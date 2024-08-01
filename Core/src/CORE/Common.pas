unit Common;



interface

uses
//Windows, Forms, Classes, SysUtils, ScktComp;
	Windows, StdCtrls, MMSystem, Classes, SysUtils, ScktComp,
	GlobalLists,
	List32;

const
	RELEASE_VERSION = '1.211 O';

	// Colus, 20040304: Let's see if this is truly global scope.
	MAX_SKILL_NUMBER = 411;
	MAX_JOB_NUMBER = 45;
	LOWER_JOB_END = 23;
	UPPER_JOB_BEGIN = 4000;
	MONSTER_ATK_RANGE = 9;

	MAX_PARTY_SIZE = 12;
    MAX_PACKET_NUMBER = $020B; // The highest packet number so far.

	//NPC CType Constants
	//Byte-sized ... Mmmmm-mmm!
	NPC_TYPE_WARP   = $00;
	NPC_TYPE_SHOP   = $01;
	NPC_TYPE_SCRIPT = $02;
	NPC_TYPE_ITEM   = $03;
	NPC_TYPE_SKILL  = $04;

  // Colus, 20040503: This is the default JID for invisible (non-displayed) NPCs.
	// callmob and SendNData will look for this.
  NPC_INVISIBLE = 32767;

	//ChrstphrR source: http://www.stud.ntnu.no/~magnusrk/calc/
	// Race Constants    (DamageFixR)
	RACE_FORMLESS  = 0;
	RACE_UNDEAD    = 1;
	RACE_BRUTE     = 2;
	RACE_PLANT     = 3;
	RACE_INSECT    = 4;
	RACE_FISH      = 5;
	RACE_DEMON     = 6;
	RACE_DEMIHUMAN = 7;
	RACE_ANGEL     = 8;
	RACE_DRAGON    = 9;
	
	// Element Constants (DamageFixE)
	ELE_NEUTRAL = 0;
	ELE_WATER   = 1; //Ice is water...
	ELE_EARTH   = 2;
	ELE_FIRE    = 3;
	ELE_WIND    = 4;
	ELE_POISON  = 5;
	ELE_HOLY    = 6;
	ELE_DARK    = 7;
	ELE_SENSE   = 8;
	ELE_UNDEAD  = 9;

	// Size Constants    (DamageFixS)
	SIZE_SML = 0;
	SIZE_MED = 1;
	SIZE_LRG = 2;

	//MapList Constants for Mode Field.
	MAP_NOTLOADED = 0;
	MAP_LOADING   = 1;
	MAP_LOADED    = 2;


type

TLivingType = ( imaCHARA, imaMOB, imaNPC );

TLiving = class
	public
		ID    : Cardinal;
		JID   : Word;
		Name  : string;
		Map   : string;
		Point : TPoint;
		ppos  : Integer;
		pcnt  : Integer;
		path  : array[0..999] of byte;
		Dir   : Byte;

		LType : TLivingType;
		//ChrstphrR 2004/06/01 -- Added to get rid of Pointer Types
		// The LType will determine what type of object AData etc
end;
//==============================================================================
// word型座標構造体(TPointはcardinal型座標)
type rPoint = record
	X :word;
	Y :word;
end;
//------------------------------------------------------------------------------
// ヒープ構造体(経路探索用)
type rHeap = record
	cost1   :word;
	cost2   :word;
	x       :word;
	y       :word;
	mx      :word;
	my      :word;
	dir     :byte;
	path    :array[0..255] of byte;
	pcnt    :byte;
end;
//------------------------------------------------------------------------------
// 経路探索用マップデータ
type rSearchMap = record
	cost : Word;
	path : array[0..255] of Byte;
	pcnt : Byte;
	addr : Byte;
end;
//------------------------------------------------------------------------------
{ Item Database
These objects are linked to either the ItemDB or ItemDBName lists, and referred
to by the Data reference in the actual instances of items in the game.
}
type TItemDB = class
	ID        :word;
	Name      :string;
	JName     :string;
	IType     :byte;
	IEquip    :boolean;
	Price     :cardinal;
	Sell      :cardinal;
	Weight    :word;
	ATK       :word;
	MATK      :word;
	DEF       :word;
	MDEF      :word;
	Range     :byte;
	Slot      :byte;
	Param     :array[0..5] of shortint;
	HIT       :smallint;
	FLEE      :smallint;
	Crit      :byte;
	Avoid     :byte;
	Cast      :cardinal;
	Job       :Int64;
	Gender    :byte;
	Loc       :word;
	wLV       :byte;
	eLV       :byte;
	View      :byte;
	Element   :byte;
	Effect    :byte;
	HP1       :word;
	HP2       :word;
	SP1       :word;
	SP2       :word;
	//Rare      :boolean;
	//Box       :byte;
{変更}
  // Colus, 20040130: Changing these to smallints for resistance purposes
	DamageFixR :array[0..9] of SmallInt; // Race mod
	DamageFixE :array[0..9] of SmallInt; // Element mod
	DamageFixS :array[0..2] of SmallInt; // Size mod
	SFixPer1   :array[0..5] of SmallInt; // Option 1 mod
	SFixPer2   :array[0..4] of SmallInt; // Option 2 mod
	DrainFix   :array[0..1] of SmallInt; // Drain amount
	DrainPer   :array[0..1] of SmallInt; // Drain chance
	AddSkill   :array[0..MAX_SKILL_NUMBER] of Word; // Skill addition
	SplashAttack  :boolean;          // Splash attack
	SpecialAttack :integer;
	{
	1 = Knockback
	2 = Fatal Blow, .1% chance of instantly killing monster
	}
	WeaponSkill   :integer;
	WeaponSkillLV :integer;
	WeaponID      :integer;
	NoJamstone    :boolean;

	FastWalk      :boolean;
	NoTarget      :boolean;
	FullRecover   :boolean;
	LessSP        :boolean;
	OrcReflect    :boolean;
	AnolianReflect :boolean;
	UnlimitedEndure :boolean;
	DoppelgagnerASPD :boolean;
	GhostArmor    :boolean;
	NoCastInterrupt :boolean;
	MagicReflect  :boolean;
	SkillWeapon   :boolean;
	GungnirEquipped :boolean;
	LVL4WeaponASPD :boolean;
	PerfectDamage   :boolean;

	public
		Procedure Assign(Source : TItemDB);
End;(* TItemDB *)


//------------------------------------------------------------------------------
// アイテムデータ
type TItem = class
	ID        : Word;
	Amount    : Word;
	Equip     : Word;
	Identify  : Byte;
	Refine    : Byte;
	Attr      : Byte;
	Card      : Array[0..3] of Word;
	Data      : TItemDB;
	Stolen    : Cardinal;

public
	Constructor Create;
	Destructor  Destroy; OverRide;

	Procedure ZeroItem;
end;//TItem
//------------------------------------------------------------------------------
{追加}
type TItemList = class
	Zeny      : Cardinal;
	Item      : array[1..100] of TItem;
	Weight    : Cardinal;
	MaxWeight : Cardinal;
	Count     : Word;

	Constructor Create;
	Destructor  Destroy; OverRide;
end;//TItemList
{追加ココまで}
//------------------------------------------------------------------------------
{アイテム製造追加}
// 製造データ
type TMaterialDB = class
	ID              :word;//製造アイテムのID
	ItemLV          :word;//製造に必要なスキルレベル(金槌との対応、リスト表示および成功率計算で使用)
	RequireSkill    :word;//製造に必要とされるスキル(金槌との対応、リスト表示および成功率計算で使用)
	MaterialID      :array[0..2] of word;//製造に必要な素材のID
	MaterialAmount  :array[0..2] of word;//製造に必要な素材の個数
end;
{アイテム製造追加ココまで}
//------------------------------------------------------------------------------

// モンスタードロップアイテム構造体
type rDropItem = record
	ID     : Word;
	Per    : Cardinal;
	Data   : TItemDB;
	Stolen : Cardinal;
end;
//------------------------------------------------------------------------------
// MapName, TerritoryName
type TTerritoryDB = class
	MapName       :ShortString;
	TerritoryName :ShortString;
end;

//------------------------------------------------------------------------------
type TMobAIDB = class
// ID,SKILL1,LEVEL1,PERCENT1,TYPE1,SKILL2,LEVEL2,PERCENT2,TYPE2,SKILL3,LEVEL3,PERCENT3,TYPE3,SKILL4,LEVEL4,PERCENT4,TYPE4
	ID            : Cardinal;
	Skill         : array[0..7] of integer;
	SkillLv       : array[0..7] of integer;
	PercentChance : array[0..7] of integer;
	//SkillType     : array[0..3] of integer;
end;
//------------------------------------------------------------------------------
type TMobAIDBFusion = class
// ID, Name,	STATUS	SKILL_ID	SKILL_LV	  PERCENT	 CASTING_TIME	  COOLDOWN_TIME		IF IfCondition
	ID        : cardinal;
	Number    : integer;
	Name      : string;
	Status    : string;
	SkillID   : string;
	SkillLV   : integer;
	Percent   : integer;
	//Casting   : integer;
	Cast_Time : integer;
	Cool_Time : integer;
	Dispel    : string;
	IfState   : string;
	IfCond    : string
end;
//------------------------------------------------------------------------------
type TGlobalVars = class
// Variable, Value
	Variable : String;
	Value    : Integer;
end;

// モンスターデータベース
//ID,Name,JName,LV,HP,EXP,JEXP,Range,ATK1,ATK2,DEF1,DEF2,MDEF1,MDEF2,HIT,FLEE,
//Scale,Race,Ele,Mode,Speed,ADelay,aMotion,dMotion,Drop1id,Drop1per,Drop2id,
//Drop2per,Drop3id,Drop3per,Drop4id,Drop4per,Drop5id,Drop5per,Drop6id,Drop6per,
//Drop7id,Drop7per,Drop8id,Drop8per,MEXP,MVP1id,MVP1per,MVP2id,MVP2per,MVP3id,MVP3per
type TMobDB = class
	ID          :word;
	Name        :string;
	JName       :string;
	LV          :byte;
	HP          :cardinal;
	SP          :cardinal; //New
	EXP         :cardinal;
	JEXP        :cardinal;
	Range1      :byte;
	ATK1        :word;
	ATK2        :word;
	DEF         :byte; //New
	MDEF        :byte; //New
	LUK         :byte; //クリ補正用LUK
	HIT         :integer;
	FLEE        :integer;
	Param       :array[0..5] of byte; //New
	Range2      :byte; //攻撃開始視界
	Range3      :byte; //追尾視界

	Scale       :byte;
	Race        :byte;
	Element     :byte;
	Mode        :byte;
	Speed       :word;
	ADelay      :word;
	aMotion     :word;
	dMotion     :word;
	Drop        :array[0..7] of rDropItem;
	Item1       :word; //New
	Item2       :word; //New
	MEXP        :cardinal;
	MEXPPer     :word;
	MVPItem     :array[0..2] of rDropItem;

	isDontMove  :boolean; //Mode &  1 : 移動
	isActive    :boolean; //Mode &  4 : アクティブ
{追加}
	isLoot      :boolean; //Mode &  2 : ルート
	isLink      :boolean; //Mode &  8 : リンク
	AISkill     :TMobAIDB;
	SkillLocations :string;  //Gives a list of where the monsters skills are located
	SkillCount  :integer;
	WaitTick :integer;
	Loaded  :boolean;
	DebugFlag :boolean;
{追加ココまで}
end;
//------------------------------------------------------------------------------
// MNAME,SLAVE_1,SLAVE_2,SLAVE_3,SLAVE_4,SLAVE_5,TOTALNUMSLAVES
type TSlaveDB = class
	Name        : string;
	Slaves      : array[0..4] of Integer;
	TotalSlaves : Integer;
end;
//------------------------------------------------------------------------------
// ID,BROADCAST,ITEMSUMMON,MONSTERSUMMON,CHANGESTATSKILL,CHANGEOPTION,SAVERETURN,CHANGELEVEL,WARP,WHOIS,GOTOSUMMONBANISH,KILLDIEALIVE,CHANGEJOB,CHANGECOLORSTYLE,AUTORAWUNIT,REFINE
type TIDTbl = class
	ID               :integer;
	BroadCast        :integer;
	ItemSummon       :integer;
	MonsterSummon    :integer;
	ChangeStatSkill  :integer;
	ChangeOption     :integer;
	SaveReturn       :integer;
	ChangeLevel      :integer;
	Warp             :integer;
	Whois            :integer;
	GotoSummonBanish :integer;
	KillDieAlive     :integer;
	ChangeJob        :integer;
	ChangeColorStyle :integer;
	AutoRawUnit      :integer;
	Refine           :integer;
	PVPControl       :integer;
	UserControl      :integer;
end;
//------------------------------------------------------------------------------
// ID,Create ID,Number Created
TMArrowDB = class
	ID   : Integer;
	CID  : array[0..2] of integer;
	CNum : array[0..2] of integer;
end;
//------------------------------------------------------------------------------
TWarpDatabase = class
	NAME:String;  //Name that player will type
	MAP :String;  //Name of the Actual Map
	X   :integer; //X Coordinate to warp to
	Y   :integer; //Y Coordinate to warp to
	Cost:integer; //Amount of zeny the warp takes
end;
//------------------------------------------------------------------------------
// 経験値配分用カウンタ

TChara = class; //Forward declaration.
rEXPDist = record
//	CData       :Pointer;
	CData       : TChara;
	Dmg         :integer;
end;

//------------------------------------------------------------------------------
// モンスターデータ
TMob = class(TLiving)
	tgtPoint    :TPoint;
	NextPoint   :TPoint;
	Point1      :TPoint;
	Point2      :TPoint;
	Speed       :word;
	Stat1       :Byte; // 1 = Stone, 2 = Freeze, 3 = Stun, 4 = Sleep, 5 = ankle snar
	Stat2       :Byte; // 1 = Poison, 2 = Curse, 4 = Silence, 8 = Chaos, 16 = Blind
	nStat       :Cardinal;
	BodyTick    :Cardinal;   // Status change tick1 (for Stat1)
	BodyCount   :byte; // Colus, 20040505: Counts hits for stat1 effects (current use, SG hitcount)
	HealthTick  :Array[0..4] of Cardinal;  // Status change tick2 (for Stat2 effects)
	EffectTick  :Array[0..11] of Cardinal; // Skill ticks (0 = Lex Aet, 1=Quagmire, 2=ME, 3=Sanct currently)
	isLooting   :boolean;
	Item        :array[1..10] of TItem;
	HP          :integer;
	SpawnDelay1 :cardinal;
	SpawnDelay2 :cardinal;
	SpawnTick   :cardinal;
	SpawnType   :cardinal;
	ATick       :cardinal;
	NextFlag      :boolean;
	MoveTick    :cardinal;
	MoveWait    :cardinal;
	DeadWait    :cardinal;// mf
	DmgTick     :cardinal; //ノックバック
	AMode       :byte;
	ATarget     :cardinal;
	AData       :Pointer;
	ARangeFlag  :boolean;
	MMode       :byte;
	ATKPer      :word; //プロボックなどによる攻撃力補正
	DEFPer      :word; //プロボックなどによる防御力補正
	EXPDist     :array[0..31] of rEXPDist; //経験値配分用カウンタ
	MVPDist     :array[0..31] of rEXPDist; //MVP判定用カウンタ
	Slaves      :Array[1..12] of Cardinal;
	Data        :TMobDB;
{追加}
	Element     :Byte;
	DEF1        :Byte;
	DEF2        :Byte;
	MDEF1       :Byte;
	MDEF2       :Byte;
	SlaveCount  :Byte;
	isSummon    :Boolean;
	isLeader    :boolean;
	isEmperium  :boolean;
	isGuardian  :Cardinal;
	isSlave     :boolean;
	isActive    :boolean; //Mode &  4 : アクティブ
	LeaderID    :Cardinal;
	EmperiumID  :Cardinal;
	GID         :Cardinal;
	NPCID       :Cardinal; //取り巻き用
{NPCイベント追加}
	Event       :cardinal;
	isCasting   :boolean;
	Stolen      :cardinal;

	Status  :string;  //Lists the monsters Current status
	MSkill  :integer;
	MLevel  :integer;

	Hidden     :boolean;
    Cloaked    :boolean;

	AnkleSnareTick : Cardinal;  //Tracks how long ankle snare lasts

	MPoint         : rPoint;
	MTick          : Cardinal;
	CastTime       : Integer;
	SkillWaitTick  : Cardinal;

	NowSkill        : Integer;
	NowSkillLv      : Integer;
	SkillSlot       : Integer;
//	AI              : Pointer;
	NoDispel        : Boolean;
	Mode            : Integer;
	Burned          : Boolean;
	SkillType       : Integer;
		// 1 = No target needed
		// 2 = Area Effect
		// 3 = Target Skill
		// 4 = Support skill
	CanFindTarget :boolean;

{NPCイベント追加ココまで}
	constructor Create;
	destructor Destroy; override;
{追加ココまで}
end;
//------------------------------------------------------------------------------
{Cute Pet Classes}
// Pet Database

(*=============================================================================*
TPetDB

--
Overview:
--
Represents the data that defines a pet's stats. This info is static,
determined by \database\pet_db.txt

ChrstphrR 2004/05/26 I'm trying to determine the ranges of the values allowed
for these values, so that the object safety checks itself.

At first look, translating the comments... the data seems odd - I'm going to
check into the DB and how it's loaded/used to see if the comments are
-accurate-

--
Revisions:
--
2004/05/26 v0.2 [ChrstphrR] - Initial 'import' of this class.
"/"/26 [ChrstphrR] - Translate SJIS comments to help explain class fields.
"/"/26 [ChrstphrR] - explicity private/protected/public sections in
 preparation for converting fields into properties with methods to keep ranges
 within values and/or direct SQL queries (once we learn the proper ranges).
*=============================================================================*)
TPetDB = class
private

protected

public
	MobID       : Word; // ID number
	ItemID      : Word; // Capture Item ID
	EggID       : Word; // Egg Item ID
	AcceID      : Word; // Accessory ID
	FoodID      : Word; // ItemID of Food Pet eats.
	Fullness    : Word; // Degree of Fullness (ChrstphrR - what's the range??)
	HungryDelay : Word; // Time delay in milliseconds per Hunger change.
	Hungry      : Word; // Intimacy gain when pet is REALLY hungry
	Full        : Word; // Intimacy reduction when pet is over-fed.
	Reserved    : Word; // Time that an intimacy increase lasts ???
	Die         : Word; // Degree of intimacy lost when owner dies
	Capture     : Word; // Basic Capture Ratio (0.1% units - 1000 = 100%)
	SkillTime   : Cardinal;  //Tracks how long a skill lasts

//	Constructor Create;
//	Destructor  Destroy; OverRide;
End;(* TPetDB ================================================================*)


(*=============================================================================*
TPet

--
Overview:
--
Represents the pets (as eggs, or fullgrown) that Characters own.
Links to the TPetDB for each species' particular characteristics.

--
Revisions:
--
2004/05/26 v0.2 [ChrstphrR] - Initial 'import' of this class.
"/"/26 [ChrstphrR] - Fullness now a property - range protected 0..100
*=============================================================================*)
TPet = class
private
	fFullness : Byte; // Range 0..100 (It's a percentage, in other words)
protected
	function  GetFullness : Byte;
	procedure SetFullness(Value : Byte);

public
	PlayerID      : Cardinal; // Account the pet is tied to
	CharaID       : Cardinal; // Actual Character that has pet.
	Cart          : Byte;
	Index         : Word;
	Incubated     : Byte;
	PetID         : Cardinal;
	JID           : Word;
	Name          : string;
	Renamed       : Byte; // 0 - default pet species name 1 - renamed(fixed)
	LV            : Word;
	Relation      : Integer; //. Level of intimacy? (Range 0..1000)
	//Fullness      : Integer; //. Level of Hunger/Fullness (Range 0..100)
	Accessory     : Word;
	Data          : TPetDB;
	isLooting     : Boolean;  //Tracks if the pet is looting
	ATarget       : Cardinal;  //Pets attacking target as well as looting
	Item          : array[1..25] of TItem;  //Items a pet is holding
	MobData       : TMobDB; //Reference to the Pet's Monster attributes.
	SkillTick     : Cardinal;  //Tracks when to use a skill
	SkillActivate : Boolean;  //Tracks if the skill is ready to be activated
	LastTick      : Cardinal;  //Used for tracking a minute
	Saved         : Byte;

	Constructor Create;
	Destructor  Destroy; OverRide;

	//Level of Hunger/Fullness - shown at 5 levels on client side, but
	// range is between 0..100%
	property Fullness : Byte
		read  GetFullness
		write SetFullness
		default 25; //Default Fullness level when pet first made.
	
End;(* TPet ==================================================================*)


{End of Cute Pet Classes}
//------------------------------------------------------------------------------
// スキルデータベース
//N,ID,JName,Type,MLV,SP1,2,3,4,5,6,7,8,9,10,HP,Cast,Lv+,AR,Ele,
//Dat1,2,3,4,5,6,7,8,9,10,Dat2,2,3,4,5,6,7,8,9,10,Req1,LV,Req2,LV,Req3,LV
TSkillDB = class
	ID         :word;
	IDC        :string;
	Name       :string;
	SType      :byte;
	MasterLV   :byte;
	SP         :array[1..10] of word;
	HP         :word;
	UseItem    :word; //消費アイテム 715=ツデロー,716=レッド,717=ブルー,他ItemIDの通り
	CastTime1  :integer; //Base
	CastTime2  :integer; //Lvごとの+
	CastTime3  :integer; //CastTime下限値
	Range      :byte;
	Element    :byte;
	Data1      :array[1..10] of integer;
	Data2      :array[1..10] of integer;
	Range2     :byte;
	Icon       :word;
	Job1        :array[0..MAX_JOB_NUMBER] of boolean;
	ReqSkill1   :array[0..9] of word;
	ReqLV1      :array[0..9] of word;
	Job2        :array[0..MAX_JOB_NUMBER] of boolean;
	ReqSkill2   :array[0..9] of word;
	ReqLV2      :array[0..9] of word;
end;//TSkillDB
//------------------------------------------------------------------------------
// スキルデータ
TSkill = class
	Lv          :word;
	Card        :boolean;
	Plag        :boolean;
	//Up        :byte;
	Tick        :cardinal; //時間制限有りのスキルのリミット
	EffectLV    :word;     //時間制限有りのスキルの効果LV
	Effect1     :integer;  //時間制限有りのスキルの効果データ1
	Data        :TSkillDB;
end;//TSkill

//------------------------------------------------------------------------------
// Character Data
TPlayer = class; //forward declaration - PData field in TChara
TNPC = class;    //forward declaration - PetNPC " " "
TMap = class;    //forward declaration - MData " " "

TChara = class(TLiving)
    private
    fFireWallCount : Byte;
    procedure SetFirewallCount( Value : Byte );
    public
	// Control Variables
	Socket        :TCustomWinSocket;
	PData         :TPlayer; // Reference back to owning TPlayer
	IP            :string;
	Login         :byte; // 0 = offline; 1 = loading; 2 = online

	// Data saved and loaded to/from chara.txt
	// Line 1:
	CID           :cardinal; //CRW - used with party members.
	Gender        :byte;

	BaseLV        :word;
	BaseEXP       :cardinal;
	StatusPoint   :word;
	JobLV         :word;
	JobEXP        :cardinal;
	SkillPoint    :word;
	PLv           :word;
	Plag          :word;
	Zeny          :cardinal;
	Stat1         :cardinal; // Status 1
	Stat2         :cardinal; // Status 2
	// Colus, 20040204:
	// Option is a word-length bitmask.  The bits are for the following
	// character status conditions:
	//
	// 01: Sight        02: Hide          04: Cloak         08: Cart 1
	// 16: Falcon       32: Peco          64: GM Hide       128: Cart 2
	// 256: Cart 3      512: Cart 4       1024: Cart 5      2048: Reverse Orcish
	// 4096: ?          8192: Ruwach      16384: Footsteps  32768: Cart 6?

	//  0000 | 0000 | 0000 | 0000
	//    R    OCCC   CPPF   CCHS
	//    w    r543   2Hel   1lig
	//    c    c       dcc    kdt
	//    h            eon     e
	//
	// OptionKeep is not necessary.  All options should be set up
	// using ands and ors to change the bitmask.
	//
	// Example: Cart check: if (Option and $0788);
	// Example: Hide check: if (Option and 2);
	// Example: Set peco on: tc.Option := tc.Option or 32;
	//Option        :cardinal;
	//Optionkeep    :cardinal;
	Option        :word;
	Hidden        :boolean;
	Paradise      :boolean;
	Karma         :cardinal;
	Manner        :cardinal;

	HP            :integer;
	MAXHP         :word;
	SP            :integer;
	MAXSP         :word;
{追加}
	MAXHPPer      :Word;
	MAXSPPer      :Word;
{追加ココまで}
	Speed         :word;
	Hair          :word;
	_2            :word;
	_3            :word;
	Weapon        :word;
	Shield        :word;
	Head1         :word;
	Head2         :word;
	Head3         :word;
	HairColor     :word;
	ClothesColor  :word;

	ParamBase     :array[0..5] of word;
	{
	STR           :byte;
	AGI           :byte;
	VIT           :byte;
	INT           :byte;
	DEX           :byte;
	LUK           :byte;
	}
	CharaNumber   :byte;
	_4            :word;

	//Map           :string;
	//Point         :TPoint;
	SaveMap       :string;
	SavePoint     :TPoint;
	MemoMap       :array[0..2] of string;
	MemoPoint     :array[0..2] of TPoint;

	// Line 2: Skills
	Skill         :array[0..MAX_SKILL_NUMBER] of TSkill;

	// Line 3: Items
	Item          :array[1..100] of TItem;
	// Line 4: Cart
	Cart          :TItemList;
	// Line 5: Variables
	Flag          :TStringList;

	//
	DefaultSpeed  :word;
	EquipJob      :Int64;
	BaseNextEXP   :cardinal;
	JobNextEXP    :cardinal;
	Weight        :cardinal;
	MaxWeight     :cardinal;
	// Changed bonus to smallint (signed words) to prevent negative stat crashes
	Bonus         :array[0..5] of SmallInt;
	Param         :array[0..5] of word;
	ParamUp       :array[0..5] of word;
	WeaponType    :array[0..1] of word; // Right(0), left(1) hand weapon types
	WeaponSprite  :array[0..1] of word; // Item IDs for wpn sprites. 0=rt., 1=lt.
{追加 - Weapon Levels}
	WeaponLv      :array[0..1] of word; // Weapon levels for right/left
{追加ココまで - Attackpower and Weapon Fixes}
	ArmsFix       :array[0..1] of word; // Right/left training (mastery?)
	ATK           :array[0..1] of array[0..5] of word; // Displayed ATK power
	ATKFix        :array[0..1] of array[0..2] of integer; // Weapon correction based on enemy size
{変更 - Damage Modifiers and Fixes}
	AttPower      :Word; // Attack power additions from cards, etc.
	DamageFixR    :array[0..1] of array[0..9] of Integer; //Race correction %: 0=weapon, 1=armor
	DamageFixE    :array[0..1] of array[0..9] of Integer; //Element correction %: 0=weapon, 1=armor
	DamageFixS    :array[0..2] of Integer;                //Size correction %: 0=S, 1=M, 2=L
{変更ココまで - Battle Stats?}
	DAPer         :integer; //DA発動確率
	DAFix         :integer; //DA発動時の2発合計攻撃力%
	Arrow         :word; //装備中の矢のID
	MATK1         :integer;
	MATK2         :integer;
	MATKFix       :integer;
	DEF1          :integer; // Defense Power %
	DEF2          :integer; // Defense Power - (VIT soak)
	DEF3          :integer; // Divine Protection
	MDEF1         :integer;
	MDEF2         :integer;
	HIT           :integer;
	FLEE1         :integer;
	FLEE2         :integer;
	FLEE3         :integer;
	Critical      :word;
	Lucky         :word;
	ASpeed        :word;
	Delay         :integer;
	ADelay        :word;
	aMotion       :word;
	dMotion       :word;
	MCastTimeFix  :byte; //詠唱時間補正%
	HPDelay       :array[0..3] of cardinal;
	SPDelay       :array[0..3] of cardinal;
{追加}
	HPDelayFix    :Integer;
	SPDelayFix    :Integer;
{追加ココまで}
	Range         :word;
	WElement      :array[0..1] of byte; // Weapon elements
	ArmorElement  :byte; // Armor element (from card or armor type)
	HPR           :word; //HP Recovery Rate
	SPR           :word; //SP Recovery Rate
{変更}
	DrainFix      :array[0..1] of Integer; //吸収量   0:HP 1:SP
	DrainPer      :array[0..1] of Integer; //吸収確率 0:HP 1:SP
	SplashAttack  :boolean;                //Causes an Area Attack
	SpecialAttack :integer;
	{
	1 = Knockback
	2 = Fatal Blow, .1% chance of instantly killing monster
	}
	KnockBackSuccess  : boolean;
	WeaponSkill       : integer;
	WeaponSkillLv :integer;
	WeaponID      :integer;
	NoJamstone    :boolean;
	NoTrap        :boolean;
	LessSP        :boolean;
	FastWalk      :boolean;
	NoTarget          : Boolean;
	FullRecover       : Boolean;
	OrcReflect        : Boolean;
	AnolianReflect    : Boolean;
	UnlimitedEndure   : Boolean;
	DoppelgagnerASPD  : Boolean;
	GhostArmor        : Boolean;
	NoCastInterrupt   : Boolean;
	MagicReflect      : Boolean;
	SkillWeapon       : Boolean;
	GungnirEquipped   : Boolean;
	LVL4WeaponASPD    : Boolean;
	PerfectDamage     : Boolean;
	PerfectHide       : Boolean;

	{Sage Effects}
	SageElementEffect : Boolean;

	//# ステ変用
	SFixPer1       :array[0..1] of array[0..4] of Integer; //変化確率%
	SFixPer2       :array[0..1] of array[0..4] of Integer;
	BodyTick       :Integer;                  //状態１用Tick
	HealthTick     :array[0..4] of Integer;   //状態２用Tick
{変更ココまで}
	//処理用変数
	ver2          :word;

	tmpMap        :string;
	tgtPoint      :TPoint; //移動先

	HPTick        :cardinal;
	SPTick        :cardinal;
	HPRTick       :cardinal;
	SPRTick       :cardinal;
	SkillTick     :cardinal; //次にスキルが切れるときのTick
	SkillTickID   :word; //次にどのスキルが切れるか

//	MData         :Pointer;
	MData         :TMap;//ref ChrstphrR - typed pointer, req. forward declaration
	NextFlag      :boolean;
	NextPoint     :TPoint;
	MoveTick      :cardinal;

	PartyName     :string; //これらはそのうちデータファイルから読むようにすること
	GuildName     :string;
	GuildID       :word;
	ClassName     :string;
{精錬NPC機能追加}
	EqLock        :Boolean; //精錬用装備ロック
{精錬NPC機能追加ココまで}
{チャットルーム機能追加}
	ChatRoomID    :cardinal; //チャットルームID
{チャットルーム機能追加ココまで}
{露店スキル追加}
	VenderID      :cardinal; //露店開設ID
{露店スキル追加ココまで}
{取引機能追加}
	DealingID     :cardinal; //取引中ID
	PreDealID     :cardinal; //取引希望ID
{取引機能追加ココまで}
{ギルド機能追加}
	GuildInv      :cardinal; //ギルド勧誘対象キャラ
	GuildPos      :byte; //ギルド職位インデックス
{ギルド機能追加ココまで}

	HeadDir       :word;
	Sit           :byte; // 0: moving 1: dead 2: sitting 3: standing
	AMode         :byte;
	//0: Not attacking  1: single attack  2: continuous attack  3: NPC dialog
	//4: Open Vending shop  5: Trade window
	ATarget       :cardinal; // ID of attacked target
	AData         :Pointer; // TNPC/TChara Data of attacked target
	ATick         :cardinal; // tick of next attack
	ScriptStep    :integer; // Step of NPC talk (script)
	DmgTick       :cardinal; // Knockback
	TargetedTick  :cardinal; //何匹に囲まれてるかのチェックの最終確認時のTick
	TargetedFix   :integer;  //敵に囲まれての回避率減少(1/10%)

	MMode         :byte;
	MSkill        :word;
	MUseLV        :word;
	MTarget       :cardinal;
	MTargetType   :byte; // Category of AData. 0 = mob, 1 = player.
	MPoint        :rPoint;
	MTick         :cardinal;
	SPAmount      :integer;         {Total amount of SP used by a skill}

	spiritSpheres :word;  // Spirit spheres per character.  Moved from global scope.

	TalkNPCID     :cardinal;
	UseItemID     :word;

{追加}
	ItemSkill     :Boolean;
	Auto          :Word; // 0:無し 1:攻撃 2:スキル 4:ルート 8:移動 16:追跡
	A_Skill       :Word;
	A_Lv          :Word;
	ActTick       :Cardinal;
{追加ココまで}
{キューペット}
//	PetData       :Pointer;
//	PetNPC        :Pointer;
	PetData       : TPet; //ChrstphrR 2004/04/21
	PetNPC        : TNPC; //typed pointers, requires forward declare

	PetMoveTick   :cardinal;
//	Crusader      :Pointer;
	Crusader      :TChara; //Reference ONLY to a Crusader for certain skills.
        Autocastactive :Boolean;
        noday         :Boolean;

        GraceTick     :Cardinal;  {Characters Grace period for not getting hit}

        AnkleSnareTick :cardinal; {How long a character is trapped in ankle snare}

        PassiveAttack :Boolean;   {Used for Skills like Grand Cross and Combo's}

        isCloaked     :Boolean;   {Says if Cloaking is Active}
        CloakTick     :Cardinal;  {Tracks For SP Usage on Cloak AND Hide}

        // Darkhelmet, I used this method so you can theoretically be poisoned
        // and cursed at the same time, even though graphics will only show one.
        PoisonTick    :Cardinal;  {Tracks how long a player is Poisoned}
        isPoisoned    :Boolean;   {Says if player is Poisoned}

        FreezeTick    :Cardinal;  {Tracks how long a player is Frozen for}
        isFrozen      :Boolean;   {Says if player is Frozen}

        isStoned      :boolean;   {Says if a player is Stoned}
        StoneTick     :Cardinal;   {Tracks the length of the curse}

        isBlind       :Boolean;   {Says if a player is blind}
        BlindTick     :Cardinal;  {Tracks how long a player is Blind}

        isSilenced    :Boolean;   {Says if a player is silenced}
        SilencedTick  :Cardinal;  {Tracks how long a player is silenced}

        intimidateActive:Boolean; {Sets intimidate Active}
        intimidateTick:cardinal;  {Used so you can delay before you intimidate}

        noHPRecovery  :Boolean;   {Player Cannot Recover HP}
        noSPRecovery  :Boolean;   {Player Cannot Recover SP}

        SPRedAmount   :integer;   {Amount SP Usage is Reduced by}

        SpellBroken   :boolean;   {Used For Spellbreaker}

        LastSong      :integer;   {Last Song a Bard Cast}
        LastSongLV    :integer;   {Level of last song a Bard Cast}
        InField       :boolean;   {Determine if a player is in a skill field}
        SongTick      :cardinal;   {Determines if Bard is Casting a Song}
        SPSongTick    :cardinal;  {For Decreasing SP when using Songs}
        StatRecalc    :boolean; {Used for the Sage skill free cast}
        //SkillOnBool         :Boolean; //boolean indicate skill duration for skills according to system time.

	constructor Create;
	destructor  Destroy; override;
  //procedures to get skilonbool and set skillonbool
  //procedure setSkillOnBool(temp:Boolean);
  //function getSkillOnBool:Boolean;
    property FireWallCount : Byte
    read   fFireWallCount
    write  SetFireWallCount;
end;
//------------------------------------------------------------------------------
// プレイヤーデータ
{ChrstphrR 2004/04/20 - no type before, in the same "type" block as the forward
declaration and TChara which points back to ... TPlayer here}
TPlayer = class
	Login         :byte; //0=オフライン 1=ログイン中
	ID	          :cardinal;
	IP            :string;
	Name          :string;
	Pass          :string;
	Gender        :byte;
	Mail          :string;
	Banned        :byte;
	CID           :array[0..8] of cardinal;
	CName         :array[0..8] of string;
	CData         :array[0..8] of TChara; //Reference pointers
	Kafra         :TItemList;//Owned

	LoginID1      :cardinal;
	LoginID2      :cardinal;
	ver2          :word;
	Saved         :byte;

	constructor Create;
	destructor  Destroy; override;
end;//TPlayer
//------------------------------------------------------------------------------


(*=============================================================================*
TParty

--
Overview:
--
Defines the basic data and function of a Party of Characters in the game.

No Constructor/Destructor Pair needed, because the fields/properties are
simple types.

--
Revisions:
--
2004/05/23 [ChrstphrR] - initial commenting of the class's purpose
2004/05/23 [ChrstphrR] - changing fields into properties, in preparation for
	SQL awareness in this object.

2004/05/31 [ChrstphrR] - Grouping fields into state information during gameplay
	and data that persists between sessions -- the latter become properties.
*=============================================================================*)
TParty = class
private
	fName        : String[24]; //24 characters max.
	fExpShare    : WordBool;
	fItemShare   : WordBool;

protected
	function  GetName : string;
	procedure SetName(Value : string);

public

//	EXPShare    : Word;//Experience sharing (0 = Not shared, 1 = Shared)
//	ITEMShare   : Word;//Item sharing       (0 = Not Shared, 1 = Shared)
	MemberID    : array[0..MAX_PARTY_SIZE-1] of Cardinal;//Character IDs
	Member      : array[0..MAX_PARTY_SIZE-1] of TChara;  //References

	{State Info that's only persistant while the server is running.}
	MinLV       : Word;//Lowest level in party (of whom are online)
	MaxLV       : Word;//Highest level in party (of whom are online)

	EXP         : Cardinal; //Used for EXP distribution to members after a kill
	JEXP        : Cardinal; // ditto, for JEXP
	PartyBard   : array[0..2] of TChara; {Tracks Who the Party's Bard is}
	PartyDancer : array[0..2] of TChara; {Tracks Who the Party's Dancer is}

	property Name : string //Party Name - must be unique
		read  GetName
		write SetName;

	//Semi-converted, need methods to work with SQL code.
	property ExpShare : WordBool
		read  fExpShare
		write fExpShare;
	property ItemShare : WordBool
		read  fItemShare
		write fItemShare;
End;(* <TClassName> ==========================================================*)


//------------------------------------------------------------------------------
TCastle = class
	Name        :string;
	GID         :word;
	GName       :string;
	GMName      :string;
	GKafra      :integer;
	EDegree     :cardinal;
	ETrigger    :integer;
	DDegree     :cardinal;
	DTrigger    :integer;
	GuardStatus :array [0..7] of integer;
end;
//------------------------------------------------------------------------------
TEmp = class
	Map    :string;
	EID    :cardinal;
end;
//------------------------------------------------------------------------------
// 店売りアイテム
TShopItem = class
	ID    :word;
	Price :cardinal;
	Data  :TItemDB;//reference
end;
//------------------------------------------------------------------------------
// NPCスクリプト
rScript = record
	ID      :word; //コマンドID
	Data1   :array of string;
	Data2   :array of string;
	Data3   :array of integer;
	DataCnt :cardinal;
end;
//------------------------------------------------------------------------------
// NPCデータ

(*=============================================================================*
TNPC

--
Overview:
--
Derived from TLiving (this change made by Colus, for the common attributes
for NPC, Mob, and Chara objects.

ChrstphrR - question for other devs -- What does an NPC represent?
Just the Kafra babes, and townsfolk?  Can it represent NPC associated monsters,
like the one in Prontera?  My description here bites, so someone feel free to
expand on what the class -represents-

*=============================================================================*)
TNPC = class(TLiving)
public
	Reg         :string;
	CType       :byte; //0=warp 1=shop 2=script 3=item 4=skill
	//warp
	WarpSize    :TPoint;
	WarpMap     :string;
	WarpPoint   :TPoint;
	//shop
	ShopItem    :array of TShopItem;
	//script
	Script      :array of rScript;
	ScriptCnt   :integer;
	ScriptLabel :string;

{NPCイベント追加}
	ScriptInitS  :integer; //OnInitステップ
	ScriptInitD  :Boolean; //OnInit実行済フラグ
	ScriptInitMS :integer;

	ChatRoomID  :cardinal; //チャットルームID
	Enable      :Boolean; //有効スイッチ
{アジト機能追加}
	Agit        :string; //エンブレム表示用
{アジト機能追加ココまで}
{NPCイベント追加ココまで}
	//item
	Item        :TItem; //owned.
	SubX        :byte;
	SubY        :byte;
	Tick        :cardinal;
	//skill
	Count       :word;
	CData       :TChara; //ref
	MData       :TMob;   //ref
{追加}
	MSkill      :Word;
{追加ココまで}
	MUseLV      :word;
{キューペット}
	//pet
	HungryTick  :cardinal;
	NextPoint   :TPoint;
	MoveTick    :cardinal;

	Constructor Create;
	Destructor  Destroy; OverRide;

End;(* TNPC
*=============================================================================*)


//------------------------------------------------------------------------------
{NPCイベント追加}
// タイマーデータ
NTimer = class
	ID        :cardinal;//タイマーID
	Tick      :cardinal;//タイマー
	Cnt       :word;//タイマーインデックス数
	Idx       :array of integer;//インデックス
	Step      :array of integer;//分岐先
	Done      :array of byte;//実行済みフラグ
public
	Constructor Create;
	Destructor  Destroy; OverRide;
end;
//マップ設定データ
MapTbl = class
	noMemo    :Boolean;
	noSave    :Boolean;
{アジト機能追加}
	noPortal  :Boolean;
	noFly     :Boolean;
	noBfly    :Boolean;
	noBranch  :Boolean;
	noSkill   :Boolean;
	noItem    :Boolean;
	Agit      :Boolean;
{アジト機能追加ココまで}
	noTele    :Boolean;
	PvP       :Boolean;
	PvPG      :Boolean;
	noDay     :Boolean;
  //Capture the flag w00t, heh
  CTF       :Boolean;
end;
{NPCイベント追加ココまで}
//------------------------------------------------------------------------------
// マップブロックデータ
TBlock = class
	NPC         :TIntList32;//Reference list
	Mob         :TIntList32;//Reference list
	CList       :TIntList32;//Reference list
	//MobProcess  :boolean;
	MobProcTick :cardinal;

	Constructor Create;
	Destructor Destroy; OverRide;
end;//TBlock
//------------------------------------------------------------------------------
// マップデータ
TMap = class
	Name      :string;
	Size      :TPoint;
	gat       :array of array of byte; //bit1=移動可能 bit2=水たまり bit3=Warp
	BlockSize :TPoint;
	Block     :array[-3..67] of array[-3..67] of TBlock; // 512/8=64 0-3~(64-1)+3
	NPC       :TIntList32;
	NPCLabel	:TStringList;
	CList     :TIntList32;
	Mob       :TIntList32;
	Mode      :byte; // 0 = not loaded, 1 = loading, 2 = load complete
{NPCイベント追加}
	TimerAct  :TIntList32; //動作中タイマー
	TimerDef  :TIntList32; //定義済タイマー
{NPCイベント追加ココまで}

	constructor Create;
	destructor Destroy; override;
end;//TMap
//------------------------------------------------------------------------------
// マップリストデータ
type TMapList = class
	Name      :string;
	Ext       :string;
	Size      :TPoint;
	Mode      :byte; // 0 = not loaded, 1 = loading, 2 = load complete
end;
//------------------------------------------------------------------------------
// 経路探索用構造体
type rPath = record
	x       :Integer;
	y       :Integer;
	dist    :integer;
	dir     :integer;
	before  :integer;
	cost    :integer;
end;
//------------------------------------------------------------------------------
{チャットルーム機能追加}
// チャットルームデータ
type TChatRoom = class
	ID        :cardinal;//チャットルームID
	Title     :string;//チャットルームタイトル
	Limit     :word;//最大人数
	Users     :word;//入室人数
	Pub       :Byte;//公開or非公開
	Pass      :string;//パスワード
	MemberID  :array[0..20] of cardinal;//メンバーのID
	MemberCID :array[0..20] of cardinal;//メンバーのCID
	MemberName :array[0..20] of string;//メンバーの名前
	KickList   :TIntList32;//kickユーザーリスト
{NPCイベント追加}
	NPCowner  :Byte;
{NPCイベント追加ココまで}

	constructor Create;
	destructor Destroy; override;
end;
{チャットルーム機能追加ココまで}
//------------------------------------------------------------------------------
{露店スキル追加}
// 露店開設データ
type TVender = class
	ID        :cardinal;//オーナーID
	CID       :cardinal;//オーナーCID
	Title     :string;//露店タイトル
	Cnt       :word;//露店残りアイテム数
	MaxCnt    :word;//露店最大アイテム数
	Idx       :array[0..12] of word;//アイテムインデックス
	Price     :array[0..12] of cardinal;//価格
	Amount    :array[0..12] of word;//数量
	Weight    :array[0..12] of word;//重量
end;
{露店スキル追加ココまで}
//------------------------------------------------------------------------------
{取引機能追加}
type TDealings = class
	ID        :cardinal;//取引ID
	UserID    :array[0..2] of cardinal;//アカウントID
	Cnt       :array[0..2] of word;//アイテム数
	Zeny      :array[0..2] of cardinal;//ゼニー
	ItemIdx   :array[0..2] of array[0..10] of word;//アイテムインデックス
	Amount    :array[0..2] of array[0..10] of cardinal;//数量
	Mode      :array[0..2] of Byte;//進行状況
end;
{取引機能追加ココまで}
//------------------------------------------------------------------------------
{ギルド機能追加}
// ギルドデータ
type TGuild = class
	ID           :Cardinal;//ID
	Name         :string;//名前
	LV           :word;//レベル
	EXP          :Cardinal;//経験値
	NextEXP      :Cardinal;//レベルアップ経験値
	MasterName   :string;//ギルドマスターの名前
	RegUsers     :word;//登録者数
	MaxUsers     :word;//定員
	SLV          :word;//メンバーのレベルの合計
	MemberID     :array[0..36] of cardinal;//メンバーID
	Member       :array[0..36] of TChara;//メンバー
	MemberPos    :array[0..36] of Byte;//メンバー職位
	MemberEXP    :array[0..36] of cardinal;//上納経験値
	PosName      :array[0..20] of string;//職位名
	PosInvite    :array[0..20] of boolean;//加入権限
	PosPunish    :array[0..20] of boolean;//処罰権限
	PosEXP       :array[0..20] of byte;//EXP上納%
	Notice       :array[0..2] of string;//告知
	Agit         :string;//管理領地
	Emblem       :Cardinal;//エンブレム
	GSkill       :array[10000..10005] of TSkill;
	GSkillPoint  :word;//スキルポイント
	Present      :Cardinal;//上納ポイント
	DisposFV     :integer;//性向F-V
	DisposRW     :integer;//性向R-W
	GuildBanList :TStringList;//追放者リスト
	RelAlliance  :TStringList;//同盟ギルドリスト
	RelHostility :TStringList;//敵対ギルドリスト

	constructor Create;
	destructor  Destroy; override;
end;//TGuild
//------------------------------------------------------------------------------
type TGBan = class
// ギルド追放者データ
	Name    :string;//キャラ名
	AccName :string;//アカウント名
	Reason  :string;//追放事由
end;
//------------------------------------------------------------------------------
type TGRel = class
// 同盟・敵対ギルドデータ
	ID        :Cardinal;//ギルドID
	GuildName :string;//同盟・敵対ギルド名
end;
{ギルド機能追加ココまで}
//------------------------------------------------------------------------------
// 定数
const
	CodeVersion = 'Fusion 1.2.1.2';
	PacketLength:array[0..MAX_PACKET_NUMBER] of integer = (
// +0  +1  +2  +3  +4  +5  +6  +7   +8  +9  +a  +b  +c  +d  +e  +f
	 10,  0,  0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0, // 0x0000
		0,  0,  0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0, // 0x0010
		0,  0,  0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0, // 0x0020
		0,  0,  0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0, // 0x0030

		0,  0,  0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0, // 0x0040
		0,  0,  0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0, // 0x0050
		0,  0,  0,  0, 55, 17,  3, 37,  46, -1, 23, -1,  3,108,  3,  2, // 0x0060
    3, 28, 19, 11,  3, -1,  9,  5,  54, 53, 58, 60, 41,  2,  6,  6, // 0x0070

		7,  3,  2,  2,  2,  5, 16, 12,  10,  7, 29, 23, -1, -1, -1,  0, // 0x0080
		7, 22, 28,  2,  6, 30, -1, -1,   3, -1, -1,  5,  9, 17, 17,  6, // 0x0090
	 23,  6,  6, -1, -1, -1, -1,  8,   7,  6,  7,  4,  7,  0, -1,  6, // 0x00a0
		8,  8,  3,  3, -1,  6,  6, -1,   7,  6,  2,  5,  6, 44,  5,  3, // 0x00b0

		7,  2,  6,  8,  6,  7, -1, -1,  -1, -1,  3,  3,  6,  3,  2, 27, // 0x00c0
		3,  4,  4,  2, -1, -1,  3, -1,   6, 14,  3, -1, 28, 29, -1, -1, // 0x00d0
	 30, 30, 26,  2,  6, 26,  3,  3,   8, 19,  5,  2,  3,  2,  2,  2, // 0x00e0
		3,  2,  6,  8, 21,  8,  8,  2,   2, 26,  3, -1,  6, 27, 30, 10, // 0x00f0


		2,  6,  6, 30, 79, 31, 10, 10,  -1, -1,  4,  6,  6,  2, 11, -1, // 0x0100
	 10, 39,  4, 10, 31, 35, 10, 18,   2, 13, 15, 20, 68,  2,  3, 16, // 0x0110
		6, 14, -1, -1, 21,  8,  8,  8,   8,  8,  2,  2,  3,  4,  2, -1, // 0x0120
		6, 86,  6, -1, -1,  7, -1,  6,   3, 16,  4,  4,  4,  6, 24, 26, // 0x0130

	 22, 14,  6, 10, 23, 19,  6, 39,   8,  9,  6, 27, -1,  2,  6,  6, // 0x0140
	110,  6, -1, -1, -1, -1, -1,  6,  -1, 54, 66, 54, 90, 42,  6, 42, // 0x0150
	 -1, -1, -1, -1, -1, 30, -1,  3,  14,  3, 30, 10, 43, 14,186,182, // 0x0160
	 14, 30, 10,  3, -1,  6,106, -1,   4,  5,  4, -1,  6,  7, -1, -1, // 0x0170

		6,  3,106, 10, 10, 34,  0,  6,   8,  4,  4,  4, 29, -1, 10,  6, // 0x0180
	 90, 86, 24,  6, 30,102,  9,  4,   8,  4, 14, 10,  4,  6,  2,  6, // 0x0190
		3,  3, 35,  5, 11, 26, -1,  4,   4,  6, 10, 12,  6, -1,  4,  4, // 0x01a0
   11,  7, -1, 67, 12, 18, 114, 6,   3,  6, 26, 26, 26, 26,  2,  3, // 0x01b0

    2, 14, 10, -1, 22, 22,  4,  2,  13, 97,  0,  9,  9, 29,  6, 28, // 0x01c0
    8, 14, 10, 35,  6,  8,  4, 11,  54, 53, 60,  2, -1, 47, 33,  6, // 0x01d0
   30,  8, 34, 14,  2,  6, 26,  2,  28, 81,  6, 10, 26,  2, -1, -1, // 0x01e0
   -1, -1, 20, 10, 32,  9, 34, 14,   2,  6, 48, 56, -1,  4,  5, 10, // 0x01f0

   26,  0,  0,  0, 18,  0,  0,  0,   0,  0,  0, 19 // 0x0200

		);
//------------------------------------------------------------------------------
// 変数
var
	AppPath              :string;

	ServerIP             :cardinal;
	ServerName           :string;
	DefaultNPCID         :cardinal;
	sv1port              :word;
	sv2port              :word;
	sv3port              :word;
	WarpDebugFlag        :boolean;
	BaseExpMultiplier    :cardinal;
	JobExpMultiplier     :cardinal;
	DisableMonsterActive   :boolean;
	AutoStart              :boolean;
	DisableLevelLimit      :boolean;
  DefaultZeny            :cardinal;
  DefaultMap             :string;
  DefaultPoint_X         :cardinal;
  DefaultPoint_Y         :cardinal;
  DefaultItem1           :cardinal;
  DefaultItem2           :cardinal;
	EnableMonsterKnockBack :boolean;
	DisableEquipLimit      :boolean;
	ItemDropType           :boolean;
	ItemDropDenominator    :integer;
  ItemDropMultiplier     :integer;
	ItemDropPer            :integer;
  StealMultiplier        :integer;
  EnablePetSkills        :boolean;
  EnableMonsterSkills    :boolean;
  EnableLowerClassDyes   :boolean;
	DisableFleeDown        :boolean;
	DisableSkillLimit      :boolean;
  Timer                  :boolean;

	FormLeft:integer;
	FormTop:integer;
	FormWidth:integer;
	FormHeight:integer;

	ScriptList :TStringList;

{アイテム製造追加}
	MaterialDB :TIntList32;
{アイテム製造追加ココまで}
{パーティー機能追加}
	PartyNameList	:TStringList;
  CastleList    :TStringList;
  TerritoryList :TStringList;
  EmpList       :TStringList;
{パーティー機能追加ココまで}
{キューペット}
	PetDB      :TIntList32;
        PetList    :TIntList32;
{キューペットここまで}
{チャットルーム機能追加}
	ChatRoomList :TIntList32;
	ChatMaxID  : cardinal;
{チャットルーム機能追加ココまで}
{露店スキル追加}
	VenderList :TIntList32;
{露店スキル追加ココまで}
{取引機能追加}
	DealingList :TIntList32;
	DealMaxID  :cardinal;
{取引機能追加ココまで}

	{ChrstphrR 2004/04/19 - Changing SummonMobList for size/algorithm
	improvements}
	SummonMobList : TSummonMobList;
	SummonMobListMVP : TStringList; //Changed for ease of use/cleanup.
	SummonIOBList    : TStringList; //Changed " " " "/"
	SummonIOVList    : TStringList; //Changed " " " "/"
	SummonICAList    : TStringList; //Changed " " " "/"
	SummonIGBList    : TStringList; //Changed " " " "/"
	SummonIOWBList   : TStringList; //Changed " " " "/"

{NPCイベント追加}
	ServerFlag :TStringList;
	MapInfo    :TStringList;
{NPCイベント追加ココまで}
{ギルド機能追加}
	GuildList     :TIntList32;
	NowGuildID    :cardinal;
	GSkillDB      :TIntList32;
	GExpTable     :array[0..50] of cardinal;
{ギルド機能追加ココまで}
	//Item     :TStringList;
	ItemDB     :TIntList32;
	ItemDBName :TStringList;
	MobDB      :TIntList32;
	MobDBName  :TStringList;
        {Monster Skill Database}
        MobAIDB    :TIntList32;
        //MobAIDBAegis:TStringList;
        MobAIDBFusion:TIntList32;
        GlobalVars:TStringList;
        //PharmacyDB :TIntList32;
  SlaveDBName:TStringList;
  MArrowDB   :TIntList32;
  WarpDatabase:TStringList;
  IDTableDB  :TIntList32;
	SkillDB    :TIntList32;
  SkillDBName:TStringlist;
	Player     :TIntList32;
	PlayerName :TStringList;
	Chara      :TIntList32;
	CharaName  :TStringList;
	CharaPID   :TIntList32;
	Map        :TStringList;
	MapList    :TStringList;

	//NowAccountID :cardinal;
	NowUsers      :word;
	NowLoginID    :cardinal;
	NowCharaID    :cardinal;
	NowNPCID      :cardinal;
	NowItemID     :cardinal;
	NowMobID      :cardinal;
{キューペット}
	NowPetID      :cardinal;
{キューペットここまで}

	DebugCnt      :word;
	id1           :cardinal;
	id2           :cardinal;
	CancelFlag    :boolean;
	ServerRunning :boolean;

	DebugOut      :TMemo;

	ShowDebugErrors : Boolean;
	{ChrstphrR - added 2004/05/09 for Debug messages for Script validation}


	//exp_db
	ExpTable        :array[0..3] of array[0..255] of cardinal;
	//job_db1
	WeightTable     :array[0..MAX_JOB_NUMBER] of word;
	HPTable         :array[0..MAX_JOB_NUMBER] of word;
	SPTable         :array[0..MAX_JOB_NUMBER] of word;
	WeaponASPDTable :array[0..MAX_JOB_NUMBER] of array[0..16] of word;
	//job_db2
	JobBonusTable   :array[0..MAX_JOB_NUMBER] of array[1..255] of byte;
	//wp_db
	WeaponTypeTable :array[0..2] of array[0..16] of word;
	//ele_db
	ElementTable    :array[0..9] of array[0..99] of integer;

	mm              :array[0..60] of array[0..60] of rSearchMap;

	buf             :array[0..32767] of byte;
//  buf2            :array[0..32767] of byte;{ChrstphrR 2004/04/24 - not used!}
	stra            :array[0..32767] of char;
{Things related to Options}
	//キャラクター初期データ関連
	WarpEnabled :boolean;
	WarpItem    :cardinal;
  StartDeathDropItem  :cardinal;
  EndDeathDropItem    :cardinal;
  TokenDrop       :boolean;
	GMCheck         :cardinal; // Can the GM commands be used by non-GM's?
	DebugCMD        :cardinal; // Can use Debug Commands?
	DeathBaseLoss     :integer;
	DeathJobLoss      :integer;
	MonsterMob        :boolean;
	SummonMonsterExp  :boolean;
	SummonMonsterAgo  :boolean;
	SummonMonsterName :boolean;
	SummonMonsterMob  :boolean;
	GlobalGMsg        :string;
	MapGMsg           :string;
{Things related to Options}

// Fusion SQL Declarations
UseSQL            :Boolean;
DbHost            :String;
DbUser            :String;
DbPass            :String;
DbName            :String;
// Fusion SQL Declarations

// Fusion INI Declarations
Option_PVP        :boolean;
Option_PVP_Steal  :boolean;
Option_PartyShare_Level :word;
Option_PVP_XPLoss :boolean;

Option_MaxUsers   :word;
Option_AutoSave   :word;
Option_AutoBackup   :word;
Option_WelcomeMsg :boolean;

Option_MOTD        : Boolean;//Master MOTD option
Option_MOTD_Athena : Boolean;//Allows Athena-style MOTD message
Option_MOTD_File   : string; //File for reading MOTD entries
// If Athena style is chosen, the limit on the text is 1 line vs 4 without.

Option_GM_Logs     :Boolean;

Option_Pet_Capture_Rate :word;
Option_GraceTime  :cardinal;
Option_GraceTime_PvPG :cardinal;
Option_Username_MF : boolean;
Option_Back_Color : string;
Option_Font_Color : string;
Option_Font_Size : integer;
Option_Font_Face : string;
Option_Font_Style : string;
// Fusion INI Declarations


//------------------------------------------------------------------------------
// 関数定義
		procedure MapLoad(MapName:string);
		Function  ScriptValidated(MapName : string; FileName : string; Tick : Cardinal) : Boolean;
		procedure MapMove(Socket:TCustomWinSocket; MapName:string; Point:TPoint);
//------------------------------------------------------------------------------
		procedure RFIFOB(index:word; var b:byte);
		procedure RFIFOW(index:word; var w:word);
		procedure RFIFOL(index:word; var l:cardinal);
		function  RFIFOS(index:word; cnt:word):string;
		procedure RFIFOM1(index:word; var xy:TPoint);
		procedure RFIFOM2(index:word; var xy1:TPoint; var xy2:TPoint);
		procedure WFIFOB(index:word; b:byte);
		procedure WFIFOW(index:word; w:word);
		procedure WFIFOL(index:word; l:cardinal);
		procedure WFIFOS(index:word; str:string; cnt:word);
		procedure WFIFOM1(index:word; xy:TPoint; Dir:byte = 0);
		procedure WFIFOM2(index:word; xy1:TPoint; xy2:TPoint);
//------------------------------------------------------------------------------
		procedure PickUpItem(tc:TChara; l:Cardinal);

		procedure CalcAbility(tc:TChara; td:TItemDB; o:Integer = 0);
		procedure CalcEquip(tc:TChara);
		procedure CalcSkill(tc:TChara; Tick:cardinal);
		procedure CalcStat(tc:TChara; Tick:cardinal = 0);

                {Bard Calculations}
                procedure CalcSongSkill(tc:TChara; Tick:cardinal = 0);
                procedure CalcSongStat(tc:TChara; Tick:cardinal = 0);

                {Sage Calculations}
                procedure CalcSageSkill(tc:TChara; Tick:cardinal = 0);

		procedure CalcLvUP(tc1:TChara; EXP:cardinal; JEXP:cardinal);

		procedure SendCGetItem(tc:TChara; Index:word; Amount:word);
		procedure SendCStat(tc:TChara; View:boolean = false);
		procedure SendCStat1(tc:TChara; Mode:word; DType:word; Value:cardinal);
		procedure SendCStoreList(tc:TChara);
		procedure SendCSkillList(tc:TChara);
		procedure SendCData(tc1:TChara; tc:TChara; Use0079:boolean = false);
		procedure SendCMove(Socket: TCustomWinSocket; tc:TChara; before, after:TPoint);
		procedure SendCLeave(tc:TChara; mode:byte);
		procedure SendBCmd(tm:TMap; Point:TPoint; PacketLen:word; tc:TChara = nil; tail:boolean = False);

    procedure SendCAttack1(tc:TChara; dmg0:integer; dmg1:integer; dmg4:integer; dmg5:integer; tm:TMap; ts:TMob; Tick:cardinal);
    procedure SendMAttack(tm:TMap; ts:TMob; tc:TChara; dmg0:integer; dmg4:integer; dmg5:integer; Tick:cardinal);

		procedure SendItemSkill(tc:TChara; s:Cardinal; L:Cardinal = 1);
		procedure SendSkillError(tc:TChara; EType:byte; BType:word = 0);
                procedure SendItemError(tc:TChara; Code:Cardinal);
		function  UseFieldSkill(tc:TChara; Tick:Cardinal) : Integer;
		function  UseTargetSkill(tc:TChara; Tick:Cardinal) : Integer;

		procedure SendCSkillAtk1(tm:TMap; tc:TChara; ts:TMob; Tick:cardinal; dmg:Integer; k:byte; PType:byte = 0);
                procedure SendCSkillAtk2(tm:TMap; tc:TChara; tc1:TChara; Tick:cardinal; dmg:Integer; k:byte; PType:byte = 0);

		procedure CalcSkillTick(tm:TMap; tc:TChara; Tick:cardinal = 0);

    procedure CharaDie(tm:TMap; tc:TChara; Tick:Cardinal; KilledByP:short = 0);
    procedure ItemDrop(tm:TMap; tc:TChara; j:integer; amount:integer);
    procedure CreateGroundItem(tm:TMap; itemID:cardinal; XPoint:cardinal; YPoint:cardinal);
                procedure UpdateStatus(tm:TMap; tc:TChara; Tick:Cardinal);
                procedure UpdateOption(tm:TMap; tc:TChara);
                procedure UpdateIcon(tm:TMap; tc:TChara; icon:word; active:byte = 1);
                procedure SilenceCharacter(tm:TMap; tc:TChara; Tick:Cardinal);
                procedure IntimidateWarp(tm:TMap; tc:TChara);

                procedure UpdateMonsterDead(tm:TMap; ts:TMob; k:integer);   //Kills a monster
				procedure UpdatePetLocation(tm:TMap; tn:TNPC);  //Update the location of a pet
                procedure SendPetRelocation(tm:TMap; tc:TChara; i:integer); //Move a pet
                procedure SendMonsterRelocation(tm:TMap; ts:tMob); //Move a monster
                procedure UpdateMonsterLocation(tm:TMap; ts:TMob);  //Update the location of a monster
                procedure UpdatePlayerLocation(tm:TMap; tc:TChara);  //Update the location of a Player
                procedure UpdateLivingLocation(tm:TMap; tv:TLiving);  //Update the location of a Player

                procedure  PetSkills(tc: TChara; Tick:cardinal);  //Calculate the Pets Skills

                procedure  Monkdelay(tm:TMap; tc:TChara; Delay:integer);

		Procedure UpdateSpiritSpheres(tm:TMap; tc:TChara; spiritSpheres:integer);
		function  DecSP(tc:TChara; SkillID:word; LV:byte) :boolean;
                function  UseItem(tc:TChara; j:integer): boolean;
                function  UseUsableItem(tc:TChara; w:integer) :boolean;
                function  UpdateWeight(tc:TChara; j:integer; td:TItemDB)  :boolean;
                function  GetMVPItem(tc1:TChara; ts:TMob; mvpitem:boolean) :boolean;
                function  StealItem(tc:TChara) :boolean;

    procedure SendLivingDisappear(tm:TMap; tv:TLiving; mode: byte = 0); // Make a Living disappear

		function  SearchCInventory(tc:TChara; ItemID:word; IEquip:boolean):word;
		function  SearchPInventory(tc:TChara; ItemID:word; IEquip:boolean):word;
//------------------------------------------------------------------------------
		//モンス・NPC
		procedure SendMData(Socket:TCustomWinSocket; ts:TMob; Use0079:boolean = false);
		procedure SendMMove(Socket: TCustomWinSocket; ts:TMob; before, after:TPoint; ver2:Word);
    procedure SendNData(Socket:TCustomWinSocket; tn:TNPC; ver2:Word; Use0079:boolean = false);
{キューペット}
                procedure SendPetMove(Socket: TCustomWinSocket; tc:TChara; target:TPoint);
{キューペットここまで}
//------------------------------------------------------------------------------
    //地点スキル
		function  SetSkillUnit(tm:TMap; ID:cardinal; xy:TPoint; Tick:cardinal; SType:word; SCount:word; STime:cardinal; tc:TChara = nil; ts:TMob = nil; SText:string = ''):TNPC;
		procedure DelSkillUnit(tm:TMap; tn:TNPC; tc:TChara);
//------------------------------------------------------------------------------
    //所持アイテム
		Function  MoveItem(
                Dest    : TItemList;
                Source  : TitemList;
                Index   : Word;
                Quant   : Word
              ) : Integer;
		function  GetItemStore(
                AList   : TItemList;
                AnItem  : TItem;
                Quant   : Word;
                IsEquip : Boolean = False
              ) : Integer;
		function  DeleteItem(
                AList : TItemList;
                Index : Word;
                Quant : Word
              ) : Integer;
		function  SearchInventory(
                AList   : TItemList;
                ItemID  : Word;
                IEquip  : Boolean
                ) : Word;//SearchCInventory()等と使い方は同じ
		procedure CalcInventory( AList : TItemList );
    
		procedure SendCart(tc:TChara);
//------------------------------------------------------------------------------
{パーティー機能追加}
    //パーティー
		procedure PartyDistribution(Map:string; tpa:TParty; EXP:Cardinal = 0; JEXP:Cardinal = 0);
		procedure SendPartyList(tc:TChara);
		procedure SendPCmd(tc:TChara; PacketLen:word; InMap:boolean = false; AvoidSelf:boolean = false);
{パーティー機能追加ココまで}
//------------------------------------------------------------------------------
{チャットルーム機能追加}
		procedure ChatRoomExit(tc:TChara; AvoidSelf:boolean = false);
		procedure ChatRoomDisp(Socket: TCustomWinSocket; tc1:TChara);
		procedure SendCrCmd(tc:TChara; PacketLen:word; AvoidSelf:boolean = false);
		procedure SendNCrCmd(tm:TMap; Point:TPoint; PacketLen:word; tc:TChara = nil; AvoidSelf:boolean = false; AvoidChat:boolean = false);
{チャットルーム機能追加ココまで}
//------------------------------------------------------------------------------
{露店スキル追加}
		procedure VenderExit(tc:TChara; AvoidSelf:boolean = false);
		procedure VenderDisp(Socket: TCustomWinSocket; tc1:TChara);
{露店スキル追加ココまで}
//------------------------------------------------------------------------------
{取引機能追加}
		procedure CancelDealings(tc:TChara; AvoidSelf:boolean = false);
{取引機能追加ココまで}
//------------------------------------------------------------------------------
{NPCイベント追加}
		function ConvFlagValue(tc:TChara; str:string; mode:boolean = false) : Integer;
{NPCイベント追加ココまで}
//------------------------------------------------------------------------------
{ギルド機能追加}
		procedure SendGuildInfo(tc:TChara; Tab:Byte; GuildM:boolean = false; AvoidSelf:boolean = false);
		procedure SendGuildMCmd(tc:TChara; PacketLen:word; AvoidSelf:boolean = false);
		procedure CalcGuildLvUP(tg:TGuild; tc:TChara; GEXP:cardinal);
		procedure SendGLoginInfo(tg:TGuild; tc:TChara);
		function  GetGuildConUsers(tg:TGuild) : word;
    procedure GuildDInvest(tn:TNPC);
    procedure SpawnNPCMob(tn:TNPC;MobName:string;X:integer;Y:integer;SpawnDelay1:cardinal;SpawnDelay2:cardinal);
    procedure SpawnEventMob(tn:TNPC;MobID:cardinal;MobName:string;X:integer;Y:integer;DropItem:cardinal);
    procedure CallGuildGuard(tn:TNPC;guard:integer);
    procedure SetGuildKafra(tn:TNPC;mode:integer);
    procedure EnableGuildKafra(MapName:string;KafraName:string;Mode:integer);
    procedure ClaimGuildCastle(ID:cardinal;MapName:string);
    function  GetGuildKafra(tn:TNPC) : integer;
    function  GetGuildID(tn:TNPC) : word;
    function  GetGuildEDegree(tn:TNPC) : cardinal;
    function  GetGuildETrigger(tn:TNPC) : word;
    function  GetGuildDDegree(tn:TNPC) : cardinal;
    function  GetGuildDTrigger(tn:TNPC) : word;
    function  CheckGuildID(tn:TNPC; tc:TChara) : word;
    function  CheckGuildMaster(tn:TNPC; tc:TChara) : word;
    function  GetGuildName(tn:TNPC) : string;
    function  GetGuildMName(tn:TNPC) : string;
		function  GetGuildRelation(tg:TGuild; tc:TChara) : integer;
		procedure KillGuildRelation(tg:TGuild; tg1:TGuild; tc:TChara; tc1:TChara; RelType:byte);
		function  LoadEmblem(tg:TGuild) : word;
		procedure SaveEmblem(tg:TGuild; size:cardinal);
    procedure UpdateLook(tm:TMap; tv:TLiving; option:byte; val1: word; val2: word = 0; use00c3: boolean = false);
//------------------------------------------------------------------------------
{アジト機能追加}
		procedure SetFlagValue(tc:TChara; str:string; svalue:string);
{アジト機能追加ココまで}
{ギルド機能追加ココまで}
//==============================================================================

	Procedure SendMOTD( NewChara : TChara );









implementation

uses SQLData, FusionSQL, Player_Skills, Globals;

procedure SendLivingDisappear(tm:TMap; tv:TLiving; mode: byte = 0);
begin
  WFIFOW(0, $0080);
  WFIFOL(2, tv.ID);
  WFIFOB(6, mode); // 0: Disappear 1: Died 2: Logout 3: Teleport
  SendBCmd(tm, tv.Point, 7);
end;

procedure UpdateLook(tm:TMap; tv:TLiving; option:byte; val1: word; val2: word; use00c3: boolean);
begin
  // Notes:
  // Options for 'option' are
  //  0: body (job), 1: hairstyle, 2: weapon, 3: head (lower), 4: head (upper),
  //  5: head (mid), 6: hair color, 7: clothes color, 8: shield, 9: shoes.
  //  (Shoes are not implemented yet it seems).
  // IF you use the old 00c3 system, val1 can only be a byte.  val2 is ignored.
  // IF you use the new system, and have an equipment update, shield ID goes in val2.
  // IF you change clothing color and are lower class, EnableLowerClassDyes must be true.
  // Why use Use00c3?  It saves a few bytes IF you don't need to update.

  if (option = 7) and (tv.JID < UPPER_JOB_BEGIN) and (EnableLowerClassDyes = false) then exit;

  if (use00c3) then begin
    WFIFOW(0, $00c3);
    WFIFOL(2, tv.ID);
    WFIFOB(6, option);
    WFIFOB(7, val1);
    SendBCmd(tm, tv.Point, 8);
  end else begin
    WFIFOW(0, $01d7);
    WFIFOL(2, tv.ID);
    WFIFOB(6, option);
    WFIFOW(7, val1);
    WFIFOW(9, val2);
    SendBCmd(tm, tv.Point, 11);
  end;
end;
//==============================================================================
{追加}
procedure PickUpItem(tc:TChara; l:Cardinal);
var
	tm:TMap;
	tn:TNPC;
	j:Integer;
begin
	with tc do begin
		tm := tc.MData;
		if tm.NPC.IndexOf(l) <> -1 then begin
			tn := tm.NPC.IndexOfObject(l) as TNPC;
			if tc.MaxWeight >= tc.Weight + tn.Item.Data.Weight * tn.Item.Amount then begin
				j := SearchCInventory(tc, tn.Item.ID, tn.Item.Data.IEquip);
				if j <> 0 then begin
					//拾うモーション
					WFIFOW( 0, $008a);
					WFIFOL( 2, tc.ID);
					WFIFOL( 6, tn.ID);
					WFIFOB(26, 1);
					SendBCmd(tm, tc.Point, 29);
					//アイテム撤去
					WFIFOW(0, $00a1);
					WFIFOL(2, tn.ID);
					SendBCmd(tm, tn.Point, 6);
					//アイテム追加
					tc.Item[j].ID := tn.Item.ID;
					tc.Item[j].Amount := tc.Item[j].Amount + tn.Item.Amount;
					tc.Item[j].Equip := 0;
					tc.Item[j].Identify := tn.Item.Identify;
					tc.Item[j].Refine := tn.Item.Refine;
					tc.Item[j].Attr := tn.Item.Attr;
					tc.Item[j].Card[0] := tn.Item.Card[0];
					tc.Item[j].Card[1] := tn.Item.Card[1];
					tc.Item[j].Card[2] := tn.Item.Card[2];
					tc.Item[j].Card[3] := tn.Item.Card[3];
					tc.Item[j].Data := tn.Item.Data;
					//重量追加
					tc.Weight := tc.Weight + tn.Item.Data.Weight * tn.Item.Amount;
					SendCStat1(tc, 0, $18, tc.Weight);
					//アイテムゲット通知
					SendCGetItem(tc, j, tn.Item.Amount);
					//アイテム削除
					tm.NPC.Delete(tm.NPC.IndexOf(tn.ID));
					with tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC do
						Delete(IndexOf(tn.ID));
					tn.Free;
				end else begin
					//これ以上もてない
					WFIFOW( 0, $00a0);
					WFIFOB(22, 1);
					Socket.SendBuf(buf, 23);
				end;
			end else begin
				//重量オーバー
				WFIFOW( 0, $00a0);
				WFIFOB(22, 2);
				Socket.SendBuf(buf, 23);
			end;
		end else begin
			//拾うアイテムがすでになくなってる
			WFIFOW( 0, $00a0);
			WFIFOB(22, 1);
			Socket.SendBuf(buf, 23);
		end;
	end;
end;

//------------------------------------------------------------------------------

procedure CalcAbility(tc:TChara; td:TItemDB; o:Integer = 0);
var
	j :Integer;
  i :byte;
  JIDFix :word; // JID correction
begin
	with tc do begin

    JIDFix := tc.JID;
    if (JIDFix > UPPER_JOB_BEGIN) then JIDFix := JIDFix - UPPER_JOB_BEGIN + LOWER_JOB_END; // (RN 4001 - 4000 + 23 = 24

		if td.IType = 6 then begin
			Inc(ATTPOWER, td.ATK);
		end;
		if td.IType <> 10 then begin
			Inc(ATK[0][0], td.ATK);
		end;
		MATKFix := MATKFix + td.MATK; //杖用
		DEF1 := DEF1 + td.DEF;
		MDEF1 := MDEF1 + td.MDEF;
		HIT := HIT + td.HIT; //命中
		FLEE1 := FLEE1 + td.FLEE; //回避
		Critical := Critical + td.Crit; //クリティカル
		Lucky := Lucky + td.Avoid; //完全回避

    // Colus, 20040127: If item/card is armor and has an element, set player's element to its 1
    // Example: Swordfish card grants a user Water 1, Pasana Fire 1...
    // NB: If you have a carded element armor (Armor of <ele>) with an element card, the
    // card takes precedence!

    if (td.Loc = 16) and (td.Element <> 0) then
      ArmorElement := 20 + td.Element;

    // Darkhelmet 20040208: if you have a status alignment, it will over rule your armor status
    // Stat1: 1 = Stone, 2 = Freeze, 3 = Stun, 4 = Sleep, 5 = ankle snar
    // Stat2: 1 = Poison, 2 = Curse, 4 = Silence, 8 = Chaos, 16 = Blind
    {   0 Neutral
       1 Water
       2 Earth
       3 Fire
       4 Wind
       5 Poison
       6 Holy
       7 Shadow
       8 Telekenesis
       9 Undead}
    if tc.Stat1 <> 0 then begin
      case Stat1 of
        1:  ArmorElement := 2;
        2:  Armorelement := 1;
      end;
    end;
    if tc.Stat2 <> 0 then begin
      case Stat2 of
        1:  ArmorElement := 5;
      end;
    end;

		for j := 0 to 5 do begin
			Bonus[j] := Bonus[j] + td.Param[j];
		end;
		for j:=0 to 9 do begin
			Inc(DamageFixR[o][j],td.DamageFixR[j]);
			Inc(DamageFixE[o][j],td.DamageFixE[j]);
		end;
		for j:=0 to 2 do begin
			Inc(DamageFixS[j],td.DamageFixS[j]);
		end;
    // Colus, 20040321: Only weapon card/items increase status affliction chances
    // (I think).  Other items increase resistances.
    if (td.IType = 4) or ((td.IType = 6) and (td.Loc = 0)) then i := 0 else i := 1;

		for j:=0 to 4 do begin
			Inc(SFixPer1[i][j],td.SFixPer1[j]);
			Inc(SFixPer2[i][j],td.SFixPer2[j]);
		end;
		Inc(DrainFix[0],td.DrainFix[0]);
		Inc(DrainPer[0],td.DrainPer[0]);
		Inc(DrainFix[1],td.DrainFix[1]);
		Inc(DrainPer[1],td.DrainPer[1]);

                if td.SkillWeapon then begin
                        tc.WeaponID := td.WeaponID;
                        tc.WeaponSkill := td.WeaponSkill;
                        tc.WeaponSkillLv := td.WeaponSkillLv;
                end;

		if td.SplashAttack then SplashAttack := true;
		if td.SpecialAttack = 1 then tc.SpecialAttack := 1;
    	if td.SpecialAttack = 2 then tc.SpecialAttack := 2;
                if td.NoJamstone then  NoJamstone := true;
                if td.AnolianReflect then AnolianReflect := true;
                if td.FullRecover then FullRecover := true;
                if td.FastWalk then FastWalk := true;
                if td.NoTarget then NoTarget := true;
                if td.LessSP then LessSP := true;
                if td.OrcReflect then OrcReflect := true;
                if td.UnlimitedEndure then UnlimitedEndure := true;
                if td.DoppelgagnerASPD then DoppelgagnerASPD := true;
                if td.MagicReflect then MagicReflect := true;
                if td.NoCastInterrupt then  NoCastInterrupt := true;
                if td.GhostArmor then GhostArmor := true;
                if td.SkillWeapon then SkillWeapon := true;
                if td.GungnirEquipped then GungnirEquipped := true;
                if td.LVL4WeaponASPD then LVL4WeaponASPD := true;
                if td.PerfectDamage then PerfectDamage := true;

 		for j := 1 to MAX_SKILL_NUMBER do begin
			if td.AddSkill[j] <> 0 then begin
				//if (not Skill[j].Data.Job1[JIDFix]) and (not Skill[j].Data.Job2[JIDFix]) and (not DisableSkillLimit) then begin
                if (not DisableSkillLimit) then begin
                	//(td.IEquip) and 
                	if (tc.Skill[j].Lv = 0) then begin
						tc.Skill[j].Lv := td.AddSkill[j];
						tc.Skill[j].Card := True;
                    end;
				end;
			end;
		end; //for j :=1 to 336 do begin

		if td.Cast <> 0 then tc.MCastTimeFix := tc.MCastTimeFix * td.Cast div 100; // Cast time corrections
		if td.HP1 <> 0 then begin //MAXHP%(1001以上で+)
			if td.HP1 > 1000 then begin
				MAXHP := MAXHP + (td.HP1 - 1000);
				//end else Inc(MAXHPPer,(td.HP1-100));
                        end else try
                                        Inc(MAXHPPer,(td.HP1 - 100));
                                except
                                        exit;
                                end;
                end;
		if td.HP2 <> 0 then begin //HP回復速度%
			HPDelayFix := HPDelayFix + 100 - td.HP2;
		end;
		if td.SP1 <> 0 then begin //MAXSP%(1001以上で+)
			if td.SP1 > 1000 then begin
				MAXSP := MAXSP + (td.SP1 - 1000);
			end else Inc(MAXSPPer,(td.SP1 - 100));
		end;
		if td.SP2 <> 0 then begin //SP回復速度%
			SPDelayFix := SPDelayFix + 100 - td.SP2;
		end;
  end;
end;
//------------------------------------------------------------------------------
procedure CalcEquip(tc:TChara);
var
	i,j,k,o :integer;
    cardspot : Integer;
    cardloop : Integer;
	Side    :byte;
    td : TItemDB;
    td2 : TItemDB;
begin
	with tc do begin
		for i := 1 to 100 do begin
			if Item[i].ID <> 0 then begin
				Weight := Weight + Item[i].Data.Weight * Item[i].Amount;
//				if Item[i].Data.IEquip and (Item[i].Equip <> 0) then begin
				if Item[i].Equip <> 0 then begin
					Side := 0;
					o := 0;
					if Item[i].Data.IType = 4 then begin //武器
						if Item[i].Equip = $20 then Side := 1;
						ATK[Side][1] := Item[i].Data.ATK;
						WeaponType[Side] := Item[i].Data.View;
            {Colus, 20040114: Set weapon sprite for this hand}
 						WeaponSprite[Side] := Item[i].Data.ID;
            if (Side = 1) then begin
              Shield := 0;
            end;
            
						if Item[i].Refine > 0 then begin
							case Item[i].Data.wLV of
							1:		j := 2;
							2:		j := 3;
							3:		j := 5;
							4:		j := 7; // 5->7 after the Comodo patch
							else	j := 0;
							end;
							ATK[Side][3] := Item[i].Refine * j;
							Inc(ATK[1][0], Item[i].Refine * j);
						end;
						if Side = 0 then Range := Range + Item[i].Data.Range;
						WElement[Side] := Item[i].Data.Element;
					end else if Item[i].Data.IType = 5 then begin
						if (Item[i].Equip and 256) <> 0 then begin // Upper headgear
							Head1 := Item[i].Data.View;
						end else if (Item[i].Equip and 512) <> 0 then begin // Mid headgear
							Head2 := Item[i].Data.View;
						end else if (Item[i].Equip and 1) <> 0 then begin // Lower headgear
							Head3 := Item[i].Data.View;
						end else if (Item[i].Equip and 32) <> 0 then begin // Shield
              {Colus, 20040114: Set shield sprite and reset weapon sprite}
							// Shield := Item[i].Data.View;
 							Shield := Item[i].Data.ID;
   						WeaponSprite[1] := 0;
						end;
						if Item[i].Refine > 0 then begin
							DEF1 := DEF1 + Item[i].Refine;
						end;
						o := 1;
					end else if (Item[i].Data.IType = 10) then begin // Arrow
						Arrow := i;
						WElement[1] := Item[i].Data.Element;
						ATK[1][2] := Item[i].Data.ATK;
					end;

                    td := ItemDB.IndexOfObject(tc.Item[i].ID) as TItemDB;
					CalcAbility(tc, td, o);

                    for cardloop := 0 to tc.Item[i].Data.Slot - 1 do begin
                    	td2 := ItemDB.IndexOfObject(tc.Item[i].Card[cardloop]) as TItemDB;
                        if assigned(td2) then begin
                        	CalcAbility(tc, td2, o);
                        end;
                    end;



					//製造武器の属性、星のかけらの判定
					if (Item[i].Card[0] = $00FF) and (Item[i].Card[1] <> 0) then begin
						//カードスロット1に入れられた数字を$0500で割った余りがその武器の属性となる
						WElement[Side] := Item[i].Card[1] mod $0500;
						//カードスロット1に入れられた数字を$0500で割った商がその武器に埋められた星のかけらの数となる
						//Item[i].Card[1] div $0500;
					end;
{アイテム製造追加ココまで}
				end;
			end;
		end;
	end;
end;
//------------------------------------------------------------------------------
procedure CalcSkill(tc:TChara; Tick:cardinal);
var
	i :Integer;
//	j :Integer;//unused.
begin

	{ Alex: We need to move passive skills into PSS as well. This will be here
    temporarily to help the migration process. }
	parse_skills(tc, Tick, 2, True);

	with tc do begin
		//修練 ATK[0][4]
        if (Skill[55].Lv <> 0) and ((WeaponType[0] = 4) or (WeaponType[0] = 5)) then begin //槍
			if (Option and 32) = 0 then begin
				ATK[0][4] := Skill[55].Data.Data1[Skill[55].Lv];
			end else begin
				ATK[0][4] := Skill[55].Data.Data2[Skill[55].Lv];
			end;
		end else if (Skill[65].Lv <> 0) and (WeaponType[0] = 8) then begin //メイス
			ATK[0][4] := Skill[65].Data.Data1[Skill[65].Lv];
		end else if (Skill[134].Lv <> 0) and (WeaponType[0] = 16) then begin //カタール
			ATK[0][4] := Skill[134].Data.Data1[Skill[134].Lv];
                end else if (Skill[226].Lv <> 0) and (WeaponType[0] = 6) then begin //Axe Mastery
			ATK[0][4] := Skill[226].Data.Data1[Skill[226].Lv];
                end else if (Skill[259].Lv <> 0) and (WeaponType[0] = 12) then begin //Iron Hand
                        ATK[0][4] := Skill[259].Data.Data1[Skill[259].Lv]
                end else if (Skill[315].Lv <> 0) and (WeaponType[0] = 13) then begin //Musical Lesson
                        ATK[0][4] := Skill[315].Data.Data1[Skill[315].Lv];
                end else if (Skill[323].Lv <> 0) and (WeaponType[0] = 14) then begin //Musical Lesson
                        ATK[0][4] := Skill[323].Data.Data1[Skill[323].Lv];
		end;
		//ディヴァインプロテクション
		if Skill[22].Lv <> 0 then begin
			DEF3 := Skill[22].Data.Data1[Skill[22].Lv];
		end else begin
			DEF3 := 0;
		end;
		//デーモンベイン ATK[0][5]
		if Skill[23].Lv <> 0 then ATK[0][5] := Skill[23].Data.Data1[Skill[23].Lv];
		//速度増加(AGI+)
		if Skill[29].Tick > Tick then begin
			Bonus[1] := Bonus[1] + 2 + Skill[29].EffectLV;
		end;
		//速度減少(AGI-)
		if Skill[30].Tick > Tick then begin
		    if (byte(Skill[30].Effect1) > Bonus[1]) then begin
		        Bonus[1] := 0;
		    end else begin
			Bonus[1] := Bonus[1] - byte(Skill[30].Effect1);
		    end;
		end;
                if Skill[33].Tick > Tick then begin
                       i := 10 + (5 * tc.Skill[33].EffectLV);
                       tc.DEF2 := tc.DEF2 + (tc.Param[2] * i div 100);
                end;

				if isPoisoned = true then begin
                  tc.DEF2 := tc.DEF2 * 75 div 100;
                end;
		//ブレス(STR,INT,DEX+)
		if Skill[34].Tick > Tick then begin
			Bonus[0] := Bonus[0] + Skill[34].EffectLV;
			Bonus[3] := Bonus[3] + Skill[34].EffectLV;
			Bonus[4] := Bonus[4] + Skill[34].EffectLV;
		end;
                	if Skill[380].Tick > Tick then begin
			Bonus[0] := Bonus[0] + 5;
			Bonus[1] := Bonus[1] + 5;
			Bonus[2] := Bonus[2] + 5;
			Bonus[3] := Bonus[3] + 5;
			Bonus[4] := Bonus[4] + 5;
                        Bonus[5] := Bonus[5] + 5;
		end;
                if (Skill[383].Tick > Tick) and (Skill[383].Lv > 0) then begin
                        tc.FLEE1 := tc.FLEE1 + Skill[383].Data.Data2[Skill[383].Lv];
                        end;
		//所持限界量増加スキル
		if Skill[36].Lv <> 0 then begin
			MaxWeight := MaxWeight + cardinal(Skill[36].Data.Data1[Skill[36].Lv]) * 10;
		end;
		//ふくろうの目スキル(DEX+)
		if Skill[43].Lv <> 0 then begin
			Bonus[4] := Bonus[4] + Skill[43].Lv;
		end;
		//ワシの目スキル(射程、命中率+)
		if Skill[44].Lv <> 0 then begin
			if Weapon = 11 then
				Range := Range + Skill[44].Lv;
			HIT := HIT + Skill[44].Lv;
		end;
		//ダブルアタック
		if (Skill[48].Lv <> 0) and (WeaponType[0] = 1) then begin
			DAPer := Skill[48].Data.Data1[Skill[48].Lv];
			DAFix := Skill[48].Data.Data2[Skill[48].Lv];
                end else if (Skill[263].Lv <> 0) and ((WeaponType[0] = 12) or (WeaponType[0] = 0)) then begin
			DAPer := Skill[263].Data.Data1[Skill[263].Lv];
			DAFix := Skill[263].Data.Data2[Skill[263].Lv];
		end else if (WeaponType[0] <> 0) and Skill[48].Card then begin   //本来の仕様？
			DAPer := Skill[48].Data.Data1[Skill[48].Lv];
			DAFix := Skill[48].Data.Data2[Skill[48].Lv];
		end else begin
			DAPer := 0;
			DAFix := 100;
		end;
		//回避率増加スキル
		if Skill[49].Lv <> 0 then begin
			FLEE2 := Skill[49].Data.Data1[Skill[49].Lv];
		end else begin
			FLEE2 := 0;
		end;

                // Colus, 20031212: Changed Monk's flee skill bonus to be like Thief's
                // Darkhelmet 12/21/03 Colus's Fix was breaking thief Skill
                if Skill[265].Lv <> 0 then begin //Dodge
                        FLEE3 := Skill[265].Data.Data1[Skill[265].Lv];
                end else begin
			FLEE3 := 0;
                end;




		//グロリア(LUK+)
		if Skill[75].Tick > Tick then begin
			Bonus[5] := Bonus[5] + 30;
		end;

                if Skill[110].Tick > Tick then begin
                     {if (Skill[110].Lv = 1) and (Skill[110].Tick / 1000 = 1) then tc.SP := tc.SP - 1;
                     if (Skill[110].Lv = 2) and (Skill[110].Tick / 2000 = 1) then tc.SP := tc.SP - 1;
                     if (Skill[110].Lv = 3) and (Skill[110].Tick / 3000 = 1) then tc.SP := tc.SP - 1;
                     if (Skill[110].Lv = 4) and (Skill[110].Tick / 4000 = 1) then tc.SP := tc.SP - 1;
                     if (Skill[110].Lv = 5) and (Skill[110].Tick / 5000 = 1) then tc.SP := tc.SP - 1;
                     tc.ATK[0][0] := tc.ATK[0][3];
                     tc.ATK[0][1] := tc.ATK[0][3];
                     tc.ATK[0][2] := tc.ATK[0][3];
                     tc.ATK[1][0] := tc.ATK[0][3];
                     tc.ATK[1][1] := tc.ATK[0][3];
                     tc.ATK[1][2] := tc.ATK[0][3];}
                end;
		//大声歌唱(STR+)
		if Skill[155].Tick > Tick then begin
			Bonus[0] := Bonus[0] + 4;
		end;
		//アスペルシオ
		if Skill[68].Tick > Tick then begin
			WElement[0] := 6;
			WElement[1] := 6;
		end;
{追加:119}
		//Enchance Poison - Bellium (Crimson)
		if Skill[138].Tick > Tick then begin
			WElement[0] := 5;
			WElement[1] := 5;
		end;
    { Colus, 20031228: This is getting stomped in CalcStat
    debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('Speed: %d', [Speed]));
                if ((tc.Option = 6) and (tc.Skill[213].Lv <> 0)) then begin
                        Speed := (Skill[213].Data.Data2[Skill[213].Lv] * Speed) div 100;
    debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('Tunnel Speed: %d', [Speed]));
                        ASpeed := Round(ASpeed * (Skill[213].Data.Data2[Skill[213].Lv] / 100));
                end;
     }
                if Skill[268].Tick > Tick then begin //Steel Body
                        // Colus 20031223: Not +90, = 90.
                        tc.DEF1 := 90; //tc.DEF1 + 90;
                        tc.MDEF1 := 90; //tc.MDEF1 +90;
                end;
           
                if Skill[269].Tick > Tick then begin
                  // Colus, 20040204: This isn't right, but how to fix it?
                  // This would make the monk hidden.
                        //tc.Option := 6;
                        tc.Option := tc.Option or 6;
                end;

                if Skill[280].Tick > Tick then begin
			WElement[0] := 3;
			WElement[1] := 3;
		end;
                if Skill[281].Tick > Tick then begin
			WElement[0] := 1;
			WElement[1] := 1;
		end;
                if Skill[282].Tick > Tick then begin
			WElement[0] := 4;
			WElement[1] := 4;
		end;
                if Skill[283].Tick > Tick then begin
			WElement[0] := 2;
			WElement[1] := 2;
		end;

	end;
end;



//------------------------------------------------------------------------------


procedure CalcStat(tc:TChara; Tick:cardinal = 0);
var{ChrstphrR 2004/04/28  Eliminating unused variables.}
	i       : Integer;
	j       : Integer;
	k       : Integer;
	tSk    : TSkillDB;
//g         :double;//unused - code using it commented out.
	JIDFix  : Word; // JID correction for upper classes.
	tg      : TGuild;
begin
	if Tick = 0 then Tick := timeGetTime();
	with tc do begin

		if (tc.guildid > 0) then begin
			//tg := tguild.create;
			{ChrstphrR 2004/04/21 Memory Leak!}
			tg := GuildList.Objects[GuildList.IndexOf(tc.GuildID)] as TGuild;

			tg.SLV := 0;
			for i := 0 to (tg.RegUsers - 1) do begin
				tg.SLV := tg.SLV + tg.Member[i].BaseLV;
			end;
		end;


		JIDFix := tc.JID;
		if (JIDFix > UPPER_JOB_BEGIN) then JIDFix := JIDFix - UPPER_JOB_BEGIN + LOWER_JOB_END; // (RN 4001 - 4000 + 23 = 24
		//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('JIDFix %d tc.JID %d',[JIDFix, tc.JID]));
		{g := int (Tick / 3600000);
		 // Darkhelmet Auto Day/Night
		if (Tick / 3600000) <= 110 then begin
			tc.noDay := true;
		end;}

		SPRedAmount := 0;
		Weight := 0;
		Range := 0;
		WeaponType[0] := 0;
		WeaponType[1] := 0;
		{Colus, 20040114: Initialize weapon sprites}
		WeaponSprite[0] := 0;
		WeaponSprite[1] := 0;
		Arrow := 0;
		Head1 := 0;
		Head2 := 0;
		Head3 := 0;
		Shield := 0;
		for i := 0 to 1 do
			for j := 0 to 5 do
				ATK[i][j] := 0;
		DEF1 := 0;
		MDEF1 := 0;
		for i := 0 to 5 do begin //ボーナス値の初期化
			Bonus[i] := 0;
			for j := 1 to JobLV do begin
				if JobBonusTable[JIDFix][j] = i + 1 then Inc(Bonus[i]);
			end;
		end;

		//初期化
		//ArrowElement := 0;
		MAXHP := 0;
		MAXSP := 0;
		MAXHPPer := 100;
		MAXSPPer := 100;
		for i := 0 to 3 do begin
			HPDelayFix := 0;
			SPDelayFix := 0;
		end;
		ATTPOWER := 0;
		MATK1 := 0;
		MATK2 := 0;
		MATKFix := 0;
{Colus, 20031217: Initting MCastTimeFix to fix cast timer calc}
		MCastTimeFix := 100;
{Colus, 20031217: End MCastTimeFix init}
		HIT := 0;
		Lucky := 1;
		Critical := 1;
		FLEE1 := 1;
		FLEE2 := 0;
		MaxWeight := 20000;
		DEF1 := 0;
		for i:=0 to 1 do begin
			WElement[i] := 0;
			DrainFix[i] := 0;
			DrainPer[i] := 0;
		end;

		// Colus, 20040127: Initialize armor element
		ArmorElement := 0;

		for i:=0 to 9 do begin
			DamageFixR[0][i] := 100;
			DamageFixR[1][i] := 0;
			DamageFixE[0][i] := 100;
			DamageFixE[1][i] := 0;
		end;
		DamageFixS[0] := 100;
		DamageFixS[1] := 100;
		DamageFixS[2] := 100;
		FastWalk := false;
		SplashAttack := false;
		SpecialAttack := 0;
		NoJamstone := false;
		NoCastInterrupt := false;
		FullRecover := false;
		UnlimitedEndure := false;
		NoTarget := false;
		OrcReflect := false;
		AnolianReflect := false;
		DoppelgagnerASPD := false;
		LessSP := false;
		MagicReflect := false;
		GhostArmor := false;
		SkillWeapon := false;
		GungnirEquipped := false;
		LVL4WeaponASPD := false;
		PerfectDamage := false;
		PerfectHide := false;
		for i:=0 to 4 do begin
			SFixPer1[0][i] := 0;
			SFixPer1[1][i] := 0;
			SFixPer2[0][i] := 0;
			SFixPer2[1][i] := 0;
		end;

		if not DisableSkillLimit then begin //スキルツリーの再構築
			for i := 1 to MAX_SKILL_NUMBER do begin
				if (not Skill[i].Data.Job1[JIDFix]) and (not Skill[i].Data.Job2[JIDFix]) then begin
					if not Skill[i].Card then begin
						//SkillPoint := SkillPoint + Skill[i].Lv;
					end;
					Skill[i].Lv := 0;
				end;
				//Skill[i].Card := False;
			end;
			if SkillPoint > 714 then SkillPoint := 714; //これだけ有れば十分
		end;

		CalcEquip(tc);
		DEF2 := Param[2];
		CalcSkill(tc,Tick);
		for i := 0 to 5 do begin
			ParamUp[i] := ((ParamBase[i] - 1) div 10) + 2;
			// Colus, 20040321: Negative bonus for stats might crash server?
			if (Bonus[i] < 0) then Bonus[i] := 0;
			Param[i] := ParamBase[i] + Bonus[i];
		end;

		if Skill[45].Tick > Tick then begin
			Bonus[1] := Bonus[1] + Param[1] * (2 + Skill[45].EffectLV) div 100;
			Param[1] := Param[1] * (102 + Skill[45].Lv) div 100;
			Bonus[4] := Bonus[4] + Param[4] * (2 + Skill[45].EffectLV) div 100;
			Param[4] := Param[4] * (102 + Skill[45].Lv) div 100;
		end;

        try
 	        i := (MAXHP + (35 + BaseLV * 5 + ((1 + BaseLV) * BaseLV div 2) * HPTable[JIDFix] div 100) * (100 + Param[2]) div 100);
        except
        	i := 65536
        end;
        
        if (i > 65535) then begin
				MAXHP := 65535;
		//end else if (JID = 23) and (MAXHP + (35 + BaseLV * 5 + ((1 + BaseLV) * BaseLV div 2) * 40 div 100) * (100 + Param[2]) div 100 > 65535) then begin
			//  MAXHP := 65535;
		end else begin

			tc.MAXHP := tc.MAXHP + (35 + tc.BaseLV * 5 + ((1 + tc.BaseLV) * tc.BaseLV div 2) * HPTable[JIDFix] div 100) * (100 + tc.Param[2]) div 100;
			//if tc.JID = 23 then tc.MAXHP := tc.MAXHP + (35 + tc.BaseLV * 5 + ((1 + tc.BaseLV) * tc.BaseLV div 2) * 40 div 100) * (100 + tc.Param[2]) div 100;

		end;

		if (Skill[107].Lv <> 0) then begin
			tc.HIT := tc.HIT + (skill[107].Lv * 2);
		end;

		if (Skill[248].Lv <> 0) then begin
			tSk := Skill[248].Data;
			if (MAXHP + tSk.Data1[Skill[248].Lv] > 65535) then begin
				MAXHP := 65535;
			end else begin
				MAXHP := MAXHP + tSk.Data1[Skill[248].Lv];
			end;
		end;
		if Skill[360].Tick > Tick then begin
			tSk := Skill[360].Data;
			if (MAXHP + tc.Skill[360].Data.Data2[tc.Skill[360].Lv] > 65535) then begin
				MAXHP := 65535;
			end else begin
				MAXHP := MAXHP + tc.Skill[360].Data.Data2[tc.Skill[360].Lv];
			end;
		end;

        try
        	i := MAXSP + BaseLV * SPTable[JIDFix] * (100 + Param[3]) div 100;
        except
        	i := 65535;
        end;
            
		MAXSP := i;
		// if JID = 23 then MAXSP := MAXSP + BaseLV * 2 * (100 + Param[3]) div 100;
		MATK1 := Param[3] + (Param[3] div 7) * (Param[3] div 7);
		MATK2 := Param[3] + (Param[3] div 5) * (Param[3] div 5);
		MATKFix := MATKFix + 100; //杖などによるMATK補正
		HIT := HIT + BaseLV + Param[4];
		Lucky := Lucky + (Param[5] div 10);
		Critical := Critical + 1 + (Param[5] div 3);

		MaxWeight := MaxWeight + cardinal((Param[0]- Bonus[0]) * 300 + WeightTable[JIDFix]);

		MDEF2 := Param[3];
		FLEE1 := FLEE1 + Param[1] + BaseLV + FLEE2 + FLEE3;


		if Skill[270].Tick > Tick then begin //Explosion Spirits
			tc.Critical := word(tc.Critical + (tc.Critical * tc.Skill[270].Effect1 div 1000) + 1);
		end;
		if Skill[380].Tick > Tick then begin //Sight
			tc.Critical := word(tc.Critical + (tc.Critical * (100 + 1 * Skill[380].Lv) div 1000));
		end;

		if WeaponType[1] = 0 then begin
			Weapon := WeaponType[0];
			ArmsFix[0] := 100;
			ArmsFix[1] := 100;
		end else begin
			case WeaponType[0] * $100 + WeaponType[1] of
			$0001: Weapon :=	1; //R素-L短
			$0002: Weapon :=	2; //R素-L剣
			$0006: Weapon :=	6; //R素-L斧
			$0101: Weapon := 17; //R短-L短
			$0202: Weapon := 18; //R剣-L剣
			$0606: Weapon := 19; //R斧-L斧
			$0102: Weapon := 20; //R短-L剣
			$0201: Weapon := 20; //R剣-L短
			$0106: Weapon := 21; //R短-L斧
			$0601: Weapon := 21; //R斧-L短
			$0206: Weapon := 22; //R剣-L斧
			$0602: Weapon := 22; //R斧-L剣
			end;
			if Skill[132].Lv = 0 then //右手_修練
				ArmsFix[0] := Skill[132].Data.Data2[1]
			else
				ArmsFix[0] := Skill[132].Data.Data1[Skill[132].Lv];
			if Skill[133].Lv = 0 then //左手_修練
				ArmsFix[1] := Skill[133].Data.Data2[1]
			else
				ArmsFix[1] := Skill[133].Data.Data1[Skill[133].Lv];
		end;

		if Weapon = 11 then begin
			//030318
			ATK[0][0] := ATK[0][0] + Param[4]; //ステータスに表示される数字。弓の時はDEX+武器ATK
			//弓の基本攻撃力
			ATK[0][2] := Param[4] + (Param[4] div 10) * (Param[4] div 10) + (Param[0] div 5) + (Param[5] div 5) + ATTPOWER;
		end else begin
			//030317 by Beg.Thread 120
			ATK[0][0] := ATK[0][0] + Param[0]; //ステータスに表示される数字。素手はSTR、武器はSTR+武器ATK
			//弓以外の基本攻撃力
			ATK[0][2] := Param[0] + (Param[0] div 10) * (Param[0] div 10) + (Param[4] div 5) + (Param[5] div 5) + ATTPOWER;
			ATK[1][2] := Param[0] + (Param[0] div 10) * (Param[0] div 10) + (Param[4] div 5) + (Param[5] div 5) + ATTPOWER;
		end;


		if Skill[66].Tick > Tick then begin
			ATK[0][3] := ATK[0][3] + 5 * Skill[66].EffectLV;
			ATK[1][3] := ATK[1][3] + 5 * Skill[66].EffectLV;
		end;


		if WeaponType[1] = 0 then begin
			ADelay := 20*WeaponASPDTable[JIDFix][Weapon];
			//if (JID = 23) then ADelay := 20*WeaponASPDTable[0][WeaponType[1]];
		end else if WeaponType[0] = 0 then begin
			ADelay := 20*WeaponASPDTable[JIDFix][WeaponType[1]];
			//if (JID = 23) then ADelay := 20*WeaponASPDTable[0][WeaponType[1]];
		end else begin //二刀流
			ADelay := 14*(WeaponASPDTable[JIDFix][WeaponType[0]] + WeaponASPDTable[JIDFix][WeaponType[1]]);
			//if (JID = 23) then ADelay := 14*(WeaponASPDTable[0][WeaponType[0]] + WeaponASPDTable[0][WeaponType[1]]);
		end;
		i := ( ( ADelay * Param[1] div 500 ) * 2 + ADelay * Param[4] div 1000 );
		if ADelay < i then ADelay := 10
		else begin
			ADelay := ADelay - i;
			{if (JID = 23) then begin  //Super Novice ASPD
				case tc.Weapon of
				1:  ADelay := ADelay * 60 div 100;
				2:  ADelay := ADelay * 50 div 100;
				6:  ADelay := ADelay * 35 div 100;
				8:  ADelay := ADelay * 40 div 100;
				10: ADelay := ADelay * 40 div 100;
				end;
			end;}
			Delay := (1000 - (4 * param[1]) - (2 * param[4]) + 300);

			if (Skill[60].Tick > Tick) and (tc.Weapon = 3) then ADelay := ADelay * 70 div 100; //ツーハンドクイックン
			if (Skill[360].Tick > Tick) and (tc.Weapon = 3) then ADelay := ADelay * 60 div 100;
			if (Skill[359].Tick > Tick) and ((tc.Weapon = 4) or (tc.Weapon = 5)) then ADelay := ADelay * 60 div 100;
			if (Skill[111].Tick > Tick) and ((tc.Weapon = 6) or (tc.Weapon = 7) or (tc.Weapon = 8))then ADelay := ADelay * 70 div 100; //Adrenaline Rush
{Editted By AppleGirl}
			if (Skill[258].Tick > Tick) and ((tc.Weapon = 4) or (tc.Weapon = 5)) then ADelay := ADelay * 70 div 100; //ツーハンドクイックン
			if Skill[268].Tick > Tick then ADelay := ADelay * 2;    {Steel Body}
			if Skill[291].Tick > Tick then ADelay := ADelay * tc.Skill[291].Effect1 div 100;  {Attack Speed Potions}
			if Skill[320].Tick > Tick then ADelay := ADelay * tc.Skill[291].Effect1 div 100;
			if tc.DoppelgagnerASPD then ADelay := ADelay * 70 div 100;  {Doppelgagner Card}
			if tc.LVL4WeaponASPD then ADelay := ADelay * 75 div 100;     {Level 4 kro new weapon aspd haste effect}
			if ADelay < 200 then ADelay := 10;
		end;
		ASpeed := ADelay div 2;

		if (Skill[60].Tick > Tick) and (tc.Weapon <> 3) then begin
			Skill[60].Tick := Tick;
			SkillTick := Tick;
			SkillTickID := 60;
		end;


		if (Skill[360].Tick > Tick) and (tc.Weapon <> 3) then begin
			Skill[360].Tick := Tick;
			SkillTick := Tick;
			SkillTickID := 360;
		end;

		if (Skill[359].Tick > Tick) and ((tc.Weapon <> 4) and (tc.Weapon <> 5)) then begin
			Skill[359].Tick := Tick;
			SkillTick := Tick;
			SkillTickID := 359;
		end;

		if (Skill[111].Tick > Tick) and ((tc.Weapon <> 6) and (tc.Weapon <> 7) and (tc.Weapon <> 8)) then begin
			Skill[111].Tick := Tick;
			SkillTick := Tick;
			SkillTickID := 111;
		end;

		if (Skill[258].Tick > Tick) and ((tc.Weapon <> 4) and (tc.Weapon <> 5)) then begin
			Skill[258].Tick := Tick;
			SkillTick := Tick;
			SkillTickID := 258;
		end;

		if ((Option and 32) <> 0) then begin
			// AlexKreuz: Skill[64].Lv = 0 caused Crash: Needs else begin.
			if Skill[64].Lv > 0 then begin
				ASpeed := Round(ASpeed * (Skill[64].Data.Data1[Skill[64].Lv] / 100));
			end else begin
				ASpeed := Round(ASpeed * (50/100));
			end;
		end;

		if Param[4] <= 150 then begin
{Colus, 20031217: MCastTimeFix correction to involve cards}
			MCastTimeFix := (100 - (Param[4] * 100) div 150) * MCastTimeFix div 100;
{Colus, 20031217: End MCastTimeFix correction}
		end else begin
			MCastTimeFix := 0;
		end;
		//サイズ補正
		for i := 0 to 1 do begin
			for j := 0 to 2 do begin
				ATKFix[i][j] := WeaponTypeTable[j][WeaponType[i]];
			end;
		end;

		// When on peco and using a spear, damage to medium scale monsters is 100%.
		if ((Option and 32) <> 0) and ((WeaponType[0] = 4) or (WeaponType[0] = 5)) then begin
			ATKFix[0][1] := 100;
		end;

		{Weapon Perfection}
		if (Skill[112].Tick > Tick) or (PerfectDamage) then begin
			for i := 0 to 1 do begin
				for j := 0 to 2 do begin
					ATKFix[i][j] := 100;
				end;
			end;
		end;
		//オーバートラスト(ATK+)
		if Skill[113].Tick > Tick then begin
			//手抜き
			for i := 0 to 1 do begin
				for j := 0 to 2 do begin
					ATKFix[i][j] := ATKFix[i][j] * (100 + 5 * Skill[113].Lv) div 100;
				end;
			end;
		end;

		if Skill[357].Tick > Tick then begin
			for i := 0 to 1 do begin
				for j := 0 to 2 do begin
					ATKFix[i][j] := ATKFix[i][j] * (100 + 5 * Skill[357].Lv) div 100;
				end;
			end;
		end;

		if Skill[380].Tick > Tick then begin
			for i := 0 to 1 do begin
				for j := 0 to 2 do begin
					ATKFix[i][j] := ATKFix[i][j] * (100 + 2 * Skill[380].Lv) div 100;
				end;
			end;
		end;

		if Skill[357].Tick > Tick then begin
			tc.HIT := tc.HIT * (100 + 10 * Skill[357].Lv) div 100;
		end;

		if Skill[380].Tick > Tick then begin
			tc.HIT := tc.HIT * (100 + 3 * Skill[380].Lv) div 100;
		end;


{:code}
		//移動速度
		i := tc.DefaultSpeed;
		if ((Option and 32) <> 0) and (Skill[63].Lv > 0) then begin
			i := i - 40;
		end;

		if FastWalk then i := i - 30;

		// Colus, 20040126: Added alchemist to pushcart calc, cleaned it up
		if (((Option and $0788) <> 0) and ((JIDFix = 10) or (JIDFix = 5) or (JIDFix = 19))) then begin // Pushcart
			if Skill[39].Lv = 0 then begin
				i := i + Skill[39].Data.Data1[1];
			end else begin
				i := i + Skill[39].Data.Data1[Skill[39].Lv];
			end;
		end;

		if Skill[29].Tick > Tick then begin // AGI Up
			if Skill[29].EffectLV > 5 then
				i := i - 45
			else
				i := i - 30;
		end;
		if Skill[387].Tick > Tick then begin // Cart boost  // I think this should do it.
			i := i - 45;
		end;
		if Skill[383].Tick > Tick then begin // Wind Walk AGI effect
			i := i - 45;
		end;
		{ Colus, 20040224: You didn't listen to how I explained the skill. :/
			This is so not right it's not even funny.
				//BS Maximun codes
				//beita 20040206
		if (Skill[114].Lv <> 0) then begin
			if getSkillOnBool then begin
			//set param[4] to be 200 for maximun effect
				tc.Param[4] := 200;
			end;
		end;
		//end of BS Maximun codes
		}
		if Skill[30].Tick > Tick then begin // AGI down
			if Skill[30].EffectLV > 5 then
				i := i + 45
			else
				i := i + 30;
		end;

		if Skill[257].Tick > Tick then begin // Defender
			i := i + 30;
		end;

		//Tunnel Drive
		// Colus, 20031228: Moved this mod from CalcSkill b/c CalcStat
		// won't take its value into account otherwise.

		if ((tc.Option and 2 <> 0) and (tc.Skill[213].Lv <> 0)) then begin
			i := (Skill[213].Data.Data2[Skill[213].Lv] * i) div 100;
		end;

		if i < 25 then i := 25;
		Speed := i;

		//if (Skill[39].Lv <> 0) and (Option = 8) then begin
			//tl := Skill[39].Data;
			//Speed := Round(Speed * (tl.Data2[Skill[39].Lv] / 100));
		//end;
		//030323
		aMotion := ADelay div 2;
		if (Skill[8].Tick > Tick) or (UnlimitedEndure = true) then begin // Endure
			dMotion := 0;
		end else if Param[1] > 100 then begin
			dMotion := 400;
		end else begin
			dMotion := 800 - Param[1] * 4;
		end;
		//030316-2 unknown-user
{修正}
		//030316-2 Cardinal
		{if Param[3] > 123 then begin
			SPDelay[0] := 150;
		end else begin
			SPDelay[0] := 7560 - (60 * Param[3]);
		end;
		if (BaseLV + Param[2]) > 203 then begin
			HPDelay[0] := 150;
		end else begin
			HPDelay[0] := 3000 - (14 * (BaseLV + Param[2])); //暫定
		end;}

		//The old SP regen was only used in Comodo, after 6.0 the sp regen become 8 secs to regen and 6 for hp you also get more
		HPDelay[0] := 6000;
		SPDelay[0] := 8000;

		//---
{:code}
		if Skill[74].Tick > Tick then begin //マグニ
			HPDelay[0] := HPDelay[0] div 2;
			SPDelay[0] := SPDelay[0] div 2;
		end;
{:code}
		HPDelay[1] := HPDelay[0] div 2; //座り
		HPDelay[2] := 7200000;          //死亡
		//030316 Cardinal
{:119}
		if (Skill[144].Lv <> 0) then HPDelay[3] := HPDelay[0] * 4 //移動時_HP_回復
		else HPDelay[3] := 7200000; //移動
{:119}
		//---
		SPDelay[1] := SPDelay[0] div 2;
		SPDelay[2] := 7200000;
		SPDelay[3] := SPDelay[0] * 2;
		j := 100 - HPDelayFix;
		if j < 0 then j := 0;
		k := 100 - SPDelayFix;
		if k < 0 then k := 0;
		for i:=0 to 3 do begin
			HPDelay[i] := HPDelay[i] * Cardinal(j) div 100;
			if HPDelay[i] < 150 then HPDelay[i] := 150;
			SPDelay[i] := SPDelay[i] * Cardinal(k) div 100;
			if SPDelay[i] < 150 then SPDelay[i] := 150;
		end;

		BaseNextEXP := ExpTable[0][BaseLV];
		if      JIDFix = 0 then i := 1
		else if JIDFix < 7 then i := 2
		else                 i := 3;
		JobNextEXP := ExpTable[i][JobLV];



		//if Weapon = 11 then Element := ArrowElement;
		//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('WElement: %d/%d', [WElement[0], WElement[1]]));
		if Weapon = 16 then Critical := Critical * 2;
		Inc(Range);
		if ((MAXHP * MAXHPPer div 100) > 65535) then begin
			MAXHP := 65535;
		end else begin
			MAXHP := MAXHP * MAXHPPer div 100;
		end;
		if ((MAXSP * MAXSPPer div 100) > 65535) then begin
			MAXSP := 65535;
		end else begin
			MAXSP := MAXSP * MAXSPPer div 100;
		end;
		if HP > MAXHP then HP := MAXHP;
		if SP > MAXSP then SP := MAXSP;
		if Critical > 100 then Critical := 100;
		if Lucky > 100 then Lucky := 100;
	end;
{カート機能}
	tc.Cart.MaxWeight := 80000;
	CalcInventory(tc.Cart);
{カート機能ココまで}
end;


//------------------------------------------------------------------------------
procedure CalcSongStat(tc:TChara; Tick:cardinal = 0);
var
	i,j      :integer;
	//Side      :byte;
	//td        :TItemDB;
	tl        :TSkillDB;
	//mi        :MapTbl;
	//g         :double;
	JIDFix     :word;   // JID correction.
begin
	if Tick = 0 then Tick := timeGetTime();
	with tc do begin
		JIDFix := tc.JID;
		if (JIDFix > UPPER_JOB_BEGIN) then JIDFix := JIDFix - UPPER_JOB_BEGIN + LOWER_JOB_END; // (RN 4001 - 4000 + 23 = 24
		SPRedAmount := 0;

		NoJamstone := false;
		NoTrap := false;

		{Initialize to 0}
		DEF1 := 0;
		FLEE1 := 1;

		MAXHP := 0;
		MAXSP := 0;

		for i := 0 to 1 do begin
			for j := 0 to 5 do begin
				ATK[i][j] := 0;
			end;
		end;
		for i := 0 to 5 do begin        {Bonus Calculation}
			Bonus[i] := 0;
			for j := 1 to JobLV do begin
				if JobBonusTable[JIDFix][j] = i + 1 then Inc(Bonus[i]);
			end;
		end;

		{Calculate Needed Skills}
		DEF2 := Param[2];

		MAXSP := MAXSP + BaseLV * SPTable[JIDFix] * (100 + Param[3]) div 100;

		if ((MAXSP * MAXSPPer div 100) > 65535) then begin
			MAXSP := 65535;
		end else begin
			MAXSP := MAXSP * MAXSPPer div 100;
		end;

		if ((MAXHP + (35 + BaseLV * 5 + ((1 + BaseLV) * BaseLV div 2) * HPTable[JIDFix] div 100) * (100 + Param[2]) div 100) > 65535) then begin
			MAXHP := 65535;
		end else begin
			tc.MAXHP := tc.MAXHP + (35 + tc.BaseLV * 5 + ((1 + tc.BaseLV) * tc.BaseLV div 2) * HPTable[JIDFix] div 100) * (100 + tc.Param[2]) div 100;
		end;

		if (Skill[248].Lv <> 0) then begin
			tl := Skill[248].Data;
			if (MAXHP + tl.Data1[Skill[248].Lv] > 65535) then begin
				MAXHP := 65535;
			end else begin
				MAXHP := MAXHP + tl.Data1[Skill[248].Lv];
			end;
		end;
		if Skill[360].Tick > Tick then begin
			if (MAXHP + tc.Skill[360].Data.Data2[tc.Skill[360].Lv] > 65535) then begin
				MAXHP := 65535;
			end else begin
				MAXHP := MAXHP + tc.Skill[360].Data.Data2[tc.Skill[360].Lv];
			end;
		end;

		if Skill[322].Tick > Tick then begin
			//tl := Skill[322].Data;
			if (MAXHP + tc.Skill[322].Effect1 > 65535) then begin
				MAXHP := 65535;
			end else begin
				MAXHP := MAXHP + tc.Skill[322].Effect1;
			end;
		end;

		if Weapon = 11 then begin
			ATK[0][0] := ATK[0][0] + Param[4]; //ステータスに表示される数字。弓の時はDEX+武器ATK
			ATK[0][2] := Param[4] + (Param[4] div 10) * (Param[4] div 10) + (Param[0] div 5) + (Param[5] div 5) + ATTPOWER;
		end else begin
			ATK[0][0] := ATK[0][0] + Param[0]; //ステータスに表示される数字。素手はSTR、武器はSTR+武器ATK
			ATK[0][2] := Param[0] + (Param[0] div 10) * (Param[0] div 10) + (Param[4] div 5) + (Param[5] div 5) + ATTPOWER;
			ATK[1][2] := Param[0] + (Param[0] div 10) * (Param[0] div 10) + (Param[4] div 5) + (Param[5] div 5) + ATTPOWER;
		end;

		for i := 0 to 5 do begin
			ParamUp[i] := ((ParamBase[i] - 1) div 10) + 2;
			Param[i] := ParamBase[i] + Bonus[i];
		end;

		if Skill[45].Tick > Tick then begin
			Bonus[1] := Bonus[1] + Param[1] * (2 + Skill[45].EffectLV) div 100;
			Param[1] := Param[1] * (102 + Skill[45].Lv) div 100;
			Bonus[4] := Bonus[4] + Param[4] * (2 + Skill[45].EffectLV) div 100;
			Param[4] := Param[4] * (102 + Skill[45].Lv) div 100;
		end;

		FLEE1 := FLEE1 + Param[1] + BaseLV + FLEE2 + FLEE3;

		if Skill[66].Tick > Tick then begin
			ATK[0][3] := ATK[0][3] + 5 * Skill[66].EffectLV;
			ATK[1][3] := ATK[1][3] + 5 * Skill[66].EffectLV;
		end;

		if ((MAXHP * MAXHPPer div 100) > 65535) then begin
			MAXHP := 65535;
		end else begin
			MAXHP := MAXHP * MAXHPPer div 100;
		end;

		NoJamStone := false;
		NoTrap := false;
	end;

end;

//------------------------------------------------------------------------------
procedure CalcSongSkill(tc:TChara; Tick:cardinal = 0);

begin

   with tc do begin

        {Drum Battle Field}
        if (tc.Skill[309].Tick > Tick) and (tc.InField) then begin
                ATK[0][4] := ATK[0][4] * tc.Skill[309].Effect1 div 100;
                tc.DEF2 := tc.DEF2 + ((tc.DEF1 + tc.DEF2 + tc.DEF3) * Skill[309].Data.Data2[tc.Skill[309].EffectLV + 5] div 100);
        end;

        {Into The Abyss}
        if (tc.Skill[312].Tick > Tick) and (Infield) then begin
                tc.NoJamstone := true;
                tc.NoTrap := true;
        end;

        {Whistling}
        if (tc.Skill[319].Tick > Tick) and (tc.InField) then begin
                tc.FLEE1 := tc.FLEE1 + (tc.FLEE1 * tc.Skill[319].Effect1 div 100);
                tc.Bonus[5] := tc.Bonus[5] + (tc.Param[5] * tc.Skill[319].Effect1 div 100);
        end;

        {Service For You}
        if (tc.Skill[330].Tick > Tick) and (tc.InField) then begin
                tc.MAXSP := tc.MAXSP + (tc.MAXSP * (tc.Skill[330].EffectLV + 10) div 100);
                tc.SPRedAmount := tc.SPRedAmount +( tc.SPRedAmount * tc.Skill[330].Effect1);
        end;

        tc.InField := false;
   end;

end;
//------------------------------------------------------------------------------

procedure CalcSageSkill(tc:TChara; Tick:cardinal = 0);
begin
        with tc do begin

                if (tc.Skill[285].Tick > Tick) and (tc.InField) and (tc.WElement[0] = 3)  then begin
                        ATK[0][4] := ATK[0][4] + Skill[285].Data.Data2[Skill[285].EffectLV];
                        tc.SageElementEffect := true;
                end else if (tc.Skill[286].Tick > Tick) and (tc.InField) and (tc.WElement[0] = 1)  then begin
                        tc.MAXHP := tc.MAXHP + (tc.MAXHP * Skill[286].Data.Data2[Skill[286].EffectLV] div 100);
                        tc.SageElementEffect := true;
                end else if (tc.Skill[287].Tick > Tick) and (tc.InField) and (tc.WElement[0] = 4)  then begin
                        tc.FLEE1 := tc.FLEE1 + Skill[287].Data.Data2[Skill[287].EffectLV];
                        tc.SageElementEffect := true;
                end else begin
                        tc.SageElementEffect := false;
                        CalcStat(tc, Tick);
                end;

                tc.InField := false;
        end;
end;
//------------------------------------------------------------------------------
{Display Icons for passive Events}
{procedure PassiveIcons(tm:TMap; tc:TChara);
begin
  with tc do begin
        {Peco Peco}
        {if (tc.Skill[63].Lv <> 0) and (tc.Option = 32) then begin
                //debugout.lines.add('[' + TimeToStr(Now) + '] ' + '(ﾟ∀ﾟ)?');
                WFIFOW(0, $0196);
                WFIFOW(2, tc.Skill[63].Data.Icon);
                WFIFOL(4, tc.ID);
                WFIFOB(8, 1);
                SendBCmd(tm, tc.Point, 9);
        end else begin
                WFIFOW(0, $0196);
                WFIFOW(2, tc.Skill[63].Data.Icon);
                WFIFOL(4, tc.ID);
                WFIFOB(8, 0);
                Socket.SendBuf(buf, 9);
        end;

        {Falcon Icon}
        {if (tc.Skill[127].Lv <> 0) and (tc.Option = 16) then begin
                //debugout.lines.add('[' + TimeToStr(Now) + '] ' + '(ﾟ∀ﾟ)?');
                WFIFOW(0, $0196);
                WFIFOW(2, tc.Skill[127].Data.Icon);
                WFIFOL(4, tc.ID);
                WFIFOB(8, 1);
                SendBCmd(tm, tc.Point, 9);
                //Socket.SendBuf(buf, 9);
        end else begin
                WFIFOW(0, $0196);
                WFIFOW(2, tc.Skill[127].Data.Icon);
                WFIFOL(4, tc.ID);
                WFIFOB(8, 0);
                Socket.SendBuf(buf, 9);
        end;

        {Overweight 50%}
        {if tc.Weight * 2 >= tc.MaxWeight then begin
                //debugout.lines.add('[' + TimeToStr(Now) + '] ' + '(ﾟ∀ﾟ)?');
                WFIFOW(0, $0196);
                WFIFOW(2, 35);
                WFIFOL(4, tc.ID);
                WFIFOB(8, 1);
                SendBCmd(tm, tc.Point, 9);
                //Socket.SendBuf(buf, 9);
        end else begin
                WFIFOW(0, $0196);
                WFIFOW(2, 35);
                WFIFOL(4, tc.ID);
                WFIFOB(8, 0);
                Socket.SendBuf(buf, 9);
        end;

        {Overweight 90%}
        {if Weight * 100 div MaxWeight >= 90 then begin
        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + '(ﾟ∀ﾟ)?');
                WFIFOW(0, $0196);
                WFIFOW(2, 36);
                WFIFOL(4, tc.ID);
                WFIFOB(8, 1);
                SendBCmd(tm, tc.Point, 9);
                //Socket.SendBuf(buf, 9);
        end else begin
                WFIFOW(0, $0196);
                WFIFOW(2, 36);
                WFIFOL(4, tc.ID);
                WFIFOB(8, 0);
                Socket.SendBuf(buf, 9);
        end;
  end;
end;}
//------------------------------------------------------------------------------
{procedure PoisonCharacter(tm:TMap; tc:TChara; Tick:cardinal);
begin
        tm := tc.MData;
        if tc.PoisonTick > Tick then begin
                WFIFOW(0, $0119);
                WFIFOL(2, tc.ID);
                WFIFOW(6, 0);
                WFIFOW(8, $01);
                WFIFOW(10, 0);
                WFIFOB(12, 0);
                SendBCmd(tm, tc.Point, 13);
        end else begin
                WFIFOW(0, $0119);
                WFIFOL(2, tc.ID);
                WFIFOW(6, 0);
                WFIFOW(8, 0);
                WFIFOW(10, 0);
                WFIFOB(12, 0);
                SendBCmd(tm, tc.Point, 13);
        end;
end;
//------------------------------------------------------------------------------
procedure BlindCharacter(tm:TMap; tc:TChara; Tick:Cardinal);
begin
        tm := tc.MData;
        if tc.BlindTick > Tick then begin
                WFIFOW(0, $0119);
                WFIFOL(2, tc.ID);
                WFIFOW(6, 00);
                WFIFOW(8, 16);
                WFIFOW(10, tc.Option);
                WFIFOB(12, 0); // attack animation
                tc.Socket.SendBuf(buf, 13)
        end else begin
                WFIFOW(0, $0119);
                WFIFOL(2, tc.ID);
                WFIFOW(6, 0);
                WFIFOW(8, 0);
                WFIFOW(10, tc.Option);
                WFIFOB(12, 0);
                SendBCmd(tm, tc.Point, 13);
        end;
end;}
//------------------------------------------------------------------------------
procedure CharaDie(tm:TMap; tc:TChara; Tick:Cardinal; KilledByP:short = 0);
// Killed by player triggers for a token to be dropped... one of Krietor's Ideas
var
  i : integer;
{  j : integer;
	mi : MapTbl;
	item : cardinal;
	StartI  : cardinal;
  EndI    : cardinal;}
begin
  // Set Hit Points to 0
  tc.HP := 0;
  // Display the character as dead
  WFIFOW( 0, $0080);
  WFIFOL( 2, tc.ID);
  WFIFOB( 6, 1);
  SendBCmd(tm, tc.Point, 7);
  // Sit = 1 lets monsters know the char is dead and the player cannot move
  tc.Sit := 1;

  if (KilledByP <> 1) or ( (KilledByP = 1) and (Option_PVP_XPLoss) ) then begin
      // Subtract the Experience loss from the .ini


      { Wow, major mistake on my behalf. Fatal N version. }

      if ( tc.BaseEXP >= (Round(tc.BaseNextEXP div 100) * DeathBaseLoss) ) then begin
      	tc.BaseEXP := tc.BaseEXP - (Round(tc.BaseNextEXP div 100) * DeathBaseLoss);
      end else begin
      	tc.BaseEXP := 0;
      end;

      if ( tc.JobEXP >= (Round(tc.JobNextEXP div 100) * DeathJobLoss) ) then begin
      	tc.JobEXP := tc.JobEXP - (Round(tc.JobNextEXP div 100) * DeathJobLoss);
      end else begin
      	tc.JobEXP := 0;
      end;


      { Ghetto Harb formulas. I submitted a bug report so long ago for darkweiss.
        But he refused to fix it, saying his calc was better.
      i := (100 - DeathBaseLoss);
      tc.BaseEXP := Round(tc.BaseEXP * (i / 100));
      i := (100 - DeathJobLoss);
      tc.JobEXP := Round(tc.JobEXP * (i / 100));
      }
      
        SendCStat1(tc, 1, $0001, tc.BaseEXP);
        SendCStat1(tc, 1, $0002, tc.JobEXP);
  end;


  tc.pcnt := 0;

  if (tc.AMode = 1) or (tc.AMode = 2) then tc.AMode := 0;

  reset_skill_effects(tc);

  { Alex: not needed since we're doing a full check for all buffs now. }
  {if (tc.Option and 2 <> 0) then begin
    tc.SkillTick := Tick;
    tc.SkillTickID := 51;
    tc.Skill[tc.SkillTickID].Tick := Tick;
  end;

  if (tc.Option and 4 <> 0) then begin
    tc.SkillTick := Tick;
    tc.SkillTickID := 135;
    tc.Skill[tc.SkillTickID].Tick := Tick;
  end;}
  
  // Krietor's idea for his server, can be commented out
  // Drop items - Only when killed by a player
  // I'll leave this commented out on the CVS
	{if (StartDeathDropItem <> 0) and (KilledbyP = 1) then begin
		StartI := StartDeathDropItem;
		EndI   := EndDeathDropItem;
		while (StartI <= EndI) do begin
			j := SearchCInventory(tc, StartI, false);
			if ((j <> 0) and (tc.Item[j].Amount >= 1)) then begin
				debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Drop Item ' + IntToStr(StartI) + ' At Location ' + IntToStr(j));
				//UseItem(tc, j);  //Use Item Function
				ItemDrop(tm, tc, j, 1);
				break;
			end;
		StartI := StartI + 1;
		end;
	end;
  { 11006,PvP_Token,"PvP Token",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    11007,GvG_Token,"GvG Token",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    11008,CTF_Token,"CTF Token",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

  // Token's will drop depending on what kind of map is there
  // PvP maps drop pvp tokens, and so on
  if TokenDrop then begin
    i := MapInfo.IndexOf(tc.Map);
    if (i <> -1) then
      mi := MapInfo.Objects[i] as MapTbl
    else exit;  //Safe exit call
    if mi.PvP then begin
      CreateGroundItem(tm, 11006, tc.Point.X + Random(3), tc.Point.Y + Random(3));
    end;
    if mi.PvPG then begin
      CreateGroundItem(tm, 11007, tc.Point.X + Random(3), tc.Point.Y + Random(3));
    end;
    if mi.CTF then begin
      CreateGroundItem(tm, 11008, tc.Point.X + Random(3), tc.Point.Y + Random(3));
    end;
  end; }

end;

//------------------------------------------------------------------------------

// Simple Algorithm to create an item dropped by a player
procedure ItemDrop(tm:TMap; tc:TChara; j:integer; amount:integer);
var
  tn:TNPC;
begin
  // An NPC Creation which is merely the item, gets it's data from tc
  tn := TNPC.Create;
  tn.ID := NowItemID;
  Inc(NowItemID);
  tn.Name := 'item';
  tn.JID := tc.Item[j].ID;
  tn.Map := tc.Map;
  tn.Point.X := tc.Point.X - 1 + Random(3);
  tn.Point.Y := tc.Point.Y - 1 + Random(3);
	tn.CType := NPC_TYPE_ITEM;
  tn.Enable := true;

	//Create Item structure in NPC, and copy data from Character's item,
	//Using the amount passed.
  tn.Item := TItem.Create;
  tn.Item.ID := tc.Item[j].ID;
  tn.Item.Amount := amount;
  tn.Item.Identify := tc.Item[j].Identify;
  tn.Item.Refine := tc.Item[j].Refine;
  tn.Item.Attr := tc.Item[j].Attr;
  tn.Item.Card[0] := tc.Item[j].Card[0];
  tn.Item.Card[1] := tc.Item[j].Card[1];
  tn.Item.Card[2] := tc.Item[j].Card[2];
  tn.Item.Card[3] := tc.Item[j].Card[3];
  tn.Item.Data := tc.Item[j].Data;

  tn.SubX := Random(8);
  tn.SubY := Random(8);
  tn.Tick := timeGetTime() + 60000;

  //Add it to the map
  tm.NPC.AddObject(tn.ID, tn);
  tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.AddObject(tn.ID, tn);

  //Reduce number of items at index by amount.
  WFIFOW( 0, $00af);
  WFIFOW( 2, j);
  WFIFOW( 4, amount);
  tc.Socket.SendBuf(buf, 6);

  // Change the player's weight for the server
  tc.Item[j].Amount := tc.Item[j].Amount - amount;
  if tc.Item[j].Amount = 0 then tc.Item[j].ID := 0;
  tc.Weight := tc.Weight - tc.Item[j].Data.Weight * amount;
  // Update weight on the Client
  SendCStat1(tc, 0, $0018, tc.Weight);

  //Item Drop on ground Packet
  WFIFOW( 0, $009e);
  WFIFOL( 2, tn.ID);
  WFIFOW( 6, tn.JID);
  WFIFOB( 8, tn.Item.Identify);
  WFIFOW( 9, tn.Point.X);
  WFIFOW(11, tn.Point.Y);
  WFIFOB(13, tn.SubX);
  WFIFOB(14, tn.SubY);
  WFIFOW(15, tn.Item.Amount);
  SendBCmd(tm, tn.Point, 17);
end;

//------------------------------------------------------------------------------

procedure CreateGroundItem(tm:TMap; itemID:cardinal; XPoint:cardinal; YPoint:cardinal);
var
	tn  : TNPC;
	td  : TItemDB;
begin
	// We're creating this item from scratch so we have to get it based on it's ID
	// We check if it exist's first to prevent a list index error
	// Maybe we should have a message on a fail though.
	if ItemDB.IndexOf(itemID) <> -1 then begin
	// Define td after we make sure it won't cause an error
	// We need this value for the item's data
		td := ItemDB.IndexOfObject(itemID) as TItemDB;

		// Create the item with blank properties since it's new
	tn := TNPC.Create;
	tn.ID := NowItemID;
	Inc(NowItemID);
	tn.Name := 'item';
	tn.JID := itemID;
	tn.Map := tm.Name;
	tn.Point.X := XPoint;
	tn.Point.Y := YPoint;
		tn.CType := NPC_TYPE_ITEM;
		tn.Enable := true;

		tn.Item := TItem.Create;
		//Create Zeros out all fields/properties, so change only what's needed
		tn.Item.ID := itemID;
		tn.Item.Amount := 1;
		tn.Item.Identify := 1;
		tn.Item.Data := td;

		tn.SubX := Random(8);
		tn.SubY := Random(8);
		tn.Tick := timeGetTime() + 60000;
		// Add the item to the core map
		tm.NPC.AddObject(tn.ID, tn);
		tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.AddObject(tn.ID, tn);

		//Item Drop on ground Packet
		WFIFOW( 0, $009e);
		WFIFOL( 2, tn.ID);
		WFIFOW( 6, tn.JID);
		WFIFOB( 8, tn.Item.Identify);
		WFIFOW( 9, tn.Point.X);
		WFIFOW(11, tn.Point.Y);
		WFIFOB(13, tn.SubX);
		WFIFOB(14, tn.SubY);
		WFIFOW(15, tn.Item.Amount);
		SendBCmd(tm, tn.Point, 17);
	end;

end;

//------------------------------------------------------------------------------

procedure UpdateStatus(tm:TMap; tc:TChara; Tick:Cardinal);
begin
        tm := tc.MData;
		
		{Example Poison changes your stats so this is neccessary}
        CalcStat(tc, Tick);
        CalcSkill(tc, Tick);
        SendCStat(tc);
        WFIFOW(0, $0119);
        WFIFOL(2, tc.ID);
        WFIFOW(6, tc.Stat1);
        WFIFOW(8, tc.Stat2);
        WFIFOW(10, tc.Option);
        WFIFOB(12, 0); // attack animation
        SendBCmd(tm, tc.Point, 13);
end;
//------------------------------------------------------------------------------
procedure UpdateOption(tm:TMap; tc:TChara);
begin
        tm := tc.MData;
  {Here we simply want to change a player option that has been previously set.}
        WFIFOW(0, $0119);
        WFIFOL(2, tc.ID);
        WFIFOW(6, tc.Stat1);
        WFIFOW(8, tc.Stat2);
        WFIFOW(10, tc.Option);
        WFIFOB(12, 0); // attack animation
        SendBCmd(tm, tc.Point, 13);

  // Do we need to update icons for cart/peco/falcon?
        {Peco Peco}
        if (tc.Skill[63].Lv <> 0) and (tc.Option and 32 <> 0) then begin
          UpdateIcon(tm, tc, tc.Skill[63].Data.Icon, 1);
        end else begin
          UpdateIcon(tm, tc, tc.Skill[63].Data.Icon, 0);
        end;

        {Falcon Icon}
        if (tc.Skill[127].Lv <> 0) and (tc.Option and 16 <> 0) then begin
          UpdateIcon(tm, tc, tc.Skill[127].Data.Icon, 1);
        end else begin
          UpdateIcon(tm, tc, tc.Skill[127].Data.Icon, 0);
        end;

end;
//------------------------------------------------------------------------------
procedure UpdateIcon(tm:TMap; tc:TChara; icon:word; active:byte = 1);
begin
  WFIFOW(0, $0196);
  WFIFOW(2, icon);
  WFIFOL(4, tc.ID);
  WFIFOB(8, active);
  SendBCmd(tm, tc.Point, 9);
end;
//------------------------------------------------------------------------------
procedure SilenceCharacter(tm:TMap; tc:TChara; Tick:Cardinal);
// Will send a "..." message over the character
// Used when a silenced character attempts to use a skill
begin
        tm := tc.MData;

        WFIFOW(0, $00c0);
        WFIFOL(2, tc.ID);
        WFIFOB(6, 09);

        SendBCmd(tm, tc.Point, 7);
end;

//------------------------------------------------------------------------------

procedure IntimidateWarp(tm:TMap; tc:TChara);
var
        i       :integer;
        j       :integer;
        xy      :TPoint;
        mi      :MapTbl;
        ts      :TMob;

begin
        ts := tc.AData;
        i := MapInfo.IndexOf(tc.Map);
        j := -1;
        if (i <> -1) then begin
                mi := MapInfo.Objects[i] as MapTbl;
                if (mi.noTele = true) then j := 0;
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
                        if ( (ts.HP > 0) and (ts.Data.MEXP = 0) ) then begin
                            ts.Point.X := tc.Point.X;
                            ts.Point.Y := tc.Point.Y;
                            SendMmove(tc.Socket, ts, ts.Point, tc.Point, tc.ver2);
                        end;
                        MapMove(tc.Socket, tc.Map, tc.Point);
                end;
        end;
end;
//------------------------------------------------------------------------------
procedure UpdateMonsterDead(tm:TMap; ts:TMob; k:integer);  //Kills a monster or updates its status

begin
	WFIFOW( 0, $0080);
	WFIFOL( 2, ts.ID);
	WFIFOB( 6, k);
	SendBCmd(tm, ts.Point, 7);
end;
//------------------------------------------------------------------------------
procedure UpdatePetLocation(tm:TMap; tn:TNPC);  //Update the location of a pet

begin
	WFIFOW(0, $0088);
	WFIFOL(2, tn.ID);
	WFIFOW(6, tn.Point.X);
	WFIFOW(8, tn.Point.Y);
	SendBCmd(tm, tn.Point, 10);
end;
//------------------------------------------------------------------------------
procedure SendPetRelocation(tm:TMap; tc:TChara; i:integer); //Move a pet
var
	tpe:TPet;
	tn:TNPC;
begin
	tpe := PetList.Objects[i] as TPet;
	if tpe.CharaID = tc.CID then begin
		tn := TNPC.Create;
		tn.ID := NowNPCID;

		Inc(NowNPCID);

		tn.Name := tpe.Name;
		tn.JID := tpe.JID;
		tn.Map := tc.Map;
		tpe.MobData := MobDB.IndexOfObject(tpe.JID) as TMobDB;

		repeat
			tn.Point.X := tc.Point.X + Random (5);
			tn.Point.Y := tc.Point.Y + Random (5);
		until (( tn.Point.X <> tc.Point.X ) or ( tn.Point.Y <> tc.Point.Y )) and ((tm.gat[tn.Point.X, tn.Point.Y] <> 1) and (tm.gat[tn.Point.X, tn.Point.Y] <> 5));

		tn.Dir := Random(8);
		tn.CType := NPC_TYPE_SCRIPT;
		tn.HungryTick := timeGettime();

		tm.NPC.AddObject(tn.ID, tn);
		tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.AddObject(tn.ID, tn);

		SendNData(tc.Socket, tn, tc.ver2 );
		SendBCmd(tm, tn.Point, 41, tc, False);

		tc.PetData := tpe;
		tc.PetNPC := tn;

		WFIFOW( 0, $01a4 );
		WFIFOB( 2, 0 );
		WFIFOL( 3, tn.ID );
		WFIFOL( 7, 0 );
		tc.Socket.SendBuf( buf, 11 );

		if tpe.Accessory <> 0 then begin
			WFIFOB( 2, 3 );
			WFIFOL( 7, tpe.Accessory );
			tc.Socket.SendBuf( buf, 11 );
		end;

		WFIFOB( 2, 5 );
		WFIFOL( 7, 20 ); // 謎
		tc.Socket.SendBuf( buf, 11 );

		WFIFOW( 0, $01a2 );
		WFIFOS( 2, tpe.Name, 24 );
		WFIFOB( 26, tpe.Renamed );
		WFIFOW( 27, tpe.LV );
		WFIFOW( 29, tpe.Fullness );
		WFIFOW( 31, tpe.Relation );
		WFIFOW( 33, tpe.Accessory );
		tc.Socket.SendBuf( buf, 35 );
	end;
end;
//------------------------------------------------------------------------------
{ChrstphrR 2004/04/28
If any of the current devs created this routine, it needs a fix...

Compiler warning: Variable "k" might not have been initialized.
Stuffing "k" without getting a value for it is a Bad Thing

This routine is THANKFULLY not called, because it would assuredly cause
AV errors, or at best, random, undefined results. It looks like the Character,
or Character index on the map would have to be passed as a parameter as well.
}
procedure SendMonsterRelocation(tm:TMap; ts:tMob);
var
  l,j,k :integer;
  xy  :TPoint;
  tc  :TChara;
begin
  //if ts.AData <> nil then tc := ts.AData
	for k := 0 to tm.Block[ts.Point.X div 8][ts.Point.Y div 8].CList.Count - 1 do begin
		tc := tm.Block[ts.Point.X div 8][ts.Point.Y div 8].CList.Objects[k] as TChara;

		WFIFOW( 0, $011a);
		WFIFOW( 2, 26);
		WFIFOW( 4, 1);
		WFIFOL( 6, ts.ID);
		WFIFOL(10, ts.ID);
		WFIFOB(14, 1);
		tc.Socket.SendBuf(buf, 15);
		UpdateMonsterDead(tm, ts, 0);
		//Delete block
		l := tm.Block[ts.Point.X div 8][ts.Point.Y div 8].MOB.IndexOf(ts.ID);
		if l <> -1 then begin
			tm.Block[ts.Point.X div 8][ts.Point.Y div 8].MOB.Delete(l);
		end;

		l := tm.MOB.IndexOf( ts.ID );
		if l <> -1 then begin
			tm.Mob.Delete(l);
		end;
		ts.ATarget := 0;
		ts.AData := nil;
		ts.AMode := 0;
		ts.MMode := 4;
		//ts.Free;
		j := 1;
		if l <> -1 then begin
			repeat
				xy.X := Random(tm.Size.X - 2) + 1;
				xy.Y := Random(tm.Size.Y - 2) + 1;
				Inc(j);
			until ( ((tm.gat[xy.X, xy.Y] <> 1) and (tm.gat[xy.X, xy.Y] <> 5)) or (j = 100) );
		ts.Point := xy;

		tm.Mob.AddObject(ts.ID, ts);
		tm.Block[ts.Point.X div 8][ts.Point.Y div 8].MOB.AddObject(ts.ID, ts);
		UpdateMonsterLocation(tm, ts);
		//SendNData(tc.Socket, tn, tc.ver2 );
		SendBCmd(tm, ts.Point, 41, tc, False);

		end;
	end;
end;

//------------------------------------------------------------------------------

procedure UpdateMonsterLocation(tm:TMap; ts:TMob);  //Update the location of a monster

begin
        WFIFOW(0, $0088);
        WFIFOL(2, ts.ID);
        WFIFOW(6, ts.Point.X);
        WFIFOW(8, ts.Point.Y);
        SendBCmd(tm, ts.Point, 10);
end;
//------------------------------------------------------------------------------

procedure UpdatePlayerLocation(tm:TMap; tc:TChara);  //Update the location of a Player

begin
        WFIFOW(0, $0088);
        WFIFOL(2, tc.ID);
        WFIFOW(6, tc.Point.X);
        WFIFOW(8, tc.Point.Y);
        SendBCmd(tm, tc.Point, 10);
end;

//------------------------------------------------------------------------------

procedure UpdateLivingLocation(tm:TMap; tv:TLiving);  //Update the location of a Living

begin
        WFIFOW(0, $0088);
        WFIFOL(2, tv.ID);
        WFIFOW(6, tv.Point.X);
        WFIFOW(8, tv.Point.Y);
        SendBCmd(tm, tv.Point, 10);
end;

//------------------------------------------------------------------------------
procedure  PetSkills(tc: TChara; Tick:cardinal);
var
//	tn:TNPC;
  tpe:TPet;
//	tm:TMap;
begin
//	tm := tc.MData;
//	tn := tc.PetNPC;
  tpe := tc.PetData;
  case tpe.JID of
    1011: {Chon Chon}
      begin
        //AGI + 4
        tc.Bonus[1] := tc.Bonus[1] + 4;
      end;
    1042: {Steel ChonChon}
      begin
        //AGI and VIT + 4
        tc.Bonus[1] := tc.Bonus[1] + 4;
        tc.Bonus[2] := tc.Bonus[2] + 4;
      end;
    1049: {Picky}
      begin
        //STR + 3
        tc.Bonus[0] := tc.Bonus[0] + 3;
      end;
    1052: {Rocker}
      begin
        //All Stats + 1
        //20040524 You were making everything equal to LUK bonus +1 - KyuubiKitsune
        tc.Bonus[0] := tc.Bonus[0] + 1;
        tc.Bonus[1] := tc.Bonus[1] + 1;
        tc.Bonus[2] := tc.Bonus[2] + 1;
        tc.Bonus[3] := tc.Bonus[3] + 1;
        tc.Bonus[4] := tc.Bonus[4] + 1;
        tc.Bonus[5] := tc.Bonus[5] + 1;
      end;
    1063: {Lunatic}
      begin
        //Luck + 3
        tc.Bonus[5] := tc.Bonus[5] + 3;
      end;
    1067: {Savage Bebe}
       begin
        //Vitality + 4
        tc.Bonus[2] := tc.Bonus[2] + 4;
      end;
    1109: {Deviruchi}
      begin
        //STR, AGI, DEX +6
        tc.Bonus[0] := tc.Bonus[0] + 6;
        tc.Bonus[1] := tc.Bonus[1] + 6;
        tc.Bonus[4] := tc.Bonus[4] + 6;
      end;
  end;
  SendCStat(tc);
end;
//------------------------------------------------------------------------------
procedure SendCStat(tc:TChara; View:boolean = false);
var
	i :integer;
begin
	//Speed
  SendCStat1(tc, 0, 0, tc.Speed);
	//HPSP
  SendCStat1(tc, 0, 5, tc.HP);
  SendCStat1(tc, 0, 6, tc.MAXHP);

  SendCStat1(tc, 0, 7, tc.SP);
  SendCStat1(tc, 0, 8, tc.MAXSP);

	// Update status points and points needed to level up.
	WFIFOW( 0, $00bd);
	WFIFOW( 2, tc.StatusPoint);
	for i := 0 to 5 do begin
		WFIFOB(i*2+4, tc.ParamBase[i]);
		WFIFOB(i*2+5, tc.ParamUp[i]);
	end;
	WFIFOW(16, tc.ATK[0][0]);
	WFIFOW(18, tc.ATK[1][0] + tc.ATK[0][4]);
	WFIFOW(20, tc.MATK2);
	WFIFOW(22, tc.MATK1);
	WFIFOW(24, tc.DEF1);
	WFIFOW(26, tc.DEF2);
	WFIFOW(28, tc.MDEF1);
	WFIFOW(30, tc.MDEF2);
	WFIFOW(32, tc.HIT);
	WFIFOW(34, tc.FLEE1);
	WFIFOW(36, tc.Lucky);
	WFIFOW(38, tc.Critical);
	WFIFOW(40, tc.ASpeed);
	WFIFOW(42, 0);
	tc.Socket.SendBuf(buf, 44);
	// Update base XP
  SendCStat1(tc, 1, 1, tc.BaseEXP);
  SendCStat1(tc, 1, $0016, tc.BaseNextEXP);

	// Update job XP
  SendCStat1(tc, 1, 2, tc.JobEXP);
  SendCStat1(tc, 1, $0017, tc.JobNextEXP);

	// Update Zeny
  SendCStat1(tc, 1, $0014, tc.Zeny);

  // Update weight
  SendCStat1(tc, 0, $0018, tc.Weight);
  SendCStat1(tc, 0, $0019, tc.MaxWeight);

  // Send status points.
	for i := 0 to 5 do begin
		WFIFOW( 0, $0141);
		WFIFOL( 2, 13+i);
		WFIFOL( 6, tc.ParamBase[i]);
		WFIFOL(10, tc.Bonus[i]);
		tc.Socket.SendBuf(buf, 14);
	end;
	// Send attack range.
	WFIFOW(0, $013a);
	WFIFOW(2, tc.Range);
	tc.Socket.SendBuf(buf, 4);

  // Update the character's view packets if necessary.
  if View then begin
    UpdateLook(tc.MData, tc, 3, tc.Head3, 0, true);
    UpdateLook(tc.MData, tc, 4, tc.Head1, 0, true);
    UpdateLook(tc.MData, tc, 5, tc.Head2, 0, true);
    if (tc.Shield <> 0) then begin
      UpdateLook(tc.MData, tc, 2, tc.WeaponSprite[0], tc.Shield);
    end else begin
      UpdateLook(tc.MData, tc, 2, tc.WeaponSprite[0], tc.WeaponSprite[1]);
    end;

  end;

end;
//------------------------------------------------------------------------------
procedure SendCStat1(tc:TChara; Mode:word; DType:word; Value:cardinal);
var
  i     :integer;
begin
	WFIFOW(0, $00b0 + Mode);
	WFIFOW(2, DType);
	WFIFOL(4, Value);

    if tc.login <> 0 then begin
    	try
			tc.Socket.SendBuf(buf, 8);
        except
            //debugout.lines.add('socket not assigned');
        end;
    end else begin
    	//debugout.lines.add('disconnected');
    end;
        
{パーティー機能追加}
	//ステータスの更新時にHPバーの情報も更新する
	if (tc.PartyName <> '') and (Mode = 0) and ((DType = 5) or (DType = 6)) then begin
		WFIFOW( 0, $0106);
		WFIFOL( 2, tc.ID);
		WFIFOW( 6, tc.HP);
		WFIFOW( 8, tc.MAXHP);
		SendPCmd(tc, 10, true, true);
	end;
  // Colus, 20040317: This is the best place to do overweight icons.
  if (Mode = 0) and ((DType = $0018) or (DType = $0019)) then begin
    i := tc.Weight * 100 div tc.MaxWeight;

    if (i >= 50) and (i < 90) then begin
      UpdateIcon(tc.MData, tc, 35, 1);
    end else begin
      UpdateIcon(tc.MData, tc, 35, 0);
    end;

    if (i >= 90) then begin
      UpdateIcon(tc.MData, tc, 36, 1);
    end else begin
      UpdateIcon(tc.MData, tc, 36, 0);
    end;

  end;

{パーティー機能追加ココまで}
end;
//------------------------------------------------------------------------------
procedure SendCData(tc1:TChara; tc:TChara; Use0079:boolean = false);
{ギルド機能追加}
var
	j   :integer;
	w   :word;
	tg  :TGuild;
{ギルド機能追加ココまで}
begin
	ZeroMemory(@buf[0], 54);




    // Alex: switched 01d9/01d8 to 0079/0078 to reenabled lower dyes. Wonder why
    // it was changed.

	if Use0079 then begin
        WFIFOW(0, $0079);
		//WFIFOW(0, $01d9); //0079->01d9
	end else begin
    	WFIFOW(0, $0078);
		//WFIFOW(0, $01d8); //0078->01d8
	end;
	WFIFOL( 2, tc.ID);
	WFIFOW( 6, tc.Speed);
{追加}
	WFIFOW( 8, tc.Stat1);
	WFIFOW(10, tc.Stat2);
{追加ココまで}
	WFIFOW(12, tc.Option);
	WFIFOW(14, tc.JID);
	WFIFOW(16, tc.Hair);
	WFIFOW(18, tc.WeaponSprite[0]); // Weapon->WeaponSprite[0];

	//WFIFOW(20, tc.WeaponSprite[1]); // Head3->WeaponSprite[1];
	//WFIFOW(22, tc.Head3); // Shield -> Head3

    WFIFOW(20, tc.Head3); // Shield -> Head3
    WFIFOW(22, tc.WeaponSprite[1]); // Head3->WeaponSprite[1];

	WFIFOW(24, tc.Head1);
	WFIFOW(26, tc.Head2);
	WFIFOW(28, tc.HairColor);
	WFIFOW(30, tc.ClothesColor);
	WFIFOW(32, tc.HeadDir);
{ギルド機能追加}
	WFIFOL(34, tc.GuildID); //GuildID.L
	w := 0;
	if (tc.GuildID <> 0) then begin
		j := GuildList.IndexOf(tc.GuildID);
		if (j <> -1) then begin
			tg := GuildList.Objects[j] as TGuild;
			w := tg.Emblem;
		end;
	end;
	WFIFOL(38, w); //EmblemID.L
	WFIFOW(42, tc.Manner); //.W?
	WFIFOB(44, tc.Karma); //.B?
{ギルド機能追加ココまで}
	WFIFOB(45, tc.Gender);
	WFIFOM1(46, tc.Point, tc.Dir);
	WFIFOB(49, 5);
	WFIFOB(50, 5);
{修正}
	if Use0079 then begin
{追加}
    {Colus, 20040115: Aura fix for >99 levels}
    if (tc.BaseLV > 99) then begin
 	  	WFIFOW(51, 99);
    end else begin
      WFIFOW(51, tc.BaseLV);
    end;

{追加ココまで}
		if tc.Socket <> nil then begin
                        if tc1.Login > 0 then begin
        			if tc.ver2 = 9 then tc1.Socket.SendBuf(buf, 53)	//Kr?
	        		else                tc1.Socket.SendBuf(buf, 51); //Jp
                        end;
		end;
	end else begin
		WFIFOB(51, tc.Sit);
{追加}
    {Colus, 20040115: Aura fix for >99 levels}
    if (tc.BaseLV > 99) then begin
	  	WFIFOW(52, 99);
    end else begin
      WFIFOW(52, tc.BaseLV);
    end;

{追加ココまで}
		if tc.Socket <> nil then begin
                        if tc1.Login > 0 then begin
        			if tc.ver2 = 9 then tc1.Socket.SendBuf(buf, 54)	//Kr?
	        		else                tc1.Socket.SendBuf(buf, 52); //Jp
                        end;
		end;
	end;
{ココまで}
{パーティー機能追加}
	if tc.PartyName <> '' then begin
	//パーティーメンバーにHPバーを表示させる
	WFIFOW( 0, $0106);
	WFIFOL( 2, tc.ID);
	WFIFOW( 6, tc.HP);
	WFIFOW( 8, tc.MAXHP);
	SendPCmd(tc, 10, true, true);

	//パーティーメンバーの位置表示
	WFIFOW( 0, $0107);
	WFIFOL( 2, tc.ID);
	WFIFOW( 6, tc.Point.X);
	WFIFOW( 8, tc.Point.Y);
	SendPCmd(tc, 10, true, true);
  end;
{パーティー機能追加ココまで}
end;
//------------------------------------------------------------------------------
procedure SendCMove(Socket: TCustomWinSocket; tc:TChara; before, after:TPoint);
{ギルド機能追加}
var
	j   :integer;
	w   :word;
	tg  :TGuild;
	//Tick :cardinal;
{ギルド機能追加ココまで}
begin
	//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('S 007b %s (%d,%d)-(%d,%d)', [tc.Name, before.X, before.Y, after.X, after.Y]));
	ZeroMemory(@buf[0], 60);

    // Alex: switched 01da to 007b to reenabled lower dyes. Wonder why
    // it was changed.

	WFIFOW( 0, $007b);  // 007b -> 01da
	//WFIFOW( 0, $01da);
	
	WFIFOL( 2, tc.ID);
	WFIFOW( 6, tc.Speed);
{追加}
	WFIFOW( 8, tc.Stat1);
	WFIFOW(10, tc.Stat2);
{追加ココまで}
	WFIFOW(12, tc.Option);
	WFIFOW(14, tc.JID);
	WFIFOW(16, tc.Hair);
	WFIFOW(18, tc.WeaponSprite[0]);  // Weapon->WeaponSprite[0]

	//WFIFOW(20, tc.WeaponSprite[1]); //Head3->WeaponSprite[1]
	//WFIFOW(22, tc.Head3); // time -> Shield
	//WFIFOL(24, timeGetTime()); // Shield -> time

	WFIFOW(20, tc.Head3); // time -> Shield
	WFIFOL(22, timeGetTime()); // Shield -> time
    WFIFOW(26, tc.WeaponSprite[1]); //Head3->WeaponSprite[1]

	WFIFOW(28, tc.Head1);
	WFIFOW(30, tc.Head2);
	WFIFOW(32, tc.HairColor);
	WFIFOW(34, tc.ClothesColor);
	WFIFOW(36, tc.HeadDir);
{ギルド機能追加}
	WFIFOL(38, tc.GuildID); //GuildID.L
	w := 0;
	if (tc.GuildID <> 0) then begin
		j := GuildList.IndexOf(tc.GuildID);
		if (j <> -1) then begin
			tg := GuildList.Objects[j] as TGuild;
			w := tg.Emblem;
		end;
	end;
	WFIFOL(42, w); //EmblemID.L
	WFIFOW(46, tc.Manner); //.W?
	WFIFOB(48, tc.Karma); //.B?
{ギルド機能追加ココまで}
	WFIFOB(49, tc.Gender);
	WFIFOM2(50, after, before);
	WFIFOB(56, 5);
	WFIFOB(57, 5);
{追加}
  {Colus, 20040115: Aura fix for >99 levels}
  if (tc.BaseLV > 99) then begin
 		WFIFOW(58, 99);
  end else begin
    WFIFOW(58, tc.BaseLV);
  end;

{追加ココまで}
{修正}
	if tc.ver2 = 9 then Socket.SendBuf(buf, 60)  //Kr?
	else                Socket.SendBuf(buf, 58); //Jp
{修正ココまで}
	//WFIFOW( 0, $007f);
	//WFIFOL( 2, timeGetTime()+1000);
	//Socket.SendBuf(buf, 6);
end;
//------------------------------------------------------------------------------
procedure SendCLeave(tc:TChara; mode:byte);
var
	i, j, k :integer;
	tm      :TMap;
	tc1     :TChara;
	mi      :MapTbl;
{キューペット}
	tn      :TNPC;
{キューペットここまで}
begin
{パーティー機能追加}
	//位置マークの削除方法がわからなかったので
	//マップから離れるときに(0,0)にいるという情報を送ってごまかしている
	if tc.PartyName <> '' then begin
		WFIFOW( 0, $0107);
		WFIFOL( 2, tc.ID);
		WFIFOW( 6, 0);
		WFIFOW( 8, 0);
		SendPCmd(tc,10,true,true);
	end;


{パーティー機能追加ココまで}
	tc.Login := 1; //ロード中に切り替え
	tc.pcnt := 0;
	tc.AMode := 0;
	tc.MMode := 0;
	tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
	mi := MapInfo.Objects[MapInfo.IndexOf(tm.Name)] as MapTbl;
{キューペット}
	if ( tc.PetData <> nil ) and ( tc.PetNPC <> nil ) then begin
		tn := tc.PetNPC;

		WFIFOW( 0, $0080 );
		WFIFOL( 2, tn.ID );
		WFIFOB( 6, 0 );
		SendBCmd( tm, tn.Point, 7 ,tc);


		//ペット削除
		i := tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.IndexOf(tn.ID);
		if i <> -1 then begin
			tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.Delete(i);
		end;

		i := tm.NPC.IndexOf( tn.ID );
		if i <> -1 then begin
			tm.NPC.Delete(i);
		end;

		tn.Free;
		tc.PetNPC := nil;
	end;
{キューペットここまで}

{チャットルーム機能追加}
	//入室中メンバーの削除処理
	if (tc.ChatRoomID <> 0) then begin
		if (mode = 2) then ChatRoomExit(tc, true)
		else ChatRoomExit(tc);
		tc.ChatRoomID := 0;
	end;
{チャットルーム機能追加ココまで}
{露店スキル追加}
	//露店を終了する
	if (tc.VenderID <> 0) then begin
		if (mode = 2) then VenderExit(tc, true)
		else VenderExit(tc);
		tc.VenderID := 0;
	end;
{露店スキル追加ココまで}
{取引機能追加}
	if (tc.DealingID <> 0) then begin
		if (mode = 2) then CancelDealings(tc, true)
		else CancelDealings(tc);
		tc.DealingID := 0;
		tc.PreDealID := 0;
	end;
{取引機能追加ココまで}
{ギルド機能追加}
	//メンバーに通知
	WFIFOW( 0, $016d);
	WFIFOL( 2, tc.ID);
	WFIFOL( 6, tc.CID);
	WFIFOL(10, 0);
	SendGuildMCmd(tc, 14, true);
{ギルド機能追加ココまで}

	if tm.Clist.IndexOf(tc.ID) <> -1 then begin //二重処理はしない
		//ブロック処理
		WFIFOW(0, $0080);
		WFIFOL(2, tc.ID);
		WFIFOB(6, mode);
		for j := tc.Point.Y div 8 - 2 to tc.Point.Y div 8 + 2 do begin
			for i := tc.Point.X div 8 - 2 to tc.Point.X div 8 + 2 do begin
				//周りの人にログアウト通知
				for k := 0 to tm.Block[i][j].CList.Count - 1 do begin
					tc1 := tm.Block[i][j].CList.Objects[k] as TChara;
					if (tc <> tc1) and (abs(tc.Point.X - tc1.Point.X) < 16) and
					(abs(tc.Point.Y - tc1.Point.Y) < 16) then tc1.Socket.SendBuf(buf, 7);
 				end;
			end;
		end;
		//if (mi.noPvP = false) then begin
		//for j := 0 to tm.CList.Count - 1 do begin
		//tc1 := tm.CList.Objects[j] as TChara;
		//WFIFOW( 0, $0199);
		//WFIFOW( 2, 1);
		//tc1.Socket.SendBuf(buf, 4);
		//k := j + 1;
		//i := tm.CList.Count - 1;
		//WFIFOW( 0, $019a);
		//WFIFOL( 2, tc1.ID);
		//WFIFOL( 6, k);
		//WFIFOL( 10, i);
		//tc1.Socket.SendBuf(buf, 14);
		//end;
		//end;

		//マップから自分のデータを消去
		tm.CList.Delete(tm.Clist.IndexOf(tc.ID));
		with tm.Block[tc.Point.X div 8][tc.Point.Y div 8] do begin
			if Clist.IndexOf(tc.ID) <> -1 then
				CList.Delete(Clist.IndexOf(tc.ID));
		end;
		if CharaPID.IndexOf(tc.ID) <> -1 then
			CharaPID.Delete(CharaPID.IndexOf(tc.ID));
	end;
end;
//------------------------------------------------------------------------------
procedure SendBCmd(tm:TMap; Point:TPoint; PacketLen:word; tc:TChara = nil; tail:boolean = False);
var
	i, j, k :integer;
	tc1     :TChara;
begin

  {Colus, 20040116: It had two X-checks instead of X and Y.}
  if (Point.X >= 0) and (Point.X <= 511) and
     (Point.Y >= 0) and (Point.Y <= 511) then begin

	for j := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
		for i := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
			//周囲の人に通知(tc <> nilの場合は自分を除く)
			if assigned(tm) then begin // AlexKreuz
					if assigned(tm.Block[i][j]) then begin
						for k := 0 to tm.Block[i][j].CList.Count - 1 do begin
							tc1 := tm.Block[i][j].CList.Objects[k] as TChara;

							if tc1 = nil then continue;
							if (tc = nil) or (tc <> tc1) then begin
								if (abs(Point.X - tc1.Point.X) < 50) and (abs(Point.Y - tc1.Point.Y) < 50) then begin
									if tail and (tc1.Stat2 = 9) then begin
										tc1.Socket.SendBuf(buf, (PacketLen+2));
									end else begin
										tc1.Socket.SendBuf(buf, PacketLen);
									end;
								end;
							end;
						end;
{修正ココまで}
					end;
				end;
			end;
		end;
	end

	else begin
		debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Attempted Battle Command Crash. Temporary Bypass. -AlexKreuz');
	end;
end;

//------------------------------------------------------------------------------

procedure SendCAttack1(tc:TChara; dmg0:integer; dmg1:integer; dmg4:integer; dmg5:integer; tm:TMap; ts:TMob; Tick:cardinal);
begin
  with tc do begin
    WFIFOW( 0, $008a);
    WFIFOL( 2, ID);
    WFIFOL( 6, ATarget);
    WFIFOL(10, Tick);
    WFIFOL(14, aMotion);
    WFIFOL(18, ts.Data.dMotion);
    WFIFOW(22, dmg0); //Right Hand Damage
    WFIFOW(24, dmg4); //Number of Hits that make up total damage
    WFIFOB(26, dmg5); //Attack Values: 0= Single 8= Multiple 10= Critical
    WFIFOW(27, dmg1); //Left Hand Damage
    SendBCmd(tm, ts.Point, 29);
  end;
end;

procedure SendMAttack(tm:TMap; ts:TMob; tc:TChara; dmg0:integer; dmg4:integer; dmg5:integer; Tick:cardinal);

begin
  with ts do begin
    WFIFOW( 0, $008a);
    WFIFOL( 2, ID);
    WFIFOL( 6, ATarget);
    WFIFOL(10, Tick);
    WFIFOL(14, ts.Data.aMotion);
    WFIFOL(18, tc.dMotion);
    WFIFOW(22, dmg0);
    WFIFOW(24, dmg4);
    // 4->9 for Endure damage, allow lucky hit gfx
    if ((tc.dMotion = 0) and (dmg5 <> 11)) then dmg5 := 9;

    WFIFOB(26, dmg5);
    WFIFOW(27, 0);
    SendBCmd(tm, tc.Point, 29);
    if dmg0 > 0 then //Debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Monster''''s Attack Deals ' + IntToStr(dmg0) + ' Damage');
  end;
end;
//------------------------------------------------------------------------------
procedure CalcSkillTick(tm:TMap; tc:TChara; Tick:cardinal = 0);
var
	i :integer;
begin
	if Tick = 0 then Tick := timeGetTime();
	with tc do begin
		SkillTick := $FFFFFFFF;
		for i := 1 to 330 do begin
			if Skill[i].Tick > Tick then begin
				if SkillTick > Skill[i].Tick then begin
					SkillTick := Skill[i].Tick;
					SkillTickID := i;
				end;
			end;
		end;
	end;
end;

procedure SendCGetItem(tc:TChara; Index:word; Amount:word);
begin
	WFIFOW( 0, $00a0);
	WFIFOW( 2, Index);
	WFIFOW( 4, Amount);
	WFIFOW( 6, tc.Item[Index].ID);
	WFIFOB( 8, tc.Item[Index].Identify);
	WFIFOB( 9, tc.Item[Index].Attr);
	WFIFOB(10, tc.Item[Index].Refine);
	WFIFOW(11, tc.Item[Index].Card[0]);
	WFIFOW(13, tc.Item[Index].Card[1]);
	WFIFOW(15, tc.Item[Index].Card[2]);
	WFIFOW(17, tc.Item[Index].Card[3]);
	with tc.Item[Index].Data do begin
		if (tc.JID = 12) and (IType = 4) and (Loc = 2) and
			 ((View = 1) or (View = 2) or (View = 6)) then
			WFIFOW(19, 34)
		else
			WFIFOW(19, Loc);
		WFIFOB(21, IType);
	end;
	WFIFOB(22, 0);
	tc.Socket.SendBuf(buf, 23);
end;
//------------------------------------------------------------------------------
procedure SendCStoreList(tc:TChara);
var
	i,j :integer;
	cnt :word;
	tp  :TPlayer;
begin
	tp := tc.PData;
	with tp do begin
		cnt := 0;
		//アイテムデータ
		WFIFOW(0, $00a5);
		j := 0;
		for i := 1 to 100 do begin

			if (tp.Kafra.Item[i].ID <> 0) then begin
                if (not tp.Kafra.Item[i].Data.IEquip) then begin
    				WFIFOW( 4 +j*10, i);
	    			WFIFOW( 6 +j*10, tp.Kafra.Item[i].Data.ID);
		    		WFIFOB( 8 +j*10, tp.Kafra.Item[i].Data.IType);
			    	WFIFOB( 9 +j*10, tp.Kafra.Item[i].Identify);
				    WFIFOW(10 +j*10, tp.Kafra.Item[i].Amount);
    				if tp.Kafra.Item[i].Data.IType = 10 then
	    				WFIFOW(12 +j*10, 32768)
		    		else
			    		WFIFOW(12 +j*10, 0);
				    Inc(j);
    				Inc(cnt);
                end;
			end;
		end;
		WFIFOW(2, 4+j*10);
		tc.Socket.SendBuf(buf, 4+j*10);
		//装備データ
		WFIFOW(0, $00a6);
		j := 0;
		for i := 1 to 100 do begin
			if (tp.Kafra.Item[i].ID <> 0) then begin
                if (tp.Kafra.Item[i].Data.IEquip) then begin
    				WFIFOW( 4 +j*20, i);
	    			WFIFOW( 6 +j*20, tp.Kafra.Item[i].Data.ID);
		    		WFIFOB( 8 +j*20, tp.Kafra.Item[i].Data.IType);
			    	WFIFOB( 9 +j*20, tp.Kafra.Item[i].Identify);
				    with tp.Kafra.Item[i].Data do begin
    					if (tc.JID = 12) and (IType = 4) and (Loc = 2) and
	    					 ((View = 1) or (View = 2) or (View = 6)) then
		    				WFIFOW(10 +j*20, 34)
			    		else
				    		WFIFOW(10 +j*20, Loc);
    				end;
	    			WFIFOW(12 +j*20, tp.Kafra.Item[i].Equip);
		    		WFIFOB(14 +j*20, tp.Kafra.Item[i].Attr);
			    	WFIFOB(15 +j*20, tp.Kafra.Item[i].Refine);
				    WFIFOW(16 +j*20, tp.Kafra.Item[i].Card[0]);
    				WFIFOW(18 +j*20, tp.Kafra.Item[i].Card[1]);
	    			WFIFOW(20 +j*20, tp.Kafra.Item[i].Card[2]);
		    		WFIFOW(22 +j*20, tp.Kafra.Item[i].Card[3]);
			    	Inc(j);
				    Inc(cnt);
                end;
			end;
		end;
		WFIFOW(2, 4+j*20);
		tc.Socket.SendBuf(buf, 4+j*20);
		//個数表示
		tp.Kafra.Count := cnt;
		WFIFOW(0, $00f2);
		WFIFOW(2, tp.Kafra.Count);
		WFIFOW(4, 100);
		tc.Socket.SendBuf(buf, 6);
	end;
end;
//------------------------------------------------------------------------------
procedure SendCSkillList(tc:TChara);
var
	i, j, k :integer;
	b       :byte;
  JIDFix     :word; // JID correction.
begin
  JIDFix := tc.JID;
  if (JIDFix > UPPER_JOB_BEGIN) then JIDFix := JIDFix - UPPER_JOB_BEGIN + LOWER_JOB_END; // (RN 4001 - 4000 + 23 = 24
  //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('JID = %d',[JID]));
	//スキル送信
	WFIFOW( 0, $010f);
	j := 0;
	for i := 1 to MAX_SKILL_NUMBER do begin
		//if (not tc.Skill[i].Data.Job[tc.JID]) and (not DisableSkillLimit) then continue;
		if ((not (tc.Skill[i].Data.Job1[JIDFix])) and (not (tc.Skill[i].Data.Job2[JIDFix])) and (not tc.Skill[i].Card) and (not tc.Skill[i].Plag) and (not DisableSkillLimit)) then continue;

                if tc.Skill[i].Plag then tc.Skill[i].Lv := tc.PLv;
    //if (tc.Skill[i].Data.Job1[JID]) then debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('Skill %d is true for JID %d',[i, JID]));
		WFIFOW( 0+37*j+4, i);
		WFIFOW( 2+37*j+4, tc.Skill[i].Data.SType);
		WFIFOW( 4+37*j+4, 0);
		WFIFOW( 6+37*j+4, tc.Skill[i].Lv);

		if tc.Skill[i].Lv <> 0 then
			WFIFOW( 8+37*j+4, tc.Skill[i].Data.SP[tc.Skill[i].Lv])
		else
			WFIFOW( 8+37*j+4, tc.Skill[i].Data.SP[1]);
		WFIFOW(10+37*j+4, tc.Skill[i].Data.Range);
		WFIFOS(12+37*j+4, tc.Skill[i].Data.IDC, 24);
		b	:= 0;
		if tc.Skill[i].Card and (not DisableSkillLimit) then begin
			b := 0;
    end else if tc.Skill[i].Plag and (not DisableSkillLimit) then begin
      b := 0;
		end else if tc.Skill[i].Lv = tc.Skill[i].Data.MasterLV then begin
			b := 0;
		end else if (tc.Skill[i].Data.MasterLV <> 0) then begin
			b := 1;
			for k := 0 to 4 do begin
                if tc.Skill[i].Data.Job1[JIDFix] and (tc.Skill[i].Data.ReqSkill1[k] <> 0) and (tc.Skill[tc.Skill[i].Data.ReqSkill1[k]].Lv < tc.Skill[i].Data.ReqLV1[k]) then begin
					b := 0;
					continue;
				end;
			end;
      if (b <> 0) then begin
        for k := 0 to 4 do begin
                if tc.Skill[i].Data.Job2[JIDFix] and (tc.Skill[i].Data.ReqSkill2[k] <> 0) and (tc.Skill[tc.Skill[i].Data.ReqSkill2[k]].Lv < tc.Skill[i].Data.ReqLV2[k]) then begin
					b := 0;
					continue;
				end;
			end;
		end;
		end;
		WFIFOB(36+37*j+4, b);
		Inc(j);
	end;
                
	WFIFOW( 2, 4+37*j);
	tc.Socket.SendBuf(buf, 4+37*j);

	// Update number of skillpoints.
  SendCStat1(tc, 0, $000c, tc.SkillPoint);
end;
//------------------------------------------------------------------------------
{追加} //イグ葉やアンティペインメント等用
procedure SendItemSkill(tc:TChara; s:Cardinal; L:Cardinal = 1);
var
	tl:TSkillDB;
begin
	tl := SkillDB.IndexOfObject(s) as TSkillDB;
	if tl = nil then Exit;
	if tl.MasterLV < L then L := tl.MasterLv
	else if L < 1 then L := 1;
	WFIFOW( 0, $0147);
	WFIFOW( 2, s);
	WFIFOW( 4, tl.SType);
	//WFIFOW( 6, L);
	//WFIFOW( 8, tl.SP[L]);
	//WFIFOW(10, tl.Range);
	//WFIFOS(12, tl.IDC, 24);
	//WFIFOB(36, 0);
	//tc.Socket.SendBuf(buf, 37);
        WFIFOW( 6, 0);
        WFIFOW( 8, L);
	WFIFOW(10, tl.SP[L]);
	WFIFOW(12, tl.Range);
	WFIFOS(14, tl.IDC, 24);
	WFIFOB(38, 0);
	tc.Socket.SendBuf(buf, 39);
	tc.ItemSkill := True;

    // To make sure that Leaf of Yggdrasil does not use up a blue gemstone.
    if (tl.ID = 54) then tc.NoJamStone := True;
end;

//------------------------------------------------------------------------------
procedure SendSkillError(tc:TChara; EType:byte; BType:word = 0);
begin
  {Colus, 20040116: This is how it works.
    R 0110 <skill ID>.w <basic type>.w ?.w <fail>.B <type>.B

    	Result of trying to use a skill.

	When fail=00, the skill could not be used.   (So, always 0...)
  The ?.w is also always 0.

  What's left?  Skill, basic type, and type.
  When type is 0, then the message is determined by the basictype variable.

	type 00: basic type skill
	type 01: Not enough SP
	type 02: Not enough HP
	type 03: No memo
	type 04: In cast delay
	type 05: Not enough money (Mammonite)
	type 06: Weapon is not usable with the skill
	type 07: No red gemstone
	type 08: No blue gemstone
	type 09: Unknown.  (GUESS: 'No yellow gemstone', maybe?)

  When type is 00, basic type is looked at:
	basic type=00: Trade
	basic type=01: Emotion
	basic type=02: Sit
	basic type=03: Chat
	basic type=04: Party
	basic type=05: Shout(?)
	basic type=06: PK
	basic type=07: Manner Point

  Now there are some other types of messages that we are going to parse.
  Messages such as overweight, arrows need equipping, etc. are done with
  013b.  We'll signify those by adding 20 to the parameter passed in.

  I think these are the 013b following codes and values:

  0 - Equip arrows first (?)
  1 - Can't attack b/c of weight (?)
  2 - Can't skill b/c of weight.
  3 - Arrows equipped.

  }
	with tc do begin
    if (EType < 20) then begin
      WFIFOW( 0, $0110);
  		WFIFOW( 2, MSkill);
  		WFIFOW( 4, BType);
  		WFIFOW( 6, 0);
  		WFIFOB( 8, 0);
  		WFIFOB( 9, EType);
      Socket.SendBuf(buf, 10);
    end else begin
      WFIFOW(0, $013b);
      WFIFOW(2, EType - 20);
      Socket.SendBuf(buf, 4);
    end;
    {
		case EType of
			1: // No SP
				begin
					WFIFOW( 0, $0110);
					WFIFOW( 2, MUseLV);
					WFIFOW( 4, 0);
					WFIFOW( 6, 0);
					WFIFOB( 8, 0);
					WFIFOB( 9, 1);
					Socket.SendBuf(buf, 10);
				end;
			2: //Overweight msg.  We need to handle this separately?
				begin
					WFIFOW(0, $013b);
					WFIFOW(2, 2);
					Socket.SendBuf(buf, 4);
				end;
			3: // Not enough money for Mammonite
				begin
					WFIFOW( 0, $0110);
					WFIFOW( 2, tc.MUseLV);
					WFIFOW( 4, 0);
					WFIFOW( 6, 0);
					WFIFOB( 8, 0);
					WFIFOB( 9, 5);
					Socket.SendBuf(buf, 10);
				end;
			else //何も無し
		end; }
	end;
end;
//------------------------------------------------------------------------------
procedure SendItemError(tc:TChara; Code:Cardinal);
{
  type 00: basic type skill
	type 01: Not enough SP
	type 02: Not enough HP
	type 03: No memo
	type 04: In cast delay
	type 05: Not enough money (Mammonite)
	type 06: Weapon is not usable with the skill
	type 07: No red gemstone
	type 08: No blue gemstone
	type 09: Unknown.  (GUESS: 'No yellow gemstone', maybe?)
}
begin
        with tc do begin
                WFIFOW( 0, $0110);
                WFIFOW( 2, MSkill);
                WFIFOW( 4, 0);
                WFIFOW( 6, 0);
                WFIFOB( 8, 0);
                WFIFOB( 9, Code);
                Socket.SendBuf(buf, 10);
        end;
                
end;
//------------------------------------------------------------------------------
function UseFieldSkill(tc:TChara; Tick:Cardinal) : Integer;
var
	tm:TMap;
	tc1:TChara;
	ts:TMob;
	tl:TSkillDB;
	i:Integer;
begin
	Result := 0;
	tm := tc.MData;
	with tc do begin
                //Reset Grace Tick
                GraceTick := Tick;
                
                if tc.isSilenced then begin
                        SilenceCharacter(tm, tc, Tick);
                        Exit;
                end;

		if (tc.Skill[tc.MSkill].Lv >= tc.MUseLV) and (tc.MUseLV > 0) then begin
			tl := tc.Skill[tc.MSkill].Data;

            if (tc.MSkill = 18) and (FireWallCount = 9) then begin
                SendSkillError(tc, 0);
                Exit;
            end;

			if tc.SP < tl.SP[tc.MUseLV] then begin
				//SP不足
				Result := 1;
				Exit;
			end;
			if tc.Weight * 100 div tc.MaxWeight >= 90 then begin
				Result := 22;
				Exit;
			end;
			if tm.Mob.IndexOf(tc.MTarget) <> -1 then begin
				ts := tm.Mob.IndexOfObject(tc.MTarget) as TMob;
				if ts.HP = 0 then Exit;
				tc.MTargetType := 0;
				tc.AData := ts;
			end else if tm.CList.IndexOf(tc.MTarget) <> -1 then begin
				tc1 := tm.CList.IndexOfObject(tc.MTarget) as TChara;
				tc.MTargetType := 1;
				tc.AData := tc1;
			end else begin
				tc1 := tc;
				tc.MTargetType := 1;
				tc.AData := tc1;
			end;
			tc.pcnt := 0;
			if (tc.AMode = 1) or (tc.AMode = 2) then tc.AMode := 0;
			with tc.Skill[tc.MSkill] do begin
				i := Data.CastTime1 + Data.CastTime2 * tc.MUseLV;
				if i < Data.CastTime3 then i := Data.CastTime3;
			end;
			i := i * tc.MCastTimeFix div 100;
			if i > 0 then begin
				//詠唱開始
				WFIFOW( 0, $013e);
				WFIFOL( 2, tc.ID);
				WFIFOL( 6, 0);
				WFIFOW(10, tc.MPoint.X);
				WFIFOW(12, tc.MPoint.Y);
				WFIFOW(14, tc.MSkill); //SkillID
				WFIFOL(16, tl.Element); //Element
				WFIFOL(20, i);
				SendBCmd(tm, tc.Point, 24);
				tc.MMode := 2;
                {Free Cast Mods}
                if tc.Skill[278].Lv <> 0 then begin
                    tc.Speed := tc.Speed + (tc.Speed * tc.Skill[278].Data.Data1[tc.MUseLV]);
                    tc.ASpeed := tc.ASpeed + (tc.ASpeed * tc.Skill[278].Data.Data2[tc.MUseLV]);
                    tc.StatRecalc := true;
                end;
				tc.MTick := Tick + cardinal(i);
			end else begin
				//詠唱なし
				tc.MMode := 2;
				tc.MTick := Tick;
			end;
		end;
	end;
end;
//------------------------------------------------------------------------------
function UseTargetSkill(tc:TChara; Tick:Cardinal) : Integer;
var
	tm:TMap;
	tc1:TChara;
	ts:TMob;
	tl:TSkillDB;
	i:Integer;
  w,w2:word;
begin
	Result := 0;
	tm := tc.MData;
	with tc do begin
                //Reset Grace Tick
                GraceTick := Tick;

                if tc.isSilenced then begin
                        SilenceCharacter(tm, tc, Tick);
                        Exit;
                end;
		tl := tc.Skill[tc.MSkill].Data;

		if (tc.SP < tl.SP[tc.MUseLV]) and (tc.ItemSkill = false) and
     (((tc.MSkill <> 51) and (tc.MSkill <> 135)) or
      (((tc.MSkill = 51) or (tc.MSkill = 135)) and (tc.Option and 6 = 0))) then begin
			//SP不足
			Result := 1;
			Exit;
		end;


		if tc.Weight * 100 div tc.MaxWeight >= 90 then begin
			//重量オーバー
			Result := 22;
			Exit;
		end;

                //Grand Cross No Interrupt
                if tc.MSkill = 254 then tc.NoCastInterrupt := True;

		if (tc.MSkill = 42) and (tc.Zeny < cardinal(tl.Data2[tc.MUseLV])) then begin
			//金欠メマー
			Result := 5;
			Exit;
		end;

		if tm.Mob.IndexOf(tc.MTarget) <> -1 then begin
			ts := tm.Mob.IndexOfObject(tc.MTarget) as TMob;
			if ts.HP = 0 then Exit;
			tc.MTargetType := 0;
			tc.AData := ts;
      // Colus, 20040306: Steal should not make anybody want to attack you.
			if (ts.ATarget = 0) and Boolean(ts.Data.Mode and $10) and (tc.MSkill <> 50) then begin

				ts.ATarget := ID;
				ts.AData := tc;
				ts.isLooting := False;
				ts.ATick := Tick + aMotion;
			end;

		end else if (tc.MSkill = 41) then begin //露店開設
			i := tl.Data1[tc.Skill[41].Lv];
			if (i >= 3) and (i <= 12) then begin
				if (DecSP(tc, 41, Skill[41].Lv) = true) then begin
					//露店最大アイテム数応答
					WFIFOW(0, $012d);
					WFIFOW(2, i);
					Socket.SendBuf(buf, 4);
				end;
			end;


		end else if tm.CList.IndexOf(tc.MTarget) <> -1 then begin
			tc1 := tm.CList.IndexOfObject(tc.MTarget) as TChara;
			tc.MTargetType := 1;
			tc.AData := tc1;
		end else begin
			tc1 := tc;
			tc.MTargetType := 1;
			tc.AData := tc1;
		end;
		tc.pcnt := 0;
		if (tc.AMode = 1) or (tc.AMode = 2) then tc.AMode := 0;

    if (tc.MSkill =  153) then begin  {Cart Revolution}
      // Colus, 20040125: Fixing Option for Cart Rev
      w := tc.Option and $0788;  // Got a cart?
      w2 := tc.Option and 6; // Not hidden or cloaked?
      if ((w = 0) or (w2 <> 0)) then exit;

    end;
                 
		if tc.MSkill =	26 then begin //テレポート
			//選択
			ZeroMemory(@buf[0], 68);
			WFIFOW( 0, $011c);
			WFIFOW( 2, 26);
			WFIFOS( 4, 'Random', 16);
			if tc.Skill[26].Lv = 2 then
				WFIFOS(20, tc.SaveMap + '.gat', 16);
			Socket.SendBuf(buf, 68);
			WFIFOW( 0, $011a);
			WFIFOW( 2, 26);
			WFIFOW( 4, tc.Skill[26].Lv);
			WFIFOL( 6, tc.ID);
			WFIFOL(10, tc.ID);
			WFIFOB(14, 1);
			Socket.SendBuf(buf, 15);
		end else begin
			with tc.Skill[tc.MSkill] do begin
				i := Data.CastTime1 + Data.CastTime2 * tc.MUseLV;
				if i < Data.CastTime3 then i := Data.CastTime3;
			end;
			i := i * tc.MCastTimeFix div 100;
			if (i > 0) or (tc.ItemSkill = true) or (tc.MSkill = 271) then begin
				//詠唱開始
				WFIFOW( 0, $013e);
				WFIFOL( 2, tc.ID);
				WFIFOL( 6, tc.MTarget);
				WFIFOW(10, 0);
				WFIFOW(12, 0);
				WFIFOW(14, tc.MSkill); //SkillID?
				WFIFOL(16, tl.Element); //Element
				WFIFOL(20, i);
				SendBCmd(tm, tc.Point, 24);
				tc.MMode := 1;
                {Free Cast Mods}
                if tc.Skill[278].Lv <> 0 then begin
                    tc.Speed := tc.Speed + (tc.Speed * tc.Skill[278].Data.Data1[tc.MUseLV]);
                    tc.ASpeed := tc.ASpeed + (tc.ASpeed * tc.Skill[278].Data.Data2[tc.MUseLV]);
                    tc.StatRecalc := true;
                end;
                tc.MTick := Tick + cardinal(i);

			end else begin
				//詠唱なし
				tc.MMode := 1;
				tc.MTick := Tick;
			end;
		end;

	end;
	Result := 0;
end;
//------------------------------------------------------------------------------
procedure SendCSkillAtk1(tm:TMap; tc:TChara; ts:TMob; Tick:cardinal; dmg:Integer; k:byte; PType:byte = 0);
var
  j: integer;
  tg: TGuild;
begin


  if assigned(ts) then begin

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
  
  // Moved Lex Aeterna calc up here.  It is display only (don't reset the tick here)
  // Commented.  When it gets here from DamageCalcX, it should be correct.
	// if (ts.EffectTick[0] > Tick) then dmg := dmg * 2; // Lex Aeterna effect

	WFIFOW( 0, $01de);
	WFIFOW( 2, tc.MSkill);
	WFIFOL( 4, tc.ID);
	WFIFOL( 8, ts.ID);
	WFIFOL(12, Tick);
	WFIFOL(16, tc.aMotion);
	WFIFOL(20, ts.Data.dMotion);
	WFIFOL(24, dmg);
	WFIFOW(28, tc.MUseLV);
	WFIFOW(30, k);
	if PType <> 0 then WFIFOB(32, PType)
	else if k = 1 then WFIFOB(32, 6)
	else               WFIFOB(32, 8);

	SendBCmd(tm, tc.Point, 33);
  end else begin
        debugout.lines.add('SENDCSKILLATK1 TS NOT ASSIGNED');
  end;
end;
//------------------------------------------------------------------------------
procedure SendCSkillAtk2(tm:TMap; tc:TChara; tc1:TChara; Tick:cardinal; dmg:Integer; k:byte; PType:byte = 0);
begin

  // Moved Lex Aeterna calc up here.  It is display only (don't reset the tick here)
  // Commented.  When it gets here from DamageCalcX, it should be correct.
	// if (tc1.Skill[78].Tick > Tick) then dmg := dmg * 2;
	WFIFOW( 0, $01de);
	WFIFOW( 2, tc.MSkill);
	WFIFOL( 4, tc.ID);
	WFIFOL( 8, tc1.ID);
	WFIFOL(12, Tick);
	WFIFOL(16, tc.aMotion);
	WFIFOL(20, tc1.dMotion);
	WFIFOL(24, dmg);
	WFIFOW(28, tc.MUseLV);
	WFIFOW(30, k);
	if PType <> 0 then WFIFOB(32, PType)
	else if k = 1 then WFIFOB(32, 6)
	else               WFIFOB(32, 8);

	SendBCmd(tm, tc.Point, 33);
end;

//------------------------------------------------------------------------------
{ChrstphrR 2004/06/01 - this was a Boolean function, but no return value.}
Procedure UpdateSpiritSpheres(
		tm : TMap;
		tc : TChara;
		spiritSpheres : Integer
	);
Begin
	WFIFOW( 0, $01d0);
	WFIFOL( 2, tc.ID);
	WFIFOW( 6, spiritspheres);
	// Colus, 20031222: This packet only has 8 bytes, not 16!
	SendBCmd(tm, tc.Point, 8);
End;
//------------------------------------------------------------------------------
procedure Monkdelay(tm:TMap; tc:TChara; Delay:integer);
begin
        WFIFOW( 0, $01d2);
        WFIFOL( 2, tc.ID);
        WFIFOL( 6, Delay);
        SendBCmd(tm, tc.Point, 10);
end;
//------------------------------------------------------------------------------
function DecSP(tc:TChara; SkillID:word; LV:byte) :boolean;
//var
        //SPAmount        :integer;

begin
   with tc do begin
        SPAmount := 0;
	Result := false;
        if SkillID = 0 then
         exit;
	if tc.SP < tc.Skill[SkillID].Data.SP[LV] then exit;
        SPAmount := tc.Skill[SkillID].Data.SP[LV];

        //Changes in SP usage
        if tc.LessSP then SPAmount := SPAmount * 70 div 100;

        if tc.NoJamstone then SPAmount := SPAmount * 125 div 100;

        if tc.SpRedAmount > 0 then SPAmount := SPAmount - (tc.Skill[SkillID].Data.SP[LV] * tc.SPRedAmount div 100);

        if tc.Autocastactive = true then begin
                SPAmount := SPAmount * 2 div 3;
                Autocastactive := false;
        end;
        
        //Golden Thief Bug Card
        if tc.NoTarget then SPAmount := SPAmount * 2;
        {if tc.LessSP then begin
                tc.SP := tc.SP - (tc.Skill[SkillID].Data.SP[LV] * 70 div 100);
        end else if tc.NoJamstone then begin
                tc.SP := tc.SP - (tc.Skill[SkillID].Data.SP[LV] * 125 div 100);
        end else if tc.SPRedAmount > 0 then begin
                tc.SP := tc.SP - (tc.Skill[SkillID].Data.SP[LV] - (tc.Skill[SkillID].Data.SP[LV] * tc.SPRedAmount div 100));
        end else begin
	        tc.SP := tc.SP - tc.Skill[SkillID].Data.SP[LV];
        end;}
        tc.SP := tc.SP - SPAmount;

	SendCStat1(tc, 0, 7, tc.SP);
   end;
	Result := true;
end;

//------------------------------------------------------------------------------

function UseItem(tc:TChara; j:integer) :boolean;

begin
        Dec(tc.Item[j].Amount, 1);
        if tc.Item[j].Amount = 0 then tc.Item[j].ID := 0;
        WFIFOW( 0, $00af);
        WFIFOW( 2, j);
        WFIFOW( 4, 1);
        tc.Socket.SendBuf(buf, 6);
        //重量変更
        tc.Weight := tc.Weight - tc.Item[j].Data.Weight;
        SendCStat1(tc, 0, $0018, tc.Weight);
end;

//------------------------------------------------------------------------------

function  UpdateWeight(tc:TChara; j:integer; td:TItemDB)  :boolean;

begin
        tc.Item[j].ID := td.ID;
        tc.Item[j].Amount := tc.Item[j].Amount + 1;
        tc.Item[j].Equip := 0;
        tc.Item[j].Identify := 1;
        tc.Item[j].Refine := 0;
        tc.Item[j].Attr := 0;
        tc.Item[j].Card[0] := 0;
        tc.Item[j].Card[1] := 0;
        tc.Item[j].Card[2] := 0;
        tc.Item[j].Card[3] := 0;
        tc.Item[j].Data := td;
        tc.Weight := tc.Weight + cardinal(td.Weight);
        SendCStat1(tc, 0, $0018, tc.Weight);
end;
//------------------------------------------------------------------------------

function UseUsableItem(tc:TChara; w:integer) :boolean;

begin
        Dec(tc.Item[w].Amount);
        WFIFOW( 0, $00a8);
        WFIFOW( 2, w);
        WFIFOW( 4, tc.Item[w].Amount);
        WFIFOB( 6, 1);
        tc.Socket.SendBuf(buf, 7);
        if tc.Item[w].Amount = 0 then tc.Item[w].ID := 0;
        tc.Weight := tc.Weight - tc.Item[w].Data.Weight;
        
        WFIFOW( 0, $00af);
        WFIFOW( 2, w);
        WFIFOW( 4, 1);

        SendCStat1(tc, 0, $0018, tc.Weight);
end;

//------------------------------------------------------------------------------

function  GetMVPItem(tc1:TChara; ts:TMob; mvpitem:boolean) :boolean;
var
        j :integer;
        i :integer;
        td :TItemDB;
begin
        if ts.Data.MEXPPer <= Random(10000) then begin
                for i := 0 to 2 do begin
                        if ts.Data.MVPItem[i].Per > cardinal(Random(10000)) then begin
                                //MVP Item
                                td := ItemDB.IndexOfObject(ts.Data.MVPItem[i].ID) as TItemDB;
                                //重量オーバーやアイテム種類数オーバーの時は、必ず経験値になる　細かい処理マンドクセ('A｀)ノ
                                if tc1.MaxWeight >= tc1.Weight + td.Weight then begin
                                        j := SearchCInventory(tc1, td.ID, td.IEquip);
                                        if j <> 0 then begin
                                                //MVP Get Item
                                                WFIFOW( 0, $010a);
                                                WFIFOW( 2, td.ID);
                                                tc1.Socket.SendBuf(buf, 4);

                                                //Set Item Properites
                                                tc1.Item[j].ID := td.ID;
                                                tc1.Item[j].Amount := tc1.Item[j].Amount + 1;
                                                tc1.Item[j].Equip := 0;
                                                tc1.Item[j].Identify := 1 - byte(td.IEquip);
                                                tc1.Item[j].Refine := 0;
                                                tc1.Item[j].Attr := 0;
                                                tc1.Item[j].Card[0] := 0;
                                                tc1.Item[j].Card[1] := 0;
                                                tc1.Item[j].Card[2] := 0;
                                                tc1.Item[j].Card[3] := 0;
                                                tc1.Item[j].Data := td;
                                                //重量追加
                                                tc1.Weight := tc1.Weight + td.Weight;
                                                SendCStat1(tc1, 0, $0018, tc1.Weight);

                                                //アイテムゲット通知
                                                SendCGetItem(tc1, j, 1);
                                                mvpitem := true;
                                        end;
                                end;
                                break;
                        end;
                end;
        end;
end;

//------------------------------------------------------------------------------
function SearchCInventory(tc:TChara; ItemID:word; IEquip:boolean):word;
var
	i :integer;
begin
	Result := 0;
	if IEquip then begin
		for i := 1 to 100 do begin
			//空きindexを探す
			if tc.Item[i].ID = 0 then begin
				tc.Item[i].Amount := 0;
				Result := i;
				break;
			end;
		end;
	end else begin
		for i := 1 to 100 do begin
			//同じアイテムを持ってるか探す
			if tc.Item[i].ID = ItemID then begin
				Result := i;
				exit;
			end;
		end;
		for i := 1 to 100 do begin
			//空きindexを探す
			if tc.Item[i].ID = 0 then begin
				tc.Item[i].Amount := 0;
				Result := i;
				break;
			end;
		end;
	end;
end;
//------------------------------------------------------------------------------
function SearchPInventory(tc:TChara; ItemID:word; IEquip:boolean):word;
var
	i   :integer;
	tp  :TPlayer;
begin
	Result := 0;
	tp := tc.PData;
	if IEquip then begin
		for i := 1 to 100 do begin
			//空きindexを探す
			if tp.Kafra.Item[i].ID = 0 then begin
				tp.Kafra.Item[i].Amount := 0;
				Result := i;
				break;
			end;
		end;
	end else begin
		for i := 1 to 100 do begin
			//同じアイテムを持ってるか探す
			if tp.Kafra.Item[i].ID = ItemID then begin
				Result := i;
				exit;
			end;
		end;
		for i := 1 to 100 do begin
			//空きindexを探す
			if tp.Kafra.Item[i].ID = 0 then begin
				tp.Kafra.Item[i].Amount := 0;
				Result := i;
				break;
			end;
		end;
	end;
end;
//==============================================================================






//==============================================================================
procedure SendMData(Socket: TCustomWinSocket; ts:TMob; Use0079:boolean = false);
begin
	ZeroMemory(@buf[0], 41);
	WFIFOW( 0, $007c);
	WFIFOL( 2, ts.ID);
	WFIFOW( 6, ts.Speed);
{追加}
	WFIFOW( 8, ts.Stat1);
	WFIFOW(10, ts.Stat2);
{追加ココまで}
	WFIFOW(20, ts.JID);
	WFIFOM1(36, ts.Point, ts.Dir);
	Socket.SendBuf(buf, 41);
end;
//------------------------------------------------------------------------------
procedure SendMMove(Socket: TCustomWinSocket; ts:TMob; before, after:TPoint; ver2:Word);
begin
	//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('S 007b %s (%d,%d)-(%d,%d)', [tc.Name, before.X, before.Y, after.X, after.Y]));
	ZeroMemory(@buf[0], 60);
	WFIFOW( 0, $007b);
	WFIFOL( 2, ts.ID);
	WFIFOW( 6, ts.Speed);
{追加}
	WFIFOW( 8, ts.Stat1);
	WFIFOW(10, ts.Stat2);
{追加ココまで}
	WFIFOW(14, ts.JID);
	WFIFOL(22, timeGetTime());
	WFIFOW(36, ts.Dir);
	WFIFOM2(50, after, before);
	WFIFOB(56, 5);
	WFIFOB(57, 5);
{修正}
	if ver2 = 9 then begin
		Socket.SendBuf(buf, 60); //kr仕様
	end else begin
		Socket.SendBuf(buf, 58); //Jp仕様
	end;
{修正ココまで}
	//WFIFOW( 0, $007f);
	//WFIFOL( 2, timeGetTime()+1000);
	//Socket.SendBuf(buf, 6);
end;
//------------------------------------------------------------------------------
procedure SendNData(Socket: TCustomWinSocket; tn:TNPC; ver2:Word; Use0079:boolean = false);
{アジト機能追加}
var
	i  :integer;
	j  :integer;
	w1 :word;
	w2 :word;
	tg :TGuild;
  tgc:TCastle;
{アジト機能追加ココまで}
begin
{NPCイベント追加}
	//if (tn.JID = -1) then exit;//CR 2004/04/26 - JID is Cardinal.
	// Colus, 20040503: Checking against the constant value now.
	if (tn.JID = NPC_INVISIBLE) then exit;
{NPCイベント追加ココまで}
	if (tn.CType = 3) then begin
		WFIFOW( 0, $009d);
		WFIFOL( 2, tn.ID);
		WFIFOW( 6, tn.Item.ID);
		WFIFOB( 8, tn.Item.Identify);
		WFIFOW( 9, tn.Point.X);
		WFIFOW(11, tn.Point.Y);
		WFIFOW(13, tn.Item.Amount);
		WFIFOB(15, tn.SubX);
		WFIFOB(16, tn.SubY);
		Socket.SendBuf(buf, 17);
	end else if tn.CType = 4 then begin
     if ((tn.JID = $B0) or (tn.JID = $99)) then begin

          WFIFOW(0, $01c9);
          WFIFOL(2, tn.ID);
          WFIFOL(6, tn.CData.ID);
	        WFIFOW(10, tn.Point.X);
	        WFIFOW(12, tn.Point.Y);
          WFIFOB(14, tn.JID);
          WFIFOB(15, 1);
          if tn.JID = $B0 then
            WFIFOB(16, 1)
          else
            WFIFOB(16, 0);
          WFIFOS(17, tn.Name, 80);
          //WFIFOW(95, Length(tn.Name));

 	        Socket.SendBuf(buf, 97);
    end else begin
  		WFIFOW( 0, $011f);
  		WFIFOL( 2, tn.ID);
  		WFIFOL( 6, 0);
  		WFIFOW(10, tn.Point.X);
	  	WFIFOW(12, tn.Point.Y);
  		WFIFOB(14, tn.JID);
  		WFIFOB(15, 1);
  		Socket.SendBuf(buf, 16);
    end;
	end else if tn.JID < 45 then begin
		ZeroMemory(@buf[0], 53);
		WFIFOW(0, $0079);
		WFIFOL( 2, tn.ID);
		WFIFOW( 6, 200);
		WFIFOW(14, tn.JID);
		WFIFOM1(46, tn.Point, tn.Dir);
		WFIFOB(49, 5);
		WFIFOB(50, 5);
{修正}
		if Socket <> nil then begin
			if ver2 = 9 then Socket.SendBuf(buf, 53) //Kr?
			else             Socket.SendBuf(buf, 51);//Jp
		end;
{修正ココまで}
	end else begin
{アジト機能追加}
//		ZeroMemory(@buf[0], 41);
//		WFIFOW( 0, $007c);
//		WFIFOL( 2, tn.ID);
//		WFIFOW( 6, 200);
//		WFIFOW(20, tn.JID);
//		WFIFOM1(36, tn.Point, tn.Dir);
//		Socket.SendBuf(buf, 41);
		ZeroMemory(@buf[0], 54);
		WFIFOW(0, $0078);
		WFIFOL( 2, tn.ID);
		WFIFOW( 6, 200);
		WFIFOW(14, tn.JID);
		w1 := 0;
		w2 := 0;
    // Colus, 20040130: We can't use this method because guilds are allowed
    // to have more than one castle, thus, their territory value keeps changing.
    // Instead we need to:
    //  1) Look up the NPC's guild (it is a mapname)
    //  2) Look for the castle with that name
    //  3) If on the list, find the guild with that castle, if any
    //     If not, well, no emblem.
    //  4) Get the guild's emblem and set it.
		if (tn.Agit <> '') then begin
      i := CastleList.IndexOf(tn.Agit);
      if (i <> -1) then begin
        tgc := CastleList.Objects[i] as TCastle;
        with tgc do begin
          // No check of j.  Castle wouldn't have been made w/o a proper guild ID.
          j := GuildList.IndexOf(tgc.GID);
          if (j <> -1) then begin
            tg := GuildList.Objects[j] as TGuild;
            w1 := tg.Emblem;
  					w2 := tg.ID;
          end;
        end;
      end;
		end; 
{		if (tn.Agit <> '') then begin
			for i := 0 to GuildList.Count - 1 do begin
				tg := GuildList.Objects[i] as TGuild;
				if (tg.Agit = tn.Agit) then begin
					w1 := tg.Emblem;
					w2 := tg.ID;
					break;
				end;
			end;
		end;}
		WFIFOL(22, w1);
		WFIFOL(26, w2);
		WFIFOM1(46, tn.Point, tn.Dir);
		WFIFOB(49, 5); //0=warp,1,5,20=hidden
		WFIFOB(50, 5); //〃
		if Socket <> nil then begin
			if ver2 = 9 then Socket.SendBuf(buf, 54)	//Kr?
			else             Socket.SendBuf(buf, 52); //Jp
		end;
{アジト機能追加ココまで}
	end;
end;
//------------------------------------------------------------------------------
{キューペット}
procedure SendPetMove(Socket: TCustomWinSocket; tc:TChara; target:TPoint );
var
        tn:TNPC;
        tpe:TPet;
        spd:word;
begin
        if ( tc.PetData <> nil ) and ( tc.PetNPC <> nil ) then begin
                tpe := tc.PetData;
                tn := tc.PetNPC;

	        ZeroMemory(@buf[0], 60);
					WFIFOW( 0, $007b);
	        WFIFOL( 2, tn.ID );

          // Colus, 20040222: Slow down the pet when actually moving
          if (tn.Path[tn.ppos] and 1) = 0 then begin
      			spd := tc.Speed;
      		end else begin
      			spd := tc.Speed * 140 div 100;
      		end;
	        WFIFOW( 6, spd);
	        WFIFOW(14, tpe.JID);
                WFIFOW(16, 20 ); // 謎
                WFIFOW(20, tpe.Accessory);
	        WFIFOL(22, timeGetTime());
	        WFIFOW(36, tn.Dir);
	        WFIFOM2(50, target, tn.Point );
	WFIFOB(56, 5);
	WFIFOB(57, 5);

	        if tc.ver2 = 9 then begin
		        Socket.SendBuf(buf, 60); //kr仕様
	        end else begin
		        Socket.SendBuf(buf, 58); //Jp仕様
	        end;
        end;
end;
{キューペットここまで}
//------------------------------------------------------------------------------
function SetSkillUnit(tm:TMap; ID:cardinal; xy:TPoint; Tick:cardinal; SType:word; SCount:word; STime:cardinal; tc:TChara = nil; ts:TMob = nil; SText:String = ''):TNPC;
var
	tn :TNPC;
begin
	tn := TNPC.Create;
	tn.ID := NowItemID;
	Inc(NowItemID);
	tn.Name := 'skillunit';
	tn.JID := SType;
	tn.Map := tm.Name;
	tn.Point := xy;
	tn.CType := 4; //SkillUnit
	tn.Tick := Tick + STime;
	tn.Count := SCount;
	tn.CData := tc;
  tn.MData := ts;
  tn.Enable := true;  // Enable a skillunit so that it will reappear when you reenter screen
	tm.NPC.AddObject(tn.ID, tn);
	tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.AddObject(tn.ID, tn);

        if tn.JID = $8D then begin  // Icewall:
          tm.gat[tn.Point.X][tn.Point.Y] := 5;  // 1-> 5, so you can snipe through?
          WFIFOW(0, $0192);
          WFIFOW(2, tn.Point.X);
          WFIFOW(4, tn.Point.Y);
          WFIFOW(6, 5);
          WFIFOS(8, tm.Name, 16);
 	        SendBCmd(tm, tn.Point, 24);
        end;


        // Graffiti/Talkie Box
        if (((tn.JID = $B0) or (tn.JID = $99)) and (SText <> '')) then begin
          tn.Name := SText;
          WFIFOW(0, $01c9);
          WFIFOL(2, tn.ID);
          WFIFOL(6, ID);
	        WFIFOW(10, tn.Point.X);
	        WFIFOW(12, tn.Point.Y);
          WFIFOB(14, tn.JID);
          WFIFOB(15, 1);
          if tn.JID = $B0 then
            WFIFOB(16, 1)
          else
            WFIFOB(16, 0);

          WFIFOS(17, SText, 80);
          //WFIFOW(95, Length(SText));

 	        SendBCmd(tm, tn.Point, 97);
        end else if tn.JID = $46 then begin
          WFIFOW( 0, $011f);
	        WFIFOL( 2, tn.ID);
	        WFIFOL( 6, ID);
	        WFIFOW(10, tn.Point.X);
	        WFIFOW(12, tn.Point.Y);
	        WFIFOB(14, $83);
	        WFIFOB(15, 1);
	        SendBCmd(tm, tn.Point, 16);

        end else begin
	//周りに通知
	        WFIFOW( 0, $011f);
	        WFIFOL( 2, tn.ID);
	        WFIFOL( 6, ID);
	        WFIFOW(10, tn.Point.X);
	        WFIFOW(12, tn.Point.Y);
	        WFIFOB(14, tn.JID);
	        WFIFOB(15, 1);
	        SendBCmd(tm, tn.Point, 16);
        end;

	Result := tn;
end;
//------------------------------------------------------------------------------
procedure DelSkillUnit(tm:TMap; tn:TNPC ; tc:TChara);
begin
	//スキル効能地撤去
	WFIFOW(0, $0120);
	WFIFOL(2, tn.ID);
	SendBCmd(tm, tn.Point, 6);
	//スキル効能地削除

  // Icewall terrain change

  if (tn.JID = $8D) then begin
    tm.gat[tn.Point.X][tn.Point.Y] := 0;

    WFIFOW(0, $0192);
    WFIFOW(2, tn.Point.X);
    WFIFOW(4, tn.Point.Y);
    WFIFOW(6, 0);
    WFIFOS(8, tm.Name, 16);
    SendBCmd(tm, tn.Point, 24);
  end;

  if (tn.JID = $7f) and (tn.CData <> nil) then begin
    tc := tn.CData;
    tc.FireWallCount := tc.FireWallCount - 1 ;
  end;
  
	tm.NPC.Delete(tm.NPC.IndexOf(tn.ID));
	with tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC do
		Delete(IndexOf(tn.ID));
	tn.Free;

end;
//==============================================================================






//==============================================================================
(*= Func MoveItem() : Integer ===================*

CRW - 2004/04/04
  Adding useful comments, renaming parameters and
  internal variables for clarity.

  No changes to external behavior or parameter
  order were made! :)

  Copies a 'Quant' amount of Items inside the
  'Source' container to the

  Returns:

  -1  - When Index is out of bounds, or the
        Source container doesn't have any items
        at Index.

   0  - ??

   2  - ??

   3  - No existing Item nodes in Dest have
        the item that Source is moving over,
        and/or the Source container is FULL.

(*-- relies on --
  DeleteItem()
  GetItemStore()
  SearchInventory()
(*==============================================*)
Function	MoveItem(
            Dest    : TItemList;
            Source  : TItemList;
            Index   : Word;
            Quant   : Word
          ) : Integer; overload;
Var
  J : Integer;
  K : Integer;
  //CRW - I hate using "i" and "l" as iterative variable names
  //  -- they're too easy to confuse for '1' '1' 'l' |'.
  //  Avoid them like the plague, I tell you! :)
Begin
  //自分範囲外
  //自分アイテム持ってない
	Result := -1;
	if (100 < index) OR (Source.Item[Index].ID = 0) then
    begin // Index OOB, or Item at Index is empty.
    Exit;
    end;//if (100...

  // Are there any Item nodes with the item ID inside the destination?
	K := SearchInventory(Dest, Source.Item[Index].ID, Source.Item[Index].Data.IEquip);
	if K = 0 then begin //相手空き無し
		Result := 3;
		Exit;
	end;

  // if there's less of the Item in Source than asked for,
  // only send that amount over, instead.
	if Source.Item[Index].Amount < Quant then Quant := Source.Item[Index].Amount;
	J := GetItemStore(Dest, Source.Item[Index], Quant);
	if j = 0 then begin
		DeleteItem(Source,Index,Quant);
		Result := 0;
	end else if j = 2 then begin //相手重量オーバー
		Result := j;
	end else if j = 3 then begin //相手種類オーバー
		Result := j;
	end;
End;(* Func MoveItem() : Integer ===============*)


//------------------------------------------------------------------------------
(*= Func GetItemStore() : Integer ===============*

CRW - 2004/04/05
  Adding useful comments, renaming parameters and
  internal variables for clarity.

  No changes to external behavior or parameter
  order were made! :)



Returns:

-1
0
3

  -1  - When Index is out of bounds, or the
        AList container doesn't have any items.

   0  - ??

   2  - ??

   3  - No existing Item nodes in Dest have
        the item that Source is moving over,
        and/or the Source container is FULL.


(*-- relies on --
  SearchInventory()
(*==============================================*)
Function  GetItemStore(
            AList   : TItemList;
            AnItem  : TItem;
            Quant   : Word;
            IsEquip : Boolean = False
          ) : Integer;
Var
	Idx : Integer;
begin
	Result := 0;
	with AList do
    begin
		//重量オーバー
		if MaxWeight < (Weight + AnItem.Data.Weight * Quant) then
      begin
			Result := 2;
			Exit;
  		end;//if MaxWeight...

		if not IsEquip then IsEquip := AnItem.Data.IEquip;
		Idx := SearchInventory(AList,AnItem.ID,IsEquip);
		//所持種類オーバー
		if Idx = 0 then begin
			Result := 3;
			Exit;
		end;
		//所持個数オーバー
		if Quant + Item[Idx].Amount > 30000 then begin
			Result := -1;
			Exit;
		end;
		with Item[Idx] do
      begin
			if Amount = 0 then
        Count := Count + 1;

			ID        := AnItem.ID;
			Amount    := Amount + Quant;
			Equip     := 0;
			Identify  := AnItem.Identify;
			Refine    := AnItem.Refine;
			Attr      := AnItem.Attr;
			Card[0]   := AnItem.Card[0];
			Card[1]   := AnItem.Card[1];
			Card[2]   := AnItem.Card[2];
			Card[3]   := AnItem.Card[3];

      Data := AnItem.Data;

		end;
		Weight := Weight + (AnItem.Data.Weight * Quant);
	end;//w AList
end;(* Func GetItemStore() : Integer ===========*)


//------------------------------------------------------------------------------
(*= Func DeleteItem() : Integer =================*

CRW - 2004/04/04
  Adding useful comments, renaming parameters and
  internal variables for clarity.

  No changes to external behavior or parameter
  order were made! :)

Deletes a given Quantity of an item at Index
inside the ItemList 'AList'

Returns:
 -1 : Failed to delete.
  0 : Deletion successful.

(*==============================================*)
Function  DeleteItem(
            AList : TItemList;
            Index : Word;
            Quant : Word
          ) : Integer;
Begin
  //CRW - internally, removing some of these
  // Dec() calls, for future changes I want to do
  // with TItem / TItemList

	Result := -1;
	if 100 < index then Exit; //範囲外
	with AList.Item[Index] do
		begin
		if ID = 0 then Exit;       //所持していない
		if Amount > Quant then
			begin //所有個数以下
			Amount := Amount - Quant;
			AList.Weight := AList.Weight  - (Data.Weight * Quant);
			end
		else
			begin
			ID := 0;
			AList.Weight := AList.Weight - (Data.Weight * Amount);
			Amount := 0;
			Dec(AList.Count);
			end;//if-else
		end;//with AList.Item{Index]
	Result := 0;
end;(* Func GetItemStore() : Integer ===========*)


//------------------------------------------------------------------------------
(*= Proc CalcInventory ==========================*

CRW - 2004/04/05
  Adding useful comments, renaming parameters and
  internal variables for clarity.

  No changes to external behavior or parameter
  order were made! :)

Recalculates a Cart or Kafra Storage container's
Weight and iten mode Count.

(*==============================================*)
Procedure CalcInventory( AList : TItemList );
Var
	ItmIdx    : Integer;
	NewCount  : Integer;
Begin
	AList.Weight := 0;
	NewCount := 0;
	//アイテム重量を計算
	for ItmIdx := 1 to 100 do
    begin
    with AList.Item[ItmIdx] do
      begin
  		if ID <> 0 then
        begin
        //if ti.Item[i].Amount <= 0 then ti.Item[i].Amount := 0;
		  	AList.Weight := AList.Weight + (Data.Weight * Amount);
  			Inc(NewCount);
	    	end;//if ID
      end;//w
  	end;//for

	AList.Count := NewCount;
End;(* Proc CalcInventory : Integer ============*)


//------------------------------------------------------------------------------
(*= Func SearchInventory : Integer ==============*

CRW - 2004/04/04
  Adding useful comments, renaming parameters and
  internal variables for clarity.

  No changes to external behavior or parameter
  order were made! :)

Passes An ItemList container, an Iten ID to search
for, and notes if the Item ID is a piece of
Equipment (Weapons/Armour/PetEgg)

Returns:
  0       : When Cart is full

  1..100  : Index of first node item can be placed
            into (if the item exists, it's stacked
            into an existing node, if not, it's
            the first free item node).

(*==============================================*)
Function  SearchInventory(
            AList   : TItemList;
            ItemID  : Word;
            IEquip  : Boolean
          ) : Word;
Var
	ItmIdx : Integer;
Begin
	Result := 0;

  //CRW moved this ahead of the for loop - this is an
  // easy quick comparison to avoid serching a cart that
  // you know is FULL from the start of the routine.
  // No change in end results occur, except, when
  // the cart's completely full, you save time. :)
  //
  //if full, leave with result of Zero - no room
	if AList.Count = 100 then Exit;

  // If stackable
	if NOT IEquip then
    begin
		for ItmIdx := 1 to 100 do
      begin
			//同じアイテムを持ってるか探す
			if AList.Item[ItmIdx].ID = ItemID then
        begin
				Result := ItmIdx;
				Exit;
  			end;//if AList.Itemp[].ID
  		end;//for
  	end;//if NOT...

  //otherwise, find the first empty spot in the Items array, return
  // that index.
	for ItmIdx := 1 to 100 do begin
		//空きindexを探す
		if AList.Item[ItmIdx].ID = 0 then begin
			AList.Item[ItmIdx].Amount := 0;
			Result := ItmIdx;
			Exit;
		end;
	end;
End;(* Func SearchInventory() : Integer ========*)


//------------------------------------------------------------------------------
{カート機能追加}
procedure SendCart(tc:TChara);
var
	j,i:Integer;
begin
	with tc.Cart do begin
	//カート内消耗品＆収集品の表示パケット作成
	WFIFOW(0, $0123);
	j := 0;
	for i := 1 to 100 do begin
		if (Item[i].ID <> 0) and (not item[i].Data.IEquip) then begin
			WFIFOW( 4 +j*10, i);
			WFIFOW( 6 +j*10, item[i].Data.ID);
			WFIFOB( 8 +j*10, item[i].Data.IType);
			WFIFOB( 9 +j*10, item[i].Identify);
			WFIFOW(10 +j*10, item[i].Amount);
			if item[i].Data.IType = 10 then
				WFIFOW(12 +j*10, 32768)
			else
				WFIFOW(12 +j*10, 0);
			Inc(j);
		end;
	end;
	WFIFOW(2, 4+j*10);
	tc.Socket.SendBuf(buf, 4+j*10);

	//カート内装備品
	WFIFOW(0, $0122);
	j := 0;
	for i := 1 to 100 do begin
		if (item[i].ID <> 0) and item[i].Data.IEquip then begin
			WFIFOW( 4 +j*20, i);
			WFIFOW( 6 +j*20, item[i].Data.ID);
			WFIFOB( 8 +j*20, item[i].Data.IType);
			WFIFOB( 9 +j*20, item[i].Identify);
			with item[i].Data do begin
				if (tc.JID = 12) and (IType = 4) and (Loc = 2) and
					 ((View = 1) or (View = 2) or (View = 6)) then
					WFIFOW(10 +j*20, 34)
				else
					WFIFOW(10 +j*20, Loc);
			end;
			WFIFOW(12 +j*20, item[i].Equip);
			WFIFOB(14 +j*20, item[i].Attr);
			WFIFOB(15 +j*20, item[i].Refine);
			WFIFOW(16 +j*20, item[i].Card[0]);
			WFIFOW(18 +j*20, item[i].Card[1]);
			WFIFOW(20 +j*20, item[i].Card[2]);
			WFIFOW(22 +j*20, item[i].Card[3]);
			Inc(j);
		end;
	end;
	WFIFOW(2, 4+j*20);
	tc.Socket.SendBuf(buf, 4+j*20);

	//カート重量、容量データの送信
	//0121 <num>.w <num limit>.w <weight>.l <weight limit>l
	WFIFOW(0, $0121);
	WFIFOW(2, Count);
	WFIFOW(4, 100);
	WFIFOL(6, Weight);
	WFIFOL(10, MaxWeight);
	tc.Socket.SendBuf(buf, 14);
  end;
end;
{カート機能追加ココまで}
//==============================================================================






//==============================================================================
//個人のレベルアップ用
procedure CalcLvUP(tc1:TChara; EXP:cardinal; JEXP:cardinal);
var
	j:Integer;
	tm:TMap;
begin
	tm := tc1.MData;

	if DisableLevelLimit or (tc1.BaseLV < 99) then
		tc1.BaseEXP := tc1.BaseEXP + EXP;

	if DisableLevelLimit or ((tc1.JID = 0) and (tc1.JobLV < 10)) or ((tc1.JID <> 0) and (tc1.JobLV < 50)) then
		tc1.JobEXP := tc1.JobEXP + JEXP;

	if tc1.BaseEXP >= tc1.BaseNextEXP then begin
		while tc1.BaseEXP >= tc1.BaseNextEXP do begin

			//ベースレベルアップ
			tc1.StatusPoint := tc1.StatusPoint + tc1.BaseLV div 5 + 3;

			if DisableLevelLimit or (tc1.BaseLV < 99) then begin
			Inc(tc1.BaseLV);
				tc1.BaseEXP := tc1.BaseEXP - tc1.BaseNextEXP;
				if (tc1.BaseEXP >= tc1.BaseNextEXP) and (not DisableLevelLimit) then begin
					try
						tc1.BaseEXP := tc1.BaseNextEXP - 1;
					finally
						tc1.BaseEXP := 0;
					end;
				end;
			end else begin
				tc1.BaseEXP := 0;
			end;

            if (ExpTable[0][tc1.BaseLV] = 0) then tc1.BaseNextEXP := 999999999
            else tc1.BaseNextEXP := ExpTable[0][tc1.BaseLV];

		end;
		SendCStat1(tc1, 0, $000b, tc1.BaseLV);
		SendCStat1(tc1, 0, $0009, tc1.StatusPoint);
		CalcStat(tc1);

		tc1.HP := tc1.MaxHP;
		tc1.SP := tc1.MaxSP;
		WFIFOW( 0, $019b);
		WFIFOL( 2, tc1.ID);
		WFIFOL( 6, 0);
		SendBCmd(tm, tc1.Point, 10);
		SendCStat(tc1);
	end else begin
		SendCStat1(tc1, 1, $0001, tc1.BaseEXP);
	end;

	if tc1.JobEXP >= tc1.JobNextEXP then begin
		repeat
			//ジョブレベルアップ
			Inc(tc1.SkillPoint);
			Inc(tc1.JobLV);
			if DisableLevelLimit or ((tc1.JID = 0) and (tc1.JobLV < 10)) or ((tc1.JID <> 0) and (tc1.JobLV < 50)) then begin
				tc1.JobEXP := tc1.JobEXP - tc1.JobNextEXP;
				if (tc1.JobEXP >= tc1.JobNextEXP) and (not DisableLevelLimit) then begin
					tc1.JobEXP := tc1.JobNextEXP - 1;
				end;
			end else begin
				tc1.JobEXP := 0;
			end;

			if tc1.JID < 13 then begin
				j := (tc1.JID + 5) div 6 + 1;
			end else begin
				j := 3; //暫定
			end;
			tc1.JobNextEXP := ExpTable[j][tc1.JobLV];

		until tc1.JobEXP < tc1.JobNextEXP;
		SendCStat1(tc1, 0, $0037, tc1.JobLV);
		SendCStat(tc1);
		if tc1.SkillPoint = 1 then
			SendCSkillList(tc1)
		else
			SendCStat1(tc1, 0, $000c, tc1.SkillPoint);
		WFIFOW( 0, $019b);
		WFIFOL( 2, tc1.ID);
		WFIFOL( 6, 1);
		SendBCmd(tm, tc1.Point, 10);
	end else begin
		SendCStat1(tc1, 1, $0002, tc1.JobEXP);
	end;
end;
//------------------------------------------------------------------------------
//経験値分配用
procedure PartyDistribution(Map:string; tpa:TParty; EXP:Cardinal = 0; JEXP:Cardinal = 0);
var
	m,l,w:Cardinal;
	i:Integer;
	tc1:TChara;
begin
	Inc(tpa.EXP,EXP);
	Inc(tpa.JEXP,JEXP);
	if tpa.EXPShare then begin
		m := 1;
		for i := 0 to 11 do begin
			if tpa.MemberID[i] = 0 then Continue;
			tc1 := tpa.Member[i];
			if (tc1.Login = 2) and (tc1.HP > 0) then begin
				if tc1.Map = Map then Inc(m);
			end;
		end;

		//l := (tpa.EXP  +  (tpa.EXP div 10) * (m - 1)) div m + 1; //適当～
		//w := (tpa.JEXP + (tpa.JEXP div 10) * (m - 1)) div m + 1; //適当～
                {バグ報告655}
                l := (tpa.EXP + 1 + (tpa.EXP div 4) * (m - 2)) div (m - 1);
                w := (tpa.JEXP + 1 + (tpa.JEXP div 4) * (m - 2)) div (m - 1);
                {バグ報告655 ここまで}
		for i := 0 to 11 do begin
			if tpa.MemberID[i] = 0 then Continue;
			tc1 := tpa.Member[i];
			if (tc1.Login = 2) and (tc1.HP > 0) then begin
				if tc1.Map = Map then CalcLvUP(tc1,l,w);
			end;
		end;
		tpa.EXP := 0;
		tpa.JEXP:= 0;
	end;
end;
{追加ココまで}
//------------------------------------------------------------------------------

{
When given a character, SendPartyList updates party information, notifies PTM
}
procedure SendPartyList(tc:TChara);
var
	i    : Integer;
	j    : Integer; //Member record index inside packet
	k    : Integer;
	PIdx : Integer;
	tpa  : TParty;
begin
	PIdx := PartyNameList.IndexOf(tc.PartyName);
	if (PIdx <> -1) then begin
		tpa := PartyNameList.Objects[PIdx] as TParty;

		{Rearrange the party members -- any offline characters are
		removed, and the other entries are bubbled up to the front.}
		i := 0;
		while (i >= 0) and (i <= 11) do begin
			if (tpa.MemberID[i] <> 0) and (Chara.IndexOf(tpa.MemberID[i]) = -1) then begin
				for j := i to 10 do begin
					tpa.MemberID[j] := tpa.MemberID[j+1];
					tpa.Member[j] := tpa.Member[j+1];
				end;
					tpa.MemberID[11] := 0;
					tpa.Member[11] := nil;
					Dec(i);
			end;
			Inc(i);
		end;

		tpa.MinLV := 99;
		tpa.MaxLV := 1;

		//パーティー情報の送信(00FBパケット)
		j := 28;
		for k := 0 to 11 do begin
			//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('k = %d : tpa.MemberID = %d', [k,tpa.MemberID[k]]));
			if (tpa.MemberID[k] = 0) then break;
			if (tpa.Member[k].Login = 2) and (tpa.Member[k].BaseLV < tpa.MinLV) then tpa.MinLV := tpa.Member[k].BaseLV;//パーティー最高レベル
			if (tpa.Member[k].Login = 2) and (tpa.Member[k].BaseLV > tpa.MaxLV) then tpa.MaxLV := tpa.Member[k].BaseLV;//パーティー最低レベル
			WFIFOL(j, tpa.Member[k].ID);
			WFIFOS(j+4, tpa.Member[k].Name, 24);
			WFIFOS(j+28, tpa.Member[k].Map + '.gat', 16);
			if (k = 0) then begin
				WFIFOB(j+44, 0);//リーダー
			end else begin
				WFIFOB(j+44, 1);//非リーダー
			end;
			//WFIFOB(j+44, 1);
			//WFIFOB(j+45, tpa.Member[k].Login);
			if (tpa.Member[k].Login = 2) then begin
				WFIFOB(j+45, 0);//オンライン
			end else begin
				WFIFOB(j+45, 1);//オフライン
			end;
			//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('k = %d : ID = %d : Name = %s : Map = %s ', [k, tpa.Member[k].ID, tpa.Member[k].Name, tpa.Member[k].Map]));
			j := j + 46;
		end;
		WFIFOW(0, $00fb);
		WFIFOW(2, j);
		WFIFOS(4, tpa.Name, 24);
		SendPCmd(tc, j);

		//パーティー共有設定の送信(0101パケット)
		//ここの公平可能レベルはiniから読みこみにするといいかも
		if (tpa.MaxLV - tpa.MinLV > Option_PartyShare_Level) and (tpa.EXPShare) then begin
			tpa.EXPShare := False;//公平可能レベルを超えていたら無条件に個別取得にする
		end;
		WFIFOW(0, $0101);
		WFIFOW(2, Word(tpa.EXPShare));
		WFIFOW(4, Word(tpa.ITEMShare));
		SendPCmd(tc, 6);

		for i := 0 to 11 do begin
			if (tpa.MemberID[i] = 0) then break;
			//パーティーメンバーのHPバー表示
			WFIFOW( 0, $0106);
			WFIFOL( 2, tpa.Member[i].ID);
			WFIFOW( 6, tpa.Member[i].HP);
			WFIFOW( 8, tpa.Member[i].MAXHP);
			SendPCmd(tpa.Member[i], 10, true, true);//同一マップ内の自分以外のPTMに送る

			//パーティーメンバーの位置表示
			WFIFOW( 0, $0107);
			WFIFOL( 2, tpa.Member[i].ID);
			WFIFOW( 6, tpa.Member[i].Point.X);
			WFIFOW( 8, tpa.Member[i].Point.Y);
			SendPCmd(tpa.Member[i], 10, true, true);//同一マップ内の自分以外のPTMに送る
		end;
	end;
end;
//------------------------------------------------------------------------------
procedure SendPCmd(tc:TChara; PacketLen:word; InMap:boolean = false; AvoidSelf:boolean = false);
//パーティーメンバーに同一パケットを送りつける
//InMapはtrue時マップ内のメンバーのみにパケット送信(位置表示やHPバーなど)
//AvoidSelfはtrue時自分自身を除くメンバーにパケット送信
var
	i	:integer;
	tc1	:TChara;
	tpa	:Tparty;
begin
	i := PartyNameList.IndexOf(tc.PartyName);
	if (i <> -1) then begin
		tpa := PartyNameList.Objects[i] as TParty;
		for i := 0 to 11 do begin
			if tpa.MemberID[i] = 0 then break;
			if Chara.IndexOf(tpa.MemberID[i]) = -1 then Continue;
			tc1 := tpa.Member[i];
			if tc1.Login <> 2 then Continue;
			if (tc.Map = tc1.Map) or (InMap = false) then begin
				if (tc.ID = tc1.ID) and (AvoidSelf = true) then continue;
				tc1.Socket.SendBuf(buf, PacketLen);
				//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('Send to ID %d : Length %d ', [tc1.ID, PacketLen]));
			end;
		end;
	end;
end;
{パーティー機能追加ココまで}
//==============================================================================






//==============================================================================
{チャットルーム機能追加}
procedure ChatRoomExit(tc:TChara; AvoidSelf:boolean = false);
//チャットルームからメンバーを削除する
//AvoidSelfはtrue時自分自身を除くメンバーにパケット送信
var
	i	:integer;
	j	:integer;
	l	:cardinal;
	w	:word;
	str	:string;
	tcr	:TChatRoom;
begin
	i := ChatRoomList.IndexOf(tc.ChatRoomID);
	if (i <> -1) then begin
		tcr := ChatRoomList.Objects[i] as TChatRoom;
		j := -1;
		for i := 0 to 19 do begin;
			if tc.ID = tcr.MemberID[i] then begin
				j := i;
				break;
			end;
		end;

		if (j = -1) then exit;
		if (j = 0) and (tcr.Users > 1) then begin
			//オーナー抜けの場合のダミー送信
			WFIFOW( 0, $00e1);
			WFIFOL( 2, 1);
			WFIFOS( 6, tcr.MemberName[0], 24);
			SendCrCmd(tc, 30, true);

			WFIFOW( 0, $00e1);
			WFIFOL( 2, 0);
			WFIFOS( 6, tcr.MemberName[1], 24);
			SendCrCmd(tc, 30, true);
		end;

		//抜けるメンバーをリストの後ろに配置
		if (tcr.Users > 1) then begin
			l := tcr.MemberID[j];
			str := tcr.MemberName[j];
			if (j <= 18) and (j <> tcr.Users - 1) then begin
				for i := j to tcr.Users - 2 do begin
					tcr.MemberID[i] := tcr.MemberID[i+1];
					tcr.MemberCID[i] := tcr.MemberCID[i+1];
					tcr.MemberName[i] := tcr.MemberName[i+1];
				end;
				tcr.MemberID[tcr.Users - 1] := l;
				tcr.MemberCID[tcr.Users - 1] := l;
				tcr.MemberName[tcr.Users - 1] := str;
			end;
		end;

		//チャット抜け通知
		WFIFOW( 0, $00dd);
		WFIFOW( 2, tcr.Users - 1);
		WFIFOS( 4, tc.Name, 24);
		WFIFOB(28, 0);
		SendCrCmd(tc, 29, AvoidSelf);

		tcr.Users := tcr.Users - 1;
		tcr.MemberID[tcr.Users] := 0;
		tcr.MemberCID[tcr.Users] := 0;
		tcr.MemberName[tcr.Users] := '';
		//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('%s Leaves %s', [tc.Name ,tcr.Title]));

		if (tcr.Users = 0) then begin
			//空室チャット閉じ
			WFIFOW( 0, $00d8);
			WFIFOL( 2, tcr.ID);
			SendNCrCmd(tc.MData, tc.Point, 6, tc, true);
			//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('ChatRoom(%s) was deleted / Remaining ChatRoom(%d)', [tcr.Title,ChatRoomList.Count-1]));
			ChatRoomList.Delete(ChatRoomList.IndexOf(tcr.ID));
			tcr.Free;
		end else begin
			if (j = 0) then begin
				//オーナー変更チャット消去
				WFIFOW( 0, $00d8);
				WFIFOL( 2, tcr.ID);
				SendNCrCmd(tc.MData, tc.Point, 6, tc, true);
			end;

			//周囲にステータス更新
			w := Length(tcr.Title);
			WFIFOW(0, $00d7);
			WFIFOW(2, w + 17);
			WFIFOL(4, tcr.MemberID[0]);
			WFIFOL(8, tcr.ID);
			WFIFOW(12, tcr.Limit);
			WFIFOW(14, tcr.Users);
			WFIFOB(16, tcr.Pub);
			WFIFOS(17, tcr.Title, w);
			SendNCrCmd(tc.MData, tc.Point, w + 17, tc, AvoidSelf);
		end;
		tc.ChatRoomID := 0;
	end;
end;
//------------------------------------------------------------------------------
procedure ChatRoomDisp(Socket: TCustomWinSocket; tc1:TChara);
//周辺のチャットルームを表示する
var
	i	:integer;
	w	:word;
	tcr	:TChatRoom;
begin
	if (tc1.ChatRoomID <> 0) then begin
		i := ChatRoomList.IndexOf(tc1.ChatRoomID);
		if (i <> -1) then begin
			tcr := ChatRoomList.Objects[i] as TChatRoom;
			if (tc1.ID = tcr.MemberID[0]) then begin
				w := Length(tcr.Title);
				WFIFOW(0, $00d7);
				WFIFOW(2, w + 17);
				WFIFOL(4, tcr.MemberID[0]);
				WFIFOL(8, tcr.ID);
				WFIFOW(12, tcr.Limit);
				WFIFOW(14, tcr.Users);
				WFIFOB(16, tcr.Pub);
				WFIFOS(17, tcr.Title, w);
				if Socket <> nil then begin
					Socket.SendBuf(buf, w + 17);
				end;
			end;
		end;
	end;
end;
//------------------------------------------------------------------------------
procedure SendCrCmd(tc:TChara; PacketLen:word; AvoidSelf:boolean = false);
//チャットルームメンバーに同一パケットを送りつける
//AvoidSelfはtrue時自分自身を除くメンバーにパケット送信
var
	i	:integer;
	tc1	:TChara;
	tcr	:TChatRoom;
begin
	i := ChatRoomList.IndexOf(tc.ChatRoomID);
	if (i <> -1) then begin
		tcr := ChatRoomList.Objects[i] as TChatRoom;
		for i := 0 to 19 do begin
			if tcr.MemberID[i] = 0 then break;
			if Chara.IndexOf(tcr.MemberCID[i]) = -1 then Continue;
			tc1 := Chara.IndexOfObject(tcr.MemberCID[i]) as TChara;
			if tc1 = nil then continue;
			if (tc.ID = tc1.ID) and (AvoidSelf = true) then continue;
			if (tc1.Socket <> nil) then begin
				tc1.Socket.SendBuf(buf, PacketLen);
			end;
		end;
	end;
end;
//------------------------------------------------------------------------------
procedure SendNCrCmd(tm:TMap; Point:TPoint; PacketLen:word; tc:TChara = nil; AvoidSelf:boolean = false; AvoidChat:boolean = false);
//チャットルームメンバー以外に同一パケットを送りつける
//AvoidSelfはtrue時自分以外にパケット送信
//AvoidChatはtrue時全チャットルーム入室メンバー以外にパケット送信
var
	i	:integer;
	j	:integer;
	k	:integer;
	tc1	:TChara;
begin
	for j := Point.Y div 8 - 2 to Point.Y div 8 + 2 do begin
		for i := Point.X div 8 - 2 to Point.X div 8 + 2 do begin
			for k := 0 to tm.Block[i][j].CList.Count - 1 do begin
				tc1 := tm.Block[i][j].CList.Objects[k] as TChara;
				if tc1 = nil then continue;
				if (tc.ID = tc1.ID) and (AvoidSelf = true) then continue;
				if (tc1.ChatRoomID <> 0) and (AvoidChat = true) then continue;
				if (tc1.ChatRoomID <> 0) and (tc1.ChatRoomID = tc.ChatRoomID) and (tc.ID <> tc1.ID) then continue;
				if (abs(Point.X - tc1.Point.X) < 16) and (abs(Point.Y - tc1.Point.Y) < 16) and
					(tc1.Socket <> nil) then begin
					tc1.Socket.SendBuf(buf, PacketLen);
				end;
			end;
		end;
	end;
end;
{チャットルーム機能追加ココまで}
//==============================================================================
{露店スキル追加}
procedure VenderExit(tc:TChara; AvoidSelf:boolean = false);
//露店を終了する
//AvoidSelfはtrue時自分自身を除くメンバーにパケット送信
var
	i	:integer;
	j	:integer;
	tv  :TVender;
begin
	if (tc.VenderID <> 0) then begin
		i := VenderList.IndexOf(tc.VenderID);
		if (i <> -1) then begin
			tv := VenderList.Objects[i] as TVender;

			if (AvoidSelf = false) then begin
				//カートにアイテムを戻す
				for j := 0 to tv.MaxCnt - 1 do begin
					if (tv.Idx[j] <> 0) then begin
						WFIFOW( 0, $0124);
						WFIFOW( 2, tv.Idx[j]);
						WFIFOL( 4, tv.Amount[j]);
						WFIFOW( 8, tc.Cart.Item[tv.Idx[j]].ID);
						WFIFOB(10, tc.Cart.Item[tv.Idx[j]].Identify);
						WFIFOB(11, tc.Cart.Item[tv.Idx[j]].Attr);
						WFIFOB(12, tc.Cart.Item[tv.Idx[j]].Refine);
						WFIFOW(13, tc.Cart.Item[tv.Idx[j]].Card[0]);
						WFIFOW(15, tc.Cart.Item[tv.Idx[j]].Card[1]);
						WFIFOW(17, tc.Cart.Item[tv.Idx[j]].Card[2]);
						WFIFOW(19, tc.Cart.Item[tv.Idx[j]].Card[3]);
						tc.Socket.SendBuf(buf, 21);
					end;
				end;

				//カートの重量表示更新
				WFIFOW(0, $0121);
				WFIFOW(2, tc.Cart.Count);
				WFIFOW(4, 100);
				WFIFOL(6, tc.Cart.Weight);
				WFIFOL(10, tc.Cart.MaxWeight);
				tc.Socket.SendBuf(buf, 14);
			end;

			//看板消去を周囲に通知
			WFIFOW(0, $0132);
			WFIFOL(2, tv.ID);
			SendBCmd(tc.Mdata, tc.Point, 6, tc);
			tc.VenderID := 0;

			//露店リスト削除
			//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('Vender(%s) was close / Remaining Vender(%d)', [tv.Title,VenderList.Count-1]));
			VenderList.Delete(VenderList.IndexOf(tv.ID));
			tv.Free;
		end;
	end;
end;
//------------------------------------------------------------------------------
procedure VenderDisp(Socket: TCustomWinSocket; tc1:TChara);
//周辺の露店を表示する
var
	i	:integer;
	tv	:TVender;
begin
	if (tc1.VenderID <> 0) then begin
		i := VenderList.IndexOf(tc1.VenderID);
		if (i <> -1) then begin
			tv := VenderList.Objects[i] as TVender;
			WFIFOW(0, $0131);
			WFIFOL(2, tv.ID);
			WFIFOS(6, tv.Title, 80);
			Socket.SendBuf(buf, 86);
		end;
	end;
end;
{露店スキル追加ココまで}
//==============================================================================
{取引機能追加}
procedure CancelDealings(tc:TChara; AvoidSelf:boolean = false);
//取引をキャンセルする
//AvoidSelfはtrue時自分自身の処理不要
var
	i	:integer;
	j	:integer;
	k	:integer;
	l	:cardinal;
	td  :TItemDB;
	tdl	:TDealings;
begin
	if (tc.DealingID <> 0) then begin
    l := 0;
		i := DealingList.IndexOf(tc.DealingID);
		if (i <> -1) then begin
			tdl := DealingList.Objects[i] as TDealings;
			for k := 0 to 1 do begin
				if (k = 0) then begin
					tc.DealingID := 0;
					if (tdl.UserID[0] = tc.ID) then l := 0 else l := 1;
					if (AvoidSelf = true) then continue;
				end else begin
					if (l = 0) then l := 1 else l := 0;
					tc := CharaPID.IndexOfObject(tdl.UserID[l]) as TChara;
					if (tc = nil) then continue;
					tc.DealingID := 0;
				end;

				//アイテム返還
				if (tdl.Cnt[l] <> 0) then begin
					for i := 0 to tdl.Cnt[l] - 1 do begin
						if (tc.Item[tdl.ItemIdx[l][i]].ID = 0) then break;
						td := tc.Item[tdl.ItemIdx[l][i]].Data;
						// {Alex: SearchCInventory was calling the wrong index. }
						//j := SearchCInventory(tc, td.ID, td.IEquip);
						//SendCGetItem(tc, j, tdl.Amount[l][i]);
                        SendCGetItem(tc, tdl.ItemIdx[l][i], tdl.Amount[l][i]);
					end;
				end;
				if (tdl.Zeny[l] <> 0) then begin
					// Update zeny
          SendCStat1(tc, 1, $0014, tc.Zeny);
				end;
				//取引キャンセルパケ
				WFIFOW(0, $00ee);
				tc.Socket.SendBuf(buf, 2);
			end;
			//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('Dealings(%d) was canceled / Remaining Dealings(%d)', [tdl.ID,DealingList.Count-1]));
			DealingList.Delete(DealingList.IndexOf(tdl.ID));
			tdl.Free;
		end;
	end;
end;
{取引機能追加ココまで}
//==============================================================================
{NPCイベント追加}
function ConvFlagValue(tc:TChara; str:string; mode:boolean = false) : Integer;
// スクリプトフラグを変換する
// mode=true時はエラーの場合に-1を返す
var
	i	:integer;
	j	:integer;
begin
	if (Copy(str, 1, 1) <> '\') then begin
		Val(str, i, j);
		if j <> 0 then begin
			Val(tc.Flag.Values[str], i, j);
			if j <> 0 then begin
				if mode = true then i := -1 else i := 0;
			end;
		end;
	end else begin
		Val(ServerFlag.Values[str], i, j);
		if (j <> 0) then begin
			if mode = true then i := -1 else i := 0;
		end;
	end;
	Result := i;
end;
{NPCイベント追加ココまで}
//==============================================================================
{ギルド機能追加}
procedure SendGuildInfo(tc:TChara; Tab:Byte; GuildM:boolean = false; AvoidSelf:boolean = false);
//ギルド情報を送信する
//GuildM=true時はギルドメンバー全員に送信する
var
	i   :integer;
	j   :integer;
	k   :integer;
	w   :word;
	tc1 :TChara;
	tg  :TGuild;
	tgb :TGBan;
begin
	if (Tab > 5) then exit;
	j := GuildList.IndexOf(tc.GuildID);
	if (j = -1) then exit;
	tg := GuildList.Objects[j] as TGuild;
	with tg do begin
		case Tab of
		0: //ギルド基本情報
			begin
				WFIFOW( 0, $01b6);
				WFIFOL( 2, ID);
				WFIFOL( 6, LV);
				WFIFOL(10, GetGuildConUsers(tg));
				WFIFOL(14, MaxUsers);
				WFIFOL(18, SLV div RegUsers);
				WFIFOL(22, EXP);
				WFIFOL(26, NextEXP);
				WFIFOL(30, Present);
				Move(DisposFV, buf[34], 4);
				Move(DisposRW, buf[38], 4);
				WFIFOL(42, 2);//members?
				WFIFOS(46, Name, 24);
				WFIFOS(70, MasterName, 24);
				WFIFOS(94, Agit, 20);
				if (GuildM = false) then tc.Socket.SendBuf(buf, 114)
				else SendGuildMCmd(tc, 114, AvoidSelf);
				//同盟・敵対情報
				i :=GetGuildRelation(tg, tc);
				if (i <> -1) then begin
					if (GuildM = false) then tc.Socket.SendBuf(buf, i)
					else SendGuildMCmd(tc, i, AvoidSelf);
				end;
			end;
		1: //ギルド員情報
			begin
				//職位情報
				w := 28 * 20 + 4;
				WFIFOW( 0, $0166);
				WFIFOW( 2, w);
				for i := 0 to 19 do begin
					WFIFOL(i * 28 + 4, i);
					WFIFOS(i * 28 + 8, PosName[i], 24);
				end;
				if (GuildM = false) then tc.Socket.SendBuf(buf, w)
				else SendGuildMCmd(tc, w, AvoidSelf);
				//メンバー情報
				w := 4;
				WFIFOW( 0, $0154);
				for i := 0 to 35 do begin
          if tg.Member[i] <> nil then begin
              if UseSQL then begin
                j := Chara.IndexOf(tg.MemberID[i]);
                if j = -1 then begin
                  Load_Characters(tg.Member[i].CID);
                end;
              end;
                    end;
					tc1 := Member[i];
					if (tc1 <> nil) then begin
						WFIFOL(w      , tc1.ID);
						WFIFOL(w +   4, tc1.CID);
						WFIFOW(w +   8, tc1.Hair);
						WFIFOW(w +  10, tc1.HairColor);
						WFIFOW(w +  12, tc1.Gender);
						WFIFOW(w +  14, tc1.JID);
						WFIFOW(w +  16, tc1.BaseLV);
						WFIFOL(w +  18, MemberEXP[i]);
						if (tc1.Login = 2) then k := 1 else k := 0;
						WFIFOL(w +  22, k);
						WFIFOL(w +  26, MemberPos[i]);
						WFIFOS(w +  30, '', 50);//?
						WFIFOS(w +  80, tc1.Name, 24);
						w := w + 104;
					end;
				end;
				WFIFOW( 2, w);
				if (GuildM = false) then tc.Socket.SendBuf(buf, w)
				else SendGuildMCmd(tc, w, AvoidSelf);
			end;
		2: //職位設定
			begin
				//職位情報
				w := 28 * 20 + 4;
				WFIFOW( 0, $0166);
				WFIFOW( 2, w);
				for i := 0 to 19 do begin
					WFIFOL( 4 + i * 28, i);
					WFIFOS( 8 + i * 28, PosName[i], 24);
				end;
				if (GuildM = false) then tc.Socket.SendBuf(buf, w)
				else SendGuildMCmd(tc, w, AvoidSelf);
				//権限＆上納
				w := 16 * 20 + 4;
				WFIFOW( 0, $0160);
				WFIFOW( 2, w);
				for i := 0 to 19 do begin
					WFIFOL( 4 + i * 16, i);
					if (PosInvite[i] = true) then j := 16 else j := 0;
					if (PosPunish[i] = true) then j := j + 1;
					WFIFOL( 8 + i * 16, j);
					WFIFOL(12 + i * 16, i);
					WFIFOL(16 + i * 16, PosEXP[i]);
				end;
				if (GuildM = false) then tc.Socket.SendBuf(buf, w)
				else SendGuildMCmd(tc, w, AvoidSelf);
			end;
		3: //ギルドスキル
			begin
				w := 37 * 5 + 6;
				j := 0;
				WFIFOW( 0, $0162);
				WFIFOW( 2, w);
				WFIFOW( 4, GSkillPoint);
				for i := 10000 to 10004 do begin
					WFIFOW( 6 + 37 * j, i);
					WFIFOW( 8 + 37 * j, 0);
					WFIFOW(10 + 37 * j, 0);
					WFIFOW(12 + 37 * j, GSkill[i].Lv);
					WFIFOW(14 + 37 * j, 0);
					WFIFOW(16 + 37 * j, 0);
					WFIFOS(18 + 37 * j, GSkill[i].Data.IDC, 24);
                                        WFIFOB(42 + 37 * j, 1);
					Inc(j);
				end;
				if (GuildM = false) then tc.Socket.SendBuf(buf, w)
				else SendGuildMCmd(tc, w, AvoidSelf);
			end;
		4: //追放者リスト
			begin
				if (GuildBanList.Count > 0) then begin
					w := 4;
					WFIFOW( 0, $0163);
					for i := 0 to GuildBanList.Count - 1 do begin
						tgb := GuildBanList.Objects[i] as TGBan;
						WFIFOS(w     , tgb.Name, 24);
						WFIFOS(w + 24, tgb.AccName, 24);
						WFIFOS(w + 48, tgb.Reason, 40);
						Inc(w, 88);
					end;
					WFIFOW( 2, w);
					SendGuildMCmd(tc, w);
				end;
			end;
		5: //告知事項
			begin
				//不要
			end;
		end;
	end;
end;
//------------------------------------------------------------------------------
procedure SendGuildMCmd(tc:TChara; PacketLen:word; AvoidSelf:boolean = false);
//ギルドメンバーに同一パケットを送りつける
//AvoidSelfはtrue時自分自身を除くメンバーにパケット送信
var
	i   :integer;
	j   :integer;
	tc1 :TChara;
	tg  :TGuild;
begin
	j := GuildList.IndexOf(tc.GuildID);
	if (j = -1) then exit;
	tg := GuildList.Objects[j] as TGuild;
	for i := 0 to tg.RegUsers - 1 do begin
		if tg.MemberID[i] = 0 then break;
		if Chara.IndexOf(tg.MemberID[i]) = -1 then break;
		tc1 := tg.Member[i];
    if tc1 <> nil then begin
		if tc1.Login <> 2 then continue;
		  if (tc.ID = tc1.ID) and (AvoidSelf = true) then continue;
		  tc1.Socket.SendBuf(buf, PacketLen);
    end;
	end;
end;
//------------------------------------------------------------------------------
procedure CalcGuildLvUP(tg:TGuild; tc:TChara; GEXP:cardinal);
begin
	tg.EXP := tg.EXP + GEXP;
	tg.MemberEXP[tc.GuildPos] := tg.MemberEXP[tc.GuildPos] + GEXP;

        if (tg.EXP >= GExpTable[tg.LV]) then begin
                while (tg.EXP >= GExpTable[tg.LV]) do begin
			tg.EXP := tg.EXP - GExpTable[tg.LV];
			if (tg.LV < 50) then begin
				tg.LV := tg.LV + 1;
				tg.GSkillPoint := tg.GSkillPoint + 1;
			end;
		end;
		SendGuildInfo(tc, 3, true);
	end;
	SendGuildInfo(tc, 0, true);
	SendGuildInfo(tc, 1, true);
end;
//------------------------------------------------------------------------------
procedure SendGLoginInfo(tg:TGuild; tc:TChara);
//ログイン時のギルド情報を送信する
var
	l :word;
begin
	WFIFOW( 0, $016c);
	WFIFOL( 2, tg.ID);
	WFIFOL( 6, tg.Emblem);
	if (tg.PosInvite[tc.GuildPos] = true) then l := 16 else l := 0;
	if (tg.PosPunish[tc.GuildPos] = true) then l := l + 1;
	WFIFOL(10, l);
	if (tc.Name = tg.MasterName) then WFIFOB(14, 1) else WFIFOB(14, 0);
	WFIFOL(15, 1);//?
	WFIFOS(19, tg.Name, 24);
	tc.Socket.SendBuf(buf, 43);
end;
//------------------------------------------------------------------------------
function GetGuildConUsers(tg:TGuild) : word;
//ログイン中のギルドメンバー数を取得する
var
	i  :integer;
	w  :word;
begin
	w := 0;
	for i := 0 to 35 do begin
		if (tg.Member[i] <> nil) then begin
			if (tg.Member[i].Login = 2) then Inc(w);
		end;
	end;
	Result := w;
end;
//------------------------------------------------------------------------------
procedure ClaimGuildCastle(ID:cardinal;MapName:string);
var
	i  :integer;
  tg :TGuild;
  tgc:TCastle;
begin
i := GuildList.IndexOf(ID);
if (i <> -1) then begin
tg := GuildList.Objects[i] as TGuild;
tgc := TCastle.Create;
		with tgc do begin
			Name := MapName;
      GID  := tg.ID;
      GName:= tg.Name;
      GMName:=tg.MasterName;
      GKafra:=0;
      EDegree:=0;
      ETrigger:=0;
      DDegree:=0;
      DTrigger:=0;
      for i := 0 to 7 do begin
      GuardStatus[i] := 0;
      end;
		end;
CastleList.AddObject(tgc.Name, tgc);
end;
end;
//------------------------------------------------------------------------------
procedure EnableGuildKafra(MapName:string;KafraName:string;Mode:integer);
var
	i,j,k,l  :integer;
	tm           :TMap;
	tm1          :TMap;
	tn1          :TNPC;
	tc1          :TChara;
begin
	if Map.IndexOf(MapName) = -1 then
		MapLoad(MapName);
	tm1 := Map.Objects[Map.IndexOf(MapName)] as TMap;
	tm := Map.Objects[Map.IndexOf(MapName)] as TMap;
	if (Mode = 1) then begin
		//enable
		i := -1;
		for k := 0 to tm1.NPC.Count - 1 do begin
			tn1 := tm1.NPC.Objects[k] as TNPC;
			if (tn1.Name = KafraName) then begin
				i := 0;
				break;
			end;
		end;
		//if (tn1.ScriptInitS <> -1) then begin
			//OnInitラベルを実行
			//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('OnInit Event(%d)', [tn1.ID]));
			//tc1 := TChara.Create;
			//tc1.TalkNPCID := tn1.ID;
			//tc1.ScriptStep := tn1.ScriptInitS;
			//tc1.AMode := 3;
			//tc1.AData := tn1;
			//tc1.Login := 0;
			//NPCScript(tc1,0,1);
			//tn.ScriptInitD := true;
			//tc1.Free;
		//end;
		if (i = 0) and (tn1.Enable = false) then begin
			tn1.Enable := true;
			for j := tn1.Point.Y div 8 - 2 to tn1.Point.Y div 8 + 2 do begin
				for i := tn1.Point.X div 8 - 2 to tn1.Point.X div 8 + 2 do begin
					for k := 0 to tm1.Block[i][j].CList.Count - 1 do begin
						tc1 := tm1.Block[i][j].Clist.Objects[k] as TChara;
						if (abs(tc1.Point.X - tn1.Point.X) < 16) and (abs(tc1.Point.Y - tn1.Point.Y) < 16) then begin
							SendNData(tc1.Socket, tn1, tc1.ver2);
						end;
					end;
				end;
			end;
		end;
	end else begin
		//disable
		i := -1;
		for k := 0 to tm1.NPC.Count - 1 do begin
			tn1 := tm1.NPC.Objects[k] as TNPC;
			if (tn1.Name = KafraName) then begin
				i := 0;
				break;
			end;
		end;
		if (i = 0) and (tn1.Enable = true) then begin
			tn1.Enable := false;
			l := tm.TimerAct.IndexOf(tn1.ID);
			if (l <> -1) then begin
				//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('NPC Timer(%d) was deleted / Remaining Timer(%d)', [tn1.ID,tm.TimerAct.Count-1]));
				tm.TimerAct.Delete(tm.TimerAct.IndexOf(tn1.ID));
			end;
			for j := tn1.Point.Y div 8 - 2 to tn1.Point.Y div 8 + 2 do begin
				for i := tn1.Point.X div 8 - 2 to tn1.Point.X div 8 + 2 do begin
					for k := 0 to tm1.Block[i][j].CList.Count - 1 do begin
						tc1 := tm1.Block[i][j].Clist.Objects[k] as TChara;
						if (abs(tc1.Point.X - tn1.Point.X) < 16) and (abs(tc1.Point.Y - tn1.Point.Y) < 16) then begin
							WFIFOW(0, $0080);
							WFIFOL(2, tn1.ID);
							WFIFOB(6, 0);
							tc1.Socket.SendBuf(buf, 7);
						end;
					end;
				end;
			end;
		end;
	end;
end;
//------------------------------------------------------------------------------
function GetGuildKafra(tn:TNPC) : integer;
var{ChrstphrR 2004/04/28 Eliminated unused variables}
	Idx : Integer;
begin
	Result := 0;
	Idx := CastleList.IndexOf(tn.Reg);

	if (Idx > -1) then
		Result := (CastleList.Objects[Idx] AS TCastle).GKafra;
end;//func GetGuildKafra()
//------------------------------------------------------------------------------
procedure SetGuildKafra(tn:TNPC;mode:integer);
var{ChrstphrR 2004/04/28 Eliminated unused variables}
	Idx : Integer;
begin
	Idx := CastleList.IndexOf(tn.Reg);

	if (Idx > -1) then
		(CastleList.Objects[Idx] as TCastle).GKafra := mode;
end;
//------------------------------------------------------------------------------
procedure SpawnNPCMob(tn:TNPC;MobName:string;X:integer;Y:integer;SpawnDelay1:cardinal;SpawnDelay2:cardinal);
var
	j   : Integer;
	k   : Integer;
	m   : Integer;
	ts  : TMob;
	tm  : TMap;
	te  : TEmp;
	tgc : TCastle;
begin
          //debugout.lines.add('[' + TimeToStr(Now) + '] ' + MobName);
          tm := Map.Objects[Map.IndexOf(tn.Map)] as TMap;
          ts := TMob.Create;
					ts.Data := MobDBName.Objects[MobDBName.IndexOf(MobName)] as TMobDB;
					ts.ID := NowMobID;
					Inc(NowMobID);
					ts.Name := ts.Data.JName;
					ts.JID := ts.Data.ID;
					ts.Map := tn.Map;
          ts.Data.isLink :=false;
          ts.NPCID := tn.ID;

          if (X = 0) and (Y = 0) then begin
          repeat
					ts.Point.X := Random(tm.Size.X - 2);
					ts.Point.Y := Random(tm.Size.y - 2);
          until ( (tm.gat[ts.Point.X][ts.Point.Y] <> 1) and (tm.gat[ts.Point.X][ts.Point.Y] <> 5) );
          end else begin
					ts.Point.X := X;
					ts.Point.Y := Y;
          end;

					ts.Dir := Random(8);
					ts.HP := ts.Data.HP;
					ts.Speed := ts.Data.Speed;

					ts.SpawnDelay1 := SpawnDelay1;
					ts.SpawnDelay2 := SpawnDelay2;

					ts.SpawnType := 0;
					ts.SpawnTick := 0;

					ts.ATarget := 0;
					ts.ATKPer := 100;
					ts.DEFPer := 100;
					ts.DmgTick := 0;

          ts.Element := ts.Data.Element;

          ts.Name := ts.Data.JName;

					ts.Data.MEXP := 0;
					ts.Data.EXP := 0;
					ts.Data.JEXP := 0;

           ts.isLooting := False;
  						for j:= 1 to 10 do begin
								ts.Item[j].ID := 0;
								ts.Item[j].Amount := 0;
								ts.Item[j].Equip := 0;
								ts.Item[j].Identify := 0;
								ts.Item[j].Refine := 0;
								ts.Item[j].Attr := 0;
								ts.Item[j].Card[0] := 0;
								ts.Item[j].Card[1] := 0;
								ts.Item[j].Card[2] := 0;
								ts.Item[j].Card[3] := 0;
						  end;
              if ts.Data.isDontMove then
              ts.MoveWait := 4294967295
              else
              ts.MoveWait := TimeGetTime() + 5000 + Cardinal(Random(10000));

              if (ts.JID = 1288) then begin
              ts.isEmperium := true;
              m := CastleList.IndexOf(ts.Map);
              if (m <> - 1) then begin
              tgc := CastleList.Objects[m] as TCastle;
              ts.GID := tgc.GID;
              end;
              k := EmpList.IndexOf(ts.Map);
              if (k = -1) then begin
              te := TEmp.Create;
		          with te do begin
              Map := ts.Map;
              EID := ts.ID;
              end;
		          EmpList.AddObject(te.Map, te);
              end;
              end;

          ts.isActive := ts.Data.isActive;

					for j := 0 to 31 do begin
						ts.EXPDist[j].CData := nil;
						ts.EXPDist[j].Dmg := 0;
					end;
					if ts.Data.MEXP <> 0 then begin
						for j := 0 to 31 do begin
							ts.MVPDist[j].CData := nil;
							ts.MVPDist[j].Dmg := 0;
						end;
						ts.MVPDist[0].Dmg := ts.Data.HP * 30 div 100; //FAに30%加算
					end;
          ts.isSummon := True;

					tm.Mob.AddObject(ts.ID, ts);
					tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);

					//SendMData(tc.Socket, ts);
					//SendBCmd(tm,ts.Point,41,tc,False);
end;
//------------------------------------------------------------------------------

procedure SpawnEventMob(tn:TNPC;MobID:cardinal;MobName:string;X:integer;Y:integer;DropItem:cardinal);
var
	j,k :integer;
  m     :integer;
  ts    :TMob;
  tm    :TMap;
  te    :TEmp;
  tgc   :TCastle;
begin
          //debugout.lines.add('[' + TimeToStr(Now) + '] ' + MobName);
          tm := Map.Objects[Map.IndexOf(tn.Map)] as TMap;
          ts := TMob.Create;
					ts.Data := MobDB.Objects[MobDB.IndexOf(MobID)] as TMobDB;
					ts.ID := NowMobID;
					Inc(NowMobID);
					ts.Name := MobName;
					ts.JID := ts.Data.ID;
					ts.Map := tn.Map;
          ts.Data.isLink :=false;
          //ts.NPCID := tn.ID;

          //if (X = 0) and (Y = 0) then begin
          //repeat
					//ts.Point.X := Random(tm.Size.X - 2);
					//ts.Point.Y := Random(tm.Size.y - 2);
          //until ( (tm.gat[ts.Point.X][ts.Point.Y] <> 1) and (tm.gat[ts.Point.X][ts.Point.Y] <> 5) );
          //end else begin
					ts.Point.X := X;
					ts.Point.Y := Y;
          //end;

					ts.Dir := Random(8);
					ts.HP := ts.Data.HP;
					ts.Speed := ts.Data.Speed;

					//ts.SpawnDelay1 := SpawnDelay1;
					//ts.SpawnDelay2 := SpawnDelay2;

					ts.SpawnType := 0;
					ts.SpawnTick := 0;

					ts.ATarget := 0;
					ts.ATKPer := 100;
					ts.DEFPer := 100;
					ts.DmgTick := 0;

          ts.Element := ts.Data.Element;

          //ts.Name := ts.Data.JName;

					ts.Data.MEXP := 0;
					ts.Data.EXP := 0;
					ts.Data.JEXP := 0;

          ts.isLooting := False;
  						for j:= 1 to 10 do begin
								ts.Item[j].ID := 0;
								ts.Item[j].Amount := 0;
								ts.Item[j].Equip := 0;
								ts.Item[j].Identify := 0;
								ts.Item[j].Refine := 0;
								ts.Item[j].Attr := 0;
								ts.Item[j].Card[0] := 0;
								ts.Item[j].Card[1] := 0;
								ts.Item[j].Card[2] := 0;
								ts.Item[j].Card[3] := 0;
						  end;
              if DropItem <> 0 then begin
                ts.Item[1].ID := DropItem;
                ts.Item[1].Amount := 1;
                ts.Item[1].Data := ItemDB.Objects[ItemDB.IndexOf(DropItem)] as TItemDB;
              end;

              if ts.Data.isDontMove then
              ts.MoveWait := 4294967295
              else
              ts.MoveWait := TimeGetTime() + 5000 + Cardinal(Random(10000));

              if (ts.JID = 1288) then begin
              ts.isEmperium := true;
              m := CastleList.IndexOf(ts.Map);
              if (m <> - 1) then begin
              tgc := CastleList.Objects[m] as TCastle;
              ts.GID := tgc.GID;
              end;
              k := EmpList.IndexOf(ts.Map);
              if (k = -1) then begin
              te := TEmp.Create;
		          with te do begin
              Map := ts.Map;
              EID := ts.ID;
              end;
		          EmpList.AddObject(te.Map, te);
              end;
              end;

          ts.isActive := ts.Data.isActive;

					for j := 0 to 31 do begin
						ts.EXPDist[j].CData := nil;
						ts.EXPDist[j].Dmg := 0;
					end;
					if ts.Data.MEXP <> 0 then begin
						for j := 0 to 31 do begin
							ts.MVPDist[j].CData := nil;
							ts.MVPDist[j].Dmg := 0;
						end;
						ts.MVPDist[0].Dmg := ts.Data.HP * 30 div 100; //FAに30%加算
					end;
          ts.isSummon := True;

					tm.Mob.AddObject(ts.ID, ts);
					tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);

					//SendMData(tc.Socket, ts);
					//SendBCmd(tm,ts.Point,41,tc,False);
end;
//------------------------------------------------------------------------------
function CheckGuildID(tn:TNPC; tc:TChara) : word;
var
  tgc:TCastle;
  i  :integer;
	w  :word;
begin
	w := 0;
  i := CastleList.IndexOf(tn.Reg);

  if (i <> - 1) then begin
  tgc := CastleList.Objects[i] as TCastle;
  if (tgc.GID = tc.GuildID) then begin
  w := 1;
  end;
  end else begin
  w := 0;
  end;

	Result := w;
end;
//------------------------------------------------------------------------------

(*-----------------------------------------------------------------------------*
CheckGuildMaster
Pre:
	tc is a valid, non-nil TChara
	tn is a valid, non-nil TNPC
	(In other words, this function's not responsible for bad input)
Post:
	If the Character is the Guild Master of the same Guild the NPC owns,
	1 is returned, else 0.
*-----------------------------------------------------------------------------*)
Function  CheckGuildMaster(
		tn : TNPC;
		tc : TChara
	) : Word;
Var{ChrstphrR 2004/04/28 Eliminated unused variables}
	Idx :integer;
Begin
	//Check Preconditions
	Assert(tn <> NIL, 'CheckGuildMaster() - NPC passed is invalid');
	Assert(tc <> NIL, 'CheckGuildMaster() - Character passed is invalid');
	//--
	Result := 0;
	Idx := CastleList.IndexOf(tn.Reg);

	if (Idx > - 1) AND ((CastleList.Objects[Idx] AS TCastle).GMName = tc.Name) then
		Result := 1;
End;(* Func CheckGuildMaster()
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*
GetGuildID
Pre:
	tn is a valid, non-nil TNPC
	(In other words, this function's not responsible for bad input)
Post:
	If tn is associated with a guild, returns the Guild ID, else returns 0
*-----------------------------------------------------------------------------*)
Function  GetGuildID(
		tn : TNPC
	) : Word;
Var{ChrstphrR 2004/04/28 Eliminated unused variables}
	Idx : Integer;
Begin
	//Check Preconditions
	Assert(tn <> NIL, 'GetGuildId() - NPC passed is invalid');
	//--
	Result := 0;
	Idx := CastleList.IndexOf(tn.Reg);

	if (Idx > - 1) then
		Result := (CastleList.Objects[Idx] AS TCastle).GID;
End;(* Func GetGuildID()
*-----------------------------------------------------------------------------*)

//------------------------------------------------------------------------------
procedure GuildDInvest(tn:TNPC);
var
  tgc:TCastle;
  i,k  :integer;
  ts  :TMob;
  tm  :TMap;
begin
  i := CastleList.IndexOf(tn.Reg);

  if (i <> - 1) then begin
  tgc := CastleList.Objects[i] as TCastle;
  tm := Map.Objects[Map.IndexOf(tn.Reg)] as TMap;
  if (tgc.DTrigger < 2) then begin
  tgc.DDegree := tgc.DDegree + 10000;
  tgc.DTrigger := tgc.DTrigger + 1;
  for k := 0 to tm.Mob.Count - 1  do begin
  ts := tm.Mob.Objects[k] as TMob;
  if (ts.isGuardian = tgc.GID) then begin
  ts.HP := ts.HP + 2000;
  end;
  end;
  end;
  end;
  
end;
//------------------------------------------------------------------------------
procedure CallGuildGuard(tn:TNPC;guard:integer);
var{ChrstphrR 2004/04/28 eliminated unused variables}
	tgc : TCastle;
	j   : integer;
	ts  : TMob;
	tm  : TMap;
	te  : TEmp;
begin
	//guard := guard - 1;
	tm := Map.Objects[Map.IndexOf(tn.Map)] as TMap;
	j := CastleList.IndexOf(tm.Name);
	if (j <> - 1) then begin
		tgc := CastleList.Objects[j] as TCastle;
		te  := nil;
		j := EmpList.IndexOf(tm.Name);
		if (j <> - 1) then te := EmpList.Objects[j] as TEmp;
		ts := TMob.Create;
		//if (tgc.GuardStatus[guard] = 1) then begin
		case guard of
		0,1,2:
			begin
				ts.Data := MobDBName.Objects[MobDBName.IndexOf('SOLDIER_GUARDIAN')] as TMobDB;
			end;
		3,4:
			begin
				ts.Data := MobDBName.Objects[MobDBName.IndexOf('ARCHER_GUARDIAN')] as TMobDB;
			end;
		5,6,7:
			begin
				ts.Data := MobDBName.Objects[MobDBName.IndexOf('KNIGHT_GUARDIAN')] as TMobDB;
			end;
		end;//case
		ts.ID := NowMobID;
		Inc(NowMobID);
		ts.Name := ts.Data.JName;
		ts.JID := ts.Data.ID;
		ts.Map := tm.Name;
		ts.Data.isLink :=false;
		ts.isGuardian := tgc.GID;

		if (te <> nil) then begin
			ts.EmperiumID := te.EID;
		end else begin
			ts.EmperiumID := 0;
		end;

		repeat
			ts.Point1.X := Random(tm.Size.X - 2);
			ts.Point1.Y := Random(tm.Size.y - 2);
		until ( (tm.gat[ts.Point1.X][ts.Point1.Y] <> 1) and (tm.gat[ts.Point1.X][ts.Point1.Y] <> 5) );

		ts.Point := ts.Point1;

		ts.Dir := Random(8);
		ts.HP := ts.Data.HP + cardinal(tgc.DTrigger * 2000);
		ts.Speed := ts.Data.Speed;
		ts.SpawnDelay1 := $7FFFFFFF;
		ts.SpawnDelay2 := 0;
		ts.SpawnType := 0;
		ts.SpawnTick := 0;
		if ts.Data.isDontMove then
			ts.MoveWait := $FFFFFFFF
		else
			ts.MoveWait := timeGetTime;
		ts.ATarget := 0;
		ts.ATKPer := 100;
		ts.DEFPer := 100;
		ts.DmgTick := 0;
		ts.Element := ts.Data.Element;
		ts.Name := ts.Data.JName;
		ts.isActive := ts.Data.isActive;
		ts.MoveWait := timeGetTime();
		for j := 0 to 31 do begin
			ts.EXPDist[j].CData := nil;
			ts.EXPDist[j].Dmg := 0;
		end;
		if ts.Data.MEXP <> 0 then begin
			for j := 0 to 31 do begin
				ts.MVPDist[j].CData := nil;
				ts.MVPDist[j].Dmg := 0;
			end;
			ts.MVPDist[0].Dmg := ts.Data.HP * 30 div 100; //FAに30%加算
		end;
		ts.isSummon := True;
		tm.Mob.AddObject(ts.ID, ts);
		tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
	end;
end;//proc CallGuildGuard()
//------------------------------------------------------------------------------


(*-----------------------------------------------------------------------------*
GetGuildEDegree()

Pre:
	tn is a valid, non-nil TNPC
	(In other words, this function's not responsible for bad input)
Post:
	If the NPC is linked to a Guild the EDegree property value is returned,
	else 0.
*-----------------------------------------------------------------------------*)
Function  GetGuildEDegree(
		tn : TNPC
	) : Cardinal;
Var
	Idx : Integer;
Begin
	//Check Preconditions
	Assert(tn <> NIL, 'GetGuildEDegree() - NPC passed is invalid');
	//--
	Result := 0;
	Idx := CastleList.IndexOf(tn.Reg);

	if (Idx > -1) then
		Result := (CastleList.Objects[Idx] AS TCastle).EDegree;
End;(* Func GetGuildEDegree()
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*
GetGuildETrigger

Pre:
	tn is a valid, non-nil NPC
Post:
	if the NPC is part of a guild, the ETrigger property value is returned,
	else 0
*-----------------------------------------------------------------------------*)
Function  GetGuildETrigger(
		tn : TNPC
	) : Word;
Var
	Idx : Integer;
Begin
	//Check Preconditions
	Assert(tn <> NIL, 'GetGuildETrigger() -- NPC passed is invalid');
	//--

	Result := 0;
	Idx := CastleList.IndexOf(tn.Reg);

	if (Idx > -1) then
		Result := (CastleList.Objects[Idx] AS TCastle).ETrigger;
End;(* Func GetGuildETrigger()
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*
GetGuildDDegree

Pre:
	tn is a valid, non-nil NPC
Post:
	if the NPC is part of a guild, the DDegree property value is returned,
	else 0
*-----------------------------------------------------------------------------*)
Function  GetGuildDDegree(
		tn : TNPC
	) : Cardinal;
Var
	Idx : Integer;
Begin
	//Check Preconditions
	Assert(tn <> NIL, 'GetGuildETrigger() -- NPC passed is invalid');
	//--

	Result := 0;
	Idx := CastleList.IndexOf(tn.Reg);

	if (Idx > -1) then
		Result := (CastleList.Objects[Idx] AS TCastle).DDegree;
End;(* Func GetGuildDDegree()
*-----------------------------------------------------------------------------*)


//------------------------------------------------------------------------------
function GetGuildDTrigger(tn:TNPC) : word;
var
  tgc:TCastle;
  i  :integer;
	w  :word;
begin
	w := 0;
  i := CastleList.IndexOf(tn.Reg);

  if (i <> - 1) then begin
  tgc := CastleList.Objects[i] as TCastle;
  w := tgc.DTrigger;
  end else begin
  w := 0;
  end;

	Result := w;
end;
//------------------------------------------------------------------------------
function GetGuildName(tn:TNPC) : string;
var
  tgc:TCastle;
  i  :integer;
	w  :string;
begin
	w := '';
  i := CastleList.IndexOf(tn.Reg);
  if (i <> - 1) then begin
  tgc := CastleList.Objects[i] as TCastle;
  w := tgc.GName;
  end else begin
  w := '$guildname';
  end;

	Result := w;
end;
//------------------------------------------------------------------------------
function GetGuildMName(tn:TNPC) : string;
var
  tgc:TCastle;
  i  :integer;
	w  :string;
begin
	w := '';
  i := CastleList.IndexOf(tn.Reg);
  if (i <> - 1) then begin
  tgc := CastleList.Objects[i] as TCastle;
  w := tgc.GMName;
  end else begin
  w := '$guildmaster';
  end;

	Result := w;
end;
//------------------------------------------------------------------------------
function GetGuildRelation(tg:TGuild; tc:TChara) : integer;
//同盟・敵対ギルド情報を送信する
var
	i   :integer;
	w   :word;
	tgl :TGRel;
begin
	if (tg.RelAlliance.Count = 0) and (tg.RelHostility.Count = 0) then begin
		Result := -1;
		exit;
	end;
	w := 4;
	WFIFOW( 0, $014c);
	for i := 0 to tg.RelAlliance.Count - 1 do begin
		tgl := tg.RelAlliance.Objects[i] as TGRel;
		WFIFOL(w, 0);
		WFIFOL(w + 4, tgl.ID);
		WFIFOS(w + 8, tgl.GuildName, 24);
		Inc(w, 32);
	end;
	for i := 0 to tg.RelHostility.Count - 1 do begin
		tgl := tg.RelHostility.Objects[i] as TGRel;
		WFIFOL(w, 1);
		WFIFOL(w + 4, tgl.ID);
		WFIFOS(w + 8, tgl.GuildName, 24);
		Inc(w, 32);
	end;
	WFIFOW( 2, w);
	Result := w;
end;
//------------------------------------------------------------------------------
procedure KillGuildRelation(tg:TGuild; tg1:TGuild; tc:TChara; tc1:TChara; RelType:byte);
//同盟・敵対関係を解消する
var
	j   : Integer;
	tgl : TGRel;
begin
	//解消通知
	if (RelType = 0) then begin
		//同盟解消(自分ギルド)
		j := tg.RelAlliance.IndexOf(tg1.Name);
		if (j <> -1) then begin
			tgl := tg.RelAlliance.Objects[j] as TGRel;
			if UseSQL then DeleteGuildAllyInfo(tg.ID,tg1.Name,1);
			tg.RelAlliance.Delete(j);
			WFIFOW( 0, $0184);
			WFIFOL( 2, tg1.ID);
			WFIFOL( 6, RelType);
			SendGuildMCmd(tc, 10);
		end;
		//同盟解消(相手ギルド)
		j := tg1.RelAlliance.IndexOf(tg.Name);
		if (j <> -1) then begin
			tgl := tg1.RelAlliance.Objects[j] as TGRel;
			if UseSQL then DeleteGuildAllyInfo(tg1.ID,tg.Name,1);
			tg1.RelAlliance.Delete(j);
			WFIFOW( 0, $0184);
			WFIFOL( 2, tg.ID);
			WFIFOL( 6, RelType);
			SendGuildMCmd(tc1, 10);
		end;
	end else begin
		//敵対解消(自分ギルドのみ)
		j := tg.RelHostility.IndexOf(tg1.Name);
		if (j <> -1) then begin
			tgl := tg.RelHostility.Objects[j] as TGRel;
			if UseSQL then DeleteGuildAllyInfo(tg.ID,tg1.Name,2);
			tg.RelHostility.Delete(j);
			WFIFOW( 0, $0184);
			WFIFOL( 2, tg1.ID);
			WFIFOL( 6, RelType);
			SendGuildMCmd(tc, 10);
		end;
	end;
end;
//------------------------------------------------------------------------------
function LoadEmblem(tg:TGuild) : word;
//ギルドエンブレムを読み込む
var
	i     :integer;
	l     :cardinal;
	str   :string;
	embfs :TFileStream;
	embdt :PByte;
	embpt :PByte;
begin
	//ファイルチェック
	str := AppPath + 'emblem\' + IntToStr(tg.ID) + '_' + IntToStr(tg.Emblem) + '.emb';
	if not FileExists(str) then begin
		Result := 0;
		exit;
	end;

	//ファイル読み込み
	embfs := TFileStream.Create(str, fmOpenRead);
        try
        l := embfs.Size;
        GetMem(embdt, l);
        embfs.Read(embdt^, l);
        finally
	embfs.Free;
	end;
        if (l = 0) then begin
        Result := 0;
				end else begin
          embpt := embdt;
          WFIFOW( 0, $0152);
          WFIFOW( 2, l + 12);
          WFIFOL( 4, tg.ID);
          WFIFOL( 8, tg.Emblem);
          for i := 0 to l - 1 do begin
              WFIFOB(i + 12, embpt^);
              Inc(embpt);
          end;
          Result := l + 12;
	end;
	FreeMem(embdt);
end;
//------------------------------------------------------------------------------
procedure SaveEmblem(tg:TGuild; size:cardinal);
//ギルドエンブレムを書き込む
var
	i     :integer;
	str   :string;
	embfs :TFileStream;
	embdt :PByte;
	embpt :PByte;
begin
	//ファイル書き込み
	str := AppPath + 'emblem\' + IntToStr(tg.ID) + '_' + IntToStr(tg.Emblem) + '.emb';
	GetMem(embdt, size);
	embpt := embdt;
	for i := 0 to size - 1 do begin
		RFIFOB(i + 4, embpt^);
		Inc(embpt);
	end;
	embfs := TFileStream.Create(str, fmCreate or fmOpenWrite);
        try
          embfs.Write(embdt^, size);
        finally
          embfs.Free;
        end;
	FreeMem(embdt);
end;
{ギルド機能追加ココまで}
{アジト機能追加}
procedure SetFlagValue(tc:TChara; str:string; svalue:string);
// スクリプトフラグを代入する
begin
	if (Copy(str, 1, 1) = '\') then begin
		ServerFlag.Values[str] := svalue;
	end else if (tc.Login = 2) then begin
		tc.Flag.Values[str] := svalue;
	end;
end;
{アジト機能追加ココまで}
//==============================================================================
//==============================================================================






//==============================================================================
(*-----------------------------------------------------------------------------*
ChrstphrR 2004/04/21
I am NOT the original author here ...  just checking to ensure the code is safe.
MapLoad() loads the map object that associated with mapname.

MapLoad helps implement the nifty load-on-first-request design for maps -- Maps
are only loaded into memory as people walk / warp / logon into them.

Input -> MapName
Acts on "Map" StringList

Changes made:
- Japanese -> English comment translation
- Fixed Memory Leaks when Exit; called without freeing created local objects
  (Even fixed the commented out Exits ... just in case.)
  Approx 145 fixed in place here across ~2000 lines of code.
- Added local procs to do the cleanup work, and reduce code bloat.
- Added local Constants for one of the routines.
- Added one or two local vars for naming clarity.
- Lowercase of MapName used internally, to maintain data consistancy.
*-----------------------------------------------------------------------------*)
Procedure MapLoad(
		MapName : string
	);

Var
	i   : Integer; // X direction loop iterator
	j   : Integer; // Y direction loop iterator

	Idx  : Integer; // Loop Iterator - used several times.

	k   : Integer;
	w       :word;
	str        : string;
	Tick    :cardinal;
	dat     :TMemoryStream;
	tm      :TMap;
	tn      :TNPC;
	tn1     :TNPC;
	h       :array[0..3] of single;
	maptype :integer;
{NPCイベント追加}
	ta      :TMapList;
{NPCイベント追加ココまで}

	afm     :textfile;
	letter  :char;

	procedure MapErr(const EMsg : String);
	begin
		debugout.lines.add('[' + TimeToStr(Now) + '] ' + EMsg);
		tm.Free;
	end;

Begin
	MapName := ChangeFileExt(MapName, '');
//	dat := TMemoryStream.Create; //Memory Buffer to read in Map
	{ChrstphrR -- dat is NOT freed up proper in most early Exits, moving so it IS
	in a safe position}

	//Safety check - don't try loading maps that don't exist in the List already
	if MapList.IndexOf(MapName) = -1 then begin
		MapErr('Map Not Found : ' + MapName);
		Exit; //CRW - 2004/04/21 - Safe
	end;

	tm := TMap.Create;
	tm.Name := MapName;
	Map.AddObject(MapName, tm);
	tm.Mode := 1;

	ta := MapList.Objects[MapList.IndexOf(MapName)] as TMapList;

	//AF2 style map file
	if ta.Ext = 'af2' then begin

		AssignFile(afm,AppPath + 'map\tmpFiles\' + MapName + '.out');
		Reset(afm);

		ReadLn(afm,str);
		if (str <> 'ADVANCED FUSION MAP') then begin
			MapErr('Mapfile error 500 : ' + MapName);
			Exit; //CRW - 2004/04/21 - Safe
		end;

		ReadLn(afm,str);
		if (str <> MapName) then begin
			MapErr('The loaded map was not in the memory map : ' + MapName);
			Exit; //CRW - 2004/04/21 - Safe
		end;

		ReadLn(afm,tm.Size.x,tm.Size.y);
		ReadLn(afm,str);

		//Set the size of the interal Map
		SetLength(tm.gat, tm.Size.X, tm.Size.Y);
		//NB, the afm data is flipped in both directions vs how the map is
		//oriented when we see it in the client
		for j := 0 to tm.Size.Y - 1 do begin
			for i := 0 to tm.Size.X - 1 do begin
				Read(afm,letter);
				tm.gat[i][j] := StrToInt(letter);
			end;
			ReadLn(afm,str);
		end;
		CloseFile(afm);
	end
	//AF2 style map file

	//AFM style map file
	else if ta.Ext = 'afm' then begin
		AssignFile(afm,AppPath + 'map/' + MapName + '.afm');
		Reset(afm);

		ReadLn(afm,str);
		if (str <> 'ADVANCED FUSION MAP') then begin
			MapErr('Mapfile error 500 : ' + MapName);
			Exit; //CRW - 2004/04/21 - Safe
		end;

		ReadLn(afm,str);
		if (str <> MapName) then begin
			MapErr('The loaded map was not the memory map : ' + MapName);
			Exit; //CRW - 2004/04/21 - Safe
		end;

		ReadLn(afm,tm.Size.x,tm.Size.y); //Read Map Size
		ReadLn(afm,str);  //Eat Blank line

		//Set the size of the interal Map
		SetLength(tm.gat, tm.Size.X, tm.Size.Y);
		//NB, the afm data is flipped in both directions vs how the map is
		//oriented when we see it in the client
		for j := 0 to tm.Size.Y - 1 do begin
			for i := 0 to tm.Size.X - 1 do begin
				Read(afm,letter);
				tm.gat[i][j] := StrToInt(letter);
			end;
			ReadLn(afm,str);
		end;
		CloseFile(afm);
	end
	//AFM style map file

	//GAT style map file
	else begin
		dat := TMemoryStream.Create; //Memory Buffer to read in Map
		{ChrstphrR -- dat is NOT freed up proper in most early Exits}
		if ta.Ext = 'gat' then begin
			//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Loading mapfile... : ' + MapName + '.gat');
			dat.LoadFromFile(AppPath + 'map\' + MapName + '.gat');
			SetLength(str, 4);
			dat.Read(str[1], 4);
		end;


		if (str <> 'GRAT') then begin
			MapErr('Mapfile error 500 : ' + MapName);
			if Assigned(dat) then dat.Free;
			Exit; //CRW - 2004/04/21 - Safe
		end;

		dat.Read(w, 2);
		dat.Read(tm.Size.X, 4);
		dat.Read(tm.Size.Y, 4);

		SetLength(tm.gat, tm.Size.X, tm.Size.Y);
		for j := 0 to tm.Size.Y - 1 do begin
			for i := 0 to tm.Size.X - 1 do begin

				if ta.Ext = 'gat' then begin
					dat.Read(h[0], 4);
					dat.Read(h[1], 4);
					dat.Read(h[2], 4);
					dat.Read(h[3], 4);
					dat.Read(maptype, 4);

					tm.gat[i][j] := maptype;

				end;
			end;
		end;
		dat.Free;
	end;
	//GAT style map file

	tm.BlockSize.X := (tm.Size.X + 7) div 8;
	tm.BlockSize.Y := (tm.Size.Y + 7) div 8;
	for j := 0 - 3 to tm.BlockSize.Y + 3 do begin
		for i := 0 - 3 to tm.BlockSize.X + 3 do begin
			tm.Block[i][j] := TBlock.Create;
			if (i < 0) or (j < 0) or (i >= tm.BlockSize.X) or (j >= tm.BlockSize.Y) then
				tm.Block[i][j].MobProcTick := $FFFFFFFF
				//The 3 Block "border" on the outside of the map does NOT perform
				// monster processing, thus it's set to the $FFFFFFFF value.
			else
				tm.Block[i][j].MobProcTick := 0;
				//Otherwise you Zero out the value :D
		end;
	end;

	//Script Load
	//debugout.lines.add('[' + TimeToStr(Now) + '] ' + 'Loading script...');
	Tick := timeGetTime;
	for Idx := 0 to ScriptList.Count - 1 do begin
		if NOT ScriptValidated(MapName, ScriptList[Idx], Tick) AND
		   ShowDebugErrors then begin
			debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format(
				'*** Error with script "%s" on map "%s"',
				[ScriptList[Idx], MapName]
			));
		end;

	end;//for Idx

	//Copy of script
	for Idx := 0 to tm.NPC.Count - 1 do begin
		tn := tm.NPC.Objects[Idx] as TNPC;
		if (tn.CType = 2) and (tn.ScriptCnt <> 0) then begin
			// Using script 'scriptlabel'...
			if tn.Script[0].ID = 99 then begin
				j := tm.NPCLabel.IndexOf(tn.Script[0].Data1[0]);
				if j <> -1 then begin
					SetLength(tn.Script[0].Data1, 0);
					tn1 := tm.NPCLabel.Objects[j] as TNPC;
					SetLength(tn.Script, tn1.ScriptCnt);
					for i := 0 to tn1.ScriptCnt - 1 do begin
						tn.Script[i] := tn1.Script[i];
					end;
					tn.ScriptCnt := tn1.ScriptCnt;
					// Colus, 20040130: Copy over script label data when you go to a script
					//tn.ScriptInitS := tn1.ScriptInitS;
					//tn.ScriptInitD := tn1.ScriptInitD;
					//tn.ScriptInitMS := tn1.ScriptInitMS;

				end;
			{NPC Event}
			end else begin
				for i := 0 to tn.ScriptCnt - 1 do begin
					//callmobイベントチェック
					if (tn.Script[i].ID = 33) and (tn.Script[i].Data2[0] <> '') then begin
						k := 0;
						for j := 0 to tm.NPC.Count - 1 do begin
							tn1 := tm.NPC.Objects[j] as TNPC;
							// Colus, 20040503: Uses NPC_INVISIBLE constant now.
							if (tn1.Name = tn.Script[i].Data2[0]) and (tn1.JID = NPC_INVISIBLE) then begin
								tn.Script[i].Data2[0] := IntToStr(tn1.ID);
								k := 1;
								break;
							end;
						end;
						if (k = 0) then begin
							//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('%s: [callmob] event not found', [tn.Script[i].Data2[0]]));
							tn.Script[i].Data2[0] := '';
						end;
					end;
				end;
			end;
			{NPC Event}
		end;
	end;//for Idx

	tm.Mode := 2;
End;(* Proc MapLoad()
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*
ScriptValidated()

Contains the validation step performed in MapLoad, and exits gracefully, if
validation errors are found.  Informs in the console window, of the
Script error, and if possible the line and command that caused the error.

The current script definition where the error is found, is dropped (not
processed), as well as any definitions after the errored entry.


Pre:
	FileName is a valid file in the Scripts directory.
Post:
	True returned if file validates (safe to load)
	False if an error resulted.

2004/05/05 - ChrstphrR - Broken out from MapLoad
2004/05/06 - ChrstphrR - fix for 'monster' segment, based on Colus' sleuthing.
*-----------------------------------------------------------------------------*)
Function  ScriptValidated(
		MapName  : string;
		FileName : string;
		Tick     : Cardinal
	) : Boolean;
Const
	SCRIPT_SYNTAX_ERR = 0;
	SCRIPT_SYNT_2_ERR = 1;
	SCRIPT_FUNCTN_ERR = 2;
	SCRIPT_SELECT_ERR = 3;
	SCRIPT_RANGE1_ERR = 4;
	SCRIPT_RANGE2_ERR = 5;
	SCRIPT_RANGE3_ERR = 6;
	SCRIPT_RANGE4_ERR = 7;
	SCRIPT_DIV_Z3_ERR = 8;
	SCRIPT_LBLNOT_ERR	= 9;
	SCRIPT_NONCMD_ERR	= 10;

Var
	Txt   : TextFile;
	Lines : Integer; //Line Counter holder - in case of errors, this is the line#
	SL    : TStringList;
	SL1   : TStringList;
	SL2   : TStringList;
	Str   : string;
	Idx   : Integer;
	Idx2  : Integer;
	ScriptPath : string;
	mathop     : string; //holds string representing a binary compare op like '<>'
	TempInt    : Integer;
	k          : Integer;
	m          : Integer;
	mcnt       : Integer;
	i          : Integer;
	J          : Integer;

	X : Integer;
	Y : Integer;
	{Used in callmob code...}

	tgc   : TCastle;

	tn    : TNPC;
	tm    : TMap; //ref only
	tr    : NTimer;
	ts    : TMob;
	ts0   : TMob;
	te    : TEmp;

	procedure ScriptErr(
						const
							ScriptErrType : Integer;
							Args: array of const
						);
	var
		EMsg : String;
	begin
		if ShowDebugErrors then begin
			case ScriptErrType of
			SCRIPT_SYNTAX_ERR : //Syntax Error (2 params in Args)
				EMsg := Format('%s %.4d: syntax error', Args);
			SCRIPT_SYNT_2_ERR : //Syntax Error (3 params in Args)
				EMsg := Format('%s %.4d: [%s] syntax error (2)', Args);
			SCRIPT_FUNCTN_ERR : //Function Error (3 params in Args)
				EMsg := Format('%s %.4d: [%s] function error', Args);
			SCRIPT_SELECT_ERR : //Too Many Selections (3 params in ARgs)
				EMsg := Format('%s %.4d: [%s] too many selections', Args);
			SCRIPT_RANGE1_ERR : //Range Error (3 params in Args)
				EMsg := Format('%s %.4d: [%s] range error (1)', Args);
			SCRIPT_RANGE2_ERR : //Range Error (3 params in Args)
				EMsg := Format('%s %.4d: [%s] range error (2)', Args);
			SCRIPT_RANGE3_ERR : //Range Error (3 params in Args)
				EMsg := Format('%s %.4d: [%s] range error (3)', Args);
			SCRIPT_RANGE4_ERR : //Range Error (3 params in Args)
				EMsg := Format('%s %.4d: [%s] range error (4)', Args);
			SCRIPT_DIV_Z3_ERR : //Div by Zero Error (3 params in Args)
				EMsg := Format('%s %.4d: [%s] div 0 error (3)', Args);
			SCRIPT_LBLNOT_ERR : //Label not found (2 params in Args)
				EMsg := Format('%s : label "%s" not found', Args);
			SCRIPT_NONCMD_ERR : //Invalid command (3 params in Args)
				EMsg := Format('%s %.4d: Invalid Command "%s"', Args);

			else
				begin
				end;//else-case
			end;//case

			debugout.lines.add('[' + TimeToStr(Now) + '] ' + EMsg);
		end;//if ShowDebugErrors
		SL.Free;
		SL1.Free;
		SL2.Free;
		if Assigned(tn) then tn.Free;
		Result := False;
	end;

Begin
	Result := True; //Assume True until early exit...

	//Set up references

	Idx := Map.IndexOf(MapName);
	if Idx > -1 then
		tm := Map.Objects[Idx] AS TMap
	else
		tm := NIL;

	if tm = NIL then Exit;

	SL  := TStringList.Create;
	SL1 := TStringList.Create;
	SL2 := TStringList.Create;

	AssignFile(Txt, FileName);
	Reset(Txt);

	{ChrstphrR - 2004/04/22 - reset Lines for each script, when parsing.}
	Lines := 0;
	while not eof(txt) do begin
		Readln(txt, str);
		Inc(lines);
		SL.Delimiter := #9;
		SL.QuoteChar := '"';
		SL.DelimitedText := str;
		if SL.Count = 4 then begin
			SL1.DelimitedText := SL[0];
			if ChangeFileExt(SL1[0], '') = MapName then begin
	// ワープポイント Lit. "Loom Point" in Katakana ------------------------------
				// Colus, 20040122: Added parsing for hidden warps.
				if (SL[1] = 'warp') OR (SL[1] = 'hiddenwarp') then begin
					tn := TNPC.Create;
					tn.ID := NowNPCID;
					Inc(NowNPCID);
					tn.Name := SL[2];
					//debugout.lines.add('[' + TimeToStr(Now) + '] ' + '-> adding warp point ' + tn.Name);
					if WarpDebugFlag then begin
						tn.JID := 1002;
					end else begin
						case SL[1][1] of //First letter of 'warp'/'hiddenwarp'
						'h' : tn.JID := 139;
						'w' : tn.JID := 45;
						end;
					end;
					tn.Map     := MapName;
					tn.Point.X := StrToInt(SL1[1]);
					tn.Point.Y := StrToInt(SL1[2]);
					tn.Dir     := StrToInt(SL1[3]);

					SL1.DelimitedText := SL[3];
					tn.CType       := NPC_TYPE_WARP;
					tn.WarpSize.X  := StrToInt(SL1[0]);
					tn.WarpSize.Y  := StrToInt(SL1[1]);
					tn.WarpMap     := ChangeFileExt(SL1[2], '');
					tn.WarpPoint.X := StrToInt(SL1[3]);
					tn.WarpPoint.Y := StrToInt(SL1[4]);

					{NPC Event}
					tn.Enable      := true;
					tn.ScriptInitS := -1;
					{NPC Event}

					tm.NPC.AddObject(tn.ID, tn);
					tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.AddObject(tn.ID, tn);
					for j := tn.Point.Y - tn.WarpSize.Y to tn.Point.Y + tn.WarpSize.Y do begin
						for i := tn.Point.X - tn.WarpSize.X to tn.Point.X + tn.WarpSize.X do begin
							tm.gat[i][j] := (tm.gat[i][j] or $4);
						end;
					end;
	// NPC Shop ------------------------------------------------------------------
				end else if SL[1] = 'shop' then begin
					tn := TNPC.Create;
					tn.ID      := NowNPCID;
					Inc(NowNPCID);
					tn.Name    := SL[2];
					//debugout.lines.add('[' + TimeToStr(Now) + '] ' + '-> adding shop ' + tn.Name);
					tn.Map     := MapName;
					tn.Point.X := StrToInt(SL1[1]);
					tn.Point.Y := StrToInt(SL1[2]);
					tn.Dir     := StrToInt(SL1[3]);

					SL1.DelimitedText := SL[3];
					tn.CType := NPC_TYPE_SHOP;
					tn.JID := StrToInt(SL1[0]);
					SetLength(tn.ShopItem, SL1.Count - 1);
					for Idx2 := 0 to sl1.Count - 2 do begin
						tn.ShopItem[Idx2] := TShopItem.Create;
						j := Pos(':', SL1[Idx2+1]);
						tn.ShopItem[Idx2].ID    := StrToInt(Copy(SL1[Idx2+1], 1, j - 1));
						tn.ShopItem[Idx2].Price := StrToInt(Copy(SL1[Idx2+1], j + 1, 8));
						tn.ShopItem[Idx2].Data  := ItemDB.IndexOfObject(tn.ShopItem[Idx2].ID) as TItemDB;
					end;

					{NPC Event}
					tn.Enable := true;
					tn.ScriptInitS := -1;
					{NPC Event}
					tm.NPC.AddObject(tn.ID, tn);
					tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.AddObject(tn.ID, tn);

					//Mark squares covered by Warp as Warpable..
					for j := tn.Point.Y - tn.WarpSize.Y to tn.Point.Y + tn.WarpSize.Y do begin
						for i := tn.Point.X - tn.WarpSize.X to tn.Point.X + tn.WarpSize.X do begin
							tm.gat[i][j] := (tm.gat[i][j] and $fe);
						end;
					end;
{d$0100fix5}
	// Script --------------------------------------------------------------------
				end else if SL[1] = 'script' then begin
					(* ChrstphrR 2004/05/11
					Script Line:
					<MapToken> 'script' <NPCName> <IDToken>

					<MapToken> ::= <MapName>,<X>,<Y>,<Direction>
						<Direction> ::= {0|1|2|3|4|5|6|7}
						107  Direction ranges from 0 to 7, Zero being North,
						2 6  the other compass points continuing counter-clockwise.
						345

					<NPCName>  ::= <OneWordName> | "<OneOrMoreWordName>"
					<IDToken>  ::= <SpriteID>,'{'

					Valid SpriteIDs can be found in the tables on
					http://www.geocities.co.jp/SiliconValley-Bay/1174/npce.html
					*)
					tn := TNPC.Create;
					tn.ID := NowNPCID;
					Inc(NowNPCID);
					tn.Name := SL[2];
					//debugout.lines.add('[' + TimeToStr(Now) + '] ' + '-> adding script ' + tn.Name);
					tn.Map := MapName;
					tn.Point.X := StrToIntDef(SL1[1],0);
					if (tn.Point.X < 0) or (tn.Point.X >= tm.Size.X) then tn.Point.X := 0;
					tn.Point.Y := StrToIntDef(SL1[2],0);
					if (tn.Point.Y < 0) or (tn.Point.Y >= tm.Size.Y) then tn.Point.Y := 0;
					tn.Dir := StrToInt(SL1[3]);
					tn.CType := NPC_TYPE_SCRIPT;

					//ChrstphrR - 2004/05/15 corrected ScriptPath so it is valid
					ScriptPath := ExtractRelativePath(AppPath, FileName);

					SL1.DelimitedText := SL[3];
					//SL1 is now the IDToken - 2 comma separated params - check count
					if (SL1.Count <> 2) AND (SL1[2] <> '{') then begin
						ScriptErr(SCRIPT_SYNTAX_ERR, [ScriptPath, Lines]);
						Exit; // Safe - 2004/04/21
					end;

					// Colus, 20040503: Making it work in a 'proper' fashion.  We DO need it,
					// but we'll handle negative values in a better manner.
					// All negative JIDs are set to the NPC_INVISIBLE value.
					TempInt := StrToIntDef(SL1[0],0);
					if TempInt < 0 then begin
						TempInt := NPC_INVISIBLE;
					end;

					tn.JID := TempInt;
					{NPC Event}
					tn.ScriptInitS := -1;
					tn.ScriptInitD := False;
					tn.Enable      := True;
					{NPC Event}
					k := 0;
					SL2.Clear;
					while not eof(txt) do begin
						//Reading Script.
						Readln(txt, str);
						Inc(lines);
						if str = '}' then break;
						//Closing curly brace means the script definition is done.

						//Convert Multiple tabs to one tab, then convert remaining tabs to spaces
						while Pos(#9#9, str) <> 0 do str := StringReplace(str, #9#9, #9, [rfReplaceAll]);
						str := StringReplace(str, #9, ' ', [rfReplaceAll]);
						str := Trim(str);
						if Copy(str, Length(str), 1) = ';' then str := Copy(str, 1, Length(str) - 1);
						str := Trim(str);
						SL.Delimiter := ' ';
						SL.QuoteChar := #1;
						SL.DelimitedText := str;
						if SL.Count > 2 then begin
							for i := 2 to SL.Count - 1 do begin
								SL[1] := SL[1] + ' ' + SL[2];
								SL.Delete(2);
							end;
						end;

						case SL.Count of
						0: //Blank Line.
							begin
								str := '//';
								SL.Add('//');
							end;
						1:	SL1.Clear;
						2:	SL1.DelimitedText := SL[1];
						else
							begin
								ScriptErr(SCRIPT_SYNTAX_ERR, [ScriptPath, lines]);
								Exit; // Safe - 2004/04/21
							end;
						end;
						str := LowerCase(SL[0]);
						SL.Delete(0);
						if str = 'mes' then begin //------- 1 mes
							if SL1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 1;
							SetLength(tn.Script[k].Data1, 1);
							SL1[0] := StringReplace(SL1[0], '&sp;', ' ', [rfReplaceAll]);
							SL1[0] := StringReplace(SL1[0], '&amp;', '&', [rfReplaceAll]);
							tn.Script[k].Data1[0] := SL1[0];
							Inc(k);
						end else if str = 'next' then begin //------- 2 next
							if sl1.Count <> 0 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 2;
							Inc(k);
						end else if str = 'close' then begin //------- 3 close
							if sl1.Count <> 0 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 3;
							Inc(k);
						end else if str = 'menu' then begin //------- 4 menu
							if sl1.Count <> sl1.Count div 2 * 2 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							if sl1.Count > 40 then begin
								ScriptErr(SCRIPT_SELECT_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 4;
							SetLength(tn.Script[k].Data1, SL1.Count div 2);
							SetLength(tn.Script[k].Data2, SL1.Count div 2);
							SetLength(tn.Script[k].Data3, SL1.Count div 2);
							tn.Script[k].DataCnt := sl1.Count div 2;
							for i := 0 to SL1.Count div 2 - 1 do begin
								SL1[i*2] := StringReplace(SL1[i*2], '&sp;', ' ', [rfReplaceAll]);
								SL1[i*2] := StringReplace(SL1[i*2], '&amp;', '&', [rfReplaceAll]);
								tn.Script[k].Data1[i] := SL1[i*2];
								tn.Script[k].Data2[i] := LowerCase(SL1[i*2+1]);
							end;
							Inc(k);
						end else if str = 'goto' then begin //------- 5 goto
							if sl1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 5;
							SetLength(tn.Script[k].Data1, 1);
							SetLength(tn.Script[k].Data3, 1);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							Inc(k);
						end else if str = 'cutin' then begin //------- 6 cutin
							if SL1.Count <> 2 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							Val(SL1[1], i, j);
							if (j <> 0) or (i < 0) or (i > 255) then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 6;
							SetLength(tn.Script[k].Data1, 1);
							SetLength(tn.Script[k].Data3, 1);
							tn.Script[k].Data1[0] := SL1[0];
							if ExtractFileExt(tn.Script[k].Data1[0]) = '' then ChangeFileExt(tn.Script[k].Data1[0], '.bmp');
							tn.Script[k].Data3[0] := StrToInt(SL1[1]);
							Inc(k);
						end else if str = 'store' then begin //------- 7 store
							if SL1.Count <> 0 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 7;
							Inc(k);
						end else if str = 'warp' then begin //------- 8 warp
							if SL1.Count <> 3 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							Val(SL1[1], i, j);
							if (j <> 0) or (i < 0) or (i > 511) then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[2], i, j);
							if (j <> 0) or (i < 0) or (i > 511) then begin
								ScriptErr(SCRIPT_RANGE3_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 8;
							SetLength(tn.Script[k].Data1, 1);
							SetLength(tn.Script[k].Data3, 2);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data3[0] := StrToInt(SL1[1]);
							tn.Script[k].Data3[1] := StrToInt(SL1[2]);
							Inc(k);
						end else if str = 'save' then begin //------- 9 save
							if sl1.Count <> 3 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[1], i, j);
							if (j <> 0) or (i < 0) or (i > 511) then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[2], i, j);
							if (j <> 0) or (i < 0) or (i > 511) then begin
								ScriptErr(SCRIPT_RANGE3_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 9;
							SetLength(tn.Script[k].Data1, 1);
							SetLength(tn.Script[k].Data3, 2);
							tn.Script[k].Data1[0] := SL1[0];
							tn.Script[k].Data3[0] := StrToInt(SL1[1]);
							tn.Script[k].Data3[1] := StrToInt(SL1[2]);
							Inc(k);
						end else if str = 'heal' then begin //------- 10 heal
							if sl1.Count <> 2 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[0], i, j);
							if (j <> 0) or (i < 0) or (i > 30000) then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[1], i, j);
							if (j <> 0) or (i < 0) or (i > 30000) then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 10;
							SetLength(tn.Script[k].Data3, 2);
							tn.Script[k].Data3[0] := StrToInt(SL1[0]);
							tn.Script[k].Data3[1] := StrToInt(SL1[1]);
							Inc(k);
						end else if str = 'set' then begin //------- 11 set
							SL[0] := StringReplace(SL[0], '+=', '+', []);
							SL[0] := StringReplace(SL[0], '-=', '-', []);
							SL[0] := StringReplace(SL[0], '*=', '*', []);
							SL[0] := StringReplace(SL[0], '/=', '/', []);
							SL[0] := StringReplace(SL[0], '+', ',1,', []);
							SL[0] := StringReplace(SL[0], '-', ',2,',	[]);
							SL[0] := StringReplace(SL[0], '=', ',0,', []);
							SL[0] := StringReplace(SL[0], '*', ',3,', []);
							SL[0] := StringReplace(SL[0], '/', ',4,', []);
							while Pos('- ', SL[0]) <> 0 do
								SL[0] := StringReplace(SL[0], '- ', '-',	[]);
							sl1.DelimitedText := SL[0];
							if sl1.Count = 3 then sl1.Add('0');
							if sl1.Count <> 4 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[1], i, j);
							if (j <> 0) or (i < 0) or (i > 4) then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[2], i, j);
							if j = 0 then begin
								if (i < -999999999) or (i > 999999999) then begin
									ScriptErr(SCRIPT_RANGE3_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end else if (StrToInt(SL1[1]) = 3) and (i = 0) then begin
									ScriptErr(SCRIPT_DIV_Z3_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							val(SL1[3], i, j);
							if (j <> 0) or (i < -999999999) or (i > 999999999) then begin
								ScriptErr(SCRIPT_RANGE4_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 11;
							SetLength(tn.Script[k].Data1, 2);
							SetLength(tn.Script[k].Data3, 2);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[2]);
							tn.Script[k].Data3[0] := StrToInt(SL1[1]);
							tn.Script[k].Data3[1] := StrToInt(SL1[3]);
							Inc(k);
						end else if str = 'additem' then begin //------- 12 additem
							if sl1.Count <> 2 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[0], i, j);
							if j = 0 then begin
								if (i < 0) or (i > 19999) then begin
									ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							val(SL1[1], i, j);
							if j = 0 then begin
								if (i < 0) or (i > 30000) then begin
									ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 12;
							SetLength(tn.Script[k].Data1, 2);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[1]);
							Inc(k);
						end else if str = 'delitem' then begin //------- 13 delitem
							if sl1.Count <> 2 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[0], i, j);
							if j = 0 then begin
								if (i < 0) or (i > 19999) then begin
									ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							val(SL1[1], i, j);
							if j = 0 then begin
								if (i < 0) or (i > 30000) then begin
									ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 13;
							SetLength(tn.Script[k].Data1, 2);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[1]);
							Inc(k);
						end else if str = 'checkitem' then begin //------- 14 checkitem
							if SL1.Count <> 4 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[0], i, j);
							if j = 0 then begin
								if (i < 0) or (i > 19999) then begin
									ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							val(SL1[1], i, j);
							if j = 0 then begin
								if (i < 0) or (i > 30000) then begin
									ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 14;
							SetLength(tn.Script[k].Data1, 2);
							SetLength(tn.Script[k].Data2, 2);
							SetLength(tn.Script[k].Data3, 2);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[1]);
							tn.Script[k].Data2[0] := LowerCase(SL1[2]);
							tn.Script[k].Data2[1] := LowerCase(SL1[3]);
							tn.Script[k].DataCnt := 2;
							Inc(k);
						end else if str = 'check' then begin //------- 15 check
							SL[0] := StringReplace(SL[0], '=>', '>=', []);
							SL[0] := StringReplace(SL[0], '=<', '<=', []);
							SL[0] := StringReplace(SL[0], '==', '=',	[]);
							SL[0] := StringReplace(SL[0], '><', '<>', []);
							SL[0] := StringReplace(SL[0], '!=', '<>', []);
							SL[0] := StringReplace(SL[0], '>',	',>,',	[]);
							SL[0] := StringReplace(SL[0], '<',	',<,',	[]);
							SL[0] := StringReplace(SL[0], '=',	',=,',	[]);
							SL[0] := StringReplace(SL[0], ',>,,=,', ',>=,', []);
							SL[0] := StringReplace(SL[0], ',<,,=,', ',<=,', []);
							SL[0] := StringReplace(SL[0], ',<,,>,', ',<>,', []);
							SL1.DelimitedText := SL[0];
							if SL1.Count <> 5 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[2], i, j);
							if j = 0 then begin
								if (i < 0) or (i > 999999999) then begin
									ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 15;
							SetLength(tn.Script[k].Data1, 3);
							SetLength(tn.Script[k].Data2, 2);
							SetLength(tn.Script[k].Data3, 3);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[2]);
							tn.Script[k].Data1[2] := SL1[1];
							mathop := SL1.Strings[1];
							j := -1;
									 if mathop = '>=' then j := 0
							else if mathop = '<=' then j := 1
							else if mathop = '='	then j := 2
							else if mathop = '<>' then j := 3
							else if mathop = '>'	then j := 4
							else if mathop = '<'	then j := 5;
							if j = -1 then begin
								ScriptErr(SCRIPT_SYNT_2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							tn.Script[k].Data3[2] := j;
							tn.Script[k].Data2[0] := LowerCase(SL1[3]);
							tn.Script[k].Data2[1] := LowerCase(SL1[4]);
							tn.Script[k].DataCnt := 2;
							Inc(k);
						end else if str = 'checkadditem' then begin //------- 16 checkadditem
							if sl1.Count <> 4 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[0], i, j);
							if j = 0 then begin
								if (i < 0) or (i > 19999) then begin
									ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							val(SL1[1], i, j);
							if j = 0 then begin
								if (i < 0) or (i > 30000) then begin
									ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 16;
							SetLength(tn.Script[k].Data1, 2);
							SetLength(tn.Script[k].Data2, 2);
							SetLength(tn.Script[k].Data3, 2);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[1]);
							tn.Script[k].Data2[0] := LowerCase(SL1[2]);
							tn.Script[k].Data2[1] := LowerCase(SL1[3]);
							tn.Script[k].DataCnt := 2;
							Inc(k);
						end else if str = 'jobchange' then begin //------- 17 jobchange
							if sl1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[0], i, j);
							if (j <> 0) or (i < 0) or (i > MAX_JOB_NUMBER) then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 17;
							SetLength(tn.Script[k].Data3, 1);
							tn.Script[k].Data3[0] := StrToInt(SL1[0]);
							Inc(k);

						end else if str = 'viewpoint' then begin //------- 18 viewpoint
							if SL1.Count <> 5 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							Val(SL1[0], i, j);
							if (j <> 0) or (i < 1) or (i > 2) then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							Val(SL1[1], i, j);
							if (j <> 0) or (i < 0) or (i > 511) then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							Val(SL1[2], i, j);
							if (j <> 0) or (i < 0) or (i > 511) then begin
								ScriptErr(SCRIPT_RANGE3_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							Val(SL1[3], i, j);
							if (j <> 0) or (i < 0) or (i > 255) then begin
								ScriptErr(SCRIPT_RANGE4_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SL1[4] := StringReplace(SL1[4], '0x', '', []);
							if Copy(SL1[4], 1, 1) <> '$' then SL1[4] := '$' + SL1[4];
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 18;
							SetLength(tn.Script[k].Data3, 5);
							tn.Script[k].Data3[0] := StrToInt(SL1[0]);
							tn.Script[k].Data3[1] := StrToInt(SL1[1]);
							tn.Script[k].Data3[2] := StrToInt(SL1[2]);
							tn.Script[k].Data3[3] := StrToInt(SL1[3]);
							tn.Script[k].Data3[4] := StrToInt(SL1[4]);
							Inc(k);
						end else if str = 'input' then begin //------- 19 input
							if sl1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 19;
							SetLength(tn.Script[k].Data1, 1);
							tn.Script[k].Data1[0] := SL1[0];
							Inc(k);
						end else if str = 'random' then begin //------- 20 random
							if sl1.Count <> 2 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[0], i, j);
							if (j = 0) AND ((i < 0) OR (i > 999999999)) then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[1], i, j);
							if (j <> 0) or (i < 0) or (i > 999999999) then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 20;
							SetLength(tn.Script[k].Data1, 1);
							SetLength(tn.Script[k].Data3, 1);
							tn.Script[k].Data1[0] := SL1[0];
							tn.Script[k].Data3[0] := StrToInt(SL1[1]);
							Inc(k);
						end else if str = 'option' then begin //------- 21 option
							if sl1.Count <> 2 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[0], i, j);
							if (j <> 0) or (i < 0) or (i > 2) then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[1], i, j);
							if (j <> 0) or (i < 0) or (i > 1) then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 21;
							SetLength(tn.Script[k].Data3, 2);
							tn.Script[k].Data3[0] := StrToInt(SL1[0]);
							tn.Script[k].Data3[1] := StrToInt(SL1[1]);
							Inc(k);
						end else if str = 'speed' then begin //------- 22 speed
							if sl1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							Val(SL1[0], i, j);
							if j = 0 then begin
								if (i < 25) or (i > 1000) then begin
									ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 22;
							SetLength(tn.Script[k].Data1, 1);
							tn.Script[k].Data1[0] := SL1[0];
							Inc(k);
						end else if str = 'die' then begin //------- 23 die
							if sl1.Count <> 0 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 23;
							Inc(k);
						end else if str = 'ccolor' then begin //------- 24 ccolor
							if sl1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							{val(SL1[0], i, j);
							if (j <> 0) or (i > 5) then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21 - commented out but replacing.
							end;}
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 24;
							SetLength(tn.Script[k].Data1, 1);
							tn.Script[k].Data1[0] := SL1[0];
							Inc(k);
						end else if str = 'refine' then begin //------- 25 refine	 refine[itemID][fail][+val]
							if sl1.Count <> 3 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							//val(SL1[0], i, j);
							//val(SL1[1], i, j);
							val(SL1[2], i, j);
							if (j <> 0) or (i > 10) then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 25;
							SetLength(tn.Script[k].Data1, 3);
							tn.Script[k].Data1[0] := SL1[0];
							tn.Script[k].Data1[1] := SL1[1];
							tn.Script[k].Data1[2] := SL1[2];
							Inc(k);
						end else if str = 'getitemamount' then begin //------- 26 getitemamount
							if sl1.Count <> 2 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[0], i, j);
							if j = 0 then begin
								if (i < 0) or (i > 19999) then begin
									ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 26;
							SetLength(tn.Script[k].Data1, 2);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[1]);
							Inc(k);
{追加:スクリプト144}
						end else if str = 'getskilllevel' then begin //--------27 getskilllevel // S144 addstart
							if sl1.Count <> 2 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;

							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 27;
							SetLength(tn.Script[k].Data1, 2);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[1]);
							Inc(k);
						end else if str = 'setskilllevel' then begin //--------28 setskilllevel
							if SL1.Count <> 2 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							Val(SL1[1], i, j);
							if j = 0 then begin
								if (i < 0) or (i > 10) then begin
									ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 28;
							SetLength(tn.Script[k].Data1, 2);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[1]);
							Inc(k);                                    // S144 addend
{追加:スクリプト144ここまで}
{精錬NPC機能追加}
						end else if str = 'refinery' then begin //--------29 refinery
							if SL1.Count <> 3 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							Val(SL1[0], i, j);
							if (j = 0) AND ((i < 0) OR (i > 10)) then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							Val(SL1[1], i, j);
							if (j = 0) AND ((i < 0) OR (i > 2)) then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							Val(SL1[2], i, j);
							if (j = 0) AND ((i < 0) OR (i > 10)) then begin
								ScriptErr(SCRIPT_RANGE3_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 29;
							SetLength(tn.Script[k].Data1, 3);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[1]);
							tn.Script[k].Data1[2] := LowerCase(SL1[2]);
							Inc(k);
						end else if str = 'equipmenu' then begin //--------30 equipmenu
							if SL1.Count <> 3 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 30;
							SetLength(tn.Script[k].Data1, 3);
							SetLength(tn.Script[k].Data2, 10);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[1]);
							tn.Script[k].Data1[2] := LowerCase(SL1[2]);
							Inc(k);
						end else if str = 'lockitem' then begin //--------31 lockitem
							if sl1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[0], i, j);
							if (j = 0) AND ((i < 0) OR (i > 1)) then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 31;
							SetLength(tn.Script[k].Data1, 1);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							Inc(k);
{精錬NPC機能追加ココまで}
{髪色変更追加}
						end else if str = 'hcolor' then begin //------- 32 hcolor
							if sl1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							Val(SL1[0], i, j);
							if (j = 0) AND ((i < 0) OR (i > 8)) then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 32;
							SetLength(tn.Script[k].Data1, 1);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							Inc(k);
{髪色変更追加ココまで}
{NPCイベント追加}
						end else if str = 'callmob' then begin //------- 33 callmob
						// callmob "force_map1",25,25,"AREA1",1002,0,"area1";
						// Experimental Mod:  x,y as 0,0 (technically if one of is 0),
						// will make a random point selected.
							if (sl1.Count = 6) then sl1.Add('');
							if (sl1.Count <> 7) then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							i := 0;
							if (tn.Map <> ChangeFileExt(SL1[0], '')) then i := 1;
							if (MobDB.IndexOf(StrToInt(SL1[4])) = -1) then i := 1;
							if i <> 0 then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 33;
							SetLength(tn.Script[k].Data1, 2);
							SetLength(tn.Script[k].Data2, 1);
							SetLength(tn.Script[k].Data3, 4);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							{Coords X,Y -- special values - if X or Y are Zero, use random
							points w/in the map}
							X := StrToInt(SL1[1]);
							Y := StrToInt(SL1[2]);
							if (X = 0) OR (Y = 0) then begin
								//ChrstphrR 2004/05/22
								//Tied to map extents - map X/Y range is 0..Mapsize-1
								//We known accessing Map here is safe -- the map was JUST
								//added in the MapLoad routine before this one was called.
								repeat
									X := Random( tm.Size.X );
									Y := Random( tm.Size.Y );
								until NOT (tm.gat[X,Y] IN [1,5]);

								//N.B - this random point selection MAY spawn a point
								// that is stuck where it shouldn't -- ideally, a
								// function to set the X/Y coords randomly on a VALID point
								// should be made, and then used here...
							end;
							tn.Script[k].Data3[0] := X; //X Coord
							tn.Script[k].Data3[1] := Y; //Y Coord
							tn.Script[k].Data1[1] := SL1[3];
							tn.Script[k].Data3[2] := StrToInt(SL1[4]);
							tn.Script[k].Data3[3] := StrToInt(SL1[5]);
							tn.Script[k].Data2[0] := LowerCase(SL1[6]);
							Inc(k);
						end else if str = 'broadcast' then begin //------- 34 broadcast
							if (sl1.Count = 1) then sl1.Add('0');
							if (sl1.Count <> 2) then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 34;
							SetLength(tn.Script[k].Data1, 1);
							SetLength(tn.Script[k].Data3, 1);
							SL1[0] := StringReplace(SL1[0], '&sp;', ' ', [rfReplaceAll]);
							SL1[0] := StringReplace(SL1[0], '&amp;', '&', [rfReplaceAll]);
							tn.Script[k].Data1[0] := SL1[0];
							tn.Script[k].Data3[0] := StrToInt(SL1[1]);
							Inc(k);
						end else if str = 'npctimer' then begin //------- 35 npctimer
							if (sl1.Count <> 1) then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[0], i, j);
							if (j = 0) AND ((i < 0) OR (i > 8)) then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 35;
							SetLength(tn.Script[k].Data3, 1);
							tn.Script[k].Data3[0] := StrToInt(SL1[0]);
							Inc(k);
						end else if str = 'addnpctimer' then begin //------- 36 addnpctimer
							if sl1.Count <> 2 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[1], i, j);
							if (j <> 0) or (i < -999999999) or (i > 999999999) then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 36;
							SetLength(tn.Script[k].Data1, 1);
							SetLength(tn.Script[k].Data3, 1);
							tn.Script[k].Data1[0] := SL1[0];
							tn.Script[k].Data3[0] := StrToInt(SL1[1]);
							Inc(k);
						end else if str = 'return' then begin //------- 37 return
							if sl1.Count <> 0 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 37;
							Inc(k);
						end else if str = 'warpallpc' then begin //------- 38 warpallpc
							if (sl1.Count = 3) then sl1.Add('0');
							if (sl1.Count <> 4) then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[1], i, j);
							if (j <> 0) or (i < 0) or (i > 511) then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[2], i, j);
							if (j <> 0) or (i < 0) or (i > 511) then begin
								ScriptErr(SCRIPT_RANGE3_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[3], i, j);
							if (j <> 0) or (i < 0) or (i > 2) then begin
								ScriptErr(SCRIPT_RANGE4_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 38;
							SetLength(tn.Script[k].Data1, 1);
							SetLength(tn.Script[k].Data3, 3);
							tn.Script[k].Data1[0] := SL1[0];
							tn.Script[k].Data3[0] := StrToInt(SL1[1]);
							tn.Script[k].Data3[1] := StrToInt(SL1[2]);
							tn.Script[k].Data3[2] := StrToInt(SL1[3]);
							Inc(k);
						end else if str = 'waitingroom' then begin //------- 39 waitingroom
							if (sl1.Count <> 2) then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[1], i, j);
							if (j <> 0) or (i < 1) or (i > 20) then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 39;
							SetLength(tn.Script[k].Data1, 1);
							SetLength(tn.Script[k].Data3, 2);
							tn.Script[k].Data1[0] := SL1[0];
							tn.Script[k].Data3[0] := StrToInt(SL1[1]);
							tn.Script[k].Data3[1] := k + 1;
							Inc(k);
						end else if str = 'enablenpc' then begin //------- 40 enablenpc
							if (sl1.Count <> 3) then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[2], i, j);
							if (j <> 0) or (i < 0) or (i > 1) then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 40;
							SetLength(tn.Script[k].Data1, 2);
							SetLength(tn.Script[k].Data3, 1);
							tn.Script[k].Data1[0] := SL1[0];
							tn.Script[k].Data1[1] := SL1[1];
							tn.Script[k].Data3[0] := StrToInt(SL1[2]);
							Inc(k);
						end else if str = 'resetmymob' then begin //------- 41 resetmymob
							if (sl1.Count <> 1) then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 41;
							SetLength(tn.Script[k].Data1, 1);
							tn.Script[k].Data1[0] := SL1[0];
							Inc(k);
						end else if str = 'getmapusers' then begin //------- 42 getmapusers
							if (sl1.Count <> 2) then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 42;
							SetLength(tn.Script[k].Data1, 2);
							tn.Script[k].Data1[0] := SL1[0];
							tn.Script[k].Data1[1] := LowerCase(SL1[1]);
							Inc(k);
						end else if str = 'setstr' then begin //------- 43 setstr
							SL[0] := StringReplace(SL[0], '+=', '+', []);
							SL[0] := StringReplace(SL[0], '+', ',1,', []);
							SL[0] := StringReplace(SL[0], '=', ',0,', []);
							sl1.DelimitedText := SL[0];
							if (sl1.Count <> 3) then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							if (Copy(SL1[0], 1, 1) <> '$') and (Copy(SL1[0], 1, 2) <> '\$') then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[1], i, j);
							if (j <> 0) or (i < 0) or (i > 1) then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 43;
							SetLength(tn.Script[k].Data1, 2);
							SetLength(tn.Script[k].Data3, 1);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := SL1[2];
							tn.Script[k].Data3[0] := StrToInt(SL1[1]);
							Inc(k);
						end else if str = 'checkstr' then begin //------- 44 checkstr
							SL[0] := StringReplace(SL[0], '==', '=',	[]);
							SL[0] := StringReplace(SL[0], '><', '<>', []);
							SL[0] := StringReplace(SL[0], '!=', '<>', []);
							SL[0] := StringReplace(SL[0], '=',	',=,',	[]);
							SL[0] := StringReplace(SL[0], '<>', ',<>,', []);
							sl1.DelimitedText := SL[0];
							if sl1.Count <> 5 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							if (Copy(SL1[0], 1, 1) <> '$') and (Copy(SL1[0], 1, 2) <> '\$') then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 44;
							SetLength(tn.Script[k].Data1, 3);
							SetLength(tn.Script[k].Data2, 2);
							SetLength(tn.Script[k].Data3, 3);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[2]);
							tn.Script[k].Data1[2] := SL1[1];
							mathop := SL1[1];
							j := -1;
							if mathop = '='	then j := 0
							else if mathop = '<>' then j := 1;
							if j = -1 then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							tn.Script[k].Data3[2] := j;
							tn.Script[k].Data2[0] := LowerCase(SL1[3]);
							tn.Script[k].Data2[1] := LowerCase(SL1[4]);
							tn.Script[k].DataCnt := 2;
							Inc(k);
{アジト機能追加}
						{Colus, 20040110: Updated guild territory command codes}
						end else if str = 'getagit' then begin //------- 58 getagit
							if (sl1.Count <> 3) then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							if (Copy(SL1[1], 1, 1) <> '$') and (Copy(SL1[1], 1, 2) <> '\$') then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							if (Copy(SL1[2], 1, 1) <> '$') and (Copy(SL1[2], 1, 2) <> '\$') then begin
								ScriptErr(SCRIPT_RANGE3_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 58;
							SetLength(tn.Script[k].Data1, 1);
							SetLength(tn.Script[k].Data2, 2);
							tn.Script[k].Data1[0] := SL1[0];
							tn.Script[k].Data2[0] := LowerCase(SL1[1]);
							tn.Script[k].Data2[1] := LowerCase(SL1[2]);
							Inc(k);
						end else if str = 'getmyguild' then begin //------- 59 getguild
							if (sl1.Count <> 1) then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							if (Copy(SL1[0], 1, 1) <> '$') and (Copy(SL1[0], 1, 2) <> '\$') then begin
								ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 59;
							SetLength(tn.Script[k].Data1, 1);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							Inc(k);

						end else if str = 'agitregist' then begin //------- 60 agitregist
							if (sl1.Count <> 1) then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 60;
							SetLength(tn.Script[k].Data1, 1);
							tn.Script[k].Data1[0] := SL1[0];
							Inc(k);

						end else if str = 'resetstat' then begin //------- 45 resetstat
							if sl1.Count <> 0 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 45;
							Inc(k);

						end else if str = 'resetbonusstat' then begin //------- 57 resetbonusstat
							if sl1.Count <> 0 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 57;
							Inc(k);
						end else if str = 'resetskill' then begin //------- 46 resetskill
							if sl1.Count <> 0 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 46;
							Inc(k);
						end else if str = 'hstyle' then begin //------- 47 hstyle
							if sl1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[0], i, j);
							if j = 0 then begin
								if (i < 0) or (i > 19) then begin
									ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 47;
							SetLength(tn.Script[k].Data1, 1);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							Inc(k);
						end else if str = 'guildreg' then begin //------- 48 guildreg
							if sl1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							//j := CastleList.IndexOf(SL1[0]);
							//if j = - 1 then begin
								//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('%s %.4d: [guildreg] map error', [ScriptPath, lines]));
								{ChrstphrR - adding in proper cleanup even though this is
								all commented out...}
								//SL.Free;
								//SL1.Free;
								//SL2.Free;
								//exit;
							//end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 48;
							SetLength(tn.Script[k].Data1, 1);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							Inc(k);
						end else if str = 'getgskilllevel' then begin //--------49 getgskilllevel
							if sl1.Count <> 2 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;

							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 49;
							SetLength(tn.Script[k].Data1, 2);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[1]);
							Inc(k);
						end else if str = 'getguardstatus' then begin //--------50 getguardstatus
							if sl1.Count <> 2 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;

							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 50;
							SetLength(tn.Script[k].Data1, 2);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[1]);
							Inc(k);
						end else if str = 'setguildkafra' then begin //------- 51 setguildkafra
							if sl1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[0], i, j);
							if j = 0 then begin
								if (i < 0) or (i > 1) then begin
									ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 51;
							SetLength(tn.Script[k].Data1, 1);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							Inc(k);
						end else if str = 'setguardstatus' then begin //--------52 setguardstatus
							if sl1.Count <> 2 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[0], i, j);
							if j = 0 then begin
								if (i < 1) or (i > 8) then begin
									ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							val(SL1[1], i, j);
							if j = 0 then begin
								if (i < 0) or (i > 1) then begin
									ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 52;
							SetLength(tn.Script[k].Data1, 2);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[1]);
							Inc(k);
						end else if str = 'callguard' then begin //------- 53 callguard
							if sl1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[0], i, j);
							if j = 0 then begin
								if (i < 1) or (i > 8) then begin
									ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 53;
							SetLength(tn.Script[k].Data1, 1);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							Inc(k);
						end else if str = 'callmymob' then begin //------- 54 callmymob
							if sl1.Count <> 5 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 54;
							SetLength(tn.Script[k].Data1, 5);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[1]);
							tn.Script[k].Data1[2] := LowerCase(SL1[2]);
							tn.Script[k].Data1[3] := LowerCase(SL1[3]);
							tn.Script[k].Data1[4] := LowerCase(SL1[4]);
							Inc(k);
						end else if str = 'resetguild' then begin //------- 55 resetguild
							if sl1.Count <> 0 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 55;
							Inc(k);
						end else if str = 'guilddinvest' then begin //------- 56 guilddinvest
							if sl1.Count <> 0 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 56;
							Inc(k);
						{end else if str = 'movenpc' then begin //------- 61 Move NPC
						if sl1.Count <> 0 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21 -- changed even if commented out
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 61;
							SetLength(tn.Script[k].Data1, 1);
							SetLength(tn.Script[k].Data3, 1);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							Inc(k);}
						end else if str = 'removeequipment' then begin //----- 63 Remove Equipment
							if sl1.Count <> 0 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 63;
							Inc(k);
						end else if str = 'basereset' then begin //----- 64 BaseReset
							if sl1.Count <> 0 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;

							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 64;
							Inc(k);
						end else if str = 'global' then begin //----- 65 Global Variable
							//We convert literal math into easier things to work with
							SL[0] := StringReplace(SL[0], '+=', '+', []);
							SL[0] := StringReplace(SL[0], '-=', '-', []);
							SL[0] := StringReplace(SL[0], '*=', '*', []);
							SL[0] := StringReplace(SL[0], '/=', '/', []);
							SL[0] := StringReplace(SL[0], '+', ',1,', []);
							SL[0] := StringReplace(SL[0], '-', ',2,',	[]);
							SL[0] := StringReplace(SL[0], '=', ',0,', []);
							SL[0] := StringReplace(SL[0], '*', ',3,', []);
							SL[0] := StringReplace(SL[0], '/', ',4,', []);
							while Pos('- ', SL[0]) <> 0 do
								SL[0] := StringReplace(SL[0], '- ', '-',	[]);
							SL1.DelimitedText := SL[0];
							if SL1.Count = 3 then SL1.Add('0');
							if SL1.Count <> 4 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[1], i, j);
							if (j <> 0) or (i < 0) or (i > 4) then begin
								ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[2], i, j);
							if j = 0 then begin
								if (i < -999999999) or (i > 999999999) then begin
									ScriptErr(SCRIPT_RANGE3_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end else if (StrToInt(SL1[1]) = 3) and (i = 0) then begin
									ScriptErr(SCRIPT_DIV_Z3_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							Val(SL1[3], i, j);
							if (j <> 0) or (i < -999999999) or (i > 999999999) then begin
								ScriptErr(SCRIPT_RANGE4_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 65;
							SetLength(tn.Script[k].Data1, 2);
							SetLength(tn.Script[k].Data3, 2);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[2]);
							tn.Script[k].Data3[0] := StrToInt(SL1[1]);
							tn.Script[k].Data3[1] := StrToInt(SL1[3]);
							Inc(k);
						end else if str = 'gcheck' then begin //------- 66 Global Check
							SL[0] := StringReplace(SL[0], '=>', '>=', []);
							SL[0] := StringReplace(SL[0], '=<', '<=', []);
							SL[0] := StringReplace(SL[0], '==', '=',	[]);
							SL[0] := StringReplace(SL[0], '><', '<>', []);
							SL[0] := StringReplace(SL[0], '!=', '<>', []);
							SL[0] := StringReplace(SL[0], '>',	',>,',	[]);
							SL[0] := StringReplace(SL[0], '<',	',<,',	[]);
							SL[0] := StringReplace(SL[0], '=',	',=,',	[]);
							SL[0] := StringReplace(SL[0], ',>,,=,', ',>=,', []);
							SL[0] := StringReplace(SL[0], ',<,,=,', ',<=,', []);
							SL[0] := StringReplace(SL[0], ',<,,>,', ',<>,', []);
							sl1.DelimitedText := SL[0];
							if sl1.Count <> 5 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							val(SL1[2], i, j);
							if j = 0 then begin
								if (i < 0) or (i > 999999999) then begin
									ScriptErr(SCRIPT_RANGE1_ERR, [ScriptPath, lines, str]);
									Exit; // Safe - 2004/04/21
								end;
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 66;
							SetLength(tn.Script[k].Data1, 3);
							SetLength(tn.Script[k].Data2, 2);
							SetLength(tn.Script[k].Data3, 3);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[2]);
							tn.Script[k].Data1[2] := SL1[1];
							mathop := SL1[1];
							j := -1;
							     if mathop = '>=' then j := 0
							else if mathop = '<=' then j := 1
							else if mathop = '='	then j := 2
							else if mathop = '<>' then j := 3
							else if mathop = '>'	then j := 4
							else if mathop = '<'	then j := 5;
							if j = -1 then begin
								ScriptErr(SCRIPT_SYNT_2_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							tn.Script[k].Data3[2] := j;
							tn.Script[k].Data2[0] := LowerCase(SL1[3]);
							tn.Script[k].Data2[1] := LowerCase(SL1[4]);
							tn.Script[k].DataCnt := 2;
							Inc(k);
						end else if str = 'eventmob' then begin //------ 67 Event Monster
							if sl1.Count <> 5 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 67;
							SetLength(tn.Script[k].Data1, 5);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							tn.Script[k].Data1[1] := LowerCase(SL1[1]);
							tn.Script[k].Data1[2] := LowerCase(SL1[2]);
							tn.Script[k].Data1[3] := LowerCase(SL1[3]);
							tn.Script[k].Data1[4] := LowerCase(SL1[4]);
							Inc(k);

						end else if str = 'addskillpoints' then begin //----- 68 Add Skill Point
							if sl1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 68;
							SetLength(tn.Script[k].Data1, 1);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							Inc(k);
						end else if str = 'addstatpoints' then begin //---- 69 Add Stat Point
							if sl1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 69;
							SetLength(tn.Script[k].Data1, 1);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							Inc(k);
                        end else if str = 'emotion' then begin //---- 70 emotion
                            if sl1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 70;
							SetLength(tn.Script[k].Data1, 1);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							Inc(k);
                        end else if str = 'donpcevent' then begin //------- 71 donpcevent
							if (sl1.Count <> 2) then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							//val(SL1[2], i, j);
							//if (j <> 0) or (i < 0) or (i > 1) then begin
							//	ScriptErr(SCRIPT_RANGE2_ERR, [ScriptPath, lines, str]);
							//	Exit; // Safe - 2004/04/21
							//end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 71;
							SetLength(tn.Script[k].Data1, 2);
                            SetLength(tn.Script[k].Data3, 1);
							//SetLength(tn.Script[k].Data3, 1);
							tn.Script[k].Data1[0] := SL1[0];
							tn.Script[k].Data1[1] := lowercase(SL1[1]);
							//tn.Script[k].Data3[0] := StrToInt(SL1[2]);
							Inc(k);
						end else if str = 'script' then begin //------- 99 script
							if sl1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							SetLength(tn.Script, k + 1);
							tn.Script[k].ID := 99;
							SetLength(tn.Script[k].Data1, 1);
							SetLength(tn.Script[k].Data3, 4);
							tn.Script[k].Data1[0] := LowerCase(SL1[0]);
							Inc(k);
						end else if Copy(str, Length(str), 1) = ':' then begin //label
{NPCイベント追加}
							if (LowerCase(Copy(str, 1, 7)) = 'ontimer') then begin
								j := StrToInt(Copy(str, 8, Length(str) - 8));
								if (j >= 0) and (j < 999999999) then begin
									i := tm.TimerDef.IndexOf(tn.ID);
									if (i <> -1) then begin
										tr := tm.TimerDef.Objects[i] as NTimer;
									end else begin
										tr := NTimer.Create;
										tm.TimerDef.AddObject(tn.ID, tr);
									end;
									tr.ID := tn.ID;
									SetLength(tr.Idx, tr.Cnt + 1);
									SetLength(tr.Step, tr.Cnt + 1);
									SetLength(tr.Done, tr.Cnt + 1);
									tr.Idx[tr.Cnt] := j;
									tr.Step[tr.Cnt] := k;
									tr.Cnt := tr.Cnt + 1;
								end;
							end else if (LowerCase(Copy(str, 1, 6)) = 'oninit') then begin
								tn.ScriptInitS := k;
							end else if (LowerCase(Copy(str, 1, 11)) = 'onmymobdead') then begin
								tn.ScriptInitMS := k;
							end;

							str := Copy(str, 1, Length(str) - 1);
							sl2.Add(str + '=' + IntToStr(k));
						end else if str = 'scriptlabel' then begin //scriptlabel
							if SL1.Count <> 1 then begin
								ScriptErr(SCRIPT_FUNCTN_ERR, [ScriptPath, lines, str]);
								Exit; // Safe - 2004/04/21
							end;
							tn.ScriptLabel := LowerCase(SL1[0]);
						end else if Copy(str,1,2) <> '//' then begin
							{ChrstphrR 2004/05/05 - We're silently ignoring comments
							-- if we're in here, there was an invalid command.}
							ScriptErr(SCRIPT_NONCMD_ERR, [ScriptPath, Lines, Str]);
							Exit; // safe 2004/05/05
						end;
					end;//while not eof(txt)

					tn.ScriptCnt := k;
					for i := 0 to k - 1 do begin
						case tn.Script[i].ID of
						4,14,15,16,44,66:
							begin
								for j := 0 to tn.Script[i].DataCnt - 1 do begin
									if tn.Script[i].Data2[j] = '-' then begin //nopラベル
										tn.Script[i].Data3[j] := i + 1;
									end else if sl2.IndexOfName(tn.Script[i].Data2[j]) = -1 then begin
										ScriptErr(SCRIPT_LBLNOT_ERR, [ScriptPath, tn.Script[i].Data2[j]]);
										Exit; // Safe - 2004/04/21
										//tn.Script[i].Data3[j] := $FFFF;
									end else begin
										tn.Script[i].Data3[j] := StrToInt(sl2.Values[tn.Script[i].Data2[j]]);
									end;
								end;
							end;
						5:
							begin
								if sl2.IndexOfName(tn.Script[i].Data1[0]) = -1 then begin
									ScriptErr(SCRIPT_LBLNOT_ERR, [ScriptPath, tn.Script[i].Data2[j]]);
									Exit; // Safe - 2004/04/21
									//tn.Script[i].Data3[0] := $FFFF;
								end else begin
									tn.Script[i].Data3[0] := StrToInt(sl2.Values[tn.Script[i].Data1[0]]);
								end;
							end;
						end;
					end;//for i

					if tn.ScriptLabel <> '' then tm.NPCLabel.AddObject(tn.ScriptLabel, tn);
					tm.NPC.AddObject(tn.ID, tn);
					tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.AddObject(tn.ID, tn);
					tm.gat[tn.Point.X][tn.Point.Y] := (tm.gat[tn.Point.X][tn.Point.Y] or $8);

{d$0100fix5よりココまで}
	// モンスター ----------------------------------------------------------------
				end else if SL[1] = 'monster' then begin
					(*
					e.g.
					aldeg_cas01.gat,216,23,0,0 monster "Emperium" 1288,1,0,0,1

					Four space/tab separated tokens overall, stored in
						SL[0] SL[1] SL[2] SL[3]
					Comma separated tokens per segment
						SL[0] has 5 tokens.
						SL[3] has 5 tokens.
					initially here, SL1[] = SL[0]

					Fixing SL1 Count checks properly now -
					2004/05/09 - 2nd fix - exit gracefully, note error.
					*)

					if SL1.Count <> 5 then begin
						if ShowDebugErrors then
							debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format(
								'%s %.4d: Monster Definition Error: %s',
								[ScriptPath, Lines, Str]
							));
						SL.Free;
						SL1.Free;
						SL2.Free;
						Result := False;
						Exit; //safe 2004/05/09
					end;

					ts0 := TMob.Create;
					ts0.Name := SL[2];
					//debugout.lines.add('[' + TimeToStr(Now) + '] ' + '-> adding mob ' + ts0.Name);
					ts0.Map := MapName;
					ts0.Point1.X := StrToInt(SL1[1]);
					ts0.Point1.Y := StrToInt(SL1[2]);
					ts0.Dir := 3;
					ts0.Point2.X := StrToInt(SL1[3]);
					ts0.Point2.Y := StrToInt(SL1[4]);

					{ChrstphrR 2004/05/06 - Colus, your hunch was right, this loop here
					SL1 was not checked properly - since at least the EWeiss project!
					2004/05/09 - instead of Padding, flagging error, exit gracefully}
					SL1.DelimitedText := SL[3];
					if SL1.Count <> 5 then begin
						if ShowDebugErrors then
							debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format(
								'%s %.4d: Monster Definition Error: %s',
								[ScriptPath, Lines, Str]
							));
						SL.Free;
						SL1.Free;
						SL2.Free;
						Result := False;
						ts0.Free; // Made a TMob, need to clean it up now too.
						Exit; //safe 2004/05/09
					end;
					for i := SL1.Count to 5 do SL1.Add('0');
					ts0.JID := StrToInt(SL1[0]);
					mcnt            := StrToInt(SL1[1]);
					ts0.SpawnDelay1 := StrToInt(SL1[2]);
					ts0.SpawnDelay2 := StrToInt(SL1[3]);
					ts0.SpawnType   := StrToInt(SL1[4]);

					if MobDB.IndexOf(ts0.JID) = -1 then continue;
					ts0.Data := MobDB.IndexOfObject(ts0.JID) as TMobDB;
					if (ts0.Point1.X = 0) and (ts0.Point1.Y = 0) and (ts0.Point2.X = 0) and (ts0.Point2.Y = 0) then begin
						//0,0,0,0指定時はマップ全域にランダム配置
						ts0.Point1.X := tm.Size.X div 2;
						ts0.Point1.Y := tm.Size.Y div 2;
						ts0.Point2.X := tm.Size.X - 1;
						ts0.Point2.Y := tm.Size.Y - 1;
					end;

					for i := 0 to mcnt - 1 do begin
						//所定数モンスターの初期配置
						ts := TMob.Create;
						ts.ID := NowMobID;
						Inc(NowMobID);
						ts.Name := ts0.Data.JName;
						ts.JID := ts0.JID;
						ts.Map := ts0.Map;
						ts.Point1.X := ts0.Point1.X;
						ts.Point1.Y := ts0.Point1.Y;
						ts.Point2.X := ts0.Point2.X;
						ts.Point2.Y := ts0.Point2.Y;

{追加}			if (ts.JID = 1288) then begin
							ts.isEmperium := true;
							m := CastleList.IndexOf(ts.Map);
							if (m <> - 1) then begin
								tgc := CastleList.Objects[m] as TCastle;
								ts.GID := tgc.GID;
							end;
							k := EmpList.IndexOf(ts.Map);
							if (k = -1) then begin
								te := TEmp.Create;
								with te do begin
									Map := ts.Map;
									EID := ts.ID;
								end;
								EmpList.AddObject(te.Map, te);
							end;
						end;//if ts.JID-1288

						ts.isLooting := False;
						for j:= 1 to 10 do begin
							ts.Item[j].ZeroItem;
						end;
{追加ココまで}
						j := 0;
						repeat
							ts.Point.X := ts.Point1.X + Random(ts.Point2.X + 1) - (ts.Point2.X div 2);
							ts.Point.Y := ts.Point1.Y + Random(ts.Point2.Y + 1) - (ts.Point2.Y div 2);
							//030317
							if (ts.Point.X < 0) or (ts.Point.X > tm.Size.X - 2) or (ts.Point.Y < 0) or (ts.Point.Y > tm.Size.Y - 2) then begin
								//debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('***RandomRoute Error!! (%d,%d) %dx%d', [xy.X,xy.Y,tm.Size.X,tm.Size.Y]));
								if ts.Point.X < 0 then ts.Point.X := 0;
								if ts.Point.X > tm.Size.X - 2 then ts.Point.X := tm.Size.X - 2;
								if ts.Point.Y < 0 then ts.Point.Y := 0;
								if ts.Point.Y > tm.Size.Y - 2 then ts.Point.Y := tm.Size.Y - 2;
							end;
							//---
							Inc(j);
						until ( (tm.gat[ts.Point.X][ts.Point.Y] <> 1) and (tm.gat[ts.Point.X][ts.Point.Y] <> 5) or (j = 100) );
						if j <> 100 then begin
							ts.Dir := Random(8);
							ts.HP := ts0.Data.HP;
							ts.Speed := ts0.Data.Speed;
							ts.SpawnDelay1 := ts0.SpawnDelay1;
							ts.SpawnDelay2 := ts0.SpawnDelay2;
							ts.SpawnType   := ts0.SpawnType;
							ts.SpawnTick   := 0;
							if ts0.Data.isDontMove then
								ts.MoveWait := 4294967295
							else
								ts.MoveWait := Tick + 5000 + Cardinal(Random(10000));
							ts.ATarget := 0;
							ts.ATKPer  := 100;
							ts.DEFPer  := 100;
							ts.DmgTick := 0;
							ts.Data    := ts0.Data;
							for j := 0 to 31 do begin
								ts.EXPDist[j].CData := nil;
								ts.EXPDist[j].Dmg := 0;
							end;
							if ts.Data.MEXP <> 0 then begin
								for j := 0 to 31 do begin
									ts.MVPDist[j].CData := nil;
									ts.MVPDist[j].Dmg := 0;
								end;
								ts.MVPDist[0].Dmg := ts.Data.HP * 30 div 100; //In FA 30%
							end;
{追加}				ts.Element  := ts.Data.Element;
{追加}				ts.isActive := ts.Data.isActive;
							ts.EmperiumID := 0;
							tm.Mob.AddObject(ts.ID, ts);
							tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
						end else begin
							ts.Free;
						end;//if-else j<>100

						if (MonsterMob = true) then begin
							k := SlaveDBName.IndexOf(ts0.Data.Name);
							if (k <> -1) then begin
								ts.isLeader := true;
							end;
						end;

					end;
					ts0.Free;
				end;
			end;
		end;
	end;
	CloseFile(txt);

	//Made it ! -- need to free up the StringLists used, though.
	SL.Free;
	SL1.Free;
	SL2.Free;
End;(* Func ScriptValidate()
*-----------------------------------------------------------------------------*)




//------------------------------------------------------------------------------
procedure MapMove(Socket:TCustomWinSocket; MapName:string; Point:TPoint);
begin
	WFIFOW(0, $0091);
	WFIFOS(2, MapName + '.rsw', 16);
	WFIFOW(18, Point.X);
	WFIFOW(20, Point.Y);
	Socket.SendBuf(buf, 22);

	//マップロード
	if Map.IndexOf(MapName) = -1 then MapLoad(MapName);

	//tm := Map.Objects[Map.IndexOf(MapName)] as TMap;
	//WFIFOW( 0, $0199);
	//WFIFOW( 2, 1);
	//Socket.SendBuf(buf, 4);
	//for j := 0 to tm.CList.Count - 1 do begin
	//tc1 := tm.CList.Objects[j] as TChara;
	//k := j + 1;
  //i := tm.CList.Count;
  //WFIFOW( 0, $019a);
  //WFIFOL( 2, tc1.ID);
  //WFIFOL( 6, k);
  //WFIFOL( 10, i);
  //Socket.SendBuf(buf, 14);
  //end;

end;
//------------------------------------------------------------------------------
function StealItem(tc:TChara) :boolean;
var
	i,k, w    :integer;
	mdrop  :array[0..7] of integer;
    success:double;
    weight :integer;
	td     :TItemDB;
	modfix :integer;
	rand   :integer;
	tm     :TMap;
    ts     :TMob;
    tc1    :TChara;
    str      :string;
begin
    tc1 := tchara.Create;
    ts := tmob.create;

    tc1 := nil;
    ts := nil;
    
    tm := tc.MData;

    if (tm.CList.IndexOf(tc.MTarget) <> -1) then begin
        tc1 := tc.adata;
    end else begin
        ts := tc.adata;
    end;

    // Modifier calc:
    // adjusted drop ratio = (10 + 3*skill + cdex - mdex)% * drop
    // This is really draconian even for high drops.  A poring drops jellopies 70%,
    // but a normal thief rarely has a mod over 50 (steal 5, 30 dex).  So 35% just for jellopy?  Bah.
    // So, we added a multiplier.  However: If your multiplier was negative, multiplying
    // made it more negative!  Oh, sweet irony!
    // Therefore the effect of the multiplier is calculated a bit differently now.
    //
    // Old:
    //modfix := (tc.Skill[50].Data.Data1[tc.Skill[50].Lv] + tc.Param[4] - ts.Data.Param[4]);
    //modfix := modfix * StealMultiplier div 100;

    modfix := ((tc.Skill[50].Data.Data1[tc.Skill[50].Lv] * StealMultiplier div 100) + tc.Param[4]);

	if Assigned(ts) then begin
		modfix := modfix - ts.Data.Param[4];
	end else if Assigned (tc1) then begin
		modfix := modfix - tc1.Param[4];
	end;

    // This isn't the right check!  It checks for leaders.  We have
    // isLeader and isSlave now for that...
    //k := SlaveDBName.IndexOf(ts.Data.Name);
    //if ((k <> -1) or (ts.Data.MEXP <> 0) or (ts.Stolen <> 0)) then begin
    if assigned(ts) then begin
        if ((ts.isSlave) or (ts.Data.MEXP <> 0) or (ts.Stolen <> 0)) then begin
            Result := false;
            exit;
        end;
    end;

    if assigned(tc1) then begin
        for i := 1 to 100 do begin
            if tc1.Item[i].ID <> 0 then begin
                if tc1.Item[i].Equip <> 0 then begin
                    modfix := modfix - tc1.param[0];
                end;
                weight := tc1.Item[i].Data.Weight;
                success := muldiv(modfix, 100, weight);
                rand := Random(20000) mod 10000;
                if rand <= success then begin
                    WFIFOW( 0, $011a);
                    WFIFOW( 2, 50);
                    WFIFOW( 4, 0);
                    WFIFOL( 6, tc1.ID);
                    WFIFOL(10, tc.ID);
                    WFIFOB(14, 1);
                    SendBCmd(tm,tc1.Point,15);

                    k := tc1.item[i].ID;
                    td := ItemDB.IndexOfObject(k) as TItemDB;
                    if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) then begin
                        k := SearchCInventory(tc, td.ID, td.IEquip);
                        if k <> 0 then begin
                            if tc.Item[k].Amount < 30000 then begin
                                UpdateWeight(tc, k, td);
                                SendCGetItem(tc, k, 1);

                                WFIFOW( 0, $00af);
                                WFIFOW( 2, i);
                                WFIFOW( 4, 1);
                                tc1.Socket.SendBuf(buf, 6);
                                
                                tc1.Item[i].Amount := tc1.Item[i].Amount - 1;
                                if tc1.Item[i].Amount = 0 then tc1.Item[i].ID := 0;
                                tc1.Weight := tc1.Weight - tc1.Item[i].Data.Weight;
                                tc1.Socket.SendBuf(buf, 6);
                                SendCStat1(tc, 0, $0018, tc1.Weight);

                                str := tc.Name + ' stole one ' + tc1.item[i].Data.Name + ' from you.';
                                w := length(STR) + 4;
                                WFIFOW(0, $009a);
                                WFIFOW(2, w);
                                WFIFOS(4, str, w - 4);
                                tc1.Socket.SendBuf(buf, w);

                                Result := true;
                                Exit;
                            end;
                        end;
                    end else begin
                        // Overweight, failed to get item.
                        WFIFOW( 0, $00a0);
                        WFIFOB(22, 2);
                        tc.Socket.SendBuf(buf, 23);
                    end; {end item added}
                end;
            end;
        end;
    end else

    if assigned(ts) then begin
        for i := 0 to 7 do begin
            mdrop[i] := modfix * integer(ts.Data.Drop[i].Per) div 100;
            rand := Random(20000) mod 10000;
            //debugout.lines.add('[' + TimeToStr(Now) + '] ' + Format('Drop %d, dropid %d, modfix %d, mdrop %d, rand %d',[i,ts.Data.Drop[i].ID,modfix,mdrop[i],rand]));
            if rand <= mdrop[i] then begin
                // Graphic send
                WFIFOW( 0, $011a);
                WFIFOW( 2, 50);
                WFIFOW( 4, 0);
                WFIFOL( 6, ts.ID);
                WFIFOL(10, tc.ID);
                WFIFOB(14, 1);
                SendBCmd(tm,ts.Point,15);

                k := ts.Data.Drop[i].Data.ID;
                td := ItemDB.IndexOfObject(k) as TItemDB;
                if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) then begin
                    k := SearchCInventory(tc, td.ID, td.IEquip);
                    if k <> 0 then begin
                        if tc.Item[k].Amount < 30000 then begin
                            UpdateWeight(tc, k, td);
                            //tc.Socket.SendBuf(buf, 8);
                            SendCGetItem(tc, k, 1);
                            ts.Stolen := tc.ID;
                            Result := true;
                            exit;
                        end;
                    end;
                end else begin
                    // Overweight, failed to get item.
                    WFIFOW( 0, $00a0);
                    WFIFOB(22, 2);
                    tc.Socket.SendBuf(buf, 23);
                end; {end item added}
            end;
        end;
    end;

    Result := false;
end;
//------------------------------------------------------------------------------
procedure RFIFOB(index:word; var b:byte);
begin
	Assert(index <= 32767, 'RFIFOB: index overflow ' + IntToStr(index));
	Move(buf[index], b, 1);
end;
//------------------------------------------------------------------------------
procedure RFIFOW(index:word; var w:word);
begin
	Assert(index <= 32766, 'RFIFOW: index overflow ' + IntToStr(index));
	Move(buf[index], w, 2);
end;
//------------------------------------------------------------------------------
procedure RFIFOL(index:word; var l:cardinal);
begin
	Assert(index <= 32764, 'RFIFOL: index overflow ' + IntToStr(index));
	Move(buf[index], l, 4);
end;
//------------------------------------------------------------------------------
function RFIFOS(index:word; cnt:word):string;
begin
	Assert(index <= 32767, 'RFIFOS: index overflow ' + IntToStr(index));
	Assert(index + cnt <= 32767, 'RFIFOS: index+cnt overflow ' + IntToStr(index+cnt));
	stra[cnt] := #0;
	Move(buf[index], stra, cnt);
	Result := stra;
end;
//------------------------------------------------------------------------------
procedure RFIFOM1(index:word; var xy:TPoint);
var
	l   :cardinal;
	bb  :array[0..3] of byte;
begin
	Move(buf[index], bb[0], 3);
	bb[3] := bb[0]; bb[0] := bb[2]; bb[2] := bb[3];
	Move(bb[0], l, 3);
	l := l shr 4;
	xy.Y :=  (l and $003ff);
	xy.X := ((l and $ffc00) shr 10);
end;
//------------------------------------------------------------------------------
procedure RFIFOM2(index:word; var xy1:TPoint; var xy2:TPoint);
var
	i   :int64;
	bb  :array[0..5] of byte;
begin
	Move(buf[index], i, 5);
	bb[5] := bb[0]; bb[0] := bb[4]; bb[4] := bb[5];
	bb[5] := bb[1]; bb[1] := bb[3]; bb[3] := bb[5];
	Move(bb[0], i, 5);
	xy1.Y :=  (i and $00000003ff);
	xy1.X := ((i and $00000ffc00) shr 10);
	xy2.Y := ((i and $003ff00000) shr 20);
	xy2.X := ((i and $ffc0000000) shr 30);
end;
//------------------------------------------------------------------------------
procedure WFIFOB(index:word; b:byte);
begin
	Assert(index <= 32767, 'WFIFOB: index overflow ' + IntToStr(index));
	Move(b, buf[index], 1);
end;
//------------------------------------------------------------------------------
procedure WFIFOW(index:word; w:word);
begin
	Assert(index <= 32766, 'WFIFOW: index overflow ' + IntToStr(index));
	Move(w, buf[index], 2);
end;
//------------------------------------------------------------------------------
procedure WFIFOL(index:word; l:longword);
begin
	Assert(index <= 32764, 'WFIFOL: index overflow ' + IntToStr(index));
	Move(l, buf[index], 4);
end;
//------------------------------------------------------------------------------
procedure WFIFOS(index:word; str:string; cnt:word);
var
	i :integer;
begin
	Assert(index <= 32767, 'WFIFOS: index overflow ' + IntToStr(index));
	Assert(index + cnt <= 32767, 'WFIFOS: index+cnt overflow ' + IntToStr(index+cnt));

	ZeroMemory(@buf[index], cnt);
	i := Length(str);
	if i = 0 then exit;
	if i > cnt then i := cnt;
	Move(str[1], buf[index], i);
end;
//------------------------------------------------------------------------------
procedure WFIFOM1(index:word; xy:TPoint; Dir:byte = 0);
var
	l   :cardinal;
	bb  :array[0..3] of byte;
begin
	l := (((xy.X and $3ff) shl 14) or ((xy.Y and $3ff) shl 4));
	Move(l, bb[0], 3);
	bb[3] := bb[0]; bb[0] := bb[2]; bb[2] := bb[3];
	bb[2] := (bb[2] or (Dir and $f));
	Move(bb[0], buf[index], 3);
end;
//------------------------------------------------------------------------------
procedure WFIFOM2(index:word; xy1:TPoint; xy2:TPoint);
var
	i :int64;
	bb  :array[0..5] of byte;
begin
	i := (((int64(xy2.X) and $3ff) shl 30) or ((int64(xy2.Y) and $3ff) shl 20) or
				((int64(xy1.X) and $3ff) shl 10) or  (int64(xy1.Y) and $3ff));
	Move(i, bb[0], 5);
	bb[5] := bb[0]; bb[0] := bb[4]; bb[4] := bb[5];
	bb[5] := bb[1]; bb[1] := bb[3]; bb[3] := bb[5];
	Move(bb[0], buf[index], 5);
end;
//==============================================================================
{
//get boolean procedure for boolean SkillOnBool
//beita 20040206
procedure TChara.setSkillOnBool(temp : Boolean);
begin;
SkillOnBool := temp;
end;

//==============================================================================
//set boolean function for boolean SkillOnBool
//beita 20040206
function TChara.getSkillOnBool : Boolean;
begin
Result := SkillOnBool;
end;
}



{===========================}
{== Start of TItemDB Code ==}
{===========================}


(*----- TItemDB.Assign ----------------*
start: CRW 2004/04/04
last: CRW 2004/04/05

Summary:
  Tedious field by field copy routine for duplicating
  the essentials of one TItemDB to another TItemDB instance.

  This saves writing out the transfer of EVERY property.

  Not Copied:

Caveat Emptor:
  Assign() is used to copy values, and avoid novice mistakes like this:

  procedure FooBlarg(AnotherItem : TItem; TakeThisMany : Cardinal);
  var
    AnItem : TItem;
  begin
    AnItem := TItem.Create;
    //Newbie note - I'm copying AnotherItem into AnItem.

    //Right way to copy :)
    AnItem.Assign(AnotherItem);
    MyCart.AddItem(AnItem);

    //Wrong - lost the reference to the Data object - memory leak!
    AnItem.Data  := AnotherItem.Data;

  end;

*-------------------------------------*)
Procedure TItemDB.Assign(Source: TItemDB);
Var
  J : Integer; // Index Variable for array transfer.
Begin
  //Transfer fields
	ID        := Source.ID;
	Name      := Source.Name;
	JName     := Source.JName;

	IType     := Source.IType;
	IEquip    := Source.IEquip;

	Price     := Source.Price;
	Sell      := Source.Sell;

	Weight    := Source.Weight;
	ATK       := Source.ATK;
	MATK      := Source.MATK;
	DEF       := Source.DEF;
	MDEF      := Source.MDEF;
	Range     := Source.Range;
	Slot      := Source.Slot;

  Param[0]  := Source.Param[0];
  Param[1]  := Source.Param[1];
  Param[2]  := Source.Param[2];
  Param[3]  := Source.Param[3];
  Param[4]  := Source.Param[4];
  Param[5]  := Source.Param[5];

	HIT       := Source.HIT;
	FLEE      := Source.FLEE;
	Crit      := Source.Crit;
	Avoid     := Source.Avoid;
	Cast      := Source.Cast;

	Job       := Source.Job;
	Gender    := Source.Gender;

	Loc       := Source.Loc;
	wLV       := Source.wLV;
	eLV       := Source.eLV;
	View      := Source.View;
	Element   := Source.Element;
	Effect    := Source.Effect;
	HP1       := Source.HP1;
	HP2       := Source.HP2;
	SP1       := Source.SP1;
	SP2       := Source.SP2;
	//Rare      := Source.Rare;
	//Box       := Source.Box;

  for J := 0 to 9 do
    begin
    DamageFixR[J] := Source.DamageFixR[J];
    DamageFixE[J] := Source.DamageFixE[J];
    end;
  DamageFixS[0] := Source.DamageFixS[0];
  DamageFixS[1] := Source.DamageFixS[1];
  DamageFixS[2] := Source.DamageFixS[2];

  SFixPer1[0]   := Source.SFixPer1[0];
  SFixPer1[1]   := Source.SFixPer1[1];
  SFixPer1[2]   := Source.SFixPer1[2];
  SFixPer1[3]   := Source.SFixPer1[3];
  SFixPer1[4]   := Source.SFixPer1[4];
  SFixPer1[5]   := Source.SFixPer1[5];

  SFixPer2[0]   := Source.SFixPer2[0];
  SFixPer2[1]   := Source.SFixPer2[1];
  SFixPer2[2]   := Source.SFixPer2[2];
  SFixPer2[3]   := Source.SFixPer2[3];
  SFixPer2[4]   := Source.SFixPer2[4];

  DrainFix[0]   := Source.DrainFix[0];
  DrainFix[1]   := Source.DrainFix[1];

  DrainPer[0]   := Source.DrainPer[0];
  DrainPer[1]   := Source.DrainPer[1];

  for J:= 0 to MAX_SKILL_NUMBER do
    begin
  	AddSkill[J] := Source.AddSkill[J];  // Skill addition
    end;

	if Specialattack > 0 then SpecialAttack := Source.SpecialAttack;
	SplashAttack  := Source.SplashAttack;
  WeaponSkill   := Source.WeaponSkill;
  WeaponSkillLV := Source.WeaponSkillLV;
  WeaponID      := Source.WeaponID;
	NoJamstone    := Source.NoJamStone;

  FastWalk          := Source.FastWalk;
  NoTarget          := Source.NoTarget;
  FullRecover       := Source.FullRecover;
  LessSP            := Source.LessSP;
  OrcReflect        := Source.OrcReflect;
  AnolianReflect    := Source.AnolianReflect;
  UnlimitedEndure   := Source.UnlimitedEndure;
  DoppelgagnerASPD  := Source.DoppelgagnerASPD;
  GhostArmor        := Source.GhostArmor;
  NoCastInterrupt   := Source.NoCastInterrupt;
  MagicReflect      := Source.MagicReflect;
  SkillWeapon       := Source.SkillWeapon;
  GungnirEquipped   := Source.GungnirEquipped;
  LVL4WeaponASPD    := Source.Lvl4WeaponASPD;
  PerfectDamage     := Source.PerfectDamage;

  // No politeness with inherited Assign calls -- this one isn't
  // derived from TPersistant, so there is no virtual Assign stub.
end;(*- TItemDB.Assign ---------------*)


{=========================}
{== End of TItemDB Code ==}
{=========================}


{=========================}
{== Start of TItem Code ==}
{=========================}


(*----- TItem.Create ------------------*
start: CRW 2004/04/01
last: CRW 2004/04/03

Initialzes data (Zero/Nil) held in TItem

*-------------------------------------*)
Constructor TItem.Create;
Begin
  inherited;
	ZeroItem;
End;(*- TItem.Create ----------------*)


(*----- TItem.Destroy -----------------*
start: CRW 2004/04/04
last: CRW 2004/04/04

Cleans up TItem

*-------------------------------------*)
Destructor TItem.Destroy;
Begin
  inherited;

//	Data.Free;
	Data := NIL; {ChrstphrR - This is a reference to TItemDB not owned.}
End;(*- TItem.Destroy ---------------*)


(*-----------------------------------------------------------------------------*
Commonly used code to zero-out Items - used in Create, and whenever
Item needs to be wiped clean.

N.B - Data field is made NIL, which means calculations based on this need
to be done BEFORE you call ZeroItem
*-----------------------------------------------------------------------------*)
Procedure TItem.ZeroItem;
Begin
  //init fields
	ID       := 0;
	Equip    := 0;
	Identify := 0;
	Refine   := 0;
	Attr     := 0;
	Card[0]  := 0;
	Card[1]  := 0;
	Card[2]  := 0;
	Card[3]  := 0;
	Data     := NIL;
	Stolen   := 0;

	//init properties
	Amount   := 0;
End;(* Proc TItem.ZeroItem
*-----------------------------------------------------------------------------*)




{=======================}
{== End of TItem Code ==}
{=======================}


//==============================================================================
// コンストラクタ、デストラクタ
{追加}
constructor TMob.Create;
var
	Idx :integer;
begin
	inherited;

	for Idx := 1 to 10 do
		Item[Idx] := TItem.Create;
	isSummon := False;
	isLooting := False;
	LType := imaMob;
end;

destructor TMob.Destroy;
var
	i :integer;
begin
	for i := 1 to 10 do
		Item[i].Free;

	inherited;
end;

constructor TItemList.Create;
var
	i :integer;
begin
	inherited;
	for i := 1 to 100 do
		Item[i] := TItem.Create;
end;

destructor TItemList.Destroy;
var
	i :integer;
begin
	for i := 1 to 100 do
		Item[i].Free;
	inherited;
end;


(*-----------------------------------------------------------------------------*

Revisions:
2004/06/01 ChrstphrR - renamed internal variable, added LType

*-----------------------------------------------------------------------------*)
Constructor TChara.Create;
Var
	Idx : Integer;
Begin
	inherited;
	// Always call ancestor's routines first in Create

	for Idx := 0 to MAX_SKILL_NUMBER do
		Skill[Idx] := TSkill.Create;
	for Idx := 1 to 100 do
		Item[Idx] := TItem.Create;
	Cart := TItemList.Create;
	Flag := TStringList.Create;

	LType := imaChara;
End;(* TChara.Create
*-----------------------------------------------------------------------------*)


destructor TChara.Destroy;
var
	i :integer;
begin
	for i := 0 to MAX_SKILL_NUMBER do
		Skill[i].Free;
	for i := 1 to 100 do
		Item[i].Free;
	Cart.Free;
	Flag.Free;

	inherited;
end;

procedure TChara.SetFireWallCount( Value : Byte );
begin
if Value > 128 then
    fFireWallCount := 0;

    if Value >= 9 then
        fFireWallCount := 9
    else
        fFireWallCount := Value;
end;


{チャットルーム機能追加}
constructor TChatRoom.Create;
begin
	inherited;

	KickList := TIntList32.Create;
end;


destructor TChatRoom.Destroy;
begin
	KickList.Free;

	inherited;
end;
{チャットルーム機能追加ココまで}


constructor TPlayer.Create;
begin
	inherited;
	Kafra := TItemList.Create;
	Kafra.MaxWeight := 4000000000;
end;


(*-----------------------------------------------------------------------------*
ChrstphrR - 2004/04/24
TPlayer.Destroy

Properly clean up all it's owned items.
*-----------------------------------------------------------------------------*)
Destructor TPlayer.Destroy;
Begin
	//Owned item cleanup...
	Kafra.Free; //Defer to ItemList to clean itself up...

	{ChrstphrR - Referenced items don't affect memory leaks,
	code to NIL them out found to be unnecessary.}
	inherited;
End;(* TPlayer.Destroy
*-----------------------------------------------------------------------------*)


constructor TBlock.Create;
begin
	inherited;
	NPC := TIntList32.Create;
	CList := TIntList32.Create;
	Mob := TIntList32.Create;
end;

destructor TBlock.Destroy;
begin
	//ChrstphrR These are all reference lists
	NPC.Free;
	CList.Free;
	Mob.Free;

	inherited;
end;

constructor TMap.Create;
begin
	inherited;

	NPC := TIntList32.Create;
	NPCLabel := TStringList.Create;
	CList := TIntList32.Create;
	Mob := TIntList32.Create;
{NPCイベント追加}
	TimerAct := TIntList32.Create;
	TimerDef := TIntList32.Create;
{NPCイベント追加ココまで}
end;

destructor TMap.Destroy;
var
	Idx : Integer;
	Idy : Integer;
begin
	for Idx := NPC.Count-1 downto 0 do
		if Assigned(NPC.Objects[Idx]) then
			(NPC.Objects[Idx] AS TNPC).Free;
	NPC.Free;
	NPCLabel.Free;

	CList.Free; //ref list
	Mob.Free;   //ref list
{NPCイベント追加}

	for Idx := TimerAct.Count-1 downto 0 do begin
		if Assigned(TimerAct.Objects[Idx]) then begin
		for Idy := TimerDef.Count-1 downto 0 do
			if TimerDef.Objects[Idy] = TimerAct.Objects[Idx] then
				TimerDef.Delete(Idy); //Remove entry pointing to what we're about to free
			(TimerAct.Objects[Idx] AS NTimer).Free;
		end;
	end;
	TimerAct.Free;

	for Idx := TimerDef.Count-1 downto 0 do
		if Assigned(TimerDef.Objects[Idx]) then
			(TimerDef.Objects[Idx] AS NTimer).Free;
	TimerDef.Free;
{NPCイベント追加ココまで}

	//Block is a static array it's extents are an odd range, need to find out
	// if the "border" around the block needs freeing, or not.
	for Idx := BlockSize.X+3 downto -3 do
		for Idy := BlockSize.Y+3 downto -3 do
			if Assigned(Block[Idx][Idy]) then
				(Block[Idx][Idy] AS TBlock).Free;

	{ChrstphrR Trying another suggestion for freeing dyn arrays:
	- no change either way}
	gat := NIL;

	inherited;
end;

{ギルド機能追加ココまで}
constructor TGuild.Create;
var
	i :integer;
begin
	inherited;

	for i := 10000 to 10004 do
		GSkill[i] := TSkill.Create;
	GuildBanList := TStringList.Create;
	RelAlliance := TStringList.Create;
	RelHostility := TStringList.Create;
end;

destructor TGuild.Destroy;
var
	Idx : Integer;
begin
	for Idx := 10000 to 10004 do
		GSkill[Idx].Free;

	{ChrstphrR 2004/04/26 - these lists contain objects}
	for Idx := GuildBanList.Count-1 downto 0 do
		if Assigned(GuildBanList.Objects[Idx]) then
			(GuildBanList.Objects[Idx] AS TGBan).Free;
	GuildBanList.Free;

	for Idx := RelAlliance.Count-1 downto 0 do
		if Assigned(RelAlliance.Objects[Idx]) then
			(RelAlliance.Objects[Idx] AS TGRel).Free;
	RelAlliance.Free;
	for Idx := RelHostility.Count-1 downto 0 do
		if Assigned(RelHostility.Objects[Idx]) then
			(RelHostility.Objects[Idx] AS TGRel).Free;
	RelHostility.Free;

	inherited;
end;
{ギルド機能追加ココまで}
//==============================================================================

(*-----------------------------------------------------------------------------*
ChrstphrR 2004/04/24

Will fold in owned object creation into the constructor, is a placeholder right
now.

2004/06/01 ChrstphrR - added LType.
*-----------------------------------------------------------------------------*)
Constructor TNPC.Create;
Begin
	inherited;
	// Always call ancestor's routines first in Create

	LType := imaNPC;
End;(* TNPC.Create
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*

*-----------------------------------------------------------------------------*)
Destructor TNPC.Destroy;
Var
	Idx : Integer;
Begin
	// Always call ancestor's routines after you clean up
	// objects you created as part of this class

	case CType of
	NPC_TYPE_SHOP   :
		begin
			for Idx := Low(ShopItem) to High(ShopItem) do
				if Assigned(ShopItem[Idx]) then
					ShopItem[Idx].Free;
			SetLength(ShopItem, 0);
		end;
	NPC_TYPE_SCRIPT :
		begin
			{ChrstphrR 2004/04/26 Okay, Script is a dyn array of rScript - which
			contains dyn arrays of string/int, so cleanup involves setting the
			arrays to zero size -- unallocating them.}
			for Idx := High(Script) downto Low(Script) do begin
				SetLength(Script[Idx].Data1, 0);
				SetLength(Script[Idx].Data2, 0);
				SetLength(Script[Idx].Data3, 0);
			end;
			//Set the memory / length of the Script array to zero.
			SetLength(Script,0);
		end;
	NPC_TYPE_ITEM   :
		begin
			Item.Free;
		end;
	end;//case

	inherited;
End;(* TNPC.Destroy
*-----------------------------------------------------------------------------*)



(*-----------------------------------------------------------------------------*
Placeholder..
*-----------------------------------------------------------------------------*)
Constructor NTimer.Create;
Begin
	inherited;
	// Always call ancestor's routines first in Create


End;(* NTimer.Create
*-----------------------------------------------------------------------------*)

(*-----------------------------------------------------------------------------*

*-----------------------------------------------------------------------------*)
Destructor NTimer.Destroy;
Begin
	// Always call ancestor's routines after you clean up
	// objects you created as part of this class
	{
	SetLength(Idx,0);
	SetLength(Step,0)
	SetLength(Done,0)
	}

	inherited;
End;(* NTimer.Destroy
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*

*-----------------------------------------------------------------------------*)
Constructor TPet.Create;
Begin
	inherited;
	// Always call ancestor's routines first in Create

	//CR will create items here, later.
End;(* TPet.Create
*-----------------------------------------------------------------------------*)

(*-----------------------------------------------------------------------------*

*-----------------------------------------------------------------------------*)
Destructor TPet.Destroy;
Var
	Idx : Integer;
Begin
	// Always call ancestor's routines after you clean up
	// objects you created as part of this class
	for Idx := Low(Item) to High(Item) do
		if Assigned(Item[Idx]) then
			Item[Idx].Free;

	inherited;
End;(* TPet.Destroy
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*
TParty.GetName

Pre:
	Text storage - reads internal storage for name.
	SQL storage - queries DB for name. (Database link assumed connected)
Post:
	Returns a valid name
*-----------------------------------------------------------------------------*)
Function  TParty.GetName : string;
Begin
	{if UseSQL then begin
		//Query database for this party's name.
	end else begin}
		Result := fName;
	{end;//if-else UseSQL}
End;(* Func TParty.GetName
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*
TParty.SetName()

Pre:
	Assumed that Value is a unique name in PartyNameList
	(not checked for by this routine!)
Post:
	Writes name to object
*-----------------------------------------------------------------------------*)
Procedure TParty.SetName(
		Value : string
	);
Begin
	{if UseSQL then begin
		//Update Database
	end else begin}
		fName := Value;
	{end;//if-else UseSQL}
End;(* Proc TParty.SetName()
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*
SendMOTD()

Sends an MOTD (Message of the Day) to a newly joined user.
Fills requirements for Feature Request #445 on the bugtracker.

N.B. - To prevent massive floods of data, this routine will only send
a maximum of 4 lines, each of max-length 195 bytes, unless the
Option_MOTD_Athena flag is true -- in that case only one line is sent.

N.B. - Trickiness - a Broadcast packet won't send more than one message
unless the packet length is a fixed 200 bytes in size, AND the string
MUST be null-terminated. 4b header + 195b string + 1b null = 200 max size.

CalledBy:
	sv3PacketProcess ( in the 0072 branch of the cmd case statement )

Pre:
	NewChara must be a valid, non-nil Character
	Option_MOTD already checked and is True
	Option_MOTD_File exists.

Post:
	Server sends the lines from the MOTD file to the newly joined user.
	If Option_MOTD_Athen is true, a self-message is sent as the MOTD - 1 line
	if false, up to 4 lines are sent as an announcement to that new player.

Revisions:
2004/05/27 - Incorperated the Athena MOTD option. [ChrstphrR]
*-----------------------------------------------------------------------------*)
Procedure SendMOTD(
		NewChara : TChara
	);
Var
	MOTD : TStringList;
	Idx  : Integer;
	J    : Integer;
	Len  : Integer;
Begin
	//Double check preconditions with asserts...
	Assert(NewChara <> NIL,'SendMOTD Error: NewChara is NIL.');
	//--
	MOTD := TStringList.Create;
	try
		try
			MOTD.LoadFromFile( AppPath + Option_MOTD_File );
		except
			on EFOpenError do begin
				//Okay, someone's writing to the file,
				//or they've locked it and we can't read it...
				//So.. we'll embarass them  :D
				MOTD.Clear;
				MOTD.Add('Message of the Day:');
				MOTD.Add('The MOTD file is not accessible, or the admin has fallen asleep while before saving the file.');
				MOTD.Add('blue(My theory is the admin has run off with one of the Prontera Kafra employee to Tahiti... *AGAIN*) /gg');
				MOTD.Add('Contact the server admin, that is, if you can reach him or her in the first place! /pif');
				//ChrstphrR - I guess we can consider this an "Easter egg".
			end;
		end;//try-except

		if MOTD.Count > 0 then begin
			Idx := MOTD.Count;
			if Idx > 4 then
				Idx := 4;
			J := 0;
			WFIFOS(4, '', 200);//pre-wipe the buffer used for 200 bytes.

			if Option_MOTD_Athena then begin
				// Athena style MOTD - self-message floating over user's head
				MOTD[J] := '<MOTD> ' + MOTD[J];
				Len := Length(MOTD[J]);
				if Len > 195 then
					MOTD[J] := Copy(MOTD[J],1,195);

				WFIFOW(0, $008e);
				WFIFOW(2, Len+5);
				WFIFOS(4, MOTD[J], Len+1);//Len+1 -> adds null termination
				NewChara.Socket.SendBuf(buf, Len+5);
			end else begin
				// Broadcast style MOTD - 4 lines max, 195 char each
				repeat
					Len := Length(MOTD[J]);
					if Len > 195 then
						MOTD[J] := Copy(MOTD[J],1,195);

					WFIFOW(0, $009a);
					WFIFOS(4, MOTD[J], Len+1);//Len+1 -> adds null termination
					Inc(J);
					NewChara.Socket.SendBuf(buf, 200);
				until (J >= Idx);
			end;//if O_MOTD_A
		end;//if
	finally
		MOTD.Free;
	end;

End;(* Proc SendMOTD()
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*
TPet.GetFullness

Pre:
	None.
Post:
	Returns Fullness (a percentage between 0..100) in a 1-byte unsigned integer.
*-----------------------------------------------------------------------------*)
Function  TPet.GetFullness : Byte;
Begin
	Result := fFullness;
End;(* Func TPet.GetFullness
*-----------------------------------------------------------------------------*)



(*-----------------------------------------------------------------------------*
TPet.SetFullness()

Pre:
	Value passed must be between 0 and 100
	Value must be different from stored Fullness
Post:
	Value will be chopped to fit the range 0..100 if it exceeds it, and,
	Value will be put into Fullness if it's not already the same.

*-----------------------------------------------------------------------------*)
Procedure TPet.SetFullness(
		Value : Byte
	);
Begin
	if (Value >= 0) AND (Value <= 100) AND (Value <> fFullness) then begin
		fFullness := Value;
	end;
End;(* Proc TPet.SetFullness()
*-----------------------------------------------------------------------------*)




end.

