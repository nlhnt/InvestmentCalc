unit investment_logic;

{$mode ObjFPC}{$H+}

interface

type
  TInvestmentYearData = record
    Year: Integer;
    Interest: Double;
    ValueEndOfYear: Double;
    AnnualInvestment: Double;
    TotalInterest: Double;
    TotalAmountInvested: Double;
  end;

  TInvestmentInput = record
    InitialInvestment: Double;
    AnnualInvestment: Double;
    ExpectedReturn: Double; // in percent
    Duration: Integer;
  end;

  TInvestmentResult = array of TInvestmentYearData;

function CalculateInvestmentResults(const Data: TInvestmentInput): TInvestmentResult;

implementation

function CalculateInvestmentResults(const Data: TInvestmentInput): TInvestmentResult;
var
  InvestmentValue, InterestEarnedInYear, TotalInterest: Double;
  Year: Integer;
  ResultData: TInvestmentResult;
begin
  InvestmentValue := Data.InitialInvestment;
  SetLength(ResultData, Data.Duration);

  for Year := 1 to Data.Duration do
  begin
    InterestEarnedInYear := InvestmentValue * (Data.ExpectedReturn / 100);
    InvestmentValue := InvestmentValue + InterestEarnedInYear + Data.AnnualInvestment;
    TotalInterest := InvestmentValue - Data.AnnualInvestment * Year - Data.InitialInvestment;

    ResultData[Year - 1].Year := Year;
    ResultData[Year - 1].Interest := InterestEarnedInYear;
    ResultData[Year - 1].ValueEndOfYear := InvestmentValue;
    ResultData[Year - 1].AnnualInvestment := Data.AnnualInvestment;
    ResultData[Year - 1].TotalInterest := TotalInterest;
    ResultData[Year - 1].TotalAmountInvested := Data.InitialInvestment + Data.AnnualInvestment * Year;
  end;

  Result := ResultData;
end;

end.

