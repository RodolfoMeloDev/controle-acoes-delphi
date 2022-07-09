unit ufrmProcImpotarDadosAcoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtDlgs, Vcl.ComCtrls,
  Vcl.Buttons, Vcl.Mask, System.UITypes, Vcl.ExtCtrls;

type
  TfrmProcImpotarDadosAcoes = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtNomeArquivo: TEdit;
    Label2: TLabel;
    OpenTextFileDialog1: TOpenTextFileDialog;
    Label3: TLabel;
    edtArquivo: TEdit;
    spbArquivo: TSpeedButton;
    spbImportar: TSpeedButton;
    pbProgresso: TProgressBar;
    edtDataArquivo: TMaskEdit;
    rdgTipoArquivo: TRadioGroup;
    procedure spbImportarClick(Sender: TObject);
    procedure spbArquivoClick(Sender: TObject);
  private
    { Private declarations }
    function ValidaCampos: Boolean;
  public
    { Public declarations }
  end;

var
  frmProcImpotarDadosAcoes: TfrmProcImpotarDadosAcoes;

implementation

{$R *.dfm}

uses uImportarDadosAcoesData, ufrmPrincipal, uConstantes;

{ TfrmProcImpotarDadosAcoes }

procedure TfrmProcImpotarDadosAcoes.spbArquivoClick(Sender: TObject);
begin
  if OpenTextFileDialog1.Execute then
  begin
    if FileExists(OpenTextFileDialog1.FileName) then
      edtArquivo.Text := OpenTextFileDialog1.FileName
    else
      MessageDlg('Arquivo não encontrado.', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
  end;
end;

procedure TfrmProcImpotarDadosAcoes.spbImportarClick(Sender: TObject);
var
  ImportaDados: TImportaDadosAcoesData;
  sErro: String;
  bPodeSobreescrever: Boolean;
begin
  bPodeSobreescrever := False;

  if ValidaCampos then
  begin
    ImportaDados := TImportaDadosAcoesData.Create(pbProgresso);
    try
      if ImportaDados.JaExisteDataImportacao(FUsuarioLogado, StrToDate(edtDataArquivo.Text)) then
      begin
        bPodeSobreescrever := MessageDlg('Já existe um arquivo importado para está data. Deseja sobreescreve-lo?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes;

        if not bPodeSobreescrever then
          Exit;
      end;

      ImportaDados.Usuario := FUsuarioLogado;
      ImportaDados.Nome := Trim(edtNomeArquivo.Text);
      ImportaDados.Data := StrToDate(edtDataArquivo.Text);
      ImportaDados.Arquivo := Trim(edtArquivo.Text);
      ImportaDados.TipoArquivo := rdgTipoArquivo.ItemIndex;
      ImportaDados.Inserir(bPodeSobreescrever, sErro);

      if sErro = EmptyStr then
      begin
        MessageDlg(INCLUIDO_COM_SUCESSO, TMsgDlgType.mtInformation, [mbok], 0);
        edtNomeArquivo.Clear;
        edtDataArquivo.Clear;
        edtArquivo.Clear;
        pbProgresso.Position := 0;
      end
      else
        MessageDlg(sErro, TMsgDlgType.mtError, [mbok], 0);
    finally
      FreeAndNil(ImportaDados);
    end;
  end;
end;

function TfrmProcImpotarDadosAcoes.ValidaCampos: Boolean;
var
  dData: TDateTime;
begin
  Result := False;

  if Trim(edtNomeArquivo.Text) = EmptyStr then
  begin
    MessageDlg('O nome do arquivo é um campo obrigatório', TMsgDlgType.mtInformation, [mbOK], 0);
    edtNomeArquivo.SetFocus;
    Exit;
  end;

  if Trim(StringReplace(edtDataArquivo.Text, '/', '', [rfReplaceAll])) = EmptyStr then
  begin
    MessageDlg('A data é um campo obrigatório', TMsgDlgType.mtInformation, [mbOK], 0);
    edtDataArquivo.SetFocus;
    Exit;
  end;

  if not TryStrToDate(edtDataArquivo.Text, dData) then
  begin
    MessageDlg('A data informada não é válida', TMsgDlgType.mtInformation, [mbOK], 0);
    edtDataArquivo.SetFocus;
    Exit;
  end;

  if Trim(edtArquivo.Text) = EmptyStr then
  begin
    MessageDlg('O arquivo para importação é um campo obrigatório', TMsgDlgType.mtInformation, [mbOK], 0);
    Exit;
  end;

  Result := True;
end;

end.
