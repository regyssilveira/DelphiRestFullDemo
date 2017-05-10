unit uSM;

interface

uses
  System.SysUtils, System.Classes, System.Json,
  DataSnap.DSProviderDataModuleAdapter, DataSnap.DSServer, DataSnap.DSAuth,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  {Declarações}
  uContato, uSC, REST.Json;

type
  TSM = class(TDSServerModule)
    qryContato: TFDQuery;
    qryContatoEmail: TFDQuery;
    qryContatoTelefone: TFDQuery;
    qryAUX: TFDQuery;
    qryContatoMaster: TFDQuery;
    qryContatoTelefoneDetail: TFDQuery;
    dsContatoMasterTelefone: TDataSource;
    dsContatoMasterEmail: TDataSource;
    FDSchemaAdapter: TFDSchemaAdapter;
    qryContatoEmailDetail: TFDQuery;
  private
    function GetInternalContatos(ID: Integer = 0): TJSONValue;
    procedure UpdateInternalContato(Contato: TJSONObject; Action: string; var Result: TJSONValue);
    function GetNextIDContato(): Integer;
  public
    function Contatos: TJSONValue; { Retorna a lista com os contatos }
    function Contato(ID: Integer): TJSONValue;
    function AcceptContatos(Contato: TJSONObject): TJSONValue; { REST-PUT }
    function UpdateContatos(Contato: TJSONObject): TJSONValue; { REST-POST }
    function CancelContatos(ContatoID: Integer): TJSONValue; { REST-DELETE }
    function DelTelefoneContato(ContatoID: Integer): Boolean;
    function DelEmailContato(ContatoID: Integer): Boolean;
  end;

var
  SM: TSM;

implementation

{$R *.dfm}
{ TSM }

function TSM.GetNextIDContato(): Integer;
begin
  qryAUX.Close;
  qryAUX.SQL.Clear;
  // qryAUX.SQL.Text := 'Select coalesce(Max(CODIGO), 0) + 1 From CONTATO';
  qryAUX.Open('Select coalesce(Max(CODIGO), 0) + 1 From CONTATO');
  Result := qryAUX.Fields[0].AsInteger;
end;

function TSM.AcceptContatos(Contato: TJSONObject): TJSONValue;
// var
// vContato: TContato;
// vTelefone: TTelefone;
// vEmail: TEmail;
// I: Integer;
begin
  UpdateInternalContato(Contato, 'I', Result);
  // { Até chegar na chamada do Método, é JSON }
  // vContato := TJson.JsonToObject<TContato>(Contato); { Converte: JsonToObject }
  // { Convertido: A partir desse momento já estamos a nível de objetos }
  //
  // { Incluindo o Contato/Master }
  // qryContato.Open;
  // qryContato.Append;
  // { Caso o campo ID seja do tipo Auto-incremento, não preciso passar }
  // qryContato.FieldByName('CODIGO').AsInteger := GetNextIDContato();
  // qryContato.FieldByName('NOME').AsString    := vContato.Nome;
  // qryContato.FieldByName('EMPRESA').AsString := vContato.Empresa;
  // qryContato.Post; { Nesse momento ID já gerado para passar para as agregações }
  // { Contato já preenchido, porém, ainda não enviado ao BD }
  //
  // { Incluindo o Telefone/Agregação }
  // { Mapeando os Telefones }
  // qryContatoTelefoneDetail.Open;
  // I := 1;
  // for vTelefone in vContato.Telefones do
  // begin
  // qryContatoTelefoneDetail.Append;
  // { Caso o campo ID seja do tipo Auto-incremento, não preciso passar }
  // { Não preciso passar o ID do Master, porque há uma relação Master-Detail }
  // qryContatoTelefoneDetail.FieldByName('ITEM_ID').AsInteger   := I;
  // qryContatoTelefoneDetail.FieldByName('CONTATOID').AsInteger := qryContato.Fields[0].AsInteger;
  // qryContatoTelefoneDetail.FieldByName('DDD').AsString        := vTelefone.DDD;
  // qryContatoTelefoneDetail.FieldByName('NUMERO').AsString     := vTelefone.Numero;
  // qryContatoTelefoneDetail.FieldByName('TIPO').AsString       := vTelefone.Tipo;
  // I := I+1;
  // qryContatoTelefoneDetail.Post; { não preciso dar um NEXT porque o For-In já avança para o próximo registro }
  // end;
  //
  // { Incluindo o Email/Agregação }
  // { Mapeando os Emails }
  // qryContatoEmailDetail.Open;
  // I := 1;
  // for vEmail in vContato.Emails do
  // begin
  // qryContatoEmailDetail.Append;
  // { Caso o campo ID seja do tipo Auto-incremento, não preciso passar }
  // { Não preciso passar o ID do Master, porque há uma relação Master-Detail }
  // qryContatoEmailDetail.FieldByName('ITEM_ID').AsInteger   := I;
  // qryContatoEmailDetail.FieldByName('CONTATOID').AsInteger := qryContato.Fields[0].AsInteger;
  // qryContatoEmailDetail.FieldByName('EMAIL').AsString      := vEmail.Email;
  // qryContatoEmailDetail.FieldByName('TIPO').AsString       := vEmail.Tipo;
  // I := I+1;
  // qryContatoEmailDetail.Post;{ não preciso dar um NEXT porqu eo For-In já avança para o próximo registro }
  // end;
  //
  // { Finalmente, vou no meu SChemaAdaptar e dou um ApplyUpdates }
  // FDSchemaAdapter.ApplyUpdates(0); { Persisto no BD }
  // FDSchemaAdapter.CommitUpdates;
  //
  // { Fecho minhas tabelas }
  // qryContato.Close; { Master }
  // qryContatoTelefoneDetail.Close; { Detail }
  // qryContatoEmailDetail.Close; { Detail }
  //
  // { Por fim, dou o Result }
  // Result := TJSONString.Create('Objeto incluido com sucesso...');
