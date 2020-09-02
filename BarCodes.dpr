program BarCodes;

uses
  Vcl.Forms,
  GUI in 'GUI.pas' {Form2},
  BarCoder in 'BarCoder.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
