unit 	 Main;

interface

uses
	Windows, MMSystem, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, ScktComp, StdCtrls, ExtCtrls, IniFiles, WinSock, ComCtrls,
	List32, Login, CharaSel, Script, Game, Path, Database, Common,ShellApi, MonsterAI, Buttons, Zip, SQLData, FusionSQL;

const
	REALTIME_PRIORITY_CLASS = $100;                      
	HIGH_PRIORITY_CLASS = $80;
	ABOVE_NORMAL_PRIORITY_CLASS = $8000;
	NORMAL_PRIORITY_CLASS = $20;
	BELOW_NORMAL_PRIORITY_CLASS = $4000;
	IDLE_PRIORITY_CLASS = $40;
        WM_NOTIFYICON  = WM_USER+333;
		htTitleBtn = htSizeLast + 1;


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
    Button2: TButton;
    BackupTimer: TTimer;
                
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
		procedure CharaPassive(tc:TChara;Tick:cardinal);
                procedure SkillPassive(tc:TChara;Tick:Cardinal);
		procedure PetPassive(tc:TChara; _Tick:Cardinal);

		function  NPCAction(tm:TMap;tn:TNPC;Tick:cardinal) : Integer;

		procedure MobAI(tm:TMap;ts:TMob;Tick:cardinal);
		procedure MobMoveL(tm:TMap;Tick:cardinal);

		function  MobMoving(tm:TMap;ts:TMob;Tick:cardinal) : Integer;  //Spirit Sphere by Darkhelmet

		procedure MobAttack(tm:TMap;ts:TMob;Tick:cardinal);
		procedure StatEffect(tm:TMap; ts:TMob; Tick:Cardinal);

    procedure CreateField(tc:TChara; Tick:Cardinal);
		procedure SkillEffect(tc:TChara; Tick:Cardinal);
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

                //Iconify procedures
    procedure cmdMinTray(Sender: TObject);
    procedure CMClickIcon(var msg: TMessage); message WM_NOTIFYICON;
    procedure BackupTimerTimer(Sender: TObject);

		//procedure cbxPriorityClick(Sender: TObject);
    //procedure cbxPriorityChange(Sender: TObject);


	private

	public
		{ Public êÈåæ }
                // AlexKreuz Online Timer
                OnlineTime, ElapsedT: integer;
                ElapsedD, ElapsedH, ElapsedM, ElapsedS: double;
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
  i             :integer;
  j             :integer;
  w             :word;
	TickCheck     :array[0..9] of cardinal;
	dmg           :array[0..7] of integer;

        //Skill variables

        spbonus       :integer;
        //Icon
        TrayIcon      : TNotifyIconData;




implementation

{$R *.dfm}

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
  
begin

	Randomize;
	timeBeginPeriod(1);
	timeEndPeriod(1);
	SetLength(TrueBoolStrs, 4);
	TrueBoolStrs[0] := '1';
	TrueBoolStrs[1] := '-1';
	TrueBoolStrs[2] := 'true';
	TrueBoolStrs[3] := 'True';
	SetLength(FalseBoolStrs, 3);
	FalseBoolStrs[0] := '0';
	FalseBoolStrs[1] := 'false';
	FalseBoolStrs[2] := 'False';

	//NowAccountID := 0;
	NowUsers := 0;
	NowLoginID := 0;
	NowItemID := 10000;
	NowMobID := 1000000;
	NowCharaID := 0;
	//NowNPCID := 50000;

        NowPetID := 0;

	AppPath := ExtractFilePath(ParamStr(0));

	DebugOut := txtDebug;

	Caption := ' Fusion 1.2.1.0 CVS Release'; //ExtractFileName(ChangeFileExt(ParamStr(0), ''));

	ScriptList := TStringList.Create;

	ItemDB := TIntList32.Create;
	ItemDB.Sorted := true;
	ItemDBName := TStringList.Create;
	ItemDBName.CaseSensitive := True;

	MaterialDB := TIntList32.Create;
	MaterialDB.Sorted := true;

	MobDB := TIntList32.Create;
	MobDB.Sorted := true;

        MobAIDB := TIntList32.Create;
        MobAIDB.Sorted := true;

        //MobAIDBAegis:= TStringList.Create;
        //MobAIDBAegis.CaseSensitive := False;
        MobAIDBFusion := TIntList32.Create;
        MobAIDBFusion.Sorted := true;

        GlobalVars := TStringList.Create;

       // PharmacyDB := TIntList32.Create;
       // PharmacyDB.Sorted := true;

	MobDBName := TStringList.Create;
	MobDBName.CaseSensitive := True;
        SlaveDBName := TStringList.Create;
        SlaveDBName.CaseSensitive := True;

        {Arrow Creation Database}
        MArrowDB := TIntList32.Create;
        MArrowDB.Sorted := true;

        WarpDatabase := TStringList.Create;

        IDTableDB := TIntList32.Create;
        IDTableDB.Sorted := true;

	SkillDB := TIntList32.Create;
  SkillDBName := TStringList.Create;
	PlayerName := TStringList.Create;
	PlayerName.CaseSensitive := True;
	Player := TIntList32.Create;
	CharaName := TStringList.Create;
	CharaName.CaseSensitive := True;
	Chara := TIntList32.Create;
	CharaPID := TIntList32.Create;

	PartyNameList := TStringList.Create;
	PartyNameList.CaseSensitive := True;
  CastleList := TStringList.Create;
	CastleList.CaseSensitive := True;
  TerritoryList := TStringList.Create;
	TerritoryList.CaseSensitive := True;
  EmpList := TStringList.Create;
	EmpList.CaseSensitive := True;

	ChatRoomList := TIntList32.Create;

	VenderList := TIntList32.Create;

	DealingList := TIntList32.Create;

	PetDB  := TIntList32.Create;
        PetList := TIntList32.Create;

	{Chrstphr 2004/04/19 -- this list is now created/loaded in the
	DataLoad proc in the Database.pas module }
	//SummonMobList := TIntList32.Create;
	SummonMobListMVP := TIntList32.Create;

	SummonIOBList  := TStringList.Create;//Changed for lower memory/ease of use
	SummonIOVList  := TStringList.Create;//Ditto
	SummonICAList  := TStringList.Create;//
	SummonIGBList  := TStringList.Create;//
	SummonIOWBList := TStringList.Create;//

	ServerFlag := TStringList.Create;
	MapInfo    := TStringList.Create;

	GuildList := TIntList32.Create;
	GSkillDB := TIntList32.Create;

	Map := TStringList.Create;
	MapList := TStringList.Create;
	sl := TStringList.Create;
	sl.QuoteChar := '"';
	sl.Delimiter := ',';

	ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
	sl.Clear;
	ini.ReadSectionValues('Server', sl);

	sl1 := TStringList.Create;
	sl1.Delimiter := '.';
	sl1.DelimitedText := sl.Values['IP'];
	if sl1.Count = 4 then begin
		ServerIP := cardinal(inet_addr(PChar(sl.Values['IP'])));
	end else begin
		ServerIP := cardinal(inet_addr('127.0.0.1'));
		//ServerIP := $0100007f;
	end;
	if sl.IndexOfName('Name') > -1 then begin
		ServerName := sl.Values['Name'];
	end else begin
		ServerName := 'weiss';
	end;
	if sl.IndexOfName('NPCID') > -1 then begin
		DefaultNPCID := StrToInt(sl.Values['NPCID']);
	end else begin
		DefaultNPCID := 50000;
	end;
	NowNPCID := DefaultNPCID;
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
	if sl.IndexOfName('WarpDebug') > -1 then begin
		WarpDebugFlag := StrToBool(sl.Values['WarpDebug']);
	end else begin
		WarpDebugFlag := false;
	end;
	if sl.IndexOfName('BaseExpMultiplier') > -1 then begin
		BaseExpMultiplier := StrToInt(sl.Values['BaseExpMultiplier']);
        	if (BaseExpMultiplier > 999) then begin
            		BaseExpMultiplier := 999;
        	end;
	end else begin
		BaseExpMultiplier := 1;
	end;
	if sl.IndexOfName('JobExpMultiplier') > -1 then begin
		JobExpMultiplier := StrToInt(sl.Values['JobExpMultiplier']);
        	if (JobExpMultiplier > 999) then begin
            		JobExpMultiplier := 999;
        	end;
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
		DefaultMap := 'new_zone01';
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
                        Option_PVP := StrToBool(sl.Values['Option_PVP']);
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
	if sl.IndexOfName('Option_WelcomeMsg') > -1 then begin
                        Option_WelcomeMsg := StrToBool(sl.Values['Option_WelcomeMsg']);
                end else begin
                        Option_WelcomeMsg := True;
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
                        Option_Font_Color := '797979';
                end;
	if sl.IndexOfName('Option_Font_Size') > -1 then begin
                        Option_Font_Size := strtoint(sl.Values['Option_Font_Size']);
                end else begin
                        Option_Font_Size := 9;
                end;
	if sl.IndexOfName('Option_Font_Face') > -1 then begin
                        Option_Font_Face := sl.Values['Option_Font_Face'];
                end else begin
                        Option_Font_Face := 'Century Gothic';
                end;
	if sl.IndexOfName('Option_Font_Style') > -1 then begin
                        Option_Font_Style := sl.Values['Option_Font_Style'];
                end else begin
                        Option_Font_Style := 'B';
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
		FormWidth := 500;
	end;
	Width := FormWidth;
	if sl.IndexOfName('Height') <> -1 then begin
		FormHeight := StrToInt(sl.Values['Height']);
	end else begin
		FormHeight := 460;
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
	sl.Free;

	Show;
	//ÉfÅ[É^ì«Ç›çûÇ›
	DatabaseLoad(Handle);
	if UseSQL then
	  SQLDataLoad()
	else
	DataLoad();

	//MapLoad('moc_vilg00');
	//MapLoad('moc_vilg01');

        DebugOut.Lines.Add('');
	DebugOut.Lines.Add('Startup Success.');
        //DebugOut.Lines.SaveToFile('StartupLog.txt');

        //DebugOut.Lines.LoadFromFile('Fusion.notice');

        DebugOut.Lines.Add('');
        DebugOut.Lines.Add('--- Fusion Command Output Begin ---');
        DebugOut.Lines.Add('');

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
{U0x003bÉRÉRÇ‹Ç≈}
end;
//------------------------------------------------------------------------------
procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
	ini : TIniFile;
	sr  : TSearchRec;
	Idx : Integer; // Loop Iterator for freeing our global lists.
begin

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

	ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
	ini.WriteString('Server', 'IP', inet_ntoa(in_addr(ServerIP)));
	ini.WriteString('Server', 'Name', ServerName);
	ini.WriteString('Server', 'NPCID', IntToStr(DefaultNPCID));
	ini.WriteString('Server', 'sv1port', IntToStr(sv1port));
	ini.WriteString('Server', 'sv2port', IntToStr(sv2port));
	ini.WriteString('Server', 'sv3port', IntToStr(sv3port));
	ini.WriteString('Server', 'WarpDebug', BoolToStr(WarpDebugFlag, true));
	ini.WriteString('Server', 'BaseExpMultiplier', IntToStr(BaseExpMultiplier));
	ini.WriteString('Server', 'JobExpMultiplier', IntToStr(JobExpMultiplier));
	ini.WriteString('Server', 'DisableMonsterActive', BoolToStr(DisableMonsterActive, true));
	ini.WriteString('Server', 'AutoStart', BoolToStr(AutoStart, true));
	ini.WriteString('Server', 'DisableLevelLimit', BoolToStr(DisableLevelLimit, true));
	ini.WriteString('Server', 'EnableMonsterKnockBack', BoolToStr(EnableMonsterKnockBack, true));
	ini.WriteString('Server', 'DisableEquipLimit', BoolToStr(DisableEquipLimit, true));
	ini.WriteString('Server', 'ItemDropType', BoolToStr(ItemDropType, true));
	ini.WriteString('Server', 'ItemDropDenominator', IntToStr(ItemDropDenominator));
	ini.WriteString('Server', 'ItemDropPer', IntToStr(ItemDropPer));
	ini.WriteString('Server', 'ItemDropMultiplier', IntToStr(ItemDropMultiplier));
	ini.WriteString('Server', 'StealMultiplier', IntToStr(StealMultiplier));
	ini.WriteString('Server', 'DisableFleeDown', BoolToStr(DisableFleeDown, true));
	ini.WriteString('Server', 'EnablePetSkills', BoolToStr(EnablePetSkills, true));
	ini.WriteString('Server', 'EnableMonsterSkills', BoolToStr(EnableMonsterSkills, true));
	ini.WriteString('Server', 'EnableLowerClassDyes', BoolToStr(EnableLowerClassDyes, true));
	ini.WriteString('Server', 'DisableSkillLimit', BoolToStr(DisableSkillLimit, true));
	ini.WriteString('Server', 'DefaultZeny', IntToStr(DefaultZeny));
	ini.WriteString('Server', 'DefaultMap', DefaultMap);
	ini.WriteString('Server', 'DefaultPoint_X', IntToStr(DefaultPoint_X));
	ini.WriteString('Server', 'DefaultPoint_Y', IntToStr(DefaultPoint_Y));
	ini.WriteString('Server', 'DefaultItem1', IntToStr(DefaultItem1));
	ini.WriteString('Server', 'DefaultItem2', IntToStr(DefaultItem2));
	ini.WriteString('Server', 'DeathBaseLoss', IntToStr(DeathBaseLoss));
	ini.WriteString('Server', 'DeathJobLoss', IntToStr(DeathJobLoss));
	ini.WriteString('Server', 'MonsterMob', BoolToStr(MonsterMob, true));
	ini.WriteString('Server', 'SummonMonsterExp', BoolToStr(SummonMonsterExp, true));
	ini.WriteString('Server', 'SummonMonsterAgo', BoolToStr(SummonMonsterAgo, true));
	ini.WriteString('Server', 'SummonMonsterName', BoolToStr(SummonMonsterName, true));
	ini.WriteString('Server', 'SummonMonsterMob', BoolToStr(SummonMonsterMob, true));
	ini.WriteString('Server', 'Timer', BoolToStr(Timer, true));
	ini.WriteString('Server', 'GlobalGMsg', GlobalGMsg);
	ini.WriteString('Server', 'MapGMsg', MapGMsg);

	ini.WriteString('Option', 'Left', IntToStr(FormLeft));
	ini.WriteString('Option', 'Top', IntToStr(FormTop));
	ini.WriteString('Option', 'Width', IntToStr(FormWidth));
	ini.WriteString('Option', 'Height', IntToStr(FormHeight));
	ini.WriteString('Option', 'Priority', IntToStr(Priority));
	ini.WriteString('Option', 'Priority', IntToStr(Priority));

	// Fusion INI Lines
	ini.WriteString('Fusion', 'Option_PVP', BoolToStr(Option_PVP));
	ini.WriteString('Fusion', 'Option_MaxUsers', IntToStr(Option_MaxUsers));
	ini.WriteString('Fusion', 'Option_AutoSave', IntToStr(Option_AutoSave));
	ini.WriteString('Fusion', 'Option_AutoBackup', IntToStr(Option_AutoBackup));
	ini.WriteString('Fusion', 'Option_WelcomeMsg', BoolToStr(Option_WelcomeMsg));
	ini.WriteString('Fusion', 'Option_Username_MF', BoolToStr(Option_Username_MF));
	ini.WriteString('Fusion', 'Option_Back_Color', Option_Back_Color);
	ini.WriteString('Fusion', 'Option_Font_Color', Option_Font_Color);
	ini.WriteString('Fusion', 'Option_Font_Size', inttostr(Option_Font_Size));
	ini.WriteString('Fusion', 'Option_Font_Face', Option_Font_Face);
	ini.WriteString('Fusion', 'Option_Font_Style', Option_Font_Style);
	// Fusion INI Lines

	// MySQL Server Lines
	ini.WriteString('MySQL Server', 'Option_MySQL', BoolToStr(UseSQL));
	ini.WriteString('MySQL Server', 'MySQL_Address', DbHost);
	ini.WriteString('MySQL Server', 'MySQL_Username', DbUser);
	ini.WriteString('MySQL Server', 'MySQL_Password', DbPass);
	ini.WriteString('MySQL Server', 'MySQL_Database', DbName);
	// MySQL Server Lines

	ini.Free;

	if UseSQL then
		SQLDataSave
	else
		DataSave;

	{ Mitch: Doesnt hurt to make sure the tray icon was deleted }
	Shell_notifyIcon(NIM_DELETE, @TrayIcon);
	{ChrstphrR 2004/04/27 -- I'm pretty sure this cleans up the 4k a bare Delphi
	app leaks because code in the RTL that Borland hasn't fixed - Bravo!}

	ScriptList.Free; //CR only stores strings, ergo safe as is.

	{ChrstphrR 2004/04/27 - My apologies for such dirty fixes to the lists ...
	Objects[] of a TSL or TIL are not freed up on Clear or Free, so the following
	for loops do so safely and properly - the Assigned() checks ensure that the
	object isn't NIL -- freeing NIL is one of those Zen riddles you just don't
	want to toy with in Delphi!  The Lists are grouped with some not looped
	through, because there often pairs or groups of lists that index the same
	list of objects. Pure StringLists / IntLists are just free'd and are marked
	explicitly.}

	for Idx := ItemDB.Count-1 downto 0 do
		if Assigned(ItemDB.Objects[Idx]) then
			(ItemDB.Objects[Idx] AS TItemDB).Free;
	ItemDB.Free; //CR - Frees up 1.4Mb properly on close down that is leaked.
	ItemDBName.Free;

{ÉAÉCÉeÉÄêªë¢í«â¡}
	for Idx := MaterialDB.Count-1 downto 0 do
		if Assigned(MaterialDB.Objects[Idx]) then
			(MaterialDB.Objects[Idx] AS TMaterialDB).Free;
	MaterialDB.Free;
{ÉAÉCÉeÉÄêªë¢í«â¡ÉRÉRÇ‹Ç≈}
	for Idx := MobDB.Count-1 downto 0 do
		if Assigned(MobDB.Objects[Idx]) then
			(MobDB.Objects[Idx] AS TMobDB).Free;
	MobDB.Free;
	MobDBName.Free;

	for Idx := MArrowDB.Count-1 downto 0 do
		if Assigned(MArrowDB.Objects[Idx]) then
			(MArrowDB.Objects[Idx] AS TMArrowDB).Free;
	MArrowDB.Free;

	for Idx := WarpDatabase.Count-1 downto 0 do
		if Assigned(WarpDatabase.Objects[Idx]) then
			(WarpDatabase.Objects[Idx] AS TWarpDatabase).Free;
	WarpDatabase.Free;

	MobAIDB.Free; //CR - Empty list.

	for Idx := MobAIDBFusion.Count-1 downto 0 do
		if Assigned(MobAIDBFusion.Objects[Idx]) then
			(MobAIDBFusion.Objects[Idx] AS TMobAIDBFusion).Free;
	MobAIDBFusion.Free;

	GlobalVars.Free;
	//PharmacyDB.Free;

	for Idx := IDTableDB.Count-1 downto 0 do
		if Assigned(IDTableDB.Objects[Idx]) then
			(IDTableDB.Objects[Idx] AS TIDTbl).Free;
	IDTableDB.Free;

	for Idx := SlaveDBName.Count-1 downto 0 do
		if Assigned(SlaveDBName.Objects[Idx]) then
			(SlaveDBName.Objects[Idx] AS TSlaveDB).Free;
	SlaveDBName.Free;

	//CR - both of these are the same count, same objects - free objects on one
	// and leave the other objects[] list alone - only free the object once!! :)
	for Idx := SkillDB.Count-1 downto 0 do
		if Assigned(SkillDB.Objects[Idx]) then
			(SkillDB.Objects[Idx] AS TSkillDB).Free;
	SkillDB.Free;
	SkillDBName.Free;

	for Idx := Player.Count-1 downto 0 do
		if Assigned(Player.Objects[Idx]) then
			(Player.Objects[Idx] AS TPlayer).Free;
	Player.Free;
	PlayerName.Free;

	for Idx := Chara.Count-1 downto 0 do
		if Assigned(Chara.Objects[Idx]) then
			(Chara.Objects[Idx] AS TChara).Free;
	Chara.Free;
	CharaName.Free;
	CharaPID.Free;
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡}
	for Idx := ChatRoomList.Count-1 downto 0 do
		if Assigned(ChatRoomList.Objects[Idx]) then
			(ChatRoomList.Objects[Idx] AS TChatRoom).Free;
	ChatRoomList.Free;
{É`ÉÉÉbÉgÉãÅ[ÉÄã@î\í«â¡ÉRÉRÇ‹Ç≈}
{ÉpÅ[ÉeÉBÅ[ã@î\í«â¡}
	for Idx := PartyNameList.Count-1 downto 0 do
		if Assigned(PartyNameList.Objects[Idx]) then
			(PartyNameList.Objects[Idx] AS TParty).Free;
	PartyNameList.Free;

	for Idx := CastleList.Count-1 downto 0 do
		if Assigned(CastleList.Objects[Idx]) then
			(CastleList.Objects[Idx] AS TCastle).Free;
	CastleList.Free;

	for Idx := TerritoryList.Count-1 downto 0 do
		if Assigned(TerritoryList.Objects[Idx]) then
			(TerritoryList.Objects[Idx] AS TTerritoryDB).Free;
	TerritoryList.Free;

	for Idx := EmpList.Count-1 downto 0 do
		if Assigned(EmpList.Objects[Idx]) then
			(EmpList.Objects[Idx] AS TEmp).Free;
	EmpList.Free;
{ÉpÅ[ÉeÉBÅ[ã@î\í«â¡ÉRÉRÇ‹Ç≈}
{ÉLÉÖÅ[ÉyÉbÉg}
	for Idx := PetDB.Count-1 downto 0 do
		if Assigned(PetDB.Objects[Idx]) then
			(PetDB.Objects[Idx] AS TPetDB).Free;
	PetDB.Free;

	for Idx := PetList.Count-1 downto 0 do
		if Assigned(PetList.Objects[Idx]) then
			(PetList.Objects[Idx] AS TPet).Free;
	PetList.Free;
{ÉLÉÖÅ[ÉyÉbÉgÇ±Ç±Ç‹Ç≈}
{òIìXÉXÉLÉãí«â¡}
	for Idx := VenderList.Count-1 downto 0 do
		if Assigned(VenderList.Objects[Idx]) then
			(VenderList.Objects[Idx] AS TVender).Free;
	VenderList.Free;
{òIìXÉXÉLÉãí«â¡ÉRÉRÇ‹Ç≈}
{éÊà¯ã@î\í«â¡}

	for Idx := DealingList.Count-1 downto 0 do
		if Assigned(DealingList.Objects[Idx]) then
			(DealingList.Objects[Idx] AS TDealings).Free;
	DealingList.Free;
{éÊà¯ã@î\í«â¡ÉRÉRÇ‹Ç≈}
{éÅ{î†í«â¡}
	SummonMobList.Free;  //ChrstphrR - 2004/04/19 - This list is now leak free.
	SummonMobListMVP.Free; {CR - empty list 2004/04/23 - leaving be}

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
	SummonIOBList.Free; //Changed to TStringList
	SummonIOVList.Free; //" " "
	SummonICAList.Free; //" " "
	SummonIGBList.Free; //" " "
	SummonIOWBList.Free;//" " "
{éÅ{î†í«â¡ÉRÉRÇ‹Ç≈}
{NPCÉCÉxÉìÉgí«â¡}
	ServerFlag.Free;//Strings Only List - safe as is.

{NPCÉCÉxÉìÉgí«â¡ÉRÉRÇ‹Ç≈}
{ÉMÉãÉhã@î\í«â¡}
	for Idx := GuildList.Count-1 downto 0 do
		if Assigned(GuildList.Objects[Idx]) then
			(GuildList.Objects[Idx] AS TGuild).Free;
	GuildList.Free;

	//Static list loaded up at beginning, need to free properly at the end.
	for Idx := GSkillDB.Count-1 downto 0 do
		if Assigned(GSkillDB.Objects[Idx]) then
			(GSkillDB.Objects[Idx] AS TSkillDB).Free;
	GSkillDB.Free;
{ÉMÉãÉhã@î\í«â¡ÉRÉRÇ‹Ç≈}
	{ChrstphrR 2004/04/23 - Runtime list, Map list is filled up as characters
	move about in the game}
	for Idx := Map.Count-1 downto 0 do
		if Assigned(Map.Objects[Idx]) then
			(Map.Objects[Idx] AS TMap).Free;
	Map.Free;

	for Idx := MapInfo.Count-1 downto 0 do
		if Assigned(MapInfo.Objects[Idx]) then
			(MapInfo.Objects[Idx] AS MapTbl).Free;
	MapInfo.Free;

	for Idx := MapList.Count-1 downto 0 do
		if Assigned(MapList.Objects[Idx]) then
			(MapList.Objects[Idx] AS TMapList).Free;
	MapList.Free;
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
end;
//------------------------------------------------------------------------------
//procedure TfrmMain.cbxPriorityClick(Sender: TObject);
//var
	//PriorityClass	:cardinal;
//begin
	//Priority := cbxPriority.ItemIndex;
	//case Priority of
	//0: 		PriorityClass := REALTIME_PRIORITY_CLASS;
	//1: 		PriorityClass := HIGH_PRIORITY_CLASS;
	//2: 		PriorityClass := ABOVE_NORMAL_PRIORITY_CLASS;
	//3: 		PriorityClass := NORMAL_PRIORITY_CLASS;
	//4: 		PriorityClass := BELOW_NORMAL_PRIORITY_CLASS;
	//5: 		PriorityClass := IDLE_PRIORITY_CLASS;
	//else
		//begin
			//cbxPriority.ItemIndex := 3;
			//Priority := 3;
			//PriorityClass := NORMAL_PRIORITY_CLASS;
		//end;
	//end;

	//SetPriorityClass(GetCurrentProcess(), PriorityClass);
//end;
//==============================================================================





//==============================================================================
// ****************************************************************************
// * SERVER 1 : LOGIN SERVER (Port 6900)                                      *
// ****************************************************************************
//==============================================================================
procedure TfrmMain.sv1ClientConnect(Sender: TObject;
	Socket: TCustomWinSocket);
begin
	//DebugOut.Lines.Add(Socket.RemoteAddress + ': Login Server -> Connect');
end;
//------------------------------------------------------------------------------
procedure TfrmMain.sv1ClientDisconnect(Sender: TObject;
	Socket: TCustomWinSocket);
begin
	//DebugOut.Lines.Add(Socket.RemoteAddress + ': Login Server -> Disconnect');
end;
//------------------------------------------------------------------------------
procedure TfrmMain.sv1ClientError(Sender: TObject;
	Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
	var ErrorCode: Integer);
begin
        DebugOut.Lines.Add(Socket.RemoteAddress + ': Login Server -> Error: ' + inttostr(ErrorCode));
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
        //DebugOut.Lines.Add(Socket.RemoteAddress + ': Character Server -> Connect');
end;
//------------------------------------------------------------------------------
procedure TfrmMain.sv2ClientDisconnect(Sender: TObject;
	Socket: TCustomWinSocket);
begin
        //DebugOut.Lines.Add(Socket.RemoteAddress + ': Character Server -> Disconnect');
end;
//------------------------------------------------------------------------------
procedure TfrmMain.sv2ClientError(Sender: TObject;
	Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
	var ErrorCode: Integer);
begin
        DebugOut.Lines.Add(Socket.RemoteAddress + ': Character Server -> Error: ' + inttostr(ErrorCode));
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
	//DebugOut.Lines.Add(Socket.RemoteAddress + ': Game Server -> Connect');
	NowUsers := sv3.Socket.ActiveConnections;
        statusbar1.Panels.Items[0].Text := ' Users Online: ' +inttostr(NowUsers); // AlexKreuz (Status Bar)
end;
//------------------------------------------------------------------------------
procedure TfrmMain.sv3ClientDisconnect(Sender: TObject;
	Socket: TCustomWinSocket);
var
	tc  :TChara;
	tp  :TPlayer;

	i,j :integer;
	mi  :MapTbl;

begin

        // AlexKreuz: Random 10053 Bug Fix
        if Assigned(Socket.Data) then begin
        	tc := Socket.Data;
        	SendCLeave(tc, 2);
                {NPCÉCÉxÉìÉgí«â¡}
        	i := MapInfo.IndexOf(tc.Map);
        	j := -1;
        	if (i <> -1) then begin
        		mi := MapInfo.Objects[i] as MapTbl;
        		if (mi.noSave = true) then j := 0;
        	end;
        	if (tc.Sit = 1) or (j = 0) then begin
                        {NPCÉCÉxÉìÉgí«â¡ÉRÉRÇ‹Ç≈}
        		tc.Map := tc.SaveMap;
        		tc.Point.X := tc.SavePoint.X;
        		tc.Point.Y := tc.SavePoint.Y;
        	end;
        	tc.Login := 0;
        	tp := tc.PData;
        	tp.Login := 0;
                if UseSQL then SQLDataSave();
        end;

        // AlexKreuz: Random 10053 Bug Fix
        //DebugOut.Lines.Add(Socket.RemoteAddress + ': Game Server -> Disconnect');
        NowUsers := sv3.Socket.ActiveConnections;
        if NowUsers > 0 then Dec(NowUsers);
        statusbar1.Panels.Items[0].Text := ' Users Online: ' +inttostr(NowUsers); // AlexKreuz (Status Bar)

end;
//------------------------------------------------------------------------------
procedure TfrmMain.sv3ClientError(Sender: TObject;
	Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
	var ErrorCode: Integer);
//var
//	tc  :TChara;
//	tp  :TPlayer;
begin
	DebugOut.Lines.Add(Socket.RemoteAddress + ': Game Server -> Error: ' + inttostr(ErrorCode));
	if UseSQL then SQLDataSave();
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

{Spawn Monster}
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
          ts1.isSlave := true;
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
	mvpid:integer;
	mvpitem:boolean;
	mvpcheck:integer;
	i1,j1,k1:integer;
	l,w:cardinal;
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
				WFIFOW( 0, $010b);
				WFIFOL( 2, ts.Data.MEXP * BaseExpMultiplier);
				tc1.Socket.SendBuf(buf, 6);
			end;
		end;
	end;


	tpaDB := TStringList.Create;
	for i := 0 to n - 1 do begin
		tc1 := ts.EXPDist[i].CData;
		//ÉçÉOÉAÉEÉgÇµÇƒÇ¢ÇÈÅAéÄÇÒÇ≈Ç¢ÇÈÅAï ÇÃÉ}ÉbÉvÇ…Ç¢ÇÈÅAÇ¢Ç∏ÇÍÇ©ÇÃèÍçáåoå±ílÇÕì¸ÇÁÇ»Ç¢
		if (tc1.Login <> 2) or (tc1.Sit = 1) or (tc1.Map <> tm.Name) then
			Continue;
		//ÉxÅ[ÉXåoå±íl
		l := 100 * Cardinal(ts.EXPDist[i].Dmg) div total;
		l := ts.Data.EXP * l div 100;
		if n <> 1 then Inc(l);
		if i = mvpid then l := l + ts.Data.MEXP; //MVP
		l := l * BaseExpMultiplier;
		if tc.Skill[307].Tick > Tick then l := l * cardinal(tc.Skill[307].Effect1 div 100);
		//ÉWÉáÉuåoå±íl

		w := ts.Data.JEXP * (cardinal(ts.EXPDist[i].Dmg) div total);

		if n <> 1 then Inc(w);
		if i = mvpid then w := w + ts.Data.MEXP; //MVP
		w := w * JobExpMultiplier;
		if tc.Skill[307].Tick > Tick then w := w * cardinal(tc.Skill[307].Effect1 div 100);

		j := GuildList.IndexOf(tc.GuildID);
		if (j <> -1) then begin
			tg := GuildList.Objects[j] as TGuild;
			ge := l * tg.PosEXP[tc1.GuildPos] div 100;
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
			if tpa.EXPShare = 1 then begin
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
			crit := boolean((SkillPer = 0) and (Random(100) < Critical - ts.Data.LUK * 0.2));
		end else begin //ìÒìÅó¨âEéË
			crit := boolean(dmg[5] = 10);
		end;
		miss := boolean((Random(100) >= i) and (not crit));
		//DAÉ`ÉFÉbÉN
		if NOT miss and (Arms = 0) and (SkillPer = 0) and (Random(100) < DAPer) then begin
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


		if (tc.GungnirEquipped) and (25 >= Random(100)) then begin
			tc.MTarget := tc.ATarget;
			ts := tm.Mob.IndexOfObject(tc.MTarget) as TMob;

			tc.MTargetType := 0;
			tc.AData := ts;

			i := Random(4);
			case i of
			0:  tc.MSkill := 5;       {Bash}
			1:  tc.MSkill := 7;       {Magnum Break}
			2:  tc.MSkill := 56;      {Pierce}
			3:  tc.MSkill := 59;      {Spear Boomerang}
			end;//case

			tc.MUseLV := Random(10) + 1;
			SkillEffect(tc, Tick);
			Exit;//safe 2004/04/27
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
					tc.MPoint.X := tc.Point.X;
					tc.MPoint.Y := tc.Point.Y;
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

	//DebugOut.Lines.Add(Format('DMG %d%% %d(%d-%d)', [dmg[6], dmg[0], dmg[1], dmg[2]]));
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
			//DebugOut.Lines.Add('Targeted: ' + inttostr(i));
			if i > 12 then i := 12;
			if i < 2 then i := 2;
			tc.TargetedFix := 12 - i;
			tc.TargetedTick := Tick;
		end;
	end;

	with ts.Data do begin
                if ts.Stat2 <> 4 then CalcAI(tm, ts, Tick);
                if ts.Hidden = true then exit;
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
							DelSkillUnit(tm, tn);
							Dec(i1);
						end;
						//DebugOut.Lines.Add('Safety Wall OK >>' + IntToStr(tn.Count));
						dmg[6] := 0;
					end;
				$85: // Pneuma
					begin
						if ts.Data.Range1 >= 4 then miss := true;
						//DebugOut.Lines.Add('Pneuma OK');
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

		if tc.Stat1 = 2 then i := 21 // Frozen?  Water 1
		else if tc.Stat1 = 1 then i := 22 // Stone?  Earth 1
    else if tc.ArmorElement <> 0 then i := tc.ArmorElement
    else i := 1;

    dmg[0] := dmg[0] * ElementTable[0][i] div 100;

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
	//DebugOut.Lines.Add(Format('REV %d%% %d(%d-%d)', [dmg[6], dmg[0], dmg[1], dmg[2]]));
end;
//------------------------------------------------------------------------------

{Player Attacking Player}
procedure TFrmMain.DamageCalc3(tm:TMap; tc:TChara; tc1:TChara; Tick:cardinal; Arms:byte = 0; SkillPer:integer = 0; AElement:byte = 0; HITFix:integer = 0);
var
	i,m,i1 :integer;
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
                            //DebugOut.Lines.Add('Pneuma OK');
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
					m := tc1.DEF1 + tc1.DEF2 + tc1.DEF3;
				end;
				dmg[3] := dmg[3] + Random((dmg[3] div 20) * (dmg[3] div 20)); //Def+DefBonus
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
	end;
	//èÛë‘ÇPÇÕâ£ÇÈÇ∆é°ÇÈ
	if tc1.Stat1 <> 0 then begin
		tc1.BodyTick := Tick + tc.aMotion;
	end;
	//DebugOut.Lines.Add(Format('DMG %d%% %d(%d-%d)', [dmg[6], dmg[0], dmg[1], dmg[2]]));
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
				//DebugOut.Lines.Add('Monster Knockback!');
				SendMMove(tc.Socket, ts, ts.Point, ts.tgtPoint,tc.ver2);
				SendBCmd(tm, ts.Point, 58, tc,True);
			end;
			ts.DmgTick := 0;
		end;
		xy := ts.Point;
    ts.CanFindTarget := true;
		{ Alex: Monster searching for attack path towards player - checks attackrange over cliffs and sightrange w/o cliffs. }
		if ( (Path_Finding(ts.path, tm, xy.X, xy.Y, tc.Point.X, tc.Point.Y, 2) <> 0) and (abs(xy.X - tc.Point.X) <= ts.Data.Range1) and (abs(xy.Y - tc.Point.Y) <= ts.Data.Range1) and (ts.Data.Range1 >= MONSTER_ATK_RANGE) ) or
		( (Path_Finding(ts.path, tm, xy.X, xy.Y, tc.Point.X, tc.Point.Y, 1) <> 0) and (abs(xy.X - tc.Point.X) <= ts.Data.Range2) and (abs(xy.Y - tc.Point.Y) <= ts.Data.Range2) ) then begin
			if (ts.ATarget = 0) or (ts.isActive) then begin
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
	i :integer;
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
				//DebugOut.Lines.Add('Character Knockback!');
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
                tc1.Sit := 1;
                tc1.HP := 0;
                SendCStat1(tc1, 0, 5, tc1.HP);
                WFIFOW(0, $0080);
                WFIFOL(2, tc1.ID);
                WFIFOB(6, 1);
                tc1.Socket.SendBuf(buf, 7);
                WFIFOW( 0, $0080);
                WFIFOL( 2, tc1.ID);
                WFIFOB( 6, 1);
                 SendBCmd(tm, tc1.Point, 7);
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
	tn:TNPC;
  tn1:TNPC;
	i,j:Integer;
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
                                                        //DebugOut.Lines.Add(Format('		Chara %s Delete', [tc1.Name]));
                                                        WFIFOW(0, $0080);
                                                        WFIFOL(2, ID);
                                                        WFIFOB(6, 0);
                                                        tc1.Socket.SendBuf(buf, 7);
                                                end;
                                                if ((dx <> 0) and (abs(Point.Y - tc1.Point.Y) < 16) and (Point.X = tc1.Point.X - dx * 15)) or
                                                ((dy <> 0) and (abs(Point.X - tc1.Point.X) < 16) and (Point.Y = tc1.Point.Y - dy * 15)) then begin
                                                        //èoåªí ím
                                                        //DebugOut.Lines.Add(Format('		Chara %s Add', [tc1.Name]));
                                                        SendNData( tc1.Socket, tn, tc1.ver2 );
                                                        //à⁄ìÆí ím
                                                        if (abs(Point.X - tc1.Point.X) < 16) and (abs(Point.Y - tc1.Point.Y) < 16) then begin
                                                                //DebugOut.Lines.Add(Format('		Chara %s Move (%d,%d)-(%d,%d)', [Name, xy.X, xy.Y, Point.X, Point.Y]));
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
        {Random Integers}
	j,k,m,n,o :Integer;
	spd:integer;
	xy:TPoint;
	dx,dy:integer;
        i :Integer;
	w :word;

        {Class Usage}
	tm:TMap;  //Map
	tn:TNPC;
	tc1:TChara;  //Player
        tl:TSkillDB;  //Skill Database
	ts:TMob;  //Monster
	tcr :TChatRoom;

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
			//DebugOut.Lines.Add(Format('		Move %d/%d (%d,%d) %d %d %d', [ppos, pcnt, Point.X, Point.Y, Path[ppos-1], spd, Tick]));

			//ÉuÉçÉbÉNèàóù1
			for n := xy.Y div 8 - 2 to xy.Y div 8 + 2 do begin
				for m := xy.X div 8 - 2 to xy.X div 8 + 2 do begin //é©ï™ÇÃãèÇÈÉuÉçÉbÉNÇÕèàóùÇ∑ÇÈïKóvÇÕÇ»Ç¢(ñ¢)
					//NPCí ím
					for k := 0 to tm.Block[m][n].NPC.Count - 1 do begin
						tn := tm.Block[m][n].NPC.Objects[k] as TNPC;
						if ((dx <> 0) and (abs(xy.Y - tn.Point.Y) < 16) and (xy.X = tn.Point.X + dx * 15)) or
						((dy <> 0) and (abs(xy.X - tn.Point.X) < 16) and (xy.Y = tn.Point.Y + dy * 15)) then begin
							//DebugOut.Lines.Add(IntToStr(tn.Item.Identify));
              //è¡ñ≈í ím
							//DebugOut.Lines.Add(Format('		NPC %s Delete', [tn.Name]));
							if tn.CType = 3 then begin
								WFIFOW(0, $00a1);
								WFIFOL(2, tn.ID);
								Socket.SendBuf(buf, 6);
							end else if tn.CType = 4 then begin
								WFIFOW(0, $0120);
								WFIFOL(2, tn.ID);
								Socket.SendBuf(buf, 6);
							end else begin
								WFIFOW(0, $0080);
								WFIFOL(2, tn.ID);
								WFIFOB(6, 0);
								Socket.SendBuf(buf, 7);
							end;
						end;
						if ((dx <> 0) and (abs(Point.Y - tn.Point.Y) < 16) and (Point.X = tn.Point.X - dx * 15)) or
						((dy <> 0) and (abs(Point.X - tn.Point.X) < 16) and (Point.Y = tn.Point.Y - dy * 15)) then begin
							//èoåªí ím
							//DebugOut.Lines.Add(Format('		NPC %s Add', [tn.Name]));
              //if tn.CType = 2 then begin
              //SendNData(Socket, tn, tc.ver2);
              //end;
							if (tn.Enable = true) then begin
                SendNData(Socket, tn, tc.ver2);
								if (tn.ScriptInitS <> -1) and (tn.ScriptInitD = false) then begin
									//OnInitÉâÉxÉãÇé¿çs
									//DebugOut.Lines.Add(Format('OnInit Event(%d)', [tn.ID]));
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
									//É`ÉÉÉbÉgÉãÅ[ÉÄÇï\é¶Ç∑ÇÈ
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
					//ÉvÉåÉCÉÑÅ[ä‘í ím
					for k := 0 to tm.Block[m][n].CList.Count - 1 do begin
						tc1 := tm.Block[m][n].CList.Objects[k] as TChara;
						if tc <> tc1 then begin //é©ï™ìØémÇ≈ÇÕí ímÇµÇ»Ç¢ÇÊÇ§Ç…ÅB
						if ((dx <> 0) and (abs(xy.Y - tc1.Point.Y) < 16) and (xy.X = tc1.Point.X + dx * 15)) or
						((dy <> 0) and (abs(xy.X - tc1.Point.X) < 16) and (xy.Y = tc1.Point.Y + dy * 15)) then begin
							//è¡ñ≈í ím
							//DebugOut.Lines.Add(Format('		Chara %s Delete', [tc1.Name]));
							WFIFOW(0, $0080);
							WFIFOL(2, ID);
							WFIFOB(6, 0);
							tc1.Socket.SendBuf(buf, 7);
							WFIFOL(2, tc1.ID);
							Socket.SendBuf(buf, 7);
						end;
						if ((dx <> 0) and (abs(Point.Y - tc1.Point.Y) < 16) and (Point.X = tc1.Point.X - dx * 15)) or
						((dy <> 0) and (abs(Point.X - tc1.Point.X) < 16) and (Point.Y = tc1.Point.Y - dy * 15)) then begin
							//èoåªí ím
							//DebugOut.Lines.Add(Format('		Chara %s Add', [tc1.Name]));
							SendCData(tc, tc1);
							SendCData(tc1, tc);



							//à⁄ìÆí ím
							if (abs(Point.X - tc1.Point.X) < 16) and (abs(Point.Y - tc1.Point.Y) < 16) then begin
								//DebugOut.Lines.Add(Format('		Chara %s Move (%d,%d)-(%d,%d)', [Name, xy.X, xy.Y, Point.X, Point.Y]));
								SendCMove(tc1.Socket, tc, Point, tgtPoint);
							end;
						end;
					end;
				end;
				//ÉÇÉìÉXÉ^Å[í ím
				for k := 0 to tm.Block[m][n].Mob.Count - 1 do begin
          if ((tm.Block[m][n].Mob.Objects[k] is TMob) = false) then continue;
					ts := tm.Block[m][n].Mob.Objects[k] as TMob;
					if ((dx <> 0) and (abs(xy.Y - ts.Point.Y) < 16) and (xy.X = ts.Point.X + dx * 15)) or
					((dy <> 0) and (abs(xy.X - ts.Point.X) < 16) and (xy.Y = ts.Point.Y + dy * 15)) then begin
						//è¡ñ≈í ím
						//DebugOut.Lines.Add(Format('		Mob %s Delete', [ts.Name]));
                                                UpdateMonsterDead(tm, ts, 0);
						{WFIFOW(0, $0080);
						WFIFOL(2, ts.ID);
						WFIFOB(6, 0);
						Socket.SendBuf(buf, 7);}
					end;
					if ((dx <> 0) and (abs(Point.Y - ts.Point.Y) < 16) and (Point.X = ts.Point.X - dx * 15)) or
					((dy <> 0) and (abs(Point.X - ts.Point.X) < 16) and (Point.Y = ts.Point.Y - dy * 15)) then begin
						//èoåªí ím
						//DebugOut.Lines.Add(Format('		Mob %s Add', [ts.Name]));
						SendMData(Socket, ts);
						//à⁄ìÆí ím
						if (ts.pcnt <> 0) and (abs(Point.X - ts.Point.X) < 16) and (abs(Point.Y - ts.Point.Y) < 16) then begin
				SendMMove(Socket, ts, ts.Point, ts.tgtPoint,ver2);
						end;
					end;
				end;
			end;
		end;

		//ÉuÉçÉbÉNà⁄ìÆ
		if (xy.X div 8 <> Point.X div 8) or (xy.Y div 8 <> Point.Y div 8) then begin
			//DebugOut.Lines.Add(Format('		BlockMove (%d,%d)-(%d,%d)', [xy.X div 8, xy.Y div 8, Point.X div 8, Point.Y div 8]));
			//à»ëOÇÃÉuÉçÉbÉNÇÃÉfÅ[É^è¡ãé
			with tm.Block[xy.X div 8][xy.Y div 8].CList do begin
				//DebugOut.Lines.Add('BlockDelete ' + inttostr(IndexOf(IntToStr(ID))));
				Delete(IndexOf(ID));
			end;
			//êVÇµÇ¢ÉuÉçÉbÉNÇ…ÉfÅ[É^í«â¡
			tm.Block[Point.X div 8][Point.Y div 8].CList.AddObject(ID, tc);
			//DebugOut.Lines.Add('		BlockMove OK');
	end;

	if (tm.gat[Point.X][Point.Y] <> 1) and (tm.gat[Point.X][Point.Y] <> 5) then begin
			//ÉèÅ[ÉvÉ|ÉCÉìÉgÇ…ì¸Ç¡ÇΩ
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
						end;
					end;
				end;
			end;

			if ppos = pcnt then begin
				//à⁄ìÆäÆóπ
				Sit := 3;
				if (tc.Skill[144].Lv = 0) then HPTick := Tick;
				HPRTick := Tick - 500;
				SPRTick := Tick;
				pcnt := 0;
				//çUåÇìÆçÏÇÇ∑ÇÈèÍçáÅAéÀíˆÉ`ÉFÉbÉN
				{
				if (AMode = 1) or (AMode = 2) then begin
					ts := AData;
					if (abs(Point.X - ts.Point.X) > Range) or (abs(Point.Y - ts.Point.Y) > Range) then begin
						//éÀíˆäOÇ»ÇÁÅAëäéËÇÃà⁄ìÆñ⁄ïWínÇ÷à⁄ìÆÇ∑ÇÈ
						NextFlag := true;
						NextPoint := ts.tgtPoint;
					end;
				end;
				}
				//DebugOut.Lines.Add(Format('		Move OK', [ID]));
				break;
			end;
			MoveTick := MoveTick + cardinal(spd);
		end;
	end;
{í«â¡}
	Result := False;
{í«â¡ÉRÉRÇ‹Ç≈}

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
  td:TItemDB;
  found:boolean;
  tpe:TPet;
  tn:TNPC;
  tn1:TNPC;
begin
	with tc do begin
		ts := AData;
		tm := MData;
                if ts.Hidden = True then exit;  //Monster is hidden so you can't hit it.

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
        StealItem(tc, ts);
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
	i1,j1,k1,k:integer;
	tm:TMap;
	ts:TMob;
	ts1:TMob;
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
                    end;

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
	i1,j1,k1,k:integer;
	tm:TMap;
	ts:TMob;
	ts1:TMob;
	xy:TPoint;
  sl:TStringList;
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
{ChrstphrR 2004/04/27 - Memory Leak fixed - free of leaks.}
procedure TfrmMain.CharaSplash2(tc:TChara;Tick:cardinal);
var
	i1,j1,k1,k:integer;
	tm:TMap;
	ts:TMob;
	ts1:TMob;
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
	j,k,m,b:Integer;
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
				//DebugOut.Lines.Add(Format('FireWall: (%d,%d) %d', [xy.X, xy.Y, b]));

				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				tn := SetSkillUnit(tm, ID, xy, Tick, $7f, tl.Data2[MUseLV], tl.Data2[MUseLV] * 1000);
				tn.CData := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;
				SetLength(bb, 1);
				bb[0] := 2;
				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $7f, tl.Data2[MUseLV], tl.Data2[MUseLV] * 1000);
				tn.CData := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				bb[0] := 6;
				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $7f, tl.Data2[MUseLV], tl.Data2[MUseLV] * 1000);
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
				tn := SetSkillUnit(tm, ID, xy, Tick, $86, 0, 3000, tc);
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;
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
				//DebugOut.Lines.Add(Format('IceWall: (%d,%d) %d', [xy.X, xy.Y, b]));
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
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				//SetLength(bb, 1);

				bb[0] := 2;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $8d, tl.Data2[MUseLV], MUseLV * 5000);
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $8d, tl.Data2[MUseLV], MUseLV * 5000);
				tn.CData  := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				bb[0] := 6;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $8d, tl.Data2[MUseLV], MUseLV * 5000);
				tn.CData := tc;
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				DirMove(tm, xy, b, bb);
				tn := SetSkillUnit(tm, ID, xy, Tick, $8d, tl.Data2[MUseLV], MUseLV * 5000);
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
				tn := SetSkillUnit(tm, ID, xy, Tick, $86, 0, 3000, tc);
				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;
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
				xy.X := MPoint.X;
				xy.Y := MPoint.Y;
				for i := 0 to 8 do begin;
					MPoint.Y := - 4 + MPoint.Y + i;
					MPoint.X := - 4 + MPoint.X + i;
					tn := SetSkillUnit(tm, ID, xy, Tick, $89, 0, MUseLv*5000,tc);
				end;

				tn.MSkill := MSkill;
				tn.MUseLV := MUseLV;

				for i := 0 to 4 do begin;
					WFIFOW( 0, $0117);
					WFIFOW( 2, MSkill);
					WFIFOL( 4, ID);
					WFIFOW( 8, MUseLV);
					WFIFOW(10, (-2 + MPoint.X + i));
					WFIFOW(12, (MPoint.Y));
					WFIFOL(14, 1);
					SendBCmd(tm, xy, 18);
				end;

				for i := 0 to 4 do begin;
					WFIFOW( 0, $0117);
					WFIFOW( 2, MSkill);
					WFIFOL( 4, ID);
					WFIFOW( 8, MUseLV);
					WFIFOW(10, (-2 + MPoint.X + i));
					WFIFOW(12, (MPoint.Y - 2));
					WFIFOL(14, 1);
					SendBCmd(tm, xy, 18);
				end;

				for i := 0 to 4 do begin;
					WFIFOW( 0, $0117);
					WFIFOW( 2, MSkill);
					WFIFOL( 4, ID);
					WFIFOW( 8, MUseLV);
					WFIFOW(10, (-2 + MPoint.X + i));
					WFIFOW(12, (MPoint.Y - 1));
					WFIFOL(14, 1);
					SendBCmd(tm, xy, 18);
				end;

				for i := 0 to 4 do begin;
					WFIFOW( 0, $0117);
					WFIFOW( 2, MSkill);
					WFIFOL( 4, ID);
					WFIFOW( 8, MUseLV);
					WFIFOW(10, (-2 + MPoint.X + i));
					WFIFOW(12, (MPoint.Y + 1));
					WFIFOL(14, 1);
					SendBCmd(tm, xy, 18);
				end;

				for i := 0 to 4 do begin;
					WFIFOW( 0, $0117);
					WFIFOW( 2, MSkill);
					WFIFOL( 4, ID);
					WFIFOW( 8, MUseLV);
					WFIFOW(10, (-2 + MPoint.X + i));
					WFIFOW(12, (MPoint.Y + 2));
					WFIFOL(14, 1);
					SendBCmd(tm, xy, 18);
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


