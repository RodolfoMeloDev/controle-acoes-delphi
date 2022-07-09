unit ufrmPesHistoricoAcoes;

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
  TfrmPesHistoricoAcoes = class(TfrmPesquisa)
    edtNomeArqImportado: TEdit;
    Label3: TLabel;
    spbArquivo: TSpeedButton;
    edtArqImportado: TEdit;
    procedure cbbTipoPesquisaChange(Sender: TObject);
    procedure edtPesquisaChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure spbConsultaClick(Sender: TObject);
    procedure edtArqImportadoExit(Sender: TObject);
    procedure spbArquivoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    var_CodigoAbertura: String;
  end;

const
  const_pesquisa ='select a."data", h.ticker, h.precounitario, h.dividend_yield, h.preco_por_lucro, h.preco_por_valor_patrimonial, h.margem_ebit,' + #13 +
                  '	   h.ev_por_ebit, h.liquidez_media_diaria, h.volume_financeiro, h.valor_mercado' + #13 +
                  'from dbo.historicosimportacao h' + #13 +
                  'inner join dbo.tickers t on t.ticker = h.ticker' + #13 +
                  'inner join dbo.arquivosimportacao a on a.arquivoimportacao = h.arquivoimportacao ' + #13 +
                  'where a.usuario = :usuario';

var
  frmPesHistoricoAcoes: TfrmPesHistoricoAcoes;

implementation

{$R *.dfm}

uses ufrmPrincipal, uConstantes, uConexao, ufrmPesImportacoes;

procedure TfrmPesHistoricoAcoes.cbbTipoPesquisaChange(Sender: TObject);
begin
//  inherited;
  edtPesquisa.Clear;
  edtPesquisa.SetFocus;

  if cbbTipoPesquisa.ItemIndex = 0 then
    edtPesquisa.MaxLength := 10
  else
    edtPesquisa.MaxLength := 100;
end;

procedure TfrmPesHistoricoAcoes.edtArqImportadoExit(Sender: TObject);
var
  qryBD: TFDQuery;
begin
  inherited;

  try
    qryBD := TFDQuery.Create(nil);
    qryBD.Connection := Conexao.oConexao;

    if Trim(edtArqImportado.Text) <> EmptyStr then
    begin
      qryBD.SQL.Text := 'select a.arquivoimportacao, a.nome from dbo.arquivosimportacao a where a.arquivoimportacao = ' + Trim(edtArqImportado.Text);
      qryBD.Open;

      if not qryBD.IsEmpty then
      begin
        edtArqImportado.Text := qryBD.FieldByName('arquivoimportacao').AsString;
        edtNomeArqImportado.Text := qryBD.FieldByName('nome').AsString;
      end
      else
      begin
        edtArqImportado.Clear;
        edtNomeArqImportado.Clear;
        edtArqImportado.SetFocus;
        MessageDlg('Registro não encontrado', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
      end;
    end
    else
    begin
      edtArqImportado.Clear;
      edtNomeArqImportado.Clear;
    end;
  finally
    FreeAndNil(qryBD);
    spbConsulta.Click;
  end;
end;

procedure TfrmPesHistoricoAcoes.edtPesquisaChange(Sender: TObject);
begin
//  inherited;
  FMaximoCaracteres := Length(trim(edtPesquisa.Text)) = edtPesquisa.MaxLength;

  if not Timer1.Enabled then
    Timer1.Enabled := True;
end;

procedure TfrmPesHistoricoAcoes.FormShow(Sender: TObject);
begin
  inherited;

  if var_CodigoAbertura <> '' then
  begin
    edtPesquisa.Text := var_CodigoAbertura;
    edtArqImportado.Enabled := False;
    edtPesquisa.Enabled     := False;
    spbArquivo.Enabled      := False;
    spbConsulta.Enabled     := False;
    cbbTipoPesquisa.Enabled := False;
    cbbStatus.Enabled       := False;
  end;

  spbConsulta.Click;
end;

procedure TfrmPesHistoricoAcoes.spbArquivoClick(Sender: TObject);
begin
  inherited;

  Application.CreateForm(TfrmPesImportacoes, frmPesImportacoes);
  try
    frmPesImportacoes.ShowModal;
    edtArqImportadoExit(Self);
  finally
    FreeAndNil(frmPesImportacoes);
  end;
end;

procedure TfrmPesHistoricoAcoes.spbConsultaClick(Sender: TObject);
begin
  inherited;

  case cbbTipoPesquisa.ItemIndex of
    0: // nome
      FFiltros := 'and t.ticker ' + IfThen(FMaximoCaracteres, ' = ' + QuotedStr(trim(edtPesquisa.Text)), ' like ' + QuotedStr('%' + trim(edtPesquisa.Text) + '%'));
    1: // codigo
      FFiltros := 'and UPPER(t.nome) ' + IfThen(FMaximoCaracteres, ' = ' + QuotedStr(trim(edtPesquisa.Text)), ' like ' + QuotedStr('%' + trim(edtPesquisa.Text) + '%'));
  end;

  if Trim(edtArqImportado.Text) <> EmptyStr then
      FFiltros := FFiltros + #13 + ' and h.arquivoimportacao = ' + edtArqImportado.Text;

  case cbbStatus.ItemIndex of
    0: // ativo
      FFiltros := FFiltros + #13 + ' and t.tipo = ''A''';
    1: // ativo
      FFiltros := FFiltros + #13 + ' and t.tipo = ''F''';
    2: // inativo
      FFiltros := FFiltros + #13 + ' and t.tipo = ''E''';
  end;

  qryConsulta.SQL.Text := const_pesquisa + #13 + FFiltros + #13 + 'order by t.ticker, a."data" desc';
  qryConsulta.ParamByName('usuario').AsInteger := FUsuarioLogado;
  qryConsulta.Open;

  lblTotalRegistros.Caption := TOTAL_REGISTROS + IntToStr(qryConsulta.RecordCount);
end;

end.
