unit Logics;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids;

type
  TMaze = array of array of Integer;
  TMazeList = ^PMazeList;
  PMazeList = record
                Name: string[64];
                Width: Byte;
                Height: Byte;
                FileWay: string[73];
                ChangeDate: string[18];
                BestGame: Real;
                Start: record
                         X,Y: Integer;
                       end;
                Next: TMazeList;
              end;

var
  tempMaze, gameMaze: Tmaze;
  MazeList: TMazeList;
  mazePOINT: TMazeList;
  isSaved, editMode: Boolean;
procedure CreateMaze(const name: string; const W, H: Byte; var List: TMazeList);
procedure DeleteMaze(const ARow: Integer; var List: TMazeList);
procedure CreateEditorForm(const name: string);
procedure CreateGameForm(const name: string);
procedure PrintList(var List: TMazeList);
procedure SaveMazeToFile(const maze: TMazeList; var tempMaze: TMaze);
procedure FillMazeGrid(const maze: TMazeList; var TMaze: TMaze);
procedure SaveGameResult(const maze: TMazeList; cand: Real);
procedure ImportMaze(const maze: TMazeList; var TMaze: TMaze);
procedure CopyArray(const Source: TMaze; var Dest: TMaze);
procedure InitGameMode(var Labirinth: TMaze; const maze: TMazeList);

implementation

uses
  List, Editor, Size, MazeLogics, Game;

procedure CopyArray(const Source: TMaze; var Dest: TMaze);      // копирование двумерного
var                                                             // динамического массива
  i: Integer;
begin
  SetLength(Dest, Length(Source), Length(Source[0]));
  for i:= 0 to Length(Source)-1 do
  begin
    Dest[i]:= Copy(Source[i]);
  end;
end;

procedure CreateMaze(const name: string; const W, H: Byte; var List: TMazeList);
var                                          // процедура создани€ лабиринта
  f, fList: TextFile;
  temp, plus: TMazeList;
  way, row, timestr: string;
  i: Integer;
  time: TDateTime;
begin
  time:= Now;
  timestr:= DateToStr(time)+ 'г. ' + TimeToStr(time); // сохранение времени создани€
  New(plus);
  way:= 'Data/' + name + '.txt';
  plus^.BestGame:= -1;
  plus^.Start.X:= 2;                                  // стартова€ точка (2,2)
  plus^.Start.Y:= 2;
  plus^.Name:= name;
  plus^.Width:= W;
  plus^.Height:= H;
  plus^.FileWay:= way;
  plus^.ChangeDate:= timestr;
  AssignFile(fList, 'Data/=FileList=.txt');           // запись данных нового
  Append(fList);                                      // лабиринта в общий файл-список
  Writeln(fList, way+'|'+IntToStr(W)+'|'+IntToStr(H)+'|'+timestr+'|'+FloatToStrF(plus^.BestGame,ffFixed,6,2)+'|'+IntToStr(plus^.Start.X)+'|'+IntToStr(plus^.Start.Y)+'|');
  CloseFile(fList);
  AssignFile (f, way);
  Rewrite(f);
  row:= '';                                           // создание файла лабиринта
  for i:= 1 to W-2 do
  begin
    row:= Concat(row, '0');
  end;
  row:= Concat(row, '10');
  WriteLn (f, row);
  row:= '0';
  for i:= 2 to W-1 do
  begin
    row:= Concat(row, '1');
  end;
  row:= Concat(row, '0');
  for i:= 2 to H-1 do
  begin
    WriteLn(f, row);
  end;
  row:= '';
  for i:= 1 to W do
  begin
    row:= Concat(row, '0');
  end;
  Writeln(f, row);
  CloseFile(f);
  temp:= List;
  if not Assigned(temp) then
  begin
    List:= plus;
    List^.Next:= nil;
  end
  else
  begin
    if temp^.Name > plus^.Name then
    begin
      plus^.next:= List;
      List:= plus;
    end
    else
    begin
      while Assigned(temp^.next) and (temp^.next^.Name < plus^.Name)  do
      begin
        temp:= temp^.next;
      end;
      plus^.next:= temp^.next;
      temp^.next:= plus;
    end;
  end;
