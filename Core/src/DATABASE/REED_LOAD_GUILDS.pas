unit REED_LOAD_GUILDS;

interface

uses
    Common, REED_Support,
    Classes, SysUtils;

    procedure PD_Load_Guilds_Pre_Parse(UID : String = '*');
    procedure PD_Load_Guilds_Parse(UID : String; resultlist : TStringList; basepath : String);

    procedure PD_Load_Guilds_Settings(tg : TGuild; path : String);
    procedure PD_Load_Guilds_Members(tg : TGuild; path : String);
    procedure PD_Load_Guilds_Positions(tg : TGuild; path : String);
    procedure PD_Load_Guilds_Skills(tg : TGuild; path : String);
    procedure PD_Load_Guilds_BanList(tg : TGuild; path : String);
    procedure PD_Load_Guilds_Diplomacy(tg : TGuild; path : String);
    procedure PD_Load_Guilds_Storage(tg : TGuild; path : String);

implementation

    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Guilds Pre Parse --------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Guilds_Pre_Parse(UID : String = '*');
    var
        basepath : String;
        pfile : String;
    begin
        basepath := AppPath + 'gamedata\Guilds\';
        pfile := 'Guild.txt';
        PD_Load_Guilds_Parse(UID, get_list(basepath, pfile), basepath);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Guilds Parse ------------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Guilds_Parse(UID : String; resultlist : TStringList; basepath : String);
    var
        i : Integer;
        pfile : String;
        path : String;
        tg : TGuild;
    begin

        for i := 0 to resultlist.Count - 1 do begin
            path := basepath + resultlist[i] + '\';

            tg := select_load_guild(UID, reed_convert_type(resultlist[i], 0, -1));
            if not assigned(tg) then Continue;

            if (UID <> '*') then
                if guild_is_online(tg) then Continue;

            pfile := 'Guild.txt';
            PD_Load_Guilds_Settings(tg, path + pfile);

            pfile := 'Members.txt';
            PD_Load_Guilds_Members(tg, path + pfile);

            pfile := 'Positions.txt';
            PD_Load_Guilds_Positions(tg, path + pfile);

            pfile := 'Skills.txt';
            PD_Load_Guilds_Skills(tg, path + pfile);

            pfile := 'BanList.txt';
            PD_Load_Guilds_BanList(tg, path + pfile);

            pfile := 'Diplomacy.txt';
            PD_Load_Guilds_Diplomacy(tg, path + pfile);

            pfile := 'Storage.txt';
            PD_Load_Guilds_Storage(tg, path + pfile);

            if (UID = '*') then begin
                GuildList.AddObject(tg.ID, tg);
            end;

        end;

        FreeAndNil(resultlist);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Guilds Settings ---------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Guilds_Settings(tg : TGuild; path : String);
    var
        datafile : TStringList;
    begin
        datafile := TStringList.Create;

        datafile.Clear;
        datafile.LoadFromFile(path);

        tg.Name := retrieve_data(0, datafile, path);
        tg.ID := retrieve_data(1, datafile, path, 1);
        tg.LV := retrieve_data(2, datafile, path, 1);
        tg.EXP := retrieve_data(3, datafile, path, 1);
        tg.NextEXP := GExpTable[tg.LV];
        tg.GSkillPoint := retrieve_data(4, datafile, path, 1);
        tg.Notice[0] := retrieve_data(5, datafile, path);
        tg.Notice[1] := retrieve_data(6, datafile, path);
        tg.Agit := retrieve_data(7, datafile, path);
        tg.Emblem := retrieve_data(8, datafile, path, 1);
        tg.Present := retrieve_data(9, datafile, path, 1);
        tg.DisposFV := retrieve_data(10, datafile, path, 1);
        tg.DisposRW := retrieve_data(11, datafile, path, 1);

        FreeAndNil(datafile);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Guilds Members ----------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Guilds_Members(tg : TGuild; path : String);
    var
        i : Integer;
        tc : TChara;
        datafile : TStringList;
    begin
        datafile := TStringList.Create;

        datafile.Clear;
        datafile.LoadFromFile(path);

        { -- Clear Member List -- }
        for i := 0 to tg.RegUsers - 1 do begin
            if Chara.IndexOf(tg.MemberID[i]) = -1 then Continue;
            tc := Chara.Objects[Chara.IndexOf(tg.MemberID[i])] as TChara;

            tc.GuildName := '';
            tc.GuildID := 0;
            tc.ClassName := '';
            tc.GuildPos := 0;

            if (i = 0) then tg.MasterName := '';
            tg.Member[i] := nil;
            tg.SLV := 0;
        end;
        tg.RegUsers := 0;
        { -- Clear Member List -- }

        { -- Assign Members -- }
        for i := 0 to retrieve_length(datafile, path) do begin
            tg.MemberID[i] := retrieve_value(datafile, path, i, 0);
            tg.MemberPos[i] := retrieve_value(datafile, path, i, 1);
            tg.MemberEXP[i] := retrieve_value(datafile, path, i, 2);

            if Chara.IndexOf(tg.MemberID[i]) = -1 then begin
                tg.MemberID[i] := 0;
                Continue;
            end;

            if ((tg.MemberID[i]) <> 0) then Inc(tg.RegUsers, 1);
            tc := Chara.Objects[Chara.IndexOf(tg.MemberID[i])] as TChara;

            tc.GuildName := tg.Name;
            tc.GuildID := tg.ID;
            tc.ClassName := tg.PosName[tg.MemberPos[i]];
            tc.GuildPos := i;

            if (i = 0) then tg.MasterName := tc.Name;
            tg.Member[i] := tc;
            tg.SLV := tg.SLV + tc.BaseLV;
        end;
        { -- Assign Members -- }

        FreeAndNil(datafile);

    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Guilds Positions --------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Guilds_Positions(tg : TGuild; path : String);
    var
        i : Integer;
        datafile : TStringList;
    begin
        datafile := TStringList.Create;

        datafile.Clear;
        datafile.LoadFromFile(path);

        for i := 0 to 19 do begin
            tg.PosName[i] := retrieve_value(datafile,path, i, 4);

            if (retrieve_value(datafile, path, i, 1) = 'Y') then tg.PosInvite[i] := True
            else tg.PosInvite[i] := False;

            if (retrieve_value(datafile, path, i, 2) = 'Y') then tg.PosPunish[i] := True
            else tg.PosPunish[i] := False;

            tg.PosEXP[i] := retrieve_value(datafile, path, i, 3);
        end;

        FreeAndNil(datafile);

    end;
    { ------------------------------------------------------------------------------------- }
    

    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Guilds Skills ------------------------------------------------------ }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Guilds_Skills(tg : TGuild; path : String);
    var
        i, skillindex : Integer;
        datafile : TStringList;
    begin
        datafile := TStringList.Create;

        datafile.Clear;
        datafile.LoadFromFile(path);

        for i := 10000 to 10004 do begin
            if GSkillDB.IndexOf(i) = -1 then Continue;
            tg.GSkill[i].Data := GSkillDB.IndexOfObject(i) as TSkillDB;
        end;

        for i := 0 to retrieve_length(datafile, path) do begin
            skillindex := retrieve_value(datafile, path, i, 0);
            if GSkillDB.IndexOf(skillindex) = -1 then Continue;
            tg.GSkill[skillindex].Lv := retrieve_value(datafile, path, i, 1);
            tg.GSkill[skillindex].Card := False;
        end;

        tg.MaxUsers := 16;
        if (tg.GSkill[10004].Lv > 0) then
            tg.MaxUsers := tg.MaxUsers + tg.GSkill[10004].Data.Data1[tg.GSkill[10004].Lv];

        FreeAndNil(datafile);

    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Guilds BanList ----------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Guilds_BanList(tg : TGuild; path : String);
    var
        i : Integer;
        tgb : TGBan;
        datafile : TStringList;
    begin
        datafile := TStringList.Create;

        datafile.Clear;
        datafile.LoadFromFile(path);

        { -- Clear existing BanList -- }
        if (tg.GuildBanList.Count > 0) then begin
            for i := 0 to tg.GuildBanList.Count - 1 do begin
                if assigned(tg.GuildBanList.Objects[i]) then
                    tg.GuildBanList.Objects[i].Free;
            end;
            tg.GuildBanList.Clear;
        end;
        { -- Clear existing BanList -- }

        for i := 0 to retrieve_length(datafile, path) do begin
            tgb := TGBan.Create;

            tgb.Name := retrieve_value(datafile, path, i, 0);
            tgb.AccName := retrieve_value(datafile, path, i, 1);
            tgb.Reason := retrieve_value(datafile, path, i, 2);

            tg.GuildBanList.AddObject(tgb.Name, tgb);
        end;

        FreeAndNil(datafile);

    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Guilds Diplomacy --------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Guilds_Diplomacy(tg : TGuild; path : String);
    var
        i : Integer;
        tgl : TGRel;
        datafile : TStringList;
    begin

        datafile := TStringList.Create;

        datafile.Clear;
        datafile.LoadFromFile(path);

        { -- Clear existing Diplomacy List -- }
        if (tg.RelAlliance.Count > 0) then begin
            for i := 0 to tg.RelAlliance.Count - 1 do begin
                if assigned(tg.RelAlliance.Objects[i]) then
                    tg.RelAlliance.Objects[i].Free;
            end;
            tg.RelAlliance.Clear;
        end;

        if (tg.RelHostility.Count > 0) then begin
            for i := 0 to tg.RelHostility.Count - 1 do begin
                if assigned(tg.RelHostility.Objects[i]) then
                    tg.RelHostility.Objects[i].Free;
            end;
            tg.RelHostility.Clear;
        end;
        { -- Clear existing Diplomacy List -- }

        for i := 0 to retrieve_length(datafile, path) do begin
            tgl := TGRel.Create;

            tgl.ID := retrieve_value(datafile, path, i, 0);
            tgl.GuildName := retrieve_value(datafile, path, i, 2);

            if (retrieve_value(datafile, path, i, 1) = 'A') then
                tg.RelAlliance.AddObject(tgl.GuildName, tgl)
            else if (retrieve_value(datafile, path, i, 1) = 'H') then
                tg.RelHostility.AddObject(tgl.GuildName, tgl)
            else
                Continue;
        end;

        FreeAndNil(datafile);

    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Guilds Storage ----------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Guilds_Storage(tg : TGuild; path : String);
    begin
        retrieve_inventories(path, tg.Storage.Item);
    end;
    { ------------------------------------------------------------------------------------- }

end.
