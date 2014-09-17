program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmSplash},
  Unit2 in 'Unit2.pas' {frmAuto},
  Unit3 in 'Unit3.pas' {frmMain},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSplash, frmSplash);
  Application.CreateForm(TfrmAuto, frmAuto);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
