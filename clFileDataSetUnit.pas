unit clFileDataSetUnit;

interface

uses DB, Classes;

type
  TDziesiecBajtow = array [0..9] of Char;

  TStreamField = class
  public
    last: array of Integer;
    value: Variant;
    FieldName: String; // readonly
    DataType: TFieldType; // readonly
    function AsString(): String;
    function AsInteger(): Integer;
    function AsDateTime(): TDateTime;
    function AsFloat(): Double;
    function IsNull(): Boolean;
    constructor Create();
  end;

  TStreamDataSet = class
  private
    fields: array of TStreamField;
    stream: TStream;
    first_record: LongInt;
    fields_count: Integer;
    Feof: Boolean;
    Fbof: Boolean;
    FRecordCount: Integer;
    FRecNo: Integer; // [1..RecordCount]
    function LoadString(): String;
    function LoadInteger(): Integer;
    function LoadDouble(): Double;
    function LoadDateTime(): TDateTime;
    procedure LoadRecord();
  public
    Active: Boolean; // readonly

    constructor Create(stream: TStream);
    destructor Destroy(); override;

    function FieldByName(field: String): TStreamField;
    function ExistField(field: String): Boolean;
    procedure Next();
    function Eof(): Boolean;
    function Bof(): Boolean;
    procedure Open();
    procedure Close();
    procedure First();
    procedure Last();
    procedure Prior();

    function RecordCount(): Integer;
    function RecNo(): Integer;

    function GetRecord(): String;
  end;

  TOnProcentLog = procedure(procent: Integer) of object;

  TOnInsertNewEvent = procedure (var dziesiatka: TDziesiecBajtow;
                                                    var stop: Boolean) of object;

  procedure SaveDatasetToStream(dataset: TDataset;
                                        var stream: TStream;
                                        event: TOnProcentLog);

  procedure SaveDziesiecBajtowToStream(event: TOnInsertNewEvent;
                                        var stream: TStream);

implementation

uses SysUtils, Variants;

function TStreamField.AsString(): String;
begin
    result := value;
end;

function TStreamField.AsInteger(): Integer;
begin
    if VarType(value) = varNull then
        result := 0
    else
        result := value;
end;

function TStreamField.AsDateTime(): TDateTime;
begin
    result := value;
end;

function TStreamField.AsFloat(): Double;
begin
    result := value;
end;

constructor TStreamDataSet.Create(stream: TStream);
begin
    inherited Create();
    Self.stream := stream;
    Active := False;
    SetLength(fields, 0);
    fbof := True;
    Open();
end;

destructor TStreamDataSet.Destroy();
begin
    Close();
    inherited Destroy();
end;

function TStreamDataSet.FieldByName(field: String): TStreamField;
var i: Integer;
begin
    result := nil;
    for i := 0 to Length(fields) - 1 do
        if LowerCase(fields[i].FieldName) = LowerCase(field) then
        begin
            result := fields[i];
            break;
        end;
    if result = nil then
        raise Exception.CreateFmt('Nie znaleziono pola %s', [field]);
end;

function TStreamDataSet.ExistField(field: String): Boolean;
var i: Integer;
begin
    result := False;
    for i := 0 to Length(fields) - 1 do
        if LowerCase(fields[i].FieldName) = LowerCase(field) then
        begin
            result := True;
            break;
        end;
end;

procedure TStreamDataSet.Next();
begin
    LoadRecord();
end;

function TStreamDataSet.Eof(): Boolean;
begin
    result := Feof;
end;

procedure TStreamDataSet.Open();
var i: Integer;
    DataType: String;
begin
    if not Active then
    begin
        stream.Position := 0;
        fields_count := LoadInteger();
        SetLength(fields, fields_count);
        for i := 0 to fields_count - 1 do
        begin
            fields[i] := TStreamField.Create();
            fields[i].FieldName := LoadString();
            DataType := LoadString();
            if DataType = 'ftString' then
                fields[i].DataType := ftString
            else
            if DataType = 'ftInteger' then
                fields[i].DataType := ftInteger
            else
            if DataType = 'ftFloat' then
                fields[i].DataType := ftFloat
            else
            if DataType = 'ftDateTime' then
                fields[i].DataType := ftDateTime
            else
            if DataType = 'ftBlob' then
                fields[i].DataType := ftBlob
            else
                raise Exception.CreateFmt('Nie obs³ugiwane', []);
        end;
        first_record := stream.Position;
        stream.Position := stream.Size - SizeOf(FRecordCount);
        stream.Read(FRecordCount, SizeOf(FRecordCount));
        stream.Position := first_record;
        First();
    end;
