unit ufrmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, System.UITypes,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.VCLUI.Wait;

type
  TfrmLogin = class(TForm)
    Label1: TLabel;
    edtLogin: TEdit;
    Label2: TLabel;
    edtSenha: TEdit;
    btnEntrar: TSpeedButton;
    btnSair: TSpeedButton;
    procedure btnSairClick(Sender: TObject);
    procedure btnEntrarClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    function ValidaLoginSenha: Boolean;
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

uses uConexao, IdHashMessageDigest, ufrmPrincipal;

{ TfrmLogin }

procedure TfrmLogin.btnEntrarClick(Sender: TObject);
var
  qryLogin: TFDQuery;
  senha: TIdHashMessageDigest5;
begin
  if ValidaLoginSenha then
  begin
    senha := TIdHashMessageDigest5.Create;
    qryLogin := TFDQuery.Create(nil);
    try
      qryLogin.Connection := Conexao.oConexao;
      qryLogin.sql.Text := 'SELECT * FROM dbo.usuarios u where u.login = :LOGIN and u.senha = :SENHA';
      qryLogin.ParamByName('LOGIN').AsString := Trim(edtLogin.Text);
      qryLogin.ParamByName('SENHA').AsString := senha.HashStringAsHex(Trim(edtSenha.Text));
      qryLogin.Open;

      if qryLogin.IsEmpty then
      begin
        MessageDlg('Usuário ou Senha inválidos', TMsgDlgType.mtInformation, [mbOK], 0);
        edtSenha.SetFocus;
        Exit;
      end
      else
      begin
        FUsuarioLogado := qryLogin.FieldByName('USUARIO').AsInteger;
        self.Close;
      end;
    finally
      FreeAndNil(qryLogin);
      FreeAndNil(senha);
    end;
  end;
end;

procedure TfrmLogin.btnSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and edtLogin.Focused and (edtSenha.Text = EmptyStr) then
    edtSenha.SetFocus
  else if (Key = #13) and edtSenha.Focused and (edtLogin.Text = EmptyStr) then
    edtLogin.SetFocus;

  if (Key = #13) and (edtLogin.Text <> EmptyStr) and (edtSenha.Text <> EmptyStr) then
    btnEntrar.Click;
end;

function TfrmLogin.ValidaLoginSenha: Boolean;
begin
  Result := False;

  if edtLogin.Text = EmptyStr then
  begin
    MessageDlg('Informe o Login', TMsgDlgType.mtInformation, [mbOK], 0);
    Exit;
  end;

  if edtSenha.Text = EmptyStr then
  begin
    MessageDlg('Informe a Senha', TMsgDlgType.mtInformation, [mbOK], 0);
    Exit
  end;

  Result := True;
end;

end.
