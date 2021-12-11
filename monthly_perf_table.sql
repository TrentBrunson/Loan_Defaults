USE [Loans]
GO

/****** Object:  Table [dbo].[monthly_performance]    Script Date: 12/10/2021 2:03:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[monthly_performance](
	[LoanNumber] [varchar](50) NULL,
	[MonthReportPeriod] [varchar](50) NULL,
	[CurrentActualUPB] [numeric](18, 0) NULL,
	[CurrentLoanDelinquencyStatus] [varchar](50) NULL,
	[LoanAge] [numeric](18, 0) NULL,
	[RemainingMonthstoMaturity] [numeric](18, 0) NULL,
	[DefectSettlementDate] [varchar](50) NULL,
	[ModificationFlag] [varchar](50) NULL,
	[ZeroBalanceCode] [varchar](50) NULL,
	[ZeroBalEffectiveDate] [varchar](50) NULL,
	[CurrentIntRate] [numeric](8, 3) NULL,
	[CurrentDeferredUPB] [numeric](18, 0) NULL,
	[DDLPI_DueDateLastPaidInstallment] [varchar](50) NULL,
	[MIRecoveries] [varchar](50) NULL,
	[NetSalesProceeds] [varchar](50) NULL,
	[Non_MIRecoveries] [varchar](50) NULL,
	[Expenses] [varchar](50) NULL,
	[LegalCosts] [varchar](50) NULL,
	[MxAndPreservationCosts] [varchar](50) NULL,
	[TaxesandInsurance] [varchar](50) NULL,
	[MiscExpenses] [varchar](50) NULL,
	[ActualLossCalc] [varchar](50) NULL,
	[ModificationCost] [varchar](50) NULL,
	[StepModificationFlag] [varchar](50) NULL,
	[DeferredPaymentPlan] [varchar](50) NULL,
	[EstimatedLoanToValue] [numeric](18, 0) NULL,
	[ZeroBalRemovalUPB] [varchar](50) NULL,
	[DelinqAccruedInt] [varchar](50) NULL,
	[DelinqDuetoDisaster] [varchar](50) NULL,
	[BorrowAssistStatusCode] [varchar](50) NULL,
	[CurrentMonthModCost] [varchar](50) NULL,
	[IntBearingUPB] [numeric](12, 2) NULL
) ON [PRIMARY]
GO

