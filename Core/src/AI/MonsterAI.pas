unit MonsterAI;

interface

uses
	Windows, StdCtrls, MMSystem, Classes, SysUtils, ScktComp, List32, Common, Path;

        procedure CalcAI(tm:TMap; ts:TMob; Tick:Cardinal);
        procedure MobSpawn(tm:TMap; ts:TMob; Tick:cardinal);
        //procedure MobSkillCalc(tm:TMap;ts:TMob;Tick:cardinal);
        //procedure MobSkillChance(tm:TMap; ts:TMob; tsAI:TMobAIDB; Tick:cardinal);
        procedure MobSkills(tm:TMap; ts:TMob; Tick:cardinal);
        procedure MobFieldSkills(tm:TMap; ts:TMob; Tick:cardinal);
        procedure MobStatSkills(tm:TMap; ts:TMob; Tick:cardinal);
        procedure MobSkillDamageCalc(tm:TMap; tc:TChara; ts:TMob; Tick:cardinal);
        procedure SendMSkillAttack(tm:TMap; tc:TChara; ts:TMob; Tick:cardinal; k:integer);
        //procedure MonsterCastTime(tm:Tmap; ts:TMob; Tick:cardinal);

        procedure LoadMonsterAIData(tm:TMap; ts:TMob; Tick:cardinal);
        procedure CalculateSkillIf(tm:TMap; ts:TMob; Tick:cardinal);
        procedure CheckSkill(tm:TMap; ts:TMob; tsAI2:TMobAIDBFusion; Tick:Cardinal);
        procedure NewMonsterCastTime(tm:TMap; ts:TMob; Tick:Cardinal);

        procedure PetAttackSkill(tm:TMap; ts:TMob; tc:TChara);
        procedure PetDamageProcess(tm:TMap; ts:TMob; tc:TChara; Dmg:integer; Tick:cardinal; isBreak:Boolean = True);
        procedure SendPetSkillAttack(tm:TMap; tc:TChara; ts:TMob; Tick:cardinal; SkillID:integer);

        function DamageProcess2(tm:TMap; tc:TChara; tc1:TChara; Dmg:integer; Tick:cardinal; isBreak:Boolean = True) : Boolean;  {Player Attacking Player}
        function DamageProcess3(tm:TMap; ts:TMob; tc1:TChara; Dmg:integer; Tick:cardinal; isBreak:Boolean = True) : Boolean;  {Monster Attacking Player}

var

dmg           :array[0..7] of integer;


implementation


(*-----------------------------------------------------------------------------*
Monster's AI

ChrstphR 2004/04/25 - cleaned up two potential memory leaks
- Exit; called without freeing the TStringList sl that is created in the code.
*-----------------------------------------------------------------------------*)
procedure CalcAI(tm:TMap; ts:TMob; Tick:Cardinal);
var
	j   : Integer;
	i1  : Integer;
	j1  : Integer;
	k1  : Integer;
	tc1 : TChara; //ref only
	ts2 : TMob;   //ref only
	tn  : TNPC;   //ref only
	sl  : TStringList;
	//ref list that is reused *shudder* to hold string indexes and object refs
	//Early exits mean this must be free'd before Exit called.
begin
	//if ts.Data.Loaded = false then TempNewAIProcedures(tm, ts, Tick);

	with ts do begin
		//MobSkillCalc(tm,ts,Tick);

		if (ts.Stat1 <> 0) and (Data.Range1 > 0) then begin
			pcnt := 0;
			Exit;//ChrstphrR 2004/04/25 - safe
		end;

		if (isLeader) and ( (MonsterMob) or ((isSummon) and (SummonMonsterMob)) )then begin
			if (SlaveCount = 0) and (Random(1000) <= 10) then begin
				WFIFOW( 0, $011a);
				WFIFOW( 2, 196);
				WFIFOW( 4, 1);
				WFIFOL( 6, ID);
				WFIFOL(10, ID);
				WFIFOB(14, 1);
				SendBCmd(tm, ts.Point, 15);
				MobSpawn(tm,ts,Tick);
			end;
		end;//if isLeader...

		sl := TStringList.Create;//ChrstphrR - moved closer to first use..
		if (ATarget = 0) then begin

			if isActive then begin
				//sl.Clear; //First use of SL, it's already empty :)
				for j1 := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
					for i1 := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
						for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
							tc1 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
							if (tc1.HP > 0) and (tc1.Hidden = false) and (tc1.Paradise = false) and ((ts.isGuardian <> tc1.GUildID) or (ts.isGuardian = 0)) and (abs(ts.Point.X - tc1.Point.X) <= 10) and (abs(ts.Point.Y - tc1.Point.Y) <= 10) then begin  //edited by The Harbinger -- darkWeiss Version
								if (tc1.Sit <> 1) or (tc1.Option < 64) then begin
									sl.AddObject(IntToStr(tc1.ID), tc1);
								end;
							end;//if
						end;//for k1
					end;//for i1
				end;//for j1

				if sl.Count > 0 then begin
					j := Random(sl.Count);
					ATarget := StrToInt(sl.Strings[j]);
					ARangeFlag := false;
					AData := sl.Objects[j];
					ATick := Tick;
					ARangeFlag := false;

					sl.Free;// Must Free up open local objects before exiting routine
					Exit;//ChrstphrR 2004/04/25 - safe
				end;
			end;

			if (NOT isLooting) AND Data.isLoot then begin

				sl.Clear;
				for j1 := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
					for i1 := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
						for k1 := 0 to tm.Block[i1][j1].NPC.Count - 1 do begin
							tn := tm.Block[i1][j1].NPC.Objects[k1] as TNPC;
							if tn.CType <> 3 then Continue;
							if (abs(tn.Point.X - Point.X) <= 10) and (abs(tn.Point.Y - Point.Y) <= 10) then begin
								sl.AddObject(IntToStr(tn.ID), tn);
							end;
						end;
					end;
				end;

				if sl.Count > 0 then begin
					j := Random(sl.Count);
					tn := sl.Objects[j] as TNPC;
					j := SearchPath2(path, tm, Point.X, Point.Y, tn.Point.X, tn.Point.Y);
					if (j <> 0) then begin
						isLooting := True;
						ATarget := tn.ID;
						ATick := Tick;

						pcnt := j;
						ppos := 0;
						MoveTick := Tick;
						tgtPoint := tn.Point;

					end;
					sl.Free;// Must Free up open local objects before exiting routine
					Exit;//ChrstphrR 2004/04/25 - safe
				end;
			end;
		//if ATarget=0 ...
		end else begin //ATarget > 0
			if isLeader AND NOT isLooting then begin
				for j1 := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
					for i1 := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
						for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
							if (tm.Block[i1][j1].Mob.Objects[k1] is TMob) then begin
								ts2 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
								if (ts2 <> nil) or (ts2 <> ts) then begin
									if ts2.LeaderID <> ts.ID then continue;
									if (abs(ts.Point.X - ts2.Point.X) <= 10) and (abs(ts.Point.Y - ts2.Point.Y) <= 10) then begin
										if ts2.ATarget = 0 then begin
											ts2.ATarget := ts.ATarget;
											ts2.ARangeFlag := false;
											ts2.AData := ts.AData;
											ts2.ATick := Tick;
											ts2.ARangeFlag := false;
										end;
									end;
								end;
							end;
						end;
					end;
				end;
			end;

			if Data.isLink AND NOT isLooting then begin
				for j1 := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
					for i1 := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
						for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
							ts2 := tm.Block[i1][j1].Mob.Objects[k1] AS TMob;
							if (ts2 <> nil) or (ts2 <> ts) then begin
								if ts2.JID <> ts.JID then Continue;
								if (abs(ts.Point.X - ts2.Point.X) <= 10) and (abs(ts.Point.Y - ts2.Point.Y) <= 10) then begin
									if ts2.ATarget = 0 then begin
										ts2.ATarget    := ts.ATarget;
										ts2.ARangeFlag := false;
										ts2.AData      := ts.AData;
										ts2.ATick      := Tick;
										ts2.ARangeFlag := false;
									end;
								end;
							end;
						end;//for k1
					end;//for i1
				end;//for j1
			end;//if Data.isLink
		end;//if-else ATarget=0/ATarget>0

		//ChrstphrR - if the 2 early Exit's don't stop the flow, this existing
		//call will free up the StringList before we leave.
		sl.Free;
	end;//with ts
end;(* proc CalcAI()
*-----------------------------------------------------------------------------*)


//------------------------------------------------------------------------------

{Spawn Monster}
procedure MobSpawn(tm:TMap; ts:TMob; Tick:cardinal);
var
	i, j, k, h, m        :integer;
	tc                   :TChara;
  ts1                    :TMob;
  tss                    :TSlaveDB;

begin

//if (MonsterMob = true) then begin
begin
        k := SlaveDBName.IndexOf(ts.Data.Name);
        if (k <> -1) then begin
                ts.isLeader := true;
                tss := SlaveDBName.Objects[k] as TSlaveDB;
                if ts.Data.Name = tss.Name then begin

                        h := tss.TotalSlaves;
                        ts.SlaveCount := h;

                        repeat
                                for i := 0 to 4 do begin
                                        if (tss.Slaves[i] <> -1) and (h <> 0) then begin
                                                ts1 := TMob.Create;
					        ts1.Data := MobDBName.Objects[tss.Slaves[i]] as TMobDB;
					        ts1.ID := NowMobID;
					        Inc(NowMobID);
					        ts1.Name := ts1.Data.JName;
					        ts1.JID := ts1.Data.ID;
                  ts1.LeaderID := ts.ID;
                  ts1.Data.isLink := false;
					        ts1.Map := ts.Map;
                  ts1.Point.X := ts.Point.X + Random(10);
					        ts1.Point.Y := ts.Point.Y + Random(10);
					        ts1.Dir := ts.Dir;
					        ts1.HP := ts1.Data.HP;
                                                if ts.Data.Speed < ts1.Data.Speed then begin
					                ts1.Speed := ts.Data.Speed;
                                                end else begin
                                                        ts1.Speed := ts1.Data.Speed;
                                                end;

					        ts1.SpawnDelay1 := $7FFFFFFF;
					        ts1.SpawnDelay2 := 0;
					        ts1.SpawnType := 0;
					        ts1.SpawnTick := 0;
                                                if ts1.Data.isDontMove then
						        ts1.MoveWait := $FFFFFFFF
					        else
                                                        ts1.MoveWait := timeGetTime();
					        ts1.ATarget := 0;
					        ts1.ATKPer := 100;
					        ts1.DEFPer := 100;
					        ts1.DmgTick := 0;
                                                ts1.Element := ts1.Data.Element;
                                                ts1.isActive := false;

					        for j := 0 to 31 do begin
						        ts1.EXPDist[j].CData := nil;
						        ts1.EXPDist[j].Dmg := 0;
				        	end;

					        if ts1.Data.MEXP <> 0 then begin
						        for j := 0 to 31 do begin
							        ts1.MVPDist[j].CData := nil;
							        ts1.MVPDist[j].Dmg := 0;
						        end;
						        ts1.MVPDist[0].Dmg := ts1.Data.HP * 30 div 100; //FAに30%加算
					        end;

					        ts1.isSummon := true;
                                                ts1.isSlave := true;
                                                tm.Mob.AddObject(ts1.ID, ts1);
					        tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);

                                                for j := ts1.Point.Y div 8 - 2 to ts1.Point.Y div 8 + 2 do begin
		                                        for m := ts1.Point.X div 8 - 2 to ts1.Point.X div 8 + 2 do begin

			                                        for k := 0 to tm.Block[m][j].CList.Count - 1 do begin
				                                        tc := tm.Block[m][j].CList.Objects[k] as TChara;
				                                        if tc = nil then continue;
                                                                        if (abs(ts1.Point.X - tc.Point.X) < 16) and (abs(ts1.Point.Y - tc.Point.Y) < 16) then begin
					                                        SendMData(tc.Socket, ts1);
                                                                                SendBCmd(tm,ts1.Point,41,tc,False);
				                                        end;
                                                                end;
		                                        end;
	                                        end;
                                                h := h - 1;
                                        end;
                                end;
                        until (h <= 0);

                        end;
                end;
        end;

