unit Common;



interface

uses
//Windows, Forms, Classes, SysUtils, ScktComp;
	Windows, StdCtrls, MMSystem, Classes, SysUtils, ScktComp, List32;

const
  // Colus, 20040304: Let's see if this is truly global scope.
  MAX_SKILL_NUMBER = 400;
  MAX_JOB_NUMBER = 45;
  LOWER_JOB_END = 23;
  UPPER_JOB_BEGIN = 4000;

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
	cost    :word;
	path    :array[0..255] of byte;
	pcnt    :byte;
	addr    :byte;
end;
//------------------------------------------------------------------------------
// アイテムデータベース
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
	SFixPer1   :array[0..5] of Word; // Option 1 mod
	SFixPer2   :array[0..4] of Word; // Option 2 mod
	DrainFix   :array[0..1] of Word; // Drain amount
	DrainPer   :array[0..1] of Word; // Drain chance
	AddSkill   :array[0..MAX_SKILL_NUMBER] of Word; // Skill addition
	SplashAttack  :boolean;          // Splash attack
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

{変更ココまで}
end;
//------------------------------------------------------------------------------
// アイテムデータ
type TItem = class
	ID        :word;
	Amount    :word;
	Equip     :word;
	Identify  :byte;
	Refine    :byte;
	Attr      :byte;
	Card      :array[0..3] of word;
	Data      :TItemDB;
        Stolen    :cardinal;
end;
//------------------------------------------------------------------------------
{追加}
type TItemList = class
	Zeny      :Cardinal;
	Item      :Array[0..100] of TItem;
	Weight    :Cardinal;
	MaxWeight :Cardinal;
	Count     :Word;

	constructor Create;
	destructor Destroy; override;
end;
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
	ID    :word;
	Per   :cardinal;
	Data  :TItemDB;
  Stolen:cardinal;
end;
//------------------------------------------------------------------------------
type TPharmacyDB = class
//ID,BookNeededID,Material1ID,Material2ID,Material3ID,Material4ID,Material5ID,Material1Amount,Material2Amount,Material3Amount,Material4Amount,Material5Amount
        ID              :cardinal;
        BookNeededID    :integer;
        MaterialID      :array [1..5] of integer;
        MaterialAmount  :array [1..5] of byte;
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
        ID              :cardinal;
        Skill           :array[0..7] of integer;
        SkillLv         :array[0..7] of integer;
        PercentChance   :array[0..7] of integer;
        //SkillType       :array[0..3] of integer;
end;
//------------------------------------------------------------------------------
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
        LUK            :byte; //クリ補正用LUK
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
{追加ココまで}
end;
//------------------------------------------------------------------------------
// MNAME,SLAVE_1,SLAVE_2,SLAVE_3,SLAVE_4,SLAVE_5,TOTALNUMSLAVES
type TSlaveDB = class
  Name        :string;
  Slaves      :array[0..4] of integer;
  TotalSlaves :integer;
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
type TMArrowDB = class
  ID        :integer;
  CID       :array[0..2] of integer;
  CNum      :array[0..2] of integer;
end;
//------------------------------------------------------------------------------
// 経験値配分用カウンタ
type rEXPDist = record
	CData       :Pointer;
	Dmg         :integer;
end;
//------------------------------------------------------------------------------
// モンスターデータ
type TMob = class
	ID          :cardinal;
	Name        :string;
	JID         :word;
	Map         :string;
	Point       :TPoint;
	tgtPoint    :TPoint;
  NextPoint   :TPoint;
	Dir         :byte;
	Point1      :TPoint;
	Point2      :TPoint;
	Speed       :word;
	Stat1       :Byte; // 1 = Stone, 2 = Freeze, 3 = Stun, 4 = Sleep, 5 = ankle snar
	Stat2       :Byte; // 1 = Poison, 2 = Curse, 4 = Silence, 8 = Chaos, 16 = Blind
  nStat       :Cardinal;
	BodyTick    :Cardinal;   // Status change tick1 (for Stat1)
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
        DeadWait    :cardinal;                  // mf
	DmgTick     :cardinal; //ノックバック
	ppos        :integer;
	pcnt        :integer;
	path        :array[0..999] of byte; //キャラの経路(向きで記録されてます)
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

        Hidden     :boolean;

        AnkleSnareTick :cardinal;  //Tracks how long ankle snare lasts

        MPoint        :rPoint;
	MTick         :cardinal;

        NowSkill        :integer;
        NowSkillLv      :integer;
        SkillSlot       :integer;
        AI              :Pointer;
        Mode           :integer;
        Burned          :boolean;

{NPCイベント追加ココまで}
	constructor Create;
	destructor Destroy; override;
{追加ココまで}
end;
//------------------------------------------------------------------------------
{キューペット}
// ペットデータベース
type TPetDB = class
	MobID           :word; // ペットモンスターのID
	ItemID          :word; // 捕獲アイテムのID
	EggID           :word; // 卵のアイテムID
	AcceID          :word; // アクセサリのアイテムID
	FoodID          :word; // エサのアイテムID
	Fullness        :word; // 餌やりによる満腹度上昇
	HungryDelay     :word; // 満腹度減少時間(msec/-1)
	Hungry          :word; // 空腹時餌やりによる親密度上昇
	Full            :word; // 満腹時餌やりによる親密度減少
	Reserved        :word; // ??? 時の親密度上昇
	Die             :word; // 死亡時親密度減少
	Capture         :word; // 基本捕獲率(0.1%単位)
  SkillTime       :cardinal;  //Tracks how long a skill lasts
end;

// ペットデータ
type TPet = class
        PlayerID        :cardinal;
        CharaID         :cardinal;
        Cart            :byte;
        Index           :word;
        Incubated       :byte;
        PetID           :cardinal;
        JID             :word;
        Name            :string;
        Renamed         :byte;
        LV              :word;
				Relation        :integer;
        Fullness        :integer;
        Accessory       :word;
        Data            :TPetDB;
		    isLooting       :boolean;  //Tracks if the pet is looting
        ATarget         :cardinal;  //Pets attacking target as well as looting
        Item            :array[1..25] of TItem;  //Items a pet is holding
        MobData         :Pointer;
        SkillTick       :cardinal;  //Tracks when to use a skill
        SkillActivate   :boolean;  //Tracks if the skill is ready to be activated
        LastTick        :cardinal;  //Used for tracking a minute
        Saved           :byte;
end;
{キューペットここまで}
//------------------------------------------------------------------------------
// スキルデータベース
//N,ID,JName,Type,MLV,SP1,2,3,4,5,6,7,8,9,10,HP,Cast,Lv+,AR,Ele,
//Dat1,2,3,4,5,6,7,8,9,10,Dat2,2,3,4,5,6,7,8,9,10,Req1,LV,Req2,LV,Req3,LV
type TSkillDB = class
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
end;
//------------------------------------------------------------------------------
// スキルデータ
type TSkill = class
	Lv          :word;
	Card        :boolean;
        Plag        :boolean;
	//Up        :byte;
	Tick        :cardinal; //時間制限有りのスキルのリミット
	EffectLV    :word;     //時間制限有りのスキルの効果LV
	Effect1     :integer;  //時間制限有りのスキルの効果データ1
	Data        :TSkillDB;
end;
//------------------------------------------------------------------------------
type TeNPC = class
	ID            :Cardinal;  //ID
	JID           :Word;      //(Chara)ジョブ (Mob)スプライト
	CID           :Cardinal;
	Name          :string;    //名前
	Sit           :Byte;
	Data          :Pointer;
	Data2         :Pointer;

	ASpeed        :Word;
	ADelay        :Word;
	aMotion       :Word;
	dMotion       :Word;
	Speed         :Word;      //移動速度[msec/1マス]

	Item          :TItemList;

	Stat1         :Word;      //状態変化1
	Stat2         :Word;      //状態変化2
	Option        :Word;      //オプション(カート、ぺこ、鷹など)
	BodyTick      :Cardinal;                //状態変化1Tick
	HealthTick    :Array[0..4] of Cardinal;  //状態変化2Tick
	Effect        :Array[0..11] of Cardinal; //状態変化3Tick
	HPDelay       :Array[0..3] of Cardinal;
	SPDelay       :Array[0..3] of Cardinal;
	HPTick        :Cardinal;
	SPTick        :Cardinal;
	HPRTick       :Cardinal;
	SPRTick       :Cardinal;

	Hair          :Word;      //(Chara)髪型
	Weapon        :Word;      //(Chara)武器の見た目
	Shield        :Word;      //(Chara)盾の見た目
	Head1         :Word;      //(Chara)頭装備-上段の見た目
	Head2         :Word;      //(Chara)頭装備-中段の見た目
	Head3         :Word;      //(Chara)頭装備-下段の見た目
	HairColor     :Word;      //(Chara)髪の色
	ClothesColor  :Word;      //(Chara)服の色
	HeadDir       :Word;      //(Chara)頭の向き
	GuildID       :Word;      //(Chara)所属ギルドのID
	__0           :Word;      //不明1
	__1           :Word;      //不明2
	Manner        :Word;      //(Chara)マナーポイント
	Karma         :Word;      //(Chara)カルマポイント
	__2           :Byte;      //不明3
	Gender        :Byte;      //(Chara)性別

	Map           :string;    //今居るマップ
	Point         :TPoint;    //今居る座標(左下が(0,0))
	Dir           :Byte;      //向き
	MData         :Pointer;
	tmpMap        :string;
	NextFlag      :boolean;
	NextPoint     :TPoint;

	tgtPoint      :TPoint;    //移動目標座標
	ppos          :Integer;   //pathをどれだけ進んだか
	pcnt          :Integer;   //pathの経路長
	path          :Array[0..255] of byte; //キャラの経路(向きで記録されてます)
	MoveTick      :Cardinal;  //最後に1マス進んだときのTick

	BaseLV        :Word;
	JobLV         :Word;
	BaseEXP       :Cardinal;
	JobEXP        :Cardinal;
	HP            :Integer;   //HP
	MAXHP         :Word;      //最大HP
	SP            :Integer;   //SP
	MAXSP         :Word;      //最大SP
	Param         :Array[0..5] of Byte;
	WeaponType    :Array[0..1] of Word; //右手左手それぞれの武器のタイプ
	WeaponLv      :Array[0..1] of Word; //それぞれの武器レベル
	ArmsFix       :Array[0..1] of Word; //右手左手修練
	BaseATK       :Word;
	ATK           :Array[0..1] of Word;
	RefineATK     :Array[0..1] of Word;
	SkillATK      :Word;

	Scale         :Byte;
	Race          :Byte;
	Element       :Byte;

	ATarget       :Cardinal;  //攻撃対象のID
	AData         :Pointer;   //(Chara)攻撃対象のTMob (Mob)攻撃対象のTChara
	ATick         :Cardinal;  //最後に攻撃したときのTick
	AMode         :Byte;
	DmgTick       :Cardinal;  //ノックバックが解除されるときのTick

	MMode         :Byte;
	MSkill        :Word;
	MUseLV        :Word;
	MTarget       :Cardinal;
	MTargetType   :Byte; //ADataの種類。0=to Mob, 1=to Player
	MPoint        :rPoint;
	MTick         :Cardinal;
	ESkill        :Array[0..100] of Word;
	ESkillLv      :Array[0..100] of Word;

	DmgFixR       :Array[0..1] of Array[0..9] of Integer; //種族補正% 0:攻撃 1:防御
	DmgFixE       :Array[0..1] of Array[0..9] of Integer; //属性補正% 0:攻撃 1:防御
	DmgFixS       :Array[0..1] of Array[0..2] of Integer; //サイズ補正%
	StatePerS1    :Array[0..1] of Array[0..4] of Integer; //変化確率%
	StatePerS2    :Array[0..1] of Array[0..4] of Integer;
	DrainFix      :array[0..1] of Integer; //吸収量	 0:HP 1:SP
	DrainPer      :array[0..1] of Integer; //吸収確率 0:HP 1:SP
	DAPer         :Integer; //DA発動確率
	DAFix         :Integer; //DA発動時の2発合計攻撃力%
	Arrow         :Word; //装備中の矢のID

	MATK          :Integer;
	DEF1          :integer; //防御力%
	DEF3          :Integer; //ディヴァインプロテクション
	MDEF2         :Integer;
	HIT           :Integer;
	FLEE          :Integer;
	Critical      :Word;
	Lucky         :Word;

	Range         :Word;
	ViewRange     :Word;
	WElement      :Array[0..1] of byte; //武器属性

	ATKSplash	    :Boolean; //9マス攻撃

