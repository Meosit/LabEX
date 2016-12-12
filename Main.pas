unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TMainForm = class(TForm)
    Logo: TImage;
    Footer: TImage;
    ADD: TBitBtn;
    LIST: TBitBtn;
    GAME: TBitBtn;
    EXIT: TButton;
    procedure FormPaint(Sender: TObject);
    procedure ADDClick(Sender: TObject);
    procedure GAMEClick(Sender: TObject);
    procedure LISTClick(Sender: TObject);
    procedure EXITClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  OpenFromMain: Boolean;

implementation

uses List, Logics;

{$R *.dfm}

procedure TMainForm.FormPaint(Sender: TObject);
var
  i: Byte;
const
  d  = 6;
  x1 = 100-d;
  y1 = 174-d;
  x2 = 300+d;
  y2 = 234+d;
begin
  with MainForm.Canvas do
  begin
    Brush.Color:= $80CAD9;
    Pen.Color:= 0;
    for i:= 0 to 2 do
    begin
      RoundRect(x1,y1+80*i,x2,y2+80*i,7,7);
    end;
    MainForm.Canvas.RoundRect(EXIT.Left-4,EXIT.Top-4,EXIT.Left+EXIT.Width+4,EXIT.Top+EXIT.Height+4,7,7);
    //Brush.Color:= clSilver;
    //FloodFill(50,200,Pixels[50,200],fsSurface);
  end;
end;


procedure TMainForm.ADDClick(Sender: TObject);
begin
  editMode:= True;
  OpenFromMain:= True;
  if ListForm = nil then ListForm:=TListForm.Create(Self);
  MainForm.Hide;
  ListForm.New.Click;
end;

procedure TMainForm.GAMEClick(Sender: TObject);
begin
  editMode:= False;
  if ListForm = nil then ListForm:=TListForm.Create(Self);
  ListForm.Top:= Round(Screen.Height/2 - ListForm.Height/2);
  ListForm.Left:= Round(Screen.Width/2 - ListForm.Width/2);
  with ListForm do
  begin
    New.Visible:= False;
    Edit.Visible:= False;
    Delete.Visible:= False;
    Game.Visible:= True;
  end;
  Mode:= False;
  MainForm.Hide;
  ListForm.Show;
end;

procedure TMainForm.LISTClick(Sender: TObject);
begin
  editMode:= True;
  OpenFromMain:= False;
  if ListForm = nil then ListForm:=TListForm.Create(Self);
  ListForm.Top:= Round(Screen.Height/2 - ListForm.Height/2);
  ListForm.Left:= Round(Screen.Width/2 - ListForm.Width/2);
  Mode:= True;
  MainForm.Hide;
  ListForm.Show;
end;

procedure TMainForm.EXITClick(Sender: TObject);
begin
  MainForm.Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  MainForm.Top:= Round(Screen.Height/2 - MainForm.Height/2);
  MainForm.Left:= Round(Screen.Width/2 - MainForm.Width/2);
end;

end.
