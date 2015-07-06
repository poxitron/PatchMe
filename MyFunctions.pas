{
        File: MyFunctions.pas
        License: GPLv3
        This file is part of PatchMe.
}


unit MyFunctions;

interface

uses
 Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
 Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Winapi.ShellAPI,
 INIFiles, Vcl.ExtCtrls, Vcl.Buttons, System.Zip, System.UITypes;

function GetAppVersion:string;  // código extraído del blog de choirul ihwan
procedure ExecNewProcess(ProgramName: String; ShowCmd: DWORD; Wait: Boolean);  // código de Chris Bray
function ExtractFileNameOnly(const FileName: string): string;
function AddLeadingZeroes(const aNumber, Length : integer) : string; // código de Zarko Gajic, de la web about.com
procedure FindAll (const Path: String; Attr: Integer; List: TStrings); // el autor del código es desconocido
procedure FileSearch(const PathName: string; const Extensions: string; var lstFiles: TStringList);  // código extraído de http://stackoverflow.com
function DirectoryIsEmpty(Directory: string): Boolean;  // código de RaverJK
procedure SetLBScrollExt(L: TListBox);  // el autor del código es desconocido


implementation

function GetAppVersion:string;
var
 Size, Size2: DWord;
 Pt, Pt2: Pointer;
 begin
   Size := GetFileVersionInfoSize(PChar (ParamStr (0)), Size2);
   if Size > 0 then
   begin
     GetMem (Pt, Size);
     try
       GetFileVersionInfo (PChar (ParamStr (0)), 0, Size, Pt);
       VerQueryValue (Pt, '\', Pt2, Size2);
       with TVSFixedFileInfo (Pt2^) do
       begin
         Result:= ' '+
         IntToStr (HiWord (dwFileVersionMS)) + '.' +
         IntToStr (LoWord (dwFileVersionMS)) + '.' +
         IntToStr (HiWord (dwFileVersionLS)) + '.' +
         IntToStr (LoWord (dwFileVersionLS));
       end;
     finally
     FreeMem (Pt);
   end;
 end;
end;

procedure ExecNewProcess(ProgramName: String; ShowCmd: DWORD; Wait: Boolean);
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CreateOK: Boolean;
begin
    { fill with known state }
  FillChar(StartInfo,SizeOf(TStartupInfo),#0);
  FillChar(ProcInfo,SizeOf(TProcessInformation),#0);
  StartInfo.cb := SizeOf(TStartupInfo);
  StartInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
  StartInfo.wShowWindow := ShowCmd;
  CreateOK := CreateProcessW(nil, PChar(ProgramName), nil, nil,False,
              CREATE_NEW_PROCESS_GROUP+NORMAL_PRIORITY_CLASS,
              nil, nil, StartInfo, ProcInfo);
    { check to see if successful }
  if CreateOK then
    begin
        { may or may not be needed. Usually wait for child processes }
      if Wait then
        WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    end
  else
    begin
       MessageDlg('No ha sido posible ejecutar: '+ProgramName, mtError, [mbOK], 0);
     end;
  CloseHandle(ProcInfo.hProcess);
  CloseHandle(ProcInfo.hThread);
end;

function ExtractFileNameOnly(const FileName: string): string;
begin
  Result := ChangeFileExt(ExtractFileName(FileName), '');
end;

function AddLeadingZeroes(const aNumber, Length : integer) : string;
begin
   result := System.SysUtils.Format('%.*d', [Length, aNumber]) ;
{ Usage: AddLeadingZeroes(2005, 10);
Will result in a '0000002005' string value. }
end;

//Devuelve todos los archivos de una carpeta
procedure FindAll (const Path: String; Attr: Integer; List: TStrings);
var
   SearchResult: TSearchRec;
   EOFound: Boolean;
begin
   EOFound := False;
   if FindFirst(Path, Attr, SearchResult) < 0 then
     exit
   else
     while not EOFound do
     begin
       if not SameText(ExtractFileExt(SearchResult.Name),'.lnk') then //Don't add the .lnk files
         List.Add(extractfilepath(Path)+SearchResult.Name);
         EOFound:= FindNext(SearchResult) <> 0;
     end;
   FindClose(SearchResult);
//Uso: FindAll(PChar(@pDroppedFilename)+'\*.*',faArchive,Origen_ListBox.Items)
end;
 
//Devuelve todos los archivos de una carpeta usando máscaras
procedure FileSearch(const PathName: string; const Extensions: string; var lstFiles: TStringList);
const
  FileMask = '*.*';
var
  Rec: TSearchRec;
  Path: string;
begin
  Path := IncludeTrailingPathDelimiter(PathName);
  if FindFirst(Path + FileMask, faAnyFile - faDirectory, Rec) = 0 then
    try
      repeat
        if AnsiPos(ExtractFileExt(Rec.Name), Extensions) > 0 then
          lstFiles.Add(Path + Rec.Name);
      until FindNext(Rec) <> 0;
    finally
      System.SysUtils.FindClose(Rec);
    end;

  if FindFirst(Path + '*.*', faDirectory, Rec) = 0 then
    try
      repeat
        if ((Rec.Attr and faDirectory) <> 0) and (Rec.Name <> '.') and
          (Rec.Name <> '..') then
          FileSearch(Path + Rec.Name, Extensions, lstFiles);
      until FindNext(Rec) <> 0;
    finally
      FindClose(Rec);
    end;
//Uso: FileSearch('C:\Temp', '.txt;.tmp;.exe;.doc', FileList);
end;

//Comprueba si el directorio está vacío
function DirectoryIsEmpty(Directory: string): Boolean;
var
  SR: TSearchRec;
  i: Integer;
begin
  Result := False;
  FindFirst(IncludeTrailingPathDelimiter(Directory) + '*', faAnyFile, SR);
  for i := 1 to 2 do
    if (SR.Name = '.') or (SR.Name = '..') then
      Result := FindNext(SR) <> 0;
  FindClose(SR);
end;

//Muestra automáticamente la barra horizontal del Listbox
procedure SetLBScrollExt(L: TListBox);
var
  i, max, x : integer;
begin
  if L.Items.Count = 0 then
    max := -10
  else
  begin
    max := 0;
    for i := 0 to L.Items.Count -1 do
    begin
      x := L.Canvas.TextWidth(L.Items[i]);
      if x > max then
        max := x;
    end;
  end;
  Inc(max,6);
  SendMessage(L.Handle, LB_SetHorizontalExtent, max+5, 0);
end;

end.