end;
//------------------------------------------------------------------------------
// Character Data
type TChara = class
	// Control Variables
	ID	          :cardinal;
	Socket        :TCustomWinSocket;
	PData         :Pointer;
	IP            :string;
	Login         :byte; // 0 = offline; 1 = loading; 2 = online

	// Data saved and loaded to/from chara.txt
	// Line 1:
	CID	          :cardinal;
	Name          :string;
	Gender        :byte;

	JID           :Word;
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
  // 256: Cart 3      512: Cart 4       1024: Cart 5
  // 8192: Ruwach

  //  0000 | 0000 | 0000 | 0000
  //    R     CCC   CPPF   CCHS
  //    w     543   2Hel   1lig
  //    c            dcc    kdt
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

	Map           :string;
	Point         :TPoint;
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
	EquipJob			:Int64;
	BaseNextEXP   :cardinal;
	JobNextEXP    :cardinal;
	Weight        :cardinal;
	MaxWeight     :cardinal;
	Bonus         :array[0..5] of word;
	Param         :array[0..5] of word;
	ParamUp       :array[0..5] of word;
	WeaponType    :array[0..1] of word; // Right(0), left(1) hand weapon types
  WeaponSprite  :array[0..1] of word; // Item IDs for wpn sprites. 0=rt., 1=lt.
{追加}
	WeaponLv      :array[0..1] of word; // Weapon levels for right/left
{追加ココまで}
	ArmsFix       :array[0..1] of word; // Right/left training (mastery?)
	ATK           :array[0..1] of array[0..5] of word; // Displayed ATK power
	ATKFix        :array[0..1] of array[0..2] of integer; // Weapon correction based on enemy size
{変更}
	AttPower      :Word; // Attack power additions from cards, etc.
	DamageFixR    :array[0..1] of array[0..9] of Integer; //Race correction %: 0=weapon, 1=armor
	DamageFixE    :array[0..1] of array[0..9] of Integer; //Element correction %: 0=weapon, 1=armor
	DamageFixS    :array[0..2] of Integer;                //Size correction %: 0=S, 1=M, 2=L
{変更ココまで}
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
	HPR           :word; //HP回復スキルの回復値
	SPR           :word; //SP回復スキルの回復値
{変更}
	DrainFix      :array[0..1] of Integer; //吸収量   0:HP 1:SP
	DrainPer      :array[0..1] of Integer; //吸収確率 0:HP 1:SP
	SplashAttack  :boolean;                //9マス攻撃
        WeaponSkill   :integer;
        WeaponSkillLv :integer;
        WeaponID      :integer;
	NoJamstone    :boolean;
        NoTrap        :boolean;
        LessSP        :boolean;
        FastWalk      :boolean;
        NoTarget      :boolean;
        FullRecover   :boolean;
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
        PerfectHide   :boolean;

        {Sage Effects}
        SageElementEffect   :boolean;

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

	MData         :Pointer;
	ppos          :integer;
	pcnt          :integer;
	path          :array[0..999] of byte; //キャラの経路(向きで記録されてます)
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

	Dir           :byte;
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
        PetData       :Pointer;
        PetNPC        :Pointer;
		PetMoveTick   :cardinal;
        Crusader      :Pointer;
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

        //SkillOnBool         :Boolean; //boolean indicate skill duration for skills according to system time.

	constructor Create;
	destructor  Destroy; override;
  //procedures to get skilonbool and set skillonbool
  //procedure setSkillOnBool(temp:Boolean);
  //function getSkillOnBool:Boolean;
end;
//------------------------------------------------------------------------------
// プレイヤーデータ
type TPlayer = class
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
	CData         :array[0..8] of TChara;
	Kafra         :TItemList;

	LoginID1      :cardinal;
	LoginID2      :cardinal;
	ver2          :word;
  Saved         :byte;

	constructor Create;
	destructor  Destroy; override;
