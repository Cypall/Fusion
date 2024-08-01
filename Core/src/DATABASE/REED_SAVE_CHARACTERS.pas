unit REED_SAVE_CHARACTERS;

interface

uses
    Common, REED_Support,
    Classes, SysUtils;

    procedure PD_Save_Characters_Parse(forced : Boolean = False; chara_id : Integer = 0);

    procedure PD_Save_Characters_Basic(tc : TChara; datafile : TStringList);
    procedure PD_Save_Characters_Memos(tc : TChara; datafile : TStringList);
    procedure PD_Save_Characters_Skills(tc : TChara; datafile : TStringList);
    procedure PD_Save_Characters_Inventory(tc : TChara; datafile : TStringList);
    procedure PD_Save_Characters_Cart(tc : TChara; datafile : TStringList);
    procedure PD_Save_Characters_Variables(tc : TChara; datafile : TStringList);

implementation

    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Characters Parse --------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Characters_Parse(forced : Boolean = False; chara_id : Integer = 0);
    var
        datafile : TStringList;
        i : Integer;
        tc : TChara;
        tp : TPlayer;
        path : String;
        pfile : String;
    begin
        datafile := TStringList.Create;

        for i := 0 to Chara.Count - 1 do begin
            datafile.Clear;

            if not (chara_id = 0) then
                tc := Chara.Objects[Chara.IndexOf(chara_id)] as TChara
            else
                tc := Chara.Objects[i] as TChara;
            
            tp := tc.PData;

            if not assigned(tp) then Continue;
            if (not tp.Login) and (not forced) then Continue;

            path := AppPath + 'gamedata\Accounts\' + IntToStr(tp.ID) + '\Characters';

            pfile := 'Character.txt';
            PD_Save_Characters_Basic(tc, datafile);
            reed_savefile(tc.CID, datafile, path, pfile);

            pfile := 'ActiveMemos.txt';
            PD_Save_Characters_Memos(tc, datafile);
            reed_savefile(tc.CID, datafile, path, pfile);

            pfile := 'Skills.txt';
            PD_Save_Characters_Skills(tc, datafile);
            reed_savefile(tc.CID, datafile, path, pfile);

            pfile := 'Inventory.txt';
            PD_Save_Characters_Inventory(tc, datafile);
            reed_savefile(tc.CID, datafile, path, pfile);

            pfile := 'Cart.txt';
            PD_Save_Characters_Cart(tc, datafile);
            reed_savefile(tc.CID, datafile, path, pfile);

            pfile := 'Variables.txt';
            PD_Save_Characters_Variables(tc, datafile);
            reed_savefile(tc.CID, datafile, path, pfile);

            if not (chara_id = 0) then Break;
        end;

        FreeAndNil(datafile);
    end;
    { ------------------------------------------------------------------------------------- }

    
    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Characters Basic --------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Characters_Basic(tc : TChara; datafile : TStringList);
    begin
        datafile.Add('NAM : ' + tc.Name);
        datafile.Add('AID : ' + IntToStr(tc.ID));
        datafile.Add('CID : ' + IntToStr(tc.CID));

        if (tc.JID > UPPER_JOB_BEGIN) then datafile.Add('JID : ' + IntToStr(tc.JID - UPPER_JOB_BEGIN + LOWER_JOB_END))
        else datafile.Add('JID : ' + IntToStr(tc.JID));

        datafile.Add('BLV : ' + IntToStr(tc.BaseLV));
        datafile.Add('BXP : ' + IntToStr(tc.BaseEXP));
        datafile.Add('STP : ' + IntToStr(tc.StatusPoint));
        datafile.Add('JLV : ' + IntToStr(tc.JobLV));
        datafile.Add('JXP : ' + IntToStr(tc.JobEXP));
        datafile.Add('SKP : ' + IntToStr(tc.SkillPoint));
        datafile.Add('ZEN : ' + IntToStr(tc.Zeny));

        datafile.Add('ST1 : ' + IntToStr(tc.Stat1));
        datafile.Add('ST2 : ' + IntToStr(tc.Stat2));
        datafile.Add('OPT : ' + IntToStr(tc.Option and $FFF9));
        datafile.Add('KAR : ' + IntToStr(tc.Karma));
        datafile.Add('MAN : ' + IntToStr(tc.Manner));

        if tc.HP < 0 then tc.HP := 0;
        if tc.SP < 0 then tc.SP := 0;

        datafile.Add('CHP : ' + IntToStr(tc.HP));
        datafile.Add('CSP : ' + IntToStr(tc.SP));
        datafile.Add('SPD : ' + IntToStr(tc.DefaultSpeed));
        datafile.Add('HAR : ' + IntToStr(tc.Hair));
        datafile.Add('C_2 : ' + IntToStr(tc._2));
        datafile.Add('C_3 : ' + IntToStr(tc._3));
        datafile.Add('WPN : ' + IntToStr(tc.Weapon));
        datafile.Add('SHD : ' + IntToStr(tc.Shield));
        datafile.Add('HD1 : ' + IntToStr(tc.Head1));
        datafile.Add('HD2 : ' + IntToStr(tc.Head2));
        datafile.Add('HD3 : ' + IntToStr(tc.Head3));
        datafile.Add('HCR : ' + IntToStr(tc.HairColor));
        datafile.Add('CCR : ' + IntToStr(tc.ClothesColor));

        datafile.Add('STR : ' + IntToStr(tc.ParamBase[0]));
        datafile.Add('AGI : ' + IntToStr(tc.ParamBase[1]));
        datafile.Add('VIT : ' + IntToStr(tc.ParamBase[2]));
        datafile.Add('INT : ' + IntToStr(tc.ParamBase[3]));
        datafile.Add('DEX : ' + IntToStr(tc.ParamBase[4]));
        datafile.Add('LUK : ' + IntToStr(tc.ParamBase[5]));

        datafile.Add('CNR : ' + IntToStr(tc.CharaNumber));

        datafile.Add('MAP : ' + tc.Map);
        datafile.Add('MPX : ' + IntToStr(tc.Point.X));
        datafile.Add('MPY : ' + IntToStr(tc.Point.Y));

        datafile.Add('MSP : ' + tc.SaveMap);
        datafile.Add('MSX : ' + IntToStr(tc.SavePoint.X));
        datafile.Add('MSY : ' + IntToStr(tc.SavePoint.Y));

        datafile.Add('PLG : ' + IntToStr(tc.Plag));
        datafile.Add('PLV : ' + IntToStr(tc.PLv));

        datafile.Add('GID : ' + IntToStr(tc.GuildID));
        datafile.Add('PID : ' + IntToStr(tc.PartyID));
    end;
    { ------------------------------------------------------------------------------------- }

    
    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Characters Memos --------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Characters_Memos(tc : TChara; datafile : TStringList);
    var
        i : Integer;
    begin
        for i := 0 to 2 do begin
            datafile.Add('M'+IntToStr(i+1)+'N : ' + tc.MemoMap[i]);
            datafile.Add('M'+IntToStr(i+1)+'X : ' + IntToStr(tc.MemoPoint[i].X));
            datafile.Add('M'+IntToStr(i+1)+'Y : ' + IntToStr(tc.MemoPoint[i].Y));
        end;
    end;
    { ------------------------------------------------------------------------------------- }

    
    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Characters Skills -------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Characters_Skills(tc : TChara; datafile : TStringList);
    var
        i, j : Integer;
        len : Integer;
        str : String;
    begin
        datafile.Add(' SID : LV : NAME');
        datafile.Add('----------------------------------');

        for i := 1 to MAX_SKILL_NUMBER do begin
            if tc.Skill[i].Lv = 0 then Continue;
            
            str := ' ';

            len := length(IntToStr(i));
            for j := 0 to (3 - len) - 1 do begin
                str := str + ' ';
            end;
            str := str + IntToStr(i);
            str := str + ' : ';

            len := length(IntToStr(tc.Skill[i].Lv));
            for j := 0 to (2 - len) - 1 do begin
                str := str + ' ';
            end;
            str := str + IntToStr(tc.Skill[i].Lv);

            str := str + ' : ' + tc.Skill[i].Data.IDC;
            datafile.Add(str);
        end;
    end;
    { ------------------------------------------------------------------------------------- }

    
    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Characters Inventory ----------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Characters_Inventory(tc : TChara; datafile : TStringList);
    begin
        compile_inventories(datafile, tc.Item);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Characters Cart----------------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Characters_Cart(tc : TChara; datafile : TStringList);
    begin
        compile_inventories(datafile, tc.Cart.Item);
    end;
    { ------------------------------------------------------------------------------------- }


    { ------------------------------------------------------------------------------------- }
    { - R.E.E.D - Save Characters Variables ----------------------------------------------- }
    { ------------------------------------------------------------------------------------- }
    procedure PD_Save_Characters_Variables(tc : TChara; datafile : TStringList);
    var
        k : Integer;
    begin
        for k := 0 to tc.Flag.Count - 1 do begin
            if ((Copy(tc.Flag.Names[k], 1, 1) <> '@') and (Copy(tc.Flag.Names[k], 1, 2) <> '$@'))
            and ((tc.Flag.Values[tc.Flag.Names[k]] <> '0') and (tc.Flag.Values[tc.Flag.Names[k]] <> '')) then begin
                datafile.Add(tc.Flag.Strings[k]);
            end;
        end;
    end;
    { ------------------------------------------------------------------------------------- }

end.
