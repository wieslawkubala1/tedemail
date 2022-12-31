unit TEDEmailUnit;

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs, DB,
  ADODB, IdTCPConnection, IdTCPClient, IdMessageClient, IdPOP3,
  IdCoder, IdCoder3to4, IdCoderUUE, IdMessage, IdBaseComponent,
  IdAntiFreezeBase, IdAntiFreeze, RxMemDS, IdHTTP, msxml, comobj, IdTCPServer,
  xmldom, XMLIntf, msxmldom, XMLDoc, IdCoderMIME, IdSMTP, clFileDataSetUnit,
  IdIOHandler, IdIOHandlerSocket, IdSSLOpenSSL, IdSocks, IdSMTPBase,
  IdCustomTCPServer, IdExplicitTLSClientServerBase, IdCoder00E, IdComponent,
    SyncObjs,

  IdException,
  IdHashCRC,
  IdStack,
  IdResourceStrings, IdAttachmentFile, IdText, IdContext, IdIntercept,
  IdLogBase, IdLogEvent;

const
  akc_temat_ustawienia: String = 'Carnet settings';

type
  TOnProcentLog = procedure(procent: Integer) of object;

  TID = record
      dest_key_value: Integer;
      in_source: Boolean;
  end;
  TIDs = array of TID;

    TCharakterystyka = record
        car_no: Integer;
        zb_nr: Integer;
        liters2: array of Double;
        id_chart_type: Integer;
        max_probe: Integer;
    end;
    TCharakterystykaArray = array of TCharakterystyka;

    TOnRaportCreateProgress = procedure(position, max: Integer) of object;
    TOnRaportCreateFunction = procedure(onProgress: TOnRaportCreateProgress) of object;

  TListView2 = class;
  TListItem2 = class
  public
      ImageIndex: Integer;
      Caption: String;
      SubItems: TStringList;
      Data: Pointer;
      owner: TListView2;
      constructor Create(owner: TListView2);
      destructor Destroy(); override;
      procedure Delete();
  end;

  TListView2 = class
  public
      Items: array of TListItem2;
      Selected: TListItem2;
      constructor Create();
      destructor Destroy(); override;
      function Add(): TListItem2;
      procedure Clear();
  end;

    TGPS = record
        szerokosc: double;
        dlugosc: double;
        gps: String;
        included: Boolean;
        gps_status: Char;
        move_event: Integer;
        dataczas: TDateTime;
        znalazl: Boolean;
        packet_prefix: String;
        marka: String;
        rej_numb: String;
    end;
  TGPSes = array [0..255] of TGPS;

  TTEDEmailSrv = class(TService)
    ADOConnection: TADOConnection;
    msg: TIdMessage;
    IdDecoderUUE1: TIdDecoderUUE;
    qMailSettings: TADOTable;
    tmp2: TADOQuery;
    qInsertEvent: TADOStoredProc;
    qCzyBylEmailCzytany2: TADOStoredProc;
    qPojazdy2: TADOQuery;
    qPojazdyZKierowcami: TADOTable;
    MegaRam: TRxMemoryData;
    MegaRamevb1: TIntegerField;
    MegaRamevb2: TIntegerField;
    MegaRamevb3: TIntegerField;
    MegaRamevb4: TIntegerField;
    MegaRamevb5: TIntegerField;
    MegaRamevb6: TIntegerField;
    MegaRamevb7: TIntegerField;
    MegaRamevb8: TIntegerField;
    MegaRamevb9: TIntegerField;
    MegaRamevb10: TIntegerField;
    tmp: TADOQuery;
    tmp5: TADOQuery;
    IdHTTP1: TIdHTTP;
    qXML: TADOQuery;
    RequestFromOnlineTrackingWWWService: TIdTCPServer;
    RequestFromButtonImmediately: TIdTCPServer;
    qCompanies: TADOQuery;
    ADOConnectionPanel: TADOConnection;
    qPanelQuery: TADOQuery;
    qStreet: TADOQuery;
    spDayWork: TADOStoredProc;
    spDayWorkid: TAutoIncField;
    spDayWorkdzien: TStringField;
    spDayWorkdata: TDateTimeField;
    spDayWorkweek: TIntegerField;
    spDayWorkmonth: TIntegerField;
    spDayWorkprzebieg: TBCDField;
    spDayWorkopis: TStringField;
    spDayWorkile_praca: TStringField;
    spDayWorkile_praca_sek: TIntegerField;
    spDayWorkile_postoj: TStringField;
    spDayWorkile_postoj_sek: TIntegerField;
    spDayWorkile_jalowy: TStringField;
    spDayWorkile_jalowy_sek: TIntegerField;
    spDayWorkstart_praca: TDateTimeField;
    spDayWorkstop_praca: TDateTimeField;
    spDayWorkstart_postoj: TDateTimeField;
    spDayWorkstop_postoj: TDateTimeField;
    spDayWorkgroup_id: TIntegerField;
    spDayWorksummary_przebieg_day: TBCDField;
    spDayWorksummary_przebieg_week: TBCDField;
    spDayWorksummary_przebieg_month: TBCDField;
    spDayWorksummary_praca_day: TStringField;
    spDayWorksummary_praca_week: TStringField;
    spDayWorksummary_praca_month: TStringField;
    spDayWorksummary_postoj_day: TStringField;
    spDayWorksummary_postoj_week: TStringField;
    spDayWorksummary_postoj_month: TStringField;
    spDayWorksummary_jalowy_day: TStringField;
    spDayWorksummary_jalowy_week: TStringField;
    spDayWorksummary_jalowy_month: TStringField;
    spDayWorksummary_przebieg_all: TBCDField;
    spDayWorksummary_praca_all: TStringField;
    spDayWorksummary_postoj_all: TStringField;
    spDayWorksummary_jalowy_all: TStringField;
    spDayWorksummary_paliwo_sum: TBCDField;
    spDayWorksummary_paliwo_srednio: TBCDField;
    spDayWorkulica_start: TStringField;
    spDayWorkulica_stop: TStringField;
    spDayWorkszerokosc0: TStringField;
    spDayWorkdlugosc0: TStringField;
    spDayWorkszerokosc: TStringField;
    spDayWorkdlugosc: TStringField;
    spDayWorksrednio: TBCDField;
    spDayWorksummary_paliwo_koszt: TBCDField;
    spDayWorkevb2: TIntegerField;
    spDayWorkmarka_pojazdu: TStringField;
    spDayWorknr_rej_pojazdu: TStringField;
    spDayWorkkierowca: TStringField;
    XML: TXMLDocument;
    IdDecoderMIME: TIdDecoderMIME;
    sp_spaceused: TADOStoredProc;
    qHistorySettings: TADOQuery;
    qHistorySettings2: TADOQuery;
    smtp: TIdSMTP;
    tmp3: TADOQuery;
    qPaliwo: TADOQuery;
    qSaveSelect: TADOQuery;
    tmp4: TADOQuery;
    qspCurrentEvents: TADOStoredProc;
    AutoIncField1: TAutoIncField;
    StringField1: TStringField;
    DateTimeField1: TDateTimeField;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    BCDField1: TBCDField;
    StringField2: TStringField;
    StringField3: TStringField;
    IntegerField3: TIntegerField;
    StringField4: TStringField;
    IntegerField4: TIntegerField;
    StringField5: TStringField;
    IntegerField5: TIntegerField;
    DateTimeField2: TDateTimeField;
    DateTimeField3: TDateTimeField;
    DateTimeField4: TDateTimeField;
    DateTimeField5: TDateTimeField;
    IntegerField6: TIntegerField;
    BCDField2: TBCDField;
    BCDField3: TBCDField;
    BCDField4: TBCDField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    StringField9: TStringField;
    StringField10: TStringField;
    StringField11: TStringField;
    StringField12: TStringField;
    StringField13: TStringField;
    StringField14: TStringField;
    BCDField5: TBCDField;
    StringField15: TStringField;
    StringField16: TStringField;
    StringField17: TStringField;
    BCDField6: TBCDField;
    BCDField7: TBCDField;
    StringField18: TStringField;
    StringField19: TStringField;
    StringField20: TStringField;
    StringField21: TStringField;
    StringField22: TStringField;
    StringField23: TStringField;
    BCDField8: TBCDField;
    BCDField9: TBCDField;
    IntegerField7: TIntegerField;
    StringField24: TStringField;
    StringField25: TStringField;
    StringField26: TStringField;
    qPanelQuery2: TADOQuery;
    qPanelQuery3: TADOQuery;
    POP: TIdPOP3;
    IdLogEvent1: TIdLogEvent;
    procedure RequestFromButtonImmediatelyExecute(AContext: TIdContext);
    procedure RequestFromOnlineTrackingWWWServiceExecute(AContext: TIdContext);
    procedure ServiceExecute(Sender: TService);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceShutdown(Sender: TService);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure IdLogEvent1Status(ASender: TComponent; const AText: string);
  private
    { Private declarations }
    doc: IXMLDOMDocument;
    root, child, child1: IXMLDomElement;
    logi: TStrings;
    FMsgCount: Integer;
    FMailBoxSize: Integer;
//    extraErrorInfo: Boolean;
//    last_procent: Integer;
    pop3_in_work: Boolean;
    lvHeaders: TListView2;
    bias: TDateTime;
    car_no: Integer;
    zrealizowany: Boolean;

    added_databases: TStringList;
    added_databases_section: TMultiReadExclusiveWriteSynchronizer;

    database_size: String;

  public
    ident: String;
    function GetServiceController: TServiceController; override;
    { Public declarations }
    procedure ConnectToDatabase(database_name: String);
    function PobierzPoczte(): boolean;
    procedure RetrievePOPHeaders(inMsgCount: Integer);
    procedure aImportExecute(Sender: TObject);
//    function GetSubject(): String;
    function GetSubject2(msg2: TIdMessage): String;
    procedure AddLog(tresc: String);
    function CzyBylJuzCzytany(dataczas: TDateTime; email: String;
                tytul: String; rozmiar: Integer; email_id: String): Boolean;
    function TimeZoneBias: TDateTime;
    function TimeZoneHourBias: Integer;
    procedure AddEmail(dataczas: TDateTime; email: String;
                tytul, tytul2: String; rozmiar: Integer;
                email_id: String);
    function UstawNajnowszaPozycje(car_no: Integer; event: Integer; dataczas: TDateTime;
        szerokosc: double; dlugosc: double; gps_status: char;
        packet_prefix: String): String; overload;
    procedure UstawNajnowszaPozycje(car_no: Integer; event: Integer; dataczas: TDateTime;
        gps: String; gps_status: char;
        packet_prefix: String); overload;
    procedure UstawNajnowszePozycje(car_no: Integer); overload;
    procedure UstawNajnowszePozycje(onProgress: TOnRaportCreateProgress = nil); overload;
    procedure WpiszNajnowszePozycjeDoEventsOnline();

    procedure UstawNajnowszeDane(var last_positions: TGPSes);

    procedure bXmlToWWWClick();
    function bXmlToWWWClick2(): AnsiString;
    function makeXml(table: TDataSet; tableName: String): AnsiString;

    procedure UaktualnijProcedureTankowania();
    procedure UaktualnijProcedureCzasuPracy();
    procedure UaktualnijProcedureGPS();
    procedure UaktualnijProcedureNietypowe();

    procedure ExportToPanel();
    function IsPanelInfoInINI(): Boolean;

    function IsRetrieveStreetsEnabled(): Boolean;
    procedure RetrieveStreets(id_car: Integer);

    procedure SaveSelectToStream(select_statement: String; var stream: TStream; event: TOnProcentLog);
    function LoadSelectFromStream(stream: TStream): TStreamDataSet;

    procedure SavePaliwoToStream(paliwo_char: TCharakterystykaArray;
                                                var stream: TStream; event: TOnProcentLog);
    procedure SavePaliwoTmpToStream(paliwo_char: TCharakterystykaArray;
                                                var stream: TStream; event: TOnProcentLog);

    procedure CopyStreamSelectToInsertQuery(source: TStreamDataSet;
        create_dest: TADOQuery; event: TOnProcentLog;
        update_dest2: TADOQuery = nil; ids: TIDs = nil;
        dest_primary_key: String = '';
        source_primary_key: String = '';
        exception_source_column: String = '';
        exception_source_column_must_be_null: Boolean = False;
        dest_table_name: String = '';
        delete_if_not_in_source: Boolean = True);

    procedure ProceduraDeviceData2(create: boolean);

    function CreatePanelConnectionString(lista: TStrings): String;



    // IMAP - potrzebne konfiguracja PostFixa
//    function GetEmailSize(MsgId: String): Integer;
//    function GetEmailMailBox(MsgId: String): String;

//    function GetEmailSize2(MsgNum: Integer): Integer;
//    function GetEmailMailBox2(MsgNum: Integer): String;

  end;

var
  TEDEmailSrv: TTEDEmailSrv;

  function GetEmailDate(msg2: TIdMessage): TDateTime;

implementation


{$R *.DFM}

uses Activex, fncPasswordUnit,
   rxStrUtils, fncDataCzasBCB,
   clEmapaTransportOrMapCenterUnit2, Variants, VerInfo,
   fncSettingsHistoryUnit, Math, CompressBLT, DMUnit;

function Installed_version: String;
var ver: TVerInfoRes;
begin
    ver := TVerInfoRes.Create(ParamStr(0));
    result := ver.FileVersion;
    ver.Free();
end;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  TEDEmailSrv.Controller(CtrlCode);
end;

function TTEDEmailSrv.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TTEDEmailSrv.ServiceStart(Sender: TService; var Started: Boolean);
var dane: TStringList;
    function CreateConnectionString(lista: TStrings): String;
    var wynik: String;
        j: Integer;
        MSDE_true_PostgreSQL_false: Boolean;
    begin
        MSDE_true_PostgreSQL_false := (lista.Values['Provider'] = 'SQLOLEDB.1');
        wynik := '';
        for j := 0 to Pred(lista.Count) do
            if (Pos('dodatkowe_', lista.Names[j]) = 0) and
               (Pos('MainDatabase_', lista.Names[j]) = 0) then
            begin
                if lista.Names[j] = 'Password' then
                    wynik := wynik + lista.Names[j] + '=' + DecodePass(lista.Values['Password']) + ';'
                else
                if (not MSDE_true_PostgreSQL_false) and (lista.Names[j] = 'Persist Security Info') then
                    wynik := wynik + 'Extended Properties=""' + ';'
                else
                if (not MSDE_true_PostgreSQL_false) and (lista.Names[j] = 'Initial Catalog') then
                    wynik := wynik + 'Location=' + lista.Values['Initial Catalog'] + ';'
                else
                    wynik := wynik + lista.Strings[j] + ';';
            end;
        wynik := Copy(wynik, 1, Length(wynik) - 1);
        result := wynik;
    end;
begin
try
    AddLog('393 ServiceStart');
//    Sleep(10000);
    CoInitialize(nil);
    Randomize();
    bias := TimeZoneBias;
    zrealizowany := False;
    Started := True;

    dane := TStringList.Create();
    dane.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini');
    ADOConnectionPanel.ConnectionString :=
        CreatePanelConnectionString(dane);
    dane.Free();
    ADOConnectionPanel.Open();
    AddLog('407 ServiceStart koniec');
except
    on e: Exception do
    begin
        AddLog(e.Message);
    end;
end;
end;

procedure TTEDEmailSrv.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
try
    AddLog('419 ServiceStop');
    ADOConnectionPanel.Close();
    CoUninitialize();
    Stopped := True;
except
    on e: Exception do
    begin
        AddLog(e.Message);
    end;
end;
end;

procedure TTEDEmailSrv.ServiceShutdown(Sender: TService);
begin
try
    AddLog('434 ServiceShutdown');
//    CoUninitialize();
except
    on e: Exception do
    begin
        AddLog(e.Message);
    end;
end;
AddLog('442 ServiceShutdown koniec');
end;

procedure TTEDEmailSrv.ServiceCreate(Sender: TObject);
begin
    logi := TStringList.Create();
              AddLog('448 ServiceCreate');

    lvHeaders
     := TListView2.Create();

    added_databases := TStringList.Create();
    added_databases_section := TMultiReadExclusiveWriteSynchronizer.Create();
      AddLog('454 ServiceCreate koniec ');
end;

procedure TTEDEmailSrv.ServiceDestroy(Sender: TObject);
begin
            AddLog('459 ServiceDestroy');
    added_databases.Free();
    added_databases_section.Free();

    lvHeaders.Free();
    AddLog('464 ServiceDestroy koniec');
    logi.Free();
end;

procedure TTEDEmailSrv.ConnectToDatabase(database_name: String);
var dane: TStrings;
    ConnectionString: String;
    nazwaBazy: String;
    version: Integer;

    licznik13567: Integer;

    function CreateConnectionString(lista: TStrings): String;
    var wynik: String;
        j: Integer;
        MSDE_true_PostgreSQL_false: Boolean;
    begin
        MSDE_true_PostgreSQL_false := (lista.Values['Provider'] = 'SQLOLEDB.1');
        wynik := '';
        for j := 0 to Pred(lista.Count) do
            if (Pos('dodatkowe_', lista.Names[j]) = 0) and
               (Pos('MainDatabase_', lista.Names[j]) = 0) then
            begin
                if lista.Names[j] = 'Password' then
                    wynik := wynik + lista.Names[j] + '=' + DecodePass(lista.Values['Password']) + ';'
                else
                if (not MSDE_true_PostgreSQL_false) and (lista.Names[j] = 'Persist Security Info') then
                    wynik := wynik + 'Extended Properties=""' + ';'
                else
                if (not MSDE_true_PostgreSQL_false) and (lista.Names[j] = 'Initial Catalog') then
                    wynik := wynik + 'Location=' + lista.Values['Initial Catalog'] + ';'
                else
                    wynik := wynik + lista.Strings[j] + ';';
            end;
        wynik := Copy(wynik, 1, Length(wynik) - 1);
        result := wynik;
    end;
begin
    dane := TStringList.Create();
    //sprawdzenie czy istnieje plik z ustawieniami aplikacji
    if not FileExists(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini') then
    begin
        raise Exception.Create('Brak pliku ustawienia.ini');
    end;

    dane.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini');

    dane.Values['Initial Catalog'] := database_name;

    ConnectionString := CreateConnectionString(dane);

    nazwaBazy := database_name;

    dane.Free();

    try
        ADOConnection.Close();
        ADOConnection.ConnectionString := ConnectionString;
        ADOConnection.ConnectionTimeout := 35;
        try
            ADOConnection.Open();
            ADOConnection.ConnectionTimeout := 35;
        except
            Sleep(1000);
            ADOConnection.ConnectionTimeout := 35;
            ADOConnection.Open();
        end;

    tmp.SQL.Clear();
    tmp.SQL.Add('select ident from carnet_settings ');
    tmp.Open();
    ident := tmp.FieldByName('ident').AsString;
    tmp.Close();

    tmp.SQL.Clear();
    tmp.SQL.Add('select version from versions ');
    tmp.Open();
    version := tmp.FieldByName('version').AsInteger;
    tmp.Close();

    if version = 1 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(69, ''Identyfikacja DALLAS'') ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 2 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_nonstandard(id_event) values(69) ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 3 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_nonstandard(id_event) values(69) ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 4 then
    begin
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 5 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_has_time(id_event) values(69) ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 6 then
    begin
      tmp.Close();
      tmp.SQL.Clear();
      tmp.SQL.Add('ALTER procedure sp_speedEvents ');
      tmp.SQL.Add('    @isInCarMode integer, ');
      tmp.SQL.Add('    @car_or_driver_no integer, ');
      tmp.SQL.Add('    @start datetime, ');
      tmp.SQL.Add('    @stop datetime, ');
      tmp.SQL.Add('    @id_progress bigint ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('begin ');
      tmp.SQL.Add('	declare @report TABLE ');
      tmp.SQL.Add('	( ');
      tmp.SQL.Add('		id integer not null identity (1,1), ');
      tmp.SQL.Add('		data datetime, ');
      tmp.SQL.Add('		startGGMM varchar(5), ');
      tmp.SQL.Add('		stopGGMM varchar(5), ');
      tmp.SQL.Add('		marka_pojazdu varchar(250), ');
      tmp.SQL.Add('		nr_rej_pojazdu varchar(10), ');
      tmp.SQL.Add('		kierowca varchar(100), ');
      tmp.SQL.Add('		setup_speed int, ');
      tmp.SQL.Add('		max_speed int, ');
      tmp.SQL.Add('		ile_sek integer, ');
      tmp.SQL.Add('		ile_GGMM varchar(5), ');
      tmp.SQL.Add('		dzien nvarchar(5), ');
      tmp.SQL.Add('		day_max_speed int,					-- maksymalne przekroczenie predkosci w ciagu dnia ');
      tmp.SQL.Add('		day_num_overspeed int,				-- ilosc przekroczen predkosci w ciagu dnia ');
      tmp.SQL.Add('		all_max_speed int,					-- maksymalne przekroczenie predkosci w calym zakresie ');
      tmp.SQL.Add('		all_num_overspeed int,				-- ilosc przekroczen predkosci w calym zakresie ');
      tmp.SQL.Add('		all_time_overspeed varchar(6),		-- czas w formacie GGMM kiedy kierowca jechal z przekroczona predkoscia ');
      tmp.SQL.Add('		primary key(id) ');
      tmp.SQL.Add('	); ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	declare @evb3 tinyint;					-- bajty zdarzenia ');
      tmp.SQL.Add('	declare @evb9 tinyint; ');
      tmp.SQL.Add('	declare @evb10 tinyint; ');
      tmp.SQL.Add('	declare @date datetime;					-- data zdarzenia ');
      tmp.SQL.Add('	declare @event_start_time datetime;		-- czas rozpoczecia zdarzenia ');
      tmp.SQL.Add('	declare @event_stop_time datetime;		-- czas zakonczenia zdarzenia ');
      tmp.SQL.Add('	declare @state tinyint;					-- stan; okresla jakie zdarzenie analizowane bylo poprzednio ');
      tmp.SQL.Add('	declare @speed_prog numeric(10, 6);		-- prog predkosci ');
      tmp.SQL.Add('    declare @speed_max numeric(10, 6);		-- maksymalna predkosc podczas przekroczenia ');
      tmp.SQL.Add('    declare @fast_imp numeric(10,3);		-- stala K dzielona przez imp_div ');
      tmp.SQL.Add('    declare @imp_div int;					-- dzielnik impulsow drogi pojazdu ');
      tmp.SQL.Add('    declare @time_sec int;					-- czas trwania zdarzenia w sekundach ');
      tmp.SQL.Add('    declare @day_of_week nvarchar(2);		-- dzien tygonia, skrot dwuznakowy ');
      tmp.SQL.Add('    declare @car_name varchar(50);			-- nazwa pojazdu ');
      tmp.SQL.Add('	declare @car_rej varchar(15);			-- numer rejestracyjny pojazdu ');
      tmp.SQL.Add('	declare @driver_name varchar(100);		-- nazwa kierowcy ');
      tmp.SQL.Add('	declare @ile_GGMM varchar(50); ');
      tmp.SQL.Add('	declare @num_records int;				-- ilosc rekordow do przeanalizowania ');
      tmp.SQL.Add('	declare @record_step int;				-- krok, co ile rekordow aktualizowac postep ');
      tmp.SQL.Add('	declare @record_index int;				-- nr kolejnego analizowanego rekordu ');
      tmp.SQL.Add('	declare @all_overspeed_sec int; ');
      tmp.SQL.Add('	declare @canceled bit;					-- wksazuje czy wykonanie procedury nie zostalo anulowane ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	set @record_step = 100; ');
      tmp.SQL.Add('	set @record_index = 1; ');
      tmp.SQL.Add('	set @all_overspeed_sec = 0; ');
      tmp.SQL.Add('	set @canceled=0; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	-- W zaleznosci od trybu wywolania funkcji wybierany jest odpowiedni widok oraz parametry jego filtrowania. ');
      tmp.SQL.Add('	-- Jesli jest to tryb pojazdu, wykorzystywany jest widok view_speedEvents_carMode, filtrowanie ');
      tmp.SQL.Add('	-- po id pojazdu. ');
      tmp.SQL.Add('	-- Jesli jest to tryb kierowcy, uzywany widok to view_speedEvents_driverMode, a filtrowanie ');
      tmp.SQL.Add('	-- po id kierowcy. ');
      tmp.SQL.Add('	-- W obu trybach wybierane sa rekordy w przedziale czasowym zdarzenia pomiedzy datami @start i @stop. ');
      tmp.SQL.Add('	if (@isInCarMode = 1) ');
      tmp.SQL.Add('	begin ');
      tmp.SQL.Add('		declare zdarzenia_cr cursor ');
      tmp.SQL.Add('			for select evb3,evb9,evb10,date,imp_div,fast_imp,driver_name,car_name,rej_numb from view_speedEvents_carMode ');
      tmp.SQL.Add('			where evb2=@car_or_driver_no AND date>=@start AND date<=@stop ');
      tmp.SQL.Add('			order by id_device_data asc; ');
      tmp.SQL.Add('		set @num_records = (select count(*) from view_speedEvents_carMode ');
      tmp.SQL.Add('			where evb2=@car_or_driver_no AND date>=@start AND date<=@stop); ');
      tmp.SQL.Add('	end ');
      tmp.SQL.Add('	else ');
      tmp.SQL.Add('	begin ');
      tmp.SQL.Add('		declare zdarzenia_cr cursor ');
      tmp.SQL.Add('			for select evb3,evb9,evb10,date,imp_div,fast_imp,driver_name,car_name,rej_numb from view_speedEvents_driverMode ');
      tmp.SQL.Add('			where id_driver=@car_or_driver_no AND date>=@start AND date<=@stop ');
      tmp.SQL.Add('			order by id_device_data asc; ');
      tmp.SQL.Add('		set @num_records = (select count(*) from view_speedEvents_driverMode ');
      tmp.SQL.Add('			where id_driver=@car_or_driver_no AND date>=@start AND date<=@stop); ');
      tmp.SQL.Add('	end ');
      tmp.SQL.Add('	set @state = 0; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	open zdarzenia_cr ');
      tmp.SQL.Add('    fetch zdarzenia_cr into @evb3, @evb9, @evb10, @date, @imp_div,@fast_imp, @driver_name, @car_name, @car_rej; ');
      tmp.SQL.Add('    while (@@fetch_status <> -1) and (@canceled=0) ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('		-- Zdarzenia 50 i 51 (odpowiednio rozpoczecie i zakonczenie przekroczenia predkosci) ');
      tmp.SQL.Add('		-- pochodza z urzadzen starego typu i trzeba przy nich prog ');
      tmp.SQL.Add('		-- predkosci wyliczac za pomoca odpowiedniego wzoru. ');
      tmp.SQL.Add('		-- Dla zdarzen 57 i 58, ktore oznaczaja to samo, wystarczy odczytac dziesiaty bajt. ');
      tmp.SQL.Add('        if @evb3 = 50 ');
      tmp.SQL.Add('        begin ');
      tmp.SQL.Add('            set @event_start_time = @date; ');
      tmp.SQL.Add('            set @speed_prog = Round((3600.0 * 1000000.0 * 110592.0) / ');
      tmp.SQL.Add('                          ((256 * @evb10) * 120000.0 * ');
      tmp.SQL.Add('                          @fast_imp * @imp_div), 0); ');
      tmp.SQL.Add('            -- Rozpoczecie przekroczenia predkosci - ustaw stan na 1 ');
      tmp.SQL.Add('            set @state = 1; ');
      tmp.SQL.Add('        end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('        if @evb3 = 51 ');
      tmp.SQL.Add('        begin ');
      tmp.SQL.Add('            set @event_stop_time = @date; ');
      tmp.SQL.Add('            set @speed_max = Round((3600.0 * 1000000.0 * 110592.0) / ');
      tmp.SQL.Add('                          ((256*@evb10 + ');
      tmp.SQL.Add('                                @evb9) * 120000.0 * ');
      tmp.SQL.Add('                          @fast_imp * @imp_div), 0); ');
      tmp.SQL.Add('            -- Zakonczenie przekroczenia predkosci - ustaw stan na 2 ');
      tmp.SQL.Add('            set @state = 2; ');
      tmp.SQL.Add('        end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('        if @evb3 = 57 ');
      tmp.SQL.Add('        begin ');
      tmp.SQL.Add('            set @event_start_time = @date; ');
      tmp.SQL.Add('            set @speed_prog = @evb10; ');
      tmp.SQL.Add('            -- Rozpoczecie przekroczenia predkosci - ustaw stan na 1 ');
      tmp.SQL.Add('            set @state = 1; ');
      tmp.SQL.Add('        end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('        if @evb3 = 58 ');
      tmp.SQL.Add('        begin ');
      tmp.SQL.Add('            set @event_stop_time = @date; ');
      tmp.SQL.Add('            set @speed_max = @evb10; ');
      tmp.SQL.Add('            -- Zakonczenie przekroczenia predkosci - ustaw stan na 2, jesli poprzednio ');
      tmp.SQL.Add('            -- bylo rozpoczecie przekroczenia predkosci. ');
      tmp.SQL.Add('            if (@state = 1) ');
      tmp.SQL.Add('				set @state = 2; ');
      tmp.SQL.Add('        end; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('		-- Jesli stan=2 to znaczy, ze przeanalizowalismy pare zdarzen oznaczajacych rozpoczecie ');
      tmp.SQL.Add('		-- i zakonczenie przekroczenia predkosci. ');
      tmp.SQL.Add('        if (@state = 2) ');
      tmp.SQL.Add('        begin ');
      tmp.SQL.Add('			-- uzyskanie skrotu nazwy dnia tygodnia ');
      tmp.SQL.Add('            set @day_of_week = dbo.spNazwaDnia_f(@event_start_time); ');
      tmp.SQL.Add('            -- reakcja na bledne dane z urzadzenia ');
      tmp.SQL.Add('            if @speed_max > 200 ');
      tmp.SQL.Add('                set @speed_max = 200 ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('			-- czas trwania zdarzenia w sekundach ');
      tmp.SQL.Add('            set @time_sec = dbo.get_date_diff(@event_start_time, @event_stop_time); ');
      tmp.SQL.Add('            set @all_overspeed_sec = @all_overspeed_sec + @time_sec; ');
      tmp.SQL.Add('            -- czas trwania zdarzenia w formacie GGMM ');
      tmp.SQL.Add('            set @ile_GGMM = dbo.spGetGGMMf(@time_sec); ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('			-- wstawienie danych do tabeli wynikowej ');
      tmp.SQL.Add('			if @event_start_time is not null ');
      tmp.SQL.Add('            insert into @report(data, startGGMM, stopGGMM, marka_pojazdu, ');
      tmp.SQL.Add('                nr_rej_pojazdu, kierowca, setup_speed, max_speed, ile_sek, ile_GGMM, ');
      tmp.SQL.Add('                dzien) ');
      tmp.SQL.Add('                values( ');
      tmp.SQL.Add('                    dbo.get_simple_date(@event_start_time), ');
      tmp.SQL.Add('                    dbo.getGGMMfromDateTime(@event_start_time), ');
      tmp.SQL.Add('                    dbo.getGGMMfromDateTime(@event_stop_time), ');
      tmp.SQL.Add('                    @car_name, @car_rej, @driver_name, ');
      tmp.SQL.Add('                    @speed_prog, @speed_max, ');
      tmp.SQL.Add('                    @time_sec, @ile_GGMM, @day_of_week ');
      tmp.SQL.Add('                ) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('            set @state = 0; ');
      tmp.SQL.Add('        end ');
      tmp.SQL.Add('        fetch zdarzenia_cr into @evb3, @evb9, @evb10, @date, @imp_div,@fast_imp, @driver_name, @car_name, @car_rej; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('		-- uaktualnij wskaznik postepu wykonania procedury ');
      tmp.SQL.Add('		if (@record_index % @record_step = 0) ');
      tmp.SQL.Add('			exec sp_progress_set @id_progress, @record_index, @num_records, @canceled output; ');
      tmp.SQL.Add('		set @record_index = @record_index + 1 ');
      tmp.SQL.Add('	end ');
      tmp.SQL.Add('	close zdarzenia_cr; ');
      tmp.SQL.Add('    deallocate zdarzenia_cr; ');
      tmp.SQL.Add('    if (@canceled<>1) or (@canceled is null) ');
      tmp.SQL.Add('		begin ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('    -- ');
      tmp.SQL.Add('    -- oblicz dane agregacyjne ');
      tmp.SQL.Add('    -- ');
      tmp.SQL.Add('    -- ustaw ilosc przekroczen w calym zakresie ');
      tmp.SQL.Add('    update @report set all_num_overspeed=(select count(*) from @report) ');
      tmp.SQL.Add('    --ustaw maksymalne przekroczenie w calym zakresie ');
      tmp.SQL.Add('    update @report set all_max_speed=(select max(max_speed) from @report) ');
      tmp.SQL.Add('    -- ustaw czas przebywania pojazdu powyzej progu predkosci ');
      tmp.SQL.Add('    update @report set all_time_overspeed=dbo.spGetGGMMf(@all_overspeed_sec) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('    declare @data datetime;			-- data przekroczenia ');
      tmp.SQL.Add('	declare @day_num_overspeed int;	-- ilosc przekroczen w ciagu dnia ');
      tmp.SQL.Add('	declare @day_max_speed int;		-- maksymalne przekroczenie w ciagu dnia ');
      tmp.SQL.Add('    declare aggr_cr cursor ');
      tmp.SQL.Add('			for select data, count(*), max(max_speed) from @report ');
      tmp.SQL.Add('				group by data ');
      tmp.SQL.Add('	-- uzupelnij brakujace dane w tabeli @report ');
      tmp.SQL.Add('	open aggr_cr ');
      tmp.SQL.Add('    fetch aggr_cr into @data, @day_num_overspeed, @day_max_speed ');
      tmp.SQL.Add('    while (@@fetch_status <> -1) ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('        update @report set day_num_overspeed=@day_num_overspeed, day_max_speed=@day_max_speed ');
      tmp.SQL.Add('			where data=@data ');
      tmp.SQL.Add('		fetch aggr_cr into @data, @day_num_overspeed, @day_max_speed ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('	close aggr_cr; ');
      tmp.SQL.Add('    deallocate aggr_cr; ');
      tmp.SQL.Add('    -- wyrejestruj procedure ze sledzenia postepu ');
      tmp.SQL.Add('    exec sp_progress_unregister @id_progress; ');
      tmp.SQL.Add('	select * from @report order by id; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add(' end ');
      tmp.SQL.Add('end ');

      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 7 then
    begin
      tmp.Close();
      tmp.SQL.Clear();
      tmp.SQL.Add('create table extra_settings ');
      tmp.SQL.Add('( ');
      tmp.SQL.Add('   id int not null, ');
      tmp.SQL.Add('   simple_look_host varchar(100), ');
      tmp.SQL.Add('   simple_look_port int, ');
      tmp.SQL.Add('   primary key(id) ');
      tmp.SQL.Add(') ');
      tmp.ExecSQL();

      tmp.Close();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into extra_settings (id, simple_look_host, simple_look_port) values(1, ''217.97.183.133'', 8082) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 8 then
    begin
        tmp.Close();
        tmp.SQL.Clear();
        tmp.SQL.Add('alter table car add last_gps varchar(50), ');
        tmp.SQL.Add('last_gps_event integer, last_gps_datetime datetime, ');
        tmp.SQL.Add('last_gps_status varchar(1) ');
        tmp.ExecSQL();

        tmp.SQL.Clear();
        tmp.SQL.Add('alter table car add last_packet_prefix varchar(10) ');
        tmp.ExecSQL();

        Inc(version);
        tmp.SQL.Clear();
        tmp.SQL.Add('update versions set version = ' + IntToStr(version));
        tmp.ExecSQL();
    end;

    if version = 9 then
    begin
        UstawNajnowszePozycje(0);

        Inc(version);
        tmp.SQL.Clear();
        tmp.SQL.Add('update versions set version = ' + IntToStr(version));
        tmp.ExecSQL();
    end;

    if version = 10 then
    begin
{        oldCaption := Caption;
        Caption := 'Wczytywanie wersji jêzykowych';

        qLanguages.Close();
        qTranslates.Close();

        archiwum := TBLTArchive.Create(ExtractFilePath(ParamStr(0)) + 'languages.lng');
        languages := TMemoryStream.Create();
        archiwum.PlikByName('languages').DekompresujDo(languages);
        languages.Position := 0;
        translates := TMemoryStream.Create();
        archiwum.PlikByName('translates').DekompresujDo(translates);
        translates.Position := 0;

        tmp.Close();
        tmp.SQL.Clear();
        tmp.SQL.Add('delete from languages'); // translates usunie siê kaskadowo
        tmp.ExecSQL();

        tmp.SQL.Clear();
        tmp.SQL.Add('insert into languages (id, language_name, flaga) values (:id, :language_name, :flaga)');
//        tmp.SQL.Add('insert into languages (id, language_name) values (:id, :language_name)');
        dataset := LoadSelectFromStream(languages);
        dataset.Open();
        CopyStreamSelectToInsertQuery(dataset, tmp, nil);
        dataset.Close();
        dataset.Free();

        tmp.SQL.Clear();
        tmp.SQL.Add('insert into translates (id, language_id, translate) values (:id, :language_id, :translate)');
        dataset := LoadSelectFromStream(translates);
        dataset.Open();
        CopyStreamSelectToInsertQuery(dataset, tmp, nil);
        dataset.Close();
        dataset.Free();

        translates.Free();
        languages.Free();
        archiwum.Free();

        qLanguages.Open();
        qLanguages.Last();
        qTranslates.Open();

        LoadLanguages();

        Caption := oldCaption; }

        Inc(version);
        tmp.SQL.Clear();
        tmp.SQL.Add('update versions set version = ' + IntToStr(version));
        tmp.ExecSQL();
    end;

    if version = 11 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(114, ''Pomiar temperatury'') ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_nonstandard(id_event) values(114) ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_has_time(id_event) values(114) ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 12 then
    begin

//      UaktualnijProcedureNietypowe();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 13 then
    begin
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 14 then
    begin
      UaktualnijProcedureCzasuPracy();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 15 then
    begin
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 16 then
    begin
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 17 then
    begin
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 18 then
    begin
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 19 then
    begin
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 20 then
    begin
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 21 then
    begin
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 22 then
    begin
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 23 then
    begin
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 24 then
    begin
//      AktualizujWersjeJezykowa();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 25 then
    begin
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 26 then
    begin
      UaktualnijProcedureTankowania();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;


    if version = 27 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('create procedure [dbo].[ZdarzeniaGPSWytluszczone] ');
      tmp.SQL.Add('	@evb2 integer, ');
      tmp.SQL.Add('	@start datetime, ');
      tmp.SQL.Add('	@end datetime ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('begin ');
      tmp.SQL.Add('	select count(*) ile_rekordow, cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime) dzien ');
      tmp.SQL.Add('	from device_data t1 ');
      tmp.SQL.Add('	where evb2 = @evb2 and ');
      tmp.SQL.Add('		date>= @start and ');
      tmp.SQL.Add('		date<= @end and ');
      tmp.SQL.Add('		(evb3 = 36 or evb3 = 38) and (evb1 = 65) ');
      tmp.SQL.Add('	group by cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime) ');
      tmp.SQL.Add('end; ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('create procedure [dbo].[ZdarzeniaGPSPrzekreslone] ');
      tmp.SQL.Add('	@evb2 integer, ');
      tmp.SQL.Add('	@start datetime, ');
      tmp.SQL.Add('	@end datetime ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('begin ');
      tmp.SQL.Add('	select count(*) ile_rekordow, cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime) dzien ');
      tmp.SQL.Add('	from device_data t1 ');
      tmp.SQL.Add('	where evb2 = @evb2 and ');
      tmp.SQL.Add('		 date>= @start and ');
      tmp.SQL.Add('		 date<= @end ');
      tmp.SQL.Add('	group by cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime) ');
      tmp.SQL.Add('end; ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('create procedure [dbo].[ZdarzeniaGPS2Wytluszczone] ');
      tmp.SQL.Add('	@driver_no integer, ');
      tmp.SQL.Add('	@start datetime, ');
      tmp.SQL.Add('	@end datetime ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('begin ');
      tmp.SQL.Add('	select count(*) ile_rekordow, cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime)   dzien ');
      tmp.SQL.Add('	from device_data t1 ');
      tmp.SQL.Add('	  inner join car_change t5 ');
      tmp.SQL.Add('		 on (t1.evb2 = t5.id_car and t1.date>= t5.start_date ');
      tmp.SQL.Add('						   and (t1.date<= t5.end_date or t5.end_date is null)) ');
      tmp.SQL.Add('	where t5.id_driver = @driver_no and ');
      tmp.SQL.Add('		 t1.date>= @start and ');
      tmp.SQL.Add('		 t1.date<= @end and ');
      tmp.SQL.Add('		(t1.evb3 = 36 or t1.evb3 = 38) and (t1.evb1 = 65) ');
      tmp.SQL.Add('	group by cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime) ');
      tmp.SQL.Add('end; ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('create procedure [dbo].[ZdarzeniaGPS2Przekreslone] ');
      tmp.SQL.Add('	@driver_no integer, ');
      tmp.SQL.Add('	@start datetime, ');
      tmp.SQL.Add('	@end datetime ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('begin ');
      tmp.SQL.Add('	select count(*) ile_rekordow, cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime)   dzien ');
      tmp.SQL.Add('	from device_data t1 ');
      tmp.SQL.Add('	  inner join car_change t5 ');
      tmp.SQL.Add('		 on (t1.evb2 = t5.id_car and t1.date>= t5.start_date ');
      tmp.SQL.Add('						   and (t1.date<= t5.end_date or t5.end_date is null)) ');
      tmp.SQL.Add('	where t5.id_driver = @driver_no and ');
      tmp.SQL.Add('		 t1.date>= @start and ');
      tmp.SQL.Add('		 t1.date<= @end ');
      tmp.SQL.Add('	group by cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime) ');
      tmp.SQL.Add('end; ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 28 then
    begin
      tmp.Close();
      tmp.SQL.Clear();
      tmp.SQL.Add('update carnet_settings set mapcenter_host = :mapcenter_host, mapcenter_port = :mapcenter_port, mapcenter_login = :mapcenter_login, mapcenter_pass = :mapcenter_pass');
      tmp.Parameters.ParamByName('mapcenter_host').Value := '';
      tmp.Parameters.ParamByName('mapcenter_port').Value := 0;
      tmp.Parameters.ParamByName('mapcenter_login').Value := '';
      tmp.Parameters.ParamByName('mapcenter_pass').Value := CodePass('');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 29 then
    begin
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 30 then
    begin
//      UaktualnijProcedureCzasuPracy();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 31 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table carnet_settings add was_dumped integer');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 32 then
    begin
      UaktualnijProcedureTankowania();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 33 then
    begin
      UaktualnijProcedureCzasuPracy();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 34 then
    begin
      UaktualnijProcedureGPS();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 35 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(181, ''Bieg ja³owy'') ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 36 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_nonstandard(id_event) values(181) ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 37 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_has_time(id_event) values(181) ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 38 then
    begin

      UaktualnijProcedureNietypowe();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 39 then
    begin

      tmp.SQL.Clear();
      tmp.SQL.Add('alter table reguly ' +
                       ' add region_number_in_device integer, '+
                           ' region_sms_mode_in_device integer');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 40 then
    begin

      tmp.SQL.Clear();
      tmp.SQL.Add('alter table reguly ' +
                       ' add region_sms_enabled integer ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 41 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(16, ''Koniec zas³oniêcia GPSu'') ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 42 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_nonstandard(id_event) values(16) ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_has_time(id_event) values(16) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 43 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(174, ''Kasowanie pamieci'') ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(175, ''Kasowanie pamieci'') ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 44 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add ident2 varchar(50) ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 45 then
    begin
//      UaktualnijProcedureCzasuPracy();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 46 then
    begin
//      UaktualnijProcedureCzasuPracy();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 47 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('create table street ');
      tmp.SQL.Add('( ');
      tmp.SQL.Add('    id_street bigint not null IDENTITY(1,1), ');
      tmp.SQL.Add('    id_car tinyint NOT NULL, ');
      tmp.SQL.Add('    _datetime datetime not null, ');
      tmp.SQL.Add('    szerokosc varchar(30), ');
      tmp.SQL.Add('    dlugosc varchar(30), ');
      tmp.SQL.Add('    street varchar(200), ');
      tmp.SQL.Add('    primary key (id_street), ');
      tmp.SQL.Add('    foreign key (id_car) references car (id_car) on delete cascade on update cascade ');
      tmp.SQL.Add(') ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 48 then
    begin
      UaktualnijProcedureCzasuPracy();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 49 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add ');
      tmp.SQL.Add('  enable_checking_oil_change integer, ');
      tmp.SQL.Add('  ChangeOilKM integer, ');
      tmp.SQL.Add('  ChangeOilMTH integer, ');
      tmp.SQL.Add('  CountedOilKM integer, ');
      tmp.SQL.Add('  CountedOilMTH integer, ');
      tmp.SQL.Add('  StartCountOilKM datetime, ');
      tmp.SQL.Add('  StartCountOilMTH datetime ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 50 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add ');
      tmp.SQL.Add('  remindTimeKM datetime, ');
      tmp.SQL.Add('  remindTimeMTH datetime ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 51 then
    begin
      UaktualnijProcedureTankowania();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 52 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table street ');
      tmp.SQL.Add(' add street2 varchar(200) ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 53 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table street drop column street2 ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('delete from street ');
      tmp.ExecSQL();
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 54 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(122, ''Pomiar obrotow silnika'') ');
      tmp.ExecSQL();
      
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_has_time(id_event) values(122) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 55 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add rpm_rated integer ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('update car set rpm_rated = 1600 ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 56 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add temperatura numeric(10, 3), predkosc integer, paliwo numeric(10, 3) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 57 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('update extra_settings set simple_look_host = ''193.192.175.194'', simple_look_port = 8082 ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 58 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add(' alter table car add gr1 integer');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 59 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('create table calendar_bold ');
      tmp.SQL.Add('( ');
      tmp.SQL.Add('    id integer not null identity, ');
      tmp.SQL.Add('    id_car tinyint not null, ');
      tmp.SQL.Add('    date_ datetime not null, ');
      tmp.SQL.Add('    has_data integer, ');
      tmp.SQL.Add('    has_gps integer, ');
      tmp.SQL.Add('    primary key (id), ');
      tmp.SQL.Add('    foreign key (id_car) references car(id_car) on update cascade on delete cascade ');
      tmp.SQL.Add(') ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 60 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('ALTER procedure [dbo].[insertevent] ');
      tmp.SQL.Add('	@evb1 integer, ');
      tmp.SQL.Add('	@evb2 integer, ');
      tmp.SQL.Add('	@evb3 integer, ');
      tmp.SQL.Add('	@evb4 integer, ');
      tmp.SQL.Add('	@evb5 integer, ');
      tmp.SQL.Add('	@evb6 integer, ');
      tmp.SQL.Add('	@evb7 integer, ');
      tmp.SQL.Add('	@evb8 integer, ');
      tmp.SQL.Add('	@evb9 integer, ');
      tmp.SQL.Add('	@evb10 integer, ');
      tmp.SQL.Add('	@evdata datetime, ');
      tmp.SQL.Add('	@pal1 integer, ');
      tmp.SQL.Add('	@pal2 integer, ');
      tmp.SQL.Add('	@timezonebias integer ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('    declare @car_exists tinyint ');
      tmp.SQL.Add('    select @car_exists=count(*) from car where id_car=@evb2 ');
      tmp.SQL.Add('    if (@car_exists=0) ');
      tmp.SQL.Add('		insert into car (id_car, name) values (@evb2, ''AUTO NR '' ');
      tmp.SQL.Add('			+ cast(@evb2 as varchar(3))) ');
      tmp.SQL.Add('	insert into device_data (evb1, evb2, evb3, evb4, evb5, evb6, evb7, evb8, ');
      tmp.SQL.Add(' evb9, evb10, [date], pal1, pal2, timezonebias) ');
      tmp.SQL.Add('	values(@evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, @evb8, @evb9, ');
      tmp.SQL.Add(' @evb10, @evdata, @pal1, @pal2, @timezonebias) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add(' declare @only_date datetime ');
      tmp.SQL.Add(' set @only_date = cast(STR(MONTH(@evdata)) + ''/'' + ');
      tmp.SQL.Add(' 							 STR(DAY(@evdata)) + ''/'' + ');
      tmp.SQL.Add(' 							 STR(YEAR(@evdata)) as datetime) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add(' declare @calendar_exists tinyint ');
      tmp.SQL.Add(' select @calendar_exists = count(*) from calendar_bold where id_car = @evb2 ');
      tmp.SQL.Add('      and date_ = @only_date ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add(' if(@calendar_exists = 0) ');
      tmp.SQL.Add(' 	insert into calendar_bold(id_car, date_, has_data, has_gps) ');
      tmp.SQL.Add(' 		values(@evb2, @only_date, 1, 0); ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add(' if (@evb3 = 36 or @evb3 = 38) and (@evb1 = 65) ');
      tmp.SQL.Add(' 	update calendar_bold set has_gps = 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;


    if version = 61 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('ALTER procedure [dbo].[ZdarzeniaGPSWytluszczone] ');
      tmp.SQL.Add('	@evb2 integer, ');
      tmp.SQL.Add('	@start datetime, ');
      tmp.SQL.Add('	@end datetime ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('begin ');
      tmp.SQL.Add('/* ');
      tmp.SQL.Add('	select count(*) ile_rekordow, cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime) dzien ');
      tmp.SQL.Add('	from device_data t1 ');
      tmp.SQL.Add('	where evb2 = @evb2 and ');
      tmp.SQL.Add('		date>= @start and ');
      tmp.SQL.Add('		date<= @end and ');
      tmp.SQL.Add('		(evb3 = 36 or evb3 = 38) and (evb1 = 65) ');
      tmp.SQL.Add('	group by cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime) ');
      tmp.SQL.Add('*/ ');
      tmp.SQL.Add('	select count(*) ile_rekordow, t1.date_ dzien ');
      tmp.SQL.Add('	from calendar_bold t1 ');
      tmp.SQL.Add('	where t1.id_car = @evb2 and ');
      tmp.SQL.Add('		 t1.date_>= @start and ');
      tmp.SQL.Add('		 t1.date_<= @end and ');
      tmp.SQL.Add('		 t1.has_gps = 1 ');
      tmp.SQL.Add('	group by t1.date_ ');
      tmp.SQL.Add('end; ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 62 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('ALTER procedure [dbo].[ZdarzeniaGPSPrzekreslone] ');
      tmp.SQL.Add('	@evb2 integer, ');
      tmp.SQL.Add('	@start datetime, ');
      tmp.SQL.Add('	@end datetime ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('begin ');
      tmp.SQL.Add('/* ');
      tmp.SQL.Add('	select count(*) ile_rekordow, cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime) dzien ');
      tmp.SQL.Add('	from device_data t1 ');
      tmp.SQL.Add('	where evb2 = @evb2 and ');
      tmp.SQL.Add('		 date>= @start and ');
      tmp.SQL.Add('		 date<= @end ');
      tmp.SQL.Add('	group by cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime) ');
      tmp.SQL.Add('*/ ');
      tmp.SQL.Add('	select count(*) ile_rekordow, t1.date_ dzien ');
      tmp.SQL.Add('	from calendar_bold t1 ');
      tmp.SQL.Add('	where t1.id_car = @evb2 and ');
      tmp.SQL.Add('		 t1.date_>= @start and ');
      tmp.SQL.Add('		 t1.date_<= @end ');
      tmp.SQL.Add('	group by t1.date_ ');
      tmp.SQL.Add('end; ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 63 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('ALTER procedure [dbo].[ZdarzeniaGPS2Wytluszczone] ');
      tmp.SQL.Add('	@driver_no integer, ');
      tmp.SQL.Add('	@start datetime, ');
      tmp.SQL.Add('	@end datetime ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('begin ');
      tmp.SQL.Add('/* ');
      tmp.SQL.Add('	select count(*) ile_rekordow, cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime)   dzien ');
      tmp.SQL.Add('	from device_data t1 ');
      tmp.SQL.Add('	  inner join car_change t5 ');
      tmp.SQL.Add('		 on (t1.evb2 = t5.id_car and t1.date>= t5.start_date ');
      tmp.SQL.Add('						   and (t1.date<= t5.end_date or t5.end_date is null)) ');
      tmp.SQL.Add('	where t5.id_driver = @driver_no and ');
      tmp.SQL.Add('		 t1.date>= @start and ');
      tmp.SQL.Add('		 t1.date<= @end and ');
      tmp.SQL.Add('		(t1.evb3 = 36 or t1.evb3 = 38) and (t1.evb1 = 65) ');
      tmp.SQL.Add('	group by cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime) ');
      tmp.SQL.Add('*/ ');
      tmp.SQL.Add('	select count(*) ile_rekordow, t1.date_ dzien ');
      tmp.SQL.Add('	from calendar_bold t1 ');
      tmp.SQL.Add('	  inner join car_change t5 ');
      tmp.SQL.Add('		 on (t1.id_car = t5.id_car and t1.date_>= t5.start_date ');
      tmp.SQL.Add('						   and (t1.date_<= t5.end_date or t5.end_date is null)) ');
      tmp.SQL.Add('	where t5.id_driver = @driver_no and ');
      tmp.SQL.Add('		 t1.date_>= @start and ');
      tmp.SQL.Add('		 t1.date_<= @end and ');
      tmp.SQL.Add('		 t1.has_gps = 1 ');
      tmp.SQL.Add('	group by t1.date_ ');
      tmp.SQL.Add('end; ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 64 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('ALTER procedure [dbo].[ZdarzeniaGPS2Przekreslone] ');
      tmp.SQL.Add('	@driver_no integer, ');
      tmp.SQL.Add('	@start datetime, ');
      tmp.SQL.Add('	@end datetime ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('begin ');
      tmp.SQL.Add('/* ');
      tmp.SQL.Add('	select count(*) ile_rekordow, cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime)   dzien ');
      tmp.SQL.Add('	from device_data t1 ');
      tmp.SQL.Add('	  inner join car_change t5 ');
      tmp.SQL.Add('		 on (t1.evb2 = t5.id_car and t1.date>= t5.start_date ');
      tmp.SQL.Add('						   and (t1.date<= t5.end_date or t5.end_date is null)) ');
      tmp.SQL.Add('	where t5.id_driver = @driver_no and ');
      tmp.SQL.Add('		 t1.date>= @start and ');
      tmp.SQL.Add('		 t1.date<= @end ');
      tmp.SQL.Add('	group by cast(STR(MONTH(date)) + ''/'' + STR(DAY(date)) + ''/'' + STR(YEAR(date)) as datetime) ');
      tmp.SQL.Add('*/ ');
      tmp.SQL.Add('	select count(*) ile_rekordow, t1.date_ dzien ');
      tmp.SQL.Add('	from calendar_bold t1 ');
      tmp.SQL.Add('	  inner join car_change t5 ');
      tmp.SQL.Add('		 on (t1.id_car = t5.id_car and t1.date_>= t5.start_date ');
      tmp.SQL.Add('						   and (t1.date_<= t5.end_date or t5.end_date is null)) ');
      tmp.SQL.Add('	where t5.id_driver = @driver_no and ');
      tmp.SQL.Add('		 t1.date_>= @start and ');
      tmp.SQL.Add('		 t1.date_<= @end ');
      tmp.SQL.Add('	group by t1.date_ ');
      tmp.SQL.Add('end; ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 65 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('update carnet_settings set mapcenter_host = :mapcenter_host, mapcenter_login = :mapcenter_login, mapcenter_pass = :mapcenter_pass');
      tmp.Parameters.ParamByName('mapcenter_host').Value := '';
      tmp.Parameters.ParamByName('mapcenter_login').Value := '';
      tmp.Parameters.ParamByName('mapcenter_pass').Value := CodePass('');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 66 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('update carnet_settings set sms_host = :sms_host');
      tmp.Parameters.ParamByName('sms_host').Value := '95.215.193.133';
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 67 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(222, ''Serwer niedostêpny'') ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_nonstandard(id_event) values(222) ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_has_time(id_event) values(222) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 68 then
    begin
      tmp.Close();
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add last_222_datetime datetime, ');
      tmp.SQL.Add('last_15_datetime datetime ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 69 then
    begin
      tmp.Close();
      tmp.SQL.Clear();
      tmp.SQL.Add('update car set last_15_datetime = null ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 70 then
    begin
      tmp.Close();
      tmp.SQL.Clear();
      tmp.SQL.Add('update car set last_15_datetime = null ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 71 then
    begin
      tmp.Close();
      tmp.SQL.Clear();
      tmp.SQL.Add(' ALTER VIEW [dbo].[view_cars_with_current_drivers] ');
      tmp.SQL.Add(' AS ');
      tmp.SQL.Add(' SELECT     dbo.car_change.start_date, dbo.car.id_car, dbo.car.name, dbo.car.rej_numb, dbo.car.useles, dbo.car.fast_imp, dbo.car.i_tank, dbo.car.i_up, ');
      tmp.SQL.Add('                       dbo.car.rpm_obro, dbo.car.rpm_disp, dbo.car.mileage, dbo.car.installation_date, dbo.car.phone_nr, dbo.car.fuel_algorithm, dbo.car.id_probe_type, ');
      tmp.SQL.Add('                       dbo.car.id_road_imp_div, dbo.car.id_device_type, dbo.car.use_motohours, dbo.car.rpm_id, dbo.car.id_approx_type_1, dbo.car.id_approx_type_2, ');
      tmp.SQL.Add('                       dbo.car.factor_approx_1, dbo.car.factor_approx_2, dbo.car.max_speed, dbo.car.rpm_stat, dbo.car.rpm_delay, dbo.car.power_off_on_fuel_chart, ');
      tmp.SQL.Add('                       dbo.car.ident, dbo.car.useles_city, dbo.car.useles_city_enabled, dbo.car.apn, dbo.car.alarm_tel, dbo.car.id_starter_type, dbo.car.id_email_cycle, ');
      tmp.SQL.Add('                       dbo.car.mode_30_sec, dbo.car.sms_on_start, dbo.car.gps_always_on, dbo.car.road_correction, dbo.driver.id_driver, dbo.driver.driver_name, ');
      tmp.SQL.Add('                       dbo.driver.fired, dbo.fuel_tank.max_capacity AS fuel_max1, fuel_tank_1.max_capacity AS fuel_max2, dbo.road_imp_div.imp_div, ');
      tmp.SQL.Add('                       dbo.car.dyn_data_enabled, dbo.car.dyn_data_max_bad_time, dbo.car.dyn_data_max_useles, dbo.car.filter_first, dbo.car.id_transmitter_mode, dbo.car.cistern, ');
      tmp.SQL.Add('                       dbo.car.last_gps, dbo.car.last_gps_event, dbo.car.last_gps_datetime, dbo.car.predkosc, dbo.car.paliwo, dbo.car.temperatura ');
      tmp.SQL.Add(' FROM         dbo.car INNER JOIN ');
      tmp.SQL.Add('                       dbo.road_imp_div ON dbo.car.id_road_imp_div = dbo.road_imp_div.id_road_imp_div LEFT OUTER JOIN ');
      tmp.SQL.Add('                       dbo.fuel_tank ON dbo.car.id_car = dbo.fuel_tank.id_car AND dbo.fuel_tank.tank_nr = 1 LEFT OUTER JOIN ');
      tmp.SQL.Add('                       dbo.fuel_tank AS fuel_tank_1 ON dbo.car.id_car = fuel_tank_1.id_car AND fuel_tank_1.tank_nr = 2 LEFT OUTER JOIN ');
      tmp.SQL.Add('                       dbo.car_change ON dbo.car.id_car = dbo.car_change.id_car AND dbo.car_change.end_date IS NULL LEFT OUTER JOIN ');
      tmp.SQL.Add('                       dbo.driver ON dbo.car_change.id_driver = dbo.driver.id_driver ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 72 then
    begin
      tmp.Close();
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add firmware_version2 varchar(6), LRx integer ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 73 then
    begin
      tmp.Close();
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add firmware_version2_changed datetime ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 74 then
    begin
      tmp.Close();
      tmp.SQL.Clear();
      tmp.SQL.Add('ALTER VIEW [dbo].[view_cars_with_current_drivers] ');
      tmp.SQL.Add(' AS ');
      tmp.SQL.Add(' SELECT     dbo.car_change.start_date, dbo.car.id_car, dbo.car.name, dbo.car.rej_numb, dbo.car.useles, dbo.car.fast_imp, dbo.car.i_tank, dbo.car.i_up, ');
      tmp.SQL.Add('                       dbo.car.rpm_obro, dbo.car.rpm_disp, dbo.car.mileage, dbo.car.installation_date, dbo.car.phone_nr, dbo.car.fuel_algorithm, dbo.car.id_probe_type, ');
      tmp.SQL.Add('                       dbo.car.id_road_imp_div, dbo.car.id_device_type, dbo.car.use_motohours, dbo.car.rpm_id, dbo.car.id_approx_type_1, dbo.car.id_approx_type_2, ');
      tmp.SQL.Add('                       dbo.car.factor_approx_1, dbo.car.factor_approx_2, dbo.car.max_speed, dbo.car.rpm_stat, dbo.car.rpm_delay, dbo.car.power_off_on_fuel_chart, ');
      tmp.SQL.Add('                       dbo.car.ident, dbo.car.useles_city, dbo.car.useles_city_enabled, dbo.car.apn, dbo.car.alarm_tel, dbo.car.id_starter_type, dbo.car.id_email_cycle, ');
      tmp.SQL.Add('                       dbo.car.mode_30_sec, dbo.car.sms_on_start, dbo.car.gps_always_on, dbo.car.road_correction, dbo.driver.id_driver, dbo.driver.driver_name, ');
      tmp.SQL.Add('                       dbo.driver.fired, dbo.fuel_tank.max_capacity AS fuel_max1, fuel_tank_1.max_capacity AS fuel_max2, dbo.road_imp_div.imp_div, ');
      tmp.SQL.Add('                       dbo.car.dyn_data_enabled, dbo.car.dyn_data_max_bad_time, dbo.car.dyn_data_max_useles, dbo.car.filter_first, dbo.car.id_transmitter_mode, dbo.car.cistern, ');
      tmp.SQL.Add('                       dbo.car.last_gps, dbo.car.last_gps_status, dbo.car.last_gps_event, dbo.car.last_gps_datetime, dbo.car.predkosc, dbo.car.paliwo, dbo.car.temperatura ');
      tmp.SQL.Add(' FROM         dbo.car INNER JOIN ');
      tmp.SQL.Add('                       dbo.road_imp_div ON dbo.car.id_road_imp_div = dbo.road_imp_div.id_road_imp_div LEFT OUTER JOIN ');
      tmp.SQL.Add('                       dbo.fuel_tank ON dbo.car.id_car = dbo.fuel_tank.id_car AND dbo.fuel_tank.tank_nr = 1 LEFT OUTER JOIN ');
      tmp.SQL.Add('                       dbo.fuel_tank AS fuel_tank_1 ON dbo.car.id_car = fuel_tank_1.id_car AND fuel_tank_1.tank_nr = 2 LEFT OUTER JOIN ');
      tmp.SQL.Add('                       dbo.car_change ON dbo.car.id_car = dbo.car_change.id_car AND dbo.car_change.end_date IS NULL LEFT OUTER JOIN ');
      tmp.SQL.Add('                       dbo.driver ON dbo.car_change.id_driver = dbo.driver.id_driver ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 75 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(45, ''Pomiar pr¹du'') ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 76 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table fuel_tank add max_probe int not null default 255 ');
      tmp.ExecSQL();

      for licznik13567 := 256 to 1023 do
      begin
          tmp.SQL.Clear();
          tmp.SQL.Add('insert into probe (id_probe) values(' + IntToStr(licznik13567) + ') ');
          tmp.ExecSQL();
      end;

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 77 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('create table chart_types ');
      tmp.SQL.Add('( ');
      tmp.SQL.Add('   id_chart_type int not null, ');
      tmp.SQL.Add('   chart_type_name varchar(30) not null, ');
      tmp.SQL.Add('   primary key (id_chart_type) ');
      tmp.SQL.Add(') ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('insert into chart_types (id_chart_type, chart_type_name) values(1, ''fuel'') ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('insert into chart_types (id_chart_type, chart_type_name) values(2, ''current'') ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('alter table fuel_tank add id_chart_type int not null default 1 ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('alter table fuel_tank add foreign key(id_chart_type) references chart_types (id_chart_type) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 78 then
    begin
      tmp.SQL.Clear();
//      tmp.SQL.Add('disable trigger protect_tank_nr_sequence on fuel_tank ');
      tmp.SQL.Add('drop trigger protect_tank_nr_sequence ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
//      tmp.SQL.Add('-- =============================================');
//      tmp.SQL.Add('-- Author:      Wac³aw Borowiec, Wies³aw Kubala');
//      tmp.SQL.Add('-- Create date: 2 february 2007, modify 2012-10-14');
//      tmp.SQL.Add('-- Description:	When inserting a new fuel tank into fuel_tank table, a new row');
//      tmp.SQL.Add('--              in probe_liters should be inserted for every probe (probe table).');
//      tmp.SQL.Add('--				If no probes are present in probe table the insert will not be allowed.');
//      tmp.SQL.Add('--              Each row indicates then liters amount connected with the certain');
//      tmp.SQL.Add('--              pal value. At the very beginning default values in probe_liters.liters');
//      tmp.SQL.Add('--              are inserted. The trigger needs, that only one fuel tank can be');
//      tmp.SQL.Add('--              added at a time.');
//      tmp.SQL.Add('-- =============================================');
      tmp.SQL.Add('ALTER TRIGGER [dbo].[probes_for_fuel_tank]');
      tmp.SQL.Add('   ON  [dbo].[fuel_tank]');
      tmp.SQL.Add('   AFTER INSERT');
      tmp.SQL.Add('AS');
      tmp.SQL.Add('BEGIN');
//      tmp.SQL.Add('	-- SET NOCOUNT ON added to prevent extra result sets from');
//      tmp.SQL.Add('	-- interfering with SELECT statements.');
      tmp.SQL.Add('	SET NOCOUNT ON;');
      tmp.SQL.Add('');
      tmp.SQL.Add('	if (@@ROWCOUNT > 1)');
      tmp.SQL.Add('	begin');
      tmp.SQL.Add('			raiserror(''Adding multiple fuel tanks at a time is forbidden.'',16,1);');
      tmp.SQL.Add('	        rollback transaction;');
      tmp.SQL.Add('			return;');
      tmp.SQL.Add('	end');
      tmp.SQL.Add('');
//      tmp.SQL.Add('	-- Check if there are any probes.');
      tmp.SQL.Add('	declare @num_probes int;');
      tmp.SQL.Add('	set @num_probes = (select count(*) from probe);');
      tmp.SQL.Add('	if (@num_probes = 0)');
      tmp.SQL.Add('	begin');
      tmp.SQL.Add('			raiserror(''No probes present in probe table.'',16,1);');
      tmp.SQL.Add('			rollback transaction;');
      tmp.SQL.Add('			return;');
      tmp.SQL.Add('	end');
      tmp.SQL.Add('');
      tmp.SQL.Add('	declare @id_probe int;');
//      tmp.SQL.Add('	-- Id of the fuel tank for which data is being inserted.');
      tmp.SQL.Add('	declare @id_fuel_tank int;');
//      tmp.SQL.Add('	-- Cursor to iterate through probes form probe table');
      tmp.SQL.Add('	declare probe_cursor cursor');
      tmp.SQL.Add('		for select id_probe from probe');
      tmp.SQL.Add('		order by id_probe');
      tmp.SQL.Add('		for read only;');
      tmp.SQL.Add('	declare @max_probe int;');
      tmp.SQL.Add('');
      tmp.SQL.Add('	open probe_cursor;');
//      tmp.SQL.Add('	-- Get the current fuel tank''s id.');
      tmp.SQL.Add('	set @id_fuel_tank = (select id_fuel_tank from INSERTED);');
      tmp.SQL.Add('	set @max_probe    = (select max_probe from INSERTED);');
//      tmp.SQL.Add('	-- Fetch first probe.');
      tmp.SQL.Add('	fetch probe_cursor into @id_probe;');
//      tmp.SQL.Add('	-- @@FETCH_STATUS should be equal to 0 on successfull fetch');
//      tmp.SQL.Add('	-- When there''s no more data, it is negative.');
      tmp.SQL.Add('	while  @@FETCH_STATUS = 0');
      tmp.SQL.Add('	begin');
//      tmp.SQL.Add('	        -- Insert default value to probe_liters');
      tmp.SQL.Add('	        insert into probe_liters values ( @id_fuel_tank, @id_probe, default)');
//      tmp.SQL.Add('	        -- Get next probe');
      tmp.SQL.Add('	        fetch probe_cursor into @id_probe;');
      tmp.SQL.Add('');
      tmp.SQL.Add('	        if @id_probe > @max_probe');
      tmp.SQL.Add('				break;');
      tmp.SQL.Add('	end');
      tmp.SQL.Add('	print ''probes_for_fuel_tank trigger on dbo.fuel_tank executed successfully'';');
      tmp.SQL.Add('	deallocate probe_cursor;');
      tmp.SQL.Add('END');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 79 then
    begin
      tmp.SQL.Clear();
//      tmp.SQL.Add('-- =============================================');
//      tmp.SQL.Add('-- Author:	Waclaw Borowiec');
//      tmp.SQL.Add('-- Create date: 24 feb 2007');
//      tmp.SQL.Add('-- Description:	Funkcja wylicza ilosc paliwa w jednostkach u¿ytkownika na podstawie 4 i 9 bajtu zdarzenia.');
//      tmp.SQL.Add('-- =============================================');
      tmp.SQL.Add('ALTER FUNCTION [dbo].[compute_fuel]');
      tmp.SQL.Add('(');
      tmp.SQL.Add('	@id_fuel_tank int,');
      tmp.SQL.Add('  @evb3 int,');
      tmp.SQL.Add('	@evb4 int,');
      tmp.SQL.Add('	@evb9 int');
      tmp.SQL.Add(')');
      tmp.SQL.Add('RETURNS numeric(10,1)');
      tmp.SQL.Add('AS');
      tmp.SQL.Add('BEGIN');
      tmp.SQL.Add('        declare @liters numeric(10,1);');
      tmp.SQL.Add('        declare @liters_next numeric(10,1);');
      tmp.SQL.Add('        declare @accuracy bit;');
      tmp.SQL.Add('');
//      tmp.SQL.Add('        -- odczytaj ilosc litrow ze wskazania sondy');
      tmp.SQL.Add('	set @liters = (select liters from view_probe_liters_fuel_tank where id_probe=@evb4 and id_fuel_tank=@id_fuel_tank);');
//      tmp.SQL.Add('        -- jesli dokladnosc uwzglednia ulamki pali, zastosuj odpowiedni wzor');
      tmp.SQL.Add('        set @accuracy = (select measure_accuracy from event_with_fuel where id_event=@evb3);');
//      tmp.SQL.Add('        -- jesli dokladnosc uwzglednia ulamki pali, zastosuj odpowiedni wzor');
      tmp.SQL.Add('        if (@accuracy = 1)');
      tmp.SQL.Add('        begin');
//      tmp.SQL.Add('                -- pobierz ilosc litrow dla wyzszej wartosci pala');
      tmp.SQL.Add('                set @liters_next = (select liters from view_probe_liters_fuel_tank where id_probe=@evb4+1 and id_fuel_tank=@id_fuel_tank);');
//      tmp.SQL.Add('                -- sprawdz czy dany odczyt nie jest wartoscia maksymalna');
      tmp.SQL.Add('                if (@liters_next is not NULL) ');
      tmp.SQL.Add('                begin');
      tmp.SQL.Add('                        set @liters = @liters + (@liters_next-@liters)*(cast(@evb9 as numeric(10,1))/256);');
      tmp.SQL.Add('                end');
      tmp.SQL.Add('');
      tmp.SQL.Add('        end');
      tmp.SQL.Add('        return @liters;');
      tmp.SQL.Add('END');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 80 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('ALTER FUNCTION [dbo].[compute_fuel_pal]');
      tmp.SQL.Add('(');
      tmp.SQL.Add('	@tank_nr int,');
      tmp.SQL.Add('  @evb3 int,');
      tmp.SQL.Add('	@evb4 int,');
      tmp.SQL.Add('	@evb9 int');
      tmp.SQL.Add(')');
      tmp.SQL.Add('RETURNS numeric(10,3)');
      tmp.SQL.Add('AS');
      tmp.SQL.Add('BEGIN');
      tmp.SQL.Add('    declare @pals numeric(10,3);');
      tmp.SQL.Add('    declare @accuracy bit;');
      tmp.SQL.Add('');
      tmp.SQL.Add('	set @pals = @evb4;');
      tmp.SQL.Add('    set @accuracy = (select measure_accuracy from event_with_fuel where id_event=@evb3 and tank_nr=@tank_nr);');
      tmp.SQL.Add('');
      tmp.SQL.Add('    if (@accuracy = 1)');
      tmp.SQL.Add('		set @pals = @pals + @evb9/256;');
      tmp.SQL.Add('    return @pals;');
      tmp.SQL.Add('END');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 81 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('create table cycle_type ');
      tmp.SQL.Add('( ');
      tmp.SQL.Add('	id_cycle_type integer not null, ');
      tmp.SQL.Add('	name varchar(30), ');
      tmp.SQL.Add('	primary key (id_cycle_type) ');
      tmp.SQL.Add('); ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('insert into cycle_type (id_cycle_type, name) values(1, ''Work cycle''); ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('insert into cycle_type (id_cycle_type, name) values(2, ''Tariff''); ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('create table cycle ');
      tmp.SQL.Add('( ');
      tmp.SQL.Add('	id_cycle integer not null identity(1, 1), ');
      tmp.SQL.Add('	id_cycle_type integer not null, ');
      tmp.SQL.Add('	name varchar(50), ');
      tmp.SQL.Add('	primary key (id_cycle), ');
      tmp.SQL.Add('	foreign key (id_cycle_type) references cycle_type (id_cycle_type) ');
      tmp.SQL.Add('); ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('create table cycle_item ');
      tmp.SQL.Add('( ');
      tmp.SQL.Add('	id_cycle_item integer not null identity(1, 1), ');
      tmp.SQL.Add('	id_cycle integer not null, ');
      tmp.SQL.Add('	order_ integer not null, ');
      tmp.SQL.Add('	name varchar(50), ');
      tmp.SQL.Add('	hour_from integer, ');
      tmp.SQL.Add('	minute_from integer, ');
      tmp.SQL.Add('	second_from integer, ');
      tmp.SQL.Add('	hour_to integer, ');
      tmp.SQL.Add('	minute_to integer, ');
      tmp.SQL.Add('	second_to integer, ');
      tmp.SQL.Add('	kWh_cost numeric(10, 2), ');
      tmp.SQL.Add('	primary key (id_cycle_item), ');
      tmp.SQL.Add('	foreign key (id_cycle) references cycle (id_cycle) on update cascade on delete cascade ');
      tmp.SQL.Add(') ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 82 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('ALTER PROCEDURE [dbo].modifyFuelCharacterization ');
      tmp.SQL.Add('	@cslist VARCHAR(8000), ');
      tmp.SQL.Add('	@id_fuel_tank INT ');
      tmp.SQL.Add('AS ');
      tmp.SQL.Add('BEGIN ');
      tmp.SQL.Add('	SET NOCOUNT ON; ');
      tmp.SQL.Add('	declare probe_cursor2 cursor ');
      tmp.SQL.Add('		for select id_probe from probe ');
      tmp.SQL.Add('		for read only; ');
      tmp.SQL.Add('	declare @num_probes int; ');
      tmp.SQL.Add('	declare @num_args int; ');
      tmp.SQL.Add('	declare @id_probe int; ');
      tmp.SQL.Add('	declare @argv numeric(10,1); ');
      tmp.SQL.Add('    create table #__tmptbl (val numeric(10,1)) ');
      tmp.SQL.Add('    declare args_cursor cursor ');
      tmp.SQL.Add('        for select val from #__tmptbl ');
      tmp.SQL.Add('        for read only; ');
      tmp.SQL.Add('    exec IntListToTable @cslist,''#__tmptbl''; ');
      tmp.SQL.Add('    set @num_probes = (select max_probe + 1 from fuel_tank where @id_fuel_tank = @id_fuel_tank); ');
      tmp.SQL.Add('    set @num_args = (select count(*) from #__tmptbl); ');
      tmp.SQL.Add('    if (@num_probes != @num_args) ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('        raiserror(''Wrong number of values in first argument'',16,1); ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('    else ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('		open probe_cursor2; ');
      tmp.SQL.Add('		open args_cursor; ');
      tmp.SQL.Add('		fetch probe_cursor2 into @id_probe; ');
      tmp.SQL.Add('		fetch args_cursor into @argv; ');
      tmp.SQL.Add('		begin transaction; ');
      tmp.SQL.Add('		while  @@FETCH_STATUS = 0 ');
      tmp.SQL.Add('		begin ');
      tmp.SQL.Add('				update probe_liters set liters=@argv where id_probe=@id_probe and id_fuel_tank=@id_fuel_tank; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('				fetch probe_cursor2 into @id_probe; ');
      tmp.SQL.Add('				fetch args_cursor into @argv; ');
      tmp.SQL.Add('		end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('		commit transaction; ');
      tmp.SQL.Add('		print ''modifyFuelCharacterization stored procedure execution finished with success''; ');
      tmp.SQL.Add('	end ');
      tmp.SQL.Add('    drop table #__tmptbl; ');
      tmp.SQL.Add('    deallocate probe_cursor2; ');
      tmp.SQL.Add('	deallocate args_cursor; ');
      tmp.SQL.Add('END ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 83 then
    begin
      tmp.Close();
      tmp.SQL.Clear();
      tmp.SQL.Add('update car set last_15_datetime = null ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('update car set last_222_datetime = null ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 84 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table cycle add default_ integer ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('alter table cycle_item add date_from datetime, date_to datetime ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('alter table cycle add last_used datetime not null default (GETDATE()) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 85 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add imax numeric(12, 2) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 86 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('create table settings_history ');
      tmp.SQL.Add('( ');
      tmp.SQL.Add('	id_settings_history integer not null identity(1, 1), ');
      tmp.SQL.Add('	change_date datetime, ');
      tmp.SQL.Add('	xml image, ');
      tmp.SQL.Add('	car_count int, ');
      tmp.SQL.Add('	bin image, ');
      tmp.SQL.Add('	send_date datetime, ');
      tmp.SQL.Add('	del_car_id int, ');
      tmp.SQL.Add('	del_car_name varchar(50), ');
      tmp.SQL.Add('	del_car_rej_numb varchar(15), ');
      tmp.SQL.Add('	default_ integer ');
      tmp.SQL.Add(') ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;


    if version = 87 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('delete from settings_history ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 88 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('delete from settings_history ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 89 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('delete from settings_history ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 90 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('delete from settings_history ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 91 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('delete from settings_history ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 92 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add to_delete int ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 93 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('delete from settings_history ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 94 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(123, ''Dok³adny pomiar paliwa'') ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_has_time(id_event) values(123) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 95 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('ALTER PROCEDURE [dbo].modifyFuelCharacterization ');
      tmp.SQL.Add('	@cslist VARCHAR(8000), ');
      tmp.SQL.Add('	@id_fuel_tank INT ');
      tmp.SQL.Add('AS ');
      tmp.SQL.Add('BEGIN ');
      tmp.SQL.Add('	SET NOCOUNT ON; ');
      tmp.SQL.Add('	declare probe_cursor2 cursor ');
      tmp.SQL.Add('		for select id_probe from probe ');
      tmp.SQL.Add('		for read only; ');
      tmp.SQL.Add('	declare @num_probes int; ');
      tmp.SQL.Add('	declare @num_args int; ');
      tmp.SQL.Add('	declare @id_probe int; ');
      tmp.SQL.Add('	declare @argv numeric(10,1); ');
      tmp.SQL.Add('    create table #__tmptbl (val numeric(10,1)) ');
      tmp.SQL.Add('    declare args_cursor cursor ');
      tmp.SQL.Add('        for select val from #__tmptbl ');
      tmp.SQL.Add('        for read only; ');
      tmp.SQL.Add('    exec IntListToTable @cslist,''#__tmptbl''; ');
      tmp.SQL.Add('    select @num_probes = (max_probe + 1) from fuel_tank where @id_fuel_tank = @id_fuel_tank; ');
      tmp.SQL.Add('    select @num_args = count(*) from #__tmptbl; ');
      tmp.SQL.Add('    if (@num_probes != @num_args) ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('        raiserror(''Wrong number of values in first argument'',16,1); ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('    else ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('		open probe_cursor2; ');
      tmp.SQL.Add('		open args_cursor; ');
      tmp.SQL.Add('		fetch probe_cursor2 into @id_probe; ');
      tmp.SQL.Add('		fetch args_cursor into @argv; ');
      tmp.SQL.Add('		begin transaction; ');
      tmp.SQL.Add('		while  @@FETCH_STATUS = 0 ');
      tmp.SQL.Add('		begin ');
      tmp.SQL.Add('				update probe_liters set liters=@argv where id_probe=@id_probe and id_fuel_tank=@id_fuel_tank; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('				fetch probe_cursor2 into @id_probe; ');
      tmp.SQL.Add('				fetch args_cursor into @argv; ');
      tmp.SQL.Add('		end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('		commit transaction; ');
      tmp.SQL.Add('		print ''modifyFuelCharacterization stored procedure execution finished with success''; ');
      tmp.SQL.Add('	end ');
      tmp.SQL.Add('    drop table #__tmptbl; ');
      tmp.SQL.Add('    deallocate probe_cursor2; ');
      tmp.SQL.Add('	deallocate args_cursor; ');
      tmp.SQL.Add('END ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 96 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(124, ''Dok³adny pomiar paliwa na postoju'') ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_has_time(id_event) values(124) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 97 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add(' update event_with_fuel set measure_accuracy = 0 ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 98 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add(' update event_with_fuel set measure_accuracy = 1 ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 99 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('delete from settings_history ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 100 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add(' update event_with_fuel set measure_accuracy = 0 ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 101 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(125, ''Pomiar napiêcia'') ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_has_time(id_event) values(125) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 102 then
    begin
      tmp.Close();
      tmp.SQL.Clear();
      tmp.SQL.Add('IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N''[dbo].[cache_day_work]'') AND OBJECTPROPERTY(id, N''IsUserTable'') = 1)');
      tmp.SQL.Add('BEGIN ');
      tmp.SQL.Add('  CREATE TABLE cache_day_work( ');
      tmp.SQL.Add('  	id int IDENTITY(1,1) NOT NULL, ');
      tmp.SQL.Add('  	evb2 int NULL, ');
      tmp.SQL.Add('  	dzien varchar(5) NULL, ');
      tmp.SQL.Add('  	data datetime NULL, ');
      tmp.SQL.Add('  	week int NULL, ');
      tmp.SQL.Add('  	month int NULL, ');
      tmp.SQL.Add('  	przebieg numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	opis varchar(200) NULL, ');
      tmp.SQL.Add('  	ile_praca varchar(20) NULL, ');
      tmp.SQL.Add('  	ile_praca_sek int NULL, ');
      tmp.SQL.Add('  	ile_postoj varchar(20) NULL, ');
      tmp.SQL.Add('  	ile_postoj_sek int NULL, ');
      tmp.SQL.Add('  	ile_jalowy varchar(20) NULL, ');
      tmp.SQL.Add('  	ile_jalowy_sek int NULL, ');
      tmp.SQL.Add('  	marka_pojazdu varchar(250) NULL, ');
      tmp.SQL.Add('  	nr_rej_pojazdu varchar(200) NULL, ');
      tmp.SQL.Add('  	kierowca varchar(100) NULL, ');
      tmp.SQL.Add('  	start_praca datetime NULL, ');
      tmp.SQL.Add('  	stop_praca datetime NULL, ');
      tmp.SQL.Add('  	start_postoj datetime NULL, ');
      tmp.SQL.Add('  	stop_postoj datetime NULL, ');
      tmp.SQL.Add('  	summary_przebieg_day numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	summary_przebieg_week numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	summary_przebieg_month numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	summary_przebieg_all numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	summary_praca_day varchar(20) NULL, ');
      tmp.SQL.Add('  	summary_praca_week varchar(20) NULL, ');
      tmp.SQL.Add('  	summary_praca_month varchar(20) NULL, ');
      tmp.SQL.Add('  	summary_praca_all varchar(20) NULL, ');
      tmp.SQL.Add('  	summary_postoj_day varchar(20) NULL, ');
      tmp.SQL.Add('  	summary_postoj_week varchar(20) NULL, ');
      tmp.SQL.Add('  	summary_postoj_month varchar(20) NULL, ');
      tmp.SQL.Add('  	summary_postoj_all varchar(20) NULL, ');
      tmp.SQL.Add('  	summary_jalowy_day varchar(20) NULL, ');
      tmp.SQL.Add('  	summary_jalowy_week varchar(20) NULL, ');
      tmp.SQL.Add('  	summary_jalowy_month varchar(20) NULL, ');
      tmp.SQL.Add('  	summary_jalowy_all varchar(20) NULL, ');
      tmp.SQL.Add('  	summary_paliwo_sum numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	summary_paliwo_srednio numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	summary_paliwo_koszt numeric(10, 2) NULL, ');
      tmp.SQL.Add('  	group_id int NULL, ');
      tmp.SQL.Add('  	ulica_start varchar(50) NULL, ');
      tmp.SQL.Add('  	ulica_stop varchar(50) NULL, ');
      tmp.SQL.Add('  	szerokosc0 varchar(30) NULL, ');
      tmp.SQL.Add('  	dlugosc0 varchar(30) NULL, ');
      tmp.SQL.Add('  	szerokosc varchar(30) NULL, ');
      tmp.SQL.Add('  	dlugosc varchar(30) NULL, ');
      tmp.SQL.Add('  	srednio numeric(10, 1) NULL, ');
      tmp.SQL.Add('  	first_event_datetime datetime NULL, ');
      tmp.SQL.Add('  	last_event_datetime datetime NULL, ');
      tmp.SQL.Add('    primary key (id) ');
      tmp.SQL.Add('  ) ');
      tmp.SQL.Add('END ');
      tmp.ExecSQL();

      tmp.Close();
      tmp.SQL.Clear();
      tmp.SQL.Add('IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N''[dbo].[cache_refueling]'') AND OBJECTPROPERTY(id, N''IsUserTable'') = 1)');
      tmp.SQL.Add('BEGIN ');
      tmp.SQL.Add('  CREATE TABLE dbo.cache_refueling( ');
      tmp.SQL.Add('  	id int IDENTITY(1,1) NOT NULL, ');
      tmp.SQL.Add('  	id_car int NOT NULL, ');
      tmp.SQL.Add('  	_117 datetime NULL, ');
      tmp.SQL.Add('  	_118 datetime NULL, ');
      tmp.SQL.Add('  	sonda numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	from_sonda numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	from_sonda_pal numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	to_sonda numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	to_sonda_pal numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	from_sonda2 numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	from_sonda2_pal numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	to_sonda2 numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	to_sonda2_pal numeric(10, 3) NULL, ');
      tmp.SQL.Add('  	was_15 int NULL, ');
      tmp.SQL.Add('  	czy_dynamiczny int NULL, ');
      tmp.SQL.Add('  	first_event_datetime datetime NULL, ');
      tmp.SQL.Add('  	last_event_datetime datetime NULL, ');
      tmp.SQL.Add('    primary key (id) ');
      tmp.SQL.Add('  ) ');
      tmp.SQL.Add('END ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 103 then
    begin
//      UaktualnijProcedureTankowania();
//      UaktualnijProcedureCzasuPracy();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 104 then
    begin

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 105 then
    begin
      tmp.SQL.Clear();

      tmp.SQL.Add('ALTER procedure [dbo].[spPaliwo] ');
      tmp.SQL.Add('	@carno integer, ');
      tmp.SQL.Add('	@evb3 integer, ');
      tmp.SQL.Add('	@nr_zb integer, ');
      tmp.SQL.Add('	@pal integer, ');
      tmp.SQL.Add('	@mpal integer, ');
      tmp.SQL.Add('	@wynik numeric(10, 3) OUTPUT ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('    if (@mpal <> 0) and (@mpal <> 64) and (@mpal <> 128) and (@mpal <> 192) ');
      tmp.SQL.Add('        set @mpal = 0; ');
      tmp.SQL.Add('    if (@mpal = 64)  ');
      tmp.SQL.Add('        set @mpal = 1 ');
      tmp.SQL.Add('    else ');
      tmp.SQL.Add('    if (@mpal = 128)  ');
      tmp.SQL.Add('        set @mpal = 2 ');
      tmp.SQL.Add('    else ');
      tmp.SQL.Add('    if (@mpal = 192)  ');
      tmp.SQL.Add('        set @mpal = 3 ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	create table #eee ');
      tmp.SQL.Add('	( ');
      tmp.SQL.Add('		ltr numeric(10, 3) ');
      tmp.SQL.Add('	) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	declare @id_fuel_tank integer ');
      tmp.SQL.Add('	declare @max_probe integer ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	if(@pal <= 0) ');
      tmp.SQL.Add('		select @wynik = 0 ');
      tmp.SQL.Add('	else ');
      tmp.SQL.Add('	begin ');
      tmp.SQL.Add('		select @id_fuel_tank = id_fuel_tank, @max_probe = max_probe from fuel_tank where id_car = @carno and tank_nr = @nr_zb ');
      tmp.SQL.Add('		if (@max_probe = 255  or  @max_probe = 0) ');
      tmp.SQL.Add('		begin ');
      tmp.SQL.Add('			set @wynik = dbo.compute_fuel(@id_fuel_tank, @evb3, ');
      tmp.SQL.Add('					@pal, ');
      tmp.SQL.Add('					0); ');
      tmp.SQL.Add('		end ');
      tmp.SQL.Add('		else ');
      tmp.SQL.Add('		if (@max_probe = 1023) ');
      tmp.SQL.Add('		begin ');
      tmp.SQL.Add('			set @wynik = dbo.compute_fuel(@id_fuel_tank, @evb3, ');
      tmp.SQL.Add('					((@pal - 1) * 4) + 1 + @mpal, ');
      tmp.SQL.Add('					0); ');
      tmp.SQL.Add('		end ');
      tmp.SQL.Add('	end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	declare @enabled1 integer ');
      tmp.SQL.Add('	declare @wsp1 integer ');
      tmp.SQL.Add('	declare @kind1 integer ');
      tmp.SQL.Add('	declare @start_pos1_bak1 integer ');
      tmp.SQL.Add('	declare @start_pos1_bak2 integer ');
      tmp.SQL.Add('	declare @enabled2 integer ');
      tmp.SQL.Add('	declare @wsp2 integer ');
      tmp.SQL.Add('	declare @kind2 integer ');
      tmp.SQL.Add('	declare @start_pos2_bak1 integer ');
      tmp.SQL.Add('	declare @start_pos2_bak2 integer ');
      tmp.SQL.Add('	declare @wynik1 numeric(10, 3) ');
      tmp.SQL.Add('	declare @wynik2 numeric(10, 3) ');
      tmp.SQL.Add(' 	declare @suma numeric(10, 3) ');
      tmp.SQL.Add('	declare @licznik integer ');
      tmp.SQL.Add('	declare @i integer ');
      tmp.SQL.Add('	declare @memi numeric(10, 3) ');
      tmp.SQL.Add('	declare @memj numeric(10, 3) ');
      tmp.SQL.Add('	declare @start_pos1 integer ');
      tmp.SQL.Add('	declare @start_pos2 integer ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	select @enabled1 = enabled1 from #aproksymacja_params ');
      tmp.SQL.Add('	select @wsp1 = wsp1 from #aproksymacja_params ');
      tmp.SQL.Add('	select @kind1 = kind1 from #aproksymacja_params ');
      tmp.SQL.Add('	select @start_pos1_bak1 = start_pos1_bak1 from #aproksymacja_params ');
      tmp.SQL.Add('	select @start_pos1_bak2 = start_pos1_bak2 from #aproksymacja_params ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	select @enabled2 = enabled2 from #aproksymacja_params ');
      tmp.SQL.Add('	select @wsp2 = wsp2 from #aproksymacja_params ');
      tmp.SQL.Add('	select @kind2 = kind2 from #aproksymacja_params ');
      tmp.SQL.Add('	select @start_pos2_bak1 = start_pos2_bak1 from #aproksymacja_params ');
      tmp.SQL.Add('	select @start_pos2_bak2 = start_pos2_bak2 from #aproksymacja_params ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	if (@enabled1 is not null) and (@enabled1 = 1) and (@wynik is not null) ');
      tmp.SQL.Add('		and (@evb3 <> 117) and (@evb3 <> 118) and (@evb3 <> 217) and (@evb3 <> 218) ');
      tmp.SQL.Add('	begin ');
      tmp.SQL.Add('		if @nr_zb = 1 ');
      tmp.SQL.Add('		begin ');
      tmp.SQL.Add('			update #aproksymacja set ltr = @wynik where id = @start_pos1_bak1 and nr_zb = @nr_zb and step = 1 ');
      tmp.SQL.Add('			select @start_pos1_bak1 = @start_pos1_bak1 + 1 ');
      tmp.SQL.Add('			if @start_pos1_bak1 >= @wsp1 ');
      tmp.SQL.Add('				select @start_pos1_bak1 = 0 ');
      tmp.SQL.Add('			select @start_pos1 = @start_pos1_bak1 ');
      tmp.SQL.Add('		end ');
      tmp.SQL.Add('		else ');
      tmp.SQL.Add('		if @nr_zb = 2 ');
      tmp.SQL.Add('		begin ');
      tmp.SQL.Add('			update #aproksymacja set ltr = @wynik where id = @start_pos1_bak2 and nr_zb = @nr_zb and step = 1 ');
      tmp.SQL.Add('			select @start_pos1_bak2 = @start_pos1_bak2 + 1 ');
      tmp.SQL.Add('			if @start_pos1_bak2 >= @wsp1 ');
      tmp.SQL.Add('				select @start_pos1_bak2 = 0 ');
      tmp.SQL.Add('			select @start_pos1 = @start_pos1_bak2 ');
      tmp.SQL.Add('		end ');
      tmp.SQL.Add('		update #aproksymacja_params set start_pos1_bak1 = @start_pos1_bak1, start_pos1_bak2 = @start_pos1_bak2 ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('		if @kind1 = 1 ');
      tmp.SQL.Add('		begin ');
      tmp.SQL.Add('			delete from #eee ');
      tmp.SQL.Add('			insert into #eee (ltr) ');
      tmp.SQL.Add('				SELECT TOP 50 PERCENT ltr ');
      tmp.SQL.Add('				FROM #aproksymacja ');
      tmp.SQL.Add('				WHERE nr_zb = @nr_zb and step = 1 and ltr <> 1000000.0 ');
      tmp.SQL.Add('				ORDER BY ltr ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('			SELECT @wynik1 = (SELECT TOP 1 ltr from #eee order by ltr DESC) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('			IF (SELECT COUNT(*) % 2 FROM #aproksymacja ');
      tmp.SQL.Add('				WHERE nr_zb = @nr_zb and step = 1 and ltr <> 1000000.0) = 1 ');
      tmp.SQL.Add('			begin ');
      tmp.SQL.Add('				select @wynik = @wynik1 ');
      tmp.SQL.Add('			end ');
      tmp.SQL.Add('			else ');
      tmp.SQL.Add('			begin ');
      tmp.SQL.Add('				delete from #eee ');
      tmp.SQL.Add('				insert into #eee (ltr) ');
      tmp.SQL.Add('					SELECT TOP 50 PERCENT ltr ');
      tmp.SQL.Add('					FROM #aproksymacja ');
      tmp.SQL.Add('					WHERE nr_zb = @nr_zb and step = 1 and ltr <> 1000000.0 ');
      tmp.SQL.Add('					ORDER BY ltr DESC ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('				SELECT @wynik2 = (SELECT TOP 1 ltr from #eee order by ltr) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('				select @wynik = (@wynik1 + @wynik2) / 2.0 ');
      tmp.SQL.Add('			end ');
      tmp.SQL.Add('		end ');
      tmp.SQL.Add('		else ');
      tmp.SQL.Add('		if @kind1 = 2 ');
      tmp.SQL.Add('		begin ');
      tmp.SQL.Add('			SELECT @wynik1 = AVG(ltr) ');
      tmp.SQL.Add('			FROM #aproksymacja ');
      tmp.SQL.Add('			WHERE nr_zb = @nr_zb and step = 1 and ltr <> 1000000.0 ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('			select @wynik = @wynik1 ');
      tmp.SQL.Add('		end ');
      tmp.SQL.Add('		else ');
      tmp.SQL.Add('		if @kind1 = 3 ');
      tmp.SQL.Add('		begin ');
      tmp.SQL.Add('			select @suma = 0.0 ');
      tmp.SQL.Add('			select @licznik = 0 ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('			select @i = @start_pos1 - 1 ');
      tmp.SQL.Add('			while (@i >= (@start_pos1 - @wsp1)) ');
      tmp.SQL.Add('			begin ');
      tmp.SQL.Add('				select @memi = ltr from #aproksymacja where id = ((@i + @wsp1) % @wsp1) ');
      tmp.SQL.Add('						and nr_zb = @nr_zb and step = 1 ');
      tmp.SQL.Add('				if @memi <> 1000000 ');
      tmp.SQL.Add('				begin ');
      tmp.SQL.Add('				    select @suma = @suma + cast((@memi * @memi) as numeric(10, 3)) ');
      tmp.SQL.Add('				    select @licznik = @licznik + 1 ');
      tmp.SQL.Add('				end ');
      tmp.SQL.Add('				select @i = @i - 1 ');
      tmp.SQL.Add('			end; ');
      tmp.SQL.Add('			if @licznik <> 0 ');
      tmp.SQL.Add('			begin ');
      tmp.SQL.Add('				select @wynik = cast(sqrt(@suma / @licznik) as numeric(10, 3)) ');
      tmp.SQL.Add('			end ');
      tmp.SQL.Add('		end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('		if (@enabled2 is not null) and (@enabled2 = 1) ');
      tmp.SQL.Add('		begin ');
      tmp.SQL.Add('			if @nr_zb = 1 ');
      tmp.SQL.Add('			begin ');
      tmp.SQL.Add('				update #aproksymacja set ltr = @wynik where id = @start_pos2_bak1 and nr_zb = @nr_zb and step = 2 ');
      tmp.SQL.Add('				select @start_pos2_bak1 = @start_pos2_bak1 + 1 ');
      tmp.SQL.Add('				if @start_pos2_bak1 >= @wsp2 ');
      tmp.SQL.Add('					select @start_pos2_bak1 = 0 ');
      tmp.SQL.Add('				select @start_pos2 = @start_pos2_bak1 ');
      tmp.SQL.Add('			end ');
      tmp.SQL.Add('			else ');
      tmp.SQL.Add('			if @nr_zb = 2 ');
      tmp.SQL.Add('			begin ');
      tmp.SQL.Add('				update #aproksymacja set ltr = @wynik where id = @start_pos2_bak2 and nr_zb = @nr_zb and step = 2 ');
      tmp.SQL.Add('				select @start_pos2_bak2 = @start_pos2_bak2 + 1 ');
      tmp.SQL.Add('				if @start_pos2_bak2 >= @wsp2 ');
      tmp.SQL.Add('					select @start_pos2_bak2 = 0 ');
      tmp.SQL.Add('				select @start_pos2 = @start_pos2_bak2 ');
      tmp.SQL.Add('			end ');
      tmp.SQL.Add('			update #aproksymacja_params set start_pos2_bak1 = @start_pos2_bak1, start_pos2_bak2 = @start_pos2_bak2 ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('			if @kind2 = 1 ');
      tmp.SQL.Add('			begin ');
      tmp.SQL.Add('				delete from #eee ');
      tmp.SQL.Add('				insert into #eee (ltr) ');
      tmp.SQL.Add('					SELECT TOP 50 PERCENT ltr ');
      tmp.SQL.Add('					FROM #aproksymacja ');
      tmp.SQL.Add('					WHERE nr_zb = @nr_zb and step = 2 and ltr <> 1000000.0 ');
      tmp.SQL.Add('					ORDER BY ltr ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('				SELECT @wynik1 = (SELECT TOP 1 ltr from #eee order by ltr DESC) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('				IF (SELECT COUNT(*) % 2 FROM #aproksymacja ');
      tmp.SQL.Add('					WHERE nr_zb = @nr_zb and step = 2 and ltr <> 1000000.0) = 1 ');
      tmp.SQL.Add('				begin ');
      tmp.SQL.Add('					select @wynik = @wynik1 ');
      tmp.SQL.Add('				end ');
      tmp.SQL.Add('				else ');
      tmp.SQL.Add('				begin ');
      tmp.SQL.Add('					delete from #eee ');
      tmp.SQL.Add('					insert into #eee (ltr) ');
      tmp.SQL.Add('						SELECT TOP 50 PERCENT ltr ');
      tmp.SQL.Add('						FROM #aproksymacja ');
      tmp.SQL.Add('						WHERE nr_zb = @nr_zb and step = 2 and ltr <> 1000000.0 ');
      tmp.SQL.Add('						ORDER BY ltr DESC ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('					SELECT @wynik2 = (SELECT TOP 1 ltr from #eee order by ltr) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('					select @wynik = (@wynik1 + @wynik2) / 2.0 ');
      tmp.SQL.Add('				end ');
      tmp.SQL.Add('			end ');
      tmp.SQL.Add('			else ');
      tmp.SQL.Add('			if @kind2 = 2 ');
      tmp.SQL.Add('			begin ');
      tmp.SQL.Add('				SELECT @wynik1 = AVG(ltr) ');
      tmp.SQL.Add('				FROM #aproksymacja ');
      tmp.SQL.Add('				WHERE nr_zb = @nr_zb and step = 2 and ltr <> 1000000.0 ');
      tmp.SQL.Add('				select @wynik = @wynik1 ');
      tmp.SQL.Add('			end ');
      tmp.SQL.Add('			else ');
      tmp.SQL.Add('			if @kind2 = 3 ');
      tmp.SQL.Add('			begin ');
      tmp.SQL.Add('				select @suma = 0.0 ');
      tmp.SQL.Add('				select @licznik = 0 ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('				select @i = @start_pos2 - 1 ');
      tmp.SQL.Add('				while (@i >= (@start_pos2 - @wsp2)) ');
      tmp.SQL.Add('				begin ');
      tmp.SQL.Add('					select @memi = ltr from #aproksymacja where id = ((@i + @wsp2) % @wsp2) ');
      tmp.SQL.Add('							and nr_zb = @nr_zb and step = 2 ');
      tmp.SQL.Add('					if @memi <> 1000000 ');
      tmp.SQL.Add('					begin ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('					    select @suma = @suma + cast((@memi * @memi) as numeric(10, 3)) ');
      tmp.SQL.Add('						select @licznik = @licznik + 1 ');
      tmp.SQL.Add('					end ');
      tmp.SQL.Add('					select @i = @i - 1 ');
      tmp.SQL.Add('				end; ');
      tmp.SQL.Add('				if @licznik <> 0 ');
      tmp.SQL.Add('				begin ');
      tmp.SQL.Add('					select @wynik = cast(sqrt(@suma / @licznik) as numeric(10, 3)) ');
      tmp.SQL.Add('				end ');
      tmp.SQL.Add('			end ');
      tmp.SQL.Add('		end ');
      tmp.SQL.Add('	end ');
      tmp.SQL.Add('	else ');
      tmp.SQL.Add('	if (@enabled1 is not null) and (@enabled1 = 1) and (@wynik is not null) ');
      tmp.SQL.Add('		and ((@evb3 = 118) or (@evb3 = 218)) ');
      tmp.SQL.Add('	begin ');
      tmp.SQL.Add('		if @nr_zb = 1 ');
      tmp.SQL.Add('		begin ');
      tmp.SQL.Add('			update #aproksymacja set ltr = @wynik where id = @start_pos1_bak1 and nr_zb = @nr_zb and step = 1 ');
      tmp.SQL.Add('			select @start_pos1_bak1 = @start_pos1_bak1 + 1 ');
      tmp.SQL.Add('			if @start_pos1_bak1 >= @wsp1 ');
      tmp.SQL.Add('				select @start_pos1_bak1 = 0 ');
      tmp.SQL.Add('		end ');
      tmp.SQL.Add('		else ');
      tmp.SQL.Add('		if @nr_zb = 2 ');
      tmp.SQL.Add('		begin ');
      tmp.SQL.Add('			update #aproksymacja set ltr = @wynik where id = @start_pos1_bak2 and nr_zb = @nr_zb and step = 1 ');
      tmp.SQL.Add('			select @start_pos1_bak2 = @start_pos1_bak2 + 1 ');
      tmp.SQL.Add('			if @start_pos1_bak2 >= @wsp1 ');
      tmp.SQL.Add('				select @start_pos1_bak2 = 0 ');
      tmp.SQL.Add('		end ');
      tmp.SQL.Add('		update #aproksymacja_params set start_pos1_bak1 = @start_pos1_bak1, start_pos1_bak2 = @start_pos1_bak2 ');
      tmp.SQL.Add('		if (@enabled2 is not null) and (@enabled2 = 1) ');
      tmp.SQL.Add('		begin ');
      tmp.SQL.Add('			if @nr_zb = 1 ');
      tmp.SQL.Add('			begin ');
      tmp.SQL.Add('				update #aproksymacja set ltr = @wynik where id = @start_pos2_bak1 and nr_zb = @nr_zb and step = 2 ');
      tmp.SQL.Add('				select @start_pos2_bak1 = @start_pos2_bak1 + 1 ');
      tmp.SQL.Add('				if @start_pos2_bak1 >= @wsp2 ');
      tmp.SQL.Add('					select @start_pos2_bak1 = 0 ');
      tmp.SQL.Add('			end ');
      tmp.SQL.Add('			else ');
      tmp.SQL.Add('			if @nr_zb = 2 ');
      tmp.SQL.Add('			begin ');
      tmp.SQL.Add('				update #aproksymacja set ltr = @wynik where id = @start_pos2_bak2 and nr_zb = @nr_zb and step = 2 ');
      tmp.SQL.Add('				select @start_pos2_bak2 = @start_pos2_bak2 + 1 ');
      tmp.SQL.Add('				if @start_pos2_bak2 >= @wsp2 ');
      tmp.SQL.Add('					select @start_pos2_bak2 = 0 ');
      tmp.SQL.Add('			end ');
      tmp.SQL.Add('			update #aproksymacja_params set start_pos2_bak1 = @start_pos2_bak1, start_pos2_bak2 = @start_pos2_bak2 ');
      tmp.SQL.Add('		end ');
      tmp.SQL.Add('	end ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 106 then
    begin
//      UaktualnijProcedureTankowania();
//      UaktualnijProcedureCzasuPracy();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 107 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table cycle_item drop column kWh_cost ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('alter table cycle_item add kWh_cost numeric(10, 4) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 108 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add last_doniec datetime ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 109 then
    begin
      try
          tmp.SQL.Clear();
          tmp.SQL.Add('alter table carnet_settings add show_current_chart int not null default(1) ');
          tmp.ExecSQL();
      except

      end;

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 110 then
    begin
      try
          tmp.SQL.Clear();
          tmp.SQL.Add('alter table carnet_settings add show_current_chart int not null default(1) ');
          tmp.ExecSQL();
      except

      end;

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 111 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(18, ''Watchdog'') ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_nonstandard(id_event) values(18) ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_has_time(id_event) values(18) ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(19, ''Watchdog'') ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_nonstandard(id_event) values(19) ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_has_time(id_event) values(19) ');
      tmp.ExecSQL();
      Inc(version);

      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 112 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table mail_settings add report_mail varchar(200) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 113 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table mail_settings add report_mail2 varchar(200) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 114 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add report_mail varchar(200) ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add report_mail2 varchar(200) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 115 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add lastendroute datetime ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 116 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add report_mail3 varchar(200) ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add report_mail4 varchar(200) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 117 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('ALTER PROCEDURE [dbo].modifyFuelCharacterization ');
      tmp.SQL.Add('	@cslist VARCHAR(8000), ');
      tmp.SQL.Add('	@id_fuel_tank INT ');
      tmp.SQL.Add('AS ');
      tmp.SQL.Add('BEGIN ');
      tmp.SQL.Add('	SET NOCOUNT ON; ');
      tmp.SQL.Add('	declare probe_cursor2 cursor ');
      tmp.SQL.Add('		for select id_probe from probe ');
      tmp.SQL.Add('		for read only; ');
      tmp.SQL.Add('	declare @num_probes int; ');
      tmp.SQL.Add('	declare @num_args int; ');
      tmp.SQL.Add('	declare @id_probe int; ');
      tmp.SQL.Add('	declare @argv numeric(10,1); ');
      tmp.SQL.Add('    create table #__tmptbl (val numeric(10,1)) ');
      tmp.SQL.Add('    declare args_cursor cursor ');
      tmp.SQL.Add('        for select val from #__tmptbl ');
      tmp.SQL.Add('        for read only; ');
      tmp.SQL.Add('    exec IntListToTable @cslist,''#__tmptbl''; ');
      tmp.SQL.Add('    select @num_probes = (max_probe + 1) from fuel_tank where id_fuel_tank = @id_fuel_tank; ');
      tmp.SQL.Add('    select @num_args = count(*) from #__tmptbl; ');
      tmp.SQL.Add('    if (@num_probes != @num_args) ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('        raiserror(''Wrong number of values in first argument'',16,1); ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('    else ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('		open probe_cursor2; ');
      tmp.SQL.Add('		open args_cursor; ');
      tmp.SQL.Add('		fetch probe_cursor2 into @id_probe; ');
      tmp.SQL.Add('		fetch args_cursor into @argv; ');
      tmp.SQL.Add('		begin transaction; ');
      tmp.SQL.Add('		while  @@FETCH_STATUS = 0 ');
      tmp.SQL.Add('		begin ');
      tmp.SQL.Add('				update probe_liters set liters=@argv where id_probe=@id_probe and id_fuel_tank=@id_fuel_tank; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('				fetch probe_cursor2 into @id_probe; ');
      tmp.SQL.Add('				fetch args_cursor into @argv; ');
      tmp.SQL.Add('		end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('		commit transaction; ');
      tmp.SQL.Add('		print ''modifyFuelCharacterization stored procedure execution finished with success''; ');
      tmp.SQL.Add('	end ');
      tmp.SQL.Add('    drop table #__tmptbl; ');
      tmp.SQL.Add('    deallocate probe_cursor2; ');
      tmp.SQL.Add('	deallocate args_cursor; ');
      tmp.SQL.Add('END ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 118 then
    begin
//      UaktualnijProcedureTankowania();
      UaktualnijProcedureCzasuPracy();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 119 then
    begin
      UaktualnijProcedureTankowania();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 120 then
    begin
      if Now() < EncodeDate(2013, 3, 15) then
      begin
          tmp.SQL.Clear();
          tmp.SQL.Add('delete from device_data ');
          tmp.SQL.Add('where date >= ''2013-02-25'' ');
          tmp.ExecSQL();

          tmp.SQL.Clear();
          tmp.SQL.Add('delete from lista_maili ');
          tmp.SQL.Add('where dataczas >= ''2013-02-25'' or ');
          tmp.SQL.Add('      dataczas = ''1899-12-30 01:00:00'' ');
          tmp.ExecSQL();
      end;

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 121 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('create table analysis_results ');
      tmp.SQL.Add('( ');
      tmp.SQL.Add('	id_analysis_results int not null identity(1, 1), ');
      tmp.SQL.Add('	id_analysis int not null, ');
      tmp.SQL.Add('	id_car tinyint not null, ');
      tmp.SQL.Add('	start datetime not null, ');
      tmp.SQL.Add('	stop2 datetime not null, ');
      tmp.SQL.Add('	analysis_passed int not null, ');
      tmp.SQL.Add('	primary key (id_analysis_results), ');
      tmp.SQL.Add('	foreign key (id_car) references car (id_car) on delete cascade on update cascade ');
      tmp.SQL.Add(') ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 122 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table analysis_results ');
      tmp.SQL.Add('add firmware_version varchar(6) not null ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 123 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table analysis_results ');
      tmp.SQL.Add('add error_stop datetime ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 124 then
    begin
      ProceduraDeviceData2(True);

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 125 then
    begin
//      ProceduraDeviceData2(False);

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 126 then
    begin
//      ProceduraDeviceData2(False);

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 127 then
    begin
//      ProceduraDeviceData2(False);

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 128 then
    begin
//      ProceduraDeviceData2(False);

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 129 then
    begin
      ProceduraDeviceData2(False);

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 130 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('delete from analysis_results where id_analysis = 8 ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 131 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add wysokosc integer ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add satelity integer ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 132 then
    begin
      UaktualnijProcedureNietypowe();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 133 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(245, ''Pomiar pr¹du 2'') ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 134 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('update car set fast_imp = 10.0 ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 135 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('create table login_cars_assignment ');
      tmp.SQL.Add('( ');
      tmp.SQL.Add('   id_assignment_car tinyint not null, ');
      tmp.SQL.Add('   login varchar(30) not null, ');
      tmp.SQL.Add('   primary key (id_assignment_car, login) ');
      tmp.SQL.Add(') ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 136 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table login_cars_assignment ');
      tmp.SQL.Add(' add foreign key (id_assignment_car) ');
      tmp.SQL.Add(' references car (id_car) on delete cascade on update cascade ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 137 then
    begin
//      UaktualnijProcedureTankowania();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 138 then
    begin
      UaktualnijProcedureTankowania();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if version = 139 then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(70, ''Uderzenie ant'') ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_nonstandard(id_event) values(70) ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_has_time(id_event) values(70) ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(71, ''Zanik chipa dodatkowego'') ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_nonstandard(id_event) values(71) ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_has_time(id_event) values(71) ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(72, ''Wejscie chipa matki'') ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_nonstandard(id_event) values(72) ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_has_time(id_event) values(72) ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event(id_event, description) values(73, ''Zanik chipa matki'') ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_nonstandard(id_event) values(73) ');
      tmp.ExecSQL();
      tmp.SQL.Clear();
      tmp.SQL.Add('insert into event_has_time(id_event) values(73) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 140) then
    begin

      tmp.SQL.Clear();

      tmp.SQL.Add('create procedure [dbo].[czybylemailczytany2] ');
      tmp.SQL.Add('    	@adres varchar(150), ');
      tmp.SQL.Add('    	@dataczas datetime, ');
      tmp.SQL.Add('    	@dataczas2 datetime, ');
      tmp.SQL.Add('    	@dataczas3 datetime, ');
      tmp.SQL.Add('    	@tytul varchar(200), ');
      tmp.SQL.Add('    	@rozmiar integer, ');
      tmp.SQL.Add('    	@mail_id varchar(500) ');
      tmp.SQL.Add('    as ');
      tmp.SQL.Add('    	select * from lista_maili ');
      tmp.SQL.Add('    	where adres = @adres ');
      tmp.SQL.Add('      		and ');
      tmp.SQL.Add('      		( ');
      tmp.SQL.Add('      		  (  (dataczas = @dataczas or dataczas = @dataczas2 or dataczas = @dataczas3) ');
      tmp.SQL.Add('      		     and (tytul = @tytul or tytul is NULL) ');
      tmp.SQL.Add('		         and ( (dataczas = @dataczas) or ');
      tmp.SQL.Add('		               (rozmiar is NULL) or ');
      tmp.SQL.Add('                       ( ');
      tmp.SQL.Add('                         (dataczas <> @dataczas) and ');
      tmp.SQL.Add('                         (rozmiar = @rozmiar) ');
      tmp.SQL.Add('                       ) ');
      tmp.SQL.Add('                     ) ');
      tmp.SQL.Add('                  and dataczas <= ''2015-12-09 19:32:00'' ');
      tmp.SQL.Add('              ) ');
      tmp.SQL.Add('              or ');
      tmp.SQL.Add('              ( ');
      tmp.SQL.Add('				  UIDL = @mail_id ');
      tmp.SQL.Add('              ) ');
      tmp.SQL.Add('            ) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 141) then
    begin
      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 142) then
    begin

      tmp.SQL.Clear();

      // zamien stare ip strefy na nowe automatycznie
      // niektóre konta strefy maj¹ zmienione has³o na vnbvgfgV1@,
      // gby logownie na strefie siê nie powiedzie, automatycznie próbowane jest has³o vnbvgfgV1@
      // dziêki 6 linijkom kodu ma Pan Panie Tomku po³owe roboty
      // ustawienia do nowego serwera trzeba ju¿ przeslac do klientów rêcznie ;)

      tmp.SQL.Clear();
      tmp.SQL.Add('update mail_settings set serwerpop3 = ''46.41.156.4'' where serwerpop3 = ''217.74.64.34'' ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('update mail_settings set serwersmtp = ''46.41.156.4'' where serwersmtp = ''217.74.64.34'' ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 143) then
    begin

      tmp.SQL.Clear();
{
      tmp.SQL.Add('ALTER procedure [dbo].[czybylemailczytany2] ');
      tmp.SQL.Add('    	@adres varchar(150), ');
      tmp.SQL.Add('    	@dataczas datetime, ');
      tmp.SQL.Add('    	@dataczas2 datetime, ');
      tmp.SQL.Add('    	@dataczas3 datetime, ');
      tmp.SQL.Add('    	@tytul varchar(200), ');
      tmp.SQL.Add('    	@rozmiar integer, ');
      tmp.SQL.Add('    	@mail_id varchar(500) ');
      tmp.SQL.Add('    as ');
      tmp.SQL.Add('    	select * from lista_maili ');
      tmp.SQL.Add('    	where adres = @adres ');
      tmp.SQL.Add('      		and ');
      tmp.SQL.Add('      		( ');
      tmp.SQL.Add('      		  (  (dataczas = @dataczas or dataczas = @dataczas2 or dataczas = @dataczas3) ');
      tmp.SQL.Add('      		     and (tytul = @tytul or tytul is NULL) ');
      tmp.SQL.Add('		         and ( (dataczas = @dataczas) or ');
      tmp.SQL.Add('		               (rozmiar is NULL) or ');
      tmp.SQL.Add('                       ( ');
      tmp.SQL.Add('                         (dataczas <> @dataczas) and ');
      tmp.SQL.Add('                         (rozmiar = @rozmiar) ');
      tmp.SQL.Add('                       ) ');
      tmp.SQL.Add('                     ) ');
      tmp.SQL.Add('                  and (dataczas <= ''2015-12-15 00:00:00''  or ');
      tmp.SQL.Add('                              @mail_id is null or @mail_id = '''') ');
      tmp.SQL.Add('              ) ');
      tmp.SQL.Add('              or ');
      tmp.SQL.Add('              ( ');
      tmp.SQL.Add('				  UIDL = @mail_id and (not ((@mail_id is null)) and @mail_id <> '''') ');
      tmp.SQL.Add('              ) ');
      tmp.SQL.Add('            ) ');
      tmp.ExecSQL();     }

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 144) then
    begin

      tmp.SQL.Clear();

      tmp.SQL.Add('ALTER procedure [dbo].[czybylemailczytany2] ');
      tmp.SQL.Add('    	@adres varchar(150), ');
      tmp.SQL.Add('    	@dataczas datetime, ');
      tmp.SQL.Add('    	@dataczas2 datetime, ');
      tmp.SQL.Add('    	@dataczas3 datetime, ');
      tmp.SQL.Add('    	@tytul varchar(200), ');
      tmp.SQL.Add('    	@rozmiar integer, ');
      tmp.SQL.Add('    	@mail_id varchar(500) ');
      tmp.SQL.Add('    as ');
      tmp.SQL.Add('    	select * from lista_maili ');
      tmp.SQL.Add('    	where adres = @adres ');
      tmp.SQL.Add('      		and ');
      tmp.SQL.Add('      		( ');
      tmp.SQL.Add('      		  (  (dataczas = @dataczas or dataczas = @dataczas2 or dataczas = @dataczas3) ');
      tmp.SQL.Add('      		     and (tytul = @tytul or tytul is NULL) ');
      tmp.SQL.Add('		         and ( (dataczas = @dataczas) or ');
      tmp.SQL.Add('		               (rozmiar is NULL) or ');
      tmp.SQL.Add('                       ( ');
      tmp.SQL.Add('                         (dataczas <> @dataczas) and ');
      tmp.SQL.Add('                         (rozmiar = @rozmiar) ');
      tmp.SQL.Add('                       ) ');
      tmp.SQL.Add('                     ) ');
      tmp.SQL.Add('                  and (dataczas <= ''2015-12-15 00:00:00'') ');
      tmp.SQL.Add('              ) ');
      tmp.SQL.Add('              or ');
      tmp.SQL.Add('              (  ');
      tmp.SQL.Add('				  UIDL = @mail_id and (not ((@mail_id is null)) and @mail_id <> '''') ');
      tmp.SQL.Add('                   and  (dataczas > ''2015-12-15 00:00:00'') ');
      tmp.SQL.Add('              ) ');
      tmp.SQL.Add('            ) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 145) then
    begin
//      tmp.SQL.Clear();

//      tmp.SQL.Add('select id_car from car ');
//      tmp.
//      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 146) then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table calendar_bold add ev181cnt int, ev14cnt int, ev15cnt int, ev222cnt int');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 147) then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table calendar_bold add evdate datetime');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 148) then
    begin
//      tmp.SQL.Clear();

//      tmp.SQL.Add('select id_car from car ');
//      tmp.
//      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 149) then
    begin
//      tmp.SQL.Clear();

//      tmp.SQL.Add('select id_car from car ');
//      tmp.
//      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 150) then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add(' ALTER procedure [dbo].[insertevent] ');
      tmp.SQL.Add(' 	@evb1 integer, ');
      tmp.SQL.Add(' 	@evb2 integer, ');
      tmp.SQL.Add(' 	@evb3 integer, ');
      tmp.SQL.Add(' 	@evb4 integer, ');
      tmp.SQL.Add(' 	@evb5 integer, ');
      tmp.SQL.Add(' 	@evb6 integer, ');
      tmp.SQL.Add(' 	@evb7 integer, ');
      tmp.SQL.Add(' 	@evb8 integer, ');
      tmp.SQL.Add(' 	@evb9 integer, ');
      tmp.SQL.Add(' 	@evb10 integer, ');
      tmp.SQL.Add(' 	@evdata datetime, ');
      tmp.SQL.Add(' 	@pal1 integer, ');
      tmp.SQL.Add(' 	@pal2 integer, ');
      tmp.SQL.Add(' 	@timezonebias integer ');
      tmp.SQL.Add(' as ');
      tmp.SQL.Add('     declare @prior_evdata datetime; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('     declare @car_exists tinyint ');
      tmp.SQL.Add('     select @car_exists=count(*) from car where id_car=@evb2 ');
      tmp.SQL.Add('     if (@car_exists=0) ');
      tmp.SQL.Add(' 		insert into car (id_car, name) values (@evb2, ''AUTO NR '' ');
      tmp.SQL.Add(' 			+ cast(@evb2 as varchar(3))) ');
      tmp.SQL.Add(' 	insert into device_data (evb1, evb2, evb3, evb4, evb5, evb6, evb7, evb8, ');
      tmp.SQL.Add('  evb9, evb10, [date], pal1, pal2, timezonebias) ');
      tmp.SQL.Add(' 	values(@evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, @evb8, @evb9, ');
      tmp.SQL.Add('  @evb10, @evdata, @pal1, @pal2, @timezonebias) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  declare @only_date date ');
      tmp.SQL.Add('  set @only_date = cast(STR(MONTH(@evdata)) + ''/'' + ');
      tmp.SQL.Add('  							 STR(DAY(@evdata)) + ''/'' + ');
      tmp.SQL.Add('  							 STR(YEAR(@evdata)) as date) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  declare @calendar_exists tinyint ');
      tmp.SQL.Add('  select @calendar_exists = count(*) from calendar_bold where id_car = @evb2 ');
      tmp.SQL.Add('       and date_ = @only_date ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  if(@calendar_exists = 0) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	insert into calendar_bold(id_car, date_, has_data, has_gps, ev181cnt, ev14cnt, ev15cnt, ev222cnt, evdate) ');
      tmp.SQL.Add('  		values(@evb2, @only_date, 1, 0, 0, 0, 0, 0, @evdata); ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  if (@evb3 = 36 or @evb3 = 38) and (@evb1 = 65) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set has_gps = 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 181) -- bieg jalowy ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev181cnt = ev181cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 14) --zasloniety gps ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev14cnt = ev14cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 222) --no server ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev222cnt = ev222cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 15) -- wylacznie zasilania ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add(' 	select @prior_evdata = evdate from calendar_bold where id_car = @evb2 and date_ = @only_date; ');
      tmp.SQL.Add('  	update calendar_bold set ev15cnt = ev15cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  	    and (dbo.get_date_diff(@prior_evdata, @evdata) >= 300) ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  update calendar_bold set evdate = @evdata where id_car = @evb2 and date_ = @only_date ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 151) then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table car add last_email_datetime datetime');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 152) then
    begin
//      tmp.SQL.Clear();
//      tmp.SQL.Add('update car set last_email_datetime = null');
//      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 153) then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('update mail_settings set serwerpop3 = ''82.177.50.124'' ');
      tmp.ExecSQL();


      tmp.SQL.Clear();
      tmp.SQL.Add('update mail_settings set serwersmtp = ''82.177.50.124'' ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 154) then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table calendar_bold add gpsV integer, gpsO integer, gpsS integer');
      tmp.ExecSQL();


      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 155) then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add(' ALTER procedure [dbo].[insertevent] ');
      tmp.SQL.Add(' 	@evb1 integer, ');
      tmp.SQL.Add(' 	@evb2 integer, ');
      tmp.SQL.Add(' 	@evb3 integer, ');
      tmp.SQL.Add(' 	@evb4 integer, ');
      tmp.SQL.Add(' 	@evb5 integer, ');
      tmp.SQL.Add(' 	@evb6 integer, ');
      tmp.SQL.Add(' 	@evb7 integer, ');
      tmp.SQL.Add(' 	@evb8 integer, ');
      tmp.SQL.Add(' 	@evb9 integer, ');
      tmp.SQL.Add(' 	@evb10 integer, ');
      tmp.SQL.Add(' 	@evdata datetime, ');
      tmp.SQL.Add(' 	@pal1 integer, ');
      tmp.SQL.Add(' 	@pal2 integer, ');
      tmp.SQL.Add(' 	@timezonebias integer ');
      tmp.SQL.Add(' as ');
      tmp.SQL.Add('     declare @prior_evdata datetime; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('     declare @car_exists tinyint ');
      tmp.SQL.Add('     select @car_exists=count(*) from car where id_car=@evb2 ');
      tmp.SQL.Add('     if (@car_exists=0) ');
      tmp.SQL.Add(' 		insert into car (id_car, name) values (@evb2, ''AUTO NR '' ');
      tmp.SQL.Add(' 			+ cast(@evb2 as varchar(3))) ');
      tmp.SQL.Add(' 	insert into device_data (evb1, evb2, evb3, evb4, evb5, evb6, evb7, evb8, ');
      tmp.SQL.Add('  evb9, evb10, [date], pal1, pal2, timezonebias) ');
      tmp.SQL.Add(' 	values(@evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, @evb8, @evb9, ');
      tmp.SQL.Add('  @evb10, @evdata, @pal1, @pal2, @timezonebias) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  declare @only_date date ');
      tmp.SQL.Add('  set @only_date = cast(STR(MONTH(@evdata)) + ''/'' + ');
      tmp.SQL.Add('  							 STR(DAY(@evdata)) + ''/'' + ');
      tmp.SQL.Add('  							 STR(YEAR(@evdata)) as date) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  declare @calendar_exists tinyint ');
      tmp.SQL.Add('  select @calendar_exists = count(*) from calendar_bold where id_car = @evb2 ');
      tmp.SQL.Add('       and date_ = @only_date ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  if(@calendar_exists = 0) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	insert into calendar_bold(id_car, date_, has_data, has_gps, ev181cnt, ev14cnt, ev15cnt, ev222cnt, evdate) ');
      tmp.SQL.Add('  		values(@evb2, @only_date, 1, 0, 0, 0, 0, 0, @evdata); ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 65) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set has_gps = 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 86) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsV = gpsV + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 83) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsS = gpsS + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 79) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsO = gpsO + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 181) -- bieg jalowy ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev181cnt = ev181cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 14) --zasloniety gps ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev14cnt = ev14cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 222) --no server ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev222cnt = ev222cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 15) -- wylacznie zasilania ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add(' 	select @prior_evdata = evdate from calendar_bold where id_car = @evb2 and date_ = @only_date; ');
      tmp.SQL.Add('  	update calendar_bold set ev15cnt = ev15cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  	    and (dbo.get_date_diff(@prior_evdata, @evdata) >= 300) ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  update calendar_bold set evdate = @evdata where id_car = @evb2 and date_ = @only_date ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 156) then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('update calendar_bold set gpsV = 0, gpsO = 0, gpsS = 0');
      tmp.ExecSQL();


      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 157) then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table calendar_bold add gpsA integer, gpsR integer');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('update calendar_bold set gpsA = 0, gpsR = 0 ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add(' ALTER procedure [dbo].[insertevent] ');
      tmp.SQL.Add(' 	@evb1 integer, ');
      tmp.SQL.Add(' 	@evb2 integer, ');
      tmp.SQL.Add(' 	@evb3 integer, ');
      tmp.SQL.Add(' 	@evb4 integer, ');
      tmp.SQL.Add(' 	@evb5 integer, ');
      tmp.SQL.Add(' 	@evb6 integer, ');
      tmp.SQL.Add(' 	@evb7 integer, ');
      tmp.SQL.Add(' 	@evb8 integer, ');
      tmp.SQL.Add(' 	@evb9 integer, ');
      tmp.SQL.Add(' 	@evb10 integer, ');
      tmp.SQL.Add(' 	@evdata datetime, ');
      tmp.SQL.Add(' 	@pal1 integer, ');
      tmp.SQL.Add(' 	@pal2 integer, ');
      tmp.SQL.Add(' 	@timezonebias integer ');
      tmp.SQL.Add(' as ');
      tmp.SQL.Add('     declare @prior_evdata datetime; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('     declare @car_exists tinyint ');
      tmp.SQL.Add('     select @car_exists=count(*) from car where id_car=@evb2 ');
      tmp.SQL.Add('     if (@car_exists=0) ');
      tmp.SQL.Add(' 		insert into car (id_car, name) values (@evb2, ''AUTO NR '' ');
      tmp.SQL.Add(' 			+ cast(@evb2 as varchar(3))) ');
      tmp.SQL.Add(' 	insert into device_data (evb1, evb2, evb3, evb4, evb5, evb6, evb7, evb8, ');
      tmp.SQL.Add('  evb9, evb10, [date], pal1, pal2, timezonebias) ');
      tmp.SQL.Add(' 	values(@evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, @evb8, @evb9, ');
      tmp.SQL.Add('  @evb10, @evdata, @pal1, @pal2, @timezonebias) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  declare @only_date date ');
      tmp.SQL.Add('  set @only_date = cast(STR(MONTH(@evdata)) + ''/'' + ');
      tmp.SQL.Add('  							 STR(DAY(@evdata)) + ''/'' + ');
      tmp.SQL.Add('  							 STR(YEAR(@evdata)) as date) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  declare @calendar_exists tinyint ');
      tmp.SQL.Add('  select @calendar_exists = count(*) from calendar_bold where id_car = @evb2 ');
      tmp.SQL.Add('       and date_ = @only_date ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  if(@calendar_exists = 0) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	insert into calendar_bold(id_car, date_, has_data, has_gps, ev181cnt, ev14cnt, ev15cnt, ev222cnt, evdate) ');
      tmp.SQL.Add('  		values(@evb2, @only_date, 1, 0, 0, 0, 0, 0, @evdata); ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 65) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set has_gps = 1, gpsA = gpsA + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 86) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsV = gpsV + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 83) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsS = gpsS + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 79) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsO = gpsO + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 82) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsR = gpsR + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 181) -- bieg jalowy ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev181cnt = ev181cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 14) --zasloniety gps ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev14cnt = ev14cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 222) --no server ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev222cnt = ev222cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 15) -- wylacznie zasilania ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add(' 	select @prior_evdata = evdate from calendar_bold where id_car = @evb2 and date_ = @only_date; ');
      tmp.SQL.Add('  	update calendar_bold set ev15cnt = ev15cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  	    and (dbo.get_date_diff(@prior_evdata, @evdata) >= 300) ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  update calendar_bold set evdate = @evdata where id_car = @evb2 and date_ = @only_date ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 158) then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table calendar_bold add nokm integer');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('update calendar_bold set nokm = 0 ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add(' ALTER procedure [dbo].[insertevent] ');
      tmp.SQL.Add(' 	@evb1 integer, ');
      tmp.SQL.Add(' 	@evb2 integer, ');
      tmp.SQL.Add(' 	@evb3 integer, ');
      tmp.SQL.Add(' 	@evb4 integer, ');
      tmp.SQL.Add(' 	@evb5 integer, ');
      tmp.SQL.Add(' 	@evb6 integer, ');
      tmp.SQL.Add(' 	@evb7 integer, ');
      tmp.SQL.Add(' 	@evb8 integer, ');
      tmp.SQL.Add(' 	@evb9 integer, ');
      tmp.SQL.Add(' 	@evb10 integer, ');
      tmp.SQL.Add(' 	@evdata datetime, ');
      tmp.SQL.Add(' 	@pal1 integer, ');
      tmp.SQL.Add(' 	@pal2 integer, ');
      tmp.SQL.Add(' 	@timezonebias integer ');
      tmp.SQL.Add(' as ');
      tmp.SQL.Add('     declare @prior_evdata datetime; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('     declare @car_exists tinyint ');
      tmp.SQL.Add('     select @car_exists=count(*) from car where id_car=@evb2 ');
      tmp.SQL.Add('     if (@car_exists=0) ');
      tmp.SQL.Add(' 		insert into car (id_car, name) values (@evb2, ''AUTO NR '' ');
      tmp.SQL.Add(' 			+ cast(@evb2 as varchar(3))) ');
      tmp.SQL.Add(' 	insert into device_data (evb1, evb2, evb3, evb4, evb5, evb6, evb7, evb8, ');
      tmp.SQL.Add('  evb9, evb10, [date], pal1, pal2, timezonebias) ');
      tmp.SQL.Add(' 	values(@evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, @evb8, @evb9, ');
      tmp.SQL.Add('  @evb10, @evdata, @pal1, @pal2, @timezonebias) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  declare @only_date date ');
      tmp.SQL.Add('  set @only_date = cast(STR(MONTH(@evdata)) + ''/'' + ');
      tmp.SQL.Add('  							 STR(DAY(@evdata)) + ''/'' + ');
      tmp.SQL.Add('  							 STR(YEAR(@evdata)) as date) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  declare @calendar_exists tinyint ');
      tmp.SQL.Add('  select @calendar_exists = count(*) from calendar_bold where id_car = @evb2 ');
      tmp.SQL.Add('       and date_ = @only_date ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  if(@calendar_exists = 0) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	insert into calendar_bold(id_car, date_, has_data, has_gps, ev181cnt, ev14cnt, ev15cnt, ev222cnt, gpsA, gpsR, gpsO, gpsS, gpsV, nokm, evdate) ');
      tmp.SQL.Add('  		values(@evb2, @only_date, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, @evdata); ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 65) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set has_gps = 1, gpsA = gpsA + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 86) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsV = gpsV + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 83) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsS = gpsS + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 79) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsO = gpsO + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 82) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsR = gpsR + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 181) -- bieg jalowy ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev181cnt = ev181cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 85) and (@evb9 = 0) and (@evb10 = 0) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set nokm = nokm + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 14) --zasloniety gps ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev14cnt = ev14cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 222) --no server ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev222cnt = ev222cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 15) -- wylacznie zasilania ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add(' 	select @prior_evdata = evdate from calendar_bold where id_car = @evb2 and date_ = @only_date; ');
      tmp.SQL.Add('  	update calendar_bold set ev15cnt = ev15cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  	    and (dbo.get_date_diff(@prior_evdata, @evdata) >= 300) ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  update calendar_bold set evdate = @evdata where id_car = @evb2 and date_ = @only_date ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 159) then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table calendar_bold add has_km integer, meters_all integer');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('update calendar_bold set has_km = 0, meters_all = 0');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add(' ALTER procedure [dbo].[insertevent] ');
      tmp.SQL.Add(' 	@evb1 integer, ');
      tmp.SQL.Add(' 	@evb2 integer, ');
      tmp.SQL.Add(' 	@evb3 integer, ');
      tmp.SQL.Add(' 	@evb4 integer, ');
      tmp.SQL.Add(' 	@evb5 integer, ');
      tmp.SQL.Add(' 	@evb6 integer, ');
      tmp.SQL.Add(' 	@evb7 integer, ');
      tmp.SQL.Add(' 	@evb8 integer, ');
      tmp.SQL.Add(' 	@evb9 integer, ');
      tmp.SQL.Add(' 	@evb10 integer, ');
      tmp.SQL.Add(' 	@evdata datetime, ');
      tmp.SQL.Add(' 	@pal1 integer, ');
      tmp.SQL.Add(' 	@pal2 integer, ');
      tmp.SQL.Add(' 	@timezonebias integer ');
      tmp.SQL.Add(' as ');
      tmp.SQL.Add('     declare @prior_evdata datetime; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('     declare @car_exists tinyint ');
      tmp.SQL.Add('     select @car_exists=count(*) from car where id_car=@evb2 ');
      tmp.SQL.Add('     if (@car_exists=0) ');
      tmp.SQL.Add(' 		insert into car (id_car, name) values (@evb2, ''AUTO NR '' ');
      tmp.SQL.Add(' 			+ cast(@evb2 as varchar(3))) ');
      tmp.SQL.Add(' 	insert into device_data (evb1, evb2, evb3, evb4, evb5, evb6, evb7, evb8, ');
      tmp.SQL.Add('  evb9, evb10, [date], pal1, pal2, timezonebias) ');
      tmp.SQL.Add(' 	values(@evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, @evb8, @evb9, ');
      tmp.SQL.Add('  @evb10, @evdata, @pal1, @pal2, @timezonebias) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  declare @only_date date ');
      tmp.SQL.Add('  set @only_date = cast(STR(MONTH(@evdata)) + ''/'' + ');
      tmp.SQL.Add('  							 STR(DAY(@evdata)) + ''/'' + ');
      tmp.SQL.Add('  							 STR(YEAR(@evdata)) as date) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  declare @calendar_exists tinyint ');
      tmp.SQL.Add('  select @calendar_exists = count(*) from calendar_bold where id_car = @evb2 ');
      tmp.SQL.Add('       and date_ = @only_date ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  if(@calendar_exists = 0) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	insert into calendar_bold(id_car, date_, has_data, has_gps, ev181cnt, ev14cnt, ev15cnt, ev222cnt, gpsA, gpsR, gpsO, gpsS, gpsV, nokm, has_km, meters_all, evdate) ');
      tmp.SQL.Add('  		values(@evb2, @only_date, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, @evdata); ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 65) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set has_gps = 1, gpsA = gpsA + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 86) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsV = gpsV + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 83) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsS = gpsS + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 79) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsO = gpsO + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 82) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsR = gpsR + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 181) -- bieg jalowy ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev181cnt = ev181cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 85) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('    if (@evb9 = 0) and (@evb10 = 0) ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('  	  update calendar_bold set nokm = nokm + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('    else ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('  	  update calendar_bold set has_km = has_km + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('  	update calendar_bold set meters_all = meters_all + ((@evb9 * 256 + @evb10) * 100) where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 14) --zasloniety gps ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev14cnt = ev14cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 222) --no server ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev222cnt = ev222cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 15) -- wylacznie zasilania ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add(' 	select @prior_evdata = evdate from calendar_bold where id_car = @evb2 and date_ = @only_date; ');
      tmp.SQL.Add('  	update calendar_bold set ev15cnt = ev15cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  	    and (dbo.get_date_diff(@prior_evdata, @evdata) >= 300) ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  update calendar_bold set evdate = @evdata where id_car = @evb2 and date_ = @only_date ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;


    if (version = 160) then
    begin
      UaktualnijProcedureNietypowe();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 161) then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table calendar_bold add ticks integer, battery integer, battery_step integer, battery_datetime datetime');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('update calendar_bold set ticks = 0, battery = 0, battery_step = 0');
      tmp.ExecSQL();

{
      tmp.SQL.Clear();
      tmp.SQL.Add(' ALTER procedure [dbo].[insertevent] ');
      tmp.SQL.Add(' 	@evb1 integer, ');
      tmp.SQL.Add(' 	@evb2 integer, ');
      tmp.SQL.Add(' 	@evb3 integer, ');
      tmp.SQL.Add(' 	@evb4 integer, ');
      tmp.SQL.Add(' 	@evb5 integer, ');
      tmp.SQL.Add(' 	@evb6 integer, ');
      tmp.SQL.Add(' 	@evb7 integer, ');
      tmp.SQL.Add(' 	@evb8 integer, ');
      tmp.SQL.Add(' 	@evb9 integer, ');
      tmp.SQL.Add(' 	@evb10 integer, ');
      tmp.SQL.Add(' 	@evdata datetime, ');
      tmp.SQL.Add(' 	@pal1 integer, ');
      tmp.SQL.Add(' 	@pal2 integer, ');
      tmp.SQL.Add(' 	@timezonebias integer ');
      tmp.SQL.Add(' as ');
      tmp.SQL.Add('     declare @prior_evdata datetime; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('     declare @car_exists tinyint ');
      tmp.SQL.Add('     select @car_exists=count(*) from car where id_car=@evb2 ');
      tmp.SQL.Add('     if (@car_exists=0) ');
      tmp.SQL.Add(' 		insert into car (id_car, name) values (@evb2, ''AUTO NR '' ');
      tmp.SQL.Add(' 			+ cast(@evb2 as varchar(3))) ');
      tmp.SQL.Add(' 	insert into device_data (evb1, evb2, evb3, evb4, evb5, evb6, evb7, evb8, ');
      tmp.SQL.Add('  evb9, evb10, [date], pal1, pal2, timezonebias) ');
      tmp.SQL.Add(' 	values(@evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, @evb8, @evb9, ');
      tmp.SQL.Add('  @evb10, @evdata, @pal1, @pal2, @timezonebias) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  declare @only_date date ');
      tmp.SQL.Add('  set @only_date = cast(STR(MONTH(@evdata)) + ''/'' + ');
      tmp.SQL.Add('  							 STR(DAY(@evdata)) + ''/'' + ');
      tmp.SQL.Add('  							 STR(YEAR(@evdata)) as date) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  declare @calendar_exists tinyint ');
      tmp.SQL.Add('  select @calendar_exists = count(*) from calendar_bold where id_car = @evb2 ');
      tmp.SQL.Add('       and date_ = @only_date ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  if(@calendar_exists = 0) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	insert into calendar_bold(id_car, date_, has_data, has_gps, ev181cnt, ev14cnt, ev15cnt, ev222cnt, gpsA, gpsR, gpsO, gpsS, gpsV, nokm, has_km, meters_all, ticks, battery, battery_step, evdate) ');
      tmp.SQL.Add('  		values(@evb2, @only_date, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, @evdata); ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 65) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set has_gps = 1, gpsA = gpsA + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 86) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsV = gpsV + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 83) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsS = gpsS + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 79) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsO = gpsO + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 82) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set gpsR = gpsR + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 181) -- bieg jalowy ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev181cnt = ev181cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if ((@evb3 = 171) or (@evb3 = 172) or (@evb3 = 173)) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set battery_step = 1, battery_datetime = @evdata where id_car = @evb2 and date_ = @only_date and battery_step = 0 ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 174) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set battery_step = 2 where id_car = @evb2 and date_ = @only_date and battery_step = 1 and battery_datetime = @evdata ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 175) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set battery_step = 3 where id_car = @evb2 and date_ = @only_date and battery_step = 2 and battery_datetime = @evdata ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 85) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('    if (@evb9 = 0) and (@evb10 = 0) ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('  	  update calendar_bold set nokm = nokm + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('    else ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('  	  update calendar_bold set has_km = has_km + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('  	update calendar_bold set meters_all = meters_all + ((@evb9 * 256 + @evb10) * 100) where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 14) --zasloniety gps ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev14cnt = ev14cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 222) --no server ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set ev222cnt = ev222cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 15) -- wylacznie zasilania ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add(' 	  select @prior_evdata = evdate from calendar_bold where id_car = @evb2 and date_ = @only_date; ');
      tmp.SQL.Add('  	update calendar_bold set ev15cnt = ev15cnt + 1 where id_car = @evb2 and date_ = @only_date and battery_step <> 3 ');
      tmp.SQL.Add('  	    and (dbo.get_date_diff(@prior_evdata, @evdata) >= 300); ');
      tmp.SQL.Add('  	update calendar_bold set ticks = ticks + 1 where id_car = @evb2 and date_ = @only_date and battery_step <> 3 ');
      tmp.SQL.Add('  	    and (dbo.get_date_diff(@prior_evdata, @evdata) < 300); ');
      tmp.SQL.Add('  	update calendar_bold set battery_step = 4, battery = battery + 1 where id_car = @evb2 and date_ = @only_date and battery_step = 3 and battery_datetime = @evdata; ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  update calendar_bold set evdate = @evdata where id_car = @evb2 and date_ = @only_date ');
      tmp.ExecSQL();
}

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 162) then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('alter table calendar_bold add starts integer ');
      tmp.ExecSQL();

      tmp.SQL.Clear();
      tmp.SQL.Add('update calendar_bold set starts = 0');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 163) then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add(' ALTER procedure [dbo].[insertevent] ');
      tmp.SQL.Add(' 	@evb1 integer, ');
      tmp.SQL.Add(' 	@evb2 integer, ');
      tmp.SQL.Add(' 	@evb3 integer, ');
      tmp.SQL.Add(' 	@evb4 integer, ');
      tmp.SQL.Add(' 	@evb5 integer, ');
      tmp.SQL.Add(' 	@evb6 integer, ');
      tmp.SQL.Add(' 	@evb7 integer, ');
      tmp.SQL.Add(' 	@evb8 integer, ');
      tmp.SQL.Add(' 	@evb9 integer, ');
      tmp.SQL.Add(' 	@evb10 integer, ');
      tmp.SQL.Add(' 	@evdata datetime, ');
      tmp.SQL.Add(' 	@pal1 integer, ');
      tmp.SQL.Add(' 	@pal2 integer, ');
      tmp.SQL.Add(' 	@timezonebias integer ');
      tmp.SQL.Add(' as ');
      tmp.SQL.Add('     declare @prior_evdata datetime; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('     declare @car_exists tinyint ');
      tmp.SQL.Add('     select @car_exists=count(*) from car where id_car=@evb2 ');
      tmp.SQL.Add('     if (@car_exists=0) ');
      tmp.SQL.Add(' 		insert into car (id_car, name) values (@evb2, ''AUTO NR '' ');
      tmp.SQL.Add(' 			+ cast(@evb2 as varchar(3))) ');
      tmp.SQL.Add(' 	insert into device_data (evb1, evb2, evb3, evb4, evb5, evb6, evb7, evb8, ');
      tmp.SQL.Add('  evb9, evb10, [date], pal1, pal2, timezonebias) ');
      tmp.SQL.Add(' 	values(@evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, @evb8, @evb9, ');
      tmp.SQL.Add('  @evb10, @evdata, @pal1, @pal2, @timezonebias) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  declare @only_date date ');
      tmp.SQL.Add('  set @only_date = cast(STR(MONTH(@evdata)) + ''/'' + ');
      tmp.SQL.Add('  							 STR(DAY(@evdata)) + ''/'' + ');
      tmp.SQL.Add('  							 STR(YEAR(@evdata)) as date) ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  declare @calendar_exists tinyint ');
      tmp.SQL.Add('  select @calendar_exists = count(*) from calendar_bold where id_car = @evb2 ');
      tmp.SQL.Add('       and date_ = @only_date ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  if(@calendar_exists = 0) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	insert into calendar_bold(id_car, date_, has_data, has_gps, ev181cnt, ev14cnt, ev15cnt, ev222cnt, gpsA, gpsR, gpsO, gpsS, gpsV, nokm, has_km, meters_all, ticks, battery, battery_step, starts, evdate) ');
      tmp.SQL.Add('  		values(@evb2, @only_date, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, @evdata); ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  if ((@evb3 = 171) or (@evb3 = 172) or (@evb3 = 173)) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set battery_step = 1, battery_datetime = @evdata where id_car = @evb2 and date_ = @only_date and battery_step = 0 ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 174) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set battery_step = 2 where id_car = @evb2 and date_ = @only_date and battery_step = 1 and battery_datetime = @evdata ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 175) ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('  	update calendar_bold set battery_step = 3 where id_car = @evb2 and date_ = @only_date and battery_step = 2 and battery_datetime = @evdata ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  if (@evb3 = 15) -- wylacznie zasilania ');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add(' 	  select @prior_evdata = evdate from calendar_bold where id_car = @evb2 and date_ = @only_date; ');
      tmp.SQL.Add('  	update calendar_bold set ev15cnt = ev15cnt + 1 where id_car = @evb2 and date_ = @only_date and battery_step <> 3 ');
      tmp.SQL.Add('  	    and (dbo.get_date_diff(@prior_evdata, @evdata) >= 300); ');
      tmp.SQL.Add('  	update calendar_bold set ticks = ticks + 1 where id_car = @evb2 and date_ = @only_date and battery_step <> 3 ');
      tmp.SQL.Add('  	    and (dbo.get_date_diff(@prior_evdata, @evdata) < 300); ');
      tmp.SQL.Add('  	update calendar_bold set battery_step = 4, battery = battery + 1 where id_car = @evb2 and date_ = @only_date and battery_step = 3 and battery_datetime = @evdata; ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add('  else');
      tmp.SQL.Add('  begin ');
      tmp.SQL.Add('	   update calendar_bold set battery_step = 0, battery_datetime = null where id_car = @evb2 and date_ = @only_date and battery_step <> 0 ');
      tmp.SQL.Add('    if (@evb3 = 10) ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('    	update calendar_bold set starts = starts + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('    else');
      tmp.SQL.Add('    if (@evb3 = 38) and (@evb1 = 65) ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('    	update calendar_bold set has_gps = 1, gpsA = gpsA + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('    else');
      tmp.SQL.Add('    if (@evb3 = 38) and (@evb1 = 86) ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('    	update calendar_bold set gpsV = gpsV + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('    else');
      tmp.SQL.Add('    if (@evb3 = 38) and (@evb1 = 83) ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('    	update calendar_bold set gpsS = gpsS + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('    else');
      tmp.SQL.Add('    if (@evb3 = 38) and (@evb1 = 79) ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('    	update calendar_bold set gpsO = gpsO + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('    else');
      tmp.SQL.Add('    if (@evb3 = 38) and (@evb1 = 82) ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('    	update calendar_bold set gpsR = gpsR + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('    else');
      tmp.SQL.Add('    if (@evb3 = 181) -- bieg jalowy ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('    	update calendar_bold set ev181cnt = ev181cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('    else');
      tmp.SQL.Add('    if (@evb3 = 85) ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('      if (@evb9 = 0) and (@evb10 = 0) ');
      tmp.SQL.Add('      begin ');
      tmp.SQL.Add('  	    update calendar_bold set nokm = nokm + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('      end ');
      tmp.SQL.Add('      else ');
      tmp.SQL.Add('      begin ');
      tmp.SQL.Add('  	    update calendar_bold set has_km = has_km + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('      end ');
      tmp.SQL.Add('  	  update calendar_bold set meters_all = meters_all + ((@evb9 * 256 + @evb10) * 100) where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('    else');
      tmp.SQL.Add('    if (@evb3 = 14) --zasloniety gps ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('    	update calendar_bold set ev14cnt = ev14cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('    else');
      tmp.SQL.Add('    if (@evb3 = 222) --no server ');
      tmp.SQL.Add('    begin ');
      tmp.SQL.Add('    	update calendar_bold set ev222cnt = ev222cnt + 1 where id_car = @evb2 and date_ = @only_date ');
      tmp.SQL.Add('    end ');
      tmp.SQL.Add('  end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('  update calendar_bold set evdate = @evdata where id_car = @evb2 and date_ = @only_date ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 164) then
    begin
      if not FileExists(ExtractFilePath(ParamStr(0)) + 'serwer.txt') then
      begin
          tmp.SQL.Clear();
          tmp.SQL.Add(' ALTER procedure [dbo].[insertevent] ');
          tmp.SQL.Add(' 	@evb1 integer, ');
          tmp.SQL.Add(' 	@evb2 integer, ');
          tmp.SQL.Add(' 	@evb3 integer, ');
          tmp.SQL.Add(' 	@evb4 integer, ');
          tmp.SQL.Add(' 	@evb5 integer, ');
          tmp.SQL.Add(' 	@evb6 integer, ');
          tmp.SQL.Add(' 	@evb7 integer, ');
          tmp.SQL.Add(' 	@evb8 integer, ');
          tmp.SQL.Add(' 	@evb9 integer, ');
          tmp.SQL.Add(' 	@evb10 integer, ');
          tmp.SQL.Add(' 	@evdata datetime, ');
          tmp.SQL.Add(' 	@pal1 integer, ');
          tmp.SQL.Add(' 	@pal2 integer, ');
          tmp.SQL.Add(' 	@timezonebias integer ');
          tmp.SQL.Add(' as ');
          tmp.SQL.Add('     declare @prior_evdata datetime; ');
          tmp.SQL.Add(' ');
          tmp.SQL.Add('     declare @car_exists tinyint ');
          tmp.SQL.Add('     select @car_exists=count(*) from car where id_car=@evb2 ');
          tmp.SQL.Add('     if (@car_exists=0) ');
          tmp.SQL.Add(' 		insert into car (id_car, name) values (@evb2, ''AUTO NR '' ');
          tmp.SQL.Add(' 			+ cast(@evb2 as varchar(3))) ');
          tmp.SQL.Add(' 	insert into device_data (evb1, evb2, evb3, evb4, evb5, evb6, evb7, evb8, ');
          tmp.SQL.Add('  evb9, evb10, [date], pal1, pal2, timezonebias) ');
          tmp.SQL.Add(' 	values(@evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, @evb8, @evb9, ');
          tmp.SQL.Add('  @evb10, @evdata, @pal1, @pal2, @timezonebias) ');
          tmp.SQL.Add(' ');
          tmp.SQL.Add(' ');
          tmp.SQL.Add('  declare @only_date datetime ');
          tmp.SQL.Add('  set @only_date = cast(STR(MONTH(@evdata)) + ''/'' + ');
          tmp.SQL.Add('  							 STR(DAY(@evdata)) + ''/'' + ');
          tmp.SQL.Add('  							 STR(YEAR(@evdata)) as datetime) ');
          tmp.SQL.Add(' ');
          tmp.SQL.Add('  declare @calendar_exists tinyint ');
          tmp.SQL.Add('  select @calendar_exists = count(*) from calendar_bold where id_car = @evb2 ');
          tmp.SQL.Add('       and date_ = @only_date ');
          tmp.SQL.Add(' ');
          tmp.SQL.Add('  if(@calendar_exists = 0) ');
          tmp.SQL.Add('  begin ');
          tmp.SQL.Add('  	insert into calendar_bold(id_car, date_, has_data, has_gps, ev181cnt, ev14cnt, ev15cnt, ev222cnt, gpsA, gpsR, gpsO, gpsS, gpsV, nokm, has_km, meters_all, ticks, battery, battery_step, starts, evdate) ');
          tmp.SQL.Add('  		values(@evb2, @only_date, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, @evdata); ');
          tmp.SQL.Add('  end ');
          tmp.SQL.Add(' ');
          tmp.SQL.Add('  if (@evb3 = 38) and (@evb1 = 65) ');
          tmp.SQL.Add('  begin ');
          tmp.SQL.Add('    update calendar_bold set has_gps = 1, gpsA = gpsA + 1 where id_car = @evb2 and date_ = @only_date ');
          tmp.SQL.Add('  end ');
          tmp.SQL.Add(' ');
          tmp.SQL.Add('  update calendar_bold set evdate = @evdata where id_car = @evb2 and date_ = @only_date ');
          tmp.ExecSQL();
      end;
    end;

    if (version = 165) then
    begin
      tmp.SQL.Clear();
      tmp.SQL.Add('create view bulk_events ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('SELECT [evb1] ');
      tmp.SQL.Add('      ,[evb2] ');
      tmp.SQL.Add('      ,[evb3] ');
      tmp.SQL.Add('      ,[evb4] ');
      tmp.SQL.Add('      ,[evb5] ');
      tmp.SQL.Add('      ,[evb6] ');
      tmp.SQL.Add('      ,[evb7] ');
      tmp.SQL.Add('      ,[evb8] ');
      tmp.SQL.Add('      ,[evb9] ');
      tmp.SQL.Add('      ,[evb10] ');
      tmp.SQL.Add('      ,[pal1] ');
      tmp.SQL.Add('      ,[pal2] ');
      tmp.SQL.Add('      ,[date] ');
      tmp.SQL.Add('      ,[timezonebias] ');
      tmp.SQL.Add('  FROM [dbo].[device_data] ');
      tmp.SQL.Add('  where date = ''2016-12-01'' ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 166) then
    begin
//      

      tmp.SQL.Clear();
      tmp.SQL.Add('ALTER procedure [dbo].[czybylemailczytany2] ');
      tmp.SQL.Add('    	@adres varchar(150), ');
      tmp.SQL.Add('    	@dataczas datetime, ');
      tmp.SQL.Add('    	@dataczas2 datetime, ');
      tmp.SQL.Add('    	@dataczas3 datetime, ');
      tmp.SQL.Add('    	@tytul varchar(200), ');
      tmp.SQL.Add('    	@rozmiar integer, ');
      tmp.SQL.Add('    	@mail_id varchar(500) ');
      tmp.SQL.Add('    as ');
      tmp.SQL.Add('    	select * from lista_maili ');
      tmp.SQL.Add('    	where adres = @adres and UIDL = @mail_id ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 167) then
    begin
      WriteIniValue('dodatkowe_ReadTimeout2', 2000);
      if ReadIniValue('dodatkowe_ReadTimeout2') <> 2000 then
          raise Exception.Create('Proszê o uruchomiæ program z uprawnieniami administratora');

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 168) then
    begin


      WriteIniValue('dodatkowe_ReadTimeout2', 3000);
      if ReadIniValue('dodatkowe_ReadTimeout2') <> 3000 then
          raise Exception.Create('Proszê o uruchomiæ program z uprawnieniami administratora');

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 169) then
    begin


      WriteIniValue('dodatkowe_ReadTimeout2', 5000);
      if ReadIniValue('dodatkowe_ReadTimeout2') <> 5000 then
          raise Exception.Create('Proszê o uruchomiæ program z uprawnieniami administratora');

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 170) then
    begin
      

      tmp.SQL.Clear();
      tmp.SQL.Add('CREATE procedure [dbo].[update_callendar] ');
      tmp.SQL.Add('(  ');
      tmp.SQL.Add('	@id_car int, ');
      tmp.SQL.Add('	@start_id bigint, ');
      tmp.SQL.Add('	@stop_id bigint ');
      tmp.SQL.Add(') ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('	declare @start_date datetime; ');
      tmp.SQL.Add('	set @start_date = null; ');
      tmp.SQL.Add('	select @start_date = date from device_data where evb2 = @id_car and id_device_data >= @start_id order by id_device_data asc; ');
      tmp.SQL.Add('	declare @stop_date datetime; ');
      tmp.SQL.Add('	set @stop_date = null; ');
      tmp.SQL.Add('	select @stop_date = date from device_data where evb2 = @id_car and id_device_data <= @stop_id order by id_device_data desc; ');
      tmp.SQL.Add('	if @start_date is null ');
      tmp.SQL.Add('	begin ');
      tmp.SQL.Add('		raiserror(''error: start_date is null'', 16, 1); ');
      tmp.SQL.Add('	end ');
      tmp.SQL.Add('	if @stop_date is null ');
      tmp.SQL.Add('	begin ');
      tmp.SQL.Add('		raiserror(''error: stop_date is null'', 16, 1); ');
      tmp.SQL.Add('	end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	delete from calendar_bold ');
      tmp.SQL.Add('	where id_car = @id_car and date_ >= @start_date and date_ <= @stop_date; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	INSERT INTO dbo.calendar_bold ');
      tmp.SQL.Add('	(id_car,date_,has_data,has_gps,ev181cnt,ev14cnt,ev15cnt,ev222cnt,evdate,gpsV,gpsO, ');
      tmp.SQL.Add('	gpsS,gpsA,gpsR,nokm,has_km,meters_all,ticks,battery,battery_step,battery_datetime,starts) ');
      tmp.SQL.Add('	select t1.evb2 as id_car, ');
      tmp.SQL.Add('	dbo.get_simple_date(t1.date) as date_, ');
      tmp.SQL.Add('	CASE WHEN count(*) > 0 THEN 1 ELSE 0 END as has_data, ');
      tmp.SQL.Add('	sign(sum(CASE WHEN (t1.evb3 = 38) and (t1.evb1 = 65) THEN 1 ELSE 0 END)) as has_gps, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 181) THEN 1 ELSE 0 END) as ev181cnt, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 14) THEN 1 ELSE 0 END) as ev14cnt, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 15) and (t2.evb3 <> 175) and (dbo.get_date_diff(t2.date, t1.date) >= 300) THEN 1 ELSE 0 END) as ev15cnt, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 222) THEN 1 ELSE 0 END) as ev222cnt, ');
      tmp.SQL.Add('	max(t1.date) as evdate, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 38) and (t1.evb1 = 65) THEN 1 ELSE 0 END) as gpsA, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 38) and (t1.evb1 = 86) THEN 1 ELSE 0 END) as gpsV, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 38) and (t1.evb1 = 83) THEN 1 ELSE 0 END) as gpsS, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 38) and (t1.evb1 = 79) THEN 1 ELSE 0 END) as gpsO, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 38) and (t1.evb1 = 82) THEN 1 ELSE 0 END) as gpsR, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 85) and (t1.evb9 = 0) and (t1.evb10 = 0) THEN 1 ELSE 0 END) as nokm, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 85) and not((t1.evb9 = 0) and (t1.evb10 = 0)) THEN 1 ELSE 0 END) as has_km, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 85) THEN ((t1.evb9 * 256 + t1.evb10) * 100) ELSE 0 END) as meters_all, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 15) and (t2.evb3 <> 175) and (dbo.get_date_diff(t2.date, t1.date) < 300) THEN 1 ELSE 0 END) as ticks, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 15) and (t2.evb3 = 175) THEN 1 ELSE 0 END) as battery, ');
      tmp.SQL.Add('	0 as battery_step, ');
      tmp.SQL.Add('	NULL as battery_datetime, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 10) THEN 1 ELSE 0 END) as starts ');
      tmp.SQL.Add('	from device_data t1 left join device_data t2 on (t1.id_device_data - 1 = t2.id_device_data and t1.evb2 = t2.evb2) ');
      tmp.SQL.Add('	where t1.evb2 = @id_car and ');
      tmp.SQL.Add('		t1.id_device_data >= @start_id and ');
      tmp.SQL.Add('		t1.id_device_data <= @stop_id  ');
      tmp.SQL.Add('	group by t1.evb2, dbo.get_simple_date(t1.date) ');

      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 171) then
    begin
      

      tmp.SQL.Clear();
      tmp.SQL.Add('create procedure [dbo].[update_callendar2] ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('	delete from calendar_bold ');
      tmp.SQL.Add('	where date_ >= ''2016-12-01'' and date_ < ''2017-02-01''  ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	INSERT INTO dbo.calendar_bold ');
      tmp.SQL.Add('	(id_car,date_,has_data,has_gps) ');
      tmp.SQL.Add('	select t1.evb2 as id_car, ');
      tmp.SQL.Add('	dbo.get_simple_date(t1.date) as date_, ');
      tmp.SQL.Add('	CASE WHEN count(*) > 0 THEN 1 ELSE 0 END as has_data, ');
      tmp.SQL.Add('	sign(sum(CASE WHEN (t1.evb3 = 38) and (t1.evb1 = 65) THEN 1 ELSE 0 END)) as has_gps ');
      tmp.SQL.Add('	from device_data t1 ');
      tmp.SQL.Add('	where t1.date >= ''2016-12-01'' and t1.date < ''2017-02-01'' ');
      tmp.SQL.Add('	group by t1.evb2, dbo.get_simple_date(t1.date)  ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 172) then
    begin
      

      tmp.SQL.Clear();
      tmp.SQL.Add('create function [dbo].[InlineMax](@val1 numeric(12, 3), @val2 numeric(12, 3)) ');
      tmp.SQL.Add('returns numeric(12, 3) ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('begin ');
      tmp.SQL.Add('  if @val1 > @val2 ');
      tmp.SQL.Add('    return @val1 ');
      tmp.SQL.Add('  return isnull(@val2,@val1) ');
      tmp.SQL.Add('end ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 173) then
    begin
      

//      UaktualnijProcedureTankowania();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 174) then
    begin


 //     UaktualnijProcedureCzasuPracy();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 175) then
    begin
      

//      UaktualnijProcedureCzasuPracy();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 176) then
    begin
      

//      UaktualnijProcedureCzasuPracy();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 177) then
    begin


//      UaktualnijProcedureTankowania();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 178) then
    begin
      

//      UaktualnijProcedureCzasuPracy();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;


    if (version = 179) then
    begin
      

//      UaktualnijProcedureCzasuPracy();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 180) then
    begin


//      UaktualnijProcedureCzasuPracy();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 181) then
    begin
      

      UaktualnijProcedureTankowania();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 182) then
    begin
      

      UaktualnijProcedureCzasuPracy();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 183) then
    begin
      

      WriteIniValue('dodatkowe_ReadTimeout2', 10000);
      if ReadIniValue('dodatkowe_ReadTimeout2') <> 10000 then
          raise Exception.Create('Proszê o uruchomiæ program z uprawnieniami administratora');

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 184) then
    begin


      tmp.SQL.Clear();
      tmp.SQL.Add('alter procedure [dbo].[update_callendar] ');
      tmp.SQL.Add('(  ');
      tmp.SQL.Add('	@id_car int, ');
      tmp.SQL.Add('	@start_id bigint, ');
      tmp.SQL.Add('	@stop_id bigint ');
      tmp.SQL.Add(') ');
      tmp.SQL.Add('as ');
      tmp.SQL.Add('	declare @start_date datetime; ');
      tmp.SQL.Add('	set @start_date = null; ');
      tmp.SQL.Add('	select @start_date = date from device_data where evb2 = @id_car and id_device_data >= @start_id order by id_device_data asc; ');
      tmp.SQL.Add('	declare @stop_date datetime; ');
      tmp.SQL.Add('	set @stop_date = null; ');
      tmp.SQL.Add('	select @stop_date = date from device_data where evb2 = @id_car and id_device_data <= @stop_id order by id_device_data desc; ');
      tmp.SQL.Add('	if @start_date is null ');
      tmp.SQL.Add('	begin ');
      tmp.SQL.Add('		return 0; ');
      tmp.SQL.Add('	end ');
      tmp.SQL.Add('	if @stop_date is null ');
      tmp.SQL.Add('	begin ');
      tmp.SQL.Add('		return 0; ');
      tmp.SQL.Add('	end ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	delete from calendar_bold ');
      tmp.SQL.Add('	where id_car = @id_car and date_ >= @start_date and date_ <= @stop_date; ');
      tmp.SQL.Add(' ');
      tmp.SQL.Add('	INSERT INTO dbo.calendar_bold ');
      tmp.SQL.Add('	(id_car,date_,has_data,has_gps,ev181cnt,ev14cnt,ev15cnt,ev222cnt,evdate,gpsV,gpsO, ');
      tmp.SQL.Add('	gpsS,gpsA,gpsR,nokm,has_km,meters_all,ticks,battery,battery_step,battery_datetime,starts) ');
      tmp.SQL.Add('	select t1.evb2 as id_car, ');
      tmp.SQL.Add('	dbo.get_simple_date(t1.date) as date_, ');
      tmp.SQL.Add('	CASE WHEN count(*) > 0 THEN 1 ELSE 0 END as has_data, ');
      tmp.SQL.Add('	sign(sum(CASE WHEN (t1.evb3 = 38) and (t1.evb1 = 65) THEN 1 ELSE 0 END)) as has_gps, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 181) THEN 1 ELSE 0 END) as ev181cnt, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 14) THEN 1 ELSE 0 END) as ev14cnt, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 15) and (t2.evb3 <> 175) and (dbo.get_date_diff(t2.date, t1.date) >= 300) THEN 1 ELSE 0 END) as ev15cnt, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 222) THEN 1 ELSE 0 END) as ev222cnt, ');
      tmp.SQL.Add('	max(t1.date) as evdate, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 38) and (t1.evb1 = 65) THEN 1 ELSE 0 END) as gpsA, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 38) and (t1.evb1 = 86) THEN 1 ELSE 0 END) as gpsV, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 38) and (t1.evb1 = 83) THEN 1 ELSE 0 END) as gpsS, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 38) and (t1.evb1 = 79) THEN 1 ELSE 0 END) as gpsO, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 38) and (t1.evb1 = 82) THEN 1 ELSE 0 END) as gpsR, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 85) and (t1.evb9 = 0) and (t1.evb10 = 0) THEN 1 ELSE 0 END) as nokm, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 85) and not((t1.evb9 = 0) and (t1.evb10 = 0)) THEN 1 ELSE 0 END) as has_km, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 85) THEN ((t1.evb9 * 256 + t1.evb10) * 100) ELSE 0 END) as meters_all, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 15) and (t2.evb3 <> 175) and (dbo.get_date_diff(t2.date, t1.date) < 300) THEN 1 ELSE 0 END) as ticks, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 15) and (t2.evb3 = 175) THEN 1 ELSE 0 END) as battery, ');
      tmp.SQL.Add('	0 as battery_step, ');
      tmp.SQL.Add('	NULL as battery_datetime, ');
      tmp.SQL.Add('	sum(CASE WHEN (t1.evb3 = 10) THEN 1 ELSE 0 END) as starts ');
      tmp.SQL.Add('	from device_data t1 left join device_data t2 on (t1.id_device_data - 1 = t2.id_device_data and t1.evb2 = t2.evb2) ');
      tmp.SQL.Add('	where t1.evb2 = @id_car and ');
      tmp.SQL.Add('		t1.id_device_data >= @start_id and ');
      tmp.SQL.Add('		t1.id_device_data <= @stop_id  ');
      tmp.SQL.Add('	group by t1.evb2, dbo.get_simple_date(t1.date) ');

      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    while (version >= 185) and  (version <= 222) do
    begin
      

      if FileExists(StriptsPath() + IntToStr(version) + '.sql') then
      begin
         // celowo nie zaczytuje, wycofuje sie tymczasowo z partycjonowania
//          tmp.SQL.Clear();
//          tmp.SQL.LoadFromFile(StriptsPath() + IntToStr(version) + '.sql');
          try
//              tmp.ExecSQL();
          except
              on e: Exception do
              begin
                  raise Exception.Create('Skrypt nr ' + IntToStr(version) + ' ' + e.Message);
              end;
          end;
      end;

      UpdateVersion(version);
    end;

    while (version >= 223) and  (version <= 241) do
    begin


      if FileExists(StriptsPath() + IntToStr(version) + '.txt') then
      begin
         // celowo nie zaczytuje, wycofuje sie tymczasowo z partycjonowania
          tmp.SQL.Clear();
          tmp.SQL.LoadFromFile(StriptsPath() + IntToStr(version) + '.txt');
          try
              tmp.ExecSQL();
          except
              on e: Exception do
              begin
                  raise Exception.Create('Skrypt nr ' + IntToStr(version) + ' ' + e.Message);
              end;
          end;
      end;

      UpdateVersion(version);
    end;

    while (version >= 242) and  (version <= 289) do
    begin
      

      if FileExists(StriptsPath() + IntToStr(version) + '.sql') then
      begin
          tmp.SQL.Clear();
          tmp.SQL.LoadFromFile(StriptsPath() + IntToStr(version) + '.sql');
          try
              tmp.ExecSQL();
          except
              on e: Exception do
              begin
                  raise Exception.Create('Skrypt nr ' + IntToStr(version) + ' ' + e.Message);
              end;
          end;
      end;

      UpdateVersion(version);
    end;

    if (version = 290) then
    begin
      

      WriteIniValue('dodatkowe_ReadTimeout2', 10000);
      if ReadIniValue('dodatkowe_ReadTimeout2') <> 10000 then
          raise Exception.Create('Proszê o uruchomiæ program z uprawnieniami administratora');
      WriteIniValue('dodatkowe_ConnectTimeout2', 10000);
      if ReadIniValue('dodatkowe_ConnectTimeout2') <> 10000 then
          raise Exception.Create('Proszê o uruchomiæ program z uprawnieniami administratora');

      WriteIniValue('dodatkowe_ConnectTimeout2222', 10000);
      if ReadIniValue('dodatkowe_ConnectTimeout2222') <> 10000 then
          raise Exception.Create('Proszê o uruchomiæ program z uprawnieniami administratora');

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 291) then
    begin
      

      WriteIniValue('dodatkowe_ReadTimeout2', 60000);
      if ReadIniValue('dodatkowe_ReadTimeout2') <> 60000 then
          raise Exception.Create('Proszê o uruchomiæ program z uprawnieniami administratora');
      WriteIniValue('dodatkowe_ConnectTimeout2', 60000);
      if ReadIniValue('dodatkowe_ConnectTimeout2') <> 60000 then
          raise Exception.Create('Proszê o uruchomiæ program z uprawnieniami administratora');

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 292) then
    begin


      tmp.SQL.Clear();
      tmp.SQL.Add('update mail_settings set serwerpop3 = ''93.179.233.222'' ');
      tmp.ExecSQL();


      tmp.SQL.Clear();
      tmp.SQL.Add('update mail_settings set serwersmtp = ''93.179.233.222'' ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    if (version = 293) then
    begin

      tmp.SQL.Clear();
      tmp.SQL.Add('alter table device_data add mpal1 tinyint, mpal2 tinyint ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    // nowe paliwo z zestawienie Excelowym i poprawnymi first_bak i last_bak
    while (version >= 294) and  (version <= 296) do
    begin
      if FileExists(StriptsPath() + IntToStr(version) + 'newfuel.sql') then
      begin
          tmp.SQL.Clear();
          tmp.SQL.LoadFromFile(StriptsPath() + IntToStr(version) + 'newfuel.sql');
          try
              tmp.ExecSQL();
          except
              on e: Exception do
              begin
                  raise Exception.Create('Skrypt nr ' + IntToStr(version) + 'newfuel ' + e.Message);
              end;
          end;
      end
      else
          raise Exception.Create('Nie znaleziono plik *.sql : ' + StriptsPath() + IntToStr(version) + 'newfuel.sql');

      UpdateVersion(version);
    end;

    // old fuel - do odtworzenia w oknie ustawieñ
    while (version >= 297) and  (version <= 298) do
    begin
      UpdateVersion(version);
    end;

    if (version = 299) then
    begin
      WriteIniValue('dodatkowe_FastFuelChartLoad', 0);
      if ReadIniValue('dodatkowe_FastFuelChartLoad') <> 0 then
          raise Exception.Create('Proszê o uruchomiæ program z uprawnieniami administratora');

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    // fast fuel chart load
    while (version >= 300) and  (version <= 301) do
    begin
      if FileExists(StriptsPath() + IntToStr(version) + 'fastchartload.sql') then
      begin
          tmp.SQL.Clear();
          tmp.SQL.LoadFromFile(StriptsPath() + IntToStr(version) + 'fastchartload.sql');
          try
              tmp.ExecSQL();
          except
              on e: Exception do
              begin
                  raise Exception.Create('Skrypt nr ' + IntToStr(version) + 'fastchartload ' + e.Message);
              end;
          end;
      end
      else
          raise Exception.Create('Nie znaleziono plik *.sql : ' + StriptsPath() + IntToStr(version) + 'fastchartload.sql');

      UpdateVersion(version);
    end;

    while (version >= 302) and  (version <= 305) do
    begin
      if FileExists(StriptsPath() + IntToStr(version) + '.sql') then
      begin
          tmp.SQL.Clear();
          tmp.SQL.LoadFromFile(StriptsPath() + IntToStr(version) + '.sql');
          try
              tmp.ExecSQL();
          except
              on e: Exception do
              begin
                  raise Exception.Create('Skrypt nr ' + IntToStr(version) + ' ' + e.Message);
              end;
          end;
      end
      else
          raise Exception.Create('Nie znaleziono plik *.sql : ' + StriptsPath() + IntToStr(version) + '.sql');

      UpdateVersion(version);
    end;

    if (version = 306) then
    begin

      tmp.SQL.Clear();
      tmp.SQL.Add('delete from device_data where evb3 in ');
      tmp.SQL.Add('(select 117 ');
      tmp.SQL.Add('union ');
      tmp.SQL.Add('select 118 ');
      tmp.SQL.Add('union ');
      tmp.SQL.Add('select 217 ');
      tmp.SQL.Add('union ');
      tmp.SQL.Add('select 218) ');
      tmp.ExecSQL();

      Inc(version);
      tmp.SQL.Clear();
      tmp.SQL.Add('update versions set version = ' + IntToStr(version));
      tmp.ExecSQL();
    end;

    while (version >= 307) and  (version <= 308) do
    begin
      if FileExists(StriptsPath() + IntToStr(version) + '.sql') then
      begin
          tmp.SQL.Clear();
          tmp.SQL.LoadFromFile(StriptsPath() + IntToStr(version) + '.sql');
          try
              tmp.ExecSQL();
          except
              on e: Exception do
              begin
                  raise Exception.Create('Skrypt nr ' + IntToStr(version) + ' ' + e.Message);
              end;
          end;
      end
      else
          raise Exception.Create('Nie znaleziono plik *.sql : ' + StriptsPath() + IntToStr(version) + '.sql');

      UpdateVersion(version);
    end;

    except
        on e: Exception do
        begin

//            Clipboard().AsText := 'Cannot open database "' + nazwaBazy + '" requested by the login. The login failed' + #13 + #10 +
//                                  e.Message;
            if (Pos('Cannot open database', e.Message) > 0) or
               (Pos('FATAL:  database "' + nazwaBazy + '" does not exist', e.Message) > 0) then
            begin
                if (LowerCase(Trim(nazwaBazy)) = 'master') or
                       (LowerCase(Trim(nazwaBazy)) = 'model') or
                       (LowerCase(Trim(nazwaBazy)) = 'msdb') or
                       (LowerCase(Trim(nazwaBazy)) = 'tempdb') then
                begin
                    raise;
                end
                else
                begin
                     //tworzenie nowej bazy danych
                    raise EAbort.Create('Przerwanie operacji');

                    dane := TStringList.Create();
                    dane.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini');


                end;
            end
            else
            if Pos('[DBNETLIB][ConnectionOpen (Connect()).]', e.Message) > 0 then
            begin
                exit;
            end
            else
            begin
                raise;
            end;
        end;
    end;
end;

function TTEDEmailSrv.PobierzPoczte(): boolean;
begin
    result := true;
try
   try
      if POP.Connected then
      begin
          AddLog('5440 Is Connected: try to disconnect in PobierzPoczte ...');
          try
              POP.Disconnect();
          except
              on e: exception do
              begin
                  AddLog('5446 exception on disconect: ' + e.Message);
              end;
          end;
          try
              POP.Reset();
          except
              on e: exception do
              begin
                  AddLog('5454 exception on reset: ' + e.Message);
              end;
          end;
          try
              POP.Disconnect();
          except
              on e: exception do
              begin
                  AddLog('5462 exception on disconect: ' + e.Message);
              end;
          end;

          AddLog('5466 after reset in PobierzPoczte');
      end
      else
          AddLog('5469 not connected: disconnect in PobierzPoczte not needed');
   except
       on e: Exception do
       begin
            AddLog('5473 exception: ' + e.Message);
       end;
   end;

   qMailSettings.Open();
   qMailSettings.First();
   POP.Host := qMailSettings.FieldByName('serwerpop3').AsString;
//   if Pos('@tednet.strefa.pl', POP.Username) > 0 then
//      POP.Port := 995
//      POP.Port := 110
//   else
      POP.Port := 110;
   POP.Username := qMailSettings.FieldByName('konto').AsString;
   POP.Password := DecodePass(qMailSettings.FieldByName('haslo').AsString);
   qMailSettings.Close();

   if POP.Host = '' then
   begin
       result := false;
       exit;
//       raise Exception.Create('Konto pocztowe jest nieskonfigurowane');
   end;

   try

       POP.ConnectTimeout := 30000;
       POP.Connect();
   except
       on e: Exception do
       begin
           AddLog('5506 raise higher ' + e.Message);
           raise;
       end;
   end;
   try
       FMsgCount := POP.CheckMessages;
       FMailBoxSize := POP.RetrieveMailBoxSize div 1024;
   except
       on e: EIdConnClosedGracefully do
       begin

       end
       else
           raise;
   end;
   if FMsgCount > 0 then
   begin
      if FMsgCount > 1 then
      begin
         if FMsgCount > 100 then
         begin
//             tmp.Close();
//             tmp.SQL.Clear();
//             tmp.SQL.Add('delete from lista_maili where id not in ( ');
//             tmp.SQL.Add('select top ' + IntToStr(FMsgCount + 100) + ' id from lista_maili order by dataczas desc )');
//             tmp.ExecSQL();
         end;
      end;
      RetrievePOPHeaders(FMsgCount);
//      lvHeaders.SortType := stData;
//      lvHeaders.SortType := stNone;
   end
   else
      begin
      end;
finally
   pop3_in_work := False;
//   if Pos('@tednet.strefa.pl', POP.Username) = 0 then
//      POP.Disconnect();
end;

   aImportExecute(nil);
end;

procedure TTEDEmailSrv.RetrievePOPHeaders(inMsgCount: Integer);
var
   intIndex: integer;
   itm: TListItem2;
   akc_temat, akc_nadawca: AnsiString;
   car_no: Integer;
   tytul2: String;
   licznik: Integer;
   rozmiar: Integer;
   ilosc_pojazdow: Integer;
   last_mail: Integer;
   last_mail_date: TDateTime;
   last_car: Integer;
begin
    AddLog('Email: ' + pop.Username + #13 + #10);


    qMailSettings.Open();
    qMailSettings.First();
    akc_temat := 'GPRS 00';
    akc_nadawca := qMailSettings.FieldByName('nadawca').AsString;
    qMailSettings.Close();
    rozmiar := 0;

    tmp2.Close();
    tmp2.SQL.Clear();
    tmp2.SQL.Add('select count(*) ilosc_pojazdow from car');
    tmp2.Open();
    ilosc_pojazdow := tmp2.FieldByName('ilosc_pojazdow').AsInteger;
    tmp2.Close();

   lvHeaders.Clear;
   licznik := 0;

   last_mail := 1;
   last_car := 0;
   last_mail_date := 0;

{
  mailBoxes := TStringList.Create();
  pop.ListMailBoxes(mailBoxes);
  AddLog('ListMailBoxes:' + #13 + #10);
  for i := 0 to mailBoxes.Count - 1 do
      AddLog('   ' + mailBoxes.Strings[i] + #13 + #10);
  AddLog(#13 + #10);

  mailBoxes.Clear();

  if Pos('tednet.strefa.pl', pop.Username) > 0 then
  begin
      mailBoxes.Add('INBOX/Pobrane programem pocztowym (do 02-12-2015)');
      mailBoxes.Add('INBOX');
  end
  else
      mailBoxes.Add('INBOX');

  mc := TIdMessageCollection.Create(TIdMessageItem);
}

//  memStream := TMemoryStream.Create();

//  if not pop.SelectMailBox('INBOX/Pobrane programem pocztowym (do 02-12-2015)') then
//      raise Exception.Create('Nie mogê zmienic mailbox na INBOX/Pobrane programem pocztowym (do 02-12-2015)');

//  for j := 0 to mailBoxes.Count - 1 do
  begin
//      AddLog(#13 + #10 + 'Zmiana na mailbox: ' + mailBoxes.Strings[j]  + #13 + #10);

//      if not pop.SelectMailBox(mailBoxes.Strings[j]) then
//          raise Exception.Create('Nie mogê zmienic mailbox na ' + mailBoxes.Strings[j]);

//      mc.Clear();

//      AddLog('INBOX FirstUnseenMsg: ' + IntToStr(pop.MailBox.FirstUnseenMsg)  + #13 + #10);
//      AddLog('INBOX TotalMsgs: ' + IntToStr(pop.MailBox.TotalMsgs) + #13 + #10);
//      AddLog('INBOX UnseenMsgs: ' + IntToStr(pop.MailBox.UnseenMsgs) + #13 + #10);

//      inMsgCount := pop.MailBox.TotalMsgs;
      inMsgCount := pop.CheckMessages;


     for intIndex := inMsgCount downto last_mail do
//     for intIndex := last_mail to inMsgCount do
     begin
       try
           // Clear the message properties
  //         ShowStatus(format(translator.GetTranslatedText(88, 'Wiadomoœæ %d z %d'), [inMsgCount - intIndex + 1, inMsgCount]));
//           ShowStatus(format(translator.GetTranslatedText(88, 'Wiadomoœæ %d z %d'), [intIndex, inMsgCount]));
//           ProcessMessages;
           Msg.Clear;
           try
  //             if (Pos('strefa.pl', pop.Username) > 0) then
  //             begin
  //                 pop.RetrieveHeader(inMsgCount - intIndex + 1, Msg);
  //             end
  //             else
               begin
                  pop.RetrieveHeader(intIndex, Msg);
               end;

               if (last_mail_date <> 0) and
                      (GetEmailDate(Msg) < last_mail_date) then
               begin
//                   Caption := DateTimeToStr(GetEmailDate(Msg));
                   break;
               end;

               try
                   car_no := Hex2Dec(Copy(GetSubject2(msg), Length(GetSubject2(msg)) - 3, 2));
               except
                   car_no := 0;
               end;

               if (last_car <> 0) and
                        (last_car <> car_no) then
               begin
                   continue;
               end;

  //             if (Pos('strefa.pl', pop.Username) > 0) then
  //                 rozmiar := pop.RetrieveMsgSize(inMsgCount - intIndex + 1)
  //             else
                   rozmiar := pop.RetrieveMsgSize(intIndex);
           except
               on e: EIdConnClosedGracefully do
               begin

               end;
               on e: Exception do
               begin
                   AddLog('5685 ' + e.Message);
                   continue;
               end;
           end;

//           AddLog('akc_temat:' + akc_temat + #13 + #10);
//           AddLog('GetSubject2():' + GetSubject2(msg) + #13 + #10);
//           AddLog('akc_nadawca:' + akc_nadawca + #13 + #10);
//           AddLog('Msg.From.Text:' + Msg.From.Text + #13 + #10);

           // Add info to ListView
           if  { (tbSaveToDatabase.Enabled) and } (
                  (Pos(akc_temat, GetSubject2(msg)) = 1) or
                  (Pos(akc_temat_ustawienia, GetSubject2(msg)) = 1) ) and
                  (AnsiLowerCase(akc_nadawca) = AnsiLowerCase(Msg.From.Text)) then
           begin
               if not CzyBylJuzCzytany(GetEmailDate(Msg), Msg.From.Text, GetSubject2(msg), rozmiar, Msg.MsgId)
                          { and (GetEmailDate(Msg) >= EncodeDate(1980, 1, 1)) } then
               begin
                   itm := lvHeaders.Add;
                   itm.ImageIndex := 5;
                   itm.Caption := GetSubject2(msg);
                   if Pos(akc_temat_ustawienia, GetSubject2(msg)) <> 1 then
                   begin
                     try
                         car_no := Hex2Dec(Copy(itm.Caption, Length(itm.Caption) - 3, 2));
                     except
                         car_no := -1;
                     end;
                     qPojazdy2.Close();
                     try
                         qPojazdyZKierowcami.Open();
                         qPojazdyZKierowcami.First();
                         if qPojazdyZKierowcami.Locate('id_car', car_no, []) then
                             tytul2 := qPojazdyZKierowcami.FieldByName('id_car').AsString + '. ' +
                                      Trim(qPojazdyZKierowcami.FieldByName('name').AsString) + ' ' +
                                      Trim(qPojazdyZKierowcami.FieldByName('rej_numb').AsString) + ' ' +
                                      Trim(qPojazdyZKierowcami.FieldByName('driver_name').AsString)
                         else
                             tytul2 := GetSubject2(msg);
                     finally
                         qPojazdyZKierowcami.Close();
                     end;
                   end
                   else
                     tytul2 := GetSubject2(msg);

                   itm.SubItems.Add(tytul2);
                   itm.SubItems.Add(Msg.From.Text);
                   itm.SubItems.Add(DateTimeToStr(GetEmailDate(Msg)));
  //                 if (Pos('strefa.pl', pop.Username) > 0) then
  //                 begin
  //                     itm.SubItems.Add(IntToStr(pop.RetrieveMsgSize(inMsgCount - intIndex + 1)));
  //                     itm.Data := Pointer(inMsgCount - intIndex + 1);
  //                 end
  //                 else
  //                 begin
                       itm.SubItems.Add(IntToStr(pop.RetrieveMsgSize(intIndex)));
                       itm.Data := Pointer(intIndex);
  //                 end;

                   itm.SubItems.Add(Msg.UID);

//                   itm.SubItems.Add(pop.MailBox.Name);
                   itm.SubItems.Add('INBOX');
                   itm.SubItems.Add(Msg.MsgId);
                   licznik := 0;
               end
               else
               begin
                   Inc(licznik);

                   if licznik = (ilosc_pojazdow + 15) then
                       break;
               end;
           end
{           else
           if not (tbSaveToDatabase.Enabled) then
           begin
               itm := lvHeaders.Items.Insert(0);
               itm.ImageIndex := 5;
               itm.Caption := GetSubject2(msg);
               itm.SubItems.Add(GetSubject2(msg));
               itm.SubItems.Add(Msg.From.Text);
               itm.SubItems.Add(DateTimeToStr(GetEmailDate(Msg)));
  //             if (Pos('strefa.pl', pop.Username) > 0) then
  //                 itm.SubItems.Add(IntToStr(pop.RetrieveMsgSize(inMsgCount - intIndex + 1)))
  //             else
                   itm.SubItems.Add(IntToStr(pop.RetrieveMsgSize(intIndex)));
  //             if (Pos('strefa.pl', pop.Username) > 0) then
  //                 itm.Data := Pointer(inMsgCount - intIndex + 1)
  //             else
                   itm.Data := Pointer(intIndex);
               itm.SubItems.Add(Msg.UID);

//               itm.SubItems.Add(pop.MailBox.Name);
               itm.SubItems.Add('INBOX');
               itm.SubItems.Add(Msg.MsgId);

           end; }
       except
           on e: Exception do
           begin
               AddLOg('5788 ' + e.Message);
               break;
           end;
       end;
     end;
   end;

//   ShowStatus(stTemp);
end;

procedure TTEDEmailSrv.aImportExecute(Sender: TObject);
var
   stTemp: string;
   intIndex: Integer;
//   li: TListItem;
   plik: AnsiString;
   stream: TStream;
   stream2: TStream;
   stream3: TStringStream;
   archiwum: TBLTArchive;
   dataset: TStreamDataSet;
   xml_md5: AnsiString;
   boolResult : boolean ;

//   part: TIdText;
   xml: AnsiString;

   szesnastka: array [0..15] of byte;
   dziesiatka: array [0..9] of byte;
   i, licznik: Integer;
   e: Integer;
   machine_no: Integer;
   ostatni_rekord, ostatni_rekord2: String;
   ExtraRecordsCount: Integer;
   kiedy: String;
   ii: Integer;
   evbDescribe: array [0..255] of String;
   j: Integer;
//   ile_rekordow: Integer;

    sek11, sek12, sek21, sek22: Integer;
    dlugosc_str, szerokosc_str: String;
    kiedy_tmp: String;

//    licznik2: Integer;
//    licznik3: Integer;
//    znak: Char;

    lastpal1: Integer;
    lastmpal1: Integer;
    lastpal2: Integer;
    lastmpal2: Integer;

    GPStxt: String;
    czy_kontynuowac: Boolean;
    tmp: String;
    errorString: String;
    itm, itm2: TListItem2;

//    last_event_datetime: TDateTime;
    oldShortDateFormat: String;
    oldDateSeparator: Char;
    adres_pierwszego_zdarzenia: Integer;
    adres_device1, adres_device2, adres_device3: Integer;
    zostal_zapisany_mail: Boolean;

    identyfikator16cyfrowy: array [1..16] of Integer;
    identyfikator16cyfrowy2: String;
    bylo174: Boolean;

    kiedy_tmp2: string;
    dataczas2: TDateTime;

    kiedy_poprzedni: string;
    dataczas_przed_15: TDateTime;

    znak1, znak2: Char;
    wersja2: Integer;
    wersja3: String;
    roaming_flag: Integer;
    kiedy_tmp66: String;
    dataczas66: TDateTime;

    change_date: TDateTime;
    car_count: Integer;
    send_date: TDateTime;
    del_car_id: Integer;
    del_car_name: String;
    del_car_rej_numb: String;
    default_: Integer;

    xml_stream: TStringStream;

    teraz: TDateTime;
    id_settings_history: Integer;
    xml_stream2: TStream;

    dozwolone_zdarzenia: array [0..256] of Boolean;

begin
    zostal_zapisany_mail := False;


    if pop.Host = '' then
       raise Exception.Create('5892 Konto pocztowe jest nieskonfigurowane');

    if pop3_in_work then
       exit;

    for j := 1 to 16 do
        identyfikator16cyfrowy[j] := 0;


   for i := 0 to 256 do
       dozwolone_zdarzenia[i] := False;

   self.tmp.Close();
   self.tmp.SQL.Clear();
   self.tmp.SQL.Add('select * from event');
   self.tmp.Open();
   while not self.tmp.Eof do
   begin
       dozwolone_zdarzenia[self.tmp.FieldByName('id_event').AsInteger] := True;
       self.tmp.Next();
   end;
   self.tmp.Close();


//   last_event_datetime := 0;

    try
        pop3_in_work := True;
        if (Length(lvHeaders.Items) > 0) then
            try

               if not pop.Connected then
               begin
                 try
                   pop.ConnectTimeout := 30000;
                   pop.Connect();
                 except
                     on e: EIdConnClosedGracefully do
                     begin
//                         ShowStatus('');
              //           Showbusy(False);
              //           raise ETranslatedException.Create(7, ''Skonfiguruj najpierw parametry konta pocztowego, na które urz¹dzenia wysy³aj¹ maile',
              //            []);
                     end;
                     on e: Exception do
                     begin
//                         ShowStatus('');
//                         Showbusy(False);
                         raise;
                     end;
                 end;
               end;
            except
               on e: EIdConnClosedGracefully do
               begin
//                   ShowStatus('');
        //           Showbusy(False);
        //           raise ETranslatedException.Create(7, ''Skonfiguruj najpierw parametry konta pocztowego, na które urz¹dzenia wysy³aj¹ maile',
        //            []);
               end;
               on e: Exception do
               begin
//                   Showbusy(False);
                   raise;
               end;
            end;
        try
            while (Length(lvHeaders.Items) > 0) do
            begin
                lvHeaders.Selected := lvHeaders.Items[0];

//                lvHeaders.Update();
//                ProcessMessages();

                Msg.Clear;
                kiedy := '';

//                if pop.MailBox.Name <> lvHeaders.Selected.SubItems.Strings[5] then
//                begin
//                    if not pop.SelectMailBox(lvHeaders.Selected.SubItems.Strings[5]) then
//                        raise Exception.Create('SelectMailBox error ' + lvHeaders.Selected.SubItems.Strings[5]);
//                end;


                //get message and put into MSG
//                ShowStatus(translator.GetTranslatedText(83, 'Œci¹ganie wiadomoœci') + ' "' + lvHeaders.Selected.Caption + '"');
                try
                    pop.Retrieve(Integer(lvHeaders.Selected.Data), Msg);
                except
                    on e: EIdConnClosedGracefully do
                    begin

                    end
                    else
                        raise;
                end;
//                statusbar.Panels[0].text := lvHeaders.Selected.Caption;

                //Setup attachments list
//                ShowStatus(translator.GetTranslatedText(84, 'Dekodowanie za³¹cznika') + ' (' + IntToStr(Msg.MessageParts.Count) + ')');
                for intIndex := 0 to Pred(Msg.MessageParts.Count) do
                begin
                    if (Msg.MessageParts.Items[intIndex] is TIdAttachmentFile) then
                    begin //general attachment
                        dataczas_przed_15 := 0;


                        machine_no := 0;

                        MegaRam.Open();
                        MegaRam.First();
                        while not MegaRam.Eof do
                        begin
                            MegaRam.Delete();
                            MegaRam.First();
                        end;

                        bylo174 := False;


                        stream := TMemoryStream.Create();
                        TIdAttachmentFile(Msg.MessageParts.Items[intIndex]).SaveToStream(stream);

                        stream.Position := 0;

                        stream.Read(szesnastka, 16);
                        adres_pierwszego_zdarzenia := stream.Position;

                        while stream.Position < stream.Size do
                        begin
                            if (stream.Size - stream.Position) = 16 then
                            begin
                                stream.Read(szesnastka, 16);
                            end
                            else
                            begin
                                e := stream.Read(dziesiatka, 10);

                                if (stream.Position = (16 + 10)) and (Integer(dziesiatka[2]) = 173)
                                       and (adres_pierwszego_zdarzenia = 16) then
                                 begin
                                     stream.Position := stream.Size - 16;
                                     stream.Read(szesnastka, 16);
                                     adres_device1 := Integer(szesnastka[1]) * 256 + Integer(szesnastka[2]);
                                     adres_device2 := Integer(szesnastka[4]) * 256 + Integer(szesnastka[5]);
                                     adres_device3 := Integer(szesnastka[7]) * 256 + Integer(szesnastka[8]);
                                     if adres_device2 = adres_device3 then
                                         adres_device1 := adres_device2;
                                     adres_pierwszego_zdarzenia := adres_device1 - $1210 + 16;
                                     if Integer(szesnastka[3]) <> 0 then
                                         adres_pierwszego_zdarzenia := adres_pierwszego_zdarzenia + $FF90 - $1210;
                                     stream.Position := adres_pierwszego_zdarzenia;
                                     if (stream.Size - stream.Position) = 16 then
                                          stream.Position := 16;
                                     continue;
                                end;

                                try
                                   dziesiatka[1] := byte(Hex2Dec(Copy(GetSubject2(Msg), Length(GetSubject2(Msg)) - 3, 2)));
                                except

                                end;

                                if not (Integer(dziesiatka[2]) in [36, 37, 38, 39, 46, 45]) then
                                begin
                                    tmp := BCBToStringWithError(
                                                         dziesiatka[1],
                                                         dziesiatka[2],
                                                         dziesiatka[4],
                                                         dziesiatka[5],
                                                         dziesiatka[6],
                                                         dziesiatka[7]);
                                    try
                                        DateTimeToBCB(StrToDateTime(tmp) - TimeZoneBias(),
                                                         dziesiatka[4],
                                                         dziesiatka[5],
                                                         dziesiatka[6],
                                                         dziesiatka[7]);
          //                                last_event_datetime := StrToDateTime(tmp) - TimeZoneBias();
                                    except

                                    end;

                                    if Integer(dziesiatka[2]) = 15 then
                                    begin
                                        tmp := BCBToStringWithError(dziesiatka[1],
                                                             dziesiatka[2],
                                                             dziesiatka[0],
                                                             dziesiatka[3],
                                                             dziesiatka[8],
                                                             dziesiatka[9]);
                                        try
                                            DateTimeToBCB(StrToDateTime(tmp) - TimeZoneBias(),
                                                             dziesiatka[0],
                                                             dziesiatka[3],
                                                             dziesiatka[8],
                                                             dziesiatka[9]);
                                        except

                                        end;
                                    end;
                                end;



                                if dozwolone_zdarzenia[Integer(dziesiatka[2])] and
                                           (e = 10) and
                                           (not ((Integer(dziesiatka[0]) = 255) and
                                                 //(Integer(dziesiatka[1]) = 255) and
                                                 (Integer(dziesiatka[2]) = 255) and
                                                 (Integer(dziesiatka[3]) = 255) and
                                                 (Integer(dziesiatka[4]) = 255) and
                                                 (Integer(dziesiatka[5]) = 255) and
                                                 (Integer(dziesiatka[6]) = 255) and
                                                 (Integer(dziesiatka[7]) = 255) and
                                                 (Integer(dziesiatka[8]) = 255) and
                                                 (Integer(dziesiatka[9]) = 255))) then
                                begin
                                    MegaRam.Append();
                                    MegaRam.FieldByName('evb1').AsFloat := Integer(dziesiatka[0]);
                                    MegaRam.FieldByName('evb2').AsFloat := Integer(dziesiatka[1]);
                                    MegaRam.FieldByName('evb3').AsFloat := Integer(dziesiatka[2]);
                                    if (machine_no = 0) and not (MegaRam.FieldByName('evb3').AsInteger in [36, 37, 38, 39, 46, 45]) then
                                        machine_no := Integer(dziesiatka[1]);
                                    MegaRam.FieldByName('evb4').AsFloat := Integer(dziesiatka[3]);
                                    MegaRam.FieldByName('evb5').AsFloat := Integer(dziesiatka[4]);
                                    MegaRam.FieldByName('evb6').AsFloat := Integer(dziesiatka[5]);
                                    MegaRam.FieldByName('evb7').AsFloat := Integer(dziesiatka[6]);
                                    MegaRam.FieldByName('evb8').AsFloat := Integer(dziesiatka[7]);
                                    MegaRam.FieldByName('evb9').AsFloat := Integer(dziesiatka[8]);
                                    MegaRam.FieldByName('evb10').AsFloat := Integer(dziesiatka[9]);
                                    MegaRam.Post();

                                    if MegaRam.FieldByName('evb3').AsFloat = 10 then
                                    begin
                                        tmp5.Close();
                                        tmp5.SQL.Clear();
                                        tmp5.SQL.Add('update car set gr1 = ' + IntToStr(MegaRam.FieldByName('evb9').AsInteger) +
                                           ' where id_car = ' + IntToStr(MegaRam.FieldByName('evb2').AsInteger));
                                        tmp5.ExecSQL();
                                    end;

                                    if MegaRam.FieldByName('evb3').AsFloat = 222 then
                                    begin
                                        try
                                            kiedy_tmp2 := BCBToString( byte(MegaRam.FieldByName('evb2').AsInteger),
                                                         byte(MegaRam.FieldByName('evb3').AsInteger),
                                                         byte(MegaRam.FieldByName('evb5').AsInteger),
                                                         byte(MegaRam.FieldByName('evb6').AsInteger),
                                                         byte(MegaRam.FieldByName('evb7').AsInteger),
                                                         byte(MegaRam.FieldByName('evb8').AsInteger));
                                            dataczas2 := StrToDateTime(kiedy_tmp2);

                                            tmp5.Close();
                                            tmp5.SQL.Clear();
                                            tmp5.SQL.Add('update car set last_222_datetime = :last_222_datetime ' +
                                                ' where id_car = ' + IntToStr(MegaRam.FieldByName('evb2').AsInteger));
                                            tmp5.Parameters.ParamByName('last_222_datetime').Value := dataczas2;
                                            tmp5.ExecSQL();
                                        except

                                        end;
                                    end;

                                    if MegaRam.FieldByName('evb3').AsFloat = 15 then
                                    begin
                                        try
                                            kiedy_tmp2 := BCBToString(byte(MegaRam.FieldByName('evb2').AsInteger),
                                                         byte(MegaRam.FieldByName('evb3').AsInteger),
                                                         byte(MegaRam.FieldByName('evb5').AsInteger),
                                                         byte(MegaRam.FieldByName('evb6').AsInteger),
                                                         byte(MegaRam.FieldByName('evb7').AsInteger),
                                                         byte(MegaRam.FieldByName('evb8').AsInteger));
                                            dataczas2 := StrToDateTime(kiedy_tmp2);

                                            if (((dataczas2 - dataczas_przed_15) * 1440.0) > 3.0) and (dataczas_przed_15 <> 0) then // minuty
                                            begin
                                                tmp5.Close();
                                                tmp5.SQL.Clear();
                                                tmp5.SQL.Add('update car set last_15_datetime = :last_15_datetime ' +
                                                    ' where id_car = ' + IntToStr(MegaRam.FieldByName('evb2').AsInteger));
                                                tmp5.Parameters.ParamByName('last_15_datetime').Value := dataczas2;
                                                tmp5.ExecSQL();
                                            end;
                                        except

                                        end;
                                    end
                                    else
                                    if not (MegaRam.FieldByName('evb3').AsInteger in [117, 217, 85, 36, 37, 38, 39, 174, 175, 45]) then
                                    begin
                                        try
                                            kiedy_poprzedni := BCBToString( byte(MegaRam.FieldByName('evb2').AsInteger),
                                                             byte(MegaRam.FieldByName('evb3').AsInteger),
                                                             byte(MegaRam.FieldByName('evb5').AsInteger),
                                                             byte(MegaRam.FieldByName('evb6').AsInteger),
                                                             byte(MegaRam.FieldByName('evb7').AsInteger),
                                                             byte(MegaRam.FieldByName('evb8').AsInteger));
                                            dataczas_przed_15 := StrToDateTime(kiedy_poprzedni);
                                        except

                                        end;
                                    end;

                                    if MegaRam.FieldByName('evb3').AsFloat = 174 then
                                    begin
                                        identyfikator16cyfrowy[1] := MegaRam.FieldByName('evb1').AsInteger;
                                        identyfikator16cyfrowy[2] := MegaRam.FieldByName('evb4').AsInteger;
                                        identyfikator16cyfrowy[3] := MegaRam.FieldByName('evb5').AsInteger;
                                        identyfikator16cyfrowy[4] := MegaRam.FieldByName('evb6').AsInteger;
                                        identyfikator16cyfrowy[5] := MegaRam.FieldByName('evb7').AsInteger;
                                        identyfikator16cyfrowy[6] := MegaRam.FieldByName('evb8').AsInteger;
                                        identyfikator16cyfrowy[7] := MegaRam.FieldByName('evb9').AsInteger;
                                        identyfikator16cyfrowy[8] := MegaRam.FieldByName('evb10').AsInteger;
                                        bylo174 := True;
                                    end;

                                    if (MegaRam.FieldByName('evb3').AsFloat = 175) and bylo174 then
                                    begin
                                        identyfikator16cyfrowy[9]  := MegaRam.FieldByName('evb1').AsInteger;
                                        identyfikator16cyfrowy[10] := MegaRam.FieldByName('evb4').AsInteger;
                                        identyfikator16cyfrowy[11] := MegaRam.FieldByName('evb5').AsInteger;
                                        identyfikator16cyfrowy[12] := MegaRam.FieldByName('evb6').AsInteger;
                                        identyfikator16cyfrowy[13] := MegaRam.FieldByName('evb7').AsInteger;
                                        identyfikator16cyfrowy[14] := MegaRam.FieldByName('evb8').AsInteger;
                                        identyfikator16cyfrowy[15] := MegaRam.FieldByName('evb9').AsInteger;
                                        identyfikator16cyfrowy[16] := MegaRam.FieldByName('evb10').AsInteger;

                                        identyfikator16cyfrowy2 := '';
                                        for ii := 1 to 16 do
                                            identyfikator16cyfrowy2 := identyfikator16cyfrowy2 + Char(identyfikator16cyfrowy[ii]);

                                        tmp5.Close();
                                        tmp5.SQL.Clear();
                                        tmp5.SQL.Add('update car set ident2 = :ident2 where id_car = ' + IntToStr(MegaRam.FieldByName('evb2').AsInteger));
                                        tmp5.Parameters.ParamByName('ident2').Value := identyfikator16cyfrowy2;
                                        tmp5.ExecSQL();
                                    end;

                                    if (MegaRam.FieldByName('evb3').AsFloat = 66) and
                                       (MegaRam.FieldByName('evb1').AsInteger <> 0) then
                                    begin
                                        znak1 := Char(MegaRam.FieldByName('evb1').AsInteger);
                                        znak2 := Char(MegaRam.FieldByName('evb4').AsInteger);
                                        wersja2 := MegaRam.FieldByName('evb9').AsInteger;
                                        roaming_flag := MegaRam.FieldByName('evb10').AsInteger;
                                        wersja3 := IntToStr(wersja2);
                                        while Length(wersja3) < 3 do
                                            wersja3 := '0' + wersja3;
                                        wersja3 := znak1 + znak2 + '.' + wersja3;

                                        kiedy_tmp66 := BCBToString( byte(MegaRam.FieldByName('evb2').AsInteger),
                                                     byte(MegaRam.FieldByName('evb3').AsInteger),
                                                     byte(MegaRam.FieldByName('evb5').AsInteger),
                                                     byte(MegaRam.FieldByName('evb6').AsInteger),
                                                     byte(MegaRam.FieldByName('evb7').AsInteger),
                                                     byte(MegaRam.FieldByName('evb8').AsInteger));
                                        dataczas66 := StrToDateTime(kiedy_tmp66);

                                        tmp5.Close();
                                        tmp5.SQL.Clear();
                                        tmp5.SQL.Add('update car set firmware_version2 = :firmware_version2, firmware_version2_changed = :firmware_version2_changed ' +
                                                      ' where id_car = ' + IntToStr(MegaRam.FieldByName('evb2').AsInteger) + ' and (firmware_version2 <> :firmware_version3 or firmware_version2 is null)' );
                                        tmp5.Parameters.ParamByName('firmware_version2').Value := wersja3;
                                        tmp5.Parameters.ParamByName('firmware_version3').Value := wersja3;
                                        tmp5.Parameters.ParamByName('firmware_version2_changed').Value := dataczas66;
                                        tmp5.ExecSQL();

                                        tmp5.Close();
                                        tmp5.SQL.Clear();
                                        tmp5.SQL.Add('update car set LRx = :LRx ' +
                                                      ' where id_car = ' + IntToStr(MegaRam.FieldByName('evb2').AsInteger) );
                                        tmp5.Parameters.ParamByName('LRx').Value := roaming_flag;
                                        tmp5.ExecSQL();
                                    end
                                    else
                                    if (MegaRam.FieldByName('evb3').AsFloat = 66) and
                                       (MegaRam.FieldByName('evb1').AsInteger = 0) then
                                    begin
                                        tmp5.Close();
                                        tmp5.SQL.Clear();
                                        tmp5.SQL.Add('update car set firmware_version2 = :firmware_version2 ' +
                                                      ' where id_car = ' + IntToStr(MegaRam.FieldByName('evb2').AsInteger));
                                        tmp5.Parameters.ParamByName('firmware_version2').Value := '';
                                        tmp5.ExecSQL();
                                    end;
                                end;
                            end;

                            if stream.Position = adres_pierwszego_zdarzenia then
                                break;

                            if ((stream.Size - stream.Position) = 16) and (adres_pierwszego_zdarzenia <> 16) then
                                stream.Position := 16;
                        end;
                        stream.Free();

//                        if czy_kontynuowac then
                        begin
          {                    stream2 := TMemoryStream.Create();
                            if last_event_datetime >= EncodeDate(2005, 1, 1) then
                            begin
                                StatusBar.SimpleText := translator.GetTranslatedText(85, 'Wyodrêbnianie nowszych zdarzeñ ni¿ te w zaczytywanym mailu...');
                                StatusBar.Update();

                                oldShortDateFormat := ShortDateFormat;
                                ShortDateFormat := 'MM/DD/YYYY';
                                oldDateSeparator := DateSeparator;
                                DateSeparator := '/';

                                SaveSelectToStream('select * from device_data where evb2 = ' +
                                    IntToStr(machine_no) + ' and date > ''' +
                                    DateTimeToStr(last_event_datetime) + ''' order by id_device_data',
                                    stream2, LogProcent);
                                tmp.Close();
                                tmp.SQL.Clear();
                                tmp.SQL.Add('delete from device_data where evb2 = ' +
                                    IntToStr(machine_no) + ' and date > ''' +
                                    DateTimeToStr(last_event_datetime) + '''');
                                tmp.ExecSQL();
                                ShortDateFormat := oldShortDateFormat;
                                DateSeparator := oldDateSeparator;
                            end; }

                            self.tmp.SQL.Clear();
                            self.tmp.SQL.Add('select top 10 * from device_data where evb2 = ' +
                                IntToStr(machine_no) + ' order by id_device_data desc');
                            self.tmp.Open();
                            ostatni_rekord := '';

                            ExtraRecordsCount := 0;
                            while (not self.tmp.Eof) and (self.tmp.FieldByName('evb3').AsInteger in [36, 37, 38, 39, 46, 45]) do
                            begin
                                Inc(ExtraRecordsCount);
                                self.tmp.Next();
                            end;

                            if not self.tmp.Eof then
                                kiedy := self.tmp.FieldByName('date').AsString;


                            for ii := 1 to 10 do
                                ostatni_rekord := ostatni_rekord + self.tmp.FieldByName('evb' + IntToStr(ii)).AsString + '|';
                            lastpal1 := self.tmp.FieldByName('pal1').AsInteger;
                            //lastmpal1 := tmp.FieldByName('mpal1').AsInteger;
                            lastpal2 := self.tmp.FieldByName('pal2').AsInteger;
                            //lastmpal2 := tmp.FieldByName('mpal2').AsInteger;
                            self.tmp.Close();

                            licznik := 0;

                            MegaRam.Open();
                            MegaRam.Last();
                            while not MegaRam.Bof do
                            begin
                                ostatni_rekord2 := '';
                                for ii := 1 to 10 do
                                    ostatni_rekord2 := ostatni_rekord2 + MegaRam.FieldByName('evb' + IntToStr(ii)).AsString + '|';
                                if ostatni_rekord = ostatni_rekord2 then
                                begin
                                    MegaRam.Next();
                                    for ii := 1 to ExtraRecordsCount do
                                        MegaRam.Next();
                                    break;
                                end
                                else
//                                    Inc(licznik);
                                MegaRam.Prior();
                            end;

          {                    MegaRam.Open();
                            MegaRam.First();
                            licznik := MegaRam.RecordCount; }

//                            i := 0;


//                            if not qInsertEvent.Connection.InTransaction then
//                                qInsertEvent.Connection.BeginTrans()
//                            else
//                                raise Exception.Create('Brak transakcji');

                            while not MegaRam.Eof do
                            begin

                                qInsertEvent.Parameters.ParamByName('@evb1').Value := MegaRam.FieldByName('evb1').AsFloat;
                                qInsertEvent.Parameters.ParamByName('@evb2').Value := MegaRam.FieldByName('evb2').AsFloat;
                                machine_no := MegaRam.FieldByName('evb2').AsInteger;
                                qInsertEvent.Parameters.ParamByName('@evb3').Value := MegaRam.FieldByName('evb3').AsFloat;
                                qInsertEvent.Parameters.ParamByName('@evb4').Value := MegaRam.FieldByName('evb4').AsFloat;
                                qInsertEvent.Parameters.ParamByName('@evb5').Value := MegaRam.FieldByName('evb5').AsFloat;
                                qInsertEvent.Parameters.ParamByName('@evb6').Value := MegaRam.FieldByName('evb6').AsFloat;
                                qInsertEvent.Parameters.ParamByName('@evb7').Value := MegaRam.FieldByName('evb7').AsFloat;
                                qInsertEvent.Parameters.ParamByName('@evb8').Value := MegaRam.FieldByName('evb8').AsFloat;
                                qInsertEvent.Parameters.ParamByName('@evb9').Value := MegaRam.FieldByName('evb9').AsFloat;
                                qInsertEvent.Parameters.ParamByName('@evb10').Value := MegaRam.FieldByName('evb10').AsFloat;

          //                        qInsertEvent.Parameters.ParamByName('@dataczas').AsDateTime := GetEmailDate(msg);
          //                        qInsertEvent.Parameters.ParamByName('@tytul2').AsString := lvHeaders.Items.Item[0].SubItems.Strings[0];
          //                        qInsertEvent.Parameters.ParamByName('@mailid').AsInteger := Integer(lvHeaders.Selected.Data);

                                if not (MegaRam.FieldByName('evb3').AsInteger in [36, 37, 38, 39, 46, 45]) then
                                begin
                                    kiedy_tmp := BCBToString(byte(MegaRam.FieldByName('evb2').AsInteger),
                                                         byte(MegaRam.FieldByName('evb3').AsInteger),
                                                         byte(MegaRam.FieldByName('evb5').AsInteger),
                                                         byte(MegaRam.FieldByName('evb6').AsInteger),
                                                         byte(MegaRam.FieldByName('evb7').AsInteger),
                                                         byte(MegaRam.FieldByName('evb8').AsInteger));
                                    if kiedy = '' then
                                        kiedy := kiedy_tmp;
                                    if kiedy <> '' then
                                        qInsertEvent.Parameters.ParamByName('@evdata').Value := StrToDateTime(kiedy_tmp);
          //                            //qInsertEvent.Parameters.ParamByName('@evdescribe').Value := evbDescribe[MegaRam.FieldByName('evb3').AsInteger];
                                    if qInsertEvent.Parameters.ParamByName('@evb3').Value <> 85 then
                                        kiedy := kiedy_tmp;
                                end
                                else
                                begin
                                    if kiedy <> '' then
                                        qInsertEvent.Parameters.ParamByName('@evdata').Value := StrToDateTime(kiedy);
                                end;
          //
          //                            IF (qInsertEvent.Parameters.ParamByName('@evb3').Value = 38) and
          //                               (qInsertEvent.Parameters.ParamByName('@evb1').Value = 65) then
          //                            begin
          //                                sek11 := trunc(qInsertEvent.Parameters.ParamByName('@EvB8').Value / 16) - 3;
          //                                sek21 := (qInsertEvent.Parameters.ParamByName('@EvB8').Value mod 16) - 3;
          //                                sek12 := trunc(qInsertEvent.Parameters.ParamByName('@EvB9').Value / 16) - 3;
          //                                sek22 := (qInsertEvent.Parameters.ParamByName('@EvB9').Value mod 16) - 3;
          //                                IF 	(sek11 >= 0) AND (sek11 <= 9) AND (sek21 >= 0) AND (sek21 <= 9) AND
          //                                         (sek12 >= 0) AND (sek12 <= 9) AND (sek22 >= 0) AND (sek22 <= 9) then
          //                                begin
          //                                    szerokosc_str := translator.GetTranslatedDatabase('Szer.:') +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB4').Value)) +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB5').Value)) + '.' +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB6').Value)) +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB7').Value)) + ',' +
          //                                      IntToStr(sek11) + IntToStr(sek21) + IntToStr(sek12) + IntToStr(sek22) +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB10').Value));
          //                                end
          //                                else
          //                                begin
          //                                    szerokosc_str := translator.GetTranslatedDatabase('Szer.:') + char(Integer(qInsertEvent.Parameters.ParamByName('@EvB4').Value)) +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB5').Value)) + '.' +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB6').Value)) +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB7').Value)) + ',????' +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB10').Value));
          //                                end;
          //                                //qInsertEvent.Parameters.ParamByName('@evdescribe').Value := szerokosc_str;
          //                            end
          //                            else
          //                                //qInsertEvent.Parameters.ParamByName('@evdescribe').Value := evbDescribe[MegaRam.FieldByName('evb3').AsInteger];
          //
          //                            if (qInsertEvent.Parameters.ParamByName('@evb3').Value = 39) then
          //                            begin
          //                                sek11 := trunc(qInsertEvent.Parameters.ParamByName('@EvB1').Value / 16) - 3;
          //                                sek21 := (qInsertEvent.Parameters.ParamByName('@EvB1').Value mod 16) - 3;
          //                                sek12 := trunc(qInsertEvent.Parameters.ParamByName('@EvB9').Value / 16) - 3;
          //                                sek22 := (qInsertEvent.Parameters.ParamByName('@EvB9').Value mod 16) - 3;
          //                                IF 	(sek11 >= 0) AND (sek11 <= 9) AND (sek21 >= 0) AND (sek21 <= 9) AND
          //                                         (sek12 >= 0) AND (sek12 <= 9) AND (sek22 >= 0) AND (sek22 <= 9) then
          //                                begin
          //                                    dlugosc_str := translator.GetTranslatedDatabase('D³ug.:') + char(Integer(qInsertEvent.Parameters.ParamByName('@EvB4').Value)) +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB5').Value)) +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB6').Value)) + '.' +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB7').Value)) +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB8').Value)) + ',' +
          //                                      IntToStr(sek11) + IntToStr(sek21) + IntToStr(sek12) + IntToStr(sek22) +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB10').Value));
          //                                end
          //                                else
          //                                begin
          //                                    dlugosc_str := translator.GetTranslatedDatabase('D³ug.:') + char(Integer(qInsertEvent.Parameters.ParamByName('@EvB4').Value)) +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB5').Value)) +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB6').Value)) + '.' +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB7').Value)) +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB8').Value)) + ',????' +
          //                                      char(Integer(qInsertEvent.Parameters.ParamByName('@EvB10').Value));
          //                                end;
          //                                //qInsertEvent.Parameters.ParamByName('@evdescribe').Value := dlugosc_str;
          //                            end;
          //
          //                            if (qInsertEvent.Parameters.ParamByName('@evb3').Value = 36) then
          //                            begin
          //                                GPStxt := Char(Integer(qInsertEvent.Parameters.ParamByName('@evb1').Value)) + '  ' +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb4').Value)) +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb5').Value)) + ',' +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb6').Value)) +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb7').Value)) + ':' +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb8').Value)) +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb9').Value));
          //                                If Integer(qInsertEvent.Parameters.ParamByName('@evb10').Value) in [83, 78] then
          //                                    GPSTxt := GPStxt + '  ' + Char(Integer(qInsertEvent.Parameters.ParamByName('@evb10').Value));
          //                                //qInsertEvent.Parameters.ParamByName('@evdescribe').Value := evbDescribe[MegaRam.FieldByName('evb3').AsInteger] + GPSTxt;
          //                            end;
          //                            if (qInsertEvent.Parameters.ParamByName('@evb3').Value = 37) then
          //                            begin
          //                                if qInsertEvent.Parameters.ParamByName('@evb4').Value = 49 then
          //                                    GPStxt := Char(Integer(qInsertEvent.Parameters.ParamByName('@evb1').Value)) + '  ' +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb4').Value)) +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb5').Value)) +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb6').Value)) + ',' +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb7').Value)) +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb8').Value)) + ':' +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb9').Value))
          //                                else
          //                                    GPStxt := Char(Integer(qInsertEvent.Parameters.ParamByName('@evb1').Value)) + '  ' +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb5').Value)) +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb6').Value)) + ',' +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb7').Value)) +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb8').Value)) + ':' +
          //                                       Char(Integer(qInsertEvent.Parameters.ParamByName('@evb9').Value));
          //                                If Integer(qInsertEvent.Parameters.ParamByName('@evb10').Value) in [69, 87] then
          //                                    GPSTxt := GPStxt + '  ' + Char(Integer(qInsertEvent.Parameters.ParamByName('@evb10').Value));
          //                                //qInsertEvent.Parameters.ParamByName('@evdescribe').Value := evbDescribe[MegaRam.FieldByName('evb3').AsInteger] + GPSTxt;
          //                            end;
          //                        end;
          //
                                if qInsertEvent.Parameters.ParamByName('@evb3').Value = 113 then
                                begin
                                    lastpal1 := qInsertEvent.Parameters.ParamByName('@evb4').Value;
          //                            lastmpal1 := 0;
                                end
                                else
                                if qInsertEvent.Parameters.ParamByName('@evb3').Value = 213 then
                                begin
                                    lastpal2 := qInsertEvent.Parameters.ParamByName('@evb4').Value;
          //                            lastmpal2 := 0;
                                end
                                else
                                if Integer(qInsertEvent.Parameters.ParamByName('@evb3').Value) in [117, 118, 119] then
                                begin
                                    lastpal1 := qInsertEvent.Parameters.ParamByName('@evb4').Value;
          //                            lastmpal1 := qInsertEvent.Parameters.ParamByName('@evb9').Value;
                                end
                                else
                                if Integer(qInsertEvent.Parameters.ParamByName('@evb3').Value) in [217, 218, 219] then
                                begin
                                    lastpal2 := qInsertEvent.Parameters.ParamByName('@evb4').Value;
          //                            lastmpal2 := qInsertEvent.Parameters.ParamByName('@evb9').Value;
                                end;

                                qInsertEvent.Parameters.ParamByName('@pal1').Value := lastpal1;
                                //qInsertEvent.Parameters.ParamByName('@mpal1').Value := lastmpal1;
                                qInsertEvent.Parameters.ParamByName('@pal2').Value := lastpal2;
                                //qInsertEvent.Parameters.ParamByName('@mpal2').Value := lastmpal2;

                                qInsertEvent.Parameters.ParamByName('@timezonebias').Value := TimeZoneHourBias();

//                                if StrToDateTime(kiedy) > EncodeDate(2013, 1, 1) then
//                                    raise Exception.Create('koniec');

                                try

                                    qInsertEvent.ExecProc();
                                except
                                    //jesli zdarzenie ma bledne dane, ktore powoduja
                                    //konflikty kluczy obcych to zostaje odrzucone
                                    on e: Exception do
                                    begin
//                                        if qInsertEvent.Connection.InTransaction then
//                                        begin
//                                            qInsertEvent.Connection.CommitTrans();
//                                            qInsertEvent.Connection.BeginTrans();
//                                        end
//                                        else
//                                            raise Exception.Create('Brak transakcji');

//                                        Caption := e.Message;
                                    end;
                                  end;
                                MegaRam.Next();
//                                i := i + 1;

                            end;

//                            if qInsertEvent.Connection.InTransaction then
//                                qInsertEvent.Connection.CommitTrans()
//                            else
//                                raise Exception.Create('brak transakcji');

          {                    if stream2.Size <> 0 then
                            begin
                                StatusBar.SimpleText := translator.GetTranslatedText(86, 'Zapisywanie wczeœniej wyodrêbnionych zdarzeñ...');
                                StatusBar.Update();
                                dataset := LoadSelectFromStream(stream2);
                                tmp.SQL.Clear();
                                tmp.SQL.Add('insert into device_data (evb1, evb2, evb3, evb4, evb5, evb6, evb7, evb8, evb9, evb10, date, pal1, pal2, timezonebias) ');
                                tmp.SQL.Add('values(:evb1, :evb2, :evb3, :evb4, :evb5, :evb6, :evb7, :evb8, :evb9, :evb10, :date, :pal1, :pal2, :timezonebias)');
                                CopyStreamSelectToInsertQuery(dataset, tmp, LogProcent);
                                dataset.Close();
                                dataset.Free();
                            end;
                            stream2.Free();}
                        end;


                        MegaRam.Close();

                        if (kiedy <> '') then
                        begin
                            tmp5.SQL.Clear();
                            tmp5.SQL.Add('update car set last_email_datetime = :last_email_datetime where id_car = :id_car');
                            tmp5.Parameters.ParamByName('id_car').Value := machine_no;
                            tmp5.Parameters.ParamByName('last_email_datetime').Value := kiedy;
                            AddLog('id_car: ' + IntToStr(machine_no) + ' last_email_datetime: ' + kiedy);
                            tmp5.ExecSQL();
                        end;

                    end
                    else
                    begin //body text
                        if Msg.MessageParts.Items[intIndex] is TIdText then
                        begin

                        end;
                    end;
                end;

                if Msg.Subject = akc_temat_ustawienia then
                begin
                    if WhichSettingsHistoryItemIsDefault() = 0 then
                    begin
                        stream3 := TStringStream.Create(Msg.Body.Text);
                        if stream3.Size > 0 then
                        begin
                            archiwum := XMLToSettingsHistoryBinAndXmlMd5(stream3.DataString,
                                            change_date,
                                            xml_md5,
                                            car_count,
                                            send_date,
                                            del_car_id,
                                            del_car_name,
                                            del_car_rej_numb,
                                            default_
                                          );

                            xml_stream := TStringStream.Create(xml_md5);
                            xml_stream.Position := 0;

                            qHistorySettings2.Close();
                            qHistorySettings2.SQL.Clear();
                            qHistorySettings2.SQL.Add('select * from settings_history where change_date = :change_date ');
                            qHistorySettings2.Parameters.ParamByName('change_date').Value := change_date;
                            qHistorySettings2.Open();
                            id_settings_history := qHistorySettings2.FieldByName('id_settings_history').AsInteger;
                            xml_stream2 := qHistorySettings2.CreateBlobStream(qHistorySettings2.FieldByName('xml'), bmRead);

                            if xml_stream.Size <> xml_stream2.Size then
                                id_settings_history := 0
                            else
                            begin
                                while xml_stream.Position < xml_stream.Size do
                                begin
                                    xml_stream.Read(znak1, 1);
                                    xml_stream2.Read(znak2, 1);
                                    if znak1 <> znak2 then
                                    begin
                                        id_settings_history := 0;
                                        break;
                                    end;
                                end;
                            end;

                            xml_stream2.Free();

                            qHistorySettings2.Close();

                            if id_settings_history = 0 then
                            begin
                                xml_stream.Position := 0;

                                qHistorySettings2.Close();
                                qHistorySettings2.SQL.Clear();
                                qHistorySettings2.SQL.Add('INSERT INTO settings_history ');
                                qHistorySettings2.SQL.Add('       (change_date, xml, car_count, bin, send_date, del_car_id, del_car_name, del_car_rej_numb, default_) ');
                                qHistorySettings2.SQL.Add(' values(:change_date, :xml, :car_count, :bin, :send_date, :del_car_id, :del_car_name, :del_car_rej_numb, :default_) ');

                                qHistorySettings2.Parameters.ParamByName('change_date').Value := change_date;
                                qHistorySettings2.Parameters.ParamByName('xml').LoadFromStream(xml_stream, ftBlob);

                                qHistorySettings2.Parameters.ParamByName('car_count').Value := car_count;
                                archiwum.stream.Position := 0;
                                qHistorySettings2.Parameters.ParamByName('bin').LoadFromStream(archiwum.stream, ftBlob);
                                archiwum.stream.Position := 0;

                                qHistorySettings2.Parameters.ParamByName('send_date').Value := change_date; // celowo
                                qHistorySettings2.Parameters.ParamByName('del_car_id').Value := del_car_id;
                                qHistorySettings2.Parameters.ParamByName('del_car_name').Value := del_car_name;
                                qHistorySettings2.Parameters.ParamByName('del_car_rej_numb').Value := del_car_rej_numb;
                                qHistorySettings2.Parameters.ParamByName('default_').Value := default_;
                                qHistorySettings2.ExecSQL();

//                                LoadBin(archiwum);
                            end;


                            xml_stream.Free();

                            archiwum.Free();
                        end;
                        stream3.Free();
                    end;
                end;

                zostal_zapisany_mail := True;
                AddEmail(GetEmailDate(msg), Msg.From.Text, GetSubject2(msg),
                        lvHeaders.Items[0].SubItems.Strings[0],
                        StrToInt(lvHeaders.Items[0].SubItems.Strings[3]), msg.MsgId);
                qMailSettings.Open();
                if (qMailSettings.FieldByName('delete_after_load').AsInteger <> 0) then
                begin
            //        for i := 1 to lvHeaders.Items.Count - 1 do
            //            lvHeaders.Items.Item[i].Data := Pointer(Integer(lvHeaders.Items.Item[i].Data) - 1);
//                    POP.Delete(Integer(lvHeaders.Selected.Data));
                end;
                qMailSettings.Close();
                lvHeaders.Items[0].Delete();
            end;
        finally
           try
              if POP.Connected then
              begin
                  AddLog('6716 Is Connected: try to disconnect2 inaImportExecute ...');
//                  addlog('keepalive before disconnect...');
//                  pop.KeepAlive();
                  POP.Disconnect();
                  AddLog('6720 after disconnect2 in aImportExecute');
              end
              else
                  AddLog('6723 not connected: disconnect2 in aImportExecute not needed');

           except
               on e: Exception do
               begin
                   AddLog('6707 raise higher' + e.Message);
                   raise;
               end;
           end;
        end;

//        if IsSettingsHistoryChanged() then
//            MakeNewSettingsHistoryItem();

        qHistorySettings2.Close();
        qHistorySettings2.SQL.Clear();
        qHistorySettings2.SQL.Add('select * from settings_history where send_date is null order by id_settings_history');
        qHistorySettings2.Open();

        if not qHistorySettings2.Eof then
        begin
            if Pos('@tednet.strefa.pl', pop.Username) > 0 then
            begin

                smtp.Host := pop.Host;
                smtp.Username := pop.Username;
                smtp.Password := pop.Password;
                smtp.AuthType := satDefault;
                smtp.Port := 587;
                smtp.Connect();

                while not qHistorySettings2.Eof do
                begin
                    Sleep(1500);

                    teraz := Now();

                    Msg.Clear();
                    Msg.Subject := akc_temat_ustawienia;
                    Msg.Date := teraz;
                    Msg.From.Address := pop.Username;
                    Msg.Recipients.EMailAddresses := pop.Username;

                    xml := SettingsHistoryItemToXML(qHistorySettings2.FieldByName('id_settings_history').AsInteger);

                    Msg.Body.Text := xml;

//                    part := TIdText.Create(Msg.MessageParts, xml_strings);
//                    part.Free();

                    try
                        smtp.Send(Msg);
                    except
                        on e: EIdConnClosedGracefully do
                        begin

                        end
                        else
                            raise;
                    end;

                    qHistorySettings2.Edit();
                    qHistorySettings2.FieldByName('send_date').AsDateTime := teraz;
                    qHistorySettings2.Post();

                    qHistorySettings2.Next();
                end;

                smtp.Disconnect();

            end;
        end;
        qHistorySettings2.Close();

        //po odebraniu wszystkich maili wyszukiwanna jest pozycja GPS
        // wszystkich pojazdow
        //zapisaywana w tabeli cardata/car, jesli stwierdzi ze ta pozycja jest nowsza niz
        //sledzenie online
        if zostal_zapisany_mail then
           UstawNajnowszePozycje(0);

        try
            if ADOConnection.DefaultDatabase = 'carnet_pompy_ciepla' then
            begin
                AddLog('6815 pompy generowanie raport dla urzadzenia 1...');

                qspCurrentEvents.Parameters.ParamByName('@carno').Value := 1;
                qspCurrentEvents.Parameters.ParamByName('@start').Value := Date() - 1;
                qspCurrentEvents.Parameters.ParamByName('@stop').Value := Date() + 1;
                qspCurrentEvents.Parameters.ParamByName('@max_event_count').Value := 1000;
                qspCurrentEvents.ExecProc();

                AddLog('6823 pompy generowanie raport dla urzadzenia 2...');

                qspCurrentEvents.Parameters.ParamByName('@carno').Value := 2;
                qspCurrentEvents.Parameters.ParamByName('@start').Value := Date() - 1;
                qspCurrentEvents.Parameters.ParamByName('@stop').Value := Date() + 1;
                qspCurrentEvents.Parameters.ParamByName('@max_event_count').Value := 1000;
                qspCurrentEvents.ExecProc();

                AddLog('6831 pompy generowanie raport dla urzadzenia 3...');

                qspCurrentEvents.Parameters.ParamByName('@carno').Value := 3;
                qspCurrentEvents.Parameters.ParamByName('@start').Value := Date() - 1;
                qspCurrentEvents.Parameters.ParamByName('@stop').Value := Date() + 1;
                qspCurrentEvents.Parameters.ParamByName('@max_event_count').Value := 1000;
                qspCurrentEvents.ExecProc();

                AddLog('6839 zakonczono generowanie raportu dla pomp');
            end;
        except
            on e: Exception do
            begin
                AddLog('6844 ' + e.Message);
            end;
        end;

    finally
        pop3_in_work := False;
    end;
end;

{
function TTEDEmailSrv.GetSubject2(Msg): String;
begin
    result := msg.Subject;
    if Pos('[Norton AntiSpam] ', result) > 0 then
        result := Copy(result, Length('[Norton AntiSpam] ') + 1, 1000);
end;
}

function TTEDEmailSrv.GetSubject2(msg2: TIdMessage): String;
begin
    result := msg2.Subject;
    if Pos('[Norton AntiSpam] ', result) > 0 then
        result := Copy(result, Length('[Norton AntiSpam] ') + 1, 1000);
end;

procedure TTEDEmailSrv.AddLog(tresc: String);
var log_file: TStrings;
    log_file_name: String;
    tmp: String;
    f: TextFile;
begin
    tmp := DateTimeToStr(Now()) + ': ' + tresc;
    logi.Add(tmp);

    log_file_name := ExtractFilePath(ParamStr(0)) + 'logi.txt';

    ForceDirectories(ExtractFilePath(log_file_name));
    log_file := TStringList.Create();
    try
        AssignFile(f,log_file_name);
        if FileExists(log_file_name) then
            Append(f)
        else
            rewrite(f);
        writeln(f, tmp);
        closefile(f);
    finally
        log_file.Free();
    end;

//    Clipboard.AsText := logi.Text;
//    if frmLogView <> nil then
//        GetLogs(frmLogView.logi);
end;

function TTEDEmailSrv.CzyBylJuzCzytany(dataczas: TDateTime; email: String;
        tytul: String; rozmiar: Integer; email_id: String): Boolean;
begin
    if email_id = '' then
    begin
        AddLog('6904 Email bez MsgId !!');
        raise Exception.Create('Email bez MsgId !!');
    end;

    qCzyBylEmailCzytany2.Parameters.ParamByName('@adres').Value := AnsiLowerCase(email);
    qCzyBylEmailCzytany2.Parameters.ParamByName('@dataczas').Value := dataczas;
    qCzyBylEmailCzytany2.Parameters.ParamByName('@dataczas2').Value := dataczas + EncodeTime(1, 0, 0, 0);
    qCzyBylEmailCzytany2.Parameters.ParamByName('@dataczas3').Value := dataczas - EncodeTime(1, 0, 0, 0);
    qCzyBylEmailCzytany2.Parameters.ParamByName('@tytul').Value := tytul;
    qCzyBylEmailCzytany2.Parameters.ParamByName('@rozmiar').Value := rozmiar;
    qCzyBylEmailCzytany2.Parameters.ParamByName('@mail_id').Value := email_id;
    qCzyBylEmailCzytany2.Open();
    result := not qCzyBylEmailCzytany2.Eof;
    qCzyBylEmailCzytany2.Close();
end;

function TTEDEmailSrv.TimeZoneBias: TDateTime;
var
  ATimeZone: TTimeZoneInformation;
begin
  case GetTimeZoneInformation(ATimeZone) of
    TIME_ZONE_ID_DAYLIGHT:
      Result := ATimeZone.Bias + ATimeZone.DaylightBias;
    TIME_ZONE_ID_STANDARD:
      Result := ATimeZone.Bias + ATimeZone.StandardBias;
    TIME_ZONE_ID_UNKNOWN:
      Result := ATimeZone.Bias;
    else
      raise Exception.Create(SysErrorMessage(GetLastError));
  end;
  Result := Result / 1440;
end;

function TTEDEmailSrv.TimeZoneHourBias: Integer;
var Hour, Min, Sec, MSec: Word;
begin
    DecodeTime(bias, Hour, Min, Sec, MSec);
    if bias >= 0.0 then
        result := Hour
    else
        result := (-1) * Hour;
end;

procedure TTEDEmailSrv.AddEmail(dataczas: TDateTime; email: String;
        tytul, tytul2: String; rozmiar: Integer; email_id: String);
begin
    tmp.Close();
    tmp.SQL.Clear();
    tmp.SQL.Add('insert into lista_maili (adres, dataczas, tytul, tytul2, ' +
        'rozmiar, uidl) values(:adres, :dataczas, :tytul, :tytul2, :rozmiar, :uidl)');
    tmp.Parameters.ParamByName('adres').Value := AnsiLowerCase(email);
    tmp.Parameters.ParamByName('dataczas').Value := dataczas;
    tmp.Parameters.ParamByName('tytul').Value := tytul;
    tmp.Parameters.ParamByName('tytul2').Value := tytul2;
    tmp.Parameters.ParamByName('rozmiar').Value := rozmiar;
    tmp.Parameters.ParamByName('uidl').Value := email_id;
    tmp.ExecSQL();
end;

procedure TTEDEmailSrv.UstawNajnowszeDane(var last_positions: TGPSes);
var i: Integer;
begin
    tmp5.Close();
    tmp5.SQL.Clear();
    tmp5.SQL.Add('SELECT evb2, max(date) date2 from device_data ' +
                   ' group by evb2');
    tmp5.Open();
    while not tmp5.Eof do
    begin
        last_positions[tmp5.FieldByName('evb2').AsInteger].included := True;
        last_positions[tmp5.FieldByName('evb2').AsInteger].znalazl  := True;
        last_positions[tmp5.FieldByName('evb2').AsInteger].dataczas := tmp5.FieldByName('date2').AsDateTime;
        tmp5.Next();
    end;
    tmp5.Close();

    for i := 0 to 255 do
    if last_positions[i].znalazl then
    begin
        if last_positions[i].gps <> '' then
            UstawNajnowszaPozycje(i, last_positions[i].move_event, last_positions[i].dataczas,
                    last_positions[i].gps, last_positions[i].gps_status,
                    last_positions[i].packet_prefix)
        else
        begin
            last_positions[i].gps := UstawNajnowszaPozycje(i, last_positions[i].move_event, last_positions[i].dataczas,
                    last_positions[i].szerokosc, last_positions[i].dlugosc, last_positions[i].gps_status,
                    last_positions[i].packet_prefix);
        end;
    end;
end;

procedure TTEDEmailSrv.UstawNajnowszePozycje(onProgress: TOnRaportCreateProgress);
var last_positions: TGPSes;
    i: Integer;
    szerokosc, dlugosc: double;
    event_id: Integer;
    sek11, sek12, sek21, sek22: Integer;
    gps_status: Char;
    dataczas: TDateTime;
    ile_aut: Integer;
    auto_licznik: Integer;
    koniec_trasy: Boolean;
    move_event_found: Boolean;
begin
    for i := 0 to 255 do
    begin
        last_positions[i].included := False;
        last_positions[i].znalazl := False;
    end;

    tmp5.Close();
    tmp5.SQL.Clear();
    tmp5.SQL.Add('select * from car');
    if car_no <> 0 then
        tmp5.SQL.Add(' where id_car = ' + IntToStr(car_no));
    tmp5.Open();
    ile_aut := 0;
    while not tmp5.Eof do
    begin
        last_positions[tmp5.FieldByName('id_car').AsInteger].included := True;
        last_positions[tmp5.FieldByName('id_car').AsInteger].marka :=
            tmp5.FieldByName('name').AsString;
        last_positions[tmp5.FieldByName('id_car').AsInteger].rej_numb :=
            tmp5.FieldByName('rej_numb').AsString;
        Inc(ile_aut);
        tmp5.Next();
    end;
    tmp5.Close();

    auto_licznik := 0;
    for i := 0 to 255 do
    begin
        if last_positions[i].included then
        begin
            Inc(auto_licznik);
            if @onProgress <> nil then
            begin
                onProgress(auto_licznik, ile_aut);
            end;
            if car_no = 0 then
            begin
                tmp5.Close();
                tmp5.SQL.Clear();
                tmp5.SQL.Add('select top 1 * from device_data where evb2 = :evb2 and evb3 = 39 order by id_device_data desc');
                tmp5.Parameters.ParamByName('evb2').Value := i;
                tmp5.Open();
                if not tmp5.Eof then
                    event_id := tmp5.FieldByName('id_device_data').AsInteger
                else
                    event_id := 0;
                tmp5.Close();

                koniec_trasy := False;

                if event_id <> 0 then
                begin
                    tmp5.SQL.Clear();
                    tmp5.SQL.Add('select top 10 * from device_data where evb2 = :evb2 and id_device_data <= :id_event order by id_device_data desc');
                    tmp5.Parameters.ParamByName('evb2').Value := i;
                    tmp5.Parameters.ParamByName('id_event').Value := event_id;
                    tmp5.Open();
                    while not tmp5.Eof do
                    begin
                        if tmp5.FieldByName('evb3').AsInteger = 85 then
                        begin
                           koniec_trasy := True;
                        end
                        else
                        if tmp5.FieldByName('evb3').AsInteger = 10 then
                        begin
                           koniec_trasy := False;
                        end;

                        if (tmp5.FieldByName('evb3').AsInteger = 39) and
                           (tmp5.FieldByName('evb4').AsInteger in [48..57]) and
                           (tmp5.FieldByName('evb5').AsInteger in [48..57]) and
                           (tmp5.FieldByName('evb6').AsInteger in [48..57]) and
                           (tmp5.FieldByName('evb7').AsInteger in [48..57]) and
                           (tmp5.FieldByName('evb8').AsInteger in [48..57]) then
                        begin
                            sek11 := trunc(tmp5.FieldByName('EvB1').AsInteger / 16) - 3;
                            sek21 := (tmp5.FieldByName('EvB1').AsInteger mod 16) - 3;
                            sek12 := trunc(tmp5.FieldByName('EvB9').AsInteger / 16) - 3;
                            sek22 := (tmp5.FieldByName('EvB9').AsInteger mod 16) - 3;
                            IF 	(sek11 >= 0) AND (sek11 <= 9) AND (sek21 >= 0) AND (sek21 <= 9) AND
                                     (sek12 >= 0) AND (sek12 <= 9) AND (sek22 >= 0) AND (sek22 <= 9) then
                            begin
                                dlugosc := StrToInt(char(tmp5.FieldByName('EvB4').AsInteger) +
                                  char(tmp5.FieldByName('EvB5').AsInteger) +
                                  char(tmp5.FieldByName('EvB6').AsInteger)) +
                                  StrToInt(char(tmp5.FieldByName('EvB7').AsInteger) +
                                  char(tmp5.FieldByName('EvB8').AsInteger)) / 60.0 +
                                  StrToInt(IntToStr(sek11) + IntToStr(sek21) + IntToStr(sek12) + IntToStr(sek22)) / 600000;
                                if char(tmp5.FieldByName('EvB10').AsInteger) = 'W' then
                                    dlugosc := dlugosc * -1;
                            end
                            else
                            begin
                                dlugosc := StrToInt(char(tmp5.FieldByName('EvB4').AsInteger) +
                                  char(tmp5.FieldByName('EvB5').AsInteger) +
                                  char(tmp5.FieldByName('EvB6').AsInteger)) +
                                  StrToInt(char(tmp5.FieldByName('EvB7').AsInteger) +
                                  char(tmp5.FieldByName('EvB8').AsInteger)) / 60.0;
                                if char(tmp5.FieldByName('EvB10').AsInteger) = 'W' then
                                    dlugosc := dlugosc * -1;
                            end;

                            if dlugosc = 0.0 then
                                continue;

                            tmp5.Next();
                            if (tmp5.FieldByName('evb3').AsInteger = 38) and
                               (tmp5.FieldByName('evb4').AsInteger in [48..57]) and
                               (tmp5.FieldByName('evb5').AsInteger in [48..57]) and
                               (tmp5.FieldByName('evb6').AsInteger in [48..57]) and
                               (tmp5.FieldByName('evb7').AsInteger in [48..57]) then
                            begin
                                sek11 := trunc(tmp5.FieldByName('EvB8').AsInteger / 16) - 3;
                                sek21 := (tmp5.FieldByName('EvB8').AsInteger mod 16) - 3;
                                sek12 := trunc(tmp5.FieldByName('EvB9').AsInteger / 16) - 3;
                                sek22 := (tmp5.FieldByName('EvB9').AsInteger mod 16) - 3;
                                IF 	(sek11 >= 0) AND (sek11 <= 9) AND (sek21 >= 0) AND (sek21 <= 9) AND
                                         (sek12 >= 0) AND (sek12 <= 9) AND (sek22 >= 0) AND (sek22 <= 9) then
                                begin
                                    szerokosc := StrToInt(char(tmp5.FieldByName('EvB4').AsInteger) +
                                      char(tmp5.FieldByName('EvB5').AsInteger)) +
                                      StrToInt(char(tmp5.FieldByName('EvB6').AsInteger) +
                                      char(tmp5.FieldByName('EvB7').AsInteger)) / 60.0 +
                                      StrToInt(IntToStr(sek11) + IntToStr(sek21) + IntToStr(sek12) + IntToStr(sek22)) / 600000;
                                    if char(tmp5.FieldByName('EvB10').AsInteger) = 'S' then
                                        szerokosc := szerokosc * -1;
                                end
                                else
                                begin
                                    szerokosc := StrToInt(char(tmp5.FieldByName('EvB4').AsInteger) +
                                      char(tmp5.FieldByName('EvB5').AsInteger)) +
                                      StrToInt(char(tmp5.FieldByName('EvB6').AsInteger) +
                                      char(tmp5.FieldByName('EvB7').AsInteger)) / 60.0;
                                    if char(tmp5.FieldByName('EvB10').AsInteger) = 'S' then
                                        szerokosc := szerokosc * -1;
                                end;

                                gps_status := Char(tmp5.FieldByName('evb1').AsInteger);
                                dataczas := tmp5.FieldByName('date').AsDateTime;

                                if szerokosc = 0.0 then
                                    continue;

                                move_event_found := False;

                                tmp5.Next();

                                while not tmp5.Eof do
                                begin
                                    if tmp5.FieldByName('evb3').AsInteger in [10, 113, 213, 119, 219, 85, 49, 115] then
                                    begin
                                        last_positions[i].znalazl := True;
                                        last_positions[i].szerokosc := szerokosc;
                                        last_positions[i].dlugosc := dlugosc;
                                        last_positions[i].gps_status := gps_status;
                                        last_positions[i].dataczas := dataczas;
                                        last_positions[i].packet_prefix := 'tez';
                                        if tmp5.FieldByName('evb3').AsInteger = 10 then
                                        begin
    //                                        if koniec_trasy then
    //                                            last_positions[i].move_event := 119
    //                                        else
                                                last_positions[i].move_event := 10;
                                        end
                                        else
                                        if tmp5.FieldByName('evb3').AsInteger in [113, 213] then
                                        begin
    //                                        if koniec_trasy then
    //                                            last_positions[i].move_event := 119
    //                                        else
                                                last_positions[i].move_event := 113;
                                        end
                                        else
                                        if tmp5.FieldByName('evb3').AsInteger in [119, 219] then
                                            last_positions[i].move_event := 119
                                        else
                                        if tmp5.FieldByName('evb3').AsInteger in [85, 49, 115] then
                                            last_positions[i].move_event := 49;

                                        move_event_found := True;

                                        break;
                                    end
                                    else
                                        tmp5.Next();
                                end;

                                if move_event_found then
                                    break;
                            end;
                        end;
                        tmp5.Next();
                    end;
                    tmp5.Close();
                end;
            end;

            tmp5.Close();
            tmp5.SQL.Clear();
            tmp5.SQL.Add('select top 1 * from events_online where car_no = :car_no and packet_prefix = ''tea'' order by id desc');
            tmp5.Parameters.ParamByName('car_no').Value := i;
            tmp5.Open();
            if not tmp5.Eof then
            begin
                if (not last_positions[i].znalazl) or
                      (
                          last_positions[i].znalazl and
                          (last_positions[i].dataczas < tmp5.FieldByName('dataczas').AsDateTime)
                      ) then
                begin
                    last_positions[i].znalazl := True;
                    last_positions[i].gps := tmp5.FieldByName('gps').AsString;
                    if tmp5.FieldByName('gps_status').AsString <> '' then
                        last_positions[i].gps_status := tmp5.FieldByName('gps_status').AsString[1]
                    else
                        last_positions[i].gps_status := 'A';
                    last_positions[i].dataczas := tmp5.FieldByName('dataczas').AsDateTime;
                    if tmp5.FieldByName('evb3').AsInteger = 10 then
                    begin
                            last_positions[i].move_event := 10
                    end
                    else
                    if tmp5.FieldByName('evb3').AsInteger in [113, 213] then
                        last_positions[i].move_event := 113
                    else
                    if tmp5.FieldByName('evb3').AsInteger in [119, 219] then
                        last_positions[i].move_event := 119
                    else
                        last_positions[i].move_event := 49;
                    last_positions[i].packet_prefix := tmp5.FieldByName('packet_prefix').AsString;
                end;
            end;
            tmp5.Close();

            if last_positions[i].znalazl then
            begin
                if last_positions[i].gps <> '' then
                    UstawNajnowszaPozycje(i, last_positions[i].move_event, last_positions[i].dataczas,
                            last_positions[i].gps, last_positions[i].gps_status,
                            last_positions[i].packet_prefix)
                else
                begin
                    last_positions[i].gps := UstawNajnowszaPozycje(i, last_positions[i].move_event, last_positions[i].dataczas,
                            last_positions[i].szerokosc, last_positions[i].dlugosc, last_positions[i].gps_status,
                            last_positions[i].packet_prefix);
                end;
            end;
        end;
    end;
    UstawNajnowszeDane(last_positions);
end;

procedure TTEDEmailSrv.UstawNajnowszePozycje(car_no: Integer);
begin
    Self.car_no := car_no;
    if car_no = 0 then
    begin
        UstawNajnowszePozycje();
    end
    else
        UstawNajnowszePozycje();
end;

procedure TTEDEmailSrv.WpiszNajnowszePozycjeDoEventsOnline();
type
    TGPS = record
        szerokosc: double;
        dlugosc: double;
        gps: String;
        included: Boolean;
        gps_status: Char;
        move_event: Integer;
        dataczas: TDateTime;
        znalazl: Boolean;
        packet_prefix: String;
    end;
var last_positions: array [0..255] of TGPS;
    i: Integer;
    car_no: Integer;
    trzeba_dodac: Boolean;
begin
    for i := 0 to 255 do
    begin
        last_positions[i].included := False;
        last_positions[i].znalazl := False;
    end;

    tmp5.Close();
    tmp5.SQL.Clear();
    tmp5.SQL.Add('select * from car ');
    tmp5.Open();
    while not tmp5.Eof do
    begin
        car_no := tmp5.FieldByName('id_car').AsInteger;
        last_positions[car_no].included := True;
        if tmp5.FieldByName('last_gps_datetime').AsDateTime <> 0 then
        begin
            last_positions[car_no].znalazl := True;
            last_positions[car_no].dataczas := tmp5.FieldByName('last_gps_datetime').AsDateTime;
            last_positions[car_no].move_event := tmp5.FieldByName('last_gps_event').AsInteger;
            if tmp5.FieldByName('last_gps_status').AsString <> '' then
                last_positions[car_no].gps_status := tmp5.FieldByName('last_gps_status').AsString[1]
            else
                last_positions[car_no].gps_status := 'A';
            last_positions[car_no].gps := tmp5.FieldByName('last_gps').AsString;
            last_positions[car_no].packet_prefix := tmp5.FieldByName('last_packet_prefix').AsString;
        end;
        tmp5.Next();
    end;
    tmp5.Close();

    for i := 0 to 255 do
    begin
        if last_positions[i].included and last_positions[i].znalazl then
        begin
            trzeba_dodac := False;

            tmp5.Close();
            tmp5.SQL.Clear();
            tmp5.SQL.Add('select top 1 * from events_online where car_no = :car_no order by id desc ');
            tmp5.Open();
            if not tmp5.Eof then
            begin
                if tmp5.FieldByName('dataczas').AsDateTime < last_positions[i].dataczas then
                    trzeba_dodac := True;
            end
            else
                trzeba_dodac := True;

            if trzeba_dodac then
            begin
                tmp5.Close();
                tmp5.SQL.Clear();
                tmp5.SQL.Add('insert into events_online (car_no, dataczas, gps, state, evb3, gps_status, packet_prefix) ');
                tmp5.SQL.Add(' values(:car_no, :dataczas, :gps, :state, :evb3, :gps_status, :packet_prefix) ');
                tmp5.Parameters.ParamByName('car_no').Value := i;
                tmp5.Parameters.ParamByName('dataczas').Value := last_positions[i].dataczas;
                tmp5.Parameters.ParamByName('gps').Value := last_positions[i].gps;
                if last_positions[i].move_event = 10 then
                    tmp5.Parameters.ParamByName('state').Value := 'Pocz¹tek ruchu'
                else
                if last_positions[i].move_event = 113 then
                    tmp5.Parameters.ParamByName('state').Value := 'W trakcie jazdy'
                else
                if last_positions[i].move_event = 49 then
                    tmp5.Parameters.ParamByName('state').Value := 'Zatrzymanie pojazdu'
                else
                    tmp5.Parameters.ParamByName('state').Value := 'Postój';
                tmp5.Parameters.ParamByName('evb3').Value := last_positions[i].move_event;
                tmp5.Parameters.ParamByName('gps_status').Value := last_positions[i].gps_status;
                tmp5.Parameters.ParamByName('packet_prefix').Value := last_positions[i].packet_prefix;
                tmp5.ExecSQL();
            end;
        end;
    end;
end;

function TTEDEmailSrv.UstawNajnowszaPozycje(car_no: Integer; event: Integer;
    dataczas: TDateTime; szerokosc: double; dlugosc: double; gps_status: char;
    packet_prefix: String): String;
var gps: String;
    gps2: String;
    znak: Char;
begin
    tmp5.Close();
    tmp5.SQL.Clear();
    tmp5.SQL.Add('update car set last_gps_datetime = null ');
    tmp5.SQL.Add('where last_gps_datetime >= :last_gps_datetime and last_gps_datetime is not null and id_car = :id_car ');
    tmp5.Parameters.ParamByName('last_gps_datetime').Value := Now() + 3;
    tmp5.Parameters.ParamByName('id_car').Value := car_no;
    tmp5.ExecSQL();

    tmp5.Close();
    tmp5.SQL.Clear();
    tmp5.SQL.Add('update events_online set dataczas = null ');
    tmp5.SQL.Add('where dataczas >= :dataczas and dataczas is not null and car_no = :car_no ');
    tmp5.Parameters.ParamByName('dataczas').Value := Now() + 3;
    tmp5.Parameters.ParamByName('car_no').Value := car_no;
    tmp5.ExecSQL();


    if dataczas <> 0 then
    begin
        if dataczas > (Now() + 3) then
        begin
            AddLog('7395 Pojazd nr ' + IntToStr(car_no) + ': czas przysz³y');
            exit;
        end;

        tmp5.Close();
        tmp5.SQL.Clear();
        tmp5.SQL.Add('update car set last_gps = :last_gps, ');
        tmp5.SQL.Add('last_gps_event = :last_gps_event, last_gps_datetime = :last_gps_datetime, ');
        tmp5.SQL.Add('last_gps_status = :last_gps_status, last_packet_prefix = :last_packet_prefix, predkosc = null, temperatura = null, paliwo = null ');
        tmp5.SQL.Add('where id_car = :id_car and (last_gps_datetime <= :last_gps_datetime2 or last_gps_datetime is null) ');

        if szerokosc >= 0.0 then
            znak := 'N'
        else
            znak := 'S';
        szerokosc := abs(szerokosc);
        gps := IntToStr(Trunc(szerokosc));
        while Length(gps) < 2 do
            gps := '0' + gps;
        szerokosc := szerokosc - Trunc(szerokosc);
        szerokosc := szerokosc * 60;
        gps := gps + IntToStr(Trunc(szerokosc));
        while Length(gps) < 4 do
            gps := Copy(gps, 1, 2) + '0' + Copy(gps, 3, 100);
        gps := gps + '.';
        szerokosc := szerokosc - Trunc(szerokosc);
        szerokosc := szerokosc * 10000;
        gps := gps + IntToStr(Trunc(szerokosc));
        while Length(gps) < 9 do
            gps := Copy(gps, 1, 5) + '0' + Copy(gps, 6, 100);
        gps := gps + ',' + znak + ',';

        if dlugosc >= 0.0 then
            znak := 'E'
        else
            znak := 'W';
        dlugosc := abs(dlugosc);
        gps2 := IntToStr(Trunc(dlugosc));
        while Length(gps2) < 3 do
            gps2 := '0' + gps2;
        dlugosc := dlugosc - Trunc(dlugosc);
        dlugosc := dlugosc * 60;
        gps2 := gps2 + IntToStr(Trunc(dlugosc));
        while Length(gps2) < 5 do
            gps2 := Copy(gps2, 1, 3) + '0' + Copy(gps2, 4, 100);
        gps2 := gps2 + '.';
        dlugosc := dlugosc - Trunc(dlugosc);
        dlugosc := dlugosc * 10000;
        gps2 := gps2 + IntToStr(Trunc(dlugosc));
        while Length(gps2) < 10 do
            gps2 := Copy(gps2, 1, 6) + '0' + Copy(gps2, 7, 100);
        gps2 := gps2 + ',' + znak;

        tmp5.Parameters.ParamByName('last_gps').Value := gps + gps2;
        tmp5.Parameters.ParamByName('last_gps_event').Value := event;
        tmp5.Parameters.ParamByName('last_gps_status').Value := gps_status;
        tmp5.Parameters.ParamByName('last_gps_datetime').Value := dataczas;
        tmp5.Parameters.ParamByName('last_gps_datetime2').Value := dataczas;
        tmp5.Parameters.ParamByName('last_packet_prefix').Value := packet_prefix;
        tmp5.Parameters.ParamByName('id_car').Value := car_no;
        tmp5.ExecSQL();


        tmp5.Close();
        tmp5.SQL.Clear();
        tmp5.SQL.Add('update events_online set dataczas = :dataczas ');
        tmp5.SQL.Add('where (dataczas <= :dataczas2 or dataczas is null) and car_no = :car_no  ');
        tmp5.Parameters.ParamByName('dataczas').Value := dataczas;
        tmp5.Parameters.ParamByName('dataczas2').Value := dataczas;
        tmp5.Parameters.ParamByName('car_no').Value := car_no;
        tmp5.ExecSQL();
    end
    else
        AddLog('7468 Pojazd nr ' + IntToStr(car_no) + ': czas zerowy');

    result := gps + gps2;
end;

procedure TTEDEmailSrv.UstawNajnowszaPozycje(car_no: Integer; event: Integer; dataczas: TDateTime;
    gps: String; gps_status: char; packet_prefix: String);
begin
    tmp5.Close();
    tmp5.SQL.Clear();
    tmp5.SQL.Add('update car set last_gps_datetime = null ');
    tmp5.SQL.Add('where last_gps_datetime >= :last_gps_datetime and last_gps_datetime is not null and id_car = :id_car ');
    tmp5.Parameters.ParamByName('last_gps_datetime').Value := Now() + 3;
    tmp5.Parameters.ParamByName('id_car').Value := car_no;
    tmp5.ExecSQL();

    tmp5.Close();
    tmp5.SQL.Clear();
    tmp5.SQL.Add('update events_online set dataczas = null ');
    tmp5.SQL.Add('where dataczas >= :dataczas and dataczas is not null and car_no = :car_no ');
    tmp5.Parameters.ParamByName('dataczas').Value := Now() + 3;
    tmp5.Parameters.ParamByName('car_no').Value := car_no;
    tmp5.ExecSQL();

    if dataczas <> 0 then
    begin
        if dataczas > (Now() + 3) then
        begin
            AddLog('7496 Pojazd nr ' + IntToStr(car_no) + ': czas przysz³y');
            exit;
        end;

        tmp5.Close();
        tmp5.SQL.Clear();
        tmp5.SQL.Add('update car set last_gps = :last_gps, ');
        tmp5.SQL.Add('last_gps_event = :last_gps_event, last_gps_datetime = :last_gps_datetime, ');
        tmp5.SQL.Add('last_gps_status = :last_gps_status, last_packet_prefix = :last_packet_prefix, predkosc = null, temperatura = null, paliwo = null  ');
        tmp5.SQL.Add('where id_car = :id_car and (last_gps_datetime <= :last_gps_datetime2 or last_gps_datetime is null) ');
        tmp5.Parameters.ParamByName('last_gps').Value := gps;
        tmp5.Parameters.ParamByName('last_gps_event').Value := event;
        tmp5.Parameters.ParamByName('last_gps_status').Value := gps_status;
        tmp5.Parameters.ParamByName('last_gps_datetime').Value := dataczas;
        tmp5.Parameters.ParamByName('last_gps_datetime2').Value := dataczas;
        tmp5.Parameters.ParamByName('last_packet_prefix').Value := packet_prefix;
        tmp5.Parameters.ParamByName('id_car').Value := car_no;
        tmp5.ExecSQL();

        tmp5.Close();
        tmp5.SQL.Clear();
        tmp5.SQL.Add('update events_online set dataczas = :dataczas ');
        tmp5.SQL.Add('where (dataczas <= :dataczas2 or dataczas is null) and car_no = :car_no  ');
        tmp5.Parameters.ParamByName('dataczas').Value := dataczas;
        tmp5.Parameters.ParamByName('dataczas2').Value := dataczas;
        tmp5.Parameters.ParamByName('car_no').Value := car_no;
        tmp5.ExecSQL();
    end
    else
        AddLog('7525 Pojazd nr ' + IntToStr(car_no) + ': czas zerowy');
end;

constructor TListItem2.Create(owner: TListView2);
begin
    inherited Create();
    self.owner := owner;
    SubItems := TStringList.Create();
end;

destructor TListItem2.Destroy();
begin
    SubItems.Free();
    inherited Destroy();
end;

procedure TListItem2.Delete();
var i: Integer;
    self2: TListItem2;
begin
    i := 0;
    while i < Length(owner.Items) do
    begin
        if owner.Items[i] = self then
            break;
        Inc(i);
    end;
    if i < Length(owner.Items) then
    begin
        self2 := owner.Items[i];
        while i < Length(owner.Items) - 1 do
        begin
            owner.Items[i] := owner.Items[i + 1];
            Inc(i);
        end;
        SetLength(owner.Items, Length(owner.Items) - 1);
        self2.Free();
    end;
end;

function TListView2.Add(): TListItem2;
var i: Integer;
begin
    SetLength(Items, Length(Items) + 1);
    for i := Length(Items) - 1 downto 1 do
    begin
        Items[i] := Items[i - 1];
    end;
    Items[0] := TListItem2.Create(Self);
    result := Items[0];
end;

procedure TListView2.Clear();
var i: Integer;
    item: TListItem2;
begin
    for i := 0 to Length(Items) - 1 do
    begin
        item := Items[i];
        item.Free();
    end;
    SetLength(Items, 0);
end;

constructor TListView2.Create();
begin
    inherited Create();
    SetLength(Items, 0);
end;

destructor TListView2.Destroy();
begin
    SetLength(Items, 0);
    inherited Destroy();
end;

procedure TTEDEmailSrv.bXmlToWWWClick();
//var input, output: TStringStream;
//    dane: AnsiString;
begin
//    if (MapcenterServer = '') and (Sender = nil) then
//        exit;

    try
//        if IsPanelInfoInINI() then
            ExportToPanel();
//        else
//        begin
 //           dane := bXmlToWWWClick2();

{
            input := TStringStream.Create('');
            output := TStringStream.Create('');

            IdHTTP1.Request.AcceptCharSet := 'UTF-8';
            IdHTTP1.Request.ContentType := 'application/x-www-form-urlencoded';
            IdHTTP1.Request.Connection := 'close';

            IdHTTP1.Host := 'tednet2.pl';
            IdHTTP1.Port := 80;
            IdHTTP1.Request.BasicAuthentication := True;
            IdHTTP1.Request.Username := 'carnet';
            IdHTTP1.Request.Password := 'xdfh54fg234';
            IdHTTP1.Connect();
            Tag := -1;

            input.WriteString(dane);

        //    AddLog(dane);

//            IdHTTP1.Post('http://tednet2.pl/carnet2/odbierz.php', input, output);
//            if output.DataString <> 'ok' then
//            begin
//                AddLog('Wyst¹pi³ problem przy eksportowaniu danych: ' + output.DataString);
//                raise EAbort.Create('');
//            end;

            IdHTTP1.Disconnect();
            input.Free();
            output.Free();
}
//        end;
    finally

    end;

    AddLog('7651 Eksport zakoñczono pomyœlnie');
end;

function TTEDEmailSrv.bXmlToWWWClick2(): AnsiString;
var car, inputs_description, kierowcy, przesiadki, mail_settings, ustawienia: AnsiString;
begin
    result := '';

//    if (MapcenterServer = '') then
//        exit;

    FormatSettings.DecimalSeparator := '.';

    qXML.Close();
    qXML.SQL.Clear();
    qXML.SQL.Add('select dbo.spDoDwochZnakowf(LTRIM(STR(YEAR(last_gps_datetime)))) + ''-'' + ' +
                  'dbo.spDoDwochZnakowf(LTRIM(STR(MONTH(last_gps_datetime)))) + ''-'' + ' +
                  'LTRIM(STR(DAY(last_gps_datetime))) last_gps_datetime, ' +
                  'last_gps, last_gps_event, last_gps_status, last_packet_prefix, ' +
                  't1.gr1, t1.id_car id, t1.name, t1.rej_numb, t2.max_capacity fuel_max, t3.max_capacity fuel_max2, ' +
                  't1.useles, t1.fast_imp, t4.imp_div mod_imp, ' +
                  't6.driver_name driver, t1.i_tank, t1.i_up, t1.rpm_obro, t1.rpm_disp, t1.mileage count, ' +
                  'max_speed mspeed, ' +
                  '(select ''T'' where rpm_stat = 1 and rpm_stat is not null union ' +
                  'select ''N'' where rpm_stat <> 1 or rpm_stat is null) rpm_stat, rpm_delay rpmdelay, cast(id_probe_type as varchar(1)) sonda, ' +
                  '''5'' freq, rpm_id, ' +
                  'cast(dbo.spDoDwochZnakowf(LTRIM(STR(MONTH(installation_date)))) + ''/'' + ' +
                  'dbo.spDoDwochZnakowf(LTRIM(STR(DAY(installation_date)))) + ''/'' + ' +
                  'LTRIM(STR(YEAR(installation_date))) as datetime) c_date, ' +
                  '(select 1 where fuel_algorithm = 1 ' +
                  '				union ' +
                  '			    select 0 where fuel_algorithm <> 1 or fuel_algorithm is null ' +
                  '               ) stralis, ' +
                  '(select 2 where use_motohours = 1 ' +
                  '				union ' +
                  '			    select 0 where use_motohours <> 1 or use_motohours is null ' +
                  '               ) car_type, ' +
                  'phone_nr telefon, ' +
                  'null changed, 1 synchronized, null deleted, ' +
                  'id_device_type isEmailGPS, ' +
                  'factor_approx_1 aproksymacja, ' +
                  '(select id_approx_type_1 where id_approx_type_1 <> 0 ' +
                  '   union' +
                  '   select 1 where id_approx_type_1 = 0) aproksym_kind, ' +
                  'factor_approx_2 aproksymacja2, ' +
                  '(select id_approx_type_2 where id_approx_type_2 <> 0 ' +
                  '   union' +
                  '   select 1 where id_approx_type_2 = 0) aproksym_kind2, ' +
                  '(select 1 where cistern = 1 ' +
                  '   union' +
                  '   select 0 where cistern = 0) cistern, ' +
                  '(select 1 where factor_approx_2 <> 0.0 ' +
                  '   union ' +
                  '   select 0 where factor_approx_2 = 0.0) second_aproksym, ' +
                  'power_off_on_fuel_chart PowerOffOnFuelChart, ident, ident2, useles_city, useles_city_enabled, apn, ' +
                  'id_starter_type starter, id_email_cycle email_cycle, ' +
                  'mode_30_sec second30, sms_on_start, gps_always_on gps_mode, road_correction, dyn_data_enabled, ' +
                  'dyn_data_max_bad_time, dyn_data_max_useles, filter_first filtr_kolejnosc, ' +
                  'id_transmitter_mode transmitter_mode, alarm_tel, ' +
  '(  select 1 where apn=''www.idea.pl'' ' +
  '  union ' +
  '  select 2 where apn=''www.plusgsm.pl'' ' +
  '  union ' +
  '  select 3 where apn=''erainternet'' ' +
  '  union ' +
  '  select 4 where apn=''erainternettt'' ' +
  '  union ' +
  '  select 5 where apn=''heyah.pl'' ' +
  '  union ' +
  '  select 6 where apn=''internet'' ' +
  '  union ' +
  '  select 7 where (apn <> ''www.idea.pl'') and (apn <> ''www.plusgsm.pl'') and (apn<>''erainternet'') ' +
  '  and (apn<>''erainternettt'') and (apn<>''heyah.pl'') and (apn<>''internet'')) operator_karty ' +
                  'from car t1 ' +
                  'left join fuel_tank t2 on (t1.id_car = t2.id_car and t2.tank_nr = 1) ' +
                  'left join fuel_tank t3 on (t1.id_car = t3.id_car and t3.tank_nr = 2) ' +
                  'left join road_imp_div t4 on (t1.id_road_imp_div = t4.id_road_imp_div) ' +
                  'left join car_change t5 on (t1.id_car = t5.id_car and t5.end_date is null) ' +
                  'left join driver t6 on (t5.id_driver = t6.id_driver) ' +
                  '');
    car := makeXml(qXML, 'car');


    qXML.Close();
    qXML.SQL.Clear();
    qXML.SQL.Add('select 1 id, t1.description enabled_desc, t2.description disabled_desc from ' +
                    'event t1, event t2 where t1.id_event = 1 and t2.id_event = 31 union ' +
                    'select 2 id, t1.description enabled_desc, t2.description disabled_desc from ' +
                    'event t1, event t2 where t1.id_event = 2 and t2.id_event = 32 union ' +
                    'select 3 id, t1.description enabled_desc, t2.description disabled_desc from ' +
                    'event t1, event t2 where t1.id_event = 3 and t2.id_event = 33 union ' +
                    'select 4 id, t1.description enabled_desc, t2.description disabled_desc from ' +
                    'event t1, event t2 where t1.id_event = 4 and t2.id_event = 34 union ' +
                    'select 5 id, t1.description enabled_desc, t2.description disabled_desc from ' +
                    'event t1, event t2 where t1.id_event = 5 and t2.id_event = 35 ');
    inputs_description := makeXml(qXML, 'inputs_description');


    qXML.Close();
    qXML.SQL.Clear();
    qXML.SQL.Add('select id_driver id, driver_name nazwa, fired was_deleted from driver');
    kierowcy := makeXml(qXML, 'kierowcy');

    qXML.Close();
    qXML.SQL.Clear();
    qXML.SQL.Add('select id_car car_no, id_driver driver_no, start_date poczatek, end_date koniec from car_change');
    przesiadki := makeXml(qXML, 'przesiadki');

    qXML.Close();
    qXML.SQL.Clear();
    qXML.SQL.Add('select * from mail_settings');
    mail_settings := makeXml(qXML, 'mail_settings');

    qXML.Close();
    qXML.SQL.Clear();
    qXML.SQL.Add('select * from carnet_settings');
    ustawienia := makeXml(qXML, 'ustawienia');

    result := '&car=' + car +
              '&inputs_description=' + inputs_description +
              '&kierowcy=' + kierowcy +
              '&przesiadki=' + przesiadki +
              '&mail_settings=' + mail_settings +
              '&ustawienia=' + ustawienia;
end;

function TTEDEmailSrv.makeXml(table: TDataSet; tableName: String): AnsiString;
var
  i   : Integer;
  xml,temp : AnsiString;
  blob_stream: TStream;
  blob_znak: Char;
begin
  try
    if table is TRxMemoryData then
        table.First()
    else
    begin
        table.close;
        table.open;
    end;


    xml  := tableName;
    doc  := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
    //Set the root name of the xml file as that of the table name.
    //In this case "country"
    root := doc.createElement(xml);
    doc.appendchild(root);
    //This while loop will go through the entaire table to generate the xml file
    while not table.eof do
    begin
      //adds the first level children , Records
      child:= doc.createElement('Records');
      root.appendchild(child);
      for i:=0 to table.FieldCount-1 do
      begin
        //adds second level children
        child1:=doc.createElement(table.Fields[i].FieldName);
        child.appendchild(child1);
        //Check field types
        case TFieldType(Ord(table.Fields[i].DataType)) of
        ftString:
        begin
          if Table.Fields[i].AsString ='' then
               temp :='null'  //Put a default string
             else
               temp := table.Fields[i].AsString;
        end;

        ftInteger, ftWord, ftSmallint:
        begin
            if Table.Fields[i].AsInteger > 0 then
               temp := IntToStr(table.Fields[i].AsInteger)
             else
               temp := '0';
        end;
        ftFloat, ftCurrency, ftBCD:
        begin
            if table.Fields[i].AsFloat > 0 then
              temp := FloatToStr(table.Fields[i].AsFloat)
            else
               temp := '0';
        end;
        ftBoolean:
        begin
            if table.Fields[i].Value then
              temp:= 'True'
            else
              temp:= 'False';
        end;
        ftDate:
        begin
            if (not table.Fields[i].IsNull) or
               (Length(Trim(table.Fields[i].AsString)) > 0) then
              temp := FormatDateTime('MM/DD/YYYY',
                             table.Fields[i].AsDateTime)
            else
              temp:= '01/01/2000';//put some valid default date
        end;
        ftDateTime:
        begin
            if (not table.Fields[i].IsNull) or
               (Length(Trim(table.Fields[i].AsString)) > 0) then
              temp := FormatDateTime('MM/DD/YYYY hh:nn:ss',
                             Table.Fields[i].AsDateTime)
            else
              temp := '01/01/2000 00:00:00';//Put some valid default date and time
        end;
        ftTime:
        begin
            if (not table.Fields[i].IsNull) or
               (Length(Trim(table.Fields[i].AsString)) > 0) then
               temp := FormatDateTime('hh:nn:ss',
                           table.Fields[i].AsDateTime)
            else
               temp := '00:00:00'; //Put some valid default time
        end;
        ftBlob:
        begin
            if table is TADOQuery then
            begin
                blob_stream := (table as TADOQuery).CreateBlobStream(table.Fields[i], bmRead);
                temp := '';
                blob_stream.Position := 0;
                while blob_stream.Position < blob_stream.Size do
                begin
                    blob_stream.Read(blob_znak, 1);
                    temp := temp + IntToHex(integer(blob_znak), 2);
                end;
                blob_stream.Free();
//                Clipboard.AsText := temp;
            end;
        end;
      end;
       //
       child1.appendChild(doc.createTextNode(temp));
      end;
    table.Next;
    end;
    table.close;

    Result := UTF8Encode(doc.xml);
    doc := nil;
  except
    on e:Exception do
    begin
      table.close;
      Result := '';
    end;
  end;
end;

procedure TTEDEmailSrv.ServiceExecute(Sender: TService);
var databases: TStringList;
    ini: TStringList;
    i: Integer;
    Hour, Min, Sec, MSec: Word;
    Hour2, Min2: Word;
    zrealizowac2: Boolean;
    database_name: String;
    dataczas: TDateTime;
    tmpStr: String;
    last_hour, last_Min: Integer;
    continue_flag: Boolean;
begin
    AddLog('7917 ServiceExecute ');
    try
        last_hour := -1;
        last_Min := -1;
        while True do
        begin
            if Status <> csRunning then
                break;

            Sleep(3000);

            DecodeTime(now(), Hour, Min, Sec, MSec);
            if (Min = 0) and (last_hour <> Hour) then
            begin
                added_databases_section.BeginWrite();
                try
                    qCompanies.Close();
                    qCompanies.SQL.Clear();
                    qCompanies.SQL.Add('select * from company where has_www_account = 1');
                    qCompanies.Open();
                    while not qCompanies.Eof do
                    begin
                        added_databases.Add(qCompanies.FieldByName('sql_database_name').AsString + ':' + FloatToStr(Now() - EncodeTime(1, 0, 0, 0)));
                        qCompanies.Next();
                    end;
                    qCompanies.Close();
                    last_hour := Hour;
                finally
                    added_databases_section.EndWrite();
                end;
            end;

            if ((Min mod 2) = 0) and (last_Min <> Min) then
            begin
                added_databases_section.BeginWrite();
                try
                    qCompanies.Close();
                    qCompanies.SQL.Clear();
                    qCompanies.SQL.Add('select * from company where has_tp_devices = 1');
                    qCompanies.Open();
                    while not qCompanies.Eof do
                    begin
                        added_databases.Add(qCompanies.FieldByName('sql_database_name').AsString + ':' + FloatToStr(Now() - EncodeTime(0, 5, 0, 0)));
                        qCompanies.Next();
                    end;
                    qCompanies.Close();
                    last_Min := Min;
                finally
                    added_databases_section.EndWrite();
                end;
            end;

            database_name := '';
            added_databases_section.BeginRead();
            try
                if added_databases.Count > 0 then
                begin
                    tmpStr := added_databases.Strings[0];

                    database_name := Copy(tmpStr, 1, Pos(':', tmpStr) - 1);

                    tmpStr := Copy(tmpStr, Pos(':', tmpStr) + 1, 1000);

                    tmpStr := ReplaceStr(tmpStr, '.', FormatSettings.DecimalSeparator);
                    tmpStr := ReplaceStr(tmpStr, ',', FormatSettings.DecimalSeparator);

                    dataczas := StrToFloat(tmpStr);

                    if dataczas + EncodeTime(0, 3, 0, 0) < Now() then
                        added_databases.Delete(0)
                    else
                        database_name := '';
                end;
            finally
                added_databases_section.EndRead();
            end;

            databases := TStringList.Create();

        //    if database_name = '' then
            begin
                DecodeTime(now(), Hour, Min, Sec, MSec);

                ini := TStringList.Create();
                ini.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini');

                if ini.IndexOfName('dodatkowe_Hour') = -1 then
                begin
                    ini.Add('dodatkowe_Hour=3');
                    ini.SaveToFile(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini');
                end;

                if ini.IndexOfName('dodatkowe_RetrieveStreets') = -1 then
                begin
                    ini.Add('dodatkowe_RetrieveStreets=0');
                    ini.SaveToFile(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini');
                end;

                if ini.IndexOfName('dodatkowe_Min') = -1 then
                begin
                    ini.Add('dodatkowe_Min=0');
                    ini.SaveToFile(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini');
                end;

                Hour2 := StrToInt(ini.Values['dodatkowe_Hour']);
                Min2  := StrToInt(ini.Values['dodatkowe_Min']);
                ini.Free();

                zrealizowac2 := (Hour2 = Hour) and (Min = Min2);

                ServiceThread.ProcessRequests(False);

                continue_flag := False;

                if zrealizowany and zrealizowac2 then
                    continue_flag := True
                else
                if not zrealizowany and not zrealizowac2 then
                    continue_flag := True
                else
                if zrealizowany and not zrealizowac2 then
                begin
                    zrealizowany := False;
                    continue_flag := True
                end;

                if not continue_flag then
                begin
                    qCompanies.Close();
                    qCompanies.SQL.Clear();
                    qCompanies.SQL.Add('select * from company');
                    qCompanies.Open();
                    while not qCompanies.Eof do
                    begin
                        databases.Add(qCompanies.FieldByName('sql_database_name').AsString);
                        qCompanies.Next();
                    end;
                    qCompanies.Close();
                    if databases.Count = 0 then
                    begin
                        ini := TStringList.Create();
                        ini.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini');
                        databases.Add(ini.Values['Initial Catalog']);
                        ini.Free();
                    end;
                end;
            end;
            try

                if database_name <> '' then
                    databases.Add(database_name);
                i := 0;
//                AddLog('Lista baz: ' + databases.Text);
                while i < databases.Count do
                begin
                    try
                        if Terminated then
                            break;
                        AddLog('8083 Logowanie do bazy ' + databases.Strings[i]);
                        ConnectToDatabase(databases.Strings[i]);
                        AddLog('8085 Pobieranie poczty bazy ' + databases.Strings[i]);
                        if PobierzPoczte() then
                        begin
                            AddLog('8088 Eksport danych na stronê www bazy ' + databases.Strings[i]);
                            bXmlToWWWClick();
                        end;
                        AddLog('8091 Zamykanie bazy ' + databases.Strings[i]);
                        ADOConnection.Connected := False;
                        pop.Disconnect();
                        i := i + 1;
                    except
                        On e: Exception do
                        begin
                            AddLog('8097 ' + e.Message);
                            AddLog('8098 after five seconds x3...');
                            Sleep(5000);
                            try
                                pop.Disconnect();
                            except
                                On e: Exception do
                                begin
                                   AddLog('8108 on disconnect: ' + e.Message);
                                end;
                            end;
                            Sleep(5000);
                            try
                                pop.Reset();
                            except
                                On e: Exception do
                                begin
                                   AddLog('8126 on reset: ' + e.Message);
                                end;
                            end;
                            Sleep(5000);
                            try
                                pop.Disconnect();
                            except
                                On e: Exception do
                                begin
                                   AddLog('8117 on second disconnent: ' + e.Message);
                                end;
                            end;
                            Sleep(5000);
                            try
                                pop.Reset();
                            except
                                On e: Exception do
                                begin
                                   AddLog('8135 on second reset: ' + e.Message);
                                end;
                            end;
                            Sleep(5000);
                            try
                                pop.Disconnect();
                            except
                                On e: Exception do
                                begin
                                   AddLog('8117 on third disconnent: ' + e.Message);
                                end;
                            end;
                            Sleep(5000);
                            AddLog('8139 continue once again');
                            continue;
                        end;
                    end;
                end;
                databases.Free();

            except
                On e: Exception do
                begin
                    AddLog('8102 ' + e.Message);
                end;
            end;
        end;
    except
        On e: Exception do
        begin
            AddLog('8109 ' + e.Message);
        end;
    end;
    AddLog('8112 ServiceExecute koniec ');
end;

procedure TTEDEmailSrv.UaktualnijProcedureTankowania();
begin
    tmp.SQL.Clear();

    tmp.Close();
    tmp.SQL.Clear();
    tmp.SQL.Add('	ALTER procedure [dbo].[spTankowania] ');
    tmp.SQL.Add('	    @carno integer, ');
    tmp.SQL.Add('	    @start datetime, ');
    tmp.SQL.Add('	    @stop datetime, ');
    tmp.SQL.Add('	    @first_1bak numeric(10, 3) OUTPUT, ');
    tmp.SQL.Add('	    @last_1bak numeric(10, 3) OUTPUT, ');
    tmp.SQL.Add('	    @first_2bak numeric(10, 3) OUTPUT, ');
    tmp.SQL.Add('	    @last_2bak numeric(10, 3) OUTPUT, ');
    tmp.SQL.Add('	    @droga numeric(10, 3) OUTPUT, ');
    tmp.SQL.Add('	    @jalowy integer OUTPUT, ');
    tmp.SQL.Add('	    @motogodziny integer OUTPUT, ');
    tmp.SQL.Add('		  @nested integer = 0, ');
    tmp.SQL.Add('	    @id_progress bigint = 0, ');
    tmp.SQL.Add('		  @no_cache integer = 1 ');
    tmp.SQL.Add('	as ');
    tmp.SQL.Add('	    declare @cistern integer ');
    tmp.SQL.Add('	    select @cistern = cistern from car where id_car = @carno ');
    tmp.SQL.Add('	    declare @canceled bit ');
    tmp.SQL.Add('	    set @canceled = 0 ');
    tmp.SQL.Add('	    declare @num_records integer ');
    tmp.SQL.Add('		  declare @start_prior datetime ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @evb1 numeric(3, 0) ');
    tmp.SQL.Add('	    declare @evb2 numeric(3, 0) ');
    tmp.SQL.Add('	    declare @evb3 numeric(3, 0) ');
    tmp.SQL.Add('	    declare @evb4 numeric(3, 0) ');
    tmp.SQL.Add('	    declare @evb5 numeric(3, 0) ');
    tmp.SQL.Add('	    declare @evb6 numeric(3, 0) ');
    tmp.SQL.Add('	    declare @evb7 numeric(3, 0) ');
    tmp.SQL.Add('	    declare @evb8 numeric(3, 0) ');
    tmp.SQL.Add('	    declare @evb9 numeric(3, 0) ');
    tmp.SQL.Add('	    declare @evb10 numeric(3, 0) ');
    tmp.SQL.Add('	    declare @evdata datetime ');
    tmp.SQL.Add('	    declare @id integer ');
    tmp.SQL.Add('	    declare @sonda_flag integer ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @stan integer ');
    tmp.SQL.Add('	    declare @fuel_max numeric(10, 3) ');
    tmp.SQL.Add('	    declare @fuel_max2 numeric(10, 3) ');
    tmp.SQL.Add('	    declare @last117 numeric(10, 3) ');
    tmp.SQL.Add('	    declare @last118 numeric(10, 3) ');
    tmp.SQL.Add('	    declare @last217 numeric(10, 3) ');
    tmp.SQL.Add('	    declare @last218 numeric(10, 3) ');
    tmp.SQL.Add('	    declare @kiedy117 datetime ');
    tmp.SQL.Add('	    declare @kiedy118 datetime ');
    tmp.SQL.Add('	    declare @kiedy113 datetime ');
    tmp.SQL.Add('	    declare @kiedy213 datetime ');
    tmp.SQL.Add('	    declare @max113 numeric(10, 3) ');
    tmp.SQL.Add('	    declare @max213 numeric(10, 3) ');
    tmp.SQL.Add('	    declare @licznik integer ');
    tmp.SQL.Add('	    declare @przyrost_droga numeric(10, 3) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @min_tank numeric(10, 3) ');
    tmp.SQL.Add('	    declare @min_ubytk numeric(10, 3) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @car_type integer ');
    tmp.SQL.Add('	    declare @kiedy10 datetime ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @min_stralis_1 numeric(10, 3) ');
    tmp.SQL.Add('	    declare @min_stralis_2 numeric(10, 3) ');
    tmp.SQL.Add('	    declare @max_stralis_1 numeric(10, 3) ');
    tmp.SQL.Add('	    declare @max_stralis_2 numeric(10, 3) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @min_stralis_pal_1 integer ');
    tmp.SQL.Add('	    declare @min_stralis_pal_2 integer ');
    tmp.SQL.Add('	    declare @max_stralis_pal_1 integer ');
    tmp.SQL.Add('	    declare @max_stralis_pal_2 integer ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @kiedy_min_stralis_1 datetime ');
    tmp.SQL.Add('	    declare @kiedy_min_stralis_2 datetime ');
    tmp.SQL.Add('	    declare @kiedy_max_stralis_1 datetime ');
    tmp.SQL.Add('	    declare @kiedy_max_stralis_2 datetime ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @czy_w_czasie_jazdy integer ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		declare @aproksym_enabled1 integer ');
    tmp.SQL.Add('		declare @aproksym_wsp1 integer ');
    tmp.SQL.Add('		declare @aproksym_kind1 integer ');
    tmp.SQL.Add('		declare @aproksym_enabled2 integer ');
    tmp.SQL.Add('		declare @aproksym_wsp2 integer ');
    tmp.SQL.Add('		declare @aproksym_kind2 integer ');
    tmp.SQL.Add('		declare @i integer ');
    tmp.SQL.Add('		declare @max_aproks_mem integer ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @_117 datetime ');
    tmp.SQL.Add('	    declare @_118 datetime ');
    tmp.SQL.Add('	    declare @sonda numeric(10, 3) ');
    tmp.SQL.Add('	    declare @from_sonda numeric(10, 3) ');
    tmp.SQL.Add('	    declare @to_sonda numeric(10, 3) ');
    tmp.SQL.Add('	    declare @from_sonda2 numeric(10, 3) ');
    tmp.SQL.Add('	    declare @to_sonda2 numeric(10, 3) ');
    tmp.SQL.Add('		declare @zb1 numeric(10, 3) ');
    tmp.SQL.Add('		declare @zb2 numeric(10, 3) ');
    tmp.SQL.Add('	    declare @was_15 integer ');
    tmp.SQL.Add('	    declare @czy_dynamiczny integer ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		declare @paliwo_pal_1 integer ');
    tmp.SQL.Add('		declare @paliwo_pal_2 integer ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		declare @max_skok numeric(10, 3) ');
    tmp.SQL.Add('		declare @max_skok_czas datetime ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		declare @dyn_data integer ');
    tmp.SQL.Add('		select @dyn_data = dyn_data_enabled from car where id_car = @carno ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    select @stan = 0 ');
    tmp.SQL.Add('	    select @last117 = 0.0 ');
    tmp.SQL.Add('	    select @last118 = 0.0 ');
    tmp.SQL.Add('	    select @last217 = 0.0 ');
    tmp.SQL.Add('	    select @last218 = 0.0 ');
    tmp.SQL.Add('	    select @kiedy117 = NULL ');
    tmp.SQL.Add('	    select @kiedy118 = NULL ');
    tmp.SQL.Add('	    select @kiedy113 = NULL ');
    tmp.SQL.Add('	    select @kiedy213 = NULL ');
    tmp.SQL.Add('	    select @first_1bak = 0 ');
    tmp.SQL.Add('	    select @last_1bak = 0 ');
    tmp.SQL.Add('	    select @first_2bak = 0 ');
    tmp.SQL.Add('	    select @last_2bak = 0 ');
    tmp.SQL.Add('	    select @droga = 0 ');
    tmp.SQL.Add('	    select @jalowy = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    select @max113 = 0 ');
    tmp.SQL.Add('	    select @max213 = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    select @licznik = 0 ');
    tmp.SQL.Add('	    select @motogodziny = 0 ');
    tmp.SQL.Add('	    select @kiedy10 = NULL ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    select @min_tank = I_TANK from car where id_car = @carno ');
    tmp.SQL.Add('	    select @min_ubytk = I_UP from car where id_car = @carno ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    select @car_type = use_motohours from car where id_car = @carno ');
    tmp.SQL.Add('	    select @sonda_flag = id_probe_type from car where id_car = @carno ');
    tmp.SQL.Add('	    select @fuel_max = max_capacity from fuel_tank where id_car = @carno and tank_nr = 1 ');
    tmp.SQL.Add('	    if @fuel_max is null ');
    tmp.SQL.Add('	        select @fuel_max = 0 ');
    tmp.SQL.Add('	    select @fuel_max2 = max_capacity from fuel_tank where id_car = @carno and tank_nr = 2 ');
    tmp.SQL.Add('	    if @fuel_max2 is null ');
    tmp.SQL.Add('	        select @fuel_max2 = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    select @min_stralis_1 = 1000000 ');
    tmp.SQL.Add('	    select @min_stralis_2 = 1000000 ');
    tmp.SQL.Add('	    select @max_stralis_1 = 0 ');
    tmp.SQL.Add('	    select @max_stralis_2 = 0 ');
    tmp.SQL.Add('	    select @max_skok = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		select @start_prior = DATEADD(Day, -1, @start) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    create table #paliwo_wynik ');
    tmp.SQL.Add('	    ( ');
    tmp.SQL.Add('	        id integer not null identity(1, 1), ');
    tmp.SQL.Add('	        _117 datetime, -- poczatek tankowania ');
    tmp.SQL.Add('	        _118 datetime, -- koniec tankowania ');
    tmp.SQL.Add('	        sonda numeric(10, 3), -- ilo zatankowanego lub upuszczonego paliwa w ltr ');
    tmp.SQL.Add('	        from_sonda numeric(10, 3), -- tankowanie/upust "z poziomu" w ltr ');
    tmp.SQL.Add('	        from_sonda_pal numeric(10, 3), -- tankowanie/upust "z poziomu" w palach ');
    tmp.SQL.Add('	        to_sonda numeric(10, 3), -- tankowanie/upust "do poziomu" w ltr ');
    tmp.SQL.Add('	        to_sonda_pal numeric(10, 3), -- tankowanie/upust "do poziomu" w palach ');
    tmp.SQL.Add('	        from_sonda2 numeric(10, 3), -- tankowanie/upust "z poziomu" w ltr dla drugiej sondy ');
    tmp.SQL.Add('	        from_sonda2_pal numeric(10, 3), -- tankowanie/upust "z poziomu" w palach dla drugiej sondy ');
    tmp.SQL.Add('	        to_sonda2 numeric(10, 3), -- tankowanie/upust "do poziomu" w ltr dla drugiej sondy ');
    tmp.SQL.Add('	        to_sonda2_pal numeric(10, 3), -- tankowanie/upust "do poziomu" w palach dla drugiej sondy ');
    tmp.SQL.Add('	        was_15 integer, -- zmienna pomocnicza do wentrznego uytku ');
    tmp.SQL.Add('	        czy_dynamiczny integer, -- zmienna pomocnicza do wentrznego uytku ');
    tmp.SQL.Add('			first_event_datetime datetime, ');
    tmp.SQL.Add('			last_event_datetime datetime, ');
    tmp.SQL.Add('	        primary key(id) ');
    tmp.SQL.Add('	    ) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		declare	@first_event_datetime_db datetime ');
    tmp.SQL.Add('		declare @last_event_datetime_db datetime ');
    tmp.SQL.Add('		declare @first_event_datetime_cache datetime ');
    tmp.SQL.Add('		declare @last_event_datetime_cache datetime ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    create table #aproksymacja_params -- tabela tymczasowa dot. aproksymacji wykresu paliwa ');
    tmp.SQL.Add('	    ( ');
    tmp.SQL.Add('			enabled1 integer, ');
    tmp.SQL.Add('			wsp1 integer, ');
    tmp.SQL.Add('			kind1 integer, ');
    tmp.SQL.Add('			start_pos1_bak1 integer, ');
    tmp.SQL.Add('			start_pos1_bak2 integer, ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			enabled2 integer, ');
    tmp.SQL.Add('			wsp2 integer, ');
    tmp.SQL.Add('			kind2 integer, ');
    tmp.SQL.Add('			start_pos2_bak1 integer, ');
    tmp.SQL.Add('			start_pos2_bak2 integer ');
    tmp.SQL.Add('	    ) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    create table #aproksymacja ');
    tmp.SQL.Add('	    ( ');
    tmp.SQL.Add('	        id integer not null, ');
    tmp.SQL.Add('	        nr_zb integer not null, ');
    tmp.SQL.Add('	        step integer not null, ');
    tmp.SQL.Add('	        ltr numeric(10, 3), ');
    tmp.SQL.Add('	        primary key (id, nr_zb, step) ');
    tmp.SQL.Add('	    ) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		create table #paliwo85 -- paliwo w momencie wystapienia zdarzenia 49/115 wykorzystywane do liczania redniego zuycia paliwa dla tras ');
    tmp.SQL.Add('		( ');
    tmp.SQL.Add('	        id integer not null identity(1, 1), ');
    tmp.SQL.Add('			dataczas datetime, ');
    tmp.SQL.Add('			zb1 numeric(10, 3), ');
    tmp.SQL.Add('			zb2 numeric(10, 3), ');
    tmp.SQL.Add('			primary key(id) ');
    tmp.SQL.Add('		) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		select @aproksym_wsp1 = factor_approx_1 from car where id_car = @carno ');
    tmp.SQL.Add('		select @aproksym_kind1 = id_approx_type_1 from car where id_car = @carno ');
    tmp.SQL.Add('		select @aproksym_wsp2 = factor_approx_2 from car where id_car = @carno ');
    tmp.SQL.Add('		select @aproksym_kind2 = id_approx_type_2 from car where id_car = @carno ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		if (@aproksym_wsp1 <> 0.0) ');
    tmp.SQL.Add('				and (@aproksym_kind1 <> 0.0) ');
    tmp.SQL.Add('			select @aproksym_enabled1 = 1 ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('			select @aproksym_enabled1 = null ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		if (@aproksym_wsp2 <> 0.0) ');
    tmp.SQL.Add('				and (@aproksym_kind2 <> 0.0) ');
    tmp.SQL.Add('			select @aproksym_enabled2 = 1 ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('			select @aproksym_enabled2 = null ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		if (@aproksym_enabled1 is not null) and (@aproksym_enabled1 = 1) ');
    tmp.SQL.Add('				and (@aproksym_enabled2 is not null) ');
    tmp.SQL.Add('				and (@aproksym_enabled2 <> 0) ');
    tmp.SQL.Add('				and (@aproksym_wsp2 <> 0.0) ');
    tmp.SQL.Add('				and (@aproksym_wsp2 is not null) ');
    tmp.SQL.Add('			select @aproksym_enabled2 = 1 ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			select @aproksym_enabled2 = null ');
    tmp.SQL.Add('			select @aproksym_wsp2 = 0 ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		if (@aproksym_enabled1 is not null) and (@aproksym_enabled1 = 1) ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			insert into #aproksymacja_params (enabled1, wsp1, kind1, start_pos1_bak1, start_pos1_bak2, ');
    tmp.SQL.Add('										  enabled2, wsp2, kind2, start_pos2_bak1, start_pos2_bak2) ');
    tmp.SQL.Add('				values(@aproksym_enabled1, @aproksym_wsp1, @aproksym_kind1, 0, 0, ');
    tmp.SQL.Add('				       @aproksym_enabled2, @aproksym_wsp2, @aproksym_kind2, 0, 0) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			select @max_aproks_mem = @aproksym_wsp1 ');
    tmp.SQL.Add('			if @max_aproks_mem < @aproksym_wsp2 ');
    tmp.SQL.Add('				select @max_aproks_mem = @aproksym_wsp2 ');
    tmp.SQL.Add('			select @i = 0 ');
    tmp.SQL.Add('			while (@i < @max_aproks_mem) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				insert into #aproksymacja (id, nr_zb, step, ltr) values(@i, 1, 1, 1000000) ');
    tmp.SQL.Add('			    if (@sonda_flag = 3) ');
    tmp.SQL.Add('					insert into #aproksymacja (id, nr_zb, step, ltr) values(@i, 2, 1, 1000000) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@aproksym_enabled2 is not null) and (@aproksym_enabled2 = 1) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					insert into #aproksymacja (id, nr_zb, step, ltr) values(@i, 1, 2, 1000000) ');
    tmp.SQL.Add('					if (@sonda_flag = 3) ');
    tmp.SQL.Add('						insert into #aproksymacja (id, nr_zb, step, ltr) values(@i, 2, 2, 1000000) ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				select @i = @i + 1 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		if (@sonda_flag = 3) ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			declare zdarzenia_cr cursor ');
    tmp.SQL.Add('				for select min(t1.date), max(t1.date) ');
    tmp.SQL.Add('					from device_data t1 ');
    tmp.SQL.Add('			  left join fuel_tank t2 ');
    tmp.SQL.Add('					  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) ');
    tmp.SQL.Add('			  left join probe_liters t22 ');
    tmp.SQL.Add('					  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) ');
    tmp.SQL.Add('			  left join fuel_tank t3 ');
    tmp.SQL.Add('					  on (t1.evb2 = t3.id_car and t3.tank_nr = 2) ');
    tmp.SQL.Add('			  left join probe_liters t33 ');
    tmp.SQL.Add('					  on (t3.id_fuel_tank = t33.id_fuel_tank and t33.id_probe = t1.pal2) ');
    tmp.SQL.Add('				where t1.evb2 = @carno and t1.date >= @start_prior and t1.date <= @stop and ');
    tmp.SQL.Add('				((t1.evb3 = 119 and t1.evb4 > 0) or ');
    tmp.SQL.Add('				 (t1.evb3 = 113 and t1.evb4 > 0) or ');
    tmp.SQL.Add('				 (t1.evb3 = 219 and t1.evb4 > 0) or ');
    tmp.SQL.Add('				 (t1.evb3 = 213 and t1.evb4 > 0) ');
    tmp.SQL.Add('					or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('		if (@sonda_flag = 1) ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			declare zdarzenia_cr cursor ');
    tmp.SQL.Add('			  for select min(t1.date), max(t1.date) ');
    tmp.SQL.Add('					from device_data t1 ');
    tmp.SQL.Add('			  left join fuel_tank t2 ');
    tmp.SQL.Add('					  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) ');
    tmp.SQL.Add('			  left join probe_liters t22 ');
    tmp.SQL.Add('					  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) ');
    tmp.SQL.Add('				where t1.evb2 = @carno and t1.date >= @start_prior and t1.date <= @stop and ');
    tmp.SQL.Add('				(((t1.evb3 = 113) and (t1.evb4 > 3)) ');
    tmp.SQL.Add('					or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			declare zdarzenia_cr cursor ');
    tmp.SQL.Add('			  for select min(t1.date), max(t1.date) ');
    tmp.SQL.Add('					from device_data t1 ');
    tmp.SQL.Add('			  left join fuel_tank t2 ');
    tmp.SQL.Add('					  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) ');
    tmp.SQL.Add('			  left join probe_liters t22 ');
    tmp.SQL.Add('					  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) ');
    tmp.SQL.Add('				where t1.evb2 = @carno and t1.date >= @start_prior and t1.date <= @stop and ');
    tmp.SQL.Add('				((t1.evb3 = 119 and t1.evb4 > 0) or ');
    tmp.SQL.Add('				 (t1.evb3 = 113 and t1.evb4 > 0) ');
    tmp.SQL.Add('					or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    open zdarzenia_cr ');
    tmp.SQL.Add('	    fetch zdarzenia_cr into @first_event_datetime_db, @last_event_datetime_db ');
    tmp.SQL.Add('	    close zdarzenia_cr ');
    tmp.SQL.Add('	    deallocate zdarzenia_cr ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		declare zdarzenia_cr cursor ');
    tmp.SQL.Add('			for select min(t1.first_event_datetime) first_event_datetime, ');
    tmp.SQL.Add('					   max(t1.last_event_datetime) last_event_datetime ');
    tmp.SQL.Add('				from cache_refueling t1 ');
    tmp.SQL.Add('			where t1.id_car = @carno and t1._117 >= @start_prior and t1._118 <= @stop ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    open zdarzenia_cr ');
    tmp.SQL.Add('	    fetch zdarzenia_cr into @first_event_datetime_cache, @last_event_datetime_cache ');
    tmp.SQL.Add('	    close zdarzenia_cr ');
    tmp.SQL.Add('	    deallocate zdarzenia_cr ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @start2 datetime ');
    tmp.SQL.Add('	    declare @stop2 datetime ');
    tmp.SQL.Add('	    declare @scope_type integer ');
    tmp.SQL.Add('		select @scope_type = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    if (@first_event_datetime_cache is null and ');
    tmp.SQL.Add('		   @last_event_datetime_cache is null) or ');
    tmp.SQL.Add('		   (@no_cache = 1) or (@nested = 1) ');
    tmp.SQL.Add('		begin -- stworz pierwsza pozycje w cache ');
    tmp.SQL.Add('			select @start2 = @start_prior ');
    tmp.SQL.Add('			select @stop2 = @stop ');
    tmp.SQL.Add('			select @scope_type = 1 ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('		if @first_event_datetime_cache is not null and ');
    tmp.SQL.Add('		   @first_event_datetime_db is not null and ');
    tmp.SQL.Add('		   @last_event_datetime_cache is not null and ');
    tmp.SQL.Add('		   @last_event_datetime_db is not null and ');
    tmp.SQL.Add('		   @first_event_datetime_db < @first_event_datetime_cache and ');
    tmp.SQL.Add('		   @last_event_datetime_db <= @last_event_datetime_cache ');
    tmp.SQL.Add('		begin -- dodaj do cache tylko starsze niz w cache ');
    tmp.SQL.Add('			select @start2 = @start_prior ');
    tmp.SQL.Add('			select @stop2 = @first_event_datetime_cache ');
    tmp.SQL.Add('			select @scope_type = 2 ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('		if @last_event_datetime_cache is not null and ');
    tmp.SQL.Add('		   @last_event_datetime_db is not null and ');
    tmp.SQL.Add('		   @first_event_datetime_cache is not null and ');
    tmp.SQL.Add('		   @first_event_datetime_db is not null and ');
    tmp.SQL.Add('		   @last_event_datetime_db > @last_event_datetime_cache and ');
    tmp.SQL.Add('		   @first_event_datetime_db >= @first_event_datetime_cache ');
    tmp.SQL.Add('		begin -- dodaj do cache tylko nowsze ni¿ w cache ');
    tmp.SQL.Add('			select @start2 = @last_event_datetime_cache ');
    tmp.SQL.Add('			select @stop2 = @stop ');
    tmp.SQL.Add('			select @scope_type = 3 ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('		if @last_event_datetime_cache is not null and ');
    tmp.SQL.Add('		   @last_event_datetime_db is not null and ');
    tmp.SQL.Add('		   @first_event_datetime_cache is not null and ');
    tmp.SQL.Add('		   @first_event_datetime_db is not null and ');
    tmp.SQL.Add('		   @last_event_datetime_db <= @last_event_datetime_cache and ');
    tmp.SQL.Add('		   @first_event_datetime_db >= @first_event_datetime_cache ');
    tmp.SQL.Add('		begin -- nie trzeba nic wyliczac, pobierz tylko z cache ');
    tmp.SQL.Add('			select @scope_type = 4 ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('		begin -- nie obs³ugiwane na razie, potrzeba wyliczenia danych ');
    tmp.SQL.Add('			  -- zarówno starszych jak i m³odszych ni¿ w cache (w dwóch przebiegach) ');
    tmp.SQL.Add('			select @scope_type = 5 ');
    tmp.SQL.Add('			RAISERROR(''@Not supported'', 16, 1); ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		if @scope_type < 4 ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			if (@scope_type = 2) or (@scope_type = 3) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				if (@sonda_flag = 3) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					declare zdarzenia_cr cursor ');
    tmp.SQL.Add('						for select min(t1.date), max(t1.date) ');
    tmp.SQL.Add('							from device_data t1 ');
    tmp.SQL.Add('					  left join fuel_tank t2 ');
    tmp.SQL.Add('							  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) ');
    tmp.SQL.Add('					  left join probe_liters t22 ');
    tmp.SQL.Add('							  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) ');
    tmp.SQL.Add('					  left join fuel_tank t3 ');
    tmp.SQL.Add('							  on (t1.evb2 = t3.id_car and t3.tank_nr = 2) ');
    tmp.SQL.Add('					  left join probe_liters t33 ');
    tmp.SQL.Add('							  on (t3.id_fuel_tank = t33.id_fuel_tank and t33.id_probe = t1.pal2) ');
    tmp.SQL.Add('						where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and ');
    tmp.SQL.Add('						((t1.evb3 = 119 and t1.evb4 > 0) or ');
    tmp.SQL.Add('						 (t1.evb3 = 113 and t1.evb4 > 0) or ');
    tmp.SQL.Add('						 (t1.evb3 = 219 and t1.evb4 > 0) or ');
    tmp.SQL.Add('						 (t1.evb3 = 213 and t1.evb4 > 0) ');
    tmp.SQL.Add('							or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				if (@sonda_flag = 1) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					declare zdarzenia_cr cursor ');
    tmp.SQL.Add('					  for select min(t1.date), max(t1.date) ');
    tmp.SQL.Add('							from device_data t1 ');
    tmp.SQL.Add('					  left join fuel_tank t2 ');
    tmp.SQL.Add('							  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) ');
    tmp.SQL.Add('					  left join probe_liters t22 ');
    tmp.SQL.Add('							  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) ');
    tmp.SQL.Add('						where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and ');
    tmp.SQL.Add('						(((t1.evb3 = 113) and (t1.evb4 > 3)) ');
    tmp.SQL.Add('							or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					declare zdarzenia_cr cursor ');
    tmp.SQL.Add('					  for select min(t1.date), max(t1.date) ');
    tmp.SQL.Add('							from device_data t1 ');
    tmp.SQL.Add('					  left join fuel_tank t2 ');
    tmp.SQL.Add('							  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) ');
    tmp.SQL.Add('					  left join probe_liters t22 ');
    tmp.SQL.Add('							  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) ');
    tmp.SQL.Add('						where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and ');
    tmp.SQL.Add('						((t1.evb3 = 119 and t1.evb4 > 0) or ');
    tmp.SQL.Add('						 (t1.evb3 = 113 and t1.evb4 > 0) ');
    tmp.SQL.Add('							or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				open zdarzenia_cr ');
    tmp.SQL.Add('				fetch zdarzenia_cr into @first_event_datetime_db, @last_event_datetime_db ');
    tmp.SQL.Add('				close zdarzenia_cr ');
    tmp.SQL.Add('				deallocate zdarzenia_cr ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			if (@sonda_flag = 3) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				declare zdarzenia_cr cursor ');
    tmp.SQL.Add('					for select t1.id_device_data, t1.evb1, t1.evb2, t1.evb3, t1.evb4, t1.evb5, t1.evb6, t1.evb7, t1.evb8, t1.evb9, t1.evb10, ');
    tmp.SQL.Add('							t1.date, t22.liters, t33.liters from device_data t1 ');
    tmp.SQL.Add('				  left join fuel_tank t2 ');
    tmp.SQL.Add('						  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) ');
    tmp.SQL.Add('				  left join probe_liters t22 ');
    tmp.SQL.Add('						  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) ');
    tmp.SQL.Add('				  left join fuel_tank t3 ');
    tmp.SQL.Add('						  on (t1.evb2 = t3.id_car and t3.tank_nr = 2) ');
    tmp.SQL.Add('				  left join probe_liters t33 ');
    tmp.SQL.Add('						  on (t3.id_fuel_tank = t33.id_fuel_tank and t33.id_probe = t1.pal2) ');
    tmp.SQL.Add('					where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and ');
    tmp.SQL.Add('					((t1.evb3 = 119 and t1.evb4 > 0) or ');
    tmp.SQL.Add('					 (t1.evb3 = 113 and t1.evb4 > 0) or ');
    tmp.SQL.Add('					 (t1.evb3 = 219 and t1.evb4 > 0) or ');
    tmp.SQL.Add('					 (t1.evb3 = 213 and t1.evb4 > 0) or (t1.evb3 = 85) ');
    tmp.SQL.Add('						or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) ');
    tmp.SQL.Add('					order by t1.id_device_data ');
    tmp.SQL.Add('				select @num_records = count(*) ');
    tmp.SQL.Add('					from device_data t1 ');
    tmp.SQL.Add('					where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and ');
    tmp.SQL.Add('					((t1.evb3 = 119 and t1.evb4 > 0) or ');
    tmp.SQL.Add('					 (t1.evb3 = 113 and t1.evb4 > 0) or ');
    tmp.SQL.Add('					 (t1.evb3 = 219 and t1.evb4 > 0) or ');
    tmp.SQL.Add('					 (t1.evb3 = 213 and t1.evb4 > 0) or (t1.evb3 = 85) ');
    tmp.SQL.Add('						or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			else ');
    tmp.SQL.Add('			if (@sonda_flag = 1) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				declare zdarzenia_cr cursor ');
    tmp.SQL.Add('					for select t1.id_device_data, t1.evb1, t1.evb2, t1.evb3, t1.evb4, t1.evb5, t1.evb6, t1.evb7, t1.evb8, t1.evb9, t1.evb10, ');
    tmp.SQL.Add('															   t1.date, t22.liters, 0.0 from device_data t1 ');
    tmp.SQL.Add('				  left join fuel_tank t2 ');
    tmp.SQL.Add('						  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) ');
    tmp.SQL.Add('				  left join probe_liters t22 ');
    tmp.SQL.Add('						  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) ');
    tmp.SQL.Add('					where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and ');
    tmp.SQL.Add('					(((t1.evb3 = 113) and (t1.evb4 > 3)) or (t1.evb3 = 85) ');
    tmp.SQL.Add('						or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) ');
    tmp.SQL.Add('					order by t1.id_device_data ');
    tmp.SQL.Add('				select @num_records = count(*) ');
    tmp.SQL.Add('				from device_data t1 ');
    tmp.SQL.Add('					where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and ');
    tmp.SQL.Add('					(((t1.evb3 = 113) and (t1.evb4 > 3)) or (t1.evb3 = 85) ');
    tmp.SQL.Add('						or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			else ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				declare zdarzenia_cr cursor ');
    tmp.SQL.Add('					for select t1.id_device_data, t1.evb1, t1.evb2, t1.evb3, t1.evb4, t1.evb5, t1.evb6, t1.evb7, t1.evb8, t1.evb9, t1.evb10, ');
    tmp.SQL.Add('															   t1.date, t22.liters, 0.0 from device_data t1 ');
    tmp.SQL.Add('				  left join fuel_tank t2 ');
    tmp.SQL.Add('						  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) ');
    tmp.SQL.Add('				  left join probe_liters t22 ');
    tmp.SQL.Add('						  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) ');
    tmp.SQL.Add('					where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and ');
    tmp.SQL.Add('					((t1.evb3 = 119 and t1.evb4 > 0) or ');
    tmp.SQL.Add('					 (t1.evb3 = 113 and t1.evb4 > 0) or (t1.evb3 = 85) ');
    tmp.SQL.Add('						or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) ');
    tmp.SQL.Add('					order by t1.id_device_data ');
    tmp.SQL.Add('				select @num_records = count(*) ');
    tmp.SQL.Add('				from device_data t1 ');
    tmp.SQL.Add('					where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and ');
    tmp.SQL.Add('					((t1.evb3 = 119 and t1.evb4 > 0) or ');
    tmp.SQL.Add('					 (t1.evb3 = 113 and t1.evb4 > 0) or (t1.evb3 = 85) ');
    tmp.SQL.Add('						or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			select @czy_w_czasie_jazdy = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			open zdarzenia_cr ');
    tmp.SQL.Add('			fetch zdarzenia_cr into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, ');
    tmp.SQL.Add('													@evb8, @evb9, @evb10, @evdata, @zb1, @zb2 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @dyn_data_max_useles numeric(10, 3) ');
    tmp.SQL.Add('			select @dyn_data_max_useles = dyn_data_max_useles from car where id_car = @carno ');
    tmp.SQL.Add('			declare @dyn_data_max_bad_time numeric(10, 3) ');
    tmp.SQL.Add('			select @dyn_data_max_bad_time = dyn_data_max_bad_time from car where id_car = @carno ');
    tmp.SQL.Add('			declare @last_droga numeric(10, 3) ');
    tmp.SQL.Add('			select @last_droga = 0 ');
    tmp.SQL.Add('			declare @last_zb1 numeric(10, 3) ');
    tmp.SQL.Add('			select @last_zb1 = @zb1 ');
    tmp.SQL.Add('			declare @last_zb2 numeric(10, 3) ');
    tmp.SQL.Add('			select @last_zb2 = @zb2 ');
    tmp.SQL.Add('			declare @last_czas113 datetime ');
    tmp.SQL.Add('			select @last_czas113 = @evdata ');
    tmp.SQL.Add('			declare @bad_count integer ');
    tmp.SQL.Add('			select @bad_count = 0 ');
    tmp.SQL.Add('			declare @zuzycie_dx numeric(10, 3) ');
    tmp.SQL.Add('			declare @droga_ numeric(10, 3) ');
    tmp.SQL.Add('			declare @czas113 datetime ');
    tmp.SQL.Add('			declare @bad_count_start_time datetime ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @first_filtry integer ');
    tmp.SQL.Add('			select @first_filtry = filter_first from car where id_car = @carno ');
    tmp.SQL.Add('			if @first_filtry is null ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				select @first_filtry = 0 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @licznik_rec integer ');
    tmp.SQL.Add('			set @licznik_rec = 0 ');
    tmp.SQL.Add('			declare @last_droga2 numeric(10, 3) ');
    tmp.SQL.Add('			set @last_droga2 = 0.0 ');
    tmp.SQL.Add('			declare @droga_2 numeric(10, 3) ');
    tmp.SQL.Add('			set @droga_2 = 0.0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			while (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('	 			if (@evb3 = 10) and (@evdata >= @start) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					set @last_droga2 = 0 ');
    tmp.SQL.Add('					set @droga_2 = 0.0 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				if (@evb3 = 113) and (@evdata >= @start) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					execute spDroga @carno, @evb1, @evb10, @droga_2 OUTPUT ');
    tmp.SQL.Add('					set @droga = @droga + @droga_2 - @last_droga2 ');
    tmp.SQL.Add('					set @last_droga2 = @droga_2 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				if (@evb3 = 49) and (@evdata >= @start) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					set @droga_2 = -100 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				if (@evb3 = 85) and (@evdata >= @start) and (@droga_2 = -100) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					execute spDroga @carno, @evb9, @evb10, @droga_2 OUTPUT ');
    tmp.SQL.Add('					set @droga = @droga + @droga_2 - @last_droga2 ');
    tmp.SQL.Add('					set @last_droga2 = @droga_2 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('			if @cistern = 1 ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('			  if @evb3 = 113 ');
    tmp.SQL.Add('				set @evb3 = 119 ');
    tmp.SQL.Add('			  else ');
    tmp.SQL.Add('			  if @evb3 = 213 ');
    tmp.SQL.Add('				set @evb3 = 219 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('				if @zb1 is null ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					select @zb1 = 0 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				if @zb2 is null ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					select @zb2 = 0 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				if (@dyn_data is not null) and (@dyn_data = 1) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('						if (@evb3 = 10) ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							select @last_droga = 0.0 ');
    tmp.SQL.Add('							select @last_czas113 = @evdata ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('						else ');
    tmp.SQL.Add('						if (@evb3 = 113) or (@evb3 = 119) or (@evb3 = 213) or (@evb3 = 219) ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							if (@evb3 = 119) and (@first_filtry = 1) ');
    tmp.SQL.Add('								execute spPaliwo @carno, @evb3, 1, @evb4, 0, @zb1 OUTPUT ');
    tmp.SQL.Add('							else ');
    tmp.SQL.Add('							if (@evb3 = 113) and (@first_filtry = 1) ');
    tmp.SQL.Add('								execute spPaliwo @carno, @evb3, 1, @evb4, 0, @zb1 OUTPUT ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('							if (@evb3 = 219) and (@first_filtry = 1) ');
    tmp.SQL.Add('								execute spPaliwo @carno, @evb3, 2, @evb4, 0, @zb2 OUTPUT ');
    tmp.SQL.Add('							else ');
    tmp.SQL.Add('							if (@evb3 = 213) and (@first_filtry = 1) ');
    tmp.SQL.Add('								execute spPaliwo @carno, @evb3, 2, @evb4, 0, @zb2 OUTPUT ');
    tmp.SQL.Add('							if @zb1 is null ');
    tmp.SQL.Add('							begin ');
    tmp.SQL.Add('								select @zb1 = 0 ');
    tmp.SQL.Add('							end ');
    tmp.SQL.Add('							if @zb2 is null ');
    tmp.SQL.Add('							begin ');
    tmp.SQL.Add('								select @zb2 = 0 ');
    tmp.SQL.Add('							end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('							if (@evb3 = 113) ');
    tmp.SQL.Add('								select @droga_ = (@evb1 * 256 + @evb10) / 10.0 ');
    tmp.SQL.Add('							else ');
    tmp.SQL.Add('							if (@evb3 = 119) or (@evb3 = 219) ');
    tmp.SQL.Add('								select @droga_ = @last_droga ');
    tmp.SQL.Add('							select @czas113 = @evdata ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('							if @evb3 <> 213 ');
    tmp.SQL.Add('							begin ');
    tmp.SQL.Add('								if (@car_type <> 1) or (@car_type is null) ');
    tmp.SQL.Add('								begin ');
    tmp.SQL.Add('									if abs(@droga_ - @last_droga) > 0.0001 ');
    tmp.SQL.Add('										select @zuzycie_dx = (((@last_zb1 + @last_zb2) - (@zb1 + @zb2)) / (@droga_ - @last_droga)) * 100 ');
    tmp.SQL.Add('									else ');
    tmp.SQL.Add('										select @zuzycie_dx = (@last_zb1 + @last_zb2) - (@zb1 + @zb2) ');
    tmp.SQL.Add('								end ');
    tmp.SQL.Add('								else ');
    tmp.SQL.Add('								begin ');
    tmp.SQL.Add('									if @last_czas113 <> @czas113 ');
    tmp.SQL.Add('										select @zuzycie_dx = ((@last_zb1 + @last_zb2) - (@zb1 + @zb2)) / (DATEDIFF(minute, @last_czas113, @czas113) / 60.0) ');
    tmp.SQL.Add('									else ');
    tmp.SQL.Add('										select @zuzycie_dx = ((@last_zb1 + @last_zb2) - (@zb1 + @zb2)) / (1 / 60.0) ');
    tmp.SQL.Add('								end ');
    tmp.SQL.Add('							end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('							if abs(@zuzycie_dx) > @dyn_data_max_useles ');
    tmp.SQL.Add('							begin ');
    tmp.SQL.Add('								if @bad_count = 0 ');
    tmp.SQL.Add('									select @bad_count_start_time = @evdata ');
    tmp.SQL.Add('								if DATEDIFF(minute, @bad_count_start_time, @evdata) < @dyn_data_max_bad_time ');
    tmp.SQL.Add('								begin ');
    tmp.SQL.Add('									select @bad_count = @bad_count + 1 ');
    tmp.SQL.Add('									fetch zdarzenia_cr into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, ');
    tmp.SQL.Add('													@evb8, @evb9, @evb10, @evdata, @zb1, @zb2 ');
    tmp.SQL.Add('									if (@car_type = 1) select @last_czas113 = @czas113 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('									continue ');
    tmp.SQL.Add('								end ');
    tmp.SQL.Add('							end ');
    tmp.SQL.Add('							select @bad_count = 0 ');
    tmp.SQL.Add('							select @last_droga = @droga_ ');
    tmp.SQL.Add('							select @last_czas113 = @czas113 ');
    tmp.SQL.Add('							select @last_zb1 = @zb1 ');
    tmp.SQL.Add('							select @last_zb2 = @zb2 ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if @evdata >= @start ');
    tmp.SQL.Add('					select @evdata = @evdata ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@evb3 = 49) or (@evb3 = 115) or (@evb3 = 85) or (@evb3 = 119) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if @czy_w_czasie_jazdy = 1 ');
    tmp.SQL.Add('						if ((@sonda_flag <> 3) or (@sonda_flag is null)) ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							if (@max_stralis_1 <> 0) and (@min_stralis_1 <> 1000000) ');
    tmp.SQL.Add('								if @kiedy_min_stralis_1 > @kiedy_max_stralis_1 ');
    tmp.SQL.Add('								begin ');
    tmp.SQL.Add('									select @kiedy_max_stralis_1 = @kiedy_min_stralis_1 ');
    tmp.SQL.Add('									select @max_stralis_1 = @min_stralis_1 ');
    tmp.SQL.Add('									select @max_skok = 0 ');
    tmp.SQL.Add('								end ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('						else ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							if (@max_stralis_2 <> 0) and (@min_stralis_2 <> 1000000) ');
    tmp.SQL.Add('								if @kiedy_min_stralis_2 > @kiedy_max_stralis_2 ');
    tmp.SQL.Add('								begin ');
    tmp.SQL.Add('									select @kiedy_max_stralis_2 = @kiedy_min_stralis_2 ');
    tmp.SQL.Add('									select @max_stralis_2 = @min_stralis_2 ');
    tmp.SQL.Add('									select @kiedy_max_stralis_1 = @kiedy_min_stralis_1 ');
    tmp.SQL.Add('									select @max_stralis_1 = @min_stralis_1 ');
    tmp.SQL.Add('									select @max_skok = 0 ');
    tmp.SQL.Add('								end ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('					select @czy_w_czasie_jazdy = 0 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				if (@evb3 = 113) or (@evb3 = 10) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if @czy_w_czasie_jazdy = 0 ');
    tmp.SQL.Add('						if ((@sonda_flag <> 3) or (@sonda_flag is null)) ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							if (@max_stralis_1 <> 0) and (@min_stralis_1 <> 1000000) ');
    tmp.SQL.Add('								if @kiedy_min_stralis_1 > @kiedy_max_stralis_1 ');
    tmp.SQL.Add('								begin ');
    tmp.SQL.Add('									if (@sonda_flag <> 1) or (@sonda_flag is null) or ');
    tmp.SQL.Add('										((@sonda_flag = 1) and (@min_stralis_1 <> 0)) ');
    tmp.SQL.Add('									begin ');
    tmp.SQL.Add('										if @kiedy_max_stralis_1 >= @start_prior ');
    tmp.SQL.Add('											insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, ');
    tmp.SQL.Add('												czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) ');
    tmp.SQL.Add('		--							            values(@kiedy_max_stralis_1, @kiedy_min_stralis_1, ');
    tmp.SQL.Add('												values(@max_skok_czas, @max_skok_czas, ');
    tmp.SQL.Add('												@min_stralis_1 - @max_stralis_1, @max_stralis_1, @min_stralis_1, 0.0, 0.0, 1, ');
    tmp.SQL.Add('												@max_stralis_pal_1, @min_stralis_pal_1, 0.0, 0.0) ');
    tmp.SQL.Add('										select @max_stralis_1 = @min_stralis_1 ');
    tmp.SQL.Add('										select @max_skok = 0 ');
    tmp.SQL.Add('									end ');
    tmp.SQL.Add('								end ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('						else ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							if (@max_stralis_2 <> 0) and (@min_stralis_2 <> 1000000) ');
    tmp.SQL.Add('								if @kiedy_min_stralis_2 > @kiedy_max_stralis_2 ');
    tmp.SQL.Add('								begin ');
    tmp.SQL.Add('									if (@sonda_flag <> 1) or (@sonda_flag is null) or ');
    tmp.SQL.Add('										((@sonda_flag = 1) and (@min_stralis_2 <> 0)) ');
    tmp.SQL.Add('									begin ');
    tmp.SQL.Add('										if @kiedy_max_stralis_2 >= @start_prior ');
    tmp.SQL.Add('											insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, ');
    tmp.SQL.Add('												czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) ');
    tmp.SQL.Add('		--								        values(@kiedy_max_stralis_2, @kiedy_min_stralis_2, ');
    tmp.SQL.Add('												values(@max_skok_czas, @max_skok_czas, ');
    tmp.SQL.Add('												@min_stralis_2 - @max_stralis_2 + ');
    tmp.SQL.Add('												@min_stralis_1 - @max_stralis_1, ');
    tmp.SQL.Add('												@max_stralis_1, @min_stralis_1, ');
    tmp.SQL.Add('												@max_stralis_2, @min_stralis_2, 1, ');
    tmp.SQL.Add('												@max_stralis_pal_1, @min_stralis_pal_1, ');
    tmp.SQL.Add('												@max_stralis_pal_2, @min_stralis_pal_2) ');
    tmp.SQL.Add('										select @max_stralis_1 = @min_stralis_1 ');
    tmp.SQL.Add('										select @max_stralis_2 = @min_stralis_1 ');
    tmp.SQL.Add('										select @max_skok = 0 ');
    tmp.SQL.Add('									end ');
    tmp.SQL.Add('								end ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('					select @czy_w_czasie_jazdy = 1 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@evb3 = 119) and (((@first_1bak < (@fuel_max / 17.0)) and @fuel_max <> 0) and (@first_1bak = 0) ');
    tmp.SQL.Add('						or (@first_1bak = 0 and @fuel_max = 0)) and (@evdata >= @start) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if (@dyn_data is not null) and (@dyn_data = 1) ');
    tmp.SQL.Add('						select @first_1bak = @zb1 ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('						execute spPaliwo @carno, @evb3, 1, @evb4, 0, @first_1bak OUTPUT ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				if (@evb3 = 113) and (((@first_1bak < (@fuel_max / 17.0)) and @fuel_max <> 0) and (@first_1bak = 0) ');
    tmp.SQL.Add('						or (@first_1bak = 0 and @fuel_max = 0)) and (@evdata >= @start) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if (@dyn_data is not null) and (@dyn_data = 1) ');
    tmp.SQL.Add('						select @first_1bak = @zb1 ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('						execute spPaliwo @carno, @evb3, 1, @evb4, 0, @first_1bak OUTPUT ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@evb3 = 219) and (((@first_2bak < (@fuel_max2 / 17.0)) and @fuel_max2 <> 0) and (@first_2bak = 0) ');
    tmp.SQL.Add('						or (@first_2bak = 0 and @fuel_max2 = 0)) and (@evdata >= @start) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if (@dyn_data is not null) and (@dyn_data = 1) ');
    tmp.SQL.Add('						select @first_2bak = @zb2 ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('						execute spPaliwo @carno, @evb3, 2, @evb4, 0, @first_2bak OUTPUT ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				if (@evb3 = 213) and (((@first_2bak < (@fuel_max2 / 17.0)) and @fuel_max2 <> 0)  and (@first_2bak = 0) ');
    tmp.SQL.Add('						or (@first_2bak = 0 and @fuel_max2 = 0)) and (@evdata >= @start) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if (@dyn_data is not null) and (@dyn_data = 1) ');
    tmp.SQL.Add('						select @first_2bak = @zb2 ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('						execute spPaliwo @carno, @evb3, 2, @evb4, 0, @first_2bak OUTPUT ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@evb3 = 119) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if (@dyn_data is not null) and (@dyn_data = 1) ');
    tmp.SQL.Add('						select @last_1bak = @zb1 ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('						execute spPaliwo @carno, @evb3, 1, @evb4, 0, @last_1bak OUTPUT ');
    tmp.SQL.Add('					select @paliwo_pal_1 = @evb4 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				if (@evb3 = 113) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if (@dyn_data is not null) and (@dyn_data = 1) ');
    tmp.SQL.Add('						select @last_1bak = @zb1 ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('						execute spPaliwo @carno, @evb3, 1, @evb4, 0, @last_1bak OUTPUT ');
    tmp.SQL.Add('					select @paliwo_pal_1 = @evb4 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@evb3 = 219) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if (@dyn_data is not null) and (@dyn_data = 1) ');
    tmp.SQL.Add('						select @last_2bak = @zb2 ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('						execute spPaliwo @carno, @evb3, 2, @evb4, 0, @last_2bak OUTPUT ');
    tmp.SQL.Add('					select @paliwo_pal_2 = @evb4 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				if (@evb3 = 213) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if (@dyn_data is not null) and (@dyn_data = 1) ');
    tmp.SQL.Add('						select @last_2bak = @zb2 ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('						execute spPaliwo @carno, @evb3, 2, @evb4, 0, @last_2bak OUTPUT ');
    tmp.SQL.Add('					select @paliwo_pal_2 = @evb4 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@evb3 = 119) or (@evb3 = 113) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if ((@sonda_flag <> 3) or (@sonda_flag is null)) ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						if (@last_1bak <= @min_stralis_1) ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							if @max_skok < abs(@min_stralis_1 - @last_1bak) ');
    tmp.SQL.Add('							begin ');
    tmp.SQL.Add('								select @max_skok = abs(@min_stralis_1 - @last_1bak) ');
    tmp.SQL.Add('								select @max_skok_czas = @evdata ');
    tmp.SQL.Add('							end ');
    tmp.SQL.Add('							select @kiedy_min_stralis_1 = @evdata ');
    tmp.SQL.Add('							select @min_stralis_1 = @last_1bak ');
    tmp.SQL.Add('							select @min_stralis_pal_1 = @paliwo_pal_1 ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('						else ');
    tmp.SQL.Add('						if (@max_stralis_1 <> 0) and (@min_stralis_1 <> 1000000) ');
    tmp.SQL.Add('							if @kiedy_min_stralis_1 > @kiedy_max_stralis_1 ');
    tmp.SQL.Add('							begin ');
    tmp.SQL.Add('								if (@sonda_flag <> 1) or (@sonda_flag is null) or ');
    tmp.SQL.Add('										((@sonda_flag = 1) and (@min_stralis_1 <> 0)) ');
    tmp.SQL.Add('								begin ');
    tmp.SQL.Add('									if (@evb3 = 119) and (@kiedy_max_stralis_1 >= @start_prior) ');
    tmp.SQL.Add('										insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, ');
    tmp.SQL.Add('												czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) ');
    tmp.SQL.Add('		--							            values(@kiedy_max_stralis_1, @kiedy_min_stralis_1, ');
    tmp.SQL.Add('												values(@max_skok_czas, @max_skok_czas, ');
    tmp.SQL.Add('												@min_stralis_1 - @max_stralis_1, ');
    tmp.SQL.Add('												@max_stralis_1, @min_stralis_1, ');
    tmp.SQL.Add('												0.0, 0.0, 1, ');
    tmp.SQL.Add('												@max_stralis_pal_1, @min_stralis_pal_1, ');
    tmp.SQL.Add('												0.0, 0.0) ');
    tmp.SQL.Add('									select @max_stralis_1 = @min_stralis_1 ');
    tmp.SQL.Add('									select @max_skok = 0 ');
    tmp.SQL.Add('								end ');
    tmp.SQL.Add('							end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						if (@last_1bak >= @max_stralis_1) ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							if @max_skok < abs(@max_stralis_1 - @last_1bak) ');
    tmp.SQL.Add('							begin ');
    tmp.SQL.Add('								select @max_skok = abs(@max_stralis_1 - @last_1bak) ');
    tmp.SQL.Add('								select @max_skok_czas = @evdata ');
    tmp.SQL.Add('							end ');
    tmp.SQL.Add('							select @kiedy_max_stralis_1 = @evdata ');
    tmp.SQL.Add('							select @max_stralis_1 = @last_1bak ');
    tmp.SQL.Add('							select @max_stralis_pal_1 = @paliwo_pal_1 ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('						else ');
    tmp.SQL.Add('						if (@max_stralis_1 <> 0) and (@min_stralis_1 <> 1000000) ');
    tmp.SQL.Add('							if @kiedy_min_stralis_1 <= @kiedy_max_stralis_1 ');
    tmp.SQL.Add('							begin ');
    tmp.SQL.Add('								if (@sonda_flag <> 1) or (@sonda_flag is null) or ');
    tmp.SQL.Add('										((@sonda_flag = 1) and (@min_stralis_1 <> 0)) ');
    tmp.SQL.Add('								begin ');
    tmp.SQL.Add('									if @kiedy_min_stralis_1 >= @start_prior ');
    tmp.SQL.Add('									begin ');
    tmp.SQL.Add('										insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, ');
    tmp.SQL.Add('											czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) ');
    tmp.SQL.Add('		--                                    values(@kiedy_min_stralis_1, @kiedy_max_stralis_1, ');
    tmp.SQL.Add('											values(@max_skok_czas, @max_skok_czas, ');
    tmp.SQL.Add('											@max_stralis_1 - @min_stralis_1, ');
    tmp.SQL.Add('											@min_stralis_1, @max_stralis_1, 0.0, 0.0, 1, ');
    tmp.SQL.Add('											@min_stralis_pal_1, @max_stralis_pal_1, 0.0, 0.0) ');
    tmp.SQL.Add('									end ');
    tmp.SQL.Add('									select @min_stralis_1 = @max_stralis_1 ');
    tmp.SQL.Add('									select @max_skok = 0 ');
    tmp.SQL.Add('								end ');
    tmp.SQL.Add('							end ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@evb3 = 219) or (@evb3 = 213) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if ((@last_1bak + @last_2bak) <= (@min_stralis_1 + @min_stralis_2)) ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						if @max_skok < abs(@min_stralis_1 - @last_1bak + @min_stralis_2 - @last_2bak) ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							select @max_skok = abs(@min_stralis_1 - @last_1bak + @min_stralis_2 - @last_2bak) ');
    tmp.SQL.Add('							select @max_skok_czas = @evdata ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('						select @kiedy_min_stralis_2 = @evdata ');
    tmp.SQL.Add('						select @kiedy_min_stralis_1 = @evdata ');
    tmp.SQL.Add('						select @min_stralis_2 = @last_2bak ');
    tmp.SQL.Add('						select @min_stralis_pal_2 = @paliwo_pal_2 ');
    tmp.SQL.Add('	   					select @min_stralis_1 = @last_1bak ');
    tmp.SQL.Add('						select @min_stralis_pal_1 = @paliwo_pal_1 ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('					if (@max_stralis_2 <> 0) and (@min_stralis_2 <> 1000000) ');
    tmp.SQL.Add('						if @kiedy_min_stralis_2 > @kiedy_max_stralis_2 ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							if (@sonda_flag <> 1) or (@sonda_flag is null) or ');
    tmp.SQL.Add('								((@sonda_flag = 1) and (@min_stralis_2 <> 0)) ');
    tmp.SQL.Add('							begin ');
    tmp.SQL.Add('								if (@evb3 = 219) and (@kiedy_max_stralis_2 >= @start_prior) ');
    tmp.SQL.Add('									insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, ');
    tmp.SQL.Add('										czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) ');
    tmp.SQL.Add('		--					            values(@kiedy_max_stralis_2, @kiedy_min_stralis_2, ');
    tmp.SQL.Add('										values(@max_skok_czas, @max_skok_czas, ');
    tmp.SQL.Add('										@min_stralis_2 - @max_stralis_2 + ');
    tmp.SQL.Add('										@min_stralis_1 - @max_stralis_1, ');
    tmp.SQL.Add('										@max_stralis_1, @min_stralis_1, ');
    tmp.SQL.Add('										@max_stralis_2, @min_stralis_2, 1, ');
    tmp.SQL.Add('										@max_stralis_pal_1, @min_stralis_pal_1, ');
    tmp.SQL.Add('										@max_stralis_pal_2, @min_stralis_pal_2) ');
    tmp.SQL.Add('								select @max_stralis_1 = @min_stralis_1 ');
    tmp.SQL.Add('								select @max_stralis_2 = @min_stralis_2 ');
    tmp.SQL.Add('								select @max_skok = 0 ');
    tmp.SQL.Add('							end ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					if ((@last_1bak + @last_2bak) >= (@max_stralis_1 + @max_stralis_2)) ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						if @max_skok < abs(@max_stralis_1 - @last_1bak + @max_stralis_2 - @last_2bak) ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							select @max_skok = abs(@max_stralis_1 - @last_1bak + @max_stralis_2 - @last_2bak) ');
    tmp.SQL.Add('							select @max_skok_czas = @evdata ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('						select @kiedy_max_stralis_1 = @evdata ');
    tmp.SQL.Add('						select @kiedy_max_stralis_2 = @evdata ');
    tmp.SQL.Add('						select @max_stralis_1 = @last_1bak ');
    tmp.SQL.Add('						select @max_stralis_pal_1 = @paliwo_pal_1 ');
    tmp.SQL.Add('						select @max_stralis_2 = @last_2bak ');
    tmp.SQL.Add('						select @max_stralis_pal_2 = @paliwo_pal_2 ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('					if (@max_stralis_2 <> 0) and (@min_stralis_2 <> 1000000) ');
    tmp.SQL.Add('						if @kiedy_min_stralis_2 <= @kiedy_max_stralis_2 ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							if (@sonda_flag <> 1) or (@sonda_flag is null) or ');
    tmp.SQL.Add('									((@sonda_flag = 1) and (@min_stralis_2 <> 0)) ');
    tmp.SQL.Add('							   if @kiedy_min_stralis_2 >= @start_prior ');
    tmp.SQL.Add('								begin ');
    tmp.SQL.Add('									insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, ');
    tmp.SQL.Add('										czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) ');
    tmp.SQL.Add('		--								values(@kiedy_min_stralis_2, @kiedy_max_stralis_2, ');
    tmp.SQL.Add('										values(@max_skok_czas, @max_skok_czas, ');
    tmp.SQL.Add('										@max_stralis_2 - @min_stralis_2 + ');
    tmp.SQL.Add('										@max_stralis_1 - @min_stralis_1, ');
    tmp.SQL.Add('										@min_stralis_1, @max_stralis_1, ');
    tmp.SQL.Add('										@min_stralis_2, @max_stralis_2, 1, ');
    tmp.SQL.Add('										@min_stralis_pal_1, @max_stralis_pal_1, ');
    tmp.SQL.Add('										@min_stralis_pal_2, @max_stralis_pal_2) ');
    tmp.SQL.Add('									select @min_stralis_1 = @max_stralis_1 ');
    tmp.SQL.Add('									select @min_stralis_2 = @max_stralis_2 ');
    tmp.SQL.Add('									select @max_skok = 0 ');
    tmp.SQL.Add('								end ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@evb3 = 85) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if @evdata >= @start ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						execute spDroga @carno, @evb9, @evb10, @przyrost_droga OUTPUT ');
    tmp.SQL.Add('						select @jalowy = @jalowy + cast((@evb1 * 256 + @evb4) / 60 as integer) ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@evb3 = 10) ');
    tmp.SQL.Add('					select @kiedy10 = @evdata ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@evb3 = 49) or (@evb3 = 115) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if @car_type = 1 ');
    tmp.SQL.Add('						if @kiedy10 is not null ');
    tmp.SQL.Add('							if @evdata >= @start ');
    tmp.SQL.Add('								select @motogodziny = @motogodziny - ');
    tmp.SQL.Add('										(cast((@evdata - @kiedy10) as numeric(10, 6)) * 86400) ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@evb3 = 49) or (@evb3 = 115) or (@evb3 = 10) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					insert into #paliwo85(dataczas, zb1, zb2) values(@evdata, @last_1bak, @last_2bak) ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@evb3 = 15) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, ');
    tmp.SQL.Add('						czy_dynamiczny, was_15, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) values(@evdata, ');
    tmp.SQL.Add('						@evdata, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 0, 0) ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				set @licznik_rec = @licznik_rec + 1 ');
    tmp.SQL.Add('				if (@licznik_rec % 10 = 0) ');
    tmp.SQL.Add('					exec sp_progress_set @id_progress, @licznik_rec, @num_records, @canceled output; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				fetch zdarzenia_cr into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, ');
    tmp.SQL.Add('						@evb8, @evb9, @evb10, @evdata, @zb1, @zb2 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			close zdarzenia_cr ');
    tmp.SQL.Add('			deallocate zdarzenia_cr ');
    tmp.SQL.Add('			if ((@sonda_flag <> 3) or (@sonda_flag is null)) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				if (@czy_w_czasie_jazdy = 0) ');
    tmp.SQL.Add('					if (@max_stralis_1 <> 0) and (@min_stralis_1 <> 1000000) ');
    tmp.SQL.Add('						if @kiedy_min_stralis_1 > @kiedy_max_stralis_1 ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							if (@sonda_flag <> 1) or (@sonda_flag is null) or ');
    tmp.SQL.Add('										((@sonda_flag = 1) and (@min_stralis_1 <> 0)) ');
    tmp.SQL.Add('							begin ');
    tmp.SQL.Add('								if @kiedy_max_stralis_1 >= @start_prior ');
    tmp.SQL.Add('											  insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, ');
    tmp.SQL.Add('													 czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) ');
    tmp.SQL.Add('		--							                 values(@kiedy_max_stralis_1, @kiedy_min_stralis_1, ');
    tmp.SQL.Add('													 values(@max_skok_czas, @max_skok_czas, ');
    tmp.SQL.Add('														 @min_stralis_1 - @max_stralis_1, ');
    tmp.SQL.Add('														 @max_stralis_1, @min_stralis_1, ');
    tmp.SQL.Add('														 0.0, 0.0, 1, ');
    tmp.SQL.Add('														 @max_stralis_pal_1, @min_stralis_pal_1, ');
    tmp.SQL.Add('														 0.0, 0.0) ');
    tmp.SQL.Add('								select @max_stralis_1 = 0 ');
    tmp.SQL.Add('								select @max_skok = 0 ');
    tmp.SQL.Add('							end ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@max_stralis_1 <> 0) and (@min_stralis_1 <> 1000000) ');
    tmp.SQL.Add('					if @kiedy_min_stralis_1 <= @kiedy_max_stralis_1 ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						if (@sonda_flag <> 1) or (@sonda_flag is null) or ');
    tmp.SQL.Add('										((@sonda_flag = 1) and (@min_stralis_1 <> 0)) ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							if @kiedy_min_stralis_1 >= @start_prior ');
    tmp.SQL.Add('								insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, ');
    tmp.SQL.Add('											czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) ');
    tmp.SQL.Add('		--                                    values(@kiedy_min_stralis_1, @kiedy_max_stralis_1, ');
    tmp.SQL.Add('											values(@max_skok_czas, @max_skok_czas, ');
    tmp.SQL.Add('											@max_stralis_1 - @min_stralis_1, ');
    tmp.SQL.Add('											@min_stralis_1, @max_stralis_1, 0.0, 0.0, 1, ');
    tmp.SQL.Add('											@min_stralis_pal_1, @max_stralis_pal_1, 0.0, 0.0) ');
    tmp.SQL.Add('							select @min_stralis_1 = 1000000 ');
    tmp.SQL.Add('							select @max_skok = 0 ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			else ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				if (@czy_w_czasie_jazdy = 0) ');
    tmp.SQL.Add('					if (@max_stralis_2 <> 0) and (@min_stralis_2 <> 1000000) ');
    tmp.SQL.Add('						if @kiedy_min_stralis_2 > @kiedy_max_stralis_2 ');
    tmp.SQL.Add('								 begin ');
    tmp.SQL.Add('							 if (@sonda_flag <> 1) or (@sonda_flag is null) or ');
    tmp.SQL.Add('											   ((@sonda_flag = 1) and (@min_stralis_2 <> 0)) ');
    tmp.SQL.Add('									   begin ');
    tmp.SQL.Add('								 if @kiedy_max_stralis_2 >= @start_prior ');
    tmp.SQL.Add('											 insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, ');
    tmp.SQL.Add('												   czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) ');
    tmp.SQL.Add('		--					                       values(@kiedy_max_stralis_2, @kiedy_min_stralis_2, ');
    tmp.SQL.Add('												   values(@max_skok_czas, @max_skok_czas, ');
    tmp.SQL.Add('													   @min_stralis_2 - @max_stralis_2 + ');
    tmp.SQL.Add('								                		 @min_stralis_1 - @max_stralis_1, ');
    tmp.SQL.Add('														 @max_stralis_1, @min_stralis_1, ');
    tmp.SQL.Add('														 @max_stralis_2, @min_stralis_2, 1, ');
    tmp.SQL.Add('														 @max_stralis_pal_1, @min_stralis_pal_1, ');
    tmp.SQL.Add('														 @max_stralis_pal_2, @min_stralis_pal_2) ');
    tmp.SQL.Add('								 select @max_stralis_1 = 0 ');
    tmp.SQL.Add('								 select @max_stralis_2 = 0 ');
    tmp.SQL.Add('	 							 select @max_skok = 0 ');
    tmp.SQL.Add('							 end ');
    tmp.SQL.Add('						 end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@max_stralis_2 <> 0) and (@min_stralis_2 <> 1000000) ');
    tmp.SQL.Add('					if @kiedy_min_stralis_2 <= @kiedy_max_stralis_2 ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						if (@sonda_flag <> 1) or (@sonda_flag is null) or ');
    tmp.SQL.Add('									((@sonda_flag = 1) and (@min_stralis_2 <> 0)) ');
    tmp.SQL.Add('							if @kiedy_min_stralis_2 >= @start_prior ');
    tmp.SQL.Add('											  insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, ');
    tmp.SQL.Add('							            			czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) ');
    tmp.SQL.Add('		--						            		values(@kiedy_min_stralis_2, @kiedy_max_stralis_2, ');
    tmp.SQL.Add('							            			values(@max_skok_czas, @max_skok_czas, ');
    tmp.SQL.Add('													@max_stralis_2 - @min_stralis_2 + ');
    tmp.SQL.Add('								            		@max_stralis_1 - @min_stralis_1, ');
    tmp.SQL.Add('													@min_stralis_1, @max_stralis_1, ');
    tmp.SQL.Add('													@min_stralis_2, @max_stralis_2, 1, ');
    tmp.SQL.Add('													@min_stralis_pal_1, @max_stralis_pal_1, ');
    tmp.SQL.Add('													@min_stralis_pal_2, @max_stralis_pal_2) ');
    tmp.SQL.Add('							select @min_stralis_1 = 1000000 ');
    tmp.SQL.Add('							select @min_stralis_2 = 1000000 ');
    tmp.SQL.Add('							select @max_skok = 0 ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			select @jalowy = @jalowy * 60 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			drop table #aproksymacja_params ');
    tmp.SQL.Add('			drop table #aproksymacja ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare tankowania_cr cursor ');
    tmp.SQL.Add('					for select id, _117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, ');
    tmp.SQL.Add('							was_15, czy_dynamiczny from #paliwo_wynik ');
    tmp.SQL.Add('					order by id ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			open tankowania_cr ');
    tmp.SQL.Add('			fetch tankowania_cr into @id, @_117, @_118, @sonda, @from_sonda, @to_sonda, @from_sonda2, @to_sonda2, ');
    tmp.SQL.Add('							@was_15, @czy_dynamiczny ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @id1 integer ');
    tmp.SQL.Add('			declare @id2 integer ');
    tmp.SQL.Add('			declare @id3 integer ');
    tmp.SQL.Add('			declare @sonda1 numeric(10, 3) ');
    tmp.SQL.Add('			declare @sonda2 numeric(10, 3) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			while (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				if (@was_15 is not null) and (@was_15 = 1) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					select @id1 = @id ');
    tmp.SQL.Add('					while (@@fetch_status <> -1) and (@was_15 is not null) and (@was_15 = 1) and (@canceled = 0) ');
    tmp.SQL.Add('						fetch tankowania_cr into @id, @_117, @_118, @sonda, @from_sonda, @to_sonda, @from_sonda2, @to_sonda2, ');
    tmp.SQL.Add('							@was_15, @czy_dynamiczny ');
    tmp.SQL.Add('					if (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						select @id2 = @id ');
    tmp.SQL.Add('						if (@sonda < 0.0) and (@to_sonda < 10.0) ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							select @sonda1 = @sonda ');
    tmp.SQL.Add('							fetch tankowania_cr into @id, @_117, @_118, @sonda, @from_sonda, @to_sonda, @from_sonda2, @to_sonda2, ');
    tmp.SQL.Add('								@was_15, @czy_dynamiczny ');
    tmp.SQL.Add('							while (@@fetch_status <> -1) and (@was_15 is not null) and (@was_15 = 1) and (@canceled = 0) ');
    tmp.SQL.Add('								fetch tankowania_cr into @id, @_117, @_118, @sonda, @from_sonda, @to_sonda, @from_sonda2, @to_sonda2, ');
    tmp.SQL.Add('									@was_15, @czy_dynamiczny ');
    tmp.SQL.Add('							if (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('							begin ');
    tmp.SQL.Add('								select @id3 = @id ');
    tmp.SQL.Add('								if (@sonda > 0.0) and (@from_sonda < 10.0) ');
    tmp.SQL.Add('								begin ');
    tmp.SQL.Add('									select @sonda2 = @sonda ');
    tmp.SQL.Add('									close tankowania_cr ');
    tmp.SQL.Add('									delete from #paliwo_wynik where id = @id1 ');
    tmp.SQL.Add('									delete from #paliwo_wynik where id = @id3 ');
    tmp.SQL.Add('									update #paliwo_wynik set sonda = @sonda1 + @sonda2, czy_dynamiczny = 15 where id = @id2 ');
    tmp.SQL.Add('									open tankowania_cr ');
    tmp.SQL.Add('								end ');
    tmp.SQL.Add('							end ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				fetch tankowania_cr into @id, @_117, @_118, @sonda, @from_sonda, @to_sonda, @from_sonda2, @to_sonda2, ');
    tmp.SQL.Add('							@was_15, @czy_dynamiczny ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			close tankowania_cr ');
    tmp.SQL.Add('			deallocate tankowania_cr ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	 		declare @id_w integer ');
    tmp.SQL.Add('			declare @car_no_w integer ');
    tmp.SQL.Add('			declare @dataczas_w datetime ');
    tmp.SQL.Add('			declare @ilosc_w numeric(10, 3) ');
    tmp.SQL.Add('			declare wyjatki_cr cursor ');
    tmp.SQL.Add('				for select id, car_no, dataczas, ilosc from paliwo_wyjatki ');
    tmp.SQL.Add('				where car_no = @carno and ');
    tmp.SQL.Add('				dataczas >= @start and dataczas <= @stop ');
    tmp.SQL.Add('				order by id ');
    tmp.SQL.Add('			open wyjatki_cr ');
    tmp.SQL.Add('			fetch wyjatki_cr into @id_w, @car_no_w, @dataczas_w, @ilosc_w ');
    tmp.SQL.Add('		  while (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				delete from #paliwo_wynik where sonda = @ilosc_w and _117 = @dataczas_w ');
    tmp.SQL.Add('				fetch wyjatki_cr into @id_w, @car_no_w, @dataczas_w, @ilosc_w ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('		  close wyjatki_cr ');
    tmp.SQL.Add('		  deallocate wyjatki_cr ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		  if @nested = 0 ');
    tmp.SQL.Add('			 exec sp_progress_unregister @id_progress; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		  if @nested = 1 ');
    tmp.SQL.Add('		  begin ');
    tmp.SQL.Add('			delete from #paliwo_wynik2 ');
    tmp.SQL.Add('			insert into #paliwo_wynik2(_117, _118, sonda, from_sonda, ');
    tmp.SQL.Add('				from_sonda_pal, to_sonda, to_sonda_pal, from_sonda2, ');
    tmp.SQL.Add('				from_sonda2_pal, to_sonda2, to_sonda2_pal, ');
    tmp.SQL.Add('				was_15, czy_dynamiczny) ');
    tmp.SQL.Add('			  select _117, _118, sonda, from_sonda, ');
    tmp.SQL.Add('				from_sonda_pal, to_sonda, to_sonda_pal, from_sonda2, ');
    tmp.SQL.Add('				from_sonda2_pal, to_sonda2, to_sonda2_pal, ');
    tmp.SQL.Add('				was_15, czy_dynamiczny from #paliwo_wynik order by id ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare czas_pracy_cr cursor for ');
    tmp.SQL.Add('			select id, start_praca, stop_praca, przebieg from #eksport_day_work ');
    tmp.SQL.Add('			order by id ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @start_praca_pr datetime ');
    tmp.SQL.Add('			declare @stop_praca_pr datetime ');
    tmp.SQL.Add('			declare @id_pr integer ');
    tmp.SQL.Add('			declare @first_bak1_pr numeric(10, 3) ');
    tmp.SQL.Add('			declare @first_bak2_pr numeric(10, 3) ');
    tmp.SQL.Add('			declare @last_bak1_pr numeric(10, 3) ');
    tmp.SQL.Add('			declare @last_bak2_pr numeric(10, 3) ');
    tmp.SQL.Add('			declare @tank_sum numeric(10, 3) ');
    tmp.SQL.Add('			declare @ZuzycieSum numeric(10, 3) ');
    tmp.SQL.Add('			declare @droga_pr numeric(10, 3) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			open czas_pracy_cr ');
    tmp.SQL.Add('			fetch czas_pracy_cr into @id_pr, @start_praca_pr, @stop_praca_pr, @droga_pr ');
    tmp.SQL.Add('			while (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				select @first_bak1_pr = zb1 from #paliwo85 where dataczas = @start_praca_pr ');
    tmp.SQL.Add('				select @first_bak2_pr = zb2 from #paliwo85 where dataczas = @start_praca_pr ');
    tmp.SQL.Add('				select @last_bak1_pr = zb1 from #paliwo85 where dataczas = @stop_praca_pr ');
    tmp.SQL.Add('				select @last_bak2_pr = zb2 from #paliwo85 where dataczas = @stop_praca_pr ');
    tmp.SQL.Add('				select @tank_sum = sum(sonda) from #paliwo_wynik where _117 >= @start_praca_pr and _118 <= @stop_praca_pr ');
    tmp.SQL.Add('					and ((sonda >= @min_tank) or (sonda <= (-@min_ubytk))) ');
    tmp.SQL.Add('				set @tank_sum = isnull(@tank_sum, 0.0) ');
    tmp.SQL.Add('				if (@first_bak1_pr is not null) and (@first_bak2_pr is not null) and ');
    tmp.SQL.Add('				   (@last_bak1_pr is not null) and (@last_bak2_pr is not null) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					set @ZuzycieSum = @first_bak1_pr + @first_bak2_pr + @tank_sum - @last_bak1_pr - @last_bak2_pr ');
    tmp.SQL.Add('					if @motogodziny >= 0 ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						if @droga_pr > 0 ');
    tmp.SQL.Add('							update #eksport_day_work set srednio = cast((@ZuzycieSum / @droga_pr * 100) * 10 + 0.5 as integer) / 10.0 where id = @id_pr ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						if DATEDIFF(minute, @start_praca_pr, @stop_praca_pr) > 0 ');
    tmp.SQL.Add('							update #eksport_day_work set srednio = cast((@ZuzycieSum / (cast(DATEDIFF(minute, @start_praca_pr, @stop_praca_pr) as numeric(10, 1)) / 60.0)) * 10 + 0.5 as integer) / 10.0 where id = @id_pr ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				fetch czas_pracy_cr into @id_pr, @start_praca_pr, @stop_praca_pr, @droga_pr ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			close czas_pracy_cr ');
    tmp.SQL.Add('			deallocate czas_pracy_cr ');
    tmp.SQL.Add('		  end ');
//    tmp.SQL.Add('		  else ');
//    tmp.SQL.Add('		  begin ');
//    tmp.SQL.Add('			if @no_cache = 0 and @nested = 0 ');
//    tmp.SQL.Add('			INSERT INTO cache_refueling ');
//    tmp.SQL.Add('	           (id_car,_117,_118,sonda,from_sonda,from_sonda_pal,to_sonda,to_sonda_pal ');
//    tmp.SQL.Add('					,from_sonda2,from_sonda2_pal,to_sonda2,to_sonda2_pal ');
//    tmp.SQL.Add('					,was_15,czy_dynamiczny,first_event_datetime,last_event_datetime) ');
//    tmp.SQL.Add('	        select @carno,_117,_118,sonda,from_sonda,from_sonda_pal,to_sonda,to_sonda_pal ');
//    tmp.SQL.Add('					,from_sonda2,from_sonda2_pal,to_sonda2,to_sonda2_pal ');
//    tmp.SQL.Add('					,was_15,czy_dynamiczny, ');
//    tmp.SQL.Add('					@first_event_datetime_db, ');
//    tmp.SQL.Add('					@last_event_datetime_db ');
//    tmp.SQL.Add('			from #paliwo_wynik ');
//    tmp.SQL.Add('			where ((sonda >= @min_tank) or (sonda <= (-@min_ubytk))) and (_117 >= @start_prior) and (_118 >= @start_prior) ');
//    tmp.SQL.Add('			order by _117, sign(sonda), czy_dynamiczny ');
//    tmp.SQL.Add('		  end ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add('		if @nested = 0 or @nested is null ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('		  if @no_cache = 0 ');
    tmp.SQL.Add('			  select sonda tankowanie, _117 poczatek, _118 koniec, _117 _113, from_sonda, to_sonda, from_sonda2, to_sonda2, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal, ');
    tmp.SQL.Add('								czy_dynamiczny, sign(sonda) znak from cache_refueling ');
    tmp.SQL.Add('				  where ((sonda >= @min_tank) or (sonda <= (-@min_ubytk))) and (_117 >= @start) and (_118 >= @start) and (_118 <= @stop) ');
    tmp.SQL.Add('				  and id_car = @carno ');
    tmp.SQL.Add('				  order by first_event_datetime, _117, sign(sonda), czy_dynamiczny ');
    tmp.SQL.Add('		  else ');
    tmp.SQL.Add('			  select sonda tankowanie, _117 poczatek, _118 koniec, _117 _113, from_sonda, to_sonda, from_sonda2, to_sonda2, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal, ');
    tmp.SQL.Add('								czy_dynamiczny, sign(sonda) znak from #paliwo_wynik ');
    tmp.SQL.Add('				  where ((sonda >= @min_tank) or (sonda <= (-@min_ubytk))) and (_117 >= @start) and (_118 >= @start) ');
    tmp.SQL.Add('				  order by _117, sign(sonda), czy_dynamiczny ');
    tmp.SQL.Add('		end ');
    tmp.ExecSQL();
end;

procedure TTEDEmailSrv.UaktualnijProcedureCzasuPracy();
begin
    tmp.SQL.Clear();
    tmp.SQL.Add('	ALTER procedure [dbo].[sp_day_work] ');
    tmp.SQL.Add('	    @isInCarMode integer, ');
    tmp.SQL.Add('	    @car_or_driver_no integer, ');
    tmp.SQL.Add('	    @start datetime, ');
    tmp.SQL.Add('	    @stop datetime, ');
    tmp.SQL.Add('	    @id_progress bigint, ');
    tmp.SQL.Add('		@calculate_fuel integer = 0, ');
    tmp.SQL.Add('		@show_only_last_day_route integer = 0, ');
    tmp.SQL.Add('		@DoNotShowEmptyTracks integer = 0, ');
    tmp.SQL.Add('	   	@with_gps integer = 0, ');
    tmp.SQL.Add('		@kosztPaliwa numeric(10, 3) = 0.0, ');
    tmp.SQL.Add('		@no_cache integer = 1 ');
    tmp.SQL.Add('	as ');
    tmp.SQL.Add('		declare @DoNotShowEmptyTracks2 integer ');
    tmp.SQL.Add('		set @DoNotShowEmptyTracks2 = @DoNotShowEmptyTracks ');
    tmp.SQL.Add('		declare @car_or_driver_no2 integer ');
    tmp.SQL.Add('		declare @start2 datetime ');
    tmp.SQL.Add('		declare @stop2 datetime ');
    tmp.SQL.Add('	    declare @stan integer ');
    tmp.SQL.Add('	    declare @tmp integer ');
    tmp.SQL.Add('	    declare @tmp2 integer ');
    tmp.SQL.Add('	    declare @tmp3 integer ');
    tmp.SQL.Add('	    declare @i integer ');
    tmp.SQL.Add('	    declare @roznica datetime ');
    tmp.SQL.Add('	    declare @czas_10 datetime ');
    tmp.SQL.Add('	    declare @car_no integer ');
    tmp.SQL.Add('	    declare @last_kierowca varchar(200) ');
    tmp.SQL.Add('	    declare @last_lastkierowca varchar(200) ');
    tmp.SQL.Add('		declare @last_kierowca123 varchar(200) ');
    tmp.SQL.Add('	    declare @last_groupid integer ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @id integer ');
    tmp.SQL.Add('	    declare @evb1 integer ');
    tmp.SQL.Add('	    declare @evb2 integer ');
    tmp.SQL.Add('	    declare @evb3 integer ');
    tmp.SQL.Add('	    declare @evb4 integer ');
    tmp.SQL.Add('	    declare @evb5 integer ');
    tmp.SQL.Add('	    declare @evb6 integer ');
    tmp.SQL.Add('	    declare @evb7 integer ');
    tmp.SQL.Add('	    declare @evb8 integer ');
    tmp.SQL.Add('	    declare @evb9 integer ');
    tmp.SQL.Add('	    declare @evb10 integer ');
    tmp.SQL.Add('	    declare @evdata datetime ');
    tmp.SQL.Add('	    declare @rej_numb2 varchar(200) ');
    tmp.SQL.Add('	    declare @name2 varchar(200) ');
    tmp.SQL.Add('	    declare @car_no2 integer ');
    tmp.SQL.Add('	    declare @kierowca2 varchar(200) ');
    tmp.SQL.Add('	    declare @car_type2 integer ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @tmpdatetime datetime ');
    tmp.SQL.Add('	    declare @tmpdatetime2 datetime ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @first_event_datetime_db datetime ');
    tmp.SQL.Add('	    declare @last_event_datetime_db datetime ');
    tmp.SQL.Add('	    declare @first_event_datetime_cache datetime ');
    tmp.SQL.Add('	    declare @last_event_datetime_cache datetime ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @przesuniecie integer ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @tmpnumeric numeric(10, 3) ');
    tmp.SQL.Add('	    declare @tmpinteger integer ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    declare @start_praca_tmp datetime ');
    tmp.SQL.Add('	    declare @stop_praca_tmp datetime ');
    tmp.SQL.Add('	    declare @start_postoj_tmp datetime ');
    tmp.SQL.Add('	    declare @stop_postoj_tmp datetime ');
    tmp.SQL.Add('	    declare @old_droga_tmp numeric(10, 3) ');
    tmp.SQL.Add('	    declare @old_jalowy_tmp numeric(10, 3) ');
    tmp.SQL.Add('	    declare @jalowy_tmp numeric(10, 3) ');
    tmp.SQL.Add('	    declare @droga_tmp numeric(10, 3) ');
    tmp.SQL.Add('	    declare @ile_postoj_tmp varchar(20) ');
    tmp.SQL.Add('	    declare @ile_praca_tmp varchar(20) ');
    tmp.SQL.Add('	    declare @ile_jalowy_tmp varchar(20) ');
    tmp.SQL.Add('	    declare @dzien varchar(5) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		declare @szerokosc varchar(30) ');
    tmp.SQL.Add('		declare @dlugosc varchar(30) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		declare @szerokosc0 varchar(30) ');
    tmp.SQL.Add('		declare @dlugosc0 varchar(30) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		declare @obroty numeric(10, 3) ');
    tmp.SQL.Add('		declare @obroty_count integer ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		declare @srednio numeric(10, 3) ');
    tmp.SQL.Add('		DECLARE	@first_1bak numeric(10, 3), ');
    tmp.SQL.Add('				@last_1bak numeric(10, 3), ');
    tmp.SQL.Add('				@first_2bak numeric(10, 3), ');
    tmp.SQL.Add('				@last_2bak numeric(10, 3), ');
    tmp.SQL.Add('				@droga123 numeric(10, 3), ');
    tmp.SQL.Add('				@jalowy int, ');
    tmp.SQL.Add('				@motogodziny int ');
    tmp.SQL.Add('		declare @sonda_all_tank numeric(10, 3) ');
    tmp.SQL.Add('		declare @ZuzycieSum numeric(10, 3) ');
    tmp.SQL.Add('		declare @sonda numeric(10, 3) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		set @szerokosc0 = null ');
    tmp.SQL.Add('		set @dlugosc0 = null ');
    tmp.SQL.Add('		set @szerokosc = null ');
    tmp.SQL.Add('		set @dlugosc = null ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    create table #eksport_day_work ');
    tmp.SQL.Add('	    ( ');
    tmp.SQL.Add('	        id integer not null identity (1,1), ');
    tmp.SQL.Add('			evb2 integer, ');
    tmp.SQL.Add('	        dzien varchar(5), ');
    tmp.SQL.Add('	        data datetime, ');
    tmp.SQL.Add('	        week integer, ');
    tmp.SQL.Add('	        month integer, ');
    tmp.SQL.Add('	        przebieg numeric(10, 3), ');
    tmp.SQL.Add('	        opis varchar(200), ');
    tmp.SQL.Add('	        ile_praca varchar(20), ');
    tmp.SQL.Add('	        ile_praca_sek integer, ');
    tmp.SQL.Add('	        ile_postoj varchar(20), ');
    tmp.SQL.Add('	        ile_postoj_sek integer, ');
    tmp.SQL.Add('	        ile_jalowy varchar(20), ');
    tmp.SQL.Add('	        ile_jalowy_sek integer, ');
    tmp.SQL.Add('	        marka_pojazdu varchar(250), ');
    tmp.SQL.Add('	        nr_rej_pojazdu varchar(200), ');
    tmp.SQL.Add('	        kierowca varchar(100), ');
    tmp.SQL.Add('	        start_praca datetime, ');
    tmp.SQL.Add('	        stop_praca datetime, ');
    tmp.SQL.Add('	        start_postoj datetime, ');
    tmp.SQL.Add('	        stop_postoj datetime, ');
    tmp.SQL.Add('			summary_przebieg_day numeric(10, 3), ');
    tmp.SQL.Add('			summary_przebieg_week numeric(10, 3), ');
    tmp.SQL.Add('			summary_przebieg_month numeric(10, 3), ');
    tmp.SQL.Add('			summary_przebieg_all numeric(10, 3), ');
    tmp.SQL.Add('			summary_praca_day varchar(20), ');
    tmp.SQL.Add('			summary_praca_week varchar(20), ');
    tmp.SQL.Add('			summary_praca_month varchar(20), ');
    tmp.SQL.Add('			summary_praca_all varchar(20), ');
    tmp.SQL.Add('			summary_postoj_day varchar(20), ');
    tmp.SQL.Add('			summary_postoj_week varchar(20), ');
    tmp.SQL.Add('			summary_postoj_month varchar(20), ');
    tmp.SQL.Add('			summary_postoj_all varchar(20), ');
    tmp.SQL.Add('			summary_jalowy_day varchar(20), ');
    tmp.SQL.Add('			summary_jalowy_week varchar(20), ');
    tmp.SQL.Add('			summary_jalowy_month varchar(20), ');
    tmp.SQL.Add('			summary_jalowy_all varchar(20), ');
    tmp.SQL.Add('			summary_paliwo_sum numeric(10, 3), ');
    tmp.SQL.Add('			summary_paliwo_srednio numeric(10, 3), ');
    tmp.SQL.Add('			summary_paliwo_koszt numeric(10, 2), ');
    tmp.SQL.Add('			summary_motogodziny_day numeric(10, 3), ');
    tmp.SQL.Add('			summary_motogodziny_week numeric(10, 3), ');
    tmp.SQL.Add('			summary_motogodziny_month numeric(10, 3), ');
    tmp.SQL.Add('			summary_motogodziny_all numeric(10, 3), ');
    tmp.SQL.Add('	        group_id integer, ');
    tmp.SQL.Add('			ulica_start varchar(50), ');
    tmp.SQL.Add('			ulica_stop varchar(50), ');
    tmp.SQL.Add('			szerokosc0 varchar(30), ');
    tmp.SQL.Add('			dlugosc0 varchar(30), ');
    tmp.SQL.Add('			szerokosc varchar(30), ');
    tmp.SQL.Add('			dlugosc varchar(30), ');
    tmp.SQL.Add('			srednio numeric(10, 1), ');
    tmp.SQL.Add('			first_event_datetime datetime, ');
    tmp.SQL.Add('			last_event_datetime datetime, ');
    tmp.SQL.Add('			srednie_obroty numeric(10, 3), ');
    tmp.SQL.Add('			motogodziny numeric(10, 3), ');
    tmp.SQL.Add('			count122 integer, ');
    tmp.SQL.Add('	        primary key(id) ');
    tmp.SQL.Add('	    ); ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    create table #paliwo_wynik2 ');
    tmp.SQL.Add('	    ( ');
    tmp.SQL.Add('	        id integer not null identity(1, 1), ');
    tmp.SQL.Add('	        _117 datetime, ');
    tmp.SQL.Add('	        _118 datetime, ');
    tmp.SQL.Add('	        sonda numeric(10, 3), ');
    tmp.SQL.Add('	        from_sonda numeric(10, 3), ');
    tmp.SQL.Add('	        from_sonda_pal numeric(10, 3), ');
    tmp.SQL.Add('	        to_sonda numeric(10, 3), ');
    tmp.SQL.Add('	        to_sonda_pal numeric(10, 3), ');
    tmp.SQL.Add('	        from_sonda2 numeric(10, 3), ');
    tmp.SQL.Add('	        from_sonda2_pal numeric(10, 3), ');
    tmp.SQL.Add('	        to_sonda2 numeric(10, 3), ');
    tmp.SQL.Add('	        to_sonda2_pal numeric(10, 3), ');
    tmp.SQL.Add('	        was_15 integer, ');
    tmp.SQL.Add('	        czy_dynamiczny integer, ');
    tmp.SQL.Add('	        primary key(id) ');
    tmp.SQL.Add('	    ) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    create index eksport_day_work_index on ');
    tmp.SQL.Add('	        #eksport_day_work(evb2, dzien, week, month, group_id) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	--	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[#zmienne]'') AND type in (N''U'')) ');
    tmp.SQL.Add('	--		DROP TABLE [dbo].[#zmienne] ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    create table #zmienne ');
    tmp.SQL.Add('	    ( ');
    tmp.SQL.Add('	        id integer not null identity (1,1), ');
    tmp.SQL.Add('	        car_no integer, ');
    tmp.SQL.Add('	        last85 datetime, ');
    tmp.SQL.Add('	        last49_115 datetime, ');
    tmp.SQL.Add('	        start_praca datetime, ');
    tmp.SQL.Add('	        stop_praca datetime, ');
    tmp.SQL.Add('	        start_postoj datetime, ');
    tmp.SQL.Add('	        stop_postoj datetime, ');
    tmp.SQL.Add('	        last_last85 datetime, ');
    tmp.SQL.Add('	        last_last49_115 datetime, ');
    tmp.SQL.Add('	        old_droga numeric(10, 3), ');
    tmp.SQL.Add('	        droga numeric(10, 3), ');
    tmp.SQL.Add('	        jalowy integer, ');
    tmp.SQL.Add('	        old_jalowy integer, ');
    tmp.SQL.Add('	        tmp_jalowy integer, ');
    tmp.SQL.Add('			first_event_datetime_db datetime, ');
    tmp.SQL.Add('			last_event_datetime_db datetime, ');
    tmp.SQL.Add('			first_event_datetime_cache datetime, ');
    tmp.SQL.Add('			last_event_datetime_cache datetime, ');
    tmp.SQL.Add('			obroty numeric(10, 3), ');
    tmp.SQL.Add('			obroty_count integer, ');
    tmp.SQL.Add('			old_obroty numeric(10, 3), ');
    tmp.SQL.Add('			old_obroty_count integer, ');
    tmp.SQL.Add('			count122 integer, ');
    tmp.SQL.Add('			old_count122 integer, ');
    tmp.SQL.Add('			primary key(id) ');
    tmp.SQL.Add('	    ); ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		set @start2 = DATEADD(month, -1, @start) ');
    tmp.SQL.Add('		set @stop2 = DATEADD(month, 1, @stop) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		if @car_or_driver_no <> 0 ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			if @isInCarMode = 1 ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				declare zdarzenia_cr2 cursor ');
    tmp.SQL.Add('				for select t1.evb2, min(t1.date), max(t1.date) ');
    tmp.SQL.Add('					from device_data t1 ');
    tmp.SQL.Add('					left join car_change t2 ');
    tmp.SQL.Add('						on (t1.evb2 = t2.id_car and t1.date >= t2.start_date ');
    tmp.SQL.Add('							   and (t1.date <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('					left join driver t3 ');
    tmp.SQL.Add('						on (t3.id_driver = t2.id_driver) ');
    tmp.SQL.Add('					left join car t4 ');
    tmp.SQL.Add('						on (t1.evb2 = t4.id_car) ');
    tmp.SQL.Add('					where t1.evb2 = @car_or_driver_no and t1.date >= @start2 and t1.date <= @stop2 ');
    tmp.SQL.Add('					and (t1.evb3 = 115 or t1.evb3 = 49 or ');
    tmp.SQL.Add('							t1.evb3 = 10 or t1.evb3 = 15 or t1.evb3 = 122) ');
    tmp.SQL.Add('					group by t1.evb2 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			else ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				declare zdarzenia_cr2 cursor ');
    tmp.SQL.Add('				for select t1.evb2, min(t1.date), max(t1.date) ');
    tmp.SQL.Add('					from device_data t1 inner join car_change t2 ');
    tmp.SQL.Add('						on (t1.evb2 = t2.id_car and t1.date >= t2.start_date ');
    tmp.SQL.Add('									   and (t1.date <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('					inner join car t3 on (t2.id_car = t3.id_car) ');
    tmp.SQL.Add('					left join driver t4 on (t2.id_driver = t4.id_driver) ');
    tmp.SQL.Add('					where t2.id_driver = @car_or_driver_no and t1.date >= @start2 ');
    tmp.SQL.Add('						 and t1.date <= @stop2 ');
    tmp.SQL.Add('						and (evb3 = 115 or evb3 = 49 or evb3 = 10 ');
    tmp.SQL.Add('								 or evb3 = 15 or evb3 = 122) ');
    tmp.SQL.Add('					group by t1.evb2 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			if @isInCarMode = 1 ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				declare zdarzenia_cr2 cursor ');
    tmp.SQL.Add('				for select t1.evb2, min(t1.date), max(t1.date) ');
    tmp.SQL.Add('					from device_data t1 ');
    tmp.SQL.Add('					left join car_change t2 ');
    tmp.SQL.Add('						on (t1.evb2 = t2.id_car and t1.date >= t2.start_date ');
    tmp.SQL.Add('							   and (t1.date <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('					left join driver t3 ');
    tmp.SQL.Add('						on (t3.id_driver = t2.id_driver) ');
    tmp.SQL.Add('					left join car t4 on (t1.evb2 = t4.id_car) ');
    tmp.SQL.Add('					where t1.date >= @start2 and t1.date <= @stop2 ');
    tmp.SQL.Add('					and (t1.evb3 = 115 or t1.evb3 = 49 or ');
    tmp.SQL.Add('							t1.evb3 = 10 or t1.evb3 = 15 or t1.evb3 = 122) ');
    tmp.SQL.Add('					group by t1.evb2 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			else ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				declare zdarzenia_cr2 cursor ');
    tmp.SQL.Add('				for select t1.evb2, min(t1.date), max(t1.date) ');
    tmp.SQL.Add('					from device_data t1 inner join car_change t2 ');
    tmp.SQL.Add('						on (t1.evb2 = t2.id_car and t1.date >= t2.start_date ');
    tmp.SQL.Add('									   and (t1.date <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('					inner join car t3 on (t2.id_car = t3.id_car) ');
    tmp.SQL.Add('					left join driver t4 on (t2.id_driver = t4.id_driver) ');
    tmp.SQL.Add('					where t1.date >= @start2 ');
    tmp.SQL.Add('						 and t1.date <= @stop2 ');
    tmp.SQL.Add('						and (evb3 = 115 or evb3 = 49 or evb3 = 10 ');
    tmp.SQL.Add('									 or evb3 = 15 or evb3 = 122) ');
    tmp.SQL.Add('					group by t1.evb2 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    open zdarzenia_cr2 ');
    tmp.SQL.Add('	    fetch zdarzenia_cr2 into @car_no, @first_event_datetime_db, @last_event_datetime_db ');
    tmp.SQL.Add('	    while (@@fetch_status <> -1) ');
    tmp.SQL.Add('	    begin ');
    tmp.SQL.Add('	        select @tmpinteger = id from #zmienne where car_no = @car_no ');
    tmp.SQL.Add('	        if @tmpinteger is null ');
    tmp.SQL.Add('	            insert into #zmienne (car_no) values(@car_no) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	        update #zmienne set first_event_datetime_db = @first_event_datetime_db, last_event_datetime_db = @last_event_datetime_db where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		    fetch zdarzenia_cr2 into @car_no, @first_event_datetime_db, @last_event_datetime_db ');
    tmp.SQL.Add('	    end ');
    tmp.SQL.Add('	    close zdarzenia_cr2 ');
    tmp.SQL.Add('	    deallocate zdarzenia_cr2 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		if @car_or_driver_no <> 0 ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			if @isInCarMode = 1 ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				declare zdarzenia_cr2 cursor ');
    tmp.SQL.Add('				for select t1.evb2, min(t1.first_event_datetime) first_event_datetime, max(t1.last_event_datetime) last_event_datetime ');
    tmp.SQL.Add('				from cache_day_work t1 ');
    tmp.SQL.Add('				left join car_change t2 ');
    tmp.SQL.Add('					on (t1.evb2 = t2.id_car and t1.start_praca >= t2.start_date ');
    tmp.SQL.Add('						   and (t1.start_praca <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('				where t1.evb2 = @car_or_driver_no ');
    tmp.SQL.Add('				group by t1.evb2 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			else ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				declare zdarzenia_cr2 cursor ');
    tmp.SQL.Add('				for select t1.evb2, min(t1.first_event_datetime) first_event_datetime, max(t1.last_event_datetime) last_event_datetime ');
    tmp.SQL.Add('				from cache_day_work t1 ');
    tmp.SQL.Add('				inner join car_change t2 ');
    tmp.SQL.Add('					on (t1.evb2 = t2.id_car and t1.start_praca >= t2.start_date ');
    tmp.SQL.Add('						   and (t1.start_praca <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('				where t2.id_driver = @car_or_driver_no ');
    tmp.SQL.Add('				group by t1.evb2 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			if @isInCarMode = 1 ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				declare zdarzenia_cr2 cursor ');
    tmp.SQL.Add('				for select t1.evb2, min(t1.first_event_datetime) first_event_datetime, max(t1.last_event_datetime) last_event_datetime ');
    tmp.SQL.Add('				from cache_day_work t1 ');
    tmp.SQL.Add('				left join car_change t2 ');
    tmp.SQL.Add('					on (t1.evb2 = t2.id_car and t1.start_praca >= t2.start_date ');
    tmp.SQL.Add('						   and (t1.start_praca <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('				group by t1.evb2 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			else ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				declare zdarzenia_cr2 cursor ');
    tmp.SQL.Add('				for select t1.evb2, min(t1.first_event_datetime) first_event_datetime, max(t1.last_event_datetime) last_event_datetime ');
    tmp.SQL.Add('				from cache_day_work t1 ');
    tmp.SQL.Add('				inner join car_change t2 ');
    tmp.SQL.Add('					on (t1.evb2 = t2.id_car and t1.start_praca >= t2.start_date ');
    tmp.SQL.Add('						   and (t1.start_praca <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('				group by t1.evb2 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    open zdarzenia_cr2 ');
    tmp.SQL.Add('	    fetch zdarzenia_cr2 into @car_no, @first_event_datetime_cache, @last_event_datetime_cache ');
    tmp.SQL.Add('	    while (@@fetch_status <> -1) ');
    tmp.SQL.Add('	    begin ');
    tmp.SQL.Add('	        select @tmpinteger = id from #zmienne where car_no = @car_no ');
    tmp.SQL.Add('	        if @tmpinteger is null ');
    tmp.SQL.Add('	            insert into #zmienne (car_no) values(@car_no) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	        update #zmienne set first_event_datetime_cache = @first_event_datetime_cache, last_event_datetime_cache = @last_event_datetime_cache where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		    fetch zdarzenia_cr2 into @car_no, @first_event_datetime_cache, @last_event_datetime_cache ');
    tmp.SQL.Add('	    end ');
    tmp.SQL.Add('	    close zdarzenia_cr2 ');
    tmp.SQL.Add('	    deallocate zdarzenia_cr2 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    select @id = id, @last_event_datetime_cache = last_event_datetime_cache from #zmienne ');
    tmp.SQL.Add('	    where not (first_event_datetime_cache is not null and ');
    tmp.SQL.Add('				   last_event_datetime_cache is not null and ');
    tmp.SQL.Add('				   first_event_datetime_cache <= first_event_datetime_db and ');
    tmp.SQL.Add('				   last_event_datetime_cache >= last_event_datetime_db ) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		if @id is null and @no_cache = 0 ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			update cache_day_work set ulica_start = ');
    tmp.SQL.Add('			( ');
    tmp.SQL.Add('				select top 1 t2.street from street t2 where evb2 = t2.id_car and  start_praca = t2._datetime ');
    tmp.SQL.Add('			) ');
    tmp.SQL.Add('			where ulica_start is null ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @max_id integer ');
    tmp.SQL.Add('			select @max_id = max(id) from #eksport_day_work ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			update cache_day_work set ulica_stop = ');
    tmp.SQL.Add('			( ');
    tmp.SQL.Add('				select top 1 t2.street from street t2 where evb2 = t2.id_car and  stop_praca = t2._datetime ');
    tmp.SQL.Add('			) ');
    tmp.SQL.Add('			where id = @max_id and ulica_stop is null ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare raport_kursor cursor for ');
    tmp.SQL.Add('				select t1.id, t1.ulica_start, t1.ulica_stop ');
    tmp.SQL.Add('				from cache_day_work t1 ');
    tmp.SQL.Add('				where t1.ulica_stop is null ');
    tmp.SQL.Add('				order by t1.id desc ');
    tmp.SQL.Add('				for update of t1.ulica_stop ');
    tmp.SQL.Add('			open raport_kursor ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @ulica_start_old varchar(50); ');
    tmp.SQL.Add('			declare @ulica_start varchar(50); ');
    tmp.SQL.Add('			declare @ulica_stop varchar(50); ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			set @ulica_start_old = ''''; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			fetch raport_kursor into @id, @ulica_start, @ulica_stop ');
    tmp.SQL.Add('			while (@@fetch_status <> -1) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				if @ulica_start_old <> '''' ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					update cache_day_work set ulica_stop = @ulica_start_old where id = @id; ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				set @ulica_start_old = @ulica_start; ');
    tmp.SQL.Add('				fetch raport_kursor into @id, @ulica_start, @ulica_stop ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			close raport_kursor ');
    tmp.SQL.Add('			deallocate raport_kursor ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			if @isInCarMode = 1 ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				select * from cache_day_work ');
    tmp.SQL.Add('				where (stop_praca > @start) and (start_praca < @stop) ');
    tmp.SQL.Add('				   and (evb2 = @car_or_driver_no) ');
    tmp.SQL.Add('				order by id ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			else ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				select * from cache_day_work t1 ');
    tmp.SQL.Add('					inner join car_change t2 ');
    tmp.SQL.Add('						on (t1.evb2 = t2.id_car and t1.start_praca >= t2.start_date ');
    tmp.SQL.Add('									   and (t1.start_praca <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('			    where (stop_praca > @start) and (t1.start_praca < @stop) ');
    tmp.SQL.Add('				   and (t2.id_driver = @car_or_driver_no) ');
    tmp.SQL.Add('				order by id ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			select @calculate_fuel = 0 ');
    tmp.SQL.Add('			select @show_only_last_day_route = 0 ');
    tmp.SQL.Add('	        select @DoNotShowEmptyTracks = 0 ');
    tmp.SQL.Add('	        select @with_gps = 1 ');
    tmp.SQL.Add('	        select @kosztPaliwa = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	        select @przesuniecie = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	        if @no_cache = 1 or @no_cache = 2 ');
    tmp.SQL.Add('	        begin ');
    tmp.SQL.Add('				select @car_or_driver_no2 = @car_or_driver_no ');
    tmp.SQL.Add('				set @start2 = DATEADD(month, -1, @start) ');
    tmp.SQL.Add('				set @stop2 = DATEADD(month, 1, @stop) ');
    tmp.SQL.Add('	        end ');
    tmp.SQL.Add('	        else ');
    tmp.SQL.Add('			if @last_event_datetime_cache is null ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				select @car_or_driver_no2 = @car_or_driver_no ');
    tmp.SQL.Add('	--			select @car_or_driver_no = 0 ');
    tmp.SQL.Add('				if @start > cast(''2010-06-01'' as datetime) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					select @start2 = cast(''2010-06-01'' as datetime) ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					select @start2 = @start ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			else ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				select @car_or_driver_no2 = @car_or_driver_no ');
    tmp.SQL.Add('				select @start2 = @last_event_datetime_cache ');
    tmp.SQL.Add('				select @przesuniecie = 2 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			set @last_kierowca123 = '''' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @num_records integer ');
    tmp.SQL.Add('			if @car_or_driver_no <> 0 ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				if @isInCarMode = 1 ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					declare zdarzenia_cr2 cursor ');
    tmp.SQL.Add('					for select t1.id_device_data, t1.evb1, t1.evb2, t1.evb3, t1.evb4, t1.evb5, t1.evb6, t1.evb7, ');
    tmp.SQL.Add('						t1.evb8, t1.evb9, t1.evb10, t1.date, null, null, null, ');
    tmp.SQL.Add('						t3.driver_name kierowca, t4.use_motohours, ');
    tmp.SQL.Add('					    t4.RPM_OBRO, t4.RPM_DISP, t4.RPM_STAT ');
    tmp.SQL.Add('						from device_data t1 ');
    tmp.SQL.Add('						left join car_change t2 ');
    tmp.SQL.Add('							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date ');
    tmp.SQL.Add('								   and (t1.date <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('						left join driver t3 ');
    tmp.SQL.Add('							on (t3.id_driver = t2.id_driver) ');
    tmp.SQL.Add('						left join car t4 on (t1.evb2 = t4.id_car) ');
    tmp.SQL.Add('						where t1.evb2 = @car_or_driver_no and t1.date >= @start2 and t1.date <= @stop2 ');
    tmp.SQL.Add('						and (t1.evb3 = 85 or t1.evb3 = 115 or t1.evb3 = 49 or ');
    tmp.SQL.Add('								t1.evb3 = 10 or t1.evb3 = 15 or t1.evb3 = 122) ');
    tmp.SQL.Add('						order by t1.id_device_data ');
    tmp.SQL.Add('					select @num_records = count(*) ');
    tmp.SQL.Add('						from device_data t1 ');
    tmp.SQL.Add('						left join car_change t2 ');
    tmp.SQL.Add('							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date ');
    tmp.SQL.Add('								   and (t1.date <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('						left join driver t3 ');
    tmp.SQL.Add('							on (t3.id_driver = t2.id_driver) ');
    tmp.SQL.Add('						left join car t4 on (t1.evb2 = t4.id_car) ');
    tmp.SQL.Add('						where t1.evb2 = @car_or_driver_no and t1.date >= @start2 and t1.date <= @stop2 ');
    tmp.SQL.Add('						and (t1.evb3 = 85 or t1.evb3 = 115 or t1.evb3 = 49 or ');
    tmp.SQL.Add('								t1.evb3 = 10 or t1.evb3 = 15 or t1.evb3 = 122) ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					declare zdarzenia_cr2 cursor ');
    tmp.SQL.Add('					for select t1.id_device_data, t1.evb1, t1.evb2, t1.evb3, t1.evb4, t1.evb5, t1.evb6, t1.evb7, ');
    tmp.SQL.Add('						t1.evb8, t1.evb9, t1.evb10, t1.date, t3.rej_numb, t3.name, t2.id_car_change, ');
    tmp.SQL.Add('								   t4.driver_name kierowca, t3.use_motohours, ');
    tmp.SQL.Add('								   t3.RPM_OBRO, t3.RPM_DISP, t3.RPM_STAT ');
    tmp.SQL.Add('						from device_data t1 inner join car_change t2 ');
    tmp.SQL.Add('							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date ');
    tmp.SQL.Add('										   and (t1.date <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('						inner join car t3 on (t2.id_car = t3.id_car) ');
    tmp.SQL.Add('						left join driver t4 on (t2.id_driver = t4.id_driver) ');
    tmp.SQL.Add('						where t2.id_driver = @car_or_driver_no and t1.date >= @start2 ');
    tmp.SQL.Add('							 and t1.date <= @stop2 ');
    tmp.SQL.Add('							and (evb3 = 85 or evb3 = 115 or evb3 = 49 or evb3 = 10 ');
    tmp.SQL.Add('										 or evb3 = 15 or evb3 = 122) ');
    tmp.SQL.Add('						order by t2.start_date, t2.id_car, t1.id_device_data ');
    tmp.SQL.Add('					select @num_records = count(*) ');
    tmp.SQL.Add('						from device_data t1 inner join car_change t2 ');
    tmp.SQL.Add('							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date ');
    tmp.SQL.Add('										   and (t1.date <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('						inner join car t3 on (t2.id_car = t3.id_car) ');
    tmp.SQL.Add('						left join driver t4 on (t2.id_driver = t4.id_driver) ');
    tmp.SQL.Add('						where t2.id_driver = @car_or_driver_no and t1.date >= @start2 ');
    tmp.SQL.Add('							 and t1.date <= @stop2 ');
    tmp.SQL.Add('							and (evb3 = 85 or evb3 = 115 or evb3 = 49 or evb3 = 10 ');
    tmp.SQL.Add('										 or evb3 = 15 or evb3 = 122) ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			else ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				if @isInCarMode = 1 ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					declare zdarzenia_cr2 cursor ');
    tmp.SQL.Add('					for select t1.id_device_data, t1.evb1, t1.evb2, t1.evb3, t1.evb4, t1.evb5, t1.evb6, t1.evb7, ');
    tmp.SQL.Add('						t1.evb8, t1.evb9, t1.evb10, t1.date, null, null, null, ');
    tmp.SQL.Add('						t3.driver_name kierowca, t4.use_motohours, ');
    tmp.SQL.Add('								   t4.RPM_OBRO, t4.RPM_DISP, t4.RPM_STAT ');
    tmp.SQL.Add('						from device_data t1 ');
    tmp.SQL.Add('						left join car_change t2 ');
    tmp.SQL.Add('							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date ');
    tmp.SQL.Add('								   and (t1.date <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('						left join driver t3 ');
    tmp.SQL.Add('							on (t3.id_driver = t2.id_driver) ');
    tmp.SQL.Add('						left join car t4 on (t1.evb2 = t4.id_car) ');
    tmp.SQL.Add('						where t1.date >= @start2 and t1.date <= @stop2 ');
    tmp.SQL.Add('						and (t1.evb3 = 85 or t1.evb3 = 115 or t1.evb3 = 49 or ');
    tmp.SQL.Add('								t1.evb3 = 10 or t1.evb3 = 15 or t1.evb3 = 122) ');
    tmp.SQL.Add('						order by t1.evb2, t1.id_device_data ');
    tmp.SQL.Add('					select @num_records = count(*) ');
    tmp.SQL.Add('						from device_data t1 ');
    tmp.SQL.Add('						left join car_change t2 ');
    tmp.SQL.Add('							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date ');
    tmp.SQL.Add('								   and (t1.date <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('						left join driver t3 ');
    tmp.SQL.Add('							on (t3.id_driver = t2.id_driver) ');
    tmp.SQL.Add('						left join car t4 on (t1.evb2 = t4.id_car) ');
    tmp.SQL.Add('						where t1.date >= @start2 and t1.date <= @stop2 ');
    tmp.SQL.Add('						and (t1.evb3 = 85 or t1.evb3 = 115 or t1.evb3 = 49 or ');
    tmp.SQL.Add('								t1.evb3 = 10 or t1.evb3 = 15 or t1.evb3 = 122) ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					declare zdarzenia_cr2 cursor ');
    tmp.SQL.Add('					for select t1.id_device_data, t1.evb1, t1.evb2, t1.evb3, t1.evb4, t1.evb5, t1.evb6, t1.evb7, ');
    tmp.SQL.Add('						t1.evb8, t1.evb9, t1.evb10, t1.date, t3.rej_numb, t3.name, t2.id_car_change, ');
    tmp.SQL.Add('								   t4.driver_name kierowca, t3.use_motohours, ');
    tmp.SQL.Add('								   t3.RPM_OBRO, t3.RPM_DISP, t3.RPM_STAT ');
    tmp.SQL.Add('						from device_data t1 inner join car_change t2 ');
    tmp.SQL.Add('							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date ');
    tmp.SQL.Add('										   and (t1.date <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('						inner join car t3 on (t2.id_car = t3.id_car) ');
    tmp.SQL.Add('						left join driver t4 on (t2.id_driver = t4.id_driver) ');
    tmp.SQL.Add('						where t1.date >= @start2 ');
    tmp.SQL.Add('							 and t1.date <= @stop2 ');
    tmp.SQL.Add('							and (evb3 = 85 or evb3 = 115 or evb3 = 49 or evb3 = 10 ');
    tmp.SQL.Add('										 or evb3 = 15 or evb3 = 122) ');
    tmp.SQL.Add('						order by t2.start_date, t2.id_car, t1.id_device_data ');
    tmp.SQL.Add('					select @num_records = count(*) ');
    tmp.SQL.Add('						from device_data t1 inner join car_change t2 ');
    tmp.SQL.Add('							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date ');
    tmp.SQL.Add('										   and (t1.date <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('						inner join car t3 on (t2.id_car = t3.id_car) ');
    tmp.SQL.Add('						left join driver t4 on (t2.id_driver = t4.id_driver) ');
    tmp.SQL.Add('						where t1.date >= @start2 ');
    tmp.SQL.Add('							 and t1.date <= @stop2 ');
    tmp.SQL.Add('							and (evb3 = 85 or evb3 = 115 or evb3 = 49 or evb3 = 10 ');
    tmp.SQL.Add('										 or evb3 = 15 or evb3 = 122) ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @record_index integer ');
    tmp.SQL.Add('			declare @record_step integer ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			set @record_index = 1 ');
    tmp.SQL.Add('			set @record_step = 10 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			select @car_no = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			select @czas_10 = null ');
    tmp.SQL.Add('			select @last_groupid = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @RPM_STAT bit ');
    tmp.SQL.Add('			declare @RPM_DISP integer ');
    tmp.SQL.Add('			declare @RPM_OBRO integer ');
    tmp.SQL.Add('			declare @last_evdata datetime ');
    tmp.SQL.Add('			declare @sekundy integer ');
    tmp.SQL.Add('			declare @impulsy integer ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			open zdarzenia_cr2 ');
    tmp.SQL.Add('			fetch zdarzenia_cr2 into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, ');
    tmp.SQL.Add('					@evb8, @evb9, @evb10, @evdata, @rej_numb2, @name2, ');
    tmp.SQL.Add('					@car_no2, @kierowca2, @car_type2, @RPM_OBRO, @RPM_DISP, @RPM_STAT ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @canceled bit ');
    tmp.SQL.Add('			declare @w_czasie_jazdy integer ');
    tmp.SQL.Add('			set @w_czasie_jazdy = 0 ');
    tmp.SQL.Add('			set @canceled = 0 ');
    tmp.SQL.Add('			set @last_evdata = null ');
    tmp.SQL.Add('			while (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				while((@przesuniecie > 0) and (@@fetch_status <> -1)) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					select @przesuniecie = @przesuniecie - 1 ');
    tmp.SQL.Add('					fetch zdarzenia_cr2 into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, ');
    tmp.SQL.Add('						@evb8, @evb9, @evb10, @evdata, @rej_numb2, @name2, ');
    tmp.SQL.Add('						@car_no2, @kierowca2, @car_type2, @RPM_OBRO, @RPM_DISP, @RPM_STAT ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				select @car_no = @evb2 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				select @tmpinteger = id from #zmienne where car_no = @car_no ');
    tmp.SQL.Add('				if @tmpinteger is null ');
    tmp.SQL.Add('					insert into #zmienne (car_no) values(@car_no) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				select @tmpdatetime = start_postoj from #zmienne ');
    tmp.SQL.Add('					where car_no = @car_no ');
    tmp.SQL.Add('				if @tmpdatetime is null ');
    tmp.SQL.Add('					update #zmienne set start_postoj = @evdata where car_no = @car_no ');
    tmp.SQL.Add('				select @tmpdatetime = start_praca from #zmienne ');
    tmp.SQL.Add('					where car_no = @car_no ');
    tmp.SQL.Add('				if @tmpdatetime is null ');
    tmp.SQL.Add('					update #zmienne set start_praca = @evdata where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if @evb3 <> 85 and @evb3 <> 117 and @evb3 <> 217 ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					update #zmienne set first_event_datetime_db = @evdata where car_no = @car_no and first_event_datetime_db is null ');
    tmp.SQL.Add('					update #zmienne set last_event_datetime_db = @evdata where car_no = @car_no ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if @evb3 = 122 ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('				    print @evdata; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					set @impulsy = @evb1 * 256 * 256 + ');
    tmp.SQL.Add('								   @evb9 * 256 + ');
    tmp.SQL.Add('							       @evb10 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					if (@last_evdata is not null) and (@RPM_STAT = 1) ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						set @sekundy = DATEDIFF(second, @last_evdata, @evdata); ');
    tmp.SQL.Add('						if (@sekundy <> 0) and (@RPM_DISP <> 0) and (@RPM_STAT = 1) and (@impulsy <> 0) ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							update #zmienne set obroty = 0.0 where car_no = @car_no and obroty is null ');
    tmp.SQL.Add('							update #zmienne set obroty_count = 0 where car_no = @car_no and obroty_count is null ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('							update #zmienne set obroty = obroty + (@impulsy / @sekundy * @RPM_OBRO / @RPM_DISP) where car_no = @car_no ');
    tmp.SQL.Add('							update #zmienne set obroty_count = obroty_count + 1 where car_no = @car_no ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('					set @last_evdata = @evdata ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if @evb3 = 10 ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					set @last_evdata = @evdata ');
    tmp.SQL.Add('					select @czas_10 = @evdata ');
    tmp.SQL.Add('					set @w_czasie_jazdy = 1 ');
    tmp.SQL.Add('					update #zmienne set obroty = 0.0 where car_no = @car_no ');
    tmp.SQL.Add('					update #zmienne set obroty_count = 0 where car_no = @car_no ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if @evb3 = 85 ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					set @w_czasie_jazdy = 0 ');
    tmp.SQL.Add('					select @tmpdatetime = last49_115 from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					if (@tmpdatetime < @czas_10) or (@tmpdatetime is null) ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						update #zmienne set last_last49_115 = @tmpdatetime where car_no = @car_no ');
    tmp.SQL.Add('						update #zmienne set last49_115 = @evdata where car_no = @car_no ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @tmpdatetime = last85 from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					update #zmienne set last_last85 = @tmpdatetime where car_no = @car_no ');
    tmp.SQL.Add('					update #zmienne set last85 = @evdata where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @tmpnumeric = droga from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					update #zmienne set old_droga = @tmpnumeric where car_no = @car_no ');
    tmp.SQL.Add('					execute spDroga @car_no, @evb9, @evb10, @tmpnumeric OUTPUT ');
    tmp.SQL.Add('					update #zmienne set droga = @tmpnumeric where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @tmpinteger = jalowy from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					update #zmienne set old_jalowy = @tmpinteger where car_no = @car_no ');
    tmp.SQL.Add('					update #zmienne set jalowy = @evb1 * 256 + @evb4 where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @last_lastkierowca = isnull(@last_kierowca, '''') ');
    tmp.SQL.Add('					select @last_kierowca = isnull(@kierowca2, '''') ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @stan = 1 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				if (@evb3 = 49) or (@evb3 = 115) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					select @tmpdatetime = last49_115 from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					update #zmienne set last_last49_115 = @tmpdatetime where car_no = @car_no ');
    tmp.SQL.Add('					update #zmienne set last49_115 = @evdata where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @stan = 2 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					select @stan = 0 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@evb3 = 15) and (@w_czasie_jazdy = 1) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('				  set @id = null ');
    tmp.SQL.Add('					select top 1 @id = id_device_data, @evb1 = evb1, @evb10 = evb10, @evdata = date from device_data ');
    tmp.SQL.Add('						where evb2 = @evb2 and evb3 = 113 and date <= @evdata and date >= @czas_10 ');
    tmp.SQL.Add('						order by id_device_data desc ');
    tmp.SQL.Add('					if @id is not null ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						select @tmpdatetime = last49_115 from #zmienne ');
    tmp.SQL.Add('							where car_no = @car_no ');
    tmp.SQL.Add('						update #zmienne set last_last49_115 = @tmpdatetime where car_no = @car_no ');
    tmp.SQL.Add('						update #zmienne set last49_115 = @evdata where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						set @w_czasie_jazdy = 0 ');
    tmp.SQL.Add('						select @tmpdatetime = last49_115 from #zmienne ');
    tmp.SQL.Add('							where car_no = @car_no ');
    tmp.SQL.Add('						if (@tmpdatetime < @czas_10) or (@tmpdatetime is null) ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							update #zmienne set last_last49_115 = @tmpdatetime where car_no = @car_no ');
    tmp.SQL.Add('							update #zmienne set last49_115 = @evdata where car_no = @car_no ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						select @tmpdatetime = last85 from #zmienne ');
    tmp.SQL.Add('							where car_no = @car_no ');
    tmp.SQL.Add('						update #zmienne set last_last85 = @tmpdatetime where car_no = @car_no ');
    tmp.SQL.Add('						update #zmienne set last85 = @czas_10 where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						select @tmpnumeric = droga from #zmienne ');
    tmp.SQL.Add('							where car_no = @car_no ');
    tmp.SQL.Add('						update #zmienne set old_droga = @tmpnumeric where car_no = @car_no ');
    tmp.SQL.Add('						execute spDroga @car_no, @evb1, @evb10, @tmpnumeric OUTPUT ');
    tmp.SQL.Add('						update #zmienne set droga = @tmpnumeric where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						select @tmpinteger = jalowy from #zmienne ');
    tmp.SQL.Add('							where car_no = @car_no ');
    tmp.SQL.Add('						update #zmienne set old_jalowy = @tmpinteger where car_no = @car_no ');
    tmp.SQL.Add('						update #zmienne set jalowy = 0 where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						select @last_lastkierowca = isnull(@last_kierowca, '''') ');
    tmp.SQL.Add('						select @last_kierowca = isnull(@kierowca2, '''') ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						select @stan = 1 ');
    tmp.SQL.Add('					end; ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@stan = 1) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					select @tmpdatetime = last_last85 from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					select @tmpdatetime2 = last_last49_115 from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					if (@tmpdatetime is null) or (@tmpdatetime2 is null) ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						fetch zdarzenia_cr2 into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, ');
    tmp.SQL.Add('								@evb8, @evb9, @evb10, @evdata, @rej_numb2, @name2, ');
    tmp.SQL.Add('								@car_no2, @kierowca2, @car_type2, @RPM_OBRO, @RPM_DISP, @RPM_STAT ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						continue ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @tmpdatetime = last_last85 from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					update #zmienne set start_praca = @tmpdatetime where car_no = @car_no ');
    tmp.SQL.Add('					select @tmpdatetime = last_last49_115 from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					update #zmienne set stop_praca = @tmpdatetime where car_no = @car_no ');
    tmp.SQL.Add('					update #zmienne set start_postoj = @tmpdatetime where car_no = @car_no ');
    tmp.SQL.Add('					select @tmpdatetime = last85 from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					update #zmienne set stop_postoj = @tmpdatetime where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @start_praca_tmp = start_praca from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					select @stop_praca_tmp = stop_praca from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					select @start_postoj_tmp = start_postoj from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					select @stop_postoj_tmp = stop_postoj from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					select @old_droga_tmp = old_droga from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @tmp = DATEDIFF(second, @start_postoj_tmp, @stop_postoj_tmp) ');
    tmp.SQL.Add('					if @tmp = 0 ');
    tmp.SQL.Add('						select @tmp = 60 ');
    tmp.SQL.Add('					if @tmp < 0 ');
    tmp.SQL.Add('						select @tmp = 0 ');
    tmp.SQL.Add('					set @ile_postoj_tmp = dbo.spGetGGMMf(@tmp); ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @tmp2 = DATEDIFF(second, @start_praca_tmp, @stop_praca_tmp) ');
    tmp.SQL.Add('					if @tmp2 = 0 ');
    tmp.SQL.Add('						select @tmp2 = 60 ');
    tmp.SQL.Add('					set @ile_praca_tmp = dbo.spGetGGMMf(@tmp2); ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @old_jalowy_tmp = old_jalowy from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					if @old_jalowy_tmp > @tmp2 ');
    tmp.SQL.Add('						select @old_jalowy_tmp = @tmp2 ');
    tmp.SQL.Add('					set @ile_jalowy_tmp = dbo.spGetGGMMf(@old_jalowy_tmp); ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					set @dzien = dbo.spNazwaDnia_f(@start_praca_tmp); ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @tmp3 = DATEPART(week, @start_praca_tmp) ');
    tmp.SQL.Add('					if DATEPART(weekday, @start_praca_tmp) = 1 ');
    tmp.SQL.Add('						select @tmp3 = @tmp3 - 1 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					if not((@DoNotShowEmptyTracks = 1) and ');
    tmp.SQL.Add('						  (@old_droga_tmp < 0.00001) ) ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						if (@last_lastkierowca <> @last_kierowca123) ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							set @last_groupid = @last_groupid + 1 ');
    tmp.SQL.Add('							set @last_kierowca123 = @last_lastkierowca ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						select @first_event_datetime_db = first_event_datetime_db, @last_event_datetime_db = last_event_datetime_db from #zmienne ');
    tmp.SQL.Add('							where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						select @obroty = old_obroty, ');
    tmp.SQL.Add('							   @obroty_count = old_obroty_count from #zmienne ');
    tmp.SQL.Add('							where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						if @obroty is null ');
    tmp.SQL.Add('							set @obroty = 0.0 ');
    tmp.SQL.Add('						if @obroty_count is null ');
    tmp.SQL.Add('							set @obroty_count = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						update #zmienne ');
    tmp.SQL.Add('							set old_obroty = obroty, ');
    tmp.SQL.Add('							    old_obroty_count = obroty_count ');
    tmp.SQL.Add('							where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						if @obroty_count > 0 ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							set @obroty = @obroty / @obroty_count ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('						else ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							set @obroty = 0.0 ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						insert into #eksport_day_work (evb2, marka_pojazdu, nr_rej_pojazdu, kierowca, ');
    tmp.SQL.Add('							opis, start_praca, stop_praca, start_postoj, stop_postoj, przebieg, ');
    tmp.SQL.Add('							group_id, ile_postoj, ile_praca, ile_jalowy, data, dzien, ');
    tmp.SQL.Add('							ile_postoj_sek, ile_praca_sek, ile_jalowy_sek, ');
    tmp.SQL.Add('							week, month, szerokosc, dlugosc, szerokosc0, dlugosc0, ');
    tmp.SQL.Add('							first_event_datetime, last_event_datetime, srednie_obroty, motogodziny, count122) ');
    tmp.SQL.Add('							values(@car_no, '''', '''', @last_lastkierowca, '''', ');
    tmp.SQL.Add('							@start_praca_tmp, @stop_praca_tmp, @start_postoj_tmp, ');
    tmp.SQL.Add('							@stop_postoj_tmp, @old_droga_tmp, @last_groupid, @ile_postoj_tmp, ');
    tmp.SQL.Add('							@ile_praca_tmp, @ile_jalowy_tmp, ');
    tmp.SQL.Add('							cast(STR(MONTH(@start_praca_tmp)) + ''/'' + ');
    tmp.SQL.Add('								 STR(DAY(@start_praca_tmp)) + ''/'' + ');
    tmp.SQL.Add('								 STR(YEAR(@start_praca_tmp)) as datetime), ');
    tmp.SQL.Add('							@dzien, @tmp, @tmp2, FLOOR(@old_jalowy_tmp / 60) * 60, ');
    tmp.SQL.Add('							DATEPART(year, @start_praca_tmp) * 100 + @tmp3, ');
    tmp.SQL.Add('							DATEPART(year, @start_praca_tmp) * 100 + ');
    tmp.SQL.Add('								DATEPART(month, @start_praca_tmp), @szerokosc, @dlugosc, @szerokosc0, @dlugosc0, ');
    tmp.SQL.Add('							@first_event_datetime_db, @last_event_datetime_db, @obroty, @obroty / 1325.0 * (@tmp2 + 60) / 3600.0, @obroty_count) ');
    tmp.SQL.Add('						update #zmienne set obroty = 0.0 where car_no = @car_no ');
    tmp.SQL.Add('						update #zmienne set obroty_count = 0 where car_no = @car_no ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('					set @dlugosc0 = @dlugosc ');
    tmp.SQL.Add('					set @szerokosc0 = @szerokosc ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@record_index % @record_step = 0) ');
    tmp.SQL.Add('					exec sp_progress_set @id_progress, @record_index, @num_records, @canceled output; ');
    tmp.SQL.Add('				set @record_index = @record_index + 1 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				fetch zdarzenia_cr2 into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, ');
    tmp.SQL.Add('						@evb8, @evb9, @evb10, @evdata, @rej_numb2, @name2, ');
    tmp.SQL.Add('						@car_no2, @kierowca2, @car_type2, @RPM_OBRO, @RPM_DISP, @RPM_STAT ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			close zdarzenia_cr2 ');
    tmp.SQL.Add('			deallocate zdarzenia_cr2 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			if @car_no <> 0 ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				select @tmpdatetime = last85 from #zmienne ');
    tmp.SQL.Add('					where car_no = @car_no ');
    tmp.SQL.Add('				select @tmpdatetime2 = last49_115 from #zmienne ');
    tmp.SQL.Add('					where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@tmpdatetime is not null) and (@tmpdatetime2 is not null) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					update #zmienne set start_praca = @tmpdatetime where car_no = @car_no ');
    tmp.SQL.Add('					update #zmienne set stop_praca = @tmpdatetime2 where car_no = @car_no ');
    tmp.SQL.Add('					update #zmienne set start_postoj = @tmpdatetime2 where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @start_praca_tmp = start_praca from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					select @stop_praca_tmp = stop_praca from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					select @start_postoj_tmp = start_postoj from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					select @stop_postoj_tmp = stop_postoj from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					select @droga_tmp = droga from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @tmp = DATEDIFF(second, @start_postoj_tmp, @stop_postoj_tmp) ');
    tmp.SQL.Add('					if @tmp = 0 ');
    tmp.SQL.Add('						select @tmp = 60 ');
    tmp.SQL.Add('					if @tmp < 0 ');
    tmp.SQL.Add('						select @tmp = 0 ');
    tmp.SQL.Add('					set @ile_postoj_tmp = dbo.spGetGGMMf(@tmp); ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @tmp2 = DATEDIFF(second, @start_praca_tmp, @stop_praca_tmp) ');
    tmp.SQL.Add('					if @tmp2 = 0 ');
    tmp.SQL.Add('						select @tmp2 = 60 ');
    tmp.SQL.Add('					set @ile_praca_tmp = dbo.spGetGGMMf(@tmp2); ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @jalowy_tmp = jalowy from #zmienne ');
    tmp.SQL.Add('						where car_no = @car_no ');
    tmp.SQL.Add('					if @jalowy_tmp > @tmp2 ');
    tmp.SQL.Add('						select @jalowy_tmp = @tmp2 ');
    tmp.SQL.Add('					set @ile_jalowy_tmp = dbo.spGetGGMMf(@jalowy_tmp); ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					set @dzien = dbo.spNazwaDnia_f(@start_praca_tmp); ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					select @tmp3 = DATEPART(week, @start_praca_tmp) ');
    tmp.SQL.Add('					if DATEPART(weekday, @start_praca_tmp) = 1 ');
    tmp.SQL.Add('						select @tmp3 = @tmp3 - 1 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					if not((@DoNotShowEmptyTracks = 1) and ');
    tmp.SQL.Add('						  (@droga_tmp < 0.00001) ) ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						if (@last_lastkierowca <> @last_kierowca123) ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							set @last_groupid = @last_groupid + 1 ');
    tmp.SQL.Add('							set @last_kierowca123 = @last_lastkierowca ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						select @first_event_datetime_db = first_event_datetime_db, @last_event_datetime_db = last_event_datetime_db from #zmienne ');
    tmp.SQL.Add('							where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						select @obroty = old_obroty, ');
    tmp.SQL.Add('							   @obroty_count = old_obroty_count from #zmienne ');
    tmp.SQL.Add('							where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						if @obroty is null ');
    tmp.SQL.Add('							set @obroty = 0.0 ');
    tmp.SQL.Add('						if @obroty_count is null ');
    tmp.SQL.Add('							set @obroty_count = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						update #zmienne ');
    tmp.SQL.Add('							set old_obroty = obroty, ');
    tmp.SQL.Add('							    old_obroty_count = obroty_count ');
    tmp.SQL.Add('							where car_no = @car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						if @obroty_count > 0 ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							set @obroty = @obroty / @obroty_count ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add('						else ');
    tmp.SQL.Add('						begin ');
    tmp.SQL.Add('							set @obroty = 0.0 ');
    tmp.SQL.Add('						end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('						insert into #eksport_day_work (evb2, marka_pojazdu, nr_rej_pojazdu, kierowca, ');
    tmp.SQL.Add('							opis, start_praca, stop_praca, start_postoj, stop_postoj, przebieg, ');
    tmp.SQL.Add('							group_id, ile_postoj, ile_praca, ile_jalowy, data, dzien, ');
    tmp.SQL.Add('							ile_postoj_sek, ile_praca_sek, ile_jalowy_sek, ');
    tmp.SQL.Add('							week, month, szerokosc, dlugosc, szerokosc0, dlugosc0, ');
    tmp.SQL.Add('							first_event_datetime, last_event_datetime, srednie_obroty, motogodziny, count122) ');
    tmp.SQL.Add('							values(@car_no, '''', '''', @last_lastkierowca, '''', ');
    tmp.SQL.Add('							@start_praca_tmp, @stop_praca_tmp, @start_postoj_tmp, ');
    tmp.SQL.Add('							null, @droga_tmp, @last_groupid, null, ');
    tmp.SQL.Add('							@ile_praca_tmp, @ile_jalowy_tmp, ');
    tmp.SQL.Add('							cast(STR(MONTH(@start_praca_tmp)) + ''/'' + ');
    tmp.SQL.Add('								 STR(DAY(@start_praca_tmp)) + ''/'' + ');
    tmp.SQL.Add('								 STR(YEAR(@start_praca_tmp)) as datetime), ');
    tmp.SQL.Add('							@dzien, ');
    tmp.SQL.Add('							@tmp, @tmp2, FLOOR(@jalowy_tmp / 60) * 60, ');
    tmp.SQL.Add('							DATEPART(year, @start_praca_tmp) * 100 + @tmp3, ');
    tmp.SQL.Add('							DATEPART(year, @start_praca_tmp) * 100 + ');
    tmp.SQL.Add('								DATEPART(month, @start_praca_tmp), @szerokosc, @dlugosc, ');
    tmp.SQL.Add('							@szerokosc0, @dlugosc0, ');
    tmp.SQL.Add('							@first_event_datetime_db, @last_event_datetime_db, @obroty, @obroty / 1325.0 * (@tmp2 + 60) / 3600.0, @obroty_count) ');
    tmp.SQL.Add('						update #zmienne set obroty = 0.0 where car_no = @car_no ');
    tmp.SQL.Add('						update #zmienne set obroty_count = 0 where car_no = @car_no ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('					set @szerokosc0 = @szerokosc ');
    tmp.SQL.Add('					set @dlugosc0 = @dlugosc ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	--		drop table #zmienne ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @group_id_aggr integer ');
    tmp.SQL.Add('			declare @group_evb2 integer ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare aggr_cr cursor ');
    tmp.SQL.Add('					for select evb2, data, group_id, sum(przebieg), sum(ile_praca_sek), sum(ile_postoj_sek), ');
    tmp.SQL.Add('						sum(ile_jalowy_sek), sum(motogodziny) from #eksport_day_work ');
    tmp.SQL.Add('						where (stop_praca > @start) and (start_praca < @stop) ');
    tmp.SQL.Add('						group by evb2, data, group_id ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @day_aggr datetime ');
    tmp.SQL.Add('			declare @day_przebieg numeric(10, 3) ');
    tmp.SQL.Add('			declare @day_praca_sek integer ');
    tmp.SQL.Add('			declare @day_postoj_sek integer ');
    tmp.SQL.Add('			declare @day_jalowy_sek integer ');
    tmp.SQL.Add('			declare @day_motogodziny numeric(10, 3) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			open aggr_cr ');
    tmp.SQL.Add('			fetch aggr_cr into @group_evb2, @day_aggr, @group_id_aggr, @day_przebieg, @day_praca_sek, @day_postoj_sek, @day_jalowy_sek, @day_motogodziny ');
    tmp.SQL.Add('			while (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				update #eksport_day_work set summary_przebieg_day=@day_przebieg, ');
    tmp.SQL.Add('											 summary_praca_day=dbo.spGetGGMMf(@day_praca_sek), ');
    tmp.SQL.Add('											 summary_postoj_day=dbo.spGetGGMMf(@day_postoj_sek), ');
    tmp.SQL.Add('											 summary_jalowy_day=dbo.spGetGGMMf(@day_jalowy_sek), ');
    tmp.SQL.Add('											 summary_motogodziny_day=@day_motogodziny ');
    tmp.SQL.Add('					where data = @day_aggr and group_id = @group_id_aggr and evb2 = @group_evb2 ');
    tmp.SQL.Add('				fetch aggr_cr into @group_evb2, @day_aggr, @group_id_aggr, @day_przebieg, @day_praca_sek, @day_postoj_sek, @day_jalowy_sek, @day_motogodziny ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			close aggr_cr; ');
    tmp.SQL.Add('			deallocate aggr_cr; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare aggr_cr2 cursor ');
    tmp.SQL.Add('					for select evb2, week, group_id, sum(przebieg), sum(ile_praca_sek), sum(ile_postoj_sek), ');
    tmp.SQL.Add('						sum(ile_jalowy_sek), sum(motogodziny) from #eksport_day_work ');
    tmp.SQL.Add('						where (stop_praca > @start) and (start_praca < @stop) ');
    tmp.SQL.Add('						group by evb2, week, group_id ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @week_aggr integer ');
    tmp.SQL.Add('			declare @week_przebieg numeric(10, 3) ');
    tmp.SQL.Add('			declare @week_praca_sek integer ');
    tmp.SQL.Add('			declare @week_postoj_sek integer ');
    tmp.SQL.Add('			declare @week_jalowy_sek integer ');
    tmp.SQL.Add('			declare @week_motogodziny numeric(10, 3) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			open aggr_cr2 ');
    tmp.SQL.Add('			fetch aggr_cr2 into @group_evb2, @week_aggr, @group_id_aggr, @week_przebieg, @week_praca_sek, @week_postoj_sek, @week_jalowy_sek, @week_motogodziny ');
    tmp.SQL.Add('			while (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				update #eksport_day_work set summary_przebieg_week=@week_przebieg, ');
    tmp.SQL.Add('											 summary_praca_week=dbo.spGetGGMMf(@week_praca_sek), ');
    tmp.SQL.Add('											 summary_postoj_week=dbo.spGetGGMMf(@week_postoj_sek), ');
    tmp.SQL.Add('											 summary_jalowy_week=dbo.spGetGGMMf(@week_jalowy_sek), ');
    tmp.SQL.Add('											 summary_motogodziny_week = @week_motogodziny ');
    tmp.SQL.Add('					where week = @week_aggr and group_id = @group_id_aggr and evb2 = @group_evb2 ');
    tmp.SQL.Add('				fetch aggr_cr2 into @group_evb2, @week_aggr, @group_id_aggr, @week_przebieg, @week_praca_sek, @week_postoj_sek, @week_jalowy_sek, @week_motogodziny ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			close aggr_cr2; ');
    tmp.SQL.Add('			deallocate aggr_cr2; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare aggr_cr3 cursor ');
    tmp.SQL.Add('					for select evb2, month, group_id, sum(przebieg), sum(ile_praca_sek), sum(ile_postoj_sek), ');
    tmp.SQL.Add('						sum(ile_jalowy_sek), sum(motogodziny) from #eksport_day_work ');
    tmp.SQL.Add('						where (stop_praca > @start) and (start_praca < @stop) ');
    tmp.SQL.Add('						group by evb2, month, group_id ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @month_aggr integer ');
    tmp.SQL.Add('			declare @month_przebieg numeric(10, 3) ');
    tmp.SQL.Add('			declare @month_praca_sek integer ');
    tmp.SQL.Add('			declare @month_postoj_sek integer ');
    tmp.SQL.Add('			declare @month_jalowy_sek integer ');
    tmp.SQL.Add('			declare @month_motogodziny numeric(10, 3) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			open aggr_cr3 ');
    tmp.SQL.Add('			fetch aggr_cr3 into @group_evb2, @month_aggr, @group_id_aggr, @month_przebieg, @month_praca_sek, @month_postoj_sek, @month_jalowy_sek, @month_motogodziny ');
    tmp.SQL.Add('			while (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				update #eksport_day_work set summary_przebieg_month=@month_przebieg, ');
    tmp.SQL.Add('											 summary_praca_month=dbo.spGetGGMMf(@month_praca_sek), ');
    tmp.SQL.Add('											 summary_postoj_month=dbo.spGetGGMMf(@month_postoj_sek), ');
    tmp.SQL.Add('											 summary_jalowy_month=dbo.spGetGGMMf(@month_jalowy_sek), ');
    tmp.SQL.Add('											 summary_motogodziny_month=@month_motogodziny ');
    tmp.SQL.Add('					where month = @month_aggr and group_id = @group_id_aggr and evb2 = @group_evb2 ');
    tmp.SQL.Add('				fetch aggr_cr3 into @group_evb2, @month_aggr, @group_id_aggr, @month_przebieg, @month_praca_sek, @month_postoj_sek, @month_jalowy_sek, @month_motogodziny ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			close aggr_cr3; ');
    tmp.SQL.Add('			deallocate aggr_cr3; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare aggr_cr4 cursor ');
    tmp.SQL.Add('					for select evb2, sum(przebieg), sum(ile_praca_sek), sum(ile_postoj_sek), ');
    tmp.SQL.Add('						sum(ile_jalowy_sek), sum(motogodziny) from #eksport_day_work ');
    tmp.SQL.Add('						where (stop_praca > @start) and (start_praca < @stop) ');
    tmp.SQL.Add('						group by evb2 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @all_przebieg numeric(10, 3) ');
    tmp.SQL.Add('			declare @all_praca_sek integer ');
    tmp.SQL.Add('			declare @all_postoj_sek integer ');
    tmp.SQL.Add('			declare @all_jalowy_sek integer ');
    tmp.SQL.Add('			declare @all_motogodziny numeric(10, 3) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			open aggr_cr4 ');
    tmp.SQL.Add('			fetch aggr_cr4 into @group_evb2, @all_przebieg, @all_praca_sek, @all_postoj_sek, @all_jalowy_sek, @all_motogodziny ');
    tmp.SQL.Add('			while (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				update #eksport_day_work set summary_przebieg_all=@all_przebieg, ');
    tmp.SQL.Add('											 summary_praca_all=dbo.spGetGGMMf(@all_praca_sek), ');
    tmp.SQL.Add('											 summary_postoj_all=dbo.spGetGGMMf(@all_postoj_sek), ');
    tmp.SQL.Add('											 summary_jalowy_all=dbo.spGetGGMMf(@all_jalowy_sek), ');
    tmp.SQL.Add('											 summary_motogodziny_all=@all_motogodziny ');
    tmp.SQL.Add('				where evb2 = @group_evb2 ');
    tmp.SQL.Add('				fetch aggr_cr4 into @group_evb2, @all_przebieg, @all_praca_sek, @all_postoj_sek, @all_jalowy_sek, @all_motogodziny ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			close aggr_cr4; ');
    tmp.SQL.Add('			deallocate aggr_cr4; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			update #eksport_day_work set marka_pojazdu = ');
    tmp.SQL.Add('				(select NAME from car where id_car = #eksport_day_work.evb2) ');
    tmp.SQL.Add('			update #eksport_day_work set nr_rej_pojazdu = ');
    tmp.SQL.Add('				(select REJ_NUMB from car where id_car = #eksport_day_work.evb2) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare @aggr_car_no integer ');
    tmp.SQL.Add('			declare @aggr_start_praca datetime ');
    tmp.SQL.Add('			declare @aggr_stop_praca datetime ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			if (@calculate_fuel = 1) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				declare aggr_cr5 cursor ');
    tmp.SQL.Add('					for select evb2, min(start_praca), max(stop_praca) from #eksport_day_work ');
    tmp.SQL.Add('					where (stop_praca > @start) and (start_praca < @stop) ');
    tmp.SQL.Add('					and start_praca is not null and stop_praca is not null ');
    tmp.SQL.Add('					group by evb2 ');
    tmp.SQL.Add('				open aggr_cr5 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				fetch aggr_cr5 into @aggr_car_no, @aggr_start_praca, @aggr_stop_praca ');
    tmp.SQL.Add('				while (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					set	@first_1bak = 0 ');
    tmp.SQL.Add('					set	@last_1bak = 0 ');
    tmp.SQL.Add('					set	@first_2bak = 0 ');
    tmp.SQL.Add('					set	@last_2bak = 0 ');
    tmp.SQL.Add('					set	@droga123 = 0 ');
    tmp.SQL.Add('					set	@jalowy = 0 ');
    tmp.SQL.Add('					set	@motogodziny = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					exec sp_progress_set @id_progress, 0, @num_records, @canceled output; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					EXEC spTankowania @aggr_car_no, ');
    tmp.SQL.Add('							@aggr_start_praca, @aggr_stop_praca, ');
    tmp.SQL.Add('							@first_1bak OUTPUT, @last_1bak OUTPUT, ');
    tmp.SQL.Add('							@first_2bak OUTPUT, @last_2bak OUTPUT, ');
    tmp.SQL.Add('							@droga123 OUTPUT, @jalowy OUTPUT, ');
    tmp.SQL.Add('							@motogodziny OUTPUT, 1, @id_progress ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					set @first_1bak = isnull(@first_1bak, 0.0) ');
    tmp.SQL.Add('					set @first_2bak = isnull(@first_2bak, 0.0) ');
    tmp.SQL.Add('					set @last_1bak = isnull(@last_1bak, 0.0) ');
    tmp.SQL.Add('					set @last_2bak = isnull(@last_2bak, 0.0) ');
    tmp.SQL.Add('					set @droga123 = isnull(@droga123, 0.0) ');
    tmp.SQL.Add('					set @jalowy = isnull(@jalowy, 0) ');
    tmp.SQL.Add('					set @motogodziny = isnull(@motogodziny, 0) ');
    tmp.SQL.Add('					declare @min_tank numeric(10, 3) ');
    tmp.SQL.Add('					declare @min_ubytk numeric(10, 3) ');
    tmp.SQL.Add('					select @min_tank = I_TANK from car where id_car = @aggr_car_no ');
    tmp.SQL.Add('					select @min_ubytk = I_UP from car where id_car = @aggr_car_no ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					set @sonda_all_tank = 0.0 ');
    tmp.SQL.Add('					declare tankowania_kursor cursor for ');
    tmp.SQL.Add('						select sonda from #paliwo_wynik2 ');
    tmp.SQL.Add('					open tankowania_kursor ');
    tmp.SQL.Add('					fetch tankowania_kursor into @sonda ');
    tmp.SQL.Add('					while (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						if ((@sonda >= @min_tank) or (@sonda <= (-@min_ubytk))) ');
    tmp.SQL.Add('								set @sonda_all_tank = @sonda_all_tank + isnull(@sonda, 0.0) ');
    tmp.SQL.Add('						fetch tankowania_kursor into @sonda ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('					close tankowania_kursor ');
    tmp.SQL.Add('					deallocate tankowania_kursor ');
    tmp.SQL.Add('					print @first_1bak ');
    tmp.SQL.Add('					print @first_2bak ');
    tmp.SQL.Add('					print @sonda_all_tank ');
    tmp.SQL.Add('					print @last_1bak ');
    tmp.SQL.Add('					print @last_2bak ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					set @ZuzycieSum = @first_1bak + @first_2bak + @sonda_all_tank - @last_1bak - @last_2bak ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					if @motogodziny >= 0 ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						if @droga123 > 0 ');
    tmp.SQL.Add('							set @srednio = cast((@ZuzycieSum / @droga123 * 100) * 10 + 0.5 as integer) / 10.0 ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						if @motogodziny < 0 ');
    tmp.SQL.Add('							set @srednio = cast((@ZuzycieSum / (abs(cast(@motogodziny as numeric(10, 1))) / 3600.0)) * 10 + 0.5 as integer) / 10.0 ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					update #eksport_day_work set summary_paliwo_sum=@ZuzycieSum, ');
    tmp.SQL.Add('												 summary_paliwo_srednio=@srednio, ');
    tmp.SQL.Add('												 summary_paliwo_koszt=@kosztPaliwa * @ZuzycieSum ');
    tmp.SQL.Add('						where evb2 = @aggr_car_no ');
    tmp.SQL.Add('					fetch aggr_cr5 into @aggr_car_no, @aggr_start_praca, @aggr_stop_praca ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				close aggr_cr5 ');
    tmp.SQL.Add('				deallocate aggr_cr5 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			if (@with_gps = 1) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				declare aggr_cr6 cursor ');
    tmp.SQL.Add('					for select evb2, min(start_praca), max(stop_praca) from #eksport_day_work ');
    tmp.SQL.Add('					where (stop_praca > @start) and (start_praca < @stop) ');
    tmp.SQL.Add('					and start_praca is not null and stop_praca is not null ');
    tmp.SQL.Add('					group by evb2 ');
    tmp.SQL.Add('				open aggr_cr6 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				fetch aggr_cr6 into @aggr_car_no, @aggr_start_praca, @aggr_stop_praca ');
    tmp.SQL.Add('				while (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					exec sp_progress_set @id_progress, 0, @num_records, @canceled output; ');
    tmp.SQL.Add('					exec sp_GPS 1, @aggr_car_no, @aggr_start_praca, @aggr_stop_praca, ');
    tmp.SQL.Add('						@id_progress, 0, 0, 1 ');
    tmp.SQL.Add('					fetch aggr_cr6 into @aggr_car_no, @aggr_start_praca, @aggr_stop_praca ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				close aggr_cr6 ');
    tmp.SQL.Add('				deallocate aggr_cr6 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			if (@show_only_last_day_route = 1) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				declare zdarz_3 cursor for ');
    tmp.SQL.Add('				select id, data from #eksport_day_work order by id desc ');
    tmp.SQL.Add('				open zdarz_3 ');
    tmp.SQL.Add('				declare @id_3 integer ');
    tmp.SQL.Add('				declare @data_3 datetime ');
    tmp.SQL.Add('				fetch zdarz_3 into @id_3, @data_3 ');
    tmp.SQL.Add('				declare @start_route_day datetime ');
    tmp.SQL.Add('				set @start_route_day = null ');
    tmp.SQL.Add('				while (@@fetch_status <> -1) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if (@start_route_day is null) or ');
    tmp.SQL.Add('					   (@start_route_day <> @data_3) ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						set @start_route_day = @data_3 ');
    tmp.SQL.Add('						fetch zdarz_3 into @id_3, @data_3 ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						delete from #eksport_day_work where id = @id_3 ');
    tmp.SQL.Add('						fetch zdarz_3 into @id_3, @data_3 ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				close zdarz_3 ');
    tmp.SQL.Add('				deallocate zdarz_3 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			exec sp_progress_unregister @id_progress; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			update #eksport_day_work set ulica_start = ');
    tmp.SQL.Add('			( ');
    tmp.SQL.Add('				select top 1 t2.street from street t2 where evb2 = t2.id_car and  start_praca = t2._datetime ');
    tmp.SQL.Add('			) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			select @max_id = max(id) from #eksport_day_work ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			update #eksport_day_work set ulica_stop = ');
    tmp.SQL.Add('			( ');
    tmp.SQL.Add('				select top 1 t2.street from street t2 where evb2 = t2.id_car and  stop_praca = t2._datetime ');
    tmp.SQL.Add('			) ');
    tmp.SQL.Add('			where id = @max_id ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			declare raport_kursor cursor for ');
    tmp.SQL.Add('				select t1.id, t1.ulica_start, t1.ulica_stop ');
    tmp.SQL.Add('				from #eksport_day_work t1 ');
    tmp.SQL.Add('				order by t1.id desc ');
    tmp.SQL.Add('				for update of t1.ulica_stop ');
    tmp.SQL.Add('			open raport_kursor ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			set @ulica_start_old = ''''; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			fetch raport_kursor into @id, @ulica_start, @ulica_stop ');
    tmp.SQL.Add('			while (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				if @ulica_start_old <> '''' ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					update #eksport_day_work set ulica_stop = @ulica_start_old where id = @id; ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				set @ulica_start_old = @ulica_start; ');
    tmp.SQL.Add('				fetch raport_kursor into @id, @ulica_start, @ulica_stop ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			close raport_kursor ');
    tmp.SQL.Add('			deallocate raport_kursor ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			if ((@no_cache = 0) or (@no_cache = 2)) and (@start > cast(''2010-06-01'' as datetime)) ');
    tmp.SQL.Add('			begin ');
//    tmp.SQL.Add('				insert into cache_day_work(evb2, dzien, data, week, month, przebieg, opis, ile_praca, ');
//    tmp.SQL.Add('					ile_praca_sek, ile_postoj, ile_postoj_sek, ile_jalowy, ile_jalowy_sek, marka_pojazdu, ');
//    tmp.SQL.Add('					nr_rej_pojazdu, kierowca, start_praca, stop_praca, start_postoj, stop_postoj, summary_przebieg_day, ');
//    tmp.SQL.Add('					summary_przebieg_week, summary_przebieg_month, summary_przebieg_all, summary_praca_day, ');
//    tmp.SQL.Add('					summary_praca_week, summary_praca_month, summary_praca_all, summary_postoj_day, summary_postoj_week, ');
//    tmp.SQL.Add('					summary_postoj_month, summary_postoj_all, summary_jalowy_day, summary_jalowy_week, ');
//    tmp.SQL.Add('					summary_jalowy_month, summary_jalowy_all, summary_paliwo_sum, summary_paliwo_srednio, ');
//    tmp.SQL.Add('					summary_paliwo_koszt, group_id, ulica_start, ulica_stop, szerokosc0, dlugosc0, szerokosc, dlugosc, ');
//    tmp.SQL.Add('					srednio, first_event_datetime, last_event_datetime) ');
//    tmp.SQL.Add('				select evb2, dzien, data, week, month, przebieg, opis, ile_praca, ');
//    tmp.SQL.Add('					ile_praca_sek, ile_postoj, ile_postoj_sek, ile_jalowy, ile_jalowy_sek, marka_pojazdu, ');
//    tmp.SQL.Add('					nr_rej_pojazdu, kierowca, start_praca, stop_praca, start_postoj, stop_postoj, summary_przebieg_day, ');
//    tmp.SQL.Add('					summary_przebieg_week, summary_przebieg_month, summary_przebieg_all, summary_praca_day, ');
//    tmp.SQL.Add('					summary_praca_week, summary_praca_month, summary_praca_all, summary_postoj_day, summary_postoj_week, ');
//    tmp.SQL.Add('					summary_postoj_month, summary_postoj_all, summary_jalowy_day, summary_jalowy_week, ');
//    tmp.SQL.Add('					summary_jalowy_month, summary_jalowy_all, summary_paliwo_sum, summary_paliwo_srednio, ');
//    tmp.SQL.Add('					summary_paliwo_koszt, group_id, ulica_start, ulica_stop, szerokosc0, dlugosc0, szerokosc, dlugosc, ');
//    tmp.SQL.Add('					srednio, first_event_datetime, last_event_datetime ');
//    tmp.SQL.Add('				from #eksport_day_work ');
//    tmp.SQL.Add('				order by id, evb2 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				select @car_or_driver_no = @car_or_driver_no2 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if @start > cast(''2010-06-01'' as datetime) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if @isInCarMode = 1 ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						select * from cache_day_work ');
    tmp.SQL.Add('						where (stop_praca > @start) and (start_praca < @stop) ');
    tmp.SQL.Add('						and (evb2 = @car_or_driver_no) ');
    tmp.SQL.Add('						order by id ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						select * from cache_day_work t1 ');
    tmp.SQL.Add('							inner join car_change t2 ');
    tmp.SQL.Add('								on (t1.evb2 = t2.id_car and t1.start_praca >= t2.start_date ');
    tmp.SQL.Add('											and (t1.start_praca <= t2.end_date or t2.end_date is null)) ');
    tmp.SQL.Add('						where (stop_praca > @start) and (t1.start_praca < @stop) ');
    tmp.SQL.Add('							and (t2.id_driver = @car_or_driver_no) ');
    tmp.SQL.Add('						order by id ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					if @DoNotShowEmptyTracks2 = 1 ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						select * from #eksport_day_work ');
    tmp.SQL.Add('						where (stop_praca > @start) and (start_praca < @stop) ');
    tmp.SQL.Add('						and przebieg > 0.0 ');
    tmp.SQL.Add('						order by id ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						select * from #eksport_day_work ');
    tmp.SQL.Add('						where (stop_praca > @start) and (start_praca < @stop) ');
    tmp.SQL.Add('						order by id ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('			else ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				select @car_or_driver_no = @car_or_driver_no2 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if @DoNotShowEmptyTracks2 = 1 ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					select * from #eksport_day_work ');
    tmp.SQL.Add('					where (stop_praca > @start) and (start_praca < @stop) ');
    tmp.SQL.Add('					and przebieg > 0.0 ');
    tmp.SQL.Add('					order by id ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					select * from #eksport_day_work ');
    tmp.SQL.Add('					where (stop_praca > @start) and (start_praca < @stop) ');
    tmp.SQL.Add('					order by id ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('		end ');
    tmp.ExecSQL();
end;

Procedure TTEDEmailSrv.UaktualnijProcedureGPS();
begin
    tmp.SQL.Clear();

    tmp.SQL.Add('ALTER procedure sp_GPS ');
    tmp.SQL.Add('    @isInCarMode integer, ');
    tmp.SQL.Add('    @car_or_driver_no integer, ');
    tmp.SQL.Add('    @start datetime, ');
    tmp.SQL.Add('    @stop datetime, ');
    tmp.SQL.Add('    @id_progress bigint, ');
    tmp.SQL.Add('	@ShowLastPostionIfNone int, ');
    tmp.SQL.Add('	@result_count int OUTPUT, ');
    tmp.SQL.Add('	@nested int = 0 ');
    tmp.SQL.Add('as ');
    tmp.SQL.Add('    if @nested = 1 ');
    tmp.SQL.Add('    begin ');
    tmp.SQL.Add('        set @stop = DATEADD(day, 1, @stop) ');
    tmp.SQL.Add('    end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	declare @num_records integer ');
    tmp.SQL.Add('	declare @dodaj_pozycje integer ');
    tmp.SQL.Add('	set @dodaj_pozycje = 0 ');
    tmp.SQL.Add('	if @isInCarMode = 1 ');
    tmp.SQL.Add('	begin ');
    tmp.SQL.Add('		declare zdarzenia_gps_cr cursor for ');
    tmp.SQL.Add('		select t_zdarzenia.id_device_data,t_zdarzenia.evb1, t_zdarzenia.evb2, t_zdarzenia.evb3, t_zdarzenia.evb4, t_zdarzenia.evb5, t_zdarzenia.evb6, t_zdarzenia.evb7, t_zdarzenia.evb8, t_zdarzenia.evb9, t_zdarzenia.evb10, t_zdarzenia.date, ');
    tmp.SQL.Add('		t1_probe_liters.liters as zb1, ');
    tmp.SQL.Add('		t2_probe_liters.liters as zb2, ');
    tmp.SQL.Add('		t_cardata.rej_numb, t_cardata.name, t_probe_type.description, ');
    tmp.SQL.Add('		t_komentarze.comment as komentarz, driver_name as kierowca ');
    tmp.SQL.Add('		from device_data t_zdarzenia ');
    tmp.SQL.Add('		  left join car_change t_przesiadki ');
    tmp.SQL.Add('			 on (t_zdarzenia.evb2 = t_przesiadki.id_car and t_zdarzenia.date >= t_przesiadki.start_date ');
    tmp.SQL.Add('							   and (t_zdarzenia.date <= t_przesiadki.end_date or t_przesiadki.end_date is null)) ');
    tmp.SQL.Add('		  left join car t_cardata on (t_cardata.id_car = t_zdarzenia.evb2) ');
    tmp.SQL.Add('		  left join fuel_tank t1_fuel_tank ');
    tmp.SQL.Add('				  on (t1_fuel_tank.id_car = t_cardata.id_car and t1_fuel_tank.tank_nr=1) ');
    tmp.SQL.Add('		  left join probe_liters t1_probe_liters ');
    tmp.SQL.Add('				  on (t1_fuel_tank.id_fuel_tank=t1_probe_liters.id_fuel_tank and t1_probe_liters.id_probe=t_zdarzenia.pal1) ');
    tmp.SQL.Add('		  left join fuel_tank t2_fuel_tank ');
    tmp.SQL.Add('				  on (t2_fuel_tank.id_car = t_cardata.id_car and t2_fuel_tank.tank_nr=2) ');
    tmp.SQL.Add('		  left join probe_liters t2_probe_liters ');
    tmp.SQL.Add('				  on (t2_fuel_tank.id_fuel_tank=t2_probe_liters.id_fuel_tank and t2_probe_liters.id_probe=t_zdarzenia.pal2) ');
    tmp.SQL.Add('		  left join comment t_komentarze ');
    tmp.SQL.Add('				  on (cast(cast(t_zdarzenia.date - 0.5 as integer) as datetime) = t_komentarze.date and t_zdarzenia.evb2 = t_komentarze.id_car) ');
    tmp.SQL.Add('		  left join driver t_kierowcy ');
    tmp.SQL.Add('				  on (t_kierowcy.id_driver = t_przesiadki.id_driver) ');
    tmp.SQL.Add('		  left join probe_type t_probe_type on t_cardata.id_probe_type=t_probe_type.id_probe_type ');
    tmp.SQL.Add('		where evb2 = @car_or_driver_no and ');
    tmp.SQL.Add('			 t_zdarzenia.date >= @start and ');
    tmp.SQL.Add('			 t_zdarzenia.date <= @stop and (t_kierowcy.fired=0 or t_kierowcy.fired is null) and ');
    tmp.SQL.Add('			(evb3 = 36 or evb3 = 37 or evb3 = 38 or evb3 = 39 ');
    tmp.SQL.Add('				 or evb3 = 10 or evb3 = 49 or evb3 = 115 or evb3 = 85 ');
    tmp.SQL.Add('				 or evb3 = 113 or evb3 = 15 or evb3 = 14 or evb3 = 171 or evb3 = 172 or evb3 = 173) ');
    tmp.SQL.Add('		order by t_zdarzenia.id_device_data ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		select @num_records = count(*) ');
    tmp.SQL.Add('			from device_data ');
    tmp.SQL.Add('			where evb2 = @car_or_driver_no and ');
    tmp.SQL.Add('				 date >= @start and ');
    tmp.SQL.Add('				 date <= @stop and ');
    tmp.SQL.Add('				(evb3 = 36 or evb3 = 37 or evb3 = 38 or evb3 = 39 ');
    tmp.SQL.Add('					 or evb3 = 10 or evb3 = 49 or evb3 = 115 or evb3 = 85 ');
    tmp.SQL.Add('					 or evb3 = 113 or evb3 = 15 or evb3 = 14 or evb3 = 171 or evb3 = 172 or evb3 = 173) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	end ');
    tmp.SQL.Add('	else ');
    tmp.SQL.Add('	begin ');
    tmp.SQL.Add('		declare zdarzenia_gps_cr cursor for ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		select t_zdarzenia.id_device_data,t_zdarzenia.evb1, t_zdarzenia.evb2, t_zdarzenia.evb3, t_zdarzenia.evb4, t_zdarzenia.evb5, t_zdarzenia.evb6, t_zdarzenia.evb7, t_zdarzenia.evb8, t_zdarzenia.evb9, t_zdarzenia.evb10, t_zdarzenia.date, ');
    tmp.SQL.Add('		t1_probe_liters.liters as zb1, ');
    tmp.SQL.Add('		t2_probe_liters.liters as zb2, ');
    tmp.SQL.Add('		t_cardata.rej_numb, t_cardata.name, t_probe_type.description, ');
    tmp.SQL.Add('		t_komentarze.comment as komentarz, t_kierowcy.driver_name as kierowca ');
    tmp.SQL.Add('		from device_data t_zdarzenia ');
    tmp.SQL.Add('		  inner join car_change t_przesiadki ');
    tmp.SQL.Add('			 on (t_zdarzenia.evb2 = t_przesiadki.id_car and t_zdarzenia.date >= t_przesiadki.start_date ');
    tmp.SQL.Add('							   and (t_zdarzenia.date <= t_przesiadki.end_date or t_przesiadki.end_date is null)) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		  left join car t_cardata on (t_cardata.id_car = t_zdarzenia.evb2) ');
    tmp.SQL.Add('		  left join fuel_tank t1_fuel_tank ');
    tmp.SQL.Add('				  on (t1_fuel_tank.id_car = t_cardata.id_car and t1_fuel_tank.tank_nr=1) ');
    tmp.SQL.Add('		  left join probe_liters t1_probe_liters ');
    tmp.SQL.Add('				  on (t1_fuel_tank.id_fuel_tank=t1_probe_liters.id_fuel_tank and t1_probe_liters.id_probe=t_zdarzenia.pal1) ');
    tmp.SQL.Add('		  left join fuel_tank t2_fuel_tank ');
    tmp.SQL.Add('				  on (t2_fuel_tank.id_car = t_cardata.id_car and t2_fuel_tank.tank_nr=2) ');
    tmp.SQL.Add('		  left join probe_liters t2_probe_liters ');
    tmp.SQL.Add('				  on (t2_fuel_tank.id_fuel_tank=t2_probe_liters.id_fuel_tank and t2_probe_liters.id_probe=t_zdarzenia.pal2) ');
    tmp.SQL.Add('		  left join comment t_komentarze ');
    tmp.SQL.Add('				  on (cast(cast(t_zdarzenia.date - 0.5 as integer) as datetime) = t_komentarze.date and t_zdarzenia.evb2 = t_komentarze.id_car) ');
    tmp.SQL.Add('		  left join driver t_kierowcy ');
    tmp.SQL.Add('				  on (t_kierowcy.id_driver = t_przesiadki.id_driver) ');
    tmp.SQL.Add('		  left join probe_type t_probe_type ');
    tmp.SQL.Add('				  on (t_probe_type.id_probe_type=t_cardata.id_probe_type) ');
    tmp.SQL.Add('		where t_przesiadki.id_driver = @car_or_driver_no and ');
    tmp.SQL.Add('			 t_zdarzenia.date >= @start and ');
    tmp.SQL.Add('			 t_zdarzenia.date <= @stop and (t_kierowcy.fired is null or t_kierowcy.fired = 0) and ');
    tmp.SQL.Add('			(t_zdarzenia.evb3 = 36 or t_zdarzenia.evb3 = 37 or t_zdarzenia.evb3 = 38 or t_zdarzenia.evb3 = 39 ');
    tmp.SQL.Add('				 or t_zdarzenia.evb3 = 10 or t_zdarzenia.evb3 = 49 or t_zdarzenia.evb3 = 115 or ');
    tmp.SQL.Add('				t_zdarzenia.evb3 = 85 or t_zdarzenia.evb3 = 113 or t_zdarzenia.evb3 = 15 or t_zdarzenia.evb3 = 14 or t_zdarzenia.evb3 = 171 or t_zdarzenia.evb3 = 172 or t_zdarzenia.evb3 = 173) ');
    tmp.SQL.Add('		order by t_zdarzenia.id_device_data ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		select @num_records = count(*) ');
    tmp.SQL.Add('		from device_data t1 ');
    tmp.SQL.Add('		  inner join car_change t5 ');
    tmp.SQL.Add('			 on (t1.evb2 = t5.id_car and t1.date >= t5.start_date ');
    tmp.SQL.Add('							   and (t1.date <= t5.end_date or t5.end_date is null)) ');
    tmp.SQL.Add('		where t5.id_driver = @car_or_driver_no and ');
    tmp.SQL.Add('			 t1.date >= @start and ');
    tmp.SQL.Add('			 t1.date <= @stop and ');
    tmp.SQL.Add('			(t1.evb3 = 36 or t1.evb3 = 37 or t1.evb3 = 38 or t1.evb3 = 39 or ');
    tmp.SQL.Add('				t1.evb3 = 10 or t1.evb3 = 49 or t1.evb3 = 115 or ');
    tmp.SQL.Add('				t1.evb3 = 85 or t1.evb3 = 113 or t1.evb3 = 15 or t1.evb3 = 14 or ');
    tmp.SQL.Add('				t1.evb3 = 171 or t1.evb3 = 172 or t1.evb3 = 173) ');
    tmp.SQL.Add('	end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('    declare @id integer ');
    tmp.SQL.Add('    declare @evb1 integer ');
    tmp.SQL.Add('    declare @evb2 integer ');
    tmp.SQL.Add('    declare @evb3 integer ');
    tmp.SQL.Add('    declare @evb4 integer ');
    tmp.SQL.Add('    declare @evb5 integer ');
    tmp.SQL.Add('    declare @evb6 integer ');
    tmp.SQL.Add('    declare @evb7 integer ');
    tmp.SQL.Add('    declare @evb8 integer ');
    tmp.SQL.Add('    declare @evb9 integer ');
    tmp.SQL.Add('    declare @evb10 integer ');
    tmp.SQL.Add('    declare @evdata datetime ');
    tmp.SQL.Add('	declare @zb1 numeric(10, 3) ');
    tmp.SQL.Add('	declare @zb2 numeric(10, 3) ');
    tmp.SQL.Add('    declare @rej_numb varchar(200) ');
    tmp.SQL.Add('    declare @name varchar(200) ');
    tmp.SQL.Add('	declare @sonda varchar(5) ');
    tmp.SQL.Add('	declare @komentarz varchar(7000) ');
    tmp.SQL.Add('	declare @kierowca varchar(100) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	declare @L_evdata datetime ');
    tmp.SQL.Add('	declare @L_evb2 integer ');
    tmp.SQL.Add('	declare @L_evb3 integer ');
    tmp.SQL.Add('	declare @L_szerokosc numeric(15, 8) ');
    tmp.SQL.Add('	declare @L_dlugosc numeric(15, 8) ');
    tmp.SQL.Add('	declare @L_opis varchar(200) ');
    tmp.SQL.Add('	declare @L_komentarz varchar(7000) ');
    tmp.SQL.Add('	declare @L_dataczas varchar(20) ');
    tmp.SQL.Add('	declare @L_czy_w_czasie_jazdy integer ');
    tmp.SQL.Add('	declare @L_droga_dyn numeric(10, 3) ');
    tmp.SQL.Add('	declare @L_zb1 numeric(10, 3) ');
    tmp.SQL.Add('	declare @L_zb2 numeric(10, 3) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	set @L_evdata = null ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	declare @licznik int ');
    tmp.SQL.Add('	declare @last_szer numeric(15, 8) ');
    tmp.SQL.Add('	declare @last_dl numeric(15, 8) ');
    tmp.SQL.Add('	declare @czy_w_czasie_jazdy int ');
    tmp.SQL.Add('	declare @szerokosc numeric(15, 8) ');
    tmp.SQL.Add('	declare @dlugosc numeric(15, 8) ');
    tmp.SQL.Add('	declare @droga_dyn numeric(10, 3) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('    set @licznik = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('    set @last_szer = 0.0 ');
    tmp.SQL.Add('    set @last_dl = 0.0 ');
    tmp.SQL.Add('    set @czy_w_czasie_jazdy = 0 ');
    tmp.SQL.Add('    set @szerokosc = 0.0 ');
    tmp.SQL.Add('    set @dlugosc = 0.0 ');
    tmp.SQL.Add('    set @droga_dyn = 0.0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	declare @kiedy10 datetime ');
    tmp.SQL.Add('	set @kiedy10 = null ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('    declare @ss integer ');
    tmp.SQL.Add('    declare @sek integer ');
    tmp.SQL.Add('    declare @mm integer ');
    tmp.SQL.Add('    declare @dd numeric(15, 10) ');
    tmp.SQL.Add('    declare @ddd numeric(15, 10) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	create table #zdarzenia_gps ');
    tmp.SQL.Add('	( ');
    tmp.SQL.Add('		id int not null identity(1, 1), ');
    tmp.SQL.Add('		evdata datetime, ');
    tmp.SQL.Add('		evb2 int, ');
    tmp.SQL.Add('		evb3 int, ');
    tmp.SQL.Add('		szerokosc varchar(30), ');
    tmp.SQL.Add('		dlugosc varchar(30), ');
    tmp.SQL.Add('		opis varchar(200), ');
    tmp.SQL.Add('		komentarz varchar(7000), ');
    tmp.SQL.Add('		dataczas varchar(20), ');
    tmp.SQL.Add('		czy_w_czasie_jazdy int, ');
    tmp.SQL.Add('		droga_dyn numeric(10, 3), ');
    tmp.SQL.Add('		zb1 numeric(10, 3), ');
    tmp.SQL.Add('		zb2 numeric(10, 3), ');
    tmp.SQL.Add('		primary key(id) ');
    tmp.SQL.Add('	) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	declare @opis varchar(200) ');
    tmp.SQL.Add('	declare @dataczas varchar(20) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('    declare @sek11 integer ');
    tmp.SQL.Add('    declare @sek21 integer ');
    tmp.SQL.Add('    declare @sek12 integer ');
    tmp.SQL.Add('    declare @sek22 integer ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	declare @drugi_przebieg integer ');
    tmp.SQL.Add('	set @drugi_przebieg = 0 ');
    tmp.SQL.Add('  declare @canceled bit ');
    tmp.SQL.Add('  set @canceled = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('    set @drugi_przebieg = 0 ');
    tmp.SQL.Add('    while @drugi_przebieg <= 1 ');
    tmp.SQL.Add('    begin ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('    open zdarzenia_gps_cr ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('    fetch zdarzenia_gps_cr into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, ');
    tmp.SQL.Add('            @evb8, @evb9, @evb10, @evdata, @zb1, @zb2, ');
    tmp.SQL.Add('			@rej_numb, @name, @sonda, @komentarz, @kierowca ');
    tmp.SQL.Add('	exec sp_progress_set @id_progress, @num_records, @num_records, @canceled output; ');
    tmp.SQL.Add('    while (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('    begin ');
    tmp.SQL.Add('		if @evb3 = 10 ');
    tmp.SQL.Add('			set @kiedy10 = @evdata ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		if @evb3 = 10 or @evb3 = 113 ');
    tmp.SQL.Add('			set @czy_w_czasie_jazdy = 1 ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('		if @evb3 = 49 or @evb3 = 115 or @evb3 = 85 ');
    tmp.SQL.Add('			set @czy_w_czasie_jazdy = 0 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		if @evb3 = 10 ');
    tmp.SQL.Add('			set @droga_dyn = 0 ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('		if @evb3 = 113 ');
    tmp.SQL.Add('			exec spDroga @evb2, @evb1, @evb10, @droga_dyn OUTPUT ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('		if @evb3 = 85 ');
    tmp.SQL.Add('			exec spDroga @evb2, @evb9, @evb10, @droga_dyn OUTPUT ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		if (@evb3 = 15) and (@szerokosc <> 0.0) and (@dlugosc <> 0.0) and (@nested = 0) ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			set @dataczas = ');
    tmp.SQL.Add('				dbo.spDoDwochZnakowf(LTRIM(STR(DATEPART(hour, @evdata)))) + '':'' + ');
    tmp.SQL.Add('				dbo.spDoDwochZnakowf(LTRIM(STR(DATEPART(minute, @evdata)))) + '' '' + ');
    tmp.SQL.Add('				LTRIM(STR(YEAR(@evdata))) + ''-'' + ');
    tmp.SQL.Add('				dbo.spDoDwochZnakowf(LTRIM(STR(MONTH(@evdata)))) + ''-'' + ');
    tmp.SQL.Add('				dbo.spDoDwochZnakowf(LTRIM(STR(DAY(@evdata)))) ');
    tmp.SQL.Add('			set @opis = ''Poczatek wylaczenia zasilania: '' + @dataczas ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			if @drugi_przebieg = 0 ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				insert into #zdarzenia_gps (evdata, evb2, evb3, ');
    tmp.SQL.Add('					szerokosc, dlugosc, opis, komentarz, dataczas, ');
    tmp.SQL.Add('					czy_w_czasie_jazdy, droga_dyn, zb1, zb2) ');
    tmp.SQL.Add('				values(@evdata, @evb2, @evb3, cast(@szerokosc as varchar(30)), cast(@dlugosc as varchar(30)), ');
    tmp.SQL.Add('				@opis, @komentarz, @dataczas, @czy_w_czasie_jazdy, @droga_dyn, @zb1, @zb2) ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		if (@evb3 = 14) or (@evb3 = 171) or (@evb3 = 172) or (@evb3 = 173) ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('		    set @last_szer = 0.0 ');
    tmp.SQL.Add('			set @last_dl = 0.0 ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		if ((@dodaj_pozycje = 1) or (@nested = 0)) begin ');
    tmp.SQL.Add('		if (@evb3 = 38) and (@evb1 = 65) and ');
    tmp.SQL.Add('		   (@evb4 >= 48) and (@evb4 <= 57) and ');
    tmp.SQL.Add('           (@evb5 >= 48) and (@evb5 <= 57) and ');
    tmp.SQL.Add('           (@evb6 >= 48) and (@evb6 <= 57) and ');
    tmp.SQL.Add('           (@evb7 >= 48) and (@evb7 <= 57) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('            select @sek11 = FLOOR(@evb8 / 16) - 3 ');
    tmp.SQL.Add('            select @sek21 = (@evb8 - (FLOOR(@evb8 / 16) * 16)) - 3 ');
    tmp.SQL.Add('            select @sek12 = FLOOR(@evB9 / 16) - 3 ');
    tmp.SQL.Add('            select @sek22 = (@evb9 - (FLOOR(@evb9 / 16) * 16)) - 3 ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('            if (@sek11 >= 0) and (@sek11 <= 9) and (@sek21 >= 0) and (@sek21 <= 9) ');
    tmp.SQL.Add('                    and (@sek12 >= 0) and (@sek12 <= 9) and (@sek22 >= 0) ');
    tmp.SQL.Add('                    and (@sek22 <= 9) ');
    tmp.SQL.Add('            begin ');
    tmp.SQL.Add('                select @szerokosc = CAST(CHAR(@evb4) + CHAR(@evb5) as integer) + ');
    tmp.SQL.Add('                  (CAST(CHAR(@evb6) + CHAR(@evb7) as integer) / 60.0) ');
    tmp.SQL.Add('                select @szerokosc = @szerokosc + ');
    tmp.SQL.Add('                    (CAST((LTRIM(STR(@sek11)) + LTRIM(STR(@sek21)) + ');
    tmp.SQL.Add('                    LTRIM(STR(@sek12)) + LTRIM(STR(@sek22))) as integer) / 600000.0) ');
    tmp.SQL.Add('                if CHAR(@evb10) = ''S'' ');
    tmp.SQL.Add('                    select @szerokosc = @szerokosc * (-1) ');
    tmp.SQL.Add('            end ');
    tmp.SQL.Add('            else ');
    tmp.SQL.Add('            begin ');
    tmp.SQL.Add('                select @szerokosc = CAST((CHAR(@evb4) + ');
    tmp.SQL.Add('                        CHAR(@evb5)) as integer) + ');
    tmp.SQL.Add('                  (CAST((CHAR(@evb6) + ');
    tmp.SQL.Add('                        CHAR(@evb7)) as integer) / 60.0) ');
    tmp.SQL.Add('                if CHAR(@evb10) = ''S'' ');
    tmp.SQL.Add('                    select @szerokosc = @szerokosc * (-1.0) ');
    tmp.SQL.Add('            end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		    fetch zdarzenia_gps_cr into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, ');
    tmp.SQL.Add('				@evb8, @evb9, @evb10, @evdata, @zb1, @zb2, ');
    tmp.SQL.Add('				@rej_numb, @name, @sonda, @komentarz, @kierowca ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			set @licznik = @licznik + 1 ');
    tmp.SQL.Add('			if (@licznik % 10 = 0) ');
    tmp.SQL.Add('			exec sp_progress_set @id_progress, @licznik, @num_records, @canceled output; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			if (@evb3 = 39) and ');
    tmp.SQL.Add('			   (@evb4 >= 48) and (@evb4 <= 57) and ');
    tmp.SQL.Add('			   (@evb5 >= 48) and (@evb5 <= 57) and ');
    tmp.SQL.Add('			   (@evb6 >= 48) and (@evb6 <= 57) and ');
    tmp.SQL.Add('			   (@evb7 >= 48) and (@evb7 <= 57) and ');
    tmp.SQL.Add('			   (@evb8 >= 48) and (@evb8 <= 57) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				select @sek11 = FLOOR(@evb1 / 16) - 3 ');
    tmp.SQL.Add('				select @sek21 = (@evb1 - (FLOOR(@evb1 / 16) * 16)) - 3; ');
    tmp.SQL.Add('				select @sek12 = FLOOR(@evB9 / 16) - 3; ');
    tmp.SQL.Add('				select @sek22 = (@evb9 - (FLOOR(@evb9 / 16) * 16)) - 3; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@sek11 >= 0) and (@sek11 <= 9) and (@sek21 >= 0) and (@sek21 <= 9) ');
    tmp.SQL.Add('						and (@sek12 >= 0) and (@sek12 <= 9) and (@sek22 >= 0) ');
    tmp.SQL.Add('						and (@sek22 <= 9) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					select @dlugosc = CAST((CHAR(@evb4) + ');
    tmp.SQL.Add('							CHAR(@evb5) + CHAR(@evb6)) as integer) + ');
    tmp.SQL.Add('					  (CAST((CHAR(@evb7) + ');
    tmp.SQL.Add('							CHAR(@evb8)) as integer) / 60.0) + ');
    tmp.SQL.Add('					  (CAST((LTRIM(STR(@sek11)) + LTRIM(STR(@sek21)) + ');
    tmp.SQL.Add('						LTRIM(STR(@sek12)) + LTRIM(STR(@sek22))) as integer) / 600000.0) ');
    tmp.SQL.Add('					if CHAR(@evb10) = ''W'' ');
    tmp.SQL.Add('						select @dlugosc = @dlugosc * (-1.0) ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					select @dlugosc = CAST((CHAR(@evb4) + ');
    tmp.SQL.Add('							CHAR(@evb5) + CHAR(@evb6)) as integer) + ');
    tmp.SQL.Add('					  (CAST((CHAR(@evb7) + ');
    tmp.SQL.Add('							CHAR(@evb8)) as integer) / 60.0) ');
    tmp.SQL.Add('					if CHAR(@evb10) = ''W'' ');
    tmp.SQL.Add('						select @dlugosc = @dlugosc * (-1.0) ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if (@last_szer = 0.0) and (@szerokosc <> 0.0) ');
    tmp.SQL.Add('					select @last_szer = @szerokosc ');
    tmp.SQL.Add('				if (@last_dl = 0.0) and (@dlugosc <> 0.0) ');
    tmp.SQL.Add('					select @last_dl = @dlugosc ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if ((abs(@last_szer - @szerokosc) < 1.0) and ');
    tmp.SQL.Add('                   (abs(@last_dl - @dlugosc) < 1.0) or ');
    tmp.SQL.Add('				   (@kiedy10 is not null)) and ');
    tmp.SQL.Add('					  (@dlugosc <> 0.0) and (@szerokosc <> 0.0) ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					select @last_szer = @szerokosc ');
    tmp.SQL.Add('					select @last_dl = @dlugosc ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					set @dataczas = ');
    tmp.SQL.Add('						dbo.spDoDwochZnakowf(LTRIM(STR(DATEPART(hour, @evdata)))) + '':'' + ');
    tmp.SQL.Add('						dbo.spDoDwochZnakowf(LTRIM(STR(DATEPART(minute, @evdata)))) + '' '' + ');
    tmp.SQL.Add('						LTRIM(STR(YEAR(@evdata))) + ''-'' + ');
    tmp.SQL.Add('						dbo.spDoDwochZnakowf(LTRIM(STR(MONTH(@evdata)))) + ''-'' + ');
    tmp.SQL.Add('						dbo.spDoDwochZnakowf(LTRIM(STR(DAY(@evdata)))) ');
    tmp.SQL.Add('					set @opis = '''' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('					if @drugi_przebieg = 0 ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						insert into #zdarzenia_gps (evdata, evb2, evb3, ');
    tmp.SQL.Add('							szerokosc, dlugosc, opis, komentarz, dataczas, ');
    tmp.SQL.Add('							czy_w_czasie_jazdy, droga_dyn, zb1, zb2) ');
    tmp.SQL.Add('						values(@evdata, @evb2, @evb3, cast(@szerokosc as varchar(30)), cast(@dlugosc as varchar(30)), @opis, ');
    tmp.SQL.Add('						@komentarz, @dataczas, @czy_w_czasie_jazdy, @droga_dyn, @zb1, @zb2) ');
    tmp.SQL.Add('						set @kiedy10 = null ');
    tmp.SQL.Add('					end ');
    tmp.SQL.Add('					else ');
    tmp.SQL.Add('					begin ');
    tmp.SQL.Add('						set @L_evdata = @evdata; ');
    tmp.SQL.Add('						set @L_evb2 = @evb2; ');
    tmp.SQL.Add('						set @L_evb3 = @evb3; ');
    tmp.SQL.Add('						set @L_szerokosc = @szerokosc; ');
    tmp.SQL.Add('						set @L_dlugosc = @dlugosc; ');
    tmp.SQL.Add('						set @L_opis = @opis; ');
    tmp.SQL.Add('						set @L_komentarz = @komentarz; ');
    tmp.SQL.Add('						set @L_dataczas = @dataczas; ');
    tmp.SQL.Add('						set @L_czy_w_czasie_jazdy = @czy_w_czasie_jazdy; ');
    tmp.SQL.Add('						set @L_droga_dyn = @droga_dyn; ');
    tmp.SQL.Add('						set @L_zb1 = @zb1; ');
    tmp.SQL.Add('						set @L_zb2 = @zb2; ');
    tmp.SQL.Add('					end; ');
    tmp.SQL.Add('					set @dodaj_pozycje = 0 ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('		end end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('        if ((@dodaj_pozycje = 1) or (@nested = 0)) begin ');
    tmp.SQL.Add('        if (@evb3 = 36) ');
    tmp.SQL.Add('        begin ');
    tmp.SQL.Add('            select @szerokosc = 0.0; ');
    tmp.SQL.Add('			if (@evb4 >= 48) and ');
    tmp.SQL.Add('                    (@evb4 <= 57) and ');
    tmp.SQL.Add('                (@evb5 >= 48) and ');
    tmp.SQL.Add('                    (@evb5 <= 57) and ');
    tmp.SQL.Add('                (@evb6 >= 48) and ');
    tmp.SQL.Add('                    (@evb6 <= 57) and ');
    tmp.SQL.Add('                (@evb7 >= 48) and ');
    tmp.SQL.Add('                    (@evb7 <= 57) and ');
    tmp.SQL.Add('                (@evb8 >= 48) and ');
    tmp.SQL.Add('                    (@evb8 <= 57) and ');
    tmp.SQL.Add('                (@evb9 >= 48) and ');
    tmp.SQL.Add('                    (@evb9 <= 57) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('            begin ');
    tmp.SQL.Add('                select @ss = CAST((CHAR(@evb4) + ');
    tmp.SQL.Add('                        CHAR(@evb5)) as integer) ');
    tmp.SQL.Add('                select @sek = CAST((CHAR(@evb8) + ');
    tmp.SQL.Add('                        CHAR(@evb9)) as integer) ');
    tmp.SQL.Add('                select @mm = CAST((CHAR(@evb6) + ');
    tmp.SQL.Add('                        CHAR(@evb7)) as integer) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('                if (@ss >= 0) and (@ss <= 90) and (@sek <= 99) and (@mm >= 0) and ');
    tmp.SQL.Add('                    (@mm <= 59) ');
    tmp.SQL.Add('                begin ');
    tmp.SQL.Add('                    select @dd = (@mm*100/60)/100.0 + (@sek*100/60)/10000.0 ');
    tmp.SQL.Add('                    select @szerokosc = FLOOR((@ss+@dd) * 1000000.0) / 1000000.0 ');
    tmp.SQL.Add('		            if (@evb10 = 83) ');
    tmp.SQL.Add('						select @szerokosc = @szerokosc * (-1.0) ');
    tmp.SQL.Add('                end ');
    tmp.SQL.Add('            end; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		    fetch zdarzenia_gps_cr into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, ');
    tmp.SQL.Add('				@evb8, @evb9, @evb10, @evdata, @zb1, @zb2, ');
    tmp.SQL.Add('				@rej_numb, @name, @sonda, @komentarz, @kierowca ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			set @licznik = @licznik + 1 ');
    tmp.SQL.Add('			if (@licznik % 10 = 0) ');
    tmp.SQL.Add('			exec sp_progress_set @id_progress, @licznik, @num_records, @canceled output; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('            select @dlugosc = 0.0 ');
    tmp.SQL.Add('            if (@evb3 = 37) and (@evb4 >= 48) and ');
    tmp.SQL.Add('                    (@evb4 <= 57) and ');
    tmp.SQL.Add('                (@evb5 >= 48) and ');
    tmp.SQL.Add('                    (@evb5 <= 57) and ');
    tmp.SQL.Add('                (@evb6 >= 48) and ');
    tmp.SQL.Add('                    (@evb6 <= 57) and ');
    tmp.SQL.Add('                (@evb7 >= 48) and ');
    tmp.SQL.Add('                    (@evb7 <= 57) and ');
    tmp.SQL.Add('                (@evb8 >= 48) and ');
    tmp.SQL.Add('                    (@evb8 <= 57) and ');
    tmp.SQL.Add('                (@evb9 >= 48) and ');
    tmp.SQL.Add('                    (@evb9 <= 57) ');
    tmp.SQL.Add('            begin ');
    tmp.SQL.Add('                select @dd = CAST((CHAR(@evb4) + ');
    tmp.SQL.Add('                        CHAR(@evb5) + CHAR(@evb6)) as integer) ');
    tmp.SQL.Add('                select @sek = CAST((CHAR(@evb9) + ''0'') as integer) ');
    tmp.SQL.Add('                select @mm = CAST((CHAR(@evb7) + ');
    tmp.SQL.Add('                        CHAR(@evb8)) as integer) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('                if (@dd >= 0) and (@dd <= 180) and (@sek <= 99) and (@mm >= 0) and ');
    tmp.SQL.Add('                    (@mm <= 60) and (@sek <= 99) ');
    tmp.SQL.Add('                begin ');
    tmp.SQL.Add('                    select @ddd = (@mm*100/60)/100.0 + (@sek*100/60)/10000.0 ');
    tmp.SQL.Add('                    select @dlugosc = FLOOR((@dd+@ddd) * 1000000.0) / 1000000.0 ');
    tmp.SQL.Add('					If @evb10 = 87 ');
    tmp.SQL.Add('						select @dlugosc = @dlugosc * (-1.0) ');
    tmp.SQL.Add('                end ');
    tmp.SQL.Add('            end ');
    tmp.SQL.Add('			if (@szerokosc <> 0.0) and (@dlugosc <> 0.0) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				set @dataczas = ');
    tmp.SQL.Add('					dbo.spDoDwochZnakowf(LTRIM(STR(DATEPART(hour, @evdata)))) + '':'' + ');
    tmp.SQL.Add('					dbo.spDoDwochZnakowf(LTRIM(STR(DATEPART(minute, @evdata)))) + '' '' + ');
    tmp.SQL.Add('					LTRIM(STR(YEAR(@evdata))) + ''-'' + ');
    tmp.SQL.Add('					dbo.spDoDwochZnakowf(LTRIM(STR(MONTH(@evdata)))) + ''-'' + ');
    tmp.SQL.Add('					dbo.spDoDwochZnakowf(LTRIM(STR(DAY(@evdata)))) ');
    tmp.SQL.Add('				set @opis = '''' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('				if @drugi_przebieg = 0 ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					insert into #zdarzenia_gps (evdata, evb2, evb3, ');
    tmp.SQL.Add('						szerokosc, dlugosc, opis, komentarz, dataczas, ');
    tmp.SQL.Add('						czy_w_czasie_jazdy, droga_dyn, zb1, zb2) ');
    tmp.SQL.Add('					values(@evdata, @evb2, @evb3, cast(@szerokosc as varchar(30)), cast(@dlugosc as varchar(30)), @opis, ');
    tmp.SQL.Add('					@komentarz, @dataczas, @czy_w_czasie_jazdy, @droga_dyn, @zb1, @zb2) ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				else ');
    tmp.SQL.Add('				begin ');
    tmp.SQL.Add('					set @L_evdata = @evdata; ');
    tmp.SQL.Add('					set @L_evb2 = @evb2; ');
    tmp.SQL.Add('					set @L_evb3 = @evb3; ');
    tmp.SQL.Add('					set @L_szerokosc = @szerokosc; ');
    tmp.SQL.Add('					set @L_dlugosc = @dlugosc; ');
    tmp.SQL.Add('					set @L_opis = @opis; ');
    tmp.SQL.Add('					set @L_komentarz = @komentarz; ');
    tmp.SQL.Add('					set @L_dataczas = @dataczas; ');
    tmp.SQL.Add('					set @L_czy_w_czasie_jazdy = @czy_w_czasie_jazdy; ');
    tmp.SQL.Add('					set @L_droga_dyn = @droga_dyn; ');
    tmp.SQL.Add('					set @L_zb1 = @zb1; ');
    tmp.SQL.Add('					set @L_zb2 = @zb2; ');
    tmp.SQL.Add('				end ');
    tmp.SQL.Add('				set @dodaj_pozycje = 0 ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('        end end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		if (@evb3 = 49) or (@evb3 = 115) or (@evb3 = 10) or (@nested = 0) ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			set @dodaj_pozycje = 1 ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('		set @licznik = @licznik + 1 ');
    tmp.SQL.Add('		if (@licznik % 10 = 0) ');
    tmp.SQL.Add('		exec sp_progress_set @id_progress, @licznik, @num_records, @canceled output; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	    fetch zdarzenia_gps_cr into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, ');
    tmp.SQL.Add('            @evb8, @evb9, @evb10, @evdata, @zb1, @zb2, ');
    tmp.SQL.Add('			@rej_numb, @name, @sonda, @komentarz, @kierowca ');
    tmp.SQL.Add('	end ');
    tmp.SQL.Add('    close zdarzenia_gps_cr ');
    tmp.SQL.Add('    deallocate zdarzenia_gps_cr ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	if (@drugi_przebieg = 1) and (@L_evdata is not null) ');
    tmp.SQL.Add('	begin ');
    tmp.SQL.Add('		insert into #zdarzenia_gps (evdata, evb2, evb3, ');
    tmp.SQL.Add('			szerokosc, dlugosc, opis, komentarz, dataczas, ');
    tmp.SQL.Add('			czy_w_czasie_jazdy, droga_dyn, zb1, zb2) ');
    tmp.SQL.Add('		values(@L_evdata, @L_evb2, 123, cast(@L_szerokosc as varchar(30)), ');
    tmp.SQL.Add('		cast(@L_dlugosc as varchar(30)), @L_opis, ');
    tmp.SQL.Add('		@L_komentarz, @L_dataczas, @L_czy_w_czasie_jazdy, @L_droga_dyn, @L_zb1, @L_zb2) ');
    tmp.SQL.Add('	end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	select @result_count = count(*) from #zdarzenia_gps ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	if (@result_count = 0) and (@ShowLastPostionIfNone = 1) and (@drugi_przebieg = 0) and (@nested = 0) ');
    tmp.SQL.Add('	begin ');
    tmp.SQL.Add('		if @isInCarMode = 1 ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			declare zdarzenia_gps_cr cursor for ');
    tmp.SQL.Add('			select top 500 t_zdarzenia.id_device_data,t_zdarzenia.evb1, t_zdarzenia.evb2, t_zdarzenia.evb3, t_zdarzenia.evb4, t_zdarzenia.evb5, t_zdarzenia.evb6, t_zdarzenia.evb7, t_zdarzenia.evb8, t_zdarzenia.evb9, t_zdarzenia.evb10, t_zdarzenia.date, ');
    tmp.SQL.Add('			t1_probe_liters.liters as zb1, ');
    tmp.SQL.Add('			t2_probe_liters.liters as zb2, ');
    tmp.SQL.Add('			t_cardata.rej_numb, t_cardata.name, t_probe_type.description, ');
    tmp.SQL.Add('			t_komentarze.comment as komentarz, driver_name as kierowca ');
    tmp.SQL.Add('			from device_data t_zdarzenia ');
    tmp.SQL.Add('			  left join car_change t_przesiadki ');
    tmp.SQL.Add('				 on (t_zdarzenia.evb2 = t_przesiadki.id_car and t_zdarzenia.date >= t_przesiadki.start_date ');
    tmp.SQL.Add('								   and (t_zdarzenia.date <= t_przesiadki.end_date or t_przesiadki.end_date is null)) ');
    tmp.SQL.Add('			  left join car t_cardata on (t_cardata.id_car = t_zdarzenia.evb2) ');
    tmp.SQL.Add('			  left join fuel_tank t1_fuel_tank ');
    tmp.SQL.Add('					  on (t1_fuel_tank.id_car = t_cardata.id_car and t1_fuel_tank.tank_nr=1) ');
    tmp.SQL.Add('			  left join probe_liters t1_probe_liters ');
    tmp.SQL.Add('					  on (t1_fuel_tank.id_fuel_tank=t1_probe_liters.id_fuel_tank and t1_probe_liters.id_probe=t_zdarzenia.pal1) ');
    tmp.SQL.Add('			  left join fuel_tank t2_fuel_tank ');
    tmp.SQL.Add('					  on (t2_fuel_tank.id_car = t_cardata.id_car and t2_fuel_tank.tank_nr=2) ');
    tmp.SQL.Add('			  left join probe_liters t2_probe_liters ');
    tmp.SQL.Add('					  on (t2_fuel_tank.id_fuel_tank=t2_probe_liters.id_fuel_tank and t2_probe_liters.id_probe=t_zdarzenia.pal2) ');
    tmp.SQL.Add('			  left join comment t_komentarze ');
    tmp.SQL.Add('					  on (cast(cast(t_zdarzenia.date - 0.5 as integer) as datetime) = t_komentarze.date and t_zdarzenia.evb2 = t_komentarze.id_car) ');
    tmp.SQL.Add('			  left join driver t_kierowcy ');
    tmp.SQL.Add('					  on (t_kierowcy.id_driver = t_przesiadki.id_driver) ');
    tmp.SQL.Add('			  left join probe_type t_probe_type on t_cardata.id_probe_type=t_probe_type.id_probe_type ');
    tmp.SQL.Add('			where evb2 = @car_or_driver_no and ');
    tmp.SQL.Add('				 t_zdarzenia.date < @start and ');
    tmp.SQL.Add('				 (t_kierowcy.fired=0 or t_kierowcy.fired is null) and ');
    tmp.SQL.Add('				(evb3 = 36 or evb3 = 37 or evb3 = 38 or evb3 = 39 ');
    tmp.SQL.Add('					 or evb3 = 10 or evb3 = 49 or evb3 = 115 or evb3 = 85 ');
    tmp.SQL.Add('					 or evb3 = 113 or evb3 = 15 or evb3 = 14 or evb3 = 171 or evb3 = 172 or evb3 = 173) ');
    tmp.SQL.Add('			order by t_zdarzenia.id_device_data ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			select @num_records = 500 ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add('		else ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			declare zdarzenia_gps_cr cursor for ');
    tmp.SQL.Add('			select top 500 t_zdarzenia.id_device_data,t_zdarzenia.evb1, t_zdarzenia.evb2, t_zdarzenia.evb3, t_zdarzenia.evb4, t_zdarzenia.evb5, t_zdarzenia.evb6, t_zdarzenia.evb7, t_zdarzenia.evb8, t_zdarzenia.evb9, t_zdarzenia.evb10, t_zdarzenia.date, ');
    tmp.SQL.Add('			t1_probe_liters.liters as zb1, ');
    tmp.SQL.Add('			t2_probe_liters.liters as zb2, ');
    tmp.SQL.Add('			t_cardata.rej_numb, t_cardata.name, t_probe_type.description, ');
    tmp.SQL.Add('			t_komentarze.comment as komentarz, t_kierowcy.driver_name as kierowca ');
    tmp.SQL.Add('			from device_data t_zdarzenia ');
    tmp.SQL.Add('			  inner join car_change t_przesiadki ');
    tmp.SQL.Add('				 on (t_zdarzenia.evb2 = t_przesiadki.id_car and t_zdarzenia.date >= t_przesiadki.start_date ');
    tmp.SQL.Add('								   and (t_zdarzenia.date <= t_przesiadki.end_date or t_przesiadki.end_date is null)) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			  left join car t_cardata on (t_cardata.id_car = t_zdarzenia.evb2) ');
    tmp.SQL.Add('			  left join fuel_tank t1_fuel_tank ');
    tmp.SQL.Add('					  on (t1_fuel_tank.id_car = t_cardata.id_car and t1_fuel_tank.tank_nr=1) ');
    tmp.SQL.Add('			  left join probe_liters t1_probe_liters ');
    tmp.SQL.Add('					  on (t1_fuel_tank.id_fuel_tank=t1_probe_liters.id_fuel_tank and t1_probe_liters.id_probe=t_zdarzenia.pal1) ');
    tmp.SQL.Add('			  left join fuel_tank t2_fuel_tank ');
    tmp.SQL.Add('					  on (t2_fuel_tank.id_car = t_cardata.id_car and t2_fuel_tank.tank_nr=2) ');
    tmp.SQL.Add('			  left join probe_liters t2_probe_liters ');
    tmp.SQL.Add('					  on (t2_fuel_tank.id_fuel_tank=t2_probe_liters.id_fuel_tank and t2_probe_liters.id_probe=t_zdarzenia.pal2) ');
    tmp.SQL.Add('			  left join comment t_komentarze ');
    tmp.SQL.Add('					  on (cast(cast(t_zdarzenia.date - 0.5 as integer) as datetime) = t_komentarze.date and t_zdarzenia.evb2 = t_komentarze.id_car) ');
    tmp.SQL.Add('			  left join driver t_kierowcy ');
    tmp.SQL.Add('					  on (t_kierowcy.id_driver = t_przesiadki.id_driver) ');
    tmp.SQL.Add('			  left join probe_type t_probe_type ');
    tmp.SQL.Add('					  on (t_probe_type.id_probe_type=t_cardata.id_probe_type) ');
    tmp.SQL.Add('			where t_przesiadki.id_driver = @car_or_driver_no and ');
    tmp.SQL.Add('				 t_zdarzenia.date < @start and ');
    tmp.SQL.Add('				 (t_kierowcy.fired is null or t_kierowcy.fired = 0) and ');
    tmp.SQL.Add('				(t_zdarzenia.evb3 = 36 or t_zdarzenia.evb3 = 37 or t_zdarzenia.evb3 = 38 or t_zdarzenia.evb3 = 39 ');
    tmp.SQL.Add('					 or t_zdarzenia.evb3 = 10 or t_zdarzenia.evb3 = 49 or t_zdarzenia.evb3 = 115 or ');
    tmp.SQL.Add('					t_zdarzenia.evb3 = 85 or t_zdarzenia.evb3 = 113 or t_zdarzenia.evb3 = 15 or t_zdarzenia.evb3 = 14 or t_zdarzenia.evb3 = 171 or t_zdarzenia.evb3 = 172 or t_zdarzenia.evb3 = 173) ');
    tmp.SQL.Add('			order by t_zdarzenia.id_device_data ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('			select @num_records = 500 ');
    tmp.SQL.Add('		end ');
    tmp.SQL.Add('		set @drugi_przebieg = 1 ');
    tmp.SQL.Add('	end ');
    tmp.SQL.Add('      else ');
    tmp.SQL.Add('        break ');
    tmp.SQL.Add('    end ');
    tmp.SQL.Add('  if @nested = 0 ');
    tmp.SQL.Add('	  exec sp_progress_unregister @id_progress; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('  if @nested = 1 ');
    tmp.SQL.Add('  begin ');
    tmp.SQL.Add('	declare @start_praca_pr datetime ');
    tmp.SQL.Add('	declare @stop_praca_pr datetime ');
    tmp.SQL.Add('	declare @id_pr integer ');
    tmp.SQL.Add('	declare @szerokosc0 varchar(30) ');
    tmp.SQL.Add('	declare @dlugosc0 varchar(30) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	declare czas_pracy_cr cursor for ');
    tmp.SQL.Add('	select id, start_praca, stop_praca from #eksport_day_work ');
    tmp.SQL.Add('	order by id ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	open czas_pracy_cr ');
    tmp.SQL.Add('	fetch czas_pracy_cr into @id_pr, @start_praca_pr, @stop_praca_pr ');
    tmp.SQL.Add('	while (@@fetch_status <> -1) and (@canceled = 0) ');
    tmp.SQL.Add('	begin ');
    tmp.SQL.Add('		select top 1 @szerokosc0 = szerokosc from #zdarzenia_gps where evdata >= @start_praca_pr order by evdata ');
    tmp.SQL.Add('		select top 1 @dlugosc0 = dlugosc from #zdarzenia_gps where evdata >= @start_praca_pr order by evdata ');
    tmp.SQL.Add('		select top 1 @szerokosc = szerokosc from #zdarzenia_gps where evdata >= @stop_praca_pr order by evdata ');
    tmp.SQL.Add('		select top 1 @dlugosc = dlugosc from #zdarzenia_gps where evdata >= @stop_praca_pr order by evdata ');
    tmp.SQL.Add('		update #eksport_day_work set szerokosc = @szerokosc, dlugosc = @dlugosc, szerokosc0 = @szerokosc0, dlugosc0 = @dlugosc0 where id = @id_pr ');
    tmp.SQL.Add('		fetch czas_pracy_cr into @id_pr, @start_praca_pr, @stop_praca_pr ');
    tmp.SQL.Add('	end ');
    tmp.SQL.Add('	close czas_pracy_cr ');
    tmp.SQL.Add('	deallocate czas_pracy_cr ');
    tmp.SQL.Add('  end ');
    tmp.SQL.Add('  else ');
    tmp.SQL.Add('    select * from #zdarzenia_gps order by id; ');

    tmp.ExecSQL();
end;

procedure TTEDEmailSrv.UaktualnijProcedureNietypowe();
begin
    tmp.SQL.Clear();
    tmp.SQL.Add('ALTER procedure [dbo].[sp_nonstandardEvents] ');
    tmp.SQL.Add('    @isInCarMode bit,  ');
    tmp.SQL.Add('    @car_or_driver_no int,  ');
    tmp.SQL.Add('    @start datetime,  ');
    tmp.SQL.Add('    @stop datetime,  ');
    tmp.SQL.Add('    @show17x bit,  ');
    tmp.SQL.Add('    @id_progress bigint,  ');
    tmp.SQL.Add('    @show181 bit = 1,  ');
    tmp.SQL.Add('    @show69  bit = 1,  ');
    tmp.SQL.Add('    @show15  bit = 1,  ');
    tmp.SQL.Add('    @show114 bit = 1,  ');
    tmp.SQL.Add('    @show14  bit = 1,  ');
    tmp.SQL.Add('    @showInputs  bit = 1 , ');
    tmp.SQL.Add('    @exclude_events_longer_than_min int = 0 ');
    tmp.SQL.Add('as  ');
    tmp.SQL.Add('begin  ');
    tmp.SQL.Add('	declare @flag_count int;  ');
    tmp.SQL.Add('	set @flag_count = 0;  ');
    tmp.SQL.Add('	if @show17x = 1  ');
    tmp.SQL.Add('	begin  ');
    tmp.SQL.Add('		set @flag_count = @flag_count + 1;  ');
    tmp.SQL.Add('	end;  ');
    tmp.SQL.Add('	if @show181 = 1  ');
    tmp.SQL.Add('	begin  ');
    tmp.SQL.Add('		set @flag_count = @flag_count + 1;  ');
    tmp.SQL.Add('	end;  ');
    tmp.SQL.Add('	if @show69 = 1  ');
    tmp.SQL.Add('	begin  ');
    tmp.SQL.Add('		set @flag_count = @flag_count + 1;  ');
    tmp.SQL.Add('	end;  ');
    tmp.SQL.Add('	if @show15 = 1  ');
    tmp.SQL.Add('	begin  ');
    tmp.SQL.Add('		set @flag_count = @flag_count + 1;  ');
    tmp.SQL.Add('	end;  ');
    tmp.SQL.Add('	if @show114 = 1  ');
    tmp.SQL.Add('	begin  ');
    tmp.SQL.Add('		set @flag_count = @flag_count + 1;  ');
    tmp.SQL.Add('	end;  ');
    tmp.SQL.Add('	if @show14 = 1  ');
    tmp.SQL.Add('	begin  ');
    tmp.SQL.Add('		set @flag_count = @flag_count + 1;  ');
    tmp.SQL.Add('	end;  ');
    tmp.SQL.Add('	if @showInputs = 1  ');
    tmp.SQL.Add('	begin  ');
    tmp.SQL.Add('		set @flag_count = @flag_count + 1;  ');
    tmp.SQL.Add('	end;  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('	declare @report TABLE  ');
    tmp.SQL.Add('	(  ');
    tmp.SQL.Add('		id int not null identity (1,1),  ');
    tmp.SQL.Add('		data datetime,  ');
    tmp.SQL.Add('		opis nvarchar(50),  ');
    tmp.SQL.Add('		ile varchar(50),  ');
    tmp.SQL.Add('		start datetime,  ');
    tmp.SQL.Add('		stop datetime,  ');
    tmp.SQL.Add('		marka_pojazdu varchar(250),  ');
    tmp.SQL.Add('		nr_rej_pojazdu varchar(10),  ');
    tmp.SQL.Add('		kierowca nvarchar(100),  ');
    tmp.SQL.Add('		group_sec integer,  ');
    tmp.SQL.Add('		group_ggmm varchar(10),  ');
    tmp.SQL.Add('		group_day_sec integer,  ');
    tmp.SQL.Add('		group_day_ggmm varchar(10),  ');
    tmp.SQL.Add('		group_all_sec integer,  ');
    tmp.SQL.Add('		group_all_ggmm varchar(10),  ');
    tmp.SQL.Add('		primary key(id)  ');
    tmp.SQL.Add('	)  ');
    tmp.SQL.Add('	declare @time varchar(50);				-- czas trwania zdarzenia  ');
    tmp.SQL.Add('	declare @car_name varchar(50);			-- nazwa pojazdu  ');
    tmp.SQL.Add('	declare @car_rej varchar(15);			-- numer rejestracyjny pojazdu  ');
    tmp.SQL.Add('	declare @evdescription nvarchar(50);		-- opis (rodzaj) zdarzenia  ');
    tmp.SQL.Add('	declare @driver_name nvarchar(100);		-- nazwa kierowcy  ');
    tmp.SQL.Add('	declare @id_device_data	bigint				-- id zdarzenia  ');
    tmp.SQL.Add('	declare @evb1 tinyint;					-- odpowiednie bajty zdarzen  ');
    tmp.SQL.Add('	declare @evb2 tinyint;  ');
    tmp.SQL.Add('	declare @evb3 tinyint;  ');
    tmp.SQL.Add('	declare @evb4 tinyint;  ');
    tmp.SQL.Add('	declare @evb9 tinyint;  ');
    tmp.SQL.Add('	declare @evb10 tinyint;  ');
    tmp.SQL.Add('	declare @event_start datetime;				-- czas rozpoczecia zdarzenia  ');
    tmp.SQL.Add('	declare @event_stop datetime;				-- czas zakonczenia zdarzenia  ');
    tmp.SQL.Add('	declare @date datetime;						-- data zajscia zdarzenia  ');
    tmp.SQL.Add('	declare @num_records int;				-- ilosc rekordow do przeanalizowania  ');
    tmp.SQL.Add('	declare @record_step int;				-- krok, co ile rekordow aktualizowac postep  ');
    tmp.SQL.Add('	declare @record_index int;				-- nr kolejnego analizowanego rekordu  ');
    tmp.SQL.Add('	declare @canceled bit;					-- wskazuje czy wykonanie procedury nie zostalo anulowane  ');
    tmp.SQL.Add('	declare @tmp5 int;  ');
    tmp.SQL.Add('	declare @tmp6 numeric(10, 3);  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('	declare @group_sec int;  ');
    tmp.SQL.Add('	declare @group_ggmm varchar(10);  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('	set @group_sec = null;  ');
    tmp.SQL.Add('	set @group_ggmm = null;  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('	declare @event_start2 datetime;  ');
    tmp.SQL.Add('	set @event_start2 = null;  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('	set @record_step = 100;  ');
    tmp.SQL.Add('	set @record_index = 1;  ');
    tmp.SQL.Add('	set @canceled = 0;  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('	-- W zaleznosci od trybu wywolania funkcji wybierany jest odpowiedni widok oraz parametry jego filtrowania.  ');
    tmp.SQL.Add('	-- Jesli jest to tryb pojazdu, wykorzystywany jest widok view_nonstandardEvents_carMode, filtrowanie  ');
    tmp.SQL.Add('	-- po id pojazdu.  ');
    tmp.SQL.Add('	-- Jesli jest to tryb kierowcy, uzywany widok to view_nonstandardEvents_driverMode, a filtrowanie  ');
    tmp.SQL.Add('	-- po id kierowcy.  ');
    tmp.SQL.Add('	-- W obu trybach wybierane sa rekordy w przedziale czasowym zdarzenia pomiedzy datami @start i @stop.  ');
    tmp.SQL.Add('	if (@isInCarMode = 1)  ');
    tmp.SQL.Add('	begin  ');
    tmp.SQL.Add('		declare zdarzenia_cr cursor  ');
    tmp.SQL.Add('			for select id_device_data,evb1,evb2,evb3,evb4,evb9,evb10,date,driver_name,description,car_name,rej_numb  ');
    tmp.SQL.Add('			from view_nonstandardEvents_carMode  ');
    tmp.SQL.Add('			where evb2=@car_or_driver_no AND date>=@start AND date<=@stop  ');
    tmp.SQL.Add('			order by id_device_data asc;  ');
    tmp.SQL.Add('		set @num_records = (select count(*) from view_nonstandardEvents_carMode  ');
    tmp.SQL.Add('			where evb2=@car_or_driver_no AND date>=@start AND date<=@stop);  ');
    tmp.SQL.Add('	end  ');
    tmp.SQL.Add('	else  ');
    tmp.SQL.Add('	begin  ');
    tmp.SQL.Add('		declare zdarzenia_cr cursor  ');
    tmp.SQL.Add('			for select id_device_data,evb1,evb2,evb3,evb4,evb9,evb10,date,driver_name,description,car_name,rej_numb  ');
    tmp.SQL.Add('			from view_nonstandardEvents_driverMode  ');
    tmp.SQL.Add('			where id_driver=@car_or_driver_no AND date>=@start AND date<=@stop  ');
    tmp.SQL.Add('			order by id_device_data asc;  ');
    tmp.SQL.Add('		set @num_records = (select count(*) from view_nonstandardEvents_driverMode  ');
    tmp.SQL.Add('			where id_driver=@car_or_driver_no AND date>=@start AND date<=@stop);  ');
    tmp.SQL.Add('	end  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('	set @event_start2 = null  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('	-- Iteruj po wszystkich wydarzeniach z widoku.  ');
    tmp.SQL.Add('	open zdarzenia_cr;  ');
    tmp.SQL.Add('    fetch zdarzenia_cr into @id_device_data,@evb1,@evb2,@evb3,@evb4,@evb9,@evb10,@date,@driver_name,@evdescription,@car_name,@car_rej;  ');
    tmp.SQL.Add('	while (@@FETCH_STATUS <> -1) and (@canceled=0)  ');
    tmp.SQL.Add('	begin  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('		-- Warunek uwzgledniajacy lub nie zdarzenia z grupy 17x w zaleznosci od  ');
    tmp.SQL.Add('		-- parametru @show17x  ');
    tmp.SQL.Add('		if (@show17x = 1 OR (@show17x = 0 AND NOT @evb3 in (171,172,173)))  ');
    tmp.SQL.Add('		begin  ');
    tmp.SQL.Add('			-- Domyslne wartosci  ');
    tmp.SQL.Add('			set @event_start = @date;  ');
    tmp.SQL.Add('			set @event_stop = NULL;  ');
    tmp.SQL.Add('			set @time = NULL;  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('			if (@evb3 = 181)  ');
    tmp.SQL.Add('			begin  ');
    tmp.SQL.Add('			  if (@show181 = 0) -- bieg jalowy ');
    tmp.SQL.Add('		      begin  ');
    tmp.SQL.Add('		        fetch zdarzenia_cr into @id_device_data,@evb1,@evb2,@evb3,@evb4,@evb9,@evb10,@date,@driver_name,@evdescription,@car_name,@car_rej;  ');
    tmp.SQL.Add('		        --if (@record_index % @record_step = 0)  ');
    tmp.SQL.Add('		        begin  ');
    tmp.SQL.Add('			         print @record_index  ');
    tmp.SQL.Add('			         print @num_records  ');
    tmp.SQL.Add('			         exec sp_progress_set @id_progress, @record_index, @num_records, @canceled output;  ');
    tmp.SQL.Add('		        end  ');
    tmp.SQL.Add('		        set @record_index = @record_index + 1;  ');
    tmp.SQL.Add('		        continue;  ');
    tmp.SQL.Add('		      end;  ');
    tmp.SQL.Add('			  set @event_stop = @date;  ');
    tmp.SQL.Add('			  set @event_start = dateadd(second, -( Round(((@evb1 * 256 + @evb4) / 60), 0) * 60), @event_stop);  ');
    tmp.SQL.Add('			  set @evdescription = N''Praca bez jazdy '' + dbo.spGetGGMMf(@evb1 * 256 + @evb4) + '' [gg:mm]'';  ');
    tmp.SQL.Add('			  set @group_sec = @evb1 * 256 + @evb4;  ');
    tmp.SQL.Add('			  set @group_ggmm = dbo.spGetGGMMf(@evb1 * 256 + @evb4);  ');
    tmp.SQL.Add('			end  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('			if (@evb3 = 15) -- zasilanie ');
    tmp.SQL.Add('			begin  ');
    tmp.SQL.Add('			  if (@show15 = 0)  ');
    tmp.SQL.Add('		      begin  ');
    tmp.SQL.Add('		        fetch zdarzenia_cr into @id_device_data,@evb1,@evb2,@evb3,@evb4,@evb9,@evb10,@date,@driver_name,@evdescription,@car_name,@car_rej;  ');
    tmp.SQL.Add('		        --if (@record_index % @record_step = 0)  ');
    tmp.SQL.Add('		        begin  ');
    tmp.SQL.Add('			         print @record_index  ');
    tmp.SQL.Add('			         print @num_records  ');
    tmp.SQL.Add('			         exec sp_progress_set @id_progress, @record_index, @num_records, @canceled output;  ');
    tmp.SQL.Add('		        end  ');
    tmp.SQL.Add('		        set @record_index = @record_index + 1;  ');
    tmp.SQL.Add('		        continue;  ');
    tmp.SQL.Add('		      end;  ');
    tmp.SQL.Add('			  set @event_stop = @date;  ');
    tmp.SQL.Add('			  set @event_start =  ');
    tmp.SQL.Add('					dbo.event_15_start_time(@evb2, @id_device_data, @event_stop);  ');
    tmp.SQL.Add('			  set @time = dbo.event_15_lasting_time(@event_start, @event_stop);  ');
    tmp.SQL.Add('			  set @group_sec =dbo.get_date_diff(@event_start, @event_stop);  ');
    tmp.SQL.Add('			  set @group_ggmm = dbo.spGetGGMMf(@group_sec);  ');
    tmp.SQL.Add('			  set @evdescription = N''Zasilanie wy³¹czone'';  ');
    tmp.SQL.Add('			end  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('			if (@evb3 = 14) -- zasloniety gps ');
    tmp.SQL.Add('			begin  ');
    tmp.SQL.Add('			  if (@show14 = 0)  ');
    tmp.SQL.Add('		      begin  ');
    tmp.SQL.Add('		        fetch zdarzenia_cr into @id_device_data,@evb1,@evb2,@evb3,@evb4,@evb9,@evb10,@date,@driver_name,@evdescription,@car_name,@car_rej;  ');
    tmp.SQL.Add('		        --if (@record_index % @record_step = 0)  ');
    tmp.SQL.Add('		        begin  ');
    tmp.SQL.Add('			         print @record_index  ');
    tmp.SQL.Add('			         print @num_records  ');
    tmp.SQL.Add('			         exec sp_progress_set @id_progress, @record_index, @num_records, @canceled output;  ');
    tmp.SQL.Add('		        end  ');
    tmp.SQL.Add('		        set @record_index = @record_index + 1;  ');
    tmp.SQL.Add('		        continue;  ');
    tmp.SQL.Add('		      end;  ');
    tmp.SQL.Add('		      set @event_start2 = @event_start;  ');
    tmp.SQL.Add('			end  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('			if (@evb3 = 16) -- koniec zasloniecia gpsu ');
    tmp.SQL.Add('			begin  ');
    tmp.SQL.Add('			  if (@show14 = 0)  ');
    tmp.SQL.Add('		      begin  ');
    tmp.SQL.Add('		        fetch zdarzenia_cr into @id_device_data,@evb1,@evb2,@evb3,@evb4,@evb9,@evb10,@date,@driver_name,@evdescription,@car_name,@car_rej;  ');
    tmp.SQL.Add('		        --if (@record_index % @record_step = 0)  ');
    tmp.SQL.Add('		        begin  ');
    tmp.SQL.Add('			         print @record_index  ');
    tmp.SQL.Add('			         print @num_records  ');
    tmp.SQL.Add('			         exec sp_progress_set @id_progress, @record_index, @num_records, @canceled output;  ');
    tmp.SQL.Add('		        end  ');
    tmp.SQL.Add('		        set @record_index = @record_index + 1;  ');
    tmp.SQL.Add('		        continue;  ');
    tmp.SQL.Add('		      end;  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('			  if (@event_start2 is not null)  ');
    tmp.SQL.Add('			  begin  ');
    tmp.SQL.Add('			    set @event_stop = @date;  ');
    tmp.SQL.Add('		        set @event_start = @event_start2;  ');
    tmp.SQL.Add('		        set @event_start2 = null;  ');
    tmp.SQL.Add('			    set @group_sec =dbo.get_date_diff(@event_start, @event_stop);  ');
    tmp.SQL.Add('			    set @group_ggmm = dbo.spGetGGMMf(@group_sec);  ');
    tmp.SQL.Add('			  end;  ');
    tmp.SQL.Add('			end  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('			if (@evb3 = 1) or (@evb3 = 2) or (@evb3 = 3) or (@evb3 = 4) or (@evb3 = 5)  ');
    tmp.SQL.Add('			begin  ');
    tmp.SQL.Add('			  if (@showInputs = 0)  ');
    tmp.SQL.Add('		      begin  ');
    tmp.SQL.Add('		        fetch zdarzenia_cr into @id_device_data,@evb1,@evb2,@evb3,@evb4,@evb9,@evb10,@date,@driver_name,@evdescription,@car_name,@car_rej;  ');
    tmp.SQL.Add('		        --if (@record_index % @record_step = 0)  ');
    tmp.SQL.Add('		        begin  ');
    tmp.SQL.Add('			         print @record_index  ');
    tmp.SQL.Add('			         print @num_records  ');
    tmp.SQL.Add('			         exec sp_progress_set @id_progress, @record_index, @num_records, @canceled output;  ');
    tmp.SQL.Add('		        end  ');
    tmp.SQL.Add('		        set @record_index = @record_index + 1;  ');
    tmp.SQL.Add('		        continue;  ');
    tmp.SQL.Add('		      end;  ');
    tmp.SQL.Add('		      set @event_start2 = @event_start;  ');
    tmp.SQL.Add('			end  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('			if (@evb3 = 31) or (@evb3 = 32) or (@evb3 = 33) or (@evb3 = 34) or (@evb3 = 35)  ');
    tmp.SQL.Add('			begin  ');
    tmp.SQL.Add('			  if (@showInputs = 0)  ');
    tmp.SQL.Add('		      begin  ');
    tmp.SQL.Add('		        fetch zdarzenia_cr into @id_device_data,@evb1,@evb2,@evb3,@evb4,@evb9,@evb10,@date,@driver_name,@evdescription,@car_name,@car_rej;  ');
    tmp.SQL.Add('		        --if (@record_index % @record_step = 0)  ');
    tmp.SQL.Add('		        begin  ');
    tmp.SQL.Add('			         print @record_index  ');
    tmp.SQL.Add('			         print @num_records  ');
    tmp.SQL.Add('			         exec sp_progress_set @id_progress, @record_index, @num_records, @canceled output;  ');
    tmp.SQL.Add('		        end  ');
    tmp.SQL.Add('		        set @record_index = @record_index + 1;  ');
    tmp.SQL.Add('		        continue;  ');
    tmp.SQL.Add('		      end;  ');
    tmp.SQL.Add('		      if (@event_start2 is not null)  ');
    tmp.SQL.Add('		      begin  ');
    tmp.SQL.Add('				set @event_stop = @date;  ');
    tmp.SQL.Add('				set @event_start = @event_start2;  ');
    tmp.SQL.Add('				set @event_start2 = null;  ');
    tmp.SQL.Add('				set @group_sec =dbo.get_date_diff(@event_start, @event_stop);  ');
    tmp.SQL.Add('				set @group_ggmm = dbo.spGetGGMMf(@group_sec);  ');
    tmp.SQL.Add('			  end;  ');
    tmp.SQL.Add('			end  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('			if (@evb3 = 13)  ');
    tmp.SQL.Add('			begin  ');
    tmp.SQL.Add('				-- Dla wydarzenia 13 w polu ile podawana jest wartosc stalej K  ');
    tmp.SQL.Add('				set @time = dbo.get_K(@evb9, @evb10);  ');
    tmp.SQL.Add('			end  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('			if (@evb3 = 19) or (@evb3 = 18)  ');
    tmp.SQL.Add('			begin  ');
    tmp.SQL.Add('			  if @flag_count = 1  ');
    tmp.SQL.Add('			  begin  ');
    tmp.SQL.Add('		        fetch zdarzenia_cr into @id_device_data,@evb1,@evb2,@evb3,@evb4,@evb9,@evb10,@date,@driver_name,@evdescription,@car_name,@car_rej;  ');
    tmp.SQL.Add('		        --if (@record_index % @record_step = 0)  ');
    tmp.SQL.Add('		        begin  ');
    tmp.SQL.Add('			         print @record_index  ');
    tmp.SQL.Add('			         print @num_records  ');
    tmp.SQL.Add('			         exec sp_progress_set @id_progress, @record_index, @num_records, @canceled output;  ');
    tmp.SQL.Add('		        end  ');
    tmp.SQL.Add('		        set @record_index = @record_index + 1;  ');
    tmp.SQL.Add('		        continue;  ');
    tmp.SQL.Add('		      end  ');
    tmp.SQL.Add('			end  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('			if (@evb3 = 69)  ');
    tmp.SQL.Add('			begin  ');
    tmp.SQL.Add('		      if (@show69 = 0)  ');
    tmp.SQL.Add('		      begin  ');
    tmp.SQL.Add('		        fetch zdarzenia_cr into @id_device_data,@evb1,@evb2,@evb3,@evb4,@evb9,@evb10,@date,@driver_name,@evdescription,@car_name,@car_rej;  ');
    tmp.SQL.Add('		        --if (@record_index % @record_step = 0)  ');
    tmp.SQL.Add('		        begin  ');
    tmp.SQL.Add('			         print @record_index  ');
    tmp.SQL.Add('			         print @num_records  ');
    tmp.SQL.Add('			         exec sp_progress_set @id_progress, @record_index, @num_records, @canceled output;  ');
    tmp.SQL.Add('		        end  ');
    tmp.SQL.Add('		        set @record_index = @record_index + 1;  ');
    tmp.SQL.Add('		        continue;  ');
    tmp.SQL.Add('		      end  ');
    tmp.SQL.Add('			  declare @dallas1 nvarchar(2);  ');
    tmp.SQL.Add('			  declare @dallas2 nvarchar(2);  ');
    tmp.SQL.Add('			  declare @dallas3 nvarchar(2);  ');
    tmp.SQL.Add('			  declare @dallas4 nvarchar(2);  ');
    tmp.SQL.Add('			  declare @tmp int;  ');
    tmp.SQL.Add('			  declare @tmp2 int;  ');
    tmp.SQL.Add('			  declare @przes int;  ');
    tmp.SQL.Add('			  declare @przes2 int;  ');
    tmp.SQL.Add('			  set @tmp = FLOOR(@evb10 / 16);  ');
    tmp.SQL.Add('			  set @przes = 48;  ');
    tmp.SQL.Add('			  if (@tmp >= 10)  ');
    tmp.SQL.Add('				set @przes = 55;  ');
    tmp.SQL.Add('			  set @tmp2 = @evb10 % 16;  ');
    tmp.SQL.Add('			  set @przes2 = 48;  ');
    tmp.SQL.Add('			  if (@tmp2 >= 10)  ');
    tmp.SQL.Add('				set @przes2 = 55;  ');
    tmp.SQL.Add('			  set @dallas4 = CHAR(@tmp + @przes) + CHAR(@tmp2 + @przes2);  ');
    tmp.SQL.Add('			  set @tmp = FLOOR(@evb9 / 16);  ');
    tmp.SQL.Add('			  set @przes = 48;  ');
    tmp.SQL.Add('			  if (@tmp >= 10)  ');
    tmp.SQL.Add('			 	set @przes = 55;  ');
    tmp.SQL.Add('			  set @tmp2 = @evb9 % 16;  ');
    tmp.SQL.Add('			  set @przes2 = 48;  ');
    tmp.SQL.Add('			  if (@tmp2 >= 10)  ');
    tmp.SQL.Add('				set @przes2 = 55;  ');
    tmp.SQL.Add('			  set @dallas3 = CHAR(@tmp + @przes) + CHAR(@tmp2 + @przes2);  ');
    tmp.SQL.Add('			  set @tmp = FLOOR(@evb4 / 16);  ');
    tmp.SQL.Add('			  set @przes = 48;  ');
    tmp.SQL.Add('			  if (@tmp >= 10)  ');
    tmp.SQL.Add('				set @przes = 55;  ');
    tmp.SQL.Add('			  set @tmp2 = @evb4 % 16;  ');
    tmp.SQL.Add('			  set @przes2 = 48;  ');
    tmp.SQL.Add('			  if (@tmp2 >= 10)  ');
    tmp.SQL.Add('				set @przes2 = 55;  ');
    tmp.SQL.Add('			  set @dallas2 = CHAR(@tmp + @przes) + CHAR(@tmp2 + @przes2);  ');
    tmp.SQL.Add('			  set @tmp = FLOOR(@evb1 / 16);  ');
    tmp.SQL.Add('			  set @przes = 48;  ');
    tmp.SQL.Add('			  if (@tmp >= 10)  ');
    tmp.SQL.Add('				set @przes = 55;  ');
    tmp.SQL.Add('			  set @tmp2 = @evb1 % 16;  ');
    tmp.SQL.Add('			  set @przes2 = 48;  ');
    tmp.SQL.Add('			  if (@tmp2 >= 10)  ');
    tmp.SQL.Add('				set @przes2 = 55;  ');
    tmp.SQL.Add('			  set @dallas1 = CHAR(@tmp + @przes) + CHAR(@tmp2 + @przes2);  ');
    tmp.SQL.Add('			  set @evdescription = N''DALLAS: Kod pracownika:'';  ');
    tmp.SQL.Add('			  set @evdescription = @evdescription + @dallas4;  ');
    tmp.SQL.Add('			  set @evdescription = @evdescription + @dallas3;  ');
    tmp.SQL.Add('			  set @evdescription = @evdescription + @dallas2;  ');
    tmp.SQL.Add('			  set @evdescription = @evdescription + @dallas1;  ');
    tmp.SQL.Add('			end  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('			if (@evb3 = 114)  ');
    tmp.SQL.Add('			begin  ');
    tmp.SQL.Add('		      if (@show114 = 0)  ');
    tmp.SQL.Add('		      begin  ');
    tmp.SQL.Add('		        fetch zdarzenia_cr into @id_device_data,@evb1,@evb2,@evb3,@evb4,@evb9,@evb10,@date,@driver_name,@evdescription,@car_name,@car_rej;  ');
    tmp.SQL.Add('		        continue;  ');
    tmp.SQL.Add('		      end  ');
    tmp.SQL.Add('			  set @tmp5 = @evb9 * 256 + @evb10;  ');
    tmp.SQL.Add('			  set @tmp6 = (@tmp5 & 32767);  ');
    tmp.SQL.Add('			  if ((@tmp5 & 32768) <> 0)  ');
    tmp.SQL.Add('				set @tmp6 = @tmp6 - 32768;  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('			  set @tmp6 = @tmp6 * 0.0625;  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('			  if (@tmp6 > 125.0) or (@tmp6 < -55.0) ');
    tmp.SQL.Add('			  begin  ');
    tmp.SQL.Add('			    fetch zdarzenia_cr into @id_device_data,@evb1,@evb2,@evb3,@evb4,@evb9,@evb10,@date,@driver_name,@evdescription,@car_name,@car_rej;  ');
    tmp.SQL.Add('		        --if (@record_index % @record_step = 0)  ');
    tmp.SQL.Add('		        begin  ');
    tmp.SQL.Add('			       print @record_index  ');
    tmp.SQL.Add('			       print @num_records  ');
    tmp.SQL.Add('			       exec sp_progress_set @id_progress, @record_index, @num_records, @canceled output;  ');
    tmp.SQL.Add('		        end  ');
    tmp.SQL.Add('		        set @record_index = @record_index + 1;  ');
    tmp.SQL.Add('				continue;  ');
    tmp.SQL.Add('  			  end;  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('			  set @evdescription = N''Pomiar temperatury: '';  ');
    tmp.SQL.Add('			  set @evdescription = @evdescription + ltrim(str(@tmp6, 10, 3)) + '' °C'';  ');
    tmp.SQL.Add('			end  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('			-- Umieszczenie danych w tabeli wynikowej  ');
    tmp.SQL.Add('			if @flag_count <> 1  ');
    tmp.SQL.Add('			begin  ');
    tmp.SQL.Add('				insert into @report (data, opis, ile, start, stop, marka_pojazdu, nr_rej_pojazdu, kierowca) values (  ');
    tmp.SQL.Add('					cast(STR(MONTH(@date)) + ''/'' + STR(DAY(@date)) + ''/'' + STR(YEAR(@date)) as datetime),  ');
    tmp.SQL.Add('					@evdescription, @time,  ');
    tmp.SQL.Add('					@event_start, @event_stop,  ');
    tmp.SQL.Add('					@car_name, @car_rej, @driver_name )  ');
    tmp.SQL.Add('			end  ');
    tmp.SQL.Add('			else  ');
    tmp.SQL.Add('			begin  ');
    tmp.SQL.Add('				insert into @report (data, opis, ile, start, stop, marka_pojazdu, nr_rej_pojazdu, kierowca, group_sec, group_ggmm) values (  ');
    tmp.SQL.Add('					cast(STR(MONTH(@date)) + ''/'' + STR(DAY(@date)) + ''/'' + STR(YEAR(@date)) as datetime),  ');
    tmp.SQL.Add('					@evdescription, @time,  ');
    tmp.SQL.Add('					@event_start, @event_stop,  ');
    tmp.SQL.Add('					@car_name, @car_rej, @driver_name,  ');
    tmp.SQL.Add('					@group_sec, @group_ggmm )  ');
    tmp.SQL.Add('			end  ');
    tmp.SQL.Add('		end  ');
    tmp.SQL.Add('		fetch zdarzenia_cr into @id_device_data,@evb1,@evb2,@evb3,@evb4,@evb9,@evb10,@date,@driver_name,@evdescription,@car_name,@car_rej;  ');
    tmp.SQL.Add('		--if (@record_index % @record_step = 0)  ');
    tmp.SQL.Add('		begin  ');
    tmp.SQL.Add('			print @record_index  ');
    tmp.SQL.Add('			print @num_records  ');
    tmp.SQL.Add('			exec sp_progress_set @id_progress, @record_index, @num_records, @canceled output;  ');
    tmp.SQL.Add('		end  ');
    tmp.SQL.Add('		set @record_index = @record_index + 1;  ');
    tmp.SQL.Add('	end  ');
    tmp.SQL.Add('	deallocate zdarzenia_cr;  ');
    tmp.SQL.Add('	exec sp_progress_unregister @id_progress;  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('	declare @data2 datetime;  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('	declare aggr_cr cursor  ');
    tmp.SQL.Add('		for select data, sum(group_sec), dbo.spGetGGMMf(sum(group_sec))  ');
    tmp.SQL.Add('		from @report  ');
    tmp.SQL.Add('		where group_sec is not null  ');
    tmp.SQL.Add('		group by data;  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('	open aggr_cr  ');
    tmp.SQL.Add('	fetch aggr_cr into @data2, @group_sec, @group_ggmm;  ');
    tmp.SQL.Add('	while (@@fetch_status <> -1)  ');
    tmp.SQL.Add('	begin  ');
    tmp.SQL.Add('		update @report set group_day_sec  = @group_sec,  ');
    tmp.SQL.Add('						   group_day_ggmm = @group_ggmm  ');
    tmp.SQL.Add('				where data = @data2  ');
    tmp.SQL.Add('		fetch aggr_cr into @data2, @group_sec, @group_ggmm;  ');
    tmp.SQL.Add('	end  ');
    tmp.SQL.Add('	close aggr_cr;  ');
    tmp.SQL.Add('	deallocate aggr_cr;  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('	declare aggr_cr cursor  ');
    tmp.SQL.Add('		for select sum(group_sec), dbo.spGetGGMMf(sum(group_sec))  ');
    tmp.SQL.Add('		from @report  ');
    tmp.SQL.Add('		where group_sec is not null;  ');
    tmp.SQL.Add('  ');
    tmp.SQL.Add('	open aggr_cr  ');
    tmp.SQL.Add('	fetch aggr_cr into @group_sec, @group_ggmm;  ');
    tmp.SQL.Add('	while (@@fetch_status <> -1)  ');
    tmp.SQL.Add('	begin  ');
    tmp.SQL.Add('		update @report set group_all_sec  = @group_sec,  ');
    tmp.SQL.Add('						   group_all_ggmm = @group_ggmm  ');
    tmp.SQL.Add('		fetch aggr_cr into @group_sec, @group_ggmm;  ');
    tmp.SQL.Add('	end  ');
    tmp.SQL.Add('	close aggr_cr;  ');
    tmp.SQL.Add('	deallocate aggr_cr;  ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	if @exclude_events_longer_than_min = 0 ');
    tmp.SQL.Add('	begin ');
    tmp.SQL.Add('		select * from @report order by id  ');
    tmp.SQL.Add('	end ');
    tmp.SQL.Add('	else ');
    tmp.SQL.Add('	begin ');
    tmp.SQL.Add('		select * from @report  ');
    tmp.SQL.Add('		where stop is null or DATEDIFF(minute , start , stop) >= @exclude_events_longer_than_min ');
    tmp.SQL.Add('		order by id  ');
    tmp.SQL.Add('	end ');
    tmp.SQL.Add('end  ');

    tmp.ExecSQL();

end;


procedure TTEDEmailSrv.RequestFromOnlineTrackingWWWServiceExecute(
  AContext: TIdContext);
var database_name: String;
begin
try
    added_databases_section.BeginWrite();
    try
        try
            database_name := AContext.Connection.IOHandler.ReadLn(#$A, 200);
            AddLog('11963 RequestFromOnlineTrackingWWWServiceExecute: database_name:' + database_name);
            AContext.Connection.IOHandler.WriteLn('ok');
            if Pos(':', database_name) = 0 then
                added_databases.Add(database_name + ':' + FloatToStr(Now()));
        except
            on e: Exception do
            begin
                if Pos('# 10054', e.Message) > 0 then
                begin
                    exit;
                end;
            end;
        end;
    finally
        added_databases_section.EndWrite();
 //       AThread.Terminate();
    end;
 except
     on e: exception do
     begin
         AddLog('11983 RequestFromOnlineTrackingWWWServiceExecute: ' + e.Message);
     end;
 end;
end;

procedure TTEDEmailSrv.RequestFromButtonImmediatelyExecute(
  AContext: TIdContext);
var database_name: String;
begin
try
    added_databases_section.BeginWrite();
    try
        try
            database_name := AContext.Connection.IOHandler.ReadLn(#$A, 200);
            AddLog('11997 RequestFromButtonImmediatelyExecute: database_name:' + database_name);
            AContext.Connection.IOHandler.WriteLn('ok');
            if Pos(':', database_name) = 0 then
                added_databases.Add(database_name + ':' + FloatToStr(Now() - EncodeTime(1, 0, 0, 0)));
        except
            on e: Exception do
            begin
                if Pos('# 10054', e.Message) > 0 then
                begin
                    exit;
                end;
            end;
        end;
    finally
        added_databases_section.EndWrite();
 //       AThread.Terminate();
    end;
except
     on e: exception do
     begin
         AddLog('12017 RequestFromButtonImmediatelyExecute: ' + e.Message);
     end;
end;
end;

function TTEDEmailSrv.CreatePanelConnectionString(lista: TStrings): String;
var wynik: String;
    j: Integer;
    MSDE_true_PostgreSQL_false: Boolean;
begin
    MSDE_true_PostgreSQL_false := (lista.Values['Provider'] = 'SQLOLEDB.1');
    wynik := '';
    for j := 0 to Pred(lista.Count) do
        if Pos('admin_panel_', lista.Names[j]) > 0 then
        begin
            if lista.Names[j] = 'admin_panel_Password' then
                wynik := wynik + lista.Names[j] + '=' + lista.Values['admin_panel_Password'] + ';'
            else
            if (not MSDE_true_PostgreSQL_false) and (lista.Names[j] = 'admin_panel_Persist Security Info') then
                wynik := wynik + 'Extended Properties=""' + ';'
            else
            if (not MSDE_true_PostgreSQL_false) and (lista.Names[j] = 'admin_panel_Initial Catalog') then
                wynik := wynik + 'Location=' + lista.Values['admin_panel_Initial Catalog'] + ';'
            else
                wynik := wynik + lista.Strings[j] + ';';
        end;
    wynik := Copy(wynik, 1, Length(wynik) - 1);
    wynik := ReplaceStr(wynik, 'admin_panel_', '');
    result := wynik;
end;

procedure TTEDEmailSrv.ExportToPanel();

var
    ini: TStrings;
    ident: String;
    id_company: Integer;
    device_email: String;

    tmp_id: Integer;
    Query_tmp: TADOQuery;
    car_ids: array of integer;
    tmp_str: String;
    licznik_car: Integer;
    max_: Longint;
begin
    try
//        ADOConnectionPanel.Connected := False;
//        ini := TStringList.Create();
//        ini.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini');
//        ADOConnectionPanel.ConnectionString := CreatePanelConnectionString(ini);
//        ini.Free();
//        ADOConnectionPanel.Connected := False;
//        ADOConnectionPanel.ConnectionTimeout := 5;
//        ADOConnectionPanel.Open();

        FormatSettings.DecimalSeparator := '.';

        qXML.Close();
        qXML.SQL.Clear();
        qXML.SQL.Add('select * from carnet_settings');
        qXML.Open();
        ident := qXML.FieldByName('ident').AsString;
        qXML.Close();

        qXML.Close();
        qXML.SQL.Clear();
        qXML.SQL.Add('select * from mail_settings');
        qXML.Open();
        device_email := qXML.FieldByName('konto').AsString;
        qXML.Close();

        qPanelQuery.Close();
        qPanelQuery.SQL.Clear();
        qPanelQuery.SQL.Add('select id_company from company where ident = ''' + ident + '''');
        qPanelQuery.Open();
        id_company := qPanelQuery.FieldByName('id_company').AsInteger;
        qPanelQuery.Close();

        if id_company = 0 then
        begin
//            qPanelQuery.Close();
//            qPanelQuery.SQL.Clear();
//            qPanelQuery.SQL.Add('insert into company (ident, id_distributor, disable_tracking, disable_google_maps, last_upload) values(''' + ident + ''', 3, 0, 0, CURRENT_TIMESTAMP)');
//            qPanelQuery.ExecSQL();

            qPanelQuery.Close();
            qPanelQuery.SQL.Clear();
            qPanelQuery.SQL.Add('insert into company (ident, id_distributor, disable_tracking, disable_google_maps, last_upload, obsolete, device_email) values(''' + ident + ''', 3, 0, 0, CURRENT_TIMESTAMP, 0, ''' + device_email + ''')');
            qPanelQuery.ExecSQL();

            qPanelQuery.Close();
            qPanelQuery.SQL.Clear();
            qPanelQuery.SQL.Add('select id_company from company where ident = ''' + ident + '''');
            qPanelQuery.Open();
            id_company := qPanelQuery.FieldByName('id_company').AsInteger;
            qPanelQuery.Close();
        end;

//        qPanelQuery.Close();
//        qPanelQuery.SQL.Clear();
//        qPanelQuery.SQL.Add('update company set last_upload = CURRENT_TIMESTAMP where id_company = ' +
//                                IntToStr(id_company));
//        qPanelQuery.ExecSQL();

        qPanelQuery.Close();
        qPanelQuery.SQL.Clear();
        qPanelQuery.SQL.Add('update company set last_upload = CURRENT_TIMESTAMP, device_email = ''' + device_email + '''  where id_company = ' +
                                            IntToStr(id_company));
        qPanelQuery.ExecSQL();




        qXML.Close();
        qXML.SQL.Clear();
        qXML.SQL.Add('select t1.to_delete, firmware_version2, LRx, firmware_version2_changed, last_222_datetime, last_15_datetime, dbo.spDoDwochZnakowf(LTRIM(STR(YEAR(last_gps_datetime)))) + ''-'' + ' +
                      'dbo.spDoDwochZnakowf(LTRIM(STR(MONTH(last_gps_datetime)))) + ''-'' + ' +
                      'LTRIM(STR(DAY(last_gps_datetime))) last_gps_datetime, ' +

                      'dbo.spDoDwochZnakowf(LTRIM(STR(YEAR(last_email_datetime)))) + ''-'' + ' +
                      'dbo.spDoDwochZnakowf(LTRIM(STR(MONTH(last_email_datetime)))) + ''-'' + ' +
                      'LTRIM(STR(DAY(last_email_datetime))) last_email_datetime, ' +

                      'last_gps, last_gps_event, last_gps_status, last_packet_prefix, ' +
                      't1.gr1, t1.id_car id, t1.name, t1.rej_numb, t2.max_capacity fuel_max, t3.max_capacity fuel_max2, ' +
                      't1.useles, t1.fast_imp, t4.imp_div mod_imp, ' +
                      't6.driver_name driver, t1.i_tank, t1.i_up, t1.rpm_obro, t1.rpm_disp, t1.mileage count, ' +
                      'max_speed mspeed, ' +
                      '(select ''T'' where rpm_stat = 1 and rpm_stat is not null union ' +
                      'select ''N'' where rpm_stat <> 1 or rpm_stat is null) rpm_stat, rpm_delay rpmdelay, cast(id_probe_type as varchar(1)) sonda, ' +
                      '''5'' freq, rpm_id, ' +
                      'cast(dbo.spDoDwochZnakowf(LTRIM(STR(MONTH(installation_date)))) + ''/'' + ' +
                      'dbo.spDoDwochZnakowf(LTRIM(STR(DAY(installation_date)))) + ''/'' + ' +
                      'LTRIM(STR(YEAR(installation_date))) as datetime) c_date, ' +
                      '(select 1 where fuel_algorithm = 1 ' +
                      '				union ' +
                      '			    select 0 where fuel_algorithm <> 1 or fuel_algorithm is null ' +
                      '               ) stralis, ' +
                      '(select 2 where use_motohours = 1 ' +
                      '				union ' +
                      '			    select 0 where use_motohours <> 1 or use_motohours is null ' +
                      '               ) car_type, ' +
                      'phone_nr telefon, ' +
                      'null changed, 1 synchronized, null deleted, ' +
                      'id_device_type isEmailGPS, ' +
                      'factor_approx_1 aproksymacja, ' +
                      '(select id_approx_type_1 where id_approx_type_1 <> 0 ' +
                      '   union' +
                      '   select 1 where id_approx_type_1 = 0) aproksym_kind, ' +
                      'factor_approx_2 aproksymacja2, ' +
                      '(select id_approx_type_2 where id_approx_type_2 <> 0 ' +
                      '   union' +
                      '   select 1 where id_approx_type_2 = 0) aproksym_kind2, ' +
                      '(select 1 where cistern = 1 ' +
                      '   union' +
                      '   select 0 where cistern = 0) cistern, ' +
                      '(select 1 where factor_approx_2 <> 0.0 ' +
                      '   union ' +
                      '   select 0 where factor_approx_2 = 0.0) second_aproksym, ' +
                      'power_off_on_fuel_chart PowerOffOnFuelChart, ident, ident2, useles_city, useles_city_enabled, apn, ' +
                      'id_starter_type starter, id_email_cycle email_cycle, ' +
                      'mode_30_sec second30, sms_on_start, gps_always_on gps_mode, road_correction, dyn_data_enabled, ' +
                      'dyn_data_max_bad_time, dyn_data_max_useles, filter_first filtr_kolejnosc, ' +
                      'id_transmitter_mode transmitter_mode, alarm_tel, ' +
      '(  select 1 where apn=''www.idea.pl'' ' +
      '  union ' +
      '  select 2 where apn=''www.plusgsm.pl'' ' +
      '  union ' +
      '  select 3 where apn=''erainternet'' ' +
      '  union ' +
      '  select 4 where apn=''erainternettt'' ' +
      '  union ' +
      '  select 5 where apn=''heyah.pl'' ' +
      '  union ' +
      '  select 6 where apn=''internet'' ' +
      '  union ' +
      '  select 7 where (apn <> ''www.idea.pl'') and (apn <> ''www.plusgsm.pl'') and (apn<>''erainternet'') ' +
      '  and (apn<>''erainternettt'') and (apn<>''heyah.pl'') and (apn<>''internet'')) operator_karty ' +
                      'from car t1 ' +
                      'left join fuel_tank t2 on (t1.id_car = t2.id_car and t2.tank_nr = 1) ' +
                      'left join fuel_tank t3 on (t1.id_car = t3.id_car and t3.tank_nr = 2) ' +
                      'left join road_imp_div t4 on (t1.id_road_imp_div = t4.id_road_imp_div) ' +
                      'left join car_change t5 on (t1.id_car = t5.id_car and t5.end_date is null) ' +
                      'left join driver t6 on (t5.id_driver = t6.id_driver) ' +
                      '');
        qXML.Open();

        qPanelQuery.Close();
        qPanelQuery.SQL.Clear();
        qPanelQuery.SQL.Add('insert into car (firmware_version2, LRx, firmware_version2_changed, last_222_datetime, last_15_datetime, gr1, id_company, name, rej_numb, useles, fast_imp, id_road_imp_div, ' +
					' i_tank, i_up, rpm_obro, rpm_disp, mileage, ' +
					' installation_date, max_speed, rpm_stat, rpm_delay, id_probe_type, rpm_id, ' +
                    ' use_motohours, phone_nr, id_device_type, factor_approx_1, power_off_on_fuel_chart, id_approx_type_1, ' +
                    ' id_approx_type_2, factor_approx_2, ident, ident2, useles_city, useles_city_enabled, apn, alarm_tel, ' +
                    ' id_starter_type, id_email_cycle, mode_30_sec, sms_on_start, gps_always_on, road_correction, ' +
                    ' id_transmitter_mode, dyn_data_enabled, dyn_data_max_bad_time, dyn_data_max_useles, filter_first, ' +
					' id_car, cistern, last_gps_datetime, last_email_datetime, last_gps, last_gps_event, last_gps_status, last_packet_prefix, fuel_algorithm, to_delete) ' +
                   ' values(:firmware_version2, :LRx, :firmware_version2_changed, :last_222_datetime, :last_15_datetime, :gr1, :id_company, :name, :rej_numb, :useles, :fast_imp, :id_road_imp_div, ' +
					' :i_tank, :i_up, :rpm_obro, :rpm_disp, :mileage, ' +
					' :installation_date, :max_speed, :rpm_stat, :rpm_delay, :id_probe_type, :rpm_id, ' +
                    ' :use_motohours, :phone_nr, :id_device_type, :factor_approx_1, :power_off_on_fuel_chart, :id_approx_type_1, ' +
                    ' :id_approx_type_2, :factor_approx_2, :ident, :ident2, :useles_city, :useles_city_enabled, :apn, :alarm_tel, ' +
                    ' :id_starter_type, :id_email_cycle, :mode_30_sec, :sms_on_start, :gps_always_on, :road_correction, ' +
                    ' :id_transmitter_mode, :dyn_data_enabled, :dyn_data_max_bad_time, :dyn_data_max_useles, :filter_first, ' +
          					' :id_car, :cistern, :last_gps_datetime, :last_email_datetime, :last_gps, :last_gps_event, :last_gps_status, :last_packet_prefix, 0, :to_delete) ');

        qPanelQuery2.Close();
        qPanelQuery2.SQL.Clear();
        qPanelQuery2.SQL.Add('update car set firmware_version2 = :firmware_version2, LRx = :LRx, firmware_version2_changed = :firmware_version2_changed, last_222_datetime = :last_222_datetime, ' +
        'last_15_datetime = :last_15_datetime, gr1 = :gr1, name = :name, rej_numb = :rej_numb, useles = :useles, fast_imp = :fast_imp, id_road_imp_div = :id_road_imp_div, ' +
          ' i_tank = :i_tank, i_up = :i_up, rpm_obro = :rpm_obro, rpm_disp = :rpm_disp, mileage = :mileage, ' +
          ' installation_date = :installation_date, max_speed = :max_speed, rpm_stat = :rpm_stat, rpm_delay = :rpm_delay, id_probe_type = :id_probe_type, rpm_id = :rpm_id, ' +
                    ' use_motohours = :use_motohours, phone_nr = :phone_nr, id_device_type = :id_device_type, factor_approx_1 = :factor_approx_1, power_off_on_fuel_chart = :power_off_on_fuel_chart, id_approx_type_1 = :id_approx_type_1, ' +
                    ' id_approx_type_2 = :id_approx_type_2, factor_approx_2 = :factor_approx_2, ident = :ident, ident2 = :ident2, useles_city = :useles_city, useles_city_enabled = :useles_city_enabled, apn = :apn, alarm_tel = :alarm_tel, ' +
                    ' id_starter_type = :id_starter_type, id_email_cycle = :id_email_cycle, mode_30_sec = :mode_30_sec, sms_on_start = :sms_on_start, gps_always_on = :gps_always_on, road_correction = :road_correction, ' +
                    ' id_transmitter_mode = :id_transmitter_mode, dyn_data_enabled = :dyn_data_enabled, dyn_data_max_bad_time = :dyn_data_max_bad_time, dyn_data_max_useles = :dyn_data_max_useles, filter_first = :filter_first, ' +
          ' cistern = :cistern, last_gps_datetime = :last_gps_datetime, last_email_datetime = :last_email_datetime, last_gps = :last_gps, last_gps_event = :last_gps_event, last_gps_status = :last_gps_status, ' +
          'last_packet_prefix = :last_packet_prefix, fuel_algorithm = 0, to_delete = :to_delete ' +
               ' where id_company = :id_company and id_car = :id_car ');

        qPanelQuery3.Close();
        qPanelQuery3.SQL.Clear();
        qPanelQuery3.SQL.Add('select id_car from car where id_company = :id_company and id_car = :id_car ');

        setLength(car_ids, 0);

        while not qXML.Eof do
        begin
            qPanelQuery3.Parameters.ParamByName('id_company').Value := id_company;
            qPanelQuery3.Parameters.ParamByName('id_car').Value := qXML.FieldByName('id').AsInteger;
            qPanelQuery3.Open();
            tmp_id := qPanelQuery3.FieldByName('id_car').AsInteger;
            qPanelQuery3.Close();

            if tmp_id = 0 then
              Query_tmp := qPanelQuery
            else
              Query_tmp := qPanelQuery2;

            Query_tmp.Parameters.ParamByName('gr1').Value := qXML.FieldByName('gr1').AsInteger;
            Query_tmp.Parameters.ParamByName('id_company').Value := id_company;
            Query_tmp.Parameters.ParamByName('name').Value := qXML.FieldByName('name').AsString;
            Query_tmp.Parameters.ParamByName('rej_numb').Value := qXML.FieldByName('rej_numb').AsString;
            Query_tmp.Parameters.ParamByName('useles').Value := qXML.FieldByName('useles').AsFloat;
            Query_tmp.Parameters.ParamByName('fast_imp').Value := qXML.FieldByName('fast_imp').AsFloat;
            Query_tmp.Parameters.ParamByName('id_road_imp_div').Value := qXML.FieldByName('mod_imp').AsInteger;
            Query_tmp.Parameters.ParamByName('i_tank').Value := qXML.FieldByName('i_tank').AsInteger;
            Query_tmp.Parameters.ParamByName('i_up').Value := qXML.FieldByName('i_up').AsInteger;
            Query_tmp.Parameters.ParamByName('rpm_obro').Value := qXML.FieldByName('rpm_obro').AsInteger;
            Query_tmp.Parameters.ParamByName('rpm_disp').Value := qXML.FieldByName('rpm_disp').AsInteger;
            Query_tmp.Parameters.ParamByName('mileage').Value := qXML.FieldByName('count').AsFloat;
            Query_tmp.Parameters.ParamByName('installation_date').Value := qXML.FieldByName('c_date').AsDateTime;
            Query_tmp.Parameters.ParamByName('max_speed').Value := qXML.FieldByName('mspeed').AsInteger;
            if qXML.FieldByName('rpm_stat').AsString = 'T' then
                Query_tmp.Parameters.ParamByName('rpm_stat').Value := 1
            else
                Query_tmp.Parameters.ParamByName('rpm_stat').Value := 0;
            Query_tmp.Parameters.ParamByName('rpm_delay').Value := qXML.FieldByName('rpmdelay').AsInteger;
            Query_tmp.Parameters.ParamByName('id_probe_type').Value := qXML.FieldByName('sonda').AsInteger;
            Query_tmp.Parameters.ParamByName('rpm_id').Value := qXML.FieldByName('rpm_id').AsInteger;
            Query_tmp.Parameters.ParamByName('use_motohours').Value := qXML.FieldByName('car_type').AsInteger;
            Query_tmp.Parameters.ParamByName('phone_nr').Value := qXML.FieldByName('telefon').AsString;
            Query_tmp.Parameters.ParamByName('id_device_type').Value := qXML.FieldByName('isEmailGPS').AsInteger;
            Query_tmp.Parameters.ParamByName('factor_approx_1').Value := qXML.FieldByName('aproksymacja').AsFloat;
            if qXML.FieldByName('PowerOffOnFuelChart').AsBoolean then
                Query_tmp.Parameters.ParamByName('power_off_on_fuel_chart').Value := 1
            else
                Query_tmp.Parameters.ParamByName('power_off_on_fuel_chart').Value := 0;
            Query_tmp.Parameters.ParamByName('id_approx_type_1').Value := qXML.FieldByName('aproksym_kind').AsInteger;
            Query_tmp.Parameters.ParamByName('id_approx_type_2').Value := qXML.FieldByName('aproksym_kind2').AsInteger;
            Query_tmp.Parameters.ParamByName('factor_approx_2').Value := qXML.FieldByName('aproksymacja2').AsFloat;
            Query_tmp.Parameters.ParamByName('ident').Value := qXML.FieldByName('ident').AsString;
            Query_tmp.Parameters.ParamByName('ident2').Value := qXML.FieldByName('ident2').AsString;
            Query_tmp.Parameters.ParamByName('useles_city').Value := qXML.FieldByName('useles_city').AsFloat;
            if qXML.FieldByName('useles_city_enabled').AsBoolean then
                Query_tmp.Parameters.ParamByName('useles_city_enabled').Value := 1
            else
                Query_tmp.Parameters.ParamByName('useles_city_enabled').Value := 0;
            Query_tmp.Parameters.ParamByName('apn').Value := qXML.FieldByName('apn').AsString;
            Query_tmp.Parameters.ParamByName('alarm_tel').Value := qXML.FieldByName('alarm_tel').AsString;
            Query_tmp.Parameters.ParamByName('id_starter_type').Value := qXML.FieldByName('starter').AsInteger;
            Query_tmp.Parameters.ParamByName('id_email_cycle').Value := qXML.FieldByName('email_cycle').AsInteger;
            if qXML.FieldByName('second30').AsBoolean then
                Query_tmp.Parameters.ParamByName('mode_30_sec').Value := 1
            else
                Query_tmp.Parameters.ParamByName('mode_30_sec').Value := 0;
            if qXML.FieldByName('sms_on_start').AsBoolean then
                Query_tmp.Parameters.ParamByName('sms_on_start').Value := 1
            else
                Query_tmp.Parameters.ParamByName('sms_on_start').Value := 0;
            if qXML.FieldByName('gps_mode').AsBoolean then
                Query_tmp.Parameters.ParamByName('gps_always_on').Value := 1
            else
                Query_tmp.Parameters.ParamByName('gps_always_on').Value := 0;
            Query_tmp.Parameters.ParamByName('road_correction').Value := qXML.FieldByName('road_correction').AsInteger;
            Query_tmp.Parameters.ParamByName('id_transmitter_mode').Value := qXML.FieldByName('transmitter_mode').AsInteger;
            if qXML.FieldByName('dyn_data_enabled').AsBoolean then
                Query_tmp.Parameters.ParamByName('dyn_data_enabled').Value := 1
            else
                Query_tmp.Parameters.ParamByName('dyn_data_enabled').Value := 0;
            Query_tmp.Parameters.ParamByName('dyn_data_max_bad_time').Value := qXML.FieldByName('dyn_data_max_bad_time').AsInteger;
            Query_tmp.Parameters.ParamByName('dyn_data_max_useles').Value := qXML.FieldByName('dyn_data_max_useles').AsInteger;
            if qXML.FieldByName('filtr_kolejnosc').AsBoolean then
                Query_tmp.Parameters.ParamByName('filter_first').Value := 1
            else
                Query_tmp.Parameters.ParamByName('filter_first').Value := 0;
            Query_tmp.Parameters.ParamByName('id_car').Value := qXML.FieldByName('id').AsInteger;
            Query_tmp.Parameters.ParamByName('cistern').Value := qXML.FieldByName('cistern').AsInteger;
            if not qXML.FieldByName('last_gps_datetime').IsNull then
                Query_tmp.Parameters.ParamByName('last_gps_datetime').Value := qXML.FieldByName('last_gps_datetime').AsDateTime
            else
                Query_tmp.Parameters.ParamByName('last_gps_datetime').Value := Null;
            if not qXML.FieldByName('last_email_datetime').IsNull then
                Query_tmp.Parameters.ParamByName('last_email_datetime').Value := qXML.FieldByName('last_email_datetime').AsDateTime
            else
                Query_tmp.Parameters.ParamByName('last_email_datetime').Value := Null;
            Query_tmp.Parameters.ParamByName('last_gps').Value := qXML.FieldByName('last_gps').AsString;
            Query_tmp.Parameters.ParamByName('last_gps_event').Value := qXML.FieldByName('last_gps_event').AsInteger;
            Query_tmp.Parameters.ParamByName('last_gps_status').Value := qXML.FieldByName('last_gps_status').AsString;
            Query_tmp.Parameters.ParamByName('last_packet_prefix').Value := qXML.FieldByName('last_packet_prefix').AsString;

            if qXML.FieldByName('last_222_datetime').AsString = '' then
                Query_tmp.Parameters.ParamByName('last_222_datetime').Value := null
            else
                Query_tmp.Parameters.ParamByName('last_222_datetime').Value := qXML.FieldByName('last_222_datetime').AsDateTime;

            if qXML.FieldByName('last_15_datetime').AsString = '' then
                Query_tmp.Parameters.ParamByName('last_15_datetime').Value := null
            else
                Query_tmp.Parameters.ParamByName('last_15_datetime').Value := qXML.FieldByName('last_15_datetime').AsDateTime;

            if qXML.FieldByName('firmware_version2_changed').AsString = '' then
                Query_tmp.Parameters.ParamByName('firmware_version2').Value := null
            else
                Query_tmp.Parameters.ParamByName('firmware_version2').Value := qXML.FieldByName('firmware_version2').AsString;
            if qXML.FieldByName('LRx').AsString = '' then
                Query_tmp.Parameters.ParamByName('LRx').Value := null
            else
                Query_tmp.Parameters.ParamByName('LRx').Value := qXML.FieldByName('LRx').AsInteger;
            if qXML.FieldByName('firmware_version2_changed').AsString = '' then
                Query_tmp.Parameters.ParamByName('firmware_version2_changed').Value := Null
            else
                Query_tmp.Parameters.ParamByName('firmware_version2_changed').Value := qXML.FieldByName('firmware_version2_changed').AsString;

            Query_tmp.Parameters.ParamByName('to_delete').Value := qXML.FieldByName('to_delete').AsInteger;

            Query_tmp.ExecSQL();

            setLength(car_ids, length( car_ids) + 1);
            car_ids[length( car_ids) - 1] := qXml.FieldByName('id').AsInteger;

            qXML.Next();
        end;
        qXML.Close();

        tmp_str := '';
        for licznik_car :=0 to length( car_ids) - 1 do
            tmp_str := tmp_str + IntToStr(car_ids[licznik_car]) + ', ';

        tmp_str := copy(tmp_str, 1, Length(tmp_str) - 2);


        qPanelQuery3.SQL.Add('delete from car where id_company = :id_company and not(id_car in (' +
         tmp_str + '))');
        qPanelQuery3.ExecSQL();



        qPanelQuery.Close();
        qPanelQuery.SQL.Clear();
        qPanelQuery.SQL.Add('insert into deleted_car (id_company, id_car, car_name, car_rej_numb, company_name, dataczas) ');
        qPanelQuery.SQL.Add('select t1.id_company, t3.id_car, t3.name, t3.rej_numb, t1.name, GETDATE() ');
        qPanelQuery.SQL.Add(' from company t1 inner join ');
        qPanelQuery.SQL.Add('	  car t3 on (t1.id_company = t3.id_company) left join ');
        qPanelQuery.SQL.Add('	  deleted_car t4 on (t4.id_company = t1.id_company and t4.id_car = t3.id_car) ');
        qPanelQuery.SQL.Add(' where t3.to_delete = 1 and t4.id_car is null ');
        qPanelQuery.ExecSQL();

        qPanelQuery.Close();
        qPanelQuery.SQL.Clear();
        qPanelQuery.SQL.Add(' delete from deleted_car ');
        qPanelQuery.SQL.Add(' where ((id_company * 10000) + id_car) in ');
        qPanelQuery.SQL.Add(' ( ');
        qPanelQuery.SQL.Add('  select ((t1.id_company * 10000) + t3.id_car) ');
        qPanelQuery.SQL.Add('  from company t1 inner join ');
        qPanelQuery.SQL.Add('	   car t3 on (t1.id_company = t3.id_company) left join ');
        qPanelQuery.SQL.Add('	   deleted_car t4 on (t4.id_company = t1.id_company and t4.id_car = t3.id_car) ');
        qPanelQuery.SQL.Add('  where (t3.to_delete = 0 or t3.to_delete is null) and t3.id_car is not null and t4.id_car is not null ');
        qPanelQuery.SQL.Add(' ) ');
        qPanelQuery.ExecSQL();

        qPanelQuery.Close();
        qPanelQuery.SQL.Clear();
        qPanelQuery.SQL.Add('select max(id_analysis_results) max_ from analysis_results where id_company = ' + IntToStr(id_company));
        qPanelQuery.Open();
        max_ := qPanelQuery.FieldByName('max_').AsInteger;
        qPanelQuery.Close();

        qXML.Close();
        qXML.SQL.Clear();
        qXML.SQL.Add('select * from analysis_results  where id_analysis_results > ' + IntToStr(max_) + ' order by id_analysis_results ');
        qXML.Open();


        qPanelQuery.Close();
        qPanelQuery.SQL.Clear();
        qPanelQuery.SQL.Add('INSERT INTO analysis_results ');
        qPanelQuery.SQL.Add('(id_analysis_results, id_analysis, id_company, id_car, start, stop2, analysis_passed, firmware_version, error_stop) ');
        qPanelQuery.SQL.Add('VALUES (:id_analysis_results, :id_analysis, :id_company, :id_car, :start, :stop2, :analysis_passed, :firmware_version, :error_stop) ');

        while not qXML.Eof do
        begin
            qPanelQuery.Parameters.ParamByName('id_analysis_results').Value :=
                qXML.FieldByName('id_analysis_results').AsInteger;
            qPanelQuery.Parameters.ParamByName('id_analysis').Value :=
                qXML.FieldByName('id_analysis').AsInteger;
            qPanelQuery.Parameters.ParamByName('id_company').Value :=
                id_company;
            qPanelQuery.Parameters.ParamByName('id_car').Value :=
                qXML.FieldByName('id_car').AsInteger;
            qPanelQuery.Parameters.ParamByName('start').Value :=
                qXML.FieldByName('start').AsDateTime;
            qPanelQuery.Parameters.ParamByName('stop2').Value :=
                qXML.FieldByName('stop2').AsDateTime;
            qPanelQuery.Parameters.ParamByName('analysis_passed').Value :=
                qXML.FieldByName('analysis_passed').AsInteger;
            qPanelQuery.Parameters.ParamByName('firmware_version').Value :=
                qXML.FieldByName('firmware_version').AsString;
            if qXML.FieldByName('error_stop').IsNull then
                qPanelQuery.Parameters.ParamByName('error_stop').Value := Null
            else
                qPanelQuery.Parameters.ParamByName('error_stop').Value :=
                    qXML.FieldByName('error_stop').AsDateTime;
            qPanelQuery.ExecSQL();

            qXML.Next();
        end;
        qXML.Close();


{
        qXML.Close();
        qXML.SQL.Clear();
        qXML.SQL.Add('select 1 id, t1.description enabled_desc, t2.description disabled_desc from ' +
                        'event t1, event t2 where t1.id_event = 1 and t2.id_event = 31 union ' +
                        'select 2 id, t1.description enabled_desc, t2.description disabled_desc from ' +
                        'event t1, event t2 where t1.id_event = 2 and t2.id_event = 32 union ' +
                        'select 3 id, t1.description enabled_desc, t2.description disabled_desc from ' +
                        'event t1, event t2 where t1.id_event = 3 and t2.id_event = 33 union ' +
                        'select 4 id, t1.description enabled_desc, t2.description disabled_desc from ' +
                        'event t1, event t2 where t1.id_event = 4 and t2.id_event = 34 union ' +
                        'select 5 id, t1.description enabled_desc, t2.description disabled_desc from ' +
                        'event t1, event t2 where t1.id_event = 5 and t2.id_event = 35 ');


        qXML.Close();
        qXML.SQL.Clear();
        qXML.SQL.Add('select id_driver id, driver_name nazwa, fired was_deleted from driver');

        qXML.Close();
        qXML.SQL.Clear();
        qXML.SQL.Add('select id_car car_no, id_driver driver_no, start_date poczatek, end_date koniec from car_change');

        qXML.Close();
        qXML.SQL.Clear();
        qXML.SQL.Add('select * from mail_settings');

        qXML.Close();
        qXML.SQL.Clear();
        qXML.SQL.Add('select * from carnet_settings');
}

//        ADOConnectionPanel.Close();

    finally
//        ADOConnectionPanel.Close();
    end;
end;

procedure TTEDEmailSrv.IdLogEvent1Status(ASender: TComponent;
  const AText: string);
begin
    AddLog(AText);
end;

function TTEDEmailSrv.IsPanelInfoInINI(): Boolean;
var ini: TStrings;
begin
    ini := TStringList.Create();
    ini.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini');
    result := (ini.Values['admin_panel_Initial Catalog'] <> '');
    ini.Free();
end;

function TTEDEmailSrv.IsRetrieveStreetsEnabled(): Boolean;
var ini: TStrings;
begin
    ini := TStringList.Create();
    ini.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini');
    result := (ini.Values['dodatkowe_RetrieveStreets'] = '1');
    ini.Free();
end;

procedure TTEDEmailSrv.RetrieveStreets(id_car: Integer);
var _datetime: TDateTime;
    q: TCustomADODataSet;
    was_add_first: Boolean;
    was_add_second: Boolean;
    Position: IEmapaPosition;
    ReportCollection: IReportEmapaCollection;
    ReportEntry: IReportEmapaEntry;

    LocalizeObject: ILocalizeEmapaObject;
    EmapaTransportPlus: ILocalizeEmapaApp;
    LocalizeCollection: ILocalizeEmapaCollection;
    i, first_id: Integer;
//    evb2: Integer;
begin
    if not IsRetrieveStreetsEnabled() then
        exit;

try
    AddLog('12534 Pobieranie ulic dla pojazdu nr ' + IntToStr(id_car) + ' ...');

    qStreet.Close();
    qStreet.SQL.Clear();
    qStreet.SQL.Add('select max(_datetime) _datetime from street where id_car = :id_car');
    qStreet.Parameters.ParamByName('id_car').Value := id_car;
    qStreet.Open();
    _datetime := qStreet.FieldByName('_datetime').AsDateTime;
    qStreet.Close();
    if (_datetime = 0) then // gdy nie by³y szukane ulice dla danego pojazdu
        _datetime := Date() - 7; // to rozpocznij szukanie ulic 4 miesi¹ce wstecz

{
    qStreet.Close();
    qStreet.SQL.Clear();
    qStreet.SQL.Add('SELECT evb2, max(start_praca) start_praca  FROM cache_day_work  where data > ''2011-06-01'' and data < ''2011-08-01'' and (szerokosc0 is null or szerokosc0 = '''') and evb2 = ' + IntToStr(id_car) + ' group by evb2 ');
    qStreet.Open();
    evb2 := qStreet.FieldByName('evb2').AsInteger;
    qStreet.Close();


    if evb2 <> 0 then
    begin
        qStreet.Close();
        qStreet.SQL.Clear();
        qStreet.SQL.Add('delete from street where _datetime >= :_datetime and id_car = :id_car');
        qStreet.Parameters.ParamByName('_datetime').Value := EncodeDate(2011, 6, 1);
        qStreet.Parameters.ParamByName('id_car').Value := id_car;
        qStreet.ExecSQL();

        qStreet.Close();
        qStreet.SQL.Clear();
        qStreet.SQL.Add('delete from cache_day_work where start_praca >= :start_praca and evb2 = :evb2');
        qStreet.Parameters.ParamByName('start_praca').Value := EncodeDate(2011, 6, 1);
        qStreet.Parameters.ParamByName('evb2').Value := id_car;
        qStreet.ExecSQL();

        _datetime := EncodeDate(2011, 6, 1);

        Addlog('   Generowanie cache od czerwca 2011...');

        spDayWork.Parameters.ParamByName('@no_cache').Value := 2; // nie pobieraj danych z cache, zapisane wyniki umieœæ w cache
    end
    else
        spDayWork.Parameters.ParamByName('@no_cache').Value := 2; // nie pobieraj danych z cache, zapisane wyniki umieœæ w cache
 }
    spDayWork.Parameters.ParamByName('@no_cache').Value := 2; // nie pobieraj danych z cache, zapisane wyniki umieœæ w cache
    spDayWork.Parameters.ParamByName('@start').Value := _datetime;
    spDayWork.Parameters.ParamByName('@stop').Value := Now();
    spDayWork.Parameters.ParamByName('@car_or_driver_no').Value := id_car;
    spDayWork.Parameters.ParamByName('@isInCarMode').Value := 1;
    spDayWork.Parameters.ParamByName('@calculate_fuel').Value := 0;
    spDayWork.Parameters.ParamByName('@DoNotShowEmptyTracks').Value := 0;
    spDayWork.Parameters.ParamByName('@show_only_last_day_route').Value := 0;
    spDayWork.Parameters.ParamByName('@with_gps').Value := 1;
    spDayWork.Parameters.ParamByName('@kosztPaliwa').Value := 0.0;
    spDayWork.Open();

    q := spDayWork;
    q.First();
    first_id := q.FieldByName('id').AsInteger;

    EmapaTransportPlus := ILocalizeEmapaApp.CreateEmapaMapCenter('bryza.emapa.pl', 6090, 'tedelectronics', '4DHJS2My');
//    EmapaTransportPlus := ILocalizeEmapaApp.CreateEmapaMapCenter('zefirek.emapa.pl', 6090, 'tedele1', '2cjr2z2W');
    LocalizeCollection := EmapaTransportPlus.CreateLocalizeCollection();
    LocalizeObject := LocalizeCollection.Add(EmptyParam, EmptyParam);
    LocalizeObject.EntID := 1;
    LocalizeObject.Name := '';
    LocalizeObject.ShowName := False;
    LocalizeObject.IconIndex := 0;
    LocalizeObject.ShowIcon := False;
    LocalizeObject.IconColor := $FF00FF;
    LocalizeObject.PathColor := $FF00FF;
    LocalizeObject.PathWidth := 2;
    LocalizeObject.Size := 2;
//    LocalizeObject.RemovePrevious := False;
//    LocalizeObject.PointsConnected := True;

    LocalizeObject.RemovePrevious := True;
    LocalizeObject.PointsConnected := False;


    FormatSettings.DecimalSeparator := '.';
    was_add_first := False;
    was_add_second := False;
    while not q.Eof do
    begin
        if not was_add_first then
        begin
            Position := LocalizeObject.Positions.Add(EmptyParam, EmptyParam, EmptyParam, EmptyParam);
            Position.Longitude := StrToFloatDef(q.FieldByName('dlugosc0').AsString, 0.0);
            Position.Latitude := StrToFloatDef(q.FieldByName('szerokosc0').AsString, 0.0);
            Position.Time := q.FieldByName('start_praca').AsDateTime;
            q.Next();
            was_add_first := True;
            if q.Eof then
            begin
                Position := LocalizeObject.Positions.Add(EmptyParam, EmptyParam, EmptyParam, EmptyParam);
                Position.Longitude := StrToFloatDef(q.FieldByName('dlugosc').AsString, 0.0);
                Position.Latitude := StrToFloatDef(q.FieldByName('szerokosc').AsString, 0.0);
                Position.Time := q.FieldByName('stop_praca').AsDateTime;
            end;
            continue;
        end
        else
        if not was_add_second then
        begin
            Position := LocalizeObject.Positions.Add(EmptyParam, EmptyParam, EmptyParam, EmptyParam);
            Position.Longitude := StrToFloatDef(q.FieldByName('dlugosc0').AsString, 0.0);
            Position.Latitude := StrToFloatDef(q.FieldByName('szerokosc0').AsString, 0.0);
            Position.Time := q.FieldByName('start_praca').AsDateTime;
            was_add_second := True;
        end;

        Position := LocalizeObject.Positions.Add(EmptyParam, EmptyParam, EmptyParam, EmptyParam);
        Position.Longitude := StrToFloatDef(q.FieldByName('dlugosc').AsString, 0.0);
        Position.Latitude := StrToFloatDef(q.FieldByName('szerokosc').AsString, 0.0);
        Position.Time := q.FieldByName('stop_praca').AsDateTime;

        q.Next();
    end;

    AddLog('   12656 Przygotowano listê ' + IntToStr(LocalizeObject.Positions.Count) + ' ulic dla pojazdu nr ' + IntToStr(id_car));

    ReportCollection := EMapaTransportPlus.RetrieveReport2(
        1, 1, nil);

    AddLog('   12661 Mapcenter zwróci³ ' + IntToStr(ReportCollection.Count) + ' ulic dla pojazdu nr ' + IntToStr(id_car));

    for i := 1 to ReportCollection.Count do
    begin
        ReportEntry := ReportCollection.Item[i];
        ReportEntry.PositionInCollection();

        if i = 1 then
        begin
            q.First();
            if q.Locate('id', first_id - 1 + i, []) then
            begin
                q.Edit();
                q.FieldByName('ulica_start').AsString := ReportEntry.Neighbourhood;
                q.Post();
            end;
        end
        else
        if i < ReportCollection.Count then
        begin
            q.First();
            if q.Locate('id', first_id - 1 + i - 1, []) then
            begin
                q.Edit();
                q.FieldByName('ulica_stop').AsString := ReportEntry.Neighbourhood;
                q.Post();
            end;

            q.First();
            if q.Locate('id', first_id - 1 + i, []) then
            begin
                q.Edit();
                q.FieldByName('ulica_start').AsString := ReportEntry.Neighbourhood;
                q.Post();
            end;
        end
        else
        begin
            q.First();
            if q.Locate('id', first_id - 1 + i - 1, []) then
            begin
                q.Edit();
                q.FieldByName('ulica_stop').AsString := ReportEntry.Neighbourhood;
                q.Post();
            end;
        end;
    end;
    ReportCollection.Free();

    LocalizeObject.Positions.Clear();

    if LocalizeCollection <> nil then
        LocalizeCollection.Clear();
    if EMapaTransportPlus <> nil then
        EMapaTransportPlus.CleanLocalizeInfo();
    if LocalizeCollection <> nil then
        LocalizeCollection.Free();
//    LocalizeCollection := nil;
//    LocalizeObject := nil;
    if EMapaTransportPlus <> nil then
        EMapaTransportPlus.Free();
//    EMapaTransportPlus := nil;

    qStreet.Close();
    qStreet.SQL.Clear();
    qStreet.SQL.Add('insert into street (id_car, _datetime, szerokosc, dlugosc, street) values(:id_car, :_datetime, :szerokosc, :dlugosc, :street) ');


    q.First();
    while not q.Eof do
    begin
        qStreet.Parameters.ParamByName('id_car').Value := id_car;
        qStreet.Parameters.ParamByName('_datetime').Value := q.FieldByName('start_praca').AsDateTime;
        qStreet.Parameters.ParamByName('szerokosc').Value := q.FieldByName('szerokosc0').AsString;
        qStreet.Parameters.ParamByName('dlugosc').Value := q.FieldByName('dlugosc0').AsString;
        qStreet.Parameters.ParamByName('street').Value := q.FieldByName('ulica_start').AsString;
        qStreet.ExecSQL();

        q.Next();
    end;

    if q.FieldByName('stop_praca').AsDateTime <> 0 then
    begin
        qStreet.Parameters.ParamByName('id_car').Value := id_car;
        qStreet.Parameters.ParamByName('_datetime').Value := q.FieldByName('stop_praca').AsDateTime;
        qStreet.Parameters.ParamByName('szerokosc').Value := q.FieldByName('szerokosc').AsString;
        qStreet.Parameters.ParamByName('dlugosc').Value := q.FieldByName('dlugosc').AsString;
        qStreet.Parameters.ParamByName('street').Value := q.FieldByName('ulica_stop').AsString;
        qStreet.ExecSQL();
    end;

    q.Close();

except
    on e: Exception do
    begin
        AddLog(e.Message);
    end;
end;

end;

{
procedure TTEDEmailSrv.EurekaLog1CustomDataRequest(
  EurekaExceptionRecord: TEurekaExceptionRecord; DataFields: TStrings);
begin
    DataFields.Add('ident=' + ident);

    try
        sp_spaceused.Open();
        database_size := sp_spaceused.FieldByName('database_size').AsString;
        DataFields.Add('database_size=' + database_size);
        sp_spaceused.Close();
    except
    end;
end;

procedure TTEDEmailSrv.EurekaLog1CustomWebFieldsRequest(
  EurekaExceptionRecord: TEurekaExceptionRecord; WebFields: TStrings);
var info: PEurekaDebugInfo;
//    archiwum: TBLTArchive;
//    znak: Char;
//    wynik: TStrings;
begin
    try
      if EurekaExceptionRecord.ExceptionObject is Exception then
        WebFields.Add('Message=' + UTF8Encode(Exception(EurekaExceptionRecord.ExceptionObject).Message));
    except
    end;

    try
      info := EurekaExceptionRecord.CallStack[0];
      WebFields.Add('ClassName=' + info^.ClassName);
      WebFields.Add('UnitName=' + info^.UnitName);
      WebFields.Add('ProcedureName=' + info^.ProcedureName);
      WebFields.Add('Line=' + IntToStr(info^.Line));
      WebFields.Add('ProcOffsetLine=' + IntToStr(info^.ProcOffsetLine));

//      wynik := TStringList.Create();
//      CallStackToStrings(EurekaExceptionRecord.CallStack, wynik);
//      Clipboard.AsText := wynik.Text;

//      WebFields.Add('CallStackToStrings=' + wynik.Text);

    except
    end;

    WebFields.Add('company_ident=' + ident);
    WebFields.Add('carnet_ver=' + Installed_version);

    WebFields.Add('database_size=' + database_size);

//    try
//        WebFields.Add('archiwum=' + archiwumStr);
//    except
//    end;
    WebFields.Add('email=' + '');
    WebFields.Add('phone=' + '');
end;
}

procedure TTEDEmailSrv.SavePaliwoToStream(paliwo_char: TCharakterystykaArray;
                                                var stream: TStream; event: TOnProcentLog);
var j, k: Integer;
    value_integer: Integer;
    bufor: array [0..8000] of Char;
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
begin
//    SaveInteger(1 + 1 + 256 + 1);
    SaveInteger(1 + 1 + 1024 + 1);
    SaveString('car_no');
    SaveString('ftInteger');
    SaveString('nr_zb');
    SaveString('ftInteger');
//    for j := 0 to 255 do
    for j := 0 to 1023 do
    begin
        SaveString('pal' + IntToStr(j));
        SaveString('ftFloat');
    end;
    SaveString('changed');
    SaveString('ftInteger');

    ile_rekordow := Length(paliwo_char);
    rec_pos := 0;

    licznik := 0;
    for j := 0 to Length(paliwo_char) - 1 do
    begin
        SaveInteger(0);
        SaveInteger(paliwo_char[j].car_no);
        SaveInteger(0);
        SaveInteger(paliwo_char[j].zb_nr);

        SaveInteger(0);
        SaveInteger(paliwo_char[j].id_chart_type);
        SaveInteger(0);
        SaveInteger(paliwo_char[j].max_probe);

        for k := 0 to paliwo_char[j].max_probe do
        begin
            SaveInteger(0);
            SaveDouble(paliwo_char[j].liters2[k]);
        end;
        for k := paliwo_char[j].max_probe + 1 to 1023 do
        begin
            SaveInteger(0);
            SaveDouble(0.0);
        end;
        SaveInteger(0);
        SaveInteger(1);

        Inc(licznik);

        Inc(rec_pos);
        if (@event) <> nil then
            event(Trunc((rec_pos * 100) / ile_rekordow));
    end;
    SaveInteger(licznik);
end;

procedure TTEDEmailSrv.SavePaliwoTmpToStream(paliwo_char: TCharakterystykaArray;
                                                var stream: TStream; event: TOnProcentLog);
var j, k: Integer;
    value_integer: Integer;
    bufor: array [0..8000] of Char;
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
begin
    SaveInteger(5);
    SaveString('car_no');
    SaveString('ftInteger');
    SaveString('nr_zb');
    SaveString('ftInteger');
    SaveString('pal');
    SaveString('ftInteger');
    SaveString('value');
    SaveString('ftFloat');
    SaveString('next_value');
    SaveString('ftFloat');


    ile_rekordow := Length(paliwo_char);
    rec_pos := 0;

    licznik := 0;
    for j := 0 to Length(paliwo_char) - 1 do
    begin
        for k := 0 to paliwo_char[j].max_probe do
        begin
            SaveInteger(0);
            SaveInteger(paliwo_char[j].car_no);
            SaveInteger(0);
            SaveInteger(paliwo_char[j].zb_nr);
            SaveInteger(0);
            SaveInteger(k);
            SaveInteger(0);
            SaveDouble(paliwo_char[j].liters2[k]);
            SaveInteger(0);
            SaveDouble(paliwo_char[j].liters2[Min(k + 1, paliwo_char[j].max_probe)]);
        end;

        Inc(licznik);

        Inc(rec_pos);
        if (@event) <> nil then
            event(Trunc((rec_pos * 100) / ile_rekordow));
    end;
    SaveInteger(licznik);
end;

procedure TTEDEmailSrv.SaveSelectToStream(select_statement: String;
                                                var stream: TStream; event: TOnProcentLog);
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
    qSaveSelect.Close();
    qSaveSelect.SQL.Clear();
    qSaveSelect.SQL.Add(select_statement);
//    qSaveSelect.SQL.SaveToFile('d:\nowy.txt');
    qSaveSelect.Open();
    ile_rekordow := qSaveSelect.RecordCount;
    rec_pos := 0;
    SaveInteger(qSaveSelect.Fields.Count);
    for i := 0 to qSaveSelect.Fields.Count - 1 do
    begin
        field := qSaveSelect.Fields.Fields[i];
        SaveString(field.FieldName);
        if field.DataType in [ftString, ftWideString] then
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
        if field.DataType in [ftBoolean] then
            SaveString('ftInteger')
        else
            raise Exception.CreateFmt('Nie obs³ugiwane', []);
    end;
    licznik := 0;
    while not qSaveSelect.Eof do
    begin
        for i := 0 to qSaveSelect.Fields.Count - 1 do
        begin
            field := qSaveSelect.Fields.Fields[i];

            if field.IsNull then
                SaveInteger(1)
            else
                SaveInteger(0);

            if field.FieldName = 'gps_mode' then
            begin
                if field.AsBoolean then
                    SaveInteger(0)
                else
                    SaveInteger(1);
                continue;
            end;

            if field.DataType = ftBoolean then
            begin
                if field.AsBoolean then
                    SaveInteger(1)
                else
                    SaveInteger(0);
                continue;
            end;

            if field.DataType in [ftString, ftWideString] then
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
            if field.DataType in [ftBoolean] then
            begin
                if field.AsBoolean then
                    SaveInteger(1)
                else
                    SaveInteger(0);
            end
            else
                raise Exception.CreateFmt('Nie obs³ugiwane', []);
        end;
        Inc(licznik);
        qSaveSelect.Next();

        Inc(rec_pos);
        if (@event) <> nil then
            event(Trunc((rec_pos * 100) / ile_rekordow));
    end;
    qSaveSelect.Close();
    SaveInteger(licznik);
end;

function TTEDEmailSrv.LoadSelectFromStream(stream: TStream): TStreamDataSet;
begin
    result := TStreamDataSet.Create(stream);
end;

procedure TTEDEmailSrv.CopyStreamSelectToInsertQuery(source: TStreamDataSet;
              create_dest: TADOQuery; event: TOnProcentLog;
              update_dest2: TADOQuery = nil; ids: TIDs = nil;
              dest_primary_key: String = '';
              source_primary_key: String = '';
              exception_source_column: String = '';
              exception_source_column_must_be_null: Boolean = False;
              dest_table_name: String = '';
              delete_if_not_in_source: Boolean = True);
var i, j, k: Integer;
    param: TParameter;
    tmp: String;
    double_tmp: double;
    int_tmp: integer;
    flaga: array of Byte;
    dest: TADOQuery;

    function IsExistDestPrimary(value: Integer): Boolean;
    begin
        k := 0;
        while k < Length(ids) do
        begin
            if ids[k].dest_key_value = value then
                break;
            inc(k);
        end;
        result := (k < Length(ids));
    end;
begin
    if source_primary_key <> '' then
    begin
        k := 0;
        while k < Length(ids) do
        begin
            ids[k].in_source := False;
            inc(k);
        end;
    end;
    while not source.Eof do
    begin
        if exception_source_column <> '' then
            if source.FieldByName(exception_source_column).IsNull <>
                exception_source_column_must_be_null then
            begin
                source.Next();
                continue;
            end;

        if source_primary_key <> '' then
        begin
            k := 0;
            while k < Length(ids) do
            begin
                if ids[k].dest_key_value =
                      source.FieldByName(source_primary_key).AsInteger then break;
                inc(k);
            end;
            if k < Length(ids) then
                ids[k].in_source := True;
        end;

        if (source_primary_key = '') then
            dest := create_dest
        else
        if IsExistDestPrimary(source.FieldByName(source_primary_key).AsInteger) then
            dest := update_dest2
        else
            dest := create_dest;
        for i := 0 to dest.Parameters.Count - 1 do
        begin
            param := dest.Parameters.Items[i];
            if param.Name = 'id_fuel_tank' then
            begin
                TEDEmailSrv.tmp4.Close();
                TEDEmailSrv.tmp4.SQL.Clear;
                TEDEmailSrv.tmp4.SQL.Add('select id_fuel_tank from fuel_tank ' +
                    'where id_car = :id_car and tank_nr = :tank_nr ');
                TEDEmailSrv.tmp4.Parameters.ParamByName('id_car').Value :=
                    source.FieldByName('car_no').AsFloat;
                TEDEmailSrv.tmp4.Parameters.ParamByName('tank_nr').Value :=
                    source.FieldByName('nr_zb').AsFloat;
                TEDEmailSrv.tmp4.Open();
                param.Value := TEDEmailSrv.tmp4.FieldByName('id_fuel_tank').AsFloat;
                TEDEmailSrv.tmp4.Close();
                continue;
            end;
            if source.ExistField(param.Name) then
            begin
                if param.Name = 'gps_mode' then
                begin
                    if source.FieldByName(param.Name).AsInteger = 1 then
                        param.Value := 0
                    else
                        param.Value := 1;
                    continue;
                end;

                if param.Name = 'aproksym_kind2' then
                begin
                    if source.FieldByName('second_aproksym').AsInteger = 0 then
                        param.Value := 0
                    else
                        param.Value := source.FieldByName(param.Name).AsInteger;
                    continue;
                end;

                if param.Name = 'mod_imp' then
                begin
                    TEDEmailSrv.tmp4.Close();
                    TEDEmailSrv.tmp4.SQL.Clear;
                    TEDEmailSrv.tmp4.SQL.Add('select t2.id_road_imp_div from road_imp_div t2 where t2.imp_div = :mod_imp ');
                    TEDEmailSrv.tmp4.Parameters.ParamByName('mod_imp').Value :=
                        source.FieldByName(param.Name).AsFloat;
                    TEDEmailSrv.tmp4.Open();
                    param.Value := TEDEmailSrv.tmp4.FieldByName('id_road_imp_div').AsFloat;
                    TEDEmailSrv.tmp4.Close();
                    continue;
                end;
                if not source.FieldByName(param.Name).IsNull then
                if source.FieldByName(param.Name).DataType in [ftString, ftWideString] then
                begin
                    if source.FieldByName(param.Name).AsString = 'T' then
                    begin
                        param.Value := 1;
                        continue;
                    end;
                    if source.FieldByName(param.Name).AsString = 'N' then
                    begin
                        param.Value := 0;
                        continue;
                    end;
                end;
                if source.FieldByName(param.Name).IsNull then
                    param.Value := 0
                else
                if param.DataType in [ftString, ftWideString] then
                    param.Value := source.FieldByName(param.Name).AsString
                else
                if param.DataType in [ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint] then
                begin
                    if param.Name = 'rpm_stat' then
                    begin
                        if source.FieldByName(param.Name).AsString = 'T' then
                            param.Value := 1
                        else
                            param.Value := 0;
                    end
                    else
                    if param.Name = 'filtr_kolejnosc' then
                    begin
                        if source.FieldByName(param.Name).AsInteger = 0 then
                            param.Value := 1
                        else
                            param.Value := 0;
                    end
                    else
                        param.Value := source.FieldByName(param.Name).AsInteger;
                end
                else
                if param.DataType in [ftFloat, ftCurrency, ftBCD] then
                    param.Value := source.FieldByName(param.Name).AsFloat
                else
                if param.DataType in [ftDate, ftTime, ftDateTime] then
                    param.Value := source.FieldByName(param.Name).AsDateTime
                else
                if param.DataType in [ftVarBytes] then
                begin
                    tmp := source.FieldByName(param.Name).AsString;
                    SetLength(flaga, Length(tmp));
                    for j := 1 to Length(tmp) do
                        flaga[j - 1] := Byte(tmp[j]);
                    param.Value := flaga;
                end
                else
                if param.DataType in [ftUnknown] then
                begin
                    tmp := source.FieldByName(param.Name).AsString;
                    if TryStrToInt(tmp, int_tmp) and
                        (source.FieldByName(param.Name).DataType in [ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint]) then
                    begin
                        param.Value := int_tmp;
                    end
                    else
                    if TryStrToFloat(tmp, double_tmp) and
                        (source.FieldByName(param.Name).DataType in [ftFloat, ftCurrency, ftBCD]) then
                    begin
                        param.Value := double_tmp;
                    end
                    else
                        param.Value := tmp;
                end
                else
                if param.DataType in [ftBoolean] then
                begin
                   if source.FieldByName(param.Name).AsInteger > 0 then
                       param.Value := 1
                   else
                       param.Value := 0;
                end
                else
                    raise Exception.CreateFmt('Nie obs³u¿ona sytuacja', []);
            end
            else
                param.Value := Null;
            if (not source.ExistField(param.Name)) or
                  source.FieldByName(param.Name).IsNull then
            begin
                if (VarType(param.Value) = varString) or
                   (VarType(param.Value) = varOleStr) then
                  param.Value := ''
                else
                if param.Name = 'koniec' then
                  param.Value := Null
                else
                  param.Value := 0;
            end
            else
            if (not source.ExistField(param.Name)) or (source.FieldByName(param.Name).DataType in [ftFloat, ftCurrency, ftBCD]) or
                   (source.FieldByName(param.Name).DataType in [ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint]) then
                if (VarType(param.Value) <> varString) and
                     (VarType(param.Value) <> varUnknown) and
                     (VarType(param.Value) <> varOleStr) and
                     (VarType(param.Value) <> 14) and
                     (VarType(param.Value) <> varBoolean) then
                    if param.Value = -1 then
                        param.Value := 0;
        end;
        try
//            dest.ParamCheck := True;
            dest.ExecSQL();
        except

        end;
        source.Next();
        if (@event) <> nil then
            event(Trunc((source.RecNo() * 100) / source.RecordCount));
    end;

    if (source_primary_key <> '') and (dest_table_name = 'car') {and delete_if_not_in_source} then
    begin
        k := 0;
        while k < Length(ids) do
        begin
            if not ids[k].in_source then
            begin
                TEDEmailSrv.tmp4.Close();
                TEDEmailSrv.tmp4.SQL.Clear();
                TEDEmailSrv.tmp4.SQL.Add('update ' + dest_table_name + ' set to_delete = 1 where ' +
                    dest_primary_key + ' = ' + IntToStr(ids[k].dest_key_value) + ' and not (name like ''AUTO NR%'') ');
                TEDEmailSrv.tmp4.ExecSQL();
            end
            else
            begin
                TEDEmailSrv.tmp4.Close();
                TEDEmailSrv.tmp4.SQL.Clear();
                TEDEmailSrv.tmp4.SQL.Add('update ' + dest_table_name + ' set to_delete = 0 where ' +
                    dest_primary_key + ' = ' + IntToStr(ids[k].dest_key_value) + ' and not (name like ''AUTO NR%'') ');
                TEDEmailSrv.tmp4.ExecSQL();
            end;
            inc(k);
        end;
    end
    else
    if (source_primary_key <> '') and delete_if_not_in_source then
    begin
        k := 0;
        while k < Length(ids) do
        begin
            if not ids[k].in_source then
            begin
                TEDEmailSrv.tmp4.Close();
                TEDEmailSrv.tmp4.SQL.Clear();
                TEDEmailSrv.tmp4.SQL.Add('delete from ' + dest_table_name + ' where ' +
                    dest_primary_key + ' = ' + IntToStr(ids[k].dest_key_value));
                TEDEmailSrv.tmp4.ExecSQL();
            end;
            inc(k);
        end;
    end;
end;

procedure TTEDEmailSrv.ProceduraDeviceData2(create: boolean);
begin
    tmp.SQL.Clear();
    if create then
        tmp.SQL.Add('create procedure device_data2 ')
    else
        tmp.SQL.Add('alter procedure device_data2 ');
    tmp.SQL.Add('  @id_car int, ');
    tmp.SQL.Add('  @kod_zdarzenia int, ');
    tmp.SQL.Add('  @start datetime, ');
    tmp.SQL.Add('  @stop datetime ');
    tmp.SQL.Add('as ');
    tmp.SQL.Add('	create table #stan_pojazdu ');
    tmp.SQL.Add('	( ');
    tmp.SQL.Add('		id int not null identity(1, 1), ');
    tmp.SQL.Add('		from_ datetime not null, ');
    tmp.SQL.Add('		to_ datetime not null, ');
    tmp.SQL.Add('		zalaczony_silnik int not null, ');
    tmp.SQL.Add('		primary key (id) ');
    tmp.SQL.Add('	) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	declare @start2 datetime; ');
    tmp.SQL.Add('	declare @stop2 datetime; ');
    tmp.SQL.Add('	set @start2 = DATEADD(month, -1, @start) ');
    tmp.SQL.Add('	set @stop2 = DATEADD(month, 1, @stop) ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	declare @evb3 int ');
    tmp.SQL.Add('	declare @date datetime ');
    tmp.SQL.Add('	declare @evb3_prior int ');
    tmp.SQL.Add('	declare @date_prior datetime ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	set @evb3_prior = 0; ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add('	declare cr cursor for ');
    tmp.SQL.Add('	select t1.evb3, t1.date from device_data t1 ');
    tmp.SQL.Add('	where t1.evb2 = @id_car and t1.date >= @start2 and t1.date <= @stop2 ');
    tmp.SQL.Add('		and (evb3 = 10 or evb3 = 49 or evb3 = 15) ');
    tmp.SQL.Add('	order by t1.id_device_data ');
    tmp.SQL.Add('	open cr; ');
    tmp.SQL.Add('	fetch cr into @evb3, @date ');
    tmp.SQL.Add('  while (@@fetch_status <> -1) ');
    tmp.SQL.Add('  begin ');
    tmp.SQL.Add('		if @evb3_prior <> 0 ');
    tmp.SQL.Add('		begin ');
    tmp.SQL.Add('			if (@evb3_prior = 10) and ((@evb3 = 49) or (@evb3 = 15)) ');
    tmp.SQL.Add('			begin ');
    tmp.SQL.Add('				insert into #stan_pojazdu (from_, to_, zalaczony_silnik) ');
    tmp.SQL.Add('					values(@date_prior, @date, 1); ');
    tmp.SQL.Add('			end ');
    tmp.SQL.Add('		end; ');
    tmp.SQL.Add('		set @evb3_prior = @evb3; ');
    tmp.SQL.Add('		set @date_prior = @date; ');
    tmp.SQL.Add('		fetch cr into @evb3, @date ');
    tmp.SQL.Add('  end ');
    tmp.SQL.Add('  close cr ');
    tmp.SQL.Add('  deallocate cr ');
    tmp.SQL.Add('  if @evb3 = 10 ');
    tmp.SQL.Add('  begin ');
    tmp.SQL.Add('	 insert into #stan_pojazdu (from_, to_, zalaczony_silnik) ');
    tmp.SQL.Add('	    values(@date, GETDATE(), 1); ');
    tmp.SQL.Add('  end ');
    tmp.SQL.Add(' ');
    tmp.SQL.Add(' if @kod_zdarzenia <> 38 ');
    tmp.SQL.Add(' begin ');
    tmp.SQL.Add('	select t1.*, isnull(t2.zalaczony_silnik, 0) zalaczony_silnik from device_data t1 ');
    tmp.SQL.Add('		left join #stan_pojazdu t2 on (t2.from_ <= t1.date and t2.to_ >= t1.date) ');
    tmp.SQL.Add('	where t1.evb2 = @id_car and t1.date >= @start and t1.date <= @stop and evb3 = @kod_zdarzenia ');
    tmp.SQL.Add('	order by t1.id_device_data ');
    tmp.SQL.Add(' end ');
    tmp.SQL.Add(' else ');
    tmp.SQL.Add(' begin ');
    tmp.SQL.Add('	select t1.evb3, t1.evb1, t1.evb4, t1.evb5, t1.evb6, t1.evb7, t1.evb8, t1.evb9, t1.evb10, isnull(t2.zalaczony_silnik, 0) zalaczony_silnik, count(*) ile_razy, min(date) date from device_data t1 ');
    tmp.SQL.Add('		left join #stan_pojazdu t2 on (t2.from_ <= t1.date and t2.to_ >= t1.date) ');
    tmp.SQL.Add('	where t1.evb2 = @id_car and t1.date >= @start and t1.date <= @stop and evb3 = @kod_zdarzenia and evb1 = 65 and t2.zalaczony_silnik = 1 ');
    tmp.SQL.Add('	group by t1.evb3, t1.evb1, t1.evb4, t1.evb5, t1.evb6, t1.evb7, t1.evb8, t1.evb9, t1.evb10, isnull(t2.zalaczony_silnik, 0) ');
    tmp.SQL.Add('	having count(*) > 1 ');
    tmp.SQL.Add('	order by min(date) ');
    tmp.SQL.Add(' end ');
    tmp.ExecSQL();
end;

function GetEmailDate(msg2: TIdMessage): TDateTime;
var Year, Month, Day: Word;
    Year2, Month2, Day2: Word;
    Hour, Min, Sec, MSec: Word;
begin
    result := msg2.Date;
    DecodeDate(Now(), Year, Month, Day);
    DecodeDate(msg2.Date, Year2, Month2, Day2);
    DecodeTime(msg2.Date, Hour, Min, Sec, MSec);
    if(Month = 1) and (Month2 = 1) and (Year = (Year2 + 1)) then
        result := EncodeDate(Year, Month2, Day2) + EncodeTime(Hour, Min, Sec, MSec);
        // dodaje 1 do roku w styczniu, gdy urzadzenie ze przestawi³o jeszcze roku
end;

end.

