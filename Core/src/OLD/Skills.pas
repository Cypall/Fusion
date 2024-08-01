unit Skills;

(*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
Skills
2004/05/31 ChrstphrR
(Original code moved from Main, and other units, from various coders from
Weiss, EWeiss, Fusion.
I won't dare take credit for anything but reorganizing things so they're
saner to look at.)

--
Overview:
--
Routines that affect skills needed a proper home ... Main.pas should REALLY just
be code that affects some of the startup, shutdown, and Form events.  Separating
out some of this code from it will make tracking down both types of routines
easier.

--
Revisions:
--
v0.1 2004/05/31
2004/05/31 [ChrstphrR] - Initial Unit creation
"/05/31 [ChrstphrR] - Import of SkillEffect
"/06/02 [DarkHelmet] - Reorder case statements numerically (partially done)
"/06/02 [DarkHelmet] - CODE-ERROR comments added for future fixes
"/06/03 [ChrstphrR] - Added link to Skill_Constants.pas
"/06/03 [ChrstphrR] - Added FindTargetsInAttackRange to replace some of the
	code that DH mentioned - will evolve into a more general routine.
"/06/03 [ChrstphrR] - Some Memory leak fixes in SkillEffect
"/06/03 [Darkhelmet] - Organized all except the platinum skills in player vs monster


*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*)

interface

uses
	{Delphi VCL Units}
	Windows, Classes,
	{Fusion Units}
	Common, Skill_Constants, Player_Skills, Globals,
	{3rd Party Units}
	List32;

	Procedure SkillEffect(
			tc   : TChara;
			Tick : Cardinal;
            UseSP : Boolean = True
		);

	Procedure FindTargetsInAttackRange(
			TrgtList  : TIntList32;
			SData     : TSkillDB;
			Chara     : TChara;
			TrgtPt    : TPoint;
			Target    : TLiving; //May be NIL
			TargetChk : Byte
		);

const
	//TargetChk Constants for FindTargetsInAttackRange()
	CHK_NONE   = 0; // No Other Checks Needed
	CHK_SELF   = 1; // Ensure TargetList doesn't include Chara
	CHK_TARGET = 2; // Ensure TargetList doesn't include Primary Target
	CHK_GUARD  = 3; // Ensure TargetList doesn't include GuildGuardians
	CHK_GUILD  = 4; // Ensure TargetList doesn't include GuildMembers

implementation

uses
	SysUtils,
	Main, Path;


