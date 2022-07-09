unit ufrmPesquisa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Vcl.StdCtrls, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids,
  Vcl.DBGrids, Vcl.Buttons, StrUtils, Vcl.ExtCtrls, System.UITypes;

type
  TfrmPesquisa = class(TForm)
    Pesquisa: TLabel;
    edtPesquisa: TEdit;
    dbPesquisa: TDBGrid;
    dtsConsulta: TDataSource;
    qryConsulta: TFDQuery;
    cbbTipoPesquisa: TComboBox;
    lblTotalRegistros: TLabel;
    spbConsulta: TSpeedButton;
    spbIncluir: TSpeedButton;
    spbAlterar: TSpeedButton;
    spbExcluir: TSpeedButton;
    spbSair: TSpeedButton;
    Label1: TLabel;
    cbbStatus: TComboBox;
    Timer1: TTimer;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure spbConsultaClick(Sender: TObject);
    procedure spbIncluirClick(Sender: TObject);
    procedure spbAlterarClick(Sender: TObject);
    procedure spbExcluirClick(Sender: TObject);
    procedure spbSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbbTipoPesquisaChange(Sender: TObject);
    procedure cbbStatusChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtPesquisaChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure dbPesquisaDblClick(Sender: TObject);
    procedure dbPesquisaDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
  protected
    FFiltros: String;
    FMaximoCaracteres: Boolean;
    FPodeExcluir: Boolean;
  public
    { Public declarations }
  end;

var
  frmPesquisa: TfrmPesquisa;

implementation

{$R *.dfm}

uses uConexao, uConstantes;

procedure TfrmPesquisa.cbbTipoPesquisaChange(Sender: TObject);
begin
  edtPesquisa.Clear;
  edtPesquisa.SetFocus;

  if cbbTipoPesquisa.ItemIndex = 0 then
    edtPesquisa.MaxLength := 100
  else
    edtPesquisa.MaxLength := 20;
end;

procedure TfrmPesquisa.dbPesquisaDblClick(Sender: TObject);
begin
  spbAlterar.Click;
end;

procedure TfrmPesquisa.dbPesquisaDrawColumnCell(Sender: TObject;const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if not odd(qryConsulta.RecNo) then
    if not (gdSelected in State) then
      dbPesquisa.Canvas.Brush.Color := rgb(230, 240, 255);

  // caso seja numerico
    if (Column.Field.DataType = ftBCD) and (Column.Field.Value < 0) then
      dbPesquisa.Canvas.Font.Color := clRed;

  dbPesquisa.Canvas.FillRect(Rect);
  dbPesquisa.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TfrmPesquisa.cbbStatusChange(Sender: TObject);
begin
  spbConsulta.Click;
end;

procedure TfrmPesquisa.edtPesquisaChange(Sender: TObject);
begin
  FMaximoCaracteres := Length(trim(edtPesquisa.Text)) = edtPesquisa.MaxLength;

  if not Timer1.Enabled and (cbbTipoPesquisa.ItemIndex = 0) then
    Timer1.Enabled := True;
end;

procedure TfrmPesquisa.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // F2
  if (Key = 113) then
    spbIncluir.Click;

  // F3
  if (Key = 114) then
    spbAlterar.Click;

  // F4
  if (Key = 115) then
    spbAlterar.Click;

  // F5
  if (Key = 116) then
    spbSair.Click;

  // F6
  if (Key = 117) then
    spbConsulta.Click;
end;

procedure TfrmPesquisa.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and (Trim(edtPesquisa.Text) <> EmptyStr) then
    spbConsulta.Click;
end;

procedure TfrmPesquisa.FormShow(Sender: TObject);
begin
  FMaximoCaracteres := False;
  FPodeExcluir := True;
end;

procedure TfrmPesquisa.spbAlterarClick(Sender: TObject);
begin
  //
end;

procedure TfrmPesquisa.spbConsultaClick(Sender: TObject);
begin
  FFiltros := '';
end;

procedure TfrmPesquisa.spbExcluirClick(Sender: TObject);
begin
  if qryConsulta.IsEmpty then
  begin
    FPodeExcluir := False;
    MessageDlg(SEM_REGISTROS, TMsgDlgType.mtInformation, [mbok], 0);
    exit;
  end;
end;

procedure TfrmPesquisa.spbIncluirClick(Sender: TObject);
begin
  //
end;

procedure TfrmPesquisa.spbSairClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmPesquisa.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  spbConsulta.Click;
end;

end.
