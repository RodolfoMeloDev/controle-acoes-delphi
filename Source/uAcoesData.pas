unit uAcoesData;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uConexao, uConstantes, StrUtils;

type
  TAcoesValores = class

  end;

  TAcoesData = class
  private
    qryBD: TFDQuery;
    FAcao: String;
    FNome: String;
    FNomeEmpresa: String;
    FCNPJ: String;
    FDescricao: String;
    FSite: String;
    FLetras: String;

    FPreco: Currency;
    FDY: Double;
    FPL: Double;
    FPVP: Double;
    FMargemEbit: Double;
    FEVEbit: Double;
    FLiquidezDiaria: Currency;
    FVolumeFinanceiro: Currency;
    FValorMercado: Currency;
    FRoic: Currency;

    FTipoAcao: TTipoAcao;
    function BuscaProximaChaveHistorico: Integer;
  protected
    //
  public
    property Acao: String read FAcao write FAcao;
    property Nome: String read FNome write FNome;
    property NomeEmpresa: String read FNomeEmpresa write FNomeEmpresa;
    property CNPJ: String read FCNPJ write FCNPJ;
    property Descricao: String read FDescricao write FDescricao;
    property Site: String read FSite write FSite;
    property TipoAcao: TTipoAcao read FTipoAcao write FTipoAcao;
    property Letras: String read FLetras write FLetras;

    property Preco: Currency read FPreco write FPreco;
    property DY: Double read FDY write FDY;
    property PL: Double read FPL write FPL;
    property PVP: Double read FPVP write FPVP;
    property MargemEbit: Double read FMargemEbit write FMargemEbit;
    property EVEbit: Double read FEVEbit write FEVEbit;
    property LiquidezDiaria: Currency read FLiquidezDiaria write FLiquidezDiaria;
    property VolumeFinanceiro: Currency read FVolumeFinanceiro write FVolumeFinanceiro;
    property ValorMercado: Currency read FValorMercado write FValorMercado;
    property Roic: Currency read FRoic write FRoic;

    function Inserir(var sErro: String): Boolean;
    function InserirDetalhes(pnArquivoImportacaoAcao: Integer; var sErro: String): Boolean;
    function VerificaAcaoCadastrada(psAcao: String): Boolean;
    function RecuperacaoJudicial(psAcao: String; pbTemRecuperacaoJudicial: Boolean): Boolean;
    function AtualizaLetrasAcao(psAcao: String; var sErro: String): Boolean;


    Constructor Create;
    Destructor Destroy; Override;
  end;

const
  qry_Inclusao = 'INSERT INTO dbo.tickers (ticker, nome, empresa, cnpj, descricao, site, tipo, letras) ' + #13 +
                 'VALUES(:ticker, :nome, :empresa, :cnpj, :descricao, :site, :tipo, :letras)';

  qry_Inclusao_Detalhes = 'INSERT INTO dbo.historicosimportacao (historicoimportacao, arquivoimportacao, ticker, precounitario, dividend_yield, preco_por_lucro, preco_por_valor_patrimonial, margem_ebit,' + #13 +
                          '                                      ev_por_ebit, liquidez_media_diaria, volume_financeiro, valor_mercado, roic)' + #13 +
                          'values (:historicoimportacao, :arquivoimportacao, :ticker, :precounitario, :dividend_yield, :preco_por_lucro, :preco_por_valor_patrimonial, :margem_ebit,' + #13 +
                          '		     :ev_por_ebit, :liquidez_media_diaria, :volume_financeiro, :valor_mercado, :roic)';

  qry_Busca_Acao = 'SELECT ticker tipo FROM dbo.tickers where ticker = :ticker';

  qry_BuscaProximaChaveHistorico = 'SELECT coalesce(max(historicoimportacao)+1,1) chave FROM dbo.historicosimportacao';
implementation

{ TAcoesData }

uses uFuncoes;

constructor TAcoesData.Create;
begin
  qryBD := TFDQuery.Create(nil);
  qryBD.Connection := Conexao.oConexao;
end;

destructor TAcoesData.Destroy;
begin
  FreeAndNil(qryBD);
  inherited;
end;

function TAcoesData.Inserir(var sErro: String): Boolean;
begin
  Result := True;
  try
    try
      qryBD.SQL.Text := qry_Inclusao;
      qryBD.ParamByName('ticker').AsString := FAcao;
      qryBD.ParamByName('nome').AsString := FNome;
      qryBD.ParamByName('tipo').AsString := IfThen(FTipoAcao = taAcao, 'A', IfThen(FTipoAcao = taFII, 'F','E'));

      if FNomeEmpresa <> EmptyStr then
        qryBD.ParamByName('empresa').AsString := FNomeEmpresa
      else
      begin
        qryBD.ParamByName('empresa').DataType := ftString;
        qryBD.ParamByName('empresa').Clear;
      end;

      if FCNPJ <> EmptyStr then
        qryBD.ParamByName('cnpj').AsString := FCNPJ
      else
      begin
        qryBD.ParamByName('cnpj').DataType := ftString;
        qryBD.ParamByName('cnpj').Clear;
      end;

      if FDescricao <> EmptyStr then
        qryBD.ParamByName('descricao').AsString := FDescricao
      else
      begin
        qryBD.ParamByName('descricao').DataType := ftString;
        qryBD.ParamByName('descricao').Clear;
      end;

      if FSite <> EmptyStr then
        qryBD.ParamByName('site').AsString := FSite
      else
      begin
        qryBD.ParamByName('site').DataType := ftString;
        qryBD.ParamByName('site').Clear;
      end;

      if FLetras <> EmptyStr then
        qryBD.ParamByName('letras').AsString := FLetras
      else
      begin
        qryBD.ParamByName('letras').DataType := ftString;
        qryBD.ParamByName('letras').Clear;
      end;

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