(*-----------------------------------------------------------------------------*
SkillEffect()

Overview:
	Erm... I just imported it! >.< ... it's nearly 6000 lines long, gimme a break!
	I mean... an overview of what this routine does will be forthcoming.

	This is a Weiss era routine.

	Plan of attack for changes:
	- Import into new unit to reduce clutter in Main.Pas (and DL time from CVS)
	- consistantly format using tabs for indents (you can set them to what you
	prefer for your indent style off of the Properties... menu choice when you
	right-click the source.
	- remove variables that are unused outright
	- pick out candidate code to reduce this from a 6000 line function to a few
	hundred lines.  This unit WILL be refactored.

Pre:
	Unknown
Post:
	Unknown

Revisions:
2004/04/27 [ChrstphrR] Memory Leak Fixes
"/05/31 [ChrstphrR] Imported into Skills unit from Main.pas
"/06/02 [DarkHelmet] CODE-ERROR comments where further work is needed
"/06/02 [DarkHelmet] Partial reorder of case statements by number --
	Skills grouped and marked by Job (Swordsman, Mage, Thief, etc)
*-----------------------------------------------------------------------------*)
Procedure SkillEffect(
		tc   : TChara;
		Tick : Cardinal;
        UseSP : Boolean = True
	);
Var
	j,k,m,b         : Integer;
	i               : Integer;
	L               : integer;
	i1,j1,k1        :integer;
	tm              :TMap;
	mi              :MapTbl;
	tc1             :TChara;
	tc2             :TChara;
	ts              :TMob;
	ts1             :TMob;
  td              :TItemDB;
  tg              :TGuild;
	tl              :TSkillDB;
	xy              :TPoint;
	bb              :array of byte;
	tpa             :TParty;
	sl              :TStringList;
  ma              :TMArrowDB;
  tma             :TMaterialDB;
  ProcessType     :Byte;
  DamageProcessed :boolean;
	tn :TNPC;

	//CR - 2004/06/03
	MonsterList : TIntList32;
	//Used to store list of Monsters in an area skill (i.e. splash damage)


Begin
	// Alex: This should not be preset. Depending on certain skill failure
	// such as I encountered with "Steal" this will cause the skill effect
	// to go through even when the skill fails.  I'm not sure which skills need
	// this, but it should be declared in the skill section, not out here.
	ProcessType := 99;

	if tc.Skill[269].Tick > Tick then begin  //Check if BladeStop is active
		case tc.Skill[269].Effect1 of
		1: Exit;
		2: if tc.MSkill <> 267 then exit;
		3: if ((tc.MSkill <> 267) and (tc.MSkill <> 266)) then exit;
		4: if ((tc.MSkill <> 267) and (tc.MSkill <> 266) and (tc.MSkill <> 273)) then exit;
		5: if ((tc.MSkill <> 267) and (tc.MSkill <> 266) and (tc.MSkill <> 273) and (tc.MSkill <> 271)) then exit;
		end;//case -- all exits here are safe 2004/04/27
	end;
	if tc.isSilenced then begin
		SilenceCharacter(tm, tc, Tick);
		Exit;//safe 2004/04/27
	end;

	{ChrstphrR 2004/04/26 -- moved this away from the first Exit calls.}
	sl := TStringList.Create;

	with tc do begin
    //Set the map data From the players map data
		tm := MData;

		tL := Skill[MSkill].Data;

    if Mapinfo.IndexOf(tm.Name) <> -1 then
	  	mi := MapInfo.Objects[MapInfo.IndexOf(tm.Name)] as MapTbl
    else exit;  //safe exit if map isn't found in mapinfo

    	{ Alex: Holy Shit, here we go. This needs to be
        called before any tests for target type are made
        the reason being that one skill function should
        be used for both types of targets.
        - Placed here after all declarations for safety. }
        parse_skills(tc, Tick, 0, UseSP);

		if MTargetType = 0 then begin //Target is a monster
			ts := tc.AData;

			if tL = NIL then begin
				sl.Free;
				Exit;//safe 2004/04/26
			end;

			if (ts is TMob) and (PassiveAttack = false) then begin // Edited by AlexKreuz
				if ts.isEmperium then begin
					j := GuildList.IndexOf(tc.GuildID);
					if (j <> -1) then begin
						tg := GuildList.Objects[j] as TGuild;
						if ((tg.GSkill[10000].Lv < 1) or ((ts.GID = tc.GuildID) and (tc.GuildID <> 0))) then begin
							MSkill := 0;
							MUseLv := 0;
							MMode := 0;
							MTarget := 0;
							sl.Free;
							Exit;//safe 2004/04/26
						end;
					end;
				end;

				if ((ts.isGuardian = tc.GuildID) and (tc.GuildID <> 0)) then begin //added by The Harbinger -- darkWeiss version
					MSkill := 0;
					MUseLv := 0;
					MMode := 0;
					MTarget := 0;
					sl.Free;
					Exit;//safe 2004/04/26
				end;
			end;

			if (ts = nil) or (ts.HP = 0) and (PassiveAttack = False) then begin
				MSkill := 0;
				MUseLv := 0;
				MMode := 0;
				MTarget := 0;
				sl.Free;
				Exit;//safe 2004/04/26
			end;

			//If Monster is in range of the skill
			if (Abs(tc.Point.X - ts.Point.X) <= tl.Range) AND
			 (Abs(tc.Point.Y - ts.Point.Y) <= tl.Range) then begin

				case MSkill of  {Skill Used Against Monster}

				//June 02, 2004 - Darkhelmet, I'm going to begin cleaning and organizing all these skills,
				//wish me luck!


				{Mage Skills Player vs Monster Begin}
				15:     {Frost Driver}
					begin
						//Magic Attack Damage Calculation
						dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * ( MUseLV + 100 ) div 100;
						dmg[0] := dmg[0] * (100 - ts.Data.MDEF) div 100; //MDEF%
						dmg[0] := dmg[0] - ts.Data.Param[3]; //MDEF-
						if dmg[0] < 1 then
							dmg[0] := 1;
						dmg[0] := dmg[0] * ElementTable[tl.Element][ts.Element] div 100;
						if dmg[0] < 0 then
							dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï

						if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
						//Send Attacking Packets
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);

						//Freezing Chance
						if (ts.Data.race <> 1) and (ts.Data.MEXP = 0) and (dmg[0] <> 0)then begin
							if Random(1000) < tl.Data1[MUseLV] * 10 then begin
								ts.nStat := 2;
								ts.BodyTick := Tick + tc.aMotion;
							end;
						end;
						frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick, False);
						tc.MTick := Tick + 1500;
					end;


				16:     {Stone Curse}
					begin
						j := SearchCInventory(tc, 716, false);
						if ((j <> 0) and (tc.Item[j].Amount >= 1)) or (NoJamstone) then begin

							//Use the Item
							if NOT NoJamstone then begin
								UseItem(tc, j);
							end;

							//Send Graphic Packet
							WFIFOW( 0, $011a);
							WFIFOW( 2, MSkill);
							WFIFOW( 4, dmg[0]);
							WFIFOL( 6, MTarget);
							WFIFOL(10, ID);
							WFIFOB(14, 1);
							SendBCmd(tm, ts.Point, 15);
							if Random(1000) < tl.Data1[MUseLV] * 10 then begin
								if (ts.Stat1 <> 1) then begin
									ts.nStat := 1;
									ts.BodyTick := Tick + tc.aMotion;
								end;
							end;
						end else begin
							SendSkillError(tc, 7); //No Red Gemstone
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
							Exit;
						end;
					end;

				MG_FIREBALL: //17 Fire Ball
					begin
						//XY is the targeting point.
						xy := ts.Point;
						MonsterList := TIntList32.Create;
						try
							FindTargetsInAttackRange(MonsterList,tl,tc,xy,ts,CHK_NONE);

							if MonsterList.Count > 0 then begin
								//For each monster, calculate damage inflicted.
								for k1 := 0 to MonsterList.Count -1 do begin
									ts1 := MonsterList.Objects[k1] AS TMob;
									dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
									dmg[0] := dmg[0] * (100 - ts1.Data.MDEF) div 100; //MDEF%
									dmg[0] := dmg[0] - ts1.Data.Param[3]; //Account for monsters MDEF
									if dmg[0] < 1 then dmg[0] := 1;
									dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100;
									dmg[0] := dmg[0] * tl.Data2[MUseLV];

									if dmg[0] < 0 then dmg[0] := 0; //Prevent negative damage
									if (ts1.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
									if ts = ts1 then begin
										k := 0;
									end else begin
										k := 5;
									end;
									//Send Attack Packets
									SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], tl.Data2[MUseLV], k);
									//Damage the monster
									frmMain.DamageProcess1(tm, tc, ts1, dmg[0], Tick);
								end;
							end;
						finally
							MonsterList.Free;
						end;
						tc.MTick := Tick + 1600;
					end;//17 MG_FIREBALL
				{Mage Skills Player vs Monster end}

				{Alcolyte Skills Player vs monster begin}
				28:     {Heal}
					begin
						if (ts.HP > 0) then begin

							//Check If Undead
							if (ts.Data.Race = 1) or (ts.Element mod 20 = 9) then begin
								//Damage Calculation
								dmg[0] := ((BaseLV + Param[3]) div 8) * tl.Data1[MUseLV] * ElementTable[6][ts.Element] div 200;

								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
								SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
								frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
							end else begin
								//Formula = (( BaseLv + INT) / 8ÇÃí[êîêÿéÃÇƒ ) * ( ÉqÅ[ÉãLv x 8 + 4 )
								dmg[0] := ((BaseLV + Param[3]) div 8) * tl.Data1[MUseLV];
								ts.HP := ts.HP + dmg[0];
								if ts.HP > Integer(ts.Data.HP) then ts.HP := ts.Data.HP;
								//Send Skill packet
								WFIFOW( 0, $011a);
								WFIFOW( 2, MSkill);
								WFIFOW( 4, dmg[0]);
								WFIFOL( 6, MTarget);
								WFIFOL(10, ID);
								WFIFOB(14, 1);
								SendBCmd(tm, ts.Point, 15);
							end;
							//Set Character Delay Tick
							tc.MTick := Tick + 1000;
						end else begin
							MMode := 4;
							Exit;
						end;
					end;
				30:     {Decrease Agility}
					begin
						//Send Graphics Packet
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, ts.ID);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, ts.Point, 15);

						if tc.Skill[30].EffectLV > 5 then begin
							ts.speed := ts.speed + 45;
						end else begin
							ts.speed := ts.speed + 30;
						end;

						tc.MTick := Tick + 1000;
					end;
				{Alcolyte Skills Player vs monster end}

        {Archer Skills player vs monster begin}
        47:     {Arrow Shower}
					begin
						if (Arrow = 0) or (Item[Arrow].Amount < 9) then begin
							WFIFOW(0, $013b);
							WFIFOW(2, 0);
							Socket.SendBuf(buf, 4);
							ATick := ATick + ADelay;
							Exit;
						end;

						Dec(Item[Arrow].Amount,9);

						WFIFOW( 0, $00af);
						WFIFOW( 2, Arrow);
						WFIFOW( 4, 9);
						Socket.SendBuf(buf, 6);

						if Item[Arrow].Amount = 0 then begin
							Item[Arrow].ID := 0;
							Arrow := 0;
						end;

						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0; //No Negate Damage

						//Send Attack Packet
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then begin
							frmMain.StatCalc1(tc, ts, Tick);
						end;
						xy := ts.Point;

						//Begin Area Effect
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
									if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then Continue;
									ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
									//NotTargetMonster
									//NotYourGuildMonster
									if (ts = ts1) or ((tc.GuildID <> 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID <> 0) and (ts1.GID = tc.GuildID)) then Continue;
									if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(ts1.ID),ts1);
								end;
							end;
						end;

						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								ts1 := sl.Objects[k1] as TMob;

								j := 0;
								case tc.Dir of
								0:
									begin
										if ts1.Point.Y < tc.Point.Y then j := 1;
									end;
								1:
									begin
										if (ts1.Point.X < tc.Point.X) and (ts1.Point.Y > tc.Point.Y) then j := 1;
									end;
								2:
									begin
										if ts1.Point.X > tc.Point.X then j := 1;
									end;
								3:
									begin
										if (ts1.Point.X < tc.Point.X) and (ts1.Point.Y < tc.Point.Y) then j := 1;
									end;
								4:
									begin
										if ts1.Point.Y > tc.Point.Y then j := 1;
									end;
								5:
									begin
										if (ts1.Point.X > tc.Point.X) and (ts1.Point.Y > tc.Point.Y) then j := 1;
									end;
								6:
									begin
										if ts1.Point.X < tc.Point.X then j := 1;
									end;
								7:
									begin
										if (ts1.Point.X > tc.Point.X) and (ts1.Point.Y > tc.Point.Y) then j := 1;
									end;
								end;

								if j <> 1 then begin
									frmMain.DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
									if dmg[0] < 0 then dmg[0] := 0; //No Negative Damage
									//Send Graphics Packet
									SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1, 5);
									//Damage Process for Monster
									if not frmMain.DamageProcess1(tm, tc, ts1, dmg[0], Tick) then
										frmMain.StatCalc1(tc, ts1, Tick);
								end;
							end;
						end;
					end;
        {Archer Skills player vs monster end}
				{Thief Skills player vs monster begin}
				50: {Steal}
				{Colus, 20040305: Redid it all.  Again.  Using info on formulas obtained
				from fansites and confirmations on algorithm from disassemblers.}
					begin
						if not (StealItem(tc)) then begin
							SendSkillError(tc, 0);
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
							DecSP(tc, 50, MUseLV);
						end;
						// Delay after stealing
						tc.MTick := Tick + 1000;
					end; {end Steal}
				52:     {Poison}
					begin
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, 100, tl.Element);
						dmg[0] := dmg[0] + 15 * MUseLV;
						dmg[0] := dmg[0] * ElementTable[tl.Element][ts.Element] div 100;
						if dmg[0] < 0 then dmg[0] := 0; //No Negative Damage
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
						k1 := (BaseLV * 2 + MUseLV * 3 + 10) - (ts.Data.LV * 2 + ts.Data.Param[2]);
						k1 := k1 * 10;
						if Random(1000) < k1 then begin
							if not Boolean(ts.Stat2 and 1) then
								ts.HealthTick[0] := Tick + tc.aMotion
							else ts.HealthTick[0] := ts.HealthTick[0] + 30000;
						end;

						frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
					end;
				{Thief Skills player vs monster end}

			54:     {Resurrection}
				begin
					j := SearchCInventory(tc, 717, false);
					if ((j <> 0) and (tc.Item[j].Amount >= 1)) or (NoJamstone = True) or (tc.ItemSkill = true) then begin

						//Damage Calculation
						// Colus, 20040123: Rearranged checks for undead, itemskill, and item usage

						if (ts.Data.Race = 1) or (ts.Element mod 20 = 9) then begin
							if NOT (NoJamstone AND ItemSkill ) then UseItem(tc, j);

							if (Random(1000) < MUseLV * 20 + Param[3] + Param[5] + BaseLV + Trunc((1 - HP / MAXHP) * 200)) and (ts.Data.MEXP = 0) then begin
								dmg[0] := ts.HP;
							end else begin
								dmg[0] := (BaseLV + Param[3] + (MUseLV * 10)) * ElementTable[6][ts.Element] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
							end;

							// Shouldn't need to cap this any more...
							//if (dmg[0] div $010000) <> 0 then dmg[0] := $07FFF; //ï€åØ
							if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;

							SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
							frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
							tc.MTick := Tick + 3000;
						end else begin
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
						end;
					end else begin
						SendSkillError(tc, 8); //No Blue Gemstone
						tc.MMode := 4;
						tc.MPoint.X := 0;
						tc.MPoint.Y := 0;
						Exit;
					end;
				end;
        {Knight skills player vs monster end}

				56:     {Pierce}
					begin
						//Check if player has a Spear
						if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
							frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
							j := ts.Data.Scale + 1;
							dmg[0] := dmg[0] * j;
							if dmg[0] < 0 then dmg[0] := 0;
							SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], j);
							if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
								frmMain.StatCalc1(tc, ts, Tick);
						end else begin
							SendSkillError(tc, 6);
							MMode := 4;
							Exit;
						end;
					end;

				57:     {Brandish Spear}
					begin
						//if ts.HP <= 0 then exit;
						if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
							xy.X := ts.Point.X - Point.X;
							xy.Y := ts.Point.Y - Point.Y;
							if abs(xy.X) > abs(xy.Y) * 3 then begin
								if xy.X > 0 then b := 6 else b := 2;
							end else if abs(xy.Y) > abs(xy.X) * 3 then begin
								if xy.Y > 0 then b := 0 else b := 4;
							end else begin
								if xy.X > 0 then begin
									if xy.Y > 0 then b := 7 else b := 5;
								end else begin
									if xy.Y > 0 then b := 1 else b := 3;
								end;
							end;
							frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
							if dmg[0] < 0 then dmg[0] := 0;

							SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
							if (dmg[0] > 0) then begin
								xy := ts.Point;
								sl.Clear;
								for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
									for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
										for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
											ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
											//NotTargetMonster
											if ts = ts1 then
												Continue;
											if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
												sl.AddObject(IntToStr(ts1.ID),ts1);
										end;
									end;
								end;

								if sl.Count <> 0 then begin
									for k1 := 0 to sl.Count - 1 do begin
										ts1 := sl.Objects[k1] as TMob;
										frmMain.DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
										if dmg[0] < 0 then
											dmg[0] := 0;
										SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1, 5);

										if not frmMain.DamageProcess1(tm, tc, ts1, dmg[0], Tick) then
											frmMain.StatCalc1(tc, ts1, Tick);

										SetLength(bb, 6);
										bb[0] := 6;
										xy := ts1.Point;
										if ts1.HP <= 0 then break;
										DirMove(tm, ts1.Point, b, bb);

										if (xy.X div 8 <> ts1.Point.X div 8) or (xy.Y div 8 <> ts1.Point.Y div 8) then begin
											with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
												Assert(IndexOf(ts1.ID) <> -1, 'MobBlockDelete Error');
												Delete(IndexOf(ts1.ID));
											end;
											tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);
											ts1.pcnt := 0;

											UpdateMonsterLocation(tm, ts1);
										end;

									end;
								end;
							end;

							if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then begin
								frmMain.StatCalc1(tc, ts, Tick);
							end;
						end else begin
							SendSkillError(tc, 6);
							MMode := 4;
							Exit;
						end;
					end;
        58:     {Spear Stab}
					begin
						if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
							xy.X := ts.Point.X - Point.X;
							xy.Y := ts.Point.Y - Point.Y;
							if abs(xy.X) > abs(xy.Y) * 3 then begin
								//Knockback Distance?
								if xy.X > 0 then b := 6 else b := 2;
							end else if abs(xy.Y) > abs(xy.X) * 3 then begin
								//ècå¸Ç´
								if xy.Y > 0 then b := 0 else b := 4;
							end else begin
								if xy.X > 0 then begin
									if xy.Y > 0 then b := 7 else b := 5;
								end else begin
									if xy.Y > 0 then b := 1 else b := 3;
								end;
							end;

							//Calculate Damage
							frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
							if dmg[0] < 0 then dmg[0] := 0; //No Negative Damage

							//Send Attacking Packet
							SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);

							//Begin Knockback
							if (dmg[0] > 0) then begin
								SetLength(bb, 6);
								bb[0] := 6;
								xy := ts.Point;
								DirMove(tm, ts.Point, b, bb);

								//Knockback Monster
								if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
									with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
										assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
										Delete(IndexOf(ts.ID));
									end;
									tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
								end;
								ts.pcnt := 0;

								//Update Coordinates of Monster
								UpdateMonsterLocation(tm, ts);
							end;

							if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
								frmMain.StatCalc1(tc, ts, Tick);

						end else begin
							SendSkillError(tc, 6);
							MMode := 4;
							Exit;
						end;
					end;

				59: {Spear_Boomerang}
					begin
						if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
							frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
							if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
							//ÉpÉPëóêM
							SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
							if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
								frmMain.StatCalc1(tc, ts, Tick);
							tc.MTick := Tick + 1000
						end else begin
							SendSkillError(tc, 6);
							MMode := 4;
							Exit;
						end;
					end;

				KN_BOWLINGBASH: {Bowling_Bash - 62}
					begin
						//Ç∆ÇŒÇ∑ï˚å¸åàíËèàóù
						//FWÇ©ÇÁÇÃÉpÉNÉä
						xy.X := ts.Point.X - Point.X;
						xy.Y := ts.Point.Y - Point.Y;
						if abs(xy.X) > abs(xy.Y) * 3 then begin
							//â°å¸Ç´
							if xy.X > 0 then b := 6 else b := 2;
						end else if abs(xy.Y) > abs(xy.X) * 3 then begin
							//ècå¸Ç´
							if xy.Y > 0 then b := 0 else b := 4;
						end else begin
							if xy.X > 0 then begin
								if xy.Y > 0 then b := 7 else b := 5;
							end else begin
								if xy.Y > 0 then b := 1 else b := 3;
							end;
						end;

						//íeÇ´îÚÇŒÇ∑ëŒè€Ç…ëŒÇ∑ÇÈÉ_ÉÅÅ[ÉWÇÃåvéZ
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);

						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, 3);
							bb[0] := 4;
							xy := ts.Point;
							DirMove(tm, ts.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
									assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(ts.ID));
								end;
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end;
							ts.pcnt := 0;

							UpdateMonsterLocation(tm, ts);

							xy := ts.Point;
							//ä™Ç´Ç±Ç›îÕàÕçUåÇ
							sl.Clear;
							for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
								for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
									for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
										if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then Continue;
										ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
										//NotTargetMonster
										//NotYourGuildMonster
										if (ts = ts1) or ((tc.GuildID <> 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID <> 0) and (ts1.GID = tc.GuildID)) then Continue;
										if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
											sl.AddObject(IntToStr(ts1.ID),ts1);
									end;
								end;
							end;
							if sl.Count <> 0 then begin
								for k1 := 0 to sl.Count - 1 do begin
									ts1 := sl.Objects[k1] as TMob;
									frmMain.DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
									if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
									//ÉpÉPëóêM
									SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1, 5);
									//É_ÉÅÅ[ÉWèàóù
									if not frmMain.DamageProcess1(tm, tc, ts1, dmg[0], Tick) then
      							frmMain.StatCalc1(tc, ts1, Tick);
								end;
							end;
						end;
						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then begin
							frmMain.StatCalc1(tc, ts, Tick);
						end;

					end;
          {Knight skills player vs monster end}

          {Priest skills player vs monster begin}

          72: // Status Recovery vs. Mob (undead)
					begin
						ts.ATarget := 0;
						if ts.Element mod 20 = 9 then begin
							//ÉpÉPëóêM
							WFIFOW( 0, $011a);
							WFIFOW( 2, MSkill);
							WFIFOW( 4, MUseLV);
							WFIFOL( 6, MTarget);
							WFIFOL(10, ID);
							WFIFOB(14, 1);
							SendBCmd(tm, ts.Point, 15);
							//ëŒÉAÉìÉfÉbÉh
							if Boolean((1 shl 4) and ts.Stat2) then begin
								ts.HealthTick[4] := ts.HealthTick[4] + 30000; //âÑí∑
							end else begin
								ts.HealthTick[4] := Tick + tc.aMotion;
							end;
						end;
					end;
				76: // Lex Divina vs. Mob
					begin
						//ÉpÉPëóêM
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, ts.Point, 15);
						//ëŒÉAÉìÉfÉbÉh
						if Boolean((1 shl 2) and ts.Stat2) then begin
							ts.HealthTick[2] := ts.HealthTick[2] + 30000; //âÑí∑
						end else begin
							ts.HealthTick[2] := Tick + tc.aMotion;
						end;
					end;

				77: // Turn Undead Damage vs. Mob
					begin
						if (ts.Data.Race = 1) or (ts.Element mod 20 = 9) then begin
							m := MUseLV * 20 + Param[3] + Param[5] + BaseLV + (200 - 200 * Cardinal(ts.HP) div ts.Data.HP) div 200;
							if (Random(1000) < m) and (ts.Data.MEXP = 0) then begin
								dmg[0] := ts.HP;
							end else begin
								dmg[0] := (BaseLV + Param[3] + (MUseLV * 10)) * ElementTable[6][ts.Element] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
							end;
							//ëŒÉAÉìÉfÉbÉh
							//if (dmg[0] div $010000) <> 0 then dmg[0] := $07FFF; //ï€åØ
							// Lex Aeterna effect
							if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
							SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
							frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
							tc.MTick := Tick + 3000;
						end else begin
							tc.MMode := 4;
							Exit;
						end;
					end;

				78: // Lex Aeterna
					begin
						//ÉpÉPëóêM
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, ts.Point, 15);

						// Colus, 20040126: Can't use Stat1 for Lex.  Those effects stop the
						// monster.  Instead we set an effect tick, which (currently) isn't
						// being used for anything!  Convenient!

						if ((ts.Stat1 < 1) or (ts.Stat1 > 2)) then
							ts.EffectTick[0] := $FFFFFFFF;

						tc.MTick := Tick + 3000;
						{if (ts.Stat1 = 0) or (ts.Stat1 = 3) or (ts.Stat1 = 4) then begin
							ts.nStat := 5;
							ts.BodyTick := Tick + tc.aMotion;
						end else if (ts.Stat1 = 5) then ts.BodyTick := ts.BodyTick + 30000;}
				end;

        {Priest skills player vs monster end}
        {Wizard skills player vs monster begin}
        84: //JT
					begin
						if tc.ID = ts.ID then Exit;

						xy.X := ts.Point.X - Point.X;
						xy.Y := ts.Point.Y - Point.Y;
						if abs(xy.X) > abs(xy.Y) * 3 then begin
							//â°å¸Ç´
							if xy.X > 0 then   b := 6 else b := 2;
						end else if abs(xy.Y) > abs(xy.X) * 3 then begin
							//ècå¸Ç´
							if xy.Y > 0 then   b := 0 else b := 4;
						end else begin
							if xy.X > 0 then begin
								if xy.Y > 0 then b := 7 else b := 5;
							end else begin
								if xy.Y > 0 then b := 1 else b := 3;
							end;
						end;

						//É_ÉÅÅ[ÉWéZèo
						dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
						dmg[0] := dmg[0] * (100 - ts.Data.MDEF) div 100; //MDEF%
						dmg[0] := dmg[0] - ts.Data.Param[3]; //MDEF-
						if dmg[0] < 1 then dmg[0] := 1;
						dmg[0] := dmg[0] * ElementTable[tl.Element][ts.Element] div 100;
						dmg[0] := dmg[0] * tl.Data2[MUseLV];
						if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], tl.Data2[MUseLV]);
						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, tl.Data2[MUseLV] div 2);
							bb[0] := 4;
							xy.X := ts.Point.X;
							xy.Y := ts.Point.Y;
							DirMove(tm, ts.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
									assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(ts.ID));
								end;
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end;
							ts.pcnt := 0;
						//Update Monster Location
						UpdateMonsterLocation(tm, ts);
						end;
						frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
					end;

				88: // Frost Nova
					begin
						dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100;
						dmg[0] := dmg[0] * (100 - ts.Data.MDEF) div 100; //MDEF%
						dmg[0] := dmg[0] - ts.Data.Param[3]; //MDEF-
						if dmg[0] < 1 then
							dmg[0] := 1;

						dmg[0] := dmg[0] * ElementTable[tl.Element][ts.Element] div 100;
						if dmg[0] < 0 then
							dmg[0] := 0;

						if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1 , 5);

						if (ts.Data.race <> 1) and (ts.Data.MEXP = 0) and (dmg[0] <> 0) then begin
							if Random(1000) < tl.Data1[MUseLV] * 10 then begin
								ts.nStat := 2;
								ts.BodyTick := Tick + tc.aMotion;
							end;
						end;
						frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
						tc.MTick := Tick + 1000;
					end;

				86: // Water Ball
					begin
						k := tl.Data2[MUseLV];
						b := 0;
						for j1 := (tc.Point.Y - k)  to (tc.Point.Y + k) do begin
							for i1 := (tc.Point.X - k) to (tc.Point.X + k) do begin
								if (tm.gat[i1][j1] = 3) then b := 1;
							end;
						end;

						if (b = 0) then begin
							SendSkillError(tc, 0);
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
							exit;
						end;

						tc.Skill[86].Tick := Tick;
																								k := tl.Data1[MUseLV];
						tc.Skill[86].EffectLV := k;
						tc.Skill[86].Effect1 := tc.MUseLV;
						frmMain.DamageOverTime(tm, tc, Tick, 86, MUseLV, k);
					end;

          93: //Sense
					begin
						ts := AData;
						WFIFOW(0, $018c);
						WFIFOW(2, ts.Data.ID);//ID
						WFIFOW(4, ts.Data.LV);//ÉåÉxÉã
						WFIFOW(6, ts.Data.Scale);//ÉTÉCÉY
						WFIFOL(8, ts.HP);//HP
						//WFIFOW(10, 0);//
						WFIFOW(12, ts.Data.DEF);//DEF
						WFIFOW(14, ts.Data.Race);//éÌë∞
						WFIFOW(16, ts.Data.MDEF);//MDEF
						WFIFOW(18, ts.Element);//ëÆê´
						for j := 0 to 8 do begin
							if (ElementTable[j+1][ts.Element] < 0) then begin
								WFIFOB(20+j, 0);//É}ÉCÉiÉXÇæÇ∆îÕàÕÉGÉâÅ[èoÇ∑ÇÃÇ≈0Ç…Ç∑ÇÈ
							end else begin
								WFIFOB(20+j, ElementTable[j+1][ts.Element]);//ñÇñ@ëäê´ëÆê´
							end;
						end;
						Socket.SendBuf(buf,29);//édólÇ∆ÇµÇƒÇÕÇ±Ç¡ÇøÇÃï˚Ç™ÇﬁÇµÇÎÇ¢Ç¢ÇÃÇ≈ÇÕÅHñ{êlÇÃÇ›Ç…å©ÇπÇÈ
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, dmg[0]);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, ts.Point, 15);
					end;
        {Wizard skills player vs monster end}

        {Hunter skills player vs monster begin}
        129://129 Blitz beat
					begin
						xy := ts.Point;
						//É_ÉÅÅ[ÉWéZè
						if tc.Option and 16 <> 0 then begin
							sl.Clear;
							MonsterList := TIntList32.Create;
							try
								FindTargetsInAttackRange(MonsterList,tl,tc,xy,ts,CHK_NONE);

								if MonsterList.Count > 0 then begin
									if Skill[128].Lv <> 0 then begin
										dmg[1] := Skill[128].Data.Data1[Skill[128].Lv] * 2;
									end else begin
										dmg[1] := 0
									end;
									dmg[1] := dmg[1] + (Param[4] div 10 + Param[3] div 2) * 2 + 80;
									dmg[1] := dmg[1] * MUseLV;

									//For each monster, calculate damage inflicted.
									for k1 := 0 to MonsterList.Count -1 do begin
										ts1 := MonsterList.Objects[k1] AS TMob;
										dmg[0] := dmg[1] * ElementTable[tl.Element][ts1.Element] div 100;
										if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
										if (ts1.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
										//Send Attack Packets
										SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], MUseLV);
										//Damage the monster
										frmMain.DamageProcess1(tm, tc, ts1, dmg[0], Tick);
									end;
								end;
							finally
								MonsterList.Free;
							end;
						end else begin
							MMode := 4;
							sl.Free;
							Exit;//Safe 2004/06/03
						end;
					end;
        {Hunter skills player vs monster end}
        {Assassain Skills player vs monster begin}
        136:  {Sonic Blows}
					begin
						if (tc.Weapon = 16) then begin
							frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
							j := 8;
							if dmg[0] < 0 then dmg[0] := 0;
							SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], j);
							if (Skill[145].Lv <> 0) and (MSkill = 5) and (MUseLV > 5) then begin //ã}èäìÀÇ´
								if Random(1000) < Skill[145].Data.Data1[MUseLV] * 10 then begin
									if (ts.Stat1 <> 3) then begin
										ts.nStat := 3;
										ts.BodyTick := Tick + tc.aMotion;
									end else ts.BodyTick := ts.BodyTick + 30000;
								end;
							end;
							if NOT frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
								frmMain.StatCalc1(tc, ts, Tick);
							tc.MTick := Tick + 1000;
						end else begin
							MMode := 4;
							Exit;
						end;
					end;
				137:    {Grimtooth}
					begin
						if (tc.Option and 2 <> 0) and (Weapon = 16) then begin
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							frmMain.StatCalc1(tc, ts, Tick);

						xy := ts.Point;
						//É_ÉÅÅ[ÉWéZèo2
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
									if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then Continue;
									ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
									//NotTargetMonster
									//NotYourGuildMonster
									if (ts = ts1) or ((tc.GuildID <> 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID <> 0) and (ts1.GID = tc.GuildID)) then Continue;
									if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(ts1.ID),ts1);
								end;
							end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								ts1 := sl.Objects[k1] as TMob;
								frmMain.DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
								if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								//ÉpÉPëóêM
								SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1, 5);
								//É_ÉÅÅ[ÉWèàóù
								if not frmMain.DamageProcess1(tm, tc, ts1, dmg[0], Tick) then
									frmMain.StatCalc1(tc, ts1, Tick);
							end;
						end;
						end else begin
							MMode := 4;
							Exit;
						end;
					end;

       141:  //Venom Splasher
				begin
					WFIFOW( 0, $011a);
					WFIFOW( 2, MSkill);
					WFIFOW( 4, MUseLV);
					WFIFOL( 6, MTarget);
					WFIFOL(10, ID);
					WFIFOB(14, 1);
					SendBCmd(tm, ts.Point, 15);
					if ts.Stat2 = 1 then begin
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0;

						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							frmMain.StatCalc1(tc, ts, Tick);
					end else begin
						SendSkillError(tc, 6);
						MMode := 4;
						Exit;
					end;
				end;

       {Assassain Skills player vs monster end}
       153:  {Cart_Revolution}
					begin
						xy.X := ts.Point.X - Point.X;
						xy.Y := ts.Point.Y - Point.Y;
						if abs(xy.X) > abs(xy.Y) * 3 then begin
							//â°å¸Ç´
							if xy.X > 0 then b := 6 else b := 2;
						end else if abs(xy.Y) > abs(xy.X) * 3 then begin
							//ècå¸Ç´
							if xy.Y > 0 then b := 0 else b := 4;
						end else begin
							if xy.X > 0 then begin
								if xy.Y > 0 then b := 7 else b := 5;
							end else begin
								if xy.Y > 0 then b := 1 else b := 3;
							end;
						end;

						//DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, 150 + (tc.Cart.Weight div 800), tl.Element, 0);
						//dmg[0] := dmg[0] + ((100 + (tc.Cart.Weight div 800)) div 100);
						if dmg[0] < 0 then dmg[0] := 0;

						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);

						if (dmg[0] > 0) then begin
							SetLength(bb, 2);
							bb[0] := 0; // Just push in the direction you're casting
							bb[1] := 0; // for 2 tiles.
							xy := ts.Point;
							DirMove(tm, ts.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
									assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(ts.ID));
								end;
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end;
							ts.pcnt := 0;
							//Update Monster Location
							UpdateMonsterLocation(tm, ts);
						end;
						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							frmMain.StatCalc1(tc, ts, Tick);

						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
									if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then Continue;
									ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
									//NotTargetMonster
									//NotYourGuildMonster
									if (ts = ts1) or ((tc.GuildID <> 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID <> 0) and (ts1.GID = tc.GuildID)) then Continue;
									if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(ts1.ID),ts1);
								end;
							end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								ts1 := sl.Objects[k1] as TMob;

								xy.X := ts1.Point.X - Point.X;
								xy.Y := ts1.Point.Y - Point.Y;
								if abs(xy.X) > abs(xy.Y) * 3 then begin
									//â°å¸Ç´
									if xy.X > 0 then b := 6 else b := 2;
									end else if abs(xy.Y) > abs(xy.X) * 3 then begin
										//ècå¸Ç´
										if xy.Y > 0 then b := 0 else b := 4;
										end else begin
											if xy.X > 0 then begin
											if xy.Y > 0 then b := 7 else b := 5;
										end else begin
											if xy.Y > 0 then b := 1 else b := 3;
									end;
								end;

								frmMain.DamageCalc1(tm, tc, ts1, Tick, 0, 150 + (tc.Cart.Weight div 800), tl.Element, 0);
								//dmg[0] := dmg[0] + (tc.Cart.MaxWeight div 8000);
								if dmg[0] < 0 then dmg[0] := 0;

								if (dmg[0] > 0) then begin
									SetLength(bb, 2);
									bb[0] := 0; // Just push in the direction you're casting
									bb[1] := 0; // for 2 tiles.
									//bb[0] := 6;
									xy := ts1.Point;
									DirMove(tm, ts1.Point, b, bb);
									//ÉuÉçÉbÉNà⁄ìÆ
									if (xy.X div 8 <> ts1.Point.X div 8) or (xy.Y div 8 <> ts1.Point.Y div 8) then begin
										with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
											Assert(IndexOf(ts1.ID) <> -1, 'MobBlockDelete Error');
											Delete(IndexOf(ts1.ID));
										end;
										tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);
									end;
									ts1.pcnt := 0;
									UpdateMonsterLocation(tm, ts1);

								end;
								if not frmMain.DamageProcess1(tm, tc, ts1, dmg[0], Tick) then begin
									frmMain.StatCalc1(tc, ts1, Tick);
								end;
							end;
						end;

					end;


			{Rouge Skills player vs monster begin}
			211:    {Steal Coin}
				begin
					j := Random(7);
					if (Random(100) < tl.Data1[MUseLV]) then begin
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, ts.Point, 15);
						//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Steal zeny success');
						k := ts.Data.LV * 5;
						Inc(Zeny, k);
						// Update Zeny
						SendCStat1(tc, 1, $0014, tc.Zeny);
					end;
				end;{Steal Coin}
			212:    {Back Stab}
				begin
					if ts.Dir = tc.Dir then begin
						if (tc.Option and 2 <> 0) then begin
							tc.Option := tc.Option and $FFFD;
							tc.Hidden := false;
							tc.Skill[51].Tick := Tick;
							tc.SkillTick := Tick;
							tc.SkillTickID := 51;
							CalcStat(tc, Tick);
							UpdateOption(tm, tc);
							// Colus, 20040319: Actually you can Backstab while visible.
						end;
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							frmMain.StatCalc1(tc, ts, Tick);
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
						frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
						tc.MTick := Tick + 500;
					end else begin
						SendSkillError(tc, 0);
						MMode := 4;
						sl.Free;
						Exit;//safe 2004/04/26
					end;
				end;
				214: //Raid
				begin
					// Colus, 20040204: Option change, testing option 2 instead of 4+2
					if (tc.Option and 2 <> 0) then begin
						tc.Option := tc.Option and $FFFD;
						tc.Hidden := false;
						tc.Skill[51].Tick := Tick;
						tc.SkillTick := Tick;
						tc.SkillTickID := 51;
						CalcStat(tc, Tick);
						UpdateOption(tm, tc);

						xy := tc.Point;
						MonsterList := TIntList32.Create;
						try
							FindTargetsInAttackRange(MonsterList,tl,tc,xy,ts,CHK_NONE);

							if MonsterList.Count > 0 then begin
								//For each monster, calculate damage inflicted.
								for k1 := 0 to MonsterList.Count -1 do begin
									ts1 := MonsterList.Objects[k1] AS TMob;
									frmMain.DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
									if dmg[0] < 1 then dmg[0] := 1;
									//if dmg[0] < 0 then dmg[0] := 0;
									//k := 1;
									SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1);
									frmMain.DamageProcess1(tm, tc, ts1, dmg[0], Tick);
								end;
							end;
						finally
							MonsterList.Free;
						end;
					end else begin
						SendSkillError(tc, 0);
						tc.MMode := 4;
						tc.MPoint.X := 0;
						tc.MPoint.Y := 0;
						sl.Free;
						Exit;//safe 2004/06/03
					end;
				end;

				215,216,217,218:
				{ 215: Strip Weapon
					216: Strip Shield
					217: Strip Armor
					218: Strip Helm }
					begin
						i := (tc.Param[4] - ts.Data.Param[4]);
						if i < 0 then i := 0;
						i := tl.Data2[MUseLV] + i;
						if (Random(100) < i) then begin
							ts.ATarget := tc.ID;
							ts.ARangeFlag := false;
							ts.AData := tc;
							//Send Skill Packet
							//CODE-ERROR - Darkhelmet, we use this packet over and over, why not make a procedure?
							WFIFOW( 0, $011a);
							WFIFOW( 2, MSkill);
							WFIFOW( 4, MUseLV);
							WFIFOL( 6, MTarget);
							WFIFOL(10, ID);
							if ts.Data.Race <> RACE_UNDEAD then begin
								WFIFOB(14, 1);
								if MSkill = 215 then begin
									//Lower Monster's Attack
									ts.ATKPer := ts.ATKPer - (ts.ATKPer * 10 div 100);
								end else if MSkill = 216 then begin
									//Lower Monster's Defense
									ts.DEF1 := ts.DEF1 - (ts.DEF1 * 15 div 100);
									ts.DEF2 := ts.DEF2 - (ts.DEF2 * 15 div 100);
								end else if MSkill = 217 then begin
									//Lower Monster's Agility, should probably decrease their speed....
									//CODE-ERROR - Darkhelmet, agility never goes into any calcs...
									// we should decrease speed instead
									ts.Data.Param[2] := ts.Data.Param[2] - (ts.Data.Param[2] * 40 div 100);
								end else if MSkill = 218 then begin
									//Decrease Intelligence
									ts.Data.Param[3] := ts.Data.Param[3] - (ts.Data.Param[3] * 40 div 100);
								end else begin  //I believe this means the monster is an MVP
									WFIFOB(14, 0);
								end;
								SendBCmd(tm, ts.Point, 15);
							end;
						end;
					end;

			219:    {Intimidate}
				begin
					frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
					if dmg[0] < 0 then dmg[0] := 0;
					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
					if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
						frmMain.StatCalc1(tc, ts, Tick);

					tc.intimidateActive := true;
					tc.intimidateTick := Tick + 1000;

					{i := MapInfo.IndexOf(tc.Map);
					j := -1;
					if (i <> -1) then begin
						mi := MapInfo.Objects[i] as MapTbl;
						if (mi.noTele) then j := 0;
					end;
					if (j <> 0) then begin
							tm := tc.MData;
						j := 0;
						repeat
							xy.X := Random(tm.Size.X - 2) + 1;
							xy.Y := Random(tm.Size.Y - 2) + 1;
							Inc(j);
						until ( ((tm.gat[xy.X, xy.Y] <> 1) and (tm.gat[xy.X, xy.Y] <> 5)) or (j = 100) );

						if j <> 100 then begin
							SendCLeave(tc, 3);
							tc.Point := xy;
							MapMove(Socket, tc.Map, tc.Point);
						end;
						ts.Point.X := tc.Point.X;
						ts.Point.Y := tc.Point.Y;
						if ts.HP > 0 then SendMmove(Socket, ts, ts.Point, tc.Point, ver2);
					end;  }

				end;{Intimidate}
      230:  //Acid Terror
				begin
					j := SearchCInventory(tc, 7136, false);
					if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
						UseItem(tc, j); //Use Item Function Call
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then
							dmg[0] := 0;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							frmMain.StatCalc1(tc, ts, Tick);
					end else begin
						tc.MMode := 4;
						tc.MPoint.X := 0;
						tc.MPoint.Y := 0;
						SL.Free;
						Exit;//safe 2004/04/26
					end;
				end;
      {Monk skills player vs monster begin}
      263:   {Triple Blows}
				begin
					if (tc.Weapon = 12) or (tc.Weapon = 0) then begin
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data2[MUseLV], tl.Element, 0);
						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 2);
						UpdateIcon(tm, tc, $59);
						Delay := (1000 - (4 * param[1]) - (2 * param[4]) + 300);
						//tc.ATick := timeGetTime() + Delay;
						MonkDelay(tm, tc, tc.Delay);

						tc.ATick := Tick + Cardinal(Delay);

						if NOT frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then begin
							frmMain.StatCalc1(tc, ts, Tick);
						end;
					end else begin
						MMode := 4;
						sl.Free;
						Exit;//safe 2004/04/26
					end;
				end;{Triple Blows}
      264:   {Body Relocation}  //New Version Oatmeal style U_U
				begin
					// Colus, 20040225: Never called?
					if tc.spiritSpheres <> 0 then begin
						//Send Graphics Packet
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, ts.ID);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						// Colus, 20040225: Oatmeal, until you send the packet,
						// ANY other packet you send will overwrite what you've
						// already done.  You cannot do the UpdateSpiritSpheres
						// call (which makes a new packet) until you send the old one.
						SendBCmd(tm, ts.Point, 15);
						tc.spiritSpheres := tc.spiritSpheres - 1;
						UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

						if tc.Skill[264].EffectLV > 1 then begin
							ts.speed := ts.speed - 45;
						end else begin
							ts.speed := ts.speed - 30;
						end;

						tc.MTick := Tick + 1000;
					end;
				end;
      266:    {Investigate}
				begin
					if tc.spiritSpheres <> 0 then begin
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						if dmg[0] < 1 then begin
							dmg[0] := 1;
						end;
						if dmg[0] < 0 then begin
							dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
							//ÉpÉPëóêM
						end;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], tl.Data2[MUseLV]);
						frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);

						tc.MTick := Tick + 1000;
						tc.spiritSpheres := tc.spiritSpheres - 1;
						UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
					end;
				end;
			267:    {Finger Offensive}
				begin
					if (SearchAttack(path, tm, Point.X, Point.Y, ts.Point.X, ts.Point.Y) <> 0) then begin
						if tc.spiritSpheres >= tc.MUseLV then begin
							//É_ÉÅÅ[ÉWéZè
							frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
							if dmg[0] < 1 then begin
								dmg[0] := 1;
							end;
							dmg[0] := dmg[0] * tl.Data2[MUseLV];
							if dmg[0] < 0 then begin
								dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								//ÉpÉPëóêM
							end;
							SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], tl.Data2[MUseLV]);
							frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
							tc.MTick := Tick + 1000;
							tc.spiritSpheres := tc.spiritSpheres - tc.MUseLV;
							UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
						end;
					end;
				end;

			271:    {Extremity Fist}
				begin
					if tc.Skill[270].Tick > Tick then begin
						if (tc.Skill[271].Data.SType = 1) then begin
							if tc.spiritSpheres = 5 then begin
								frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
								spbonus := tc.SP;
								dmg[0] := dmg[0] *(8 + tc.SP div 100) + 250 + (tc.Skill[271].Lv * 150);
								dmg[0] := dmg[0] + j;
								if dmg[0] < 0 then begin
									dmg[0] := 0;
									//ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								end;
								{SetLength(bb, 6);
								//bb[0] := 6;

								xy := tc.Point;
								DirMove(tm, tc.Point, tc.Dir, bb);

								if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
									with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
										Assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
										Delete(IndexOf(tc.ID));
									end;
									tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
								end;
								tc.pcnt := 0;

								UpdatePlayerLocation(tm, tc);  }
								frmMain.KnockBackLiving(tm, tc, ts, 6, 2);

								SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
								frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
								tc.MTick := Tick + Cardinal(3500 + (tl.CastTime2 * MUseLV));
								tc.spiritSpheres := tc.spiritSpheres - 5;
								UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

								{20031223, Colus: Cancel Explosion Spirits after Ashura
								 Ashura's tick will control SP lockout time}
								tc.Skill[271].Tick := Tick + 300000;
								tc.Skill[270].Tick := Tick;
								tc.SkillTick := Tick;
								tc.SkillTickID := 270;
								tc.SP := 0;
								SendCStat(tc);
							end;
						end else begin
							if tc.spiritSpheres >= 4 then begin
								ts := tm.Mob.IndexOfObject(tc.ATarget) as TMob;
								if ts = nil then begin
									sl.Free;
									Exit;//safe 2004/04/26
								end;
								ts.IsEmperium := False;
								tc.AData := ts;
								PassiveAttack := False;
								frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
								spbonus := tc.SP;
								dmg[0] := dmg[0] *(8 + tc.SP div 100) + 250 + (tc.Skill[271].Lv * 150);
								dmg[0] := dmg[0] + j;
								if dmg[0] < 0 then begin
									dmg[0] := 0;
									//ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								end;
								{SetLength(bb, 6);
								//bb[0] := 6;

								xy := tc.Point;
								DirMove(tm, tc.Point, tc.Dir, bb);

								if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
									with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
										Assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
										Delete(IndexOf(tc.ID));
									end;
									tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
								end;
								tc.pcnt := 0;

								UpdatePlayerLocation(tm, tc);   }
								frmMain.KnockBackLiving(tm, tc, ts, 6, 2);
								SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
								frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
								tc.MTick := Tick + Cardinal(3500 + (tl.CastTime2 * MUseLV));
								tc.spiritSpheres := 0;
								UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

								{20031223, Colus: Cancel Explosion Spirits after Ashura
								 Ashura's tick will control SP lockout time}
								tc.Skill[271].Tick := Tick + 300000;
								tc.Skill[270].Tick := Tick;
								tc.SkillTick := Tick;
								tc.SkillTickID := 270;
								tc.SP := 0;
								SendCStat(tc);
								tc.Skill[271].Data.SType := 1;
								tc.Skill[271].Data.CastTime1 := 4500;
								SendCSkillList(tc);
							end;
						end;
					end;
				end;

			272:   {Chain Combo Effect}
				begin
					ts := tm.Mob.IndexOfObject(tc.ATarget) as TMob;
					if ts = nil then Exit;
					ts.IsEmperium := False;
					tc.AData := ts;
					PassiveAttack := False;

					frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
					dmg[0] := dmg[0];
					dmg[0] := dmg[0] + (75 div 100) * 60;
					if dmg[0] < 0 then dmg[0] := 0; //Negative Damage

					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 4);
					frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
					tc.Skill[MSkill].Tick := Tick + 5000;

					if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then begin
						frmMain.StatCalc1(tc, ts, Tick);
					end;
					tc.MTick := Tick + 500;

				end;
			273:  //Combo finsher
				begin
					if tc.spiritSpheres >= 1 then begin
						ts := tm.Mob.IndexOfObject(tc.ATarget) as TMob;
						if ts = nil then begin
							sl.Free;
							Exit;//safe 2004/04/27
						end;
						ts.IsEmperium := False;
						tc.AData := ts;
						PassiveAttack := False;

						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						dmg[0] := dmg[0];
						dmg[0] := dmg[0] + (75 div 100) * 60;
						if dmg[0] < 0 then dmg[0] := 0; //Negative Damage

						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 4);
						frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
						tc.Skill[MSkill].Tick := Tick + 5000;
						if tc.spiritSpheres <= 0 then tc.spiritSpheres := 0;
						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then begin
							tc.spiritSpheres := tc.spiritSpheres - 1;
						end;
						UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
						frmMain.StatCalc1(tc, ts, Tick);
						tc.MTick := Tick + 500;
						if (tc.Skill[270].Tick >= Tick) then begin
							tc.Skill[271].Data.SType := 4;
							tc.Skill[271].Data.CastTime1 := 1;
							tc.Delay := (700 - (4 * tc.param[1]) - (2 * tc.param[4]) + 300);
							MonkDelay(tm, tc, tc.Delay);
							// Colus, 20040430: The +1000 is there just to make it more possible (the
							// monk delay keeps you from moving during the delay phase.)
							tc.Skill[273].Tick := Tick + tc.Delay + 1000;
							tc.Skill[273].EffectLV := 1;
							SendCSkillList(tc);
						end;
					end;
				end;
      {Monk Skills Player vs Monster end}

				{Crusader Skills Player vs Monster begin}
				250:    {Shield Charge}
					begin
						if (tc.Shield > 0) then begin
							{If Wearing Shield}
							xy.X := ts.Point.X - Point.X;
							xy.Y := ts.Point.Y - Point.Y;
							if abs(xy.X) > abs(xy.Y) * 3 then begin
								//â°å¸Ç´
								if xy.X > 0 then
									b := 6
								else
									b := 2;
							end else if abs(xy.Y) > abs(xy.X) * 3 then begin
								//ècå¸Ç´
								if xy.Y > 0 then
									b := 0
								else
									b := 4;
							end else begin
								if xy.X > 0 then begin
									if xy.Y > 0 then
										b := 7
									else
										b := 5;
								end else begin
									if xy.Y > 0 then
										b := 1
									else
										b := 3;
								end;
							end;

						//Calculate the Damage
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
							//ÉpÉPëóêM
							SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
							//ÉmÉbÉNÉoÉbÉNèàóù
							if (dmg[0] > 0) then begin
								SetLength(bb, 6);
								bb[0] := 6;
								xy := ts.Point;
								DirMove(tm, ts.Point, b, bb);
								//ÉuÉçÉbÉNà⁄ìÆ
								if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
									with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
										Assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
										Delete(IndexOf(ts.ID));
									end;
									tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
								end;
								ts.pcnt := 0;
								UpdateMonsterLocation(tm, ts);
							end;
							if Random(100) < Skill[250].Data.Data2[MUseLV] then begin
								if (ts.Stat1 <> 3) then begin
									ts.nStat := 3;
									ts.BodyTick := Tick + tc.aMotion;
								end else begin
									ts.BodyTick := ts.BodyTick + 30000;
								end;
							end;
							if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
								frmMain.StatCalc1(tc, ts, Tick);
						end;
					end;
				251:    {Shield Boomerang}
					begin
						if (tc.Shield <> 0) then begin
							frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
							if dmg[0] < 0 then
								dmg[0] := 0;
							SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
							if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
								frmMain.StatCalc1(tc, ts, Tick);
							tc.MTick := Tick + 1000;
						end else begin
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
							sl.Free;
							Exit;//safe 2004/04/26
						end;
					end;


			253:    {Holy Cross}
				begin
					frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
					if dmg[0] < 0 then dmg[0] := 0; //Negative Damage

					//Send Skill Packets
					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 2);
					//Byte 16 isn't Blind 32 is Chance to blind on undead
					if Random(100) < Skill[253].Data.Data2[MUseLV] then begin
						if (ts.Stat2 <> 32) and (ts.Data.Race = 1)  then begin
							ts.nStat := 32;
						end;
					end;
					if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
						frmMain.StatCalc1(tc, ts, Tick);
				end;
				254:    {Grand Cross}
					begin
						PassiveAttack := false;
						DamageProcessed := false;
						NoCastInterrupt := true;
						//É_ÉÅÅ[ÉWéZèo
						xy := tc.Point;
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
									if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then
										Continue;
									ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
									//NotTargetMonster
									//NotYourGuildMonster
									if (ts = ts1) or ((tc.GuildID > 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID > 0) and (ts1.GID = tc.GuildID)) then
										Continue;
									if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(ts1.ID),ts1);
								end;//for k1
							end;//for i1
						end;//for j1
						if sl.Count > 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								ts1 := sl.Objects[k1] as TMob;
								frmMain.DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
								//dmg[0] := dmg[0];
								dmg[0] := (MATK2 - MATK1 + 20) * 35 + ATTPOWER + dmg[0];
								j := 3;
								if DamageProcessed = false then begin
									DamageProcessed := true;
									//SendCSkillAtk2(tm, tc, tc, Tick, (dmg[0] * 100 div 200), j, 5);
									if tc.HP > ((dmg[0] div 350) * 100) then begin
										tc.HP := tc.HP - (dmg[0] * 100 div 350);  //Subtract Damage
										WFIFOW( 0, $01de);
										WFIFOW( 2, 254);
										WFIFOL( 4, tc.ID);
										WFIFOL( 8, tc.ID);
										WFIFOL(12, Tick);
										WFIFOL(16, ts1.Data.dMotion);
										WFIFOL(20, tc.aMotion);
										WFIFOL(24, (dmg[0] * 100 div 350));
										WFIFOW(28, MUseLV);
										WFIFOW(30, 3);
										WFIFOB(32, 8);
										SendBCmd(tm, tc.Point, 33);
										//SendMSkillAttack(tm, tc, ts, ts.Data.AISkill, Tick, 3, 0);
										if dmg[0] <> 0 then begin
											tc.DmgTick := Tick + tc.dMotion div 2;
											{Colus, 20031216: Cancel casting timer on hit.
											Also, phen card handling.}
											if tc.NoCastInterrupt = False then begin
												tc.MMode := 0;
												tc.MTick := 0;
												WFIFOW(0, $01b9);
												WFIFOL(2, tc.ID);
												SendBCmd(tm, tc.Point, 6);
											end;
											{Colus, 20031216: end cast-timer cancel}
										end;
									end else begin
										tc.HP := 1;
										{WFIFOW( 0, $0080);
										WFIFOL( 2, tc.ID);
										WFIFOB( 6, 1);
										SendBCmd(tm, tc.Point, 7);
										tc.Sit := 1;

										i := (100 - DeathBaseLoss);
										tc.BaseEXP := Round(tc.BaseEXP * (i / 100));
										i := (100 - DeathJobLoss);
										tc.JobEXP := Round(tc.JobEXP * (i / 100));

										SendCStat1(tc, 1, $0001, tc.BaseEXP);
										SendCStat1(tc, 1, $0002, tc.JobEXP);

										tc.pcnt := 0;
										if (tc.AMode = 1) or (tc.AMode = 2) then tc.AMode := 0;
										ATarget := 0;
										ts.ARangeFlag := false;}
									end;

									SendCStat1(tc, 0, $0005, tc.HP);
									ATick := ATick + ts.Data.ADelay;
								end;

								//SendCStat1(tc, 0, 5, tc.HP);
								//SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 3, 6);
								//SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], j, 3);
								WFIFOW( 0, $01de);
								WFIFOW( 2, 0);
								WFIFOL( 4, ts1.ID);
								WFIFOL( 8, ts1.ID);
								WFIFOL(12, Tick);
								WFIFOL(16, tc.aMotion);
								WFIFOL(20, ts1.Data.dMotion);
								WFIFOL(24, dmg[0]);
								WFIFOW(28, 1);
								WFIFOW(30, 3);
								WFIFOB(32, 9);
								SendBCmd(tm, tc.Point, 33);
								if not frmMain.DamageProcess1(tm, tc, ts1, dmg[0], Tick) then
									frmMain.StatCalc1(tc, ts1, Tick); {í«â¡}
							end;
						end;
					end;

			// CODE-ERROR - Darkhelmet, Defender should be used on a players self only,
			// therefore it has no use being against a monster
			257:    {Defender}
				begin
					tc1 := tc;
					ProcessType := 3;
				end;

			{Crusader Skills Player vs Monster end}
      {Sage Skills Player vs Monster begin}
			290:    {Abracadabra}
				begin
					i := Random(12);
					i := i + 1;

					{CODE-ERROR: Could be better code...}
					case i of
					1: tc.MSkill := 11;
					2: tc.MSkill := 13;
					3: tc.MSkill := 14;
					4: tc.MSkill := 15;
					5: tc.MSkill := 17;
					6: tc.MSkill := 19;
					7: tc.MSkill := 20;
					8: tc.MSkill := 84;
					9: tc.MSkill := 86;
					10: tc.MSkill := 88;
					11: tc.MSkill := 90;
					12: tc.MSkill := 91;
					end;//case
					tc.MUseLV := Random(10);
					if tc.MUseLV < 1 then tc.MUseLV := 1;
						if tc.MUseLV > tc.Skill[i].Data.MasterLV then
							tc.MUseLV := tc.Skill[i].Data.MasterLV;
						{CreateField(tc, Tick);}
						//if (tc.MSkill = 84) or (tc.MSkill = 19) or (tc.MSkill = 14) or (tc.MSkill = 13) or (tc.MSkill = 11) or (tc.MSkill = 20) then Skilleffect(tc, Tick);
						Skilleffect(tc, Tick);
					end;
      365:   //Magic Crusher
				begin
					//Magic Attack Calculation
					dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
					dmg[0] := dmg[0] * (100 - ts.Data.DEF) div 100;
					dmg[0] := dmg[0] - ts.Data.Param[2];
					if dmg[0] < 1 then
						dmg[0] := 1;
					dmg[0] := dmg[0] * 1;
					dmg[0] := dmg[0] * tl.Data2[MUseLV];
					if dmg[0] < 0 then
						dmg[0] := 0;

					if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;

					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], tl.Data2[MUseLV]);
					frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
				end;

			367: //Pressure
				begin
					frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
					j := 1;
					if dmg[0] < 0 then dmg[0] := 0;
					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], j);
					if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
						frmMain.StatCalc1(tc, ts, Tick);
					xy := ts.Point;

					sl.Clear;
					for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
						for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
							for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
								if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then Continue;
								ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
								//NotTargetMonster
								//NotYourGuildMonster
								if (ts = ts1) or ((tc.GuildID <> 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID <> 0) and (ts1.GID = tc.GuildID)) then Continue;
								if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
									sl.AddObject(IntToStr(ts1.ID),ts1);
							end;//for k1
						end;//for i1
					end;//for j1
					if sl.Count > 0 then begin
						for k1 := 0 to sl.Count - 1 do begin
							ts1 := sl.Objects[k1] as TMob;
							frmMain.DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
							j := 1;
							if dmg[0] < 0 then dmg[0] := 0;
							SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1, 6);
							//SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], j);
							if not frmMain.DamageProcess1(tm, tc, ts1, dmg[0], Tick) then
								frmMain.StatCalc1(tc, ts1, Tick);
						end;//for k1
					end;//if sl.Count
				end;

			368:    //Sacrafice {temp still need to find out the effects so far it just does damage like bash
				begin
				if tc.Weapon = 2 then begin
					frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
					if dmg[0] < 0 then dmg[0] := 0;
					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
					if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
						frmMain.StatCalc1(tc, ts, Tick);
					end else begin
						SendSkillError(tc, 6);
						MMode := 4;
						sl.Free;
						Exit;//safe 2004/04/26
					end;
				end;


      /// We can cheat and use Spear stab
			370:     {Palm Strike}
				begin
					if tc.Skill[270].Tick > Tick then begin
						xy.X := ts.Point.X - Point.X;
						xy.Y := ts.Point.Y - Point.Y;
						if abs(xy.X) > abs(xy.Y) * 3 then begin
							//Knockback Distance?
							if xy.X > 0 then b := 6 else b := 2;
						end else if abs(xy.Y) > abs(xy.X) * 3 then begin
							if xy.Y > 0 then b := 0 else b := 4;
						end else begin
							if xy.X > 0 then begin
								if xy.Y > 0 then b := 7 else b := 5;
							end else begin
								if xy.Y > 0 then b := 1 else b := 3;
							end;
						end;

						//Calculate Damage
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						if dmg[0] < 0 then dmg[0] := 0; //No Negative Damage

						//Send Attacking Packet
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);

						//Begin Knockback
						if (dmg[0] > 0) then begin
							SetLength(bb, 6);
							bb[0] := 6;
							xy := ts.Point;
							DirMove(tm, ts.Point, b, bb);

							//Knockback Monster
							if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
									Assert(IndexOf(ts.ID) > -1, 'MobBlockDelete Error');
									Delete(IndexOf(ts.ID));
								end;
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end;
							ts.pcnt := 0;

							//Update Coordinates of Monster
							UpdateMonsterLocation(tm, ts);
						end;

						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							frmMain.StatCalc1(tc, ts, Tick);
					end else begin
						SendSkillError(tc, 0);
						MMode := 4;
						sl.Free;
						Exit;//safe 2004/04/26
					end;
				end;{Palm Strike}
      371:  //Tiger Crush
				begin
					if tc.spiritSpheres >= 1 then begin
						ts := tm.Mob.IndexOfObject(tc.ATarget) as TMob;
						if ts = nil then begin
							sl.Free;
							Exit;//safe 2004/04/27
						end;
						ts.IsEmperium := False;
						tc.AData := ts;
						PassiveAttack := False;

						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						dmg[0] := dmg[0];
						dmg[0] := dmg[0] + (75 div 100) * 60;
						if dmg[0] < 0 then dmg[0] := 0; //Negative Damage

						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 4);
						frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
						tc.Skill[MSkill].Tick := Tick + 5000;
						if tc.spiritSpheres <= 0 then tc.spiritSpheres := 0;
						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							tc.spiritSpheres := tc.spiritSpheres - 1;
						UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
						frmMain.StatCalc1(tc, ts, Tick);
						tc.MTick := Tick + 500;
					end;
				end;{Tiger Crush}
        
			372:   //Chain Crush
				if tc.spiritSpheres >= 2 then begin
					ts := tm.Mob.IndexOfObject(tc.ATarget) as TMob;
					if ts = nil then begin
						sl.Free;
						Exit;//safe 2004/04/27
					end;
					ts.IsEmperium := False;
					tc.AData := ts;
					PassiveAttack := False;

					frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
					dmg[0] := dmg[0];
					dmg[0] := dmg[0] + (75 div 100) * 60;
					if dmg[0] < 0 then dmg[0] := 0; //Negative Damage

					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 4);
					frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
					tc.Skill[MSkill].Tick := Tick + 5000;

					if tc.spiritSpheres <= 0 then tc.spiritSpheres := 0;
					tc.spiritSpheres := tc.spiritSpheres - 2;
					UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
					frmMain.StatCalc1(tc, ts, Tick);

					tc.MTick := Tick + 500;
				end;{Chain Crush}
      {Sage Skills player vs monster begin}
      374:  {Soul Change PvM}
				begin
					if ts.Burned = false then begin
						tc.SP := tc.SP + (tc.MAXSP * 3 div 100);
						ts.Burned := true;
						tc.MTick := Tick + 5000;
						SendCStat(tc);
					end else begin
						SendSkillError(tc, 0);
						MMode := 4;
						sl.Free;
						Exit;//safe 2004/04/26
					end;
				end;
			379:  {Soul_Breaker}
				begin
					if tc.Weapon = 16 then begin
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							frmMain.StatCalc1(tc, ts, Tick);
					end else begin
						SendSkillError(tc, 6);
						MMode := 4;
						sl.Free;
						Exit;//safe 2004/04/27
					end;
				end;
      {Sage Skills Player vs Monster End}
      381:    {Falcon Assault}
				//Damage calc needs to be redone not much info about this skill.
				if tc.Option and 16 <> 0 then begin
					frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
					if dmg[0] < 0 then dmg[0] := 0;
					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
					if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
						frmMain.StatCalc1(tc, ts, Tick);
				end else begin
					SendSkillError(tc, 0);
					MMode := 4;
					sl.Free;
					Exit;//safe 2004/04/26
				end;{Falcon Assault}

			382:     {Sniper Shot}
				begin
					if (Arrow = 0) or (Item[Arrow].Amount < 1) then begin
						WFIFOW(0, $013b);
						WFIFOW(2, 0);
						Socket.SendBuf(buf, 4);
						ATick := ATick + ADelay;
						sl.Free;
						Exit;//safe 2004/04/26
					end;

					Dec(Item[Arrow].Amount,1);

					WFIFOW( 0, $00af);
					WFIFOW( 2, Arrow);
					WFIFOW( 4, 9);
					Socket.SendBuf(buf, 6);

					if Item[Arrow].Amount = 0 then begin
						Item[Arrow].ID := 0;
						Arrow := 0;
					end;

					if tc.Weapon = 11 then begin
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							frmMain.StatCalc1(tc, ts, Tick);
					end else begin
						SendSkillError(tc, 6);
						MMode := 4;
						sl.Free;
						Exit;//safe 2004/04/26
					end;
				end;{Sniper Shot}

			394:     {Arrow Shower}
				begin
					if (Arrow = 0) or (Item[Arrow].Amount < 9) then begin
						WFIFOW(0, $013b);
						WFIFOW(2, 0);
						Socket.SendBuf(buf, 4);
						ATick := ATick + ADelay;
						sl.Free;
						Exit;//safe 2004/04/26
					end;

					Dec(Item[Arrow].Amount,9);

					WFIFOW( 0, $00af);
					WFIFOW( 2, Arrow);
					WFIFOW( 4, 9);
					Socket.SendBuf(buf, 6);

					if Item[Arrow].Amount = 0 then begin
						Item[Arrow].ID := 0;
						Arrow := 0;
					end;

					if tc.Weapon = 11 then begin
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1, 6);
						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							frmMain.StatCalc1(tc, ts, Tick);
					end else begin
						SendSkillError(tc, 6);
						MMode := 4;
						tc.MTick := Tick + 500;//CR - moved ahead of Exit;
						sl.Free;
						Exit;//safe 2004/04/26
					end;
				end;{Arrow Shower}
      397: // Spiral Pierce
					begin
						//tc1 := tc;
						//ProcessType := 1;
            SendCSkillAtk1(tm, tc, ts, Tick, 1, 1);
						tc.MTick := Tick + 2000;
					end;
				398: // Head Crush
					begin
						//tc1 := tc;
						//ProcessType := 1;
						SendCSkillAtk1(tm, tc, ts, Tick, 1, 1);
						tc.MTick := Tick + 2000;
					end;
				399: // Joint Beat
					begin
						//tc1 := tc;
						//ProcessType := 1;
						SendCSkillAtk1(tm, tc, ts, Tick, 1, 1);
						tc.MTick := Tick + 2000;
					end;
				400: // Napalm Vulcan
					begin
						//tc1 := tc;
						//ProcessType := 1;
						SendCSkillAtk1(tm, tc, ts, Tick, 100, tc.Skill[MSkill].Data.Data2[MUseLV]);
						tc.MTick := Tick + 2000;
					end;

				402: // Mind Breaker
					begin
					ts.ATarget := tc.ID;
					ts.ARangeFlag := false;
					ts.AData := tc;
					//ÉpÉPëóêM
					WFIFOW( 0, $011a);
					WFIFOW( 2, MSkill);
					WFIFOW( 4, MUseLV);
					WFIFOL( 6, MTarget);
					WFIFOL(10, ID);
					if ts.Data.Race <> 1 then begin
						WFIFOB(14, 1);
						ts.ATKPer := word(tl.Data1[MUseLV]);
						ts.DEFPer := word(tl.Data2[MUseLV]);
					end else begin
						WFIFOB(14, 0);
					end;
					SendBCmd(tm, ts.Point, 15);
					tc.MTick := Tick + 2000;
					end;

				403: // Memorize
					begin
						tc1 := tc;
						ProcessType := 1;
					end;

			//New skills ---- Alchemist
			{231:    Potion Pitcher
				begin
					j := SearchCInventory(tc, 501, false);
					if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
						UseItem(tc, j);
						if (tc.HP > 0) then begin
							dmg[0] := tc.HP + ((td.HP1 + Random(td.HP2 - td.HP1 + 1)) * (100 + tc.Param[2]) div 100) * tc.Skill[231].Data.Data1[tc.Skill[231].Lv] div 100;;
							ts.HP := ts.HP + dmg[0];

							WFIFOW( 0, $011a);
							WFIFOW( 2, MSkill);
							WFIFOW( 4, dmg[0]);
							WFIFOL( 6, MTarget);
							WFIFOL(10, ID);
							WFIFOB(14, 1);
							SendBCmd(tm, ts.Point, 15);
							tc.MTick := Tick + 1000;
						end;
					end;
				end;}


				{CODE-ERROR: You have got to be joking...}
				{Colus, 20040116: I reorganized this because it was ugly.  It also doesn't
					abort for the skills which require certain weapon types.}
				42,316,324:
				{
					42  : Mammonite
					316 : Musical Strike
					324 : Throw Arrow}
				begin
				//É_ÉÅÅ[ÉWéZèo
					j := 1; // Moved # of hits up here to initialize.

						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);

					if (MSkill = 316) or (MSkill = 324) then begin
						if (Weapon = 13) or (Weapon = 14) then begin
							frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
						end else begin
							//DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
							SendSkillError(tc, 6);
							tc.MMode := 4;
							Exit;
						end;
					end;

					if (MSkill = 56) then begin //ÉsÉAÅ[ÉXÇÕts.Data.Scale + 1âÒhit
						j := ts.Data.Scale + 1;
						dmg[0] := dmg[0] * j;
					end;

					//Mammonite
					if MSkill = 42 then begin
						// Should check to see if we have the money!
						if (Zeny >= Cardinal(tl.Data2[MUseLV])) then begin
							Dec(Zeny, tl.Data2[MUseLV]);
							// Update zeny
							SendCStat1(tc, 1, $0014, Zeny);
						end else begin
							SendSkillError(tc, 5);
							tc.MMode := 4;
							Exit;
						end;
					end;

					if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
					SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], j);

					if (Skill[145].Lv <> 0) and (MSkill = 5) and (MUseLV > 5) then begin //ã}èäìÀÇ´
						if Random(1000) < Skill[145].Data.Data1[MUseLV] * 10 then begin
							if (ts.Stat1 <> 3) then begin
								ts.nStat := 3;
								ts.BodyTick := Tick + tc.aMotion;
							end else
								ts.BodyTick := ts.BodyTick + 30000;
						end;
					end;

					if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then begin
						frmMain.StatCalc1(tc, ts, Tick);
					end;
				end;

				11,13,14,19,20,90,156:
				{11  : Napalm Beat
				.13  : Soul Strike
				.14  : Cold Bolt
				.19  : Fire Bolt
				.20  : Lightning Bolt
				.90  : Earth Spike
				.156 : Holy Light }
					begin
						//Magic Attack Calculation
						dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
						dmg[0] := dmg[0] * (100 - ts.Data.MDEF) div 100; //MDEF%
						dmg[0] := dmg[0] - ts.Data.Param[3]; //MDEF-
						if dmg[0] < 1 then
							dmg[0] := 1;
						dmg[0] := dmg[0] * ElementTable[tl.Element][ts.Element] div 100;
						dmg[0] := dmg[0] * tl.Data2[MUseLV];
						if dmg[0] < 0 then
							dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM

						if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;

						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], tl.Data2[MUseLV]);
						frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick);
						case MSkill of
						11,90:     tc.MTick := Tick + 1000;
						13:        tc.MTick := Tick +  800 + 400 * ((MUseLV + 1) div 2) - 300 * (MUseLV div 10);
						14,19,20 : tc.MTick := Tick +  800 + 200 * MUseLV;
						else       tc.MTick := Tick + 1000;
						end;
					end;

        {Platinum Skills player vs monster Begin}
				148: {Charge_Arrow}
					begin
						//Ç∆ÇŒÇ∑ï˚å¸åàíËèàóù
						//FWÇ©ÇÁÇÃÉpÉNÉä
						xy.X := ts.Point.X - Point.X;
						xy.Y := ts.Point.Y - Point.Y;
						if abs(xy.X) > abs(xy.Y) * 3 then begin
							//â°å¸Ç´
							if xy.X > 0 then b := 6 else b := 2;
							end else if abs(xy.Y) > abs(xy.X) * 3 then begin
								//ècå¸Ç´
								if xy.Y > 0 then b := 0 else b := 4;
								end else begin
									if xy.X > 0 then begin
									if xy.Y > 0 then b := 7 else b := 5;
								end else begin
									if xy.Y > 0 then b := 1 else b := 3;
							end;
						end;

						//íeÇ´îÚÇŒÇ∑ëŒè€Ç…ëŒÇ∑ÇÈÉ_ÉÅÅ[ÉWÇÃåvéZ
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);

						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, 6);
							bb[0] := 6;
							xy := ts.Point;
							DirMove(tm, ts.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
									assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(ts.ID));
								end;
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end;
							ts.pcnt := 0;
							UpdateMonsterLocation(tm, ts);
						end;
						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							frmMain.StatCalc1(tc, ts, Tick);
					end;
				149:  {Sprinkle Sand}
					begin
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						dmg[0] := Round(dmg[0] * 1.25);
						j := 1;
						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], j);
						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then begin
							frmMain.StatCalc1(tc, ts, Tick);
						end;
					end;

				152: {Stone Throw}
					begin
            //See if player has a stone
						j := SearchCInventory(tc, 7049, false);
						if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
							UseItem(tc, j);
							dmg[0] := 30;
							dmg[0] := dmg[0] * ElementTable[tl.Element][0] div 100;
							if (ts.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
							SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);
							if Random(1000) < Skill[152].Data.Data1[MUseLV] * 10 then begin
								if (ts.Stat1 <> 3) then begin
									ts.nStat := 3;
									ts.BodyTick := Tick + tc.aMotion;
								end else ts.BodyTick := ts.BodyTick + 30000;
							end;
							frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick, False);
						end else begin
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
						end;
            {Platinum Skills player vs monster end}
					end; //End Case
        end;

			end else begin
				if tc.MTick + 500 < Tick then begin
					MMode := 4;
					sl.Free;
					Exit;//safe 2004/06/03
				end;
			end;