end;

procedure DeleteMaze(const ARow: Integer; var List: TMazeList);
var                                // удаление лабиринта
  temp, del: TMazeList;
  i, button: Integer;
  f: TextFile;
  delstr: string;
begin
  button:= MessageDLG('ƒанна€ операци€ необратима, продолжить?',mtWarning,mbOKCancel,0);  // проверка от случайного нажати€
  if Assigned(List) and (button = mrOk) then
  begin
    temp:= List;
    if ARow = 1 then                               // удаление элемента списка
    begin
      del:= List;
      List:= List^.next;
    end
    else
    begin
      i:= 1;
      while (temp <> nil) and (i < ARow-1) do
      begin
        temp:= temp^.Next;
        inc(i);
      end;
      del:= temp^.Next;
      temp^.Next:= temp^.Next^.Next 
    end;
    delstr:= del^.FileWay;
    Dispose(del);
    temp:= MazeList;
    Rewrite(f, 'Data/=FileList=.txt');             // перезапись файла-списка лабиринтов
    while Assigned(temp) do
    begin
      Writeln(f, temp^.FileWay+'|'+IntToStr(temp^.Width)+'|'+IntToStr(temp^.Height)+'|'+temp^.ChangeDate+'|'+FloatToStrF(temp^.BestGame,ffFixed,6,2)+'|'+IntToStr(temp^.Start.X)+'|'+IntToStr(temp^.Start.Y)+'|');
      temp:= temp^.Next;
    end;
    CloseFile(f);
    DeleteFile(delstr);
  end;
end;

procedure SaveMazeToFile(const maze: TMazeList; var tempMaze: TMaze);
var                                      // сохранение изменений в лабиринте
  button,W, H, i, j: Byte;
  f: TextFile;
  temp: TMazeList;
  row, timestr: string;
  time: TDateTime;
begin
  if maze^.BestGame > 0 then     // при изменении лабиринта результаты игры сбрасываютс€
  begin
    button:= MessageDLG('ѕри изменении лабиринта результаты его прохождени€ будут сброшены! —охранить лабиринт?',mtWarning,mbOKCancel,0);
  end
  else
  begin
    button:= mrOk;
  end;
  if button = mrOk then
  begin
    time:= Now;
    timestr:= DateToStr(time)+ 'г. ' + TimeToStr(time);  // сохранение времени изменени€
    W:= maze^.Width;
    H:= maze^.Height;
    tempMaze[maze^.Start.Y,maze^.Start.X]:= 1;
    AssignFile(f, maze^.FileWay);
    Rewrite(f);
    for i:= 1 to H do                                // перезапись лабиринта из массива в файл
    begin
      row:= '';
      for j:= 1 to W do
      begin
        row:= Concat(row, IntToStr(tempMaze[i,j]));
      end;
      Writeln(f, row);
    end;
    CloseFile(f);
    mazePOINT^.ChangeDate:= timestr;
    mazePOINT^.BestGame:= -1;
    temp:= MazeList;
    Rewrite(f, 'Data/=FileList=.txt');
    while Assigned(temp) do                               // перезапись файла-списка лабиринтов
    begin
      Writeln(f, temp^.FileWay+'|'+IntToStr(temp^.Width)+'|'+IntToStr(temp^.Height)+'|'+temp^.ChangeDate+'|'+FloatToStrF(temp^.BestGame,ffFixed,6,2)+'|'+IntToStr(temp^.Start.X)+'|'+IntToStr(temp^.Start.Y)+'|');
      temp:= temp^.Next;
    end;
    CloseFile(f);
    isSaved:= True;
    tempMaze[maze^.Start.Y,maze^.Start.X]:= -1;
    MessageDLG('»зменени€ успешно сохранены.',mtInformation,[mbOK],0);
  end;
end;

procedure SaveGameResult(const maze: TMazeList; cand: Real);
var                       // если результат игры лучше, то сохранить новый результат
  f: TextFile;
  temp: TMazeList;
  newrecord: string[14];