function TAcoesData.InserirDetalhes(pnArquivoImportacaoAcao: Integer; var sErro: String): Boolean;
var
  nChave: Integer;
begin
  Result := True;
  try
    try
      nChave := BuscaProximaChaveHistorico;
      qryBD.SQL.Text := qry_Inclusao_Detalhes;
      qryBD.ParamByName('historicoimportacao').AsInteger := nChave;
      qryBD.ParamByName('arquivoimportacao').AsInteger := pnArquivoImportacaoAcao;
      qryBD.ParamByName('ticker').AsString := FAcao;
      qryBD.ParamByName('precounitario').AsCurrency := FPreco;
      qryBD.ParamByName('preco_por_lucro').AsCurrency := FPL;
      qryBD.ParamByName('margem_ebit').AsFloat := FMargemEbit;
      qryBD.ParamByName('ev_por_ebit').AsFloat := FEVEbit;
      qryBD.ParamByName('roic').AsFloat := FRoic;

      if FDY <> 0 then
        qryBD.ParamByName('dividend_yield').AsFloat := FDY
      else
      begin
        qryBD.ParamByName('dividend_yield').DataType := ftFloat;
        qryBD.ParamByName('dividend_yield').Clear;
      end;

      if FPVP <> 0 then
        qryBD.ParamByName('preco_por_valor_patrimonial').AsFloat := FPVP
      else
      begin
        qryBD.ParamByName('preco_por_valor_patrimonial').DataType := ftFloat;
        qryBD.ParamByName('preco_por_valor_patrimonial').Clear;
      end;

      if FLiquidezDiaria <> 0 then
        qryBD.ParamByName('liquidez_media_diaria').AsFloat := FLiquidezDiaria
      else
      begin
        qryBD.ParamByName('liquidez_media_diaria').DataType := ftFloat;
        qryBD.ParamByName('liquidez_media_diaria').Clear;
      end;

      if FVolumeFinanceiro <> 0 then
        qryBD.ParamByName('volume_financeiro').AsFloat := FVolumeFinanceiro
      else
      begin
        qryBD.ParamByName('volume_financeiro').DataType := ftFloat;
        qryBD.ParamByName('volume_financeiro').Clear;
      end;

      if FValorMercado <> 0 then
        qryBD.ParamByName('valor_mercado').AsFloat := FValorMercado
      else
      begin
        qryBD.ParamByName('valor_mercado').DataType := ftFloat;
        qryBD.ParamByName('valor_mercado').Clear;
      end;

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

function TAcoesData.RecuperacaoJudicial(psAcao: String; pbTemRecuperacaoJudicial: Boolean): Boolean;
begin
  qryBD.SQL.Text := 'update dbo.tickers set recuperacao_judicial = :recuperacao_judicial where ticker = :ticker';
  try
    try
      qryBD.ParamByName('ticker').AsString := psAcao;
      qryBD.ParamByName('recuperacao_judicial').AsString := Ifthen(pbTemRecuperacaoJudicial, 'S', 'N');
      qryBD.ExecSQL;
      Result := True;
    except
      on e: Exception do
      begin
        Result := False;
      end;
    end;
  finally
    qryBD.Close;
  end;
end;

function TAcoesData.VerificaAcaoCadastrada(psAcao: String): Boolean;
begin
  try
    qryBD.SQL.Text := qry_Busca_Acao;
    qryBD.ParamByName('ticker').AsString := psAcao;
    qryBD.Open;

    Result := not qryBD.IsEmpty;
  finally
    qryBD.Close;
  end;
end;

function TAcoesData.AtualizaLetrasAcao(psAcao: String; var sErro: String): Boolean;
begin
  try
    try
      qryBD.SQL.Text := 'update dbo.tickers set letras = :letras where ticker = :ticker';
      qryBD.ParamByName('letras').AsString := TFuncoes.RetornaLetrasAcao(psAcao);
      qryBD.ParamByName('ticker').AsString := psAcao;
      qryBD.ExecSQL;
      Result := True;
    except
      on e: Exception do
      begin
        Result := False;
        sErro := e.Message;
      end;
    end;
  finally
    qryBD.Close;
  end;
end;

function TAcoesData.BuscaProximaChaveHistorico: Integer;
begin
  try
    qryBD.SQL.Text := qry_BuscaProximaChaveHistorico;
    qryBD.Open;
    Result := qryBD.FieldByName('chave').AsInteger;
  finally
    qryBD.Close;
  end;
end;

end.
