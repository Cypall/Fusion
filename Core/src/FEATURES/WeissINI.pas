unit WeissINI;

interface

uses
    {Windows VCL}
    {$IFDEF MSWINDOWS}
    WinSock,
    {$ENDIF}
    {Common}
    IniFiles, SysUtils,
    {Fusion}
	Common;

	procedure weiss_ini_save();

implementation

uses
	Main;

	procedure weiss_ini_save();
    var
    	ini : TIniFile;
    begin
        ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
        ini.WriteString('Version', 'VER', '1.212 S - R.E.E.D Beta 4 Release');
        ini.WriteString('Server', 'WAN_IP', WAN_IP);
        ini.WriteString('Server', 'Name', ServerName);

        //This is the start of npc id's. commented out because it's not necessary to mod
        //ini.WriteString('Server', 'NPCID', IntToStr(DefaultNPCID));

        ini.WriteString('Server', 'sv1port', IntToStr(sv1port));
        ini.WriteString('Server', 'sv2port', IntToStr(sv2port));
        ini.WriteString('Server', 'sv3port', IntToStr(sv3port));
        ini.WriteString('Server', 'wacport', IntToStr(wacport));
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
        ini.WriteString('Server', 'DisableAdv2ndDye', BoolToStr(DisableAdv2ndDye, true));
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

        // Fusion INI Lines
        ini.WriteString('Fusion', 'Option_PVP', BoolToStr(Option_PVP));
        ini.WriteString('Fusion', 'Option_PVP_Steal', BoolToStr(Option_PVP_Steal));
        ini.WriteString('Fusion', 'Option_PartyShare_Level', IntToStr(Option_PartyShare_Level));
        ini.WriteString('Fusion', 'Option_PVP_XPLoss', BoolToStr(Option_PVP_XPLoss));
        ini.WriteString('Fusion', 'Option_MaxUsers', IntToStr(Option_MaxUsers));
        ini.WriteString('Fusion', 'Option_AutoSave', IntToStr(Option_AutoSave));
        ini.WriteString('Fusion', 'Option_AutoBackup', IntToStr(Option_AutoBackup));
        ini.WriteString('Fusion', 'Option_DNS_Update', IntToStr(Option_DNS_Update));
        ini.WriteString('Fusion', 'Option_WelcomeMsg', BoolToStr(Option_WelcomeMsg));
        ini.WriteString('Fusion', 'Option_MOTD', BoolToStr(Option_MOTD));
        ini.WriteString('Fusion', 'Option_MOTD_Athena', BoolToStr(Option_MOTD_Athena));
        ini.WriteString('Fusion', 'Option_MOTD_File', Option_MOTD_File);
        ini.WriteString('Fusion', 'Option_GM_Logs', BoolToStr(Option_GM_Logs));
        ini.WriteString('Fusion', 'Option_Username_MF', BoolToStr(Option_Username_MF));
        ini.WriteString('Fusion', 'Option_Back_Color', Option_Back_Color);
        ini.WriteString('Fusion', 'Option_Font_Color', Option_Font_Color);
        ini.WriteString('Fusion', 'Option_Font_Size', inttostr(Option_Font_Size));
        ini.WriteString('Fusion', 'Option_Font_Face', Option_Font_Face);
        ini.WriteString('Fusion', 'Option_Font_Style', Option_Font_Style);
        ini.WriteString('Fusion', 'Option_Pet_Capture_Rate', InttoStr(Option_Pet_Capture_Rate));
        ini.WriteString('Fusion', 'Option_Mob_Spawn_Rate', InttoStr(Option_Mob_Spawn_Rate));
        ini.WriteString('Fusion', 'Option_Minimize_Tray', BoolToStr(Option_Minimize_Tray));
        ini.WriteString('Fusion', 'Option_Enable_WAC', BoolToStr(Option_Enable_WAC));
        ini.WriteString('Fusion', 'Option_Enable_ISCS', BoolToStr(Option_Enable_ISCS));
        ini.WriteString('Fusion', 'Option_Use_UPnP', BoolToStr(Option_Use_UPnP));
        ini.WriteString('Fusion', 'Option_Packet_Out', BoolToStr(Option_Packet_Out));
        ini.WriteString('Fusion', 'Option_FireWall_Cap', IntToStr(Option_FireWall_Cap));
        ini.WriteString('Fusion', 'Option_IceWall_Cap', IntToStr(Option_IceWall_Cap));
        // Fusion INI Lines

        // MySQL Server Lines
        ini.WriteString('MySQL Server', 'Option_MySQL', BoolToStr(UseSQL));
        ini.WriteString('MySQL Server', 'MySQL_Address', DbHost);
        ini.WriteString('MySQL Server', 'MySQL_Username', DbUser);
        ini.WriteString('MySQL Server', 'MySQL_Password', DbPass);
        ini.WriteString('MySQL Server', 'MySQL_Database', DbName);
        // MySQL Server Lines

        {ChrstphrR 2004/05/09 - Debug section added to INI file
        Controls options that allow/supress when errors occur - these features
        will be useful to Devs in Core/DB/Scripts, and people modifying both
        Database and Script files for testing.}
        ini.WriteString('Debug', 'ShowDebugErrors', BoolToStr(ShowDebugErrors));

        //ini.WriteString('Toys', 'MapUnloadTime', IntToStr(MapUnloadTime));

        ini.Free;
    end;

end.