{TC1 BECOMES TARGET}













{ SKILL SPLIT }
{ SKILL SPLIT }
{ SKILL SPLIT }
{ SKILL SPLIT }
{ SKILL SPLIT }
{ SKILL SPLIT }
{ SKILL SPLIT }
{ SKILL SPLIT }
{ SKILL SPLIT }
{ SKILL SPLIT }
{ SKILL SPLIT }
{ SKILL SPLIT }
















		end else begin //MTargetType = 0
			tc1 := tc.AData;
			if tc1.NoTarget then begin
				sl.Free;
				Exit;//Safe 2004/06/03
			end;


			if (tc1 = nil) or ((tc1.HP = 0) and (MSkill <> 54)) Then begin
				MSkill := 0;
				MUseLv := 0;
				MMode := 0;
				MTarget := 0;
				Exit;
			end;
      //Check if your target is in range

            { Placed here for protection. One of my users managed to transfer Ice property
            from a falchion to Damascus. Attacking under such conditions undefines tl. }
			if not assigned(tl) then Exit;

			if (abs(Point.X - tc1.Point.X) <= tl.Range) and (abs(Point.Y - tc1.Point.Y) <= tl.Range) then begin

				case tc.MSkill of
				//Assassin Skills
				139: //Poison React
					begin
						tc1 := tc;
						ProcessType := 3;
						MTick := Tick + 100;
					end;
				401: // Gather Souls
					begin
						tc1 := tc;
						ProcessType := 1;
						tc.spiritSpheres := 5;
						UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
					end;

				//Alchemist Skills
				231:  //Potion Pitcher
					begin
						j := SearchCInventory(tc, tc.Skill[231].Data.Data2[MUseLV], false);
						if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
							UseItem(tc, j);

							if (tc1.Sit <> 1) then begin
								k := tc.Skill[231].Data.Data2[MUseLV];
								td := ItemDB.IndexOfObject(k) as TItemDB;

								{Colus, 20040116:
								 Level 5 Potion Pitcher is a blue pot, not a green one.  Don't
								 change this no matter what people claim. :)
								 Also, using target's VIT/INT on this instead of alch's...it's definitely
								 possible to get a 4K heal on a crusader with a white pot. }
								if (td.SP1 <> 0) then begin
									dmg[0] := ((td.SP1 + Random(td.SP2 - td.SP1 + 1)) * (100 + tc1.Param[3]) div 100) * tc.Skill[231].Data.Data1[tc.Skill[231].Lv] div 100;
									if (tc.ID = tc1.ID) then dmg[0] := dmg[0] * tc.Skill[227].Data.Data1[tc.Skill[227].Lv] div 100;
									tc1.SP := tc1.SP + dmg[0];
									if tc1.SP > tc1.MAXSP then tc1.SP := tc1.MAXSP;
									SendCStat1(tc1, 0, 7, tc.SP);

									// Is there no way to show SP heal graphic on the target to others?
									// I guess there isn't one...oh, well.  SP recovery to self is done
									// with the SP recovery graphic.

									WFIFOW( 0, $013d);
									WFIFOW( 2, $0007);
									WFIFOW( 4, dmg[0]);
									tc1.Socket.SendBuf(buf, 6);

								end else begin
									dmg[0] := ((td.HP1 + Random(td.HP2 - td.HP1 + 1)) * (100 + tc1.Param[2]) div 100) * tc.Skill[231].Data.Data1[tc.Skill[231].Lv] div 100 * (100 + tc1.Skill[4].Lv * 10) div 100;
									if (tc.ID = tc1.ID) then dmg[0] := dmg[0] * tc.Skill[227].Data.Data1[tc.Skill[227].Lv] div 100;
									tc1.HP := tc1.HP + dmg[0];
									if tc1.HP > tc1.MAXHP then tc1.HP := tc1.MAXHP;
									SendCStat1(tc1, 0, 5, tc1.HP);

									// Show heal graphics on target
									WFIFOW( 0, $011a);
									WFIFOW( 2, 28);  // We cheat and use the heal skill for the gfx
									WFIFOW( 4, dmg[0]);
									WFIFOL( 6, tc1.ID);
									WFIFOL(10, tc.ID);
									WFIFOB(14, 1);
									SendBCmd(tm, tc1.Point, 15);
								end;

								ProcessType := 0;
								tc.MTick := Tick + 500; // Delay after is .5s

							end else begin
								MMode := 4;
								Exit;
							end;
						end;
					end;
				//New skills ---- Crusader
				249: //Auto Gaurd
					begin
						if Shield <> 0 then begin;
							ProcessType := 3;
							tc.MTick := Tick + 1000;
						end else begin
							Exit;
						end;
					end;
				252: //Reflect Shield
					begin
						if Shield <> 0 then begin
							ProcessType := 3;
							MTick := Tick + 100;
						end else begin
							Exit;
						end;
					end;
				254:  {Grand Cross}
					begin
						NoCastInterrupt := true;
						PassiveAttack := True;
						tc.MTargetType := 0;
						SkillEffect(tc, Tick);
					end;


				255:  //Devotion
					begin
						tc1 := tc;
						ProcessType := 5;
					end;
				256: //Providence
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
				257: //Defender
					begin
						tc1 := tc;
						ProcessType := 3;
					end;

				//Monk Skills
				261:  //Call Spirits
					begin
						tc1 := tc;
						ProcessType := 2;
						tc.spiritSpheres := tc.spiritSpheres + Skill[261].Data.Data1[Skill[261].Lv];
						if tc.spiritSpheres > 5 then tc.spiritSpheres := 5;
						if tc.spiritSpheres > Skill[261].Data.Data2[Skill[261].Lv] then tc.spiritSpheres := Skill[261].Data.Data2[Skill[261].Lv];
						UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
						{tc1 := tc;
						ProcessType := 2;
						tc.spiritSpheres := tc.spiritSpheres + Skill[261].Data.Data2[Skill[261].Lv];
						if tc.spiritSpheres > 5 then tc.spiritSpheres := 5;
						UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
						{WFIFOW( 0, $01d0);
						WFIFOL( 2, tc.ID);
						WFIFOW( 6, spiritspheres);
						SendBCmd(tm, tc.Point, 16);}
						//Create_Spirit_Sphere(1, spiritSpheres);}
					end;
				262:  //Absorb Spirits
					if tc.spiritSpheres <> 0 then begin
						// Colus, 20040203: Fixed proper SP recovery amount, show SP recovery effect
						i := tc.spiritSpheres * Skill[262].Data.Data2[Skill[262].Lv];
						tc.spiritSpheres := 0;
						tc.SP := tc.SP + i;
						if tc.SP > tc.MAXSP then tc.SP := tc.MAXSP;
						UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
						WFIFOW( 0, $013d);
						WFIFOW( 2, $0007);
						WFIFOW( 4, i);
						tc1.Socket.SendBuf(buf, 6);
					end;
				268:   //Steel Body
					if tc.spiritSpheres = 5 then begin
						tc1 := tc;
						ProcessType := 3;
						tc.spiritSpheres := tc.spiritSpheres - 5;
						UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
					end else begin
						// Colus - This ability must have 5 spheres!
						sl.Free;
						Exit;//Safe 2004/06/03
					end;
				270:   //Explosion Spirits
					begin
						if tc.spiritSpheres = 5 then begin
							tc1 := tc;
							ProcessType := 3;
							tc.spiritSpheres := tc.spiritSpheres - 5;
							UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
						end else begin
							sl.Free;
							Exit;//Safe 2004/06/03
						end;
					end;
				272:   {Chain Combo Setup}
					begin
						if (Skill[263].Tick > Tick) and (Skill[272].Tick < Tick) and ((tc.Weapon = 12) or (tc.Weapon = 0)) then begin
							PassiveAttack := True;
							tc.MTargetType := 0;
							Monkdelay(tm, tc, Delay);
							SkillEffect(tc, Tick);

						end else begin
							SendSkillError(tc, 0);
							MMode := 4;
							sl.Free;
							Exit;//Safe 2004/06/03
						end;
					end;

                                 273:   {Combo Finish Setup}
                                        begin
						if (Skill[272].Tick > Tick) and (tc.spiritSpheres >= 1) and ((tc.Weapon = 12) or (tc.Weapon = 0)) then begin
							PassiveAttack := True;
							tc.MTargetType := 0;
																												SkillEffect(tc, Tick);
						end else begin
							SendSkillError(tc, 0);
							MMode := 4;
							Exit;
						end;

					end;
				271: // COLUS NEW ASHURA
					begin
						ts := tc.AData;
						if (ts is TMob) then begin
							PassiveAttack := True;
							tc.MTargetType := 0;
							SkillEffect(tc, Tick);
							exit;
						end;
						tc1 := tc.AData;
						if tc.Skill[270].Tick > Tick then begin
							if (tc.Skill[271].Data.SType = 4) then begin
								processtype := 255;
								if tc.spiritSpheres >= 4 then begin

									frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
									spbonus := tc.SP;
									dmg[0] := dmg[0] *(8 + tc.SP div 100) + 250 + (tc.Skill[271].Lv * 150);
									dmg[0] := dmg[0] + j;
									if dmg[0] < 0 then begin
										dmg[0] := 0;
										//ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
									end;
									SetLength(bb, 6);
									//bb[0] := 6;

									xy := tc.Point;
									DirMove(tm, tc.Point, tc.Dir, bb);

									if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
										with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
											assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
											Delete(IndexOf(tc.ID));
										end;
										tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
									end;
									tc.pcnt := 0;

							UpdatePlayerLocation(tm, tc);

							SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
							frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
							tc.MTick := Tick + Cardinal(3500 + (tl.CastTime2 * MUseLV));
							tc.spiritSpheres := 0;
							UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

							{20031223, Colus: Cancel Explosion Spirits after Ashura
							 Ashura's tick will control SP lockout time}
							tc.Skill[271].Tick := Tick + 300000;
							tc.Skill[270].Tick := Tick;
							tc.SkillTick := Tick;
							tc.SkillTickID := 270;
							tc.SP := 0;
							SendCStat(tc);
							tc.Skill[271].Data.SType := 1;
							tc.Skill[271].Data.CastTime1 := 4500;
							SendCSkillList(tc);

							end;
						end else if (tc.Skill[271].Data.SType = 1) then begin
							processtype := 255;
							if tc.spiritSpheres = 5 then begin
								frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
								spbonus := tc.SP;
								dmg[0] := dmg[0] *(8 + tc.SP div 100) + 250 + (tc.Skill[271].Lv * 150);
								dmg[0] := dmg[0] + j;
								if dmg[0] < 0 then begin
									dmg[0] := 0;
									//ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								end;
								SetLength(bb, 6);
								bb[0] := 6;

							xy := tc.Point;
							DirMove(tm, tc.Point, tc.Dir, bb);

							if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
									assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
									Delete(IndexOf(tc.ID));
								end;
								tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
																												end;
							tc.pcnt := 0;

							UpdatePlayerLocation(tm, tc);

							SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
							frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
							tc.MTick := Tick + Cardinal(3500 + (tl.CastTime2 * MUseLV));
							tc.spiritSpheres := tc.spiritSpheres - 5;
							UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

							{20031223, Colus: Cancel Explosion Spirits after Ashura
							 Ashura's tick will control SP lockout time}
							tc.Skill[271].Tick := Tick + 300000;
							tc.Skill[270].Tick := Tick;
							tc.SkillTick := Tick;
							tc.SkillTickID := 270;
							tc.SP := 0;
							SendCStat(tc);
							end;
						end;
					  end;
					end;
					 371:   {Combo Finish Setup}
					begin
						if (Skill[273].Tick > Tick) and (tc.spiritSpheres >= 1) and ((tc.Weapon = 12) or (tc.Weapon = 0)) then begin
							PassiveAttack := True;
							tc.MTargetType := 0;
							SkillEffect(tc, Tick);
						end else begin
																												SendSkillError(tc, 0);
							MMode := 4;
							Exit;
						end;

					end;
					 372:   {Combo Finish Setup}
					begin
						if (Skill[273].Tick > Tick) and (tc.spiritSpheres >= 2 ) and ((tc.Weapon = 12) or (tc.Weapon = 0)) then begin
							PassiveAttack := True;
							tc.MTargetType := 0;
							SkillEffect(tc, Tick);
						end else begin
							SendSkillError(tc, 0);
							MMode := 4;
							Exit;
						end;

					end;
				//End Monk Skills

				//Sage
				275:    {Cast Cancel}
					begin
						//tc.SP := tc.SP - tc.Skill
						// Colus, 20040203:
						// Reduce SP of last casted spell (saved in Effect1 and EffectLV) by factor based on CC's level
						tc.SP := tc.SP - (Skill[Skill[275].Effect1].Data.SP[Skill[275].EffectLV] * Skill[275].Data.Data2[tc.MUseLV] div 100);
						if tc.SP < 0 then tc.SP := 0;
						tc.MMode := 0;
												tc.MTick := Tick;
						tc.MTarget := 0;
						tc.MPoint.X := 0;
						tc.MPoint.Y := 0;

						//Update SP
						SendCStat1(tc, 0, $0007, tc.SP);

						//Cancel Cast Timer
						WFIFOW(0, $01b9);
						WFIFOL(2, tc.ID);
						SendBCmd(tm, tc.Point, 6);
						//ProcessType := 4;
					end;
				279:    {Autocast}
					begin
																					ZeroMemory(@buf[0], 30);
					  WFIFOW(0, $01cd);
					  // Napalm Beat at L1
					  if tc.Skill[11].Lv > 0 then WFIFOL(2, 11);
					  // CB/FB/LB at L2-L4
					  if (tc.Skill[14].Lv > 0) and (tc.Skill[279].Lv > 1) then WFIFOL(6, 14);
					  if (tc.Skill[19].Lv > 0) and (tc.Skill[279].Lv > 1) then WFIFOL(10, 19);
					  if (tc.Skill[20].Lv > 0) and (tc.Skill[279].Lv > 1) then WFIFOL(14, 20);
					  // SS at L5-L7
					  if (tc.Skill[13].Lv > 0) and (tc.Skill[279].Lv > 4) then WFIFOL(18, 13);
					  // FBall at L8-L9
					  if (tc.Skill[17].Lv > 0) and (tc.Skill[279].Lv > 7) then WFIFOL(22, 17);
					  // FD at L10
					  if (tc.Skill[15].Lv > 0) and (tc.Skill[279].Lv > 9) then WFIFOL(26, 15);
																					tc.Socket.SendBuf(buf, 30);
						tc1 := tc;
						ProcessType := 3;
					end;
				280,281,282,283: {Flamelauncher, Frost Weapon, Lightning Loader, Seismic Weapon}
					begin
						Skill[280].Tick := Tick;
						Skill[281].Tick := Tick;
						Skill[282].Tick := Tick;
						Skill[283].Tick := Tick;
						ProcessType := 3;
					end;


				//Item Skills

				291:  {Attack Speed Potions}
					begin
						tc1 := tc;
						ProcessType := 3;

						{WFIFOW( 0, $011a);
						WFIFOW( 2, 258);
						WFIFOW( 4, 1);
						WFIFOL( 6, tc1.ID);
						WFIFOL(10, ID);
						WFIFOB(14, 1);}
						{SendBCmd(tm, tc1.Point, 15);
						tc1.Skill[291].Tick := Tick + cardinal(tl.Data1[MUseLV]) * 1000;
						tc1.Skill[291].EffectLV := MUseLV;
						tc1.Skill[291].Effect1 := tl.Data2[MUseLV];

						if SkillTick > tc1.Skill[MSkill].Tick then begin
							SkillTick := tc1.Skill[291].Tick;
							SkillTickID := 291;
						end;

						CalcStat(tc1, Tick);
						SendCStat(tc1);

						if tl.Icon <> 0 then begin
							WFIFOW(0, $0196);
							WFIFOW(2, tl.Icon);
							WFIFOL(4, ID);
							WFIFOB(8, 1);
							SendBCmd(tm, tc1.Point, 9);
						end;}
					end;

				{Bard}
				304:    {Adaption}
					begin
						tc.LastSong := 0;
						tc.LastsongLV := 0;
						tc.SongTick := Tick;
					end;

				305:    {Encore}
					if tc.SongTick > Tick then begin
						if tc.LastSong = 0 then exit;
																								tc.MSkill := tc.LastSong;
						tc.MUseLV := tc.LastSongLV;
						tc.SP := tc.SP - (tc.Skill[MSkill].Data.SP[tc.MUseLV] div 2);
						DecSP(tc, MSkill, MUseLV);
						frmMain.CreateField(tc, Tick);
					end;

				//New Professor Skills
				373:  //Hp Conversion
				begin
					i := Skill[373].Data.Data1[MUseLv];
					if tc.HP - i > 0 then begin
						i := Skill[373].Data.Data1[MUseLv];
						tc.HP := tc.HP - i;
						tc.SP := tc.SP + i;
						dmg[0] := Skill[373].Data.Data1[MUseLv];
						if tc.SP > tc.MAXSP then tc.SP := tc.MAXSP;
						WFIFOW( 0, $013d);
						WFIFOW( 2, $0007);
						WFIFOW( 4, dmg[0]);
						tc.Socket.SendBuf(buf, 6);
						SendCStat(tc);
						//SendCStat1(tc, 0, 5, tc.HP);

					end else begin
						SendSkillError(tc, 0);
						MMode := 4;
						Exit;
					end;
				end;

				24: {Ruwatch}
					begin
						if (MSkill = 10) then Option := Option or 1 else Option := Option or $2000;
						UpdateOption(tm, tc);
						ProcessType := 2;

						xy := tc.Point;


						sl.Clear;
						for j1 := (xy.Y - tl.Range) div 8 to (xy.Y + tl.Range) div 8 do begin
							for i1 := (xy.X - tl.Range) div 8 to (xy.X + tl.Range) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue;
									tc1 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									//NoOtherChecks
									if (abs(tc1.Point.X - xy.X) <= tl.Range) and (abs(tc1.Point.Y - xy.Y) <= tl.Range) then begin
											sl.AddObject(IntToStr(tc1.ID),tc1);
									end;
								end;
							end;
						end;

						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
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
					end;

				28:     {Heal}
					begin
						if (tc1.Sit <> 1) then begin
							dmg[0] := ((BaseLV + Param[3]) div 8) * tl.Data1[MUseLV];
							if (tc1.ArmorElement mod 20 <> 9) then begin
								tc1.HP := tc1.HP + dmg[0];
								if tc1.HP > tc1.MAXHP then tc1.HP := tc1.MAXHP;
								SendCStat1(tc1, 0, 5, tc1.HP);
								ProcessType := 0;
							end else begin
								SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
								frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
								Exit;
							end;

							tc.MTick := Tick + 1000;
						end else begin
							MMode :=4;
							Exit;
						end;
					end;

				29: // Agility Up
					begin
						ProcessType := 3;
						tc.MTick := Tick + 1000;
					end;

				31: // Aqua Benedicta
					begin
						j := SearchCInventory(tc, 713, false);
						if (j <> 0) and (tc.Item[j].Amount >= 1) and (tm.gat[tc.Point.X][tc.Point.Y] = 3) then begin
							UseItem(tc, j);

							td := ItemDB.IndexOfObject(523) as TItemDB;
							if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) then begin
								k := SearchCInventory(tc, td.ID, td.IEquip);
								if k <> 0 then begin
									if tc.Item[k].Amount < 30000 then begin
										UpdateWeight(tc, k, td);

										//ÉAÉCÉeÉÄÉQÉbÉgí ím
										SendCGetItem(tc, k, 1);
									end;
								end;
							end else begin
								//èdó ÉIÅ[ÉoÅ[
								WFIFOW( 0, $00a0);
								WFIFOB(22, 2);
								Socket.SendBuf(buf, 23);
							end;
						end else begin
							SendSkillError(tc, 0);
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
							Exit;
						end;
					end;
			32: // Signum Crucis
				begin
					ProcessType := 0;
					xy := tc.Point;
					sl.Clear;
					for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
						for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
							for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
								ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
								//NotTargetMonster
								//NotYourGuildMonster
								if (ts = ts1) or ((tc.GuildID <> 0) and (ts1.isGuardian = tc.GuildID)) or ((tc.GuildID <> 0) and (ts1.GID = tc.GuildID)) then Continue;
								if (abs(ts1.Point.X - xy.X) <= tl.Range2) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
									sl.AddObject(IntToStr(ts1.ID),ts1);
							end;
						end;
					end;
					if sl.Count <> 0 then begin
						for k1 := 0 to sl.Count - 1 do begin
							ts1 := sl.Objects[k1] as TMob;
							i := (100 - tl.Data2[MUseLv]);
							ts1.DEF1 := Round(ts1.DEF1 * (i / 100));
							ts1.DEF2 := Round(ts1.DEF2 * (i / 100));

							if Random(1000) < Skill[32].Data.Data1[MUseLV] * 10 then begin
								tm := tc.MData;
								WFIFOW(0, $00c0);
								WFIFOL(2, ts1.ID);
								WFIFOW(6, $0004);
								ts1.DEFPer := word(tl.Data2[MUseLV]);
								SendBCmd(tm, tc.Point, 7);
							end;
						end;
					end;
				end;
			33: // Angelus
				begin
					tc1 := tc;
					ProcessType := 5;
				end;
			34: // Blessing
				begin
					ProcessType := 3;
				end;
			35:     {Cure}
				begin
					//tc1.Stat2 := tc1.Stat2 and (not $1C);
					tc1.isPoisoned := False;
					tc1.PoisonTick := Tick;
					tc1.isBlind := false;
					tc1.BlindTick := Tick;
					tc1.FreezeTick := Tick;
					tc1.isFrozen := false;
					tc1.Stat1 := 0;
					tc1.Stat2 := 0;
					UpdateStatus(tm, tc1, Tick);
					//ProcessType := 0;
				end;
			40: // Item Appraisal
				begin
					tc1 := tc;
					//ProcessType := 2;
					WFIFOW(0, $0177);
					j := 4;
					for i := 1 to 100 do begin
						if (tc.Item[i].ID <> 0) and (tc.Item[i].Amount > 0) and
							 (tc.Item[i].Identify = 0) then begin
							WFIFOW(j, i);
							j := j + 2;
						end;
					end;
					if j <> 4 then begin // Send the list of unidentified items...
						WFIFOW(2, j);
						Socket.SendBuf(buf, j);
						tc.UseItemID := w;
					end;
					WFIFOW( 0, $00a8);
					WFIFOW( 2, w);
					WFIFOW( 4, 0);
					WFIFOB( 6, 0);
					Socket.SendBuf(buf, 7);
				end;
				45: // Improve Concentration
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
				51:     {Hiding}
					begin
						if (tc.Option and 4 = 0) then begin
							tc1 := tc;
							ProcessType := 1;
						end else begin
							MMode := 4;
							exit;
						end;
					end;
				53:
					begin
						tc1 := tc;
						ProcessType := 0;
					end;
				234:
					begin
						tc1 := tc;
						ProcessType := 0;
					end;
				235:
					begin
						tc1 := tc;
						ProcessType := 0;
					end;
				236:
					begin
						tc1 := tc;
						ProcessType := 0;
					end;
				237:
					begin
						tc1 := tc;
						ProcessType := 0;
					end;

				54:     {Resurrection}
					begin
						j := SearchCInventory(tc, 717, false);
						if ((((j <> 0) and (tc.Item[j].Amount >= 1)) or (NoJamstone)) or (tc.ItemSkill)) then begin
							if (tc1.Sit = 1) AND (tc1.HP = 0) then begin
								if NOT (NoJamstone AND ItemSkill) then UseItem(tc, j);

								{ Mitch 02-03-2004: Fixed Ygg. Leaf uses SP! }
								//tc.ItemSkill := false;
								dmg[0] := ((tc1.MAXHP * tl.Data1[MUseLV]) div 100) + 1;

								tc1.Sit := 3;
								tc1.HP := tc1.HP + dmg[0];
								SendCStat1(tc1, 0, 5, tc1.HP);
								WFIFOW( 0, $0148);
								WFIFOL( 2, tc1.ID);
								WFIFOW( 6, 100);
								SendBCmd(tm, tc1.Point, 8);
								ProcessType := 0;
							end else begin
								tc.MMode := 4;
								Exit;
							end;
						end else begin
							SendSkillError(tc, 8); //No Blue Gemstone
							dmg[0] := 0;
							tc.MMode := 4;
							//tc.MPoint.X := 0;
							//tc.MPoint.Y := 0;
							Exit;
						end;
					end;
				60: // Two-hand Quicken
					begin
						if (tc.Weapon = 3) then begin
							tc1 := tc;
							//ÉpÉPëóêM
							//WFIFOW( 0, $00b0);
							//WFIFOW( 2, $0035);
							//WFIFOL( 4, ASpeed);
							//Socket.SendBuf(buf[0], 8);
							ProcessType := 3;
						end else begin
							MMode := 4;
							Exit;
						end;
					end;
				61: //AC
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
						355: //Aurablade
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
						356: //Parrying
					begin
						if (tc.Weapon = 3) then begin;
						ProcessType := 3;
						MTick := Tick + 100;
						end else begin
						SendSkillError(tc, 6);
						MMode := 4;
						Exit;
						end;
					end;


						357: //Concentration
					begin
	    if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
						tc1 := tc;
						ProcessType := 3;
	    end else begin
	      SendSkillError(tc, 6);
	      MMode := 4;
	      Exit;
	    end;
					end;
						358: //  Tension Relax
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
					360: // Fury
					begin
	    if (tc.Weapon = 3) then begin
						tc1 := tc;
						ProcessType := 3;
	    end else begin
	      SendSkillError(tc, 6);
	      MMode := 4;
	      Exit;
	    end;
	  end;

	  359: // Berserk
					begin
	    if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
						tc1 := tc;
						ProcessType := 3;
	    end else begin
	      SendSkillError(tc, 6);
	      MMode := 4;
	      Exit;
	    end;
	  end;
					361: //  Assumptio
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
					387: // Cart Boost
					begin
					if (tc.Option and $0788 <> 0) then begin
						tc1 := tc;
						ProcessType := 3;
						end else begin
						SendSkillError(tc, 0);
						MMode :=4 ;
						Exit;
						end
				end;
				       383: //         Windwalk
					begin
						tc1 := tc;
						ProcessType := 5;
					end;
					  380: // Sight
					begin
						tc1 := tc;
						ProcessType := 3;
					end;

					 384: //  Meltdown   //no effect yet
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
					  385: //  Create coin             //no effect yet
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
					  395: //  Create nugget             //no effect yet
					begin
						tc1 := tc;
						ProcessType := 3;
					end;

				66: // Imposito Manus
					begin
						ProcessType := 3;
						tc.MTick := Tick + 3000;
					end;
				67: // Suffragium
					begin
						// Colus, 20040226: Which is it?
						ProcessType := 3;
						ProcessType := 2;
					end;
				154: // Change Cart
					begin
						tc1 := tc;
					end;
				68: // Aspersio
					begin
	  j := SearchCInventory(tc, 523, false);
						if (j <> 0) and (tc.Item[j].Amount >= 1) then begin

							UseItem(tc, j);
	    ProcessType := 3;
						end else begin
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
							Exit;
						end;
	  end;
				69: // B.S.S.
					begin
						ProcessType := 3;
					end;
	71: // Slow Poison
	  begin
	    ProcessType := 2;
	  end;
				73: // Kyrie Eleison
					begin
						tc1 := tc;
						ProcessType := 5;
					end;
				74: // Magnificat
					begin
						tc1 := tc;
						ProcessType := 5;
					end;
{í«â¡:119}
				75: // Gloria
					begin
						tc1 := tc;
						ProcessType := 5;
						tc.MTick := Tick + 2000;
					end;
			81: //Sightrasher
					if Skill[10].Tick > Tick then begin
						xy := tc.Point;
						sl.Clear;
						j := tl.Range2 + tl.Data2[MUseLV];
						for j1 := (xy.Y - j) div 8 to (xy.Y + j) div 8 do begin
							for i1 := (xy.X - j) div 8 to (xy.X + j) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
									if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then
										continue;
									ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
									//NoOtherChecks
									if (abs(ts1.Point.X - xy.X) <= j) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(ts1.ID),ts1);
									end;
								end;
							end;
							if sl.Count <> 0 then begin
								for k1 := 0 to sl.Count - 1 do begin
			ts1 := sl.Objects[k1] as TMob;
			dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
			dmg[0] := dmg[0] * (100 - ts1.Data.MDEF) div 100; //MDEF%
			dmg[0] := dmg[0] - ts1.Data.Param[3]; //MDEF-
			if dmg[0] < 1 then dmg[0] := 1;
			dmg[0] := dmg[0] * ElementTable[tl.Element][ts1.Element] div 100;
			dmg[0] := dmg[0] * tl.Data2[MUseLV];
			if dmg[0] < 0 then dmg[0] := 0;
			if (ts1.EffectTick[0] > Tick) then dmg[0] := dmg[0] * 2;
			if ts = ts1 then k := 0 else k := 5;
			SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], tl.Data2[MUseLV], k);
			frmMain.DamageProcess1(tm, tc, ts1, dmg[0], Tick);
				end;
			end;
			tc.MTick := Tick + 1600;
							end else begin
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
							Exit;
						end;
			406: // Meteor Assault
				begin
					//tc1 := tc;
					//ProcessType := 1;
					xy := tc.Point;
					sl.Clear;
					j := tl.Range2;
					for j1 := (xy.Y - j) div 8 to (xy.Y + j) div 8 do begin
						for i1 := (xy.X - j) div 8 to (xy.X + j) div 8 do begin
							for k1 := 0 to tm.Block[i1][j1].Mob.Count - 1 do begin
								if ((tm.Block[i1][j1].Mob.Objects[k1] is TMob) = false) then continue;
								ts1 := tm.Block[i1][j1].Mob.Objects[k1] as TMob;
								//NoOtherChecks
								if (abs(ts1.Point.X - xy.X) <= j) and (abs(ts1.Point.Y - xy.Y) <= tl.Range2) then
									sl.AddObject(IntToStr(ts1.ID),ts1);
							end;
						end;
					end;
					if sl.Count <> 0 then begin
						for k1 := 0 to sl.Count - 1 do begin
							ts1 := sl.Objects[k1] as TMob;
							frmMain.DamageCalc1(tm, tc, ts1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
							if dmg[0] < 1 then dmg[0] := 1;
							if dmg[0] < 0 then dmg[0] := 0;
							k := 1;
							SendCSkillAtk1(tm, tc, ts1, Tick, dmg[0], 1);
							frmMain.DamageProcess1(tm, tc, ts1, dmg[0], Tick);
						end;
					end;

				end;

				111: // Adrenaline Rush
					begin
						tc1 := tc;
						ProcessType := 5;
					end;
				112: // Weapon Perfection
					begin
						tc1 := tc;
						ProcessType := 4;
					end;
				113: // Power Thrust
					begin
						tc1 := tc;
						ProcessType := 5;
					end;
			114: // Maximize Power
				begin
					tc1 := tc;

					if (tc.Skill[114].EffectLV = 1) then begin
						// Turn it off
						tc1.Skill[114].Tick := Tick;
						tc1.SkillTick := Tick;
						tc1.SkillTickID := 114;
						tc1.Skill[114].EffectLV := 0;
						tc.MMode := 4;
						Exit; // Why?  Because we don't want the effect.
					end else begin
						// Turn it on
						tc1.Skill[114].EffectLV := 1;
						tc1.Skill[114].Tick := Tick + Cardinal(tc1.Skill[114].Data.Data1[tc1.Skill[114].Lv]);
						ProcessType := 1;
					end;

				end;
			130:
				begin
					xy.X := tc.MPoint.X;
					xy.Y := tc.MPoint.Y;
					i1 := abs(tc.Point.X - xy.X);
					j1 := abs(tc.Point.Y - xy.Y);
					i := (1 + (2 * tc.Skill[130].Lv));

					if (tc.Option and 16 <> 0) and (i1 <= i) and (j1 <= i) then begin
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue;
									tc1 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									//NoOtherChecks
									if (abs(tc1.Point.X - xy.X) <= tl.Range2) and (abs(tc1.Point.Y - xy.Y) <= tl.Range2) then begin
										sl.AddObject(IntToStr(tc1.ID),tc1);
									end;
								end;
							end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								tc1 := sl.Objects[k1] as TChara;
								if (tc1.Option and 6 <> 0) then begin
									tc1.Option := tc1.Option and $FFF9;

									tc1.SkillTick := tc1.Skill[51].Tick;
									tc1.SkillTickID := 51;
									tc1.Hidden := false;
									CalcStat(tc1, Tick);

									// Colus, 20031228: Tunnel Drive speed update
									if (tc1.Skill[213].Lv <> 0) then begin
										SendCStat1(tc1, 0, 0, tc1.Speed);
									end;
								end;
							end;
						end;
		end else begin
		SendSkillError(tc, 0);
		tc.MMode := 4;
		Exit;
		end;
		end;
				135:    {Cloaking}
					begin
						tm := tc.MData;

						xy.X := tc.Point.X;
						xy.Y := tc.Point.Y;

						k := 0;
						if (tc.Option and 4 <> 0) then begin
							// Cloaked, so uncloak
							tc.isCloaked := false;
							tc.Hidden := false;
							tc.Skill[MSkill].Tick := Tick;
							tc.SkillTick := Tick;
							tc.SkillTickID := 135;
							tc.Option := tc.Option and $FFF9;
							CalcStat(tc, Tick);

							UpdateOption(tm, tc);
							tc.MMode := 4;
							exit;
						end else begin
							for j1 := - 1 to 1 do begin
								for i1 := -1 to 1 do begin
									if ((j1 = 0) and (i1 = 0)) then continue;
									j := tm.gat[xy.X + i1, xy.Y + j1];
									if (j = 1) or (j = 5) then begin
										// Colus, 20040205: Moved this from SkillPassive.
										// We don't need to run the cloak every tick, only
										// the status change.
										tc.isCloaked := true;
										tc.Hidden := true;
										tc.CloakTick := Tick;
																						//tc.Optionkeep := tc.Option;
										// Colus, 20040204: Trying option 4 instead of 6 for cloak
										tc.Option := tc.Option or 4;
										k := 1;
										CalcStat(tc, Tick);

										UpdateOption(tm, tc);
										tc1 := tc;
										ProcessType := 1;
									end;
								end;
							end;

							if k = 0 then begin
								SendSkillError(tc, 0);
								// Colus, 20040225: Failed cloaks burn SP
								DecSP(tc, MSkill, MUseLV);
								//tc.MMode := 4;
								//Exit;
							end;
						end;
						{repeat
							xy.X := (tm.Size.X - 2) + 1;
							xy.Y := Random(tm.Size.Y - 2) + 1;
							Inc(j);
						until ( ((tm.gat[xy.X, xy.Y] <> 1) and (tm.gat[xy.X, xy.Y] <> 5)) or (j = 100) );}
					end;

				138: // Enchant Poison
					begin
						ProcessType := 3;
					end;

				142: //âûã}éËìñ
					begin
						dmg[0] := 5;
						tc.HP := tc.HP + dmg[0];
						if tc.HP > tc.MAXHP then tc.HP := tc.MAXHP;
						SendCStat1(tc, 0, 5, tc.HP);
						ProcessType := 0;
					end;
				143: //éÄÇÒÇæÉtÉä
					begin
	    tc1 := tc;
						ProcessType := 1;
					end;
	147:
	  begin
	    WFIFOW(0, $01ad);
			j := 4;
	    for i := 1 to 100 do begin
	    k := MArrowDB.IndexOf(tc.Item[i].ID);
	    if (tc.Item[i].ID <> 0) and (tc.Item[i].Amount > 0) and (k <> -1) then begin
	    l := tc.Item[i].ID;
	    WFIFOW(j, l);
	    j := j + 2;
	    end;
	    end;
	    if j <> 4 then begin
						WFIFOW(2, j);
	    Socket.SendBuf(buf, j);
	    tc.UseItemID := w;
	    end;
	    WFIFOW( 0, $00a8);
	    WFIFOW( 2, w);
	    WFIFOW( 4, 0);
	    WFIFOB( 6, 0);
	    Socket.SendBuf(buf, 7);
	  end;
	150:    {Backsliding}
		begin
			SetLength(bb, 5);
			{Colus, 20031228: This bb produces behavior equal
			 to the previous settings w/o turning the char around.
			 However, it still isn't updating the position of the
			 character (perhaps because it is not damaging anything?)

			 Darkhelmet, hows that now?}
			bb[0] := 4;
			bb[1] := 4;
			bb[2] := 4;
			bb[3] := 4;
			bb[4] := 4;
//                        bb[0] := 1;

			//bb[1] := 0;
			xy := tc.Point;

			DirMove(tm, tc.Point, tc.Dir, bb);
												//ÉuÉçÉbÉNà⁄ìÆ
			if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
				with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
					assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
					Delete(IndexOf(tc.ID));
				end;
				tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
			end;
			tc.pcnt := 0;

			UpdatePlayerLocation(tm, tc);


		end;
	151:
	  begin
	      td := ItemDB.IndexOfObject(7049) as TItemDB;
							if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) then begin
								k := SearchCInventory(tc, td.ID, td.IEquip);
								if k <> 0 then begin
									if tc.Item[k].Amount < 30000 then begin
									UpdateWeight(tc, k, td);
									{tc.Item[k].ID := td.ID;
									tc.Item[k].Amount := tc.Item[k].Amount + 1;
									tc.Item[k].Equip := 0;
									tc.Item[k].Identify := 1;
									tc.Item[k].Refine := 0;
									tc.Item[k].Attr := 0;
									tc.Item[k].Card[0] := 0;
									tc.Item[k].Card[1] := 0;
																																				tc.Item[k].Card[2] := 0;
									tc.Item[k].Card[3] := 0;
									tc.Item[k].Data := td;
									//èdó í«â¡
									tc.Weight := tc.Weight + cardinal(td.Weight);
									WFIFOW( 0, $00b0);
									WFIFOW( 2, $0018);
									WFIFOL( 4, tc.Weight);}
									//Socket.SendBuf(buf, 8);

									//ÉAÉCÉeÉÄÉQÉbÉgí ím
									SendCGetItem(tc, k, 1);
		end;
								end;
							end else begin
								//èdó ÉIÅ[ÉoÅ[
								WFIFOW( 0, $00a0);
								WFIFOB(22, 2);
								Socket.SendBuf(buf, 23);
							end;
		end;
				157: //ÉGÉlÉãÉMÅ[ÉRÅ[Ég
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
				155: //ëÂê∫âÃè•
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
	228:    {Pharmacy}
	  begin
	    // Every Pharmacy use consumes a Medicine Bowl.
	    j := SearchCInventory(tc, 7134, false);
						if (j <> 0) and (tc.Item[j].Amount >= 1) then begin
	      UseItem(tc, j);
	      j := 4; // Initial length of packet being sent out
							for k := 0 to MaterialDB.Count-1 do begin
		m := 0;  // Do we add this to the list or not?

								tma := MaterialDB.Objects[k] as TMaterialDB;
		// In the material DB, ItemLV is the book we need.
		// Cheesy, I know, but they all have IDs in the 7000s, so
		// this check _should_ always work.
		if (tma.ItemLV > MSkill) then begin
		  i1 := SearchCInventory(tc, tma.ItemLV, false);

		  if (i1 = 0) or (tc.Item[i1].Amount < 1) then begin
		    m := 1;
		    continue;
		  end;

									for l := 0 to 2 do begin
										//if (tma.ItemLV > tc.Skill[tma.RequireSkill].Lv) or (tc.Item[w].ID <> 612) then begin
										//  m := 1;
										//	continue;
										//end;

		    if tma.MaterialID[l] = 0 then continue;

										i1 := SearchCInventory(tc, tma.MaterialID[l], false);

										if (i1 = 0) or (tc.Item[i1].Amount < tma.MaterialAmount[l]) then begin
										  m := 1;
		    end;
									end;

									if (m <> 1) then begin

										WFIFOW(j, tma.ID);
										WFIFOW(j+2, 12);
										WFIFOL(j+4, tc.ID);
										j := j+8;

									end;
								end;
	      end;

	      // Send the list.
							WFIFOW(0, $018d);
							WFIFOW(2, j);
							Socket.SendBuf(buf, j);
	    end else begin
	      SendSkillError(tc, 0);
	      tc.MMode := 4;
						Exit;

						end;
					end;

	258:
	  begin
	    // AlexKreuz: Fixed Spear Quicken - Set type to Spear [4 & 5]
	    if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
						tc1 := tc;
						ProcessType := 3;
	    end else begin
	    tc.MMode := 4;
						Exit;
	    end;
	  end;
				else
					begin
	    if ((tm.CList.IndexOf(tc.MTarget) <> -1) and (mi.PvP = false)) or (tc1 = nil) then begin
								MMode := 4;
								MTarget := 0;
		Exit;
	   end;
		 if tc = tc1 then exit;
	   if tc1.NoTarget = true then exit;
	   case tc.MSkill of
				//Blacksmith
				110:
				if (tc.Weapon = 6) or (tc.Weapon = 7) or (tc.Weapon = 8) then begin
					if Random(100) < Skill[110].Data.Data1[MUseLV] then begin
								if (tc1.Stat1 <> 3) then begin
									//tc1.Stat1 := 3;
									tc1.BodyTick := Tick + tc.aMotion;
								end else tc1.BodyTick := tc1.BodyTick + 30000;
																				end else begin
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
					end;
				end;
				//Skills From MWeiss
				{50:     //Steal
					begin
						SendCSkillAtk1(tm, tc, ts, Tick, 0, 1, 6);
						j := Random(7);
						if (Random(100) < tl.Data1[MUseLV]) then begin
							k := ts.Data.Drop[j].Data.ID;
							if k <> 0 then begin
								td := ItemDB.IndexOfObject(k) as TItemDB;
								if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) then begin
									i := SearchCInventory(tc, td.ID, td.IEquip);
									if i <> 0 then begin
										if tc.Item[i].Amount < 30000 then begin
											tc.Item[i].ID := td.ID;
											tc.Item[i].Amount := tc.Item[i].Amount + 1;
											tc.Item[i].Equip := 0;
											tc.Item[i].Identify := 1;
											tc.Item[i].Refine := 0;
											tc.Item[i].Attr := 0;
											tc.Item[i].Card[0] := 0;
											tc.Item[i].Card[1] := 0;
											tc.Item[i].Card[2] := 0;
											tc.Item[i].Card[3] := 0;
											tc.Item[i].Data := td;
																	tc.Weight := tc.Weight + cardinal(td.Weight);
											WFIFOW( 0, $00b0);
											WFIFOW( 2, $0018);
											WFIFOL( 4, tc.Weight);
											Socket.SendBuf(buf, 8);
											SendCGetItem(tc, i, 1);
										end;
									end else if tc.Item[100].ID <> 0 then begin
										tc.Item[100].ID := td.ID;
										tc.Item[100].Amount := 1;
										tc.Item[100].Equip := 0;
										tc.Item[100].Identify := 1;
										tc.Item[100].Refine := 0;
										tc.Item[100].Attr := 0;
										tc.Item[100].Card[0] := 0;
										tc.Item[100].Card[1] := 0;
										tc.Item[100].Card[2] := 0;
										tc.Item[100].Card[3] := 0;
										tc.Item[100].Data := td;
									end;
								end;
							end;
						end;
					end;}


				50: {Steal}
				begin
				    if Option_PVP_Steal then begin
					if not (StealItem(tc)) then begin
																						SendSkillError(tc, 0);
					    tc.MMode := 4;
					    tc.MPoint.X := 0;
					    tc.MPoint.Y := 0;
					    DecSP(tc, 50, MUseLV);
					end;
				    end else begin
					SendSkillError(tc, 0);
					tc.MMode := 4;
					tc.MPoint.X := 0;
					tc.MPoint.Y := 0;
					DecSP(tc, 50, MUseLV);
				    end;
				    // Delay after stealing
				    tc.MTick := Tick + 1000;
				end;

				250:    //Shield Charge
					begin
						if (tc.Shield <> 0) then begin // 20040324,Eliot: It should check if You have a shield.
						xy.X := tc1.Point.X - Point.X;
						xy.Y := tc1.Point.Y - Point.Y;
						{if abs(xy.X) > abs(xy.Y) * 3 then begin
							if xy.X > 0 then b := 6 else b := 2;
						end else if abs(xy.Y) > abs(xy.X) * 3 then begin
							if xy.Y > 0 then b := 0 else b := 4;
						end else begin
							if xy.X > 0 then begin
								if xy.Y > 0 then b := 7 else b := 5;
							end else begin
								if xy.Y > 0 then b := 1 else b := 3;
							end;
						end;}

						frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);

						{if (dmg[0] > 0) then begin
							SetLength(bb, 3);
							bb[0] := 4;
							xy := ts.Point;
							DirMove(tm, ts.Point, b, bb);
							if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
									assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(ts.ID));
								end;
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end;
							ts.pcnt := 0;
							WFIFOW(0, $0088);
							WFIFOL(2, ts.ID);
							WFIFOW(6, ts.Point.X);
							WFIFOW(8, ts.Point.Y);
							SendBCmd(tm, ts.Point, 10);
							xy := ts.Point;
							sl.Clear;
						end;}
					begin
						if Random(100) < Skill[250].Data.Data2[MUseLV] then begin
							//Nothing
							tc1.BodyTick := tc1.BodyTick + 30000;
						end;
						if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							frmMain.StatCalc2(tc, tc1, Tick);     // 20040324,Eliot : Wouldn't it be nice if we actually deal any damage ?
						end;
					end;
				end;
			264:   {Body Relocation}
				// Colus, 20040225: This isn't called ever?
				begin
					if tc.spiritSpheres <> 0 then begin
						//ÉpÉPëóêM
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, ts.ID);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, ts.Point, 15);
						// Colus, 20040225: Oatmeal, until you send the packet,
						// ANY other packet you send will overwrite what you've
						// already done.  You cannot do the UpdateSpiritSpheres
						// call (which makes a new packet) until you send the old one.
						tc.spiritSpheres := tc.spiritSpheres - 1;
						UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);


						if tc.Skill[264].EffectLV > 1 then begin
							ts.speed := ts.speed - 45;
						end else begin
							ts.speed := ts.speed - 30;
						end;

						tc.MTick := Tick + 1000;
					end;
				end;
			257: //Defender
				begin
					tc1 := tc;
					ProcessType := 3;
				end;
			{258: //Spear Quicken
				begin
					if (tc.Weapon <> 5) then begin
						tc1 := tc;
						ProcessType := 3;
					end else begin
						tc.MMode := 4;
						Exit;
					end;
					end else begin
						if ((tm.CList.IndexOf(tc.MTarget) <> -1) and (mi.PvP = false)) or (tc1 = nil) then begin
							MMode := 4;
							MTarget := 0;
							Exit;
						end;
					end;
				end;}
					//New skills ---- Alchemist
				231:  //Potion Pitcher
		begin
			j := SearchCInventory(tc, tc.Skill[231].Data.Data2[MUseLV], false);
	    if (j <> 0) and (tc.Item[j].Amount >= 1) then begin

	      UseItem(tc, j);

	      if (tc1.Sit <> 1) then begin
		k := tc.Skill[231].Data.Data2[MUseLV];
		td := ItemDB.IndexOfObject(k) as TItemDB;


		{Colus, 20040116:
		  Level 5 Potion Pitcher is a blue pot, not a green one.  Don't
		  change this no matter what people claim. :)
		  Also, using target's VIT/INT on this instead of alch's...it's definitely
		  possible to get a 4K heal on a crusader with a white pot.
		  }
		if (td.SP1 <> 0) then begin
									dmg[0] := ((td.SP1 + Random(td.SP2 - td.SP1 + 1)) * (100 + tc1.Param[3]) div 100) * tc.Skill[231].Data.Data1[tc.Skill[231].Lv] div 100;
		  if (tc.ID = tc1.ID) then dmg[0] := dmg[0] * tc.Skill[227].Data.Data1[tc.Skill[227].Lv] div 100;
						tc1.SP := tc1.SP + dmg[0];
									if tc1.SP > tc1.MAXSP then tc1.SP := tc1.MAXSP;
									SendCStat1(tc1, 0, 7, tc.SP);

		  // Is there no way to show SP heal graphic on the target to others?
		  // I guess there isn't one...oh, well.  SP recovery to self is done
									// with the SP recovery graphic.


		  WFIFOW( 0, $013d);
		  WFIFOW( 2, $0007);
						  WFIFOW( 4, dmg[0]);
						  tc1.Socket.SendBuf(buf, 6);

		end else begin
						    dmg[0] := ((td.HP1 + Random(td.HP2 - td.HP1 + 1)) * (100 + tc1.Param[2]) div 100) * tc.Skill[231].Data.Data1[tc.Skill[231].Lv] div 100 * (100 + tc1.Skill[4].Lv * 10) div 100;
		  if (tc.ID = tc1.ID) then dmg[0] := dmg[0] * tc.Skill[227].Data.Data1[tc.Skill[227].Lv] div 100;
						tc1.HP := tc1.HP + dmg[0];
					if tc1.HP > tc1.MAXHP then tc1.HP := tc1.MAXHP;
		  SendCStat1(tc1, 0, 5, tc1.HP);

			// Show heal graphics on target
		  WFIFOW( 0, $011a);
		  WFIFOW( 2, 28);    // We cheat and use the heal skill for the gfx
		  WFIFOW( 4, dmg[0]);
		  WFIFOL( 6, tc1.ID);
		  WFIFOL(10, tc.ID);
			WFIFOB(14, 1);
		  SendBCmd(tm, tc1.Point, 15);

		end;

						    ProcessType := 0;
						    tc.MTick := Tick + 500; // Delay after is .5s

	      end else begin
								MMode := 4;
		Exit;
	      end;
	    end;
	  end;
				234:  //Chemical Protection --- Weapon
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
				235:  //Chemical Protection --- Shield
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
				236:  //Chemical Protection --- Armor
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
				237:  //Chemical Protection --- Helmet
					begin
						tc1 := tc;
						ProcessType := 3;
					end;
				//New Skills ---- Rouge
				211: //Steal Coin
					begin
						SendCSkillAtk2(tm, tc, tc1, Tick, 0, 1, 6);
						j := Random(7);
																								if (Random(100) < tl.Data1[MUseLV]) then begin
							if tc1.Zeny > 0 then begin;
							 //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'PvP Steal zenny succesful');
								k := (tc.BaseLV * 5) - (tc1.BaseLV * 3);
							if k < 0 then k := 0;
							Dec(tc1.Zeny, k);
						     Inc(Zeny, k);
							{if tc1.Zeny < 0 then tc1.Zeny := 0;}
							// Update zeny
	      SendCStat1(tc, 1, $0014, Zeny);

							end;
						end;
					end;
				212:    {Back Stab PvP}
				if tc1.Dir = tc.Dir then begin
					if (tc.Option and 2 <> 0) then begin
						tc.Option := tc.Option and $FFFD;
						tc.Hidden := false;
						tc.Skill[51].Tick := Tick;
						tc.SkillTick := Tick;
						tc.SkillTickID := 51;
						CalcStat(tc, Tick);
						UpdateOption(tm, tc);
					// Colus, 20040319: Actually you can Backstab while visible.
					{end else begin
						SendSkillError(tc, 0);
						tc.MMode := 4;
						Exit;}
					end;
					frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
					if dmg[0] < 0 then dmg[0] := 0;
					SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);
					if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then begin
						frmMain.StatCalc2(tc, tc1, Tick);
					end;
					//SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
					//DamageProcess3(tm, tc, tc1, dmg[0], Tick);
					tc.MTick := Tick + 500;
				end else begin
					SendSkillError(tc, 0);
					MMode := 4;
					Exit;
				end;
				{214:
					if (tc.Option = 6) then begin
						DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);
						if not DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							StatCalc2(tc, tc1, Tick);
						xy := tc1.Point;
						//É_ÉÅÅ[ÉWéZèo2
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue; tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
									if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(tc2.ID),tc2);
								end;
							end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								tc2 := sl.Objects[k1] as TChara;
								DamageCalc3(tm, tc, tc2, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
								if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								//ÉpÉPëóêM
								SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1, 5);
								//É_ÉÅÅ[ÉWèàóù
								if not DamageProcess2(tm, tc, tc2, dmg[0], Tick) then
						StatCalc2(tc, tc2, Tick);
							end;
						end;
						end else begin
						tc.MMode := 4;
						tc.MPoint.X := 0;
						tc.MPoint.Y := 0;
						Exit;
						end;}
				215:
				begin
				if tc1.Skill[234].Tick > Tick then begin
				end else
				if (Random(100) < tc.Param[4] - tc1.Param[4] + tl.Data1[MUseLV]) then begin
						if (tc1.Weapon <> 0) then begin
							for i := 1 to 100 do begin
								if (tc1.Item[i].Equip = 2) then begin
									if tc1.Item[i].Equip = 32768 then begin
																					tc1.Item[i].Equip := 0;
									WFIFOW(0, $013c);
									WFIFOW(2, 0);
									tc1.Socket.SendBuf(buf, 4);
									end else begin
                                    reset_skill_effects(tc);
									WFIFOW(0, $00ac);
									WFIFOW(2, i);
									WFIFOW(4, tc1.Item[i].Equip);
									tc1.Item[i].Equip := 0;
									WFIFOB(6, 1);
									tc1.Socket.SendBuf(buf, 7);
                                    remove_equipcard_skills(tc, i);
									end;

									CalcStat(tc1);
									SendCStat(tc1, true);
									Break;
								end;
							end;
						end;
					end;
				end;
				216:
				if tc1.Skill[235].Tick > Tick then begin
				end else
					if (Random(100) < tc.Param[4] - tc1.Param[4] + tl.Data1[MUseLV]) then begin
						if (tc1.Shield <> 0) then begin
							for i := 1 to 100 do begin
							if (tc1.Item[i].Equip = 32) then begin
								if tc1.Item[i].Equip = 32768 then begin
								tc1.Item[i].Equip := 0;
																	WFIFOW(0, $013c);
								WFIFOW(2, 0);
								tc1.Socket.SendBuf(buf, 4);
								end else begin
                                reset_skill_effects(tc);
								WFIFOW(0, $00ac);
								WFIFOW(2, i);
								WFIFOW(4, tc1.Item[i].Equip);
								tc1.Item[i].Equip := 0;
								WFIFOB(6, 1);
								tc1.Socket.SendBuf(buf, 7);
                                remove_equipcard_skills(tc, i);
								end;

							CalcStat(tc1);
							SendCStat(tc1, true);
							Break;
							end;
						end;
					end;
				end;
				217:
				if tc1.Skill[236].Tick > Tick then begin
				end else
					if (Random(100) < tc.Param[4] - tc1.Param[4] + tl.Data1[MUseLV]) then begin
					for i := 1 to 100 do begin
						if (tc1.Item[i].Equip = 16) then begin
							if tc1.Item[i].Equip = 32768 then begin
							tc1.Item[i].Equip := 0;
							WFIFOW(0, $013c);
							WFIFOW(2, 0);
							tc1.Socket.SendBuf(buf, 4);
																end else begin
                            reset_skill_effects(tc);
							WFIFOW(0, $00ac);
							WFIFOW(2, i);
							WFIFOW(4, tc1.Item[i].Equip);
							tc1.Item[i].Equip := 0;
							WFIFOB(6, 1);
							tc1.Socket.SendBuf(buf, 7);
                            remove_equipcard_skills(tc, i);
							end;

						CalcStat(tc1);
						SendCStat(tc1, true);
						Break;
						end;
					end;
				end;
				218:
				if tc1.Skill[237].Tick > Tick then begin
				end else
					if (Random(100) < tc.Param[4] - tc1.Param[4] + tl.Data1[MUseLV]) then begin
						if (tc1.Head1 <> 0) then begin
						for i := 1 to 100 do begin
							if (tc1.Item[i].Equip = 256) then begin
								if tc1.Item[i].Equip = 32768 then begin
								tc1.Item[i].Equip := 0;
								WFIFOW(0, $013c);
								WFIFOW(2, 0);
								tc1.Socket.SendBuf(buf, 4);
								end else begin
                                reset_skill_effects(tc);
								WFIFOW(0, $00ac);
								WFIFOW(2, i);
																	WFIFOW(4, tc1.Item[i].Equip);
								tc1.Item[i].Equip := 0;
								WFIFOB(6, 1);
								tc1.Socket.SendBuf(buf, 7);
                                remove_equipcard_skills(tc, i);
								end;

							CalcStat(tc1);
							SendCStat(tc1, true);
							Break;
							end;
						end;
					end;
				end;
			219:
				begin
					frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
					j := 1;
					if dmg[0] < 0 then dmg[0] := 0;
					SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
					if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
						frmMain.StatCalc2(tc, tc1, Tick);
				end;
	   //New skills ---- Monk
				{261:  //Call Spirits
					begin
						tc1 := tc;
						ProcessType := 3;
						spiritSpheres := Skill[261].Data.Data2[Skill[261].Lv];
					end;
				262:  //Absorb Spirits;
																				if spiritSpheres <> 0 then begin
						spiritSpheres := spiritSpheres - 1;
						tc.SP := (tc.SP + Skill[262].Data.Data2[Skill[262].Lv]);
						if tc.SP > tc.MAXSP then
							tc.SP := tc.MAXSP;
					end;}

				{268:   //Steel Body
						if spiritSpheres = 5 then begin
							tc1 := tc;
							ProcessType := 3;
							spiritSpheres := spiritSpheres - 5;
						end;}
				269:    {Blade Stop}
					begin
						ProcessType := 3;
						tc.MTick := Tick + Cardinal(Skill[269].Data.Data1[MUseLV] * 1000);
						tc1.MTick := Tick + Cardinal(Skill[269].Data.Data1[MUseLV] * 1000);
					end;
				270:   //Explosion Spirits
					if tc.spiritSpheres = 5 then begin
						tc1 := tc;
						ProcessType := 3;
						tc.spiritSpheres := tc.spiritSpheres - 5;
					end;

				271:    {Extremity Fist}
					begin
					// Colus, 20040406: Right, so here are the options:
					//  - If you are in Critical mode, and in a combo, you can do a self-target Ashura with 4 spheres.
					//  - If you are not in a combo, you need 5 spheres and must target another person.
						if tc.Skill[270].Tick > Tick then begin
						  if (tc.Skill[271].Data.SType = 1) then begin
							processtype := 255;
							if tc.spiritSpheres = 5 then begin
							frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
							spbonus := tc.SP;
							dmg[0] := dmg[0] *(8 + tc.SP div 100) + 250 + (tc.Skill[271].Lv * 150);
							dmg[0] := dmg[0] + j;
							if dmg[0] < 0 then begin
								dmg[0] := 0;
								//ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
							end;
							SetLength(bb, 6);
							//bb[0] := 6;

							xy := tc.Point;
							DirMove(tm, tc.Point, tc.Dir, bb);

							if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
									assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
									Delete(IndexOf(tc.ID));
								end;
								tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
							end;
							tc.pcnt := 0;

							UpdatePlayerLocation(tm, tc);

							SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
							frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
							tc.MTick := Tick + Cardinal(3500 + (tl.CastTime2 * MUseLV));
							tc.spiritSpheres := tc.spiritSpheres - 5;
							UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

							{20031223, Colus: Cancel Explosion Spirits after Ashura
							 Ashura's tick will control SP lockout time}
							tc.Skill[271].Tick := Tick + 300000;
							tc.Skill[270].Tick := Tick;
							tc.SkillTick := Tick;
							tc.SkillTickID := 270;
							tc.SP := 0;
							SendCStat(tc);
							end;
						// 4-sphere mode
						end else begin
							processtype := 255;
							if tc.spiritSpheres >= 4 then begin

							frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
							spbonus := tc.SP;
							dmg[0] := dmg[0] *(8 + tc.SP div 100) + 250 + (tc.Skill[271].Lv * 150);
							dmg[0] := dmg[0] + j;
							if dmg[0] < 0 then begin
								dmg[0] := 0;
								//ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
							end;
							SetLength(bb, 6);
							//bb[0] := 6;

							xy := tc.Point;
							DirMove(tm, tc.Point, tc.Dir, bb);

							if (xy.X div 8 <> tc.Point.X div 8) or (xy.Y div 8 <> tc.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Clist do begin
									assert(IndexOf(tc.ID) <> -1, 'Player Delete Error');
									Delete(IndexOf(tc.ID));
								end;
								tm.Block[tc.Point.X div 8][tc.Point.Y div 8].Clist.AddObject(tc.ID, tc);
							end;
							tc.pcnt := 0;

							UpdatePlayerLocation(tm, tc);

							SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
							frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
							tc.MTick := Tick + Cardinal(3500 + (tl.CastTime2 * MUseLV));
							tc.spiritSpheres := 0;
							UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);

							{20031223, Colus: Cancel Explosion Spirits after Ashura
							 Ashura's tick will control SP lockout time}
							tc.Skill[271].Tick := Tick + 300000;
							tc.Skill[270].Tick := Tick;
							tc.SkillTick := Tick;
							tc.SkillTickID := 270;
							tc.SP := 0;
							SendCStat(tc);
							tc.Skill[271].Data.SType := 1;
							tc.Skill[271].Data.CastTime1 := 4500;
							SendCSkillList(tc);

							end;
						end;
					end;
				end;

			266:  //Investigate
				begin
					if tc.spiritSpheres <> 0 then begin
						frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						if dmg[0] < 1 then begin
							dmg[0] := 1;
						end;
						if dmg[0] < 0 then begin
							dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
							//ÉpÉPëóêM
						end;
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], tl.Data2[MUseLV]);
						frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
						if MSkill = 266 then begin
							tc.MTick := Tick + 1000;
						end;
						tc.spiritSpheres := tc.spiritSpheres - 1;
						UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
					end;
				end;
			267:  //Finger Offensive
						if tc.spiritSpheres >= tc.MUseLV then begin
							//É_ÉÅÅ[ÉWéZè
							frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
										if dmg[0] < 1 then begin
							dmg[0] := 1;
							end;
							dmg[0] := dmg[0] * tl.Data2[MUseLV];
								if dmg[0] < 0 then begin
								dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								//ÉpÉPëóêM
								end;
								SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], tl.Data2[MUseLV]);
								frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
								tc.MTick := Tick + 1000;
						tc.spiritSpheres := tc.spiritSpheres - tc.MUseLV;
						UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
						end;
				273:  //Combo Finish
					if Skill[272].Tick > Tick then begin
					if (tc.Weapon = 12) then begin
						xy.X := ts.Point.X - Point.X;
						xy.Y := ts.Point.Y - Point.Y;
						if abs(xy.X) > abs(xy.Y) * 3 then begin
							//â°å¸Ç´
							if xy.X > 0 then b := 6 else b := 2;
							end else if abs(xy.Y) > abs(xy.X) * 3 then begin
								//ècå¸Ç´
								if xy.Y > 0 then b := 0 else b := 4;
								end else begin
									if xy.X > 0 then begin
									if xy.Y > 0 then b := 7 else b := 5;
								end else begin
									if xy.Y > 0 then b := 1 else b := 3;
							end;
						end;
						//íeÇ´îÚÇŒÇ∑ëŒè€Ç…ëŒÇ∑ÇÈÉ_ÉÅÅ[ÉWÇÃåvéZ
						frmMain.DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk1(tm, tc, ts, Tick, dmg[0], 1);

						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, 6);
							bb[0] := 6;
							xy := ts.Point;
							DirMove(tm, ts.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> ts.Point.X div 8) or (xy.Y div 8 <> ts.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].Mob do begin
									assert(IndexOf(ts.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(ts.ID));
								end;
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end;
							ts.pcnt := 0;
							//Update Monster Location
							UpdateMonsterLocation(tm, ts);

						end;
						if not frmMain.DamageProcess1(tm, tc, ts, dmg[0], Tick) then
							frmMain.StatCalc1(tc, ts, Tick);

					end else begin
						MMode := 4;
						Exit;
					end;
				end;
			272:  //Chain Combo
					if Skill[263].Tick > Tick then begin
						frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						if dmg[0] < 0 then begin
							dmg[0] := 0; //Negative Damage
						end;
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 4);
						frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
						tc.MTick := Tick + 1000;
						tc.Skill[MSkill].Tick := Tick + cardinal(2) * 1000;
					end;
			5,42,253,316,324: //ÉoÉbÉVÉÖÅAÉÅÉ}Å[ÅADSÅAÉsÉAÅ[ÉXÅASB
				begin

					j := 1;

					//É_ÉÅÅ[ÉWéZèo
					if (MSkill = 5) or (MSkill = 253) then begin
						frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
					end else begin
						frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
					end;

					if (MSkill = 316) or (MSkill = 324) then begin
						if (Weapon = 13) or (Weapon = 14) then begin
							// Is 2 or 3 correct?
							frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
						end else begin
							//DamageCalc1(tm, tc, ts, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
							SendSkillError(tc, 6);
							tc.MMode := 4;
							Exit;
						end;
					end;

					if MSkill = 56 then begin //ÉsÉAÅ[ÉXÇÕts.Data.Scale + 1âÒhit
						j := 1;
						dmg[0] := dmg[0] * j;
					end else if MSkill = 253 then begin
						j := 2;
					end else begin
						j := 1;
					end;

			//ÉÅÉ}Å[ÇÃZenyè¡îÔ
			if MSkill = 42 then begin
				// Should check to see if we have the money!
				if (Zeny >= Cardinal(tl.Data2[MUseLV])) then begin
					Dec(Zeny, tl.Data2[MUseLV]);
					// Update Zeny
					SendCStat1(tc, 1, $0014, Zeny);

				end else begin
					SendSkillError(tc, 5);
					tc.MMode := 4;
					Exit;
				end;
			end;

						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
						if (Skill[145].Lv <> 0) and (MSkill = 5) and (MUseLV > 5) then begin //ã}èäìÀÇ´
							if Random(1000) < Skill[145].Data.Data1[MUseLV] * 10 then begin
								if (tc1.Stat1 <> 3) then begin
									//tc1.Stat1 := 3;
									tc1.BodyTick := Tick + tc.aMotion;
								end else tc1.BodyTick := tc1.BodyTick + 30000;
							end;
						end;
						if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							frmMain.StatCalc2(tc, tc1, Tick);
					end;

			11,13,14,19,20,90,156: //BOLT,NB,SS,ES,HL
					begin
						//É_ÉÅÅ[ÉWéZèo
						dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
						dmg[0] := dmg[0] * (100 - tc1.MDEF1) div 100; //MDEF%
						dmg[0] := dmg[0] - tc1.Param[3]; //MDEF-
						if dmg[0] < 1 then dmg[0] := 1;
						dmg[0] := dmg[0] * ElementTable[tl.Element][tc1.ArmorElement] div 100;
						// Colus, 20040130: Add effect of garment cards
						dmg[0] := dmg[0] * (100 - tc1.DamageFixE[1][tl.Element]) div 100;
						dmg[0] := dmg[0] * tl.Data2[MUseLV];
						if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï

						if (tc1.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], tl.Data2[MUseLV]);
						frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
						case MSkill of
							11,90:     tc.MTick := Tick + 1000;
							13:        tc.MTick := Tick +  800 + 400 * ((MUseLV + 1) div 2) - 300 * (MUseLV div 10);
							14,19,20 : tc.MTick := Tick +  800 + 200 * MUseLV;
							else       tc.MTick := Tick + 1000;
						end;
					end;
{í«â¡}
			15: {Frost Driver PvP}
				begin
					//Damage Calc
					dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * ( MUseLV + 100 ) div 100;
					dmg[0] := dmg[0] * (100 - tc1.MDEF1) div 100; //MDEF%
					dmg[0] := dmg[0] - tc1.MDEF2; // Using INT defense rather than INT.
					//dmg[0] := dmg[0] - tc1.Param[3]; //MDEF- its using only the INT should use MDEF2
					if dmg[0] < 1 then dmg[0] := 1;
					dmg[0] := dmg[0] * ElementTable[tl.Element][tc1.ArmorElement] div 100;
					// Colus, 20040130: Add effect of garment cards
					dmg[0] := dmg[0] * (100 - tc1.DamageFixE[1][tl.Element]) div 100;
					if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
					//ÉpÉPëóêM
					if (tc1.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
					SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
					if (dmg[0] > 0)then begin
						if Random(1000) < tl.Data1[MUseLV] * 10 then begin
							tc1.Stat1 := 2;
							tc1.FreezeTick := Tick + 15000;
							tc1.isFrozen := true;
							UpdateStatus(tm, tc1, Tick);
						end;
					end;
					frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick, False);
					tc.MTick := Tick + 1500;
				end;

