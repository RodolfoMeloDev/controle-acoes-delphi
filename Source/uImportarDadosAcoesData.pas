unit uImportarDadosAcoesData;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uConexao, uAcoesData,
  REST.Client, REST.Response.Adapter, Data.DBJson, Vcl.ComCtrls, Vcl.StdCtrls,
  System.RegularExpressions, uConstantes, System.Generics.Collections;

type
  TImportaDadosAcoesData = class
  private
    qryBD: TFDQuery;
    FArquivoImportacaoAcao: Integer;
    FUsuario: Integer;
    FNome: String;
    FData: TDate;
    FArquivo: String;
    FTipoArquivo: Integer;
    FTotalRegistros: Integer;

    oProgressbar: TProgressBar;

    FChaveAPI1: String;
    FChaveAPI2: String;
    FChaveAPI3: String;
    FChavePrincipal: String;

    FPosicaoColunas: TDictionary<String, Integer>;

    function BuscaProximaChave: Integer;
    function PegaCodigoDataImportacao(pnUsuario: Integer; pdData: TDate): Integer;
    procedure BuscaDadosAcaoWebService(var poAcao: TAcoesData);
    procedure PreencheDadosComplementaresAcao(var poAcao: TAcoesData; psLinha: String; poLayout: TLayoutArquivo);
    function ValidaLayout(psLinha: String; out poLayout: TLayoutArquivo): Boolean;
  protected
    //
  public
    function JaExisteDataImportacao(pnUsuario: Integer; pdData: TDate): Boolean;
    function Inserir(pbPodeSobreescrever: Boolean; var sErro: String): Boolean;
    function Remover(var sErro: String): Boolean;

    property ArquivoImportacaoAcao: Integer read FArquivoImportacaoAcao write FArquivoImportacaoAcao;
    property Usuario: Integer read FUsuario write FUsuario;
    property Nome: String read FNome write FNome;
    property Data: TDate read FData write FData;
    property Arquivo: String read FArquivo write FArquivo;
    property TipoArquivo: Integer read FTipoArquivo write FTipoArquivo;

    Constructor Create(var poProgressBar: TProgressBar); overload;
    Constructor Create(pnChave: Integer); overload;
    Destructor Destroy; Override;
  end;

const
  qry_BuscaProximaChave = 'SELECT coalesce(max(arquivoimportacao)+1,1) chave FROM dbo.arquivosimportacao';

  qry_Busca_Arquivo_Importacao = 'SELECT arquivoimportacao FROM dbo.arquivosimportacao where usuario = :usuario and "data" = :data';

  qry_Inclusao = 'INSERT INTO dbo.arquivosimportacao (arquivoimportacao, usuario, nome, "data", arquivo)' + #13 +
                 'VALUES(:arquivoimportacao, :usuario, :nome, :data, :arquivo)';

  qry_Excluisao = 'delete from dbo.arquivosimportacao a where a.arquivoimportacao = :arquivoimportacao';

  qry_Exclui_Historico = 'delete from dbo.historicosimportacao where arquivoimportacao = :arquivoimportacao';

implementation

{ TImportaDadosAcoesData }

uses uFuncoes;

constructor TImportaDadosAcoesData.Create(var poProgressBar: TProgressBar);
begin
  // Site: https://hgbrasil.com/status/finance
  // URL Base - API: https://api.hgbrasil.com/finance/
  // Chaves da API cadastradas
  FChaveAPI1 := 'a8c7fddb';
  FChaveAPI2 := 'a54094ef';
  FChaveAPI3 := 'a3b393cd';
  FChavePrincipal := FChaveAPI1;

  FPosicaoColunas := TDictionary<String, Integer>.Create;

  qryBD := TFDQuery.Create(nil);
  qryBD.Connection := Conexao.oConexao;

  oProgressbar := poProgressBar;

  FArquivoImportacaoAcao := BuscaProximaChave;
end;

destructor TImportaDadosAcoesData.Destroy;
begin
  FreeAndNil(FPosicaoColunas);
  FreeAndNil(qryBD);
  inherited;
end;

function TImportaDadosAcoesData.Inserir(pbPodeSobreescrever: Boolean; var sErro: String): Boolean;
var
  oStream: TFileStream;
  Acoes: TAcoesData;
  oArquivo: TextFile;
  sLinha: String;
  oLayout: TLayoutArquivo;