begin
  newrecord:= '';
  if (maze^.BestGame < 0) or (maze^.BestGame > cand) then
  begin
    maze^.BestGame:= cand;
    newrecord:= ' Ќовый рекорд!';
  end;
  temp:= MazeList;
  Rewrite(f, 'Data/=FileList=.txt');
  while Assigned(temp) do
  begin
    Writeln(f, temp^.FileWay+'|'+IntToStr(temp^.Width)+'|'+IntToStr(temp^.Height)+'|'+temp^.ChangeDate+'|'+FloatToStrF(temp^.BestGame,ffFixed,6,2)+'|'+IntToStr(temp^.Start.X)+'|'+IntToStr(temp^.Start.Y)+'|');
    temp:= temp^.Next;
  end;
  CloseFile(f);
  MessageDLG('ѕоздравл€ем! ¬ы успешно прошли лабиринт, ваше врем€: '+GameForm.LTimer.Caption+'.'+newrecord,mtInformation,[mbOK],0);
end;

procedure ImportMaze(const maze: TMazeList; var TMaze: TMaze);
var                         // выгрузка лабиринта из файла в массив
  W, H, i, j: Byte;
  f: TextFile;
  row: string;
begin
  W:= maze^.Width;
  H:= maze^.Height;
  SetLength(TMaze, H+2, W+2);
  AssignFile(f, maze^.FileWay);
  Reset(f);
  for i:= 1 to H do
  begin
    Readln(f, row);
    for j:= 1 to W do
    begin
      TMaze[i,j]:= StrToInt(row[j]);
    end;
  end;
  CloseFile(f);
end;

procedure FillMazeGrid(const maze: TMazeList; var TMaze: TMaze);
var                            // заполнение таблицы stringgrid значени€ми из массива
  i, j: Byte;
begin
  if editMode then
  begin
    for i:= 1 to maze^.Height do
    begin
      for j:= 1 to maze^.Width do
      begin
        EditorForm.Maze.Cells[j-1,i-1]:= IntToStr(TMaze[i,j]);
      end;
    end;
    if maze^.Start.X > 0 then
    EditorForm.Maze.Cells[maze^.Start.X-1,maze^.Start.Y-1]:= '-1'
  end
  else
  begin
    for i:= 1 to maze^.Height do
    begin
      for j:= 1 to maze^.Width do
      begin
        GameForm.Maze.Cells[j-1,i-1]:= IntToStr(TMaze[i,j]);
      end;
    end;
  end;
end;

procedure PrintList(var List: TMazeList);
var                          // отрисовка списка всех лабиринтов
  temp: TMazeList;
  i: Integer;
begin
  temp:= List;
  with ListForm.List do
  begin
    Cols[0].Clear;
    Cols[1].Clear;
    Cols[2].Clear;
    Cells[0,0]:= '»м€ Ћабиринта';
    Cells[1,0]:= '–азмер';
    if editMode then
    begin
      Cells[2,0]:= 'ƒата изменени€';
    end
    else
    begin
      Cells[2,0]:= 'Ћучшее врем€';
    end;
  end;
  i:= 1;
  while Assigned(temp) do
  begin
    inc(i);
    temp:= temp^.Next;
  end;
  if i > 13 then
  begin
    ListForm.List.RowCount:= i;
  end;
  temp:= List;
  i:= 1;
  while Assigned(temp) do
  begin
    if ((temp^.Start.X > 0) and (temp^.Start.X > 0)) then
    begin
      with ListForm.List do
      begin
        Cells[0,i]:= temp^.Name;
        Cells[1,i]:= IntToStr(temp^.Width)+'x'+IntToStr(temp^.Height);
        if editMode then
        begin
          Cells[2,i]:= temp^.ChangeDate;
        end
        else
        begin
          if temp^.BestGame < 0 then
          begin
            Cells[2,i]:= 'ƒанных нет'
          end
          else
          begin
            Cells[2,i]:= FloatToStrF(temp^.BestGame,ffFixed,6,2);
          end;
        end;
      end;
    end;
    inc(i);
    temp:= temp^.Next;
  end;