end;
//------------------------------------------------------------------------------
// Darkhelmet, Ah, my classic AI, i'll leave it here commented out just because
// of good times with it
{procedure MobSkillCalc(tm:TMap;ts:TMob;Tick:cardinal);

var
        tsAI :TMobAIDB;
        skillSlot :integer;
        k    :integer;

begin
        k := MobAIDB.IndexOf(ts.Data.ID);
        if (ts.Data.ID <> 0) and (k <> -1) then begin
    //for skillSlot := 0 to 10 do begin
                tsAI := MobAIDB.Objects[k] as TMobAIDB;
                MobSkillChance(tm, ts, tsAI, Tick);
        end;
    //end;
end;
//------------------------------------------------------------------------------

procedure MobSkillChance(tm:TMap; ts:TMob; tsAI:TMobAIDB; Tick:cardinal);

var
        //tc:TChara;
        i   :integer;
        //j   :integer;
        //tc  :TChara;

begin
        // Colus, 20030129: Changes random(7) to 8 for that last skill.
        // QUESTION: Why is this outer loop here?  Do you _really_ want to
        // (potentially) fire multiple skills off at once?

        // Darkhelmet, that would be my crappy chance system.  the loop is there
        // to go through each of the nine skills.  it is then randomized to ensure
        // that the chance occurs in a random order.
        //for j := 0 to 7 do begin
                i := Random(8);
                if ts.MSKill <> 0 then begin
                        if tsAI.PercentChance[i] > Random(100) then begin
                                //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Success');

                                MonsterCastTime(tm, ts, Tick);
                                ts.NowSkill := ts.MSKill;
                                ts.NowSkillLv := ts.MSKill;
                                ts.SkillSlot := i;
                                ts.AI := tsAI;
                                ts.Mode := 3;
                                {MobSkills(tm, ts, tsAI, Tick, i);
                                //if tc.Skill[ts.MSKill].Data.SType = 2 then
                                MobFieldSkills(tm, ts, tsAI, Tick, i);
                                MobStatSkills(tm, ts, tsAI, Tick, i);
                                //Break;
                        end;
                        //end else debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Fail');
                end;
        //end;
end; }

//------------------------------------------------------------------------------

//procedure MobSkills(tm:TMap; ts:TMob; tsAI:TMobAIDB; Tick:cardinal; i:integer);
procedure MobSkills(tm:TMap; ts:TMob; Tick:cardinal);
var
        tl      :TSkillDB;
        b       :integer;
        tc      :TChara;
        bb      :array of byte;
        xy      :TPoint;
        //j       :integer;
begin

        //for i := 0 to 3 do begin
{ChrstphrR 2004/04/26 -- tc is NOT passed, it's not created -- it doesn't exist
the next few lines will -guarantee- an access violation will occur}
{Darkhelmet 2004/04/30 -- tc is defined by the monsters Adata as long as it's AData has
something in it}

        if (assigned(ts.AData)) then begin

        dmg[0] := 0;

        tl := SkillDB.IndexOfObject(ts.MSkill) as TSkillDB;

        if ts.AData <> nil then tc := ts.AData
        else Exit;

        {Darkhelmet, Now why would you do this here... I mean come on, honestly?}
        if tc <> nil then begin
    	 {	  if tc.Stat1 = 2 then j := 21 // Frozen?  Water 1
          else if tc.Stat1 = 1 then j := 22 // Stone?  Earth 1
          else if tc.ArmorElement <> 0 then j := tc.ArmorElement // PC's armor type
    		  else j := 1;  }


        case ts.MSkill of
                //dmg[0] := dmg[0] := dmg[0] * tc.Skill[ts.MSKill].Data.Data1[ts.MSKill];
                5:      {Bash}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;
                        dmg[0] := dmg[0] * tl.Data1[ts.MLevel] div 100;
                        SendMSkillAttack(tm, tc, ts, Tick, 1);
                end;

                11,13,14,19,20:
                                { 11  : Napalm Beat
                                  13  : Soul Strike
                                  14  : Cold Bolt
                                  19  : Fire Bolt
                                  20  : Lightning Bolt
                                }
                        begin
                                //dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
                                //dmg[0] := dmg[0] * (100 - ts.Data.MDEF) div 100; //MDEF%
                                //dmg[0] := dmg[0] - ts.Data.Param[3]; //MDEF-
                                {Unsure about magic calculations so just using the attack calc algorithm [Darkhelmet]}
                                MobSkillDamageCalc(tm, tc, ts, Tick);
                                if dmg[0] < 1 then dmg[0] := 1;
                                //dmg[0] := dmg[0] * ElementTable[tl.Element][j] div 100;
                                dmg[0] := dmg[0] * tl.Data2[ts.MLevel];

                                if dmg[0] < 0 then dmg[0] := 0;
                                SendMSkillAttack(tm, tc, ts, Tick, tl.Data2[ts.MLevel]);
                        end;
                15:     {Frost Driver}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);

                        //dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * ( MUseLV + 100 ) div 100;
                        //dmg[0] := dmg[0] * (100 - ts.Data.MDEF) div 100; //MDEF%
                        //dmg[0] := dmg[0] - ts.Data.Param[3]; //MDEF-
                        if dmg[0] < 1 then dmg[0] := 1;
                        //dmg[0] := dmg[0] * ElementTable[tl.Element][j] div 100;
                        if dmg[0] < 0 then dmg[0] := 0; //Negative Damage

                        //Send Packets
			SendMSkillAttack(tm, tc, ts, Tick, 1);
                                        {if (ts.Data.race <> 1) and (ts.Data.MEXP = 0) and (dmg[0] <> 0)then begin
                                                if Random(1000) < tl.Data1[MUseLV] * 10 then begin
                                                        ts.nStat := 2;
                                                        ts.BodyTick := Tick + tc.aMotion;
                                                end;
                                        end;}
					//DamageProcess1(tm, tc, ts, dmg[0], Tick, False);
					//tc.MTick := Tick + 1500;
                end;

                46:     {Double Strafe}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;
                        dmg[0] := dmg[0] * 2;
                        SendMSkillAttack(tm, tc, ts, Tick, 2);
                end;

                56:     {Pierce}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;
                        dmg[0] := dmg[0] * tc.Skill[56].Data.Data1[ts.MLevel] div 100;
                        SendMSkillAttack(tm, tc, ts, Tick, 2);
                end;
                57:     {Brandish Spear}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;
                        dmg[0] := dmg[0] * tc.Skill[57].Data.Data1[ts.MLevel] div 100;
                        SendMSkillAttack(tm, tc, ts, Tick, 1);
                        if (dmg[0] > 0) then begin
                                SetLength(bb, 6);
                                bb[0] := 6;
                                xy := tc.Point;
                                DirMove(tm, tc.Point, tc.Dir, bb);
                                //Move the Player
                                if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
                                        with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
                                                assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
                                                Delete(IndexOf(tc.ID));
                                        end;
                                        tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
                                end;
                                tc.pcnt := 0;

                                //Send Packets to Update
                                WFIFOW(0, $0088);
                                WFIFOL(2, tc.ID);
                                WFIFOW(6, tc.Point.X);
                                WFIFOW(8, tc.Point.Y);
                                SendBCmd(tm, tc.Point, 10);;
                        end;
                end;
                84: {Jupitel Thunder}
                begin
                  MobSkillDamageCalc(tm, tc, ts, Tick);
                  if dmg[0] < 0 then dmg[0] := 0;
                  dmg[0] := dmg[0] * tc.Skill[84].Data.Data2[ts.MLevel] div 100;
                  SendMSkillAttack(tm, tc, ts, Tick, 1);
                end;

                86: {Water Ball}
                begin
                  MobSkillDamageCalc(tm, tc, ts, Tick);
                  if dmg[0] < 0 then dmg[0] := 0;
                  dmg[0] := dmg[0] * tc.Skill[86].Data.Data1[ts.MLevel] div 100;
                  SendMSkillAttack(tm, tc, ts, Tick, 1);
                end;

                136:    {Sonic Blows}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;
                        dmg[0] := dmg[0] * 8;
                        SendMSkillAttack(tm, tc, ts, Tick, 8);
                end;

                137:    {Grimtooth}
                begin
                    if (ts.Cloaked) then begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;
                        SendMSkillAttack(tm, tc, ts, Tick, 1);
                    end;
                end;

                148:    {Charge Arrow}
                begin

                        xy.X := tc.Point.X - tc.Point.X;
                        xy.Y := tc.Point.Y - tc.Point.Y;
                        if abs(xy.X) > abs(xy.Y) * 3 then begin
                                //Get KnockBack Distance
                                if xy.X > 0 then b := 6 else b := 2;
                        end else if abs(xy.Y) > abs(xy.X) * 3 then begin
								//縦向き
                                if xy.Y > 0 then b := 0 else b := 4;
                        end else begin
                                if xy.X > 0 then begin
                                        if xy.Y > 0 then b := 7 else b := 5;
                                end else begin
                                        if xy.Y > 0 then b := 1 else b := 3;
                                end;
                        end;

                        //Damage Calculations
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0; //Negative Damage

                        //Send Attack
                        // Colus, 20040129: Should be an MSkill
                        //SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
                        SendMSkillAttack(tm, tc, ts, Tick, 1);

                        //Successful Damage
                        if (dmg[0] > 0) then begin
                                SetLength(bb, 6);
                                bb[0] := 6;
                                xy := tc.Point;
                                DirMove(tm, tc.Point, tc.Dir, bb);
                                //Move the Player
                                if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
                                        with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
                                                assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
                                                Delete(IndexOf(tc.ID));
                                        end;
                                        tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
                                end;
                                tc.pcnt := 0;

                                //Send Packets to Update
                                WFIFOW(0, $0088);
                                WFIFOL(2, tc.ID);
                                WFIFOW(6, tc.Point.X);
                                WFIFOW(8, tc.Point.Y);
                                SendBCmd(tm, tc.Point, 10);;
                        end;
                end;

                170:    {Npc- Critical}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;
                        dmg[0] := dmg[0] * tc.Skill[170].Data.Data1[ts.MLevel] div 100;
                        SendMSkillAttack(tm, tc, ts, Tick, 1);
                end;

                171:    {Npc-combo hit}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;
                        dmg[0] := dmg[0] * 3;
                        SendMSkillAttack(tm, tc, ts, Tick, 3);
                end;

                173:    {Self Destruction}
                begin
                        dmg[0] := ts.HP;
                        if dmg[0] < 0 then dmg[0] := 0;
                        SendMSkillAttack(tm, tc, ts, Tick, 1);
                        ts.HP := 0;
                        WFIFOW( 0, $0080);
	                WFIFOL( 2, ts.ID);
	                WFIFOB( 6, 1);
	                SendBCmd(tm, ts.Point, 7);
                        
                end;

                175:    {Suicide Attack}
                begin
                        dmg[0] := ts.HP;
                        if dmg[0] < 0 then dmg[0] := 0;
                        SendMSkillAttack(tm, tc, ts, Tick, 1);
                        ts.HP := 0;
                        WFIFOW( 0, $0080);
	                WFIFOL( 2, ts.ID);
	                WFIFOB( 6, 1);
	                SendBCmd(tm, ts.Point, 7);
                        
                end;

                176:    {Posion Attack}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;
                        //dmg[0] := dmg[0] * tc.Skill[176].Data.Data1[ts.MSKill] div 100;
                        SendMSkillAttack(tm, tc, ts, Tick, 1);
                        tc.isPoisoned := True;
                        tc.PoisonTick := tick + 15000;
                        tc.Stat2 := 1;
                        UpdateStatus(tm, tc, Tick);
                end;

                177:    {Blind Attack}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;

                        SendMSkillAttack(tm, tc, ts, Tick, 1);
                        tc.isBlind := True;
                        tc.Stat2 := 16;
                        tc.BlindTick := tick + 15000;
                        UpdateStatus(tm, tc, Tick);
                        //BlindCharacter(tm, tc, Tick);
                end;

                178:    {Silence Attack}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;

                        SendMSkillAttack(tm, tc, ts , Tick, 1);

                        tc.isSilenced := True;
                        tc.SilencedTick := Tick + 15000;
                        SilenceCharacter(tm, tc, Tick);
                end;

                // Colus, 20040129: Updated elemental attacks.  Added
                // water, earth, poison, holy, shadow attacks.
                // NOTE: I put the elements in the skill DB.  We don't want
                // to change their elements back to their defaults.  The reason
                // is that if we later implement attribute change, these skills
                // would change them back.

                184,185,186,187,188,189,190:    {Elemental Attacks}
                begin
                        //ts.Element := 1;  // Water
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        //dmg[0] := dmg[0] * ElementTable[tl.Element][j] div 100;
                        if dmg[0] < 0 then dmg[0] := 0;
                        SendMSkillAttack(tm, tc, ts, Tick, 1);
                        //ts.Element := ts.Data.Element;
                end;

                191:    {Telekenesis Attack}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;
                        //dmg[0] := dmg[0] * tc.Skill[191].Data.Data1[ts.MSKill] div 100;
                        SendMSkillAttack(tm, tc, ts, Tick, 1);
                end;


                192:    {Magical Attack}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;
                        dmg[0] := dmg[0] + tc.DEF1 + tc.DEF2;
                        dmg[0] := dmg[0] - tc.MDEF1 - tc.MDEF2;
                        dmg[0] := dmg[0] * tc.Skill[192].Data.Data1[ts.MLevel] div 100;
                        if dmg[0] < 0 then dmg[0] := 0;
                        SendMSkillAttack(tm, tc, ts, Tick, 1);
                end;

                199:    {Blood Drain}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;
                        dmg[0] := dmg[0] * 2;
                        ts.HP := ts.HP + dmg[0];
                        if ts.HP > integer(ts.Data.HP) then ts.HP := ts.Data.HP;
                        SendMSkillAttack(tm, tc, ts, Tick, 1);
                end;

                200:    {Energy Drain}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;
                        //dmg[0] := dmg[0] * tc.Skill[200].Data.Data1[ts.MSKill] div 100;
                        if dmg[0] > 0 then begin
                                tc.SP := tc.SP - (dmg[0] div 4);
                                if tc.SP < 0 then tc.SP := 0;
                        end;
                        SendMSkillAttack(tm, tc, ts, Tick, 1);

                end;

                202:    {Dark Breath}
                begin
                        MobSkillDamageCalc(tm, tc, ts, Tick);
                        if dmg[0] < 0 then dmg[0] := 0;
                        dmg[0] := dmg[0] * tc.Skill[202].Data.Data1[ts.MLevel] div 100;
                        SendMSkillAttack(tm, tc, ts, Tick, 1);
                end;
                else //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Skill ' + IntToStr(ts.MSkill) + ' Is not coded')
            end;
        end;

        end;
        //Debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Skill ' + IntToStr(ts.MSkill) + ' Deals ' + IntToStr(dmg[0]) + ' Damage');
	{ChrstphrR - 2004/04/26 ensure that the dyn array is unset}
	bb := NIL;
