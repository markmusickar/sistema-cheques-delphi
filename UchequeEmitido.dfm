object chequeEmitido: TchequeEmitido
  Left = 0
  Top = 0
  Caption = 'Inclus'#227'o de Cheque'
  ClientHeight = 496
  ClientWidth = 582
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  StyleName = 'Windows'
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 15
  object Label1: TLabel
    Left = 24
    Top = 43
    Width = 88
    Height = 15
    Caption = 'Numero Cheque'
  end
  object Label2: TLabel
    Left = 24
    Top = 101
    Width = 26
    Height = 15
    Caption = 'Valor'
  end
  object Vencimento: TLabel
    Left = 24
    Top = 155
    Width = 63
    Height = 15
    Caption = 'Vencimento'
  end
  object Nomial: TLabel
    Left = 24
    Top = 211
    Width = 39
    Height = 15
    Caption = 'Nomial'
  end
  object Nome: TLabel
    Left = 344
    Top = 43
    Width = 68
    Height = 15
    Caption = 'Nome Conta'
  end
  object Nomef: TLabel
    Left = 344
    Top = 115
    Width = 96
    Height = 15
    Caption = 'Nome Fornecedor'
  end
  object edtNumeroCheque: TEdit
    Left = 23
    Top = 64
    Width = 121
    Height = 23
    TabOrder = 0
  end
  object edtValor: TEdit
    Left = 24
    Top = 120
    Width = 121
    Height = 23
    TabOrder = 1
  end
  object EdtVencimento: TMaskEdit
    Left = 24
    Top = 176
    Width = 118
    Height = 23
    EditMask = '!99/99/00;1;_'
    MaxLength = 8
    TabOrder = 2
    Text = '  /  /  '
  end
  object cbConta: TComboBox
    Left = 344
    Top = 64
    Width = 145
    Height = 23
    Style = csDropDownList
    TabOrder = 3
    StyleName = 'Windows'
  end
  object btnAddconta: TButton
    Left = 495
    Top = 63
    Width = 26
    Height = 25
    Caption = '+'
    TabOrder = 4
    OnClick = btnAddcontaClick
  end
  object btnEditConta: TButton
    Left = 527
    Top = 63
    Width = 25
    Height = 25
    Caption = 'btnEditConta'
    TabOrder = 5
    OnClick = btnEditContaClick
  end
  object cbStatus: TComboBox
    Left = 23
    Top = 14
    Width = 76
    Height = 23
    Style = csDropDownList
    TabOrder = 6
    Items.Strings = (
      'Aberto'
      'Compessado'
      'Cancelado')
  end
  object cbFavorecido: TComboBox
    Left = 344
    Top = 136
    Width = 145
    Height = 23
    Style = csDropDownList
    TabOrder = 7
  end
  object BtnaddFavorecido: TButton
    Left = 495
    Top = 135
    Width = 26
    Height = 25
    Caption = '+'
    TabOrder = 8
    OnClick = BtnaddFavorecidoClick
  end
  object bntEditeFavorecido: TButton
    Left = 527
    Top = 135
    Width = 25
    Height = 25
    Caption = 'bntEditeFavorecido'
    TabOrder = 9
  end
  object EditNominal: TEdit
    Left = 23
    Top = 232
    Width = 121
    Height = 23
    TabOrder = 10
  end
  object BtnSalva: TButton
    Left = 24
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Salva'
    TabOrder = 11
    OnClick = BtnSalvaClick
  end
end
