unit SplitNumberUnit;

interface

uses
  System.StrUtils;

type
  TStringArray = array of String;

function SplitNumber(Number: String): TStringArray;

implementation

function SplitNumber(Number: String): TStringArray;
var
  IntPart: String;
  FractPart: String;
  SepPos: Integer;
  Digit: String;
  i: Integer;
begin
  SepPos := Pos(',', Number);
  if SepPos <> 0 then
  begin
    IntPart := Copy(Number, 1, SepPos - 1);
    FractPart := Copy(Number, SepPos + 1, Length(Number) - SepPos);
  end
  else
    IntPart := Number;

  IntPart := ReverseString(IntPart); // ?????????????? ?????? ??? ???????? ?????????? ?? ???????
  i := 0;
  repeat
    Inc(i);
    Digit := Copy(IntPart, 1, 3);
    Insert(ReverseString(Digit), Result, 0);
    Delete(IntPart, 1, 3);
  until Length(IntPart) = 0;

  if SepPos <> 0 then
  begin
    SetLength(Result, i + 1);
    Result[i] := ',' + FractPart;
  end;

end;

end.
