unit uConstantes;

interface

const
  TOTAL_REGISTROS = 'Total de Registros: ';

  INCLUIDO_COM_SUCESSO = 'Cadastro realizado com sucesso';
  ALTERADO_COM_SUCESSO = 'Cadastro alterado com sucesso';
  REMOVIDO_COM_SUCESSO = 'Cadastro removido com sucesso';
  SEM_REGISTROS = 'Nenhum registro encontrado';

var
  Layout_StatusInvest: Array of String = ['PRECO', 'DY', 'P/L', 'P/VP', 'MARGEM EBIT', 'EV/EBIT', 'LIQUIDEZ MEDIA DIARIA', 'VALOR DE MERCADO', 'ROIC'];
  Layout_InvestSite: Array of String = ['preço', 'div.yield', 'p/l', 'p/vpa', 'magem ebit', 'ev/ebit', 'volume financ.(r$)', 'market cap(r$)', 'roic'];

type
  TTipoManutencao = (tmInclusao, tmAlteracao, tmVisualizacao, tmExclusao);
  TTipoAcao = (taAcao, taFII, taETF);
  TLayoutArquivo = (tlStatusInvest, tlInvestSite);

implementation

end.
