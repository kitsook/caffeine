unit caffeineui;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ButtonPanel,
  Menus, UniqueInstance, VersionSupport, windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonPanelConfirm: TButtonPanel;
    CheckGroupSettings: TCheckGroup;
    MenuItemSettings: TMenuItem;
    MenuItemExit: TMenuItem;
    PopupMenuTrayIcon: TPopupMenu;
    TrayIconCaffeine: TTrayIcon;
    UniqueInstance1: TUniqueInstance;
    procedure CheckGroupSettingsItemClick(Sender: TObject; Index: integer);
    procedure FormCreate(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure MenuItemSettingsClick(Sender: TObject);
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

{ TForm1 }

procedure TForm1.TrayIconCaffeineClick(Sender: TObject);
begin
  if Form1.Visible then
    Form1.Hide
  else
    Form1.Show;
end;

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
  (* Prevent sleeping. *)
  SetThreadExecutionState(ES_CONTINUOUS or ES_SYSTEM_REQUIRED or ES_DISPLAY_REQUIRED);
  CheckGroupSettings.Checked[0] := True;
end;

procedure TForm1.CheckGroupSettingsItemClick(Sender: TObject; Index: integer);
begin
  if Index = 0 then
  begin
    ApplySetting(CheckGroupSettings.Checked[0]);
  end
end;

procedure TForm1.HelpButtonClick(Sender: TObject);
begin
  MessageDlg('Caffeine-Simplified', 'Caffeine-Simplified v' + LeftStr(GetFileVersion, 5) + ' © 2020 Kyle Leong' + sLineBreak +
  'https://github.com/kyleleong/caffeine' + sLineBreak +
  '© 2023 Clarence Ho' + sLineBreak +
  'https://github.com/kitsook/caffeine' + sLineBreak +
  sLineBreak +
  'Caffeine prevents your computer from going to sleep while it is active. ' +
  'You can quit the program or access its settings at any time from the tray icon.' +
  sLineBreak + sLineBreak + 'Caffeine uses icons from:' + sLineBreak +
  'https://www.famfamfam.com/lab/icons/silk/' + sLineBreak +
  'https://www.flaticon.com/authors/freepik/'
  , mtInformation, [mbOK], 0);
end;

procedure TForm1.MenuItemSettingsClick(Sender: TObject);
begin
  Form1.Show;
end;

procedure TForm1.MenuItemExitClick(Sender: TObject);
begin
  Form1.Close;
end;

end.