end;

function TSM.Contato(ID: Integer): TJSONValue;
begin
  Result := GetInternalContatos(ID);
end;

function TSM.Contatos: TJSONValue;
begin
  Result := GetInternalContatos;
end;

function TSM.DelEmailContato(ContatoID: Integer): Boolean;
begin
  qryContatoEmailDetail.Filter   := 'CONTATOID = '+ContatoID.ToString;
  qryContatoEmailDetail.Filtered := True;
  qryContatoEmailDetail.Open;

//  qryContatoEmailDetail.First;
//  while not qryContatoEmailDetail.Eof do
//  begin
//    qryContatoEmailDetail.Delete;
//    qryContatoEmailDetail.Next;
//  end;

    { Excluir o Detalhe Telefone }
  if qryContatoEmailDetail.Active then
  begin
    { cascade a nível de aplicação }
    while not qryContatoEmailDetail.IsEmpty do
      qryContatoEmailDetail.Delete(); { deleto a tabela Detail }
  end;

  Result := True;
end;

function TSM.DelTelefoneContato(ContatoID: Integer): Boolean;
begin
  qryContatoTelefoneDetail.Filter   := 'CONTATOID = '+ContatoID.ToString;
  qryContatoTelefoneDetail.Filtered := True;
  qryContatoTelefoneDetail.Open;

//  qryContatoTelefoneDetail.First;
//  while not qryContatoTelefoneDetail.Eof do
//  begin
//    qryContatoTelefoneDetail.Delete;
//    qryContatoTelefoneDetail.Next;
//  end;


  { Excluir o Detalhe Telefone }
  if qryContatoTelefoneDetail.Active then
  begin
    { cascade a nível de aplicação }
    while not qryContatoTelefoneDetail.IsEmpty do
      qryContatoTelefoneDetail.Delete(); { deleto a tabela Detail }
  end;

  Result := True;
end;

function TSM.GetInternalContatos(ID: Integer): TJSONValue;
var
  Arr: TJSONArray;
  Obj: TJSONObject;
  I: Integer;
  Contato: TContato;
  Telefone: TTelefone;
  Email: TEmail;
begin
  Arr := TJSONArray.Create;

  qryContato.Close; { Filtrando o Contato pelo ID }
  if ID <> 0 then
  begin
    qryContato.Filter := 'CODIGO =' + IntToStr(ID);
    qryContato.Filtered := True;
  end;
  { ... }

  qryContato.Open;
  qryContato.First;
  while not qryContato.eof do
  begin
    Contato := TContato.Create;
    Contato.Codigo := qryContato.FieldByName('CODIGO').AsInteger;
    Contato.Nome := qryContato.FieldByName('NOME').AsString;
    Contato.Empresa := qryContato.FieldByName('EMPRESA').AsString;

    { Filtrando os telefones do Contato de acordo com o ID }
    qryContatoTelefone.Close;
    qryContatoTelefone.Filter := 'CONTATOID =' + qryContato.FieldByName
      ('CODIGO').AsString;
    qryContatoTelefone.Filtered := True;
    qryContatoTelefone.Open;
    while not qryContatoTelefone.eof do
    begin
      Telefone := TTelefone.Create;
      Telefone.ItemId := qryContatoTelefone.FieldByName('ITEM_ID').AsInteger;
      Telefone.ContatoIdo := qryContatoTelefone.FieldByName('CONTATOID')
        .AsInteger;
      Telefone.DDD := qryContatoTelefone.FieldByName('DDD').AsString;
      Telefone.Numero := qryContatoTelefone.FieldByName('NUMERO').AsString;
      Telefone.Tipo := qryContatoTelefone.FieldByName('TIPO').AsString;
      Contato.Telefones.Add(Telefone); { Preencho a Lista }
      qryContatoTelefone.Next; { Próximo... }
    end;
    { ... }

    { Filtrando os Emails do Contato de acordo com o ID }
    qryContatoEmail.Close;
    qryContatoEmail.Filter := 'CONTATOID =' + qryContato.FieldByName
      ('CODIGO').AsString;
    qryContatoEmail.Filtered := True;
    qryContatoEmail.Open;
    while not qryContatoEmail.eof do
    begin
      Email := TEmail.Create;
      Email.ItemId := qryContatoEmail.FieldByName('ITEM_ID').AsInteger;
      Email.ContatoID := qryContatoEmail.FieldByName('CONTATOID').AsInteger;
      Email.Email := qryContatoEmail.FieldByName('EMAIL').AsString;
      Email.Tipo := qryContatoEmail.FieldByName('TIPO').AsString;
      Contato.Emails.Add(Email); { Preencho a Lista }
      qryContatoEmail.Next; { Próximo... }
    end;
    { ... }

    {
      convertendo o contato em JSONObject, assim não preciso ficar adicionando
      Pair... Já fiz as associações, agora converto...
    }
    Obj := TJson.ObjectToJsonObject(Contato);

    Arr.AddElement(Obj); { Adiciono o Objeto no Array }
    qryContato.Next;
  end;
  {
    já passamos por todos os contatos, fizemos todos os filtros de acordo com
    as associações entre as classes, neste caso por agregação. Agora é só
    adicionar o Array ao Result do processamento do Método, cujo o retorno, é
    um TJSONValue...
  }
  Result := Arr;