begin
  Result := True;
  try
    try
      if not Conexao.oConexao.InTransaction then
        Conexao.oConexao.StartTransaction;

      if not pbPodeSobreescrever then
      begin
        oStream := TFileStream.Create(FArquivo, fmOpenRead);

        qryBD.SQL.Text := qry_Inclusao;
        qryBD.ParamByName('arquivoimportacao').AsInteger := FArquivoImportacaoAcao;
        qryBD.ParamByName('usuario').AsInteger := FUsuario;
        qryBD.ParamByName('nome').AsString := FNome;
        qryBD.ParamByName('data').AsDate := FData;
        qryBD.ParamByName('arquivo').DataType := ftStream;
        qryBD.ParamByName('arquivo').StreamMode := smOpenWrite;
        qryBD.ExecSQL;
        try
          qryBD.ParamByName('arquivo').AsStream.CopyFrom(oStream, -1);
        finally
          FreeAndNil(oStream);
        end;
        qryBD.CloseStreams;
      end
      else
      begin
        FArquivoImportacaoAcao := PegaCodigoDataImportacao(FUsuario, FData);
        qryBD.SQL.Text := qry_Exclui_Historico;
        qryBD.ParamByName('arquivoimportacao').AsInteger := FArquivoImportacaoAcao;
        qryBD.ExecSQL;
      end;

      try
        AssignFile(oArquivo, FArquivo);
        Reset(oArquivo);

        // pega o total de linhas
        while not EOF(oArquivo) do
        begin
          inc(FTotalRegistros);
          Readln(oArquivo, sLinha);
        end;

        oProgressbar.Max := FTotalRegistros -1;
        oProgressbar.Position := 0;

        // reinicia o arquivo
        Reset(oArquivo);
        //Cabeçalho
        Readln(oArquivo, sLinha);

        if not ValidaLayout(sLinha, oLayout) then
        begin
          sErro := 'Layout do arquivo inválido';
          Result := False;

          if Conexao.oConexao.InTransaction then
            Conexao.oConexao.Rollback;

          Exit;
        end;

        while not EOF(oArquivo) do
        begin
          oProgressbar.Position := oProgressbar.Position + 1;
          Readln(oArquivo, sLinha);

          Acoes := TAcoesData.Create;

          Acoes.Acao := Copy(sLinha, 1, Pos(';', sLinha)-1);

          if Acoes.Acao <> EmptyStr then
          begin
            if not Acoes.VerificaAcaoCadastrada(Acoes.Acao) then
            begin
              BuscaDadosAcaoWebService(Acoes);
              acoes.TipoAcao := TTipoAcao(FTipoArquivo);
              Acoes.Letras := TFuncoes.RetornaLetrasAcao(Acoes.Acao);
              Acoes.Inserir(sErro);
            end;

            PreencheDadosComplementaresAcao(Acoes, sLinha, oLayout);
            Acoes.InserirDetalhes(FArquivoImportacaoAcao, sErro);
          end;

          FreeAndNil(Acoes);
        end;
      finally
        CloseFile(oArquivo);
      end;

      if sErro = EmptyStr then
        Conexao.oConexao.Commit
      else
      begin
        if Conexao.oConexao.InTransaction then
          Conexao.oConexao.Rollback;
      end;
    except
      on e: Exception do
      begin
        sErro := e.Message;
        Result := False;
        qryBD.CloseStreams;

        if Conexao.oConexao.InTransaction then
          Conexao.oConexao.Rollback;

        if not Assigned(oStream) then
          FreeAndNil(oStream);
      end;
    end;
  finally
    qryBD.Close;

    if not Assigned(oStream) then
      FreeAndNil(oStream);
  end;
end;

function TImportaDadosAcoesData.JaExisteDataImportacao(pnUsuario: Integer; pdData: TDate): Boolean;
begin
  try
    qryBD.SQL.Text := qry_Busca_Arquivo_Importacao;
    qryBD.ParamByName('usuario').AsInteger := pnUsuario;
    qryBD.ParamByName('data').AsDate := pdData;
    qryBD.Open;
    Result := not qryBD.IsEmpty;
  finally
    qryBD.Close;
  end;
end;

function TImportaDadosAcoesData.PegaCodigoDataImportacao(pnUsuario: Integer; pdData: TDate): Integer;
begin
  try
    qryBD.SQL.Text := qry_Busca_Arquivo_Importacao;
    qryBD.ParamByName('usuario').AsInteger := pnUsuario;
    qryBD.ParamByName('data').AsDate := pdData;
    qryBD.Open;
    Result := qryBD.FieldByName('arquivoimportacao').AsInteger;
  finally
    qryBD.Close;
  end;
end;

procedure TImportaDadosAcoesData.PreencheDadosComplementaresAcao(var poAcao: TAcoesData; psLinha: String; poLayout: TLayoutArquivo);
var
  Linha: TStringList;
