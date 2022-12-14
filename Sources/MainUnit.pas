unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TMainForm = class(TForm)
    ExpressionEdit: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    CalculateSpeedButton: TSpeedButton;
    ClearSpeedButton: TSpeedButton;
    BackspaceSpeedButton: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    SpeedButton19: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton21: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton23: TSpeedButton;
    SpeedButton24: TSpeedButton;
    ResultRichEdit: TRichEdit;
    procedure SpeedButtonClick(Sender: TObject);
    procedure ClearSpeedButtonClick(Sender: TObject);
    procedure BackspaceSpeedButtonClick(Sender: TObject);
    procedure CalculateSpeedButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses CalculateUnit, SplitNumberUnit;

// backspace
procedure TMainForm.BackspaceSpeedButtonClick(Sender: TObject);
begin
  keybd_event(VK_BACK, 0, 0, 0); // нажатие
  keybd_event(VK_BACK, 0, KEYEVENTF_KEYUP, 0); // отпускание
end;

// очистить поле ввода
procedure TMainForm.ClearSpeedButtonClick(Sender: TObject);
begin
  ExpressionEdit.Text := ''
end;

// обработка нажатий кнопок с печатными символами
procedure TMainForm.SpeedButtonClick(Sender: TObject);
var
  CurPos: Integer;
  Value, Expression, BtnCaption: String;
begin
  ExpressionEdit.SetFocus;
  ExpressionEdit.ClearSelection;
  CurPos := ExpressionEdit.SelStart;
  BtnCaption := (Sender as TSpeedButton).Caption;
  if BtnCaption = '×' then
    Value := '*'
  else if BtnCaption = '÷' then
    Value := '/'
  else
    Value := BtnCaption;
  Expression := ExpressionEdit.Text;
  Expression.Insert(CurPos, Value);
  ExpressionEdit.Text := Expression;
  ExpressionEdit.SelStart := CurPos + 1
end;

// вычислить выражение
procedure TMainForm.CalculateSpeedButtonClick(Sender: TObject);
var
  ExspressionResult: String;
  Digits: TStringArray;
  i: Integer;
begin
  ResultRichEdit.Clear;
  ExspressionResult := CalculateExpression(ExpressionEdit.Text);
  if ExspressionResult = 'error' then
  begin
    ResultRichEdit.SelAttributes.Color := clRed;
    ResultRichEdit.SelText := ExspressionResult;
  end
  else
  begin
    Digits := SplitNumber(ExspressionResult);
    for i := 0 to Length(Digits) - 1 do
    begin
      if i mod 2 = 0 then
        ResultRichEdit.SelAttributes.Color := clGray
      else
        ResultRichEdit.SelAttributes.Color := clBlack;
      ResultRichEdit.SelText := Digits[i];
    end;
  end;
end;

end.
