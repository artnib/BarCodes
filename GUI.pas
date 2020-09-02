unit GUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Actions,
  Vcl.ActnList, Vcl.ComCtrls, BarCoder;

type
  TForm2 = class(TForm)
    ActionList1: TActionList;
    SetInput: TAction;
    SetOutput: TAction;
    Process: TAction;
    Button1: TButton;
    Button2: TButton;
    InFile: TLabel;
    OutFile: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ErrMsg: TLabel;
    Button3: TButton;
    StatusBar1: TStatusBar;
    Stop: TAction;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure SetInputExecute(Sender: TObject);
    procedure SetOutputExecute(Sender: TObject);
    procedure ProcessUpdate(Sender: TObject);
    procedure ProcessExecute(Sender: TObject);
    procedure StopExecute(Sender: TObject);
  private
    bc: TBarCoder;
  end;

var
  Form2: TForm2;

implementation

uses
  BarCode, Diagnostics;

{$R *.dfm}

const
  NoInFile = 'Входной файл не выбран';
  NoOutFile = 'Выходной файл не выбран';

procedure TForm2.FormCreate(Sender: TObject);
begin
  InFile.Caption:=NoInFile;
  OutFile.Caption:=NoOutFile;
end;

procedure TForm2.ProcessExecute(Sender: TObject);
var
  sw: TStopWatch;
begin
  Process.Enabled:=False;
  StatusBar1.Panels[0].Text:='Обработка...';
  Stop.Enabled:=True;
  bc:=TBarCoder.Create(InFile.Caption);
end;

procedure TForm2.ProcessUpdate(Sender: TObject);
begin
  if (InFile.Caption = NoInFile) {or (OutFile.Caption = NoOutFile)} then
    Exit;
  if Stop.Enabled then
    Exit;
  ErrMsg.Visible:=False;
  Process.Enabled:=True;
end;

procedure TForm2.SetInputExecute(Sender: TObject);
begin
 if OpenDialog1.Execute then
  begin
    InFile.Caption:=OpenDialog1.FileName;
  end;
end;

procedure TForm2.SetOutputExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    OutFile.Caption:=SaveDialog1.FileName;
  end;
end;

procedure TForm2.StopExecute(Sender: TObject);
begin
  if Assigned(bc) then
    bc.Terminate;
  StatusBar1.Panels[0].Text:='Обработка отменена';
end;

end.
