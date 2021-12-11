
-- Looking for code 01 and 06 which are not Defaulted
SELECT ZeroBalanceCode 
FROM monthly_performance
WHERE ZeroBalanceCode <> '';

SELECT DISTINCT ZeroBalanceCode 
FROM monthly_performance; -- '01' AND '96' ONLY 2 ZeroBalanceCode and rest has a Blank Code 

SELECT ZeroBalanceCode 
FROM monthly_performance
WHERE ZeroBalanceCode = 96; -- 100 ROWS

SELECT ZeroBalanceCode 
FROM monthly_performance
WHERE ZeroBalanceCode = 01; -- 7946

-- creting New column with clean_ZeroBalanceCode
ALTER TABLE monthly_performance
ADD Clean_ZeroBalanceCode VARCHAR(50) NULL;

-- Setting values 1 and 0 to New column Clean_ZeroBalanceCode based on codes from ZeroBalanceCode column
UPDATE monthly_performance										--4,771,722 rows affected
SET Clean_ZeroBalanceCode = 
		CASE
			WHEN ZeroBalanceCode IN ('','96') THEN 1					--	1 means record had a DEFAULT
			WHEN ZeroBalanceCode IN ('01','06') THEN 0			--	0 means record did not have a DEFAULT
		END; 

 /* SELECT LoanNumber, Clean_ZeroBalanceCode  FROM monthly_performance
WHERE Clean_ZeroBalanceCode = '0'; Just testing the new values to make sure updated */

-- Following loans delinquet due to disaster with the loan age
SELECT LoanNumber, LoanAge, DelinqDuetoDisaster 
FROM monthly_performance
WHERE DelinqDuetoDisaster <> ''
ORDER BY LoanAge;

SELECT DelinqAccruedInt 
FROM monthly_performance
WHERE DelinqAccruedInt <> '';


-- Original Actual UnpaidBalance , Int.Rate and LoanTerm Number for first time Home buyers;
SELECT LoanSequenceNum,OriginalUPB, OriginalInterestRate, OriginalLoanTerm, PropertyState
FROM origination
WHERE FirstTimeHomebuyerFlag ='Y'
ORDER BY PropertyState; -- 108,537 loans is a first time home buyer

