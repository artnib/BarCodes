unit GUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Actions,
  Vcl.ActnList, Vcl.ComCtrls;

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
    procedure FormCreate(Sender: TObject);
    procedure SetInputExecute(Sender: TObject);
    procedure SetOutputExecute(Sender: TObject);
    procedure ProcessUpdate(Sender: TObject);
    procedure ProcessExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
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
  //MessageDlg('error', mtError, [mbOK], 0);
end;

procedure TForm2.ProcessExecute(Sender: TObject);
var
  sw: TStopWatch;
begin
  try
    Process.Enabled:=False;
    StatusBar1.Panels[0].Text:='Обработка...';
    sw:=TStopWatch.StartNew;
    GroupCodes(InFile.Caption{, OutFile.Caption});
    StatusBar1.Panels[0].Text:=Format('Время обработки, мс: %d',
      [sw.ElapsedMilliseconds]);
    Process.Enabled:=True;
  except
    on e: Exception do
    begin
      MessageDlg(e.Message, mtError, [mbOK], 0);
      Process.Enabled:=True;
    end;
  end;
end;

procedure TForm2.ProcessUpdate(Sender: TObject);
begin
  if (InFile.Caption = NoInFile) {or (OutFile.Caption = NoOutFile)} then
    Exit;
  {if InFile.Caption = OutFile.Caption then
  begin
    ErrMsg.Caption:='Входной и выходной файлы должны быть разными.';
    ErrMsg.Visible:=True;
    Process.Enabled:=False;
    Exit;
  end;}
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

end.