end;
//------------------------------------------------------------------------------
{パーティー機能追加}
// パーティーデータ
type TParty = class
	Name      :string;//パーティーの名前
	MinLV     :word;//パーティー内最低レベル
	MaxLV     :word;//パーティー内最大レベル
	EXPShare  :word;//パーティー経験値設定(0がバラバラで1が公平)
	ITEMShare :word;//パーティーアイテム設定(0がバラバラで1が共有？未実装要素)
	MemberID  :array[0..11] of cardinal;//メンバーのID
	Member    :array[0..11] of TChara;//メンバー
	EXP       :Cardinal; //経験値分配用
	JEXP      :Cardinal; //経験値分配用
        PartyBard :array[0..2] of TChara; {Tracks Who the Party's Bard is}
        PartyDancer :array[0..2] of TChara; {Tracks Who the Party's Dancer is}
end;
{パーティー機能追加ココまで}
//------------------------------------------------------------------------------
type TCastle = class
	Name    :string;
  GID     :word;
  GName   :string;
  GMName  :string;
  GKafra  :integer;
  EDegree :cardinal;
  ETrigger:integer;
  DDegree :cardinal;
  DTrigger:integer;
  GuardStatus:array [0..7] of integer;
end;
//------------------------------------------------------------------------------
type TEmp = class
	Map    :string;
  EID    :cardinal;
end;
//------------------------------------------------------------------------------
// 店売りアイテム
type TShopItem = class
	ID    :word;
	Price :cardinal;
	Data  :TItemDB;
end;
//------------------------------------------------------------------------------
// NPCスクリプト
type rScript = record
	ID      :word; //コマンドID
	Data1   :array of string;
	Data2   :array of string;
	Data3   :array of integer;
	DataCnt :cardinal;
end;
//------------------------------------------------------------------------------
// NPCデータ
type TNPC = class
	ID          :cardinal;
	Name        :string;
{NPCイベント追加}
//	JID         :word;
	JID         :integer;
{NPCイベント追加ココまで}
	Map         :string;
  Reg         :string;
	Point       :TPoint;
	Dir         :byte;
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
	Item        :TItem;
	SubX        :byte;
	SubY        :byte;
	Tick        :cardinal;
	//skill
	Count       :word;
	CData       :TChara;
        MData       :TMob;
{追加}
	MSkill      :Word;
{追加ココまで}
	MUseLV      :word;
{キューペット}
        //pet
        HungryTick  :cardinal;
        NextPoint   :TPoint;
        MoveTick    :cardinal;
        ppos        :integer;
	pcnt        :integer;
        path        :array[0..999] of byte; //キャラの経路(向きで記録されてます)

        //AnkleTick   :cardinal;  //How long ankle snare lasts.
{キューペットここまで}
end;
//------------------------------------------------------------------------------
{NPCイベント追加}
// タイマーデータ
type NTimer = class
	ID        :cardinal;//タイマーID
	Tick      :cardinal;//タイマー
	Cnt       :word;//タイマーインデックス数
	Idx       :array of integer;//インデックス
	Step      :array of integer;//分岐先
	Done      :array of byte;//実行済みフラグ
end;
//マップ設定データ
type MapTbl = class
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

end;
{NPCイベント追加ココまで}
//------------------------------------------------------------------------------
// マップブロックデータ
type TBlock = class
	NPC         :TIntList32;
	Mob         :TIntList32;
	CList       :TIntList32;
	//MobProcess  :boolean;
	MobProcTick :cardinal;

	constructor Create;
	destructor Destroy; override;
end;
//------------------------------------------------------------------------------
// マップデータ
type TMap = class
	Name      :string;
	Size      :TPoint;
	gat       :array of array of byte; //bit1=移動可能 bit2=水たまり bit3=Warp
	BlockSize :TPoint;
	Block     :array[-3..67] of array[-3..67] of TBlock; // 512/8=64 0-3~(64-1)+3
	NPC       :TIntList32;
	NPCLabel	:TStringList;
	CList     :TIntList32;
	Mob       :TIntList32;
	Mode      :byte; //0=未ロード 1=ロード中 2=ロード済み
{NPCイベント追加}
	TimerAct  :TIntList32; //動作中タイマー
	TimerDef  :TIntList32; //定義済タイマー
{NPCイベント追加ココまで}

	constructor Create;
	destructor Destroy; override;
end;
//------------------------------------------------------------------------------
// マップリストデータ
type TMapList = class
	Name      :string;
        Ext       :string;
	Size      :TPoint;
	Mode      :byte; //0=未ロード 1=ロード中 2=ロード済み
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
{氏{箱追加}
type TSummon = class
	Name      :string;
end;
{氏{箱追加ココまで}
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
end;
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
	CodeVersion = 'Fusion-Weiss 1.2.0.9';
	PacketLength:array[0..$200] of integer = (
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
    0,  8,  0,  0,  0,  0,  0,  0,  28,  0,  0,  0,  0,  0,  0,  0, // 0x01e0
    0,  0,  0,  0,  7,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0, // 0x01f0

// Previous packet lengths
//		3, 28, 19, 11,  3, -1,  9,  5,  52, 51, 56, 58, 41,  2,  6,  6, // 0x0070
//		0,  0, -1,  0,  0,  0,114,  0,   0,  0,  0,  0,  0,  0,  0,  0, // 0x01b0
//		0,  0,  0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0, // 0x01c0
//		0,  0,  0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0, // 0x01d0
//		0,  0,  0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0, // 0x01e0
//		0,  0,  0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0, // 0x01f0
		0);
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
{氏{箱追加}
	SummonMobList :TIntList32;
	SummonIOBList :TIntList32;
	SummonIOVList :TIntList32;
	SummonICAList :TIntList32;
	SummonIGBList :TIntList32;
{氏{箱追加ココまで}
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
        PharmacyDB :TIntList32;
  SlaveDBName:TStringList;
  MArrowDB   :TIntList32;
  IDTableDB  :TIntList32;
	SkillDB    :TIntList32;
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

	mm              :array[0..30] of array[0..30] of rSearchMap;

	buf             :array[0..32767] of byte;
  buf2            :array[0..32767] of byte;
	stra            :array[0..32767] of char;
{オプション関連}
        //キャラクター初期データ関連

        GMCheck         :cardinal; // GMコマンドをGM以外も使えるか
        DebugCMD        :cardinal; // デバッグコマンドが使えるか
DeathBaseLoss     :integer;
DeathJobLoss      :integer;
MonsterMob        :boolean;
SummonMonsterExp  :boolean;
SummonMonsterAgo  :boolean;
SummonMonsterName :boolean;
SummonMonsterMob  :boolean;
GlobalGMsg        :string;
MapGMsg           :string;
{オプション関連ここまで}

// Fusion SQL Declarations
UseSQL            :Boolean;
DbHost            :String;
DbUser            :String;
DbPass            :String;
DbName            :String;
// Fusion SQL Declarations

// Fusion INI Declarations
Option_PVP        :boolean;
Option_MaxUsers   :word;
Option_AutoSave   :word;
Option_AutoBackup   :word;
Option_WelcomeMsg :boolean;
Option_GraceTime  :cardinal;
Option_GraceTime_PvPG :cardinal;
// Fusion INI Declarations


//------------------------------------------------------------------------------
// 関数定義
		procedure MapLoad(MapName:string);
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

		procedure SendItemSkill(tc:TChara; s:Cardinal; L:Cardinal = 1);
		procedure SendSkillError(tc:TChara; EType:byte; BType:word = 0);
                procedure SendItemError(tc:TChara; Code:Cardinal);
		function  UseFieldSkill(tc:TChara; Tick:Cardinal) : Integer;
		function  UseTargetSkill(tc:TChara; Tick:Cardinal) : Integer;

		procedure SendCSkillAtk1(tm:TMap; tc:TChara; ts:TMob; Tick:cardinal; dmg:Integer; k:byte; PType:byte = 0);
                procedure SendCSkillAtk2(tm:TMap; tc:TChara; tc1:TChara; Tick:cardinal; dmg:Integer; k:byte; PType:byte = 0);

		procedure CalcSkillTick(tm:TMap; tc:TChara; Tick:cardinal = 0);

                //procedure PassiveIcons(tm:TMap; tc:TChara);  //Calculate Passive Icons
                //procedure PoisonCharacter(tm:TMap; tc:TChara; Tick:cardinal);  //Poison or Un-poison a character
                //procedure BlindCharacter(tm:TMap; tc:TChara; Tick:Cardinal);
                procedure UpdateStatus(tm:TMap; tc:TChara; Tick:Cardinal);
                procedure UpdateOption(tm:TMap; tc:TChara);
                procedure UpdateIcon(tm:TMap; tc:TChara; icon:word; active:byte = 1);
                procedure SilenceCharacter(tm:TMap; tc:TChara; Tick:Cardinal);
                procedure IntimidateWarp(tm:TMap; tc:TChara);

                procedure UpdateMonsterDead(tm:TMap; ts:TMob; k:integer);   //Kills a monster
				procedure UpdatePetLocation(tm:TMap; tn:TNPC);  //Update the location of a pet
                procedure SendPetRelocation(tm:TMap; tc:TChara; i:integer); //Move a pet
                procedure UpdateMonsterLocation(tm:TMap; ts:TMob);  //Update the location of a monster
                procedure UpdatePlayerLocation(tm:TMap; tc:TChara);  //Update the location of a Player

                procedure  PetSkills(tc: TChara; Tick:cardinal);  //Calculate the Pets Skills

                procedure  Monkdelay(tm:TMap; tc:TChara; Delay:integer);

                function  UpdateSpiritSpheres(tm:TMap; tc:TChara; spiritSpheres:integer) :boolean;
		function  DecSP(tc:TChara; SkillID:word; LV:byte) :boolean;
                function  UseItem(tc:TChara; j:integer): boolean;
                function  UseUsableItem(tc:TChara; w:integer) :boolean;
                function  UpdateWeight(tc:TChara; j:integer; td:TItemDB)  :boolean;
                function  GetMVPItem(tc1:TChara; ts:TMob; mvpitem:boolean) :boolean;
                function  StealItem(tc:TChara; ts:TMob) :boolean;

		function  SearchCInventory(tc:TChara; ItemID:word; IEquip:boolean):word;
		function  SearchPInventory(tc:TChara; ItemID:word; IEquip:boolean):word;
//------------------------------------------------------------------------------
		//モンス・NPC
		procedure SendMData(Socket:TCustomWinSocket; ts:TMob; Use0079:boolean = false);
		procedure SendMMove(Socket: TCustomWinSocket; ts:TMob; before, after:TPoint; ver2:Word);
    procedure SendNData(Socket:TCustomWinSocket; tn:TNPC; ver2:Word; Use0079:boolean = false);
		procedure SendPMove(Socket: TCustomWinSocket; te:TeNPC; before, after:TPoint; ver2:Word);
{キューペット}
                procedure SendPetMove(Socket: TCustomWinSocket; tc:TChara; target:TPoint);
{キューペットここまで}
//------------------------------------------------------------------------------
    //地点スキル
		function  SetSkillUnit(tm:TMap; ID:cardinal; xy:TPoint; Tick:cardinal; SType:word; SCount:word; STime:cardinal; tc:TChara = nil; ts:TMob = nil; SText:string = ''):TNPC;
		procedure DelSkillUnit(tm:TMap; tn:TNPC);
//------------------------------------------------------------------------------
    //所持アイテム
		function  MoveItem(ti1:TItemList; ti2:TitemList; Index:Word; cnt:Word) : Integer;

		function  GetItemStore(ti:TItemList; td:TItem; cnt:Word; IsEquip:Boolean = False) : Integer;
		function  DeleteItem(ti:TItemList; index:Word; cnt:Word) : Integer;
		function  SearchInventory(ti:TItemList; ItemID:word; IEquip:boolean) : word;//SearchCInventory()等と使い方は同じ
		procedure CalcInventory(ti:TItemList);
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
//------------------------------------------------------------------------------
{アジト機能追加}
		procedure SetFlagValue(tc:TChara; str:string; svalue:string);
{アジト機能追加ココまで}
{ギルド機能追加ココまで}
//==============================================================================










implementation

uses SQLData, FusionSQL;

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
					WFIFOW( 0, $00b0);
					WFIFOW( 2, $0018);
					WFIFOL( 4, tc.Weight);
					Socket.SendBuf(buf, 8);
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
		for j:=0 to 4 do begin
			Inc(SFixPer1[0][j],td.SFixPer1[j]);
			Inc(SFixPer2[0][j],td.SFixPer2[j]);
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

		for j :=1 to MAX_SKILL_NUMBER do begin // Add card skills
			if td.AddSkill[j] <> 0 then begin
				if (not Skill[j].Data.Job1[JIDFix]) and (not Skill[j].Data.Job2[JIDFix]) and (not DisableSkillLimit) then begin
					Skill[j].Lv := td.AddSkill[j];
					Skill[j].Card := True;
				end;
			end;
		end; //for j :=1 to 336 do begin

		if td.Cast <> 0 then MCastTimeFix := MCastTimeFix * td.Cast div 100; // Cast time corrections
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
	Side    :byte;
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
					CalcAbility(tc, Item[i].Data, o);
{アイテム製造修正}
					for k := 0 to Item[i].Data.Slot - 1 do begin //カード補正1
						//製造武器の関係でカードスロットにDBにない数字が入るため(4001-4149)の時だけカード処理するように修正
						if (Item[i].Card[k] <> 0) and (Item[i].Card[k] > 4000) and (Item[i].Card[k] < 4211) then begin
							CalcAbility(tc, (ItemDB.IndexOfObject(Item[i].Card[k]) as TItemDB), o);
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
	i,j :Integer;
begin
	with tc do begin
		//修練 ATK[0][4]
		if (Skill[2].Lv <> 0) and ((WeaponType[0] = 1) or (WeaponType[0] = 2)) then begin //短剣、剣
			ATK[0][4] := Skill[2].Data.Data1[Skill[2].Lv];
		end else if (Skill[3].Lv <> 0) and (WeaponType[0] = 3) then begin //両手剣
			ATK[0][4] := Skill[3].Data.Data1[Skill[3].Lv];
		end else if (Skill[55].Lv <> 0) and ((WeaponType[0] = 4) or (WeaponType[0] = 5)) then begin //槍
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
                if Skill[383].Tick > Tick then begin
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
			Bonus[0] := Bonus[0] + 5;
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
    DebugOut.Lines.Add(Format('Speed: %d', [Speed]));
                if ((tc.Option = 6) and (tc.Skill[213].Lv <> 0)) then begin
                        Speed := (Skill[213].Data.Data2[Skill[213].Lv] * Speed) div 100;
    DebugOut.Lines.Add(Format('Tunnel Speed: %d', [Speed]));
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
var
	i,j,k,o,p :integer;
	Side      :byte;
	td        :TItemDB;
        tl        :TSkillDB;
        mi        :MapTbl;
        g         :double;
  JIDFix    :word; // JID correction for upper classes.
begin
	if Tick = 0 then Tick := timeGetTime();
	with tc do begin
    JIDFix := tc.JID;
    if (JIDFix > UPPER_JOB_BEGIN) then JIDFix := JIDFix - UPPER_JOB_BEGIN + LOWER_JOB_END; // (RN 4001 - 4000 + 23 = 24
    //DebugOut.Lines.Add(Format('JIDFix %d tc.JID %d',[JIDFix, tc.JID]));
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
				Skill[i].Card := False;
			end;
			if SkillPoint > 714 then SkillPoint := 714; //これだけ有れば十分
		end;
		CalcEquip(tc);
    DEF2 := Param[2];
		CalcSkill(tc,Tick);
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
    if ((MAXHP + (35 + BaseLV * 5 + ((1 + BaseLV) * BaseLV div 2) * HPTable[JIDFix] div 100) * (100 + Param[2]) div 100) > 65535) then begin
        MAXHP := 65535;
    //end else if (JID = 23) and (MAXHP + (35 + BaseLV * 5 + ((1 + BaseLV) * BaseLV div 2) * 40 div 100) * (100 + Param[2]) div 100 > 65535) then begin
      //  MAXHP := 65535;
    end else begin

		tc.MAXHP := tc.MAXHP + (35 + tc.BaseLV * 5 + ((1 + tc.BaseLV) * tc.BaseLV div 2) * HPTable[JIDFix] div 100) * (100 + tc.Param[2]) div 100;
           //     if tc.JID = 23 then tc.MAXHP := tc.MAXHP + (35 + tc.BaseLV * 5 + ((1 + tc.BaseLV) * tc.BaseLV div 2) * 40 div 100) * (100 + tc.Param[2]) div 100;

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
       tl := Skill[360].Data;
    if (MAXHP + tc.Skill[360].Data.Data2[tc.Skill[360].Lv] > 65535) then begin
      MAXHP := 65535;
    end else begin
        MAXHP := MAXHP + tc.Skill[360].Data.Data2[tc.Skill[360].Lv];
    end;
    end;

		MAXSP := MAXSP + BaseLV * SPTable[JIDFix] * (100 + Param[3]) div 100;
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
                 //       if (JID = 23) then ADelay := 20*WeaponASPDTable[0][WeaponType[1]];
		end else if WeaponType[0] = 0 then begin
			ADelay := 20*WeaponASPDTable[JIDFix][WeaponType[1]];
                   //     if (JID = 23) then ADelay := 20*WeaponASPDTable[0][WeaponType[1]];
		end else begin //二刀流
			ADelay := 14*(WeaponASPDTable[JIDFix][WeaponType[0]] + WeaponASPDTable[JIDFix][WeaponType[1]]);
                     //   if (JID = 23) then ADelay := 14*(WeaponASPDTable[0][WeaponType[0]] + WeaponASPDTable[0][WeaponType[1]]);
		end;
		i := ( ( ADelay * Param[1] div 500 ) * 2 + ADelay * Param[4] div 1000 );
		if ADelay < i then ADelay := 200
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
{Editted By AppleGirl}  if (Skill[258].Tick > Tick) and ((tc.Weapon = 4) or (tc.Weapon = 5)) then ADelay := ADelay * 70 div 100; //ツーハンドクイックン
                        if Skill[268].Tick > Tick then ADelay := ADelay * 2;    {Steel Body}
                        if Skill[291].Tick > Tick then ADelay := ADelay * tc.Skill[291].Effect1 div 100;  {Attack Speed Potions}
                        if Skill[320].Tick > Tick then ADelay := ADelay * tc.Skill[291].Effect1 div 100;
                        if tc.DoppelgagnerASPD then ADelay := ADelay * 70 div 100;  {Doppelgagner Card}
                        if tc.LVL4WeaponASPD then ADelay := ADelay * 75 div 100;     {Level 4 kro new weapon aspd haste effect}
			if ADelay < 200 then ADelay := 200;
		end;
		ASpeed := ADelay div 2;

                if (Skill[60].Tick > Tick) and (tc.Weapon <> 3) then begin
                    Skill[60].Tick := Tick;
                    SkillTick := Tick;
                end;

                
                if (Skill[360].Tick > Tick) and (tc.Weapon <> 3) then begin
                    Skill[360].Tick := Tick;
                    SkillTick := Tick;
                end;

                if (Skill[359].Tick > Tick) and (tc.Weapon <> (4 or 5)) then begin
                    Skill[359].Tick := Tick;
                    SkillTick := Tick;
                end;


                if (Skill[111].Tick > Tick) and (tc.Weapon <> (6 or 7)) then begin
                    Skill[111].Tick := Tick;
                    SkillTick := Tick;
                end;

                if (Skill[258].Tick > Tick) and (tc.Weapon <> (4 or 5)) then begin
                    Skill[258].Tick := Tick;
                    SkillTick := Tick;
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
		//DebugOut.Lines.Add(Format('WElement: %d/%d', [WElement[0], WElement[1]]));
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

                for i := 0 to 1 do
                        for j := 0 to 5 do
                                ATK[i][j] := 0;
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
                //DebugOut.Lines.Add('(ﾟ∀ﾟ)?');
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
                //DebugOut.Lines.Add('(ﾟ∀ﾟ)?');
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
                //DebugOut.Lines.Add('(ﾟ∀ﾟ)?');
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
        //DebugOut.Lines.Add('(ﾟ∀ﾟ)?');
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
                        ts.Point.X := tc.Point.X;
                        ts.Point.Y := tc.Point.Y;
                        if ts.HP > 0 then SendMmove(tc.Socket, ts, ts.Point, tc.Point, tc.ver2);
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
  tn.CType := 2;
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
procedure  PetSkills(tc: TChara; Tick:cardinal);
var
  tn:TNPC;
  tpe:TPet;
  tm:TMap;
begin
  tm := tc.MData;
  tn := tc.PetNPC;
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
        tc.Bonus[0] := tc.Bonus[5] + 1;
        tc.Bonus[1] := tc.Bonus[5] + 1;
        tc.Bonus[2] := tc.Bonus[5] + 1;
        tc.Bonus[3] := tc.Bonus[5] + 1;
        tc.Bonus[4] := tc.Bonus[5] + 1;
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
	WFIFOW(0, $00b0);
	WFIFOW(2, $0000);
	WFIFOL(4, tc.Speed);
	tc.Socket.SendBuf(buf, 8);

	//HPSP
	WFIFOW(0, $00b0);
	WFIFOW(2, $0005);
	WFIFOL(4, tc.HP);
	tc.Socket.SendBuf(buf, 8);
	WFIFOW(0, $00b0);
	WFIFOW(2, $0006);
	WFIFOL(4, tc.MAXHP);
	tc.Socket.SendBuf(buf, 8);
	WFIFOW(0, $00b0);
	WFIFOW(2, $0007);
	WFIFOL(4, tc.SP);
	tc.Socket.SendBuf(buf, 8);
	WFIFOW(0, $00b0);
	WFIFOW(2, $0008);
	WFIFOL(4, tc.MAXSP);
	tc.Socket.SendBuf(buf, 8);
	//ステータス
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
	//ベース経験値
	WFIFOW(0, $00b1);
	WFIFOW(2, $0001);
	WFIFOL(4, tc.BaseEXP);
	tc.Socket.SendBuf(buf, 8);
	WFIFOW(0, $00b1);
	WFIFOW(2, $0016);
	WFIFOL(4, tc.BaseNextEXP);
	tc.Socket.SendBuf(buf, 8);
	//ジョブ経験値
	WFIFOW(0, $00b1);
	WFIFOW(2, $0002);
	WFIFOL(4, tc.JobEXP);
	tc.Socket.SendBuf(buf, 8);
	WFIFOW(0, $00b1);
	WFIFOW(2, $0017);
	WFIFOL(4, tc.JobNextEXP);
	tc.Socket.SendBuf(buf, 8);
	//所持金更新
	WFIFOW(0, $00b1);
	WFIFOW(2, $0014);
	WFIFOL(4, tc.Zeny);
	tc.Socket.SendBuf(buf, 8);
	//重量
	WFIFOW(0, $00b0);
	WFIFOW(2, $0018);
	WFIFOL(4, tc.Weight);
	tc.Socket.SendBuf(buf, 8);
	//最大重量
	WFIFOW(0, $00b0);
	WFIFOW(2, $0019);
	WFIFOL(4, tc.MaxWeight);
	tc.Socket.SendBuf(buf, 8);
	//ボーナス
	for i := 0 to 5 do begin
		WFIFOW( 0, $0141);
		WFIFOL( 2, 13+i);
		WFIFOL( 6, tc.ParamBase[i]);
		WFIFOL(10, tc.Bonus[i]);
		tc.Socket.SendBuf(buf, 14);
	end;
	//射程距離セット
	WFIFOW(0, $013a);
	WFIFOW(2, tc.Range);
	tc.Socket.SendBuf(buf, 4);

//Tumy
if View then begin
      WFIFOW(0, $00c3);
      WFIFOL(2, tc.ID);
      //WFIFOB(6, 2);
      //WFIFOB(7, tc.Weapon);
      //tc.Socket.SendBuf(buf, 8); // patket change for view weapon
      WFIFOB(6, 3);
      WFIFOB(7, tc.Head3);
      SendBCmd(tc.MData, tc.Point, 8);
      //tc.Socket.SendBuf(buf, 8);
      WFIFOB(6, 4);
      WFIFOB(7, tc.Head1);
      SendBCmd(tc.MData, tc.Point, 8);
      //tc.Socket.SendBuf(buf, 8);
      WFIFOB(6, 5);
      WFIFOB(7, tc.Head2);
      SendBCmd(tc.MData, tc.Point, 8);
      //tc.Socket.SendBuf(buf, 8);
      //WFIFOB(6, 8);
      //WFIFOB(7, tc.Shield);
      //tc.Socket.SendBuf(buf, 8); // patket change for view Shield

      {Colus, 20040114: Using new weapon sprite display packet.}
      WFIFOW(0, $01d7);
      WFIFOL(2, tc.ID);
      WFIFOB(6, 2);
      WFIFOW(7, tc.WeaponSprite[0]);
      if (tc.Shield <> 0) then begin
        WFIFOW(9, tc.Shield);
      end else begin
        WFIFOW(9, tc.WeaponSprite[1]);
      end;
      SendBCmd(tc.MData, tc.Point, 11);
      //tc.Socket.SendBuf(buf, 11);
end;
// Tumy

end;
//------------------------------------------------------------------------------
procedure SendCStat1(tc:TChara; Mode:word; DType:word; Value:cardinal);
begin
	WFIFOW(0, $00b0 + Mode);
	WFIFOW(2, DType);
	WFIFOL(4, Value);
	tc.Socket.SendBuf(buf, 8);
{パーティー機能追加}
	//ステータスの更新時にHPバーの情報も更新する
	if tc.PartyName <> '' then begin
		WFIFOW( 0, $0106);
		WFIFOL( 2, tc.ID);
		WFIFOW( 6, tc.HP);
		WFIFOW( 8, tc.MAXHP);
		SendPCmd(tc, 10, true, true);
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
	if Use0079 then begin
		WFIFOW(0, $01d9); //0079->01d9
	end else begin
		WFIFOW(0, $01d8); //0078->01d8
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
	WFIFOW(20, tc.WeaponSprite[1]); // Head3->WeaponSprite[1];
	WFIFOW(22, tc.Head3); // Shield -> Head3
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
	//DebugOut.Lines.Add(Format('S 007b %s (%d,%d)-(%d,%d)', [tc.Name, before.X, before.Y, after.X, after.Y]));
	ZeroMemory(@buf[0], 60);
	WFIFOW( 0, $01da);  // 007b -> 01da
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
	WFIFOW(20, tc.WeaponSprite[1]); //Head3->WeaponSprite[1]
	WFIFOW(22, tc.Head3); // time -> Shield
	WFIFOL(24, timeGetTime()); // Shield -> time
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
     debugout.lines.add('Attempted Battle Command Crash. Temporary Bypass. -AlexKreuz');
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
			if (tp.Kafra.Item[i].ID <> 0) and not tp.Kafra.Item[i].Data.IEquip then begin
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
		WFIFOW(2, 4+j*10);
		tc.Socket.SendBuf(buf, 4+j*10);
		//装備データ
		WFIFOW(0, $00a6);
		j := 0;
		for i := 1 to 100 do begin
			if (tp.Kafra.Item[i].ID <> 0) and tp.Kafra.Item[i].Data.IEquip then begin
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
  //DebugOut.Lines.Add(Format('JID = %d',[JID]));
	//スキル送信
	WFIFOW( 0, $010f);
	j := 0;
	for i := 1 to MAX_SKILL_NUMBER do begin
		//if (not tc.Skill[i].Data.Job[tc.JID]) and (not DisableSkillLimit) then continue;
		if ((not (tc.Skill[i].Data.Job1[JIDFix])) and (not (tc.Skill[i].Data.Job2[JIDFix])) and (not tc.Skill[i].Card) and (not tc.Skill[i].Plag) and (not DisableSkillLimit)) then continue;
                if tc.Skill[i].Plag then tc.Skill[i].Lv := tc.PLv;
    //if (tc.Skill[i].Data.Job1[JID]) then DebugOut.Lines.Add(Format('Skill %d is true for JID %d',[i, JID]));
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

	//スキルポイント送信
	WFIFOW( 0, $00b0);
	WFIFOW( 2, $000c);
	WFIFOL( 4, tc.SkillPoint);
	tc.Socket.SendBuf(buf, 8);
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
			if (i > 0) or (tc.ItemSkill = true) then begin
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
function UpdateSpiritSpheres(tm:TMap; tc:TChara; spiritSpheres:integer) :boolean;
begin
        WFIFOW( 0, $01d0);
        WFIFOL( 2, tc.ID);
        WFIFOW( 6, spiritspheres);
        // Colus, 20031222: This packet only has 8 bytes, not 16!
        SendBCmd(tm, tc.Point, 8);
end;
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

	WFIFOW( 0, $00b0);
	WFIFOW( 2, $0007);
	WFIFOL( 4, tc.SP);
	tc.Socket.SendBuf(buf, 8);
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
        WFIFOW( 0, $00b0);
        WFIFOW( 2, $0018);
        WFIFOL( 4, tc.Weight);
        tc.Socket.SendBuf(buf, 8);
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
        WFIFOW( 0, $00b0);
        WFIFOW( 2, $0018);
        WFIFOL( 4, tc.Weight);
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

        WFIFOW( 0, $00b0);
        WFIFOW( 2, $0018);
        WFIFOL( 4, tc.Weight);
        tc.Socket.SendBuf(buf, 8);
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
                                                WFIFOW( 0, $00b0);
                                                WFIFOW( 2, $0018);
                                                WFIFOL( 4, tc1.Weight);
                                                tc1.Socket.SendBuf(buf, 8);

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
	//DebugOut.Lines.Add(Format('S 007b %s (%d,%d)-(%d,%d)', [tc.Name, before.X, before.Y, after.X, after.Y]));
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
procedure SendPMove(Socket: TCustomWinSocket; te:TeNPC; before, after:TPoint; ver2:Word);
begin
	ZeroMemory(@buf[0], 60);
	WFIFOW( 0, $007b);
	WFIFOL( 2, te.ID);
	WFIFOW( 6, te.Speed);
	WFIFOW( 8, te.Stat1);
	WFIFOW(10, te.Stat2);
	WFIFOW(12, te.Option);
	WFIFOW(14, te.JID);
	WFIFOW(16, te.Hair);
	WFIFOW(18, te.Weapon);
	WFIFOW(20, te.Head3);
	WFIFOL(22, timeGetTime());
	WFIFOW(26, te.Shield);
	WFIFOW(28, te.Head1);
	WFIFOW(30, te.Head2);
	WFIFOW(32, te.HairColor);
	WFIFOW(34, te.ClothesColor);
	WFIFOW(36, te.HeadDir);
	WFIFOW(38, te.GuildID);
	WFIFOW(44, te.Manner);
	WFIFOW(46, te.Karma);
	WFIFOB(49, te.Gender);
	WFIFOM2(50, after, before);
	WFIFOB(56, 5);
	WFIFOB(57, 5);
{修正}
	if ver2 = 9 then Socket.SendBuf(buf, 60)  //Kr?
	else             Socket.SendBuf(buf, 58); //Jp
end;
//------------------------------------------------------------------------------
{アジト機能追加}
var
	i  :integer;
	j  :integer;
	w1 :word;
	w2 :word;
	tg :TGuild;
  tgc:TCastle;
{アジト機能追加ココまで}
procedure SendNData(Socket: TCustomWinSocket; tn:TNPC; ver2:Word; Use0079:boolean = false);
begin
{NPCイベント追加}
	if (tn.JID = -1) then exit;
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
          tg := GuildList.Objects[j] as TGuild;
          w1 := tg.Emblem;
					w2 := tg.ID;
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
procedure DelSkillUnit(tm:TMap; tn:TNPC);
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
  
	tm.NPC.Delete(tm.NPC.IndexOf(tn.ID));
	with tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC do
		Delete(IndexOf(tn.ID));
	tn.Free;

end;
//==============================================================================








//==============================================================================
function	MoveItem(ti1:TItemList; ti2:TitemList; Index:Word; cnt:Word) : Integer; overload;
var
	i,j:Integer;
begin
	Result := -1;
	if 100 < index then Exit; //自分範囲外
	if ti2.Item[Index].ID = 0 then Exit; //自分アイテム持ってない
	i := SearchInventory(ti1, ti2.Item[Index].ID, ti2.Item[Index].Data.IEquip);
	if i = 0 then begin //相手空き無し
		Result := 3;
		Exit;
	end;
	//個数多すぎたら持ってる数に
	if ti2.Item[Index].Amount < cnt then cnt := ti2.Item[Index].Amount;
	j := GetItemStore(ti1, ti2.Item[Index], cnt);
	if j = 0 then begin
		DeleteItem(ti2,Index,cnt);
		Result := 0;
	end else if j = 2 then begin //相手重量オーバー
		Result := j;
	end else if j = 3 then begin //相手種類オーバー
		Result := j;
	end;
end;
//------------------------------------------------------------------------------
function  GetItemStore(ti:TItemList; td:TItem; cnt:Word; IsEquip:Boolean = False) : Integer;
var
	i:Integer;
begin
	Result := 0;
	with ti do begin
		//重量オーバー
		if MaxWeight < (Weight + td.Data.Weight * cnt) then begin
			Result := 2;
			Exit;
		end;
		if not IsEquip then IsEquip := td.Data.IEquip;
		i := SearchInventory(ti,td.ID,IsEquip);
		//所持種類オーバー
		if i = 0 then begin
			Result := 3;
			Exit;
		end;
		//所持個数オーバー
		if cnt + Item[i].Amount > 30000 then begin
			Result := -1;
			Exit;
		end;
		with Item[i] do begin
			if Amount = 0 then Inc(Count);
			ID := td.ID;
			Inc(Amount,cnt);
			Equip := 0;
			Identify := td.Identify;
			Refine := td.Refine;
			Attr := td.Attr;
			Card[0] := td.Card[0];
			Card[1] := td.Card[1];
			Card[2] := td.Card[2];
			Card[3] := td.Card[3];
			Data := td.Data;
		end;
		Inc(Weight,(td.Data.Weight * cnt));
	end;
end;
//------------------------------------------------------------------------------
function DeleteItem(ti:TItemList; index:Word; cnt:Word) : Integer;
begin
	Result := -1;
	if 100 < index then Exit; //範囲外
	with ti.item[index] do begin
		if ID = 0 then Exit;       //所持していない
		if Amount > cnt then begin //所有個数以下
			Dec(Amount,cnt);
			Dec(ti.Weight,(Data.Weight * cnt));
		end else begin
			ID := 0;
			Dec(ti.Weight,(Data.Weight * Amount));
			Amount := 0;
			Dec(ti.Count);
		end;
	end;
	Result := 0;
end;
//------------------------------------------------------------------------------
procedure CalcInventory(ti:TItemList);
var
	i,j:Integer;
begin
	ti.Weight := 0;
	j := 0;
	//アイテム重量を計算
	for i := 1 to 100 do begin
		if ti.Item[i].ID <> 0 then begin
                        //if ti.Item[i].Amount <= 0 then ti.Item[i].Amount := 0;
			Inc(ti.Weight,(ti.item[i].Data.Weight * ti.item[i].Amount));
			Inc(j);
		end;
	end;
	ti.Count := j;
end;
//------------------------------------------------------------------------------
function SearchInventory(ti:TItemList; ItemID:Word; IEquip:Boolean) : Word;
var
	i :integer;
begin
	Result := 0;
	if not IEquip then begin
		for i := 1 to 100 do begin
			//同じアイテムを持ってるか探す
			if ti.Item[i].ID = ItemID then begin
				Result := i;
				Exit;
			end;
		end;
	end;
	if ti.Count = 100 then Exit;
	for i := 1 to 100 do begin
		//空きindexを探す
		if ti.Item[i].ID = 0 then begin
			ti.Item[i].Amount := 0;
			Result := i;
			Exit;
		end;
	end;
end;
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
			Inc(tc1.BaseLV);
			if DisableLevelLimit or (tc1.BaseLV < 99) then begin
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
			tc1.BaseNextEXP := ExpTable[0][tc1.BaseLV];

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
	if tpa.EXPShare = 1 then begin
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
{パーティー機能追加}
procedure SendPartyList(tc:TChara);//tcを引数として与えるとパーティー情報を更新し、PTMに通知する
var
	i,j,k :integer;
	tpa   :TParty;
begin
	i := PartyNameList.IndexOf(tc.PartyName);
	if (i <> -1) then begin
		tpa := PartyNameList.Objects[i] as TParty;

		tpa.MinLV := 99;
		tpa.MaxLV := 1;
		i := 0;
		//パーティーメンバーの整理(パーティーに入ったまま削除されたキャラクターはパーティーからも削除する)
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

		//パーティー情報の送信(00FBパケット)
		j := 28;
		for k := 0 to 11 do begin
			//DebugOut.Lines.Add(Format('k = %d : tpa.MemberID = %d', [k,tpa.MemberID[k]]));
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
			//DebugOut.Lines.Add(Format('k = %d : ID = %d : Name = %s : Map = %s ', [k, tpa.Member[k].ID, tpa.Member[k].Name, tpa.Member[k].Map]));
			j := j + 46;
		end;
		WFIFOW(0, $00fb);
		WFIFOW(2, j);
		WFIFOS(4, tpa.Name, 24);
		SendPCmd(tc, j);

		//パーティー共有設定の送信(0101パケット)
		//ここの公平可能レベルはiniから読みこみにするといいかも
		if (tpa.MaxLV - tpa.MinLV > 10) and (tpa.EXPShare = 1) then begin
			tpa.EXPShare := 0;//公平可能レベルを超えていたら無条件に個別取得にする
		end;
		WFIFOW(0, $0101);
		WFIFOW(2, tpa.EXPShare);
		WFIFOW(4, tpa.ITEMShare);
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
				//DebugOut.Lines.Add(Format('Send to ID %d : Length %d ', [tc1.ID, PacketLen]));
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
		//DebugOut.Lines.Add(Format('%s Leaves %s', [tc.Name ,tcr.Title]));

		if (tcr.Users = 0) then begin
			//空室チャット閉じ
			WFIFOW( 0, $00d8);
			WFIFOL( 2, tcr.ID);
			SendNCrCmd(tc.MData, tc.Point, 6, tc, true);
			//DebugOut.Lines.Add(Format('ChatRoom(%s) was deleted / Remaining ChatRoom(%d)', [tcr.Title,ChatRoomList.Count-1]));
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
			//DebugOut.Lines.Add(Format('Vender(%s) was close / Remaining Vender(%d)', [tv.Title,VenderList.Count-1]));
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
						j := SearchCInventory(tc, td.ID, td.IEquip);
						SendCGetItem(tc, j, tdl.Amount[l][i]);
					end;
				end;
				if (tdl.Zeny[l] <> 0) then begin
					//ゼニー返還
					WFIFOW(0, $00b1);
					WFIFOW(2, $0014);
					WFIFOL(4, tc.Zeny);
					tc.Socket.SendBuf(buf, 8);
				end;
				//取引キャンセルパケ
				WFIFOW(0, $00ee);
				tc.Socket.SendBuf(buf, 2);
			end;
			//DebugOut.Lines.Add(Format('Dealings(%d) was canceled / Remaining Dealings(%d)', [tdl.ID,DealingList.Count-1]));
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
	i,j,k,l,m,n  :integer;
  tg           :TGuild;
  tgc          :TCastle;
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
							//DebugOut.Lines.Add(Format('OnInit Event(%d)', [tn1.ID]));
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
								//DebugOut.Lines.Add(Format('NPC Timer(%d) was deleted / Remaining Timer(%d)', [tn1.ID,tm.TimerAct.Count-1]));
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
var
  tgc:TCastle;
  i  :integer;
	w  :integer;
begin
	w := 0;
  i := CastleList.IndexOf(tn.Reg);

  if (i <> - 1) then begin
  tgc := CastleList.Objects[i] as TCastle;
  w := tgc.GKafra;
  end else begin
  w := 0;
  end;

	Result := w;
end;
//------------------------------------------------------------------------------
procedure SetGuildKafra(tn:TNPC;mode:integer);
var
  tgc:TCastle;
  i  :integer;
begin
  i := CastleList.IndexOf(tn.Reg);

  if (i <> - 1) then begin
  tgc := CastleList.Objects[i] as TCastle;
  tgc.GKafra := mode;
  end;

end;
//------------------------------------------------------------------------------
procedure SpawnNPCMob(tn:TNPC;MobName:string;X:integer;Y:integer;SpawnDelay1:cardinal;SpawnDelay2:cardinal);
var
  i,j,k :integer;
  m     :integer;
  ts    :TMob;
  tm    :TMap;
  te    :TEmp;
  tgc   :TCastle;
begin
          //DebugOut.Lines.Add(MobName);
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
function CheckGuildMaster(tn:TNPC; tc:TChara) : word;
var
  tgc:TCastle;
  i  :integer;
	w  :word;
begin
	w := 0;
  i := CastleList.IndexOf(tn.Reg);

  if (i <> - 1) then begin
  tgc := CastleList.Objects[i] as TCastle;
  if (tgc.GMName = tc.Name) then begin
  w := 1;
  end;
  end else begin
  w := 0;
  end;

	Result := w;
end;
//------------------------------------------------------------------------------
function GetGuildID(tn:TNPC) : word;
var
  tgc:TCastle;
  i  :integer;
	w  :word;
begin
	w := 0;
  i := CastleList.IndexOf(tn.Reg);

  if (i <> - 1) then begin
  tgc := CastleList.Objects[i] as TCastle;
  w := tgc.GID;
  end else begin
  w := 0;
  end;

	Result := w;
end;
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
var
  tgc        :TCastle;
  i,j,k,l,m  :integer;
  ts         :TMob;
  tm         :TMap;
  te         :TEmp;
begin
          //guard := guard - 1;
          tm := Map.Objects[Map.IndexOf(tn.Map)] as TMap;
	        j := CastleList.IndexOf(tm.Name);
          if (j <> - 1) then begin
          tgc := CastleList.Objects[j] as TCastle;
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
          end;
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
          ts.MoveWait := timeGetTime();
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
          //end;
          end;
end;
//------------------------------------------------------------------------------
function GetGuildEDegree(tn:TNPC) : cardinal;
var
  tgc:TCastle;
  i  :integer;
	w  :cardinal;
begin
	w := 0;
  i := CastleList.IndexOf(tn.Reg);

  if (i <> - 1) then begin
  tgc := CastleList.Objects[i] as TCastle;
  w := tgc.EDegree;
  end else begin
  w := 0;
  end;

	Result := w;
end;
//------------------------------------------------------------------------------
function GetGuildETrigger(tn:TNPC) : word;
var
  tgc:TCastle;
  i  :integer;
	w  :word;
begin
	w := 0;
  i := CastleList.IndexOf(tn.Reg);

  if (i <> - 1) then begin
  tgc := CastleList.Objects[i] as TCastle;
  w := tgc.ETrigger;
  end else begin
  w := 0;
  end;

	Result := w;
end;
//------------------------------------------------------------------------------
function GetGuildDDegree(tn:TNPC) : cardinal;
var
  tgc:TCastle;
  i  :integer;
	w  :cardinal;
begin
	w := 0;
  i := CastleList.IndexOf(tn.Reg);

  if (i <> - 1) then begin
  tgc := CastleList.Objects[i] as TCastle;
  w := tgc.DDegree;
  end else begin
  w := 0;
  end;

	Result := w;
end;
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
	j   :integer;
	w   :word;
	tgl :TGRel;
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
procedure MapLoad(MapName:string);
var
	i,j,k,l :integer;
	i1,g,ii :integer;
  m       :integer;
  x,p       :integer;
	cnt     :array[0..3] of integer;
	lines   :integer;
	mcnt    :integer;
	SDelay  :cardinal;
	w       :word;
	str     :string;
  str2    :string;
	ScriptPath :string;
	Tick    :cardinal;
	dat     :TMemoryStream;
	txt     :TextFile;
	tm      :TMap;
	tn      :TNPC;
	tn1     :TNPC;
	ts      :TMob;
  tgc     :TCastle;
  te      :TEmp;
	ts0     :TMob;
  ts1     :TMob;
  tss     :TSlaveDB;
  tc1     :TChara;
	h  :array[0..3] of single;
	maptype :integer;
	sl:TStringList;
	sl1:TStringList;
	sl2:TStringList;
	flag:boolean;
{NPCイベント追加}
	tc      :TChara;
	tr      :NTimer;
	ta	:TMapList;
{NPCイベント追加ココまで}

        afm :textfile;
        letter :char;
begin
	MapName := ChangeFileExt(MapName, '');
	dat := TMemoryStream.Create; //読み込み用メモリバッファ


	if MapList.IndexOf(MapName) = -1 then begin
		//DebugOut.Lines.Add('Map Not found : ' + MapName);
		exit;
	end;

	tm := TMap.Create;
	tm.Name := MapName;
	Map.AddObject(MapName, tm);
	tm.Mode := 1;

        ta := MapList.Objects[MapList.IndexOf(MapName)] as TMapList;

        if ta.Ext = 'af2' then begin

          assignfile(afm,AppPath + 'map\tmpFiles\' + MapName + '.out');
          Reset(afm);

          ReadLn(afm,str);
          if (str <> 'ADVANCED FUSION MAP') then begin
            DebugOut.Lines.Add('Mapfile error 500 : ' + MapName);
            tm.Free;
            exit;
          end;

          ReadLn(afm,str);
          if (str <> MapName) then begin
            DebugOut.Lines.Add('The loaded map was not the memory map : ' + MapName);
            tm.Free;
            exit;
          end;

          ReadLn(afm,tm.Size.x,tm.Size.y);
          ReadLn(afm,str);

          SetLength(tm.gat, tm.Size.X, tm.Size.Y);
          for j := 0 to tm.Size.Y - 1 do begin
            for i := 0 to tm.Size.X - 1 do begin
              Read(afm,letter);
              tm.gat[i][j] := strtoint(letter);
            end;
            ReadLn(afm,str);
          end;
          CloseFile(afm);
        end

        else if ta.Ext = 'afm' then begin

          assignfile(afm,AppPath + 'map/' + MapName + '.afm');
          Reset(afm);

          ReadLn(afm,str);
          if (str <> 'ADVANCED FUSION MAP') then begin
            DebugOut.Lines.Add('Mapfile error 500 : ' + MapName);
            tm.Free;
            exit;
          end;

          ReadLn(afm,str);
          if (str <> MapName) then begin
            DebugOut.Lines.Add('The loaded map was not the memory map : ' + MapName);
            tm.Free;
            exit;
          end;

          ReadLn(afm,tm.Size.x,tm.Size.y);
          ReadLn(afm,str);

          SetLength(tm.gat, tm.Size.X, tm.Size.Y);
          for j := 0 to tm.Size.Y - 1 do begin
            for i := 0 to tm.Size.X - 1 do begin
              Read(afm,letter);
              tm.gat[i][j] := strtoint(letter);
            end;
            ReadLn(afm,str);
          end;
          CloseFile(afm);
        end

        else begin
         
          if ta.Ext = 'gat' then begin
            //DebugOut.Lines.Add('Loading mapfile... : ' + MapName + '.gat');
            dat.LoadFromFile(AppPath + 'map\' + MapName + '.gat');
            SetLength(str, 4);
            dat.Read(str[1], 4);
          end;
          
          if (str <> 'GRAT') then begin
            DebugOut.Lines.Add('Mapfile error 500 : ' + MapName);
            tm.Free;
            exit;
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

	tm.BlockSize.X := (tm.Size.X + 7) div 8;
	tm.BlockSize.Y := (tm.Size.Y + 7) div 8;
	for j := 0 - 3 to tm.BlockSize.Y + 3 do begin
		for i := 0 - 3 to tm.BlockSize.X + 3 do begin
			tm.Block[i][j] := TBlock.Create;
			if (i < 0) or (j < 0) or (i >= tm.BlockSize.X) or (j >= tm.BlockSize.Y) then
				tm.Block[i][j].MobProcTick := $FFFFFFFF //画面外ブロックはモンスター処理を行わない
			else
				tm.Block[i][j].MobProcTick := 0;
		end;
	end;

	//スクリプトロード
	//DebugOut.Lines.Add('Loading script...');
	for i := 0 to 3 do cnt[i] := 0;
	Tick := timeGetTime();
	lines := 0;
	sl := TStringList.Create;
	sl1 := TStringList.Create;
	sl2 := TStringList.Create;
	for i1 := 0 to ScriptList.Count - 1 do begin
		AssignFile(txt, ScriptList.Strings[i1]);
		Reset(txt);
		while not eof(txt) do begin
			Readln(txt, str);
			Inc(lines);
			sl.Delimiter := #9;
			sl.QuoteChar := '"';
			sl.DelimitedText := str;
			if sl.Count = 4 then begin
				sl1.DelimitedText := sl.Strings[0];
				if ChangeFileExt(sl1.Strings[0], '') = MapName then begin
	// ワープポイント ------------------------------------------------------------
          // Colus, 20040122: Added parsing for hidden warps.
					if (sl.Strings[1] = 'warp') or (sl.Strings[1] = 'hiddenwarp') then begin
						tn := TNPC.Create;
						tn.ID := NowNPCID;
						Inc(NowNPCID);
						tn.Name := sl.Strings[2];
						//DebugOut.Lines.Add('-> adding warp point ' + tn.Name);
						if WarpDebugFlag then begin
              tn.JID := 1002;
            end else begin
              if sl.Strings[1] = 'warp' then tn.JID := 45 else tn.JID := 139;
            end;
						tn.Map := MapName;
						tn.Point.X := StrToInt(sl1.Strings[1]);
						tn.Point.Y := StrToInt(sl1.Strings[2]);
						tn.Dir := StrToInt(sl1.Strings[3]);
						sl1.DelimitedText := sl.Strings[3];
						tn.CType := 0;
						tn.WarpSize.X := StrToInt(sl1.Strings[0]);
						tn.WarpSize.Y := StrToInt(sl1.Strings[1]);
						tn.WarpMap := ChangeFileExt(sl1.Strings[2], '');
						tn.WarpPoint.X :=  StrToInt(sl1.Strings[3]);
						tn.WarpPoint.Y :=  StrToInt(sl1.Strings[4]);
{NPCイベント追加}
						tn.Enable := true;
						tn.ScriptInitS := -1;
{NPCイベント追加ココまで}
						tm.NPC.AddObject(tn.ID, tn);
						tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.AddObject(tn.ID, tn);
						for j := tn.Point.Y - tn.WarpSize.Y to tn.Point.Y + tn.WarpSize.Y do begin
							for i := tn.Point.X - tn.WarpSize.X to tn.Point.X + tn.WarpSize.X do begin
								tm.gat[i][j] := (tm.gat[i][j] or $4);
							end;
						end;
						Inc(cnt[0]);
	// NPCショップ ---------------------------------------------------------------
					end else if sl.Strings[1] = 'shop' then begin
						tn := TNPC.Create;
						tn.ID := NowNPCID;
						Inc(NowNPCID);
						tn.Name := sl.Strings[2];
						//DebugOut.Lines.Add('-> adding shop ' + tn.Name);
						tn.Map := MapName;
						tn.Point.X := StrToInt(sl1.Strings[1]);
						tn.Point.Y := StrToInt(sl1.Strings[2]);
						tn.Dir := StrToInt(sl1.Strings[3]);
						sl1.DelimitedText := sl.Strings[3];
						tn.CType := 1;
						tn.JID := StrToInt(sl1.Strings[0]);
						SetLength(tn.ShopItem, sl1.Count - 1);
						for i := 0 to sl1.Count - 2 do begin
							tn.ShopItem[i] := TShopItem.Create;
							j := Pos(':', sl1.Strings[i+1]);
							tn.ShopItem[i].ID := StrToInt(Copy(sl1.Strings[i+1], 1, j - 1));
							tn.ShopItem[i].Price := StrToInt(Copy(sl1.Strings[i+1], j + 1, 8));
							tn.ShopItem[i].Data := ItemDB.IndexOfObject(tn.ShopItem[i].ID) as TItemDB;
						end;

{NPCイベント追加}
						tn.Enable := true;
						tn.ScriptInitS := -1;
{NPCイベント追加ココまで}
						tm.NPC.AddObject(tn.ID, tn);
						tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.AddObject(tn.ID, tn);

						for j := tn.Point.Y - tn.WarpSize.Y to tn.Point.Y + tn.WarpSize.Y do begin
							for i := tn.Point.X - tn.WarpSize.X to tn.Point.X + tn.WarpSize.X do begin
								tm.gat[i][j] := (tm.gat[i][j] and $fe);
							end;
						end;
						Inc(cnt[1]);
{d$0100fix5より}
	// スクリプト ----------------------------------------------------------------
					end else if sl.Strings[1] = 'script' then begin
						tn := TNPC.Create;
						tn.ID := NowNPCID;
						Inc(NowNPCID);
						tn.Name := sl.Strings[2];
						//DebugOut.Lines.Add('-> adding script ' + tn.Name);
						tn.Map := MapName;
						tn.Point.X := StrToInt(sl1.Strings[1]);
						if (tn.Point.X < 0) or (tn.Point.X >= tm.Size.X) then tn.Point.X := 0;
						tn.Point.Y := StrToInt(sl1.Strings[2]);
						if (tn.Point.Y < 0) or (tn.Point.Y >= tm.Size.Y) then tn.Point.Y := 0;
						tn.Dir := StrToInt(sl1.Strings[3]);
						tn.CType := 2;
						sl1.DelimitedText := sl.Strings[3];
						tn.JID := StrToInt(sl1.Strings[0]);
						ScriptPath := ExtractRelativePath(AppPath, ScriptList.Strings[i1]);
{NPCイベント追加}
						tn.ScriptInitS := -1;
						tn.ScriptInitD := false;
						tn.Enable := true;
{NPCイベント追加ココまで}
						k := 0;
						sl2.Clear;
						while not eof(txt) do begin
							//スクリプト読み込み
							Readln(txt, str);
							Inc(lines);
							if str = '}' then break; //注：スクリプト終了文字「}」は１行にそれのみ書くこと
							while Pos(#9#9, str) <> 0 do str := StringReplace(str, #9#9, #9, [rfReplaceAll]);
							str := StringReplace(str, #9, ' ', [rfReplaceAll]);
							str := Trim(str);
							if Copy(str, Length(str), 1) = ';' then str := Copy(str, 1, Length(str) - 1);
							str := Trim(str);
							sl.Delimiter := ' ';
							sl.QuoteChar := #1;
							sl.DelimitedText := str;
							if sl.Count > 2 then begin
								for i := 2 to sl.Count - 1 do begin
									sl.Strings[1] := sl.Strings[1] + ' ' + sl.Strings[2];
									sl.Delete(2);
								end;
							end;
							case sl.Count of
							1:	sl1.Clear;
							2:	sl1.DelimitedText := sl.Strings[1];
							else
								begin
									DebugOut.Lines.Add(Format('%s %.4d: syntax error', [ScriptPath, lines]));
									exit;
								end;
							end;
							str := LowerCase(sl.Strings[0]);
							sl.Delete(0);
							if str = 'mes' then begin //------- 1 mes
								if sl1.Count <> 1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [mes] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 1;
								SetLength(tn.Script[k].Data1, 1);
								sl1.Strings[0] := StringReplace(sl1.Strings[0], '&sp;', ' ', [rfReplaceAll]);
								sl1.Strings[0] := StringReplace(sl1.Strings[0], '&amp;', '&', [rfReplaceAll]);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								Inc(k);
							end else if str = 'next' then begin //------- 2 next
								if sl1.Count <> 0 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [next] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 2;
								Inc(k);
							end else if str = 'close' then begin //------- 3 close
								if sl1.Count <> 0 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [close] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 3;
								Inc(k);
							end else if str = 'menu' then begin //------- 4 menu
								if sl1.Count <> sl1.Count div 2 * 2 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [menu] function error', [ScriptPath, lines]));
									exit;
								end;
								if sl1.Count > 40 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [menu] too many selections', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 4;
								SetLength(tn.Script[k].Data1, sl1.Count div 2);
								SetLength(tn.Script[k].Data2, sl1.Count div 2);
								SetLength(tn.Script[k].Data3, sl1.Count div 2);
								tn.Script[k].DataCnt := sl1.Count div 2;
								for i := 0 to sl1.Count div 2 - 1 do begin
									sl1.Strings[i*2] := StringReplace(sl1.Strings[i*2], '&sp;', ' ', [rfReplaceAll]);
									sl1.Strings[i*2] := StringReplace(sl1.Strings[i*2], '&amp;', '&', [rfReplaceAll]);
									tn.Script[k].Data1[i] := sl1.Strings[i*2];
									tn.Script[k].Data2[i] := LowerCase(sl1.Strings[i*2+1]);
								end;
								Inc(k);
							end else if str = 'goto' then begin //------- 5 goto
								if sl1.Count <> 1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [goto] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 5;
								SetLength(tn.Script[k].Data1, 1);
								SetLength(tn.Script[k].Data3, 1);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								Inc(k);
							end else if str = 'cutin' then begin //------- 6 cutin
								if sl1.Count <> 2 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [cutin] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[1], i, j);
								if (j <> 0) or (i < 0) or (i > 255) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [cutin] range error (2)', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 6;
								SetLength(tn.Script[k].Data1, 1);
								SetLength(tn.Script[k].Data3, 1);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								if ExtractFileExt(tn.Script[k].Data1[0]) = '' then ChangeFileExt(tn.Script[k].Data1[0], '.bmp');
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[1]);
								Inc(k);
							end else if str = 'store' then begin //------- 7 store
								if sl1.Count <> 0 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [store] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 7;
								Inc(k);
							end else if str = 'warp' then begin //------- 8 warp
								if sl1.Count <> 3 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [warp] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[1], i, j);
								if (j <> 0) or (i < 0) or (i > 511) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [warp] range error (2)', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[2], i, j);
								if (j <> 0) or (i < 0) or (i > 511) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [warp] range error (3)', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 8;
								SetLength(tn.Script[k].Data1, 1);
								SetLength(tn.Script[k].Data3, 2);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[1]);
								tn.Script[k].Data3[1] := StrToInt(sl1.Strings[2]);
								Inc(k);
							end else if str = 'save' then begin //------- 9 save
								if sl1.Count <> 3 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [save] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[1], i, j);
								if (j <> 0) or (i < 0) or (i > 511) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [save] range error (2)', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[2], i, j);
								if (j <> 0) or (i < 0) or (i > 511) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [save] range error (3)', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 9;
								SetLength(tn.Script[k].Data1, 1);
								SetLength(tn.Script[k].Data3, 2);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[1]);
								tn.Script[k].Data3[1] := StrToInt(sl1.Strings[2]);
								Inc(k);
							end else if str = 'heal' then begin //------- 10 heal
								if sl1.Count <> 2 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [heal] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if (j <> 0) or (i < 0) or (i > 30000) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [heal] range error (1)', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[1], i, j);
								if (j <> 0) or (i < 0) or (i > 30000) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [heal] range error (2)', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 10;
								SetLength(tn.Script[k].Data3, 2);
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[0]);
								tn.Script[k].Data3[1] := StrToInt(sl1.Strings[1]);
								Inc(k);
							end else if str = 'set' then begin //------- 11 set
								sl.Strings[0] := StringReplace(sl.Strings[0], '+=', '+', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], '-=', '-', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], '*=', '*', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], '/=', '/', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], '+', ',1,', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], '-', ',2,',	[]);
								sl.Strings[0] := StringReplace(sl.Strings[0], '=', ',0,', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], '*', ',3,', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], '/', ',4,', []);
								while Pos('- ', sl.Strings[0]) <> 0 do
									sl.Strings[0] := StringReplace(sl.Strings[0], '- ', '-',	[]);
								sl1.DelimitedText := sl.Strings[0];
								if sl1.Count = 3 then sl1.Add('0');
								if sl1.Count <> 4 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [set] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[1], i, j);
								if (j <> 0) or (i < 0) or (i > 4) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [set] range error (2)', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[2], i, j);
								if j = 0 then begin
									if (i < -999999999) or (i > 999999999) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [set] range error (3)', [ScriptPath, lines]));
										exit;
									end else if (StrToInt(sl1.Strings[1]) = 3) and (i = 0) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [set] div 0 error (3)', [ScriptPath, lines]));
										exit;
									end;
								end;
								val(sl1.Strings[3], i, j);
								if (j <> 0) or (i < -999999999) or (i > 999999999) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [set] range error (4)', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 11;
								SetLength(tn.Script[k].Data1, 2);
								SetLength(tn.Script[k].Data3, 2);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[2]);
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[1]);
								tn.Script[k].Data3[1] := StrToInt(sl1.Strings[3]);
								Inc(k);
							end else if str = 'additem' then begin //------- 12 additem
								if sl1.Count <> 2 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [additem] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 19999) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [additem] range error (1)', [ScriptPath, lines]));
										exit;
									end;
								end;
								val(sl1.Strings[1], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 30000) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [additem] range error (2)', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 12;
								SetLength(tn.Script[k].Data1, 2);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[1]);
								Inc(k);
							end else if str = 'delitem' then begin //------- 13 delitem
								if sl1.Count <> 2 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [delitem] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 19999) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [delitem] range error (1)', [ScriptPath, lines]));
										exit;
									end;
								end;
								val(sl1.Strings[1], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 30000) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [delitem] range error (2)', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 13;
								SetLength(tn.Script[k].Data1, 2);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[1]);
								Inc(k);
							end else if str = 'checkitem' then begin //------- 14 checkitem
								if sl1.Count <> 4 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [checkitem] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 19999) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [checkitem] range error (1)', [ScriptPath, lines]));
										exit;
									end;
								end;
								val(sl1.Strings[1], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 30000) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [checkitem] range error (2)', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 14;
								SetLength(tn.Script[k].Data1, 2);
								SetLength(tn.Script[k].Data2, 2);
								SetLength(tn.Script[k].Data3, 2);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[1]);
								tn.Script[k].Data2[0] := LowerCase(sl1.Strings[2]);
								tn.Script[k].Data2[1] := LowerCase(sl1.Strings[3]);
								tn.Script[k].DataCnt := 2;
								Inc(k);
							end else if str = 'check' then begin //------- 15 check
								sl.Strings[0] := StringReplace(sl.Strings[0], '=>', '>=', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], '=<', '<=', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], '==', '=',	[]);
								sl.Strings[0] := StringReplace(sl.Strings[0], '><', '<>', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], '!=', '<>', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], '>',	',>,',	[]);
								sl.Strings[0] := StringReplace(sl.Strings[0], '<',	',<,',	[]);
								sl.Strings[0] := StringReplace(sl.Strings[0], '=',	',=,',	[]);
								sl.Strings[0] := StringReplace(sl.Strings[0], ',>,,=,', ',>=,', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], ',<,,=,', ',<=,', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], ',<,,>,', ',<>,', []);
								sl1.DelimitedText := sl.Strings[0];
								if sl1.Count <> 5 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [check] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[2], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 999999999) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [check] range error (1)', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 15;
								SetLength(tn.Script[k].Data1, 3);
								SetLength(tn.Script[k].Data2, 2);
								SetLength(tn.Script[k].Data3, 3);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[2]);
								tn.Script[k].Data1[2] := sl1.Strings[1];
								str := sl1.Strings[1];
								j := -1;
										 if str = '>=' then j := 0
								else if str = '<=' then j := 1
								else if str = '='	then j := 2
								else if str = '<>' then j := 3
								else if str = '>'	then j := 4
								else if str = '<'	then j := 5;
								if j = -1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [check] syntax error (2)', [ScriptPath, lines]));
									exit;
								end;
								tn.Script[k].Data3[2] := j;
								tn.Script[k].Data2[0] := LowerCase(sl1.Strings[3]);
								tn.Script[k].Data2[1] := LowerCase(sl1.Strings[4]);
								tn.Script[k].DataCnt := 2;
								Inc(k);
							end else if str = 'checkadditem' then begin //------- 16 checkadditem
								if sl1.Count <> 4 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [checkadditem] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 19999) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [checkadditem] range error (1)', [ScriptPath, lines]));
										exit;
									end;
								end;
								val(sl1.Strings[1], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 30000) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [checkadditem] range error (2)', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 16;
								SetLength(tn.Script[k].Data1, 2);
								SetLength(tn.Script[k].Data2, 2);
								SetLength(tn.Script[k].Data3, 2);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[1]);
								tn.Script[k].Data2[0] := LowerCase(sl1.Strings[2]);
								tn.Script[k].Data2[1] := LowerCase(sl1.Strings[3]);
								tn.Script[k].DataCnt := 2;
								Inc(k);
							end else if str = 'jobchange' then begin //------- 17 jobchange
								if sl1.Count <> 1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [jobchange] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if (j <> 0) or (i < 0) or (i > MAX_JOB_NUMBER) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [jobchange] range error (1)', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 17;
								SetLength(tn.Script[k].Data3, 1);
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[0]);
								Inc(k);

							end else if str = 'viewpoint' then begin //------- 18 viewpoint
								if sl1.Count <> 5 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [viewpoint] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if (j <> 0) or (i < 1) or (i > 2) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [viewpoint] range error (1)', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[1], i, j);
								if (j <> 0) or (i < 0) or (i > 511) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [viewpoint] range error (2)', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[2], i, j);
								if (j <> 0) or (i < 0) or (i > 511) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [viewpoint] range error (3)', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[3], i, j);
								if (j <> 0) or (i < 0) or (i > 255) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [viewpoint] range error (4)', [ScriptPath, lines]));
									exit;
								end;
								sl1.Strings[4] := StringReplace(sl1.Strings[4], '0x', '', []);
								if Copy(sl1.Strings[4], 1, 1) <> '$' then sl1.Strings[4] := '$' + sl1.Strings[4];
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 18;
								SetLength(tn.Script[k].Data3, 5);
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[0]);
								tn.Script[k].Data3[1] := StrToInt(sl1.Strings[1]);
								tn.Script[k].Data3[2] := StrToInt(sl1.Strings[2]);
								tn.Script[k].Data3[3] := StrToInt(sl1.Strings[3]);
								tn.Script[k].Data3[4] := StrToInt(sl1.Strings[4]);
								Inc(k);
							end else if str = 'input' then begin //------- 19 input
								if sl1.Count <> 1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [input] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 19;
								SetLength(tn.Script[k].Data1, 1);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								Inc(k);
							end else if str = 'random' then begin //------- 20 random
								if sl1.Count <> 2 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [random] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 999999999) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [random] range error (1)', [ScriptPath, lines]));
										exit;
									end;
								end;
								val(sl1.Strings[1], i, j);
								if (j <> 0) or (i < 0) or (i > 999999999) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [random] range error (2)', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 20;
								SetLength(tn.Script[k].Data1, 1);
								SetLength(tn.Script[k].Data3, 1);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[1]);
								Inc(k);
							end else if str = 'option' then begin //------- 21 option
								if sl1.Count <> 2 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [option] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if (j <> 0) or (i < 0) or (i > 2) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [option] range error (1)', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[1], i, j);
								if (j <> 0) or (i < 0) or (i > 1) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [option] range error (2)', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 21;
								SetLength(tn.Script[k].Data3, 2);
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[0]);
								tn.Script[k].Data3[1] := StrToInt(sl1.Strings[1]);
								Inc(k);
							end else if str = 'speed' then begin //------- 22 speed
								if sl1.Count <> 1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [speed] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if j = 0 then begin
									if (i < 25) or (i > 1000) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [speed] range error (1)', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 22;
								SetLength(tn.Script[k].Data1, 1);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								Inc(k);
							end else if str = 'die' then begin //------- 23 die
								if sl1.Count <> 0 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [die] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 23;
								Inc(k);
							end else if str = 'ccolor' then begin //------- 24 ccolor
								if sl1.Count <> 1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [ccolor] function error', [ScriptPath, lines]));
									exit;
								end;
								{val(sl1.Strings[0], i, j);
								if (j <> 0) or (i > 5) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [ccolor] range error (1)', [ScriptPath, lines]));
									exit;
								end;}
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 24;
								SetLength(tn.Script[k].Data1, 1);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								Inc(k);
							end else if str = 'refine' then begin //------- 25 refine	 refine[itemID][fail][+val]
								if sl1.Count <> 3 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [refine] function error', [ScriptPath, lines]));
									exit;
								end;
								//val(sl1.Strings[0], i, j);
								//val(sl1.Strings[1], i, j);
								val(sl1.Strings[2], i, j);
								if (j <> 0) or (i > 10) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [refine] range error (1)', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 25;
								SetLength(tn.Script[k].Data1, 3);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								tn.Script[k].Data1[1] := sl1.Strings[1];
								tn.Script[k].Data1[2] := sl1.Strings[2];
								Inc(k);
							end else if str = 'getitemamount' then begin //------- 26 getitemamount
								if sl1.Count <> 2 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [getitemamount] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 19999) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [getitemamount] range error (1)', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 26;
								SetLength(tn.Script[k].Data1, 2);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[1]);
								Inc(k);
{追加:スクリプト144}
							end else if str = 'getskilllevel' then begin //--------27 getskilllevel // S144 addstart
								if sl1.Count <> 2 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [getskilllevel] function error', [ScriptPath, lines]));
									exit;
								end;

								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 27;
								SetLength(tn.Script[k].Data1, 2);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[1]);
								Inc(k);
							end else if str = 'setskilllevel' then begin //--------28 setskilllevel
								if sl1.Count <> 2 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [setskilllevel] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[1], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 10) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [setskilllevel] range error(2)', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 28;
								SetLength(tn.Script[k].Data1, 2);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[1]);
								Inc(k);                                    // S144 addend
{追加:スクリプト144ここまで}
{精錬NPC機能追加}
							end else if str = 'refinery' then begin //--------29 refinery
								if sl1.Count <> 3 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [refinery] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 10) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [refinery] range error (1)', [ScriptPath, lines]));
										exit;
									end;
								end;
								val(sl1.Strings[1], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 2) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [refinery] range error (2)', [ScriptPath, lines]));
										exit;
									end;
								end;
								val(sl1.Strings[2], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 10) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [refinery] range error (3)', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 29;
								SetLength(tn.Script[k].Data1, 3);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[1]);
								tn.Script[k].Data1[2] := LowerCase(sl1.Strings[2]);
								Inc(k);
							end else if str = 'equipmenu' then begin //--------30 equipmenu
								if sl1.Count <> 3 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [equipmenu] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 30;
								SetLength(tn.Script[k].Data1, 3);
								SetLength(tn.Script[k].Data2, 10);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[1]);
								tn.Script[k].Data1[2] := LowerCase(sl1.Strings[2]);
								Inc(k);
							end else if str = 'lockitem' then begin //--------31 lockitem
								if sl1.Count <> 1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [lockitem] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 1) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [lockitem] range error', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 31;
								SetLength(tn.Script[k].Data1, 1);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								Inc(k);
{精錬NPC機能追加ココまで}
{髪色変更追加}
							end else if str = 'hcolor' then begin //------- 32 hcolor
								if sl1.Count <> 1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [hcolor] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 8) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [hcolor] range error', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 32;
								SetLength(tn.Script[k].Data1, 1);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								Inc(k);
{髪色変更追加ココまで}
{NPCイベント追加}
							end else if str = 'callmob' then begin //------- 33 callmob
								if (sl1.Count = 6) then sl1.Add('');
								if (sl1.Count <> 7) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [callmob] function error', [ScriptPath, lines]));
									exit;
								end;
								i := 0;
								if (tn.Map <> ChangeFileExt(sl1.Strings[0], '')) then i := 1;
								if (MobDB.IndexOf(StrToInt(sl1.Strings[4])) = -1) then i := 1;
								if i <> 0 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [callmob] range error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 33;
								SetLength(tn.Script[k].Data1, 2);
								SetLength(tn.Script[k].Data2, 1);
								SetLength(tn.Script[k].Data3, 4);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[1]);
								tn.Script[k].Data3[1] := StrToInt(sl1.Strings[2]);
								tn.Script[k].Data1[1] := sl1.Strings[3];
								tn.Script[k].Data3[2] := StrToInt(sl1.Strings[4]);
								tn.Script[k].Data3[3] := StrToInt(sl1.Strings[5]);
								tn.Script[k].Data2[0] := LowerCase(sl1.Strings[6]);
								Inc(k);
							end else if str = 'broadcast' then begin //------- 34 broadcast
								if (sl1.Count = 1) then sl1.Add('0');
								if (sl1.Count <> 2) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [broadcast] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 34;
								SetLength(tn.Script[k].Data1, 1);
								SetLength(tn.Script[k].Data3, 1);
								sl1.Strings[0] := StringReplace(sl1.Strings[0], '&sp;', ' ', [rfReplaceAll]);
								sl1.Strings[0] := StringReplace(sl1.Strings[0], '&amp;', '&', [rfReplaceAll]);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[1]);
								Inc(k);
							end else if str = 'npctimer' then begin //------- 35 npctimer
								if (sl1.Count <> 1) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [npctimer] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 8) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [npctimer] range error', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 35;
								SetLength(tn.Script[k].Data3, 1);
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[0]);
								Inc(k);
							end else if str = 'addnpctimer' then begin //------- 36 addnpctimer
								if sl1.Count <> 2 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [addnpctimer] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[1], i, j);
								if (j <> 0) or (i < -999999999) or (i > 999999999) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [addnpctimer] range error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 36;
								SetLength(tn.Script[k].Data1, 1);
								SetLength(tn.Script[k].Data3, 1);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[1]);
								Inc(k);
							end else if str = 'return' then begin //------- 37 return
								if sl1.Count <> 0 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [return] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 37;
								Inc(k);
							end else if str = 'warpallpc' then begin //------- 38 warpallpc
								if (sl1.Count = 3) then sl1.Add('0');
								if (sl1.Count <> 4) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [warpallpc] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[1], i, j);
								if (j <> 0) or (i < 0) or (i > 511) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [warpallpc] range error (2)', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[2], i, j);
								if (j <> 0) or (i < 0) or (i > 511) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [warpallpc] range error (3)', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[3], i, j);
								if (j <> 0) or (i < 0) or (i > 2) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [warpallpc] range error (4)', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 38;
								SetLength(tn.Script[k].Data1, 1);
								SetLength(tn.Script[k].Data3, 3);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[1]);
								tn.Script[k].Data3[1] := StrToInt(sl1.Strings[2]);
								tn.Script[k].Data3[2] := StrToInt(sl1.Strings[3]);
								Inc(k);
							end else if str = 'waitingroom' then begin //------- 39 waitingroom
								if (sl1.Count <> 2) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [waitingroom] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[1], i, j);
								if (j <> 0) or (i < 2) or (i > 20) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [waitingroom] range error (2)', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 39;
								SetLength(tn.Script[k].Data1, 1);
								SetLength(tn.Script[k].Data3, 2);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[1]);
								tn.Script[k].Data3[1] := k + 1;
								Inc(k);
							end else if str = 'enablenpc' then begin //------- 40 enablenpc
								if (sl1.Count <> 3) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [enablenpc] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[2], i, j);
								if (j <> 0) or (i < 0) or (i > 1) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [enablenpc] range error (2)', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 40;
								SetLength(tn.Script[k].Data1, 2);
								SetLength(tn.Script[k].Data3, 1);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								tn.Script[k].Data1[1] := sl1.Strings[1];
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[2]);
								Inc(k);
							end else if str = 'resetmymob' then begin //------- 41 resetmymob
								if (sl1.Count <> 1) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [resetmymob] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 41;
								SetLength(tn.Script[k].Data1, 1);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								Inc(k);
							end else if str = 'getmapusers' then begin //------- 42 getmapusers
								if (sl1.Count <> 2) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [getmapusers] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 42;
								SetLength(tn.Script[k].Data1, 2);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[1]);
								Inc(k);
							end else if str = 'setstr' then begin //------- 43 setstr
								sl.Strings[0] := StringReplace(sl.Strings[0], '+=', '+', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], '+', ',1,', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], '=', ',0,', []);
								sl1.DelimitedText := sl.Strings[0];
								if (sl1.Count <> 3) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [setstr] function error', [ScriptPath, lines]));
									exit;
								end;
								if (Copy(sl1.Strings[0], 1, 1) <> '$') and (Copy(sl1.Strings[0], 1, 2) <> '\$') then begin
									DebugOut.Lines.Add(Format('%s %.4d: [setstr] range error (1)', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[1], i, j);
								if (j <> 0) or (i < 0) or (i > 1) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [setstr] range error (2)', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 43;
								SetLength(tn.Script[k].Data1, 2);
								SetLength(tn.Script[k].Data3, 1);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := sl1.Strings[2];
								tn.Script[k].Data3[0] := StrToInt(sl1.Strings[1]);
								Inc(k);
							end else if str = 'checkstr' then begin //------- 44 checkstr
								sl.Strings[0] := StringReplace(sl.Strings[0], '==', '=',	[]);
								sl.Strings[0] := StringReplace(sl.Strings[0], '><', '<>', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], '!=', '<>', []);
								sl.Strings[0] := StringReplace(sl.Strings[0], '=',	',=,',	[]);
								sl.Strings[0] := StringReplace(sl.Strings[0], '<>', ',<>,', []);
								sl1.DelimitedText := sl.Strings[0];
								if sl1.Count <> 5 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [checkstr] function error', [ScriptPath, lines]));
									exit;
								if (Copy(sl1.Strings[0], 1, 1) <> '$') and (Copy(sl1.Strings[0], 1, 2) <> '\$') then begin
									DebugOut.Lines.Add(Format('%s %.4d: [checkstr] range error (1)', [ScriptPath, lines]));
									exit;
								end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 44;
								SetLength(tn.Script[k].Data1, 3);
								SetLength(tn.Script[k].Data2, 2);
								SetLength(tn.Script[k].Data3, 3);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[2]);
								tn.Script[k].Data1[2] := sl1.Strings[1];
								str := sl1.Strings[1];
								j := -1;
								if str = '='	then j := 0
								else if str = '<>' then j := 1;
								if j = -1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [checkstr] syntax error (2)', [ScriptPath, lines]));
									exit;
								end;
								tn.Script[k].Data3[2] := j;
								tn.Script[k].Data2[0] := LowerCase(sl1.Strings[3]);
								tn.Script[k].Data2[1] := LowerCase(sl1.Strings[4]);
								tn.Script[k].DataCnt := 2;
								Inc(k);
{アジト機能追加}
							{Colus, 20040110: Updated guild territory command codes}
							end else if str = 'getagit' then begin //------- 58 getagit
								if (sl1.Count <> 3) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [getagit] function error', [ScriptPath, lines]));
									exit;
								end;
								if (Copy(sl1.Strings[1], 1, 1) <> '$') and (Copy(sl1.Strings[1], 1, 2) <> '\$') then begin
									DebugOut.Lines.Add(Format('%s %.4d: [getagit] range error (2)', [ScriptPath, lines]));
									exit;
								end;
								if (Copy(sl1.Strings[2], 1, 1) <> '$') and (Copy(sl1.Strings[2], 1, 2) <> '\$') then begin
									DebugOut.Lines.Add(Format('%s %.4d: [getagit] range error (3)', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 58;
								SetLength(tn.Script[k].Data1, 1);
								SetLength(tn.Script[k].Data2, 2);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								tn.Script[k].Data2[0] := LowerCase(sl1.Strings[1]);
								tn.Script[k].Data2[1] := LowerCase(sl1.Strings[2]);
								Inc(k);
							end else if str = 'getmyguild' then begin //------- 59 getguild
								if (sl1.Count <> 1) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [getmyguild] function error', [ScriptPath, lines]));
									exit;
								end;
								if (Copy(sl1.Strings[0], 1, 1) <> '$') and (Copy(sl1.Strings[0], 1, 2) <> '\$') then begin
									DebugOut.Lines.Add(Format('%s %.4d: [getmyguild] range error (1)', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 59;
								SetLength(tn.Script[k].Data1, 1);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								Inc(k);


							end else if str = 'agitregist' then begin //------- 60 agitregist
								if (sl1.Count <> 1) then begin
									DebugOut.Lines.Add(Format('%s %.4d: [agitregist] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 60;
								SetLength(tn.Script[k].Data1, 1);
								tn.Script[k].Data1[0] := sl1.Strings[0];
								Inc(k);

              end else if str = 'resetstat' then begin //------- 45 resetstat
								if sl1.Count <> 0 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [resetstat] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 45;
								Inc(k);
                                                                     
              end else if str = 'resetbonusstat' then begin //------- 57 resetbonusstat
								if sl1.Count <> 0 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [resetstat] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 57;
								Inc(k);
              end else if str = 'resetskill' then begin //------- 46 resetskill
								if sl1.Count <> 0 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [resetskill] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 46;
								Inc(k);
              end else if str = 'hstyle' then begin //------- 47 hstyle
								if sl1.Count <> 1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [hstyle] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 19) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [hstyle] range error', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 47;
								SetLength(tn.Script[k].Data1, 1);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								Inc(k);
              end else if str = 'guildreg' then begin //------- 48 guildreg
								if sl1.Count <> 1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [guildreg] function error', [ScriptPath, lines]));
									exit;
								end;
                //j := CastleList.IndexOf(sl1.Strings[0]);
								//if j = - 1 then begin
                  //DebugOut.Lines.Add(Format('%s %.4d: [guildreg] map error', [ScriptPath, lines]));
                  //exit;
								//end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 48;
								SetLength(tn.Script[k].Data1, 1);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								Inc(k);
              end else if str = 'getgskilllevel' then begin //--------49 getgskilllevel
								if sl1.Count <> 2 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [getgskilllevel] function error', [ScriptPath, lines]));
									exit;
								end;

								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 49;
								SetLength(tn.Script[k].Data1, 2);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[1]);
								Inc(k);
              end else if str = 'getguardstatus' then begin //--------50 getguardstatus
								if sl1.Count <> 2 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [getguardstatus] function error', [ScriptPath, lines]));
									exit;
								end;

								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 50;
								SetLength(tn.Script[k].Data1, 2);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[1]);
								Inc(k);
              end else if str = 'setguildkafra' then begin //------- 51 setguildkafra
								if sl1.Count <> 1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [setguildkafra] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 1) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [setguildkafra] range error', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 51;
								SetLength(tn.Script[k].Data1, 1);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								Inc(k);
              end else if str = 'setguardstatus' then begin //--------52 setguardstatus
								if sl1.Count <> 2 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [setguardstatus] function error', [ScriptPath, lines]));
									exit;
								end;
                val(sl1.Strings[0], i, j);
								if j = 0 then begin
									if (i < 1) or (i > 8) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [setguardstatus] range error', [ScriptPath, lines]));
										exit;
									end;
								end;
                val(sl1.Strings[1], i, j);
								if j = 0 then begin
									if (i < 0) or (i > 1) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [setguardstatus] range error', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 52;
								SetLength(tn.Script[k].Data1, 2);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								tn.Script[k].Data1[1] := LowerCase(sl1.Strings[1]);
								Inc(k);
              end else if str = 'callguard' then begin //------- 53 callguard
								if sl1.Count <> 1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [callguard] function error', [ScriptPath, lines]));
									exit;
								end;
								val(sl1.Strings[0], i, j);
								if j = 0 then begin
									if (i < 1) or (i > 8) then begin
										DebugOut.Lines.Add(Format('%s %.4d: [callguard] range error', [ScriptPath, lines]));
										exit;
									end;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 53;
								SetLength(tn.Script[k].Data1, 1);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								Inc(k);
              end else if str = 'callmymob' then begin //------- 54 callmymob
								if sl1.Count <> 5 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [callmymob] function error', [ScriptPath, lines]));
									exit;
								end;

								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 54;
								SetLength(tn.Script[k].Data1, 5);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
                tn.Script[k].Data1[1] := LowerCase(sl1.Strings[1]);
                tn.Script[k].Data1[2] := LowerCase(sl1.Strings[2]);
                tn.Script[k].Data1[3] := LowerCase(sl1.Strings[3]);
                tn.Script[k].Data1[4] := LowerCase(sl1.Strings[4]);
								Inc(k);
              end else if str = 'resetguild' then begin //------- 55 resetguild
								if sl1.Count <> 0 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [resetguild] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 55;
								Inc(k);
              end else if str = 'guilddinvest' then begin //------- 56 guilddinvest
								if sl1.Count <> 0 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [guilddinvest] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 56;
								Inc(k);
              {end else if str = 'movenpc' then begin //------- 61 Move NPC
                                                                if sl1.Count <> 0 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [guilddinvest] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 61;
                                                                SetLength(tn.Script[k].Data1, 1);
								SetLength(tn.Script[k].Data3, 1);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
								Inc(k);}

							end else if str = 'script' then begin //------- 99 script
								if sl1.Count <> 1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [script] function error', [ScriptPath, lines]));
									exit;
								end;
								SetLength(tn.Script, k + 1);
								tn.Script[k].ID := 99;
								SetLength(tn.Script[k].Data1, 1);
								SetLength(tn.Script[k].Data3, 4);
								tn.Script[k].Data1[0] := LowerCase(sl1.Strings[0]);
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
								if sl1.Count <> 1 then begin
									DebugOut.Lines.Add(Format('%s %.4d: [scriptlabel] function error', [ScriptPath, lines]));
									exit;
								end;
								tn.ScriptLabel := LowerCase(sl1.Strings[0]);
							end;
						end;
						tn.ScriptCnt := k;
						for i := 0 to k - 1 do begin
							case tn.Script[i].ID of
							4,14,15,16,44:
								begin
									for j := 0 to tn.Script[i].DataCnt - 1 do begin
										if tn.Script[i].Data2[j] = '-' then begin //nopラベル
											tn.Script[i].Data3[j] := i + 1;
										end else if sl2.IndexOfName(tn.Script[i].Data2[j]) = -1 then begin
											DebugOut.Lines.Add(Format('%s : label "%s" not found', [ScriptPath, tn.Script[i].Data2[j]]));
											exit;
											//tn.Script[i].Data3[j] := $FFFF;
										end else begin
											tn.Script[i].Data3[j] := StrToInt(sl2.Values[tn.Script[i].Data2[j]]);
										end;
									end;
								end;
							5:
								begin
									if sl2.IndexOfName(tn.Script[i].Data1[0]) = -1 then begin
										DebugOut.Lines.Add(Format('%s : label "%s" not found', [ScriptPath, tn.Script[i].Data1[0]]));
										exit;
										//tn.Script[i].Data3[0] := $FFFF;
									end else begin
										tn.Script[i].Data3[0] := StrToInt(sl2.Values[tn.Script[i].Data1[0]]);
									end;
								end;
							end;
						end;

						if tn.ScriptLabel <> '' then tm.NPCLabel.AddObject(tn.ScriptLabel, tn);
						tm.NPC.AddObject(tn.ID, tn);
						tm.Block[tn.Point.X div 8][tn.Point.Y div 8].NPC.AddObject(tn.ID, tn);
						tm.gat[tn.Point.X][tn.Point.Y] := (tm.gat[tn.Point.X][tn.Point.Y] or $8);

						Inc(cnt[2]);
{d$0100fix5よりココまで}
	// モンスター ----------------------------------------------------------------
					end else if sl.Strings[1] = 'monster' then begin
						for i := sl.Count to 4 do sl.Add('0');
						ts0 := TMob.Create;
						ts0.Name := sl.Strings[2];
						//DebugOut.Lines.Add('-> adding mob ' + ts0.Name);
						ts0.Map := MapName;
						ts0.Point1.X := StrToInt(sl1.Strings[1]);
						ts0.Point1.Y := StrToInt(sl1.Strings[2]);
						ts0.Dir := 3;
						ts0.Point2.X := StrToInt(sl1.Strings[3]);
						ts0.Point2.Y := StrToInt(sl1.Strings[4]);
						sl1.DelimitedText := sl.Strings[3];
						for i := sl.Count to 4 do sl.Add('0');
						ts0.JID := StrToInt(sl1.Strings[0]);
						mcnt := StrToInt(sl1.Strings[1]);
						ts0.SpawnDelay1 := StrToInt(sl1.Strings[2]);
						ts0.SpawnDelay2 := StrToInt(sl1.Strings[3]);
						ts0.SpawnType := StrToInt(sl1.Strings[4]);
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

{追加}        if (ts.JID = 1288) then begin
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
{追加ココまで}
							j := 0;
							repeat
								ts.Point.X := ts.Point1.X + Random(ts.Point2.X + 1) - (ts.Point2.X div 2);
								ts.Point.Y := ts.Point1.Y + Random(ts.Point2.Y + 1) - (ts.Point2.Y div 2);
								//030317
								if (ts.Point.X < 0) or (ts.Point.X > tm.Size.X - 2) or (ts.Point.Y < 0) or (ts.Point.Y > tm.Size.Y - 2) then begin
									//DebugOut.Lines.Add(Format('***RandomRoute Error!! (%d,%d) %dx%d', [xy.X,xy.Y,tm.Size.X,tm.Size.Y]));
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
								ts.SpawnType := ts0.SpawnType;
								ts.SpawnTick := 0;
								if ts0.Data.isDontMove then
									ts.MoveWait := 4294967295
								else
                ts.MoveWait := Tick + 5000 + Cardinal(Random(10000));
								ts.ATarget := 0;
								ts.ATKPer := 100;
								ts.DEFPer := 100;
								ts.DmgTick := 0;
								ts.Data := ts0.Data;
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
{追加}					ts.Element := ts.Data.Element;
{追加}					ts.isActive := ts.Data.isActive;
                ts.EmperiumID := 0;
								tm.Mob.AddObject(ts.ID, ts);
								tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);
							end else begin
								ts.Free;
							end;

if (MonsterMob = true) then begin
    k := SlaveDBName.IndexOf(ts0.Data.Name);
    if (k <> -1) then begin
     ts.isLeader := true;
    end;
end;



						end;
						ts0.Free;
						Inc(cnt[3]);
					end;
				end;
			end;
		end;
		CloseFile(txt);
	end;
	//スクリプトのコピー
	for i1 := 0 to tm.NPC.Count - 1 do begin
		tn := tm.NPC.Objects[i1] as TNPC;
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
{NPCイベント追加}
			end else begin
				for i := 0 to tn.ScriptCnt - 1 do begin
					//callmobイベントチェック
					if (tn.Script[i].ID = 33) and (tn.Script[i].Data2[0] <> '') then begin
						k := 0;
						for j := 0 to tm.NPC.Count - 1 do begin
							tn1 := tm.NPC.Objects[j] as TNPC;
							if (tn1.Name = tn.Script[i].Data2[0]) and (tn1.JID = -1) then begin
								tn.Script[i].Data2[0] := IntToStr(tn1.ID);
								k := 1;
								break;
							end;
						end;
						if (k = 0) then begin
							//DebugOut.Lines.Add(Format('%s: [callmob] event not found', [tn.Script[i].Data2[0]]));
							tn.Script[i].Data2[0] := '';
						end;
					end;
				end;
			end;
{NPCイベント追加ココまで}
		end;
	end;

	//DebugOut.Lines.Add('WarpPoint: ' + IntToStr(cnt[0]));
	//DebugOut.Lines.Add('Shop: ' + IntToStr(cnt[1]));
	//DebugOut.Lines.Add('NPC: ' + IntToStr(cnt[2]));
	//DebugOut.Lines.Add('Monster: ' + IntToStr(cnt[3]));
	//DebugOut.Lines.Add('-> Map load success.');

	sl.Free;
	sl1.Free;
	sl2.Free;

	tm.Mode := 2;
end;
//------------------------------------------------------------------------------
procedure MapMove(Socket:TCustomWinSocket; MapName:string; Point:TPoint);
var
i,j,k :integer;
tm    :TMap;
tc1   :TChara;

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
function StealItem(tc:TChara; ts:TMob) :boolean;
var
  i,j,k :integer;
  mdrop :array[0..7] of integer;
  td    :TItemDB;
  modfix:integer;
  rand  :integer;
  tm    :TMap;
begin
  tm := tc.MData;
  modfix := (tc.Skill[50].Data.Data1[tc.Skill[50].Lv] + tc.Param[4] - ts.Data.Param[4]);
  modfix := modfix * StealMultiplier div 100;

  k := SlaveDBName.IndexOf(ts.Data.Name);
  if ((k <> -1) or (ts.Data.MEXP <> 0) or (ts.Stolen <> 0)) then begin
    Result := false;
    exit;
  end;

  for i := 0 to 7 do begin
    mdrop[i] := modfix * integer(ts.Data.Drop[i].Per) div 100;
    rand := Random(20000) mod 10000;
    DebugOut.Lines.Add(Format('Drop %d, modfix %d, mdrop %d, rand %d',[i,modfix,mdrop[i],rand]));
    if rand <= mdrop[i] then begin
                                     // Graphic send
                                     WFIFOW( 0, $011a);
                                     WFIFOW( 2, 50);
                                     WFIFOW( 4, 0);
                                     WFIFOL( 6, tc.ID);
                                     WFIFOL(10, tc.ID);
                                     WFIFOB(14, 1);
                                     SendBCmd(tm,ts.Point,15);

                                     k := ts.Data.Drop[i].Data.ID;
                                     td := ItemDB.IndexOfObject(k) as TItemDB;
                                     if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) then begin
                                      k := SearchCInventory(tc, td.ID, td.IEquip);
                                      if k <> 0 then begin
                                        if tc.Item[k].Amount < 30000 then begin
                                          //アイテム追加
                                          UpdateWeight(tc, k, td);

                                          tc.Socket.SendBuf(buf, 8);
                                          //アイテムゲット通知
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








