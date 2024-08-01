unit PacketProcesses;

interface
uses
    {Windows VCL}
    {$IFDEF MSWINDOWS}
    ScktComp, //Windows, MMSystem, StdCtrls,  //Tsusai: are Windows, MMSystem, and StdCtrls even used here?
    {$ENDIF}
//    {Kylix/Delphi CLX}
//    {$IFDEF LINUX}
//    Types, QStdCtrls,
//    {$ENDIF}
    {Shared}
    Classes, SysUtils, Types,
    {Fusion}
	GlobalLists, Common, List32;

procedure SendSkillDamage(tm : TMap; skill_ID : integer; src_ID: cardinal; destination_ID : Cardinal; Tick : Cardinal; src_speed:integer; dst_speed:integer; param1:integer; param2:integer; param3:integer; Npc_type:byte; Point: TPoint);
procedure UpdateGroundEffect(tm : TMap; dst_ID:cardinal; src_ID:cardinal; Point:TPoint; Skill_Type:byte; fail:byte; Socket: TCustomWinSocket = nil);

implementation

procedure SendSkillDamage(tm : TMap; skill_ID : integer; src_ID: cardinal; destination_ID : Cardinal; Tick : Cardinal; src_speed:integer; dst_speed:integer; param1:integer; param2:integer; param3:integer; Npc_type:byte; Point: TPoint);
{R 01de <skill ID>.w <src ID>.l <dst ID>.l <server tick>.l <src speed>.l <dst speed>.l <param1>.l <param2>.w <param3>.w <type>.B

	Skill effect for an attack.  (Improved version of 0114.)
	type=04 Seen when using firewall.  About the same as type=06?
	type=05 Split-damage type seen with Napalm Beat/Fireball?
	type=06 Single-hit type?  param1 is total damage, param2 is level, param3 is 1.
	type=07 Damage without a display?
	type=08 Multiple-hit type?  param1 is total damage, param2 is level, param3 is number of hits.
	type=09 I thought it was for giving damage without the actual damage motion (Endure), but it made a damage motion.  (True function is unknown.)
}

begin
    WFIFOW( 0, $01de);
    WFIFOW( 2, skill_ID);
    WFIFOL( 4, src_ID);
    WFIFOL( 8, destination_ID);
    WFIFOL(12, Tick);
    WFIFOL(16, src_speed);
    WFIFOL(20, dst_speed);
    WFIFOL(24, param1);
    WFIFOW(28, param2);
    WFIFOW(30, param3);
    WFIFOB(32, Npc_Type);
    SendBCmd(tm, Point, 33);
end;

procedure UpdateGroundEffect(tm : TMap; dst_ID:cardinal; src_ID:cardinal; Point:TPoint; Skill_Type:byte; fail:byte; Socket: TCustomWinSocket = nil);
{
   R 01c9 <dst ID>.l <src ID>.l <X>.w <Y>.w <type>.B <fail>.B ?.81b

	Display a ground skill effect. (011f's improved version?)

	Types:

	7e: Safety Wall
	7f: Firewall
	80: Opened Warp Portal
	81: Opening Warp Portal
	82: B.S. Sacramenti
	83: Sanctuary
	84: Magnus Exorcismus
	85: Pneuma
	86: Large Magic Circle (SG/MS/LoV/GX (Grand Cross?))
	87: Fire Pillar (standby)
	88: Fire Pillar (activated)
	89-8b: No effect
	8c: Talkie Box (activated)
	8d: Ice Wall
	8e: Quagmire
	8f: Blast Mine
	90: Skid Trap
	91: Ankle Snare
	92: Venom Dust
	93: Land Mine
	94: Shockwave Trap
	95: Sandman
	96: Flasher
	97: Freezing Trap
	98: Claymore Trap
	99: Talkie Box (before activation)
	9a: Volcano
	9b: Deluge
	9c: Violent Gale
	9d: Land Protector
	9e: Zeny sign
	9f: Zeny bag (Mr. Kim, a Rich Man)
	a0: Turning green pillar
	a1: Pink music note (two types alternate, single and joined)
	a2: Ball of light with a point in the middle
	a3: Lavender spring, short
	a4: Gemstones (Into the Abyss)
	a5: Turning blue pillar
	a6: Dissonance (short yellow haze)
	a7: Whistle (single music note)
	a8: Assassin Cross of Sunset (tall red haze)
	a9: Poem of Bragi (arcane letters)
	aa: Apple of Idun (golden apples)
	ab: Selfish Dance (same effect as Dissonance)
	ac: Humming (joined musical notes)
	ad: Please Don't Forget Me... (tall green haze)
	ae: Service For You (hearts)
	af: Pink spring, tall
	b0: Graffiti (?)
	b1: Demonstration
	b2: Pink Warp Portal (active)
	b3: Small floating cross (Gospel)
	b4: 5x5 square of light (Basilica)
	b5: No effect?
	b6: Fog wall (X-shaped dark effect)
	b7: Spider Web
	b8-: No resource?

	Ground info request ?.81b is unkhown.
}
begin
    WFIFOW( 0, $011f);
    WFIFOL( 2, dst_ID);
    WFIFOL( 6, src_ID);
    WFIFOW(10, Point.X);
    WFIFOW(12, Point.Y);
    WFIFOB(14, Skill_Type);
    WFIFOB(15, fail);
    if tm <> nil then
        SendBCmd(tm, Point, 16)
    else Socket.SendBuf(buf, 16);
end;

end.
