unit frmMainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, CompressBLT, Mask, ToolEdit;

type
  TfrmMain = class(TForm)
    TreeView: TTreeView;
    bNewArchive: TButton;
    Button1: TButton;
    Button2: TButton;
    bDecompressTo: TButton;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    DirectoryEdit: TDirectoryEdit;
    ProgressBar: TProgressBar;
    StatusLabel: TLabel;
    procedure bNewArchiveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure bDecompressToClick(Sender: TObject);
  private
    { Private declarations }
    procedure OnProgress(const KatPlikName: AnsiString; action: TBLTProgressAction; progress, max: LongInt);
  public
    Archiwum: TBLTArchive;
    ArchiwumView: TBLTArchiveView;
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

procedure TfrmMain.bNewArchiveClick(Sender: TObject);
begin
    if Archiwum <> nil then
    begin
        ArchiwumView.Free();
        Archiwum.Free();
        Archiwum := nil;
    end;

    if SaveDialog.Execute() then
    begin
        DeleteFile(SaveDialog.FileName);
        if ExtractFileExt(SaveDialog.FileName) = '' then
            if SaveDialog.FilterIndex = 1 then
                SaveDialog.FileName := SaveDialog.FileName + '.inst'
            else
                SaveDialog.FileName := SaveDialog.FileName + '.upgr';
        Archiwum := TBLTArchive.Create(SaveDialog.FileName);
        Archiwum.OnProgress := OnProgress;
        ArchiwumView := TBLTArchiveView.Create(Archiwum, TreeView);
        ArchiwumView.RefreshView();
    end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    Archiwum := nil;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
    if Archiwum <> nil then
    begin
        ArchiwumView.Free();
        Archiwum.Free();
    end;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
    if Archiwum <> nil then
    begin
        ArchiwumView.Free();
        Archiwum.Free();
        Archiwum := nil;
    end;

    if OpenDialog.Execute() then
    begin
        Archiwum := TBLTArchive.Create(OpenDialog.FileName);
        Archiwum.OnProgress := OnProgress;
        ArchiwumView := TBLTArchiveView.Create(Archiwum, TreeView);
        ArchiwumView.RefreshView();
    end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var tmp: AnsiString;
begin
    if Archiwum <> nil then
    begin
//        DirectoryEdit.Text := '.';
        tmp := DirectoryEdit.Text;
        DirectoryEdit.DoClick();
//        if DirectoryEdit.Text <> tmp then
        begin
            tmp := Trim(DirectoryEdit.Text);
            if Length(tmp) > 0 then
                if tmp[1] = '"' then
                    tmp := Copy(tmp, 2, 1000);
            if Length(tmp) > 0 then
                if tmp[Length(tmp)] = '"' then
                    tmp := Copy(tmp, 1, Length(tmp) - 1);
            if Length(tmp) > 0 then
                if tmp[Length(tmp)] <> '\' then
                    tmp := tmp + '\';
            Archiwum.KompresujZ(tmp);
            ArchiwumView.RefreshView();
        end;
    end
    else
        Beep();
end;

procedure TfrmMain.OnProgress(const KatPlikName: AnsiString;
    action: TBLTProgressAction; progress, max: LongInt);
var label_: AnsiString;
begin
    if ProgressBar.Max <> max then
        ProgressBar.Max := max;
    ProgressBar.Position := progress;
    if action = bltCompressing then
        label_ := 'Kompresowanie '
    else
    if action = bltDecompressing then
        label_ := 'Dekompresowanie '
    else
    if action = bltRebuild then
        label_ := 'Przebudowa ';
    StatusLabel.Caption := label_ + KatPlikName;
    StatusLabel.Update();
    ProgressBar.Update();
    Application.ProcessMessages();
end;

procedure TfrmMain.bDecompressToClick(Sender: TObject);
var tmp: AnsiString;
begin
    if Archiwum <> nil then
    begin
        DirectoryEdit.Text := '.';
        tmp := DirectoryEdit.Text;
        DirectoryEdit.DoClick();
        if DirectoryEdit.Text <> tmp then
        begin
            tmp := Trim(DirectoryEdit.Text);
            if Length(tmp) > 0 then
                if tmp[1] = '"' then
                    tmp := Copy(tmp, 2, 1000);
            if Length(tmp) > 0 then
                if tmp[Length(tmp)] = '"' then
                    tmp := Copy(tmp, 1, Length(tmp) - 1);
            if Length(tmp) > 0 then
                if tmp[Length(tmp)] <> '\' then
                    tmp := tmp + '\';
            Archiwum.DekompresujDo(tmp);
            ArchiwumView.RefreshView();
        end;
    end
    else
        Beep();
end;

end.

