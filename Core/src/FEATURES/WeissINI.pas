unit WeissINI;

interface

uses
	Common, IniFiles, SysUtils, WinSock;

	procedure weiss_ini_save();

implementation

uses
	Main;

	procedure weiss_ini_save();
    var
    	ini : TIniFile;
    begin
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
        ini.WriteString('Fusion', 'Option_PVP_Steal', BoolToStr(Option_PVP_Steal));
        ini.WriteString('Fusion', 'Option_PartyShare_Level', IntToStr(Option_PartyShare_Level));
        ini.WriteString('Fusion', 'Option_PVP_XPLoss', BoolToStr(Option_PVP_XPLoss));
        ini.WriteString('Fusion', 'Option_MaxUsers', IntToStr(Option_MaxUsers));
        ini.WriteString('Fusion', 'Option_AutoSave', IntToStr(Option_AutoSave));
        ini.WriteString('Fusion', 'Option_AutoBackup', IntToStr(Option_AutoBackup));
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
        
        ini.Free;
    end;

end.
 