unit ufrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.jpeg;

type
  TfrmPrincipal = class(TForm)
    pnlMenu: TPanel;
    spbUsuarios: TSpeedButton;
    spbAcoes: TSpeedButton;
    spbHistoricoAcoes: TSpeedButton;
    spbAnaliseAcoes: TSpeedButton;
    spbRelatorioAnalise: TSpeedButton;
    imgFundoTela: TImage;
    spbImportarDadosAcoes: TSpeedButton;
    procedure spbUsuariosClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure spbImportarDadosAcoesClick(Sender: TObject);
    procedure spbAcoesClick(Sender: TObject);
    procedure spbHistoricoAcoesClick(Sender: TObject);
    procedure spbAnaliseAcoesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  FUsuarioLogado: Integer;
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses ufrmLogin, ufrmPesUsuarios, ufrmPesAcoes,
  ufrmPesHistoricoAcoes, ufrmPesImportacoes, ufrmProcAnaliseAcoes;

procedure TfrmPrincipal.spbUsuariosClick(Sender: TObject);
begin
  Application.CreateForm(TfrmPesUsuarios, frmPesUsuarios);
  try
    frmPesUsuarios.ShowModal
  finally
    FreeAndNil(frmPesUsuarios);
  end;
end;

procedure TfrmPrincipal.spbAcoesClick(Sender: TObject);
begin
  Application.CreateForm(TfrmPesAcoes, frmPesAcoes);
  try
    frmPesAcoes.ShowModal
  finally
    FreeAndNil(frmPesAcoes);
  end;
end;

procedure TfrmPrincipal.spbAnaliseAcoesClick(Sender: TObject);
begin
  Application.CreateForm(TfrmProcAnaliseAcoes, frmProcAnaliseAcoes);
  try
    frmProcAnaliseAcoes.ShowModal;
  finally
    FreeAndNil(frmProcAnaliseAcoes);
  end;
end;

procedure TfrmPrincipal.spbHistoricoAcoesClick(Sender: TObject);
begin
  Application.CreateForm(TfrmPesHistoricoAcoes, frmPesHistoricoAcoes);
  try
    frmPesHistoricoAcoes.ShowModal
  finally
    FreeAndNil(frmPesHistoricoAcoes);
  end;
end;

procedure TfrmPrincipal.spbImportarDadosAcoesClick(Sender: TObject);
begin
  Application.CreateForm(TfrmPesImportacoes, frmPesImportacoes);
  try
    frmPesImportacoes.ShowModal
  finally
    FreeAndNil(frmPesImportacoes);
  end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  Application.CreateForm(TfrmLogin, frmLogin);
  try
    frmLogin.ShowModal;
  finally
    FreeAndNil(frmLogin);
  end;
end;

end.
