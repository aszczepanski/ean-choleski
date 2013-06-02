object Form1: TForm1
  Left = 207
  Top = 72
  Width = 960
  Height = 560
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Metoda Choleskiego'
  Color = clBtnFace
  Constraints.MaxHeight = 560
  Constraints.MaxWidth = 960
  Constraints.MinHeight = 560
  Constraints.MinWidth = 960
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 112
    Top = 16
    Width = 817
    Height = 265
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 0
    ColWidths = (
      64
      64
      63
      64
      64)
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object Edit1: TEdit
    Left = 16
    Top = 168
    Width = 89
    Height = 21
    TabOrder = 1
    Text = '3'
  end
  object Button1: TButton
    Left = 16
    Top = 240
    Width = 89
    Height = 25
    Caption = 'Oblicz'
    TabOrder = 2
    OnClick = Button1Click
  end
  object RichEdit1: TRichEdit
    Left = 16
    Top = 296
    Width = 913
    Height = 201
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object RadioGroup1: TRadioGroup
    Left = 16
    Top = 40
    Width = 89
    Height = 113
    Caption = 'Typ zmiennych'
    TabOrder = 4
  end
  object RadioButton1: TRadioButton
    Left = 24
    Top = 56
    Width = 65
    Height = 25
    Caption = 'Extended'
    Checked = True
    TabOrder = 5
    TabStop = True
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 24
    Top = 88
    Width = 65
    Height = 17
    Caption = 'IntAr 1'
    TabOrder = 6
    OnClick = RadioButton2Click
  end
  object RadioButton3: TRadioButton
    Left = 24
    Top = 120
    Width = 65
    Height = 17
    Caption = 'IntAr 2'
    TabOrder = 7
    OnClick = RadioButton3Click
  end
  object Button2: TButton
    Left = 16
    Top = 200
    Width = 89
    Height = 33
    Caption = 'Ustaw rozmiar'
    TabOrder = 8
    OnClick = Button2Click
  end
end
