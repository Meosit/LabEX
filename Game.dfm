object GameForm: TGameForm
  Left = 285
  Top = 71
  BorderStyle = bsSingle
  Caption = #1048#1075#1088#1086#1074#1086#1081' '#1088#1077#1078#1080#1084
  ClientHeight = 617
  ClientWidth = 794
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Maze: TStringGrid
    Left = 8
    Top = 7
    Width = 603
    Height = 603
    ColCount = 10
    DefaultColWidth = 59
    DefaultRowHeight = 59
    FixedCols = 0
    RowCount = 10
    FixedRows = 0
    ParentShowHint = False
    ScrollBars = ssNone
    ShowHint = False
    TabOrder = 0
    OnDrawCell = MazeDrawCell
    OnKeyDown = MazeKeyDown
    OnSelectCell = MazeSelectCell
  end
  object BACK: TButton
    Left = 640
    Top = 392
    Width = 129
    Height = 33
    Caption = #1053#1072#1079#1072#1076
    TabOrder = 1
    OnClick = BACKClick
  end
  object modes: TGroupBox
    Left = 616
    Top = 8
    Width = 169
    Height = 105
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1080#1075#1088#1099
    TabOrder = 2
    object LTimer: TLabel
      Left = 25
      Top = 73
      Width = 40
      Height = 24
      Caption = '0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LTime: TLabel
      Left = 8
      Top = 56
      Width = 44
      Height = 16
      Caption = #1042#1088#1077#1084#1103':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object timeUP: TRadioButton
      Left = 8
      Top = 16
      Width = 153
      Height = 17
      Caption = #1048#1075#1088#1072' '#1085#1072' '#1083#1091#1095#1096#1077#1077' '#1074#1088#1077#1084#1103
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = timeUPClick
    end
    object timeDOWN: TRadioButton
      Left = 8
      Top = 40
      Width = 153
      Height = 17
      Caption = #1059#1089#1087#1077#1090#1100' '#1085#1072#1081#1090#1080' '#1074#1099#1093#1086#1076' '#1079#1072
      TabOrder = 1
      OnClick = timeDOWNClick
    end
    object timeD: TEdit
      Left = 120
      Top = 56
      Width = 41
      Height = 21
      Enabled = False
      TabOrder = 2
      Text = '8'
      OnExit = timeDExit
      OnKeyPress = timeDKeyPress
    end
  end
  object AddBox: TGroupBox
    Left = 616
    Top = 272
    Width = 169
    Height = 113
    Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1092#1091#1085#1082#1094#1080#1080
    TabOrder = 3
    object START: TSpeedButton
      Left = 8
      Top = 19
      Width = 153
      Height = 38
      Hint = 'F2'
      AllowAllUp = True
      GroupIndex = 1
      Caption = #1053#1072#1095#1072#1090#1100' '#1080#1075#1088#1091' '#1089#1086' '#1089#1074#1086#1077#1081' '#1090#1086#1095#1082#1080
      ParentShowHint = False
      ShowHint = True
      OnClick = STARTClick
    end
    object PASSFIND: TSpeedButton
      Left = 8
      Top = 67
      Width = 153
      Height = 38
      Hint = 'Ctrl + F'
      AllowAllUp = True
      GroupIndex = 2
      Caption = #1055#1088#1086#1083#1086#1078#1080#1090#1100' '#1087#1091#1090#1100' '#1086#1090' '#1090#1086#1095#1082#1080
      ParentShowHint = False
      ShowHint = True
      OnClick = PASSFINDClick
    end
  end
  object GameBox: TGroupBox
    Left = 616
    Top = 120
    Width = 169
    Height = 145
    Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1080#1075#1088#1086#1081
    TabOrder = 4
    object ABORT: TButton
      Left = 32
      Top = 104
      Width = 129
      Height = 33
      Hint = 'Ctrl + Q'
      Caption = #1055#1088#1077#1088#1074#1072#1090#1100' '#1080#1075#1088#1091
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = ABORTClick
    end
    object PAUSE: TButton
      Left = 32
      Top = 64
      Width = 129
      Height = 33
      Hint = 'Ctrl + X'
      Caption = #1055#1072#1091#1079#1072
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = PAUSEClick
    end
    object DEFSTART: TButton
      Left = 8
      Top = 24
      Width = 153
      Height = 33
      Hint = 'F1'
      Caption = #1053#1072#1095#1072#1090#1100' '#1080#1075#1088#1091
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = DEFSTARTClick
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 47
    OnTimer = TimerTimer
    Left = 776
    Top = 616
  end
end
