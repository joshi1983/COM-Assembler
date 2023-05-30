unit StringManiU;

interface

type
    MyChar = record
      Char1: char; // the character
      index: integer;
      // index is 0 if the character is part of the formatting part
      // otherwise the index refers to the index in the plain text version of the string
    end;
    FormattedString = array of MyChar;
    function OnlyChars(Str1,charStr: string): boolean;
     function valfloat(str1: string): boolean;
     function ExtentionPos(fn: string): integer;
     function LastPos(ch: char;str1: string): integer;
     function GetFNWithExtentionAs(fn,extStr: string): string;
     function MyGetExtention(fn: string): string;
     function MyGetDir(fn: string): string;
     function GetLastPartOfFN(fn: string): string;
     function ShortenName(fn: string): string;
     procedure ClearFirstSpaces(var str1: string);
     procedure ClearDoubleSpaces(var str1: string);
     procedure ClearAllSpaces(var s: string);
     procedure RemoveComment(var str1: string);
     function CleanString(const str1: string): string;
     procedure ClearLastSpaces(var str1: string);
     function GetQuoteContents(s: string): string;
     function ClearFirstWordSpecial(var str1: string;const WordEnds: string): string;
     function ClearFirstWord(var str1: string): string;
     function GetFirstWordSpecial(str1,EndChars: string): string;
     procedure InsertChar(var str1: string;cnum: integer; c: char);
     function StringGreater(s1,s2: string): boolean;
     function StringEqual(s1,s2: string): boolean;
     procedure ClearAllTabs(var s: string);
     procedure InsertString(var str1: string;cnum: integer; s: string); overload;
     function ValidInt(s: string): boolean;
     procedure ReplaceValues(subs,withstr: string;var s: string); overload;
     procedure ReplaceValues(subs,withstr: string;var fs: FormattedString); overload;
     procedure InsertString(var fs: FormattedString; PlainIndex: integer;withstr: string); overload;
     function GetPosOfFirstChar(chars,s: string): integer;
     function GetWithNoSpaces(s: string): string;

implementation
uses SysUtils;
// here are a few string manipulation functions ---------
function valfloat(str1: string): boolean;
var
  c: byte; // represents character number in the for loop
  d,e: boolean; // represents the statement "a decimal has been found in the string."
// used to find the string invalid if there are more than one decimal
begin
     result:=true;
     d:=False;
     e:=False;
     str1:=lowercase(str1);
     if (str1<>'-')and(str1<>'')and(str1<>'.') then
     begin
          for c:=1 to length(str1) do
          begin // loop through the characters in the string
               if ((str1[c]>'9')or(str1[c]<'0'))and(str1[c]<>'.')and(str1[c]<>'-')and(str1[c]<>'e') then
               begin
                  result:=False; // an error will occur if trying to convert the string to real
                  break; // the string was found invalid so there is no reason
                  // to continue in the for loop
               end;
               if str1[c]='.' then
               begin
                    if d then // if there was another decimal already found
                    begin
                         result:=False;
                         break; // breaks the for loop so this can be more efficient
                    end;
                    d:=true; // a decimal has been found
               end
               else if (str1[c]='-')and(c<>1) then
               begin
                    result:=False;
                    break;
               end
               else if str1[c]='e' then
               begin
                    if e then
                    begin
                       result:=False;
                       break;
                    end;
                    e:=true;
               end;
          end;
     end
     else // string is invalid
         result:=False;
     if not result then
        beep; // help notify the user of the problem of an invalid number
end;

function ValidInt(s: string): boolean;
{
my definition of a valid int:
   All characters are '0'..'9'.
   The very first character can also be a '-' sign.
}
var
  c: integer;
begin
     result:=true;
     if (s[1]<>'-')and((s[1]>'9')or(s[1]<'0')) then
        result:=false;
     if result then
        for c:=2 to length(s) do
             if (s[c]>'9')or(s[c]<'0') then
             begin
                  result:=false;
                  break;
             end;
end;

function StringGreater(s1,s2: string): boolean;
var
 c: integer;
 len1: integer;
