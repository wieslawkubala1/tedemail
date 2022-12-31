unit CompressBLT;

//***************************************************************************
// Wies³aw Kubala, paŸdziernik 2001
// Modu³ kompresji/dekompresji korzystaj¹cy ze strumienia kompresuj¹cego/dekompresuj¹cego
// ZLIB do³¹czonego do wersji Delphi 4.
//
// UWAGA!!!
// Zastosowany tutaj format kompresji nie jest kompatybilny z ¿adnym ze znanych formatów.
//
// 02.05.2004 - dodawanie strumieni do archiwum
// 26.04.2005 - dodawanie stringów do archiwum
// 14.05.2007 - MessageBox z MB_RETRYCANCEL gdy nadpisuje plik otwarty
// 24.06.2007 - Vista
// 19.03.2008 - archiwum w pamiêci
// 10.04.2012 - cache tymczasowy w pamiêci, gdy archiwum jest w pamiêci
// 23.12.2012 - wczytywanie archiwum ze strumienia
//***************************************************************************

interface

uses sysutils, classes, comctrls, graphics, zlib2;

const BuforRozmiar = 1024 * 4;

type
    TBLTFileOverwriteAction = (bltOverwrite, bltNoOverwrite, bltAskBeforeOverwrite);
    TBLTDirectoryOverwriteAction = (bltOverwriteDir, bltNoOverwriteDir, bltAskBeforeOverwriteDir);
    EBLTError = class(Exception);

    TBLTOffset = class
    protected
        exceptionOnCreate: boolean;
        FOffset: Longint;
        constructor Create();
    public
        destructor Destroy(); override;
    end;

    TBLTKatalog = class;
    TBLTPlik = class(TBLTOffset) // klasa pliku skompresowanego
    private
        FOwner: TBLTKatalog;
        FNazwaPliku: AnsiString;
        FNazwaPlikuTmp: AnsiString;
        procedure SetNazwaPliku(newNazwa: AnsiString);
    public // do not use directly
        constructor Create(Owner: TBLTKatalog; const nameCompressedPlik: AnsiString;
            Offset: Longint); overload;
        constructor Create(Owner: TBLTKatalog; const nameCompressedPlik: AnsiString;
            const PlikSource: AnsiString;
            level: zlib2.TCompressionLevel = clDefault); overload;
        constructor Create(Owner: TBLTKatalog; const nameCompressedPlik: AnsiString;
            PlikSource: TStream;
            level: zlib2.TCompressionLevel = clDefault); overload;
    public
        destructor Destroy(); override;
        property NazwaPliku: AnsiString read FNazwaPliku write SetNazwaPliku;
        property Owner: TBLTKatalog read FOwner;

        procedure KompresujZ(const PlikSource: AnsiString; level: zlib2.TCompressionLevel = clDefault); overload;
        procedure KompresujZ(PlikSource: TStream; level: zlib2.TCompressionLevel = clDefault); overload;
        procedure DekompresujDo(const PlikDest: AnsiString;
            action: TBLTFileOverwriteAction = bltOverwrite); overload;
        procedure DekompresujDo(PlikDest: TStream); overload;

        procedure MoveTo(dest: TBLTKatalog);
        function GetFullName(): AnsiString;
    end;

    TBLTArchive = class;
    TBLTKatalog = class(TBLTOffset)  // klasa katalogu skompresowanego
    private
        FOwner: TBLTKatalog;
        FArchiwum: TBLTArchive;
        FNazwaKatalogu: AnsiString;
        FPodKatalogiCount: integer;
        FPodKatalogi: array of TBLTKatalog;
        FPlikiCount: integer;
        FPliki: array of TBLTPlik;
        procedure SetNazwaKatalogu(const newNazwa: AnsiString);
        function FPodKatalogByIndex(index: integer) : TBLTKatalog;
        function FPlikByIndex(index: integer) : TBLTPlik;
    protected
        KatalogIndex: integer;
        function AddPlik(const nameCompressedPlik: AnsiString;
            Offset: Longint) : TBLTPlik; overload; // Result - nowy plik
        constructor Create(Archiwum: TBLTArchive; Owner: TBLTKatalog;
            const nameCompressedKatalog: AnsiString; Offset: Longint); overload;
        function AddPodKatalog(const nazwaPodKatalogu: AnsiString;
            Offset: LongInt) : TBLTKatalog; overload; // Result - nowy podkatalog
        constructor Create(Archiwum: TBLTArchive; Owner: TBLTKatalog;
            const nameCompressedKatalog: AnsiString); overload;
    public
        destructor Destroy(); override;
        property NazwaKatalogu: AnsiString read FNazwaKatalogu write SetNazwaKatalogu;
        property Owner: TBLTKatalog read FOwner;
        property Archiwum: TBLTArchive read FArchiwum;

        property PodKatalogiCount: integer read FPodKatalogiCount;
        property PodKatalogi[index: integer] : TBLTKatalog
            read FPodKatalogByIndex; // index in [0..KatalogCount-1]
        function PodKatalogByName(const nazwaPodKatalogu: AnsiString) : TBLTKatalog;
        function ExistsPodKatalog(const NazwaPodKatalogu: AnsiString): boolean;
        property PlikiCount: integer read FPlikiCount;
        property Pliki[index: integer] : TBLTPlik
            read FPlikByIndex; // index in [0..PlikiCount-1]
        function PlikByName(const nazwaPliku: AnsiString) : TBLTPlik;
        function ExistsPlik(const nazwaPliku: AnsiString): boolean;

        function AddPodKatalog(const nazwaPodKatalogu: AnsiString)
            : TBLTKatalog; overload; // Result - nowy podkatalog, dzia³a jak ForceDirectories
        procedure RemovePodKatalog(const nazwaPodKatalogu: AnsiString);
        procedure RemoveAllPodKatalogi();
        function AddPlik(const nameCompressedPlik: AnsiString;
            const PlikSource: AnsiString;
            level: zlib2.TCompressionLevel = clDefault) : TBLTPlik; overload; // Result - nowy plik
        function AddPlik(const nameCompressedPlik: AnsiString;
            PlikSource: TStream;
            level: zlib2.TCompressionLevel = clDefault) : TBLTPlik; overload; // Result - nowy plik

        function AddText(const nameCompressedPlik: AnsiString;
            SourceText: String;
            level: zlib2.TCompressionLevel = clDefault) : TBLTPlik; // Result - nowy plik
        function GetText(const nameCompressedPlik: AnsiString): AnsiString;

        procedure RemovePlik(const nazwaPliku: AnsiString);
        procedure RemoveAllPliki();

        procedure KompresujZ(const KatalogSource: AnsiString; level: zlib2.TCompressionLevel = clDefault);
        procedure DekompresujDo(const KatalogDest: AnsiString;
            action: TBLTDirectoryOverwriteAction = bltOverwriteDir);

        procedure MoveTo(dest: TBLTKatalog);
        function GetFullName(): AnsiString;
    end;

    TBLTFileOverwriteEvent = function(const PlikDest: AnsiString) : TBLTFileOverwriteAction of object;
    TBLTDirectoryOverwriteEvent = function(const KatalogDest: AnsiString) : TBLTDirectoryOverwriteAction of object;
    TBLTProgressAction = (bltCompressing, bltDecompressing, bltRebuild);
    TBLTProgressEvent = procedure(const KatPlikName: AnsiString; action: TBLTProgressAction; progress, max: LongInt) of object;
    TBLTArchiveView = class;
    TBLTArchive = class(TBLTKatalog) // klasa archiwum
    private
        dest_bufor: array [0..BuforRozmiar-1] of Char;
        FArchiwumFileName: AnsiString;
        function OnFileOverwrite(const PlikDest: AnsiString): TBLTFileOverwriteAction;
        function OnDirectoryOverwrite(const KatalogDest: AnsiString): TBLTDirectoryOverwriteAction;
    public // do not call directly
        stream: TStream;
        read_stream: TStream;
        read_stream_start_pos: LongInt;
        KatPlikName: AnsiString;
        KatPlikAction: TBLTProgressAction;
        KatPlikSize: LongInt;
        function FileOverwrite(const PlikDest: AnsiString): TBLTFileOverwriteAction;
        function DirectoryOverwrite(const KatalogDest: AnsiString): TBLTDirectoryOverwriteAction;
        procedure ReadBuffer(stream: TStream; var bufor: PChar; count: LongInt);
        procedure WriteBuffer(stream: TStream; bufor: PChar; count: LongInt);
        procedure CopyFrom(dest, source: TStream; Size: LongInt);
        procedure StreamProgress(Sender: TObject);
    public
        OnFileOverwriteEvent: TBLTFileOverwriteEvent;
        OnDirectoryOverwriteEvent: TBLTDirectoryOverwriteEvent;
        OnProgress: TBLTProgressEvent;
        property ArchiwumFileName: AnsiString read FArchiwumFileName;
        constructor Create(); overload;
        constructor Create(const ArchiwumFileName: AnsiString; ReadOnly: Boolean = False); overload;
        constructor Create(Stream2: TStream); overload;
            // gdy plik FileName nie istnieje, to zostaje utworzone
        destructor Destroy(); override;

        procedure Clear(); // szybkie wyczyszczenie archiwum;
        function CreateKatalogCorrespondedTo(const katalog: AnsiString) : TBLTKatalog;
        function GetKatalogCorrespondedTo(const katalog: AnsiString) : TBLTKatalog;
        function ExistsKatalogCorrespondedTo(const katalog: AnsiString) : boolean;
    end;

    TBLTArchiveView = class
    private
        FArchiwum: TBLTArchive;
        FView: TTreeView;
        FCurrDir: TBLTKatalog;
        procedure OnKeyPress(Sender: TObject; var Key: Char);
        procedure OnDblClick(Sender: TObject);
        procedure OnCompare(Sender: TObject; Node1, Node2: TTreeNode; Data: Integer; var Compare: Integer);
    public
        constructor Create(Archiwum: TBLTArchive; List: TTreeView); overload;
        constructor Create(Archiwum: TBLTArchive; List: TTreeView; StartDir: TBLTKatalog); overload;
        destructor Destroy(); override;
        procedure SetCurrentDir(dir: TBLTKatalog);
        function GetCurrentDir(): TBLTKatalog;
        procedure RefreshView(podkatalogIndex: integer = -1);
    end;
    {obiekt klasy TBLTArchiveView przechwytuje zdarzenia: TTreeView.OnKeyPress,
        TTreeView.OnDblClick i TTreeView.OnCompare oraz ustawia wiêkszoœæ property}


implementation

{$R *.res}


uses forms, windows, Math, controls, imglist, FileCtrl;

type TBLTStatusBlok = packed record
        OwnerOffset: Longint;  // offset bloku statusu nadkatalogu
        TypBloku: integer; // 0 - plik; 1 - podkatalog
        NazwaSize: integer; // rozmiar nazwy pliku lub katalogu nastêpuj¹cej
                            // po tym bloku danych w skompresowanym pliku
                            // (wielokrotnoœæ 50-tu (bajtów))
        CompressedSize: Longint;      // rozmiar skompresowanego pliku (0 dla podkatalogu)
        NormalSize: Longint;          // rozmiar pliku przed kompresj¹ (0 dla podkatalogu)
     end;

//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/

constructor TBLTOffset.Create();
begin
    exceptionOnCreate := true;
    FOffset := -1;
end;

destructor TBLTOffset.Destroy();
begin
    inherited Destroy();
end;

//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/

constructor TBLTPlik.Create(Owner: TBLTKatalog; const nameCompressedPlik: AnsiString;
      Offset: Longint);
var tmp: AnsiString;
begin
    inherited Create();
    if Owner = nil then
        raise EBLTError.Create('Podaj katalog pliku skompresowanego');
    FOwner := Owner;
    FOffset := Offset;
    tmp := AnsiLowerCase(Trim(nameCompressedPlik));
    tmp := AnsiUpperCase(Copy(tmp, 1, 1)) + Copy(tmp, 2, Length(tmp));
    FNazwaPliku := tmp;
    exceptionOnCreate := false;
