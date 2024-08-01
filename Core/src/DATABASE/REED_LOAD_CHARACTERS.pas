unit REED_LOAD_CHARACTERS;

interface

uses
    Common, REED_Support,
    Classes, SysUtils, Forms;

    procedure PD_Load_Characters_Startup(UID : String; path : String);

    procedure PD_Load_Characters_Parse(UID : String = '*');

    procedure PD_Load_Characters(UID : String; tp : TPlayer; resultlist : TStringList; basepath : String; pfile : String);
    procedure PD_Load_Characters_Memos(UID : String; tp : TPlayer; resultlist : TStringList; basepath : String; pfile : String);
    procedure PD_Load_Characters_Skills(UID : String; tp : TPlayer; resultlist : TStringList; basepath : String; pfile : String);
    procedure PD_Load_Characters_Inventory(UID : String; tp : TPlayer; resultlist : TStringList; basepath : String; pfile : String);
    procedure PD_Load_Characters_Cart(UID : String; tp : TPlayer; resultlist : TStringList; basepath : String; pfile : String);
    procedure PD_Load_Characters_Variables(UID : String; tp : TPlayer; resultlist : TStringList; basepath : String; pfile : String);

implementation

    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Characters Parser -------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Characters_Startup(UID : String; path : String);
    var
        tp : TPlayer;
        pfile : String;
        dirlist : TStringList;
    begin
        dirlist := TStringList.Create;
        dirlist.Clear;

        tp := Player.Objects[Player.IndexOf(reed_convert_type(UID, 0, -1))] as TPlayer;
        path := path + 'Characters\';

        pfile := 'Character.txt';
        dirlist := get_list(path, pfile);

        pfile := 'Character.txt';
        PD_Load_Characters(UID, tp, dirlist, path, pfile);

        pfile := 'ActiveMemos.txt';
        PD_Load_Characters_Memos(UID, tp, dirlist, path, pfile);

        pfile := 'Skills.txt';
        PD_Load_Characters_Skills(UID, tp, dirlist, path, pfile);

        pfile := 'Inventory.txt';
        PD_Load_Characters_Inventory(UID, tp, dirlist, path, pfile);

        pfile := 'Cart.txt';
        PD_Load_Characters_Cart(UID, tp, dirlist, path, pfile);

        pfile := 'Variables.txt';
        PD_Load_Characters_Variables(UID, tp, dirlist, path, pfile);

        dirlist.Free;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Characters Parser -------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Characters_Parse(UID : String = '*');
    var
        basepath : String;
        path : String;
        pfile : String;
        resultlist : TStringList;
        i : Integer;
        tp : TPlayer;
        dirlist : TStringList;
    begin
        basepath := AppPath+'gamedata\Accounts\';
        pfile := 'Account.txt';
        resultlist := get_list(basepath, pfile);
        dirlist := TStringList.Create;

        for i := 0 to resultlist.Count - 1 do begin
            if Player.IndexOf(reed_convert_type(resultlist[i], 0, -1)) = -1 then Continue;
            tp := Player.Objects[Player.IndexOf(reed_convert_type(resultlist[i], 0, -1))] as TPlayer;

            if (UID = '*') then path := basepath + resultlist[i] + '\Characters\'
            else path := basepath + UID + '\Characters\';

            pfile := 'Character.txt';
            dirlist := get_list(path, pfile);

            pfile := 'Character.txt';
            PD_Load_Characters(UID, tp, dirlist, path, pfile);

            pfile := 'ActiveMemos.txt';
            PD_Load_Characters_Memos(UID, tp, dirlist, path, pfile);

            pfile := 'Skills.txt';
            PD_Load_Characters_Skills(UID, tp, dirlist, path, pfile);

            pfile := 'Inventory.txt';
            PD_Load_Characters_Inventory(UID, tp, dirlist, path, pfile);

            pfile := 'Cart.txt';
            PD_Load_Characters_Cart(UID, tp, dirlist, path, pfile);

            pfile := 'Variables.txt';
            PD_Load_Characters_Variables(UID, tp, dirlist, path, pfile);

            if (UID <> '*') then Break;
        end;

        FreeAndNil(dirlist);
        FreeAndNil(resultlist);
    end;
    { ------------------------------------------------------------------------------------- }
    

    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Characters --------------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Characters(UID : String; tp : TPlayer; resultlist : TStringList; basepath : String; pfile : String);
    var
        path : String;
        i : Integer;
        tc : TChara;
        datafile : TStringList;
    begin
        datafile := TStringList.Create;

        for i := 0 to resultlist.Count - 1 do begin

            path := basepath + resultlist[i] + '\' + pfile;

            datafile.Clear;
            datafile.LoadFromFile(path);
    
            if Chara.IndexOf(reed_convert_type(resultlist[i], 0, -1)) = -1 then begin
                tc := TChara.Create;
            end else begin
                tc := Chara.Objects[Chara.IndexOf(reed_convert_type(resultlist[i], 0, -1))] as TChara;

                if (tc.Name <> tp.CName[0]) and (tc.Name <> tp.CName[1]) and (tc.Name <> tp.CName[2])
                and (tc.Name <> tp.CName[3]) and (tc.Name <> tp.CName[4]) and (tc.Name <> tp.CName[5])
                and (tc.Name <> tp.CName[6]) and (tc.Name <> tp.CName[7]) and (tc.Name <> tp.CName[8]) then begin
                    Continue;
                end;
            end;

            { -- Begin - Retrieve and assign values to character. -- }
            tc.Name := retrieve_data(0, datafile, path);
            tc.ID := retrieve_data(1, datafile, path, 1);
            tc.CID := retrieve_data(2, datafile, path, 1);
    
            tc.JID := retrieve_data(3, datafile, path, 1);
            if (tc.JID > LOWER_JOB_END) then tc.JID := tc.JID - LOWER_JOB_END + UPPER_JOB_BEGIN;
    
            tc.BaseLV := retrieve_data(4, datafile, path, 1);
            tc.BaseEXP := retrieve_data(5, datafile, path, 1);
            tc.StatusPoint := retrieve_data(6, datafile, path, 1);
            tc.JobLV := retrieve_data(7, datafile, path, 1);
            tc.JobEXP := retrieve_data(8, datafile, path, 1);
            tc.SkillPoint := retrieve_data(9, datafile, path, 1);
            tc.Zeny := retrieve_data(10, datafile, path, 1);
            tc.Stat1 := retrieve_data(11, datafile, path, 1);
            tc.Stat2 := retrieve_data(12, datafile, path, 1);
            tc.Option := retrieve_data(13, datafile, path, 1);
            tc.Karma := retrieve_data(14, datafile, path, 1);
            tc.Manner := retrieve_data(15, datafile, path, 1);
            tc.HP := retrieve_data(16, datafile, path, 1);
            tc.SP := retrieve_data(17, datafile, path, 1);
            tc.DefaultSpeed := retrieve_data(18, datafile, path, 1);
            tc.Hair := retrieve_data(19, datafile, path, 1);
            tc._2 := retrieve_data(20, datafile, path, 1);
            tc._3 := retrieve_data(21, datafile, path, 1);
            tc.Weapon := retrieve_data(22, datafile, path, 1);
            tc.Shield := retrieve_data(23, datafile, path, 1);
            tc.Head1 := retrieve_data(24, datafile, path, 1);
            tc.Head2 := retrieve_data(25, datafile, path, 1);
            tc.Head3 := retrieve_data(26, datafile, path, 1);
            tc.HairColor := retrieve_data(27, datafile, path, 1);
            tc.ClothesColor := retrieve_data(28, datafile, path, 1);
            tc.ParamBase[0] := retrieve_data(29, datafile, path, 1);
            tc.ParamBase[1] := retrieve_data(30, datafile, path, 1);
            tc.ParamBase[2] := retrieve_data(31, datafile, path, 1);
            tc.ParamBase[3] := retrieve_data(32, datafile, path, 1);
            tc.ParamBase[4] := retrieve_data(33, datafile, path, 1);
            tc.ParamBase[5] := retrieve_data(34, datafile, path, 1);
            tc.CharaNumber := retrieve_data(35, datafile, path, 1);
            tc.Map := retrieve_data(36, datafile, path);
            tc.Point.X := retrieve_data(37, datafile, path, 1);
            tc.Point.Y := retrieve_data(38, datafile, path, 1);
            tc.SaveMap := retrieve_data(39, datafile, path);
            tc.SavePoint.X := retrieve_data(40, datafile, path, 1);
            tc.SavePoint.Y := retrieve_data(41, datafile, path, 1);
            tc.Plag := retrieve_data(42, datafile, path, 1);
            tc.PLv := retrieve_data(43, datafile, path, 1);
            tc.GuildID := retrieve_data(44, datafile, path, 1);
            tc.PartyID := retrieve_data(45, datafile, path, 1);

            tc.PData := tp;
            { -- End - Retrieve and assign values to character. -- }

            if Chara.IndexOf(reed_convert_type(resultlist[i], 0, -1)) = -1 then begin
                CharaName.AddObject(tc.Name, tc);
                Chara.AddObject(tc.CID, tc);
            end;

            if tc.CID < 100001 then tc.CID := tc.CID + 100001;
            if tc.CID >= NowCharaID then NowCharaID := tc.CID + 1;

        end;

        for i := 0 to 8 do begin
            tp.CData[i] := nil;
            if CharaName.IndexOf(tp.CName[i]) = -1 then Continue;
            tp.CData[i] := CharaName.Objects[CharaName.IndexOf(tp.CName[i])] as TChara;
            tp.CData[i].CharaNumber := i;
            tp.CData[i].ID := tp.ID;
            tp.CData[i].Gender := tp.Gender;
        end;

        FreeAndNil(datafile);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Characters Warp Memo Points ---------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Characters_Memos(UID : String; tp : TPlayer; resultlist : TStringList; basepath : String; pfile : String);
    var
        path : String;
        i, j : Integer;
        tc : TChara;
        datafile : TStringList;
    begin
        datafile := TStringList.Create;

        for i := 0 to resultlist.Count - 1 do begin

            if Chara.IndexOf(reed_convert_type(resultlist[i], 0, -1)) = -1 then Continue;
            tc := Chara.Objects[Chara.IndexOf(reed_convert_type(resultlist[i], 0, -1))] as TChara;

            path := basepath + resultlist[i] + '\' + pfile;

            datafile.Clear;
            datafile.LoadFromFile(path);

            { -- Begin - Retrieve and assign values to character. -- }
            for j := 0 to 2 do begin
                tc.MemoMap[j] := retrieve_data(0+(3*j), datafile, path);
                tc.MemoPoint[j].X := retrieve_data(1+(3*j), datafile, path);
                tc.MemoPoint[j].Y := retrieve_data(2+(3*j), datafile, path);
            end;
            { -- End - Retrieve and assign values to character. -- }
            
        end;

        FreeAndNil(datafile);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Characters Skills -------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Characters_Skills(UID : String; tp : TPlayer; resultlist : TStringList; basepath : String; pfile : String);
    var
        path : String;
        i, j, k : Integer;
        tc : TChara;
        datafile : TStringList;
    begin
        datafile := TStringList.Create;

        for i := 0 to resultlist.Count - 1 do begin

            if Chara.IndexOf(reed_convert_type(resultlist[i], 0, -1)) = -1 then Continue;
            tc := Chara.Objects[Chara.IndexOf(reed_convert_type(resultlist[i], 0, -1))] as TChara;

            for j := 0 to MAX_SKILL_NUMBER do begin
                if SkillDB.IndexOf(j) <> -1 then begin
                    tc.Skill[j].Data := SkillDB.IndexOfObject(j) as TSkillDB;
                    tc.Skill[j].Lv := 0;
                end;
            end;

            if (tc.Plag <> 0) then begin
                tc.Skill[tc.Plag].Plag := True;
            end;

            path := basepath + resultlist[i] + '\' + pfile;

            datafile.Clear;
            datafile.LoadFromFile(path);

            { -- Begin - Retrieve and assign values to character. -- }
            for j := 0 to retrieve_length(datafile, path) do begin

                k := retrieve_value(datafile,path,j,0);
                if SkillDB.IndexOf(k) <> -1 then begin
                    tc.Skill[k].Lv := retrieve_value(datafile,path,j,1);
                    tc.Skill[k].Card := False;
                    tc.Skill[k].Plag := False;
                end;

            end;
            { -- End - Retrieve and assign values to character. -- }
            
        end;

        FreeAndNil(datafile);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Characters Inventory ----------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Characters_Inventory(UID : String; tp : TPlayer; resultlist : TStringList; basepath : String; pfile : String);
    var
        path : String;
        i : Integer;
        tc : TChara;
    begin
        for i := 0 to resultlist.Count - 1 do begin

            if Chara.IndexOf(reed_convert_type(resultlist[i], 0, -1)) = -1 then Continue;
            tc := Chara.Objects[Chara.IndexOf(reed_convert_type(resultlist[i], 0, -1))] as TChara;

            path := basepath + resultlist[i] + '\' + pfile;

            retrieve_inventories(path, tc.Item);

        end;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Characters Cart ---------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Characters_Cart(UID : String; tp : TPlayer; resultlist : TStringList; basepath : String; pfile : String);
    var
        path : String;
        i : Integer;
        tc : TChara;
    begin
        for i := 0 to resultlist.Count - 1 do begin

            if Chara.IndexOf(reed_convert_type(resultlist[i], 0, -1)) = -1 then Continue;
            tc := Chara.Objects[Chara.IndexOf(reed_convert_type(resultlist[i], 0, -1))] as TChara;

            path := basepath + resultlist[i] + '\' + pfile;

            retrieve_inventories(path, tc.Cart.Item);

        end;
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Load Characters Variables ----------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Load_Characters_Variables(UID : String; tp : TPlayer; resultlist : TStringList; basepath : String; pfile : String);
    var
        path : String;
        i, j : Integer;
        tc : TChara;
    begin
        for i := 0 to resultlist.Count - 1 do begin

            if Chara.IndexOf(reed_convert_type(resultlist[i], 0, -1)) = -1 then Continue;
            tc := Chara.Objects[Chara.IndexOf(reed_convert_type(resultlist[i], 0, -1))] as TChara;

            path := basepath + resultlist[i] + '\' + pfile;

            for j := 0 to tc.Flag.Count - 1 do begin
                tc.Flag.Delete(0);
            end;

            tc.Flag := stringlist_load(path);

        end;
    end;
    { ------------------------------------------------------------------------------------- }

end.
