
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

-- Following loans delinquet due to disaster with the loan age
SELECT LoanNumber, LoanAge, DelinqDuetoDisaster 
FROM monthly_performance
WHERE DelinqDuetoDisaster <> ''
ORDER BY LoanAge; --1938 rows, max loan age 4

SELECT DelinqAccruedInt 
FROM monthly_performance
WHERE DelinqAccruedInt <> ''; -- 0


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

-- Current Actual UnpaidBalance , Int.Rate and RemainingMonths to maturity with Loan Number
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
ORDER BY PostalCode; -- 888 rows

SELECT * FROM
monthly_performance
WHERE ZeroBalEffectiveDate <> ''; -- 8046

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

/*
Selecting subset of columns for predictive analysis

Target: Zero Balance Code: 96, 

Top featuers:
	From Origination table:
		Credit Score
		CLTV
		DTI
		LTV
		Other possibilities:
			1st time homebuyer
			Original unpaid balance
			property state
			property type
			postal code
			loan purpose
			# of borrower
	From Monthly table:
		Current actual unpaid balance
		Current loan delinquency status
		Zero Balance Code

*/

-- create data warngling tables
SELECT * INTO monthly_analysis FROM monthly_performance;
SELECT * INTO origination_analysis FROM origination;

-- how to join the tables
SELECT DISTINCT LoanSequenceNum FROM origination_analysis;
-- 1214275 rows
SELECT COUNT(LoanSequenceNum) FROM origination_analysis;
--1214275 rows; all values distinct

SELECT DISTINCT LoanNumber FROM monthly_analysis;
--1214259 rows

-- checking for unique values another way
SELECT LoanSequenceNum, COUNT(LoanSequenceNum) as cnt 
	FROM origination_analysis
	GROUP BY LoanSequenceNum HAVING COUNT(LoanSequenceNum) > 1;
	-- zero results

SELECT LoanNumber, COUNT(LoanNumber) as cnt 
	FROM monthly_analysis
	GROUP BY LoanNumber HAVING COUNT(LoanNumber) > 1 ORDER BY cnt;
	-- counts from 2-5; makes sense because this table has monthly reporting
	-- join monthly into origination

-- are the values in each other's table for joining?
SELECT * FROM monthly_analysis
	WHERE LoanNumber NOT IN (SELECT DISTINCT LoanSequenceNum FROM origination_analysis);
-- 0 rows

SELECT * FROM origination_analysis
	WHERE LoanSequenceNum NOT IN (SELECT DISTINCT LoanSequenceNum FROM monthly_analysis);
-- 0 rows

/*

*/

--check it worked
SELECT TOP 1000 * FROM monthly_analysis;
SELECT TOP 1000 * FROM origination_analysis;

-- creting New column with clean_ZeroBalanceCode
ALTER TABLE monthly_analysis
ADD Clean_ZeroBalanceCode NUMERIC NULL;

-- Setting values 1 and 0 to New column Clean_ZeroBalanceCode based on codes from ZeroBalanceCode column
-- make this easier to interpret target variable; set up for binomial logistic analysis
-- code of 96 is not in the user guide, but found it on their website as a default indidcator
UPDATE monthly_analysis				
SET Clean_ZeroBalanceCode = 
		CASE
			WHEN ZeroBalanceCode IN (01, 06) THEN 0  --	0 means record no DEFAULT
			WHEN ZeroBalanceCode IN (96, 09, 03) THEN 1	 --	1 means record did have a DEFAULT
		END; 

SELECT DISTINCT Clean_ZeroBalanceCode FROM monthly_analysis;

SELECT LoanNumber, Clean_ZeroBalanceCode  FROM monthly_analysis
WHERE Clean_ZeroBalanceCode = 0; -- Just testing the new values to make sure updated */
-- 7946 rows

SELECT LoanNumber, Clean_ZeroBalanceCode  FROM monthly_analysis
WHERE Clean_ZeroBalanceCode = 1;
-- 100 rows