end;//proc MobSkills()

//------------------------------------------------------------------------------

procedure MobFieldSkills(tm:TMap; ts:TMob; Tick:cardinal);
var
        //tl  :TSkillDB;
        //sl  :TStringList;
        //tc  :TChara;
        j   :integer;
        AttackData :TChara;
        xy  :TPoint;
	//bb  :array of byte;
        tn  :TNPC;

begin

        //for i := 0 to 3 do begin
                if ts.AData <> nil then
                    AttackData := ts.AData
                else
                    Exit;
                  //AttackData := ts;

                case ts.MSKill of
                  //18: {Fire Wall}
                  //  begin

                  //  end;
                        83:     {Meteor}
                        begin
                                //AttackData := ts.AData;

                                xy.X := AttackData.Point.X;
                                xy.Y := AttackData.Point.Y;

                                //Place the Effect
                                ts.IsCasting := true;
                                tn := SetSkillUnit(tm, ts.ID, xy, Tick, $88, 0, 3000, nil, ts);

                                tn.MSkill := ts.MSkill;
                                tn.MUseLV := ts.MLevel;

                                for j := 1 to AttackData.Skill[83].Data.Data2[ts.MLevel] do begin;
                                        WFIFOW( 0, $0117);
                                        WFIFOW( 2, ts.MSKill);
                                        WFIFOL( 4, ts.ID);
                                        WFIFOW( 8, ts.MLevel);
                                        WFIFOW(10, (AttackData.Point.X - 4 + Random(12)));
                                        WFIFOW(12, (AttackData.Point.Y - 4 + Random(12)));
                                        WFIFOL(14, 1);
                                        SendBCmd(tm, xy, 18);
                                end;

                        end;

                        85:     {Lord of Vermillion}
                          begin
                                //AttackData := ts.AData;
                                //Cast Point
                                xy.X := AttackData.Point.X;
                                xy.Y := AttackData.Point.Y;

                                ts.IsCasting := true;

                                //Create Graphics and Set NPC
                                tn := SetSkillUnit(tm, ts.ID, xy, Tick, $86, 0, 3000, nil, ts);

                                tn.MSkill := ts.MSKill;
                                tn.MUseLV := ts.MLevel;

                                WFIFOW( 0, $0117);
                                WFIFOW( 2, ts.MSKill);
                                WFIFOL( 4, ts.ID);
                                WFIFOW( 8, ts.MLevel);
                                WFIFOW(10, (AttackData.Point.X));
                                WFIFOW(12, (AttackData.Point.Y));
                                WFIFOL(14, 1);
                                SendBCmd(tm, xy, 18);
                          end;

                        {140:   //Venom Dust
                        begin
                          // Create Location
                          xy.X := (AttackData.Point.X);
					                xy.Y := (AttackData.Point.Y) + 1;
                          tn := SetSkillUnit(tm, ts.ID, xy, Tick, $92, 0, AttackData.Skill[140].Data.Data1[ts.MLevel] * 1000, nil, ts);

					                xy.X := (AttackData.Point.X) + 1;
                          xy.Y := (AttackData.Point.Y);

                          tn := SetSkillUnit(tm, ts.ID, xy, Tick, $92, 0, AttackData.Skill[140].Data.Data1[ts.MLevel] * 1000, nil, ts);

					                xy.X := (AttackData.Point.X) - 1;
					                xy.Y := (AttackData.Point.Y);

					                tn := SetSkillUnit(tm, ts.ID, xy, Tick, $92, 0, AttackData.Skill[140].Data.Data1[ts.MLevel] * 1000, nil, ts);

					                xy.X := (AttackData.Point.X);
					                xy.Y := (AttackData.Point.Y) - 1;

					                tn := SetSkillUnit(tm, ts.ID, xy, Tick, $92, 0, AttackData.Skill[140].Data.Data1[ts.MLevel] * 1000, nil, ts);
					                tn.MSkill := ts.MSkill;
                          tn.MUseLV := ts.MLevel;
                          debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Venom Dust')
                        end; }

                        else //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Skill ' + IntToStr(ts.MSkill) + ' Is not coded')
                end;  //end case
        //end;
end;
//------------------------------------------------------------------------------
procedure MobStatSkills(tm:TMap; ts:TMob; Tick:cardinal);

var
    ProcessType     :Byte;
    j,i1,j1 :integer;
    //mi  :MapTbl;
    xy  :TPoint;
begin

