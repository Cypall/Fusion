program Weiss;

{$R 'manifest.res' 'manifest.rc'}

uses
  madExcept,
  madLinkDisAsm,
  Forms,
  Main in 'Main.pas' {frmMain},
  List32 in '..\lib\List32.pas',
  Common in 'Common.pas',
  Path in 'Path.pas',
  Login in 'Login.pas',
  CharaSel in 'CharaSel.pas',
  Game in 'Game.pas',
  Database in 'Database.pas',
  Script in 'Script.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'The Fusion Project';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