begin
     len1:=Length(s1);
     if Length(s2)<len1 then
        len1:=Length(s2);
     result:=false; // if they are equal, return false
     for c:=1 to len1 do
         if s1[c]<>s2[c] then
         begin
              result:=(s1[c]>s2[c]);
              break;
         end;
end;


function ShortenName(fn: string): string;
// returns an abreviated form of fn eliminating some of the directories to shorten the length.
// this is incase the file name is so far into subfolders that it is hard to display.
begin
     result:=fn;
     if Length(fn)>40 then
        result:='..\'+GetLastPartOfFN(fn);
end;

function StringEqual(s1,s2: string): boolean;
var
 c: integer;
 len1: integer;
begin
     len1:=Length(s1);
     if Length(s2)<len1 then
        len1:=Length(s2);
     result:=true; // if they are not equal, return false
     for c:=1 to len1 do
         if s1[c]<>s2[c] then
         begin
              result:=false;
              break;
         end;
end;

procedure RemoveChar(var str1: string;cnum: integer);
begin
     str1:=copy(str1,1,cnum-1)+copy(str1,cnum+1,999);
end;

procedure InsertChar(var str1: string;cnum: integer; c: char);
begin
     str1:=copy(str1,1,cnum-1)+c+copy(str1,cnum,999);
end;

procedure InsertString(var str1: string;cnum: integer; s: string);
begin
     str1:=copy(str1,1,cnum-1)+s+copy(str1,cnum,999);
end;

procedure ReplaceValues(subs,withstr: string;var s: string);
var
  x,StartPos,LenDiff: integer;
  s2: string;
begin
     StartPos:=0; // set an initial value
     x:=pos(subs,s);
     LenDiff:=length(withstr)-length(subs);
     while (x>0)and(StartPos<>x) do
     begin
          s:=copy(s,1,x-1)+copy(s,x+length(subs),999); // remove the character
          StartPos:=x+LenDiff;
          InsertString(s,x,withstr);
          s2:=copy(s,StartPos+1,999);
          x:=pos(subs,s2)+StartPos;
     end;
end;

function OnlyChars(Str1,charStr: string): boolean;
// returns false if str1 contains even one character that is not in the charStr
var
  c: char;
  x,y: integer;
  found: boolean;
begin
     result:=false;
     for y:=length(Str1) downto 1 do
     begin
          found:=false;
          for x:=Length(CharStr) downto 1 do
              if CharStr[x]=Str1[y] then
              begin
                   found:=true;
                   break;
              end;
          if not found then break;
     end;
     result:=found;
end;

