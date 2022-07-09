unit ufrmProcAnaliseAcoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtDlgs, Vcl.FileCtrl,
  System.UITypes, Data.DB, StrUtils, Math,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Vcl.ExtCtrls, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient,
  Datasnap.Provider, System.Generics.Collections, Vcl.NumberBox;

type
  TfrmProcAnaliseAcoes = class(TForm)
    pcAnalise: TPageControl;
    tsParametros: TTabSheet;
    grbParametros: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    spbAnalise: TSpeedButton;
    spbBackup: TSpeedButton;
    Label3: TLabel;
    spbArquivo: TSpeedButton;
    ckbRecJudicial: TCheckBox;
    ckbMaiorLiquidez: TCheckBox;
    rdgTipo: TRadioGroup;
    rdgTipoAnalise: TRadioGroup;
    ckbValoesNegativos: TCheckBox;
    ckbItensZerado: TCheckBox;
    edtLiquidez: TNumberBox;
    edtEvEbitMin: TNumberBox;
    edtEvEbitMax: TNumberBox;
    edtPLMin: TNumberBox;
    edtPLMax: TNumberBox;
    edtMargemEbitMin: TNumberBox;
    edtMargemEbitMax: TNumberBox;
    Panel1: TPanel;
    edtArquivo: TEdit;
    tsResultado: TTabSheet;
    lblTotalRegistros: TLabel;
    dbPesquisa: TDBGrid;
    edtDestino: TEdit;
    spbConsultaPasta: TSpeedButton;
    Label9: TLabel;
    spbExportar: TSpeedButton;
    procedure spbArquivoClick(Sender: TObject);
    procedure spbBackupClick(Sender: TObject);
    procedure spbAnaliseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbPesquisaDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure rdgTipoAnaliseClick(Sender: TObject);
    procedure pcAnaliseChanging(Sender: TObject; var AllowChange: Boolean);
    procedure spbConsultaPastaClick(Sender: TObject);
    procedure spbExportarClick(Sender: TObject);
  private
    { Private declarations }
    cdsAcoes: TClientDataSet;
    dtsAcoes: TDataSource;

    function RetornaFiltrosPesquisa: String;

    procedure CriaClientDataSet;
    procedure PopulaClientDataSet(Query: TFDQuery; var cdsDados: TClientDataSet);

    procedure RemoverValoresNegativos(var cdsDados: TClientDataSet);
    procedure RemoverItensZerados(var cdsDados: TClientDataSet);
    procedure RemoverItensMenorLiquidez(var cdsDados: TClientDataSet);

    procedure AtualizaPosicao(var cdsDados: TClientDataSet);

  public
    { Public declarations }
  end;

const
  IDX_ANALISE = 'ANALISE';
  IDX_CAMPOS_ANALISE = 'acao;liquidez_media_diaria;volume_financeiro';

  IDX_EY = 'EY';
  IDX_CAMPOS_EY = 'ev_por_ebit';

  IDX_PL = 'PL';
  IDX_CAMPOS_PL = 'preco_por_lucro';

  IDX_MISTO = 'MISTO';
  IDX_CAMPOS_MISTO = 'ev_por_ebit;preco_por_lucro';

  const_consulta = 'select t.letras, h.ticker, h.precounitario, h.dividend_yield, h.preco_por_lucro, h.ev_por_ebit, h.margem_ebit, h.liquidez_media_diaria, h.volume_financeiro,' + #13 +
                   ' t.recuperacao_judicial rj, st.nomesetor, ss.nomesubsetor, s.nomesegmento' + #13 +
                   'from dbo.historicosimportacao h' + #13 +
                   'inner join dbo.tickers t on t.ticker = h.ticker' + #13 +
                   'left join dbo.segmentos s on s.segmento = t.segmento' + #13 +
                   'left join dbo.subsetores ss on ss.subsetor  = s.subsetor' + #13 +
                   'left join dbo.setores st on st.setor = ss.setor' + #13 +
                   'where h.arquivoimportacao = (select max(a.arquivoimportacao) from dbo.arquivosimportacao a)' + #13 +
                   '  and h.precounitario > 0' + #13 +
                   '  and h.ticker not like ''%33''';

var
  frmProcAnaliseAcoes: TfrmProcAnaliseAcoes;

implementation

{$R *.dfm}

