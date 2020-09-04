unit BarCoder;

interface

uses
  System.Classes;

type
  TBarCoder = class(TThread)
  private
    FPath: string;
    FError: string;
    FStatus: string;
    procedure UpdateGUI;
    procedure UpdateStatus;
  protected
    procedure Execute; override;
  public
    constructor Create(Path: string);
  end;

implementation

uses
  System.Win.ComObj, System.Variants, System.StrUtils, System.Types, SysUtils,
  Generics.Collections, GUI, System.DateUtils;

const
  FirstSheet = 1;
  FirstRow = 1;
  DELIM = ';';
  AllHeaders = 'GOODSCODE;BARCODE';
  GCOL = 1;
  BCOL = 2;
  TextFormat = '@';

{ BarCoder }

constructor TBarCoder.Create(Path: string);
begin
  FPath:=Path;
  inherited Create;
end;

procedure TBarCoder.Execute;
const
  FirstSheet = 1;
  FirstRow = 1;
  DELIM = ';';
  AllHeaders = 'GOODSCODE;BARCODE';
  GCOL = 1;
  BCOL = 2;
  TextFormat = '@';
  UpdatePeriod = 1;
var
  ExcelApp, InBook, OutBook, InSheet, OutSheet: OleVariant;
  headers: TStringDynArray;
  col: integer;
  InRow, OutRow: integer;
  gcode, bcode, bcodes: string;
  codes: TDictionary<string, TList<string>>;
  rows: TDictionary<string, integer>;
  t: TTime;
  ccount: integer;
begin
  FError:='';
  t:=Time;
  try
    ExcelApp:=CreateOleObject('Excel.Application');
    InBook:=ExcelApp.Workbooks.Open(FPath);
    InSheet:=InBook.Worksheets[FirstSheet];
    headers:=SplitString(AllHeaders, DELIM);
    for col:=Low(headers) to High(headers) do
      if InSheet.Cells.Item[FirstRow, col + 1].Text <> headers[col] then
        raise Exception.Create(Format('Неверная структура файла. Не найден столбец %d "%s"',
          [col + 1, headers[col]]));
    InRow:=FirstRow + 1;
    Outrow:=FirstRow + 1;
    codes:=TDictionary<string, TList<string>>.Create;
    rows:=TDictionary<string, integer>.Create;
    OutBook:=ExcelApp.Workbooks.Add;
    OutSheet:=OutBook.Worksheets[FirstSheet];
    for col:=Low(headers) to High(headers) do
      OutSheet.Cells.Item[FirstRow, col + 1].Value:=headers[col];
    while Length(InSheet.Cells.Item[InRow, GCOL].Text) > 0 do
    begin
      if Terminated then
      begin
        InBook.Close(False);
        OutBook.Close(False);
        ExcelApp.Quit;
        Synchronize(UpdateGUI);
        Exit;
      end;
      gcode:=InSheet.Cells.Item[InRow, GCOL].Text;
      if not codes.ContainsKey(gcode) then
        codes.Add(gcode, TList<string>.Create);
      codes.Items[gcode].Add(InSheet.Cells.Item[InRow, BCOL].Text);
      if not rows.ContainsKey(gcode) then
      begin
        rows.Add(gcode, OutRow);
        OutSheet.Cells.Item[OutRow, GCOL].Value:=gcode;
        Inc(OutRow);
      end;
      Inc(InRow);
      if SecondsBetween(Time, t) > UpdatePeriod then
      begin
        FStatus:=Format('Обработка строк: %d', [InRow]);
        UpdateStatus;
        t:=Time;
      end;
    end;
    InBook.Close(False);
    ccount:=0;
    for gcode in codes.Keys do
    begin
      if Terminated then
      begin
        ExcelApp.Visible:=True;
        Exit;
      end;
      bcodes:='';
      for bcode in codes.Items[gcode] do
      begin
        if Length(bcodes) > 0 then
          bcodes:=bcodes + DELIM;
        bcodes:=bcodes + bcode;
      end;
      OutRow:=rows.Items[gcode];
      OutSheet.Cells.Item[OutRow, BCOL].NumberFormat:=TextFormat;
      OutSheet.Cells.Item[OutRow, BCOL].Value:=bcodes;
      Inc(ccount);
      if SecondsBetween(Time, t) > UpdatePeriod then
      begin
        FStatus:=Format('Группировка кодов: %d', [ccount]);
        UpdateStatus;
        t:=Time;
      end;
    end;
    Synchronize(UpdateGUI);
    ExcelApp.Visible:=True;
  except
    on e: Exception do
    begin
      if e is EOleSysError then
        FError:='Ошибка запуска Excel. Возможно, программа Excel не установлена.'
      else
        FError:=e.Message;
      if not VarIsEmpty(ExcelApp) then
        ExcelApp.Quit;
      Synchronize(UpdateGUI);
    end;
  end;
end;

procedure TBarCoder.UpdateGUI;
begin
  Form2.Process.Enabled:=True;
  Form2.Stop.Enabled:=False;
  if Length(FError) > 0 then
  begin
    Form2.ErrMsg.Caption:=FError;
    Form2.StatusBar1.Panels[0].Text:='';
  end;
end;

procedure TBarCoder.UpdateStatus;
begin
  Form2.StatusBar1.Panels[0].Text:=FStatus;
end;

end.
