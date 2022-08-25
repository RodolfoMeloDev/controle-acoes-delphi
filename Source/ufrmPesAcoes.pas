unit ufrmPesAcoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ufrmPesquisa, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Vcl.ExtCtrls, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, StrUtils,
  Vcl.Menus, System.UITypes;

type
  TfrmPesAcoes = class(TfrmPesquisa)
    ppmHistorico: TPopupMenu;
    MostraHistricodePreo1: TMenuItem;
    N1: TMenuItem;
    GravarRecuperaoJudicial1: TMenuItem;
    RemoverRecuperaoJudicial1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure spbConsultaClick(Sender: TObject);
    procedure cbbTipoPesquisaChange(Sender: TObject);
    procedure edtPesquisaChange(Sender: TObject);
    procedure MostraHistricodePreo1Click(Sender: TObject);
    procedure GravarRecuperaoJudicial1Click(Sender: TObject);
    procedure RemoverRecuperaoJudicial1Click(Sender: TObject);
    procedure dbPesquisaDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
    function RecuperacaoJudicial(pbRecuperacaoJudicial: Boolean): Boolean;
  public
    { Public declarations }
  end;

const
  const_pesquisa = 'select t.recuperacao_judicial, t.ticker, t.nome, a2."data", h.precounitario, h.dividend_yield, h.preco_por_lucro, h.preco_por_valor_patrimonial,' + #13 +
                   '	   h.margem_ebit, h.ev_por_ebit, h.liquidez_media_diaria, h.volume_financeiro, h.valor_mercado,	t.empresa, t.cnpj, t.descricao, t.site, h.roic' + #13 +
                   'from dbo.tickers t' + #13 +
                   'left join dbo.historicosimportacao h on h.ticker  = t.ticker and' + #13 +
                   '										h.arquivoimportacao = (select max(a.arquivoimportacao) arquivoimportacao from dbo.arquivosimportacao a where a.usuario = :usuario)' + #13 +
                   'left join dbo.arquivosimportacao a2 on a2.arquivoimportacao = h.arquivoimportacao';

var
  frmPesAcoes: TfrmPesAcoes;

implementation

{$R *.dfm}

uses uConstantes, ufrmPrincipal, ufrmPesHistoricoAcoes, uAcoesData;

procedure TfrmPesAcoes.cbbTipoPesquisaChange(Sender: TObject);
begin
//  inherited;
  edtPesquisa.Clear;
  edtPesquisa.SetFocus;

  if cbbTipoPesquisa.ItemIndex = 0 then
    edtPesquisa.MaxLength := 10
  else
    edtPesquisa.MaxLength := 100;
end;

procedure TfrmPesAcoes.dbPesquisaDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  if Column.FieldName = 'recuperacao_judicial' then
  begin
    if (qryConsulta.FieldByName('recuperacao_judicial').AsString = 'S') then
    begin
      dbPesquisa.Canvas.Font.Color := clRed;
      dbPesquisa.Canvas.Brush.Color := clRed;
    end
    else
      dbPesquisa.Canvas.Font.Color := dbPesquisa.Canvas.Brush.Color;

    dbPesquisa.Canvas.FillRect(Rect);
    dbPesquisa.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end
end;

procedure TfrmPesAcoes.edtPesquisaChange(Sender: TObject);
begin
//  inherited;
  FMaximoCaracteres := Length(trim(edtPesquisa.Text)) = edtPesquisa.MaxLength;

  if not Timer1.Enabled then
    Timer1.Enabled := True;
end;

procedure TfrmPesAcoes.FormShow(Sender: TObject);
begin
  inherited;
  spbConsulta.Click;
end;

procedure TfrmPesAcoes.GravarRecuperaoJudicial1Click(Sender: TObject);
begin
  inherited;
  if RecuperacaoJudicial(True) then
    MessageDlg(INCLUIDO_COM_SUCESSO, TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK], 0);
end;

procedure TfrmPesAcoes.MostraHistricodePreo1Click(Sender: TObject);
begin
  inherited;
  Application.CreateForm(TfrmPesHistoricoAcoes, frmPesHistoricoAcoes);
  try
    frmPesHistoricoAcoes.var_CodigoAbertura := qryConsulta.FieldByName('ticker').AsString;
    frmPesHistoricoAcoes.ShowModal
  finally
    FreeAndNil(frmPesHistoricoAcoes);
  end;
end;

function TfrmPesAcoes.RecuperacaoJudicial(pbRecuperacaoJudicial: Boolean): Boolean;
var
  oAcao: TAcoesData;
begin
  oAcao := TAcoesData.Create;
  try
    Result := oAcao.RecuperacaoJudicial(qryConsulta.FieldByName('ticker').AsString, pbRecuperacaoJudicial);
    spbConsulta.Click;
  finally
    FreeAndNil(oAcao);
  end;
end;

procedure TfrmPesAcoes.RemoverRecuperaoJudicial1Click(Sender: TObject);
begin
  inherited;
  if RecuperacaoJudicial(False) then
    MessageDlg(REMOVIDO_COM_SUCESSO, TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK], 0);
end;

procedure TfrmPesAcoes.spbConsultaClick(Sender: TObject);
begin
  inherited;

  case cbbTipoPesquisa.ItemIndex of
    0: // nome
      FFiltros := 'where t.ticker ' + IfThen(FMaximoCaracteres, ' = ' + QuotedStr(trim(edtPesquisa.Text)), ' like ' + QuotedStr('%' + trim(edtPesquisa.Text) + '%'));
    1: // codigo
      FFiltros := 'where UPPER(t.nome) ' + IfThen(FMaximoCaracteres, ' = ' + QuotedStr(trim(edtPesquisa.Text)), ' like ' + QuotedStr('%' + trim(edtPesquisa.Text) + '%'));
  end;

  case cbbStatus.ItemIndex of
    0: // ativo
      FFiltros := FFiltros + #13 + ' and t.tipo = ''A''';
    1: // ativo
      FFiltros := FFiltros + #13 + ' and t.tipo = ''F''';
    2: // inativo
      FFiltros := FFiltros + #13 + ' and t.tipo = ''E''';
  end;

  qryConsulta.SQL.Text := const_pesquisa + #13 + FFiltros + #13 + 'order by t.ticker';
  qryConsulta.ParamByName('usuario').AsInteger := FUsuarioLogado;
  qryConsulta.Open;

  lblTotalRegistros.Caption := TOTAL_REGISTROS + IntToStr(qryConsulta.RecordCount);
end;

end.
