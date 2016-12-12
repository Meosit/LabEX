unit Game;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, Logics, MazeLogics, Buttons;

type
  TGameForm = class(TForm)
    Maze: TStringGrid;
    Timer: TTimer;
    BACK: TButton;
    modes: TGroupBox;
    LTimer: TLabel;
    LTime: TLabel;
    timeUP: TRadioButton;
    timeDOWN: TRadioButton;
    timeD: TEdit;
    AddBox: TGroupBox;
    START: TSpeedButton;
    PASSFIND: TSpeedButton;
    GameBox: TGroupBox;
    ABORT: TButton;
    PAUSE: TButton;
    DEFSTART: TButton;
    procedure BACKClick(Sender: TObject);
    procedure MazeDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure TimerTimer(Sender: TObject);
    procedure MazeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure timeDKeyPress(Sender: TObject; var Key: Char);
    procedure timeDExit(Sender: TObject);
    procedure timeUPClick(Sender: TObject);
    procedure timeDOWNClick(Sender: TObject);
    procedure MazeSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure STARTClick(Sender: TObject);
    procedure ABORTClick(Sender: TObject);
    procedure PAUSEClick(Sender: TObject);
    procedure PASSFINDClick(Sender: TObject);
    procedure DEFSTARTClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GameForm: TGameForm = nil;

implementation

uses
  List, Main;

{$R *.dfm}

var
  t: Real;
  tCol, tRow: Integer;
  ratingGame: Boolean;

procedure TGameForm.BACKClick(Sender: TObject);
begin
  PrintList(MazeList);
  ListForm.Show;
  GameForm.Close;
end;

procedure TGameForm.MazeDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);   // ��������� �����
begin
  if GameForm.Maze.Cells[ACol, ARow] = '-2' then
  begin
    GameForm.Maze.Canvas.Brush.Color:= clBlack;
    GameForm.Maze.Canvas.FillRect(Rect);
  end;
  if GameForm.Maze.Cells[ACol, ARow] <> '-2' then
  begin
    GameForm.Maze.Canvas.Brush.Color:= clYellow;
    GameForm.Maze.Canvas.FillRect(Rect);
  end;
  if StrToInt(GameForm.Maze.Cells[ACol, ARow]) >= 10000 then
  begin
    GameForm.Maze.Canvas.Brush.Color:= clRed;
    GameForm.Maze.Canvas.FillRect(Rect);
  end;
end;

procedure TGameForm.TimerTimer(Sender: TObject);
var
  cand: Real;
  flag: Boolean;
begin
  if timeUP.Checked then     // ���� �������
  begin
    t:= t + 0.05;
  end
  else
  begin
    t:= t - 0.05;
  end;
  LTimer.Caption:= FloatToStrF(t,ffFixed, 6,2);
  flag:= True;
  if                    // ������� ��������� ����
    (gameMaze[tRow,tCol+1] = -3) or
    (gameMaze[tRow+2,tCol+1] = -3) or
    (gameMaze[tRow+1,tCol] = -3) or
    (gameMaze[tRow+1,tCol+2] = -3)
  then
  begin
    Timer.Enabled:= False;
    cand:= StrToFloat(LTimer.Caption);
    if timeUP.Checked then
    begin
      if ratingGame then SaveGameResult(mazePOINT,cand)
      else MessageDLG('�����������! �� ������� ������ ��������, ���� �����: '+GameForm.LTimer.Caption,mtInformation,[mbOK],0);
    end
    else
    begin
      flag:= False;
      cand:= StrToInt(timeD.Text) - cand;
      MessageDLG('�����������! �� ������ ������ ��������, ���� �����: '+FloatToStrF(cand,ffFixed, 6,2),mtInformation,[mbOK],0);
    end;
    DEFSTART.Enabled:= True;
    START.Enabled:= True;
    PAUSE.Enabled:= False;
    ABORT.Enabled:= False;
  end;
  if flag and (t < 0) and timeDOWN.Checked then // ������� ���������
  begin
    LTimer.Caption:= '0.00';
    Timer.Enabled:= False;
    MessageDLG('�� ���������. �� �� ������ ��������� � ��������� �����. ',mtWarning,[mbOK],0);
    DEFSTART.Enabled:= True;
    START.Enabled:= True;
    PAUSE.Enabled:= False;
    ABORT.Enabled:= False;
  end;
