unit Player_Skills;

interface

uses
    {Windows VCL}
    {$IFDEF MSWINDOWS}
    Windows, MMSystem,
    {$ENDIF}
    {Kylix/Delphi CLX}
    {$IFDEF LINUX}
    Qt, Types,
    {$ENDIF}
    {Shared}
    IniFiles, Classes, SysUtils, Math,
    {Fusion}
    Common, List32, Path;

var
    SKILL_TYPE : Byte;

    { Initialization Procedures }
    procedure parse_skills(tc : TChara; Tick : Cardinal; effect : Integer = 0; UseSP : Boolean = True);

    { Finalization Procedures }
    procedure process_effect(tc : TChara; success : Integer; Tick : Cardinal);
    procedure process_skill_attack(tc : TChara; j : Integer; Tick : Cardinal);
    procedure process_skill_splash_attack(tc : TChara; sl : TStringList; Tick : Cardinal);
    procedure process_skill_magic(tc : TChara; j : Integer; Tick : Cardinal);

    { Calculation Procedures }
    procedure use_sp(tc : TChara; SkillID : word; LV : byte);
    function find_targets(tc : TChara; sl : TStringList; rangefield : Integer; playersOnly : Boolean = false) : TStringList;
    function check_allow_pvp(tc : TChara) : Boolean;

    { Skill Procedures - Swordsman }
    function skill_sword_mastery(tc : TChara) : Integer;
    function skill_two_handed_sword_mastery(tc : TChara) : Integer;
    function skill_hp_recovery(tc : TChara; Tick : Cardinal) : Integer;
    function skill_bash(tc : TChara; Tick : Cardinal) : Integer;
    function skill_provoke(tc : TChara) : Integer;
    function skill_magnum_break(tc : TChara; sl : TStringList) : TStringList;
    function skill_endure() : Integer;

    { Skill Procedures - Mage }
    function skill_sp_recovery(tc : TChara; Tick : Cardinal) : Integer;
    function skill_sight(tc : TChara; Tick : Cardinal) : Integer;
    function skill_napalm_beat(tc : TChara; Tick : Cardinal) : Integer;
    function skill_soul_strike(tc : TChara; Tick : Cardinal) : Integer;
    function skill_cold_bolt(tc : TChara; Tick : Cardinal) : Integer;

    { Skill Procedures - Archer }
    function skill_double_strafe(tc : TChara; Tick : Cardinal) : Integer;

implementation

