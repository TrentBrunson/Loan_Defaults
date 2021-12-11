USE [Loans]
GO

/****** Object:  Table [dbo].[origination]    Script Date: 12/10/2021 2:04:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[origination](
	[CreditScore] [numeric](18, 0) NULL,
	[FirstPaymentDate] [varchar](50) NULL,
	[FirstTimeHomebuyerFlag] [varchar](50) NULL,
	[MaturityDate] [varchar](50) NULL,
	[MetStatArea] [varchar](50) NULL,
	[MortgageInsurancePercentage] [numeric](18, 0) NULL,
	[NumberUnits] [numeric](18, 0) NULL,
	[OccupancyStatus] [varchar](50) NULL,
	[OriginalCombineLoantovalue] [numeric](18, 0) NULL,
	[OriginalDebttoIncomeRatio] [numeric](18, 0) NULL,
	[OriginalUPB] [numeric](18, 0) NULL,
	[OriginalLoantoValue] [numeric](18, 0) NULL,
	[OriginalInterestRate] [numeric](6, 3) NULL,
	[Channel] [varchar](50) NULL,
	[PrepaymentPenaltyMortFlag] [varchar](50) NULL,
	[Amortization Type] [varchar](50) NULL,
	[PropertyState] [varchar](50) NULL,
	[PropertyType] [varchar](50) NULL,
	[PostalCode] [numeric](18, 0) NULL,
	[LoanSequenceNum] [varchar](50) NULL,
	[LoanPurpose] [varchar](50) NULL,
	[OriginalLoanTerm] [numeric](18, 0) NULL,
	[NumberBorrowers] [numeric](18, 0) NULL,
	[SellerName] [varchar](50) NULL,
	[ServicerName] [varchar](50) NULL,
	[SuperConformingFlag] [varchar](50) NULL,
	[PreHARPLoanSeqNum] [varchar](50) NULL,
	[ProgramIndicator] [varchar](50) NULL,
	[HARPIndicator] [varchar](50) NULL,
	[PropertyValuationModel] [numeric](18, 0) NULL,
	[InterestOnlyIndicator] [varchar](50) NULL
) ON [PRIMARY]
GO

