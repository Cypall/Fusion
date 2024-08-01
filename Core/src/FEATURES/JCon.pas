unit JCon;

interface

uses
    {$IFDEF MSWINDOWS}
	//WinSock,
    WSocket,
    {$ENDIF}
    {Shared}
    SysUtils, StrUtils,
    {Fusion}
	Common, Database, WeissINI, Globals, Game_Master, PlayerData, WAC, REED_DELETE, REED_SAVE_ACCOUNTS, REED_SAVE_CHARACTERS;

	procedure JCon_Accounts_Load();
    procedure JCon_Accounts_Populate(aType : Integer);
    procedure JCon_Accounts_Clear();
    procedure JCon_Accounts_Save();
    procedure JCon_Accounts_Delete();
    procedure JCon_Accounts_Chara_Delete(str : String);

    procedure JCon_Characters_Load();
    procedure JCon_Characters_Populate();
    procedure JCon_Characters_Save();
    procedure JCon_Characters_Online();
    procedure JCon_Chara_Online_Populate();
    procedure JCon_Chara_KickProcess(Ban : boolean=false);
    procedure JCon_Chara_Online_Rescue();
    procedure JCon_Chara_Online_PM();
    procedure JCon_Chara_Inv_Load();
    procedure JCon_Chara_Inv_Populate();
    procedure JCon_Chara_Inv_Save();
    procedure JCon_Chara_Cart_Load();
    procedure JCon_Chara_Store_Load();
    procedure JCon_Chara_Skill_Load(HideNull : Boolean);
    procedure JCon_Chara_Skill_Populate();
    procedure JCon_Chara_Skill_Save();
    procedure JCon_Chara_Flag_Load();
    procedure JCon_Chara_Flag_Delete();
    procedure JCon_Chara_Flag_Populate();
    procedure JCon_Chara_Flag_Save();

    procedure JCon_INI_Server_Load();
    procedure JCon_INI_Server_Save();

    procedure JCon_INI_Game_Load();
    procedure JCon_INI_Game_Save();


implementation