end;

procedure TGameForm.MazeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);     // ����������
begin
  if (tCol >= 0) and (tRow >= 0) and (Timer.Enabled) then
  begin
    with GameForm.Maze do
    begin
      case Key of
        VK_LEFT, $41:   begin
                          Dec(tCol);
                          if Cells[tCol, tRow] <> '-2' then
                          begin
                            Cells[tCol,tRow]:= '10000';
                            Cells[tCol+1,tRow]:= '-1';
                          end
                          else
                          begin
                            Inc(tCol);
                            Key:= 0;
                          end;
                        end;
        VK_RIGHT, $44:  begin
                          Inc(tCol);
                          if Cells[tCol, tRow] <> '-2' then
                          begin
                            Cells[tCol,tRow]:= '10000';
                            Cells[tCol-1,tRow]:= '-1';
                          end
                          else
                          begin
                            Dec(tCol);
                            Key:= 0;
                          end;
                        end;
         VK_UP, $57:    begin
                          Dec(tRow);
                          if Cells[tCol, tRow] <> '-2' then
                          begin
                            Cells[tCol,tRow]:= '10000';
                            Cells[tCol,tRow+1]:= '-1';
                          end
                          else
                          begin
                            Inc(tRow);
                            Key:= 0;
                          end;
                        end;
         VK_DOWN, $53:  begin
                          Inc(tRow);
                          if Cells[tCol, tRow] <> '-2' then
                          begin
                            Cells[tCol,tRow]:= '10000';
                            Cells[tCol,tRow-1]:= '-1';
                          end
                          else
                          begin
                            Dec(tRow);
                            Key:= 0;
                          end;
                        end;
      end;
    end;
  end;
  case Key of
    VK_SPACE: if PAUSE.Enabled then PAUSE.Click;
    VK_F1:    if DEFSTART.Enabled then DEFSTART.Click;
  end;
  if (ssCtrl in Shift) then
  begin
    case Key of
      $51: if ABORT.Enabled then ABORT.Click;
      $5A:  begin
              if START.Enabled then
              begin
                if START.Down then
                begin
                  START.Down:= False;
                  START.Caption:= '������ ���� �� ����� �����';
                end
                else
                begin
                  START.Down:= True;
                  START.Caption:= '�������� �� ����� ������';
                end;
              end;
            end;
      $46:  begin
              if PAUSE.Enabled then
              begin
                PAUSE.Click;
              end;
              if PASSFIND.Down then
              begin
                PASSFIND.Down:= False;
                PASSFIND.Caption:= '��������� ���� �� �����';
              end
              else
              begin
                PASSFIND.Down:= True;
                PASSFIND.Caption:= '�������� �� ����� ������';
              end;
            end;
    end;
  end;
end;

procedure TGameForm.timeDKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
  begin
    Key := #0;
  end;
end;

procedure TGameForm.timeDExit(Sender: TObject);
begin
  if timeD.Text = '' then
  begin
    timeD.Text:= '8';
  end;
end;

procedure TGameForm.timeUPClick(Sender: TObject);
begin
  timeD.Enabled:= False;
end;

procedure TGameForm.timeDOWNClick(Sender: TObject);
begin
  timeD.Enabled:= True;
end;

procedure TGameForm.MazeSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  num: Integer;
  flag: Boolean;
begin
  if START.Down and (Maze.Cells[ACol,ARow] <> '-2')  then
  begin       // ��������� ��������� �����
    START.Down:= False;
    START.Caption:= '������ ����';
    Maze.SetFocus;
    FillMazeGrid(mazePOINT,gameMaze);
    Maze.Row:= ARow;
    Maze.Col:= ACol;
    tCol:= ACol;
    tRow:= ARow;
    Maze.Cells[tCol,tRow]:= '10000';
    if timeUP.Checked then
    begin
      t:= 0;
    end
    else
    begin
      t:= StrToInt(timeD.Text);
    end;
    DEFSTART.Enabled:= False;
    START.Enabled:= False;
    ABORT.Enabled:= True;
    PAUSE.Enabled:= True;
    Timer.Enabled:= True;
  end;
  if PASSFIND.Down and (Maze.Cells[ACol,ARow] <> '-2') then
  begin            // ��������� ��������� ����� ��� ������ ������
    MazePassFind(gameMaze, mazePOINT, ACol, ARow, flag, num);
    PASSFIND.Down:= False;
    if flag then
    begin
      FillMazeGrid(mazePOINT, gameMaze);
      MessageDLG('���������� ����� ��� ������: '+IntToStr(num),mtInformation,[mbOK],0);
    end
    else
    begin
      MessageDLG('�� ������� ��������� ��� ������.',mtWarning,[mbOK],0);
    end;
    CopyArray(tempMaze,gameMaze);
  end;