with ts do begin
        ProcessType := 0;
        case ts.MSKill of
          8:  {Endure}
            begin

            end;
          26: {Teleport}
                begin
                  // Colus, 20040506: Was this even tested?
                  // When a monster doesn't have a target and tries to do this,
                  // it crashes.  Every single time.  It's plainly obvious.  As
                  // long as you don't summon the monster (making you the target)
                  // it happens almost always.
                  //
                  // Going to try to fix it like a flywing, so you see the disappear
                  // effect and the monster is moved.
                  SendMonsterRelocation(tm, ts);

									{i := MapInfo.IndexOf(ts.Map);
									j := -1;
									if (i <> -1) then begin
										mi := MapInfo.Objects[i] as MapTbl;
										if (mi.noTele = true) then j := 0;
									end;
									if (j <> 0) then begin
                    if (Common.Map.IndexOf(ts.Map) <> - 1) then begin
            				  tm := Common.Map.Objects[Common.Map.IndexOf(ts.Map)] as TMap;

                      j := 0;

  									  repeat
  										  xy.X := Random(tm.Size.X - 2) + 1;
  										  xy.Y := Random(tm.Size.Y - 2) + 1;
  										  Inc(j);
  									  until ( ((tm.gat[xy.X, xy.Y] <> 1) and (tm.gat[xy.X, xy.Y] <> 5)) or (j = 100) );

  									  if j <> 100 then begin
                        ts.ATarget := 0;
                        ts.AData := nil;
                        ts.AMode := 0;
                        ts.Status := 'IDLE_ST';
                        //ts.pcnt := 0;
                        UpdateLivingLocation(tm, ts);
                        SendLivingDisappear(tm, ts, 3);
                        with tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob do begin
                  				Assert(IndexOf(ts.ID) <> -1, 'Mob Delete Error');
                          Delete(IndexOf(ts.ID));
                        end;

  										  ts.Point := xy;
                        UpdateLivingLocation(tm, ts);
                        tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
                      end;
									  end;
                  end; }

                end;
          28:     {Heal}
                begin
                  dmg[0] := (ts.Data.LV * 2 + 10);
                  ts.HP := ts.HP + dmg[0];
                  if ts.HP > integer(ts.Data.HP) then ts.HP := ts.Data.HP;

                  WFIFOW( 0, $011a);
                  WFIFOW( 2, ts.MSKill);
                  WFIFOW( 4, dmg[0]);
                  WFIFOL( 6, ts.ID);
                  WFIFOL(10, ts.ID);
                  WFIFOB(14, 1);
                  SendBCmd(tm, ts.Point, 15);
                end;
          29: {Increase Agility}
            begin
              if ts.MLevel > 5 then begin
						    ts.speed := ts.speed - 45;
						  end else begin
						    ts.speed := ts.speed - 30;
						  end;

            end;

          51:     {Hide}
                begin
                        ProcessType := 1;
                end;


          114:    {Power Maximize}
                begin
                        ProcessType := 1;
                end;
          135:  {Cloaking}
            begin
                //When ProcessType = 1, cloaking will be handled
                xy.X := ts.Point.X;
                xy.Y := ts.Point.Y;

                if (ts.Cloaked) then begin
                    // Cloaked, so uncloak
                    ProcessType := 1;

                end else begin
                    for j1 := - 1 to 1 do begin
                        for i1 := -1 to 1 do begin
                            if ((j1 = 0) and (i1 = 0)) then continue;
                            j := tm.gat[xy.X + i1, xy.Y + j1];
                            if (j = 1) or (j = 5) then begin
                                ProcessType := 1;
                            end;
                        end
                    end;
                end;
                //if ProcessType = 0 then DebugOut.Lines.Add('Monster is too far from a wall');
            end;
          196:  {Summon Slave}
            begin
              // (ts.isLeader) and ( (MonsterMob) or ((ts.isSummon) and (SummonMonsterMob)) )then begin
                if ts.SlaveCount = 0 then begin
                  // (Random(1000) <= 10) then begin
                    WFIFOW( 0, $011a);
                    WFIFOW( 2, 196);
                    WFIFOW( 4, 1);
                    WFIFOL( 6, ID);
                    WFIFOL(10, ID);
                    WFIFOB(14, 1);
                    SendBCmd(tm, ts.Point, 15);
                    MobSpawn(tm,ts,Tick);
                  //end;
                end;
              //end;
            end;

          197:  {NPC Emotion}
                  begin
                    j := Random(31) + 1;

                    // Not sure on the exact emotion its supposed to do,
                    // So I just did it with a random emotion
                    WFIFOW(0, $00c0);
                    WFIFOL(2, ts.ID);
                    WFIFOB(6, j);
                    SendBCmd(tm, ts.Point, 7);
                  end;
          else //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Skill ' + IntToStr(ts.MSkill) + ' Is not coded')
        end;

        case ProcessType of
                0:  //Skill Used on Oneself
                        begin
                                //Packet Process
                                WFIFOW( 0, $011a);
                                WFIFOW( 2, ts.MSKill);
                                WFIFOW( 4, dmg[0]);
                                WFIFOL( 6, ts.ID);
                                WFIFOL(10, ID);
                                WFIFOB(14, 1);
                                SendBCmd(tm, ts.Point, 15);
                        end;
                1:  //Skills Like Power Maximize
                        begin
                                WFIFOW( 0, $011a);
                                WFIFOW( 2, ts.MSKill);
                                WFIFOW( 4, ts.MLevel);
                                WFIFOL( 6, ts.ID);
                                WFIFOL(10, ts.ID);
                                WFIFOB(14, 1);
                                SendBCmd(tm, ts.Point, 15);

                                if (ts.MSKill = 51) or (ts.MSkill = 135) then begin
                                    if (ts.Hidden) or (ts.Cloaked) then begin
                                        ts.Hidden := false;
                                        ts.Cloaked := false;
                                        WFIFOW(0, $0119);
                                        WFIFOL(2, ts.ID);
                                        WFIFOW(6, 0);
                                        WFIFOW(8, 0);
    					                WFIFOW(10, 0);
    					                WFIFOB(12, 0);
    					                SendBCmd(tm, ts.Point, 13);
                                        //DebugOut.Lines.Add('Monster ' + ts.Name + ' uncloaks via Skill Cloaking!');

                                    end else begin
                                        if ts.MSkill = 135 then ts.Cloaked := true
                                        else ts.Hidden := true;
                                        WFIFOW(0, $0119);
    					                WFIFOL(2, ts.ID);
    					                WFIFOW(6, 0);
    					                WFIFOW(8, 0);
    					                WFIFOW(10, 6);
    					                WFIFOB(12, 0);
    					                SendBCmd(tm, ts.Point, 13);
                                        //DebugOut.Lines.Add('Monster ' + ts.Name + ' cloaks!');
                                    end;

                                end;
                                {
                                if (tc1.MSkill = 143) then begin
                                        if tc1.Sit = 1 then begin
						tc1.Sit := 3;
                                                SkillTick := tc1.Skill[MSkill].Tick;
                                                SkillTickID := MSkill;
                                                tc1.SP := tc1.SP + 5;
                                                if tc1.SP > tc1.MAXSP then tc1.SP := tc1.MAXSP;
                                                CalcStat(tc1, Tick);
                                        end else begin
                                                tc1.Sit := 1;
                                        end;
                                end;}

                                if (ts.MSKill = 114) then begin
                                        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Monster Casts Power Maximize');
                                        {if tc1.Option = 32 then begin
						//tc1.Option := tc1.Optionkeep;
                                                SkillTick := tc1.Skill[MSkill].Tick;
                                                SkillTickID := MSkill;
                                                //CalcMonsterStat(ts, Tick);
                                        end else begin
                                                tc1.Optionkeep := tc1.Option;
                                                tc1.Option := 32;
                                        end; }
                                end;

                        end;
                end;
        end;
end;

//------------------------------------------------------------------------------

procedure MobSkillDamageCalc(tm:TMap; tc:TChara; ts:TMob; Tick:cardinal);
        var
	i,j,k     :integer;
	miss      :boolean;
	crit      :boolean;
	avoid     :boolean; //完全回避
	i1,j1,k1  :integer;
	xy        :TPoint;
	ts1       :TMob;
	tn        :TNPC;
   //     tl        :TSkillDB;
