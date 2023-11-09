program caffeine;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, caffeineui, VersionSupport
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Caffeine-Simplified';
  Application.Scaled:=True;
  Application.Initialize;
  Application.ShowMainForm:=FALSE;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

