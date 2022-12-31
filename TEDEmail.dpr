program TEDEmail;

uses
  SvcMgr,
  TEDEmailUnit in 'TEDEmailUnit.pas' {TEDEmailSrv: TService},
  fncPasswordUnit in 'fncPasswordUnit.pas',
  TypyUnit in 'TypyUnit.pas',
  fncFCSUnit in 'fncFCSUnit.pas',
  fncDataCzasBCB in 'fncDataCzasBCB.pas',
  clEmapaTransportOrMapCenterUnit2 in 'clEmapaTransportOrMapCenterUnit2.pas',
  VerInfo in 'VerInfo.pas',
  fncSettingsHistoryUnit in 'fncSettingsHistoryUnit.pas',
  CompressBLT in 'CompressBLT\CompressBLT.pas',
  Zlib2 in 'CompressBLT\Zlib2.pas',
  clFileDataSetUnit in 'clFileDataSetUnit.pas',
  fncExportUnit in 'fncExportUnit.pas',
  MD5 in 'MD5.pas',
  DMUnit in 'DMUnit.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TTEDEmailSrv, TEDEmailSrv);
  Application.Run;
end.