begin
  try
    psLinha := StringReplace(psLinha, '.', '', [rfReplaceAll]);
    psLinha := StringReplace(psLinha, '%', '', [rfReplaceAll]);
    psLinha := StringReplace(psLinha, 'NA', '', [rfReplaceAll]);
    psLinha := StringReplace(psLinha, ';', #13, [rfReplaceAll]);

    Linha := TStringList.Create;
    Linha.Text := psLinha;

    for var coluna in FPosicaoColunas do
    begin
      if coluna.Value <= (Linha.Count - 1) then
      begin
        if (coluna.Key = 'PRECO') or (coluna.Key = 'preço') then
          poAcao.Preco := StrToCurrDef(Linha[coluna.Value], 0)
        else
        if ((coluna.Key = 'DY') or (coluna.Key = 'div.yield')) and (Trim(Linha[coluna.Value]) <> EmptyStr) then
          poAcao.DY := StrToFloat(Linha[coluna.Value])
        else
        if (coluna.Key = 'P/L') or (coluna.Key = 'p/l') then
          poAcao.PL := StrToFloatDef(Linha[coluna.Value], 0)
        else
        if ((coluna.Key = 'P/VP') or (coluna.Key = 'p/vpa')) and (Trim(Linha[coluna.Value]) <> EmptyStr) then
          poAcao.PVP := StrToFloat(Linha[coluna.Value])
        else
        if (coluna.Key = 'MARGEM EBIT') or (coluna.Key = 'magem ebit') then
          poAcao.MargemEbit := StrToFloatDef(Linha[coluna.Value], 0)
        else
        if (coluna.Key = 'EV/EBIT') or (coluna.Key = 'ev/ebit') then
          poAcao.EVEbit := StrToFloatDef(Linha[coluna.Value], 0)
        else
        if ((coluna.Key = 'LIQUIDEZ MEDIA DIARIA')) and (Trim(Linha[coluna.Value]) <> EmptyStr) then
          poAcao.LiquidezDiaria := StrToCurr(Linha[coluna.Value])
        else
        if ((coluna.Key = 'volume financ.(r$)')) and (Trim(Linha[coluna.Value]) <> EmptyStr) then
          poAcao.VolumeFinanceiro := StrToCurr(Linha[coluna.Value])
        else
        if ((coluna.Key = 'VALOR DE MERCADO') or (coluna.Key = 'market cap(r$)')) and (Trim(Linha[coluna.Value]) <> EmptyStr) then
          poAcao.ValorMercado := StrToCurr(Linha[coluna.Value])
        else
        if (coluna.Key = 'ROIC') and (Trim(Linha[coluna.Value]) <> EmptyStr) then
          poAcao.Roic := StrToCurrDef(Linha[coluna.Value], 0);
      end;
    end;
  finally
    FreeAndNil(Linha)
  end;
end;

function TImportaDadosAcoesData.Remover(var sErro: String): Boolean;
begin
  Result := True;
  try
    try
      if not Conexao.oConexao.InTransaction then
        Conexao.oConexao.StartTransaction;

        qryBD.SQL.Text := qry_Exclui_Historico;
        qryBD.ParamByName('arquivoimportacao').AsInteger := FArquivoImportacaoAcao;
        qryBD.ExecSQL;

        qryBD.SQL.Text := qry_Excluisao;
        qryBD.ParamByName('arquivoimportacao').AsInteger := FArquivoImportacaoAcao;
        qryBD.ExecSQL;

      if sErro = EmptyStr then
        Conexao.oConexao.Commit
      else
      begin
        if Conexao.oConexao.InTransaction then
          Conexao.oConexao.Rollback;
      end;
    except
      on e: Exception do
      begin
        sErro := e.Message;
        Result := False;

        if Conexao.oConexao.InTransaction then
          Conexao.oConexao.Rollback;
      end;
    end;
  finally
    qryBD.Close;
  end;
end;

function TImportaDadosAcoesData.ValidaLayout(psLinha: String; out poLayout: TLayoutArquivo): Boolean;
var
  var_i, var_j: Integer;
  Colunas: TStringList;
begin
  Result := False;

  try
    Colunas := TStringList.Create;
    Colunas.Text := StringReplace(UpperCase(psLinha), ';', #13, [rfReplaceAll]);

    // Percorre as colunas definidas para o layout
    for var_i := 0 to High(Layout_StatusInvest) do
    begin
      // compara com as colunas que vieram no arquivo
      for var_j := 0 to Pred(Colunas.Count) do
      begin
        if Trim(Colunas[var_j]) = Layout_StatusInvest[var_i] then
        begin
          FPosicaoColunas.Add(Trim(Colunas[var_j]), var_j);
          Result := True;
          Break;
        end;
      end;
      // se não encontrou a coluna, não é o layout correto
      if not Result then
        Break;
    end;

    if Result then
      poLayout := tlStatusInvest
    else
    begin
      Colunas.Text := LowerCase(Colunas.Text);
      // Percorre as colunas definidas para o layout
      for var_i := 0 to High(Layout_InvestSite) do
      begin
        // compara com as colunas que vieram no arquivo
        for var_j := 0 to Pred(Colunas.Count) do
        begin
          if Trim(Colunas[var_j]) = Layout_InvestSite[var_i] then
          begin
            FPosicaoColunas.Add(Trim(Colunas[var_j]), var_j);
            Result := True;
            Break;
          end;
        end;
        // se não encontrou a coluna, não é o layout correto
        if not Result then
          Break;
      end;

      if Result then
        poLayout := tlInvestSite;
    end;
  finally
    FreeAndNil(Colunas);
  end;
end;

procedure TImportaDadosAcoesData.BuscaDadosAcaoWebService(var poAcao: TAcoesData);

  procedure InsereDetalhesAcao(var poMemTable: TFDMemTable);
  begin
    if poMemTable.FindField('results.' + poAcao.Acao +'.error') <> nil then
      poAcao.Nome := poAcao.Acao
    else
    begin
      poAcao.Nome := poMemTable.FieldByName('results.' + poAcao.Acao +'.name').AsString;
      poAcao.NomeEmpresa := poMemTable.FieldByName('results.'+ poAcao.Acao +'.company_name').AsString;
      poAcao.CNPJ := poMemTable.FieldByName('results.'+ poAcao.Acao +'.document').AsString;
      poAcao.Descricao := poMemTable.FieldByName('results.'+ poAcao.Acao +'.description').AsString;
      poAcao.Site := poMemTable.FieldByName('results.'+ poAcao.Acao +'.website').AsString;
    end;
  end;

var
  oClient: TRESTClient;
  oRequest: TRESTRequest;
  oResponse: TRESTResponse;
  oAdapterResponse: TRESTResponseDataSetAdapter;
  oMemTable: TFDMemTable;
begin
  try
    try
      // cria componentes
      oClient := TRESTClient.Create('https://api.hgbrasil.com/finance/stock_price?');
      oResponse := TRESTResponse.Create(nil);
      oRequest := TRESTRequest.Create(nil);
      oMemTable := TFDMemTable.Create(nil);
      oAdapterResponse := TRESTResponseDataSetAdapter.Create(nil);

      // seta os parametros
      oResponse.ContentType :=  'application/json';
      oRequest.Client := oClient;
      oRequest.Response := oResponse;
      oRequest.Params.AddItem('key', FChavePrincipal);
      oRequest.Params.AddItem('symbol', poAcao.Acao);
      oAdapterResponse.Response := oResponse;
      oAdapterResponse.NestedElements := True;
      oAdapterResponse.TypesMode := TJSONTypesMode.JSONOnly;
      oAdapterResponse.Active := True;
      oAdapterResponse.Dataset := oMemTable;
      oAdapterResponse.Active := True;

      // realiza a chamada da requisicao
      oRequest.Execute;

      if oResponse.StatusCode = 200 then
        InsereDetalhesAcao(oMemTable)
      // bloqueio por requisiões realizadas
      else if oResponse.StatusCode = 403 then
      begin
        // exclui a chave para adicionar a nova para realizar as outras requisições
        oRequest.Params.Delete('key');

        // seta a chave alternativa
        if FChavePrincipal = FChaveAPI1 then
          FChavePrincipal := FChaveAPI2
        else
        if FChavePrincipal = FChaveAPI2 then
          FChavePrincipal := FChaveAPI3;

        // adiciona o novo parametro
        oRequest.Params.AddItem('key', FChavePrincipal);
        // executa a requisição novamente com a nova chave
        oRequest.Execute;

        // caso feita a requisição com sucesso segue a mesma linha de informações
        if oResponse.StatusCode = 200 then
          InsereDetalhesAcao(oMemTable)
        // caso de erro não força uma 3 tentativa, somente passa o nome para a ação
        else
          poAcao.Nome := poAcao.Acao;
      end
      else
        poAcao.Nome := poAcao.Acao;
    except
      on e:Exception do
      begin
        poAcao.Nome := poAcao.Acao;
      end;
    end;
  finally
    FreeAndNil(oClient);
    FreeAndNil(oResponse);
    FreeAndNil(oRequest);
    FreeAndNil(oMemTable);
    FreeAndNil(oAdapterResponse);
  end;
end;

function TImportaDadosAcoesData.BuscaProximaChave: Integer;
begin
  try
    qryBD.SQL.Text := qry_BuscaProximaChave;
    qryBD.Open;
    Result := qryBD.FieldByName('chave').AsInteger;
  finally
    qryBD.Close;
  end;
end;

constructor TImportaDadosAcoesData.Create(pnChave: Integer);
begin
  FArquivoImportacaoAcao := pnChave;

  qryBD := TFDQuery.Create(nil);
  qryBD.Connection := Conexao.oConexao;
end;

end.
