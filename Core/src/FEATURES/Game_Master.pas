unit Game_Master;

interface

uses
    IniFiles, Classes, SysUtils, Common, List32, MMSystem, Globals;

type TGM_Table = class
    ID : Integer;
    Level : Byte;
end;

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
    GM_ATHENA_KILL : Byte;
    GM_ATHENA_DIE : Byte;
    GM_ATHENA_JOBCHANGE : Byte;
    GM_ATHENA_HIDE : Byte;
    GM_ATHENA_OPTION : Byte;
    GM_ATHENA_STORAGE : Byte;
    GM_ATHENA_SPEED : Byte;
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
    GM_ATHENA_HELP : Byte;
    GM_ATHENA_ZENY : Byte;
    GM_ATHENA_BASELVLUP : Byte;
    GM_ATHENA_LVUP : Byte;
    GM_ATHENA_JOBLVLUP : Byte;
    GM_ATHENA_JOBLVUP : Byte;
    GM_ATHENA_SKPOINT :  Byte;


    GM_Access_DB : TIntList32;

    procedure load_commands();
    procedure save_commands();

    procedure parse_commands(tc : TChara; str : String);
    function check_level(id : Integer; cmd : Integer) : Boolean;
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
    function command_athena_kill(tc: TChara; str : String) : String;
    function command_athena_die(tc : TChara) : String;
    function command_athena_jobchange(tc : TChara; str : String) : String;
    function command_athena_hide(tc : TChara) : String;
    function command_athena_option(tc : TChara; str : String) : String;
    function command_athena_storage(tc : TChara) : String;
    function command_athena_speed(tc : TChara; str : String) : String;
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
    function command_athena_help(tc : TChara) : String;
    function command_athena_zeny(tc : TChara; str : String) : String;
    function command_athena_baselvlup(tc : TChara; str : String) : String;
    function command_athena_lvup(tc : TChara; str : String) : String;
    function command_athena_joblvlup(tc : TChara; str : String) : String;
    function command_athena_joblvup(tc : TChara; str : String) : String;
    function command_athena_skpoint(tc : TChara; str : String) : String;

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
        GM_ATHENA_KILL := StrToIntDef(sl.Values['ATHENA_KILL'], 1);
        GM_ATHENA_DIE := StrToIntDef(sl.Values['ATHENA_DIE'], 1);
        GM_ATHENA_JOBCHANGE := StrToIntDef(sl.Values['ATHENA_JOBCHANGE'], 1);
        GM_ATHENA_HIDE := StrToIntDef(sl.Values['ATHENA_HIDE'], 1);
        GM_ATHENA_OPTION := StrToIntDef(sl.Values['ATHENA_OPTION'], 1);
        GM_ATHENA_STORAGE := StrToIntDef(sl.Values['ATHENA_STORAGE'], 1);
        GM_ATHENA_SPEED := StrToIntDef(sl.Values['ATHENA_SPEED'], 1);
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
        GM_ATHENA_HELP := StrToIntDef(sl.Values['ATHENA_HELP'], 1);
        GM_ATHENA_ZENY := StrToIntDef(sl.Values['ATHENA_ZENY'], 1);
        GM_ATHENA_BASELVLUP := StrToIntDef(sl.Values['ATHENA_BASELVLUP'], 1);
        GM_ATHENA_LVUP := StrToIntDef(sl.Values['ATHENA_LVUP'], 1);
        GM_ATHENA_JOBLVLUP := StrToIntDef(sl.Values['ATHENA_JOBLVLUP'], 1);
        GM_ATHENA_JOBLVUP := StrToIntDef(sl.Values['ATHENA_JOBLVUP'], 1);
        GM_ATHENA_SKPOINT := StrToIntDef(sl.Values['ATHENA_SKPOINT'], 1);

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
        Idx : Integer;
    Begin
        ini := TIniFile.Create(AppPath + 'gm_commands.ini');

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
        ini.WriteString('Athena GM Commands', 'ATHENA_KILL', IntToStr(GM_ATHENA_KILL));
        ini.WriteString('Athena GM Commands', 'ATHENA_DIE', IntToStr(GM_ATHENA_DIE));
        ini.WriteString('Athena GM Commands', 'ATHENA_JOBCHANGE', IntToStr(GM_ATHENA_JOBCHANGE));
        ini.WriteString('Athena GM Commands', 'ATHENA_HIDE', IntToStr(GM_ATHENA_HIDE));
        ini.WriteString('Athena GM Commands', 'ATHENA_OPTION', IntToStr(GM_ATHENA_OPTION));
        ini.WriteString('Athena GM Commands', 'ATHENA_STORAGE', IntToStr(GM_ATHENA_STORAGE));
        ini.WriteString('Athena GM Commands', 'ATHENA_SPEED', IntToStr(GM_ATHENA_SPEED));
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
        ini.WriteString('Athena GM Commands', 'ATHENA_HELP', IntToStr(GM_ATHENA_HELP));
        ini.WriteString('Athena GM Commands', 'ATHENA_ZENY', IntToStr(GM_ATHENA_ZENY));
        ini.WriteString('Athena GM Commands', 'ATHENA_BASELVLUP', IntToStr(GM_ATHENA_BASELVLUP));
        ini.WriteString('Athena GM Commands', 'ATHENA_LVUP', IntToStr(GM_ATHENA_LVUP));
        ini.WriteString('Athena GM Commands', 'ATHENA_JOBLVLUP', IntToStr(GM_ATHENA_JOBLVLUP));
        ini.WriteString('Athena GM Commands', 'ATHENA_JOBLVUP', IntToStr(GM_ATHENA_JOBLVUP));
        ini.WriteString('Athena GM Commands', 'ATHENA_SKPOINT', IntToStr(GM_ATHENA_SKPOINT));

        ini.Free;

        //Free up the GM Command List when program closes down.
        for Idx := GM_Access_DB.Count-1 downto 0 do begin
            if Assigned(GM_Access_DB.Objects[Idx]) then begin
                (GM_Access_DB.Objects[Idx] AS TGM_Table).Free;
            end;
        end;

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
            if ( (copy(str, 1, length('alive')) = 'alive') and (check_level(tc.ID, GM_ALIVE)) ) then error_msg := command_alive(tc)
            else if ( (copy(str, 1, length('item')) = 'item') and (check_level(tc.ID, GM_ITEM)) ) then error_msg := command_item(tc, str)
            else if ( (copy(str, 1, length('save')) = 'save') and (check_level(tc.ID, GM_SAVE)) ) then error_msg := command_save(tc)
            else if ( (copy(str, 1, length('return')) = 'return') and (check_level(tc.ID, GM_RETURN)) ) then error_msg := command_return(tc)
            else if ( (copy(str, 1, length('die')) = 'die') and (check_level(tc.ID, GM_DIE)) ) then error_msg := command_die(tc)
            else if ( (copy(str, 1, length('auto')) = 'auto') and (check_level(tc.ID, GM_AUTO)) ) then error_msg := command_auto(tc, str)
            else if ( (copy(str, 1, length('hcolor')) = 'hcolor') and (check_level(tc.ID, GM_HCOLOR)) ) then error_msg := command_hcolor(tc, str)
            else if ( (copy(str, 1, length('ccolor')) = 'ccolor') and (check_level(tc.ID, GM_CCOLOR)) ) then error_msg := command_ccolor(tc, str)
            else if ( (copy(str, 1, length('hstyle')) = 'hstyle') and (check_level(tc.ID, GM_HSTYLE)) ) then error_msg := command_hstyle(tc, str)
            else if ( (copy(str, 1, length('kill')) = 'kill') and (check_level(tc.ID, GM_KILL)) ) then error_msg := command_kill(str)
            else if ( (copy(str, 1, length('goto')) = 'goto') and (check_level(tc.ID, GM_GOTO)) ) then error_msg := command_goto(tc, str)
            else if ( (copy(str, 1, length('summon')) = 'summon') and (check_level(tc.ID, GM_SUMMON)) ) then error_msg := command_summon(tc, str)
            else if ( (copy(str, 1, length('warp')) = 'warp') and (check_level(tc.ID, GM_WARP)) ) then error_msg := command_warp(tc, str)
            else if ( (copy(str, 1, length('banish')) = 'banish') and (check_level(tc.ID, GM_BANISH)) ) then error_msg := command_banish(str)
            else if ( (copy(str, 1, length('job')) = 'job') and (check_level(tc.ID, GM_JOB)) ) then error_msg := command_job(tc, str)
            else if ( (copy(str, 1, length('blevel')) = 'blevel') and (check_level(tc.ID, GM_BLEVEL)) ) then error_msg := command_blevel(tc, str)
            else if ( (copy(str, 1, length('jlevel')) = 'jlevel') and (check_level(tc.ID, GM_JLEVEL)) ) then error_msg := command_jlevel(tc, str)
            else if ( (copy(str, 1, length('changestat')) = 'changestat') and (check_level(tc.ID, GM_CHANGESTAT)) ) then error_msg := command_changestat(tc, str)
            else if ( (copy(str, 1, length('skillpoint')) = 'skillpoint') and (check_level(tc.ID, GM_SKILLPOINT)) ) then error_msg := command_skillpoint(tc, str)
            else if ( (copy(str, 1, length('skillall')) = 'skillall') and (check_level(tc.ID, GM_SKILLALL)) ) then error_msg := command_skillall(tc)
            else if ( (copy(str, 1, length('statall')) = 'statall') and (check_level(tc.ID, GM_STATALL)) ) then error_msg := command_statall(tc)
            else if ( (copy(str, 1, length('superstats')) = 'superstats') and (check_level(tc.ID, GM_SUPERSTATS)) ) then error_msg := command_superstats(tc)
            else if ( (copy(str, 1, length('zeny')) = 'zeny') and (check_level(tc.ID, GM_ZENY)) ) then error_msg := command_zeny(tc, str)
            else if ( (copy(str, 1, length('changeskill')) = 'changeskill') and (check_level(tc.ID, GM_CHANGESKILL)) ) then error_msg := command_changeskill(tc, str)
            else if ( (copy(str, 1, length('monster')) = 'monster') and (check_level(tc.ID, GM_MONSTER)) ) then error_msg := command_monster(tc, str)
            else if ( (copy(str, 1, length('speed')) = 'speed') and (check_level(tc.ID, GM_SPEED)) ) then error_msg := command_speed(tc, str)
            else if ( (copy(str, 1, length('whois')) = 'whois') and (check_level(tc.ID, GM_WHOIS)) ) then error_msg := command_whois(tc)
            else if ( (copy(str, 1, length('option')) = 'option') and (check_level(tc.ID, GM_OPTION)) ) then error_msg := command_option(tc, str)
            else if ( (copy(str, 1, length('raw')) = 'raw') and (check_level(tc.ID, GM_RAW)) ) then error_msg := command_raw(tc, str)
            else if ( (copy(str, 1, length('unit')) = 'unit') and (check_level(tc.ID, GM_UNIT)) ) then error_msg := command_unit(tc, str)
            else if ( (copy(str, 1, length('stat')) = 'stat') and (check_level(tc.ID, GM_STAT)) ) then error_msg := command_stat(tc, str)
            else if ( (copy(str, 1, length('refine')) = 'refine') and (check_level(tc.ID, GM_REFINE)) ) then error_msg := command_refine(tc, str)
            else if ( (copy(str, 1, length('glevel')) = 'glevel') and (check_level(tc.ID, GM_GLEVEL)) ) then error_msg := command_glevel(tc, str)
            else if ( (copy(str, 1, length('ironical')) = 'ironical') and (check_level(tc.ID, GM_IRONICAL)) ) then error_msg := command_ironical(tc)
            else if ( (copy(str, 1, length('mothball')) = 'mothball') and (check_level(tc.ID, GM_MOTHBALL)) ) then error_msg := command_mothball(tc)
            else if ( (copy(str, 1, length('where')) = 'where') and (check_level(tc.ID, GM_WHERE)) ) then error_msg := command_where(tc, str)
            else if ( (copy(str, 1, length('revive')) = 'revive') and (check_level(tc.ID, GM_REVIVE)) ) then error_msg := command_revive(str)
            else if ( (copy(str, 1, length('ban')) = 'ban') and (check_level(tc.ID, GM_BAN)) ) then error_msg := command_ban(str)
            else if ( (copy(str, 1, length('kick')) = 'kick') and (check_level(tc.ID, GM_KICK)) ) then error_msg := command_kick(str)
            else if ( (copy(str, 1, length('icon')) = 'icon') and (check_level(tc.ID, GM_ICON)) ) then error_msg := command_icon(tc, str)
            else if ( (copy(str, 1, length('unicon')) = 'unicon') and (check_level(tc.ID, GM_UNICON)) ) then error_msg := command_unicon(tc, str)
            else if ( (copy(str, 1, length('server')) = 'server') and (check_level(tc.ID, GM_SERVER)) ) then error_msg := command_server()
            else if ( (copy(str, 1, length('pvpon')) = 'pvpon') and (check_level(tc.ID, GM_PVPON)) ) then error_msg := command_pvpon(tc)
            else if ( (copy(str, 1, length('pvpoff')) = 'pvpoff') and (check_level(tc.ID, GM_PVPOFF)) ) then error_msg := command_pvpoff(tc)
            else if ( (copy(str, 1, length('gpvpon')) = 'gpvpon') and (check_level(tc.ID, GM_GPVPON)) ) then error_msg := command_gpvpon(tc)
            else if ( (copy(str, 1, length('gpvpoff')) = 'gpvpoff') and (check_level(tc.ID, GM_GPVPOFF)) ) then error_msg := command_gpvpoff(tc)
            else if ( (copy(str, 1, length('newplayer')) = 'newplayer') and (check_level(tc.ID, GM_NEWPLAYER)) ) then error_msg := command_newplayer(str)
            else if ( (copy(str, 1, length('pword')) = 'pword') and (check_level(tc.ID, GM_PWORD)) ) then error_msg := command_pword(tc, str)
            else if ( (copy(str, 1, length('users')) = 'users') and (check_level(tc.ID, GM_USERS)) ) then error_msg := command_users()
            else if ( (copy(str, 1, length('charblevel')) = 'charblevel') and (check_level(tc.ID, GM_CHARBLEVEL)) ) then error_msg := command_charblevel(tc, str)
            else if ( (copy(str, 1, length('charjlevel')) = 'charjlevel') and (check_level(tc.ID, GM_CHARJLEVEL)) ) then error_msg := command_charjlevel(tc, str)
            else if ( (copy(str, 1, length('charstatpoint')) = 'charstatpoint') and (check_level(tc.ID, GM_CHARSTATPOINT)) ) then error_msg := command_charstatpoint(tc, str)
            else if ( (copy(str, 1, length('charskillpoint')) = 'charskillpoint') and (check_level(tc.ID, GM_CHARSKILLPOINT)) ) then error_msg := command_charskillpoint(tc, str)
            else if ( (copy(str, 1, length('changes')) = 'changes') and (check_level(tc.ID, GM_CHANGES)) ) then error_msg := command_changes(tc, str)
        end else if gmstyle = '@' then begin
            if ( (copy(str, 1, length('heal')) = 'heal') and (check_level(tc.ID, GM_ATHENA_HEAL)) ) then error_msg := command_athena_heal(tc, str)
            else if ( (copy(str, 1, length('kami')) = 'kami') and (check_level(tc.ID, GM_ATHENA_KAMI)) ) then error_msg := command_athena_kami(tc, str)
            else if ( (copy(str, 1, length('alive')) = 'alive') and (check_level(tc.ID, GM_ATHENA_ALIVE)) ) then error_msg := command_athena_alive(tc)
            else if ( (copy(str, 1, length('kill')) = 'kill') and (check_level(tc.ID, GM_ATHENA_KILL)) ) then error_msg := command_athena_kill(tc, str)
			else if ( (copy(str, 1, length('die')) = 'die') and (check_level(tc.ID, GM_ATHENA_DIE)) ) then error_msg := command_athena_die(tc)
            else if ( (copy(str, 1, length('jobchange')) = 'jobchange') and (check_level(tc.ID, GM_ATHENA_JOBCHANGE)) ) then error_msg := command_athena_jobchange(tc, str)
            else if ( (copy(str, 1, length('hide')) = 'hide') and (check_level(tc.ID, GM_ATHENA_HIDE)) ) then error_msg := command_athena_hide(tc)
            else if ( (copy(str, 1, length('option')) = 'option') and (check_level(tc.ID, GM_ATHENA_OPTION)) ) then error_msg := command_athena_option(tc, str)
            else if ( (copy(str, 1, length('storage')) = 'storage') and (check_level(tc.ID, GM_ATHENA_STORAGE)) ) then error_msg := command_athena_storage(tc)
            else if ( (copy(str, 1, length('speed')) = 'speed') and (check_level(tc.ID, GM_ATHENA_SPEED)) ) then error_msg := command_athena_speed(tc, str)
            else if ( (copy(str, 1, length('who3')) = 'who3') and (check_level(tc.ID, GM_ATHENA_WHO3)) ) then error_msg := command_athena_who3(tc, str)
            else if ( (copy(str, 1, length('who2')) = 'who2') and (check_level(tc.ID, GM_ATHENA_WHO2)) ) then error_msg := command_athena_who2(tc, str)
            else if ( (copy(str, 1, length('who')) = 'who') and (check_level(tc.ID, GM_ATHENA_WHO)) ) then error_msg := command_athena_who(tc, str)
            else if ( (copy(str, 1, length('jumpto')) = 'jumpto') and (check_level(tc.ID, GM_ATHENA_JUMPTO)) ) then error_msg := command_athena_jumpto(tc, str)
            else if ( (copy(str, 1, length('jump')) = 'jump') and (check_level(tc.ID, GM_ATHENA_JUMP)) ) then error_msg := command_athena_jump(tc, str)
            else if ( (copy(str, 1, length('where')) = 'where') and (check_level(tc.ID, GM_ATHENA_WHERE)) ) then error_msg := command_athena_where(tc, str)
            else if ( (copy(str, 1, length('rura+')) = 'rura+') and (check_level(tc.ID, GM_ATHENA_RURAP)) ) then error_msg := command_athena_rurap(tc, str)
            else if ( (copy(str, 1, length('rura')) = 'rura') and (check_level(tc.ID, GM_ATHENA_RURA)) ) then error_msg := command_athena_rura(tc, str)
            else if ( (copy(str, 1, length('warp+')) = 'warp+') and (check_level(tc.ID, GM_ATHENA_WARPP)) ) then error_msg := command_athena_warpp(tc, str)
            else if ( (copy(str, 1, length('warp')) = 'warp') and (check_level(tc.ID, GM_ATHENA_WARP)) ) then error_msg := command_athena_warp(tc, str)
            else if ( (copy(str, 1, length('send')) = 'send') and (check_level(tc.ID, GM_ATHENA_SEND)) ) then error_msg := command_athena_send(tc, str)
            else if ( (copy(str, 1, length('charwarp')) = 'charwarp') and (check_level(tc.ID, GM_ATHENA_CHARWARP)) ) then error_msg := command_athena_charwarp(tc, str)
            else if ( (copy(str, 1, length('help')) = 'help') and (check_level(tc.ID, GM_ATHENA_HELP)) ) then error_msg := command_athena_help(tc)
            else if ( (copy(str, 1, length('zeny')) = 'zeny') and (check_level(tc.ID, GM_ATHENA_ZENY)) ) then error_msg := command_athena_zeny(tc, str)
			else if ( (copy(str, 1, length('baselvlup')) = 'baselvlup') and (check_level(tc.ID, GM_ATHENA_BASELVLUP)) ) then error_msg := command_athena_baselvlup(tc, str)
            else if ( (copy(str, 1, length('lvup')) = 'lvup') and (check_level(tc.ID, GM_ATHENA_LVUP)) ) then error_msg := command_athena_lvup(tc, str)
            else if ( (copy(str, 1, length('joblvlup')) = 'joblvlup') and (check_level(tc.ID, GM_ATHENA_JOBLVLUP)) ) then error_msg := command_athena_joblvlup(tc, str)
            else if ( (copy(str, 1, length('joblvup')) = 'joblvup') and (check_level(tc.ID, GM_ATHENA_JOBLVUP)) ) then error_msg := command_athena_joblvup(tc, str)
            else if ( (copy(str, 1, length('skpoint')) = 'skpoint') and (check_level(tc.ID, GM_ATHENA_SKPOINT)) ) then error_msg := command_athena_skpoint(tc, str)
        end else if gmstyle = '/' then begin
        	if ( (aegistype = 'B') and (Copy(str, 1, length(tc.Name) + 2) = (tc.Name + ': ')) and (not (Copy(str, 1, 4) = 'blue') ) and (check_level(tc. ID, GM_AEGIS_B)) ) then error_msg := command_aegis_b(str)
            else if ( (aegistype = 'B') and (Copy(str, 1, length(tc.Name) + 2) <> (tc.Name + ': ')) and (not (Copy(str, 1, 4) = 'blue') ) and (check_level(tc. ID, GM_AEGIS_NB)) ) then error_msg := command_aegis_nb(str)
            else if ( (aegistype = 'B') and (Copy(str, 1, 4) = 'blue') and (check_level(tc. ID, GM_AEGIS_BB)) ) then error_msg := command_aegis_bb(tc, str)
            else if ( (aegistype = 'S') and (ItemDBName.IndexOf(str) <> -1) and (check_level(tc.ID, GM_AEGIS_ITEM)) ) then error_msg := command_aegis_item(tc, str)
            else if ( (aegistype = 'S') and (MobDBName.IndexOf(str) <> -1) and (check_level(tc.ID, GM_AEGIS_MONSTER)) ) then error_msg := command_aegis_monster(tc, str)
            else if ( (aegistype = 'R') and (StrToInt(str) = 0) and (check_level(tc.ID, GM_AEGIS_RESETSTATE)) ) then error_msg := command_aegis_resetstate(tc, str)
            else if ( (aegistype = 'R') and (StrToInt(str) = 1) and (check_level(tc.ID, GM_AEGIS_RESETSKILL)) ) then error_msg := command_aegis_resetskill(tc, str)
            else if ( (aegistype = 'H') and (check_level(tc.ID, GM_AEGIS_HIDE)) ) then error_msg := command_aegis_hide(tc)
        end;

        if (error_msg <> '') then error_message(tc, error_msg);
        if ( (Option_GM_Logs) and (error_msg <> '') ) then save_gm_log(tc, error_msg);
    end;

    function check_level(id : Integer; cmd : Integer) : Boolean;
    var
        idx : Integer;
        tGM : TGM_Table;
    begin
        Result := False;
        idx := GM_Access_DB.IndexOf(id);

        if (idx <> -1) then begin
            tGM := GM_Access_DB.Objects[idx] as TGM_Table;
            if ( (tGM.ID = id) and (tGM.Level >= cmd) ) then Result := True;
        end else begin
            if (cmd = 0) then Result := True;
        end;
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

            CreateDir('logs');
            logfile.SaveToFile(AppPath + 'logs\GM_COMMANDS-' + filename + '.txt');
        except
            on E : Exception do DebugOut.Lines.Add('[' + TimeToStr(Now) + '] ' + '*** GM Logfile Error : ' + E.Message);
        end;
        logfile.Free;
    end;

    function command_alive(tc : TChara) : String;
    var
        tm : TMap;
    begin
        Result := 'GM_ALIVE Success.';

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

    function command_item(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        td : TItemDB;
        i, j, k : Integer;
    begin
        Result := 'GM_ITEM Success.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 6, 256);

        if sl.Count = 2 then begin
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
    var
        tm : TMap;
    begin
        Result := 'GM_DIE Success.';

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        CharaDie(tm, tc, 1);
    end;

    function command_auto(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        j, k : Integer;
    begin
        Result := 'GM_AUTO Success.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 5, 256);

        if sl.Count = 0 then Exit;
        Val(sl.Strings[0], j, k);
        if (k <> 0) or (j < 0) then Exit;
        tc.Auto := j;

        if sl.Count = 3 then begin
            Val(sl.Strings[1], tc.A_Skill, k);
            Val(sl.Strings[2], tc.A_Lv, k);
        end;

        sl.Free;
    end;

    function command_hcolor(tc : TChara; str : String) : String;
    var
        tm : TMap;
        i, k : Integer;
    begin
        Result := 'GM_HCOLOR Success.';

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        Val(Copy(str, 8, 256), i, k);
        if (k = 0) and (i >= 0) then begin
            tc.HairColor := i;
            UpdateLook(tm, tc, 6, i, 0, true);
        end;
    end;

    function command_ccolor(tc : TChara; str : String) : String;
    var
        tm : TMap;
        i, k : Integer;
    begin
        Result := 'GM_CCOLOR Success.';

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        Val(Copy(str, 8, 256), i, k);
        if (k = 0) and (i >= 0) then begin
            tc.ClothesColor := i;
            UpdateLook(tm, tc, 7, i, 0, true);
        end;
    end;

    function command_hstyle(tc : TChara; str : String) : String;
    var
        tm : TMap;
        i, k : Integer;
    begin
        Result := 'GM_HSTYLE Success.';

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        Val(Copy(str, 8, 256), i, k);
        if (k = 0) and (i >= 0) then begin
            tc.Hair := i;
            UpdateLook(tm, tc, 1, i, 0, true);
        end;
    end;

    function command_kill(str : String) : String;
    var
        s : String;
        tc1 : TChara;
        tm : TMap;
    begin
        Result := 'GM_KILL Success.';

        s := Copy(str, 6, 256);
        if (CharaName.Indexof(s) <> -1) then begin
            tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;

            if (tc1.Login = 2) then begin
                tm := Map.Objects[Map.IndexOf(tc1.Map)] as TMap;
                tc1.HP := 0;
                tc1.Sit := 1;
                SendCStat1(tc1, 0, 5, tc1.HP);

                WFIFOW( 0, $0080);
                WFIFOL( 2, tc1.ID);
                WFIFOB( 6, 1);
                SendBCmd(tm, tc1.Point, 7);

                Result := 'GM_KILL Success. ' + s + ' has been killed.';
            end else begin
                Result := 'GM_KILL Failure. ' + s + ' is not logged in.';
            end;
        end else begin
            Result := 'GM_KILL Failure. ' + s + ' is an invalid character name.';
        end;
    end;

    function command_goto(tc : TChara; str : String) : String;
    var
        s : String;
        tc1 : TChara;
    begin
        Result := 'GM_GOTO Success.';

        s := Copy(str, 6, 256);
        if CharaName.Indexof(s) <> -1 then begin
            tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;
            if (tc.Hidden = false) then SendCLeave(tc, 2);
            tc.tmpMap := tc1.Map;
            tc.Point := tc1.Point;
            MapMove(tc.Socket, tc1.Map, tc1.Point);

            Result := 'GM_GOTO Success. ' + tc.Name + ' warped to ' + s + '.';
        end else begin
            Result := 'GM_GOTO Failure. ' + s + ' is an invalid character name.';
        end;
    end;

    function command_summon(tc : TChara; str : String) : String;
    var
        s : String;
        tc1 : TChara;
    begin
        Result := 'GM_SUMMON Success.';

        s := Copy(str, 8, 256);
        if CharaName.Indexof(s) <> -1 then begin
            Result := 'GM_SUMMON Success. ' + s + ' warped to ' + tc.Name + '.';
            tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;

            if (tc1.Login = 2) then begin
                SendCLeave(tc1, 2);
                tc1.Map := tc.Map;
                tc1.Point := tc.Point;
                MapMove(tc1.Socket, tc.Map, tc.Point);
            end else begin
                tc1.Map := tc.Map;
                tc1.Point := tc.Point;

                Result := Result + ' But ' + s + ' is offline.';
            end;

        end else begin
            Result := 'GM_SUMMON Failure. ' + s + ' is an invalid character name.';
        end;
    end;

    function command_warp(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        i, j, k : Integer;
        ta : TMapList;
    begin
        Result := 'GM_WARP Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 6, 256);

        if sl.Count <> 3 then Exit;
        Val(sl.Strings[1], i, k);

        if k <> 0 then Exit;
        Val(sl.Strings[2], j, k);

        if k <> 0 then Exit;
        if MapList.IndexOf(LowerCase(sl.Strings[0])) = -1 then Exit;

        ta := MapList.Objects[MapList.IndexOf(LowerCase(sl.Strings[0]))] as TMapList;
        if (i < 0) or (i >= ta.Size.X) or (j < 0) or (j >= ta.Size.Y) then Exit;

        if (tc.Hidden = false) then SendCLeave(tc, 2);
        tc.tmpMap := LowerCase(sl.Strings[0]);
        tc.Point := Point(i,j);
        MapMove(tc.Socket, LowerCase(sl.Strings[0]), Point(i,j));

        Result := 'GM_WARP Success. Warp to ' + tc.tmpMap + ' (' + IntToStr(i) + ',' + IntToStr(j) + ').';
        sl.Free;
    end;

    function command_banish(str : String) : String;
    var
        sl : TStringList;
        i, j, k : Integer;
        ta : TMapList;
        tc1 : TChara;
        s : String;
    begin
        Result := 'GM_BANISH Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 8, 256);

        if (sl.Count <> 4) then begin
            Result := Result + ' Missing information.';
            Exit;
        end;

        Val(sl[sl.Count - 2], i, k);
        if k <> 0 then Exit;

        Val(sl[sl.Count - 1], j, k);
        if k <> 0 then Exit;

        if MapList.IndexOf(sl.Strings[sl.Count - 3]) <> -1 then begin
            ta := MapList.Objects[MapList.IndexOf(sl.Strings[sl.Count - 3])] as TMapList;
            if (i < 0) or (i >= ta.Size.X) or (j < 0) or (j >= ta.Size.Y) then Exit;

            for k := 0 to sl.Count - 4 do begin
                s := s + ' ' + sl.Strings[k];
                s := Trim(s);
            end;

            if CharaName.Indexof(s) <> -1 then begin
                tc1 := CharaName.Objects[CharaName.Indexof(s)] as TChara;
                Result := 'GM_BANISH Success. ' + s + ' warped to ' + ta.Name + ' (' + IntToStr(i) + ', ' + IntToStr(j) + ').';

                if (tc1.Login = 2) then begin
                    SendCLeave(tc1, 2);
                    tc1.tmpMap := sl.Strings[sl.Count - 3];
                    tc1.Point := Point(i,j);
                    MapMove(tc1.Socket, tc1.tmpMap, tc1.Point);
                end else begin
                    tc1.Map := sl.Strings[sl.Count - 3];
                    tc1.Point := Point(i,j);
                    Result := Result + ' ' + s + ' is offline.';
                end;
            end else begin
                Result := Result + ' ' + s + ' is an invalid character name.';
            end;
        end else begin
            Result := 'GM_BANISH Failure. ' + sl.Strings[sl.Count - 3] + ' is not a valid map name.';
        end;

        sl.Free;
    end;

    function command_job(tc : TChara; str : String) : String;
    var
        i, j, k : Integer;
        tm : TMap;
    begin
        Result := 'GM_JOB Failure.';

        if (tc.JID <> 0) or ((DebugCMD and $0020) <> 0) then begin
            Val(Copy(str, 5, 256), i, k);
            if (k = 0) and (i >= 0) and (i <= MAX_JOB_NUMBER) and (i <> 13) then begin
                tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;

                // Colus, 20040203: Added unequip of items when you #job
                for  j := 1 to 100 do begin
                    if tc.Item[j].Equip = 32768 then begin
                        tc.Item[j].Equip := 0;
                        WFIFOW(0, $013c);
                        WFIFOW(2, 0);
                        tc.Socket.SendBuf(buf, 4);
                    end else if tc.Item[j].Equip <> 0 then begin
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
                            UpdateIcon(tm, tc, tc.Skill[j].Data.Icon, 0);
                        end;
                    end;
                    tc.Skill[j].Tick := timeGetTime();
                    tc.Skill[j].Effect1 := 0;
                end;

                if (i > LOWER_JOB_END) then begin
                    i := i - LOWER_JOB_END + UPPER_JOB_BEGIN; // 24 - 23 + 4000 = 4001, remort novice
                    tc.ClothesColor := 1; // This is the default clothes palette color for upper classes
                end else begin
                    tc.ClothesColor := 0;
                end;

                tc.JID := i;

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

                Result := 'GM_JOB Success. New Job ID is ' + IntToStr(i) + '.';
            end else begin
                Result := Result + ' Job ID is out of range.';
            end;
        end;
    end;

    function command_blevel(tc : TChara; str : String) : String;
    var
        i, k, w3 : Integer;
        oldlevel : Integer;
    begin
        Result := 'GM_BLEVEL Failure.';

        oldlevel := tc.BaseLV;
        Val(Copy(str, 8, 256), i, k);

        if (k = 0) and (i >= 1) and (i <= 32767) and (i <> tc.BaseLV) then begin
            if tc.BaseLV > i then begin
                tc.BaseLV := i;

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
                tc.BaseLV := i;

                for i := w3 to tc.BaseLV - 1 do begin
                    tc.StatusPoint := tc.StatusPoint + i div 5 + 3;
                end;
            end;

            if (tc.BaseNextEXP = 0) then tc.BaseNextEXP := 999999999;
            tc.BaseEXP := tc.BaseNextEXP - 1;
            tc.BaseNextEXP := ExpTable[0][tc.BaseLV];

            CalcStat(tc);
            SendCStat(tc);
            SendCStat1(tc, 0, $000b, tc.BaseLV);
            SendCStat1(tc, 0, $0009, tc.StatusPoint);
            SendCStat1(tc, 1, $0001, tc.BaseEXP);

            Result := 'GM_BLEVEL Success. level changed from ' + IntToStr(oldlevel) + ' to ' + IntToStr(tc.BaseLV) + '.';
        end else begin
            Result := Result + ' Incomplete information or level out of range.';
        end;
    end;

    function command_jlevel(tc : TChara; str : String) : String;
    var
        i, j, k : Integer;
        oldlevel : Integer;
    begin
        Result := 'GM_JLEVEL Failure.';

        oldlevel := tc.JobLV;
        Val(Copy(str, 8, 256), i, k);

        if (k = 0) and (i >= 1) and (i <= 32767) and (i <> tc.JobLV) then begin
            tc.JobLV := i;

            for i := 1 to MAX_SKILL_NUMBER do begin
                if not tc.Skill[i].Card then tc.Skill[i].Lv := 0;
            end;

            if tc.JID = 0 then tc.SkillPoint := tc.JobLV - 1
            else if tc.JID < 7 then tc.SkillPoint := tc.JobLV - 1 + 9
            else tc.SkillPoint := tc.JobLV - 1 + 49 + 9;

            SendCSkillList(tc);

            if (tc.JobNextEXP = 0) then tc.JobNextEXP := 999999999;
            tc.JobEXP := tc.JobNextEXP - 1;

            if tc.JID < 13 then begin
                j := (tc.JID + 5) div 6 + 1;
            end else begin
                j := 3;
            end;

            tc.JobNextEXP := ExpTable[j][tc.JobLV];

            CalcStat(tc);
            SendCStat(tc);
            SendCStat1(tc, 0, $0037, tc.JobLV);
            SendCStat1(tc, 0, $000c, tc.SkillPoint);
            SendCStat1(tc, 1, $0002, tc.JobEXP);


            Result := 'GM_JLEVEL Success. level changed from ' + IntToStr(oldlevel) + ' to ' + IntToStr(tc.JobLV) + '.';
        end else begin
            Result := Result + ' Incomplete information or level out of range.';
        end;
    end;

    function command_changestat(tc : TChara; str : String) : String;
    var
        sl : TStringList;
        i, j, k : Integer;
    begin
        Result := 'GM_CHANGESTAT Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 12, 256);

        if (sl.Count = 2) then begin
            Val(sl[0], i, k);

            if(i >= 0) and (i <= 5) then begin
                Val(sl[1], j, k);

                if(j >= 1) and (j <= 32767) then begin
                    tc.ParamBase[i] := j;
                    CalcStat(tc);
                    SendCStat(tc);
                    SendCStat1(tc, 0, $0009, tc.StatusPoint);

                    Result := 'GM_CHANGESTAT Success. Stat ' + IntToStr(i) + ' changed to ' + IntToStr(j) + '.';
                end;
            end else begin
                Result := Result + ' Incorrect stat index number.';
            end;
        end else begin
            Result := Result + ' Incomplete information.';
        end;

        sl.Free;
    end;

    function command_skillpoint(tc : TChara; str : String) : String;
    var
        i, k : Integer;
    begin
        Result := 'GM_SKILLPOINT Failure.';

        Val(Copy(str, 12, 256), i, k);
        if (k = 0) and (i >= 0) and (i <= 1001) then begin
            tc.SkillPoint := i;
            SendCStat1(tc, 0, $000c, tc.SkillPoint);
            Result := 'GM_SKILLPOINT Sucess. Skill Point amount set to ' + IntToStr(i) + '.';
        end else begin
            Result := Result + ' Skill Point amount out of range [0-1001].';
        end;
    end;

    function command_skillall(tc : TChara) : String;
    var
        j, i : Integer;
    begin
        Result := 'GM_SKILLALL Failure.';

        j := tc.JID;
        if (j > UPPER_JOB_BEGIN) then j := j - UPPER_JOB_BEGIN + LOWER_JOB_END;
        // (RN 4001 - 4000 + 23 = 24)

        for i := 1 to 157 do begin
            if (tc.Skill[i].Data.Job1[j]) or (tc.Skill[i].Data.Job2[j]) then begin
                tc.Skill[i].Lv := tc.Skill[i].Data.MasterLV;
            end;
        end;

        for i := 210 to MAX_SKILL_NUMBER do begin
            if (tc.Skill[i].Data.Job1[j]) or (tc.Skill[i].Data.Job2[j]) then begin
                tc.Skill[i].Lv := tc.Skill[i].Data.MasterLV;
            end;
        end;

        tc.SkillPoint := 1000;
        SendCSkillList(tc);
        CalcStat(tc);
        SendCStat(tc);

        Result := 'GM_SKILLALL Success.';
    end;

    function command_statall(tc : TChara) : String;
    var
        i : Integer;
    begin
        Result := 'GM_STATALL Failure.';

        for i := 0 to 5 do begin
            tc.ParamBase[i] := 99;
        end;

        tc.StatusPoint := 1000;
        CalcStat(tc);
        SendCStat(tc);
        SendCStat1(tc, 0, $0009, tc.StatusPoint);

        Result := 'GM_STATALL Success.';
    end;

    function command_superstats(tc : TChara) : String;
    var
        i : Integer;
    begin
        Result := 'GM_SUPERSTATS Failure.';

        for i := 0 to 5 do begin
            tc.ParamBase[i] := 32767;
        end;

        tc.StatusPoint := 1000;
        CalcStat(tc);
        SendCStat(tc);
        SendCStat1(tc, 0, $0009, tc.StatusPoint);

        Result := 'GM_SUPERSTATS Success.';
    end;

    function command_zeny(tc : TChara; str : String) : String;
    var
        i, k : Integer;
    begin
        Result := 'GM_ZENY Failure.';

        Val(Copy(str, 6, 256), i, k);
        if (k = 0) and (i >= -2147483647) and (i <= 2147483647) then begin
            if (tc.Zeny + i <= 2147483647) and (tc.Zeny + i >= 0) then begin
                tc.Zeny := tc.Zeny + i;
                SendCStat1(tc, 1, $0014, tc.Zeny);

                Result := 'GM_ZENY Success. ' + IntToStr(abs(i)) + ' Zeny';
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

    function command_changeskill(tc : TChara; str : String) : String;
    var
        i, j, k : Integer;
        sl : TStringList;
    begin
        Result := 'GM_CHANGESKILL Failure.';

        sl := TStringList.Create;
        sl.DelimitedText := Copy(str, 13, 256);

        if (sl.Count = 2) then begin
            Val(sl.Strings[0], i, k);
            if k <> 0 then Exit;
            Val(sl.Strings[1], j, k);
            if k <> 0 then Exit;

            if ((i >= 1) and (i <= 157)) or ((i >= 210) and (i <= MAX_SKILL_NUMBER)) then begin
                if (j > tc.Skill[i].Data.MasterLV) then j := tc.Skill[i].Data.MasterLV;
                tc.Plag := i;
                tc.PLv := j;
                tc.Skill[i].Plag := true;
                SendCSkillList(tc);
                CalcStat(tc);
                SendCStat(tc);

                Result := 'GM_CHANGESKILL Success. Skill ' + IntToStr(i) + ' set to ' + IntToStr(j) + '.';
            end else begin
                Result := Result + ' Skill selection out of range [1-157,210-' + IntToStr(MAX_SKILL_NUMBER) + '].';
            end;
        end else begin
            Result := Result + ' Incomplete information.';
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
        i, j : Integer;
        tm : TMap;
        tc1 : TChara;
    begin
        Result := 'GM_MOTHBALL Success.';

        if tc.Stat2 = 16 then begin
            Result := Result + ' Command deactivated.';
            j := 0;
        end else begin
            Result := Result + ' Command activated.';
            j := 16;
        end;

        tm := Map.Objects[Map.IndexOf(tc.Map)] as TMap;
        for i := 0 to charaname.count - 1 do begin
            tc1 := charaname.objects[i] as tchara;
            if (tc1.login = 2) then begin
                WFIFOW(0, $0119);
                WFIFOL(2, tc1.ID);
                WFIFOW(6, 0);
                WFIFOW(8, j);
                WFIFOW(10, 0);
                WFIFOB(12, 0);
                SendBCmd(tm, tc1.Point, 13);
                tc.Stat2 := j;
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

            if tp1.Banned = 0 then begin
                Result := Result + ' ' + tc1.Name + ' has been banned.';
                tp1.Banned := 1;
            end else begin
                Result := Result + ' ' + tc1.Name + ' has been un-banned.';
                tp1.Banned := 0;
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

        if MapInfo.IndexOf(tc.Map) <> -1 then begin;
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
        tp1, tp2 : TPlayer;
        i, Idx : Integer;
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

    	    	for i := 0 to PlayerName.Count - 1 do begin
	            	tp2 := PlayerName.Objects[i] as TPlayer;
                	if (tp2.ID <> i + 100101) and (tp2.ID > 100100) then begin
            	    	Idx := i + 100101;
        	            Break;
    	            end;
	            end;

            	if (i = PlayerName.Count) then Idx := 100101 + PlayerName.Count;

                tp1 := TPlayer.Create;
                tp1.ID := Idx;
                tp1.Name := sl.Strings[0];
                tp1.Pass := sl.Strings[1];
                tp1.Mail := sl.Strings[3];
                tp1.Gender := StrToInt(sl.Strings[2]);
                tp1.Banned := 0;
                tp1.ver2 := 9;

                PlayerName.InsertObject(i, tp1.Name, tp1);
                Player.AddObject(tp1.ID, tp1);

                Result := 'GM_NEWPLAYER Success. ' + tp1.Name + ' has been added successfully.';
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
                    tc1.BaseNextEXP := ExpTable[0][tc1.BaseLV];

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

                    if tc1.JID < 13 then begin
                        w3 := (tc1.JID + 5) div 6 + 1;
                    end else begin
                        w3 := 3;
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

            if (i > LOWER_JOB_END) then begin
                i := i - LOWER_JOB_END + UPPER_JOB_BEGIN; // 24 - 23 + 4000 = 4001, remort novice
                tc.ClothesColor := 1; // This is the default clothes palette color for upper classes
            end else begin
                tc.ClothesColor := 0; // Reset the clothes color to the default value.
            end;

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

    function command_athena_who3(tc : Tchara; str : String) : String;
    var
        tc1 : TChara;
        i, w : Integer;
    begin
        Result := 'GM_ATHENA_WHO3 Success.';
        for i := 0 to CharaName.Count - 1 do begin
            tc1 := CharaName.Objects[i] as TChara;
            if tc1.Login = 2 then begin
                str := 'Name: ' + tc1.Name + ' -- Party: ' + tc1.PartyName + ' -- Guild: ' + tc1.GuildName;
                w := Length(str) + 4;
                WFIFOW (0, $009a);
                WFIFOW (2, w);
                WFIFOS (4, str, w - 4);
                tc.socket.sendbuf(buf, w);
            end;
        end;
    end;

    function command_athena_who2(tc : TChara; str : String) : String;
    var
        tc1 : TChara;
        i, w : Integer;
    begin
        Result := 'GM_ATHENA_WHO2 Success.';
        for i := 0 to CharaName.Count - 1 do begin
            tc1 := CharaName.Objects[i] as TChara;
            if tc1.Login = 2 then begin

                if tc1.JID = 0 then str :='Novice' else
                if tc1.JID = 1 then str :='Swordsman' else
                if tc1.JID = 2 then str :='Mage' else
                if tc1.JID = 3 then str :='Archer' else
                if tc1.JID = 4 then str :='Acolyte' else
                if tc1.JID = 5 then str :='Merchant' else
                if tc1.JID = 6 then str :='Thief' else
                if tc1.JID = 7 then str :='Knight' else
                if tc1.JID = 8 then str :='Priest' else
                if tc1.JID = 9 then str :='Wizard' else
                if tc1.JID = 10 then str :='Blacksmith' else
                if tc1.JID = 11 then str :='Hunter' else
                if tc1.JID = 12 then str :='Assassin' else
                if tc1.JID = 13 then str :='Knight 2' else
                if tc1.JID = 14 then str :='Crusader' else
                if tc1.JID = 15 then str :='Monk' else
                if tc1.JID = 16 then str :='Sage' else
                if tc1.JID = 17 then str :='Rogue' else
                if tc1.JID = 18 then str :='Alchemist' else
                if tc1.JID = 19 then str :='Bard' else
                if tc1.JID = 20 then str :='Dancer' else
                if tc1.JID = 21 then str :='Crusader 2' else
                if tc1.JID = 22 then str :='Wedding' else
                if tc1.JID = 23 then str :='Super Novice' else
                str := 'Unknown Class';

                str := 'Name: ' + tc1.Name + ' -- Job: ' + str + ' -- Base Level:  ' + inttostr(tc1.baselv) + ' -- Job Level: ' + inttostr(tc1.joblv);
                w := Length(str) + 4;
                WFIFOW (0, $009a);
                WFIFOW (2, w);
                WFIFOS (4, str, w - 4);
                tc.socket.sendbuf(buf, w);
            end;
        end;
    end;

    function command_athena_who(tc : Tchara; str : String) : String;
    var
        tc1 : TChara;
        i, w : Integer;
    begin
        Result := 'GM_ATHENA_WHO Success.';
        for i := 0 to CharaName.Count - 1 do begin
            tc1 := CharaName.Objects[i] as TChara;
            if tc1.Login = 2 then begin
                str := 'Name: ' + tc1.Name + ' -- Location: ' + tc1.map + ' ' + inttostr(tc1.point.x) + ' ' + inttostr(tc1.point.y);
                w := Length(str) + 4;
                WFIFOW (0, $009a);
                WFIFOW (2, w);
                WFIFOS (4, str, w - 4);
                tc.socket.sendbuf(buf, w);
            end;
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
        sl : TStringList;
        str2 : String;
        tc1 : TChara;
        i, w : Integer;
    begin
        Result := 'GM_ATHENA_WHERE Failure.';
        sl := tstringlist.Create;
        sl.DelimitedText := str;

        if sl.count < 2 then Exit;

        str2 := '';
        for i := 1 to (sl.Count - 1) do begin
            str2 := str2 + ' ' + sl.Strings[i];
        end;
        str2 := Trim(str2);

        if (CharaName.Indexof(str2) <> -1) then begin
            tc1 := charaname.objects[charaname.indexof(str2)] as tchara;
            str := tc1.Name + ' located at ' + tc1.map + ' ' + inttostr(tc1.point.x) + ' ' + inttostr(tc1.point.y);

            w := Length(str) + 4;
            WFIFOW (0, $009a);
            WFIFOW (2, w);
            WFIFOS (4, str, w - 4);
            tc.socket.sendbuf(buf, w);

            Result := 'GM_ATHENA_WHERE Success.';
        end;

        sl.Free;
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

    function command_athena_help(tc : TChara) : String;
    var
	    Help : TStringList;
	    Idx  : Integer;
	    J    : Integer;
	    Len  : Integer;
    begin
    	Result := 'GM_ATHENA_HELP Failure.';

	    Help := TStringList.Create;
	    try
		    try
			    Help.LoadFromFile( AppPath + 'help.txt' );
		    except
			    on EFOpenError do begin
				    Result := Result + ' No help file found.';
			    end;
		    end;//try-except

		    if Help.Count > 0 then begin
			    Idx := Help.Count;
			    J := 0;
			    WFIFOS(4, '', 400);//pre-wipe the buffer used for 200 bytes.
                // Broadcast style MOTD - 4 lines max, 195 char each
				repeat
					Len := Length(Help[J]);
					if Len > 195 then Help[J] := Copy(Help[J],1,195);
					WFIFOW(0, $009a);
					WFIFOS(4, Help[J], Len+1);//Len+1 -> adds null termination
					Inc(J);
					tc.Socket.SendBuf(buf, 200);

                    Result := 'GM_ATHENA_HELP Success.';
				until (J >= Idx);
		    end;//if
	    finally
		    Help.Free;
	    end;
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
            tc.BaseNextEXP := ExpTable[0][tc.BaseLV];

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
            tc.BaseNextEXP := ExpTable[0][tc.BaseLV];

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

            if tc.JID < 13 then begin
                w3 := (tc.JID + 5) div 6 + 1;
            end else begin
                w3 := 3;
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

            if tc.JID < 13 then begin
                w3 := (tc.JID + 5) div 6 + 1;
            end else begin
                w3 := 3;
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
                    tc.BaseLV := 1001;
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
end.