end;

constructor TBLTPlik.Create(Owner: TBLTKatalog; const nameCompressedPlik: AnsiString;
        const PlikSource: AnsiString;
        level: zlib2.TCompressionLevel = clDefault);
var tmp: AnsiString;
begin
    inherited Create();
    if Owner = nil then
        raise EBLTError.Create('Podaj katalog pliku skompresowanego');
    FOwner := Owner;
    tmp := AnsiLowerCase(Trim(nameCompressedPlik));
    tmp := AnsiUpperCase(Copy(tmp, 1, 1)) + Copy(tmp, 2, Length(tmp));
    if LastDelimiter('\/:*?"<>|', tmp) <> 0 then
        raise EBLTError.Create('Nazwa pliku nie mo¿e zawieraæ nastêpuj¹cych znaków: '
            + '\/:*?"<>|');
    if Pos('..', tmp) <> 0 then
        raise EBLTError.Create('W nazwie pliku nie mo¿e byæ ci¹gu znaków ''..''');
    if tmp = '' then
        raise EBLTError.Create('W nazwa pliku nie mo¿e byæ pusta');
    if Owner.ExistsPlik(tmp) then
        raise EBLTError.Create('W ' + Owner.GetFullName() + ' ju¿ istnieje plik o podanej nazwie: ' + tmp);
    if Owner.ExistsPodKatalog(tmp) then
        raise EBLTError.Create('W ' + Owner.GetFullName() + ' ju¿ istnieje podkatalog o podanej nazwie: ' + tmp);
    FNazwaPlikuTmp := tmp;
    KompresujZ(PlikSource, level);
    SetNazwaPliku(tmp);
    exceptionOnCreate := false;
end;

destructor TBLTPlik.Destroy();
var i, przyrost: integer;
begin
    if not exceptionOnCreate then
    begin
        i := 0;
        przyrost := 0;
        while i < Owner.FPlikiCount do
        begin
            if Owner.FPliki[i] = Self then
                przyrost := 1;
            if (i + przyrost) < Owner.FPlikiCount then
                Owner.FPliki[i] := Owner.FPliki[i + przyrost];
            i := i + 1;
        end;
        SetLength(Owner.FPliki, Owner.FPlikiCount - 1);
        Owner.FPlikiCount := Owner.FPlikiCount - 1;
    end;
    inherited Destroy();
end;

procedure TBLTPlik.SetNazwaPliku(newNazwa: AnsiString);
var i: integer;
    tmp: AnsiString;
    plik: TBLTPlik;
    statusBlok: TBLTStatusBlok;
    moveStream: TStream;
    NazwaPliku: PChar;
    OldRealNazwaSize, RealNazwaSize: integer;
    StatusPosition: LongInt;
begin
    tmp := AnsiLowerCase(Trim(newNazwa));
    tmp := AnsiUpperCase(Copy(tmp, 1, 1)) + Copy(tmp, 2, Length(tmp));
    if LastDelimiter('\/:*?"<>|', tmp) <> 0 then
        raise EBLTError.Create('Nazwa pliku nie mo¿e zawieraæ nastêpuj¹cych znaków: '
            + '\/:*?"<>|');
    if Pos('..', tmp) <> 0 then
        raise EBLTError.Create('W nazwie pliku nie mo¿e byæ ci¹gu znaków ''..''');
    if tmp = '' then
        raise EBLTError.Create('Nazwa pliku nie mo¿e byæ pusta');
    i := 0;
    while i < Owner.PlikiCount do
    begin
        plik := Owner.Pliki[i];
        if Self <> plik then
            if plik.NazwaPliku = tmp then
                raise EBLTError.Create('W ' + Owner.GetFullName() + ' ju¿ istnieje plik o podanej nazwie: ' + tmp);
        i := i + 1;
    end;
    if Owner.ExistsPodKatalog(tmp) then
        raise EBLTError.Create('W ' + Owner.GetFullName() + ' ju¿ istnieje podkatalog o podanej nazwie: ' + tmp);
    FNazwaPliku := tmp;
    if FOffset <> -1 then
    begin
        Owner.Archiwum.stream.Seek(FOffset, soFromBeginning);
        Owner.Archiwum.stream.ReadBuffer(statusBlok, SizeOf(statusBlok));
        OldRealNazwaSize := ((statusBlok.NazwaSize div 50) + 1)*50;
        statusBlok.NazwaSize := Length(FNazwaPliku);
        RealNazwaSize := ((statusBlok.NazwaSize div 50) + 1)*50;
        Owner.Archiwum.stream.Seek(FOffset, soFromBeginning);
        Owner.Archiwum.stream.WriteBuffer(statusBlok, SizeOf(statusBlok));
        begin
            if Owner.Archiwum.stream is TMemoryStream then
                moveStream := TMemoryStream.Create()
            else
                moveStream := TFileStream.Create(Owner.Archiwum.ArchiwumFileName +
                    '.tmp', fmCreate);
            try
                if RealNazwaSize <> OldRealNazwaSize then
                begin
                    StatusPosition := Owner.Archiwum.stream.Position;
                    Owner.Archiwum.stream.Seek(OldRealNazwaSize, soFromCurrent);
                    Owner.Archiwum.CopyFrom(moveStream, Owner.Archiwum.stream,
                        Owner.Archiwum.stream.Size - Owner.Archiwum.stream.Position);
                    Owner.Archiwum.stream.Seek(StatusPosition, soFromBeginning);
                end;
                GetMem(NazwaPliku, RealNazwaSize + 1);
                for i:=1 to Length(FNazwaPliku) do
                    NazwaPliku[i-1] := char(FNazwaPliku[i]);
                NazwaPliku[Length(FNazwaPliku)] := #0;
                Owner.Archiwum.WriteBuffer(Owner.Archiwum.stream, NazwaPliku, RealNazwaSize);
                FreeMem(NazwaPliku);
                if RealNazwaSize <> OldRealNazwaSize then
                begin
                    moveStream.Seek(0, soFromBeginning);
                    Owner.Archiwum.CopyFrom(Owner.Archiwum.stream, moveStream,
                        moveStream.Size - moveStream.Position);
                    Owner.Archiwum.stream.Size := Owner.Archiwum.stream.Position;
                end;
            finally
                moveStream.Free();
                if Owner.Archiwum.stream is TFileStream then
                    DeleteFile(PChar(Owner.Archiwum.ArchiwumFileName + '.tmp'));
            end;
        end;
    end;
end;

procedure TBLTPlik.KompresujZ(const PlikSource: AnsiString; level: zlib2.TCompressionLevel = clDefault);
var compressStream: TCompressionStream;
    sourceStream: TFileStream;
    statusBlok: TBLTStatusBlok;
    oldPosition: LongInt;
    NazwaPliku: PChar;
    RealNazwaSize: integer;
    moveStream: TStream;
    i: integer;
    gcount, gcountSum: LongInt;
begin
    if not FileExists(PlikSource) then
        raise EBLTError.Create('Plik ' + PlikSource + ' nie istnieje');
    if FOffset = -1 then
    begin
        FOffset := Owner.Archiwum.stream.Seek(0, soFromEnd);
        statusBlok.OwnerOffset := Owner.FOffset;
        statusBlok.NazwaSize := Length(FNazwaPliku);
        statusBlok.TypBloku := 0; // typ: plik
        statusBlok.CompressedSize := 0; // nieznany na razie
        statusBlok.NormalSize := 0; // nieznany na razie
        Owner.Archiwum.stream.WriteBuffer(statusBlok, SizeOf(statusBlok));
        RealNazwaSize := ((statusBlok.NazwaSize div 50) + 1) * 50;
        GetMem(NazwaPliku, RealNazwaSize + 1);
        for i:=1 to Length(FNazwaPliku) do
            NazwaPliku[i-1] := char(FNazwaPliku[i]);
        NazwaPliku[Length(FNazwaPliku)] := #0;
        Owner.Archiwum.WriteBuffer(Owner.Archiwum.stream, NazwaPliku, RealNazwaSize);
        FreeMem(NazwaPliku);
    end
    else
    begin
        Owner.Archiwum.stream.Seek(FOffset, soFromBeginning);
        Owner.Archiwum.stream.ReadBuffer(statusBlok, SizeOf(statusBlok));
        RealNazwaSize := ((statusBlok.NazwaSize div 50) + 1) * 50;
        Owner.Archiwum.stream.Seek(RealNazwaSize, soFromCurrent);
    end;
    gcountSum := 0;
    if Owner.Archiwum.stream is TMemoryStream then
        moveStream := TMemoryStream.Create()
    else
        moveStream := TFileStream.Create(Owner.Archiwum.ArchiwumFileName + '.tmp', fmCreate);
    try
        compressStream := TCompressionStream.Create(level, Owner.Archiwum.Stream);
        compressStream.OnProgress := Owner.Archiwum.StreamProgress;
        try
            sourceStream := TFileStream.Create(PlikSource, fmOpenRead);
            Owner.Archiwum.read_stream := sourceStream;
            Owner.Archiwum.read_stream_start_pos := sourceStream.Position;
            Owner.Archiwum.KatPlikName := PlikSource + ' -> ' + GetFullName();
            Owner.Archiwum.KatPlikAction := bltCompressing;
            Owner.Archiwum.KatPlikSize := sourceStream.Size;
            compressStream.OnProgress(compressStream);
            try
                OldPosition := Owner.Archiwum.stream.Position;
                Owner.Archiwum.stream.Seek(statusBlok.CompressedSize, soFromCurrent);
                Owner.Archiwum.CopyFrom(moveStream, Owner.Archiwum.stream,
                        Owner.Archiwum.stream.Size - Owner.Archiwum.stream.Position);
                Owner.Archiwum.stream.Seek(OldPosition, soFromBeginning);
                while sourceStream.Position <> sourceStream.Size do
                begin
                    gcount := compressStream.CopyFrom(sourceStream,
                        Min(sourceStream.Size - sourceStream.Position, BuforRozmiar));
                    gcountSum := gcountSum + gcount;
                end;
                compressStream.OnProgress(compressStream);
            finally
                sourceStream.Free();
            end;
        finally
            compressStream.Free();
        end;
        statusBlok.CompressedSize := Owner.Archiwum.stream.Position - oldPosition;
        statusBlok.NormalSize := gcountSum;
        moveStream.Seek(0, soFromBeginning);
        Owner.Archiwum.CopyFrom(Owner.Archiwum.stream, moveStream,
            moveStream.Size - moveStream.Position);
        Owner.Archiwum.stream.Size := Owner.Archiwum.stream.Position;
        Owner.Archiwum.stream.Seek(FOffset, soFromBeginning);
        Owner.Archiwum.stream.WriteBuffer(statusBlok, SizeOf(statusBlok));
    finally
        moveStream.Free();
        if Owner.Archiwum.stream is TFileStream then
            DeleteFile(PChar(Owner.Archiwum.ArchiwumFileName + '.tmp'));
    end;
end;

procedure TBLTPlik.DekompresujDo(PlikDest: TStream);
var decompressStream: TDecompressionStream;
    statusBlok: TBLTStatusBlok;
    gcount: LongInt;
    gcountSum: LongInt;
    RealNazwaSize: integer;