//------------------------------------------------------------------------------
{ChrstphrR 2004/04/27 - Memory Leak Fixes}
procedure TfrmMain.SkillEffect(tc:TChara; Tick:Cardinal);
var
	j,k,m,b         :Integer;
	l               :integer;
	i1,j1,k1        :integer;
	tm              :TMap;
	mi              :MapTbl;
	tc1             :TChara;
	tc2             :TChara;
	ts              :TMob;
	ts1             :TMob;
  td              :TItemDB;
  tg              :TGuild;
	tl              :TSkillDB;
	xy              :TPoint;
	bb              :array of byte;
	tpa             :TParty;
	sl              :TStringList;
  ma              :TMArrowDB;
  tma             :TMaterialDB;
  ProcessType     :Byte;
  DamageProcessed :boolean;
  tn :TNPC;

begin
	ProcessType := 0;

  if tc.Skill[269].Tick > Tick then begin  //Check if BladeStop is active
    case tc.Skill[269].Effect1 of
		1: Exit;
      2: if tc.MSkill <> 267 then exit;
      3: if ((tc.MSkill <> 267) and (tc.MSkill <> 266)) then exit;
      4: if ((tc.MSkill <> 267) and (tc.MSkill <> 266) and (tc.MSkill <> 273)) then exit;
      5: if ((tc.MSkill <> 267) and (tc.MSkill <> 266) and (tc.MSkill <> 273) and (tc.MSkill <> 271)) then exit;
		end;//case -- all exits here are safe 2004/04/27
  end;
        if tc.isSilenced then begin
                SilenceCharacter(tm, tc, Tick);
		Exit;//safe 2004/04/27
        end;

	{ChrstphrR 2004/04/26 -- moved this away from the first Exit calls.}
	sl := TStringList.Create;

	with tc do begin
		tm := MData;
		tL := Skill[MSkill].Data;
    mi := MapInfo.Objects[MapInfo.IndexOf(tm.Name)] as MapTbl;
    if MTargetType = 0 then begin
			ts := tc.AData;

			if tL = NIL then begin
				sl.Free;
				Exit;//safe 2004/04/26
			end;

      if (ts is TMob) and (PassiveAttack = false) then begin // Edited by AlexKreuz
        if ts.isEmperium then begin
          j := GuildList.IndexOf(tc.GuildID);
          if (j <> -1) then begin
            tg := GuildList.Objects[j] as TGuild;
            if ((tg.GSkill[10000].Lv < 1) or ((ts.GID = tc.GuildID) and (tc.GuildID <> 0))) then begin
              MSkill := 0;
              MUseLv := 0;
              MMode := 0;
              MTarget := 0;
							sl.Free;
							Exit;//safe 2004/04/26
            end;
          end;
        end;

        if ((ts.isGuardian = tc.GuildID) and (tc.GuildID <> 0)) then begin //added by The Harbinger -- darkWeiss version
          MSkill := 0;
          MUseLv := 0;
          MMode := 0;
          MTarget := 0;
					sl.Free;
					Exit;//safe 2004/04/26
        end;
      end;

      if (ts = nil) or (ts.HP = 0) and (PassiveAttack = False) then begin
				MSkill := 0;
				MUseLv := 0;
				MMode := 0;
				MTarget := 0;
				sl.Free;
				Exit;//safe 2004/04/26
			end;

			//éÀíˆÉ`ÉFÉbÉN
			if (abs(tc.Point.X - ts.Point.X) <= tl.Range) and (abs(tc.Point.Y - ts.Point.Y) <= tl.Range) then begin

			case MSkill of  {Skill Used Against Monster}

                                //Blacksmith
                                {110:    Hammer Fall
                                if (tc.Weapon = 6) or (tc.Weapon = 7) then begin
                                        xy.X := MPoint.X;
                                        xy.Y := MPoint.Y;
                                        WFIFOW( 0, $0117);
                                        WFIFOW( 2, MSkill);
                                        WFIFOL( 4, ID);
                                        WFIFOW( 8, MUseLV);
                                        WFIFOW(10, xy.X);
                                        WFIFOW(12, xy.Y);
                                        WFIFOL(14, 1);
                                        if Random(100) < Skill[110].Data.Data1[MUseLV] then begin
                                                if (ts.Stat1 <> 3) then begin
                                                        ts.nStat := 3;
                                                        ts.BodyTick := Tick + tc.aMotion;
                                                end else begin
                                                        ts.BodyTick := ts.BodyTick + 30000;
                                                end;
                                        end else begin
					      	tc.MMode := 4;
					     	tc.MPoint.X := 0;
					    	tc.MPoint.Y := 0;
                                        end;
                                end else begin
                                        tc.MMode := 4;
                                        tc.MPoint.X := 0;
                                        tc.MPoint.Y := 0;
                                end;}

                                50:     {Steal}
                                begin
                                  {Colus, 20040305: Redid it all.  Again.  Using info on formulas obtained
                                   from fansites and confirmations on algorithm from disassemblers.}
                                  if not (StealItem(tc, ts)) then begin
                                    SendSkillError(tc, 0);

                                    tc.MMode := 4;
                                    tc.MPoint.X := 0;
                                    tc.MPoint.Y := 0;
                                    DecSP(tc, 50, MUseLV);
                                  end;
                                  // Delay after stealing
                                  tc.MTick := Tick + 1000;

				end; {end Steal}

                                250:    {Shield Charge}
                                begin
					if (tc.Shield > 0) then begin
                                        {If Wearing Shield}
                                                xy.X := ts.Point.X - Point.X;
						xy.Y := ts.Point.Y - Point.Y;
						if abs(xy.X) > abs(xy.Y) * 3 then begin
							//â°å¸Ç´
							if xy.X > 0 then
                                                                b := 6
                                                        else
                                                                b := 2;
                                                end
                                                else if abs(xy.Y) > abs(xy.X) * 3 then begin
                                                        //ècå¸Ç´
							if xy.Y > 0 then
                                                                b := 0
                                                        else
                                                                b := 4;
                                                end
                                                else begin
                                                        if xy.X > 0 then begin
								if xy.Y > 0 then
                                                                        b := 7
                                                                else
                                                                        b := 5;
                                                        end else begin
                                                                if xy.Y > 0 then
                                                                        b := 1
                                                                else
                                                                        b := 3;
							end;
						end;

						//íeÇ´îÚÇŒÇ∑ëŒè€Ç…ëŒÇ∑ÇÈÉ_ÉÅÅ[ÉWÇÃåvéZ
						DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						if dmg[0] < 0 then
                                                        dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
                                                //ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, 6);
							bb[0] := 6;
							xy := ts.Point;
							DirMove(tm, ts.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
										Assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(ts.ID));
								end;
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end;
							ts.pcnt := 0;
							//Update Monster Location
                                                        UpdateMonsterLocation(tm, ts);
						end;
                                                if Random(100) < Skill[250].Data.Data2[MUseLV] then begin
                                                        if (ts.Stat1 <> 3) then begin
								ts.nStat := 3;
								ts.BodyTick := Tick + tc.aMotion;
                                                        end
                                                        else
                                                                ts.BodyTick := ts.BodyTick + 30000;
                                                end;
						if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							StatCalc1(tc, ts, Tick);
                                        end;
                                end;
                                251:    {Shield Boomerang}
                                begin
                                        if (tc.Shield <> 0) then begin
                                                DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then
                                                        dmg[0] := 0;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
						if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							StatCalc1(tc, ts, Tick);
              tc.MTick := Tick + 1000;
                                        end else begin
                                                tc.MMode := 4;
                                                tc.MPoint.X := 0;
                                                tc.MPoint.Y := 0;
						sl.Free;
						Exit;//safe 2004/04/26
                                        end;
                                end;
                                230:  //acid terror
                                         begin
                                                j := SearchCInventory(tc, 7136, false);
						if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
                                                        UseItem(tc, j); //Use Item Function Call
                                                DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then
                                                        dmg[0] := 0;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
						if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							StatCalc1(tc, ts, Tick);
                                        end else begin
                                                tc.MMode := 4;
                                                tc.MPoint.X := 0;
                                                tc.MPoint.Y := 0;
						SL.Free;
						Exit;//safe 2004/04/26
                                        end;
                                end;

                                253:    {Holy Cross}
                                        begin
                                                DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
                                                if dmg[0] < 0 then dmg[0] := 0; //Negative Damage

                                                //Send Skill Packets
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 2);
												//Byte 16 isn't Blind 32 is Chance to blind on undead
                                        if Random(100) < Skill[253].Data.Data2[MUseLV] then begin
                                                        if (ts.Stat2 <> 32) and (ts.Data.Race = 1)  then begin
								ts.nStat := 32;
                                                        end
                                                end;
						if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							StatCalc1(tc, ts, Tick);
                                        end;

      368:    //Sacrafice {temp still need to find out the effects so far it just does damage like bash
        begin
        if tc.Weapon = 2 then begin
          DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
          if dmg[0] < 0 then dmg[0] := 0;
          SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
          if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
          StatCalc1(tc, ts, Tick);
          end else begin
            SendSkillError(tc, 6);
            MMode := 4;
						sl.Free;
						Exit;//safe 2004/04/26
           end;
           end;

           379:
        begin
        if tc.Weapon = 16 then begin
        DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
          if dmg[0] < 0 then dmg[0] := 0;
          SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
          if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
          StatCalc1(tc, ts, Tick);
            end else begin
            SendSkillError(tc, 6);
            MMode := 4;
						sl.Free;
						Exit;//safe 2004/04/27
           end;
           end;

			382:     {Sniper Shot}
                  begin
                  if (Arrow = 0) or (Item[Arrow].Amount < 1) then begin
                  WFIFOW(0, $013b);
                  WFIFOW(2, 0);
                  Socket.SendBuf(buf, 4);
                  ATick := ATick + ADelay;
						sl.Free;
						Exit;//safe 2004/04/26
                  end;

                  Dec(Item[Arrow].Amount,1);

                  WFIFOW( 0, $00af);
                  WFIFOW( 2, Arrow);
                  WFIFOW( 4, 9);
                  Socket.SendBuf(buf, 6);

                  if Item[Arrow].Amount = 0 then begin
                  Item[Arrow].ID := 0;
                  Arrow := 0;
                  end;

                  if tc.Weapon = 11 then begin
                   DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
                   if dmg[0] < 0 then dmg[0] := 0;
                SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
          if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
          StatCalc1(tc, ts, Tick);
            end else begin
            SendSkillError(tc, 6);
            MMode := 4;
						sl.Free;
						Exit;//safe 2004/04/26
                 end;
				end;{Sniper Shot}

          394:     {Arrow Shower}
                  begin
                  if (Arrow = 0) or (Item[Arrow].Amount < 9) then begin
                  WFIFOW(0, $013b);
                  WFIFOW(2, 0);
                  Socket.SendBuf(buf, 4);
                  ATick := ATick + ADelay;
						sl.Free;
						Exit;//safe 2004/04/26
                  end;

                  Dec(Item[Arrow].Amount,9);

                  WFIFOW( 0, $00af);
                  WFIFOW( 2, Arrow);
                  WFIFOW( 4, 9);
                  Socket.SendBuf(buf, 6);

                  if Item[Arrow].Amount = 0 then begin
                  Item[Arrow].ID := 0;
                  Arrow := 0;
                  end;

           if tc.Weapon = 11 then begin
           DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
           if dmg[0] < 0 then dmg[0] := 0;
           SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
          if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
          StatCalc1(tc, ts, Tick);
            end else begin
            SendSkillError(tc, 6);
            MMode := 4;
						tc.MTick := Tick + 500;//CR - moved ahead of Exit;
						sl.Free;
						Exit;//safe 2004/04/26
                  end;
				end;{Arrow Shower}

			381:    {Falcon Assault}
				//Damage calc needs to be redone not much info about this skill.
        if tc.Option and 16 <> 0 then begin
         DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
          if dmg[0] < 0 then dmg[0] := 0;
          SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
          if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
          StatCalc1(tc, ts, Tick);
            end else begin
            SendSkillError(tc, 0);
            MMode := 4;
					sl.Free;
					Exit;//safe 2004/04/26
				end;{Falcon Assault}

            /// We can cheat and use Spear stab
			370:     {Palm Strike}
                                                 if tc.Skill[270].Tick > Tick then begin
						                xy.X := ts.Point.X - Point.X;
						                xy.Y := ts.Point.Y - Point.Y;
						                if abs(xy.X) > abs(xy.Y) * 3 then begin
							                //Knockback Distance?
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

						                //Calculate Damage
						                DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						                if dmg[0] < 0 then dmg[0] := 0; //No Negative Damage

						                //Send Attacking Packet
						                SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);

						                //Begin Knockback
						                if (dmg[0] > 0) then begin
							                SetLength(bb, 6);
							                bb[0] := 6;
							                xy := ts.Point;
							                DirMove(tm, ts.Point, b, bb);

							                //Knockback Monster
							                if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								                with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
								Assert(IndexOf(ts.ID) > -1, 'MobBlockDelete Error');
									                Delete(IndexOf(ts.ID));
								                end;
								                tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							                end;
							                ts.pcnt := 0;

							                //Update Coordinates of Monster
							                UpdateMonsterLocation(tm, ts);
						                end;

						                if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							                StatCalc1(tc, ts, Tick);
                                                        end else begin
                                                          SendSkillError(tc, 0);
                                                                MMode := 4;
					sl.Free;
					Exit;//safe 2004/04/26
				end;{Palm Strike}

           365:   //Magic Crusher
                                begin
					//Magic Attack Calculation
					dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
					dmg[0] := dmg[0] * (100 - ts.Data.DEF) div 100;
					dmg[0] := dmg[0] - ts.Data.Param[2]; 
					if dmg[0] < 1 then
                                                dmg[0] := 1;
					dmg[0] := dmg[0] * 1;
                                        dmg[0] := dmg[0] * tl.Data2[MUseLV];
                                        if dmg[0] < 0 then
                                                dmg[0] := 0;

          if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;

					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], tl.Data2[MUseLV]);
                                        DamageProcess1(tm, tc, ts, dmg[0], Tick);
                                                     end;

        367: //Pressure
          begin
            DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
            j := 1;
            if dmg[0] < 0 then dmg[0] := 0;
            SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], j);
            if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
            StatCalc1(tc, ts, Tick);
            xy := ts.Point;

            sl.Clear;
            for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
            for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
            for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
								if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then Continue;
								ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
            if (ts = ts1) or ((tc.GuildID <> 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID <> 0) and (ts1.GID = tc.GuildID)) then Continue;
            if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
            sl.AddObject(IntToStr(ts1.ID),ts1);
							end;//for k1
						end;//for i1
					end;//for j1
					if sl.Count > 0 then begin
                for k1 := 0 to sl.Count - 1 do begin
                ts1 := sl.Objects[k1] as TMob;
                DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
                j := 1;
                if dmg[0] < 0 then dmg[0] := 0;
                SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1, 6);
                //SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], j);
                if not DamageProcess1(tm, tc, ts1, dmg[0], Tick) then
		StatCalc1(tc, ts1, Tick);
						end;//for k1
					end;//if sl.Count
                end;

                                254:    {Grand Cross}
                                begin
                                        PassiveAttack := false;
                                        DamageProcessed := false;
                                        NoCastInterrupt := true;
                                        //tc.MPoint.X := tc.Point.X;
                                        //tc.MPoint.Y := tc.Point.Y;
                                        //DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
				//end;
                                        //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                                        //ÉpÉPëóêM
				       	//SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], j);
			                //if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
						//StatCalc1(tc, ts, Tick);
		       			//xy := ts.Point;
		      			//É_ÉÅÅ[ÉWéZèo
                                        xy.X := tc.Point.X;
                                        xy.Y := tc.Point.Y;
		     			sl.Clear;
		    			for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
		   				for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
		  					for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
		 						if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then
                                                                       Continue;
                                                                ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
								if (ts = ts1) or ((tc.GuildID > 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID > 0) and (ts1.GID = tc.GuildID)) then
                                                                        Continue;
								if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
									sl.AddObject(IntToStr(ts1.ID),ts1);
							end;//for k1
						end;//for i1
					end;//for j1
					if sl.Count > 0 then begin
						for k1 := 0 to sl.Count - 1 do begin
							ts1 := sl.Objects[k1] as TMob;
							DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
                                                        //dmg[0] := dmg[0];
                                                        dmg[0] := (MATK2 - MATK1 + 20) * 35 + ATTPOWER + dmg[0];
                                                        j := 3;
                                                        if DamageProcessed = false then begin
                                                                DamageProcessed := true;
                                                                //SendCSkillAtk2(tm, tc, tc, Tick, (dmg[0] * 100 div 200), j, 5);
							        if tc.HP > (dmg[0] * 100 div 350) then begin
					                                tc.HP := tc.HP - (dmg[0] * 100 div 350);  //Subtract Damage
                                                                        WFIFOW( 0, $01de);
	                                                                WFIFOW( 2, 254);
	                                                                WFIFOL( 4, tc.ID);
                                                                        WFIFOL( 8, tc.ID);
                                                                	WFIFOL(12, Tick);
                                                                        WFIFOL(16, ts1.Data.dMotion);
	                                                                WFIFOL(20, tc.aMotion);
	                                                                WFIFOL(24, (dmg[0] * 100 div 350));
	                                                                WFIFOW(28, MUseLV);
	                                                                WFIFOW(30, 3);
                                                                        WFIFOB(32, 8);
	                                                                SendBCmd(tm, tc.Point, 33);
                                                                        //SendMSkillAttack(tm, tc, ts, ts.Data.AISkill, Tick, 3, 0);
					                                if dmg[0] <> 0 then begin
						                                tc.DmgTick := Tick + tc.dMotion div 2;
                                                                                {Colus, 20031216: Cancel casting timer on hit.
                                                                                        Also, phen card handling.}
                                                                                if tc.NoCastInterrupt = False then begin
                                                                                        tc.MMode := 0;
                                                                                        tc.MTick := 0;
                                                                                        WFIFOW(0, $01b9);
                                                                                        WFIFOL(2, tc.ID);
                                                                                        SendBCmd(tm, tc.Point, 6);
                                                                                end;
                                                                                {Colus, 20031216: end cast-timer cancel}
					                                end;
				                                end else begin
					                                tc.HP := 1;
					                                {WFIFOW( 0, $0080);
					                                WFIFOL( 2, tc.ID);
					                                WFIFOB( 6, 1);
					                                SendBCmd(tm, tc.Point, 7);
					                                tc.Sit := 1;

                                                                        i := (100 - DeathBaseLoss);
                                                                        tc.BaseEXP := Round(tc.BaseEXP * (i / 100));
                                                                        i := (100 - DeathJobLoss);
                                                                        tc.JobEXP := Round(tc.JobEXP * (i / 100));

                                                                        SendCStat1(tc, 1, $0001, tc.BaseEXP);
                                                                        SendCStat1(tc, 1, $0002, tc.JobEXP);

					                                tc.pcnt := 0;
					                                if (tc.AMode = 1) or (tc.AMode = 2) then tc.AMode := 0;
						                        ATarget := 0;
                                                                        ts.ARangeFlag := false;}
					                        end;

					                        SendCStat1(tc, 0, $0005, tc.HP);
					                        ATick := ATick + ts.Data.ADelay;
                                                        end;

                                                        //SendCStat1(tc, 0, 5, tc.HP);
                                                        //SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 3, 6);
		        				//SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], j, 3);
                                                        WFIFOW( 0, $01de);
                                                        WFIFOW( 2, 0);
                                                        WFIFOL( 4, ts1.ID);
                                                        WFIFOL( 8, ts1.ID);
                                                        WFIFOL(12, Tick);
                                                        WFIFOL(16, tc.aMotion);
                                                        WFIFOL(20, ts1.Data.dMotion);
                                                        WFIFOL(24, dmg[0]);
                                                        WFIFOW(28, 1);
                                                        WFIFOW(30, 3);
                                                        WFIFOB(32, 9);
                                                        SendBCmd(tm, tc.Point, 33);
							if not DamageProcess1(tm, tc, ts1, dmg[0], Tick) then
                	       					StatCalc1(tc, ts1, Tick); {í«â¡}
                                                end;
                                        end;
                                end;

                                //New skills ---- Crusader
                                257:    {Defender}
	     			begin
	     				tc1 := tc;
	     				ProcessType := 3;
	     			end;

                                //New skills ---- Alchemist
                                {231:    Potion Pitcher
                                begin
                                        j := SearchCInventory(tc, 501, false);
                                        if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
                                                UseItem(tc, j);
                                                if (tc.HP > 0) then begin
                                                        dmg[0] := tc.HP + ((td.HP1 + Random(td.HP2 - td.HP1 + 1)) * (100 + tc.Param[2]) div 100) * tc.Skill[231].Data.Data1[tc.Skill[231].Lv] div 100;;
                                                        ts.HP := ts.HP + dmg[0];

                                                        WFIFOW( 0, $011a);
                                                        WFIFOW( 2, MSkill);
                                                        WFIFOW( 4, dmg[0]);
                                                        WFIFOL( 6, MTarget);
                                                        WFIFOL(10, ID);
                                                        WFIFOB(14, 1);
                                                        SendBCmd(tm, ts.Point, 15);
                                                        tc.MTick := Tick + 1000;
                                                end;
                                        end;
                                end;}
			{234:    {Chemical Protection --- Weapon}
				{begin

                                        ProcessType := 3;
                                end;
                                235:    {Chemical Protection --- Shield}
				{begin
                                        ProcessType := 3;
                                end;
                                236:    {Chemical Protection --- Armor}
				{begin
                                        ProcessType := 3;
                                end;
                                237:    {Chemical Protection --- Helmet}
                                {begin
                                        ProcessType := 3;
                                end;}

			//New skills ---- Rogue
                                211:    {Steal Coin}
                                begin
                                        j := Random(7);
                                        if (Random(100) < tl.Data1[MUseLV]) then begin
                                                WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, ts.Point, 15);
                                        //DebugOut.Lines.Add('Steal zeny success');
                                                k := ts.Data.LV * 5;
                                                Inc(Zeny, k);
						// Update Zeny
						SendCStat1(tc, 1, $0014, tc.Zeny);
                                        end;
				end;{Steal Coin}
                                212:    {Back Stab}
                                if ts.Dir = tc.Dir then begin
                                  if (tc.Option and 2 <> 0) then begin
                                    tc.Option := tc.Option and $FFFD;
                                    tc.Hidden := false;
                                    tc.Skill[51].Tick := Tick;
                                    tc.SkillTick := Tick;
                                    tc.SkillTickID := 51;
                                    CalcStat(tc, Tick);
                                    UpdateOption(tm, tc);
                                  // Colus, 20040319: Actually you can Backstab while visible.
                                  {end else begin
                                    SendSkillError(tc, 0);
                                    tc.MMode := 4;
						sl.Free;//CR - just in case!
                                    Exit;}
                                  end;
                                    DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
                                        if dmg[0] < 0 then dmg[0] := 0;
                                    SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
                                        if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then StatCalc1(tc, ts, Tick);
                                    SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
                                    DamageProcess1(tm, tc, ts, dmg[0], Tick);
                                    tc.MTick := Tick + 500;
                                    end else begin
                                        SendSkillError(tc, 0);
                                        MMode := 4;
					sl.Free;
					Exit;//safe 2004/04/26
                                end;

                                {214:    {Raid}
                                {begin
                                        if (tc.Option = 6) then begin
						DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then
                                                        dmg[0] := 0;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
						if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
                                                        StatCalc1(tc, ts, Tick);
						xy := ts.Point;
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
									ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
									if (ts = ts1) or ((ts1.GID = tc.GuildID) or (ts1.isGuardian = tc.GuildID) and (tc.GuildID <> 0)) then
                                                                                Continue;
									if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(ts1.ID),ts1);
								end;//for k1
							end;//for i1
						end;//for j1
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								ts1 := sl.Objects[k1] as TMob;
								DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
								if dmg[0] < 0 then
                                                                        dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								//ÉpÉPëóêM
								SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1, 5);
								//É_ÉÅÅ[ÉWèàóù
								if not DamageProcess1(tm, tc, ts1, dmg[0], Tick) then
                        						StatCalc1(tc, ts1, Tick);
							end;
						end;
                                        end else begin
                                                tc.MMode := 4;
                                                tc.MPoint.X := 0;
                                                tc.MPoint.Y := 0;
						sl.Free;
						Exit;//safe 2004/04/26
                                        end;
				end;}

                                215,216,217,218:
                                { 215: Strip Weapon
                                  216: Strip Shield
                                  217: Strip Armor
                                  218: Strip Helm }
                                begin
                                        i := (tc.Param[4] - ts.Data.Param[4]);
                                        if i < 0 then
                                                i := 0;
                                        i := tl.Data2[MUseLV] + i;
                                        if (Random(100) < i) then begin
                                                ts.ATarget := tc.ID;
						ts.ARangeFlag := false;
						ts.AData := tc;
						//ÉpÉPëóêM
					        WFIFOW( 0, $011a);
				       	        WFIFOW( 2, MSkill);
				      	        WFIFOW( 4, MUseLV);
				     	        WFIFOL( 6, MTarget);
				    	        WFIFOL(10, ID);
			               	        if ts.Data.Race <> 1 then begin
			      			        WFIFOB(14, 1);
                                                        if MSkill = 215 then begin
                                                                ts.ATKPer := ts.ATKPer - (ts.ATKPer * 10 div 100);
                                                        end
                                                        else if MSkill = 216 then begin
                                                                ts.DEF1 := ts.DEF1 - (ts.DEF1 * 15 div 100);
                                                                ts.DEF2 := ts.DEF2 - (ts.DEF2 * 15 div 100);
                                                        end
                                                        else if MSkill = 217 then begin
                                                                ts.Data.Param[2] := ts.Data.Param[2] - (ts.Data.Param[2] * 40 div 100);
                                                        end
                                                        else if MSkill = 218 then begin
                                                                ts.Data.Param[3] := ts.Data.Param[3] - (ts.Data.Param[3] * 40 div 100);
                                                        end else begin
							        WFIFOB(14, 0);
                                                        end;
					        	SendBCmd(tm, ts.Point, 15);
                                                end;
                                          end;
                                end;

                                219:    {Intimidate}
                                        begin
                                        DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
						if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							StatCalc1(tc, ts, Tick);
                                                        
                                                tc.intimidateActive := true;
                                                tc.intimidateTick := Tick + 1000;

									{i := MapInfo.IndexOf(tc.Map);
									j := -1;
									if (i <> -1) then begin
										mi := MapInfo.Objects[i] as MapTbl;
										if (mi.noTele = true) then j := 0;
									end;
									if (j <> 0) then begin
										tm := tc.MData;
									j := 0;
									repeat
										xy.X := Random(tm.Size.X - 2) + 1;
										xy.Y := Random(tm.Size.Y - 2) + 1;
										Inc(j);
									until ( ((tm.gat[xy.X, xy.Y] <> 1) and (tm.gat[xy.X, xy.Y] <> 5)) or (j = 100) );

									if j <> 100 then begin
										SendCLeave(tc, 3);
										tc.Point := xy;
										MapMove(Socket, tc.Map, tc.Point);
									end;
                                                                        ts.Point.X := tc.Point.X;
                                                                        ts.Point.Y := tc.Point.Y;
                                                                        if ts.HP > 0 then SendMmove(Socket, ts, ts.Point, tc.Point, ver2);
                                                        	end;  }

				end;{Intimidate}

                                //New skills ---- Monk
                                {261:  Call Spirits
                                begin
                                        tc1 := tc;
                                        ProcessType := 3;
                                        spiritSpheres := Skill[261].Data.Data2[Skill[261].Lv];
                                        WFIFOW( 0, $011f);
	                                WFIFOL( 2, tc.ID);
	                                WFIFOL( 6, ID);
	                                WFIFOW(10, tc.Point.X);
	                                WFIFOW(12, tc.Point.Y);
	                                WFIFOB(14, $88);
	                                WFIFOB(15, 1);
	                                SendBCmd(tm, tc.Point, 16)
                                end;
                                262:  Absorb Spirits
                                begin
                                        if spiritSpheres <> 0 then begin
                                                spiritSpheres := spiritSpheres - 1;
                                                tc.SP := (tc.SP + Skill[262].Data.Data2[Skill[262].Lv]);
                                                if tc.SP > tc.MAXSP then
                                                        tc.SP := tc.MAXSP;
                                        end;
                                end;}

                                263:   {Triple Blows}
                                begin
                                        if (tc.Weapon = 12) or (tc.Weapon = 0) then begin
                                                DamageCalc1(tm, tc, ts, Tick, 0, tl.Data2[MUseLV], tl.Element, 0);
                                                if dmg[0] < 0 then dmg[0] := 0;
                                                SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 2);
                                                UpdateIcon(tm, tc, $59);
                                                Delay := (1000 - (4 * param[1]) - (2 * param[4]) + 300);
                                                //tc.ATick := timeGetTime() + Delay;
                                                MonkDelay(tm, tc, tc.Delay);

                                                tc.ATick := Tick + Cardinal(Delay);

                                                if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
                                                StatCalc1(tc, ts, Tick);
                                        end else begin
                                                MMode := 4;
						sl.Free;
						Exit;//safe 2004/04/26
                                end;
				end;{Triple Blows}

                                {264:   {Body Relocation}
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
						sl.Free;//just in case...
						Exit;//safe 2004/04/26
                                        end else begin
                                                tc.MMode := 4;
                                                tc.MPoint.X := 0;
						tc.MPoint.Y := 0;
						sl.Free;//just in case.
						Exit;//safe 2004/04/26
                                        end;}
                                //end;

                                {268:    Steel Body
                                begin
                                        if spiritSpheres = 5 then begin
                                                tc1 := tc;
                                                ProcessType := 3;
                                                spiritSpheres := spiritSpheres - 5;
                                                UpdateSpiritSpheres(tc, spiritSpheres);
                                        end;
                                end;}
                                {270:    {Explosion Spirits
                                begin
                                        if spiritSpheres = 5 then begin
                                                tc1 := tc;
                                                ProcessType := 3;
                                                spiritSpheres := spiritSpheres - 5;
                                        end;
                                end;}

                                271:    {Extremity Fist}
                                begin
                                        if tc.Skill[270].Tick > Tick then begin
                                                if (tc.Skill[271].Data.SType = 1) then begin
                                                  if tc.spiritSpheres = 5 then begin
                                                        DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
                                                        spbonus := tc.SP;
                                                        dmg[0] := dmg[0] *(8 + tc.SP div 100) + 250 + (tc.Skill[271].Lv * 150);
                                                        dmg[0] := dmg[0] + j;
                                                        if dmg[0] < 0 then begin
                                                                dmg[0] := 0;
                                                                //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                                                        end;
                                                        {SetLength(bb, 6);
                                                        //bb[0] := 6;

                                                        xy := tc.Point;
                                                        DirMove(tm, tc.Point, tc.Dir, bb);

                                                        if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
                                                                with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
										Assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
                                                                        Delete(IndexOf(tc.ID));
                                                                end;
                                                                tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
                                                        end;
                                                        tc.pcnt := 0;

                                                        UpdatePlayerLocation(tm, tc);  }
                                                        KnockBackLiving(tm, tc, ts, 6, 2);

                                                        SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
                                                        DamageProcess1(tm, tc, ts, dmg[0], Tick);
                                                        tc.MTick := Tick + Cardinal(3500 + (tl.CastTime2 * MUseLV));
                                                        tc.spiritSpheres := tc.spiritSpheres - 5;
                                                        UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

                                                        {20031223, Colus: Cancel Explosion Spirits after Ashura
                                                         Ashura's tick will control SP lockout time}
                                                        tc.Skill[271].Tick := Tick + 300000;
                                                        tc.Skill[270].Tick := Tick;
                                                        tc.SkillTick := Tick;
                                                        tc.SkillTickID := 270;
                                                        tc.SP := 0;
                                                        SendCStat(tc);
                                                  end;
                                                end else begin
                                                  if tc.spiritSpheres >= 4 then begin
                           ts := tm.Mob.IndexOfObject(tc.ATarget) as TMob;
								if ts = nil then begin
									sl.Free;
									Exit;//safe 2004/04/26
								end;
                                        ts.IsEmperium := False;
                                        tc.AData := ts;
                                        PassiveAttack := False;
                                                        DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
                                                        spbonus := tc.SP;
                                                        dmg[0] := dmg[0] *(8 + tc.SP div 100) + 250 + (tc.Skill[271].Lv * 150);
                                                        dmg[0] := dmg[0] + j;
                                                        if dmg[0] < 0 then begin
                                                                dmg[0] := 0;
                                                                //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                                                        end;
                                                        {SetLength(bb, 6);
                                                        //bb[0] := 6;

                                                        xy := tc.Point;
                                                        DirMove(tm, tc.Point, tc.Dir, bb);

                                                        if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
                                                                with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
										Assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
                                                                        Delete(IndexOf(tc.ID));
                                                                end;
                                                                tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
                                                        end;
                                                        tc.pcnt := 0;

                                                        UpdatePlayerLocation(tm, tc);   }
                                                        KnockBackLiving(tm, tc, ts, 6, 2);
                                                        SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
                                                        DamageProcess1(tm, tc, ts, dmg[0], Tick);
                                                        tc.MTick := Tick + Cardinal(3500 + (tl.CastTime2 * MUseLV));
                                                        tc.spiritSpheres := 0;
                                                        UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

                                                        {20031223, Colus: Cancel Explosion Spirits after Ashura
                                                         Ashura's tick will control SP lockout time}
                                                        tc.Skill[271].Tick := Tick + 300000;
                                                        tc.Skill[270].Tick := Tick;
                                                        tc.SkillTick := Tick;
                                                        tc.SkillTickID := 270;
                                                        tc.SP := 0;
                                                        SendCStat(tc);
                                                        tc.Skill[271].Data.SType := 1;
                                                        tc.Skill[271].Data.CastTime1 := 4500;
                                                        SendCSkillList(tc);
                                                  end;
                                                end;
                                        end;
                                end;

                                272:   {Chain Combo Effect}
                                begin
                                        ts := tm.Mob.IndexOfObject(tc.ATarget) as TMob;
                                        if ts = nil then Exit;
                                        ts.IsEmperium := False;
                                        tc.AData := ts;
                                        PassiveAttack := False;

                                        DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
                                        dmg[0] := dmg[0];
                                        dmg[0] := dmg[0] + (75 div 100) * 60;
                                        if dmg[0] < 0 then dmg[0] := 0; //Negative Damage

                                        SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 4);
                                        DamageProcess1(tm, tc, ts, dmg[0], Tick);
                                        tc.Skill[MSkill].Tick := Tick + 5000;

                                        if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then

                                        StatCalc1(tc, ts, Tick);
                                        tc.MTick := Tick + 500;

                                end;
                                    273:  //Combo finsher
                                    begin
                                if tc.spiritSpheres >= 1 then begin
                                        ts := tm.Mob.IndexOfObject(tc.ATarget) as TMob;
						if ts = nil then begin
							sl.Free;
							Exit;//safe 2004/04/27
						end;
                                        ts.IsEmperium := False;
                                        tc.AData := ts;
                                        PassiveAttack := False;

                                        DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
                                        dmg[0] := dmg[0];
                                        dmg[0] := dmg[0] + (75 div 100) * 60;
                                        if dmg[0] < 0 then dmg[0] := 0; //Negative Damage

                                        SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 4);
                                        DamageProcess1(tm, tc, ts, dmg[0], Tick);
                                        tc.Skill[MSkill].Tick := Tick + 5000;
                                        if tc.spiritSpheres <= 0 then tc.spiritSpheres := 0;
                                        if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
                                        tc.spiritSpheres := tc.spiritSpheres - 1;
                                        UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
                                        StatCalc1(tc, ts, Tick);
                                        tc.MTick := Tick + 500;
                                        if (tc.Skill[270].Tick >= Tick) then begin
                                          tc.Skill[271].Data.SType := 4;
                                          tc.Skill[271].Data.CastTime1 := 1;
                                          tc.Delay := (700 - (4 * tc.param[1]) - (2 * tc.param[4]) + 300);
                                          MonkDelay(tm, tc, tc.Delay);
                                          // Colus, 20040430: The +1000 is there just to make it more possible (the
                                          // monk delay keeps you from moving during the delay phase.)
                                          tc.Skill[273].Tick := Tick + tc.Delay + 1000;
                                          tc.Skill[273].EffectLV := 1;
                                          SendCSkillList(tc);
                                        end;
                                end;
                                end;

                                    371:  //Tiger Crush
                                 if tc.spiritSpheres >= 1 then begin
                                        ts := tm.Mob.IndexOfObject(tc.ATarget) as TMob;
					if ts = nil then begin
						sl.Free;
						Exit;//safe 2004/04/27
					end;
                                        ts.IsEmperium := False;
                                        tc.AData := ts;
                                        PassiveAttack := False;

                                        DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
                                        dmg[0] := dmg[0];
                                        dmg[0] := dmg[0] + (75 div 100) * 60;
                                        if dmg[0] < 0 then dmg[0] := 0; //Negative Damage

                                        SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 4);
                                        DamageProcess1(tm, tc, ts, dmg[0], Tick);
                                        tc.Skill[MSkill].Tick := Tick + 5000;
                                        if tc.spiritSpheres <= 0 then tc.spiritSpheres := 0;
                                        if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
                                        tc.spiritSpheres := tc.spiritSpheres - 1;
                                        UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
                                        StatCalc1(tc, ts, Tick);
                                        tc.MTick := Tick + 500;
				end;{Tiger Crush}

                                     372:   //Chain Crush
                                 if tc.spiritSpheres >= 2 then begin
                                        ts := tm.Mob.IndexOfObject(tc.ATarget) as TMob;
					if ts = nil then begin
						sl.Free;
						Exit;//safe 2004/04/27
					end;
                                        ts.IsEmperium := False;
                                        tc.AData := ts;
                                        PassiveAttack := False;

                                        DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
                                        dmg[0] := dmg[0];
                                        dmg[0] := dmg[0] + (75 div 100) * 60;
                                        if dmg[0] < 0 then dmg[0] := 0; //Negative Damage

                                        SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 4);
                                        DamageProcess1(tm, tc, ts, dmg[0], Tick);
                                        tc.Skill[MSkill].Tick := Tick + 5000;

                                        if tc.spiritSpheres <= 0 then tc.spiritSpheres := 0;
                                        tc.spiritSpheres := tc.spiritSpheres - 2;
                                        UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
                                        StatCalc1(tc, ts, Tick);

                                        tc.MTick := Tick + 500;
				end;{Chain Crush}

                                {273:    {Combo Finish Effect}
                                {if tc.spiritSpheres <> 0 then begin
                                                PassiveAttack := False;
                                                ts := tm.Mob.IndexOfObject(tc.ATarget) as TMob;
					if ts = nil then begin
						sl.Free;//just in case
						Exit;//safe 2004/04/27
					end;
                                                ts.IsEmperium := False;
			                        tc.AData := ts;
                                                xy.X := ts.Point.X - Point.X;
                                                xy.Y := ts.Point.Y - Point.Y;
                                                if abs(xy.X) > abs(xy.Y) * 3 then begin
                                                        //â°å¸Ç´
                                                        if xy.X > 0 then
                                                                b := 6
                                                        else
                                                                b := 2;
                                                end else if abs(xy.Y) > abs(xy.X) * 3 then begin
                                                        //ècå¸Ç´
                                                        if xy.Y > 0 then
                                                                b := 0
                                                        else
                                                                b := 4;
                                                end else begin
                                                        if xy.X > 0 then begin
                                                                if xy.Y > 0 then
                                                                        b := 7
                                                                else
                                                                        b := 5;
							end else begin
                                                                if xy.Y > 0 then
                                                                        b := 1
                                                                else
                                                                        b := 3;
							end;
						end;

						//Damage Calculations
						DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
                                                dmg[0] := dmg[0];
                                                dmg[0] := dmg[0] + (14 div 10) * 70;
						if dmg[0] < 0 then
                                                        dmg[0] := 0; //Negative Damage
						//Send Attack Packets
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);

						//Knockback
						if (dmg[0] > 0) then begin
							SetLength(bb, 6);
							bb[0] := 6;
							xy := ts.Point;
							DirMove(tm, ts.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
									assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(ts.ID));
								end;
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end;
							ts.pcnt := 0;
							//Update Monster Location
                                                        UpdateMonsterLocation(tm, ts);
						end;
						if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
                                                        tc.spiritSpheres := tc.spiritSpheres - 1;
                                                        UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
							StatCalc1(tc, ts, Tick);

                                                tc.MTick := Tick + 2000;
                                        end; }

                                266:    {Investigate}
                                begin
                                        if tc.spiritSpheres <> 0 then begin
                                                DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
                                                if dmg[0] < 1 then begin
                                                        dmg[0] := 1;
                                                end;
                                                if dmg[0] < 0 then begin
                                                        dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
					        	//ÉpÉPëóêM
                                                end;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], tl.Data2[MUseLV]);
						DamageProcess1(tm, tc, ts, dmg[0], Tick);

                                                tc.MTick := Tick + 1000;
                                                tc.spiritSpheres := tc.spiritSpheres - 1;
                                                UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
                                        end;
                                end;
                                267:    {Finger Offensive}
                                begin
                                    if (SearchAttack(path, tm, Point.X, Point.Y, ts.Point.X, ts.Point.Y) <> 0) then begin
                                        if tc.spiritSpheres >= tc.MUseLV then begin
					//É_ÉÅÅ[ÉWéZè
                                                DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						if dmg[0] < 1 then begin
                                                        dmg[0] := 1;
                                                end;
						dmg[0] := dmg[0] * tl.Data2[MUseLV];
                                                if dmg[0] < 0 then begin
                                                        dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
					                //ÉpÉPëóêM
                                                end;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], tl.Data2[MUseLV]);
						DamageProcess1(tm, tc, ts, dmg[0], Tick);
                                                tc.MTick := Tick + 1000;
                                                tc.spiritSpheres := tc.spiritSpheres - tc.MUseLV;
                                                UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
                                        end;
                                end;
                                end;

                                //Sage
                                290:    {Abracadabra}
                                begin
                                        i := Random(12);
                                        i := i + 1;

                                        {CODE-ERROR: Could be better code...}
                                        case i of
                                                1: tc.MSkill := 11;
                                                2: tc.MSkill := 13;
                                                3: tc.MSkill := 14;
                                                4: tc.MSkill := 15;
                                                5: tc.MSkill := 17;
                                                6: tc.MSkill := 19;
                                                7: tc.MSkill := 20;
                                                8: tc.MSkill := 84;
                                                9: tc.MSkill := 86;
                                                10: tc.MSkill := 88;
                                                11: tc.MSkill := 90;
                                                12: tc.MSkill := 91;
						end;//case
                                        tc.MUseLV := Random(10);
						if tc.MUseLV < 1 then tc.MUseLV := 1;
                                        if tc.MUseLV > tc.Skill[i].Data.MasterLV then
                                                tc.MUseLV := tc.Skill[i].Data.MasterLV;
                                        {CreateField(tc, Tick);}
                                        //if (tc.MSkill = 84) or (tc.MSkill = 19) or (tc.MSkill = 14) or (tc.MSkill = 13) or (tc.MSkill = 11) or (tc.MSkill = 20) then Skilleffect(tc, Tick);
                                        Skilleffect(tc, Tick);
                                end;

                                374:  {Soul Change PvM}
                                begin
                                  if ts.Burned = false then begin
                                    tc.SP := tc.SP + (tc.MAXSP * 3 div 100);
                                    ts.Burned := true;
                                    tc.MTick := Tick + 5000;
                                    SendCStat(tc);
                                  end else begin
                                    SendSkillError(tc, 0);
                                    MMode := 4;
							sl.Free;
							Exit;//safe 2004/04/26
                                  end;
                                end;
        {CODE-ERROR: You have got to be joking...}
        {Colus, 20040116: I reorganized this because it was ugly.  It also doesn't
          abort for the skills which require certain weapon types.}
				5,42,46,316,324:
        { 5   : Bash
          42  : Mammonite
          46  : Double Stafing
          316 : Musical Strike
          324 : Throw Arrow}
				begin
				//É_ÉÅÅ[ÉWéZèo
          j := 1; // Moved # of hits up here to initialize.

          if (MSkill = 5) then begin
						DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
					end else begin
						DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
					end;

          if (MSkill = 316) or (MSkill = 324) then begin
            if (Weapon = 13) or (Weapon = 14) then begin
  						DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
  					end else begin
	  					//DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
              SendSkillError(tc, 6);
  						tc.MMode := 4;
  						Exit;
  					end;
          end;

					if (MSkill = 46) then begin       {Double Strafing}
            if (Weapon = 11) then begin
  						dmg[0] := dmg[0] * 2;
  						j := 2;
            end else begin
              SendSkillError(tc, 6);
  						tc.MMode := 4;
  						Exit;
            end;
          end;

					if (MSkill = 56) then begin //ÉsÉAÅ[ÉXÇÕts.Data.Scale + 1âÒhit
						j := ts.Data.Scale + 1;
						dmg[0] := dmg[0] * j;
					end;

					//Mammonite
					if MSkill = 42 then begin
            // Should check to see if we have the money!
            if (Zeny >= Cardinal(tl.Data2[MUseLV])) then begin
  						Dec(Zeny, tl.Data2[MUseLV]);
  						// Update zeny
              SendCStat1(tc, 1, $0014, Zeny);
            end else begin
              SendSkillError(tc, 5);
  						tc.MMode := 4;
  						Exit;
            end;
					end;

					if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], j);

					if (Skill[145].Lv <> 0) and (MSkill = 5) and (MUseLV > 5) then begin //ã}èäìÀÇ´
						if Random(1000) < Skill[145].Data.Data1[MUseLV] * 10 then begin
							if (ts.Stat1 <> 3) then begin
								ts.nStat := 3;
								ts.BodyTick := Tick + tc.aMotion;
							end else
                ts.BodyTick := ts.BodyTick + 30000;
            end;
          end;

					if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							StatCalc1(tc, ts, Tick);
					end;

				6:      {Provoke}
				begin
					ts.ATarget := tc.ID;
					ts.ARangeFlag := false;
					ts.AData := tc;
					//ÉpÉPëóêM
					WFIFOW( 0, $011a);
					WFIFOW( 2, MSkill);
					WFIFOW( 4, MUseLV);
					WFIFOL( 6, MTarget);
					WFIFOL(10, ID);
					if ts.Data.Race <> 1 then begin
						WFIFOB(14, 1);
						ts.ATKPer := word(tl.Data1[MUseLV]);
						ts.DEFPer := word(tl.Data2[MUseLV]);
					end else begin
						WFIFOB(14, 0);
					end;
					SendBCmd(tm, ts.Point, 15);
				end;
				7:      {Magnum Break}
				begin
					//É_ÉÅÅ[ÉWéZèo1
					DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
					if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
					//ÉpÉPëóêM
					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
					if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
						StatCalc1(tc, ts, Tick);
					xy := ts.Point;
					//É_ÉÅÅ[ÉWéZèo2
					sl.Clear;
					for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
						for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
							for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
								ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
								if ts = ts1 then
                                                                        Continue;
								if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
									sl.AddObject(IntToStr(ts1.ID),ts1);
							end;
						end;
					end;
					if sl.Count <> 0 then begin
						for k1 := 0 to sl.Count - 1 do begin
							ts1 := sl.Objects[k1] as TMob;
							DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
							if dmg[0] < 0 then
                                                                dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
							//ÉpÉPëóêM
							SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1, 5);
							//É_ÉÅÅ[ÉWèàóù
							if not DamageProcess1(tm, tc, ts1, dmg[0], Tick) then
        			                        	StatCalc1(tc, ts1, Tick);
						end;
					end;
				end;
				11,13,14,19,20,90,156:
                                { 11  : Napalm Beat
                                  13  : Soul Strike
                                  14  : Cold Bolt
                                  19  : Fire Bolt
                                  20  : Lightning Bolt
                                  90  : Earth Spike
                                  156 : Holy Light }
				begin
					//Magic Attack Calculation
					dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
					dmg[0] := dmg[0] * (100 - ts.Data.MDEF) div 100; //MDEF%
					dmg[0] := dmg[0] - ts.Data.Param[3]; //MDEF-
					if dmg[0] < 1 then
                                                dmg[0] := 1;
					dmg[0] := dmg[0] * ElementTable[tl.Element][ts.Element] div 100;
                                        dmg[0] := dmg[0] * tl.Data2[MUseLV];
                                        if dmg[0] < 0 then
                                                dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                                        //ÉpÉPëóêM

          if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;

					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], tl.Data2[MUseLV]);
                                        DamageProcess1(tm, tc, ts, dmg[0], Tick);
					case MSkill of
						11,90:     tc.MTick := Tick + 1000;
						13:        tc.MTick := Tick +  800 + 400 * ((MUseLV + 1) div 2) - 300 * (MUseLV div 10);
						14,19,20 : tc.MTick := Tick +  800 + 200 * MUseLV;
						else       tc.MTick := Tick + 1000;
					end;
                                end;
				15:     {Frost Driver}
                                begin
					//Magic Attack Damage Calculation
					dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * ( MUseLV + 100 ) div 100;
					dmg[0] := dmg[0] * (100 - ts.Data.MDEF) div 100; //MDEF%
					dmg[0] := dmg[0] - ts.Data.Param[3]; //MDEF-
					if dmg[0] < 1 then
                                                dmg[0] := 1;
                                        dmg[0] := dmg[0] * ElementTable[tl.Element][ts.Element] div 100;
					if dmg[0] < 0 then
                                                dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï

          if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
                                        //Send Attacking Packets
					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);

                                        //Freezing Chance
                                        if (ts.Data.race <> 1) and (ts.Data.MEXP = 0) and (dmg[0] <> 0)then begin
                                                if Random(1000) < tl.Data1[MUseLV] * 10 then begin
                                                        ts.nStat := 2;
                                                        ts.BodyTick := Tick + tc.aMotion;
                                                end;
                                        end;
					DamageProcess1(tm, tc, ts, dmg[0], Tick, False);
					tc.MTick := Tick + 1500;
                                end;


				16:     {Stone Curse}
				begin
                                        j := SearchCInventory(tc, 716, false);
					if ((j <> 0) and (tc.Item[j].Amount >= 1)) or (NoJamstone = True) then begin

						//Use the Item
                                                if NoJamstone = False then begin
						        UseItem(tc, j);
                                                end;

						//É_ÉÅÅ[ÉWéZèo
						       //ÉpÉPëóêM
        					WFIFOW( 0, $011a);
	        				WFIFOW( 2, MSkill);
		        			WFIFOW( 4, dmg[0]);
			        		WFIFOL( 6, MTarget);
				        	WFIFOL(10, ID);
					        WFIFOB(14, 1);
                                                SendBCmd(tm, ts.Point, 15);
        					if Random(1000) < tl.Data1[MUseLV] * 10 then begin
	        					if (ts.Stat1 <> 1) then begin
		        					ts.nStat := 1;
			        				ts.BodyTick := Tick + tc.aMotion;
				        		end;
					        end;
                                        end else begin
                                                SendSkillError(tc, 7); //No Red Gemstone
                                                tc.MMode := 4;
                                                tc.MPoint.X := 0;
                                                tc.MPoint.Y := 0;
                                                Exit;
                                        end;
                                end;
{:119}
				17:     {Fire Ball}
					begin
						xy := ts.Point;
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
									if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then continue; ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
									if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(ts1.ID),ts1);
								end;
						 end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								ts1 := sl.Objects[k1] as TMob;
								dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
								dmg[0] := dmg[0] * (100 - ts1.Data.MDEF) div 100; //MDEF%
								dmg[0] := dmg[0] - ts1.Data.Param[3]; //MDEF-
								if dmg[0] < 1 then dmg[0] := 1;
								dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100;
								dmg[0] := dmg[0] * tl.Data2[MUseLV];
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                if (ts1.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
								if ts = ts1 then k := 0 else k := 5;
								SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], tl.Data2[MUseLV], k);
								//É_ÉÅÅ[ÉWèàóù
								DamageProcess1(tm, tc, ts1, dmg[0], Tick);
							end;
						end;
						tc.MTick := Tick + 1600;
					end;

				28:     {Heal}
					begin
                                                if (ts.HP > 0) then begin

						        //Check If Undead
						        if (ts.Data.Race = 1) or (ts.Element mod 20 = 9) then begin
							        //Damage Calculation
							        dmg[0] := ((BaseLV + Param[3]) div 8) * tl.Data1[MUseLV] * ElementTable[6][ts.Element] div 200;

							        if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                      if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
							        SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
							        DamageProcess1(tm, tc, ts, dmg[0], Tick);
						        end else begin
							        //Formula = (( BaseLv + INT) / 8ÇÃí[êîêÿéÃÇƒ ) * ( ÉqÅ[ÉãLv x 8 + 4 )
							        dmg[0] := ((BaseLV + Param[3]) div 8) * tl.Data1[MUseLV];
							        ts.HP := ts.HP + dmg[0];
							        if ts.HP > Integer(ts.Data.HP) then ts.HP := ts.Data.HP;
							        //Send Skill packet
							        WFIFOW( 0, $011a);
							        WFIFOW( 2, MSkill);
							        WFIFOW( 4, dmg[0]);
							        WFIFOL( 6, MTarget);
							        WFIFOL(10, ID);
							        WFIFOB(14, 1);
							        SendBCmd(tm, ts.Point, 15);
						        end;
						        //Set Character Delay Tick
						        tc.MTick := Tick + 1000;
                                                end else begin
                                                        MMode := 4;
                                                        Exit;
                                                end;
					end;
				30:     {Decrease Agility}
					begin
						//Send Graphics Packet
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, ts.ID);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, ts.Point, 15);

						if tc.Skill[30].EffectLV > 5 then begin
						    ts.speed := ts.speed + 45;
						end else begin
						    ts.speed := ts.speed + 30;
						end;

						tc.MTick := Tick + 1000;
					end;

                                264:   {Body Relocation}  //New Version Oatmeal style U_U
                                    begin
                                        // Colus, 20040225: Never called?
                                        if tc.spiritSpheres <> 0 then begin
                                                //Send Graphics Packet
                                                WFIFOW( 0, $011a);
                                                WFIFOW( 2, MSkill);
                                                WFIFOW( 4, MUseLV);
                                                WFIFOL( 6, ts.ID);
                                                WFIFOL(10, ID);
                                                WFIFOB(14, 1);
                                                // Colus, 20040225: Oatmeal, until you send the packet,
                                                // ANY other packet you send will overwrite what you've
                                                // already done.  You cannot do the UpdateSpiritSpheres
                                                // call (which makes a new packet) until you send the old one.
                                                SendBCmd(tm, ts.Point, 15);
                                                tc.spiritSpheres := tc.spiritSpheres - 1;
                                                UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

                                                if tc.Skill[264].EffectLV > 1 then begin
                                                        ts.speed := ts.speed - 45;
                                                end else begin
                                                        ts.speed := ts.speed - 30;
                                                end;

                                                tc.MTick := Tick + 1000;
                                        end;
                                    end;
                                47:     {Arrow Shower}
                                        begin
                                                if (Arrow = 0) or (Item[Arrow].Amount < 9) then begin
                                                        WFIFOW(0, $013b);
                                                        WFIFOW(2, 0);
                                                        Socket.SendBuf(buf, 4);
                                                        ATick := ATick + ADelay;
                                                        Exit;
                                                end;

                                                Dec(Item[Arrow].Amount,9);

                                                WFIFOW( 0, $00af);
                                                WFIFOW( 2, Arrow);
                                                WFIFOW( 4, 9);
                                                Socket.SendBuf(buf, 6);

                                                if Item[Arrow].Amount = 0 then begin
                                                        Item[Arrow].ID := 0;
                                                        Arrow := 0;
                                                end;

                                                DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
                                                if dmg[0] < 0 then dmg[0] := 0; //No Negate Damage

                                                //Send Attack Packet
                                                SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
                                                if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then

                                                StatCalc1(tc, ts, Tick);
                                                xy := ts.Point;

                                                //Begin Area Effect
                                                sl.Clear;
                                                for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
                                                        for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
                                                                for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
                                                                        if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then Continue; ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
                                                                        if (ts = ts1) or ((tc.GuildID <> 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID <> 0) and (ts1.GID = tc.GuildID)) then Continue;
                                                                        if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
                                                                                sl.AddObject(IntToStr(ts1.ID),ts1);
                                                                end;
                                                        end;
                                                end;

                                                if sl.Count <> 0 then begin
                                                        for k1 := 0 to sl.Count - 1 do begin
                                                                ts1 := sl.Objects[k1] as TMob;

                                                                j := 0;
                                                                case tc.Dir of
                                                                        0:
                                                                                begin
                                                                                        if ts1.Point.Y < tc.Point.Y then j := 1;
                                                                                end;
                                                                        1:
                                                                                begin
                                                                                        if (ts1.Point.X < tc.Point.X) and (ts1.Point.Y > tc.Point.Y) then j := 1;
                                                                                end;
                                                                        2:
                                                                                begin
                                                                                        if ts1.Point.X > tc.Point.X then j := 1;
                                                                                end;
                                                                        3:
                                                                                begin
                                                                                        if (ts1.Point.X < tc.Point.X) and (ts1.Point.Y < tc.Point.Y) then j := 1;
                                                                                end;
                                                                        4:
                                                                                begin
                                                                                        if ts1.Point.Y > tc.Point.Y then j := 1;
                                                                                end;
                                                                        5:
                                                                                begin
                                                                                        if (ts1.Point.X > tc.Point.X) and (ts1.Point.Y > tc.Point.Y) then j := 1;
                                                                                end;
                                                                        6:
                                                                                begin
                                                                                        if ts1.Point.X < tc.Point.X then j := 1;
                                                                                end;
                                                                        7:
                                                                                begin
                                                                                        if (ts1.Point.X > tc.Point.X) and (ts1.Point.Y > tc.Point.Y) then j := 1;
                                                                                end;
                                                                end;

                                                                if j <> 1 then begin
                                                                        DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
                                                                        if dmg[0] < 0 then dmg[0] := 0; //No Negative Damage

                                                                        //Send Graphics Packet
                                                                        SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1, 5);

                                                                        //Damage Process for Monster
                                                                        if not DamageProcess1(tm, tc, ts1, dmg[0], Tick) then
						                                StatCalc1(tc, ts1, Tick);
                                                                end;

                                                        end;
                                                end;
                                        end;

                                        52:     {Poison}
					        begin
						        DamageCalc1(tm, tc, ts, Tick, 0, 100, tl.Element);
						        dmg[0] := dmg[0] + 15 * MUseLV;
						        dmg[0] := dmg[0] * ElementTable[tl.Element][ts.Element] div 100;
						        if dmg[0] < 0 then dmg[0] := 0; //No Negative Damage
						        SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
						        k1 := (BaseLV * 2 + MUseLV * 3 + 10) - (ts.Data.LV * 2 + ts.Data.Param[2]);
						        k1 := k1 * 10;
						        if Random(1000) < k1 then begin
							        if not Boolean(ts.Stat2 and 1) then
								        ts.HealthTick[0] := Tick + tc.aMotion
							        else ts.HealthTick[0] := ts.HealthTick[0] + 30000;
						        end;
                                                        
						        DamageProcess1(tm, tc, ts, dmg[0], Tick);
				        	end;

				        54:     {Resurrection}
					        begin
                    j := SearchCInventory(tc, 717, false);
						        if ((j <> 0) and (tc.Item[j].Amount >= 1)) or (NoJamstone = True) or (tc.ItemSkill = true) then begin

                      //Damage Calculation
                      // Colus, 20040123: Rearranged checks for undead, itemskill, and item usage
                      
                      
                      if (ts.Data.Race = 1) or (ts.Element mod 20 = 9) then begin

                        if (NoJamstone = False) and (ItemSkill = false) then UseItem(tc, j);

							          if (Random(1000) < MUseLV * 20 + Param[3] + Param[5] + BaseLV + Trunc((1 - HP / MAXHP) * 200)) and (ts.Data.MEXP = 0) then begin
  								        dmg[0] := ts.HP;
  							        end else begin
  								        dmg[0] := (BaseLV + Param[3] + (MUseLV * 10)) * ElementTable[6][ts.Element] div 100;
  								        if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
  							        end;

                      // Shouldn't need to cap this any more...
							        //if (dmg[0] div $010000) <> 0 then dmg[0] := $07FFF; //ï€åØ
                        if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;

							          SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
							          DamageProcess1(tm, tc, ts, dmg[0], Tick);
							          tc.MTick := Tick + 3000;
                      end else begin
                        tc.MMode := 4;
  							        tc.MPoint.X := 0;
  							        tc.MPoint.Y := 0;
                      end;
						        end else begin
                      SendSkillError(tc, 8); //No Blue Gemstone
							        tc.MMode := 4;
							        tc.MPoint.X := 0;
							        tc.MPoint.Y := 0;
							        Exit;
						        end;
					        end;

                                        56:     {Pierce}
                                                begin
                                                        //Check if player has a Spear
                                                        if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
                                                                DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
                                                                j := ts.Data.Scale + 1;
                                                                dmg[0] := dmg[0] * j;
						                if dmg[0] < 0 then dmg[0] := 0;
						                SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], j);
						                if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
                                                                        StatCalc1(tc, ts, Tick);
                                                        end else begin
                                                          SendSkillError(tc, 6);
                                                                MMode := 4;
                                                                Exit;
                                                        end;
                                                end;


                                        58:     {Spear Stab}
                                                begin
                                                        if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
						                xy.X := ts.Point.X - Point.X;
						                xy.Y := ts.Point.Y - Point.Y;
						                if abs(xy.X) > abs(xy.Y) * 3 then begin
							                //Knockback Distance?
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

						                //Calculate Damage
						                DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						                if dmg[0] < 0 then dmg[0] := 0; //No Negative Damage

						                //Send Attacking Packet
						                SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);

						                //Begin Knockback
						                if (dmg[0] > 0) then begin
							                SetLength(bb, 6);
							                bb[0] := 6;
							                xy := ts.Point;
							                DirMove(tm, ts.Point, b, bb);

							                //Knockback Monster
							                if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								                with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
									                assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
									                Delete(IndexOf(ts.ID));
								                end;
								                tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							                end;
							                ts.pcnt := 0;

							                //Update Coordinates of Monster
							                UpdateMonsterLocation(tm, ts);
						                end;

						                if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							                StatCalc1(tc, ts, Tick);

                                                        end else begin
                                                          SendSkillError(tc, 6);
                                                                MMode := 4;
                                                                Exit;
                                                        end;
                                                end;
                                        57:     {Brandish Spear}
                                                begin
                                                        //if ts.HP <= 0 then exit;
                                                        if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
                                                                xy.X := ts.Point.X - Point.X;
			                                        xy.Y := ts.Point.Y - Point.Y;
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
                                                                DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
                                                                if dmg[0] < 0 then dmg[0] := 0;

                                                                SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);


                                                                if (dmg[0] > 0) then begin
                                                                        xy := ts.Point;
					                                sl.Clear;
					                                for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
						                                for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
							                                for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
								                                ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
								                                if ts = ts1 then
                                                                                                        Continue;
								                                if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
									                                sl.AddObject(IntToStr(ts1.ID),ts1);
                                                                                        end;
					                                	end;
					                                end;

				                                	if sl.Count <> 0 then begin
						                                for k1 := 0 to sl.Count - 1 do begin
							                                ts1 := sl.Objects[k1] as TMob;
							                                DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
							                                if dmg[0] < 0 then
                                                                                                dmg[0] := 0;
							                                SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1, 5);

							                                if not DamageProcess1(tm, tc, ts1, dmg[0], Tick) then
        			                        	                                StatCalc1(tc, ts1, Tick);

                                                                                        SetLength(bb, 6);
                                                                                        bb[0] := 6;
                                                                                        xy := ts1.Point;
                                                                                        if ts1.HP <= 0 then break;
                                                                                        DirMove(tm, ts1.Point, b, bb);

                                                                                        if (xy.X div 8 <> ts1.Point.X div 8) or (xy.Y div 8 <> ts1.Point.Y div 8) then begin
                                                                                                with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
                                                                                                        assert(IndexOf(ts1.ID) <> -1, 'MobBlockDelete Error');
                                                                                                        Delete(IndexOf(ts1.ID));
                                                                                                end;
                                                                                        tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);
                                                                                        ts1.pcnt := 0;

                                                                                        UpdateMonsterLocation(tm, ts1);
                                                                                end;

                                	                                end;
					                        end;
                                                        end;

                                                        if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then StatCalc1(tc, ts, Tick);

                                                        end else begin
                                                          SendSkillError(tc, 6);
                                                                MMode := 4;
                                                                Exit;
                                                        end;
                                                end;
        59:
          begin
          if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
          DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
						if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							StatCalc1(tc, ts, Tick);
              tc.MTick := Tick + 1000
          end else begin
            SendSkillError(tc, 6);
            MMode := 4;
            Exit;
          end;
          end;
				62: //BB
					begin
						//Ç∆ÇŒÇ∑ï˚å¸åàíËèàóù
						//FWÇ©ÇÁÇÃÉpÉNÉä
						xy.X := ts.Point.X - Point.X;
						xy.Y := ts.Point.Y - Point.Y;
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

						//íeÇ´îÚÇŒÇ∑ëŒè€Ç…ëŒÇ∑ÇÈÉ_ÉÅÅ[ÉWÇÃåvéZ
						DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);

						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, 3);
							bb[0] := 4;
							xy := ts.Point;
							DirMove(tm, ts.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
									assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(ts.ID));
								end;
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end;
							ts.pcnt := 0;

							//Update Location of Monster
                                                        UpdateMonsterLocation(tm, ts);
							
							xy := ts.Point;
							//ä™Ç´Ç±Ç›îÕàÕçUåÇ
							sl.Clear;
							for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
								for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
									for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
										if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then Continue; ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
										if (ts = ts1) or ((tc.GuildID <> 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID <> 0) and (ts1.GID = tc.GuildID)) then Continue;
										if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
											sl.AddObject(IntToStr(ts1.ID),ts1);
									end;
								end;
							end;
							if sl.Count <> 0 then begin
								for k1 := 0 to sl.Count - 1 do begin
									ts1 := sl.Objects[k1] as TMob;
									DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
									if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
									//ÉpÉPëóêM
									SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1, 5);
									//É_ÉÅÅ[ÉWèàóù
									if not DamageProcess1(tm, tc, ts1, dmg[0], Tick) then
{í«â¡}							StatCalc1(tc, ts1, Tick);
								end;
							end;
						end;
						if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
{í«â¡}				StatCalc1(tc, ts, Tick);
					end;
{:119}
				72: // Status Recovery vs. Mob (undead)
					begin
						ts.ATarget := 0;
						if ts.Element mod 20 = 9 then begin
							//ÉpÉPëóêM
							WFIFOW( 0, $011a);
							WFIFOW( 2, MSkill);
							WFIFOW( 4, MUseLV);
							WFIFOL( 6, MTarget);
							WFIFOL(10, ID);
							WFIFOB(14, 1);
							SendBCmd(tm, ts.Point, 15);
							//ëŒÉAÉìÉfÉbÉh
							if Boolean((1 shl 4) and ts.Stat2) then begin
								ts.HealthTick[4] := ts.HealthTick[4] + 30000; //âÑí∑
							end else begin
								ts.HealthTick[4] := Tick + tc.aMotion;
							end;
						end;
					end;
				76: // Lex Divina vs. Mob
					begin
						//ÉpÉPëóêM
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, ts.Point, 15);
						//ëŒÉAÉìÉfÉbÉh
						if Boolean((1 shl 2) and ts.Stat2) then begin
							ts.HealthTick[2] := ts.HealthTick[2] + 30000; //âÑí∑
						end else begin
							ts.HealthTick[2] := Tick + tc.aMotion;
						end;
					end;
{:119}
				77: // Turn Undead Damage vs. Mob
					begin
						if (ts.Data.Race = 1) or (ts.Element mod 20 = 9) then begin
							m := MUseLV * 20 + Param[3] + Param[5] + BaseLV + (200 - 200 * Cardinal(ts.HP) div ts.Data.HP) div 200;
							if (Random(1000) < m) and (ts.Data.MEXP = 0) then begin
								dmg[0] := ts.HP;
							end else begin
{ïœçX}					dmg[0] := (BaseLV + Param[3] + (MUseLV * 10)) * ElementTable[6][ts.Element] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
							end;
							//ëŒÉAÉìÉfÉbÉh
							//if (dmg[0] div $010000) <> 0 then dmg[0] := $07FFF; //ï€åØ
              // Lex Aeterna effect
              if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;              
							SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
							DamageProcess1(tm, tc, ts, dmg[0], Tick);
							tc.MTick := Tick + 3000;
						end else begin
							tc.MMode := 4;
							Exit;
						end;
					end;
				78: // Lex Aeterna
					begin
						//ÉpÉPëóêM
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, ts.Point, 15);

            // Colus, 20040126: Can't use Stat1 for Lex.  Those effects stop the
            // monster.  Instead we set an effect tick, which (currently) isn't
            // being used for anything!  Convenient!

            if ((ts.Stat1 < 1) or (ts.Stat1 > 2)) then
              ts.EffectTick[0] := $FFFFFFFF;

            tc.MTick := Tick + 3000;
						{if (ts.Stat1 = 0) or (ts.Stat1 = 3) or (ts.Stat1 = 4) then begin
							ts.nStat := 5;
							ts.BodyTick := Tick + tc.aMotion;
						end else if (ts.Stat1 = 5) then ts.BodyTick := ts.BodyTick + 30000;}
          end;
                                              141:  //venom splasher
                                                begin
                                                WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, ts.Point, 15);
                                                if ts.Stat2 = 1 then begin
                                                DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0;

						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
						if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
                                                StatCalc1(tc, ts, Tick);
                                                end else begin
            SendSkillError(tc, 6);
            MMode := 4;
            Exit;
            end;
            end;
				84: //JT
					begin
                                                if tc.ID = ts.ID then Exit;

						xy.X := ts.Point.X - Point.X;
						xy.Y := ts.Point.Y - Point.Y;
						if abs(xy.X) > abs(xy.Y) * 3 then begin
							//â°å¸Ç´
							if xy.X > 0 then   b := 6 else b := 2;
						end else if abs(xy.Y) > abs(xy.X) * 3 then begin
							//ècå¸Ç´
							if xy.Y > 0 then   b := 0 else b := 4;
						end else begin
							if xy.X > 0 then begin
								if xy.Y > 0 then b := 7 else b := 5;
							end else begin
								if xy.Y > 0 then b := 1 else b := 3;
							end;
						end;

						//É_ÉÅÅ[ÉWéZèo
						dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
						dmg[0] := dmg[0] * (100 - ts.Data.MDEF) div 100; //MDEF%
						dmg[0] := dmg[0] - ts.Data.Param[3]; //MDEF-
						if dmg[0] < 1 then dmg[0] := 1;
						dmg[0] := dmg[0] * ElementTable[tl.Element][ts.Element] div 100;
						dmg[0] := dmg[0] * tl.Data2[MUseLV];
						if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
            if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
            SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], tl.Data2[MUseLV]);
						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, tl.Data2[MUseLV] div 2);
							bb[0] := 4;
							xy.X := ts.Point.X;
							xy.Y := ts.Point.Y;
							DirMove(tm, ts.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
									assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(ts.ID));
								end;
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end;
							ts.pcnt := 0;
						//Update Monster Location
						UpdateMonsterLocation(tm, ts);
						end;
						DamageProcess1(tm, tc, ts, dmg[0], Tick);
					end;
                    
    88: // Frost Nova
    begin

        dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100;
        dmg[0] := dmg[0] * (100 - ts.Data.MDEF) div 100; //MDEF%
        dmg[0] := dmg[0] - ts.Data.Param[3]; //MDEF-

        if dmg[0] < 1 then
          dmg[0] := 1;

        dmg[0] := dmg[0] * ElementTable[tl.Element][ts.Element] div 100;
          
        if dmg[0] < 0 then
          dmg[0] := 0;

        if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
                  
        SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1 , 5);

        if (ts.Data.race <> 1) and (ts.Data.MEXP = 0) and (dmg[0] <> 0) then begin
          if Random(1000) < tl.Data1[MUseLV] * 10 then begin
            ts.nStat := 2;
            ts.BodyTick := Tick + tc.aMotion;
          end;
        end;

        
        DamageProcess1(tm, tc, ts, dmg[0], Tick);

        tc.MTick := Tick + 1000;
  
    end;


    {

    AlexKreuz: I don't know why all this code is even here, esp. since
    SendCSkillAtk1 is determined with fixed dmg of 35000.

    SendCSkillAtk1(tm, tc, ts, 15, 35000, 1, 6);
    xy := ts.Point;
    sl.Clear;
    for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
      for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
        for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin

          if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then
            Continue;

          ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;

          if (ts = ts1) or ((tc.GuildID <> 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID <> 0) and (ts1.GID = tc.GuildID)) then
            Continue;

          if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
            sl.AddObject(IntToStr(ts1.ID),ts1);
        end;
      end;
    end;
    
    if sl.Count <> 0 then begin
      for k1 := 0 to sl.Count - 1 do begin
        ts1 := sl.Objects[k1] as TMob;
        dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100;
        dmg[0] := dmg[0] * (100 - ts1.Data.MDEF) div 100; //MDEF%
        dmg[0] := dmg[0] - ts1.Data.Param[3]; //MDEF-

        if dmg[0] < 1 then
          dmg[0] := 1;

        dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100;
          
        if dmg[0] < 0 then
          dmg[0] := 0;

        SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1 , 5);

        if (ts1.Data.race <> 1) and (ts1.Data.MEXP = 0) and (dmg[0] <> 0) then begin
          if Random(1000) < tl.Data1[MUseLV] * 10 then begin
            ts1.nStat := 2;
            ts1.BodyTick := Tick + tc.aMotion;
          end;
        end;

      end;
    end;}

				86: // Water Ball
					begin
            k := tl.Data2[MUseLV];
            b := 0;
            for j1 := (tc.Point.Y - k)  to (tc.Point.Y + k) do begin
              for i1 := (tc.Point.X - k) to (tc.Point.X + k) do begin
                if (tm.gat[i1][j1] = 3) then b := 1;
              end;
            end;

            if (b = 0) then begin
              SendSkillError(tc, 0);
              tc.MMode := 4;
              tc.MPoint.X := 0;
              tc.MPoint.Y := 0;
              exit;
            end;

            tc.Skill[86].Tick := Tick;
                                                k := tl.Data1[MUseLV];
            tc.Skill[86].EffectLV := k;
            tc.Skill[86].Effect1 := tc.MUseLV;
            DamageOverTime(tm, tc, Tick, 86, MUseLV, k);

            //for m := 0 to k - 1 do begin
            {if dmg[1] <> 0 then begin
                                                        dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100;
                                                        dmg[0] := dmg[0] * (100 - ts.Data.MDEF) div 100; //MDEF%
                                                        dmg[0] := dmg[0] - ts.Data.Param[3]; //MDEF-
                                                        if dmg[0] < 1 then dmg[0] := 1;
                                                        dmg[0] := dmg[0] * ElementTable[tl.Element][ts.Element] div 100;
                                                        if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï

                                                        if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;

                                                        SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
                                                        //É_ÉÅÅ[ÉWèàóù
                                                        DamageProcess1(tm, tc, ts, dmg[0], Tick);
                				        xy := ts.Point;
						        sl.Clear;
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
              end; }
            //end;
					end;
				93: //ÉÇÉìÉXÉ^Å[èÓïÒ
					begin
						ts := AData;
						WFIFOW(0, $018c);
						WFIFOW(2, ts.Data.ID);//ID
						WFIFOW(4, ts.Data.LV);//ÉåÉxÉã
						WFIFOW(6, ts.Data.Scale);//ÉTÉCÉY
						WFIFOL(8, ts.HP);//HP
						//WFIFOW(10, 0);//
						WFIFOW(12, ts.Data.DEF);//DEF
						WFIFOW(14, ts.Data.Race);//éÌë∞
						WFIFOW(16, ts.Data.MDEF);//MDEF
						WFIFOW(18, ts.Element);//ëÆê´
						for j := 0 to 8 do begin
							if (ElementTable[j+1][ts.Element] < 0) then begin
								WFIFOB(20+j, 0);//É}ÉCÉiÉXÇæÇ∆îÕàÕÉGÉâÅ[èoÇ∑ÇÃÇ≈0Ç…Ç∑ÇÈ
							end else begin
								WFIFOB(20+j, ElementTable[j+1][ts.Element]);//ñÇñ@ëäê´ëÆê´
							end;
						end;
						Socket.SendBuf(buf,29);//édólÇ∆ÇµÇƒÇÕÇ±Ç¡ÇøÇÃï˚Ç™ÇﬁÇµÇÎÇ¢Ç¢ÇÃÇ≈ÇÕÅHñ{êlÇÃÇ›Ç…å©ÇπÇÈ
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, dmg[0]);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, ts.Point, 15);
					end;
				129://Blitz beat
					begin
						xy := ts.Point;
						//É_ÉÅÅ[ÉWéZè
            if tc.Option and 16 <> 0 then begin
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
									if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then Continue; ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
									if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(ts1.ID),ts1);
							 	end;
							end;
						end;
						if sl.Count <> 0 then begin
							if Skill[128].Lv <> 0 then begin
								dmg[1] := Skill[128].Data.Data1[Skill[128].Lv] * 2;
							end else begin
								dmg[1] := 0
							end;
							dmg[1] := dmg[1] + (Param[4] div 10 + Param[3] div 2) * 2 + 80;
							dmg[1] := dmg[1] * MUseLV;
							for k1 := 0 to sl.Count - 1 do begin
								ts1 := sl.Objects[k1] as TMob;
								dmg[0] := dmg[1] * ElementTable[tl.Element][ts1.Element] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                if (ts1.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
								SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], MUseLV);
								//É_ÉÅÅ[ÉWèàóù
								DamageProcess1(tm, tc, ts1, dmg[0], Tick);
							end;
						end;
                                                end else begin
                                                MMode := 4;
                                                Exit;
                                                end;
					end;
{}      136:
          begin
            if (tc.Weapon = 16) then begin
            DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
            j := 8;
						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], j);
						if (Skill[145].Lv <> 0) and (MSkill = 5) and (MUseLV > 5) then begin //ã}èäìÀÇ´
							if Random(1000) < Skill[145].Data.Data1[MUseLV] * 10 then begin
								if (ts.Stat1 <> 3) then begin
									ts.nStat := 3;
									ts.BodyTick := Tick + tc.aMotion;
								end else ts.BodyTick := ts.BodyTick + 30000;
							end;
						end;
						if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							StatCalc1(tc, ts, Tick);
              tc.MTick := Tick + 1000;
            end else begin
            MMode := 4;
            Exit;
            end;
          end;
        137:    {Grimtooth}
          begin
            if (tc.Option and 2 <> 0) and (Weapon = 16) then begin
          	DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
						if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							StatCalc1(tc, ts, Tick);
						xy := ts.Point;
						//É_ÉÅÅ[ÉWéZèo2
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
									if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then Continue; ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
									if (ts = ts1) or ((tc.GuildID <> 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID <> 0) and (ts1.GID = tc.GuildID)) then Continue;
									if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(ts1.ID),ts1);
                end;
							end;
            end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								ts1 := sl.Objects[k1] as TMob;
								DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
								if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								//ÉpÉPëóêM
								SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1, 5);
								//É_ÉÅÅ[ÉWèàóù
								if not DamageProcess1(tm, tc, ts1, dmg[0], Tick) then
{í«â¡}						StatCalc1(tc, ts1, Tick);
							end;
						end;
            end else begin
            MMode := 4;
            Exit;
            end;
          end;
				148: //É`ÉÉÅ[ÉW_ÉAÉçÅ[
					begin
						//Ç∆ÇŒÇ∑ï˚å¸åàíËèàóù
						//FWÇ©ÇÁÇÃÉpÉNÉä
						xy.X := ts.Point.X - Point.X;
						xy.Y := ts.Point.Y - Point.Y;
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

						//íeÇ´îÚÇŒÇ∑ëŒè€Ç…ëŒÇ∑ÇÈÉ_ÉÅÅ[ÉWÇÃåvéZ
						DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);

						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, 6);
							bb[0] := 6;
							xy := ts.Point;
							DirMove(tm, ts.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
									assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(ts.ID));
								end;
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end;
							ts.pcnt := 0;
							//Update Monster Location
                                                        UpdateMonsterLocation(tm, ts);
						end;
						if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							StatCalc1(tc, ts, Tick);
					end;
        149:
          begin

              DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
              dmg[0] := Round(dmg[0] * 1.25);
              j := 1;
						  if dmg[0] < 0 then dmg[0] := 0;
						  SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], j);
						  if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							StatCalc1(tc, ts, Tick);

          end;
				397: // Spiral Pierce
					begin
						//tc1 := tc;
						//ProcessType := 1;
            SendCSkillAtk1(tm, tc, ts, Tick, 1, 1);
						tc.MTick := Tick + 2000;
					end;
				398: // Head Crush
					begin
						//tc1 := tc;
						//ProcessType := 1;
            SendCSkillAtk1(tm, tc, ts, Tick, 1, 1);
						tc.MTick := Tick + 2000;
					end;
				399: // Joint Beat
					begin
						//tc1 := tc;
						//ProcessType := 1;
            SendCSkillAtk1(tm, tc, ts, Tick, 1, 1);
						tc.MTick := Tick + 2000;
					end;
				400: // Napalm Vulcan
					begin
						//tc1 := tc;
						//ProcessType := 1;
            SendCSkillAtk1(tm, tc, ts, Tick, 100, tc.Skill[MSkill].Data.Data2[MUseLV]);
						tc.MTick := Tick + 2000;
					end;

        402: // Mind Breaker
					begin
					ts.ATarget := tc.ID;
					ts.ARangeFlag := false;
					ts.AData := tc;
					//ÉpÉPëóêM
					WFIFOW( 0, $011a);
					WFIFOW( 2, MSkill);
					WFIFOW( 4, MUseLV);
					WFIFOL( 6, MTarget);
					WFIFOL(10, ID);
					if ts.Data.Race <> 1 then begin
						WFIFOB(14, 1);
						ts.ATKPer := word(tl.Data1[MUseLV]);
						ts.DEFPer := word(tl.Data2[MUseLV]);
					end else begin
						WFIFOB(14, 0);
					end;
					SendBCmd(tm, ts.Point, 15);

					tc.MTick := Tick + 2000;

					end;

        403: // Memorize
					begin
            tc1 := tc;
            ProcessType := 1;

					end;

				152: //êŒìäÇ∞
					begin
            j := SearchCInventory(tc, 7049, false);
						if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
							UseItem(tc, j);
              dmg[0] := 30;
						  dmg[0] := dmg[0] * ElementTable[tl.Element][0] div 100;
              if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
	  					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
              if Random(1000) < Skill[152].Data.Data1[MUseLV] * 10 then begin
 								if (ts.Stat1 <> 3) then begin
									ts.nStat := 3;
									ts.BodyTick := Tick + tc.aMotion;
								end else ts.BodyTick := ts.BodyTick + 30000;
              end;
			  			DamageProcess1(tm, tc, ts, dmg[0], Tick, False);
						end else begin
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
						end;
					end;
        153:
          begin
            xy.X := ts.Point.X - Point.X;
						xy.Y := ts.Point.Y - Point.Y;
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

            //DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
            DamageCalc1(tm, tc, ts, Tick, 0, 150 + (tc.Cart.Weight div 800), tl.Element, 0);
						//dmg[0] := dmg[0] + ((100 + (tc.Cart.Weight div 800)) div 100);
            if dmg[0] < 0 then dmg[0] := 0;

						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);

            if (dmg[0] > 0) then begin
							SetLength(bb, 2);
							bb[0] := 0; // Just push in the direction you're casting
              bb[1] := 0; // for 2 tiles.
							xy := ts.Point;
							DirMove(tm, ts.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
									assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(ts.ID));
								end;
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end;
							ts.pcnt := 0;
							//Update Monster Location
							UpdateMonsterLocation(tm, ts);
						end;
						if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
            StatCalc1(tc, ts, Tick);

						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
									if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then Continue; ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
									if (ts = ts1) or ((tc.GuildID <> 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID <> 0) and (ts1.GID = tc.GuildID)) then Continue;
									if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(ts1.ID),ts1);
								end;
							end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								ts1 := sl.Objects[k1] as TMob;

            xy.X := ts1.Point.X - Point.X;
						xy.Y := ts1.Point.Y - Point.Y;
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

								DamageCalc1(tm, tc, ts1, Tick, 0, 150 + (tc.Cart.Weight div 800), tl.Element, 0);
								//dmg[0] := dmg[0] + (tc.Cart.MaxWeight div 8000);
                if dmg[0] < 0 then dmg[0] := 0;

              if (dmg[0] > 0) then begin
							SetLength(bb, 2);
							bb[0] := 0; // Just push in the direction you're casting
              bb[1] := 0; // for 2 tiles.
							//bb[0] := 6;
							xy := ts1.Point;
							DirMove(tm, ts1.Point, b, bb);
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
								if not DamageProcess1(tm, tc, ts1, dmg[0], Tick) then
    						StatCalc1(tc, ts1, Tick);
							end;
						end;


          end;
          end;

			end else begin
				if tc.MTick + 500 < Tick then begin
					MMode := 4;
					Exit;
				end;
			end;

