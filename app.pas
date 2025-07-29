unit app;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  ComCtrls, ExtCtrls, investment_logic;

type

  { TinvestmentCalculatorForm }

  TinvestmentCalculatorForm = class(TForm)
    ToggleButton: TButton;
    calculateButton: TButton;
    initInvestmentInput: TEdit;
    annoInvestmentInput: TEdit;
    expectedReturnInput: TEdit;
    durationInput: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    resultGrid: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Timer1: TTimer;
    procedure calculateButtonClick(Sender: TObject);
    procedure initInvestmentInputChange(Sender: TObject);
    procedure expectedReturnInputChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ToggleButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
         AnimatingOut: Boolean;
  public

  end;

var
  investmentCalculatorForm: TinvestmentCalculatorForm;

implementation

{$R *.lfm}

{ TinvestmentCalculatorForm }

procedure TinvestmentCalculatorForm.calculateButtonClick(Sender: TObject);
var
  input: TInvestmentInput;
  resultData: TInvestmentResult;
  I: Integer;
begin
     if not TryStrToFloat(initInvestmentInput.Text, input.InitialInvestment) or
     not TryStrToFloat(annoInvestmentInput.Text, input.AnnualInvestment) or
     not TryStrtoFloat(expectedReturnInput.Text, input.ExpectedReturn) or
     not TryStrToInt(durationInput.Text, input.Duration) then
     begin
       Dialogs.ShowMessage('Invalid input!');
       Exit;
     end;

     // Calculate results
     resultData := CalculateInvestmentResults(Input);

     // Example: show results in messages or populate a grid
     for I := 0 to High(resultData) do
     begin
       //Dialogs.ShowMessage(Format(
       //   'Year %d: Value=%.2f, Interest=%.2f, Invested=%.2f, Total Interest=%.2f',
       //   [resultData[I].Year,
       //    resultData[I].ValueEndOfYear,
       //    resultData[I].Interest,
       //    resultData[I].TotalAmountInvested,
       //    resultData[I].TotalInterest]
       // ));
      // Set grid rows = header + data rows
      resultGrid.RowCount := input.Duration + 1;

      // Set resultGrid to be visible
      resultGrid.Visible := True;

      // Fill grid rows
      resultGrid.Cells[0, I + 1] := InttoStr(resultData[I].Year);
      resultGrid.Cells[1, i + 1] := FormatFloat('0.00', resultData[I].Interest);
      resultGrid.Cells[2, i + 1] := FormatFloat('0.00', resultData[I].ValueEndOfYear);
      resultGrid.Cells[3, i + 1] := FormatFloat('0.00', 0);
      resultGrid.Cells[4, i + 1] := FormatFloat('0.00', resultData[I].TotalInterest);
      resultGrid.Cells[5, i + 1] := FormatFloat('0.00', resultData[I].TotalAmountInvested);
     end;
end;

procedure TinvestmentCalculatorForm.initInvestmentInputChange(Sender: TObject);
begin

end;

procedure TinvestmentCalculatorForm.expectedReturnInputChange(Sender: TObject);
begin

end;

procedure TinvestmentCalculatorForm.FormCreate(Sender: TObject);
begin

     // Offcanvas setting
     Panel1.Left := 0;
     Panel1.Visible:= False;
     Panel1.Width := 0;
     AnimatingOut := False;
     // Compute investment result grid
    resultGrid.ColCount := 6;
    resultGrid.RowCount := 2;  // 1 header + 1 empty data row

    resultGrid.Cells[0, 0] := 'Year';
    resultGrid.Cells[1,0] := 'Interest Earned';
    resultGrid.Cells[2,0] := 'Value End of Year';
    resultGrid.Cells[3,0] := 'Annual Investment';
    resultGrid.Cells[4,0] := 'Total Interest';
    resultGrid.Cells[5,0] := 'Total Amount Invested';
end;

procedure TinvestmentCalculatorForm.Label1Click(Sender: TObject);
begin

end;

procedure TinvestmentCalculatorForm.Label5Click(Sender: TObject);
begin

end;

procedure TinvestmentCalculatorForm.FormResize(Sender: TObject);
begin
    Panel1.Height := ClientHeight;
end;

procedure TinvestmentCalculatorForm.ToggleButtonClick(Sender: TObject);
begin
    AnimatingOut := Panel1.Visible;
    Timer1.Enabled := True;
    Dialogs.ShowMessage('TO Button Clicked!');
end;

procedure TinvestmentCalculatorForm.Timer1Timer(Sender: TObject);
const
  StepSize = 20;
begin
    if AnimatingOut then
        begin
          // Slide out to left
          if Panel1.Width > 0 then
             Panel1.Width := Panel1.Width - Stepsize
          else
            begin
              Panel1.Visible := False;
              Timer1.Enabled := False;
            end;
        end
    else
    begin
     // Slide in from left
     if not Panel1.Visible then
        begin
          Panel1.Width := 0;
          Panel1.Visible := True;
        end;
     if Panel1.Width < 200 then
        Panel1.Width := Panel1.Width + StepSize
     else
       Timer1.Enabled := False;
    end;
end;

end.