-- State wise Total loan 
SELECT PropertyState, COUNT(*) AS [# of Loans]
FROM origination
GROUP BY PropertyState
ORDER BY PropertyState; -- 54 rows

-- Current Actual UnpaidBalance , Int.Rate and RamainingMonths to maturity with Loan Number
SELECT LoanNumber, CurrentActualUPB, CurrentIntRate, RemainingMonthstoMaturity 
FROM monthly_performance
WHERE RIGHT(MonthReportPeriod,2) = 02; -- 375,979 rows

-- Showing Loan Number, First payment date, Maturity date , Original Amount, Original Int.Rate and Service Name
-- whose Credit Score > 600
SELECT LoanSequenceNum, FirstPaymentDate, MaturityDate, OriginalUPB, OriginalInterestRate, ServicerName, CreditScore
FROM origination
WHERE CreditScore > 600; --1,214,258 rows

--This query shows for each loan is for how many years with OriginalUnpaidBalance and finance bank name
SELECT LoanSequenceNum, OriginalUPB, CAST(LEFT(MaturityDate,4) AS INT) - CAST(LEFT(FirstPaymentDate,4) AS INT) AS [# of Years],
OriginalInterestRate, ServicerName
FROM origination; -- 1,214,275 ROWS

-- Displays Loans with Paid Balnce for more than 3 months from the actual origination loan date
SELECT o.LoanSequenceNum, o.OriginalUPB, m.CurrentActualUPB, (o.OriginalUPB - m.CurrentActualUPB) AS [Paid Balance],
o.OriginalInterestRate, m.CurrentIntRate, o.PropertyState
FROM monthly_performance m JOIN origination o
ON m.LoanNumber = o.LoanSequenceNum
WHERE m.LoanAge > 3
ORDER BY o.PropertyState;  -- 383,723 ROWS

-- SHOWS No of Loans with each postal code and has total of 888 rows
SELECT PostalCode, COUNT(*) AS [# of Loans]
FROM origination
GROUP BY PostalCode
ORDER BY PostalCode;

SELECT * FROM
monthly_performance
WHERE ZeroBalEffectiveDate <> '';

SELECT DISTINCT CurrentLoanDelinquencyStatus
FROM monthly_performance; -- 0,1,2,3, and 4 these are delinquency status but not find any connection with these status with any other rows

SELECT DISTINCT OccupancyStatus
FROM origination; -- P, S, AND I ONLY 3 Occupancy status but don't know the meaning for this character

SELECT ActualLossCalc FROM monthly_performance
WHERE ActualLossCalc <> ''; -- NO DATA

SELECT ModificationCost FROM monthly_performance
WHERE ModificationCost <> ''; -- ONLY 14 ROWS

SELECT DelinqAccruedInt FROM monthly_performance
WHERE DelinqAccruedInt <> ''; -- 0 rows

SELECT DDLPI_DueDateLastPaidInstallment FROM monthly_performance
WHERE DDLPI_DueDateLastPaidInstallment <> ''; -- 8046 ROWS

SELECT DefectSettlementDate FROM monthly_performance
WHERE DefectSettlementDate <> ''; -- 100 rows

SELECT NetSalesProceeds FROM monthly_performance
WHERE Expenses <> ''; -- 0 rows

SELECT Expenses FROM monthly_performance
WHERE NetSalesProceeds <> ''; -- 0 rows

SELECT StepModificationFlag FROM monthly_performance
WHERE StepModificationFlag <> ''; -- 0 rows

SELECT EstimatedLoanToValue FROM monthly_performance
WHERE EstimatedLoanToValue <> 0; -- 4,771,722 rows

SELECT ZeroBalRemovalUPB FROM monthly_performance
WHERE ZeroBalRemovalUPB <> ''; -- 8046 rows

SELECT DISTINCT BorrowAssistStatusCode FROM monthly_performance
WHERE BorrowAssistStatusCode <> ''; -- R AND F  2 CODES ONLY

SELECT DISTINCT CurrentMonthModCost FROM monthly_performance
WHERE CurrentMonthModCost <> ''; 14 ROWS

SELECT DISTINCT  MortgageInsurancePercentage
FROM origination; -- 23 ROWS 

SELECT DISTINCT SuperConformingFlag
FROM origination; -- Only 'Y' flag allocated with 54128 rows rest the rows has blank value

SELECT  SuperConformingFlag
FROM origination
WHERE SuperConformingFlag <> ''; -- 54128 ROWS 

SELECT  PreHARPLoanSeqNum, HARPIndicator
FROM origination
WHERE PreHARPLoanSeqNum <> '' OR HARPIndicator <> ''; -- O ROWS

SELECT  InterestOnlyIndicator
FROM origination; -- This has only 1 Indicator 'N' and 1,214,275 rows available

SELECT DISTINCT SellerName
FROM origination
ORDER BY SellerName; -- 21 ROWS With different sellername

SELECT DISTINCT PostalCode
FROM origination; -- 888 rows with different postal codes

SELECT DISTINCT LoanPurpose
FROM origination; -- C, P, N Three different codes for the LoanPurpose

SELECT COUNT(*) LoanPurpose
FROM origination; -- 1214275 rows available FOR LoanPurpose

SELECT DISTINCT [Amortization Type]
FROM origination; -- Only 1 type available which is FRM  and has 1214275 rows available

SELECT DISTINCT NumberUnits
FROM origination;  -- 4 different types of NumberUnits lable with 1,2,3,4 and has a total rows of 1214275

SELECT DISTINCT NumberBorrowers
FROM origination; -- 5 Different types of codes for NumberBorrowers listed as 1,2,3,4,5 and has a total rows of 1214275

SELECT DISTINCT PrepaymentPenaltyMortFlag
FROM origination; -- Only 1 flag which is lable as 'N' and has 1214275 rows available