uses
    Main, Skills;

    procedure parse_skills(tc : TChara; Tick : Cardinal; effect : Integer = 0; UseSP : Boolean = True);
    var
        success : Integer;
        targets : TStringList;
    begin
        SKILL_TYPE := 0;

        if not check_allow_pvp(tc) then begin
            if (tc.MSkill = 8) then begin
                tc.SkillTickID := 8;
            end else begin
                exit;
            end;
        end;

        targets := TStringList.Create;
        targets.Clear;

        if ( (effect = 1) and (tc.HP <= 0) ) then effect := -1;

        {
            tc.Skill[x].LV must be used for effect skills that have no target.
            tc.MSkill must be used for active skills that have a target.
            tc.Skill[x].LV must be used for passive skills. Also, passive must be true.
        }

        { 2} if (tc.Skill[2].Lv <> 0) and (effect = 2) then success := skill_sword_mastery(tc);
        { 3} if (tc.Skill[3].Lv <> 0) and (effect = 2) then success := skill_two_handed_sword_mastery(tc);
        { 4} if (tc.Skill[4].Lv <> 0) and (effect = 1) then success := skill_hp_recovery(tc, Tick);
        { 5} if (tc.MSkill = 5) and (effect = 0) then success := skill_bash(tc, Tick);
        { 6} if (tc.MSkill = 6) and (effect = 0) then success := skill_provoke(tc);
        { 7} if (tc.MSkill = 7) and (effect = 0) then targets := skill_magnum_break(tc, targets);
        { 8} if (tc.MSkill = 8) and (effect = 0) then success := skill_endure();
        { 9} if (tc.Skill[9].Lv <> 0) and (effect = 1) then success := skill_sp_recovery(tc, Tick);
        {10} if (tc.MSkill = 10) and (effect = 0) then success := skill_sight(tc, Tick);
        {11} if (tc.MSkill = 11) and (effect = 0) then success := skill_napalm_beat(tc, Tick);
        {13} if (tc.MSkill = 13) and (effect = 0) then success := skill_soul_strike(tc, Tick);
        {14} if (tc.MSkill = 14) and (effect = 0) then success := skill_cold_bolt(tc, Tick);
        {46} if (tc.MSkill = 46) and (effect = 0) then success := skill_double_strafe(tc, Tick);

        {
            Process_Effect Success Codes:
            -1 : Success
            0 : Skill Failed
            1 : Not enough SP
            2 : Not enough HP
            3 : No memo
            4 : In cast delay
            5 : Not enough money
            6 : Weapon is not usable with the skill
            7 : No red gemstone
            8 : No blue gemstone
            9 : No yellow gemstone
        }

        case SKILL_TYPE of
            1: process_effect(tc, success, Tick);
            2: process_effect(tc, success, Tick);
            3: process_skill_attack(tc, success, Tick);
            4: process_skill_splash_attack(tc, targets, Tick);
            5: process_skill_magic(tc, success, Tick);
        end;

        if (UseSP) and ( ( (SKILL_TYPE = 1) and (success = -1) ) or (SKILL_TYPE = 2) or (SKILL_TYPE = 3) or (SKILL_TYPE = 5) ) then begin
            use_sp(tc, tc.MSkill, tc.MUseLV);
        end;

        SKILL_TYPE := 0;
        targets.Free;
    end;

    procedure process_effect(tc : TChara; success : Integer; Tick : Cardinal);
    var
        tm : TMap;
        tc1 : TChara;
        ts : TMob;
        tl : TSkillDB;
    begin
        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        tl := tc.Skill[tc.MSkill].Data;

        if (success = -1) then begin
            WFIFOW( 0, $011a);
            WFIFOW( 2, tc.MSkill);
            WFIFOW( 4, tc.MUseLV);
            WFIFOL( 6, tc.MTarget);
            WFIFOL(10, tc.ID);
            WFIFOB(14, 1);
        end else begin
            WFIFOW( 0, $0110);
            WFIFOW( 2, tc.MSkill);
            WFIFOW( 4, 0);
            WFIFOW( 6, 0);
            WFIFOB( 8, 0);
            WFIFOB( 9, success);
        end;

        if tc.MTargetType = 0 then begin
            ts := tc.AData;
            if (ts.HP <= 0) and (success = -1) then begin
                SKILL_TYPE := 0;
                Exit;
            end;
            SendBCmd(tm, ts.Point, 15);
        end else begin
            tc1 := tc.AData;
            if (tc1.HP <= 0) and (success = -1) then begin
                SKILL_TYPE := 0;
                Exit;
            end;
            SendBCmd(tm, tc1.Point, 15);

            if (SKILL_TYPE = 2) then begin
                tc1.Skill[tc.MSkill].Tick := Tick + cardinal(tl.Data1[tc.MUseLV]) * 1000;
                tc1.Skill[tc.MSkill].EffectLV := tc.MUseLV;
                tc1.Skill[tc.MSkill].Effect1 := tl.Data2[tc.MUseLV];
                if tc.SkillTick > tc1.Skill[tc.MSkill].Tick then begin
                    tc.SkillTick := tc1.Skill[tc.MSkill].Tick;
                    tc.SkillTickID := tc.MSkill;
                end;
                if tc.MSkill = 61 then tc1.Skill[tc.MSkill].Tick := Tick + cardinal(tl.Data1[tc.MUseLV]) * 110;
                CalcStat(tc1, Tick);
                //if ProcessType = 3 then SendCStat(tc1);
                if (tl.Icon <> 0) and (tl.Icon <> 107) then begin
                    UpdateIcon(tm, tc1, tl.Icon, 1);
                end;
            end;
            
        end;
    end;

    procedure process_skill_attack(tc : TChara; j : Integer; Tick : Cardinal);
    var
        ts : TMob;
        tc1 : TChara;
        tm : TMap;
        tl : TSkillDB;
    begin
        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

        { Placed here to prevent attacking self }
        if tc.AData = tc then Exit;

        if dmg[0] < 0 then dmg[0] := 0;
        if tc.MTargetType = 0 then begin
            ts := tc.AData;
            if ts.HP <= 0 then begin
                SKILL_TYPE := 0;
                Exit;
            end;

            SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], j);
            if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then frmMain.StatCalc1(tc, ts, Tick);
        end else begin
            tc1 := tc.AData;
            if tc1.HP <= 0 then begin
                SKILL_TYPE := 0;
                Exit;
            end;

            SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
            if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then frmMain.StatCalc2(tc, tc1, Tick);
        end;
    end;

    procedure process_skill_splash_attack(tc : TChara; sl : TStringList; Tick : Cardinal);
    var
        k1 : Integer;
        tm : TMap;
        tl : TSkillDB;
        ts : TMob;
        tc1 : TChara;
    begin
        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        tl := tc.Skill[tc.MSkill].Data;

        tc1 := tc.AData;

        if dmg[0] < 0 then dmg[0] := 0;
        if sl.Count <> 0 then begin
            for k1 := 0 to sl.Count - 1 do begin
                if (tm.CList.IndexOf(StrToInt(sl.Strings[k1])) <> -1) then begin
                    tc1 := sl.Objects[k1] as TChara;
                    if tc1.HP <= 0 then begin
                        SKILL_TYPE := 0;
                        Exit;
                    end;
                    
                    frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[tc.MUseLV], tl.Element, tl.Data1[tc.MUseLV]);
                    SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
                    if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then frmMain.StatCalc2(tc, tc1, Tick);
                end else begin
                    ts := sl.Objects[k1] as TMob;
                    if ts.HP <= 0 then begin
                        SKILL_TYPE := 0;
                        Exit;
                    end;

                    frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[tc.MUseLV], tl.Element, tl.Data1[tc.MUseLV]);
                    SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
                    if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then frmMain.StatCalc1(tc, ts, Tick);
                end;
            end;
        end;
    end;

    procedure process_skill_magic(tc : TChara; j : Integer; Tick : Cardinal);
    var
        ts : TMob;
        tl : TSkillDB;
        tm : TMap;
        tc1 : Tchara;
    begin
        tm := tc.MData;
        tl := tc.Skill[tc.MSkill].Data;

        if tc.AData = tc then Exit;

        with tc do begin
            dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
            if tc.MTargetType = 0 then begin
                ts := tc.AData;
                if ts.HP <= 0 then begin
                    SKILL_TYPE := 0;
                    Exit;
                end;
                dmg[0] := dmg[0] * (100 - ts.Data.MDEF) div 100; //MDEF%
                dmg[0] := dmg[0] - ts.Data.Param[3]; //MDEF-
                if dmg[0] < 1 then
                    dmg[0] := 1;
                dmg[0] := dmg[0] * ElementTable[tl.Element][ts.Element] div 100;
                dmg[0] := dmg[0] * tl.Data2[MUseLV];
                if dmg[0] < 0 then
                    dmg[0] := 0;

                if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;

                SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], tl.Data2[MUseLV]);
                frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
            end else begin
                tc1 := tc.AData;
                if tc1.HP <= 0 then begin
                    SKILL_TYPE := 0;
                    Exit;
                end;
                dmg[0] := dmg[0] * (100 - tc1.MDEF1) div 100; //MDEF%
                dmg[0] := dmg[0] - tc1.Param[3]; //MDEF-
                if dmg[0] < 1 then
                    dmg[0] := 1;
                dmg[0] := dmg[0] * ElementTable[tl.Element][tc1.ArmorElement] div 100;
                dmg[0] := dmg[0] * (100 - tc1.DamageFixE[1][tl.Element]) div 100;
                dmg[0] := dmg[0] * tl.Data2[MUseLV];
                if dmg[0] < 0 then
                    dmg[0] := 0;

                if (tc1.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;

                SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], tl.Data2[MUseLV]);
                frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
            end;
        end;
    end;

    procedure use_sp(tc : TChara; SkillID : word; LV : byte);
    begin
        tc.SPAmount := 0;

        if SkillID = 0 then Exit;
        if tc.SP < tc.Skill[SkillID].Data.SP[LV] then Exit;

        tc.SPAmount := tc.Skill[SkillID].Data.SP[LV];

        if tc.LessSP then tc.SPAmount := tc.SPAmount * 70 div 100;
        if tc.NoJamstone then tc.SPAmount := tc.SPAmount * 125 div 100;
        if tc.SPRedAmount > 0 then tc.SPAmount := tc.SPAmount - (tc.Skill[SkillID].Data.SP[LV] * tc.SPRedAmount div 100);

        if (tc.Autocastactive) then begin
            tc.SPAmount := tc.SPAmount * 2 div 3;
            tc.Autocastactive := False;
        end;

        // Golen Thief Bug Card (Alex: Should cards be processed here?)
        if tc.NoTarget then tc.SPAmount := tc.SPAmount * 2;

        tc.SP := tc.SP - tc.SPAmount;

        SendCStat1(tc, 0, 7, tc.SP);
        tc.MMode  := 0;
        tc.MSkill := 0;
        tc.MUseLv := 0;
    end;

    function find_targets(tc : TChara; sl : TStringList; rangefield : Integer; playersOnly : Boolean = false) : TStringList;
    var
        j1, i1, k1 : Integer;
        tm : TMap;
        tl : TSkillDB;
        xy : TPoint;
        ts : TMob;
        tc1 : TChara;
        mi : MapTbl;
    begin
        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        mi := MapInfo.Objects[MapInfo.IndexOf(tm.Name)] as MapTbl;
        tl := tc.Skill[tc.MSkill].Data;

        tc1 := tc.AData;
        xy := tc1.Point;

        for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
            for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
              if NOT playersOnly then begin
                for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
                    ts := tm.Block[i1][j1].Mob.Objects[k1] as TMob;

                    if (rangefield = 1) then begin
                        if (abs(ts.Point.X - xy.X) <= tl.Range) and (abs(ts.Point.Y - xy.Y) <= tl.Range) then sl.AddObject(IntToStr(ts.ID),ts);
                    end else if (rangefield = 2) then begin
                        if (abs(ts.Point.X - xy.X) <= tl.Range2) and (abs(ts.Point.Y - xy.Y) <= tl.Range2) then sl.AddObject(IntToStr(ts.ID),ts);
                    end;
                end;
              end;

                for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
                    if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then Continue;
                    tc1 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
                    if (tc = tc1) or ((mi.PvPG = true) and (tc.GuildID = tc1.GuildID) and (tc.GuildID <> 0)) then Continue;

                    if (rangefield = 1) then begin
                        if (abs(tc1.Point.X - xy.X) <= tl.Range) and (abs(tc1.Point.Y - xy.Y) <= tl.Range) then sl.AddObject(IntToStr(tc1.ID),tc1);
                    end else if (rangefield = 2) then begin
                        if (abs(tc1.Point.X - xy.X) <= tl.Range2) and (abs(tc1.Point.Y - xy.Y) <= tl.Range2) then sl.AddObject(IntToStr(tc1.ID),tc1);
                    end;
                end;
            end;
        end;

        Result := sl;
    end;

    function check_allow_pvp(tc : TChara) : Boolean;
    var
    	mi : MapTbl;
    begin
    	mi := MapInfo.Objects[MapInfo.IndexOf(tc.Map)] as MapTbl;

        if (not mi.PvP) and (tc.MTargetType <> 0) then Result := False
        else Result := True;
    end;


    { -------------------------------------------------- }
    { - Job: Swordsman --------------------------------- }
    { - Job ID: 1 -------------------------------------- }
    { - Skill Name: Sword Mastery ---------------------- }
    { - Skill ID Name: SM_SWORD ------------------------ }
    { - Skill ID: 2 ------------------------------------ }
    { -------------------------------------------------- }
    function skill_sword_mastery(tc : TChara) : Integer;
    begin
        if ( (tc.WeaponType[0] = 1) or (tc.WeaponType[0] = 2) ) then begin
            tc.ATK[0][4] := tc.Skill[2].Data.Data1[tc.Skill[2].Lv];
        end;
    end;


    { -------------------------------------------------- }
    { - Job: Swordsman --------------------------------- }
    { - Job ID: 1 -------------------------------------- }
    { - Skill Name: Two-Handed Sword Mastery ----------- }
    { - Skill ID Name: SM_TWOHAND ---------------------- }
    { - Skill ID: 3 ------------------------------------ }
    { -------------------------------------------------- }
    function skill_two_handed_sword_mastery(tc : TChara) : Integer;
    begin
        if (tc.WeaponType[0] = 3) then begin
            tc.ATK[0][4] := tc.Skill[3].Data.Data1[tc.Skill[3].Lv];
        end;
    end;


    { -------------------------------------------------- }
    { - Job: Swordsman --------------------------------- }
    { - Job ID: 1 -------------------------------------- }
    { - Skill Name: HP Recovery ------------------------ }
    { - Skill ID Name: SM_RECOVERY --------------------- }
    { - Skill ID: 4 ------------------------------------ }
    { -------------------------------------------------- }
    function skill_hp_recovery(tc : TChara; Tick : Cardinal) : Integer;
    var
        j : Integer;
    begin
        if (tc.HPRTick + 10000 <= Tick) and (tc.Sit <> 1) and (tc.Option and 6 = 0) then begin
            if tc.HP <> tc.MAXHP then begin
                j := (5 + tc.MAXHP div 500) * tc.Skill[4].Lv;
                if tc.HP + j > tc.MAXHP then j := tc.MAXHP - tc.HP;
                tc.HP := tc.HP + j;
                WFIFOW(0, $013d);
                WFIFOW(2, $0005);
                WFIFOW(4, j);
                tc.Socket.SendBuf(buf, 6);
                SendCStat1(tc, 0, 5, tc.HP);
            end;
            tc.HPRTick := Tick;
        end;
    end;
    
    
    { -------------------------------------------------- }
    { - Job: Swordsman --------------------------------- }
    { - Job ID: 1 -------------------------------------- }
    { - Skill Name: Bash ------------------------------- }
    { - Skill ID Name: SM_BASH ------------------------- }
    { - Skill ID: 5 ------------------------------------ }
    { -------------------------------------------------- }
    function skill_bash(tc : TChara; Tick : Cardinal) : Integer;
    var
        ts : TMob;
        tc1 : TChara;
        tm : TMap;
        tl : TSkillDB;
    begin
        SKILL_TYPE := 3;

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        tl := tc.Skill[tc.MSkill].Data;

        if tc.MTargetType = 0 then begin
            ts := tc.AData;
            frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[tc.MUseLV], tl.Element, tl.Data2[tc.MUseLV]);

            if (tc.Skill[145].Lv <> 0) and (tc.MSkill = 5) and (tc.MUseLV > 5) then begin
                if Random(1000) < tc.Skill[145].Data.Data1[tc.MUseLV] * 10 then begin
                    if (ts.Stat1 <> 3) then begin
                        ts.nStat := 3;
                        ts.BodyTick := Tick + tc.aMotion;
                    end else begin
                        ts.BodyTick := ts.BodyTick + 30000;
                    end;
                end;
            end;
        end else begin
            tc1 := tc.AData;
            frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[tc.MUseLV], tl.Element, tl.Data2[tc.MUseLV]);
        end;

        Result := 1;
    end;


    { -------------------------------------------------- }
    { - Job: Swordsman --------------------------------- }
    { - Job ID: 1 -------------------------------------- }
    { - Skill Name: Provoke ---------------------------- }
    { - Skill ID Name: SM_PROVOKE ---------------------- }
    { - Skill ID: 6 ------------------------------------ }
    { -------------------------------------------------- }
    function skill_provoke(tc : TChara) : Integer;
    var
        ts : TMob;
        tc1 : TChara;
        tm : TMap;
        tl : TSkillDB;
        rand : Integer;
        k, r : Integer;
        rx, ry : Integer;
    begin
        SKILL_TYPE := 1;
        Result := -1;
        
        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        tl := tc.Skill[tc.MSkill].Data;

        rand := Random(100);
        if ( (tc.Skill[tc.MSkill].Lv * 3 + 50) >= rand ) then begin
            { Provoke Successful. % chance checked. } 
            if tc.MTargetType = 0 then begin
                ts := tc.AData;

                if ( (ts.Data.Race <> 1) and (ts.Data.MEXP = 0) ) then begin
                    { PvM: Provoke Succcessful. No Undead or MVP. }
                    ts.ATKPer := word(tl.Data1[tc.MUseLV]);
                    ts.DEFPer := word(tl.Data2[tc.MUseLV]);
                    ts.ATarget := tc.ID;
                    ts.ARangeFlag := false;
                    ts.AData := tc;
                end else begin
                    { PvM: Provoke Failed. Wrong Race/Type. }
                    Result := 0;
                end;
            end else begin
                { PvP: Provoke Successful }
                tc1 := tc.AData;

                if (tc1.Sit <> 1) then begin

                    k := 0;
                    r := 0;
                    while ( (k = 0) and (r < 100) ) do begin
                        Randomize;
                        rx := randomrange(-tc1.Range,tc1.Range) + tc.Point.X;
                        Randomize;
                        ry := randomrange(-tc1.Range,tc1.Range) + tc.Point.Y;
                        k := Path_Finding(tc1.path, tm, tc1.Point.X, tc1.Point.Y, rx, ry, 1);
                        inc(r);
                    end;

                    if ( (rx = tc.Point.X) and (ry = tc.Point.y) ) then k := 0;

                    if ( (k <> 0) ) then begin
                        tc1.NextFlag := true;
                        tc1.nextpoint.X := rx;
                        tc1.nextpoint.Y := ry;
                        tc1.tgtPoint := tc1.NextPoint;
                    end;

                    WFIFOW( 0, $0139);
                    WFIFOL( 2, tc.ID);
                    WFIFOW( 6, tc.Point.X);
                    WFIFOW( 8, tc.Point.Y);
                    WFIFOW(10, tc1.Point.X);
                    WFIFOW(12, tc1.Point.Y);
                    WFIFOW(14, tc1.Range);
                    tc1.Socket.SendBuf(buf, 16);

                    tc1.MTargetType := 1;
                    tc1.AMode := 2;
                    tc1.ATarget := tc.ID;
                    tc1.AData := tc;

                    if tc1.ATick + tc1.ADelay - 200 < timeGetTime() then
                    tc1.ATick := timeGetTime() - tc1.ADelay + 200;

                    tc1.DamageFixS[1] := word(tl.Data1[tc.MUseLV]);
                    tc1.DEF1 := word(tl.Data2[tc.MUseLV]) * tc1.DEF1 div 100;
                end else begin
                    { Provoke failed. Target Dead. }
                    Result := 0;
                end;
            end;
        end else begin
            { Provoke failed. % chance too low. }
            Result := 0;
        end;
    end;


    { -------------------------------------------------- }
    { - Job: Swordsman --------------------------------- }
    { - Job ID: 1 -------------------------------------- }
    { - Skill Name: Magnum Break ----------------------- }
    { - Skill ID Name: SM_MAGNUM ----------------------- }
    { - Skill ID: 7 ------------------------------------ }
    { -------------------------------------------------- }
    function skill_magnum_break(tc : TChara; sl : TStringList) : TStringList;
    begin
        SKILL_TYPE := 4;
        sl := find_targets(tc, sl, 2);
        Result := sl;
    end;


    { -------------------------------------------------- }
    { - Job: Swordsman --------------------------------- }
    { - Job ID: 1 -------------------------------------- }
    { - Skill Name: Endure ----------------------------- }
    { - Skill ID Name: SM_ENDURE ----------------------- }
    { - Skill ID: 8 ------------------------------------ }
    { -------------------------------------------------- }
    function skill_endure() : Integer;
    begin
        SKILL_TYPE := 2;
        Result := -1;
    end;


    { -------------------------------------------------- }
    { - Job: Mage -------------------------------------- }
    { - Job ID: 2 -------------------------------------- }
    { - Skill Name: SP Recovery ------------------------ }
    { - Skill ID Name: MG_SRECOVERY -------------------- }
    { - Skill ID: 9 ------------------------------------ }
    { -------------------------------------------------- }
    function skill_sp_recovery(tc : TChara; Tick : Cardinal) : Integer;
    var
        j : Integer;
    begin
        if (tc.Skill[9].Lv <> 0) and (tc.SPRTick + 10000 <= Tick) and (tc.Sit <> 1 ) and (tc.Option and 6 = 0) then begin
            if tc.SP <> tc.MAXSP then begin
                j := (3 + tc.MAXSP * 2 div 1000) * tc.Skill[9].Lv;
                if tc.SP + j > tc.MAXSP then j := tc.MAXSP - tc.SP;
                tc.SP := tc.SP + j;
                WFIFOW(0, $013d);
                WFIFOW(2, $0007);
                WFIFOW(4, j);
                tc.Socket.SendBuf(buf, 6);
                SendCStat1(tc, 0, 7, tc.SP);
            end;
            tc.SPRTick := Tick;
        end;
    end;


    { -------------------------------------------------- }
    { - Job: Mage -------------------------------------- }
    { - Job ID: 2 -------------------------------------- }
    { - Skill Name: Sight ------------------------------ }
    { - Skill ID Name: MG_SIGHT ------------------------ }
    { - Skill ID: 10 ----------------------------------- }
    { -------------------------------------------------- }
    function skill_sight(tc : TChara; Tick : Cardinal) : Integer;
    var
        tm : TMap;
        tc1 : TChara;
        k1 : Integer;
        sl : TStringList;
    begin
        SKILL_TYPE := 2;
        Result := -1;
        tc.SkillTickID := 10;

        sl := TStringList.Create;
        sl.Clear;

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

        if (tc.MSkill = 10) then tc.Option := tc.Option or 1 else tc.Option := tc.Option or $2000;
        UpdateOption(tm, tc);

        sl := find_targets(tc, sl, 1, true);

        if sl.Count <> 0 then begin
            for k1 := 0 to sl.Count - 1 do begin
                //tc1 := tm.CList.IndexOfObject(tc.MTarget) as TChara;
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

        sl.Free;
    end;


    { -------------------------------------------------- }
    { - Job: Mage -------------------------------------- }
    { - Job ID: 2 -------------------------------------- }
    { - Skill Name: Napalm Beat ------------------------ }
    { - Skill ID Name: MG_NAPALMBEAT ------------------- }
    { - Skill ID: 11 ----------------------------------- }
    { -------------------------------------------------- }
    function skill_napalm_beat(tc : Tchara; Tick : Cardinal) : Integer;
    begin
        SKILL_TYPE := 5;

        tc.MTick := Tick + 1000;
    end;

    { -------------------------------------------------- }
    { - Job: Mage -------------------------------------- }
    { - Job ID: 2 -------------------------------------- }
    { - Skill Name: Soul Strike ------------------------ }
    { - Skill ID Name: MG_SOULSTRIKE ------------------- }
    { - Skill ID: 13 ----------------------------------- }
    { -------------------------------------------------- }
    function skill_soul_strike(tc : Tchara; Tick : Cardinal) : Integer;
    begin
        SKILL_TYPE := 5;

        tc.MTick := Tick +  800 + 400 * ((tc.MUseLV + 1) div 2) - 300 * (tc.MUseLV div 10);
    end;

    { -------------------------------------------------- }
    { - Job: Mage -------------------------------------- }
    { - Job ID: 2 -------------------------------------- }
    { - Skill Name: Cold Bolt -------------------------- }
    { - Skill ID Name: MG_COLDBOLT --------------------- }
    { - Skill ID: 14 ----------------------------------- }
    { -------------------------------------------------- }
    function skill_cold_bolt(tc : Tchara; Tick : Cardinal) : Integer;
    begin
        SKILL_TYPE := 5;

        tc.MTick := Tick +  800 + 200 * tc.MUseLV;
    end;


    { -------------------------------------------------- }
    { - Job: Archer ------------------------------------ }
    { - Job ID: 3 -------------------------------------- }
    { - Skill Name: Double Strafe ---------------------- }
    { - Skill ID Name: AC_DOUBLE ----------------------- }
    { - Skill ID: 46 ----------------------------------- }
    { -------------------------------------------------- }
    function skill_double_strafe(tc : TChara; Tick : Cardinal) : Integer;
    var
        ts : TMob;
        tc1 : TChara;
        tm : TMap;
        tl : TSkillDB;
    begin
        SKILL_TYPE := 3;

        { Alex: We need to reset this to standard damage to prevent doubling. }
        dmg[0] := dmg[0] div 2;

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        tl := tc.Skill[tc.MSkill].Data;

        if (tc.Weapon = 11) then begin
            if tc.MTargetType = 0 then begin
                ts := tc.AData;
                frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[tc.MUseLV], tl.Element, 0);
            end else begin
                tc1 := tc.AData;
                frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[tc.MUseLV], tl.Element, 0);
            end;

            dmg[0] := dmg[0] * 2;
            Result := 2;
        end else begin
            SKILL_TYPE := 1;
            Result := 6;
        end;
    end;

end.
