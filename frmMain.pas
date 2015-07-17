{
        PatchMe
        Copyright © 2014, poxitron
        This file is part of PatchMe.

    PatchMe is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    PatchMe is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with PatchMe.  If not, see <http://www.gnu.org/licenses/>.
}

unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Winapi.ShellAPI,
  INIFiles, Vcl.ExtCtrls, Vcl.Buttons, System.Zip, System.UITypes, System.Types, Vcl.Menus;

type
  TForm1 = class(TForm)
    BorrarTodo_Button: TButton;
    Borrar_Button: TButton;
    Buffer_ComboBox: TComboBox;
    CompressFiles_CheckBox: TCheckBox;
    Crear_Button: TButton;
    DeleteFiles_CheckBox: TCheckBox;
    Destino_Button: TButton;
    Destino_ListBox: TListBox;
    Destino_OpenDialog: TOpenDialog;
    Destino_PopupMenu: TPopupMenu;
    Estado_Label: TLabel;
    Buffer_Label: TLabel;
    MB_Label: TLabel;
    Origen_Label: TLabel;
    Destino_Label: TLabel;
    N1: TMenuItem;
    N2: TMenuItem;
    Origen_Button: TButton;
    Origen_ListBox: TListBox;
    Origen_OpenDialog: TOpenDialog;
    Origen_PopupMenu: TPopupMenu;
    Panel_Buffer: TPanel;
    Panel_Central: TPanel;
    Parche_SaveDialog: TSaveDialog;
    SelecAll_Origen: TMenuItem;
    SeleccAll_Destino: TMenuItem;
    SelectNone_Destino: TMenuItem;
    SelectNone_Origen: TMenuItem;
    Sort_Destino: TMenuItem;
    Sort_Origen: TMenuItem;
    GridPanel1: TGridPanel;
    Panel_Inferior: TPanel;
    xdeltaFileNames_CheckBox: TCheckBox;
    xdeltaFileNamesOriegn_Label: TLabel;
    xdeltaFileNamesDestino_Label: TLabel;
    procedure BorrarTodo_ButtonClick(Sender: TObject);
    procedure Borrar_ButtonClick(Sender: TObject);
    procedure CompressFiles_CheckBoxClick(Sender: TObject);
    procedure Crear_ButtonClick(Sender: TObject);
    procedure Destino_ButtonClick(Sender: TObject);
    procedure Destino_ListBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Destino_PopupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Origen_ButtonClick(Sender: TObject);
    procedure Origen_ListBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Origen_PopupClick(Sender: TObject);
    procedure xdeltaFileNamesDestino_LabelClick(Sender: TObject);
    procedure xdeltaFileNamesOriegn_LabelClick(Sender: TObject);

  private
    { Private declarations }
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);

  public
    { Public declarations }

  end;

  { TMyThread }
  TMyThread = class(TThread)
  protected
    procedure Execute; override;
  end;

var
  Form1: TForm1;
  INI: TINIFile;
  ArchivoOrigen, ArchivoDestino, Archivoxdelta: String;
  RutaParche, NombreParche: String;
  RutaEjecutable: String;
  LatestSourcePath, LatestDestinationPath, LatestPatchPath: String;

implementation

uses
  MyFunctions;

{$R *.dfm}
{------------------------------------------------------------------------------
-------------------------------- Procedimientos -------------------------------}
procedure AsignarVariables;
begin
  RutaParche := ExtractFilePath(Form1.Parche_SaveDialog.FileName);
  NombreParche := ExtractFileNameOnly(Form1.Parche_SaveDialog.FileName);
end;

procedure DeshabilitarComponentes;
var
  i: Integer;
begin
  for i := Form1.ComponentCount - 1 downto 0 do
  begin
    if Form1.Components[i] is TButton then
      TButton(Form1.Components[i]).Enabled := False;
  end;
  Form1.Buffer_ComboBox.Enabled := False;
  Form1.Origen_ListBox.Enabled := False;
  Form1.Destino_ListBox.Enabled := False;
  Form1.xdeltaFileNames_CheckBox.Enabled := False;
  Form1.xdeltaFileNamesOriegn_Label.Enabled := False;
  Form1.xdeltaFileNamesDestino_Label.Enabled := False;
end;

procedure HabilitarComponentes;
var
  i: Integer;