uses uConexao, uConstantes, uFuncoes, uAcoesData;

procedure TfrmProcAnaliseAcoes.dbPesquisaDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if dtsAcoes.DataSet.RecNo <= 20 then
    dbPesquisa.Canvas.Brush.Color := rgb(227, 251, 227)
  else
    dbPesquisa.Canvas.Brush.Color := rgb(255,229,229);

  if (gdSelected in State) then
  begin
    dbPesquisa.Canvas.Font.Color := clWhite;
    dbPesquisa.Canvas.Brush.Color := clBlue;
  end;

  if Column.FieldName = 'rj' then
  begin
    if (dtsAcoes.DataSet.FieldByName('rj').AsString = 'S') then
    begin
      dbPesquisa.Canvas.Font.Color := clRed;
      dbPesquisa.Canvas.Brush.Color := clRed;
    end
    else
      dbPesquisa.Canvas.Font.Color := dbPesquisa.Canvas.Brush.Color;
  end;

  dbPesquisa.Canvas.FillRect(Rect);
  dbPesquisa.DefaultDrawDataCell(rect,Column.Field,state);
end;

procedure TfrmProcAnaliseAcoes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(dtsAcoes);
  FreeAndNil(cdsAcoes);
end;

procedure TfrmProcAnaliseAcoes.FormShow(Sender: TObject);
begin
  CriaClientDataSet;
  dtsAcoes := TDataSource.Create(nil);

  tsResultado.TabVisible := False;
end;

procedure TfrmProcAnaliseAcoes.pcAnaliseChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if pcAnalise.ActivePage = tsResultado then
    tsResultado.TabVisible := false;
end;

procedure TfrmProcAnaliseAcoes.rdgTipoAnaliseClick(Sender: TObject);
begin
  if not cdsAcoes.IsEmpty then
    cdsAcoes.IndexName := IfThen(rdgTipoAnalise.ItemIndex = 0, IDX_EY, IfThen(rdgTipoAnalise.ItemIndex = 1, IDX_PL, IDX_MISTO));
end;

procedure TfrmProcAnaliseAcoes.AtualizaPosicao(var cdsDados: TClientDataSet);
begin
  cdsDados.First;

  while not cdsDados.Eof do
  begin
    cdsDados.Edit;
    cdsDados.FieldByName('posicao').AsInteger := cdsDados.RecNo;
    cdsDados.Post;

    cdsDados.Next;
  end;

  cdsDados.First;
end;

procedure TfrmProcAnaliseAcoes.CriaClientDataSet;
begin
  cdsAcoes := TClientDataSet.Create(nil);
  cdsAcoes.FieldDefs.Clear;
  cdsAcoes.FieldDefs.add('posicao', ftInteger);
  cdsAcoes.FieldDefs.add('rj', ftString, 10);
  cdsAcoes.FieldDefs.add('acao', ftString, 10);
  cdsAcoes.FieldDefs.add('ticker', ftString, 10);
  cdsAcoes.FieldDefs.add('precounitario', ftCurrency);
  cdsAcoes.FieldDefs.add('dividend_yield', ftFloat);
  cdsAcoes.FieldDefs.add('preco_por_lucro', ftFloat);
  cdsAcoes.FieldDefs.add('ev_por_ebit', ftFloat);
  cdsAcoes.FieldDefs.add('margem_ebit', ftFloat);
  cdsAcoes.FieldDefs.add('liquidez_media_diaria', ftCurrency);
  cdsAcoes.FieldDefs.add('volume_financeiro', ftCurrency);
  cdsAcoes.FieldDefs.add('setor', ftString, 100);
  cdsAcoes.FieldDefs.add('subsetor', ftString, 100);
  cdsAcoes.FieldDefs.add('segmento', ftString, 100);
  cdsAcoes.CreateDataSet;

  // cria os ordenadores
  cdsAcoes.IndexDefs.Add(IDX_ANALISE, IDX_CAMPOS_ANALISE, [ixDescending]);
  cdsAcoes.IndexDefs.Add(IDX_EY, IDX_CAMPOS_EY, []);
  cdsAcoes.IndexDefs.Add(IDX_PL, IDX_CAMPOS_PL, []);
  cdsAcoes.IndexDefs.Add(IDX_MISTO, IDX_CAMPOS_MISTO, []);

  // formata os campos
  TCurrencyField(cdsAcoes.Fields.FieldByName('precounitario')).DisplayFormat := '###,###,###,##0.00';
  TCurrencyField(cdsAcoes.Fields.FieldByName('liquidez_media_diaria')).DisplayFormat := '###,###,###,##0.00';
  TCurrencyField(cdsAcoes.Fields.FieldByName('volume_financeiro')).DisplayFormat := '###,###,###,##0.00';

  TCurrencyField(cdsAcoes.Fields.FieldByName('dividend_yield')).DisplayFormat := '###,###,###,##0.00';
  TCurrencyField(cdsAcoes.Fields.FieldByName('preco_por_lucro')).DisplayFormat := '###,###,###,##0.00';
  TCurrencyField(cdsAcoes.Fields.FieldByName('ev_por_ebit')).DisplayFormat := '###,###,###,##0.00';
  TCurrencyField(cdsAcoes.Fields.FieldByName('volume_financeiro')).DisplayFormat := '###,###,###,##0.00';
