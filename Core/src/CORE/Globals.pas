unit Globals;

interface

uses
    {Windows VCL}
    {$IFDEF MSWINDOWS}
    MMSystem, ComObj,
    {$ENDIF}
    {Kylix/Delphi CLX}
        {need eqive of MMSystem.  MMSystem is needed for timeGetTime}
    {Shared}
    Classes, SysUtils, Dialogs,
    {Fusion}
    Common, SQLData, Zip, List32, PlayerData, REED_SAVE_ACCOUNTS, REED_Support;



    procedure init_globals();

    { ---------------------------------------------------------------------- }

    function check_attack_lag(tc : TChara) : Boolean;

    procedure reset_skill_effects(tc : TChara);
    procedure remove_equipcard_skills(tc : TChara; idx : Integer);

    function remove_badsavechars(str : String) : String;

    procedure leave_party(tc : TChara);
    procedure leave_guild(tc : TChara);
    procedure ban_guild(tc : TChara);

    procedure message_green(tc : TChara; str : String);
    procedure message_yellow(tc : TChara; str : String);
    procedure message_blue(tc : TChara; str : String);

    procedure backup_txt_database();

    function uselan(in_ip : String) : Boolean;

    function open_storage(tc : TChara; storage_items : array of TItem) : Integer;
    function addto_storage(tc : TChara; storage_items : array of TItem; amt, w1, w2: Integer) : Integer;
    function takefrom_storage(tc : TChara; storage_items : array of TItem; cnt, l, w1, w2 : Integer) : Integer;

    procedure fnl_lists(stringlist : TStringList; intlist : TIntList32);

    procedure create_account(username : String; password : String; email : String; sex : String);
    function get_accountid() : Integer;

    procedure create_upnp(port : Integer; name : String);
    procedure destroy_upnp(port : Integer);
    procedure broadcast_handle(tc,tc1 : TChara; str : string; NPCReferal : boolean; MessageMod : integer; NPC : TNPC = nil);
    function JIDFixer(ID:integer) : integer;

    function get_nowguildid() : Integer;
    procedure console(str : String);


implementation

