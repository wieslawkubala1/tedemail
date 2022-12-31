object TEDEmailSrv: TTEDEmailSrv
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  AllowPause = False
  DisplayName = 'TEDEmail'
  Interactive = True
  OnExecute = ServiceExecute
  OnShutdown = ServiceShutdown
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 471
  Width = 596
  object ADOConnection: TADOConnection
    CommandTimeout = 86400
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=gfdjhdt6436%3SDF;Persist Security I' +
      'nfo=True;User ID=sa;Initial Catalog=carnet_pompy_ciepla;Data Sou' +
      'rce=SERWER4\MSSQL2005_CARNET;Use Procedure for Prepare=1;Auto Tr' +
      'anslate=True;Packet Size=4096;Workstation ID=WIESIEK3;Use Encryp' +
      'tion for Data=False;Tag with column collation when possible=Fals' +
      'e'
    ConnectionTimeout = 5
    CursorLocation = clUseServer
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 48
    Top = 24
  end
  object msg: TIdMessage
    AttachmentEncoding = 'UUE'
    BccList = <>
    CCList = <>
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 178
    Top = 99
  end
  object IdDecoderUUE1: TIdDecoderUUE
    FillChar = '~'
    Left = 242
    Top = 67
  end
  object qMailSettings: TADOTable
    Connection = ADOConnection
    CursorLocation = clUseServer
    CommandTimeout = 86400
    TableName = 'mail_settings'
    Left = 80
    Top = 168
  end
  object tmp2: TADOQuery
    Connection = ADOConnection
    CommandTimeout = 86400
    Parameters = <>
    Left = 232
    Top = 8
  end
  object qInsertEvent: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'insertevent;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@evb1'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@evb2'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@evb3'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@evb4'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@evb5'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@evb6'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@evb7'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@evb8'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@evb9'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@evb10'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@evdata'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@pal1'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@pal2'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@timezonebias'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 184
    Top = 296
  end
  object qCzyBylEmailCzytany2: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'czybylemailczytany2;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@adres'
        Attributes = [paNullable]
        DataType = ftString
        Size = 150
        Value = Null
      end
      item
        Name = '@dataczas'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@dataczas2'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@dataczas3'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@tytul'
        Attributes = [paNullable]
        DataType = ftString
        Size = 200
        Value = Null
      end
      item
        Name = '@rozmiar'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@mail_id'
        Attributes = [paNullable]
        DataType = ftString
        Size = 500
        Value = Null
      end>
    Left = 136
    Top = 296
  end
  object qPojazdy2: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select * from view_cars_with_current_drivers order by name, rej_' +
        'numb'
      '')
    Left = 9
    Top = 168
  end
  object qPojazdyZKierowcami: TADOTable
    Connection = ADOConnection
    CursorType = ctStatic
    TableName = 'view_cars_with_current_drivers'
    Left = 168
    Top = 208
  end
  object MegaRam: TRxMemoryData
    FieldDefs = <>
    Left = 56
    Top = 232
    object MegaRamevb1: TIntegerField
      FieldName = 'evb1'
    end
    object MegaRamevb2: TIntegerField
      FieldName = 'evb2'
    end
    object MegaRamevb3: TIntegerField
      FieldName = 'evb3'
    end
    object MegaRamevb4: TIntegerField
      FieldName = 'evb4'
    end
    object MegaRamevb5: TIntegerField
      FieldName = 'evb5'
    end
    object MegaRamevb6: TIntegerField
      FieldName = 'evb6'
    end
    object MegaRamevb7: TIntegerField
      FieldName = 'evb7'
    end
    object MegaRamevb8: TIntegerField
      FieldName = 'evb8'
    end
    object MegaRamevb9: TIntegerField
      FieldName = 'evb9'
    end
    object MegaRamevb10: TIntegerField
      FieldName = 'evb10'
    end
  end
  object tmp: TADOQuery
    Connection = ADOConnection
    CommandTimeout = 86400
    Parameters = <>
    Left = 128
    Top = 8
  end
  object tmp5: TADOQuery
    Connection = ADOConnection
    CommandTimeout = 86400
    Parameters = <>
    Left = 181
    Top = 8
  end
  object IdHTTP1: TIdHTTP
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 56
    Top = 280
  end
  object qXML: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    Left = 16
    Top = 328
  end
  object RequestFromOnlineTrackingWWWService: TIdTCPServer
    Bindings = <>
    DefaultPort = 8086
    OnExecute = RequestFromOnlineTrackingWWWServiceExecute
    Left = 288
    Top = 168
  end
  object RequestFromButtonImmediately: TIdTCPServer
    Bindings = <>
    DefaultPort = 8087
    OnExecute = RequestFromButtonImmediatelyExecute
    Left = 312
    Top = 224
  end
  object qCompanies: TADOQuery
    Connection = ADOConnectionPanel
    CommandTimeout = 86400
    Parameters = <>
    SQL.Strings = (
      'select * from company'
      'where has_www_account = 1')
    Left = 469
    Top = 64
  end
  object ADOConnectionPanel: TADOConnection
    CommandTimeout = 86400
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=sasa123;Persist Security Info=True;' +
      'User ID=sa;Initial Catalog=carnet_scr;Data Source=SERWER4\MSSQL2' +
      '005_CARNET;Use Procedure for Prepare=1;Auto Translate=True;Packe' +
      't Size=4096;Workstation ID=WIESIEK3;Use Encryption for Data=Fals' +
      'e;Tag with column collation when possible=False'
    ConnectionTimeout = 5
    CursorLocation = clUseServer
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 448
    Top = 132
  end
  object qPanelQuery: TADOQuery
    Connection = ADOConnectionPanel
    Parameters = <>
    Left = 440
    Top = 188
  end
  object qStreet: TADOQuery
    Connection = ADOConnection
    CommandTimeout = 86400
    Parameters = <>
    Left = 293
    Top = 8
  end
  object spDayWork: TADOStoredProc
    Connection = ADOConnection
    CursorType = ctStatic
    CommandTimeout = 90
    ProcedureName = 'sp_day_work;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@isInCarMode'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@car_or_driver_no'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@start'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@stop'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@id_progress'
        Attributes = [paNullable]
        DataType = ftLargeint
        Precision = 19
        Value = Null
      end
      item
        Name = '@calculate_fuel'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@show_only_last_day_route'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@DoNotShowEmptyTracks'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@with_gps'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@kosztPaliwa'
        Attributes = [paNullable]
        DataType = ftBCD
        NumericScale = 3
        Precision = 10
        Value = Null
      end
      item
        Name = '@no_cache'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 448
    Top = 256
    object spDayWorkid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object spDayWorkdzien: TStringField
      FieldName = 'dzien'
      Size = 5
    end
    object spDayWorkdata: TDateTimeField
      FieldName = 'data'
    end
    object spDayWorkweek: TIntegerField
      FieldName = 'week'
    end
    object spDayWorkmonth: TIntegerField
      FieldName = 'month'
    end
    object spDayWorkprzebieg: TBCDField
      FieldName = 'przebieg'
      DisplayFormat = '0.0'
      Precision = 12
      Size = 6
    end
    object spDayWorkopis: TStringField
      FieldName = 'opis'
      Size = 30
    end
    object spDayWorkile_praca: TStringField
      FieldName = 'ile_praca'
    end
    object spDayWorkile_praca_sek: TIntegerField
      FieldName = 'ile_praca_sek'
    end
    object spDayWorkile_postoj: TStringField
      FieldName = 'ile_postoj'
    end
    object spDayWorkile_postoj_sek: TIntegerField
      FieldName = 'ile_postoj_sek'
    end
    object spDayWorkile_jalowy: TStringField
      FieldName = 'ile_jalowy'
    end
    object spDayWorkile_jalowy_sek: TIntegerField
      FieldName = 'ile_jalowy_sek'
    end
    object spDayWorkstart_praca: TDateTimeField
      FieldName = 'start_praca'
    end
    object spDayWorkstop_praca: TDateTimeField
      FieldName = 'stop_praca'
    end
    object spDayWorkstart_postoj: TDateTimeField
      FieldName = 'start_postoj'
    end
    object spDayWorkstop_postoj: TDateTimeField
      FieldName = 'stop_postoj'
    end
    object spDayWorkgroup_id: TIntegerField
      FieldName = 'group_id'
    end
    object spDayWorksummary_przebieg_day: TBCDField
      FieldName = 'summary_przebieg_day'
      DisplayFormat = '0.0'
      Precision = 10
      Size = 3
    end
    object spDayWorksummary_przebieg_week: TBCDField
      FieldName = 'summary_przebieg_week'
      Precision = 10
      Size = 3
    end
    object spDayWorksummary_przebieg_month: TBCDField
      FieldName = 'summary_przebieg_month'
      Precision = 10
      Size = 3
    end
    object spDayWorksummary_praca_day: TStringField
      FieldName = 'summary_praca_day'
    end
    object spDayWorksummary_praca_week: TStringField
      FieldName = 'summary_praca_week'
    end
    object spDayWorksummary_praca_month: TStringField
      FieldName = 'summary_praca_month'
    end
    object spDayWorksummary_postoj_day: TStringField
      FieldName = 'summary_postoj_day'
    end
    object spDayWorksummary_postoj_week: TStringField
      FieldName = 'summary_postoj_week'
    end
    object spDayWorksummary_postoj_month: TStringField
      FieldName = 'summary_postoj_month'
    end
    object spDayWorksummary_jalowy_day: TStringField
      FieldName = 'summary_jalowy_day'
    end
    object spDayWorksummary_jalowy_week: TStringField
      FieldName = 'summary_jalowy_week'
    end
    object spDayWorksummary_jalowy_month: TStringField
      FieldName = 'summary_jalowy_month'
    end
    object spDayWorksummary_przebieg_all: TBCDField
      FieldName = 'summary_przebieg_all'
      Precision = 10
      Size = 3
    end
    object spDayWorksummary_praca_all: TStringField
      FieldName = 'summary_praca_all'
    end
    object spDayWorksummary_postoj_all: TStringField
      FieldName = 'summary_postoj_all'
    end
    object spDayWorksummary_jalowy_all: TStringField
      FieldName = 'summary_jalowy_all'
    end
    object spDayWorksummary_paliwo_sum: TBCDField
      FieldName = 'summary_paliwo_sum'
      Precision = 10
      Size = 3
    end
    object spDayWorksummary_paliwo_srednio: TBCDField
      FieldName = 'summary_paliwo_srednio'
      Precision = 10
      Size = 3
    end
    object spDayWorkulica_start: TStringField
      FieldName = 'ulica_start'
      Size = 50
    end
    object spDayWorkulica_stop: TStringField
      FieldName = 'ulica_stop'
      Size = 50
    end
    object spDayWorkszerokosc0: TStringField
      FieldName = 'szerokosc0'
      Size = 30
    end
    object spDayWorkdlugosc0: TStringField
      FieldName = 'dlugosc0'
      Size = 30
    end
    object spDayWorkszerokosc: TStringField
      FieldName = 'szerokosc'
      Size = 30
    end
    object spDayWorkdlugosc: TStringField
      FieldName = 'dlugosc'
      Size = 30
    end
    object spDayWorksrednio: TBCDField
      FieldName = 'srednio'
      DisplayFormat = '0.0'
      Precision = 10
      Size = 1
    end
    object spDayWorksummary_paliwo_koszt: TBCDField
      FieldName = 'summary_paliwo_koszt'
      Precision = 10
      Size = 3
    end
    object spDayWorkevb2: TIntegerField
      FieldName = 'evb2'
    end
    object spDayWorkmarka_pojazdu: TStringField
      FieldName = 'marka_pojazdu'
      Size = 250
    end
    object spDayWorknr_rej_pojazdu: TStringField
      FieldName = 'nr_rej_pojazdu'
      Size = 200
    end
    object spDayWorkkierowca: TStringField
      FieldName = 'kierowca'
      Size = 100
    end
  end
  object XML: TXMLDocument
    Options = [doNodeAutoCreate, doNodeAutoIndent, doAttrNull, doAutoPrefix, doNamespaceDecl]
    Left = 520
    Top = 304
    DOMVendorDesc = 'MSXML'
  end
  object IdDecoderMIME: TIdDecoderMIME
    FillChar = '='
    Left = 440
    Top = 320
  end
  object sp_spaceused: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'sp_spaceused;1'
    Parameters = <>
    Left = 328
    Top = 108
  end
  object qHistorySettings: TADOQuery
    Connection = ADOConnection
    CommandTimeout = 86400
    Parameters = <>
    Left = 120
    Top = 343
  end
  object qHistorySettings2: TADOQuery
    Connection = ADOConnection
    CommandTimeout = 86400
    Parameters = <>
    Left = 216
    Top = 343
  end
  object smtp: TIdSMTP
    SASLMechanisms = <>
    Left = 336
    Top = 296
  end
  object tmp3: TADOQuery
    Connection = ADOConnection
    CommandTimeout = 86400
    Parameters = <>
    Left = 352
    Top = 8
  end
  object qPaliwo: TADOQuery
    Connection = ADOConnection
    Parameters = <
      item
        Name = 'car_no'
        DataType = ftWord
        Precision = 3
        Size = 1
        Value = Null
      end
      item
        Name = 'nr_zb'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'select t1.* from view_probe_liters_fuel_tank t1'
      'inner join fuel_tank t2 on (t1.id_fuel_tank = t2.id_fuel_tank)'
      'where t2.id_car = :car_no and t2.tank_nr = :nr_zb'
      'order by t1.id_probe')
    Left = 256
    Top = 384
  end
  object qSaveSelect: TADOQuery
    Connection = ADOConnection
    CursorLocation = clUseServer
    CommandTimeout = 86400
    Parameters = <>
    Left = 320
    Top = 384
  end
  object tmp4: TADOQuery
    Connection = ADOConnection
    CursorLocation = clUseServer
    CommandTimeout = 86400
    Parameters = <>
    Left = 352
    Top = 72
  end
  object qspCurrentEvents: TADOStoredProc
    Connection = ADOConnection
    CursorType = ctStatic
    CommandTimeout = 1000000
    ProcedureName = 'spCurrentEvents;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@carno'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end
      item
        Name = '@start'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@stop'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@max_event_count'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 40
    Top = 72
    object AutoIncField1: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object StringField1: TStringField
      FieldName = 'dzien'
      Size = 5
    end
    object DateTimeField1: TDateTimeField
      FieldName = 'data'
    end
    object IntegerField1: TIntegerField
      FieldName = 'week'
    end
    object IntegerField2: TIntegerField
      FieldName = 'month'
    end
    object BCDField1: TBCDField
      FieldName = 'przebieg'
      DisplayFormat = '0.0'
      Precision = 12
      Size = 6
    end
    object StringField2: TStringField
      FieldName = 'opis'
      Size = 30
    end
    object StringField3: TStringField
      FieldName = 'ile_praca'
    end
    object IntegerField3: TIntegerField
      FieldName = 'ile_praca_sek'
    end
    object StringField4: TStringField
      FieldName = 'ile_postoj'
    end
    object IntegerField4: TIntegerField
      FieldName = 'ile_postoj_sek'
    end
    object StringField5: TStringField
      FieldName = 'ile_jalowy'
    end
    object IntegerField5: TIntegerField
      FieldName = 'ile_jalowy_sek'
    end
    object DateTimeField2: TDateTimeField
      FieldName = 'start_praca'
    end
    object DateTimeField3: TDateTimeField
      FieldName = 'stop_praca'
    end
    object DateTimeField4: TDateTimeField
      FieldName = 'start_postoj'
    end
    object DateTimeField5: TDateTimeField
      FieldName = 'stop_postoj'
    end
    object IntegerField6: TIntegerField
      FieldName = 'group_id'
    end
    object BCDField2: TBCDField
      FieldName = 'summary_przebieg_day'
      DisplayFormat = '0.0'
      Precision = 10
      Size = 3
    end
    object BCDField3: TBCDField
      FieldName = 'summary_przebieg_week'
      Precision = 10
      Size = 3
    end
    object BCDField4: TBCDField
      FieldName = 'summary_przebieg_month'
      Precision = 10
      Size = 3
    end
    object StringField6: TStringField
      FieldName = 'summary_praca_day'
    end
    object StringField7: TStringField
      FieldName = 'summary_praca_week'
    end
    object StringField8: TStringField
      FieldName = 'summary_praca_month'
    end
    object StringField9: TStringField
      FieldName = 'summary_postoj_day'
    end
    object StringField10: TStringField
      FieldName = 'summary_postoj_week'
    end
    object StringField11: TStringField
      FieldName = 'summary_postoj_month'
    end
    object StringField12: TStringField
      FieldName = 'summary_jalowy_day'
    end
    object StringField13: TStringField
      FieldName = 'summary_jalowy_week'
    end
    object StringField14: TStringField
      FieldName = 'summary_jalowy_month'
    end
    object BCDField5: TBCDField
      FieldName = 'summary_przebieg_all'
      Precision = 10
      Size = 3
    end
    object StringField15: TStringField
      FieldName = 'summary_praca_all'
    end
    object StringField16: TStringField
      FieldName = 'summary_postoj_all'
    end
    object StringField17: TStringField
      FieldName = 'summary_jalowy_all'
    end
    object BCDField6: TBCDField
      FieldName = 'summary_paliwo_sum'
      Precision = 10
      Size = 3
    end
    object BCDField7: TBCDField
      FieldName = 'summary_paliwo_srednio'
      Precision = 10
      Size = 3
    end
    object StringField18: TStringField
      FieldName = 'ulica_start'
      Size = 50
    end
    object StringField19: TStringField
      FieldName = 'ulica_stop'
      Size = 50
    end
    object StringField20: TStringField
      FieldName = 'szerokosc0'
      Size = 30
    end
    object StringField21: TStringField
      FieldName = 'dlugosc0'
      Size = 30
    end
    object StringField22: TStringField
      FieldName = 'szerokosc'
      Size = 30
    end
    object StringField23: TStringField
      FieldName = 'dlugosc'
      Size = 30
    end
    object BCDField8: TBCDField
      FieldName = 'srednio'
      DisplayFormat = '0.0'
      Precision = 10
      Size = 1
    end
    object BCDField9: TBCDField
      FieldName = 'summary_paliwo_koszt'
      Precision = 10
      Size = 3
    end
    object IntegerField7: TIntegerField
      FieldName = 'evb2'
    end
    object StringField24: TStringField
      FieldName = 'marka_pojazdu'
      Size = 250
    end
    object StringField25: TStringField
      FieldName = 'nr_rej_pojazdu'
      Size = 200
    end
    object StringField26: TStringField
      FieldName = 'kierowca'
      Size = 100
    end
  end
  object qPanelQuery2: TADOQuery
    Connection = ADOConnectionPanel
    Parameters = <>
    Left = 512
    Top = 188
  end
  object qPanelQuery3: TADOQuery
    Connection = ADOConnectionPanel
    Parameters = <>
    Left = 520
    Top = 236
  end
  object POP: TIdPOP3
    Intercept = IdLogEvent1
    SASLMechanisms = <>
    Left = 144
    Top = 152
  end
  object IdLogEvent1: TIdLogEvent
    OnStatus = IdLogEvent1Status
    Left = 232
    Top = 128
  end
end