end;

procedure TfrmProcAnaliseAcoes.PopulaClientDataSet(Query: TFDQuery; var cdsDados: TClientDataSet);
begin
  if not cdsDados.IsEmpty then
    cdsDados.EmptyDataSet;

  while not Query.Eof do
  begin
    cdsDados.Append;
    cdsDados.FieldByName('rj').AsString := Query.FieldByName('rj').AsString;
    cdsDados.FieldByName('acao').AsString := Query.FieldByName('letras').AsString;
    cdsDados.FieldByName('ticker').AsString := Query.FieldByName('ticker').AsString;
    cdsDados.FieldByName('precounitario').AsCurrency := Query.FieldByName('precounitario').AsCurrency;
    cdsDados.FieldByName('dividend_yield').AsFloat := Query.FieldByName('dividend_yield').AsFloat;
    cdsDados.FieldByName('preco_por_lucro').AsFloat := Query.FieldByName('preco_por_lucro').AsFloat;
    cdsDados.FieldByName('ev_por_ebit').AsFloat := Query.FieldByName('ev_por_ebit').AsFloat;
    cdsDados.FieldByName('margem_ebit').AsFloat := Query.FieldByName('margem_ebit').AsFloat;
    cdsDados.FieldByName('liquidez_media_diaria').AsCurrency := Query.FieldByName('liquidez_media_diaria').AsCurrency;
    cdsDados.FieldByName('volume_financeiro').AsCurrency := Query.FieldByName('volume_financeiro').AsCurrency;
    cdsDados.FieldByName('setor').AsString := Query.FieldByName('nomesetor').AsString;
    cdsDados.FieldByName('subsetor').AsString := Query.FieldByName('nomesubsetor').AsString;
    cdsDados.FieldByName('segmento').AsString := Query.FieldByName('nomesegmento').AsString;
    cdsDados.Post;

    Query.Next;
  end;
end;

procedure TfrmProcAnaliseAcoes.RemoverItensMenorLiquidez(var cdsDados: TClientDataSet);
var
  sAcaoAnterior: String;
  sAcao: String;
begin
  if ckbMaiorLiquidez.Checked then
  begin
    sAcaoAnterior := '';
    cdsDados.IndexName := IDX_ANALISE;
    cdsDados.First;
    while not cdsAcoes.Eof do
    begin
      sAcao := TFuncoes.RetornaLetrasAcao(cdsDados.FieldByName('ticker').AsString);
      if sAcaoAnterior = sAcao then
      begin
        sAcaoAnterior := sAcao;
        cdsDados.Delete;
      end
      else
      begin
        sAcaoAnterior := sAcao;
        cdsDados.Next;
      end;
    end;
  end;
end;

procedure TfrmProcAnaliseAcoes.RemoverItensZerados(var cdsDados: TClientDataSet);
begin
  if ckbItensZerado.Checked then
  begin
    cdsDados.First;
    while not cdsAcoes.Eof do
    begin
      if (cdsDados.FieldByName('preco_por_lucro').AsCurrency = 0) or
         (cdsDados.FieldByName('ev_por_ebit').AsCurrency = 0) or
         ((cdsDados.FieldByName('liquidez_media_diaria').AsCurrency = 0) and (cdsDados.FieldByName('volume_financeiro').AsCurrency = 0))
      then
        cdsDados.Delete
      else
        cdsDados.Next;
    end;
  end;
