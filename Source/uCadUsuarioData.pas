unit uCadUsuarioData;

interface

uses
  System.SysUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uConexao, uConstantes,
  System.Generics.Collections, Math, IdHashMessageDigest;

type
  TUsuario = class
  private
    qryBD: TFDQuery;
    FSQLOperacacoes: TDictionary<TTipoManutencao, String>;
    FUsuario: Integer;
    FLogin: String;
    FSenha: String;
    FConfirmarSenha: String;
    FNome: String;
    FStatus: String;
  protected
    //
  public
    procedure BuscaDadosEntidade;
    function BuscaProximaChave: Integer;
    function ValidaLoginJaExiste(psLogin: String): Boolean;
    function Inserir(var sErro: String): Boolean;
    function Remover(var sErro: String): Boolean;
    function Atualizar(var sErro: String): Boolean;

    property Usario: Integer read FUsuario write FUsuario;
    property Login: String read FLogin write FLogin;
    property Senha: String read FSenha write FSenha;
    property ConfirmarSenha: String read FConfirmarSenha write FConfirmarSenha;
    property Nome: String read FNome write FNome;
    property Status: String read FStatus write FStatus;

    Constructor Create(pnChave: Integer; pnOperacoes: TDictionary<TTipoManutencao, String>);
    Destructor  Destroy; Override;
  end;

implementation

{ TUsuario }

function TUsuario.BuscaProximaChave: Integer;
begin
  try
    qryBD.SQL.Text := 'SELECT coalesce(max(usuario)+1,1) chave FROM dbo.usuarios';
    qryBD.Open;
    Result := qryBD.FieldByName('chave').AsInteger;
  finally
    qryBD.Close;
  end;
end;

constructor TUsuario.Create(pnChave: Integer; pnOperacoes: TDictionary<TTipoManutencao, String>);
begin
  FUsuario := pnChave;
  FSQLOperacacoes := pnOperacoes;

  qryBD := TFDQuery.Create(nil);
  qryBD.Connection := Conexao.oConexao;
end;

destructor TUsuario.Destroy;
begin
  FreeAndNil(qryBD);
  inherited;
end;

function TUsuario.Inserir(var sErro: String): Boolean;
var
  sSQL: String;
  senha: TIdHashMessageDigest5;
begin
  Result := True;
  try
    try
      FSQLOperacacoes.TryGetValue(tmInclusao, sSQL);
      senha := TIdHashMessageDigest5.Create;
      qryBD.SQL.Text := sSQL;
      qryBD.ParamByName('usuario').AsInteger := FUsuario;
      qryBD.ParamByName('login').AsString := FLogin;
      qryBD.ParamByName('senha').AsString := senha.HashStringAsHex(FSenha);
      qryBD.ParamByName('nome').AsString := FNome;
      qryBD.ParamByName('status').AsString := FStatus;
      qryBD.ParamByName('datacriacao').AsDateTime := Now;
      qryBD.ExecSQL;
    except
      on e: Exception do
      begin
        sErro := e.Message;
        Result := False;
      end;
    end;
  finally
    qryBD.Close;
    FreeAndNil(senha);
  end;
end;

function TUsuario.Remover(var sErro: String): Boolean;
var
  sSQL: String;
begin
  Result := True;
  try
    try
      FSQLOperacacoes.TryGetValue(tmExclusao, sSQL);
      qryBD.SQL.Text := sSQL;
      qryBD.ParamByName('usuario').AsInteger := FUsuario;
      qryBD.ExecSQL;
    except
      on e: Exception do
      begin
        sErro := e.Message;
        Result := False;
      end;
    end;
  finally
    qryBD.Close;
  end;
end;

function TUsuario.ValidaLoginJaExiste(psLogin: String): Boolean;
begin
  try
    qryBD.SQL.Text := 'SELECT u.login from dbo.usuarios u where u.login = :login';
    qryBD.ParamByName('login').AsString := psLogin;
    qryBD.Open;
  finally
    Result := not qryBD.IsEmpty;
    qryBD.Close;
  end;
end;

function TUsuario.Atualizar(var sErro: String): Boolean;
var
  sSQL: String;
  senha: TIdHashMessageDigest5;
begin
  Result := True;
  try
    try
      FSQLOperacacoes.TryGetValue(tmAlteracao, sSQL);
      senha := TIdHashMessageDigest5.Create;
      qryBD.SQL.Text := sSQL;
      qryBD.ParamByName('usuario').AsInteger := FUsuario;
      qryBD.ParamByName('senha').AsString := senha.HashStringAsHex(FSenha);
      qryBD.ParamByName('nome').AsString := FNome;
      qryBD.ParamByName('status').AsString := FStatus;
      qryBD.ParamByName('dataalteracao').AsDateTime := Now;
      qryBD.ExecSQL;
    except
      on e: Exception do
      begin
        sErro := e.Message;
        Result := False;
      end;
    end;
  finally
    qryBD.Close;
    FreeAndNil(senha)
  end;
end;

procedure TUsuario.BuscaDadosEntidade;
var
  sSQL: String;
begin
  try
    FSQLOperacacoes.TryGetValue(tmVisualizacao, sSQL);

    qryBD.SQL.Text := sSQL;
    qryBD.ParamByName('usuario').AsInteger := FUsuario;
    qryBD.Open;

    FUsuario := qryBD.FieldByName('usuario').AsInteger;
    FLogin := qryBD.FieldByName('login').AsString;
    FSenha := qryBD.FieldByName('senha').AsString;
    FConfirmarSenha := qryBD.FieldByName('senha').AsString;
    FNome := qryBD.FieldByName('nome').AsString;
    FStatus := qryBD.FieldByName('status').AsString;
  finally
    qryBD.Close;
  end;
end;

end.
