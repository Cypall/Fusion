unit Game_Master;

interface

uses
    {Windows}
    {$IFDEF MSWINDOWS}
    MMSystem,
    {$ENDIF}
    {Kylix/Delphi CLX}
        {Need to finx CLX equiv of MMSystem (timeGetTime)}
    {Shared}
    IniFiles, Classes, SysUtils, StrUtils, Dialogs,
    {Fusion}
    Common, List32, Globals, PlayerData, WeissINI, ISCS, MonsterAI;

var
    GM_ALIVE : Byte;
    GM_ITEM : Byte;
    GM_SAVE : Byte;
    GM_RETURN : Byte;
    GM_DIE : Byte;
    GM_AUTO : Byte;
    GM_HCOLOR : Byte;
    GM_CCOLOR : Byte;
    GM_HSTYLE : Byte;
    GM_KILL : Byte;
    GM_GOTO : Byte;
    GM_SUMMON : Byte;
    GM_WARP : Byte;
    GM_BANISH : Byte;
    GM_JOB : Byte;
    GM_BLEVEL : Byte;
    GM_JLEVEL : Byte;
    GM_CHANGESTAT : Byte;
    GM_SKILLPOINT : Byte;
    GM_SKILLALL : Byte;
    GM_STATALL : Byte;
    GM_SUPERSTATS : Byte;
    GM_ZENY : Byte;
    GM_CHANGESKILL : Byte;
    GM_MONSTER : Byte;
    GM_SPEED : Byte;
    GM_WHOIS : Byte;
    GM_OPTION : Byte;
    GM_RAW : Byte;
    GM_UNIT : Byte;
    GM_STAT : Byte;
    GM_REFINE : Byte;
    GM_GLEVEL : Byte;
    GM_IRONICAL : Byte;
    GM_MOTHBALL : Byte;
    GM_WHERE : Byte;
    GM_REVIVE : Byte;
    GM_BAN : Byte;
    GM_KICK : Byte;
    GM_ICON : Byte;
    GM_UNICON : Byte;
    GM_SERVER : Byte;
    GM_PVPON : Byte;
    GM_PVPOFF : Byte;
    GM_GPVPON : Byte;
    GM_GPVPOFF : Byte;
    GM_NEWPLAYER : Byte;
    GM_PWORD : Byte;
    GM_USERS : Byte;
    GM_CHARBLEVEL : Byte;
    GM_CHARJLEVEL : Byte;
    GM_CHARSTATPOINT : Byte;
    GM_CHARSKILLPOINT : Byte;
    GM_CHANGES : Byte;
    GM_ISCSON : Byte;
    GM_ISCSOFF : Byte;
    GM_AUTOLOOT : Byte;
    GM_GSTORAGE : Byte;
    GM_RCON : Byte;
    GM_JAIL : Byte;
    GM_UNJAIL : Byte;
    GM_CALL_MERCENARY : Byte;
    GM_EMAIL : Byte;

    GM_AEGIS_B : Byte;
    GM_AEGIS_NB : Byte;
    GM_AEGIS_BB : Byte;
    GM_AEGIS_ITEM : Byte;
    GM_AEGIS_MONSTER : Byte;
    GM_AEGIS_HIDE : Byte;
    GM_AEGIS_RESETSTATE : Byte;
    GM_AEGIS_RESETSKILL : Byte;

    GM_ATHENA_HEAL : Byte;
    GM_ATHENA_KAMI : Byte;
    GM_ATHENA_ALIVE : Byte;
    GM_ATHENA_SAVE : Byte;
    GM_ATHENA_LOAD : Byte;
    GM_ATHENA_KILL : Byte;
    GM_ATHENA_DIE : Byte;
    GM_ATHENA_JOBCHANGE : Byte;
    GM_ATHENA_HIDE : Byte;
    GM_ATHENA_OPTION : Byte;
    GM_ATHENA_STORAGE : Byte;
    GM_ATHENA_SPEED : Byte;
    GM_ATHENA_WHOMAP3 : Byte;
    GM_ATHENA_WHOMAP2 : Byte;
    GM_ATHENA_WHOMAP : Byte;
    GM_ATHENA_WHO3 : Byte;
    GM_ATHENA_WHO2 : Byte;
    GM_ATHENA_WHO : Byte;
    GM_ATHENA_JUMP : Byte;
    GM_ATHENA_JUMPTO : Byte;
    GM_ATHENA_WHERE : Byte;
    GM_ATHENA_RURA : Byte;
    GM_ATHENA_WARP : Byte;
    GM_ATHENA_RURAP : Byte;
    GM_ATHENA_SEND : Byte;
    GM_ATHENA_WARPP : Byte;
    GM_ATHENA_CHARWARP : Byte;
    GM_ATHENA_H : Byte;
    GM_ATHENA_HELP : Byte;
    GM_ATHENA_ZENY : Byte;
    GM_ATHENA_BASELVLUP : Byte;
    GM_ATHENA_LVUP : Byte;
    GM_ATHENA_JOBLVLUP : Byte;
    GM_ATHENA_JOBLVUP : Byte;
    GM_ATHENA_SKPOINT :  Byte;
    GM_ATHENA_STPOINT : Byte;
    GM_ATHENA_STR : Byte;
    GM_ATHENA_AGI : Byte;
    GM_ATHENA_VIT : Byte;
    GM_ATHENA_INT : Byte;
    GM_ATHENA_DEX : Byte;
    GM_ATHENA_LUK : Byte;
    GM_ATHENA_SPIRITBALL : Byte;
    GM_ATHENA_QUESTSKILL : Byte;
    GM_ATHENA_LOSTSKILL : Byte;
    GM_ATHENA_MODEL : Byte;
    GM_ATHENA_ITEM2 : Byte;
    GM_ATHENA_ITEM : Byte;
    GM_ATHENA_DOOM : Byte;
    GM_ATHENA_KICK : Byte;
    GM_ATHENA_KICKALL : Byte;
    GM_ATHENA_RAISE : Byte;
    GM_ATHENA_RAISEMAP : Byte;


    GM_Access_DB : TIntList32;

    procedure load_commands();
    procedure save_commands();

    procedure parse_commands(tc : TChara; str : String);
    function check_level(tc : TChara; cmd : Integer) : Boolean;
    procedure error_message(tc : TChara; str : String);
    procedure save_gm_log(tc : TChara; str : String);

    function command_alive(tc : TChara) : String;
    function command_item(tc : TChara; str : String) : String;
    function command_save(tc : TChara) : String;
    function command_return(tc : TChara) : String;
    function command_die(tc : TChara) : String;
    function command_auto(tc : TChara; str : String) : String;
    function command_hcolor(tc : TChara; str : String) : String;
    function command_ccolor(tc : TChara; str : String) : String;
    function command_hstyle(tc : TChara; str : String) : String;
    function command_kill(str : String) : String;
    function command_goto(tc : TChara; str : String) : String;
    function command_summon(tc : TChara; str : String) : String;
    function command_warp(tc : TChara; str : String) : String;
    function command_banish(str : String) : String;
    function command_job(tc : TChara; str : String) : String;
    function command_blevel(tc : TChara; str : String) : String;
    function command_jlevel(tc : TChara; str : String) : String;
    function command_changestat(tc : TChara; str : String) : String;
    function command_skillpoint(tc : TChara; str : String) : String;
    function command_skillall(tc : TChara) : String;
    function command_statall(tc : TChara) : String;
    function command_superstats(tc : TChara) : String;
    function command_zeny(tc : TChara; str : String) : String;
    function command_changeskill(tc : TChara; str : String) : String;
    function command_monster(tc : TChara; str : String) : String;
    function command_speed(tc : TChara; str : String) : String;
    function command_whois(tc : TChara) : String;
    function command_option(tc : TChara; str : String) : String;
    function command_raw(tc : TChara; str : String) : String;
    function command_unit(tc : TChara; str : String) : String;
    function command_stat(tc : TChara; str : String) : String;
    function command_refine(tc : TChara; str : String) : String;
    function command_glevel(tc : TChara; str : String) : String;
    function command_ironical(tc : TChara) : String;
    function command_mothball(tc : TChara) : String;
    function command_where(tc : TChara; str : String) : String;
    function command_revive(str : String) : String;
    function command_ban(str : String) : String;
    function command_kick(str : String) : String;
    function command_icon(tc : TChara; str : String) : String;
    function command_unicon(tc : TChara; str : String) : String;
    function command_server() : String;
    function command_pvpon(tc : TChara) : String;
    function command_pvpoff(tc : TChara) : String;
    function command_gpvpon(tc : TChara) : String;
    function command_gpvpoff(tc : TChara) : String;
    function command_newplayer(str : String) : String;
    function command_pword(tc : TChara; str : String) : String;
    function command_users() : String;
    function command_charblevel(tc : TChara; str : String) : String;
    function command_charjlevel(tc : TChara; str : String) : String;
    function command_charstatpoint(tc : TChara; str : String) : String;
    function command_charskillpoint(tc : TChara; str : String) : String;
    function command_changes(tc : TChara; str : String) : String;
    function command_iscson(tc : TChara) : String;
    function command_iscsoff(tc : TChara) : String;
    function command_autoloot(tc : TChara) : String;
    function command_gstorage(tc : TChara) : String;
    function command_rcon(str : String) : String;
    function command_jail(tc : TChara; str : String) : String;
    function command_unjail(tc: TChara; str : String) : String;
    function command_call_mercenary(tc : TChara; str : String) : String;
    function command_email(tc : TChara; str : String) : String;

    function command_aegis_b(str : String) : String;
    function command_aegis_bb(tc : TChara; str : String) : String;
    function command_aegis_nb(str : String) : String;
    function command_aegis_item(tc : TChara; str : String) : String;
    function command_aegis_monster(tc : TChara; str : String) : String;
    function command_aegis_hide(tc : TChara) : String;
    function command_aegis_resetstate(tc : TChara; str : String) : String;
    function command_aegis_resetskill(tc : Tchara; str : String) : String;

    function command_athena_heal(tc : TChara; str : String) : String;
    function command_athena_kami(tc : TChara; str : String) : String;
    function command_athena_alive(tc : TChara) : String;
    function command_athena_save(tc : TChara) : String;
    function command_athena_load(tc : TChara) : String;
    function command_athena_kill(tc: TChara; str : String) : String;
    function command_athena_die(tc : TChara) : String;
    function command_athena_jobchange(tc : TChara; str : String) : String;
    function command_athena_hide(tc : TChara) : String;
    function command_athena_option(tc : TChara; str : String) : String;
    function command_athena_storage(tc : TChara) : String;
    function command_athena_speed(tc : TChara; str : String) : String;
    function command_athena_whomap3(tc : TChara; str : String) : String;
    function command_athena_whomap2(tc : TChara; str : String) : String;
    function command_athena_whomap(tc : TChara; str : String) : String;
    function command_athena_who3(tc : TChara; str : String) : String;
    function command_athena_who2(tc : TChara; str : String) : String;
    function command_athena_who(tc : TChara; str : String) : String;
    function command_athena_jump(tc : TChara; str : String) : String;
    function command_athena_jumpto(tc : TChara; str : String) : String;
    function command_athena_where(tc : TChara; str : String) : String;
    function command_athena_rura(tc : TChara; str : String) : String;
    function command_athena_warp(tc : TChara; str : String) : String;
    function command_athena_rurap(tc : Tchara; str : String) : String;
    function command_athena_send(tc : TChara; str : String) : String;
    function command_athena_warpp(tc : TChara; str : String) : String;
    function command_athena_charwarp(tc : TChara; str : String) : String;
    function command_athena_h(tc : TChara; str : String) : String;
    function command_athena_help(tc : TChara; str : String) : String;
    function command_athena_zeny(tc : TChara; str : String) : String;
    function command_athena_baselvlup(tc : TChara; str : String) : String;
    function command_athena_lvup(tc : TChara; str : String) : String;
    function command_athena_joblvlup(tc : TChara; str : String) : String;
    function command_athena_joblvup(tc : TChara; str : String) : String;
    function command_athena_skpoint(tc : TChara; str : String) : String;
    function command_athena_stpoint(tc : Tchara; str : String) : String;
    function command_athena_str(tc : TChara; str : String) : String;
    function command_athena_agi(tc : TChara; str : String) : String;
    function command_athena_vit(tc : TChara; str : String) : String;
    function command_athena_int(tc : TChara; str : String) : String;
    function command_athena_dex(tc : TChara; str : String) : String;
    function command_athena_luk(tc : TChara; str : String) : String;
    function command_athena_spiritball(tc : TChara; str : String) : String;
    function command_athena_questskill(tc : TChara; str : String) : String;
    function command_athena_lostskill(tc : TChara; str : String) : String;
    function command_athena_model(tc : TChara; str : String) : String;
    function command_athena_item2(tc : TChara; str : String) : String;
    function command_athena_item(tc : TChara; str : String) : String;
    function command_athena_doom(tc : TChara) : String;
    function command_athena_kick(tc : TChara; str : String) : String;
    function command_athena_kickall(tc : TChara) : String;
    function command_athena_raise(tc : TChara) : String;
    function command_athena_raisemap(tc : TChara) : String;


implementation

    procedure load_commands();
    var
        ini : TIniFile;
        sl : TStringList;
    begin
        ini := TIniFile.Create(AppPath + 'gm_commands.ini');
        sl := TStringList.Create();
        sl.Clear;
        ini.ReadSectionValues('Fusion GM Commands', sl);

        GM_ALIVE := StrToIntDef(sl.Values['ALIVE'], 1);
        GM_ITEM := StrToIntDef(sl.Values['ITEM'], 1);
        GM_SAVE := StrToIntDef(sl.Values['SAVE'], 1);
        GM_RETURN := StrToIntDef(sl.Values['RETURN'], 1);
        GM_DIE := StrToIntDef(sl.Values['DIE'], 1);
        GM_AUTO := StrToIntDef(sl.Values['AUTO'], 1);
        GM_HCOLOR := StrToIntDef(sl.Values['HCOLOR'], 1);
        GM_CCOLOR := StrToIntDef(sl.Values['CCOLOR'], 1);
        GM_HSTYLE := StrToIntDef(sl.Values['HSTYLE'], 1);
        GM_KILL := StrToIntDef(sl.Values['KILL'], 1);
        GM_GOTO := StrToIntDef(sl.Values['GOTO'], 1);
        GM_SUMMON := StrToIntDef(sl.Values['SUMMON'], 1);
        GM_WARP := StrToIntDef(sl.Values['WARP'], 1);
        GM_BANISH := StrToIntDef(sl.Values['BANISH'], 1);
        GM_JOB := StrToIntDef(sl.Values['JOB'], 1);
        GM_BLEVEL := StrToIntDef(sl.Values['BLEVEL'], 1);
        GM_JLEVEL := StrToIntDef(sl.Values['JLEVEL'], 1);
        GM_CHANGESTAT := StrToIntDef(sl.Values['CHANGESTAT'], 1);
        GM_SKILLPOINT := StrToIntDef(sl.Values['SKILLPOINT'], 1);
        GM_SKILLALL := StrToIntDef(sl.Values['SKILLALL'], 1);
        GM_STATALL := StrToIntDef(sl.Values['STATALL'], 1);
        GM_SUPERSTATS := StrToIntDef(sl.Values['SUPERSTATS'], 1);
        GM_ZENY := StrToIntDef(sl.Values['ZENY'], 1);
        GM_CHANGESKILL := StrToIntDef(sl.Values['CHANGESKILL'], 1);
        GM_MONSTER := StrToIntDef(sl.Values['MONSTER'], 1);
        GM_SPEED := StrToIntDef(sl.Values['SPEED'], 1);
        GM_WHOIS := StrToIntDef(sl.Values['WHOIS'], 1);
        GM_OPTION := StrToIntDef(sl.Values['OPTION'], 1);
        GM_RAW := StrToIntDef(sl.Values['RAW'], 1);
        GM_UNIT := StrToIntDef(sl.Values['UNIT'], 1);
        GM_STAT := StrToIntDef(sl.Values['STAT'], 1);
        GM_REFINE := StrToIntDef(sl.Values['REFINE'], 1);
        GM_GLEVEL := StrToIntDef(sl.Values['GLEVEL'], 1);
        GM_IRONICAL := StrToIntDef(sl.Values['IRONICAL'], 1);
        GM_MOTHBALL := StrToIntDef(sl.Values['MOTHBALL'], 1);
        GM_WHERE := StrToIntDef(sl.Values['WHERE'], 1);
        GM_REVIVE := StrToIntDef(sl.Values['REVIVE'], 1);
        GM_BAN := StrToIntDef(sl.Values['BAN'], 1);
        GM_KICK := StrToIntDef(sl.Values['KICK'], 1);
        GM_ICON := StrToIntDef(sl.Values['ICON'], 1);
        GM_UNICON := StrToIntDef(sl.Values['UNICON'], 1);
        GM_SERVER := StrToIntDef(sl.Values['SERVER'], 0);
        GM_PVPON := StrToIntDef(sl.Values['PVPON'], 1);
        GM_PVPOFF := StrToIntDef(sl.Values['PVPOFF'], 1);
        GM_GPVPON := StrToIntDef(sl.Values['GPVPON'], 1);
        GM_GPVPOFF := StrToIntDef(sl.Values['GPVPOFF'], 1);
        GM_NEWPLAYER := StrToIntDef(sl.Values['NEWPLAYER'], 1);
        GM_PWORD := StrToIntDef(sl.Values['PWORD'], 0);
        GM_USERS := StrToIntDef(sl.Values['USERS'], 0);
        GM_CHARBLEVEL := StrToIntDef(sl.Values['CHARBLEVEL'], 1);
        GM_CHARJLEVEL := StrToIntDef(sl.Values['CHARJLEVEL'], 1);
        GM_CHARSTATPOINT := StrToIntDef(sl.Values['CHARSTATPOINT'], 1);
        GM_CHARSKILLPOINT := StrToIntDef(sl.Values['CHARSKILLPOINT'], 1);
        GM_CHANGES := StrToIntDef(sl.Values['CHANGES'], 0);
        GM_ISCSON := StrToIntDef(sl.Values['ISCSON'], 0);
        GM_ISCSOFF := StrToIntDef(sl.Values['ISCSOFF'], 0);
        GM_AUTOLOOT := StrToIntDef(sl.Values['AUTOLOOT'], 1);
        GM_GSTORAGE := StrToIntDef(sl.Values['GSTORAGE'], 1);
        GM_RCON := StrToIntDef(sl.Values['RCON'], 1);
        GM_JAIL := StrToIntDef(sl.Values['JAIL'], 1);
        GM_UNJAIL := StrToIntDef(sl.Values['UNJAIL'], 1);
        GM_CALL_MERCENARY := StrToIntDef(sl.Values['CALL_MERCENARY'], 1);
        GM_EMAIL := StrToIntDef(sl.Values['EMAIL'], 0);

        ini.ReadSectionValues('Aegis GM Commands', sl);

        GM_AEGIS_B := StrToIntDef(sl.Values['AEGIS_B'], 1);
        GM_AEGIS_NB := StrToIntDef(sl.Values['AEGIS_NB'], 1);
        GM_AEGIS_BB := StrToIntDef(sl.Values['AEGIS_BB'], 1);
        GM_AEGIS_ITEM := StrToIntDef(sl.Values['AEGIS_ITEM'], 1);
        GM_AEGIS_MONSTER := StrToIntDef(sl.Values['AEGIS_MONSTER'], 1);
        GM_AEGIS_HIDE := StrToIntDef(sl.Values['AEGIS_HIDE'], 1);
        GM_AEGIS_RESETSTATE := StrToIntDef(sl.Values['AEGIS_RESETSTATE'], 1);
        GM_AEGIS_RESETSKILL := StrToIntDef(sl.Values['AEGIS_RESETSKILL'], 1);

        ini.ReadSectionValues('Athena GM Commands', sl);

        GM_ATHENA_HEAL := StrToIntDef(sl.Values['ATHENA_HEAL'], 1);
        GM_ATHENA_KAMI := StrToIntDef(sl.Values['ATHENA_KAMI'], 1);
        GM_ATHENA_ALIVE := StrToIntDef(sl.Values['ATHENA_ALIVE'], 1);
        GM_ATHENA_SAVE := StrToIntDef(sl.Values['ATHENA_SAVE'], 1);
        GM_ATHENA_LOAD := StrToIntDef(sl.Values['ATHENA_LOAD'], 1);
        GM_ATHENA_KILL := StrToIntDef(sl.Values['ATHENA_KILL'], 1);
        GM_ATHENA_DIE := StrToIntDef(sl.Values['ATHENA_DIE'], 1);
        GM_ATHENA_JOBCHANGE := StrToIntDef(sl.Values['ATHENA_JOBCHANGE'], 1);
        GM_ATHENA_HIDE := StrToIntDef(sl.Values['ATHENA_HIDE'], 1);
        GM_ATHENA_OPTION := StrToIntDef(sl.Values['ATHENA_OPTION'], 1);
        GM_ATHENA_STORAGE := StrToIntDef(sl.Values['ATHENA_STORAGE'], 1);
        GM_ATHENA_SPEED := StrToIntDef(sl.Values['ATHENA_SPEED'], 1);
        GM_ATHENA_WHOMAP3 := StrToIntDef(sl.Values['ATHENA_WHOMAP3'], 1);
        GM_ATHENA_WHOMAP2 := StrToIntDef(sl.Values['ATHENA_WHOMAP2'], 1);
        GM_ATHENA_WHOMAP := StrToIntDef(sl.Values['ATHENA_WHOMAP'], 1);
        GM_ATHENA_WHO3 := StrToIntDef(sl.Values['ATHENA_WHO3'], 1);
        GM_ATHENA_WHO2 := StrToIntDef(sl.Values['ATHENA_WHO2'], 1);
        GM_ATHENA_WHO := StrToIntDef(sl.Values['ATHENA_WHO'], 1);
        GM_ATHENA_JUMP := StrToIntDef(sl.Values['ATHENA_JUMP'], 1);
        GM_ATHENA_JUMPTO := StrToIntDef(sl.Values['ATHENA_JUMPTO'], 1);
        GM_ATHENA_WHERE := StrToIntDef(sl.Values['ATHENA_WHERE'], 1);
        GM_ATHENA_RURA := StrToIntDef(sl.Values['ATHENA_RURA'], 1);
        GM_ATHENA_WARP := StrToIntDef(sl.Values['ATHENA_WARP'], 1);
        GM_ATHENA_RURAP := StrToIntDef(sl.Values['ATHENA_RURAP'], 1);
        GM_ATHENA_SEND := StrToIntDef(sl.Values['ATHENA_SEND'], 1);
        GM_ATHENA_WARPP := StrToIntDef(sl.Values['ATHENA_WARPP'], 1);
        GM_ATHENA_CHARWARP := StrToIntDef(sl.Values['ATHENA_CHARWARP'], 1);
        GM_ATHENA_H := StrToIntDef(sl.Values['ATHENA_H'], 1);
        GM_ATHENA_HELP := StrToIntDef(sl.Values['ATHENA_HELP'], 1);
        GM_ATHENA_ZENY := StrToIntDef(sl.Values['ATHENA_ZENY'], 1);
        GM_ATHENA_BASELVLUP := StrToIntDef(sl.Values['ATHENA_BASELVLUP'], 1);
        GM_ATHENA_LVUP := StrToIntDef(sl.Values['ATHENA_LVUP'], 1);
        GM_ATHENA_JOBLVLUP := StrToIntDef(sl.Values['ATHENA_JOBLVLUP'], 1);
        GM_ATHENA_JOBLVUP := StrToIntDef(sl.Values['ATHENA_JOBLVUP'], 1);
        GM_ATHENA_SKPOINT := StrToIntDef(sl.Values['ATHENA_SKPOINT'], 1);
        GM_ATHENA_STPOINT := StrToIntDef(sl.Values['ATHENA_STPOINT'], 1);
        GM_ATHENA_STR := StrToIntDef(sl.Values['ATHENA_STR'], 1);
        GM_ATHENA_AGI := StrToIntDef(sl.Values['ATHENA_AGI'], 1);
        GM_ATHENA_VIT := StrToIntDef(sl.Values['ATHENA_VIT'], 1);
        GM_ATHENA_INT := StrToIntDef(sl.Values['ATHENA_INT'], 1);
        GM_ATHENA_DEX := StrToIntDef(sl.Values['ATHENA_DEX'], 1);
        GM_ATHENA_LUK := StrToIntDef(sl.Values['ATHENA_LUK'], 1);
        GM_ATHENA_SPIRITBALL := StrToIntDef(sl.Values['ATHENA_SPIRITBALL'], 1);
        GM_ATHENA_QUESTSKILL := StrToIntDef(sl.Values['ATHENA_QUESTSKILL'], 1);
        GM_ATHENA_LOSTSKILL := StrToIntDef(sl.Values['ATHENA_LOSTSKILL'], 1);
        GM_ATHENA_MODEL := StrToIntDef(sl.Values['ATHENA_MODEL'], 1);
        GM_ATHENA_ITEM2 := StrToIntDef(sl.Values['ATHENA_ITEM2'], 1);
        GM_ATHENA_ITEM := StrToIntDef(sl.Values['ATHENA_ITEM'], 1);
        GM_ATHENA_DOOM := StrToIntDef(sl.Values['ATHENA_DOOM'], 1);
        GM_ATHENA_KICK := StrToIntDef(sl.Values['ATHENA_KICK'], 1);
        GM_ATHENA_KICKALL := StrToIntDef(sl.Values['ATHENA_KICKALL'], 1);
        GM_ATHENA_RAISE := StrToIntDef(sl.Values['ATHENA_RAISE'], 1);
        GM_ATHENA_RAISEMAP := StrToIntDef(sl.Values['ATHENA_RAISEMAP'], 1);

        sl.Free;
        ini.Free;

        GM_Access_DB := TIntList32.Create;
    end;


