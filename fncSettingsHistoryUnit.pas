unit fncSettingsHistoryUnit;

interface

uses Classes, CompressBLT;

function MakeCurrentSettingsToBin(): TBLTArchive;
function MakeCurrentSettingsToXMLMD5(): AnsiString;
procedure LoadBin(archive: TBLTArchive);

function MakeNewSettingsHistoryItem(del_car_id: Integer = 0; del_car_name: String = ''; del_car_rej_numb: String = ''): Integer;
function WhichSettingsHistoryItemIsDefault(): Integer;
function IsSettingsHistoryChanged(): Boolean;
procedure SetSettingsHistoryItemDefaultFlag(id_settings_history: integer; default_: boolean);
function LoadSettingsHistoryItem(id_settings_history: integer): Boolean;

function SettingsHistoryItemToXML(id_settings_history: integer): AnsiString;

function XMLToSettingsHistoryBinAndXmlMd5(xml: AnsiString;
  var change_date: TDateTime;
  var xml_md5: AnsiString;
  var car_count: Integer;
  var send_date: TDateTime;
  var del_car_id: Integer;
  var del_car_name: String;
  var del_car_rej_numb: String;
  var default_: Integer
  ): TBLTArchive;


implementation

uses fncExportUnit, TEDEmailUnit, ADODB, DB, SysUtils, md5, msxml,
  controls, ComObj, rxStrUtils;

function MakeCurrentSettingsToBin(): TBLTArchive;
var archiwum: TBLTArchive;
begin
    archiwum := TBLTArchive.Create();
    CreateExportArchive(archiwum);
    archiwum.stream.Position := 0;
    result := archiwum;
end;

function MakeCurrentSettingsToXMLMD5(): AnsiString;
begin
    result := MD5DigestToStr(MD5String(TEDEmailSrv.bXmlToWWWClick2()));
end;

procedure LoadBin(archive: TBLTArchive);
begin
    TEDEmailSrv.ADOConnection.BeginTrans();
    try
        LoadExportArchive(archive);
    except
        TEDEmailSrv.ADOConnection.RollbackTrans();
        raise;
    end;
end;

function WhichSettingsHistoryItemIsDefault(): Integer;
var id_settings_history: Integer;
begin
    TEDEmailSrv.qHistorySettings.Close();
    TEDEmailSrv.qHistorySettings.SQL.Clear();
    TEDEmailSrv.qHistorySettings.SQL.Add('select id_settings_history from settings_history where default_ = 1');
    TEDEmailSrv.qHistorySettings.Open();
    id_settings_history := TEDEmailSrv.qHistorySettings.FieldByName('id_settings_history').AsInteger;
    TEDEmailSrv.qHistorySettings.Close();
    result := id_settings_history;
end;

function IsSettingsHistoryChanged(): Boolean;
//var id_settings_history: Integer;
//    xml: AnsiString;
//    stream: TStream;
//    stream2: TStringStream;
begin
    result := False;

    {

    id_settings_history := WhichSettingsHistoryItemIsDefault();
    if id_settings_history = 0 then
    begin
        TEDEmailSrv.qHistorySettings.Close();
        TEDEmailSrv.qHistorySettings.SQL.Clear();
        TEDEmailSrv.qHistorySettings.SQL.Add('select max(id_settings_history) id_settings_history from settings_history');
        TEDEmailSrv.qHistorySettings.Open();
        id_settings_history := TEDEmailSrv.qHistorySettings.FieldByName('id_settings_history').AsInteger;
        TEDEmailSrv.qHistorySettings.Close();
    end;
    if id_settings_history <> 0 then
    begin
        TEDEmailSrv.qHistorySettings.Close();
        TEDEmailSrv.qHistorySettings.SQL.Clear();
        TEDEmailSrv.qHistorySettings.SQL.Add('select xml from settings_history where id_settings_history = :id_settings_history');
        TEDEmailSrv.qHistorySettings.Parameters.ParamByName('id_settings_history').Value := id_settings_history;
        TEDEmailSrv.qHistorySettings.Open();
        stream := TEDEmailSrv.qHistorySettings.CreateBlobStream(TEDEmailSrv.qHistorySettings.FieldByName('xml'), bmRead);
        stream.Position := 0;
        stream2 := TStringStream.Create('');
        stream2.CopyFrom(stream, 0);
        xml := stream2.DataString;
        stream2.Free();
        stream.Free();
        result := (xml <> MakeCurrentSettingsToXMLMD5());
    end
    else
        result := True; }
end;


