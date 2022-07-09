object Conexao: TConexao
  OldCreateOrder = False
  Height = 102
  Width = 372
  object oConexao: TFDConnection
    Params.Strings = (
      'Database=ControleAcoes'
      'User_Name=postgres'
      'Password=admin'
      'Server=localhost'
      'LoginTimeout=30'
      'CharacterSet=win1252'
      'OidAsBlob=Yes'
      'UnknownFormat=BYTEA'
      'MetaDefSchema=dbo'
      'MetaCurSchema=dbo'
      'DriverID=PG')
    FetchOptions.AssignedValues = [evRowsetSize]
    FetchOptions.RowsetSize = 10000000
    FormatOptions.AssignedValues = [fvFmtDisplayNumeric]
    FormatOptions.FmtDisplayNumeric = '###,###,###,##0.00'
    TxOptions.Isolation = xiReadCommitted
    LoginPrompt = False
    Transaction = oTransaction
    Left = 40
    Top = 16
  end
  object oTransaction: TFDTransaction
    Options.Isolation = xiReadCommitted
    Connection = oConexao
    Left = 184
    Top = 16
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 272
    Top = 16
  end
  object oPgDriverLink: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files (x86)\PostgreSQL\10\bin\libpq.dll'
    Left = 104
    Top = 16
  end
end
