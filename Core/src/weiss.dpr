program Weiss;

{$R 'manifest.res' 'manifest.rc'}

uses
  madExcept,
  Forms,
  Main in 'Main.pas' {frmMain},
  List32 in '..\lib\List32.pas',
  Common in 'Common.pas',
  Path in 'Path.pas',
  Login in 'Login.pas',
  CharaSel in 'CharaSel.pas',
  Game in 'Game.pas',
  Database in 'Database.pas',
  Script in 'Script.pas',
  Skills in 'Skills.pas',
  WeissINI in 'WeissINI.pas',
  JCon in 'JCon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'The Fusion Project';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
