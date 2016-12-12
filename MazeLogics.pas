unit MazeLogics;

interface

uses
  SysUtils, Logics;

procedure MazePassFind(var Labirinth: TMaze; const maze: TMazeList; xS, yS: Byte; var ExistExit: Boolean; var num:Integer);
procedure MazeGeneration(var Labirinth: TMaze; const mazeP: TMazeList);

implementation

uses
  Game, Editor;

const
  BORDER = -3;
  WALL = -2;
  PASS = -1;
  WAYCONST = 10000;

procedure MazePassFind(var Labirinth: TMaze; const maze: TMazeList; xS, yS: Byte; var ExistExit: Boolean; var num:Integer);
var                              // ��������� ������ ������ �� ���������
  xE, yE, W, H, max: Integer;

  procedure WaveSpread(var Labirinth: TMaze; xS,yS,H,W: integer; var max: integer);
  var                            // ��������� ��������������� �����
    x,y,i,j,d: integer;
  begin
    y:= yS;
    x:= xS;
    d:= 0;
    Labirinth[y,x]:= d;
    repeat
      inc(d);
      for i:= 0 to H+1 do
      begin
        for j:= 0 to W+1 do
        begin
          if (Labirinth[i,j] = d-1) then        // ���� ����� ���� �������� ������� �� 1,
          begin                                 // �� ��������� ����� �������� �����
            if (i > 0) and (Labirinth[i-1,j] = PASS) then
            begin
              Labirinth[i-1,j]:= d;
            end;
            if (i < H+1) and (Labirinth[i+1,j] = PASS) then
            begin
              Labirinth[i+1,j]:= d;
            end;
            if (j > 0) and (Labirinth[i,j-1] = PASS) then
            begin
              Labirinth[i,j-1]:= d;
            end;
            if (j < W+1) and (Labirinth[i,j+1] = PASS) then
            begin
              Labirinth[i,j+1]:= d;
            end;
          end;
        end;
      end;
    until d > 0.5*W*H;
    max:= 0;
    for i:= 1 to H do                     // ���������� ������������� �������� �����
    begin
      for j:= 1 to W do
      begin
        if max <= Labirinth[i,j] then
        begin
          max := Labirinth[i,j];
        end;
      end;
    end;
  end;

  procedure SetExitPoint(const Labirinth: TMaze; var xE,yE: integer; H,W, max: integer);
  var                              // ����� � �������� ����� ������
    i,j,k,min,minY,minX: integer;
  begin
    i:= 1;
    minX:= -1;
    minY:= -1;
    min:= max;
    for k:= 1 to 2 do
    begin
      for j:= 1 to W do
      begin
        if Labirinth[i,j] <> WALL then    // ������ �� �������������� ��������
        begin
          if (Labirinth[i,j] <= min) and (Labirinth[i,j] >= 0) then
          begin
            min:= Labirinth[i,j];       // ���� ����������� ����� � ������� ���������
            minY:= i;                   // ��� ���� �������� �����, �� ��� ������������
            minX:= j;
          end;
        end;
      end;
      inc(i,H-1);
    end;
    j:= 1;
    for k:= 1 to 2 do
    begin
      for i:= 1 to H do
      begin
        if Labirinth[i,j] <> WALL then   // ���������� ��� ������������ ������
        begin
          if (Labirinth[i,j] <= min) and (Labirinth[i,j] >= 0) then
          begin
            min:= Labirinth[i,j];
            minY:= i;
            minX:= j;
          end;
        end;
      end;
      inc(j,W-1);
    end;
    yE:= minY;       // ��������� ����� � ���������� ����
    xE:= minX;
    if xE = -1 then   // ���� �� ���� �� ��������� �������� - ������ ���
    begin
      ExistExit:= False;
    end;
  end;

  procedure WayCheck(var Labirinth: Tmaze; yS,xS,yE,xE: integer; var num: Integer);
  var                 // ���������� ���� ������ ������� (�������� ����)
    d,y,x: integer;
  begin
    y:= yE;
    x:= xE;
    num:= 0;
    Labirinth[y,x]:= Labirinth[y,x] + WAYCONST; // ��������� ����� ��� ������� ����
    d:= Labirinth[y,x];                         // � ������� �����, ��� �� ����� ��� ���� ������
    while (Labirinth[y,x] > WAYCONST) and (d > WAYCONST - 1) do
    begin
      if Labirinth[y,x] = d then
      begin
        if Labirinth[y-1,x] = d - 1 - WAYCONST then
        begin
          Labirinth[y-1,x]:= d - 1;
          dec(y)
        end
        else
        begin
          if Labirinth[y+1,x] = d - 1 - WAYCONST then
          begin
            Labirinth[y+1,x]:= d - 1;
            inc(y)
          end
          else
          begin
            if Labirinth[y,x+1] = d - 1 - WAYCONST then
            begin
              Labirinth[y,x+1]:= d - 1;
              inc(x);
            end
            else
            begin
              if Labirinth[y,x-1] = d - 1 - WAYCONST then
              begin
                Labirinth[y,x-1]:= d - 1;
                dec(x);
              end;
            end;
          end;
        end;
        Inc(num);
      end;
      dec(d);
    end;
  end;