SELECT LoanNumber, Clean_ZeroBalanceCode  FROM monthly_analysis
WHERE Clean_ZeroBalanceCode IS NOT NULL;
-- rows 8046 rows; matches total of the two above; good

SELECT LoanNumber, Clean_ZeroBalanceCode  FROM monthly_analysis
WHERE Clean_ZeroBalanceCode IS NULL;
-- 4769676 rows

SELECT DISTINCT CreditScore FROM origination_analysis ORDER BY CreditScore;
 -- 240 rows; 9999 is interesting

SELECT * FROM origination_analysis WHERE CreditScore = 9999;
-- credit score is the gold standard for assessing financial default risk
-- entire industry based on it; if no valid value, need to drop it
-- 267 rows; of the millions of rows - drop these for the join so don't introduce bad data

DELETE FROM origination_analysis WHERE CreditScore = 9999;
-- 267 rows removed

-- check
SELECT DISTINCT CreditScore FROM origination_analysis ORDER BY CreditScore DESC;
-- no more 9999

-- double check after some research...
SELECT Clean_ZeroBalanceCode,
	COUNT(*) CNTs
	FROM monthly_analysis
	GROUP BY Clean_ZeroBalanceCode;
	-- 1: 4763776; 0: 7946; 4763676 are blank

SELECT ZeroBalanceCode,
	COUNT(*) CNTs
	FROM monthly_analysis
	GROUP BY ZeroBalanceCode;
	-- 01: 7946; 96: 100; 4763676 are blank
-- all good

/*
CLTV values
Data Element File Type Valid Values If Not Valid
Credit Score (FICO) Origination 301 - 850 Space (3)
Mortgage Insurance Percentage (MI %) Origination 1% - 55% or 0 (000) Space (3)
Original Debt-to-Income Ratio (DTI) Origination 0%<DTI<= 65%
For HARP: 999
Original Loan-to-Value Ratio (LTV) Origination 6% - 105%
For HARP: 1% - 999%
Original Combined Loan-to-Value Ratio (CLTV) Origination 6% - 200%
For HARP: 1% - 999%
*/
SELECT DISTINCT OriginalCombineLoantovalue o
	FROM origination_analysis ORDER BY o;
	-- no negative values; good
	-- greater than 100% ratio, but since includes seondary mortgages, can be over 100%
	-- in range of 1-999%

/*
DTI values
*/
SELECT DISTINCT OriginalDebttoIncomeRatio o
	FROM origination_analysis ORDER BY o;
	-- 52 values, 1 to 51 and 999 is N/A

/*
LTV values
*/
SELECT DISTINCT OriginalLoantoValue o
	FROM origination_analysis ORDER BY o;
	-- 96 values, 3-101%

SELECT COUNT(*) FROM origination_analysis WHERE OriginalLoantoValue IS NULL;
SELECT COUNT(*) FROM origination_analysis WHERE OriginalDebttoIncomeRatio IS NULL;
SELECT COUNT(*) FROM origination_analysis WHERE OriginalCombineLoantovalue IS NULL;
-- no nulls

SELECT DISTINCT CurrentLoanDelinquencyStatus FROM monthly_analysis ORDER BY CurrentLoanDelinquencyStatus;
-- 5 values; 0-4 are all valid

SELECT DISTINCT DelinqDuetoDisaster FROM monthly_analysis ORDER BY DelinqDuetoDisaster;
-- two values yes and blank
SELECT COUNT(DelinqDuetoDisaster) cnt FROM monthly_analysis WHERE DelinqDuetoDisaster = 'Y';
-- 1938
SELECT COUNT(DelinqDuetoDisaster) cnt FROM monthly_analysis WHERE DelinqDuetoDisaster = '';
-- 4769784
SELECT COUNT(DelinqDuetoDisaster) cnt FROM monthly_analysis WHERE DelinqDuetoDisaster is NOT NULL;
-- 4771722 = total of the other two

-- make nulls like UPB field
ALTER TABLE monthly_analysis
ADD Clean_DelinqDuetoDisaster varchar NULL; -- set to length of one since only Y in this dataset

