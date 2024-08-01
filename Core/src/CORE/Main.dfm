object frmMain: TfrmMain
  Left = 313
  Top = 356
  Width = 765
  Height = 435
  Caption = '#33'
  Color = clCream
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS P????'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  DesignSize = (
    757
    401)
  PixelsPerInch = 96
  TextHeight = 16
  object lbl00: TLabel
    Left = 189
    Top = 9
    Width = 30
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = '('#180'-`)'
  end
  object cmdStart: TButton
    Left = 5
    Top = 5
    Width = 68
    Height = 24
    Caption = 'Start'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = cmdStartClick
  end
  object cmdStop: TButton
    Left = 77
    Top = 5
    Width = 68
    Height = 24
    Caption = 'Stop'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = cmdStopClick
  end
  object Edit1: TEdit
    Left = 154
    Top = 5
    Width = 455
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    MaxLength = 83
    ParentFont = False
    TabOrder = 3
    OnKeyPress = Edit1KeyPress
  end
  object Button1: TButton
    Left = 613
    Top = 5
    Width = 108
    Height = 24
    Anchors = [akTop, akRight]
    Caption = 'Send Message'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = Button1Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 382
    Width = 757
    Height = 19
    Color = clCream
    Panels = <
      item
        Width = 100
      end
      item
        Width = 300
      end
      item
        Alignment = taRightJustify
        Width = 50
      end>
  end
  object txtDebug: TMemo
    Left = 0
    Top = 34
    Width = 757
    Height = 348
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = 14071432
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Button2: TButton
    Left = 729
    Top = 5
    Width = 22
    Height = 24
    Anchors = [akTop, akRight]
    Caption = 'T'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = cmdMinTray
  end
  object sv1: TServerSocket
    Active = False
    Port = 6900
    ServerType = stNonBlocking
    OnClientConnect = sv1ClientConnect
    OnClientDisconnect = sv1ClientDisconnect
    OnClientRead = sv1ClientRead
    OnClientError = sv1ClientError
    Left = 12
    Top = 248
  end
  object sv2: TServerSocket
    Active = False
    Port = 5964
    ServerType = stNonBlocking
    OnClientConnect = sv2ClientConnect
    OnClientDisconnect = sv2ClientDisconnect
    OnClientRead = sv2ClientRead
    OnClientError = sv2ClientError
    Left = 44
    Top = 248
  end
  object sv3: TServerSocket
    Active = False
    Port = 5967
    ServerType = stNonBlocking
    OnClientConnect = sv3ClientConnect
    OnClientDisconnect = sv3ClientDisconnect
    OnClientRead = sv3ClientRead
    OnClientError = sv3ClientError
    Left = 76
    Top = 248
  end
  object DBsaveTimer: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = DBsaveTimerTimer
    Left = 112
    Top = 248
  end
  object BackupTimer: TTimer
    Enabled = False
    OnTimer = BackupTimerTimer
    Left = 368
    Top = 200
  end
end
