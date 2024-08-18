object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 441
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object Button1: TButton
    Left = 3
    Top = 408
    Width = 158
    Height = 25
    Caption = 'Get audio text'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 268
    Height = 385
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button2: TButton
    Left = 167
    Top = 408
    Width = 34
    Height = 25
    Caption = 'Rec'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 207
    Top = 408
    Width = 28
    Height = 25
    Caption = 'Stop'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Memo2: TMemo
    Left = 282
    Top = 8
    Width = 97
    Height = 385
    Lines.Strings = (
      'Memo1')
    TabOrder = 4
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 200
    Top = 264
  end
end
