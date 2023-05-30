unit MainU;
{
This unit contains code for GUI related things

}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus;

type
  TMainFrm = class(TForm)
    CodeMemo: TMemo;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Run1: TMenuItem;
    Assemble1: TMenuItem;
    AssembleandRun1: TMenuItem;
    Run2: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Save1: TMenuItem;
    View1: TMenuItem;
    OpcodeListing1: TMenuItem;
    N2: TMenuItem;
    Export1: TMenuItem;
    HTML1: TMenuItem;
    HTMLdocumentandload1: TMenuItem;
    DisassembleCOMProgram1: TMenuItem;
    SelectedHTMLdocument1: TMenuItem;
    DebugOutput: TMemo;
    N3: TMenuItem;
    UserManual1: TMenuItem;
    Options1: TMenuItem;
    MakeAssembleProcessDocument1: TMenuItem;
    OutputDebugInformationtofile1: TMenuItem;
    GettingStarted1: TMenuItem;
    ExportListtocfile1: TMenuItem;
    procedure About1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Assemble1Click(Sender: TObject);
    procedure AssembleandRun1Click(Sender: TObject);
    procedure OpcodeListing1Click(Sender: TObject);
    procedure HTML1Click(Sender: TObject);
    procedure HTMLdocumentandload1Click(Sender: TObject);
    procedure DisassembleCOMProgram1Click(Sender: TObject);
    procedure SelectedHTMLdocument1Click(Sender: TObject);
    procedure UserManual1Click(Sender: TObject);
    procedure MakeAssembleProcessDocument1Click(Sender: TObject);
    procedure WndProc(var message : TMessage);  override;
    procedure OutputDebugInformationtofile1Click(Sender: TObject);
    procedure GettingStarted1Click(Sender: TObject);
    procedure ExportListtocfile1Click(Sender: TObject);
  private
    pASMProgramName: string;
    procedure LoadFile(fn: string);
    function GetASMProgramName: string;
    procedure SetASMProgramName(NewName: string);
    { Private declarations }
  public
    { Public declarations }
    property ASMProgramName: string read GetASMProgramName write SetASMProgramName;
    //ASMProgramName: string;
  end;
  function GetProgDir: string;

var
  MainFrm: TMainFrm;

const
   InstructionSetFN = 'instruction set.txt';
   INIFName = 'Program1.ASM'; // initial source file
   HelpDir = '\Help';

   // OpenDialog filter indexes
   oiASM = 1; // for editing code
   oiCOM = 2; // for disassembling com files
   oiEXE = 3; // for disassembling EXE programs

   // SaveDialog filter indexes
   siASM = 1; // saving source code
   siHTML = 2; // exporting code to HTML
   siCOM = 3; // assembling a com program
   siTXT = 4; // for selecting file to save debug data into

implementation
uses AssemblerU,StringManiU, ShellAPI;
{$R *.DFM}

function TMainFrm.GetASMProgramName: string;
begin
     result:=pASMProgramName;
end;

procedure TMainFrm.SetASMProgramName(NewName: string);
begin
     Caption:='MyAssembler - '+ShortenName(NewName);
     pASMProgramName:=NewName;
end;

function GetProgDir: string;
var
  x: integer;
