unit clEmapaTransportOrMapCenterUnit2; // or GoogleMaps

interface

uses ExtCtrls, Graphics, Controls, Classes, Types,
      SHDocVw, MSHTML;

const
mapcenter_error_message: String = 'Nieprawid³owy adres lub port serwera ' +
            'MapCenter lub nie masz po³¹czenia z Internetem. By zmieniæ ' +
            'ustawienia ³¹czenia siê z serwerem MapCenter, wybierz ' +
            'przycisk "Ustawienia..."';


type
    TOnRaportCreateProgress2 = procedure(position, max: Integer) of object;
    TOnRaportCreateFunction2 = procedure(onProgress: TOnRaportCreateProgress2) of object;


    ILocalizeEmapaCollection = class;
    IReportEmapaCollection = class;
    ILocalizeEmapaApp = class
    public // do not call directly
        host: String;
        port: Integer;
        login, pass: String;
        webBrowser: TWebBrowser;
        FIsBusy: Boolean;
        OldOnPaint: TNotifyEvent;
        OldOnMouseDown: TMouseEvent;
        OldOnMouseMove: TMouseMoveEvent;
        Image: TImage;
        PaintBox: TPaintBox;
    private
        FLocalizeCollection: ILocalizeEmapaCollection;
        Fzoom_level: Integer;
    public
        constructor CreateEmapaMapCenter(host: String; port: Integer;
                                                        login, pass: String);

        destructor Destroy(); override;

        function CreateLocalizeCollection(): ILocalizeEmapaCollection;

        procedure CleanLocalizeInfo();
        function RetrieveReport2(EntID: Integer;
                                Position: Integer;
                                onProgress: TOnRaportCreateProgress2;
                                GetStreetsFromEmapaTransport: Boolean = False):
                                    IReportEmapaCollection;

        property zoom_level: Integer read Fzoom_level;
        function IsBusy(): Boolean;
    end;

    ILocalizeEmapaObject = class;
    ILocalizeEmapaCollection = class
    public // do not call directly
//        lc: ILocalizeCollection;
        owner: ILocalizeEmapaApp;
        items: array of ILocalizeEmapaObject;
    public
        function Add(Before: OleVariant; After: OleVariant): ILocalizeEmapaObject;
        procedure Clear();
        constructor Create(owner: ILocalizeEmapaApp);
        destructor Destroy(); override;
    end;

    IEmapaPosition = class
    public // do not call directly
//        ip: IPosition;
        report_wag: Integer;
        x, y: Integer;
        pos: Integer;
    private
        FLongitude: Double;
        FLatitude: Double;
        FTime: TDateTime;
        FDescription: String;
        FShowDescription: Boolean;
        FShowName: Boolean;
        FIconIndex: Integer;
        FShowIcon: Boolean;
        FIconColor: Integer;
        zoom_this_position: Boolean;
        function GetLongitude(): Double;
        procedure SetLongitude(value: Double);
        function GetLatitude(): Double;
        procedure SetLatitude(value: Double);
        function GetTime(): TDateTime;
        procedure SetTime(value: TDateTime);
        function GetDescription(): String;
        procedure SetDescription(value: String);
        function GetShowDescription(): Boolean;
        procedure SetShowDescription(value: Boolean);
        function GetShowName(): Boolean;
        procedure SetShowName(value: Boolean);
        function GetIconIndex(): Integer;
        procedure SetIconIndex(value: Integer);
        function GetShowIcon(): Boolean;
        procedure SetShowIcon(value: Boolean);
        function GetIconColor(): Integer;
        procedure SetIconColor(value: Integer);
    public
        droga_dyn: double;
        property Longitude: Double read GetLongitude write SetLongitude;
        property Latitude: Double read GetLatitude write SetLatitude;
        property Time: TDateTime read GetTime write SetTime;
        property Description: String read GetDescription write SetDescription;
        property ShowDescription: Boolean read GetShowDescription write SetShowDescription;
        property ShowName: Boolean read GetShowName write SetShowName;
        property IconIndex: Integer read GetIconIndex write SetIconIndex;
        property ShowIcon: Boolean read GetShowIcon write SetShowIcon;
        property IconColor: Integer read GetIconColor write SetIconColor;
        constructor Create();
        destructor Destroy(); override;
        procedure ZoomTo();
    end;

    IEmapaPositions = class
    public // do not call directly
        owner: ILocalizeEmapaObject;
        positions: array of IEmapaPosition;
    public
        WasFit: Boolean;
        function Count(): Integer;
        procedure Remove(Index_: Integer);
        procedure Clear();
        function Add(Longitude: OleVariant; Latitude: OleVariant;
                Before: OleVariant; After: OleVariant): IEmapaPosition;
        constructor Create(owner: ILocalizeEmapaObject);
        destructor Destroy(); override;
    end;

    ILocalizeEmapaObject = class
    public // do not call directly