end;

procedure TStreamDataSet.Close();
var i: Integer;
begin
    if Active then
    begin
        for i := 0 to fields_count - 1 do
            fields[i].Free();
        SetLength(fields, 0);
    end;
end;

function TStreamDataSet.LoadString(): String;
var i: Integer;
    bufor: array [0..8000] of Char;
    size: Integer;
begin
    stream.Read(size, SizeOf(size));
    stream.Read(bufor, size);
    result := '';
    for i := 0 to size - 1 do
        result := result + bufor[i];
end;

function TStreamDataSet.LoadInteger(): Integer;
begin
    stream.Read(result, SizeOf(result));
end;

function TStreamDataSet.LoadDouble(): Double;
begin
    stream.Read(result, SizeOf(result));
end;

function TStreamDataSet.LoadDateTime(): TDateTime;
begin
    stream.Read(result, SizeOf(result));
end;

procedure TStreamDataSet.First();
begin
    stream.Position := first_record;
    FRecNo := 0;
    LoadRecord();
end;

procedure TStreamDataSet.LoadRecord();
var i: Integer;
    field: TStreamField;
    is_null: Integer;
begin
    stream.Position;
    if stream.Position < (stream.Size - SizeOf(Integer)) then
    begin
        for i := 0 to fields_count - 1 do
        begin
            field := fields[i];
            is_null := LoadInteger();
            if field.DataType = ftString then
            begin
                field.value := LoadString();
                SetLength(field.last, Length(field.last) + 1);
                field.last[Length(field.last) - 1] := Length(String(field.value));
            end
            else
            if field.DataType = ftInteger then
                field.value := LoadInteger()
            else
            if field.DataType = ftFloat then
                field.value := LoadDouble()
            else
            if field.DataType = ftDateTime then
                field.value := LoadDateTime()
            else
            if field.DataType = ftBlob then
            begin
                field.value := LoadString();
                SetLength(field.last, Length(field.last) + 1);
                field.last[Length(field.last) - 1] := Length(String(field.value));
            end
            else
                raise Exception.CreateFmt('Nie obs³ugiwane', []);
            if is_null = 1 then
                field.value := Null;
        end;
        Feof := False;
        Fbof := False;
        Inc(FRecNo);
    end
    else
        Feof := True;
end;

function TStreamField.IsNull(): Boolean;
begin
    result := (value = Null);
end;

function TStreamDataSet.RecordCount(): Integer;
begin
    result := FRecordCount;
end;

function TStreamDataSet.RecNo(): Integer;
begin
    result := FRecNo;
end;

function TStreamDataSet.GetRecord(): String;
var wynik: String;
    i: Integer;
begin
    for i := 0 to Length(fields) - 1 do
        wynik := wynik + fields[i].AsString() + '||||';
    result := wynik;
end;

procedure SaveDatasetToStream(dataset: TDataset; var stream: TStream; event: TOnProcentLog);
var i: Integer;
    value_integer: Integer;
    bufor: array [0..8000] of Char;
    field: TField;
    licznik: Integer;
    ile_rekordow: Integer;
    rec_pos: Integer;

    procedure SaveString(value: String);
    var i: Integer;
    begin
        value_integer := Length(value);
        stream.Write(value_integer, SizeOf(value_integer));
        for i := 0 to Length(value) - 1 do
            bufor[i] := value[i + 1];
        stream.Write(bufor, Length(value));
    end;
    procedure SaveInteger(value: Integer);
    begin
        stream.Write(value, SizeOf(value));
    end;
    procedure SaveDouble(value: Double);
    begin
        stream.Write(value, SizeOf(value));
    end;
    procedure SaveDateTime(value: TDateTime);
    begin
        stream.Write(value, SizeOf(value));
    end;