begin
  for i := Form1.ComponentCount - 1 downto 0 do
  begin
    if Form1.Components[i] is TButton then
      TButton(Form1.Components[i]).Enabled := True;
  end;
  Form1.Buffer_ComboBox.Enabled := True;
  Form1.Origen_ListBox.Enabled := True;
  Form1.Destino_ListBox.Enabled := True;
  Form1.xdeltaFileNames_CheckBox.Enabled := True;
  Form1.xdeltaFileNamesOriegn_Label.Enabled := True;
  Form1.xdeltaFileNamesDestino_Label.Enabled := True;
end;

//Arrastrar y soltar archivos desde Windows
procedure TForm1.AppMessage(var Msg: TMsg; var Handled: Boolean);
var
  QtyDroppedFiles, FileIndex: Integer;
  pDroppedFilename: array[0..255] of Char;
  s: string;
begin
  if Msg.message = WM_DROPFILES then
  begin
    QtyDroppedFiles := DragQueryFile(Msg.wParam, Cardinal(-1), nil, 0);
    try
      for FileIndex := 0 to QtyDroppedFiles - 1 do
      begin
        DragQueryFile(Msg.wParam, FileIndex, @pDroppedFilename, sizeof(pDroppedFilename));
        if Msg.hwnd = Origen_ListBox.Handle then
        begin
          //comprueba si es un archivo y, si no es un acceso directo, lo añade
          if FileExists(PChar(@pDroppedFilename)) and not SameText(ExtractFileExt(PChar(@pDroppedFilename)), '.lnk') then
          begin
            Origen_ListBox.Items.Add(PChar(@pDroppedFilename));
          end;
          //comprueba si es una carpeta y, si no está vacía, añade su contenido
          if DirectoryExists(PChar(@pDroppedFilename)) and not DirectoryIsEmpty(PChar(@pDroppedFilename)) then
          begin
            FindAll(PChar(@pDroppedFilename) + '\*.*', faArchive, Origen_ListBox.Items);
          end;
          SetLBScrollExt(Origen_ListBox);
        end;
        if Msg.hwnd = Destino_ListBox.Handle then
        begin
          //comprueba si es un archivo y, si no es un acceso directo, lo añade
          if FileExists(PChar(@pDroppedFilename)) and not SameText(ExtractFileExt(PChar(@pDroppedFilename)), '.lnk') then
          begin
            Destino_ListBox.Items.Add(PChar(@pDroppedFilename));
          end;
          //comprueba si es una carpeta y, si no está vacía, añade su contenido
          if DirectoryExists(PChar(@pDroppedFilename)) and not DirectoryIsEmpty(PChar(@pDroppedFilename)) then
          begin
            FindAll(PChar(@pDroppedFilename) + '\*.*', faArchive, Destino_ListBox.Items);
          end;
          SetLBScrollExt(Destino_ListBox);
        end;
      end;
    finally
      DragFinish(Msg.wParam);
      Handled := True;
    end;
  end;
end;

//Ejecuta xdelta y procesar los archivos de los listbox
procedure Ejecutarxdelta;
var
  b, i, n: integer;
  buffer, parametros, ejecutable: String;
begin
  n := 0;
  b := StrToInt(Form1.Buffer_ComboBox.Text) * 1048576;
  buffer := '-B' + IntToStr(b);
  try
    if Form1.xdeltaFileNames_CheckBox.Checked then
    begin //Genera el archivo .xdelta con el nombre del archivo de destino
      for i := 0 to Form1.Origen_ListBox.items.count - 1 do
      begin
        ArchivoOrigen := Form1.Origen_ListBox.Items.Strings[i];
        ArchivoDestino := Form1.Destino_ListBox.Items.Strings[i];
        case Form1.xdeltaFileNamesDestino_Label.Visible of
          True: Archivoxdelta := RutaParche + ExtractFileNameOnly(ArchivoDestino) + '.xdelta';
          False: Archivoxdelta := RutaParche + ExtractFileNameOnly(ArchivoOrigen) + '.xdelta';
        end;
        parametros := buffer + ' -f -e -s "' + ArchivoOrigen + '" "' + ArchivoDestino + '" "' + Archivoxdelta + '"';
        ExecNewProcess(RutaEjecutable + '\xdelta.exe ' + parametros, SW_HIDE, True);
      end;
    end
    else
    begin //Genera el archivo .xdelta con el nombre file01.xdelta
      for i := 0 to Form1.Origen_ListBox.items.count - 1 do
      begin
        inc(n);
        ArchivoOrigen := Form1.Origen_ListBox.Items.Strings[i];
        ArchivoDestino := Form1.Destino_ListBox.Items.Strings[i];
        Archivoxdelta := RutaParche + 'file' + AddLeadingZeroes(n, 2) + '.xdelta';
        parametros := buffer + ' -f -e -s "' + ArchivoOrigen + '" "' + ArchivoDestino + '" "' + Archivoxdelta + '"';
        ExecNewProcess(RutaEjecutable + '\xdelta.exe ' + parametros, SW_HIDE, True);
      end;
    end;
  finally
  end;
