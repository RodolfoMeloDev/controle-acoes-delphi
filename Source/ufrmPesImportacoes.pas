unit ufrmPesImportacoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ufrmPesquisa, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Vcl.ExtCtrls, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, StrUtils,
  System.UITypes;

type
  TfrmPesImportacoes = class(TfrmPesquisa)
    procedure spbIncluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure spbConsultaClick(Sender: TObject);
    procedure dbPesquisaDblClick(Sender: TObject);
    procedure spbExcluirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  const_pesquisa = 'select a.arquivoimportacao, a.nome, a."data" from dbo.arquivosimportacao a where a.usuario = :usuario';

  const_exclusao =  'delete from dbo.arquivosimportacao a where a.arquivoimportacao = :arquivoimportacao';

  const_exclusao_itens = 'delete from dbo.historicosimportacao h where h.arquivoimportacao = :arquivoimportacao';

var
  frmPesImportacoes: TfrmPesImportacoes;

implementation

{$R *.dfm}

uses ufrmProcImpotarDadosAcoes, uConstantes, ufrmPrincipal,
  ufrmPesHistoricoAcoes, uImportarDadosAcoesData;

procedure TfrmPesImportacoes.dbPesquisaDblClick(Sender: TObject);
begin
  inherited;
  if frmPesHistoricoAcoes <> nil then
  begin
    frmPesHistoricoAcoes.edtArqImportado.Text := qryConsulta.FieldByName('arquivoimportacao').AsString;
    Self.Close;
  end;
end;

procedure TfrmPesImportacoes.FormShow(Sender: TObject);
begin
  inherited;
  spbConsulta.Click;
end;

procedure TfrmPesImportacoes.spbConsultaClick(Sender: TObject);
begin
  inherited;
  case cbbTipoPesquisa.ItemIndex of
    0: // nome
      FFiltros := 'and a.nome ' + IfThen(FMaximoCaracteres, ' = ' + QuotedStr(trim(edtPesquisa.Text)), ' like ' + QuotedStr('%' + trim(edtPesquisa.Text) + '%'));
    1: // login
      FFiltros := 'and a.arquivoimportacao = ' + edtPesquisa.Text;
  end;

  qryConsulta.SQL.Text := const_pesquisa + #13 + FFiltros + #13 + 'order by a."data" desc';
  qryConsulta.ParamByName('usuario').AsInteger := FUsuarioLogado;
  qryConsulta.Open;

  lblTotalRegistros.Caption := TOTAL_REGISTROS + IntToStr(qryConsulta.RecordCount);
end;

procedure TfrmPesImportacoes.spbExcluirClick(Sender: TObject);
var
  oDadosImportados: TImportaDadosAcoesData;
  sErro: String;
begin
  inherited;
  if not FPodeExcluir then
    exit
  else if MessageDlg('Confirma a exclusão deste registro?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],0) = mrNo then
    exit;

  oDadosImportados := TImportaDadosAcoesData.Create(qryConsulta.FieldByName('arquivoimportacao').AsInteger);
  try
    oDadosImportados.Remover(sErro);
    if sErro = EmptyStr then
    begin
      MessageDlg(REMOVIDO_COM_SUCESSO, TMsgDlgType.mtInformation, [mbok], 0);
      spbConsulta.Click;
    end
    else
      MessageDlg(sErro, TMsgDlgType.mtError, [mbok], 0);
  finally
    FreeAndNil(oDadosImportados)
  end;
end;

procedure TfrmPesImportacoes.spbIncluirClick(Sender: TObject);
begin
  inherited;

  Application.CreateForm(TfrmProcImpotarDadosAcoes, frmProcImpotarDadosAcoes);
  try
    frmProcImpotarDadosAcoes.ShowModal;
    spbConsulta.Click;
  finally
    FreeAndNil(frmProcImpotarDadosAcoes);
  end;
end;

end.
