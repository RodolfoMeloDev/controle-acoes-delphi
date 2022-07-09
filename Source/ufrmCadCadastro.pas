unit ufrmCadCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, uConstantes,
  System.Generics.Collections, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmCadCadastro = class(TForm)
    pnlTitulo: TPanel;
    spbGravar: TSpeedButton;
    spbSair: TSpeedButton;
    spbCancelar: TSpeedButton;
    grbDados: TGroupBox;
    rdgStatus: TRadioGroup;
    qryBD: TFDQuery;
    procedure spbSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  protected
    FChave: Integer;
    FTipoManutencao: TTipoManutencao;
    FSQLOperacacoes: TDictionary<TTipoManutencao, String>;
  public
    { Public declarations }
    procedure Inicilizar(psNome: String; poTipoManutencao: TTipoManutencao; paOperacoes: TDictionary<TTipoManutencao, String>; pnChave: Integer = 0);
  end;

var
  frmCadCadastro: TfrmCadCadastro;

implementation

{$R *.dfm}

uses uConexao;

procedure TfrmCadCadastro.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // F2
  if (Key = 113) then
    spbGravar.Click;

  // F3
  if (Key = 114) then
    spbCancelar.Click;

  // F5
  if (Key = 116) then
    spbSair.Click;
end;

procedure TfrmCadCadastro.Inicilizar(psNome: String; poTipoManutencao: TTipoManutencao; paOperacoes: TDictionary<TTipoManutencao, String>; pnChave: Integer = 0);
begin
  case poTipoManutencao of
    tmInclusao: pnlTitulo.Caption := psNome + ' - Inclusão';
    tmAlteracao: pnlTitulo.Caption := psNome + ' - Alteração'
  end;
  FTipoManutencao := poTipoManutencao;
  FSQLOperacacoes := paOperacoes;
  FChave := pnChave;
  Self.ShowModal;
end;

procedure TfrmCadCadastro.spbSairClick(Sender: TObject);
begin
  self.Close;
end;

end.
