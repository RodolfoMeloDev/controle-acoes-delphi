inherited frmPesImportacoes: TfrmPesImportacoes
  Caption = 'Pesquisa de Importa'#231#245'es'
  PixelsPerInch = 96
  TextHeight = 13
  inherited spbAlterar: TSpeedButton
    Visible = False
  end
  inherited Label1: TLabel
    Visible = False
  end
  inherited dbPesquisa: TDBGrid
    Columns = <
      item
        Expanded = False
        FieldName = 'arquivoimportacao'
        Title.Caption = 'C'#243'digo'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'data'
        Title.Caption = 'Data'
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nome'
        Title.Caption = 'Descri'#231#227'o do Arquivo'
        Width = 500
        Visible = True
      end>
  end
  inherited cbbStatus: TComboBox
    Visible = False
  end
  inherited qryConsulta: TFDQuery
    FormatOptions.AssignedValues = [fvFmtDisplayNumeric]
    FormatOptions.FmtDisplayNumeric = ''
    SQL.Strings = (
      
        'select a.arquivoimportacao, a.nome, a."data", a.usuario from dbo' +
        '.arquivosimportacao a')
  end
end
