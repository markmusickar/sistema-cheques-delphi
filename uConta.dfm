object Conta: TConta
  Left = 0
  Top = 0
  Caption = 'Cadastro de Contas'
  ClientHeight = 244
  ClientWidth = 277
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Nome: TLabel
    Left = 72
    Top = 8
    Width = 33
    Height = 15
    Caption = 'Nome'
  end
  object Agencia: TLabel
    Left = 72
    Top = 62
    Width = 43
    Height = 15
    Caption = 'Agencia'
  end
  object Conta: TLabel
    Left = 71
    Top = 112
    Width = 32
    Height = 15
    Caption = 'Conta'
  end
  object EditNome: TEdit
    Left = 72
    Top = 31
    Width = 121
    Height = 23
    TabOrder = 0
    OnKeyPress = EditKeyPress
  end
  object EditAgencia: TEdit
    Left = 72
    Top = 83
    Width = 121
    Height = 23
    TabOrder = 1
    OnKeyPress = EditKeyPress
  end
  object EditConta: TEdit
    Left = 72
    Top = 133
    Width = 121
    Height = 23
    TabOrder = 2
    OnKeyPress = EditKeyPress
  end
  object BtnSalva: TButton
    Left = 96
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Salva'
    TabOrder = 3
    OnClick = BtnSalvaClick
  end
end