begin
    ile_rekordow := dataset.RecordCount;
    rec_pos := 0;
    SaveInteger(dataset.Fields.Count);
    for i := 0 to dataset.Fields.Count - 1 do
    begin
        field := dataset.Fields.Fields[i];
        SaveString(field.FieldName);
        if field.DataType = ftString then
            SaveString('ftString')
        else
        if field.DataType in [ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint] then
            SaveString('ftInteger')
        else
        if field.DataType in [ftFloat, ftCurrency, ftBCD] then
            SaveString('ftFloat')
        else
        if field.DataType in [ftDate, ftTime, ftDateTime] then
            SaveString('ftDateTime')
        else
        if field.DataType in [ftBlob] then
            SaveString('ftBlob')
        else
            raise Exception.CreateFmt('Nie obs³ugiwane', []);
    end;
    licznik := 0;
    dataset.First();
    while not dataset.Eof do
    begin
        for i := 0 to dataset.Fields.Count - 1 do
        begin
            field := dataset.Fields.Fields[i];
            if field.IsNull then
                SaveInteger(1)
            else
                SaveInteger(0);
            if field.DataType = ftString then
                SaveString(field.AsString)
            else
            if field.DataType in [ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint] then
                SaveInteger(field.AsInteger)
            else
            if field.DataType in [ftFloat, ftCurrency, ftBCD] then
                SaveDouble(field.AsFloat)
            else
            if field.DataType in [ftDate, ftTime, ftDateTime] then
                SaveDateTime(field.AsDateTime)
            else
            if field.DataType in [ftBlob] then
                SaveString(field.AsString)
            else
                raise Exception.CreateFmt('Nie obs³ugiwane', []);
        end;
        Inc(licznik);
        dataset.Next();

        Inc(rec_pos);
        if (@event) <> nil then
            event(Trunc((rec_pos * 100) / ile_rekordow));
    end;
    SaveInteger(licznik);
end;

procedure SaveDziesiecBajtowToStream(event: TOnInsertNewEvent;
                                      var stream: TStream);
var i: Integer;
    value_integer: Integer;
    bufor: array [0..8000] of Char;
    licznik: Integer;
    stop: Boolean;
    dziesiatka: TDziesiecBajtow;

    procedure SaveString(value: String);
    var i: Integer;
    begin
        value_integer := Length(value);
        stream.Write(value_integer, SizeOf(value_integer));
        for i := 0 to Length(value) - 1 do
            bufor[i] := value[i + 1];
        stream.Write(bufor, Length(value));
    end;
    procedure SaveInteger(value: Integer);
    begin
        stream.Write(value, SizeOf(value));
    end;
    procedure SaveDouble(value: Double);
    begin
        stream.Write(value, SizeOf(value));
    end;
    procedure SaveDateTime(value: TDateTime);
    begin
        stream.Write(value, SizeOf(value));
    end;
begin
    stream.Size := 0;
    SaveInteger(10);
    for i := 1 to 10 do
    begin
        SaveString('evb' + IntToStr(i));
        SaveString('ftInteger');
    end;
    licznik := 0;
    stop := False;
    event(dziesiatka, stop);
    while not stop do
    begin
        for i := 1 to 10 do
        begin
            SaveInteger(0);
            SaveInteger(Integer(dziesiatka[i - 1]));
        end;
        Inc(licznik);
        event(dziesiatka, stop);
    end;
    SaveInteger(licznik);
end;

function TStreamDataSet.Bof(): Boolean;
begin
    result := Fbof;
end;

procedure TStreamDataSet.Last();
begin
    while not Eof do
        Next();
end;

procedure TStreamDataSet.Prior();
var field: TStreamField;
    i, j: Integer;
begin
    for j := 1 to 2 do
        for i := Length(fields) - 1 downto 0 do
        begin
            field := fields[i];

            if field.DataType = ftString then
                stream.Position := stream.Position
                                        - field.last[Length(field.last) - 1]
                                        - SizeOf(Integer)
            else
            if field.DataType in [ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint] then
                stream.Position := stream.Position - SizeOf(Integer)
            else
            if field.DataType in [ftFloat, ftCurrency, ftBCD] then
                stream.Position := stream.Position - SizeOf(Double)
            else
            if field.DataType in [ftDate, ftTime, ftDateTime] then
                stream.Position := stream.Position - SizeOf(TDateTime)
            else
            if field.DataType in [ftBlob] then
                stream.Position := stream.Position
                                        - field.last[Length(field.last) - 1]
                                        - SizeOf(Integer)
            else
                raise Exception.CreateFmt('Nie obs³ugiwane', []);
            stream.Position := stream.Position - SizeOf(Integer)
        end;
    if stream.Position < first_record then
    begin
        fbof := True;
        stream.Position := first_record;
    end
    else
    begin
        LoadRecord();
        fbof := False;
        Dec(FRecNo);
        for i := Length(fields) - 1 downto 0 do
        begin
            field := fields[i];
            if field.DataType = ftString then
                SetLength(field.last, FRecNo);
        end;
    end;
end;

constructor TStreamField.Create();
begin
    inherited Create();
    SetLength(last, 0);
end;

end.