begin
	if tc.TargetedTick <> Tick then begin
		if DisableFleeDown then begin
			tc.TargetedFix := 10;
			tc.TargetedTick := Tick;
		end else begin
			i := 0;
			xy := tc.Point;
			for j1 := xy.Y div 8 - 2 to xy.Y div 8 + 2 do begin
				for i1 := xy.X div 8 - 2 to xy.X div 8 + 2 do begin
					for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
            if (tm.Block[i1][j1].Mob.Objects[k1] is TMob) then begin
						ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
						if (tc.ID = ts1.ATarget) and (abs(ts1.Point.X - tc.Point.X) <= ts1.Data.Range1) and
							 (abs(ts1.Point.Y - tc.Point.Y) <= ts1.Data.Range1) then Inc(i);
					end;
				end;
			end;
			end;
			//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Targeted: ' + inttostr(i));
			if i > 12 then i := 12;
			if i < 2 then i := 2;
			tc.TargetedFix := 12 - i;
			tc.TargetedTick := Tick;
		end;
	end;

	with ts.Data do begin
                //MobSkillCalc(tm,ts,Tick);

		i := HIT - (tc.FLEE1 * tc.TargetedFix div 10) + 80;
		i := i - tc.FLEE2;
		if i < 5 then i := 5
		else if i > 95 then i := 95;

		dmg[6] := i;
		//crit := boolean((SkillPer = 0) and (Random(100) < Critical));
		crit := false;
		//avoid := boolean((SkillPer = 0) and (Random(100) < tc.Lucky));
		miss := boolean((Random(100) >= i) and (not crit));

                //Shield Reflect
                {if ((miss = False) and (tc.Skill[252].Tick > Tick)) then begin
                                tc.MSkill := 252;
                                dmg[0] := (dmg[0] * tc.Skill[252].Effect1) div 100;
                                WFIFOW( 0, $011a);
                                WFIFOW( 2, tc.MSkill);
                                WFIFOW( 4, tc.MUseLV);
                                WFIFOL( 6, tc.ID);
                                WFIFOL(10, tc.ID);
                                WFIFOB(14, 1);
                                SendBCmd(tm, tc.Point, 15);
                                WFIFOW( 0, $008a);
                                WFIFOL( 2, tc.ID);
                                WFIFOL( 6, ts.ID);
                                WFIFOL(10, timeGetTime());
                                WFIFOL(14, tc.aMotion);
                                WFIFOL(18, ts.Data.dMotion);
                                WFIFOW(22, dmg[0]); //ダメージ
                                WFIFOW(24, 1); //分割数
                                WFIFOB(26, 0); //0=単攻撃 8=複数 10=クリティカル
                                WFIFOW(27, 0); //逆手
                                SendBCmd(tm, ts.Point, 29);
                                SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
                                if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
                                StatCalc1(tc, ts, Tick);
                                dmg[0] := 0;
                                dmg[5] := 11;
                end;

                if tc.AnolianReflect then begin
                      dmg[0] := (dmg[0] * 10) div 100;
                      if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
                      StatCalc1(tc, ts, Tick);
                      dmg[0] := 0;
                      dmg[5] := 11;
                end;

                //Poison React
                if ((miss = False) and (tc.Skill[139].Tick > Tick) and (ts.Data.Element = 25)) then begin
                                DamageCalc1(tm, tc, ts, Tick, 0, 0, 0, 20);
                                tc.MSkill := 139;
                                dmg[0] := (dmg[0] * tc.Skill[139].Effect1) div 100;
                                WFIFOW( 0, $011a);
                                WFIFOW( 2, tc.MSkill);
                                WFIFOW( 4, tc.MUseLV);
                                WFIFOL( 6, tc.ID);
                                WFIFOL(10, tc.ID);
                                WFIFOB(14, 1);
                                SendBCmd(tm, tc.Point, 15);
                                WFIFOW( 0, $008a);
                                WFIFOL( 2, tc.ID);
                                WFIFOL( 6, ts.ID);
                                WFIFOL(10, timeGetTime());
                                WFIFOL(14, tc.aMotion);
                                WFIFOL(18, ts.Data.dMotion);
                                WFIFOW(22, dmg[0]); //ダメージ
                                WFIFOW(24, 1); //分割数
                                WFIFOB(26, 0); //0=単攻撃 8=複数 10=クリティカル
                                WFIFOW(27, 0); //逆手
                                SendBCmd(tm, ts.Point, 29);
                                SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
                                if not DamageProcess1(tm, tc, ts, dmg[0], Tick) then
                                StatCalc1(tc, ts, Tick);
                                dmg[0] := 0;
                                dmg[5] := 11;
                end; }

                //From mWeiss

		i1 := 0;
		while (i1 >= 0) and (i1 < tm.Block[tc.Point.X div 8][tc.Point.Y div 8].NPC.Count) do begin
			tn := tm.Block[tc.Point.X div 8][tc.Point.Y div 8].NPC.Objects[i1] as TNPC;
			if tn = nil then begin
				Inc(i1);
				continue;
			end;
			if (tc.Point.X = tn.Point.X) and (tc.Point.Y = tn.Point.Y) then begin
				case tn.JID of
				$7e: //セイフティウォール
					begin
						miss := true;
						if not avoid then Dec(tn.Count);
						if tn.Count = 0 then begin
							DelSkillUnit(tm, tn, tc);
							Dec(i1);
						end;
						//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Safety Wall OK >>' + IntToStr(tn.Count));
						dmg[6] := 0;
					end;
				$85: //ニューマ
					begin
						if ts.Data.Range1 >= 4 then miss := true;
						//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Pneuma OK');
						dmg[6] := 0;
					end;
				end;
			end;
			Inc(i1);
		end;

		if crit then dmg[5] := 10 else dmg[5] := 0; //クリティカルチェック
		//VITボーナスとか計算
		j := ((tc.Param[2] div 2) + (tc.Param[2] * 3 div 10));
		k := ((tc.Param[2] div 2) + (tc.Param[2] * tc.Param[2] div 150 - 1));
		if j > k then k := j;
		if tc.Skill[33].Tick > Tick then begin //エンジェラス
			k := k * tc.Skill[33].Effect1 div 100;
		end;

		dmg[1] := ATK1 + Random(ATK2 - ATK1 + 1);
		if (ts.Stat2 and 1) = 1 then dmg[1] := dmg[1] * 75 div 100;
		//オート_バーサーク
		if (tc.Skill[146].Lv <> 0) and (tc.HP * 100 / tc.MAXHP <= 25) then dmg[0] := (dmg[1] * (100 - (tc.DEF1 * word(tc.Skill[6].Data.Data2[10]) div 100)) div 100 - k) * ts.ATKPer div 100
		else dmg[0] := (dmg[1] * (100 - tc.DEF1) div 100 - k) * ts.ATKPer div 100;
		if Race = 1 then dmg[0] := dmg[0] - tc.DEF3; //DP
		if dmg[0] < 0 then dmg[0] := 1;

		//if SkillPer <> 0 then dmg[0] := dmg[0] * SkillPer div 100; //Skill%
		//dmg[0] := dmg[0] * ElementTable[AElement][ts.Data.Element] div 100; //属性相性補正

		//カード補正
    // Colus, 20040129: The race reduction shield cards are direct values, not 100-val.
		//dmg[0] := dmg[0] * (100-tc.DamageFixR[1][ts.Data.Race] )div 100;

    // Added elemental property reduction cards...
    //dmg[0] := dmg[0] * (100-tc.DamageFixE[1][ts.Element] )div 100;

    // Colus, 20040127: The race reduction shield cards are direct values, not 100-val.
    //        20040129: Couldn't do it this way.  Must change the card data instead...
		dmg[0] := dmg[0] * (100 - tc.DamageFixR[1][ts.Data.Race]) div 100;
		dmg[0] := dmg[0] * (100 - tc.DamageFixE[1][0]) div 100;    


    // Moving element determination to the separate skills...

    //MOVING IT BACK!
    // Determine element based on status/armor type...
		if tc.Stat1 = 2 then i := 21 // Frozen?  Water 1
        else if tc.Stat1 = 1 then i := 22 // Stone?  Earth 1
        else if tc.ArmorElement <> 0 then i := tc.ArmorElement // PC's armor type
		else i := 1;
		dmg[0] := dmg[0] * ElementTable[ts.Element mod 20][i] div 100; // Damage modifier based on elements}


		if (tc.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2; // Lex Aeterna effect
		//dmg[0] := dmg[0] * tc.DEFFixE[ts.Data.Element mod 20] div 100;

                {//Auto Gaurd
                if ((miss = False) and (tc.Skill[249].Tick > Tick)) then begin
                        miss := boolean(Random(100) <= tc.Skill[249].Effect1);
                        if (miss = True) then begin
                                tc.MSkill := 249;
                                WFIFOW( 0, $011a);
                                WFIFOW( 2, tc.MSkill);
                                WFIFOW( 4, tc.MUseLV);
                                WFIFOL( 6, tc.ID);
                                WFIFOL(10, tc.ID);
                                WFIFOB(14, 1);
                                SendBCmd(tm, tc.Point, 15);
                                SendCSkillAtk1(tm, tc, ts, Tick, 0, 1, 6);
                                tc.MTick := Tick + 3000;
                        end;
                end; }

                //Dragonology
                if (tc.Skill[284].Lv <> 0) and (ts.Data.Race = 9) then begin
                        dmg[0] := (dmg[0] - dmg[0] * tc.Skill[284].Data.Data1[tc.Skill[284].Lv]) div 100;
                end;

                //Providence
                if (tc.Skill[256].Tick > Tick) and ((ts.Data.Race = 1) or (ts.Data.Race = 6) or (ts.Data.Race = 8)) then begin
                        i := (dmg[0] * tc.Skill[256].Data.Data2[tc.Skill[256].Lv]) div 100;
                        dmg[0] := dmg[0] - i;
                end;

                {if tc.Skill[61].Tick > Tick then begin //AC
                        tc.AMode := 8;
                        tc.ATarget := ts.ID;
                        DamageCalc1(tm, tc, ts, Tick, 0, 0, 0, 20);
                        if dmg[0] < 0 then dmg[0] := 0; //属性攻撃での回復は未実装
                        //パケ送信
                        WFIFOW( 0, $008a);
                        WFIFOL( 2, tc.ID);
                        WFIFOL( 6, tc.ATarget);
                        WFIFOL(10, timeGetTime());
                        WFIFOL(14, tc.aMotion);
                        WFIFOL(18, ts.Data.dMotion);
                        WFIFOW(22, dmg[0]); //ダメージ
                        WFIFOW(24, 1); //分割数
                        WFIFOB(26, 0); //0=単攻撃 8=複数 10=クリティカル
                        WFIFOW(27, 0); //逆手
                        SendBCmd(tm, ts.Point, 29);
                        DamageProcess1(tm, tc, ts, dmg[0], Tick);
                        StatCalc1(tc, ts, Tick);
                        tc.Skill[61].Tick := Tick;
                        tc.AMode := 0;
                        dmg[0] := 0;
                        dmg[5] := 11;
                end else if avoid then begin
                        dmg[0] := 0;
			dmg[5] := 11;
		end else if not miss then begin
			//攻撃命中
			if dmg[0] <> 0 then begin
				if tc.Skill[157].Tick > Tick then begin //エネルギーコート
					if (tc.SP * 100 / tc.MAXSP) < 1 then tc.SP := 0;
				   	if tc.SP > 0 then begin
						i := 1;
						if (tc.SP * 100 / tc.MAXSP) > 20 then i := 2;
						if (tc.SP * 100 / tc.MAXSP) > 40 then i := 3;
						if (tc.SP * 100 / tc.MAXSP) > 60 then i := 4;
						if (tc.SP * 100 / tc.MAXSP) > 80 then i := 5;
						dmg[0] := dmg[0] - ((dmg[0] * i * 6) div 100);
						tc.SP := tc.SP - (tc.MAXSP * (i + 1) * 5) div 1000;
                                        end;
                                end else if (tc.Skill[257].Tick > Tick) then begin //Defender
                                                i := (dmg[0] * tc.Skill[257].Data.Data2[tc.Skill[257].Lv]) div 100;
                                                dmg[0] := dmg[0] - i;
                                                tc.MSkill := 257;
                                                WFIFOW( 0, $011a);
						WFIFOW( 2, tc.MSkill);
						WFIFOW( 4, tc.MUseLV);
						WFIFOL( 6, tc.ID);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
                                end else begin
                                tc.Skill[257].Tick := Tick;
                                tc.Skill[157].Tick := Tick;
                                SendCStat1(tc, 0, 7, tc.SP);
				end;
				tc.MMode := 0;
				tc.MTick := Tick;
				tc.MTarget := 0;
				tc.MPoint.X := 0;
				tc.MPoint.Y := 0;
                        end;
		end else begin
			//攻撃ミス
			dmg[0] := 0;
		end;}
		//ここで星のかけら効果を入れる(未実装)
                if dmg[0] > 16000 then dmg[0] := 16000;
		dmg[4] := 1;
	end;
	//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('REV %d%% %d(%d-%d)', [dmg[6], dmg[0], dmg[1], dmg[2]]));
end;

//------------------------------------------------------------------------------
procedure SendMSkillAttack(tm:TMap; tc:TChara; ts:TMob; Tick:cardinal; k:integer);

begin
//R 01de <skill ID>.w <src ID>.l <dst ID>.l <server tick>.l <src speed>.l <dst speed>.l <param1>.l <param2>.w <param3>.w <type>.B

  // Moved Lex Aeterna calc up here.  It is display only (don't reset the tick here)
  // Damage should be correct when it gets here.  Commented.
	//if (tc.Skill[78].Tick > Tick) then k := k * 2; // Lex Aeterna effect

  // Colus, 20040129: If you aren't going to use DamageProcess3 for mob skills,
  // then you need to have a check here so that you don't run into negative HP.
  // Likewise you need to send the correct packets for updates, etc., right?

        if tc.HP - dmg[0] > 0 then tc.HP := tc.HP - dmg[0];  //Subtract Damage.
        if tc.HP < 0 then tc.HP := 0;
        WFIFOW( 0, $01de);
	WFIFOW( 2, ts.MSkill);
	WFIFOL( 4, ts.ID);
	WFIFOL( 8, tc.ID);
	WFIFOL(12, Tick);
	//WFIFOL(16, tc.aMotion);
	//WFIFOL(20, ts.Data.dMotion);
        WFIFOL(16, ts.Data.dMotion);
	WFIFOL(20, tc.aMotion);
	WFIFOL(24, dmg[0]);
	WFIFOW(28, ts.MLevel);
	WFIFOW(30, k);
        WFIFOB(32, 8);
	//else               WFIFOB(32, 8);
	//if ts.Stat1 = 5 then dmg := dmg * 2; //レックス_エーテルナ
	SendBCmd(tm, tc.Point, 33);
end;
//------------------------------------------------------------------------------
// The Original monster cast time, it has much since evolved
{procedure MonsterCastTime(tm:Tmap; ts:TMob; Tick:cardinal);
var
        //tl     :TSkillDB;
        tc      :TChara;
        j      :integer;
begin

        tc := ts.AData;

        //with Skill[ts.MSKill] do begin

        j := tc.Skill[ts.MSKill].Data.CastTime1 + tc.Skill[ts.MSKill].Data.CastTime2 * ts.MSKill;
        if j < tl.CastTime3  then j := tl.CastTime3;

        ts.MTick := Tick + cardinal(j);
        //j := j * tc.MCastTimeFix div 100;
        if (j > 0) then begin
                //Send Packets
                WFIFOW( 0, $013e);
                WFIFOL( 2, ts.ID);
                WFIFOL( 6, ts.ATarget);
                WFIFOW(10, 0);
                WFIFOW(12, 0);
                WFIFOW(14, ts.MSKill); //SkillID
                WFIFOL(16, tc.Skill[ts.MSKill].Data.Element); //Element
                WFIFOL(20, j);
                SendBCmd(tm, ts.Point, 24);
                ts.MMode := 1;
                ts.ATick := Tick + cardinal(j);
        end else begin
                //詠唱なし
                ts.MMode := 1;
                ts.ATick := Tick;
        end;

end;
}
//------------------------------------------------------------------------------
procedure LoadMonsterAIData(tm:TMap; ts:TMob; Tick:cardinal);
var
  tsAI2 :TMobAIDBFusion;
  m     :integer;
  sl    :TStringList;

begin
  sl := TStringList.Create;
  sl.Delimiter := ',';
  sl.Clear;
  ts.SkillWaitTick := Tick;
  ts.Data.SkillCount := 0;
  {
  Monster Data: RAYDRIC BERSERK_ST NPC_DARKNESSATTACK 3 200 0 7500 0 0 0
Monster Data: RAYDRIC RUSH_ST NPC_EMOTION 1 15 0 10000 0 0 0
Monster Data: RAYDRIC BERSERK_ST SM_MAGNUM 6 50 1500 10000 NO_DISPEL 0 0
Monster Data: RAYDRIC BERSERK_ST SM_MAGNUM 6 1000 1500 10000 NO_DISPEL IF_ENEMYCOUNT 2
Monster Data: RAYDRIC BERSERK_ST BS_MAXIMIZE 1 50 1000 40000 0 0 0
Monster Data: RAYDRIC RUSH_ST BS_MAXIMIZE 1 50 1000 40000 0 0 0
Monster Data: RAYDRIC BERSERK_ST SM_MAGNUM 6 150 1500 10000 NO_DISPEL IF_HP 30
Monster Data: RAYDRIC BERSERK_ST BS_MAXIMIZE 1 150 1000 40000 IF_HP 30 0
}
  {Possible If's
    IF_COMRADECONDITION
    IF_COMRADEHP
    IF_CONDITION
    IF_ENEMYCOUNT
    IF_HIDING
    IF_MAGICLOCKED
    IF_RANGEATTACKED
    IF_RUDEATTACK
    IF_SKILLUSE
    IF_SLAVENUM
  }

  //j := MobAIDBFusion.IndexOf(ts.Number);
  //k := j;
  //j := MobAIDBFusion.IndexOf(ts.Name);
  //debugout.lines.add('[' + TimeToStr(Now) + '] ' + ts.Name);
  for m := 0 to MobAIDBFusion.Count do begin
    if MobAIDBFusion.IndexOf(m) <> -1 then begin
    //while (j > 0) do begin
      //tsAI2 := MobAIDBFusion.IndexOf(j)] as TMobAIDBFusion;
      tsAI2 := MobAIDBFusion.Objects[MobAIDBFusion.IndexOf(m)] as TMobAIDBFusion;
      //debugout.lines.add('[' + TimeToStr(Now) + '] ' + IntToStr(j));
      if (ts.Data.ID = tsAI2.ID) then begin

        sl.Add(IntToStr(m));
        ts.Data.SkillLocations := sl.DelimitedText;
        ts.Data.SkillCount := ts.Data.SkillCount + 1;

        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Monster Data: ' + tsAI2.Name + ' ' + tsAI2.Status + ' ' +  tsAI2.SkillID + ' ' + IntToStr(tsAI2.SkillLV) + ' ' + IntToStr(tsAI2.Percent) + ' ' + IntToStr(tsAI2.Cast_Time) + ' ' + IntToStr(tsAI2.Cool_Time) + ' ' + tsAI2.Dispel + ' ' + tsAI2.IfState + ' ' + tsAI2.IfCond );
        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + '----------------------------');
        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Skill: ' + tsAI2.SkillID);

        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Requires monster is in ' + tsAI2.Status + ' status');

        if tsAI2.Dispel = 'NO_DISPEL' then begin
        //  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Cannot be broken when attacked.');
          ts.NoDispel := true;
        end else
        //  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Can be broken when attacked.');
          ts.NoDispel := true;
        ///////////If Conditions Begin////////////////
        if tsAI2.IfState = 'IF_COMRADECONDITION' then begin
        //  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Skill Has Comrade Condition, ' + tsAI2.IfCond);
        end;
        if tsAI2.IfState = 'IF_COMRADEHP' then begin
        //  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Skill Has Comrade HP Condition, if Comrade HP is ' + tsAI2.IfCond + '% or less');
        end;
        if tsAI2.IfState = 'IF_CONDITION' then begin
        //  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Only active if monster is: ' + tsAI2.IfCond);
        end;
        if tsAI2.IfState = 'IF_HIDING' then begin
        //  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Monster Must Be Hiding');
        end;
        if tsAI2.IfState = 'IF_MAGICLOCKED' then begin
        //  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Enemy Must be Magic Locked');
        end;
        if tsAI2.IfState = 'IF_RANGEATTACKED' then begin
        //  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Enemy Must be Range Attacked');
        end;
        if tsAI2.IfState = 'IF_RUDEATTACK' then begin
        //  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Enemy Must be Rude Attacked');
        end;
        if tsAI2.IfState = 'IF_SKILLUSE' then begin
        //  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Skill ' + tsAI2.IfCond + ' Triggers this');
        end;
        if tsAI2.IfState = 'IF_SLAVENUM' then begin
        //  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Slave Count Must be at least: ' + tsAI2.IfCond);
        end;
        if tsAI2.IfState = 'IF_HP' then begin
        //  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Skill ' + tsAI2.SkillID + ' has if HP Argument, needs ' + tsAI2.IfCond + '% of HP');
        end;

        if tsAI2.IfState = 'IF_ENEMYCOUNT' then
          begin
            //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Skill ' + tsAI2.SkillID + ' has if Enemy Count Statement, needs ' + tsAI2.IfCond + ' enemies' );
          end;
        ///////////If Conditions End////////////////
        {
        debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Skill Level: ' + IntToStr(tsAI2.SkillLV));
        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Percent: ' + IntToStr(tsAI2.Percent));
        debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Cast Time: ' + IntToStr(tsAI2.Cast_Time));
        debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Cool Time: ' + IntToStr(tsAI2.Cool_Time));
        debugout.lines.add('[' + TimeToStr(Now) + '] ' + '----Next Skill----');
        }

      end;
      //j := j -1;
      //if k = 0 then break;
    end;
  end;
  ts.Data.Loaded := true;
  ts.CanFindTarget := true;

  {
  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Locations of skills: ' + ts.Data.SkillLocations );
  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Locations of skills: ' + sl.DelimitedText );
  debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Done');
  debugout.lines.add('[' + TimeToStr(Now) + '] ' + '----------------------------');
  debugout.lines.add('[' + TimeToStr(Now) + '] ' + '');
  debugout.lines.add('[' + TimeToStr(Now) + '] ' + '');
  sl.Clear;
  }
	{ChrstphrR 2004/04/26 - have to free up what you create...}
	sl.Free;
