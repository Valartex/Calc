program Calc;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  CalculateUnit in 'CalculateUnit.pas',
  SplitNumberUnit in 'SplitNumberUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
