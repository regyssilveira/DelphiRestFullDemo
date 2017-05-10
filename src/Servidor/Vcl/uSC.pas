unit uSC;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DSTCPServerTransport,
  Datasnap.DSHTTPCommon, Datasnap.DSHTTP, Datasnap.DSServer,
  Datasnap.DSCommonServer, IPPeerServer, IPPeerAPI, Datasnap.DSAuth,
  DbxSocketChannelNative, DbxCompressionFilter, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Phys.IBBase,
  FireDAC.Comp.UI, Data.DB, FireDAC.Comp.Client,
  { Declarações }
  System.IniFiles, Vcl.Forms;

type
  TSC = class(TDataModule)
    DSServer: TDSServer;
    DSTCPServerTransport: TDSTCPServerTransport;
    DSHTTPService: TDSHTTPService;
    DSAuthenticationManager: TDSAuthenticationManager;
    DSServerClass: TDSServerClass;
    cursor: TFDGUIxWaitCursor;
    link: TFDPhysFBDriverLink;
    Conexao: TFDConnection;
    procedure DSServerClassGetClass(DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
    procedure DSAuthenticationManagerUserAuthorize(Sender: TObject; EventObject: TDSAuthorizeEventObject; var valid: Boolean);
    procedure DSAuthenticationManagerUserAuthenticate(Sender: TObject; const Protocol, Context, User, Password: string; var valid: Boolean; UserRoles: TStrings);
    procedure ConexaoBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    I: TIniFile;
  public
  end;

var
  SC: TSC;

implementation

{$R *.dfm}

uses
  uSM;

procedure TSC.DSServerClassGetClass(DSServerClass: TDSServerClass;
  var PersistentClass: TPersistentClass);
begin
  PersistentClass := uSM.TSM;
end;

procedure TSC.ConexaoBeforeConnect(Sender: TObject);
begin
  Conexao.ConnectionName := 'ConnFB';
  Conexao.Params.Values['DriverName'] := I.ReadString('ConnFB', 'DriverName', '');
  Conexao.Params.Values['Database']   := I.ReadString('ConnFB', 'Database', '');
  Conexao.Params.Values['VendorLib']  := I.ReadString('ConnFB', 'VendorLib', '');
  Conexao.Params.Values['User_Name']  := I.ReadString('ConnFB', 'User_Name', '');
  Conexao.Params.Values['Password']   := I.ReadString('ConnFB', 'Password', '');
  Conexao.Params.Values['Protocol']   := I.ReadString('ConnFB', 'Protocol', '');
  Conexao.Params.Values['Server']     := I.ReadString('ConnFB', 'Server', '');
  Conexao.Params.Values['Port']       := I.ReadString('ConnFB', 'Port', '');
  Conexao.Params.Values['DriverID']   := I.ReadString('ConnFB', 'DriverID', '');
  Conexao.Params.Values['DriverName'] := I.ReadString('ConnFB', 'DriverName', '');
end;

procedure TSC.DataModuleCreate(Sender: TObject);
begin
  I := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini')
end;

procedure TSC.DSAuthenticationManagerUserAuthenticate(Sender: TObject;
  const Protocol, Context, User, Password: string; var valid: Boolean;
  UserRoles: TStrings);
begin
  { TODO : Validate the client user and password.
    If role-based authorization is needed, add role names to the UserRoles parameter }
  valid := True;
end;

procedure TSC.DSAuthenticationManagerUserAuthorize(Sender: TObject;
  EventObject: TDSAuthorizeEventObject; var valid: Boolean);
begin
  { TODO : Authorize a user to execute a method.
    Use values from EventObject such as UserName, UserRoles, AuthorizedRoles and DeniedRoles.
    Use DSAuthenticationManager1.Roles to define Authorized and Denied roles
    for particular server methods. }
  valid := True;
end;

end.
