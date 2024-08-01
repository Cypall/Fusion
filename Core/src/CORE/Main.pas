unit Main;

interface

uses
    {Delphi VCL units (Windows Only)}
        {$IFDEF MSWINDOWS} //Saying to load this if WINDOWS
        Windows, Messages, MMSystem, Forms, ShellApi, Graphics, Controls, Dialogs,
        Menus, ScktComp, StdCtrls, ExtCtrls, WinSock, ComCtrls,
        {$ENDIF}
    {Delphi/Kylix CLX units (Linux)}
        {$IFDEF LINUX}
        QExtCtrls, QComCtrls, QGraphics, QControls, QDialogs, QMenus, Qt, QStdCtrls,
        {$ENDIF}
    {Shared}
        SysUtils, Variants, Classes, IniFiles, Types,
	{Fusion Units}
    	Login, CharaSel, Script, Game, Path, Database, Common, MonsterAI, Buttons,
    	SQLData, FusionSQL, Math, Game_Master, Player_Skills, WeissINI, JCon, Globals,
        PacketProcesses, ISCS, WAC,
    {3rd Party Units}
    	List32, Zip, WSocket;

const
    {I know these are windows based, keep away from linux XD}
    {$IFDEF MSWINDOWS}
	REALTIME_PRIORITY_CLASS = $100;
	HIGH_PRIORITY_CLASS = $80;
	ABOVE_NORMAL_PRIORITY_CLASS = $8000;
	NORMAL_PRIORITY_CLASS = $20;
	BELOW_NORMAL_PRIORITY_CLASS = $4000;
	IDLE_PRIORITY_CLASS = $40;
	WM_NOTIFYICON  = WM_USER+333;
	htTitleBtn = htSizeLast + 1;
    {$ENDIF}


type
	TfrmMain = class(TForm)
		sv1          :TServerSocket;
		sv2          :TServerSocket;
		sv3          :TServerSocket;
		cmdStart     :TButton;
		cmdStop      :TButton;
		lbl00        :TLabel;
		txtDebug     :TMemo;
		DBsaveTimer  :TTimer;
		Edit1: TEdit;
		Button1: TButton;
		StatusBar1: TStatusBar;
		BackupTimer: TTimer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Server1: TMenuItem;
    Start1: TMenuItem;
    Stop1: TMenuItem;
    TabSheet3: TTabSheet;
    ListBox1: TListBox;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit6: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Button3: TButton;
    Button4: TButton;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Button5: TButton;
    Label23: TLabel;
    Label24: TLabel;
    Edit23: TEdit;
    Edit24: TEdit;
    Label25: TLabel;
    Edit25: TEdit;
    Label26: TLabel;
    Edit26: TEdit;
    Label27: TLabel;
    ComboBox1: TComboBox;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Edit29: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ComboBox16: TComboBox;
    Button2: TButton;
    Edit37: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    Edit40: TEdit;
    Edit42: TEdit;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    ComboBox17: TComboBox;
    Label38: TLabel;
    Label54: TLabel;
    Label39: TLabel;
    Edit27: TEdit;
    Label40: TLabel;
    Edit28: TEdit;
    Label41: TLabel;
    Edit43: TEdit;
    Label42: TLabel;
    Label46: TLabel;
    Edit44: TEdit;
    Label47: TLabel;
    Edit45: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    ComboBox9: TComboBox;
    ComboBox10: TComboBox;
    ComboBox11: TComboBox;
    ComboBox12: TComboBox;
    ComboBox13: TComboBox;
    Control1: TMenuItem;
    MinimizetoTray2: TMenuItem;
    Label48: TLabel;
    ComboBox14: TComboBox;
    Database1: TMenuItem;
    Save1: TMenuItem;
    Backup1: TMenuItem;
    Button6: TButton;
    ComboBox15: TComboBox;
    ComboBox18: TComboBox;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    S1: TMenuItem;
    ConnecttoISCS1: TMenuItem;
    EnableWebAccountCreator1: TMenuItem;
    Label60: TLabel;
    Edit5: TEdit;
    TabSheet7: TTabSheet;
    Edit53: TEdit;
    Label65: TLabel;
    DNSUpdateTimer: TTimer;
    PageControl3: TPageControl;
    TabSheet6: TTabSheet;
    Label95: TLabel;
    Label96: TLabel;
    ListBox3: TListBox;
    Button17: TButton;
    Button18: TButton;
    Edit8: TEdit;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    TabSheet9: TTabSheet;
    Label61: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label67: TLabel;
    Label62: TLabel;
    Label66: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label94: TLabel;
    Label93: TLabel;
    Label92: TLabel;
    Label91: TLabel;
    Label90: TLabel;
    Label89: TLabel;
    Label88: TLabel;
    Label87: TLabel;
    Label86: TLabel;
    Label84: TLabel;
    Label83: TLabel;
    Label82: TLabel;
    Label81: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    Label102: TLabel;
    Label101: TLabel;
    Label100: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    Label114: TLabel;
    Label112: TLabel;
    Label113: TLabel;
    Label117: TLabel;
    Label118: TLabel;
    Edit52: TEdit;
    Edit15: TEdit;
    Edit14: TEdit;
    Edit10: TEdit;
    ListBox2: TListBox;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit16: TEdit;
    Edit36: TEdit;
    Edit41: TEdit;
    Edit46: TEdit;
    Edit47: TEdit;
    Edit48: TEdit;
    Edit49: TEdit;
    Edit50: TEdit;
    Edit51: TEdit;
    Button16: TButton;
    Edit67: TEdit;
    Edit66: TEdit;
    Edit65: TEdit;
    Edit64: TEdit;
    Edit63: TEdit;
    Edit61: TEdit;
    Edit59: TEdit;
    Edit57: TEdit;
    Edit56: TEdit;
    Edit55: TEdit;
    Edit54: TEdit;
    Edit60: TEdit;
    Edit62: TEdit;
    Edit68: TEdit;
    Edit69: TEdit;
    Edit70: TEdit;
    Edit71: TEdit;
    Edit72: TEdit;
    Edit73: TEdit;
    Edit74: TEdit;
    TabSheet10: TTabSheet;
    Label119: TLabel;
    Label120: TLabel;
    Label121: TLabel;
    Label122: TLabel;
    Label123: TLabel;
    Label124: TLabel;
    Label125: TLabel;
    Label126: TLabel;
    Label127: TLabel;
    Label97: TLabel;
    ListBox4: TListBox;
    CheckBox1: TCheckBox;
    ComboBox19: TComboBox;
    Edit58: TEdit;
    Edit75: TEdit;
    Edit76: TEdit;
    Edit77: TEdit;
    Edit78: TEdit;
    Button22: TButton;
    Edit85: TEdit;
    TabSheet14: TTabSheet;
    ListBox5: TListBox;
    ListBox6: TListBox;
    Label128: TLabel;
    Label129: TLabel;
    Label130: TLabel;
    Label85: TLabel;
    ListBox7: TListBox;
    ListBox8: TListBox;
    Label110: TLabel;
    Label111: TLabel;
    Button23: TButton;
    Button24: TButton;
    ComboBox20: TComboBox;
    Label115: TLabel;
    CheckBox2: TCheckBox;
    Label116: TLabel;
    Label131: TLabel;
    Button25: TButton;
    Edit79: TEdit;
    Edit80: TEdit;
    Label132: TLabel;
    Label133: TLabel;
    Label134: TLabel;
    Label135: TLabel;
    Menu1: TMenuItem;
    Console1: TMenuItem;
    Options1: TMenuItem;
    Administration1: TMenuItem;
    Accounts1: TMenuItem;
    Characters1: TMenuItem;
    Label1: TLabel;
    Combo_ISCS: TComboBox;
    Label136: TLabel;
    ListBox9: TListBox;
    Label137: TLabel;
    ComboBox21: TComboBox;
    Label139: TLabel;
    ComboBox22: TComboBox;
    Help1: TMenuItem;
    Bugtracker1: TMenuItem;
    FusionHomepage1: TMenuItem;

		procedure FormResize(Sender: TObject); overload;
		procedure DBsaveTimerTimer(Sender: TObject);

		procedure FormCreate(Sender: TObject);
		procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
		procedure MonsterSpawn(tm:TMap; ts:TMob; Tick:cardinal);
		procedure MobSpawn(tm:TMap; ts:TMob; Tick:cardinal);
		procedure MonsterDie(tm:TMap; tc:TChara; ts:TMob; Tick:cardinal);

		procedure StatCalc1(tc:TChara; ts:TMob; Tick:cardinal);
		procedure StatCalc2(tc:TChara; tc1:TChara; Tick:cardinal);
		function  CharaMoving(tc:TChara;Tick:cardinal) : boolean;
		procedure CharaSplash(tc:TChara;Tick:cardinal);
		procedure CharaSplash2(tc:TChara;Tick:cardinal);
		procedure CharaAttack(tc:TChara;Tick:cardinal);
		procedure CharaAttack2(tc:TChara;Tick:cardinal);

        {Maybe a place to put all the passive processes besides main?}
		procedure CharaPassive(tc:TChara;Tick:cardinal);
		procedure SkillPassive(tc:TChara;Tick:Cardinal);
		procedure PetPassive(tc:TChara; _Tick:Cardinal);
        function  MapPassive(tm:TMap; Tick:Cardinal) : boolean;

		function  NPCAction(tm:TMap;tn:TNPC;Tick:cardinal;tc:TChara) : Integer;

		procedure MobAI(tm:TMap;ts:TMob;Tick:cardinal);
		procedure MobMoveL(tm:TMap;Tick:cardinal);

		function  MobMoving(tm:TMap;ts:TMob;Tick:cardinal) : Integer;  //Spirit Sphere by Darkhelmet

		procedure MobAttack(tm:TMap;ts:TMob;Tick:cardinal);
		procedure StatEffect(tm:TMap; ts:TMob; Tick:Cardinal);

		procedure CreateField(tc:TChara; Tick:Cardinal);
		function DamageOverTime(tm: TMap; var tc: TChara; Tick: cardinal; skill: word; useLV: byte; count: integer): boolean;
		{Pet Moving}
		procedure PetMoving( tc:TChara; _Tick:cardinal );

		{Damage Calculations}
		procedure DamageCalc1(tm:TMap; tc:TChara; ts:TMob; Tick:cardinal; Arms:byte = 0; SkillPer:integer = 0; AElement:byte = 0; HITFix:integer = 0);
		procedure DamageCalc2(tm:TMap; tc:TChara; ts:TMob; Tick:cardinal; SkillPer:integer = 0; AElement:byte = 255; HITFix:integer = 0);
		procedure DamageCalc3(tm:TMap; tc:TChara; tc1:TChara; Tick:cardinal; Arms:byte = 0; SkillPer:integer = 0; AElement:byte = 0; HITFix:integer = 0);

		{Damage Processes}
		function  DamageProcess1(tm:TMap; tc:TChara; ts:TMob; Dmg:integer; Tick:cardinal;isBreak:Boolean = True) : Boolean;
		function  DamageProcess2(tm:TMap; tc:TChara; tc1:TChara; Dmg:integer; Tick:cardinal;isBreak:Boolean = True) : Boolean;
		procedure KnockBackLiving(tm:TMap; tc:TChara; tv:TLiving; dist:byte; ktype: byte = 0);

		procedure sv1ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
		procedure sv1ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
		procedure sv1ClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
		procedure sv1ClientRead(Sender: TObject; Socket: TCustomWinSocket);
		procedure sv2ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
		procedure sv2ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
		procedure sv2ClientRead(Sender: TObject; Socket: TCustomWinSocket);
		procedure sv2ClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
		procedure sv3ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
		procedure sv3ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
		procedure sv3ClientRead(Sender: TObject; Socket: TCustomWinSocket);
		procedure sv3ClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
		procedure cmdStartClick(Sender: TObject);
		procedure cmdStopClick(Sender: TObject);
		procedure Button1Click(Sender: TObject);
		procedure Edit1KeyPress(Sender: TObject; var Key: Char);
		procedure CMClickIcon(var msg: TMessage); message WM_NOTIFYICON;
		procedure BackupTimerTimer(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox9Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);

    procedure PriorityUpdate(prioramount : Integer);
    procedure PageControl2Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure MinimizetoTray2Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Backup1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Clic(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure ConnecttoISCS1Click(Sender: TObject);
    procedure EnableWebAccountCreator1Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure PageControl3Change(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure Edit8KeyPress(Sender: TObject; var Key: Char);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure ListBox4Click(Sender: TObject);
    procedure DNSUpdateTimerTimer(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure ListBox7Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure ListBox8Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure Console1Click(Sender: TObject);
    procedure Accounts1Click(Sender: TObject);
    procedure Characters1Click(Sender: TObject);
    procedure Bugtracker1Click(Sender: TObject);
    procedure FusionHomepage1Click(Sender: TObject);
    	//procedure cbxPriorityChange(Sender: TObject);


	private

	public
		{ Public êÈåæ }
		// AlexKreuz Online Timer
		OnlineTime, ElapsedT: integer;

//		ElapsedD, ElapsedH, ElapsedM, ElapsedS: double;
		ElapsedD, ElapsedH, ElapsedM, ElapsedS: DWORD;
		// AlexKreuz Online Timer


		DelPointX       :array[0..999] of cardinal;  // mf
		DelPointY       :array[0..999] of cardinal;  // mf
		DelID           :array[0..999] of cardinal;  // mf
		DelWait         :array[0..999] of cardinal;  // mf

	end;



var
	frmMain       :TfrmMain;

	Priority      :cardinal;
	TickCheckCnt  :byte;

//ChrstphrR 2004/06/01 - if I find out who the SOB is that made THESE global
// variables I'll run them through.
//	i             :integer;
//	j             :integer;
	w             :word;
	TickCheck     :array[0..9] of cardinal;
	dmg           :array[0..7] of integer;

	//Skill variables

	spbonus       :integer;
	//Icon
	TrayIcon      : TNotifyIconData;

implementation

{$R *.dfm}

uses
	Skills;

//==============================================================================
procedure TfrmMain.FormCreate(Sender: TObject);
var
	sl  :TStringList;
	sl1 :TStringList;
	ini :TIniFile;
	PriorityClass :cardinal;
	a : integer;
	b : integer;
	c : integer;

    hostName : array [0..255] of char;
    hostEnt : PHostEnt;
    addr : PChar;
    IP : String;

begin

	AppPath := ExtractFilePath(ParamStr(0));
    Caption := ' Fusion Server Software - ' + RELEASE_VERSION;

    Combo_ISCS.ItemIndex := 0;

	//Alex' new GM command initialization
	load_commands();
    init_globals();

	sl := TStringList.Create;
	sl.QuoteChar := '"';
	sl.Delimiter := ',';
    sl.Clear;

    ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
    ini.ReadSectionValues('Version', sl);
        if not (sl.Values['VER'] = '1.212 S - R.E.E.D Beta 4 Release') then begin
            DeleteFile(AppPath + 'weiss.ini');
        end;
    ini.Free;


	ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));

	ini.ReadSectionValues('Server', sl);

	sl1 := TStringList.Create;
	sl1.Delimiter := '.';


    { -- Automatically assigning LAN_IP -- }
    gethostname(hostName, sizeof (hostName));
    hostEnt := gethostbyname(hostName);
    addr := hostEnt^.h_addr_list^;
    LAN_IP := Format ('%d.%d.%d.%d', [byte (addr [0]), byte (addr [1]), byte (addr [2]), byte (addr [3])]);
    LAN_ADDR := cardinal(inet_addr(PChar(LAN_IP)));
    { -- Automatically assigning LAN_IP -- }

    { -- Resolving WAN_IP -- }
	sl1.DelimitedText := sl.Values['WAN_IP'];
    WAN_IP := sl.Values['WAN_IP'];
    WAN_ADDR := cardinal(inet_addr(PChar(WAN_IP)));
    hostEnt := gethostbyname(PChar(WAN_IP));
    try
        addr := hostEnt^.h_addr_list^;
        IP := Format ('%d.%d.%d.%d', [byte (addr [0]), byte (addr [1]), byte (addr [2]), byte (addr [3])]);
        WAN_ADDR := cardinal(inet_addr(PChar(IP)));
    except
        on EAccessViolation do begin
            WAN_ADDR := LAN_ADDR;
        end;
    end;
    { -- Resolving WAN_IP -- }


	if sl.IndexOfName('Name') > -1 then begin
		ServerName := sl.Values['Name'];
	end else begin
		ServerName := 'weiss';
	end;
	{if sl.IndexOfName('NPCID') > -1 then begin
		DefaultNPCID := StrToInt(sl.Values['NPCID']);
	end else begin
		DefaultNPCID := 50000;
	end;}
    
    //Tsusai : NPC ID's start with this number, so why is it needed for user modification?
    //50000 is a nice static start point for npc id's
	NowNPCID := 50000;

	if sl.IndexOfName('sv1port') > -1 then begin
		sv1port := StrToInt(sl.Values['sv1port']);
	end else begin
		sv1port := 6900;
	end;
	sv1.Port := sv1port;
	if sl.IndexOfName('sv2port') > -1 then begin
		sv2port := StrToInt(sl.Values['sv2port']);
	end else begin
		sv2port := 6121;
	end;
	sv2.Port := sv2port;
	if sl.IndexOfName('sv3port') > -1 then begin
		sv3port := StrToInt(sl.Values['sv3port']);
	end else begin
		sv3port := 5121;
	end;
	sv3.Port := sv3port;
	if sl.IndexOfName('wacport') > -1 then begin
		wacport := StrToInt(sl.Values['wacport']);
	end else begin
		wacport := 80;
	end;

	if sl.IndexOfName('WarpDebug') > -1 then begin
		WarpDebugFlag := StrToBool(sl.Values['WarpDebug']);
	end else begin
		WarpDebugFlag := false;
	end;
	if sl.IndexOfName('BaseExpMultiplier') > -1 then begin
		BaseExpMultiplier := StrToInt(sl.Values['BaseExpMultiplier']);
		{if (BaseExpMultiplier > 999) then begin
			BaseExpMultiplier := 999;
		end;}
	end else begin
		BaseExpMultiplier := 1;
	end;
	if sl.IndexOfName('JobExpMultiplier') > -1 then begin
		JobExpMultiplier := StrToInt(sl.Values['JobExpMultiplier']);
		{if (JobExpMultiplier > 999) then begin
			JobExpMultiplier := 999;
		end;}
	end else begin
		JobExpMultiplier := 1;
	end;
	if sl.IndexOfName('DisableMonsterActive') > -1 then begin
		DisableMonsterActive := StrToBool(sl.Values['DisableMonsterActive']);
	end else begin
		DisableMonsterActive := false;
	end;
	if sl.IndexOfName('AutoStart') > -1 then begin
		AutoStart := StrToBool(sl.Values['AutoStart']);
	end else begin
		AutoStart := true;
	end;
	if sl.IndexOfName('DisableLevelLimit') > -1 then begin
		DisableLevelLimit := StrToBool(sl.Values['DisableLevelLimit']);
	end else begin
		DisableLevelLimit := false;
	end;
	if sl.IndexOfName('EnableMonsterKnockBack') > -1 then begin
		EnableMonsterKnockBack := StrToBool(sl.Values['EnableMonsterKnockBack']);
	end else begin
		EnableMonsterKnockBack := false;
	end;
	if sl.IndexOfName('DisableEquipLimit') > -1 then begin
		DisableEquipLimit := StrToBool(sl.Values['DisableEquipLimit']);
	end else begin
		DisableEquipLimit := false;
	end;
	if sl.IndexOfName('ItemDropType') > -1 then begin
		ItemDropType := StrToBool(sl.Values['ItemDropType']);
	end else begin
		ItemDropType := false;
	end;
	if sl.IndexOfName('ItemDropDenominator') > -1 then begin
		ItemDropDenominator := StrToInt(sl.Values['ItemDropDenominator']);
	end else begin
		ItemDropDenominator := 10000;
	end;
	if sl.IndexOfName('ItemDropPer') > -1 then begin
		ItemDropPer := StrToInt(sl.Values['ItemDropPer']);
	end else begin
		ItemDropPer := 10000;
	end;
{Colus, 20031222: ItemDropMultiplier works like this:
    Default value is 1.
    Making it higher than 1 will make IDD = 10000/IDM (which is a xIDM drop rate)
    Maximum value is 10000.  Higher values become 10K.  (10000x drops?  Ugh...)
		Values of 0 or less default to 1.

    * The checking is done here so that we don't repeat it for every single drop.
    * You currently can play with IDD and IDP independently.  They do the same
      thing...I would rather see people use one or the other, but it's their
      call.
}
	if sl.IndexOfName('ItemDropMultiplier') > -1 then begin
		ItemDropMultiplier := StrToInt(sl.Values['ItemDropMultiplier']);
    if ItemDropMultiplier <= 1 then begin
      ItemDropMultiplier := 1;
    end else if ItemDropMultiplier > 10000 then begin
      ItemDropMultiplier := 10000;
    end;
	end else begin
		ItemDropMultiplier := 1;
	end;
	if sl.IndexOfName('StealMultiplier') > -1 then begin
		StealMultiplier := StrToInt(sl.Values['StealMultiplier']);
		if StealMultiplier <= 0 then begin
			StealMultiplier := 0;
		end else if StealMultiplier > 10000 then begin
			StealMultiplier := 10000;
		end;
	end else begin
		StealMultiplier := 100;
	end;
	if sl.IndexOfName('EnablePetSkills') > -1 then begin
		EnablePetSkills := StrToBool(sl.Values['EnablePetSkills']);
	end else begin
		EnablePetSkills := true;
	end;
	if sl.IndexOfName('EnableMonsterSkills') > -1 then begin
		EnableMonsterSkills := StrToBool(sl.Values['EnableMonsterSkills']);
	end else begin
		EnableMonsterSkills := true;
	end;
	if sl.IndexOfName('EnableLowerClassDyes') > -1 then begin
		EnableLowerClassDyes := StrToBool(sl.Values['EnableLowerClassDyes']);
	end else begin
		EnableLowerClassDyes := false;
	end;
    if sl.IndexOfName('DisableAdv2ndDye') > -1 then begin
		DisableAdv2ndDye := StrToBool(sl.Values['DisableAdv2ndDye']);
	end else begin
		DisableAdv2ndDye := false;
    end;
	if sl.IndexOfName('DisableFleeDown') > -1 then begin
		DisableFleeDown := StrToBool(sl.Values['DisableFleeDown']);
	end else begin
		DisableFleeDown := false;
	end;
	if sl.IndexOfName('DisableSkillLimit') > -1 then begin
		DisableSkillLimit := StrToBool(sl.Values['DisableSkillLimit']);
	end else begin
		DisableSkillLimit := false;
	end;
{U0x008a_fix}
	if sl.IndexOfName('DefaultZeny') > -1 then begin
		DefaultZeny := StrToInt(sl.Values['DefaultZeny']);
	end else begin
		DefaultZeny := 300;
	end;
	if sl.IndexOfName('DefaultMap') > -1 then begin
		DefaultMap := sl.Values['DefaultMap'];
	end else begin
		DefaultMap := 'new_1-1';
	end;
	if sl.IndexOfName('DefaultPoint_X') > -1 then begin
		DefaultPoint_X := StrToInt(sl.Values['DefaultPoint_X']);
	end else begin
		DefaultPoint_X := 50;
	end;
	if sl.IndexOfName('DefaultPoint_Y') > -1 then begin
		DefaultPoint_Y := StrToInt(sl.Values['DefaultPoint_Y']);
	end else begin
		DefaultPoint_Y := 100;
	end;
	if sl.IndexOfName('DefaultItem1') > -1 then begin
		DefaultItem1 := StrToInt(sl.Values['DefaultItem1']);
	end else begin
		DefaultItem1 := 1201;
	end;
	if sl.IndexOfName('DefaultItem2') > -1 then begin
		DefaultItem2 := StrToInt(sl.Values['DefaultItem2']);
	end else begin
		DefaultItem2 := 2301;
	end;
	if sl.IndexOfName('GMCheck') > -1 then begin
		GMCheck := StrToIntDef(sl.Values['GMCheck'],0);
	end else begin
		GMCheck := $FF;
	end;
	if sl.IndexOfName('DebugCMD') > -1 then begin
		DebugCMD := StrToIntDef(sl.Values['DebugCMD'],0);
	end else begin
		DebugCMD := $FFFF;
	end;
	if sl.IndexOfName('DeathBaseLoss') > -1 then begin
		DeathBaseLoss := StrToInt(sl.Values['DeathBaseLoss']);
	end else begin
		DeathBaseLoss := 1;
	end;
	if sl.IndexOfName('DeathJobLoss') > -1 then begin
		DeathJobLoss := StrToInt(sl.Values['DeathJobLoss']);
	end else begin
		DeathJobLoss := 1;
	end;
	if sl.IndexOfName('MonsterMob') > -1 then begin
		MonsterMob := StrToBool(sl.Values['MonsterMob']);
	end else begin
		MonsterMob := true;
	end;
	if sl.IndexOfName('SummonMonsterExp') > -1 then begin
		SummonMonsterExp := StrToBool(sl.Values['SummonMonsterExp']);
	end else begin
		SummonMonsterExp := true;
	end;
		if sl.IndexOfName('SummonMonsterAgo') > -1 then begin
		SummonMonsterAgo := StrToBool(sl.Values['SummonMonsterAgo']);
	end else begin
		SummonMonsterAgo := false;
	end;
		if sl.IndexOfName('SummonMonsterName') > -1 then begin
		SummonMonsterName := StrToBool(sl.Values['SummonMonsterName']);
	end else begin
		SummonMonsterName := true;
	end;
	if sl.IndexOfName('SummonMonsterMob') > -1 then begin
		SummonMonsterMob := StrToBool(sl.Values['SummonMonsterMob']);
	end else begin
		SummonMonsterMob := true;
	end;
	if sl.IndexOfName('GlobalGMsg') > -1 then begin
		GlobalGMsg := sl.Values['GlobalGMsg'];
	end else begin
		GlobalGMsg := 'The [$castlename] castle has been taken by [$guildname] guild.';
		// Unoccupied version: 'The [$castlename] castle is claimed by [$guildname] guild.'
	end;
	if sl.IndexOfName('MapGMsg') > -1 then begin
		MapGMsg := sl.Values['MapGMsg'];
	end else begin
		MapGMsg := 'Emperium Has Been Destroyed';
	end;
	if sl.IndexOfName('Timer') > -1 then begin
		Timer := StrToBool(sl.Values['Timer']);
	end else begin
		Timer := true;
	end;

{U0x008a_fix_end}
	sl.Clear;

	ini.ReadSectionValues('Fusion', sl);
	if sl.IndexOfName('Option_PVP') > -1 then begin
                    try
                        Option_PVP := StrToBool(sl.Values['Option_PVP']);
                    except
                        on EConvertError do
                            Option_PVP := False;
                    end;
                end else begin
                        Option_PVP := false;
                end;
	if sl.IndexOfName('Option_MaxUsers') > -1 then begin
                        Option_MaxUsers := StrToInt(sl.Values['Option_MaxUsers']);
                end else begin
                        Option_MaxUsers := 100;
                end;
	if sl.IndexOfName('Option_AutoSave') > -1 then begin
                        Option_AutoSave := StrToInt(sl.Values['Option_AutoSave']);
                end else begin
                        Option_AutoSave := 600;
                end;
	if sl.IndexOfName('Option_AutoBackup') > -1 then begin
		Option_AutoBackup := StrToInt(sl.Values['Option_AutoBackup']);
	end else begin
		Option_AutoBackup := 0;
	end;
    if sl.IndexOfName('Option_DNS_Update') > -1 then begin
		Option_DNS_Update := StrToInt(sl.Values['Option_DNS_Update']);
	end else begin
		Option_DNS_Update := 0;
	end;
	if sl.IndexOfName('Option_WelcomeMsg') > -1 then begin
		Option_WelcomeMsg := StrToBool(sl.Values['Option_WelcomeMsg']);
	end else begin
		Option_WelcomeMsg := True;
	end;

	Option_MOTD := StrToBoolDef(SL.Values['Option_MOTD'], False);
	if Option_MOTD then begin
		Option_MOTD_File := SL.Values['Option_MOTD_File'];
		if NOT FileExists( AppPath + Option_MOTD_File ) then begin
			//Turn off MOTD option.
			Option_MOTD_File := '';
			Option_MOTD := False;
		end;
		Option_MOTD_Athena := StrToBoolDef(SL.Values['Option_MOTD_Athena'], False);
	end;

	if sl.IndexOfName('Option_GraceTime') > -1 then begin
                        Option_GraceTime := StrToInt(sl.Values['Option_GraceTime']);
                end else begin
                        Option_GraceTime := 5000;
                end;
	if sl.IndexOfName('Option_GraceTime_PvPG') > -1 then begin
                        Option_GraceTime_PvPG := StrToInt(sl.Values['Option_GraceTime_PvPG']);
                end else begin
                        Option_GraceTime_PvPG := 15000;
                end;
	if sl.IndexOfName('Option_Username_MF') > -1 then begin
		Option_Username_MF := StrToBool(sl.Values['Option_Username_MF']);
	end else begin
		Option_Username_MF := False;
	end;

	if sl.IndexOfName('Option_Back_Color') > -1 then begin
                        Option_Back_Color := sl.Values['Option_Back_Color'];
                end else begin
                        Option_Back_Color := 'FFFFFF';
                end;
	if sl.IndexOfName('Option_Font_Color') > -1 then begin
                        Option_Font_Color := sl.Values['Option_Font_Color'];
                end else begin
                        Option_Font_Color := '14BB85';
                end;
	if sl.IndexOfName('Option_Font_Size') > -1 then begin
                        Option_Font_Size := strtoint(sl.Values['Option_Font_Size']);
                end else begin
                        Option_Font_Size := 8;
                end;
	if sl.IndexOfName('Option_Font_Face') > -1 then begin
                        Option_Font_Face := sl.Values['Option_Font_Face'];
                end else begin
                        Option_Font_Face := 'Lucida Sans Unicode';
                end;
	if sl.IndexOfName('Option_Font_Style') > -1 then begin
		Option_Font_Style := sl.Values['Option_Font_Style'];
	end else begin
		Option_Font_Style := '';
	end;


    if sl.IndexOfName('Option_Enable_WAC') > -1 then begin
        try
            Option_Enable_WAC := StrToBool(sl.Values['Option_Enable_WAC']);
        except
            on EConvertError do Option_Enable_WAC := False;
        end;
    end else begin
        Option_Enable_WAC := False;
    end;

    if sl.IndexOfName('Option_Enable_ISCS') > -1 then begin
        try
            Option_Enable_ISCS := StrToBool(sl.Values['Option_Enable_ISCS']);
        except
            on EConvertError do Option_Enable_ISCS := True;
        end;
    end else begin
        Option_Enable_ISCS := True;
    end;

    if sl.IndexOfName('Option_Use_UPnP') > -1 then begin
        try
            Option_Use_UPnP := StrToBool(sl.Values['Option_Use_UPnP']);
        except
            on EConvertError do Option_Use_UPnP := True;
        end;
    end else begin
        Option_Use_UPnP := True;
    end;


    if (Option_Use_UPnP) then begin
        create_upnp(sv1port, 'Fusion Login Zone');
        create_upnp(sv2port, 'Fusion Character Zone');
        create_upnp(sv3port, 'Fusion Game Zone');
    end;

    if (Option_Enable_WAC) then begin
        create_wac();
        EnableWebAccountCreator1.Caption := 'Disable Web Account Creator';
    end;

    if sl.IndexOfName('Option_Minimize_Tray') > -1 then begin
        try
            Option_Minimize_Tray := StrToBool(sl.Values['Option_Minimize_Tray']);
        except
            on EConvertError do Option_Minimize_Tray := False;
        end;
    end else begin
        Option_Minimize_Tray := False;
    end;


	if sl.IndexOfName('Option_Mob_Spawn_Rate') > -1 then begin
                        Option_Mob_Spawn_Rate := StrToInt(sl.Values['Option_Mob_Spawn_Rate']);
                end else begin
                        Option_Mob_Spawn_Rate := 100;
                end;
	if sl.IndexOfName('Option_Pet_Capture_Rate') > -1 then begin
                        Option_Pet_Capture_Rate := StrToInt(sl.Values['Option_Pet_Capture_Rate']);
                end else begin
                        Option_Pet_Capture_Rate := 100;
                end;
    if sl.IndexOfName('Option_PVP_Steal') > -1 then begin
                        Option_PVP_Steal := StrToBool(sl.Values['Option_PVP_Steal']);
                end else begin
                        Option_PVP_Steal := False;
                end;
    if sl.IndexOfName('Option_PartyShare_Level') > -1 then begin
                        Option_PartyShare_Level := StrToInt(sl.Values['Option_PartyShare_Level']);
                end else begin
                        Option_PartyShare_Level := 10;
                end;
    if sl.IndexOfName('Option_GM_Logs') > -1 then begin
                        Option_GM_Logs := StrToBool(sl.Values['Option_GM_Logs']);
                end else begin
                        Option_GM_Logs := False;
                end;
    if sl.IndexOfName('Option_PVP_XPLoss') > -1 then begin
                        Option_PVP_XPLoss := StrToBool(sl.Values['Option_PVP_XPLoss']);
                end else begin
                        Option_PVP_XPLoss := True;
                end;

    if sl.IndexOfName('Option_FireWall_Cap') > -1 then begin
                        Option_FireWall_Cap := StrToInt(sl.Values['Option_FireWall_Cap']);
                end else begin
                        Option_FireWall_Cap := 3;
                end;
    if sl.IndexOfName('Option_IceWall_Cap') > -1 then begin
                        Option_IceWall_Cap := StrToInt(sl.Values['Option_IceWall_Cap']);
                end else begin
                        Option_IceWall_Cap := 3;
                end;

    if sl.IndexOfName('Option_Packet_Out') > -1 then begin
        try
            Option_Packet_Out := StrToBool(sl.Values['Option_Packet_Out']);
        except
            on EConvertError do Option_Packet_Out := True;
        end;
    end else begin
        Option_Packet_Out := False;
    end;

                sl.Clear;
                sl1.Clear;

                ini.ReadSectionValues('MySQL Server', sl);
                if sl.IndexOfName('Option_MySQL') <> -1 then begin
                    UseSQL := StrToBool(sl.Values['Option_MySQL']);
                end else begin
                    UseSQL := false;
                end;

                sl1.Delimiter := '.';
                sl1.DelimitedText := sl.Values['MySQL_Address'];

                if sl1.Count = 4 then begin
                    DbHost := sl.Values['MySQL_Address'];
                end else begin
                    DbHost := '127.0.0.1';
                end;
                sl1.Free;

                if sl.IndexOfName('MySQL_Username') <> -1 then begin
                    DbUser := sl.Values['MySQL_Username'];
                end else begin
                    DbUser := 'root';
                end;

                if sl.IndexOfName('MySQL_Password') <> -1 then begin
                    DbPass := sl.Values['MySQL_Password'];
                end else begin
                    DbPass := '';
                end;

                if sl.IndexOfName('MySQL_Database') <> -1 then begin
                    DbName := sl.Values['MySQL_Database'];
                end else begin
                    DbName := 'FusionSQL';
                end;

                sl.clear;

	ini.ReadSectionValues('Option', sl);

	if sl.IndexOfName('Left') <> -1 then begin
		FormLeft := StrToInt(sl.Values['Left']);
	end else begin
		FormLeft := 0;
	end;
	Left := FormLeft;
	if sl.IndexOfName('Top') <> -1 then begin
		FormTop := StrToInt(sl.Values['Top']);
	end else begin
		FormTop := 0;
	end;
	Top := FormTop;
	if sl.IndexOfName('Width') <> -1 then begin
		FormWidth := StrToInt(sl.Values['Width']);
	end else begin
		FormWidth := frmMain.Width;
	end;
	Width := FormWidth;
	if sl.IndexOfName('Height') <> -1 then begin
		FormHeight := StrToInt(sl.Values['Height']);
	end else begin
		FormHeight := frmMain.Height;
	end;
	Height := FormHeight;
	if sl.IndexOfName('Priority') <> -1 then begin
		Priority := StrToInt(sl.Values['Priority']);
		if Priority > 5 then Priority := 3;
	end else begin
		Priority := 1;
	end;
	if sl.IndexOfName('GMCheck') <> -1 then begin
		GMCheck := StrToIntDef(sl.Values['GMCheck'],0);
	end else begin
		GMCheck := $FF;
	end;
	SL.Clear;

	//Darkhelmet's Toys
	ini.ReadSectionValues('Toys', sl);
	if sl.IndexOfName('EnabledUWarp') <> -1 then begin
		WarpEnabled := StrToBool(sl.Values['EnabledUWarp']);
	end else begin
		WarpEnabled := False;
	end;
	if sl.IndexOfName('EUWarpItem') <> -1 then begin
		WarpItem := StrToInt(sl.Values['EUWarpItem']);
	end else begin
		WarpItem := 0;
	end;
  //Krietor's Request by Darkhelmet
  //  Designed for pvp, a range of items a character will drop when killed
  if sl.IndexOfName('DeathdropS') <> - 1 then begin  //Start Range
    StartDeathDropItem := StrToInt(sl.Values['DeathdropS']);
  end else begin
    StartDeathDropItem := 0;
  end;
  if sl.IndexOfName('DeathDropE') <> -1 then begin  //End Range
    EndDeathDropItem := StrToInt(sl.Values['DeathdropE']);
  end else begin
    EndDeathDropItem := 0;
  end;
  //Krietor's Request, Token Drops by Darkhelmet
  if sl.IndexOfName('DropToken') <> -1 then begin
    TokenDrop := StrToBool(sl.Values['DropToken']);
  end else begin
    TokenDrop := false;
  end;
  if sl.IndexOfName('MapUnloadTime') <> -1 then begin   //Time To Unload a map in minutes
    MapUnloadTime := StrToInt(sl.Values['MapUnloadTime']);
  end else begin
    MapUnloadTime := 0;
  end;

	{ChrstphrR 2004/05/09 - Debug section added to INI file
	Controls options that allow/supress when errors occur - these features
	will be useful to Devs in Core/DB/Scripts, and people modifying both
	Database and Script files for testing.}
	SL.Clear;
	ini.ReadSectionValues('Debug', SL);
	{Current Options:
	ShowDebugErrors - boolean, default False - if true, outputs error messages
	during Script Validation phase of MapLoad
	}
	if SL.IndexOfName('ShowDebugErrors') <> -1 then begin
		ShowDebugErrors := StrToBool(SL.Values['ShowDebugErrors']);
	end else begin
		ShowDebugErrors := False;
	end;


	//cbxPriority.ItemIndex := Priority;
  case Priority of
	0: 		PriorityClass := REALTIME_PRIORITY_CLASS;
	1: 		PriorityClass := HIGH_PRIORITY_CLASS;
	2: 		PriorityClass := ABOVE_NORMAL_PRIORITY_CLASS;
	3: 		PriorityClass := NORMAL_PRIORITY_CLASS;
	4: 		PriorityClass := BELOW_NORMAL_PRIORITY_CLASS;
	5: 		PriorityClass := IDLE_PRIORITY_CLASS;
	else
		begin
			Priority := 3;
			PriorityClass := NORMAL_PRIORITY_CLASS;
		end;
	end;

	SetPriorityClass(GetCurrentProcess(), PriorityClass);



        a := strtoint(floattostr(hextoint(copy(Option_Back_Color, 1, 2))));
        b := strtoint(floattostr(hextoint(copy(Option_Back_Color, 3, 2))));
        c := strtoint(floattostr(hextoint(copy(Option_Back_Color, 5, 2))));
        txtDebug.Color := RGB(a, b, c);

        a := strtoint(floattostr(hextoint(copy(Option_Font_Color, 1, 2))));
        b := strtoint(floattostr(hextoint(copy(Option_Font_Color, 3, 2))));
        c := strtoint(floattostr(hextoint(copy(Option_Font_Color, 5, 2))));
        txtDebug.Font.Color := RGB(a, b, c);

        txtDebug.Font.Name := Option_Font_Face;
        txtDebug.Font.Size := Option_Font_Size;

        txtDebug.Font.Style := [];
        for a := 1 to length(Option_Font_Style) do begin
                if (copy(Option_Font_Style,a,1)) = 'B' then begin
                        txtDebug.Font.Style := txtDebug.Font.Style + [fsBold];
                end else if (copy(Option_Font_Style,a,1)) = 'I' then begin
                        txtDebug.Font.Style := txtDebug.Font.Style + [fsItalic];
                end else if (copy(Option_Font_Style,a,1)) = 'U' then begin
                        txtDebug.Font.Style := txtDebug.Font.Style + [fsUnderline];
                end else if (copy(Option_Font_Style,a,1)) = 'S' then begin
                        txtDebug.Font.Style := txtDebug.Font.Style + [fsStrikeOut];
                end;
        end;


	ini.Free;
	SL.Free;

	Show;

	//ÉfÅ[É^ì«Ç›çûÇ›
	DatabaseLoad(Handle);
	if UseSQL then
		SQLDataLoad()
	else
	DataLoad();


	//MapLoad('moc_vilg00');
	//MapLoad('moc_vilg01');

        debugout.lines.add('[' + TimeToStr(Now) + '] ' + '');
	debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Startup Success.');
        //DebugOut.Lines.SaveToFile('StartupLog.txt');

        //DebugOut.Lines.LoadFromFile('Fusion.notice');

        debugout.lines.add('[' + TimeToStr(Now) + '] ' + '');
        debugout.lines.add('[' + TimeToStr(Now) + '] ' + '--- Fusion '+ RELEASE_VERSION +' ---');
        debugout.lines.add('[' + TimeToStr(Now) + '] ' + '--- Command Output Begin ---');
        debugout.lines.add('[' + TimeToStr(Now) + '] ' + '');

	cmdStart.Enabled := true;

	//cbxPriorityClick(Sender);
	if AutoStart then PostMessage(cmdStart.Handle, BM_CLICK, 0, 0);
{U0x003b}
	DBsaveTimer.Enabled := True;
    DBSaveTimer.Interval := Option_AutoSave * 1000;

    if (Option_AutoBackup = 0) then begin
        BackupTimer.Enabled := False;
    end
    else begin
        BackupTimer.Enabled := True;
        BackupTimer.Interval := Option_AutoBackup * 1000;
    end;

    if (Option_DNS_Update = 0) then begin
        DNSUpdateTimer.Enabled := False;
    end
    else begin
        DNSUpdateTimer.Enabled := True;
        DNSUpdateTimer.Interval := Option_DNS_Update * 1000;
    end;


    if (Option_Enable_ISCS) then frmMain.ConnecttoISCS1Click(self);


{U0x003bÉRÉRÇ‹Ç≈}
end;
//------------------------------------------------------------------------------
procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
	sr  : TSearchRec;
	Idx : Integer; // Loop Iterator for freeing our global lists.
begin

    destroy_wac(True);
	save_commands();

    if (Option_Use_UPnP) then begin
        destroy_upnp(sv1port);
        destroy_upnp(sv2port);
        destroy_upnp(sv3port);
    end;

	if FindFirst(AppPath + 'map\tmpFiles\*.out', $27, sr) = 0 then begin
		repeat
			DeleteFile(AppPath+'map\tmpFiles\'+sr.Name);
		until FindNext(sr) <> 0;
		FindClose(sr);
	end;

	if ServerRunning then begin
		cmdStop.Enabled := false;
		CancelFlag := true;
		repeat
			Application.ProcessMessages;
		until ServerRunning;
	end;

	if WindowState = wsNormal then begin
		FormLeft := Left;
		FormTop := Top;
		FormWidth := Width;
		FormHeight := Height;
	end;

    weiss_ini_save();

	if UseSQL then
		SQLDataSave
	else
		DataSave(false);

	{ Mitch: Doesnt hurt to make sure the tray icon was deleted }
	Shell_notifyIcon(NIM_DELETE, @TrayIcon);


    //---- We need to clear this memory in a CLEAN way once and for all ----//
    fnl_lists(ScriptList, nil);
    fnl_lists(ItemDBName, ItemDB);
    fnl_lists(nil, MaterialDB);
    fnl_lists(MobDBName, MobDB);
    fnl_lists(nil, MArrowDB);
    fnl_lists(WarpDatabase, nil);
    fnl_lists(nil, MobAIDB);
    fnl_lists(nil, MobAIDBFusion);
    fnl_lists(GlobalVars, nil);
    fnl_lists(nil, IDTableDB);
    fnl_lists(SlaveDBName, nil);
    fnl_lists(SkillDBName, SkillDB);
    fnl_lists(PlayerName, Player);
    fnl_lists(CharaName, Chara);
    //fnl_lists(nil, CharaPID);
    FreeAndNil(CharaPID);
    fnl_lists(nil, ChatRoomList);
    fnl_lists(PartyNameList, PartyList);
    fnl_lists(CastleList, nil);
    fnl_lists(TerritoryList, nil);
    fnl_lists(EmpList, nil);
    fnl_lists(nil, PetDB);
    fnl_lists(nil, PetList);
    fnl_lists(nil, VenderList);
    fnl_lists(nil, DealingList);
    fnl_lists(SummonMobListMVP, nil);
    fnl_lists(SummonIOBList, nil);
    fnl_lists(SummonIOVList, nil);
    fnl_lists(SummonICAList, nil);
    fnl_lists(SummonIGBList, nil);
    fnl_lists(SUmmonIOWBList, nil);
    fnl_lists(ServerFlag, nil);
    fnl_lists(nil, GuildList);
    fnl_lists(nil, GSkillDB);
    fnl_lists(Map, nil);
    fnl_lists(MapInfo, nil);
    fnl_lists(MapList, nil);
    fnl_lists(BanList, nil);

    FreeAndNil(SummonMobList);
    //---- The rest is the dirty shit commented out in case I need it ----//





	{SummonMobList.Free;  //ChrstphrR - 2004/04/19 - This list is now leak free.
	SummonMobListMVP.Free;} {CR - empty list 2004/04/23 - leaving be}

	{ChrstphrR 2004/04/26 -- Summon???Lists cleaned up here by converting them to
	TStringLists -- now instead of using a TIntList32 that was:
	- storing an integer the same number as the index of the nodes in Integers[]
	- storing a string in a TObject (think, tossing a dime into a fridge)
	- failing to free the strings AND the Objects when cleaning up...
	Now we have a semi-inefficient StringLists that are used for random item
	generation when someone uses a Old Blue Box, etc.  This is a compromise data
	structure until I make them equivalent to the TRandList derived objects that
	TSummonMobList is.
	}
	{SummonIOBList.Free; //Changed to TStringList
	SummonIOVList.Free; //" " "
	SummonICAList.Free; //" " "
	SummonIGBList.Free; //" " "
	SummonIOWBList.Free;//" " "}
{éÅ{î†í«â¡ÉRÉRÇ‹Ç≈}
{NPCÉCÉxÉìÉgí«â¡}
	//ServerFlag.Free;//Strings Only List - safe as is.


	{ChrstphrR 2004/04/27 -- I'm pretty sure this cleans up the 4k a bare Delphi
	app leaks because code in the RTL that Borland hasn't fixed - Bravo!}


    { Alex: This is really bizarre. The scriptlist is created on form create
      thus freeing it at this point should not give an access violation.
      Oh well, I'll put the try-except-end around it just to prevent crashes. }
    {try
    	ScriptList.Free; //CR only stores strings, ergo safe as is.
    except
    end;}

	{ChrstphrR 2004/04/27 - My apologies for such dirty fixes to the lists ...
	Objects[] of a TSL or TIL are not freed up on Clear or Free, so the following
	for loops do so safely and properly - the Assigned() checks ensure that the
	object isn't NIL -- freeing NIL is one of those Zen riddles you just don't
	want to toy with in Delphi!  The Lists are grouped with some not looped
	through, because there often pairs or groups of lists that index the same
	list of objects. Pure StringLists / IntLists are just free'd and are marked
	explicitly.}

	{for Idx := ItemDB.Count - 1 downto 0 do begin
        try
            if Assigned(ItemDB.Objects[Idx]) then (ItemDB.Objects[Idx] AS TItemDB).Free;
        except
            on EAccessViolation do Continue;
        end;
    end;

    try
    	ItemDB.Free; //CR - Frees up 1.4Mb properly on close down that is leaked.
	    ItemDBName.Free;
    except
        on EAccessViolation do ;
    end;}

{ÉAÉCÉeÉÄêªë¢í«â¡}



	{for Idx := MaterialDB.Count-1 downto 0 do
		if Assigned(MaterialDB.Objects[Idx]) then
			(MaterialDB.Objects[Idx] AS TMaterialDB).Free;
	MaterialDB.Free;

{ÉAÉCÉeÉÄêªë¢í«â¡ÉRÉRÇ‹Ç≈}
	{for Idx := MobDB.Count-1 downto 0 do
		if Assigned(MobDB.Objects[Idx]) then
			(MobDB.Objects[Idx] AS TMobDB).Free;
	MobDB.Free;
	MobDBName.Free;}

	{for Idx := MArrowDB.Count-1 downto 0 do
		if Assigned(MArrowDB.Objects[Idx]) then
			(MArrowDB.Objects[Idx] AS TMArrowDB).Free;
	MArrowDB.Free;}

	{for Idx := WarpDatabase.Count-1 downto 0 do
		if Assigned(WarpDatabase.Objects[Idx]) then
			(WarpDatabase.Objects[Idx] AS TWarpDatabase).Free;
	WarpDatabase.Free;}

	//MobAIDB.Free; //CR - Empty list.

	{for Idx := MobAIDBFusion.Count-1 downto 0 do
		if Assigned(MobAIDBFusion.Objects[Idx]) then
			(MobAIDBFusion.Objects[Idx] AS TMobAIDBFusion).Free;
	MobAIDBFusion.Free;}

	//GlobalVars.Free;
	//PharmacyDB.Free;

	{for Idx := IDTableDB.Count-1 downto 0 do
		if Assigned(IDTableDB.Objects[Idx]) then
			(IDTableDB.Objects[Idx] AS TIDTbl).Free;
	IDTableDB.Free;}

	{for Idx := SlaveDBName.Count-1 downto 0 do
		if Assigned(SlaveDBName.Objects[Idx]) then
			(SlaveDBName.Objects[Idx] AS TSlaveDB).Free;
	SlaveDBName.Free;}

	//CR - both of these are the same count, same objects - free objects on one
	// and leave the other objects[] list alone - only free the object once!! :)
	{for Idx := SkillDB.Count-1 downto 0 do
		if Assigned(SkillDB.Objects[Idx]) then
			(SkillDB.Objects[Idx] AS TSkillDB).Free;
	SkillDB.Free;
	SkillDBName.Free;}

	{for Idx := Player.Count-1 downto 0 do
		if Assigned(Player.Objects[Idx]) then
			(Player.Objects[Idx] AS TPlayer).Free;
	Player.Free;
	PlayerName.Free;}

	{for Idx := Chara.Count-1 downto 0 do
		if Assigned(Chara.Objects[Idx]) then
			(Chara.Objects[Idx] AS TChara).Free;
	Chara.Free;
	CharaName.Free;
	CharaPID.Free;}
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡}
	{for Idx := ChatRoomList.Count-1 downto 0 do
		if Assigned(ChatRoomList.Objects[Idx]) then
			(ChatRoomList.Objects[Idx] AS TChatRoom).Free;
	ChatRoomList.Free;}
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡ÉRÉRÇ‹Ç≈}
{ÉpÅ[ÉeÉBÅ[ã@î\í«â¡}
	{for Idx := PartyNameList.Count-1 downto 0 do
		if Assigned(PartyNameList.Objects[Idx]) then
			(PartyNameList.Objects[Idx] AS TParty).Free;
	PartyNameList.Free;}

	{for Idx := CastleList.Count-1 downto 0 do
		if Assigned(CastleList.Objects[Idx]) then
			(CastleList.Objects[Idx] AS TCastle).Free;
	CastleList.Free;}

	{for Idx := TerritoryList.Count-1 downto 0 do
		if Assigned(TerritoryList.Objects[Idx]) then
			(TerritoryList.Objects[Idx] AS TTerritoryDB).Free;
	TerritoryList.Free;}

	{for Idx := EmpList.Count-1 downto 0 do
		if Assigned(EmpList.Objects[Idx]) then
			(EmpList.Objects[Idx] AS TEmp).Free;
	EmpList.Free;}
{ÉpÅ[ÉeÉBÅ[ã@î\í«â¡ÉRÉRÇ‹Ç≈}
{ÉLÉÖÅ[ÉyÉbÉg}
	{for Idx := PetDB.Count-1 downto 0 do
		if Assigned(PetDB.Objects[Idx]) then
			(PetDB.Objects[Idx] AS TPetDB).Free;
	PetDB.Free;}

	{for Idx := PetList.Count-1 downto 0 do
		if Assigned(PetList.Objects[Idx]) then
			(PetList.Objects[Idx] AS TPet).Free;
	PetList.Free;}
{ÉLÉÖÅ[ÉyÉbÉgÇ±Ç±Ç‹Ç≈}
{òIìXÉXÉLÉãí«â¡}
	{for Idx := VenderList.Count-1 downto 0 do
		if Assigned(VenderList.Objects[Idx]) then
			(VenderList.Objects[Idx] AS TVender).Free;
	VenderList.Free;}
{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}
{éÊà¯ã@î\í«â¡}

	{for Idx := DealingList.Count-1 downto 0 do
		if Assigned(DealingList.Objects[Idx]) then
			(DealingList.Objects[Idx] AS TDealings).Free;
	DealingList.Free;}
{éÊà¯ã@î\í«â¡ÉRÉRÇ‹Ç≈}
{éÅ{î†í«â¡}
	{SummonMobList.Free;  //ChrstphrR - 2004/04/19 - This list is now leak free.
	SummonMobListMVP.Free;} {CR - empty list 2004/04/23 - leaving be}

	{ChrstphrR 2004/04/26 -- Summon???Lists cleaned up here by converting them to
	TStringLists -- now instead of using a TIntList32 that was:
	- storing an integer the same number as the index of the nodes in Integers[]
	- storing a string in a TObject (think, tossing a dime into a fridge)
	- failing to free the strings AND the Objects when cleaning up...
	Now we have a semi-inefficient StringLists that are used for random item
	generation when someone uses a Old Blue Box, etc.  This is a compromise data
	structure until I make them equivalent to the TRandList derived objects that
	TSummonMobList is.
	}
	{SummonIOBList.Free; //Changed to TStringList
	SummonIOVList.Free; //" " "
	SummonICAList.Free; //" " "
	SummonIGBList.Free; //" " "
	SummonIOWBList.Free;//" " "}
{éÅ{î†í«â¡ÉRÉRÇ‹Ç≈}
{NPCÉCÉxÉìÉgí«â¡}
	//ServerFlag.Free;//Strings Only List - safe as is.

{NPCÉCÉxÉìÉgí«â¡ÉRÉRÇ‹Ç≈}
{ÉMÉãÉhã@î\í«â¡}
	{for Idx := GuildList.Count-1 downto 0 do
		if Assigned(GuildList.Objects[Idx]) then
			(GuildList.Objects[Idx] AS TGuild).Free;
	GuildList.Free;}

	//Static list loaded up at beginning, need to free properly at the end.
	{for Idx := GSkillDB.Count-1 downto 0 do
		if Assigned(GSkillDB.Objects[Idx]) then
			(GSkillDB.Objects[Idx] AS TSkillDB).Free;
	GSkillDB.Free;}
{ÉMÉãÉhã@î\í«â¡ÉRÉRÇ‹Ç≈}
	{ChrstphrR 2004/04/23 - Runtime list, Map list is filled up as characters
	move about in the game}
	{for Idx := Map.Count-1 downto 0 do
		if Assigned(Map.Objects[Idx]) then
			(Map.Objects[Idx] AS TMap).Free;
	Map.Free;}

	{for Idx := MapInfo.Count-1 downto 0 do
		if Assigned(MapInfo.Objects[Idx]) then
			(MapInfo.Objects[Idx] AS MapTbl).Free;
	MapInfo.Free;

	for Idx := MapList.Count-1 downto 0 do
		if Assigned(MapList.Objects[Idx]) then
			(MapList.Objects[Idx] AS TMapList).Free;
	MapList.Free;}
end;//proc TfrmMain.FormCloseQuery()
//------------------------------------------------------------------------------

procedure TfrmMain.FormResize(Sender: TObject);
begin
	Perform(WM_NCACTIVATE, Word(Active), 0);
	if WindowState = wsNormal then begin
		FormLeft := Left;
		FormTop := Top;
		FormWidth := Width;
		FormHeight := Height;
	end;
	StatusBar1.Panels[1].Width := 300;
	StatusBar1.Panels[0].Width := FormWidth - 300;
	// Keep the timer portion of the panels the same.
end;

//------------------------------------------------------------------------------
procedure TfrmMain.PriorityUpdate(prioramount : Integer);
var
	PriorityClass	:cardinal;
begin
	case prioramount of
	0: 		PriorityClass := REALTIME_PRIORITY_CLASS;
	1: 		PriorityClass := HIGH_PRIORITY_CLASS;
	2: 		PriorityClass := ABOVE_NORMAL_PRIORITY_CLASS;
	3: 		PriorityClass := NORMAL_PRIORITY_CLASS;
	4: 		PriorityClass := BELOW_NORMAL_PRIORITY_CLASS;
	5: 		PriorityClass := IDLE_PRIORITY_CLASS;
	else
		begin
			Priority := 3;
			PriorityClass := NORMAL_PRIORITY_CLASS;
		end;
	end;

	SetPriorityClass(GetCurrentProcess(), PriorityClass);
end;
//==============================================================================





//==============================================================================
// ****************************************************************************
// * SERVER 1 : LOGIN SERVER (Port 6900)                                      *
// ****************************************************************************
//==============================================================================
procedure TfrmMain.sv1ClientConnect(Sender: TObject;
	Socket: TCustomWinSocket);
begin
	//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Socket.RemoteAddress + ': Login Server -> Connect');
end;
//------------------------------------------------------------------------------
procedure TfrmMain.sv1ClientDisconnect(Sender: TObject;
	Socket: TCustomWinSocket);
begin
	//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Socket.RemoteAddress + ': Login Server -> Disconnect');
end;
//------------------------------------------------------------------------------
procedure TfrmMain.sv1ClientError(Sender: TObject;
	Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
	var ErrorCode: Integer);
begin
    { Alex: Server owners do not need to see this. It'll make them
    think something is wrong and start bitching.
        debugout.lines.add('[' + TimeToStr(Now) + '] ' + Socket.RemoteAddress + ': Login Server -> Player has been disconnected from server. Player did not exit via Exit button');
    }
	if ErrorCode = 10053 then Socket.Close;
	ErrorCode := 0;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.sv1ClientRead(Sender: TObject; Socket: TCustomWinSocket);
begin
	try
	sv1PacketProcess(Socket);
  except
    exit;
  end;
end;
//==============================================================================










//==============================================================================
// ****************************************************************************
// * SERVER 2 : CHARA SERVER (Port 6121)                                      *
// ****************************************************************************
//==============================================================================
procedure TfrmMain.sv2ClientConnect(Sender: TObject;
	Socket: TCustomWinSocket);
begin
        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Socket.RemoteAddress + ': Character Server -> Connect');
end;
//------------------------------------------------------------------------------
procedure TfrmMain.sv2ClientDisconnect(Sender: TObject;
	Socket: TCustomWinSocket);
begin
        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Socket.RemoteAddress + ': Character Server -> Disconnect');
end;
//------------------------------------------------------------------------------
procedure TfrmMain.sv2ClientError(Sender: TObject;
	Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
	var ErrorCode: Integer);
begin
    { Alex: Server owners do not need to see this. It'll make them
    think something is wrong and start bitching.
        debugout.lines.add('[' + TimeToStr(Now) + '] ' + Socket.RemoteAddress + ': Character Server -> Player has been disconnected from server. Player did not exit via Exit button');
    }
	if ErrorCode = 10053 then Socket.Close;
	ErrorCode := 0;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.sv2ClientRead(Sender: TObject;
	Socket: TCustomWinSocket);
begin
	try
	sv2PacketProcess(Socket);
	except
		exit;
	end;
end;
//==============================================================================




//==============================================================================
// ****************************************************************************
// * SERVER 3 : GAME SERVER (Port 5121)                                       *
// ****************************************************************************
//==============================================================================
procedure TfrmMain.sv3ClientConnect(Sender: TObject;
	Socket: TCustomWinSocket);
begin
	//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Socket.RemoteAddress + ': Game Server -> Connect');
	NowUsers := sv3.Socket.ActiveConnections;
        statusbar1.Panels.Items[0].Text := ' Users Online: ' +inttostr(NowUsers); // AlexKreuz (Status Bar)
end;
//------------------------------------------------------------------------------
procedure TfrmMain.sv3ClientDisconnect(Sender: TObject;
	Socket: TCustomWinSocket);
var
	tc  :TChara;
	tp  :TPlayer;
    tm  :TMap;

	i,j :integer;
	mi  :MapTbl;

begin

    iscs_console_disconnect(Socket.Data);
    DataSave();

    if Assigned(Socket.Data) then begin
        tc := Socket.Data;
        tm := tc.MData;
        SendCLeave(tc, 2);

        if MapInfo.IndexOf(tc.Map) <> -1 then begin
            i := MapInfo.IndexOf(tc.Map);
            j := -1;

            if (i <> -1) then begin
                mi := MapInfo.Objects[i] as MapTbl;
                if (mi.noSave = true) then j := 0;
            end;

        	if (tc.Sit = 1) or (j = 0) then begin
                tc.Map := tc.SaveMap;
                tc.Point.X := tc.SavePoint.X;
                tc.Point.Y := tc.SavePoint.Y;
            end;

            tc.Login := 0;
            tp := tc.PData;
            tp.Login := false;

            if UseSQL then SQLDataSave();
        end;
    end;

    tc.OnTouchIDs.Free;

    NowUsers := sv3.Socket.ActiveConnections;
    if NowUsers > 0 then Dec(NowUsers);

    statusbar1.Panels.Items[0].Text := ' Users Online: ' +inttostr(NowUsers);

    // Already calculated in SendCLeave above.
    // Can't recalculate because SendCLeave deleted the tm.CList.
    // if mi.PvP then CalcPvPRank(tm);

end;
//------------------------------------------------------------------------------
procedure TfrmMain.sv3ClientError(Sender: TObject;
	Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
	var ErrorCode: Integer);
begin

    iscs_console_disconnect(Socket.Data);
    DataSave();

	if UseSQL then SQLDataSave();

    //DebugOut.Lines.Add(Socket.RemoteAddress + ': Game Server -> Error: ' + inttostr(ErrorCode));
	if ErrorCode = 10053 then Socket.Close;
	if ErrorCode = 10054 then Socket.Close;

	ErrorCode := 0;
	NowUsers := sv3.Socket.ActiveConnections;
end;

//------------------------------------------------------------------------------
procedure TfrmMain.sv3ClientRead(Sender: TObject;
	Socket: TCustomWinSocket);
begin
        try
	        sv3PacketProcess(Socket);
        except
                exit;
        end;
end;
//==============================================================================










//==============================================================================
{
ChrstphrR 2004/04/27
- unused var cleanup
- Checked for memory leaks - no obvious ones.
}
procedure TFrmMain.MonsterSpawn(tm:TMap; ts:TMob; Tick:cardinal);
var
	i, j, k : Integer;
	tc      : TChara;

begin
	//Repeat until Spawn Point chosen.
	repeat
		ts.Point.X := ts.Point1.X + Random(ts.Point2.X + 1) - (ts.Point2.X div 2);
		ts.Point.Y := ts.Point1.Y + Random(ts.Point2.Y + 1) - (ts.Point2.Y div 2);
		if (ts.Point.X < 0) or (ts.Point.X > tm.Size.X - 2) or (ts.Point.Y < 0) or (ts.Point.Y > tm.Size.Y - 2) then begin
			if ts.Point.X < 0 then ts.Point.X := 0;
			if ts.Point.X > tm.Size.X - 2 then ts.Point.X := tm.Size.X - 2;
			if ts.Point.Y < 0 then ts.Point.Y := 0;
			if ts.Point.Y > tm.Size.Y - 2 then ts.Point.Y := tm.Size.Y - 2;
		end;
	until ( (tm.gat[ts.Point.X, ts.Point.Y] <> 1) and (tm.gat[ts.Point.X, ts.Point.Y] <> 5) );
	{ChrstphrR  2004/04/27 - This spawning code is pretty common...
	could it be made into a function call and spare everyone the complexity?
	... and is this an efficient algorithm for picking a random point?
	}

	ts.Dir := Random(8);
	ts.HP := ts.Data.HP;
	if ts.Data.isDontMove then
		ts.MoveWait := $FFFFFFFF
	else

    ts.MoveWait := Tick + 5000 + Cardinal(Random(10000));
	ts.Speed := ts.Data.Speed;
	ts.ATarget := 0;
	ts.ARangeFlag := false;
	ts.ATKPer := 100;
	ts.DEFPer := 100;
	ts.DmgTick := 0;
	ts.Status := 'IDLE_ST';
    ts.pcnt := 0;
	if ts.Data.Loaded = false then LoadMonsterAIData(tm, ts, Tick);
	for j := 0 to 31 do begin
		ts.EXPDist[j].CData := nil;
		ts.EXPDist[j].Dmg := 0;
	end;
	if ts.Data.MEXP <> 0 then begin
		for j := 0 to 31 do begin
			ts.MVPDist[j].CData := nil;
			ts.MVPDist[j].Dmg := 0;
		end;
		ts.MVPDist[0].Dmg := ts.Data.HP * 30 div 100; //FAÇ…30%â¡éZ
	end;

	tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);

	//Notify Nearby Characters that Monster has spawned
	for j := ts.Point.Y div 8 - 2 to ts.Point.Y div 8 + 2 do begin
		for i := ts.Point.X div 8 - 2 to ts.Point.X div 8 + 2 do begin
			//é¸ÇËÇÃêlÇ…í ím
			for k := 0 to tm.Block[i][j].CList.Count - 1 do begin
				tc := tm.Block[i][j].CList.Objects[k] as TChara;
				if tc = nil then continue;
				if (abs(ts.Point.X - tc.Point.X) < 16) and (abs(ts.Point.Y - tc.Point.Y) < 16) then begin
					SendMData(tc.Socket, ts);
				end;
			end;//for k1
		end;//for i1
	end;//for j1

	if (MonsterMob = true) then begin
		k := SlaveDBName.IndexOf(ts.Data.Name);
		if (k <> -1) then begin
			ts.isLeader := true;
		end;
	end;
end;//proc TFrmMain.MonsterSpawn()
//------------------------------------------------------------------------------

{Spawn Slave Monster}
procedure TFrmMain.MobSpawn(tm:TMap; ts:TMob; Tick:cardinal);
var
	i, j, k, h, m : Integer;
	tc            : TChara;
	ts1           : TMob;
	tss           : TSlaveDB;

begin

	if (MonsterMob = true) then begin
		k := SlaveDBName.IndexOf(ts.Data.Name);
		if (k <> -1) then begin
			ts.isLeader := true;
			tss := SlaveDBName.Objects[k] as TSlaveDB;
			if ts.Data.Name = tss.Name then begin

				h := tss.TotalSlaves;
				ts.SlaveCount := h;

				repeat
					for i := 0 to 4 do begin
						if (tss.Slaves[i] <> -1) and (h <> 0) then begin
							ts1 := TMob.Create;
							ts1.Data := MobDBName.Objects[tss.Slaves[i]] as TMobDB;
							ts1.ID := NowMobID;
							Inc(NowMobID);
							ts1.Name := ts1.Data.JName;
							ts1.JID := ts1.Data.ID;
							ts1.LeaderID := ts.ID;
							ts1.Data.isLink := false;
							ts1.Status := 'IDLE_ST';
							ts1.Map := ts.Map;
							ts1.Point.X := ts.Point.X;
							ts1.Point.Y := ts.Point.Y;
							ts1.Dir := ts.Dir;
							ts1.HP := ts1.Data.HP;
							if ts.Data.Speed < ts1.Data.Speed then begin
								ts1.Speed := ts.Data.Speed;
							end else begin
								ts1.Speed := ts1.Data.Speed;
							end;
							ts1.SpawnDelay1 := $7FFFFFFF;
							ts1.SpawnDelay2 := 0;
							ts1.SpawnType := 0;
							ts1.SpawnTick := 0;
							if ts1.Data.isDontMove then
								ts1.MoveWait := $FFFFFFFF
							else
								ts1.MoveWait := timeGetTime();
							ts1.ATarget := 0;
							ts1.ATKPer := 100;
							ts1.DEFPer := 100;
							ts1.DmgTick := 0;
							ts1.Element := ts1.Data.Element;
							ts1.isActive := false;
							for j := 0 to 31 do begin
								ts1.EXPDist[j].CData := nil;
								ts1.EXPDist[j].Dmg := 0;
							end;
							if ts1.Data.MEXP <> 0 then begin
								for j := 0 to 31 do begin
									ts1.MVPDist[j].CData := nil;
									ts1.MVPDist[j].Dmg := 0;
								end;
								ts1.MVPDist[0].Dmg := ts1.Data.HP * 30 div 100; //FAÇ…30%â¡éZ
							end;
							ts1.isSummon := true;
							ts1.isSlave  := true;
							tm.Mob.AddObject(ts1.ID, ts1);
							tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);

							for j := ts1.Point.Y div 8 - 2 to ts1.Point.Y div 8 + 2 do begin
								for m := ts1.Point.X div 8 - 2 to ts1.Point.X div 8 + 2 do begin
									//é¸ÇËÇÃêlÇ…í ím
									for k := 0 to tm.Block[m][j].CList.Count - 1 do begin
										tc := tm.Block[m][j].CList.Objects[k] as TChara;
										if tc = nil then continue;
										if (abs(ts1.Point.X - tc.Point.X) < 16) and (abs(ts1.Point.Y - tc.Point.Y) < 16) then begin
											SendMData(tc.Socket, ts1);
											SendBCmd(tm,ts1.Point,41,tc,False);
										end;
									end;
								end;
							end;
							h := h - 1;
						end;
					end;
				until (h <= 0);

			end;
		end;
	end;

end;
//------------------------------------------------------------------------------
procedure TFrmMain.MonsterDie(tm:TMap; tc:TChara; ts:TMob; Tick:cardinal);
var
	//Variable Declarations
	k,i,j,m,n:integer;
	total:cardinal;
    bonus:integer;
	mvpid:integer;
	mvpitem:boolean;
	mvpcheck:integer;
	i1,j1,k1:integer;
	L : Cardinal;
	w : Cardinal;
	TgtFlag:boolean;
	DropFlag:boolean;
	delcnt:integer;

	//Class Usage
	tc1:TChara;     {Player}
	ts1:TMob;       {Monster}
	tn:TNPC;        {NPC}
	td:TItemDB;     {Reads the Item Database}
	tpaDB:TStringList;
	tpa:TParty;     {Party Class}
	tg   : TGuild;    {Guild Glass}
	tgc  : TCastle;
	tt   : TTerritoryDB;
	tn1  : TNPC;
	ge   : Cardinal;

	//String Declarations
	str  : string;
	str2 : string;

begin
	UpdateMonsterDead(tm, ts, 1);
	{WFIFOW( 0, $0080);
	WFIFOL( 2, ts.ID);
	WFIFOB( 6, 1);
	SendBCmd(tm, ts.Point, 7);}

	delcnt := 0;                      // mf
	repeat                            // mf
		delcnt := delcnt + 1;           // mf
	until (DelPointX[delcnt] = 0) or (delcnt >= 999);      // mf
	DelPointX[delcnt] := ts.Point.X;  // mf
	DelPointY[delcnt] := ts.Point.Y;  // mf
	DelID[delcnt] := ts.ID;           // mf
	DelWait[delcnt] := ts.DeadWait;   // mf

	ts.HP := 0;
	ts.pcnt := 0;

	ts.Stat1 :=0;
	ts.Stat2 :=0;
	ts.nStat := 0;
	ts.Element := ts.Data.Element;
	ts.BodyTick := 0;
	for i := 0 to 4 do
		ts.HealthTick[i] := 0;
	ts.isLooting := False;
	ts.Status := 'DEAD_ST';


	ts.SpawnTick := Tick;

	n := tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.IndexOf(ts.ID);
	if n = -1 then Exit;//safe 2004/04/26

	if ts.isSlave then begin
		ts1 := tm.Mob.IndexOfObject(ts.LeaderID) as TMob;
		if (ts1 <> nil) then begin
			if (ts1.SlaveCount - 1 <= 0) then begin
				ts1.SlaveCount := 0;
			end else begin
				ts1.SlaveCount := ts1.SlaveCount - 1;
			end;
		end;
	end;

	if (ts.isEmperium) then begin

		j := GuildList.IndexOf(tc.GuildID);
		m := TerritoryList.IndexOf(ts.Map);
		if (j <> -1) and (m <> -1) then begin
			tg := GuildList.Objects[j] as TGuild;
			tt := TerritoryList.Objects[m] as TTerritoryDB;
			str := GlobalGMsg;

			str := StringReplace(str, '$charaname', tc.Name, [rfReplaceAll]);
			str := StringReplace(str, '$mapname', ts.Map, [rfReplaceAll]);
			str := StringReplace(str, '$castlename', tt.TerritoryName, [rfReplaceAll]);
			str := StringReplace(str, '$guildname', tg.Name, [rfReplaceAll]);
			str := StringReplace(str, '$guildmaster', tg.MasterName, [rfReplaceAll]);
		end else begin
			str := MapGMsg;
		end;

		str2 :='blue' + MapGMsg;
		//str := StringReplace(str, '$charaname', tc.Name, [rfReplaceAll]);
		//str := StringReplace(str, '$mapname', ts.Map, [rfReplaceAll]);
		//str := StringReplace(str, '$guildname', tg.Name, [rfReplaceAll]);
		//str := StringReplace(str, '$guildmaster', tg.MasterName, [rfReplaceAll]);

		w := Length(str) + 4;
		WFIFOW(0, $009a);
		WFIFOW(2, w);
		WFIFOS(4, str, w - 4);

		for l := 0 to CharaName.Count - 1 do begin
			tc1 := CharaName.Objects[l] as TChara;
			if tc1.Login = 2 then tc1.Socket.SendBuf(buf, w);
		end;

		w := Length(str) + 4;
		WFIFOW(0, $009a);
		WFIFOW(2, w);
		WFIFOS(4, str2, w - 4);

		for l := 0 to tm.CList.Count - 1 do begin
			tc1 := tm.CList.Objects[l] as TChara;
			if (tc1.Login = 2) then tc1.Socket.SendBuf(buf, w);
		end;

		if (EmpList.Count > 0) then begin
			k := EmpList.IndexOf(ts.Map);
			if (k > - 1) then begin
				EmpList.Objects[k].Free;
				EmpList.Delete(k);
			end;
		end;

		if (CastleList.Count > 0) then begin
			m := CastleList.IndexOf(ts.Map);
			if (m > - 1) then begin
				CastleList.Objects[m].Free;
				CastleList.Delete(m);
			end;
		end;

		{Colus, 20040113: Set territory for the guild (not done in real RO!  BAH!}
		{I will replace this with something that parses the guild bases in
		ClaimGuildCastle.}
		//tg.Agit := tm.Name;

		ClaimGuildCastle(tc.GuildID,ts.Map);
		EnableGuildKafra(ts.Map,'Kafra Service',0);

		for l := 0 to CharaName.Count - 1 do begin
			tc1 := CharaName.Objects[l] as TChara;
			if (tc1.Map = tm.Name) AND (tc1.Login = 2) AND
			   ((tc1.GuildID = 0) OR (tc1.GuildID <> tc.GuildID))then begin
				SendCLeave(tc1, 2);
				tc1.tmpMap := tc1.SaveMap;
				tc1.Map := tc1.SaveMap;
				tc1.Point := tc1.SavePoint;
				MapMove(tc1.Socket, tc1.Map, tc1.Point);
			end;
		end;
	end;


	if (ts.NPCID > 0) then begin
		tn := tm.NPC.IndexOfObject(ts.NPCID) as TNPC;
		tc1 := TChara.Create;
		tc1.TalkNPCID := 0;
		tc1.ScriptStep := tn.ScriptInitMS;
		tc1.AMode := 3;
		tc1.AData := tn;
		tc1.Login := 0;
		NPCScript(tc1,0,1);
		tc1.Free;
		ts.NPCID := 0;
	end;

	ts.LeaderID := 0;

	tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.Delete(n);


	for j1 := ts.Point.Y div 8 - 2 to ts.Point.Y div 8 + 2 do begin
		for i1 := ts.Point.X div 8 - 2 to ts.Point.X div 8 + 2 do begin
			for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
				tc1 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
				if ((tc1.AMode = 1) or (tc1.AMode = 2)) and (tc1.ATarget = ts.ID) then begin
					tc1.AMode := 0;
					tc1.ATarget := 0;
				end;
				if (tc1.MMode > 0) and (tc1.MTarget = ts.ID) then begin
					tc1.MMode := 0;
					tc1.MTarget := 0;
				end;
			end;//for k1
		end;//for i1
	end;//for j1

	//åoå±ílï™îzèàóù
	n := 32;
	total := 0;
	for i := 0 to 31 do begin
		if ts.EXPDist[i].CData = nil then begin
			n := i;
			break;
		end;
		tc1 := ts.EXPDist[i].CData;
		if (tc1.Login = 2) and (tc1.Sit <> 1) and (tc1.Map = tm.Name) then begin
			//ÉçÉOÉAÉEÉgÇµÇƒÇ¢ÇÈÅAéÄÇÒÇ≈Ç¢ÇÈÅAï ÇÃÉ}ÉbÉvÇ…Ç¢ÇÈÅAÇ¢Ç∏ÇÍÇ©ÇÃèÍçáåoå±ílÇÕì¸ÇÁÇ»Ç¢
			Inc(total, ts.EXPDist[i].Dmg);
		end;
	end;


	mvpid := -1;

	if ts.Data.MEXP > 0 then begin
		mvpcheck := 0;
		for i := 0 to 31 do begin
			if ts.MVPDist[i].CData = nil then break;
			tc1 := ts.MVPDist[i].CData;
			if (tc1.Login = 2) and (tc1.Sit <> 1) and (tc1.Map = tm.Name) then begin
				//ÉçÉOÉAÉEÉgÇµÇƒÇ¢ÇÈÅAéÄÇÒÇ≈Ç¢ÇÈÅAï ÇÃÉ}ÉbÉvÇ…Ç¢ÇÈÅAÇ¢Ç∏ÇÍÇ©ÇÃèÍçáMVPëŒè€Ç…Ç»ÇÁÇ»Ç¢
				if mvpcheck < ts.MVPDist[i].Dmg then begin
					mvpid := i;
					mvpcheck := ts.MVPDist[i].Dmg;
				end;
			end;
		end;

		if mvpid <> -1 then begin
			tc1 := ts.MVPDist[mvpid].CData;
			//MVPï\é¶
			WFIFOW(0, $010c);
			WFIFOL(2, tc1.ID);
			SendBCmd(tm, tc1.Point, 6);
			//MVPÉ`ÉFÉbÉN
			mvpitem := false;
			GetMVPItem(tc1, ts, mvpitem);
			{if ts.Data.MEXPPer <= Random(10000) then begin
				for i := 0 to 2 do begin
					if ts.Data.MVPItem[i].Per > cardinal(Random(10000)) then begin
						//MVPÉAÉCÉeÉÄälìæ
						td := ItemDB.IndexOfObject(ts.Data.MVPItem[i].ID) as TItemDB;

						if tc1.MaxWeight >= tc1.Weight + td.Weight then begin
							j := SearchCInventory(tc1, td.ID, td.IEquip);
							if j <> 0 then begin
								//MVPÉAÉCÉeÉÄÉQÉbÉgí ím
								WFIFOW( 0, $010a);
								WFIFOW( 2, td.ID);
								tc1.Socket.SendBuf(buf, 4);

								//ÉAÉCÉeÉÄí«â¡
								tc1.Item[j].ID := td.ID;
								tc1.Item[j].Amount := tc1.Item[j].Amount + 1;
								tc1.Item[j].Equip := 0;
								tc1.Item[j].Identify := 1 - byte(td.IEquip);
								tc1.Item[j].Refine := 0;
								tc1.Item[j].Attr := 0;
								tc1.Item[j].Card[0] := 0;
								tc1.Item[j].Card[1] := 0;
								tc1.Item[j].Card[2] := 0;
								tc1.Item[j].Card[3] := 0;
								tc1.Item[j].Data := td;
								//èdó í«â¡
								tc1.Weight := tc1.Weight + td.Weight;
								WFIFOW( 0, $00b0);
								WFIFOW( 2, $0018);
								WFIFOL( 4, tc1.Weight);
								tc1.Socket.SendBuf(buf, 8);

								//ÉAÉCÉeÉÄÉQÉbÉgí ím
								SendCGetItem(tc1, j, 1);
								mvpitem := true;
							end;
						end;
						break;
					end;
				end;
			end;}
			if not mvpitem then begin
				//MVPåoå±ílälìæï\é¶ é¿ç€ÇÃâ¡éZÇÕå„Ç≈Ç‹Ç∆ÇﬂÇƒ

                { Alex: we're temporarily hardcoding it because AppleGirl was being a baby about
                how she already fixed it [not] so we don't want to give away the key that helped
                us solve it. }
                //bonus := (ts.Data.EXP * (ts.Data.MEXP + (3 * (n - 1))) * BaseExpMultiplier) div 100;
                bonus := (ts.Data.EXP * (120 + (3 * (n - 1))) * BaseExpMultiplier) div 100;

				WFIFOW( 0, $010b);
				WFIFOL( 2, bonus);
				tc1.Socket.SendBuf(buf, 6);
			end;
		end;
	end;


	tpaDB := TStringList.Create;
	for i := 0 to n - 1 do begin

		tc1 := ts.EXPDist[i].CData;

		if (tc1.Login <> 2) or (tc1.Sit = 1) or (tc1.Map <> tm.Name) then Continue;

		l := 100 * Cardinal(ts.EXPDist[i].Dmg) div total;
		l := ts.Data.EXP * l div 100;

        w := 100 * Cardinal(ts.EXPDist[i].Dmg) div total;
        w := ts.Data.JEXP * w div 100;

		if n <> 1 then Inc(l);
        if n <> 1 then Inc(w);

		try
        	l := l * BaseExpMultiplier;
        except
        	l := 2147483647;
        end;

		try
        	w := w * JobExpMultiplier;
        except
    		w := 2147483647;
        end;

		if (i = mvpid) and (not mvpitem) then l := l + bonus;

        { Alex: MVPs Bonus XP does not give job xp }
        //if (i = mvpid) and (not mvpitem) then w := w + ts.Data.MEXP; //MVP

		if tc1.Skill[307].Tick > Tick then l := l * cardinal(tc.Skill[307].Effect1 div 100);
		if tc1.Skill[307].Tick > Tick then w := w * cardinal(tc.Skill[307].Effect1 div 100);


		j := GuildList.IndexOf(tc.GuildID);
		if (j <> -1) then begin
			tg := GuildList.Objects[j] as TGuild;

            try
    			ge := l * tg.PosEXP[tc1.GuildPos] div 100;
            except
                ge := 4294967295;
            end;

			if (ge > l) then ge := l;
			if (ge > 0) then begin
				l := l - ge;
				CalcGuildLvUP(tg, tc1, ge);
			end;
		end;


		//ÉoÅ[ÉeÉBÅ[ã@î\
		j := PartyNameList.IndexOf(tc.PartyName);
		if j <> -1 then begin
			tpa := PartyNameList.Objects[j] as TParty;
			if tpa.EXPShare then begin
				Inc(tpa.EXP,l);
				Inc(tpa.JEXP,w);
				j := tpaDB.IndexOf(tpa.Name);
				if j = -1 then begin
					tpaDB.AddObject(tpa.Name,tpa);
				end;
			end else begin
				CalcLvUP(tc1,l,w);
			end;
		end else begin
				CalcLvUP(tc1,l,w);
		end;
	end;
	//ëºÇÃÉ}ÉbÉvÇ≈èàóùÇ™îÌÇÁÇ»Ç¢Ç∆âºíË
	for i := 0 to tpaDB.Count -1 do begin
		tpa := tpaDB.Objects[i] as TParty;
		PartyDistribution(ts.Map,tpa);
	end;
	tpaDB.Free;//safe 2004/04/27

	//ÉAÉCÉeÉÄÉhÉçÉbÉv

	if (ts.isSlave = false) then begin
		for k := 0 to 7 do begin
			DropFlag := false;

			{Colus, 20031222: Added ItemDropMultiplier to the calc.  It modifies IDD.}
			j := ItemDropDenominator div ItemDropMultiplier;
			i := (j - (j - ts.Data.Drop[k].Per) * 10000 div ItemDropPer);
			if ItemDropType then begin
				if Random(j) <= i then DropFlag := true; //èdóÕédólÅBÉäÉìÉSÇóéÇ∆Ç∑ÅB
			end else begin
				if Random(j) < i then DropFlag := true; //ñ{óàÇÃ(?)édólÅBÉäÉìÉSÇÕóéÇ∆Ç≥Ç»Ç¢ÅB
			end;
			if DropFlag then begin
				tn := TNPC.Create;
				tn.ID := NowItemID;
				Inc(NowItemID);
				tn.Name := 'item';
				tn.JID := ts.Data.Drop[k].ID;
				tn.Map := ts.Map;
				tn.Point.X := ts.Point.X - 1 + Random(3);
				tn.Point.Y := ts.Point.Y - 1 + Random(3);
				tn.CType := 3;
				tn.Enable := true;
				tn.Item := TItem.Create;
				tn.Item.ID := ts.Data.Drop[k].ID;
				tn.Item.Amount := 1;
				tn.Item.Identify := 1 - byte(ts.Data.Drop[k].Data.IEquip);
				tn.Item.Refine := 0;
				tn.Item.Attr := 0;
				tn.Item.Card[0] := 0;
				tn.Item.Card[1] := 0;
				tn.Item.Card[2] := 0;
				tn.Item.Card[3] := 0;
				tn.Item.Data := ts.Data.Drop[k].Data;
				tn.SubX := Random(8);
				tn.SubY := Random(8);
				tn.Tick := Tick + 60000;
				tm.NPC.AddObject(tn.ID, tn);
				tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.AddObject(tn.ID, tn);

				//é¸ÇËÇ…í ím
				WFIFOW( 0, $009e);
				WFIFOL( 2, tn.ID);
				WFIFOW( 6, tn.JID);
				WFIFOB( 8, tn.Item.Identify);
				WFIFOW( 9, tn.Point.X);
				WFIFOW(11, tn.Point.Y);
				WFIFOB(13, tn.SubX);
				WFIFOB(14, tn.SubY);
				WFIFOW(15, tn.Item.Amount);
				SendBCmd(tm, tn.Point, 17);
			end;
		end;
	end;
	//ó≠ÇﬂçûÇÒÇæÉAÉCÉeÉÄ
	for k := 1 to 10 do begin
		if ts.Item[k].Amount = 0 then Break;
		tn := TNPC.Create;
		tn.ID := NowItemID;
		Inc(NowItemID);
		tn.Name := 'item';
		tn.JID := ts.Item[k].ID;
		tn.Map := ts.Map;
		tn.Point.X := ts.Point.X - 1 + Random(3);
		tn.Point.Y := ts.Point.Y - 1 + Random(3);
		tn.CType := 3;
                tn.Enable := true;
		tn.Item := TItem.Create;
		tn.Item.ID := ts.Item[k].ID;
		tn.Item.Amount := 1;
		tn.Item.Identify := ts.Item[k].Identify;
		tn.Item.Refine := ts.Item[k].Refine;
		tn.Item.Attr := ts.Item[k].Attr;
		tn.Item.Card[0] := ts.Item[k].Card[0];
		tn.Item.Card[1] := ts.Item[k].Card[1];
		tn.Item.Card[2] := ts.Item[k].Card[2];
		tn.Item.Card[3] := ts.Item[k].Card[3];
		tn.Item.Data := ts.Item[k].Data;
		tn.SubX := Random(8);
		tn.SubY := Random(8);
		tn.Tick := Tick + 60000;
		tm.NPC.AddObject(tn.ID, tn);
		tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.AddObject(tn.ID, tn);

		ts.Item[k].ID := 0;
		ts.Item[k].Amount := 0;
		ts.Item[k].Equip := 0;
		ts.Item[k].Identify := 0;
		ts.Item[k].Refine := 0;
		ts.Item[k].Attr := 0;
		ts.Item[k].Card[0] := 0;
		ts.Item[k].Card[1] := 0;
		ts.Item[k].Card[2] := 0;
		ts.Item[k].Card[3] := 0;
		ts.Item[k].Data := nil;

		//é¸ÇËÇ…í ím
		WFIFOW( 0, $009e);
		WFIFOL( 2, tn.ID);
		WFIFOW( 6, tn.JID);
		WFIFOB( 8, tn.Item.Identify);
		WFIFOW( 9, tn.Point.X);
		WFIFOW(11, tn.Point.Y);
		WFIFOB(13, tn.SubX);
		WFIFOB(14, tn.SubY);
		WFIFOW(15, tn.Item.Amount);
		SendBCmd(tm, tn.Point, 17);
	end;

	if ts.isSummon then begin
		//è¢ä“ÉÇÉìÉXÇÕè¡ñ≈
		i := tm.Mob.IndexOf(ts.ID);
		if i = -1 then Exit;
		tm.Mob.Delete(i);

		if (ts.Event > 0) then begin
			tn := tm.NPC.IndexOfObject(ts.Event) as TNPC;
			tc1 := TChara.Create;
			tc1.TalkNPCID := tn.ID;
			tc1.ScriptStep := 0;
			tc1.AMode := 3;
			tc1.AData := tn;
			tc1.Login := 0;
			NPCScript(tc1,0,1);
			tc1.Free;
		end;
		ts.Free;
	end;

end;//proc TFrmMain.MonsterDie()
//------------------------------------------------------------------------------

// ëŒÉÇÉìÉXÉ^Å[èÛë‘ïœâªåvéZ
procedure TFrmMain.StatCalc1(tc:TChara; ts:TMob; Tick:cardinal);
var
	i:Integer;
	k:Cardinal;
begin
	with tc do begin
		k := 0;
		for i :=0 to 4 do begin
			if Random(100) < SFixPer1[0][i] then begin
				k := i + 1;
			end;
		end;
		if (k <> 0) then begin
			if (k <> ts.Stat1) then begin
				ts.BodyTick := Tick + tc.aMotion + ts.Data.dMotion;
				ts.nStat := k;
			end else begin
				ts.BodyTick := ts.BodyTick + 30000; //âÑí∑
			end;
		end;
		for i :=0 to 4 do begin
			k := 1 shl i;
			if Random(100) < SFixPer2[0][i] then begin
				if Boolean(k and ts.Stat2) then begin
					ts.HealthTick[i] := ts.HealthTick[i] + 30000; //âÑí∑
				end else begin
					ts.HealthTick[i] := Tick + tc.aMotion + ts.Data.dMotion;
				end;
			end;
		end;
	end;
end;
//------------------------------------------------------------------------------
procedure TFrmMain.StatCalc2(tc:TChara; tc1:TChara; Tick:cardinal);
var
	i:Integer;
	k:Cardinal;
begin
	with tc do begin
		k := 0;
		for i :=0 to 4 do begin
			if Random(100) < SFixPer1[0][i] then begin
				k := i + 1;
			end;
		end;
		if (k <> 0) then begin
			if (k <> tc1.Stat1) then begin
				tc1.BodyTick := Tick + tc.aMotion + tc1.dMotion;
        //tc1.Stat1 := k;
			end else begin
				tc1.BodyTick := tc1.BodyTick + 30000; //âÑí∑
			end;
		end;
		for i :=0 to 4 do begin
			k := 1 shl i;
			if Random(100) < SFixPer2[0][i] then begin
				if Boolean(k and tc1.Stat2) then begin
					tc1.HealthTick[i] := tc1.HealthTick[i] + 30000; //âÑí∑
				end else begin
					tc1.HealthTick[i] := Tick + tc.aMotion + tc1.dMotion;
				end;
			end;
		end;
	end;
end;

//------------------------------------------------------------------------------

{Player Attacking Monster}
{ChrstphrR 2004/04/27 - Checked all exits, no chance of Mem Leaks.}
procedure TFrmMain.DamageCalc1(tm:TMap; tc:TChara; ts:TMob; Tick:cardinal; Arms:byte = 0; SkillPer:integer = 0; AElement:byte = 0; HITFix:integer = 0);
var
	i,j,m :integer;
	miss  :boolean;
	crit  :boolean;
	datk  :boolean;
	tatk  :boolean;
	tg    :TGuild;
begin


    if assigned(ts) then begin
	with tc do begin

		GraceTick := Tick;

		if (ts.isEmperium) then begin
			j := GuildList.IndexOf(GuildID);
			if (j <> -1) then begin
			tg := GuildList.Objects[j] as TGuild;
				if (tg.GSkill[10000].Lv < 1) then begin
					dmg[0] := 0;
					Exit;
				end;
			end else begin
				dmg[0] := 0;
				Exit;//safe 2004/04/27
			end;
		end;

		i := HIT + HITFix - ts.Data.FLEE + 80;
		if i < 5 then i := 5;
		if i > 100 then i := 100;
		dmg[6] := i;
		Delay := (1000 - (4 * param[1]) - (2 * param[4]) + 300);

		if Arms = 0 then begin
            if Weapon = 16 then begin
                crit := boolean((SkillPer = 0) and (Random(100) < (Critical * 2) - ts.Data.LUK * 0.2));
            end else begin
                crit := boolean((SkillPer = 0) and (Random(100) < Critical - ts.Data.LUK * 0.2));
            end;
		end else begin //ìÒìÅó¨âEéË
			crit := boolean(dmg[5] = 10);
		end;
		miss := boolean((Random(100) >= i) and (not crit));
		//DAÉ`ÉFÉbÉN
		if NOT miss and (Arms = 0) and (SkillPer = 0) and (Random(100) < DAPer) then begin
      tatk := false;
      datk := false;
			if Skill[263].Lv > 0 then tatk := true;
			if Skill[48].Lv > 0 then datk := true;
			crit := false;
			if tatk then datk := false;
			//if tatk = true then tc.ATick := timeGetTime() + Delay;
			//if tatk = true then tc.ATick := timeGetTime() + 200 + Delay;
			//if tatk = true then Monkdelay(tm, tc, Delay);

			//if tatk = true then ADelay := (1000 - (4 * param[1]) - (2 * param[4]) - 300);

			Delay := (1000 - (4 * param[1]) - (2 * param[4]) + 300);
			//if tatk = true then Combodelay := (1000 - (4 * param[4]));
		end else begin
			datk := false;
			tatk := false;
		end;

		if not miss then begin
			//Monster is hit
			if Arms = 0 then if crit then dmg[5] := 10 else dmg[5] := 0; //ÉNÉäÉeÉBÉJÉãÉ`ÉFÉbÉN
			if WeaponType[Arms] = 0 then begin
				//ëféË
				dmg[0] := ATK[Arms][2];
			end else if Weapon = 11 then begin
				//ã|
				if dmg[5] = 10 then begin
					dmg[0] := ATK[0][2] + ATK[1][2] + ATK[0][1] * ATKFix[Arms][ts.Data.Scale] div 100;
				end else begin
					dmg[2] := ATK[0][1];

					case WeaponLv[0] of
						2: dmg[1] := Param[4] * 120 div 100;
						3: dmg[1] := Param[4] * 140 div 100;
						4: dmg[1] := Param[4] * 160 div 100;
						else dmg[1] := Param[4];
					end;//case
					// Colus, 20040226: I *think* we apply Maximize Power here.
					// Of course this is bow code and probably will never be called normally.
					// Leaving this as a TODO.
					// if (dmg[1] >= ATK[0][1]) or ((Skill[114].Tick >= Tick) and (Skill[114].EffectLV = 1)) then begin
					if dmg[1] >= ATK[0][1] then begin
						dmg[1] := ATK[0][1] * ATK[0][1] div 100;
					end else begin
						dmg[1] := dmg[1] * ATK[0][1] div 100;
					end;
					if dmg[1] > dmg[2] then dmg[2] := dmg[1];
					dmg[0] := dmg[1] + Random(dmg[2] - dmg[1] + 1) + Random(ATK[1][2]);
					dmg[0] := ATK[0][2] + dmg[0] * ATKFix[Arms][ts.Data.Scale] div 100;
				end;

			end else begin
				//ëféËà»äO
				if dmg[5] = 10 then begin
					dmg[0] := ATK[Arms][2] + ATK[Arms][1] * ATKFix[Arms][ts.Data.Scale] div 100;
				end else begin

					case WeaponLv[Arms] of
						2: dmg[1] := Param[4] * 120 div 100;
						3: dmg[1] := Param[4] * 140 div 100;
						4: dmg[1] := Param[4] * 160 div 100;
						else dmg[1] := Param[4];
					end;//case

					dmg[2] := ATK[Arms][1];
					// Colus, 20040226: I *think* we apply Maximize Power here.
					//if dmg[2] < dmg[1] then dmg[1] := dmg[2]; //DEX>ATKÇÃèÍçáÅAATKóDêÊ
					if (dmg[2] < dmg[1]) or ((Skill[114].Tick >= Tick) and (Skill[114].EffectLV = 1)) then begin
						dmg[1] := dmg[2];
						dmg[0] := dmg[2]; //DEX>ATKÇ then maximum value
					end else begin
						dmg[0] := dmg[1] + Random(dmg[2] - dmg[1] + 1);
					end;
					dmg[0] := ATK[Arms][2] + dmg[0] * ATKFix[Arms][ts.Data.Scale] div 100;
				end;
			end;
			if ts.Data.Race = 1 then dmg[0] := dmg[0] + ATK[0][5]; //ÉfÅ[ÉÇÉìÉxÉCÉì
			if SkillPer <> 0 then dmg[0] := dmg[0] * SkillPer div 100; //Skill%

			if (dmg[5] = 0) or (dmg[5] = 8) then begin
				if (ts.Stat2 and 1) = 1 then begin //ì≈Ç…ÇÊÇÈï‚ê≥
					dmg[3] := ts.Data.Param[2] * 75 div 100;
					m := ts.Data.DEF * 75 div 100;
				end else begin
					dmg[3] := ts.Data.Param[2];
					m := ts.Data.DEF;
				end;
																if tc.Skill[308].Tick > Tick then m := 0;
				dmg[3] := dmg[3] + Random((dmg[3] div 20) * (dmg[3] div 20)); //Def+DefBonus
				{ This causes negative damage. Why is this here. Added correct calculations to the bottom?
				if (AMode <> 8) then begin //AC
					//ÉIÅ[Ég_ÉoÅ[ÉTÅ[ÉN
					if (tc.Skill[146].Lv <> 0) and ((tc.HP  / tc.MAXHP) * 100 <= 25) then dmg[0] := (dmg[0] * (100 - (m * ts.DEFPer div 100)) div 100) * word(tc.Skill[6].Data.Data1[10]) div 100 - dmg[3]
					else dmg[0] := dmg[0] * (100 - (m * ts.DEFPer div 100)) div 100 - dmg[3]; //ÉvÉçÉ{ÉbÉNèCê≥ÇÕÇ±Ç±
				end;}
			end;

			dmg[0] := dmg[0] + ATK[Arms][3]; // 'Refining correction'
			if dmg[0] < 1 then dmg[0] := 1;
			dmg[0] := dmg[0] + ATK[0][4]; //èCó˚ï‚ê≥    ' Practice correction'?  (skill bonus?)

			// Japn. comment: 'Card correction'
			if Arms = 0 then begin // Japn. comment: 'When there are no card corrections for the left hand'
				dmg[0] := dmg[0] * DamageFixS[ts.Data.scale] div 100;
				dmg[0] := dmg[0] * DamageFixR[0][ts.Data.Race] div 100;
				dmg[0] := dmg[0] * DamageFixE[0][ts.Element mod 20] div 100;
			end;

			// Japn. comment: 'Establish element'
			if AElement = 0 then begin
				if Weapon = 11 then begin
					AElement := WElement[1];
				end else begin
					AElement := WElement[Arms];
				end;
			end;
			if ts.Stat1 = 2 then i := 21 // Frozen?  Water 1
			else if ts.Stat1 = 1 then i := 22 // Stone?  Earth 1
			else i := ts.Element;

			dmg[0] := dmg[0] * ElementTable[AElement][i] div 100; // Elemental damage multiplier
			if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2; // Lex Aeterna effect
		end else begin
			//çUåÇÉ~ÉX
			dmg[0] := 0;
		end;
		if tc.Skill[355].Tick > Tick then begin
			dmg[0] := dmg[0] + tc.Skill[355].Data.Data2[tc.Skill[355].Lv];
		end;
		//HP leech effect
		if (dmg[0] > 0) and (random(100) < DrainPer[0]) then begin
			HP := HP + (dmg[0] * DrainFix[0] div 100);
			if HP > MAXHP then HP := MAXHP;
			SendCStat1(tc, 0, 5, HP);
		end;
		//SP leech effect
		if (dmg[0] > 0) and (random(100) < DrainPer[1]) then begin
			SP := SP + (dmg[0] * DrainFix[1] div 100);
			if SP > MAXSP then SP := MAXSP;
			SendCStat1(tc, 0, 7, SP);
		end;

		if (tc.Stat1 <> 0) and (dmg[0] > 0) then begin
			tc.Stat1 := 0;
			tc.FreezeTick := Tick;
			tc.isFrozen := false;
			UpdateStatus(tm, tc, Tick);
		end;

		//ÉAÉTÉVÉììÒìÅó¨èCê≥
		if dmg[0] > 0 then begin
			dmg[0] := dmg[0] * ArmsFix[Arms] div 100;
			if dmg[0] = 0 then dmg[0] := 1;
		end;
		//Ç±Ç±Ç≈êØÇÃÇ©ÇØÇÁå¯â Çì¸ÇÍÇÈ(ñ¢é¿ëï)

		//Dragonology
		if (tc.Skill[284].Lv <> 0) and (ts.Data.Race = 9) then begin
			dmg[0] := dmg[0] + (dmg[0] * tc.Skill[284].Data.Data1[tc.Skill[284].Lv] div 100);
		end;
		//Beast Bane
		if (tc.Skill[126].Lv <> 0) and (ts.Data.Race = 2) then begin
			dmg[0] := dmg[0] + ATK[0][5];
			ATK[0][5]:= tc.Skill[126].Data.Data1[tc.Skill[126].Lv]
		end;

		if Arms = 1 then Exit;//safe 2004/04/27
		//É_ÉuÉãÉAÉ^ÉbÉN
		if datk then begin
			dmg[0] := dmg[0] * DAFix div 100 * 2;
			dmg[4] := 2;
			dmg[5] := 8;
		end else if (tatk) and (tc.Skill[263].Lv > 0) then begin
			dmg[0] := dmg[0] * (tc.Skill[263].Data.Data2[Skill[263].Lv] div 100);
			dmg[4] := 3;
			dmg[5] := 8;
			tc.MTarget := tc.ATarget;
			ts := tm.Mob.IndexOfObject(tc.MTarget) as TMob;
			if (ts = nil) OR (ts.HP = 0) then Exit;//safe 2004/04/27
			tc.MTargetType := 0;
			tc.AData := ts;
			tc.MSkill := 263;
			tc.MUseLV := Skill[263].Lv;
			//DecSP(tc, MSkill, MUseLV);
			SkillEffect(tc, Tick);

			tc.Skill[263].Tick := Tick + cardinal(2) * 1000;
		end else begin
			dmg[4] := 1;
		end;

		if (tc.Skill[279].Tick > Tick) and (Skill[279].Lv > 0) then begin     {Auto Cast}
			if tc.Skill[279].Data.Data2[tc.Skill[279].Lv] >= Random(100) then begin
						Autocastactive := true;
				tc.MTarget := tc.ATarget;
				ts := tm.Mob.IndexOfObject(tc.MTarget) as TMob;
				if ts.HP = 0 then Exit;
				tc.MTargetType := 0;
				tc.AData := ts;
				if (ts.ATarget = 0) and Boolean(ts.Data.Mode and $10) then begin
					ts.ATarget := ID;
					ts.AData := tc;
					ts.isLooting := False;
					ts.ATick := Tick + aMotion;
				end;

				i := tc.Skill[279].Effect1;
				if (i > 0) then j := tc.Skill[i].Lv;
				// What level can you use?
				case i of
				11:
					begin
						m := 3;
					end;
				14,19,20,13:
					begin
						m := 3;
					end;
				17:
					begin
						m := 2;
					end;
				15:
					begin
						m := 1;
					end;
				end;//case

				if (j > m) then j := m;
				tc.MSkill := i;

				// What level will you be casting at?
				// We reuse i and m now...

				m := Random(100);
				if (m < 50) then
					i := 1
				else if (m < 85) then
					i := 2
				else
					i := 3;

				if (j < i) then i := j;

				// Set the final skill level.
				tc.MUseLV := i;

				DecSP(tc, MSkill, MUseLV);
				SkillEffect(tc, Tick);
				//DamageProcess1(tm, tc, ts, dmg[0] + dmg[1], Tick)
			end;
		end;


		if (tc.GungnirEquipped) and (25 >= Random(100)) and (SkillPer = 0) then begin
			tc.MTarget := tc.ATarget;
			ts := tm.Mob.IndexOfObject(tc.MTarget) as TMob;

			tc.MTargetType := 0;
			tc.AData := ts;

			i := Random(4);
			case i of
			0:  tc.MSkill := 5;       {Bash}
			//1:  tc.MSkill := 7;       {Magnum Break}
			//2:  tc.MSkill := 56;      {Pierce}
			//3:  tc.MSkill := 59;      {Spear Boomerang}
			end;//case

			tc.MUseLV := Random(10) + 1;
			if (tc.MSkill <> 0) then SkillEffect(tc, Tick, False);
            tc.MSkill := 0;
            tc.MUseLV := 0;

			Exit;
		end;

		j := SearchCInventory(tc, tc.WeaponID, true);
		if tc.SkillWeapon then begin

			if (j <> 0) and (Random(100) < 30) and (tc.MSkill = 0) then begin
				tc.MTarget := tc.ATarget;
				ts := tm.Mob.IndexOfObject(tc.MTarget) as TMob;
				tc.MTargetType := 0;
				tc.AData := ts;

				tc.MSkill := WeaponSkill;
				tc.MUseLV := WeaponSkillLv;

				if tc.WeaponID = 1468 then begin
					tc.MPoint.X := ts.Point.X;
					tc.MPoint.Y := ts.Point.Y;
					CreateField(tc, tick);
				end else begin
					SkillEffect(tc, Tick);
				end;
				tc.MSkill := 0;
				tc.MUseLV := 0;
				Exit;//safe 2004/04/27
			end;
			if tc.SageElementEffect then dmg[0] := dmg[0] + (dmg[0] * tc.Skill[285].Data.Data1[Skill[285].EffectLV] div 100);
		end;

		if (tc.Skill[146].Lv <> 0) and ((tc.HP  / tc.MAXHP) * 100 <= 25) then begin
			dmg[0] := ((tc.Skill[6].Data.Data1[10] * dmg[0]) div 100);
		end;

	end;

	if ts.Stat1 <> 0 then begin
		ts.BodyTick := Tick + tc.aMotion;
	end;
    end else begin
        debugout.lines.add('DAMAGECALC1 TS NOT ASSIGNED');
    end;

	//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('DMG %d%% %d(%d-%d)', [dmg[6], dmg[0], dmg[1], dmg[2]]));
end;//proc TFrmMain.DamageCalc1()
//------------------------------------------------------------------------------

{Monster Attacking Player}
procedure TFrmMain.DamageCalc2(tm:TMap; tc:TChara; ts:TMob; Tick:cardinal; SkillPer:integer = 0; AElement:byte = 255; HITFix:integer = 0);
var
	i,j,k     :integer;
	miss      :boolean;
	crit      :boolean;
	avoid     :boolean; //äÆëSâÒî
	i1,j1,k1  :integer;
	xy        :TPoint;
	ts1       :TMob;
	tn        :TNPC;
begin
    CalculateSkillIf(tm, ts, Tick);
    if ts.Hidden then exit;
	if tc.TargetedTick <> Tick then begin
		if DisableFleeDown then begin
			tc.TargetedFix := 10;
			tc.TargetedTick := Tick;
		end else begin
			i := 0;
			xy := tc.Point;
			for j1 := xy.Y div 8 - 2 to xy.Y div 8 + 2 do begin
				for i1 := xy.X div 8 - 2 to xy.X div 8 + 2 do begin
					for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
            if (tm.Block[i1][j1].Mob.Objects[k1] is TMob) then begin
						ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
						if (tc.ID = ts1.ATarget) and (abs(ts1.Point.X - tc.Point.X) <= ts1.Data.Range1) and
							 (abs(ts1.Point.Y - tc.Point.Y) <= ts1.Data.Range1) then Inc(i);
					end;
				end;
			end;
			end;
			//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Targeted: ' + inttostr(i));
			if i > 12 then i := 12;
			if i < 2 then i := 2;
			tc.TargetedFix := 12 - i;
			tc.TargetedTick := Tick;
		end;
	end;

	with ts.Data do begin
                if ts.Stat2 <> 4 then CalcAI(tm, ts, Tick);
		i := HIT + HITFix - (tc.FLEE1 * tc.TargetedFix div 10) + 80;
		i := i - tc.FLEE2;
		if i < 5 then i := 5
		else if i > 95 then i := 95;

		dmg[6] := i;
		//crit := boolean((SkillPer = 0) and (Random(100) < Critical));
		crit := false;
		avoid := boolean((SkillPer = 0) and (Random(100) < tc.Lucky));
		miss := boolean((Random(100) >= i) and (not crit));

                //Shield Reflect
                if ((miss = False) and (tc.Skill[252].Tick > Tick)) then begin
                                tc.MSkill := 252;
                                dmg[0] := (dmg[0] * tc.Skill[252].Effect1) div 100;
                                WFIFOW( 0, $011a);
                                WFIFOW( 2, tc.MSkill);
                                WFIFOW( 4, tc.MUseLV);
                                WFIFOL( 6, tc.ID);
                                WFIFOL(10, tc.ID);
                                WFIFOB(14, 1);
                                SendBCmd(tm, tc.Point, 15);
                                WFIFOW( 0, $008a);
                                WFIFOL( 2, tc.ID);
                                WFIFOL( 6, ts.ID);
                                WFIFOL(10, timeGetTime());
                                WFIFOL(14, tc.aMotion);
                                WFIFOL(18, ts.Data.dMotion);
                                WFIFOW(22, dmg[0]); //É_ÉÅÅ[ÉW
                                WFIFOW(24, 1); //ï™äÑêî
                                WFIFOB(26, 0); //0=íPçUåÇ 8=ï°êî 10=ÉNÉäÉeÉBÉJÉã
                                WFIFOW(27, 0); //ãtéË
                                SendBCmd(tm, ts.Point, 29);
                                SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
                                if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
                                StatCalc1(tc, ts, Tick);
                                dmg[0] := 0;
                                dmg[5] := 11;
                end;

                if tc.AnolianReflect then begin
                      dmg[0] := (dmg[0] * 10) div 100;
                      if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
                      StatCalc1(tc, ts, Tick);
                      dmg[0] := 0;
                      dmg[5] := 11;
                end;

                //Poison React
                if ((miss = False) and (tc.Skill[139].Tick > Tick) and (ts.Data.Element = 25)) then begin
                                DamageCalc1(tm, tc, ts, Tick, 0, 0, 0, 20);
                                tc.MSkill := 139;
                                dmg[0] := (dmg[0] * tc.Skill[139].Effect1) div 100;
                                WFIFOW( 0, $011a);
                                WFIFOW( 2, tc.MSkill);
                                WFIFOW( 4, tc.MUseLV);
                                WFIFOL( 6, tc.ID);
                                WFIFOL(10, tc.ID);
                                WFIFOB(14, 1);
                                SendBCmd(tm, tc.Point, 15);
                                WFIFOW( 0, $008a);
                                WFIFOL( 2, tc.ID);
                                WFIFOL( 6, ts.ID);
                                WFIFOL(10, timeGetTime());
                                WFIFOL(14, tc.aMotion);
                                WFIFOL(18, ts.Data.dMotion);
                                WFIFOW(22, dmg[0]); //É_ÉÅÅ[ÉW
                                WFIFOW(24, 1); //ï™äÑêî
                                WFIFOB(26, 0); //0=íPçUåÇ 8=ï°êî 10=ÉNÉäÉeÉBÉJÉã
                                WFIFOW(27, 0); //ãtéË
                                SendBCmd(tm, ts.Point, 29);
                                SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
                                if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
                                StatCalc1(tc, ts, Tick);
                                dmg[0] := 0;
                                dmg[5] := 11;
                end;

                //From mWeiss

		i1 := 0;
		while (i1 >= 0) and (i1 < tm.Block[tc.Point.X div 8][tc.Point.Y div 8].NPC.Count) do begin
			tn := tm.Block[tc.Point.X div 8][tc.Point.Y div 8].NPC.Objects[i1] as TNPC;
			if tn = nil then begin
				Inc(i1);
				continue;
			end;
			if (tc.Point.X = tn.Point.X) and (tc.Point.Y = tn.Point.Y) then begin
				case tn.JID of
				$7e: // Safety Wall
					begin
						miss := true;
						if not avoid then Dec(tn.Count);
						if tn.Count = 0 then begin
							DelSkillUnit(tm, tn, tc);
							Dec(i1);
						end;
						//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Safety Wall OK >>' + IntToStr(tn.Count));
						dmg[6] := 0;
					end;
				$85: // Pneuma
					begin
						if ts.Data.Range1 >= 4 then miss := true;
						//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Pneuma OK');
						dmg[6] := 0;
					end;
				end;//case
			end;
			Inc(i1);
		end;

		if crit then dmg[5] := 10 else dmg[5] := 0; // Set critical attack status
		//VITÉ{Å[ÉiÉXÇ∆Ç©åvéZ
		j := ((tc.Param[2] div 2) + (tc.Param[2] * 3 div 10));
		k := ((tc.Param[2] div 2) + (tc.Param[2] * tc.Param[2] div 150 - 1));
		if j > k then k := j;
		if tc.Skill[33].Tick > Tick then begin // Angelus
			k := k * tc.Skill[33].Effect1 div 100;
		end;

    // Colus, 20040226: TODO: Use an EffectTick to make monster Maximize Power work!
    // if (EffectTick[somenumber] >= Tick) then
    //   dmg[1] := ATK2
    // else
    //   dmg[1] := ATK1 + Random(ATK2 - ATK1 + 1);
		dmg[1] := ATK1 + Random(ATK2 - ATK1 + 1);
		if (ts.Stat2 and 1) = 1 then dmg[1] := dmg[1] * 75 div 100;
		//ÉIÅ[Ég_ÉoÅ[ÉTÅ[ÉN
		if (tc.Skill[146].Lv <> 0) and (tc.HP * 100 / tc.MAXHP <= 25) then dmg[0] := (dmg[1] * (100 - (tc.DEF1 * word(tc.Skill[6].Data.Data2[10]) div 100)) div 100 - k) * ts.ATKPer div 100
		else dmg[0] := (dmg[1] * (100 - tc.DEF1) div 100 - k) * ts.ATKPer div 100;
		if Race = 1 then dmg[0] := dmg[0] - tc.DEF3; //DP
		if dmg[0] < 0 then dmg[0] := 1;

		if SkillPer <> 0 then dmg[0] := dmg[0] * SkillPer div 100; //Skill%
		//dmg[0] := dmg[0] * ElementTable[AElement][ts.Data.Element] div 100; //ëÆê´ëäê´ï‚ê≥

		//ÉJÅ[Éhï‚ê≥
    // Colus, 20040127: The race reduction shield cards are direct values, not 100-val.
    //        20040129: Couldn't do it this way.  Must change the card data instead...
		dmg[0] := dmg[0] * (100 - tc.DamageFixR[1][ts.Data.Race]) div 100;
		dmg[0] := dmg[0] * (100 - tc.DamageFixE[1][0]) div 100;    

    // Determine element based on status/armor type...

    //Below line is commented because the only elemental hits come on skills.
		//dmg[0] := dmg[0] * tc.DEFFixE[ts.Data.Element mod 20] div 100;

	{	if tc.Stat1 = 2 then i := 21 // Frozen?  Water 1
		else if tc.Stat1 = 1 then i := 22 // Stone?  Earth 1
    else if tc.ArmorElement <> 0 then i := tc.ArmorElement
    else i := 1;

    dmg[0] := dmg[0] * ElementTable[ts.Element mod 20][i] div 100; }

    if (tc.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2; // Lex Aeterna effect

         if (tc.Skill[361].Tick > Tick) then begin
        dmg[0] :=dmg[0] div 2;
        end else begin
         tc.Skill[361].Tick := Tick;
         end;
                //Auto Gaurd
                if ((miss = False) and (tc.Skill[249].Tick > Tick)) then begin
                        miss := boolean(Random(100) <= tc.Skill[249].Effect1);
                        if (miss = True) then begin
                                tc.MSkill := 249;
                                WFIFOW( 0, $011a);
                                WFIFOW( 2, tc.MSkill);
                                WFIFOW( 4, tc.MUseLV);
                                WFIFOL( 6, tc.ID);
                                WFIFOL(10, tc.ID);
                                WFIFOB(14, 1);
                                SendBCmd(tm, tc.Point, 15);
                                SendCSkillAtk1(tm, tc, ts, Tick, 0, 1, 6);
                                tc.MTick := Tick + 3000;
                        end;
                end;
                //Parry
                if ((miss = False) and (tc.Skill[356].Tick > Tick)) then begin
                        miss := boolean(Random(100) <= tc.Skill[356].Effect1);
                        if (miss = True) then begin
                                tc.MSkill := 356;
                                WFIFOW( 0, $011a);
                                WFIFOW( 2, tc.MSkill);
                                WFIFOW( 4, tc.MUseLV);
                                WFIFOL( 6, tc.ID);
                                WFIFOL(10, tc.ID);
                                WFIFOB(14, 1);
                                SendBCmd(tm, tc.Point, 15);
                                SendCSkillAtk1(tm, tc, ts, Tick, 0, 1, 6);
                                tc.MTick := Tick + 3000;
                        end;
                end;

                //Dragonology
                if (tc.Skill[284].Lv <> 0) and (ts.Data.Race = 9) then begin
                        dmg[0] := (dmg[0] - dmg[0] * tc.Skill[284].Data.Data1[tc.Skill[284].Lv]) div 100;
                end;

                //Providence
                if (tc.Skill[256].Tick > Tick) and ((ts.Data.Race = 1) or (ts.Data.Race = 6) or (ts.Data.Race = 8)) then begin
                        i := (dmg[0] * tc.Skill[256].Data.Data2[tc.Skill[256].Lv]) div 100;
                        dmg[0] := dmg[0] - i;
                end;

                if tc.Skill[61].Tick > Tick then begin //AC
                        tc.AMode := 8;
                        tc.ATarget := ts.ID;
                        DamageCalc1(tm, tc, ts, Tick, 0, 0, 0, 20);
                        if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                        //ÉpÉPëóêM
                        WFIFOW( 0, $008a);
                        WFIFOL( 2, tc.ID);
                        WFIFOL( 6, tc.ATarget);
                        WFIFOL(10, timeGetTime());
                        WFIFOL(14, tc.aMotion);
                        WFIFOL(18, ts.Data.dMotion);
                        WFIFOW(22, dmg[0]); //É_ÉÅÅ[ÉW
                        WFIFOW(24, 1); //ï™äÑêî
                        WFIFOB(26, 0); //0=íPçUåÇ 8=ï°êî 10=ÉNÉäÉeÉBÉJÉã
                        WFIFOW(27, 0); //ãtéË
                        SendBCmd(tm, ts.Point, 29);
                        DamageProcess1(tm, tc, ts, dmg[0], Tick);
                        StatCalc1(tc, ts, Tick);
                        tc.Skill[61].Tick := Tick;
                        tc.AMode := 0;
                        dmg[0] := 0;
                        dmg[5] := 11;
                end else if avoid then begin
                        dmg[0] := 0;
			                  dmg[5] := 11;
		end else if not miss then begin
			//çUåÇñΩíÜ
			if dmg[0] <> 0 then begin
				if tc.Skill[157].Tick > Tick then begin //ÉGÉlÉãÉMÅ[ÉRÅ[Ég
					if (tc.SP * 100 / tc.MAXSP) < 1 then tc.SP := 0;
				   	if tc.SP > 0 then begin
						i := 1;
						if (tc.SP * 100 / tc.MAXSP) > 20 then i := 2;
						if (tc.SP * 100 / tc.MAXSP) > 40 then i := 3;
						if (tc.SP * 100 / tc.MAXSP) > 60 then i := 4;
						if (tc.SP * 100 / tc.MAXSP) > 80 then i := 5;
						dmg[0] := dmg[0] - ((dmg[0] * i * 6) div 100);
						tc.SP := tc.SP - (tc.MAXSP * (i + 1) * 5) div 1000;
                                        end;
                                end else if (tc.Skill[257].Tick > Tick) then begin //Defender
                                                i := (dmg[0] * tc.Skill[257].Data.Data2[tc.Skill[257].Lv]) div 100;
                                                dmg[0] := dmg[0] - i;
                                                tc.MSkill := 257;
                                                WFIFOW( 0, $011a);
						WFIFOW( 2, tc.MSkill);
						WFIFOW( 4, tc.MUseLV);
						WFIFOL( 6, tc.ID);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
                                end else begin
                                tc.Skill[257].Tick := Tick;
                                tc.Skill[157].Tick := Tick;
                                SendCStat1(tc, 0, 7, tc.SP);
				end;
{Colus, 20031216: Cancel casting timer on hit.
  This also processes phen card correctly, hopefully.}

        if tc.NoCastInterrupt = False then begin
				tc.MMode := 0;
				tc.MTick := Tick;
				tc.MTarget := 0;
				tc.MPoint.X := 0;
				tc.MPoint.Y := 0;
        // Colus, 20040126: Who removed the packet?
        WFIFOW(0, $01b9);
        WFIFOL(2, tc.ID);
        SendBCmd(tm, tc.Point, 6);
                        end;
{Colus, 20031216: end cast-timer cancel change}

      end;
		end else begin
			// Japanese comment: "Attack missed" (no damage)
			dmg[0] := 0;
		end;
		// Japanese comment: "Here effects of Star Crumbs would be considered (unimplemented)"

		dmg[4] := 1;
	end;
	//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('REV %d%% %d(%d-%d)', [dmg[6], dmg[0], dmg[1], dmg[2]]));
end;
//------------------------------------------------------------------------------

{Player Attacking Player}
procedure TFrmMain.DamageCalc3(tm:TMap; tc:TChara; tc1:TChara; Tick:cardinal; Arms:byte = 0; SkillPer:integer = 0; AElement:byte = 0; HITFix:integer = 0);
var
	i,m,i1,j :integer;
	miss  :boolean;
	crit  :boolean;
	datk  :boolean;
	tatk  :boolean;
	tn    :TNPC;
begin
	with tc do begin
                //Grace Time Handling
                GraceTick := Tick;
                if tc1.GraceTick > Tick then Exit;

		i := HIT + HITFix - tc1.FLEE1 + 80;
		if i < 5 then i := 5;
		if i > 100 then i := 100;
		dmg[6] := i;
		if Arms = 0 then begin
			crit := boolean((SkillPer = 0) and (Random(100) < Critical - tc1.Lucky * 0.2));
		end else begin //ìÒìÅó¨âEéË
			crit := boolean(dmg[5] = 10);
		end;
		miss := boolean((Random(100) >= i) and (not crit));
		//DAÉ`ÉFÉbÉN
		if (miss = false) and (Arms = 0) and (SkillPer = 0) and (Random(100) < DAPer) then begin
                        if (Skill[263].Lv <> 0) then begin
                                tatk := true;
                                datk := false;
			end;
			if (Skill[48].Lv <> 0) then begin
                                datk := true;
                                tatk := false;
			end;
			crit := false;
		end else begin
			datk := false;
                        tatk := false;
		end;
               
        i1 := 0;
        while (i1 >= 0) and (i1 < tm.Block[tc.Point.X div 8][tc.Point.Y div 8].NPC.Count) do begin
            tn := tm.Block[tc.Point.X div 8][tc.Point.Y div 8].NPC.Objects[i1] as TNPC;
            if tn = nil then begin
                Inc(i1);
                continue;
            end;
            if (tc1.Point.X = tn.Point.X) and (tc1.Point.Y = tn.Point.Y) then begin
                case tn.JID of
                    $85: {Pneuma}
                    begin
                        if (miss = false) and (tc.Weapon = 11) then begin
                            miss := true;
                            //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Pneuma OK');
                            dmg[6] := 0;
                        end;
                    end;
                end;
            end;
            Inc(i1);
				end;

		if not miss then begin
			if tc1.Stat1 <> 0 then begin
				tc1.Stat1 := 0;
				tc1.FreezeTick := Tick;
				tc1.isFrozen := false;
				UpdateStatus(tm, tc1, Tick);
			end;
			if tc1.OrcReflect then begin
				i := dmg[0];
				//tc.MSkill := 61;
				tc1.MSkill := 61;
				dmg[0] := (dmg[0] * 30) div 100;
				SendCSkillAtk2(tm, tc1, tc, Tick, dmg[0], 1, 6);
				if not DamageProcess2(tm, tc1, tc, dmg[0], Tick) then
				StatCalc2(tc1, tc, Tick);
				dmg[0] := i;
				dmg[5] := 11;
			end;

			//çUåÇñΩíÜ
			if Arms = 0 then if crit then dmg[5] := 10 else dmg[5] := 0; //ÉNÉäÉeÉBÉJÉãÉ`ÉFÉbÉN
			if WeaponType[Arms] = 0 then begin
				//ëféË
				dmg[0] := ATK[Arms][2];
			end else if Weapon = 11 then begin
				//ã|
				if dmg[5] = 10 then begin
					dmg[0] := ATK[0][2] + ATK[1][2] + ATK[0][1] * ATKFix[Arms][1] div 100;
				end else begin
					dmg[2] := ATK[0][1];

					case WeaponLv[0] of
						2: dmg[1] := Param[4] * 120 div 100;
						3: dmg[1] := Param[4] * 140 div 100;
						4: dmg[1] := Param[4] * 160 div 100;
						else dmg[1] := Param[4];
					end;
					if dmg[1] >= ATK[0][1] then begin
						dmg[1] := ATK[0][1] * ATK[0][1] div 100;
					end else begin
						dmg[1] := dmg[1] * ATK[0][1] div 100;
					end;
					if dmg[1] > dmg[2] then dmg[2] := dmg[1];
					dmg[0] := dmg[1] + Random(dmg[2] - dmg[1] + 1) + Random(ATK[1][2]);
					dmg[0] := ATK[0][2] + dmg[0] * ATKFix[Arms][1] div 100;
				end;

			end else begin
				//ëféËà»äO
				if dmg[5] = 10 then begin
					dmg[0] := ATK[Arms][2] + ATK[Arms][1] * ATKFix[Arms][1] div 100;
				end else begin

					case WeaponLv[Arms] of
						2: dmg[1] := Param[4] * 120 div 100;
						3: dmg[1] := Param[4] * 140 div 100;
						4: dmg[1] := Param[4] * 160 div 100;
						else dmg[1] := Param[4];
					end;

					dmg[2] := ATK[Arms][1];
					// Colus, 20040226: I *think* we apply Maximize Power here.
					//if dmg[2] < dmg[1] then dmg[1] := dmg[2]; //DEX>ATKÇÃèÍçáÅAATKóDêÊ
					if (dmg[2] < dmg[1]) or ((Skill[114].Tick >= Tick) and (Skill[114].EffectLV = 1)) then begin
						dmg[1] := dmg[2];
						dmg[0] := dmg[2]; //DEX>ATKÇ then maximum value
					end else begin
						dmg[0] := dmg[1] + Random(dmg[2] - dmg[1] + 1);
					end;
					dmg[0] := dmg[1] + Random(dmg[2] - dmg[1] + 1);
					dmg[0] := ATK[Arms][2] + dmg[0] * ATKFix[Arms][1] div 100;
				end;
			end;
			dmg[0] := dmg[0] + ATK[0][5]; //ÉfÅ[ÉÇÉìÉxÉCÉì
			if SkillPer <> 0 then dmg[0] := dmg[0] * SkillPer div 100; //Skill%

			if (dmg[5] = 0) or (dmg[5] = 8) then begin
				if (tc1.Stat2 and 1) = 1 then begin //ì≈Ç…ÇÊÇÈï‚ê≥
					dmg[3] := tc1.Param[2] * 75 div 100;
					m := tc1.DEF1 * 75 div 100;
				end else begin
					dmg[3] := tc1.Param[2];
					m := tc1.DEF2 + tc1.DEF3;
				end;
				dmg[3] := dmg[3] + Random((dmg[3] div 20) * (dmg[3] div 20)); //VitDefBonus
				dmg[0] := dmg[0] - (dmg[0] * tc1.DEF1 div 100); //Correct Armor Defense Bonus
				if (AMode <> 8) then begin //AC
					//ÉIÅ[Ég_ÉoÅ[ÉTÅ[ÉN
					if (tc.Skill[146].Lv <> 0) and ((tc.HP  / tc.MAXHP) * 100 <= 25) then dmg[0] := (dmg[0] * (100 - (m * tc1.DAPer div 100)) div 100) * word(tc.Skill[6].Data.Data1[10]) div 100 - dmg[3]
					else dmg[0] := dmg[0] * (100 - (m * tc1.DAPer div 100)) div 100 - dmg[3]; //ÉvÉçÉ{ÉbÉNèCê≥ÇÕÇ±Ç±
				end;
			end;

			dmg[0] := dmg[0] + ATK[Arms][3]; //ê∏òBï‚ê≥
			if dmg[0] < 1 then dmg[0] := 1;
			dmg[0] := dmg[0] + ATK[0][4]; //èCó˚ï‚ê≥

			//ÉJÅ[Éhï‚ê≥
			if Arms = 0 then begin //ç∂éËÇ…ÇÕÉJÅ[Éhï‚ê≥Ç»Çµ
				dmg[0] := dmg[0] * DamageFixS[1] div 100;
				dmg[0] := dmg[0] * DamageFixR[0][1] div 100;
				// Colus, 20040127: Readded + to element card effects
				dmg[0] := dmg[0] * DamageFixE[0][tc1.ArmorElement mod 20] div 100;
			end;
			//ëÆê´ê›íË
			if AElement = 0 then begin
				if Weapon = 11 then begin
					AElement := WElement[1];
				end else begin
					AElement := WElement[Arms];
				end;
			end;

			// Determine element based on status/armor type...
			if tc1.Stat1 = 2 then i := 21 // Frozen?  Water 1
			else if tc1.Stat1 = 1 then i := 22 // Stone?  Earth 1
			else if tc1.ArmorElement <> 0 then i := tc1.ArmorElement // PC's armor type
			else i := 1;
			dmg[0] := dmg[0] * ElementTable[AElement][i] div 100; // Damage modifier based on elements

			// Colus, 20040129: Readded card effects for race/element properties.
			//        Note that all players are demi-human (race 7).
			dmg[0] := dmg[0] * (100 - tc.DamageFixR[1][7]) div 100;
			dmg[0] := dmg[0] * (100 - tc.DamageFixE[1][AElement]) div 100;

			if (tc1.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2; // Lex Aeterna effect
		end else begin
			//çUåÇÉ~ÉX
			dmg[0] := 0;
		end;
		//HPãzé˚
		if (dmg[0] > 0) and (random(100) < DrainPer[0]) then begin
			HP := HP + (dmg[0] * DrainFix[0] div 100);
			if HP > MAXHP then HP := MAXHP;
			SendCStat1(tc, 0, 5, HP);
		end;
		//SPãzé˚
		if (dmg[0] > 0) and (random(100) < DrainPer[1]) then begin
			SP := SP + (dmg[0] * DrainFix[1] div 100);
			if SP > MAXSP then SP := MAXSP;
			SendCStat1(tc, 0, 7, SP);
		end;

		if tc1.GhostArmor then begin
			if (AElement = 0) then dmg[0] := 0;
		end;

		//ÉAÉTÉVÉììÒìÅó¨èCê≥
		if dmg[0] > 0 then begin
			dmg[0] := dmg[0] * ArmsFix[Arms] div 100;
			if dmg[0] = 0 then dmg[0] := 1;
		end;
		//Ç±Ç±Ç≈êØÇÃÇ©ÇØÇÁå¯â Çì¸ÇÍÇÈ(ñ¢é¿ëï)

		if Arms = 1 then exit;
		//É_ÉuÉãÉAÉ^ÉbÉN
		if datk then begin
			dmg[0] := dmg[0] * DAFix div 100 * 2;
			dmg[4] := 2;
			dmg[5] := 8;
		end else if tatk then begin
			dmg[0] := dmg[0] * (tc.Skill[263].Data.Data2[Skill[263].Lv] div 100);
			dmg[4] := 3;
			dmg[5] := 8;
			tc.Skill[MSkill].Tick := Tick + cardinal(2) * 1000;
		end else begin
			dmg[4] := 1;
		end;


        if (tc.GungnirEquipped) and (25 >= Random(100)) and (SkillPer = 0) then begin
			tc.MTarget := tc.ATarget;
			tc1 := tm.CList.IndexOfObject(tc.MTarget) as TChara;

			tc.MTargetType := 1;
			tc.AData := tc1;

			i := Random(4);
			case i of
			0:  tc.MSkill := 5;       //Bash
			//1:  tc.MSkill := 7;       //Magnum Break
			//2:  tc.MSkill := 56;      //Pierce
			//3:  tc.MSkill := 59;      //Spear Boomerang
			end;

			tc.MUseLV := Random(10) + 1;
			if (tc.MSkill <> 0) then SkillEffect(tc, Tick, False);
            tc.MSkill := 0;
            tc.MUseLV := 0;
			Exit;
		end;

		j := SearchCInventory(tc, tc.WeaponID, true);
		if tc.SkillWeapon then begin

			if (j <> 0) and (Random(100) < 30) and (tc.MSkill = 0) then begin
				tc.MTarget := tc.ATarget;
				tc1 := tm.CList.IndexOfObject(tc.MTarget) as TChara;

				tc.MTargetType := 1;
				tc.AData := tc1;

				tc.MSkill := WeaponSkill;
				tc.MUseLV := WeaponSkillLv;

				if tc.WeaponID = 1468 then begin
					tc.MPoint.X := tc1.Point.X;
					tc.MPoint.Y := tc1.Point.Y;
					CreateField(tc, tick);
				end else begin
					SkillEffect(tc, Tick);
				end;
				tc.MSkill := 0;
				tc.MUseLV := 0;
				Exit;//safe 2004/04/27
			end;
			if tc.SageElementEffect then dmg[0] := dmg[0] + (dmg[0] * tc.Skill[285].Data.Data1[Skill[285].EffectLV] div 100);
		end;

	end;
	//èÛë‘ÇPÇÕâ£ÇÈÇ∆é°ÇÈ
	if tc1.Stat1 <> 0 then begin
		tc1.BodyTick := Tick + tc.aMotion;
	end;
	//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('DMG %d%% %d(%d-%d)', [dmg[6], dmg[0], dmg[1], dmg[2]]));
end;
//------------------------------------------------------------------------------

{Player Attacking Monster
Return values:
False - Damage value Dmg 0 or more...
True  - Monster dead because the Damage did them in.

ChrstphrR 2004/04/27 - changes made so that all Exits give a valid, not an
undefined Result value.

No Memory Leaks here. :)
}
function TfrmMain.DamageProcess1(tm:TMap; tc:TChara; ts:TMob; Dmg:integer; Tick:cardinal; isBreak:Boolean = True) : Boolean;
var
	{Random Variables}
	i  : Integer;
	j  : Integer;
	w  : Cardinal;
	xy : TPoint;
	tg : TGuild;
begin
	Result := False; //Assume false

	// AlexKreuz: Needed to stop damage to Emperium
	// From Splash Attacks.
	if (ts.isEmperium) then begin
		j := GuildList.IndexOf(tc.GuildID);
		if (j > -1) then begin
		tg := GuildList.Objects[j] as TGuild;
			if (tg.GSkill[10000].Lv < 1) then begin
				Dmg := 0;
				Exit;//result is defined
			end;
		end else begin
			Dmg := 0;
			Exit;//result is defined
		end;
	end;

	//Cancel Monster Casting
	if (ts.Mode = 3) AND NOT ts.NoDispel then begin
		ts.Mode := 0;
		ts.MPoint.X := 0;
		ts.MPoint.Y := 0;
		WFIFOW(0, $01b9);
		WFIFOL(2, ts.ID);
		SendBCmd(tm, ts.Point, 6);
	end;
	if ts.CanFindTarget then ts.Status := 'BESERK_ST';
	CalculateSkillIf(tm, ts, Tick);
	// Reset Lex Aeterna
	if (ts.EffectTick[0] > Tick) then begin
		// Dmg := Dmg * 2;  // Done in the DamageCalc functions
		ts.EffectTick[0] := 0;
	end;

	{Item Skill - Fatal Blow}
	if (tc.SpecialAttack = 2) and (ts.Data.MEXP = 0) then begin {Fatal Blow}
		if Random(10000) < 10 then Dmg := ts.HP;
	end;

	if ts.HP < Dmg then Dmg := ts.HP;

	if Dmg = 0 then begin
		Exit;//result is defined.
	end;
	if (ts.Stat1 <> 0) and isBreak then begin
		if ts.Stat1 <> 5 then begin   //code for ankle snar, not to break
			ts.BodyTick := Tick + tc.aMotion;
		end;
	end;

	UpdateMonsterLocation(tm, ts);

	ts.HP := ts.HP - Dmg;
	for i := 0 to 31 do begin
		if (ts.EXPDist[i].CData = nil) or (ts.EXPDist[i].CData = tc) then begin
			ts.EXPDist[i].CData := tc;
			Inc(ts.EXPDist[i].Dmg, Dmg);
			Break;
		end;
	end;
	if ts.Data.MEXP <> 0 then begin
		for i := 0 to 31 do begin
			if (ts.MVPDist[i].CData = nil) or (ts.MVPDist[i].CData = tc) then begin
				ts.MVPDist[i].CData := tc;
				Inc(ts.MVPDist[i].Dmg, Dmg);
				Break;
			end;
		end;
	end;

	if (ts.HP > 0) then begin
		//É^Å[ÉQÉbÉgê›íË
		if (EnableMonsterKnockBack) then begin
			ts.pcnt := 0;
			if ts.ATarget = 0 then begin
				w := Tick + ts.Data.dMotion + tc.aMotion;
				ts.ATick := Tick + ts.Data.dMotion + tc.aMotion;
			end else begin
				w := Tick + ts.Data.dMotion div 2;
			end;
			if w > ts.DmgTick then ts.DmgTick := w;
		end else begin
			if ts.ATarget = 0 then ts.ATick := Tick;
			if ts.ATarget <> tc.ID then
				ts.pcnt := 0
			else if (ts.pcnt <> 0)  then begin
				//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Monster Knockback!');
				SendMMove(tc.Socket, ts, ts.Point, ts.tgtPoint,tc.ver2);
				SendBCmd(tm, ts.Point, 58, tc,True);
			end;
			ts.DmgTick := 0;
		end;
		xy := ts.Point;
    ts.CanFindTarget := true;
		{ Alex: Monster searching for attack path towards player - checks attackrange over cliffs and sightrange w/o cliffs. }

        
		{if ( (Path_Finding(ts.path, tm, xy.X, xy.Y, tc.Point.X, tc.Point.Y, 2) <> 0) and (abs(xy.X - tc.Point.X) <= ts.Data.Range1) and (abs(xy.Y - tc.Point.Y) <= ts.Data.Range1) and (ts.Data.Range1 >= MONSTER_ATK_RANGE) ) or
		( (Path_Finding(ts.path, tm, xy.X, xy.Y, tc.Point.X, tc.Point.Y, 1) <> 0) and (abs(xy.X - tc.Point.X) <= ts.Data.Range2) and (abs(xy.Y - tc.Point.Y) <= ts.Data.Range2) ) then begin}


        { Alex: Retaliatory attack. Monster should definitely be able to return fire if he is being attacked. }
        if ( (Path_Finding(ts.path, tm, xy.X, xy.Y, tc.Point.X, tc.Point.Y, 2) <> 0) and (ts.Data.Range1 >= MONSTER_ATK_RANGE) ) or
		( (Path_Finding(ts.path, tm, xy.X, xy.Y, tc.Point.X, tc.Point.Y, 1) <> 0) ) then begin


			if (ts.ATarget = 0) or (ts.isActive	) then begin
				ts.ATarget := tc.ID;

				ts.AData := tc;

				ts.isLooting := False;
			end;
    end else begin
      ts.CanFindTarget := false;
      ts.Status := 'IDLE_ST';
      ts.SkillWaitTick := 0;
      CalculateSkillIf(tm, ts, Tick);
		end;
	end else begin
		//Kill Monster
		MonsterDie(tm, tc, ts, Tick);
		Result := True;//Only condition where Result is true.
	end;
end;
//------------------------------------------------------------------------------
function TfrmMain.DamageProcess2(tm:TMap; tc:TChara; tc1:TChara; Dmg:integer; Tick:cardinal; isBreak:Boolean = True) : Boolean;  {Monster Attacking Player}
var
	{Random Variables}
//	i :integer;
	w :Cardinal;
begin

  // Reset Lex Aeterna
	if (tc1.Skill[78].Tick > Tick) then begin
    // Dmg := Dmg * 2;  // Done in the DamageCalc functions
    tc.Skill[78].Tick := 0;
  end;

	if tc1.HP < Dmg then Dmg := tc1.HP;  //Damage Greater than Player's Life

  if Dmg = 0 then begin  //Miss, no damage
		Result := False;
		Exit;
	end else begin
    // AlexKreuz: Hidden character unhides when they
    // get hit.
    if tc1.Skill[51].Tick > Tick then begin
      tc1.Skill[51].Tick := Tick;
      tc1.SkillTick := Tick;
      // Adding the skilltick ID...
      tc1.SkillTickID := 51;
    end;
    if tc1.Skill[135].Tick > Tick then begin
      tc1.Skill[135].Tick := Tick;
      tc1.SkillTick := Tick;
      // Adding the skilltick ID...
      tc1.SkillTickID := 135;
    end;
  end;

	if (tc1.Stat1 <> 0) then tc1.BodyTick := Tick + tc.aMotion;

        UpdatePlayerLocation(tm, tc1);

	tc1.HP := tc1.HP - Dmg;
        SendCStat1(tc1, 0, 5, tc1.HP);
	//for i := 0 to 31 do begin
		//if (ts.EXPDist[i].CData = nil) or (ts.EXPDist[i].CData = tc) then begin
			//ts.EXPDist[i].CData := tc;
			//Inc(ts.EXPDist[i].Dmg, Dmg);
			//break;
		//end;
	//end;
	//if ts.Data.MEXP <> 0 then begin
		//for i := 0 to 31 do begin
			//if (ts.MVPDist[i].CData = nil) or (ts.MVPDist[i].CData = tc) then begin
				//ts.MVPDist[i].CData := tc;
				//Inc(ts.MVPDist[i].Dmg, Dmg);
				//break;
			//end;
		//end;
	//end;

	if tc1.HP > 0 then begin
		if EnableMonsterKnockBack then begin
			tc1.pcnt := 0;
			if tc1.ATarget = 0 then begin
				w := Tick + tc1.dMotion + tc.aMotion;
				tc1.ATick := Tick + tc1.dMotion + tc.aMotion;
			end else begin
				w := Tick + tc1.dMotion div 2;
			end;
			if w > tc1.DmgTick then tc1.DmgTick := w;
		end else begin
			if tc1.ATarget = 0 then tc1.ATick := Tick;
			if tc1.ATarget <> tc.ID then
				tc1.pcnt := 0
			else if tc1.pcnt <> 0 then begin
				//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Character Knockback!');
				//SendMMove(tc.Socket, ts, ts.Point, ts.tgtPoint,tc.ver2);
				SendBCmd(tm, tc1.Point, 58, tc,True);
			end;
			tc1.DmgTick := 0;
		end;
		//ts.ATarget := tc.ID;
		//ts.AData := tc;
		//ts.isLooting := False;

		Result := False;
	end else begin
    // Character has died
    CharaDie(tm, tc1, Tick, tc);
                {tc1.Sit := 1;
                tc1.HP := 0;
                SendCStat1(tc1, 0, 5, tc1.HP);
                WFIFOW(0, $0080);
                WFIFOL(2, tc1.ID);
                WFIFOB(6, 1);
                tc1.Socket.SendBuf(buf, 7);
                WFIFOW( 0, $0080);
                WFIFOL( 2, tc1.ID);
                WFIFOB( 6, 1);
                 SendBCmd(tm, tc1.Point, 7); }
		Result := True;
	end;
end;
//------------------------------------------------------------------------------

{Pick Up an Item}
procedure PickUp(tm:TMap; ts:TMob; Tick:Cardinal);
var
	tn:TNPC;
	i,j:Integer;
begin
	with ts do begin
		if tm.NPC.IndexOf(ts.ATarget) <> -1 then begin
			tn := tm.NPC.IndexOfObject(ts.Atarget) as TNPC;
			if (abs(ts.Point.X - tn.Point.X) <= 1) and (abs(ts.Point.Y - tn.Point.Y) <= 1) then begin
				j := 0;
				for i := 1 to 10 do begin
					//ãÛÇ´indexÇíTÇ∑
					if ts.Item[i].ID = 0 then begin
						ts.Item[i].Amount := 0;
						j := i;
						break;
					end;
				end;
				if j <> 0 then begin
					//ÉAÉCÉeÉÄí«â¡
					ts.Item[j].ID := tn.Item.ID;
					ts.Item[j].Amount := ts.Item[j].Amount + tn.Item.Amount;
					ts.Item[j].Equip := 0;
					ts.Item[j].Identify := tn.Item.Identify;
					ts.Item[j].Refine := tn.Item.Refine;
					ts.Item[j].Attr := tn.Item.Attr;
					ts.Item[j].Card[0] := tn.Item.Card[0];
					ts.Item[j].Card[1] := tn.Item.Card[1];
					ts.Item[j].Card[2] := tn.Item.Card[2];
					ts.Item[j].Card[3] := tn.Item.Card[3];
					ts.Item[j].Data := tn.Item.Data;
				end;
				//ÉAÉCÉeÉÄìPãé
				WFIFOW(0, $00a1);
				WFIFOL(2, tn.ID);
				SendBCmd(tm, tn.Point, 6);
				//ÉAÉCÉeÉÄçÌèú
				tm.NPC.Delete(tm.NPC.IndexOf(tn.ID));
				with tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC do
					Delete(IndexOf(tn.ID));
				tn.Free;

			end else begin
				//Update Monster Location
                                UpdateMonsterLocation(tm, ts);
				Exit;
			end;
		end;

                UpdateMonsterLocation(tm, ts);
		
		ts.pcnt := 0;
		ts.MoveWait := Tick + ts.Data.aMotion;
		ts.ATarget := 0;
		ts.ATick := Tick + ts.Data.ADelay;
		ts.isLooting := False;
    ts.Status := 'IDLE_ST';

	end;
end;

//==============================================================================

{Pet Picks Up an Item}
procedure PetPickUp(tm:TMap; tpe:TPet; tc: TChara; Tick:Cardinal);
var
	tn  : TNPC;
	tn1 : TNPC;
	j   : Integer;
begin
	with tpe do begin
		tn1 := tc.PetNPC;
		if tm.NPC.IndexOf(tpe.ATarget) <> -1 then begin
			tn := tm.NPC.IndexOfObject(tpe.ATarget) as TNPC;
			if (abs(tn1.Point.X - tn.Point.X) <= 1) and (abs(tn1.Point.Y - tn.Point.Y) <= 1) then begin
				j := 0;
				{for i := 1 to 25 do begin
					//Add the Item
					if tpe.Item[i].ID = 0 then begin
						tpe.Item[i].Amount := 0;
						j := i;
						break;
					end;
				end;}
				{if j <> 0 then begin
					//ÉAÉCÉeÉÄí«â¡
					tpe.Item[j].ID := tn.Item.ID;
					tpe.Item[j].Amount := tpe.Item[j].Amount + tn.Item.Amount;
					tpe.Item[j].Equip := 0;
					tpe.Item[j].Identify := tn.Item.Identify;
					tpe.Item[j].Refine := tn.Item.Refine;
					tpe.Item[j].Attr := tn.Item.Attr;
					tpe.Item[j].Card[0] := tn.Item.Card[0];
					tpe.Item[j].Card[1] := tn.Item.Card[1];
					tpe.Item[j].Card[2] := tn.Item.Card[2];
					tpe.Item[j].Card[3] := tn.Item.Card[3];
					tpe.Item[j].Data := tn.Item.Data;}
				//Add to players inventory
				if tc.MaxWeight >= tc.Weight + tn.Item.Data.Weight * tn.Item.Amount then begin
					j := SearchCInventory(tc, tn.Item.ID, tn.Item.Data.IEquip);
					if j <> 0 then begin
						//ÉAÉCÉeÉÄìPãé
						tpe.ATarget := 0;
									tn1.NextPoint := tc.Point;
						WFIFOW(0, $00a1);
						WFIFOL(2, tn.ID);
						SendBCmd(tm, tn.Point, 6);
						//ÉAÉCÉeÉÄí«â¡
						tc.Item[j].ID := tn.Item.ID;
						tc.Item[j].Amount := tc.Item[j].Amount + tn.Item.Amount;
						tc.Item[j].Equip := 0;
						tc.Item[j].Identify := tn.Item.Identify;
						tc.Item[j].Refine := tn.Item.Refine;
						tc.Item[j].Attr := tn.Item.Attr;
						tc.Item[j].Card[0] := tn.Item.Card[0];
						tc.Item[j].Card[1] := tn.Item.Card[1];
						tc.Item[j].Card[2] := tn.Item.Card[2];
						tc.Item[j].Card[3] := tn.Item.Card[3];
						tc.Item[j].Data := tn.Item.Data;
						//èdó í«â¡
						tc.Weight := tc.Weight + tn.Item.Data.Weight * tn.Item.Amount;
						SendCStat1(tc, 0, $0018, tc.Weight);
						//ÉAÉCÉeÉÄÉQÉbÉgí ím
						SendCGetItem(tc, j, tn.Item.Amount);
					end;
				end;
				//Remove the item from screen
				WFIFOW(0, $00a1);
				WFIFOL(2, tn.ID);
				SendBCmd(tm, tn1.Point, 6);
				//Remove item from block
				tm.NPC.Delete(tm.NPC.IndexOf(tn.ID));
				with tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC do
					Delete(IndexOf(tn.ID));
				tn.Free;

			end else begin
				//Update Monster Location
				UpdatePetLocation(tm, tn1);
				Exit;
			end;
		end;

		UpdatePetLocation(tm, tn1);

		tn1.pcnt := 0;
		tn1.MoveTick := Tick + 1000;
		tpe.ATarget := 0;
		//tpe.ATick := Tick + ts.Data.ADelay;
		tpe.isLooting := False;
	end;
end;

//------------------------------------------------------------------------------

{Pet Moving Function}
procedure TfrmMain.PetMoving( tc:TChara; _Tick:cardinal );
var
	j,k,m,n :Integer;
        spd:cardinal;
	xy:TPoint;
	dx,dy:integer;
	tm:TMap;
	tn:TNPC;
  tn1:TNPC;
  tc1:TChara;
  tpe:TPet;
begin
        if ( tc.PetData = nil ) or ( tc.PetNPC = nil ) then exit;

        tm := tc.MData;
        tn := tc.PetNPC;
        tpe := tc.PetData;

	with tn do begin

                if (Path[ppos] and 1) = 0 then begin
			spd := tc.Speed;
		end else begin
			spd := tc.Speed * 140 div 100;
		end;

                for j := 1 to ( _Tick - MoveTick ) div spd do begin

                xy := Point;
                Dir := Path[ppos];
                case Path[ppos] of
                        0: begin              Inc(Point.Y); dx :=  0; dy :=  1; end;
			1: begin Dec(Point.X);Inc(Point.Y); dx := -1; dy :=  1; end;
			2: begin Dec(Point.X);              dx := -1; dy :=  0; end;
			3: begin Dec(Point.X);Dec(Point.Y); dx := -1; dy := -1; end;
			4: begin              Dec(Point.Y); dx :=  0; dy := -1; end;
			5: begin Inc(Point.X);Dec(Point.Y); dx :=  1; dy := -1; end;
			6: begin Inc(Point.X);              dx :=  1; dy :=  0; end;
			7: begin Inc(Point.X);Inc(Point.Y); dx :=  1; dy :=  1; end;
			else begin                          dx :=  0; dy :=  0; end; //ñ{óàÇÕãNÇ±ÇÈÇÕÇ∏Ç™Ç»Ç¢
                end;
                Inc(ppos);

                //ÉuÉçÉbÉNèàóù1
                for n := xy.Y div 8 - 2 to xy.Y div 8 + 2 do begin
                        for m := xy.X div 8 - 2 to xy.X div 8 + 2 do begin //é©ï™ÇÃãèÇÈÉuÉçÉbÉNÇÕèàóùÇ∑ÇÈïKóvÇÕÇ»Ç¢(ñ¢)
                                for k := 0 to tm.Block[m][n].CList.Count - 1 do begin
                                        tc1 := tm.Block[m][n].CList.Objects[k] as TChara;
                                        if tc <> tc1 then begin //é©ï™ìØémÇ≈ÇÕí ímÇµÇ»Ç¢ÇÊÇ§Ç…ÅB
                                                if ((dx <> 0) and (abs(xy.Y - tc1.Point.Y) < 16) and (xy.X = tc1.Point.X + dx * 15)) or
                                                ((dy <> 0) and (abs(xy.X - tc1.Point.X) < 16) and (xy.Y = tc1.Point.Y + dy * 15)) then begin
                                                        //è¡ñ≈í ím
                                                        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('		Chara %s Delete', [tc1.Name]));
                                                        WFIFOW(0, $0080);
                                                        WFIFOL(2, ID);
                                                        WFIFOB(6, 0);
                                                        tc1.Socket.SendBuf(buf, 7);
                                                end;
                                                if ((dx <> 0) and (abs(Point.Y - tc1.Point.Y) < 16) and (Point.X = tc1.Point.X - dx * 15)) or
                                                ((dy <> 0) and (abs(Point.X - tc1.Point.X) < 16) and (Point.Y = tc1.Point.Y - dy * 15)) then begin
                                                        //èoåªí ím
                                                        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('		Chara %s Add', [tc1.Name]));
                                                        //Darkhelmet, I found you you stupid bastard!  YOU ARE CAUSING OUR BARD PROBLEMS
                                                        SendNData( tc1.Socket, tn, tc1.ver2, tc );
                                                        //à⁄ìÆí ím
                                                        if (abs(Point.X - tc1.Point.X) < 16) and (abs(Point.Y - tc1.Point.Y) < 16) then begin
                                                                //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('		Chara %s Move (%d,%d)-(%d,%d)', [Name, xy.X, xy.Y, Point.X, Point.Y]));
                                                                SendPetMove(tc1.Socket, tc, NextPoint );
                                                        end;
                                                end;
                                        end;
                                end;
			end;
                end;

                //ÉuÉçÉbÉNà⁄ìÆ
                if (xy.X div 8 <> Point.X div 8) or (xy.Y div 8 <> Point.Y div 8) then begin
                        //à»ëOÇÃÉuÉçÉbÉNÇÃÉfÅ[É^è¡ãé
                        with tm.Block[xy.X div 8][xy.Y div 8].NPC do begin
                                Delete(IndexOf(ID));
                        end;
                        //êVÇµÇ¢ÉuÉçÉbÉNÇ…ÉfÅ[É^í«â¡
                        tm.Block[Point.X div 8][Point.Y div 8].NPC.AddObject(ID, tn);
                end;

                if (tpe.ATarget <> 0) then begin
				          if tpe.isLooting then begin
					          tn1 := tm.NPC.IndexOfObject(tpe.ATarget) as TNPC;
					          if tn1 = nil then begin
                      UpdatePetLocation(tm, tn);

						          tpe.isLooting := False;
						          tpe.ATarget := 0;
						          ppos := pcnt;
						          //MoveWait := Tick + Data.dMotion;
					          end else if (abs(tn.Point.X - tn1.Point.X) < 2) and (abs(tn.Point.Y - tn1.Point.Y) < 2) then begin
						          tn.NextPoint := Point;
						          ppos := pcnt;
						        //ATick := Tick + Speed;
					          end;
                  end;
                end;

                if ppos = pcnt then begin
                        //à⁄ìÆäÆóπ
                        pcnt := 0;
                        break;
                end;
                MoveTick := MoveTick + spd;

                end;
	end;
end;

//==============================================================================
//Character Moving Function
function  TfrmMain.CharaMoving(tc:TChara;Tick:cardinal) : boolean;
var
	i   : Integer;
	j   : Integer;
	k   : Integer;
	m   : Integer;
	n   : Integer;
//	o   : Integer;
	dx  : Integer;
	dy  : Integer;
	spd : Integer;
	xy  : TPoint;
	w   : Word;
	tm  : TMap;
	tn  : TNPC;
	tc1 : TChara;
//	tl  : TSkillDB;
	ts  : TMob;
	tcr : TChatRoom;
begin

with tc do begin

    tm := MData;

    if (Path[ppos] and 1) = 0 then begin
        spd := Speed;
    end else begin
        spd := Speed * 140 div 100;
    end;

    for j := 1 to integer(Tick - MoveTick) div spd do begin
        xy := Point;
        Dir := Path[ppos];
        HeadDir := 0;
        case Path[ppos] of
            0: begin Inc(Point.Y);              dx :=  0; dy :=  1; end;
            1: begin Dec(Point.X);Inc(Point.Y); dx := -1; dy :=  1; end;
            2: begin Dec(Point.X);              dx := -1; dy :=  0; end;
            3: begin Dec(Point.X);Dec(Point.Y); dx := -1; dy := -1; end;
            4: begin              Dec(Point.Y); dx :=  0; dy := -1; end;
            5: begin Inc(Point.X);Dec(Point.Y); dx :=  1; dy := -1; end;
            6: begin Inc(Point.X);              dx :=  1; dy :=  0; end;
            7: begin Inc(Point.X);Inc(Point.Y); dx :=  1; dy :=  1; end;
        else
            begin  HeadDir := 0; dx :=  0; dy :=	0; end; //ñ{óàÇÕãNÇ±ÇÈÇÕÇ∏Ç™Ç»Ç¢
        end;
        Inc(ppos);
        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('		Move %d/%d (%d,%d) %d %d %d', [ppos, pcnt, Point.X, Point.Y, Path[ppos-1], spd, Tick]));
    
        for n := xy.Y div 8 - 2 to xy.Y div 8 + 2 do begin
            for m := xy.X div 8 - 2 to xy.X div 8 + 2 do begin
                for k := 0 to tm.Block[m][n].NPC.Count - 1 do begin
                    tn := tm.Block[m][n].NPC.Objects[k] as TNPC;

                    if ((dx <> 0) and (abs(xy.Y - tn.Point.Y) < 16) and (xy.X = tn.Point.X + dx * 15)) or
                    ((dy <> 0) and (abs(xy.X - tn.Point.X) < 16) and (xy.Y = tn.Point.Y + dy * 15)) then begin
                        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + IntToStr(tn.Item.Identify));
                        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('		NPC %s Delete', [tn.Name]));

                        if tn.CType = 3 then begin
                            WFIFOW(0, $00a1);
                            WFIFOL(2, tn.ID);
                            if tc.Login <> 0 then Socket.SendBuf(buf, 6);
                        end else if tn.CType = 4 then begin
                            WFIFOW(0, $0120);
                            WFIFOL(2, tn.ID);
                            if tc.Login <> 0 then Socket.SendBuf(buf, 6);
                        end else begin
                            WFIFOW(0, $0080);
                            WFIFOL(2, tn.ID);
                            WFIFOB(6, 0);
                            if tc.Login <> 0 then Socket.SendBuf(buf, 7);
                        end;
                    end;

                    if ((dx <> 0) and (abs(Point.Y - tn.Point.Y) < 16) and (Point.X = tn.Point.X - dx * 15)) or
                    ((dy <> 0) and (abs(Point.X - tn.Point.X) < 16) and (Point.Y = tn.Point.Y - dy * 15)) then begin
                        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('		NPC %s Add', [tn.Name]));

                        //if tn.CType = 2 then begin
                            //SendNData(Socket, tn, tc.ver2);
                        //end;

                        if (tn.Enable = true) then begin
                            SendNData(Socket, tn, tc.ver2, tc);
                            if (tn.ScriptInitS <> -1) and (tn.ScriptInitD = false) then begin
                                //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('OnInit Event(%d)', [tn.ID]));

                                tc1 := TChara.Create;
                                tc1.TalkNPCID := tn.ID;
                                tc1.ScriptStep := tn.ScriptInitS;
                                tc1.AMode := 3;
                                tc1.AData := tn;
                                tc1.Login := 0;
                                NPCScript(tc1,0,1);
                                tn.ScriptInitD := true;
                                tc1.Free;
                            end;

                            if (tn.ChatRoomID <> 0) then begin
                                i := ChatRoomList.IndexOf(tn.ChatRoomID);

                                if (i <> -1) then begin
                                    tcr := ChatRoomList.Objects[i] as TChatRoom;

                                    if (tn.ID = tcr.MemberID[0]) then begin
                                        w := Length(tcr.Title);
                                        WFIFOW(0, $00d7);
                                        WFIFOW(2, w + 17);
                                        WFIFOL(4, tcr.MemberID[0]);
                                        WFIFOL(8, tcr.ID);
                                        WFIFOW(12, tcr.Limit);
                                        WFIFOW(14, tcr.Users);
                                        WFIFOB(16, tcr.Pub);
                                        WFIFOS(17, tcr.Title, w);

                                        if tc.Socket <> nil then begin
                                            tc.Socket.SendBuf(buf, w + 17);
                                        end;
                                    end;
                                end;
                            end;
                        end;

                    end;
                end;
                
                for k := 0 to tm.Block[m][n].CList.Count - 1 do begin
                    tc1 := tm.Block[m][n].CList.Objects[k] as TChara;

                    if tc <> tc1 then begin
                        if ((dx <> 0) and (abs(xy.Y - tc1.Point.Y) < 16) and (xy.X = tc1.Point.X + dx * 15)) or
                        ((dy <> 0) and (abs(xy.X - tc1.Point.X) < 16) and (xy.Y = tc1.Point.Y + dy * 15)) then begin
                            //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('		Chara %s Delete', [tc1.Name]));
                            
                            WFIFOW(0, $0080);
                            WFIFOL(2, ID);
                            WFIFOB(6, 0);
                            tc1.Socket.SendBuf(buf, 7);
                            WFIFOL(2, tc1.ID);
                            Socket.SendBuf(buf, 7);
                        end;
    
                        if ((dx <> 0) and (abs(Point.Y - tc1.Point.Y) < 16) and (Point.X = tc1.Point.X - dx * 15)) or
                        ((dy <> 0) and (abs(Point.X - tc1.Point.X) < 16) and (Point.Y = tc1.Point.Y - dy * 15)) then begin
                            //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('		Chara %s Add', [tc1.Name]));

                            SendCData(tc, tc1);
                            SendCData(tc1, tc);
                            
                            if (abs(Point.X - tc1.Point.X) < 16) and (abs(Point.Y - tc1.Point.Y) < 16) then begin
                                //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('		Chara %s Move (%d,%d)-(%d,%d)', [Name, xy.X, xy.Y, Point.X, Point.Y]));

                                SendCMove(tc1.Socket, tc, Point, tgtPoint);
                            end;
                        end;
                    end;
                end;
    
                for k := 0 to tm.Block[m][n].Mob.Count - 1 do begin
                    if ((tm.Block[m][n].Mob.Objects[k] is TMob) = false) then continue;
                    ts := tm.Block[m][n].Mob.Objects[k] as TMob;

                    if ((dx <> 0) and (abs(xy.Y - ts.Point.Y) < 16) and (xy.X = ts.Point.X + dx * 15)) or
                    ((dy <> 0) and (abs(xy.X - ts.Point.X) < 16) and (xy.Y = ts.Point.Y + dy * 15)) then begin
                        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('		Mob %s Delete', [ts.Name]));
                        
                        UpdateMonsterDead(tm, ts, 0, tc);
                        {WFIFOW(0, $0080);
                        WFIFOL(2, ts.ID);
                        WFIFOB(6, 0);
                        Socket.SendBuf(buf, 7);}
                    end;

                    if ((dx <> 0) and (abs(Point.Y - ts.Point.Y) < 16) and (Point.X = ts.Point.X - dx * 15)) or
                    ((dy <> 0) and (abs(Point.X - ts.Point.X) < 16) and (Point.Y = ts.Point.Y - dy * 15)) then begin
                        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('		Mob %s Add', [ts.Name]));
                        
                        SendMData(Socket, ts);

                        if (ts.pcnt <> 0) and (abs(Point.X - ts.Point.X) < 16) and (abs(Point.Y - ts.Point.Y) < 16) then begin
                            SendMMove(Socket, ts, ts.Point, ts.tgtPoint,ver2);
                        end;
                    end;
                end;
            end;
        end;

        if (xy.X div 8 <> Point.X div 8) or (xy.Y div 8 <> Point.Y div 8) then begin
            //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('		BlockMove (%d,%d)-(%d,%d)', [xy.X div 8, xy.Y div 8, Point.X div 8, Point.Y div 8]));

            with tm.Block[xy.X div 8][xy.Y div 8].CList do begin
                //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'BlockDelete ' + inttostr(IndexOf(IntToStr(ID))));
                Delete(IndexOf(ID));
            end;

            tm.Block[Point.X div 8][Point.Y div 8].CList.AddObject(ID, tc);
            //debugout.lines.add('[' + TimeToStr(Now) + '] ' + '		BlockMove OK');
        end;

        if (tm.gat[Point.X][Point.Y] <> 1) and (tm.gat[Point.X][Point.Y] <> 5) then begin
            for n := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
                for m := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
                    for k := 0 to tm.Block[m][n].NPC.Count - 1 do begin
                        tn := tm.Block[m][n].NPC.Objects[k] as TNPC;

                        if (tn.CType = 0) and (tn.Enable = true) then begin

                            if (abs(Point.X - tn.Point.X) <= tn.WarpSize.X) and
                            (abs(Point.Y - tn.Point.Y) <= tn.WarpSize.Y) then begin

                                if (tc.Skill[144].Lv = 0) then HPTick := Tick;

                                HPRTick := Tick - 500;
                                SPRTick := Tick;
                                pcnt := 0;
                                SendCLeave(tc, 0);
                                Map := tn.WarpMap;
                                Point := tn.WarpPoint;
                                MapMove(Socket, Map, Point);

                                NextPoint := Point;
                                Result := True;
                                Exit;
                            end;
                        end;

                        if (tn.CType = NPC_TYPE_SCRIPT) and (tn.Enable = true) and (tn.OnTouch = true) then begin

                            if (abs(Point.X - tn.Point.X) <= tn.WarpSize.X) and
                            (abs(Point.Y - tn.Point.Y) <= tn.WarpSize.Y) then begin
                                if tc.OnTouchIDs.IndexOf(tn.ID) = -1 then begin
                                    tc.TalkNPCID := tn.ID;
                                    if tn.OnTouchLabel <> 0 then tc.ScriptStep := tn.OnTouchLabel
                                    else tc.ScriptStep := 0;
                                    tc.AMode := 3;
                                    if (tc.Option and 6 <> 0) then begin
                                        tc.Option := tc.Option and $FFF9;
                                        //å©ÇΩñ⁄ïœçX  Lit. "The eye modification which you saw"
                                        UpdateOption(tm, tc);
                                    end;
                                    tc.AData := tn;
                                    tc.OnTouchIDs.Add(tn.ID);
                                    NPCScript(tc);
                                end;
                            end else begin
                                if tc.OnTouchIDs.IndexOf(tn.ID) <> -1 then
                                    tc.OnTouchIDs.Delete(tc.OnTouchIDs.IndexOf(tn.ID));
                            end;
                        end;


                    end;
                end;
            end;
        end;

        if ppos = pcnt then begin
            Sit := 3;

            if (tc.Skill[144].Lv = 0) then HPTick := Tick;

            HPRTick := Tick - 500;
            SPRTick := Tick;
            pcnt := 0;

            {
            if (AMode = 1) or (AMode = 2) then begin
                ts := AData;
                if (abs(Point.X - ts.Point.X) > Range) or (abs(Point.Y - ts.Point.Y) > Range) then begin
                    NextFlag := true;
                    NextPoint := ts.tgtPoint;
                end;
            end;
            }

            //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('		Move OK', [ID]));
            break;
        end;

        MoveTick := MoveTick + cardinal(spd);
    end;
end;

Result := False;
end;
//------------------------------------------------------------------------------
//ï™äÑÇQ
procedure TfrmMain.CharaAttack(tc:TChara;Tick:cardinal);
var
	i1,j1,k1,k:integer;
	tm:TMap;
	ts:TMob;
	ts1:TMob;
	xy:TPoint;
	sl:TStringList;
	tl:TSkillDB;
//	td:TItemDB;
//	found:boolean;
//	tpe:TPet;
//	tn:TNPC;
//	tn1:TNPC;
begin
	with tc do begin
		ts := AData;
		tm := MData;
		if ts.Hidden = True then ts.AMode := 0;  //Monster is hidden so you can't hit it.

		if ts.HP <= 0 then begin
			//Monster is Dead
			ts.HP := 0;
			AMode := 0;
			Exit;
		end;

		{if (pcnt <> 0) and (abs(Point.X - ts.Point.X) <= Range) and (abs(Point.Y - ts.Point.Y) <= Range) then begin
			//à⁄ìÆíÜÇÃéûÇÕà⁄ìÆí‚é~
			Sit := 3;
			HPTick := timeGetTime();
			HPRTick := timeGetTime() - 500;
			SPRTick := timeGetTime();
			pcnt := 0;
			WFIFOW(0, $0088);
			WFIFOL(2, ID);
			WFIFOW(6, Point.X);
			WFIFOW(8, Point.Y);
			SendBCmd(tm, Point, 10);
			if ATick + ADelay - 200 < Tick then ATick := Tick - ADelay + 200;
		end;}

								{Alex: Player search for monster - Should search over cliffs, but not walls and check for range - Type 2 }
		if (Path_Finding(path, tm, Point.X, Point.Y,ts.Point.X, ts.Point.Y, 2) <> 0) and (abs(Point.X - ts.Point.X) <= Range) and (abs(Point.Y - ts.Point.Y) <= Range) then begin
			//çUåÇ
			if ts = nil then begin
				AMode := 0;
				Exit;
			end;

			if Weapon = 11 then begin  //Bow

				if (Arrow = 0) or (Item[Arrow].Amount = 0) then begin
					//No Arrows
					WFIFOW(0, $013b);
					WFIFOW(2, 0);
					Socket.SendBuf(buf, 4);
					//AMode := 0;
					ATick := ATick + ADelay;
					Exit;
				end;

				//Decrease Arrow Amount
				Dec(Item[Arrow].Amount);

				//Packet Send
				WFIFOW( 0, $00af);
				WFIFOW( 2, Arrow);
				WFIFOW( 4, 1);
				Socket.SendBuf(buf, 6);

				if Item[Arrow].Amount = 0 then begin
					Item[Arrow].ID := 0;
					Arrow := 0;
				end;
			end;

			if Weight * 100 div MaxWeight >= 90 then begin
				//Weight is over 90%
				WFIFOW(0, $013b);
				WFIFOW(2, 1);
				Socket.SendBuf(buf, 4);
				AMode := 0;
				Exit;
			end;

			//Pet Attacks
			if (EnablePetSkills) and ( tc.PetData <> nil ) and ( tc.PetNPC <> nil ) then PetAttackSkill(tm, ts, tc);

			// + åÉ Çµ Ç≠ é© ìÆ ëÈ +
			if (Option and 16 <> 0) and (Skill[129].Lv <> 0) and (Random(1000) < Param[5] * 10 div 3) then begin //ämó¶É`ÉFÉbÉN
				if (JobLV + 9) div 10 < Skill[129].Lv then begin
					dmg[4] := (JobLV + 9) div 10;
				end else begin
					dmg[4] := Skill[129].lv;
				end;
				//dmg[4]ÇíiêîïœêîÇ…égóp
				//É_ÉÅÅ[ÉWéZèo
				if Skill[128].Lv <> 0 then begin
					dmg[1] := Skill[128].Data.Data1[Skill[128].Lv] * 2;
				end else begin
					dmg[1] := 0;
				end;
				dmg[1] := dmg[1] + (Param[4] div 10 + Param[3] div 2) * 2 + 80;
				dmg[1] := dmg[1] * dmg[4];
				MMode := 0;
				MSkill := 129;
				MUseLV := $F000;

				xy := ts.Point;
				//É_ÉÅÅ[ÉWéZèo
				sl := TStringList.Create;
				tl := Skill[129].Data;
				for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
					for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
						for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
							ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
							if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
								sl.AddObject(IntToStr(ts1.ID),ts1);
						end;
					end;
				end;

				if sl.Count <> 0 then begin
					for k1 := 0 to sl.Count - 1 do begin
						ts1 := sl.Objects[k1] as TMob;
						dmg[0] := dmg[1] * ElementTable[0][ts1.Element] div 100; //ëÆê´ëäê´ï‚ê≥
						if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 5);
						//É_ÉÅÅ[ÉWèàóù
						if ts = ts1 then
							dmg[7] := dmg[0]
						else
							DamageProcess1(tm, tc, ts1, dmg[0], Tick);
					end;
				end;
				sl.Free;
				{ïœçXÉRÉRÇ‹Ç≈}
			end else begin
				dmg[7] := 0;
			end;
			//é©ìÆëÈèIÇÌÇË

			//É_ÉÅÅ[ÉWéZèo
			DamageCalc1(tm, tc, ts, Tick);
			if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
			if Weapon = 16 then begin
				//ÉJÉ^Å[Éãí«åÇ
				dmg[1] := dmg[0] * (1 + Skill[48].Lv * 2) div 100;
			end else if WeaponType[1] <> 0 then begin
				//ìÒìÅó¨ç∂éË
				k := dmg[0];
				DamageCalc1(tm, tc, ts, Tick, 1);
				if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
				dmg[1] := dmg[0];
				dmg[0] := k;
			end else begin
				dmg[1] := 0;
			end;

			{Colus, 20040106: Changed this to work with modded Steal calc.
							20040114: Moved this so that you have to do damage before Snatching,
												added the MVP checks/slave checks back.
							20040122: No more Snatching with ranged weapons.}
			{TODO: Figure out proper modification of Snatcher by Steal skill.}
			if ((dmg[0] <> 0) and (tc.Skill[210].Lv <> 0) and (tc.Weapon <> 11) and (Random(1000) < ((tc.Skill[210].Data.Data1[Skill[210].Lv] * 10) + tc.Skill[50].Data.Data1[Skill[50].Lv]))) then begin
				StealItem(tc);
			end;
			SendCAttack1(tc, dmg[0], dmg[1], dmg[4], dmg[5], tm, ts, Tick);

			//Transformed to SendCAttack1
			{WFIFOW( 0, $008a);
			WFIFOL( 2, ID);
			WFIFOL( 6, ATarget);
			WFIFOL(10, timeGetTime());
			WFIFOL(14, aMotion);
			WFIFOL(18, ts.Data.dMotion);
			WFIFOW(22, dmg[0]); //É_ÉÅÅ[ÉW
			WFIFOW(24, dmg[4]); //ï™äÑêî
			WFIFOB(26, dmg[5]); //0=íPçUåÇ 8=ï°êî 10=ÉNÉäÉeÉBÉJÉã
			WFIFOW(27, dmg[1]); //ãtéË
			SendBCmd(tm, ts.Point, 29); }

			//ÉXÉvÉâÉbÉVÉÖçUåÇêÁóté†âÍç≤âÍ(ﬂÅÕﬂ)
			if SplashAttack then begin
				CharaSplash(tc,Tick);
			end;

			if not DamageProcess1(tm, tc, ts, dmg[0] + dmg[1] + dmg[7], Tick) then
				StatCalc1(tc, ts, Tick);
			ATick := ATick + ADelay;

		end;
	end;
end;
//------------------------------------------------------------------------------
//ï™äÑÇQ
procedure TfrmMain.CharaAttack2(tc:TChara;Tick:cardinal);
var
	i1 : Integer;
	j1 : Integer;
	k1 : Integer;
	k  : Integer;
	tm:TMap;
	tc1:TChara;
	tc2:TChara;
	xy:TPoint;
	sl:TStringList;
	tl:TSkillDB;
begin
	with tc do begin
		tc1 := AData;
		tm := MData;

		if tc1.HP <= 0 then begin
			tc1.HP := 0;
			AMode := 0;
			Exit;
		end;
		if (pcnt <> 0) and (abs(Point.X - tc1.Point.X) <= Range) and (abs(Point.Y - tc1.Point.Y) <= Range) then begin
			Sit := 3;
			HPTick := timeGetTime();
			HPRTick := timeGetTime() - 500;
			SPRTick := timeGetTime();
			pcnt := 0;
			UpdatePlayerLocation(tm, tc);

			if ATick + ADelay - 200 < Tick then ATick := Tick - ADelay + 200;
		end;
		if (abs(Point.X - tc1.Point.X) <= Range) and (abs(Point.Y - tc1.Point.Y) <= Range) then begin
			if tc1 = nil then begin
				AMode := 0;
				Exit;
			end;
			if Weapon = 11 then begin
				if (Arrow = 0) or (Item[Arrow].Amount = 0) then begin
					WFIFOW(0, $013b);
					WFIFOW(2, 0);
					Socket.SendBuf(buf, 4);
					ATick := ATick + ADelay;
					Exit;
				end;
				Dec(Item[Arrow].Amount);
				WFIFOW( 0, $00af);
				WFIFOW( 2, Arrow);
				WFIFOW( 4, 1);
				Socket.SendBuf(buf, 6);
				if Item[Arrow].Amount = 0 then begin
					Item[Arrow].ID := 0;
					Arrow := 0;
				end;
			end;
			if Weight * 100 div MaxWeight >= 90 then begin
				WFIFOW(0, $013b);
				WFIFOW(2, 1);
				Socket.SendBuf(buf, 4);
				AMode := 0;
				Exit;
			end;
			if (Option and 16 <> 0) and (Skill[129].Lv <> 0) and (Random(1000) < Param[5] * 10 div 3) then begin //ämó¶É`ÉFÉbÉN
				if (JobLV + 9) div 10 < Skill[129].Lv then begin
					dmg[4] := (JobLV + 9) div 10;
				end else begin
					dmg[4] := Skill[129].lv;
				end;
				if Skill[128].Lv <> 0 then begin
					dmg[1] := Skill[128].Data.Data1[Skill[128].Lv] * 2;
				end else begin
					dmg[1] := 0;
				end;
				dmg[1] := dmg[1] + (Param[4] div 10 + Param[3] div 2) * 2 + 80;
				dmg[1] := dmg[1] * dmg[4];
				MMode := 0;
				MSkill := 129;
				MUseLV := $FFFF;

				xy := tc1.Point;
				sl := TStringList.Create;
				tl := Skill[129].Data;
				for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
					for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
						for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
							tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
							if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
								sl.AddObject(IntToStr(tc2.ID),tc2);
						end;
					end;
				end;
				if sl.Count <> 0 then begin
					for k1 := 0 to sl.Count - 1 do begin
						tc2 := sl.Objects[k1] as TChara;
						dmg[0] := dmg[1];
						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], dmg[4]);
						if tc1 = tc2 then
							dmg[7] := dmg[0]
						else
							DamageProcess2(tm, tc, tc2, dmg[0], Tick);
					end;
				end;
				sl.Free;
			end else begin
				dmg[7] := 0;
			end;

			DamageCalc3(tm, tc, tc1, Tick);
			if dmg[0] < 0 then dmg[0] := 0;
			if Weapon = 16 then begin

				dmg[1] := dmg[0] * (1 + Skill[48].Lv * 2) div 100;

			end else if WeaponType[1] <> 0 then begin
				k := dmg[0];
				DamageCalc3(tm, tc, tc1, Tick, 1);
				if dmg[0] < 0 then dmg[0] := 0;
				dmg[1] := dmg[0];
				dmg[0] := k;

			end else begin
				dmg[1] := 0;
			end;
			WFIFOW( 0, $008a);
			WFIFOL( 2, ID);
			WFIFOL( 6, ATarget);
			WFIFOL(10, timeGetTime());
			WFIFOL(14, aMotion);
			WFIFOL(18, tc1.dMotion);
			WFIFOW(22, dmg[0]);
			WFIFOW(24, dmg[4]);
			WFIFOB(26, dmg[5]);
			WFIFOW(27, dmg[1]);
			SendBCmd(tm, tc1.Point, 29);

			{Colus, 20031216: Cancel casting timer on hit. Also, phen card handling.}
			if (tc1.NoCastInterrupt = False) and (dmg[0] > 0) then begin
				tc1.MMode := 0;
				tc1.MTick := 0;
				WFIFOW(0, $01b9);
				WFIFOL(2, tc1.ID);
				SendBCmd(tm, tc1.Point, 6);
			end;
			{Colus, 20031216: end cast-timer cancel}

			if SplashAttack then CharaSplash2(tc,Tick);  //Splash Attack Enabled

			if (tc.Skill[279].Tick > Tick) and (Skill[279].Lv > 0) then begin     {Auto Cast}
				try
					if tc.Skill[279].Data.Data2[tc.Skill[279].Lv] >= Random(100) then begin
						Autocastactive := true;
						tc.MTarget := tc.ATarget;
						tc1 := tm.CList.IndexOfObject(tc.MTarget) as TChara;
						if tc1.HP = 0 then Exit;
						tc.MTargetType := 1;
						tc.AData := tc1;
						i1 := tc.Skill[279].Effect1;
						if (i1 > 0) then j1 := tc.Skill[i1].Lv;
						// What level can you use?
						case i1 of
						11:
							begin
								k := 3;
							end;
						14,19,20,13:
							begin
								k := 3;
							end;
						17:
							begin
								k := 2;
							end;
						15:
							begin
								k := 1;
							end;
						end;//case

						if (j1 > k) then j1 := k;
						tc.MSkill := i1;

						// What level will you be casting at?
						// We reuse i1 and k now...

						k := Random(100);
						if (k < 50) then
							i1 := 1
						else if (k < 85) then
							i1 := 2
						else
							i1 := 3;

						if (j1 < i1) then i1 := j1;

						// Set the final skill level.
						tc.MUseLV := i1;

						DecSP(tc, MSkill, MUseLV);
						SkillEffect(tc, Tick);
						//DamageProcess1(tm, tc, ts, dmg[0] + dmg[1], Tick)

					end;
				except
					exit;
				end;
			end;

			if not DamageProcess2(tm, tc, tc1, dmg[0] + dmg[1] + dmg[7], Tick) then
				StatCalc2(tc, tc1, Tick);

			ATick := ATick + ADelay;
		end;
	end;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.CharaSplash(tc:TChara;Tick:cardinal);  {Splash Damage Versus a Monster}
var
	i1  : Integer;
	j1  : Integer;
	k1  : Integer;
	k   : Integer;
	tm  : TMap;
	ts  : TMob;
	ts1 : TMob;
	xy  : TPoint;
	sl  : TStringList;
begin
	with tc do begin
		ts := AData;
		tm := MData;
		xy := ts.Point;
		sl := TStringList.Create;
		for j1 := (xy.Y - 1) div 8 to (xy.Y + 1) div 8 do begin
			for i1 := (xy.X - 1) div 8 to (xy.X + 1) div 8 do begin
				for k1 := 0 to tm.Block[i1][j1].Mob.Count -1 do begin
					ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
					if ts1 = ts then Continue;
					if (abs(ts1.Point.X - xy.X) <= 1) and (abs(ts1.Point.Y - xy.Y) <= 1) then
						sl.AddObject(IntToStr(ts1.ID),ts1);
				end;
			end;
		end;
		if sl.Count > 0 then begin
			for k1 := 0 to sl.Count -1 do begin
				ts1 := sl.Objects[k1] as TMob;
				DamageCalc1(tm, tc, ts1, Tick);

				if dmg[0] < 0 then dmg[0] := 0; //Negative Damage

				if WeaponType[0] = 16 then begin   
					dmg[1] := dmg[0] * (1 + Skill[48].Lv * 2) div 100;
				end else if WeaponType[1] <> 0 then begin
					//ìÒìÅó¨âEéË
					k := dmg[0];
					DamageCalc1(tm, tc, ts, Tick, 1);
					dmg[1] := dmg[0];
					dmg[0] := k;
				end else begin
					dmg[1] := dmg[0] * (1 + Skill[263].Lv * 2) div 100;;
				end;

				WFIFOW( 0, $008a);
				WFIFOL( 2, ID);
				WFIFOL( 6, ts1.ID);
				WFIFOL(10, timeGetTime());
				WFIFOL(14, aMotion);
				WFIFOL(18, ts1.Data.dMotion);
				WFIFOW(22, dmg[0]); //É_ÉÅÅ[ÉW
				WFIFOW(24, dmg[4]); //ï™äÑêî
				WFIFOB(26, dmg[5]); //0=íPçUåÇ 8=ï°êî 10=ÉNÉäÉeÉBÉJÉã
				WFIFOW(27, dmg[1]); //ãtéË
				SendBCmd(tm, ts1.Point, 29);
				//É_ÉÅÅ[ÉWèàó

				if not DamageProcess1(tm, tc, ts1, dmg[0] + dmg[1], Tick) then
				StatCalc1(tc, ts1, Tick);
			end;
		end;
		{ChrstphrR 2004/04/26 - TSL not freed after creation}
		sl.Free;
	end;
end;//proc TfrmMain.CharaSplash()
//------------------------------------------------------------------------------

{
ChrstphrR 2004/04/27 - Memory Leak fixed - free of leaks.
ChrstphrR 2004/05/31 - Removal of unused variables.
}
procedure TfrmMain.CharaSplash2(tc:TChara;Tick:cardinal);
var
	i1 : Integer;
	j1 : Integer;
	k1 : Integer;
	k  : Integer;
	tm:TMap;
//	ts:TMob;
//	ts1:TMob;
	tc1:TChara;
	tc2:TChara;
	xy:TPoint;
	sl:TStringList;
begin
	with tc do begin
		tc1 := AData;
		tm := MData;
		xy := tc1.Point;
		sl := TStringList.Create;
		for j1 := (xy.Y - 1) div 8 to (xy.Y + 1) div 8 do begin
			for i1 := (xy.X - 1) div 8 to (xy.X + 1) div 8 do begin
				for k1 := 0 to tm.Block[i1][j1].CList.Count -1 do begin
					tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
					if tc2 = tc1 then Continue;
                    if tc2 = tc then Continue;
					if (abs(tc2.Point.X - xy.X) <= 1) and (abs(tc2.Point.Y - xy.Y) <= 1) then
						sl.AddObject(IntToStr(tc2.ID),tc2);
				end;
			end;
		end;
		if sl.Count > 0 then begin
			for k1 := 0 to sl.Count -1 do begin
				tc2 := sl.Objects[k1] as TChara;
				DamageCalc3(tm, tc, tc2, Tick);
				if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
				if WeaponType[0] = 16 then begin
				//ÉJÉ^Å[Éãí«åÇ
					dmg[1] := dmg[0] * (1 + Skill[48].Lv * 2) div 100;
				end else if WeaponType[1] <> 0 then begin
					//ìÒìÅó¨âEéË
					k := dmg[0];
					DamageCalc3(tm, tc, tc1, Tick, 1);
					dmg[1] := dmg[0];
					dmg[0] := k;
				end else begin
					dmg[1] := 0;
				end;
				WFIFOW( 0, $008a);
				WFIFOL( 2, ID);
				WFIFOL( 6, tc2.ID);
				WFIFOL(10, timeGetTime());
				WFIFOL(14, aMotion);
				WFIFOL(18, tc2.dMotion);
				WFIFOW(22, dmg[0]); //É_ÉÅÅ[ÉW
				WFIFOW(24, dmg[4]); //ï™äÑêî
				WFIFOB(26, dmg[5]); //0=íPçUåÇ 8=ï°êî 10=ÉNÉäÉeÉBÉJÉã
				WFIFOW(27, dmg[1]); //ãtéË
				SendBCmd(tm, tc2.Point, 29);
				//É_ÉÅÅ[ÉWèàóù
				if not DamageProcess2(tm, tc, tc2, dmg[0] + dmg[1], Tick) then
				StatCalc2(tc, tc2, Tick);
			end;
		end;
		sl.Free; //ChrstphrR - 2004/04/27 Must free created objects
	end;
end;//proc TfrmMain.CharaSplash2()
//------------------------------------------------------------------------------
{ChrstphrR 2004/04/27 - Memory leak fixes.}
{í«â¡}
procedure TfrmMain.CreateField(tc:TChara; Tick:Cardinal);
var
	i : Integer;
	j : Integer;
	b : Integer;
	i1,j1,k1:integer;
	tm  :TMap;
	tn  :TNPC;
	ts1 :TMob;
	tl  :TSkillDB;
	xy  :TPoint;
	bb  :array of byte;
	sl  :TStringList;
begin
	sl := TStringList.Create;
	tm := tc.MData;
	tl := tc.Skill[tc.MSkill].Data;
	if tc.Skill[269].Tick > Tick then exit;

	if tc.isSilenced then begin
		SilenceCharacter(tm, tc, Tick);
		sl.Free;
		Exit;//Safe 2004/04/26
	end;

	with tc do begin
		case MSkill of
		21,91: {Thunder Storm, Heaven Drive}
			begin
				//Cast on the Point Targeted
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;

				sl.Clear;
				for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
					for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
						for k1 := 0 to tm.Block[i1][j1].Mob.Count -1 do begin
							ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
							if (abs(ts1.Point.X - xy.X) > tl.Range2) or (abs(ts1.Point.Y - xy.Y) > tl.Range2) then
								Continue;
							sl.AddObject(IntToStr(ts1.ID),ts1)
						end;//for k1
					end;//for i1
				end;//for j1

				//If Monster is in the Area
				if sl.Count <> 0 then begin
					for k1 := 0 to sl.Count -1 do begin
						ts1 := sl.Objects[k1] as TMob;

						//Caculate Damage
						dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
						dmg[0] := dmg[0] * (100 - ts1.Data.MDEF) div 100; //MDEF%
						dmg[0] := dmg[0] - ts1.Data.Param[3]; //MDEF-
						if dmg[0] < 1 then dmg[0] := 1;
						dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100;
						dmg[0] := dmg[0] * tl.Data2[MUseLV];
						if (ts1.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
						if dmg[0] < 0 then dmg[0] := 0; //Negative Damage
						//Send Attack
						SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], tl.Data2[MUseLV]);
						//Send Damage
						DamageProcess1(tm, tc, ts1, dmg[0], Tick);
					end;
				end;
				tc.MTick := Tick + 1000;
				if MSkill = 21 then Inc(tc.MTick,1000);
			end;
		12:     {Safety Wall}
			begin
				j := SearchCInventory(tc, 717, false);
				if ((j <> 0) and (tc.Item[j].Amount >= 1)) or (NoJamstone = True) then begin
					if NoJamstone = False then UseItem(tc, j);  //Use Item Function
					xy.X := MPoint.X;
					xy.Y := MPoint.Y;
					tn := SetSkillUnit(tm, ID, xy, Tick, $7e, tl.Data2[MUseLV], tl.Data1[MUseLV] * 1000);
					tn.MSkill := MSkill;
				end else begin
					SendSkillError(tc, 8); //No Blue Gemstone
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;
		18:     {Fire Wall}
			begin
				xy.X := MPoint.X - Point.X;
				xy.Y := MPoint.Y - Point.Y;
				if abs(xy.X) > abs(xy.Y) * 3 then begin
					//â°å¸Ç´
					if xy.X > 0 then b := 6 else b := 2;
				end else if abs(xy.Y) > abs(xy.X) * 3 then begin
					//ècå¸Ç´
					if xy.Y > 0 then b := 0 else b := 4;
				end else begin
					if xy.X > 0 then begin
						if xy.Y > 0 then b := 7 else b := 5;
					end else begin
						if xy.Y > 0 then b := 1 else b := 3;
					end;
				end;
				//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('FireWall: (%d,%d) %d', [xy.X, xy.Y, b]));

				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				tn := SetSkillUnit(tm, ID, xy, Tick, $7f, tl.Data2[MUseLV], tl.Data2[MUseLV] * 1000);
                FireWallCount := FireWallCount + 1;
				tn.CData := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;
				SetLength(bb, 1);
				bb[0] := 2;
				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $7f, tl.Data2[MUseLV], tl.Data2[MUseLV] * 1000);
                FireWallCount := FireWallCount + 1;
				tn.CData := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				bb[0] := 6;
				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $7f, tl.Data2[MUseLV], tl.Data2[MUseLV] * 1000);
                FireWallCount := FireWallCount + 1;
				tn.CData := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;
				{ Colus, 20031219: Removed the stair-step pattern for diagonal FWs
				if (b mod 2) <> 0 then begin

						xy.X := MPoint.X;
						xy.Y := MPoint.Y;
					bb[0] := 3;
					DirMove(tm, xy, b, bb);
					tn := SetSkillUnit(tm, ID, xy, Tick, $7f, tl.Data2[MUseLV], tl.Data2[MUseLV] * 1000);
					tn.CData := tc;
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
					xy.X := MPoint.X;
					xy.Y := MPoint.Y;
					bb[0] := 5;
					DirMove(tm, xy, b, bb);
					tn := SetSkillUnit(tm, ID, xy, Tick, $7f, tl.Data2[MUseLV], tl.Data2[MUseLV] * 1000);
					tn.CData := tc;
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
				end;
				Colus, 20031219: FW update end}
			end;
		25:     {Pneuma}
			begin
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				tn := SetSkillUnit(tm, ID, xy, Tick, $85, 0, tl.Data1[1] * 1000);
				tn.MSkill := MSkill;
			end;

		27:     {Warp Portal}
			begin
				ZeroMemory(@buf[0], 68);
				WFIFOW( 0, $011c);
				WFIFOW( 2, 27);
				WFIFOS( 4, SaveMap + '.gat', 16);
				for j := 0 to tl.Data1[Skill[27].Lv] - 1 do begin
					if MemoMap[j] <> '' then WFIFOS(20+j*16, MemoMap[j] + '.gat', 16);
				end;
				Socket.SendBuf(buf, 68);
				MMode := 4;
				sl.Free;
				Exit;//safe 2004/04/26
			end;

		70:     {Sanctuary}
			begin
				j := SearchCInventory(tc, 717, false);
				if ((j <> 0) and (tc.Item[j].Amount >= 1)) or (NoJamstone = True) then begin

					if NoJamstone = False then UseItem(tc, j);
					// Colus, 20040117: Corrected position of Sanctuary field
					for j1 := 1 to 5 do begin
						for i1 := 1 to 5 do begin
							if ((i1 < 2) or (i1 > 4)) and ((j1 < 2) or (j1 > 4)) then Continue;
							xy.X := (MPoint.X) -3 + i1;
							xy.Y := (MPoint.Y) -3 + j1;

							if (xy.X < 0) or (xy.X >= tm.Size.X) or (xy.Y < 0) or (xy.Y >= tm.Size.Y) then Continue;
							tn := SetSkillUnit(tm, ID, xy, Tick, $46, 10, tl.Data1[MUseLV] * 1000);
							tn.CType  := 4;
							tn.CData  := tc;
							tn.MSkill := MSkill;
							tn.MUseLV := MUseLV;
						end;//for i1
					end;//for j1

				end else begin
					SendSkillError(tc, 8); //No Blue Gemstone
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;
		79:     {Magnus Exorcism}
			begin
				j := SearchCInventory(tc, 717, false);
				if ((j <> 0) and (tc.Item[j].Amount >= 1)) or (NoJamstone) then begin

					if NOT NoJamstone then UseItem(tc, j); //Function Call to Use item
					for j1 := 1 to 7 do begin
						for i1 := 1 to 7 do begin
							if ((i1 < 3) or (i1 > 5)) and ((j1 < 3) or (j1 > 5)) then Continue;
							xy.X := (MPoint.X) -4 + i1;
							xy.Y := (MPoint.Y) -4 + j1;
							if (xy.X < 0) or (xy.X >= tm.Size.X) or (xy.Y < 0) or (xy.Y >= tm.Size.Y) then Continue;
							tn := SetSkillUnit(tm, ID, xy, Tick, $84, tl.Data2[MUseLV], (4+MUseLV)*1000);
							tn.Tick := Tick + ((4+MUseLV) * 1000); //tl.Data1[MUseLV];
							tn.CData := tc;
							tn.MSkill := MSkill;
							tn.MUseLV := MUseLV;
						end;//for i1
					end;//for j1
					tc.MTick := Tick + 4000;  // Cast delay 4s

				end else begin  //Doesn't have Gemstone
					SendSkillError(tc, 8); //No Blue Gemstone
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;
		80:     {Fire Pillar}
			begin
				j := SearchCInventory(tc, 717, False);
				if ((j <> 0) AND (tc.Item[j].Amount >= 1)) OR (NoJamstone) then begin
					//Function Call to use item
					if NOT NoJamstone then UseItem(tc, j);
					xy.X := MPoint.X;
					xy.Y := MPoint.Y;
					tn := SetSkillUnit(tm, ID, xy, Tick, $87, MUseLV, 30000, tc);
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
				end else begin
					SendSkillError(tc, 8); //No Blue Gemstone
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;
		83:     {Meteor}
			begin
				//Cast Point
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;

				//Place the Effect
				tn := SetSkillUnit(tm, ID, xy, Tick, $88, 0, 3000, tc);

				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				for i := 1 to Skill[83].Data.Data2[MUseLV] do begin;
					WFIFOW( 0, $0117);
					WFIFOW( 2, MSkill);
					WFIFOL( 4, ID);
					WFIFOW( 8, MUseLV);
					WFIFOW(10, (MPoint.X - 4 + Random(12)));
					WFIFOW(12, (MPoint.Y - 4 + Random(12)));
					WFIFOL(14, 1);
					SendBCmd(tm, xy, 18);
				end;
			end;

		85:     {Lord of Vermillion}
			begin
				//Cast Point
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;

				//Create Graphics and Set NPC
				tn := SetSkillUnit(tm, ID, xy, Tick, $86, 0, 4000, tc);
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;
        tc.MTick := Tick + 5000;
			end;

		404: // Fog Wall
			begin
				xy.X := MPoint.X - Point.X;
				xy.Y := MPoint.Y - Point.Y;
				if Abs(xy.X) > Abs(xy.Y) * 3 then begin

					if xy.X > 0 then b := 6 else b := 2;
				end else if Abs(xy.Y) > Abs(xy.X) * 3 then begin
					if xy.Y > 0 then b := 0 else b := 4;
				end else begin
					if xy.X > 0 then begin
						if xy.Y > 0 then b := 7 else b := 5;
					end else begin
						if xy.Y > 0 then b := 1 else b := 3;
					end;
				end;

				SetLength(bb, 1);
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				tn := SetSkillUnit(tm, ID, xy, Tick, $b6, tl.Data2[MUseLV], 20000);
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				bb[0] := 2;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $b6, tl.Data2[MUseLV], 20000);
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $b6, tl.Data2[MUseLV], 20000);
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				bb[0] := 6;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $b6, tl.Data2[MUseLV], 20000);
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $b6, tl.Data2[MUseLV], 20000);
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;
			end;
		405: // Spider Web
			begin
				xy.X := MPoint.X - Point.X;
				xy.Y := MPoint.Y - Point.Y;
				if Abs(xy.X) > Abs(xy.Y) * 3 then begin
					if xy.X > 0 then b := 6 else b := 2;
				end else if Abs(xy.Y) > Abs(xy.X) * 3 then begin
					if xy.Y > 0 then b := 0 else b := 4;
				end else begin
					if xy.X > 0 then begin
						if xy.Y > 0 then b := 7 else b := 5;
					end else begin
						if xy.Y > 0 then b := 1 else b := 3;
					end;
				end;
				SetLength(bb, 1);

				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				tn := SetSkillUnit(tm, ID, xy, Tick, $b7, tl.Data2[MUseLV], 8000);
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				bb[0] := 2;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $b7, tl.Data2[MUseLV], 8000);
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $b7, tl.Data2[MUseLV], 8000);
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				bb[0] := 6;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $b7, tl.Data2[MUseLV], 8000);
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $b7, tl.Data2[MUseLV], 8000);
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

			end;
		87:     {Ice Wall}
			begin
				xy.X := MPoint.X - Point.X;
				xy.Y := MPoint.Y - Point.Y;
				if Abs(xy.X) > Abs(xy.Y) * 3 then begin

					if xy.X > 0 then b := 6 else b := 2;
				end else if Abs(xy.Y) > Abs(xy.X) * 3 then begin

					if xy.Y > 0 then b := 0 else b := 4;
				end else begin
					if xy.X > 0 then begin
						if xy.Y > 0 then b := 7 else b := 5;
					end else begin
						if xy.Y > 0 then b := 1 else b := 3;
					end;
				end;
				//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('IceWall: (%d,%d) %d', [xy.X, xy.Y, b]));
				{Colus, 20031219: Extended IW to 5 tiles,
				Removed stair-step pattern on diagonal IWs,
				Made duration dependent on skill level.
				TODO:
				1) Why does center tile last 1s longer on level 1 IW?
					 - Tested, it's all on same tick--may be client prob?
				2) Make IWs damageable (change mode?)
					 Durability based on level (floor(500, 200+(level*200)))
					 Durability based on time (decay over time, rate = ?)
				3) Find push-back and remove it (related to 2?)
				}

				SetLength(bb, 1);

				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				tn := SetSkillUnit(tm, ID, xy, Tick, $8d, tl.Data2[MUseLV], MUseLV * 5000);
                IceWallCount := IceWallCount + 1;
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				//SetLength(bb, 1);

				bb[0] := 2;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $8d, tl.Data2[MUseLV], MUseLV * 5000);
                IceWallCount := IceWallCount + 1;
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $8d, tl.Data2[MUseLV], MUseLV * 5000);
                IceWallCount := IceWallCount + 1;
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				bb[0] := 6;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $8d, tl.Data2[MUseLV], MUseLV * 5000);
                IceWallCount := IceWallCount + 1;
				tn.CData := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $8d, tl.Data2[MUseLV], MUseLV * 5000);
                IceWallCount := IceWallCount + 1;
				tn.CData := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				{Colus, 20031219: Removed stair-step pattern for diagonal IWs
				if (b mod 2) <> 0 then begin
					//éŒÇﬂå¸Ç´
					xy.X := MPoint.X;
					xy.Y := MPoint.Y;
					bb[0] := 3;
					DirMove(tm, xy, b, bb);
					tn := SetSkillUnit(tm, ID, xy, Tick, $8d, tl.Data2[MUseLV], MUseLV * 5000);
					tn.CData := tc;
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
					xy.X := MPoint.X;
					xy.Y := MPoint.Y;
					bb[0] := 5;
					DirMove(tm, xy, b, bb);
					tn := SetSkillUnit(tm, ID, xy, Tick, $8d, tl.Data2[MUseLV], MUseLV * 5000);
					tn.CData := tc;
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
				end;
				Colus, 20031219: End IW modifications}
			end;

		89:     {Storm Gust}
			begin
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				tn := SetSkillUnit(tm, ID, xy, Tick, $86, 0, 4500, tc);
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

        tc.MTick := Tick + 5000;

			end;
		140: //venom dust
			begin
				j := SearchCInventory(tc, 716, false);
				if ((j <> 0) and (tc.Item[j].Amount >= 1)) or (NoJamstone) then begin
					if NOT NoJamstone then UseItem(tc, j);
					xy.X := (tc.Point.X);
					xy.Y := (tc.Point.Y) + 1;
					WFIFOW( 0, $0117);
					WFIFOW( 2, MSkill);
					WFIFOL( 4, ID);
					WFIFOW( 8, MUseLV);
					WFIFOW(10, xy.X);
					WFIFOW(12, xy.Y);
					WFIFOL(14, 1);
					SendBCmd(tm, xy, 18);
					tn := SetSkillUnit(tm, ID, xy, Tick, $92, 0, tl.Data1[MUseLv] * 1000, tc);
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
					xy.X := (tc.Point.X) + 1;
					xy.Y := (tc.Point.Y);
					WFIFOW( 0, $0117);
					WFIFOW( 2, MSkill);
					WFIFOL( 4, ID);
					WFIFOW( 8, MUseLV);
					WFIFOW(10, xy.X);
					WFIFOW(12, xy.Y);
					WFIFOL(14, 1);
					SendBCmd(tm, xy, 18);
					tn := SetSkillUnit(tm, ID, xy, Tick, $92, 0, tl.Data1[MUseLv] * 1000, tc);
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
					xy.X := (tc.Point.X) - 1;
					xy.Y := (tc.Point.Y);
					WFIFOW( 0, $0117);
					WFIFOW( 2, MSkill);
					WFIFOL( 4, ID);
					WFIFOW( 8, MUseLV);
					WFIFOW(10, xy.X);
					WFIFOW(12, xy.Y);
					WFIFOL(14, 1);
					SendBCmd(tm, xy, 18);
					tn := SetSkillUnit(tm, ID, xy, Tick, $92, 0, tl.Data1[MUseLv] * 1000, tc);
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
					xy.X := (tc.Point.X);
					xy.Y := (tc.Point.Y) - 1;
					WFIFOW( 0, $0117);
					WFIFOW( 2, MSkill);
					WFIFOL( 4, ID);
					WFIFOW( 8, MUseLV);
					WFIFOW(10, xy.X);
					WFIFOW(12, xy.Y);
					WFIFOL(14, 1);
					SendBCmd(tm, xy, 18);
					tn := SetSkillUnit(tm, ID, xy, Tick, $92, 0, tl.Data1[MUseLv] * 1000, tc);
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
				end else begin
					SendSkillError(tc, 7); //No Red Gemstone
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;
		92:     {Quagmire}
 			begin
 			  xy.X := MPoint.X; // not even needed
 			  xy.Y := MPoint.Y; // not even needed
 				for i := 0 to 4 do begin
          for j := 0 to 4 do begin
					  xy.Y := - 2 + tc.MPoint.Y + j;
 					  xy.X := - 2 + tc.MPoint.X + i;
					  tn := SetSkillUnit(tm, ID, xy, Tick, $8E, 0, tc.Skill[92].Data.Data1[MUseLv]*1000,tc); // You could/should? use tc.Skill[92].Data.Data1[MUseLv] * 1000 for the time instead of tc.MUseLv*5000, that would make it rely totally on DB
   				  tn.MSkill := tc.MSkill;
  				  tn.MUseLV := tc.MUseLV;
          end;
        end;
      end;{Quagmire}

		110:    {Hammer Fall}
			if (tc.Weapon = 6) or (tc.Weapon = 7) or (tc.Weapon = 8) then begin
				//Cast Point
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;

				//Create Graphics and Set NPC
				tn := SetSkillUnit(tm, ID, xy, Tick, $6E, 0, 3000, tc);
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;
			end else begin
				SendSkillError(tc, 6); // Wrong weapon
				tc.MMode := 4;
				tc.MPoint.X := 0;
				tc.MPoint.Y := 0;
				sl.Free;
				Exit;//safe 2004/04/26
			end;{Hammer Fall}
		264:
			begin
				if tc.spiritSpheres <> 0 then begin
					//Cast Point
					xy.X := MPoint.X;
					xy.Y := MPoint.Y;

					tn := SetSkillUnit(tm, ID, xy, Tick, $2E, 0, 3000, tc);

					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
					tc.spiritSpheres := tc.spiritSpheres - 1;
					UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

					// Colus, 20040225: This is not done yet.
					// This will move the player to the right spot, but it does not
					// check to make sure the target can be reached.  If you try to jump
					// through a wall/cliff, you will be stuck until you dash to a tile
					// you could move to validly.  HOWEVER, this will correctly update your
					// position now.
					if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
						with tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist do begin
							Assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
							Delete(IndexOf(tc.ID));
						end;
						tm.Block[xy.X div 8][xy.Y div 8].Clist.AddObject(tc.ID, tc);
					end;
					tc.pcnt := 0;
					tc.Point := xy;
					UpdatePlayerLocation(tm, tc);
				end else begin
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;

		115:    {Skid Trap}
			begin
				j := SearchCInventory(tc, 1065, false);
				if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
					UseItem(tc, j);  //Use Item Function Call

					//Cast point
					xy.X := MPoint.X;
					xy.Y := MPoint.Y;

					//Graphical Effects and placing NPC
					tn := SetSkillUnit(tm, ID, xy, Tick, $90, MUseLV, tl.Data2[MUseLV] * 1000, tc);
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
				end else begin

					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;{Skid Trap}
		116:    {Land Mine}
			begin
				j := SearchCInventory(tc, 1065, false);
				if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
					UseItem(tc, j); //Use Item Function Call

					//Set Cast point
					xy.X := MPoint.X;
					xy.Y := MPoint.Y;

					//Graphical Effects and placing NPC
					tn := SetSkillUnit(tm, ID, xy, Tick, $93, MUseLV, tl.Data2[MUseLV] * 1000, tc);
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;

				end else begin
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					Exit;
				end;
			end;{Land Mine}
		117:    {Ankle Snare Trap}
			begin
				j := SearchCInventory(tc, 1065, false);
				if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
					UseItem(tc, j); //Use Item Function Call

					//Cast Point
					xy.X := MPoint.X;
					xy.Y := MPoint.Y;

					tn := SetSkillUnit(tm, ID, xy, Tick, $91, MUseLV, tl.Data2[MUseLV] * 1000, tc);
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
				end else begin
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;{Ankle Snare Trap}

		118:    {Shock Wave Trap}
			begin
				j := SearchCInventory(tc, 1065, false);
				if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
					UseItem(tc, j); //Use Item Function Call

					//Cast Point
					xy.X := MPoint.X;
					xy.Y := MPoint.Y;

					tn := SetSkillUnit(tm, ID, xy, Tick, $94, MUseLV, tl.Data2[MUseLV] * 1000, tc);
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;

				end else begin
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;{Shock Wave Trap}

		119:    {Sandman Trap}
			begin
				j := SearchCInventory(tc, 1065, false);
				if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
					UseItem(tc, j); //Use Item Function Call

					//Cast Point
					xy.X := MPoint.X;
					xy.Y := MPoint.Y;

					tn := SetSkillUnit(tm, ID, xy, Tick, $95, MUseLV, tl.Data2[MUseLV] * 1000, tc);
					tn.MSkill := MSkill;

				end else begin
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;{Sandman Trap}
		120:    {Flasher Trap}
			begin
				j := SearchCInventory(tc, 1065, false);
				if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
					UseItem(tc, j); //Use Item Function Call

					xy.X := MPoint.X;
					xy.Y := MPoint.Y;

					tn := SetSkillUnit(tm, ID, xy, Tick, $96, MUseLV, tl.Data2[MUseLV] * 1000, tc);
					tn.MSkill := MSkill;

				end else begin
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;
		121:    {Freezing Trap}
			begin
				j := SearchCInventory(tc, 1065, false);
				if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
					UseItem(tc, j); //Use Item Function Call

					xy.X := MPoint.X;
					xy.Y := MPoint.Y;
					tn := SetSkillUnit(tm, ID, xy, Tick, $97, MUseLV, tl.Data2[MUseLV] * 1000, tc);
					tn.MSkill := MSkill;
				end else begin
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;
		122:    {Blast Mine}
			begin
				j := SearchCInventory(tc, 1065, false);
				if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
					UseItem(tc, j); //Use Item Function Call

					xy.X := MPoint.X;
					xy.Y := MPoint.Y;

					tn := SetSkillUnit(tm, ID, xy, Tick, $8f, MUseLV, tl.Data2[MUseLV] * 1000, tc);
					tn.MSkill := MSkill;
				end else begin
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;{Blast Mine}
		//264:    {Body Relocation}
			{begin
				if ((tc.Point.X <> tc.MPoint.X) and (tc.Point.Y = tc.MPoint.Y)) or ((tc.Point.X = tc.MPoint.X) and (tc.Point.Y <> tc.MPoint.Y)) and (tm.gat[tc.MPoint.X, tc.MPoint.Y] <> 1) and (tm.gat[tc.MPoint.X, tc.MPoint.Y] <> 5) then begin
					WFIFOW( 0, $011a);
					WFIFOW( 2, tc.MSkill);
					WFIFOW( 4, dmg[0]);
					WFIFOL( 6, tc.ID);
					WFIFOL(10, tc.ID);
					WFIFOB(14, 1);
					SendBCmd(tm,tc.Point,15);

					SendCLeave(tc, 2);
					tc.tmpMap := tc.Map;
					tc.Point.X := tc.MPoint.X;
					tc.Point.Y := tc.MPoint.Y;
					MapMove(Socket, tc.Map, tc.Point);
					tc.SP := tc.SP - tl.SP[tc.MUseLV];
					MMode := 4;
					sl.Free;//CR - added just in case this is uncommented later!
					Exit;//safe 2004/04/26
				end else begin
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;//CR - added just in case this is uncommented later!
					Exit;//safe 2004/04/26
				end;
			end;}

		123:    {Claymore Trap}
			begin
				j := SearchCInventory(tc, 1065, false);
				if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
					UseItem(tc, j); //Use Item Function Call

					xy.X := MPoint.X;
					xy.Y := MPoint.Y;
					tn := SetSkillUnit(tm, ID, xy, Tick, $98, MUseLV, tl.Data2[MUseLV] * 1000, tc);
					tn.MSkill := MSkill;

				end else begin
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;
		130:
			begin
				xy.X := tc.MPoint.X;
				xy.Y := tc.MPoint.Y;
				i1 := abs(tc.Point.X - xy.X);
				j1 := abs(tc.Point.Y - xy.Y);
				i := (1 + (2 * tc.Skill[130].Lv));

				if (tc.Option and 16 <> 0) and (i1 <= i) and (j1 <= i) then begin

					sl.Clear;

					for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
						for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
							for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
								if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then continue;
								ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
								if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
									sl.AddObject(IntToStr(ts1.ID),ts1);
							end;
						end;
					end;

					if sl.Count <> 0 then begin
						for k1 := 0 to sl.Count - 1 do begin
							ts1 := sl.Objects[k1] as TMob;
							if (ts1.Hidden = true) then begin
								ts1.Hidden := false;
								WFIFOW(0, $0119);
								WFIFOL(2, ts1.ID);
								WFIFOW(6, 0);
								WFIFOW(8, 0);
								WFIFOW(10, 0);
								WFIFOB(12, 0);
								SendBCmd(tm, ts1.Point, 13);
							end;
						end;
					end;
				end else begin
					SendSkillError(tc, 0);
					tc.MMode := 4;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;
		229:    {Demonstration}
			begin
				j := SearchCInventory(tc, 7135, false);
				if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
					UseItem(tc, j); //Use Item Function Call

					xy.X := MPoint.X - Point.X;
					xy.Y := MPoint.Y - Point.Y;

					if abs(xy.X) > abs(xy.Y) * 3 then begin
						if xy.X > 0 then b := 6 else b := 2;
					end else if abs(xy.Y) > abs(xy.X) * 3 then begin
						if xy.Y > 0 then b := 0 else b := 4;
					end else begin
						if xy.X > 0 then begin
							if xy.Y > 0 then b := 7 else b := 5;
						end else begin
							if xy.Y > 0 then b := 1 else b := 3;
						end;
					end;
					xy.X := MPoint.X;
					xy.Y := MPoint.Y;
					tn := SetSkillUnit(tm, ID, xy, Tick, $E5, tl.Data1[MUseLV], tl.Data1[MUseLV] * 1000);
					tn.CData  := tc;
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
					SetLength(bb, 1);
					bb[0] := 2;
					DirMove(tm, xy, b, bb);
					tn := SetSkillUnit(tm, ID, xy, Tick, $E5, tl.Data1[MUseLV], tl.Data1[MUseLV] * 1000);
					tn.CData  := tc;
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
					xy.X := MPoint.X;
					xy.Y := MPoint.Y;
					bb[0] := 6;
					DirMove(tm, xy, b, bb);
					tn := SetSkillUnit(tm, ID, xy, Tick, $E5, tl.Data2[MUseLV], tl.Data2[MUseLV] * 1000);
					tn.CData := tc;

					WFIFOW( 0, $011f);
					WFIFOL( 2, tn.ID);
					WFIFOL( 6, ID);
					WFIFOW(10, tn.Point.X);
					WFIFOW(12, tn.Point.Y);
					WFIFOB(14, $b1);
					WFIFOB(15, 1);
					SendBCmd(tm, tn.Point, 16);

					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
					if (b mod 2) <> 0 then begin
						//éŒÇﬂå¸Ç´
						xy.X := MPoint.X;
						xy.Y := MPoint.Y;
						bb[0] := 3;
						DirMove(tm, xy, b, bb);
						tn := SetSkillUnit(tm, ID, xy, Tick, $E5, tl.Data1[MUseLV], tl.Data1[MUseLV] * 1000);
						tn.CData := tc;
						tn.MSkill := MSkill;
						tn.MUseLV := MUseLV;
						xy.X := MPoint.X;
						xy.Y := MPoint.Y;
						bb[0] := 5;
						DirMove(tm, xy, b, bb);
						tn := SetSkillUnit(tm, ID, xy, Tick, $E5, tl.Data1[MUseLV], tl.Data1[MUseLV] * 1000);
						tn.CData := tc;
															tn.MSkill := 83;
						tn.MUseLV := MUseLV;
					end;
				end else begin
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;

		{230:    {Acid Terror}
			{begin
				j := SearchCInventory(tc, 7136, false);
				if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
					UseItem(tc, j); //Use Item Function Call

					xy.X := MPoint.X - Point.X;
					xy.Y := MPoint.Y - Point.Y;
					if abs(xy.X) > abs(xy.Y) * 3 then begin
						if xy.X > 0 then b := 6 else b := 2;
					end else if abs(xy.Y) > abs(xy.X) * 3 then begin
						if xy.Y > 0 then b := 0 else b := 4;
					end else begin
						if xy.X > 0 then begin
							if xy.Y > 0 then b := 7 else b := 5;
						end else begin
							if xy.Y > 0 then b := 1 else b := 3;
						end;
					end;
					xy.X := MPoint.X;
					xy.Y := MPoint.Y;
					tn := SetSkillUnit(tm, ID, xy, Tick, $E5, tl.Data1[MUseLV], tl.Data1[MUseLV] * 1000);
					tn.CData := tc;
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
					SetLength(bb, 1);
					bb[0] := 2;
					DirMove(tm, xy, b, bb);
					tn := SetSkillUnit(tm, ID, xy, Tick, $E5, tl.Data1[MUseLV], tl.Data1[MUseLV] * 1000);
					tn.CData := tc;
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
					xy.X := MPoint.X;
					xy.Y := MPoint.Y;
					bb[0] := 6;
					DirMove(tm, xy, b, bb);
					tn := SetSkillUnit(tm, ID, xy, Tick, $E5, tl.Data2[MUseLV], tl.Data2[MUseLV] * 1000);
					tn.CData := tc;

					for i := - 2 to 2 do begin
						WFIFOW( 0, $011f);
						WFIFOL( 2, tn.ID);
						WFIFOL( 6, ID);
						WFIFOW(10, tn.Point.X + i);
						WFIFOW(12, tn.Point.Y + i);
						WFIFOB(14, $8e);
						WFIFOB(15, 1);
						SendBCmd(tm, tn.Point, 16);
					end;

					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
					if (b mod 2) <> 0 then begin
						xy.X := MPoint.X;
						xy.Y := MPoint.Y;
						bb[0] := 3;
						DirMove(tm, xy, b, bb);
						tn := SetSkillUnit(tm, ID, xy, Tick, $E5, tl.Data1[MUseLV], tl.Data1[MUseLV] * 1000);
						tn.CData := tc;
						tn.MSkill := MSkill;
						tn.MUseLV := MUseLV;
						xy.X := MPoint.X;
						xy.Y := MPoint.Y;
						bb[0] := 5;
						DirMove(tm, xy, b, bb);
						tn := SetSkillUnit(tm, ID, xy, Tick, $E5, tl.Data1[MUseLV], tl.Data1[MUseLV] * 1000);
						tn.CData := tc;
						tn.MSkill := 83;
						tn.MUseLV := MUseLV;
					end;
				end else begin
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;//CR - just in case it's uncommented
					Exit;//safe 2004/04/26
				end;
			end;}

		233:    {Marine Sphere}
			begin
				j := SearchCInventory(tc, 7138, false);
				if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
					UseItem(tc, j); //Use Item Function Call

					xy.X := MPoint.X;
					xy.Y := MPoint.Y;
					tn := SetSkillUnit(tm, ID, xy, Tick, $E9, MUseLV, tl.Data1[MUseLV] * 1000, tc);
					tn.MSkill := MSkill;
					ts1 := TMob.Create;
					with ts1 do begin
						Point.X := tc.MPoint.X;
						Point.Y := tc.MPoint.Y;
						ts1.ID := 1142;
						Name := 'Marine Sphere';
						ts1.JID := 1142;
						Data := MobDB.IndexOfObject(ts1.JID) as TMobDB;

						ZeroMemory(@buf[0], 41);
						WFIFOW( 0, $007c);
						WFIFOL( 2, ID);
						WFIFOW( 6, 1000);
						WFIFOW( 8, Stat1);
						WFIFOW(10, Stat2);
						WFIFOW(20, JID);
						WFIFOM1(36, Point, Dir);
						SendBCmd(tm,Point,41,nil,true);
					end;
				end else begin
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;
		232:    {Cannabalize (Flora)}
			begin
				j := SearchCInventory(tc, 7137, false);
				if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
					UseItem(tc, j); //Use Item Function Call

					xy.X := MPoint.X;
					xy.Y := MPoint.Y;
					tn := SetSkillUnit(tm, ID, xy, Tick, $F1, MUseLV, tl.Data1[MUseLV] * 1000, tc);
					tn.MSkill := MSkill;
					tn.MUseLV := MUseLV;
					ts1 := TMob.Create;
					//SetSkillUnit(tm, ID, xy, Tick, 1118, MUseLV, tl.Data1[MUseLV], tc);
					with ts1 do begin
						Point.X := tc.MPoint.X;
						Point.Y := tc.MPoint.Y;
						ts1.ID := 1118;
						Name := 'Flora';
						ts1.JID := 1118;
						Data := MobDB.IndexOfObject(ts1.JID) as TMobDB;

						ZeroMemory(@buf[0], 41);
						WFIFOW( 0, $007c);
						WFIFOL( 2, ID);
						WFIFOW( 6, 1000);
						WFIFOW( 8, Stat1);
						WFIFOW(10, Stat2);
						WFIFOW(20, JID);
						WFIFOM1(36, Point, Dir);
						SendBCmd(tm,Point,41,nil,true);
					end;
				end else begin
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;

		285:    {Volcano}
			begin
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				for j1 := 1 to (Skill[288].Data.Data2[MUseLV] - 2) do begin
					for i1 := 1 to (Skill[288].Data.Data2[MUseLV] - 2) do begin
						xy.X := (tc.MPoint.X) - 5 + i1;
						xy.Y := (tc.MPoint.Y) - 5 + j1;

						tn := SetSkillUnit(tm, ID, xy, Tick, $9a, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);

                        tn.CharacterReceivedList.Add(tc.ID);
						tn.MSkill := MSkill;
						tn.MUseLV := MUseLV;
					end;
				end;
			end;
		369:    //gospel
			begin
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				for j1 := 1 to 9 do begin
					for i1 := 1 to 9 do begin
						xy.X := (tc.MPoint.X) - 5 + i1;
						xy.Y := (tc.MPoint.Y) - 5 + j1;

						tn := SetSkillUnit(tm, ID, xy, Tick, $b3, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);

						tn.MSkill := MSkill;
						tn.MUseLV := MUseLV;
					end;
				end;
			end;
		362:    // Basilica
			begin
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				{for j1 := 1 to 9 do begin
					for i1 := 1 to 9 do begin
						xy.X := (tc.MPoint.X) - 5 + i1;
						xy.Y := (tc.MPoint.Y) - 5 + j1;}

				tn := SetSkillUnit(tm, ID, xy, Tick, $b4, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);

				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;
				{	end;
				end;}
			end;

		286:    {Deluge}
			begin
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				for j1 := 1 to (tc.Skill[288].Data.Data2[MUseLV] - 2) do begin
					for i1 := 1 to (tc.Skill[288].Data.Data2[MUseLV] - 2) do begin
						xy.X := (tc.MPoint.X) - 5 + i1;
						xy.Y := (tc.MPoint.Y) - 5 + j1;

						tn := SetSkillUnit(tm, ID, xy, Tick, $9b, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);

                        tn.CharacterReceivedList.Add(tc.ID);
						tn.MSkill := MSkill;
						tn.MUseLV := MUseLV;
					end;
				end;
			end;

		287:    {Violent Gale}
			begin
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				for j1 := 1 to (Skill[288].Data.Data2[MUseLV] - 2) do begin
					for i1 := 1 to (Skill[288].Data.Data2[MUseLV] - 2) do begin
						xy.X := (tc.MPoint.X) - 5 + i1;
						xy.Y := (tc.MPoint.Y) - 5 + j1;

						tn := SetSkillUnit(tm, ID, xy, Tick, $9c, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);

                        tn.CharacterReceivedList.Add(tc.ID);
						tn.MSkill := MSkill;
						tn.MUseLV := MUseLV;
					end;
				end;
			end;

		288:    //Land protector
			begin
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				for j1 := 1 to (Skill[288].Data.Data2[MUseLV] - 2) do begin
					for i1 := 1 to (Skill[288].Data.Data2[MUseLV] - 2) do begin
						xy.X := (tc.MPoint.X) - 5 + i1;
						xy.Y := (tc.MPoint.Y) - 5 + j1;

						tn := SetSkillUnit(tm, ID, xy, Tick, $9d, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);

                        tn.CharacterReceivedList.Add(tc.ID);
						tn.MSkill := MSkill;
						tn.MUseLV := MUseLV;
					end;
				end;
			end;
		306,307,308,309,310,311,312,313,315,316,317,319,320,321,322,325,
		327,328,329,330:
			begin
				xy.X := tc.Point.X;
				xy.Y := tc.Point.Y;
				tc.LastSong := MSkill;
				tc.LastSongLV := MUseLV;
				j1 := 1;
				i1 := 1;
				for j1 := 1 to 9 do begin
					for i1 := 1 to 9 do begin
						//if ((i1 = 2) or (i1 = 4) or  (i1 = 6) or (i1 = 8)) or ((j1 = 2) or (j1 = 4) or  (j1 = 6) or (j1 = 8)) then begin
						if ((i1 = 2) or (i1 = 4) or  (i1 = 6) or (i1 = 8)) and ((j1 = 2) or (j1 = 4) or  (j1 = 6) or (j1 = 8)) then begin
							//if (j1 = 2 or 4 or 6 or 8) or (i1 = 2 or 4 or 6 or 8) then continue;
							//if (i1 = 2 or 4 or 6 or 8) then xy.X := (tc.Point.X) - 5 + i1;
							//if (j1 = 2 or 4 or 6 or 8) then xy.Y := (tc.Point.Y) - 5 + j1;
							xy.X := (tc.Point.X) - 5 + i1;
							xy.Y := (tc.Point.Y) - 5 + j1;
							case MSkill of
							306:	{Lullaby}
								tn := SetSkillUnit(tm, ID, xy, Tick, $9e, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							307:    {Richman Kim}
								tn := SetSkillUnit(tm, ID, xy, Tick, $9f, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							308:    {Eternal Chaos}
								tn := SetSkillUnit(tm, ID, xy, Tick, $a0, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							309:    {Drum Battle Field}
								tn := SetSkillUnit(tm, ID, xy, Tick, $a1, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							310:    {Ring of Neblium}
								tn := SetSkillUnit(tm, ID, xy, Tick, $a2, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							311:    {Rock is Well}
								tn := SetSkillUnit(tm, ID, xy, Tick, $a3, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							312:    {Into Abyss}
								tn := SetSkillUnit(tm, ID, xy, Tick, $a4, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							313:    {Siegfried}
								tn := SetSkillUnit(tm, ID, xy, Tick, $a5, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);

							317:    {Dissonance}
								tn := SetSkillUnit(tm, ID, xy, Tick, $a6, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);

							319:    {Whistle}
								tn := SetSkillUnit(tm, ID, xy, Tick, $a7, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							320:    {Assassain Cross}
								tn := SetSkillUnit(tm, ID, xy, Tick, $a8, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							321:    {Poem of Bragi}
								tn := SetSkillUnit(tm, ID, xy, Tick, $a9, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							322:    {Apple of Idun}
								tn := SetSkillUnit(tm, ID, xy, Tick, $aa, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							325:    {Ugly Dance}
								tn := SetSkillUnit(tm, ID, xy, Tick, $ab, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							327:    {Humming}
								tn := SetSkillUnit(tm, ID, xy, Tick, $ac, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							328:    {Don't Forget Me}
								tn := SetSkillUnit(tm, ID, xy, Tick, $ad, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							329:    {Fortune Kiss}
								tn := SetSkillUnit(tm, ID, xy, Tick, $ae, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							330:    {Service for You}
								tn := SetSkillUnit(tm, ID, xy, Tick, $af, 10, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
							end;//case
							//tn.CType := 4;
							//tn.CData := tc;
							tn.MSkill := MSkill;
							tn.MUseLV := MUseLV;
                            tn.CharacterReceivedList.Add(tc.ID);
							tc.SongTick := Tick + Cardinal(tc.Skill[MSkill].Data.Data1[MUseLV] * 1000);
							//i1 := i1 + 2;
							//1 := j1 + 2;

						 end;
					end;
				end;
				WFIFOW( 0, $011a);
				WFIFOW( 2, MSkill);
				WFIFOW( 4, dmg[0]);
				WFIFOL( 6, tc.ID);
				WFIFOL(10, ID);
				WFIFOB(14, 1);
				SendBCmd(tm, tc.Point, 15);

			end;

		314:    {Ragnarok}
			begin
				xy.X := tc.Point.X;
				xy.Y := tc.Point.Y;
				tc.LastSong := MSkill;
				tc.LastSongLV := MUseLV;
				tn := SetSkillUnit(tm, ID, xy, Tick, $49, 0, tc.Skill[MSkill].Data.Data1[MUseLV] * 1000, tc);
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;
				tc.SongTick := Tick + Cardinal(tc.Skill[MSkill].Data.Data1[MUseLV] * 1000);
			end;
		else
			begin
				tc.MMode  := 4;
				tc.MPoint.X := 0;
				tc.MPoint.Y := 0;
				sl.Free;
				Exit;//safe 204/04/26
			end;

		end;//case

		WFIFOW( 0, $0117);
		WFIFOW( 2, MSkill);
		WFIFOL( 4, ID);
		WFIFOW( 8, MUseLV);
		WFIFOW(10, MPoint.X);
		WFIFOW(12, MPoint.Y);
		WFIFOL(14, 1);
		SendBCmd(tm, xy, 18);
	end;//with
	sl.Free;
	tc.MPoint.X := 0;
	tc.MPoint.Y := 0;
end;//proc TfrmMain.CreateField()



{í«â¡Ç±Ç±Ç‹Ç≈}
//------------------------------------------------------------------------------
//âÒïúÉXÉLÉãìô
procedure TfrmMain.CharaPassive(tc:TChara;Tick:cardinal);
var
	j          : Integer;
	bonusregen : Integer;
//  tc1:TChara;
//	xy:TPoint;
//	sl:TStringList;
//	tl:TSkillDB;
////	i1,j1,k1:integer;
//	tm:TMap;
begin

    	{ Alex: For passsive skills also. We want to
        place all skill effects into one area. }
        parse_skills(tc, Tick, 1, True);

	with tc do begin
		//HPSPâÒïúèàóù
		if Weight * 2 < MaxWeight then begin

			if (HPTick + HPDelay[3 - Sit] <= Tick) and (tc.isPoisoned = false) and  (tc.Option and 6 = 0) then begin
				if HP <> MAXHP then begin
					bonusregen := (MAXHP div 200) + (Param[1] div 5) ;
					if bonusregen = 0 then begin
						Inc(HP);
					end else begin
						HP := HP + bonusregen;
					end;
					HPTick := HPTick + HPDelay[3 - Sit];

					if HP > MAXHP then HP := MAXHP;
					SendCStat1(tc, 0, 5, HP);
				end else begin
					HPTick := Tick;
				end;
			end;

			if (SPTick + SPDelay[3 - Sit] <= Tick) and (Skill[271].Tick < Tick) and (Skill[270].Tick < Tick) and (tc.Option and 6 = 0) then begin
				if SP <> MAXSP then begin

					bonusregen := 1+(MAXSP div 100) + (Param[3] div 6) ;
					if Param[3] >= 120 then begin
						bonusregen := bonusregen + (((Param[3]-120) div 2)+ 4) ;
					end;
					SP := SP + bonusregen ;

					SPTick := SPTick + SPDelay[3 - Sit];

					if SP > MAXSP then SP := MAXSP;
						SendCStat1(tc, 0, 7, SP);
				end else begin
					SPTick := Tick;
				end;
			end;
			if Weight * 2 <> MaxWeight then begin

				if Weight * 2 < MaxWeight then begin

			//HPé©ìÆâÒïú

					{SP Usage For Songs}
					if LastSong <> 0 then begin
						if tc.Skill[LastSong].Data.Element <> 0 then begin
							if (tc.SongTick > Tick) and (tc.SPSongTick + tc.Skill[LastSong].Data.Element * 1000 < Tick) then begin
								if tc.SP > 1 then tc.SP := tc.SP - 1;
								SPSongTick := Tick;
							end;
						end;
					end;


				{ Ç–ÇÂÇ¡Ç∆ÇµÇΩÇÁÇ±ÇÃèàóùÇ¢ÇÈÇ©Ç‡
				end else begin
					HPTick := Tick;
					SPTick := Tick;
				}
				end;
			end else begin
				HPTick := Tick;
				if Skill[270].Tick < Tick then begin
					SPTick := Tick;
				end;

			end;
		end;
	end;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.SkillPassive(tc:TChara;Tick:cardinal);
var
	j  : Integer;
//  tc1:TChara;
	xy : TPoint;
//  sl:TStringList;
//  tl:TSkillDB;
	i1 : Integer;
	j1 : Integer;
//	k1 : Integer;
	k  : Integer;
	tm : TMap;
    ts : TMob;
begin
	with tc do begin
		//if Weight * 2 <> MaxWeight then begin
		// Colus, 20040430: Combo Finish check to reset Ashura's combo mode after the delay period passes.
		if (tc.Skill[273].Lv > 0) and (tc.Skill[273].Tick <= Tick) and (tc.Skill[273].EffectLV = 1) then begin

			tc.Skill[273].EffectLV := 0;
			tc.Skill[271].Data.SType := 1;
			tc.Skill[271].Data.CastTime1 := 4500;
			SendCSkillList(tc);
		end;

		// Recalls the Water Ball effect to do multiple hits over time.
		if (tc.Skill[86].Lv > 0) and (tc.Skill[86].Tick <= Tick) and (tc.Skill[86].EffectLV > 0) then begin
			DamageOverTime(tc.MData, tc, Tick, 86, tc.Skill[86].Effect1, tc.Skill[86].EffectLV);
		end;
		{Sanctuary}
		// Colus, 20031229: Changed heal period 5000->1000, added check to stop healing when full
		//        20030127: No more heals while dead
		if ((tc.Skill[70].Tick > Tick) and (tc.HPRTick + 1000 <= Tick) and (tc.InField = true) and (tc.HP <> tc.MAXHP) and (tc.Sit <> 1)) then begin
			 if (tc.ArmorElement mod 20 <> 9) then begin
					j := Skill[70].Effect1;

					tc.HP := tc.HP + j;
					if tc.HP > tc.MAXHP then tc.HP := tc.MAXHP;

					// Colus, 20040117: Nobody else sees the heal, use 011a:
					WFIFOW( 0, $011a);
					WFIFOW( 2, 28);  // Cheat with heal
					WFIFOW( 4, j);
					WFIFOL( 6, ID);
					WFIFOL(10, 0); // Not sure what to do about this (NPC's ID?)
					WFIFOB(14, 1);
					SendBCmd(tc.MData, tc.Point, 15);
					{WFIFOW( 0, $013d);
					WFIFOW( 2, $0005);
					WFIFOW( 4, j);
					//Socket.SendBuf(buf, 6);
					SendBCmd(tc.MData, tc.Point, 6);}

					SendCStat1(tc, 0, 5, HP);
					HPRTick := Tick;
					tc.InField := false;
				end else begin
					tm := tc.MData;
					j := Skill[70].Effect1;
					SendCSkillAtk2(tm, tc, tc, Tick, j, 1);
					DamageProcess2(tm, tc, tc, j, Tick);
					HPRTick := Tick;
					tc.InField := false;
				end;
			end;
			if ((tc.Skill[369].Tick > Tick) and (tc.HPRTick + 2000 <= Tick) and (tc.InField = true) and (tc.HP <> tc.MAXHP) and (tc.Sit <> 1)) then begin

				j := Random(1000);

				tc.HP := tc.HP + j;
				if tc.HP > tc.MAXHP then tc.HP := tc.MAXHP;

				// Colus, 20040117: Nobody else sees the heal, use 011a:
				WFIFOW( 0, $011a);
				WFIFOW( 2, 28);  // Cheat with heal
				WFIFOW( 4, j);
				WFIFOL( 6, ID);
				WFIFOL(10, 0); // Not sure what to do about this (NPC's ID?)
				WFIFOB(14, 1);
				SendBCmd(tc.MData, tc.Point, 15);
				{WFIFOW( 0, $013d);
				WFIFOW( 2, $0005);
				WFIFOW( 4, j);
				//Socket.SendBuf(buf, 6);
				SendBCmd(tc.MData, tc.Point, 6);}

                        SendCStat1(tc, 0, 5, HP);
                        HPRTick := Tick;
                        tc.InField := false;
                end;

                {Apple of Idun}
                if (tc.Skill[322].Tick > Tick) and (tc.HPRTick + 6000 <= Tick) and (tc.InField = true) then begin

                        j := Skill[322].Effect1;

                        tc.HP := tc.HP + j;
                        if tc.HP > tc.MAXHP then tc.HP := tc.MAXHP;

                        // Colus, 20040117: Nobody else sees the heal, use 011a:
  							        WFIFOW( 0, $011a);
  							        WFIFOW( 2, 28);  // Cheat with heal
  							        WFIFOW( 4, j);
  							        WFIFOL( 6, ID);
  							        WFIFOL(10, 0); // Not sure what to do about this (NPC's ID?)
  							        WFIFOB(14, 1);
  							        SendBCmd(tc.MData, tc.Point, 15);
                        {WFIFOW( 0, $013d);
                        WFIFOW( 2, $0005);
                        WFIFOW( 4, j);
                        //Socket.SendBuf(buf, 6);
                        SendBCmd(tc.MData, tc.Point, 6);}

                        SendCStat1(tc, 0, 5, HP);
                        HPRTick := Tick;
                        tc.InField := false;
                end;

                if tc.intimidateActive then begin
                        if tc.intimidateTick < Tick then begin
                                tc.intimidateActive := false;
                                IntimidateWarp(tm, tc);
                        end;
                end;

                if tc.isCloaked then begin  {Cloaking}
                        tm := tc.MData;

                        xy.X := tc.Point.X;
                        xy.Y := tc.Point.Y;

                        k := 0;

                        for j1 := - 1 to 1 do begin
                          for i1 := -1 to 1 do begin
                            if ((j1 = 0) and (i1 = 0)) then continue;
                            j := tm.gat[xy.X + i1, xy.Y + j1];
                                if (j = 1) or (j = 5) then begin
                                  // Colus, 20040205: Moved this to the actual skill.
                                  // Too many updates.

                                        k := 1;
                                end;
                          end;
                        end;

                        if k <> 1 then begin
                                tc.Skill[135].Tick := Tick;
                                tc.SkillTick := Tick;
                                tc.SkillTickID := 135;
                                tc.Option := tc.Option and $FFF9;
                                //SkillTick := tc.Skill[MSkill].Tick;
                                //SkillTickID := MSkill;
                                tc.Hidden := false;
                                tc.isCloaked := false;
                                CalcStat(tc, Tick);
                                UpdateOption(tm, tc);
                        end;
                end;

                if (tc.Option and 4 <> 0) then begin
                  if (tc.Skill[135].Lv > 0) and ((tc.CloakTick + Cardinal(tc.Skill[135].Data.Data1[Skill[135].Lv] * 1000)) < Tick) then begin
                        if tc.SP >= 1 then begin
                          tc.SP := tc.SP - 1;
                          CloakTick := Tick;
                          SendCStat1(tc, 0, 7, SP);
                          //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Hit cloaktick');
                        end else begin
                          // Colus, 20040205: Added uncloak when you run out of SP.
                          // Colus, 20040307: Fixed crash bug (map set properly), remove icon, 0 SP.
                          tm := tc.MData;
                          tc.SP := 0;
                          SendCStat1(tc, 0, 7, SP);
                                tc.Skill[135].Tick := Tick;
                                tc.Option := tc.Option and $FFF9;
                                SkillTick := tc.Skill[MSkill].Tick;
                                SkillTickID := 135;
                                tc.Hidden := false;
                                tc.isCloaked := false;
                                CalcStat(tc, Tick);
                          UpdateOption(tm, tc);
                          //UpdateIcon(tm, tc, 5, 0);
                          {WFIFOW(0, $0119);
                                WFIFOL(2, tc.ID);
                                WFIFOW(6, tc.Stat1);
                                WFIFOW(8, tc.Stat2);
                                WFIFOW(10, tc.Option);
                                WFIFOB(12, 0);
                          SendBCmd(tm, tc.Point, 13);}
                        end;
                  end;
                end;

               // Colus, 20040224: Yeah, Hide drains SP also, but at a different rate.
               if (tc.Option and 2 <> 0) then begin
                  if (tc.Skill[51].Lv > 0) and ((tc.CloakTick + (4000 + (tc.Skill[51].Lv * 1000))) < Tick) then begin
                        if tc.SP >= 1 then begin
                          tc.SP := tc.SP - 1;
                          CloakTick := Tick;
                          SendCStat1(tc, 0, 7, SP);
                          //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Hit cloaktick');
                        end else begin
                          tm := tc.MData;
                          // Colus, 20040205: Added unhide when you run out of SP.
                          // Colus, 20040307: Fixed crash bug (map set properly), remove icon, 0 SP.
                          tm := tc.MData;
                          tc.SP := 0;
                          SendCStat1(tc, 0, 7, SP);
                                tc.Skill[51].Tick := Tick;
                                tc.Option := tc.Option and $FFF9;
                                SkillTick := tc.Skill[51].Tick;
                                SkillTickID := 51;
                                tc.Hidden := false;
                                tc.isCloaked := false;
                                CalcStat(tc, Tick);
                          UpdateOption(tm, tc);
                          //UpdateIcon(tm, tc, 4, 0);
                          {WFIFOW(0, $0119);
                                WFIFOL(2, tc.ID);
                                WFIFOW(6, tc.Stat1);
                                WFIFOW(8, tc.Stat2);
                                WFIFOW(10, tc.Option);
                                WFIFOB(12, 0);
                          SendBCmd(tm, tc.Point, 13);}
                        end;
                  end;
                end;

                if (tc.Skill[114].Lv > 0) and (tc.Skill[114].EffectLV = 1) and (tc.Skill[114].Tick < Tick) then begin
                        if tc.SP >= 1 then begin
                          tc.SP := tc.SP - 1;
                          tc.Skill[114].Tick := Tick + Cardinal(tc.Skill[114].Data.Data1[tc.Skill[114].Lv]);
                          SendCStat1(tc, 0, 7, SP);
                          //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Hit maximize tick');
                        end else begin
                          // Colus, 20040307: Fixed crash bug (map set properly), remove icon, 0 SP.
                          tm := tc.MData;
                          tc.SP := 0;
                          SendCStat1(tc, 0, 7, SP);
                          tc.Skill[114].Tick := Tick;
                          tc.Skill[114].EffectLV := 0;
                          SkillTick := tc.Skill[114].Tick;
                          SkillTickID := 114; //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('STID %d', [SkillTickID]));
                        end;
                end;
                if (tc.isPoisoned = true) then begin
                        if tc.PoisonTick < Tick then begin
                                tc.isPoisoned := False;
                                tc.PoisonTick := Tick;
                                tc.Stat2 := 0;
                                UpdateStatus(tm, tc, Tick);
                        end;
                end;

                {Stone Curse Removal}
                if tc.isStoned = true then begin
                        if tc.StoneTick < Tick then begin
                                tc.Stat1 := 0;
                                tc.isStoned := false;
                                tc.StoneTick := Tick;
                                UpdateStatus(tm, tc, Tick);
                        end;
                end;

                {Blind Removal}
                if tc.isBlind = true then begin
                        if tc.BlindTick < Tick then begin
                                tc.Stat2 := 0;
                                tc.isBlind := false;
                                tc.BlindTick := Tick;
                                UpdateStatus(tm, tc, Tick);
                        end;
                end;

                {Freeze Removal}
                if tc.isFrozen = true then begin
                        if tc.FreezeTick < Tick then begin
                                tc.Stat1 := 0;
                                tc.isFrozen := false;
                                tc.FreezeTick := Tick;
                                UpdateStatus(tm, tc, Tick);
                        end;
                end;

                {Silenced Removal}
                if tc.isSilenced = true then begin
                        if tc.SilencedTick < Tick then begin
                          tc.Stat2 := 0;
                          tc.isSilenced := false;
                          tc.SilencedTick := Tick;
                          SilenceCharacter(tm, tc, Tick);
                        end;
                end;



      {Colus, 20031223: Added check for Ashura recovery period.}
			{

            Alex: Neither Asura nor Fury affect HP Recovery.

            if (HPTick + HPDelay[3 - Sit] <= Tick) and (Skill[271].Tick > Tick) and (Option and 6 = 0) then begin
				if (HP <> MAXHP) then begin
					for j := 1 to (Tick - HPTick) div HPDelay[3 - Sit] do begin
                                                if tc.isPoisoned = True then Dec(HP)
                                                else Inc(HP);
						HPTick := HPTick + HPDelay[3 - Sit];
					end;
					if HP > MAXHP then HP := MAXHP;
                                        if tc.HP < 0 then tc.HP := 0;
					SendCStat1(tc, 0, 5, HP);
                                end else if (tc.isPoisoned = True) then begin
                                        for j := 1 to (Tick - HPTick) div HPDelay[3 - Sit] do begin
						Dec(HP);
						HPTick := HPTick + HPDelay[3 - Sit];
					end;
					if HP < 1 then HP := 1;
					SendCStat1(tc, 0, 5, HP);
				end else begin
					HPTick := Tick;
				end;
			end;}
			//SPé©ìÆâÒïú
      {Colus, 20031223: Added check for Ashura recovery period.}
			{if (SPTick + SPDelay[3 - Sit] <= Tick) and (Skill[270].Tick > Tick) and (Skill[271].Tick < Tick) and (Option and 6 = 0) then begin
				if SP <> MAXSP then begin
					for j := 1 to (Tick - SPTick) div SPDelay[3 - Sit] do begin
						Inc(SP);
						SPTick := SPTick + SPDelay[3 - Sit];
					end;
					if SP > MAXSP then SP := MAXSP;
						SendCStat1(tc, 0, 7, SP);
					end else begin
						SPTick := Tick;
				end;
			end;}

		if (Sit >= 2) then begin

        	if Weight * 2 < MaxWeight then begin

	        	{ Alex: iro.ragnarokonline.com: "the caster cannot restore SP automatically"; No mention of HP }
				if (Sit = 2) and (Skill[260].Lv <> 0) and (HPRTick + 10000 <= Tick) and (Option and 6 = 0) then begin
					if HP <> MAXHP then begin
						j := (5 + MAXHP div 500) * Skill[260].Data.Data1[Skill[260].Lv];
						if HP + j > MAXHP then j := MAXHP - HP;
						HP := HP + j;
						WFIFOW( 0, $013d);
						WFIFOW( 2, $0005);
						WFIFOW( 4, j);
						Socket.SendBuf(buf, 6);
						SendCStat1(tc, 0, 5, HP);
					end;
					HPRTick := Tick;
				end;

		        if (Sit = 2) and (Skill[260].Lv <> 0) and (SPRTick + 10000 <= Tick) and (Skill[271].Tick < Tick) and (Skill[270].Tick < Tick) and (tc.Option and 6 = 0) then begin
    		    	if (SP <> MAXSP) then begin
        		    	j := (3 + MAXSP * 2 div 1000) * Skill[260].Data.Data2[Skill[260].Lv];
            		    if SP + j > MAXSP then j := MAXSP - SP;
                		SP := SP + j;
                		WFIFOW( 0, $013d);
	                    WFIFOW( 2, $0007);
    	                WFIFOW( 4, j);
        	            Socket.SendBuf(buf, 6);
            	        SendCStat1(tc, 0, 7, SP);
                	end;
	                SPRTick := Tick;
    	        end;
                
            end;
        end;

	end;
	//end;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.PetPassive(tc:TChara; _Tick:cardinal);
var
	j : Integer;
	k : Integer;
//	m : Integer;
//	n : Integer;
//	spd:cardinal;
//	xy:TPoint;
//	dx,dy:integer;
	tm:TMap;
	tn1:TNPC;
	tn:TNPC;
	tpe:TPet;
	//tc1:TChara;
	i1 : Integer;
	j1 : Integer;
	k1 : Integer;
	MobData:TMobDB;
	sl:TStringList;
	//Tick:cardinal;
	//ts:TMob;
begin
	sl := TStringList.Create;
	tm := tc.MData;
	tn1 := tc.PetNPC;
	tpe := tc.PetData;
	MobData := tpe.MobData;

	if tpe.Accessory <> 0 then begin
		with tn1 do begin

            if not assigned(tpe.Data) then Exit;

			if tpe.Data.SkillTime > 0 then begin
				//Tick System needs to be redone
				{if tpe.SkillTick < _Tick - 60000 + (tpe.Data.SkillTime * 1000) then begin
					tpe.SkillTick := _Tick + (tpe.Data.SkillTime * 1000);
					CalcStat(tc);
					CalcSkill(tc, _Tick);
					SendCStat(tc);
				end else if tpe.SkillTick > _Tick then begin
					tpe.SkillActivate := true;
					tpe.SkillTick := _Tick;
				end;  }
				if tpe.SkillTick < _Tick then begin
					tpe.SkillTick := _Tick + 60000;
					CalcStat(tc);
					CalcSkill(tc, _Tick);
					SendCStat(tc);
				end;

				if (tpe.SkillTick >= _Tick + (60000 - (tpe.Data.SkillTime * 1000))) and (tpe.SkillActivate = false) then begin
					tpe.SkillActivate := true;
					PetSkills(tc, _Tick);
				end else if (tpe.SkillTick <= _Tick + (60000 - (tpe.Data.SkillTime * 1000))) and (tpe.SkillActivate = true) then begin
					tpe.SkillActivate := false;
					CalcStat(tc);
					CalcSkill(tc, _Tick);
					SendCStat(tc);
				end;

			end;

			//Smokie's Perfect Hide: Cannot be detected by insects or demons.
			if tpe.JID = 1056 then tc.PerfectHide := true;

			//Sohee's Heal: When HP is lower than 1/3rd, she heals 400HP/Min until HP is higher than 1/3rd
			// Colus, 20040317: Stop Sohee heals when you are dead :)
			if (tpe.JID = 1170) and (tc.HP < (tc.MAXHP / 3)) and (tc.Sit <> 1) then begin
				if tpe.SkillTick < _Tick then begin
					tpe.SkillTick := _Tick + 60000;
					tc.HP := tc.HP + 400;

					//Show Heal
					WFIFOW( 0, $011a);
					WFIFOW( 2, 28);  // We cheat and use the heal skill for the gfx
					WFIFOW( 4, 400);
					WFIFOL( 6, tc.ID);
					WFIFOL(10, tn1.ID);
					WFIFOB(14, 1);
					SendBCmd(tm, tc.Point, 15);

					//Send Players HP
					SendCStat1(tc, 0, 5, tc.HP);
				end;
			end;

			// Spores Heal Poison
			if (tpe.JID = 1014) and (tc.isPoisoned = true) then begin
				if tpe.SkillTick < _Tick then begin
					tpe.SkillTick := _Tick + 60000;

					tc.isPoisoned := False;
					tc.PoisonTick := Tick;
					tc.Stat1 := 0;

					//Show Heal
					WFIFOW( 0, $011a);
					WFIFOW( 2, 35);  // We cheat and use the heal skill for the gfx
					WFIFOW( 4, 1);
					WFIFOL( 6, tc.ID);
					WFIFOL(10, tn1.ID);
					WFIFOB(14, 1);
					SendBCmd(tm, tc.Point, 15);

					UpdateStatus(tm, tc, Tick);
				end;
			end;

			// Isis Magnificat: When HP/SP both are lower than 50%, she will use Level
			// 2 Magnificat once per minute, until HP/SP are higher than 50%
			if (tpe.JID = 1029) and (tc.HP < tc.MAXHP / 2) and (tc.SP < tc.MAXSP / 2) then begin
				if tpe.SkillTick < _Tick then begin
					tpe.SkillTick := _Tick + 60000;
					//Add Magnificat
					WFIFOW( 0, $011a);
					WFIFOW( 2, 74);
					WFIFOW( 4, 0);
					WFIFOL( 6, tc.ID);
					WFIFOL(10, tn1.ID);
					WFIFOB(14, 1);
					SendBCmd(tm, tc.Point, 15);

					tc.Skill[74].Tick := _Tick + cardinal(tc.Skill[74].Data.Data1[2]) * 1000;
					tc.Skill[tc.MSkill].EffectLV := 2;
					tc.Skill[tc.MSkill].Effect1 := tc.Skill[74].Data.Data2[2];
					if tc.SkillTick > tc.Skill[74].Tick then begin
						tc.SkillTick := tc.Skill[74].Tick;
						tc.SkillTickID := 74;
					end;

					CalcStat(tc, _Tick);
					SendCStat(tc);

					//Send Icon
					UpdateIcon(tm, tc, 20, 1);
				end;
			end;


			if MobData.isLoot then begin

				if (not tpe.isLooting) then begin
					//Clear the Stringlist
					sl.Clear;

					//Find items in Range
					for j1 := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
						for i1 := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
							for k1 := 0 to tm.Block[i1][j1].NPC.Count - 1 do begin
								tn := tm.Block[i1][j1].NPC.Objects[k1] as TNPC;
								if tn.CType <> 3 then Continue;
								if (abs(tn.Point.X - Point.X) <= 9) and (abs(tn.Point.Y - Point.Y) <= 9) then begin
									//Add to the string list
									sl.AddObject(IntToStr(tn.ID), tn);
								end;
							end;
						end;
					end;
					if sl.Count <> 0 then begin
						j := Random(sl.Count);
						tn := sl.Objects[j] as TNPC;
//1
						{ Alex: Still Unknown - Pet Looting? - 1 for now }
						k := Path_Finding(path, tm, Point.X, Point.Y, tn.Point.X, tn.Point.Y, 1);
						if (k <> 0) then begin
							tpe.isLooting := True;
							tpe.ATarget := tn.ID;
							//ATick := Tick;

							pcnt := k;
							ppos := 0;
							MoveTick := Tick;

							NextPoint := tn.Point;
							PetMoving(tc, Tick);
							SendPetMove(tc.Socket, tc, NextPoint);
							SendBCmd( tm, tn.Point, 58, tc, True );
						end;
						sl.Free;
						Exit;//safe 2004/04/26
					end;
				end;
				//end;
			//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Poring is your pet.');
			end;
		end;
	end;
	sl.Free;//safe 2004/04/26
end;


//------------------------------------------------------------------------------
function TfrmMain.MapPassive(tm:TMap; Tick:Cardinal) : boolean;
var
    i,j   :   cardinal;
    tn    :   TNPC;
    itemCount : integer; //The Number of items on the map

begin
    Result := false;  //We are going to assume it fails
    if NOT tm.NeedToUnload then begin

        //if tm.LastAction < tm.UnloadTime then tm.LastAction := tm.UnloadTime + 1000;

        //try
        //    j := Tick - tm.LastAction;
        //except
        //    j := tm.UnloadTime + 50000;
        //end;

        if tm.CList.Count > 0 then exit; //Map has characters on the map
        itemCount := 0;
        for i := 0 to tm.NPC.Count - 1 do begin
            tn := tm.NPC.Objects[i] as TNPC;
            if tn.CType = 3 then Inc(itemCount);
        end;
        if itemCount > 0 then exit; //Map has items currently on it

        //It passed all of our tests, lets check it's tick
        Result := true;

        if Tick > tm.lastAction then j := Tick - tm.LastAction
        else j := 0;

        if j < tm.UnloadTime then exit;  //Map has had actions and will not be unloaded

        //DebugOut.Lines.Add('[' + TimeToStr(Now) + '] ' + 'Map ' + tm.Name + ' Has ' + IntToStr(tm.NPC.Count) + ' NPCs');
        //DebugOut.Lines.Add('[' + TimeToStr(Now) + '] ' + IntToStr(itemCount) + ' items are on the map of those NPCs');
        //DebugOut.Lines.Add('[' + TimeToStr(Now) + '] ' + 'Map ' + tm.Name + ' Has been idle for ' + IntToStr(j) + ' ms and needs to be unloaded');

        tm.NeedToUnload := true;

    end;

end;

{Darkhelmet - July 28, 2004.
   Sigh, in all of fusions time not one developer has tackled this function.  I made some crappy
   additions to it, but it contains some vital bandwidth problems of over updating so
   I am hoping to conqure them now.
}
function TfrmMain.NPCAction(tm:TMap;tn:TNPC;Tick:cardinal;tc:TChara) : Integer;
var
	k,m,c,c1: Integer;
	i,j:Integer;
	i1,j1,k1:integer;
	i2,j2,k2:integer;
    p1,p2:integer;
	tc1:TChara;
    tMonster:TMob;
	ts1:TMob;
    tc2:TChara;
	tl	:TSkillDB;
	xy:TPoint;
    b:integer;
	bb:array of byte;
	sl:TStringList;
    sl2:TStringList;
	flag:Boolean;
    mi :MapTbl;
begin
    // Get the Maps Info
    mi := MapInfo.Objects[MapInfo.IndexOf(tm.Name)] as MapTbl;

	k := 0;

    // If the NPC is an item
	if (tn.CType = 3) and (tn.Tick <= Tick) then begin
        if tn.JID  = $F1 then begin  //If its biocannabliaze begin
            WFIFOW(0, $00a1);
            WFIFOL(2, 1118);
            SendBCmd(tm, tn.Point, 6);
            {Delte the plant}
            with tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC do
                Delete(IndexOf(1118));

            tn.Free;  //Free the NPC
        end;
		//This is a normal NPC
		WFIFOW(0, $00a1);
		WFIFOL(2, tn.ID);
		SendBCmd(tm, tn.Point, 6);
		//Remove from NPC index
		tm.NPC.Delete(tm.NPC.IndexOf(tn.ID));
		with tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC do
			Delete(IndexOf(tn.ID));
			tn.Free;
	end else if (tn.CType = 4) then begin //If its a skill
		if tn.Tick <= Tick then begin  //It's tick has expired
			case tn.JID of
                $8D: // Icewall ends
                    begin
                        DelSkillUnit(tm, tn, tc);
                        Dec(k);
     			    end;
				$81:// Warp Portal Opens
                    begin
						tn.JID := $80;
                        UpdateLook(tm, tn, 0, tn.JID, 0, true);
						tn.Tick := Tick + 20000;
					end;
				$8F:// Blast Mine activated
					begin
						tn.JID := $74;
                        UpdateLook(tm, tn, 0, tn.JID, 0, true);
						tn.Tick := Tick + 2000;
					end;
                $99: // Talkie Box Activated
                    begin
						tn.JID := $8c;
                        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Talkie changed');
                        UpdateLook(tm, tn, 0, tn.JID, 0, true);
						tn.Tick := Tick + 60000;
                    end;
        { $8c: // Talkie Box fires
          begin
            WFIFOW(0, $0191);
            WFIFOL(2, tn.ID);
            WFIFOS(6, tn.Name, 80);
            SendBCmd(tm, tn.Point, 86);
          end;}

            else  //Not a special case, so we are going to delete it as normal
                begin
                    //Remove the graphic
                    DelSkillUnit(tm, tn, tc);
                    Dec(k);
                end;
			end;
		end else begin
			//It is still active, so let's do it's effects
			c := 0;
			while (c >= 0) and (c < tm.Block[tn.Point.X div 8][tn.Point.Y div 8].CList.Count) do begin
				tc1 := tm.Block[tn.Point.X div 8][tn.Point.Y div 8].CList.Objects[c] as TChara;
				Inc(c);
				if tc1 = nil then continue;
				if (tc1.pcnt = 0) and (tc1.Point.X = tn.Point.X) and (tc1.Point.Y = tn.Point.Y) then begin
					case tn.JID of
						$80: //Chat room
							begin
                                                                {É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡}
								if (tc1.ChatRoomID <> 0) then continue;
                                                                {É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡ÉRÉRÇ‹Ç≈}
								SendCLeave(tc1, 0);
								tc1.tmpMap := tn.WarpMap;
								tc1.Point := tn.WarpPoint;
								MapMove(tc1.Socket, tn.WarpMap, tn.WarpPoint);
								Dec(tn.Count);
								if tn.Count = 0 then begin //Ç±Ç±ÇÃèàóùÇ™Ç§Ç‹Ç≠Ç¢Ç≠Ç©Ç«Ç§Ç©ì‰
									DelSkillUnit(tm, tn, tc);
									Dec(k);
									c := -1;
									continue;
								end else begin
									Dec(c);
								end;
							end;
                        $99: // Talkie Box fires
                            begin
                                //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Talkie fire self');
                                WFIFOW(0, $0191);
                                WFIFOL(2, tc1.ID);
                                WFIFOS(6, tn.Name, 80);
                                //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('Name %s', [tn.Name]));
                                SendBCmd(tm, tn.Point, 86);
                            end;
                        $8c: // Talkie Box fires
                            begin
                                WFIFOW(0, $0191);
                                //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('Name %s', [tn.Name]));
                                WFIFOL(2, tn.ID);
                                WFIFOS(6, tn.Name, 80);
                                SendBCmd(tm, tn.Point, 86);
                            end;
					end;
				end;
			end;

			tc1 := tn.CData;
            tMonster := tn.MData;

			tl := SkillDB.IndexOfObject(tn.MSkill) as TSkillDB;
			if tl <> nil then begin
				m := tl.Range2;
			end else begin
				m := 0;
			end;
			//Start Searching
		    flag := False;
            sl2 := TStringList.Create;

            {Find Characters in area}
            for p1 := (tn.Point.Y - m) div 8 to (tn.Point.Y + m) div 8 do begin
				for i1 := (tn.Point.X - m) div 8 to (tn.Point.X + m) div 8 do begin
					for c1 := 0 to tm.Block[i1][p1].Clist.Count -1 do begin
                        if (tm.Block[i1][p1].Clist.Objects[c1] is TChara) then begin
						    tc2 := tm.Block[i1][p1].CList.Objects[c1] as TChara;
						    if tc2 = nil then Continue;
						    if (abs(tc2.Point.X - tn.Point.X) <= m) and (abs(tc2.Point.Y - tn.Point.Y) <= m) then
							    sl2.AddObject(IntToStr(tc2.ID),tc2);
						    if (tc2.Point.X = tn.Point.X) and (tc2.Point.Y = tn.Point.Y) then
							    flag := True;
					    end;
				    end;
			    end;
			end;

            //Monster casting sysem I randomly placed... needs to be moved to monsterAI under a call
            if tMonster <> nil then begin
                if tMonster.isCasting then begin
                    if sl2.Count <> 0 then begin
                        for c1 := 0 to sl2.Count - 1 do begin
                            tc2 := sl2.Objects[c1] as TChara;
                            case tn.JID of
                                $88: //Meteor
							    begin
								    //if (tn.Tick + 1000 * tn.Count) < (Tick + 3000) then begin
									//dmg[0] := tc1.MATK1 + Random(tc1.MATK2 - tc1.MATK1 + 1) * tc1.MATKFix div 100 * tl.Data1[tn.MUseLV] div 100;
									//dmg[0] := dmg[0] * (100 - tc2.MDEF1 + tc2.MDEF2) div 100; //MDEF%
									//dmg[0] := dmg[0] - tc2.Param[3]; //MDEF-
                                    MobSkillDamageCalc(tm, tc2, tn.MData, Tick);

									if dmg[0] < 1 then dmg[0] := 1;

									dmg[0] := dmg[0] * tl.Data2[tn.MUseLV];
									if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï

                                                                        //Packet Process
									WFIFOW( 0, $01de);
									WFIFOW( 2, 83);
									WFIFOL( 4, tn.ID);
									WFIFOL( 8, tc2.ID);
									WFIFOL(12, Tick);
									WFIFOL(16, tMonster.Data.aMotion);
									WFIFOL(20, tc2.dMotion);
									WFIFOL(24, dmg[0]);
									WFIFOW(28, tn.MUseLV);
									WFIFOW(30, tl.Data2[tn.MUseLV]);
									WFIFOB(32, 8);
                                                                        SendBCmd(tm, tn.Point, 33);

                                                                        //SendMSkillAttack(tm, tc2, tn.MData, tn.MData.Data.AISkill, Tick, 1, 1);
									DamageProcess3(tm, tn.MData, tc2, dmg[0], Tick);

									if c1 = (sl2.Count -1) then begin
										Inc(tn.Count);	//CountÇî≠ìÆî≠êîÇ∆SkillLVÇ…égóp
										if tn.Count = 3 then tn.Tick := Tick
									end;

                                end;

                                $86:    {Lord of Vermillion Damage}
							    begin
								//if (tn.Tick + 1000 * tn.Count) < (Tick + 3000) then begin
                                    MobSkillDamageCalc(tm, tc2, tn.MData, Tick);
                                    dmg[0] := dmg[0] * tMonster.Data.Param[3];
                                    if dmg[0] > 15000 then dmg[0] := 15000;
									//dmg[0] := tc1.MATK1 + Random(tc1.MATK2 - tc1.MATK1 + 1) * tc1.MATKFix div 100 * tl.Data1[tn.MUseLV] div 100;
									dmg[0] := dmg[0] * (100 - tc2.MDEF1 + tc2.MDEF2) div 100; //MDEF%
									dmg[0] := dmg[0] - tc2.Param[3]; //Magic Defence
									if dmg[0] < 1 then dmg[0] := 1;
									dmg[0] := dmg[0] * tl.Data2[tn.MUseLV];
									if dmg[0] < 0 then dmg[0] := 0; //Negative Damage

									//Packet Process
									WFIFOW( 0, $01de);
									WFIFOW( 2, 83);
									WFIFOL( 4, tn.ID);
									WFIFOL( 8, tc2.ID);
									WFIFOL(12, Tick);
									WFIFOL(16, tMonster.Data.aMotion);
									WFIFOL(20, tc2.dMotion);
									WFIFOL(24, dmg[0]);
									WFIFOW(28, tn.MUseLV);
									WFIFOW(30, tl.Data2[tn.MUseLV]);
									WFIFOB(32, 8);
                                    SendBCmd(tm, tn.Point, 33);

									DamageProcess3(tm, tn.MData, tc2, dmg[0], Tick);

									if c1 = (sl2.Count -1) then begin
										Inc(tn.Count);	//CountÇî≠ìÆî≠êîÇ∆SkillLVÇ…égóp
										if tn.Count = 3 then tn.Tick := Tick
									end;
							    end;
                            end;  //End Case
                                        //tMonster.IsCasting := false;
                                        //Exit;
                        end;
                    end;
                end;
            end;  //End of monster Casting

            //Pvp Area effects begin
            if sl2.Count <> 0 then begin
                for c1 := 0 to sl2.Count - 1 do begin
                    tc2 := sl2.Objects[c1] as TChara;
                    if (tc2.NoTarget = false) and (tc2.HP > 0) then begin
                        case tn.JID of
                            $8d: {Ice Wall}
							begin
                                {Colus, 20030113: Put the bounce back in until pathing works right again.}
								SetLength(bb, 1);
								bb[0] := 4;     // 1->4
								//bb[1] := 0;
                                xy := tc2.Point;
                                //tc2.Dir := 8 - tc2.Dir;
								DirMove(tm, tc2.Point, tc2.Dir, bb);
								//ÉuÉçÉbÉNà⁄ìÆ
								if (xy.X div 8 <> tc2.Point.X div 8) or (xy.Y div 8 <> tc2.Point.Y div 8) then begin
									with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
										assert(IndexOf(tc2.ID) <> -1, 'Player Delete Error');
										Delete(IndexOf(tc2.ID));
									end;
									tm.Block[tc2.Point.X div 8][tc2.Point.Y div 8].Clist.AddObject(tc2.ID, tc2);
								end;
								tc2.pcnt := 0;
                                //Update Players Location
								UpdatePlayerLocation(tm, tc2);
							end;

                            $46:    {Sanctuary}
                            begin
                                tc2.Skill[tn.MSkill].Tick := tn.Tick;

                                //if tc2.Skill[tn.MSkill].Tick < Tick then begin;
                                tc2.Skill[tn.MSkill].EffectLV := tn.MUseLV;
                                tc2.Skill[tn.MSkill].Effect1 := tc2.Skill[tn.MSkill].Data.Data2[tn.MUseLV];
                                if tc2.SkillTick > tc2.Skill[tn.MSkill].Tick then begin
                                    tc2.SkillTick := tc2.Skill[tn.MSkill].Tick;
                                    tc2.SkillTickID := tn.MSkill;

                                end;
                                tc2.InField := true;
                            end;

                            $b3:    // Gospel
                            begin
                                tc2.Skill[tn.MSkill].Tick := tn.Tick;

                                //if tc2.Skill[tn.MSkill].Tick < Tick then begin;
                                tc2.Skill[tn.MSkill].EffectLV := tn.MUseLV;
                                tc2.Skill[tn.MSkill].Effect1 := tc2.Skill[tn.MSkill].Data.Data2[tn.MUseLV];
                                if tc2.SkillTick > tc2.Skill[tn.MSkill].Tick then begin
                                    tc2.SkillTick := tc2.Skill[tn.MSkill].Tick;
                                    tc2.SkillTickID := tn.MSkill;

                                end;
                                tc2.InField := true;
                            end;

                            $49:    {Ragnarok}  //UNCODED
                            begin
                                j := Random(10);
                            end;

                            $9a:    {Volcano Effect}
                            begin
                                tc2.Skill[tn.MSkill].Tick := tn.Tick;

                                tc2.Skill[tn.MSkill].EffectLV := tn.MUseLV;
                                tc2.Skill[tn.MSkill].Effect1 := tc2.Skill[tn.MSkill].Data.Data2[tn.MUseLV];

                                CalcStat(tc2, Tick);
                                CalcSageSkill(tc2, Tick);

                                //SendCStat(tc2);
                                tc2.InField := true;

                            end;

                            $9b,$9c: {Deluge, Violent Gale}
                            begin
                                tc2.Skill[tn.MSkill].Tick := tn.Tick;

                                tc2.Skill[tn.MSkill].EffectLV := tn.MUseLV;
                                tc2.Skill[tn.MSkill].Effect1 := tc2.Skill[tn.MSkill].Data.Data2[tn.MUseLV];

                                CalcStat(tc2, Tick);
                                CalcSageSkill(tc2, Tick);

                                SendCStat(tc2);
                                tc2.InField := true;
                            end;


                            $9e,$9f,$a0,$a1,$a2,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af:
                            {Mr Rich Man A Kim.. and like every bard skill starts here}
                            begin
                                tc2.Skill[tn.MSkill].Tick := tn.Tick;

                                tc2.Skill[tn.MSkill].EffectLV := tn.MUseLV;
                                tc2.Skill[tn.MSkill].Effect1 := tc2.Skill[tn.MSkill].Data.Data2[tn.MUseLV];
                                if tc2.SkillTick > tc2.Skill[tn.MSkill].Tick then begin
                                    tc2.SkillTick := tc2.Skill[tn.MSkill].Tick;
                                    tc2.SkillTickID := tn.MSkill;
                                end;

                                CalcSongStat(tc2, Tick);

                                CalcSongSkill(tc2, Tick);

                                SendCStat(tc2);
                                tc2.InField := true;

                            end;

                        end;
                    end;
                end;
            end;  //End of friendly Pvp Skills

            //Damage PvP begins
            if (mi.PvP = true) then begin
                if sl2.Count <> 0 then begin
                    for c1 := 0 to sl2.Count - 1 do begin
                        tc2 := sl2.Objects[c1] as TChara;
                        if (tc2 <> tn.CData) and (tc2.NoTarget = false) and (tc2.HP > 0) then begin

                            // Colus, 20040317: Alex commented this out, beita undid it, I recommented.
                            // Caused crashes with parties in PvP maps
                            {if (tc2.PartyName <> '') and (tn.CData.Partyname <> '') then begin
                                if (tc2.PartyName = tn.CData.Partyname) then break;
                            end;}

                            case tn.JID of
                                $74://Unsure... what  this is exactly... I Don't see anywhere that calls it
                                begin
								    dmg[0] := (tc1.Param[4] + 75) * (100 + tc1.Param[3]) div 100;
								    dmg[0] := dmg[0] * tn.Count;
							    	if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								    tn.Tick := Tick;
								    WFIFOW( 0, $01de);
								    WFIFOW( 2, $74);
								    WFIFOL( 4, tn.ID);
								    WFIFOL( 8, tc2.ID);
								    WFIFOL(12, Tick);
								    WFIFOL(16, tc1.aMotion);
								    WFIFOL(20, tc2.dMotion);
								    WFIFOL(24, dmg[0]);
								    WFIFOW(28, tn.Count);
								    WFIFOW(30, 1);
								    WFIFOB(32, 5);
								    SendBCmd(tm, tn.Point, 33);
								    DamageProcess2(tm, tc1, tc2, dmg[0], tick);
							    end;

						{//$7f: //ÉtÉ@ÉCÉAÅ[ÉEÉHÅ[Éã
							begin
								//É_ÉÅÅ[ÉWéZèo
								dmg[0] := tn.CData.MATK1 + Random(tn.CData.MATK2 - tn.CData.MATK1 + 1) * tn.CData.MATKFix div 100 * tn.CData.Skill[18].Data.Data1[tn.MUseLV] div 100;
								//dmg[0] := tn.MATK1 + Random(tn.MATK2 - tn.MATK1 + 1);
								dmg[0] := dmg[0] * (100 - tc2.MDEF1 + tc2.MDEF2) div 100; //MDEF%
								dmg[0] := dmg[0] - tc2.Param[3]; //MDEF-
								if dmg[0] < 1 then dmg[0] := 1;
								dmg[0] := dmg[0] * ElementTable[tn.CData.Skill[18].Data.Element][ts1.Element] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								//É_ÉÅÅ[ÉWÉpÉPëóêM
								WFIFOW( 0, $01de);
								WFIFOW( 2, 18);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, tc2.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, 0);
								WFIFOL(20, tc2.dMotion);
								WFIFOL(24, dmg[0]);
								WFIFOW(28, 1);
								WFIFOW(30, 1);
								WFIFOB(32, 4);
								SendBCmd(tm, tn.Point, 33);
								//ÉmÉbÉNÉoÉbÉNèàóù
								{if (dmg[0] > 0) and (ts1.Data.Race <> 1) then begin
									SetLength(bb, 2);
									bb[0] := 4;
									bb[1] := 4;
									xy := ts1.Point;
									DirMove(tm, ts1.Point, ts1.Dir, bb);
									//ÉuÉçÉbÉNà⁄ìÆ
									if (xy.X div 8 <> ts1.Point.X div 8) or (xy.Y div 8 <> ts1.Point.Y div 8) then begin
										with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
											assert(IndexOf(ts1.ID) <> -1, 'MobBlockDelete Error');
											Delete(IndexOf(ts1.ID));
										end;
										tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);
									end;
									ts1.pcnt := 0;
									//ÉpÉPëóêM
									WFIFOW(0, $0088);
									WFIFOL(2, ts1.ID);
									WFIFOW(6, ts1.Point.X);
									WFIFOW(8, ts1.Point.Y);
									SendBCmd(tm, ts1.Point, 10);
								end;
								DamageProcess2(tm, tn.CData, tc2, dmg[0], Tick);
								Dec(tn.Count);
								if tn.Count = 0 then begin //Ç±Ç±ÇÃèàóùÇ™Ç§Ç‹Ç≠Ç¢Ç≠Ç©Ç«Ç§Ç©ì‰
									DelSkillUnit(tm, tn);
									Dec(k);
									Break;
								end;
							end;}
{í«â¡:119}
					       { $84:
							begin
									//É_ÉÅÅ[ÉWéZèo
                  if (tc2.ArmorElement mod 20 = 9) then begin
									dmg[0] := tn.CData.MATK1 + Random(tn.CData.MATK2 - tn.CData.MATK1 + 1) * tn.CData.MATKFix div 100;
									dmg[0] := dmg[0] * (100 - tc2.MDEF1 + tc2.MDEF2) div 100; //MDEF%
									dmg[0] := dmg[0] - tc2.Param[3]; //MDEF-
									if dmg[0] < 1 then dmg[0] := 1;
									dmg[0] := dmg[0] * tn.Count;
									if dmg[0] < 0 then dmg[0] := 0;
									tn.Tick := Tick;
									//É_ÉÅÅ[ÉWÉpÉPëóêM
									WFIFOW( 0, $01de);
									WFIFOW( 2, 79);
									WFIFOL( 4, tn.ID);
									WFIFOL( 8, tc2.ID);
									WFIFOL(12, Tick);
									WFIFOL(16, tc1.aMotion);
									WFIFOL(20, tc2.dMotion);
									WFIFOL(24, dmg[0]);
									WFIFOW(28, tn.Count);
									WFIFOW(30, tl.Data2[tn.Count]);
									WFIFOB(32, 8);
									SendBCmd(tm, tn.Point, 33);
									DamageProcess2(tm, tn.CData, tc2, dmg[0], Tick);
                  end;
							end;  }
{í«â¡:119ÉRÉRÇ‹Ç≈}
						    $86: //LoV
							    begin
								    if (tn.Tick + 1000 * tn.Count) < (Tick + 3000) then begin
									    dmg[0] := tc1.MATK1 * (80 + 20 * tl.Data1[tn.MUseLV]) div 400;
									    dmg[0] := dmg[0] * (100 - (tc2.MDEF1 + tc2.MDEF2)) div 100; //MDEF%
									    dmg[0] := dmg[0] - tc2.Param[3]; //MDEF-
									    if dmg[0] < 1 then dmg[0] := 1;
								    	//dmg[0] := dmg[0] * tl.Data2[tn.MUseLV];
								    	if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
									    WFIFOW( 0, $01de);
									    WFIFOW( 2, 85);
									    WFIFOL( 4, tn.ID);
									    WFIFOL( 8, tc2.ID);
									    WFIFOL(12, Tick);
									    WFIFOL(16, tc1.aMotion);
									    WFIFOL(20, tc2.dMotion);
									    WFIFOL(24, dmg[0]);
									    WFIFOW(28, tn.MUseLV);
									    WFIFOW(30, tl.Data2[tn.MUseLV]);
									    WFIFOB(32, 8);
									    SendBCmd(tm, tn.Point, 33);
									    DamageProcess2(tm,tc1,tc2,dmg[0],tick);
									    if c1 = (sl2.Count -1) then begin
										    Inc(tn.Count);	//CountÇî≠ìÆî≠êîÇ∆SkillLVÇ…égóp
										    if tn.Count = 1 then tn.Tick := Tick
									    end;
								    end;
							    end;
						    $87: //FP
							    begin
								    //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Hit') ;
								    {if not flag then Break;} //ì•ÇÒÇ≈Ç»Ç¢
								    tn.Tick := Tick;
								    dmg[0] := (tc1.MATK1 + Random(tc1.MATK2 - tc1.MATK1 + 1)) * tc1.MATKFix div 500 + 50;
								    if dmg[0] < 51 then dmg[0] := 51;
								    dmg[0] := dmg[0] * tl.Data2[tn.Count];
								    if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								    //ñ≥óùÇ‚ÇËÉGÉtÉFÉNÉgÇèoÇµÇƒÇ›ÇÈ
								    {SetSkillUnit(tm,tc1.ID,tn.Point,Tick,$88,0,4000);}

								    WFIFOW( 0, $01de);
								    WFIFOW( 2, tn.JID);
								    WFIFOL( 4, tn.ID);
								    WFIFOL( 8, tc2.ID);
								    WFIFOL(12, Tick);
								    WFIFOL(16, tc1.aMotion);
								    WFIFOL(20, tc2.dMotion);
								    WFIFOL(24, dmg[0]);
								    WFIFOW(28, tn.Count);
								    WFIFOW(30, tl.Data2[tn.Count]);
								    WFIFOB(32, 8);
								    SendBCmd(tm, tn.Point, 33);
								    DamageProcess2(tm,tc1,tc2,dmg[0],Tick);
							    end;

                            $88: //Meteor
							    begin
								    if (tn.Tick + 1000 * tn.Count) < (Tick + 3000) then begin
									    dmg[0] := tc1.MATK1 + Random(tc1.MATK2 - tc1.MATK1 + 1) * tc1.MATKFix div 100 * tl.Data1[tn.MUseLV] div 100;
									    dmg[0] := dmg[0] * (100 - tc2.MDEF1 + tc2.MDEF2) div 100; //MDEF%
									    dmg[0] := dmg[0] - tc2.Param[3]; //MDEF-
									    if dmg[0] < 1 then dmg[0] := 1;
									    dmg[0] := dmg[0] * tl.Data2[tn.MUseLV];
									    if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                                        //if tn.LastPacketSendTick + tn.PacketSendDelay < Tick then begin
                                            //UpdateGroundEffect(tm, 83, tn.ID, tc2.ID, Tick, tc1.aMotion, tc2.dMotion, dmg[0], tn.MUseLV, tl.Data2[tn.MUseLV], 8, tn.Point);
                                            //tn.LastPacketSendTick := Tick;
                                        //end;
									    WFIFOW( 0, $01de);
									    WFIFOW( 2, 83);
									    WFIFOL( 4, tn.ID);
									    WFIFOL( 8, tc2.ID);
									    WFIFOL(12, Tick);
									    WFIFOL(16, tc1.aMotion);
									    WFIFOL(20, tc2.dMotion);
									    WFIFOL(24, dmg[0]);
									    WFIFOW(28, tn.MUseLV);
									    WFIFOW(30, tl.Data2[tn.MUseLV]);
									    WFIFOB(32, 8);
                                        SendBCmd(tm, tn.Point, 33);
									    DamageProcess2(tm,tc1,tc2,dmg[0],tick);
									    if c1 = (sl2.Count -1) then begin
										    Inc(tn.Count);	//CountÇî≠ìÆî≠êîÇ∆SkillLVÇ…égóp
										    if tn.Count = 3 then tn.Tick := Tick
									    end;
								    end;
                                end;
                                                {//$89: //Quagmire
                                                        begin
								if (tn.Tick + 1000 * tn.Count) < (Tick + 3000) then begin
                                                                        if (tc2.Speed * 2 >= 65535) then begin
                                                                                tc2.Speed := 65535;
                                                                        end else begin
						                                tc2.Speed := tc2.Speed * 2;
                                                                        end;
									WFIFOW( 0, $01de);
									WFIFOW( 2, 92);
									WFIFOL( 4, tn.ID);
									WFIFOL( 8, ts1.ID);
									WFIFOL(12, Tick);
									WFIFOL(16, tc1.aMotion);
									WFIFOL(20, tc2.dMotion);
									WFIFOL(24, dmg[0]);
									WFIFOW(28, tn.MUseLV);
									WFIFOW(30, tl.Data2[tn.MUseLV]);
									WFIFOB(32, 8);
                                                                        SendBCmd(tm, tn.Point, 33);
									if c1 = (sl2.Count -1) then begin
										Inc(tn.Count);	//CountÇî≠ìÆî≠êîÇ∆SkillLVÇ…égóp
										if tn.Count = 3 then tn.Tick := Tick
									end;
								end;
							end;}


                                                {//$90: //ÉAÉCÉXÉEÉHÅ[Éã
							begin
								//ÉmÉbÉNÉoÉbÉNèàóù
                //SetLength(bb, 6);
                //bb[0] := 6;
							  //xy := ts1.Point;
							  //DirMove(tm, ts1.Point, tn.Dir, bb);
								SetLength(bb, 2);
								bb[0] := 4;
								bb[1] := 4;
								xy := tc2.Point;
								DirMove(tm, tc2.Point, tc2.Dir, bb);
								//ÉuÉçÉbÉNà⁄ìÆ
								if (xy.X div 8 <> tc2.Point.X div 8) or (xy.Y div 8 <> tc2.Point.Y div 8) then begin
									with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
										assert(IndexOf(tc2.ID) <> -1, 'MobBlockDelete Error');
										Delete(IndexOf(tc2.ID));
									end;
									tm.Block[tc2.Point.X div 8][ts1.Point.Y div 8].CList.AddObject(tc2.ID, tc2);
								end;
								ts1.pcnt := 0;
								//ÉpÉPëóêM
								WFIFOW(0, $0088);
								WFIFOL(2, tc2.ID);
								WFIFOW(6, tc2.Point.X);
								WFIFOW(8, tc2.Point.Y);
								SendBCmd(tm, ts1.Point, 10);
							end;}

							$91:    {Ankle Snare Trapping PVP}
							begin

								if (tn.Count <> 0) and (tc2 <> tn.CData) then begin
                 if not flag then Break; //ì•ÇÒÇ≈Ç»Ç¢
                 tc2.AnkleSnareTick := tn.Tick;
                 tn.Tick := Tick + tn.Count * 10000;
									//ts1.DmgTick := Tick + tn.Count * 10000;
									tc2.Point.X := tn.Point.X;
									tc2.Point.Y := tn.Point.Y;
									tc2.pcnt := 0;
                  UpdatePlayerLocation(tm, tc2);
                  tn.Count := 0;
									if c = (sl2.Count -1) then tn.Count := 0;
								end;
                end;
						$92:    {Venom Dust PvP effect}
              				begin
                				if tc2.isPoisoned = false then begin
                  					tc2.isPoisoned := True;
                  					tc2.PoisonTick := tick + 15000;
                  					tc2.Stat2 := 1;
                  					UpdateStatus(tm, tc2, Tick);
                				end;
              				end;
						$93: {Land Mine}
							begin
								if not flag then Break; //ì•ÇÒÇ≈Ç»Ç¢
                                                                //Land Mine : [ (Dex/2 +75) * (1 + Int/100) x S.Lv ]
                                                                dmg[0] := ( ((trunc(tc1.Param[5]/2)) + 75) * (1 + (tc1.Param[3] div 100)) * tc1.Skill[116].Lv );
								dmg[0] := dmg[0] * tn.Count;
                                                                // AlexKreuz: Players have no element types - Neutral Element.
								// dmg[0] := dmg[0] * ElementTable[tl.Element][tc2.Element] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								tn.Tick := Tick;
								WFIFOW( 0, $01de);
								WFIFOW( 2, 116);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, tc2.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, tc1.aMotion);
								WFIFOL(20, tc2.dMotion);
								WFIFOL(24, dmg[0]);
								WFIFOW(28, tn.Count);
								WFIFOW(30, 1);
								WFIFOB(32, 5);
								SendBCmd(tm, tn.Point, 33);
								DamageProcess2(tm, tc1, tc2, dmg[0], tick);
							end;
            $99: {Talkie Box}
              begin
              //  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Talkie fire pvp');
                WFIFOW(0, $0191);
                WFIFOL(2, tc2.ID);
                WFIFOS(6, tn.Name, 80);
                SendBCmd(tm, tn.Point, 86);
              end;
{:119}
						{//$95: //SM
							begin
								if not flag then Break; //ì•ÇÒÇ≈Ç»Ç¢
								if Random(1000) < tn.CData.Skill[119].Data.Data2[tn.Count] * 10 then begin
									if (ts1.Stat1 <> 4) then begin
										ts1.nStat := 4;
										ts1.BodyTick := Tick + tc1.aMotion;
									end;
								end;
								tn.Tick := Tick;
								WFIFOW( 0, $0114);
								WFIFOW( 2, 15);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, ts1.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, tc1.aMotion);
								WFIFOL(20, ts1.Data.dMotion);
								WFIFOW(24, 0);
								WFIFOW(26, tn.Count);
								WFIFOW(28, 1);
								WFIFOB(30, 5);
								SendBCmd(tm, tn.Point, 31);
							end;
						$96: //Flasher Trap - Bellium (Crimson)
							begin
								if not flag then Break; //ì•ÇÒÇ≈Ç»Ç¢
								if Random(1000) < tn.CData.Skill[120].Data.Data2[tn.Count] * 10 then begin
									if (ts1.Stat1 <> 3) then begin
										ts1.nStat := 3;
										ts1.BodyTick := Tick + tc1.aMotion;
                                                                                WFIFOW( 0, $011a);
                                                                                WFIFOW( 2, 120);
                                                                                WFIFOW( 4, tn.MUseLv);
                                                                                WFIFOL( 6, ts1.ID);
                                                                                WFIFOL(10, tn.ID);
									end;
								end;
								tn.Tick := Tick;
								WFIFOW( 0, $0114);
								WFIFOW( 2, 120);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, ts1.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, tc1.aMotion);
								WFIFOL(20, ts1.Data.dMotion);
								WFIFOW(24, 0);
								WFIFOW(26, tn.Count);
								WFIFOW(28, 1);
								WFIFOB(30, 5);
								SendBCmd(tm, tn.Point, 31);
							end;}
						{//$97: //FT
							begin
								if not flag then Break; //ì•ÇÒÇ≈Ç»Ç¢
								if Random(1000) < tn.CData.Skill[121].Data.Data2[tn.Count] * 10 then begin
									if (ts1.Stat1 <> 2) then begin
										ts1.nStat := 2;
										ts1.BodyTick := Tick + tc1.aMotion;
									end;
								end;
								tn.Tick := Tick;
								WFIFOW( 0, $0114);
								WFIFOW( 2, $79);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, ts1.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, tc1.aMotion);
								WFIFOL(20, ts1.Data.dMotion);
								WFIFOW(24, 0);
								WFIFOW(26, tn.Count);
								WFIFOW(28, 1);
								WFIFOB(30, 5);
								SendBCmd(tm, tn.Point, 31);
							end;
						$98: //CT
							begin
								if not flag then Break; //ì•ÇÒÇ≈Ç»Ç¢
								dmg[0] := (tc1.Param[4] + 75) * (100 + tc1.Param[3]) div 100;
								dmg[0] := dmg[0] * tn.Count;
								dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								tn.Tick := Tick;
								WFIFOW( 0, $01de);
								WFIFOW( 2, 123);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, ts1.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, tc1.aMotion);
								WFIFOL(20, ts1.Data.dMotion);
								WFIFOL(24, dmg[0]);
								WFIFOW(28, tn.Count);
								WFIFOW(30, 1);
								WFIFOB(32, 5);
								SendBCmd(tm, tn.Point, 33);
								DamageProcess1(tm, tc1, ts1, dmg[0], tick);
							end;}
{:119}
																			end;
																		end;
																	end;
																end;
											end;


			sl := TStringList.Create;
			for j1 := (tn.Point.Y - m) div 8 to (tn.Point.Y + m) div 8 do begin
				for i1 := (tn.Point.X - m) div 8 to (tn.Point.X + m) div 8 do begin
					for c := 0 to tm.Block[i1][j1].Mob.Count -1 do begin
						if (tm.Block[i1][j1].Mob.Objects[c] is TMob) then begin
							ts1 := tm.Block[i1][j1].Mob.Objects[c] as TMob;
							if ts1 = nil then Continue;
							if (abs(ts1.Point.X - tn.Point.X) <= m) and (abs(ts1.Point.Y - tn.Point.Y) <= m) then
								sl.AddObject(IntToStr(ts1.ID),ts1);
							if (ts1.Point.X = tn.Point.X) and (ts1.Point.Y = tn.Point.Y) then
								flag := True;
						end;
					end;
				end;
			end;
			if (sl.Count <> 0)  then begin
				if tMonster <> nil then exit;
				for c := 0 to sl.Count - 1 do begin
					ts1 := sl.Objects[c] as TMob;

					case tn.JID of
						$46: //Sanctuary
							begin
								// Colus, 20031229: Check is same as ME (no undead prop, demon race)
								if (tn.Tick >= Tick) and (ts1.EffectTick[3] <= Tick) then begin
								if ((ts1.Element mod 20 = 9) or (ts1.Data.Race = 6)) then begin
									dmg[0] := tn.CData.Skill[70].Data.Data2[tn.MUseLV];

									if dmg[0] < 0 then dmg[0] := 0; //No Negative Damage
									dmg[0] := dmg[0] div 2; // Half-heal damage for undead/demon

									ts1.EffectTick[3] := Tick + 1000;
									WFIFOW( 0, $01de);
									WFIFOW( 2, $46);
									WFIFOL( 4, tn.ID);
									WFIFOL( 8, ts1.ID);
									WFIFOL(12, Tick);
									WFIFOL(16, tc1.aMotion);
									WFIFOL(20, ts1.Data.dMotion);
									WFIFOL(24, dmg[0]);
									WFIFOW(28, tn.MUseLV); // Changed from tn.Count to 1 (1-hit)
									WFIFOW(30, 1);
									WFIFOB(32, 6);  // Changed from 5 (bolt spell) to 6 (1-hit)
									SendBCmd(tm, tn.Point, 33);
									DamageProcess1(tm, tc1, ts1, dmg[0], tick);
								end else begin
								//if ((ts1.Element mod 20 <> 9) and (ts1.Data.Race <> 6) and (ts1.EffectTick[3] <= Tick)) then begin
									//debugout.lines.add('[' + TimeToStr(Now) + '] ' + format('et3 %d, tick %d',[ts1.EffectTick[3], Tick]));
									//É_ÉÅÅ[ÉWéZèo
									//dmg[0] := tn.CData.Skill[70].Data.Data2[tn.MUseLV];
									i := tn.CData.Skill[70].Data.Data2[tn.MUseLV];

									ts1.EffectTick[3] := Tick + 1000;
									//É_ÉÅÅ[ÉWÉpÉPëóêM
									ts1.HP := ts1.HP + i; //dmg[0];
									if Cardinal(ts1.HP) > ts1.Data.HP then ts1.HP := Integer(ts1.Data.HP);

									WFIFOW( 0, $011a);
									WFIFOW( 2, 28); // Use heal
									WFIFOW( 4, i); //dmg[0]);
									WFIFOL( 6, ts1.ID);
									WFIFOL(10, tn.ID);
									WFIFOB(14, 1);
									SendBCmd(tm, ts1.Point, 15);

								end;
								end;
							end;




{:119}
					$74://ÉuÉâÉXÉgÉ}ÉCÉìî≠ìÆ
							begin
								dmg[0] := (tc1.Param[4] + 75) * (100 + tc1.Param[3]) div 100;
								dmg[0] := dmg[0] * tn.Count;
								dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								tn.Tick := Tick;
								WFIFOW( 0, $01de);
								WFIFOW( 2, $74);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, ts1.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, tc1.aMotion);
								WFIFOL(20, ts1.Data.dMotion);
								WFIFOL(24, dmg[0]);
								WFIFOW(28, tn.Count);
								WFIFOW(30, 1);
								WFIFOB(32, 5);
								SendBCmd(tm, tn.Point, 33);
								DamageProcess1(tm, tc1, ts1, dmg[0], tick);
							end;
{:119}
						$7f: //ÉtÉ@ÉCÉAÅ[ÉEÉHÅ[Éã
							begin
								//É_ÉÅÅ[ÉWéZèo
								dmg[0] := tn.CData.MATK1 + Random(tn.CData.MATK2 - tn.CData.MATK1 + 1) * tn.CData.MATKFix div 100 * tn.CData.Skill[18].Data.Data1[tn.MUseLV] div 100;
								//dmg[0] := tn.MATK1 + Random(tn.MATK2 - tn.MATK1 + 1);
								dmg[0] := dmg[0] * (100 - ts1.Data.MDEF) div 100; //MDEF%
								dmg[0] := dmg[0] - ts1.Data.Param[3]; //MDEF-
								if dmg[0] < 1 then dmg[0] := 1;
								dmg[0] := dmg[0] * ElementTable[tn.CData.Skill[18].Data.Element][ts1.Element] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								//É_ÉÅÅ[ÉWÉpÉPëóêM
								WFIFOW( 0, $01de);
								WFIFOW( 2, 18);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, ts1.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, 0);
								WFIFOL(20, ts1.Data.dMotion);
								WFIFOL(24, dmg[0]);
								WFIFOW(28, 1);
								WFIFOW(30, 1);
								WFIFOB(32, 4);
								SendBCmd(tm, tn.Point, 33);
								//ÉmÉbÉNÉoÉbÉNèàóù
								if (dmg[0] > 0) and (ts1.Data.Race <> 1) then begin
									SetLength(bb, 2);
									bb[0] := 4;
									bb[1] := 4;
									xy := ts1.Point;
									DirMove(tm, ts1.Point, ts1.Dir, bb);
									//ÉuÉçÉbÉNà⁄ìÆ
									if (xy.X div 8 <> ts1.Point.X div 8) or (xy.Y div 8 <> ts1.Point.Y div 8) then begin
										with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
											assert(IndexOf(ts1.ID) <> -1, 'MobBlockDelete Error');
											Delete(IndexOf(ts1.ID));
										end;
										tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);
									end;
									ts1.pcnt := 0;
									//Update Monster Location
                                                                        UpdateMonsterLocation(tm, ts1);

								end;
								DamageProcess1(tm, tn.CData, ts1, dmg[0], Tick);
								Dec(tn.Count);
								if tn.Count = 0 then begin //Ç±Ç±ÇÃèàóùÇ™Ç§Ç‹Ç≠Ç¢Ç≠Ç©Ç«Ç§Ç©ì‰
									DelSkillUnit(tm, tn, tc);
									Dec(k);
									Break;
								end;
							end;
{í«â¡:119}
						$84: // Damage of Magnus Exorcism
							begin
								if ((ts1.Element mod 20 = 9) or (ts1.Data.Race = 6)) and (tn.Tick >= Tick) and (ts1.EffectTick[2] <= Tick) then begin
									//É_ÉÅÅ[ÉWéZèo
									dmg[0] := tn.CData.MATK1 + Random(tn.CData.MATK2 - tn.CData.MATK1 + 1) * tn.CData.MATKFix div 100;
									dmg[0] := dmg[0] * (100 - ts1.Data.MDEF) div 100; //MDEF%
									dmg[0] := dmg[0] - ts1.Data.Param[3]; //MDEF-
									if dmg[0] < 1 then dmg[0] := 1;
									dmg[0] := dmg[0] * tn.Count;
									dmg[0] := dmg[0] * ElementTable[tn.CData.Skill[79].Data.Element][ts1.Element] div 100;
                  if (ts1.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;                  
									if dmg[0] < 0 then dmg[0] := 0;
									ts1.EffectTick[2] := Tick + 3000;       // TODO: Stop expiring ME tiles on 1 hit
									//É_ÉÅÅ[ÉWÉpÉPëóêM
									WFIFOW( 0, $01de);
									WFIFOW( 2, 79);
									WFIFOL( 4, tn.ID);
									WFIFOL( 8, ts1.ID);
									WFIFOL(12, Tick);
									WFIFOL(16, tc1.aMotion);
									WFIFOL(20, ts1.Data.dMotion);
									WFIFOL(24, dmg[0]);
									WFIFOW(28, tn.Count);
									WFIFOW(30, tl.Data2[tn.Count]);
									WFIFOB(32, 8);
									SendBCmd(tm, tn.Point, 33);
									DamageProcess1(tm, tn.CData, ts1, dmg[0], Tick);
								end;
							end;
{í«â¡:119ÉRÉRÇ‹Ç≈}
            // Colus, 20040505: Look, ALL great magics (SG/LoV/GX) operate HERE.
            // If you want different calculations for them, CHECK tn.MSkill!
						$86: // Great Magic damage (Player vs. Monster)
							begin
                if (tn.MSkill = 85) then begin // LoV
                  if (tn.Tick + 1000 * tn.Count) < (Tick + 4000) then begin

                  	{ Alex: math laws which should be working aren't. Go figure }
                    { If dmg[0] breaks which only happens with integer overflow conditions, }
                    { then set dmg[0] to its maximum. }
                    try
                    	dmg[0] := (tc1.MATK1 + Random(tc1.MATK2 - tc1.MATK1 + 1)) * tl.Data1[tn.MUseLV] div 100 * tc1.MATKFix div 100;
                        dmg[0] := dmg[0] * (100 - ts1.Data.MDEF) div 100; //MDEF%
                        dmg[0] := dmg[0] - ts1.Data.Param[3]; //MDEF-
                        if dmg[0] < 1 then dmg[0] := 1;
                        dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100;
                        //dmg[0] := dmg[0] * tl.Data2[tn.MUseLV];
                        if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                    except
                    	dmg[0] := 2147483647;
                    end;


	  								WFIFOW( 0, $01de);
  									WFIFOW( 2, tn.MSkill);
  									WFIFOL( 4, tn.ID);
  									WFIFOL( 8, ts1.ID);
  									WFIFOL(12, Tick);
  									WFIFOL(16, tc1.aMotion);
  									WFIFOL(20, ts1.Data.dMotion);
  									WFIFOL(24, dmg[0]);
  									WFIFOW(28, tn.MUseLV);
  									WFIFOW(30, tl.Data2[tn.MUseLV]);
  									WFIFOB(32, 8);
  									if ts1.isEmperium = false then begin
  									  SendBCmd(tm, tn.Point, 33);
  									end;
  									DamageProcess1(tm,tc1,ts1,dmg[0],tick);
  									if c = (sl.Count -1) then begin
  										Inc(tn.Count);	//CountÇî≠ìÆî≠êîÇ∆SkillLVÇ…égóp
  										if tn.Count = 4 then tn.Tick := Tick
  									end;
                   end;

                end else if (tn.MSkill = 89) then begin // SG
                  // Hits every .45 seconds, 10 times.
  								if (tn.Tick + (450 * tn.Count)) < (Tick + 4500) then begin
                    dmg[0] := (tc1.MATK1 + Random(tc1.MATK2 - tc1.MATK1 + 1)) * tl.Data1[tn.MUseLV] div 100 * tc1.MATKFix div 100;
  									dmg[0] := dmg[0] * (100 - ts1.Data.MDEF) div 100; //MDEF%
  									dmg[0] := dmg[0] - ts1.Data.Param[3]; //MDEF-
  									if dmg[0] < 1 then dmg[0] := 1;
  									dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100;
  									//dmg[0] := dmg[0] * tl.Data2[tn.MUseLV];
  									if (dmg[0] < 0) or (ts1.Stat1 = 2) then dmg[0] := 0;
                    if (dmg[0] > 0) and (ts1.isEmperium = false) and (ts1.Data.Race <> 1) then begin
                      ts1.BodyCount := ts1.BodyCount + 1;
                      if (ts1.BodyCount = 3) then begin
                        ts1.BodyCount := 0;
                        ts1.nStat := 2;
                        ts1.BodyTick := Tick + tc1.aMotion;
                      end;
                    end;
  									WFIFOW( 0, $01de);
  									WFIFOW( 2, 89);
  									WFIFOL( 4, tn.ID);
  									WFIFOL( 8, ts1.ID);
  									WFIFOL(12, Tick);
  									WFIFOL(16, tc1.aMotion);
  									WFIFOL(20, ts1.Data.dMotion);
  									WFIFOL(24, dmg[0]);
  									WFIFOW(28, tn.MUseLV);
  									WFIFOW(30, 1);
  									WFIFOB(32, 6);
  									if ts1.isEmperium = false then begin
  									  SendBCmd(tm, tn.Point, 33);
  									end;
  									DamageProcess1(tm,tc1,ts1,dmg[0],tick);

                    if (tn.Count = 10) then ts1.BodyCount := 0;

  									if c = (sl.Count -1) then begin
  										Inc(tn.Count);	//CountÇî≠ìÆî≠êîÇ∆SkillLVÇ…égóp
  										if tn.Count = 10 then tn.Tick := Tick
  									end;
  								end;
                end;

							end;
						$87: //FP
							begin
								//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Hit') ;
								{if not flag then Break;} //ì•ÇÒÇ≈Ç»Ç¢
								tn.Tick := Tick;
								dmg[0] := (tn.CData.MATK1 + Random(tn.CData.MATK2 - tn.CData.MATK1 + 1)) * tn.CData.MATKFix div 500 + 50;
								if dmg[0] < 51 then dmg[0] := 51;
								dmg[0] := dmg[0] * tl.Data2[tn.Count];
								dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								//ñ≥óùÇ‚ÇËÉGÉtÉFÉNÉgÇèoÇµÇƒÇ›ÇÈ
								{SetSkillUnit(tm,tc1.ID,tn.Point,Tick,$87,0,4000);}

								WFIFOW( 0, $01de);
								WFIFOW( 2, tn.JID);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, ts1.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, tc1.aMotion);
								WFIFOL(20, ts1.Data.dMotion);
								WFIFOL(24, dmg[0]);
								WFIFOW(28, tn.Count);
								WFIFOW(30, tl.Data2[tn.Count]);
								WFIFOB(32, 8);
								SendBCmd(tm, tn.Point, 33);
								DamageProcess1(tm,tc1,ts1,dmg[0],Tick);
							end;
                                                $88: //Meteor
							begin
								if (tn.Tick + 1000 * tn.Count) < (Tick + 3000) then begin
                                                                        if tc1 <> nil then begin
									        dmg[0] := tc1.MATK1 + Random(tc1.MATK2 - tc1.MATK1 + 1) * tc1.MATKFix div 100 * tl.Data1[tn.MUseLV] div 100;
									        dmg[0] := dmg[0] * (100 - ts1.Data.MDEF) div 100; //MDEF%
									        dmg[0] := dmg[0] - ts1.Data.Param[3]; //MDEF-
									        if dmg[0] < 1 then dmg[0] := 1;
									        dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100;
									        dmg[0] := dmg[0] * tl.Data2[tn.MUseLV];
									        if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
									        WFIFOW( 0, $01de);
									        WFIFOW( 2, 83);
									        WFIFOL( 4, tn.ID);
									        WFIFOL( 8, ts1.ID);
									        WFIFOL(12, Tick);
									        WFIFOL(16, tc1.aMotion);
									        WFIFOL(20, ts1.Data.dMotion);
									        WFIFOL(24, dmg[0]);
									        WFIFOW(28, tn.MUseLV);
									        WFIFOW(30, tl.Data2[tn.MUseLV]);
									        WFIFOB(32, 8);
                                                                                SendBCmd(tm, tn.Point, 33);
									        DamageProcess1(tm,tc1,ts1,dmg[0],tick);
									        if c = (sl.Count -1) then begin
										        Inc(tn.Count);	//CountÇî≠ìÆî≠êîÇ∆SkillLVÇ…égóp
										        if tn.Count = 3 then tn.Tick := Tick
									        end;
                                                                        end;
								end;
							end;
                $8E: //Quagmire
                     //ts.EffectTick[1] set to be the tick value of monster under
                     //Quagmire effect. effect will resume after EffectTick[1]
                     //is less than Tick, done in procedure StatEffect
            begin
              if (ts1.EffectTick[1] < Tick ) then begin
                 ts1.Speed := ts1.Speed * 2;
                 ts1.Data.Param[1] := ts1.Data.Param[1] div 2;
                 ts1.Data.Param[4] := ts1.Data.Param[4] div 2;
              end;
                 ts1.EffectTick [1]:= Tick + 5000*tc1.Skill[92].Lv;
              end;

						$8d:    {Ice Wall}
							begin
                {Colus, 20030113: Put bounce back in until pathing is updated.}
								SetLength(bb, 1);
								bb[0] := 4;   // 2->4
                                                                xy := ts1.Point;
								DirMove(tm, ts1.Point, ts1.Dir, bb);

								if (xy.X div 8 <> ts1.Point.X div 8) or (xy.Y div 8 <> ts1.Point.Y div 8) then begin
									with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
										assert(IndexOf(ts1.ID) <> -1, 'MobBlockDelete Error');
										Delete(IndexOf(ts1.ID));
									end;
									tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);
								end;
								ts1.pcnt := 0;

                                                                UpdateMonsterLocation(tm, ts1);
                      
							end;

                                                $90: //ÉAÉCÉXÉEÉHÅ[Éã
							begin
								//ÉmÉbÉNÉoÉbÉNèàóù

								SetLength(bb, 2);
								bb[0] := 4;
								bb[1] := 4;
								xy := ts1.Point;
								DirMove(tm, ts1.Point, ts1.Dir, bb);
								//ÉuÉçÉbÉNà⁄ìÆ
								if (xy.X div 8 <> ts1.Point.X div 8) or (xy.Y div 8 <> ts1.Point.Y div 8) then begin
									with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
										assert(IndexOf(ts1.ID) <> -1, 'MobBlockDelete Error');
										Delete(IndexOf(ts1.ID));
									end;
									tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);
								end;
								ts1.pcnt := 0;
								//Update Monster Location
                                                                UpdateMonsterLocation(tm, ts1);
								
							end;

                $91:    {Ankle Snare Trapping Code}
							begin
								if tn.Count <> 0 then begin
                if not flag then Break; //ì•ÇÒÇ≈Ç»Ç¢
								//if Random(1000) < tn.CData.Skill[117].Data.Data2[tn.Count] * 10 then begin
								if (ts1.Stat1 <> 5) then begin
                  ts1.Data.Mode:= 0;
									ts1.nStat := 5;
									ts1.BodyTick := Tick + tc1.aMotion;
									end;
								//end;
                  ts1.AnkleSnareTick := tn.Tick;
									tn.Tick := Tick + tn.Count * 10000;
                  tn.Count := 0;
									//ts1.DmgTick := Tick + tn.Count * 10000;
									ts1.Point.X := tn.Point.X;
									ts1.Point.Y := tn.Point.Y;
									ts1.pcnt := 0;
                  UpdateMonsterLocation(tm, ts1);
                  if c = (sl.Count -1) then tn.Count := 0;
								end;
							end;
                                                $92:    {Venom Dust}
                                                        begin
                                                                if not Boolean(ts1.Stat2 and 1) then
								        ts1.HealthTick[0] := Tick + tn.CData.aMotion
							        else ts1.HealthTick[0] := ts1.HealthTick[0] + 30000;
                                                        end;

						$93: {Land Mine}
							begin
								if not flag then Break; //ì•ÇÒÇ≈Ç»Ç¢
                                                                //Land Mine : [ (Dex/2 +75) * (1 + Int/100) x S.Lv ]
                                                                dmg[0] := ( ((trunc(tc1.Param[5]/2)) + 75) * (1 + (tc1.Param[3] div 100)) * tc1.Skill[116].Lv );
								dmg[0] := dmg[0] * tn.Count;
								dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								tn.Tick := Tick;
								WFIFOW( 0, $01de);
								WFIFOW( 2, 116);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, ts1.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, tc1.aMotion);
								WFIFOL(20, ts1.Data.dMotion);
								WFIFOL(24, dmg[0]);
								WFIFOW(28, tn.Count);
								WFIFOW(30, 1);
								WFIFOB(32, 5);
								SendBCmd(tm, tn.Point, 33);
								DamageProcess1(tm, tc1, ts1, dmg[0], tick);
							end;
{:119}
						$95: //SM
							begin
								if not flag then Break; //ì•ÇÒÇ≈Ç»Ç¢
								if Random(1000) < tn.CData.Skill[119].Data.Data2[tn.Count] * 10 then begin
									if (ts1.Stat1 <> 4) then begin
										ts1.nStat := 4;
										ts1.BodyTick := Tick + tc1.aMotion;
									end;
								end;
								tn.Tick := Tick;
								WFIFOW( 0, $0114);
								WFIFOW( 2, 15);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, ts1.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, tc1.aMotion);
								WFIFOL(20, ts1.Data.dMotion);
								WFIFOW(24, 0);
								WFIFOW(26, tn.Count);
								WFIFOW(28, 1);
								WFIFOB(30, 5);
								SendBCmd(tm, tn.Point, 31);
							end;
						$96: //Flasher Trap - Bellium (Crimson)
							begin
								if not flag then Break; //ì•ÇÒÇ≈Ç»Ç¢
								if Random(1000) < tn.CData.Skill[120].Data.Data2[tn.Count] * 10 then begin
									if (ts1.Stat1 <> 3) then begin
										ts1.nStat := 3;
										ts1.BodyTick := Tick + tc1.aMotion;
                                                                                WFIFOW( 0, $011a);
                                                                                WFIFOW( 2, 120);
                                                                                WFIFOW( 4, tn.MUseLv);
                                                                                WFIFOL( 6, ts1.ID);
                                                                                WFIFOL(10, tn.ID);
									end;
								end;
								tn.Tick := Tick;
								WFIFOW( 0, $0114);
								WFIFOW( 2, 120);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, ts1.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, tc1.aMotion);
								WFIFOL(20, ts1.Data.dMotion);
								WFIFOW(24, 0);
								WFIFOW(26, tn.Count);
								WFIFOW(28, 1);
								WFIFOB(30, 5);
								SendBCmd(tm, tn.Point, 31);
							end;
						$97: //FT
							begin
								if not flag then Break; //ì•ÇÒÇ≈Ç»Ç¢
								if Random(1000) < tn.CData.Skill[121].Data.Data2[tn.Count] * 10 then begin
									if (ts1.Stat1 <> 2) then begin
										ts1.nStat := 2;
										ts1.BodyTick := Tick + tc1.aMotion;
									end;
								end;
								tn.Tick := Tick;
								WFIFOW( 0, $0114);
								WFIFOW( 2, $79);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, ts1.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, tc1.aMotion);
								WFIFOL(20, ts1.Data.dMotion);
								WFIFOW(24, 0);
								WFIFOW(26, tn.Count);
								WFIFOW(28, 1);
								WFIFOB(30, 5);
								SendBCmd(tm, tn.Point, 31);
							end;
						$98: //CT
							begin
								if not flag then Break; //ì•ÇÒÇ≈Ç»Ç¢
								dmg[0] := (tc1.Param[4] + 75) * (100 + tc1.Param[3]) div 100;
								dmg[0] := dmg[0] * tn.Count;
								dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								tn.Tick := Tick;
								WFIFOW( 0, $01de);
								WFIFOW( 2, 123);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, ts1.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, tc1.aMotion);
								WFIFOL(20, ts1.Data.dMotion);
								WFIFOL(24, dmg[0]);
								WFIFOW(28, tn.Count);
								WFIFOW(30, 1);
								WFIFOB(32, 5);
								SendBCmd(tm, tn.Point, 33);
								DamageProcess1(tm, tc1, ts1, dmg[0], tick);
							end;

            $99: {Talkie Box}
              begin
                WFIFOW(0, $0191);
                WFIFOL(2, ts1.ID);
                WFIFOS(6, tn.Name, 80);
                SendBCmd(tm, tn.Point, 86);
              end;
                                                $6E:   {Hammer Fall}
                                                        if Random(100) < tn.CData.Skill[110].Data.Data1[tn.MUseLV] then begin
                                                                if (ts1.Stat1 <> 3) then begin
                                                                        ts1.nStat := 3;
                                                                        ts1.BodyTick := Tick + tn.CData.aMotion;
                                                                end else begin
                                                                        ts1.BodyTick := ts1.BodyTick + 30000;
                                                                end;
                                                        end;

                                                $E5:    {Demonstration Damage and Acid Terror Damage}
                                                        begin
								DamageCalc1(tm, tn.CData,ts1, Tick, 0, tn.CData.Skill[229].Data.Data2[tn.MUseLV],tl.Element,0);
								if dmg[0] < 0 then dmg[0] := 0;

								WFIFOW( 0, $01de);
								WFIFOW( 2, 18);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, ts1.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, 0);
								WFIFOL(20, ts1.Data.dMotion);
								WFIFOL(24, dmg[0]);
								WFIFOW(28, 1);
								WFIFOW(30, 1);
								WFIFOB(32, 4);
								SendBCmd(tm, tn.Point, 33);

								if (dmg[0] > 0) and (ts1.Data.Race <> 1) then begin
									SetLength(bb, 2);
									bb[0] := 4;
									bb[1] := 4;
									xy := ts1.Point;
									DirMove(tm, ts1.Point, ts1.Dir, bb);
									//ÉuÉçÉbÉNà⁄ìÆ
									if (xy.X div 8 <> ts1.Point.X div 8) or (xy.Y div 8 <> ts1.Point.Y div 8) then begin
										with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
											assert(IndexOf(ts1.ID) <> -1, 'MobBlockDelete Error');
											Delete(IndexOf(ts1.ID));
										end;
										tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);
									end;
									ts1.pcnt := 0;
									//Update Monster Location
                                                                        UpdateMonsterLocation(tm, ts1);
									
								end;
								DamageProcess1(tm, tn.CData, ts1, dmg[0], Tick);
								Dec(tn.Count);
								if tn.Count = 0 then begin //Ç±Ç±ÇÃèàóùÇ™Ç§Ç‹Ç≠Ç¢Ç≠Ç©Ç«Ç§Ç©ì‰
									DelSkillUnit(tm, tn, tc);
									Dec(k);
									Break;
								end;
							end;
                                                $E9:    {Marine Sphere}
                                                        begin
                                                                if not flag then Break;
								dmg[0] := (tc1.Param[4] + 75) * (100 + tc1.Param[3]) div 100;
								dmg[0] := dmg[0] * tn.Count;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								tn.Tick := Tick;
								WFIFOW( 0, $01de);
								WFIFOW( 2, 116);
								WFIFOL( 4, tn.ID);
								WFIFOL( 8, ts1.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, tc1.aMotion);
								WFIFOL(20, ts1.Data.dMotion);
								WFIFOL(24, dmg[0]);
								WFIFOW(28, tn.Count);
								WFIFOW(30, 1);
								WFIFOB(32, 5);
								SendBCmd(tm, tn.Point, 33);
								DamageProcess1(tm, tc1, ts1, dmg[0], tick);
                                                        end;
                                                $F1:    {Bio Cannabalize}

                                                        begin
                                                                if not flag then Break;

                                                                DamageCalc1(tm, tn.CData, ts1, Tick, 0, tn.CData.Skill[232].Data.Data2[tn.MUseLV],tl.Element, tn.CData.Skill[232].Data.Data2[tn.MUseLV]);

                                                                if dmg[0] < 0 then dmg[0] := 0; //Negative Damage
                                                                tn.CData.MSkill := 137;
																																SendCSkillAtk1(tm, tn.CData, ts1, Tick, dmg[0], 1, 6);
                                                                if not DamageProcess1(tm, tn.CData, ts1, dmg[0], Tick) then StatCalc1(tn.CData, ts1, Tick);
                                                        end;
                                                {//$a0:    {Eternal Chaos
                                                        begin
                                                                if not flag then Break;

                                                                ts1.DEF1 := 0;
                                                                ts1.DEF2 := 0;

                                                        end;}

				    	end; //case
				end;
		      end;
		end;
	end;
	Result := k;
end;
//------------------------------------------------------------------------------










//------------------------------------------------------------------------------
procedure TfrmMain.MobAI(tm:TMap; ts:TMob; Tick:Cardinal);
var
	j,i1,j1,k1:integer;
	tc1:TChara;
	ts2:TMob;
	tn:TNPC;
	sl:TStringList;
begin
	sl := TStringList.Create;
	with ts do begin
		if (ts.Stat1 <> 0) and (Data.Range1 > 0) then begin
			pcnt := 0;
			Exit;
		end;

		{if (isLeader) and ( (MonsterMob) or ((isSummon) and (SummonMonsterMob)) )then begin
			if SlaveCount = 0 then begin
				if (Random(1000) <= 10) then begin
					WFIFOW( 0, $011a);
					WFIFOW( 2, 196);
						WFIFOW( 4, 1);
					WFIFOL( 6, ID);
					WFIFOL(10, ID);
					WFIFOB(14, 1);
					SendBCmd(tm, ts.Point, 15);
					MobSpawn(tm,ts,Tick);
				end;
			end;
		end;}


		if Status = 'RUN' then begin
			ts.ATarget := 0;
			ts.tgtPoint.X := ts.Point.X + Random(10);
			ts.tgtPoint.Y := ts.Point.Y + Random(10);
		end;

		if (ATarget = 0) then begin
			//if Data.isActive then begin

			if (isActive) and (ts.Status <> 'RUN') then begin

				sl.Clear;
				for j1 := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
					for i1 := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
						for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
							tc1 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
							if (tc1.HP > 0) and (tc1.Sit <> 1) and (tc1.Option and 64 = 0) and ((tc1.Option and 6 = 0) or ((tc1.Option and 6 <> 0) and (ts.Data.Race = 6) or (ts.Data.Race = 4) or (ts.Data.MEXP <> 0))) and (tc1.Paradise = false) and ((ts.isGuardian <> tc1.GUildID) or (ts.isGuardian = 0)) and (abs(ts.Point.X - tc1.Point.X) <= 10) and (abs(ts.Point.Y - tc1.Point.Y) <= 10) then begin
								{ Alex: Very complex. Monster searching for target. Checks for attack range over cliffs or sight range over regular terrain. }
								if ( (Path_Finding(ts.path, tm, ts.Point.X, ts.Point.Y, tc1.Point.X, tc1.Point.Y, 2) <> 0) and (abs(ts.Point.X - tc1.Point.X) <= ts.Data.Range1) and (abs(ts.Point.Y - tc1.Point.Y) <= ts.Data.Range1) and (ts.Data.Range1 >= MONSTER_ATK_RANGE) ) or
								 ( (Path_Finding(ts.path, tm, ts.Point.X, ts.Point.Y, tc1.Point.X, tc1.Point.Y, 1) <> 0) and (abs(ts.Point.X - tc1.Point.X) <= ts.Data.Range2) and (abs(ts.Point.Y - tc1.Point.Y) <= ts.Data.Range2) ) then begin
									sl.AddObject(IntToStr(tc1.ID), tc1);
								end;
							end;
						end;
					end;
				end;

				if sl.Count <> 0 then begin
					//éãäEì‡ÇÃíNÇ©Ç…É^Å[ÉQÉbÉgÇíËÇﬂÇÈ
					j := Random(sl.Count);
					ATarget := StrToInt(sl.Strings[j]);
					ARangeFlag := false;
					AData := sl.Objects[j];
					ATick := Tick;
					ARangeFlag := false;
					Exit;
				end;
			end;

			if (not isLooting) and Data.isLoot then begin
				//ÉãÅ[ÉgÉÇÉìÉX
				sl.Clear;

				//ÉAÉCÉeÉÄíTÇµ
				for j1 := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
					for i1 := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
						for k1 := 0 to tm.Block[i1][j1].NPC.Count - 1 do begin
							tn := tm.Block[i1][j1].NPC.Objects[k1] as TNPC;
							if tn.CType <> 3 then Continue;
							if (abs(tn.Point.X - Point.X) <= 10) and (abs(tn.Point.Y - Point.Y) <= 10) then begin
								sl.AddObject(IntToStr(tn.ID), tn);
							end;
						end;
					end;
				end;

				if sl.Count <> 0 then begin
					j := Random(sl.Count);
					tn := sl.Objects[j] as TNPC;

					{ Alex: Monster searching for loot - Must block cliffs and walls - Type 1 }
					j := Path_Finding(path, tm, Point.X, Point.Y, tn.Point.X, tn.Point.Y, 1);
					if (j <> 0) then begin
						if ts.Item[10].ID = 0 then begin
							isLooting := True;
							Status := 'MOVEITEM_ST';
							CalculateSkillIf(tm, ts, Tick);
							ATarget := tn.ID;
							ATick := Tick;

							pcnt := j;
							ppos := 0;
							MoveTick := Tick;
							tgtPoint := tn.Point;
						end;
					end;
					Exit;
				end;
			end;
		end

		else begin
			if (isLeader) and (isLooting = false) then begin
				for j1 := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
					for i1 := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
						for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
							if (tm.Block[i1][j1].Mob.Objects[k1] is TMob) then begin
								ts2 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
								if (ts2 <> nil) or (ts2 <> ts) then begin
									if ts2.LeaderID <> ts.ID then continue;
									if (abs(ts.Point.X - ts2.Point.X) <= 10) and (abs(ts.Point.Y - ts2.Point.Y) <= 10) then begin
										if ts2.ATarget = 0 then begin
											ts2.ATarget := ts.ATarget;
											ts2.ARangeFlag := false;
											ts2.AData := ts.AData;
											ts2.ATick := Tick;
											ts2.ARangeFlag := false;
										end;
									end;
								end;
							end;
						end;
					end;
				end;
			end;

			if Data.isLink and (not isLooting) then begin
				for j1 := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
					for i1 := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
						for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
							ts2 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
							if (ts2 <> nil) or (ts2 <> ts) then begin
								if ts2.JID <> ts.JID then continue;
								if (abs(ts.Point.X - ts2.Point.X) <= 10) and (abs(ts.Point.Y - ts2.Point.Y) <= 10) then begin
									if ts2.ATarget = 0 then begin
										ts2.ATarget := ts.ATarget;
										ts2.ARangeFlag := false;
										ts2.AData := ts.AData;
										ts2.ATick := Tick;
										ts2.ARangeFlag := false;
									end;
								end;
							end;
						end;
					end;
				end;
			end;
		end;

	sl.Free;
	end;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.MobMoveL(tm:TMap; Tick:Cardinal);
var
	i,j,a,c:integer;
	xy:TPoint;
	ts:TMob;
//	ts2:TMob;
begin
	//à⁄ìÆèàóù
	for j := 0 to tm.BlockSize.Y - 1 do begin
		for i := 0 to tm.BlockSize.X - 1 do begin
			//if not Block[i][j].MobProcess then begin
			if tm.Block[i][j].MobProcTick < Tick then begin
				//for a := 0 to Block[i][j].Mob.Count - 1 do begin
				a := 0;
				while (a >= 0) and (a < tm.Block[i][j].Mob.Count) do begin
					try
						ts := tm.Block[i][j].Mob.Objects[a] as TMob;
					except
						Exit;
					end;
					with ts do begin
						if (Data.isDontMove) or (HP = 0) or (ts.Stat1 <> 0) or (ts.AnkleSnareTick > Tick) then begin
							Inc(a);
							continue;
						end;
						ATarget := 0; //030317 çUåÇëŒè€Ç™ÇªÇŒÇ…Ç¢Ç»Ç¢ÇÃÇ≈âèú(ñ≥ë Ç…ifégÇÌÇ»Ç¢ï˚Ç™èàóùÇ™ëÅÇ¢)
						ARangeFlag := false;
						if pcnt <> 0 then begin
							//ëOÇÃà⁄ìÆèàóùÇ™écÇ¡ÇƒÇ¢ÇÈÇ∆Ç´
							//ÉuÉçÉbÉNà⁄ìÆ
							if (tgtPoint.X div 8 <> Point.X div 8) or (tgtPoint.Y div 8 <> Point.Y div 8) then begin
								c := tm.Block[Point.X div 8][Point.Y div 8].Mob.IndexOf(ID);
								Assert(c <> -1, Format('MobBlockDelete3 %d (%d,%d)',[c,Point.X,Point.Y]));
								tm.Block[Point.X div 8][Point.Y div 8].Mob.Delete(c);
								//êVÇµÇ¢ÉuÉçÉbÉNÇ…ÉfÅ[É^í«â¡
								tm.Block[tgtPoint.X div 8][tgtPoint.Y div 8].Mob.AddObject(ID, ts);
							end;
							Point := tgtPoint;
							pcnt := 0;
							MoveWait := Tick + 5000 + Cardinal(Random(5000));
						end else begin
							//à⁄ìÆÇµÇƒÇ»Ç¢Ç∆Ç´
							if MoveWait < Tick then begin
								//à⁄ìÆäJén
								//AMode := 0;
								c := 0;
								repeat
									//repeat
										xy.X := Random(17) - 8; //à⁄ìÆîÕàÕÇÕç≈ëÂ8É}ÉX
										xy.Y := Random(17) - 8; //Å™(2ÉuÉçÉbÉNà»è„à⁄ìÆÇµÇ»Ç¢ÇÊÇ§Ç…)
										//until (abs(xy.X) > 2) and (abs(xy.Y) > 2);
										xy.X := xy.X + Point.X;
										xy.Y := xy.Y + Point.Y;
										//030316-2 ñºñ≥ÇµÇ≥ÇÒ/030317
										if (xy.X < 0) or (xy.X > tm.Size.X - 2) or (xy.Y < 0) or (xy.Y > tm.Size.Y - 2) then begin
											//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('***RandomRoute Error!! (%d,%d) %dx%d', [xy.X,xy.Y,tm.Size.X,tm.Size.Y]));
											if xy.X < 0 then xy.X := 0;
											if xy.X > tm.Size.X - 2 then xy.X := tm.Size.X - 2;
											if xy.Y < 0 then xy.Y := 0;
											if xy.Y > tm.Size.Y - 2 then xy.Y := tm.Size.Y - 2;
										end;
										//---
										Inc(c);
									until ( ((tm.gat[xy.X][xy.Y] <> 1) and (tm.gat[xy.X][xy.Y] <> 5)) or (c = 100) );
									if c <> 100 then begin
										//ÉuÉçÉbÉNà⁄ìÆ
										if (xy.X div 8 <> Point.X div 8) or (xy.Y div 8 <> Point.Y div 8) then begin
											//à»ëOÇÃÉuÉçÉbÉNÇÃÉfÅ[É^è¡ãé
											//with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
											//	Delete(IndexOf(IntToStr(ID)));
											//end;
											c := tm.Block[Point.X div 8][Point.Y div 8].Mob.IndexOf(ID);
											//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'MobBlockDelete2 ' + Inttostr(c));
											if c <> -1 then begin
												tm.Block[Point.X div 8][Point.Y div 8].Mob.Delete(c);
												Dec(a);
											end else begin
												//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('MobBlockDelete2 %d (%d,%d)',[c,Point.X,Point.Y]));
										end;
										//êVÇµÇ¢ÉuÉçÉbÉNÇ…ÉfÅ[É^í«â¡
										tm.Block[xy.X div 8][xy.Y div 8].Mob.AddObject(ID, ts);
									end;
									Point.X := xy.X;
									Point.Y := xy.Y;
								end;
								MoveWait := Tick + 5000 + Cardinal(Random(5000));
							end;
						end;
					end;
					Inc(a);
				end;
				//tm.Block[a][b].MobProcess := true;
				//tm.Block[i][j].MobProcTick := Tick;
			end;
		end;
	end;
end;
//------------------------------------------------------------------------------
function TfrmMain.MobMoving(tm:TMap; ts:TMob; Tick:Cardinal) : Integer;
var
//	i : Integer;
	j : Integer;
	k : Integer;
	m : Integer;
	n : Integer;
	c : Integer;
	tc1:TChara;
	tn:TNPC;
	spd:cardinal;
	xy:TPoint;
	dx,dy:integer;
//	ts1:TMob;

begin

	k := 0;
	with ts do begin
		ts.Status := 'RMOVE_ST';
		CalculateSkillIf(tm, ts, Tick);
		//if (tm.gat[ts.Point.X][ts.Point.Y] <> 0) then continue;
		if (path[ppos] and 1) = 0 then begin
			spd := Speed;
		end else begin
			spd := Speed * 140 div 100; //éŒÇﬂÇÕ1.4î{éûä‘Ç™Ç©Ç©ÇÈ
		end;
		for j := 1 to (Tick - MoveTick) div spd do begin
			xy := Point;
			Dir := path[ppos];
			case Dir of
				0: begin               Inc(Point.Y); dx :=  0; dy :=  1; end;
				1: begin Dec(Point.X); Inc(Point.Y); dx := -1; dy :=  1; end;
				2: begin Dec(Point.X);               dx := -1; dy :=  0; end;
				3: begin Dec(Point.X); Dec(Point.Y); dx := -1; dy := -1; end;
				4: begin               Dec(Point.Y); dx :=  0; dy := -1; end;
				5: begin Inc(Point.X); Dec(Point.Y); dx :=  1; dy := -1; end;
				6: begin Inc(Point.X);               dx :=  1; dy :=  0; end;
				7: begin Inc(Point.X); Inc(Point.Y); dx :=  1; dy :=  1; end;
				else
					begin              {HeadDir := 0;} dx :=  0; dy :=  0; end; //ñ{óàÇÕãNÇ±ÇÈÇÕÇ∏Ç™Ç»Ç¢
			end;
			Inc(ppos);
			//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('	 Mob-Move %d/%d (%d,%d) %d %d %d', [ppos, pcnt, Point.X, Point.Y, path[ppos-1], spd, Tick]));

			//ÉuÉçÉbÉNèàóù
			{ Alex: Don't know what this is for but tested fine w/o it. Performance increase. }
			for n := xy.Y div 8 - 2 to xy.Y div 8 + 2 do begin
				for m := xy.X div 8 - 2 to xy.X div 8 + 2 do begin

					//ÉvÉåÉCÉÑÅ[Ç…í ím
					for c := 0 to tm.Block[m][n].CList.Count - 1 do begin
						tc1 := tm.Block[m][n].CList.Objects[c] as TChara;
						if tc1 = nil then continue;
						if ((dx <> 0) and (abs(xy.Y - tc1.Point.Y) < 16) and (xy.X = tc1.Point.X + dx * 15)) or
						 ((dy <> 0) and (abs(xy.X - tc1.Point.X) < 16) and (xy.Y = tc1.Point.Y + dy * 15)) then begin
							//è¡ñ≈í ím
							WFIFOW(0, $0080);
							WFIFOL(2, ts.ID);
							WFIFOB(6, 0);
							tc1.Socket.SendBuf(buf, 7);
						end;
						if ((dx <> 0) and (abs(Point.Y - tc1.Point.Y) < 16) and (Point.X = tc1.Point.X - dx * 15)) or
						((dy <> 0) and (abs(Point.X - tc1.Point.X) < 16) and (Point.Y = tc1.Point.Y - dy * 15)) then begin
							//Send Monster Data Packet
							SendMData(tc1.Socket, ts);
							//Send Monster Move Packet
							if (abs(Point.X - tc1.Point.X) < 16) and (abs(Point.Y - tc1.Point.Y) < 16) then SendMMove(tc1.Socket, ts, Point, tgtPoint, tc1.ver2);

						end;
					end;
				end;
			end;

			//ÉuÉçÉbÉNà⁄ìÆ
			if (xy.X div 8 <> Point.X div 8) or (xy.Y div 8 <> Point.Y div 8) then begin
				//à»ëOÇÃÉuÉçÉbÉNÇÃÉfÅ[É^è¡ãé
				//with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
				//	Delete(IndexOf(IntToStr(ID)));
				//end;
				c := tm.Block[xy.X div 8][xy.Y div 8].Mob.IndexOf(ID);
				if c <> -1 then begin
					tm.Block[xy.X div 8][xy.Y div 8].Mob.Delete(c);
					Dec(k);
				end else begin
					//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('MobBlockDelete %d (%d,%d)',[c,xy.X,xy.Y]));
				end;
				//êVÇµÇ¢ÉuÉçÉbÉNÇ…ÉfÅ[É^í«â¡
				tm.Block[Point.X div 8][Point.Y div 8].Mob.AddObject(ID, ts);
			end;

			if (ATarget <> 0) then begin
				if isLooting then begin
					tn := tm.NPC.IndexOfObject(ts.ATarget) as TNPC;
					if tn = nil then begin
						UpdateMonsterLocation(tm, ts);

						isLooting := False;
						ATarget := 0;
						ppos := pcnt;
						MoveWait := Tick + Data.dMotion;
					end else if (abs(ts.Point.X - tn.Point.X) <2) and (abs(ts.Point.Y - tn.Point.Y) <2) then begin
						tgtPoint := Point;
						ppos := pcnt;
						ATick := Tick + Speed;
					end;
				end else begin
					tc1 := AData;
					if (abs(ts.Point.X - tc1.Point.X) > 13) or (abs(ts.Point.Y - tc1.Point.Y) > 13) and (ts.isSlave = false) then begin
						//éãäEÇÃÇªÇ∆Ç‹Ç≈ì¶Ç∞ÇÁÇÍÇΩ
						UpdateMonsterLocation(tm, ts);

						ATarget := 0;
						ARangeFlag := false;
						MoveWait := Tick + 5000;
					end else if (abs(Point.X - tc1.Point.X) <= Data.Range1) and (abs(Point.Y - tc1.Point.Y) <= Data.Range1) then begin
						//éÀíˆì‡Ç‹Ç≈í«Ç¢Ç¬Ç¢ÇΩ
						tgtPoint := Point;
						ppos := pcnt;
						ATick := Tick;
					end;
				end;
			end;

			if ppos = pcnt then begin
				//à⁄ìÆäÆóπ
				pcnt := 0;
				if ATarget = 0 then begin
					MoveWait := Tick + 5000;
				end else begin
					MoveWait := Tick;
				end;
				ATick := Tick - Data.ADelay;
				//ÉpÉPëóêM(ã|çUåÇÇ≈ÇÃà íuÇ∏ÇÍëŒç
				UpdateMonsterLocation(tm, ts);

				break;
			end;
			MoveTick := MoveTick + spd;
		end;
	end;
	Result := k;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.MobAttack(tm:TMap;ts:TMob;Tick:cardinal);
var
	j   : Integer;
	c   : Integer;
	tc1 : TChara;
	tc2 : TChara;
	xy  : TPoint;
begin
	with ts do begin
		tc2 := nil;
		tc1 := AData;
		if tc1.GraceTick > Tick then exit;

		if (tc1.Skill[255].Tick > Tick) and (assigned(tc1.Crusader)) then begin
			tc2 := tc1.Crusader;
			if (tc2.Login <> 2) and (tc1 <> tc2) then begin
				tc2 := nil;
				tc1.Skill[255].Tick := Tick;
			end;
		end;

    ts.Status := 'RUSH_ST';

		if ( (tc1.Sit = 1) or (tc1.Login <> 2) or (tc1.Option and 64 <> 0) or ((tc1.Option and 6 <> 0) and ((ts.Data.Race <> 4) and (ts.Data.Race <> 6) and (ts.Data.MEXP = 0))) ) and (ts.isLooting = false) then begin
		{ Stops attack if target is dead, not logged in, or hidden }
			ATarget := 0;
			ARangeFlag := false;
		end

		else if (abs(ts.Point.X - tc1.Point.X) <= ts.Data.Range1) and (abs(ts.Point.Y - tc1.Point.Y) <= ts.Data.Range1) then begin
		{ Attacks if monster and player are within attack range of each other }

			if (ATick + Data.ADelay < Tick) then begin
				ATick := Tick - Data.ADelay;
			end;

			if ATick + Data.ADelay <= Tick then begin
				UpdateMonsterLocation(tm, ts);

				for j := 1 to (Tick - ATick) div Data.ADelay do begin
					if tc1.Skill[255].Tick > Tick then begin
						DamageCalc2(tm, tc1, ts, Tick);
            SendMAttack(tm, ts, tc2, dmg[0], dmg[4], dmg[5], Tick);
            {
						WFIFOW( 0, $008a);
						WFIFOL( 2, ID);
						WFIFOL( 6, tc2.ID);
						WFIFOL(10, timeGetTime());
						WFIFOL(14, ts.Data.aMotion);
						WFIFOL(18, tc2.dMotion);
						WFIFOW(22, dmg[0]);
						WFIFOW(24, dmg[4]);


						// 4->9 for Endure damage, allow lucky hit gfx
						if ((tc2.dMotion = 0) and (dmg[5] <> 11)) then dmg[5] := 9;

						WFIFOB(26, dmg[5]);
						WFIFOW(27, 0);
						SendBCmd(tm, tc2.Point, 29);
            }

						if (dmg[0] <> 0) and (tc2.pcnt <> 0) and (tc2.dMotion <> 0) then begin
							tc2.Sit := 3;
							tc2.HPTick := Tick;
							tc2.HPRTick := Tick - 500;
							tc2.SPRTick := Tick;
							tc2.pcnt := 0;
							UpdatePlayerLocation(tm, tc2);

							// Colus, 20040129: Reset Lex Aeterna here
							tc2.Skill[78].Tick := 0;
						end;

						if ts.Data.MEXP <> 0 then begin
							for c := 0 to 31 do begin
								if (ts.MVPDist[c].CData = nil) or (ts.MVPDist[c].CData = tc2) then begin
									ts.MVPDist[c].CData := tc2;
									Inc(ts.MVPDist[c].Dmg, dmg[0]);
									break;
								end;
							end;
						end;

						if tc2.HP > dmg[0] then begin
							{ Player has more HP than damage done to him or her }
							tc2.HP := tc2.HP - dmg[0];
							if dmg[0] <> 0 then begin
								tc2.DmgTick := Tick + tc2.dMotion div 2;
							end;

			    	if (tc2.Option and 2 <> 0) then begin
                tc2.SkillTick := Tick;
                tc2.SkillTickID := 51;
                tc2.Skill[tc2.SkillTickID].Tick := Tick;
              end;
                if (tc2.Option and 4 <> 0) then begin
                  tc2.SkillTick := Tick;
                  tc2.SkillTickID := 135;
                  tc2.Skill[tc2.SkillTickID].Tick := Tick;
                end;
						end

						else begin
							{ Player has run out of HP and dies }
              //Simplified into a procedure
              CharaDie(tm, tc2, Tick);
              ATarget := 0;
							ARangeFlag := false;

							{tc2.HP := 0;
							WFIFOW( 0, $0080);
							WFIFOL( 2, tc2.ID);
							WFIFOB( 6, 1);
							SendBCmd(tm, tc2.Point, 7);
							tc2.Sit := 1;

							i := (100 - DeathBaseLoss);
							tc2.BaseEXP := Round(tc2.BaseEXP * (i / 100));
							i := (100 - DeathJobLoss);
							tc2.JobEXP := Round(tc2.JobEXP * (i / 100));

							SendCStat1(tc2, 1, $0001, tc2.BaseEXP);
							SendCStat1(tc2, 1, $0002, tc2.JobEXP);

							tc2.pcnt := 0;
							if (tc2.AMode = 1) or (tc2.AMode = 2) then tc2.AMode := 0;
							ATarget := 0;
							ARangeFlag := false;
      				if (tc2.Option and 2 <> 0) then begin
                tc2.SkillTick := Tick;
                tc2.SkillTickID := 51;
                tc2.Skill[tc2.SkillTickID].Tick := Tick;
              end;
                if (tc2.Option and 4 <> 0) then begin
                  tc2.SkillTick := Tick;
                  tc2.SkillTickID := 135;
                  tc2.Skill[tc2.SkillTickID].Tick := Tick;
                end;}
						end;

						SendCStat1(tc2, 0, 5, tc2.HP);
						ts.ATick := ts.ATick + Cardinal(abs(ts.Data.ADelay));
					end

					else if tc1.Skill[255].Tick <= Tick then begin
						DamageCalc2(tm, tc1, ts, Tick);
						if dmg[0] <= 0 then dmg[0] := 0;

            SendMAttack(tm, ts, tc1, dmg[0], dmg[4], dmg[5], Tick);
						{WFIFOW( 0, $008a);
						WFIFOL( 2, ID);
						WFIFOL( 6, ATarget);
						WFIFOL(10, timeGetTime());
						WFIFOL(14, ts.Data.aMotion);
						WFIFOL(18, tc1.dMotion);
						WFIFOW(22, dmg[0]);
						WFIFOW(24, dmg[4]);
						
						// 4->9 for Endure damage, allow lucky hit gfx						
						if ((tc1.dMotion = 0) and (dmg[5] <> 11)) then dmg[5] := 9;

						WFIFOB(26, dmg[5]);
						WFIFOW(27, 0);
						SendBCmd(tm, tc1.Point, 29);}
						
						if (dmg[0] <> 0) and (tc1.pcnt <> 0) and (tc1.dMotion <> 0) then begin
							tc1.Sit := 3;
							tc1.HPTick := Tick;
							tc1.HPRTick := Tick - 500;
							tc1.SPRTick := Tick;
							tc1.pcnt := 0;
							UpdatePlayerLocation(tm, tc1);
							
							// Colus, 20040129: Reset Lex Aeterna here
							tc1.Skill[78].Tick := 0;
						end;

						if ts.Data.MEXP <> 0 then begin
							for c := 0 to 31 do begin
								if (ts.MVPDist[c].CData = nil) or (ts.MVPDist[c].CData = tc1) then begin
									ts.MVPDist[c].CData := tc1;
									Inc(ts.MVPDist[c].Dmg, dmg[0]);
									break;
								end;
							end;
						end;

						if tc1.HP > dmg[0] then begin
							tc1.HP := tc1.HP - dmg[0];
							if dmg[0] <> 0 then begin
								tc1.DmgTick := Tick + tc1.dMotion div 2;

								{Colus, 20031216: Cancel casting timer on hit. Also, phen card handling.}

								if tc1.NoCastInterrupt = False then begin
									tc1.MMode := 0;
									tc1.MTick := 0;
									WFIFOW(0, $01b9);
									WFIFOL(2, tc1.ID);
									SendBCmd(tm, tc1.Point, 6);
								end;

								{Colus, 20031216: end cast-timer cancel}
                if (tc1.Option and 2 <> 0) then begin
                  tc1.SkillTick := Tick;
                  tc1.SkillTickID := 51;
                  tc1.Skill[tc1.SkillTickID].Tick := Tick;
                end;
                if (tc1.Option and 4 <> 0) then begin
                  tc1.SkillTick := Tick;
                  tc1.SkillTickID := 135;
                  tc1.Skill[tc1.SkillTickID].Tick := Tick;
                end;
							end;
						end

						else begin
              // CharaDie(tm, tc1, Tick, 1);  <- why 1? this is a monster.
              CharaDie(tm, tc1, Tick);
              ATarget := 0;
							ARangeFlag := false;
            {
							tc1.HP := 0;
							WFIFOW( 0, $0080);
							WFIFOL( 2, tc1.ID);
							WFIFOB( 6, 1);
							SendBCmd(tm, tc1.Point, 7);
							tc1.Sit := 1;

							i := (100 - DeathBaseLoss);
							tc1.BaseEXP := Round(tc1.BaseEXP * (i / 100));
							i := (100 - DeathJobLoss);
							tc1.JobEXP := Round(tc1.JobEXP * (i / 100));
							
							SendCStat1(tc1, 1, $0001, tc1.BaseEXP);
							SendCStat1(tc1, 1, $0002, tc1.JobEXP);
							
							tc1.pcnt := 0;
							
							if (tc1.AMode = 1) or (tc1.AMode = 2) then tc1.AMode := 0;
							ATarget := 0;
							ARangeFlag := false;
							if (tc1.Option and 2 <> 0) then begin
                				tc1.SkillTick := Tick;
                				tc1.SkillTickID := 51;
                  tc1.Skill[tc1.SkillTickID].Tick := Tick;
							end;
							if (tc1.Option and 4 <> 0) then begin
                				tc1.SkillTick := Tick;
                				tc1.SkillTickID := 135;
                  tc1.Skill[tc1.SkillTickID].Tick := Tick;
							end;
						}
						end;
						SendCStat1(tc1, 0, 5, tc1.HP);
						ATick := ATick + Data.ADelay;
					end;
				end;
			end;
			
			ARangeFlag := true;
			
		end else if (abs(ts.Point.X - tc1.Point.X) > 20) or (abs(ts.Point.Y - tc1.Point.Y) > 20) then begin
		{ Player is outside monster's range }
			
			UpdateMonsterLocation(tm, ts);
			ATarget := 0;
			if Data.isDontMove then
				MoveWait := $FFFFFFFF
			else
				MoveWait := Tick + 5000;
				
			ATick := Tick - Data.ADelay;
			ARangeFlag := false;

		end else begin
		{ No target }
			
			if Data.isDontMove then begin
				ATick := Tick - Data.ADelay;
			end
				
			else begin
				ARangeFlag := false;
				if (not EnableMonsterKnockBack) or (DmgTick <= Tick) then begin
					pcnt := 0;
					j := 0;
						
					repeat
						xy.X := tc1.Point.X + Random(3) - 1;
						xy.Y := tc1.Point.Y + Random(3) - 1;

						{if xy.X <= 0 then xy.X := 1;
						if xy.X >= tm.Size.X - 1 then xy.X := tm.Size.X - 2;
						if xy.Y <= 0 then xy.Y := 1;
						if xy.Y >= tm.Size.Y - 1 then xy.Y := tm.Size.Y - 2;}
							
						if ( (tm.gat[xy.X][xy.Y] <> 1) and (tm.gat[xy.X][xy.Y] <> 5) ) then break;
						Inc(j);
					until (j = 100);
						
					if j <> 100 then begin
                                                // { Alex: Monster walking towards target. May not walk over cliffs. Type 1. }
                                                //if ( (Path_Finding(path, tm, Point.X, Point.Y, xy.X, xy.Y, 1) <> 0) and (abs(Point.X - xy.X) <= ts.Data.Range2) and (abs(Point.Y - xy.Y) <= ts.Data.Range2) ) then begin
                                                if ( (Path_Finding(path, tm, Point.X, Point.Y, xy.X, xy.Y, 1) <> 0) ) then begin
                                                        pcnt := Path_Finding(path, tm, Point.X, Point.Y, xy.X, xy.Y, 1);
                                                end;

						ts.DeadWait := Tick;
					end;
						
					if pcnt = 0 then begin
						MoveWait := Tick + 5000;
					end
						
					else begin
						ppos := 0;
						MoveTick := Tick;
						tgtPoint := xy;
							
						SendMMove(tc1.Socket, ts, Point, tgtPoint, tc1.ver2);
						if (ts = nil) or (tc1 = nil) then exit;
						SendBCmd(tm, ts.Point, 58, tc1, True);
					end;
				end;
			end;
		end;
	end;
end;
//------------------------------------------------------------------------------
procedure TfrmMain.StatEffect(tm:TMap; ts:TMob; Tick:Cardinal);
var
	sflag:Boolean;
	j,m,n:Word;
begin

	sflag := False;
	if (ts.Stat1 = 0) or (ts.Stat1 <> ts.nStat) then begin
		if (ts.BodyTick <> 0) and (ts.BodyTick < Tick) then begin
			if ts.Stat1 <> 0 then begin
				//âèú
				case ts.Stat1 of
					1,2:
						begin
							ts.Element := ts.Data.Element;
						end;
				end;
			end;
			//àŸèÌî≠ê∂1
			ts.Stat1 := ts.nStat;
			case ts.nStat of
 				1:
					begin
						ts.Element := 22;
					end;
				2:
					begin
						ts.Element := 21;
					end;
			end;
			ts.BodyTick := Tick + 30000; //ìKìñ
			sflag := True;
      ts.pcnt := 0;
		end;
	end else begin
		if ts.BodyTick < Tick then begin
			case ts.Stat1 of
				1,2:
					begin
						ts.Element := ts.Data.Element;
					end;
			end;
			//âèú1
			ts.Stat1 := 0;
			ts.nStat := 0;
			ts.BodyTick := 0;
			ZeroMemory(@buf[0], 60);
			WFIFOW( 0, $007b);
			WFIFOL( 2, ts.ID);
			WFIFOW( 6, ts.Speed);
			WFIFOW( 8, ts.Stat1);
			WFIFOW(10, ts.Stat2);
			WFIFOW(14, ts.JID);
			WFIFOL(22, timeGetTime());
			WFIFOW(36, ts.Dir);
			WFIFOM2(50, ts.Point, ts.Point);
			WFIFOB(56, 5);
			WFIFOB(57, 5);
			SendBCmd(tm,ts.Point,60,nil,True);    // Length 58->60
		end;
	end;
       //wiz skill quagmire duration over, monster resume
      if (ts.EffectTick[1] <= Tick) and (ts.EffectTick[1]<>0) then begin
        ts.EffectTick[1]:=0;
        ts.Speed := ts.Speed div 2;
        ts.Data.Param[1] := ts.Data.Param[1] * 2;
        ts.Data.Param[4] := ts.Data.Param[4] * 2;
			  ZeroMemory(@buf[0], 60);
			  WFIFOW( 0, $007b);
			  WFIFOL( 2, ts.ID);
			  WFIFOW( 6, ts.Speed);
			  WFIFOW( 8, ts.Stat1);
			  WFIFOW(10, ts.Stat2);
			  WFIFOW(14, ts.JID);
			  WFIFOL(22, timeGetTime());
			  WFIFOW(36, ts.Dir);
			  WFIFOM2(50, ts.Point, ts.Point);
			  WFIFOB(56, 5);
			  WFIFOB(57, 5);
			  SendBCmd(tm,ts.Point,60,nil,True);    // Length 58->60
      end;
	//èÛë‘ïœâª2
	m := 0;
	for n:= 0 to 4 do begin
		j := 1 shl n;
		if (ts.Stat2 and j) = 0 then begin
			if (ts.HealthTick[n] <> 0) and (ts.HealthTick[n] < Tick) then begin
				//àŸèÌî≠ê∂2
				ts.Stat2 := ts.Stat2 or j;
				ts.HealthTick[n] := Tick + 30000; //ìKìñ
				sflag := True;
				m := m or j;
			end;
		end else if ts.HealthTick[n] < Tick then begin
			//âèú
			ts.Stat2 := ts.Stat2 and (not j);
			ts.HealthTick[n] := 0;
			sflag := True;
		end;
	end;
	if ( (sflag) and (ts.Data.MEXP = 0) ) then begin
		WFIFOW(0, $0119);
		WFIFOL(2, ts.ID);
		WFIFOW(6, ts.nStat);
		WFIFOW(8, m);
		WFIFOW(10, 0);
		WFIFOB(12, 0);
		SendBCmd(tm, ts.Point, 13);
    UpdateMonsterLocation(tm, ts);
	end;
end;
//------------------------------------------------------------------------------









//------------------------------------------------------------------------------
{í«â¡}
procedure AutoAction(tc:TChara; Tick:Cardinal);
var
	i1,j1,k1,i,j,k:Integer;
	ts:TMob;
	ts1:TMob;
	tm:TMap;
	tn:TNPC;
	tn1:TNPC;
	tl:TSkillDB;
	sl:TStringList;
	xy:TPoint;
	X,Y,Z:Cardinal;
	label Looting;
begin
	ts := nil;
	tm := tc.MData;

        { Alex: reverting to 007d requires a weapon sprite fix. }
    	if (tc.Shield <> 0) then begin
        	UpdateLook(tc.MData, tc, 2, tc.WeaponSprite[0], tc.Shield);
		end else begin
			UpdateLook(tc.MData, tc, 2, tc.WeaponSprite[0], tc.WeaponSprite[1]);
		end;

	with tc do begin
		if ((ATarget <> 0) or (MMode <> 0)) then begin
			ts := AData;
			//éÄÇÒÇ≈Ç¢ÇÈ,éãäEÇÃäOÇ…ãèÇÈ
			if (ts.HP = 0) or (abs(Point.X - ts.Point.X) > 15) or (abs(Point.Y - ts.Point.Y) > 15) then begin
				MMode := 0;
				MTarget := 0;
				MPoint.X := 0;
				MPoint.Y := 0;
				AMode := 0;
				ATarget := 0;
				AData := nil;
			end;
		end;//if ((ATarget...
		if MMode <> 0 then Exit; //ârè•íÜÇÕçsìÆÇ≈Ç´Ç»Ç¢
		if ((auto and $02) = $02) and (A_Skill <> 0) and (SP > Skill[A_Skill].Data.SP[A_Lv]) then begin
			tl := Skill[A_Skill].Data;
			if tl.SP[A_Lv] > SP then begin
				Sit := 2;
				WFIFOW(0, $008a);
				WFIFOL(2, tc.ID);
				WFIFOB(26, 2);
				SendBCmd(tm, Point, 29);
				Exit;//safe 2004/04/27
			end;
			if (MMode = 0) and (MPoint.X = 0) and (MPoint.Y = 0) then begin
				sl := TStringList.Create;
				for j1 := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
					for i1 := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
						for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
							ts := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
							if ts.HP = 0 then Continue;
							if (abs(ts.Point.X - Point.X) <= 15) and (abs(ts.Point.Y - Point.Y) <= 15) then begin
								//éãäEì‡Ç…Ç¢ÇƒéÄÇÒÇ≈Ç»Ç¢
								sl.AddObject(IntToStr(ts.ID), ts);
							end;
						end;
					end;
				end;
				ts := nil;
				if sl.Count > 0 then begin
					j := 20;
					for i := 0 to sl.Count -1 do begin
						ts1 := sl.Objects[i] as TMob;
						X := abs(ts1.Point.X - Point.X);
						Y := abs(ts1.Point.Y - Point.Y);
						if (X + Y) < Cardinal(j) then begin //ãóó£Ç™àÍî‘ãﬂÇ¢
//2
							{ Alex: Currently Unexplored - Type 1 for safety }
							k := Path_Finding(tc.path, tm, Point.X, Point.Y, ts1.Point.X, ts1.Point.Y, 1);
							//íHÇËíÖÇØÇ∏éÀíˆäOÇ»ÇÁñ≥éã
							if (k = 0) and ((X > tl.Range) or (Y > tl.Range)) then Continue;
							j := X + Y;
							ts := ts1;
						end;
					end;
				end;//if sl.Count...
				sl.Free;//safe 2004/04/27
			end;//if (MMod=0...

			if ts = nil then begin
				//å©Ç¬Ç©ÇÁÇ»Ç©Ç¡ÇΩ
				MMode := 0;
				MTarget := 0;
				MPoint.X := 0;
				MPoint.Y := 0;
			end else begin
				if (abs(Point.X - ts.Point.X) > tl.Range) or (abs(Point.Y - ts.Point.Y) > tl.Range) then begin
					NextFlag := True;
					NextPoint := ts.Point;
				end else begin
					//çUåÇâ¬î\
					NextFlag := False;
					Sit := 3;
					pcnt := 0;
					UpdatePlayerLocation(tm, tc);
					MUseLV := A_Lv;
					MSkill := A_Skill;
					k := 0;
					if tl.SType = 1 then begin
						//É^ÉQå^
						MMode := 1;
						MTarget := ts.ID;
						AData := ts;
						MPoint.X := 0;
						MPoint.Y := 0;
						k := UseTargetSkill(tc,Tick);
					end else if tl.SType = 2 then begin
						//èÍèäå^
						MMode := 2;
						MTarget := 0;
						MPoint.X := ts.Point.X;
						MPoint.Y := ts.Point.Y;
						k := UseFieldSkill(tc,Tick);
					end;
					if k <> 0 then begin //ÉGÉâÅ[Ç™èoÇΩÇÁçsìÆí‚é~
						SendSkillError(tc,k);
						Auto := Auto xor 2;
					end;
					ActTick := MTick + ADelay; //ÉXÉLÉãÉfÉBÉåÉCÇ™Ç¢Ç‹Ç¢ÇøâÇÁÇ»Ç¢ÇÃÇ≈
					Exit;//safe 2004/04/27
				end;//if-else
			end;//if-else ts=nil...
		end else if (auto and $01) = $01 then begin

			if (AMode = 0) and (ATarget = 0) then begin
				//É^ÉQíTÇµ
				sl := TStringList.Create;
				for j1 := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
					for i1 := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
						for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
							ts := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
							if ts.HP = 0 then Continue;
							if (abs(ts.Point.X - Point.X) <= 15) and (abs(ts.Point.Y - Point.Y) <= 15) then begin
								//éãäEì‡Ç…Ç¢ÇƒéÄÇÒÇ≈Ç»Ç¢
								sl.AddObject(IntToStr(ts.ID), ts);
							end;
						end;//for k1
					end;//for i1
				end;//for j1
				ts := nil;
				if sl.Count > 0 then begin
					Z := 20;
					for i := 0 to sl.Count -1 do begin
						ts1 := sl.Objects[i] as TMob;
						X := abs(ts1.Point.X - Point.X);
						Y := abs(ts1.Point.Y - Point.Y);
						if (X + Y) < Z then begin //ãóó£Ç™àÍî‘ãﬂÇ¢
							{ Alex: Currently Unexplored - Type 1 for safety }
							k := Path_Finding(tc.path, tm, Point.X, Point.Y, ts1.Point.X, ts1.Point.Y, 1);
							//íHÇËíÖÇØÇ∏éÀíˆäOÇ»ÇÁñ≥éã
							if (k = 0) and ((X > Range) or (Y > Range)) then Continue;
							Z := X + Y;
							ts := ts1;
						end;
					end;
				end;
				sl.Free;//safe 2004/04/27
			end;

			if ts = nil then begin
				//É^ÉQÇ™å©Ç¬Ç©ÇÁÇ»Ç©Ç¡ÇΩ
				AMode := 0;
				ATarget := 0;
			end else begin
				if (abs(Point.X - ts.Point.X) > Range) or (abs(Point.Y - ts.Point.Y) > Range) then begin
					//éÀíˆäOÇ»ÇÁí«ê’
					NextFlag := True;
					NextPoint := ts.Point;
					ActTick := Tick + Speed div 2;
					if ts.ID <> ATarget then begin
						WFIFOW( 0, $0139);
						WFIFOL( 2, ts.ID);
						WFIFOW( 6, ts.Point.X);
						WFIFOW( 8, ts.Point.Y);
						WFIFOW(10, tc.Point.X);
						WFIFOW(12, tc.Point.Y);
						WFIFOW(14, tc.Range); //éÀíˆ
						Socket.SendBuf(buf, 16);
					end;
				end else begin
					//çUåÇâ¬î\
					Sit := 3;
					NextFlag := False;
					AMode := 2;
					if ATarget <> ts.ID then begin
						ATarget := ts.ID;
						AData := ts;
						if ATick + (tc.ADelay - 200) < Tick then
							ATick := Tick - ADelay + 200;
					end;
					ActTick := Tick + 200 - ADelay + aMotion;
					Exit;//safe 2004/04/27
				end;
			end;
		end;
		if ((Auto and $04) = $04) and (ATarget = 0) and (MMode = 0) then begin //ÉãÅ[Ég
			//ÉAÉCÉeÉÄíTÇµ
			sl := TStringList.Create;
			for j1 := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
				for i1 := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
					for k1 := 0 to tm.Block[i1][j1].NPC.Count - 1 do begin
						tn := tm.Block[i1][j1].NPC.Objects[k1] as TNPC;
						if tn.CType <> 3 then Continue;
						if (abs(tn.Point.X - Point.X) <= 15) and (abs(tn.Point.Y - Point.Y) <= 15) then begin
							//åÛï‚Ç…í«â¡
							sl.AddObject(IntToStr(tn.ID), tn);
						end;
					end;
				end;
			end;
			tn := nil;
			if sl.Count <> 0 then begin
				//àÍî‘ãﬂÇ¢Ç‡ÇÃÇ
				j := 20;
				for i := 0 to sl.Count -1 do begin
					tn1 := sl.Objects[i] as TNPC;
					X := abs(tn1.Point.X - Point.X);
					Y := abs(tn1.Point.Y - Point.Y);
					if (X + Y) < Cardinal(j) then begin
						{ Alex: Currently Unexplored - Type 1 for safety }
						k := Path_Finding(tc.path, tm, Point.X, Point.Y, tn1.Point.X, tn1.Point.Y, 1);
						if (k = 0) and ((X > 1) or (Y > 1)) then Continue;
						j := X + Y;
						tn := tn1;
					end;
				end;
			end;
			sl.Free;//safe
			if tn = nil then begin
				//é¸ÇËÇ…âΩÇ‡ñ≥Çµ
			end else begin
				if (abs(Point.X - tn.Point.X) > 1) or (abs(Point.Y - tn.Point.Y) > 1) then begin
					NextFlag := True;
					NextPoint := tn.Point;
				end else begin
					if ATick < Tick then begin
						UpdatePlayerLocation(tm, tc);
						PickUpItem(tc,tn.ID);
						ActTick := Tick + 200;
					end;
				end;
				Exit;//safe 2004/04/27
			end;
		end;
		if ((auto and $10) = $10) and (Sit = 3) and (ATarget = 0) and (MMode = 0) then begin
			//ÉtÉâÉtÉâìKìñÇ…à⁄ìÆ
			j := 0;
			i := 0;
			repeat
				k := 0;
				repeat
					xy.X := Point.X + Random(17) - 8; //à⁄ìÆîÕàÕÇÕç≈ëÂ8É}ÉX
					xy.Y := Point.Y + Random(17) - 8; //Å™(2ÉuÉçÉbÉNà»è„à⁄ìÆÇµÇ»Ç¢ÇÊÇ§Ç…)
					Inc(k);
				until ((xy.X >= 0) and (xy.X <= tm.Size.X - 2) and (xy.Y >= 0) and (xy.Y <= tm.Size.Y - 2)) or (k = 100);
				if k = 100 then begin
					//à⁄ìÆâ¬î\â”èäÇ™Ç»Ç¢orè≠Ç»Ç∑Ç¨ÇÈÇ∆Ç´ÇÕà⁄ìÆÇµÇ»Ç¢
					j := 100;
					break;
				end;
				//---
				if ( (tm.gat[xy.X][xy.Y] <> 1) and (tm.gat[xy.X][xy.Y] <> 5) ) then begin
					//pcnt := SearchPath(path, tm, Point, xy);
					{ Alex: Currently Unexplored - Type 1 for safety }
					i := Path_Finding(path, tm, Point.X, Point.Y, xy.X, xy.Y, 1);
				end;
				{ChrstphrR 2004/04/27 with that pcnt := ... line commented out, the code
				looked confusing, so I encluded the begin-end pair to show what it IS
				branching and executing -- only needs correction if this branch is
				unintended.}

				Inc(j);
			until (i <> 0) or (j = 100);
			if j <> 100 then begin
				NextFlag := True;
				NextPoint := xy;
				//ë“Çøéûä‘(Ç©Ç»ÇËìKìñ)
				ActTick := Tick + Cardinal(Random(1000)) + Speed * Cardinal(i);
			end;
		end;
	end;
end;//proc AutoAction()


function TFrmMain.DamageOverTime(tm: TMap; var tc: TChara; Tick: cardinal; skill: word; useLV: byte; count: integer): boolean;
var
	tl  : TSkillDB;
	tv  : TLiving;
	ts  : TMob;
	ts1 : TMob;
	i1  : Integer;
	j1  : Integer;
	k1  : Integer;
	sl  : TStringList;
	{ChrstphrR 2004/04/27 - Okay, new game plan with StringLists...
	UNLESS you need them end to end in a routine, you create them when needed,
	and free them up inside that block after it's use is over with.
	i.e. in a Case branch, between that branch's begin-end, you will

	begin//Skillname here
		sl := TStringList.Create;
		//Do stuff here, some involving the sl...
		...
		sl.Free;
	end;//Skillname here
	}

	offset : Integer;
	xy     : TPoint;
begin
	Result := false;
	tv := tc.AData;
	tl := tc.Skill[skill].Data;

	if (tv = nil) then Exit;//safe 2004/04/27

	case skill of
	86: // Water Ball
		begin
			ts := tv as TMob;
			with tc do begin
				MSkill := 86;
				MUseLV := useLV;
				dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100;
				dmg[0] := dmg[0] * (100 + (30 * MUseLV)) div 100; // Added skill fix
				dmg[0] := dmg[0] * (100 - ts.Data.MDEF) div 100; //MDEF%
				dmg[0] := dmg[0] - ts.Data.Param[3]; //MDEF-
				if dmg[0] < 1 then dmg[0] := 1;
				dmg[0] := dmg[0] * ElementTable[tl.Element][ts.Element] div 100;
				if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï

				if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;

				//if (count mod 3 = 1) then begin
				SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
				{end else begin
					MSkill := 0;
					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);}
				//end;

				//É_ÉÅÅ[ÉWèàóù
				if (dmg[0] >= ts.HP) then begin
					offset := 0;
					count := 0;
				end else begin
					offset := 150;
					count := count - 1;
				end;
				DamageProcess1(tm, tc, ts, dmg[0], Tick);

				xy := ts.Point;

				sl := TStringList.Create;//remember this must be free'd afterward!
				for j1 := (xy.Y - 1) div 8 to (xy.Y + 1) div 8 do begin
					for i1 := (xy.X - 1) div 8 to (xy.X + 1) div 8 do begin
						for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
							if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then Continue; ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
							if (ts = ts1) or ((tc.GuildID <> 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID <> 0) and (ts1.GID = tc.GuildID)) then Continue;
							if (abs(ts1.Point.X - xy.X) <= tl.Data2[MUseLV]) and (abs(ts1.Point.Y - xy.Y) <= tl.Data2[MUseLV]) then
								sl.AddObject(IntToStr(ts1.ID),ts1);
						end;
					end;
				end;
				if sl.Count <> 0 then begin
					for k1 := 0 to sl.Count - 1 do begin
						ts1 := sl.Objects[k1] as TMob;
						dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100;
						dmg[0] := dmg[0] * (100 + (30 * MUseLV)) div 100; // Added skill fix
						dmg[0] := dmg[0] * (100 - ts1.Data.MDEF) div 100; //MDEF%
						dmg[0] := dmg[0] - ts1.Data.Param[3]; //MDEF-
						if dmg[0] < 1 then dmg[0] := 1;
						dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100;
						if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						if (ts1.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
						SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1);
						//É_ÉÅÅ[ÉWèàóù
						DamageProcess1(tm, tc, ts1, dmg[0], Tick)
					end;
				end;
			sl.Free;//safe 2004/04/27
			end;//with
			//offset := 150;
			//count := count - 1;
			tc.Skill[86].Tick := Tick + offset;
			tc.Skill[86].EffectLV := count;
		end;
	end;//case

	{if (count > 0) then begin
		DamageOverTime(tm, tc, Tick + offset, skill, count);
	end;}
end;//func TFrmMain.DamageOverTime()

{í«â¡ÉRÉRÇ‹Ç≈}
//------------------------------------------------------------------------------
procedure TfrmMain.cmdStartClick(Sender: TObject);
var
	DelDelayNum     :integer;       // mf
	DelPoint        :TPoint;        // mf
	DelCount        :integer;       // mf

	i,j,k,l,m,n,a,b,c:integer;
	i1,j1,k1:integer;
	Tick :cardinal;

	//tp:TPlayer;
	tc:TChara;
	//tp1:TPlayer;
	tc1:TChara;
	tm:TMap;
	mi:MapTbl;
	tn:TNPC;
	ts:TMob;
	ts1:TMob;
	ts2:TMob;
	CastingMonster:TMob;  //Get if a monster is casting a skill
	tk	:TSkill;
	tl	:TSkillDB;
	spd:cardinal;
	Tick1:cardinal;
	xy:TPoint;
	xy2:TPoint;
	dx,dy:integer;
	rx,ry:integer;
	r:integer;
	DropFlag:boolean;
	SkillProcessType:byte;
	sl:TStringList;
	bb:array of byte;
{ÉLÉÖÅ[ÉyÉbÉg}
				tpe:TPet;
{ÉLÉÖÅ[ÉyÉbÉgÇ±Ç±Ç‹Ç≈}
{NPCÉCÉxÉìÉgí«â¡}
	tr      :NTimer;
{NPCÉCÉxÉìÉgí«â¡ÉRÉRÇ‹Ç≈}

	zfile :TZip;

    x, y : Integer;

label ExitWarpSearch;
begin

	sl := TStringList.Create;
	try
		cmdStart.Enabled := false;

        try
    		sv1.Active := true;
        except
            on ESocketError do begin
                cmdStart.Enabled := True;
                debugout.Lines.add('The Login port (' + IntToStr(sv1port) + ') is in use. You can not run Fusion on this port.');
                Exit;
            end;
        end;

        try
		    sv2.Active := true;
        except
            on ESocketError do begin
                cmdStart.Enabled := True;
                debugout.Lines.add('The Character port '+ IntToStr(sv2port) +' is in use. You can not run Fusion on this port.');
                Exit;
            end;
        end;

        try
		    sv3.Active := true;
        except
            on ESocketError do begin
                cmdStart.Enabled := True;
                debugout.Lines.add('The Zone port '+ IntToStr(sv3port) +' is in use. You can not run Fusion on this port.');
                Exit;
            end;
        end;

		ServerRunning := true;
		cmdStop.Enabled := true;
		TickCheckCnt := 0;

		OnlineTime := timeGetTime(); // AlexKreuz

		DelDelayNum := 0; // mf

        if (Option_Minimize_Tray) then frmMain.MinimizetoTray2Click(self);

		repeat

			// mf
			DelCount := 0;
			repeat
				if (DelPointX[DelDelayNum] <> 0) and (DelWait[DelDelayNum] + 5000 < Tick) then begin
					DelPoint.X := DelPointX[DelDelayNum];
					DelPoint.Y := DelPointY[DelDelayNum];
					WFIFOW( 0, $0080);
					WFIFOL( 2, DelID[DelDelayNum]);
					WFIFOB( 6, 1);
					SendBCmd(tm, DelPoint, 7);
					DelPointX[DelDelayNum] := 0;
					DelPointY[DelDelayNum] := 0;
					DelID[DelDelayNum] := 0;
					DelWait[DelDelayNum] := 0;
				end;
				DelDelayNum := DelDelayNum + 1;
				if DelDelayNum > 999 then DelDelayNum := 0;
				DelCount := DelCount + 1;
			until DelCount > 9;
			//mf

			Tick := timeGetTime();
			// AlexKreuz Online Time
			// ChrstphrR 2004/06/02 - minor rewrite, all integer math/types now
			ElapsedT := (Tick - Cardinal(OnlineTime));

			ElapsedD := (ElapsedT div 86400000);
			ElapsedT := ElapsedT Mod 86400000;

			ElapsedH := (ElapsedT div 3600000);
			ElapsedT := ElapsedT Mod 3600000;

			ElapsedM := (ElapsedT div 60000);
			ElapsedT := ElapsedT Mod 60000;

			ElapsedS := (ElapsedT div 1000);

			StatusBar1.Panels[1].Text := Format(
				'%d Days, %d Hours, %d Minutes, %d Seconds',
				[ ElapsedD, ElapsedH, ElapsedM, ElapsedS ]
			); // AlexKreuz (Status Bar)
			// AlexKreuz Online Time


			for i := 0 to CharaName.Count - 1 do begin
				tc := CharaName.Objects[i] as TChara;
				if tc.Login <> 2 then continue;  //Character is logged in
				with tc do begin

					tm := MData;
					if tm = nil then continue;

					mi := MapInfo.Objects[MapInfo.IndexOf(tm.Name)] as MapTbl;

					if (Sit <> 1) and (Auto <> 0) and (ActTick < Tick) then begin
						AutoAction(tc,Tick);
					end;


					// This code checks to see if you are in attack mode.
					// If you are this code will check to see if you and the mob share the same spot.
					// If you do this code will move you to a random spot 1 tc.Range away from the mob.
					// Purpose: Created to fix bug where you stop attacking when you and mob
					// share same spot.
					if (AMode = 1) or (AMode = 2) then begin

                    	if tc.MTargetType = 0 then begin
						ts := AData;
                            x := ts.Point.x;
                            y := ts.Point.y;
                        end else begin
                        	tc1 := AData;
                            x := tc1.Point.x;
                            y := tc1.Point.y;
                        end;

						if ( (x = tc.Point.x) and (y = tc.Point.Y) ) then begin
							//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'stuck');
							k := 0;
							r := 0;
							while ( (k = 0) and (r < 100) ) do begin
								Randomize;
								rx := randomrange(-tc.Range,tc.Range) + tc.Point.X;
								Randomize;
								ry := randomrange(-tc.Range,tc.Range) + tc.Point.Y;
								k := Path_Finding(tc.path, tm, tc.Point.X, tc.Point.Y, rx, ry, 1);
								inc(r);
							end;

							if ( (k <> 0) ) then begin
								NextFlag := true;
								nextpoint.X := rx;
								nextpoint.Y := ry;
							end;
						end;
					end;
					// End Code: AlexKreuz


					//Able to move
					if (pcnt <> 0)  then begin
						if (Path[ppos] and 1) = 0 then spd := Speed else spd := Speed * 140 div 100;

						if MoveTick + spd <= Tick then begin
	{èCê≥}
							if CharaMoving(tc,Tick) then begin
								goto ExitWarpSearch;
							end;
	{èCê≥ÉRÉRÇ‹Ç≈}
						end;
					end;

	{U0x003b}
					try
					//í«â¡à⁄ìÆèàóù
						if NextFlag and (DmgTick <= Tick) then begin
							if (tm.Size.X < NextPoint.X) or (tm.Size.Y < NextPoint.Y) then begin
								//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Move processing error');
							end else begin
								/// alexkreuz: xxx
	//						if ((tc.MMode = 0) or (tc.Skill[278].Lv > 0)) and ((tm.gat[NextPoint.X][NextPoint.Y] <> 1) and (tm.gat[NextPoint.X][NextPoint.Y] <> 5)) and ((tc.Option <> 6) or (tc.Skill[213].Lv <> 0) or (tc.isCloaked)) and (tc.SongTick < Tick) and (tc.AnkleSnareTick < Tick) then begin
								if ((tc.MMode = 0) or (tc.Skill[278].Lv > 0)) and ((tm.gat[NextPoint.X][NextPoint.Y] <> 1) and (tm.gat[NextPoint.X][NextPoint.Y] <> 5)) and ((tc.Option and 6 = 0) or (tc.Skill[213].Lv <> 0) or (tc.isCloaked)) and (tc.SongTick < Tick) and (tc.AnkleSnareTick < Tick) and (tc.FreezeTick < Tick) and (tc.StoneTick < Tick) then begin
									//í«â¡à⁄ìÆ
									AMode := 0;

									{ Alex: Currently Unexplored - Type 1 for safety }
									k := Path_Finding(tc.path, tm, Point.X, Point.Y, NextPoint.X, NextPoint.Y, 1);
									if k <> 0 then begin
										if pcnt = 0 then MoveTick := Tick;
										pcnt := k;
										ppos := 0;
										Sit := 0;
										tgtPoint := NextPoint;
										//åoòHíTçıOK
										WFIFOW(0, $0087);
										WFIFOL(2, MoveTick);
										WFIFOM2(6, NextPoint, Point);
										WFIFOB(11, 0);
										Socket.SendBuf(buf, 12);
										//ÉuÉçÉbÉNèàóù
										for n := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
											for m := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
												//é¸ÇËÇÃêlÇ…í ím&é¸ÇËÇ…Ç¢ÇÈêlÇï\é¶Ç≥ÇπÇÈ
												for k := 0 to tm.Block[m][n].CList.Count - 1 do begin
													tc1 := tm.Block[m][n].CList.Objects[k] as TChara;
													if (tc <> tc1) and (abs(Point.X - tc1.Point.X) < 16) and (abs(Point.Y - tc1.Point.Y) < 16) then begin
														SendCMove(tc1.Socket, tc, Point, NextPoint);
	{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡}
														//é¸ï”ÇÃÉ`ÉÉÉbÉgÉãÅ[ÉÄÇï\é¶
														ChatRoomDisp(tc.Socket, tc1);
	{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡ÉRÉRÇ‹Ç≈}
	{òIìXÉXÉLÉãí«â¡}
														//é¸ï”ÇÃòIìXÇï\é¶
														VenderDisp(tc.Socket, tc1);
	{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}
													end;
												end;
											end;
										end;
									end;
								end else begin
									Sit := 3;
								end;
								NextFlag := false;
							end;
						end;
					except
						//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Move processing error');
					end;

					//Auto Attacking
					if (AMode = 1) or (AMode = 2) then begin
						if (tc.Sit = 1) or (tc.Option and 6 <> 0) then begin
							AMode := 0;
						end else if ATick + ADelay < Tick then begin
							if (tm.CList.IndexOf(tc.ATarget) <> -1) and ((mi.Pvp = true) or (mi.PvPG = true)) then begin
								if (mi.PvPG = true) then begin
									tc1 := tc.AData;
									//Check if character is in guild
									if ((tc1.GuildID <> tc.GuildID) or (tc.GuildID = 0)) then begin
										CharaAttack2(tc,Tick);
									end;
								end else begin
									CharaAttack2(tc,Tick);
								end;
							end else begin
								ts := tc.AData;
								if (ts.GID <> tc.GuildID) and (ts.isGuardian <> tc.GuildID) or (tc.GuildID = 0) then begin
									CharaAttack(tc,Tick);
								end;
							end;
							if AMode = 1 then AMode := 0;
						end;
					end;
					//ÉXÉLÉãèàóù

					//Darkhelmet, ts isnt always defined i believe
					// so it does not always work.  But, this is the
					// correct way of doing the cast time.

					for b := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
						for a := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
							if tm.Block[a][b] = nil then continue;
							//if not tm.Block[a][b].MobProcess then begin
							if tm.Block[a][b].MobProcTick < Tick then begin
								//ÉÇÉìÉXÉ^Å[à⁄ìÆèàóù(ïtãﬂÇÃÉÇÉìÉXÉ^Å[)
								//for k := 0 to tm.Block[a][b].Mob.Count - 1 do begin
								k := 0;
								while (k >= 0) and (k < tm.Block[a][b].Mob.Count) do begin
									//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'mob : ' + IntToStr(k));
									if ((tm.Block[a][b].Mob.Objects[k] is TMob) = false) then begin
										Inc(k);
										continue;
									end;

									CastingMonster := tm.Block[a][b].Mob.Objects[k] as TMob;
									Inc(k);
									//if CastingMonster = nil then Continue;
									if CastingMonster <> nil then begin
										if (CastingMonster.MTick <= Tick) and (CastingMonster.Mode = 3) then begin
											if (tc.HP > 0) and (CastingMonster.Stat2 <> 4) then begin
												tl := tc.Skill[CastingMonster.MSkill].Data;
												tk := tc.Skill[CastingMonster.MSkill];

												//if Boolean(MMode and $02) then begin
												if (tl.SType = 1) then MobSkills(tm, CastingMonster, Tick)
												//if tc.Skill[tsAI.Skill[i]].Data.SType = 2 then
												else if (tl.SType = 2) then MobFieldSkills(tm, CastingMonster, Tick)
												else MobStatSkills(tm, CastingMonster, Tick);
												CastingMonster.SkillWaitTick := Tick + Cardinal(CastingMonster.Data.WaitTick);
												ts.SkillType := 0;
												//end else if Boolean(MMode and $01) then begin
												//pcnt := 0;

												CastingMonster.MTick := Tick;
												CastingMonster.Mode := 0;
												//CastingMonster.MTarget := 0;
											end else if (CastingMonster.Stat2 = 4) then begin
												tm := tc.MData;

												WFIFOW(0, $00c0);
												WFIFOL(2, CastingMonster.ID);
												WFIFOB(6, 09);

												SendBCmd(tm, tc.Point, 7);

											end else begin
												CastingMonster.MTick := 0;
												CastingMonster.Mode := 0;
											end;
										end;
									end;
								end;
							end;
						end;
					end;


					if Boolean(MMode and $03) and (MTick <= Tick) then begin
                        if tc.StatRecalc then CalcStat(tc);
						tl := tc.Skill[tc.MSkill].Data;
						tk := tc.Skill[tc.MSkill];
						if (tc.SP < tl.SP[tc.MUseLV]) and
						 (((tc.MSkill <> 51) and (tc.MSkill <> 135)) or
						 (((tc.MSkill = 51) or (tc.MSkill = 135)) and (tc.Option and 6 = 0))) then begin
							//SPïsë´
							SendSkillError(tc, 1);
							if MMode = 1 then begin
								MMode := 0;
								MTarget := 0;
							end else begin
								MMode := 0;
								MPoint.X := 0;
								MPoint.Y := 0;
							end;
						end else if tc.Weight * 100 div tc.MaxWeight >= 90 then begin
							//èdó ÉIÅ[ÉoÅ[
							WFIFOW(0, $013b);
							WFIFOW(2, 2);
							Socket.SendBuf(buf, 4);
							if MMode = 1 then begin
								MMode := 0;
								MTarget := 0;
							end else begin
								MMode := 0;
								MPoint.X := 0;
								MPoint.Y := 0;
							end;
						end else begin
							if (tk.Lv < MUseLV) and (tc.ItemSkill = false) then begin
								//ÉåÉxÉãÇ™ë´ÇËÇ»Ç¢(ïsê≥ÉpÉPÉbÉg)
								if MMode = 1 then begin
									MMode := 0;
									MTarget := 0;
								end else begin
									MMode := 0;
									MPoint.X := 0;
									MPoint.Y := 0;
								end;
							end else if ((tc.Sit = 1) and (tc.MSkill <> 143)) then begin
								if MMode = 1 then begin
									MMode := 0;
									MTarget := 0;
								end else begin
									MMode := 0;
									MPoint.X := 0;
									MPoint.Y := 0;
								end;
							end else if (tc.Option and 2 <> 0) and (tc.MSkill <> 51) and (tc.MSkill <> 137) and (tc.MSkill <> 214) and (tc.MSkill <> 212)then begin
								if MMode = 1 then begin
									MMode := 0;
									MTarget := 0;
								end else begin
									MMode := 0;
									MPoint.X := 0;
									MPoint.Y := 0;
								end;
							end else begin
								if Boolean(MMode and $02) then begin
									CreateField(tc,Tick);
								end else if Boolean(MMode and $01) then begin
									ts := tc.adata;
									if assigned(ts) then begin
										if ( (Path_Finding(tc.path, tm, tc.Point.X, tc.Point.Y, ts.Point.X, ts.Point.Y, 2) <> 0) or (ts.ID = tc.ID) ) then begin
											SkillEffect(tc,Tick);
										end;
									end else begin
										SkillEffect(tc,Tick);
									end;
									MTarget := 0;
									pcnt := 0;
								end;
								if Boolean(MMode xor $04) then begin
									if NOT (tc.ItemSkill) then begin
										// Colus, 20040118: Unhiding should not drain SP...
										// Colus, 20040204: The reason we are testing that we _are_ hidden is b/c we use
										// the mode set in the skill code previously.  This means you are hiding successfully.
										if (((MSkill <> 51) and (MSkill <> 135)) or ((MSkill = 51) and (Option and 2 <> 0)) or ((MSkill = 135) and (Option and 4 <> 0))) then begin
                                        	{ Alex: This must be moved into the new PSS system
                                            as soon as all the skills have made the transition. }
											DecSP(tc, MSkill, MUseLV);
										end;
									end else begin
										tc.ItemSkill := false;
									end;
								end;
								tc.MMode	:= 0;
								tc.MSkill := 0;
								tc.MUseLv := 0;
							end;
						end;
					end;

					CharaPassive(tc,Tick);
					SkillPassive(tc,Tick);
					if (EnablePetSkills) and ( tc.PetData <> nil ) and ( tc.PetNPC <> nil )then PetPassive(tc, Tick);

					//éûä‘êßå¿ÉXÉLÉãÇ™êÿÇÍÇΩÇ©Ç«Ç§Ç©É`ÉFÉbÉN
					if SkillTick <= Tick then begin
						case SkillTickID of
						10,24: // Sight/Ruwach
							begin
								Option := Option and $DFFE;
								UpdateOption(tm, tc);
								Skill[SkillTickID].Tick := 0;
								//Skill[10].Tick := 0;
								//Skill[24].Tick := 0;
							end;

						51,135: // Hiding and Cloaking
							begin
								// AlexKreuz: Changed to expire Hide Skill
								if (tc.Option and 6 <> 0) then begin
									tc.Option := tc.Option and $FFF9;
									SkillTick := tc.Skill[SkillTickID].Tick;
									//tc.SP := tc.SP + 10;
									tc.Hidden := false;
									if tc.SP > tc.MAXSP then tc.SP := tc.MAXSP;
									CalcStat(tc, Tick);
									UpdateOption(tm, tc);
									// Colus, 20031228: Tunnel Drive speed update
									if (tc.Skill[213].Lv <> 0) then begin
										SendCStat1(tc, 0, 0, tc.Speed);
									end;
								end;
							end;
						261:    {Call Spirits}
							begin
								//UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
							end;
						end;//case
						// Remove icon if the skill has one...
                        if assigned(tc.Skill[tc.SkillTickID].Data) then begin
							if tc.Skill[SkillTickID].Data.Icon <> 0 then begin
								if tc.Skill[tc.SkillTickID].Tick <= Tick then begin
									//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('(Icon remove, skilltickid %d)',[SkillTickID]));
									UpdateIcon(tm, tc, tc.Skill[SkillTickID].Data.Icon, 0);
								end;
                            end;
						end;

						CalcStat(tc, Tick);
						SendCStat(tc);
						CalcSkillTick(tm, tc, Tick);
					end;

					//PassiveIcons(tm, tc);

					//Mob&Item Process
					tm := tc.MData;
					for b := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
						for a := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
							if tm.Block[a][b] = nil then continue;
							//if not tm.Block[a][b].MobProcess then begin
							if tm.Block[a][b].MobProcTick < Tick then begin
								//ÉÇÉìÉXÉ^Å[à⁄ìÆèàóù(ïtãﬂÇÃÉÇÉìÉXÉ^Å[)
								//for k := 0 to tm.Block[a][b].Mob.Count - 1 do begin
								k := 0;
								while (k >= 0) and (k < tm.Block[a][b].Mob.Count) do begin
									//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'mob : ' + IntToStr(k));
									if ((tm.Block[a][b].Mob.Objects[k] is TMob) = false) then begin
										Inc(k);
										continue;
									end;

									ts := tm.Block[a][b].Mob.Objects[k] as TMob;

                                    {Mercenary Handling}
                                    if ts.MercID <> 0 then begin
                                        if ts.MercMoveTick < Tick then
                                            if (ts.OwnerID = tc.ID) and (ts.MercMoveTick < Tick) then MercenaryAI(tc, ts, tm, Tick);
                                    end;
                                    
									Inc(k);
									if ts = nil then Continue;
									if (ts.HP = 0) and (ts.SpawnTick + ts.SpawnDelay1 + cardinal(Random(ts.SpawnDelay2 + 1)) <= Tick) then begin
										//Spawn
										MonsterSpawn(tm, ts, Tick);
									end;

									with ts do begin
										//èÛë‘ïœâª
										StatEffect(tm,ts,Tick);
										//èÛë‘ÇPÇ≈ÇÕçsìÆïsâ¬
										if ts.Stat1 <> 0 then Continue;
										MobAI(tm,ts,Tick);
										if (ts = nil) then continue;

										if (ts <> nil) then begin
											if (EmperiumID <> 0) then begin
												ts2 := tm.Mob.IndexOfObject(EmperiumID) as TMob;
												if (ts2 = nil) or (ts2.HP = 0) or (ts2.Map <> ts.Map) then begin
													EmperiumID := 0;
													MonsterDie(tm,tc,ts,Tick);
												end;
											end;
										end;

										if (ts <> nil) then begin
											if (LeaderID <> 0) then begin
												ts2 := tm.Mob.IndexOfObject(LeaderID) as TMob;
												if (ts2 = nil) or (ts2.HP = 0) or (ts2.Map <> ts.Map) then begin
													MonsterDie(tm,tc,ts,Tick);
												end;
											end;
										end;

										if (pcnt <> 0) then begin

											if isLooting then begin
											SendMMove(tc.Socket, ts, Point, tgtPoint, tc.ver2);
											SendBCmd(tm,ts.Point,58,tc,True);
											end;

											if (path[ppos] and 1) = 0 then spd := Speed else spd := Speed * 140 div 100; //éŒÇﬂÇÕ1.4î{éûä‘Ç™Ç©Ç©ÇÈ
											if MoveTick + spd <= Tick then begin
												if ts.Mode <> 3 then k := k + MobMoving(tm,ts,Tick);
											end;

										end else begin
											if (ts.HP = 0) then continue;

											if isLooting then begin
												if ATick < Tick then
													PickUp(tm,ts,Tick);
											end else if (ATarget <> 0) and (Data.Range1 > 0) then begin
												MobAttack(tm,ts,Tick);
											end else if (MoveWait < Tick) and (not isLooting) then begin
												//à⁄ìÆäJén
												j := 0;
												if LeaderID <> 0 then begin
													//éÊÇËä™Ç´óp
													ts2 := tm.Mob.IndexOfObject(LeaderID) as TMob;
													if (ts2 = nil) or (ts2.HP = 0) or (ts2.Map <> ts.Map) then begin
														LeaderID := 0;
														MonsterDie(tm,tc,ts,Tick);
													end else begin
														repeat
															k := 0;
															repeat
																xy.X := ts2.Point.X + Random(11) - 5;
																xy.Y := ts2.Point.Y + Random(11) - 5;
																Inc(k);
															until ((xy.X >= 0) and (xy.X <= tm.Size.X - 2) and (xy.Y >= 0) and (xy.Y <= tm.Size.Y - 2)) or (k = 100);
															if k = 100 then begin
																//à⁄ìÆâ¬î\â”èäÇ™Ç»Ç¢orè≠Ç»Ç∑Ç¨ÇÈÇ∆Ç´ÇÕà⁄ìÆÇµÇ»Ç¢
																j := 100;
																Break;
															end;
															if ( (tm.gat[xy.X][xy.Y] <> 1) and (tm.gat[xy.X][xy.Y] <> 5) ) then
																{ Alex: Currently Unexplored - Type 1 for safety }
																pcnt := Path_Finding(path, tm, Point.X, Point.Y, xy.X, xy.Y, 1);
															Inc(j);
														until (pcnt <> 0) or (j = 100);
													end;
												end else begin
													//AMode := 0;
													//030316-2 ñºñ≥ÇµÇ≥ÇÒ/030317
													repeat
														k := 0;
														pcnt := 0;
														repeat
															xy.X := Point.X + Random(17) - 8;
															xy.Y := Point.Y + Random(17) - 8;
															Inc(k);
														until ((xy.X >= 0) and (xy.X <= tm.Size.X - 2) and (xy.Y >= 0) and (xy.Y <= tm.Size.Y - 2)) or (k = 100);
														if k = 100 then begin
															//à⁄ìÆâ¬î\â”èäÇ™Ç»Ç¢orè≠Ç»Ç∑Ç¨ÇÈÇ∆Ç´ÇÕà⁄ìÆÇµÇ»Ç¢
															j := 100;
															break;
														end;
														//---
														if ( (tm.gat[xy.X][xy.Y] <> 1) and (tm.gat[xy.X][xy.Y] <> 5) ) then
															{ Alex: Currently Unexplored - Type 1 for safety }
															pcnt := Path_Finding(path, tm, Point.X, Point.Y, xy.X, xy.Y, 1);
														ts.DeadWait := Tick;   // mf
														Inc(j);
													until (pcnt <> 0) or (j = 100);
												end;
												if (j < 100) then begin
													ppos := 0;
													if (pcnt <> 0) and (ts.AnkleSnareTick < Tick) then begin
														MoveTick := Tick;
														tgtPoint := xy;

														UpdateMonsterLocation(tm, ts);

														SendMMove(tc.Socket, ts, Point, tgtPoint, tc.ver2);
														SendBCmd(tm,ts.Point,58,tc,True);
													end;
	{èCê≥ÉRÉRÇ‹Ç≈}
												end else begin
													if ts.isSlave then begin
													MonsterDie(tm,tc,ts,Tick);
													end else begin
													//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('* * * * SearchPath Error (%d,%d)',[Point.X,Point.Y]));
													end;
													MoveWait := Tick + 10000;
												end;
											end;
										end;
									end;
								end;

								//ÉAÉCÉeÉÄ&ÉXÉLÉãå¯î\ínèàóù(ïtãﬂÇÃÇ‡ÇÃÇÃÇ›èàóù)
								k := 0;
								while (0 <= k) and (k < tm.Block[a][b].NPC.Count) do begin
									//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'mob : ' + IntToStr(k));
									if ((tm.Block[a][b].NPC.Objects[k] is TNPC) = false) then begin
									Inc(k);
									continue;
									end;

									tn := tm.Block[a][b].NPC.Objects[k] as TNPC;
									Inc(k);
									if tn = nil then Continue;
									k := k + NPCAction(tm,tn,Tick,tc);
								end;
								//ÉtÉâÉOON
								//tm.Block[a][b].MobProcess := true;
								tm.Block[a][b].MobProcTick := Tick;
							end;
						end;
					end;
	{ÉLÉÖÅ[ÉyÉbÉg}
					if ( PetData <> nil ) and ( PetNPC <> nil ) and (PetMoveTick < Tick) then begin
						tpe := PetData;
						tn := PetNPC;
						if tpe.isLooting = false then begin
							// à⁄ìÆ
							j := 0;
							{ Alex: Currently Unexplored - Type 1 for safety }
							k := Path_Finding(tn.path, tm, tn.Point.X, tn.Point.Y, Point.X, Point.Y, 1);
							if (k > 3) and (k < 15) then begin

								if Sit = 0 then begin
									xy := Point;
								end else begin
									repeat
										if j >= 100 then begin
											xy := Point;
											break;
										end;

										xy.X := Point.X + Random(5) - 2;
										xy.Y := Point.Y + Random(5) - 2;
										Inc(j);
									until ( xy.X <> Point.X ) or ( xy.Y <> Point.Y );
									{ Alex: Currently Unexplored - Type 1 for safety }
									k := Path_Finding(tn.path, tm, tn.Point.X, tn.Point.Y, xy.X, xy.Y, 1);
								end;

								if k <> 0 then begin
									tn.NextPoint := xy;
									SendPetMove( Socket, tc, xy );
									SendBCmd( tm, tn.Point, 58, tc, True );

									if tn.pcnt = 0 then MoveTick := Tick;
									tn.pcnt := k;
									tn.ppos := 0;

									PetMoveTick := Tick + 1500;
									if (tn.Path[tn.ppos] and 1) = 0 then spd := Speed else spd := Speed * 140 div 100;

									if tn.MoveTick + spd <= Tick then begin
										PetMoving( tc, Tick );
									end;

								end;
								// k = 0 case makes pets dupe next to you...
							end else if (k >= 15) then begin //or (k = 0) then begin

								WFIFOW( 0, $0080 );
								WFIFOL( 2, tn.ID );
								WFIFOB( 6, 0 );
								SendBCmd( tm, tn.Point, 7 ,tc);
                                
								//Delete block
								l := tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.IndexOf(tn.ID);
								if l <> -1 then begin
									tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.Delete(l);
								end;

								l := tm.NPC.IndexOf( tn.ID );
								if l <> -1 then begin
									tm.NPC.Delete(l);
								end;

								tn.Free;
								tc.PetNPC := nil;
								n := 0;
								for m := 1 to 100 do begin
									if ( tc.Item[m].ID <> 0 ) and ( tc.Item[m].Amount > 0 ) and
										( tc.Item[m].Card[0] = $FF00 ) and ( tc.Item[m].Attr <> 0 ) then begin
											n := m;
											break;
									end;
								end;
								if n > 0 then begin

									l := PetList.IndexOf( tc.Item[n].Card[2] + tc.Item[n].Card[3] * $10000 );

									if l <> -1 then begin
										SendPetRelocation(tm, tc, l);
									end;
								end;
							end;
						end else if tpe.isLooting then begin
							j := 0;
							{ Alex: Currently Unexplored - Type 1 for safety }
							k := Path_Finding(tn.path, tm, tn.Point.X, tn.Point.Y, tn.NextPoint.X, tn.NextPoint.Y, 1);
							if k > 1 then begin
								//tn.NextPoint := xy;
								SendPetMove( Socket, tc, tn.NextPoint );
								SendBCmd( tm, tn.Point, 58, tc, True );
								if tn.pcnt = 0 then MoveTick := Tick;
								tn.pcnt := k;
								tn.ppos := 0;

								PetMoveTick := Tick + 1000;
								if (tn.Path[tn.ppos] and 1) = 0 then spd := Speed else spd := Speed * 140 div 100;

								if tn.MoveTick + spd <= Tick then begin
									PetMoving( tc, Tick );
								end;
							end else begin
								PetPickup(tm, tpe, tc, Tick);
							end;
						end;

                        if tpe.Data = nil then begin
                            debugout.Lines.Add('Pet ' + tpe.Name + ' not defined in pet_db.txt');
                            debugout.Lines.Add('Server terminated.');
                            cmdStop.Click;
                            Exit;
                        end;

						//Auto PetIsHungrier system
						if tpe.Fullness > 0 then begin
							if ( tn.HungryTick + tpe.Data.HungryDelay ) < Tick then begin
								tpe.Fullness := tpe.Fullness -1;

								WFIFOW( 0, $01a4 );
								WFIFOB( 2, 2 ); // Intimacy Changed
								WFIFOL( 3, tn.ID );
								WFIFOL( 7, tpe.Fullness );
								tc.Socket.SendBuf( buf, 11 );

								tn.HungryTick := Tick;
							end;
						end;
					end;
	{ÉLÉÖÅ[ÉyÉbÉgÇ±Ç±Ç‹Ç≈}
				end;
				ExitWarpSearch:
			end;

            {Check to unload maps}
{

Alex:

This stuff doesnt work,
don't uncomment.



        if tm.UnloadTime > 0 then begin
            for k := 0 to Map.Count - 1 do begin
                tm := Map.Objects[k] as TMap;
                if NOT MapPassive(tm, Tick) then tm.LastAction := Tick;
                if tm.NeedToUnload then begin
                    //DebugOut.Lines.Add('[' + TimeToStr(Now) + '] ' + 'Map ' + tm.Name + 'Has been destroyed');
                    i := Map.IndexOf(tm.Name);
                    if i <> -1 then begin
                        Map.Delete(i);
                        tm.Destroy;
                    //    DebugOut.Lines.Add('[' + TimeToStr(Now) + '] ' + 'Current Map Count ' + IntToStr(Map.Count))
                    end else DebugOut.Lines.Add('[' + TimeToStr(Now) + '] ' + 'Map ' + tm.Name + 'Not Found');
                    Break;
                end;
            end;
        end;

        }

	{NPCÉCÉxÉìÉgí«â¡}
			for k := 0 to Map.Count - 1 do begin

                if Map.Objects[k] = nil then Continue;

				tm := Map.Objects[k] as TMap;
				with tm do begin
					if (TimerAct.Count > 0) then begin
						for i := 0 to TimerAct.Count - 1 do begin
							tr := TimerAct.Objects[i] as NTimer;
							tn := tm.NPC.IndexOfObject(tr.ID) as TNPC;
							for a := 0 to tr.Cnt - 1 do begin
								if (tr.Tick + cardinal(tr.Idx[a]) <= Tick) and (tr.Done[a] = 0) then begin
									//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('NPC Timer Event(%d)', [tr.Idx[a]]));
									tr.Done[a] := 1;
									tc1 := TChara.Create;
									tc1.TalkNPCID := tr.ID;
									tc1.ScriptStep := tr.Step[a];
									tc1.AMode := 3;
									tc1.AData := tn;
									tc1.Login := 0;
									NPCScript(tc1,0,1);
									tc1.Free;
								end;
							end;
						end;
					end;
				end;
			end;
	{NPCÉCÉxÉìÉgí«â¡ÉRÉRÇ‹Ç≈}

			//ÉÇÉìÉXÉ^Å[èàóù(ÉLÉÉÉâÇÃÇªÇŒÇ…Ç¢Ç»Ç¢ÉÇÉìÉXÉ^Å[ÇÕä»à’èàóùÇÃÇ›)
			for k := 0 to Map.Count - 1 do begin
				tm := Map.Objects[k] as TMap;
				with tm do begin
					if (Mode = 2) and (CList.Count > 0) then begin
						MobMoveL(tm,Tick);
						//Spwanèàóù
						for i := 0 to Mob.Count - 1 do begin
							ts := Mob.Objects[i] as TMob;
							if (ts.HP = 0) and (ts.SpawnTick + ts.SpawnDelay1 + cardinal(Random(ts.SpawnDelay2 + 1)) <= Tick) then begin
								MonsterSpawn(tm, ts, Tick);
							end;
						end;
					end;
				end;
			end;

			Application.ProcessMessages;
			Tick1 := timeGetTime();
			if (Tick + 30) > Tick1 then begin
				Sleep(Tick + 30 - Tick1);
				//Tick1 := timeGetTime();
			end;

			//if (Tick1 - Tick) <> 0 then begin
				//TickCheck[TickCheckCnt] := Tick1 - Tick;
				//Inc(TickCheckCnt);
				//if TickCheckCnt = 10 then begin
					//Tick1 := 0;
					//for i := 0 to 9 do Tick1 := Tick1 + TickCheck[i];
					//lbl00.Caption := IntToStr(Tick1 div 10);
					//TickCheckCnt := 0;
				//end;
			//end;


		until CancelFlag;
	finally
		sl.Free;
		for i := 0 to sv1.Socket.ActiveConnections - 1 do
			sv1.Socket.Disconnect(i);
		sv1.Active := false;
		for i := 0 to sv2.Socket.ActiveConnections - 1 do
		sv2.Socket.Disconnect(i);
		sv2.Active := false;
		for i := 0 to sv3.Socket.ActiveConnections - 1 do
			sv3.Socket.Disconnect(i);
		sv3.Active := false;
		cmdStop.Enabled := false;
		ServerRunning := false;
		CancelFlag := false;
		cmdStart.Enabled := true;
		//lbl00.Caption := '(ÅL-ÅM)';
	end;
end;

procedure TfrmMain.cmdStopClick(Sender: TObject);
begin
	CancelFlag := true;
	cmdStop.Enabled := false;
end;
//------------------------------------------------------------------------------
{U0x003b}
procedure TfrmMain.DBsaveTimerTimer(Sender: TObject);
begin
	if UseSQL then
		SQLDataSave()
	else
		DataSave();
	//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Data Saved');
end;

//==============================================================================

// AlexKreuz's Server Control Panel & Communication Box
procedure TfrmMain.Button1Click(Sender: TObject);

var
        i, j, k, counter: integer;
        tc1:TChara;
        tc2:TChara;
        tp1: TPlayer;
        ta: TMapList;
        str: string;
        sl: TStringList;
label ExitParse;
begin

    if (Combo_ISCS.ItemIndex = 1) and (ISCS_ON) then begin
        iscs_console_send(Edit1.Text);
    end else if Copy(Edit1.Text, 1, 1) = '-' then begin

        sl := TStringList.Create;
        sl.DelimitedText := Copy(Edit1.Text, 2, 256);

        if sl.Count = 0 then goto ExitParse;
            if sl.Strings[0] = 'reload' then begin
                // Reloads Databases. Warning, does not save Data.
                MapList.Clear;
                ItemDB.Clear;
                ItemDBName.Clear;
                MaterialDB.Clear;
                MobDB.Clear;
                MobDBName.Clear;
                SummonMobList.Clear;
                SummonMobListMVP.Clear; //Safe 2004/05/23
                SummonIOBList.Clear;//Safe 2004/04/26
                SummonIOVList.Clear;//Safe 2004/04/26
                SummonICAList.Clear;//Safe 2004/04/26
                SummonIGBList.Clear;//Safe 2004/04/26
                SummonIOWBList.Clear;//Safe 2004/04/26
                PetDB.Clear;
                MapInfo.Clear;
                SkillDB.Clear;
                SkillDBName.Clear;
                GSkillDB.Clear;
                SlaveDBName.Clear;
                //PharmacyDB.Clear;
                MercenariesList.Clear;
                MobAIDB.Clear;
                MobAIDBFusion.Clear;
                GlobalVars.Clear;
                MArrowDB.Clear;
                WarpDatabase.Clear;
                IDTableDB.Clear;
                Playername.Clear;
                Player.Clear;
                Charaname.Clear;
                Chara.Clear;
                Castlelist.Clear;
                Partynamelist.Clear;
                Guildlist.Clear;
                PetList.Clear;
                DatabaseLoad(Handle);
                DataLoad();
                debugout.lines.add('[' + TimeToStr(Now) + '] ' + '');
                debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Databases Reload Completed ...');
                debugout.lines.add('[' + TimeToStr(Now) + '] ' + '');
            end

            else if sl.Strings[0] = 'uptime' then begin
                // Displays Uptime Stats in Console
                // Syntax: -uptime [global]
                debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Fusion Server Uptime: '+floattostr(ElapsedD) +' Days, '+ floattostr(ElapsedH) +' Hours, '+ floattostr(ElapsedM) +' Minutes, '+ floattostr(ElapsedS) +' Seconds.');
                if sl.Count = 2 then begin
                    if sl.Strings[1] = 'global' then begin
                        edit1.Text := 'Fusion Server Uptime: '+floattostr(ElapsedD) +' Days, '+ floattostr(ElapsedH) +' Hours, '+ floattostr(ElapsedM) +' Minutes, '+ floattostr(ElapsedS) +' Seconds.';
                        button1.Click;
                    end;
                end;
            end

            else if sl.Strings[0] = 'ban' then begin
            // Bans IP Address [global]
            // Syntax: -ban ip.address
            end

            else if sl.Strings[0] = 'unban' then begin
            // Unbans IP Address [global]
            // Syntax: -unban ip.addresss
            end

            else if sl.Strings[0] = 'help' then begin
            // Displays list of Console Commands
            // Syntax: -help
            end

            else if sl.Strings[0] = 'move' then begin
            // Relocates on or off-line player
            // Syntax: -move chara_name map_name x_coord y_coord
            end;

        ExitParse:

        sl.free();
    end

    else begin
    // Sends GM Messages via Server Console
        str := 'Server: ' + edit1.text;
        w := 200;
        WFIFOW(0, $009a);
        WFIFOW(2, w);
        WFIFOS(4, str, w);
        for k := 0 to CharaName.Count - 1 do begin
            tc1 := CharaName.Objects[k] as TChara;
            if tc1.Login = 2 then tc1.Socket.SendBuf(buf, w);
        end;

        debugout.lines.add('[' + TimeToStr(Now) + '] ' + str);
    end;

    edit1.Clear;

end;

procedure TfrmMain.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #13 then begin
        button1.Click;
    end;
end;

procedure TfrmMain.CMClickIcon(var msg: TMessage);
begin
  if msg.lparam = WM_LBUTTONDBLCLK then begin
        Option_Minimize_Tray := False;
        frmMain.Visible := true;
        Application.BringToFront;
        ShowWindow(Application.Handle, SW_SHOWNORMAL);
        SetWindowLong(Application.Handle, GWL_EXSTYLE,WS_EX_APPWINDOW);
        Shell_notifyIcon(NIM_DELETE, @TrayIcon);
  end;
end;

procedure TfrmMain.BackupTimerTimer(Sender: TObject);
begin
	backup_txt_database();
end;

// Knockback situations:
// 1) Knock self back (tc.Dir, bb[] 4
// 2) Knock monster away (ddir, bb[] 0
// 3) Knock self forward (Ashura), ddir, bb[]0
//    has to be tv is ts, so get dir, then orig is tc.point and you act on it
{ChrstphrR 2004/04/28 - no memory leaks.}
procedure TfrmMain.KnockBackLiving(tm:TMap; tc:TChara; tv:TLiving; dist:byte; ktype: byte = 0);
var
	bb: array of byte;
	i: integer;
	b: byte;
	xy : TPoint;
//	vpoint: TPoint;
	dx, dy: integer;
//	tc1: TChara;
//	ts1: TMob;
begin
	SetLength(bb, dist);
	b := tv.Dir;

	if (ktype and 1 = 0) then begin
		for i := 0 to (dist-1) do begin
			bb[i] := 4;
		end;
	end else begin
	//if (ktype and 2 = 0) then begin
		dx := tv.Point.X - tc.Point.X;
		dy := tv.Point.Y - tc.Point.Y;
		if abs(dx) > abs(dy) * 3 then begin
			if dx > 0 then b := 6 else b := 2;
		end else if abs(dy) > abs(dx) * 3 then begin
			if dy > 0 then b := 0 else b := 4;
		end else begin
			if dx > 0 then begin
				if dy > 0 then b := 7 else b := 5;
			end else begin
				if dy > 0 then b := 1 else b := 3;
			end;
		end;
	//end;

		for i := 0 to (dist-1) do begin
			bb[i] := 0;
		end;
	end;

	// Stop them first.
	//UpdateLivingLocation(tm, tv);

	if (ktype and 2 <> 0) then begin
		xy := tc.Point;
		tv := tc;
	end;

	// Do the point shift.  The default behavior is to push backwards.
	DirMove(tm, tv.Point, b, bb);
	if (xy.X div 8 <> tv.Point.X div 8) or (xy.Y div 8 <> tv.Point.Y div 8) then begin
		if (tv is TChara) then begin
			with tm.Block[xy.X div 8][xy.Y div 8].CList do begin
				Assert(IndexOf(tv.ID) <> -1, 'Player Delete Error');
				Delete(IndexOf(tv.ID));
			end;
      tm.Block[tv.Point.X div 8][tv.Point.Y div 8].Clist.AddObject(tv.ID, tv);

      //if (tv.pcnt <> 0) then begin debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Move');
        tv.pcnt := 0;
        //UpdateLivingLocation(tm, tv);
        //SendCMove(tc.Socket, (tv as TChara), xy, tv.Point);
        //SendBCmd(tm, tv.Point, 60, tc);
      //end else begin debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Stat');
      //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('xy %d %d tv %d %d',[xy.X, xy.Y, tv.Point.X, tv.Point.Y]));
        SetSkillUnit(tm, tv.ID, tv.Point, timeGetTime(), $2E, 0, 3000, tc);
        UpdateLivingLocation(tm, tv);
				//SendCData(tc, tc);
        //SendBCmd(tm, tv.Point, 54, tc);
      //end;

    end else if (tv is TMob) then begin
      with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
				Assert(IndexOf(tv.ID) <> -1, 'Mob Delete Error');
        Delete(IndexOf(tv.ID));
      end;
      tm.Block[tv.Point.X div 8][tv.Point.Y div 8].Mob.AddObject(tv.ID, tv);


      if (tv.pcnt <> 0) then begin
        tv.pcnt := 0;
        //UpdateLivingLocation(tm, tv);
        SendMMove(tc.Socket, (tv as TMob), xy, tv.Point, 9);
        SendBCmd(tm, tv.Point, 60, tc);
      end else begin
        SendMData(tc.Socket, (tv as TMob), false);
        SendBCmd(tm, tv.Point, 58);
      end;
    end;

    tv.pcnt := 0;

    //UpdateLivingLocation(tm, tv);

  end;
end;//TfrmMain.KnockBackLiving


procedure TfrmMain.Start1Click(Sender: TObject);
begin
	cmdStart.Click;
end;

procedure TfrmMain.Stop1Click(Sender: TObject);
begin
	cmdStop.Click;
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
    if (ISCS_ON) then iscs_console_disconnect();
	frmMain.Close;
end;


procedure TfrmMain.Save1Click(Sender: TObject);
begin
    DataSave(false);
    debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Player data has been saved.');
end;

procedure TfrmMain.S1Click(Sender: TObject);
begin
    DataSave(true);
end;

procedure TfrmMain.Backup1Click(Sender: TObject);
begin
	backup_txt_database();
    debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Player data has been backed up.');
end;

procedure TfrmMain.MinimizetoTray2Click(Sender: TObject);
begin
    {$IFDEF MSWINDOWS}
    Option_Minimize_Tray := True;
    weiss_ini_save();

    //Add Icon to System Tray
                TrayIcon.cbSize := SizeOf(TrayIcon);
                TrayIcon.Wnd := Self.Handle;
                TrayIcon.uID := 0;
                TrayIcon.uFlags := NIF_ICON or NIF_TIP or NIF_MESSAGE;
                TrayIcon.uCallbackMessage := WM_NOTIFYICON;
                TrayIcon.hIcon := Application.Icon.Handle;
                TrayIcon.szTip := RELEASE_VERSION;
                Shell_notifyIcon(NIM_ADD, @TrayIcon);
                frmMain.Visible := false;
                Application.Minimize;
                ShowWindow(Application.Handle, SW_HIDE);
                SetWindowLong(Application.Handle, GWL_EXSTYLE,
                GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW );
                //Sets Windows Extended Styles WS_EX_TOOLWINDOW to true
                // (Don't ToolWindows don't show in taskbar by default)
    {$ENDIF}
    {$IFDEF LINUX}
        ShowMessage('This Option is not available under Linux.');
    {$ENDIF}
end;

procedure TfrmMain.PageControl1Change(Sender: TObject);
begin
	if (TabSheet1.Showing) then begin
    end else if (TabSheet3.Showing) then begin
		JCon_Accounts_Load();
    end else if (TabSheet4.Showing) then begin
    	JCon_INI_Server_Load();
    end else if (TabSheet6.Showing) then begin
        JCon_Characters_Online();
        //ShowMessage('Under Development, This section does not work.');
    end;


end;

procedure TfrmMain.ListBox1Click(Sender: TObject);
begin
	JCon_Accounts_Populate(0);
end;

procedure TfrmMain.ListBox9Click(Sender: TObject);
begin
    JCon_Accounts_Populate(1);
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
	JCon_Accounts_Clear();
end;

procedure TfrmMain.Button4Click(Sender: TObject);
begin
	JCon_Accounts_Save();
end;

procedure TfrmMain.Button6Click(Sender: TObject);
begin
	JCon_Accounts_Delete();
end;

procedure TfrmMain.Button7Clic(Sender: TObject);
begin
	JCon_Accounts_Chara_Delete(frmMain.Button7.Caption);
end;

procedure TfrmMain.Button8Click(Sender: TObject);
begin
	JCon_Accounts_Chara_Delete(frmMain.Button8.Caption);
end;

procedure TfrmMain.Button9Click(Sender: TObject);
begin
	JCon_Accounts_Chara_Delete(frmMain.Button9.Caption);
end;

procedure TfrmMain.Button10Click(Sender: TObject);
begin
	JCon_Accounts_Chara_Delete(frmMain.Button10.Caption);
end;

procedure TfrmMain.Button11Click(Sender: TObject);
begin
	JCon_Accounts_Chara_Delete(frmMain.Button11.Caption);
end;

procedure TfrmMain.Button12Click(Sender: TObject);
begin
	JCon_Accounts_Chara_Delete(frmMain.Button12.Caption);
end;

procedure TfrmMain.Button13Click(Sender: TObject);
begin
	JCon_Accounts_Chara_Delete(frmMain.Button13.Caption);
end;

procedure TfrmMain.Button14Click(Sender: TObject);
begin
	JCon_Accounts_Chara_Delete(frmMain.Button14.Caption);
end;

procedure TfrmMain.Button15Click(Sender: TObject);
begin
	JCon_Accounts_Chara_Delete(frmMain.Button15.Caption);
end;

procedure TfrmMain.Button5Click(Sender: TObject);
begin
	JCon_INI_Server_Save();
end;

procedure TfrmMain.PageControl2Change(Sender: TObject);
begin
	if (TabSheet4.Showing) then begin
    	JCon_INI_Server_Load();
    end else if (TabSheet5.Showing) then begin
    	JCon_INI_Game_Load();
    end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
	JCon_INI_Game_Save();
end;

procedure TfrmMain.ConnecttoISCS1Click(Sender: TObject);
begin
    if not (ISCS_ON) then begin
        ConnecttoISCS1.Caption := 'Disconnect from ISCS';
        Option_Enable_ISCS := True;
        iscs_console_connect();
        debugout.Lines.Add('- Inter-Server Communication System Activated -');
        Combo_ISCS.ItemIndex := 1;
    end

    else begin
        ConnecttoISCS1.Caption := 'Connect to ISCS';
        Option_Enable_ISCS := False;
        iscs_console_disconnect();
        debugout.Lines.Add('- Inter-Server Communication System Deactivated -');
        Combo_ISCS.ItemIndex := 0;
    end;
end;

procedure TfrmMain.EnableWebAccountCreator1Click(Sender: TObject);
begin
    if not (Option_Enable_WAC) then begin
        EnableWebAccountCreator1.Caption := 'Disable Web Account Creator';
        Option_Enable_WAC := True;
        create_wac();
    end

    else begin
        Option_Enable_WAC := False;
        EnableWebAccountCreator1.Caption := 'Enable Web Account Creator';
        destroy_wac();
    end;
end;

procedure TfrmMain.ListBox2Click(Sender: TObject);
begin
    JCon_Characters_Populate();
end;

procedure TfrmMain.Button16Click(Sender: TObject);
begin
    JCon_Characters_Save();
end;

//character tabs
procedure TfrmMain.PageControl3Change(Sender: TObject);
begin
	if (TabSheet6.Showing) then begin
    	JCon_Characters_Online();
    end else if (TabSheet9.Showing) then begin
    	JCon_Characters_Load();
    end else if (TabSheet10.Showing) then begin
        JCon_Chara_Inv_Load();
        JCon_Chara_Cart_Load();
        JCon_Chara_Store_Load();
    end else if (TabSheet14.Showing) then begin
        JCon_Chara_Flag_Load();
        frmMain.CheckBox2.Checked := True;  //this controls skill load
    end;
end;

//online refresh
procedure TfrmMain.Button17Click(Sender: TObject);
begin
    JCon_Characters_Online();
end;

//online list kick
procedure TfrmMain.Button18Click(Sender: TObject);
begin
    JCon_Chara_KickProcess;
end;

//Kick Ban
procedure TfrmMain.Button20Click(Sender: TObject);
begin
    JCon_Chara_KickProcess(True);
end;

//setting a temp name for the online list
procedure TfrmMain.ListBox3Click(Sender: TObject);
begin
    JCon_Chara_Online_Populate();
end;

//Hitting enter for CharaPM
procedure TfrmMain.Edit8KeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #13 then begin
        JCon_Chara_Online_PM();
    end;
end;

//charaPM
procedure TfrmMain.Button19Click(Sender: TObject);
begin
    JCon_Chara_Online_PM();
end;

//Move a stuck character to last saved location (ex. out of a wall, or isolated area)
procedure TfrmMain.Button21Click(Sender: TObject);
begin
    JCon_Chara_Online_Rescue();
end;

procedure TfrmMain.ListBox4Click(Sender: TObject);
begin
    JCon_Chara_Inv_Populate();
end;

procedure TfrmMain.DNSUpdateTimerTimer(Sender: TObject);
begin
    WAN_ADDR := cardinal(wsocket_inet_addr(PChar(WAN_IP)));
    //WAN_ADDR := cardinal(inet_addr(PChar(WAN_IP)));
    weiss_ini_save();
    debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'DNS Update Complete.');
end;

procedure TfrmMain.Button22Click(Sender: TObject);
begin
    JCon_Chara_Inv_Save();
end;

procedure TfrmMain.CheckBox2Click(Sender: TObject);
begin
    if frmMain.CheckBox2.Checked = true then
        JCon_Chara_Skill_Load(true)
    else JCon_Chara_Skill_Load(false);
end;

procedure TfrmMain.ListBox7Click(Sender: TObject);
begin
    JCon_Chara_Skill_Populate();
end;

procedure TfrmMain.Button23Click(Sender: TObject);
begin
    JCon_Chara_Skill_Save();
end;

procedure TfrmMain.Button25Click(Sender: TObject);
begin
    JCon_Chara_Flag_Delete();
end;

procedure TfrmMain.Button24Click(Sender: TObject);
begin
    JCon_Chara_Flag_Save();
end;

procedure TfrmMain.ListBox8Click(Sender: TObject);
begin
    JCon_Chara_Flag_Populate();
end;

procedure TfrmMain.Options1Click(Sender: TObject);
begin
    JCon_INI_Server_Load();
    TabSheet2.Show;
end;

procedure TfrmMain.Console1Click(Sender: TObject);
begin
    TabSheet1.Show;
end;

procedure TfrmMain.Accounts1Click(Sender: TObject);
begin
    JCon_Accounts_Load();
    TabSheet3.Show;
end;

procedure TfrmMain.Characters1Click(Sender: TObject);
begin
    JCon_Characters_Online();
    TabSheet7.Show;
end;

procedure TfrmMain.Bugtracker1Click(Sender: TObject);
begin
    ShellExecute(self.WindowHandle,'open','http://fusion.cobax.net/bugtracker',nil,nil, SW_SHOWNORMAL);
end;

procedure TfrmMain.FusionHomepage1Click(Sender: TObject);
begin
    ShellExecute(self.WindowHandle,'open','http://fusion.cobax.net',nil,nil, SW_SHOWNORMAL);
end;

end.
