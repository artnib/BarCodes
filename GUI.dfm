object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072' '#1096#1090#1088#1080#1093'-'#1082#1086#1076#1086#1074
  ClientHeight = 123
  ClientWidth = 611
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object InFile: TLabel
    Left = 119
    Top = 14
    Width = 26
    Height = 13
    Caption = 'InFile'
  end
  object ErrMsg: TLabel
    Left = 119
    Top = 45
    Width = 3
    Height = 13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 105
    Height = 25
    Action = SetInput
    TabOrder = 0
  end
  object Button3: TButton
    Left = 8
    Top = 39
    Width = 105
    Height = 25
    Action = Process
    TabOrder = 1
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 104
    Width = 611
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object Button4: TButton
    Left = 8
    Top = 70
    Width = 105
    Height = 25
    Action = Stop
    TabOrder = 3
  end
  object ActionList1: TActionList
    Left = 248
    Top = 40
    object SetInput: TAction
      Caption = #1042#1093#1086#1076#1085#1086#1081' '#1092#1072#1081#1083'...'
      ShortCut = 16457
      OnExecute = SetInputExecute
    end
    object Process: TAction
      Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100
      Enabled = False
      OnExecute = ProcessExecute
      OnUpdate = ProcessUpdate
    end
    object Stop: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Enabled = False
      OnExecute = StopExecute
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = #1060#1072#1081#1083#1099' Excel|*.xls*'
    Left = 312
    Top = 40
  end
end
