unit Editor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Logics, Grids, StdCtrls, ExtCtrls, Mask, Buttons, MazeLogics;

type
  TEditorForm = class(TForm)
    Maze: TStringGrid;
    EditMode: TGroupBox;
    PassIcon: TImage;
    BorderIcon: TImage;
    cX: TLabel;
    cY: TLabel;
    GENERATE: TButton;
    SAVE: TButton;
    BACK: TButton;
    Mode: TRadioGroup;
    Tool: TRadioGroup;
    SETSTART: TSpeedButton;
    CANCEL: TButton;
    procedure BACKClick(Sender: TObject);
    procedure MazeDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SAVEClick(Sender: TObject);
    procedure MazeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MazeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MazeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ModeClick(Sender: TObject);
    procedure SETSTARTClick(Sender: TObject);
    procedure GENERATEClick(Sender: TObject);
    procedure MazeExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CANCELClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditorForm: TEditorForm = nil;

implementation

uses
  List, Main;

{$R *.dfm}
var
  tRow, tCol, tSX, tSY: Integer;
  Pass: Boolean;

procedure TEditorForm.BACKClick(Sender: TObject);
begin
  EditorForm.Close;
end;

procedure TEditorForm.MazeDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);  // отрисовка €чеек
begin
  if EditorForm.Maze.Cells[ACol, ARow] = '0' then
  begin
    EditorForm.Maze.Canvas.Brush.Color:= clBlack;
    EditorForm.Maze.Canvas.FillRect(Rect);
  end;
  if EditorForm.Maze.Cells[ACol, ARow] = '1' then
  begin
    EditorForm.Maze.Canvas.Brush.Color:= clYellow;
    EditorForm.Maze.Canvas.FillRect(Rect);
  end;
  if EditorForm.Maze.Cells[ACol, ARow] = '-1' then
  begin
    EditorForm.Maze.Canvas.Brush.Color:= clRed;
    EditorForm.Maze.Canvas.FillRect(Rect);
  end;
end;

procedure TEditorForm.SAVEClick(Sender: TObject);
begin                                  // сохранение
  SaveMazeToFile(mazePOINT,tempMaze);
  tSX:= mazePOINT^.Start.X;
  tSY:= mazePOINT^.Start.Y;
  SETSTART.Down:= False;
end;

procedure TEditorForm.MazeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Maze.MouseToCell(x,y,tCol,tRow);
  if Mode.ItemIndex = 1 then
  begin
    Pass:= True;
  end
  else
  begin
    Pass:= False;
  end;
  isSaved:= False;
end;

procedure TEditorForm.MazeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var                                      // рисование област€ми
  row, col, i, j: Integer;
begin
  if X > Maze.Width - 4 then X:= Maze.Width - 4;
  if X < 4 then X:= 4;
  if Y > Maze.Height - 4 then Y:= Maze.Height - 4;
  if Y < 4 then Y:= 4;
  Maze.MouseToCell(x,y,col,row);
  if col < tCol then
  begin
    i:= col;
    col:= tCol;
    tCol:= i;
  end;
  if row < tRow then
  begin
    i:= row;
    row:= tRow;
    tRow:= i;
  end;
  if (Tool.ItemIndex = 1) and not SETSTART.Down then
  begin
    if Pass then
    begin
      for i:= tCol to col do
      begin
        for j:= tRow to row do
        begin
          Maze.Cells[i,j]:= '1';
          tempMaze[j+1,i+1]:= 1;
          isSaved:= False;
        end;
      end;
    end
    else
    begin
      for i:= tCol to col do
      begin
        for j:= tRow to row do
        begin
          Maze.Cells[i,j]:= '0';
          tempMaze[j+1,i+1]:= 0;
        end;
      end;
    end;
  end
  else
  begin
    if SETSTART.Down and                      // установка начальной точки
      (Maze.Cells[col,row] <> '0') and
      (col in [1..Maze.ColCount-1]) and
      (row in [1..Maze.RowCount-1])
    then
    begin
      Maze.Cells[mazePOINT.Start.X-1,mazePOINT.Start.Y-1]:= '1';
      tempMaze[mazePOINT.Start.Y,mazePOINT.Start.X]:= 1;
      mazePOINT.Start.X:= col+1;
      mazePOINT.Start.Y:= row+1;
      Maze.Cells[col,row]:= '-1';
      tempMaze[row+1,col+1]:= -1;
      SETSTART.Down:= False;
      SETSTART.Caption:= '”становить начальную точку';
    end;
  end;
  Maze.Cells[mazePOINT^.Start.X-1,mazePOINT^.Start.Y-1]:= '-1';
end;

procedure TEditorForm.MazeMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);                           // обычное рисование
var
  row, col: Integer;
