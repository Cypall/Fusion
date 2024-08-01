program Weiss;

{$R 'manifest.res' 'manifest.rc'}

uses
  {$IFDEF MSWINDOWS}
  madExcept,
  Forms,

  Main in 'CORE\Main.pas' {frmMain},
  Common in 'CORE\Common.pas',
  Globals in 'CORE\Globals.pas',

  Login in 'ZONE\Login.pas',
  CharaSel in 'ZONE\CharaSel.pas',
  Game in 'ZONE\Game.pas',

  Database in 'DATABASE\Database.pas',
  PlayerData in 'DATABASE\PlayerData.pas',
  REED_Support in 'DATABASE\REED_Support.pas',
  REED_LOAD_ACCOUNTS in 'DATABASE\REED_LOAD_ACCOUNTS.pas',
  REED_LOAD_CHARACTERS in 'DATABASE\REED_LOAD_CHARACTERS.pas',
  REED_LOAD_PETS in 'DATABASE\REED_LOAD_PETS.pas',
  REED_LOAD_PARTIES in 'DATABASE\REED_LOAD_PARTIES.pas',
  REED_LOAD_GUILDS in 'DATABASE\REED_LOAD_GUILDS.pas',
  REED_LOAD_CASTLES in 'DATABASE\REED_LOAD_CASTLES.pas',
  REED_SAVE_ACCOUNTS in 'DATABASE\REED_SAVE_ACCOUNTS.pas',
  REED_SAVE_CHARACTERS in 'DATABASE\REED_SAVE_CHARACTERS.pas',
  REED_SAVE_PETS in 'DATABASE\REED_SAVE_PETS.pas',
  REED_SAVE_PARTIES in 'DATABASE\REED_SAVE_PARTIES.pas',
  REED_SAVE_GUILDS in 'DATABASE\REED_SAVE_GUILDS.pas',
  REED_SAVE_CASTLES in 'DATABASE\REED_SAVE_CASTLES.pas',
  REED_DELETE in 'DATABASE\REED_DELETE.pas',
  
  FusionSQL in 'SQL\FusionSQL.pas',
  SQLData in 'SQL\SQLData.pas',

  MonsterAI in 'AI\MonsterAI.pas',
  Path in 'AI\Path.pas',

  Game_Master in 'FEATURES\Game_Master.pas',
  JCon in 'FEATURES\JCon.pas',
  Player_Skills in 'FEATURES\Player_Skills.pas',
  WeissINI in 'FEATURES\WeissINI.pas',
  ISCS in 'FEATURES\ISCS.pas',
  WAC in 'FEATURES\WAC.pas',

  GlobalLists in 'OLD\GlobalLists.pas',
  Manifest in 'OLD\Manifest.pas',
  PacketProcesses in 'OLD\PacketProcesses.pas',
  Script in 'OLD\Script.pas',
  Skills in 'OLD\Skills.pas',
  Skill_Constants in 'OLD\Skill_Constants.pas',
  TrimStr in 'OLD\TrimStr.pas',

  Zip in '3RDPARTY\Zip.pas',
  ZipDlls in '3RDPARTY\ZipDlls.pas',
  List32 in '3RDPARTY\List32.pas',
  SlyIrc in '3RDPARTY\SlyIrc.pas',
  Response in '3RDPARTY\Response.pas',
  WSocket in '3RDPARTY\WSocket.pas',
  WSockBuf in '3RDPARTY\WSockBuf.pas',
  BRSHttpSrv in '3RDPARTY\BRSHttpSrv.pas';
  {$ENDIF}

  {$IFDEF LINUX}
  QForms,

  Main in 'CORE/Main.pas' {frmMain},
  Common in 'CORE/Common.pas',
  Globals in 'CORE/Globals.pas',

  Login in 'ZONE/Login.pas',
  CharaSel in 'ZONE/CharaSel.pas',
  Game in 'ZONE/Game.pas',

  Database in 'DATABASE/Database.pas',
  PlayerData in 'DATABASE/PlayerData.pas',

  FusionSQL in 'SQL/FusionSQL.pas',
  SQLData in 'SQL/SQLData.pas',

  MonsterAI in 'AI/MonsterAI.pas',
  Path in 'AI/Path.pas',

  Game_Master in 'FEATURES/Game_Master.pas',
  JCon in 'FEATURES/JCon.pas',
  Player_Skills in 'FEATURES/Player_Skills.pas',
  WeissINI in 'FEATURES/WeissINI.pas',
  ISCS in 'FEATURES/ISCS.pas',

  GlobalLists in 'OLD/GlobalLists.pas',
  Manifest in 'OLD/Manifest.pas',
  PacketProcesses in 'OLD/PacketProcesses.pas',
  Script in 'OLD/Script.pas',
  Skills in 'OLD/Skills.pas',
  Skill_Constants in 'OLD/Skill_Constants.pas',
  TrimStr in 'OLD/TrimStr.pas',

  Zip in '3RDPARTY/Zip.pas',
  ZipDlls in '3RDPARTY/ZipDlls.pas',
  List32 in '3RDPARTY/List32.pas';
  SlyIrc in '3RDPARTY/SlyIrc.pas',
  Response in '3RDPARTY/Response.pas',
  WSocket in '3RDPARTY/WSocket.pas',
  WSockBuf in '3RDPARTY/WSockBuf.pas';
  {$ENDIF}

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Fusion Server Software';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
