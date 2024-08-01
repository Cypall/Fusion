object frmMain: TfrmMain
  Left = 194
  Top = 53
  Width = 608
  Height = 365
  Caption = 's'
  Color = clCream
  Constraints.MaxHeight = 365
  Constraints.MaxWidth = 608
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Trebuchet MS'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 18
  object lbl00: TLabel
    Left = 189
    Top = 9
    Width = 30
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = '('#180'-`)'
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 300
    Width = 600
    Height = 19
    Color = clCream
    Panels = <
      item
        Width = 100
      end
      item
        Width = 300
      end>
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 600
    Height = 300
    ActivePage = TabSheet1
    Align = alClient
    Constraints.MinHeight = 300
    Constraints.MinWidth = 600
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Trebuchet MS'
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabOrder = 1
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Server Console'
      TabVisible = False
      DesignSize = (
        592
        290)
      object txtDebug: TMemo
        Left = 0
        Top = 0
        Width = 592
        Height = 262
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
        TabOrder = 0
      end
      object Edit1: TEdit
        Left = 0
        Top = 264
        Width = 486
        Height = 26
        Anchors = [akLeft, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        MaxLength = 200
        ParentFont = False
        TabOrder = 1
        OnKeyPress = Edit1KeyPress
      end
      object cmdStart: TButton
        Left = 5
        Top = 61
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
        TabOrder = 2
        Visible = False
        OnClick = cmdStartClick
      end
      object cmdStop: TButton
        Left = 5
        Top = 85
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
        TabOrder = 3
        Visible = False
        OnClick = cmdStopClick
      end
      object Button1: TButton
        Left = 5
        Top = 109
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
        Visible = False
        OnClick = Button1Click
      end
      object Combo_ISCS: TComboBox
        Left = 488
        Top = 264
        Width = 104
        Height = 26
        Anchors = [akLeft, akRight, akBottom]
        ItemHeight = 18
        TabOrder = 5
        Items.Strings = (
          'Server'
          'ISCS')
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'INI Options'
      ImageIndex = 1
      TabVisible = False
      object PageControl2: TPageControl
        Left = 0
        Top = 0
        Width = 592
        Height = 290
        ActivePage = TabSheet4
        Align = alClient
        TabOrder = 0
        OnChange = PageControl2Change
        object TabSheet4: TTabSheet
          Caption = 'Server Options'
          object Label17: TLabel
            Left = 12
            Top = 56
            Width = 57
            Height = 18
            Caption = 'IP Address'
          end
          object Label18: TLabel
            Left = 12
            Top = 8
            Width = 69
            Height = 18
            Caption = 'Server Name'
          end
          object Label19: TLabel
            Left = 564
            Top = 424
            Width = 36
            Height = 18
            Caption = 'NPC ID'
          end
          object Label20: TLabel
            Left = 148
            Top = 8
            Width = 57
            Height = 18
            Caption = 'Login Port'
          end
          object Label21: TLabel
            Left = 148
            Top = 56
            Width = 83
            Height = 18
            Caption = 'Character Port'
          end
          object Label22: TLabel
            Left = 148
            Top = 104
            Width = 58
            Height = 18
            Caption = 'Game Port'
          end
          object Label25: TLabel
            Left = 324
            Top = 464
            Width = 92
            Height = 18
            Caption = 'MySQL Password'
            Visible = False
          end
          object Label23: TLabel
            Left = 324
            Top = 424
            Width = 98
            Height = 18
            Caption = 'MySQL IP Address'
            Visible = False
          end
          object Label24: TLabel
            Left = 196
            Top = 464
            Width = 95
            Height = 18
            Caption = 'MySQL Username'
            Visible = False
          end
          object Label26: TLabel
            Left = 452
            Top = 424
            Width = 90
            Height = 18
            Caption = 'MySQL Database'
            Visible = False
          end
          object Label27: TLabel
            Left = 196
            Top = 424
            Width = 61
            Height = 18
            Caption = 'Use MySQL'
            Visible = False
          end
          object Label33: TLabel
            Left = 436
            Top = 104
            Width = 63
            Height = 18
            Caption = 'GM Logging'
          end
          object Label28: TLabel
            Left = 292
            Top = 104
            Width = 115
            Height = 18
            Caption = 'Auto-Backup Interval'
          end
          object Label29: TLabel
            Left = 292
            Top = 56
            Width = 99
            Height = 18
            Caption = 'Auto-Save Interval'
          end
          object Label30: TLabel
            Left = 436
            Top = 8
            Width = 104
            Height = 18
            Caption = '_M/_F Registration'
          end
          object Label31: TLabel
            Left = 292
            Top = 152
            Width = 84
            Height = 18
            Caption = 'Maximum Users'
          end
          object Label32: TLabel
            Left = 292
            Top = 8
            Width = 57
            Height = 18
            Caption = 'Auto-Start'
          end
          object Label36: TLabel
            Left = 148
            Top = 504
            Width = 31
            Height = 18
            Caption = 'Timer'
          end
          object Label34: TLabel
            Left = 452
            Top = 472
            Width = 103
            Height = 18
            Caption = 'Show Script Errors'
          end
          object Label35: TLabel
            Left = 436
            Top = 200
            Width = 66
            Height = 18
            Caption = 'Warp Debug'
          end
          object Label37: TLabel
            Left = 436
            Top = 152
            Width = 41
            Height = 18
            Caption = 'Priority'
          end
          object Label38: TLabel
            Left = 436
            Top = 56
            Width = 103
            Height = 18
            Caption = 'Enable Lower Dyes'
          end
          object Label60: TLabel
            Left = 148
            Top = 152
            Width = 64
            Height = 18
            Caption = 'W.A.C. Port'
          end
          object Label137: TLabel
            Left = 12
            Top = 152
            Width = 69
            Height = 18
            Caption = 'Enable UPnP'
          end
          object Label139: TLabel
            Left = 148
            Top = 200
            Width = 64
            Height = 18
            Caption = 'Enable WAC'
          end
          object Edit17: TEdit
            Left = 12
            Top = 72
            Width = 121
            Height = 26
            TabOrder = 0
          end
          object Edit22: TEdit
            Left = 148
            Top = 120
            Width = 121
            Height = 26
            TabOrder = 5
          end
          object Edit21: TEdit
            Left = 148
            Top = 72
            Width = 121
            Height = 26
            TabOrder = 4
          end
          object Edit20: TEdit
            Left = 148
            Top = 24
            Width = 121
            Height = 26
            TabOrder = 3
          end
          object Edit19: TEdit
            Left = 564
            Top = 440
            Width = 80
            Height = 26
            TabOrder = 2
          end
          object Edit18: TEdit
            Left = 12
            Top = 24
            Width = 121
            Height = 26
            TabOrder = 1
          end
          object Button5: TButton
            Left = 12
            Top = 216
            Width = 75
            Height = 25
            Caption = 'Save'
            TabOrder = 23
            OnClick = Button5Click
          end
          object Edit23: TEdit
            Left = 196
            Top = 480
            Width = 121
            Height = 26
            TabOrder = 9
            Visible = False
          end
          object Edit24: TEdit
            Left = 324
            Top = 440
            Width = 121
            Height = 26
            TabOrder = 7
            Visible = False
          end
          object Edit25: TEdit
            Left = 324
            Top = 480
            Width = 121
            Height = 26
            TabOrder = 10
            Visible = False
          end
          object Edit26: TEdit
            Left = 452
            Top = 440
            Width = 80
            Height = 26
            TabOrder = 8
            Visible = False
          end
          object ComboBox1: TComboBox
            Left = 196
            Top = 440
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 6
            Visible = False
            Items.Strings = (
              'No'
              'Yes')
          end
          object Edit29: TEdit
            Left = 292
            Top = 168
            Width = 121
            Height = 26
            TabOrder = 13
          end
          object Edit30: TEdit
            Left = 292
            Top = 120
            Width = 121
            Height = 26
            TabOrder = 16
          end
          object Edit31: TEdit
            Left = 292
            Top = 72
            Width = 121
            Height = 26
            TabOrder = 15
          end
          object ComboBox2: TComboBox
            Left = 292
            Top = 24
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 12
            Items.Strings = (
              'No'
              'Yes')
          end
          object ComboBox3: TComboBox
            Left = 436
            Top = 24
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 14
            Items.Strings = (
              'No'
              'Yes')
          end
          object ComboBox4: TComboBox
            Left = 436
            Top = 120
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 17
            Items.Strings = (
              'No'
              'Yes')
          end
          object ComboBox5: TComboBox
            Left = 453
            Top = 488
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 18
            Items.Strings = (
              'No'
              'Yes')
          end
          object ComboBox6: TComboBox
            Left = 436
            Top = 216
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 19
            Items.Strings = (
              'No'
              'Yes')
          end
          object ComboBox7: TComboBox
            Left = 148
            Top = 520
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 20
            Items.Strings = (
              'No'
              'Yes')
          end
          object ComboBox8: TComboBox
            Left = 437
            Top = 168
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 21
            Items.Strings = (
              'Real Time'
              'High'
              'Above Normal'
              'Normal'
              'Below Normal'
              'Low')
          end
          object ComboBox17: TComboBox
            Left = 436
            Top = 72
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 22
            Items.Strings = (
              'No'
              'Yes')
          end
          object Edit5: TEdit
            Left = 148
            Top = 168
            Width = 121
            Height = 26
            TabOrder = 11
          end
          object ComboBox21: TComboBox
            Left = 12
            Top = 168
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 24
            Items.Strings = (
              'No'
              'Yes')
          end
          object ComboBox22: TComboBox
            Left = 148
            Top = 216
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 25
            Items.Strings = (
              'No'
              'Yes')
          end
        end
        object TabSheet5: TTabSheet
          Caption = 'Game Options'
          ImageIndex = 1
          object Label43: TLabel
            Left = 148
            Top = 56
            Width = 111
            Height = 18
            Caption = 'Base Death Exp Loss'
          end
          object Label44: TLabel
            Left = 148
            Top = 104
            Width = 106
            Height = 18
            Caption = 'Job Death Exp Loss'
          end
          object Label45: TLabel
            Left = 148
            Top = 8
            Width = 96
            Height = 18
            Caption = 'Party Share Level'
          end
          object Label49: TLabel
            Left = 12
            Top = 152
            Width = 100
            Height = 18
            Caption = 'Disable Level Limit'
          end
          object Label50: TLabel
            Left = 292
            Top = 8
            Width = 89
            Height = 18
            Caption = 'Enable Pet Skills'
          end
          object Label51: TLabel
            Left = 436
            Top = 8
            Width = 59
            Height = 18
            Caption = 'Enable PvP'
          end
          object Label52: TLabel
            Left = 148
            Top = 384
            Width = 102
            Height = 18
            Caption = 'Disable Equip Limit'
          end
          object Label53: TLabel
            Left = 436
            Top = 104
            Width = 90
            Height = 18
            Caption = 'Enable PvP Steal'
          end
          object Label55: TLabel
            Left = 292
            Top = 56
            Width = 96
            Height = 18
            Caption = 'Pet Capture Rate'
          end
          object Label56: TLabel
            Left = 436
            Top = 152
            Width = 104
            Height = 18
            Caption = 'Steal Success Rate'
          end
          object Label57: TLabel
            Left = 12
            Top = 104
            Width = 111
            Height = 18
            Caption = 'Item Drop Multiplier'
          end
          object Label58: TLabel
            Left = 12
            Top = 56
            Width = 100
            Height = 18
            Caption = 'Job Exp Multiplier'
          end
          object Label59: TLabel
            Left = 12
            Top = 8
            Width = 105
            Height = 18
            Caption = 'Base Exp Multiplier'
          end
          object Label54: TLabel
            Left = 436
            Top = 56
            Width = 109
            Height = 18
            Caption = 'Enable PvP Exp Loss'
          end
          object Label47: TLabel
            Left = 404
            Top = 384
            Width = 83
            Height = 18
            Caption = 'Default Y Point'
          end
          object Label39: TLabel
            Left = 20
            Top = 336
            Width = 70
            Height = 18
            Caption = 'Default Zeny'
          end
          object Label40: TLabel
            Left = 20
            Top = 384
            Width = 66
            Height = 18
            Caption = 'Default Map'
          end
          object Label41: TLabel
            Left = 276
            Top = 384
            Width = 83
            Height = 18
            Caption = 'Default X Point'
          end
          object Label42: TLabel
            Left = 276
            Top = 344
            Width = 87
            Height = 18
            Caption = 'Default Weapon'
          end
          object Label46: TLabel
            Left = 404
            Top = 344
            Width = 76
            Height = 18
            Caption = 'Default Armor'
          end
          object Label48: TLabel
            Left = 532
            Top = 384
            Width = 93
            Height = 18
            Caption = 'Disable Skill Limit'
          end
          object ComboBox16: TComboBox
            Left = 12
            Top = 168
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 5
            Items.Strings = (
              'No'
              'Yes')
          end
          object Button2: TButton
            Left = 12
            Top = 216
            Width = 75
            Height = 25
            Caption = 'Save'
            TabOrder = 21
            OnClick = Button2Click
          end
          object Edit37: TEdit
            Left = 12
            Top = 72
            Width = 121
            Height = 26
            TabOrder = 1
          end
          object Edit38: TEdit
            Left = 12
            Top = 120
            Width = 121
            Height = 26
            TabOrder = 2
          end
          object Edit39: TEdit
            Left = 436
            Top = 168
            Width = 121
            Height = 26
            TabOrder = 3
          end
          object Edit40: TEdit
            Left = 292
            Top = 72
            Width = 121
            Height = 26
            TabOrder = 4
          end
          object Edit42: TEdit
            Left = 12
            Top = 24
            Width = 121
            Height = 26
            TabOrder = 0
          end
          object Edit27: TEdit
            Left = 20
            Top = 400
            Width = 121
            Height = 26
            TabOrder = 14
          end
          object Edit28: TEdit
            Left = 276
            Top = 400
            Width = 121
            Height = 26
            TabOrder = 15
          end
          object Edit43: TEdit
            Left = 276
            Top = 360
            Width = 121
            Height = 26
            TabOrder = 12
          end
          object Edit44: TEdit
            Left = 404
            Top = 360
            Width = 121
            Height = 26
            TabOrder = 13
          end
          object Edit45: TEdit
            Left = 404
            Top = 400
            Width = 121
            Height = 26
            TabOrder = 16
          end
          object Edit34: TEdit
            Left = 148
            Top = 24
            Width = 121
            Height = 26
            TabOrder = 19
          end
          object Edit32: TEdit
            Left = 148
            Top = 72
            Width = 121
            Height = 26
            TabOrder = 17
          end
          object Edit33: TEdit
            Left = 148
            Top = 120
            Width = 121
            Height = 26
            TabOrder = 18
          end
          object Edit35: TEdit
            Left = 20
            Top = 352
            Width = 121
            Height = 26
            TabOrder = 11
          end
          object ComboBox9: TComboBox
            Left = 148
            Top = 400
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 6
            Items.Strings = (
              'No'
              'Yes')
          end
          object ComboBox10: TComboBox
            Left = 292
            Top = 24
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 7
            Items.Strings = (
              'No'
              'Yes')
          end
          object ComboBox11: TComboBox
            Left = 436
            Top = 24
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 8
            Items.Strings = (
              'No'
              'Yes')
          end
          object ComboBox12: TComboBox
            Left = 436
            Top = 120
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 9
            Items.Strings = (
              'No'
              'Yes')
          end
          object ComboBox13: TComboBox
            Left = 436
            Top = 72
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 10
            Items.Strings = (
              'No'
              'Yes')
          end
          object ComboBox14: TComboBox
            Left = 532
            Top = 400
            Width = 121
            Height = 26
            ItemHeight = 18
            TabOrder = 20
            Items.Strings = (
              'No'
              'Yes')
          end
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Accounts'
      ImageIndex = 2
      TabVisible = False
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 58
        Height = 18
        Caption = 'Username:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 8
        Top = 56
        Width = 55
        Height = 18
        Caption = 'Password:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 8
        Top = 104
        Width = 23
        Height = 18
        Caption = 'Sex:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 8
        Top = 152
        Width = 78
        Height = 18
        Caption = 'Email Address:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 408
        Top = 552
        Width = 96
        Height = 18
        Caption = 'Account Banned:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
      end
      object Label7: TLabel
        Left = 336
        Top = 8
        Width = 109
        Height = 18
        Caption = 'Delete Character 1:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 336
        Top = 56
        Width = 109
        Height = 18
        Caption = 'Delete Character 2:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 336
        Top = 104
        Width = 109
        Height = 18
        Caption = 'Delete Character 3:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 336
        Top = 152
        Width = 109
        Height = 18
        Caption = 'Delete Character 4:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
      end
      object Label11: TLabel
        Left = 336
        Top = 200
        Width = 109
        Height = 18
        Caption = 'Delete Character 5:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 464
        Top = 8
        Width = 109
        Height = 18
        Caption = 'Delete Character 6:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
      end
      object Label13: TLabel
        Left = 464
        Top = 56
        Width = 109
        Height = 18
        Caption = 'Delete Character 7:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
      end
      object Label14: TLabel
        Left = 464
        Top = 104
        Width = 109
        Height = 18
        Caption = 'Delete Character 8:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
      end
      object Label15: TLabel
        Left = 464
        Top = 152
        Width = 109
        Height = 18
        Caption = 'Delete Character 9:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
      end
      object Label16: TLabel
        Left = 136
        Top = 8
        Width = 74
        Height = 18
        Caption = 'Account List:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
      end
      object Label65: TLabel
        Left = 8
        Top = 200
        Width = 112
        Height = 18
        Caption = 'ALBGM Access Level'
      end
      object Label1: TLabel
        Left = 128
        Top = 400
        Width = 65
        Height = 18
        Caption = 'Account ID:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object Label136: TLabel
        Left = 200
        Top = 402
        Width = 22
        Height = 18
        Caption = 'asdf'
        Visible = False
      end
      object ListBox1: TListBox
        Left = 136
        Top = 24
        Width = 121
        Height = 217
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ItemHeight = 18
        MultiSelect = True
        ParentFont = False
        TabOrder = 0
        OnClick = ListBox1Click
      end
      object Edit3: TEdit
        Left = 8
        Top = 24
        Width = 121
        Height = 26
        Color = 12250448
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object Edit4: TEdit
        Left = 8
        Top = 72
        Width = 121
        Height = 26
        Color = 12250448
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object Edit6: TEdit
        Left = 8
        Top = 168
        Width = 121
        Height = 26
        Color = 12250448
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Trebuchet MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object Button3: TButton
        Left = 8
        Top = 256
        Width = 75
        Height = 25
        Caption = '&Clear'
        TabOrder = 15
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 168
        Top = 256
        Width = 75
        Height = 25
        Caption = '&Save'
        TabOrder = 17
        OnClick = Button4Click
      end
      object Button6: TButton
        Left = 88
        Top = 256
        Width = 75
        Height = 25
        Caption = '&Delete'
        TabOrder = 16
        OnClick = Button6Click
      end
      object ComboBox15: TComboBox
        Left = 8
        Top = 120
        Width = 121
        Height = 26
        Color = 12250448
        ItemHeight = 18
        TabOrder = 3
        Items.Strings = (
          'Female'
          'Male')
      end
      object ComboBox18: TComboBox
        Left = 407
        Top = 568
        Width = 121
        Height = 26
        ItemHeight = 18
        TabOrder = 5
        Items.Strings = (
          'No'
          'Yes')
      end
      object Button7: TButton
        Left = 336
        Top = 24
        Width = 121
        Height = 25
        TabOrder = 6
        OnClick = Button7Clic
      end
      object Button8: TButton
        Left = 336
        Top = 72
        Width = 121
        Height = 25
        TabOrder = 7
        OnClick = Button8Click
      end
      object Button9: TButton
        Left = 336
        Top = 120
        Width = 121
        Height = 25
        TabOrder = 8
        OnClick = Button9Click
      end
      object Button10: TButton
        Left = 336
        Top = 168
        Width = 121
        Height = 25
        TabOrder = 9
        OnClick = Button10Click
      end
      object Button11: TButton
        Left = 336
        Top = 216
        Width = 121
        Height = 25
        TabOrder = 10
        OnClick = Button11Click
      end
      object Button12: TButton
        Left = 464
        Top = 24
        Width = 121
        Height = 25
        TabOrder = 11
        OnClick = Button12Click
      end
      object Button13: TButton
        Left = 464
        Top = 72
        Width = 121
        Height = 25
        TabOrder = 12
        OnClick = Button13Click
      end
      object Button14: TButton
        Left = 464
        Top = 120
        Width = 121
        Height = 25
        TabOrder = 13
        OnClick = Button14Click
      end
      object Button15: TButton
        Left = 464
        Top = 168
        Width = 121
        Height = 25
        TabOrder = 14
        OnClick = Button15Click
      end
      object Edit53: TEdit
        Left = 8
        Top = 216
        Width = 121
        Height = 26
        TabOrder = 18
      end
      object ListBox9: TListBox
        Left = 264
        Top = 24
        Width = 65
        Height = 217
        ItemHeight = 18
        TabOrder = 19
        OnClick = ListBox9Click
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Characters'
      TabVisible = False
      object PageControl3: TPageControl
        Left = 0
        Top = 0
        Width = 592
        Height = 290
        ActivePage = TabSheet6
        Align = alClient
        TabOrder = 0
        OnChange = PageControl3Change
        object TabSheet6: TTabSheet
          Caption = 'Online'
          ImageIndex = 6
          object Label95: TLabel
            Left = 8
            Top = 368
            Width = 4
            Height = 18
            Visible = False
          end
          object Label96: TLabel
            Left = 256
            Top = 8
            Width = 128
            Height = 18
            Caption = 'Message the Character'
          end
          object Label138: TLabel
            Left = 8
            Top = 8
            Width = 78
            Height = 18
            Caption = 'Character List'
          end
          object ListBox3: TListBox
            Left = 8
            Top = 24
            Width = 233
            Height = 217
            ItemHeight = 18
            TabOrder = 0
            OnClick = ListBox3Click
          end
          object Button17: TButton
            Left = 256
            Top = 112
            Width = 97
            Height = 25
            Caption = 'Refresh'
            TabOrder = 1
            OnClick = Button17Click
          end
          object Button18: TButton
            Left = 256
            Top = 184
            Width = 97
            Height = 25
            Caption = 'Kick'
            TabOrder = 2
            OnClick = Button18Click
          end
          object Edit8: TEdit
            Left = 256
            Top = 24
            Width = 313
            Height = 26
            TabOrder = 5
            OnKeyPress = Edit8KeyPress
          end
          object Button19: TButton
            Left = 472
            Top = 56
            Width = 97
            Height = 25
            Caption = 'Send'
            TabOrder = 6
            Visible = False
            OnClick = Button19Click
          end
          object Button20: TButton
            Left = 256
            Top = 216
            Width = 97
            Height = 25
            Caption = 'Kick / Ban'
            TabOrder = 3
            OnClick = Button20Click
          end
          object Button21: TButton
            Left = 256
            Top = 152
            Width = 97
            Height = 25
            Caption = 'Rescue'
            TabOrder = 4
            OnClick = Button21Click
          end
        end
        object TabSheet9: TTabSheet
          Caption = 'Stats'
          object Label61: TLabel
            Left = 0
            Top = 0
            Width = 78
            Height = 18
            Caption = 'Character List'
          end
          object Label63: TLabel
            Left = 200
            Top = 16
            Width = 73
            Height = 18
            Caption = 'Character ID:'
          end
          object Label64: TLabel
            Left = 200
            Top = 40
            Width = 34
            Height = 18
            Caption = 'Job ID'
          end
          object Label67: TLabel
            Left = 200
            Top = 0
            Width = 34
            Height = 18
            Caption = 'Name:'
          end
          object Label62: TLabel
            Left = 256
            Top = 40
            Width = 47
            Height = 18
            Caption = 'Base Lvl.'
          end
          object Label66: TLabel
            Left = 200
            Top = 80
            Width = 49
            Height = 18
            Caption = 'Base EXP'
          end
          object Label68: TLabel
            Left = 256
            Top = 80
            Width = 44
            Height = 18
            Caption = 'Job EXP'
          end
          object Label69: TLabel
            Left = 312
            Top = 40
            Width = 42
            Height = 18
            Caption = 'Job Lvl.'
          end
          object Label70: TLabel
            Left = 312
            Top = 120
            Width = 59
            Height = 18
            Caption = 'Status Pts.'
          end
          object Label71: TLabel
            Left = 256
            Top = 120
            Width = 46
            Height = 18
            Caption = 'Skill Pts.'
          end
          object Label72: TLabel
            Left = 312
            Top = 80
            Width = 27
            Height = 18
            Caption = 'Zeny'
          end
          object Label73: TLabel
            Left = 200
            Top = 120
            Width = 34
            Height = 18
            Caption = 'Speed'
          end
          object Label74: TLabel
            Left = 200
            Top = 160
            Width = 53
            Height = 18
            Caption = 'Hair Style'
          end
          object Label75: TLabel
            Left = 256
            Top = 160
            Width = 55
            Height = 18
            Caption = 'Hair Color'
          end
          object Label76: TLabel
            Left = 312
            Top = 160
            Width = 67
            Height = 18
            Caption = 'Cloths Color'
          end
          object Label77: TLabel
            Left = 384
            Top = 40
            Width = 58
            Height = 18
            Caption = 'Saved Map'
          end
          object Label78: TLabel
            Left = 456
            Top = 40
            Width = 48
            Height = 18
            Caption = 'S. Map X'
          end
          object Label79: TLabel
            Left = 512
            Top = 40
            Width = 44
            Height = 18
            Caption = 'S.Map Y'
          end
          object Label80: TLabel
            Left = 384
            Top = 80
            Width = 70
            Height = 18
            Caption = 'Current Map'
          end
          object Label94: TLabel
            Left = 128
            Top = 160
            Width = 21
            Height = 18
            Caption = 'LUK'
          end
          object Label93: TLabel
            Left = 72
            Top = 160
            Width = 20
            Height = 18
            Caption = 'DEX'
          end
          object Label92: TLabel
            Left = 16
            Top = 160
            Width = 18
            Height = 18
            Caption = 'INT'
          end
          object Label91: TLabel
            Left = 128
            Top = 120
            Width = 17
            Height = 18
            Caption = 'VIT'
          end
          object Label90: TLabel
            Left = 72
            Top = 120
            Width = 18
            Height = 18
            Caption = 'AGI'
          end
          object Label89: TLabel
            Left = 16
            Top = 120
            Width = 20
            Height = 18
            Caption = 'STR'
          end
          object Label88: TLabel
            Left = 256
            Top = 200
            Width = 44
            Height = 18
            Caption = 'Status 2'
          end
          object Label87: TLabel
            Left = 200
            Top = 200
            Width = 44
            Height = 18
            Caption = 'Status 1'
          end
          object Label86: TLabel
            Left = 312
            Top = 200
            Width = 38
            Height = 18
            Caption = 'Option'
          end
          object Label84: TLabel
            Left = 384
            Top = 0
            Width = 17
            Height = 18
            Caption = 'SP:'
          end
          object Label83: TLabel
            Left = 328
            Top = 0
            Width = 19
            Height = 18
            Caption = 'HP:'
          end
          object Label82: TLabel
            Left = 512
            Top = 80
            Width = 45
            Height = 18
            Caption = 'C-Map Y'
          end
          object Label81: TLabel
            Left = 456
            Top = 80
            Width = 45
            Height = 18
            Caption = 'C-Map X'
          end
          object Label98: TLabel
            Left = 328
            Top = 16
            Width = 21
            Height = 18
            Caption = 'N/A'
          end
          object Label99: TLabel
            Left = 384
            Top = 16
            Width = 21
            Height = 18
            Caption = 'N/A'
          end
          object Label102: TLabel
            Left = 440
            Top = 16
            Width = 21
            Height = 18
            Caption = 'N/A'
          end
          object Label101: TLabel
            Left = 440
            Top = 0
            Width = 51
            Height = 18
            Caption = 'Account:'
          end
          object Label100: TLabel
            Left = 96
            Top = 224
            Width = 67
            Height = 18
            Caption = 'Party Name:'
          end
          object Label103: TLabel
            Left = 168
            Top = 224
            Width = 21
            Height = 18
            Caption = 'N/A'
          end
          object Label104: TLabel
            Left = 96
            Top = 208
            Width = 32
            Height = 18
            Caption = 'Guild:'
          end
          object Label105: TLabel
            Left = 136
            Top = 208
            Width = 21
            Height = 18
            Caption = 'N/A'
          end
          object Label106: TLabel
            Left = 384
            Top = 120
            Width = 66
            Height = 18
            Caption = 'Memo Map1'
          end
          object Label107: TLabel
            Left = 456
            Top = 120
            Width = 48
            Height = 18
            Caption = 'M-Map X'
          end
          object Label108: TLabel
            Left = 512
            Top = 120
            Width = 48
            Height = 18
            Caption = 'M-Map Y'
          end
          object Label109: TLabel
            Left = 384
            Top = 160
            Width = 66
            Height = 18
            Caption = 'Memo Map2'
          end
          object Label114: TLabel
            Left = 384
            Top = 200
            Width = 66
            Height = 18
            Caption = 'Memo Map3'
          end
          object Label112: TLabel
            Left = 456
            Top = 160
            Width = 48
            Height = 18
            Caption = 'M-Map X'
          end
          object Label113: TLabel
            Left = 512
            Top = 160
            Width = 48
            Height = 18
            Caption = 'M-Map Y'
          end
          object Label117: TLabel
            Left = 456
            Top = 200
            Width = 48
            Height = 18
            Caption = 'M-Map X'
          end
          object Label118: TLabel
            Left = 512
            Top = 200
            Width = 48
            Height = 18
            Caption = 'M-Map Y'
          end
          object Label134: TLabel
            Left = 240
            Top = 0
            Width = 21
            Height = 18
            Caption = 'N/A'
          end
          object Label135: TLabel
            Left = 280
            Top = 16
            Width = 21
            Height = 18
            Caption = 'N/A'
          end
          object Edit52: TEdit
            Left = 384
            Top = 96
            Width = 65
            Height = 26
            TabOrder = 16
          end
          object Edit15: TEdit
            Left = 200
            Top = 96
            Width = 49
            Height = 26
            TabOrder = 4
          end
          object Edit14: TEdit
            Left = 256
            Top = 56
            Width = 49
            Height = 26
            TabOrder = 2
          end
          object Edit10: TEdit
            Left = 200
            Top = 56
            Width = 49
            Height = 26
            TabOrder = 1
          end
          object ListBox2: TListBox
            Left = 16
            Top = 16
            Width = 177
            Height = 105
            ItemHeight = 18
            TabOrder = 0
            OnClick = ListBox2Click
          end
          object Edit11: TEdit
            Left = 312
            Top = 136
            Width = 49
            Height = 26
            TabOrder = 9
          end
          object Edit12: TEdit
            Left = 312
            Top = 56
            Width = 49
            Height = 26
            TabOrder = 3
          end
          object Edit13: TEdit
            Left = 256
            Top = 96
            Width = 49
            Height = 26
            TabOrder = 5
          end
          object Edit16: TEdit
            Left = 256
            Top = 136
            Width = 49
            Height = 26
            TabOrder = 8
          end
          object Edit36: TEdit
            Left = 312
            Top = 96
            Width = 49
            Height = 26
            MaxLength = 10
            TabOrder = 6
          end
          object Edit41: TEdit
            Left = 200
            Top = 136
            Width = 49
            Height = 26
            TabOrder = 7
          end
          object Edit46: TEdit
            Left = 200
            Top = 176
            Width = 49
            Height = 26
            TabOrder = 13
          end
          object Edit47: TEdit
            Left = 256
            Top = 176
            Width = 49
            Height = 26
            TabOrder = 14
          end
          object Edit48: TEdit
            Left = 312
            Top = 176
            Width = 49
            Height = 26
            TabOrder = 15
          end
          object Edit49: TEdit
            Left = 384
            Top = 56
            Width = 65
            Height = 26
            TabOrder = 10
          end
          object Edit50: TEdit
            Left = 456
            Top = 56
            Width = 49
            Height = 26
            TabOrder = 11
          end
          object Edit51: TEdit
            Left = 512
            Top = 56
            Width = 49
            Height = 26
            TabOrder = 12
          end
          object Button16: TButton
            Left = 16
            Top = 216
            Width = 73
            Height = 25
            Caption = 'Save'
            TabOrder = 37
            OnClick = Button16Click
          end
          object Edit67: TEdit
            Left = 16
            Top = 136
            Width = 49
            Height = 26
            TabOrder = 25
          end
          object Edit66: TEdit
            Left = 72
            Top = 136
            Width = 49
            Height = 26
            TabOrder = 26
          end
          object Edit65: TEdit
            Left = 128
            Top = 136
            Width = 49
            Height = 26
            TabOrder = 27
          end
          object Edit64: TEdit
            Left = 72
            Top = 174
            Width = 49
            Height = 26
            TabOrder = 32
          end
          object Edit63: TEdit
            Left = 16
            Top = 176
            Width = 49
            Height = 26
            TabOrder = 31
          end
          object Edit61: TEdit
            Left = 128
            Top = 174
            Width = 49
            Height = 26
            TabOrder = 33
          end
          object Edit59: TEdit
            Left = 512
            Top = 96
            Width = 49
            Height = 26
            TabOrder = 18
          end
          object Edit57: TEdit
            Left = 456
            Top = 96
            Width = 49
            Height = 26
            TabOrder = 17
          end
          object Edit56: TEdit
            Left = 200
            Top = 216
            Width = 49
            Height = 26
            TabOrder = 19
          end
          object Edit55: TEdit
            Left = 256
            Top = 216
            Width = 49
            Height = 26
            TabOrder = 20
          end
          object Edit54: TEdit
            Left = 312
            Top = 216
            Width = 49
            Height = 26
            TabOrder = 21
          end
          object Edit60: TEdit
            Left = 512
            Top = 136
            Width = 49
            Height = 26
            TabOrder = 24
          end
          object Edit62: TEdit
            Left = 456
            Top = 136
            Width = 49
            Height = 26
            TabOrder = 23
          end
          object Edit68: TEdit
            Left = 384
            Top = 136
            Width = 65
            Height = 26
            TabOrder = 22
          end
          object Edit69: TEdit
            Left = 384
            Top = 176
            Width = 65
            Height = 26
            TabOrder = 28
          end
          object Edit70: TEdit
            Left = 456
            Top = 176
            Width = 49
            Height = 26
            TabOrder = 29
          end
          object Edit71: TEdit
            Left = 512
            Top = 176
            Width = 49
            Height = 26
            TabOrder = 30
          end
          object Edit72: TEdit
            Left = 512
            Top = 216
            Width = 49
            Height = 26
            TabOrder = 36
          end
          object Edit73: TEdit
            Left = 456
            Top = 216
            Width = 49
            Height = 26
            TabOrder = 35
          end
          object Edit74: TEdit
            Left = 384
            Top = 216
            Width = 65
            Height = 26
            TabOrder = 34
          end
        end
        object TabSheet10: TTabSheet
          Caption = 'Inventory'
          ImageIndex = 1
          object Label119: TLabel
            Left = 200
            Top = 0
            Width = 58
            Height = 18
            Caption = 'Item Name'
          end
          object Label120: TLabel
            Left = 288
            Top = 0
            Width = 34
            Height = 18
            Caption = 'ItemID'
          end
          object Label121: TLabel
            Left = 200
            Top = 16
            Width = 21
            Height = 18
            Caption = 'N/A'
          end
          object Label122: TLabel
            Left = 200
            Top = 64
            Width = 74
            Height = 18
            Caption = 'Refined Level'
          end
          object Label123: TLabel
            Left = 288
            Top = 64
            Width = 42
            Height = 18
            Caption = 'Amount'
          end
          object Label124: TLabel
            Left = 200
            Top = 104
            Width = 49
            Height = 18
            Caption = 'Card 1 ID'
          end
          object Label125: TLabel
            Left = 288
            Top = 104
            Width = 49
            Height = 18
            Caption = 'Card 2 ID'
          end
          object Label126: TLabel
            Left = 200
            Top = 144
            Width = 49
            Height = 18
            Caption = 'Card 3 ID'
          end
          object Label127: TLabel
            Left = 288
            Top = 144
            Width = 49
            Height = 18
            Caption = 'Card 4 ID'
          end
          object Label97: TLabel
            Left = 288
            Top = 40
            Width = 51
            Height = 18
            Caption = 'Equipped'
            Visible = False
          end
          object Label128: TLabel
            Left = 384
            Top = 128
            Width = 138
            Height = 18
            Caption = 'Storage Items (view only)'
          end
          object Label129: TLabel
            Left = 384
            Top = 0
            Width = 90
            Height = 18
            Caption = 'Cart (View Only)'
          end
          object Label130: TLabel
            Left = 8
            Top = 0
            Width = 111
            Height = 18
            Caption = 'Character Inventory'
          end
          object Label85: TLabel
            Left = 192
            Top = 192
            Width = 186
            Height = 18
            Caption = 'The ability to save is not available'
          end
          object ListBox4: TListBox
            Left = 8
            Top = 16
            Width = 177
            Height = 233
            ItemHeight = 18
            TabOrder = 0
            OnClick = ListBox4Click
          end
          object CheckBox1: TCheckBox
            Left = 200
            Top = 40
            Width = 81
            Height = 17
            Caption = 'Identified'
            TabOrder = 1
          end
          object ComboBox19: TComboBox
            Left = 200
            Top = 80
            Width = 73
            Height = 26
            ItemHeight = 18
            TabOrder = 2
            Items.Strings = (
              '0'
              '1'
              '2'
              '3'
              '4'
              '5'
              '6'
              '7'
              '8'
              '9'
              '10')
          end
          object Edit58: TEdit
            Left = 288
            Top = 80
            Width = 73
            Height = 26
            TabOrder = 4
          end
          object Edit75: TEdit
            Left = 200
            Top = 120
            Width = 73
            Height = 26
            TabOrder = 5
          end
          object Edit76: TEdit
            Left = 288
            Top = 120
            Width = 73
            Height = 26
            TabOrder = 6
          end
          object Edit77: TEdit
            Left = 200
            Top = 160
            Width = 73
            Height = 26
            TabOrder = 7
          end
          object Edit78: TEdit
            Left = 288
            Top = 160
            Width = 73
            Height = 26
            TabOrder = 8
          end
          object Button22: TButton
            Left = 288
            Top = 224
            Width = 73
            Height = 25
            Caption = 'Save'
            TabOrder = 11
            Visible = False
            OnClick = Button22Click
          end
          object Edit85: TEdit
            Left = 288
            Top = 16
            Width = 73
            Height = 26
            TabOrder = 3
          end
          object ListBox5: TListBox
            Left = 384
            Top = 144
            Width = 177
            Height = 105
            ItemHeight = 18
            TabOrder = 9
          end
          object ListBox6: TListBox
            Left = 384
            Top = 16
            Width = 177
            Height = 105
            ItemHeight = 18
            TabOrder = 10
          end
        end
        object TabSheet14: TTabSheet
          Caption = 'Skills / Flags'
          ImageIndex = 5
          object Label110: TLabel
            Left = 312
            Top = 0
            Width = 85
            Height = 18
            Caption = 'Flags (variables)'
          end
          object Label111: TLabel
            Left = 8
            Top = 0
            Width = 26
            Height = 18
            Caption = 'Skills'
          end
          object Label115: TLabel
            Left = 192
            Top = 40
            Width = 53
            Height = 18
            Caption = 'Skill Level'
          end
          object Label116: TLabel
            Left = 240
            Top = 16
            Width = 21
            Height = 18
            Caption = 'N/A'
          end
          object Label131: TLabel
            Left = 192
            Top = 16
            Width = 39
            Height = 18
            Caption = 'Skill ID:'
          end
          object Label132: TLabel
            Left = 456
            Top = 0
            Width = 78
            Height = 18
            Caption = 'Variable Name'
          end
          object Label133: TLabel
            Left = 456
            Top = 40
            Width = 30
            Height = 18
            Caption = 'Value'
          end
          object ListBox7: TListBox
            Left = 8
            Top = 16
            Width = 177
            Height = 233
            ItemHeight = 18
            TabOrder = 0
            OnClick = ListBox7Click
          end
          object ListBox8: TListBox
            Left = 320
            Top = 16
            Width = 129
            Height = 233
            ItemHeight = 18
            TabOrder = 1
            OnClick = ListBox8Click
          end
          object Button23: TButton
            Left = 192
            Top = 224
            Width = 75
            Height = 25
            Caption = 'Save'
            TabOrder = 2
            OnClick = Button23Click
          end
          object Button24: TButton
            Left = 456
            Top = 224
            Width = 75
            Height = 25
            Caption = 'Save'
            TabOrder = 3
            OnClick = Button24Click
          end
          object ComboBox20: TComboBox
            Left = 192
            Top = 56
            Width = 41
            Height = 26
            ItemHeight = 0
            TabOrder = 4
          end
          object CheckBox2: TCheckBox
            Left = 192
            Top = 144
            Width = 121
            Height = 17
            Caption = 'Hide Unused Skills'
            TabOrder = 5
            OnClick = CheckBox2Click
          end
          object Button25: TButton
            Left = 456
            Top = 192
            Width = 75
            Height = 25
            Caption = 'Delete'
            TabOrder = 6
            OnClick = Button25Click
          end
          object Edit79: TEdit
            Left = 456
            Top = 16
            Width = 121
            Height = 26
            TabOrder = 7
          end
          object Edit80: TEdit
            Left = 456
            Top = 56
            Width = 121
            Height = 26
            TabOrder = 8
          end
        end
      end
    end
  end
  object sv1: TServerSocket
    Active = False
    Port = 6900
    ServerType = stNonBlocking
    OnClientConnect = sv1ClientConnect
    OnClientDisconnect = sv1ClientDisconnect
    OnClientRead = sv1ClientRead
    OnClientError = sv1ClientError
    Left = 36
    Top = 512
  end
  object sv2: TServerSocket
    Active = False
    Port = 5964
    ServerType = stNonBlocking
    OnClientConnect = sv2ClientConnect
    OnClientDisconnect = sv2ClientDisconnect
    OnClientRead = sv2ClientRead
    OnClientError = sv2ClientError
    Left = 68
    Top = 512
  end
  object sv3: TServerSocket
    Active = False
    Port = 5967
    ServerType = stNonBlocking
    OnClientConnect = sv3ClientConnect
    OnClientDisconnect = sv3ClientDisconnect
    OnClientRead = sv3ClientRead
    OnClientError = sv3ClientError
    Left = 100
    Top = 512
  end
  object DBsaveTimer: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = DBsaveTimerTimer
    Left = 96
    Top = 480
  end
  object BackupTimer: TTimer
    Enabled = False
    OnTimer = BackupTimerTimer
    Left = 40
    Top = 472
  end
  object MainMenu1: TMainMenu
    Left = 64
    Top = 480
    object File1: TMenuItem
      Caption = '&File'
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Server1: TMenuItem
      Caption = '&Server'
      object Start1: TMenuItem
        Caption = '&Start'
        OnClick = Start1Click
      end
      object Stop1: TMenuItem
        Caption = 'S&top'
        OnClick = Stop1Click
      end
    end
    object Database1: TMenuItem
      Caption = '&Database'
      object Save1: TMenuItem
        Caption = '&Online Save'
        OnClick = Save1Click
      end
      object S1: TMenuItem
        Caption = '&Comprehensive Save'
        OnClick = S1Click
      end
      object Backup1: TMenuItem
        Caption = '&Backup'
        OnClick = Backup1Click
      end
    end
    object Control1: TMenuItem
      Caption = '&Control'
      object MinimizetoTray2: TMenuItem
        Caption = '&Minimize to Tray'
        OnClick = MinimizetoTray2Click
      end
      object ConnecttoISCS1: TMenuItem
        Caption = '&Connect to ISCS'
        OnClick = ConnecttoISCS1Click
      end
      object EnableWebAccountCreator1: TMenuItem
        Caption = '&Enable Web Account Creator'
        OnClick = EnableWebAccountCreator1Click
      end
    end
    object Menu1: TMenuItem
      Caption = '&Menu'
      object Console1: TMenuItem
        Caption = '&Console'
        OnClick = Console1Click
      end
      object Options1: TMenuItem
        Caption = '&Options'
        OnClick = Options1Click
      end
    end
    object Administration1: TMenuItem
      Caption = '&Administration'
      object Accounts1: TMenuItem
        Caption = '&Accounts'
        OnClick = Accounts1Click
      end
      object Characters1: TMenuItem
        Caption = '&Characters'
        OnClick = Characters1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object Bugtracker1: TMenuItem
        Caption = 'Report &Bugs'
        OnClick = Bugtracker1Click
      end
      object FusionHomepage1: TMenuItem
        Caption = '&Fusion Homepage'
        OnClick = FusionHomepage1Click
      end
    end
  end
  object DNSUpdateTimer: TTimer
    Enabled = False
    OnTimer = DNSUpdateTimerTimer
    Left = 128
    Top = 480
  end
end