{TC1 BECOMES TARGET}


		end else begin //MTargetType = 0
			tc1 := tc.AData;
                        if tc1.NoTarget = true then exit;


			if (tc1 = nil) or ((tc1.HP = 0) and (MSkill <> 54)) Then begin
        MSkill := 0;
				MUseLv := 0;
				MMode := 0;
				MTarget := 0;
				Exit;
      end;
				if (abs(Point.X - tc1.Point.X) <= tl.Range) and (abs(Point.Y - tc1.Point.Y) <= tl.Range) then begin

			case tc.MSkill of
        //Assassin Skills
        139: //Poison React
          begin
            tc1 := tc;
            ProcessType := 3;
            MTick := Tick + 100;
          end;
 				401: // Gather Souls
					begin
            tc1 := tc;
            ProcessType := 1;
            tc.spiritSpheres := 5;
            UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

					end;

        //Alchemist Skills
        231:  //Potion Pitcher
          begin
            j := SearchCInventory(tc, tc.Skill[231].Data.Data2[MUseLV], false);
            if (j <> 0) and (tc.Item[j].Amount >= 1) then begin

              UseItem(tc, j);

              if (tc1.Sit <> 1) then begin
                k := tc.Skill[231].Data.Data2[MUseLV];
                td := ItemDB.IndexOfObject(k) as TItemDB;

                {Colus, 20040116:
                  Level 5 Potion Pitcher is a blue pot, not a green one.  Don't
                  change this no matter what people claim. :)
                  Also, using target's VIT/INT on this instead of alch's...it's definitely
                  possible to get a 4K heal on a crusader with a white pot.
                  }
                if (td.SP1 <> 0) then begin
									dmg[0] := ((td.SP1 + Random(td.SP2 - td.SP1 + 1)) * (100 + tc1.Param[3]) div 100) * tc.Skill[231].Data.Data1[tc.Skill[231].Lv] div 100;
                  if (tc.ID = tc1.ID) then dmg[0] := dmg[0] * tc.Skill[227].Data.Data1[tc.Skill[227].Lv] div 100;
      						tc1.SP := tc1.SP + dmg[0];
									if tc1.SP > tc1.MAXSP then tc1.SP := tc1.MAXSP;
									SendCStat1(tc1, 0, 7, tc.SP);

                  // Is there no way to show SP heal graphic on the target to others?
                  // I guess there isn't one...oh, well.  SP recovery to self is done
                  // with the SP recovery graphic.

                  WFIFOW( 0, $013d);
                  WFIFOW( 2, $0007);
    						  WFIFOW( 4, dmg[0]);
    						  tc1.Socket.SendBuf(buf, 6);

                end else begin
  						    dmg[0] := ((td.HP1 + Random(td.HP2 - td.HP1 + 1)) * (100 + tc1.Param[2]) div 100) * tc.Skill[231].Data.Data1[tc.Skill[231].Lv] div 100 * (100 + tc1.Skill[4].Lv * 10) div 100;
                  if (tc.ID = tc1.ID) then dmg[0] := dmg[0] * tc.Skill[227].Data.Data1[tc.Skill[227].Lv] div 100;
      						tc1.HP := tc1.HP + dmg[0];
  				        if tc1.HP > tc1.MAXHP then tc1.HP := tc1.MAXHP;
                  SendCStat1(tc1, 0, 5, tc1.HP);

                  // Show heal graphics on target
                  WFIFOW( 0, $011a);
                  WFIFOW( 2, 28);  // We cheat and use the heal skill for the gfx
                  WFIFOW( 4, dmg[0]);
                  WFIFOL( 6, tc1.ID);
                  WFIFOL(10, tc.ID);
                  WFIFOB(14, 1);
                  SendBCmd(tm, tc1.Point, 15);

                end;

						    ProcessType := 0;
						    tc.MTick := Tick + 500; // Delay after is .5s

              end else begin
                MMode := 4;
                Exit;
              end;
            end;
          end;
                                //New skills ---- Crusader
                                249: //Auto Gaurd
                                        begin
                                                if Shield <> 0 then begin;
                                                ProcessType := 3;
						tc.MTick := Tick + 1000;
                                                end else begin
                                                Exit;
                                                end;
                                        end;
                                252: //Reflect Shield
                                        begin
                                                if Shield <> 0 then begin;
                                                ProcessType := 3;
                                                MTick := Tick + 100;
                                                end else begin
                                                Exit;
                                                end;
                                        end;
                                 254:  {Grand Cross}
                                        begin
                                                NoCastInterrupt := true;
                                                PassiveAttack := True;
                                                tc.MTargetType := 0;
                                                SkillEffect(tc, Tick);
                                        end;

                                    
                                255:  //Devotion
					begin
						tc1 := tc;
						ProcessType := 5;
					end;
                                256: //Providence
                                        begin
						tc1 := tc;
						ProcessType := 3;
					end;
                                257: //Defender
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
                                //Monk Skills
                                261:  //Call Spirits
                                        begin
                                                tc1 := tc;
                                                ProcessType := 2;
                                                tc.spiritSpheres := tc.spiritSpheres + Skill[261].Data.Data1[Skill[261].Lv];
                                                if tc.spiritSpheres > 5 then tc.spiritSpheres := 5;
                                                if tc.spiritSpheres > Skill[261].Data.Data2[Skill[261].Lv] then tc.spiritSpheres := Skill[261].Data.Data2[Skill[261].Lv];
                                                UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
                                               { tc1 := tc;
                                                ProcessType := 2;
                                                tc.spiritSpheres := tc.spiritSpheres + Skill[261].Data.Data2[Skill[261].Lv];
                                                if tc.spiritSpheres > 5 then tc.spiritSpheres := 5;
                                                UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
                                                {WFIFOW( 0, $01d0);
                                                WFIFOL( 2, tc.ID);
                                                WFIFOW( 6, spiritspheres);
                                                SendBCmd(tm, tc.Point, 16);}
                                                //Create_Spirit_Sphere(1, spiritSpheres);}
                                        end;
                                262:  //Absorb Spirits
                                        if tc.spiritSpheres <> 0 then begin
                                          // Colus, 20040203: Fixed proper SP recovery amount, show SP recovery effect
                                          i := tc.spiritSpheres * Skill[262].Data.Data2[Skill[262].Lv];
                                          tc.spiritSpheres := 0;
                                          tc.SP := tc.SP + i;
                                          if tc.SP > tc.MAXSP then tc.SP := tc.MAXSP;
                                          UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
                                          WFIFOW( 0, $013d);
                                          WFIFOW( 2, $0007);
                            						  WFIFOW( 4, i);
                            						  tc1.Socket.SendBuf(buf, 6);
                                        end;
                                268:   //Steel Body
                                                if tc.spiritSpheres = 5 then begin
                                                        tc1 := tc;
                                                        ProcessType := 3;
                                                        tc.spiritSpheres := tc.spiritSpheres - 5;
                                                        UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
                                                end else begin
                                                  exit;  // Colus - This ability must have 5 spheres!
                                                end;
                                 270:   //Explosion Spirits

                                                if tc.spiritSpheres = 5 then begin
                                                        tc1 := tc;
                                                        ProcessType := 3;
                                                        tc.spiritSpheres := tc.spiritSpheres - 5;
                                                        UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
                                                end else begin
                                                        exit;
                                                end;
                                 272:   {Chain Combo Setup}
                                        begin
                                                if (Skill[263].Tick > Tick) and (Skill[272].Tick < Tick) and ((tc.Weapon = 12) or (tc.Weapon = 0)) then begin
                                                        PassiveAttack := True;
                                                        tc.MTargetType := 0;
                                                        Monkdelay(tm, tc, Delay);
                                                        SkillEffect(tc, Tick);

                                                end else begin
                                                        SendSkillError(tc, 0);
                                                        MMode := 4;
                                                        Exit;
                                                end;
                                        end;

                                 273:   {Combo Finish Setup}
                                        begin
                                                if (Skill[272].Tick > Tick) and (tc.spiritSpheres >= 1) and ((tc.Weapon = 12) or (tc.Weapon = 0)) then begin
                                                        PassiveAttack := True;
                                                        tc.MTargetType := 0;
                                                        SkillEffect(tc, Tick);
                                                end else begin
                                                        SendSkillError(tc, 0);
                                                        MMode := 4;
                                                        Exit;
                                                end;

                                        end;
                                        271: // COLUS NEW ASHURA
                                        begin
                                              ts := tc.AData;
                                              if (ts is TMob) then begin
                                              PassiveAttack := True;
                                                        tc.MTargetType := 0;
                                                        SkillEffect(tc, Tick);
                                                        exit;
                                              end;
                                              tc1 := tc.AData;
                                                if tc.Skill[270].Tick > Tick then begin
                                                  if (tc.Skill[271].Data.SType = 4) then begin
                                                        processtype := 255;
                                                        if tc.spiritSpheres >= 4 then begin

                                                        DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
                                                        spbonus := tc.SP;
                                                        dmg[0] := dmg[0] *(8 + tc.SP div 100) + 250 + (tc.Skill[271].Lv * 150);
                                                        dmg[0] := dmg[0] + j;
                                                        if dmg[0] < 0 then begin
                                                                dmg[0] := 0;
                                                                //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                                                        end;
                                                        SetLength(bb, 6);
                                                        //bb[0] := 6;

                                                        xy := tc.Point;
                                                        DirMove(tm, tc.Point, tc.Dir, bb);

                                                        if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
                                                                with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
                                                                        assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
                                                                        Delete(IndexOf(tc.ID));
                                                                end;
                                                                tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
                                                        end;
                                                        tc.pcnt := 0;

                                                        UpdatePlayerLocation(tm, tc);

                                                        SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
                                                        DamageProcess2(tm, tc, tc1, dmg[0], Tick);
                                                        tc.MTick := Tick + Cardinal(3500 + (tl.CastTime2 * MUseLV));
                                                        tc.spiritSpheres := 0;
                                                        UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

                                                        {20031223, Colus: Cancel Explosion Spirits after Ashura
                                                         Ashura's tick will control SP lockout time}
                                                        tc.Skill[271].Tick := Tick + 300000;
                                                        tc.Skill[270].Tick := Tick;
                                                        tc.SkillTick := Tick;
                                                        tc.SkillTickID := 270;
                                                        tc.SP := 0;
                                                        SendCStat(tc);
                                                        tc.Skill[271].Data.SType := 1;
                                                        tc.Skill[271].Data.CastTime1 := 4500;
                                                        SendCSkillList(tc);

                                                  end;
                                                end else if (tc.Skill[271].Data.SType = 1) then begin
                                                       processtype := 255;
                                                        if tc.spiritSpheres = 5 then begin
                                                        DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
                                                        spbonus := tc.SP;
                                                        dmg[0] := dmg[0] *(8 + tc.SP div 100) + 250 + (tc.Skill[271].Lv * 150);
                                                        dmg[0] := dmg[0] + j;
                                                        if dmg[0] < 0 then begin
                                                                dmg[0] := 0;
                                                                //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                                                        end;
                                                        SetLength(bb, 6);
                                                        bb[0] := 6;

                                                        xy := tc.Point;
                                                        DirMove(tm, tc.Point, tc.Dir, bb);

                                                        if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
                                                                with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
                                                                        assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
                                                                        Delete(IndexOf(tc.ID));
                                                                end;
                                                                tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
                                                        end;
                                                        tc.pcnt := 0;

                                                        UpdatePlayerLocation(tm, tc);

                                                        SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
                                                        DamageProcess2(tm, tc, tc1, dmg[0], Tick);
                                                        tc.MTick := Tick + Cardinal(3500 + (tl.CastTime2 * MUseLV));
                                                        tc.spiritSpheres := tc.spiritSpheres - 5;
                                                        UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

                                                        {20031223, Colus: Cancel Explosion Spirits after Ashura
                                                         Ashura's tick will control SP lockout time}
                                                        tc.Skill[271].Tick := Tick + 300000;
                                                        tc.Skill[270].Tick := Tick;
                                                        tc.SkillTick := Tick;
                                                        tc.SkillTickID := 270;
                                                        tc.SP := 0;
                                                        SendCStat(tc);
                                                        end;
                                                end;
                                          end;
                                        end;
                                         371:   {Combo Finish Setup}
                                        begin
                                                if (Skill[273].Tick > Tick) and (tc.spiritSpheres >= 1) and ((tc.Weapon = 12) or (tc.Weapon = 0)) then begin
                                                        PassiveAttack := True;
                                                        tc.MTargetType := 0;
                                                        SkillEffect(tc, Tick);
                                                end else begin
                                                        SendSkillError(tc, 0);
                                                        MMode := 4;
                                                        Exit;
                                                end;

                                        end;
                                         372:   {Combo Finish Setup}
                                        begin
                                                if (Skill[273].Tick > Tick) and (tc.spiritSpheres >= 2 ) and ((tc.Weapon = 12) or (tc.Weapon = 0)) then begin
                                                        PassiveAttack := True;
                                                        tc.MTargetType := 0;
                                                        SkillEffect(tc, Tick);
                                                end else begin
                                                        SendSkillError(tc, 0);
                                                        MMode := 4;
                                                        Exit;
                                                end;

                                        end;
                                //End Monk Skills

                                //Sage
                                275:    {Cast Cancel}
                                        begin
                                                //tc.SP := tc.SP - tc.Skill
                                                // Colus, 20040203:
                                                // Reduce SP of last casted spell (saved in Effect1 and EffectLV) by factor based on CC's level
                                                tc.SP := tc.SP - (Skill[Skill[275].Effect1].Data.SP[Skill[275].EffectLV] * Skill[275].Data.Data2[tc.MUseLV] div 100);
                                                if tc.SP < 0 then tc.SP := 0;
                                                tc.MMode := 0;
				                tc.MTick := Tick;
				                tc.MTarget := 0;
				                tc.MPoint.X := 0;
				                tc.MPoint.Y := 0;
                                                
                                                //Update SP
                                                SendCStat1(tc, 0, $0007, tc.SP);

                                                //Cancel Cast Timer
                                                WFIFOW(0, $01b9);
                                                WFIFOL(2, tc.ID);
                                                SendBCmd(tm, tc.Point, 6);
                                                //ProcessType := 4;
                                        end;
                                279:    {Autocast}
                                        begin
                                          ZeroMemory(@buf[0], 30);
                                          WFIFOW(0, $01cd);
                                          // Napalm Beat at L1
                                          if tc.Skill[11].Lv > 0 then WFIFOL(2, 11);
                                          // CB/FB/LB at L2-L4
                                          if (tc.Skill[14].Lv > 0) and (tc.Skill[279].Lv > 1) then WFIFOL(6, 14);
                                          if (tc.Skill[19].Lv > 0) and (tc.Skill[279].Lv > 1) then WFIFOL(10, 19);
                                          if (tc.Skill[20].Lv > 0) and (tc.Skill[279].Lv > 1) then WFIFOL(14, 20);
                                          // SS at L5-L7
                                          if (tc.Skill[13].Lv > 0) and (tc.Skill[279].Lv > 4) then WFIFOL(18, 13);
                                          // FBall at L8-L9
                                          if (tc.Skill[17].Lv > 0) and (tc.Skill[279].Lv > 7) then WFIFOL(22, 17);
                                          // FD at L10
                                          if (tc.Skill[15].Lv > 0) and (tc.Skill[279].Lv > 9) then WFIFOL(26, 15);
                                          tc.Socket.SendBuf(buf, 30);
                                                tc1 := tc;
                                                ProcessType := 3;
                                        end;
                                280,281,282,283: {Flamelauncher, Frost Weapon, Lightning Loader, Seismic Weapon}
					begin
                                                Skill[280].Tick := Tick;
                                                Skill[281].Tick := Tick;
                                                Skill[282].Tick := Tick;
                                                Skill[283].Tick := Tick;
						ProcessType := 3;
					end;


                                //Item Skills

                                291:  {Attack Speed Potions}
					begin
						tc1 := tc;
						ProcessType := 3;

                                                {WFIFOW( 0, $011a);
						WFIFOW( 2, 258);
						WFIFOW( 4, 1);
						WFIFOL( 6, tc1.ID);
						WFIFOL(10, ID);
						WFIFOB(14, 1);}
						{SendBCmd(tm, tc1.Point, 15);
                                                tc1.Skill[291].Tick := Tick + cardinal(tl.Data1[MUseLV]) * 1000;
						tc1.Skill[291].EffectLV := MUseLV;
						tc1.Skill[291].Effect1 := tl.Data2[MUseLV];

						if SkillTick > tc1.Skill[MSkill].Tick then begin
							SkillTick := tc1.Skill[291].Tick;
							SkillTickID := 291;
						end;

						CalcStat(tc1, Tick);
						SendCStat(tc1);

			                        if tl.Icon <> 0 then begin
							WFIFOW(0, $0196);
							WFIFOW(2, tl.Icon);
							WFIFOL(4, ID);
							WFIFOB(8, 1);
                                                        SendBCmd(tm, tc1.Point, 9);
						end;}
                                        end;

                                {Bard}
                                304:    {Adaption}
                                        begin
                                                tc.LastSong := 0;
                                                tc.LastsongLV := 0;
                                                tc.SongTick := Tick;
                                        end;

                                305:    {Encore}
                                        if tc.SongTick > Tick then begin
                                                if tc.LastSong = 0 then exit;
                                                tc.MSkill := tc.LastSong;
                                                tc.MUseLV := tc.LastSongLV;
                                                tc.SP := tc.SP - (tc.Skill[MSkill].Data.SP[tc.MUseLV] div 2);
                                                DecSP(tc, MSkill, MUseLV);
                                                CreateField(tc, Tick);
                                        end;




                                {63:     Peco Peco Riding
                                        begin
                                                tc1 := tc;
                                                ProcessType := 3;
                                        end;}
                                //New Professor Skills
                                373:  //Hp Conversion
                                begin
                                  i := Skill[373].Data.Data1[MUseLv];
                                  if tc.HP - i > 0 then begin
                                    i := Skill[373].Data.Data1[MUseLv];
	                                  tc.HP := tc.HP - i;
	                                  tc.SP := tc.SP + i;
                                    dmg[0] := Skill[373].Data.Data1[MUseLv];
	                                  if tc.SP > tc.MAXSP then tc.SP := tc.MAXSP;
                                    WFIFOW( 0, $013d);
                                    WFIFOW( 2, $0007);
    						                    WFIFOW( 4, dmg[0]);
    						                    tc.Socket.SendBuf(buf, 6);
                                    SendCStat(tc);
                                    //SendCStat1(tc, 0, 5, tc.HP);

                                  end else begin
                                    SendSkillError(tc, 0);
                                    MMode := 4;
                                    Exit;
                                  end;
                                end;

      	                        8: //ÉCÉìÉfÉÖÉA
					begin
						tc1 := tc;
						ProcessType := 2;
					end;
    10,24: {Ruwatch, Sight}
        begin
            if (MSkill = 10) then Option := Option or 1 else Option := Option or $2000;
            UpdateOption(tm, tc);
            ProcessType := 2;

            xy := tc.Point;
            sl.Clear;

            for j1 := (xy.Y - tl.Range) div 8 to (xy.Y + tl.Range) div 8 do begin
                for i1 := (xy.X - tl.Range) div 8 to (xy.X + tl.Range) div 8 do begin
                    for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
                        if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue; tc1 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
                        if (abs(tc1.Point.X - xy.X) <= tl.Range) and (abs(tc1.Point.Y - xy.Y) <= tl.Range) then
                            sl.AddObject(IntToStr(tc1.ID),tc1);
                    end;
                end;
            end;

            if sl.Count <> 0 then begin
                for k1 := 0 to sl.Count - 1 do begin
                    tc1 := sl.Objects[k1] as TChara;
                    if (tc1.Option and 6 <> 0) then begin
                        tc1.Option := tc1.Option and $FFF9;
                        tc1.Hidden := false;
                        tc1.SkillTick := tc1.Skill[51].Tick;
                        tc1.SkillTickID := 51;
                        CalcStat(tc1, Tick);

                        UpdateOption(tm, tc1);

                        // Colus, 20031228: Tunnel Drive speed update
                        if (tc1.Skill[213].Lv <> 0) then begin
                          SendCStat1(tc1, 0, 0, tc1.Speed);
                        end;
                    end;
                end;
            end;
        end;

				28:     {Heal}
					begin
            if (tc1.Sit <> 1) then begin
              dmg[0] := ((BaseLV + Param[3]) div 8) * tl.Data1[MUseLV];
              if (tc1.ArmorElement mod 20 <> 9) then begin
                tc1.HP := tc1.HP + dmg[0];
                if tc1.HP > tc1.MAXHP then tc1.HP := tc1.MAXHP;
                SendCStat1(tc1, 0, 5, tc1.HP);
                ProcessType := 0;
              end else begin
  							SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
  							DamageProcess2(tm, tc, tc1, dmg[0], Tick);
                exit;                
              end;

              tc.MTick := Tick + 1000;
            end else begin
              MMode :=4;
              Exit;
              end;
          end;

				29: // Agility Up
					begin
						ProcessType := 3;
						tc.MTick := Tick + 1000;
					end;

				31: // Aqua Benedicta
					begin

            j := SearchCInventory(tc, 713, false);
						if (j <> 0) and (tc.Item[j].Amount >= 1) and (tm.gat[tc.Point.X][tc.Point.Y] = 3) then begin

							UseItem(tc, j);

              td := ItemDB.IndexOfObject(523) as TItemDB;
							if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) then begin
								k := SearchCInventory(tc, td.ID, td.IEquip);
								if k <> 0 then begin
									if tc.Item[k].Amount < 30000 then begin

									UpdateWeight(tc, k, td);
									{tc.Item[k].ID := td.ID;
                                                                        tc.Item[k].Amount := tc.Item[k].Amount + 1;
                                                                        tc.Item[k].Equip := 0;
                                                                        tc.Item[k].Identify := 1;
                                                                        tc.Item[k].Refine := 0;
                                                                        tc.Item[k].Attr := 0;
                                                                        tc.Item[k].Card[0] := 0;
                                                                        tc.Item[k].Card[1] := 0;
                                                                        tc.Item[k].Card[2] := 0;
                                                                        tc.Item[k].Card[3] := 0;
                                                                        tc.Item[k].Data := td;
									//èdó í«â¡
									tc.Weight := tc.Weight + cardinal(td.Weight);
									WFIFOW( 0, $00b0);
									WFIFOW( 2, $0018);
									WFIFOL( 4, tc.Weight);}
									//Socket.SendBuf(buf, 8);

									//ÉAÉCÉeÉÄÉQÉbÉgí ím
									SendCGetItem(tc, k, 1);
                end;
								end;
							end else begin
								//èdó ÉIÅ[ÉoÅ[
								WFIFOW( 0, $00a0);
								WFIFOB(22, 2);
								Socket.SendBuf(buf, 23);
							end;



						end else begin
              SendSkillError(tc, 0);
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
							Exit;
						end;
					end;
        32: // Signum Crucis
					begin
						ProcessType := 0;
            xy := tc.Point;
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
									ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
									if (ts = ts1) or ((tc.GuildID <> 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID <> 0) and (ts1.GID = tc.GuildID)) then Continue;
									if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(ts1.ID),ts1);
								end;
							end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								ts1 := sl.Objects[k1] as TMob;
                i := (100 - tl.Data2[MUseLv]);
                ts1.DEF1 := Round(ts1.DEF1 * (i / 100));
                ts1.DEF2 := Round(ts1.DEF2 * (i / 100));

                if Random(1000) < Skill[32].Data.Data1[MUseLV] * 10 then begin
                  tm := tc.MData;
                  WFIFOW(0, $00c0);
                  WFIFOL(2, ts1.ID);
                  WFIFOW(6, $0004);
                  ts1.DEFPer := word(tl.Data2[MUseLV]);
                  SendBCmd(tm, tc.Point, 7);
							  end;
							end;
						end;
					end;
				33: // Angelus
					begin
						tc1 := tc;
						ProcessType := 5;
					end;
				34: // Blessing
					begin
						ProcessType := 3;
					end;
				35:     {Cure}
					begin
						//tc1.Stat2 := tc1.Stat2 and (not $1C);
            tc1.isPoisoned := False;
            tc1.PoisonTick := Tick;
            tc1.isBlind := false;
            tc1.BlindTick := Tick;
			tc1.FreezeTick := Tick;
            tc1.isFrozen := false;
            tc1.Stat1 := 0;
            tc1.Stat2 := 0;
            UpdateStatus(tm, tc1, Tick);
						//ProcessType := 0;
					end;
        40: // Item Appraisal
          begin
          tc1 := tc;
          //ProcessType := 2;
                  WFIFOW(0, $0177);
									j := 4;
									for i := 1 to 100 do begin
										if (tc.Item[i].ID <> 0) and (tc.Item[i].Amount > 0) and
											 (tc.Item[i].Identify = 0) then begin
											WFIFOW(j, i);
											j := j + 2;
										end;
									end;
									if j <> 4 then begin // Send the list of unidentified items...
										WFIFOW(2, j);
										Socket.SendBuf(buf, j);
										tc.UseItemID := w;
									end;
                  WFIFOW( 0, $00a8);
						      WFIFOW( 2, w);
						      WFIFOW( 4, 0);
						      WFIFOB( 6, 0);
						      Socket.SendBuf(buf, 7);
          end;
				45: // Improve Concentration
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
				51:     {Hiding}
					begin
            if (tc.Option and 4 = 0) then begin
              tc1 := tc;
              ProcessType := 1;
            end else begin
              MMode := 4;
              exit;
            end;

					end;
        53:
          begin
          tc1 := tc;
          ProcessType := 0;
          end;
           234:
          begin
          tc1 := tc;
          ProcessType := 0;
          end;
          235:
          begin
          tc1 := tc;
          ProcessType := 0;
          end;
          236:
          begin
          tc1 := tc;
          ProcessType := 0;
          end;
           237:
          begin
          tc1 := tc;
          ProcessType := 0;
          end;

          54:     {Resurrection}
					begin
            j := SearchCInventory(tc, 717, false);
						if ((((j <> 0) and (tc.Item[j].Amount >= 1)) or (NoJamstone = True)) or (tc.ItemSkill = true)) then begin
              if ((tc1.Sit = 1) and (tc1.HP = 0)) then begin

                if (NoJamstone = False) and (ItemSkill = false) then UseItem(tc, j);

                { Mitch 02-03-2004: Fixed Ygg. Leaf uses SP! }
                //tc.ItemSkill := false;
                dmg[0] := ((tc1.MAXHP * tl.Data1[MUseLV]) div 100) + 1;

  							tc1.Sit := 3;
  							tc1.HP := tc1.HP + dmg[0];
  							SendCStat1(tc1, 0, 5, tc1.HP);
  							WFIFOW( 0, $0148);
  							WFIFOL( 2, tc1.ID);
  							WFIFOW( 6, 100);
  							SendBCmd(tm, tc1.Point, 8);
                ProcessType := 0;
              end else begin
                tc.MMode := 4;
                Exit;
              end;
						end else begin
              SendSkillError(tc, 8); //No Blue Gemstone
              dmg[0] := 0;
              tc.MMode := 4;
							Exit;

							//tc.MPoint.X := 0;
							//tc.MPoint.Y := 0;
							//Exit;
						end;
					end;
				60: // Two-hand Quicken
					begin
            if (tc.Weapon = 3) then begin
						tc1 := tc;
						//ÉpÉPëóêM
						//WFIFOW( 0, $00b0);
						//WFIFOW( 2, $0035);
						//WFIFOL( 4, ASpeed);
						//Socket.SendBuf(buf[0], 8);
						ProcessType := 3;
            end else begin
            MMode := 4;
            Exit;
            end;
					end;
				61: //AC
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
                                        	355: //Aurablade
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
                                             	356: //Parrying
                                        begin
                                                if (tc.Weapon = 3) then begin;
                                                ProcessType := 3;
                                                MTick := Tick + 100;
                                                end else begin
                                                SendSkillError(tc, 6);
                                                MMode := 4;
                                                Exit;
                                                end;
                                        end;


                                         	357: //Concentration
					begin
            if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
  						tc1 := tc;
  						ProcessType := 3;
            end else begin
              SendSkillError(tc, 6);
              MMode := 4;
              Exit;
            end;
					end;
                                         	358: //  Tension Relax
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
                                      	360: // Fury
					begin
            if (tc.Weapon = 3) then begin
  						tc1 := tc;
  						ProcessType := 3;
            end else begin
              SendSkillError(tc, 6);
              MMode := 4;
              Exit;
            end;
          end;

          359: // Berserk
					begin
            if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
  						tc1 := tc;
  						ProcessType := 3;
            end else begin
              SendSkillError(tc, 6);
              MMode := 4;
              Exit;
            end;
          end;
                                        361: //  Assumptio
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
                                        387: // Cart Boost
					begin
                                        if (tc.Option and $0788 <> 0) then begin
						tc1 := tc;
						ProcessType := 3;
                                                end else begin
                                                SendSkillError(tc, 0);
                                                MMode :=4 ;
                                                Exit;
                                                end
				end;
                                       383: //         Windwalk
					begin
						tc1 := tc;
						ProcessType := 5;
					end;
                                          380: // Sight
					begin
						tc1 := tc;
						ProcessType := 3;
					end;

                                         384: //  Meltdown   //no effect yet
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
                                          385: //  Create coin             //no effect yet
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
                                          395: //  Create nugget             //no effect yet
					begin
						tc1 := tc;
						ProcessType := 3;
					end;

				66: // Imposito Manus
					begin
						ProcessType := 3;
						tc.MTick := Tick + 3000;
					end;
				67: // Suffragium
					begin
            // Colus, 20040226: Which is it?
						ProcessType := 3;
						ProcessType := 2;
					end;
				154: // Change Cart
					begin
						tc1 := tc;
					end;
				68: // Aspersio
					begin
          j := SearchCInventory(tc, 523, false);
						if (j <> 0) and (tc.Item[j].Amount >= 1) then begin

							UseItem(tc, j);
            ProcessType := 3;
						end else begin
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
							Exit;
						end;
          end;
				69: // B.S.S.
					begin
						ProcessType := 3;
					end;
        71: // Slow Poison
          begin
            ProcessType := 2;
          end;
				73: // Kyrie Eleison
					begin
						tc1 := tc;
						ProcessType := 5;
					end;
				74: // Magnificat
					begin
						tc1 := tc;
						ProcessType := 5;
					end;
{í«â¡:119}
				75: // Gloria
					begin
						tc1 := tc;
						ProcessType := 5;
						tc.MTick := Tick + 2000;
					end;
                                81: //Sightrasher
                                            if Skill[10].Tick > Tick then begin 
                                                xy := tc.Point;
                  sl.Clear;
                                                j := tl.Range2 + tl.Data2[MUseLV]; 
                  for j1 := (xy.Y - j) div 8 to (xy.Y + j) div 8 do begin 
                     for i1 := (xy.X - j) div 8 to (xy.X + j) div 8 do begin 
                        for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin 
                           if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then continue; ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
                           if (abs(ts1.Point.X - xy.X) <= j) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then 
                              sl.AddObject(IntToStr(ts1.ID),ts1); 
                        end; 
                   end; 
                  end; 
                  if sl.Count <> 0 then begin 
                     for k1 := 0 to sl.Count - 1 do begin 
                        ts1 := sl.Objects[k1] as TMob; 
                        dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100; 
                        dmg[0] := dmg[0] * (100 - ts1.Data.MDEF) div 100; //MDEF% 
                        dmg[0] := dmg[0] - ts1.Data.Param[3]; //MDEF- 
                        if dmg[0] < 1 then dmg[0] := 1; 
                        dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100; 
                        dmg[0] := dmg[0] * tl.Data2[MUseLV]; 
                        if dmg[0] < 0 then dmg[0] := 0;
                        if (ts1.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
                        if ts = ts1 then k := 0 else k := 5;
                        SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], tl.Data2[MUseLV], k);
                        DamageProcess1(tm, tc, ts1, dmg[0], Tick); 
                     end; 
                  end; 
                  tc.MTick := Tick + 1600;
                                      end else begin
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
							Exit;
						end;
        406: // Meteor Assault
					begin
						//tc1 := tc;
						//ProcessType := 1;
                  xy := tc.Point;
                  sl.Clear;
                  j := tl.Range2;
                  for j1 := (xy.Y - j) div 8 to (xy.Y + j) div 8 do begin
                  for i1 := (xy.X - j) div 8 to (xy.X + j) div 8 do begin
                  for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
                  if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then continue; ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
                  if (abs(ts1.Point.X - xy.X) <= j) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
                  sl.AddObject(IntToStr(ts1.ID),ts1);
                  end;
                  end;
                  end;
                  if sl.Count <> 0 then begin
                  for k1 := 0 to sl.Count - 1 do begin
                  ts1 := sl.Objects[k1] as TMob;
                  DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
                  if dmg[0] < 1 then dmg[0] := 1;
                  if dmg[0] < 0 then dmg[0] := 0;
                  k := 1;
                  SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1);
                  DamageProcess1(tm, tc, ts1, dmg[0], Tick);
                  end;
                  end;

          end;
                  214: //Raid
                  begin
                  // Colus, 20040204: Option change, testing option 2 instead of 4+2
                  if (tc.Option and 2 <> 0) then begin
                  tc.Option := tc.Option and $FFFD;
                  tc.Hidden := false;
                  tc.Skill[51].Tick := Tick;
                  tc.SkillTick := Tick;
                  tc.SkillTickID := 51;
                  CalcStat(tc, Tick);
                  UpdateOption(tm, tc);
                  xy := tc.Point;
                  sl.Clear;
                  j := tl.Range2;
                  for j1 := (xy.Y - j) div 8 to (xy.Y + j) div 8 do begin
                  for i1 := (xy.X - j) div 8 to (xy.X + j) div 8 do begin
                  for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
                  if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then continue; ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
                  if (abs(ts1.Point.X - xy.X) <= j) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
                  sl.AddObject(IntToStr(ts1.ID),ts1);
                  end;
                  end;
                  end;
                  if sl.Count <> 0 then begin
                  for k1 := 0 to sl.Count - 1 do begin
                  ts1 := sl.Objects[k1] as TMob;
                  DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
                  if dmg[0] < 1 then dmg[0] := 1;
                  if dmg[0] < 0 then dmg[0] := 0;
                  k := 1;
                  SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1);
                  DamageProcess1(tm, tc, ts1, dmg[0], Tick);
                  end;
                  end;
            end else begin
            SendSkillError(tc, 0);
            tc.MMode := 4;
            tc.MPoint.X := 0;
            tc.MPoint.Y := 0;
            Exit;
            end;
                  end;

				111: // Adrenaline Rush
					begin
						tc1 := tc;
						ProcessType := 5;
					end;
				112: // Weapon Perfection
					begin
						tc1 := tc;
						ProcessType := 4;
					end;
				113: // Power Thrust
					begin
						tc1 := tc;
						ProcessType := 5;
					end;
				114: // Maximize Power
					begin
						tc1 := tc;

            if (tc.Skill[114].EffectLV = 1) then begin
              // Turn it off
              tc1.Skill[114].Tick := Tick;
              tc1.SkillTick := Tick;
              tc1.SkillTickID := 114;
              tc1.Skill[114].EffectLV := 0;
              tc.MMode := 4;
              Exit; // Why?  Because we don't want the effect.
            end else begin
              // Turn it on
              tc1.Skill[114].EffectLV := 1;
              tc1.Skill[114].Tick := Tick + Cardinal(tc1.Skill[114].Data.Data1[tc1.Skill[114].Lv]);
  						ProcessType := 1;
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
								for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue;
                  tc1 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									if (abs(tc1.Point.X - xy.X) <= tl.Range2) and (abs(tc1.Point.Y - xy.Y) <= tl.Range2) then
                    sl.AddObject(IntToStr(tc1.ID),tc1);
								end;
							end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								tc1 := sl.Objects[k1] as TChara;
                if (tc1.Option and 6 <> 0) then begin
  						    tc1.Option := tc1.Option and $FFF9;

                  tc1.SkillTick := tc1.Skill[51].Tick;
                  tc1.SkillTickID := 51;
                  tc1.Hidden := false;
                  CalcStat(tc1, Tick);

                  // Colus, 20031228: Tunnel Drive speed update
                  if (tc1.Skill[213].Lv <> 0) then begin
         				    SendCStat1(tc1, 0, 0, tc1.Speed);
                  end;
                end;
							end;
						end;
          end else begin
          SendSkillError(tc, 0);
          tc.MMode := 4;
          Exit;
          end;
          end;
      135:    {Cloaking}
      begin
        tm := tc.MData;

        xy.X := tc.Point.X;
        xy.Y := tc.Point.Y;

        k := 0;
				if (tc.Option and 4 <> 0) then begin
                          // Cloaked, so uncloak
                          tc.isCloaked := false;
                          tc.Hidden := false;
                          tc.Skill[MSkill].Tick := Tick;
                          tc.SkillTick := Tick;
                          tc.SkillTickID := 135;
                          tc.Option := tc.Option and $FFF9;
                          CalcStat(tc, Tick);

                          UpdateOption(tm, tc);
                          tc.MMode := 4;
                          exit;
                        end else begin
                        for j1 := - 1 to 1 do begin
                          for i1 := -1 to 1 do begin
                            if ((j1 = 0) and (i1 = 0)) then continue;
                            j := tm.gat[xy.X + i1, xy.Y + j1];
                                if (j = 1) or (j = 5) then begin
                                  // Colus, 20040205: Moved this from SkillPassive.
                                  // We don't need to run the cloak every tick, only
                                  // the status change.
                                  tc.isCloaked := true;
                                  tc.Hidden := true;
                                  tc.CloakTick := Tick;
                                  //tc.Optionkeep := tc.Option;
                                  // Colus, 20040204: Trying option 4 instead of 6 for cloak
                                  tc.Option := tc.Option or 4;
                                  k := 1;
                                  CalcStat(tc, Tick);

                                  UpdateOption(tm, tc);
                                  tc1 := tc;
                                  ProcessType := 1;
                                end;
                          end;
                        end;

                                                if k = 0 then begin
                                                  SendSkillError(tc, 0);
                                                  // Colus, 20040225: Failed cloaks burn SP
                                                  DecSP(tc, MSkill, MUseLV);
                                                        //tc.MMode := 4;
                                                        //Exit;
                                                end;
                        end;
                                                {repeat
                                                        xy.X := (tm.Size.X - 2) + 1;
                                                        xy.Y := Random(tm.Size.Y - 2) + 1;
                                                        Inc(j);
                                                until ( ((tm.gat[xy.X, xy.Y] <> 1) and (tm.gat[xy.X, xy.Y] <> 5)) or (j = 100) );}
                                        end;
				138: // Enchant Poison
					begin
						ProcessType := 3;
					end;

