object ListForm: TListForm
  Left = 393
  Top = 77
  BorderStyle = bsSingle
  Caption = #1057#1087#1080#1089#1086#1082' '#1083#1072#1073#1080#1088#1080#1085#1090#1086#1074
  ClientHeight = 424
  ClientWidth = 577
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object List: TStringGrid
    Left = 25
    Top = 10
    Width = 525
    Height = 366
    ColCount = 3
    DefaultRowHeight = 25
    FixedCols = 0
    RowCount = 14
    Options = [goFixedVertLine, goFixedHorzLine, goHorzLine, goRowSelect]
    ScrollBars = ssVertical
    TabOrder = 0
    OnSelectCell = ListSelectCell
  end
  object New: TButton
    Left = 25
    Top = 386
    Width = 100
    Height = 30
    Caption = #1053#1086#1074#1099#1081
    TabOrder = 1
    OnClick = NewClick
  end
  object Game: TButton
    Left = 25
    Top = 386
    Width = 200
    Height = 30
    Caption = #1048#1075#1088#1072#1090#1100
    Enabled = False
    TabOrder = 2
    Visible = False
    OnClick = GameClick
  end
  object Edit: TButton
    Left = 135
    Top = 386
    Width = 100
    Height = 30
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
    Enabled = False
    TabOrder = 3
    OnClick = EditClick
  end
  object Back: TButton
    Left = 470
    Top = 386
    Width = 80
    Height = 30
    Caption = #1053#1072#1079#1072#1076
    TabOrder = 4
    OnClick = BackClick
  end
  object Delete: TButton
    Left = 245
    Top = 386
    Width = 100
    Height = 30
    Caption = #1059#1076#1072#1083#1080#1090#1100
    Enabled = False
    TabOrder = 5
    OnClick = DeleteClick
  end
end
