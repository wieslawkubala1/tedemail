program CompressTool;

uses
  Forms,
  frmMainUnit in 'frmMainUnit.pas' {frmMain},
  CompressBLT in 'CompressBLT.pas',
  Zlib2 in 'Zlib2.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