//        lo: ILocalizeObject;
        owner: ILocalizeEmapaCollection;
    private
        FEntID: Integer;
        FName: String;
        FShowName: Boolean;
        FIconIndex: Integer;
        FShowIcon: Boolean;
        FIconColor: Integer;
        FPathColor: Integer;
        FPathWidth: Integer;
        FSize: Integer;
        FRemovePrevious: Boolean;
        FPointsConnected: Boolean;
        FPositions: IEmapaPositions;

        function GetEntID: Integer;
        procedure SetEntID(value: Integer);
        function GetName: String;
        procedure SetName(value: String);
        function GetShowName: Boolean;
        procedure SetShowName(value: Boolean);
        function GetIconIndex: Integer;
        procedure SetIconIndex(value: Integer);
        function GetShowIcon: Boolean;
        procedure SetShowIcon(value: Boolean);
        function GetIconColor: Integer;
        procedure SetIconColor(value: Integer);
        function GetPathColor: Integer;
        procedure SetPathColor(value: Integer);
        function GetPathWidth: Integer;
        procedure SetPathWidth(value: Integer);
        function GetSize: Integer;
        procedure SetSize(value: Integer);
        function GetRemovePrevious: Boolean;
        procedure SetRemovePrevious(value: Boolean);
        function GetPointsConnected: Boolean;
        procedure SetPointsConnected(value: Boolean);
    public
        property EntID: Integer read GetEntID write SetEntID;
        property Name: String read GetName write SetName;
        property ShowName: Boolean read GetShowName write SetShowName;
        property IconIndex: Integer read GetIconIndex write SetIconIndex;
        property ShowIcon: Boolean read GetShowIcon write SetShowIcon;
        property IconColor: Integer read GetIconColor write SetIconColor;
        property PathColor: Integer read GetPathColor write SetPathColor;
        property PathWidth: Integer read GetPathWidth write SetPathWidth;
        property Size: Integer read GetSize write SetSize;
        property RemovePrevious: Boolean read GetRemovePrevious write SetRemovePrevious;
        property PointsConnected: Boolean read GetPointsConnected write SetPointsConnected;
        property Positions: IEmapaPositions read FPositions;

        constructor Create(owner: ILocalizeEmapaCollection);
        destructor Destroy(); override;
    end;

    IReportEmapaEntry = class
    public // do not call directly
//        re: IReportEntry;
        rec: IReportEmapaCollection;
    private
        FNeighbourhood: String;
        FCounty: String;
        FState: String;
        function GetNeighbourhood(): String;
        function GetCounty(): String;
        function GetState(): String;
    public
        property Neighbourhood: String read GetNeighbourhood;
        property County: String read GetCounty;
        property State: String read GetState;
        function PositionInCollection(): Integer;

        constructor Create(rec: IReportEmapaCollection);
        destructor Destroy(); override;
    end;

    IReportEmapaCollection = class
    public // do not call directly
//        rc: IReportCollection;
    private
        FItem: array of IReportEmapaEntry;
        function GetItem(Index_: Integer): IReportEmapaEntry;
    public
        property Item[Index_: Integer]: IReportEmapaEntry read GetItem;
        constructor Create();
        destructor Destroy(); override;
        function Count(): Integer;
    end;

implementation

uses SysUtils, variants, IdHttp, XMLDoc, XMLIntf, 
            Math, JPEG, forms, windows, SyncObjs,
            strUtils, Contnrs, TEDEmailUnit;

//var sekcja: TCriticalSection;

constructor ILocalizeEmapaApp.CreateEmapaMapCenter(
                    host: String; port: Integer; login, pass: String);
begin
    inherited Create();
    FIsBusy := False;
    FLocalizeCollection := nil;
    self.host := host;
    self.port := port;
    self.login := login;
    self.pass := pass;
    Image := nil;
    PaintBox := nil;
    OldOnPaint := nil;
    OldOnMouseDown := nil;
    OldOnMouseMove := nil;
    webBrowser := nil;
end;

function ILocalizeEmapaApp.IsBusy(): Boolean;
begin
    result := FIsBusy;
end;

destructor ILocalizeEmapaApp.Destroy();
begin
    if FLocalizeCollection <> nil then
        FLocalizeCollection.Free();
    if PaintBox <> nil then
    begin
        PaintBox.OnPaint := OldOnPaint;
        PaintBox.OnMouseDown := OldOnMouseDown;
        PaintBox.OnMouseMove := OldOnMouseMove;
    end;
    inherited Destroy();
end;

function ILocalizeEmapaApp.CreateLocalizeCollection():
            ILocalizeEmapaCollection;
begin
    if FLocalizeCollection = nil then
    begin
        FLocalizeCollection := ILocalizeEmapaCollection.Create(Self);
    end;
    result := FLocalizeCollection;
end;

procedure ILocalizeEmapaApp.CleanLocalizeInfo();
//var
//    window: IHTMLWindow2;
//    doc: IHTMLDocument2;
var i, j: Integer;
    LocalizeObject: ILocalizeEmapaObject;
begin
    if FLocalizeCollection <> nil then
    begin
        for i := 0 to Length(FLocalizeCollection.items) - 1 do
        begin
            LocalizeObject := FLocalizeCollection.items[i];
            for j := 0 to Length(LocalizeObject.Positions.positions) - 1 do
            begin
//                LocalizeObject.Positions.positions[j].ip := nil;
                LocalizeObject.Positions.positions[j].Free();
            end;
            SetLength(LocalizeObject.Positions.positions, 0);
        end;
    end;
end;



function IEmapaPositions.Add(Longitude: OleVariant; Latitude: OleVariant;
                Before: OleVariant; After: OleVariant): IEmapaPosition;
begin
//if not sekcja.TryEnter() then raise EAbort.Create('zakleszczenie');
//sekcja.Enter();
try
    SetLength(positions, Length(positions) + 1);
    positions[Length(positions) - 1] := IEmapaPosition.Create();
    result := positions[Length(positions) - 1];
    result.pos := Length(positions);
    try
        result.Longitude := Longitude;
    except
        result.Longitude := 0;
    end;
    try
        result.Latitude := Latitude;
    except
        result.Latitude := 0;
    end;
//    result.ip := nil;
//    if owner.lo <> nil then
//        result.ip := owner.lo.Positions.Add(Longitude, Latitude, Before, After);
finally
  //sekcja.Leave();
end;
end;

function IReportEmapaCollection.Count(): Integer;
begin
//sekcja.Enter();
try
    result := Length(FItem);
finally
  //sekcja.Leave();
end;
end;

function ILocalizeEmapaCollection.Add(Before: OleVariant;
        After: OleVariant): ILocalizeEmapaObject;
begin
//sekcja.Enter();
try
    SetLength(items, Length(items) + 1);
    items[Length(items) - 1] := ILocalizeEmapaObject.Create(Self);
    result := items[Length(items) - 1];