end;

//Crea el archivo .bat
procedure CrearBatch;
var
  AStringList: TStringList;
  i, n: integer;
begin
  n := 0;
  try
    AStringList := TStringList.Create;
    AStringList.Add('@echo off');
    //AStringList.Add('chcp 1252>NUL');
    AStringList.Add('chcp 65001>NUL');
    AStringList.Add('echo Archivo generado con PatchMe' + GetAppVersion);
    AStringList.Add('echo.');
    if Form1.xdeltaFileNames_CheckBox.Checked then
    begin
      for i := 0 to Form1.Origen_ListBox.items.count - 1 do
      begin
        ArchivoOrigen := ExtractFileName(Form1.Origen_ListBox.Items.Strings[i]);
        ArchivoDestino := ExtractFileName(Form1.Destino_ListBox.Items.Strings[i]);
        case Form1.xdeltaFileNamesDestino_Label.Visible of
          True: Archivoxdelta := ExtractFileNameOnly(ArchivoDestino) + '.xdelta';
          False: Archivoxdelta := ExtractFileNameOnly(ArchivoOrigen) + '.xdelta';
        end;
        AStringList.Add('if not exist "' + ArchivoOrigen + '" goto nofile');
        AStringList.Add('echo Parcheando el archivo: ' + ArchivoOrigen);
        AStringList.Add('xdelta.exe -f -d -s "' + ArchivoOrigen + '" "' + Archivoxdelta + '" "' + ArchivoDestino + '"');
        AStringList.Add('echo Parche aplicado.');
        AStringList.Add('echo.');
      end;
    end
    else
    begin
      for i := 0 to Form1.Origen_ListBox.items.count - 1 do
      begin
        inc(n);
        ArchivoOrigen := ExtractFileName(Form1.Origen_ListBox.Items.Strings[i]);
        ArchivoDestino := ExtractFileName(Form1.Destino_ListBox.Items.Strings[i]);
        Archivoxdelta := 'file' + AddLeadingZeroes(n, 2) + '.xdelta';
        AStringList.Add('if not exist "' + ArchivoOrigen + '" goto nofile');
        AStringList.Add('echo Parcheando el archivo: ' + ArchivoOrigen);
        AStringList.Add('xdelta.exe -f -d -s "' + ArchivoOrigen + '" "' + Archivoxdelta + '" "' + ArchivoDestino + '"');
        AStringList.Add('echo Parche aplicado.');
        AStringList.Add('echo.');
      end;
    end;
    AStringList.Add('echo Proceso finalizado.');
    AStringList.Add('pause');
    AStringList.Add('exit');
    AStringList.Add(':nofile');
    AStringList.Add('echo No se ha encontrado el archivo de origen en el directorio.');
    AStringList.Add('pause');
    AStringList.Add('exit');
    AStringList.WriteBOM := False;
    AStringList.SaveToFile(RutaParche + NombreParche + '.bat', TEncoding.UTF8);
  finally
    AStringList.Free;
  end;
end;

//Crea el archivo .sh
procedure CrearSh;
var
  AStringList: TStringList;
  i, n: integer;