end;

function TSM.UpdateContatos(Contato: TJSONObject): TJSONValue;
begin
  UpdateInternalContato(Contato, 'U', Result);
end;

procedure TSM.UpdateInternalContato(Contato: TJSONObject; Action: string; var Result: TJSONValue);
var
  vContato: TContato;
  vTelefone: TTelefone;
  vEmail: TEmail;
  vFilter: string;
  I: Integer;
begin
  vContato := TJson.JsonToObject<TContato>(Contato);

  if Action = 'U' then
  begin
    vFilter := 'CODIGO = ' + vContato.Codigo.ToString;
    qryContatoMaster.Filter   := vFilter;
    qryContatoMaster.Filtered := True;
  end;
  { ... }
  qryContatoMaster.Open;
  qryContatoTelefoneDetail.Open;
  qryContatoEmailDetail.Open;
  { ... }
  if Action = 'U' then
  begin
    qryContatoMaster.Edit;
  end
  else
  begin
    qryContatoMaster.Append;
    qryContatoMaster.FieldByName('CODIGO').AsInteger := GetNextIDContato();
  end;
  qryContatoMaster.FieldByName('NOME').AsString := vContato.Nome;
  qryContatoMaster.FieldByName('EMPRESA').AsString := vContato.Empresa;
  qryContatoMaster.Post;
  { ... }
  DelTelefoneContato(vContato.Codigo);
  I := 1;
  for vTelefone in vContato.Telefones do
  begin
    qryContatoTelefoneDetail.Append;
    qryContatoTelefoneDetail.FieldByName('ITEM_ID').AsInteger   := I;
    qryContatoTelefoneDetail.FieldByName('CONTATOID').AsInteger := qryContatoMaster.Fields[0].AsInteger;
    qryContatoTelefoneDetail.FieldByName('DDD').AsString        := vTelefone.DDD;
    qryContatoTelefoneDetail.FieldByName('NUMERO').AsString     := vTelefone.Numero;
    qryContatoTelefoneDetail.FieldByName('TIPO').AsString       := vTelefone.Tipo;
    I := I + 1;
    qryContatoTelefoneDetail.Post;
  end;
  { ... }
  DelEmailContato(vContato.Codigo);
  I := 1;
  for vEmail in vContato.Emails do
  begin
    qryContatoEmailDetail.Append;
    qryContatoEmailDetail.FieldByName('ITEM_ID').AsInteger := I;
    qryContatoEmailDetail.FieldByName('CONTATOID').AsInteger := qryContatoMaster.Fields[0].AsInteger;
    qryContatoEmailDetail.FieldByName('EMAIL').AsString := vEmail.Email;
    qryContatoEmailDetail.FieldByName('TIPO').AsString := vEmail.Tipo;
    I := I + 1;
    qryContatoEmailDetail.Post;
  end;

  FDSchemaAdapter.ApplyUpdates(0);
  FDSchemaAdapter.CommitUpdates;

  qryContatoMaster.Close();
  qryContatoTelefoneDetail.Close();
  qryContatoEmailDetail.Close();

  if Action = 'U' then
    Result := TJSONString.Create('Alterado com sucesso...')
  else
    Result := TJSONString.Create('Incluído com sucesso...');
end;

function TSM.CancelContatos(ContatoID: Integer): TJSONValue;
begin
  qryContatoMaster.Filter   := 'CODIGO = '+ContatoID.ToString;
  qryContatoMaster.Filtered := True;
  qryContatoMaster.Open;
  qryContatoMaster.Delete;
  FDSchemaAdapter.ApplyUpdates(0);
  FDSchemaAdapter.CommitUpdates();
  Result := TJSONString.Create('Excluido com sucesso...');
end;

end.