//    result.lo := nil;
//    if lc <> nil then
//        result.lo := lc.Add(Before, After);
finally
  //sekcja.Leave();
end;
end;

procedure IEmapaPositions.Clear();
var i: Integer;
begin
//sekcja.Enter();
try
//    if owner.lo <> nil then
//        owner.lo.Positions.Clear();
    for i := 0 to Length(positions) - 1 do
        positions[i].Free();
    SetLength(positions, 0);
finally
  //sekcja.Leave();
end;
end;

function IEmapaPositions.Count(): Integer;
begin
//sekcja.Enter();
try
    result := Length(positions);
finally
  //sekcja.Leave();
end;
end;

procedure IEmapaPositions.Remove(Index_: Integer);
var i: Integer;
//    longitude, latitude: double;
begin
//sekcja.Enter();
try
    if (Index_ < 1) or (Index_ > Length(positions)) then
        raise Exception.Create('Nieprawid³owy indeks');
    i := Index_ - 1;
//    if owner.lo <> nil then
//    begin
//        longitude := owner.lo.Positions.Item[Index_].Longitude;
//        latitude := owner.lo.Positions.Item[Index_].Latitude;
//        if ((abs(longitude - positions[i].Longitude) >= 0.000001) or
//                (abs(latitude - positions[i].Latitude) >= 0.000001)) then
//            raise Exception.Create('Nieprawid³a pozycja GPS');
//        if positions[i].IconIndex <> owner.lo.Positions.Item[Index_].IconIndex then
//            raise Exception.Create('Nieprawid³y IconIndex pozycji GPS');
//        positions[i].ip := nil;
//        owner.lo.Positions.Remove(Index_);
//    end;
    positions[i].Free();
    while i <= (Length(positions) - 2) do
    begin
        positions[i] := positions[i + 1];
        Inc(i);
    end;
    SetLength(positions, Length(positions) - 1);
finally
  //sekcja.Leave();
end;
end;

function IEmapaPosition.GetLongitude(): Double;
begin
//    if ip <> nil then
//        result := ip.Longitude
//    else
        result := FLongitude;
end;

procedure IEmapaPosition.SetLongitude(value: Double);
begin
//sekcja.Enter();
try
//    if ip <> nil then
//        ip.Longitude := value
//    else
        FLongitude := value;
finally
  //sekcja.Leave();
end;
end;

function IEmapaPosition.GetLatitude(): Double;
begin
//    if ip <> nil then
//        result := ip.Latitude
//    else
        result := FLatitude;
end;

procedure IEmapaPosition.SetLatitude(value: Double);
begin
//sekcja.Enter();
try
//    if ip <> nil then
//        ip.Latitude := value
//    else
        FLatitude := value;
finally
  //sekcja.Leave();
end;
end;

function IEmapaPosition.GetTime(): TDateTime;
begin
//    if ip <> nil then
//        result := ip.Time
//    else
        result := FTime;
end;

procedure IEmapaPosition.SetTime(value: TDateTime);
begin
//sekcja.Enter();
try
//    if ip <> nil then
//        ip.Time := value
//    else
        FTime := value;
finally
  //sekcja.Leave();
end;
end;

function IEmapaPosition.GetDescription(): String;
begin
//    if ip <> nil then
//        result := ip.Description
//    else
        result := FDescription;
end;

procedure IEmapaPosition.SetDescription(value: String);
begin
//sekcja.Enter();
try
//    if ip <> nil then
//        ip.Description := value
//    else
        FDescription := value;
finally
  //sekcja.Leave();
end;
end;

function IEmapaPosition.GetShowDescription(): Boolean;
begin
//    if ip <> nil then
//        result := ip.ShowDescription
//    else
        result := FShowDescription;
end;

procedure IEmapaPosition.SetShowDescription(value: Boolean);
begin
//sekcja.Enter();
try
//    if ip <> nil then
//        ip.ShowDescription := value
//    else
        FShowDescription := value;
finally
  //sekcja.Leave();
end;
end;

function IEmapaPosition.GetShowName(): Boolean;
begin
//    if ip <> nil then
//        result := ip.ShowName
//    else
        result := FShowName;
end;

procedure IEmapaPosition.SetShowName(value: Boolean);
begin
//sekcja.Enter();
try
//    if ip <> nil then
//        ip.ShowName := value
//    else
        FShowName := value;
finally
  //sekcja.Leave();
end;
end;

function IEmapaPosition.GetIconIndex(): Integer;
begin
//    if ip <> nil then
//        result := ip.IconIndex
//    else
        result := FIconIndex;
end;

procedure IEmapaPosition.SetIconIndex(value: Integer);
begin
//sekcja.Enter();
try
//    if ip <> nil then
//    begin
//        ip.IconIndex := value;
//    end
//    else
        FIconIndex := value;
finally
  //sekcja.Leave();
end;
end;

function IEmapaPosition.GetShowIcon(): Boolean;
begin
//    if ip <> nil then
//        result := ip.ShowIcon
//    else
        result := FShowIcon;
end;

procedure IEmapaPosition.SetShowIcon(value: Boolean);
begin
//sekcja.Enter();
try
//    if ip <> nil then
//        ip.ShowIcon := value
//    else
        FShowIcon := value;
finally
  //sekcja.Leave();
end;
end;

function IEmapaPosition.GetIconColor(): Integer;
begin
//    if ip <> nil then
//        result := ip.IconColor
//    else
        result := FIconColor;
end;

procedure IEmapaPosition.SetIconColor(value: Integer);
begin
//sekcja.Enter();
try
//    if ip <> nil then
//        ip.IconColor := value
//    else
        FIconColor := value;
finally
  //sekcja.Leave();
end;
end;

function ILocalizeEmapaObject.GetEntID: Integer;
begin
//    if lo <> nil then
//        result := lo.EntID
//    else
        result := FEntID;
end;

