inherited frmPesUsuarios: TfrmPesUsuarios
  Caption = 'Pesquisa de Usu'#225'rios'
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited dbPesquisa: TDBGrid
    Top = 48
    Columns = <
      item
        Expanded = False
        FieldName = 'usuario'
        Title.Caption = 'Usu'#225'rio'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'login'
        Title.Caption = 'Login'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nome'
        Title.Caption = 'Nome'
        Width = 250
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'datacriacao'
        Title.Caption = 'Dt. Cria'#231#227'o'
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'dataalteracao'
        Title.Caption = 'Dt. Altera'#231#227'o'
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'status'
        Title.Caption = 'Status'
        Width = 50
        Visible = True
      end>
  end
  inherited cbbTipoPesquisa: TComboBox
    Items.Strings = (
      'Nome'
      'C'#243'digo'
      'Login')
  end
  inherited qryConsulta: TFDQuery
    FormatOptions.AssignedValues = [fvFmtDisplayNumeric]
    FormatOptions.FmtDisplayNumeric = ''
    SQL.Strings = (
      
        'select u.usuario, u.login, u.nome, u.status, u.datacriacao, u.da' +
        'taalteracao from dbo.usuarios u')
  end
end