SELECT COUNT(Clean_DelinqDuetoDisaster) FROM monthly_analysis WHERE Clean_DelinqDuetoDisaster = NULL;
--
SELECT COUNT(Clean_DelinqDuetoDisaster) FROM monthly_analysis WHERE Clean_DelinqDuetoDisaster IS NOT NULL;
--0 rows
SELECT Clean_DelinqDuetoDisaster FROM monthly_analysis;
-- 4771722 rows; just as above


-- Setting values 1 and 0 to New column Clean_ZeroBalanceCode based on codes from ZeroBalanceCode column


UPDATE monthly_analysis				
SET Clean_DelinqDuetoDisaster = DelinqDuetoDisaster WHERE DelinqDuetoDisaster = 'Y'; 
-- 1938 rows changed - matches the count above

--validate
SELECT COUNT(Clean_DelinqDuetoDisaster) cnt FROM monthly_analysis WHERE Clean_DelinqDuetoDisaster = 'Y';
-- 1938 rows
SELECT COUNT(Clean_DelinqDuetoDisaster) cnt FROM monthly_analysis WHERE Clean_DelinqDuetoDisaster = '';
-- 0 rows - now have nulls in it

SELECT COUNT(LoanSequenceNum) cnt, PropertyState
FROM origination_analysis
WHERE FirstTimeHomebuyerFlag ='Y'
GROUP BY PropertyState
ORDER BY cnt;
 -- 108,537 loans is a first time home buyer
 -- Virgin Islands & Guam least; CA & TX most

SELECT DISTINCT OriginalUPB FROM origination_analysis;
-- 1070 rows
SELECT DISTINCT OriginalUPB FROM origination_analysis WHERE OriginalUPB IS NULL;
-- 0 rows
SELECT COUNT(OriginalUPB) FROM origination_analysis WHERE OriginalUPB > 0;
-- 1214008 rows is same as number rows in this table

SELECT COUNT(*) FROM origination_analysis;

-- state evaluations
SELECT COUNT(PropertyState) FROM origination_analysis WHERE PropertyState = '';
-- 0 rows
SELECT COUNT(DISTINCT(PropertyState)) FROM origination_analysis;
--54 

SELECT COUNT(PropertyType) FROM origination_analysis WHERE PropertyType = '';
-- 0 rows
SELECT COUNT(DISTINCT(PropertyType)) FROM origination_analysis;
-- 5; 
SELECT DISTINCT PropertyType FROM origination_analysis;
--the values match the online guide; no nulls

SELECT COUNT(PostalCode) FROM origination_analysis WHERE PostalCode IS NULL;
-- 0 rows
SELECT COUNT(PostalCode) FROM origination_analysis WHERE PostalCode IS NOT NULL;
-- all rows filled with a value
SELECT COUNT(DISTINCT(PostalCode)) FROM origination_analysis;
-- 888; 
SELECT DISTINCT PostalCode FROM origination_analysis ORDER BY PostalCode DESC;
-- all have two trailing zeroes as described in the guide, but what are the 3 & 4-digit codes?

SELECT PostalCode, PropertyState
	FROM origination_analysis
	WHERE LEN(PostalCode) < 5
	ORDER BY PropertyState;
-- 4 digit are new england states

SELECT PostalCode, PropertyState
	FROM origination_analysis
	WHERE LEN(PostalCode) < 4
	ORDER BY PropertyState;
-- 3 digit are US territories
-- import error; when importing, following guide from website: numeric, 5
-- forced numeric data type; this stripped the preceeding zeroes

-- fix postal code
ALTER TABLE origination_analysis
ADD Clean_PostalCode varchar(5);

UPDATE origination_analysis
	SET Clean_PostalCode = 
		CASE
			WHEN LEN(PostalCode) = 5 THEN PostalCode
			WHEN LEN(PostalCode) = 4 THEN CONCAT('0', CAST(PostalCode AS varchar))
			WHEN LEN(PostalCode) = 3 THEN '00' + PostalCode
			ELSE PostalCode
		END;