procedure ILocalizeEmapaObject.SetEntID(value: Integer);
begin
//    if lo <> nil then
//        lo.EntID := value
//    else
        FEntID := value;
end;

function ILocalizeEmapaObject.GetName: String;
begin
//    if lo <> nil then
//        result := lo.Name
//    else
        result := FName;
end;

procedure ILocalizeEmapaObject.SetName(value: String);
begin
//    if lo <> nil then
//        lo.Name := value
//    else
        FName := value;
end;

function ILocalizeEmapaObject.GetShowName: Boolean;
begin
//    if lo <> nil then
//        result := lo.ShowName
//    else
        result := FShowName;
end;

procedure ILocalizeEmapaObject.SetShowName(value: Boolean);
begin
//    if lo <> nil then
//        lo.ShowName := value
//    else
        FShowName := value;
end;

function ILocalizeEmapaObject.GetIconIndex: Integer;
begin
//    if lo <> nil then
//        result := lo.IconIndex
//    else
        result := FIconIndex;
end;

procedure ILocalizeEmapaObject.SetIconIndex(value: Integer);
begin
//    if lo <> nil then
//        lo.IconIndex := value
//    else
        FIconIndex := value;
end;

function ILocalizeEmapaObject.GetShowIcon: Boolean;
begin
//    if lo <> nil then
//        result := lo.ShowIcon
//    else
        result := FShowIcon;
end;

procedure ILocalizeEmapaObject.SetShowIcon(value: Boolean);
begin
//    if lo <> nil then
//        lo.ShowIcon := value
//    else
        FShowIcon := value;
end;

function ILocalizeEmapaObject.GetIconColor: Integer;
begin
//    if lo <> nil then
//        result := lo.IconColor
//    else
        result := FIconColor;
end;

procedure ILocalizeEmapaObject.SetIconColor(value: Integer);
begin
//    if lo <> nil then
//        lo.IconColor := value
//    else
        FIconColor := value;
end;

function ILocalizeEmapaObject.GetPathColor: Integer;
begin
//    if lo <> nil then
//        result := lo.PathColor
//    else
        result := FPathColor;
end;

procedure ILocalizeEmapaObject.SetPathColor(value: Integer);
begin
//    if lo <> nil then
//        lo.PathColor := value
//    else
        FPathColor := value;
end;

function ILocalizeEmapaObject.GetPathWidth: Integer;
begin
//    if lo <> nil then
//        result := lo.PathWidth
//    else
        result := FPathWidth;
end;

procedure ILocalizeEmapaObject.SetPathWidth(value: Integer);
begin
//    if lo <> nil then
//        lo.PathWidth := value
//    else
        FPathWidth := value;
end;

function ILocalizeEmapaObject.GetSize: Integer;
begin
//    if lo <> nil then
//        result := lo.Size
//    else
        result := FSize;
end;

procedure ILocalizeEmapaObject.SetSize(value: Integer);
begin
//    if lo <> nil then
//        lo.Size := value
//    else
        FSize := value;
end;

function ILocalizeEmapaObject.GetRemovePrevious: Boolean;
begin
//    if lo <> nil then
//        result := lo.RemovePrevious
//    else
        result := FRemovePrevious;
end;

procedure ILocalizeEmapaObject.SetRemovePrevious(value: Boolean);
begin
//    if lo <> nil then
//        lo.RemovePrevious := value
//    else
        FRemovePrevious := value;
end;

function ILocalizeEmapaObject.GetPointsConnected: Boolean;
begin
//    if lo <> nil then
//        result := lo.PointsConnected
//    else
        result := FPointsConnected;
end;

procedure ILocalizeEmapaObject.SetPointsConnected(value: Boolean);
begin
//    if lo <> nil then
//        lo.PointsConnected := value
//    else
        FPointsConnected := value;
end;


constructor IReportEmapaEntry.Create(rec: IReportEmapaCollection);
begin
    inherited Create();
//    re := nil;
    Self.rec := rec;
end;

destructor IReportEmapaEntry.Destroy();
begin
//    re := nil;
    inherited Destroy();
end;

function IReportEmapaEntry.GetNeighbourhood(): String;
begin
//    if re <> nil then
//        result := re.Neighbourhood
//    else
        result := FNeighbourhood;
end;

function IReportEmapaEntry.GetCounty(): String;
begin
//    if re <> nil then
//        result := re.County
//    else
        result := FCounty;
end;

function IReportEmapaEntry.GetState(): String;
begin
//    if re <> nil then
//        result := re.State
//    else
        result := FState;
end;

function IReportEmapaCollection.GetItem(Index_: Integer): IReportEmapaEntry;
begin
    if (Index_ < 1) or (Index_ > Length(FItem)) then
        raise Exception.Create('Nieprawid³owy indeks');
    result := FItem[Index_ - 1];
end;

constructor IReportEmapaCollection.Create();
begin
    inherited Create();
//    rc := nil;
    SetLength(FItem, 0);
end;

destructor IReportEmapaCollection.Destroy();
var i: Integer;
begin
//    rc := nil;
    for i := 0 to Length(FItem) - 1 do
        FItem[i].Free();
    SetLength(FItem, 0);
    inherited Destroy();
end;

constructor IEmapaPositions.Create(owner: ILocalizeEmapaObject);
begin
    inherited Create();
    Self.owner := owner;
    SetLength(positions, 0);
    WasFit := False;
end;

destructor IEmapaPositions.Destroy();
var i: Integer;
begin
    for i := 0 to Length(positions) - 1 do
        positions[i].Free();
    SetLength(positions, 0);
    inherited Destroy();
end;

constructor ILocalizeEmapaCollection.Create(owner: ILocalizeEmapaApp);
begin
    inherited Create();
    Self.owner := owner;
//    lc := nil;
    SetLength(items, 0);
end;

destructor ILocalizeEmapaCollection.Destroy();
begin
//    lc := nil;
    while Length(items) > 0 do
        items[0].Free();
    owner.FLocalizeCollection := nil;
    inherited Destroy();
