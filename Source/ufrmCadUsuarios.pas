unit ufrmCadUsuarios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ufrmCadCadastro, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, System.UITypes,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Math, uCadUsuarioData, StrUtils;

type
  TfrmCadUsuarios = class(TfrmCadCadastro)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtUsuario: TEdit;
    edtLogin: TEdit;
    edtSenha: TEdit;
    edtNomeUsuario: TEdit;
    edtConfirmarSenha: TEdit;
    Label5: TLabel;
    procedure FormShow(Sender: TObject);
    procedure spbGravarClick(Sender: TObject);
    procedure spbCancelarClick(Sender: TObject);
  private
    { Private declarations }
    function ValidaCampos: Boolean;
  public
    { Public declarations }
  end;

var
  frmCadUsuarios: TfrmCadUsuarios;

implementation

uses
  uConstantes;

{$R *.dfm}

{ TfrmCadUsuarios }

procedure TfrmCadUsuarios.FormShow(Sender: TObject);
var
  oUsuario: TUsuario;
begin
  inherited;
  oUsuario := TUsuario.Create(FChave, FSQLOperacacoes);

  try
    if FTipoManutencao = tmAlteracao then
    begin
      oUsuario.BuscaDadosEntidade;

      edtUsuario.Text := IntToStr(oUsuario.Usario);
      edtLogin.Text := oUsuario.Login;
      edtSenha.Text := oUsuario.Senha;
      edtConfirmarSenha.Text := oUsuario.ConfirmarSenha;
      edtNomeUsuario.Text := oUsuario.Nome;
      rdgStatus.ItemIndex := IfThen(oUsuario.Status = 'A', 0, 1);
      edtSenha.SetFocus;
    end
    else
    begin
      edtLogin.Enabled := True;
      rdgStatus.Enabled := False;
      edtUsuario.Text :=  IntToStr(oUsuario.BuscaProximaChave);
      edtLogin.SetFocus;
    end;
  finally
    FreeAndNil(oUsuario);
  end;
end;

procedure TfrmCadUsuarios.spbCancelarClick(Sender: TObject);
begin
  inherited;
  if FTipoManutencao = tmInclusao then
    edtLogin.Clear;

  edtSenha.Clear;
  edtConfirmarSenha.Clear;
  edtNomeUsuario.Clear;
  rdgStatus.ItemIndex := 0;
end;

procedure TfrmCadUsuarios.spbGravarClick(Sender: TObject);
var
  sErro: String;
  oUsuario: TUsuario;
begin
  inherited;
  if ValidaCampos then
  begin
    oUsuario := TUsuario.Create(FChave, FSQLOperacacoes);
    try
      oUsuario.Usario := StrToInt(edtUsuario.Text);
      oUsuario.Login := Trim(edtLogin.Text);
      oUsuario.Senha := Trim(edtSenha.Text);
      oUsuario.Nome := Trim(edtNomeUsuario.Text);
      oUsuario.Status := IfThen(rdgStatus.ItemIndex = 0, 'A', 'I');

      if FTipoManutencao = tmInclusao then
        oUsuario.Inserir(sErro)
      else
        oUsuario.Atualizar(sErro);

      if sErro = EmptyStr then
      begin
        MessageDlg(IfThen(FTipoManutencao = tmInclusao, INCLUIDO_COM_SUCESSO, ALTERADO_COM_SUCESSO ), TMsgDlgType.mtInformation, [mbok], 0);
        frmCadUsuarios.Close;
      end
      else
        MessageDlg(sErro, TMsgDlgType.mtError, [mbok], 0);
    finally
      FreeAndNil(oUsuario)
    end;
  end;
end;

function TfrmCadUsuarios.ValidaCampos: Boolean;
var
  oUsuario: TUsuario;
begin
  Result := False;
  oUsuario := TUsuario.Create(FChave, FSQLOperacacoes);

  try
    if Trim(edtLogin.Text) = EmptyStr then
    begin
      MessageDlg('Login é um campo obrigatório', TMsgDlgType.mtInformation, [mbOK], 0);
      edtLogin.SetFocus;
      Exit;
    end;

    if Trim(edtSenha.Text) = EmptyStr then
    begin
      MessageDlg('Senha é um campo obrigatório', TMsgDlgType.mtInformation, [mbOK], 0);
      edtSenha.SetFocus;
      Exit;
    end;

    if Trim(edtConfirmarSenha.Text) = EmptyStr then
    begin
      MessageDlg('Conirmar Senha é um campo obrigatório', TMsgDlgType.mtInformation, [mbOK], 0);
      edtConfirmarSenha.SetFocus;
      Exit;
    end;

    if Trim(edtNomeUsuario.Text) = EmptyStr then
    begin
      MessageDlg('Nome é um campo obrigatório', TMsgDlgType.mtInformation, [mbOK], 0);
      edtNomeUsuario.SetFocus;
      Exit;
    end;

    if Trim(edtSenha.Text) <> Trim(edtConfirmarSenha.Text) then
    begin
      MessageDlg('As senhas estão diferentes, verifique', TMsgDlgType.mtInformation, [mbOK], 0);
      edtSenha.SetFocus;
      Exit;
    end;

    if (FTipoManutencao = tmInclusao) and oUsuario.ValidaLoginJaExiste(Trim(edtLogin.Text)) then
    begin
      MessageDlg('Este login já é utilizado por outro usuário', TMsgDlgType.mtInformation, [mbOK], 0);
      edtLogin.SetFocus;
      Exit;
    end;

    Result := True;
  finally
    FreeAndNil(oUsuario);
  end;
end;

end.