procedure ClearFirstSpaces(var str1: string);
begin // clear all spaces from the string
     while pos(' ',str1)=1 do
           str1:=copy(str1,2,999);
     while pos(#9,str1)=1 do // clear first tabs
           str1:=copy(str1,2,999);
end;

procedure ClearLastSpaces(var str1: string);
var // remove all of the last space characters in the string
  c: integer;
begin
     for c:=length(str1) downto 1 do
         if str1[c]=' ' then
            str1:=copy(str1,1,c-1)
         else
             exit;
end;

procedure ClearDoubleSpaces(var str1: string);
var // make sure no 2 spaces are side-by-side
  pos1: integer;
begin
     // replace any tabs with a space
     pos1:=pos(#9,str1);
     while pos1>0 do
     begin
          RemoveChar(str1,pos1);
          InsertChar(str1,pos1,' ');
          pos1:=pos(#9,str1);
     end;
     // remove double spaces
     pos1:=pos('  ',str1);
     while pos1>0 do
     begin
          RemoveChar(str1,pos1);
          pos1:=pos('  ',str1);
     end;
end;

procedure ClearAllTabs(var s: string);
var // make sure no spaces are in the string
  pos1: integer;
begin
     pos1:=pos(#9,s);
     while pos1>0 do
     begin
          RemoveChar(s,pos1);
          pos1:=pos(#9,s);
     end;
end;


procedure ClearAllSpaces(var s: string);
var // make sure no spaces are in the string
  pos1: integer;
begin
     pos1:=pos(' ',s);
     while pos1>0 do
     begin
          RemoveChar(s,pos1);
          pos1:=pos(' ',s);
     end;
     pos1:=pos(#9,s); // clean all tabs
     while pos1>0 do
     begin
          RemoveChar(s,pos1);
          pos1:=pos(#9,s);
     end;
end;

function GetWithNoSpaces(s: string): string;
// make sure no spaces are in the string
begin
     result:=s;
     ClearAllSpaces(result);
end;

procedure RemoveComment(var str1: string);
var
  pos1: integer;
begin
     pos1:=pos('//',str1);
     if pos1>0 then
        str1:=copy(str1,1,pos1-1);
     pos1:=pos(';',str1);
     if pos1>0 then
        str1:=copy(str1,1,pos1-1);
        // eliminate internal documentation
end;

function CleanString(const str1: string): string;
begin
     result:=str1;
     RemoveComment(result);
     ClearLastSpaces(result);
     ClearFirstSpaces(result);
     ClearDoubleSpaces(result);
end;

function ClearFirstWordSpecial(var str1: string;const WordEnds: string): string;
// returns the first word that is cleared from the parameter
var
  pos1,Pos2: integer;
  x: integer;
begin
     ClearFirstSpaces(str1); // clear the first spaces
     pos2:=0;
     for x:=Length(WordEnds) downto 1 do
     begin
          pos1:=pos(WordEnds[x],str1);
          if (pos1>1)and((pos1<pos2)or(pos2=0)) then
             pos2:=pos1;
     end;
     // Now, pos2 is the position of the ending of the first word
     if pos2<1 then
        result:=''
     else
         result:=copy(str1,1,pos2-1);
     if length(result)=1 then
        for x:=Length(WordEnds) downto 1 do
             if WordEnds[x]=result then
             begin
                  result:='';
                  break;
             end;
     if pos2=0 then
     begin
          result:=str1;
          str1:='';
     end
     else
         str1:=copy(str1,pos2+1,999);
end;

function ClearFirstWord(var str1: string): string;
// returns the first word that is cleared from the parameter
const
     WordEnds: string = ' (),;';
begin
     result:=ClearFirstWordSpecial(str1,WordEnds);
end;

function GetFirstWordSpecial(str1,EndChars: string): string;
begin
     result:=ClearFirstWordSpecial(str1,EndChars);
end;

function LastPos(ch: char;str1: string): integer;
var
  c: integer;
begin
     result:=0;
     for c:=length(str1) downto 1 do
         if str1[c]=ch then
         begin
              result:=c;
              break;
         end;
end;

function GetPosOfFirstChar(chars,s: string): integer;
var
  x,pos1: integer;
begin
     result:=0;
     if chars<>'' then
        for x:=length(chars) downto 1 do
        begin
             pos1:=pos(chars[x],s);
             if (pos1<>0)and((result=0)or(pos1<result)) then
                result:=pos1;
        end;
end;

function ExtentionPos(fn: string): integer;
var
 c: integer;
begin
     c:=LastPos('.',fn);
     if c<1 then
        result:=0
     else
     begin
          if pos('\',copy(fn,c,999))>0 then
             result:=0
          else
              result:=c;
     end;
end;

function GetFNWithExtentionAs(fn,extStr: string): string;
var
  c: integer;
begin
     c:=Extentionpos(fn);
     if c>0 then
     begin
          fn:=copy(fn,1,c);
          result:=fn+extStr;
     end
     else
        result:=fn+'.'+extStr;
end;

function MyGetExtention(fn: string): string;
var
  c: integer;
begin
     c:=Extentionpos(fn);
     if c>0 then
          result:=LowerCase(copy(fn,c+1,999))
     else
         result:='';
end;

function MyGetDir(fn: string): string;
var
  c: integer;
begin
     c:=LastPos('\',fn);
     if c>0 then
          result:=copy(fn,1,c)
     else
         result:='';
end;

function GetLastPartOfFN(fn: string): string;
var
  pos1: integer;
begin
     pos1:=LastPos('\',fn);
     if pos1<0 then
        result:=fn
     else
         result:=Copy(fn,pos1+1,999);
end;

function GetQuoteContents(s: string): string;
// it is assumed that there is only 1 quoted section in the string s
var
  SingleQuote: boolean;
  pos2,pos1,c: integer;
begin
     result:='';
     pos1:=pos('"',s);
     c:=pos('''',s);
     if (pos1<=0)or((pos1>c)and(c>0)) then
     begin
          pos1:=c;
          SingleQuote:=true;
     end
     else
         SingleQuote:=false;
     if SingleQuote then
        pos2:=LastPos('''',s)
     else
         pos2:=LastPos('"',s);
     result:=Copy(s,pos1+1,pos2-pos1-1);
end;


// -------------------- FormattedString functions ------------------------------

function StringToFS(s: string): FormattedString;
var
  x: integer;
begin
     SetLength(result,Length(s)+1);
     for x:=Length(s) downto 1 do // loop through the characters of the string
     begin
          result[x-1].Char1:=s[x]; // add the character to the array
          result[x-1].index:=x; // set the initial index of the character to the index in the unformatted version
     end;
end;

function FSLength(fs: FormattedString): integer;
begin
     result:=high(fs)+1;
end;

function FSToString(fs: FormattedString): string;
var
  x: integer;
begin
     result:='';
     for x:=high(fs) downto 0 do
         result:=fs[x].Char1+result;
end;

function FSPlainToString(fs: FormattedString): string;
var
  x: integer;
begin
     result:='';
     for x:=high(fs) downto 0 do
         if fs[x].index<>0 then // if this character is not part of formatting
            result:=fs[x].Char1+result;
end;

function FSPos(SubStr: string; fs: FormattedString): integer;
begin
     result:=pos(SubStr,FSToString(fs));
end;

function FSPLainPos(SubStr: string; fs: FormattedString): integer;
begin
     result:=pos(SubStr,FSToString(fs));
     if result<>0 then
        result:=fs[result].index;
end;

function PlainIndexToFormattedIndex(PlainIndex: integer; fs: FormattedString): integer;
// PlainIndex = an index into the plain portion of fs
// returns the index into the whole formatted string
// This means the length of any formatting before this character at index [PlainIndex] adds to the result
var
  x: integer;
begin
     result:=0;
     for x:=high(fs) downto 0 do
         if fs[x].index=PlainIndex then
         begin
              result:=x;
              break;
         end;
end;

procedure InsertString(var fs: FormattedString; PlainIndex: integer;withstr: string);
{
fs = the formatted string to which the substring is inserted
x = the index into the plain text part of the string that the substring is inserted
WithStr = the string that will be inserted.  This becomes part of the formatting of the string.
}
var
  x,pos1,len1: integer;
begin
     pos1:=PlainIndexToFormattedIndex(PlainIndex,fs);
     len1:=length(WithStr);

     // ---------- make space for the substring by lengthening the array and shifting the upper portion to the end of the array.
     SetLength(fs,high(fs)+len1);
     for x:=high(fs) downto pos1+len1 do
         fs[x]:=fs[x-pos1];
     // -----------------------------------
     // ------ copy the substring into the array ---------------
     for x:=pos1 to pos1+len1 do
     begin
          fs[x].char1:=WithStr[x-pos1+1]; // copy the substring in
          fs[x].index:=0; // indicate that this is part of the formatting information
     end;
end;

procedure ReplaceValues(subs,withstr: string;var fs: FormattedString);
{
replace substrings from the plain text portion of fs.

For example, for html documents, '<' '>' signs are replaced with '&lt' and '&gr'
Those new values will be part of the formatted portion of the string.
}
//var
  //{x,}StartPos{,LenDiff}: integer;
  //s2: string;
begin
     //StartPos:=0; // set an initial value
{     x:=FSPlainPos(subs,fs);
     LenDiff:=Length(withstr)-Length(subs);
     while (x>0)and(StartPos<>x) do
     begin
          s:=FSCopy(s,1,x-1)+FSCopy(s,x+length(subs),999); // remove the substring
          StartPos:=x+LenDiff;
          InsertString(s,x,withstr);
          s2:=copy(s,StartPos+1,999);
          x:=pos(subs,s2)+StartPos;
     end;  }
end;

// ----------------------------------------------------------------------------

end.
