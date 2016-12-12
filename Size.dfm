object SizeForm: TSizeForm
  Left = 531
  Top = 224
  Width = 224
  Height = 260
  BorderIcons = [biMinimize, biMaximize]
  Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1083#1072#1073#1080#1088#1080#1085#1090#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Cancel: TButton
    Left = 107
    Top = 190
    Width = 95
    Height = 25
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = CancelClick
  end
  object Ok: TButton
    Left = 5
    Top = 190
    Width = 95
    Height = 25
    Caption = 'OK'
    TabOrder = 3
    OnClick = OkClick
  end
  object WidthBox: TGroupBox
    Left = 8
    Top = 54
    Width = 193
    Height = 65
    Caption = #1064#1080#1088#1080#1085#1072' '#1083#1072#1073#1080#1088#1080#1085#1090#1072
    TabOrder = 1
    object WL: TLabel
      Left = 8
      Top = 21
      Width = 147
      Height = 13
      Caption = '  10                                     100'
    end
    object WidthBar: TTrackBar
      Left = 8
      Top = 32
      Width = 153
      Height = 25
      Max = 100
      Min = 10
      Position = 25
      TabOrder = 1
      ThumbLength = 15
      TickMarks = tmTopLeft
      TickStyle = tsManual
      OnChange = WidthBarChange
    end
    object WidthSize: TEdit
      Left = 160
      Top = 40
      Width = 25
      Height = 21
      TabOrder = 0
      Text = '25'
      OnChange = WidthSizeChange
      OnExit = WidthSizeExit
      OnKeyPress = WidthSizeKeyPress
    end
  end
  object HeightBox: TGroupBox
    Left = 8
    Top = 120
    Width = 193
    Height = 65
    Caption = #1042#1099#1089#1086#1090#1072' '#1083#1072#1073#1080#1088#1080#1085#1090#1072
    TabOrder = 2
    object HL: TLabel
      Left = 8
      Top = 21
      Width = 147
      Height = 13
      Caption = '  10                                     100'
    end
    object HeightBar: TTrackBar
      Left = 8
      Top = 32
      Width = 153
      Height = 25
      Max = 100
      Min = 10
      Position = 25
      TabOrder = 1
      ThumbLength = 15
      TickMarks = tmTopLeft
      TickStyle = tsManual
      OnChange = HeightBarChange
    end
    object HeightSize: TEdit
      Left = 160
      Top = 40
      Width = 25
      Height = 21
      TabOrder = 0
      Text = '25'
      OnChange = HeightSizeChange
      OnExit = HeightSizeExit
      OnKeyPress = HeightSizeKeyPress
    end
  end
  object NameBox: TGroupBox
    Left = 8
    Top = 6
    Width = 193
    Height = 45
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1083#1072#1073#1080#1088#1080#1085#1090#1072
    TabOrder = 0
    object Name: TEdit
      Left = 8
      Top = 18
      Width = 177
      Height = 21
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnExit = NameExit
    end
  end
end