end;

procedure TGameForm.STARTClick(Sender: TObject);
begin
  if START.Down then
  begin
    START.Caption:= '�������� �� ����� ������';
  end
  else
  begin
    START.Caption:= '������ ���� �� ����� �����';
  end;
end;

procedure TGameForm.ABORTClick(Sender: TObject);
begin                // ���������� ����
  Timer.Enabled:= False;
  LTimer.Caption:= '0.00';
  DEFSTART.Enabled:= True;
  START.Enabled:= True;
  ABORT.Enabled:= False;
  PAUSE.Enabled:= False;
end;

procedure TGameForm.PAUSEClick(Sender: TObject);
begin                // �����
  if Timer.Enabled then
  begin
    PAUSE.Caption:= '���������� ����';
    Timer.Enabled:= False;
  end
  else
  begin
    PAUSE.Caption:= '�����';
    FillMazeGrid(mazePOINT,gameMaze);
    Maze.Cells[tCol,tRow]:= '10000';
    Maze.SetFocus;
    Maze.Row:= tRow;
    Maze.Col:= tCol;
    Timer.Enabled:= True;
  end;
end;

procedure TGameForm.PASSFINDClick(Sender: TObject);
begin
  if PAUSE.Enabled then
  begin
    PAUSE.Click;
  end;
  if PASSFIND.Down then
  begin
    PASSFIND.Caption:= '�������� �� ����� ������';
  end
  else
  begin
    PASSFIND.Caption:= '��������� ���� �� �����';
  end;
end;

procedure TGameForm.DEFSTARTClick(Sender: TObject);
begin                 // ������ ���� �� �������
  ratingGame:= True;
  Maze.SetFocus;
  FillMazeGrid(mazePOINT,gameMaze);
  tCol:= mazePOINT^.Start.X-1;
  tRow:= mazePOINT^.Start.Y-1;
  Maze.Row:= tRow;
  Maze.Col:= tCol;
  Maze.Cells[tCol,tRow]:= '10000';
  if timeUP.Checked then
  begin
    t:= 0;
  end
  else
  begin
    t:= StrToInt(timeD.Text);
  end;
  DEFSTART.Enabled:= False;
  START.Enabled:= False;
  ABORT.Enabled:= True;
  PAUSE.Enabled:= True;
  Timer.Enabled:= True;
end;

procedure TGameForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F1:    if DEFSTART.Enabled then DEFSTART.Click; // F1 - ������ ���� �� ������� \
    VK_F2:    begin                                    // F2 - ����� �� ���� �����
                if START.Enabled then
                begin
                  if START.Down then
                  begin
                    START.Down:= False;
                    START.Caption:= '������ ����';
                  end
                  else
                  begin
                    START.Down:= True;
                    START.Caption:= '�������� �� ����� ������';
                  end;
                end;
              end;
  end;
  if (ssCtrl in Shift) then
  begin
    case Key of
      $58   :  if PAUSE.Enabled then PAUSE.Click; // ctrl + X - �����
      $51:  if ABORT.Enabled then ABORT.Click;  // ctrl + Q - �������� ����
      $46:  begin                              // ctrl + F - ����� �� �����
              if PAUSE.Enabled then
              begin
                PAUSE.Click;
              end;
              if PASSFIND.Down then
              begin
                PASSFIND.Down:= False;
                PASSFIND.Caption:= '��������� ���� �� �����';
              end
              else
              begin
                PASSFIND.Down:= True;
                PASSFIND.Caption:= '�������� �� ����� ������';
              end;
            end;
    end;
  end;
end;


end.