{í«â¡ÉRÉRÇ‹Ç≈}
{:119}
			16: {Stone Curse PvP}
				begin
					j := SearchCInventory(tc, 716, false);
					if ((j <> 0) and (tc.Item[j].Amount >= 1)) or (NoJamstone = True) then begin
							//ÉAÉCÉeÉÄêîå∏è
							if NoJamstone = False then UseItem(tc, j);


							//É_ÉÅÅ[ÉWéZèo
						//ÉpÉPëóêM
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, dmg[0]);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, tc1.Point, 15);
						if Random(1000) < tl.Data1[MUseLV] * 10 then begin
							//if (tc1.Stat1 <> 1) then begin
								tc1.Stat1 := 1;
								tc1.isStoned := true;
								tc1.StoneTick := Tick + 15000;
		UpdateStatus(tm, tc1, Tick);
							//end;
						end;
						end else begin
	      SendSkillError(tc, 7); //No Red Gemstone
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
							Exit;
						end;
					end;
{:119}
				17: //FB (HDÇ∆ÇŸÇ⁄ìØÇ∂) - Fireball
					begin
						xy := tc1.Point;
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1,j1].CList.Count - 1 do begin
									if ((tm.Block[i1,j1].CList.Objects[k1] is TChara) = false) then continue;
									tc2 := tm.Block[i1,j1].CList.Objects[k1] as TChara;
									//NoOtherChecks
									if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(tc2.ID),tc2);
								end;
						 end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								tc2 := sl.Objects[k1] as TChara;
								dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
								dmg[0] := dmg[0] * (100 - tc2.MDEF1) div 100; //MDEF%
								dmg[0] := dmg[0] - tc2.Param[3]; //MDEF-
								if dmg[0] < 1 then dmg[0] := 1;
								dmg[0] := dmg[0] * ElementTable[tl.Element][tc2.ArmorElement] div 100;
								// Colus, 20040130: Add effect of garment cards
								dmg[0] := dmg[0] * (100 - tc2.DamageFixE[1][tl.Element]) div 100;
								dmg[0] := dmg[0] * tl.Data2[MUseLV];
								if dmg[0] < 0 then dmg[0] := 1 ; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï - Damage Less than 0
								if (tc2.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
								if (tc1 = tc2) or (tc = tc2)  then k := 0 else k := 5;
								SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], tl.Data2[MUseLV], k);
								//É_ÉÅÅ[ÉWèàóù
								frmMain.DamageProcess2(tm, tc, tc2, dmg[0], Tick);
							end;
						end;
						tc.MTick := Tick + 1600;
					end;

				30: //ë¨ìxå∏è≠
					begin
						ProcessType := 3;
						tc.MTick := Tick + 1000;
					end;


			365:   //Magic Crusher PVP by Eliot
				begin
					dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100; // Calculate Attack Power - Eliot
					dmg[0] := dmg[0] * (100 - tc1.MDEF1) div 100 - tc1.MDEF2; // Calculate Magic Defense - Eliot & added INT defence - KyuubiKitsune
					dmg[0] := dmg[0] - tc1.Param[3];
					if dmg[0] < 1 then          // Check for negative damage
						dmg[0] := 1;
					dmg[0] := dmg[0] * 1;
					dmg[0] := dmg[0] * tl.Data2[MUseLV];
					if dmg[0] < 0 then
						dmg[0] := 0;
					SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], tl.Data2[MUseLV]);
					frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
					tc.MTick := Tick + 1000;
				end;
			47:
				begin
					if (Arrow = 0) or (Item[Arrow].Amount < 9) then begin
						WFIFOW(0, $013b);
						WFIFOW(2, 0);
						Socket.SendBuf(buf, 4);
						ATick := ATick + ADelay;
						Exit;
					end;
					Dec(Item[Arrow].Amount,9);

					WFIFOW( 0, $00af);
					WFIFOW( 2, Arrow);
					WFIFOW( 4, 9);
					Socket.SendBuf(buf, 6);
					if Item[Arrow].Amount = 0 then begin
						Item[Arrow].ID := 0;
						Arrow := 0;
					end;

					frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
					if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);
						if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							frmMain.StatCalc2(tc, tc1, Tick);
						xy := tc1.Point;
						//É_ÉÅÅ[ÉWéZèo2
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue;
									tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									//NotSelf
									//NotTargetChara
									//NotYourGuildMember
									if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
									if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(tc2.ID),tc2);
								end;
							end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								tc2 := sl.Objects[k1] as TChara;

							j := 0;
							case tc.Dir of
							0:
								begin
									if tc2.Point.Y < tc.Point.Y then j := 1;
								end;
							1:
								begin
									if (tc2.Point.X < tc.Point.X) and (tc2.Point.Y > tc.Point.Y) then j := 1;
								end;
							2:
								begin
									if tc2.Point.X > tc.Point.X then j := 1;
								end;
							3:
								begin
									if (tc2.Point.X < tc.Point.X) and (tc2.Point.Y < tc.Point.Y) then j := 1;
								end;
							4:
								begin
									if tc2.Point.Y > tc.Point.Y then j := 1;
								end;
							5:
								begin
									if (tc2.Point.X > tc.Point.X) and (tc2.Point.Y > tc.Point.Y) then j := 1;
								end;
							6:
								begin
									if tc2.Point.X < tc.Point.X then j := 1;
								end;
							7:
								begin
									if (tc2.Point.X > tc.Point.X) and (tc2.Point.Y > tc.Point.Y) then j := 1;
								end;
							end;

							if j <> 1 then begin
								frmMain.DamageCalc3(tm, tc, tc2, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
								if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								//ÉpÉPëóêM
								SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1, 5);
								//É_ÉÅÅ[ÉWèàóù
								if not frmMain.DamageProcess2(tm, tc, tc2, dmg[0], Tick) then
{í«â¡}						frmMain.StatCalc2(tc, tc2, Tick);
							end;
						end;
					end;
				end;
			52:     {Envenom PvP}
				begin
					frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, 100, tl.Element);
					dmg[0] := dmg[0] + 15 * MUseLV;
					dmg[0] := dmg[0] * ElementTable[tl.Element][tc1.ArmorElement] div 100;
					// Colus, 20040130: Add effect of garment cards
					dmg[0] := dmg[0] * (100 - tc1.DamageFixE[1][tl.Element]) div 100;
					if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
					SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
					k1 := (BaseLV * 2 + MUseLV * 3 + 10) - (tc1.BaseLV * 2 + tc1.Param[2]);
					k1 := k1 * 10;
					if Random(1000) < k1 then begin
						tc1.isPoisoned := true;
						tc1.PoisonTick := Tick + 20000;
						tc1.Stat2 := 1;
						UpdateStatus(tm, tc1, Tick);
						//if not Boolean(tc1.Stat2 and 1) then
							//tc1.HealthTick[0] := Tick + tc.aMotion
						//else tc1.HealthTick[0] := tc1.HealthTick[0] + 30000;
					end;
					frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
				end;
{í«â¡:119ÉRÉRÇ‹Ç≈}
			56:
				begin
					if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
						frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						j := 1;
						dmg[0] := dmg[0] * j;
						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
						if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							frmMain.StatCalc2(tc, tc1, Tick);
					end else begin
						MMode := 4;
						Exit;
					end;
				end;
			57:     {Brandish Spear}
				begin
					if (tc.Option and 32 <> 0) and ((tc.Weapon = 4) or (tc.Weapon = 5)) then begin
						frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						dmg[0] := dmg[0] * 2;
						j := 1;

						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
						if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							frmMain.StatCalc2(tc, tc1, Tick);
					end else begin
						tc.MMode := 4;
						tc.MPoint.X := 0;
						tc.MPoint.Y := 0;
						Exit;
					end;
				end;
			58:
				begin
					if (tc.Weapon = 4) or (tc.Weapon = 5) then begin
						xy.X := tc1.Point.X - Point.X;
						xy.Y := tc1.Point.Y - Point.Y;
						if abs(xy.X) > abs(xy.Y) * 3 then begin
							//â°å¸Ç´
							if xy.X > 0 then b := 6 else b := 2;
							end else if abs(xy.Y) > abs(xy.X) * 3 then begin
								//ècå¸Ç´
								if xy.Y > 0 then b := 0 else b := 4;
								end else begin
									if xy.X > 0 then begin
									if xy.Y > 0 then b := 7 else b := 5;
								end else begin
									if xy.Y > 0 then b := 1 else b := 3;
							end;
						end;
						//íeÇ´îÚÇŒÇ∑ëŒè€Ç…ëŒÇ∑ÇÈÉ_ÉÅÅ[ÉWÇÃåvéZ
						frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);

						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, 6);
							bb[0] := 6;
							xy := tc1.Point;
							DirMove(tm, tc1.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> tc1.Point.X div 8) or (xy.Y div 8 <> tc1.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].CList do begin
									Assert(IndexOf(tc1.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(tc1.ID));
								end;
								tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].CList.AddObject(tc1.ID, tc1);
							end;
							tc1.pcnt := 0;
							//Update Player's Location
							UpdatePlayerLocation(tm, tc1);
						end;
						if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							frmMain.StatCalc2(tc, tc1, Tick);

		end else begin
			MMode := 4;
	    Exit;
	  end;
					end;

	59:
	    begin
		if (tc.Weapon = 4) or (tc.Weapon = 5) then begin

		    i1 := 0;
		    k  := 1;
		    while (i1 >= 0) and (i1 < tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].NPC.Count) do begin
			tn := tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].NPC.Objects[i1] as TNPC;
			if tn = nil then begin
			    Inc(i1);
			    continue;
			end;
			if (tc1.Point.X = tn.Point.X) and (tc1.Point.Y = tn.Point.Y) then begin
					case tn.JID of
				$85: {Pneuma}
				begin
				    dmg[0] := 0;
				    //debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Pneuma OK');
				    dmg[6] := 0;
				    k := 0;
				end;
			    end;
			end;
							Inc(i1);
						end;

						if (k = 1) then begin
							frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						end;

						if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);
						if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then begin
							frmMain.StatCalc2(tc, tc1, Tick);
						end;
						tc.MTick := Tick + 1000;
					end else begin
						MMode := 4;
						Exit;
					end;
				end;

			62: //BB
				begin
						//Ç∆ÇŒÇ∑ï˚å¸åàíËèàóù
						//FWÇ©ÇÁÇÃÉpÉNÉä
						xy.X := tc1.Point.X - Point.X;
						xy.Y := tc1.Point.Y - Point.Y;
						if abs(xy.X) > abs(xy.Y) * 3 then begin
							//â°å¸Ç´
							if xy.X > 0 then b := 6 else b := 2;
						end else if abs(xy.Y) > abs(xy.X) * 3 then begin
							//ècå¸Ç´
							if xy.Y > 0 then b := 0 else b := 4;
						end else begin
							if xy.X > 0 then begin
								if xy.Y > 0 then b := 7 else b := 5;
							end else begin
								if xy.Y > 0 then b := 1 else b := 3;
							end;
						end;

						//íeÇ´îÚÇŒÇ∑ëŒè€Ç…ëŒÇ∑ÇÈÉ_ÉÅÅ[ÉWÇÃåvéZ
						frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);

						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, 3);
							bb[0] := 4;
							xy := tc1.Point;
							DirMove(tm, tc1.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> tc1.Point.X div 8) or (xy.Y div 8 <> tc1.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].CList do begin
									assert(IndexOf(tc1.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(tc1.ID));
								end;
								tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].CList.AddObject(tc1.ID, tc1);
							end;
							tc1.pcnt := 0;
							//Update Players Location
							UpdatePlayerLocation(tm, tc1);
							xy := tc1.Point;
							//ä™Ç´Ç±Ç›îÕàÕçUåÇ
							sl.Clear;
							for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
								for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
									for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
										if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue;
										tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
										//NotSelf
										//NotTargetChara
										//NotYourGuildMember
										if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
										if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
											sl.AddObject(IntToStr(tc2.ID),tc2);
									end;
								end;
							end;
							if sl.Count <> 0 then begin
								for k1 := 0 to sl.Count - 1 do begin
									tc2 := sl.Objects[k1] as TChara;
									frmMain.DamageCalc3(tm, tc, tc2, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
									if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
									//ÉpÉPëóêM
									SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1, 5);
									//É_ÉÅÅ[ÉWèàóù
									if not frmMain.DamageProcess2(tm, tc, tc2, dmg[0], Tick) then
{í«â¡}							frmMain.StatCalc2(tc, tc2, Tick);
								end;
							end;
						end;
						if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
{í«â¡}				frmMain.StatCalc2(tc, tc1, Tick);
					end;
{:119}
				76: // Lex Divina vs. Player
					begin
						//ÉpÉPëóêM
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, tc1.Point, 15);
						// Set Silence effect
						if Boolean((1 shl 2) and tc1.Stat2) then begin
							tc1.HealthTick[2] := tc1.HealthTick[2] + 30000; //âÑí∑
						end else begin
							tc1.HealthTick[2] := Tick + tc.aMotion;
						end;
					end;

				77: // Turn Undead vs. Player
					begin
					// Colus, 20040127: Fixed check to be for players
						if (tc1.ArmorElement mod 20 = 9) then begin
							m := MUseLV * 20 + Param[3] + Param[5] + BaseLV + (200 - 200 * Cardinal(tc1.HP) div Cardinal(tc1.HP)) div 200;
							if (Random(1000) < m) then begin
								dmg[0] := tc1.HP;
							end else begin
								dmg[0] := (BaseLV + Param[3] + (MUseLV * 10)) * ElementTable[6][0] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
							end;
							// Damage cap (removed)
							//if (dmg[0] div $010000) <> 0 then dmg[0] := $07FFF; //ï€åØ
							// Lex Aeterna effect
							if (tc1.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
							SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
							frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
							tc.MTick := Tick + 3000;
						end else begin
							tc.MMode := 4;
							Exit;
						end;
					end;
				78: // Lex Aeterna
					begin
						//ÉpÉPëóêM
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, MTarget);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, tc1.Point, 15);

	    // Colus, 20040126: Can't use Lex Aeterna on Stat1.
	    // Set the tick on the skill instead.

	    if ((tc1.Stat1 < 1) or (tc1.Stat1 > 2)) then
	      tc1.Skill[78].Tick := $FFFFFFFF;

	    tc.MTick := Tick + 3000;
						{if (tc1.Stat1 = 0) or (tc1.Stat1 = 3) or (tc1.Stat1 = 4) then begin
							//tc1.Stat1 := 5;
							tc1.BodyTick := Tick + tc.aMotion;
						end else if (tc1.Stat1 = 5) then tc1.BodyTick := tc1.BodyTick + 30000;}
					end;
				84: //JT
					begin

						xy.X := tc1.Point.X - Point.X;
						xy.Y := tc1.Point.Y - Point.Y;
						if abs(xy.X) > abs(xy.Y) * 3 then begin
							//â°å¸Ç´
							if xy.X > 0 then   b := 6 else b := 2;
						end else if abs(xy.Y) > abs(xy.X) * 3 then begin
							//ècå¸Ç´
							if xy.Y > 0 then   b := 0 else b := 4;
						end else begin
							if xy.X > 0 then begin
								if xy.Y > 0 then b := 7 else b := 5;
							end else begin
								if xy.Y > 0 then b := 1 else b := 3;
							end;
						end;

						//É_ÉÅÅ[ÉWéZèo
						dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100 * tl.Data1[MUseLV] div 100;
						dmg[0] := dmg[0] * (100 - tc1.MDEF1) div 100; //MDEF%
						dmg[0] := dmg[0] - tc1.Param[3]; //MDEF-
						if dmg[0] < 1 then dmg[0] := 1;
						dmg[0] := dmg[0] * ElementTable[tl.Element][tc1.ArmorElement] div 100;
	    // Colus, 20040130: Add effect of garment cards
	    dmg[0] := dmg[0] * (100 - tc1.DamageFixE[1][tl.Element]) div 100;
						dmg[0] := dmg[0] * tl.Data2[MUseLV];
						if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
	    if (tc1.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
						//ÉpÉPëóêM
																								// AlexKreuz: Monk Heal
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], tl.Data2[MUseLV]);
						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, tl.Data2[MUseLV] div 2);
							bb[0] := 4;
							xy.X := tc1.Point.X;
							xy.Y := tc1.Point.Y;
							DirMove(tm, tc1.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> tc1.Point.X div 8) or (xy.Y div 8 <> tc1.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].CList do begin
									assert(IndexOf(tc1.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(tc1.ID));
								end;
								tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].CList.AddObject(tc1.ID, tc1);
							end;
							tc1.pcnt := 0;
						//Update Players Location
						UpdatePlayerLocation(tm, tc1);
						end;
						frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
					end;
				88: //ÉtÉçÉXÉgÉmÉîÉ@
					begin
					//Colus: A stray 35,000 damage thing for Frost Nova.
					//SendCSkillAtk2(tm, tc, tc1, 15, 35000, 1, 6);
						xy := tc1.Point;
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue;
									tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									//NotSelf
									//NotTargetChara
									//NotYourGuildMember
									if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
									if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(tc2.ID),tc2);
								end;
							end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								tc2 := sl.Objects[k1] as TChara;
								dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100;
								dmg[0] := dmg[0] * (100 - tc2.MDEF1) div 100; //MDEF%
								dmg[0] := dmg[0] - tc2.Param[3]; //MDEF-
								if dmg[0] < 1 then dmg[0] := 1;
								dmg[0] := dmg[0] * ElementTable[tl.Element][tc2.ArmorElement] div 100;
								// Colus, 20040130: Add effect of garment cards
								dmg[0] := dmg[0] * (100 - tc2.DamageFixE[1][tl.Element]) div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								if (tc2.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
								SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1 , 5);
								// Colus: What the hell is this?  1 <> 1?
								if (1 <> 1) and (dmg[0] <> 0)then begin
									if Random(1000) < tl.Data1[MUseLV] * 10 then begin
										//tc2.Stat1 := 2;
										tc2.BodyTick := Tick + tc.aMotion;
									end;
								end;
								//É_ÉÅÅ[ÉWèàóù
								frmMain.DamageProcess2(tm, tc, tc2, dmg[0], Tick);
							end;
						end;
						tc.MTick := Tick + 1000;
					end;
				86: {Water Ball PvP}
					begin
						k := tl.Data1[MUseLV];
						for m := 0 to k - 1 do begin
						if dmg[1] <> 0 then begin
							dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100;
							dmg[0] := dmg[0] * (100 - tc1.MDEF1) div 100; //MDEF%
							dmg[0] := dmg[0] - tc1.Param[3]; //MDEF-
							if dmg[0] < 1 then dmg[0] := 1;
							dmg[0] := dmg[0] * ElementTable[tl.Element][tc1.ArmorElement] div 100;
							if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
							if (tc1.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
							SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
							//É_ÉÅÅ[ÉWèàóù
							frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
							xy := tc1.Point;
							sl.Clear;
							for j1 := (xy.Y - tl.Data2[MUseLV]) div 8 to (xy.Y + tl.Data2[MUseLV]) div 8 do begin
								for i1 := (xy.X - tl.Data2[MUseLV]) div 8 to (xy.X + tl.Data2[MUseLV]) div 8 do begin
									for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
										if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue;
										tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
										//NotSelf
										//NotTargetChara
										//NotYourGuildMember
										if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
										if (abs(tc2.Point.X - xy.X) <= tl.Data2[MUseLV]) and (abs(tc2.Point.Y - xy.Y) <= tl.Data2[MUseLV]) then
											sl.AddObject(IntToStr(tc2.ID),tc2);
									end;
								end;
							end;
							if sl.Count <> 0 then begin
								for k1 := 0 to sl.Count - 1 do begin
									tc2 := sl.Objects[k1] as TChara;
									dmg[0] := MATK1 + Random(MATK2 - MATK1 + 1) * MATKFix div 100;
									dmg[0] := dmg[0] * (100 - tc2.MDEF1) div 100; //MDEF%
									dmg[0] := dmg[0] - tc2.Param[3]; //MDEF-
									if dmg[0] < 1 then dmg[0] := 1;
									dmg[0] := dmg[0] * ElementTable[tl.Element][tc2.ArmorElement] div 100;
									if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
									if (tc2.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
									SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1);
									//É_ÉÅÅ[ÉWèàóù
									frmMain.DamageProcess2(tm, tc, tc2, dmg[0], Tick)
								end;
							end;
						end;
					end;
				end;

			129://Blitz beat
				begin
					xy := tc1.Point;
					//É_ÉÅÅ[ÉWéZè
					if tc.Option and 16 <> 0 then begin
						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue;
									tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									//NotSelf
									//NotTargetChara
									//NotYourGuildMember
									if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
									if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(tc2.ID),tc2);
								end;
							end;
						end;
						if sl.Count <> 0 then begin
							if Skill[128].Lv <> 0 then begin
								dmg[1] := Skill[128].Data.Data1[Skill[128].Lv] * 2;
							end else begin
								dmg[1] := 0
							end;
							dmg[1] := dmg[1] + (Param[4] div 10 + Param[3] div 2) * 2 + 80;
							dmg[1] := dmg[1] * MUseLV;
							for k1 := 0 to sl.Count - 1 do begin
								tc2 := sl.Objects[k1] as TChara;
								dmg[0] := dmg[1] * ElementTable[tl.Element][tc2.ArmorElement] div 100;
								if dmg[0] < 0 then dmg[0] := 0; //ñÇñ@çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
								if (tc2.Skill[78].Tick > Tick) then dmg[0] := dmg[0] * 2;
								SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], MUseLV);
								//É_ÉÅÅ[ÉWèàóù
								frmMain.DamageProcess2(tm, tc, tc2, dmg[0], Tick);
							end;
						end;
					end else begin
						MMode := 4;
						Exit;
					end;
				end;
			136:
				begin
					if (tc.Weapon = 16) then begin
					frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
					j := 8;
					if dmg[0] < 0 then dmg[0] := 0;
					SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
					if (Skill[145].Lv <> 0) and (MSkill = 5) and (MUseLV > 5) then begin //ã}èäìÀÇ´
						if Random(1000) < Skill[145].Data.Data1[MUseLV] * 10 then begin
							if (tc1.Stat1 <> 3) then begin
								//tc1.Stat1 := 3;
								tc1.BodyTick := Tick + tc.aMotion;
							end else tc1.BodyTick := tc1.BodyTick + 30000;
						end;
					end;
					if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
						frmMain.StatCalc2(tc, tc1, Tick);
						tc.MTick := Tick + 1000;
					end else begin
						MMode := 4;
						Exit;
					end;
				end;
			137:    {Grimtooth}
				begin
					if (tc.Option and 2 <> 0) and (Weapon = 16) then begin
						frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
							if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
							//ÉpÉPëóêM
							SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);
							if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
								frmMain.StatCalc2(tc, tc1, Tick);
							xy := tc1.Point;
							//É_ÉÅÅ[ÉWéZèo2
							sl.Clear;
							for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
								for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
									for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
										if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue;
										tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
										//NotSelf
										//NotTargetChara
										//NotYourGuildMember
										if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
										if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
											sl.AddObject(IntToStr(tc2.ID),tc2);
									end;
								end;
							end;
							if sl.Count <> 0 then begin
								for k1 := 0 to sl.Count - 1 do begin
									tc2 := sl.Objects[k1] as TChara;
									frmMain.DamageCalc3(tm, tc, tc2, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
									if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
									//ÉpÉPëóêM
									SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1, 5);
									//É_ÉÅÅ[ÉWèàóù
									if not frmMain.DamageProcess2(tm, tc, tc2, dmg[0], Tick) then
										frmMain.StatCalc2(tc, tc2, Tick);
								end;
							end;
						end else begin
							MMode := 4;
							Exit;
						end;
					end;
				148: //É`ÉÉÅ[ÉW_ÉAÉçÅ[
					begin
						//Ç∆ÇŒÇ∑ï˚å¸åàíËèàóù
						//FWÇ©ÇÁÇÃÉpÉNÉä
						xy.X := tc1.Point.X - Point.X;
						xy.Y := tc1.Point.Y - Point.Y;
						if abs(xy.X) > abs(xy.Y) * 3 then begin
							//â°å¸Ç´
							if xy.X > 0 then b := 6 else b := 2;
							end else if abs(xy.Y) > abs(xy.X) * 3 then begin
								//ècå¸Ç´
								if xy.Y > 0 then b := 0 else b := 4;
								end else begin
									if xy.X > 0 then begin
									if xy.Y > 0 then b := 7 else b := 5;
								end else begin
									if xy.Y > 0 then b := 1 else b := 3;
							end;
						end;

						//íeÇ´îÚÇŒÇ∑ëŒè€Ç…ëŒÇ∑ÇÈÉ_ÉÅÅ[ÉWÇÃåvéZ
						frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
						if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï
						//ÉpÉPëóêM
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);

						//ÉmÉbÉNÉoÉbÉNèàóù
						if (dmg[0] > 0) then begin
							SetLength(bb, 6);
							bb[0] := 6;
							xy := tc1.Point;
							DirMove(tm, tc1.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> tc1.Point.X div 8) or (xy.Y div 8 <> tc1.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].CList do begin
									assert(IndexOf(tc1.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(tc1.ID));
								end;
								tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].CList.AddObject(tc1.ID, tc1);
							end;
							tc1.pcnt := 0;
							//Update Players Location
							UpdatePlayerLocation(tm, tc1);
						end;
						if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							frmMain.StatCalc2(tc, tc1, Tick);
					end;
			149:
				begin

					frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, 0);
					dmg[0] := Round(dmg[0] * 1.25);
					j := 1;
					if dmg[0] < 0 then dmg[0] := 0;
					SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
					if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
						frmMain.StatCalc2(tc, tc1, Tick);

					end;
				152: //êŒìäÇ∞
					begin
						j := SearchCInventory(tc, 7049, false);
						if (j <> 0) and (tc.Item[j].Amount >= 1) then begin

							UseItem(tc, j);
							dmg[0] := 30;
							dmg[0] := dmg[0] * ElementTable[tl.Element][0] div 100;
							SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1);
							if Random(1000) < Skill[152].Data.Data1[MUseLV] * 10 then begin
								if (tc1.Stat1 <> 3) then begin
									//tc1.Stat1 := 3;
									tc1.BodyTick := Tick + tc.aMotion;
								end else tc1.BodyTick := tc1.BodyTick + 30000;
							end;
						frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick, False);
						end else begin
							tc.MMode := 4;
							tc.MPoint.X := 0;
							tc.MPoint.Y := 0;
						end;
					end;
				153:
					begin
						xy.X := tc1.Point.X - Point.X;
						xy.Y := tc1.Point.Y - Point.Y;
						if abs(xy.X) > abs(xy.Y) * 3 then begin
							//â°å¸Ç´
							if xy.X > 0 then b := 6 else b := 2;
							end else if abs(xy.Y) > abs(xy.X) * 3 then begin
								//ècå¸Ç´
								if xy.Y > 0 then b := 0 else b := 4;
								end else begin
									if xy.X > 0 then begin
									if xy.Y > 0 then b := 7 else b := 5;
								end else begin
									if xy.Y > 0 then b := 1 else b := 3;
							end;
						end;

			//DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
			frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, 150 + (tc.Cart.Weight div 800), tl.Element, 0);
						//dmg[0] := dmg[0] + (tc.Cart.Weight div 800);
			if dmg[0] < 0 then dmg[0] := 0;

						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);

			if (dmg[0] > 0) then begin
							SetLength(bb, 2);
							bb[0] := 0; // Just push in the direction you're casting
				bb[1] := 0; // for 2 tiles.
							//bb[0] := 6;
							xy := tc1.Point;
							DirMove(tm, tc1.Point, b, bb);
							//ÉuÉçÉbÉNà⁄ìÆ
							if (xy.X div 8 <> tc1.Point.X div 8) or (xy.Y div 8 <> tc1.Point.Y div 8) then begin
								with tm.Block[xy.X div 8][xy.Y div 8].CList do begin
									assert(IndexOf(tc1.ID) <> -1, 'MobBlockDelete Error');
									Delete(IndexOf(tc1.ID));
								end;
								tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].CList.AddObject(tc1.ID, tc1);
							end;
							tc1.pcnt := 0;
							//Update Players Location
							UpdatePlayerLocation(tm, tc1);
						end;
						if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
							frmMain.StatCalc2(tc, tc1, Tick);

						sl.Clear;
						for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
							for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
								for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
									if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue;
									tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
									//NotSelf
									//NotTargetChara
									//NotYourGuildMember
									if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
									if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
										sl.AddObject(IntToStr(tc2.ID),tc2);
								end;
							end;
						end;
						if sl.Count <> 0 then begin
							for k1 := 0 to sl.Count - 1 do begin
								tc2 := sl.Objects[k1] as TChara;

								xy.X := tc2.Point.X - Point.X;
								xy.Y := tc2.Point.Y - Point.Y;
								if abs(xy.X) > abs(xy.Y) * 3 then begin
									//â°å¸Ç´
									if xy.X > 0 then b := 6 else b := 2;
									end else if abs(xy.Y) > abs(xy.X) * 3 then begin
										//ècå¸Ç´
										if xy.Y > 0 then b := 0 else b := 4;
										end else begin
											if xy.X > 0 then begin
												if xy.Y > 0 then b := 7 else b := 5;
											end else begin
												if xy.Y > 0 then b := 1 else b := 3;
											end;
										end;

								frmMain.DamageCalc3(tm, tc, tc2, Tick, 0, 150 + (tc.Cart.Weight div 800), tl.Element, 0);
								//dmg[0] := dmg[0] + (tc.Cart.MaxWeight div 8000);
								if dmg[0] < 0 then dmg[0] := 0;

								SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1, 5);

							if (dmg[0] > 0) then begin
								SetLength(bb, 2);
								bb[0] := 0; // Just push in the direction you're casting
								bb[1] := 0; // for 2 tiles.
								//bb[0] := 6;
								xy := tc2.Point;
								DirMove(tm, tc2.Point, b, bb);
								//ÉuÉçÉbÉNà⁄ìÆ
								if (xy.X div 8 <> tc2.Point.X div 8) or (xy.Y div 8 <> tc2.Point.Y div 8) then begin
									with tm.Block[xy.X div 8][xy.Y div 8].CList do begin
										assert(IndexOf(tc2.ID) <> -1, 'MobBlockDelete Error');
										Delete(IndexOf(tc2.ID));
									end;
									tm.Block[tc2.Point.X div 8][tc2.Point.Y div 8].CList.AddObject(tc2.ID, tc2);
								end;
								tc2.pcnt := 0;
								//Update Players Location
								UpdatePlayerLocation(tm, tc2);
							end;
							if not frmMain.DamageProcess2(tm, tc, tc2, dmg[0], Tick) then
								frmMain.StatCalc2(tc, tc2, Tick);
						end;
					end;

				end;

			251:
				begin
					if (tc.Shield <> 0) then begin

						i1 := 0;
						k  := 1;
						while (i1 >= 0) and (i1 < tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].NPC.Count) do begin
							tn := tm.Block[tc1.Point.X div 8][tc1.Point.Y div 8].NPC.Objects[i1] as TNPC;
							if tn = nil then begin
								Inc(i1);
								continue;
							end;
							if (tc1.Point.X = tn.Point.X) and (tc1.Point.Y = tn.Point.Y) then begin
								case tn.JID of
								$85: {Pneuma}
									begin
										dmg[0] := 0;
										//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Pneuma OK');
										dmg[6] := 0;
										k := 0;
									end;
								end;
							end;
			Inc(i1);
				end;

				if (k = 1) then begin
					frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
				end;

				if dmg[0] < 0 then dmg[0] := 0;
						SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], 1, 6);
						if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then begin
							frmMain.StatCalc2(tc, tc1, Tick);
						end;
					end;
				end;

			254:
				begin
					NoCastInterrupt := true;
					frmMain.DamageCalc3(tm, tc, tc1, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data1[MUseLV]);
					j := 3;
					if dmg[0] < 0 then dmg[0] := 0; //ëÆê´çUåÇÇ≈ÇÃâÒïúÇÕñ¢é¿ëï

					SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
					if not frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick) then
						frmMain.StatCalc2(tc, tc1, Tick);
					xy := tc1.Point;

					sl.Clear;
					for j1 := (xy.Y - tl.Range2) div 8 to (xy.Y + tl.Range2) div 8 do begin
						for i1 := (xy.X - tl.Range2) div 8 to (xy.X + tl.Range2) div 8 do begin
							for k1 := 0 to tm.Block[i1][j1].CList.Count - 1 do begin
								if ((tm.Block[i1][j1].CList.Objects[k1] is TChara) = false) then continue;
								tc2 := tm.Block[i1][j1].CList.Objects[k1] as TChara;
								//NotSelf
								//NotTargetChara
								//NotYourGuildMember
								if (tc1 = tc2) or (tc = tc2) or ((mi.PvPG = true) and (tc.GuildID = tc2.GuildID) and (tc.GuildID <> 0)) then Continue;
								if (abs(tc2.Point.X - xy.X) <= tl.Range2) and (abs(tc2.Point.Y - xy.Y) <= tl.Range2) then
									sl.AddObject(IntToStr(tc2.ID),tc2);
							end;
						end;
					end;

					if sl.Count <> 0 then begin
						for k1 := 0 to sl.Count - 1 do begin
							tc2 := sl.Objects[k1] as TChara;
							frmMain.DamageCalc3(tm, tc, tc2, Tick, 0, tl.Data1[MUseLV], tl.Element, tl.Data2[MUseLV]);
							j := 1;
							if dmg[0] < 0 then dmg[0] := 0;
							SendCSkillAtk2(tm, tc, tc2, Tick, dmg[0], 1, 6);
							//SendCSkillAtk2(tm, tc, tc1, Tick, dmg[0], j);
							if not frmMain.DamageProcess2(tm, tc, tc2, dmg[0], Tick) then
								frmMain.StatCalc2(tc, tc2, Tick);
						end;
					end;
				end;
			277:    {Spellbreaker}
					begin
																								tc.SP := tc.SP + (tc1.SPAmount * tc.Skill[277].Data.Data1[MUseLv]);
						if tc.SP > tc.MAXSP then tc.SP := tc.MAXSP;
						tc1.MMode := 0;
						tc1.MPoint.X := 0;
						tc1.MPoint.Y := 0;
						WFIFOW(0, $01b9);
						WFIFOL(2, tc1.ID);
						SendBCmd(tm, tc1.Point, 6);
					end;
				289:  {Dispell}
				  begin
				    for i := 1 to MAX_SKILL_NUMBER do begin
				      tc1.Skill[i].Tick := Tick;
									  tc1.Skill[i].EffectLV := 0;
									  tc1.Skill[i].Effect1 := 0;
										if SkillTick > tc1.Skill[i].Tick then begin
										  SkillTick := tc1.Skill[i].Tick;
										  SkillTickID := MSkill;
				      end;
									  //Remove Icons
							if tc1.Skill[i].Data.Icon <> 0 then begin
										  //debugout.lines.add('[' + TimeToStr(Now) + '] ' + '(Icon Removed)!');
					UpdateIcon(tm, tc1, tc1.Skill[i].Data.Icon, 0);
									  end;
				      CalcStat(tc1, Tick);
				      SendCStat(tc1);
				    end;

				end;
				374:  {Soul Change PvP}
				begin
				{Requirement: Magic Rod LV 3, Spell Breaker LV 2
				 * Exchange SP of the target with your SP. You can use this for
				 party members in normal maps, and for anyone in PvP. If any leftover
				 SP remains, they will be ignored (for example, a Knight with 200 SP
				 will not have any more than max SP of 200 even if the Professor
				 had 1000 SP). If a magic caster gets SP switched,
				 and his or her SP doesn't fulfill the requirement for magic he
				 or she was casting, the magic will do absolutely nothing.
				 It takes 3 seconds to cast, and takes 5 SP.
				 There's also nasty 5 second after-skill delay.
				 If you use this on a monster, you regain 3% of your SP.
				 You can't use this skill on a monster again that already had
				 Soul Change.}
					i := tc.SP;
					k := tc1.SP;
					tc.SP := k;
					tc1.SP := i;
					if tc1.SP > tc1.MAXSP then tc1.SP := tc1.MAXSP;
					if tc.SP > tc.MAXSP then tc.SP := tc.MAXSP;
					tc.MTick := Tick + 5000;

				  SendCStat(tc);
				  SendCStat(tc1);
				  {Socket.SendBuf(buf, 8);
				  WFIFOW( 0, $00b0);
																	WFIFOW( 2, $0005);
				  WFIFOL( 4, SP);
																	Socket.SendBuf(buf, 8);

				  tc1.Socket.SendBuf(buf, 8);
				  WFIFOW( 0, $00b0);
				  WFIFOW( 2, $0005);
					WFIFOL( 4, tc1.SP);
				  tc1.Socket.SendBuf(buf, 8); }



				end;

						375: //Soul Burn pVp
							begin
								i := tc1.SP;
								dmg[0] := i * 2;
								if Random(100) < Skill[375].Data.Data1[MUseLV] then begin
									tc.SP := 0;
									//dmg[0] := dmg[0] - (tc.MDEF1 + tc.MDEF2);
									//if dmg[0] < 0 then dmg[0] := 0;
									frmMain.DamageProcess2(tm, tc, tc, dmg[0], Tick);
									SendCStat(tc);
								end else begin
									tc1.SP := 0;
									//dmg[0] := dmg[0] - (tc1.MDEF1 + tc1.MDEF2);
									frmMain.DamageProcess2(tm, tc, tc1, dmg[0], Tick);
									SendCStat(tc1);
								end;
							end;

						end;//case

						if tc1.MagicReflect then begin
							//tc.MSkill := 252;
							tc1.MSkill := 252;
							dmg[0] := dmg[0] * 30 div 100;
							SendCSkillAtk2(tm, tc1, tc, Tick, dmg[0], 1, 6);
							if not frmMain.DamageProcess2(tm, tc1, tc, dmg[0], Tick) then frmMain.StatCalc1(tc, ts, Tick);
							dmg[0] := 0;
							dmg[5] := 11;
						end;

					end;
				end;

			end else begin
				if tc.MTick + 500 < Tick then begin
					MMode := 4;
					sl.Free;
					Exit;//safe 2004/06/03
				end;
			end;

			{if (tc1 <> nil) then begin
				if (tc1.Skill[225].Lv <> 0) then begin
					if (tc.Skill[tc.MSkill].Lv <= tc1.Skill[225].Lv) then begin
						if (tc1.Plag <> 0) then begin
							tc1.Skill[tc1.Plag].Plag := false;
							tc1.Skill[tc1.Plag].Lv := 0;
						end;
						tc1.Plag := tc.MSkill;
						tc1.PLv := tc.Skill[tc.MSkill].Lv;
						tc1.Skill[tc.MSkill].Plag := true;
						SendCSkillList(tc1);
					end;
				end;
			end;}
			case ProcessType of
			0: // Player skill, no time limit, no status update, no icon
				begin
					// Send effect
					WFIFOW( 0, $011a);
					WFIFOW( 2, MSkill);
					WFIFOW( 4, dmg[0]);
					WFIFOL( 6, tc1.ID);
					WFIFOL(10, ID);
					WFIFOB(14, 1);
					SendBCmd(tm, tc1.Point, 15);
				end;
			1: // Player skill, no time limit, with icon change
				begin
					if (tc1.MSkill <> 135) then begin
						WFIFOW( 0, $011a);
						WFIFOW( 2, MSkill);
						WFIFOW( 4, MUseLV);
						WFIFOL( 6, tc1.ID);
						WFIFOL(10, ID);
						WFIFOB(14, 1);
						SendBCmd(tm, tc1.Point, 15);
					end;
					// Hiding
					if (tc1.MSkill = 51) then begin {Hiding}
						if (tc1.Option and 2 <> 0) then begin
							//tc1.setSkillOnBool(False); //set SkillOnBool for icon update //beita 20040206
							tc1.Skill[MSkill].Tick := Tick;
							tc1.Option := tc1.Option and $FFFD;
							SkillTick := tc1.Skill[MSkill].Tick;
							SkillTickID := MSkill;
							//tc1.SP := tc1.SP + 10;  // Colus 20040118
							tc1.Hidden := false;
							//if tc1.SP > tc1.MAXSP then tc1.SP := tc1.MAXSP;
						end else begin
							//tc1.setSkillOnBool(True); //set SkillOnBool for icon update //beita 20040206
							// Required to place Hide on a timer.
							tc1.Skill[MSkill].Tick := Tick + cardinal(tl.Data1[MUseLV]) * 1000;

							if SkillTick > tc1.Skill[MSkill].Tick then begin
								SkillTick := tc1.Skill[MSkill].Tick;
								SkillTickID := MSkill;
							end;

							//tc1.Optionkeep := tc1.Option;
							tc1.Option := tc1.Option or 2;
							tc1.Hidden := true;
							// Colus, 20040224: Hide also drains SP but at a different rate...
							tc1.CloakTick := Tick;
						end;

						CalcStat(tc1, Tick);
						UpdateOption(tm, tc1);

						// Colus, 20031228: Tunnel Drive speed update
						if (tc1.Skill[213].Lv <> 0) then begin
							SendCStat1(tc1, 0, 0, tc1.Speed);
						end;
					end;

					// Play Dead
					if (tc1.MSkill = 143) then begin
						if tc1.Sit = 1 then begin
							//set SkillOnBool for icon update //beita 20040206
							//tc1.setSkillOnBool(False);
							tc1.Sit := 3;

							SkillTick := tc1.Skill[MSkill].Tick;
							SkillTickID := MSkill;

							tc1.SP := tc1.SP + 5;
							if tc1.SP > tc1.MAXSP then tc1.SP := tc1.MAXSP;
							CalcStat(tc1, Tick);
						end else begin
							//set SkillOnBool for icon update //beita 20040206
							//tc1.setSkillOnBool(True);
							tc1.Sit := 1;
						end;
					end;

					if (tl.Icon <> 0) then begin
						UpdateIcon(tm, tc, tl.Icon, 1);
					end;
				end;
			2, 3: // Player-based, time-limited skill (2 = no status update, 3 = status update)
				begin
					// Send effect
					WFIFOW( 0, $011a);
					WFIFOW( 2, MSkill);
					WFIFOW( 4, MUseLV);
					WFIFOL( 6, tc1.ID);
					WFIFOL(10, ID);
					WFIFOB(14, 1);
					SendBCmd(tm, tc1.Point, 15);
					tc1.Skill[MSkill].Tick := Tick + cardinal(tl.Data1[MUseLV]) * 1000;
					tc1.Skill[MSkill].EffectLV := MUseLV;
					tc1.Skill[MSkill].Effect1 := tl.Data2[MUseLV];
					if SkillTick > tc1.Skill[MSkill].Tick then begin
						SkillTick := tc1.Skill[MSkill].Tick;
						SkillTickID := MSkill;
					end;
					if MSkill = 61 then tc1.Skill[MSkill].Tick := Tick + cardinal(tl.Data1[MUseLV]) * 110;
					CalcStat(tc1, Tick);
					if ProcessType = 3 then SendCStat(tc1);
					//ÉAÉCÉRÉìï\é¶
					if (tl.Icon <> 0) and (tl.Icon <> 107) then begin
						//debugout.lines.add('[' + TimeToStr(Now) + '] ' + '(ﬂÅÕﬂ)!');
						UpdateIcon(tm, tc1, tl.Icon, 1);
					end;
				end;

			4,5: // Party-only time-limited skills (4 means no status change, 5 means status change)
				begin
					sl.Clear;
					if (tc.PartyName = '') then begin
						sl.AddObject(IntToStr(tc.ID),tc);
					end else begin
						tpa := PartyNameList.Objects[PartyNameList.IndexOf(tc.PartyName)] as TParty;
						for k := 0 to 11 do begin
							if(tpa.MemberID[k] = 0) then break;
							if tpa.Member[k].Login <> 2 then Continue;
							if tc.Map <> tpa.Member[k].Map then Continue;
							if (abs(tc.Point.X - tpa.Member[k].Point.X) < 16) and
							(abs(tc.Point.Y - tpa.Member[k].Point.Y) < 16) then
								sl.AddObject(IntToStr(tpa.MemberID[k]),tpa.Member[k]);
						end;
					end;
					if sl.Count <> 0 then begin
						for k := 0 to sl.Count -1 do begin
							tc1 := sl.Objects[k] as TChara;
							//ÉpÉPëóêM
							WFIFOW( 0, $011a);
							WFIFOW( 2, tc.MSkill);
							WFIFOW( 4, tc.MUseLV);
							WFIFOL( 6, tc1.ID);
							WFIFOL(10, tc1.ID);
							WFIFOB(14, 1);
							SendBCmd(tm, tc1.Point, 15);
							if tc.MSkill = 255 then begin
								if tc.JID = 14 then tc1.Crusader := tc;
							end;
							//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('ID %d casts %d to ID %d', [tc.ID,tc.MSkill,tc1.ID]));
							tc1.Skill[tc.MSkill].Tick := Tick + cardinal(tl.Data1[tc.MUseLV]) * 1000;
							tc1.Skill[tc.MSkill].EffectLV := tc.MUseLV;
							tc1.Skill[tc.MSkill].Effect1 := tl.Data2[tc.MUseLV];
							if tc1.SkillTick > tc1.Skill[tc.MSkill].Tick then begin
								tc1.SkillTick := tc1.Skill[tc.MSkill].Tick;
								tc1.SkillTickID := tc.MSkill;
							end;
							CalcStat(tc1, Tick);
							if ProcessType = 5 then SendCStat(tc1);
							//ÉAÉCÉRÉìï\é¶
							if (tl.Icon <> 0) then begin
								UpdateIcon(tm, tc1, tl.Icon, 1);
							end;
						end;
					end;
				end;
			end;
{ÉpÅ[ÉeÉBÅ[ã@î\í«â¡ÉRÉRÇ‹Ç≈}
		end;
	end;
	sl.Free;
End;(* Proc SkillEffect()
*-----------------------------------------------------------------------------*)



(*-----------------------------------------------------------------------------*
FindTargetsInAttackRange()

Find Monsters in Range of Skill's Attack Radius (Range2 in code speak)
(Made to replace MG_FIREBALL search - looking for simular code in other skills)

Used for skills that have a radius of attack.
(i.e. splash damage, or an area effect)

* An IntList is passed to this routine - Creation and Cleanup of the list is
the calling routine's responsibility, only.

Pre:
	MonsterList is created, any data in the list is cleared.
	SkillDB is valid.

Post:
	MonsterList contains 0+ monsters that are in range of the given Skill.


Revisions:
2004/06/03 [ChrstphrR] rearranged routine - has a code for special exceptions...
It doesn't YET properly support Characters or Monsters as targets, only
Monsters. ... will be worked on at a later time (time to rotovate the garden!)
*-----------------------------------------------------------------------------*)
Procedure FindTargetsInAttackRange(
		TrgtList  : TIntList32;
		SData     : TSkillDB;
		Chara     : TChara;
		TrgtPt    : TPoint;
		Target    : TLiving; //May be NIL
		TargetChk : Byte
	);
Var
	X    : Integer;
	Y    : Integer;
	MCnt : Integer;
	Area    : TRect; //Simplifies Math for Block by Block search.
	ChkArea : TRect; //Simplifies Monster within Range check.

//	AMap : TMap; //Chara.MData is the same...
	AMob   : TMob;
	AChara : TChara;
Begin
	Area := Rect( //Ordered Left, Right, Top, Bottom
		TrgtPt.X - SData.Range2, TrgtPt.Y - SData.Range2,
		TrgtPt.X + SData.Range2, TrgtPt.Y + SData.Range2
	);
	//TRect convention is screen coords, not cartesian, so the properties
	// might look odd below:

	CopyRect(ChkArea,Area);
	Inc(ChkArea.Top);
	Inc(ChkArea.Bottom);
	//This trickiness is to accomodate for PtInRect Check later
	// If the Pt lies on Top, or Left are considered in the rectangle,
	// But not so if it lies ON Bottom or Right sides - so inflate sides by one,
	// to have it check the proper area.

	//Search each block that the Skill Attack Area covers, add all monsters
	//within that Area range, Add monsters in that Area to the Target List.
	for Y := (Area.Top) div 8 to (Area.Bottom) div 8 do begin
		for X := (Area.Left) div 8 to (Area.Right) div 8 do begin
			for MCnt := 0 to Chara.MData.Block[X,Y].Mob.Count - 1 do begin
				if (Chara.MData.Block[X,Y].Mob.Objects[MCnt] IS TMob) then begin
					AMob := Chara.MData.Block[X,Y].Mob.Objects[MCnt] AS TMob;

					case TargetChk of
					// CHK_NONE - skip
					CHK_SELF   :// Ensure TargetList doesn't include Chara
						begin
							if (Target IS TChara) AND ((Target AS TChara) = Chara) then begin
								Continue;
							end;
						end;
					CHK_TARGET :// Ensure TargetList doesn't include Primary Target
						begin
							if (Target IS TChara) AND ((Target AS TChara) = Chara) then begin
								Continue;
							end;
							if (Target IS TMob) AND ((Target AS TMob) = AMob) then begin
								Continue;
							end;
						end;
					CHK_GUARD  :// Ensure TargetList doesn't include GuildGuardians
						begin
						end;
					CHK_GUILD  :// Ensure TargetList doesn't include GuildMembers
						begin
						end;
					end;//case TargetChk
					{
					ChrstphrR -- there's several conditional checks that some of the
					routines bail out on.
					Listing them all here, so that a common routine can be written for
					all of them.


					//Don't add if main monster (TrgtPt = ts.Point?)
					if (ts = AMob) then begin
						Continue;
					end;

					//Don't add main monster (if the TrgtPt = ts.Point?)
					// Or if the monster is part of the guild the Character is in.
					if (ts = AMob) OR
					 ((AChara.GuildID > 0) AND (AMob.isGuardian = AChara.GuildID)) OR
					 ((AChara.GuildID > 0) AND (AMob.GID = AChara.GuildID)) then begin
						Continue;
					end;

					//Condtion(s) when Character is the target -- To be implemented yet...

					//NotSelf
					//NotTargetChara
					//NotYourGuildMember
					if (tc1 = tc2) OR (tc = tc2) OR
					 ((mi.PvPG = true) AND (tc.GuildID = tc2.GuildID) AND (tc.GuildID <> 0)) then begin
						Continue;
					end;
					}

					if PtInRect(ChkArea,AMob.Point) then begin
						TrgtList.AddObject(AMob.ID,AMob);
					end;
				end;
			end;
		end;
	end;
End;(* Proc FindTargetsInAttackRange()
*-----------------------------------------------------------------------------*)


end.