begin
  n := 0;
  try
    AStringList := TStringList.Create;
    AStringList.Add('#!/usr/bin/env bash');
    AStringList.Add('');
    AStringList.Add('echo "Archivo generado con PatchMe' + GetAppVersion + '"');
    AStringList.Add('echo');
    AStringList.Add('if [[ ! $(which xdelta3) ]]; then');
    AStringList.Add('  echo "No se encuentra el ejecutable de xdelta. Saliendo."');
    AStringList.Add('  exit -1');
    AStringList.Add('else');
    if Form1.xdeltaFileNames_CheckBox.Checked then
    begin
      for i := 0 to Form1.Origen_ListBox.items.count - 1 do
      begin
        ArchivoOrigen := ExtractFileName(Form1.Origen_ListBox.Items.Strings[i]);
        ArchivoDestino := ExtractFileName(Form1.Destino_ListBox.Items.Strings[i]);
        case Form1.xdeltaFileNamesDestino_Label.Visible of
          True: Archivoxdelta := ExtractFileNameOnly(ArchivoDestino) + '.xdelta';
          False: Archivoxdelta := ExtractFileNameOnly(ArchivoOrigen) + '.xdelta';
        end;
        AStringList.Add('if [[ ! -f "' + ArchivoOrigen + '" ]]; then');
        AStringList.Add('  echo "No se encuentra el fichero de origen: ' + ArchivoOrigen + '"');
        AStringList.Add('  exit -1');
        AStringList.Add('fi');
        AStringList.Add('');
        AStringList.Add('echo "Parcheando el archivo: ' + ArchivoOrigen + '"');
        AStringList.Add('xdelta3 -f -d -s "' + ArchivoOrigen + '" "' + Archivoxdelta + '" "' + ArchivoDestino + '"');
        AStringList.Add('echo "Parche aplicado."');
        AStringList.Add('');
      end;
    end
    else
    begin
      for i := 0 to Form1.Origen_ListBox.items.count - 1 do
      begin
        inc(n);
        ArchivoOrigen := ExtractFileName(Form1.Origen_ListBox.Items.Strings[i]);
        ArchivoDestino := ExtractFileName(Form1.Destino_ListBox.Items.Strings[i]);
        Archivoxdelta := 'file' + AddLeadingZeroes(n, 2) + '.xdelta';
        AStringList.Add('if [[ ! -f "' + ArchivoOrigen + '" ]]; then');
        AStringList.Add('  echo "No se encuentra el fichero de origen: ' + ArchivoOrigen + '"');
        AStringList.Add('  exit -1');
        AStringList.Add('fi');
        AStringList.Add('');
        AStringList.Add('echo "Parcheando el archivo: ' + ArchivoOrigen + '"');
        AStringList.Add('xdelta3 -f -d -s "' + ArchivoOrigen + '" "' + Archivoxdelta + '" "' + ArchivoDestino + '"');
        AStringList.Add('echo "Parche aplicado."');
        AStringList.Add('');
      end;
    end;
    AStringList.Add('echo "Proceso finalizado."');
    AStringList.Add('fi');
    AStringList.Add('');
    AStringList.Add('exit 0');
    AStringList.LineBreak := #10;
    AStringList.SaveToFile(RutaParche + NombreParche + '.sh', TEncoding.UTF8);
  finally
    AStringList.Free;
  end;
end;

//Comprime los archivos
procedure ComprimirArchivos;
var
  i, n: integer;
  AZipper: TZipFile;
begin
  n := 0;
  try
    AZipper := TZipFile.Create;
    AZipper.Open(RutaParche + NombreParche + '.zip', zmWrite);
    if Form1.xdeltaFileNames_CheckBox.Checked then
    begin
      for i := 0 to Form1.Origen_ListBox.items.count - 1 do
      begin
        case Form1.xdeltaFileNamesDestino_Label.Visible of
          True: Archivoxdelta := ExtractFileNameOnly(Form1.Destino_ListBox.Items.Strings[i]) + '.xdelta';
          False: Archivoxdelta := ExtractFileNameOnly(Form1.Origen_ListBox.Items.Strings[i]) + '.xdelta';
        end;
        AZipper.Add(RutaParche + Archivoxdelta, Archivoxdelta);
      end;
    end
    else
    begin
      for i := 0 to Form1.Origen_ListBox.items.count - 1 do
      begin
        inc(n);
        Archivoxdelta := 'file' + AddLeadingZeroes(n, 2) + '.xdelta';
        AZipper.Add(RutaParche + Archivoxdelta, Archivoxdelta);
      end;
    end;
    AZipper.Add(RutaParche + 'xdelta.exe');
    AZipper.Add(RutaParche + NombreParche + '.bat');
    AZipper.Add(RutaParche + NombreParche + '.sh');
    AZipper.Close;
  finally
    AZipper.Free;
  end;
