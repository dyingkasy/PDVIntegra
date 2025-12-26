program PDVIntegra;

uses
  Vcl.Forms,
  uPDVINT in 'uPDVINT.pas' {Form1},
  PDVIntegration in 'PDVIntegration.pas',
  PDVStorage in 'PDVStorage.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
