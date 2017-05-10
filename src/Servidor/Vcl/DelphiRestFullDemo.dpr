program DelphiRestFullDemo;

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  uFrmMenu in 'uFrmMenu.pas' {FrmServidor},
  uSM in 'uSM.pas' {SM: TDSServerModule},
  uSC in 'uSC.pas' {SC: TDataModule},
  uContato in '..\..\Modelo\uContato.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSC, SC);
  Application.CreateForm(TSM, SM);
  Application.CreateForm(TFrmServidor, FrmServidor);
  Application.Run;
end.