end;

constructor IEmapaPosition.Create();
begin
    inherited Create();
//    ip := nil;
    x := -1;
    y := -1;
    zoom_this_position := False;
end;

destructor IEmapaPosition.Destroy();
begin
//    ip := nil;
    inherited Destroy();
end;

constructor ILocalizeEmapaObject.Create(owner: ILocalizeEmapaCollection);
begin
    inherited Create();
    self.owner := owner;
    FPositions := IEmapaPositions.Create(Self);
//    lo := nil;
end;

destructor ILocalizeEmapaObject.Destroy();
var i: Integer;
begin
//    lo := nil;
    i := 0;
    while i < Length(owner.items) do
    begin
        if owner.items[i] = Self then
            break;
        Inc(i);
    end;
    while i < (Length(owner.items) - 1) do
    begin
        owner.items[i] := owner.items[i + 1];
        Inc(i);
    end;
    SetLength(owner.items, Length(owner.items) - 1);
    FPositions.Free();
    inherited Destroy();
end;


{
function ILocalizeEmapaApp.RetrieveReport2(EntID: Integer;
                                          Position: Integer;
                                          onProgress: TOnRaportCreateProgress2;
                                          GetStreetsFromEmapaTransport: Boolean = False):
                                              IReportEmapaCollection;
var //rc: IReportCollection;
    i, j: Integer;
//    e: IReportEntry;
//    e2: IReportEmapaEntry;
    lo: ILocalizeEmapaObject;
    lp: IEmapaPosition;
    query: TStrings;
    http: TIdHttp;
    query2, wynik: String;
    strstream: TStringStream;
    node: IXMLNode;
    re: IReportEmapaEntry;
    zoom_level: Integer;
    gotowe: Boolean;
    adress_id: Integer;
    report_wag: Integer;
    dodano_chociaz_jeden: Boolean;
    odpowiedz_z_emapa_transport: Boolean;
//    lista: array [0..132, 3..14] of String;
begin
    begin
        result := IReportEmapaCollection.Create();
//        result.rc := nil;
        lp := nil;
        for i := 0 to Length(self.FLocalizeCollection.items) - 1 do
        begin
            lo := self.FLocalizeCollection.items[i];
            for j := 0 to lo.Positions.Count - 1 do
            begin
                lp := lo.Positions.positions[j];
                break;
            end;
        end;
        if lp <> nil then
        begin
            odpowiedz_z_emapa_transport := False;
            for zoom_level := 14 downto 3 do
//            for zoom_level := 14 downto 14 do
//            for zoom_level := 14 downto 8 do
            begin
                if @onProgress <> nil then
                    onProgress(14 - zoom_level, 14 - 3 + 1);

                query := TStringList.Create();
                query.Add('<QUERY TYPE="TextPointInfo" SESSION_ID="" ' +
                        'LON_LAT_TYPE="LL" ASCII_SEARCH="Yes">');
                gotowe := True;
                dodano_chociaz_jeden := False;
                for i := 0 to Length(self.FLocalizeCollection.items) - 1 do
                begin
                    lo := self.FLocalizeCollection.items[i];
                    for j := 0 to lo.Positions.Count - 1 do
                    begin
                        lp := lo.Positions.positions[j];

                        if zoom_level = 14 then
                            lp.report_wag := 0
                        else
                        if (lp.report_wag and Trunc(Power(2, 6 - 1))) <> 0 then
                            continue;
                        gotowe := False;

                        if not ((lp.FLongitude = 0.0) and (lp.FLatitude = 0.0)) then
                        begin
                            query.Add('<MAP_POINT ID="' + IntToStr(i * 100000 + j) + '">' +
                                '<LON>' + FloatToStr(lp.FLongitude) + '</LON>' +
                                '<LAT>' + FloatToStr(lp.FLatitude) + '</LAT>' +
                                '</MAP_POINT>');
                            dodano_chociaz_jeden := True;
                        end;
                    end;
                end;

                if gotowe or (not dodano_chociaz_jeden) then
                begin
                    query.Free();
                    break;
                end;

                query.Add('<MID_POINT>' +
                    '<LON>0</LON>' +
                    '<LAT>0</LAT>' +
                    '</MID_POINT>' +
                    '<ZOOM>' + IntToStr(zoom_level) + '</ZOOM>' +
                    '<WIDTH>640</WIDTH>' +
                    '<HEIGHT>480</HEIGHT>' +
                    '</QUERY>');

                http := TIdHttp.Create(nil);
//                http.MaxLineLength := 1048576;
//                http.RecvBufferSize := 1048576;
//                http.SendBufferSize := 1048576;
//                http.ProtocolVersion := pv1_1;
                http.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows 98)';
//                if DM.MapcenterServer <> '' then
//                begin
//                    http.Host := DM.MapcenterServer;
//                    http.Port := DM.MapcenterListeningPort;
//                end
//                else
//                begin
//                    http.Host := DM.MapcenterServerUlice;
//                    http.Port := DM.MapcenterListeningPortUlice;
//                end;
//////                login := DM.MapcenterServerUser;
//////                pass := DM.MapcenterServerPassword;

                //                http.Request.URL := host;
//                frmMain.bCrcCheckClick(nil);
                try
                    http.Request.BasicAuthentication := True;
                    http.Request.Username := login;
                    http.Request.Password := pass;
                    http.Host := host;
                    http.Port := port;
//                    http.Request.UserAgent := DM.CodeActiveCarCount();
//                    http.Request.CustomHeaders.Add('CarCount: ' +
//                        DM.CodeActiveCarCount());
                    http.Connect();
                except
                    http.Free();
                    query.Free();
                    raise Exception.Create(mapcenter_error_message);
                end;
                query2 := query.Text;
