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
    Process: TAction;
    Button1: TButton;
    InFile: TLabel;
    OpenDialog1: TOpenDialog;
    ErrMsg: TLabel;
    Button3: TButton;
    StatusBar1: TStatusBar;
    Stop: TAction;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure SetInputExecute(Sender: TObject);
    procedure ProcessUpdate(Sender: TObject);
    procedure ProcessExecute(Sender: TObject);
    procedure StopExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    bc: TBarCoder;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

const
  NoInFile = 'Входной файл не выбран';

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopExecute(self);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  InFile.Caption:=NoInFile;
end;

procedure TForm2.ProcessExecute(Sender: TObject);
begin
  Process.Enabled:=False;
  StatusBar1.Panels[0].Text:='Обработка...';
  Stop.Enabled:=True;
  ErrMsg.Caption:='';
  bc:=TBarCoder.Create(InFile.Caption);
end;

procedure TForm2.ProcessUpdate(Sender: TObject);
begin
  if InFile.Caption = NoInFile then
    Exit;
  if Stop.Enabled then
    Exit;
//  ErrMsg.Visible:=False;
  Process.Enabled:=True;
end;

procedure TForm2.SetInputExecute(Sender: TObject);
begin
 if OpenDialog1.Execute then
  begin
    InFile.Caption:=OpenDialog1.FileName;
  end;
end;

procedure TForm2.StopExecute(Sender: TObject);
begin
  if Assigned(bc) then
    bc.Terminate;
  StatusBar1.Panels[0].Text:='Обработка отменена';
end;

end.