end;

procedure TfrmProcAnaliseAcoes.RemoverValoresNegativos(var cdsDados: TClientDataSet);
begin
  if ckbValoesNegativos.Checked then
  begin
    cdsDados.First;
    while not cdsAcoes.Eof do
    begin
      if (cdsDados.FieldByName('preco_por_lucro').AsCurrency < 0) or
         (cdsDados.FieldByName('ev_por_ebit').AsCurrency < 0) or
         (cdsDados.FieldByName('margem_ebit').AsCurrency < 0)
      then
        cdsDados.Delete
      else
        cdsDados.Next;
    end;
  end;
end;

function TfrmProcAnaliseAcoes.RetornaFiltrosPesquisa: String;
begin
  Result := '';

  case rdgTipo.ItemIndex of
    0: // ativo
      Result := Result + #13 + ' and t.tipo = ''A''';
    1: // ativo
      Result := Result + #13 + ' and t.tipo = ''F''';
    2: // inativo
      Result := Result + #13 + ' and t.tipo = ''E''';
  end;

  if ckbRecJudicial.Checked then
    Result := Result + #13 + '  and coalesce(t.recuperacao_judicial, ''N'') <> ''S''';

  if edtLiquidez.Value > 0 then
    Result := Result + #13 + '  and ((h.liquidez_media_diaria >= ' + FloatToStr(edtLiquidez.Value) + ') or (h.volume_financeiro >= ' + FloatToStr(edtLiquidez.Value) + '))';

  if edtEvEbitMin.Value > 0 then
    Result := Result + #13 + '  and h.ev_por_ebit >= ' + FloatToStr(edtEvEbitMin.Value);

  if edtEvEbitMax.Value > 0 then
    Result := Result + #13 + '  and h.ev_por_ebit <= ' + FloatToStr(edtEvEbitMax.Value);

  if edtPLMin.Value > 0 then
    Result := Result + #13 + '  and h.preco_por_lucro >= ' + FloatToStr(edtPLMin.Value);

  if edtPLMax.Value > 0 then
    Result := Result + #13 + '  and h.preco_por_lucro <= ' + FloatToStr(edtPLMax.Value);

  if edtMargemEbitMin.Value > 0 then
    Result := Result + #13 + '  and h.margem_ebit >= ' + FloatToStr(edtMargemEbitMin.Value);

  if edtMargemEbitMax.Value > 0 then
    Result := Result + #13 + '  and h.margem_ebit <= ' + FloatToStr(edtMargemEbitMax.Value);
end;

procedure TfrmProcAnaliseAcoes.spbAnaliseClick(Sender: TObject);
var
  qryConsulta: TFDQuery;
