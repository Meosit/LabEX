unit Size;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TSizeForm = class(TForm)
    Cancel: TButton;
    Ok: TButton;
    WidthBox: TGroupBox;
    WidthBar: TTrackBar;
    WidthSize: TEdit;
    WL: TLabel;
    HeightBox: TGroupBox;
    HL: TLabel;
    HeightBar: TTrackBar;
    HeightSize: TEdit;
    NameBox: TGroupBox;
    Name: TEdit;
    procedure CancelClick(Sender: TObject);
    procedure HeightBarChange(Sender: TObject);
    procedure WidthBarChange(Sender: TObject);
    procedure WidthSizeKeyPress(Sender: TObject; var Key: Char);
    procedure WidthSizeExit(Sender: TObject);
    procedure WidthSizeChange(Sender: TObject);
    procedure HeightSizeChange(Sender: TObject);
    procedure HeightSizeExit(Sender: TObject);
    procedure OkClick(Sender: TObject);
    procedure HeightSizeKeyPress(Sender: TObject; var Key: Char);
    procedure NameExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SizeForm: TSizeForm  = nil;

implementation

uses List, Editor, Main, Logics;

{$R *.dfm}

var
  flag: Boolean;

procedure TSizeForm.CancelClick(Sender: TObject);
begin
  if OpenFromMain then
  begin
    MainForm.Show;
  end
  else
  begin
    ListForm.Show;
  end;
  SizeForm.Close;
end;

procedure TSizeForm.HeightBarChange(Sender: TObject);
begin
  HeightSize.Text:= IntToStr(HeightBar.Position);
end;

procedure TSizeForm.WidthBarChange(Sender: TObject);
begin
  WidthSize.Text:= IntToStr(WidthBar.Position);
end;

procedure TSizeForm.WidthSizeKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
  begin
    Key := #0;
  end;
end;


procedure TSizeForm.HeightSizeKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
  begin
    Key := #0;
  end;
end;

procedure TSizeForm.WidthSizeExit(Sender: TObject);
begin
  if (WidthSize.Text <> '') and (StrToInt(WidthSize.Text) > 100) then
  begin
    WidthSize.Text:= '100';
    WidthSize.SelectAll;
    WidthSize.SetFocus;
  end;
  if (WidthSize.Text <> '') and (StrToInt(WidthSize.Text) < 10) then
  begin
    WidthSize.Text:= '10';
  end;
  if WidthSize.Text = '' then
  begin
    WidthSize.Text:= '10';
  end;  
end;

procedure TSizeForm.WidthSizeChange(Sender: TObject);
begin
  if (WidthSize.Text <> '') and (StrToInt(WidthSize.Text) in [10..100]) then
  begin
    WidthBar.Position:= StrToInt(WidthSize.Text);
  end;
end;

procedure TSizeForm.HeightSizeChange(Sender: TObject);
begin
  if (HeightSize.Text <> '') and (StrToInt(HeightSize.Text) in [10..100]) then
  begin
    HeightBar.Position:= StrToInt(HeightSize.Text);
  end;
end;

procedure TSizeForm.HeightSizeExit(Sender: TObject);
begin
  if (HeightSize.Text <> '') and (StrToInt(HeightSize.Text) > 100) then
  begin
    HeightSize.Text:= '100';
    HeightSize.SelectAll;
    HeightSize.SetFocus;
  end;
  if (HeightSize.Text <> '') and (StrToInt(HeightSize.Text) < 10) then
  begin
    HeightSize.Text:= '50';
  end;
  if HeightSize.Text = '' then
  begin
    HeightSize.Text:= '50';
  end;
end;

procedure TSizeForm.OkClick(Sender: TObject);
var            
  temp: TMazeList;
  flag2: Boolean;
begin
  flag2:= True;
  temp:= MazeList;
  while Assigned(temp) do
  begin
    if temp^.Name = Name.Text then
    begin
      flag2:= False;
      MessageDLG('Лабиринт с таким именем уже существует.',mtError,[mbOK],0);
      Name.SetFocus;
      Name.SelectAll;
      Break;
    end;
    temp:= temp^.Next;
  end;
  if flag2 then
  begin
    if flag then
    begin
      CreateMaze(Name.Text, StrToInt(WidthSize.Text), StrToInt(HeightSize.Text), MazeList);
      CreateEditorForm(Name.Text);
      SizeForm.Close;
    end
    else
    begin
      MessageDLG('В названии лабиринта допустимы символы  0-9, а-я, А-Я, a-z, A-Z, ''_''. Размер 1-64 символа.',mtError,[mbOK],0);
    end;
  end;
end;

procedure TSizeForm.NameExit(Sender: TObject);
var
  i: Integer;
begin
  if not (Length(Name.Text) in [1..64]) then
  begin
    flag:= False;
    Name.Color:= clRed;
    Name.Font.Color:= clWhite;
  end
  else
  begin
    flag:= True;
    for i:= 1 to Length(Name.Text) do
    begin
      if not (Name.Text[i] in ['0'..'9','a'..'z','A'..'Z','а'..'я','А'..'Я','_']) then
      begin
        Name.Color:= clRed;
        Name.Font.Color:= clWhite;
        flag:= False;
        Break;
      end;
    end;
  end;
  if flag then
  begin
    Name.Color:= clWindow;
    Name.Font.Color:= clWindowText;
  end;
end;

procedure TSizeForm.FormCreate(Sender: TObject);
begin
  Application.HintPause:= 100;
  Application.HintHidePause:= 4000;
  Name.Hint:= 'Допустимые символы 0-9, а-я, А-Я, a-z, A-Z, ''_''. Размер 1-64 символа.'
end;

initialization
  flag:= True;

end.