//                query2 := Clipboard.AsText;
//                Clipboard.AsText := query2;
                query2 := utf8encode(query2);
                strstream := TStringStream.Create(query2);
                try
                    wynik := http.Post(http.Host, strstream);
                    if Pos('Authentication failed', wynik) > 0 then
                        raise EIdHTTPProtocolException.Create('Authentication failed');
                except
                    on e: EIdHTTPProtocolException do
                    begin
//                        Clipboard.AsText := e.Message;
                        http.Free();
                        query.Free();
                        strstream.Free();
                        raise Exception.Create('Nieprawid³owy login lub has³o. ' +
                            'By zmieniæ ' +
                            'ustawienia ³¹czenia siê z serwerem MapCenter, wybierz ' +
                            'przycisk "Ustawienia..."');
                    end
                    else
                    begin
                        http.Free();
                        query.Free();
                        strstream.Free();
                        raise Exception.Create(mapcenter_error_message);
                    end;
                end;

                http.Free();
                query.Free();
                strstream.Free();

                if Pos('ERROR', wynik) = 1 then
                begin
                    if Pos('ERROR1', wynik) = 1 then
                    begin
                        wynik := Copy(wynik, Length('ERROR1') + 3, 10000);
                        if wynik = '' then
                            raise Exception.Create('Konto, na które siê logujesz zosta³o ' +
                                'zablokowane.')
                        else
                            raise Exception.Create(wynik);
                    end
                    else
                    if Pos('ERROR2', wynik) = 1 then
                    begin
                        wynik := Copy(wynik, Length('ERROR2') + 3, 10000);
                            raise Exception.Create(wynik);
                    end
                end;

//                Clipboard.AsText := wynik;

                TEDEmailSrv.XML.LoadFromXML(wynik);
                node := TEDEmailSrv.XML.DocumentElement.ChildNodes.Nodes[1].ChildNodes.Nodes[1];
                while node <> nil do
                begin
                    report_wag := 0;
                    if node.ChildNodes.Nodes['STREET'].Text <> '' then
                        report_wag := report_wag or Trunc(Power(2, 6 - 1));
                    if node.ChildNodes.Nodes['CITY'].Text <> '' then
                        report_wag := report_wag or Trunc(Power(2, 6 - 2));
                    if node.ChildNodes.Nodes['ROAD'].Text <> '' then
                        report_wag := report_wag or Trunc(Power(2, 6 - 3));
                    if node.ChildNodes.Nodes['NATURAL'].Text <> '' then
                        report_wag := report_wag or Trunc(Power(2, 6 - 4));
                    if node.ChildNodes.Nodes['COUNTY'].Text <> '' then
                        report_wag := report_wag or Trunc(Power(2, 6 - 5));
                    if node.ChildNodes.Nodes['DISTRICT'].Text <> '' then
                        report_wag := report_wag or Trunc(Power(2, 6 - 6));


                    adress_id := Integer(node.Attributes['ID']);

                    while not (adress_id < Length(result.FItem)) do
                    begin
                        SetLength(result.FItem, Length(result.FItem) + 1);
                        result.FItem[Length(result.FItem) - 1] :=
                                IReportEmapaEntry.Create(result);
                    end;
                    re := result.FItem[adress_id];
                    lp := nil;
                    for i := 0 to Length(self.FLocalizeCollection.items) - 1 do
                    begin
                        lo := self.FLocalizeCollection.items[i];
                        for j := 0 to lo.Positions.Count - 1 do
                        begin
                            lp := lo.Positions.positions[j];
                            if (i * 100000 + j) = adress_id then
                                break;
                        end;
                    end;
                    if lp.report_wag < report_wag then
                    begin
                        lp.report_wag := report_wag;
                        re.FState := node.ChildNodes.Nodes['DISTRICT'].Text;
                        re.FCounty := node.ChildNodes.Nodes['COUNTY'].Text;
                        re.FNeighbourhood := '';
                        if ((report_wag and Trunc(Power(2, 6 - 1))) <> 0) or
                               ((report_wag and Trunc(Power(2, 6 - 2))) <> 0) then
                            re.FNeighbourhood := re.FNeighbourhood + ' ' +
                                Trim(node.ChildNodes.Nodes['CITY'].Text + ' ' +
                                node.ChildNodes.Nodes['STREET'].Text)
                        else
                        begin
                            if ((report_wag and Trunc(Power(2, 6 - 4))) <> 0) then
                                re.FNeighbourhood := re.FNeighbourhood + ' ' +
                                    Trim(node.ChildNodes.Nodes['NATURAL'].Text);
                            if ((report_wag and Trunc(Power(2, 6 - 3))) <> 0) then
                                re.FNeighbourhood := re.FNeighbourhood + ' ' +
                                    Trim('Droga nr ' +
                                    node.ChildNodes.Nodes['ROAD'].Text);
                        end;
                        re.FNeighbourhood := Trim(re.FNeighbourhood);

                        if (Pos('(', re.FNeighbourhood) > 0) and
                           (Pos(')', re.FNeighbourhood) > 0) and
                           (StrToIntDef(Copy(re.FNeighbourhood,
                                 Pos('(', re.FNeighbourhood) + 1,
                                 Pos(')', re.FNeighbourhood) - 1), 0) <> 0)  then
                           odpowiedz_z_emapa_transport := True;
                    end;


                    node := node.NextSibling();
                end;
                if odpowiedz_z_emapa_transport then
                    break;
            end;
        end;
    end;
end;
}

function ILocalizeEmapaApp.RetrieveReport2(EntID: Integer;
                        Position: Integer;
                        onProgress: TOnRaportCreateProgress2;
                        GetStreetsFromEmapaTransport: Boolean = False): IReportEmapaCollection;
var // rc: IReportCollection;
    i, j: Integer;
//    e: IReportEntry;
//    e2: IReportEmapaEntry;
    lo: ILocalizeEmapaObject;
    lp: IEmapaPosition;
    query: TStrings;
    http: TIdHttp;
    query2, wynik: String;
    strstream: TStringStream;
    node: IXMLNode;
    re: IReportEmapaEntry;
    gotowe: Boolean;
    dodano_chociaz_jeden: Boolean;