{í«â¡:codeÉRÉRÇ‹Ç≈}
{í«â¡:119}
				142: //âûã}éËìñ
					begin
						dmg[0] := 5;
						tc.HP := tc.HP + dmg[0];
						if tc.HP > tc.MAXHP then tc.HP := tc.MAXHP;
						SendCStat1(tc, 0, 5, tc.HP);
						ProcessType := 0;
					end;
				143: //éÄÇÒÇæÉtÉä
					begin
            tc1 := tc;
						ProcessType := 1;
					end;
        147:
          begin
            WFIFOW(0, $01ad);
            j := 4;
            for i := 1 to 100 do begin
            k := MArrowDB.IndexOf(tc.Item[i].ID);
            if (tc.Item[i].ID <> 0) and (tc.Item[i].Amount > 0) and (k <> -1) then begin
            l := tc.Item[i].ID;
            WFIFOW(j, l);
            j := j + 2;
            end;
            end;
            if j <> 4 then begin
            WFIFOW(2, j);
            Socket.SendBuf(buf, j);
            tc.UseItemID := w;
            end;
            WFIFOW( 0, $00a8);
            WFIFOW( 2, w);
            WFIFOW( 4, 0);
            WFIFOB( 6, 0);
            Socket.SendBuf(buf, 7);
          end;
        150:    {Backsliding}
                begin
                        SetLength(bb, 5);
                        {Colus, 20031228: This bb produces behavior equal
                         to the previous settings w/o turning the char around.
                         However, it still isn't updating the position of the
                         character (perhaps because it is not damaging anything?)

                         Darkhelmet, hows that now?}
                        bb[0] := 4;
                        bb[1] := 4;
                        bb[2] := 4;
                        bb[3] := 4;
                        bb[4] := 4;