end;//LoadMonsterAIData()

//------------------------------------------------------------------------------
procedure CalculateSkillIf(tm:TMap; ts:TMob; Tick:cardinal);
var
  tc2 :TChara;
  sl, sl2:TStringList;
  m,c1: Integer;
  p1:integer;
  i,j:Integer;
  i1:integer;
  HPCount:integer;
  tsAI2 :TMobAIDBFusion;
  EnemyCount:word;

begin
  sl := TStringList.Create;
  sl.Clear;
  sl.Delimiter := ',';
  sl.DelimitedText := ts.Data.SkillLocations;
  i :=  ts.Data.SkillCount;
  if ts.Data.Loaded = false then LoadMonsterAIData(tm, ts, Tick);
  while (i > 0) and (EnableMonsterSkills) do begin
    i := i - 1;
    j := StrToInt(sl.Strings[i]);
    tsAI2 := MobAIDBFusion.Objects[MobAIDBFusion.IndexOf(j)] as TMobAIDBFusion;

    if tsAI2.IfState = 'IF_HP' then begin
      //if ts.Data.DebugFlag = false then begin
        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Skill ' + tsAI2.SkillID + ' of the ' + ts.Name + ' has an if HP Argument, needs ' + tsAI2.IfCond + '% of HP');
        HPCount := ts.HP * 1000 div (Integer(ts.Data.HP) * 10);
        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Monster''''s hp percent is ' + IntToStr(HPCount));

        if HPCount > StrToInt(tsAI2.IfCond) then
          //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'If Statement passes as false')
        else begin
          //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'If Statement passes as true');
          CheckSkill(tm, ts, tsAI2, Tick);
        end;

      //end;
    end else if tsAI2.IfState = 'IF_HIDING' then begin  // If monster is hidden
      if ts.Hidden = true then CheckSkill(tm, ts, tsAI2, Tick);
		end else if tsAI2.IfState = 'IF_MAGICLOCKED' then begin // If monster is being targeted
    end else if tsAI2.IfState = 'IF_RUDEATTACK' then begin
      if ts.CanFindTarget = false then CheckSkill(tm, ts, tsAI2, Tick);
		end else if tsAI2.IfState = 'IF_ENEMYCOUNT' then begin
			sl2 := TStringList.Create;
			m := 9;
			// Get Players in Area
			for p1 := (ts.Point.Y - m) div 8 to (ts.Point.Y + m) div 8 do begin
				for i1 := (ts.Point.X - m) div 8 to (ts.Point.X + m) div 8 do begin
					for c1 := 0 to tm.Block[i1][p1].Clist.Count -1 do begin
						if (tm.Block[i1][p1].Clist.Objects[c1] is TChara) then begin
							tc2 := tm.Block[i1][p1].CList.Objects[c1] as TChara;
							if tc2 = nil then Continue;
							if (abs(tc2.Point.X - ts.Point.X) <= m) and (abs(tc2.Point.Y - ts.Point.Y) <= m) then
								sl2.AddObject(IntToStr(tc2.ID),tc2);
						end;
					end;
				end;
			end;
			EnemyCount := sl2.Count;
			//Check if enemy count meets the if condition
			if EnemyCount >= StrToInt(tsAI2.IfCond) then CheckSkill(tm, ts, tsAI2, Tick);
			//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Enemy Count: ' + IntToStr(EnemyCount));

			{ChrstphrR 2004/04/26 - have to free up what you create...}
			{Safe to just Free, since the objects stored are owned and
			referenced by another list - tm.CList}
			sl2.Free;
		end else
			CheckSkill(tm, ts, tsAI2, Tick);

		ts.Data.DebugFlag := true;
	end;

	{ChrstphrR 2004/04/26 - have to free up what you create...}
	sl.Free;
end;//CalculateSkillIf

//------------------------------------------------------------------------------

procedure CheckSkill(tm:TMap; ts:TMob; tsAI2:TMobAIDBFusion; Tick:Cardinal);
var
	TempSkill:TSkillDB;
begin
	if (tsAI2.Percent > Random(1000)) and (lowercase(ts.Status) = lowercase(tsAI2.Status)) and (ts.SkillWaitTick < Tick) then begin
	//if (tsAI2.Percent > Random(1000)) and (ts.SkillWaitTick < Tick) then begin
	if tsAI2.SkillID = 'RUN' then begin
      ts.Status := 'RUN';
    end else if (ts.SkillType = 0) then begin
      //ts.SkillType := 0;
      // Temp skill is used to get all the data for the skill
      TempSkill :=  SkillDBName.Objects[SkillDBName.IndexOf(tsAI2.SkillID)] as TSkillDB;

      // Skill type
      // 1: Target
      // 2: Area Effect
      // Anything else is use on self/allies
      ts.SkillType := TempSkill.SType;

      // The skill's level and ID
      ts.MSkill := TempSkill.ID;
      ts.MLevel := tsAI2.SkillLV;

      //We derive the cast time straight from the db
      ts.CastTime := tsAI2.Cast_Time;
      ts.Data.WaitTick := tsAI2.Cool_Time;
      ts.Mode := TempSkill.SType;
      NewMonsterCastTime(tm, ts, Tick);
    end;
    //MobSkills(tm, ts, Tick);
    //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Percent Passes');
  end;
end;
//------------------------------------------------------------------------------

procedure NewMonsterCastTime(tm:TMap; ts:TMob; Tick:Cardinal);
var
        tc      :TChara;
        j      :integer;
        tl      :TSkillDB;

begin

        tc := ts.AData;
        tl := SkillDB.IndexOfObject(ts.MSkill) as TSkillDB; 
	if ((tc <> nil) and (ts <> nil)) or (ts.SkillType = 4) then begin
        //j := tc.Skill[ts.MSKill].Data.CastTime1 + tc.Skill[ts.MSKill].Data.CastTime2 * ts.MSKill;
        //if j < tc.Skill[ts.MSKill].Data.CastTime3  then j := tc.Skill[ts.MSKill].Data.CastTime3;
        j := ts.CastTime;
        ts.MTick := Tick + cardinal(j);

        if (j > 0) then begin
          if ts.SkillType = 1 then begin // Skill is a target skill, we'll follow the target
                //Send Packets
                WFIFOW( 0, $013e);
                WFIFOL( 2, ts.ID);
                WFIFOL( 6, ts.ATarget);
                WFIFOW(10, 0);
                WFIFOW(12, 0);
                WFIFOW(14, ts.MSKill); //SkillID
                WFIFOL(16, tl.Element); //Element
                WFIFOL(20, j);
                SendBCmd(tm, ts.Point, 24);
                ts.ATick := Tick + cardinal(j);
                ts.MMode := 1;
          end else if ts.SkillType = 2 then begin // Skill is an area effect, we cast at it's MPoint
            WFIFOW( 0, $013e);
				    WFIFOL( 2, ts.ID);
				    WFIFOL( 6, 0);
				    WFIFOW(10, ts.MPoint.X);
				    WFIFOW(12, ts.MPoint.Y);
				    WFIFOW(14, ts.MSkill); //SkillID
				    WFIFOL(16, ts.Element); //Element
				    WFIFOL(20, j);
				    SendBCmd(tm, ts.Point, 24);
				    ts.MMode := 2;
				    ts.MTick := Tick + cardinal(j);
          end else begin  // Skill is used on the monster
            WFIFOW( 0, $013e);
            WFIFOL( 2, ts.ID);
            WFIFOL( 6, ts.ID);
            WFIFOW(10, 0);
            WFIFOW(12, 0);
            WFIFOW(14, ts.MSKill); //SkillID
            WFIFOL(16, tl.Element); //Element
            WFIFOL(20, j);
            SendBCmd(tm, ts.Point, 24);
            ts.MMode := 4;
            ts.MTick := Tick + cardinal(j);
          end;
          //Mode 3 is using a Skill
          ts.Mode := 3;



        end else begin  // There is no cast time
                //詠唱なし
                ts.Mode := 3;
                ts.MMode := 1;
                ts.ATick := Tick;
        end;
  end;

end;

//------------------------------------------------------------------------------

procedure PetAttackSkill(tm:TMap; ts:TMob; tc:TChara);
var
  i1,j1,k1:integer;
  tn:TNPC;
  tn1:TNPC;
  tpe:TPet;
	sl:TStringList;
  Tick:cardinal;
  xy:TPoint;
  //Damage:integer;
  ts1:TMob;

begin
  sl := TStringList.Create;
  tn := tc.PetNPC;
  tpe := tc.PetData;
  Tick := timeGetTime();
  if tpe.Accessory > 0 then begin
    //Ork Warrior Attack (ignores Defense)
    if tpe.JID = 1023 then begin
      if Random(10000) < (tpe.Relation) then begin
        dmg[0] := 100;
        PetDamageProcess(tm, ts, tc, dmg[0], Tick);
        SendPetSkillAttack(tm, tc, ts, Tick, 158);
      end;
    end;
    //Munak Attack (undead)
    if tpe.JID = 1026 then begin
      if Random(10000) < (tpe.Relation) then begin
        dmg[0] := 444;
        //dmg[0] := dmg[0] * (ElementTable[7][ts.Element] div 100);
        if dmg[0] < 0 then dmg[0] := 0;
        PetDamageProcess(tm, ts, tc, dmg[0], Tick);
        SendPetSkillAttack(tm, tc, ts, Tick, 190);
      end;
    end;
    //Hunter Fly Wind Attack
    if tpe.JID = 1035 then begin
      if Random(10000) < (tpe.Relation) then begin
        dmg[0] := 444;
        //dmg[0] := dmg[0] * (ElementTable[4][ts.Element] div 100);
        if dmg[0] < 0 then dmg[0] := 0;
        PetDamageProcess(tm, ts, tc, dmg[0], Tick);
        SendPetSkillAttack(tm, tc, ts, Tick, 187);
      end;
    end;
    //Poison Spore Attack
    if tpe.JID = 1077 then begin
      if Random(10000) < (tpe.Relation) then begin
        dmg[0] := 444;
        //dmg[0] := dmg[0] * (4 * (ElementTable[7][ts.Element] div 100));
        if dmg[0] < 0 then dmg[0] := 0;
        PetDamageProcess(tm, ts, tc, dmg[0], Tick);
        SendPetSkillAttack(tm, tc, ts, Tick, 187);
      end;
    end;

    //Baphomet Jr. Attack
    if tpe.JID = 1101 then begin
      if Random(10000) < (tpe.Relation) then begin
        if not Boolean(ts.Stat2 and 1) then
        ts.HealthTick[0] := Tick + tc.aMotion
        else ts.HealthTick[0] := ts.HealthTick[0] + 30000;
      end;
    end;

    // Dokkaebi Hammer Fall: (Intimacy Level/100)*1% chance of using
    // Hammer Fall on enemy when Master is attacking
    if (tpe.JID = 1110) and (tc.AData <> nil) then begin
      if Random(10000) < (tpe.Relation) then begin
        xy.X := ts.Point.X;
        xy.Y := ts.Point.Y;

        //Create Graphics and Set NPC
        tn1 := SetSkillUnit(tm, tc.ID, xy, Tick, $6E, 0, 3000, tc);

        tn1.MSkill := 110;
        tn1.MUseLV := 2;

        //Send Graphic
        WFIFOW( 0, $0117);
        WFIFOW( 2, 110);
        WFIFOL( 4, tn.ID);
        WFIFOW( 8, 2);
        WFIFOW(10, ts.Point.X);
        WFIFOW(12, ts.Point.Y);
        WFIFOL(14, 1);
        SendBCmd(tm, xy, 18);
      end;
    end;
      //Baby Desert Wolf Provoke
      if (tpe.JID = 1107) and (Random(100) > 90) then begin
        ts.ATarget := tc.ID;
        ts.ARangeFlag := false;
        ts.AData := tc;
        //Send Graphic
        WFIFOW( 0, $011a);
        WFIFOW( 2, 6);
        WFIFOW( 4, 1);
        WFIFOL( 6, tn.ID);
        WFIFOL(10, tn.ID);
        if ts.Data.Race <> 1 then begin
          WFIFOB(14, 1);
          ts.ATKPer := word(tc.Skill[6].Data.Data1[1]);
          ts.DEFPer := word(tc.Skill[6].Data.Data2[1]);
        end else begin
          WFIFOB(14, 0);
          SendBCmd(tm, tn.Point, 15);
        end;
      end;
      // Petit Heaven Drive: x% of casting Level 1 Heaven's Drive (MATK 500~600)
      //(x = Intimacy Level/100)
      if (tpe.JID = 1155) and (Random(10000) < tpe.Relation) then begin
            xy.X := ts.Point.X;
						xy.Y := ts.Point.Y;

						sl.Clear;
						for j1 := (xy.Y - tc.Skill[91].Data.Range2) div 8 to (xy.Y + tc.Skill[91].Data.Range2) div 8 do begin
							for i1 := (xy.X - tc.Skill[91].Data.Range2) div 8 to (xy.X + tc.Skill[91].Data.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].Mob.Count -1 do begin
									ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
									if (abs(ts1.Point.X - xy.X) > tc.Skill[91].Data.Range2) or (abs(ts1.Point.Y - xy.Y) > tc.Skill[91].Data.Range2) then
										Continue;
									sl.AddObject(IntToStr(ts1.ID),ts1)
								end;
							end;
						end;

                                                //If Monster is in the Area
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count -1 do begin
								ts1 := sl.Objects[k1] as TMob;

								//Caculate Damage
								dmg[0] := 500 + Random(600 - 500 + 1) * tc.Skill[91].Data.Data1[1] div 100;
								dmg[0] := dmg[0] * (100 - ts1.Data.MDEF) div 100; //MDEF%
								dmg[0] := dmg[0] - ts1.Data.Param[3]; //MDEF-
								if dmg[0] < 1 then dmg[0] := 1;
								dmg[0] := dmg[0] * ElementTable[tc.Skill[91].Data.Element][ts1.Element] div 100;
								dmg[0] := dmg[0] * tc.Skill[91].Data.Data2[1];
                if (ts1.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
								if dmg[0] < 0 then dmg[0] := 0; //Negative Damage
                //Send Attack
                PetDamageProcess(tm, ts1, tc, dmg[0], Tick);
                SendPetSkillAttack(tm, tc, ts1, Tick, 91);

                //Send Graphic
                WFIFOW( 0, $0117);
                WFIFOW( 2, 91);
			          WFIFOL( 4, tn.ID);
			          WFIFOW( 8, 1);
			          WFIFOW(10, ts.Point.X);
                WFIFOW(12, ts.Point.Y);
			          WFIFOL(14, 1);
			          SendBCmd(tm, xy, 18);

							end;
        end;
      end;
		end;

	{ChrstphrR 2004/04/26 - have to free up what you create...}
	sl.Free;
end;//proc PetAttackSkill()



//------------------------------------------------------------------------------
function DamageProcess2(tm:TMap; tc:TChara; tc1:TChara; Dmg:integer; Tick:cardinal; isBreak:Boolean = True) : Boolean;  {Monster Attacking Player}
var
    {Random Variables}
    w :Cardinal;
begin
	if tc1.HP < Dmg then Dmg := tc1.HP;  //Damage Greater than Player's Life

  if Dmg = 0 then begin  //Miss, no damage
		Result := False;
		Exit;
	end else begin
    // AlexKreuz: Hidden character unhides when they
    // get hit.
    if tc1.Skill[51].Tick > Tick then begin
      tc1.Skill[51].Tick := Tick;
      tc1.SkillTick := Tick;
    end;
  end;

	if (tc1.Stat1 <> 0) then tc1.BodyTick := Tick + tc.aMotion;

	WFIFOW(0, $0088);
	WFIFOL(2, tc1.ID);
	WFIFOW(6, tc1.Point.X);
	WFIFOW(8, tc1.Point.Y);
	SendBCmd(tm, tc1.Point, 10);

	tc1.HP := tc1.HP - Dmg;
        SendCStat1(tc1, 0, 5, tc1.HP);
	//for i := 0 to 31 do begin
		//if (ts.EXPDist[i].CData = nil) or (ts.EXPDist[i].CData = tc) then begin
			//ts.EXPDist[i].CData := tc;
			//Inc(ts.EXPDist[i].Dmg, Dmg);
			//break;
		//end;
	//end;
	//if ts.Data.MEXP <> 0 then begin
		//for i := 0 to 31 do begin
			//if (ts.MVPDist[i].CData = nil) or (ts.MVPDist[i].CData = tc) then begin
				//ts.MVPDist[i].CData := tc;
				//Inc(ts.MVPDist[i].Dmg, Dmg);
				//break;
			//end;
		//end;
	//end;

  // Monster has positive life
	if tc1.HP > 0 then begin
		if EnableMonsterKnockBack then begin
			tc1.pcnt := 0;
			if tc1.ATarget = 0 then begin
				w := Tick + tc1.dMotion + tc.aMotion;
				tc1.ATick := Tick + tc1.dMotion + tc.aMotion;
			end else begin
				w := Tick + tc1.dMotion div 2;
			end;
			if w > tc1.DmgTick then tc1.DmgTick := w;
		end else begin
			if tc1.ATarget = 0 then tc1.ATick := Tick;
			if tc1.ATarget <> tc.ID then
				tc1.pcnt := 0
			else if tc1.pcnt <> 0 then begin
				//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Character Knockback!');
				//SendMMove(tc.Socket, ts, ts.Point, ts.tgtPoint,tc.ver2);
				SendBCmd(tm, tc1.Point, 58, tc,True);
			end;
			tc1.DmgTick := 0;
		end;
		//ts.ATarget := tc.ID;
		//ts.AData := tc;
		//ts.isLooting := False;

		Result := False;
	end else begin
    {tc1.Sit := 1;
    tc1.HP := 0;
    SendCStat1(tc1, 0, 5, tc1.HP);
    WFIFOW(0, $0080);
    WFIFOL(2, tc1.ID);
    WFIFOB(6, 1);
    tc1.Socket.SendBuf(buf, 7);
    WFIFOW( 0, $0080);
    WFIFOL( 2, tc1.ID);
    WFIFOB( 6, 1);
    SendBCmd(tm, tc1.Point, 7);
    }
    //Character dies, so we simply use the new algorithm to implement exp loss as well
    CharaDie(tm, tc1, Tick);
		Result := True;
	end;
end;
//------------------------------------------------------------------------------
function DamageProcess3(tm:TMap; ts:TMob; tc1:TChara; Dmg:integer; Tick:cardinal; isBreak:Boolean = True) : Boolean;  {Monster Attacking Player}
var
    {Random Variables}
	w :Cardinal;
begin

  // Colus, 20040129: Reset Lex Aeterna
	if (tc1.Skill[78].Tick > Tick) then begin
    // Dmg := Dmg * 2;  // Done in the DamageCalc functions
    tc1.Skill[78].Tick := 0;
  end;
  
	if tc1.HP < Dmg then Dmg := tc1.HP;  //Damage Greater than Player's Life

        if Dmg = 0 then begin  //Miss, no damage
		Result := False;
		Exit;
	end else begin

        // AlexKreuz: Hidden character unhides when they
        // get hit.
                if tc1.Skill[51].Tick > Tick then begin
                        tc1.Skill[51].Tick := Tick;
                        tc1.SkillTick := Tick;
                end;
        end;

	if (tc1.Stat1 <> 0) then tc1.BodyTick := Tick + ts.Data.aMotion;

	WFIFOW(0, $0088);
	WFIFOL(2, tc1.ID);
	WFIFOW(6, tc1.Point.X);
	WFIFOW(8, tc1.Point.Y);
	SendBCmd(tm, tc1.Point, 10);

	tc1.HP := tc1.HP - Dmg;
        SendCStat1(tc1, 0, 5, tc1.HP);
	//for i := 0 to 31 do begin
		//if (ts.EXPDist[i].CData = nil) or (ts.EXPDist[i].CData = tc) then begin
			//ts.EXPDist[i].CData := tc;
			//Inc(ts.EXPDist[i].Dmg, Dmg);
			//break;
		//end;
	//end;
	//if ts.Data.MEXP <> 0 then begin
		//for i := 0 to 31 do begin
			//if (ts.MVPDist[i].CData = nil) or (ts.MVPDist[i].CData = tc) then begin
				//ts.MVPDist[i].CData := tc;
				//Inc(ts.MVPDist[i].Dmg, Dmg);
				//break;
			//end;
		//end;
	//end;

	if tc1.HP > 0 then begin
		if EnableMonsterKnockBack then begin
			tc1.pcnt := 0;
			if tc1.ATarget = 0 then begin
				w := Tick + tc1.dMotion + ts.Data.aMotion;
				tc1.ATick := Tick + tc1.dMotion + ts.Data.aMotion;
			end else begin
				w := Tick + tc1.dMotion div 2;
			end;
			if w > tc1.DmgTick then tc1.DmgTick := w;
		end else begin
			if tc1.ATarget = 0 then tc1.ATick := Tick;
			if tc1.ATarget <> ts.ID then
				tc1.pcnt := 0
			else if tc1.pcnt <> 0 then begin
				//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Character Knockback!');
				//SendMMove(tc.Socket, ts, ts.Point, ts.tgtPoint,tc.ver2);
				SendBCmd(tm, tc1.Point, 58, nil ,True);
			end;
			tc1.DmgTick := 0;
		end;
		//ts.ATarget := tc.ID;
		//ts.AData := tc;
		//ts.isLooting := False;

		Result := False;
	end else begin
                {tc1.Sit := 1;
                tc1.HP := 0;
                SendCStat1(tc1, 0, 5, tc1.HP);
                WFIFOW(0, $0080);
                WFIFOL(2, tc1.ID);
                WFIFOB(6, 1);
                tc1.Socket.SendBuf(buf, 7);
                WFIFOW( 0, $0080);
                WFIFOL( 2, tc1.ID);
                WFIFOB( 6, 1);
                 SendBCmd(tm, tc1.Point, 7); }
    // Character has died
    CharaDie(tm, tc1, Tick);
		Result := True;
	end;
end;

//------------------------------------------------------------------------------

procedure PetDamageProcess(tm:TMap; ts:TMob; tc:TChara; Dmg:integer; Tick:cardinal; isBreak:Boolean = True);
var
  //tn:TNPC;
  //tpe:TPet;
  i,j :integer;
  w :Cardinal;
  xy:TPoint;
  tg    :TGuild;
begin
  //tn := tc.PetNPC;
  //tpe := tc.PetData;

  // AlexKreuz: Needed to stop damage to Emperium
  // From Splash Attacks.
  if (ts.isEmperium) then begin
    j := GuildList.IndexOf(tc.GuildID);
    if (j <> -1) then begin
	  tg := GuildList.Objects[j] as TGuild;
      if (tg.GSkill[10000].Lv < 1) then begin
        dmg := 0;
        Exit;
      end;
    end else begin
        dmg := 0;
        Exit;
    end;
  end;
        //Cancel Monster Casting
        if ts.Mode = 3 then begin
                ts.Mode := 0;
                ts.MPoint.X := 0;
                ts.MPoint.Y := 0;
                WFIFOW(0, $01b9);
                WFIFOL(2, ts.ID);
                SendBCmd(tm, ts.Point, 6);
        end;
  // Reset Lex Aeterna
	if (ts.EffectTick[0] > Tick) then begin
    // Dmg := Dmg * 2;  // Done in the DamageCalc functions
    ts.EffectTick[0] := 0;
  end;

	if ts.HP < Dmg then Dmg := ts.HP;

	if Dmg = 0 then begin
		Exit;
	end;
	if (ts.Stat1 <> 0) and isBreak then begin
    if ts.Stat1 <> 5 then begin   //code for ankle snar, not to break
		ts.BodyTick := Tick + tc.aMotion;
    end;
	end;

  UpdateMonsterLocation(tm, ts);

	if (ts.HP - Dmg > 0) then ts.HP := ts.HP - Dmg;
	for i := 0 to 31 do begin
		if (ts.EXPDist[i].CData = nil) or (ts.EXPDist[i].CData = tc) then begin
			ts.EXPDist[i].CData := tc;
			Inc(ts.EXPDist[i].Dmg, Dmg);
			break;
		end;
	end;
	if ts.Data.MEXP <> 0 then begin
		for i := 0 to 31 do begin
			if (ts.MVPDist[i].CData = nil) or (ts.MVPDist[i].CData = tc) then begin
				ts.MVPDist[i].CData := tc;
				Inc(ts.MVPDist[i].Dmg, Dmg);
				break;
			end;
		end;
	end;
        
	if (ts.HP > 0) then begin
		//ターゲット設定
		if (EnableMonsterKnockBack) then begin
			ts.pcnt := 0;
			if ts.ATarget = 0 then begin
				w := Tick + ts.Data.dMotion + tc.aMotion;
				ts.ATick := Tick + ts.Data.dMotion + tc.aMotion;
			end else begin
				w := Tick + ts.Data.dMotion div 2;
			end;
			if w > ts.DmgTick then ts.DmgTick := w;
		end else begin
			if ts.ATarget = 0 then ts.ATick := Tick;
			if ts.ATarget <> tc.ID then
				ts.pcnt := 0
			else if (ts.pcnt <> 0)  then begin
				//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Monster Knockback!');
				        SendMMove(tc.Socket, ts, ts.Point, ts.tgtPoint,tc.ver2);
				        SendBCmd(tm, ts.Point, 58, tc,True);
			end;
			ts.DmgTick := 0;
		end;
    xy := ts.Point;
    j := SearchPath2(ts.path, tm, xy.X, xy.Y, tc.Point.X, tc.Point.Y);
    if j <> 0 then begin
        if (ts.ATarget = 0) or (ts.isActive) then begin
		ts.ATarget := tc.ID;
		ts.AData := tc;
		ts.isLooting := False;
        end;
    end;
	end else begin
		//Kill Monster
		//MonsterDie(tm, tc, ts, Tick);
	end;
end;

//------------------------------------------------------------------------------
procedure SendPetSkillAttack(tm:TMap; tc:TChara; ts:TMob; Tick:cardinal; SkillID:integer);
var
  tn:TNPC;
  tpe:TPet;
begin
  tn := tc.PetNPC;
  tpe := tc.PetData;
//01de <skill ID>.w <src ID>.l <dst ID>.l <server tick>.l <src speed>.l <dst speed>.l <param1>.l <param2>.w <param3>.w <type>.B

  if ts.HP < 0 then ts.HP := 0;
  WFIFOW( 0, $01de);
	WFIFOW( 2, SkillID);
	WFIFOL( 4, tn.ID);
	WFIFOL( 8, ts.ID);
	WFIFOL(12, Tick);
  WFIFOL(16, ts.Data.dMotion);
	WFIFOL(20, tc.aMotion);
	WFIFOL(24, dmg[0]);
	WFIFOW(28, 1);
	WFIFOW(30, 1);
  WFIFOB(32, 6);
	//else               WFIFOB(32, 8);
	//if ts.Stat1 = 5 then dmg := dmg * 2; //レックス_エーテルナ
	SendBCmd(tm, ts.Point, 33);
end;
//------------------------------------------------------------------------------

end.