function MakeNewSettingsHistoryItem(del_car_id: Integer = 0; del_car_name: String = ''; del_car_rej_numb: String = ''): Integer;
//var stream: TStream;
//    stream2: TStringStream;
//
//    stream3: TStream;
//    stream4: TBLTArchive;
//
//    car_count: Integer;
//    id_settings_history: Integer;
begin
    result := 0;

{
    TEDEmailSrv.qHistorySettings.Close();
    TEDEmailSrv.qHistorySettings.SQL.Clear();
    TEDEmailSrv.qHistorySettings.SQL.Add('select count(*) car_count from car');
    TEDEmailSrv.qHistorySettings.Open();
    car_count := TEDEmailSrv.qHistorySettings.FieldByName('car_count').AsInteger;
    TEDEmailSrv.qHistorySettings.Close();

    TEDEmailSrv.qHistorySettings.Close();
    TEDEmailSrv.qHistorySettings.SQL.Clear();
    TEDEmailSrv.qHistorySettings.SQL.Add('select * from settings_history');
    TEDEmailSrv.qHistorySettings.Open();

    TEDEmailSrv.qHistorySettings.Insert();

    stream := TEDEmailSrv.qHistorySettings.CreateBlobStream(TEDEmailSrv.qHistorySettings.FieldByName('xml'), bmWrite);
    stream2 := TStringStream.Create(MakeCurrentSettingsToXMLMD5());
    stream2.Position := 0;
    stream.Position := 0;
    stream.CopyFrom(stream2, 0);
    stream2.Free();

    stream3 := TEDEmailSrv.qHistorySettings.CreateBlobStream(TEDEmailSrv.qHistorySettings.FieldByName('bin'), bmWrite);
    stream4 := MakeCurrentSettingsToBin();
    stream4.stream.Position := 0;
    stream3.Position := 0;
    stream3.CopyFrom(stream4.stream, 0);
    stream4.Free();

    TEDEmailSrv.qHistorySettings.FieldByName('change_date').AsDateTime := Now();
    TEDEmailSrv.qHistorySettings.FieldByName('car_count').AsInteger := car_count;
    TEDEmailSrv.qHistorySettings.FieldByName('del_car_id').AsInteger := del_car_id;
    TEDEmailSrv.qHistorySettings.FieldByName('del_car_name').AsString := del_car_name;
    TEDEmailSrv.qHistorySettings.FieldByName('del_car_rej_numb').AsString := del_car_rej_numb;

    stream.Free();
    stream3.Free();
    TEDEmailSrv.qHistorySettings.Post();
    TEDEmailSrv.qHistorySettings.Close();

    TEDEmailSrv.qHistorySettings.Close();
    TEDEmailSrv.qHistorySettings.SQL.Clear();
    TEDEmailSrv.qHistorySettings.SQL.Add('select max(id_settings_history) id_settings_history from settings_history');
    TEDEmailSrv.qHistorySettings.Open();
    id_settings_history := TEDEmailSrv.qHistorySettings.FieldByName('id_settings_history').AsInteger;
    TEDEmailSrv.qHistorySettings.Close();

    result := id_settings_history; }
end;

procedure SetSettingsHistoryItemDefaultFlag(id_settings_history: integer; default_: boolean);
begin
    TEDEmailSrv.qHistorySettings.Close();
    TEDEmailSrv.qHistorySettings.SQL.Clear();
    TEDEmailSrv.qHistorySettings.SQL.Add('update settings_history set default_ = :default_ where id_settings_history = :id_settings_history');
    if default_ then
        TEDEmailSrv.qHistorySettings.Parameters.ParamByName('default_').Value := 1
    else
        TEDEmailSrv.qHistorySettings.Parameters.ParamByName('default_').Value := 0;
    TEDEmailSrv.qHistorySettings.Parameters.ParamByName('id_settings_history').Value := id_settings_history;
    TEDEmailSrv.qHistorySettings.ExecSQL();
end;

function LoadSettingsHistoryItem(id_settings_history: integer): Boolean;
var stream: TStream;
    stream2: TBLTArchive;
    defauilt_id: Integer;
