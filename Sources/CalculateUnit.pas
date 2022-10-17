unit CalculateUnit;

interface

uses
  System.StrUtils, System.SysUtils;

type
  TPairedBrackets = Record
    OpeningBracketPos: Integer;
    ClosingBracketPos: Integer
  end;

  TOperands = Record
    LeftOperand: String;
    RigthOperand: String;
    LeftEdge: Integer;
    RightEdge: Integer;
  end;

function CalculateExpression(Expression: String): String;
function CalculateArithmeticExpression(Expression: String): String;
function GetFirstPairedBrackets(Expression: String): TPairedBrackets;
function GetOperands(Expression: String; OperationPos: Integer): TOperands;

implementation

// ���������� ���������� �������� ��������������� ���������
function CalculateExpression(Expression: String): String;
var
  Brackets: TPairedBrackets;
  ExpressionResult: String;
  SubExpression: String;
  ExpressionResultInDouble: Double;
begin
  Expression := StringReplace(Expression, ' ', '', [rfReplaceAll]); // ������� ��� �������

  Brackets := GetFirstPairedBrackets(Expression);

  // ���� ��������� ������ ������, ��������� ���������, ����������� ����� ���
  while (Brackets.OpeningBracketPos > 0) and (Brackets.ClosingBracketPos > 0) do
  begin
    if Brackets.ClosingBracketPos - Brackets.OpeningBracketPos > 1 then // ���� ������ ����� �����, �� ��������� ����� ���� ������
    begin
      SubExpression := Copy(Expression, Brackets.OpeningBracketPos + 1, Brackets.ClosingBracketPos - Brackets.OpeningBracketPos - 1); // �������� ���������, ����������� ����� ������
      ExpressionResult := CalculateArithmeticExpression(SubExpression); // ���������� �� ������ ���������� ���������
    end;
    if ExpressionResult = 'error' then // ���� ��������� �� ���� ��������� - ��������� ����
      Break;
    Expression := StuffString(Expression, Brackets.OpeningBracketPos, Length(SubExpression) + 2, ExpressionResult); // �������� � �������� ��������� ���� �� �������� �� ��������� ���������� ����� �����

    Brackets := GetFirstPairedBrackets(Expression);
  end;

  // ��������� ���������, ���������� ����� �������� ������
  Expression := CalculateArithmeticExpression(Expression);

  // � �������� ����� ������ �������� ���� �����
  if TryStrToFloat(Expression, ExpressionResultInDouble) then
    Result := Expression
  else
    Result := 'error'
end;

// ���������� ���������� �������� ��������������� ���������, ��� ������
function CalculateArithmeticExpression(Expression: String): String;
const
    Operations = '/*-+';
var
  Operation: Char;
  OperationPos: Integer;
  Operands: TOperands;
  LeftOperand: Double;
  RightOperand: Double;
  ExpressionResult: Double;
begin
  // ���������� �� ������� �������������� ��������
  for Operation in Operations do
  begin
    OperationPos := Pos(Operation, Expression); // ������� ������� ����� �������������� ��������
    // ���� ����� �������������� ��������, ��� ���� �������� �� ����� ������ � ������ ��� ����� ���������
    while (OperationPos > 1) and (OperationPos < Length(Expression)) do
    begin
      Operands := GetOperands(Expression, OperationPos); // �������� �������� ��������� � ��� �������
      // ���� �� ������ ���� �� ��������� - ������� �� �������
      if (Operands.LeftOperand = '') or (Operands.RigthOperand = '') then
        begin
          Result := 'error';
          Exit
        end;

      LeftOperand := StrToFloat(Operands.LeftOperand);
      RightOperand := StrToFloat(Operands.RigthOperand);

      // �������� ������� �� ����
      if (Operation = '/') and (RightOperand = 0) then
      begin
        Result := 'error';
        Exit
      end;

      // ��������� ��������� ��������������� ���������
      case Operation of
        '/': ExpressionResult := LeftOperand / RightOperand;
        '*': ExpressionResult := LeftOperand * RightOperand;
        '-': ExpressionResult := LeftOperand - RightOperand;
        '+': ExpressionResult := LeftOperand + RightOperand;
      end;

      Expression := StuffString(Expression, Operands.LeftEdge, Operands.RightEdge - Operands.LeftEdge + 1, FloatToStr(ExpressionResult)); // �������� � �������� ��������� ���� �������� �� � ���������

      OperationPos := Pos(Operation, Expression);
    end;
  end;

  // � �������� ����� ������ �������� ���� �����
  if TryStrToFloat(Expression, ExpressionResult) then
    Result := Expression
  else
    Result := 'error'
end;

// �������� �������� � ������� ���������
function GetOperands(Expression: String; OperationPos: Integer): TOperands;
const
  digits = '0123456789,';
var
  LeftOperand: String;
  RightOperand: String;
  LeftEdge: Integer;
  RightEdge: Integer;
  i: Integer;
begin
  LeftOperand := '';
  LeftEdge := 0;
  // �������� ����� ����� �� �������
  for i := OperationPos - 1 downto 1 do
    if Pos(Expression[i], digits) > 0 then
    begin
      LeftOperand := Expression[i] + LeftOperand;
      LeftEdge := i
    end
    else
      Break;

  RightOperand := '';
  RightEdge := 0;
  // �������� ����� ������ �� ��������
  for i := OperationPos + 1 to Length(Expression) do
    if Pos(Expression[i], digits) > 0 then
    begin
      RightOperand := RightOperand + Expression[i];
      RightEdge := i
    end
    else
      Break;

  Result.LeftOperand := LeftOperand;
  Result.RigthOperand := RightOperand;
  Result.LeftEdge := LeftEdge;
  Result.RightEdge := RightEdge
end;

// ��������� ������� ������ ���� ������, �� ���������� ������ ������ ������
function GetFirstPairedBrackets(Expression: String): TPairedBrackets;
const
  OpeningBrackets = '([{';
  ClosingBrackets = ')]}';
var
  OpeningBracketPos: Integer;
  ClosingBracketPos: Integer;
  BracketPos: Integer;
  Bracket: String;
  BracketIndex: Integer;
begin
  BracketIndex := 0;
  ClosingBracketPos := Length(Expression) + 1;
  // ������� ��������� ����������� ������
  for Bracket in ClosingBrackets do
  begin
    BracketPos := Pos(Bracket, Expression);
    if (BracketPos < ClosingBracketPos) and (BracketPos > 0) then
    begin
      BracketIndex := Pos(Bracket, ClosingBrackets);
      ClosingBracketPos := BracketPos
    end;
  end;

  // ���� ����������� ������ ������� - ���� �����������
  if BracketIndex <> 0 then
  begin
    // ������� ��������� ����������� ������
    Expression := ReverseString(Expression); // �������������� ������
    OpeningBracketPos := Length(Expression) - PosEx(OpeningBrackets[BracketIndex], Expression, Length(Expression) - ClosingBracketPos + 1) + 1; // � ����������� ������ ������� ��������� ����������� � ��� ��������� ������ � ��������� � ������� � �������� ������
  end
  else
  begin
    OpeningBracketPos := 0;
    ClosingBracketPos := 0
  end;

  Result.OpeningBracketPos := OpeningBracketPos;
  Result.ClosingBracketPos := ClosingBracketPos
end;

end.