//    lista: array [0..132, 3..14] of String;
    root: IXMLNode;
    sessionID: String;
    state, county, city, street: String;
    adress_id: Integer;
begin
    result := IReportEmapaCollection.Create();
//    result.rc := nil;
    lp := nil;
    for i := 0 to Length(self.FLocalizeCollection.items) - 1 do
    begin
        lo := self.FLocalizeCollection.items[i];
        for j := 0 to lo.Positions.Count - 1 do
        begin
            lp := lo.Positions.positions[j];
            break;
        end;
    end;
    if lp <> nil then
    begin

        if @onProgress <> nil then
            onProgress(1, 1);

        query := TStringList.Create();

        query.Clear();
        query.Add('<QUERY>');
        query.Add('<MC_QUERY_NAME>CreateSessionID</MC_QUERY_NAME>');
        query.Add('</QUERY>');


        http := TIdHttp.Create(nil);
//                http.MaxLineLength := 1048576;
//                http.RecvBufferSize := 1048576;
//                http.SendBufferSize := 1048576;
//                http.ProtocolVersion := pv1_1;
        http.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows 98)';
//        if DM.MapcenterServer <> '' then
//        begin
//            http.Host := DM.MapcenterServer;
//            http.Port := DM.MapcenterListeningPort;
//        end
//        else
//        begin
//            http.Host := DM.MapcenterServerUlice;
//            http.Port := DM.MapcenterListeningPortUlice;
//        end;
///        login := DM.MapcenterServerUser;
///        pass := DM.MapcenterServerPassword;


        //                http.Request.URL := host;
//        frmMain.bCrcCheckClick(nil);
        try
            http.Request.BasicAuthentication := True;
            http.Request.Username := login;
            http.Request.Password := pass;


//                    http.Request.UserAgent := DM.CodeActiveCarCount();
//            http.Request.CustomHeaders.Add('CarCount: ' +
//                DM.CodeActiveCarCount());
            http.Connect();
        except
            http.Free();
            query.Free();
            raise Exception.Create(mapcenter_error_message);
        end;

        query2 := query.Text;
//                query2 := Clipboard.AsText;
//                Clipboard.AsText := query2;
        query2 := utf8encode(query2);
        strstream := TStringStream.Create(query2);
        try
            wynik := http.Post('http://' + host + ':' +
                IntToStr(port) + '/xml?version=2.0', strstream);
            if Pos('Authentication failed', wynik) > 0 then
                raise EIdHTTPProtocolException.Create('Authentication failed');
        except
            on e: EIdHTTPProtocolException do
            begin
//                        Clipboard.AsText := e.Message;
                http.Free();
                query.Free();
                strstream.Free();
                raise Exception.Create(mapcenter_error_message);
            end
            else
            begin
                http.Free();
                query.Free();
                strstream.Free();
                raise Exception.Create(mapcenter_error_message);
            end;
        end;

        TEDEmailSrv.XML.LoadFromXML(wynik);
        node := TEDEmailSrv.XML.DocumentElement.ChildNodes.Nodes['SessionID'];
        sessionID := node.text;


//                http.Free();
//                query.Free();
        strstream.Free();

        query.Clear();
        query.Add('<QUERY>');
        query.Add('<MC_QUERY_NAME>Degeocode</MC_QUERY_NAME>');
        query.Add('<SessionID>' + sessionID + '</SessionID>');
        query.Add('<MiddlePoint>');
        query.Add('  <Longitude>0</Longitude>');
        query.Add('  <Latitude>0</Latitude>');
        query.Add('</MiddlePoint>');
        query.Add('<MapAltitude>0</MapAltitude>');
        query.Add('<MapRotation>0</MapRotation>');
        query.Add('<MapTilt>0</MapTilt>');
        query.Add('<MapProjection>Mercator</MapProjection>');
        query.Add('<MapProjectionParams></MapProjectionParams>');
        query.Add('<MapPoints>');
        gotowe := True;
        dodano_chociaz_jeden := False;
        for i := 0 to Length(self.FLocalizeCollection.items) - 1 do
        begin
            lo := self.FLocalizeCollection.items[i];
            for j := 0 to lo.Positions.Count - 1 do
            begin
                lp := lo.Positions.positions[j];

                gotowe := False;

