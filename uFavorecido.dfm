object Favorecido: TFavorecido
  Left = 0
  Top = 0
  Caption = 'Favorecido'
  ClientHeight = 298
  ClientWidth = 306
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  TextHeight = 15
  object BtnSalva: TButton
    Left = 120
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Salva'
    TabOrder = 0
    OnClick = BtnSalvaClick
  end
  object EdtNome: TEdit
    Left = 88
    Top = 55
    Width = 121
    Height = 23
    TabOrder = 1
    OnKeyPress = EdtNomeKeyPress
  end
end