-- CASE didn't work, even when changing conditions; moving on...

UPDATE origination_analysis SET Clean_PostalCode = '00' + Clean_PostalCode 
	WHERE LEN(Clean_PostalCode) < 4;
UPDATE origination_analysis SET Clean_PostalCode = '0' + Clean_PostalCode 
	WHERE LEN(Clean_PostalCode) = 4;

SELECT COUNT(DISTINCT(Clean_PostalCode)) FROM origination_analysis;
-- 888;
SELECT DISTINCT(Clean_PostalCode) FROM origination_analysis ORDER BY Clean_PostalCode;
-- 888; worked - all 5 digits again

SELECT DISTINCT LoanPurpose FROM origination_analysis;
-- 3 values, c, p, n; all in the guide
SELECT LoanPurpose FROM origination_analysis WHERE LoanPurpose = '';
-- 0 rows
SELECT LoanPurpose FROM origination_analysis WHERE LoanPurpose IS NOT NULL;
-- 1214008 rows; matches the full data set

SELECT DISTINCT NumberBorrowers FROM origination_analysis;
-- 5 values, 1-5; how many nulls?
SELECT NumberBorrowers FROM origination_analysis WHERE NumberBorrowers IS NULL;
-- 0 rows
SELECT NumberBorrowers, COUNT(NumberBorrowers) cnt
	FROM origination_analysis 
	WHERE NumberBorrowers IS NOT NULL 
	GROUP BY NumberBorrowers
	ORDER BY COUNT(NumberBorrowers);
-- half are single borrowers; decreasing counts to 18 for 5; 
-- seems likely to not have many loans with 5+ borrowers


/*
THE BIG JOIN
JOIN on loan number in a new table
*/

SELECT o.LoanSequenceNum LoanSeqNum,
	o.CreditScore,
	o.OriginalCombineLoantovalue,
	o.OriginalDebttoIncomeRatio,
	o.OriginalUPB,
	o.OriginalLoantoValue,
	o.PropertyState,
	o.PropertyType,
	o.Clean_PostalCode PostalCode,
	o.LoanPurpose,
	o.NumberBorrowers,
	m.CurrentLoanDelinquencyStatus LoanDelinqStatus,
	m.Clean_ZeroBalanceCode ZeroBalCode,
	m.Clean_DelinqDuetoDisaster DelinqDisaster
		INTO merged_loan_data
	FROM origination_analysis o JOIN monthly_analysis m ON
		o.LoanSequenceNum = m.LoanNumber;
-- 4770815 rows affected

-- Check data table exists
SELECT TOP 1000 * FROM merged_loan_data;
-- it has 14 columns as written; NULL values populated

-- check cleaned data types
-- postal code
SELECT COUNT(DISTINCT PostalCode) FROM merged_loan_data;
-- 888 again
SELECT DISTINCT PostalCode FROM merged_loan_data ORDER BY PostalCode;
-- all 5 digits visually; now check with counts
SELECT COUNT(DISTINCT PostalCode) FROM merged_loan_data WHERE LEN(PostalCode) = 5;
-- 888 again!  good

-- check Delinquency due to disaster status
SELECT COUNT(DISTINCT DelinqDisaster) FROM merged_loan_data;
-- 1 value
SELECT DISTINCT DelinqDisaster FROM merged_loan_data;
-- Ys and nulls

-- Check Zero Balance status
SELECT COUNT(DISTINCT ZeroBalCode) FROM merged_loan_data;
-- 2 values
SELECT DISTINCT ZeroBalCode FROM merged_loan_data;
-- 0, 1, and null
SELECT COUNT(ZeroBalCode) FROM merged_loan_data WHERE ZeroBalCode = 1;
-- 100 rows
SELECT COUNT(ZeroBalCode) FROM merged_loan_data WHERE ZeroBalCode = 0;
-- 7945
SELECT COUNT(ZeroBalCode) FROM merged_loan_data WHERE ZeroBalCode IS NOT NULL;
-- 8045; rest are nulls