//                    if not ((lp.FLongitude = 0.0) and (lp.FLatitude = 0.0)) then
                begin
                    query.Add('<ITEM>' +
                        '<Longitude>' + FloatToStr(lp.FLongitude) + '</Longitude>' +
                        '<Latitude>' + FloatToStr(lp.FLatitude) + '</Latitude>' +
                        '</ITEM>');
                    dodano_chociaz_jeden := True;
                end;
            end;
        end;
        query.Add('</MapPoints>');

        if gotowe or (not dodano_chociaz_jeden) then
        begin
            query.Free();
            exit;
        end;

        query.Add('<QueryRadius>200</QueryRadius>');
        query.Add('<MaxElems>0</MaxElems>');
        query.Add('<DegeocodeLayers>');
        query.Add('<ITEM>Area0</ITEM>');
        query.Add('<ITEM>Area1</ITEM>');
        query.Add('<ITEM>Area2</ITEM>');
        query.Add('<ITEM>Area3</ITEM>');
        query.Add('<ITEM>Area9</ITEM>');
        query.Add('<ITEM>Buildings</ITEM>');
        query.Add('<ITEM>CalculatedRoute</ITEM>');
        query.Add('<ITEM>Cities</ITEM>');
        query.Add('<ITEM>CourveText</ITEM>');
    //    query.Add('<ITEM>Forests</ITEM>');
        query.Add('<ITEM>IndustrialAreas</ITEM>');
    //    query.Add('<ITEM>Islands</ITEM>');
        query.Add('<ITEM>Localize</ITEM>');
        query.Add('<ITEM>LogisticInformation</ITEM>');
        query.Add('<ITEM>Logistics</ITEM>');
    //    query.Add('<ITEM>NationalParks</ITEM>');
        query.Add('<ITEM>Objects</ITEM>');
        query.Add('<ITEM>Peaks</ITEM>');
        query.Add('<ITEM>POI</ITEM>');
        query.Add('<ITEM>POI_Parking</ITEM>');
        query.Add('<ITEM>Rails</ITEM>');
    //    query.Add('<ITEM>RailStations</ITEM>');
    //    query.Add('<ITEM>Rivers</ITEM>');
        query.Add('<ITEM>Roads</ITEM>');
        query.Add('<ITEM>RoutePlannerEntries</ITEM>');
    //    query.Add('<ITEM>Seas</ITEM>');
        query.Add('<ITEM>SpatialDataViewer</ITEM>');
    //    query.Add('<ITEM>Squares</ITEM>');
        query.Add('<ITEM>TMC</ITEM>');
    //    query.Add('<ITEM>TOPOLines</ITEM>');
        query.Add('<ITEM>TrafficInformation</ITEM>');
        query.Add('<ITEM>TuristInfo</ITEM>');
    //    query.Add('<ITEM>Waters</ITEM>');
        query.Add('<ITEM>ZIPAreas</ITEM>');
        query.Add('</DegeocodeLayers>');
        query.Add('<OnlyNamedEntries>1</OnlyNamedEntries>');
        query.Add('<UseViewVisibility>0</UseViewVisibility>');
        query.Add('</QUERY>');

        query2 := query.Text;
//                query2 := Clipboard.AsText;
//                Clipboard.AsText := query2;
        query2 := utf8encode(query2);
        strstream := TStringStream.Create(query2);
        try
            wynik := http.Post('http://' + host + ':' +
                IntToStr(port) + '/xml?version=2.0', strstream);
            if Pos('Authentication failed', wynik) > 0 then
                raise EIdHTTPProtocolException.Create('Authentication failed');
        except
            on e: EIdHTTPProtocolException do
            begin
//                        Clipboard.AsText := e.Message;
                http.Free();
                query.Free();
                strstream.Free();
                raise Exception.Create(mapcenter_error_message);
            end
            else
            begin
                http.Free();
                query.Free();
                strstream.Free();
                raise Exception.Create(mapcenter_error_message);
            end;
        end;


        TEDEmailSrv.XML.LoadFromXML(wynik);

//        Clipboard.AsText := wynik;

        root := TEDEmailSrv.XML.DocumentElement.ChildNodes.Nodes['Results'].ChildNodes.Nodes['ITEM'];
        adress_id := -1;

        while root <> nil do
        begin
            Inc(adress_id);

            node := root.ChildNodes.Nodes['AreaName2'];
            county := node.text;

            node := root.ChildNodes.Nodes['AreaName3'];
            state := node.text;

            node := root.ChildNodes.Nodes['City'];
            city := node.ChildNodes.Nodes['Name'].Text;

            node := root.ChildNodes.Nodes['Street'];
            street := node.ChildNodes.Nodes['Name'].Text;

            while not (adress_id < Length(result.FItem)) do
            begin
                SetLength(result.FItem, Length(result.FItem) + 1);
                result.FItem[Length(result.FItem) - 1] :=
                        IReportEmapaEntry.Create(result);
            end;
            re := result.FItem[adress_id];
//                lp := nil;
            for i := 0 to Length(self.FLocalizeCollection.items) - 1 do
            begin
                lo := self.FLocalizeCollection.items[i];
                for j := 0 to lo.Positions.Count - 1 do
                begin
//                        lp := lo.Positions.positions[j];
                    if (i * 100000 + j) = adress_id then
                        break;
                end;
            end;

            re.FState := state;
            re.FCounty := county;
            re.FNeighbourhood := Trim(city + ' ' + street);
            re.FNeighbourhood := Trim(re.FNeighbourhood);

            if re.FNeighbourhood = '' then
            begin
                re.FNeighbourhood := state + ' powiat ' + county;
                re.FNeighbourhood := Trim(re.FNeighbourhood);
            end;

            root := root.NextSibling();
        end;
        http.Free();
        query.Free();
        strstream.Free();
    end;
end;


function IReportEmapaEntry.PositionInCollection(): Integer;
var i: Integer;
begin
//    if re <> nil then
//        result := re.PositionInCollection
//    else
    begin
        i := 0;
        while i < rec.Count() do
        begin
            if rec.FItem[i] = Self then
                break;
            Inc(i);
        end;
        result := i + 1;
    end;
end;

procedure ILocalizeEmapaCollection.Clear();
var i: Integer;
begin
//    if lc <> nil then
//        lc.Clear();
    for i := 0 to Length(Items) - 1 do
        Items[i].Free();
    SetLength(Items, 0);
end;

function OdNajstarszego(Item1, Item2: Pointer): Integer;
type
   ILocalizeEmapaObjectPtr = ^ ILocalizeEmapaObject;
var p1, p2: ILocalizeEmapaObject;
begin
    p1 := ILocalizeEmapaObject(Item1);
    p2 := ILocalizeEmapaObject(Item2);
    if (p1.Positions.Count > 0) and (p2.Positions.Count > 0) then
    begin
        if p1.Positions.positions[Length(p1.Positions.positions) - 1].FTime >
             p2.Positions.positions[Length(p2.Positions.positions) - 1].FTime then
            result := -1
        else
        if p1.Positions.positions[Length(p1.Positions.positions) - 1].FTime <
             p2.Positions.positions[Length(p2.Positions.positions) - 1].FTime then
            result := 1
        else
            result := 0;
    end
    else
        result := 0;
end;

procedure IEmapaPosition.ZoomTo();
begin
    zoom_this_position := True;
end;

end.

