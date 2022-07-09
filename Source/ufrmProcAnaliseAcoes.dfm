object frmProcAnaliseAcoes: TfrmProcAnaliseAcoes
  Left = 0
  Top = 0
  Caption = 'An'#225'lise de A'#231#245'es'
  ClientHeight = 661
  ClientWidth = 906
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    906
    661)
  PixelsPerInch = 96
  TextHeight = 13
  object pcAnalise: TPageControl
    Left = 8
    Top = 8
    Width = 894
    Height = 648
    ActivePage = tsResultado
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnChanging = pcAnaliseChanging
    object tsParametros: TTabSheet
      Caption = 'Parametros para Anal'#237'se'
      DesignSize = (
        886
        620)
      object grbParametros: TGroupBox
        Left = 3
        Top = 3
        Width = 877
        Height = 614
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
        DesignSize = (
          877
          614)
        object Label1: TLabel
          Left = 24
          Top = 24
          Width = 202
          Height = 13
          Caption = 'Liq. Di'#225'ria / Vol. Financeiro (Minimo)'
        end
        object Label2: TLabel
          Left = 342
          Top = 23
          Width = 66
          Height = 13
          Caption = 'EV/Ebit Min.'
        end
        object Label4: TLabel
          Left = 24
          Top = 78
          Width = 45
          Height = 13
          Caption = 'P/L Min.'
        end
        object Label5: TLabel
          Left = 129
          Top = 78
          Width = 49
          Height = 13
          Caption = 'P/L M'#225'x.'
        end
        object Label6: TLabel
          Left = 447
          Top = 24
          Width = 70
          Height = 13
          Caption = 'EV/Ebit M'#225'x.'
        end
        object Label7: TLabel
          Left = 646
          Top = 24
          Width = 82
          Height = 13
          Caption = 'Marg. Ebit Min.'
        end
        object Label8: TLabel
          Left = 755
          Top = 24
          Width = 86
          Height = 13
          Caption = 'Marg. Ebit M'#225'x.'
        end
        object spbAnalise: TSpeedButton
          Left = 726
          Top = 300
          Width = 129
          Height = 33
          Anchors = [akTop, akRight]
          Caption = 'Realizar Analise'
          OnClick = spbAnaliseClick
        end
        object spbBackup: TSpeedButton
          Left = 24
          Top = 408
          Width = 129
          Height = 33
          Caption = 'Recuperar Backup'
          OnClick = spbBackupClick
        end
        object Label3: TLabel
          Left = 24
          Top = 362
          Width = 273
          Height = 13
          Caption = 'Caminho do Backup - Dados que se'#227'o analisados'
        end
        object spbArquivo: TSpeedButton
          Left = 815
          Top = 365
          Width = 41
          Height = 37
          Hint = 'Consultar (F6)'
          Anchors = [akTop, akRight]
          Glyph.Data = {
            42090000424D4209000000000000420000002800000018000000180000000100
            20000300000000090000130B0000130B000000000000000000000000FF0000FF
            0000FF0000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000092968EEF7D7E7CFF81827FFFA8B7A5670000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000C7F3F317C1EEEE4BC5EBE635D4FFD4060000
            00000000000000000000959A93EA7C7C7AFFB1AE95FF888882FF838581FE0000
            0000000000000000000000000000000000000000000000000000000000000000
            0000C5EFEF31B3EBEFC0A5E9F4EF93E8FCFF90E7FDFF98E8F9FD9EE9F7F9ABEA
            F2E2BAECEA8AA2ACA2BC7C7C7BFFB8B499FFE0D6AAFF97978AFF80827EFF0000
            0000000000000000000000000000000000000000000000000000D4FFD406B4EA
            EEBC94E7FBFF90E7FDFFB8EBECA6A6EAF5ED94E7FBFFBFEFEA65C2EBEB5CC2EB
            EB5CB1C6BF8D7C7C7BFF9E9D8DFFE0D6AAFFCBC4A0FF7C7C7AFF9CA399CC0000
            00000000000000000000000000000000000000000000C5F3E716A7EAF4EC90E7
            FDFF90E7FDFF90E7FDFF90E7FDFF90E7FDFF90E7FDFF90E7FDFF90E7FDFF8FE4
            F8FF7E7F7CFF868881FFDAD1A7FFDBD2A7FF7E7F7CFF8A8E88FA000000000000
            000000000000000000000000000000000000D4FFD406A8EAF4EB90E7FDFF90E7
            FDFF90E7FDFF94DDE8FF8C9993FF81837FFF7F7F7DFF80817FFF878C88FF8285
            81FF7F7F7CFFA4A28AFFAAA68EFF838480FF81837FFFBFFFDF08000000000000
            000000000000000000000000000000000000B4EBEEB990E7FDFF90E7FDFF90E7
            FDFF8F9E99FF7B7B7AFF81827DFF98978AFFAAA592FFA09F8EFF878782FF8081
            7DFFA3A28CFFA4A28AFF898A83FF7C7D7BFF93DEECFFB5EAEDAE000000000000
            0000000000000000000000000000C5EDE72C94E7FBFF90E7FDFF90E7FDFF8B93
            8DFF7D7D7BFFB6B298FF909086FF909289FFD8E5CDFF959B8FFF83847FFFBDB8
            9BFF969488FF7D7D7BFF7B7B7AFF96C6CAFEA0E9F6F6AFEBF2D9D4FFD4060000
            0000000000000000000000000000B4EAEEBB90E7FDFF90E7FDFF96B4B3FF7C7C
            7AFFC7C29FFFD1DFC3FFBDC1AFFFFCF5D4FFFDF5D3FFFDF5D3FFBEC3B0FF8081
            7EFFA09E8DFF80807DFF828480FF9DE8F7FAADEBF2DDBAECECA3C0EFEC620000
            0000000000000000000000000000B6EBEDAD99E7F9FDA4EAF5F07E7F7DFF9898
            8AFFD2DBBDFFFCF5D2FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFF0EB
            CBFF80817EFFB2AE95FF7B7B7AFF94D5E2FF90E7FDFF90E7FDFFAAEAF3E70000
            00000000000000000000FFFFFF02B4EAEEBB9AE8F7FCA8D8D9F27B7B7AFFDCD3
            A8FFE4ECD1FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5
            D3FFB2B8A7FF868681FF81827EFF8C9893FF90E7FDFF90E7FDFF99E7F8FD0000
            00000000000000000000C5EBEB2890E7FDFF90E7FDFF97B1B0FF7E7F7CFFDCD7
            AEFFFCF5D2FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5
            D3FFFDF5D3FF80817DFF909187FF858884FF90E7FDFF90E7FDFF90E7FDFFFFFF
            FF020000000000000000C2ECE62A99E7F9FDB5EBECB89BA8A0F67F807DFFDAD7
            B0FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5
            D3FFFDF5D3FF81817EFF929287FF858883FF90E7FDFF90E7FDFF92E7FCFF0000
            00000000000000000000BFFFFF0497E7F9FEADE9F0D9A5C8C3F27D7D7BFFE0D6
            AAFFF0F1D2FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5
            D3FFDCDDC4FF81827EFF878781FF8B918CFF90E7FDFF90E7FDFF99E7F8FD0000
            0000000000000000000000000000A2E8F4F390E7FDFF91E6FBFF7C7C7AFFBAB3
            9AFFD3E2C8FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5
            D3FF898B85FF9E9D8DFF7C7D7BFF95BDC0FF90E7FDFF90E7FDFFABE9F2E10000
            0000000000000000000000000000B6ECEEB690E7FDFF90E7FDFF8B938DFF8081
            7DFFDED6ACFFAAB4A5FFEAEACBFFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFE4E6
            CAFF989A8CFF949488FF7F807DFF90E7FDFF90E7FDFF90E7FDFFB9EBEC9B0000
            0000000000000000000000000000C2F1F12695E7FAFE90E7FDFF91E5F7FF7F7F
            7DFF878881FFA6A491FF7F7F7DFF888A84FF979C92FF9CA296FFA0A79AFF8D8D
            84FFA3A290FF7B7B7AFF95C4CAFF90E7FDFF90E7FDFF9BE8F7FBBFE9E90C0000
            000000000000000000000000000000000000B7EAEDB290E7FDFF90E7FDFF94D9
            E7FF7F807DFF7F7F7CFFA8A691FFABA892FF969688FFA7A591FFC1B99BFF8586
            80FF7C7C7BFF94B8B7FF90E7FDFF90E7FDFF90E7FDFFBAEDEB92000000000000
            000000000000000000000000000000000000BFFFFF04AAEBF2E690E7FDFF90E7
            FDFF90E6FCFF8C9893FF7D7E7CFF7B7B7AFF7C7C7AFF7C7C7BFF7D7E7CFF878C
            88FF94DBE7FF90E7FDFF90E7FDFF90E7FDFFB1ECEFCA00000000000000000000
            00000000000000000000000000000000000000000000CFEFEF10ABEAF2E390E7
            FDFF90E7FDFF90E7FDFF90E7FDFF91E3F3FF97CDD4FF92DFEFFF90E7FDFF90E7
            FDFF90E7FDFF90E7FDFF90E7FDFFB0EAF0D3FFFFFF0200000000000000000000
            0000000000000000000000000000000000000000000000000000FFFFFF02C5EE
            EA3EC2F2EA3FC2F2EA3FC2F2EA3FB1EBF0CEA9EAF2E8A9EAF4E9A0E9F6F7C2EB
            EB5C9DE8F7FA99E7F8FDBAEDEB83000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000FFFFFF02BFEEEB5DB0EBF1D09FE9F6F894E7FBFF94E7FBFF9EE9F7F9AEEB
            F2DABBECEC8BBFE9E90C00000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000FFFFFF02FFFFFF02000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000}
          ParentShowHint = False
          ShowHint = True
          OnClick = spbArquivoClick
        end
        object ckbRecJudicial: TCheckBox
          Left = 24
          Top = 246
          Width = 297
          Height = 17
          Caption = 'Desconsiderar a'#231#245'es em Recupera'#231#227'o Judicial'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object ckbMaiorLiquidez: TCheckBox
          Left = 24
          Top = 307
          Width = 180
          Height = 17
          Caption = 'Retornar Maior Liquidez'
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
        object rdgTipo: TRadioGroup
          Left = 24
          Top = 134
          Width = 306
          Height = 40
          Caption = 'Tipo '
          Columns = 3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ItemIndex = 0
          Items.Strings = (
            'A'#231#227'o'
            'FII'
            'ETF')
          ParentFont = False
          TabOrder = 0
          TabStop = True
        end
        object rdgTipoAnalise: TRadioGroup
          Left = 24
          Top = 190
          Width = 306
          Height = 40
          Caption = 'Tipo Anal'#237'se '
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'E.Y'
            'P/L'
            'E.Y + P/L')
          TabOrder = 1
          OnClick = rdgTipoAnaliseClick
        end
        object ckbValoesNegativos: TCheckBox
          Left = 24
          Top = 265
          Width = 193
          Height = 17
          Caption = 'Desconsiderar Negativos'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object ckbItensZerado: TCheckBox
          Left = 24
          Top = 284
          Width = 193
          Height = 17
          Caption = 'Desconsiderar Itens zerados'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object edtLiquidez: TNumberBox
          Left = 24
          Top = 43
          Width = 200
          Height = 21
          Alignment = taRightJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Mode = nbmCurrency
          ParentFont = False
          TabOrder = 6
          SpinButtonOptions.Placement = nbspCompact
        end
        object edtEvEbitMin: TNumberBox
          Left = 342
          Top = 43
          Width = 95
          Height = 21
          Alignment = taRightJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Mode = nbmFloat
          ParentFont = False
          TabOrder = 7
          SpinButtonOptions.Placement = nbspCompact
        end
        object edtEvEbitMax: TNumberBox
          Left = 447
          Top = 43
          Width = 95
          Height = 21
          Alignment = taRightJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Mode = nbmFloat
          ParentFont = False
          TabOrder = 8
          SpinButtonOptions.Placement = nbspCompact
        end
        object edtPLMin: TNumberBox
          Left = 24
          Top = 97
          Width = 95
          Height = 21
          Alignment = taRightJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Mode = nbmFloat
          ParentFont = False
          TabOrder = 9
          SpinButtonOptions.Placement = nbspCompact
        end
        object edtPLMax: TNumberBox
          Left = 129
          Top = 97
          Width = 95
          Height = 21
          Alignment = taRightJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Mode = nbmFloat
          ParentFont = False
          TabOrder = 10
          SpinButtonOptions.Placement = nbspCompact
        end
        object edtMargemEbitMin: TNumberBox
          Left = 646
          Top = 43
          Width = 100
          Height = 21
          Alignment = taRightJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Mode = nbmFloat
          ParentFont = False
          TabOrder = 11
          SpinButtonOptions.Placement = nbspCompact
        end
        object edtMargemEbitMax: TNumberBox
          Left = 755
          Top = 43
          Width = 100
          Height = 21
          Alignment = taRightJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Mode = nbmFloat
          ParentFont = False
          TabOrder = 12
          SpinButtonOptions.Placement = nbspCompact
        end
        object Panel1: TPanel
          Left = 24
          Top = 339
          Width = 831
          Height = 6
          Anchors = [akLeft, akTop, akRight]
          BevelInner = bvSpace
          BevelOuter = bvSpace
          TabOrder = 13
        end
        object edtArquivo: TEdit
          Left = 24
          Top = 381
          Width = 785
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          CharCase = ecUpperCase
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 14
        end
      end
    end
    object tsResultado: TTabSheet
      Caption = 'Resultado'
      ImageIndex = 1
      DesignSize = (
        886
        620)
      object lblTotalRegistros: TLabel
        Left = 11
        Top = 598
        Width = 109
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'Total de Registros: '
      end
      object spbConsultaPasta: TSpeedButton
        Left = 679
        Top = 12
        Width = 41
        Height = 37
        Hint = 'Consultar (F6)'
        Anchors = [akTop, akRight]
        Glyph.Data = {
          42090000424D4209000000000000420000002800000018000000180000000100
          20000300000000090000130B0000130B000000000000000000000000FF0000FF
          0000FF0000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000092968EEF7D7E7CFF81827FFFA8B7A5670000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000C7F3F317C1EEEE4BC5EBE635D4FFD4060000
          00000000000000000000959A93EA7C7C7AFFB1AE95FF888882FF838581FE0000
          0000000000000000000000000000000000000000000000000000000000000000
          0000C5EFEF31B3EBEFC0A5E9F4EF93E8FCFF90E7FDFF98E8F9FD9EE9F7F9ABEA
          F2E2BAECEA8AA2ACA2BC7C7C7BFFB8B499FFE0D6AAFF97978AFF80827EFF0000
          0000000000000000000000000000000000000000000000000000D4FFD406B4EA
          EEBC94E7FBFF90E7FDFFB8EBECA6A6EAF5ED94E7FBFFBFEFEA65C2EBEB5CC2EB
          EB5CB1C6BF8D7C7C7BFF9E9D8DFFE0D6AAFFCBC4A0FF7C7C7AFF9CA399CC0000
          00000000000000000000000000000000000000000000C5F3E716A7EAF4EC90E7
          FDFF90E7FDFF90E7FDFF90E7FDFF90E7FDFF90E7FDFF90E7FDFF90E7FDFF8FE4
          F8FF7E7F7CFF868881FFDAD1A7FFDBD2A7FF7E7F7CFF8A8E88FA000000000000
          000000000000000000000000000000000000D4FFD406A8EAF4EB90E7FDFF90E7
          FDFF90E7FDFF94DDE8FF8C9993FF81837FFF7F7F7DFF80817FFF878C88FF8285
          81FF7F7F7CFFA4A28AFFAAA68EFF838480FF81837FFFBFFFDF08000000000000
          000000000000000000000000000000000000B4EBEEB990E7FDFF90E7FDFF90E7
          FDFF8F9E99FF7B7B7AFF81827DFF98978AFFAAA592FFA09F8EFF878782FF8081
          7DFFA3A28CFFA4A28AFF898A83FF7C7D7BFF93DEECFFB5EAEDAE000000000000
          0000000000000000000000000000C5EDE72C94E7FBFF90E7FDFF90E7FDFF8B93
          8DFF7D7D7BFFB6B298FF909086FF909289FFD8E5CDFF959B8FFF83847FFFBDB8
          9BFF969488FF7D7D7BFF7B7B7AFF96C6CAFEA0E9F6F6AFEBF2D9D4FFD4060000
          0000000000000000000000000000B4EAEEBB90E7FDFF90E7FDFF96B4B3FF7C7C
          7AFFC7C29FFFD1DFC3FFBDC1AFFFFCF5D4FFFDF5D3FFFDF5D3FFBEC3B0FF8081
          7EFFA09E8DFF80807DFF828480FF9DE8F7FAADEBF2DDBAECECA3C0EFEC620000
          0000000000000000000000000000B6EBEDAD99E7F9FDA4EAF5F07E7F7DFF9898
          8AFFD2DBBDFFFCF5D2FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFF0EB
          CBFF80817EFFB2AE95FF7B7B7AFF94D5E2FF90E7FDFF90E7FDFFAAEAF3E70000
          00000000000000000000FFFFFF02B4EAEEBB9AE8F7FCA8D8D9F27B7B7AFFDCD3
          A8FFE4ECD1FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5
          D3FFB2B8A7FF868681FF81827EFF8C9893FF90E7FDFF90E7FDFF99E7F8FD0000
          00000000000000000000C5EBEB2890E7FDFF90E7FDFF97B1B0FF7E7F7CFFDCD7
          AEFFFCF5D2FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5
          D3FFFDF5D3FF80817DFF909187FF858884FF90E7FDFF90E7FDFF90E7FDFFFFFF
          FF020000000000000000C2ECE62A99E7F9FDB5EBECB89BA8A0F67F807DFFDAD7
          B0FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5
          D3FFFDF5D3FF81817EFF929287FF858883FF90E7FDFF90E7FDFF92E7FCFF0000
          00000000000000000000BFFFFF0497E7F9FEADE9F0D9A5C8C3F27D7D7BFFE0D6
          AAFFF0F1D2FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5
          D3FFDCDDC4FF81827EFF878781FF8B918CFF90E7FDFF90E7FDFF99E7F8FD0000
          0000000000000000000000000000A2E8F4F390E7FDFF91E6FBFF7C7C7AFFBAB3
          9AFFD3E2C8FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFFDF5
          D3FF898B85FF9E9D8DFF7C7D7BFF95BDC0FF90E7FDFF90E7FDFFABE9F2E10000
          0000000000000000000000000000B6ECEEB690E7FDFF90E7FDFF8B938DFF8081
          7DFFDED6ACFFAAB4A5FFEAEACBFFFDF5D3FFFDF5D3FFFDF5D3FFFDF5D3FFE4E6
          CAFF989A8CFF949488FF7F807DFF90E7FDFF90E7FDFF90E7FDFFB9EBEC9B0000
          0000000000000000000000000000C2F1F12695E7FAFE90E7FDFF91E5F7FF7F7F
          7DFF878881FFA6A491FF7F7F7DFF888A84FF979C92FF9CA296FFA0A79AFF8D8D
          84FFA3A290FF7B7B7AFF95C4CAFF90E7FDFF90E7FDFF9BE8F7FBBFE9E90C0000
          000000000000000000000000000000000000B7EAEDB290E7FDFF90E7FDFF94D9
          E7FF7F807DFF7F7F7CFFA8A691FFABA892FF969688FFA7A591FFC1B99BFF8586
          80FF7C7C7BFF94B8B7FF90E7FDFF90E7FDFF90E7FDFFBAEDEB92000000000000
          000000000000000000000000000000000000BFFFFF04AAEBF2E690E7FDFF90E7
          FDFF90E6FCFF8C9893FF7D7E7CFF7B7B7AFF7C7C7AFF7C7C7BFF7D7E7CFF878C
          88FF94DBE7FF90E7FDFF90E7FDFF90E7FDFFB1ECEFCA00000000000000000000
          00000000000000000000000000000000000000000000CFEFEF10ABEAF2E390E7
          FDFF90E7FDFF90E7FDFF90E7FDFF91E3F3FF97CDD4FF92DFEFFF90E7FDFF90E7
          FDFF90E7FDFF90E7FDFF90E7FDFFB0EAF0D3FFFFFF0200000000000000000000
          0000000000000000000000000000000000000000000000000000FFFFFF02C5EE
          EA3EC2F2EA3FC2F2EA3FC2F2EA3FB1EBF0CEA9EAF2E8A9EAF4E9A0E9F6F7C2EB
          EB5C9DE8F7FA99E7F8FDBAEDEB83000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000FFFFFF02BFEEEB5DB0EBF1D09FE9F6F894E7FBFF94E7FBFF9EE9F7F9AEEB
          F2DABBECEC8BBFE9E90C00000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000FFFFFF02FFFFFF02000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000}
        ParentShowHint = False
        ShowHint = True
        OnClick = spbConsultaPastaClick
      end
      object Label9: TLabel
        Left = 11
        Top = 9
        Width = 155
        Height = 13
        Caption = 'Caminho Destino Resultado'
      end
      object spbExportar: TSpeedButton
        Left = 734
        Top = 16
        Width = 129
        Height = 33
        Caption = 'Exportar '
        OnClick = spbExportarClick
      end
      object dbPesquisa: TDBGrid
        Left = 11
        Top = 55
        Width = 852
        Height = 537
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ParentFont = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = [fsBold]
        OnDrawColumnCell = dbPesquisaDrawColumnCell
        Columns = <
          item
            Expanded = False
            FieldName = 'rj'
            Title.Caption = 'RJ'
            Width = 20
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'posicao'
            Title.Caption = 'Pos.'
            Width = 40
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ticker'
            Title.Caption = 'A'#231#227'o'
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'precounitario'
            Title.Caption = 'Pre'#231'o Un.'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'dividend_yield'
            Title.Caption = 'D.Y.'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'preco_por_lucro'
            Title.Caption = 'P/L'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ev_por_ebit'
            Title.Caption = 'EV/Ebit'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'margem_ebit'
            Title.Caption = 'Margem Ebit'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'liquidez_media_diaria'
            Title.Caption = 'Liquidez M'#233'dia Di'#225'ria'
            Width = 140
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'volume_financeiro'
            Title.Caption = 'Volume Financerio'
            Width = 140
            Visible = True
          end>
      end
      object edtDestino: TEdit
        Left = 11
        Top = 28
        Width = 662
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        CharCase = ecUpperCase
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
  end
end