end;

procedure CreateEditorForm(const name: string);
var                         // создание формы редактора
  mazeSize, nCols, nRows, d, W, H: Integer;
  temp: TMazeList;
begin
  temp:= MazeList;
  while temp^.Name <> name do
  begin
    temp:= temp^.Next;
  end;
  mazePOINT:= temp;
  EditorForm:= TEditorForm.Create(EditorForm);
  EditorForm.Maze.Height:= 603;
  EditorForm.Maze.Width:= 603;
  EditorForm.ClientHeight:= 619;
  EditorForm.ClientWidth:= 616 + EditorForm.EditMode.Width + 8;
  mazeSize:= EditorForm.Maze.Height;
  nCols:= temp^.Width;
  nRows:= temp^.Height;
  with EditorForm.Maze do                   // вычисление и установка нужных размеров stringgrid
  begin
    ColCount:= nCols;
    RowCount:= nRows;
    if nRows <= nCols then
    begin
      d:= Trunc((mazeSize - 3)/nCols) - 1;
    end
    else
    begin
      d:= Trunc((mazeSize - 3)/nRows) - 1;
    end;
    DefaultColWidth:= d;
    DefaultRowHeight:= d;
    W:= (d + 1)*nCols + 3;
    H:= (d + 1)*nRows + 3;
    Width:= W;
    EditorForm.ClientWidth:= 8 + W + 5 + EditorForm.EditMode.Width + 8;
    if (H < mazeSize) then
    begin
      Height:= H;
      if H > EditorForm.BACK.Top + EditorForm.BACK.Height + 8 then
      begin
        EditorForm.ClientHeight:= 8 + H + 8;
      end
      else
      begin
        EditorForm.ClientHeight:= EditorForm.BACK.Top + EditorForm.BACK.Height + 8;
      end;
    end;
  end;
  EditorForm.EditMode.Left:= 8 + W + 5;                    // установка нужного положени€ кнопок
  EditorForm.SAVE.Left:= EditorForm.EditMode.Left;
  EditorForm.CANCEL.Left:= EditorForm.EditMode.Left;
  EditorForm.BACK.Left:= EditorForm.SAVE.Left + 24;
  EditorForm.BACK.Top:= EditorForm.ClientHeight - EditorForm.BACK.Height - 8;
  EditorForm.Top:= Round(Screen.Height/2 - EditorForm.Height/2);
  EditorForm.Left:= Round(Screen.Width/2 - EditorForm.Width/2);
  ImportMaze(temp, tempMaze);
  FillMazeGrid(temp, tempMaze);
  EditorForm.ShowModal;
end;

procedure CreateGameForm(const name: string);
var                      // создание формы игрового режима
  mazeSize, nCols, nRows, d, W, H: Integer;
  temp: TMazeList;
begin
  temp:= MazeList;
  while temp^.Name <> name do
  begin
    temp:= temp^.Next;
  end;
  mazePOINT:= temp;
  GameForm:= TGameForm.Create(GameForm);
  GameForm.Maze.Height:= 603;
  GameForm.Maze.Width:= 603;
  GameForm.ClientHeight:= 619;
  GameForm.ClientWidth:= 616 + GameForm.START.Width + 8;
  mazeSize:= GameForm.Maze.Height;
  nCols:= temp^.Width;
  nRows:= temp^.Height;
  with GameForm.Maze do                    // вычисление и установка нужных размеров stringgrid
  begin
    ColCount:= nCols;
    RowCount:= nRows;
    if nRows <= nCols then
    begin
      d:= Trunc((mazeSize - 3)/nCols) - 1;
    end
    else
    begin
      d:= Trunc((mazeSize - 3)/nRows) - 1;
    end;
    DefaultColWidth:= d;
    DefaultRowHeight:= d;
    W:= (d + 1)*nCols + 3;
    H:= (d + 1)*nRows + 3;
    Width:= W;
    GameForm.ClientWidth:= 8 + W + 5 + GameForm.START.Width + 8;
    if (H < mazeSize) then
    begin
      Height:= H;
      if H > GameForm.BACK.Top + GameForm.BACK.Height + 8 then
      begin
        GameForm.ClientHeight:= 8 + H + 8;
      end
      else
      begin
        GameForm.ClientHeight:= GameForm.BACK.Top + GameForm.BACK.Height + 8;
      end;
    end;
  end;
  GameForm.modes.Left:= 8 + W + 5;                    // установка нужного положени€ кнопок
  GameForm.GameBox.Left:= 8 + W + 5;
  GameForm.AddBox.Left:= 8 + W + 5;
  GameForm.BACK.Left:= GameForm.AddBox.Left + 24;
  GameForm.BACK.Top:= GameForm.ClientHeight - GameForm.BACK.Height - 8;
  GameForm.Top:= Round(Screen.Height/2 - GameForm.Height/2);
  GameForm.Left:= Round(Screen.Width/2 - GameForm.Width/2);
  InitGameMode(gameMaze, temp);
  CopyArray(gameMaze,tempMaze);
  FillMazeGrid(temp, gameMaze);
  GameForm.ShowModal;