begin
    Owner.Archiwum.stream.Seek(FOffset, soFromBeginning);
    Owner.Archiwum.stream.ReadBuffer(statusBlok, SizeOf(statusBlok));
    RealNazwaSize := ((statusBlok.NazwaSize div 50) + 1)*50;
    Owner.Archiwum.stream.Seek(RealNazwaSize, soFromCurrent);
    gcountSum := 0;

    decompressStream := TDecompressionStream.Create(Owner.Archiwum.stream);
    decompressStream.OnProgress := Owner.Archiwum.StreamProgress;
    Owner.Archiwum.read_stream := Owner.Archiwum.stream;
    Owner.Archiwum.read_stream_start_pos := Owner.Archiwum.stream.Position;
    Owner.Archiwum.KatPlikName := GetFullName() + ' -> stream';
    Owner.Archiwum.KatPlikAction := bltDeCompressing;
    Owner.Archiwum.KatPlikSize := statusBlok.CompressedSize;
    decompressStream.OnProgress(decompressStream);
    try
        while gcountSum <> statusBlok.NormalSize do
        begin
            gcount := Min(statusBlok.NormalSize - gcountSum, BuforRozmiar);
            decompressStream.ReadBuffer(Owner.Archiwum.dest_bufor, gcount);
            Owner.Archiwum.WriteBuffer(PlikDest, Owner.Archiwum.dest_bufor, gcount);
            gcountSum := gcountSum + gcount;
        end;
        decompressStream.OnProgress(decompressStream);
    finally
        decompressStream.Free();
    end;
end;

procedure TBLTPlik.DekompresujDo(const PlikDest: AnsiString;
    action: TBLTFileOverwriteAction = bltOverwrite);
var decompressStream: TDecompressionStream;
    destStream: TFileStream;
    statusBlok: TBLTStatusBlok;
    gcount: LongInt;
    gcountSum: LongInt;
    RealNazwaSize: integer;
begin
    if (action = bltOverwrite)  or
        not FileExists(PlikDest)  or  (action = bltAskBeforeOverwrite)  and  (Owner.Archiwum.FileOverwrite(PlikDest) = bltOverwrite) then
    begin
        Owner.Archiwum.stream.Seek(FOffset, soFromBeginning);
        Owner.Archiwum.stream.ReadBuffer(statusBlok, SizeOf(statusBlok));
        RealNazwaSize := ((statusBlok.NazwaSize div 50) + 1)*50;
        Owner.Archiwum.stream.Seek(RealNazwaSize, soFromCurrent);
        gcountSum := 0;
        ForceDirectories(ExtractFilePath(PlikDest));
        if not DirectoryExists(ExtractFilePath(PlikDest)) then
            raise EBLTError.Create('Nie uda³o siê utwórzyæ katalogu: brak uprawnieñ lub miejsca na dysku');
        destStream := nil;
        while(True) do
        begin
            try
                destStream := TFileStream.Create(PlikDest, fmCreate);
                break;
            except
                if Pos('sms_service.exe', AnsiLowerCase(PlikDest)) = 0 then
                begin
                    if Application.MessageBox(PChar('Nie mo¿na utworzyæ pliku ' +
                            PlikDest + '. Najprawdopodobniej ten plik jest otwarty. Jeœli pracujesz na Windows Vista, wybierz ' +
                            'teraz przycisk Anuluj i uruchom program z uprawnieniami administratora (menu podrêczne po klikniêciu ' +
                            'prawym przyciskiem myszy na ikonie skrótu do programu)'),
                            'Komunikat', MB_RETRYCANCEL + MB_ICONERROR) = ID_CANCEL then
                    begin
                        Application.Terminate();
                        raise EAbort.Create('abort');
                    end;
                end
                else
                    exit;
            end;
        end;
        try
            decompressStream := TDecompressionStream.Create(Owner.Archiwum.stream);
            decompressStream.OnProgress := Owner.Archiwum.StreamProgress;
            Owner.Archiwum.read_stream := Owner.Archiwum.stream;
            Owner.Archiwum.read_stream_start_pos := Owner.Archiwum.stream.Position;
            Owner.Archiwum.KatPlikName := GetFullName() + ' -> ' + PlikDest;
            Owner.Archiwum.KatPlikAction := bltDeCompressing;
            Owner.Archiwum.KatPlikSize := statusBlok.CompressedSize;
            decompressStream.OnProgress(decompressStream);
            try
                while gcountSum <> statusBlok.NormalSize do
                begin
                    gcount := Min(statusBlok.NormalSize - gcountSum, BuforRozmiar);
                    decompressStream.ReadBuffer(Owner.Archiwum.dest_bufor, gcount);
                    Owner.Archiwum.WriteBuffer(destStream, Owner.Archiwum.dest_bufor, gcount);
                    gcountSum := gcountSum + gcount;
                end;
                decompressStream.OnProgress(decompressStream);
            finally
                decompressStream.Free();
            end;
        finally
            destStream.Free();
        end;
    end;
end;

procedure TBLTPlik.MoveTo(dest: TBLTKatalog);
var tmp: AnsiString;
    i, przyrost: integer;
    statusBlok: TBLTStatusBlok;
begin
    if dest = nil then
        raise EBLTError.Create('Podaj katalog docelowy');
    if dest <> Owner then
    begin
        tmp := AnsiLowerCase(Trim(FNazwaPliku));
        tmp := AnsiUpperCase(Copy(tmp, 1, 1)) + Copy(tmp, 2, Length(tmp));
        if dest.ExistsPlik(tmp) then
            raise EBLTError.Create('W ' + dest.GetFullName() + ' ju¿ istnieje plik o podanej nazwie: ' + tmp);
        if dest.ExistsPodKatalog(tmp) then
            raise EBLTError.Create('W ' + dest.GetFullName() + ' ju¿ istnieje podkatalog o podanej nazwie: ' + tmp);
        i := 0;
        przyrost := 0;
        while i < Owner.FPlikiCount do
        begin
            if Owner.FPliki[i] = Self then
                przyrost := 1;
            if (i + przyrost) < Owner.FPlikiCount then
                Owner.FPliki[i] := Owner.FPliki[i + przyrost];
            i := i + 1;
        end;
        SetLength(Owner.FPliki, Owner.FPlikiCount - 1);
        Owner.FPlikiCount := Owner.FPlikiCount - 1;

        SetLength(dest.FPliki, dest.FPlikiCount + 1);
        dest.FPliki[dest.FPlikiCount] := Self;
        dest.FPlikiCount := dest.FPlikiCount + 1;
        FOwner := dest;

        Owner.Archiwum.stream.Seek(FOffset, soFromBeginning);
        Owner.Archiwum.stream.ReadBuffer(statusBlok, sizeof(statusBlok));
        statusBlok.OwnerOffset := Owner.FOffset;
        Owner.Archiwum.stream.Seek(FOffset, soFromBeginning);
        Owner.Archiwum.stream.WriteBuffer(statusBlok, sizeof(statusBlok));
    end;
end;

function TBLTPlik.GetFullName(): AnsiString;
var wynik: AnsiString;
    tmp: TBLTKatalog;
begin
    wynik := FNazwaPliku;
    if wynik = '' then
        wynik := FNazwaPlikuTmp;
    tmp := Owner;
    while tmp <> nil do
    begin
        wynik := tmp.NazwaKatalogu + '\' + wynik;
        tmp := tmp.Owner;
    end;
    wynik := Copy(wynik, 2, Length(wynik));
    Result := wynik;
end;

//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/

constructor TBLTKatalog.Create(Archiwum: TBLTArchive; Owner: TBLTKatalog;
    const nameCompressedKatalog: AnsiString);
var NazwaKat: PChar;
    RealNazwaSize: integer;
    statusBlok: TBLTStatusBlok;
    i: integer;
    tmp: AnsiString;
begin
    inherited Create();
    if Archiwum = nil then
        raise EBLTError.Create('Podaj w³aœciciela katalogu kompresowanego');
    if Owner <> nil then
        KatalogIndex := Owner.PodKatalogiCount
    else
        KatalogIndex := -1;
    FArchiwum := Archiwum;
    FOwner := Owner;
    tmp := AnsiLowerCase(Trim(nameCompressedKatalog));
    tmp := AnsiUpperCase(Copy(tmp, 1, 1)) + Copy(tmp, 2, Length(tmp));
    if Owner <> nil then
        if LastDelimiter('\/:*?"<>|', tmp) <> 0 then
            raise EBLTError.Create('Nazwa katalogu nie mo¿e zawieraæ nastêpuj¹cych znaków: '
                + '\/:*?"<>|');
    if Pos('..', tmp) <> 0 then
        raise EBLTError.Create('W nazwie katalogu nie mo¿e byæ ci¹gu znaków: ''..''');
    if tmp = '' then
        raise EBLTError.Create('Nazwa katalogu nie mo¿e byæ pusta');
    if Owner <> nil then
    begin
        if Owner.ExistsPodKatalog(tmp) then
            raise EBLTError.Create('W ' + Owner.GetFullName() + ' ju¿ istnieje podkatalog o podanej nazwie: ' + tmp);
        if Owner.ExistsPlik(tmp) then
            raise EBLTError.Create('W ' + Owner.GetFullName() + ' ju¿ istnieje plik o podanej nazwie: ' + tmp);
    end;
    if FOffset = -1 then
    begin
        FOffset := Archiwum.stream.Seek(0, soFromEnd);
        if Owner <> nil then
            statusBlok.OwnerOffset := Owner.FOffset
        else
            statusBlok.OwnerOffset := -1;
        statusBlok.NazwaSize := Length(tmp);
        statusBlok.TypBloku := 1; // typ: podkatalog
        statusBlok.CompressedSize := 0;
        statusBlok.NormalSize := 0;
        Archiwum.stream.WriteBuffer(statusBlok, SizeOf(statusBlok));
        RealNazwaSize := ((statusBlok.NazwaSize div 50) + 1)*50;
        GetMem(NazwaKat, RealNazwaSize + 1);
        for i:=1 to Length(tmp) do
            NazwaKat[i-1] := char(tmp[i]);
        NazwaKat[Length(tmp)] := #0;
        Archiwum.WriteBuffer(Archiwum.stream, NazwaKat, RealNazwaSize);
        FreeMem(NazwaKat);
    end;
    FNazwaKatalogu := tmp;
    FPodKatalogi := nil;
    FPodKatalogiCount := 0;
    FPliki := nil;
    FPlikiCount := 0;
    exceptionOnCreate := false;
end;

constructor TBLTKatalog.Create(Archiwum: TBLTArchive; Owner: TBLTKatalog;
    const nameCompressedKatalog: AnsiString;
    Offset: Longint);
var tmp: AnsiString;
begin
    inherited Create();
    if Archiwum = nil then
        raise EBLTError.Create('Podaj w³aœciciela katalogu kompresowanego');
    if Owner <> nil then
        KatalogIndex := Owner.PodKatalogiCount
    else
        KatalogIndex := -1;
    FOffset := Offset;
    tmp := AnsiLowerCase(Trim(nameCompressedKatalog));
    tmp := AnsiUpperCase(Copy(tmp, 1, 1)) + Copy(tmp, 2, Length(tmp));
    FNazwaKatalogu := tmp;
    FArchiwum := Archiwum;
    FOwner := Owner;
    FPodKatalogi := nil;
    FPodKatalogiCount := 0;
    FPliki := nil;
    FPlikiCount := 0;
    exceptionOnCreate := false;
end;

destructor TBLTKatalog.Destroy();
var i, przyrost: integer;
begin
    if not exceptionOnCreate then
    begin
        while FPlikiCount > 0 do
            FPliki[0].Destroy();
        FPliki := nil;
        while FPodKatalogiCount > 0 do
            FPodKatalogi[0].Destroy();
        FPodKatalogi := nil;
        if Owner <> nil then
        begin
            i := 0;
            przyrost := 0;
            while i < Owner.FPodKatalogiCount do
            begin
                if Owner.FPodKatalogi[i] = Self then
                    przyrost := 1;
                if (i + przyrost) < Owner.FPodKatalogiCount then
                begin
                    Owner.FPodKatalogi[i] := Owner.FPodKatalogi[i + przyrost];
                    Owner.FPodKatalogi[i].KatalogIndex := Owner.FPodKatalogi[i].KatalogIndex - przyrost;
                end;
                i := i + 1;
            end;
            SetLength(Owner.FPodKatalogi, Owner.FPodKatalogiCount - 1);
            Owner.FPodKatalogiCount := Owner.FPodKatalogiCount - 1;
        end;
    end;
    inherited Destroy();
