USE [WebApplication_DoTest]
GO
/****** Object:  Table [dbo].[RowProperty]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RowProperty]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RowProperty](
	[RowPropertyID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](100) NULL,
	[Name] [varchar](1000) NULL,
	[IsActive] [bigint] NULL,
	[Remarks] [varchar](1000) NULL,
	[EmployeeID_CreatedBy] [bigint] NULL,
	[EmployeeID_UpdatedBy] [bigint] NULL,
	[DateCreated] [datetime] NULL,
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_RowProperty] PRIMARY KEY CLUSTERED 
(
	[RowPropertyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Rights_Details]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Rights_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Rights_Details](
	[Rights_DetailsID] [bigint] IDENTITY(1,1) NOT NULL,
	[RightsID] [bigint] NULL,
	[System_Modules_AccessID] [bigint] NULL,
	[IsAllowed] [bit] NULL,
 CONSTRAINT [PK_Rights_Details] PRIMARY KEY CLUSTERED 
(
	[Rights_DetailsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ContactPerson_Details]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContactPerson_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ContactPerson_Details](
	[ContactPerson_DetailsID] [bigint] IDENTITY(1,1) NOT NULL,
	[ContactPersonID] [bigint] NULL,
	[PersonID] [bigint] NULL,
	[Position] [varchar](50) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_ContactPerson_Details] PRIMARY KEY CLUSTERED 
(
	[ContactPerson_DetailsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContactPerson]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContactPerson]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ContactPerson](
	[ContactPersonID] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_ContactPerson] PRIMARY KEY CLUSTERED 
(
	[ContactPersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[CallLog]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CallLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CallLog](
	[CallLogID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[CustomerID] [bigint] NULL,
	[LookupCallTopicID] [bigint] NULL,
	[ItemID] [bigint] NULL,
	[PurchaseDate] [datetime] NULL,
	[ReturnDate] [datetime] NULL,
	[RANo] [varchar](50) NULL,
	[BatchNo] [varchar](50) NULL,
	[Conversation] [varchar](max) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_CallLog] PRIMARY KEY CLUSTERED 
(
	[CallLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Bank_Account]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bank_Account]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Bank_Account](
	[Bank_AccountID] [bigint] IDENTITY(1,1) NOT NULL,
	[BankID] [bigint] NULL,
	[TransitNo] [varchar](50) NULL,
	[InstitutionNo] [varchar](50) NULL,
	[AccountNo] [varchar](50) NULL,
	[LookupID_Currency] [bigint] NULL,
	[Balance_Amount] [numeric](18, 2) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Bank_Account] PRIMARY KEY CLUSTERED 
(
	[Bank_AccountID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DocumentItem]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DocumentItem]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DocumentItem](
	[DocumentItemID] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_DocumentItem] PRIMARY KEY CLUSTERED 
(
	[DocumentItemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Person]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Person]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Person](
	[PersonID] [bigint] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[MiddleName] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[Phone] [varchar](50) NULL,
	[Mobile] [varchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[WorkEmail] [varchar](50) NULL,
	[BirthDate] [datetime] NULL,
	[BirthPlace] [varchar](50) NULL,
	[Nationality] [varchar](50) NULL,
	[BloodType] [varchar](50) NULL,
	[Religion] [varchar](50) NULL,
	[Spouse] [varchar](1000) NULL,
	[Height] [varchar](50) NULL,
	[Weight] [varchar](50) NULL,
	[SSS] [varchar](50) NULL,
	[TIN] [varchar](50) NULL,
	[PhilHealthNo] [varchar](50) NULL,
	[PagibigNo] [varchar](50) NULL,
	[System_LookupID_Gender] [bigint] NULL,
	[System_LookupID_CivilStatus] [bigint] NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Payment_CreditCard_Details]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payment_CreditCard_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Payment_CreditCard_Details](
	[Payment_CreditCard_DetailsID] [bigint] NOT NULL,
	[Payment_CreditCardID] [bigint] NULL,
	[AccountNo] [varchar](50) NULL,
	[AccountName] [varchar](100) NULL,
	[ExpirationDate] [datetime] NULL,
	[Amount] [numeric](18, 2) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Payment_CreditCard_Details] PRIMARY KEY CLUSTERED 
(
	[Payment_CreditCard_DetailsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Payment_CreditCard]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payment_CreditCard]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Payment_CreditCard](
	[Payment_CreditCardID] [bigint] IDENTITY(1,1) NOT NULL,
	[PaymentID] [bigint] NULL,
 CONSTRAINT [PK_Payment_CreditCard] PRIMARY KEY CLUSTERED 
(
	[Payment_CreditCardID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Payment_Check_Details]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payment_Check_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Payment_Check_Details](
	[Payment_Check_DetailsID] [bigint] IDENTITY(1,1) NOT NULL,
	[Payment_CheckID] [bigint] NULL,
	[AccountNo] [varchar](50) NULL,
	[AccountName] [varchar](50) NULL,
	[CheckNo] [varchar](50) NULL,
	[CheckDate] [datetime] NULL,
	[BankID] [bigint] NULL,
	[Amount] [numeric](18, 2) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Payment_Check_Details_1] PRIMARY KEY CLUSTERED 
(
	[Payment_Check_DetailsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Payment_Check]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payment_Check]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Payment_Check](
	[Payment_CheckID] [bigint] IDENTITY(1,1) NOT NULL,
	[PaymentID] [bigint] NULL,
 CONSTRAINT [PK_Payment_Check_1] PRIMARY KEY CLUSTERED 
(
	[Payment_CheckID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Payment_Cash]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payment_Cash]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Payment_Cash](
	[Payment_CashID] [bigint] IDENTITY(1,1) NOT NULL,
	[PaymentID] [bigint] NULL,
	[Amount] [numeric](18, 2) NULL,
 CONSTRAINT [PK_Payment_Cash_1] PRIMARY KEY CLUSTERED 
(
	[Payment_CashID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Payment_BankTransfer_Details]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payment_BankTransfer_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Payment_BankTransfer_Details](
	[Payment_BankTransfer_DetailsID] [bigint] IDENTITY(1,1) NOT NULL,
	[Payment_BankTransferID] [bigint] NULL,
	[BankID] [bigint] NULL,
	[AccountName] [varchar](100) NULL,
	[AccountNo] [varchar](50) NULL,
	[TransferDate] [datetime] NULL,
	[Amount] [numeric](18, 2) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Payment_BankTransfer_Details] PRIMARY KEY CLUSTERED 
(
	[Payment_BankTransfer_DetailsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Payment_BankTransfer]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payment_BankTransfer]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Payment_BankTransfer](
	[Payment_BankTransferID] [bigint] IDENTITY(1,1) NOT NULL,
	[PaymentID] [bigint] NULL,
 CONSTRAINT [PK_Payment_BankTransfer] PRIMARY KEY CLUSTERED 
(
	[Payment_BankTransferID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Payment]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Payment](
	[PaymentID] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Payment_1] PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Address]    Script Date: 10/21/2013 11:46:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Address]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Address](
	[AddressID] [bigint] IDENTITY(1,1) NOT NULL,
	[Address] [varchar](1000) NULL,
	[City] [varchar](100) NULL,
	[LookupID_States] [bigint] NULL,
	[LookupID_Country] [bigint] NULL,
	[ZipCode] [varchar](50) NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AccountingLedgerPostingPeriod]    Script Date: 10/21/2013 11:46:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountingLedgerPostingPeriod]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AccountingLedgerPostingPeriod](
	[AccountingLedgerPostingPeriodID] [bigint] IDENTITY(1,1) NOT NULL,
	[DocumentID] [bigint] NULL,
 CONSTRAINT [PK_AccountingLedgerPostingPeriod] PRIMARY KEY CLUSTERED 
(
	[AccountingLedgerPostingPeriodID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[AccountingLedgerMappingChartOfAccounts]    Script Date: 10/21/2013 11:46:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountingLedgerMappingChartOfAccounts]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AccountingLedgerMappingChartOfAccounts](
	[AccountingLedgerMappingChartOfAccountsID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[System_ModulesID] [bigint] NULL,
	[TableName] [varchar](100) NULL,
	[FieldName_ID] [varchar](100) NULL,
	[FieldName_DocNo] [varchar](100) NULL,
	[FieldName_DatePosted] [varchar](100) NULL,
	[FieldName_ChartOfAccountID] [varchar](100) NULL,
	[FieldName_Amount] [varchar](100) NULL,
	[FieldName_PartyID] [varchar](100) NULL,
	[IsDebit] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_AccountingLedgerMappingChartOfAccounts] PRIMARY KEY CLUSTERED 
(
	[AccountingLedgerMappingChartOfAccountsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AccountingLedgerMapping]    Script Date: 10/21/2013 11:46:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountingLedgerMapping]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AccountingLedgerMapping](
	[AccountingLedgerMappingID] [bigint] NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[AccountingChartOfAccountsID] [bigint] NULL,
	[System_ModulesID] [bigint] NULL,
	[TableName] [varchar](100) NULL,
	[FieldName_ID] [varchar](100) NULL,
	[FieldName_DocNo] [varchar](100) NULL,
	[FieldName_DatePosted] [varchar](100) NULL,
	[FieldName_Amount] [varchar](100) NULL,
	[FieldName_PartyID] [varchar](100) NULL,
	[IsDebit] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_AccountingLedgerMapping] PRIMARY KEY CLUSTERED 
(
	[AccountingLedgerMappingID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AccountingLedger_Posted]    Script Date: 10/21/2013 11:46:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountingLedger_Posted]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AccountingLedger_Posted](
	[AccountingLedger_PostedID] [bigint] IDENTITY(1,1) NOT NULL,
	[AccountingLedgerPostingPeriodID] [bigint] NULL,
	[AccountingChartOfAccountsID] [bigint] NULL,
	[System_ModulesID] [bigint] NULL,
	[TableName] [varchar](100) NULL,
	[SourceID] [bigint] NULL,
	[DocNo] [varchar](1000) NULL,
	[DatePosted] [datetime] NULL,
	[PartyID] [bigint] NULL,
	[Amount] [numeric](18, 2) NULL,
	[IsDebit] [bit] NULL,
 CONSTRAINT [PK_AccountingLedger_Posted] PRIMARY KEY CLUSTERED 
(
	[AccountingLedger_PostedID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AccountingLedger_Current]    Script Date: 10/21/2013 11:46:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountingLedger_Current]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AccountingLedger_Current](
	[AccountingChartOfAccountsID] [bigint] NULL,
	[System_ModulesID] [bigint] NULL,
	[TableName] [varchar](100) NULL,
	[SourceID] [bigint] NULL,
	[DocNo] [varchar](1000) NULL,
	[DatePosted] [datetime] NULL,
	[PartyID] [bigint] NULL,
	[Amount] [numeric](18, 2) NULL,
	[IsDebit] [bit] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AccountingChartOfAccounts]    Script Date: 10/21/2013 11:46:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountingChartOfAccounts]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AccountingChartOfAccounts](
	[AccountingChartOfAccountsID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[AccountingChartOfAccountsID_Parent] [bigint] NULL,
	[System_LookupID_AccountType] [bigint] NULL,
	[IsDebit] [bit] NULL,
	[LookupID_Currency] [bigint] NULL,
	[PartyID_Subsidiary] [bigint] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_AccountingChartOfAccounts] PRIMARY KEY CLUSTERED 
(
	[AccountingChartOfAccountsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[AccountingBudget_Period]    Script Date: 10/21/2013 11:46:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountingBudget_Period]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AccountingBudget_Period](
	[AccountingBudget_PeriodID] [bigint] IDENTITY(1,1) NOT NULL,
	[AccountingBudgetID] [bigint] NULL,
	[System_LookupID_BudgetPeriod] [bigint] NULL,
	[Amount] [numeric](18, 2) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_AccountingBudget_Period] PRIMARY KEY CLUSTERED 
(
	[AccountingBudget_PeriodID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[AccountingBudget]    Script Date: 10/21/2013 11:46:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountingBudget]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AccountingBudget](
	[AccountingBudgetID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[BudgetYear] [datetime] NULL,
	[AccountingChartOfAccountsID] [bigint] NULL,
	[PartyID] [bigint] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_AccountingBudget] PRIMARY KEY CLUSTERED 
(
	[AccountingBudgetID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[DocumentChartOfAccounts]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DocumentChartOfAccounts]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DocumentChartOfAccounts](
	[DocumentChartOfAccountsID] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_DocumentChartOfAccounts] PRIMARY KEY CLUSTERED 
(
	[DocumentChartOfAccountsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Document]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Document]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Document](
	[DocumentID] [bigint] IDENTITY(1,1) NOT NULL,
	[DocNo] [varchar](50) NULL,
	[DateApplied] [datetime] NULL,
	[IsPosted] [bit] NULL,
	[IsCancelled] [bit] NULL,
	[DatePosted] [datetime] NULL,
	[DateCancelled] [datetime] NULL,
	[EmployeeID_PostedBy] [bigint] NULL,
	[EmployeeID_CancelledBy] [bigint] NULL,
 CONSTRAINT [PK_Document] PRIMARY KEY CLUSTERED 
(
	[DocumentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DataObjects_Series]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataObjects_Series]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DataObjects_Series](
	[TableName] [varchar](1000) NULL,
	[LastID] [bigint] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DataObjects_Parameters]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataObjects_Parameters]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DataObjects_Parameters](
	[ParameterName] [varchar](50) NULL,
	[ParameterValue] [varchar](8000) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Customer_ShippingAddress]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer_ShippingAddress]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Customer_ShippingAddress](
	[Customer_ShippingAddressID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerID] [bigint] NULL,
	[AddressID] [bigint] NULL,
	[LookupID_DeliveryMethod] [bigint] NULL,
	[StoreCode] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Customer_ShippingAddress] PRIMARY KEY CLUSTERED 
(
	[Customer_ShippingAddressID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Customer_Receipt]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer_Receipt]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Customer_Receipt](
	[Customer_ReceiptID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerID] [bigint] NULL,
	[PurchaseDate] [datetime] NULL,
	[Store] [varchar](1000) NULL,
	[TransactionNo] [varchar](50) NULL,
	[SerialNo] [varchar](50) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Customer_Receipt] PRIMARY KEY CLUSTERED 
(
	[Customer_ReceiptID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Materialized_InventoryWarehouse_History_Item]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Materialized_InventoryWarehouse_History_Item]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Materialized_InventoryWarehouse_History_Item](
	[Ct] [bigint] NULL,
	[DocNo] [varchar](1000) NULL,
	[DatePosted] [datetime] NULL,
	[ItemID] [bigint] NULL,
	[WarehouseID] [bigint] NULL,
	[Qty] [bigint] NULL,
	[Running_Qty] [bigint] NULL,
	[Flag] [int] NULL,
	[Entry_Desc] [varchar](8000) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Materialized_InventoryWarehouse_Current_Item]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Materialized_InventoryWarehouse_Current_Item]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Materialized_InventoryWarehouse_Current_Item](
	[ItemID] [bigint] NULL,
	[WarehouseID] [bigint] NULL,
	[Qty] [bigint] NULL,
 CONSTRAINT [IX_Materialized_InventoryWarehouse_Current_Item] UNIQUE NONCLUSTERED 
(
	[ItemID] ASC,
	[WarehouseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LookupTaxCode]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LookupTaxCode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LookupTaxCode](
	[LookupTaxCodeID] [bigint] IDENTITY(1,1) NOT NULL,
	[Desc] [varchar](1000) NULL,
	[PST_Value] [numeric](18, 2) NULL,
	[GST_Value] [numeric](18, 2) NULL,
	[HST_Value] [numeric](18, 2) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TaxCode] PRIMARY KEY CLUSTERED 
(
	[LookupTaxCodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LookupShippingCost]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LookupShippingCost]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LookupShippingCost](
	[LookupShippingCostID] [bigint] IDENTITY(1,1) NOT NULL,
	[Desc] [varchar](50) NULL,
	[Value] [numeric](18, 2) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Lookup_ShippingCost] PRIMARY KEY CLUSTERED 
(
	[LookupShippingCostID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LookupPriceDiscount]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LookupPriceDiscount]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LookupPriceDiscount](
	[LookupPriceDiscountID] [bigint] IDENTITY(1,1) NOT NULL,
	[Desc] [varchar](50) NULL,
	[Value] [numeric](18, 2) NULL,
	[IsPerc] [bit] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Lookup_PriceDiscount] PRIMARY KEY CLUSTERED 
(
	[LookupPriceDiscountID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LookupClientType]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LookupClientType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LookupClientType](
	[LookupClientTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[Desc] [varchar](1000) NULL,
	[IsName] [bit] NULL,
	[IsAddress] [bit] NULL,
	[IsCompany] [bit] NULL,
	[IsShipVia] [bit] NULL,
	[IsCurrency] [bit] NULL,
	[IsBalance] [bit] NULL,
	[IsCreditCard] [bit] NULL,
	[IsCreditCard_AccountName] [bit] NULL,
	[IsCreditCard_Expiration] [bit] NULL,
	[IsCreditLimit] [bit] NULL,
	[IsCreditHold] [bit] NULL,
	[IsPaymentTerm] [bit] NULL,
	[IsTaxCode] [bit] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_ClientType] PRIMARY KEY CLUSTERED 
(
	[LookupClientTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LookupCallTopic]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LookupCallTopic]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LookupCallTopic](
	[LookupCallTopicID] [bigint] IDENTITY(1,1) NOT NULL,
	[Desc] [varchar](1000) NULL,
	[IsRA] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Lookup_CallTopic] PRIMARY KEY CLUSTERED 
(
	[LookupCallTopicID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Lookup_Details]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Lookup_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Lookup_Details](
	[Lookup_DetailsID] [bigint] IDENTITY(1,1) NOT NULL,
	[LookupID] [bigint] NULL,
	[Desc] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Lookup_Items] PRIMARY KEY CLUSTERED 
(
	[Lookup_DetailsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Lookup]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Lookup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Lookup](
	[LookupID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Desc] [varchar](1000) NULL,
	[Lookup_DetailsID_Default] [bigint] NULL,
	[IsLookup_Details] [bit] NULL,
	[Lookup_Details_Other_TableName] [varchar](1000) NULL,
	[Lookup_Details_Other_DescField] [varchar](1000) NULL,
	[Lookup_Details_Other_Condition] [varchar](1000) NULL,
	[Lookup_Details_Other_Url] [varchar](1000) NULL,
	[IsHidden] [bit] NULL,
 CONSTRAINT [PK_Lookup] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Item_Supplier]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Item_Supplier]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Item_Supplier](
	[Item_SupplierID] [bigint] IDENTITY(1,1) NOT NULL,
	[ItemID] [bigint] NULL,
	[SupplierID] [bigint] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Item_Supplier] PRIMARY KEY CLUSTERED 
(
	[Item_SupplierID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Item_PriceHistory]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Item_PriceHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Item_PriceHistory](
	[Item_PriceHistoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[ItemID] [bigint] NULL,
	[Price] [numeric](18, 2) NULL,
	[EmployeeID_PostedBy] [bigint] NULL,
	[DatePosted] [datetime] NULL,
 CONSTRAINT [PK_Item_PriceHistory] PRIMARY KEY CLUSTERED 
(
	[Item_PriceHistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Item_Part]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Item_Part]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Item_Part](
	[Item_PartID] [bigint] IDENTITY(1,1) NOT NULL,
	[ItemID] [bigint] NULL,
	[ItemID_Part] [bigint] NULL,
	[Qty] [bigint] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Item_Part] PRIMARY KEY CLUSTERED 
(
	[Item_PartID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Item_Location]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Item_Location]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Item_Location](
	[Item_LocationID] [bigint] IDENTITY(1,1) NOT NULL,
	[ItemID] [bigint] NULL,
	[WarehouseID] [bigint] NULL,
	[Location1] [varchar](50) NULL,
	[Location2] [varchar](50) NULL,
	[Location3] [varchar](50) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Item_Location] PRIMARY KEY CLUSTERED 
(
	[Item_LocationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Item_CostHistory]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Item_CostHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Item_CostHistory](
	[Item_CostHistoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[ItemID] [bigint] NULL,
	[Cost] [numeric](18, 2) NULL,
	[EmployeeID_PostedBy] [bigint] NULL,
	[DatePosted] [datetime] NULL,
 CONSTRAINT [PK_Item_CostHistory] PRIMARY KEY CLUSTERED 
(
	[Item_CostHistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TransactionPurchaseReturn]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseReturn]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionPurchaseReturn](
	[TransactionPurchaseReturnID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[DocumentItemID] [bigint] NULL,
	[TransactionReceiveOrderID] [bigint] NULL,
	[SupplierID] [bigint] NULL,
	[WarehouseID] [bigint] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionPurchaseReturn] PRIMARY KEY CLUSTERED 
(
	[TransactionPurchaseReturnID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TransactionPurchasePayment_PurchaseInvoice]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionPurchasePayment_PurchaseInvoice]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionPurchasePayment_PurchaseInvoice](
	[TransactionPurchasePayment_PurchaseInvoiceID] [bigint] IDENTITY(1,1) NOT NULL,
	[TransactionPurchasePaymentID] [bigint] NULL,
	[TransactionPurchaseInvoiceID] [bigint] NULL,
	[Amount] [numeric](18, 2) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionPurchasePayment_PurchaseInvoice] PRIMARY KEY CLUSTERED 
(
	[TransactionPurchasePayment_PurchaseInvoiceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'TransactionPurchasePayment_PurchaseInvoice', N'COLUMN',N'Amount'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Amount Paid for this Purchase Invoice Document' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TransactionPurchasePayment_PurchaseInvoice', @level2type=N'COLUMN',@level2name=N'Amount'
GO
/****** Object:  Table [dbo].[TransactionPurchasePayment_EmployeeExpense]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionPurchasePayment_EmployeeExpense]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionPurchasePayment_EmployeeExpense](
	[TransactionPurchasePayment_EmployeeExpenseID] [bigint] IDENTITY(1,1) NOT NULL,
	[TransactionPurchasePaymentID] [bigint] NULL,
	[TransactionEmployeeExpenseID] [bigint] NULL,
	[Amount] [numeric](18, 2) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionPurchasePayment_EmployeeExpense] PRIMARY KEY CLUSTERED 
(
	[TransactionPurchasePayment_EmployeeExpenseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TransactionPurchasePayment_CreditNotes]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionPurchasePayment_CreditNotes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionPurchasePayment_CreditNotes](
	[TransactionPurchasePayment_CreditNotesID] [bigint] IDENTITY(1,1) NOT NULL,
	[TransactionPurchasePaymentID] [bigint] NULL,
	[System_LookupID_CreditNoteSourceType] [bigint] NULL,
	[SourceID] [bigint] NULL,
	[Amount] [numeric](18, 2) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionPurchasePayment_CreditNotes] PRIMARY KEY CLUSTERED 
(
	[TransactionPurchasePayment_CreditNotesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TransactionPurchasePayment]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionPurchasePayment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionPurchasePayment](
	[TransactionPurchasePaymentID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[PaymentID] [bigint] NULL,
	[PartyID] [bigint] NULL,
	[System_LookupID_PurchasePaymentType] [bigint] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionPurchasePayment] PRIMARY KEY CLUSTERED 
(
	[TransactionPurchasePaymentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TransactionPurchaseInvoice]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseInvoice]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionPurchaseInvoice](
	[TransactionPurchaseInvoiceID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[DocumentChartOfAccountsID] [bigint] NULL,
	[LookupID_PaymentTerm] [bigint] NULL,
	[PartyID] [bigint] NULL,
	[IsTrade] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionPurchaseInvoice] PRIMARY KEY CLUSTERED 
(
	[TransactionPurchaseInvoiceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TransactionJournalVoucher_Details]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionJournalVoucher_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionJournalVoucher_Details](
	[TransactionJournalVoucher_DetailsID] [bigint] IDENTITY(1,1) NOT NULL,
	[TransactionJournalVoucherID] [bigint] NULL,
	[AccountingChartOfAccountsID] [bigint] NULL,
	[PartyID] [bigint] NULL,
	[Desc] [varchar](1000) NULL,
	[Debit_Amount] [numeric](18, 2) NULL,
	[Credit_Amount] [numeric](18, 2) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionJournalVoucher_Details] PRIMARY KEY CLUSTERED 
(
	[TransactionJournalVoucher_DetailsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TransactionJournalVoucher]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionJournalVoucher]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionJournalVoucher](
	[TransactionJournalVoucherID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionJournalVoucher] PRIMARY KEY CLUSTERED 
(
	[TransactionJournalVoucherID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TransactionEmployeeExpense]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionEmployeeExpense]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionEmployeeExpense](
	[TransactionEmployeeExpenseID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[DocumentChartOfAccountsID] [bigint] NULL,
	[EmployeeID] [bigint] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionEmployeeExpense] PRIMARY KEY CLUSTERED 
(
	[TransactionEmployeeExpenseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[InventoryWarehouseReceived]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseReceived]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InventoryWarehouseReceived](
	[InventoryWarehouseReceivedID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[DocumentItemID] [bigint] NULL,
	[WarehouseID] [bigint] NULL,
	[SupplierID] [bigint] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_InventoryWarehouseReceived] PRIMARY KEY CLUSTERED 
(
	[InventoryWarehouseReceivedID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Employee_Leave]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Employee_Leave]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Employee_Leave](
	[Employee_LeaveID] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [bigint] NULL,
	[System_LookupID_LeaveType] [bigint] NULL,
	[LeaveDate] [datetime] NULL,
	[Reason] [varchar](5000) NULL,
	[IsApproved] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Employee_Leave] PRIMARY KEY CLUSTERED 
(
	[Employee_LeaveID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_UserLogin]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[System_UserLogin]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[System_UserLogin](
	[UserID] [bigint] NOT NULL,
	[SessionID] [varchar](50) NULL,
 CONSTRAINT [PK_System_UserLogin] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_TableUpdateBatch_Details]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[System_TableUpdateBatch_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[System_TableUpdateBatch_Details](
	[System_TableUpdateBatchID] [bigint] NULL,
	[ID] [bigint] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[System_TableUpdateBatch]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[System_TableUpdateBatch]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[System_TableUpdateBatch](
	[System_TableUpdateBatchID] [bigint] NOT NULL,
	[TableName] [varchar](1000) NULL,
	[TableName_Source] [varchar](1000) NULL,
	[TableName_Cache] [varchar](1000) NULL,
	[TableName_KeyName] [varchar](1000) NULL,
 CONSTRAINT [PK_System_TableUpdateBatch] PRIMARY KEY CLUSTERED 
(
	[System_TableUpdateBatchID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_Series]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[System_Series]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[System_Series](
	[TableName] [varchar](1000) NULL,
	[LastID] [bigint] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_Parameters]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[System_Parameters]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[System_Parameters](
	[ParameterName] [varchar](50) NULL,
	[ParameterValue] [varchar](8000) NULL,
 CONSTRAINT [IX_System_Parameters] UNIQUE NONCLUSTERED 
(
	[ParameterName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_Modules_AccessLib]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[System_Modules_AccessLib]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[System_Modules_AccessLib](
	[System_Modules_AccessLibID] [bigint] NOT NULL,
	[Desc] [varchar](50) NULL,
 CONSTRAINT [PK_System_Modules_AccessLib] PRIMARY KEY CLUSTERED 
(
	[System_Modules_AccessLibID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_Modules_Access]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[System_Modules_Access]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[System_Modules_Access](
	[System_Modules_AccessID] [bigint] NOT NULL,
	[System_ModulesID] [bigint] NULL,
	[System_Modules_AccessLibID] [bigint] NULL,
 CONSTRAINT [PK_System_Modules_Access] PRIMARY KEY CLUSTERED 
(
	[System_Modules_AccessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[System_Modules]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[System_Modules]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[System_Modules](
	[System_ModulesID] [bigint] NOT NULL,
	[Name] [varchar](1000) NULL,
	[Code] [varchar](1000) NULL,
	[IsHO] [bit] NULL,
	[IsBranch] [bit] NULL,
	[IsWarehouse] [bit] NULL,
	[IsHidden] [bit] NULL,
	[PageUrl_List] [varchar](1000) NULL,
	[PageUrl_Details] [varchar](1000) NULL,
	[FormName] [varchar](1000) NULL,
	[Arguments] [varchar](1000) NULL,
	[Parent_System_ModulesID] [bigint] NULL,
	[IconIndex] [int] NULL,
	[OrderIndex] [int] NULL,
 CONSTRAINT [PK_System_Modules_1] PRIMARY KEY CLUSTERED 
(
	[System_ModulesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_LookupPartyType]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[System_LookupPartyType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[System_LookupPartyType](
	[System_LookupPartyTypeID] [bigint] NOT NULL,
	[Name] [varchar](50) NULL,
	[TableName] [varchar](100) NULL,
	[FieldName] [varchar](100) NULL,
 CONSTRAINT [PK_System_LookupPartyType] PRIMARY KEY CLUSTERED 
(
	[System_LookupPartyTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_Lookup_Details]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[System_Lookup_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[System_Lookup_Details](
	[System_Lookup_DetailsID] [bigint] NOT NULL,
	[System_LookupID] [bigint] NOT NULL,
	[Name] [varchar](50) NULL,
	[Desc] [varchar](50) NULL,
	[OrderIndex] [int] NULL,
 CONSTRAINT [PK_System_Lookup_Items_1] PRIMARY KEY CLUSTERED 
(
	[System_Lookup_DetailsID] ASC,
	[System_LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_Lookup]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[System_Lookup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[System_Lookup](
	[System_LookupID] [bigint] NOT NULL,
	[Name] [varchar](50) NULL,
 CONSTRAINT [PK_System_Lookup] PRIMARY KEY CLUSTERED 
(
	[System_LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_DocumentSeries]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[System_DocumentSeries]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[System_DocumentSeries](
	[System_DocumentSeriesID] [bigint] NOT NULL,
	[ModuleName] [varchar](1000) NULL,
	[TableName] [varchar](1000) NULL,
	[FieldName] [varchar](1000) NULL,
	[Desc] [varchar](1000) NULL,
	[Prefix] [varchar](50) NULL,
	[Digits] [int] NULL,
 CONSTRAINT [PK_System_SeriesParameters] PRIMARY KEY CLUSTERED 
(
	[System_DocumentSeriesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_BindDefinition_Field]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[System_BindDefinition_Field]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[System_BindDefinition_Field](
	[System_BindDefinition_FieldID] [bigint] NOT NULL,
	[System_BindDefinitionID] [bigint] NULL,
	[Name] [varchar](1000) NULL,
	[Desc] [varchar](1000) NULL,
	[System_LookupID_FieldType] [int] NULL,
	[IsReadOnly] [bit] NULL,
	[Width] [int] NULL,
	[NumberFormat] [varchar](50) NULL,
	[System_LookupID_HorizontalAlign] [bigint] NULL,
	[ClientSideBeginEdit] [varchar](1000) NULL,
	[ClientSideEndEdit] [varchar](1000) NULL,
	[CommandName] [varchar](1000) NULL,
	[System_LookupID_ButtonType] [int] NULL,
	[FieldText] [varchar](50) NULL,
	[OrderIndex] [int] NULL,
	[IsHidden] [bit] NULL,
 CONSTRAINT [PK_BindDefinition_Field] PRIMARY KEY CLUSTERED 
(
	[System_BindDefinition_FieldID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_BindDefinition]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[System_BindDefinition]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[System_BindDefinition](
	[System_BindDefinitionID] [bigint] NOT NULL,
	[Name] [varchar](1000) NULL,
	[TableName] [varchar](1000) NULL,
	[TableKey] [varchar](50) NULL,
	[Desc] [varchar](1000) NULL,
	[Condition] [varchar](8000) NULL,
	[Sort] [varchar](8000) NULL,
	[Window_Width] [int] NULL,
	[Window_Height] [int] NULL,
	[IsMultipleSelect] [bit] NULL,
 CONSTRAINT [PK_BindDefinition] PRIMARY KEY CLUSTERED 
(
	[System_BindDefinitionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TransactionSalesReturn]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionSalesReturn]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionSalesReturn](
	[TransactionSalesReturnID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[DocumentItemID] [bigint] NULL,
	[TransactionSalesInvoiceID] [bigint] NULL,
	[CustomerID] [bigint] NULL,
	[WarehouseID] [bigint] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionSalesReturn] PRIMARY KEY CLUSTERED 
(
	[TransactionSalesReturnID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TransactionSalesPayment_SalesInvoice]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionSalesPayment_SalesInvoice]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionSalesPayment_SalesInvoice](
	[TransactionSalesPayment_SalesInvoiceID] [bigint] IDENTITY(1,1) NOT NULL,
	[TransactionSalesPaymentID] [bigint] NULL,
	[TransactionSalesInvoiceID] [bigint] NULL,
	[Amount] [numeric](18, 2) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionSalesPayment_SalesInvoice] PRIMARY KEY CLUSTERED 
(
	[TransactionSalesPayment_SalesInvoiceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TransactionSalesPayment]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionSalesPayment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionSalesPayment](
	[TransactionSalesPaymentID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[PaymentID] [bigint] NULL,
	[CustomerID] [bigint] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionSalesPayment] PRIMARY KEY CLUSTERED 
(
	[TransactionSalesPaymentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[User_Password]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User_Password]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[User_Password](
	[User_PasswordID] [bigint] NOT NULL,
	[UserID] [bigint] NULL,
	[Password] [varchar](50) NULL,
	[DateExpiry] [datetime] NULL,
 CONSTRAINT [PK_User_Password] PRIMARY KEY CLUSTERED 
(
	[User_PasswordID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DocumentItem_Details]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DocumentItem_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DocumentItem_Details](
	[DocumentItem_DetailsID] [bigint] IDENTITY(1,1) NOT NULL,
	[DocumentItemID] [bigint] NULL,
	[ItemID] [bigint] NULL,
	[Qty] [bigint] NULL,
	[Cost] [numeric](18, 2) NULL,
	[Price] [numeric](18, 2) NULL,
	[PriceDiscount_Value] [numeric](18, 2) NULL,
	[PriceDiscount_IsPerc] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_DocumentItem_Details] PRIMARY KEY CLUSTERED 
(
	[DocumentItem_DetailsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[User]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[User](
	[UserID] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [bigint] NULL,
	[RowPropertyID] [bigint] NULL,
	[UserName] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_User] UNIQUE NONCLUSTERED 
(
	[UserID] ASC,
	[EmployeeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Item]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Item]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Item](
	[ItemID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[Warranty] [varchar](1000) NULL,
	[LookupID_Category] [bigint] NULL,
	[LookupID_ItemType] [bigint] NULL,
	[LookupID_Brand] [bigint] NULL,
	[LookupID_Retailer] [bigint] NULL,
	[LookupID_ItemUOM] [bigint] NULL,
	[Image_Path] [varchar](1000) NULL,
	[PdfDesc_Path] [varchar](1000) NULL,
	[PdfFaq_Path] [varchar](1000) NULL,
	[PdfOthers_Path] [varchar](1000) NULL,
	[IsPart] [bit] NULL,
	[IsSerial] [bit] NULL,
	[Size_Length] [numeric](18, 2) NULL,
	[Size_Width] [numeric](18, 2) NULL,
	[Size_Height] [numeric](18, 2) NULL,
	[Size_Weight] [numeric](18, 2) NULL,
	[Inv_FloorLevel] [int] NULL,
	[Inv_ReorderLevel] [int] NULL,
	[Inv_CeilingLevel] [int] NULL,
	[Price] [numeric](18, 2) NULL,
	[Cost] [numeric](18, 2) NULL,
 CONSTRAINT [PK_Item] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Party]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Party]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Party](
	[PartyID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[AddressID] [bigint] NULL,
	[System_LookupID_PartyType] [bigint] NULL,
	[IsPerson] [bit] NULL,
 CONSTRAINT [PK_Party] PRIMARY KEY CLUSTERED 
(
	[PartyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[DocumentChartOfAccounts_Details]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DocumentChartOfAccounts_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DocumentChartOfAccounts_Details](
	[DocumentChartOfAccounts_DetailsID] [bigint] IDENTITY(1,1) NOT NULL,
	[DocumentChartOfAccountsID] [bigint] NULL,
	[AccountingChartOfAccountsID] [bigint] NULL,
	[Desc] [varchar](1000) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Tax_Perc] [numeric](18, 2) NULL,
	[Tax_Amount] [numeric](18, 2) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_DocumentChartOfAccounts_Details] PRIMARY KEY CLUSTERED 
(
	[DocumentChartOfAccounts_DetailsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Rights]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Rights]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Rights](
	[RightsID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
 CONSTRAINT [PK_Rights] PRIMARY KEY CLUSTERED 
(
	[RightsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ReleasedChecks]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReleasedChecks]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReleasedChecks](
	[ReleasedChecksID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[PartyID] [bigint] NULL,
	[CheckNo] [varchar](50) NULL,
	[CheckDate] [datetime] NULL,
	[Amount] [numeric](18, 2) NULL,
	[IsEncashed] [bit] NULL,
	[DateEncashed] [datetime] NULL,
 CONSTRAINT [PK_ReleasedChecks] PRIMARY KEY CLUSTERED 
(
	[ReleasedChecksID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Bank]    Script Date: 10/21/2013 11:46:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bank]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Bank](
	[BankID] [bigint] IDENTITY(1,1) NOT NULL,
	[PartyID] [bigint] NULL,
	[ContactPersonID] [bigint] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Bank] PRIMARY KEY CLUSTERED 
(
	[BankID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Bank] UNIQUE NONCLUSTERED 
(
	[PartyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Customer](
	[CustomerID] [bigint] IDENTITY(1,1) NOT NULL,
	[PartyID] [bigint] NULL,
	[PersonID] [bigint] NULL,
	[ContactPersonID] [bigint] NULL,
	[Company] [varchar](50) NULL,
	[EmployeeID_SalesPerson] [bigint] NULL,
	[LookupTaxCodeID] [bigint] NULL,
	[LookupClientTypeID] [bigint] NULL,
	[LookupID_ShipVia] [bigint] NULL,
	[LookupID_Currency] [bigint] NULL,
	[LookupID_PaymentTerm] [bigint] NULL,
	[IsCreditHold] [bit] NULL,
	[CreditCard_AccountName] [varchar](1000) NULL,
	[CreditCard_Expiration] [datetime] NULL,
	[CreditCard_CVV] [varchar](50) NULL,
	[CreditCardNo1] [varchar](50) NULL,
	[CreditCardNo2] [varchar](50) NULL,
	[CreditCardNo3] [varchar](50) NULL,
	[CreditCardNo4] [varchar](50) NULL,
	[CreditLimit] [numeric](18, 2) NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Customer] UNIQUE NONCLUSTERED 
(
	[PartyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Customer_1] UNIQUE NONCLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Supplier]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Supplier]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Supplier](
	[SupplierID] [bigint] IDENTITY(1,1) NOT NULL,
	[PartyID] [bigint] NULL,
	[LookupID_PaymentTerm] [bigint] NULL,
 CONSTRAINT [PK_Supplier] PRIMARY KEY CLUSTERED 
(
	[SupplierID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Supplier] UNIQUE NONCLUSTERED 
(
	[PartyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Employee]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Employee](
	[EmployeeID] [bigint] IDENTITY(1,1) NOT NULL,
	[PartyID] [bigint] NULL,
	[PersonID] [bigint] NULL,
	[Position] [varchar](50) NULL,
	[LookupID_Department] [bigint] NULL,
	[LookupID_PayRate] [bigint] NULL,
	[LookupID_EmployeeType] [bigint] NULL,
	[SIN] [varchar](50) NULL,
	[Pay] [numeric](18, 2) NULL,
	[DateHired] [datetime] NULL,
	[DateTerminate] [datetime] NULL,
	[Leave_Vacation] [int] NULL,
	[Leave_Sick] [int] NULL,
	[Leave_Bereavement] [int] NULL,
 CONSTRAINT [PK_Employee_1] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Employee] UNIQUE NONCLUSTERED 
(
	[PartyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Employee_1] UNIQUE NONCLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Warehouse]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Warehouse]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Warehouse](
	[WarehouseID] [bigint] IDENTITY(1,1) NOT NULL,
	[PartyID] [bigint] NULL,
 CONSTRAINT [PK_Warehouse] PRIMARY KEY CLUSTERED 
(
	[WarehouseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_Warehouse] UNIQUE NONCLUSTERED 
(
	[PartyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[User_Rights]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User_Rights]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[User_Rights](
	[User_RightsID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [bigint] NULL,
	[RightsID] [bigint] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_User_Rights] PRIMARY KEY CLUSTERED 
(
	[User_RightsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TransactionSalesOrder]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionSalesOrder]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionSalesOrder](
	[TransactionSalesOrderID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[DocumentItemID] [bigint] NULL,
	[CustomerID] [bigint] NULL,
	[Customer_ShippingAddressID] [bigint] NULL,
	[LookupPriceDiscountID] [bigint] NULL,
	[LookupID_PaymentTerm] [bigint] NULL,
	[LookupID_DeliveryMethod] [bigint] NULL,
	[LookupID_ShipVia] [bigint] NULL,
	[LookupID_Currency] [bigint] NULL,
	[LookupID_OrderType] [bigint] NULL,
	[Freight_Amount] [numeric](18, 2) NULL,
	[OtherCost_Amount] [numeric](18, 2) NULL,
	[PST_Perc] [numeric](18, 2) NULL,
	[GST_Perc] [numeric](18, 2) NULL,
	[HST_Perc] [numeric](18, 2) NULL,
	[PONo] [varchar](50) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionSalesOrder] PRIMARY KEY CLUSTERED 
(
	[TransactionSalesOrderID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_TransactionSalesOrder] UNIQUE NONCLUSTERED 
(
	[DocumentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_TransactionSalesOrder_1] UNIQUE NONCLUSTERED 
(
	[DocumentItemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InventoryWarehouseSnapshot]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseSnapshot]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InventoryWarehouseSnapshot](
	[InventoryWarehouseSnapshotID] [bigint] IDENTITY(1,1) NOT NULL,
	[WarehouseID] [bigint] NULL,
	[SnapshotDate] [datetime] NULL,
 CONSTRAINT [PK_InventoryWarehouseSnapShot] PRIMARY KEY CLUSTERED 
(
	[InventoryWarehouseSnapshotID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TransactionPurchaseOrder]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseOrder]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionPurchaseOrder](
	[TransactionPurchaseOrderID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[DocumentItemID] [bigint] NULL,
	[SupplierID] [bigint] NULL,
	[WarehouseID] [bigint] NULL,
	[LookupID_PaymentTerm] [bigint] NULL,
	[LookupID_DeliveryMethod] [bigint] NULL,
	[DeliveryInstruction] [varchar](1000) NULL,
	[DeliveryDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionPurchaseOrder] PRIMARY KEY CLUSTERED 
(
	[TransactionPurchaseOrderID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InventoryWarehouseOpening]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseOpening]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InventoryWarehouseOpening](
	[InventoryWarehouseOpeningID] [bigint] NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[DocumentItemID] [bigint] NULL,
	[WarehouseID] [bigint] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_InventoryWarehouseOpening] PRIMARY KEY CLUSTERED 
(
	[InventoryWarehouseOpeningID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[InventoryWarehouseAdjustment]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseAdjustment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InventoryWarehouseAdjustment](
	[InventoryWarehouseAdjustmentID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[DocumentItemID] [bigint] NULL,
	[WarehouseID] [bigint] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_InventoryWarehouseAdjustment] PRIMARY KEY CLUSTERED 
(
	[InventoryWarehouseAdjustmentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[InventoryWarehouseTransfer]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseTransfer]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InventoryWarehouseTransfer](
	[InventoryWarehouseTransferID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[DocumentItemID] [bigint] NULL,
	[WarehouseID_TransferFrom] [bigint] NULL,
	[WarehouseID_TransferTo] [bigint] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_InventoryWarehouseTransfer] PRIMARY KEY CLUSTERED 
(
	[InventoryWarehouseTransferID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[InventoryWarehouseSnapshot_Details]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseSnapshot_Details]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InventoryWarehouseSnapshot_Details](
	[InventoryWarehouseSnapshot_DetailsID] [bigint] IDENTITY(1,1) NOT NULL,
	[InventoryWarehouseSnapshotID] [bigint] NULL,
	[ItemID] [bigint] NULL,
	[Qty] [bigint] NULL,
 CONSTRAINT [PK_InventoryWarehouseSnapshot_Details] PRIMARY KEY CLUSTERED 
(
	[InventoryWarehouseSnapshot_DetailsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TransactionDeliverOrder]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionDeliverOrder]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionDeliverOrder](
	[TransactionDeliverOrderID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[DocumentItemID] [bigint] NULL,
	[TransactionSalesOrderID] [bigint] NULL,
	[WarehouseID] [bigint] NULL,
	[TrackingNo] [varchar](50) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionDeliverOrder] PRIMARY KEY CLUSTERED 
(
	[TransactionDeliverOrderID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_TransactionDeliverOrder] UNIQUE NONCLUSTERED 
(
	[DocumentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_TransactionDeliverOrder_1] UNIQUE NONCLUSTERED 
(
	[DocumentItemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TransactionReceiveOrder]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionReceiveOrder]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionReceiveOrder](
	[TransactionReceiveOrderID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[DocumentItemID] [bigint] NULL,
	[TransactionPurchaseOrderID] [bigint] NULL,
	[WarehouseID] [bigint] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionReceiveOrder] PRIMARY KEY CLUSTERED 
(
	[TransactionReceiveOrderID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[TransactionSalesInvoice]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionSalesInvoice]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionSalesInvoice](
	[TransactionSalesInvoiceID] [bigint] NOT NULL,
	[RowPropertyID] [bigint] NULL,
	[DocumentID] [bigint] NULL,
	[TransactionDeliverOrderID] [bigint] NULL,
	[TrackingNo] [varchar](50) NULL,
	[LookupID_PaymentTerm] [bigint] NULL,
	[LookupID_InvoiceType] [bigint] NULL,
	[Freight_Amount] [numeric](18, 2) NULL,
	[OtherCost_Amount] [numeric](18, 2) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionSalesInvoice] PRIMARY KEY CLUSTERED 
(
	[TransactionSalesInvoiceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TransactionPurchaseInvoice_ReceiveOrder]    Script Date: 10/21/2013 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseInvoice_ReceiveOrder]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionPurchaseInvoice_ReceiveOrder](
	[TransactionPurchaseInvoice_ReceiveOrderID] [bigint] IDENTITY(1,1) NOT NULL,
	[TransactionPurchaseInvoiceID] [bigint] NULL,
	[TransactionReceiveOrderID] [bigint] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TransactionPurchaseInvoice_ReceiveOrder] PRIMARY KEY CLUSTERED 
(
	[TransactionPurchaseInvoice_ReceiveOrderID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  ForeignKey [FK_Bank_Party]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Bank_Party]') AND parent_object_id = OBJECT_ID(N'[dbo].[Bank]'))
ALTER TABLE [dbo].[Bank]  WITH CHECK ADD  CONSTRAINT [FK_Bank_Party] FOREIGN KEY([PartyID])
REFERENCES [dbo].[Party] ([PartyID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Bank_Party]') AND parent_object_id = OBJECT_ID(N'[dbo].[Bank]'))
ALTER TABLE [dbo].[Bank] CHECK CONSTRAINT [FK_Bank_Party]
GO
/****** Object:  ForeignKey [FK_Customer_Party]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Customer_Party]') AND parent_object_id = OBJECT_ID(N'[dbo].[Customer]'))
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Party] FOREIGN KEY([PartyID])
REFERENCES [dbo].[Party] ([PartyID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Customer_Party]') AND parent_object_id = OBJECT_ID(N'[dbo].[Customer]'))
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Party]
GO
/****** Object:  ForeignKey [FK_Customer_Person]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Customer_Person]') AND parent_object_id = OBJECT_ID(N'[dbo].[Customer]'))
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Customer_Person]') AND parent_object_id = OBJECT_ID(N'[dbo].[Customer]'))
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Person]
GO
/****** Object:  ForeignKey [FK_DocumentChartOfAccounts_Details_DocumentChartOfAccounts]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DocumentChartOfAccounts_Details_DocumentChartOfAccounts]') AND parent_object_id = OBJECT_ID(N'[dbo].[DocumentChartOfAccounts_Details]'))
ALTER TABLE [dbo].[DocumentChartOfAccounts_Details]  WITH CHECK ADD  CONSTRAINT [FK_DocumentChartOfAccounts_Details_DocumentChartOfAccounts] FOREIGN KEY([DocumentChartOfAccountsID])
REFERENCES [dbo].[DocumentChartOfAccounts] ([DocumentChartOfAccountsID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DocumentChartOfAccounts_Details_DocumentChartOfAccounts]') AND parent_object_id = OBJECT_ID(N'[dbo].[DocumentChartOfAccounts_Details]'))
ALTER TABLE [dbo].[DocumentChartOfAccounts_Details] CHECK CONSTRAINT [FK_DocumentChartOfAccounts_Details_DocumentChartOfAccounts]
GO
/****** Object:  ForeignKey [FK_DocumentItem_Details_DocumentItem]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DocumentItem_Details_DocumentItem]') AND parent_object_id = OBJECT_ID(N'[dbo].[DocumentItem_Details]'))
ALTER TABLE [dbo].[DocumentItem_Details]  WITH CHECK ADD  CONSTRAINT [FK_DocumentItem_Details_DocumentItem] FOREIGN KEY([DocumentItemID])
REFERENCES [dbo].[DocumentItem] ([DocumentItemID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DocumentItem_Details_DocumentItem]') AND parent_object_id = OBJECT_ID(N'[dbo].[DocumentItem_Details]'))
ALTER TABLE [dbo].[DocumentItem_Details] CHECK CONSTRAINT [FK_DocumentItem_Details_DocumentItem]
GO
/****** Object:  ForeignKey [FK_Employee_Party]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_Party]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Party] FOREIGN KEY([PartyID])
REFERENCES [dbo].[Party] ([PartyID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_Party]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Party]
GO
/****** Object:  ForeignKey [FK_Employee_Person1]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_Person1]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Person1] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Employee_Person1]') AND parent_object_id = OBJECT_ID(N'[dbo].[Employee]'))
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Person1]
GO
/****** Object:  ForeignKey [FK_InventoryWarehouseAdjustment_Warehouse]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InventoryWarehouseAdjustment_Warehouse]') AND parent_object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseAdjustment]'))
ALTER TABLE [dbo].[InventoryWarehouseAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_InventoryWarehouseAdjustment_Warehouse] FOREIGN KEY([WarehouseID])
REFERENCES [dbo].[Warehouse] ([WarehouseID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InventoryWarehouseAdjustment_Warehouse]') AND parent_object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseAdjustment]'))
ALTER TABLE [dbo].[InventoryWarehouseAdjustment] CHECK CONSTRAINT [FK_InventoryWarehouseAdjustment_Warehouse]
GO
/****** Object:  ForeignKey [FK_InventoryWarehouseOpening_Warehouse]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InventoryWarehouseOpening_Warehouse]') AND parent_object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseOpening]'))
ALTER TABLE [dbo].[InventoryWarehouseOpening]  WITH CHECK ADD  CONSTRAINT [FK_InventoryWarehouseOpening_Warehouse] FOREIGN KEY([WarehouseID])
REFERENCES [dbo].[Warehouse] ([WarehouseID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InventoryWarehouseOpening_Warehouse]') AND parent_object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseOpening]'))
ALTER TABLE [dbo].[InventoryWarehouseOpening] CHECK CONSTRAINT [FK_InventoryWarehouseOpening_Warehouse]
GO
/****** Object:  ForeignKey [FK_InventoryWarehouseSnapshot_Warehouse]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InventoryWarehouseSnapshot_Warehouse]') AND parent_object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseSnapshot]'))
ALTER TABLE [dbo].[InventoryWarehouseSnapshot]  WITH CHECK ADD  CONSTRAINT [FK_InventoryWarehouseSnapshot_Warehouse] FOREIGN KEY([WarehouseID])
REFERENCES [dbo].[Warehouse] ([WarehouseID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InventoryWarehouseSnapshot_Warehouse]') AND parent_object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseSnapshot]'))
ALTER TABLE [dbo].[InventoryWarehouseSnapshot] CHECK CONSTRAINT [FK_InventoryWarehouseSnapshot_Warehouse]
GO
/****** Object:  ForeignKey [FK_InventoryWarehouseSnapshot_Details_InventoryWarehouseSnapshot]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InventoryWarehouseSnapshot_Details_InventoryWarehouseSnapshot]') AND parent_object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseSnapshot_Details]'))
ALTER TABLE [dbo].[InventoryWarehouseSnapshot_Details]  WITH CHECK ADD  CONSTRAINT [FK_InventoryWarehouseSnapshot_Details_InventoryWarehouseSnapshot] FOREIGN KEY([InventoryWarehouseSnapshotID])
REFERENCES [dbo].[InventoryWarehouseSnapshot] ([InventoryWarehouseSnapshotID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InventoryWarehouseSnapshot_Details_InventoryWarehouseSnapshot]') AND parent_object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseSnapshot_Details]'))
ALTER TABLE [dbo].[InventoryWarehouseSnapshot_Details] CHECK CONSTRAINT [FK_InventoryWarehouseSnapshot_Details_InventoryWarehouseSnapshot]
GO
/****** Object:  ForeignKey [FK_InventoryWarehouseTransfer_Warehouse]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InventoryWarehouseTransfer_Warehouse]') AND parent_object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseTransfer]'))
ALTER TABLE [dbo].[InventoryWarehouseTransfer]  WITH CHECK ADD  CONSTRAINT [FK_InventoryWarehouseTransfer_Warehouse] FOREIGN KEY([WarehouseID_TransferFrom])
REFERENCES [dbo].[Warehouse] ([WarehouseID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InventoryWarehouseTransfer_Warehouse]') AND parent_object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseTransfer]'))
ALTER TABLE [dbo].[InventoryWarehouseTransfer] CHECK CONSTRAINT [FK_InventoryWarehouseTransfer_Warehouse]
GO
/****** Object:  ForeignKey [FK_InventoryWarehouseTransfer_Warehouse1]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InventoryWarehouseTransfer_Warehouse1]') AND parent_object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseTransfer]'))
ALTER TABLE [dbo].[InventoryWarehouseTransfer]  WITH CHECK ADD  CONSTRAINT [FK_InventoryWarehouseTransfer_Warehouse1] FOREIGN KEY([WarehouseID_TransferTo])
REFERENCES [dbo].[Warehouse] ([WarehouseID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_InventoryWarehouseTransfer_Warehouse1]') AND parent_object_id = OBJECT_ID(N'[dbo].[InventoryWarehouseTransfer]'))
ALTER TABLE [dbo].[InventoryWarehouseTransfer] CHECK CONSTRAINT [FK_InventoryWarehouseTransfer_Warehouse1]
GO
/****** Object:  ForeignKey [FK_Item_RowProperty]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_RowProperty]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_RowProperty] FOREIGN KEY([RowPropertyID])
REFERENCES [dbo].[RowProperty] ([RowPropertyID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_RowProperty]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_Item_RowProperty]
GO
/****** Object:  ForeignKey [FK_Party_Address]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Party_Address]') AND parent_object_id = OBJECT_ID(N'[dbo].[Party]'))
ALTER TABLE [dbo].[Party]  WITH CHECK ADD  CONSTRAINT [FK_Party_Address] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Address] ([AddressID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Party_Address]') AND parent_object_id = OBJECT_ID(N'[dbo].[Party]'))
ALTER TABLE [dbo].[Party] CHECK CONSTRAINT [FK_Party_Address]
GO
/****** Object:  ForeignKey [FK_ReleasedChecks_Party]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReleasedChecks_Party]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReleasedChecks]'))
ALTER TABLE [dbo].[ReleasedChecks]  WITH CHECK ADD  CONSTRAINT [FK_ReleasedChecks_Party] FOREIGN KEY([PartyID])
REFERENCES [dbo].[Party] ([PartyID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ReleasedChecks_Party]') AND parent_object_id = OBJECT_ID(N'[dbo].[ReleasedChecks]'))
ALTER TABLE [dbo].[ReleasedChecks] CHECK CONSTRAINT [FK_ReleasedChecks_Party]
GO
/****** Object:  ForeignKey [FK_Rights_RowProperty]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Rights_RowProperty]') AND parent_object_id = OBJECT_ID(N'[dbo].[Rights]'))
ALTER TABLE [dbo].[Rights]  WITH CHECK ADD  CONSTRAINT [FK_Rights_RowProperty] FOREIGN KEY([RowPropertyID])
REFERENCES [dbo].[RowProperty] ([RowPropertyID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Rights_RowProperty]') AND parent_object_id = OBJECT_ID(N'[dbo].[Rights]'))
ALTER TABLE [dbo].[Rights] CHECK CONSTRAINT [FK_Rights_RowProperty]
GO
/****** Object:  ForeignKey [FK_Supplier_Party]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Supplier_Party]') AND parent_object_id = OBJECT_ID(N'[dbo].[Supplier]'))
ALTER TABLE [dbo].[Supplier]  WITH CHECK ADD  CONSTRAINT [FK_Supplier_Party] FOREIGN KEY([PartyID])
REFERENCES [dbo].[Party] ([PartyID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Supplier_Party]') AND parent_object_id = OBJECT_ID(N'[dbo].[Supplier]'))
ALTER TABLE [dbo].[Supplier] CHECK CONSTRAINT [FK_Supplier_Party]
GO
/****** Object:  ForeignKey [FK_TransactionDeliverOrder_Document]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionDeliverOrder_Document]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionDeliverOrder]'))
ALTER TABLE [dbo].[TransactionDeliverOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionDeliverOrder_Document] FOREIGN KEY([DocumentID])
REFERENCES [dbo].[Document] ([DocumentID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionDeliverOrder_Document]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionDeliverOrder]'))
ALTER TABLE [dbo].[TransactionDeliverOrder] CHECK CONSTRAINT [FK_TransactionDeliverOrder_Document]
GO
/****** Object:  ForeignKey [FK_TransactionDeliverOrder_DocumentItem]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionDeliverOrder_DocumentItem]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionDeliverOrder]'))
ALTER TABLE [dbo].[TransactionDeliverOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionDeliverOrder_DocumentItem] FOREIGN KEY([DocumentItemID])
REFERENCES [dbo].[DocumentItem] ([DocumentItemID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionDeliverOrder_DocumentItem]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionDeliverOrder]'))
ALTER TABLE [dbo].[TransactionDeliverOrder] CHECK CONSTRAINT [FK_TransactionDeliverOrder_DocumentItem]
GO
/****** Object:  ForeignKey [FK_TransactionDeliverOrder_TransactionSalesOrder]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionDeliverOrder_TransactionSalesOrder]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionDeliverOrder]'))
ALTER TABLE [dbo].[TransactionDeliverOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionDeliverOrder_TransactionSalesOrder] FOREIGN KEY([TransactionSalesOrderID])
REFERENCES [dbo].[TransactionSalesOrder] ([TransactionSalesOrderID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionDeliverOrder_TransactionSalesOrder]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionDeliverOrder]'))
ALTER TABLE [dbo].[TransactionDeliverOrder] CHECK CONSTRAINT [FK_TransactionDeliverOrder_TransactionSalesOrder]
GO
/****** Object:  ForeignKey [FK_TransactionDeliverOrder_Warehouse]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionDeliverOrder_Warehouse]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionDeliverOrder]'))
ALTER TABLE [dbo].[TransactionDeliverOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionDeliverOrder_Warehouse] FOREIGN KEY([WarehouseID])
REFERENCES [dbo].[Warehouse] ([WarehouseID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionDeliverOrder_Warehouse]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionDeliverOrder]'))
ALTER TABLE [dbo].[TransactionDeliverOrder] CHECK CONSTRAINT [FK_TransactionDeliverOrder_Warehouse]
GO
/****** Object:  ForeignKey [FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionPurchaseInvoice]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionPurchaseInvoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseInvoice_ReceiveOrder]'))
ALTER TABLE [dbo].[TransactionPurchaseInvoice_ReceiveOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionPurchaseInvoice] FOREIGN KEY([TransactionPurchaseInvoiceID])
REFERENCES [dbo].[TransactionPurchaseInvoice] ([TransactionPurchaseInvoiceID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionPurchaseInvoice]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseInvoice_ReceiveOrder]'))
ALTER TABLE [dbo].[TransactionPurchaseInvoice_ReceiveOrder] CHECK CONSTRAINT [FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionPurchaseInvoice]
GO
/****** Object:  ForeignKey [FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionReceiveOrder]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionReceiveOrder]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseInvoice_ReceiveOrder]'))
ALTER TABLE [dbo].[TransactionPurchaseInvoice_ReceiveOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionReceiveOrder] FOREIGN KEY([TransactionReceiveOrderID])
REFERENCES [dbo].[TransactionReceiveOrder] ([TransactionReceiveOrderID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionReceiveOrder]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseInvoice_ReceiveOrder]'))
ALTER TABLE [dbo].[TransactionPurchaseInvoice_ReceiveOrder] CHECK CONSTRAINT [FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionReceiveOrder]
GO
/****** Object:  ForeignKey [FK_TransactionPurchaseOrder_Document]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionPurchaseOrder_Document]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseOrder]'))
ALTER TABLE [dbo].[TransactionPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionPurchaseOrder_Document] FOREIGN KEY([DocumentID])
REFERENCES [dbo].[Document] ([DocumentID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionPurchaseOrder_Document]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseOrder]'))
ALTER TABLE [dbo].[TransactionPurchaseOrder] CHECK CONSTRAINT [FK_TransactionPurchaseOrder_Document]
GO
/****** Object:  ForeignKey [FK_TransactionPurchaseOrder_DocumentItem]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionPurchaseOrder_DocumentItem]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseOrder]'))
ALTER TABLE [dbo].[TransactionPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionPurchaseOrder_DocumentItem] FOREIGN KEY([DocumentItemID])
REFERENCES [dbo].[DocumentItem] ([DocumentItemID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionPurchaseOrder_DocumentItem]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseOrder]'))
ALTER TABLE [dbo].[TransactionPurchaseOrder] CHECK CONSTRAINT [FK_TransactionPurchaseOrder_DocumentItem]
GO
/****** Object:  ForeignKey [FK_TransactionPurchaseOrder_RowProperty]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionPurchaseOrder_RowProperty]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseOrder]'))
ALTER TABLE [dbo].[TransactionPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionPurchaseOrder_RowProperty] FOREIGN KEY([RowPropertyID])
REFERENCES [dbo].[RowProperty] ([RowPropertyID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionPurchaseOrder_RowProperty]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseOrder]'))
ALTER TABLE [dbo].[TransactionPurchaseOrder] CHECK CONSTRAINT [FK_TransactionPurchaseOrder_RowProperty]
GO
/****** Object:  ForeignKey [FK_TransactionPurchaseOrder_Supplier]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionPurchaseOrder_Supplier]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseOrder]'))
ALTER TABLE [dbo].[TransactionPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionPurchaseOrder_Supplier] FOREIGN KEY([SupplierID])
REFERENCES [dbo].[Supplier] ([SupplierID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionPurchaseOrder_Supplier]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionPurchaseOrder]'))
ALTER TABLE [dbo].[TransactionPurchaseOrder] CHECK CONSTRAINT [FK_TransactionPurchaseOrder_Supplier]
GO
/****** Object:  ForeignKey [FK_TransactionReceiveOrder_TransactionPurchaseOrder]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionReceiveOrder_TransactionPurchaseOrder]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionReceiveOrder]'))
ALTER TABLE [dbo].[TransactionReceiveOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionReceiveOrder_TransactionPurchaseOrder] FOREIGN KEY([TransactionPurchaseOrderID])
REFERENCES [dbo].[TransactionPurchaseOrder] ([TransactionPurchaseOrderID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionReceiveOrder_TransactionPurchaseOrder]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionReceiveOrder]'))
ALTER TABLE [dbo].[TransactionReceiveOrder] CHECK CONSTRAINT [FK_TransactionReceiveOrder_TransactionPurchaseOrder]
GO
/****** Object:  ForeignKey [FK_TransactionReceiveOrder_Warehouse]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionReceiveOrder_Warehouse]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionReceiveOrder]'))
ALTER TABLE [dbo].[TransactionReceiveOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionReceiveOrder_Warehouse] FOREIGN KEY([WarehouseID])
REFERENCES [dbo].[Warehouse] ([WarehouseID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionReceiveOrder_Warehouse]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionReceiveOrder]'))
ALTER TABLE [dbo].[TransactionReceiveOrder] CHECK CONSTRAINT [FK_TransactionReceiveOrder_Warehouse]
GO
/****** Object:  ForeignKey [FK_TransactionSalesInvoice_TransactionDeliverOrder]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionSalesInvoice_TransactionDeliverOrder]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionSalesInvoice]'))
ALTER TABLE [dbo].[TransactionSalesInvoice]  WITH CHECK ADD  CONSTRAINT [FK_TransactionSalesInvoice_TransactionDeliverOrder] FOREIGN KEY([TransactionDeliverOrderID])
REFERENCES [dbo].[TransactionDeliverOrder] ([TransactionDeliverOrderID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionSalesInvoice_TransactionDeliverOrder]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionSalesInvoice]'))
ALTER TABLE [dbo].[TransactionSalesInvoice] CHECK CONSTRAINT [FK_TransactionSalesInvoice_TransactionDeliverOrder]
GO
/****** Object:  ForeignKey [FK_TransactionSalesOrder_Customer]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionSalesOrder_Customer]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionSalesOrder]'))
ALTER TABLE [dbo].[TransactionSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionSalesOrder_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionSalesOrder_Customer]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionSalesOrder]'))
ALTER TABLE [dbo].[TransactionSalesOrder] CHECK CONSTRAINT [FK_TransactionSalesOrder_Customer]
GO
/****** Object:  ForeignKey [FK_TransactionSalesOrder_Document]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionSalesOrder_Document]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionSalesOrder]'))
ALTER TABLE [dbo].[TransactionSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionSalesOrder_Document] FOREIGN KEY([DocumentID])
REFERENCES [dbo].[Document] ([DocumentID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionSalesOrder_Document]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionSalesOrder]'))
ALTER TABLE [dbo].[TransactionSalesOrder] CHECK CONSTRAINT [FK_TransactionSalesOrder_Document]
GO
/****** Object:  ForeignKey [FK_TransactionSalesOrder_DocumentItem]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionSalesOrder_DocumentItem]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionSalesOrder]'))
ALTER TABLE [dbo].[TransactionSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionSalesOrder_DocumentItem] FOREIGN KEY([DocumentItemID])
REFERENCES [dbo].[DocumentItem] ([DocumentItemID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionSalesOrder_DocumentItem]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionSalesOrder]'))
ALTER TABLE [dbo].[TransactionSalesOrder] CHECK CONSTRAINT [FK_TransactionSalesOrder_DocumentItem]
GO
/****** Object:  ForeignKey [FK_TransactionSalesOrder_RowProperty]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionSalesOrder_RowProperty]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionSalesOrder]'))
ALTER TABLE [dbo].[TransactionSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionSalesOrder_RowProperty] FOREIGN KEY([RowPropertyID])
REFERENCES [dbo].[RowProperty] ([RowPropertyID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TransactionSalesOrder_RowProperty]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionSalesOrder]'))
ALTER TABLE [dbo].[TransactionSalesOrder] CHECK CONSTRAINT [FK_TransactionSalesOrder_RowProperty]
GO
/****** Object:  ForeignKey [FK_User_RowProperty]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_User_RowProperty]') AND parent_object_id = OBJECT_ID(N'[dbo].[User]'))
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_RowProperty] FOREIGN KEY([RowPropertyID])
REFERENCES [dbo].[RowProperty] ([RowPropertyID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_User_RowProperty]') AND parent_object_id = OBJECT_ID(N'[dbo].[User]'))
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_RowProperty]
GO
/****** Object:  ForeignKey [FK_User_Rights_User]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_User_Rights_User]') AND parent_object_id = OBJECT_ID(N'[dbo].[User_Rights]'))
ALTER TABLE [dbo].[User_Rights]  WITH CHECK ADD  CONSTRAINT [FK_User_Rights_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_User_Rights_User]') AND parent_object_id = OBJECT_ID(N'[dbo].[User_Rights]'))
ALTER TABLE [dbo].[User_Rights] CHECK CONSTRAINT [FK_User_Rights_User]
GO
/****** Object:  ForeignKey [FK_Warehouse_Party]    Script Date: 10/21/2013 11:46:30 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Warehouse_Party]') AND parent_object_id = OBJECT_ID(N'[dbo].[Warehouse]'))
ALTER TABLE [dbo].[Warehouse]  WITH CHECK ADD  CONSTRAINT [FK_Warehouse_Party] FOREIGN KEY([PartyID])
REFERENCES [dbo].[Party] ([PartyID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Warehouse_Party]') AND parent_object_id = OBJECT_ID(N'[dbo].[Warehouse]'))
ALTER TABLE [dbo].[Warehouse] CHECK CONSTRAINT [FK_Warehouse_Party]
GO