begin
  if X > Maze.Width - 4 then X:= Maze.Width - 4;
  if X < 4 then X:= 4;
  if Y > Maze.Height - 4 then Y:= Maze.Height - 4;
  if Y < 4 then Y:= 4;
  Maze.MouseToCell(x,y,col,row);
  cX.Caption:= 'X: ' + IntToStr(col+1);
  cY.Caption:= 'Y: ' + IntToStr(row+1);
  if Tool.ItemIndex = 0 then
  begin
    if ssLeft in Shift then
    begin
      if Pass then
      begin
        Maze.Cells[col,row]:= '1';
        tempMaze[row+1,col+1]:= 1;
        isSaved:= False;
      end
      else
      begin
        Maze.Cells[col,row]:= '0';
        tempMaze[row+1,col+1]:= 0;
        isSaved:= False;
      end;
    end;
  end;
end;

procedure TEditorForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);               // страховка от потери данных
var
  answer: Integer;
begin
  if not isSaved then
  begin
    answer:= MessageDLG('»зменени€ не были сохранены. Cохранить?',mtWarning,mbYesNoCancel,0);
    if answer = mrYes then
    begin
      SaveMazeToFile(mazePOINT,tempMaze);
      CanClose:= True;
    end;
    if answer = mrNo then CanClose:= True;
    if answer = mrCancel then CanClose:= False;
  end;
  if CanClose then
  begin
    if (mazePOINT^.Start.Y > 0) and (mazePOINT^.Start.X > 0) then
    tempMaze[mazePOINT^.Start.Y,mazePOINT^.Start.X]:= 1;
    isSaved:= True;
    if OpenFromMain then
    begin
      MainForm.Show;
    end
    else
    begin
      PrintList(MazeList);
      ListForm.Show;
    end;
  end;
end;

procedure TEditorForm.ModeClick(Sender: TObject);
begin                                    // смена режима
  if Mode.ItemIndex = 0 then
  begin
    PassIcon.Visible:= False;
    BorderIcon.Visible:= True;
  end
  else
  begin
    PassIcon.Visible:= True;
    BorderIcon.Visible:= False;
  end;
  SETSTART.Down:= False;
end;

procedure TEditorForm.SETSTARTClick(Sender: TObject);
begin
  if SETSTART.Down then
  begin
    SETSTART.Caption:= '¬ыберите точку';
  end
  else
  begin
    SETSTART.Caption:= '”становить начальную точку';
  end;
end;

procedure TEditorForm.GENERATEClick(Sender: TObject);
var                                       // генераци€ лабиринта
  btn: Integer;
begin
  btn:= MessageDLG('ƒанна€ операци€ перекроет текущий лабиринт. ѕродолжить?',mtWarning,mbOKCancel,0);
  if btn = mrOk then
  begin
    MazeGeneration(tempMaze, mazePOINT);
    FillMazeGrid(mazePOINT,tempMaze);
    isSaved:= False;
  end;
end;

procedure TEditorForm.MazeExit(Sender: TObject);
begin
  if SETSTART.Down then
  begin
    SETSTART.Down:= False;
    SETSTART.Caption:= '”становить начальную точку';
  end;
end;

procedure TEditorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);           // гор€чие клавиши
begin
  case Key of
    VK_F1:  begin                // смена режима стены или прохода
              if Mode.ItemIndex = 0 then
              begin
                PassIcon.Visible:= False;
                BorderIcon.Visible:= True;
                Mode.ItemIndex:= 1;
              end
              else
              begin
                PassIcon.Visible:= True;
                BorderIcon.Visible:= False;
                Mode.ItemIndex:= 0;
              end;
              SETSTART.Down:= False;
            end;
    VK_F2:  begin                // смена инструмента
              if Tool.ItemIndex = 0 then
              begin
                Tool.ItemIndex:= 1;
              end
              else
              begin
                Tool.ItemIndex:= 0;
              end;
            end;
  end;
  if (ssCtrl in Shift) then
  begin                                                           
    case Key of
      $53:  SAVE.Click;    // ctrl + S   сохранение
      $47:  GENERATE.Click;// ctrl + G   генераци€
      $57:  begin          // ctrl + W   установка начальной точки
              if SETSTART.Down then
              begin
                SETSTART.Caption:= '¬ыберите точку';
                SETSTART.Down:= False;
              end
              else
              begin
                SETSTART.Caption:= '”становить начальную точку';
                SETSTART.Down:= True;
              end;
            end;
      $5A:  CANCEL.Click;// ctrl + Z     отмена всех изменений
    end;
  end;
end;

procedure TEditorForm.CANCELClick(Sender: TObject);
var
  btn: Integer;
begin                     // отмена всех изменений
  if not isSaved then btn:= MessageDLG('¬се несохраненные данные будут потер€ны. ѕродолжить?',mtWarning,mbOKCancel,0);
  if not isSaved and (btn = mrOk) then
  begin
    ImportMaze(mazePOINT, tempMaze);
    mazePOINT^.Start.X:= tSX;
    mazePOINT^.Start.Y:= tSY;
    FillMazeGrid(mazePOINT, tempMaze);
    isSaved:= True;
  end;
end;

procedure TEditorForm.FormCreate(Sender: TObject);
begin
  tSX:= mazePOINT^.Start.X;
  tSY:= mazePOINT^.Start.Y;
end;

end.