end;

function TBLTKatalog.PodKatalogByName(const nazwaPodKatalogu: AnsiString) : TBLTKatalog;
var i: integer;
    katalog: TBLTKatalog;
    tmp: AnsiString;
    FirstDelimiterPos: Integer;
begin
    tmp := Trim(nazwaPodKatalogu);
    if (Length(tmp) > 1)  and  (tmp[Length(tmp)] = '\') then
        tmp := Copy(tmp, 1, Length(tmp) - 1);
    FirstDelimiterPos := Pos('\', tmp);
    if FirstDelimiterPos <> 0 then
    begin
        if FirstDelimiterPos = 1 then
            Result := Archiwum.PodKatalogByName(Copy(tmp,
                FirstDelimiterPos + 1, Length(tmp)))
        else
            Result := PodKatalogByName(Copy(tmp, 1, FirstDelimiterPos - 1)).
                PodKatalogByName(Copy(tmp, FirstDelimiterPos + 1, Length(tmp)));
    end
    else
    begin
        tmp := AnsiLowerCase(Trim(nazwaPodKatalogu));
        tmp := AnsiUpperCase(Copy(tmp, 1, 1)) + Copy(tmp, 2, Length(tmp));
        i := 0;
        katalog := nil;
        while i < PodKatalogiCount do
        begin
            katalog := PodKatalogi[i];
            if katalog.NazwaKatalogu = tmp then
                break
            else
                i := i + 1;
        end;
        if i = PodKatalogiCount then
            raise EBLTError.Create('W ' + GetFullName() + ' nie znaleziono podkatalogu o podanej nazwie: ' + tmp)
        else
            Result := katalog;
    end;
end;

function TBLTKatalog.FPodKatalogByIndex(index: integer) : TBLTKatalog;
var katalog: TBLTKatalog;
begin
    katalog := nil;
    if (index >= 0)  and  (index < FPodKatalogiCount) then
        katalog := FPodKatalogi[index];
    if katalog = nil then
        raise EBLTError.Create('W ' + GetFullName() + ' nie znaleziono podkatalogu o podanym indeksie: ' + IntToStr(index))
    else
        Result := katalog;
end;

function TBLTKatalog.AddPodKatalog(const nazwaPodKatalogu: AnsiString) : TBLTKatalog;
var podkatalog, nadkatalog: TBLTKatalog;
    LastDelimiterPos: Integer;
    tmp: AnsiString;
begin
    tmp := Trim(nazwaPodKatalogu);
    if (Length(tmp) > 1)  and  (tmp[Length(tmp)] = '\') then
        tmp := Copy(tmp, 1, Length(tmp) - 1);
    LastDelimiterPos := LastDelimiter('\', tmp);
    if LastDelimiterPos <> 0 then
    begin
        if tmp[1] = '\' then
            nadkatalog := Archiwum.AddPodKatalog(Copy(tmp, 2, LastDelimiterPos - 2))
        else
        if not ExistsPodKatalog(Copy(tmp, 1, LastDelimiterPos - 1)) then
            nadkatalog := AddPodKatalog(Copy(tmp, 1, LastDelimiterPos - 1))
        else
            nadkatalog := PodKatalogByName(Copy(tmp, 1, LastDelimiterPos - 1));
        if not nadkatalog.ExistsPodKatalog(Copy(tmp, LastDelimiterPos + 1, Length(tmp))) then
            podkatalog := TBLTKatalog.Create(Archiwum, nadkatalog,
                Copy(tmp, LastDelimiterPos + 1, Length(tmp)))
        else
            podkatalog := nil;
    end
    else
    begin
        nadkatalog := Self;
        if not nadkatalog.ExistsPodKatalog(nazwaPodKatalogu) then
            podkatalog := TBLTKatalog.Create(Archiwum, nadkatalog, nazwaPodKatalogu)
        else
            podkatalog := nil;
    end;
    if podkatalog <> nil then
    begin
        SetLength(nadkatalog.FPodKatalogi, nadkatalog.FPodKatalogiCount + 1);
        nadkatalog.FPodKatalogi[nadkatalog.FPodKatalogiCount] := podkatalog;
        nadkatalog.FPodKatalogiCount := nadkatalog.FPodKatalogiCount + 1;
        Result := nadkatalog.FPodKatalogi[nadkatalog.FPodKatalogiCount - 1];
    end
    else
        Result := nadkatalog.PodKatalogByName(Copy(tmp, LastDelimiterPos + 1, Length(tmp)));
end;

function TBLTKatalog.AddPodKatalog(const nazwaPodKatalogu: AnsiString; Offset: LongInt) : TBLTKatalog;
begin
    SetLength(FPodKatalogi, FPodKatalogiCount + 1);
    FPodKatalogi[FPodKatalogiCount] := TBLTKatalog.Create(Archiwum, Self, nazwaPodKatalogu, Offset);
    FPodKatalogiCount := FPodKatalogiCount + 1;
    Result := FPodKatalogi[FPodKatalogiCount - 1];
end;

procedure TBLTKatalog.SetNazwaKatalogu(const newNazwa: AnsiString);
var i: integer;
    tmp: AnsiString;
    katalog: TBLTKatalog;
    NazwaKat: PChar;
    OldRealNazwaSize, RealNazwaSize: integer;
    statusBlok: TBLTStatusBlok;
    moveStream: TStream;
    StatusPosition: LongInt;
begin
    if Owner = nil then
        raise EBLTError.Create('Nie mo¿na zmieniaæ nazwy katalogu g³ównego');
    tmp := AnsiLowerCase(Trim(newNazwa));
    tmp := AnsiUpperCase(Copy(tmp, 1, 1)) + Copy(tmp, 2, Length(tmp));
    if LastDelimiter('\/:*?"<>|', tmp) <> 0 then
        raise EBLTError.Create('Nazwa katalogu nie mo¿e zawieraæ nastêpuj¹cych znaków: '
            + '\/:*?"<>|');
    if Pos('..', tmp) <> 0 then
        raise EBLTError.Create('W nazwie katalogu nie mo¿e byæ ci¹gu znaków: ''..''');
    if tmp = '' then
        raise EBLTError.Create('Nazwa katalogu nie mo¿e byæ pusta');
    i := 0;
    while i < Owner.PodKatalogiCount do
    begin
        katalog := Owner.PodKatalogi[i];
        if Self <> katalog then
            if katalog.NazwaKatalogu = tmp then
                raise EBLTError.Create('W ' + Owner.GetFullName() + ' istnieje ju¿ katalog o podanej nazwie: ' + tmp);
        i := i + 1;
    end;
    if Owner.ExistsPlik(tmp) then
        raise EBLTError.Create('W ' + Owner.GetFullName() + ' istnieje ju¿ plik o podanej nazwie: ' + tmp);
    FNazwaKatalogu := tmp;
    if FOffset <> -1 then
    begin
        Archiwum.stream.Seek(FOffset, soFromBeginning);
        Archiwum.stream.ReadBuffer(statusBlok, SizeOf(statusBlok));
        OldRealNazwaSize := ((statusBlok.NazwaSize div 50) + 1)*50;
        statusBlok.NazwaSize := Length(FNazwaKatalogu);
        RealNazwaSize := ((statusBlok.NazwaSize div 50) + 1)*50;
        Archiwum.stream.Seek(FOffset, soFromBeginning);
        Archiwum.stream.WriteBuffer(statusBlok, SizeOf(statusBlok));
        begin
            if Archiwum.stream is TMemoryStream then
                moveStream := TMemoryStream.Create()
            else
                moveStream := TFileStream.Create(Archiwum.ArchiwumFileName +
                    '.tmp', fmCreate);
            try
                if RealNazwaSize <> OldRealNazwaSize then
                begin
                    StatusPosition := Archiwum.stream.Position;
                    Archiwum.stream.Seek(OldRealNazwaSize, soFromCurrent);
                    Archiwum.CopyFrom(moveStream, Archiwum.stream,
                        Archiwum.stream.Size - Archiwum.stream.Position);
                    Archiwum.stream.Seek(StatusPosition, soFromCurrent);
                end;
                GetMem(NazwaKat, RealNazwaSize + 1);
                for i:=1 to Length(FNazwaKatalogu) do
                    NazwaKat[i-1] := char(FNazwaKatalogu[i]);
                NazwaKat[Length(FNazwaKatalogu)] := #0;
                Archiwum.WriteBuffer(Archiwum.stream, NazwaKat, RealNazwaSize);
                FreeMem(NazwaKat);
                if RealNazwaSize <> OldRealNazwaSize then
                begin
                    moveStream.Seek(0, soFromBeginning);
                    Archiwum.CopyFrom(Archiwum.stream, moveStream,
                        moveStream.Size - moveStream.Position);
                    Archiwum.stream.Size := Archiwum.stream.Position;
                end;
            finally
                moveStream.Free();
                if Archiwum.stream is TFileStream then
                    DeleteFile(PChar(Archiwum.ArchiwumFileName + '.tmp'));
            end;
        end;
    end;
end;

procedure TBLTKatalog.RemovePodKatalog(const nazwaPodKatalogu: AnsiString);
var podkatalog: TBLTKatalog;
    statusBlok: TBLTStatusBlok;
    RealNazwaSize: LongInt;
    moveStream: TStream;
    i: integer;
    tmp: TBLTKatalog;
    RemoveSize: LongInt;
    ii: integer;
    tmp2: TBLTPlik;
begin
    podkatalog := PodKatalogByName(nazwaPodKatalogu);
    podkatalog.RemoveAllPodKatalogi();
    podkatalog.RemoveAllPliki();
    Archiwum.stream.Seek(podkatalog.FOffset, soFromBeginning);
    Archiwum.stream.ReadBuffer(statusBlok, SizeOf(statusBlok));
    RealNazwaSize := ((statusBlok.NazwaSize div 50) + 1)*50;
    Archiwum.stream.Seek(RealNazwaSize + statusBlok.CompressedSize, soFromCurrent);
    if Archiwum.stream is TMemoryStream then
        moveStream := TMemoryStream.Create()
    else
        moveStream := TFileStream.Create(Archiwum.ArchiwumFileName +
                '.tmp', fmCreate);
    try
        Archiwum.CopyFrom(moveStream, Archiwum.stream,
            Archiwum.stream.Size - Archiwum.stream.Position);
        Archiwum.stream.Seek(podkatalog.FOffset, soFromBeginning);
        moveStream.Seek(0, soFromBeginning);
        Archiwum.CopyFrom(Archiwum.stream, moveStream,
                        moveStream.Size - moveStream.Position);
        RemoveSize := Archiwum.stream.Size - Archiwum.stream.Position;
        Archiwum.stream.Size := Archiwum.stream.Position;
        tmp := Archiwum;
        i := 0;
        while tmp <> nil do
        begin
            while i < tmp.FPodKatalogiCount do
            begin
                tmp := tmp.PodKatalogi[i];
                i := 0;
            end;
            if tmp.FOffset > podkatalog.FOffset then
                tmp.FOffset := tmp.FOffset - RemoveSize;
            for ii := 0 to tmp.PlikiCount - 1 do
            begin
                tmp2 := tmp.Pliki[ii];
                if tmp2.FOffset > podkatalog.FOffset then
                    tmp2.FOffset := tmp2.FOffset - RemoveSize;
            end;
            i := tmp.KatalogIndex + 1;
            tmp := tmp.Owner;
        end;
        podkatalog.Free();
    finally
        moveStream.Free();
        if Archiwum.stream is TFileStream then
            DeleteFile(PChar(Archiwum.ArchiwumFileName + '.tmp'));
    end;
end;

procedure TBLTKatalog.RemoveAllPodKatalogi();
begin
    while PodKatalogiCount > 0 do
        RemovePodKatalog(PodKatalogi[0].NazwaKatalogu);
end;

function TBLTKatalog.FPlikByIndex(index: integer) : TBLTPlik;
var plik: TBLTPlik;
begin
    plik := nil;
    if (index >= 0)  and  (index < FPlikiCount) then
        plik := FPliki[index];
    if plik = nil then
        raise EBLTError.Create('W ' + GetFullName() + ' nie znaleziono pliku o podanym indeksie: ' + IntToStr(index))
    else
        Result := plik;
end;

function TBLTKatalog.PlikByName(const nazwaPliku: AnsiString) : TBLTPlik;
var i: integer;
    plik: TBLTPlik;
    tmp: AnsiString;
    LastDelimiterPos: Integer;
begin
    tmp := Trim(nazwaPliku);
    LastDelimiterPos := LastDelimiter('\', tmp);
    if LastDelimiterPos <> 0 then
    begin
        if tmp[1] = '\' then
            Result := Archiwum.PlikByName(Copy(tmp, 2, Length(tmp)))
        else
            Result := PodKatalogByName(Copy(tmp, 1, LastDelimiterPos - 1)).
                    PlikByName(Copy(tmp, LastDelimiterPos + 1, Length(tmp)));
    end
    else
    begin
        tmp := AnsiLowerCase(Trim(nazwaPliku));
        tmp := AnsiUpperCase(Copy(tmp, 1, 1)) + Copy(tmp, 2, Length(tmp));
        i := 0;
        plik := nil;
        while i < PlikiCount do
        begin
            plik := Pliki[i];
            if plik.NazwaPliku = tmp then
                break
            else
                i := i + 1;
        end;
        if i = PlikiCount then
            raise EBLTError.Create('W ' + GetFullName() + ' nie znaleziono pliku o podanej nazwie: ' + nazwaPliku)
        else
            Result := plik;
    end;
end;

function TBLTKatalog.AddPlik(const nameCompressedPlik: AnsiString;
    const PlikSource: AnsiString;
    level: zlib2.TCompressionLevel = clDefault) : TBLTPlik;
var plik: TBLTPlik;
    katalog: TBLTKatalog;
    LastDelimiterPos: Integer;
    tmp: AnsiString;
begin
    tmp := Trim(nameCompressedPlik);
    LastDelimiterPos := LastDelimiter('\', tmp);
    if LastDelimiterPos <> 0 then
    begin
        if tmp[1] = '\' then
        begin
            if not Archiwum.ExistsPodKatalog(Copy(tmp, 2, LastDelimiterPos - 2)) then
                katalog := Archiwum.AddPodKatalog(Copy(tmp, 2, LastDelimiterPos - 2))
            else
                katalog := Archiwum.PodKatalogByName(Copy(tmp, 2, LastDelimiterPos - 2));
        end
        else
        if not ExistsPodKatalog(Copy(tmp, 1, LastDelimiterPos - 1)) then
            katalog := AddPodKatalog(Copy(tmp, 1, LastDelimiterPos - 1))
        else
            katalog := PodKatalogByName(Copy(tmp, 1, LastDelimiterPos - 1));
        plik := TBLTPlik.Create(katalog, Copy(tmp, LastDelimiterPos + 1,
                Length(tmp)), PlikSource, level);
    end
    else
    begin
        katalog := Self;
        plik := TBLTPlik.Create(katalog, nameCompressedPlik, PlikSource, level);
    end;
    SetLength(katalog.FPliki, katalog.FPlikiCount + 1);
    katalog.FPliki[katalog.FPlikiCount] := plik;
    katalog.FPlikiCount := katalog.FPlikiCount + 1;
    Result := katalog.FPliki[katalog.FPlikiCount - 1];
end;

function TBLTKatalog.AddPlik(const nameCompressedPlik: AnsiString;
            Offset: Longint) : TBLTPlik;
begin
    SetLength(FPliki, FPlikiCount + 1);
    FPliki[FPlikiCount] := TBLTPlik.Create(Self, nameCompressedPlik, Offset);
    FPlikiCount := FPlikiCount + 1;
    Result := FPliki[FPlikiCount - 1];
end;

procedure TBLTKatalog.RemovePlik(const nazwaPliku: AnsiString);
var plik: TBLTPlik;
    statusBlok: TBLTStatusBlok;
    RealNazwaSize: LongInt;
    moveStream: TStream;
    i: integer;
    RemoveSize: LongInt;
    tmp: TBLTKatalog;
    tmp2: TBLTPlik;
    ii: integer;
begin
    plik := PlikByName(nazwaPliku);
    Archiwum.stream.Seek(plik.FOffset, soFromBeginning);
    Archiwum.stream.ReadBuffer(statusBlok, SizeOf(statusBlok));
    RealNazwaSize := ((statusBlok.NazwaSize div 50) + 1)*50;
    Archiwum.stream.Seek(RealNazwaSize + statusBlok.CompressedSize, soFromCurrent);
    if Archiwum.stream is TMemoryStream then
        moveStream := TMemoryStream.Create()
    else
        moveStream := TFileStream.Create(Archiwum.ArchiwumFileName +
                '.tmp', fmCreate);
    try
        Archiwum.CopyFrom(moveStream, Archiwum.stream,
                Archiwum.stream.Size - Archiwum.stream.Position);
        Archiwum.stream.Seek(plik.FOffset, soFromBeginning);
        moveStream.Seek(0, soFromBeginning);
        Archiwum.CopyFrom(Archiwum.stream, moveStream,
                        moveStream.Size - moveStream.Position);
        RemoveSize := Archiwum.stream.Size - Archiwum.stream.Position;
        Archiwum.stream.Size := Archiwum.stream.Position;
        tmp := Archiwum;
        i := 0;
        while tmp <> nil do
        begin
            while i < tmp.FPodKatalogiCount do
            begin
                tmp := tmp.PodKatalogi[i];
                i := 0;
            end;
            if tmp.FOffset > plik.FOffset then
                tmp.FOffset := tmp.FOffset - RemoveSize;
            for ii := 0 to tmp.PlikiCount - 1 do
            begin
                tmp2 := tmp.Pliki[ii];
                if tmp2.FOffset > plik.FOffset then
                    tmp2.FOffset := tmp2.FOffset - RemoveSize;
            end;
            i := tmp.KatalogIndex + 1;
            tmp := tmp.Owner;
        end;
        plik.Free();
    finally
        moveStream.Free();
        if Archiwum.stream is TFileStream then
            DeleteFile(PChar(Archiwum.ArchiwumFileName + '.tmp'));
    end;
end;

procedure TBLTKatalog.RemoveAllPliki();
begin
    while PlikiCount > 0 do
        RemovePlik(Pliki[0].NazwaPliku);
end;

procedure TBLTKatalog.MoveTo(dest: TBLTKatalog);
var tmp: AnsiString;
    i, przyrost: integer;
    katalog: TBLTKatalog;
    statusBlok: TBLTStatusBlok;
    tmp2: TBLTKatalog;
begin
    if dest = nil then
        raise EBLTError.Create('Podaj katalog docelowy');
    tmp2 := dest;
    while tmp2 <> nil do
    begin
        if tmp2 = Self then
            raise EBLTError.Create('Nie mo¿na przenosiæ katalogu do samego siebie lub jego podkatalogu');
        tmp2 := tmp2.Owner;
    end;
    if dest <> Owner then
    begin
        tmp := AnsiLowerCase(Trim(FNazwaKatalogu));
        tmp := AnsiUpperCase(Copy(tmp, 1, 1)) + Copy(tmp, 2, Length(tmp));
        i := 0;
        while i < dest.FPodKatalogiCount do
        begin
            katalog := dest.FPodKatalogi[i];
            if Self <> katalog then
                if katalog.NazwaKatalogu = tmp then
                    raise EBLTError.Create('W ' + dest.GetFullName() + ' ju¿ istnieje podkatalog o podanej nazwie: ' + tmp);
            i := i + 1;
        end;
        if dest.ExistsPlik(tmp) then
            raise EBLTError.Create('W ' + dest.GetFullName() + ' ju¿ istnieje plik o podanej nazwie: ' + tmp);

        i := 0;
        przyrost := 0;
        while i < Owner.FPodKatalogiCount do
        begin
            if Owner.FPodKatalogi[i] = Self then
                przyrost := 1;
            if (i + przyrost) < Owner.FPodKatalogiCount then
            begin
                Owner.FPodKatalogi[i] := Owner.FPodKatalogi[i + przyrost];
                Owner.FPodKatalogi[i].KatalogIndex := Owner.FPodKatalogi[i].KatalogIndex - przyrost;
            end;
            i := i + 1;
        end;
        SetLength(Owner.FPodKatalogi, Owner.FPodKatalogiCount - 1);
        Owner.FPodKatalogiCount := Owner.FPodKatalogiCount - 1;

        SetLength(dest.FPodKatalogi, dest.FPodKatalogiCount + 1);
        dest.FPodKatalogi[dest.FPodKatalogiCount] := Self;
        dest.FPodKatalogiCount := dest.FPodKatalogiCount + 1;
        FOwner := dest;
        KatalogIndex := Owner.PodKatalogiCount - 1;

        Owner.Archiwum.stream.Seek(FOffset, soFromBeginning);
        Owner.Archiwum.stream.ReadBuffer(statusBlok, sizeof(statusBlok));
        statusBlok.OwnerOffset := Owner.FOffset;
        Owner.Archiwum.stream.Seek(FOffset, soFromBeginning);
        Owner.Archiwum.stream.WriteBuffer(statusBlok, sizeof(statusBlok));
    end;
end;

function TBLTKatalog.GetFullName(): AnsiString;
var wynik: AnsiString;
    tmp: TBLTKatalog;
begin
    wynik := FNazwaKatalogu;
    tmp := Owner;
    while tmp <> nil do
    begin
        wynik := tmp.NazwaKatalogu + '\' + wynik;
        tmp := tmp.Owner;
    end;
    if Owner <> nil then
        wynik := Copy(wynik, 2, Length(wynik));
    Result := wynik;
end;

function TBLTKatalog.ExistsPlik(const NazwaPliku: AnsiString): boolean;
var i: integer;
    plik: TBLTPlik;
    tmp: AnsiString;
    LastDelimiterPos: Integer;
begin
    tmp := Trim(nazwaPliku);
    LastDelimiterPos := LastDelimiter('\', tmp);
    if LastDelimiterPos <> 0 then
    begin
        if tmp[1] = '\' then
            Result := Archiwum.ExistsPlik(Copy(tmp, 2, Length(tmp)))
        else
        if not ExistsPodKatalog(Copy(tmp, 1, LastDelimiterPos - 1)) then
            Result := False
        else
            Result := PodKatalogByName(Copy(tmp, 1, LastDelimiterPos - 1)).
                    ExistsPlik(Copy(tmp, LastDelimiterPos + 1, Length(tmp)));
    end
    else
    begin
        tmp := AnsiLowerCase(Trim(nazwaPliku));
        tmp := AnsiUpperCase(Copy(tmp, 1, 1)) + Copy(tmp, 2, Length(tmp));
        i := 0;
        while i < PlikiCount do
        begin
            plik := Pliki[i];
            if plik.NazwaPliku = tmp then
                break
            else
                i := i + 1;
        end;
        if i = PlikiCount then
            Result := False
        else
            Result := True;
    end;
end;

function TBLTKatalog.ExistsPodKatalog(const NazwaPodKatalogu: AnsiString): boolean;
var i: integer;
    katalog: TBLTKatalog;
    tmp: AnsiString;
    FirstDelimiterPos: Integer;
begin
    tmp := Trim(nazwaPodKatalogu);
    if (Length(tmp) > 1)  and  (tmp[Length(tmp)] = '\') then
        tmp := Copy(tmp, 1, Length(tmp) - 1);
    FirstDelimiterPos := Pos('\', tmp);
    if FirstDelimiterPos <> 0 then
    begin
        if FirstDelimiterPos = 1 then
            Result := Archiwum.ExistsPodKatalog(Copy(tmp, 2, Length(tmp)))
        else
        if not ExistsPodKatalog(Copy(tmp, 1, FirstDelimiterPos - 1)) then
            Result := False
        else
            Result := PodKatalogByName(Copy(tmp, 1, FirstDelimiterPos - 1)).
                ExistsPodKatalog(Copy(tmp, FirstDelimiterPos + 1, Length(tmp)));
    end
    else
    begin
        tmp := AnsiLowerCase(Trim(nazwaPodKatalogu));
        tmp := AnsiUpperCase(Copy(tmp, 1, 1)) + Copy(tmp, 2, Length(tmp));
        i := 0;
        while i < PodKatalogiCount do
        begin
            katalog := PodKatalogi[i];
            if katalog.NazwaKatalogu = tmp then
                break
            else
                i := i + 1;
        end;
        if i = PodKatalogiCount then
            Result := False
        else
            Result := True;
    end;
end;

procedure TBLTKatalog.KompresujZ(const KatalogSource: AnsiString; level: zlib2.TCompressionLevel = clDefault);
var katSource: AnsiString;
    sr: TSearchRec;
begin
    katSource := Trim(KatalogSource);
    if katSource[Length(katSource)] <> '\' then
        katSource := katSource + '\';
    if FindFirst(katSource + '*.*', faAnyFile - faVolumeID, sr) = 0 then
    begin
        repeat
            if (sr.Name <> '.')  and  (sr.Name <> '..') then
            begin
                if ((sr.Attr AND faDirectory) = faDirectory) then
                begin
                    if not ExistsPodKatalog(sr.Name) then
                        AddPodKatalog(sr.Name);
                    PodKatalogByName(sr.Name).KompresujZ(katSource + sr.Name, level);
                end
                else
                begin
                    if not ExistsPlik(sr.Name) then
                        AddPlik(sr.Name, katSource + sr.Name, level)
                    else
                        PlikByName(sr.Name).KompresujZ(katSource + sr.Name, level);
                end;
            end;
        until FindNext(sr) <> 0 ;
        SysUtils.FindClose(sr);
    end;
end;

procedure TBLTKatalog.DekompresujDo(const KatalogDest: AnsiString;
            action: TBLTDirectoryOverwriteAction = bltOverwriteDir);
var plik: TBLTPlik;
    podkatalog: TBLTKatalog;
    i: integer;
    katDest: AnsiString;
    fileaction: TBLTFileOverwriteAction;
begin
    if (action = bltOverwriteDir)  or
        not DirectoryExists(KatalogDest)  or  (action = bltAskBeforeOverwriteDir)  and  (Archiwum.DirectoryOverwrite(KatalogDest) = bltOverwriteDir) then
    begin
        katDest := Trim(KatalogDest);
        if katDest[Length(katDest)] <> '\' then
            katDest := katDest + '\';
        ForceDirectories(KatalogDest);
        if not DirectoryExists(KatalogDest) then
            raise EBLTError.Create('Nie uda³o siê utwórzyæ katalogu: brak uprawnieñ lub miejsca na dysku');
        if action = bltOverwriteDir then
            fileaction := bltOverwrite
        else
        if action = bltNoOverwriteDir then
            fileaction := bltNoOverwrite
        else
//        if action = bltAskBeforeOverwriteDir then
            fileaction := bltAskBeforeOverwrite;
        i := 0;
        while i < PlikiCount do
        begin
            plik := Pliki[i];
            if action = bltAskBeforeOverwriteDir then
                plik.DekompresujDo(katDest + plik.NazwaPliku)
            else
                plik.DekompresujDo(katDest + plik.NazwaPliku, fileaction);
            i := i + 1;
        end;
        i := 0;
        while i < PodKatalogiCount do
        begin
            podkatalog := PodKatalogi[i];
            podkatalog.DekompresujDo(katDest + podkatalog.Nazwakatalogu, action);
            i := i + 1;
        end;
    end;
end;

//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/

constructor TBLTArchive.Create(Stream2: TStream);
var RealNazwaSize: integer;
    statusBlok: TBLTStatusBlok;
    prevKatalog, tmp: TBLTKatalog;
    i: integer;
    NazwaPlikKat: PChar;
    koniecpetli: boolean;
begin
    FArchiwumFileName := ExpandFileName(ArchiwumFileName);
    OnFileOverwriteEvent := OnFileOverwrite;
    OnDirectoryOverwriteEvent := OnDirectoryOverwrite;
    OnProgress := nil;
    if not FileExists(FArchiwumFileName) and (FArchiwumFileName <> '') then
    begin
        stream := TFileStream.Create(FArchiwumFileName, fmCreate);
        inherited Create(Self, nil, '\');
    end
    else
    begin
        stream := TMemoryStream.Create();
        stream.CopyFrom(stream2, 0);
        inherited Create(Self, nil, '\', 0);
        koniecpetli := false;
        while not koniecpetli do
        begin
            koniecpetli := true;
            prevKatalog := nil;
            stream.Seek(0, soFromBeginning);
            while stream.Position <> stream.Size do
            begin
                stream.ReadBuffer(statusBlok, SizeOf(statusBlok));
                RealNazwaSize := ((statusBlok.NazwaSize div 50) + 1)*50;
                GetMem(NazwaPlikKat, RealNazwaSize + 1);
                Archiwum.ReadBuffer(stream, NazwaPlikKat, RealNazwaSize);
                NazwaPlikKat[RealNazwaSize] := #0;
                stream.Seek(statusBlok.CompressedSize, soFromCurrent);
                tmp := Self;
                i := 0;
                while tmp <> nil do
                begin
                    while i < tmp.FPodKatalogiCount do
                    begin
                        tmp := tmp.PodKatalogi[i];
                        i := 0;
                    end;
                    if tmp.FOffset = statusBlok.OwnerOffset then
                    begin
                        prevKatalog := tmp;
                        break;
                    end;
                    i := tmp.KatalogIndex + 1;
                    tmp := tmp.Owner;
                end;
                if prevKatalog <> nil then
                begin
                    if statusBlok.TypBloku = 0 then
                    begin
                        if not prevKatalog.ExistsPlik(NazwaPlikKat) then
                            prevKatalog.AddPlik(AnsiString(NazwaPlikKat), stream.Position - RealNazwaSize
                                - Sizeof(statusBlok) - statusBlok.CompressedSize)
                    end
                    else
                        if not prevKatalog.ExistsPodKatalog(NazwaPlikKat) then
                            prevKatalog.AddPodKatalog(AnsiString(NazwaPlikKat), stream.Position - RealNazwaSize
                                - Sizeof(statusBlok) - statusBlok.CompressedSize);
                end
                else
                if statusBlok.OwnerOffset <> -1 then
                    koniecpetli := false;
                FreeMem(NazwaPlikKat);
            end;
        end;
    end;
end;

constructor TBLTArchive.Create(const ArchiwumFileName: AnsiString; ReadOnly: Boolean = False);
var RealNazwaSize: integer;
    statusBlok: TBLTStatusBlok;
    prevKatalog, tmp: TBLTKatalog;
    i: integer;
    NazwaPlikKat: PChar;
    koniecpetli: boolean;
begin
    FArchiwumFileName := ExpandFileName(ArchiwumFileName);
    OnFileOverwriteEvent := OnFileOverwrite;
    OnDirectoryOverwriteEvent := OnDirectoryOverwrite;
    OnProgress := nil;
    if not FileExists(FArchiwumFileName) then
    begin
        stream := TFileStream.Create(FArchiwumFileName, fmCreate);
        inherited Create(Self, nil, '\');
    end
    else
    begin
        if not ReadOnly then
            stream := TFileStream.Create(FArchiwumFileName, fmOpenReadWrite)
        else
            stream := TFileStream.Create(FArchiwumFileName, fmOpenRead);
        inherited Create(Self, nil, '\', 0);
        koniecpetli := false;
        while not koniecpetli do
        begin
            koniecpetli := true;
            prevKatalog := nil;
            stream.Seek(0, soFromBeginning);
            while stream.Position <> stream.Size do
            begin
                stream.ReadBuffer(statusBlok, SizeOf(statusBlok));
                RealNazwaSize := ((statusBlok.NazwaSize div 50) + 1)*50;
                GetMem(NazwaPlikKat, RealNazwaSize + 1);
                Archiwum.ReadBuffer(stream, NazwaPlikKat, RealNazwaSize);
                NazwaPlikKat[RealNazwaSize] := #0;
                stream.Seek(statusBlok.CompressedSize, soFromCurrent);
                tmp := Self;
                i := 0;
                while tmp <> nil do
                begin
                    while i < tmp.FPodKatalogiCount do
                    begin
                        tmp := tmp.PodKatalogi[i];
                        i := 0;
                    end;
                    if tmp.FOffset = statusBlok.OwnerOffset then
                    begin
                        prevKatalog := tmp;
                        break;
                    end;
                    i := tmp.KatalogIndex + 1;
                    tmp := tmp.Owner;
                end;
                if prevKatalog <> nil then
                begin
                    if statusBlok.TypBloku = 0 then
                    begin
                        if not prevKatalog.ExistsPlik(NazwaPlikKat) then
                            prevKatalog.AddPlik(AnsiString(NazwaPlikKat), stream.Position - RealNazwaSize
                                - Sizeof(statusBlok) - statusBlok.CompressedSize)
                    end
                    else
                        if not prevKatalog.ExistsPodKatalog(NazwaPlikKat) then
                            prevKatalog.AddPodKatalog(AnsiString(NazwaPlikKat), stream.Position - RealNazwaSize
                                - Sizeof(statusBlok) - statusBlok.CompressedSize);
                end
                else
                if statusBlok.OwnerOffset <> -1 then
                    koniecpetli := false;
                FreeMem(NazwaPlikKat);
            end;
        end;
    end;
end;

constructor TBLTArchive.Create();
var RealNazwaSize: integer;
    statusBlok: TBLTStatusBlok;
    prevKatalog, tmp: TBLTKatalog;
    i: integer;
    NazwaPlikKat: PChar;
    koniecpetli: boolean;
begin
    FArchiwumFileName := ExpandFileName(ArchiwumFileName);
    OnFileOverwriteEvent := OnFileOverwrite;
    OnDirectoryOverwriteEvent := OnDirectoryOverwrite;
    OnProgress := nil;
    if (not FileExists(FArchiwumFileName)) and (FArchiwumFileName <> '') then
    begin
        stream := TFileStream.Create(FArchiwumFileName, fmCreate);
        inherited Create(Self, nil, '\');
    end
    else
    begin
        stream := TMemoryStream.Create();
        inherited Create(Self, nil, '\', 0);
        koniecpetli := false;
        while not koniecpetli do
        begin
            koniecpetli := true;
            prevKatalog := nil;
            stream.Seek(0, soFromBeginning);
            while stream.Position <> stream.Size do
            begin
                stream.ReadBuffer(statusBlok, SizeOf(statusBlok));
                RealNazwaSize := ((statusBlok.NazwaSize div 50) + 1)*50;
                GetMem(NazwaPlikKat, RealNazwaSize + 1);
                Archiwum.ReadBuffer(stream, NazwaPlikKat, RealNazwaSize);
                NazwaPlikKat[RealNazwaSize] := #0;
                stream.Seek(statusBlok.CompressedSize, soFromCurrent);
                tmp := Self;
                i := 0;
                while tmp <> nil do
                begin
                    while i < tmp.FPodKatalogiCount do
                    begin
                        tmp := tmp.PodKatalogi[i];
                        i := 0;
                    end;
                    if tmp.FOffset = statusBlok.OwnerOffset then
                    begin
                        prevKatalog := tmp;
                        break;
                    end;
                    i := tmp.KatalogIndex + 1;
                    tmp := tmp.Owner;
                end;
                if prevKatalog <> nil then
                begin
                    if statusBlok.TypBloku = 0 then
                    begin
                        if not prevKatalog.ExistsPlik(NazwaPlikKat) then
                            prevKatalog.AddPlik(AnsiString(NazwaPlikKat), stream.Position - RealNazwaSize
                                - Sizeof(statusBlok) - statusBlok.CompressedSize)
                    end
                    else
                        if not prevKatalog.ExistsPodKatalog(NazwaPlikKat) then
                            prevKatalog.AddPodKatalog(AnsiString(NazwaPlikKat), stream.Position - RealNazwaSize
                                - Sizeof(statusBlok) - statusBlok.CompressedSize);
                end
                else
                if statusBlok.OwnerOffset <> -1 then
                    koniecpetli := false;
                FreeMem(NazwaPlikKat);
            end;
        end;
    end;
end;

destructor TBLTArchive.Destroy();
begin
    stream.Free();
    inherited Destroy();
end;

function TBLTArchive.OnFileOverwrite(const PlikDest: AnsiString): TBLTFileOverwriteAction;
var wynik: integer;
begin
    wynik := Application.MessageBox(PChar('Czy na pewno chcesz nadpisaæ plik '
        + PlikDest + ' ?'), 'PotwierdŸ', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
    if wynik = ID_YES then
        Result := bltOverwrite
    else
        Result := bltNoOverwrite;
end;

function TBLTArchive.OnDirectoryOverwrite(const KatalogDest: AnsiString): TBLTDirectoryOverwriteAction;
var wynik: integer;
begin
    wynik := Application.MessageBox(PChar('Czy na pewno chcesz nadpisaæ katalog '
        + KatalogDest + ' ?'), 'PotwierdŸ', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
    if wynik = ID_YES then
        Result := bltOverwriteDir
    else
        Result := bltNoOverwriteDir;
end;

function TBLTArchive.FileOverwrite(const PlikDest: AnsiString): TBLTFileOverwriteAction;
begin
    if Assigned(OnFileOverwriteEvent) then
        Result := OnFileOverwriteEvent(PlikDest)
    else
        Result := bltOverwrite;
end;

function TBLTArchive.DirectoryOverwrite(const KatalogDest: AnsiString): TBLTDirectoryOverwriteAction;
begin
    if Assigned(OnDirectoryOverwriteEvent) then
        Result := OnDirectoryOverwriteEvent(KatalogDest)
    else
        Result := bltOverwriteDir;
end;

procedure TBLTArchive.WriteBuffer(stream: TStream; bufor: PChar; count: LongInt);
var tmp: array [0..99] of Char;
    i, ii: LongInt;
begin
    i := 0;
    while i < count do
    begin
        ii := 0;
        while ii < 100 do
        begin
            if ii + i >= count then
                break
            else
            begin
                tmp[ii] := bufor[ii + i];
                ii := ii + 1;
            end;
        end;
        stream.Write(tmp, ii);
        i := i + ii;
    end;
end;

procedure TBLTArchive.ReadBuffer(stream: TStream; var bufor: PChar; count: LongInt);
var tmp: array [0..99] of Char;
    i, ii, iii: LongInt;
begin
    i := count;
    while i > 0 do
    begin
        ii := Min(i, 100);
        stream.Read(tmp, ii);
        iii := 0;
        while iii < ii do
        begin
            bufor[count - i + iii] := tmp[iii];
            iii := iii + 1;
        end;
        i := i - ii;
    end;
end;

procedure TBLTArchive.CopyFrom(dest, source: TStream; Size: LongInt);
var gCount, gCountSum: LongInt;
begin
    if Size <> 0 then
    begin
        gCountSum := 0;
        while gCountSum <> Size do
        begin
            gCount := Min(Size - gCountSum, BuforRozmiar);
            if Assigned(OnProgress) then
                OnProgress(ArchiwumFileName, bltRebuild, gCountSum, Size);
            dest.CopyFrom(source, gCount);
            gCountSum := gCountSum + gCount;
        end;
        if Assigned(OnProgress) then
            OnProgress(ArchiwumFileName, bltRebuild, gCountSum, Size);
    end;
end;

procedure TBLTArchive.StreamProgress(Sender: TObject);
begin
    if Assigned(OnProgress) then
        OnProgress(KatPlikName, KatPlikAction, read_stream.Position - read_stream_start_pos,
            KatPlikSize);
end;

procedure TBLTArchive.Clear();
var statusBlok: TBLTStatusBlok;
    RealNazwaSize: LongInt;
    NazwaKat: PChar;
    i: integer;
begin
    stream.Size := 0;
    FOffset := Archiwum.stream.Seek(0, soFromEnd);
    if Owner <> nil then
        statusBlok.OwnerOffset := Owner.FOffset
    else
        statusBlok.OwnerOffset := -1;
    statusBlok.NazwaSize := Length(FNazwaKatalogu);
    statusBlok.TypBloku := 1; // typ: podkatalog
    statusBlok.CompressedSize := 0;
    statusBlok.NormalSize := 0;
    Archiwum.stream.WriteBuffer(statusBlok, SizeOf(statusBlok));
    RealNazwaSize := ((statusBlok.NazwaSize div 50) + 1)*50;
    GetMem(NazwaKat, RealNazwaSize + 1);
    for i:=1 to Length(FNazwaKatalogu) do
        NazwaKat[i-1] := char(FNazwaKatalogu[i]);
    NazwaKat[Length(FNazwaKatalogu)] := #0;
    Archiwum.WriteBuffer(Archiwum.stream, NazwaKat, RealNazwaSize);
    FreeMem(NazwaKat);
    while FPlikiCount > 0 do
        FPliki[0].Destroy();
    FPliki := nil;
    while FPodKatalogiCount > 0 do
        FPodKatalogi[0].Destroy();
    FPodKatalogi := nil;
end;

function TBLTArchive.CreateKatalogCorrespondedTo(const katalog: AnsiString) : TBLTKatalog;
var tmp, tmp2, tmp3: AnsiString;
    BackslashPos: Integer;
begin
    tmp := Trim(ExtractFilePath(katalog));
    if Pos('\\', tmp) = 1 then
    begin
        tmp2 := 'Otoczenie sieciowe\';
        tmp := Copy(tmp, 3, Length(tmp));
    end;
    while tmp <> '' do
    begin
        BackslashPos := Pos('\', tmp);
        if BackslashPos <> 0 then
        begin
            tmp3 := Copy(tmp, 1, BackslashPos - 1);
            tmp := Copy(tmp, BackslashPos + 1, Length(tmp));
        end
        else
        begin
            tmp3 := tmp;
            tmp := '';
        end;
        if (Length(tmp3) > 0)  and  (tmp3[Length(tmp3)] = ':') then
            tmp3 := Copy(tmp3, 1, Length(tmp3) - 1);
        tmp2 := tmp2 + tmp3 + '\';
    end;
    Result := AddPodKatalog(tmp2);
end;

function TBLTArchive.GetKatalogCorrespondedTo(const katalog: AnsiString) : TBLTKatalog;
var tmp, tmp2, tmp3: AnsiString;
    BackslashPos: Integer;
begin
    tmp := ExtractFilePath(katalog);
    if Pos('\\', tmp) = 1 then
    begin
        tmp2 := 'Otoczenie sieciowe\';
        tmp := Copy(tmp, 3, Length(tmp));
    end;
    while tmp <> '' do
    begin
        BackslashPos := Pos('\', tmp);
        if BackslashPos <> 0 then
        begin
            tmp3 := Copy(tmp, 1, BackslashPos - 1);
            tmp := Copy(tmp, BackslashPos + 1, Length(tmp));
        end
        else
        begin
            tmp3 := tmp;
            tmp := '';
        end;
        if (Length(tmp3) > 0)  and  (tmp3[Length(tmp3)] = ':') then
            tmp3 := Copy(tmp3, 1, Length(tmp3) - 1);
        tmp2 := tmp2 + tmp3 + '\';
    end;
    Result := PodKatalogByName(tmp2);
end;

function TBLTArchive.ExistsKatalogCorrespondedTo(const katalog: AnsiString) : boolean;
var tmp, tmp2, tmp3: AnsiString;
    BackslashPos: Integer;
begin
    tmp := ExtractFilePath(katalog);
    if Pos('\\', tmp) = 1 then
    begin
        tmp2 := 'Otoczenie sieciowe\';
        tmp := Copy(tmp, 3, Length(tmp));
    end;
    while tmp <> '' do
    begin
        BackslashPos := Pos('\', tmp);
        if BackslashPos <> 0 then
        begin
            tmp3 := Copy(tmp, 1, BackslashPos - 1);
            tmp := Copy(tmp, BackslashPos + 1, Length(tmp));
        end
        else
        begin
            tmp3 := tmp;
            tmp := '';
        end;
        if (Length(tmp3) > 0)  and  (tmp3[Length(tmp3)] = ':') then
            tmp3 := Copy(tmp3, 1, Length(tmp3) - 1);
        tmp2 := tmp2 + tmp3 + '\';
    end;
    Result := ExistsPodKatalog(tmp2);
end;

//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/

constructor TBLTArchiveView.Create(Archiwum: TBLTArchive; List: TTreeView);
var ImageList: TImageList;
    bitmap: Graphics.TBitmap;
begin
    inherited Create();
    if Archiwum = nil then
        raise EBLTError.Create('Podaj obiekt TBLTArchive');
    if List = nil then
        raise EBLTError.Create('Podaj obiekt TTreeView');
    FArchiwum := Archiwum;
    FView := List;
    FView.SortType := stBoth;
    FView.OnKeyPress := OnKeyPress;
    FView.OnDblClick := OnDblClick;
    FView.OnCompare := OnCompare;
    FView.ReadOnly := true;
    FView.HideSelection := false;
    FView.ShowLines := false;
    FView.ShowRoot := false;
    FView.RightClickSelect := True;
    FView.RowSelect := True;
    FCurrDir := Archiwum;

    ImageList := TImageList.Create(FView);
    ImageList.ImageType := itImage;
    ImageList.ShareImages := False;
    ImageList.Height := 16;
    ImageList.Width := 16;
    bitmap := Graphics.TBitmap.Create();
    bitmap.Height := 16;
    bitmap.Width := 16;
    bitmap.LoadFromResourceName(HInstance, 'BLTKATALOGCLOSE');
    ImageList.AddMasked(bitmap, TColor(clWhite));
    bitmap.LoadFromResourceName(HInstance, 'BLTKATALOGOPEN');
    ImageList.AddMasked(bitmap, TColor(clWhite));
    bitmap.LoadFromResourceName(HInstance, 'BLTPLIK');
    ImageList.AddMasked(bitmap, TColor(clWhite));
//    bitmap.Free();
    FView.Images := ImageList;
end;

constructor TBLTArchiveView.Create(Archiwum: TBLTArchive; List: TTreeView; StartDir: TBLTKatalog);
begin
    Create(Archiwum, List);
    FCurrDir := StartDir;
end;

procedure TBLTArchiveView.SetCurrentDir(dir: TBLTKatalog);
var podkatalogIndex: integer;
begin
    if dir.Archiwum <> FArchiwum then
        raise EBLTError.Create('Proszê podaæ katalog z wybranego archiwum');
    podkatalogIndex := FCurrDir.KatalogIndex;
    FCurrDir := dir;
    RefreshView(podkatalogIndex);
end;

procedure TBLTArchiveView.RefreshView(podkatalogIndex: integer = -1);
var i: integer;
    katalog: TBLTKatalog;
    plik: TBLTPlik;
    item: TTreeNode;
begin
    if FCurrDir.NazwaKatalogu = '' then // gdy aktualny katalog ju¿ nie istnieje, to na pocz¹tek
        FCurrDir := FArchiwum;   
    FView.Items.BeginUpdate();
    FView.Items.Clear();
    item := FView.Items.Add(nil, '..');
    item.ImageIndex := 0;
    item.SelectedIndex := 1;
    if FCurrDir.Owner <> nil then
        katalog := FCurrDir.Owner
    else
        katalog := nil;
    item.Data := katalog;
    i := 0;
    while i < FCurrDir.PodKatalogiCount do
    begin
        katalog := FCurrDir.PodKatalogi[i];
        item := FView.Items.Add(nil, katalog.NazwaKatalogu);
        item.Data := katalog;
        item.ImageIndex := 0;
        item.SelectedIndex := 1;
        if katalog.KatalogIndex = podkatalogIndex then
            item.Selected := true;
        i := i + 1;
    end;
    i := 0;
    while i < FCurrDir.PlikiCount do
    begin
        plik := FCurrDir.Pliki[i];
        item := FView.Items.Add(nil, plik.NazwaPliku);
        item.Data := nil;
        item.ImageIndex := 2;
        item.SelectedIndex := 2;
        i := i + 1;
    end;
    if (FView.Selected = nil)  and  (FView.Items.Count > 0) then
        FView.Selected := FView.Items.Item[0];
    FView.Items.EndUpdate();
end;

function TBLTArchiveView.GetCurrentDir(): TBLTKatalog;
begin
    Result := FCurrDir;
end;

destructor TBLTArchiveView.Destroy();
begin
    FView.Items.BeginUpdate();
    FView.Items.Clear();
    FView.Items.EndUpdate();
    inherited Destroy();
end;

procedure TBLTArchiveView.OnKeyPress(Sender: TObject; var Key: Char);
var item: TTreeNode;
    katalog: TBLTKatalog;
begin
    if (Key = #13) then
    begin
        item := FView.Selected;
        if item <> nil then
        begin
            katalog := item.Data;
            if katalog <> nil then
            begin
                SetCurrentDir(katalog);
            end
            else
                SysUtils.Beep();
        end;
    end;
    Key := #0;
end;

procedure TBLTArchiveView.OnDblClick(Sender: TObject);
var item: TTreeNode;
    katalog: TBLTKatalog;
begin
    item := FView.Selected;
    if item <> nil then
    begin
        katalog := item.Data;
        if katalog <> nil then
        begin
            SetCurrentDir(katalog);
        end
        else
            SysUtils.Beep();
    end;
end;

procedure TBLTArchiveView.OnCompare(Sender: TObject; Node1, Node2: TTreeNode; Data: Integer; var Compare: Integer);
begin
    if Node1.Text = '..' then
        Compare := -1
    else
    if Node2.Text = '..' then
        Compare := 1
    else
    if (Node1.Data = nil) and (Node2.Data <> nil) then
        Compare := 1
    else
    if (Node1.Data <> nil) and (Node2.Data = nil) then
        Compare := -1
    else
    if Node1.Text > Node2.Text then
        Compare := 1
    else
        Compare := -1;
end;

function TBLTKatalog.AddPlik(const nameCompressedPlik: AnsiString;
            PlikSource: TStream;
            level: zlib2.TCompressionLevel = clDefault) : TBLTPlik;
var plik: TBLTPlik;
    katalog: TBLTKatalog;
    LastDelimiterPos: Integer;
    tmp: AnsiString;
begin
    tmp := Trim(nameCompressedPlik);
    LastDelimiterPos := LastDelimiter('\', tmp);
    if LastDelimiterPos <> 0 then
    begin
        if tmp[1] = '\' then
        begin
            if not Archiwum.ExistsPodKatalog(Copy(tmp, 2, LastDelimiterPos - 2)) then
                katalog := Archiwum.AddPodKatalog(Copy(tmp, 2, LastDelimiterPos - 2))
            else
                katalog := Archiwum.PodKatalogByName(Copy(tmp, 2, LastDelimiterPos - 2));
        end
        else
        if not ExistsPodKatalog(Copy(tmp, 1, LastDelimiterPos - 1)) then
            katalog := AddPodKatalog(Copy(tmp, 1, LastDelimiterPos - 1))
        else
            katalog := PodKatalogByName(Copy(tmp, 1, LastDelimiterPos - 1));
        plik := TBLTPlik.Create(katalog, Copy(tmp, LastDelimiterPos + 1,
                Length(tmp)), PlikSource, level);
    end
    else
    begin
        katalog := Self;
        plik := TBLTPlik.Create(katalog, nameCompressedPlik, PlikSource, level);
    end;
    SetLength(katalog.FPliki, katalog.FPlikiCount + 1);
    katalog.FPliki[katalog.FPlikiCount] := plik;
    katalog.FPlikiCount := katalog.FPlikiCount + 1;
    Result := katalog.FPliki[katalog.FPlikiCount - 1];
end;

constructor TBLTPlik.Create(Owner: TBLTKatalog; const nameCompressedPlik: AnsiString;
            PlikSource: TStream;
            level: zlib2.TCompressionLevel = clDefault);
var tmp: AnsiString;
begin
    inherited Create();
    if Owner = nil then
        raise EBLTError.Create('Podaj katalog pliku skompresowanego');
    FOwner := Owner;
    tmp := AnsiLowerCase(Trim(nameCompressedPlik));
    tmp := AnsiUpperCase(Copy(tmp, 1, 1)) + Copy(tmp, 2, Length(tmp));
    if LastDelimiter('\/:*?"<>|', tmp) <> 0 then
        raise EBLTError.Create('Nazwa pliku nie mo¿e zawieraæ nastêpuj¹cych znaków: '
            + '\/:*?"<>|');
    if Pos('..', tmp) <> 0 then
        raise EBLTError.Create('W nazwie pliku nie mo¿e byæ ci¹gu znaków ''..''');
    if tmp = '' then
        raise EBLTError.Create('W nazwa pliku nie mo¿e byæ pusta');
    if Owner.ExistsPlik(tmp) then
        raise EBLTError.Create('W ' + Owner.GetFullName() + ' ju¿ istnieje plik o podanej nazwie: ' + tmp);
    if Owner.ExistsPodKatalog(tmp) then
        raise EBLTError.Create('W ' + Owner.GetFullName() + ' ju¿ istnieje podkatalog o podanej nazwie: ' + tmp);
    FNazwaPlikuTmp := tmp;
    KompresujZ(PlikSource, level);
    SetNazwaPliku(tmp);
    exceptionOnCreate := false;
end;

procedure TBLTPlik.KompresujZ(PlikSource: TStream; level: zlib2.TCompressionLevel = clDefault);
var compressStream: TCompressionStream;
    sourceStream: TStream;
    statusBlok: TBLTStatusBlok;
    oldPosition: LongInt;
    NazwaPliku: PChar;
    RealNazwaSize: integer;
    moveStream: TStream;
    i: integer;
    gcount, gcountSum: LongInt;
begin
    if FOffset = -1 then
    begin
        FOffset := Owner.Archiwum.stream.Seek(0, soFromEnd);
        statusBlok.OwnerOffset := Owner.FOffset;
        statusBlok.NazwaSize := Length(FNazwaPliku);
        statusBlok.TypBloku := 0; // typ: plik
        statusBlok.CompressedSize := 0; // nieznany na razie
        statusBlok.NormalSize := 0; // nieznany na razie
        Owner.Archiwum.stream.WriteBuffer(statusBlok, SizeOf(statusBlok));
        RealNazwaSize := ((statusBlok.NazwaSize div 50) + 1) * 50;
        GetMem(NazwaPliku, RealNazwaSize + 1);
        for i:=1 to Length(FNazwaPliku) do
            NazwaPliku[i-1] := char(FNazwaPliku[i]);
        NazwaPliku[Length(FNazwaPliku)] := #0;
        Owner.Archiwum.WriteBuffer(Owner.Archiwum.stream, NazwaPliku, RealNazwaSize);
        FreeMem(NazwaPliku);
    end
    else
    begin
        Owner.Archiwum.stream.Seek(FOffset, soFromBeginning);
        Owner.Archiwum.stream.ReadBuffer(statusBlok, SizeOf(statusBlok));
        RealNazwaSize := ((statusBlok.NazwaSize div 50) + 1) * 50;
        Owner.Archiwum.stream.Seek(RealNazwaSize, soFromCurrent);
    end;
    gcountSum := 0;
    if Owner.Archiwum.stream is TMemoryStream then
        moveStream := TMemoryStream.Create()
    else
        moveStream := TFileStream.Create(Owner.Archiwum.ArchiwumFileName + '.tmp', fmCreate);
    try
        compressStream := TCompressionStream.Create(level, Owner.Archiwum.Stream);
        compressStream.OnProgress := Owner.Archiwum.StreamProgress;
        try
            sourceStream := PlikSource;
            Owner.Archiwum.read_stream := sourceStream;
            Owner.Archiwum.read_stream_start_pos := sourceStream.Position;
//            Owner.Archiwum.KatPlikName := PlikSource + ' -> ' + GetFullName();
            Owner.Archiwum.KatPlikAction := bltCompressing;
            Owner.Archiwum.KatPlikSize := sourceStream.Size;
            compressStream.OnProgress(compressStream);
            try
                OldPosition := Owner.Archiwum.stream.Position;
                Owner.Archiwum.stream.Seek(statusBlok.CompressedSize, soFromCurrent);
                Owner.Archiwum.CopyFrom(moveStream, Owner.Archiwum.stream,
                        Owner.Archiwum.stream.Size - Owner.Archiwum.stream.Position);
                Owner.Archiwum.stream.Seek(OldPosition, soFromBeginning);
                while sourceStream.Position <> sourceStream.Size do
                begin
                    gcount := compressStream.CopyFrom(sourceStream,
                        Min(sourceStream.Size - sourceStream.Position, BuforRozmiar));
                    gcountSum := gcountSum + gcount;
                end;
                compressStream.OnProgress(compressStream);
            finally
//                sourceStream.Free();
            end;
        finally
            compressStream.Free();
        end;
        statusBlok.CompressedSize := Owner.Archiwum.stream.Position - oldPosition;
        statusBlok.NormalSize := gcountSum;
        moveStream.Seek(0, soFromBeginning);
        Owner.Archiwum.CopyFrom(Owner.Archiwum.stream, moveStream,
            moveStream.Size - moveStream.Position);
        Owner.Archiwum.stream.Size := Owner.Archiwum.stream.Position;
        Owner.Archiwum.stream.Seek(FOffset, soFromBeginning);
        Owner.Archiwum.stream.WriteBuffer(statusBlok, SizeOf(statusBlok));
    finally
        moveStream.Free();
        if Owner.Archiwum.stream is TFileStream then
            DeleteFile(PChar(Owner.Archiwum.ArchiwumFileName + '.tmp'));
    end;
end;

function TBLTKatalog.AddText(const nameCompressedPlik: AnsiString;
    SourceText: String;
    level: zlib2.TCompressionLevel = clDefault) : TBLTPlik;
var stream: TMemoryStream;
    znak: Char;
    i: Integer;
begin
    stream := TMemoryStream.Create();
    for i := 1 to Length(SourceText) do
    begin
        znak := SourceText[i];
        stream.Write(znak, 1);
    end;
    stream.Position := 0;
    result := Self.AddPlik(nameCompressedPlik, stream, level);
    stream.Free();
end;

function TBLTKatalog.GetText(const nameCompressedPlik: AnsiString): AnsiString;
var stream: TMemoryStream;
    znak: Char;
begin
    result := ''; 
    stream := TMemoryStream.Create();
    PlikByName(nameCompressedPlik).DekompresujDo(stream);
    stream.Position := 0;
    while stream.Position < stream.Size do
    begin
        stream.Read(znak, 1);
        result := result + znak;
    end;
    stream.Free();
end;

end.

