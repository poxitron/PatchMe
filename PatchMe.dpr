program PatchMe;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  MyFunctions in 'MyFunctions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'PatchMe';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
