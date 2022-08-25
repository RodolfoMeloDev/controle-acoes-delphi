inherited frmPesAcoes: TfrmPesAcoes
  Caption = 'Pesquisa de A'#231#245'es'
  ClientHeight = 541
  ClientWidth = 1104
  ExplicitLeft = -357
  ExplicitWidth = 1120
  ExplicitHeight = 580
  PixelsPerInch = 96
  TextHeight = 13
  inherited lblTotalRegistros: TLabel
    Top = 524
    ExplicitTop = 524
  end
  inherited spbConsulta: TSpeedButton
    Left = 981
    ExplicitLeft = 983
  end
  inherited spbIncluir: TSpeedButton
    Left = 1028
    Visible = False
    ExplicitLeft = 1030
  end
  inherited spbAlterar: TSpeedButton
    Left = 1028
    Visible = False
    ExplicitLeft = 1030
  end
  inherited spbExcluir: TSpeedButton
    Left = 1028
    Visible = False
    ExplicitLeft = 1030
  end
  inherited spbSair: TSpeedButton
    Left = 1028
    ExplicitLeft = 1030
  end
  inherited Label1: TLabel
    Left = 1028
    Width = 55
    Caption = 'Tipo A'#231#227'o'
    ExplicitLeft = 1030
    ExplicitWidth = 55
  end
  inherited edtPesquisa: TEdit
    Width = 840
    ExplicitWidth = 840
  end
  inherited dbPesquisa: TDBGrid
    Top = 50
    Width = 1014
    Height = 470
    PopupMenu = ppmHistorico
    Columns = <
      item
        Expanded = False
        FieldName = 'recuperacao_judicial'
        Title.Caption = 'RJ'
        Width = 20
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ticker'
        Title.Caption = 'C'#243'digo'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nome'
        Title.Caption = 'Nome'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'data'
        Title.Caption = 'Ult. Importa'#231#227'o'
        Width = 85
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'precounitario'
        Title.Caption = 'Pr. Un.'
        Width = 70
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'dividend_yield'
        Title.Caption = 'Div. Yield'
        Width = 70
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'preco_por_lucro'
        Title.Caption = 'P/L'
        Width = 70
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'preco_por_valor_patrimonial'
        Title.Caption = 'P/VPA'
        Width = 70
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'margem_ebit'
        Title.Caption = 'Marg. Ebit'
        Width = 70
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'ev_por_ebit'
        Title.Caption = 'EV/Ebit'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'roic'
        Title.Caption = 'ROIC'
        Width = 70
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'liquidez_media_diaria'
        Title.Caption = 'Liq. M'#233'dia Di'#225'ria'
        Width = 95
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'volume_financeiro'
        Title.Caption = 'Volume Financeiro'
        Width = 95
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'valor_mercado'
        Title.Caption = 'Valor Mercado'
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'cnpj'
        Title.Caption = 'CNPJ'
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'empresa'
        Title.Caption = 'Empresa'
        Width = 250
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'site'
        Title.Caption = 'Site'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'descricao'
        Title.Caption = 'Descri'#231#227'o'
        Width = 1200
        Visible = True
      end>
  end
  inherited cbbTipoPesquisa: TComboBox
    Text = 'C'#243'digo'
    Items.Strings = (
      'C'#243'digo'
      'Nome')
  end
  inherited cbbStatus: TComboBox
    Left = 1028
    Text = 'A'#231#227'o'
    Items.Strings = (
      'A'#231#227'o'
      'FII'
      'ETF')
    ExplicitLeft = 1028
  end
  inherited qryConsulta: TFDQuery
    FormatOptions.AssignedValues = [fvFmtEditNumeric]
    SQL.Strings = (
      
        'select t.ticker, t.nome, a2."data", h.precounitario, h.dividend_' +
        'yield, h.preco_por_lucro, h.preco_por_valor_patrimonial,'
      
        #9'   h.margem_ebit, h.ev_por_ebit, h.liquidez_media_diaria, h.vol' +
        'ume_financeiro, h.valor_mercado,'#9't.empresa, t.cnpj, t.descricao,' +
        ' t.site, h.roic'
      'from dbo.tickers t'
      
        'left join dbo.historicosimportacao h on h.ticker  = t.ticker and' +
        ' '#9#9#9#9#9#9#9#9#9#9'h.arquivoimportacao = (select max(a.arquivoimportacao' +
        ') arquivoimportacao from dbo.arquivosimportacao a where a.usuari' +
        'o = :usuario)'#9#9#9#9#9#9#9#9#9#9
      
        'left join dbo.arquivosimportacao a2 on a2.arquivoimportacao = h.' +
        'arquivoimportacao ')
    ParamData = <
      item
        Name = 'USUARIO'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end>
  end
  object ppmHistorico: TPopupMenu
    Left = 416
    Top = 192
    object MostraHistricodePreo1: TMenuItem
      Caption = 'Mostra Hist'#243'rico de Pre'#231'o'
      OnClick = MostraHistricodePreo1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object GravarRecuperaoJudicial1: TMenuItem
      Caption = 'Gravar Recupera'#231#227'o Judicial'
      OnClick = GravarRecuperaoJudicial1Click
    end
    object RemoverRecuperaoJudicial1: TMenuItem
      Caption = 'Remover Recupera'#231#227'o Judicial'
      OnClick = RemoverRecuperaoJudicial1Click
    end
  end
end