end;

procedure InitGameMode(var Labirinth: TMaze; const maze: TMazeList);
var                                              // инициализаци€ массива с лабиринтом дл€
  i, j, H, W: integer;                           // корректной работы в игровом режиме
begin
  ImportMaze(maze, Labirinth);
  H:= maze^.Height;
  W:= maze^.Width;
  for i:= 1 to H do                              // замена 1 и 0 в массиве на
  begin                                          // значени€ нужные дл€ работы
    for j:= 1 to W do
    begin
      if Labirinth[i,j] = 0 then
      begin
        Labirinth[i,j]:= -2;
      end
      else
      begin
        Labirinth[i,j]:= -1;
      end;
    end;
  end;
  for i:= 0 to H+1 do
  begin
    for j:= 0 to W+1 do
    begin
      if (i = 0) or (i = H+1) then
      begin
        Labirinth[i,j]:= -3;
      end;
      if (j = 0) or (j = W+1) then
      begin
        Labirinth[i,j]:= -3;
      end;
    end;
  end;
end;

procedure Initialize;                         // инициализаци€ программы
var
  f: TextFile;
  i, j: Integer;
  tmp, row: string;
  plus, temp: TMazeList;
begin
  isSaved:= True;
  New(MazeList);
  MazeList:= nil;
  AssignFile(f, 'Data/=FileList=.txt');           // чтение файла-списка лабиринтов и
  Reset(f);                                       // формирование списка в программе
  while not Eof(f) do
  begin
    New(plus);
    Readln(f, row);
    i:= 0;
    for j:= 1 to 7 do
    begin
      tmp:= '';
      Inc(i);
      while row[i] <> '|' do
      begin
        tmp:= tmp + row[i];
        inc(i);
      end;
      case j of
        1:  begin
              plus^.FileWay:= tmp;
              Delete(tmp, Length(tmp)-3,4);
              Delete(tmp,1,5);
              plus^.Name:= tmp;
            end;
        2:  plus^.Width:= StrToInt(tmp);
        3:  plus^.Height:= StrToInt(tmp);
        4:  plus^.ChangeDate:= tmp;
        5:  plus^.BestGame:= StrToFloat(tmp);
        6:  plus^.Start.X:= StrToInt(tmp);
        7:  plus^.Start.Y:= StrToInt(tmp);
      end;
    end;
    temp:= MazeList;
    if not Assigned(temp) then
    begin
      MazeList:= plus;
      MazeList^.Next:= nil;
    end
    else
    begin
      if temp^.Name > plus^.Name then
      begin
        plus^.next:= MazeList;
        MazeList:= plus;
      end
      else
      begin
        while Assigned(temp^.next) and (temp^.next^.Name < plus^.Name)  do
        begin
          temp:= temp^.next;
        end;
        plus^.next:= temp^.next;
        temp^.next:= plus;
      end;
    end;
  end;
  CloseFile(f);
end;

initialization
  Initialize;

end.