//==============================================================================
// コンストラクタ、デストラクタ
{追加}
constructor TMob.Create;
var
	i :integer;
begin
	inherited;
	for i := 1 to 10 do
		Item[i] := TItem.Create;
  isSummon := False;
  isLooting := False;
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
{追加ここまで}
constructor TChara.Create;
var
	i :integer;
begin
	inherited;

	for i := 0 to MAX_SKILL_NUMBER do
		Skill[i] := TSkill.Create;
	for i := 1 to 100 do
		Item[i] := TItem.Create;
	Cart := TItemList.Create;
	Flag := TStringList.Create;

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

constructor TPlayer.Create;
begin
	inherited;
  Kafra := TItemList.Create;
  Kafra.MaxWeight := 4000000000;
end;

destructor TPlayer.Destroy;
begin
  Kafra.Free;
	inherited;
end;

constructor TBlock.Create;
begin
	inherited;

	NPC := TIntList32.Create;
	CList := TIntList32.Create;
	Mob := TIntList32.Create;
end;

destructor TBlock.Destroy;
begin
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
begin
	NPC.Free;
	NPCLabel.Free;
	CList.Free;
	Mob.Free;
{NPCイベント追加}
	TimerAct.Free;
	TimerDef.Free;
{NPCイベント追加ココまで}

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
	i :integer;
begin
	for i := 10000 to 10004 do
		GSkill[i].Free;
	GuildBanList.Free;
	RelAlliance.Free;
	RelHostility.Free;

	inherited;
end;
{ギルド機能追加ココまで}
//==============================================================================
end.
 