begin
  W:= maze^.Width;
  H:= maze^.Height;
  Inc(xS);
  inc(yS);
  ExistExit:= True;
  WaveSpread(Labirinth,xS,yS,H,W,max);
  SetExitPoint(Labirinth,xE,yE,H,W,max);
  if ExistExit then WayCheck(Labirinth,yS,xS,yE,xE,num);
end;

procedure MazeGeneration(var Labirinth: TMaze; const mazeP: TMazeList);
var                       // ��������� ��������� ���������
  line: array [1..2] of array of Integer;
  i, j, k, t, sets, H, W, curr: Integer;
begin
  Randomize;
  SetLength(line[1],Length(Labirinth[0]));
  SetLength(line[2],Length(Labirinth[0]));
  H:= mazeP^.Height;
  W:= mazeP^.Width;
  if not(W and 1 = 1) then        // ������������� ������
  begin
    dec(W);
  end;  
  // ��������� ������ �����
  for i:= 1 to W do
  begin
    line[1,i]:= -1;
  end;
  line[2,1]:= -1;
  line[2,W]:= -1;
  sets:= 1;
  for i:= 2 to W-1 do              // ���������� ��������� ��� ������ ������
  begin
    line[2,i]:= sets;
    inc(sets);
  end;
  i:= 2;
  sets:= 1;
  while i <= W-2 do                // ����������� ������
  begin
    if Boolean(Random(2)) then
    begin
      line[2,i+2]:= line[2,i];
      line[2,i+1]:= line[2,i];
    end
    else
    begin
      line[2,i+1]:= -1;
      Inc(sets);
    end;
    Inc(i,2);
  end;
  curr:= 1;
  while curr <= 2 do             // ����������� ������ � ������
  begin
    for i:= 1 to W do
    begin
      Labirinth[curr,i]:= line[curr,i];
    end;
    Inc(curr);
  end;
  // ��������� ������� �����
  for k:= 1 to ((H div 2) - 1) do
  begin
    for i:= 1 to W do            // ������� ������
    begin
      line[1,i]:= -1;
    end;
    i:= 2;
    for t:= 1 to sets do
    begin
      j:= 0;
      while line[2,i] <> -1 do
      begin
        if not(i and 1 = 1) then Inc(j);
        Inc(i);
      end;
      Inc(i);
      line[1,i - 2*Random(j) - 2]:= line[2,i-2]; // �������� ������ ��� �������
    end;
    for i:= 3 to W-1 do  // ���������� �� ��������� ������ (����������� ��� ������� ������)
    begin
      if line[2,i] = -1 then
      begin
        line[2,i]:= line[2,i-1];
      end;
    end;
    for i:= 2 to W-1 do     // ������ �� �������� ����� ����������
    begin
      if line[1,i] = -1 then
      begin
        line[2,i]:= 0;
      end;
    end;
    line[2,2]:= 1;
    sets:= Labirinth[2,W-1]+1;
    for i:= 2 to W-1 do          // ���������� ��������� ��� ������� ������
    begin
      if line[2,i] = 0 then
      begin
        line[2,i]:= sets;
        Inc(sets);
      end;
    end;
    i:= 2;
    sets:= 1;
    while i <= W-2 do             // ��������� ����������� ������
    begin
      if Boolean(Random(2)) or (line[1,i+1] <> -1) then
      begin
        line[2,i+2]:= line[2,i];
        line[2,i+1]:= line[2,i];
      end
      else
      begin
        line[2,i+1]:= -1;
        Inc(sets);
      end;
      Inc(i,2);
    end;
    for j:= 1 to 2 do              // �������� ������ � ������
    begin
      for i:= 1 to W do
      begin
        Labirinth[curr,i]:= line[j,i];
      end;
      Inc(curr);
    end;
  end;