end;

//Borra los archivos
procedure BorrarArchivos;
var
  i, n: integer;
begin
  n := 0;
  try
    if Form1.xdeltaFileNames_CheckBox.Checked then
    begin
      for i := 0 to Form1.Origen_ListBox.items.count - 1 do
      begin
        case Form1.xdeltaFileNamesDestino_Label.Visible of
          True: Archivoxdelta := ExtractFileNameOnly(Form1.Destino_ListBox.Items.Strings[i]) + '.xdelta';
          False: Archivoxdelta := ExtractFileNameOnly(Form1.Origen_ListBox.Items.Strings[i]) + '.xdelta';
        end;
        DeleteFile(RutaParche + Archivoxdelta);
      end;
    end
    else
    begin
      for i := 0 to Form1.Origen_ListBox.items.count - 1 do
      begin
        inc(n);
        Archivoxdelta := 'file' + AddLeadingZeroes(n, 2) + '.xdelta';
        DeleteFile(RutaParche + Archivoxdelta);
      end;
    end;
    DeleteFile(RutaParche + 'xdelta.exe');
    DeleteFile(RutaParche + NombreParche + '.bat');
    DeleteFile(RutaParche + NombreParche + '.sh');
  finally
  end;
end;
{------------------------- Fin de los procedimientos ---------------------------
-------------------------------------------------------------------------------}

//Carga la configuración al iniciar y más cosas
procedure TForm1.FormCreate(Sender: TObject);
var
  s: string;
begin
  try
    RutaEjecutable := ExtractFileDir(Application.ExeName);
    Form1.Caption := Application.Title + GetAppVersion;
    Application.OnMessage := AppMessage;
    DragAcceptFiles(Origen_ListBox.Handle, True);
    DragAcceptFiles(Destino_ListBox.Handle, True);
    INI := TINIFile.Create(RutaEjecutable + '\config.ini');
    DeleteFiles_CheckBox.Checked := INI.ReadBool('Config', 'DeleteFiles', True);
    CompressFiles_CheckBox.Checked := INI.ReadBool('Config', 'CompressFiles', True);
    xdeltaFileNames_CheckBox.Checked := INI.ReadBool('Config', 'xdeltaFileName', False);
    s := INI.ReadString('Config', 'xdeltaFileNameType', '1');
    if  s = '1' then
    begin
      xdeltaFileNamesDestino_Label.Visible := True;
      xdeltaFileNamesOriegn_Label.Visible := False;
    end
    else
    begin
      xdeltaFileNamesDestino_Label.Visible := False;
      xdeltaFileNamesOriegn_Label.Visible := True;
    end;
    LatestSourcePath := INI.ReadString('Config', 'LatestSourcePath', '');
    LatestDestinationPath := INI.ReadString('Config', 'LatestDestinationPath', '');
    LatestPatchPath := INI.ReadString('Config', 'LatestPatchPath', '');
    Form1.Top := INI.ReadInteger('Position', 'Top', Screen.DesktopHeight div 2 - 260);
    Form1.Left := INI.ReadInteger('Position', 'Left', Screen.DesktopWidth div 2 - 250);
    Form1.Width := INI.ReadInteger('Position', 'Width', 500);
    Form1.Height := INI.ReadInteger('Position', 'Height', 520);
  finally
    INI.Free;
  end;
end;

//Guarda la configuración al salir y más cosas
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    INI := TINIFile.Create(RutaEjecutable + '\config.ini');
    INI.WriteBool('Config', 'DeleteFiles', DeleteFiles_CheckBox.Checked);
    INI.WriteBool('Config', 'CompressFiles', CompressFiles_CheckBox.Checked);
    INI.WriteBool('Config', 'xdeltaFileName', xdeltaFileNames_CheckBox.Checked);
    case xdeltaFileNamesDestino_Label.Visible of
      True: INI.WriteString('Config', 'xdeltaFileNameType', '1');
      False: INI.WriteString('Config', 'xdeltaFileNameType', '0');
    end;
    INI.WriteString('Config', 'LatestSourcePath', LatestSourcePath);
    INI.WriteString('Config', 'LatestDestinationPath', LatestDestinationPath);
    INI.WriteString('Config', 'LatestPatchPath', LatestPatchPath);
    INI.WriteInteger('Position', 'Top', Form1.Top);
    INI.WriteInteger('Position', 'Left', Form1.Left);
    INI.WriteInteger('Position', 'Width', Form1.Width);
    INI.WriteInteger('Position', 'Height', Form1.Height);
  finally
    INI.Free;
  end;
  DragAcceptFiles(Origen_ListBox.Handle, False);
  DragAcceptFiles(Destino_ListBox.Handle, False);