uses
	Main;

	procedure JCon_Accounts_Load();
    var
		i : Integer;
    	AccountItem : TPlayer;
	begin

		frmMain.ListBox1.Clear;
        frmMain.ListBox9.Clear;

		for i := 0 to (PlayerName.Count - 1) do begin
			AccountItem := PlayerName.Objects[i] as TPlayer;
	        frmMain.listbox1.Items.AddObject(PlayerName.Strings[i], AccountItem);
    	    frmMain.listbox1.Sorted := True;
            AccountItem := Player.Objects[i] as TPlayer;
            frmMain.ListBox9.Items.AddObject(IntToStr(AccountItem.ID), AccountItem);
            frmMain.ListBox9.Sorted := True;
	    end;
    end;


    procedure JCon_Accounts_Populate(aType : Integer);
	var
    	AccountItem : TPlayer;
	begin
    	if (frmMain.listbox1.ItemIndex = -1) then Exit;

		if aType = 0 then
            AccountItem := frmMain.listbox1.Items.Objects[frmMain.listbox1.ItemIndex] as TPlayer
        else
            AccountItem := frmMain.listbox9.Items.Objects[frmMain.listbox9.ItemIndex] as TPlayer;

        frmMain.ListBox9.ItemIndex := Player.IndexOf(AccountItem.ID);
        frmMain.ListBox1.ItemIndex := PlayerName.IndexOf(AccountItem.Name);

	    frmMain.Label136.Caption := IntToStr(AccountItem.ID);
    	frmMain.Edit3.Text := AccountItem.Name;
	    frmMain.Edit4.Text := AccountItem.Pass;
        frmMain.ComboBox15.ItemIndex := -1;
        frmMain.ComboBox15.ItemIndex := AccountItem.Gender;
	    frmMain.Edit6.Text := AccountItem.Mail;
        frmMain.ComboBox18.ItemIndex := -1;
        //frmMain.ComboBox18.ItemIndex := AccountItem.Banned;
        frmMain.ComboBox18.ItemIndex := abs(StrToInt(BoolToStr(AccountItem.Banned)));

        if AccountItem.CName[0] <> '' then frmMain.Button7.Caption := AccountItem.CName[0]
        else frmMain.Button7.Caption := '';
        if AccountItem.CName[1] <> '' then frmMain.Button8.Caption := AccountItem.CName[1]
        else frmMain.Button8.Caption := '';
        if AccountItem.CName[2] <> '' then frmMain.Button9.Caption := AccountItem.CName[2]
        else frmMain.Button9.Caption := '';
        if AccountItem.CName[3] <> '' then frmMain.Button10.Caption := AccountItem.CName[3]
        else frmMain.Button10.Caption := '';
        if AccountItem.CName[4] <> '' then frmMain.Button11.Caption := AccountItem.CName[4]
        else frmMain.Button11.Caption := '';
        if AccountItem.CName[5] <> '' then frmMain.Button12.Caption := AccountItem.CName[5]
        else frmMain.Button12.Caption := '';
        if AccountItem.CName[6] <> '' then frmMain.Button13.Caption := AccountItem.CName[6]
        else frmMain.Button13.Caption := '';
        if AccountItem.CName[7] <> '' then frmMain.Button14.Caption := AccountItem.CName[7]
        else frmMain.Button14.Caption := '';
        if AccountItem.CName[8] <> '' then frmMain.Button15.Caption := AccountItem.CName[8]
        else frmMain.Button15.Caption := '';

        frmMain.Edit53.Text := IntToStr(AccountItem.AccessLevel);
    end;


    procedure JCon_Accounts_Clear();
    begin
        frmMain.Label136.Caption := '';
    	frmMain.Edit3.Clear;
	    frmMain.Edit4.Clear;
    	frmMain.ComboBox15.Text := '';
	    frmMain.Edit6.Clear;
    	frmMain.ComboBox18.Text := '';
        frmMain.Button7.Caption := '';
        frmMain.Button8.Caption := '';
        frmMain.Button9.Caption := '';
        frmMain.Button10.Caption := '';
        frmMain.Button11.Caption := '';
        frmMain.Button12.Caption := '';
        frmMain.Button13.Caption := '';
        frmMain.Button14.Caption := '';
        frmMain.Button15.Caption := '';
        frmMain.Edit53.Clear;
    end;


    procedure JCon_Accounts_Save();
	var
	    AccountItem : TPlayer;
    	tc : TChara;
	    i : Integer;
	begin
    	if (frmMain.Edit3.Text = '') then begin
        	Exit;
        end else if PlayerName.IndexOf(frmMain.Edit3.Text) <> -1 then begin
			AccountItem := PlayerName.Objects[PlayerName.IndexOf(frmMain.Edit3.Text)] as TPlayer;

	    	for i := 0 to 8 do begin
                if not assigned(AccountItem.CData[i]) then Continue;

    	    	tc := AccountItem.CData[i];
        	    if assigned(tc) then begin
	        	    if assigned(tc.Socket) then begin
    	        		if tc.Login <> 0 then tc.Socket.Close;
	                    tc.Socket := nil;
    	            end;
        	    end;
	        end;

		    //AccountItem.ID := StrToInt(frmMain.Edit2.Text);
        	AccountItem.Name := frmMain.Edit3.Text;
	        AccountItem.Pass := frmMain.Edit4.Text;
    	    AccountItem.Gender := frmMain.ComboBox15.ItemIndex;
        	AccountItem.Mail := frmMain.Edit6.Text;
	        AccountItem.Banned := StrToBool(IntToStr(abs(frmMain.ComboBox18.ItemIndex)));
            AccountItem.AccessLevel := StrToInt(frmMain.Edit53.Text);
		    //DataSave(True);
            PD_Save_Accounts_Parse(True);
        end else begin
            create_account(frmMain.Edit3.Text, frmMain.Edit4.Text, frmMain.Edit6.Text, IntToStr(frmMain.ComboBox15.ItemIndex));
    	    frmMain.Button3.Click;
        end;

        JCon_Accounts_Load();
    end;

    procedure JCon_Accounts_Delete();
    var
    	tp : TPlayer;
        i, k : Integer;
    begin

    	for k := 0 to frmMain.ListBox1.Count - 1 do begin
        	if frmMain.ListBox1.Selected[k] then begin

            	tp := frmMain.listbox1.Items.Objects[k] as TPlayer;

                if (assigned(tp)) then begin
                    PD_Delete_Accounts(tp.ID);
		        end;
            end;
        end;

        JCon_Accounts_Clear();
        JCon_Accounts_Load();

    end;

    procedure JCon_Accounts_Chara_Delete(str : String);
    var
    	tc : TChara;
        tp : TPlayer;
        i : Integer;
    begin
        if (Charaname.IndexOf(str) = -1) then Exit;
    	tc := charaname.objects[charaname.indexof(str)] as TChara;

        tp := Player.Objects[Player.IndexOf(tc.ID)] as TPlayer;
        if (not assigned(tp)) then Exit;

        case tc.CharaNumber of
            0: frmMain.Button7.Caption := '';
            1: frmMain.Button8.Caption := '';
            2: frmMain.Button9.Caption := '';
            3: frmMain.Button10.Caption := '';
            4: frmMain.Button11.Caption := '';
            5: frmMain.Button12.Caption := '';
            6: frmMain.Button13.Caption := '';
            7: frmMain.Button14.Caption := '';
            8: frmMain.Button15.Caption := '';
        end;

        if assigned(tc.Socket) then begin
            if tc.Login <> 0 then begin
            	tc.Socket.Close;
            	tc.Socket := nil;
            end;
        end;

        PD_Delete_Character(tc.CID);
        tp.CName[tc.CharaNumber] := '';
        tp.CData[tc.CharaNumber] := nil;

        DataSave(True);
    end;


    procedure JCon_INI_Server_Load();
    begin
		frmMain.Edit17.Text := WAN_IP;
		frmMain.Edit18.Text := ServerName;
	    frmMain.Edit19.Text := IntToStr(DefaultNPCID);
    	frmMain.Edit20.Text := IntToStr(sv1port);
    	frmMain.Edit21.Text := IntToStr(sv2port);
	    frmMain.Edit22.Text := IntToStr(sv3port);
        frmMain.Edit5.Text := IntToStr(wacport);

        frmMain.ComboBox1.ItemIndex := abs(StrToInt(BoolToStr(UseSQL)));
        frmMain.Edit24.Text := DBHost;
        frmMain.Edit23.Text := DBUser;
        frmMain.Edit25.Text := DBPass;
        frmMain.Edit26.Text := DBName;

        frmMain.ComboBox2.ItemIndex := abs(StrToInt(BoolToStr(AutoStart)));
        frmMain.Edit29.Text := IntToStr(Option_MaxUsers);
        frmMain.ComboBox3.ItemIndex := abs(StrToInt(BoolToStr(Option_Username_MF)));

        frmMain.Edit31.Text := IntToStr(Option_AutoSave div 60);
        frmMain.Edit30.Text := IntToStr(Option_AutoBackup div 60);
        frmMain.ComboBox4.ItemIndex := abs(StrToInt(BoolToStr(Option_GM_Logs)));

        frmMain.ComboBox5.ItemIndex := abs(StrToInt(BoolToStr(ShowDebugErrors)));
        frmMain.ComboBox6.ItemIndex := abs(StrToInt(BoolToStr(WarpDebugFlag)));
        frmMain.ComboBox7.ItemIndex := abs(StrToInt(BoolToStr(Timer)));

        frmMain.ComboBox8.ItemIndex := Priority;
        frmMain.ComboBox17.ItemIndex := abs(StrToInt(BoolToStr(EnableLowerClassDyes)));

        frmMain.ComboBox21.ItemIndex := abs(StrToInt(BoolToStr(Option_Use_UPnP)));
        frmMain.ComboBox22.ItemIndex := abs(StrToInt(BoolToStr(Option_Enable_WAC)));
    end;


    procedure JCon_INI_Server_Save();
    var
		i : Integer;
	begin
        WAN_IP := frmMain.Edit17.Text;
        {$IFDEF MSWINDOWS}
		    WAN_ADDR := cardinal(wsocket_inet_addr(PChar(WAN_IP)));
        {$ENDIF}
        //WAN_ADDR := cardinal(inet_addr(PChar(WAN_IP)));
		ServerName := frmMain.Edit18.Text;
    	DefaultNPCID := StrToInt(frmMain.Edit19.Text);

	    if (frmMain.sv1.port <> StrToInt(frmMain.Edit20.Text)) or (frmMain.sv2.port <> StrToInt(frmMain.Edit21.Text)) or (frmMain.sv3.port <> StrToInt(frmMain.Edit22.Text)) then begin

		    for i := 0 to frmMain.sv1.Socket.ActiveConnections - 1 do
    			frmMain.sv1.Socket.Disconnect(i);
		    for i := 0 to frmMain.sv2.Socket.ActiveConnections - 1 do
    			frmMain.sv2.Socket.Disconnect(i);
	    	for i := 0 to frmMain.sv3.Socket.ActiveConnections - 1 do
    			frmMain.sv3.Socket.Disconnect(i);

		    frmMain.sv1.Active := False;
    		frmMain.sv2.Active := False;
	    	frmMain.sv3.Active := False;

            if (Option_Use_UPnP) then begin
                destroy_upnp(sv1port);
                destroy_upnp(sv2port);
                destroy_upnp(sv3port);
            end;

            if (frmMain.Edit20.Text <> frmMain.Edit21.Text) and (frmMain.Edit20.Text <> frmMain.Edit22.Text) and (frmMain.Edit21.Text <> frmMain.Edit22.Text) then begin
                sv1port := StrToInt(frmMain.Edit20.Text);
        		sv2port := StrToInt(frmMain.Edit21.Text);
	    	    sv3port := StrToInt(frmMain.Edit22.Text);
            end;

            if (Option_Use_UPnP) then begin
                create_upnp(sv1port, 'Fusion Login Zone');
                create_upnp(sv2port, 'Fusion Character Zone');
                create_upnp(sv3port, 'Fusion Game Zone');
            end;

		    frmMain.sv1.port := sv1port;
		    frmMain.sv2.port := sv2port;
	    	frmMain.sv3.port := sv3port;

		    frmMain.sv1.Active := True;
    		frmMain.sv2.Active := True;
	    	frmMain.sv3.Active := True;
	    end;

        if (frmMain.Edit5.Text <> frmMain.Edit20.Text) and (frmMain.Edit5.Text <> frmMain.Edit21.Text) and (frmMain.Edit5.Text <> frmMain.Edit22.Text) then begin
            if not ( (wacport) = (StrToInt(frmMain.Edit5.Text)) ) then begin
                if (Option_Use_UPnP) and (Option_Enable_WAC) then destroy_upnp(wacport);
                wacport := StrToInt(frmMain.Edit5.Text);
                if (Option_Use_UPnP) and (Option_Enable_WAC) then create_upnp(wacport, 'Fusion Web Account Creator');
            end;
        end;

        if not ( (Option_Use_UPnP) = (StrToBool(IntToStr(abs(frmMain.ComboBox21.ItemIndex)))) ) then begin
            Option_Use_UPnP := StrToBool(IntToStr(abs(frmMain.ComboBox21.ItemIndex)));
            if (Option_Use_UPnP) then begin
                create_upnp(sv1port, 'Fusion Login Zone');
                create_upnp(sv2port, 'Fusion Character Zone');
                create_upnp(sv3port, 'Fusion Game Zone');
            end else begin
                destroy_upnp(sv1port);
                destroy_upnp(sv2port);
                destroy_upnp(sv3port);
                destroy_upnp(wacport);
            end;
        end;

        if (Option_Enable_WAC) then destroy_wac(true);
        Option_Enable_WAC := StrToBool(IntToStr(abs(frmMain.ComboBox22.ItemIndex)));
        if (Option_Enable_WAC) then create_wac();

        UseSQL := StrToBool(IntToStr(abs(frmMain.ComboBox1.ItemIndex)));
        DBHost := frmMain.Edit24.Text;
        DBUser := frmMain.Edit23.Text;
        DBPass := frmMain.Edit25.Text;
        DBName := frmMain.Edit26.Text;

        AutoStart := StrToBool(IntToStr(abs(frmMain.ComboBox2.ItemIndex)));
        Option_MaxUsers := StrToInt(frmMain.Edit29.Text);
        Option_Username_MF := StrToBool(IntToStr(abs(frmMain.ComboBox3.ItemIndex)));

        Option_AutoSave := 60 * StrToInt(frmMain.Edit31.Text);
        Option_AutoBackup := 60 * StrToInt(frmMain.Edit30.Text);
        Option_GM_Logs := StrToBool(IntToStr(abs(frmMain.ComboBox4.ItemIndex)));

        ShowDebugErrors := StrToBool(IntToStr(abs(frmMain.ComboBox5.ItemIndex)));
        WarpDebugFlag := StrToBool(IntToStr(abs(frmMain.ComboBox6.ItemIndex)));
        Timer := StrToBool(IntToStr(abs(frmMain.ComboBox7.ItemIndex)));

        Priority := frmMain.ComboBox8.ItemIndex;
        frmMain.PriorityUpdate(Priority);
        EnableLowerClassDyes := StrToBool(IntToStr(abs(frmMain.ComboBox17.ItemIndex)));

		weiss_ini_save();
    end;

    procedure JCon_INI_Game_Load();
    begin
    	try frmMain.Edit42.Text := IntToStr(BaseExpMultiplier); except end;
        try frmMain.Edit37.Text := IntToStr(JobExpMultiplier); except end;
        try frmMain.Edit38.Text := IntToStr(ItemDropMultiplier); except end;

        try frmMain.Edit39.Text := IntToStr(StealMultiplier); except end;
        try frmMain.Edit40.Text := IntToStr(Option_Pet_Capture_Rate); except end;

        try frmMain.ComboBox16.ItemIndex := abs(StrToInt(BoolToStr(DisableLevelLimit))); except end;
        try frmMain.ComboBox9.ItemIndex := abs(StrToInt(BoolToStr(DisableEquipLimit))); except end;
        try frmMain.ComboBox10.ItemIndex := abs(StrToInt(BoolToStr(EnablePetSkills))); except end;
        try frmMain.ComboBox11.ItemIndex := abs(StrToInt(BoolToStr(Option_PVP))); except end;
        try frmMain.ComboBox12.ItemIndex := abs(StrToInt(BoolToStr(Option_PVP_Steal))); except end;
        try frmMain.ComboBox13.ItemIndex := abs(StrToInt(BoolToStr(Option_PVP_XPLoss))); except end;

        try frmMain.Edit35.Text := IntToStr(DefaultZeny); except end;
        try frmMain.Edit43.Text := IntToStr(DefaultItem1); except end;
        try frmMain.Edit44.Text := IntToStr(DefaultItem2); except end;
        try frmMain.Edit27.Text := DefaultMap; except end;
        try frmMain.Edit28.Text := IntToStr(DefaultPoint_X); except end;
        try frmMain.Edit45.Text := IntToStr(DefaultPoint_Y); except end;

        try frmMain.Edit32.Text := IntToStr(DeathBaseLoss); except end;
        try frmMain.Edit33.Text := IntToStr(DeathJobLoss); except end;
        try frmMain.Edit34.Text := IntToStr(Option_PartyShare_Level); except end;
        try frmMain.ComboBox14.ItemIndex := abs(StrToInt(BoolToStr(DisableSkillLimit))); except end;

    end;

    procedure JCon_INI_Game_Save();
    begin
        try BaseExpMultiplier := StrToInt(frmMain.Edit42.Text); except end;
        try JobExpMultiplier := StrToInt(frmMain.Edit37.Text); except end;
        try ItemDropMultiplier := StrToInt(frmMain.Edit38.Text); except end;

        try StealMultiplier := StrToInt(frmMain.Edit39.Text); except end;
        try Option_Pet_Capture_Rate := StrToInt(frmMain.Edit40.Text); except end;

        try DisableLevelLimit := StrToBool(IntToStr(abs(frmMain.ComboBox16.ItemIndex))); except end;
        try DisableEquipLimit := StrToBool(IntToStr(abs(frmMain.ComboBox9.ItemIndex))); except end;
        try EnablePetSkills := StrToBool(IntToStr(abs(frmMain.ComboBox10.ItemIndex))); except end;
        try Option_PVP := StrToBool(IntToStr(abs(frmMain.ComboBox11.ItemIndex))); except end;
        try Option_PVP_Steal := StrToBool(IntToStr(abs(frmMain.ComboBox12.ItemIndex))); except end;
        try Option_PVP_XPLoss := StrToBool(IntToStr(abs(frmMain.ComboBox13.ItemIndex))); except end;

        try DefaultZeny := StrToInt(frmMain.Edit35.Text); except end;
        try DefaultItem1 := StrToInt(frmMain.Edit43.Text); except end;
        try DefaultItem2 := StrToInt(frmMain.Edit44.Text); except end;
        try DefaultMap := frmMain.Edit27.Text; except end;
        try DefaultPoint_X := StrToInt(frmMain.Edit28.Text); except end;
        try DefaultPoint_Y := StrToInt(frmMain.Edit45.Text); except end;

        try DeathBaseLoss := StrToInt(frmMain.Edit32.Text); except end;
        try DeathJobLoss := StrToInt(frmMain.Edit33.Text); except end;
        try Option_PartyShare_Level := StrToInt(frmMain.Edit34.Text); except end;
        try DisableSkillLimit := StrToBool(IntToStr(abs(frmMain.ComboBox14.ItemIndex))); except end;

		weiss_ini_save();
    end;


	procedure JCon_Characters_Load();
    var
		i : Integer;
    	tc : TChara;
	begin

		frmMain.ListBox2.Clear;

		for i := 0 to (CharaName.Count - 1) do begin
			tc := CharaName.Objects[i] as TChara;
	        frmMain.listbox2.Items.AddObject(CharaName.Strings[i], tc);
    	    frmMain.listbox2.Sorted := True;
	    end;
    end;


    procedure JCon_Characters_Populate();
	var
    	tc : TChara;

	begin
    	if (frmMain.listbox2.ItemIndex = -1) then Exit;

		tc := frmMain.listbox2.Items.Objects[frmMain.listbox2.ItemIndex] as TChara;
	    frmMain.Label134.Caption := tc.Name;
    	frmMain.Label135.Caption := IntToStr(tc.CID);
        if (tc.JID > LOWER_JOB_END) then frmMain.Edit10.Text := IntToStr(tc.JID - UPPER_JOB_BEGIN + LOWER_JOB_END)
        else frmMain.Edit10.Text := IntToStr(tc.JID);
        frmMain.Edit14.Text := IntToStr(tc.BaseLV);
        frmMain.Edit12.Text := IntToStr(tc.JobLV);
        frmMain.Edit15.Text := IntToStr(tc.BaseEXP);
        frmMain.Edit13.Text := IntToStr(tc.JobEXP);
        frmMain.Edit36.Text := IntToStr(tc.Zeny);

        frmMain.Edit41.Text := IntToStr(tc.Speed);
        frmMain.Edit16.Text := IntToStr(tc.SkillPoint);
        frmMain.Edit11.Text := IntToStr(tc.StatusPoint);
        frmMain.Edit49.Text := tc.SaveMap;
        frmMain.Edit50.Text := IntToStr(tc.SavePoint.X);
        frmMain.Edit51.Text := IntToStr(tc.SavePoint.Y);
        frmMain.Edit46.Text := IntToStr(tc.Hair);
        frmMain.Edit47.Text := IntToStr(tc.HairColor);
        frmMain.Edit48.Text := IntToStr(tc.ClothesColor);
        frmMain.Edit52.Text := tc.Map;
        frmMain.Edit57.Text := IntToStr(tc.Point.X);
        frmMain.Edit59.Text := IntToStr(tc.Point.Y);
        frmMain.Edit56.Text := IntToStr(tc.Stat1);
        frmMain.Edit55.Text := IntToStr(tc.Stat2);
        frmMain.Edit54.Text := IntToStr(tc.Option);
        frmMain.Edit67.Text := IntToStr(tc.Parambase[0]);
        frmMain.Edit66.Text := IntToStr(tc.Parambase[1]);
        frmMain.Edit65.Text := IntToStr(tc.Parambase[2]);
        frmMain.Edit63.Text := IntToStr(tc.Parambase[3]);
        frmMain.Edit64.Text := IntToStr(tc.Parambase[4]);
        frmMain.Edit61.Text := IntToStr(tc.Parambase[5]);
        frmMain.Label98.Caption := IntToStr(tc.HP);
        frmMain.Label99.Caption := IntToStr(tc.SP);
        frmMain.Label102.Caption := tc.PData.Name;
        frmMain.Edit68.Text := tc.MemoMap[0];
        frmMain.Edit62.Text := IntToStr(tc.MemoPoint[0].X);
        frmMain.Edit60.Text := IntToStr(tc.MemoPoint[0].Y);
        frmMain.Edit69.Text := tc.MemoMap[1];
        frmMain.Edit70.Text := IntToStr(tc.MemoPoint[1].X);
        frmMain.Edit71.Text := IntToStr(tc.MemoPoint[1].Y);
        frmMain.Edit74.Text := tc.MemoMap[2];
        frmMain.Edit73.Text := IntToStr(tc.MemoPoint[2].X);
        frmMain.Edit72.Text := IntToStr(tc.MemoPoint[2].Y);
        if tc.GuildID <> 0 then frmMain.Label105.Caption := tc.GuildName;
        if tc.PartyID <> 0 then frmMain.Label103.Caption := tc.PartyName;

    end;

    procedure JCon_Characters_Save();
    var
        tc : TChara;
	begin
    	if (frmMain.ListBox2.ItemIndex = -1) then begin
        	Exit;
        end else if CharaName.IndexOf(frmMain.Label134.Caption) <> -1 then begin
			tc := CharaName.Objects[CharaName.IndexOf(frmMain.Label134.Caption)] as TChara;

        if assigned(tc) then begin
            if assigned(tc.Socket) then begin
                if tc.Login <> 0 then tc.Socket.Close;
                    tc.Socket := nil;
                end;
            end;
        end;

        if StrToInt(frmMain.Edit10.Text) > LOWER_JOB_END then
            tc.JID := (StrToInt(frmMain.Edit10.Text) - LOWER_JOB_END + UPPER_JOB_BEGIN)
        else tc.JID := StrToInt(frmMain.Edit10.Text);
        tc.BaseLV := StrToInt(frmMain.Edit14.Text);
        tc.BaseEXP := StrToInt(frmMain.Edit15.Text);
        tc.StatusPoint := StrToInt(frmMain.Edit11.Text);
        tc.JobLV := StrToInt(frmMain.Edit12.Text);
        tc.JobEXP := StrToInt(frmMain.Edit13.Text);
        tc.SkillPoint := StrToInt(frmMain.Edit16.Text);

        if StrToInt64(frmMain.Edit36.Text) < 0 then tc.Zeny := 0
        else if StrToInt64(frmMain.Edit36.Text) > MAXINTEGER then tc.Zeny := MAXINTEGER
        else tc.Zeny := StrToInt(frmMain.Edit36.Text);

        tc.Stat1 := StrToInt(frmMain.Edit55.Text);
        tc.Stat2 := StrToInt(frmMain.Edit56.Text);
        tc.Option := StrToInt(frmMain.Edit54.Text);
        tc.Speed := StrToInt(frmMain.Edit41.Text);
        tc.Hair := StrToInt(frmMain.Edit46.Text);
        tc.HairColor := StrToInt(frmMain.Edit47.Text);
        tc.ClothesColor := StrToInt(frmMain.Edit48.Text);
        tc.ParamBase[0] := StrToInt(frmMain.Edit67.Text);
        tc.ParamBase[1] := StrToInt(frmMain.Edit66.Text);
        tc.ParamBase[2] := StrToInt(frmMain.Edit65.Text);
        tc.ParamBase[3] := StrToInt(frmMain.Edit63.Text);
        tc.ParamBase[4] := StrToInt(frmMain.Edit64.Text);
        tc.ParamBase[5] := StrToInt(frmMain.Edit61.Text);
        tc.Map := frmMain.Edit52.Text;
        tc.Point.X := StrToInt(frmMain.Edit57.Text);
        tc.Point.Y := StrToInt(frmMain.Edit59.Text);
        tc.SaveMap := frmMain.Edit49.Text;
        tc.SavePoint.X := StrToInt(frmMain.Edit50.Text);
        tc.SavePoint.Y := StrToInt(frmMain.Edit51.Text);
        tc.MemoMap[0] :=  frmMain.Edit68.Text;
        tc.MemoPoint[0].X := StrToInt(frmMain.Edit62.Text);
        tc.MemoPoint[0].Y := StrToInt(frmMain.Edit60.Text);
        tc.MemoMap[1] := frmMain.Edit69.Text;
        tc.MemoPoint[1].X := StrToInt(frmMain.Edit70.Text);
        tc.MemoPoint[1].Y := StrToInt(frmMain.Edit71.Text);
        tc.MemoMap[2] := frmMain.Edit74.Text;
        tc.MemoPoint[2].X := StrToInt(frmMain.Edit73.Text);
        tc.MemoPoint[2].Y := StrToInt(frmMain.Edit72.Text);

        PD_Save_Characters_Parse(true, tc.CID);
        JCon_Characters_Load();
    end;

    procedure JCon_Characters_Online();
    var
		i : Integer;
    	tc : TChara;
	begin

		frmMain.ListBox3.Clear;

		for i := 0 to (CharaName.Count - 1) do begin
			tc := CharaName.Objects[i] as TChara;
            if (tc.Login = 2) then begin

    	        frmMain.listbox3.Items.AddObject(CharaName.Strings[i], tc);
        	    frmMain.listbox3.Sorted := True;
            end;
	    end;
    end;

    procedure JCon_Chara_Online_Populate();
    var
        tc : TChara;
    begin
        if (frmMain.listbox3.ItemIndex = -1) then Exit;
        	tc := frmMain.listbox3.Items.Objects[frmMain.listbox3.ItemIndex] as TChara;
    	    frmMain.Label95.Caption := tc.Name;
    end;


    procedure JCon_Chara_KickProcess(Ban : Boolean=false);
    var
        tc : TChara;
    begin
        if (frmMain.Label95.Caption = '') then begin
        Exit;
        end else if CharaName.IndexOf(frmMain.Label95.Caption) <> -1 then begin
            tc := CharaName.Objects[CharaName.IndexOf(frmMain.Label95.Caption)] as TChara;

        if assigned(tc) then begin
            if assigned(tc.Socket) then begin
                if tc.Login <> 0 then tc.Socket.Close;
                    tc.Socket := nil;
                end;
            end;
        end;
        if Ban then begin
            tc.PData.Banned := True;
            //DataSave(true);
            {Alex: we just need to save the account. Also DataSave(true) is unsafe now.}
            PD_Save_Accounts_Parse(True);
        end;
        JCon_Characters_Online();
    end;

    procedure JCon_Chara_Online_Rescue();
    var
        tc : TChara;
    begin
        if (frmMain.Label95.Caption = '') then begin
            Exit;
        end else if CharaName.IndexOf(frmMain.Label95.Caption) <> -1 then begin

            tc := CharaName.Objects[CharaName.IndexOf(frmMain.Label95.Caption)] as TChara;
            tc.tmpMap := tc.SaveMap;
            tc.Point := tc.SavePoint;

            SendCLeave(tc, 2);
            MapMove(tc.Socket, tc.tmpMap, tc.Point);

            end;
    end;

    procedure JCon_Chara_Online_PM();
    var
        str : string;
        w : byte;
        k : integer;
        tc1 : TChara;
    begin
        str := 'Server PM: ' + frmMain.edit8.text;
        w := 200;
        WFIFOW(0, $009a);
        WFIFOW(2, w);
        WFIFOS(4, str, w);

        if (frmMain.Label95.Caption= '') then Exit;
        for k := 0 to CharaName.Count - 1 do begin
            tc1 := CharaName.Objects[k] as TChara;
            if (tc1.Login = 2) and (tc1.Name = frmMain.Label95.Caption) then tc1.Socket.SendBuf(buf, w);
        end;

        debugout.lines.add('[' + TimeToStr(Now) + '] Server Message to ' + tc1.Name + ': ' + frmMain.edit8.text);
        frmMain.edit8.Clear;
    end;

    procedure JCon_Chara_Inv_Load();
    var
		j : Integer;
    	tc : TChara;
        ShowItem : string;
        Item : TItemDB;

	begin
        frmMain.ListBox4.Clear;

        if (frmMain.listbox2.ItemIndex = -1) then Exit;
        tc := frmMain.listbox2.Items.Objects[frmMain.listbox2.ItemIndex] as TChara;
        for j := 1 to 100 do begin
            if tc.Item[j].ID <> 0 then begin
                Item := tc.Item[j].Data as TItemDB;
                ShowItem := Item.Name + ' : ' + IntToStr(tc.Item[j].ID);
                frmMain.ListBox4.Items.Add(ShowItem); end;
        end;
    end;

    procedure JCon_Chara_Inv_Populate();
    var
        j : integer;
        tc : TChara;
        Item : TItemDB;

    begin
        if (frmMain.listbox2.ItemIndex = -1) then Exit;
    		tc := frmMain.listbox2.Items.Objects[frmMain.listbox2.ItemIndex] as TChara;
        if (frmMain.listbox4.ItemIndex = -1) then Exit;
            j := (frmMain.Listbox4.ItemIndex + 1);
            Item := tc.Item[j].Data;
            try frmMain.Label121.Caption := Item.Name; except end;
            try frmMain.Edit85.Text := IntToStr(tc.Item[j].ID); except end;
            try frmMain.CheckBox1.Checked := StrToBool(IntToStr(tc.Item[j].Identify)); except end;

            if tc.Item[j].Equip <> 0 then frmMain.Label97.Visible := True
            else frmMain.Label97.Visible := false;

            try frmMain.ComboBox19.ItemIndex := tc.Item[j].Refine; except end;
            try frmMain.Edit58.Text := IntToStr(tc.Item[j].Amount); except end;
            try frmMain.Edit75.Text := IntToStr(tc.Item[j].Card[0]); except end;
            try frmMain.Edit76.Text := IntToStr(tc.Item[j].Card[1]); except end;
            try frmMain.Edit77.Text := IntToStr(tc.Item[j].Card[2]); except end;
            try frmMain.Edit78.Text := IntToStr(tc.Item[j].Card[3]); except end;
    end;

    procedure JCon_Chara_Inv_Save();
    var
        tc : TChara;
        j : Integer;
        Item : TItemList;
    begin //Still don't know how to pull this off without REED biting me.
{        //if frmMain.Edit84.Text = '' then Exit;
        if (frmMain.listbox2.ItemIndex = -1) then Exit;
    		tc := frmMain.listbox2.Items.Objects[frmMain.listbox2.ItemIndex] as TChara;

        if assigned(tc) then begin
            if assigned(tc.Socket) then begin
                if tc.Login <> 0 then tc.Socket.Close;
                    tc.Socket := nil;
            end;
        end;

        if (frmMain.listbox4.ItemIndex = -1) then Exit;
        j := (frmMain.Listbox4.ItemIndex + 1);
        //Item Removal
        if StrToInt(frmMain.Edit85.Text) = 0 then
            tc.Item[j].ID := 0
        else begin
            if StrToInt(frmMain.Edit85.Text) <> tc.Item[j].ID then Exit {begin
            //Disabling new/overwrite item usage.  REED doesn't like me
                tc.Item[j].ID := StrToInt(frmMain.Edit85.Text);
                tc.Item[j].Equip := 0;
                tc.Item[j].Attr := 0;
                tc.Item[j].Amount := 1;
                tc.Item[j].Card[0] := 0;
                tc.Item[j].Card[1] := 0;
                tc.Item[j].Card[2] := 0;
                tc.Item[j].Card[3] := 0;
                tc.Item[j].Refine := 0;
            end else begin
                tc.Item[j].Amount := StrToInt(frmMain.Edit58.Text);
                tc.Item[j].Card[0] := 0;
                tc.Item[j].Card[1] := 0;
                tc.Item[j].Card[2] := 0;
                tc.Item[j].Card[3] := 0;
            end;
        end;
        DataSave(True);}
        JCon_Chara_Inv_Load();
    end;


    procedure JCon_Chara_Cart_Load();
    var
		j : Integer;
    	tc : TChara;
        Item : TItemDB;

	begin
        frmMain.ListBox6.Clear;

        if (frmMain.listbox2.ItemIndex = -1) then Exit;
        tc := frmMain.listbox2.Items.Objects[frmMain.listbox2.ItemIndex] as TChara;
        for j := 1 to 100 do begin
            if tc.Cart.Item[j].ID <> 0 then begin
                Item := tc.Cart.Item[j].Data as TItemDB;
                frmMain.ListBox6.Items.Add(Item.Name + ' : ' + IntToStr(tc.Cart.Item[j].ID));
            end;
        end;
    end;

    procedure JCon_Chara_Store_Load();
    var
		j : Integer;
    	tc : TChara;
        Item : TItemDB;

	begin
        frmMain.ListBox5.Clear;

        if (frmMain.listbox2.ItemIndex = -1) then Exit;
        tc := frmMain.listbox2.Items.Objects[frmMain.listbox2.ItemIndex] as TChara;
        for j := 1 to 100 do begin
            if tc.PData.Kafra.Item[j].ID <> 0 then begin
                Item := tc.PData.Kafra.Item[j].Data as TItemDB;
                frmMain.ListBox5.Items.Add(Item.Name + ' : ' + IntToStr(tc.PData.Kafra.Item[j].ID));
            end;
        end;
    end;

    procedure JCon_Chara_Skill_Load(HideNull : Boolean);
    var
		j : Integer;
    	tc : TChara;
        JIDFix : integer;

	begin
        frmMain.ListBox7.Clear;
        frmMain.ComboBox20.Clear;

        if (frmMain.listbox2.ItemIndex = -1) then Exit;
        tc := frmMain.listbox2.Items.Objects[frmMain.listbox2.ItemIndex] as TChara;

        JIDFix := StrToInt(frmMain.Edit10.Text);

        for j := 1 to MAX_SKILL_NUMBER do begin

            if HideNull = true then begin

                frmMain.CheckBox2.Checked := true;
                if tc.Skill[j].Lv <> 0 then
                    frmMain.ListBox7.Items.Add((IntToStr(tc.Skill[j].Data.ID)) + ' : ' + tc.Skill[j].Data.Name);
            end else begin
                frmMain.CheckBox2.Checked := false;
                if ((tc.Skill[j].Data.Job1[JIDFix]) or (tc.Skill[j].Data.Job2[JIDFix])) then begin
                    if tc.Skill[j].Lv >= 0 then
                        frmMain.ListBox7.Items.Add((IntToStr(tc.Skill[j].Data.ID)) + ' : ' + tc.Skill[j].Data.Name);
                end;
            end;
        end;
    end;

    procedure JCon_Chara_Skill_Populate();
    var
        tc : TChara;
        TempIndex, SkillID : integer;

    begin
        if (frmMain.listbox2.ItemIndex = -1) then Exit;
        if (frmMain.ListBox7.ItemIndex = -1) then Exit;

		tc := frmMain.listbox2.Items.Objects[frmMain.listbox2.ItemIndex] as TChara;

        frmMain.ComboBox20.Clear;

        if frmMain.CheckBox2.Checked = false then begin
            SkillID := (frmMain.ListBox7.ItemIndex + 1); //Skill ID if you show all skills
        end else begin
            TempIndex := 0;
            SkillID := 0; //the skill ID if you have hidden
            repeat  //selecting a skill ID that isn't lvl 0,
                    // and then adding a counter to compare with selected itemindex
                SkillID := SkillID + 1;
                if tc.Skill[SkillID].Lv <> 0 then
                    TempIndex := TempIndex + 1;
            until (TempIndex = (frmMain.ListBox7.ItemIndex + 1)) OR (SkillID > MAX_SKILL_NUMBER);
        end;
        frmMain.Label116.Caption := IntToStr(SkillID);

        //reusing TempIndex to save variables
        //creating the combobox to hold valid skill levels
        for TempIndex := 0 to tc.Skill[SkillID].Data.MasterLV do
            frmMain.ComboBox20.Items.Add(IntToStr(TempIndex));
        frmMain.ComboBox20.ItemIndex := tc.Skill[SkillID].Lv;
    end;

    procedure JCon_Chara_Skill_Save();
    var
        tc : TChara;
        j : integer;

    begin
        if (frmMain.ListBox7.ItemIndex = -1) then Exit;
        tc := frmMain.listbox2.Items.Objects[frmMain.listbox2.ItemIndex] as TChara;

        if assigned(tc) then begin
            if assigned(tc.Socket) then begin
                if tc.Login <> 0 then tc.Socket.Close;
                    tc.Socket := nil;
                end;
        end;

        j := StrToInt(frmMain.Label116.Caption);

        tc.Skill[j].Lv := frmMain.ComboBox20.ItemIndex;
        DataSave(true);
        if frmMain.CheckBox2.Checked = false then JCon_Chara_Skill_Load(false)
        else JCon_Chara_Skill_Load(true);
    end;

    procedure JCon_Chara_Flag_Load();
    var
    	tc : TChara;

	begin
        frmMain.ListBox8.Clear;
        frmMain.Edit79.Clear;
        frmMain.Edit80.Clear;

        if (frmMain.listbox2.ItemIndex = -1) then Exit;
        tc := frmMain.listbox2.Items.Objects[frmMain.listbox2.ItemIndex] as TChara;

        frmMain.ListBox8.Items.AddStrings(tc.Flag);

    end;

    procedure JCon_Chara_Flag_Delete();
    var
        tc : TChara;
    begin
        if (frmMain.listbox2.ItemIndex = -1) then Exit;
        if (frmMain.listbox8.ItemIndex = -1) then Exit;
        tc := frmMain.listbox2.Items.Objects[frmMain.listbox2.ItemIndex] as TChara;
        tc.Flag.Delete(frmMain.ListBox8.ItemIndex);

        DataSave(true);
        JCon_Chara_Flag_Load();
    end;

    procedure JCon_Chara_Flag_Populate();
    var
        tc : TChara;
        sl : string;
        delimiter : integer;
    begin
        if (frmMain.listbox2.ItemIndex = -1) then Exit;
        if (frmMain.listbox8.ItemIndex = -1) then Exit;
        tc := frmMain.listbox2.Items.Objects[frmMain.listbox2.ItemIndex] as TChara;
        sl := frmMain.ListBox8.Items.Strings[frmMain.ListBox8.ItemIndex];
        delimiter := AnsiPos('=', sl);
        frmMain.Edit79.Text := AnsiLeftStr(sl, delimiter - 1);
        frmMain.Edit80.Text := AnsiRightStr(sl, (length(sl) - delimiter));
    end;

    procedure JCon_Chara_Flag_Save();
    var
        tc : TChara;
        sl, str : string;
        varname, varval : string; // variable name and variable value
        delimiter : integer;  // position of "=" for delimitting
    begin
        if (frmMain.listbox2.ItemIndex = -1) then Exit;
        if (frmMain.listbox8.ItemIndex = -1) then Exit;
        tc := frmMain.listbox2.Items.Objects[frmMain.listbox2.ItemIndex] as TChara;
        sl := frmMain.ListBox8.Items.Strings[frmMain.ListBox8.ItemIndex];
        delimiter := AnsiPos('=', sl);
        varname := AnsiLeftStr(sl, delimiter - 1);
        varval := AnsiRightStr(sl, (length(sl) - delimiter));
        str := frmMain.Edit79.Text + '=' + frmMain.Edit80.Text;

        if frmMain.Edit79.Text <> varname then //adding a new var
            tc.Flag.Add(str)
        else //updating
            tc.Flag.Strings[frmMain.ListBox8.ItemIndex] := str;

        DataSave(true);
        JCon_Chara_Flag_Load();
    end;

end.