begin
  dbPesquisa.DataSource := nil;

  qryConsulta := TFDQuery.Create(nil);
  qryConsulta.Connection := Conexao.oConexao;
  qryConsulta.SQL.Text := const_consulta + #13 +
                          RetornaFiltrosPesquisa + #13 +
                          'order by t.letras, h.liquidez_media_diaria desc, h.volume_financeiro';
  qryConsulta.Open;

  if not qryConsulta.IsEmpty then
  begin
    PopulaClientDataSet(qryConsulta, cdsAcoes);

    RemoverValoresNegativos(cdsAcoes);

    RemoverItensZerados(cdsAcoes);

    RemoverItensMenorLiquidez(cdsAcoes);

    // ordena pelo tipo de analise
    cdsAcoes.IndexName := IfThen(rdgTipoAnalise.ItemIndex = 0, IDX_EY, IfThen(rdgTipoAnalise.ItemIndex = 1, IDX_PL, IDX_MISTO));
    AtualizaPosicao(cdsAcoes);

    // liga o grid
    dtsAcoes.DataSet := cdsAcoes;
    dbPesquisa.DataSource := dtsAcoes;
    tsResultado.TabVisible := True;
    pcAnalise.ActivePage := tsResultado;

    // seta os dados
    lblTotalRegistros.Caption := 'Total de Registros: ' + IntToStr(cdsAcoes.RecordCount);

    MessageDlg('Analíse finalizada com sucesso', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
  end
  else
    MessageDlg(SEM_REGISTROS, TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);

  FreeAndNil(qryConsulta);
end;

procedure TfrmProcAnaliseAcoes.spbArquivoClick(Sender: TObject);
var
  sPasta: String;
begin
  if SelectDirectory('Selecione uma pasta', '', sPasta) then
    edtArquivo.Text := sPasta;
end;

procedure TfrmProcAnaliseAcoes.spbBackupClick(Sender: TObject);
var
  qryBD: TFDQuery;
  nNomeArquivo: String;
begin
  if edtArquivo.Text = EmptyStr then
  begin
    MessageDlg('Selecione um caminho para salvar o backup do arquivo que será analisado', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
    Exit;
  end;

  qryBD := TFDQuery.Create(nil);
  try
    try
      qryBD.Connection := Conexao.oConexao;
      qryBD.sql.Text := 'select lo_get(a.arquivo) arquivo, a."data" from dbo.arquivosimportacao a order by a.arquivoimportacao desc LIMIT 1';
      qryBD.Open;

      if qryBD.IsEmpty then
      begin
        MessageDlg('Não existe dados para serem recuperados', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
        Exit;
      end;

      nNomeArquivo := edtArquivo.Text + '\backup_' + StringReplace(qryBD.FieldByName('data').AsString, '/', '-', [rfReplaceAll]) + '.csv';

      if FileExists(nNomeArquivo) then
        if MessageDlg('O arquivo já existe, deseja sobreescreve-lo?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrNo then
          Exit;

      TBlobField(qryBD.FieldByName('arquivo')).SaveToFile(nNomeArquivo);

      MessageDlg('Backup realizado com sucesso', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
    except
      on e: Exception do
      begin
        MessageDlg(e.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
      end;
    end;
  finally
    FreeAndNil(qryBD);
  end;
end;

procedure TfrmProcAnaliseAcoes.spbConsultaPastaClick(Sender: TObject);
var
  sPasta: String;
begin
  if SelectDirectory('Selecione uma pasta', '', sPasta) then
    edtDestino.Text := sPasta;
end;

procedure TfrmProcAnaliseAcoes.spbExportarClick(Sender: TObject);
var
  nNomeArquivo: String;
  oArquivo: TextFile;
  i: Integer;
  cdsClone: TClientDataSet;
  sLinha: String;
begin
  if edtDestino.Text = EmptyStr then
  begin
    MessageDlg('Selecione uma pasta para salvar o arquivo.', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
    Exit;
  end;

  nNomeArquivo := edtDestino.Text + '\resultado_' + StringReplace(DateToStr(Now), '/', '-', [rfReplaceAll]) + '.csv';

  if FileExists(nNomeArquivo) then
    if MessageDlg('O arquivo já existe, deseja sobreescreve-lo?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrNo then
      Exit;

  cdsClone := TClientDataSet.Create(nil);
  try
    cdsClone.CloneCursor(cdsAcoes, False);

    // cabeçalho do arquivo
    for I := 0 to cdsClone.FieldCount - 1 do
    begin
       sLinha := sLinha + cdsClone.Fields.Fields[I].FieldName + ';';
    end;

    AssignFile(oArquivo, nNomeArquivo);
    Rewrite(oArquivo);

    Writeln(oArquivo, sLinha);

    cdsClone.First;
    while not cdsClone.Eof do
    begin
      sLinha := '';

      for I := 0 to cdsClone.FieldCount - 1 do
      begin
        if (cdsClone.Fields.Fields[I].DataType = ftFloat) then
          sLinha := sLinha + FloatToStr(cdsClone.Fields.Fields[I].Value) + ';'
        else if (cdsClone.Fields.Fields[I].DataType = ftCurrency) then
          sLinha := sLinha + CurrToStr(cdsClone.Fields.Fields[I].Value) + ';'
        else if (cdsClone.Fields.Fields[I].DataType = ftInteger) then
          sLinha := sLinha + IntToStr(cdsClone.Fields.Fields[I].Value) + ';'
        else
          sLinha := sLinha + cdsClone.Fields.Fields[I].Value + ';';
      end;

      Writeln(oArquivo, sLinha);

      cdsClone.Next;
    end;

    MessageDlg('Exportação realizada com sucesso', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
  finally
    CloseFile(oArquivo);
    FreeAndNil(cdsClone);
  end;
end;

end.
