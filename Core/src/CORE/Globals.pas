unit Globals;

interface

uses
    MMSystem, Classes, SysUtils,
    Common, SQLData,
    Zip, List32;

    function check_attack_lag(tc : TChara) : Boolean;

    procedure reset_skill_effects(tc : TChara);
    procedure remove_equipcard_skills(tc : TChara; idx : Integer);

    procedure leave_party(tc : TChara);
    procedure leave_guild(tc : TChara);
    procedure ban_guild(tc : TChara);

    procedure message_green(tc : TChara; str : String);
    procedure message_yellow(tc : TChara; str : String);
    procedure message_blue(tc : TChara; str : String);

    procedure backup_txt_database();

implementation

uses
	Main;

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

                PartyNameList.Delete(PartyNameList.IndexOf(tpa.Name));
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
        	guildlist.Delete(j);
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
        tc.Socket.SendBuf(buf, length(str) + 5);
    end;

    procedure message_yellow(tc : TChara; str : String);
    begin
        WFIFOW(0, $009a);
        WFIFOW(2, length(str) + 5);
        WFIFOS(4, str, length(str) + 1);
        tc.Socket.SendBuf(buf, length(str) + 5);
    end;

    procedure message_blue(tc : TChara; str : String);
    begin
        WFIFOW(0, $009a);
        WFIFOW(2, length(str) + 9);
        WFIFOS(4, 'blue'+str, length(str) + 4);
        tc.Socket.SendBuf(buf, length(str) + 9);
    end;

    procedure backup_txt_database();
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
	    zfile := tzip.create(frmMain);
    	zfile.Filename := AppPath + 'backup\' + filename + '.zip';

	    fileslist := tstringlist.Create;
    	fileslist.Add(AppPath + 'chara.txt');
	    fileslist.Add(AppPath + 'gcastle.txt');
    	fileslist.Add(AppPath + 'guild.txt');
	    fileslist.Add(AppPath + 'party.txt');
    	fileslist.Add(AppPath + 'pet.txt');
	    fileslist.Add(AppPath + 'player.txt');
        fileslist.Add(AppPath + 'status.txt');

	    zfile.FileSpecList := fileslist;
    	zfile.Add;
	    zfile.Free;

    	fileslist.Free;
    end;

end.