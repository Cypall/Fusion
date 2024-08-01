unit PlayerData;

interface

uses
    {Windows VCL}
    {$IFDEF MSWINDOWS}
    Windows, MMSystem, Forms,
    {$ENDIF}
    {Kylix/Delphi CLX}
    {$IFDEF LINUX}
    Qt, QForms, Types,
    {$ENDIF}
    {Shared}
    Classes, SysUtils, IniFiles,
    {Fusion}
    Common, REED_Support,
    REED_LOAD_ACCOUNTS,
    REED_LOAD_CHARACTERS,
    REED_LOAD_PETS,
    REED_LOAD_PARTIES,
    REED_LOAD_GUILDS,
    REED_LOAD_CASTLES,
    REED_SAVE_ACCOUNTS,
    REED_SAVE_CHARACTERS,
    REED_SAVE_PETS,
    REED_SAVE_PARTIES,
    REED_SAVE_GUILDS,
    REED_SAVE_CASTLES;

    { Parsers }
    procedure PD_PlayerData_Load(UID : String = '*');
    procedure PD_PlayerData_Save(forced : Boolean = False);

    { Create Basic Structure }
    procedure PD_Create_Structure();


implementation

uses
	Game_Master, GlobalLists, Zip, TrimStr, Database;


    { -------------------------------------------------------------------------------- }
    { -- Parsers --------------------------------------------------------------------- }
    { -------------------------------------------------------------------------------- }
    procedure PD_PlayerData_Load(UID : String = '*');
    var
        tp : TPlayer;
    begin
        PD_Create_Structure();

        if UID <> '*' then begin
            if PlayerName.IndexOf(UID) = -1 then Exit;
            tp := PlayerName.Objects[PlayerName.IndexOf(UID)] as TPlayer;
            UID := IntToStr(tp.ID);
        end;

        if UID = '*' then debugout.Lines.add('­ Account / Character / Pet Linkages ­');
    	PD_Load_Accounts(UID);

        //if UID = '*' then debugout.Lines.add('­ Characters ­');
        //PD_Load_Characters_Parse(UID);

        //if UID = '*' then debugout.Lines.add('­ Pets ­');
        //PD_Load_Pets_Parse(UID);

        if UID = '*' then debugout.Lines.add('­ Parties ­');
        PD_Load_Parties_Pre_Parse(UID);

        if UID = '*' then debugout.Lines.add('­ Guilds ­');
        PD_Load_Guilds_Pre_Parse(UID);

        if UID = '*' then debugout.Lines.add('­ Castles ­');
        PD_Load_Castles_Pre_Parse(UID);
    end;

    procedure PD_PlayerData_Save(forced : Boolean = False);
    begin
        PD_Create_Structure();

        if (forced) then debugout.lines.add('Initiating Comprehensive Save .. Please Wait.');

        PD_Save_Accounts_Parse(forced);
        PD_Save_Characters_Parse(forced);
        PD_Save_Pets_Parse(forced);
        PD_Save_Parties_Parse(forced);
        PD_Save_Guilds_Parse(forced);
        PD_Save_Castles_Parse(forced);

        if (forced) then debugout.lines.add('Comprehensive Save Completed.');
    end;


    { -------------------------------------------------------------------------------- }
    { -- Create Structure ------------------------------------------------------------ }
    { -------------------------------------------------------------------------------- }
    procedure PD_Create_Structure();
    begin
        CreateDir(AppPath + 'gamedata');
        CreateDir(AppPath + 'gamedata\Accounts');
        CreateDir(AppPath + 'gamedata\Parties');
        CreateDir(AppPath + 'gamedata\Guilds');
        CreateDir(AppPath + 'gamedata\Castles');
    end;

end.