uses
	Main, REED_DELETE;


    procedure init_globals();
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

        NowUsers := 0;
        NowLoginID := 0;
        NowItemID := 10000;
        NowMobID := 1000000;
        NowCharaID := 0;
        NowPartyID := 10000;
        NowPetID := 0;
        NowGuildID := get_nowguildid();

        DebugOut := frmMain.txtDebug;

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

        MobAIDBFusion := TIntList32.Create;
        MobAIDBFusion.Sorted := true;

        MercenariesList := TStringList.Create;
        MercenariesList.CaseSensitive := False;

        GlobalVars := TStringList.Create;

        MobDBName := TStringList.Create;
        MobDBName.CaseSensitive := True;
        SlaveDBName := TStringList.Create;
        SlaveDBName.CaseSensitive := True;

        MArrowDB := TIntList32.Create;
        MArrowDB.Sorted := true;

        WarpDatabase := TStringList.Create;

        IDTableDB := TIntList32.Create;
        IDTableDB.Sorted := true;

        SkillDB := TIntList32.Create;
        SkillDBName := TStringList.Create;

        PlayerName := TStringList.Create;
        PlayerName.CaseSensitive := True;
        PlayerName.Sorted := True;
        Player := TIntList32.Create;
        Player.Sorted := True;

        CharaName := TStringList.Create;
        CharaName.CaseSensitive := True;
        CharaName.Sorted := True;
        Chara := TIntList32.Create;
        Chara.Sorted := True;
        CharaPID := TIntList32.Create;

        PartyNameList := TStringList.Create;
        PartyNameList.CaseSensitive := True;

        PartyList := TIntList32.Create;
        PartyList.Sorted := True;

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

        SummonMobListMVP := TStringList.Create;

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

        BanList := TStringList.Create;
    end;

    { ---------------------------------------------------------------------- }

    function check_attack_lag(tc : TChara) : Boolean;
    begin
        Result := False;

        if ( (tc.DmgTick + 10000) > timeGetTime() ) then begin
            Result := True;
            message_green(tc, 'You are being attacked. Please try again in 10 seconds.');
        end else
    end;

    procedure reset_skill_effects(tc : TChara);
    var
    	i : Integer;
    begin
    	for i := 1 to MAX_SKILL_NUMBER do begin
        	if tc.Skill[i].Tick >= timeGetTime() then begin
            	tc.Skill[i].Tick := 0;
                tc.SkillTick := 0;
            end;
        end;
    end;

    procedure remove_equipcard_skills(tc : TChara; idx : Integer);
    var
    	i, j : Integer;
        td : TItemDB;
    begin
    	for j := 1 to MAX_SKILL_NUMBER do begin
        	if tc.Item[idx].Data.AddSkill[j] <> 0 then begin
            	if (tc.Skill[j].Card) then begin
                	tc.Skill[j].Lv := tc.Skill[j].Lv - tc.Item[idx].Data.AddSkill[j];
                    tc.Skill[j].Card := False;
				end;
			end;

            for i := 0 to tc.Item[idx].Data.Slot - 1 do begin
            	td := ItemDB.IndexOfObject(tc.Item[idx].Card[i]) as TItemDB;
                if assigned(td) then begin
                	if (td.AddSkill[j] <> 0) and (tc.Skill[j].Card) then begin
	                	tc.Skill[j].Lv := tc.Skill[j].Lv - td.AddSkill[j];
    	                tc.Skill[j].Card := False;
                    end;
                end;
            end;
		end;
    end;

    function remove_badsavechars(str : String) : String;
    begin
        str := StringReplace(str, '\', '-', [rfReplaceAll, rfIgnoreCase]);
        str := StringReplace(str, '/', '-', [rfReplaceAll, rfIgnoreCase]);
        str := StringReplace(str, ':', '-', [rfReplaceAll, rfIgnoreCase]);
        str := StringReplace(str, '*', '-', [rfReplaceAll, rfIgnoreCase]);
        str := StringReplace(str, '?', '-', [rfReplaceAll, rfIgnoreCase]);
        str := StringReplace(str, '<', '-', [rfReplaceAll, rfIgnoreCase]);
        str := StringReplace(str, '>', '-', [rfReplaceAll, rfIgnoreCase]);
        str := StringReplace(str, '|', '-', [rfReplaceAll, rfIgnoreCase]);
        str := StringReplace(str, '"', '-', [rfReplaceAll, rfIgnoreCase]);
        str := StringReplace(str, '.', '-', [rfReplaceAll, rfIgnoreCase]);
        Result := str;
    end;


    { -------------------------------------------------------------------------------- }
    { - Beginning of processing procedures ------------------------------------------- }
    { -------------------------------------------------------------------------------- }

    procedure leave_party(tc : TChara);
    var
    	i, j : Integer;
        tpa : TParty;
    begin
    	i := PartyNameList.IndexOf(tc.PartyName);

        if (i <> -1) then begin
        	tpa := PartyNameList.Objects[i] as TParty;

            WFIFOW( 0, $0105);
            WFIFOL( 2, tc.CID);
            WFIFOS( 6, tc.Name , 24);
            WFIFOB( 30, 1);
            SendPCmd(tc,31);

            tc.PartyName := '';
            tc.PartyID := 0;

            j := -1;
            for i := 0 to 11 do begin;
            	if tc.CID = tpa.MemberID[i] then begin
                	j := i;
                    break;
                end;
            end;

            for i := j to 10 do begin
            	tpa.MemberID[i] := tpa.MemberID[i+1];
                tpa.Member[i] := tpa.Member[i+1];
            end;

            tpa.MemberID[11] := 0;
            tpa.Member[11] := nil;

            if (tpa.MemberID[0] = 0) then begin
            	if UseSQL then DeleteParty(tpa.Name);

                PD_Delete_Parties(tpa.ID);

                tpa.Free;
            end else begin
            	if assigned(tpa.Member[0]) then begin
	            	SendPartyList(tpa.Member[0]);
                end;
            end;
        end;
    end;

    procedure leave_guild(tc : TChara);
    var
    	str : String;
        l : Cardinal;
        i, j : Integer;
        tg : TGuild;
    begin
    	RFIFOL( 2, l);
        str := RFIFOS(14, 40);

        j := GuildList.IndexOf(tc.GuildID);
        if (j = -1) then Exit;

        tg := GuildList.Objects[j] as TGuild;

        if (tc.Name <> tg.MasterName) and (tg.RegUsers > 1) then begin
        	WFIFOW( 0, $015a);
            WFIFOS( 2, tc.Name, 24);
            WFIFOS(26, str, 40);
            SendGuildMCmd(tc, 66);

            for i := tc.GuildPos to 35 do begin
            	tg.MemberID[i] := tg.MemberID[i + 1];
                tg.Member[i] := tg.Member[i + 1];
                tg.MemberPos[i] := tg.MemberPos[i + 1];
                tg.MemberEXP[i] := tg.MemberEXP[i + 1];
            end;

            if (tg.GuildBanList.IndexOf(tc.Name) <> -1) then tg.GuildBanList.Delete(tg.GuildBanList.IndexOf(tc.Name));

            if UseSQL then DeleteGuildMember(tc.CID,1,nil,0);

            Dec(tg.RegUsers);
            tc.GuildID := 0;
            tc.GuildName := '';
            tc.ClassName := '';
            tc.GuildPos := 0;
        end else begin
        	for i := 0 to tg.RegUsers - 1 do begin
            	if assigned(tg.Member[i]) then begin
	            	tg.Member[i].GuildID := 0;
    	            tg.Member[i].GuildName := '';
        	        tg.Member[i].GuildPos := 0;
                end;
            end;

            PD_Delete_Guilds(tg.ID);
        end;
    end;

    procedure ban_guild(tc : TChara);
    var
    	l : Cardinal;
        l2 : Cardinal;
        i, j : Integer;
        str : String;
        tg : TGuild;
        tc1 : TChara;
        tp1 : TPlayer;
        tgb : TGBan;
    begin
    	RFIFOL( 2, l);
        RFIFOL(10, l2);
        str := RFIFOS(14, 40);

        j := GuildList.IndexOf(tc.GuildID);
        if (j = -1) then Exit;

        tg := GuildList.Objects[j] as TGuild;
        if (tg.ID <> l) then Exit;

        tc1 := Chara.IndexOfObject(l2) as TChara;
        if tc1 = nil then Exit;

        tp1 := Player.IndexOfObject(tc1.ID) as TPlayer;

        WFIFOW( 0, $015c);
        WFIFOS( 2, tc1.Name, 24);
        WFIFOS(26, str, 40);
        WFIFOS(66, tp1.Name, 24);
        SendGuildMCmd(tc, 90);

        tgb := TGBan.Create;
        tgb.Name := tc1.Name;
        tgb.AccName := tp1.Name;
        tgb.Reason := str;
        tg.GuildBanList.AddObject(tgb.Name, tgb);

        for i := tc1.GuildPos to 35 do begin
        	tg.MemberID[i] := tg.MemberID[i + 1];
            tg.Member[i] := tg.Member[i + 1];
            tg.MemberPos[i] := tg.MemberPos[i + 1];
            tg.MemberEXP[i] := tg.MemberEXP[i + 1];
            if assigned(tg.Member[i]) then
                Dec(tg.Member[i].GuildPos);
        end;

        if UseSQL then DeleteGuildMember(tc1.CID,2,tgb,tg.ID);

        Dec(tg.RegUsers);
        tc1.GuildID := 0;
        tc1.GuildName := '';
        tc1.ClassName := '';
        tc1.GuildPos := 0;
    end;

    { -------------------------------------------------------------------------------- }

    procedure message_green(tc : TChara; str : String);
    begin
        WFIFOW(0, $008e);
        WFIFOW(2, length(str) + 5);
        WFIFOS(4, str, length(str) + 1);
        if tc.Login <> 0 then tc.Socket.SendBuf(buf, length(str) + 5);
    end;

    procedure message_yellow(tc : TChara; str : String);
    begin
        WFIFOW(0, $009a);
        WFIFOW(2, length(str) + 5);
        WFIFOS(4, str, length(str) + 1);
        if tc.Login <> 0 then tc.Socket.SendBuf(buf, length(str) + 5);
    end;

    procedure message_blue(tc : TChara; str : String);
    begin
        WFIFOW(0, $009a);
        WFIFOW(2, length(str) + 9);
        WFIFOS(4, 'blue'+str, length(str) + 4);
        if tc.Login <> 0 then tc.Socket.SendBuf(buf, length(str) + 9);
    end;

    procedure backup_txt_database();
    var
	    zfile :TZip;
    	fileslist :TStringList;
	    filename :string;
        //R.E.E.D.
        gamefolder :string;
        gamedatalist :TStringList;
    begin
	    DateSeparator      := '-';
    	TimeSeparator      := '-';
	    ShortDateFormat    := 'yyyy/mm/dd';
    	LongTimeFormat    := 'hh:mm:ss';

	    filename := datetostr(date) + ' - ' +timetostr(time);
    	CreateDir(AppPath+'backup');

        try
    	    zfile := tzip.create(frmMain);
        	zfile.Filename := AppPath + 'backup\' + filename + '.zip';

    	    fileslist := tstringlist.Create;
            // fileslist.Add(AppPath + 'chara.txt');
            // fileslist.Add(AppPath + 'gcastle.txt');
            // fileslist.Add(AppPath + 'guild.txt');
            // fileslist.Add(AppPath + 'party.txt');
            // fileslist.Add(AppPath + 'pet.txt');
            // fileslist.Add(AppPath + 'player.txt');
            //fileslist.Add(AppPath + 'status.txt');
            fileslist.Add(AppPath + 'Global_Vars.txt');
            fileslist.Add(AppPath + 'servervariables.txt');
            fileslist.Add(AppPath + 'BannedIPs.txt');

            zfile.FileSpecList := fileslist;
            zfile.Add;

            //R.E.E.D
            gamefolder := AppPath;
            zfile.AddPath := gamefolder;
            gamedatalist := tstringlist.Create;
            gamedatalist.Add('gamedata\*.txt');
            zfile.AddOptions := [aoRecursive, aoFolderEntries, aoUpdate]; //include all subfolders too.

            zfile.FileSpecList := gamedatalist;
            zfile.Add;

            zfile.Free;

            fileslist.Free;
            gamedatalist.Free;
        except
            on ZipException do begin
                debugout.Lines.Add('Unable to create backup file. Check your folder.');
            end;
        end;
    end;


    function uselan(in_ip : String) : Boolean;
    var
        sl : TStringList;
    begin
        Result := False;

        sl := TStringList.Create;
        sl.Delimiter := '.';
        sl.DelimitedText := in_ip;

        { ------------------------------------------- }
        { Private IP Addresses                        }
        { ------------------------------------------- }
        { 192.168.0.0 - 192.168.255.255               }
        { 172.16.0.0 - 172.31.255.255                 }
        { 10.0.0.0 - 10.255.255.255                   }
        { 127.0.0.1                                   }
        { ------------------------------------------- }
        { http://www.duxcw.com/faq/network/privip.htm }
        { ------------------------------------------- }

        if (sl.DelimitedText = '127.0.0.1') then
            Result := True
        else if (sl.Strings[0] = '10') then
            Result := True
        else if ( (sl.Strings[0] = '192') and (sl.Strings[1] = '168') ) then
            Result := True
        else if ( (sl.Strings[0] = '172') and (StrToInt(sl.Strings[1]) >= 16) and (StrToInt(sl.Strings[1]) <= 31) ) then
            Result := True;

        FreeAndNil(sl);
    end;


    function open_storage(tc : TChara; storage_items : array of TItem) : Integer;
    var
        storage_count : Integer;
        i, j : Integer;
    begin

        storage_count := 0;

        { -- Get list of non-equip items -- }
        WFIFOW(0, $00a5);

        j := 0;
        for i := 0 to 99 do begin

            if storage_items[i].ID = 0 then Continue;
            if storage_items[i].Data.IEquip then Continue;

            WFIFOW( 4 + j * 10, i+1);
            WFIFOW( 6 + j * 10, storage_items[i].Data.ID);
            WFIFOB( 8 + j * 10, storage_items[i].Data.IType);
            WFIFOB( 9 + j * 10, storage_items[i].Identify);
            WFIFOW(10 + j * 10, storage_items[i].Amount);

            if storage_items[i].Data.IType = 10 then WFIFOW(12 + j * 10, 32768)
            else WFIFOW(12 + j * 10, 0);

            Inc(j);
            Inc(storage_count);

        end;

        WFIFOW(2, 4 + j * 10);
        tc.Socket.SendBuf(buf, 4 + j * 10);
        { -- Get list of non-equip items -- }


        { -- Get list of equippable items -- }
        WFIFOW(0, $00a6);

        j := 0;
        for i := 0 to 99 do begin

            if storage_items[i].ID = 0 then Continue;
            if not storage_items[i].Data.IEquip then Continue;

            WFIFOW( 4 + j * 20, i+1);
            WFIFOW( 6 + j * 20, storage_items[i].Data.ID);
            WFIFOB( 8 + j * 20, storage_items[i].Data.IType);
            WFIFOB( 9 + j * 20, storage_items[i].Identify);

            with storage_items[i].Data do begin
                if (tc.JID = 12) and (IType = 4) and (Loc = 2) and ((View = 1) or (View = 2) or (View = 6)) then
                    WFIFOW(10 + j * 20, 34)
                else
                    WFIFOW(10 + j * 20, storage_items[i].Data.Loc);
            end;

            WFIFOW(12 + j * 20, storage_items[i].Equip);
            WFIFOB(14 + j * 20, storage_items[i].Attr);
            WFIFOB(15 + j * 20, storage_items[i].Refine);
            WFIFOW(16 + j * 20, storage_items[i].Card[0]);
            WFIFOW(18 + j * 20, storage_items[i].Card[1]);
            WFIFOW(20 + j * 20, storage_items[i].Card[2]);
            WFIFOW(22 + j * 20, storage_items[i].Card[3]);

            Inc(j);
            Inc(storage_count);

        end;

        WFIFOW(2, 4 + j * 20);
        tc.Socket.SendBuf(buf, 4 + j * 20);
        { -- Get list of equippable items -- }


        { -- Assign storage totals -- }
        WFIFOW(0, $00f2);
        WFIFOW(2, storage_count);
        WFIFOW(4, 100);
        tc.Socket.SendBuf(buf, 6);
        { -- Assign storage totals -- }
        

        result := storage_count;

    end;


    function addto_storage(tc : TChara; storage_items : array of TItem; amt, w1, w2 : Integer) : Integer;
    var
        j : Integer;
    begin

        Result := -1;

        j := SearchPInventory(tc, tc.Item[w1].ID, tc.Item[w1].Data.IEquip, storage_items);
        if j < 0 then Exit;

        if (storage_items[j].Amount = 0) then begin
            Inc(amt);
            WFIFOW(0, $00f2);
            WFIFOW(2, amt);
            WFIFOW(4, 100);
            tc.Socket.SendBuf(buf, 6);
        end;

        if storage_items[j].Amount + w2 > 30000 then Exit;

        storage_items[j].ID := tc.Item[w1].ID;
        Inc(storage_items[j].Amount, w2);

        storage_items[j].Equip := 0;
        storage_items[j].Identify := tc.Item[w1].Identify;
        storage_items[j].Refine := tc.Item[w1].Refine;
        storage_items[j].Attr := tc.Item[w1].Attr;
        storage_items[j].Card[0] := tc.Item[w1].Card[0];
        storage_items[j].Card[1] := tc.Item[w1].Card[1];
        storage_items[j].Card[2] := tc.Item[w1].Card[2];
        storage_items[j].Card[3] := tc.Item[w1].Card[3];
        storage_items[j].Data := tc.Item[w1].Data;

        WFIFOW( 0, $00f4);
        WFIFOW( 2, j+1);
        WFIFOL( 4, w2);
        WFIFOW( 8, storage_items[j].ID);
        WFIFOB(10, storage_items[j].Identify);
        WFIFOB(11, storage_items[j].Attr);
        WFIFOB(12, storage_items[j].Refine);
        WFIFOW(13, storage_items[j].Card[0]);
        WFIFOW(15, storage_items[j].Card[1]);
        WFIFOW(17, storage_items[j].Card[2]);
        WFIFOW(19, storage_items[j].Card[3]);
        tc.Socket.SendBuf(buf, 21);

        Dec(tc.Item[w1].Amount, w2);
        if tc.Item[w1].Amount = 0 then tc.Item[w1].ID := 0;
        WFIFOW( 0, $00af);
        WFIFOW( 2, w1);
        WFIFOW( 4, w2);
        tc.Socket.SendBuf(buf, 6);

        Result := amt;

    end;


    function takefrom_storage(tc : TChara; storage_items : array of TItem; cnt, l, w1, w2 : Integer) : Integer;
    var
        j : Integer;
        tpe : TPet;
        weight : Cardinal;
    begin
        Result := 0;

        if (storage_items[w1].ID = 0) or (storage_items[w1].Amount < w2) then Exit;
        weight := storage_items[w1].Data.Weight * w2;

        j := SearchCInventory(tc, storage_items[w1].ID, storage_items[w1].Data.IEquip);

        if j = 0 then Exit;
        if tc.Item[j].Amount + w2 > 30000 then Exit;

        tc.Item[j].ID := storage_items[w1].ID;
        Inc(tc.Item[j].Amount, w2);

        tc.Item[j].Equip := 0;
        tc.Item[j].Identify := storage_items[w1].Identify;
        tc.Item[j].Refine := storage_items[w1].Refine;
        tc.Item[j].Attr := storage_items[w1].Attr;
        tc.Item[j].Card[0] := storage_items[w1].Card[0];
        tc.Item[j].Card[1] := storage_items[w1].Card[1];
        tc.Item[j].Card[2] := storage_items[w1].Card[2];
        tc.Item[j].Card[3] := storage_items[w1].Card[3];
        tc.Item[j].Data := storage_items[w1].Data;

        SendCGetItem(tc, j, w2);

        Dec(storage_items[w1].Amount, w2);
        if (storage_items[w1].Amount = 0) then begin
            storage_items[w1].ID := 0;
            Dec(cnt);
        end;

        WFIFOW(0, $00f6);
        WFIFOW(2, w1+1);
        WFIFOL(4, l);
        tc.Socket.SendBuf(buf, 8);

        WFIFOW(0, $00f2);
        WFIFOW(2, cnt);
        WFIFOW(4, 100);
        tc.Socket.SendBuf(buf, 6);

        tc.Weight := tc.Weight + weight;

        SendCStat1(tc, 0, $0018, tc.Weight);

        if (tc.Item[j].Card[0] = $FF00) then begin
            if PetList.IndexOf(tc.Item[j].Card[1]) = -1 then Exit;
            tpe := PetList.Objects[PetList.IndexOf(tc.Item[j].Card[1])] as TPet;
            tpe.Index := j;
            tpe.CharaID := tc.CID;
        end;

    end;


    procedure fnl_lists(stringlist : TStringList; intlist : TIntList32);
    var
        idx : Integer;
        dual : Boolean;
    begin

        dual := False;
        if assigned(stringlist) and assigned(intlist) then dual := True;

        if assigned(stringlist) then begin
            try
                if stringlist.Count > 0 then begin
                    for idx := 0 to stringlist.Count - 1 do begin
                        if assigned(stringlist.Objects[idx]) then
                            stringlist.Objects[idx].Free;
                            stringlist.Objects[idx] := nil;
                    end;
                end;
            except
            end;
            FreeAndNil(stringlist);
        end;

        if assigned(intlist) then begin
            try
                if (intlist.Count > 0) and not (dual) then begin
                    for idx := 0 to intlist.Count - 1 do begin
                        if assigned(intlist.Objects[idx]) then
                            intlist.Objects[idx].Free;
                    end;
                end;
            except
            end;
            FreeAndNil(intlist);
        end;

    end;

    procedure create_account(username : String; password : String; email : String; sex : String);
    var
        tp : TPlayer;
    begin

        tp := TPlayer.Create;
        tp.ID := get_accountid();
        tp.Name := username;
        tp.Pass := password;

        if (sex = 'M') or (sex = '_M') then tp.Gender := 1
        else if (sex = 'F') or (sex = '_F') then tp.Gender := 0
        else tp.Gender := StrToInt(sex);

        tp.Mail := email;
        tp.Login := false;
        PlayerName.AddObject(tp.Name, tp);
        Player.AddObject(tp.ID, tp);

        PD_Save_Accounts_Parse(True);
    end;

    function get_accountid() : Integer;
    var
        last : Integer;
        i : Integer;
        tp : TPlayer;
    begin
        last := 100099;

        for i := 0 to Player.Count do begin

            if (i = Player.Count) then begin
                Inc(last, 2);
                Break;
            end;

            tp := Player.Objects[i] as TPlayer;

            if (tp.ID < 100101) then Continue;
            Inc(last);
            if ( (tp.ID - last) <= 1 ) then Continue;
            Inc(last);
            Break;

        end;

        Result := last;
    end;

    procedure create_upnp(port : Integer; name : String);
    var
        nat : Variant;
        ports : Variant;
    begin
        if not (LAN_IP = '127.0.0.1') then begin
            try
                nat := CreateOleObject('HNetCfg.NATUPnP');
                ports := nat.StaticPortMappingCollection;
                ports.Add(port, 'TCP', port, LAN_IP, true, name);
            except
                ShowMessage('An Error occured with adding UPnP Ports. The ' + name + ' port was not added to the router.  Please check to see if your router supports UPnP and has it enabled or disable UPnP.');
            end;
        end;
    end;

    procedure destroy_upnp(port : Integer);
    var
        nat : Variant;
        ports : Variant;
    begin
        if not (LAN_IP = '127.0.0.1') then begin
            try
                nat := CreateOleObject('HNetCfg.NATUPnP');
                ports := nat.StaticPortMappingCollection;
                ports.Remove(port, 'TCP');
            except
                ShowMessage('An Error occured while trying to remove the UPnP Ports. If you have a router with UPnP enabled, please check the Internet Gateway to make sure the Fusion ports are closed. Make sure to disable UPnP if your router does not support it.');
            end;
        end;
    end;

    procedure broadcast_handle(tc,tc1 : TChara; str : string; NPCReferal : boolean; MessageMod : integer; NPC : TNPC = nil);
    (*--------------------------------------------------------------------------------
    Broadcast handler. -Tsusai
    This is the all-in-one form of broadcast designed to work with calls from
    NPC's as well as anything else.
    tc & tc1 -> tc is the sender, tc1 is the receiver(s)
    str -> Broadcast string
    NPCReferal -> If using a npc to make the call, converts MessageMod to compatable BroadcastType
    MessageMod -> changes the type of modification like blue color, Charaname pre-addon, etc
      after being properly converted to to BroadcastType
        BroadcastType = 1 is just the string sent
        BroadcastType = 2 is charaname + string
        BroadcastType = 3 is 2 but blue
        BroadcastType = 5 is blue color string
        BroadcastType = 0 is NPC Name + string
        BroadcastType = 4 is 0 but blue
    NPC -> refering npc, OPTIONAL because GM commands don't have a refering npc (thanks Chris)
    --------------------------------------------------------------------------------*)
    var
        i : integer;
        j : integer;
        k : integer;
        w : integer;
        BroadcastType : byte;
    begin
        str := str + chr(0);
        i := AnsiPos('$[', str);
        while i <> 0 do begin
            j := AnsiPos(']', Copy(str, i + 2, 256));
            if j <= 1 then break;
            //grabbing variables
            if (Copy(str, i + 2, 1) = '$') then
                str := Copy(str, 1, i - 1) + tc.Flag.Values[Copy(str, i + 2, j - 1)]  + Copy(str, i + j + 2, 256)
            else if (Copy(str, i + 2, 2) = '\$') then
                str := Copy(str, 1, i - 1) + ServerFlag.Values[Copy(str, i + 2, j - 1)]  + Copy(str, i + j + 2, 256)
            else begin
                k := ConvFlagValue(tc, Copy(str, i + 2, j - 1), true);
                if k <> -1 then str := Copy(str, 1, i - 1) + IntToStr(k) + Copy(str, i + j + 2, 256)
            else str := Copy(str, 1, i - 1) + Copy(str, i + j + 2, 256);
            end;
        i := AnsiPos('$[', str);
        end;
        //predetermined variable string replacement
        str := StringReplace(str, '$codeversion', CodeVersion, [rfReplaceAll]);
        str := StringReplace(str, '$charaname', tc.Name, [rfReplaceAll]);
        str := StringReplace(str, '$joblevel', IntToStr(tc.JobLV), [rfReplaceAll]);
        if ((NPCReferal) and (Assigned(NPC))) then begin
            str := StringReplace(str, '$guildname', GetGuildName(NPC), [rfReplaceAll]);
            str := StringReplace(str, '$guildmaster', GetGuildMName(NPC), [rfReplaceAll]);
            str := StringReplace(str, '$edegree', IntToStr(GetGuildEDegree(NPC)), [rfReplaceAll]);
            str := StringReplace(str, '$etrigger', IntToStr(GetGuildETrigger(NPC)), [rfReplaceAll]);
            str := StringReplace(str, '$ddegree', IntToStr(GetGuildDDegree(NPC)), [rfReplaceAll]);
            str := StringReplace(str, '$dtrigger', IntToStr(GetGuildDTrigger(NPC)), [rfReplaceAll]);
        end;
        str := StringReplace(str, '$$', '$', [rfReplaceAll]);
        str := StringReplace(str, '\\', '\', [rfReplaceAll]);


        if NPCReferal then begin
            if ((MessageMod = 0) or (MessageMod = 200)) then BroadcastType := 0
            else if ((MessageMod = 20) or (MessageMod = 220)) then BroadcastType := 2
            else if ((MessageMod = 30) or (MessageMod = 230)) then BroadcastType := 3
            else if ((MessageMod = 40) or (MessageMod = 240)) then BroadcastType := 4
            else if ((MessageMod = 100) or (MessageMod = 300)) then BroadcastType := 5
            else BroadcastType := 1;
        end else begin
            if (MessageMod > 5) then
                BroadcastType := 1
            else BroadcastType := MessageMod;
        end;

        // BroadcastType = 1 is just the string sent
        if BroadcastType = 2 then str := tc.Name + ' : ' + str; // displays characters name with it
        if BroadcastType = 3 then str := 'blue' + tc.Name + ' : ' +str; //displays character name and in blue
        if BroadcastType = 5 then str := 'blue' + str;        //  Blue String Broadcast
        if ((NPCReferal) and (Assigned(NPC))) then begin
            if BroadcastType = 4 then str := 'blue' + NPC.Name + ' : ' +str; //displays npc name and in blue
            if BroadcastType = 0 then str := NPC.Name + ' : ' + str; // Null (0): displays npc name with it
        end;
        if tc1.Login = 2 then begin
            w := Length(str) + 4;
            WFIFOW(0, $009a);
            WFIFOW(2, w);
            WFIFOS(4, str, w - 4);
            tc1.Socket.SendBuf(buf, w);
        end;
    end;

    function JIDFixer(ID:integer) : integer;
    begin
        if (ID > UPPER_JOB_BEGIN) then
            Result :=  ID - UPPER_JOB_BEGIN + LOWER_JOB_END // (RN 4001 - 4000 + 23 = 24
        else Result := ID;
    end;


    function get_nowguildid() : Integer;
    var
        basepath, pfile : String;
        resultlist : TStringList;
    begin
        resultlist := TStringList.Create;
        basepath := AppPath + 'gamedata\Guilds\';
        pfile := 'Members.txt';
        resultlist := get_list(basepath, pfile);
        resultlist.Sort;
        if (resultlist.Count = 0) then Result := 1
        else Result := reed_convert_type(resultlist[resultlist.Count-1], 0, 0, basepath+resultlist[resultlist.Count-1])+1;
        resultlist.Free;
    end;


    procedure console(str : String);
    begin
        debugout.Lines.Add('[' + TimeToStr(Now) + '] ' + str);
    end;

end.