begin
    defauilt_id := WhichSettingsHistoryItemIsDefault();
    if (defauilt_id <> id_settings_history) and (defauilt_id <> 0) then
    begin
        result := False;
        exit;
    end;

    TEDEmailSrv.qHistorySettings.SQL.Clear();
    TEDEmailSrv.qHistorySettings.SQL.Add('select bin from settings_history where id_settings_history = :id_settings_history');
    TEDEmailSrv.qHistorySettings.Parameters.ParamByName('id_settings_history').Value := id_settings_history;
    TEDEmailSrv.qHistorySettings.Open();
    stream := TEDEmailSrv.qHistorySettings.CreateBlobStream(TEDEmailSrv.qHistorySettings.FieldByName('bin'), bmRead);
    stream.Position := 0;
    stream2 := TBLTArchive.Create(stream);

    TEDEmailSrv.ADOConnection.BeginTrans();
    try
        LoadExportArchive(stream2);
    except
        TEDEmailSrv.ADOConnection.RollbackTrans();
        raise;
    end;
    stream2.Free();
    stream.Free();
    TEDEmailSrv.qHistorySettings.Close();
    result := True;
end;


function SettingsHistoryItemToXML(id_settings_history: integer): AnsiString;
begin
    TEDEmailSrv.qHistorySettings.SQL.Clear();
    TEDEmailSrv.qHistorySettings.SQL.Add('select * from settings_history where id_settings_history = :id_settings_history');
    TEDEmailSrv.qHistorySettings.Parameters.ParamByName('id_settings_history').Value := id_settings_history;
    TEDEmailSrv.qHistorySettings.Open();
    result := TEDEmailSrv.makeXml(TEDEmailSrv.qHistorySettings, 'settings_history');
    TEDEmailSrv.qHistorySettings.Close();
end;

function XMLToSettingsHistoryBinAndXmlMd5(xml: AnsiString;
  var change_date: TDateTime;
  var xml_md5: AnsiString;
  var car_count: Integer;
  var send_date: TDateTime;
  var del_car_id: Integer;
  var del_car_name: String;
  var del_car_rej_numb: String;
  var default_: Integer
  ): TBLTArchive;
var doc: IXMLDOMDocument;
    node: IXMLDOMNode;
    node2: IXMLDOMNode;
    tmp: AnsiString;
    tmp2: AnsiString;
    i: Integer;
    stream: TStream;
    archive: TBLTArchive;
    znak: Char;
    FormatSettings: TFormatSettings;
begin
    doc  := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;

    xml := ReplaceStr(xml, #10, '');
    xml := ReplaceStr(xml, #13, '');
    xml := ReplaceStr(xml, ' ', '');

    doc.loadXML(xml);
    node := doc.childNodes.item[0].firstChild;
    node2 := node.childNodes.item[0]; // id_settings_history
    node2 := node.childNodes.item[1]; // change_date

    FormatSettings.DateSeparator := '-';
    FormatSettings.TimeSeparator := ':';
    FormatSettings.ShortDateFormat := 'MM-DD-YYYY';
    FormatSettings.ShortTimeFormat := 'hh:nn:ss';

    change_date :=  StrToDateTime(node2.text, FormatSettings);
    node2 := node.childNodes.item[2]; // xml

    tmp := node2.text;
    tmp2 := '';
    i := 1;
    while i <= Length(tmp) do
    begin
        tmp2 := tmp2 + char(Hex2Dec(tmp[i] + tmp[i + 1]));
        i := i + 2;
    end;
    xml_md5 := tmp2;

    node2 := node.childNodes.item[3]; // car_count
    car_count := StrToIntDef(node2.text, 0);
    node2 := node.childNodes.item[4]; // bin

    tmp := node2.text;
    tmp2 := '';
    i := 1;
//    Clipboard.asText := tmp;

    stream := TMemoryStream.Create();

    while i <= Length(tmp) do
    begin
        znak := char(Hex2Dec(tmp[i] + tmp[i + 1]));
        stream.Write(znak, 1);
        i := i + 2;
    end;
    stream.Position := 0;
    archive := TBLTArchive.Create(stream);
    stream.Free();


    node2 := node.childNodes.item[5]; // send_date

    FormatSettings.DateSeparator := '/';
    FormatSettings.ShortDateFormat := 'MM/DD/YYYY';

    send_date := StrToDateTime(node2.text, FormatSettings);
    node2 := node.childNodes.item[6]; // del_car_id
    del_car_id := StrToIntDef(node2.text, 0);
    node2 := node.childNodes.item[7]; // del_car_name
    del_car_name := node2.text;
    node2 := node.childNodes.item[8]; // del_car_rej_numb
    del_car_rej_numb := node2.text;
    node2 := node.childNodes.item[9]; // default_
    default_ := StrToIntDef(node2.text, 0);

    if del_car_name = 'null' then
        del_car_name := '';
    if del_car_rej_numb = 'null' then
        del_car_rej_numb := '';

    result := archive;
end;

end.