end;

//Ordena los archivos arrastrándolos
procedure TForm1.ListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  ListBox: TListBox;
  i, TargetIndex: Integer;
  SelectedItems: TStringList;
begin
  Assert(Source = Sender);
  ListBox := Sender as TListBox;
  TargetIndex := ListBox.ItemAtPos(Point(X, Y), False);
  if TargetIndex <> -1 then
  begin
    SelectedItems := TStringList.Create;
    try
      ListBox.Items.BeginUpdate;
      try
        for i := ListBox.Items.Count - 1 downto 0 do
        begin
          if ListBox.Selected[i] then
          begin
            SelectedItems.AddObject(ListBox.Items[i], ListBox.Items.Objects[i]);
            ListBox.Items.Delete(i);
            if i < TargetIndex then
              dec(TargetIndex);
          end;
        end;
        for i := SelectedItems.Count - 1 downto 0 do
        begin
          ListBox.Items.InsertObject(TargetIndex, SelectedItems[i], SelectedItems.Objects[i]);
          ListBox.Selected[TargetIndex] := True;
          inc(TargetIndex);
        end;
      finally
        ListBox.Items.EndUpdate;
      end;
    finally
      SelectedItems.Free;
    end;
  end;
end;

procedure TForm1.Origen_ListBoxDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Source = Origen_ListBox;
end;

procedure TForm1.Destino_ListBoxDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Source = Destino_ListBox;
end;

//Añade archivos de origen al pulsar el botón
procedure TForm1.Origen_ButtonClick(Sender: TObject);
var
  i: Integer;
begin
  Origen_OpenDialog.InitialDir := LatestSourcePath;
  if Origen_OpenDialog.Execute then
  begin
    LatestSourcePath := ExtractFilePath(Origen_OpenDialog.FileName);
    for i := 0 to Origen_OpenDialog.Files.Count - 1 do
    begin
      Origen_ListBox.Items.Add(Origen_OpenDialog.Files[i]);
    end;
  end;
  SetLBScrollExt(Origen_ListBox);
end;

//Añade archivos de destino al pulsar el botón
procedure TForm1.Destino_ButtonClick(Sender: TObject);
var
  i: Integer;
begin
  Destino_OpenDialog.InitialDir := LatestDestinationPath;
  if Destino_OpenDialog.Execute then
  begin
    LatestDestinationPath := ExtractFilePath(Destino_OpenDialog.FileName);
    for i := 0 to Destino_OpenDialog.Files.Count - 1 do
    begin
      Destino_ListBox.Items.Add(Destino_OpenDialog.Files[i]);
    end;
  end;
  SetLBScrollExt(Destino_ListBox);
end;

//Elimina los items seleccionados de los ListBox
procedure TForm1.Borrar_ButtonClick(Sender: TObject);
var
  i: Integer;
begin
  for i := Origen_ListBox.Items.Count - 1 downto 0 do
  begin
    if Origen_ListBox.Selected[i] then
      begin
        Origen_ListBox.Items.Delete(i);
        SetLBScrollExt(Origen_ListBox);
      end;
  end;
  for i := Destino_ListBox.Items.Count - 1 downto 0 do
  begin
    if Destino_ListBox.Selected[i] then
      begin
        Destino_ListBox.Items.Delete(i);
        SetLBScrollExt(Destino_ListBox);
      end;
  end;
end;

//Elimina todos los items de los ListBox
procedure TForm1.BorrarTodo_ButtonClick(Sender: TObject);
begin
  Origen_ListBox.Clear;
  Destino_ListBox.Clear;
  SetLBScrollExt(Origen_ListBox);
  SetLBScrollExt(Destino_ListBox);
end;

//Acción del popup menú para el Origen_listbox
procedure TForm1.Origen_PopupClick(Sender: TObject);
var
  i: Integer;
