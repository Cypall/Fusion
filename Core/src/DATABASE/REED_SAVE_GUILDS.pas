unit REED_SAVE_GUILDS;

interface

uses
    Common, REED_Support,
    Classes, SysUtils;

    procedure PD_Save_Guilds_Parse(forced : Boolean = False);

    procedure PD_Save_Guilds_Basic(tg : TGuild; datafile : TStringList);
    procedure PD_Save_Guilds_Members(tg : TGuild; datafile : TStringList);
    procedure PD_Save_Guilds_Positions(tg : TGuild; datafile : TStringList);
    procedure PD_Save_Guilds_Skills(tg : TGuild; datafile : TStringList);
    procedure PD_Save_Guilds_BanList(tg : TGuild; datafile : TStringList);
    procedure PD_Save_Guilds_Diplomacy(tg : TGuild; datafile : TStringList);
    procedure PD_Save_Guilds_Storage(tg : TGuild; datafile : TStringList);

implementation

    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Guilds Parse ------------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Guilds_Parse(forced : Boolean = False);
    var
        datafile : TStringList;
        i, j : Integer;
        tg : TGuild;
        path : String;
        pfile : String;
    begin
        datafile := TStringList.Create;

        for i := 0 to GuildList.Count - 1 do begin
            tg := GuildList.Objects[i] as TGuild;
            if (not guild_is_online(tg)) and (not forced) then Continue;
            if not guild_is_current(tg.ID) then Continue;
            
            datafile.Clear;

            path := AppPath + 'gamedata\Guilds';

            pfile := 'Guild.txt';
            PD_Save_Guilds_Basic(tg, datafile);
            reed_savefile(tg.ID, datafile, path, pfile);

            pfile := 'Members.txt';
            PD_Save_Guilds_Members(tg, datafile);
            reed_savefile(tg.ID, datafile, path, pfile);

            pfile := 'Positions.txt';
            PD_Save_Guilds_Positions(tg, datafile);
            reed_savefile(tg.ID, datafile, path, pfile);

            pfile := 'Skills.txt';
            PD_Save_Guilds_Skills(tg, datafile);
            reed_savefile(tg.ID, datafile, path, pfile);

            pfile := 'BanList.txt';
            PD_Save_Guilds_BanList(tg, datafile);
            reed_savefile(tg.ID, datafile, path, pfile);

            pfile := 'Diplomacy.txt';
            PD_Save_Guilds_Diplomacy(tg, datafile);
            reed_savefile(tg.ID, datafile, path, pfile);

            pfile := 'Storage.txt';
            PD_Save_Guilds_Storage(tg, datafile);
            reed_savefile(tg.ID, datafile, path, pfile);
        end;

        datafile.Clear;
        FreeAndNil(datafile);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Guilds Basic ------------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Guilds_Basic(tg : TGuild; datafile : TStringList);
    begin
        datafile.Add('NAM : ' + tg.Name);
        datafile.Add('GID : ' + IntToStr(tg.ID));
        datafile.Add('GLV : ' + IntToStr(tg.LV));
        datafile.Add('EXP : ' + IntToStr(tg.EXP));
        datafile.Add('SKP : ' + IntToStr(tg.GSkillPoint));
        datafile.Add('NT1 : ' + tg.Notice[0]);
        datafile.Add('NT2 : ' + tg.Notice[1]);
        datafile.Add('AGT : ' + tg.Agit);
        datafile.Add('EMB : ' + IntToStr(tg.Emblem));
        datafile.Add('PSN : ' + IntToStr(tg.Present));
        datafile.Add('DFV : ' + IntToStr(tg.DisposFV));
        datafile.Add('DRW : ' + IntToStr(tg.DisposRW));
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Guilds Members ----------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Guilds_Members(tg : TGuild; datafile : TStringList);
    var
        i : Integer;
        masterflag : Boolean;
        str : String;
    begin
        datafile.Add(' CID    : PO : EXP        ');
        datafile.Add('--------------------------');

        masterflag := True;
        for i := 0 to tg.RegUsers - 1 do begin

            if tg.MemberID[i] = 0 then Continue;
            if not assigned(tg.Member[i]) then Continue;
            if tg.Member[i].GuildID <> tg.ID then Continue;

            if masterflag then begin
                tg.MemberPOS[i] := 0;
                masterflag := False;
            end;

            str := ' ';
            str := str + reed_column_align(IntToStr(tg.MemberID[i]), 0);
            str := str + reed_column_align(IntToStr(tg.MemberPOS[i]), 2);
            str := str + reed_column_align(IntToStr(tg.MemberEXP[i]), 10, False);

            datafile.Add(str);
        end;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Guilds Positions --------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Guilds_Positions(tg : TGuild; datafile : TStringList);
    var
        i : Integer;
        str : String;
    begin
        datafile.Add(' ID : I : P : XP : NAME');
        datafile.Add('----------------------------------------------------------');

        for i := 0 to 19 do begin
            str := ' ';

            if i < 9 then
                str := str + reed_column_align(IntToStr(i+1), 2)
            else
                str := str + reed_column_align(IntToStr(i+1), 1);

            if (tg.PosInvite[i])
                then str := str + reed_column_align('Y', 0)
                else str := str + reed_column_align('N', 0);

            if (tg.PosPunish[i])
                then str := str + reed_column_align('Y', 0)
                else str := str + reed_column_align('N', 0);

            str := str + reed_column_align(IntToStr(tg.PosEXP[i]), 2);
            str := str + reed_column_align(tg.PosName[i], 0, False);

            datafile.Add(str);
        end;
        
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Guilds Skills ------------------------------------------------------ }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Guilds_Skills(tg : TGuild; datafile : TStringList);
    var
        i : Integer;
        str : String;
    begin
        datafile.Add(' SK ID : LV : SKILL NAME');
        datafile.Add('-------------------------------');

        for i := 10000 to 10004 do begin
            if tg.GSkill[i].LV = 0 then Continue;
            str := ' ';

            str := str + reed_column_align(IntToStr(i), 0);
            str := str + reed_column_align(IntToStr(tg.GSkill[i].LV), 2);
            str := str + reed_column_align(tg.GSkill[i].Data.IDC, 0, False);

            datafile.Add(str);
        end;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Guilds BanList ----------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Guilds_BanList(tg : TGuild; datafile : TStringList);
    var
        i : Integer;
        str : String;
        tgb : TGBan;
    begin
        datafile.Add(' CHARACTER NAME          : ACCOUNT NAME            : BAN REASON');
        datafile.Add('------------------------------------------------------------------------------------------------------');

        for i := 0 to tg.GuildBanList.Count - 1 do begin
            tgb := tg.GuildBanList.Objects[i] as TGBan;
            if (tgb = nil) then Continue;

            str := ' ';

            str := str + reed_column_align(tgb.Name, 23);
            str := str + reed_column_align(tgb.AccName, 23);
            str := str + reed_column_align(tgb.Reason, 0, False);

            datafile.Add(str);
        end;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Guilds Diplomacy --------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Guilds_Diplomacy(tg : TGuild; datafile : TStringList);
    var
        i : Integer;
        str : String;
        tgl : TGRel;
    begin
        datafile.Add(' GID    : T : GUILD NAME');
        datafile.Add('-----------------------------------------------------');

        for i := 0 to tg.RelAlliance.Count - 1 do begin
            tgl := tg.RelAlliance.Objects[i] as TGRel;
            if (tgl = nil) then Continue;

            str := ' ';

            str := str + reed_column_align(IntToStr(tgl.ID), 6);
            str := str + reed_column_align('A', 1);
            str := str + reed_column_align(tgl.GuildName, 0, False);

            datafile.Add(str);
        end;

        for i := 0 to tg.RelHostility.Count - 1 do begin
            tgl := tg.RelHostility.Objects[i] as TGRel;
            if (tgl = nil) then Continue;

            str := ' ';

            str := str + reed_column_align(IntToStr(tgl.ID), 5);
            str := str + reed_column_align('H', 0);
            str := str + reed_column_align(tgl.GuildName, 0, False);

            datafile.Add(str);
        end;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Guilds Storage ----------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Guilds_Storage(tg : TGuild; datafile : TStringList);
    begin
        compile_inventories(datafile, tg.Storage.Item);
    end;
    { ------------------------------------------------------------------------------------- }

end.
