program ControleAcoes;

uses
  Vcl.Forms,
  ufrmPrincipal in 'ufrmPrincipal.pas' {frmPrincipal},
  uConexao in 'DataModule\uConexao.pas' {Conexao: TDataModule},
  ufrmLogin in 'ufrmLogin.pas' {frmLogin},
  ufrmPesquisa in 'ufrmPesquisa.pas' {frmPesquisa},
  ufrmPesUsuarios in 'ufrmPesUsuarios.pas' {frmPesUsuarios},
  uConstantes in 'uConstantes.pas',
  ufrmCadCadastro in 'ufrmCadCadastro.pas' {frmCadCadastro},
  ufrmCadUsuarios in 'ufrmCadUsuarios.pas' {frmCadUsuarios},
  uCadUsuarioData in 'uCadUsuarioData.pas',
  ufrmPesAcoes in 'ufrmPesAcoes.pas' {frmPesAcoes},
  ufrmPesHistoricoAcoes in 'ufrmPesHistoricoAcoes.pas' {frmPesHistoricoAcoes},
  ufrmProcAnaliseAcoes in 'ufrmProcAnaliseAcoes.pas' {frmProcAnaliseAcoes},
  ufrmProcImpotarDadosAcoes in 'ufrmProcImpotarDadosAcoes.pas' {frmProcImpotarDadosAcoes},
  uImportarDadosAcoesData in 'uImportarDadosAcoesData.pas',
  uAcoesData in 'uAcoesData.pas',
  ufrmPesImportacoes in 'ufrmPesImportacoes.pas' {frmPesImportacoes},
  uFuncoes in 'uFuncoes.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TConexao, Conexao);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
