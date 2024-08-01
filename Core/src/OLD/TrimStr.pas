unit TrimStr;

interface

uses
    SysUtils;    

const
   BlackSpace = [#33..#126];

function trim(const Search: string): string;

function space_in(str : String) : String;
function space_out(str : String) : String;

implementation


function trim(const Search: string): string;
var
   Index: byte;
begin
   Index:=1;
   while (Index <= Length(Search)) and not (Search[Index] in BlackSpace) do
      Index:=Index + 1;
   Result:=Copy(Search, Index, 255);
   Index:=Length(Result);
   while (Index > 0) and not (Result[Index] in BlackSpace) do
      Index:=Index - 1;
   Result:=Copy(Result, 1, Index);
end;

function space_in(str : String) : String;
begin
    Result := StringReplace(str, ' ', '[§FUSION§]', [rfReplaceAll, rfIgnoreCase]);
end;

function space_out(str : String) : String;
begin
    Result := StringReplace(str, '[§FUSION§]', ' ', [rfReplaceAll, rfIgnoreCase]);
end;


end.
