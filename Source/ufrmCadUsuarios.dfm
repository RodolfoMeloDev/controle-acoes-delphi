inherited frmCadUsuarios: TfrmCadUsuarios
  Caption = 'frmCadUsuarios'
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited spbGravar: TSpeedButton
    OnClick = spbGravarClick
  end
  inherited spbCancelar: TSpeedButton
    OnClick = spbCancelarClick
  end
  inherited grbDados: TGroupBox
    object Label1: TLabel [0]
      Left = 16
      Top = 24
      Width = 43
      Height = 13
      Caption = 'Usu'#225'rio'
    end
    object Label2: TLabel [1]
      Left = 16
      Top = 72
      Width = 30
      Height = 13
      Caption = 'Login'
    end
    object Label3: TLabel [2]
      Left = 16
      Top = 118
      Width = 35
      Height = 13
      Caption = 'Senha'
    end
    object Label4: TLabel [3]
      Left = 16
      Top = 164
      Width = 32
      Height = 13
      Caption = 'Nome'
    end
    object Label5: TLabel [4]
      Left = 226
      Top = 118
      Width = 94
      Height = 13
      Caption = 'Confirmar Senha'
    end
    inherited rdgStatus: TRadioGroup
      Top = 210
      TabOrder = 5
      ExplicitTop = 210
    end
    object edtUsuario: TEdit
      Left = 16
      Top = 43
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      TabOrder = 0
    end
    object edtLogin: TEdit
      Left = 16
      Top = 91
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      TabOrder = 1
    end
    object edtSenha: TEdit
      Left = 16
      Top = 137
      Width = 200
      Height = 21
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 2
    end
    object edtNomeUsuario: TEdit
      Left = 16
      Top = 183
      Width = 513
      Height = 21
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 100
      ParentFont = False
      TabOrder = 4
    end
    object edtConfirmarSenha: TEdit
      Left = 226
      Top = 137
      Width = 200
      Height = 21
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 3
    end
  end
end
