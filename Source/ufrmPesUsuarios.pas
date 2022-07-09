unit ufrmPesUsuarios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ufrmPesquisa, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, StrUtils, Vcl.ExtCtrls,
  System.Generics.Collections, uConstantes, System.UITypes;

type
  TfrmPesUsuarios = class(TfrmPesquisa)
    procedure FormShow(Sender: TObject);
    procedure spbConsultaClick(Sender: TObject);
    procedure spbIncluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure spbAlterarClick(Sender: TObject);
    procedure spbExcluirClick(Sender: TObject);
  private
    { Private declarations }
    FSQLs: TDictionary<TTipoManutencao, String>;
    procedure CriaCadastroUsuario(poTipoManutencao: TTipoManutencao);
  public
    { Public declarations }
  end;

const
  const_pesquisa = 'select u.usuario, u.login, u.nome, u.status, u.datacriacao, u.dataalteracao from dbo.usuarios u';

  const_inclusao = 'INSERT INTO dbo.usuarios (usuario, login, senha, nome, status, datacriacao)' + #13 +
                   'VALUES(:usuario, :login, :senha, :nome, :status, :datacriacao)';

  const_alteracao = 'UPDATE dbo.usuarios SET ' + #13 +
                    '	senha = :senha,' + #13 +
                    '	nome = :nome,' + #13 +
                    '	status = :status,' + #13 +
                    '	dataalteracao= :dataalteracao' + #13 +
                    'WHERE usuario = :usuario';

  const_exclusao = 'DELETE FROM dbo.usuarios' + #13 +
                   'WHERE usuario = :usuario';

  const_visualizacao = 'SELECT usuario, login, senha, nome, status, datacriacao, dataalteracao' + #13 +
                       'FROM dbo.usuarios'+ #13 +
                       'where usuario = :usuario';

var
  frmPesUsuarios: TfrmPesUsuarios;

implementation

{$R *.dfm}

uses ufrmCadUsuarios, uCadUsuarioData;

procedure TfrmPesUsuarios.CriaCadastroUsuario(poTipoManutencao: TTipoManutencao);
begin
  Application.CreateForm(TfrmCadUsuarios, frmCadUsuarios);
  try
    frmCadUsuarios.Inicilizar('Cadastro de Usuários',
                              poTipoManutencao,
                              FSQLs,
                              qryConsulta.FieldByName('usuario').AsInteger);
  finally
    FreeAndNil(frmCadUsuarios);
  end;
end;

procedure TfrmPesUsuarios.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(FSQLs);
end;

procedure TfrmPesUsuarios.FormCreate(Sender: TObject);
begin
  inherited;
  FSQLs := TDictionary<TTipoManutencao, String>.Create;

  FSQLs.Add(tmInclusao, const_inclusao);
  FSQLs.Add(tmAlteracao, const_alteracao);
  FSQLs.Add(tmExclusao, const_exclusao);
  FSQLs.Add(tmVisualizacao, const_visualizacao);

end;

procedure TfrmPesUsuarios.FormShow(Sender: TObject);
begin
  inherited;
  spbConsulta.Click;
end;

procedure TfrmPesUsuarios.spbAlterarClick(Sender: TObject);
begin
  inherited;
  if not qryConsulta.IsEmpty then
  begin
    CriaCadastroUsuario(tmAlteracao);
    spbConsulta.Click;
  end;
end;

procedure TfrmPesUsuarios.spbConsultaClick(Sender: TObject);
begin
  inherited;

  case cbbTipoPesquisa.ItemIndex of
    0: // nome
      FFiltros := 'where u.nome ' + IfThen(FMaximoCaracteres, ' = ' + QuotedStr(trim(edtPesquisa.Text)), ' like ' + QuotedStr('%' + trim(edtPesquisa.Text) + '%'));
    1: // codigo
      FFiltros := 'where u.usuario = ' + trim(edtPesquisa.Text);
    2: // login
      FFiltros := 'where u.login = ' + QuotedStr(trim(edtPesquisa.Text));
  end;

  case cbbStatus.ItemIndex of
    1: // ativo
      FFiltros := FFiltros + #13 + ' and u.status = ''A''';
    2: // inativo
      FFiltros := FFiltros + #13 + ' and u.status = ''I''';
  end;

  qryConsulta.SQL.Text := const_pesquisa + #13 + FFiltros + #13 + 'order by u.nome';
  qryConsulta.Open;

  lblTotalRegistros.Caption := TOTAL_REGISTROS + IntToStr(qryConsulta.RecordCount);
end;

procedure TfrmPesUsuarios.spbExcluirClick(Sender: TObject);
var
  oUsuario: TUsuario;
  sErro: String;
begin
  inherited;
  if not FPodeExcluir then
    exit
  else if MessageDlg('Confirma a exclusão deste registro?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],0) = mrNo then
    exit;

  oUsuario := TUsuario.Create(qryConsulta.FieldByName('usuario').AsInteger, FSQLs);
  try
    oUsuario.Remover(sErro);
    if sErro = EmptyStr then
    begin
      MessageDlg(REMOVIDO_COM_SUCESSO, TMsgDlgType.mtInformation, [mbok], 0);
      spbConsulta.Click;
    end
    else
      MessageDlg(sErro, TMsgDlgType.mtError, [mbok], 0);
  finally
    FreeAndNil(oUsuario)
  end;
end;

procedure TfrmPesUsuarios.spbIncluirClick(Sender: TObject);
begin
  inherited;
  CriaCadastroUsuario(tmInclusao);
  spbConsulta.Click;
end;

end.