begin
    case (Sender as TMenuItem).Tag of
      1: //ordenar por nombre
      begin
        Origen_ListBox.Sorted := False;
        Origen_ListBox.Sorted := True;
        DragAcceptFiles(Origen_ListBox.Handle, True);
      end;
      2: begin //seleccionar todo
         for I := 0 to (Origen_ListBox.Items.Count - 1) do
           Origen_ListBox.Selected[i] := True;
         end;
      3: begin //deseleccionar todo
         for I := 0 to (Origen_ListBox.Items.Count - 1) do
           Origen_ListBox.Selected[i] := False;
         end;
    end;
end;

//Acción del popup menú para el Destino_listbox
procedure TForm1.Destino_PopupClick(Sender: TObject);
var
  i: Integer;
begin
    case (Sender as TMenuItem).Tag of
      1: //ordenar por nombre
      begin
        Destino_ListBox.Sorted := False;
        Destino_ListBox.Sorted := True;
        DragAcceptFiles(Destino_ListBox.Handle, True);
      end;
      2: begin //seleccionar todo
         for I := 0 to (Destino_ListBox.Items.Count - 1) do
           Destino_ListBox.Selected[i] := True;
         end;
      3: begin //deseleccionar todo
         for I := 0 to (Destino_ListBox.Items.Count - 1) do
           Destino_ListBox.Selected[i] := False;
         end;
    end;
end;

//Activa y desactiva la compresión de archivos
procedure TForm1.CompressFiles_CheckBoxClick(Sender: TObject);
begin
  case CompressFiles_CheckBox.Checked of
    True: DeleteFiles_CheckBox.Enabled := True;
    False: DeleteFiles_CheckBox.Enabled := False;
  end;
end;

procedure TForm1.xdeltaFileNamesDestino_LabelClick(Sender: TObject);
begin
  xdeltaFileNamesDestino_Label.Visible := False;
  xdeltaFileNamesOriegn_Label.Visible := True;
end;

procedure TForm1.xdeltaFileNamesOriegn_LabelClick(Sender: TObject);
begin
  xdeltaFileNamesDestino_Label.Visible := True;
  xdeltaFileNamesOriegn_Label.Visible := False;
end;

//Ejecuta el hilo, y este todo el proceso
procedure TForm1.Crear_ButtonClick(Sender: TObject);
var
  o, d: integer;
  AThread: TMyThread;
begin
  o := Origen_ListBox.Items.Count;
  d := Destino_ListBox.Items.Count;
  Parche_SaveDialog.InitialDir := LatestPatchPath;
  Parche_SaveDialog.FileName := ExtractFileName(Parche_SaveDialog.FileName);
  if o <> d then
    MessageDlg('El número de archivos en origen y destino no coincide.', mtError, [mbOK], 0)
  else
  if (o = 0) and (d = 0) then
    MessageDlg('Debes añadir como mínimo un archivo de origen y uno de destino.', mtError, [mbOK], 0)
  else
  if not FileExists(Pchar(RutaEjecutable + '\xdelta.exe')) then
    MessageDlg('El ejecutable xdelta.exe no se encuentra en la misma carpeta que PatchMe.', mtError, [mbOK], 0)
  else
  if Parche_SaveDialog.Execute then
  begin
    LatestPatchPath := ExtractFilePath(Parche_SaveDialog.FileName);
    try
      AThread := TMyThread.Create(True);
      AThread.FreeOnTerminate := true;
      AThread.Start;
    finally
    end;
  end;
end;

procedure TMyThread.Execute;
begin
  try
    DeshabilitarComponentes;
    Form1.Estado_Label.Caption := 'Estado: Creando el parche...';
    AsignarVariables;
    Ejecutarxdelta;
    CrearBatch;
    CrearSh;
    CopyFile(Pchar(RutaEjecutable + '\xdelta.exe'), Pchar(RutaParche + 'xdelta.exe'), False);
    if Form1.CompressFiles_CheckBox.Checked then
    begin
      Form1.Estado_Label.Caption := 'Estado: Comprimiendo los archivos...';
      ComprimirArchivos;
    end;
    if Form1.DeleteFiles_CheckBox.Checked and Form1.DeleteFiles_CheckBox.Enabled then
    begin
      Form1.Estado_Label.Caption := 'Estado: Borrando los archivos intermedios...';
      BorrarArchivos;
    end;
  finally
    HabilitarComponentes;
    Form1.Estado_Label.Caption := 'Estado: Parche creado satisfactoriamente.';
  end;
end;

end.
