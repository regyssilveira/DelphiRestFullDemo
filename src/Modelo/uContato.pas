{
  Modelo de Negório: Regras encapsuladas
  Recurso: CONTATO = associação com as classes TEmail e TTelefone

  OBS: Quando se herda de um TComponent, a instancia/criação do objeto precisa
  ter um Owner, senão, passa nil...
}

unit uContato;

interface

uses
  System.Classes, System.Generics.Collections;

type
  TEmail = class { Agregação }
  private
    FItemId: Integer;
    FContatoId: Integer;
    FEmail: string;
    FTipo: string;
    procedure SetItemId(const Value: Integer);
    procedure SetContatoId(const Value: Integer);
    procedure SetEmail(const Value: string);
    procedure SetTipo(const Value: string);
  public
    property ItemId: Integer read FItemId write SetItemId;
    property ContatoId: Integer read FContatoId write SetContatoId;
    property Email: string read FEmail write SetEmail;
    property Tipo: string read FTipo write SetTipo;
  end;

  TTelefone = class { Agregação }
  private
    FItemId: Integer;
    FContatoIdo: Integer;
    FDDD: string;
    FNumero: string;
    FTipo: string;
    procedure SetItemId(const Value: Integer);
    procedure SetContatoIdo(const Value: Integer);
    procedure SetDDD(const Value: string);
    procedure SetNumero(const Value: string);
    procedure SetTipo(const Value: string);
  public
    property ItemId: Integer read FItemId write SetItemId;
    property ContatoIdo: Integer read FContatoIdo write SetContatoIdo;
    property DDD: string read FDDD write SetDDD;
    property Numero: string read FNumero write SetNumero;
    property Tipo: string read FTipo write SetTipo;
  end;

  TContato = class { Recurso }
  private
    FCodigo: Integer;
    FEmpresa: string;
    FNome: string;
    FTelefones: TList<TTelefone>;
    FEmails: TList<TEmail>;
    procedure SetCodigo(const Value: Integer);
    procedure SetEmpresa(const Value: string);
    procedure SetNome(const Value: string);
  public
    {
      Boa Prática: Sempre que declararmos Propriedades do Tipo de Outras classes,
      devemos instancia-las no Construtor da Classe que recebe o objeto agregado,
      que neste caso, é a classe TContato que recebe por agregação, as classes
      TEmail e TTelefone via Listas/Tipadas, sempre lembrando de destruílas no
      Destrutor da Classe.
    }
    constructor Create;
    destructor Destroy; override;
    property Codigo: Integer read FCodigo write SetCodigo;
    property Nome: string read FNome write SetNome;
    property Empresa: string read FEmpresa write SetEmpresa;
    property Emails: TList<TEmail> read FEmails; { Lista Tipada/Generic = Email - somente leitura }
    property Telefones: TList<TTelefone> read FTelefones; { Lista Tipada/Generic = Telefone - somente leitura }
    procedure Validar();
  end;


implementation

{ TContato }

constructor TContato.Create;
begin
  FEmails := TList<TEmail>.Create;
  FTelefones := TList<TTelefone>.Create;
end;

destructor TContato.Destroy;
begin
  FEmails.Free;
  FTelefones.Free;

  inherited;
end;

procedure TContato.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TContato.SetEmpresa(const Value: string);
begin
  FEmpresa := Value;
end;

procedure TContato.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TContato.Validar();
var
  Str: string;
begin
  Str := 'Validando...';
end;

{ TEmail }

procedure TEmail.SetContatoId(const Value: Integer);
begin
  FContatoId := Value;
end;

procedure TEmail.SetEmail(const Value: string);
begin
  FEmail := Value;
end;

procedure TEmail.SetItemId(const Value: Integer);
begin
  FItemId := Value;
end;

procedure TEmail.SetTipo(const Value: string);
begin
  FTipo := Value;
end;

{ TTelefone }

procedure TTelefone.SetContatoIdo(const Value: Integer);
begin
  FContatoIdo := Value;
end;

procedure TTelefone.SetDDD(const Value: string);
begin
  FDDD := Value;
end;

procedure TTelefone.SetItemId(const Value: Integer);
begin
  FItemId := Value;
end;

procedure TTelefone.SetNumero(const Value: string);
begin
  FNumero := Value;
end;

procedure TTelefone.SetTipo(const Value: string);
begin
  FTipo := Value;
end;

end.

{ TODO -oCharles -c0 : Tratar exceção, Gestão de Memória (ReportMemoryLeakOnShootDown), etc... }
