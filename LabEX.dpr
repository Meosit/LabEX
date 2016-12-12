program LabEX;

uses
  Forms,
  Main in 'Main.pas' {Main},
  Logics in 'Logics.pas',
  List in 'List.pas' {List},
  Editor in 'Editor.pas' {Editor},
  Size in 'Size.pas' {Size},
  MazeLogics in 'MazeLogics.pas',
  Game in 'Game.pas' {GameForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TGameForm, GameForm);
  Application.Run;
end.
