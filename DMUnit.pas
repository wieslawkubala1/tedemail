unit DMUnit;

interface

uses classes;

type
DM = class
public
    class function   bulk_path: string;
end;

function ReadIniValue(name: String): Variant;
procedure WriteIniValue(name: String; value: Variant);
function StriptsPath() : String;
procedure UpdateVersion(var version: Integer);


implementation

uses SysUtils, TEDEmailUnit, Variants;

class function  DM.bulk_path: string;
var tmp2: String;
begin
   tmp2 := DateTimeToStr(Now());
   tmp2 := StringReplace(tmp2, '-', '', [rfReplaceAll, rfIgnoreCase]);
   tmp2 := StringReplace(tmp2, ':', '', [rfReplaceAll, rfIgnoreCase]);
   tmp2 := StringReplace(tmp2, ' ', '', [rfReplaceAll, rfIgnoreCase]);

    result := ExtractFilePath(ParamStr(0)) + 'bulk_' + TEDEmailSrv.ADOConnection.DefaultDatabase + ' ' + tmp2 + '.txt';

end;

function ReadIniValue(name: String): Variant;
var lista: TStrings;
begin
    if not FileExists(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini') then
        raise Exception.Create('Nie znaleziono pliku ustawieñ');
    lista := TStringList.Create();
    while True do
    begin
        try
            lista.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini');
            break;
        except

        end;
    end;
    result := lista.Values[name];
    lista.Free();
end;


procedure WriteIniValue(name: String; value: Variant);
var lista: TStrings;
begin
    if not FileExists(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini') then
        raise Exception.Create('Nie znaleziono pliku ustawieñ');
    lista := TStringList.Create();
    while True do
    begin
        try
            lista.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini');
            break;
        except

        end;
    end;
    if lista.IndexOfName(name) <> -1 then
        lista.Values[name] := value
    else
        lista.add(name + '=' + VarToStr(value));
    while True do
    begin
        try
            lista.SaveToFile(ExtractFilePath(ParamStr(0)) + 'ustawienia.ini');
            break;
        except

        end;
    end;
    lista.Free();
end;

function StriptsPath() : String;
begin
    result := ExtractFilePath(ParamStr(0)) + 'update_scripts\';
end;

procedure UpdateVersion(var version: Integer);
begin
    Inc(version);
    TEDEmailSrv.tmp.SQL.Clear();
    TEDEmailSrv.tmp.SQL.Add('update versions set version = ' + IntToStr(version));
    TEDEmailSrv.tmp.ExecSQL();
end;


end.
