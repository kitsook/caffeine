unit caffeineui;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, UniqueInstance, VersionSupport, windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    MenuItemAbout: TMenuItem;
    MenuItemEnable: TMenuItem;
    MenuItemExit: TMenuItem;
    PopupMenuTrayIcon: TPopupMenu;
    Separator1: TMenuItem;
    TrayIconCaffeine: TTrayIcon;
    UniqueInstance1: TUniqueInstance;
    procedure FormCreate(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure MenuItemAboutClick(Sender: TObject);
    procedure MenuItemEnableClick(Sender: TObject);
    procedure MenuItemExitClick(Sender: TObject);
    procedure TrayIconCaffeineClick(Sender: TObject);
  private

  public

  end;

(* Source Credits: https://tips.delphidabbler.com/tips/127.html *)
type
  EXECUTION_STATE = DWORD;

const
  ES_SYSTEM_REQUIRED = $00000001;
  ES_DISPLAY_REQUIRED = $00000002;
  ES_USER_PRESENT = $00000004;
  ES_AWAYMODE_REQUIRED = $00000040;
  ES_CONTINUOUS = $80000000;

procedure SetThreadExecutionState(ESFlags: EXECUTION_STATE);
  stdcall; external kernel32 name 'SetThreadExecutionState';

procedure ApplySetting(TurnOn: Boolean);

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure ApplySetting(TurnOn: Boolean);
begin
  SetThreadExecutionState(ES_CONTINUOUS);
  if TurnOn then
    SetThreadExecutionState(ES_CONTINUOUS or ES_SYSTEM_REQUIRED or ES_DISPLAY_REQUIRED)
  else
    SetThreadExecutionState(ES_CONTINUOUS);
end;

procedure DrawIcon(Enabled: Boolean);
begin
  if Enabled then
    Form1.TrayIconCaffeine.Icon.LoadFromResourceName(HINSTANCE, 'CAFFEINE_ENABLED')
  else
    Form1.TrayIconCaffeine.Icon.LoadFromResourceName(HINSTANCE, 'CAFFEINE_DISABLED');
end;

procedure Toggle;
begin
  Form1.MenuItemEnable.Checked := Not Form1.MenuItemEnable.Checked;
  ApplySetting(Form1.MenuItemEnable.Checked);
  DrawIcon(Form1.MenuItemEnable.Checked);
end;

{ TForm1 }

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
  if Form1.WindowState = wsMinimized then
  begin
    Form1.WindowState := wsNormal;
    Form1.Hide;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MenuItemEnable.Checked := True;
  ApplySetting(True);
end;

procedure TForm1.MenuItemAboutClick(Sender: TObject);
begin
  MessageDlg('Caffeine-Simplified',
  'Caffeine-Simplified v' + LeftStr(GetFileVersion, 5) + sLineBreak +
  '© 2020 Kyle Leong' + sLineBreak +
  'https://github.com/kyleleong/caffeine' + sLineBreak +
  '© 2023 Clarence Ho' + sLineBreak +
  'https://github.com/kitsook/caffeine' + sLineBreak +
  sLineBreak +
  'Caffeine prevents your computer from going to sleep while it is enabled.' + sLineBreak
  + sLineBreak +
  'Caffeine uses icons from:' + sLineBreak +
  'https://www.famfamfam.com/lab/icons/silk/' + sLineBreak +
  'https://www.flaticon.com/authors/freepik/',
  mtInformation, [mbOK], 0);

end;

procedure TForm1.MenuItemEnableClick(Sender: TObject);
begin
  Toggle;
end;

procedure TForm1.MenuItemExitClick(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.TrayIconCaffeineClick(Sender: TObject);
begin
  Toggle;
end;

end.
