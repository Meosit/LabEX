unit List;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids;

type
  TListForm = class(TForm)
    List: TStringGrid;
    New: TButton;
    Game: TButton;
    Edit: TButton;
    Back: TButton;
    Delete: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BackClick(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure ListSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure GameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ListForm: TListForm = nil;
  Mode: Boolean;

implementation

uses
  Main, Size, Logics, MazeLogics;

{$R *.dfm}

var
  Row: Integer;

procedure TListForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with ListForm do
  begin
    New.Visible:= True;
    Edit.Visible:= True;
    Delete.Visible:= True;
    Game.Visible:= False;
  end;
  MainForm.Show;
end;

procedure TListForm.BackClick(Sender: TObject);
begin
  ListForm.Close;
  with ListForm do
  begin
    New.Visible:= True;
    Edit.Visible:= True;
    Delete.Visible:= True;
    Game.Visible:= False;
  end;
  MainForm.Show;
end;

procedure TListForm.NewClick(Sender: TObject);
begin
  SizeForm:= TSizeForm.Create(Self);
  SizeForm.Top:= Round(Screen.Height/2 - SizeForm.Height/2);
  SizeForm.Left:= Round(Screen.Width/2 - SizeForm.Width/2);
  SizeForm.ShowModal;
end;

procedure TListForm.FormHide(Sender: TObject);
var
  myRect: TGridRect;
begin
  Game.Enabled:= False;
  Edit.Enabled:= False;
  Delete.Enabled:= False;
end;

procedure TListForm.ListSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if List.Cells[ACol,ARow] <> '' then
  begin
    Game.Enabled:= True;
    Edit.Enabled:= True;
    Delete.Enabled:= True;
  end
  else
  begin
    Game.Enabled:= False;
    Edit.Enabled:= False;
    Delete.Enabled:= False;
  end;
  Row:= ARow;
end;

procedure TListForm.FormShow(Sender: TObject);
begin
  PrintList(MazeList);
end;

procedure TListForm.DeleteClick(Sender: TObject);
begin
  DeleteMaze(Row, MazeList);
  PrintList(MazeList);
end;

procedure TListForm.EditClick(Sender: TObject);
var
  name: string[64];
begin
  name:= ListForm.List.Cells[0,Row];
  CreateEditorForm(name);
end;

procedure TListForm.GameClick(Sender: TObject);
var
  name: string[64];
begin
  name:= ListForm.List.Cells[0,Row];
  CreateGameForm(name);
end;

procedure TListForm.FormCreate(Sender: TObject);
begin
  with List do
  begin
    ColWidths[0]:= 300;
    ColWidths[1]:= 100;
    ColWidths[2]:= 100;
  end;
end;

end.