begin
     result:=Application.Exename;
     x:=length(result);
     while (x>1)and(result[x]<>'\') do
           dec(x);
     result:=copy(result,1,x-1);
end;


procedure TMainFrm.About1Click(Sender: TObject);
begin
     ShowMessage('MyAssembler v1.08'+#13+'Created by Josh G.');
end;

procedure tMainFrm.WndProc(var message : TMessage);
var //path  : String;
    twm   : TWMDropFiles;
    count : Integer;
    a     : Integer;
    aFile : array[0..255] of Char;
    fname : String;
    fext  : String;
begin
  if (message.Msg = WM_DROPFILES) then
  begin

    twm := TWMDropFiles(message);
    count := DragQueryFile(twm.drop, $FFFFFFFF, nil, 0);

    for a:=0 to count-1 do
    begin
         DragQueryFile(twm.Drop, a, aFile, 256);
         fname := extractFileName(aFile);
         fext  := extractFileExt(aFile);
         LoadFile(afile);
    end;
  end else inherited WndProc(message);
end;

procedure TMainFrm.FormDestroy(Sender: TObject);
begin
     FreeAssemblerU;
end;

procedure TMainFrm.FormActivate(Sender: TObject);
begin
     AssemblerU.MakeAssembleProcessDoc:=MakeAssembleProcessDocument1.Checked;
end;

procedure TMainFrm.Exit1Click(Sender: TObject);
begin
     Close;
end;

procedure TMainFrm.LoadFile(fn: string);
var
  ext1: string;
begin
     ext1:=LowerCase(MyGetExtention(fn));
     if (ext1='asm')or(ext1='inc')or(ext1='txt') then
     begin
          CodeMemo.Lines.LoadFromFile(OpenDialog1.FileName);
          if ext1='asm' then
             ASMProgramName:=fn;
     end
     else if ext1='com' then
         DisassembleCOMProgram(CodeMemo.Lines,OpenDialog1.FileName)
     else if ext1='exe' then
          DisassembleEXEProgram(CodeMemo.Lines, OpenDialog1.FileName)
     else
         ShowMessage('unable to load the file called, "'+fn+
         '" because the extention is not recognized.');
end;

procedure TMainFrm.Open1Click(Sender: TObject);
begin
     if OpenDialog1.Execute then
     begin
          LoadFile(OpenDialog1.FileName);
     end;
end;

procedure TMainFrm.SaveAs1Click(Sender: TObject);
begin
     if SaveDialog1.Execute then
     begin
          case SaveDialog1.FilterIndex of
           siASM: begin
                      ASMProgramName:=GetFNWithExtentionAs(SaveDialog1.FileName,'asm');
                      CodeMemo.Lines.SaveToFile(ASMProgramName);
                  end;
           siHTML: MakeSourceCodeHTMLDocument(CodeMemo.Lines,SaveDialog1.FileName,ASMProgramName);
           siCOM: AssembleTStringsToFile(CodeMemo.Lines,SaveDialog1.FileName);
          end;
     end;
end;

procedure MyHandleParameters;
// Load the program's parameter strings and execute any commands that might be in them.
var
  CurrentP,ext1: string;
  x: integer;
  CloseAfter: boolean; // true when the program is to be closed after handling the parameters
  OutputFileName: string;
  SourceFileName: string;
begin
     if ParamCount > 0 then
     begin // if a command-line option is included
           x:=0;
           CloseAfter:=false;
           OutputFileName:='';
           SourceFileName:='';
           while x<=ParamCount do // loop through parameters
           begin
                CurrentP:=ParamStr(x);
                ext1:=MyGetExtention(CurrentP);
                if (CurrentP='-o')or(ext1='com') then
                begin
                     CloseAfter:=true;
                     if not (ext1='com') then
                     begin
                          inc(x);
                          CurrentP:=ParamStr(x);
                     end;
                     OutputFileName:=CurrentP;
                end
                else if (CurrentP='-s')or(ext1='asm') then
                begin
                     if not (ext1='asm') then
                     begin
                          inc(x);
                          CurrentP:=ParamStr(x);
                     end;
                     SourceFileName:=CurrentP;
                end
                else if (CurrentP='-l') then
                begin
                     inc(x);
                     CurrentP:=ParamStr(x);
                     MainFrm.LoadFile(CurrentP);
                end
                else if (CurrentP='-e') then
                begin
                     inc(x);
                     CurrentP:=ParamStr(x);
                     OutputDebug.FileName:=CurrentP;
                     OutputDebug.OutputToGUI:=false;
                end
                else
                if CurrentP='noclose' then
                   CloseAfter:=false
                else if CurrentP='makeprocdoc' then
                begin
                     MainFrm.MakeAssembleProcessDocument1.Checked:=true;
                     MakeAssembleProcessDoc:=true;
                end;
                inc(x);
           end;
           if (SourceFileName<>'') then
           begin
                if OutputFileName<>'' then
                begin
                     ext1:=MyGetExtention(OutputFileName);
                     { This part will be changed in the future so output can be
                     to html, com, exe... depending on the extention of the output file }
                     AssembleSourceFileToProgramFile(SourceFileName,OutputFileName);
                end
                else
                    CloseAfter:=false;
           end;
           if CloseAfter then
              application.terminate; // close the program
     end;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
     ASMProgramName:=GetProgDir+'\'+INIFName;
     InitializeAssemblerU;
     OpenDialog1.FileName:=ASMProgramName;
     SaveDialog1.FileName:=ASMProgramName;
     DragAcceptFiles( Self.Handle, True );
     AssemblerU.LoadInstructionSet(GetProgDir+'\'+InstructionSetFN);
     AssemblerU.MakeAssembleProcessDoc:=MakeAssembleProcessDocument1.Checked;
     MyHandleParameters;
end;

procedure TMainFrm.Save1Click(Sender: TObject);
begin
     CodeMemo.Lines.SavetoFile(ASMProgramName);
end;

procedure TMainFrm.Assemble1Click(Sender: TObject);
begin
     AssembleTStringsToFile(CodeMemo.Lines,ASMPRogramName);
end;

procedure TMainFrm.AssembleandRun1Click(Sender: TObject);
var
  fn: string;
begin
     fn:=AssembleTStringsToFile(CodeMemo.Lines,ASMPRogramName);
     ExecuteFile(fn,fn);
end;

procedure TMainFrm.OpcodeListing1Click(Sender: TObject);
var
  fn: string;
begin
     fn:=GetProgDir+'instruction set.html';
     fn:=MakeHTMLOpcodeTable(fn); // make HTML document
     ExecuteFile(fn,fn); // open this new HTML document
end;

procedure TMainFrm.HTML1Click(Sender: TObject);
begin
     MakeSourceCodeHTMLDocument(CodeMemo.Lines,ASMProgramName,ASMProgramName);
     // make HTML document
end;

procedure TMainFrm.HTMLdocumentandload1Click(Sender: TObject);
var
  fn: string;
begin
     fn:=MakeSourceCodeHTMLDocument(CodeMemo.Lines,ASMProgramName,ASMProgramName);
     // make HTML document
     ExecuteFile(fn,fn); // open this new HTML document
end;

procedure TMainFrm.DisassembleCOMProgram1Click(Sender: TObject);
// This feature is not working yet.
begin
     OpenDialog1.FilterIndex:=oiCOM; // show com files for opening
     Open1Click(Sender);
     OpenDialog1.FilterIndex:=oiASM;
end;

procedure TMainFrm.SelectedHTMLdocument1Click(Sender: TObject);
begin
     SaveDialog1.FilterIndex:=siHTML;
     SaveAs1Click(Sender);
     SaveDialog1.FilterIndex:=siASM;
end;

procedure TMainFrm.UserManual1Click(Sender: TObject);
var
   fn: string;
begin
     fn:= GetProgDir+HelpDir+'\MyAssembler Manual.html';
     ExecuteFile(fn,GetProgDir); // open the user manual
end;

procedure TMainFrm.MakeAssembleProcessDocument1Click(Sender: TObject);
begin
     MakeAssembleProcessDocument1.Checked:=not MakeAssembleProcessDocument1.Checked;
     MakeAssembleProcessDoc:=MakeAssembleProcessDocument1.Checked;
end;

procedure TMainFrm.OutputDebugInformationtofile1Click(Sender: TObject);
begin
     OutputDebug.OutputToGUI:=OutputDebugInformationToFile1.Checked;
     OutputDebugInformationToFile1.Checked:=not OutputDebugInformationToFile1.Checked;
     if not OutputDebug.FileSet then
     begin
          SaveDialog1.FilterIndex:=siTXT;
          if SaveDialog1.Execute then
             OutputDebug.FileName:=SaveDialog1.FileName;
          SaveDialog1.FilterIndex:=siASM;
     end;
     { if the file name isn't set and this is not outputting to the GUI but
     instead a file, open a dialog to let the user select the file to save the debug data to}
end;

procedure TMainFrm.GettingStarted1Click(Sender: TObject);
var
   fn: string;
begin
     fn:= GetProgDir+HelpDir+'\Getting Started.html';
     ExecuteFile(fn,GetProgDir); // open the user manual
end;

procedure TMainFrm.ExportListtocfile1Click(Sender: TObject);
begin
     MakeOpcodeHeader;
end;

end.