(*-----------------------------------------------------------------------------*
Called when we're shutting down the server *only*
- Writes settings to GM_Commands.ini
- Also Frees up GM_AccessDB list.

2004/06/02 - ChrstphrR - added in List Free-up code so that no memory is leaked.
*-----------------------------------------------------------------------------*)
    Procedure save_commands();
    Var
        ini : TIniFile;

    Begin
        ini := TIniFile.Create(AppPath + 'gm_commands.ini');

        try
            ini.WriteString('Fusion GM Commands', 'ALIVE', IntToStr(GM_ALIVE));
            ini.WriteString('Fusion GM Commands', 'ITEM', IntToStr(GM_ITEM));
            ini.WriteString('Fusion GM Commands', 'SAVE', IntToStr(GM_SAVE));
            ini.WriteString('Fusion GM Commands', 'RETURN', IntToStr(GM_RETURN));
            ini.WriteString('Fusion GM Commands', 'DIE', IntToStr(GM_DIE));
            ini.WriteString('Fusion GM Commands', 'AUTO', IntToStr(GM_AUTO));
            ini.WriteString('Fusion GM Commands', 'HCOLOR', IntToStr(GM_HCOLOR));
            ini.WriteString('Fusion GM Commands', 'CCOLOR', IntToStr(GM_CCOLOR));
            ini.WriteString('Fusion GM Commands', 'HSTYLE', IntToStr(GM_HSTYLE));
            ini.WriteString('Fusion GM Commands', 'KILL', IntToStr(GM_KILL));
            ini.WriteString('Fusion GM Commands', 'GOTO', IntToStr(GM_GOTO));
            ini.WriteString('Fusion GM Commands', 'SUMMON', IntToStr(GM_SUMMON));
            ini.WriteString('Fusion GM Commands', 'WARP', IntToStr(GM_WARP));
            ini.WriteString('Fusion GM Commands', 'BANISH', IntToStr(GM_BANISH));
            ini.WriteString('Fusion GM Commands', 'JOB', IntToStr(GM_JOB));
            ini.WriteString('Fusion GM Commands', 'BLEVEL', IntToStr(GM_BLEVEL));
            ini.WriteString('Fusion GM Commands', 'JLEVEL', IntToStr(GM_JLEVEL));
            ini.WriteString('Fusion GM Commands', 'CHANGESTAT', IntToStr(GM_CHANGESTAT));
            ini.WriteString('Fusion GM Commands', 'SKILLPOINT', IntToStr(GM_SKILLPOINT));
            ini.WriteString('Fusion GM Commands', 'SKILLALL', IntToStr(GM_SKILLALL));
            ini.WriteString('Fusion GM Commands', 'STATALL', IntToStr(GM_STATALL));
            ini.WriteString('Fusion GM Commands', 'SUPERSTATS', IntToStr(GM_SUPERSTATS));
            ini.WriteString('Fusion GM Commands', 'ZENY', IntToStr(GM_ZENY));
            ini.WriteString('Fusion GM Commands', 'CHANGESKILL', IntToStr(GM_CHANGESKILL));
            ini.WriteString('Fusion GM Commands', 'MONSTER', IntToStr(GM_MONSTER));
            ini.WriteString('Fusion GM Commands', 'SPEED', IntToStr(GM_SPEED));
            ini.WriteString('Fusion GM Commands', 'WHOIS', IntToStr(GM_WHOIS));
            ini.WriteString('Fusion GM Commands', 'OPTION', IntToStr(GM_OPTION));
            ini.WriteString('Fusion GM Commands', 'RAW', IntToStr(GM_RAW));
            ini.WriteString('Fusion GM Commands', 'UNIT', IntToStr(GM_UNIT));
            ini.WriteString('Fusion GM Commands', 'STAT', IntToStr(GM_STAT));
            ini.WriteString('Fusion GM Commands', 'REFINE', IntToStr(GM_REFINE));
            ini.WriteString('Fusion GM Commands', 'GLEVEL', IntToStr(GM_GLEVEL));
            ini.WriteString('Fusion GM Commands', 'IRONICAL', IntToStr(GM_IRONICAL));
            ini.WriteString('Fusion GM Commands', 'MOTHBALL', IntToStr(GM_MOTHBALL));
            ini.WriteString('Fusion GM Commands', 'WHERE', IntToStr(GM_WHERE));
            ini.WriteString('Fusion GM Commands', 'REVIVE', IntToStr(GM_REVIVE));
            ini.WriteString('Fusion GM Commands', 'BAN', IntToStr(GM_BAN));
            ini.WriteString('Fusion GM Commands', 'KICK', IntToStr(GM_KICK));
            ini.WriteString('Fusion GM Commands', 'ICON', IntToStr(GM_ICON));
            ini.WriteString('Fusion GM Commands', 'UNICON', IntToStr(GM_UNICON));
            ini.WriteString('Fusion GM Commands', 'SERVER', IntToStr(GM_SERVER));
            ini.WriteString('Fusion GM Commands', 'PVPON', IntToStr(GM_PVPON));
            ini.WriteString('Fusion GM Commands', 'PVPOFF', IntToStr(GM_PVPOFF));
            ini.WriteString('Fusion GM Commands', 'GPVPON', IntToStr(GM_GPVPON));
            ini.WriteString('Fusion GM Commands', 'GPVPOFF', IntToStr(GM_GPVPOFF));
            ini.WriteString('Fusion GM Commands', 'NEWPLAYER', IntToStr(GM_NEWPLAYER));
            ini.WriteString('Fusion GM Commands', 'PWORD', IntToStr(GM_PWORD));
            ini.WriteString('Fusion GM Commands', 'USERS', IntToStr(GM_USERS));
            ini.WriteString('Fusion GM Commands', 'CHARBLEVEL', IntToStr(GM_CHARBLEVEL));
            ini.WriteString('Fusion GM Commands', 'CHARJLEVEL', IntToStr(GM_CHARJLEVEL));
            ini.WriteString('Fusion GM Commands', 'CHARSTATPOINT', IntToStr(GM_CHARSTATPOINT));
            ini.WriteString('Fusion GM Commands', 'CHARSKILLPOINT', IntToStr(GM_CHARSKILLPOINT));
            ini.WriteString('Fusion GM Commands', 'CHANGES', IntToStr(GM_CHANGES));
            ini.WriteString('Fusion GM Commands', 'ISCSON', IntToStr(GM_ISCSON));
            ini.WriteString('Fusion GM Commands', 'ISCSOFF', IntToStr(GM_ISCSOFF));
            ini.WriteString('Fusion GM Commands', 'AUTOLOOT', IntToStr(GM_AUTOLOOT));
            ini.WriteString('Fusion GM Commands', 'GSTORAGE', IntToStr(GM_GSTORAGE));
            ini.WriteString('Fusion GM Commands', 'RCON', IntToStr(GM_RCON));
            ini.WriteString('Fusion GM Commands', 'JAIL', IntToStr(GM_JAIL));
            ini.WriteString('Fusion GM Commands', 'UNJAIL', IntToStr(GM_UNJAIL));
            // Placeholder for CALL_MERCENARY command.
            ini.WriteString('Fusion GM Commands', 'EMAIL', IntToStr(GM_EMAIL));

            ini.WriteString('Aegis GM Commands', 'AEGIS_B', IntToStr(GM_AEGIS_B));
            ini.WriteString('Aegis GM Commands', 'AEGIS_NB', IntToStr(GM_AEGIS_NB));
            ini.WriteString('Aegis GM Commands', 'AEGIS_BB', IntToStr(GM_AEGIS_BB));
            ini.WriteString('Aegis GM Commands', 'AEGIS_ITEM', IntToStr(GM_AEGIS_ITEM));
            ini.WriteString('Aegis GM Commands', 'AEGIS_MONSTER', IntToStr(GM_AEGIS_MONSTER));
            ini.WriteString('Aegis GM Commands', 'AEGIS_HIDE', IntToStr(GM_AEGIS_HIDE));
            ini.WriteString('Aegis GM Commands', 'AEGIS_RESETSTATE', IntToStr(GM_AEGIS_RESETSTATE));
            ini.WriteString('Aegis GM Commands', 'AEGIS_RESETSKILL', IntToStr(GM_AEGIS_RESETSKILL));

            ini.WriteString('Athena GM Commands', 'ATHENA_HEAL', IntToStr(GM_ATHENA_HEAL));
            ini.WriteString('Athena GM Commands', 'ATHENA_KAMI', IntToStr(GM_ATHENA_KAMI));
            ini.WriteString('Athena GM Commands', 'ATHENA_ALIVE', IntToStr(GM_ATHENA_ALIVE));
            ini.WriteString('Athena GM Commands', 'ATHENA_SAVE', IntToStr(GM_ATHENA_SAVE));
            ini.WriteString('Athena GM Commands', 'ATHENA_LOAD', IntToStr(GM_ATHENA_LOAD));
            ini.WriteString('Athena GM Commands', 'ATHENA_KILL', IntToStr(GM_ATHENA_KILL));
            ini.WriteString('Athena GM Commands', 'ATHENA_DIE', IntToStr(GM_ATHENA_DIE));
            ini.WriteString('Athena GM Commands', 'ATHENA_JOBCHANGE', IntToStr(GM_ATHENA_JOBCHANGE));
            ini.WriteString('Athena GM Commands', 'ATHENA_HIDE', IntToStr(GM_ATHENA_HIDE));
            ini.WriteString('Athena GM Commands', 'ATHENA_OPTION', IntToStr(GM_ATHENA_OPTION));
            ini.WriteString('Athena GM Commands', 'ATHENA_STORAGE', IntToStr(GM_ATHENA_STORAGE));
            ini.WriteString('Athena GM Commands', 'ATHENA_SPEED', IntToStr(GM_ATHENA_SPEED));
            ini.WriteString('Athena GM Commands', 'ATHENA_WHOMAP3', IntToStr(GM_ATHENA_WHOMAP3));
            ini.WriteString('Athena GM Commands', 'ATHENA_WHOMAP2', IntToStr(GM_ATHENA_WHOMAP2));
            ini.WriteString('Athena GM Commands', 'ATHENA_WHOMAP', IntToStr(GM_ATHENA_WHOMAP));
            ini.WriteString('Athena GM Commands', 'ATHENA_WHO3', IntToStr(GM_ATHENA_WHO3));
            ini.WriteString('Athena GM Commands', 'ATHENA_WHO2', IntToStr(GM_ATHENA_WHO2));
            ini.WriteString('Athena GM Commands', 'ATHENA_WHO', IntToStr(GM_ATHENA_WHO));
            ini.WriteString('Athena GM Commands', 'ATHENA_JUMP', IntToStr(GM_ATHENA_JUMP));
            ini.WriteString('Athena GM Commands', 'ATHENA_JUMPTO', IntToStr(GM_ATHENA_JUMPTO));
            ini.WriteString('Athena GM Commands', 'ATHENA_WHERE', IntToStr(GM_ATHENA_WHERE));
            ini.WriteString('Athena GM Commands', 'ATHENA_RURA', IntToStr(GM_ATHENA_RURA));
            ini.WriteString('Athena GM Commands', 'ATHENA_WARP', IntToStr(GM_ATHENA_WARP));
            ini.WriteString('Athena GM Commands', 'ATHENA_RURAP', IntToStr(GM_ATHENA_RURAP));
            ini.WriteString('Athena GM Commands', 'ATHENA_SEND', IntToStr(GM_ATHENA_SEND));
            ini.WriteString('Athena GM Commands', 'ATHENA_WARPP', IntToStr(GM_ATHENA_WARPP));
            ini.WriteString('Athena GM Commands', 'ATHENA_CHARWARP', IntToStr(GM_ATHENA_CHARWARP));
            ini.WriteString('Athena GM Commands', 'ATHENA_H', IntToStr(GM_ATHENA_H));
            ini.WriteString('Athena GM Commands', 'ATHENA_HELP', IntToStr(GM_ATHENA_HELP));
            ini.WriteString('Athena GM Commands', 'ATHENA_ZENY', IntToStr(GM_ATHENA_ZENY));
            ini.WriteString('Athena GM Commands', 'ATHENA_BASELVLUP', IntToStr(GM_ATHENA_BASELVLUP));
            ini.WriteString('Athena GM Commands', 'ATHENA_LVUP', IntToStr(GM_ATHENA_LVUP));
            ini.WriteString('Athena GM Commands', 'ATHENA_JOBLVLUP', IntToStr(GM_ATHENA_JOBLVLUP));
            ini.WriteString('Athena GM Commands', 'ATHENA_JOBLVUP', IntToStr(GM_ATHENA_JOBLVUP));
            ini.WriteString('Athena GM Commands', 'ATHENA_SKPOINT', IntToStr(GM_ATHENA_SKPOINT));
            ini.WriteString('Athena GM Commands', 'ATHENA_STPOINT', IntToStr(GM_ATHENA_STPOINT));
            ini.WriteString('Athena GM Commands', 'ATHENA_STR', IntToStr(GM_ATHENA_STR));
            ini.WriteString('Athena GM Commands', 'ATHENA_AGI', IntToStr(GM_ATHENA_AGI));
            ini.WriteString('Athena GM Commands', 'ATHENA_VIT', IntToStr(GM_ATHENA_VIT));
            ini.WriteString('Athena GM Commands', 'ATHENA_INT', IntToStr(GM_ATHENA_INT));
            ini.WriteString('Athena GM Commands', 'ATHENA_DEX', IntToStr(GM_ATHENA_DEX));
            ini.WriteString('Athena GM Commands', 'ATHENA_LUK', IntToStr(GM_ATHENA_LUK));
            ini.WriteString('Athena GM Commands', 'ATHENA_SPIRITBALL', IntToStr(GM_ATHENA_SPIRITBALL));
            ini.WriteString('Athena GM Commands', 'ATHENA_QUESTSKILL', IntToStr(GM_ATHENA_QUESTSKILL));
            ini.WriteString('Athena GM Commands', 'ATHENA_LOSTSKILL', IntToStr(GM_ATHENA_LOSTSKILL));
            ini.WriteString('Athena GM Commands', 'ATHENA_MODEL', IntToStr(GM_ATHENA_MODEL));
            ini.WriteString('Athena GM Commands', 'ATHENA_ITEM2', IntToStr(GM_ATHENA_ITEM2));
            ini.WriteString('Athena GM Commands', 'ATHENA_ITEM', IntToStr(GM_ATHENA_ITEM));
            ini.WriteString('Athena GM Commands', 'ATHENA_DOOM', IntToStr(GM_ATHENA_DOOM));
            ini.WriteString('Athena GM Commands', 'ATHENA_KICK', IntToStr(GM_ATHENA_KICK));
            ini.WriteString('Athena GM Commands', 'ATHENA_KICKALL', IntToStr(GM_ATHENA_KICKALL));
            ini.WriteString('Athena GM Commands', 'ATHENA_RAISE', IntToStr(GM_ATHENA_RAISE));
            ini.WriteString('Athena GM Commands', 'ATHENA_RAISEMAP', IntToStr(GM_ATHENA_RAISEMAP));
        except
            on EIniFileException do begin
                ShowMessage('Fusion could not write to file '+AppPath+'gm_commands.ini. Access levels were not saved.  Please check the permissions of that file.');
            end;
        end;

        ini.Free;

    End;(* Proc save_commands()
*-----------------------------------------------------------------------------*)


    procedure parse_commands(tc : TChara; str : String);
    var
        error_msg : String;
        gmstyle : String;
        aegistype : String;
    begin
    	if (Copy(str, 0, 1) = '/') then begin
        	gmstyle := '/';
            aegistype := Copy(str, 2, 1);
            str := Copy(str, 3, length(str) - 2);
        end

        else begin
        	gmstyle := Copy(str, Pos(' : ', str) + 3, 1);
            str := Copy(str, Pos(' : ', str) + 4, 256);
        end;


        error_msg := '';

        if gmstyle = '#' then begin
            if ( (copy(str, 1, length('alive')) = 'alive') and (check_level(tc, GM_ALIVE)) ) then error_msg := command_alive(tc)
            else if ( (copy(str, 1, length('item')) = 'item') and (check_level(tc, GM_ITEM)) ) then error_msg := command_item(tc, str)
            else if ( (copy(str, 1, length('save')) = 'save') and (check_level(tc, GM_SAVE)) ) then error_msg := command_save(tc)
            else if ( (copy(str, 1, length('return')) = 'return') and (check_level(tc, GM_RETURN)) ) then error_msg := command_return(tc)
            else if ( (copy(str, 1, length('die')) = 'die') and (check_level(tc, GM_DIE)) ) then error_msg := command_die(tc)
            else if ( (copy(str, 1, length('autoloot')) = 'autoloot') and (check_level(tc, GM_AUTOLOOT)) ) then error_msg := command_autoloot(tc)
            else if ( (copy(str, 1, length('auto')) = 'auto') and (check_level(tc, GM_AUTO)) ) then error_msg := command_auto(tc, str)
            else if ( (copy(str, 1, length('hcolor')) = 'hcolor') and (check_level(tc, GM_HCOLOR)) ) then error_msg := command_hcolor(tc, str)
            else if ( (copy(str, 1, length('ccolor')) = 'ccolor') and (check_level(tc, GM_CCOLOR)) ) then error_msg := command_ccolor(tc, str)
            else if ( (copy(str, 1, length('hstyle')) = 'hstyle') and (check_level(tc, GM_HSTYLE)) ) then error_msg := command_hstyle(tc, str)
            else if ( (copy(str, 1, length('kill')) = 'kill') and (check_level(tc, GM_KILL)) ) then error_msg := command_kill(str)
            else if ( (copy(str, 1, length('goto')) = 'goto') and (check_level(tc, GM_GOTO)) ) then error_msg := command_goto(tc, str)
            else if ( (copy(str, 1, length('summon')) = 'summon') and (check_level(tc, GM_SUMMON)) ) then error_msg := command_summon(tc, str)
            else if ( (copy(str, 1, length('warp')) = 'warp') and (check_level(tc, GM_WARP)) ) then error_msg := command_warp(tc, str)
            else if ( (copy(str, 1, length('banish')) = 'banish') and (check_level(tc, GM_BANISH)) ) then error_msg := command_banish(str)
            else if ( (copy(str, 1, length('job')) = 'job') and (check_level(tc, GM_JOB)) ) then error_msg := command_job(tc, str)
            else if ( (copy(str, 1, length('blevel')) = 'blevel') and (check_level(tc, GM_BLEVEL)) ) then error_msg := command_blevel(tc, str)
            else if ( (copy(str, 1, length('jlevel')) = 'jlevel') and (check_level(tc, GM_JLEVEL)) ) then error_msg := command_jlevel(tc, str)
            else if ( (copy(str, 1, length('changestat')) = 'changestat') and (check_level(tc, GM_CHANGESTAT)) ) then error_msg := command_changestat(tc, str)
            else if ( (copy(str, 1, length('skillpoint')) = 'skillpoint') and (check_level(tc, GM_SKILLPOINT)) ) then error_msg := command_skillpoint(tc, str)
            else if ( (copy(str, 1, length('skillall')) = 'skillall') and (check_level(tc, GM_SKILLALL)) ) then error_msg := command_skillall(tc)
            else if ( (copy(str, 1, length('statall')) = 'statall') and (check_level(tc, GM_STATALL)) ) then error_msg := command_statall(tc)
            else if ( (copy(str, 1, length('superstats')) = 'superstats') and (check_level(tc, GM_SUPERSTATS)) ) then error_msg := command_superstats(tc)
            else if ( (copy(str, 1, length('zeny')) = 'zeny') and (check_level(tc, GM_ZENY)) ) then error_msg := command_zeny(tc, str)
            else if ( (copy(str, 1, length('changeskill')) = 'changeskill') and (check_level(tc, GM_CHANGESKILL)) ) then error_msg := command_changeskill(tc, str)
            else if ( (copy(str, 1, length('monster')) = 'monster') and (check_level(tc, GM_MONSTER)) ) then error_msg := command_monster(tc, str)
            else if ( (copy(str, 1, length('speed')) = 'speed') and (check_level(tc, GM_SPEED)) ) then error_msg := command_speed(tc, str)
            else if ( (copy(str, 1, length('whois')) = 'whois') and (check_level(tc, GM_WHOIS)) ) then error_msg := command_whois(tc)
            else if ( (copy(str, 1, length('option')) = 'option') and (check_level(tc, GM_OPTION)) ) then error_msg := command_option(tc, str)
            else if ( (copy(str, 1, length('raw')) = 'raw') and (check_level(tc, GM_RAW)) ) then error_msg := command_raw(tc, str)
            else if ( (copy(str, 1, length('unit')) = 'unit') and (check_level(tc, GM_UNIT)) ) then error_msg := command_unit(tc, str)
            else if ( (copy(str, 1, length('stat')) = 'stat') and (check_level(tc, GM_STAT)) ) then error_msg := command_stat(tc, str)
            else if ( (copy(str, 1, length('refine')) = 'refine') and (check_level(tc, GM_REFINE)) ) then error_msg := command_refine(tc, str)
            else if ( (copy(str, 1, length('glevel')) = 'glevel') and (check_level(tc, GM_GLEVEL)) ) then error_msg := command_glevel(tc, str)
            else if ( (copy(str, 1, length('ironical')) = 'ironical') and (check_level(tc, GM_IRONICAL)) ) then error_msg := command_ironical(tc)
            else if ( (copy(str, 1, length('mothball')) = 'mothball') and (check_level(tc, GM_MOTHBALL)) ) then error_msg := command_mothball(tc)
            else if ( (copy(str, 1, length('where')) = 'where') and (check_level(tc, GM_WHERE)) ) then error_msg := command_where(tc, str)
            else if ( (copy(str, 1, length('revive')) = 'revive') and (check_level(tc, GM_REVIVE)) ) then error_msg := command_revive(str)
            else if ( (copy(str, 1, length('ban')) = 'ban') and (check_level(tc, GM_BAN)) ) then error_msg := command_ban(str)
            else if ( (copy(str, 1, length('kick')) = 'kick') and (check_level(tc, GM_KICK)) ) then error_msg := command_kick(str)
            else if ( (copy(str, 1, length('icon')) = 'icon') and (check_level(tc, GM_ICON)) ) then error_msg := command_icon(tc, str)
            else if ( (copy(str, 1, length('unicon')) = 'unicon') and (check_level(tc, GM_UNICON)) ) then error_msg := command_unicon(tc, str)
            else if ( (copy(str, 1, length('server')) = 'server') and (check_level(tc, GM_SERVER)) ) then error_msg := command_server()
            else if ( (copy(str, 1, length('pvpon')) = 'pvpon') and (check_level(tc, GM_PVPON)) ) then error_msg := command_pvpon(tc)
            else if ( (copy(str, 1, length('pvpoff')) = 'pvpoff') and (check_level(tc, GM_PVPOFF)) ) then error_msg := command_pvpoff(tc)
            else if ( (copy(str, 1, length('gpvpon')) = 'gpvpon') and (check_level(tc, GM_GPVPON)) ) then error_msg := command_gpvpon(tc)
            else if ( (copy(str, 1, length('gpvpoff')) = 'gpvpoff') and (check_level(tc, GM_GPVPOFF)) ) then error_msg := command_gpvpoff(tc)
            else if ( (copy(str, 1, length('newplayer')) = 'newplayer') and (check_level(tc, GM_NEWPLAYER)) ) then error_msg := command_newplayer(str)
            else if ( (copy(str, 1, length('pword')) = 'pword') and (check_level(tc, GM_PWORD)) ) then error_msg := command_pword(tc, str)
            else if ( (copy(str, 1, length('users')) = 'users') and (check_level(tc, GM_USERS)) ) then error_msg := command_users()
            else if ( (copy(str, 1, length('charblevel')) = 'charblevel') and (check_level(tc, GM_CHARBLEVEL)) ) then error_msg := command_charblevel(tc, str)
            else if ( (copy(str, 1, length('charjlevel')) = 'charjlevel') and (check_level(tc, GM_CHARJLEVEL)) ) then error_msg := command_charjlevel(tc, str)
            else if ( (copy(str, 1, length('charstatpoint')) = 'charstatpoint') and (check_level(tc, GM_CHARSTATPOINT)) ) then error_msg := command_charstatpoint(tc, str)
            else if ( (copy(str, 1, length('charskillpoint')) = 'charskillpoint') and (check_level(tc, GM_CHARSKILLPOINT)) ) then error_msg := command_charskillpoint(tc, str)
            else if ( (copy(str, 1, length('changes')) = 'changes') and (check_level(tc, GM_CHANGES)) ) then error_msg := command_changes(tc, str)
            else if ( (copy(str, 1, length('iscson')) = 'iscson') and (check_level(tc, GM_ISCSON)) ) then error_msg := command_iscson(tc)
            else if ( (copy(str, 1, length('iscsoff')) = 'iscsoff') and (check_level(tc, GM_ISCSOFF)) ) then error_msg := command_iscsoff(tc)
            else if ( (copy(str, 1, length('gstorage')) = 'gstorage') and (check_level(tc, GM_GSTORAGE)) ) then error_msg := command_gstorage(tc)
            else if ( (copy(str, 1, length('rcon')) = 'rcon') and (check_level(tc, GM_RCON)) ) then error_msg := command_rcon(str)
            else if ( (copy(str, 1, length('jail')) = 'jail') and (check_level(tc, GM_JAIL)) ) then error_msg := command_jail(tc, str)
            else if ( (copy(str, 1, length('unjail')) = 'unjail') and (check_level(tc, GM_UNJAIL)) ) then error_msg := command_unjail(tc, str)
            // Extremely Buggy GM Command. I don't want this enabled unless it works. else if ( (copy(str, 1, length('call_mercenary')) = 'call_mercenary') and (check_level(tc, GM_CALL_MERCENARY)) ) then error_msg := command_call_mercenary(tc, str)
            else if ( (copy(str, 1, length('email')) = 'email') and (check_level(tc, GM_EMAIL)) ) then error_msg := command_email(tc, str)
        end else if gmstyle = '@' then begin
            if ( (copy(str, 1, length('heal')) = 'heal') and (check_level(tc, GM_ATHENA_HEAL)) ) then error_msg := command_athena_heal(tc, str)
            else if ( (copy(str, 1, length('kami')) = 'kami') and (check_level(tc, GM_ATHENA_KAMI)) ) then error_msg := command_athena_kami(tc, str)
            else if ( (copy(str, 1, length('alive')) = 'alive') and (check_level(tc, GM_ATHENA_ALIVE)) ) then error_msg := command_athena_alive(tc)
            else if ( (copy(str, 1, length('save')) = 'save') and (check_level(tc, GM_ATHENA_SAVE)) ) then error_msg := command_athena_save(tc)
            else if ( (copy(str, 1, length('load')) = 'load') and (check_level(tc, GM_ATHENA_LOAD)) ) then error_msg := command_athena_load(tc)
            else if ( (copy(str, 1, length('kill')) = 'kill') and (check_level(tc, GM_ATHENA_KILL)) ) then error_msg := command_athena_kill(tc, str)
            else if ( (copy(str, 1, length('die')) = 'die') and (check_level(tc, GM_ATHENA_DIE)) ) then error_msg := command_athena_die(tc)
            else if ( (copy(str, 1, length('jobchange')) = 'jobchange') and (check_level(tc, GM_ATHENA_JOBCHANGE)) ) then error_msg := command_athena_jobchange(tc, str)
            else if ( (copy(str, 1, length('hide')) = 'hide') and (check_level(tc, GM_ATHENA_HIDE)) ) then error_msg := command_athena_hide(tc)
            else if ( (copy(str, 1, length('option')) = 'option') and (check_level(tc, GM_ATHENA_OPTION)) ) then error_msg := command_athena_option(tc, str)
            else if ( (copy(str, 1, length('storage')) = 'storage') and (check_level(tc, GM_ATHENA_STORAGE)) ) then error_msg := command_athena_storage(tc)
            else if ( (copy(str, 1, length('speed')) = 'speed') and (check_level(tc, GM_ATHENA_SPEED)) ) then error_msg := command_athena_speed(tc, str)
            else if ( (copy(str, 1, length('whomap3')) = 'whomap3') and (check_level(tc, GM_ATHENA_WHOMAP3)) ) then error_msg := command_athena_whomap3(tc, str)
            else if ( (copy(str, 1, length('whomap2')) = 'whomap2') and (check_level(tc, GM_ATHENA_WHOMAP2)) ) then error_msg := command_athena_whomap2(tc, str)
            else if ( (copy(str, 1, length('whomap')) = 'whomap') and (check_level(tc, GM_ATHENA_WHOMAP)) ) then error_msg := command_athena_whomap(tc, str)
            else if ( (copy(str, 1, length('who3')) = 'who3') and (check_level(tc, GM_ATHENA_WHO3)) ) then error_msg := command_athena_who3(tc, str)
            else if ( (copy(str, 1, length('who2')) = 'who2') and (check_level(tc, GM_ATHENA_WHO2)) ) then error_msg := command_athena_who2(tc, str)
            else if ( (copy(str, 1, length('who')) = 'who') and (check_level(tc, GM_ATHENA_WHO)) ) then error_msg := command_athena_who(tc, str)
            else if ( (copy(str, 1, length('jumpto')) = 'jumpto') and (check_level(tc, GM_ATHENA_JUMPTO)) ) then error_msg := command_athena_jumpto(tc, str)
            else if ( (copy(str, 1, length('jump')) = 'jump') and (check_level(tc, GM_ATHENA_JUMP)) ) then error_msg := command_athena_jump(tc, str)
            else if ( (copy(str, 1, length('where')) = 'where') and (check_level(tc, GM_ATHENA_WHERE)) ) then error_msg := command_athena_where(tc, str)
            else if ( (copy(str, 1, length('rura+')) = 'rura+') and (check_level(tc, GM_ATHENA_RURAP)) ) then error_msg := command_athena_rurap(tc, str)
            else if ( (copy(str, 1, length('rura')) = 'rura') and (check_level(tc, GM_ATHENA_RURA)) ) then error_msg := command_athena_rura(tc, str)
            else if ( (copy(str, 1, length('warp+')) = 'warp+') and (check_level(tc, GM_ATHENA_WARPP)) ) then error_msg := command_athena_warpp(tc, str)
            else if ( (copy(str, 1, length('warp')) = 'warp') and (check_level(tc, GM_ATHENA_WARP)) ) then error_msg := command_athena_warp(tc, str)
            else if ( (copy(str, 1, length('send')) = 'send') and (check_level(tc, GM_ATHENA_SEND)) ) then error_msg := command_athena_send(tc, str)
            else if ( (copy(str, 1, length('charwarp')) = 'charwarp') and (check_level(tc, GM_ATHENA_CHARWARP)) ) then error_msg := command_athena_charwarp(tc, str)
            else if ( (copy(str, 1, length('h')) = 'h') and (check_level(tc, GM_ATHENA_H)) ) then error_msg := command_athena_h(tc, str)
            else if ( (copy(str, 1, length('help')) = 'help') and (check_level(tc, GM_ATHENA_HELP)) ) then error_msg := command_athena_help(tc, str)
            else if ( (copy(str, 1, length('zeny')) = 'zeny') and (check_level(tc, GM_ATHENA_ZENY)) ) then error_msg := command_athena_zeny(tc, str)
			else if ( (copy(str, 1, length('baselvlup')) = 'baselvlup') and (check_level(tc, GM_ATHENA_BASELVLUP)) ) then error_msg := command_athena_baselvlup(tc, str)
            else if ( (copy(str, 1, length('lvup')) = 'lvup') and (check_level(tc, GM_ATHENA_LVUP)) ) then error_msg := command_athena_lvup(tc, str)
            else if ( (copy(str, 1, length('joblvlup')) = 'joblvlup') and (check_level(tc, GM_ATHENA_JOBLVLUP)) ) then error_msg := command_athena_joblvlup(tc, str)
            else if ( (copy(str, 1, length('joblvup')) = 'joblvup') and (check_level(tc, GM_ATHENA_JOBLVUP)) ) then error_msg := command_athena_joblvup(tc, str)
            else if ( (copy(str, 1, length('skpoint')) = 'skpoint') and (check_level(tc, GM_ATHENA_SKPOINT)) ) then error_msg := command_athena_skpoint(tc, str)
            else if ( (copy(str, 1, length('skpoint')) = 'skpoint') and (check_level(tc, GM_ATHENA_SKPOINT)) ) then error_msg := command_athena_skpoint(tc, str)
            else if ( (copy(str, 1, length('stpoint')) = 'stpoint') and (check_level(tc, GM_ATHENA_STPOINT)) ) then error_msg := command_athena_stpoint(tc, str)
            else if ( (copy(str, 1, length('str')) = 'str') and (check_level(tc, GM_ATHENA_STR)) ) then error_msg := command_athena_str(tc, str)
            else if ( (copy(str, 1, length('agi')) = 'agi') and (check_level(tc, GM_ATHENA_AGI)) ) then error_msg := command_athena_agi(tc, str)
            else if ( (copy(str, 1, length('vit')) = 'vit') and (check_level(tc, GM_ATHENA_VIT)) ) then error_msg := command_athena_vit(tc, str)
            else if ( (copy(str, 1, length('int')) = 'int') and (check_level(tc, GM_ATHENA_INT)) ) then error_msg := command_athena_int(tc, str)
            else if ( (copy(str, 1, length('dex')) = 'dex') and (check_level(tc, GM_ATHENA_DEX)) ) then error_msg := command_athena_dex(tc, str)
            else if ( (copy(str, 1, length('luk')) = 'luk') and (check_level(tc, GM_ATHENA_LUK)) ) then error_msg := command_athena_luk(tc, str)
            else if ( (copy(str, 1, length('spiritball')) = 'spiritball') and (check_level(tc, GM_ATHENA_SPIRITBALL)) ) then error_msg := command_athena_spiritball(tc, str)
            else if ( (copy(str, 1, length('questskill')) = 'questskill') and (check_level(tc, GM_ATHENA_QUESTSKILL)) ) then error_msg := command_athena_questskill(tc, str)
            else if ( (copy(str, 1, length('lostskill')) = 'lostskill') and (check_level(tc, GM_ATHENA_LOSTSKILL)) ) then error_msg := command_athena_lostskill(tc, str)
            else if ( (copy(str, 1, length('model')) = 'model') and (check_level(tc, GM_ATHENA_MODEL)) ) then error_msg := command_athena_model(tc, str)
            else if ( (copy(str, 1, length('item2')) = 'item2') and (check_level(tc, GM_ATHENA_ITEM2)) ) then error_msg := command_athena_item2(tc, str)
            else if ( (copy(str, 1, length('item')) = 'item') and (check_level(tc, GM_ATHENA_ITEM)) ) then error_msg := command_athena_item(tc, str)
            else if ( (copy(str, 1, length('doom')) = 'doom') and (check_level(tc, GM_ATHENA_DOOM)) ) then error_msg := command_athena_doom(tc)
            else if ( (copy(str, 1, length('kickall')) = 'kickall') and (check_level(tc, GM_ATHENA_KICKALL)) ) then error_msg := command_athena_kickall(tc)
            else if ( (copy(str, 1, length('kick')) = 'kick') and (check_level(tc, GM_ATHENA_KICK)) ) then error_msg := command_athena_kick(tc, str)
            else if ( (copy(str, 1, length('raisemap')) = 'raisemap') and (check_level(tc, GM_ATHENA_RAISEMAP)) ) then error_msg := command_athena_raisemap(tc)
            else if ( (copy(str, 1, length('raise')) = 'raise') and (check_level(tc, GM_ATHENA_RAISE)) ) then error_msg := command_athena_raise(tc)
        end else if gmstyle = '/' then begin
        	if ( (aegistype = 'B') and (Copy(str, 1, length(tc.Name) + 2) = (tc.Name + ': ')) and (not (Copy(str, 1, 4) = 'blue') ) and (check_level(tc, GM_AEGIS_B)) ) then error_msg := command_aegis_b(str)
            else if ( (aegistype = 'B') and (Copy(str, 1, length(tc.Name) + 2) <> (tc.Name + ': ')) and (not (Copy(str, 1, 4) = 'blue') ) and (check_level(tc, GM_AEGIS_NB)) ) then error_msg := command_aegis_nb(str)
            else if ( (aegistype = 'B') and (Copy(str, 1, 4) = 'blue') and (check_level(tc, GM_AEGIS_BB)) ) then error_msg := command_aegis_bb(tc, str)
            else if ( (aegistype = 'S') and (ItemDBName.IndexOf(str) <> -1) and (check_level(tc, GM_AEGIS_ITEM)) ) then error_msg := command_aegis_item(tc, str)
            else if ( (aegistype = 'S') and (MobDBName.IndexOf(str) <> -1) and (check_level(tc, GM_AEGIS_MONSTER)) ) then error_msg := command_aegis_monster(tc, str)
            else if ( (aegistype = 'R') and (StrToInt(str) = 0) and (check_level(tc, GM_AEGIS_RESETSTATE)) ) then error_msg := command_aegis_resetstate(tc, str)
            else if ( (aegistype = 'R') and (StrToInt(str) = 1) and (check_level(tc, GM_AEGIS_RESETSKILL)) ) then error_msg := command_aegis_resetskill(tc, str)
            else if ( (aegistype = 'H') and (check_level(tc, GM_AEGIS_HIDE)) ) then error_msg := command_aegis_hide(tc)
        end;

        if (error_msg <> '') then error_message(tc, error_msg);
        if ( (Option_GM_Logs) and (error_msg <> '') ) then save_gm_log(tc, error_msg);
    end;

    function check_level(tc : TChara; cmd : Integer) : Boolean;
    var
        tp : TPlayer;
    begin
        Result := False;
        tp := tc.PData;
        if tp.AccessLevel >= cmd then Result := True;
    end;

    procedure error_message(tc : TChara; str : String);
    begin
        WFIFOW(0, $009a);
        WFIFOW(2, length(str) + 4);
        WFIFOS(4, str, length(str));
        tc.Socket.SendBuf(buf, length(str) + 4);
    end;

    {
    save_gm_log()
    Orig Author: AlexKreuz
    2004/05/28

    Revisions:
    2004/05/31 [ChrstphrR] Added exception handling to gracefully handle file
    errors that might occur. (Notice how try-except doesn't butcher the code :D )
    }
    procedure save_gm_log(tc : TChara; str : String);
    var
        logfile : TStringList;
        timestamp : TDateTime;
        filename : String;
    begin
        timestamp := Now;
        filename := StringReplace(DateToStr(timestamp), '/', '_', [rfReplaceAll, rfIgnoreCase]);
        logfile := TStringList.Create;

        {ChrstphrR 2004/05/30 - try-except to handle nasty situations where
        we can't open or write to the logfiles -- they won't be showstoppers.
        Note that the Create and Free methods are outside of this.}
        try
            if FileExists(AppPath + 'logs\GM_COMMANDS-' + filename + '.txt') then begin
                logfile.LoadFromFile(AppPath + 'logs\GM_COMMANDS-' + filename + '.txt');
            end;

            str := '[' + DateToStr(timestamp) + '-' + TimeToStr(timestamp) + '] ' + IntToStr(tc.ID) + ': ' + str + ' (' + tc.Name + ')';
            logfile.Add(str);

            CreateDir(AppPath + 'logs');
            logfile.SaveToFile(AppPath + 'logs\GM_COMMANDS-' + filename + '.txt');
        except
            on E : Exception do DebugOut.Lines.Add('[' + TimeToStr(Now) + '] ' + '*** GM Logfile Error : ' + E.Message);
        end;
        logfile.Free;
    end;

    function command_alive(tc : TChara) : String;
    begin
        Result := 'GM_ALIVE Success.';

        tc.HP := tc.MAXHP;
        tc.SP := tc.MAXSP;
        tc.Sit := 3;

        SendCStat1(tc, 0, 5, tc.HP);
        SendCStat1(tc, 0, 7, tc.SP);

        WFIFOW(0, $0148);
        WFIFOL(2, tc.ID);
        WFIFOW(6, 100);

        SendBCmd(tc.MData, tc.Point, 8);
    end;

    function command_item(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        td : TItemDB;
        item, quantity, k : Integer;
    begin
        Result := 'GM_ITEM Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 6, 256);

        if sl.Count = 2 then begin
            Val(sl[0], item, k);

            if k = 0 then begin
                if ItemDB.IndexOf(item) <> -1 then begin
                    Val(sl[1], quantity, k);

                    if k = 0 then begin
                        if (quantity > 0) or (quantity <= 30000) then begin
                            td := ItemDB.IndexOfObject(item) as TItemDB;

                            if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) * cardinal(quantity) then begin
                                k := SearchCInventory(tc, item, td.IEquip);

                                if k <> 0 then begin
                                    if tc.Item[k].Amount + quantity > 30000 then begin
                                        quantity := 30000 - tc.Item[k].Amount;
                                    end;
                                    if td.IEquip then quantity := 1;
                                    tc.Item[k].ID := item;
                                    tc.Item[k].Amount := tc.Item[k].Amount + quantity;
                                    tc.Item[k].Equip := 0;
                                    tc.Item[k].Identify := 1;
                                    tc.Item[k].Refine := 0;
                                    tc.Item[k].Attr := 0;
                                    tc.Item[k].Card[0] := 0;
                                    tc.Item[k].Card[1] := 0;
                                    tc.Item[k].Card[2] := 0;
                                    tc.Item[k].Card[3] := 0;
                                    tc.Item[k].Data := td;
                                    tc.Weight := tc.Weight + cardinal(td.Weight) * cardinal(quantity);

                                    SendCStat1(tc, 0, $0018, tc.Weight);
                                    SendCGetItem(tc, k, quantity);

                                    Result := 'GM_ITEM Success.';
                                end;
                            end

                            else begin
                                Result := Result + ' Creating this many items would make you overweight.';
                            end;
                        end

                        else begin
                            Result := Result + ' Quantity must be from 1-30000.';
                        end;
                    end

                    else begin
                        Result := Result + ' Quantity must be a valid integer.';
                    end;
                end

                else begin
                    Result := Result + ' Item does not exist.';
                end;
            end

            else begin
                Result := Result + ' Item ID must be a valid integer.';
            end;
        end

        else begin
            Result := Result + ' Insufficient input. Format is <item ID> <quantity>.';
        end;
        sl.Free;
    end;

    function command_save(tc : TChara) : String;
    begin
        Result := 'GM_SAVE Success.';

        tc.SaveMap := tc.Map;
        tc.SavePoint.X := tc.Point.X;
        tc.SavePoint.Y := tc.Point.Y;

        Result := 'Saved at ' + tc.Map + ' (' + IntToStr(tc.Point.X) + ',' + IntToStr(tc.Point.Y) + ')';
    end;

    function command_return(tc : TChara) : String;
    begin
        Result := 'GM_RETURN Success.';

        SendCLeave(tc.Socket.Data, 2);
        tc.Map := tc.SaveMap;
        tc.Point := tc.SavePoint;
        MapMove(tc.Socket, tc.Map, tc.Point);
    end;

    function command_die(tc : TChara) : String;
    begin
        Result := 'GM_DIE Success.';

        CharaDie(tc.MData, tc, 1);
    end;

    function command_auto(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        tl : TSkillDB;
        mode, k : Integer;
    begin
        Result := 'GM_AUTO Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 5, 256);

        if (sl.Count > 0) and (sl.Count < 4) then begin
            if sl.Count = 3 then begin
                Val(sl.Strings[1], tc.A_Skill, k);
                if k = 0 then begin
                    Val(sl.Strings[2], tc.A_Lv, k);
                    if k <> 0 then begin
                        Result := Result + ' Skill level must be a valid integer.';
                        sl.Free;
                        Exit;
                    end

                    else begin
                        if tc.Skill[tc.A_Skill].Lv < tc.A_Lv then begin
                            Result := Result + ' You do not have that level of the skill.';
                            sl.Free;
                            Exit;
                        end;
                    end;
                end

                else begin
                    Result := Result + ' Skill ID must be a valid integer.';
                end;
            end;
            Val(sl.Strings[0], mode, k);
            if k = 0 then begin
                tc.Auto := mode;
                Result := 'GM_AUTO Success.';
                if tc.Auto = 0 then Result := Result + ' [Auto OFF]';
                if tc.Auto AND 1 = 1 then Result := Result + ' [Auto attack ON]';
                if tc.Auto AND 2 = 2 then begin
                    tl := tc.Skill[tc.A_Skill].Data;
                    Result := Result + ' [Auto Skill ON - ' + tl.Name + ' ' + IntToStr(tc.A_Lv) + ']';
                end;
                if tc.Auto AND 4 = 4 then Result := Result + ' [Auto loot ON]';
                if tc.Auto AND 16 = 16 then Result := Result + ' [Auto move ON]';
            end

            else begin
                Result := Result + ' Mode must be a valid integer.';
            end;
        end

        else begin
            Result := Result + ' Insufficient input. Format is <mode> (1 = auto attack, 2 = auto skill, 4 = auto loot, 16 = auto move) [skill ID] [skill level].';
        end;
        sl.Free;
    end;

    function command_hcolor(tc : TChara; str : String) : String;
    var
        s : String;
        color, k : Integer;
    begin
        Result := 'GM_HCOLOR Failure.';

        s := Copy(str, 8, 256);

        if s <> '' then begin
            Val(Copy(str, 8, 256), color, k);
            if k = 0 then begin
                Result := 'GM_HCOLOR Success.';
                tc.HairColor := color;
                UpdateLook(tc.MData, tc, 6, color, 0, true);
            end else Result := Result + ' Color must be a valid integer.';

        end else Result := Result + ' Insufficient input. Format is <color number>.';

    end;

    function command_ccolor(tc : TChara; str : String) : String;
    var
        s : String;
        k : Integer;
        color : integer;
    begin
        Result := 'GM_CCOLOR Failure.';

        s := Copy(str, 8, 256);

        if s <> '' then begin
            Val(Copy(str, 8, 256), color, k);
            if k = 0 then begin
                Result := 'GM_CCOLOR Success.';
                tc.ClothesColor := color;
                UpdateLook(tc.MData, tc, 7, color, 0, true);
            end else Result := Result + ' Color must be a valid integer.';
        end else Result := Result + ' Insufficient input. Format is <clothes color>.';
    end;

    function command_hstyle(tc : TChara; str : String) : String;
    var
        s : String;
        style, k : Integer;
    begin
        Result := 'GM_HSTYLE Failure.';

        s := Copy(str, 8, 256);

        if s <> '' then begin
            Val(Copy(str, 8, 256), style, k);
            if k = 0 then begin
                if (style >= 0) and (style <= 20) then begin
                    Result := 'GM_HSTYLE Success.';
                    tc.Hair := style;
                    UpdateLook(tc.MData, tc, 1, style, 0, true);
                end

                else begin
                    Result := Result + ' Style must be in range [0-20].';
                end;
            end

            else begin
                Result := Result + ' Style must be a valid integer.';
            end;
        end

        else begin
            Result := Result + ' Insufficient input. Format is <hairstyle> (In range 0-20).';
        end;
    end;

    function command_kill(str : String) : String;
    var
        s : String;
        tc1 : TChara;
    begin
        Result := 'GM_KILL Failure.';

        s := Copy(str, 6, 256);
        if s <> '' then begin
            if (CharaName.Indexof(s) <> -1) then begin
                tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;

                if (tc1.Login = 2) then begin
                    tc1.HP := 0;
                    tc1.Sit := 1;
                    SendCStat1(tc1, 0, 5, tc1.HP);

                    WFIFOW( 0, $0080);
                    WFIFOL( 2, tc1.ID);
                    WFIFOB( 6, 1);

                    SendBCmd(tc1.MData, tc1.Point, 7);

                    Result := 'GM_KILL Success. ' + s + ' has been killed.';
                end

                else begin
                    Result := Result + ' ' + s + ' is not logged in.';
                end;
            end

            else begin
                Result := Result + ' ' + s + ' is an invalid character name.';
            end;
        end

        else begin
            Result := Result + ' Please enter a character name.';
        end;
    end;

    function command_goto(tc : TChara; str : String) : String;
    var
        s : String;
        tc1 : TChara;
    begin
        Result := 'GM_GOTO Failure.';

        s := Copy(str, 6, 256);

        if s <> '' then begin
            if CharaName.Indexof(s) <> -1 then begin
                tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;
                if (tc.Hidden = false) then SendCLeave(tc, 2);
                tc.tmpMap := tc1.Map;
                tc.Point := tc1.Point;
                MapMove(tc.Socket, tc1.Map, tc1.Point);

                Result := 'GM_GOTO Success. ' + tc.Name + ' warped to ' + s + '.';
            end

            else begin
                Result := Result + ' ' + s + ' is an invalid character name.';
            end;
        end

        else begin
            Result := Result + ' Insufficient input. Format is <charname>.';
        end;
    end;

    function command_summon(tc : TChara; str : String) : String;
    var
        s : String;
        tc1 : TChara;
    begin
        Result := 'GM_SUMMON Failure.';

        s := Copy(str, 8, 256);

        if s <> '' then begin
            if CharaName.Indexof(s) <> -1 then begin
                Result := 'GM_SUMMON Success. ' + s + ' warped to ' + tc.Name + '.';
                tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;

                if (tc1.Login = 2) then begin
                    SendCLeave(tc1, 2);
                    tc1.Map := tc.Map;
                    tc1.Point := tc.Point;
                    MapMove(tc1.Socket, tc.Map, tc.Point);
                end

                else begin
                    tc1.Map := tc.Map;
                    tc1.Point := tc.Point;

                    Result := Result + ' But ' + s + ' is offline.';
                end;
            end

            else begin
                Result := Result + ' ' + s + ' is an invalid character name.';
            end;
        end

        else begin
            Result := Result + ' Insufficient input. Format is <charname>.';
        end;
    end;

    function command_warp(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        x, y, j, k : Integer;
        tm : TMap;
    begin
        Result := 'GM_WARP Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 6, 256);

        if sl.Count > 0 then begin
            sl.Strings[0] := LowerCase(sl.Strings[0]);

            if MapList.IndexOf(sl.Strings[0]) <> -1 then begin
                if Map.IndexOf(sl.Strings[0]) = -1 then begin
                    MapLoad(sl.Strings[0]);
                end;
            end

            else begin
                Result := Result + ' Map does not exist.';
                sl.Free;
                Exit;
            end;
        end
        else begin
            sl.Add(MapList.Strings[random(MapList.Count-1)]);
            if Map.IndexOf(sl.Strings[0]) = -1 then begin
                MapLoad(sl.Strings[0]);
            end;
        end;
        tm := Map.Objects[Map.IndexOf(sl.Strings[0])] as TMap;
        j := 0;

        repeat
            x := Random(tm.Size.X - 2) + 1;
            y := Random(tm.Size.Y - 2) + 1;
            Inc(j);
        until ( ((tm.gat[x, y] <> 1) and (tm.gat[x, y] <> 5)) or (j = 100) );

        if sl.Count > 1 then begin

            Val(sl.Strings[1], x, k);
            if k <> 0 then begin
                Result := Result + ' X coordinate must be a valid integer.';
                sl.Free;
                Exit;
            end;

            j := 0;

            repeat
                y := Random(tm.Size.Y - 2) + 1;
                Inc(j);
            until ( ((tm.gat[x, y] <> 1) and (tm.gat[x, y] <> 5)) or (j = 100) );
        end;

        if sl.Count = 3 then begin
            Val(sl.Strings[2], y, k);
            if k <> 0 then begin
                Result := Result + ' Y coordinate must be a valid integer.';
                sl.Free;
                Exit;
            end;
        end;

        if (x >= 0) and (x <= tm.Size.X - 1) and (y >= 0) and (y <= tm.Size.Y - 1) then begin
            if (tm.gat[x, y] <> 1) and (tm.gat[x, y] <> 5) then begin
                if (tc.Hidden = false) then SendCLeave(tc, 2);

                tc.tmpMap := sl.Strings[0];
                tc.Point := Point(x,y);

                MapMove(tc.Socket, sl.Strings[0], Point(x,y));

                Result := 'GM_WARP Success. Warp to ' + tc.tmpMap + ' (' + IntToStr(x) + ',' + IntToStr(y) + ').';
            end

            else begin
                Result := Result + ' Specified cell is impassable.';
            end;
        end

        else begin
            Result := Result + ' Coordinates are out of range. (0-' + IntToStr(tm.Size.X - 1) + ', 0-' + IntToStr(tm.Size.Y - 1) + ')';
        end;
        sl.Free;
    end;

    function command_banish(str : String) : String;
    var
        sl : TStringList;
        x, y, k : Integer;
        ta : TMapList;
        tc1 : TChara;
    begin
        Result := 'GM_BANISH Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 8, 256);

        if (sl.Count = 4) then begin
            if MapList.IndexOf(sl.Strings[1]) <> -1 then begin
                ta := MapList.Objects[MapList.IndexOf(sl.Strings[1])] as TMapList;

                Val(sl.Strings[2], x, k);
                if k = 0 then begin

                    Val(sl.Strings[3], y, k);
                    if k = 0 then begin

                        if (x >= 0) and (x <= ta.Size.X) and (y >= 0) and (y <= ta.Size.Y) then begin

                            if CharaName.Indexof(sl.Strings[0]) <> -1 then begin
                                tc1 := CharaName.Objects[CharaName.Indexof(sl.Strings[0])] as TChara;


                                if (tc1.Login = 2) then begin
                                    SendCLeave(tc1, 2);

                                    tc1.tmpMap := sl.Strings[1];
                                    tc1.Point := Point(x,y);

                                    MapMove(tc1.Socket, tc1.tmpMap, tc1.Point);

                                    Result := 'GM_BANISH Success. ' + sl.Strings[0] + ' warped to ' + ta.Name + ' (' + IntToStr(x) + ', ' + IntToStr(y) + ').';
                                end

                                else begin
                                    tc1.Map := sl.Strings[1];
                                    tc1.Point := Point(x,y);

                                    Result := 'GM_BANISH Success. But ' + ' ' + sl.Strings[0] + ' is offline.';
                                end;
                            end

                            else begin
                                Result := Result + ' ' + sl.Strings[0] + ' is an invalid character name.';
                            end;
                        end

                        else begin
                            Result := Result + ' Coordinates are out of range. (0-' + IntToStr(ta.Size.X - 1) + ', 0-' + IntToStr(ta.Size.Y - 1) + ')';
                        end;
                    end

                    else begin
                        Result := Result + ' Y coordinate must be a valid integer.';
                    end;
                end

                else begin
                    Result := Result + ' X coordinate must be a valid integer.';
                end;
            end

            else begin
                Result := Result + sl.Strings[1] + ' does not exist.';
            end;
        end

        else begin
            Result := Result + ' Insufficient input. Format is <char name> <map> <x coordinate> <y coordinate>.';
        end;
        sl.Free;
    end;

    function command_job(tc : TChara; str : String) : String;
    var
        job, j, k, l : Integer;
        s : String;
    begin
        Result := 'GM_JOB Failure.';

        s := Copy(str, 5, 256);

        if s <> '' then begin
            if (tc.JID <> 0) or ((DebugCMD and $0020) <> 0) then begin
                Val(Copy(str, 5, 256), job, k);
                if k = 0 then begin
                    if (job >= 0) and (job <= MAX_JOB_NUMBER) then begin

                        // Colus, 20040203: Added unequip of items when you #job
                        for  j := 1 to 100 do begin
                            if tc.Item[j].Equip = 32768 then begin
                                tc.Item[j].Equip := 0;

                                WFIFOW(0, $013c);
                                WFIFOW(2, 0);

                                tc.Socket.SendBuf(buf, 4);
                            end

                            else if tc.Item[j].Equip <> 0 then begin
                    	        reset_skill_effects(tc);

                                WFIFOW(0, $00ac);
                                WFIFOW(2, j);
                                WFIFOW(4, tc.Item[j].Equip);

                                tc.Item[j].Equip := 0;

                                WFIFOB(6, 1);

                                tc.Socket.SendBuf(buf, 7);

                                remove_equipcard_skills(tc, j);
                            end;
                        end;

                        // Darkhelmet, 20040212: Added to remove all ticks when changing jobs.
                        for j := 1 to MAX_SKILL_NUMBER do begin
                            if tc.Skill[j].Data.Icon <> 0 then begin
                                if tc.Skill[j].Tick >= timeGetTime() then begin
                                    UpdateIcon(tc.MData, tc, tc.Skill[j].Data.Icon, 0);
                                end;
                            end;
                            tc.Skill[j].Tick := timeGetTime();
                            tc.Skill[j].Effect1 := 0;
                        end;

                        if (job > LOWER_JOB_END) then begin
                            l := job - LOWER_JOB_END + UPPER_JOB_BEGIN; // 24 - 23 + 4000 = 4001, remort novice
                            if (DisableAdv2ndDye) and (job > 30) then
                                tc.ClothesColor := 0;
                        end

                        else begin
                            l := job;
                            tc.ClothesColor := 0;
                        end;

                        tc.JID := l;

                        if (tc.Option <> 0) then begin
                            tc.Option := 0;
                            WFIFOW(0, $0119);
                            WFIFOL(2, tc.ID);
                            WFIFOW(6, 0);
                            WFIFOW(8, 0);
                            WFIFOW(10, tc.Option);
                            WFIFOB(12, 0);
                            SendBCmd(tc.MData, tc.Point, 13);
                        end;

                        CalcStat(tc);

                        SendCStat(tc, true); // Add the true to recalc sprites
                        SendCSkillList(tc);

                        // Colus, 20040303: Using newer packet to allow upper job changes
                        UpdateLook(tc.Mdata, tc, 0, l);
                        UpdateLook(tc.MData, tc, 7, tc.ClothesColor, 0, true);

                        Result := 'GM_JOB Success. New Job ID is ' + IntToStr(job) + '.';
                    end

                    else begin
                        Result := Result + ' Job ID is out of range.';
                    end;
                end

                else begin
                    Result := Result + ' Job ID must be a valid integer.';
                end;
            end;
        end

        else begin
            Result := Result + ' Insufficient input. Format is <new job ID>.';
        end;
    end;

    function command_blevel(tc : TChara; str : String) : String;
    var
        newlevel, i, k, w3 : Integer;
        oldlevel : Integer;
        s : string;
    begin
        Result := 'GM_BLEVEL Failure.';

        s := Copy(str, 8, 256);

        if s <> '' then begin

            oldlevel := tc.BaseLV;
            Val(Copy(str, 8, 256), newlevel, k);

            if k = 0 then begin
                if newlevel <> tc.BaseLV then begin
                    if (newlevel >= 1) and (newlevel <= 32767) then begin
                        if tc.BaseLV > newlevel then begin
                            tc.BaseLV := newlevel;

                            for i := 0 to 5 do begin
                                tc.ParamBase[i] := 1;
                            end;

                            tc.StatusPoint := 48;

                            for i := 1 to tc.BaseLV - 1 do begin
                                tc.StatusPoint := tc.StatusPoint + i div 5 + 3;
                            end;
                        end

                        else begin
                            w3 := tc.BaseLV;
                            tc.BaseLV := newlevel;

                            for i := w3 to tc.BaseLV - 1 do begin
                                tc.StatusPoint := tc.StatusPoint + i div 5 + 3;
                            end;
                        end;

                        if (tc.BaseNextEXP = 0) then tc.BaseNextEXP := 999999999;
                        tc.BaseEXP := tc.BaseNextEXP - 1;
                        if tc.JID > 23 then
                            tc.BaseNextEXP := ExpTable[5][tc.BaseLV]
                        else tc.BaseNextEXP := ExpTable[0][tc.BaseLV];

                        CalcStat(tc);

                        SendCStat(tc);
                        SendCStat1(tc, 0, $000b, tc.BaseLV);
                        SendCStat1(tc, 0, $0009, tc.StatusPoint);
                        SendCStat1(tc, 1, $0001, tc.BaseEXP);

                        Result := 'GM_BLEVEL Success. level changed from ' + IntToStr(oldlevel) + ' to ' + IntToStr(tc.BaseLV) + '.';
                    end

                    else begin
                        Result := Result + ' Supplied level is outwith valid range. <1-32767>.';
                    end;
                end

                else begin
                    Result := Result + ' Supplied level is identical to current.';
                end;
            end

            else begin
                Result := Result + ' Supplied level must be a valid integer.';
            end;
        end

        else begin
            Result := Result + ' Insufficient data. Format is <new base level>.';
        end;
    end;

    function command_jlevel(tc : TChara; str : String) : String;
    var
        newlevel, i, j, k : Integer;
        oldlevel : Integer;
        JIDFix : Integer;
        s : String;
    begin
        Result := 'GM_JLEVEL Failure.';

        s := Copy(str, 8, 256);

        if s <> '' then begin

            oldlevel := tc.JobLV;
            Val(Copy(str, 8, 256), newlevel, k);

            if k = 0 then begin
                if (newlevel >= 1) and (newlevel <= 32767) then begin
                    if newlevel <> tc.JobLV then begin
                        tc.JobLV := newlevel;

                        for i := 1 to MAX_SKILL_NUMBER do begin
                            if not tc.Skill[i].Card then tc.Skill[i].Lv := 0;
                        end;

                        if tc.JID = 0 then tc.SkillPoint := tc.JobLV - 1
                        else if tc.JID < 7 then tc.SkillPoint := tc.JobLV - 1 + 9
                        else tc.SkillPoint := tc.JobLV - 1 + 49 + 9;

                        SendCSkillList(tc);

                        if (tc.JobNextEXP = 0) then tc.JobNextEXP := 999999999;
                        tc.JobEXP := tc.JobNextEXP - 1;

                        JIDFix := JIDFixer(tc.JID);
                        case JIDFix of
                            1..6: j := 2;
                            7..22: j := 3;
                            23: j := 4;
                            24: j := 6;
                            25..30: j := 7;
                            31..45: j := 8;
                            else j := 8;
                        end;

                        tc.JobNextEXP := ExpTable[j][tc.JobLV];

                        CalcStat(tc);

                        SendCStat(tc);
                        SendCStat1(tc, 0, $0037, tc.JobLV);
                        SendCStat1(tc, 0, $000c, tc.SkillPoint);
                        SendCStat1(tc, 1, $0002, tc.JobEXP);

                        Result := 'GM_JLEVEL Success. level changed from ' + IntToStr(oldlevel) + ' to ' + IntToStr(tc.JobLV) + '.';
                    end

                    else begin
                        Result := Result + ' Supplied level is identical to current.';
                    end;
                end

                else begin
                    Result := Result + ' Supplied level is outwith valid range. <1-32767>.';
                end;
            end

            else begin
                Result := Result + ' Supplied level must be a valid integer.';
            end;
        end

        else begin
            Result := Result + ' Insufficient data. Format is <new job level>.';
        end;
    end;

    function command_changestat(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        stat, value, k : Integer;
    begin
        Result := 'GM_CHANGESTAT Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 12, 256);

        if (sl.Count = 2) then begin
            Val(sl[0], stat, k);

            if k = 0 then begin

                if(stat >= 0) and (stat <= 5) then begin
                    Val(sl[1], value, k);

                    if k = 0 then begin

                        if(value >= 1) and (value <= 32767) then begin
                            tc.ParamBase[stat] := value;

                            CalcStat(tc);

                            SendCStat(tc);
                            SendCStat1(tc, 0, $0009, tc.StatusPoint);

                            Result := 'GM_CHANGESTAT Success. ';
                            if stat = 0 then Result := Result + 'Strength'
                            else if stat = 1 then Result := Result + 'Agility'
                            else if stat = 2 then Result := Result + 'Vitality'
                            else if stat = 3 then Result := Result + 'Intelligence'
                            else if stat = 4 then Result := Result + 'Dexterity'
                            else if stat = 5 then Result := Result + 'Luck ';
                            Result := Result + ' changed to ' + IntToStr(value) + '.';
                        end

                        else begin
                            Result := Result + ' Supplied value is out of valid range. <1-32767>.';
                        end;
                    end

                    else begin
                        Result := Result + ' Supplied value must be a valid integer.';
                    end;
                end

                else begin
                    Result := Result + ' Supplied stat index is out of valid range. <0-5>';
                end;
            end

            else begin
                Result := Result + ' Supplied stat index must be a valid integer.';
            end;
        end

        else begin
            Result := Result + ' Insufficient data. Format is <stat index> <new value>.';
        end;
        sl.Free;
    end;

    function command_skillpoint(tc : TChara; str : String) : String;
    var
        newpoints, k : Integer;
        s : String;
    begin
        Result := 'GM_SKILLPOINT Failure.';

        s := Copy(str, 12, 256);

        if s <> '' then begin

            Val(Copy(str, 12, 256), newpoints, k);
            if k = 0 then begin
                if (newpoints >= 0) and (newpoints <= 1001) then begin
                    tc.SkillPoint := newpoints;

                    SendCStat1(tc, 0, $000c, tc.SkillPoint);

                    Result := 'GM_SKILLPOINT Success. Skill Point amount set to ' + IntToStr(newpoints) + '.';
                end

                else begin
                    Result := Result + ' Supplied value is out of valid range <0-1001>.';
                end;
            end

            else begin
                Result := Result + ' Supplied value must be a valid integer.';
            end;
        end

        else begin
            Result := Result + ' Insufficient data. Format is <new value>.';
        end;
    end;

    function command_skillall(tc : TChara) : String;
    var
        job, i : Integer;
    begin
        Result := 'GM_SKILLALL Success.';

        job := tc.JID;
        if (job > UPPER_JOB_BEGIN) then job := job - UPPER_JOB_BEGIN + LOWER_JOB_END;
        // (RN 4001 - 4000 + 23 = 24)

        for i := 1 to 157 do begin
            if (tc.Skill[i].Data.Job1[job]) or (tc.Skill[i].Data.Job2[job]) then begin
                tc.Skill[i].Lv := tc.Skill[i].Data.MasterLV;
            end;
        end;

        for i := 210 to MAX_SKILL_NUMBER do begin
            if (tc.Skill[i].Data.Job1[job]) or (tc.Skill[i].Data.Job2[job]) then begin
                tc.Skill[i].Lv := tc.Skill[i].Data.MasterLV;
            end;
        end;

        tc.SkillPoint := 1000;

        SendCSkillList(tc);

        CalcStat(tc);

        SendCStat(tc);
    end;

    function command_statall(tc : TChara) : String;
    var
        i : Integer;
    begin
        Result := 'GM_STATALL Success.';

        for i := 0 to 5 do begin
            tc.ParamBase[i] := 99;
        end;

        tc.StatusPoint := 1000;

        CalcStat(tc);

        SendCStat(tc);
        SendCStat1(tc, 0, $0009, tc.StatusPoint);
    end;

    function command_superstats(tc : TChara) : String;
    var
        i : Integer;
    begin
        Result := 'GM_SUPERSTATS Success.';

        for i := 0 to 5 do begin
            tc.ParamBase[i] := 32767;
        end;

        tc.StatusPoint := 1000;

        CalcStat(tc);

        SendCStat(tc);
        SendCStat1(tc, 0, $0009, tc.StatusPoint);
    end;

    function command_zeny(tc : TChara; str : String) : String;
    var
        value, k : Integer;
        s : String;
    begin
        Result := 'GM_ZENY Failure.';

        s := Copy(str, 6, 256);

        if s <> '' then begin

            Val(Copy(str, 6, 256), value, k);
            if k = 0 then begin
                if (value >= -2147483647) and (value <= 2147483647) then begin
                    if (tc.Zeny + value <= 2147483647) and (tc.Zeny + value >= 0) then begin
                        tc.Zeny := tc.Zeny + value;
                    end

                    else begin
                        if tc.Zeny + value > 214748364 then begin
                            tc.Zeny := 214748364;
                        end

                        else begin
                            tc.Zeny := 0;
                        end;
                        value := value - tc.Zeny;
                    end;
                    SendCStat1(tc, 1, $0014, tc.Zeny);
                    Result := 'GM_ZENY Success. ' + IntToStr(abs(value)) + ' Zeny ';
                    if value = 0 then Result := Result + 'set (no change).'
                    else if value > 0 then Result := Result + 'added.'
                    else if value < 0 then Result := Result + 'subtracted.';
                end

                else begin
                    Result := Result + ' Supplied value is outwith valid range. <-2147483647-2147483647>.';
                end;
            end

            else begin
                Result := Result + ' Supplied value must be a valid integer.';
            end;
        end

        else begin
            Result := Result + ' Insufficient data. Format is <amount to change zeny by>.';
        end;
    end;

    function command_changeskill(tc : TChara; str : String) : String;
    var
        skill, level, k : Integer;
        sl : TStringList;
    begin
        Result := 'GM_CHANGESKILL Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 13, 256);

        if (sl.Count = 2) then begin
            Val(sl.Strings[0], skill, k);
            if k = 0 then begin
                Val(sl.Strings[1], level, k);
                if k = 0 then begin

                    if ((skill >= 1) and (skill <= 157)) or ((skill >= 210) and (skill <= MAX_SKILL_NUMBER)) then begin
                        if (level > tc.Skill[skill].Data.MasterLV) then level := tc.Skill[skill].Data.MasterLV;
                        tc.Plag := skill;
                        tc.PLv := level;
                        tc.Skill[skill].Plag := true;

                        SendCSkillList(tc);

                        CalcStat(tc);

                        SendCStat(tc);

                        Result := 'GM_CHANGESKILL Success. Skill ' + tc.Skill[skill].Data.Name + ' set to level ' + IntToStr(level) + '.';
                    end

                    else begin
                        Result := Result + ' Supplied skill ID is out of valid range <1-157,210-' + IntToStr(MAX_SKILL_NUMBER) + '>.';
                    end;
                end

                else begin
                    Result := Result + ' Supplied level must be a valid integer.';
                end;
            end

            else begin
                Result := Result + ' Supplied skill ID must be a valid integer.';
            end;
        end

        else begin
            Result := Result + ' Insufficient data. Format is <skill ID> <level>.';
        end;
        sl.Free;
    end;

    function command_monster(tc : TChara; str : String) : String;
    var
        ts, ts1 : TMob;
        tm : TMap;
        h, i, j, k, l : Integer;
        sl : TStringList;
        tss : TSlaveDB;
    begin
        Result := 'GM_MONSTER Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 9, 256);
        if sl.Count = 2 then begin
            if (MobDBName.IndexOf(sl.Strings[0]) <> -1) then begin
                Val(sl.Strings[1], j, k);

                if(j >= 1) and (j <= 20) then begin
                    for l := 1 to j do begin
                        tm := tc.MData;

                        ts := TMob.Create;
                        ts.Data := MobDBName.Objects[MobDBName.IndexOf(sl.Strings[0])] as TMobDB;
                        ts.ID := NowMobID;
                        Inc(NowMobID);
                        ts.Name := ts.Data.JName;
                        ts.JID := ts.Data.ID;
                        ts.Map := tc.Map;
                        ts.Data.isLink :=false;
                        ts.Point.X := tc.Point.X + Random(2) - 1;
                        ts.Point.Y := tc.Point.Y + Random(2) - 1;
                        ts.Dir := Random(8);
                        ts.HP := ts.Data.HP;
                        ts.Speed := ts.Data.Speed;
                        ts.SpawnDelay1 := $7FFFFFFF;
                        ts.SpawnDelay2 := 0;
                        ts.SpawnType := 0;
                        ts.SpawnTick := 0;
                        if ts.Data.isDontMove then ts.MoveWait := $FFFFFFFF
                        else ts.MoveWait := timeGetTime;
                        ts.ATarget := 0;
                        ts.ATKPer := 100;
                        ts.DEFPer := 100;
                        ts.DmgTick := 0;
                        ts.Element := ts.Data.Element;

                        if (SummonMonsterName = true) then ts.Name := ts.Data.JName
                        else ts.Name := 'Summon Monster';

                        if (SummonMonsterExp = false) then begin
                            ts.Data.MEXP := 0;
                            ts.Data.EXP := 0;
                            ts.Data.JEXP := 0;
                        end;

                        if (SummonMonsterAgo = true) then ts.isActive := true
                        else ts.isActive := ts.Data.isActive;

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
                            ts.MVPDist[0].Dmg := ts.Data.HP * 30 div 100;
                        end;

                        ts.isSummon := True;
                        ts.EmperiumID := 0;

                        tm.Mob.AddObject(ts.ID, ts);
                        tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);

                        SendMData(tc.Socket, ts);
                        SendBCmd(tm,ts.Point,41,tc,False);

                        Result := 'GM_MONSTER Success. ' + ts.Name + ' summoned at ' + tm.Name + ' (' + IntToStr(ts.Point.X) + ',' + IntToStr(ts.Point.Y) + ')';

                        if (SummonMonsterMob = true) then begin
                            k := SlaveDBName.IndexOf(sl.Strings[0]);
                            if (k <> -1) then begin
                                ts.isLeader := true;

                                tss := SlaveDBName.Objects[k] as TSlaveDB;
                                if sl.Strings[0] = tss.Name then begin
                                    h := tss.TotalSlaves;
                                    ts.SlaveCount := h;
                                    repeat
                                        for i := 0 to 4 do begin
                                            if (tss.Slaves[i] <> -1) and (h <> 0) then begin
                                                ts1 := TMob.Create;
                                                ts1.Data := MobDBName.Objects[tss.Slaves[i]] as TMobDB;
                                                ts1.ID := NowMobID;
                                                ts.Slaves[h] := ts1.ID;
                                                Inc(NowMobID);
                                                ts1.Name := ts1.Data.JName;
                                                ts1.JID := ts1.Data.ID;
                                                ts1.LeaderID := ts.ID;
                                                ts1.Data.isLink := false;
                                                ts1.Map := ts.Map;
                                                ts1.Point := ts.Point;
                                                ts1.Dir := ts.Dir;
                                                ts1.HP := ts1.Data.HP;

                                                if ts.Data.Speed < ts1.Data.Speed then ts1.Speed := ts.Data.Speed
                                                else ts1.Speed := ts1.Data.Speed;

                                                ts1.SpawnDelay1 := $7FFFFFFF;
                                                ts1.SpawnDelay2 := 0;
                                                ts1.SpawnType := 0;
                                                ts1.SpawnTick := 0;

                                                if ts1.Data.isDontMove then ts1.MoveWait := $FFFFFFFF
                                                else ts1.MoveWait := ts.MoveWait;
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
                                                    ts1.MVPDist[0].Dmg := ts1.Data.HP * 30 div 100;
                                                end;

                                                tm.Mob.AddObject(ts1.ID, ts1);
                                                tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);

                                                ts1.isSummon := true;
                                                ts1.isSlave := true;
                                                ts1.EmperiumID := 0;

                                                SendMData(tc.Socket, ts1);
                                                SendBCmd(tm,ts1.Point,41,tc,False);

                                                h := h - 1;
                                            end;
                                        end;
                                    until (h <= 0);
                                end;
                            end;
                        end;
                    end;
                end else begin
                    Result := Result + ' Quantity out of range [0-20].';
                end;
            end;
        end else begin
            Result := Result + ' Incomplete information.';
        end;

        sl.Free;
    end;

    function command_speed(tc : TChara; str : String) : String;
    var
        sl : TStringList;
    begin
        Result := 'GM_SPEED Failure.';

        sl := tstringlist.Create;
        sl.DelimitedText := str;

        if (sl.count = 2) then begin
            if (strtoint(sl.Strings[1]) >= 25) and (strtoint(sl.Strings[1]) <= 1000) then begin
                Result := 'GM_SPEED Success. Speed changed from ' + IntToStr(tc.Speed);
                str := 'Walking speed is now ' + sl.Strings[1];
                tc.DefaultSpeed := strtoint(sl.strings[1]);
                CalcStat(tc);
                SendCStat1(tc, 0, 0, tc.Speed);
                Result := Result + ' to ' + IntToStr(tc.Speed) + '.';
            end else begin
                Result := Result + ' Speed out of range [25-1000].';
            end;
        end else begin
            Result := Result + ' Incomplete information.';
        end;

        sl.Free;
    end;

    function command_whois(tc : TChara) : String;
    var
        str2 : String;
        tc1 : TChara;
        i : Integer;
    begin
        Result := 'GM_WHOIS Failure.';

        str2 := 'Online Users: ';
        for i := 0 to CharaName.Count - 1 do begin
            tc1 := CharaName.Objects[i] as TChara;
            if tc1.Login = 2 then begin
                if str2 = 'Online Users: ' then begin
                    str2 := str2 + tc1.Name;
                end else begin
                    str2 := str2 + ',' + tc1.Name;
                end;
            end;
        end;

        Result := 'GM_WHOIS Success. ' + str2 + '.';
    end;

    function command_option(tc : TChara; str : String) : String;
    var
        tm : TMap;
    begin
        Result := 'GM_OPTION Success.';

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

        if Copy(str, 8, 5) = 'sight' then begin
            tc.Option := tc.Option or 1;
            Result := Result + ' Sight activated.';
        end else if Copy(str, 8, 6) = 'ruwach' then begin
            tc.Option := tc.Option or 8192;
            Result := Result + ' Ruwach activated.';
        end else if ((tc.JID IN [ 5, 10, 18, 23 ]) OR (tc.JID = 4006) OR (tc.JID = 4011) OR (tc.JID = 4019)) AND (Copy(str, 8, 4) = 'cart') then begin
            tc.Option := tc.Option or 8;
            SendCart(tc);
            Result := Result + ' Cart activated.';
        end else if (((tc.JID = 11) OR (tc.JID = 4012)) AND (Copy(str, 8, 6) = 'falcon')) then begin
            tc.Option := tc.Option or $10;
            Result := Result + ' Falcon activated.';
        end else if ((tc.JID IN [ 7, 14 ]) OR (tc.JID = 4008) OR (tc.JID = 4014) OR (tc.JID = 4015) OR (tc.JID = 4023 )) AND ((Copy(str, 8, 4) = 'peko') or (Copy(str, 8, 4) = 'peco')) then begin
            tc.Option := tc.Option or $20;
            Result := Result + ' Peco activated.';
        end else if Copy(str, 8, 3) = 'off' then begin
            tc.Option := 0;
            Result := Result + ' Options turned off.';
        end else begin
            Result := 'GM_OPTION Failure. Make sure you are the correct job type.';
        end;
        UpdateOption(tm, tc);

    end;

    function command_raw(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        i : Integer;
    begin
        Result := 'GM_RAW Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 5, 256);

        if (sl.Count > 0) then begin;

            for i := 0 to sl.Count - 1 do begin
                // I really doubt this is right, but oh well.
                // This command doesn't seem to work.
                WFIFOB(i, StrToInt('$' + sl.Strings[i]));
            end;
            tc.socket.SendBuf(buf, i);

            Result := 'GM_RAW Success. Packet string, ' + str + ' sent.';
        end else begin
            Result := Result + ' Incomplete information.';
        end;

        sl.Free;
    end;

    function command_unit(tc : TChara; str : String) : String;
    var
        j, k : Integer;
        tm : TMap;
    begin
        Result := 'GM_UNIT Failure. Incomplete information or out of range [0-999].';

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        Val(Copy(str, 6, 256), j, k);
        if (k <> 0) or (j < 0) or (j > 999) then Exit;
        SetSkillUnit(tm, tc.ID, Point(tc.Point.X + 1, tc.Point.Y - 1), timeGetTime(), j, 1, 10000);

        Result := 'GM_UNIT Success.';
    end;

    function command_stat(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        i, j, k, l, ii : Integer;
        tm : TMap;
    begin
        Result := 'GM_STAT Failure.';

        sl := tstringlist.Create;
        sl.DelimitedText := str;

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

        if (sl.count = 5) then begin
            val(sl.Strings[1], i, ii);
            if ii <> 0 then Exit;
            val(sl.Strings[2], j, ii);
            if ii <> 0 then Exit;
            val(sl.Strings[3], k, ii);
            if ii <> 0 then Exit;
            val(sl.Strings[4], l, ii);
            if ii <> 0 then Exit;
    
            WFIFOW(0, $0119);
            WFIFOL(2, tc.ID);
            WFIFOW(6, i);
            WFIFOW(8, j);
            WFIFOW(10, k);
            WFIFOB(12, l);
            SendBCmd(tm, tc.Point, 13);
            tc.Stat1 := i;
            tc.Stat2 := j;
            tc.Option := k;

            Result := 'GM_STAT Success. Options set to ' + inttostr(i) + ' ' + inttostr(j) + ' ' + inttostr(k) + ' ' + inttostr(l);
        end else begin
            Result := Result + ' Incomplete information.';
        end;

        sl.Free;
    end;

    function command_refine(tc : TChara; str : String) : String;
    var
        i, j, k : Integer;
        tm : TMap;
    begin
        Result := 'GM_REFINE Failure.';

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

        Val(Copy(str, 8, 256), j, k);
        if (k <> 0) or (j < 0) or (j > 10) then begin
            Result := Result + ' Incomplete information or out of range [0-10].';
            Exit;
        end;

        for i := 1 to 100 do begin
            with tc.Item[i] do begin
                if (ID <> 0) AND (Amount <> 0) AND Data.IEquip AND (Equip <> 0) then begin

                    tc.Item[i].Refine := Byte(j);
                    reset_skill_effects(tc);
                    WFIFOW(0, $00ac);
                    WFIFOW(2, i);
                    WFIFOW(4, tc.Item[i].Equip);
                    WFIFOB(6, 1);
                    tc.Socket.SendBuf(buf, 7);
                    remove_equipcard_skills(tc, i);

                    WFIFOW(0, $0188);
                    WFIFOW(2, 0);
                    WFIFOW(4, i);
                    WFIFOW(6, word(j));
                    tc.Socket.SendBuf(buf, 8);

                    WFIFOW(0, $00aa);
                    WFIFOW(2, i);
                    WFIFOW(4, tc.Item[i].Equip);
                    WFIFOB(6, 1);
                    tc.Socket.SendBuf(buf, 7);
                end;
            end;
        end;
        
        WFIFOW(0, $019b);
        WFIFOL(2, tc.ID);
        WFIFOL(6, 3);
        SendBCmd(tm, tc.Point, 10, tc);
        CalcStat(tc);
        SendCStat(tc);

        Result := 'GM_REFINE Success. Equipment refined to level ' + IntToStr(j) + '.';
    end;

    function command_glevel(tc : TChara; str : String) : String;
    var
        i, j, k : Integer;
        oldlevel : Integer;
        tg : TGuild;
    begin
        Result := 'GM_GLEVEL Failure.';

        j := GuildList.IndexOf(tc.GuildID);
        tg := GuildList.Objects[j] as TGuild;

        oldlevel := tg.LV;

        if (tg <> NIL) and (tc.GuildID = tg.ID) then begin
            Val(Copy(str, 8 , 256), i, k);
            if (k = 0) and (i >= 1) and (i <= 99) then begin
                tg.LV := i;
                for j := 10000 to 10004 do begin
                    tg.GSkill[j].Lv := 0;
                end;

                tg.GSkillPoint := tg.LV -1;
                tg.EXP := tg.NextEXP -1;
                SendGuildInfo(tc, 3, true);

                tg.NextEXP := GExpTable[tg.LV];
                SendGuildInfo(tc, 0, true);
                SendGuildInfo(tc, 1, true);

                Result := 'GM_GLEVEL Success. ' + tg.Name + ' level raised from ' + inttostr(oldlevel) + ' to ' + inttostr(i) + '.';
            end else begin
                Result := Result + ' Information incomplete or out of range [1-99].';
            end;
        end else begin
            Result := Result + ' Guild does not exist.';
        end;
    end;


    function command_ironical(tc : TChara) : String;
    var
        tm : TMap;
    begin
        Result := 'GM_IRONICAL Failure.';

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        
        WFIFOW(0, $0119);
        WFIFOL(2, tc.ID);
        WFIFOW(6, 0);
        WFIFOW(8, 2);
        WFIFOW(10, 64);
        WFIFOB(12, 0);
        SendBCmd(tm, tc.Point, 13);
        tc.Stat1 := 0;
        tc.Stat2 := 2;
        tc.Option := 64;

        Result := 'GM_IRONICAL Success.';
    end;

    function command_mothball(tc : TChara) : String;
    var
        i  : Integer;
        tm : TMap;
        tc1 : TChara;
    begin
        Result := 'GM_MOTHBALL Success.';

        if tc.Stat2 >= 16 then begin
            Result := Result + ' Command deactivated.';
            tc.Stat2 := tc.Stat2 - 16;
            if tc.Stat2 < 0 then tc.Stat2 := 0
        end else begin
            Result := Result + ' Command activated.';
            tc.Stat2 := tc.Stat2 + 16;
        end;

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        for i := 0 to charaname.count - 1 do begin
            tc1 := charaname.objects[i] as tchara;
            if (tc1.login = 2) then begin
                WFIFOW(0, $0119);
                WFIFOL(2, tc1.ID);
                WFIFOW(6, 0);
                WFIFOW(8, tc.Stat2);
                WFIFOW(10, 0);
                WFIFOB(12, 0);
                SendBCmd(tm, tc1.Point, 13);
            end;
        end;

    end;

    function command_where(tc : TChara; str : String) : String;
    var
        s : String;
        tc1 : TChara;
    begin
        Result := 'GM_WHERE Failure.';

        s := Copy(str, 7, 256);
        if s = '' then begin
            Result := 'GM_WHERE Success. ' + tc.Name + ' located at: ' + tc.Map + ' (' + IntToStr(tc.Point.X) + ',' + IntToStr(tc.Point.Y) + ').';
        end else if CharaName.IndexOf(s) <> -1 then begin
            tc1 := CharaName.Objects[CharaName.IndexOf(s)] as TChara;
            if tc1.Login <> 2 then begin
                Result := Result + ' ' + tc1.Name + ' is not logged in.';
            end else begin
                Result := 'GM_WHERE Success. ' + tc1.Name + ' located at: ' + tc1.Map + ' (' + IntToStr(tc1.Point.X) + ',' + IntToStr(tc1.Point.Y) + ').';
            end;
        end else begin
            Result := Result + ' Couldnt find player ' + s + '.';
        end;
    end;

    function command_revive(str : String) : String;
    var
        s : String;
        tc1 : TChara;
        tm : TMap;
    begin
        Result := 'GM_REVIVE Failure.';

        s := Copy(str, 8, 256);
        s := Trim(s);
        if CharaName.IndexOf(s) <> -1 then begin
            tc1 := CharaName.Objects[CharaName.IndexOf(s)] as TChara;
            tm := Map.Objects[Map.IndexOf(tc1.Map)] as TMap;

            tc1.HP := tc1.MAXHP;
            tc1.SP := tc1.MAXSP;
            tc1.Sit := 3;
            SendCStat1(tc1,0,5,tc1.HP);
            SendCStat1(tc1,0,7,tc1.SP);
            WFIFOW( 0, $0148);
            WFIFOL( 2, tc1.ID);
            WFIFOW( 6, 100);
            SendBCmd(tm, tc1.Point, 8);

            Result := 'GM_REVIVE Success. ' + tc1.Name + ' revived.'; 
        end else begin
            Result := Result + ' Character ' + s + ' not found.';
        end;
    end;

    function command_ban(str : String) : String;
    var
        s : String;
        tc1 : TChara;
        tp1 : TPlayer;
    begin
        Result := 'GM_BAN Success.';

        s := Copy(str, 5, 256);
        s := Trim(s);
        if CharaName.IndexOf(s) <> -1 then begin
            tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;
            tp1 := Player.IndexOfObject(tc1.ID) as TPlayer;

            if tp1.Banned = False then begin
                Result := Result + ' ' + tc1.Name + ' has been banned.';
                tp1.Banned := True;
            end else begin
                Result := Result + ' ' + tc1.Name + ' has been un-banned.';
                tp1.Banned := False;
            end;
        end else begin
            Result := 'GM_BAN Failure. Character ' + s + ' not found.';
        end;
    end;

    function command_kick(str : String) : String;
    var
        s : String;
        tc1 : TChara;
    begin
        Result := 'GM_KICK Failure.';
        s := Copy(str, 6, 256);
        s := Trim(s);

        if CharaName.Indexof(s) <> -1 then begin
            tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;
            if tc1.Login = 2 then begin
                tc1.Socket.Close;
                Result := 'GM KICK Success. Character ' + tc1.Name + ' has been kicked.';
            end else begin
                Result := Result + ' Character ' + s + ' is not online.';
            end;
        end else begin
            Result := Result + ' Character ' + s + ' does not exist.';
        end;
    end;

    function command_icon(tc : TChara; str : String) : String;
    var
        i, j, k : Integer;
        tm : TMap;
    begin
        Result := 'GM_ICON Failure.';

        Val(Copy(str, 6, 256), i, k);
        
        if (k = 0) then begin
            for j := i to i do begin
                tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
                UpdateIcon(tm, tc, j, 1);
            end;
            Result := 'GM_ICON Success. Icon ' + IntToStr(j-1) + ' set.';
        end else begin
            Result := Result + ' Invalid input. Integer input required.';
        end;
    end;
    
    function command_unicon(tc : TChara; str : String) : String;
    var
        i, j, k : Integer;
        tm : TMap;
    begin
        Result := 'GM_UNICON Failure.';

        Val(Copy(str, 8, 256), i, k);
        
        if (k = 0) then begin
            for j := i to i do begin
                tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
                UpdateIcon(tm, tc, j, 0);
            end;
            Result := 'GM_UNICON Success. Icon ' + IntToStr(j-1) + ' unset.';
        end else begin
            Result := Result + ' Invalid input. Integer input required.';
        end;
    end;

    function command_server() : String;
    begin
        Result := 'Ragnarok Online Server powered by Fusion Server Software - ' + RELEASE_VERSION + '.';
    end;

    function command_pvpon(tc : TChara) : String;
    var
        mi : MapTbl;
        tc1 : TChara;
        i, k : Integer;
        tm : TMap;
    begin
        Result := 'GM_PVPON Failure.';

        if MapInfo.IndexOf(tc.Map) <> -1 then begin
            mi := MapInfo.Objects[MapInfo.IndexOf(tc.Map)] as MapTbl;
            if (mi.PvP = true) then begin
                Result := Result + ' PVP already enabled on map ' + tc.Map + '.';
            end else begin
                mi.PvP := true;
                tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

                for i := 0 to tm.CList.Count - 1 do begin
                    tc1 := tm.CList.Objects[0] as TChara;

                    if (tc1.Hidden = false) then SendCLeave(tc1, 2);
                    tc1.tmpMap := LowerCase(tc1.Map);
                    tc1.Point := Point(tc1.Point.X, tc1.Point.Y);
                    MapMove(tc1.Socket, LowerCase(tc1.Map), Point(tc1.Point.X, tc1.Point.Y));
                end;

                Result := 'GM_PVPON Success. PVP enabled on map ' + tc1.Map + '.';
            end;
        end else begin
            Result := Result + ' Map ' + tc.Map + ' not found.';
        end;
    end;

    function command_pvpoff(tc : TChara) : String;
    var
        mi : MapTbl;
        tc1 : TChara;
        i, k : Integer;
        tm : TMap;
    begin
        Result := 'GM_PVPOFF Failure.';

        if MapInfo.IndexOf(tc.Map) <> -1 then begin;
            mi := MapInfo.Objects[MapInfo.IndexOf(tc.Map)] as MapTbl;

            if (mi.PvP = false) then begin
                Result := Result + ' PVP already disabled on map ' + tc.Map + '.';
            end else begin
                mi.PvP := false;
                tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

                for i := 0 to tm.CList.Count - 1 do begin
                    tc1 := tm.CList.Objects[0] as TChara;

                    if (tc1.Hidden = false) then SendCLeave(tc1, 2);
                    tc1.tmpMap := LowerCase(tc1.Map);
                    tc1.Point := Point(tc1.Point.X, tc1.Point.Y);
                    MapMove(tc1.Socket, LowerCase(tc1.Map), Point(tc1.Point.X, tc1.Point.Y));
                end;

                Result := 'GM_PVPOFF Success. PVP disabled on map ' + tc1.Map + '.';
            end;
        end else begin
            Result := Result + ' Map ' + tc.Map + ' not found.';
        end;
    end;

    function command_gpvpon(tc : TChara) : String;
    var
        mi : MapTbl;
        tc1 : TChara;
        i, k : Integer;
        tm : TMap;
    begin
        Result := 'GM_GPVPON Failure.';

        if MapInfo.IndexOf(tc.Map) <> -1 then begin;
            mi := MapInfo.Objects[MapInfo.IndexOf(tc.Map)] as MapTbl;
            if (mi.PvPG = true) then begin
                Result := Result + ' PVPG already enabled on map ' + tc.Map + '.';
            end else begin
                mi.PvPG := true;
                tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

                for i := 0 to tm.CList.Count - 1 do begin
                    tc1 := tm.CList.Objects[0] as TChara;

                    if (tc1.Hidden = false) then SendCLeave(tc1, 2);
                    tc1.tmpMap := LowerCase(tc1.Map);
                    tc1.Point := Point(tc1.Point.X, tc1.Point.Y);
                    MapMove(tc1.Socket, LowerCase(tc1.Map), Point(tc1.Point.X, tc1.Point.Y));
                end;

                Result := 'GM_GPVPON Success. PVPG enabled on map ' + tc1.Map + '.';
            end;
        end else begin
            Result := Result + ' Map ' + tc.Map + ' not found.';
        end;
    end;

    function command_gpvpoff(tc : TChara) : String;
    var
        mi : MapTbl;
        tc1 : TChara;
        i, k : Integer;
        tm : TMap;
    begin
        Result := 'GM_GPVPOFF Failure.';

        if MapInfo.IndexOf(tc.Map) <> -1 then begin;
            mi := MapInfo.Objects[MapInfo.IndexOf(tc.Map)] as MapTbl;

            if (mi.PvPG = false) then begin
                Result := Result + ' PVPG already disabled on map ' + tc.Map + '.';
            end else begin
                mi.PvPG := false;
                tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

                for i := 0 to tm.CList.Count - 1 do begin
                    tc1 := tm.CList.Objects[0] as TChara;

                    if (tc1.Hidden = false) then SendCLeave(tc1, 2);
                    tc1.tmpMap := LowerCase(tc1.Map);
                    tc1.Point := Point(tc1.Point.X, tc1.Point.Y);
                    MapMove(tc1.Socket, LowerCase(tc1.Map), Point(tc1.Point.X, tc1.Point.Y));
                end;

                Result := 'GM_GPVPOFF Success. PVPG disabled on map ' + tc1.Map + '.';
            end;
        end else begin
            Result := Result + ' Map ' + tc.Map + ' not found.';
        end;
    end;

    function command_newplayer(str : String) : String;
    var
        sl : TStringList;
    begin
        Result := 'GM_NEWPLAYER Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 11, 256);

        if sl.Count = 4 then begin;
            if PlayerName.IndexOf(sl.Strings[0]) <> -1 then begin
                Result := Result + ' Player name ' + sl.Strings[0] + ' already exists.';
            end else if (Length(sl.Strings[0]) < 4) or (Length(sl.strings[1]) < 4) then begin
                Result := Result + ' Player name and password must be at least 4 character long.';
            end else if (sl.strings[2] <> '1') and (sl.strings[2] <> '0') then begin
                Result := Result + ' Gender can only be 1 (Male) or 2 (Female).';
            end else begin
                create_account(sl.Strings[0], sl.Strings[1], sl.Strings[3], sl.Strings[2]);
                Result := 'GM_NEWPLAYER Success. ' + sl.Strings[0] + ' has been added successfully.';
            end;
        end else begin
            Result := Result + ' Incomplete information. Syntax: #newplayer [username] [password] [gender 1|0] [email].';
        end;

        sl.Free;
    end;

    function command_pword(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        tp1 : TPlayer;
    begin
        Result := 'GM_PWORD Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 7, 256);
        if sl.Count = 2 then begin;

            if length(sl.Strings[0]) < 4 then begin
                Result := Result + ' Passwords must be at least 4 characters long.';
            end else if (sl.Strings[0] = ' ') or (sl.Strings[1] = ' ') then begin
                Result := Result + ' You have to enter a new password and your email address.';
            end else begin
                tp1 := Player.IndexOfObject(tc.ID) as TPlayer;

                if sl.Strings[1] <> tp1.Mail then begin
                    Result := Result + ' Your email address didnt match the one you entered.';
                end else begin
                    tp1.Pass := sl.Strings[0];
                    Result := 'GM_PWORD Success. Password changed. New Password: ' + tp1.Pass + '.';
                end;
            end;
        end else begin
            Result := Result + ' Incomplete information. Syntax: #pword [newpass] [email].';
        end;

        sl.Free;
    end;

    function command_users() : String;
    var
        tc1 : TChara;
        i : Integer;
    begin
        Result := 'Users currently logged in: ';

        for i := 0 to CharaName.Count - 1 do begin
            tc1 := CharaName.Objects[i] as TChara;
            if tc1.Login = 2 then begin
                if Result = 'Users currently logged in: ' then begin
                    Result := Result + tc1.Name;
                end else begin
                    Result := Result + ', ' + tc1.Name;
                end;
            end;
        end;

        Result := Result + '.';
    end;

    function command_charblevel(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        tc1 : TChara;
        tm : TMap;
        oldlevel : Integer;
        i, k, w3 : Integer;
    begin
        Result := 'GM_CHARBLEVEL Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 12, 256);

        if sl.Count <> 2 then Exit;
        Val(sl.Strings[1], i, k);

        if CharaName.Indexof(sl.Strings[0]) <> -1 then begin
            tc1 := CharaName.Objects[CharaName.Indexof(sl.Strings[0])] as TChara;

            if (tc1.Login = 2) then begin
                tm := Map.Objects[Map.IndexOf(tc1.Map)] as TMap;

                oldlevel := tc1.BaseLV;

                if (k = 0) and (i >= 1) and (i <= 32767) and (i <> tc1.BaseLV) then begin
                    if tc1.BaseLV > i then begin
                        tc1.BaseLV := i;

                        for i := 0 to 5 do begin
                            tc1.ParamBase[i] := 1;
                        end;

                        tc1.StatusPoint := 48;

                        for i := 1 to tc1.BaseLV - 1 do begin
                            tc1.StatusPoint := tc1.StatusPoint + i div 5 + 3;
                        end;
                    end

                    else begin
                        w3 := tc1.BaseLV;
                        tc1.BaseLV := i;

                        for i := w3 to tc1.BaseLV - 1 do begin
                            tc1.StatusPoint := tc1.StatusPoint + i div 5 + 3;
                        end;
                    end;

                    if (tc1.BaseNextEXP = 0) then tc1.BaseNextEXP := 999999999;
                    tc1.BaseEXP := tc1.BaseNextEXP - 1;
                    if tc1.JID > 23 then tc1.BaseNextEXP := ExpTable[5][tc1.BaseLV]
                    else tc1.BaseNextEXP := ExpTable[0][tc1.BaseLV];

                    CalcStat(tc1);
                    SendCStat(tc1);
                    SendCStat1(tc1, 0, $000b, tc1.BaseLV);
                    SendCStat1(tc1, 0, $0009, tc1.StatusPoint);
                    SendCStat1(tc1, 1, $0001, tc1.BaseEXP);

                    Result := 'GM_CHARBLEVEL Success. Level of ' + sl.Strings[0] + ' changed from ' + IntToStr(oldlevel) + ' to ' + IntToStr(tc1.BaseLV) + '.';
                end else begin
                    Result := Result + ' Incomplete information or level out of range.';
                end;
            end else begin
                Result := Result + sl.Strings[0] + ' is not logged in.';
            end;
        end else begin
            Result := Result + ' Character ' + sl.Strings[0] + ' does not exist.';
        end;
    sl.Free;
    end;

    function command_charjlevel(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        tc1 : TChara;
        tm : TMap;
        oldlevel : Integer;
        i, k, w3 : Integer;
        JIDFix : word;
    begin
        Result := 'GM_CHARJLEVEL Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 12, 256);

        if sl.Count <> 2 then Exit;
        Val(sl.Strings[1], i, k);

        if CharaName.Indexof(sl.Strings[0]) <> -1 then begin
            tc1 := CharaName.Objects[CharaName.Indexof(sl.Strings[0])] as TChara;

            if (tc1.Login = 2) then begin
                tm := Map.Objects[Map.IndexOf(tc1.Map)] as TMap;

                oldlevel := tc1.JobLV;

                if (k = 0) and (i >= 1) and (i <= 32767) and (i <> tc1.JobLV) then begin
                    tc1.JobLV := i;

                    for i := 1 to MAX_SKILL_NUMBER do begin
                        if not tc1.Skill[i].Card then tc1.Skill[i].Lv := 0;
                    end;

                    if tc1.JID = 0 then tc1.SkillPoint := tc1.JobLV - 1
                    else if tc1.JID < 7 then tc1.SkillPoint := tc1.JobLV - 1 + 9
                    else tc1.SkillPoint := tc1.JobLV - 1 + 49 + 9;

                    SendCSkillList(tc1);

                    if (tc1.JobNextEXP = 0) then tc1.JobNextEXP := 999999999;
                    tc1.JobEXP := tc1.JobNextEXP - 1;

                    JIDFix := JIDFixer(tc1.JID);
                    case JIDFix of
                        0: w3 := 1;
                        1..6: w3 := 2;
                        7..22: w3 := 3;
                        23: w3 := 4;
                        24: w3 := 6;
                        25..30: w3 := 7;
                        31..45: w3 := 8;
                        else w3 := 8;
                    end;
                    tc1.JobNextEXP := ExpTable[w3][tc1.JobLV];

                    CalcStat(tc1);
                    SendCStat(tc1);
                    SendCStat1(tc1, 0, $0037, tc1.JobLV);
                    SendCStat1(tc1, 0, $000c, tc1.SkillPoint);
                    SendCStat1(tc1, 1, $0002, tc1.JobEXP);

                    Result := 'GM_CHARJLEVEL Success. Level of ' + sl.Strings[0] + ' changed from ' + IntToStr(oldlevel) + ' to ' + IntToStr(tc1.JobLV) + '.';
                end else begin
                    Result := Result + ' Incomplete information or level out of range.';
                end;
            end else begin
                Result := Result + sl.Strings[0] + ' is not logged in.';
            end;
        end else begin
            Result := Result + ' Character ' + sl.Strings[0] + ' does not exist.';
        end;
    sl.Free;
    end;

    function command_charstatpoint(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        tc1 : TChara;
        tm : TMap;
        oldvalue : Integer;
        i, k, w3 : Integer;
    begin
        Result := 'GM_CHARSTATPOINT Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 15, 256);

        if sl.Count <> 2 then Exit;
        Val(sl.Strings[1], i, k);

        if CharaName.Indexof(sl.Strings[0]) <> -1 then begin
            tc1 := CharaName.Objects[CharaName.Indexof(sl.Strings[0])] as TChara;

            if (tc1.Login = 2) then begin
                tm := Map.Objects[Map.IndexOf(tc1.Map)] as TMap;

                oldvalue := tc1.StatusPoint;

                if (k = 0) and (i >= 1) and (i <= 9999) and (i <> tc1.StatusPoint) then begin
                    tc1.StatusPoint := i;

                    SendCStat1(tc1, 0, $0009, tc1.StatusPoint);

                    Result := 'GM_CHARSTATPOINT Success. Status points of ' + sl.Strings[0] + ' changed from ' + IntToStr(oldvalue) + ' to ' + IntToStr(tc1.StatusPoint) + '.';
                end else begin
                    Result := Result + ' Incomplete information or value out of range.';
                end;
            end else begin
                Result := Result + sl.Strings[0] + ' is not logged in.';
            end;
        end else begin
            Result := Result + ' Character ' + sl.Strings[0] + ' does not exist.';
        end;
    sl.Free;
    end;

    function command_charskillpoint(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        tc1 : TChara;
        tm : TMap;
        oldvalue : Integer;
        i, k : Integer;
    begin
        Result := 'GM_CHARSKILLPOINT Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 16, 256);

        if sl.Count <> 2 then Exit;
        Val(sl.Strings[1], i, k);

        if CharaName.Indexof(sl.Strings[0]) <> -1 then begin
            tc1 := CharaName.Objects[CharaName.Indexof(sl.Strings[0])] as TChara;

            if (tc1.Login = 2) then begin
                tm := Map.Objects[Map.IndexOf(tc1.Map)] as TMap;

                oldvalue := tc1.SkillPoint;

                if (k = 0) and (i >= 1) and (i <= 1001) and (i <> tc1.SkillPoint) then begin
                    tc1.SkillPoint := i;

                    SendCStat1(tc1, 0, $000c, tc1.SkillPoint);

                    Result := 'GM_CHARSKILLPOINT Success. Skill points of ' + sl.Strings[0] + ' changed from ' + IntToStr(oldvalue) + ' to ' + IntToStr(tc1.SkillPoint) + '.';
                end else begin
                    Result := Result + ' Incomplete information or value out of range.';
                end;
            end else begin
                Result := Result + sl.Strings[0] + ' is not logged in.';
            end;
        end else begin
            Result := Result + ' Character ' + sl.Strings[0] + ' does not exist.';
        end;
    sl.Free;
    end;

    function command_changes(tc : TChara; str : String) : String;
    var
    	changefile : TStringList;
        sl : TStringList;
        length : Integer;
        i : Integer;
    begin
        Result := 'GM_CHANGES Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 6, 256);

        if sl.Count = 2 then begin
	    	changefile := TStringList.Create;
    	    try
            	if sl.Strings[1] = 'core' then begin
                	changefile.LoadFromFile(AppPath + 'documents\changes_core.txt');
                end else if sl.Strings[1] = 'database' then begin
                	changefile.LoadFromFile(AppPath + 'documents\changes_database.txt');
                end else if sl.Strings[1] = 'oscripts' then begin
                	changefile.LoadFromFile(AppPath + 'documents\changes_oscripts.txt');
                end else if sl.Strings[1] = 'cscripts' then begin
                	changefile.LoadFromFile(AppPath + 'documents\changes_cscripts.txt');
                end else if sl.Strings[1] = 'client' then begin
                	changefile.LoadFromFile(AppPath + 'documents\changes_client.txt');
                end else begin
                	Result := Result + ' Incorrect information.';
                    changefile.Free;
                    Exit;
                end;
	        except
    	    	on EFOpenError do begin
                    message_green(tc, 'File not accessible. Contact your server admin.');
                    Result := Result + ' File not accessible.';
                    changefile.Free;
                	Exit;
	            end;
    	    end;

	        if changefile.Count > 150 then length := 150 else length := changefile.Count;
    	    for i := 1 to length do begin
        		message_green(tc, changefile[length-i]);
	        end;
        end else begin
        	message_green(tc, 'Command Syntax:');
            message_green(tc, '#changes <type> -- core | client | database | oscripts | cscripts');

        	Result := Result + ' Not enough information.';
            sl.Free;
            Exit;
        end;

        sl.Free;
        changefile.Free;
        Result := 'GM_CHANGES Success.';
    end;

    function command_iscson(tc : TChara) : String;
    begin
        tc.ISCS := True;
        iscs_console_connect(tc);
        Result := 'GM_ISCSON Success.';
    end;

    function command_iscsoff(tc : TChara) : String;
    begin
        tc.ISCS := False;
        iscs_console_disconnect(tc);
        Result := 'GM_ISCSOFF Success.';
    end;

    function command_autoloot(tc : TChara) : String;
    begin
        if (tc.Auto < 4) or ((tc.Auto > 15) and (tc.Auto < 20)) then begin //Preventing conflict with GM_AUTO
            tc.Auto := tc.Auto + 4;
            Result := 'GM AUTOLOOT On.';
        end else begin
            if ((tc.Auto - 4) < 0 ) then tc.Auto := 0 else tc.Auto := tc.Auto - 4;
            Result := 'GM AUTOLOOT Off.';
        end;
    end;

    function command_gstorage(tc : TChara) : String;
    var
        tg : TGuild;
    begin
        Result := 'GM_GSTORAGE Failure.';

        if GuildList.IndexOf(tc.GuildID) = -1 then begin
            Result := Result + ' Guild does not exist.';
            Exit;
        end;

        tg := GuildList.Objects[GuildList.IndexOf(tc.GuildID)] as TGuild;
        tg.Storage.Count := open_storage(tc, tg.Storage.Item);

        tc.guild_storage := True;

        Result := 'GM_STORAGE Success.';
    end;

    function command_rcon(str : String) : String;
    var
        sl : TStringList;

    begin

        Result := 'RCON Failure:';
        sl := tstringlist.Create;
        sl.DelimitedText := str;

        if (sl.Count >= 3) then begin
            if ((sl.Strings[1] = 'set') or (sl.Strings[1] = 'check')) then begin

                if (sl.Strings[2] = 'wanip') then begin
                    if (sl.Strings[1] = 'set') then begin
                        if (sl.Count >= 4) then begin
                            WAN_IP := sl.Strings[3];
                            Result := 'GM_RCON Set Success. WAN IP is now ' + sl.Strings[3];
                        end else Result := Result + ' WAN IP Change Failure.';
                    end else if (sl.Strings[1] = 'check') then Result := 'GM_RCON Check Success. Current WAN IP is ' + WAN_IP;

                end else if (sl.Strings[2] = 'lanip') then begin
                    if (sl.Strings[1] = 'set') then begin
                        if (sl.Count >= 4) then begin
                            LAN_IP := sl.Strings[3];
                            Result := 'GM_RCON Set Success. LAN IP is now ' + sl.Strings[3];
                        end else Result := Result + ' LAN IP Change Failure.';
                    end else if (sl.Strings[1] = 'check') then Result := 'GM_RCON Check Success. Current LAN IP is ' + LAN_IP;

                end else if (sl.Strings[2] = 'basemultiplier') then begin
                    if (sl.Strings[1] = 'set') then begin
                        if (sl.Count >= 4) then begin
                            if (strtoint(sl.Strings[3]) >= 1) then begin
                                BaseExpMultiplier := (StrToInt(sl.Strings[3]));
                                Result := 'GM_RCON Set Success: Base EXP Multiplier is now ' + sl.Strings[3];
                            end else Result := Result + ' Error with Base Multiplier.';
                        end else Result := Result + ' No Base Multiplier Specified.';
                    end else if (sl.Strings[1] = 'check') then Result := 'GM_RCON Check Success. Current Base EXP Multiplier is ' + IntToStr(BaseEXPMultiplier);

                end else if (sl.Strings[2] = 'jobmultiplier') then begin
                    if (sl.Strings[1] = 'set') then begin
                        if (sl.Count >= 4) then begin
                            if (strtoint(sl.Strings[3]) >= 1) then begin
                                JobExpMultiplier := (StrToInt(sl.Strings[3]));
                                Result := 'GM_RCON Set Success: Job EXP Multiplier is now ' + sl.Strings[3];
                            end else Result := Result + ' Error with Job Multiplier.';
                        end else Result := Result + ' No Job Multiplier Specified.';
                    end else if (sl.Strings[1] = 'check') then Result := 'GM_RCON Check Success. Current Job EXP Multiplier is ' + IntToStr(JobEXPMultiplier);

                end else if (sl.Strings[2] = 'itemmultiplier') then begin
                    if (sl.Strings[1] = 'set') then begin
                        if (sl.Count >= 4) then begin
                            if (strtoint(sl.Strings[3]) >= 1) then begin
                                ItemDropMultiplier := (StrToInt(sl.Strings[3]));
                                Result := 'GM_RCON Set Success: Item Drop Multiplier is now ' + sl.Strings[3];
                            end else Result := Result + ' Error with Item Drop Multiplier.';
                        end else Result := Result + ' No Item Drop Multiplier Specified.';
                    end else if (sl.Strings[1] = 'check') then Result := 'GM_RCON Check Success. Current Job EXP Multiplier is ' + IntToStr(ItemDropMultiplier);

                end else Result := Result + ' Please Specify CHECK or SET with a valid command.';

            end else Result := Result + ' Please Specify CHECK or SET with a valid command.';

        end else Result := Result + ' Please Specify CHECK or SET with a command.';


        sl.Free;
        weiss_ini_save();
    end;

    function command_jail(tc : TChara; str : String) : String;
    var
        s : String;
        tc1 : TChara;
    begin
        Result := 'GM_JAIL Success.';

        s := Copy(str, 6, 256);
        if CharaName.Indexof(s) <> -1 then begin
            Result := 'GM_JAIL Success. ' + s + ' jailed.';
            tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;

            if (tc1.Login = 2) then begin
                SendCLeave(tc1, 2);
                tc1.Map := 'sec_pri';
                tc1.Point := Point(20,80);
                MapMove(tc1.Socket, tc.Map, tc.Point);
            end else begin
                tc1.Map := 'sec_pri';
                tc1.Point := Point(20,80);

                Result := Result + ' But ' + s + ' is offline.';
            end;

        end else begin
            Result := 'GM_JAIL Failure. ' + s + ' is an invalid character name.';
        end;
    end;

    function command_unjail(tc : TChara; str : String) : String;
    var
        s : String;
        tc1 : TChara;
    begin
        Result := 'GM_UNJAIL Success.';

        s := Copy(str, 8, 256);
        if CharaName.Indexof(s) <> -1 then begin
            Result := 'GM_JAIL Success. ' + s + ' unjailed.';
            tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;

            if (tc1.Login = 2) then begin
                SendCLeave(tc1, 2);
                tc1.Map := 'prontera';
                tc1.Point := Point(150,170);
                MapMove(tc1.Socket, tc.Map, tc.Point);
            end else begin
                tc1.Map := 'prontera';
                tc1.Point := Point(150,170);

                Result := Result + ' But ' + s + ' is offline.';
            end;

        end else begin
            Result := 'GM_JAIL Failure. ' + s + ' is an invalid character name.';
        end;
    end;

    function command_call_mercenary(tc : TChara; str : String) : String;
	var
        i, j, k : Integer;
        tMerc : TMob;
        tm : TMap;
        mercName : PChar;
        customName : String;
        sl:TStringList;
    begin
        sl := TStringList.Create;
        
        if tc.mercenaryID = 0 then begin

            Result := 'GM_CALL_MERCENARY Failed.';

            sl := TStringList.Create;
            sl.DelimitedText := Copy(str, 6, 256);

            if sl.Count <> 3 then Exit;

            customName := sl.Strings[2];

            tm := tc.MData;
            tMerc := TMob.Create;

            mercName := PChar(sl.Strings[1]);
            mercName := PChar(uppercase(String(mercName)));

            tMerc := CreateMercenary(tm, PChar(mercName), tc, tMerc, customName);

            if tMerc.JID = 0 then begin
                Result := 'GM_CALL_MERCENARY Failed.  Invalid Monster name.';
                exit;
            end;

            Result := 'GM_CALL_MERCENARY Success.';

        end else Result := 'GM_CALL_MERCENARY Failed. You already have a mercenary.';

        sl.Free;
   	end;

    function command_email(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        tp1 : TPlayer;
    begin
        Result := 'GM_EMAIL Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 7, 256);
        if sl.Count = 2 then begin;

            if (sl.Strings[0] = ' ') or (sl.Strings[1] = ' ') then begin
                Result := Result + ' You have to enter your old password and your new email address.';
            end else begin
                tp1 := Player.IndexOfObject(tc.ID) as TPlayer;

                if sl.Strings[0] <> tp1.Pass then begin
                    Result := Result + ' Your password didnt match the one you entered.';
                end else begin
                    tp1.Mail := sl.Strings[1];
                    Result := 'GM_EMAIL Success. Email changed. New Email: ' + tp1.Mail + '.';
                end;
            end;
        end else begin
            Result := Result + ' Incomplete information. Syntax: #email [password] [new_email].';
        end;

        sl.Free;
    end;


    function command_aegis_b(str : String) : String;
    var
    	tc1 : TChara;
        k : Integer;
    begin
    	WFIFOW(0, $009a);
	    for k := 0 to CharaName.Count - 1 do begin
        	tc1 := CharaName.Objects[k] as TChara;
        	if tc1.Login = 2 then tc1.Socket.SendBuf(buf, length(str) + 5);
    	end;

        Result := 'GM_AEGIS_B Success.';
    end;

    function command_aegis_nb(str : String) : String;
    var
    	tc1 : TChara;
        k : Integer;
    begin
    	WFIFOW(0, $009a);
	    for k := 0 to CharaName.Count - 1 do begin
        	tc1 := CharaName.Objects[k] as TChara;
        	if tc1.Login = 2 then tc1.Socket.SendBuf(buf, length(str) + 5);
    	end;

        Result := 'GM_AEGIS_NB Success.';
    end;

    function command_aegis_bb(tc : TChara; str : String) : String;
    var
    	tc1 : TChara;
        k : Integer;
    begin
    	WFIFOW(0, $009a);
	    for k := 0 to CharaName.Count - 1 do begin
        	tc1 := CharaName.Objects[k] as TChara;
        	if (tc1.Login = 2) and (tc1.Map = tc.Map) then tc1.Socket.SendBuf(buf, length(str) + 5);
    	end;

        Result := 'GM_AEGIS_BB Success.';
    end;

    function command_aegis_item(tc : TChara; str : String) : String;
    var
        td : TItemDB;
        j, k : Integer;
    begin
        Result := 'GM_AEGIS_ITEM Failure.';
        td := ItemDBName.Objects[ItemDBName.IndexOf(str)] as TItemDB;

        if td.IEquip then begin
            j := 1;
        end else begin
            j := 30;
        end;

        if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) * cardinal(j) then begin
            k := SearchCInventory(tc, td.ID, td.IEquip);
            if k <> 0 then begin
                if tc.Item[k].Amount + j > 30000 then Exit;
                tc.Item[k].ID := td.ID;
                tc.Item[k].Amount := tc.Item[k].Amount + j;
                tc.Item[k].Equip := 0;
                tc.Item[k].Identify := 1;
                tc.Item[k].Refine := 0;
                tc.Item[k].Attr := 0;
                tc.Item[k].Card[0] := 0;
                tc.Item[k].Card[1] := 0;
                tc.Item[k].Card[2] := 0;
                tc.Item[k].Card[3] := 0;
                tc.Item[k].Data := td;
                tc.Weight := tc.Weight + cardinal(td.Weight) * cardinal(j);
                SendCStat1(tc, 0, $0018, tc.Weight);
                SendCGetItem(tc, k, j);
                Result := 'GM_AEGIS_ITEM Success. ' + inttostr(j) + ' ' + str + ' spawned.' ;
            end;
        end else begin
            WFIFOW( 0, $00a0);
            WFIFOB(22, 2);
            tc.Socket.SendBuf(buf, 23);
        end;
    end;

    function command_aegis_monster(tc : TChara; str : String) : String;
    var
        ts, ts1 : TMob;
        tm : TMap;
        tss : TSlaveDB;
        h, i, j, k : Integer;
    begin
        Result := 'GM_AEGIS_MONSTER Failure.';

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        ts := TMob.Create;
        ts.Data := MobDBName.Objects[MobDBName.IndexOf(str)] as TMobDB;
        ts.ID := NowMobID;
        Inc(NowMobID);
        ts.Name := ts.Data.JName;
        ts.JID := ts.Data.ID;
        ts.Map := tc.Map;
        ts.Data.isLink :=false;
        ts.Point.X := tc.Point.X + Random(2) - 1;
        ts.Point.Y := tc.Point.Y + Random(2) - 1;

        ts.Dir := Random(8);
        ts.HP := ts.Data.HP;
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

        if (SummonMonsterName = true) then begin
            ts.Name := ts.Data.JName;
        end else begin
            ts.Name := 'Summon Monster';
        end;

        if (SummonMonsterExp = false) then begin
            ts.Data.MEXP := 0;
            ts.Data.EXP := 0;
            ts.Data.JEXP := 0;
        end;

        if (SummonMonsterAgo = true) then begin
            ts.isActive := true;
        end else begin
            ts.isActive := ts.Data.isActive;
        end;

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
            ts.MVPDist[0].Dmg := ts.Data.HP * 30 div 100;
        end;
        ts.isSummon := True;
        ts.EmperiumID := 0;

        tm.Mob.AddObject(ts.ID, ts);
        tm.Block[ts.Point.X div 8][ts.Point.Y div 8].Mob.AddObject(ts.ID, ts);

        SendMData(tc.Socket, ts);
        SendBCmd(tm,ts.Point,41,tc,False);

        Result := 'GM_AEGIS_MONSTER Success. ' + str + ' summoned.';

        if (SummonMonsterMob = true) then begin
            k := SlaveDBName.IndexOf(str);
            if (k <> -1) then begin
                ts.isLeader := true;

                tss := SlaveDBName.Objects[k] as TSlaveDB;
                if str = tss.Name then begin

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
                                ts1.Point.X := ts.Point.X;
                                ts1.Point.Y := ts.Point.Y;
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
                                        ts1.MVPDist[0].Dmg := ts1.Data.HP * 30 div 100;
                                end;
                                tm.Mob.AddObject(ts1.ID, ts1);
                                tm.Block[ts1.Point.X div 8][ts1.Point.Y div 8].Mob.AddObject(ts1.ID, ts1);
                                ts1.isSummon := true;
                                ts1.isSlave := true;
                                ts1.EmperiumID := 0;

                                SendMData(tc.Socket, ts1);
                                SendBCmd(tm,ts1.Point,41,tc,False);

                                h := h - 1;
                            end;
                        end;
                    until (h <= 0);
                end;
            end;
        end;
    end;

    function command_aegis_resetstate(tc : TChara; str : String) : String;
    var
        i : Integer;
    begin
        Result := 'GM_AEGIS_RESETSTATE Success.';
        for i := 0 to 5 do begin
            tc.ParamBase[i] := 1;
        end;
        tc.StatusPoint := 48;
        for i := 1 to tc.BaseLV - 1 do begin
            tc.StatusPoint := tc.StatusPoint + i div 5 + 3;
        end;
        CalcStat(tc);
        SendCStat(tc);
    end;

    function command_aegis_resetskill(tc : Tchara; str : String) : String;
    var
        i, j : Integer;
    begin
        Result := 'GM_AEGIS_RESETSKILL Success.';
        j := 0;
        for i := 2 to MAX_SKILL_NUMBER do begin
            j := j + tc.Skill[i].Lv;
            if not tc.Skill[i].Card then
                tc.Skill[i].Lv := 0;
        end;
        if (tc.Plag <> 0) then begin
            tc.Skill[tc.Plag].Plag := false;
            tc.Skill[tc.Plag].Lv := 0;
            tc.Plag := 0;
            tc.PLv := 0;
        end;
        if tc.JID = 0 then begin
        end else begin
            tc.skillpoint := j;
        end;

        SendCSkillList(tc);
        CalcStat(tc);
        SendCStat(tc);
    end;

    function command_aegis_hide(tc : TChara) : String;
    var
        tm : TMap;
    begin
    	Result := 'GM_AEGIS_HIDE Success.';
        tm := tc.MData;

        if (tc.Option and 64 = 0) then begin
            tc.Option := tc.Option or 64;
            tc.Hidden := true;
            Result := Result + ' Hide Activated.';
        end else begin
            tc.Option := tc.Option and $FFBF;
            tc.Hidden := false;
            Result := Result + ' Hide Deactivated.';
        end;

        WFIFOW(0, $0119);
        WFIFOL(2, tc.ID);
        WFIFOW(6, 0);
        WFIFOW(8, 0);
        WFIFOW(10, tc.Option);
        WFIFOB(12, 0);
        SendBCmd(tm, tc.Point, 13);
    end;


    function command_athena_heal(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        tm : TMap;
        i, j, ii : Integer;
    begin
        Result := 'GM_ATHENA_HEAL Failure.';

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 6, 256);

        if (sl.Count < 2) or (sl.Count > 3) then Exit;

        i := 0;
        j := 0;

        if (sl.Count = 2) then begin
            val(sl.Strings[0], i, ii);
            if ii <> 0 then Exit;
            val(sl.Strings[1], j, ii);
            if ii <> 0 then Exit;
        end;

        if (i <= 0) then i := tc.MAXHP;
        if (j <= 0) then j := tc.MAXSP;

        if (tc.HP + i > tc.MAXHP) then i := tc.MAXHP - tc.HP;
        if (tc.SP + j > tc.MAXSP) then j := tc.MAXSP - tc.SP;

		Result := 'GM_ATHENA_HEAL Success. ' + inttostr(i) + ' HP & ' + inttostr(j) + ' SP healed.';        

        i := i + tc.HP;
        j := j + tc.SP;

        tc.HP := i;
        tc.SP := j;
        tc.Sit := 3;
        SendCStat1(tc, 0, 5, tc.HP);
        SendCStat1(tc, 0, 7, tc.SP);
        WFIFOW( 0, $0148);
        WFIFOL( 2, tc.ID);
        WFIFOW( 6, 100);
        SendBCmd(tm, tc.Point, 8);

        sl.Free;
    end;

    function command_athena_kami(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        i, w : Integer;
        str2 : String;
    begin
        Result := 'GM_ATHENA_KAMI Failed.';

        sl := tstringlist.Create;
        sl.DelimitedText := str;

        if (sl.Count < 2) or (sl.Count > 3) then Exit;

        str2 := '';
        for i := 1 to (sl.Count - 1) do begin
            str2 := str2 + ' ' + sl.Strings[i];
        end;
        str2 := Trim(str2);

        if (length(sl.Strings[0])) = 5 then begin
            str2 := 'blue' + str2;
        end;

        w := Length(str2) + 4;
        WFIFOW (0, $009a);
        WFIFOW (2, w);
        WFIFOS (4, str2, w - 4);

        for i := 0 to charaname.count - 1 do begin
            tc := charaname.objects[i] as tchara;
            if (tc.login = 2) then begin
                tc.socket.sendbuf(buf, w);
            end;
        end;

        Result := 'GM_ATHENA_KAMI Success.';
        sl.free;
    end;

    function command_athena_alive(tc : TChara) : String;
    var
        tm : TMap;
    begin
        Result := 'GM_ATHENA_ALIVE Success.';

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        tc.HP := tc.MAXHP;
        tc.SP := tc.MAXSP;
        tc.Sit := 3;
        SendCStat1(tc, 0, 5, tc.HP);
        SendCStat1(tc, 0, 7, tc.SP);
        WFIFOW(0, $0148);
        WFIFOL(2, tc.ID);
        WFIFOW(6, 100);
        SendBCmd(tm, tc.Point, 8);
    end;

    function command_athena_save(tc : TChara) : String;
    begin
        Result := 'GM_ATHENA_SAVE Success.';

        tc.SaveMap := tc.Map;
        tc.SavePoint.X := tc.Point.X;
        tc.SavePoint.Y := tc.Point.Y;

        Result := Result + ' Saved at ' + tc.Map + ' (' + IntToStr(tc.Point.X) + ',' + IntToStr(tc.Point.Y) + ')';
    end;

    function command_athena_load(tc : TChara) : String;
    begin
        Result := 'GM_ATHENA_LOAD Success.';

        SendCLeave(tc.Socket.Data, 2);
        tc.Map := tc.SaveMap;
        tc.Point := tc.SavePoint;
        MapMove(tc.Socket, tc.Map, tc.Point);
    end;

    function command_athena_kill(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        i : Integer;
        tm : TMap;
    begin
        Result := 'GM_ATHENA_KILL Failure.';

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        sl := TStringList.Create;
        sl.DelimitedText := str;

        if sl.Count <> 2 then Exit;

        str := '';
        for i := 1 to (sl.Count - 1) do begin
            str := str + ' ' + sl.Strings[i];
        end;
        str := Trim(str);

        if (CharaName.Indexof(str) <> -1) then begin
            tc := charaname.objects[charaname.indexof(str)] as TChara;

            if (tc.Login = 2) then begin
                tc.Sit := 1;
                tc.HP := 0;
                SendCStat1(tc, 0, 5, tc.HP);
                WFIFOW( 0, $0080);
                WFIFOL( 2, tc.ID);
                WFIFOB( 6, 1);
                SendBCmd(tm, tc.Point, 7);

                Result := 'GM_ATHENA_KILL Success. ' + tc.name + ' has killed ' + tc.name + '.';
            end else begin
                Result := Result + tc.Name + ' is not online.';
            end;
        end else begin
            Result := Result + sl.Strings[1] + ' is not a valid character name.';
        end;
        sl.Free;
    end;

    function command_athena_die(tc : TChara) : String;
    var
    	tm : TMap;
    begin
    	Result := 'GM_ATHENA_DIE Success.';

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        CharaDie(tm, tc, 1);
    end;

    function command_athena_jobchange(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        tm : TMap;
        i, j, ii : Integer;
    begin
        Result := 'GM_ATHENA_JOBCHANGE Failure.';

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

        sl := tstringlist.Create;
        sl.DelimitedText := str;

        if sl.count <> 2 then Exit;

        val(sl.Strings[1], i, ii);
        if ii <> 0 then Exit;

        if (ii = 0) and (i >= 0) and (i <= MAX_JOB_NUMBER) and (i <> 13) then begin
            // Colus, 20040203: Added unequip of items when you #job
            for  j := 1 to 100 do begin
                if tc.Item[j].Equip = 32768 then begin
                    tc.Item[j].Equip := 0;
                    WFIFOW(0, $013c);
                    WFIFOW(2, 0);
                    tc.Socket.SendBuf(buf, 4);
                end else if tc.Item[j].Equip <> 0 then begin
                    WFIFOW(0, $00ac);
                    WFIFOW(2, j);
                    WFIFOW(4, tc.Item[j].Equip);
                    tc.Item[j].Equip := 0;
                    WFIFOB(6, 1);
                    tc.Socket.SendBuf(buf, 7);
                    remove_equipcard_skills(tc, j);
                end;
            end;

            // Darkhelmet, 20040212: Added to remove all ticks when changing jobs.
            for j := 1 to MAX_SKILL_NUMBER do begin
                if tc.Skill[j].Data.Icon <> 0 then begin
                    if tc.Skill[j].Tick >= timeGetTime() then begin
                        //debugout.lines.add('[' + TimeToStr(Now) + '] ' + '(Icon Removed');
                        UpdateIcon(tm, tc, tc.Skill[j].Data.Icon, 0);
                    end;
                end;
                tc.Skill[j].Tick := timeGetTime();
                tc.Skill[j].Effect1 := 0;
            end;

            if (j > LOWER_JOB_END) then begin
                j := j - LOWER_JOB_END + UPPER_JOB_BEGIN; // 24 - 23 + 4000 = 4001, remort novice
                if (DisableAdv2ndDye) and (j > 4007) then
                    tc.ClothesColor := 0
                else tc.ClothesColor := 1; // This is the default clothes palette color for upper classes
            end else tc.ClothesColor := 0;

            tc.JID := i; // Set the JID to the corrected value.

            if (tc.Option <> 0) then begin
                tc.Option := 0;
                WFIFOW(0, $0119);
                WFIFOL(2, tc.ID);
                WFIFOW(6, 0);
                WFIFOW(8, 0);
                WFIFOW(10, tc.Option);
                WFIFOB(12, 0);
                SendBCmd(tc.MData, tc.Point, 13);
            end;

            CalcStat(tc);
            SendCStat(tc, true); // Add the true to recalc sprites
            SendCSkillList(tc);

            // Colus, 20040303: Using newer packet to allow upper job changes
            UpdateLook(tm, tc, 0, i);
            UpdateLook(tm, tc, 7, tc.ClothesColor, 0, true);

            Result := 'GM_ATHENA_JOBCHANGE Success.';

        end;

        sl.Free;
    end;

    function command_athena_hide(tc : TChara) : String;
    var
        tm : TMap;
        i : Integer;
    begin
        Result := 'GM_ATHENA_HIDE Success.';

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

        if tc.Option = 64 then i := 0
        else i := 64;
        WFIFOW(0, $0119);
        WFIFOL(2, tc.ID);
        WFIFOW(6, 0);
        WFIFOW(8, 0);
        WFIFOW(10, i);
        WFIFOB(12, 0);
        SendBCmd(tm, tc.Point, 13);
        tc.Stat1 := 0;
        tc.Stat2 := 0;
        tc.Option := i;
    end;

    function command_athena_option(tc : TChara; str : String) : String;
    var
        tm : TMap;
        sl : TStringList;
        i, ii, j, k, w : Integer;
    begin
        Result := 'GM_ATHENA_OPTION Failure.';
        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        sl := tstringlist.Create;
        sl.DelimitedText := str;

        if sl.count <> 4 then Exit;

        val(sl.Strings[1], i, ii);
        if ii <> 0 then Exit;
        val(sl.Strings[2], j, ii);
        if ii <> 0 then Exit;
        val(sl.Strings[3], k, ii);
        if ii <> 0 then Exit;

        WFIFOW(0, $0119);
        WFIFOL(2, tc.ID);
        WFIFOW(6, i);
        WFIFOW(8, j);
        WFIFOW(10, k);
        WFIFOB(12, 0);
        SendBCmd(tm, tc.Point, 13);
        tc.Stat1 := i;
        tc.Stat2 := j;
        tc.Option := k;

        Result := 'GM_ATHENA_OPTION Success. Options set to ' + inttostr(i) + ' ' + inttostr(j) + ' ' + inttostr(k);

        w := Length(str) + 4;
        WFIFOW (0, $009a);
        WFIFOW (2, w);
        WFIFOS (4, str, w - 4);
        tc.socket.sendbuf(buf, w);

        sl.Free;
    end;

    function command_athena_storage(tc : TChara) : String;
    begin
        Result := 'GM_ATHENA_STORAGE Success.';
        SendCStoreList(tc);
    end;

    function command_athena_speed(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        w : Integer;
    begin
        Result := 'GM_ATHENA_SPEED Failure.';
        sl := tstringlist.Create;
        sl.DelimitedText := str;

        if sl.count <> 2 then Exit;

        if (strtoint(sl.Strings[1]) >= 25) and (strtoint(sl.Strings[1]) <= 1000) then begin
            Result := 'GM_ATHENA_SPEED Success. Walking speed is now ' + sl.Strings[1];
            tc.DefaultSpeed := strtoint(sl.strings[1]);
            CalcStat(tc);
            SendCStat1(tc, 0, 0, tc.Speed);
        end else begin
            Result := Result + 'Requested speed out of range. Must be 25-1000';
        end;

        w := Length(str) + 4;
        WFIFOW (0, $009a);
        WFIFOW (2, w);
        WFIFOS (4, str, w - 4);
        tc.socket.sendbuf(buf, w);

        sl.Free;
    end;

    function command_athena_whomap3(tc : TChara; str : String) : String;
    var
        tc1 : TChara;
        tp : TPlayer;
        tm : TMap;
        i, w, matches : Integer;
        s, party, guild : String;
    begin
        Result := 'GM_ATHENA_WHOMAP3 Failure.';

        matches := 0;

        s := Copy(str, 9, 256);
        s := Trim(s);
        if (maplist.IndexOf(s) = -1) then s := tc.map;
        if Map.IndexOf(s) <> -1 then begin
            tm := Map.Objects[Map.IndexOf(s)] as TMap;
            for i := 0 to tm.CList.Count - 1 do begin
                tc1 := tm.CList.objects[i] as TChara;
                if tc1.Login = 2 then begin
                    matches := matches + 1;
                    tp := tc1.PData;
                    if tc1.PartyName = '' then party := chr(39) + 'None' + chr(39) else party := tc1.PartyName;
                    if tc1.GuildName = '' then guild := chr(39) + 'None' + chr(39) else guild := tc1.GuildName;
                    if tp.AccessLevel > 0 then begin
                        str := 'Name: ' + tc1.Name + ' (GM: ' + IntToStr(tp.AccessLevel) + ') | Party: ' + party + ' | Guild: ' + guild;
                    end else begin
                        str := 'Name: ' + tc1.Name + ' | Party: ' + party + ' | Guild: ' + guild;
                    end;
                    w := Length(str) + 4;
                    WFIFOW (0, $009a);
                    WFIFOW (2, w);
                    WFIFOS (4, str, w - 4);
                    tc.socket.sendbuf(buf, w);
                end;
            end;
        end;
        if matches = 0 then str := 'No player found in map ' + chr(39) + s + '.gat' + chr(39) + '.' else if matches > 1 then str := IntToStr(matches) + ' players found in map ' + chr(39) + s + '.gat' + chr(39) + '.' else str := IntToStr(matches) + ' player found in map ' + chr(39) + s + '.gat' + chr(39) + '.';
        w := Length(str) + 4;
        WFIFOW (0, $009a);
        WFIFOW (2, w);
        WFIFOS (4, str, w - 4);
        tc.socket.sendbuf(buf, w);
        if matches > 0 then begin
            Result := 'GM_ATHENA_WHOMAP3 Success.';
        end;
    end;

    function command_athena_whomap2(tc : TChara; str : String) : String;
    var
        tc1 : TChara;
        tp : TPlayer;
        tm : TMap;
        i, w, matches : Integer;
        s, job : String;
    begin
        Result := 'GM_ATHENA_WHOMAP2 Failure.';

        matches := 0;

        s := Copy(str, 9, 256);
        s := Trim(s);
        if (maplist.IndexOf(s) = -1) then s := tc.map;
        if Map.IndexOf(s) <> -1 then begin
            tm := Map.Objects[Map.IndexOf(s)] as TMap;
            for i := 0 to tm.CList.Count - 1 do begin
                tc1 := tm.CList.objects[i] as TChara;
                if tc1.Login = 2 then begin
                    matches := matches + 1;
                    tp := tc1.PData;
                    if tc1.JID = 0 then job :='Novice' else
                    if tc1.JID = 1 then job :='Swordsman' else
                    if tc1.JID = 2 then job :='Mage' else
                    if tc1.JID = 3 then job :='Archer' else
                    if tc1.JID = 4 then job :='Acolyte' else
                    if tc1.JID = 5 then job :='Merchant' else
                    if tc1.JID = 6 then job :='Thief' else
                    if tc1.JID = 7 then job :='Knight' else
                    if tc1.JID = 8 then job :='Priest' else
                    if tc1.JID = 9 then job :='Wizard' else
                    if tc1.JID = 10 then job :='Blacksmith' else
                    if tc1.JID = 11 then job :='Hunter' else
                    if tc1.JID = 12 then job :='Assassin' else
                    if tc1.JID = 13 then job :='Knight 2' else
                    if tc1.JID = 14 then job :='Crusader' else
                    if tc1.JID = 15 then job :='Monk' else
                    if tc1.JID = 16 then job :='Sage' else
                    if tc1.JID = 17 then job :='Rogue' else
                    if tc1.JID = 18 then job :='Alchemist' else
                    if tc1.JID = 19 then job :='Bard' else
                    if tc1.JID = 20 then job :='Dancer' else
                    if tc1.JID = 21 then job :='Crusader 2' else
                    if tc1.JID = 22 then job :='Wedding' else
                    if tc1.JID = 23 then job :='Super Novice' else
                    if tc1.JID = 4001 then job :='High Novice' else
                    if tc1.JID = 4002 then job :='High Swordsman' else
                    if tc1.JID = 4003 then job :='High Mage' else
                    if tc1.JID = 4004 then job :='High Archer' else
                    if tc1.JID = 4005 then job :='High Acolyte' else
                    if tc1.JID = 4006 then job :='High Merchant' else
                    if tc1.JID = 4007 then job :='High Thief' else
                    if tc1.JID = 4008 then job :='Lord Knight' else
                    if tc1.JID = 4009 then job :='High Priest' else
                    if tc1.JID = 4010 then job :='High Wizard' else
                    if tc1.JID = 4011 then job :='Whitesmith' else
                    if tc1.JID = 4012 then job :='Sniper' else
                    if tc1.JID = 4013 then job :='Assassin Cross' else
                    if tc1.JID = 4014 then job :='Lord Knight2' else
                    if tc1.JID = 4015 then job :='Paladin' else
                    if tc1.JID = 4016 then job :='Champion' else
                    if tc1.JID = 4017 then job :='Professor' else
                    if tc1.JID = 4018 then job :='Stalker' else
                    if tc1.JID = 4019 then job :='Creator' else
                    if tc1.JID = 4020 then job :='Clown' else
                    if tc1.JID = 4021 then job :='Gypsy' else
                    if tc1.JID = 4022 then job :='Paladin 2' else
                    job := 'Unknown Class';

                    if tp.AccessLevel > 0 then begin
                            str := 'Name: ' + tc1.Name + ' (GM: ' + IntToStr(tp.AccessLevel) + ') | BLvl: ' + IntToStr(tc.BaseLV) + ' | Job: ' + job + ' (Lvl: ' + IntToStr(tc.JobLV) + ')';
                        end else begin
                            str := 'Name: ' + tc1.Name + ' | BLvl: ' + IntToStr(tc.BaseLV) + ' | Job: ' + job + ' (Lvl: ' + IntToStr(tc.JobLV) + ')';
                        end;
                    w := Length(str) + 4;
                    WFIFOW (0, $009a);
                    WFIFOW (2, w);
                    WFIFOS (4, str, w - 4);
                    tc.socket.sendbuf(buf, w);
                end;
            end;
        end;
        if matches = 0 then str := 'No player found in map ' + chr(39) + s + '.gat' + chr(39) + '.' else if matches > 1 then str := IntToStr(matches) + ' players found in map ' + chr(39) + s + '.gat' + chr(39) + '.' else str := IntToStr(matches) + ' player found in map ' + chr(39) + s + '.gat' + chr(39) + '.';
        w := Length(str) + 4;
        WFIFOW (0, $009a);
        WFIFOW (2, w);
        WFIFOS (4, str, w - 4);
        tc.socket.sendbuf(buf, w);
        if matches > 0 then begin
            Result := 'GM_ATHENA_WHOMAP2 Success.';
        end;
    end;

    function command_athena_whomap(tc : Tchara; str : String) : String;
    var
        tc1 : TChara;
        tp : TPlayer;
        tm : TMap;
        i, w, matches : Integer;
        s : String;
    begin
        Result := 'GM_ATHENA_WHOMAP Failure.';

        matches := 0;

        s := Copy(str, 8, 256);
        s := Trim(s);
        if (maplist.IndexOf(s) = -1) then s := tc.map;
        if Map.IndexOf(s) <> -1 then begin
            tm := Map.Objects[Map.IndexOf(s)] as TMap;
            for i := 0 to tm.CList.Count - 1 do begin
                tc1 := tm.CList.objects[i] as TChara;
                if tc1.Login = 2 then begin
                    matches := matches + 1;
                    tp := tc1.PData;
                    if tp.AccessLevel > 0 then begin
                        str := 'Name: ' + tc1.Name + ' (GM: ' + IntToStr(tp.AccessLevel) + ') | Location: ' + tc1.map + '.gat ' + inttostr(tc1.point.x) + ' ' + inttostr(tc1.point.y);
                    end else begin
                        str := 'Name: ' + tc1.Name + ' | Location: ' + tc1.map + '.gat ' + inttostr(tc1.point.x) + ' ' + inttostr(tc1.point.y);
                    end;
                    w := Length(str) + 4;
                    WFIFOW (0, $009a);
                    WFIFOW (2, w);
                    WFIFOS (4, str, w - 4);
                    tc.socket.sendbuf(buf, w);
                end;
            end;
        end;
        if matches = 0 then str := 'No player found in map ' + chr(39) + s + '.gat' + chr(39) + '.' else if matches > 1 then str := IntToStr(matches) + ' players found in map ' + chr(39) + s + '.gat' + chr(39) + '.' else str := IntToStr(matches) + ' player found in map ' + chr(39) + s + '.gat' + chr(39) + '.';
        w := Length(str) + 4;
        WFIFOW (0, $009a);
        WFIFOW (2, w);
        WFIFOS (4, str, w - 4);
        tc.socket.sendbuf(buf, w);
        if matches > 0 then begin
            Result := 'GM_ATHENA_WHOMAP Success.';
        end;
    end;

    function command_athena_who3(tc : Tchara; str : String) : String;
    var
        tc1 : TChara;
        tp : TPlayer;
        i, w, matches : Integer;
        s, party, guild : String;
    begin
        Result := 'GM_ATHENA_WHO3 Failure.';

        matches := 0;

        s := Copy(str, 6, 256);
        s := Trim(s);
        for i := 0 to CharaName.Count - 1 do begin
            tc1 := CharaName.Objects[i] as TChara;
            if LeftStr(Uppercase(tc1.name),Length(s)) = Uppercase(s) then begin
                if tc1.Login = 2 then begin
                    matches := matches + 1;
                    tp := tc1.PData;
                    if tc1.PartyName = '' then party := chr(39) + 'None' + chr(39) else party := tc1.PartyName;
                    if tc1.GuildName = '' then guild := chr(39) + 'None' + chr(39) else guild := tc1.GuildName;
                    if tp.AccessLevel > 0 then begin
                        str := 'Name: ' + tc1.Name + ' (GM: ' + IntToStr(tp.AccessLevel) + ') | Party: ' + party + ' | Guild: ' + guild;
                    end else begin
                        str := 'Name: ' + tc1.Name + ' | Party: ' + party + ' | Guild: ' + guild;
                    end;
                    w := Length(str) + 4;
                    WFIFOW (0, $009a);
                    WFIFOW (2, w);
                    WFIFOS (4, str, w - 4);
                    tc.socket.sendbuf(buf, w);
                end;
            end;
        end;
        if matches = 0 then str := 'No player found.' else if matches > 1 then str := IntToStr(matches) + ' players found.' else str := IntToStr(matches) + ' player found.';
        w := Length(str) + 4;
        WFIFOW (0, $009a);
        WFIFOW (2, w);
        WFIFOS (4, str, w - 4);
        tc.socket.sendbuf(buf, w);
        if matches > 0 then begin
            Result := 'GM_ATHENA_WHO3 Success.';
        end;
    end;

    function command_athena_who2(tc : TChara; str : String) : String;
    var
        tc1 : TChara;
        tp : TPlayer;
        i, w, matches : Integer;
        s, job : String;
    begin
        Result := 'GM_ATHENA_WHO2 Failure.';

        matches := 0;

        s := Copy(str, 6, 256);
        s := Trim(s);
        for i := 0 to CharaName.Count - 1 do begin
            tc1 := CharaName.Objects[i] as TChara;
            if LeftStr(Uppercase(tc1.name),Length(s)) = Uppercase(s) then begin
                if tc1.Login = 2 then begin
                    matches := matches + 1;
                    tp := tc1.PData;
                    if tc1.JID = 0 then job :='Novice' else
                    if tc1.JID = 1 then job :='Swordsman' else
                    if tc1.JID = 2 then job :='Mage' else
                    if tc1.JID = 3 then job :='Archer' else
                    if tc1.JID = 4 then job :='Acolyte' else
                    if tc1.JID = 5 then job :='Merchant' else
                    if tc1.JID = 6 then job :='Thief' else
                    if tc1.JID = 7 then job :='Knight' else
                    if tc1.JID = 8 then job :='Priest' else
                    if tc1.JID = 9 then job :='Wizard' else
                    if tc1.JID = 10 then job :='Blacksmith' else
                    if tc1.JID = 11 then job :='Hunter' else
                    if tc1.JID = 12 then job :='Assassin' else
                    if tc1.JID = 13 then job :='Knight 2' else
                    if tc1.JID = 14 then job :='Crusader' else
                    if tc1.JID = 15 then job :='Monk' else
                    if tc1.JID = 16 then job :='Sage' else
                    if tc1.JID = 17 then job :='Rogue' else
                    if tc1.JID = 18 then job :='Alchemist' else
                    if tc1.JID = 19 then job :='Bard' else
                    if tc1.JID = 20 then job :='Dancer' else
                    if tc1.JID = 21 then job :='Crusader 2' else
                    if tc1.JID = 22 then job :='Wedding' else
                    if tc1.JID = 23 then job :='Super Novice' else
                    if tc1.JID = 4001 then job :='High Novice' else
                    if tc1.JID = 4002 then job :='High Swordsman' else
                    if tc1.JID = 4003 then job :='High Mage' else
                    if tc1.JID = 4004 then job :='High Archer' else
                    if tc1.JID = 4005 then job :='High Acolyte' else
                    if tc1.JID = 4006 then job :='High Merchant' else
                    if tc1.JID = 4007 then job :='High Thief' else
                    if tc1.JID = 4008 then job :='Lord Knight' else
                    if tc1.JID = 4009 then job :='High Priest' else
                    if tc1.JID = 4010 then job :='High Wizard' else
                    if tc1.JID = 4011 then job :='Whitesmith' else
                    if tc1.JID = 4012 then job :='Sniper' else
                    if tc1.JID = 4013 then job :='Assassin Cross' else
                    if tc1.JID = 4014 then job :='Lord Knight2' else
                    if tc1.JID = 4015 then job :='Paladin' else
                    if tc1.JID = 4016 then job :='Champion' else
                    if tc1.JID = 4017 then job :='Professor' else
                    if tc1.JID = 4018 then job :='Stalker' else
                    if tc1.JID = 4019 then job :='Creator' else
                    if tc1.JID = 4020 then job :='Clown' else
                    if tc1.JID = 4021 then job :='Gypsy' else
                    if tc1.JID = 4022 then job :='Paladin 2' else
                    job := 'Unknown Class';

                    if tp.AccessLevel > 0 then begin
                            str := 'Name: ' + tc1.Name + ' (GM: ' + IntToStr(tp.AccessLevel) + ') | BLvl: ' + IntToStr(tc1.BaseLV) + ' | Job: ' + job + ' (Lvl: ' + IntToStr(tc1.JobLV) + ')';
                        end else begin
                            str := 'Name: ' + tc1.Name + ' | BLvl: ' + IntToStr(tc1.BaseLV) + ' | Job: ' + job + ' (Lvl: ' + IntToStr(tc1.JobLV) + ')';
                        end;
                    w := Length(str) + 4;
                    WFIFOW (0, $009a);
                    WFIFOW (2, w);
                    WFIFOS (4, str, w - 4);
                    tc.socket.sendbuf(buf, w);
                end;
            end;
        end;
        if matches = 0 then str := 'No player found.' else if matches > 1 then str := IntToStr(matches) + ' players found.' else str := IntToStr(matches) + ' player found.';
        w := Length(str) + 4;
        WFIFOW (0, $009a);
        WFIFOW (2, w);
        WFIFOS (4, str, w - 4);
        tc.socket.sendbuf(buf, w);
        if matches > 0 then begin
            Result := 'GM_ATHENA_WHO2 Success.';
        end;
    end;

    function command_athena_who(tc : Tchara; str : String) : String;
    var
        tc1 : TChara;
        tp : TPlayer;
        i, w, matches : Integer;
        s : String;
    begin
        Result := 'GM_ATHENA_WHO Failure.';

        matches := 0;

        s := Copy(str, 5, 256);
        s := Trim(s);
        for i := 0 to CharaName.Count - 1 do begin
            tc1 := CharaName.Objects[i] as TChara;
            if LeftStr(Uppercase(tc1.name),Length(s)) = Uppercase(s) then begin
                if tc1.Login = 2 then begin
                    matches := matches + 1;
                    tp := tc1.PData;
                    if tp.AccessLevel > 0 then begin
                        str := 'Name: ' + tc1.Name + ' (GM: ' + IntToStr(tp.AccessLevel) + ') | Location: ' + tc1.map + '.gat ' + inttostr(tc1.point.x) + ' ' + inttostr(tc1.point.y);
                    end else begin
                        str := 'Name: ' + tc1.Name + ' | Location: ' + tc1.map + '.gat ' + inttostr(tc1.point.x) + ' ' + inttostr(tc1.point.y);
                    end;
                    w := Length(str) + 4;
                    WFIFOW (0, $009a);
                    WFIFOW (2, w);
                    WFIFOS (4, str, w - 4);
                    tc.socket.sendbuf(buf, w);
                end;
            end;
        end;
        if matches = 0 then str := 'No player found.' else if matches > 1 then str := IntToStr(matches) + ' players found.' else str := IntToStr(matches) + ' player found.';
        w := Length(str) + 4;
        WFIFOW (0, $009a);
        WFIFOW (2, w);
        WFIFOS (4, str, w - 4);
        tc.socket.sendbuf(buf, w);
        if matches > 0 then begin
            Result := 'GM_ATHENA_WHO Success.';
        end;
    end;

    function command_athena_jump(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        ta : TMapList;
        i, j, ii : Integer;
    begin
        Result := 'GM_ATHENA_JUMP Failure.';
        sl := tstringlist.Create;
        sl.DelimitedText := str;

        if sl.count <> 3 then Exit;

        val(sl.Strings[1], i, ii);
        if ii <> 0 then Exit;
        val(sl.Strings[2], j, ii);
        if ii <> 0 then Exit;

        if (maplist.IndexOf(tc.Map) <> -1) then begin
            ta := maplist.objects[maplist.indexof(tc.map)] as tmaplist;
            if (i < 0) or (i >= ta.size.x) or (j < 0) or (j >= ta.size.y) then Exit;

            sendcleave(tc, 2);
            tc.tmpMap := tc.map;
            tc.Point := point(i, j);
            mapmove(tc.Socket, tc.tmpMap, tc.Point);

            Result := 'GM_ATHENA_JUMP Success. Jumped to ' + IntToStr(i) + ',' + IntToStr(j);
        end;

    sl.Free;
    end;

    function command_athena_jumpto(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        tc1 : TChara;
        str2 : String;
        i : Integer;
    begin
        Result := 'GM_ATHENA_JUMPTO Failure.';
        sl := tstringlist.Create;
        sl.DelimitedText := str;

        if sl.count <> 2 then Exit;

        str2 := '';
        for i := 1 to (sl.Count - 1) do begin
            str2 := str2 + ' ' + sl.Strings[i];
        end;
        str2 := Trim(str2);

        if (CharaName.Indexof(str2) <> -1) then begin
            tc1 := charaname.objects[charaname.indexof(str2)] as tchara;
            tc.tmpmap := tc1.map;
            tc.point := tc1.point;
            mapmove (tc1.socket, tc1.map, tc1.point);

            Result := 'GM_ATHENA_JUMPTO Success. Jumped to ' + tc1.Name;
        end;

        sl.Free;
    end;

    function command_athena_where(tc : TChara; str : String) : String;
    var
        s : String;
        tc1 : TChara;
        i, w : Integer;
    begin
        Result := 'GM_ATHENA_WHERE Failure.';

        s := Copy(str, 7, 256);
        s := Trim(s);

        if s = '' then s := tc.Name;
        if (CharaName.IndexOf(s) <> -1) then begin
            tc1 := charaname.objects[charaname.indexof(s)] as tchara;
            if tc1.Login = 2 then begin
                str := tc1.Name + ': ' + tc1.map + '.gat (' + inttostr(tc1.point.x) + ' ' + inttostr(tc1.point.y) + ')';
                w := Length(str) + 4;
                WFIFOW (0, $009a);
                WFIFOW (2, w);
                WFIFOS (4, str, w - 4);
                tc.socket.sendbuf(buf, w);

                Result := 'GM_ATHENA_WHERE Success.';
            end else begin
                str := 'Character not found.';
                w := Length(str) + 4;
                WFIFOW (0, $009a);
                WFIFOW (2, w);
                WFIFOS (4, str, w - 4);
                tc.socket.sendbuf(buf, w);
                str := '@where failed.';
                w := Length(str) + 4;
                WFIFOW (0, $009a);
                WFIFOW (2, w);
                WFIFOS (4, str, w - 4);
                tc.socket.sendbuf(buf, w);
            end;
        end else begin
            str := 'Character not found.';
            w := Length(str) + 4;
            WFIFOW (0, $009a);
            WFIFOW (2, w);
            WFIFOS (4, str, w - 4);
            tc.socket.sendbuf(buf, w);
            str := '@where failed.';
            w := Length(str) + 4;
            WFIFOW (0, $009a);
            WFIFOW (2, w);
            WFIFOS (4, str, w - 4);
            tc.socket.sendbuf(buf, w);
        end;
    end;

    function command_athena_rura(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        i, j, ii : Integer;
        ta : TMapList;
    begin
        Result := 'GM_ATHENA_RURA Failure.';

        sl := tstringlist.Create;
        sl.DelimitedText := str;

        if sl.count <> 4 then Exit;

        val(sl.Strings[2], i, ii);
        if ii <> 0 then Exit;
        val(sl.Strings[3], j, ii);
        if ii <> 0 then Exit;

        if (maplist.IndexOf(sl.Strings[1]) <> -1) then begin
            ta := maplist.objects[maplist.indexof(sl.strings[1])] as tmaplist;
            if (i < 0) or (i >= ta.size.x) or (j < 0) or (j >= ta.size.y) then Exit;

            sendcleave(tc, 2);
            tc.tmpMap := sl.Strings[1];
            tc.Point := point(i, j);
            mapmove(tc.Socket, tc.tmpMap, tc.Point);
            Result := 'GM_ATHENA_WARP Success. Warp to ' + tc.tmpMap + ' (' + IntToStr(i) + ',' + IntToStr(j) + ').';
        end;
        sl.Free;
    end;

    function command_athena_warp(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        i, j, ii : Integer;
        ta : TMapList;
    begin
        Result := 'GM_ATHENA_WARP Failure.';

        sl := tstringlist.Create;
        sl.DelimitedText := str;

        if sl.count <> 4 then Exit;

        val(sl.Strings[2], i, ii);
        if ii <> 0 then Exit;
        val(sl.Strings[3], j, ii);
        if ii <> 0 then Exit;

        if (maplist.IndexOf(sl.Strings[1]) <> -1) then begin
            ta := maplist.objects[maplist.indexof(sl.strings[1])] as tmaplist;
            if (i < 0) or (i >= ta.size.x) or (j < 0) or (j >= ta.size.y) then Exit;

            sendcleave(tc, 2);
            tc.tmpMap := sl.Strings[1];
            tc.Point := point(i, j);
            mapmove(tc.Socket, tc.tmpMap, tc.Point);
            Result := 'GM_ATHENA_WARP Success. Warp to ' + tc.tmpMap + ' (' + IntToStr(i) + ',' + IntToStr(j) + ').';
        end;
        sl.Free;
    end;

    function command_athena_warpp(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        i, j, k, w, ii : Integer;
        s : string;
        ta : TMapList;
        tc1 : TChara;
    begin
        Result := 'GM_ATHENA_WARP+ Failure.';
        sl := tstringlist.Create;
        sl.DelimitedText := str;

        if sl.count <> 5 then Exit;

        val(sl.Strings[2], i, ii);
        if ii <> 0 then Exit;
        val(sl.Strings[3], j, ii);
        if ii <> 0 then Exit;

        if maplist.IndexOf(sl.Strings[1]) <> -1 then begin
            ta := maplist.objects[maplist.indexof(sl.strings[1])] as tmaplist;
            if (i < 0) or (i >= ta.size.x) or (j < 0) or (j >= ta.size.y) then Exit;

            for k := 4 to sl.Count - 1 do begin
            s := s + ' ' + sl.Strings[k];
            s := Trim(s);
            end;

            if (charaname.IndexOf(s) <> -1) then begin
                tc1 := charaname.objects[charaname.indexof(s)] as tchara;
                str := tc.Name + ' warped ' + tc1.Name + ' to ' + sl.strings[1] + ' ' + inttostr(i) + ' ' + inttostr(j);

                w := Length(str) + 4;
                WFIFOW (0, $009a);
                WFIFOW (2, w);
                WFIFOS (4, str, w - 4);
                tc.socket.sendbuf(buf, w);

                if tc1.Login = 2 then begin
                    sendcleave(tc1, 2);
                    tc1.tmpMap := sl.Strings[1];
                    tc1.Point := point(i, j);
                    mapmove(tc1.Socket, tc1.tmpMap, tc1.Point);
                    Result := 'GM_ATHENA_WARP+ Success.';
                end

                else begin
                    tc1.Map := sl.Strings[1];
                    tc1.Point := point(i, j);
                end;
            end;
        end;
        sl.Free;
    end;

    function command_athena_send(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        i, j, k, w, ii : Integer;
        s : string;
        ta : TMapList;
        tc1 : TChara;
    begin
        Result := 'GM_ATHENA_SEND Failure.';
        sl := tstringlist.Create;
        sl.DelimitedText := str;

        if sl.count <> 5 then Exit;

        val(sl.Strings[2], i, ii);
        if ii <> 0 then Exit;
        val(sl.Strings[3], j, ii);
        if ii <> 0 then Exit;

        if maplist.IndexOf(sl.Strings[1]) <> -1 then begin
            ta := maplist.objects[maplist.indexof(sl.strings[1])] as tmaplist;
            if (i < 0) or (i >= ta.size.x) or (j < 0) or (j >= ta.size.y) then Exit;

            for k := 4 to sl.Count - 1 do begin
            s := s + ' ' + sl.Strings[k];
            s := Trim(s);
            end;

            if (charaname.IndexOf(s) <> -1) then begin
                tc1 := charaname.objects[charaname.indexof(s)] as tchara;
                str := tc.Name + ' warped ' + tc1.Name + ' to ' + sl.strings[1] + ' ' + inttostr(i) + ' ' + inttostr(j);

                w := Length(str) + 4;
                WFIFOW (0, $009a);
                WFIFOW (2, w);
                WFIFOS (4, str, w - 4);
                tc.socket.sendbuf(buf, w);

                if tc1.Login = 2 then begin
                    sendcleave(tc1, 2);
                    tc1.tmpMap := sl.Strings[1];
                    tc1.Point := point(i, j);
                    mapmove(tc1.Socket, tc1.tmpMap, tc1.Point);
                    Result := 'GM_ATHENA_SEND Success.';
                end

                else begin
                    tc1.Map := sl.Strings[1];
                    tc1.Point := point(i, j);
                end;
            end;
        end;
        sl.Free;
    end;

    function command_athena_rurap(tc : Tchara; str : String) : String;
    var
        sl : TStringList;
        i, j, k, w, ii : Integer;
        s : string;
        ta : TMapList;
        tc1 : TChara;
    begin
        Result := 'GM_ATHENA_RURA+ Failure.';
        sl := tstringlist.Create;
        sl.DelimitedText := str;

        if sl.count <> 5 then Exit;

        val(sl.Strings[2], i, ii);
        if ii <> 0 then Exit;
        val(sl.Strings[3], j, ii);
        if ii <> 0 then Exit;

        if maplist.IndexOf(sl.Strings[1]) <> -1 then begin
            ta := maplist.objects[maplist.indexof(sl.strings[1])] as tmaplist;
            if (i < 0) or (i >= ta.size.x) or (j < 0) or (j >= ta.size.y) then Exit;

            for k := 4 to sl.Count - 1 do begin
            s := s + ' ' + sl.Strings[k];
            s := Trim(s);
            end;

            if (charaname.IndexOf(s) <> -1) then begin
                tc1 := charaname.objects[charaname.indexof(s)] as tchara;
                str := tc.Name + ' warped ' + tc1.Name + ' to ' + sl.strings[1] + ' ' + inttostr(i) + ' ' + inttostr(j);

                w := Length(str) + 4;
                WFIFOW (0, $009a);
                WFIFOW (2, w);
                WFIFOS (4, str, w - 4);
                tc.socket.sendbuf(buf, w);

                if tc1.Login = 2 then begin
                    sendcleave(tc1, 2);
                    tc1.tmpMap := sl.Strings[1];
                    tc1.Point := point(i, j);
                    mapmove(tc1.Socket, tc1.tmpMap, tc1.Point);
                    Result := 'GM_ATHENA_RURA+ Success.';
                end

                else begin
                    tc1.Map := sl.Strings[1];
                    tc1.Point := point(i, j);
                end;
            end;
        end;
        sl.Free;
    end;

    function command_athena_charwarp(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        i, j, k, w, ii : Integer;
        s : string;
        ta : TMapList;
        tc1 : TChara;
    begin
        Result := 'GM_ATHENA_CHARWARP Failure.';
        sl := tstringlist.Create;
        sl.DelimitedText := str;

        if sl.count <> 5 then Exit;

        val(sl.Strings[2], i, ii);
        if ii <> 0 then Exit;
        val(sl.Strings[3], j, ii);
        if ii <> 0 then Exit;

        if maplist.IndexOf(sl.Strings[1]) <> -1 then begin
            ta := maplist.objects[maplist.indexof(sl.strings[1])] as tmaplist;
            if (i < 0) or (i >= ta.size.x) or (j < 0) or (j >= ta.size.y) then Exit;

            for k := 4 to sl.Count - 1 do begin
            s := s + ' ' + sl.Strings[k];
            s := Trim(s);
            end;

            if (charaname.IndexOf(s) <> -1) then begin
                tc1 := charaname.objects[charaname.indexof(s)] as tchara;
                str := tc.Name + ' warped ' + tc1.Name + ' to ' + sl.strings[1] + ' ' + inttostr(i) + ' ' + inttostr(j);

                w := Length(str) + 4;
                WFIFOW (0, $009a);
                WFIFOW (2, w);
                WFIFOS (4, str, w - 4);
                tc.socket.sendbuf(buf, w);

                if tc1.Login = 2 then begin
                    sendcleave(tc1, 2);
                    tc1.tmpMap := sl.Strings[1];
                    tc1.Point := point(i, j);
                    mapmove(tc1.Socket, tc1.tmpMap, tc1.Point);
                    Result := 'GM_ATHENA_CHARWARP Success.';
                end

                else begin
                    tc1.Map := sl.Strings[1];
                    tc1.Point := point(i, j);
                end;
            end;
        end;
        sl.Free;
    end;

    function command_athena_h(tc : TChara; str : String) : String;
    var
    	helpfile : TStringList;
        sl : TStringList;
        length : Integer;
        i : Integer;
    begin
        Result := 'GM_ATHENA_H Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 6, 256);

        helpfile := TStringList.Create;
        try
            helpfile.LoadFromFile(AppPath + 'documents\help.txt');
        except
            on EFOpenError do begin
                message_green(tc, 'File not accessible. Contact your server admin.');
                Result := Result + ' File not accessible.';
                helpfile.Free;
                Exit;
            end;
        end;

        if helpfile.Count > 150 then length := 150 else length := helpfile.Count;
        for i := 0 to length do begin
            message_green(tc, helpfile[i]);
        end;

        sl.Free;
        helpfile.Free;
        Result := 'GM_ATHENA_H Success.';
    end;

    function command_athena_help(tc : TChara; str : String) : String;
    var
    	helpfile : TStringList;
        sl : TStringList;
        length : Integer;
        i : Integer;
    begin
        Result := 'GM_ATHENA_HELP Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 6, 256);

        helpfile := TStringList.Create;
        try
            helpfile.LoadFromFile(AppPath + 'documents\help.txt');
        except
            on EFOpenError do begin
                message_green(tc, 'File not accessible. Contact your server admin.');
                Result := Result + ' File not accessible.';
                helpfile.Free;
                Exit;
            end;
        end;

        if helpfile.Count > 150 then length := 150 else length := helpfile.Count;
        for i := 0 to length do begin
            message_green(tc, helpfile[i]);
        end;

        sl.Free;
        helpfile.Free;
        Result := 'GM_ATHENA_HELP Success.';
    end;

    function command_athena_zeny(tc : TChara; str : String) : String;
    var
        i, k : Integer;
    begin
        Result := 'GM_ATHENA_ZENY Failure.';

        Val(Copy(str, 6, 256), i, k);
        if (k = 0) and (i >= -2147483647) and (i <= 2147483647) then begin
            if (tc.Zeny + i <= 2147483647) and (tc.Zeny + i >= 0) then begin
                tc.Zeny := tc.Zeny + i;
                SendCStat1(tc, 1, $0014, tc.Zeny);

                Result := 'GM_ATHENA_ZENY Success. ' + IntToStr(abs(i)) + ' Zeny';
                if (i = 0) then begin
                    tc.Zeny := i;
                    Result := Result + ' set.';
                end else
                if (i > 0) then begin
                    Result := Result + ' added.';
                end else if (i < 0) then begin
                    Result := Result + ' subtracted.';
                end;
            end else begin
                Result := Result + ' Zeny on hand amount out of range [0-2147483647].';
            end;
        end else begin
            Result := Result + ' Zeny amount out of range [-2147483647-2147483647].';
        end;
    end;

    function command_athena_baselvlup(tc : TChara; str : String) : String;
    var
        i, k, w3 : Integer;
        oldlevel : Integer;
    begin
        Result := 'GM_ATHENA_BASELVLUP Failure.';

        oldlevel := tc.BaseLV;
        Val(Copy(str, 11, 256), i, k);

        if (k = 0) and (i >= -254) and (i <= 254) then begin
            if i < 0 then begin
                if (tc.BaseLV + i >= 1) then tc.BaseLV := tc.BaseLV + i
                else if (tc.BaseLV + i < 1) and (tc.BaseLV > 1) then begin
                    tc.BaseLV := 1;
                end else begin
                    Result := Result + ' Minimum level is 1.';
                    Exit;
                end;

                for i := 0 to 5 do begin
                    tc.ParamBase[i] := 1;
                end;

                tc.StatusPoint := 48;

                for i := 1 to tc.BaseLV - 1 do begin
                    tc.StatusPoint := tc.StatusPoint + i div 5 + 3;
                end;
            end

            else begin
                w3 := tc.BaseLV;
                if (tc.BaseLV + i <= 255) then tc.BaseLV := tc.BaseLV + i
                else if (tc.BaseLV + i > 255) and (tc.BaseLV < 255) then begin
                    tc.BaseLV := 255;
                end else begin
                    Result := Result + ' Maximum level is 255.';
                    Exit;
                end;

                for i := w3 to tc.BaseLV - 1 do begin
                    tc.StatusPoint := tc.StatusPoint + i div 5 + 3;
                end;
            end;

            tc.BaseEXP := tc.BaseNextEXP - 1;
            if tc.JID > 23 then
                tc.BaseNextEXP := ExpTable[5][tc.BaseLV]
            else tc.BaseNextEXP := ExpTable[0][tc.BaseLV];


            CalcStat(tc);
            SendCStat(tc);
            SendCStat1(tc, 0, $000b, tc.BaseLV);
            SendCStat1(tc, 0, $0009, tc.StatusPoint);
            SendCStat1(tc, 1, $0001, tc.BaseEXP);

            Result := 'GM_ATHENA_BASELVLUP Success. level changed from ' + IntToStr(oldlevel) + ' to ' + IntToStr(tc.BaseLV) + '.';
        end else begin
            Result := Result + ' Incomplete information or level out of range.';
        end;
    end;

    function command_athena_lvup(tc : TChara; str : String) : String;
    var
        i, k, w3 : Integer;
        oldlevel : Integer;
    begin
        Result := 'GM_ATHENA_LVUP Failure.';

        oldlevel := tc.BaseLV;
        Val(Copy(str, 6, 256), i, k);

        if (k = 0) and (i >= -198) and (i <= 198) then begin
            if i < 0 then begin
                if (tc.BaseLV + i >= 1) then tc.BaseLV := tc.BaseLV + i
                else if (tc.BaseLV + i < 1) and (tc.BaseLV > 1) then begin
                    tc.BaseLV := 1;
                end else begin
                    Result := Result + ' Minimum level is 1.';
                    Exit;
                end;

                for i := 0 to 5 do begin
                    tc.ParamBase[i] := 1;
                end;

                tc.StatusPoint := 48;

                for i := 1 to tc.BaseLV - 1 do begin
                    tc.StatusPoint := tc.StatusPoint + i div 5 + 3;
                end;
            end

            else begin
                w3 := tc.BaseLV;
                if (tc.BaseLV + i <= 199) then tc.BaseLV := tc.BaseLV + i
                else if (tc.BaseLV + i > 199) and (tc.BaseLV < 199) then begin
                    tc.BaseLV := 199;
                end else begin
                    Result := Result + ' Maximum level is 199.';
                    Exit;
                end;

                for i := w3 to tc.BaseLV - 1 do begin
                    tc.StatusPoint := tc.StatusPoint + i div 5 + 3;
                end;
            end;

            tc.BaseEXP := tc.BaseNextEXP - 1;
            if tc.JID > 23 then tc.BaseNextEXP := ExpTable[5][tc.BaseLV]
            else tc.BaseNextEXP := ExpTable[0][tc.BaseLV];

            CalcStat(tc);
            SendCStat(tc);
            SendCStat1(tc, 0, $000b, tc.BaseLV);
            SendCStat1(tc, 0, $0009, tc.StatusPoint);
            SendCStat1(tc, 1, $0001, tc.BaseEXP);

            Result := 'GM_ATHENA_LVUP Success. level changed from ' + IntToStr(oldlevel) + ' to ' + IntToStr(tc.BaseLV) + '.';
        end else begin
            Result := Result + ' Incomplete information or level out of range.';
        end;
    end;

    function command_athena_joblvlup(tc : TChara; str : String) : String;
    var
        i, k, w3 : Integer;
        oldlevel : Integer;
        JIDFix : word;
    begin
        Result := 'GM_ATHENA_JOBLVLUP Failure.';

        oldlevel := tc.JobLV;
        Val(Copy(str, 10, 256), i, k);

        if (k = 0) and (i >= -70) and (i <= 70) then begin
            if i < 0 then begin
                if (tc.JobLV + i >= 1) then tc.JobLV := tc.JobLV + i
                else if (tc.JobLV + i < 1) and (tc.JobLV > 1) then begin
                    tc.JobLV := 1;
                end else begin
                    Result := Result + ' Minimum level is 1.';
                    Exit;
                end;
            end else begin
                if (tc.JID = 0) and (tc.JobLV + i > 10) and (tc.JobLV < 10) then tc.JobLV := 10
                else if (tc.JID = 0) and (tc.JobLV = 10) then begin
                    Result := Result + ' Maximum level is 10.';
                    Exit;
                end
                else if (tc.JID > 0) and (tc.JID < 23) and (tc.JobLV + i > 50) and (tc.JobLV < 50) then tc.JobLV := 50
                else if (tc.JID > 0) and (tc.JID < 23) and (tc.JobLV = 50) then begin
                    Result := Result + ' Maximum level is 50.';
                    Exit;
                end
                else if (tc.JobLV + i <= 70) then tc.JobLV := tc.JobLV + i
                else if (tc.JobLV + i > 70) and (tc.JobLV < 70) then begin
                    tc.JobLV := 70;
                end else begin
                    Result := Result + ' Maximum level is 70.';
                    Exit;
                end;
            end;

            for i := 1 to MAX_SKILL_NUMBER do begin
                if not tc.Skill[i].Card then tc.Skill[i].Lv := 0;
            end;

            if tc.JID = 0 then tc.SkillPoint := tc.JobLV - 1
            else if tc.JID < 7 then tc.SkillPoint := tc.JobLV - 1 + 9
            else tc.SkillPoint := tc.JobLV - 1 + 49 + 9;

            SendCSkillList(tc);

            tc.JobEXP := tc.JobNextEXP - 1;

            JIDFix := JIDFixer(tc.JID);
            case JIDFix of
                0: w3 := 1;
                1..6: w3 := 2;
                7..22: w3 := 3;
                23: w3 := 4;
                24: w3 := 6;
                25..30: w3 := 7;
                31..45: w3 := 8;
                else w3 := 8;
            end;

            tc.JobNextEXP := ExpTable[w3][tc.JobLV];

            CalcStat(tc);
            SendCStat(tc);
            SendCStat1(tc, 0, $0037, tc.JobLV);
            SendCStat1(tc, 0, $000c, tc.SkillPoint);
            SendCStat1(tc, 1, $0002, tc.JobEXP);

            Result := 'GM_ATHENA_JOBLVLUP Success. level changed from ' + IntToStr(oldlevel) + ' to ' + IntToStr(tc.JobLV) + '.';
        end else begin
            Result := Result + ' Incomplete information or level out of range.';
        end;
    end;

    function command_athena_joblvup(tc : TChara; str : String) : String;
    var
        i, k, w3 : Integer;
        oldlevel : Integer;
        JIDFix : word;
    begin
        Result := 'GM_ATHENA_JOBLVUP Failure.';

        oldlevel := tc.JobLV;
        Val(Copy(str, 9, 256), i, k);

        if (k = 0) and (i >= -70) and (i <= 70) then begin
            if i < 0 then begin
                if (tc.JobLV + i >= 1) then tc.JobLV := tc.JobLV + i
                else if (tc.JobLV + i < 1) and (tc.JobLV > 1) then begin
                    tc.JobLV := 1;
                end else begin
                    Result := Result + ' Minimum level is 1.';
                    Exit;
                end;
            end else begin
                if (tc.JID = 0) and (tc.JobLV + i > 10) and (tc.JobLV < 10) then tc.JobLV := 10
                else if (tc.JID = 0) and (tc.JobLV = 10) then begin
                    Result := Result + ' Maximum level is 10.';
                    Exit;
                end
                else if (tc.JID > 0) and (tc.JID < 23) and (tc.JobLV + i > 50) and (tc.JobLV < 50) then tc.JobLV := 50
                else if (tc.JID > 0) and (tc.JID < 23) and (tc.JobLV = 50) then begin
                    Result := Result + ' Maximum level is 50.';
                    Exit;
                end
                else if (tc.JobLV + i <= 70) then tc.JobLV := tc.JobLV + i
                else if (tc.JobLV + i > 70) and (tc.JobLV < 70) then begin
                    tc.JobLV := 70;
                end else begin
                    Result := Result + ' Maximum level is 70.';
                    Exit;
                end;
            end;

            for i := 1 to MAX_SKILL_NUMBER do begin
                if not tc.Skill[i].Card then tc.Skill[i].Lv := 0;
            end;

            if tc.JID = 0 then tc.SkillPoint := tc.JobLV - 1
            else if tc.JID < 7 then tc.SkillPoint := tc.JobLV - 1 + 9
            else tc.SkillPoint := tc.JobLV - 1 + 49 + 9;

            SendCSkillList(tc);

            tc.JobEXP := tc.JobNextEXP - 1;

            JIDFix := JIDFixer(tc.JID);
            case JIDFix of
                0: w3 := 1;
                1..6: w3 := 2;
                7..22: w3 := 3;
                23: w3 := 4;
                24: w3 := 6;
                25..30: w3 := 7;
                31..45: w3 := 8;
                else w3 := 8;
            end;

            tc.JobNextEXP := ExpTable[w3][tc.JobLV];

            CalcStat(tc);
            SendCStat(tc);
            SendCStat1(tc, 0, $0037, tc.JobLV);
            SendCStat1(tc, 0, $000c, tc.SkillPoint);
            SendCStat1(tc, 1, $0002, tc.JobEXP);

            Result := 'GM_ATHENA_JOBLVUP Success. level changed from ' + IntToStr(oldlevel) + ' to ' + IntToStr(tc.JobLV) + '.';
        end else begin
            Result := Result + ' Incomplete information or level out of range.';
        end;
    end;

    function command_athena_skpoint(tc : TChara; str : String) : String;
    var
        i, k : Integer;
        oldpoints : Integer;
    begin
        Result := 'GM_ATHENA_SKPOINT Failure.';

        oldpoints := tc.SkillPoint;

        Val(Copy(str, 9, 256), i, k);
        if (k = 0) and (i >= -1001) and (i <= 1001) then begin
            if i < 0 then begin
                if (tc.SkillPoint + i >= 0) then tc.SkillPoint := tc.SkillPoint + i
                else if (tc.SkillPoint + i < 0) and (tc.SkillPoint > 0) then begin
                    tc.SkillPoint := 0;
                end else begin
                    Result := Result + ' Minimum number of points is 0.';
                    Exit;
                end;
            end

            else begin
                if (tc.SkillPoint + i <= 1001) then tc.SkillPoint := tc.SkillPoint + i
                else if (tc.SkillPoint + i > 1001) and (tc.SkillPoint < 1001) then begin
                    tc.SkillPoint := 1001;
                end else begin
                    Result := Result + ' Maximum number of points is 1001.';
                    Exit;
                end;
            end;

            SendCStat1(tc, 0, $000c, tc.SkillPoint);

            if (i > 0) then Result := 'GM_ATHENA_SKPOINT Success. ' + IntToStr(tc.SkillPoint - oldpoints) + ' points added.'
            else Result := 'GM_ATHENA_SKPOINT Success. ' + IntToStr(oldpoints - tc.SkillPoint) + ' points subtracted.'
        end else begin
            Result := Result + ' Skill Point amount out of range [-1001-1001].';
        end;
    end;

    function command_athena_stpoint(tc : TChara; str : String) : String;
    var
        i, k : Integer;
        oldpoints : Integer;
    begin
        Result := 'GM_ATHENA_STPOINT Failure.';

        oldpoints := tc.StatusPoint;

        Val(Copy(str, 9, 256), i, k);
        if (k = 0) and (i >= -9999) and (i <= 9999) then begin
            if i < 0 then begin
                if (tc.StatusPoint + i >= 0) then tc.StatusPoint := tc.StatusPoint + i
                else if (tc.StatusPoint + i < 0) and (tc.StatusPoint > 0) then begin
                    tc.StatusPoint := 0;
                end else begin
                    Result := Result + ' Minimum number of points is 0.';
                    Exit;
                end;
            end

            else begin
                if (tc.StatusPoint + i <= 999) then tc.StatusPoint := tc.StatusPoint + i
                else if (tc.StatusPoint + i > 9999) and (tc.SkillPoint < 9999) then begin
                    tc.StatusPoint := 9999;
                end else begin
                    Result := Result + ' Maximum number of points is 9999.';
                    Exit;
                end;
            end;

            SendCStat1(tc, 0, $0009, tc.StatusPoint);

            if (i > 0) then Result := 'GM_ATHENA_STPOINT Success. ' + IntToStr(tc.StatusPoint - oldpoints) + ' points added.'
            else Result := 'GM_ATHENA_STPOINT Success. ' + IntToStr(oldpoints - tc.StatusPoint) + ' points subtracted.'
        end else begin
            Result := Result + ' Status Point amount out of range [-9999-9999].';
        end;
    end;

    function command_athena_str(tc : TChara; str : String) : String;
    var
        i, k, oldpoints : Integer;
    begin
        Result := 'GM_ATHENA_STR Failure.';

        oldpoints := tc.ParamBase[0];

        Val(Copy(str, 5, 256), i, k);
        if (k = 0) and (i >= -32767) and (i <= 32767) then begin
            if i < 0 then begin
                if (tc.ParamBase[0] + i >= 1) then tc.ParamBase[0] := tc.ParamBase[0] + i
                else if (tc.ParamBase[0] + i < 1) and (tc.ParamBase[0] > 1) then begin
                    tc.ParamBase[0] := 1;
                end else begin
                    Result := Result + 'Minimum number of points is 1.';
                    Exit;
                end;
            end

            else begin
                if (tc.ParamBase[0] + i <= 32767) then tc.ParamBase[0] := tc.ParamBase[0] + i
                else if (tc.ParamBase[0] + i > 32767) and (tc.ParamBase[0] < 32767) then begin
                    tc.ParamBase[0] := 32767;
                end else begin
                    Result := Result + 'Maximum number of points is 32767.';
                    Exit;
                end;
            end;

            CalcStat(tc);
            SendCStat(tc);

            if (i > 0) then Result := 'GM_ATHENA_STR Success. ' + IntToStr(tc.ParamBase[0] - oldpoints) + ' points added.'
            else Result := 'GM_ATHENA_STR Success. ' + IntToStr(oldpoints - tc.ParamBase[0]) + ' points subtracted.'
        end else begin
            Result := Result + 'Point amount out of range [-32767-32767].';
        end;
    end;

    function command_athena_agi(tc : TChara; str : String) : String;
    var
        i, k, oldpoints : Integer;
    begin
        Result := 'GM_ATHENA_AGI Failure.';

        oldpoints := tc.ParamBase[1];

        Val(Copy(str, 5, 256), i, k);
        if (k = 0) and (i >= -32767) and (i <= 32767) then begin
            if i < 0 then begin
                if (tc.ParamBase[1] + i >= 1) then tc.ParamBase[1] := tc.ParamBase[1] + i
                else if (tc.ParamBase[1] + i < 1) and (tc.ParamBase[1] > 1) then begin
                    tc.ParamBase[1] := 1;
                end else begin
                    Result := Result + 'Minimum number of points is 1.';
                    Exit;
                end;
            end

            else begin
                if (tc.ParamBase[1] + i <= 32767) then tc.ParamBase[1] := tc.ParamBase[1] + i
                else if (tc.ParamBase[1] + i > 32767) and (tc.ParamBase[1] < 32767) then begin
                    tc.ParamBase[1] := 32767;
                end else begin
                    Result := Result + 'Maximum number of points is 32767.';
                    Exit;
                end;
            end;

            CalcStat(tc);
            SendCStat(tc);

            if (i > 0) then Result := 'GM_ATHENA_AGI Success. ' + IntToStr(tc.ParamBase[1] - oldpoints) + ' points added.'
            else Result := 'GM_ATHENA_AGI Success. ' + IntToStr(oldpoints - tc.ParamBase[1]) + ' points subtracted.'
        end else begin
            Result := Result + 'Point amount out of range [-32767-32767].';
        end;
    end;

    function command_athena_vit(tc : TChara; str : String) : String;
    var
        i, k, oldpoints : Integer;
    begin
        Result := 'GM_ATHENA_VIT Failure.';

        oldpoints := tc.ParamBase[2];

        Val(Copy(str, 5, 256), i, k);
        if (k = 0) and (i >= -32767) and (i <= 32767) then begin
            if i < 0 then begin
                if (tc.ParamBase[2] + i >= 1) then tc.ParamBase[2] := tc.ParamBase[2] + i
                else if (tc.ParamBase[2] + i < 1) and (tc.ParamBase[2] > 1) then begin
                    tc.ParamBase[2] := 1;
                end else begin
                    Result := Result + 'Minimum number of points is 1.';
                    Exit;
                end;
            end

            else begin
                if (tc.ParamBase[2] + i <= 32767) then tc.ParamBase[2] := tc.ParamBase[2] + i
                else if (tc.ParamBase[2] + i > 32767) and (tc.ParamBase[2] < 32767) then begin
                    tc.ParamBase[2] := 32767;
                end else begin
                    Result := Result + 'Maximum number of points is 32767.';
                    Exit;
                end;
            end;

            CalcStat(tc);
            SendCStat(tc);

            if (i > 0) then Result := 'GM_ATHENA_VIT Success. ' + IntToStr(tc.ParamBase[2] - oldpoints) + ' points added.'
            else Result := 'GM_ATHENA_VIT Success. ' + IntToStr(oldpoints - tc.ParamBase[2]) + ' points subtracted.'
        end else begin
            Result := Result + 'Point amount out of range [-32767-32767].';
        end;
    end;

    function command_athena_int(tc : TChara; str : String) : String;
    var
        i, k, oldpoints : Integer;
    begin
        Result := 'GM_ATHENA_INT Failure.';

        oldpoints := tc.ParamBase[3];

        Val(Copy(str, 5, 256), i, k);
        if (k = 0) and (i >= -32767) and (i <= 32767) then begin
            if i < 0 then begin
                if (tc.ParamBase[3] + i >= 1) then tc.ParamBase[3] := tc.ParamBase[3] + i
                else if (tc.ParamBase[3] + i < 1) and (tc.ParamBase[3] > 1) then begin
                    tc.ParamBase[3] := 1;
                end else begin
                    Result := Result + 'Minimum number of points is 1.';
                    Exit;
                end;
            end

            else begin
                if (tc.ParamBase[3] + i <= 32767) then tc.ParamBase[3] := tc.ParamBase[3] + i
                else if (tc.ParamBase[3] + i > 32767) and (tc.ParamBase[3] < 32767) then begin
                    tc.ParamBase[3] := 32767;
                end else begin
                    Result := Result + 'Maximum number of points is 32767.';
                    Exit;
                end;
            end;

            CalcStat(tc);
            SendCStat(tc);

            if (i > 0) then Result := 'GM_ATHENA_INT Success. ' + IntToStr(tc.ParamBase[3] - oldpoints) + ' points added.'
            else Result := 'GM_ATHENA_INT Success. ' + IntToStr(oldpoints - tc.ParamBase[3]) + ' points subtracted.'
        end else begin
            Result := Result + 'Point amount out of range [-32767-32767].';
        end;
    end;

    function command_athena_dex(tc : TChara; str : String) : String;
    var
        i, k, oldpoints : Integer;
    begin
        Result := 'GM_ATHENA_DEX Failure.';

        oldpoints := tc.ParamBase[4];

        Val(Copy(str, 5, 256), i, k);
        if (k = 0) and (i >= -32767) and (i <= 32767) then begin
            if i < 0 then begin
                if (tc.ParamBase[4] + i >= 1) then tc.ParamBase[4] := tc.ParamBase[4] + i
                else if (tc.ParamBase[4] + i < 1) and (tc.ParamBase[4] > 1) then begin
                    tc.ParamBase[4] := 1;
                end else begin
                    Result := Result + 'Minimum number of points is 1.';
                    Exit;
                end;
            end

            else begin
                if (tc.ParamBase[4] + i <= 32767) then tc.ParamBase[4] := tc.ParamBase[4] + i
                else if (tc.ParamBase[4] + i > 32767) and (tc.ParamBase[4] < 32767) then begin
                    tc.ParamBase[4] := 32767;
                end else begin
                    Result := Result + 'Maximum number of points is 32767.';
                    Exit;
                end;
            end;

            CalcStat(tc);
            SendCStat(tc);

            if (i > 0) then Result := 'GM_ATHENA_DEX Success. ' + IntToStr(tc.ParamBase[4] - oldpoints) + ' points added.'
            else Result := 'GM_ATHENA_DEX Success. ' + IntToStr(oldpoints - tc.ParamBase[4]) + ' points subtracted.'
        end else begin
            Result := Result + 'Point amount out of range [-32767-32767].';
        end;
    end;

    function command_athena_luk(tc : TChara; str : String) : String;
    var
        i, k, oldpoints : Integer;
    begin
        Result := 'GM_ATHENA_LUK Failure.';

        oldpoints := tc.ParamBase[5];

        Val(Copy(str, 5, 256), i, k);
        if (k = 0) and (i >= -32767) and (i <= 32767) then begin
            if i < 0 then begin
                if (tc.ParamBase[5] + i >= 1) then tc.ParamBase[5] := tc.ParamBase[5] + i
                else if (tc.ParamBase[5] + i < 1) and (tc.ParamBase[5] > 1) then begin
                    tc.ParamBase[5] := 1;
                end else begin
                    Result := Result + 'Minimum number of points is 1.';
                    Exit;
                end;
            end

            else begin
                if (tc.ParamBase[5] + i <= 32767) then tc.ParamBase[5] := tc.ParamBase[5] + i
                else if (tc.ParamBase[5] + i > 32767) and (tc.ParamBase[5] < 32767) then begin
                    tc.ParamBase[5] := 32767;
                end else begin
                    Result := Result + 'Maximum number of points is 32767.';
                    Exit;
                end;
            end;

            CalcStat(tc);
            SendCStat(tc);

            if (i > 0) then Result := 'GM_ATHENA_LUK Success. ' + IntToStr(tc.ParamBase[5] - oldpoints) + ' points added.'
            else Result := 'GM_ATHENA_LUK Success. ' + IntToStr(oldpoints - tc.ParamBase[5]) + ' points subtracted.'
        end else begin
            Result := Result + 'Point amount out of range [-32767-32767].';
        end;
    end;

    function command_athena_spiritball(tc : TChara; str : String) : String;
    var
        tm : TMap;
        i, k : Integer;
    begin
        Result := 'GM_ATHENA_SPIRITBALL Failure.';

        tm := tc.MData;

        Val(Copy(str, 12, 256), i, k);

        if (k = 0) and (i >= 1) and (i <= 1000) then begin
            tc.spiritSpheres := i;
            UpdateSpiritSpheres(tm, tc, tc.spiritSpheres);
            Result := 'GM_ATHENA_SPIRITBALL Success.';
        end;
    end;

    function command_athena_questskill(tc : TChara; str : String) : String;
    var
        i, k : Integer;
    begin
        Result := 'GM_ATHENA_QUESTSKILL Failure.';

        Val(Copy(str, 12, 256), i, k);

        if (k = 0) and (i >= 144) and (i <= 157) then begin
            tc.Skill[i].Lv := 1;
            SendCSkillList(tc);
            Result := 'GM_ATHENA_QUESTSKILL Success.';
        end;
    end;

    function command_athena_lostskill(tc : TChara; str : String) : String;
    var
        i, k : Integer;
    begin
        Result := 'GM_ATHENA_LOSTSKILL Failure.';

        Val(Copy(str, 11, 256), i, k);

        if (k = 0) and (i >= 144) and (i <= 157) then begin
            tc.Skill[i].Lv := 0;
            SendCSkillList(tc);
            Result := 'GM_ATHENA_LOSTSKILL Success.';
        end;
    end;

    function command_athena_model(tc : TChara; str : String) : String;
    var
        i, j, k, ii : Integer;
        tm : TMap;
        sl : TStringList;
    begin
        Result := 'GM_ATHENA_MODEL Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := str;

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

        if sl.count <> 4 then Exit;

        val(sl.Strings[1], i, ii);
        if ii <> 0 then Exit;
        val(sl.Strings[2], j, ii);
        if ii <> 0 then Exit;
        val(sl.Strings[3], k, ii);
        if ii <> 0 then Exit;

        if (i >= 0) and (i <= 20) and (j >= 0) and (j <= 8) and (k >= 0) and (k <= 4) then begin
            tc.Hair := i;
            tc.HairColor := j;
            tc.ClothesColor := k;
            UpdateLook(tm, tc, 1, i, 0, true);
            UpdateLook(tm, tc, 6, i, 0, true);
            UpdateLook(tm, tc, 7, i, 0, true);
            Result := 'GM_ATHENA_MODEL Success.';
        end;
    end;

    function command_athena_item(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        td : TItemDB;
        i, j, k : Integer;
        itemname : String;
    begin
        Result := 'GM_ATHENA_ITEM Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 6, 256);

        if sl.Count = 2 then begin
            itemname := sl.Strings[0];
            if ItemDBName.IndexOf(itemname) <> -1 then begin

                td := ItemDBName.Objects[ItemDBName.IndexOf(itemname)] as TItemDB;

                Val(sl[1], j, k);

                if k <> 0 then Exit;

                if (j <= 0) or (j > 30000) then Exit;

                if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) * cardinal(j) then begin
                    k := SearchCInventory(tc, i, td.IEquip);

                    if k <> 0 then begin
                        if tc.Item[k].Amount + j > 30000 then Exit;
                        if td.IEquip then j := 1;

                        tc.Item[k].ID := td.ID;
                        tc.Item[k].Amount := tc.Item[k].Amount + j;
                        tc.Item[k].Equip := 0;
                        tc.Item[k].Identify := 1;
                        tc.Item[k].Refine := 0;
                        tc.Item[k].Attr := 0;
                        tc.Item[k].Card[0] := 0;
                        tc.Item[k].Card[1] := 0;
                        tc.Item[k].Card[2] := 0;
                        tc.Item[k].Card[3] := 0;
                        tc.Item[k].Data := td;

                        tc.Weight := tc.Weight + cardinal(td.Weight) * cardinal(j);
                        SendCStat1(tc, 0, $0018, tc.Weight);

                        SendCGetItem(tc, k, j);
                        Result := 'GM_ATHENA_ITEM Success.' + inttostr(j) + ' ' + itemname + ' spawned.' ;;
                    end;
                end

                else begin
                    WFIFOW( 0, $00a0);
                    WFIFOB(22, 2);
                    tc.Socket.SendBuf(buf, 23);
                end;
            end

            else begin
                Val(sl[0], i, k);

                if k <> 0 then Exit;
                if ItemDB.IndexOf(i) = -1 then Exit;

                Val(sl[1], j, k);

                if k <> 0 then Exit;
                if (j <= 0) or (j > 30000) then Exit;

                td := ItemDB.IndexOfObject(i) as TItemDB;

                if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) * cardinal(j) then begin
                    k := SearchCInventory(tc, i, td.IEquip);

                    if k <> 0 then begin
                        if tc.Item[k].Amount + j > 30000 then Exit;
                        if td.IEquip then j := 1;

                        tc.Item[k].ID := i;
                        tc.Item[k].Amount := tc.Item[k].Amount + j;
                        tc.Item[k].Equip := 0;
                        tc.Item[k].Identify := 1;
                        tc.Item[k].Refine := 0;
                        tc.Item[k].Attr := 0;
                        tc.Item[k].Card[0] := 0;
                        tc.Item[k].Card[1] := 0;
                        tc.Item[k].Card[2] := 0;
                        tc.Item[k].Card[3] := 0;
                        tc.Item[k].Data := td;

                        tc.Weight := tc.Weight + cardinal(td.Weight) * cardinal(j);
                        SendCStat1(tc, 0, $0018, tc.Weight);

                        SendCGetItem(tc, k, j);
                        Result := 'GM_ATHENA_ITEM Success.';
                    end;
                end

                else begin
                    WFIFOW( 0, $00a0);
                    WFIFOB(22, 2);
                    tc.Socket.SendBuf(buf, 23);
                end;
            end;

            sl.Free;
        end;
    end;

    function command_athena_item2(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        td : TItemDB;
        i, j, k, l, identify, refine, attribute, card1, card2, card3, card4 : Integer;
        itemname : String;
    begin
        Result := 'GM_ATHENA_ITEM2 Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 7, 256);

        if sl.Count = 9 then begin
            itemname := sl.Strings[0];
            if ItemDBName.IndexOf(itemname) <> -1 then begin

                td := ItemDBName.Objects[ItemDBName.IndexOf(itemname)] as TItemDB;

                Val(sl[1], j, k);

                if k <> 0 then Exit;

                if (j <= 0) or (j > 30000) then Exit;

                if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) * cardinal(j) then begin
                    k := SearchCInventory(tc, i, td.IEquip);

                    if k <> 0 then begin
                        if tc.Item[k].Amount + j > 30000 then Exit;
                        if td.IEquip then j := 1;

                        Val(sl[2], identify, l);

                        if l <> 0 then Exit;

                        Val(sl[3], refine, l);

                        if l <> 0 then Exit;

                        Val(sl[4], attribute, l);

                        if l <> 0 then Exit;

                        Val(sl[5], card1, l);

                        if l <> 0 then Exit;

                        Val(sl[6], card2, l);

                        if l <> 0 then Exit;

                        Val(sl[7], card3, l);

                        if l <> 0 then Exit;

                        Val(sl[8], card4, l);

                        if l <> 0 then Exit;

                        tc.Item[k].ID := td.ID;
                        tc.Item[k].Amount := tc.Item[k].Amount + j;
                        tc.Item[k].Equip := 0;
                        tc.Item[k].Identify := identify;
                        tc.Item[k].Refine := refine;
                        tc.Item[k].Attr := attribute;
                        tc.Item[k].Card[0] := card1;
                        tc.Item[k].Card[1] := card2;
                        tc.Item[k].Card[2] := card3;
                        tc.Item[k].Card[3] := card4;
                        tc.Item[k].Data := td;

                        tc.Weight := tc.Weight + cardinal(td.Weight) * cardinal(j);
                        SendCStat1(tc, 0, $0018, tc.Weight);

                        SendCGetItem(tc, k, j);
                        Result := 'GM_ATHENA_ITEM2 Success.' + inttostr(j) + ' ' + itemname + ' spawned.' ;;
                    end;
                end

                else begin
                    WFIFOW( 0, $00a0);
                    WFIFOB(22, 2);
                    tc.Socket.SendBuf(buf, 23);
                end;
            end

            else begin
                Val(sl[0], i, k);

                if k <> 0 then Exit;
                if ItemDB.IndexOf(i) = -1 then Exit;

                Val(sl[1], j, k);

                if k <> 0 then Exit;
                if (j <= 0) or (j > 30000) then Exit;

                td := ItemDB.IndexOfObject(i) as TItemDB;

                if tc.MaxWeight >= tc.Weight + cardinal(td.Weight) * cardinal(j) then begin
                    k := SearchCInventory(tc, i, td.IEquip);

                    if k <> 0 then begin
                        if tc.Item[k].Amount + j > 30000 then Exit;
                        if td.IEquip then j := 1;

                        Val(sl[2], identify, l);

                        if l <> 0 then Exit;

                        Val(sl[3], refine, l);

                        if l <> 0 then Exit;

                        Val(sl[4], attribute, l);

                        if l <> 0 then Exit;

                        Val(sl[5], card1, l);

                        if l <> 0 then Exit;

                        Val(sl[6], card2, l);

                        if l <> 0 then Exit;

                        Val(sl[7], card3, l);

                        if l <> 0 then Exit;

                        Val(sl[8], card4, l);

                        if l <> 0 then Exit;

                        tc.Item[k].ID := i;
                        tc.Item[k].Amount := tc.Item[k].Amount + j;
                        tc.Item[k].Equip := 0;
                        tc.Item[k].Identify := identify;
                        tc.Item[k].Refine := refine;
                        tc.Item[k].Attr := attribute;
                        tc.Item[k].Card[0] := card1;
                        tc.Item[k].Card[1] := card2;
                        tc.Item[k].Card[2] := card3;
                        tc.Item[k].Card[3] := card4;
                        tc.Item[k].Data := td;

                        tc.Weight := tc.Weight + cardinal(td.Weight) * cardinal(j);
                        SendCStat1(tc, 0, $0018, tc.Weight);

                        SendCGetItem(tc, k, j);
                        Result := 'GM_ATHENA_ITEM2 Success.';
                    end;
                end

                else begin
                    WFIFOW( 0, $00a0);
                    WFIFOB(22, 2);
                    tc.Socket.SendBuf(buf, 23);
                end;
            end;

            sl.Free;
        end;
    end;

    function command_athena_doom(tc : Tchara) : String;
    var
        tc1 : TChara;
        tm : TMap;
        i, w : Integer;
        debug : String;
    begin
        Result := 'GM_ATHENA_DOOM Success.';
        for i := 0 to CharaName.Count - 1 do begin
            tc1 := CharaName.Objects[i] as TChara;
            if tc1.Login = 2 then begin
                if tc1.PData.Accesslevel = 0 then begin
                    debug := 'The user ' + tc1.Name + ' has been killed.';
                    w := Length(debug) + 4;
                    tm := Map.Objects[Map.IndexOf(tc1.Map)] as TMap;
                    CharaDie(tm, tc1, 1);
                    WFIFOW (0, $009a);
                    WFIFOW (2, w);
                    WFIFOS (4, debug, w - 4);
                    tc.socket.sendbuf(buf, w);
                end;
            end;
        end;
    end;

    function command_athena_kick(tc : TChara; str : String) : String;
    var
        s : String;
        tc1 : TChara;
    begin
        Result := 'GM_ATHENA_KICK Failure.';
        s := Copy(str, 6, 256);
        s := Trim(s);

        if CharaName.Indexof(s) <> -1 then begin
            tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;
            if tc1.Login = 2 then begin
                tc1.Socket.Close;
                Result := 'GM_ATHENA_KICK Success. Character ' + tc1.Name + ' has been kicked.';
            end else begin
                Result := Result + ' Character ' + s + ' is not online.';
            end;
        end else begin
            Result := Result + ' Character ' + s + ' does not exist.';
        end;
    end;

    function command_athena_kickall(tc : TChara) : String;
    var
        tc1 : TChara;
        tm : TMap;
        i : Integer;
    begin
        Result := 'GM_ATHENA_KICKALL Success.';

        for i := 0 to CharaName.Count - 1 do begin
            tc1 := CharaName.Objects[i] as TChara;
            if tc1.Login = 2 then begin
                tc1.Socket.Close;
            end;
        end;
    end;

    function command_athena_raise(tc : TChara) : String;
    var
        tc1 : TChara;
        tm : TMap;
        i : Integer;
    begin
        Result := 'GM_ATHENA_RAISE Success.';
        for i := 0 to CharaName.Count - 1 do begin
            tc1 := CharaName.Objects[i] as TChara;
            if tc1.Login = 2 then begin
                tm := Map.Objects[Map.IndexOf(tc1.Map)] as TMap;
                tc1.HP := tc1.MAXHP;
                tc1.SP := tc1.MAXSP;
                tc1.Sit := 3;
                SendCStat1(tc1, 0, 5, tc1.HP);
                SendCStat1(tc1, 0, 7, tc1.SP);
                WFIFOW(0, $0148);
                WFIFOL(2, tc1.ID);
                WFIFOW(6, 100);
                SendBCmd(tm, tc1.Point, 8);
            end;
        end;
    end;


    function command_athena_raisemap(tc : TChara) : String;
    var
        tc1 : TChara;
        i : Integer;
        tm : TMap;
    begin
        Result := 'GM_ATHENA_RAISEMAP Success.';
        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        for i := 0 to tm.CList.Count - 1 do begin
            tc1 := tm.CList.objects[i] as TChara;
            tc1.HP := tc1.MAXHP;
            tc1.SP := tc1.MAXSP;
            tc1.Sit := 3;
            SendCStat1(tc1, 0, 5, tc1.HP);
            SendCStat1(tc1, 0, 7, tc1.SP);
            WFIFOW(0, $0148);
            WFIFOL(2, tc1.ID);
            WFIFOW(6, 100);
            SendBCmd(tm, tc1.Point, 8);
        end;
    end;
    
end.