// ��������� ��������� ������
  for i:= 2 to W-1 do                     // ��������� ������ ������
  begin
    Labirinth[H,i]:= -1;
    Labirinth[H-1,i]:= 0;
  end;
  i:= 4;
  while i<= W-3 do                           // ����������� ��� ����������
  begin                                      // ��������� ������� ��� 
    if (i and 1 = 1) then                    // ������� ���������
    for j:= 1 to Random(6)+2 do
    begin
      Labirinth[H-j,i]:= -1;
      Labirinth[H-j,i-1]:= 0;
      Labirinth[H-j,i+1]:= 0;
    end;
    Labirinth[H-j,i]:= 0;
    Labirinth[H-j,i-1]:= 0;
    Labirinth[H-j,i+1]:= 0;
    Inc(i,Random(W div 6)+1);
  end;
  for i:= H-7 to H-2 do
  begin
    for j:= 3 to W-2 do
    begin
      if (Labirinth[i-1,j] <> -1) and
        (Labirinth[i+1,j] <> -1) and
        (Labirinth[i,j-1] <> -1) and
        (Labirinth[i,j+1] <> -1) and
        (Labirinth[i,j] = -1)
      then
      begin
        Labirinth[i,j-1]:= -1;
      end;  
    end;
  end;
  Labirinth[H,1]:= -1;
  Labirinth[H,W]:= -1;

  if not (mazeP^.Width and 1 = 1) then // ����������� ��� ������ ������ ���������
  begin
    Inc(W);
    for i:= 2 to H-1 do
    begin
      if Labirinth[i,W-2] = -1 then
      begin
        Labirinth[i,W-1]:= -1
      end
      else
      begin
        if (Labirinth[i-1,W-1] = -1) and (Labirinth[i+1,W-1] = -1) then
        begin
          Labirinth[i,W-1]:= 0;
        end
        else
        begin
          if Boolean(Random(2)) then
          begin
            Labirinth[i,W-1]:= 0;
          end
          else
          begin
            Labirinth[i,W-1]:= -1;
          end;
        end;
      end;
      Labirinth[i,W]:= -1;
    end;
    Labirinth[1,W-1]:= 0;
    Labirinth[2,W-1]:= 0;
    Labirinth[1,W-2]:= -1;
    Labirinth[H,W]:= -1;
    Labirinth[1,W]:= -1;
  end;
  if not(mazeP^.Height and 1 = 1) then // ����������� ��� ������ ������ ���������
  begin
    for i:= 3 to W-2 do
    begin
      if (Labirinth[H-2,i] <> -1) and (Labirinth[H-2,i-1] <> -1) and (Labirinth[H-2,i+1] <> -1) then
      begin
        Labirinth[H-1,i]:= -1;
      end;
    end;
  end;
// ������� ������� � ������ ��� ��� ������ ���������
  for i:= 1 to H do
  begin
    for j:= 1 to W do
    begin
      if Labirinth[i,j] = -1 then
      begin
        Labirinth[i,j]:= 0;
      end
      else
      begin
        Labirinth[i,j]:= 1;
      end;
    end;
  end;
  Labirinth[1,W-1]:= 1;            // ��������� ��������� ����� � ������ �� ���������
  EditorForm.Maze.Cells[mazeP^.Start.X-1,mazeP^.Start.Y-1]:= '1';
  tempMaze[mazeP^.Start.Y,mazeP^.Start.X]:= 1;
  mazeP^.Start.X:= 2;
  mazeP^.Start.Y:= 2;
  EditorForm.Maze.Cells[mazeP^.Start.X-1,mazeP^.Start.Y-1]:= '-1';
  Labirinth[mazeP^.Start.X,mazeP^.Start.Y]:= -1;
end;

end.