//                        bb[0] := 1;

                        //bb[1] := 0;
                        xy := tc.Point;

                        DirMove(tm, tc.Point, tc.Dir, bb);
                        //ÉuÉçÉbÉNà⁄ìÆ
                        if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
                                with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
                                        assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
                                        Delete(IndexOf(tc.ID));
                                end;
                                tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
                        end;
                        tc.pcnt := 0;

                        UpdatePlayerLocation(tm, tc);


                end;
        151:
          begin
              td := ItemDB.IndexOfObject(7049) as TItemDB;
							if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) then begin
								k := SearchCInventory(tc, td.ID, td.IEquip);
								if k <> 0 then begin
									if tc.Item[k].Amount < 30000 then begin
									UpdateWeight(tc, k, td);
									{tc.Item[k].ID := td.ID;
                                                                        tc.Item[k].Amount := tc.Item[k].Amount + 1;
                                                                        tc.Item[k].Equip := 0;
                                                                        tc.Item[k].Identify := 1;
                                                                        tc.Item[k].Refine := 0;
                                                                        tc.Item[k].Attr := 0;
                                                                        tc.Item[k].Card[0] := 0;
                                                                        tc.Item[k].Card[1] := 0;
                                                                        tc.Item[k].Card[2] := 0;
                                                                        tc.Item[k].Card[3] := 0;
                                                                        tc.Item[k].Data := td;
									//èdó í«â¡
									tc.Weight := tc.Weight + cardinal(td.Weight);
									WFIFOW( 0, $00b0);
									WFIFOW( 2, $0018);
									WFIFOL( 4, tc.Weight);}
									//Socket.SendBuf(buf, 8);

									//ÉAÉCÉeÉÄÉQÉbÉgí ím
									SendCGetItem(tc, k, 1);
                end;
								end;
							end else begin
								//èdó ÉIÅ[ÉoÅ[
								WFIFOW( 0, $00a0);
								WFIFOB(22, 2);
								Socket.SendBuf(buf, 23);
							end;
          end;
				157: //ÉGÉlÉãÉMÅ[ÉRÅ[Ég
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
				155: //ëÂê∫âÃè•
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
        228:    {Pharmacy}
          begin
            // Every Pharmacy use consumes a Medicine Bowl.
            j := SearchCInventory(tc, 7134, false);
						if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
              UseItem(tc, j);
              j := 4; // Initial length of packet being sent out
							for k := 0 to MaterialDB.Count-1 do begin
                m := 0;  // Do we add this to the list or not?

								tma := MaterialDB.Objects[k] as TMaterialDB;
                // In the material DB, ItemLV is the book we need.
                // Cheesy, I know, but they all have IDs in the 7000s, so
                // this check _should_ always work.
                if (tma.ItemLV > MSkill) then begin
                  i1 := SearchCInventory(tc, tma.ItemLV, false);

                  if (i1 = 0) or (tc.Item[i1].Amount < 1) then begin
                    m := 1;
                    continue;
                  end;

									for l := 0 to 2 do begin
										//if (tma.ItemLV > tc.Skill[tma.RequireSkill].Lv) or (tc.Item[w].ID <> 612) then begin
										//  m := 1;
										//	continue;
										//end;

                    if tma.MaterialID[l] = 0 then continue;

										i1 := SearchCInventory(tc, tma.MaterialID[l], false);

										if (i1 = 0) or (tc.Item[i1].Amount < tma.MaterialAmount[l]) then begin
										  m := 1;
                    end;
									end;

									if (m <> 1) then begin

										WFIFOW(j, tma.ID);
										WFIFOW(j+2, 12);
										WFIFOL(j+4, tc.ID);
										j := j+8;

									end;
								end;
              end;

              // Send the list.
							WFIFOW(0, $018d);
							WFIFOW(2, j);
							Socket.SendBuf(buf, j);
            end else begin
              SendSkillError(tc, 0);
              tc.MMode := 4;
  						Exit;

						end;
					end;

        258:
          begin
            // AlexKreuz: Fixed Spear Quicken - Set type to Spear [4 & 5]
            if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
						tc1 := tc;
						ProcessType := 3;
            end else begin
            tc.MMode := 4;
						Exit;
            end;
          end;
				else
					begin
            if ((tm.CList.IndexOf(tc.MTarget) <> -1) and (mi.PvP = false)) or (tc1 = nil) then begin
								MMode := 4;
								MTarget := 0;
                Exit;
           end;
           if tc = tc1 then exit;
           if tc1.NoTarget = true then exit;
           case tc.MSkill of
                                //Blacksmith
                                110:
                                if (tc.Weapon = 6) or (tc.Weapon = 7) or (tc.Weapon = 8) then begin
                                        if Random(100) < Skill[110].Data.Data1[MUseLV] then begin
                                                                if (tc1.Stat1 <> 3) then begin
									//tc1.Stat1 := 3;
									tc1.BodyTick := Tick + tc.aMotion;
								end else tc1.BodyTick := tc1.BodyTick + 30000;
                                        end else begin
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
                                        end;
                                end;
                                //Skills From MWeiss
                                {50:     //Steal
                                        begin
                                                SendCSkillAtk1(tm, tc, ts, Tick, 0, 1, 6);
                                                j := Random(7);
                                                if (Random(100) < tl.Data1[MUseLV]) then begin
                                                        k := ts.Data.Drop[j].Data.ID;
                                                        if k <> 0 then begin
                                                                td := ItemDB.IndexOfObject(k) as TItemDB;
                                                                if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) then begin
                                                                        i := SearchCInventory(tc, td.ID, td.IEquip);
                                                                        if i <> 0 then begin
                                                                                if tc.Item[i].Amount < 30000 then begin
								                        tc.Item[i].ID := td.ID;
                                                                                        tc.Item[i].Amount := tc.Item[i].Amount + 1;
                                                                                        tc.Item[i].Equip := 0;
                                                                                        tc.Item[i].Identify := 1;
                                                                                        tc.Item[i].Refine := 0;
                                                                                        tc.Item[i].Attr := 0;
                                                                                        tc.Item[i].Card[0] := 0;
                                                                                        tc.Item[i].Card[1] := 0;
                                                                                        tc.Item[i].Card[2] := 0;
                                                                                        tc.Item[i].Card[3] := 0;
                                                                                        tc.Item[i].Data := td;
									                tc.Weight := tc.Weight + cardinal(td.Weight);
									                WFIFOW( 0, $00b0);
									                WFIFOW( 2, $0018);
									                WFIFOL( 4, tc.Weight);
									                Socket.SendBuf(buf, 8);
                                                                                        SendCGetItem(tc, i, 1);
                                                                                end;
                                                                        end else if tc.Item[100].ID <> 0 then begin
                                                                                tc.Item[100].ID := td.ID;
                                                                                tc.Item[100].Amount := 1;
                                                                                tc.Item[100].Equip := 0;
                                                                                tc.Item[100].Identify := 1;
                                                                                tc.Item[100].Refine := 0;
                                                                                tc.Item[100].Attr := 0;
                                                                                tc.Item[100].Card[0] := 0;
                                                                                tc.Item[100].Card[1] := 0;
                                                                                tc.Item[100].Card[2] := 0;
                                                                                tc.Item[100].Card[3] := 0;
                                                                                tc.Item[100].Data := td;
                                                                        end;
						                end;
                                                        end;
                                                end;
					end;}
                                250:    //Shield Charge
                                        begin
                                    if (tc.Shield <> 0) then begin // 20040324,Eliot: It should check if You have a shield.
						xy.X := tc1.Point.X - Point.X;
						xy.Y := tc1.Point.Y - Point.Y;
						{if abs(xy.X) > abs(xy.Y) * 3 then begin
							if xy.X > 0 then b := 6 else b := 2;
						end else if abs(xy.Y) > abs(xy.X) * 3 then begin
							if xy.Y > 0 then b := 0 else b := 4;
						end else begin
							if xy.X > 0 then begin
								if xy.Y > 0 then b := 7 else b := 5;
							end else begin
								if xy.Y > 0 then b := 1 else b := 3;
							end;
						end;}

						DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);

						{if (dmg[0] > 0) then begin
							SetLength(bb, 3);
							bb[0] := 4;
							xy := ts.Point;
							DirMove(tm, ts.Point, b, bb);
							if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
									assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(ts.ID));
								end;
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end;
							ts.pcnt := 0;
							WFIFOW(0, $0088);
							WFIFOL(2, ts.ID);
							WFIFOW(6, ts.Point.X);
							WFIFOW(8, ts.Point.Y);
							SendBCmd(tm, ts.Point, 10);
							xy := ts.Point;
							sl.Clear;
                                                end;}
                                        begin
					     	if Random(100) < Skill[250].Data.Data2[MUseLV] then begin
                                                        //Nothing
						    	tc1.BodyTick := tc1.BodyTick + 30000;
                          end;
                   if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							StatCalc2(tc, tc1, Tick);     // 20040324,Eliot : Wouldn't it be nice if we actually deal any damage ?
                                        end;
                                        end;
                                        end;
                                264:   {Body Relocation}
                                // Colus, 20040225: This isn't called ever?
                                begin
                               if tc.spiritSpheres <> 0 then begin
						//ÉpÉPëóêM
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, ts.ID);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, ts.Point, 15);
                                                // Colus, 20040225: Oatmeal, until you send the packet,
                                                // ANY other packet you send will overwrite what you've
                                                // already done.  You cannot do the UpdateSpiritSpheres
                                                // call (which makes a new packet) until you send the old one.
                                                tc.spiritSpheres := tc.spiritSpheres - 1;
                                                UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);


						if tc.Skill[264].EffectLV > 1 then begin
						    ts.speed := ts.speed - 45;
						end else begin
						    ts.speed := ts.speed - 30;
						end;

						tc.MTick := Tick + 1000;
					end;
          end;
                                 257: //Defender
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
                                {258: //Spear Quicken
                                        begin
                                                if (tc.Weapon <> 5) then begin
						tc1 := tc;
						ProcessType := 3;
                                                end else begin
                                                tc.MMode := 4;
						Exit;
                                                end;
                                                 end else
					                begin
                                                        if ((tm.CList.IndexOf(tc.MTarget) <> -1) and (mi.PvP = false)) or (tc1 = nil) then begin
								MMode := 4;
								MTarget := 0;
                                                        Exit;
                                                        end;
                                                        end;
                                        end;
                                  }
                                  //New skills ---- Alchemist
                                231:  //Potion Pitcher
          begin
            j := SearchCInventory(tc, tc.Skill[231].Data.Data2[MUseLV], false);
            if (j <> 0) and (tc.Item[j].Amount >= 1) then begin

              UseItem(tc, j);

              if (tc1.Sit <> 1) then begin
                k := tc.Skill[231].Data.Data2[MUseLV];
                td := ItemDB.IndexOfObject(k) as TItemDB;


                {Colus, 20040116:
                  Level 5 Potion Pitcher is a blue pot, not a green one.  Don't
                  change this no matter what people claim. :)
                  Also, using target's VIT/INT on this instead of alch's...it's definitely
                  possible to get a 4K heal on a crusader with a white pot.
                  }
                if (td.SP1 <> 0) then begin
									dmg[0] := ((td.SP1 + Random(td.SP2 - td.SP1 + 1)) * (100 + tc1.Param[3]) div 100) * tc.Skill[231].Data.Data1[tc.Skill[231].Lv] div 100;
                  if (tc.ID = tc1.ID) then dmg[0] := dmg[0] * tc.Skill[227].Data.Data1[tc.Skill[227].Lv] div 100;
      						tc1.SP := tc1.SP + dmg[0];
									if tc1.SP > tc1.MAXSP then tc1.SP := tc1.MAXSP;
									SendCStat1(tc1, 0, 7, tc.SP);

                  // Is there no way to show SP heal graphic on the target to others?
                  // I guess there isn't one...oh, well.  SP recovery to self is done
                  // with the SP recovery graphic.


                  WFIFOW( 0, $013d);
                  WFIFOW( 2, $0007);
    						  WFIFOW( 4, dmg[0]);
    						  tc1.Socket.SendBuf(buf, 6);

                end else begin
  						    dmg[0] := ((td.HP1 + Random(td.HP2 - td.HP1 + 1)) * (100 + tc1.Param[2]) div 100) * tc.Skill[231].Data.Data1[tc.Skill[231].Lv] div 100 * (100 + tc1.Skill[4].Lv * 10) div 100;
                  if (tc.ID = tc1.ID) then dmg[0] := dmg[0] * tc.Skill[227].Data.Data1[tc.Skill[227].Lv] div 100;
      						tc1.HP := tc1.HP + dmg[0];
  				        if tc1.HP > tc1.MAXHP then tc1.HP := tc1.MAXHP;
                  SendCStat1(tc1, 0, 5, tc1.HP);

                  // Show heal graphics on target
                  WFIFOW( 0, $011a);
                  WFIFOW( 2, 28);    // We cheat and use the heal skill for the gfx
                  WFIFOW( 4, dmg[0]);
                  WFIFOL( 6, tc1.ID);
                  WFIFOL(10, tc.ID);
                  WFIFOB(14, 1);
                  SendBCmd(tm, tc1.Point, 15);

                end;

						    ProcessType := 0;
						    tc.MTick := Tick + 500; // Delay after is .5s

              end else begin
                MMode := 4;
                Exit;
              end;
            end;
          end;
                                234:  //Chemical Protection --- Weapon
                                        begin
                                                tc1 := tc;
                                                ProcessType := 3;
                                        end;
                                235:  //Chemical Protection --- Shield
                                        begin
                                                tc1 := tc;
                                                ProcessType := 3;
                                        end;
                                236:  //Chemical Protection --- Armor
                                        begin
                                                tc1 := tc;
                                                ProcessType := 3;
                                        end;
                                237:  //Chemical Protection --- Helmet
                                        begin
                                                tc1 := tc;
                                                ProcessType := 3;
                                        end;
                                //New Skills ---- Rouge
                                211: //Steal Coin
                                        begin
                                                SendCSkillAtk2(tm, tc, tc1, Tick, 0, 1, 6);
                                                j := Random(7);
                                                if (Random(100) < tl.Data1[MUseLV]) then begin
                                                        if tc1.Zeny > 0 then begin;
                                                         //DebugOut.Lines.Add('PvP Steal zenny succesful');
                                                                k := (tc.BaseLV * 5) - (tc1.BaseLV * 3);
                                                        if k < 0 then k := 0;
                                                        Dec(tc1.Zeny, k);
                                                     Inc(Zeny, k);
                                                        {if tc1.Zeny < 0 then tc1.Zeny := 0;}
							// Update zeny
              SendCStat1(tc, 1, $0014, Zeny);

                                                        end;
                                                end;
                                        end;
                                212:    {Back Stab PvP}
                                if tc1.Dir = tc.Dir then begin
                                  if (tc.Option and 2 <> 0) then begin
                                    tc.Option := tc.Option and $FFFD;
                                    tc.Hidden := false;
                                    tc.Skill[51].Tick := Tick;
                                    tc.SkillTick := Tick;
                                    tc.SkillTickID := 51;
                                    CalcStat(tc, Tick);
                                    UpdateOption(tm, tc);
                                  // Colus, 20040319: Actually you can Backstab while visible.
                                  {end else begin
                                    SendSkillError(tc, 0);
                                    tc.MMode := 4;
                                    Exit;}
                                  end;
                                  DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
                                  if dmg[0] < 0 then dmg[0] := 0;
                                  SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);
                                  if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then StatCalc2(tc, tc1, Tick);
                                  //SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
                                  //DamageProcess3(tm, tc, tc1, dmg[0], Tick);
                                  tc.MTick := Tick + 500;
                                end else begin
                                  SendSkillError(tc, 0);
                                  MMode := 4;
                                  Exit;
                                end;
                                {214:
                                        if (tc.Option = 6) then begin
                                                DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);
						if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							StatCalc2(tc, tc1, Tick);
						xy := tc1.Point;
						//É_ÉÅÅ[ÉWéZèo2
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue; tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
									if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(tc2.ID),tc2);
								end;
							end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								tc2 := sl.Objects[k1] as TChara;
								DamageCalc3(tm, tc, tc2, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
								if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								//ÉpÉPëóêM
								SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1, 5);
								//É_ÉÅÅ[ÉWèàóù
								if not DamageProcess2(tm, tc, tc2, dmg[0], Tick) then
						StatCalc2(tc, tc2, Tick);
							end;
						end;
                                                end else begin
                                                tc.MMode := 4;
                                                tc.MPoint.X := 0;
                                                tc.MPoint.Y := 0;
                                                Exit;
                                                end;}
                                215:
                                begin
                                if tc1.Skill[234].Tick > Tick then begin
                                end else
                                if (Random(100) < tc.Param[4] - tc1.Param[4] + tl.Data1[MUseLV]) then begin
                                                if (tc1.Weapon <> 0) then begin
                                                        for i := 1 to 100 do begin
                                                                if (tc1.Item[i].Equip = 2) then begin
                                                                        if tc1.Item[i].Equip = 32768 then begin
					                                tc1.Item[i].Equip := 0;
					                                WFIFOW(0, $013c);
					                                WFIFOW(2, 0);
					                                tc1.Socket.SendBuf(buf, 4);
				                                        end else begin
					                                WFIFOW(0, $00ac);
					                                WFIFOW(2, i);
					                                WFIFOW(4, tc1.Item[i].Equip);
					                                tc1.Item[i].Equip := 0;
					                                WFIFOB(6, 1);
					                                tc1.Socket.SendBuf(buf, 7);
				                                        end;

				                                        CalcStat(tc1);
				                                        SendCStat(tc1, true);
                                                                        Break;
                                                                end;
                                                        end;
                                                end;
                                        end;
                                end;
                                216:
                                if tc1.Skill[235].Tick > Tick then begin
                                end else
                                        if (Random(100) < tc.Param[4] - tc1.Param[4] + tl.Data1[MUseLV]) then begin
                                                if (tc1.Shield <> 0) then begin
                                                        for i := 1 to 100 do begin
                                                        if (tc1.Item[i].Equip = 32) then begin
                                                                if tc1.Item[i].Equip = 32768 then begin
					                        tc1.Item[i].Equip := 0;
					                        WFIFOW(0, $013c);
					                        WFIFOW(2, 0);
					                        tc1.Socket.SendBuf(buf, 4);
				                                end else begin
					                        WFIFOW(0, $00ac);
					                        WFIFOW(2, i);
					                        WFIFOW(4, tc1.Item[i].Equip);
					                        tc1.Item[i].Equip := 0;
					                        WFIFOB(6, 1);
					                        tc1.Socket.SendBuf(buf, 7);
				                                end;

				                        CalcStat(tc1);
				                        SendCStat(tc1, true);
                                                        Break;
                                                        end;
                                                end;
                                        end;
                                end;
                                217:
                                if tc1.Skill[236].Tick > Tick then begin
                                end else
                                        if (Random(100) < tc.Param[4] - tc1.Param[4] + tl.Data1[MUseLV]) then begin
                                        for i := 1 to 100 do begin
                                                if (tc1.Item[i].Equip = 16) then begin
                                                        if tc1.Item[i].Equip = 32768 then begin
					                tc1.Item[i].Equip := 0;
					                WFIFOW(0, $013c);
					                WFIFOW(2, 0);
					                tc1.Socket.SendBuf(buf, 4);
				                        end else begin
					                WFIFOW(0, $00ac);
                                                        WFIFOW(2, i);
					                WFIFOW(4, tc1.Item[i].Equip);
					                tc1.Item[i].Equip := 0;
					                WFIFOB(6, 1);
					                tc1.Socket.SendBuf(buf, 7);
				                        end;

				                CalcStat(tc1);
				                SendCStat(tc1, true);
                                                Break;
                                                end;
                                        end;
                                end;
                                218:
                                if tc1.Skill[237].Tick > Tick then begin
                                end else
                                        if (Random(100) < tc.Param[4] - tc1.Param[4] + tl.Data1[MUseLV]) then begin
                                                if (tc1.Head1 <> 0) then begin
                                                for i := 1 to 100 do begin
                                                        if (tc1.Item[i].Equip = 256) then begin
                                                                if tc1.Item[i].Equip = 32768 then begin
					                        tc1.Item[i].Equip := 0;
					                        WFIFOW(0, $013c);
					                        WFIFOW(2, 0);
					                        tc1.Socket.SendBuf(buf, 4);
				                                end else begin
					                        WFIFOW(0, $00ac);
					                        WFIFOW(2, i);
					                        WFIFOW(4, tc1.Item[i].Equip);
					                        tc1.Item[i].Equip := 0;
					                        WFIFOB(6, 1);
					                        tc1.Socket.SendBuf(buf, 7);
				                                end;

				                        CalcStat(tc1);
				                        SendCStat(tc1, true);
                                                        Break;
                                                        end;
                                                end;
                                        end;
                                end;
                                219:
                                begin
                                        DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
                                        j := 1;
						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
						if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							StatCalc2(tc, tc1, Tick);
                                end;
           //New skills ---- Monk
                                {261:  //Call Spirits
                                        begin
                                                tc1 := tc;
                                                ProcessType := 3;
                                                spiritSpheres := Skill[261].Data.Data2[Skill[261].Lv];
                                        end;
                                262:  //Absorb Spirits;
                                        if spiritSpheres <> 0 then begin
                                                spiritSpheres := spiritSpheres - 1;
                                                tc.SP := (tc.SP + Skill[262].Data.Data2[Skill[262].Lv]);
                                                if tc.SP > tc.MAXSP then
                                                        tc.SP := tc.MAXSP;
                                        end;}

                                {268:   //Steel Body
                                                if spiritSpheres = 5 then begin
                                                        tc1 := tc;
                                                        ProcessType := 3;
                                                        spiritSpheres := spiritSpheres - 5;
                                                end;}
                                269:    {Blade Stop}
                                        begin
                                                ProcessType := 3;
                                                tc.MTick := Tick + Cardinal(Skill[269].Data.Data1[MUseLV] * 1000);
                                                tc1.MTick := Tick + Cardinal(Skill[269].Data.Data1[MUseLV] * 1000);
                                        end;
                                270:   //Explosion Spirits
                                       if tc.spiritSpheres = 5 then begin
                                                tc1 := tc;
                                                ProcessType := 3;
                                                tc.spiritSpheres := tc.spiritSpheres - 5;
                                        end;

                                271:    {Extremity Fist}
                                begin
                                  // Colus, 20040406: Right, so here are the options:
                                  //  - If you are in Critical mode, and in a combo, you can do a self-target Ashura with 4 spheres.
                                  //  - If you are not in a combo, you need 5 spheres and must target another person.
                                                if tc.Skill[270].Tick > Tick then begin
                                                  if (tc.Skill[271].Data.SType = 1) then begin
                                                        processtype := 255;
                                                        if tc.spiritSpheres = 5 then begin
                                                        DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
                                                        spbonus := tc.SP;
                                                        dmg[0] := dmg[0] *(8 + tc.SP div 100) + 250 + (tc.Skill[271].Lv * 150);
                                                        dmg[0] := dmg[0] + j;
                                                        if dmg[0] < 0 then begin
                                                                dmg[0] := 0;
                                                                //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                                                        end;
                                                        SetLength(bb, 6);
                                                        //bb[0] := 6;

                                                        xy := tc.Point;
                                                        DirMove(tm, tc.Point, tc.Dir, bb);

                                                        if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
                                                                with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
                                                                        assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
                                                                        Delete(IndexOf(tc.ID));
                                                                end;
                                                                tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
                                                        end;
                                                        tc.pcnt := 0;

                                                        UpdatePlayerLocation(tm, tc);

                                                        SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
                                                        DamageProcess2(tm, tc, tc1, dmg[0], Tick);
                                                        tc.MTick := Tick + Cardinal(3500 + (tl.CastTime2 * MUseLV));
                                                        tc.spiritSpheres := tc.spiritSpheres - 5;
                                                        UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

                                                        {20031223, Colus: Cancel Explosion Spirits after Ashura
                                                         Ashura's tick will control SP lockout time}
                                                        tc.Skill[271].Tick := Tick + 300000;
                                                        tc.Skill[270].Tick := Tick;
                                                        tc.SkillTick := Tick;
                                                        tc.SkillTickID := 270;
                                                        tc.SP := 0;
                                                        SendCStat(tc);
                                                        end;
                                                  // 4-sphere mode
                                                  end else begin
                                                        processtype := 255;
                                                        if tc.spiritSpheres >= 4 then begin

                                                        DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
                                                        spbonus := tc.SP;
                                                        dmg[0] := dmg[0] *(8 + tc.SP div 100) + 250 + (tc.Skill[271].Lv * 150);
                                                        dmg[0] := dmg[0] + j;
                                                        if dmg[0] < 0 then begin
                                                                dmg[0] := 0;
                                                                //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                                                        end;
                                                        SetLength(bb, 6);
                                                        //bb[0] := 6;

                                                        xy := tc.Point;
                                                        DirMove(tm, tc.Point, tc.Dir, bb);

                                                        if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
                                                                with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
                                                                        assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
                                                                        Delete(IndexOf(tc.ID));
                                                                end;
                                                                tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
                                                        end;
                                                        tc.pcnt := 0;

                                                        UpdatePlayerLocation(tm, tc);

                                                        SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
                                                        DamageProcess2(tm, tc, tc1, dmg[0], Tick);
                                                        tc.MTick := Tick + Cardinal(3500 + (tl.CastTime2 * MUseLV));
                                                        tc.spiritSpheres := 0;
                                                        UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

                                                        {20031223, Colus: Cancel Explosion Spirits after Ashura
                                                         Ashura's tick will control SP lockout time}
                                                        tc.Skill[271].Tick := Tick + 300000;
                                                        tc.Skill[270].Tick := Tick;
                                                        tc.SkillTick := Tick;
                                                        tc.SkillTickID := 270;
                                                        tc.SP := 0;
                                                        SendCStat(tc);
                                                        tc.Skill[271].Data.SType := 1;
                                                        tc.Skill[271].Data.CastTime1 := 4500;
                                                        SendCSkillList(tc);

                                                        end;
                                                  end;
                                                end;
                                end;

                                266:  //Investigate
                                                if tc.spiritSpheres <> 0 then begin
                                                        DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
                                                        if dmg[0] < 1 then begin
                                                        dmg[0] := 1;
                                                        end;
                                                                if dmg[0] < 0 then begin
                                                                dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
					        	        //ÉpÉPëóêM
                                                                end;
						                SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], tl.Data2[MUseLV]);
						                DamageProcess2(tm, tc, tc1, dmg[0], Tick);
                                                                        if MSkill = 266 then begin
                                                                        tc.MTick := Tick + 1000;
                                                                        end;
                                                tc.spiritSpheres := tc.spiritSpheres - 1;
                                                UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
                                                end;
                                267:  //Finger Offensive
                                                if tc.spiritSpheres >= tc.MUseLV then begin
						        //É_ÉÅÅ[ÉWéZè
						        DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						        if dmg[0] < 1 then begin
                                                        dmg[0] := 1;
                                                        end;
						        dmg[0] := dmg[0] * tl.Data2[MUseLV];
						                if dmg[0] < 0 then begin
                                                                dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
					        	        //ÉpÉPëóêM
                                                                end;
						                SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], tl.Data2[MUseLV]);
						                DamageProcess2(tm, tc, tc1, dmg[0], Tick);
                                                                tc.MTick := Tick + 1000;
                                                tc.spiritSpheres := tc.spiritSpheres - tc.MUseLV;
                                                UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
                                                end;
                                273:  //Combo Finish
                                        if Skill[272].Tick > Tick then begin
                                        if (tc.Weapon = 12) then begin
						xy.X := ts.Point.X - Point.X;
						xy.Y := ts.Point.Y - Point.Y;
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
						//íeÇ´îÚÇŒÇ∑ëŒè€Ç…ëŒÇ∑ÇÈÉ_ÉÅÅ[ÉWÇÃåvéZ
						DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);

						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, 6);
							bb[0] := 6;
							xy := ts.Point;
							DirMove(tm, ts.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
									assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(ts.ID));
								end;
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end;
							ts.pcnt := 0;
							//Update Monster Location
                                                        UpdateMonsterLocation(tm, ts);
							
						end;
						if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							StatCalc1(tc, ts, Tick);

                                                end else begin
                                                        MMode := 4;
                                                        Exit;
                                                end;
                                                end;
                                 272:  //Chain Combo
                                                if Skill[263].Tick > Tick then begin
                                                DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
                                                if dmg[0] < 0 then begin
                                                                dmg[0] := 0; //Negative Damage
                                                end;
                                                SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 4);
                                                DamageProcess2(tm, tc, tc1, dmg[0], Tick);
                                                tc.MTick := Tick + 1000;
                                                tc.Skill[MSkill].Tick := Tick + cardinal(2) * 1000;
					end;
        5,42,46,253,316,324: //ÉoÉbÉVÉÖÅAÉÅÉ}Å[ÅADSÅAÉsÉAÅ[ÉXÅASB
					begin

            j := 1;

						//É_ÉÅÅ[ÉWéZèo
						if (MSkill = 5) or (MSkill = 253) then begin
							DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
						end else begin
							DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						end;

            if (MSkill = 316) or (MSkill = 324) then begin
              if (Weapon = 13) or (Weapon = 14) then begin
                // Is 2 or 3 correct?
    						DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
    					end else begin
  	  					//DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
                SendSkillError(tc, 6);
    						tc.MMode := 4;
    						Exit;
    					end;
            end;

						if (MSkill = 46) then begin //DSÇÕ2òAåÇ
              if (Weapon = 11) then begin
  							dmg[0] := dmg[0] * 2;
  							j := 2;
              end else begin
                SendSkillError(tc, 6);
                MMode := 4;
                exit;
              end;
						end else if MSkill = 56 then begin //ÉsÉAÅ[ÉXÇÕts.Data.Scale + 1âÒhit
							j := 1;
							dmg[0] := dmg[0] * j;
            end else if MSkill = 253 then begin
							j := 2;
						end else begin
							j := 1;
						end;

						//ÉÅÉ}Å[ÇÃZenyè¡îÔ
						if MSkill = 42 then begin
              // Should check to see if we have the money!
              if (Zeny >= Cardinal(tl.Data2[MUseLV])) then begin
    						Dec(Zeny, tl.Data2[MUseLV]);
    						// Update Zeny
                SendCStat1(tc, 1, $0014, Zeny);

              end else begin
                SendSkillError(tc, 5);
    						tc.MMode := 4;
    						Exit;
              end;
						end;
            
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
						if (Skill[145].Lv <> 0) and (MSkill = 5) and (MUseLV > 5) then begin //ã}èäìÀÇ´
							if Random(1000) < Skill[145].Data.Data1[MUseLV] * 10 then begin
								if (tc1.Stat1 <> 3) then begin
									//tc1.Stat1 := 3;
									tc1.BodyTick := Tick + tc.aMotion;
								end else tc1.BodyTick := tc1.BodyTick + 30000;
							end;
						end;
						if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							StatCalc2(tc, tc1, Tick);
					end;
      6: //ÉvÉçÉ{ÉbÉN
					begin
						tc1.ATarget := tc.ID;
						tc1.AData := tc;
						//ÉpÉPëóêM
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
            WFIFOB(14, 0);

						SendBCmd(tm, tc1.Point, 15);
					end;
				7: //MBÅAÉAÉçÅ[ÉVÉÉÉèÅ[ÅAÉOÉäÉÄ
					begin
						//É_ÉÅÅ[ÉWéZèo1
						DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);
						if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							StatCalc2(tc, tc1, Tick);
						xy := tc1.Point;
						//É_ÉÅÅ[ÉWéZèo2
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue; tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
									if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(tc2.ID),tc2);
								end;
							end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								tc2 := sl.Objects[k1] as TChara;
								DamageCalc3(tm, tc, tc2, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
								if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								//ÉpÉPëóêM
								SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1, 5);
								//É_ÉÅÅ[ÉWèàóù
								if not DamageProcess2(tm, tc, tc2, dmg[0], Tick) then
{í«â¡}						StatCalc2(tc, tc2, Tick);
							end;
						end;
					end;
				11,13,14,19,20,90,156: //BOLT,NB,SS,ES,HL
					begin
						//É_ÉÅÅ[ÉWéZèo
						dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
						dmg[0] := dmg[0] * (100 - tc1.MDEF1) div 100; //MDEF%
						dmg[0] := dmg[0] - tc1.Param[3]; //MDEF-
						if dmg[0] < 1 then dmg[0] := 1;
						dmg[0] := dmg[0] * ElementTable[tl.Element][tc1.ArmorElement] div 100;
            // Colus, 20040130: Add effect of garment cards
            dmg[0] := dmg[0] * (100 - tc1.DamageFixE[1][tl.Element]) div 100;
						dmg[0] := dmg[0] * tl.Data2[MUseLV];
						if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï

            if (tc1.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], tl.Data2[MUseLV]);
						DamageProcess2(tm, tc, tc1, dmg[0], Tick);
						case MSkill of
							11,90:     tc.MTick := Tick + 1000;
							13:        tc.MTick := Tick +  800 + 400 * ((MUseLV + 1) div 2) - 300 * (MUseLV div 10);
							14,19,20 : tc.MTick := Tick +  800 + 200 * MUseLV;
							else       tc.MTick := Tick + 1000;
						end;
					end;
{í«â¡}
				15: {Frost Driver PvP}
					begin
						//Damage Calc
						dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * ( MUseLV + 100 ) div 100;
						dmg[0] := dmg[0] * (100 - tc1.MDEF1) div 100; //MDEF%
						dmg[0] := dmg[0] - tc1.Param[3]; //MDEF-
						if dmg[0] < 1 then dmg[0] := 1;
						dmg[0] := dmg[0] * ElementTable[tl.Element][tc1.ArmorElement] div 100;
            // Colus, 20040130: Add effect of garment cards
            dmg[0] := dmg[0] * (100 - tc1.DamageFixE[1][tl.Element]) div 100;
						if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
            if (tc1.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;            
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
            if (dmg[0] > 0)then begin
              if Random(1000) < tl.Data1[MUseLV] * 10 then begin
                tc1.Stat1 := 2;
                tc1.FreezeTick := Tick + 15000;
                tc1.isFrozen := true;
                UpdateStatus(tm, tc1, Tick);
              end;
            end;
						DamageProcess2(tm, tc, tc1, dmg[0], Tick, False);
						tc.MTick := Tick + 1500;
					end;

{í«â¡ÉRÉRÇ‹Ç≈}
{:119}
				16: {Stone Curse PvP}
					begin
          j := SearchCInventory(tc, 716, false);
						if ((j <> 0) and (tc.Item[j].Amount >= 1)) or (NoJamstone = True) then begin
							//ÉAÉCÉeÉÄêîå∏è
                                                        if NoJamstone = False then UseItem(tc, j);

                                        
							//É_ÉÅÅ[ÉWéZèo
						//ÉpÉPëóêM
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, dmg[0]);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, tc1.Point, 15);
						if Random(1000) < tl.Data1[MUseLV] * 10 then begin
							//if (tc1.Stat1 <> 1) then begin
								tc1.Stat1 := 1;
								tc1.isStoned := true;
								tc1.StoneTick := Tick + 15000;
                UpdateStatus(tm, tc1, Tick);
							//end;
						end;
						end else begin
              SendSkillError(tc, 7); //No Red Gemstone
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
							Exit;
						end;
					end;
{:119}
				17: //FB (HDÇ∆ÇŸÇ⁄ìØÇ∂)
					begin
						xy := tc1.Point;
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue; tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(tc2.ID),tc2);
								end;
						 end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								tc2 := sl.Objects[k1] as TChara;
								dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
								dmg[0] := dmg[0] * (100 - tc2.MDEF1) div 100; //MDEF%
								dmg[0] := dmg[0] - tc2.Param[3]; //MDEF-
								if dmg[0] < 1 then dmg[0] := 1;
								dmg[0] := dmg[0] * ElementTable[tl.Element][tc2.ArmorElement] div 100;
                // Colus, 20040130: Add effect of garment cards
                dmg[0] := dmg[0] * (100 - tc2.DamageFixE[1][tl.Element]) div 100;
								dmg[0] := dmg[0] * tl.Data2[MUseLV];
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                if (tc2.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
								if (tc1 = tc2) or (tc = tc2)  then k := 0 else k := 5;
								SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], tl.Data2[MUseLV], k);
								//É_ÉÅÅ[ÉWèàóù
								DamageProcess2(tm, tc, tc2, dmg[0], Tick);
							end;
						end;
						tc.MTick := Tick + 1600;
					end;
				
				30: //ë¨ìxå∏è≠
					begin
						ProcessType := 3;
						tc.MTick := Tick + 1000;
					end;


        365:   //Magic Crusher PVP by Eliot
          begin
					 dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100; // Calculate Attack Power - Eliot
					 dmg[0] := dmg[0] * (100 - tc1.MDEF1) div 100; // Calculate Magic Defense - Eliot
					 dmg[0] := dmg[0] - tc1.Param[3];
					if dmg[0] < 1 then          // Check for negative damage
           dmg[0] := 1;
					 dmg[0] := dmg[0] * 1;
           dmg[0] := dmg[0] * tl.Data2[MUseLV];
          if dmg[0] < 0 then
           dmg[0] := 0;
               SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], tl.Data2[MUseLV]);
               DamageProcess2(tm, tc, tc1, dmg[0], Tick);
                  tc.MTick := Tick + 1000;
          end;
        47:
          begin
          if (Arrow = 0) or (Item[Arrow].Amount < 9) then begin
					WFIFOW(0, $013b);
					WFIFOW(2, 0);
					Socket.SendBuf(buf, 4);
					ATick := ATick + ADelay;
					Exit;
				  end;
				  Dec(Item[Arrow].Amount,9);

				  WFIFOW( 0, $00af);
				  WFIFOW( 2, Arrow);
				  WFIFOW( 4, 9);
				  Socket.SendBuf(buf, 6);
				  if Item[Arrow].Amount = 0 then begin
					Item[Arrow].ID := 0;
					Arrow := 0;
				  end;

            DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);
						if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							StatCalc2(tc, tc1, Tick);
						xy := tc1.Point;
						//É_ÉÅÅ[ÉWéZèo2
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue; tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
									if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(tc2.ID),tc2);
								end;
							end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								tc2 := sl.Objects[k1] as TChara;

                j := 0;
                case tc.Dir of
						    0:
                  begin
                    if tc2.Point.Y < tc.Point.Y then j := 1;
                  end;
                1:
                  begin
                    if (tc2.Point.X < tc.Point.X) and (tc2.Point.Y > tc.Point.Y) then j := 1;
                  end;
                2:
                  begin
                    if tc2.Point.X > tc.Point.X then j := 1;
                  end;
                3:
                  begin
                    if (tc2.Point.X < tc.Point.X) and (tc2.Point.Y < tc.Point.Y) then j := 1;
                  end;
                4:
                  begin
                    if tc2.Point.Y > tc.Point.Y then j := 1;
                  end;
                5:
                  begin
                    if (tc2.Point.X > tc.Point.X) and (tc2.Point.Y > tc.Point.Y) then j := 1;
                  end;
                6:
                  begin
                    if tc2.Point.X < tc.Point.X then j := 1;
                  end;
                7:
                  begin
                    if (tc2.Point.X > tc.Point.X) and (tc2.Point.Y > tc.Point.Y) then j := 1;
                  end;
					      end;

                if j <> 1 then begin
								DamageCalc3(tm, tc, tc2, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
								if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								//ÉpÉPëóêM
								SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1, 5);
								//É_ÉÅÅ[ÉWèàóù
								if not DamageProcess2(tm, tc, tc2, dmg[0], Tick) then
{í«â¡}						StatCalc2(tc, tc2, Tick);
                end;

							end;
						end;
          end;
				52:     {Envenom PvP}
					begin
						DamageCalc3(tm, tc, tc1, Tick, 0, 100, tl.Element);
						dmg[0] := dmg[0] + 15 * MUseLV;
						dmg[0] := dmg[0] * ElementTable[tl.Element][tc1.ArmorElement] div 100;
                                                // Colus, 20040130: Add effect of garment cards
                                                dmg[0] := dmg[0] * (100 - tc1.DamageFixE[1][tl.Element]) div 100;
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
						k1 := (BaseLV * 2 + MUseLV * 3 + 10) - (tc1.BaseLV * 2 + tc1.Param[2]);
						k1 := k1 * 10;
						if Random(1000) < k1 then begin
                                                        tc1.isPoisoned := true;
                                                        tc1.PoisonTick := Tick + 20000;
							tc1.Stat2 := 1;
             				UpdateStatus(tm, tc1, Tick);
							//if not Boolean(tc1.Stat2 and 1) then
								//tc1.HealthTick[0] := Tick + tc.aMotion
							//else tc1.HealthTick[0] := tc1.HealthTick[0] + 30000;
						end;
						DamageProcess2(tm, tc, tc1, dmg[0], Tick);
					end;
{í«â¡:119ÉRÉRÇ‹Ç≈}
        56:
          begin
            if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
            DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
            j := 1;
            dmg[0] := dmg[0] * j;
						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
						if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
            StatCalc2(tc, tc1, Tick);
            end else begin
            MMode := 4;
            Exit;
            end;
          end;
        57:     {Brandish Spear}
        begin
                if (tc.Option and 32 <> 0) and ((tc.Weapon = 4) or (tc.Weapon = 5)) then begin
                        DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
                        dmg[0] := dmg[0] * 2;
                        j := 1;

                        if dmg[0] < 0 then dmg[0] := 0;
                        SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
                        if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
                        StatCalc2(tc, tc1, Tick);
                end else begin
                        tc.MMode := 4;
                        tc.MPoint.X := 0;
                        tc.MPoint.Y := 0;
                        Exit;
                        end;
        end;
        58:
          begin
          if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
						xy.X := tc1.Point.X - Point.X;
						xy.Y := tc1.Point.Y - Point.Y;
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
						//íeÇ´îÚÇŒÇ∑ëŒè€Ç…ëŒÇ∑ÇÈÉ_ÉÅÅ[ÉWÇÃåvéZ
						DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);

						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, 6);
							bb[0] := 6;
							xy := tc1.Point;
							DirMove(tm, tc1.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> tc1.Point.X div 8) or (xy.Y div 8 <> tc1.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].CList do begin
									assert(IndexOf(tc1.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(tc1.ID));
								end;
								tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].CList.AddObject(tc1.ID, tc1);
							end;
							tc1.pcnt := 0;
							//Update Player's Location
							UpdatePlayerLocation(tm, tc1);
						end;
						if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							StatCalc2(tc, tc1, Tick);
            
          end else begin
            MMode := 4;
            Exit;
          end;
          end;

        59:
            begin
                if (tc.Weapon = 4) or (tc.Weapon = 5) then begin

                    i1 := 0;
                    k  := 1;
                    while (i1 >= 0) and (i1 < tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].NPC.Count) do begin
                        tn := tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].NPC.Objects[i1] as TNPC;
                        if tn = nil then begin
                            Inc(i1);
                            continue;
                        end;
                        if (tc1.Point.X = tn.Point.X) and (tc1.Point.Y = tn.Point.Y) then begin
                            case tn.JID of
                                $85: {Pneuma}
                                begin
                                    dmg[0] := 0;
                                    //DebugOut.Lines.Add('Pneuma OK');
                                    dmg[6] := 0;
                                    k := 0;
                                end;
                            end;
                        end;
                        Inc(i1);
                    end;

                    if (k = 1) then begin
                        DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
                    end;

                    if dmg[0] < 0 then dmg[0] := 0;
                    SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);
                    if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then StatCalc2(tc, tc1, Tick);
                     tc.MTick := Tick + 1000;
                end else begin
                    MMode := 4;
                    Exit;
                end;
            end;

				62: //BB
					begin
						//Ç∆ÇŒÇ∑ï˚å¸åàíËèàóù
						//FWÇ©ÇÁÇÃÉpÉNÉä
						xy.X := tc1.Point.X - Point.X;
						xy.Y := tc1.Point.Y - Point.Y;
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

						//íeÇ´îÚÇŒÇ∑ëŒè€Ç…ëŒÇ∑ÇÈÉ_ÉÅÅ[ÉWÇÃåvéZ
						DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);

						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, 3);
							bb[0] := 4;
							xy := tc1.Point;
							DirMove(tm, tc1.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> tc1.Point.X div 8) or (xy.Y div 8 <> tc1.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].CList do begin
									assert(IndexOf(tc1.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(tc1.ID));
								end;
								tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].CList.AddObject(tc1.ID, tc1);
							end;
							tc1.pcnt := 0;
							//Update Players Location
							UpdatePlayerLocation(tm, tc1);
							xy := tc1.Point;
							//ä™Ç´Ç±Ç›îÕàÕçUåÇ
							sl.Clear;
							for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
								for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
									for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
										if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue; tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
										if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
										if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
											sl.AddObject(IntToStr(tc2.ID),tc2);
									end;
								end;
							end;
							if sl.Count <> 0 then begin
								for k1 := 0 to sl.Count - 1 do begin
									tc2 := sl.Objects[k1] as TChara;
									DamageCalc3(tm, tc, tc2, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
									if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
									//ÉpÉPëóêM
									SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1, 5);
									//É_ÉÅÅ[ÉWèàóù
									if not DamageProcess2(tm, tc, tc2, dmg[0], Tick) then
{í«â¡}							StatCalc2(tc, tc2, Tick);
								end;
							end;
						end;
						if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
{í«â¡}				StatCalc2(tc, tc1, Tick);
					end;
{:119}
				76: // Lex Divina vs. Player
					begin
						//ÉpÉPëóêM
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, tc1.Point, 15);
						// Set Silence effect
						if Boolean((1 shl 2) and tc1.Stat2) then begin
							tc1.HealthTick[2] := tc1.HealthTick[2] + 30000; //âÑí∑
						end else begin
							tc1.HealthTick[2] := Tick + tc.aMotion;
						end;
					end;
{:119}
				77: // Turn Undead vs. Player
					begin
            // Colus, 20040127: Fixed check to be for players
						if (tc1.ArmorElement mod 20 = 9) then begin
							m := MUseLV * 20 + Param[3] + Param[5] + BaseLV + (200 - 200 * Cardinal(tc1.HP) div tc1.HP) div 200;
							if (Random(1000) < m) then begin
								dmg[0] := tc1.HP;
							end else begin
{ïœçX}					dmg[0] := (BaseLV + Param[3] + (MUseLV * 10)) * ElementTable[6][0] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
							end;
							// Damage cap (removed)
							//if (dmg[0] div $010000) <> 0 then dmg[0] := $07FFF; //ï€åØ
              // Lex Aeterna effect
              if (tc1.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
							SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
							DamageProcess2(tm, tc, tc1, dmg[0], Tick);
							tc.MTick := Tick + 3000;
						end else begin
							tc.MMode := 4;
							Exit;
						end;
					end;
				78: // Lex Aeterna
					begin
						//ÉpÉPëóêM
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, tc1.Point, 15);

            // Colus, 20040126: Can't use Lex Aeterna on Stat1.
            // Set the tick on the skill instead.

            if ((tc1.Stat1 < 1) or (tc1.Stat1 > 2)) then
              tc1.Skill[78].Tick := $FFFFFFFF;
              
            tc.MTick := Tick + 3000;
						{if (tc1.Stat1 = 0) or (tc1.Stat1 = 3) or (tc1.Stat1 = 4) then begin
							//tc1.Stat1 := 5;
							tc1.BodyTick := Tick + tc.aMotion;
						end else if (tc1.Stat1 = 5) then tc1.BodyTick := tc1.BodyTick + 30000;}
					end;
				84: //JT
					begin

						xy.X := tc1.Point.X - Point.X;
						xy.Y := tc1.Point.Y - Point.Y;
						if abs(xy.X) > abs(xy.Y) * 3 then begin
							//â°å¸Ç´
							if xy.X > 0 then   b := 6 else b := 2;
						end else if abs(xy.Y) > abs(xy.X) * 3 then begin
							//ècå¸Ç´
							if xy.Y > 0 then   b := 0 else b := 4;
						end else begin
							if xy.X > 0 then begin
								if xy.Y > 0 then b := 7 else b := 5;
							end else begin
								if xy.Y > 0 then b := 1 else b := 3;
							end;
						end;

						//É_ÉÅÅ[ÉWéZèo
						dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
						dmg[0] := dmg[0] * (100 - tc1.MDEF1) div 100; //MDEF%
						dmg[0] := dmg[0] - tc1.Param[3]; //MDEF-
						if dmg[0] < 1 then dmg[0] := 1;
						dmg[0] := dmg[0] * ElementTable[tl.Element][tc1.ArmorElement] div 100;
            // Colus, 20040130: Add effect of garment cards
            dmg[0] := dmg[0] * (100 - tc1.DamageFixE[1][tl.Element]) div 100;
						dmg[0] := dmg[0] * tl.Data2[MUseLV];
						if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
            if (tc1.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
						//ÉpÉPëóêM
                                                // AlexKreuz: Monk Heal
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], tl.Data2[MUseLV]);
						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, tl.Data2[MUseLV] div 2);
							bb[0] := 4;
							xy.X := tc1.Point.X;
							xy.Y := tc1.Point.Y;
							DirMove(tm, tc1.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> tc1.Point.X div 8) or (xy.Y div 8 <> tc1.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].CList do begin
									assert(IndexOf(tc1.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(tc1.ID));
								end;
								tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].CList.AddObject(tc1.ID, tc1);
							end;
							tc1.pcnt := 0;
						//Update Players Location
						UpdatePlayerLocation(tm, tc1);
						end;
						DamageProcess2(tm, tc, tc1, dmg[0], Tick);
					end;
				88: //ÉtÉçÉXÉgÉmÉîÉ@
					begin
          //Colus: A stray 35,000 damage thing for Frost Nova.
          //SendCSkillAtk2(tm, tc, tc1, 15, 35000, 1, 6);
						xy := tc1.Point;
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue; tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
									if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(tc2.ID),tc2);
                                                                end;
                                                        end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								tc2 := sl.Objects[k1] as TChara;
								dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100;
								dmg[0] := dmg[0] * (100 - tc2.MDEF1) div 100; //MDEF%
								dmg[0] := dmg[0] - tc2.Param[3]; //MDEF-
								if dmg[0] < 1 then dmg[0] := 1;
								dmg[0] := dmg[0] * ElementTable[tl.Element][tc2.ArmorElement] div 100;
                // Colus, 20040130: Add effect of garment cards
                dmg[0] := dmg[0] * (100 - tc2.DamageFixE[1][tl.Element]) div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                if (tc2.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
								SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1 , 5);
                // Colus: What the hell is this?  1 <> 1?
                if (1 <> 1) and (dmg[0] <> 0)then begin
                  if Random(1000) < tl.Data1[MUseLV] * 10 then begin
								    //tc2.Stat1 := 2;
								    tc2.BodyTick := Tick + tc.aMotion;
                  end;
						    end;
								//É_ÉÅÅ[ÉWèàóù
								DamageProcess2(tm, tc, tc2, dmg[0], Tick);
							end;
						end;
                                                tc.MTick := Tick + 1000;
					end;
				86: {Water Ball PvP}
					begin
                                                k := tl.Data1[MUseLV];
                                                for m := 0 to k - 1 do begin
                                                if dmg[1] <> 0 then begin
                                                        dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100;
                                                        dmg[0] := dmg[0] * (100 - tc1.MDEF1) div 100; //MDEF%
                                                        dmg[0] := dmg[0] - tc1.Param[3]; //MDEF-
                                                        if dmg[0] < 1 then dmg[0] := 1;
                                                        dmg[0] := dmg[0] * ElementTable[tl.Element][tc1.ArmorElement] div 100;
                                                        if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                                                        if (tc1.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
                                                        SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
                                                        //É_ÉÅÅ[ÉWèàóù
                                                        DamageProcess2(tm, tc, tc1, dmg[0], Tick);
                				        xy := tc1.Point;
						        sl.Clear;
						        for j1 := (xy.Y - tl.Data2[MUseLV]) div 8 to (xy.Y + tl.Data2[MUseLV]) div 8 do begin
							        for i1 := (xy.X - tl.Data2[MUseLV]) div 8 to (xy.X + tl.Data2[MUseLV]) div 8 do begin
								        for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									        if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue; tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									        if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
									        if (abs(tc2.Point.X - xy.X) <= tl.Data2[MUseLV]) and (abs(tc2.Point.Y - xy.Y) <= tl.Data2[MUseLV]) then
										        sl.AddObject(IntToStr(tc2.ID),tc2);
								        end;
                                                                end;
						        end;
						        if sl.Count <> 0 then begin
							        for k1 := 0 to sl.Count - 1 do begin
                                                                        tc2 := sl.Objects[k1] as TChara;
                                                                        dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100;
                                                                        dmg[0] := dmg[0] * (100 - tc2.MDEF1) div 100; //MDEF%
                                                                        dmg[0] := dmg[0] - tc2.Param[3]; //MDEF-
                                                                        if dmg[0] < 1 then dmg[0] := 1;
                                                                        dmg[0] := dmg[0] * ElementTable[tl.Element][tc2.ArmorElement] div 100;
                                                                        if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                                                                        if (tc2.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
                                                                        SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1);
                                                                        //É_ÉÅÅ[ÉWèàóù
                                                                        DamageProcess2(tm, tc, tc2, dmg[0], Tick)
                                                                end;
                                                        end;
                                                        end;
                                                        end;
					end;

				129://Blitz beat
					begin
						xy := tc1.Point;
						//É_ÉÅÅ[ÉWéZè
                                                if tc.Option and 16 <> 0 then begin
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
                for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue; tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
									if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(tc2.ID),tc2);
							 	end;
							end;
						end;
						if sl.Count <> 0 then begin
							if Skill[128].Lv <> 0 then begin
								dmg[1] := Skill[128].Data.Data1[Skill[128].Lv] * 2;
							end else begin
								dmg[1] := 0
							end;
							dmg[1] := dmg[1] + (Param[4] div 10 + Param[3] div 2) * 2 + 80;
							dmg[1] := dmg[1] * MUseLV;
							for k1 := 0 to sl.Count - 1 do begin
								tc2 := sl.Objects[k1] as TChara;
								dmg[0] := dmg[1] * ElementTable[tl.Element][tc2.ArmorElement] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
                if (tc2.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
								SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], MUseLV);
								//É_ÉÅÅ[ÉWèàóù
								DamageProcess2(tm, tc, tc2, dmg[0], Tick);
							end;
						end;
                                                end else begin
                                                MMode := 4;
                                                Exit;
                                                end;
					end;
{}      136:
          begin
            if (tc.Weapon = 16) then begin
            DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
            j := 8;
						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
						if (Skill[145].Lv <> 0) and (MSkill = 5) and (MUseLV > 5) then begin //ã}èäìÀÇ´
							if Random(1000) < Skill[145].Data.Data1[MUseLV] * 10 then begin
								if (tc1.Stat1 <> 3) then begin
									//tc1.Stat1 := 3;
									tc1.BodyTick := Tick + tc.aMotion;
								end else tc1.BodyTick := tc1.BodyTick + 30000;
							end;
						end;
						if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							StatCalc2(tc, tc1, Tick);
              tc.MTick := Tick + 1000;
            end else begin
            MMode := 4;
            Exit;
            end;
          end;
        137:    {Grimtooth}
          begin
            if (tc.Option and 2 <> 0) and (Weapon = 16) then begin
          	DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);
						if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							StatCalc2(tc, tc1, Tick);
						xy := tc1.Point;
						//É_ÉÅÅ[ÉWéZèo2
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue; tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
									if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(tc2.ID),tc2);
                end;
							end;
            end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								tc2 := sl.Objects[k1] as TChara;
								DamageCalc3(tm, tc, tc2, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
								if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								//ÉpÉPëóêM
								SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1, 5);
								//É_ÉÅÅ[ÉWèàóù
								if not DamageProcess2(tm, tc, tc2, dmg[0], Tick) then
{í«â¡}						StatCalc2(tc, tc2, Tick);
							end;
						end;
            end else begin
            MMode := 4;
            Exit;
            end;
          end;
				148: //É`ÉÉÅ[ÉW_ÉAÉçÅ[
					begin
						//Ç∆ÇŒÇ∑ï˚å¸åàíËèàóù
						//FWÇ©ÇÁÇÃÉpÉNÉä
						xy.X := tc1.Point.X - Point.X;
						xy.Y := tc1.Point.Y - Point.Y;
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

						//íeÇ´îÚÇŒÇ∑ëŒè€Ç…ëŒÇ∑ÇÈÉ_ÉÅÅ[ÉWÇÃåvéZ
						DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);

						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, 6);
							bb[0] := 6;
							xy := tc1.Point;
							DirMove(tm, tc1.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> tc1.Point.X div 8) or (xy.Y div 8 <> tc1.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].CList do begin
									assert(IndexOf(tc1.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(tc1.ID));
								end;
								tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].CList.AddObject(tc1.ID, tc1);
							end;
							tc1.pcnt := 0;
							//Update Players Location
							UpdatePlayerLocation(tm, tc1);
						end;
						if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							StatCalc2(tc, tc1, Tick);
					end;
        149:
          begin

              DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
              dmg[0] := Round(dmg[0] * 1.25);
              j := 1;
						  if dmg[0] < 0 then dmg[0] := 0;
						  SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
						  if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							StatCalc2(tc, tc1, Tick);

          end;
				152: //êŒìäÇ∞
					begin
                                                j := SearchCInventory(tc, 7049, false);
						if (j <> 0) and (tc.Item[j].Amount >= 1) then begin

							UseItem(tc, j);
                                                        dmg[0] := 30;
						        dmg[0] := dmg[0] * ElementTable[tl.Element][0] div 100;
						        SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
                                                        if Random(1000) < Skill[152].Data.Data1[MUseLV] * 10 then begin
								if (tc1.Stat1 <> 3) then begin
									//tc1.Stat1 := 3;
									tc1.BodyTick := Tick + tc.aMotion;
								end else tc1.BodyTick := tc1.BodyTick + 30000;
                                                        end;
						DamageProcess2(tm, tc, tc1, dmg[0], Tick, False);
						end else begin
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
						end;
					end;
                                153:
                                        begin
                                                xy.X := tc1.Point.X - Point.X;
						xy.Y := tc1.Point.Y - Point.Y;
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

            //DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
            DamageCalc3(tm, tc, tc1, Tick, 0, 150 + (tc.Cart.Weight div 800), tl.Element, 0);
						//dmg[0] := dmg[0] + (tc.Cart.Weight div 800);
            if dmg[0] < 0 then dmg[0] := 0;

						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);

            if (dmg[0] > 0) then begin
							SetLength(bb, 2);
							bb[0] := 0; // Just push in the direction you're casting
              bb[1] := 0; // for 2 tiles.
							//bb[0] := 6;
							xy := tc1.Point;
							DirMove(tm, tc1.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> tc1.Point.X div 8) or (xy.Y div 8 <> tc1.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].CList do begin
									assert(IndexOf(tc1.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(tc1.ID));
								end;
								tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].CList.AddObject(tc1.ID, tc1);
							end;
							tc1.pcnt := 0;
							//Update Players Location
							UpdatePlayerLocation(tm, tc1);
						end;
						if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
            StatCalc2(tc, tc1, Tick);

						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue; tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
									if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(tc2.ID),tc2);
								end;
							end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								tc2 := sl.Objects[k1] as TChara;

            xy.X := tc2.Point.X - Point.X;
						xy.Y := tc2.Point.Y - Point.Y;
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

								DamageCalc3(tm, tc, tc2, Tick, 0, 150 + (tc.Cart.Weight div 800), tl.Element, 0);
								//dmg[0] := dmg[0] + (tc.Cart.MaxWeight div 8000);
                if dmg[0] < 0 then dmg[0] := 0;

								SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1, 5);

              if (dmg[0] > 0) then begin
							SetLength(bb, 2);
							bb[0] := 0; // Just push in the direction you're casting
              bb[1] := 0; // for 2 tiles.
							//bb[0] := 6;
							xy := tc2.Point;
							DirMove(tm, tc2.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> tc2.Point.X div 8) or (xy.Y div 8 <> tc2.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].CList do begin
									assert(IndexOf(tc2.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(tc2.ID));
								end;
								tm.Block[tc2.Point.X div 8][tc2.Point.Y div 8].CList.AddObject(tc2.ID, tc2);
							end;
							tc2.pcnt := 0;
							//Update Players Location
							UpdatePlayerLocation(tm, tc2);
						end;
								if not DamageProcess2(tm, tc, tc2, dmg[0], Tick) then
    						StatCalc2(tc, tc2, Tick);
							end;
						end;

          end;

        251:
            begin
                if (tc.Shield <> 0) then begin

                    i1 := 0;
                    k  := 1;
                    while (i1 >= 0) and (i1 < tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].NPC.Count) do begin
                        tn := tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].NPC.Objects[i1] as TNPC;
                        if tn = nil then begin
                            Inc(i1);
                            continue;
                        end;
                        if (tc1.Point.X = tn.Point.X) and (tc1.Point.Y = tn.Point.Y) then begin
                            case tn.JID of
                                $85: {Pneuma}
                                begin
                                    dmg[0] := 0;
                                    //DebugOut.Lines.Add('Pneuma OK');
                                    dmg[6] := 0;
                                    k := 0;
                                end;
                            end;
                        end;
                        Inc(i1);
                    end;

                    if (k = 1) then begin
                        DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
                    end;

                    if dmg[0] < 0 then dmg[0] := 0;
                    SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);
                    if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then StatCalc2(tc, tc1, Tick);
                end;
            end;

        254:
          begin
                NoCastInterrupt := true;
                DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
                j := 3;
                if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï

                SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
                if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
                StatCalc2(tc, tc1, Tick);
                xy := tc1.Point;

                sl.Clear;
                for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
                        for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
                                for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
                                        if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue; tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
                                        if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
                                        if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
                                                sl.AddObject(IntToStr(tc2.ID),tc2);
                                end;
                        end;
                end;

                if sl.Count <> 0 then begin
                        for k1 := 0 to sl.Count - 1 do begin
                                tc2 := sl.Objects[k1] as TChara;
                                DamageCalc3(tm, tc, tc2, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
                                j := 1;
                                if dmg[0] < 0 then dmg[0] := 0;
                                SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1, 6);
                                //SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
                                if not DamageProcess2(tm, tc, tc2, dmg[0], Tick) then
{í«â¡}				StatCalc2(tc, tc2, Tick);
                        end;


                end;
           end;
                                277:    {Spellbreaker}
                                        begin
                                                tc.SP := tc.SP + (tc1.SPAmount * tc.Skill[277].Data.Data1[MUseLv]);
                                                if tc.SP > tc.MAXSP then tc.SP := tc.MAXSP;
                                                tc1.MMode := 0;
                                                tc1.MPoint.X := 0;
                                                tc1.MPoint.Y := 0;
                                                WFIFOW(0, $01b9);
                                                WFIFOL(2, tc1.ID);
                                                SendBCmd(tm, tc1.Point, 6);
                                        end;
                                289:  {Dispell}
                                  begin
                                    for i := 1 to MAX_SKILL_NUMBER do begin
                                      tc1.Skill[i].Tick := Tick;
						                          tc1.Skill[i].EffectLV := 0;
						                          tc1.Skill[i].Effect1 := 0;
						                          if SkillTick > tc1.Skill[i].Tick then begin
							                          SkillTick := tc1.Skill[i].Tick;
							                          SkillTickID := MSkill;
                                      end;
						                          //Remove Icons
			                                if tc1.Skill[i].Data.Icon <> 0 then begin
							                          //DebugOut.Lines.Add('(Icon Removed)!');
                                        UpdateIcon(tm, tc1, tc1.Skill[i].Data.Icon, 0);
						                          end;
                                      CalcStat(tc1, Tick);
                                      SendCStat(tc1);
                                    end;

                                  end;
                                374:  {Soul Change PvP}
                                begin
                                {
                                  Requirement: Magic Rod LV 3, Spell Breaker LV 2
                                  * Exchange SP of the target with your SP. You can use this for
                                  party members in normal maps, and for anyone in PvP. If any leftover
                                  SP remains, they will be ignored (for example, a Knight with 200 SP
                                  will not have any more than max SP of 200 even if the Professor
                                  had 1000 SP). If a magic caster gets SP switched,
                                  and his or her SP doesn't fulfill the requirement for magic he
                                  or she was casting, the magic will do absolutely nothing.
                                  It takes 3 seconds to cast, and takes 5 SP.
                                  There's also nasty 5 second after-skill delay.
                                  If you use this on a monster, you regain 3% of your SP.
                                  You can't use this skill on a monster again that already had
                                  Soul Change.
                                }
                                  i := tc.SP;
                                  k := tc1.SP;
                                  tc.SP := k;
                                  tc1.SP := i;
                                  if tc1.SP > tc1.MAXSP then tc1.SP := tc1.MAXSP;
                                  if tc.SP > tc.MAXSP then tc.SP := tc.MAXSP;
                                  tc.MTick := Tick + 5000;

                                  SendCStat(tc);
                                  SendCStat(tc1);
                                  {Socket.SendBuf(buf, 8);
                                  WFIFOW( 0, $00b0);
                                  WFIFOW( 2, $0005);
                                  WFIFOL( 4, SP);
                                  Socket.SendBuf(buf, 8);

                                  tc1.Socket.SendBuf(buf, 8);
                                  WFIFOW( 0, $00b0);
                                  WFIFOW( 2, $0005);
                                  WFIFOL( 4, tc1.SP);
                                  tc1.Socket.SendBuf(buf, 8); }



                                end;

                                375: //Soul Burn pVp
                                begin
	                                i := tc1.SP;
	                                dmg[0] := i * 2;
	                                if Random(100) < Skill[375].Data.Data1[MUseLV] then begin
                                    tc.SP := 0;
                                    //dmg[0] := dmg[0] - (tc.MDEF1 + tc.MDEF2);
                                    //if dmg[0] < 0 then dmg[0] := 0;
		                                DamageProcess2(tm, tc, tc, dmg[0], Tick);
                                    SendCStat(tc);
	                                end else begin
                                    tc1.SP := 0;
                                    //dmg[0] := dmg[0] - (tc1.MDEF1 + tc1.MDEF2);
		                                DamageProcess2(tm, tc, tc1, dmg[0], Tick);
                                    SendCStat(tc1);
                                  end;
                                end;

           end;
           if tc1.MagicReflect then begin
                        //tc.MSkill := 252;
                        tc1.MSkill := 252;
                        dmg[0] := dmg[0] * 30 div 100;
                        SendCSkillAtk2(tm, tc1, tc, Tick, dmg[0], 1, 6);
                        if not DamageProcess2(tm, tc1, tc, dmg[0], Tick) then StatCalc1(tc, ts, Tick);
                        dmg[0] := 0;
                        dmg[5] := 11;
           end;

                end;
{í«â¡:119ÉRÉRÇ‹Ç≈}


                        end;

                        
			end else begin
				if tc.MTick + 500 < Tick then begin
					MMode := 4;
					Exit;
			end;
			end;


           {if (tc1 <> nil) then begin
           if (tc1.Skill[225].Lv <> 0) then begin
           if (tc.Skill[tc.MSkill].Lv <= tc1.Skill[225].Lv) then begin
           if (tc1.Plag <> 0) then begin
           tc1.Skill[tc1.Plag].Plag := false;
           tc1.Skill[tc1.Plag].Lv := 0;
           end;
           tc1.Plag := tc.MSkill;
           tc1.PLv := tc.Skill[tc.MSkill].Lv;
           tc1.Skill[tc.MSkill].Plag := true;
           SendCSkillList(tc1);
           end;
           end;
           end;}
			case ProcessType of
				0: // Player skill, no time limit, no status update, no icon
					begin
						// Send effect
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, dmg[0]);
						WFIFOL( 6, tc1.ID);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, tc1.Point, 15);
          end;
        1: // Player skill, no time limit, with icon change
					begin
            if (tc1.MSkill <> 135) then begin
  						WFIFOW( 0, $011a);
  						WFIFOW( 2, MSkill);
  						WFIFOW( 4, MUseLV);
  						WFIFOL( 6, tc1.ID);
  						WFIFOL(10, ID);
  						WFIFOB(14, 1);
  						SendBCmd(tm, tc1.Point, 15);
            end;

            // Hiding
            if (tc1.MSkill = 51) then begin {Hiding}

              if (tc1.Option and 2 <> 0) then begin
                //tc1.setSkillOnBool(False); //set SkillOnBool for icon update //beita 20040206
                tc1.Skill[MSkill].Tick := Tick;
	    					tc1.Option := tc1.Option and $FFFD;
                SkillTick := tc1.Skill[MSkill].Tick;
                SkillTickID := MSkill;
                //tc1.SP := tc1.SP + 10;  // Colus 20040118
                tc1.Hidden := false;
                //if tc1.SP > tc1.MAXSP then tc1.SP := tc1.MAXSP;
              end else begin
                //tc1.setSkillOnBool(True); //set SkillOnBool for icon update //beita 20040206
                // Required to place Hide on a timer.
						    tc1.Skill[MSkill].Tick := Tick + cardinal(tl.Data1[MUseLV]) * 1000;

    						if SkillTick > tc1.Skill[MSkill].Tick then begin
							    SkillTick := tc1.Skill[MSkill].Tick;
							    SkillTickID := MSkill;
    					  end;

                //tc1.Optionkeep := tc1.Option;
                tc1.Option := tc1.Option or 2;
                tc1.Hidden := true;
                // Colus, 20040224: Hide also drains SP but at a different rate...
                tc1.CloakTick := Tick;
              end;

              CalcStat(tc1, Tick);

              UpdateOption(tm, tc1);

              // Colus, 20031228: Tunnel Drive speed update
              if (tc1.Skill[213].Lv <> 0) then begin
                SendCStat1(tc1, 0, 0, tc1.Speed);
    					end;

            end;

                // Play Dead
                if (tc1.MSkill = 143) then begin
                        if tc1.Sit = 1 then begin

                                //set SkillOnBool for icon update //beita 20040206
                                //tc1.setSkillOnBool(False);

                                tc1.Sit := 3;

                                SkillTick := tc1.Skill[MSkill].Tick;
                                SkillTickID := MSkill;

                                tc1.SP := tc1.SP + 5;
                                if tc1.SP > tc1.MAXSP then tc1.SP := tc1.MAXSP;

                                CalcStat(tc1, Tick);
                        end else begin
                                //set SkillOnBool for icon update //beita 20040206
                                //tc1.setSkillOnBool(True);
                                tc1.Sit := 1;
                        end;
            end;

            if (tl.Icon <> 0) then begin
              UpdateIcon(tm, tc, tl.Icon, 1);
						end;
          end;
				2, 3: // Player-based, time-limited skill (2 = no status update, 3 = status update)
					begin
						// Send effect
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, tc1.ID);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, tc1.Point, 15);
						tc1.Skill[MSkill].Tick := Tick + cardinal(tl.Data1[MUseLV]) * 1000;
						tc1.Skill[MSkill].EffectLV := MUseLV;
						tc1.Skill[MSkill].Effect1 := tl.Data2[MUseLV];
						if SkillTick > tc1.Skill[MSkill].Tick then begin
							SkillTick := tc1.Skill[MSkill].Tick;
							SkillTickID := MSkill;
						end;
						if MSkill = 61 then tc1.Skill[MSkill].Tick := Tick + cardinal(tl.Data1[MUseLV]) * 110;
						CalcStat(tc1, Tick);
						if ProcessType = 3 then SendCStat(tc1);
						//ÉAÉCÉRÉìï\é¶
			if (tl.Icon <> 0) and (tl.Icon <> 107) then begin
							//DebugOut.Lines.Add('(ﬂÅÕﬂ)!');
              UpdateIcon(tm, tc1, tl.Icon, 1);
						end;
					end;

				4,5: // Party-only time-limited skills (4 means no status change, 5 means status change)
					begin
						sl.Clear;
						if (tc.PartyName = '') then begin
							sl.AddObject(IntToStr(tc.ID),tc);
						end else begin
							tpa := PartyNameList.Objects[PartyNameList.IndexOf(tc.PartyName)] as TParty;
							for k := 0 to 11 do begin
								if(tpa.MemberID[k] = 0) then break;
								if tpa.Member[k].Login <> 2 then Continue;
								if tc.Map <> tpa.Member[k].Map then Continue;
								if (abs(tc.Point.X - tpa.Member[k].Point.X) < 16) and
								(abs(tc.Point.Y - tpa.Member[k].Point.Y) < 16) then
									sl.AddObject(IntToStr(tpa.MemberID[k]),tpa.Member[k]);
							end;
						end;
						if sl.Count <> 0 then begin
							for k := 0 to sl.Count -1 do begin
								tc1 := sl.Objects[k] as TChara;
								//ÉpÉPëóêM
								WFIFOW( 0, $011a);
								WFIFOW( 2, tc.MSkill);
								WFIFOW( 4, tc.MUseLV);
								WFIFOL( 6, tc1.ID);
								WFIFOL(10, tc1.ID);
								WFIFOB(14, 1);
								SendBCmd(tm, tc1.Point, 15);
                if tc.MSkill = 255 then begin
                  if tc.JID = 14 then tc1.Crusader := tc;
                end;
								//DebugOut.Lines.Add(Format('ID %d casts %d to ID %d', [tc.ID,tc.MSkill,tc1.ID]));
								tc1.Skill[tc.MSkill].Tick := Tick + cardinal(tl.Data1[tc.MUseLV]) * 1000;
								tc1.Skill[tc.MSkill].EffectLV := tc.MUseLV;
								tc1.Skill[tc.MSkill].Effect1 := tl.Data2[tc.MUseLV];
								if tc1.SkillTick > tc1.Skill[tc.MSkill].Tick then begin
									tc1.SkillTick := tc1.Skill[tc.MSkill].Tick;
									tc1.SkillTickID := tc.MSkill;
								end;
								CalcStat(tc1, Tick);
								if ProcessType = 5 then SendCStat(tc1);
								//ÉAÉCÉRÉìï\é¶
								if (tl.Icon <> 0) then begin
                  UpdateIcon(tm, tc1, tl.Icon, 1);
								end;
							end;
						end;
					end;
			end;
{ÉpÅ[ÉeÉBÅ[ã@î\í«â¡ÉRÉRÇ‹Ç≈}
		end;
	end;
	sl.Free;
end;

{í«â¡Ç±Ç±Ç‹Ç≈}
//------------------------------------------------------------------------------
//âÒïúÉXÉLÉãìô
procedure TfrmMain.CharaPassive(tc:TChara;Tick:cardinal);
var
	j :Integer;
  tc1:TChara;
  xy:TPoint;
  sl:TStringList;
  tl:TSkillDB;
  i1,j1,k1:integer;
  bonusregen:Integer;
  tm:TMap;
begin
	with tc do begin
		//HPSPâÒïúèàóù
		if Weight * 2 < MaxWeight then begin

if (HPTick + HPDelay[3 - Sit] <= Tick) and (Skill[271].Tick < Tick) and (tc.isPoisoned = false) and  (tc.Option and 6 = 0) then begin
if HP <> MAXHP then begin
bonusregen := (MAXHP div 200) + (Param[1] div 5) ;
if bonusregen = 0 then begin ;
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

if (SPTick + SPDelay[3 - Sit] <= Tick) and (Skill[271].Tick < Tick) and  (tc.Option and 6 = 0) then begin
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

				if (Skill[4].Lv <> 0) and (HPRTick + 10000 <= Tick) and (tc.Sit <> 1 ) and (tc.Option and 6 = 0) then begin
					if HP <> MAXHP then begin
						j := (5 + MAXHP div 500) * Skill[4].Lv;
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

        {Colus, 20031223: Why is the SP part of Spiritual Relaxation here?}
        {Shouldn't it be in SkillPassive?  Oh, well...}
        { Anyway, according to kRO site, SP *can* be recovered with this
          in Critical Explosion mode, but not in normal regen.  So I'm
          removing the Critical Explosion check while adding the Ashura check.
          Also, it doesn't say anything about recovering HP, so that's not
          changed...for now.}
        if (Sit = 2) and (Skill[260].Lv <> 0) and (SPRTick + 10000 <= Tick) and (Skill[271].Tick < Tick) and (tc.Option and 6 = 0) then begin
					if (SP <> MAXSP) then begin
{ãZèp229}   j := (3 + MAXSP * 2 div 1000) * Skill[260].Data.Data2[Skill[260].Lv];
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

				if (Skill[9].Lv <> 0) and (SPRTick + 10000 <= Tick) and (tc.Sit <> 1 ) and (tc.Option and 6 = 0) then begin
					if SP <> MAXSP then begin
{ãZèp229}   j := (3 + MAXSP * 2 div 1000) * Skill[9].Lv;
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
	j :Integer;
  tc1:TChara;
  xy:TPoint;
  sl:TStringList;
  tl:TSkillDB;
  i1,j1,k1,k:integer;
  tm:TMap;
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
{                        WFIFOW( 0, $013d);
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
{                        WFIFOW( 0, $013d);
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
                          //DebugOut.Lines.Add('Hit cloaktick');
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
                          //DebugOut.Lines.Add('Hit cloaktick');
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
                          //DebugOut.Lines.Add('Hit maximize tick');
                        end else begin
                          // Colus, 20040307: Fixed crash bug (map set properly), remove icon, 0 SP.
                          tm := tc.MData;
                          tc.SP := 0;
                          SendCStat1(tc, 0, 7, SP);
                          tc.Skill[114].Tick := Tick;
                          tc.Skill[114].EffectLV := 0;
                          SkillTick := tc.Skill[114].Tick;
                          SkillTickID := 114; //DebugOut.Lines.Add(Format('STID %d', [SkillTickID]));
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
			if (HPTick + HPDelay[3 - Sit] <= Tick) and (Skill[271].Tick < Tick) and (Option and 6 = 0) then begin
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
			end;
			//SPé©ìÆâÒïú
      {Colus, 20031223: Added check for Ashura recovery period.}
			if (SPTick + SPDelay[3 - Sit] <= Tick) and (Skill[270].Tick < Tick) and (Skill[271].Tick < Tick) and (Option and 6 = 0) then begin
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
			end;  

			if (Sit >= 2) then begin

        if (Sit = 2) and (Skill[260].Lv <> 0) and (HPRTick + 10000 <= Tick) and (Skill[271].Tick < Tick) and (Option and 6 = 0) then begin
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
                                end;
                                end;
                                //end;
                                end;
                {if (tc.Skill[70].Tick mod 5000 = 0) then begin
                        tc.HP := 1;
                end;}
//------------------------------------------------------------------------------
procedure TfrmMain.PetPassive(tc:TChara; _Tick:cardinal);
var
  j,k,m,n :Integer;
  spd:cardinal;
	xy:TPoint;
	dx,dy:integer;
	tm:TMap;
	tn1:TNPC;
  tn:TNPC;
  tpe:TPet;
  tc1:TChara;
  i1,j1,k1:integer;
	MobData:TMobDB;
	sl:TStringList;
  Tick:cardinal;
  //ts:TMob;
  //tc1:TChara;
  //xy:TPoint;
begin
  sl := TStringList.Create;
  tm := tc.MData;
  tn1 := tc.PetNPC;
  tpe := tc.PetData;
  MobData := tpe.MobData;

  if tpe.Accessory <> 0 then begin
    with tn1 do begin

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


    if MobData.isLoot = true then begin

      if (not tpe.isLooting) then begin
				//Clear the Stringlist
				sl.Clear;

				//Find items in Range
				for j1 := Point.Y div 8 - 3 to Point.Y div 8 + 3 do begin
					for i1 := Point.X div 8 - 3 to Point.X div 8 + 3 do begin
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
					    //if ts.Item[10].ID = 0 then begin
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
					    //end;
					end;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
      end;
			//end;
    //DebugOut.Lines.Add('Poring is your pet.');
    end;
  end;
  end;
	sl.Free;//safe 2004/04/26
end;


//------------------------------------------------------------------------------
function TfrmMain.NPCAction(tm:TMap;tn:TNPC;Tick:cardinal) : Integer;
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
        mi := MapInfo.Objects[MapInfo.IndexOf(tm.Name)] as MapTbl;
	k := 0;
	if (tn.CType = 3) and (tn.Tick <= Tick) then begin
                if tn.JID  = $F1 then begin
                        WFIFOW(0, $00a1);
		        WFIFOL(2, 1118);
		        SendBCmd(tm, tn.Point, 6);
                        with tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC do
			        Delete(IndexOf(1118));
                        tn.Free;
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
	end else if (tn.CType = 4) then begin //ÉXÉLÉãå¯î\ín
		if tn.Tick <= Tick then begin
			case tn.JID of
        $8D: // Icewall ends
          begin
						DelSkillUnit(tm, tn);
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
            //DebugOut.Lines.Add('Talkie changed');
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

				else
					begin
						//ÉXÉLÉãå¯î\ínìPãé
						DelSkillUnit(tm, tn);
						Dec(k);
					end;
			end;
		end else begin
			//ÉXÉLÉãå¯î\ínå¯â  Charaì•Ç›å^
			c := 0;
			while (c >= 0) and (c < tm.Block[tn.Point.X div 8][tn.Point.Y div 8].CList.Count) do begin
				tc1 := tm.Block[tn.Point.X div 8][tn.Point.Y div 8].CList.Objects[c] as TChara;
				Inc(c);
				if tc1 = nil then continue;
				if (tc1.pcnt = 0) and (tc1.Point.X = tn.Point.X) and (tc1.Point.Y = tn.Point.Y) then begin
					case tn.JID of
						$80: //É|Å[É^Éãî≠ìÆå„
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
									DelSkillUnit(tm, tn);
									Dec(k);
									c := -1;
									continue;
								end else begin
									Dec(c);
								end;
							end;
            $99: // Talkie Box fires
            begin
             //DebugOut.Lines.Add('Talkie fire self');
              WFIFOW(0, $0191);
              WFIFOL(2, tc1.ID);
              WFIFOS(6, tn.Name, 80);
              //DebugOut.Lines.Add(Format('Name %s', [tn.Name]));
              SendBCmd(tm, tn.Point, 86);
            end;
            $8c: // Talkie Box fires
            begin
              WFIFOW(0, $0191);
              //DebugOut.Lines.Add(Format('Name %s', [tn.Name]));
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
			//èÍèäéwíËÉXÉLÉã îÕàÕå^
		  flag := False;
                        sl2 := TStringList.Create;
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
								//end;
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
								//end;
							end;
                                                end;  //End Case
                                        //tMonster.IsCasting := false;
                                        //Exit;
                                        end;
                                end;
                            end;
                        end;

                        if sl2.Count <> 0 then begin
                                for c1 := 0 to sl2.Count - 1 do begin
                                        tc2 := sl2.Objects[c1] as TChara;
                                        if (tc2.NoTarget = false) and (tc2.HP > 0) then begin
                                          case tn.JID of
                                                {//$46: //Sanctuary
                                                     begin
                                                                if tc2.MTick < Tick then begin
									dmg[0] := tn.CData.Skill[70].Data.Data2[tn.MUseLV];

									tn.Tick := Tick;
                                                     
                                                                        tc2.HP := tc2.HP + dmg[0];
						                        if tc2.HP > tc2.MAXHP then tc2.HP := tc2.MAXHP;
                                                                        WFIFOW( 0, $011a);
                                                                        WFIFOW( 2, tn.MSkill);
                                                                        WFIFOW( 4, dmg[0]);
                                                                        WFIFOL( 6, tc2.ID);
                                                                        WFIFOL(10, tn.ID);
                                                                        WFIFOB(14, 1);
							                SendBCmd(tm, tc2.Point, 15);
						                        SendCStat1(tc2, 0, 5, tc2.HP);
									SendBCmd(tm, tn.Point, 31);

                                                                        tc2.MTick := Tick + 1000;
                                                                end;
                                                     end;}
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
                                                $49:    {Ragnarok}
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
                                                {Mr Rich Man A Kim}
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
                                                {//$a7:    Whistle Effect
                                                        begin
                                                                //if tc2.MTick < Tick then begin
                                                                //if not flag then Break;
                                                                if tc2.Skill[319].Tick > Tick then break;
                                                                        {tc2.FLEE1 := tc2.FLEE1 - (tc2.FLEE1 * tc2.Skill[319].Effect1 div 100);
                                                                        tc2.Bonus[5] := tc2.Bonus[5] - (tc2.Param[5] * tc2.Skill[319].Effect1 div 100);
                                                                end;
                                                                tc2.Skill[319].Tick := tn.Tick;
                                                                        {tc2.FLEE1 := tc2.FLEE1 + (tc2.FLEE1 * tn.CData.Skill[319].Data.Data2[tn.MUseLV] div 100);
                                                                        tc2.Bonus[5] := tc2.Param[5] * tn.CData.Skill[319].Data.Data2[tn.MUseLV] div 100;
                                                                        {CalcStat(tc2, Tick);
                                                                        SendCStat1(tc2, 0, 5, tc2.FLEE1);
                                                                        SendCStat1(tc2, 0, 5, tc2.Bonus[5]);
                                                                        SendBCmd(tm, tn.Point, 31);
                                                                tc2.Skill[319].EffectLV := tn.MUseLV;
                                                                tc2.Skill[319].Effect1 := tc2.Skill[319].Data.Data2[tn.MUseLV];
						                if tc2.SkillTick > tc2.Skill[319].Tick then begin
							                tc2.SkillTick := tc2.Skill[319].Tick;
							                tc2.SkillTickID := 319;
						                end;
                                                                CalcSkill(tc2, Tick);
                                                                SendCStat(tc2);
                                                                tn.Tick := Tick;
                                                                //flag := false;

                                                        end;}
                                                {//$a8:    {Assassain Cross At Sunset
                                                        begin
                                                                tc2.Skill[320].Tick := Tick + tn.CData.Skill[320].Data.Data1[tn.MUseLV];

                                                        end;}
                                                end;
                                end;
                        end;
                        end;
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
                                                $74://ÉuÉâÉXÉgÉ}ÉCÉìî≠ìÆ
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
									dmg[0] := tc1.MATK1 + Random(tc1.MATK2 - tc1.MATK1 + 1) * tc1.MATKFix * tl.Data1[tn.MUseLV] div 100;
									dmg[0] := dmg[0] * (100 - tc2.MDEF1 + tc2.MDEF2) div 100; //MDEF%
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
								//DebugOut.Lines.Add('Hit') ;
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
              //  DebugOut.Lines.Add('Talkie fire pvp');
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
                  //DebugOut.lines.add(format('et3 %d, tick %d',[ts1.EffectTick[3], Tick]));
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
									DelSkillUnit(tm, tn);
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
						$86: //LoV
							begin
								if (tn.Tick + 1000 * tn.Count) < (Tick + 3000) then begin
									dmg[0] := tc1.MATK1 + Random(tc1.MATK2 - tc1.MATK1 + 1) * tc1.MATKFix * tl.Data1[tn.MUseLV] div 100;
									dmg[0] := dmg[0] * (100 - ts1.Data.MDEF) div 100; //MDEF%
									dmg[0] := dmg[0] - ts1.Data.Param[3]; //MDEF-
									if dmg[0] < 1 then dmg[0] := 1;
									dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100;
									//dmg[0] := dmg[0] * tl.Data2[tn.MUseLV];
									if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
									WFIFOW( 0, $01de);
									WFIFOW( 2, 85);
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
										if tn.Count = 1 then tn.Tick := Tick
									end;
								end;
							end;
						$87: //FP
							begin
								//DebugOut.Lines.Add('Hit') ;
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
                $89: //Quagmire
                     //ts.EffectTick[1] set to be the tick value of monster under
                     //Quagmire effect. effect will resume after EffectTick[1]
                     //is less than Tick, done in procedure StatEffect
            begin
              if (ts1.EffectTick[1] < Tick ) then begin
                 ts1.Speed := ts1.Speed * 2;
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
									DelSkillUnit(tm, tn);
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

    if (isLeader) and ( (MonsterMob) or ((isSummon) and (SummonMonsterMob)) )then begin
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
      end;

	if Status = 'RUN' then begin
      ts.ATarget := 0;
      ts.tgtPoint.X := ts.Point.X + Random(10);
      ts.tgtPoint.Y := ts.Point.Y + Random(10);
    end;

		if (ATarget = 0) then begin
			//if Data.isActive then begin

			if (isActive) and (ts.Status <> 'RUN') then begin
			
				sl.Clear;
				for j1 := Point.Y div 8 - 3 to Point.Y div 8 + 3 do begin
					for i1 := Point.X div 8 - 3 to Point.X div 8 + 3 do begin
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
				for j1 := Point.Y div 8 - 3 to Point.Y div 8 + 3 do begin
					for i1 := Point.X div 8 - 3 to Point.X div 8 + 3 do begin
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
				for j1 := Point.Y div 8 - 3 to Point.Y div 8 + 3 do begin
					for i1 := Point.X div 8 - 3 to Point.X div 8 + 3 do begin
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
				for j1 := Point.Y div 8 - 3 to Point.Y div 8 + 3 do begin
					for i1 := Point.X div 8 - 3 to Point.X div 8 + 3 do begin
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
        ts2:TMob;
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
                                                exit;
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
											//DebugOut.Lines.Add(Format('***RandomRoute Error!! (%d,%d) %dx%d', [xy.X,xy.Y,tm.Size.X,tm.Size.Y]));
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
											//DebugOut.Lines.Add('MobBlockDelete2 ' + Inttostr(c));
											if c <> -1 then begin
												tm.Block[Point.X div 8][Point.Y div 8].Mob.Delete(c);
												Dec(a);
											end else begin
												//DebugOut.Lines.Add(Format('MobBlockDelete2 %d (%d,%d)',[c,Point.X,Point.Y]));
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
	i,j,k,m,n,c:integer;
	tc1:TChara;
	tn:TNPC;
	spd:cardinal;
	xy:TPoint;
	dx,dy:integer;
        ts1:TMob;

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
			//DebugOut.Lines.Add(Format('	 Mob-Move %d/%d (%d,%d) %d %d %d', [ppos, pcnt, Point.X, Point.Y, path[ppos-1], spd, Tick]));

			//ÉuÉçÉbÉNèàóù
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
					//DebugOut.Lines.Add(Format('MobBlockDelete %d (%d,%d)',[c,xy.X,xy.Y]));
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
	i,j,c:	integer;
	tc1:	TChara;
        tc2:	TChara;
	xy:	TPoint;
begin
	with ts do begin
		tc2 := nil;
		tc1 := AData;
		if tc1.GraceTick > Tick then exit;

		if tc1.Skill[255].Tick > Tick then begin
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
		{ Attacks if monster and player are within range of each other }

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
							tc2.HP := 0;
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
                end;
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
							
						end;
						SendCStat1(tc1, 0, 5, tc1.HP);
						ATick := ATick + Data.ADelay;
					end;
				end;
			end;
			
			ARangeFlag := true;
			
		end else if (abs(ts.Point.X - tc1.Point.X) > 13) or (abs(ts.Point.Y - tc1.Point.Y) > 13) then begin
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
                                                if ( (Path_Finding(path, tm, Point.X, Point.Y, xy.X, xy.Y, 1) <> 0) and (abs(Point.X - xy.X) <= ts.Data.Range2) and (abs(Point.Y - xy.Y) <= ts.Data.Range2) ) then begin
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
	if sflag then begin
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
				for j1 := Point.Y div 8 - 3 to Point.Y div 8 + 3 do begin
					for i1 := Point.X div 8 - 3 to Point.X div 8 + 3 do begin
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
				for j1 := Point.Y div 8 - 3 to Point.Y div 8 + 3 do begin
					for i1 := Point.X div 8 - 3 to Point.X div 8 + 3 do begin
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
						if ATick + tc.ADelay - 200 < Tick then
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
			for j1 := Point.Y div 8 - 3 to Point.Y div 8 + 3 do begin
				for i1 := Point.X div 8 - 3 to Point.X div 8 + 3 do begin
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
	ts	: TMob;
	ts1 : TMob;
	i, j, i1, j1, k1: integer;
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

label ExitWarpSearch;
begin

        edit1.SetFocus;

	sl := TStringList.Create;
	try
	cmdStart.Enabled := false;
  
	sv1.Active := true;
	sv2.Active := true;
	sv3.Active := true;

	ServerRunning := true;
	cmdStop.Enabled := true;
	TickCheckCnt := 0;

        OnlineTime := timeGetTime(); // AlexKreuz

        DelDelayNum := 0; // mf

	repeat

                DelCount := 0;                                                            // mf
                repeat                                                                    // mf
                        if (DelPointX[DelDelayNum] <> 0) and (DelWait[DelDelayNum] + 5000 < Tick) then begin    // mf
                                DelPoint.X := DelPointX[DelDelayNum];                     // mf
                                DelPoint.Y := DelPointY[DelDelayNum];                     // mf
                           	WFIFOW( 0, $0080);                                        // mf
                	        WFIFOL( 2, DelID[DelDelayNum]);                           // mf
                	        WFIFOB( 6, 1);                                            // mf
                	        SendBCmd(tm, DelPoint, 7);                                // mf
                                DelPointX[DelDelayNum] := 0;                              // mf
                                DelPointY[DelDelayNum] := 0;                              // mf
                                DelID[DelDelayNum] := 0;                                  // mf
                                DelWait[DelDelayNum] := 0;                                // mf
                        end;                                                              // mf
                                                                                          // mf
                        DelDelayNum := DelDelayNum + 1;                                   // mf
                                                                                          // mf
                        if DelDelayNum > 999 then DelDelayNum := 0;                       // mf
                        DelCount := DelCount + 1;                                         // mf
                until DelCount > 9;                                                       // mf
        //if Timer = true then begin

		Tick := timeGetTime();

                // AlexKreuz Online Time
                ElapsedT := (Tick - Cardinal(OnlineTime));

                ElapsedD := int (ElapsedT / 86400000);
                ElapsedT := ElapsedT Mod 86400000;

                ElapsedH := int (ElapsedT / 3600000);
                ElapsedT := ElapsedT Mod 3600000;

                ElapsedM := int (ElapsedT / 60000);
                ElapsedT := ElapsedT Mod 60000;

                ElapsedS := int (ElapsedT / 1000);

                //statusbar1.Panels.Items[1].Text := floattostr(ElapsedT);
                statusbar1.Panels.Items[2].Text := floattostr(ElapsedD) +' Days, '+ floattostr(ElapsedH) +' Hours, '+ floattostr(ElapsedM) +' Minutes, '+ floattostr(ElapsedS) +' Seconds.    '; // AlexKreuz (Status Bar)
        //end;
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
						//DebugOut.Lines.Add('Move processing error');
					end else begin
                                        /// alexkreuz: xxx
//					if ((tc.MMode = 0) or (tc.Skill[278].Lv > 0)) and ((tm.gat[NextPoint.X][NextPoint.Y] <> 1) and (tm.gat[NextPoint.X][NextPoint.Y] <> 5)) and ((tc.Option <> 6) or (tc.Skill[213].Lv <> 0) or (tc.isCloaked)) and (tc.SongTick < Tick) and (tc.AnkleSnareTick < Tick) then begin
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
				//DebugOut.Lines.Add('Move processing error');
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

                                for b := Point.Y div 8 - 3 to Point.Y div 8 + 3 do begin
					for a := Point.X div 8 - 3 to Point.X div 8 + 3 do begin
			                        if tm.Block[a][b] = nil then continue;
						//if not tm.Block[a][b].MobProcess then begin
						if tm.Block[a][b].MobProcTick < Tick then begin
							//ÉÇÉìÉXÉ^Å[à⁄ìÆèàóù(ïtãﬂÇÃÉÇÉìÉXÉ^Å[)
							//for k := 0 to tm.Block[a][b].Mob.Count - 1 do begin
							k := 0;
							while (k >= 0) and (k < tm.Block[a][b].Mob.Count) do begin
								//DebugOut.Lines.Add('mob : ' + IntToStr(k));
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
                                                                                if (ts.SkillType = 1) then MobSkills(tm, CastingMonster, Tick)
                                                                                //if tc.Skill[tsAI.Skill[i]].Data.SType = 2 then
                                                                                else if (ts.SkillType = 2) then MobFieldSkills(tm, CastingMonster, Tick)
                                                                                else MobStatSkills(tm, CastingMonster, Tick);
                                                                                CastingMonster.SkillWaitTick := Tick + Cardinal(CastingMonster.Data.WaitTick);

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
            if Boolean(MMode xor $04) then
              if (tc.ItemSkill = false) then begin
                // Colus, 20040118: Unhiding should not drain SP...
                // Colus, 20040204: The reason we are testing that we _are_ hidden is b/c we use
                // the mode set in the skill code previously.  This means you are hiding successfully.
                if (((MSkill <> 51) and (MSkill <> 135)) or ((MSkill = 51) and (Option and 2 <> 0)) or ((MSkill = 135) and (Option and 4 <> 0))) then begin
                  DecSP(tc, MSkill, MUseLV);
                end;
              end else begin
              tc.ItemSkill := false;
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
					end;
					// Remove icon if the skill has one...
          if tc.Skill[SkillTickID].Data.Icon <> 0 then begin
            if tc.Skill[tc.SkillTickID].Tick <= Tick then begin
  						//DebugOut.Lines.Add(Format('(Icon remove, skilltickid %d)',[SkillTickID]));
              UpdateIcon(tm, tc, tc.Skill[SkillTickID].Data.Icon, 0);
            end;
					end;

					CalcStat(tc, Tick);
					SendCStat(tc);
					CalcSkillTick(tm, tc, Tick);
				end;

                                //PassiveIcons(tm, tc);

				//Mob&Item Process
				tm := tc.MData;
				for b := Point.Y div 8 - 3 to Point.Y div 8 + 3 do begin
					for a := Point.X div 8 - 3 to Point.X div 8 + 3 do begin
			if tm.Block[a][b] = nil then continue;
						//if not tm.Block[a][b].MobProcess then begin
						if tm.Block[a][b].MobProcTick < Tick then begin
							//ÉÇÉìÉXÉ^Å[à⁄ìÆèàóù(ïtãﬂÇÃÉÇÉìÉXÉ^Å[)
							//for k := 0 to tm.Block[a][b].Mob.Count - 1 do begin
							k := 0;
							while (k >= 0) and (k < tm.Block[a][b].Mob.Count) do begin
								//DebugOut.Lines.Add('mob : ' + IntToStr(k));
                                                                if ((tm.Block[a][b].Mob.Objects[k] is TMob) = false) then begin
                                                                        Inc(k);
                                                                        continue;
                                                                end;

								ts := tm.Block[a][b].Mob.Objects[k] as TMob;
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
{èCê≥}								                        if ts.Mode <> 3 then k := k + MobMoving(tm,ts,Tick);
										end;
                    
									end else begin
                    if (ts.HP = 0) then continue;

										if isLooting then begin
											if ATick < Tick then
											 	PickUp(tm,ts,Tick);
										end else if (ATarget <> 0) and (Data.Range1 > 0) then begin
											MobAttack(tm,ts,Tick);
{èCê≥}							end else if (MoveWait < Tick) and (not isLooting) then begin
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
												//DebugOut.Lines.Add(Format('* * * * SearchPath Error (%d,%d)',[Point.X,Point.Y]));
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
								//DebugOut.Lines.Add('mob : ' + IntToStr(k));
                if ((tm.Block[a][b].NPC.Objects[k] is TNPC) = false) then begin
                Inc(k);
                continue;
                end;
                
								tn := tm.Block[a][b].NPC.Objects[k] as TNPC;
								Inc(k);
								if tn = nil then Continue;
								k := k + NPCAction(tm,tn,Tick);
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

                                                // é©ìÆï†å∏ÇËÉVÉXÉeÉÄ
                                                if tpe.Fullness > 0 then begin
                                                        if ( tn.HungryTick + tpe.Data.HungryDelay ) < Tick then begin
                                                                Dec( tpe.Fullness );

                                                                WFIFOW( 0, $01a4 );
                                                                WFIFOB( 2, 2 );
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

{NPCÉCÉxÉìÉgí«â¡}
		for k := 0 to Map.Count - 1 do begin
			tm := Map.Objects[k] as TMap;
			with tm do begin
				if (TimerAct.Count > 0) then begin
					for i := 0 to TimerAct.Count - 1 do begin
						tr := TimerAct.Objects[i] as NTimer;
						tn := tm.NPC.IndexOfObject(tr.ID) as TNPC;
						for a := 0 to tr.Cnt - 1 do begin
							if (tr.Tick + cardinal(tr.Idx[a]) <= Tick) and (tr.Done[a] = 0) then begin
								//DebugOut.Lines.Add(Format('NPC Timer Event(%d)', [tr.Idx[a]]));
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
	//DebugOut.Lines.Add('Data Saved');
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

        if Copy(Edit1.Text, 1, 1) = '-' then begin

                sl := TStringList.Create;
                sl.DelimitedText := Copy(Edit1.Text, 2, 256);

                if sl.Count = 0 then goto ExitParse;

                if sl.Strings[0] = 'users' then begin
                // Displays List of Online Users
                // Syntax: -users [global]

                        str := 'Users Currently Logged in: ';

                        k := 0;
                        for i := 0 to CharaName.Count - 1 do begin
        		              tc1 := CharaName.Objects[i] as TChara;
        			              if (tc1.Login = 2) and (tc1 <> tc2) then begin
                                        if k = 0 then begin
                                          tc2 := tc1;
                                          str := str + tc1.Name;
                                          k := k + 1
                                        end else begin
                                          tc2 := tc1;
                                          str := str + ', ' + tc1.Name;
                                          k := k + 1;
                                        end;
                                end;
                        end;

                        DebugOut.Lines.Add(str);

                        if sl.Count = 2 then begin
                                if sl.Strings[1] = 'global' then begin
                                        edit1.Text := str;
                                        button1.Click;
                                end;
                        end;

                end

                else if sl.strings[0] = 'save' then begin
                // Save data
                    DataSave();
                    Debugout.lines.add('Player data has been saved.');
                end

                else if sl.Strings[0] = 'reload' then begin
                // Reloads Databases. Warning, does not save Data.
                    MapList.Clear;
                    ItemDB.Clear;
                    ItemDBName.Clear;
                    MaterialDB.Clear;
                    MobDB.Clear;
                    MobDBName.Clear;
                    SummonMobList.Clear;
                    SummonMobListMVP.Clear;
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
                    debugout.lines.add('');
                    debugout.lines.add('Databases Reload Completed ...');
                    debugout.lines.add('');
                end

                else if sl.Strings[0] = 'uptime' then begin
                // Displays Uptime Stats in Console
                // Syntax: -uptime [global]

                        DebugOut.Lines.Add('Fusion Server Uptime: '+floattostr(ElapsedD) +' Days, '+ floattostr(ElapsedH) +' Hours, '+ floattostr(ElapsedM) +' Minutes, '+ floattostr(ElapsedS) +' Seconds.');

                        if sl.Count = 2 then begin
                                if sl.Strings[1] = 'global' then begin
                                        edit1.Text := 'Fusion Server Uptime: '+floattostr(ElapsedD) +' Days, '+ floattostr(ElapsedH) +' Hours, '+ floattostr(ElapsedM) +' Minutes, '+ floattostr(ElapsedS) +' Seconds.';
                                        button1.Click;
                                end;
                        end;
                end

                else if sl.Strings[0] = 'kick' then begin
                // Kicks User
                // Syntax: -kick username [global]

                        if sl.Count > 1 then begin
                                for i := 0 to CharaName.Count - 1 do begin
                                        tc1 := CharaName.Objects[i] as TChara;
                                        if (tc1.Name = sl.Strings[1]) then begin
                                                if tc1.Login = 2 then begin
                                                        WFIFOW(0, $00b3);
                                                        WFIFOB(2, $0001);
                                                        tc1.Socket.SendBuf(buf, 3);
                                                        DebugOut.Lines.Add(sl.Strings[1] + ' has been kicked.');
                                                        
                                                        if sl.Count > 2 then begin
                                                                if sl.Strings[2] = 'global' then begin
                                                                        edit1.Text := sl.Strings[1] + ' has been kicked.';
                                                                        button1.Click;
                                                                end;
                                                        end;
                                                end else begin
                                                        DebugOut.Lines.Add(sl.Strings[1] + ' is not online.');
                                                end;
                                        end;
                                end;
                        end;
                end

                else if str = '-ban' then begin
                // Bans IP Address [global]
                // Syntax: -ban ip.address

                end

                else if str = '-unban' then begin
                // Unbans IP Address [global]
                // Syntax: -unban ip.addresss

                end

                else if str = '-userstats' then begin
                // Relocates on or off-line character
                // Syntax: -move chara_name map_name x_coord y_coord

                end

                else if str = '-take' then begin
                // Removes an posession from a character
                // Type: zeny, item, level, jlevel, bexp, jexp, skill
                // Value: ID Number (item, skill only)
                // Quantity: Amount to remove
                // Syntax: -take type value quantity

                end

                else if str = '-give' then begin
                // Gives a posession to a character
                // Type: zeny, item, level, jlevel, bexp, jexp, skill
                // Value: ID Number (item, skill only)
                // Quantity: Amount to remove
                // Syntax: -give type value quantity

                end

                else if str = '-help' then begin
                // Displays list of Console Commands
                // Syntax: -help

                end

                else if str = '-move' then begin
                // Relocates on or off-line player
                // Syntax: -move chara_name map_name x_coord y_coord

                end

                else if sl.Strings[0] = 'sql' then begin
                // Pseudo SQL Database Administration

			if sl.Count > 1 then begin
		        	if sl.Strings[1] = 'update' then begin
					if sl.Count > 2 then begin

                                                // Player Data Begin
				        	if sl.Strings[2] = 'player' then begin
							if sl.Count > 3 then begin
						        	if sl.Strings[3] = 'set' then begin
									if sl.Count > 4 then begin
								        	if sl.Strings[4] = 'gender' then begin
											if sl.Count > 5 then begin
										        	if sl.Strings[5] = '=' then begin
													if sl.Count > 6 then begin
														if sl.Count > 7 then begin
													        	if sl.Strings[7] = 'where' then begin
																if sl.Count > 8 then begin
															        	if sl.Strings[8] = 'username' then begin
																		if sl.Count > 9 then begin
																	        	if sl.Strings[9] = '=' then begin
																			        if sl.Count > 10 then begin
                                                                                                                                                                        if PlayerName.IndexOf(sl.Strings[10]) = -1 then begin
                                                                                                                                                                                DebugOut.Lines.Add('That username does not exist.');
                                                                                                                                                                        end
                                                                                                                                                                        else begin
                                                                                                                                                                                tp1 := PlayerName.Objects[PlayerName.IndexOf(sl.Strings[10])] as TPlayer;

                                                                                                                                                                                DebugOut.Lines.Add('Username: '+sl.Strings[10]);
                                                                                                                                                                                DebugOut.Lines.Add('Old Gender: '+inttostr(tp1.Gender));
                                                                                                                                                                                tp1.Gender := strtoint(sl.Strings[6]);
                                                                                                                                                                                DebugOut.Lines.Add('New Gender: '+sl.Strings[6]);
                                                                                                                                                                                DebugOut.Lines.Add('Gender change was successful.');
                                                                                                                                                                        end;
                                                                                                                               			        	end;
                                                                                                                                                        end;
																	        end;
															        	end;
															        end;
													        	end;
													        end;
												        end;
										        	end;
										        end;
								        	end else

                                                                                if sl.Strings[4] = 'password' then begin
											if sl.Count > 5 then begin
										        	if sl.Strings[5] = '=' then begin
													if sl.Count > 6 then begin
														if sl.Count > 7 then begin
													        	if sl.Strings[7] = 'where' then begin
																if sl.Count > 8 then begin
															        	if sl.Strings[8] = 'username' then begin
																		if sl.Count > 9 then begin
																	        	if sl.Strings[9] = '=' then begin
																			        if sl.Count > 10 then begin
                                                                                                                                                                        if PlayerName.IndexOf(sl.Strings[10]) = -1 then begin
                                                                                                                                                                                DebugOut.Lines.Add('That username does not exist.');
                                                                                                                                                                        end
                                                                                                                                                                        else begin
                                                                                                                                                                                tp1 := PlayerName.Objects[PlayerName.IndexOf(sl.Strings[10])] as TPlayer;

                                                                                                                                                                                DebugOut.Lines.Add('Username: '+sl.Strings[10]);
                                                                                                                                                                                DebugOut.Lines.Add('Old Password: '+ tp1.Pass);
                                                                                                                                                                                tp1.Pass := sl.Strings[6];
                                                                                                                                                                                DebugOut.Lines.Add('New Password: '+sl.Strings[6]);
                                                                                                                                                                                DebugOut.Lines.Add('Password change was successful.');
                                                                                                                                                                        end;
                                                                                                                               			        	end;
                                                                                                                                                        end;
																	        end;
															        	end else

                                                                                                                                        if sl.Strings[8] = 'charaname' then begin
																		if sl.Count > 9 then begin
																	        	if sl.Strings[9] = '=' then begin
																			        if sl.Count > 10 then begin
                                                                                                                                                                        counter := 11;
                                                                                                                                                                        while sl.Count > counter do begin
                                                                                                                                                                                sl.Strings[10] := sl.Strings[10] + ' ' + sl.Strings[counter];
                                                                                                                                                                                counter := counter + 1;
                                                                                                                                                                        end;

                                                                                                                                                                        if CharaName.IndexOf(sl.Strings[10]) = -1 then begin
                                                                                                                                                                                DebugOut.Lines.Add('That character does not exist.');
                                                                                                                                                                        end
                                                                                                                                                                        else begin
                                                                                                                                                                                tc1 := CharaName.Objects[CharaName.IndexOf(sl.Strings[10])] as TChara;
                                                                                                                                                                                tp1 := Player.IndexOfObject(tc1.ID) as TPlayer;

                                                                                                                                                                                DebugOut.Lines.Add('Username: '+sl.Strings[10]);
                                                                                                                                                                                DebugOut.Lines.Add('Old Password: '+ tp1.Pass);
                                                                                                                                                                                tp1.Pass := sl.Strings[6];
                                                                                                                                                                                DebugOut.Lines.Add('New Password: '+sl.Strings[6]);
                                                                                                                                                                                DebugOut.Lines.Add('Password change was successful.');
                                                                                                                                                                        end;
                                                                                                                               			        	end;
                                                                                                                                                        end;
																	        end;
                                                                                                                                        end;
															        end;
													        	end;
													        end;
												        end;
										        	end;
										        end;
								        	end;
								        end;
						        	end;
						        end;
				        	end
                                                // Player Data End

                                                // Character Data Begin
				        	else if sl.Strings[2] = 'chara' then begin
							if sl.Count > 3 then begin
						        	if sl.Strings[3] = 'set' then begin
									if sl.Count > 4 then begin
								        	if sl.Strings[4] = 'zeny' then begin
											if sl.Count > 5 then begin
										        	if sl.Strings[5] = '=' then begin
													if sl.Count > 6 then begin
														if sl.Count > 7 then begin
													        	if sl.Strings[7] = 'where' then begin
																if sl.Count > 8 then begin
															        	if sl.Strings[8] = 'charaname' then begin
																		if sl.Count > 9 then begin
																	        	if sl.Strings[9] = '=' then begin
																			        if sl.Count > 10 then begin
                                                                                                                                                                        counter := 11;
                                                                                                                                                                        while sl.Count > counter do begin
                                                                                                                                                                                sl.Strings[10] := sl.Strings[10] + ' ' + sl.Strings[counter];
                                                                                                                                                                                counter := counter + 1;
                                                                                                                                                                        end;

                                                                                                                                                                        if CharaName.IndexOf(sl.Strings[10]) = -1 then begin
                                                                                                                                                                                DebugOut.Lines.Add('That character does not exist.');
                                                                                                                                                                        end
                                                                                                                                                                        else begin
                                                                                                                                                                                tc1 := CharaName.Objects[CharaName.IndexOf(sl.Strings[10])] as TChara;
                                                                                                                                                                                DebugOut.Lines.Add('Character Name: ' + sl.Strings[10]);
                                                                                                                                                                                DebugOut.Lines.Add('Total Zeny: ' + inttostr(tc1.Zeny));

                                                                                                                                                                                if (copy(sl.Strings[6],1,1) = '+') or (copy(sl.Strings[6],1,1) = '-') then begin
                                                                                                                                                                                        if tc1.Zeny + Cardinal(strtoint(sl.Strings[6])) < 0 then begin
                                                                                                                                                                                                DebugOut.Lines.Add('Not enough Zeny. Zeny command was un-successful.');
                                                                                                                                                                                        end else begin
                                                                                                                                                                                                tc1.Zeny := tc1.Zeny + Cardinal(strtoint(sl.Strings[6]));
                                                                                                                                                                                                DebugOut.Lines.Add('Zeny command was successful.');
                                                                                                                                                                                                DebugOut.Lines.Add('Updated Total: ' + inttostr(tc1.Zeny));
                                                                                                                                                                                        end;
                                                                                                                                                                                end else begin
                                                                                                                                                                                        tc1.Zeny := strtoint(sl.Strings[6]);
                                                                                                                                                                                        DebugOut.Lines.Add('Zeny command was successful.');
                                                                                                                                                                                        DebugOut.Lines.Add('Updated Total: ' + inttostr(tc1.Zeny));
                                                                                                                                                                                end;

                                                                                                                                                                                if tc1.Login = 2 then begin
                                                                                                                                                                                                      SendCStat1(tc1, 1, $0014, tc1.Zeny);
                                                                                                                                                                                end;
                                                                                                                                                                        end;
                                                                                                                               			        	end;
                                                                                                                                                        end;
																	        end;
															        	end;
															        end;
													        	end;
													        end;
												        end;
										        	end;
										        end;
								        	end;

								        	if sl.Strings[4] = 'location' then begin
											if sl.Count > 5 then begin
										        	if sl.Strings[5] = '=' then begin
													if sl.Count > 6 then begin
														if sl.Count > 7 then begin
                                                                                                                        if sl.Count > 8 then begin
                                                                                                                                if sl.Count > 9 then begin
                													        	if sl.Strings[9] = 'where' then begin
                																if sl.Count > 10 then begin
		                													        	if sl.Strings[10] = 'charaname' then begin
				                														if sl.Count > 11 then begin
						                											        	if sl.Strings[11] = '=' then begin
								                											        if sl.Count > 12 then begin
                                                                                                                                                                                        counter := 13;
                                                                                                                                                                                        while sl.Count > counter do begin
                                                                                                                                                                                                sl.Strings[12] := sl.Strings[12] + ' ' + sl.Strings[counter];
                                                                                                                                                                                                counter := counter + 1;
                                                                                                                                                                                        end;

                                                                                                                                                                                        if CharaName.IndexOf(sl.Strings[12]) = -1 then begin
                                                                                                                                                                                                DebugOut.Lines.Add('That character does not exist.');
                                                                                                                                                                                        end else begin

                                                                                                                                                                                                tc1 := CharaName.Objects[CharaName.IndexOf(sl.Strings[12])] as TChara;

                                                                                                                                                                                                if MapList.IndexOf(sl.Strings[6]) <> -1 then begin
                                                                                                                                                                                                        ta := MapList.Objects[MapList.IndexOf(sl.Strings[6])] as TMapList;
                                                                                                                                                                                                        if (strtoint(sl.Strings[7]) >= 0) and (strtoint(sl.Strings[7]) < ta.Size.X) and (strtoint(sl.Strings[8]) >= 0) and (strtoint(sl.Strings[8]) < ta.Size.Y) then begin
                                                                                                                                                                                                                if tc1.Login = 2 then begin
                                                                                                                                                                                                                        // User is online
                                                                                                                                                                                                                        if (tc1.Option and 64 = 0) then SendCLeave(tc1, 2);
                                                                                                                                                                                                                        MapMove(tc1.Socket, sl.Strings[6], Point(strtoint(sl.Strings[7]),strtoint(sl.Strings[8])));
                                                                                                                                                                                                                        tc1.Map := sl.Strings[6];
                                                                                                                                                                                                                        tc1.Point.X := strtoint(sl.Strings[7]);
                                                                                                                                                                                                                        tc1.Point.Y := strtoint(sl.Strings[8]);
                                                                                                                                                                                                                end else begin
                                                                                                                                                                                                                        // User is not online
                                                                                                                                                                                                                        tc1.Map := sl.Strings[6];
                                                                                                                                                                                                                        tc1.Point.X := strtoint(sl.Strings[7]);
                                                                                                                                                                                                                        tc1.Point.Y := strtoint(sl.Strings[8]);
                                                                                                                                                                                                                end;
                                                                                                                                                                                                                DebugOut.Lines.Add(tc1.Name + ' was moved successfully to ' + sl.Strings[6] + ' ' + sl.Strings[7] + ' ' + sl.Strings[8] + '.');
                                                                                                                                                                                                        end else begin
                                                                                                                                                                                                                DebugOut.Lines.Add(tc1.Name + ' was not moved. Bad Map Coordinates.');
                                                                                                                                                                                                        end;
                                                                                                                                                                                                end else begin
                                                                                                                                                                                                        DebugOut.Lines.Add(tc1.Name + ' was not moved. Bad Map Name.');
                                                                                                                                                                                                end;
                                                                                                                                                                                        end;
                                                                                                                                                                                end;
                                                                                                                                                                        end;
                                                                                                                               			        	end;
                                                                                                                                                        end;
																	        end;
															        	end;
															        end;
													        	end;
													        end;
												        end;
										        	end;
										        end;
								        	end;

								        	{if sl.Strings[4] = 'item' then begin
											if sl.Count > 5 then begin
										        	if sl.Strings[5] = '=' then begin
													if sl.Count > 6 then begin
														if sl.Count > 7 then begin
													        	if sl.Strings[7] = 'where' then begin
																if sl.Count > 8 then begin
															        	if sl.Strings[8] = 'charaname' then begin
																		if sl.Count > 9 then begin
																	        	if sl.Strings[9] = '=' then begin
																			        if sl.Count > 10 then begin
                                                                                                                                                                        counter := 11;
                                                                                                                                                                        while sl.Count > counter do begin
                                                                                                                                                                                sl.Strings[10] := sl.Strings[10] + ' ' + sl.Strings[counter];
                                                                                                                                                                                counter := counter + 1;
                                                                                                                                                                        end;

                                                                                                                                                                        if CharaName.IndexOf(sl.Strings[10]) = -1 then begin
                                                                                                                                                                                DebugOut.Lines.Add('That character does not exist.');
                                                                                                                                                                        end
                                                                                                                                                                        else begin
                                                                                                                                                                                tc1 := CharaName.Objects[CharaName.IndexOf(sl.Strings[10])] as TChara;
                                                                                                                                                                                DebugOut.Lines.Add('Character Name: ' + sl.Strings[10]);
                                                                                                                                                                                //DebugOut.Lines.Add('Total Zeny: ' + inttostr(tc1.Zeny));

                                                                                                                                                                                if (copy(sl.Strings[7],1,1) = '+') or (copy(sl.Strings[7],1,1) = '-') then begin
                                                                                                                                                                                        if tc1.Item[sl.Strings[6]].Amount + strtoint(sl.Strings[7]) < 0 then begin
                                                                                                                                                                                                DebugOut.Lines.Add('Not enough quantity. Item command was un-successful.');
                                                                                                                                                                                        end else begin
                                                                                                                                                                                                tc1.Item[sl.Strings[6]
                                                                                                                                                                                                tc1.Zeny := tc1.Zeny + strtoint(sl.Strings[6]);
                                                                                                                                                                                                DebugOut.Lines.Add('Zeny command was successful.');
                                                                                                                                                                                                DebugOut.Lines.Add('Updated Total: ' + inttostr(tc1.Zeny));
                                                                                                                                                                                        end;
                                                                                                                                                                                end else begin
                                                                                                                                                                                        tc1.Zeny := strtoint(sl.Strings[6]);
                                                                                                                                                                                        DebugOut.Lines.Add('Zeny command was successful.');
                                                                                                                                                                                        DebugOut.Lines.Add('Updated Total: ' + inttostr(tc1.Zeny));
                                                                                                                                                                                end;

                                                                                                                                                                                if tc1.Login = 2 then begin
                                                                                                                                                                                        WFIFOW(0, $00b1);
	        		                        																WFIFOW(2, $0014);
                                																			WFIFOL(4, tc1.Zeny);
			        																	                tc1.Socket.SendBuf(buf, 8);
                                                                                                                                                                                end;
                                                                                                                                                                        end;
                                                                                                                               			        	end;
                                                                                                                                                        end;
																	        end;
															        	end;
															        end;
													        	end;
													        end;
												        end;
										        	end;
										        end;
								        	end;}
								        end;
						        	end;
						        end;
				        	end;
                                                // Character Data End

				        end;
		        	end;

		        	if sl.Strings[1] = 'select' then begin
					if sl.Count > 2 then begin

                                                // Character Data Begin
				        	if sl.Strings[2] = 'items' then begin
							if sl.Count > 3 then begin
						        	if sl.Strings[3] = 'from' then begin
									if sl.Count > 4 then begin
								        	if sl.Strings[4] = 'chara' then begin
											if sl.Count > 5 then begin
										        	if sl.Strings[5] = 'where' then begin
													if sl.Count > 6 then begin
                                                                                                                if sl.Strings[6] = 'charaname' then begin
														        if sl.Count > 7 then begin
													        	        if sl.Strings[7] = '=' then begin
																        if sl.Count > 8 then begin
                                                                                                                                                counter := 9;
                                                                                                                                                while sl.Count > counter do begin
                                                                                                                                                        sl.Strings[8] := sl.Strings[8] + ' ' + sl.Strings[counter];
                                                                                                                                                        counter := counter + 1;
                                                                                                                                                end;

                                                                                                                                                if CharaName.IndexOf(sl.Strings[8]) = -1 then begin
                                                                                                                                                        DebugOut.Lines.Add('That character does not exist.');
                                                                                                                                                end
                                                                                                                                                else begin
                                                                                                                                                        tc1 := CharaName.Objects[CharaName.IndexOf(sl.Strings[8])] as TChara;
                                                                                                                                                        DebugOut.Lines.Add('Character Name: ' + sl.Strings[8]);
                                                                                                                                                        i := 0;
                                                                                                                                			for j := 1 to 100 do begin
                                                                                                                                				if tc1.Item[j].ID <> 0 then begin
                                                                                                                                                                        DebugOut.Lines.Add('Call Number: '+inttostr(j)+', ID: '+inttostr(tc1.Item[j].ID)+', Quantity: '+inttostr(tc1.Item[j].Amount));
                                                                                                                                					{sl.Add(IntToStr(tc.Item[j].ID));
                                                                                                                                					sl.Add(IntToStr(tc.Item[j].Amount));
                                                                                                                                					sl.Add(IntToStr(tc.Item[j].Equip));
                                                                                                                                					sl.Add(IntToStr(tc.Item[j].Identify));
                                                                                                                                					sl.Add(IntToStr(tc.Item[j].Refine));
                                                                                                                                					sl.Add(IntToStr(tc.Item[j].Attr));
                                                                                                                                					sl.Add(IntToStr(tc.Item[j].Card[0]));
                                                                                                                                					sl.Add(IntToStr(tc.Item[j].Card[1]));
                                                                                                                                					sl.Add(IntToStr(tc.Item[j].Card[2]));
                                                                                                                                					sl.Add(IntToStr(tc.Item[j].Card[3]));}
                                                                                                                                					Inc(i);
                                                                                                                                				end;
                                                                                                                                			end;
                                                                                                                                                        DebugOut.Lines.Add('Total Items: ' + inttostr(i));
																	        end;
															        	end;
															        end;
													        	end;
													        end;
												        end;
										        	end;
										        end;
								        	end;
								        end;
						        	end;
						        end;
				        	end;
                                                // Character Data End

				        end;
		        	end;
		        end;
                end

                else if str = '-' then begin
                // Relocates on or off-line player
                // Syntax: -move chara_name map_name x_coord y_coord

                end;

ExitParse:

                sl.free();
        end

        else begin
        // Sends GM Messages via Server Console

                str := edit1.text;

                //RFIFOW(2, w);
        	//str := RFIFOS(4, w - 4);

                w := 200;
        	WFIFOW(0, $009a);
	        WFIFOW(2, w);
	        WFIFOS(4, str, w);
        	//Socket.SendBuf(buf, w);

                for k := 0 to CharaName.Count - 1 do begin
                        tc1 := CharaName.Objects[k] as TChara;
		        if tc1.Login = 2 then tc1.Socket.SendBuf(buf, w);
                end;

                DebugOut.Lines.Add('Server: ' + str);
        end;

        edit1.Clear;

end;

procedure TfrmMain.Edit1KeyPress(Sender: TObject; var Key: Char);

begin

        if Key = #13 then begin
                button1.Click;
        end;

end;

procedure TfrmMain.cmdMinTray(Sender: TObject);
  begin
    //Add Icon to System Tray
                TrayIcon.cbSize := SizeOf(TrayIcon);
                TrayIcon.Wnd := Self.Handle;
                TrayIcon.uID := 0;
                TrayIcon.uFlags := NIF_ICON or NIF_TIP or NIF_MESSAGE;
                TrayIcon.uCallbackMessage := WM_NOTIFYICON;
                TrayIcon.hIcon := Application.Icon.Handle;
                TrayIcon.szTip := 'Fusion';
                Shell_notifyIcon(NIM_ADD, @TrayIcon);
                frmMain.Visible := false;
                Application.Minimize;
                ShowWindow(Application.Handle, SW_HIDE);
                SetWindowLong(Application.Handle, GWL_EXSTYLE,
                GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW );
                //Sets Windows Extended Styles WS_EX_TOOLWINDOW to true
                // (Don't ToolWindows don't show in taskbar by default)

end;

procedure TfrmMain.CMClickIcon(var msg: TMessage);
begin
  if msg.lparam = WM_LBUTTONDBLCLK then begin
        frmMain.Visible := true;
        Application.BringToFront;
        ShowWindow(Application.Handle, SW_SHOWNORMAL);
        SetWindowLong(Application.Handle, GWL_EXSTYLE,WS_EX_APPWINDOW);
        Shell_notifyIcon(NIM_DELETE, @TrayIcon);
  end;
end;

procedure TfrmMain.BackupTimerTimer(Sender: TObject);
var
    zfile :TZip;
    fileslist :TStringList;
    filename :string;
begin

    DateSeparator      := '-';
    TimeSeparator      := '-';
    ShortDateFormat    := 'yyyy/mm/dd';
    LongTimeFormat    := 'hh:mm:ss';

    filename := datetostr(date) + ' - ' +timetostr(time);

    CreateDir('backup');
    zfile := tzip.create(self);
    zfile.Filename := AppPath + 'backup\' + filename + '.zip';

    fileslist := tstringlist.Create;
    fileslist.Add(AppPath + 'chara.txt');
    fileslist.Add(AppPath + 'gcastle.txt');
    fileslist.Add(AppPath + 'guild.txt');
    fileslist.Add(AppPath + 'party.txt');
    fileslist.Add(AppPath + 'pet.txt');
    fileslist.Add(AppPath + 'player.txt');

    zfile.FileSpecList := fileslist;
    zfile.Add;
    zfile.Free;

    fileslist.Free;

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
  xy, vpoint: TPoint;
  dx, dy: integer;
  tc1: TChara;
  ts1: TMob;
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

//    end;

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

      //if (tv.pcnt <> 0) then begin DebugOut.Lines.Add('Move');
        tv.pcnt := 0;
        //UpdateLivingLocation(tm, tv);
        //SendCMove(tc.Socket, (tv as TChara), xy, tv.Point);
        //SendBCmd(tm, tv.Point, 60, tc);
      //end else begin DebugOut.Lines.Add('Stat');
      //DebugOut.Lines.Add(Format('xy %d %d tv %d %d',[xy.X, xy.Y, tv.Point.X, tv.Point.Y]));
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


end.
