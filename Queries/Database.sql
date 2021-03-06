USE [master]
GO
/****** Object:  Database [WebApplication_DoTest]    Script Date: 06/04/2012 21:16:10 ******/
CREATE DATABASE [WebApplication_DoTest] ON  PRIMARY 
( NAME = N'WebApplication_DoTest', FILENAME = N'D:\Databases_2K5\WebApplication_DoTest.mdf' , SIZE = 12288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'WebApplication_DoTest_log', FILENAME = N'D:\Databases_2K5\WebApplication_DoTest_Log.ldf' , SIZE = 164672KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [WebApplication_DoTest] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WebApplication_DoTest].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [WebApplication_DoTest] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET ANSI_NULLS OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET ANSI_PADDING OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET ARITHABORT OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [WebApplication_DoTest] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [WebApplication_DoTest] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [WebApplication_DoTest] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET  DISABLE_BROKER
GO
ALTER DATABASE [WebApplication_DoTest] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [WebApplication_DoTest] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [WebApplication_DoTest] SET  READ_WRITE
GO
ALTER DATABASE [WebApplication_DoTest] SET RECOVERY FULL
GO
ALTER DATABASE [WebApplication_DoTest] SET  MULTI_USER
GO
ALTER DATABASE [WebApplication_DoTest] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [WebApplication_DoTest] SET DB_CHAINING OFF
GO
EXEC sys.sp_db_vardecimal_storage_format N'WebApplication_DoTest', N'ON'
GO
USE [WebApplication_DoTest]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetSeriesNo]    Script Date: 06/04/2012 21:16:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[Author] Kolin Locke
[Date Created] 2010.05.16.1043
[Description] 
	Generates New Series No. 
	Does not include missing series nos.
*/

Create Procedure [dbo].[usp_GetSeriesNo]
@TableName As VarChar(Max)
, @FieldName As VarChar(Max)
, @Prefix As VarChar(Max)
, @Digits As Int
As	
Begin
	Declare @SqlQuery As VarChar(Max)
	Declare @SqlQuery_Derived As VarChar(Max)
	Declare @SqlQuery_Like As VarChar(Max)

	Set @SqlQuery_Like = ''

	Declare @Ct As Int
	Set @Ct = 0

	While @Ct < Len(@Prefix)
	Begin
		Set @SqlQuery_Like = @SqlQuery_Like + '[' + Substring(@Prefix,@Ct + 1,1) + ']'
		Set @Ct = @Ct + 1
	End

	Set @SqlQuery_Like = @SqlQuery_Like + '[-]'
	Set @SqlQuery_Like = @SqlQuery_Like + Replicate('[0-9]',@Digits)

	Set @SqlQuery_Derived =
		'
		Select
			Cast(Substring(' + @FieldName + ', CharIndex(''' + @Prefix + '-'', ' + @FieldName + ') + ' + Cast(Len(@Prefix) + 1 As VarChar)  + ', Len(' + @FieldName + ')) As BigInt) As [Series]
		From
			' + @TableName + '
		Where
			' + @FieldName + ' Like ''' + @SqlQuery_Like + '''
		'
	Set @SqlQuery =
		'
		Declare @Prefix As VarChar(Max)
		Declare @Digits As Int
		
		Select
			@Prefix = ''' + @Prefix + '''
			, @Digits = ' + Cast(@Digits As VarChar) + '
		
		Declare @Series As BigInt
		Set @Series = 1
		
		Select			
			@Series = Tb.Series			
		From
			(
			Select
				(IsNull(Max(Tb.Series),0) + 1) As [Series]
			From
				(' + @SqlQuery_Derived + ') As [Tb]
			) As [Tb]
		
		Declare @Return_SeriesNo As VarChar(Max)
		Set @Return_SeriesNo = @Prefix + ''-'' + dbo.udf_TextFiller(Cast(@Series As VarChar),''0'',@Digits)
		Select @Return_SeriesNo As [Return_SeriesNo]	
		'
	
	Exec(@SqlQuery)
	
	Return 0
End
GO
/****** Object:  UserDefinedFunction [dbo].[udf_TextFiller]    Script Date: 06/04/2012 21:16:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--	Author:		
--		Kolin Locke
--	Create date: 	
--		2010.02.25.0051
--	Description:	
--		[???]
-- =============================================
CREATE FUNCTION [dbo].[udf_TextFiller]
(
@TextInput As VarChar(8000),
@Filler As VarChar(1),
@TextLength Int
)
RETURNS VarChar(8000)
AS
BEGIN
	Declare @ReturnValue VarChar(8000)
	Set @ReturnValue = Right(Replicate(@Filler,@TextLength) + Ltrim(Left(IsNull(@TextInput,''),@TextLength)),@TextLength) 
	Return @ReturnValue
	
END
GO
/****** Object:  Table [dbo].[User_Password]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[udf_DataObjects_GetTableDef]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[udf_DataObjects_GetTableDef]
(@TableName VarChar(Max))	
Returns Table
As
Return
	(
	Select
		sCol.Column_id
		, sCol.Name As [ColumnName]
		, sTyp.Name As [DataType]
		, sCol.max_length As [Length]
		, sCol.Precision
		, sCol.Scale
		, sCol.Is_Identity As [IsIdentity]
		, Cast
		(
			(
			Case Count(IsCcu.Column_Name)
				When 0 Then 0
				Else 1
			End
			) 
		As Bit) As IsPk
	From 
		Sys.Columns As sCol
		Left Join Sys.Types As sTyp
			On sCol.system_type_id = sTyp.system_type_id
			And [sCol].User_Type_ID = [sTyp].User_Type_ID
		Inner Join Sys.Tables As sTab
			On sCol.Object_ID = sTab.Object_ID
		Inner Join Sys.Schemas As sSch
			On sSch.Schema_ID = sTab.Schema_ID
		Left Join Sys.Key_Constraints As Skc
			On sTab.Object_Id = Skc.Parent_Object_Id
			And Skc.Type = 'PK'
		Left Join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE As IsCcu
			On Skc.Name = IsCcu.Constraint_Name
			And sTab.Name = IsCcu.Table_Name
			And sCol.Name = IsCcu.Column_Name
	Where
		sSch.Name + '.' + sTab.Name = @TableName
		And sCol.Is_Computed = 0
	Group By
		sCol.Name
		, sTyp.Name
		, sCol.max_length
		, sCol.Precision
		, sCol.Scale
		, sCol.Is_Identity
		, sCol.Column_id
	)
GO
/****** Object:  UserDefinedFunction [dbo].[udf_ConvertDate]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kolin Locke
-- Create date: 	09.18.2007
-- Description:	[???]
-- =============================================
CREATE FUNCTION [dbo].[udf_ConvertDate]
(
@DateInput DateTime	
	
)
RETURNS DateTime
AS
BEGIN
	Declare @DateOutput DateTime
	
	Set @DateOutput = (Convert(DateTime,(Cast(DatePart(yyyy,@DateInput) as VarChar)
			+ '-' + 
			Cast(DatePart(mm,@DateInput) as VarChar)
			+ '-' + 
			Cast(DatePart(dd,@DateInput) as VarChar)),102))
	Return @DateOutput
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_GetTableDef]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[udf_GetTableDef]
(
	@TableName VarChar(Max)
)	
Returns Table
As
Return
	(
	Select
		sCol.Column_id
		, sCol.Name As [ColumnName]
		, sTyp.Name As [DataType]
		, sCol.max_length As [Length]
		, sCol.Precision
		, sCol.Scale
		, sCol.Is_Identity As [IsIdentity]
		, Cast
		(
			(
			Case Count(IsCcu.Column_Name)
				When 0 Then 0
				Else 1
			End
			) 
		As Bit) As IsPk
	From 
		Sys.Columns As sCol
		Left Join Sys.Types As sTyp
			On sCol.system_type_id = sTyp.system_type_id
			And [sCol].User_Type_ID = [sTyp].User_Type_ID
		Inner Join Sys.Tables As sTab
			On sCol.Object_ID = sTab.Object_ID
		Inner Join Sys.Schemas As sSch
			On sSch.Schema_ID = sTab.Schema_ID
		Left Join Sys.Key_Constraints As Skc
			On sTab.Object_Id = Skc.Parent_Object_Id
			And Skc.Type = 'PK'
		Left Join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE As IsCcu
			On Skc.Name = IsCcu.Constraint_Name
			And sTab.Name = IsCcu.Table_Name
			And sCol.Name = IsCcu.Column_Name
	Where
		sSch.Name + '.' + sTab.Name = @TableName
		And sCol.Is_Computed = 0
	Group By
		sCol.Name
		, sTyp.Name
		, sCol.max_length
		, sCol.Precision
		, sCol.Scale
		, sCol.Is_Identity
		, sCol.Column_id
	)
GO
/****** Object:  StoredProcedure [dbo].[usp_User_Rights_Load]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[usp_User_Rights_Load]
@ID As BigInt = 0
As
Begin
	Declare @Condition VarChar(Max)
	If @ID = 0
	Begin
		Set @Condition = '1 = 0'
	End
	Else
	Begin
		Set @Condition = 'UserID = ' + Cast(@ID As VarChar(50))
	End
	
	Declare @Query VarChar(Max)
	Set @Query =
		'		
		Select
			[Tb].User_RightsID
			, [Tb].UserID
			, [Tb].IsActive
			, [R].RightsID
			, [R].Name As [RightsName]
			, [R].Remarks As [RightsDesc]
		From
			(
			Select *
			From User_Rights
			Where ' + @Condition + '
			) As [Tb]
			Right Join [uvw_Rights] As [R]
				On [R].RightsID = [Tb].RightsID
		'
		Exec(@Query)

End
GO
/****** Object:  StoredProcedure [dbo].[usp_Rights_Details_Load]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_Rights_Details_Load]
@ID As BigInt = 0
As
Begin
	Declare @Condition VarChar(Max)
	If @ID = 0
	Begin
		Set @Condition = '1 = 0'
	End
	Else
	Begin
		Set @Condition = 'RightsID = ' + Cast(@ID As VarChar(50))
	End
	
	Declare @Query VarChar(Max)
	Set @Query =
		'		
		Select
			[Tb].Rights_DetailsID
			, [Tb].RightsID
			, [Tb].IsAllowed
			, [Sma].System_ModulesID
			, [Sma].System_Modules_AccessLibID
			, [Sma].System_Modules_Name
			, [Sma].System_Modules_Code
			, [Sma].System_Modules_AccessID
			, [Sma].Parent_System_Modules_Name
			, [Sma].Parent_System_ModulesID
			, [Sma].[Desc] As [System_Modules_Access_Desc]
		From
			(
			Select *
			From Rights_Details
			Where ' + @Condition + '
			) As [Tb]
			Right Join [uvw_System_Modules_Access] As [Sma]
				On [Sma].System_Modules_AccessID = [Tb].System_Modules_AccessID
		'
		Exec(@Query)

End
GO
/****** Object:  Table [dbo].[Address]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AccountingLedgerPostingPeriod]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountingLedgerPostingPeriod](
	[AccountingLedgerPostingPeriodID] [bigint] IDENTITY(1,1) NOT NULL,
	[DocumentID] [bigint] NULL,
 CONSTRAINT [PK_AccountingLedgerPostingPeriod] PRIMARY KEY CLUSTERED 
(
	[AccountingLedgerPostingPeriodID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccountingLedgerMappingChartOfAccounts]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AccountingLedgerMapping]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AccountingLedger_Posted]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AccountingLedger_Current]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AccountingChartOfAccounts]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[AccountingBudget_Period]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[AccountingBudget]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[DocumentChartOfAccounts]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentChartOfAccounts](
	[DocumentChartOfAccountsID] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_DocumentChartOfAccounts] PRIMARY KEY CLUSTERED 
(
	[DocumentChartOfAccountsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Document]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DataObjects_Series]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DataObjects_Series](
	[TableName] [varchar](1000) NULL,
	[LastID] [bigint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DataObjects_Parameters]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DataObjects_Parameters](
	[ParameterName] [varchar](50) NULL,
	[ParameterValue] [varchar](8000) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Customer_ShippingAddress]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Customer_Receipt]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContactPerson_Details]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContactPerson]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContactPerson](
	[ContactPersonID] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_ContactPerson] PRIMARY KEY CLUSTERED 
(
	[ContactPersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CallLog]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Bank_Account]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InventoryWarehouseReceived]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[Employee_Leave]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DocumentItem]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentItem](
	[DocumentItemID] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_DocumentItem] PRIMARY KEY CLUSTERED 
(
	[DocumentItemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Materialized_InventoryWarehouse_History_Item]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Materialized_InventoryWarehouse_Current_Item]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[LookupTaxCode]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LookupShippingCost]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LookupPriceDiscount]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LookupClientType]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LookupCallTopic]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Lookup_Details]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Lookup]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Item_Supplier]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[Item_PriceHistory]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[Item_Part]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[Item_Location]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Item_CostHistory]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[System_UserLogin]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[System_UserLogin](
	[UserID] [bigint] NOT NULL,
	[SessionID] [varchar](50) NULL,
 CONSTRAINT [PK_System_UserLogin] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_Series]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[System_Series](
	[TableName] [varchar](1000) NULL,
	[LastID] [bigint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_Parameters]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[System_Parameters](
	[ParameterName] [varchar](50) NULL,
	[ParameterValue] [varchar](8000) NULL,
 CONSTRAINT [IX_System_Parameters] UNIQUE NONCLUSTERED 
(
	[ParameterName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_Modules_AccessLib]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[System_Modules_AccessLib](
	[System_Modules_AccessLibID] [bigint] NOT NULL,
	[Desc] [varchar](50) NULL,
 CONSTRAINT [PK_System_Modules_AccessLib] PRIMARY KEY CLUSTERED 
(
	[System_Modules_AccessLibID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_Modules_Access]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[System_Modules_Access](
	[System_Modules_AccessID] [bigint] NOT NULL,
	[System_ModulesID] [bigint] NULL,
	[System_Modules_AccessLibID] [bigint] NULL,
 CONSTRAINT [PK_System_Modules_Access] PRIMARY KEY CLUSTERED 
(
	[System_Modules_AccessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[System_Modules]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_LookupPartyType]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_Lookup_Details]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_Lookup]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[System_Lookup](
	[System_LookupID] [bigint] NOT NULL,
	[Name] [varchar](50) NULL,
 CONSTRAINT [PK_System_Lookup] PRIMARY KEY CLUSTERED 
(
	[System_LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_DocumentSeries]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_BindDefinition_Field]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[System_BindDefinition]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TransactionPurchaseInvoice]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[TransactionJournalVoucher_Details]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TransactionJournalVoucher]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[TransactionEmployeeExpense]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[Person]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Payment_CreditCard_Details]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Payment_CreditCard]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment_CreditCard](
	[Payment_CreditCardID] [bigint] IDENTITY(1,1) NOT NULL,
	[PaymentID] [bigint] NULL,
 CONSTRAINT [PK_Payment_CreditCard] PRIMARY KEY CLUSTERED 
(
	[Payment_CreditCardID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payment_Check_Details]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Payment_Check]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment_Check](
	[Payment_CheckID] [bigint] IDENTITY(1,1) NOT NULL,
	[PaymentID] [bigint] NULL,
 CONSTRAINT [PK_Payment_Check_1] PRIMARY KEY CLUSTERED 
(
	[Payment_CheckID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payment_Cash]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment_Cash](
	[Payment_CashID] [bigint] IDENTITY(1,1) NOT NULL,
	[PaymentID] [bigint] NULL,
	[Amount] [numeric](18, 2) NULL,
 CONSTRAINT [PK_Payment_Cash_1] PRIMARY KEY CLUSTERED 
(
	[Payment_CashID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payment_BankTransfer_Details]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Payment_BankTransfer]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment_BankTransfer](
	[Payment_BankTransferID] [bigint] IDENTITY(1,1) NOT NULL,
	[PaymentID] [bigint] NULL,
 CONSTRAINT [PK_Payment_BankTransfer] PRIMARY KEY CLUSTERED 
(
	[Payment_BankTransferID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payment]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment](
	[PaymentID] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Payment_1] PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TransactionPurchaseReturn]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[TransactionPurchasePayment_PurchaseInvoice]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Amount Paid for this Purchase Invoice Document' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TransactionPurchasePayment_PurchaseInvoice', @level2type=N'COLUMN',@level2name=N'Amount'
GO
/****** Object:  Table [dbo].[TransactionPurchasePayment_EmployeeExpense]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[TransactionPurchasePayment_CreditNotes]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[TransactionPurchasePayment]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[TransactionSalesReturn]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[TransactionSalesPayment_SalesInvoice]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[TransactionSalesPayment]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[RowProperty]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Rights_Details]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[Rights]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rights](
	[RightsID] [bigint] IDENTITY(1,1) NOT NULL,
	[RowPropertyID] [bigint] NULL,
 CONSTRAINT [PK_Rights] PRIMARY KEY CLUSTERED 
(
	[RightsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Party]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[Item]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DocumentChartOfAccounts_Details]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DocumentItem_Details]    Script Date: 06/04/2012 21:16:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  View [dbo].[uvw_Person_Name]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Person_Name]
As
	Select 
		[Tb].*
		, IsNull([Tb].FirstName,'') + ' ' + IsNull([Tb].MiddleName,'') + ' ' + IsNull([Tb].LastName,'') As [FullName]
	From 
		Person As [Tb]
GO
/****** Object:  View [dbo].[uvw_Person]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Person]
As
	Select 
		[Tb].*
		, IsNull([Tb].FirstName,'') + ' ' + IsNull([Tb].MiddleName,'') + ' ' + IsNull([Tb].LastName,'') As [FullName]
	From 
		Person As [Tb]
GO
/****** Object:  View [dbo].[uvw_Payment_CreditCard]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_Payment_CreditCard]
As
	Select
		[Tb].*
		, IsNull([Tbd].Amount,0) As [Amount]
	From
		(
		Select [Tb].*
		From
			(
			Select 
				PaymentID
				, Min(Payment_CreditCardID) As [Payment_CreditCardID]
			From 
				Payment_CreditCard
			Group By 
				PaymentID
			) As [Tb_Ex]
			Left Join Payment_CreditCard As [Tb]
				On [Tb].Payment_CreditCardID = [Tb_Ex].Payment_CreditCardID
		) As [Tb]
		Left Join
			(
			Select 
				[Tb].Payment_CreditCardID
				, Sum([Tb].Amount) As [Amount]
			From 
				Payment_CreditCard_Details As [Tb]
			Where
				IsNull([Tb].IsDeleted,0) = 0
			Group By
				[Tb].Payment_CreditCardID
			) As [Tbd]
			On [Tbd].Payment_CreditCardID = [Tb].Payment_CreditCardID
GO
/****** Object:  View [dbo].[uvw_Payment_Check]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_Payment_Check]
As
	
	Select
		[Tb].*
		, IsNull([Tbd].Amount,0) As [Amount]
	From
		(
		Select [Tb].*
		From
			(
			Select 
				PaymentID
				, Min(Payment_CheckID) As [Payment_CheckID]
			From 
				Payment_Check
			Group By 
				PaymentID
			) As [Tb_Ex]
			Left Join Payment_Check As [Tb]
				On [Tb].Payment_CheckID = [Tb_Ex].Payment_CheckID
		) As [Tb]
		Left Join
			(
			Select 
				[Tb].Payment_CheckID
				, Sum([Tb].Amount) As [Amount]
			From 
				Payment_Check_Details As [Tb]
			Where
				IsNull([Tb].IsDeleted,0) = 0
			Group By
				[Tb].Payment_CheckID
			) As [Tbd]
			On [Tbd].Payment_CheckID = [Tb].Payment_CheckID
GO
/****** Object:  View [dbo].[uvw_Payment_Cash]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_Payment_Cash]
As
	Select [Tb].*
	From
		(
		Select 
			PaymentID
			, Min(Payment_CashID) As [Payment_CashID]
		From 
			Payment_Cash
		Group By 
			PaymentID
		) As [Tb_Ex]
		Left Join Payment_Cash As [Tb]
			On [Tb].Payment_CashID = [Tb_Ex].Payment_CashID
GO
/****** Object:  View [dbo].[uvw_System_Modules]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_System_Modules]
As
	Select
		[Sm].*
		, [Psm].OrderIndex As [Parent_OrderIndex]
	From 
		System_Modules As [Sm]
		Left Join System_Modules As [Psm]
			On [Psm].System_ModulesID = [Sm].Parent_System_ModulesID
GO
/****** Object:  View [dbo].[uvw_System_Lookup_Details]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_System_Lookup_Details]
As
	Select 
		[Tbd].*
		, [Tb].[Name] As [Lookup_Name]
	From 
		System_Lookup_Details As [Tbd]
		Left Join System_Lookup As [Tb]
			On [Tb].System_LookupID = [Tbd].System_LookupID
GO
/****** Object:  View [dbo].[uvw_System_Modules_AccessLib]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create  View [dbo].[uvw_System_Modules_AccessLib]
As
	Select
		Row_Number() Over (Order By System_ModulesID, System_Modules_AccessLibID) As [vw_System_Modules_AccessLibID],
		Sm.System_ModulesID,
		Sma.System_Modules_AccessLibID,
		Sm.[Name] As [System_Modules_Name],
		Sm.Code As [System_Modules_Code],
		Sma.[Desc]
	From
		System_Modules As Sm,
		System_Modules_AccessLib As Sma
GO
/****** Object:  View [dbo].[uvw_Lookup_Details]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_Lookup_Details]
As
	Select 
		[Tbd].*
		, [Tb].[Name] As [Lookup_Name]
	From 
		Lookup_Details As [Tbd]
		Left Join Lookup As [Tb]
			On [Tb].LookupID = [Tbd].LookupID
GO
/****** Object:  View [dbo].[uvw_Payment_BankTransfer]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_Payment_BankTransfer]
As
	Select
		[Tb].*
		, IsNull([Tbd].Amount,0) As [Amount]
	From
		(
		Select [Tb].*
		From
			(
			Select 
				PaymentID
				, Min(Payment_BankTransferID) As [Payment_BankTransferID]
			From 
				Payment_BankTransfer
			Group By 
				PaymentID
			) As [Tb_Ex]
			Left Join Payment_BankTransfer As [Tb]
				On [Tb].Payment_BankTransferID = [Tb_Ex].Payment_BankTransferID
		) As [Tb]
		Left Join
			(
			Select 
				[Tb].Payment_BankTransferID
				, Sum([Tb].Amount) As [Amount]
			From 
				Payment_BankTransfer_Details As [Tb]
			Where
				IsNull([Tb].IsDeleted,0) = 0
			Group By
				[Tb].Payment_BankTransferID
			) As [Tbd]
			On [Tbd].Payment_BankTransferID = [Tb].Payment_BankTransferID
GO
/****** Object:  StoredProcedure [dbo].[usp_System_CheckLogin]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_System_CheckLogin]
@UserID As BigInt
, @SessionID As VarChar(50)
As
Begin
	Declare @Ct As BigInt
	Select @Ct = Count(1)
	From System_UserLogin
	Where
		UserID = @UserID
		And SessionID = @SessionID

	Declare @Return As Bit	
	Set @Return = 1

	If @Ct = 0
	Begin
		Set @Return = 0
	End

	Select @Return As [Value]
End
GO
/****** Object:  StoredProcedure [dbo].[usp_Set_System_Parameter]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_Set_System_Parameter]
@ParameterName VarChar(Max)
, @ParameterValue VarChar(Max)
As
Begin
	Declare @Ct As Int	
	Select @Ct = Count(1)
	From System_Parameters
	Where ParameterName = @ParameterName
	
	If @Ct = 0
	Begin
		Insert Into System_Parameters (ParameterName, ParameterValue) Values (@ParameterName, @ParameterValue)
	End
	Else
	Begin
		Update System_Parameters Set ParameterValue = @ParameterValue Where ParameterName = @ParameterName
	End
End
GO
/****** Object:  StoredProcedure [dbo].[usp_GetTableDef]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[usp_GetTableDef]
@TableName VarChar(Max)
, @SchemaName VarChar(Max) = ''
As
Set NOCOUNT On
Begin
	
	If IsNull(@SchemaName, '') = ''
	Begin
		Set @SchemaName = 'dbo'
	End
	
	Select *
	From [udf_GetTableDef](@SchemaName + '.' + @TableName)
	Order By Column_Id
	
End
GO
/****** Object:  StoredProcedure [dbo].[usp_Require_System_Parameter]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[usp_Require_System_Parameter]
@ParameterName VarChar(Max)
, @ParameterValue VarChar(Max)
As
Begin
	Declare @Ct As Int	
	Select @Ct = Count(1)
	From System_Parameters
	Where ParameterName = @ParameterName
	
	If @Ct = 0
	Begin
		Insert Into System_Parameters (ParameterName, ParameterValue) Values (@ParameterName, @ParameterValue)
	End
End
GO
/****** Object:  StoredProcedure [dbo].[usp_System_Series_Updater]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_System_Series_Updater]
As
Begin
	
	Create Table #Tmp_List 
	(
		TableName VarChar(1000) Collate Database_Default
		, ID BigInt
		, Last_ID BigInt
	)

	Declare @TableName As VarChar(1000)
	Declare @ColumnName As VarChar(1000)
	Declare @Query As VarChar(Max)

	Declare Cur Cursor Read_Only Forward_Only
	For
	Select 
		[St].Name As [TableName]
	From
		(
		Select * 
		From Sys.Tables
		) As [St]

	Open Cur

	Fetch Next From Cur
	Into @TableName

	While @@Fetch_Status = 0
	Begin
		Declare Cur_Columns Cursor Read_Only Forward_Only
		For
		Select ColumnName
		From udf_GetTableDef(@TableName)
		Where 
			IsPk = 1 
			And IsIdentity = 0
		
		Open Cur_Columns
		
		Fetch Next From Cur_Columns
		Into @ColumnName
		
		While @@Fetch_Status = 0
		Begin
			
			Set @Query =
			'
			Insert 
			Into #Tmp_List 
			(TableName, ID, Last_ID)
			Select
				''' + @TableName + '.' + @ColumnName + ''' As [TableName],
				IsNull(Max(' + @ColumnName + '),0) As ID,
				IsNull(Max(' + @ColumnName + '),0) As [Last_ID]
			From
				[' + @TableName + ']
			'
			Exec(@Query)
			
			Fetch Next From Cur_Columns
			Into @ColumnName
		End
		
		Close Cur_Columns
		Deallocate Cur_Columns
		
		Fetch Next From Cur
		Into @TableName

	End

	Close Cur
	Deallocate Cur

	Select * 
	From #Tmp_List
	Order By TableName

	
	Insert Into System_Series
	(
		TableName, 
		LastID
	)
	Select 
		TableName,
		Last_ID
	From
		#Tmp_List As [Source]
	Where
		Source.[TableName] Not In 
		(
		Select
			TableName
		From
			System_Series
		)
		
	Update System_Series
	Set
		LastID = [Source].Last_ID
	From
		#Tmp_list As [Source],
		System_Series As [Target]
	Where
		[Source].TableName = [Target].TableName
	

	Drop Table #Tmp_List

	
End
GO
/****** Object:  StoredProcedure [dbo].[usp_System_NewLogin]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_System_NewLogin]
@UserID As BigInt
, @SessionID As VarChar(50)
As
Begin
	If Not Exists
		(
		Select 1
		From System_UserLogin
		Where UserID = @UserID
		)
	Begin
		Insert Into System_UserLogin 
			(UserID, SessionID) 
		Values
			(@UserID, @SessionID)
	End
	Else
	Begin
		Update System_UserLogin 
		Set SessionID = @SessionID
		Where UserID = @UserID
	End
End
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Get_System_Parameter]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[udf_Get_System_Parameter]
(
@ParameterName VarChar(Max)
)
Returns VarChar(Max)
As
Begin
	Declare @ParameterValue As VarChar(Max)		
	Set @ParameterValue = ''
	
	Declare @Ct As Int	
	Select @Ct = Count(1)
	From System_Parameters
	Where ParameterName = @ParameterName
	
	If @Ct = 0
	Begin
		Return ''
	End
	Else
	Begin
		Select @ParameterValue = ParameterValue
		From System_Parameters
		Where ParameterName = @ParameterName
	End
	
	Return @ParameterValue
End
GO
/****** Object:  UserDefinedFunction [dbo].[udf_System_BindDefinition]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[udf_System_BindDefinition]
(
	@Name VarChar(Max)
)	
Returns Table
As
Return
	(
	Select 
		[Tbd].*
	From 
		System_BindDefinition_Field As [Tbd]
		Inner Join System_BindDefinition As [Tb]
			On [Tb].System_BindDefinitionID = [Tbd].System_BindDefinitionID
	Where
		[Tb].Name = @Name
	)
GO
/****** Object:  Table [dbo].[User]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_DataObjects_GetTableDef]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[usp_DataObjects_GetTableDef]
@TableName VarChar(Max)
, @SchemaName VarChar(Max) = ''
As
Set NOCOUNT On
Begin
	
	If IsNull(@SchemaName, '') = ''
	Begin
		Set @SchemaName = 'dbo'
	End
	
	Select *
	From [udf_DataObjects_GetTableDef](@SchemaName + '.' + @TableName)
	Order By Column_Id
	
End
GO
/****** Object:  StoredProcedure [dbo].[usp_DataObjects_GetNextID]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_DataObjects_GetNextID]
@TableName VarChar(Max)
As
Begin
	Declare @LastID BigInt
	Declare @Ct Int

	Select @Ct = Count(*)
	From DataObjects_Series
	Where TableName = @TableName
		
	If @Ct = 0
	Begin
		Insert Into DataObjects_Series (TableName, LastID) Values (@TableName, 0)
	End

	Select @LastID = LastID
	From DataObjects_Series
	Where TableName = @TableName
		
	Set @LastID = @LastID + 1
		
	Update DataObjects_Series
	Set LastID = @LastID 
	Where TableName = @TableName
	
	Select @LastID As [ID]
	
End
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountingLedger_UpdateCurrent_Transaction]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_AccountingLedger_UpdateCurrent_Transaction]
@System_ModulesID As BigInt
, @SourceID As BigInt
As
Begin
	
	Delete From AccountingLedger_Current
	Where 
		System_ModulesID = @System_ModulesID
		And SourceID = @SourceID	
		
	Declare @DateLastPostingPeriod As DateTime
	Select @DateLastPostingPeriod = Max([Tb].DatePosted)
	From 
		(
		Select
			[D].DatePosted
		From
			AccountingLedgerPostingPeriod As [Tb]
			Left Join Document As [D]
				On [D].DocumentID = [Tb].DocumentID
		) As [Tb]
	Select @DateLastPostingPeriod = IsNull(@DateLastPostingPeriod,'2000-01-01')
	
	--[-]
	
	Declare @AccountingChartOfAccountsID As BigInt
	Declare @TableName As VarChar(Max)
	Declare @FieldName_ID As VarChar(Max)
	Declare @FieldName_DocNo As VarChar(Max)
	Declare @FieldName_DatePosted As VarChar(Max)
	Declare @FieldName_ChartOfAccountsID As VarChar(Max)
	Declare @FieldName_Amount As VarChar(Max)
	Declare @FieldName_PartyID As VarChar(Max)
	
	Declare @IsDebit As Bit

	Declare @Query As NVarChar(Max)
	Declare @Query_Parameters As NVarChar(Max)
	Declare @Query_PartyID As NVarChar(Max)
	
	Create Table #Tmp 
	(
		AccountingChartOfAccountsID BigInt
		, System_ModulesID BigInt
		, TableName VarChar(100)
		, SourceID BigInt
		, DocNo VarChar(1000)
		, DatePosted DateTime
		, PartyID BigInt
		, Amount Numeric(18,2)
		, IsDebit Bit
	)
	
	--[Insert Data: Based on AccountingLedgerMapping]
	
	Declare GLMapCur Cursor For
	Select 
		[Tb].AccountingChartOfAccountsID
		, [Tb].System_ModulesID
		, [Tb].TableName
		, [Tb].FieldName_ID
		, [Tb].FieldName_DocNo
		, [Tb].FieldName_DatePosted
		, [Tb].FieldName_Amount
		, [Tb].FieldName_PartyID
		, [Tb].IsDebit
	From 
		AccountingLedgerMapping As [Tb]
		Inner Join AccountingChartOfAccounts As [Coa]
			On [Coa].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID

	Open GLMapCur

	Fetch Next From GLMapCur 
	Into
		@AccountingChartOfAccountsID
		, @System_ModulesID
		, @TableName
		, @FieldName_ID
		, @FieldName_DocNo
		, @FieldName_DatePosted
		, @FieldName_Amount
		, @FieldName_PartyID
		, @IsDebit

	While @@Fetch_Status = 0
	Begin
		
		Set @Query_PartyID = ', Null'
		If Not IsNull(@FieldName_PartyID,'') = ''
		Begin
			Set @Query_PartyID = ', [' + @FieldName_PartyID + ']'
		End
		
		Set @Query = 
			'
			Insert Into #Tmp
				(
				AccountingChartOfAccountsID
				, System_ModulesID
				, TableName
				, SourceID
				, DocNo
				, DatePosted
				, Amount
				, IsDebit
				, PartyID
				)
			Select
				@Param_ChartOfAccountsID
				, @Param_System_ModulesID
				, @Param_TableName
				, [' + @FieldName_ID + ']
				, [' + @FieldName_DocNo + ']
				, [' + @FieldName_DatePosted + ']
				, [' + @FieldName_Amount + ']
				, @Param_IsDebit
				' + @Query_PartyID + '
			From
				[' + @TableName + ']
			Where
				IsPosted = 1
				And IsNull(IsCancelled,0) = 0
				And [' + @FieldName_DatePosted + '] >= @Param_DateLastPostingPeriod
				And [' + @FieldName_DatePosted + '] <= GetDate()
				And [' + @FieldName_Amount + '] <> 0
			'
		
		Set @Query_Parameters = 
			'
			@Param_ChartOfAccountsID BigInt
			, @Param_System_ModulesID BigInt
			, @Param_TableName VarChar(100)
			, @Param_FieldName_ID VarChar(1000)
			, @Param_FieldName_DocNo VarChar(1000)
			, @Param_FieldName_DatePosted VarChar(1000)
			, @Param_FieldName_Amount VarChar(1000)
			, @Param_IsDebit Bit
			, @Param_DateLastPostingPeriod DateTime
			'
		
		Execute sp_executesql
			@Query
			, @Query_Parameters
			, @Param_ChartOfAccountsID = @AccountingChartOfAccountsID
			, @Param_System_ModulesID = @System_ModulesID
			, @Param_TableName = @TableName
			, @Param_FieldName_ID = @FieldName_ID
			, @Param_FieldName_DocNo = @FieldName_DocNo
			, @Param_FieldName_DatePosted = @FieldName_DatePosted
			, @Param_FieldName_Amount = @FieldName_Amount
			, @Param_IsDebit = @IsDebit
			, @Param_DateLastPostingPeriod = @DateLastPostingPeriod

		Fetch Next From GLMapCur 
		Into
			@AccountingChartOfAccountsID
			, @System_ModulesID
			, @TableName
			, @FieldName_ID
			, @FieldName_DocNo
			, @FieldName_DatePosted
			, @FieldName_Amount
			, @FieldName_PartyID
			, @IsDebit
	End

	Close GLMapCur
	Deallocate GLMapCur
	
	--[Insert Data: Based on AccountingLedgerMappingChartOfAccounts]

	Declare GLCoaMapCur Cursor For
	Select 
		System_ModulesID
		, TableName
		, FieldName_ID
		, FieldName_DocNo
		, FieldName_DatePosted
		, FieldName_ChartOfAccountID
		, FieldName_Amount
		, FieldName_PartyID
		, IsDebit
	From 
		AccountingLedgerMappingChartOfAccounts

	Open GLCoaMapCur

	Fetch Next From GLCoaMapCur
	Into 
		@System_ModulesID
		, @TableName
		, @FieldName_ID
		, @FieldName_DocNo
		, @FieldName_DatePosted
		, @FieldName_ChartOfAccountsID
		, @FieldName_Amount
		, @FieldName_PartyID
		, @IsDebit

	While @@Fetch_Status = 0
	Begin
		
		Set @Query_PartyID = ', Null'
		If Not IsNull(@FieldName_PartyID,'') = ''
		Begin
			Set @Query_PartyID = ', [' + @FieldName_PartyID + ']'
		End
		
		Set @Query = 
			'
			Insert Into #Tmp
				(
					AccountingChartOfAccountsID
					, System_ModulesID
					, TableName
					, SourceID
					, DocNo
					, DatePosted
					, Amount
					, IsDebit
					, PartyID
				)
				Select 
					[' + @FieldName_ChartOfAccountsID + ']
					, @Param_System_ModulesID
					, @Param_TableName
					, [' + @FieldName_ID + ']
					, [' + @FieldName_DocNo + ']
					, [' + @FieldName_DatePosted + ']
					, [' + @FieldName_Amount + ']
					, @Param_IsDebit
					' + @Query_PartyID + '
				From
					[' + @TableName + ']
				Where
					IsPosted = 1
					And IsNull(IsCancelled,0) = 0
					And [' + @FieldName_DatePosted + '] >= @Param_DateLastPostingPeriod
					And [' + @FieldName_DatePosted + '] <= GetDate()
					And [' + @FieldName_Amount + '] <> 0
			'
		
		Set @Query_Parameters = 
				'
				@Param_System_ModulesID BigInt
				, @Param_TableName VarChar(100)
				, @Param_FieldName_ID VarChar(1000)
				, @Param_FieldName_DocNo VarChar(1000)
				, @Param_FieldName_DatePosted VarChar(1000)
				, @Param_FieldName_Amount VarChar(1000)
				, @Param_IsDebit Bit
				, @Param_DateLastPostingPeriod DateTime
				'
		
		Execute sp_executesql
				@Query
				, @Query_Parameters
				, @Param_System_ModulesID = @System_ModulesID
				, @Param_TableName = @TableName
				, @Param_FieldName_ID = @FieldName_ID
				, @Param_FieldName_DocNo = @FieldName_DocNo
				, @Param_FieldName_DatePosted = @FieldName_DatePosted
				, @Param_FieldName_Amount = @FieldName_Amount
				, @Param_IsDebit = @IsDebit
				, @Param_DateLastPostingPeriod = @DateLastPostingPeriod
		
		Fetch Next From GLCoaMapCur
		Into 
			@System_ModulesID
			, @TableName
			, @FieldName_ID
			, @FieldName_DocNo
			, @FieldName_DatePosted
			, @FieldName_ChartOfAccountsID
			, @FieldName_Amount
			, @FieldName_PartyID
			, @IsDebit
	End

	Close GLCoaMapCur
	Deallocate GLCoaMapCur
	
	--[-]

	Insert Into AccountingLedger_Current
	Select 
		[Tb].* 
	From 
		#Tmp As [Tb]
		Inner Join AccountingChartOfAccounts As [Coa]
			On [Coa].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID
	Order By 
		[Tb].AccountingChartOfAccountsID
		, [Tb].DatePosted

	Drop Table #Tmp 
	
End
GO
/****** Object:  StoredProcedure [dbo].[usp_DataObjects_Parameter_Set]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_DataObjects_Parameter_Set]
@ParameterName VarChar(Max)
, @ParameterValue VarChar(Max)
As
Begin
	Declare @Ct As Int	
	Select @Ct = Count(1)
	From DataObjects_Parameters
	Where ParameterName = @ParameterName
	
	If @Ct = 0
	Begin
		Insert Into DataObjects_Parameters 
			(ParameterName, ParameterValue) 
		Values 
			(@ParameterName, @ParameterValue)
	End
	Else
	Begin
		Update DataObjects_Parameters 
		Set ParameterValue = @ParameterValue 
		Where ParameterName = @ParameterName
	End
End
GO
/****** Object:  StoredProcedure [dbo].[usp_DataObjects_Parameter_Require]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_DataObjects_Parameter_Require]
@ParameterName VarChar(Max)
, @ParameterValue VarChar(Max)
As
Begin
	Declare @Ct As Int	
	Select @Ct = Count(1)
	From DataObjects_Parameters
	Where ParameterName = @ParameterName
	
	If @Ct = 0
	Begin
		Insert Into DataObjects_Parameters 
			(ParameterName, ParameterValue) 
		Values 
			(@ParameterName, @ParameterValue)
	End
End
GO
/****** Object:  StoredProcedure [dbo].[usp_GetNextID]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--	Author:			
--		Kolin Locke
--	Create date:	
--		2009.06.20.2217
--	Description:	
--		Returns New ID and Updates System_Series
-- =============================================

Create Procedure [dbo].[usp_GetNextID]
@TableName VarChar(Max)
As
Begin
	Declare @LastID BigInt
	Declare @Ct Int

	Select
		@Ct = Count(*)
	From
		System_Series
	Where
		TableName = @TableName
		
	If @Ct = 0
	Begin
		Insert Into System_Series (TableName, LastID) Values (@TableName, 0)
	End

	Select
		@LastID = LastID
	From
		System_Series
	Where
		TableName = @TableName
		
	Set @LastID = @LastID + 1
		
	Update System_Series 
	Set LastID = @LastID 
	Where TableName = @TableName
	
	Select @LastID As [ID]
	
End
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseReturn_DocumentItem]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionPurchaseReturn_DocumentItem]
As
	Select
		[Did].*
		, [Tb].TransactionPurchaseReturnID
		, [Tb].TransactionReceiveOrderID
		, [Tb].WarehouseID
		, [Tb].SupplierID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		TransactionPurchaseReturn As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_TransactionSalesReturn_DocumentItem]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesReturn_DocumentItem]
As
	Select
		[Did].*
		, [Tb].TransactionSalesReturnID
		, [Tb].TransactionSalesInvoiceID
		, [Tb].CustomerID
		, [Tb].WarehouseID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		TransactionSalesReturn As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  Table [dbo].[Warehouse]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  StoredProcedure [dbo].[usp_Get_System_Parameter]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[usp_Get_System_Parameter]
@ParameterName VarChar(Max)
As
Begin
	Declare @ParameterValue As VarChar(Max)		
	Set @ParameterValue = ''
	
	Declare @Ct As Int	
	Select @Ct = Count(1)
	From System_Parameters
	Where ParameterName = @ParameterName
	
	If @Ct = 0
	Begin
		Exec usp_Require_System_Parameter @ParameterName
	End
	Else
	Begin
		Select @ParameterValue = ParameterValue
		From System_Parameters
		Where ParameterName = @ParameterName
	End
	
	Select @ParameterValue As [ParameterValue]
End
GO
/****** Object:  StoredProcedure [dbo].[usp_DataObjects_Parameter_Get]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_DataObjects_Parameter_Get]
@ParameterName VarChar(Max)
As
Begin
	Declare @ParameterValue As VarChar(Max)		
	Set @ParameterValue = ''
	
	Declare @Ct As Int	
	Select @Ct = Count(1)
	From DataObjects_Parameters
	Where ParameterName = @ParameterName
	
	If @Ct = 0
	Begin
		Exec usp_DataObjects_Parameter_Require @ParameterName
	End
	Else
	Begin
		Select @ParameterValue = ParameterValue
		From DataObjects_Parameters
		Where ParameterName = @ParameterName
	End
	
	Select @ParameterValue As [ParameterValue]
End
GO
/****** Object:  UserDefinedFunction [dbo].[udf_System_Lookup]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[udf_System_Lookup]
(
	@Lookup_Name VarChar(Max)
)	
Returns Table
As
Return
	(
	Select
		System_Lookup_DetailsID As [System_LookupID]
		, [Name]
		, [Desc]
		, OrderIndex
	From uvw_System_Lookup_Details
	Where 
		Lookup_Name = @Lookup_Name
	)
GO
/****** Object:  Table [dbo].[User_Rights]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Lookup]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[udf_Lookup]
(
	@Lookup_Name VarChar(Max)
)	
Returns Table
As
Return
	(
	Select 
		Lookup_DetailsID As [LookupID]
		, [Desc]
	From uvw_Lookup_Details
	Where 
		Lookup_Name = @Lookup_Name
		And IsNull(IsDeleted,0) = 0
		And IsNull(IsActive,0) = 1
	)
GO
/****** Object:  View [dbo].[uvw_ContactPerson_Details]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_ContactPerson_Details]
As

	Select 
		[Tb].*
		, [P].FirstName
		, [P].LastName
		, [P].MiddleName
		, [P].Phone		
		, [P].Mobile
		, [P].Fax
		, [P].Email
		, [P].WorkEmail
		, [P].FullName
	From 
		ContactPerson_Details As [Tb]
		Left Join uvw_Person As [P]
			On [P].PersonID = [Tb].PersonID
GO
/****** Object:  View [dbo].[uvw_Payment]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Payment]
As
	Select
		[Tb].*
		, 
		(
		[Tb].[Cash_Amount] 
		+ [Tb].[Check_Amount] 
		+ [Tb].[CreditCard_Amount]
		+ [Tb].[BankTransfer_Amount]
		) As [Amount]
	From
		(
		Select 
			[Tb].*
			, IsNull([P_Cash].Amount,0) As [Cash_Amount]
			, IsNull([P_Check].Amount,0) As [Check_Amount]
			, IsNull([P_CreditCard].Amount,0) As [CreditCard_Amount]
			, IsNull([P_BankTransfer].Amount,0) As [BankTransfer_Amount]
		From 
			Payment As [Tb]
			Left Join uvw_Payment_Cash As [P_Cash]
				On [P_Cash].PaymentID = [Tb].PaymentID
			Left Join uvw_Payment_Check As [P_Check]
				On [P_Check].PaymentID = [Tb].PaymentID
			Left Join uvw_Payment_CreditCard As [P_CreditCard]
				On [P_CreditCard].PaymentID = [Tb].PaymentID
			Left Join uvw_Payment_BankTransfer As [P_BankTransfer]
				On [P_BankTransfer].PaymentID = [Tb].PaymentID
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseReceived_DocumentItem]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_InventoryWarehouseReceived_DocumentItem]
As
	Select
		[Did].*
		, [Tb].InventoryWarehouseReceivedID
		, [Tb].WarehouseID
		, [Tb].SupplierID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		InventoryWarehouseReceived As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_System_Modules_Access]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_System_Modules_Access]
As
	Select Top (100) Percent
		IsNull(Sm.[Parent_System_Modules_Name],'Root') As [Parent_System_Modules_Name]
		, Smal.[System_Modules_Name]
		, Smal.[System_Modules_Code]
		, Smal.[Desc]
		, Sm.Parent_System_ModulesID
		, Sma.*
	From
		System_Modules_Access As [Sma]
		Left Join uvw_System_Modules_AccessLib As [Smal]
			On Smal.System_ModulesID = Sma.System_ModulesID
			And Smal.System_Modules_AccessLibID = Sma.System_Modules_AccessLibID
		Left Join
			(
			Select Top (100) Percent
				Psm.[Name] As [Parent_System_Modules_Name],
				Sm.System_ModulesID,
				Sm.Parent_System_ModulesID,
				Sm.OrderIndex,
				Sm.[Name] As [System_Modules_Name],
				Sm.[Code] As  [System_Modules_Code]			
			From 
				System_Modules As Sm
				Left Join System_Modules As Psm
					On Sm.Parent_System_ModulesID = Psm.System_ModulesID
			Order By
				Sm.Parent_System_ModulesID,
				Sm.OrderIndex
			) As Sm
			On Sm.System_ModulesID = Sma.System_ModulesID

	Order By
		Sm.Parent_System_ModulesID,
		Sm.OrderIndex
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Bank]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Supplier]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[ReleasedChecks]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TransactionPurchaseOrder]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TransactionSalesOrder]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InventoryWarehouseSnapshot]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryWarehouseSnapshot](
	[InventoryWarehouseSnapshotID] [bigint] IDENTITY(1,1) NOT NULL,
	[WarehouseID] [bigint] NULL,
	[SnapshotDate] [datetime] NULL,
 CONSTRAINT [PK_InventoryWarehouseSnapShot] PRIMARY KEY CLUSTERED 
(
	[InventoryWarehouseSnapshotID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InventoryWarehouseOpening]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[InventoryWarehouseAdjustment]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[InventoryWarehouseTransfer]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  View [dbo].[uvw_Materialized_InventoryParty_Current_Item]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_Materialized_InventoryParty_Current_Item]
As
	Select
		[Tb].*
	From
		(
		Select 
			[Tb].ItemID
			, [Wh].PartyID
			, [Tb].Qty
		From 
			Materialized_InventoryWarehouse_Current_Item As [Tb]
			Inner Join Warehouse As [Wh]
				On [Wh].WarehouseID = [Tb].WarehouseID
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_Employee_Name]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Employee_Name]
As
	Select 
		[Tb].*
		, [P].FullName As [EmployeeName]
	From 
		Employee As [Tb]
		Left Join uvw_Person As [P]
			On [P].PersonID = [Tb].PersonID
GO
/****** Object:  View [dbo].[uvw_AccountingBudget_Period_New]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_AccountingBudget_Period_New]
As
	Select 
		[Tbd].AccountingBudget_PeriodID
		, [Tbd].AccountingBudgetID
		, [Tbd].Amount
		, [Lookup_Bp].System_LookupID As [System_LookupID_BudgetPeriod]
		, [Lookup_Bp].[Desc] As [BudgetPeriod_Desc]
		, [Lookup_Bp].[OrderIndex] As [BudgetPeriod_OrderIndex]
	From 
		(
		Select * 
		From AccountingBudget_Period
		Where 1 = 0
		) As [Tbd]
		Right Join udf_System_Lookup('BudgetPeriod') As [Lookup_Bp]	
			On [Lookup_Bp].System_LookupID = [Tbd].System_LookupID_BudgetPeriod
GO
/****** Object:  View [dbo].[uvw_Bank_Account]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Bank_Account]
As
	Select 
		[Tb].*
		, [Lkp_Currency].[Desc] As [Lookup_Currency_Desc]
	From 
		Bank_Account As [Tb]
		Left Join udf_Lookup('Currency') As [Lkp_Currency]
			On [Lkp_Currency].LookupID = [Tb].LookupID_Currency
GO
/****** Object:  View [dbo].[uvw_Address]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Address]
As
	Select 
		[Tb].* 
		, (
		IsNull([Tb].Address,'')
		+ Char(13) + Char(10)
		+ IsNull([Tb].City,'')
		+ Char(13) + Char(10)
		+ IsNull([Lkp_States].[Desc],'')
		+ Char(13) + Char(10)
		+ IsNull([Tb].[ZipCode],'')
		+ Char(13) + Char(10)
		+ IsNull([Lkp_Country].[Desc],'')
		) As [Address_Complete]
	From 
		[Address] As [Tb]
		Left Join udf_Lookup('States') As [Lkp_States]
			On [Lkp_States].LookupID = [Tb].LookupID_States
		Left Join udf_Lookup('Country') As [Lkp_Country]
			On [Lkp_Country].LookupID = [Tb].LookupID_Country
GO
/****** Object:  View [dbo].[uvw_Customer_Name]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Customer_Name]
As
	Select 
		[Tb].*
		, [P].FullName As [CustomerName]
	From 
		Customer As [Tb]
		Left Join uvw_Person As [P]
			On [P].PersonID = [Tb].PersonID
GO
/****** Object:  View [dbo].[uvw_Document]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Document]
As
	Select 
		[Tb].*
		
		, [E_PostedBy].EmployeeName As [Employee_PostedBy]
		, [E_CancelledBy].EmployeeName As [Employee_CancelledBy]
		
		, (
		Case [Tb].IsCancelled
			When 1 Then
				'Cancelled'
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					'Posted'
				Else 
					'Open'
			End
			)
		End
		) As [Status]
		
	From 
		Document As [Tb]
		Left Join uvw_Employee_Name As [E_PostedBy]
			On [Tb].EmployeeID_PostedBy = [E_PostedBy].EmployeeID
		Left Join uvw_Employee_Name As [E_CancelledBy]
			On [Tb].EmployeeID_CancelledBy = [E_CancelledBy].EmployeeID
GO
/****** Object:  View [dbo].[uvw_Customer_ShippingAddress]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Customer_ShippingAddress]
As
	Select
		[Tb].*
		, [A].Address_Complete As [Address]
		, [Lkp_DeliveryMethod].[Desc] As [DeliveryMethod_Desc]
	From
		Customer_ShippingAddress As [Tb]
		Left Join uvw_Address As [A]
			On [A].AddressID = [Tb].AddressID
		Left Join udf_Lookup('DeliveryMethod') As [Lkp_DeliveryMethod]
			On [Lkp_DeliveryMethod].LookupID = [Tb].LookupID_DeliveryMethod
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseAdjustment_DocumentItem]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_InventoryWarehouseAdjustment_DocumentItem]
As
	Select
		[Did].*
		, [Tb].InventoryWarehouseAdjustmentID
		, [Tb].WarehouseID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		InventoryWarehouseAdjustment As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseOpening_DocumentItem]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_InventoryWarehouseOpening_DocumentItem]
As
	Select
		[Did].*
		, [Tb].InventoryWarehouseOpeningID
		, [Tb].WarehouseID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		InventoryWarehouseOpening As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseTransfer_DocumentItem]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_InventoryWarehouseTransfer_DocumentItem]
As
	Select
		[Did].*
		, [Tb].InventoryWarehouseTransferID
		, [Tb].WarehouseID_TransferFrom
		, [Tb].WarehouseID_TransferTo
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		InventoryWarehouseTransfer As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_RowProperty]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_RowProperty]
As
	Select 
		[Tb].*
		, IsNull([Tb].Code,'') + ' - ' + IsNull([Tb].Name,'') As [CodeName]
		, [E_Cb].EmployeeName As [Employee_CreatedBy]
		, [E_Ub].EmployeeName As [Employee_UpdatedBy]
	From 
		RowProperty As [Tb]
		Left Join uvw_Employee_Name As [E_Cb]
			On [Tb].EmployeeID_CreatedBy = [E_Cb].EmployeeID
		Left Join uvw_Employee_Name As [E_Ub]
			On [Tb].EmployeeID_UpdatedBy = [E_Ub].EmployeeID
GO
/****** Object:  Table [dbo].[InventoryWarehouseSnapshot_Details]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [dbo].[TransactionDeliverOrder]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TransactionReceiveOrder]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  View [dbo].[uvw_TransactionSalesOrder_DocumentItem]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesOrder_DocumentItem]
As
	Select
		[Did].*
		, [Tb].TransactionSalesOrderID
		, [Tb].CustomerID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		TransactionSalesOrder As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseOrder_DocumentItem]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionPurchaseOrder_DocumentItem]
As
	Select
		[Did].*
		, [Tb].TransactionPurchaseOrderID
		, [Tb].SupplierID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		TransactionPurchaseOrder As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseInvoice_Paid]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionPurchaseInvoice_Paid]
As
	Select
			[Tbd].TransactionPurchaseInvoiceID
			, IsNull(Sum([Tbd].Amount),0) As [Amount]
		From
			TransactionPurchasePayment_PurchaseInvoice As [Tbd]
			Left Join TransactionPurchasePayment As [Tb]
				On [Tb].TransactionPurchasePaymentID = [Tbd].TransactionPurchasePaymentID
			Left Join uvw_Document As [D]
				On [D].DocumentID = [Tb].DocumentID
		Where
			IsNull([D].IsPosted,0) = 1
			And IsNull([D].IsCancelled,0) = 0
			And IsNull([Tb].IsDeleted,0) = 0
			And IsNull([Tbd].IsDeleted,0) = 0
		Group By
			[Tbd].TransactionPurchaseInvoiceID
GO
/****** Object:  View [dbo].[uvw_TransactionJournalVoucher]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionJournalVoucher]
As
	Select 
		[Tb].*
		
		, [Rp].Remarks
		, [Rp].Employee_CreatedBy
		, [Rp].Employee_UpdatedBy
		, [Rp].DateCreated
		, [Rp].DateUpdated
		
		, [D].DocNo
		, [D].Status
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
		, [D].Employee_PostedBy
		, [D].Employee_CancelledBy
		
	From 
		TransactionJournalVoucher As [Tb]
		Left Join uvw_RowProperty As [Rp]
			On [Rp].RowPropertyID = [Tb].RowPropertyID
		Left Join uvw_Document As [D]
			On [D].DocumentID = [Tb].DocumentID
GO
/****** Object:  View [dbo].[uvw_TransactionEmployeeExpense_Paid]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionEmployeeExpense_Paid]
As
	Select
			[Tbd].TransactionEmployeeExpenseID
			, IsNull(Sum([Tbd].Amount),0) As [Amount]
		From
			TransactionPurchasePayment_EmployeeExpense As [Tbd]
			Left Join TransactionPurchasePayment As [Tb]
				On [Tb].TransactionPurchasePaymentID = [Tbd].TransactionPurchasePaymentID
			Left Join uvw_Document As [D]
				On [D].DocumentID = [Tb].DocumentID
		Where
			IsNull([D].IsPosted,0) = 1
			And IsNull([D].IsCancelled,0) = 0
			And IsNull([Tb].IsDeleted,0) = 0
			And IsNull([Tbd].IsDeleted,0) = 0
		Group By
			[Tbd].TransactionEmployeeExpenseID
GO
/****** Object:  View [dbo].[uvw_TransactionReceiveOrder_DocumentItem]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionReceiveOrder_DocumentItem]
As
	Select
		[Did].*
		, [Tb].TransactionReceiveOrderID
		, [Tb].TransactionPurchaseOrderID
		, [Tb].WarehouseID
		, [Po].SupplierID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		TransactionReceiveOrder As [Tb]
		Left Join TransactionPurchaseOrder As [Po]
			On [Po].TransactionPurchaseOrderID = [Tb].TransactionPurchaseOrderID
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_TransactionSalesInvoice_Paid]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesInvoice_Paid]
As
	Select
			[Spsi].TransactionSalesInvoiceID
			, IsNull(Sum([Spsi].Amount),0) As [Amount]
		From
			TransactionSalesPayment_SalesInvoice As [Spsi]
			Left Join TransactionSalesPayment As [Sp]
				On [Sp].TransactionSalesPaymentID = [Spsi].TransactionSalesPaymentID
			Left Join uvw_Document As [D]
				On [D].DocumentID = [Sp].DocumentID
		Where
			IsNull([D].IsPosted,0) = 1
			And IsNull([D].IsCancelled,0) = 0
			And IsNull([Sp].IsDeleted,0) = 0
			And IsNull([Spsi].IsDeleted,0) = 0
		Group By
			[Spsi].TransactionSalesInvoiceID
GO
/****** Object:  View [dbo].[uvw_TransactionSalesOrder_Document]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionSalesOrder_Document]
As
	Select 
		[Tb].*
		, [D].DocNo
		, [D].Status
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
		, [D].Employee_PostedBy
		, [D].Employee_CancelledBy
		
	From 
		TransactionSalesOrder As [Tb]
		Left Join uvw_Document As [D]
			On [D].DocumentID = [Tb].DocumentID
GO
/****** Object:  Table [dbo].[TransactionSalesInvoice]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TransactionPurchaseInvoice_ReceiveOrder]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  View [dbo].[uvw_TransactionDeliverOrder_DocumentItem]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionDeliverOrder_DocumentItem]
As
	Select
		[Did].*
		, [Tb].TransactionDeliverOrderID
		, [Tb].TransactionSalesOrderID
		, [Tb].WarehouseID
		, [So].CustomerID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		TransactionDeliverOrder As [Tb]
		Left Join TransactionSalesOrder As [So]
			On [So].TransactionSalesOrderID = [Tb].TransactionSalesOrderID
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_Rights]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Rights]
As
	Select 
		[Tb].*
		, [Rp].Code
		, [Rp].Name
		, [Rp].IsActive
		, [Rp].Remarks
		, [Rp].Employee_CreatedBy
		, [Rp].Employee_UpdatedBy
		, [Rp].DateCreated
		, [Rp].DateUpdated
	From 
		[Rights] As [Tb]
		Left Join uvw_RowProperty As [Rp]
			On [Rp].RowPropertyID = [Tb].RowPropertyID
GO
/****** Object:  View [dbo].[uvw_Item]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Item]
As
	Select 
		[Tb].*
		, [Rp].Code
		, [Rp].Name
		, [Rp].CodeName
		, [Rp].IsActive
		, [Rp].Remarks
		, [Rp].Employee_CreatedBy
		, [Rp].Employee_UpdatedBy
		, [Rp].DateCreated
		, [Rp].DateUpdated
		
		, [Rp].Code As [ItemCode]
		, [Rp].Name As [ItemName]
		, [Rp].CodeName As [ItemCodeName]
		
		, [L_ItemType].[Desc] As [ItemType_Desc]
		, [L_Category].[Desc] As [Category_Desc]
		, [L_Brand].[Desc] As [Brand_Desc]
		, [L_Retailer].[Desc] As [Retailer_Desc]
		
	From 
		Item As [Tb]
		Left Join uvw_RowProperty As [Rp]
			On [Rp].RowPropertyID = [Tb].RowPropertyID
		Left Join udf_Lookup('ItemType') As [L_ItemType]
			On [L_ItemType].LookupID = [Tb].LookupID_ItemType
		Left Join udf_Lookup('Category') As [L_Category]
			On [L_Category].LookupID = [Tb].LookupID_Category
		Left Join udf_Lookup('Brand') As [L_Brand]
			On [L_Brand].LookupID = [Tb].LookupID_Brand
		Left Join udf_Lookup('Retailer') As [L_Retailer]
			On [L_Retailer].LookupID = [Tb].LookupID_Retailer
GO
/****** Object:  View [dbo].[uvw_Party]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Party]
As
	Select
		[Tb].*
		, IsNull([Tb].PartyCode,'') + ' - ' + IsNull([Tb].PartyName,'') As [PartyCodeName]
	From
		(
		Select
			[Tb].*			
			, [Rp].Code
			, [Rp].IsActive
			, [Rp].Remarks
			, [Rp].Employee_CreatedBy
			, [Rp].Employee_UpdatedBy
			, [Rp].DateCreated
			, [Rp].DateUpdated			
			, [A].Address_Complete As [Address]
			, [Lkp_PartyType].[Name] As [PartyType_Desc]
			, (
			Case [Tb].System_LookupID_PartyType
				When 1 Then [E].EmployeeName
				When 2 Then [C].CustomerName
				Else [Rp].Name
			End
			) As [PartyName]
			, [Rp].Code As [PartyCode]
		From
			Party As [Tb]
			Left Join uvw_RowProperty As [Rp]
				On [Rp].RowPropertyID = [Tb].RowPropertyID
			Left Join uvw_Address As [A]
				On [A].AddressID = [Tb].AddressID
			Left Join System_LookupPartyType As [Lkp_PartyType]
				On [Lkp_PartyType].System_LookupPartyTypeID = [Tb].System_LookupID_PartyType
			Left Join uvw_Employee_Name As [E]
				On [E].PartyID = [Tb].PartyID
				And [Tb].System_LookupID_PartyType = 1
			Left Join uvw_Customer_Name As [C]
				On [C].PartyID = [Tb].PartyID
				And [Tb].System_LookupID_PartyType = 2
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseSnapshot_Details_Max]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_InventoryWarehouseSnapshot_Details_Max]
As
	Select
		[Tb_Max].InventoryWarehouseSnapshotID
		, [Tb_Max].WarehouseID
		, [Tbd].ItemID
		, [Tbd].Qty
		, [Tb].SnapshotDate
	From
		(
		Select
			Max(InventoryWarehouseSnapshotID) As InventoryWarehouseSnapshotID
			, WarehouseID
		From
			InventoryWarehouseSnapshot
		Group By
			WarehouseID
		) As [Tb_Max]
		Inner Join InventoryWarehouseSnapshot As [Tb]
			On [Tb].InventoryWarehouseSnapshotID = [Tb_Max].InventoryWarehouseSnapshotID
		Inner Join InventoryWarehouseSnapshot_Details As [Tbd]
			On [Tbd].InventoryWarehouseSnapshotID = [Tb_Max].InventoryWarehouseSnapshotID
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseSnapshot_Details]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_InventoryWarehouseSnapshot_Details]
As
	Select	
		[Tbd].*
		, Row_Number() Over (Partition By [Tb].WarehouseID, [Tbd].ItemID Order By [Tb].WarehouseID, [Tbd].ItemID, [Tb].SnapshotDate Desc) As [Ct]
		, [Tb].WarehouseID
		, [Tb].SnapshotDate
	From
		InventoryWarehouseSnapshot As [Tb]
		Inner Join InventoryWarehouseSnapshot_Details As [Tbd]
			On [Tbd].InventoryWarehouseSnapshotID = [Tb].InventoryWarehouseSnapshotID
GO
/****** Object:  View [dbo].[uvw_AccountingLedgerPostingPeriod]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_AccountingLedgerPostingPeriod]
As
	Select
		[Tb].*
		, [D].DocNo
		, [D].DateApplied
		, [D].DatePosted
		, [D].EmployeeID_PostedBy
		, [D].Employee_PostedBy
	From
		AccountingLedgerPostingPeriod As [Tb]
		Left Join uvw_Document As [D]
			On [D].DocumentID = [Tb].DocumentID
GO
/****** Object:  UserDefinedFunction [dbo].[udf_InventoryWarehouseSnapshot_Details_Max]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[udf_InventoryWarehouseSnapshot_Details_Max]
(
	@DateCheck As DateTime
)	
Returns Table
As
Return
	(
	Select
		[Tb_Max].InventoryWarehouseSnapshotID
		, [Tb_Max].WarehouseID
		, [Tbd].ItemID
		, [Tbd].Qty
		, [Tb].SnapshotDate
	From
		(
		Select
			Max(InventoryWarehouseSnapshotID) As InventoryWarehouseSnapshotID
			, WarehouseID
		From
			InventoryWarehouseSnapshot
		Where
			SnapshotDate <= @DateCheck
		Group By
			WarehouseID
		) As [Tb_Max]
		Inner Join InventoryWarehouseSnapshot As [Tb]
			On [Tb].InventoryWarehouseSnapshotID = [Tb_Max].InventoryWarehouseSnapshotID
		Inner Join InventoryWarehouseSnapshot_Details As [Tbd]
			On [Tbd].InventoryWarehouseSnapshotID = [Tb_Max].InventoryWarehouseSnapshotID
	)
GO
/****** Object:  UserDefinedFunction [dbo].[udf_InventoryWarehouse_Current_Item]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[udf_InventoryWarehouse_Current_Item]
(
	@DateCheck As DateTime
)	
Returns Table
As
Return
	(
	Select
		[Tb].ItemID
		, [Tb].WarehouseID
		, Sum([Tb].Qty) As [Qty]
	From
		(
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID_TransferFrom As [WarehouseID]
			, (Sum([Tbd].Qty) * -1) As [Qty]
		From 
			uvw_InventoryWarehouseTransfer_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID_TransferFrom
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID_TransferFrom
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID_TransferTo As [WarehouseID]
			, Sum([Tbd].Qty) As [Qty]
		From 
			uvw_InventoryWarehouseTransfer_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID_TransferTo
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID_TransferTo
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, Sum([Tbd].Qty) As [Qty]
		From 
			uvw_InventoryWarehouseOpening_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, Sum([Tbd].Qty) As [Qty]
		From 
			uvw_InventoryWarehouseAdjustment_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, Sum([Tbd].Qty) As [Qty]
		From 
			uvw_TransactionReceiveOrder_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, (Sum([Tbd].Qty) * -1) As [Qty]
		From 
			uvw_TransactionDeliverOrder_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, Sum([Tbd].Qty) As [Qty]
		From 
			uvw_TransactionSalesReturn_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, (Sum([Tbd].Qty) * -1) As [Qty]
		From 
			uvw_TransactionPurchaseReturn_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Snapshot].ItemID
			, [Snapshot].WarehouseID
			, [Snapshot].Qty
		From 
			udf_InventoryWarehouseSnapshot_Details_Max(@DateCheck) As [Snapshot]
		) As [Tb]
	Group By
		[Tb].ItemID
		, [Tb].WarehouseID
	)
GO
/****** Object:  View [dbo].[uvw_Bank]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_Bank]
As
	Select 
		[Tb].*
		, [Party].PartyCode As [BankCode]
		, [Party].PartyName As [BankName]
		, [Party].PartyCodeName As [BankCodeName]
		, [Party].Address
		, [Party].Employee_CreatedBy
		, [Party].Employee_UpdatedBy
		, [Party].DateCreated
		, [Party].DateUpdated
	From 
		Bank As [Tb]
		Left Join uvw_Party As [Party]
			On [Party].PartyID = [Tb].PartyID
GO
/****** Object:  View [dbo].[uvw_AccountingChartOfAccounts]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_AccountingChartOfAccounts]
As
	Select 
		[Tb].*
		
		, [Rp].Code
		, [Rp].Name
		, [Rp].CodeName
		, [Rp].IsActive
		, [Rp].Remarks
		, [Rp].Employee_CreatedBy
		, [Rp].Employee_UpdatedBy
		, [Rp].DateCreated
		, [Rp].DateUpdated
		
		, [Rp].Code As [AccountCode]
		, [Rp].Name As [AccountName]
		, [Rp].CodeName As [AccountCodeName]
		
		, [Pr].PartyCode
		, [Pr].PartyName
		, [Pr].PartyCodeName
		, [Pr].PartyType_Desc
		
		, [Lkp_AccountType].[Desc] As [AccountType_Desc]
		, [Lkp_Currency].[Desc] As [Currency_Desc]
		
		, (
		Case [Tb].IsDebit
			When 1 Then
				'Debit'
			Else
				'Credit'
		End
		) As [IsDebit_Desc]
		
	From 
		AccountingChartOfAccounts As [Tb]
		Left Join uvw_RowProperty As [Rp]
			On [Rp].RowPropertyID = [Tb].RowPropertyID
		Left Join uvw_Party As [Pr]
			On [Pr].PartyID = [Tb].PartyID_Subsidiary
		Left Join udf_System_Lookup('AccountType') As [Lkp_AccountType]
			On [Lkp_AccountType].System_LookupID = [Tb].System_LookupID_AccountType
		Left Join udf_Lookup('Currency') As [Lkp_Currency]
			On [Lkp_Currency].LookupID = [Tb].LookupID_Currency
GO
/****** Object:  View [dbo].[uvw_Employee]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Employee]
As
	Select 
		[Tb].*
		, [Party].PartyCode As [EmployeeCode]
		, [Party].PartyName As [EmployeeName]
		, [Party].PartyCodeName As [EmployeeCodeName]
		, [Party].Employee_CreatedBy
		, [Party].Employee_UpdatedBy
		, [Party].DateCreated
		, [Party].DateUpdated
	From 
		Employee As [Tb]
		Left Join uvw_Party As [Party]
			On [Party].PartyID = [Tb].PartyID
GO
/****** Object:  View [dbo].[uvw_DocumentItem_Details]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_DocumentItem_Details]
As
	Select
		[Tb].*
		, IsNull([Tb].Qty,0) * IsNull([Tb].DiscountPrice,0) As [PriceAmount]
		, IsNull([Tb].Qty,0) * IsNull([Tb].Cost,0) As [CostAmount]
	From
		(
		Select
			[Tb].*
			, (
			Case 
				When [Tb].DiscountPrice_Ex >= 0 Then [Tb].DiscountPrice_Ex
				Else 0
			End
			) As [DiscountPrice]
		From
			(
			Select
				[Tb].*
				, (IsNull([Tb].Price,0) - IsNull([Tb].PriceDiscount_Value_Ex,0)) As [DiscountPrice_Ex]
			From
				(
				Select 
					[Tb].*
					, [I].ItemCode
					, [I].ItemName
					, [I].ItemCodeName
					, [I].ItemType_Desc
					, [I].Category_Desc
					, [I].Brand_Desc
					, [I].Retailer_Desc
					, (
					Case IsNull([Tb].PriceDiscount_IsPerc,0)
						When 0 Then [Tb].PriceDiscount_Value
						Else [Tb].Price * ([Tb].PriceDiscount_Value / 100)
					End
					) As [PriceDiscount_Value_Ex]
				From 
					DocumentItem_Details As [Tb]
					Left Join uvw_Item As [I]
						On [I].ItemID = [Tb].ItemID
				) As [Tb]
			) As [Tb]
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouse_Current_Item]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_InventoryWarehouse_Current_Item]
As
	Select
		[Tb].ItemID
		, [Tb].WarehouseID
		, IsNull(Sum([Tb].Qty),0) As [Qty]
	From
		(
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID_TransferFrom As [WarehouseID]
			, (Sum([Tbd].Qty) * -1) As [Qty]
		From 
			uvw_InventoryWarehouseTransfer_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID_TransferFrom
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID_TransferFrom
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID_TransferTo As [WarehouseID]
			, Sum([Tbd].Qty) As [Qty]
		From 
			uvw_InventoryWarehouseTransfer_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID_TransferTo
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID_TransferTo
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, Sum([Tbd].Qty) As [Qty]
		From 
			uvw_InventoryWarehouseOpening_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, Sum([Tbd].Qty) As [Qty]
		From 
			uvw_InventoryWarehouseAdjustment_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, Sum([Tbd].Qty) As [Qty]
		From 
			uvw_TransactionReceiveOrder_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, (Sum([Tbd].Qty) * -1) As [Qty]
		From 
			uvw_TransactionDeliverOrder_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, Sum([Tbd].Qty) As [Qty]
		From 
			uvw_TransactionSalesReturn_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, (Sum([Tbd].Qty) * -1) As [Qty]
		From 
			uvw_TransactionPurchaseReturn_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
				),'1900-01-01')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Snapshot].ItemID
			, [Snapshot].WarehouseID
			, [Snapshot].Qty
		From 
			uvw_InventoryWarehouseSnapshot_Details_Max As [Snapshot]
		) As [Tb]
	Group By
		[Tb].ItemID
		, [Tb].WarehouseID
GO
/****** Object:  View [dbo].[uvw_ReleasedChecks]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_ReleasedChecks]
As
	Select
		[Tb].*
		, (
		Case IsNull([Tb].IsCancelled,0)
			When 1 Then
				'Cancelled'
			Else
			(
			Case IsNull([Tb].IsPosted,0)
				When 1 Then 
					(
					Case IsNull([Tb].IsEncashed,0)
						When 1 Then
							'Posted - Encashed'
						Else
							'Posted'
					End
					)
				Else 
					'Open'
			End
			)
		End
		) As [Status]
	From
		(
		Select 
			[Tb].*
			, [Rp].Remarks
			, [Rp].Employee_CreatedBy
			, [Rp].Employee_UpdatedBy
			, [Rp].DateCreated
			, [Rp].DateUpdated
			, [D].DocNo
			, [D].IsPosted
			, [D].IsCancelled
			, [D].DatePosted
			, [D].DateCancelled
			, [D].Employee_PostedBy
			, [D].Employee_CancelledBy
			, [P].PartyCode
			, [P].PartyName
			, [P].PartyCodeName
			, [P].PartyType_Desc
		From 
			ReleasedChecks As [Tb]
			Left Join uvw_RowProperty As [Rp]
				On [Rp].RowPropertyID = [Tb].RowPropertyID
			Left Join uvw_Document As [D]
				On [D].DocumentID = [Tb].DocumentID
			Left Join uvw_Party As [P]
				On [P].PartyID = [Tb].PartyID
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_Supplier]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Supplier]
As
	Select 
		[Tb].*
		, [Party].PartyCode As [SupplierCode]
		, [Party].PartyName As [SupplierName]
		, [Party].PartyCodeName As [SupplierCodeName]
		, [Party].Address
		, [Party].Employee_CreatedBy
		, [Party].Employee_UpdatedBy
		, [Party].DateCreated
		, [Party].DateUpdated
	From 
		Supplier As [Tb]
		Left Join uvw_Party As [Party]
			On [Party].PartyID = [Tb].PartyID
		Left Join udf_Lookup('LookupID_PaymentTerm') As [Lkp_PaymentTerm]
			On [Lkp_PaymentTerm].LookupID = [Tb].LookupID_PaymentTerm
GO
/****** Object:  View [dbo].[uvw_TransactionDeliverOrder_IsInvoiced]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionDeliverOrder_IsInvoiced]
As	
	Select
		[Tb].TransactionDeliverOrderID
		, Cast(
		(
		Case 
			When [Tb].TransactionDeliverOrderID Is Not Null Then 1
			Else 0
		End
		) As Bit) As [IsInvoiced]
	From
		(
		Select [Si].TransactionDeliverOrderID
		From 
			TransactionSalesInvoice As [Si]
			Left Join uvw_Document As [D]
				On [D].DocumentID = [Si].DocumentID
		Where 
			[D].IsPosted = 1
			And IsNull([D].IsCancelled,0) = 0
			And IsNull([Si].IsDeleted,0) = 0
		Group By [Si].TransactionDeliverOrderID
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_Rights_Details]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Rights_Details]
As
	Select
		[Sma].RightsID
		, [Sma].Rights_Name
		, [Sma].System_ModulesID
		, [Sma].System_Modules_AccessLibID
		, [Sma].System_Modules_Name
		, [Sma].System_Modules_Code
		, [Sma].System_Modules_AccessID
		, [Sma].Parent_System_Modules_Name
		, [Sma].Parent_System_ModulesID
		, [Sma].[Desc] As [System_Modules_Access_Desc]
		, [Rd].Rights_DetailsID
		, IsNull(Rd.[IsAllowed], 0) As [IsAllowed]
	From
		[Rights] As [R]
		Left Join [Rights_Details] As [Rd]
			On [R].[RightsID] = [Rd].[RightsID]		
		Right Join
			(
			Select
				[R].RightsID
				, [R].[Name] As [Rights_Name]
				, [Sma].System_Modules_AccessID
				, [Sma].System_ModulesID
				, [Sma].System_Modules_AccessLibID
				, [Sma].Parent_System_ModulesID
				, [Sma].[Parent_System_Modules_Name]
				, [Sma].[System_Modules_Name]
				, [Sma].[System_Modules_Code]
				, [Sma].[Desc]
			From
				uvw_Rights As [R]
				, uvw_System_Modules_Access As [Sma]
			) As [Sma]
			On [Sma].[System_Modules_AccessID] = [Rd].[System_Modules_AccessID]
			And R.RightsID = Sma.RightsID
GO
/****** Object:  View [dbo].[uvw_Item_Part]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Item_Part]
As	
	Select 
		[Tb].*
		, [I].ItemCode
		, [I].ItemName
		, [I_Part].ItemCode As [Part_ItemCode]
		, [I_Part].ItemName As [Part_ItemName]
		, [I_Part].ItemCodeName As [Part_ItemCodeName]
	From 
		Item_Part As [Tb]
		Left Join uvw_Item As [I]
			On [I].ItemID = [Tb].ItemID
		Left Join uvw_Item As [I_Part]
			On [I_Part].ItemID = [Tb].ItemID_Part
GO
/****** Object:  View [dbo].[uvw_Warehouse]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Warehouse]
As
	Select 
		[Tb].*
		, [Party].PartyCode As [WarehouseCode]
		, [Party].PartyName As [WarehouseName]
		, [Party].PartyCodeName As [WarehouseCodeName]
		, [Party].Address
		, [Party].Employee_CreatedBy
		, [Party].Employee_UpdatedBy
		, [Party].DateCreated
		, [Party].DateUpdated
	From 
		Warehouse As [Tb]
		Left Join uvw_Party As [Party]
			On [Party].PartyID = [Tb].PartyID
GO
/****** Object:  View [dbo].[uvw_TransactionSalesInvoice_DocumentItem_Balance]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesInvoice_DocumentItem_Balance]
As
	Select 
		[Tb].* 
		, (
			[Tb].Qty 
			-  IsNull([Srdi].Qty,0)
			) As [Balance_Qty]
	From 
		(
		Select
			[Dodi].*
			, [Si].TransactionSalesInvoiceID
		From
			TransactionSalesInvoice As [Si]
			Inner Join uvw_TransactionDeliverOrder_DocumentItem  As [Dodi]
				On [Dodi].TransactionDeliverOrderID = [Si].TransactionDeliverOrderID
		) As [Tb]
		Left Join
			(
			Select
				TransactionSalesInvoiceID
				, ItemID
				, Sum(Qty) As [Qty]
			From
				uvw_TransactionSalesReturn_DocumentItem
			Where
				IsNull(IsPosted,0) = 1
				And IsNull(IsCancelled,0) = 0
				And IsNull(IsDeleted,0) = 0
			Group By
				TransactionSalesInvoiceID
				, ItemID
			) As [Srdi]
			On [Srdi].TransactionSalesInvoiceID = [Tb].TransactionSalesInvoiceID
			And [Srdi].ItemID = [Tb].ItemID
GO
/****** Object:  View [dbo].[uvw_TransactionReceiveOrder_IsInvoiced]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionReceiveOrder_IsInvoiced]
As	
	Select
		[Tb].TransactionReceiveOrderID
		, Cast(1 As Bit) As [IsInvoiced]
	From
		(
		Select [Piro].TransactionReceiveOrderID
		From 
			TransactionPurchaseInvoice As [Pi]
			Left Join TransactionPurchaseInvoice_ReceiveOrder As [Piro]
				On [Piro].TransactionPurchaseInvoiceID = [Pi].TransactionPurchaseInvoiceID
			Left Join uvw_Document As [D]
				On [D].DocumentID = [Pi].DocumentID
		Where 
			[D].IsPosted = 1
			And IsNull([D].IsCancelled,0) = 0
			And IsNull([Pi].IsDeleted,0) = 0
			And IsNull([Piro].IsDeleted,0) = 0
		Group By [Piro].TransactionReceiveOrderID
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_TransactionSalesOrder_DocumentItem_OrderBalance]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesOrder_DocumentItem_OrderBalance]
As
	Select
		[Tb].*
	From
		(
		Select 
			[Tb].* 
			, (
				[Tb].Qty 
				-  IsNull([Dodi].Qty,0)
				) As [OrderBalance_Qty]
		From 
			uvw_TransactionSalesOrder_DocumentItem As [Tb]
			Left Join
				(
				Select
					TransactionSalesOrderID
					, ItemID
					, Sum(Qty) As [Qty]
				From
					uvw_TransactionDeliverOrder_DocumentItem 
				Where
					IsNull(IsPosted,0) = 1
					And IsNull(IsCancelled,0) = 0
					And IsNull(IsDeleted,0) = 0
				Group By
					TransactionSalesOrderID
					, ItemID
				) As [Dodi]
				On [Dodi].TransactionSalesOrderID = [Tb].TransactionSalesOrderID
				And [Dodi].ItemID = [Tb].ItemID
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_TransactionReceiveOrder_DocumentItem_Balance]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionReceiveOrder_DocumentItem_Balance]
As
	Select 
		[Tb].* 
		, (
			[Tb].Qty 
			-  IsNull([Prdi].Qty,0)
			) As [Balance_Qty]
	From 
		uvw_TransactionReceiveOrder_DocumentItem As [Tb]
		Left Join
			(
			Select
				TransactionReceiveOrderID
				, ItemID
				, Sum(Qty) As [Qty]
			From
				uvw_TransactionPurchaseReturn_DocumentItem
			Where
				IsNull(IsPosted,0) = 1
				And IsNull(IsCancelled,0) = 0
				And IsNull(IsDeleted,0) = 0
			Group By
				TransactionReceiveOrderID
				, ItemID
			) As [Prdi]
			On [Prdi].TransactionReceiveOrderID = [Tb].TransactionReceiveOrderID
			And [Prdi].ItemID = [Tb].ItemID
GO
/****** Object:  View [dbo].[uvw_Materialized_InventoryParty_Current_Item_Desc]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_Materialized_InventoryParty_Current_Item_Desc]
As
	Select
		[Tb].*
		, [Pr].PartyCode
		, [Pr].PartyName
		, [Pr].PartyCodeName
		, [Pr].PartyType_Desc
		, [Pr].System_LookupID_PartyType
		, [I].ItemCode
		, [I].ItemName
		, [I].ItemCodeName
		, [I].ItemType_Desc
		, [I].Category_Desc
		, [I].Brand_Desc
		, [I].Retailer_Desc
	From 
		uvw_Materialized_InventoryParty_Current_Item As [Tb]
		Left Join uvw_Party As [Pr]
			On [Pr].PartyID = [Tb].PartyID
		Left Join uvw_Item As [I]
			On [I].ItemID = [Tb].ItemID
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseOrder_DocumentItem_OrderBalance]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionPurchaseOrder_DocumentItem_OrderBalance]
As
	Select 
		[Tb].* 
		, (
			[Tb].Qty 
			-  IsNull([Rodi].Qty,0)
			) As [OrderBalance_Qty]
	From 
		uvw_TransactionPurchaseOrder_DocumentItem As [Tb]
		Left Join
			(
			Select
				TransactionPurchaseOrderID
				, ItemID
				, Sum(Qty) As [Qty]
			From
				uvw_TransactionReceiveOrder_DocumentItem 
			Where
				IsNull(IsPosted,0) = 1
				And IsNull(IsCancelled,0) = 0
				And IsNull(IsDeleted,0) = 0
			Group By
				TransactionPurchaseOrderID
				, ItemID
			) As [Rodi]
			On [Rodi].TransactionPurchaseOrderID = [Tb].TransactionPurchaseOrderID
			And [Rodi].ItemID = [Tb].ItemID
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionPurchasePayment]
As
	Select 
		[Tb].*
		
		, [Rp].Remarks
		, [Rp].Employee_CreatedBy
		, [Rp].Employee_UpdatedBy
		, [Rp].DateCreated
		, [Rp].DateUpdated
		
		, [D].DocNo
		, [D].Status
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
		, [D].Employee_PostedBy
		, [D].Employee_CancelledBy
		
		, [Pr].PartyCode
		, [Pr].PartyName		
		, [Pr].PartyCodeName
		, [Pr].PartyType_Desc
		
		, [Lkp_PurchasePaymentType].[Desc] As [PurchasePaymentType_Desc]
		
	From 
		TransactionPurchasePayment As [Tb]
		Left Join uvw_RowProperty As [Rp]
			On [Rp].RowPropertyID = [Tb].RowPropertyID
		Left Join uvw_Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Left Join uvw_Party As [Pr]
			On [Pr].PartyID = [Tb].PartyID
		Left Join udf_System_Lookup('PurchasePaymentType') As [Lkp_PurchasePaymentType]
			On [Lkp_PurchasePaymentType].System_LookupID = [Tb].System_LookupID_PurchasePaymentType
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseOrder_IsComplete]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionPurchaseOrder_IsComplete]
As
	Select
		[Tb].TransactionPurchaseOrderID
		, Cast(
			(
			Case
				When [Tb].Ct = 0 Then 1
				Else 0
			End
			) As Bit) As [IsComplete]
	From
		(
		Select 
			Count(1) As Ct 
			, TransactionPurchaseOrderID
		From 
			uvw_TransactionPurchaseOrder_DocumentItem_OrderBalance
		Where
			OrderBalance_Qty > 0
		Group By
			TransactionPurchaseOrderID
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseOrder_DocumentItem_Desc]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionPurchaseOrder_DocumentItem_Desc]
As
	Select
		[Did].*
		, [Podiob].OrderBalance_Qty
		, [Tb].TransactionPurchaseOrderID
		, [Tb].SupplierID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		TransactionPurchaseOrder As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join uvw_DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
		Left Join uvw_TransactionPurchaseOrder_DocumentItem_OrderBalance As [Podiob]
			On [Podiob].TransactionPurchaseOrderID = [Tb].TransactionPurchaseOrderID
			And [Podiob].ItemID = [Did].ItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_TransactionJournalVoucher_Details]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionJournalVoucher_Details]
As
	Select
		[Tbd].*
		
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
		
		, [Coa].AccountCode
		, [Coa].AccountName
		, [Coa].AccountCodeName
		
		, [Pr].PartyCode
		, [Pr].PartyName
		, [Pr].PartyCodeName
		, [Pr].PartyType_Desc

	From
		TransactionJournalVoucher_Details As [Tbd]
		Left Join TransactionJournalVoucher As [Tb]
			On [Tb].TransactionJournalVoucherID = [Tbd].TransactionJournalVoucherID
		Left Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Left Join uvw_Party As [Pr]
			On [Pr].PartyID = [Tbd].PartyID
		Left Join uvw_AccountingChartOfAccounts As [Coa]
			On [Coa].AccountingChartOfAccountsID = [Tbd].AccountingChartOfAccountsID
GO
/****** Object:  View [dbo].[uvw_TransactionSalesOrder_DocumentItem_Desc]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesOrder_DocumentItem_Desc]
As
	Select
		[Did].*
		, [Sodiob].OrderBalance_Qty
		, [Tb].TransactionSalesOrderID
		, [Tb].CustomerID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		TransactionSalesOrder As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join uvw_DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
		Left Join uvw_TransactionSalesOrder_DocumentItem_OrderBalance As [Sodiob]
			On [Sodiob].TransactionSalesOrderID = [Tb].TransactionSalesOrderID
			And [Sodiob].ItemID = [Did].ItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_TransactionSalesOrder_Complete]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesOrder_Complete]
As
	Select
		[So].TransactionSalesOrderID
		, Cast(
			(
			Case
				When IsNull([Tb].Ct,0) = 0 Then 1
				Else 0
			End
			) As Bit) As [IsComplete]
	From
		(
		Select 
			Count(1) As Ct 
			, TransactionSalesOrderID
		From 
			uvw_TransactionSalesOrder_DocumentItem_OrderBalance
		Where
			OrderBalance_Qty > 0
		Group By
			TransactionSalesOrderID
		) As [Tb]
		Right Join TransactionSalesOrder As [So]
			On [So].TransactionSalesOrderID = [Tb].TransactionSalesOrderID
GO
/****** Object:  View [dbo].[uvw_User]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_User]
As
	Select 
		[Tb].*
		, [E].EmployeeName
		, [Rp].IsActive
		, [Rp].Remarks
		, [Rp].Employee_CreatedBy
		, [Rp].Employee_UpdatedBy
		, [Rp].DateCreated
		, [Rp].DateUpdated
	From 
		[User] As [Tb]
		Left Join uvw_Employee As [E]
			On [Tb].EmployeeID = [E].EmployeeID
		Left Join uvw_RowProperty As [Rp]
			On [Rp].RowPropertyID = [Tb].RowPropertyID
GO
/****** Object:  View [dbo].[uvw_Payment_Check_Details]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_Payment_Check_Details]
As
	Select 
		[Tb].*
		, [Bank].BankName
		, [Bank].BankCode
		, [Bank].BankCodeName
	From 
		Payment_Check_Details As [Tb]
		Left Join uvw_Bank As [Bank]
			On [Bank].BankID = [Tb].BankID
GO
/****** Object:  View [dbo].[uvw_Payment_BankTransfer_Details]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_Payment_BankTransfer_Details]
As
	Select 
		[Tb].*
		, [Bank].BankName
		, [Bank].BankCode
		, [Bank].BankCodeName
	From 
		Payment_BankTransfer_Details As [Tb]
		Left Join uvw_Bank As [Bank]
			On [Bank].BankID = [Tb].BankID
GO
/****** Object:  View [dbo].[uvw_Item_Location]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_Item_Location]
As	
	Select 
		[Tb].*
		
		, [I].ItemCode
		, [I].ItemName
		, [I].ItemCodeName
		, [I].ItemType_Desc
		, [I].Category_Desc
		, [I].Brand_Desc
		, [I].Retailer_Desc
		
		, [Wh].WarehouseCode
		, [Wh].WarehouseName
		, [Wh].WarehouseCodeName
	From 
		Item_Location As [Tb]
		Left Join uvw_Item As [I]
			On [I].ItemID = [Tb].ItemID
		Left Join uvw_Warehouse As [Wh]
			On [Wh].WarehouseID = [Tb].WarehouseID
GO
/****** Object:  View [dbo].[uvw_Materialized_InventoryWarehouse_Current_Item]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Materialized_InventoryWarehouse_Current_Item]
As
	Select 
		Row_Number() Over (Order By (Select 0)) As [ID]
		, [Tb].*
		
		, [Wh].WarehouseCode
		, [Wh].WarehouseName
		, [Wh].WarehouseCodeName
		
		, [I]. [ItemCode]
		, [I]. [ItemName]
		, [I]. [ItemCodeName]
		, [I]. [ItemType_Desc]
		, [I]. [Category_Desc]
		, [I]. [Brand_Desc]
		, [I].[Retailer_Desc]
		, [I].Cost
		, [I].Price
		
	From 
		Materialized_InventoryWarehouse_Current_Item As [Tb]
		Left Join uvw_Warehouse As [Wh]
			On [Wh].WarehouseID = [Tb].WarehouseID
		Left Join uvw_Item As [I]
			On [I].ItemID = [Tb].ItemID
GO
/****** Object:  View [dbo].[uvw_Lookup]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Lookup]
As
	Select
		[Tb].*
		, (
		Case IsNull([Tb].Tmp_Lookup_Details_Desc,'')
			When '' Then '-Select Default-'
			Else [Tb].Tmp_Lookup_Details_Desc
		End
		) As [Lookup_Details_Desc]
	From
		(
		Select 
			[L].* 
			, (
			Case IsNull([L].IsLookup_Details,0)
				When 1 Then 
					[Ld].[Desc]
				Else
					(
					Case [L].LookupID
						When 1 Then
							[LCallTopic].[Desc]
						When 3 Then 
							[Lct].[Desc]
						When 19 Then 
							[Ltc].[Desc]
						When 20 Then
							[Wh].WarehouseCodeName
						When 21 Then
							[Lpd].[Desc]
						When 24 Then
							[Lsc].[Desc]
						Else
							''
					End
					)
			End
			) As [Tmp_Lookup_Details_Desc]
		From 
			Lookup As [L]
			Left Join Lookup_Details As [Ld]
				On [Ld].Lookup_DetailsID = [L].Lookup_DetailsID_Default
			
			Left Join LookupCallTopic As [LCallTopic]
				On [LCallTopic].LookupCallTopicID = [L].Lookup_DetailsID_Default
				And [L].LookupID = 1
			
			Left Join LookupClientType As [Lct]
				On [Lct].LookupClientTypeID = [L].Lookup_DetailsID_Default
				And [L].LookupID = 3
				
			Left Join LookupTaxCode As [Ltc]
				On [Ltc].LookupTaxCodeID = [L].Lookup_DetailsID_Default
				And [L].LookupID = 19
				
			Left Join uvw_Warehouse As [Wh]
				On [Wh].WarehouseID = [L].Lookup_DetailsID_Default
				And [L].LookupID = 20
				
			Left Join LookupPriceDiscount As [Lpd]
				On [Lpd].LookupPriceDiscountID = [L].Lookup_DetailsID_Default
				And [L].LookupID = 21
				
			Left Join LookupShippingCost As [Lsc]
				On [Lsc].LookupShippingCostID = [L].Lookup_DetailsID_Default
				And [L].LookupID = 24
			
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_Item_Supplier]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_Item_Supplier]
As	
	Select 
		[Tb].*
		
		, [I].ItemCode
		, [I].ItemName
		, [I].ItemCodeName
		, [I].ItemType_Desc
		, [I].Category_Desc
		, [I].Brand_Desc
		, [I].Retailer_Desc
		
		, [S].SupplierCode
		, [S].SupplierName
		, [S].SupplierCodeName
	From 
		Item_Supplier As [Tb]
		Left Join uvw_Item As [I]
			On [I].ItemID = [Tb].ItemID
		Left Join uvw_Supplier As [S]
			On [S].SupplierID = [Tb].SupplierID
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseTransfer]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_InventoryWarehouseTransfer]
As
	Select
		[Tb].*
		
		, [Rp].Remarks
		, [Rp].Employee_CreatedBy
		, [Rp].Employee_UpdatedBy
		, [Rp].DateCreated
		, [Rp].DateUpdated
		
		, [D].DocNo
		, [D].DateApplied
		, [D].Status
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
		, [D].Employee_PostedBy
		, [D].Employee_CancelledBy
		
		, [Wh_TransferFrom].WarehouseCode As [WarehouseCode_TransferFrom]
		, [Wh_TransferFrom].WarehouseName As [WarehouseName_TransferFrom]
		, [Wh_TransferFrom].WarehouseCodeName As [WarehouseCodeName_TransferFrom]
		, [Wh_TransferFrom].Address As [WarehouseAddress_TransferFrom]
		
		, [Wh_TransferTo].WarehouseCode As [WarehouseCode_TransferTo]
		, [Wh_TransferTo].WarehouseName As [WarehouseName_TransferTo]
		, [Wh_TransferTo].WarehouseCodeName As [WarehouseCodeName_TransferTo]
		, [Wh_TransferTo].Address As [WarehouseAddress_TransferTo]
		
	From
		InventoryWarehouseTransfer As [Tb]
		Left Join uvw_RowProperty As [Rp]
			On [Rp].RowPropertyID = [Tb].RowPropertyID
		Left Join uvw_Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Left Join uvw_Warehouse As [Wh_TransferFrom]
			On [Wh_TransferFrom].WarehouseID = [Tb].WarehouseID_TransferFrom
		Left Join uvw_Warehouse As [Wh_TransferTo]
			On [Wh_TransferTo].WarehouseID = [Tb].WarehouseID_TransferTo
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseTransfer_DocumentItem_Desc]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_InventoryWarehouseTransfer_DocumentItem_Desc]
As
	Select
		[Did].*
		, [Tb].InventoryWarehouseTransferID
		, [Tb].WarehouseID_TransferFrom
		, [Tb].WarehouseID_TransferTo
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		InventoryWarehouseTransfer As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join uvw_DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseReceived_DocumentItem_Desc]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_InventoryWarehouseReceived_DocumentItem_Desc]
As
	Select
		[Did].*
		, [Tb].InventoryWarehouseReceivedID
		, [Tb].WarehouseID
		, [Tb].SupplierID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		InventoryWarehouseReceived As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join uvw_DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseReceived]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_InventoryWarehouseReceived]
As
	Select
		[Tb].*
		
		, [Rp].Remarks
		, [Rp].Employee_CreatedBy
		, [Rp].Employee_UpdatedBy
		, [Rp].DateCreated
		, [Rp].DateUpdated
		
		, [D].DocNo
		, [D].DateApplied
		, [D].Status
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
		, [D].Employee_PostedBy
		, [D].Employee_CancelledBy
		
		, [Wh].WarehouseCode
		, [Wh].WarehouseName
		, [Wh].WarehouseCodeName
		
		, [S].SupplierCode
		, [S].SupplierName
		, [S].SupplierCodeName
		
	From
		InventoryWarehouseReceived As [Tb]
		Left Join uvw_RowProperty As [Rp]
			On [Rp].RowPropertyID = [Tb].RowPropertyID
		Left Join uvw_Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Left Join uvw_Warehouse As [Wh]
			On [Wh].WarehouseID = [Tb].WarehouseID
		Left Join uvw_Supplier As [S]
			On [S].SupplierID = [Tb].SupplierID
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseOpening_DocumentItem_Desc]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_InventoryWarehouseOpening_DocumentItem_Desc]
As
	Select
		[Did].*
		, [Tb].InventoryWarehouseOpeningID
		, [Tb].WarehouseID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		InventoryWarehouseOpening As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join uvw_DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_Inventory_Status_Item]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Inventory_Status_Item]
As
	Select
		[Tb].*
		, (
		Case
			When IsNull([Tb].So_Qty,0) > 0 Then IsNull([Tb].So_Qty,0) - IsNull([Tb].Committed_Qty,0)
			Else 0
		End) As [BackOrder_Qty]
	From
		(
		Select 
			[I].ItemID
			, [I].ItemCode
			, [I].ItemName
			, [I].ItemCodeName
			, [I].ItemType_Desc
			, [I].Category_Desc
			, [I].Brand_Desc
			, [I].Retailer_Desc
			
			, IsNull([Inv].Qty,0) As [Inv_Qty]
			, IsNull([Po].Qty,0) As [Po_Qty]
			, IsNull([So].Qty,0) As [So_Qty]
			, (
			Case
				When (IsNull([Inv].Qty,0) >= IsNull([So].Qty,0)) And (IsNull([So].Qty,0) > 0) Then IsNull([So].Qty,0)
				When (IsNull([So].Qty,0) > 0) Then  IsNull([So].Qty,0) - (IsNull([So].Qty,0) - IsNull([Inv].Qty,0))
				Else 0
			End) As [Committed_Qty]
		From 
			uvw_Item As [I]
			Left Join
				(
				Select 
					ItemID
					, Sum(OrderBalance_Qty) As [Qty]
				From 
					uvw_TransactionSalesOrder_DocumentItem_OrderBalance
				Where
					IsNull(IsPosted,0) = 1
					And IsNull(IsCancelled,0) = 0
					And IsNull(IsDeleted,0) = 0
				Group By
					ItemID
				) As [So]
				On [So].ItemID = [I].ItemID
			Left Join 
				(
				Select 
					ItemID
					, Sum(OrderBalance_Qty) As [Qty]
				From 
					uvw_TransactionPurchaseOrder_DocumentItem_OrderBalance
				Where
					IsNull(IsPosted,0) = 1
					And IsNull(IsCancelled,0) = 0
					And IsNull(IsDeleted,0) = 0
				Group By
					ItemID
				) As [Po]
				On [Po].ItemID = [I].ItemID
			Left Join
				(
				Select
					ItemID
					, Sum(Qty) As [Qty]
				From 
					Materialized_InventoryWarehouse_Current_Item
				Group By
					ItemID
				) As [Inv]
				On [Inv].ItemID = [I].ItemID
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseOpening]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_InventoryWarehouseOpening]
As
	Select
		[Tb].*
		
		, [Rp].Remarks
		, [Rp].Employee_CreatedBy
		, [Rp].Employee_UpdatedBy
		, [Rp].DateCreated
		, [Rp].DateUpdated
		
		, [D].DocNo
		, [D].DateApplied
		, [D].Status
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
		, [D].Employee_PostedBy
		, [D].Employee_CancelledBy
		
		, [Wh].WarehouseCode
		, [Wh].WarehouseName
		, [Wh].WarehouseCodeName
		, [Wh].Address As [WarehouseAddress]
		
	From
		InventoryWarehouseOpening As [Tb]
		Left Join uvw_RowProperty As [Rp]
			On [Rp].RowPropertyID = [Tb].RowPropertyID
		Left Join uvw_Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Left Join uvw_Warehouse As [Wh]
			On [Wh].WarehouseID = [Tb].WarehouseID
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseAdjustment_DocumentItem_Desc]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_InventoryWarehouseAdjustment_DocumentItem_Desc]
As
	Select
		[Did].*
		, [Tb].InventoryWarehouseAdjustmentID
		, [Tb].WarehouseID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		InventoryWarehouseAdjustment As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join uvw_DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseAdjustment]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_InventoryWarehouseAdjustment]
As
	Select
		[Tb].*
		
		, [Rp].Remarks
		, [Rp].Employee_CreatedBy
		, [Rp].Employee_UpdatedBy
		, [Rp].DateCreated
		, [Rp].DateUpdated
		
		, [D].DocNo
		, [D].DateApplied
		, [D].Status
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
		, [D].Employee_PostedBy
		, [D].Employee_CancelledBy
		
		, [Wh].WarehouseCode
		, [Wh].WarehouseName
		, [Wh].WarehouseCodeName
		, [Wh].Address As [WarehouseAddress]
		
	From
		InventoryWarehouseAdjustment As [Tb]
		Left Join uvw_RowProperty As [Rp]
			On [Rp].RowPropertyID = [Tb].RowPropertyID
		Left Join uvw_Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Left Join uvw_Warehouse As [Wh]
			On [Wh].WarehouseID = [Tb].WarehouseID
GO
/****** Object:  View [dbo].[uvw_DocumentChartOfAccounts_Details]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_DocumentChartOfAccounts_Details]
As
	Select
		[Tb].*
		, (IsNull([Tb].Amount,0) - IsNull([Tb].Tax_Amount,0)) As [Gross_Amount]
		
		, [Coa].AccountCode
		, [Coa].AccountName
		, [Coa].AccountCodeName
		, [Coa].System_LookupID_AccountType
		, [Coa].AccountType_Desc
		
	From
		DocumentChartOfAccounts_Details As [Tb]
		Left Join uvw_AccountingChartOfAccounts As [Coa]
			On [Coa].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID
GO
/****** Object:  StoredProcedure [dbo].[usp_InventoryWarehouse_Update_Current_Item]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_InventoryWarehouse_Update_Current_Item]
@ID_ItemWarehouse As VarChar(Max) = ''
As
Begin
	Declare @Ex_ID_ItemWarehouse As VarChar(Max)
	Declare @cItemID As VarChar(50)
	Declare @cWarehouseID As VarChar(50)
	
	Declare @SqlQuery As VarChar(Max)
	Declare @SqlQuery_Source As VarChar(Max)
	Declare @SqlQuery_Source_Criteria_ItemWarehouse As VarChar(Max)
	Declare @SqlQuery_Source_Criteria_Or As VarChar(10)
	
	Select
		@SqlQuery = ''
		, @SqlQuery_Source = ''
		, @SqlQuery_Source_Criteria_ItemWarehouse = ''
		, @SqlQuery_Source_Criteria_Or = ''
	
	If @ID_ItemWarehouse <> ''
	Begin
	
		Set @Ex_ID_ItemWarehouse = @ID_ItemWarehouse
		While (Select CharIndex('</I>',@Ex_ID_ItemWarehouse)) <> 0 
		Begin
			Select @cItemID = SubString(@Ex_ID_ItemWarehouse,CharIndex('<I>',@Ex_ID_ItemWarehouse) + 3,(CharIndex('</I>',@Ex_ID_ItemWarehouse) - 4))
			Select @Ex_ID_ItemWarehouse = SubString(@Ex_ID_ItemWarehouse,(CharIndex('</I>',@Ex_ID_ItemWarehouse) + 4),Len(@Ex_ID_ItemWarehouse))

			Select @cWarehouseID = SubString(@Ex_ID_ItemWarehouse,CharIndex('<WH>',@Ex_ID_ItemWarehouse) + 4,(CharIndex('</WH>',@Ex_ID_ItemWarehouse) - 5))
			Select @Ex_ID_ItemWarehouse = SubString(@Ex_ID_ItemWarehouse,(CharIndex('</WH>',@Ex_ID_ItemWarehouse) + 5),Len(@Ex_ID_ItemWarehouse))
			
			Set @SqlQuery_Source_Criteria_ItemWarehouse =
				@SqlQuery_Source_Criteria_ItemWarehouse +
				' ' + @SqlQuery_Source_Criteria_Or + '
				(ItemID = ' + @cItemID + ' And WarehouseID = ' + @cWarehouseID + ' ) 
				 '
				Set @SqlQuery_Source_Criteria_Or = 'Or'
		End
		
		Set @SqlQuery_Source_Criteria_ItemWarehouse = ' And (' + @SqlQuery_Source_Criteria_ItemWarehouse + ')'
		
		Set @SqlQuery_Source =
			'
			Select * 
			From uvw_InventoryWarehouse_Current_Item
			Where
				1 = 1
				' + @SqlQuery_Source_Criteria_ItemWarehouse + '
			'
		
		Set @SqlQuery = 
			'
			Update Materialized_InventoryWarehouse_Current_Item 
			Set
				[Qty] = Source.[Qty]
			From
				(' + @SqlQuery_Source + ') As [Source]
				, Materialized_InventoryWarehouse_Current_Item As [Target]
			Where
				[Source].ItemID = [Target].ItemID
				And [Source].WarehouseID = [Target].WarehouseID
			
			Insert Into Materialized_InventoryWarehouse_Current_Item
				(
				ItemID
				, WarehouseID
				, Qty
				)
			Select
				ItemID
				, WarehouseID
				, Qty
			From
				(' + @SqlQuery_Source + ') As [Source]
			Where
				Not Exists
				(
				Select *
				From Materialized_InventoryWarehouse_Current_Item As [Target]
				Where
					[Source].ItemID = [Target].ItemID
					And [Source].WarehouseID = [Target].WarehouseID
				)
			'
		Exec(@SqlQuery)
		
	End
	Else
	Begin
		Truncate Table Materialized_InventoryWarehouse_Current_Item
		Insert Into Materialized_InventoryWarehouse_Current_Item
			(
			ItemID
			, WarehouseID
			, Qty
			)
		Select
			ItemID
			, WarehouseID
			, Qty
		From
			uvw_InventoryWarehouse_Current_Item As [Source]
	End
End
GO
/****** Object:  View [dbo].[uvw_AccountingBudget]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_AccountingBudget]
As
	Select 
		[Tb].*
		
		, [Rp].Code
		, [Rp].Name
		, [Rp].CodeName
		, [Rp].IsActive
		, [Rp].Remarks
		, [Rp].Employee_CreatedBy
		, [Rp].Employee_UpdatedBy
		, [Rp].DateCreated
		, [Rp].DateUpdated
		
		, [Coa].AccountCode
		, [Coa].AccountName
		, [Coa].AccountCodeName
		
		, [Pr].PartyCode
		, [Pr].PartyName
		, [Pr].PartyCodeName
		, [Pr].PartyType_Desc
		
	From 
		AccountingBudget As [Tb]
		Left Join uvw_RowProperty As [Rp]
			On [Rp].RowPropertyID = [Tb].RowPropertyID
		Left Join uvw_AccountingChartOfAccounts As [Coa]
			On [Coa].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID
		Left Join uvw_Party As [Pr]
			On [Pr].PartyID = [Tb].PartyID
GO
/****** Object:  View [dbo].[uvw_AccountingLedger]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_AccountingLedger]
As
	Select
		[Tb].*
		, [Coa].AccountCode
		, [Coa].AccountName
		, [Coa].AccountCodeName
		, [Coa].AccountType_Desc
		, [Coa].System_LookupID_AccountType
		, [Coa].IsDebit As [Coa_IsDebit]
		
		, (
			Case [Tb].IsDebit
				When 1 Then 'Debit'
				Else 'Credit'
			End
			) As [EntryType]
		
		, [Pr].PartyCode
		, [Pr].PartyName
		, [Pr].PartyCodeName
		, [Pr].PartyType_Desc
		
		, [Sm].Name As [Module_Name]
		
	From
		(
		Select
			'Current' As [Tb]
			, AccountingChartOfAccountsID
			, System_ModulesID
			, TableName
			, SourceID
			, DocNo
			, DatePosted
			, PartyID
			, Amount
			, IsDebit
		From
			AccountingLedger_Current
		
		Union All
		
		Select
			'Posted' As [Tb]
			, AccountingChartOfAccountsID
			, System_ModulesID
			, TableName
			, SourceID
			, DocNo
			, DatePosted
			, PartyID
			, Amount
			, IsDebit
		From
			AccountingLedger_Posted
		) As [Tb]
		Left Join uvw_AccountingChartOfAccounts As [Coa]
			On [Coa].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID
		Left Join uvw_Party As [Pr]
			On [Pr].PartyID = [Tb].PartyID
		Left Join System_Modules As [Sm]
			On [Sm].System_ModulesID = [Tb].System_ModulesID
GO
/****** Object:  View [dbo].[uvw_AccountingChartOfAccounts_Parent]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_AccountingChartOfAccounts_Parent]
As
	Select
		[Tb].*
		, [Tb_Parent].AccountCode As [Parent_AccountCode]
		, [Tb_Parent].AccountName As [Parent_AccountName]
		, [Tb_Parent].AccountCodeName As [Parent_AccountCodeName]
	From
		uvw_AccountingChartOfAccounts As [Tb]
		Left Join uvw_AccountingChartOfAccounts As [Tb_Parent]
			On [Tb_Parent].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID_Parent
GO
/****** Object:  View [dbo].[uvw_Customer]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_Customer]
As
	Select 
		[Tb].*
		, (
		Case [Tb].IsCreditHold
			When 1 Then 'Yes'
			Else '-'
		End
		) As [IsCreditHold_Desc]
		, (
		IsNull([Tb].CreditCardNo1,'')
		+ '-'
		+ IsNull([Tb].CreditCardNo2,'')
		+ '-'
		+ IsNull([Tb].CreditCardNo3,'')
		+ '-'
		+ IsNull([Tb].CreditCardNo4,'')
		) As [CreditCard_Complete]
		, [Lkp_ClientType].[Desc] As [ClientType_Desc]
		, [Lkp_TaxCode].[Desc] As [TaxCode_Desc]
		, [Lkp_TaxCode].[PST_Value]
		, [Lkp_TaxCode].[GST_Value]
		, [Lkp_TaxCode].[HST_Value]
		, [Lkp_ShipVia].[Desc] As [ShipVia_Desc]
		, [E_SP].EmployeeName As [EmployeeName_SalesPerson]
		, [E_SP].EmployeeCodeName As [EmployeeCodeName_SalesPerson]
		, [Party].PartyCode As [CustomerCode]
		, [Party].PartyName As [CustomerName]
		, [Party].PartyCodeName As [CustomerCodeName]
		, [Party].Address
		, [Party].Employee_CreatedBy
		, [Party].Employee_UpdatedBy
		, [Party].DateCreated
		, [Party].DateUpdated
	From 
		Customer As [Tb]
		Left Join uvw_Employee As [E_SP]
			On [E_SP].EmployeeID = [Tb].EmployeeID_SalesPerson
		Left Join LookupClientType As [Lkp_ClientType]
			On [Lkp_ClientType].LookupClientTypeID = [Tb].LookupClientTypeID
		Left Join LookupTaxCode As [Lkp_TaxCode]
			On [Lkp_TaxCode].LookupTaxCodeID = [Tb].LookupTaxCodeID
		Left Join udf_Lookup('ShipVia') As [Lkp_ShipVia]
			On [Lkp_ShipVia].LookupID = [Tb].LookupID_ShipVia
		Left Join udf_Lookup('Currency') As [Lkp_Currency]
			On [Lkp_Currency].LookupID = [Tb].LookupID_Currency
		Left Join udf_Lookup('PaymentTerm') As [Lkp_PaymentTerm]
			On [Lkp_PaymentTerm].LookupID = [Tb].LookupID_PaymentTerm
		Left Join uvw_Party As [Party]
			On [Party].PartyID = [Tb].PartyID
GO
/****** Object:  UserDefinedFunction [dbo].[udf_InventoryWarehouse_History_Item_Union]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[udf_InventoryWarehouse_History_Item_Union]
(
	@DateStart As DateTime
	, @DateEnd As DateTime
)	
Returns Table
As
Return
	(
	Select
		[Tb].*
		, [Wh].PartyID
	From
		(
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID_TransferFrom As [WarehouseID]
			, ([Tbd].Qty * -1) As [Qty]
			, 1 As [Flag]
			, 'Transfered To: ' + IsNull([W].WarehouseCodeName,'') As [Entry_Desc]
		From 
			uvw_InventoryWarehouseTransfer_DocumentItem As [Tbd]
			Left Join uvw_Warehouse As [W]
				On [W].WarehouseID = [Tbd].WarehouseID_TransferTo
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID_TransferTo As [WarehouseID]
			, [Tbd].Qty
			, 1 As [Flag]
			, 'Transfered From: ' + IsNull([W].WarehouseCodeName,'') As [Entry_Desc]
		From 
			uvw_InventoryWarehouseTransfer_DocumentItem As [Tbd]
			Left Join uvw_Warehouse As [W]
				On [W].WarehouseID = [Tbd].WarehouseID_TransferFrom
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, [Tbd].Qty
			, 1 As [Flag]
			, 'Opening Balance' As [Entry_Desc]
		From 
			uvw_InventoryWarehouseOpening_DocumentItem As [Tbd]
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, [Tbd].Qty
			, 1 As [Flag]
			, 'Adjustment ' As [Entry_Desc]
		From 
			uvw_InventoryWarehouseAdjustment_DocumentItem As [Tbd]
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, [Tbd].Qty
			, 1 As [Flag]
			, 'Received From: ' + IsNull([S].SupplierCodeName,'') As [Entry_Desc]
		From 
			uvw_TransactionReceiveOrder_DocumentItem As [Tbd]
			Left Join uvw_Supplier As [S]
				On [S].SupplierID = [Tbd].SupplierID
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, ([Tbd].Qty * -1) As [Qty]
			, 1 As [Flag]
			, 'Delivered To: ' + IsNull([C].CustomerCodeName,'') As [Entry_Desc]
		From 
			uvw_TransactionDeliverOrder_DocumentItem As [Tbd]
			Left Join uvw_Customer As [C]
				On [C].CustomerID = [Tbd].CustomerID
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, [Tbd].Qty
			, 1 As [Flag]
			, 'Returned By: ' + IsNull([C].CustomerCodeName,'') As [Entry_Desc]
		From 
			uvw_TransactionSalesReturn_DocumentItem As [Tbd]
			Left Join uvw_Customer As [C]
				On [C].CustomerID = [Tbd].CustomerID
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, ([Tbd].Qty * -1) As [Qty]
			, 1 As [Flag]
			, 'Returned To: ' + IsNull([S].SupplierCodeName,'') As [Entry_Desc]
		From 
			uvw_TransactionPurchaseReturn_DocumentItem As [Tbd]
			Left Join uvw_Supplier As [S]
				On [S].SupplierID = [Tbd].SupplierID
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			'Snapshot' As [DocNo]
			, [Tbd].SnapshotDate As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, [Tbd].Qty
			, 2 As [Flag]
			, 'Inventory Snapshot' As [Entry_Desc]
		From 
			uvw_InventoryWarehouseSnapshot_Details As [Tbd]
		Where
			[Tbd].SnapshotDate >= @DateStart
			And [Tbd].SnapshotDate <= @DateEnd
		
		Union All
		
		Select
			'Balance Brought Forward' As [DocNo]
			, @DateStart As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, [Tbd].Qty
			, 1 As [Flag]
			, 'Balance Brought Forward ' As [Entry_Desc]
		From
			udf_InventoryWarehouse_Current_Item(@DateStart) As [Tbd]
		
		) As [Tb]
		Left Join Warehouse As [Wh]
			On [Wh].WarehouseID = [Tb].WarehouseID
	)
GO
/****** Object:  UserDefinedFunction [dbo].[udf_AccountingLedger_Amount]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[udf_AccountingLedger_Amount]
(
@DateStart As DateTime
, @DateEnd As DateTime
)
Returns Table
As
Return
	(
	Select 
		[Tb].AccountingChartOfAccountsID
		, [Tb].System_LookupID_AccountType
		, [Tb].Coa_IsDebit
		, [Tb].IsDebit
		, [Tb].AccountCodeName
		, [Tb].EntryType
		, [Tb].AccountType_Desc
		, Sum([Tb].Amount) As [Amount]
	From 
		uvw_AccountingLedger As [Tb]
	Where
		DatePosted >= @DateStart
		And DatePosted <= @DateEnd
	Group By
		[Tb].AccountingChartOfAccountsID
		, [Tb].System_LookupID_AccountType
		, [Tb].Coa_IsDebit
		, [Tb].IsDebit
		, [Tb].AccountCodeName
		, [Tb].EntryType
		, [Tb].AccountType_Desc
	)
GO
/****** Object:  UserDefinedFunction [dbo].[udf_AccountingLedger]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[udf_AccountingLedger]
(
	@DateStart As DateTime
	, @DateEnd As DateTime
)	
Returns Table
As
Return
	(
	Select [Tb].*
	From uvw_AccountingLedger As [Tb]
	Where 
		DatePosted >= @DateStart
		And DatePosted <= @DateEnd
	)
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountingLedger_UpdateCurrent_JournalVoucher]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_AccountingLedger_UpdateCurrent_JournalVoucher]
@SourceID As BigInt
As
Begin
	
	Declare @System_ModulesID As BigInt
	Set @System_ModulesID = 43
	
	Delete From AccountingLedger_Current
	Where 
		System_ModulesID = @System_ModulesID
		And SourceID = @SourceID	
		
	Declare @DateLastPostingPeriod As DateTime
	Select @DateLastPostingPeriod = Max([Tb].DatePosted)
	From 
		(
		Select
			[D].DatePosted
		From
			AccountingLedgerPostingPeriod As [Tb]
			Left Join Document As [D]
				On [D].DocumentID = [Tb].DocumentID
		) As [Tb]
	Select @DateLastPostingPeriod = IsNull(@DateLastPostingPeriod,'2000-01-01')
	
	--[-]
	
	Declare @AccountingChartOfAccountsID As BigInt
	Declare @TableName As VarChar(Max)
	Declare @FieldName_ID As VarChar(Max)
	Declare @FieldName_DocNo As VarChar(Max)
	Declare @FieldName_DatePosted As VarChar(Max)
	Declare @FieldName_ChartOfAccountsID As VarChar(Max)
	Declare @FieldName_Amount As VarChar(Max)
	Declare @FieldName_PartyID As VarChar(Max)
	
	Declare @IsDebit As Bit

	Declare @Query As NVarChar(Max)
	Declare @Query_Parameters As NVarChar(Max)
	Declare @Query_PartyID As NVarChar(Max)
	
	Create Table #Tmp 
	(
		AccountingChartOfAccountsID BigInt
		, System_ModulesID BigInt
		, TableName VarChar(100)
		, SourceID BigInt
		, DocNo VarChar(1000)
		, DatePosted DateTime
		, PartyID BigInt
		, Amount Numeric(18,2)
		, IsDebit Bit
	)
	
	--[Insert Data: From TransactionJournalVoucher]
	
	Insert Into #Tmp
		(
		AccountingChartOfAccountsID
		, System_ModulesID
		, TableName
		, SourceID
		, DocNo
		, DatePosted
		, Amount
		, IsDebit
		, PartyID
		)
	Select
		AccountingChartOfAccountsID
		, @System_ModulesID
		, 'TransactionJournalVoucher'
		, TransactionJournalVoucherID
		, DocNo
		, DateApplied
		, Debit_Amount
		, 1
		, PartyID
	From
		uvw_TransactionJournalVoucher_Details
	Where
		IsNull(Debit_Amount,0) <> 0
		And IsNull(IsPosted,0) = 1
		And IsNull(IsCancelled,0) = 0
		And DateApplied >= @DateLastPostingPeriod
		And DateApplied <= GetDate()

	Insert Into #Tmp
		(
		AccountingChartOfAccountsID
		, System_ModulesID
		, TableName
		, SourceID
		, DocNo
		, DatePosted
		, Amount
		, IsDebit
		, PartyID
		)
	Select
		AccountingChartOfAccountsID
		, @System_ModulesID
		, 'TransactionJournalVoucher'
		, TransactionJournalVoucherID
		, DocNo
		, DateApplied
		, Credit_Amount
		, 0
		, PartyID
	From
		uvw_TransactionJournalVoucher_Details
	Where
		IsNull(Credit_Amount,0) <> 0
		And IsNull(IsPosted,0) = 1
		And IsNull(IsCancelled,0) = 0
		And DateApplied >= @DateLastPostingPeriod
		And DateApplied <= GetDate()
	
	--[-]
	
	Insert Into AccountingLedger_Current
	Select 
		[Tb].* 
	From 
		#Tmp As [Tb]
		Inner Join AccountingChartOfAccounts As [Coa]
			On [Coa].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID
	Order By 
		[Tb].AccountingChartOfAccountsID
		, [Tb].DatePosted

	Drop Table #Tmp 
	
End
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountingLedger_UpdateCurrent]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_AccountingLedger_UpdateCurrent]
As
Begin
	Declare @DateLastPostingPeriod As DateTime
	Select @DateLastPostingPeriod = Max([Tb].DatePosted)
	From 
		(
		Select
			[D].DatePosted
		From
			AccountingLedgerPostingPeriod As [Tb]
			Left Join Document As [D]
				On [D].DocumentID = [Tb].DocumentID
		) As [Tb]
	Select @DateLastPostingPeriod = IsNull(@DateLastPostingPeriod,'2000-01-01')
	
	--[-]
	
	Declare @AccountingChartOfAccountsID As BigInt
	Declare @TableName As VarChar(Max)
	Declare @System_ModulesID As BigInt
	Declare @FieldName_ID As VarChar(Max)
	Declare @FieldName_DocNo As VarChar(Max)
	Declare @FieldName_DatePosted As VarChar(Max)
	Declare @FieldName_ChartOfAccountsID As VarChar(Max)
	Declare @FieldName_Amount As VarChar(Max)
	Declare @FieldName_PartyID As VarChar(Max)
	
	Declare @IsDebit As Bit

	Declare @Query As NVarChar(Max)
	Declare @Query_Parameters As NVarChar(Max)
	Declare @Query_PartyID As NVarChar(Max)
	
	Create Table #Tmp 
	(
		AccountingChartOfAccountsID BigInt
		, System_ModulesID BigInt
		, TableName VarChar(100)
		, SourceID BigInt
		, DocNo VarChar(1000)
		, DatePosted DateTime
		, PartyID BigInt
		, Amount Numeric(18,2)
		, IsDebit Bit
	)
	
	--[Insert Data: Based on AccountingLedgerMapping]
	
	Declare GLMapCur Cursor For
	Select 
		[Tb].AccountingChartOfAccountsID
		, [Tb].System_ModulesID
		, [Tb].TableName
		, [Tb].FieldName_ID
		, [Tb].FieldName_DocNo
		, [Tb].FieldName_DatePosted
		, [Tb].FieldName_Amount
		, [Tb].FieldName_PartyID
		, [Tb].IsDebit
	From 
		AccountingLedgerMapping As [Tb]
		Inner Join AccountingChartOfAccounts As [Coa]
			On [Coa].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID

	Open GLMapCur

	Fetch Next From GLMapCur 
	Into
		@AccountingChartOfAccountsID
		, @System_ModulesID
		, @TableName
		, @FieldName_ID
		, @FieldName_DocNo
		, @FieldName_DatePosted
		, @FieldName_Amount
		, @FieldName_PartyID
		, @IsDebit

	While @@Fetch_Status = 0
	Begin
		
		Set @Query_PartyID = ', Null'
		If Not IsNull(@FieldName_PartyID,'') = ''
		Begin
			Set @Query_PartyID = ', [' + @FieldName_PartyID + ']'
		End
		
		Set @Query = 
			'
			Insert Into #Tmp
				(
				AccountingChartOfAccountsID
				, System_ModulesID
				, TableName
				, SourceID
				, DocNo
				, DatePosted
				, Amount
				, IsDebit
				, PartyID
				)
			Select
				@Param_ChartOfAccountsID
				, @Param_System_ModulesID
				, @Param_TableName
				, [' + @FieldName_ID + ']
				, [' + @FieldName_DocNo + ']
				, [' + @FieldName_DatePosted + ']
				, [' + @FieldName_Amount + ']
				, @Param_IsDebit
				' + @Query_PartyID + '
			From
				[' + @TableName + ']
			Where
				IsPosted = 1
				And IsNull(IsCancelled,0) = 0
				And [' + @FieldName_DatePosted + '] >= @Param_DateLastPostingPeriod
				And [' + @FieldName_DatePosted + '] <= GetDate()
				And [' + @FieldName_Amount + '] <> 0
			'
		
		Set @Query_Parameters = 
			'
			@Param_ChartOfAccountsID BigInt
			, @Param_System_ModulesID BigInt
			, @Param_TableName VarChar(100)
			, @Param_FieldName_ID VarChar(1000)
			, @Param_FieldName_DocNo VarChar(1000)
			, @Param_FieldName_DatePosted VarChar(1000)
			, @Param_FieldName_Amount VarChar(1000)
			, @Param_IsDebit Bit
			, @Param_DateLastPostingPeriod DateTime
			'
		
		Execute sp_executesql
			@Query
			, @Query_Parameters
			, @Param_ChartOfAccountsID = @AccountingChartOfAccountsID
			, @Param_System_ModulesID = @System_ModulesID
			, @Param_TableName = @TableName
			, @Param_FieldName_ID = @FieldName_ID
			, @Param_FieldName_DocNo = @FieldName_DocNo
			, @Param_FieldName_DatePosted = @FieldName_DatePosted
			, @Param_FieldName_Amount = @FieldName_Amount
			, @Param_IsDebit = @IsDebit
			, @Param_DateLastPostingPeriod = @DateLastPostingPeriod

		Fetch Next From GLMapCur 
		Into
			@AccountingChartOfAccountsID
			, @System_ModulesID
			, @TableName
			, @FieldName_ID
			, @FieldName_DocNo
			, @FieldName_DatePosted
			, @FieldName_Amount
			, @FieldName_PartyID
			, @IsDebit
	End

	Close GLMapCur
	Deallocate GLMapCur
	
	--[Insert Data: Based on AccountingLedgerMappingChartOfAccounts]

	Declare GLCoaMapCur Cursor For
	Select 
		System_ModulesID
		, TableName
		, FieldName_ID
		, FieldName_DocNo
		, FieldName_DatePosted
		, FieldName_ChartOfAccountID
		, FieldName_Amount
		, FieldName_PartyID
		, IsDebit
	From 
		AccountingLedgerMappingChartOfAccounts

	Open GLCoaMapCur

	Fetch Next From GLCoaMapCur
	Into 
		@System_ModulesID
		, @TableName
		, @FieldName_ID
		, @FieldName_DocNo
		, @FieldName_DatePosted
		, @FieldName_ChartOfAccountsID
		, @FieldName_Amount
		, @FieldName_PartyID
		, @IsDebit

	While @@Fetch_Status = 0
	Begin
		
		Set @Query_PartyID = ', Null'
		If Not IsNull(@FieldName_PartyID,'') = ''
		Begin
			Set @Query_PartyID = ', [' + @FieldName_PartyID + ']'
		End
		
		Set @Query = 
			'
			Insert Into #Tmp
				(
					AccountingChartOfAccountsID
					, System_ModulesID
					, TableName
					, SourceID
					, DocNo
					, DatePosted
					, Amount
					, IsDebit
					, PartyID
				)
				Select 
					[' + @FieldName_ChartOfAccountsID + ']
					, @Param_System_ModulesID
					, @Param_TableName
					, [' + @FieldName_ID + ']
					, [' + @FieldName_DocNo + ']
					, [' + @FieldName_DatePosted + ']
					, [' + @FieldName_Amount + ']
					, @Param_IsDebit
					' + @Query_PartyID + '
				From
					[' + @TableName + ']
				Where
					IsPosted = 1
					And IsNull(IsCancelled,0) = 0
					And [' + @FieldName_DatePosted + '] >= @Param_DateLastPostingPeriod
					And [' + @FieldName_DatePosted + '] <= GetDate()
					And [' + @FieldName_Amount + '] <> 0
			'
		
		Set @Query_Parameters = 
				'
				@Param_System_ModulesID BigInt
				, @Param_TableName VarChar(100)
				, @Param_FieldName_ID VarChar(1000)
				, @Param_FieldName_DocNo VarChar(1000)
				, @Param_FieldName_DatePosted VarChar(1000)
				, @Param_FieldName_Amount VarChar(1000)
				, @Param_IsDebit Bit
				, @Param_DateLastPostingPeriod DateTime
				'
		
		Execute sp_executesql
				@Query
				, @Query_Parameters
				, @Param_System_ModulesID = @System_ModulesID
				, @Param_TableName = @TableName
				, @Param_FieldName_ID = @FieldName_ID
				, @Param_FieldName_DocNo = @FieldName_DocNo
				, @Param_FieldName_DatePosted = @FieldName_DatePosted
				, @Param_FieldName_Amount = @FieldName_Amount
				, @Param_IsDebit = @IsDebit
				, @Param_DateLastPostingPeriod = @DateLastPostingPeriod
		
		Fetch Next From GLCoaMapCur
		Into 
			@System_ModulesID
			, @TableName
			, @FieldName_ID
			, @FieldName_DocNo
			, @FieldName_DatePosted
			, @FieldName_ChartOfAccountsID
			, @FieldName_Amount
			, @FieldName_PartyID
			, @IsDebit
	End

	Close GLCoaMapCur
	Deallocate GLCoaMapCur
	
	--[Insert Data: From TransactionJournalVoucher]
	
	Set @System_ModulesID = 43

	Insert Into #Tmp
		(
		AccountingChartOfAccountsID
		, System_ModulesID
		, TableName
		, SourceID
		, DocNo
		, DatePosted
		, Amount
		, IsDebit
		, PartyID
		)
	Select
		AccountingChartOfAccountsID
		, @System_ModulesID
		, 'TransactionJournalVoucher'
		, TransactionJournalVoucherID
		, DocNo
		, DateApplied
		, Debit_Amount
		, 1
		, PartyID
	From
		uvw_TransactionJournalVoucher_Details
	Where
		IsNull(Debit_Amount,0) <> 0
		And IsNull(IsPosted,0) = 1
		And IsNull(IsCancelled,0) = 0
		And DateApplied >= @DateLastPostingPeriod
		And DateApplied <= GetDate()

	Insert Into #Tmp
		(
		AccountingChartOfAccountsID
		, System_ModulesID
		, TableName
		, SourceID
		, DocNo
		, DatePosted
		, Amount
		, IsDebit
		, PartyID
		)
	Select
		AccountingChartOfAccountsID
		, @System_ModulesID
		, 'TransactionJournalVoucher'
		, TransactionJournalVoucherID
		, DocNo
		, DateApplied
		, Credit_Amount
		, 0
		, PartyID
	From
		uvw_TransactionJournalVoucher_Details
	Where
		IsNull(Credit_Amount,0) <> 0
		And IsNull(IsPosted,0) = 1
		And IsNull(IsCancelled,0) = 0
		And DateApplied >= @DateLastPostingPeriod
		And DateApplied <= GetDate()

	--[-]

	Truncate Table AccountingLedger_Current

	Insert Into AccountingLedger_Current
	Select 
		[Tb].* 
	From 
		#Tmp As [Tb]
		Inner Join AccountingChartOfAccounts As [Coa]
			On [Coa].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID
	Order By 
		[Tb].AccountingChartOfAccountsID
		, [Tb].DatePosted

	Drop Table #Tmp 
	
End
GO
/****** Object:  View [dbo].[uvw_CallLog]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_CallLog]
As
	Select 
		[Tb].*
		
		, [Rp].Remarks
		, [Rp].Employee_CreatedBy
		, [Rp].Employee_UpdatedBy
		, [Rp].DateCreated
		, [Rp].DateUpdated
		
		, [D].DocNo
		, [D].Status
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
		, [D].Employee_PostedBy
		, [D].Employee_CancelledBy
		
		, [Lkp_CallTopic].[Desc] As [LookupCallTopic_Desc]
		
		, [C].CustomerCode
		, [C].CustomerName
		, [C].CustomerCodeName
		, [C].Company
		
		, [I].ItemCode
		, [I].ItemName
		, [I].ItemCodeName
		, [I].Warranty
		
	From 
		CallLog As [Tb]
		Left Join uvw_RowProperty As [Rp]
			On [Rp].RowPropertyID = [Tb].RowPropertyID
		Left Join uvw_Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Left Join LookupCallTopic As [Lkp_CallTopic]
			On [Lkp_CallTopic].LookupCallTopicID = [Tb].LookupCallTopicID
		Left Join uvw_Item As [I]
			On [I].ItemID = [Tb].ItemID
		Left Join uvw_Customer As [C]
			On [C].CustomerID = [Tb].CustomerID
GO
/****** Object:  View [dbo].[uvw_AccountingLedger_Format]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_AccountingLedger_Format]
As
	Select
		[Tb].*
		, 'Debit' As [Tb_Format]
		, [Tb].Amount As [Debit_Amount]
		, Null As [Credit_Amount]
	From
		uvw_AccountingLedger As [Tb]
	Where
		IsNull(IsDebit,0) = 1

	Union All
	
	Select
		[Tb].*
		, 'Credit' As [Tb_Format]
		, Null As [Debit_Amount]
		, [Tb].Amount As [Credit_Amount]
	From
		uvw_AccountingLedger As [Tb]
	Where
		IsNull(IsDebit,0) = 0
GO
/****** Object:  View [dbo].[uvw_AccountingChartOfAccounts_Cp]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_AccountingChartOfAccounts_Cp]
As
	Select
		[Tb].*
	From
		uvw_AccountingChartOfAccounts_Parent As [Tb]
GO
/****** Object:  View [dbo].[uvw_AccountingBudget_Period]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_AccountingBudget_Period]
As
	Select 
		[Tbd].AccountingBudget_PeriodID
		, [Tbd].Amount
		, [Tb].AccountingBudgetID
		, [Tb].System_LookupID_BudgetPeriod
		, [Tb].Name
		, [Tb].BudgetYear
		, [Tb].AccountCode
		, [Tb].AccountName
		, [Tb].AccountCodeName
		, [Tb].PartyCode
		, [Tb].PartyName
		, [Tb].PartyCodeName
		, [Tb].PartyType_Desc
		, [Tb].BudgetPeriod_Desc
		, [Tb].BudgetPeriod_OrderIndex
	From 
		AccountingBudget_Period As [Tbd]
		Right Join
			(
			Select
				[Tb].*
				, [Lookup_Bp].System_LookupID As [System_LookupID_BudgetPeriod]
				, [Lookup_Bp].[Desc] As [BudgetPeriod_Desc]
				, [Lookup_Bp].[OrderIndex] As [BudgetPeriod_OrderIndex]
			From
				uvw_AccountingBudget As [Tb]
				, udf_System_Lookup('BudgetPeriod') As [Lookup_Bp]
			) As [Tb]
			On [Tb].AccountingBudgetID = [Tbd].AccountingBudgetID
			And [Tb].System_LookupID_BudgetPeriod = [Tbd].System_LookupID_BudgetPeriod
GO
/****** Object:  View [dbo].[uvw_DocumentChartOfAccounts]    Script Date: 06/04/2012 21:16:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_DocumentChartOfAccounts]
As
	Select
		[Tb].DocumentChartOfAccountsID
		, Sum([Tb].Amount) As [Amount]
	From
		uvw_DocumentChartOfAccounts_Details As [Tb]
	Group By
		[Tb].DocumentChartOfAccountsID
GO
/****** Object:  View [dbo].[uvw_TransactionDeliverOrder_DocumentItem_Desc]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionDeliverOrder_DocumentItem_Desc]
As
	Select
		[Tb].*
		, [Sodi].Qty As [Order_Qty]
		, [Sodi].OrderBalance_Qty
		, [Sodi].Price As [So_Price]
		, [Sodi].DiscountPrice As [So_DiscountPrice]
		, IsNull([Tb].Qty,0) * IsNull([Sodi].DiscountPrice,0) As [Do_Amount]
	From
		(
		Select
			[Did].*
			, [Tb].TransactionDeliverOrderID
			, [Tb].TransactionSalesOrderID
			, [Tb].WarehouseID
			, [D].DocNo
			, [D].DateApplied
			, [D].IsPosted
			, [D].IsCancelled
			, [D].DatePosted
			, [D].DateCancelled
		From
			TransactionDeliverOrder As [Tb]
			Inner Join Document As [D]
				On [D].DocumentID = [Tb].DocumentID
			Inner Join uvw_DocumentItem_Details As [Did]
				On [Did].DocumentItemID = [Tb].DocumentItemID
		Where
			IsNull([Did].IsDeleted,0) = 0
		) As [Tb]
		Left Join uvw_TransactionSalesOrder_DocumentItem_Desc As [Sodi]
			On [Sodi].TransactionSalesOrderID = [Tb].TransactionSalesOrderID
			And [Sodi].ItemID = [Tb].ItemID
GO
/****** Object:  View [dbo].[uvw_User_Rights]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_User_Rights]
As
	Select
		[Tbd].User_RightsID
		, [Tbd].IsActive
		, [Cp_Ur].UserID
		, [Cp_Ur].RightsID
		, [Cp_Ur].RightsName
		, [Cp_Ur].RightsDesc
	From
		[User_Rights] As [Tbd]
		Right Join 
			(
			Select 
				[R].RightsID
				, [U].UserID
				, [R].[Name] As [RightsName]
				, R.[Remarks] As [RightsDesc]
			From 
				[uvw_User] As [U]
				, [uvw_Rights]  As [R]
			) As [Cp_Ur]
			On [Cp_Ur].RightsID = [Tbd].RightsID
			And [Cp_Ur].UserID = [Tbd].UserID
GO
/****** Object:  View [dbo].[uvw_TransactionSalesOrder]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesOrder]
As
	Select
		[Tb].*
		, (
		Case [Tb].IsCancelled
			When 1 Then
				'Cancelled'
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					(
					Case [Tb].IsComplete
						When 1 Then
							'Complete'
						Else
							'Posted'
					End
					)
				Else 
					'Open'
			End
			)
		End
		) As [Status]
		
	From
		(
		Select
			[Tb].*
			, (
			IsNull([Tb].SubAmount,0) 
			+ IsNull([Tb].PST_Amount,0)
			+ IsNull([Tb].GST_Amount,0)
			+ IsNull([Tb].HST_Amount,0)
			) As [Amount]
		From
			(
			Select
				[Tb].*
				, (IsNull([Tb].SubAmount,0) * (IsNull([Tb].PST_Perc,0) / 100)) As [PST_Amount]
				, (IsNull([Tb].SubAmount,0) * (IsNull([Tb].GST_Perc,0) / 100)) As [GST_Amount]
				, (IsNull([Tb].SubAmount,0) * (IsNull([Tb].HST_Perc,0) / 100)) As [HST_Amount]
			From
				(
				Select
					[Tb].*
					, (
					IsNull([Tb].Item_Amount,0) 
					+ IsNull([Tb].Freight_Amount,0) 
					+ IsNull([Tb].OtherCost_Amount,0) 
					) As [SubAmount]
				From
					(
					Select 
						[Tb].*
						
						, [Rp].Remarks
						, [Rp].Employee_CreatedBy
						, [Rp].Employee_UpdatedBy
						, [Rp].DateCreated
						, [Rp].DateUpdated
						
						, [D].DocNo
						--, [D].Status
						, [D].DateApplied
						, [D].IsPosted
						, [D].IsCancelled
						, [D].DatePosted
						, [D].DateCancelled
						, [D].Employee_PostedBy
						, [D].Employee_CancelledBy
						
						, [C].PartyID As [PartyID_Customer]
						, [C].CustomerCode
						, [C].CustomerName
						, [C].CustomerCodeName
						, [C].Company
						, [C].Address As [BillingAddress]
						, [C].IsCreditHold_Desc
						, [C].CreditCard_Complete
						, [C].CreditCard_Expiration
						
						, [Csa].Address As [ShippingAddress]
						
						, [Lkp_PriceDiscount].[Desc] As [PriceDiscount_Desc]
						, [Lkp_ClientType].[Desc] As [ClientType_Desc]
						, [Lkp_PaymentTerm].[Desc] As [PaymentTerm_Desc]
						, [Lkp_DeliveryMethod].[Desc] As [DeliveryMethod_Desc]
						, [Lkp_ShipVia].[Desc] As [ShipVia_Desc]
						, [Lkp_Currency].[Desc] As [Currency_Desc]
						, [Lkp_OrderType].[Desc] As [OrderType_Desc]
						
						, [Soc].IsComplete						
						, [Sodi_Amount].Amount As [Item_Amount]
						
					From 
						TransactionSalesOrder As [Tb]
						Left Join uvw_RowProperty As [Rp]
							On [Rp].RowPropertyID = [Tb].RowPropertyID
						Left Join uvw_Document As [D]
							On [D].DocumentID = [Tb].DocumentID
						Left Join uvw_Customer As [C]
							On [C].CustomerID = [Tb].CustomerID
						Left Join uvw_Customer_ShippingAddress As [Csa]
							On [Csa].Customer_ShippingAddressID = [Tb].Customer_ShippingAddressID
						Left Join LookupPriceDiscount As [Lkp_PriceDiscount]
							On [Lkp_PriceDiscount].LookupPriceDiscountID = [Tb].LookupPriceDiscountID
						Left Join LookupClientType As [Lkp_ClientType]
							On [Lkp_ClientType].LookupClientTypeID = [C].LookupClientTypeID
						Left Join udf_Lookup('PaymentTerm') As [Lkp_PaymentTerm]
							On [Lkp_PaymentTerm].LookupID = [Tb].LookupID_PaymentTerm
						Left Join udf_Lookup('DeliveryMethod') As [Lkp_DeliveryMethod]
							On [Lkp_DeliveryMethod].LookupID = [Tb].LookupID_DeliveryMethod
						Left Join udf_Lookup('ShipVia') As [Lkp_ShipVia]
							On [Lkp_ShipVia].LookupID = [Tb].LookupID_ShipVia
						Left Join udf_Lookup('Currency') As [Lkp_Currency]
							On [Lkp_Currency].LookupID = [Tb].LookupID_Currency
						Left Join udf_Lookup('OrderType') As [Lkp_OrderType]
							On [Lkp_OrderType].LookupID = [Tb].LookupID_OrderType
						Left Join uvw_TransactionSalesOrder_Complete As [Soc]
							On [Soc].TransactionSalesOrderID = [Tb].TransactionSalesOrderID
						Left Join
							(
							Select
								TransactionSalesOrderID
								, IsNull(Sum(PriceAmount),0) As [Amount]
							From 
								uvw_TransactionSalesOrder_DocumentItem_Desc
							Group By
								TransactionSalesOrderID
							) As [Sodi_Amount]
							On [Sodi_Amount].TransactionSalesOrderID = [Tb].TransactionSalesOrderID
					) As [Tb]
				) As [Tb]
			) As [Tb]
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_TransactionReceiveOrder_DocumentItem_Desc]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionReceiveOrder_DocumentItem_Desc]
As	
	Select
		[Tb].*
		, [Rodib].Balance_Qty
	From
		(
		Select
			[Did].DocumentItem_DetailsID
			, [Did].DocumentItemID
			, [Did].Qty
			, [Did].IsDeleted
			, [Podi].ItemID
			, [Podi].ItemCode
			, [Podi].ItemName
			, [Podi].ItemCodeName
			, [Podi].ItemType_Desc
			, [Podi].Category_Desc
			, [Podi].Brand_Desc
			, [Podi].Retailer_Desc
			
			, [Podi].Qty As [Order_Qty]
			, [Podi].OrderBalance_Qty
			, [Podi].Cost As [Po_Cost]
			, IsNull([Did].Qty,0) * IsNull([Podi].Cost,0) As [Ro_Amount]
			
			, [Tb].TransactionReceiveOrderID
			, [Tb].TransactionPurchaseOrderID
			, [Tb].WarehouseID
			, [D].DocNo
			, [D].DateApplied
			, [D].IsPosted
			, [D].IsCancelled
			, [D].DatePosted
			, [D].DateCancelled
		From
			TransactionReceiveOrder As [Tb]
			Inner Join Document As [D]
				On [D].DocumentID = [Tb].DocumentID
			Inner Join uvw_DocumentItem_Details As [Did]
				On [Did].DocumentItemID = [Tb].DocumentItemID
			Right Join uvw_TransactionPurchaseOrder_DocumentItem_Desc As [Podi]
				On [Podi].TransactionPurchaseOrderID = [Tb].TransactionPurchaseOrderID
				And [Podi].ItemID = [Did].ItemID
		Where
			IsNull([Did].IsDeleted,0) = 0
		) As [Tb]
		Left Join uvw_TransactionReceiveOrder_DocumentItem_Balance As [Rodib]
			On [Rodib].TransactionReceiveOrderID = [Tb].TransactionReceiveOrderID
			And [Rodib].ItemID = [Tb].ItemID
GO
/****** Object:  StoredProcedure [dbo].[usp_InventoryParty_Update_Current_Item]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_InventoryParty_Update_Current_Item]
@ID_ItemParty As VarChar(Max) = ''
As
Begin
	Declare @Ex_ID_ItemParty As VarChar(Max)
	Declare @cItemID As VarChar(50)
	Declare @cPartyID As VarChar(50)
	Declare @cConcessionaireID As VarChar(50)
	Declare @cWarehouseID As VarChar(50)
	
	Declare @SqlQuery As VarChar(Max)
	Declare @SqlQuery_Source As VarChar(Max)
	Declare @SqlQuery_Source_Criteria_ItemParty As VarChar(Max)
	Declare @SqlQuery_Source_Criteria_Or As VarChar(10)
	
	Select
		@SqlQuery = ''
		, @SqlQuery_Source = ''
		, @SqlQuery_Source_Criteria_ItemParty = ''
		, @SqlQuery_Source_Criteria_Or = ''
	
	Create Table #Tmp (ItemID BigInt, PartyID BigInt)
	
	If @ID_ItemParty <> ''
	Begin
	
		Set @Ex_ID_ItemParty = @ID_ItemParty
		While (Select CharIndex('</I>',@Ex_ID_ItemParty)) <> 0 
		Begin
			Select @cItemID = SubString(@Ex_ID_ItemParty,CharIndex('<I>',@Ex_ID_ItemParty) + 3,(CharIndex('</I>',@Ex_ID_ItemParty) - 4))
			Select @Ex_ID_ItemParty = SubString(@Ex_ID_ItemParty,(CharIndex('</I>',@Ex_ID_ItemParty) + 4),Len(@Ex_ID_ItemParty))

			Select @cPartyID = SubString(@Ex_ID_ItemParty,CharIndex('<PR>',@Ex_ID_ItemParty) + 4,(CharIndex('</PR>',@Ex_ID_ItemParty) - 5))
			Select @Ex_ID_ItemParty = SubString(@Ex_ID_ItemParty,(CharIndex('</PR>',@Ex_ID_ItemParty) + 5),Len(@Ex_ID_ItemParty))
			
			Insert Into #Tmp 
				(ItemID, PartyID)
			Values
				(Cast(@cItemID As BigInt), Cast(@cPartyID As BigInt))
		End
		
		--[-]
		
		Declare Cur_Wh Cursor Fast_Forward
		For
		Select
			Cast([Tb].ItemID As VarChar(50))
			, Cast([Wh].WarehouseID As VarChar(50))
		From 
			#Tmp As [Tb]
			Inner Join Warehouse As [Wh]
				On [Wh].PartyID = [Tb].PartyID
				
		Open Cur_Wh
		
		Fetch Next From Cur_Wh
		Into @cItemID, @cWarehouseID
		
		Declare @ID_ItemWarehouse As VarChar(Max)
		Set @ID_ItemWarehouse = ''
		
		While @@Fetch_Status = 0
		Begin
			Set @ID_ItemWarehouse = @ID_ItemWarehouse + '<I>' + @cItemID + '</I>' + '<WH>' + @cWarehouseID + '</WH>'
			Fetch Next From Cur_Wh
			Into @cItemID, @cWarehouseID
		End
		
		Close Cur_Wh
		Deallocate Cur_Wh
		
		If @ID_ItemWarehouse <> ''
		Begin
			Exec usp_InventoryWarehouse_Update_Current_Item @ID_ItemWarehouse
		End
		--[-]
		
		Drop Table #Tmp
	End
	Else
	Begin
		Exec usp_InventoryWarehouse_Update_Current_Item
	End
End
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseOrder]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionPurchaseOrder]
As
	Select
		[Tb].*
		, (
		Case [Tb].IsCancelled
			When 1 Then
				'Cancelled'
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					(
					Case [Tb].IsComplete
						When 1 Then
							'Complete'
						Else
							'Posted'
					End
					)
				Else 
					'Open'
			End
			)
		End
		) As [Status]
	From
		(
		Select
			[Tb].*
			, [Tb].Item_Amount As [Amount]
		From
			(
			Select 
				[Tb].*
				
				, [Rp].Remarks
				, [Rp].Employee_CreatedBy
				, [Rp].Employee_UpdatedBy
				, [Rp].DateCreated
				, [Rp].DateUpdated
				
				, [D].DocNo
				--, [D].Status
				, [D].IsPosted
				, [D].IsCancelled
				, [D].DatePosted
				, [D].DateCancelled
				, [D].Employee_PostedBy
				, [D].Employee_CancelledBy
				
				, [Su].PartyID As [PartyID_Supplier]
				, [Su].SupplierCode
				, [Su].SupplierName
				, [Su].SupplierCodeName
				, [Su].Address As [SupplierAddress]
				
				, [Wh].WarehouseCode
				, [Wh].WarehouseName
				, [Wh].WarehouseCodeName
				, [Wh].Address As [WarehouseAddress]
				
				, [Lkp_PaymentTerm].[Desc] As [PaymentTerm_Desc]
				, [Lkp_DeliveryMethod].[Desc] As [DeliveryMethod_Desc]
				
				, [Poic].IsComplete
				, [Podi_Amount].Amount As [Item_Amount]
				
			From 
				TransactionPurchaseOrder As [Tb]
				Left Join uvw_RowProperty As [Rp]
					On [Rp].RowPropertyID = [Tb].RowPropertyID
				Left Join uvw_Document As [D]
					On [D].DocumentID = [Tb].DocumentID
				Left Join uvw_Supplier As [Su]
					On [Su].SupplierID = [Tb].SupplierID
				Left Join uvw_Warehouse As [Wh]
					On [Wh].WarehouseID = [Tb].WarehouseID
				Left Join udf_Lookup('PaymentTerm') As [Lkp_PaymentTerm]
					On [Lkp_PaymentTerm].LookupID = [Tb].LookupID_PaymentTerm
				Left Join udf_Lookup('DeliveryMethod') As [Lkp_DeliveryMethod]
					On [Lkp_DeliveryMethod].LookupID = [Tb].LookupID_DeliveryMethod
				Left Join uvw_TransactionPurchaseOrder_IsComplete As [Poic]
					On [Poic].TransactionPurchaseOrderID = [Tb].TransactionPurchaseOrderID
				Left Join
					(
					Select
						TransactionPurchaseOrderID
						, IsNull(Sum(CostAmount),0) As [Amount]
					From
						uvw_TransactionPurchaseOrder_DocumentItem_Desc
					Group By
						TransactionPurchaseOrderID
					) As [Podi_Amount]
					On [Podi_Amount].TransactionPurchaseOrderID = [Tb].TransactionPurchaseOrderID
			) As [Tb]
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_TransactionReceiveOrder_Amount]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionReceiveOrder_Amount]
As
	Select
		[Tb].*
		, [Rodi].Amount
	From
		TransactionReceiveOrder As [Tb]
		Left Join
			(
			Select
				TransactionReceiveOrderID
				, IsNull(Sum(Ro_Amount),0) As [Amount]
			From 
				uvw_TransactionReceiveOrder_DocumentItem_Desc
			Group By
				TransactionReceiveOrderID
			) As [Rodi]
			On [Rodi].TransactionReceiveOrderID = [Tb].TransactionReceiveOrderID
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseReturn_DocumentItem_Desc]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionPurchaseReturn_DocumentItem_Desc]
As
	Select			
		[Did].DocumentItem_DetailsID
		, [Did].DocumentItemID
		, [Did].Qty
		, [Did].IsDeleted
		, [Rodi].ItemID
		, [Rodi].ItemCode
		, [Rodi].ItemName
		, [Rodi].ItemCodeName
		, [Rodi].ItemType_Desc
		, [Rodi].Category_Desc
		, [Rodi].Brand_Desc
		, [Rodi].Retailer_Desc
		
		, [Rodi].Qty As [Invoice_Qty]
		, [Rodi].Balance_Qty
		, [Rodi].Po_Cost
		, IsNull([Did].Qty,0) * IsNull([Rodi].Po_Cost,0) As [Pr_Amount]
		
		, [Tb].TransactionPurchaseReturnID
		, [Tb].TransactionReceiveOrderID
		, [Tb].SupplierID
		, [Tb].WarehouseID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		TransactionPurchaseReturn As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join uvw_DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
		Right Join uvw_TransactionReceiveOrder_DocumentItem_Desc As [Rodi]
			On [Rodi].TransactionReceiveOrderID = [Tb].TransactionReceiveOrderID
			And [Rodi].ItemID = [Did].ItemID
			And IsNull([Rodi].Balance_Qty,0) > 0
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_TransactionSalesInvoice_DocumentItem_Desc]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionSalesInvoice_DocumentItem_Desc]
As
	Select
		[Tb].*
		, [Sidib].Balance_Qty
	From
		(
		Select
			[Dodi].*
			, [Si].TransactionSalesInvoiceID
		From
			TransactionSalesInvoice As [Si]
			Inner Join uvw_TransactionDeliverOrder_DocumentItem_Desc As [Dodi]
				On [Dodi].TransactionDeliverOrderID = [Si].TransactionDeliverOrderID
		) As [Tb]
		Left Join uvw_TransactionSalesInvoice_DocumentItem_Balance As [Sidib]
			On [Sidib].TransactionSalesInvoiceID = [Tb].TransactionSalesInvoiceID
			And [Sidib].ItemID = [Tb].ItemID
GO
/****** Object:  View [dbo].[uvw_TransactionDeliverOrder]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionDeliverOrder]
As
	Select
		[Tb].*
		, (
		Case [Tb].IsCancelled
			When 1 Then
				'Cancelled'
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					(
					Case [Tb].IsInvoiced
						When 1 Then
							'Invoiced'
						Else
							'Posted'
					End
					)
				Else 
					'Open'
			End
			)
		End
		) As [Status]
	From
		(
		Select
			[Tb].*
			, (
			IsNull([Tb].SubAmount,0) 
			+ IsNull([Tb].PST_Amount,0)
			+ IsNull([Tb].GST_Amount,0)
			+ IsNull([Tb].HST_Amount,0)
			) As [Amount]
		From
			(
			Select
				[Tb].*
				, (IsNull([Tb].SubAmount,0) * (IsNull([Tb].PST_Perc,0) / 100)) As [PST_Amount]
				, (IsNull([Tb].SubAmount,0) * (IsNull([Tb].GST_Perc,0) / 100)) As [GST_Amount]
				, (IsNull([Tb].SubAmount,0) * (IsNull([Tb].HST_Perc,0) / 100)) As [HST_Amount]
			From
				(
				Select
					[Tb].*
					, (
					IsNull([Tb].Item_Amount,0) 
					) As [SubAmount]
				From
					(
					Select 
						[Tb].*
						
						, [Rp].Remarks
						, [Rp].Employee_CreatedBy
						, [Rp].Employee_UpdatedBy
						, [Rp].DateCreated
						, [Rp].DateUpdated
						
						, [D].DocNo
						--, [D].Status
						, [D].DateApplied
						, [D].IsPosted
						, [D].IsCancelled
						, [D].DatePosted
						, [D].DateCancelled
						, [D].Employee_PostedBy
						, [D].Employee_CancelledBy
						
						, [Wh].WarehouseCode
						, [Wh].WarehouseName
						, [Wh].WarehouseCodeName
						, [Wh].Address As [WarehouseAddress]
						
						, [So].DocNo As [So_DocNo]
						, [So].DatePosted As [So_DatePosted]
						, [So].CustomerID
						, [So].PartyID_Customer
						, [So].CustomerCodeName
						, [So].Company
						, [So].ShippingAddress
						, [So].BillingAddress
						, [So].LookupID_ShipVia
						, [So].LookupID_PaymentTerm
						, [So].ShipVia_Desc
						, [So].PaymentTerm_Desc
						
						, [So].Freight_Amount
						, [So].OtherCost_Amount		
						, [So].PST_Perc
						, [So].GST_Perc
						, [So].HST_Perc
						
						, [Dodi_Amount].Amount As [Item_Amount]
						, [Doii].IsInvoiced
						
					From 
						TransactionDeliverOrder As [Tb]
						Left Join uvw_RowProperty As [Rp]
							On [Rp].RowPropertyID = [Tb].RowPropertyID
						Left Join uvw_Document As [D]
							On [D].DocumentID = [Tb].DocumentID
						Left Join uvw_TransactionSalesOrder As [So]
							On [So].TransactionSalesOrderID = [Tb].TransactionSalesOrderID
						Left Join uvw_Warehouse As [Wh]
							On [Wh].WarehouseID = [Tb].WarehouseID
						Left Join
							(
							Select
								TransactionDeliverOrderID
								, IsNull(Sum(Do_Amount),0) As [Amount]
							From
								uvw_TransactionDeliverOrder_DocumentItem_Desc
							Group By
								TransactionDeliverOrderID
							) As [Dodi_Amount]
							On [Dodi_Amount].TransactionDeliverOrderID = [Tb].TransactionDeliverOrderID
						Left Join uvw_TransactionDeliverOrder_IsInvoiced As [Doii]
							On [Doii].TransactionDeliverOrderID = [Tb].TransactionDeliverOrderID
					) As [Tb]
				) As [Tb]
			) As [Tb]
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_TransactionEmployeeExpense_Amount]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionEmployeeExpense_Amount]
As
	Select
		[Tb].*
			, (
			IsNull([Tb].Dcoa_Amount,0) 
			) As [Amount]
	From
		(
		Select
			[Tb].TransactionEmployeeExpenseID
			, [Dcoa].Amount As [Dcoa_Amount]
		From
			TransactionEmployeeExpense As [Tb]
			Left Join uvw_DocumentChartOfAccounts As [Dcoa]
				On [Dcoa].DocumentChartOfAccountsID = [Tb].DocumentChartOfAccountsID
		) As [Tb]
GO
/****** Object:  StoredProcedure [dbo].[usp_System_Modules_Load]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[usp_System_Modules_Load]
@UserID As BigInt
As
Begin
	Select Distinct
		[Sm].*
		, [Psm].OrderIndex As [Psm_OrderIndex]
		, [Sm].OrderIndex As [Sm_OrderIndex]
	From 
		System_Modules As [Sm]
		Inner Join uvw_Rights_Details As [Rd]
			On [Rd].System_ModulesID = [Sm].System_ModulesID
			And [Rd].System_Modules_Access_Desc = 'Access'
			And [Rd].IsAllowed = 1
			And IsNull([Sm].IsHidden,0) = 0
		Inner Join uvw_User_Rights As [Ur]
			On [Ur].RightsID = [Rd].RightsID
			And [Ur].IsActive = 1
			And [Ur].UserID = @UserID
		Left Join System_Modules As [Psm]
			On [Psm].System_ModulesID = [Sm].Parent_System_ModulesID
	Order By
		[Psm].OrderIndex
		, [Sm].OrderIndex
End
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Accounting_GeneralLedger]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[udf_Accounting_GeneralLedger]
(
	@DateStart As DateTime
	, @DateEnd As DateTime
)
Returns Table
As
Return
	(
	Select
		[Tb].AccountingChartOfAccountsID
		, [Tb].AccountCode
		, [Tb].AccountName
		, [Tb].AccountCodeName
		, [Tb].AccountType_Desc
		, IsNull([Tb_Debit].Amount,0) As [Debit_Amount]
		, IsNull([Tb_Credit].Amount,0) As [Credit_Amount]
	From
		(
		Select Distinct
			AccountingChartOfAccountsID
			, AccountCode
			, AccountName
			, AccountCodeName
			, AccountType_Desc
		From
			udf_AccountingLedger(@DateStart,@DateEnd)
		) As [Tb]
		Left Join 
			(
			Select 
				AccountingChartOfAccountsID
				, Sum(Amount) As [Amount]
			From 
				udf_AccountingLedger(@DateStart,@DateEnd)
			Where
				IsDebit = 1
			Group By
				AccountingChartOfAccountsID
			) As [Tb_Debit]
			On [Tb_Debit].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID
		Left Join	
			(
			Select 
				AccountingChartOfAccountsID
				, Sum(Amount) As [Amount]
			From 
				udf_AccountingLedger(@DateStart,@DateEnd)
			Where
				IsDebit = 0
			Group By
				AccountingChartOfAccountsID
			) As [Tb_Credit]
			On [Tb_Credit].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID
	)
GO
/****** Object:  StoredProcedure [dbo].[usp_InventoryWarehouse_History_Item]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_InventoryWarehouse_History_Item]
	@DateStart As DateTime
	, @DateEnd As DateTime
	, @ItemID As BigInt
	, @WarehouseID As BigInt
As
Begin
	Create Table #Tmp
		(
		[Ct] BigInt
		, [DocNo] VarChar(1000)
		, [DatePosted] DateTime
		, [ItemID] BigInt
		, [WarehouseID] BigInt
		, [Qty] BigInt
		, [Flag] Int
		, [Entry_Desc] VarChar(8000)
		)

	Insert Into #Tmp
	Select
		Row_Number() Over (Partition By WarehouseID, ItemID Order By [Tb].DatePosted) As [Ct]
		, [Tb].DocNo
		, [Tb].DatePosted
		, [Tb].ItemID
		, [Tb].WarehouseID
		, IsNull([Tb].Qty,0) As [Qty]
		, [Tb].Flag
		, [Tb].Entry_Desc
	From
		udf_InventoryWarehouse_History_Item_Union(@DateStart, @DateEnd) As [Tb]
	Where
		ItemID = @ItemID
		And WarehouseID = @WarehouseID
	Order By
		[Tb].DatePosted
	
	Select
		[Tb].Ct
		, [Tb].DocNo
		, [Tb].DatePosted
		, [Tb].ItemID
		, [Tb].WarehouseID
		, [Tb].Qty
		, [Tb].Running_Qty
		, [Tb].Flag
		, [Tb].Entry_Desc
	From
		(
		Select
			[Tb].*
			, IsNull(
				(
				Select
					Sum([InnerTb].Qty) As [Qty]
				From #Tmp As [InnerTb]
				Where
					[InnerTb].ItemID = [Tb].ItemID
					And [InnerTb].WarehouseID = [Tb].WarehouseID
					And [InnerTb].Ct <= [Tb].Ct
					And [InnerTb].Ct >=
						IsNull(
							(
							Select Max([InnerTb].Ct)
							From #Tmp As [InnerTb]
							Where
								[InnerTb].Flag = 2
								And [InnerTb].ItemID = [Tb].ItemID
								And [InnerTb].WarehouseID = [Tb].WarehouseID
								And [InnerTb].Ct <= [Tb].Ct
							)
							,0)
				),0) As [Running_Qty]
		From
			#Tmp As [Tb]
		) As [Tb]
			
	Order By
		WarehouseID
		, ItemID
		, Ct

	Drop Table #Tmp	
End
GO
/****** Object:  UserDefinedFunction [dbo].[udf_TransactionSalesOrder_StockStatus]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[udf_TransactionSalesOrder_StockStatus]
(
	@WarehouseID As BigInt
)
Returns Table
As
Return
	(
	Select Top (100) Percent
		[Tb].*
		, [Sodi].StatusID
		, (
				Case IsNull([Sodi].StatusID,0)
					When 1 Then 'Full'
					When 2 Then 'Partial'
					When 3 Then 'None'
				End
		) As [StockStatus]
	From
		uvw_TransactionSalesOrder As [Tb]
		Left Join
			(
			Select
				[Tb].TransactionSalesOrderID
				, (
				Case
					When [Sodi] = [Inv] Then 1
					When [Inv] > 0 Then 2
					When [Inv] = 0 Then 3
				End
				) As [StatusID]
			From
				(
				Select
					[Sodi].TransactionSalesOrderID
					, IsNull([Sodi].Ct,0) As [Sodi]
					, IsNull([Inv].Ct,0) As [Inv]
				From
					(
					Select
						[Sodiob].TransactionSalesOrderID
						, Count(1) As [Ct]
					From
						uvw_TransactionSalesOrder_DocumentItem_OrderBalance As [Sodiob]
						Left Join Materialized_InventoryWarehouse_Current_Item As [Inv]
							On [Inv].ItemID = [Sodiob].ItemID
							And [Inv].WarehouseID = @WarehouseID
					Where
						IsNull([Inv].Qty,0) >= IsNull([Sodiob].Qty,0)
						And IsNull([Sodiob].Qty,0) > 0
					Group By
						[Sodiob].TransactionSalesOrderID
					) As [Inv]
					Right Join
						(
						Select
							[Sodiob].TransactionSalesOrderID
							, Count(1) As [Ct]
						From
							uvw_TransactionSalesOrder_DocumentItem_OrderBalance As [Sodiob]
						Where
							IsNull([Sodiob].Qty,0) > 0
						Group By
							[Sodiob].TransactionSalesOrderID
						) As [Sodi]
						On [Sodi].TransactionSalesOrderID = [Inv].TransactionSalesOrderID
				) As [Tb]
			) As [Sodi]
			On [Sodi].TransactionSalesOrderID = [Tb].TransactionSalesOrderID
	Where
		IsNull([Tb].IsPosted,0) = 1
		And IsNull([Tb].IsComplete,0) = 0
		And IsNull([Tb].IsCancelled,0) = 0
	Order By
		StatusID
		, DocNo	
	)
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountingLedger_PostCurrent]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[usp_AccountingLedger_PostCurrent]
@EmployeeID As BigInt
As
Begin
	Begin Transaction TrnLevel_0
	Begin Try
		Exec usp_AccountingLedger_UpdateCurrent
		
		Declare @DateLastPostingPeriod As DateTime
		Select @DateLastPostingPeriod = Max([Tb].DatePosted)
		From 
			(
			Select 
				[D].DatePosted
			From 
				AccountingLedgerPostingPeriod As [Tb]
				Left Join Document As [D]
					On [D].DocumentID = [Tb].DocumentID
			) As [Tb]
		Select @DateLastPostingPeriod = IsNull(@DateLastPostingPeriod,'2000-01-01')
	
		--[-]
		
		Declare @DocumentSeries_Table VarChar(1000)
		Declare @DocumentSeries_Field VarChar(1000)
		Declare @DocumentSeries_Prefix VarChar(1000)
		Declare @DocumentSeries_Digits Int
		
		Select
			@DocumentSeries_Table = [TableName]
			, @DocumentSeries_Field = [FieldName]
			, @DocumentSeries_Prefix = [Prefix]
			, @DocumentSeries_Digits = [Digits]
		From
			System_DocumentSeries
		Where
			ModuleName = 'LedgerPostingPeriod'
		
		Declare @Table_DocNo Table (DocNo VarChar(1000))
		Insert @Table_DocNo (DocNo)
		Exec usp_GetSeriesNo 
			@DocumentSeries_Table
			, @DocumentSeries_Field
			, @DocumentSeries_Prefix
			, @DocumentSeries_Digits
		
		Declare @DocNo As VarChar(1000)
		Select Top 1 @DocNo = DocNo
		From @Table_DocNo
		
		Declare @DatePosted As DateTime
		Set @DatePosted = GetDate()
		
		Declare @Table_Document Table (DocumentID BigInt)	
		
		Insert Into Document 
			(DocNo, DateApplied, DatePosted, EmployeeID_PostedBy)
		Output
			Inserted.DocumentID
		Into
			@Table_Document
		Values
			(@DocNo, @DatePosted, @DatePosted, @EmployeeID)
		
		Declare @DocumentID As BigInt
		Select @DocumentID = DocumentID
		From @Table_Document
		
		Declare @Table_Alpp Table (AccountingLedgerPostingPeriodID BigInt)
		
		Insert Into AccountingLedgerPostingPeriod
			(DocumentID)
		Output
			Inserted.AccountingLedgerPostingPeriodID
		Into
			@Table_Alpp
		Values
			(@DocumentID)
		
		Declare @AccountingLedgerPostingPeriodID As BigInt
		Select @AccountingLedgerPostingPeriodID = AccountingLedgerPostingPeriodID
		From @Table_Alpp
		
		--[-]
		
		Insert Into AccountingLedger_Posted
			(
				AccountingLedgerPostingPeriodID
				, AccountingChartOfAccountsID
				, System_ModulesID
				, TableName
				, SourceID
				, DocNo
				, DatePosted
				, PartyID
				, Amount
				, IsDebit
			)
		Select
			@AccountingLedgerPostingPeriodID
			, AccountingChartOfAccountsID
			, System_ModulesID
			, TableName
			, SourceID
			, DocNo
			, DatePosted
			, PartyID
			, Amount
			, IsDebit
		From
			AccountingLedger_Current
		Where
			DatePosted >= @DateLastPostingPeriod
		
		Commit Transaction TrnLevel_0
		
	End Try
	Begin Catch
		Rollback Transaction TrnLevel_0
		Print Error_Message()
	End Catch
End
GO
/****** Object:  UserDefinedFunction [dbo].[udf_AccountingLedger_Format]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[udf_AccountingLedger_Format]
(
	@DateStart As DateTime
	, @DateEnd As DateTime
)	
Returns Table
As
Return
	(
	Select 
		[Tb].*
		, 'Debit' As [UnionTb]
		, Amount As [Debit_Amount]
		, Null As [Credit_Amount]
	From 
		udf_AccountingLedger(@DateStart,@DateEnd) As[Tb]
	Where
		IsNull(IsDebit,0) = 1

	Union

	Select 
		[Tb].*
		, 'Credit' As [UnionTb]
		, Null As [Debit_Amount]
		, Amount As [Credit_Amount]
	From 
		udf_AccountingLedger(@DateStart,@DateEnd) As[Tb]
	Where
		IsNull(IsDebit,0) = 0
	)
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Accounting_TrialBalance]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[udf_Accounting_TrialBalance]
(
	@DateStart As DateTime
	, @DateEnd As DateTime
)	
Returns Table
As
Return
	(
	Select
		[Tb].*
	From
		(
		Select 
			[Coa].AccountingChartOfAccountsID
			, [Coa].System_LookupID_AccountType
			, [Coa].AccountCodeName
			, [Coa].AccountType_Desc
			, (
			Case
				When IsNull([Tb_Debit].Amount,0) = 0 Then
					Null
				Else
					IsNull([Tb_Debit].Amount,0)
			End
			) As [Debit_Amount]
			, (
			Case
				When IsNull([Tb_Credit].Amount,0) = 0 Then
					Null
				Else
					IsNull([Tb_Credit].Amount,0)
			End
			) As [Credit_Amount]
		From 
			uvw_AccountingChartOfAccounts As [Coa]
			Left Join
				(
				Select
					[Tb].AccountingChartOfAccountsID
					, [Tb].System_LookupID_AccountType
					, [Tb].Coa_IsDebit
					, Sum([Tb].Amount) As [Amount]
				From
					(
					Select 
						[Tb].AccountingChartOfAccountsID
						, [Tb].System_LookupID_AccountType
						, [Tb].Coa_IsDebit
						, [Tb].Amount
					From 
						udf_AccountingLedger_Amount(@DateStart,@DateEnd) As [Tb]
					Where
						IsNull([Tb].Coa_IsDebit,0) = 1
						And IsNull([Tb].IsDebit,0) = 1

					Union All
					
					Select 
						[Tb].AccountingChartOfAccountsID
						, [Tb].System_LookupID_AccountType
						, [Tb].Coa_IsDebit
						, ([Tb].Amount * -1) As [Amount]
					From 
						udf_AccountingLedger_Amount(@DateStart,@DateEnd) As [Tb]
					Where
						IsNull([Tb].Coa_IsDebit,0) = 1
						And IsNull([Tb].IsDebit,0) = 0
					) As [Tb]
				Group By
					[Tb].AccountingChartOfAccountsID
					, [Tb].System_LookupID_AccountType
					, [Tb].Coa_IsDebit
				) As [Tb_Debit]
				On [Tb_Debit].AccountingChartOfAccountsID = [Coa].AccountingChartOfAccountsID
				And [Tb_Debit].System_LookupID_AccountType = [Coa].System_LookupID_AccountType
			Left Join
				(
				Select
					[Tb].AccountingChartOfAccountsID
					, [Tb].System_LookupID_AccountType
					, [Tb].Coa_IsDebit
					, Sum([Tb].Amount) As [Amount]
				From
					(
					Select 
						[Tb].AccountingChartOfAccountsID
						, [Tb].System_LookupID_AccountType
						, [Tb].Coa_IsDebit
						, [Tb].Amount
					From 
						udf_AccountingLedger_Amount(@DateStart,@DateEnd) As [Tb]
					Where
						IsNull([Tb].Coa_IsDebit,0) = 0
						And IsNull([Tb].IsDebit,0) = 0

					Union
					
					Select 
						[Tb].AccountingChartOfAccountsID
						, [Tb].System_LookupID_AccountType
						, [Tb].Coa_IsDebit
						, ([Tb].Amount * -1) As [Amount]
					From 
						udf_AccountingLedger_Amount(@DateStart,@DateEnd) As [Tb]
					Where
						IsNull([Tb].Coa_IsDebit,0) = 0
						And IsNull([Tb].IsDebit,0) = 1
					) As [Tb]
				Group By
					[Tb].AccountingChartOfAccountsID
					, [Tb].System_LookupID_AccountType
					, [Tb].Coa_IsDebit
				) As [Tb_Credit]
				On [Tb_Credit].AccountingChartOfAccountsID = [Coa].AccountingChartOfAccountsID
				And [Tb_Credit].System_LookupID_AccountType = [Coa].System_LookupID_AccountType
		) As [Tb]
	Where
		IsNull([Tb].Debit_Amount ,0) <> 0
		Or IsNull([Tb].Credit_Amount ,0) <> 0
	)
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Accounting_IncomeStatement]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[udf_Accounting_IncomeStatement]
(
	@DateStart As DateTime
	, @DateEnd As DateTime
)	
Returns Table
As
Return	
	(
	Select 
		1 As [Type]
		, 'Income' As [TypeDesc]
		, [Tb].AccountCodeName
		, IsNull([Tb].Debit_Amount,0) + IsNull([Tb].Credit_Amount,0) As [Amount]
	From 
		udf_Accounting_TrialBalance(@DateStart,@DateEnd) As [Tb]
	Where
		[Tb].System_LookupID_AccountType = 3 --7
		Or [Tb].System_LookupID_AccountType = 8 --14
	
	Union All
	
	Select 
		2 As [Type]
		, 'Expense' As [TypeDesc]
		, [Tb].AccountCodeName
		, IsNull([Tb].Debit_Amount,0) + IsNull([Tb].Credit_Amount,0) As [Amount]
	From 
		udf_Accounting_TrialBalance(@DateStart,@DateEnd) As [Tb]
	Where
		[Tb].System_LookupID_AccountType = 4
		Or [Tb].System_LookupID_AccountType = 7
	)
GO
/****** Object:  StoredProcedure [dbo].[usp_Accounting_Report_TrialBalance]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_Accounting_Report_TrialBalance]
@DateStart As DateTime
, @DateEnd As DateTime
As
Begin
	Select *
	Into #Tmp
	From udf_Accounting_TrialBalance(@DateStart,@DateEnd)
	
	Select *
	From #Tmp
	
	Select 
		Sum(Debit_Amount) As [Debit_Amount]
		, Sum(Credit_Amount) As [Credit_Amount]
	From 
		#Tmp
		
	Drop Table #Tmp
	
End
GO
/****** Object:  View [dbo].[uvw_TransactionSalesReturn_DocumentItem_Desc]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesReturn_DocumentItem_Desc]
As
	Select			
		/*
		, [Did].ItemID
		, [Did].ItemCode
		, [Did].ItemName
		, [Did].ItemCodeName
		, [Did].ItemType_Desc
		, [Did].Category_Desc
		, [Did].Brand_Desc
		, [Did].Retailer_Desc
		, [Did].Cost
		, [Did].Price
		, [Did].DiscountPrice_Ex
		, [Did].DiscountPrice
		, [Did].PriceAmount
		, [Did].CostAmount
		, [Did].PriceDiscount_Value
		, [Did].PriceDiscount_IsPerc
		*/
	
		[Did].DocumentItem_DetailsID
		, [Did].DocumentItemID
		, [Did].Qty
		, [Did].IsDeleted
		, [Sidi].ItemID
		, [Sidi].ItemCode
		, [Sidi].ItemName
		, [Sidi].ItemCodeName
		, [Sidi].ItemType_Desc
		, [Sidi].Category_Desc
		, [Sidi].Brand_Desc
		, [Sidi].Retailer_Desc
		
		, [Sidi].Qty As [Invoice_Qty]
		, [Sidi].Balance_Qty
		, [Sidi].So_Price
		, [Sidi].So_DiscountPrice
		, IsNull([Did].Qty,0) * IsNull([Sidi].So_DiscountPrice,0) As [Sr_Amount]
		
		, [Tb].TransactionSalesReturnID
		, [Tb].TransactionSalesInvoiceID
		, [Tb].CustomerID
		, [Tb].WarehouseID
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
	From
		TransactionSalesReturn As [Tb]
		Inner Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Inner Join uvw_DocumentItem_Details As [Did]
			On [Did].DocumentItemID = [Tb].DocumentItemID
		Right Join uvw_TransactionSalesInvoice_DocumentItem_Desc As [Sidi]
			On [Sidi].TransactionSalesInvoiceID = [Tb].TransactionSalesInvoiceID
			And [Sidi].ItemID = [Did].ItemID
			And IsNull([Sidi].Balance_Qty,0) > 0
	Where
		IsNull([Did].IsDeleted,0) = 0
GO
/****** Object:  View [dbo].[uvw_TransactionSalesInvoice_Amount]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionSalesInvoice_Amount]
As	
	Select
		[Tb].*
		, (
		IsNull([Tb].SubAmount,0) 
		+ IsNull([Tb].PST_Amount,0)
		+ IsNull([Tb].GST_Amount,0)
		+ IsNull([Tb].HST_Amount,0)
		) As [Amount]
		, (
		IsNull([Tb].PST_Amount,0)
		+ IsNull([Tb].GST_Amount,0)
		+ IsNull([Tb].HST_Amount,0)
		) As [TaxTotal]
	From
		(
		Select
			[Tb].*
			, (IsNull([Tb].SubAmount,0) * (IsNull([Tb].PST_Perc,0) / 100)) As [PST_Amount]
			, (IsNull([Tb].SubAmount,0) * (IsNull([Tb].GST_Perc,0) / 100)) As [GST_Amount]
			, (IsNull([Tb].SubAmount,0) * (IsNull([Tb].HST_Perc,0) / 100)) As [HST_Amount]
		From
			(
			Select
				[Tb].*
				, (
				IsNull([Tb].Do_SubAmount,0) 
				+ IsNull([Tb].Freight_Amount,0) 
				+ IsNull([Tb].OtherCost_Amount,0) 
				) As [SubAmount]
			From
				(
				Select 
					[Tb].*
					
					, [Do].PST_Perc
					, [Do].GST_Perc
					, [Do].HST_Perc
					, [Do].SubAmount As [Do_SubAmount]
					, [Do].Amount As [Do_Amount]
					
					, (
					+ IsNull([Tb].Freight_Amount,0) 
					+ IsNull([Tb].OtherCost_Amount,0) 
					) As [Freight_OtherCost_Amount]
					
				From 
					TransactionSalesInvoice As [Tb]
					Left Join uvw_TransactionDeliverOrder As [Do]
						On [Do].TransactionDeliverOrderID = [Tb].TransactionDeliverOrderID
				) As [Tb]
			) As [Tb]
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseInvoice_ReceiveOrder]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionPurchaseInvoice_ReceiveOrder]
As
	Select
		[Tbd].*
		
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
		
		, [Ro].DocNo As [Ro_DocNo]
		, [Ro].IsPosted As [Ro_IsPosted]
		, [Ro].IsCancelled As [Ro_IsCancelled]
		, [Ro].DatePosted As [Ro_DatePosted]
		, [Ro].DateCancelled As [Ro_DateCancelled]
		, [Ro].Amount As [Ro_Amount]
		
	From
		TransactionPurchaseInvoice_ReceiveOrder As [Tbd]
		Left Join TransactionPurchaseInvoice As [Tb]
			On [Tb].TransactionPurchaseInvoiceID = [Tbd].TransactionPurchaseInvoiceID
		Left Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Left Join 
			(
			Select
				[Tb].*
				, [D].DocNo
				, [D].DateApplied
				, [D].IsPosted
				, [D].IsCancelled
				, [D].DatePosted
				, [D].DateCancelled
			From
				uvw_TransactionReceiveOrder_Amount As [Tb]
				Left Join Document As [D]
					On [D].DocumentID = [Tb].DocumentID
			) As [Ro]
			On [Ro].TransactionReceiveOrderID = [Tbd].TransactionReceiveOrderID
GO
/****** Object:  View [dbo].[uvw_TransactionEmployeeExpense_Balance]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionEmployeeExpense_Balance]
As
	Select
		[Tb].TransactionEmployeeExpenseID
		, IsNull([Eep].Amount,0) As [Paid_Amount]
		, IsNull([Tb].Amount,0) As [Due_Amount]
		, (IsNull([Tb].Amount,0) - IsNull([Eep].Amount,0)) As [Balance_Amount]
	From
		uvw_TransactionEmployeeExpense_Amount As [Tb]
		Left Join uvw_TransactionEmployeeExpense_Paid As [Eep]
			On [Eep].TransactionEmployeeExpenseID = [Tb].TransactionEmployeeExpenseID
GO
/****** Object:  View [dbo].[uvw_TransactionEmployeeExpense_IsPaid]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionEmployeeExpense_IsPaid]
As
	Select
		[Tb].TransactionEmployeeExpenseID
		, [Tb].Paid_Amount
		, [Tb].Due_Amount
		, [Tb].Balance_Amount
		, Cast(
		(
		Case 
			When [Tb].Balance_Amount <= 0 Then 1
			Else 0
		End
		) As Bit)As [IsPaid]
	From
		uvw_TransactionEmployeeExpense_Balance As [Tb]
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseInvoice_Amount]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionPurchaseInvoice_Amount]
As
	Select
		[Tb].*
			, (
			IsNull([Tb].Dcoa_Amount,0) 
			+ IsNull([Tb].Piro_Amount,0) 
			) As [Amount]
	From
		(
		Select
			[Tb].TransactionPurchaseInvoiceID
			, [Dcoa].Amount As [Dcoa_Amount]
			, [Piro].Amount As [Piro_Amount]
		From
			TransactionPurchaseInvoice As [Tb]
			Left Join uvw_DocumentChartOfAccounts As [Dcoa]
				On [Dcoa].DocumentChartOfAccountsID = [Tb].DocumentChartOfAccountsID
			Left Join
				(
				Select
					TransactionPurchaseInvoiceID
					, Sum(Ro_Amount) As [Amount]
				From 
					uvw_TransactionPurchaseInvoice_ReceiveOrder
				Group By
					TransactionPurchaseInvoiceID
				) As [Piro]
				On [Piro].TransactionPurchaseInvoiceID = [Tb].TransactionPurchaseInvoiceID
			
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_TransactionSalesInvoice_Balance]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesInvoice_Balance]
As
	Select
		[Tb].TransactionSalesInvoiceID
		, IsNull([Sip].Amount,0) As [Paid_Amount]
		, IsNull([Tb].Amount,0) As [Due_Amount]
		, (IsNull([Tb].Amount,0) - IsNull([Sip].Amount,0)) As [Balance_Amount]
	From
		uvw_TransactionSalesInvoice_Amount As [Tb]
		Left Join uvw_TransactionSalesInvoice_Paid As [Sip]
			On [Sip].TransactionSalesInvoiceID = [Tb].TransactionSalesInvoiceID
GO
/****** Object:  StoredProcedure [dbo].[usp_Accounting_Report_IncomeStatement]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[usp_Accounting_Report_IncomeStatement]
@DateStart As DateTime
, @DateEnd As DateTime
As
Begin
	
	Select * 
	Into #Tmp
	From udf_Accounting_IncomeStatement(@DateStart,@DateEnd)
		
	Declare @Income_Amount As Numeric(18,2)
	Declare @Expense_Amount As Numeric(18,2)
	Declare @Net_Amount As Numeric(18,2)
	
	Select @Income_Amount = Sum(Amount)
	From #Tmp
	Where [Type] = 1

	Select @Expense_Amount = Sum(Amount)
	From #Tmp
	Where [Type] = 2
	
	Set @Net_Amount = IsNull(@Income_Amount,0) - IsNull(@Expense_Amount,0)
	
	Select *
	From #Tmp
	Where [Type] = 1
	
	Select *
	From #Tmp
	Where [Type] = 2
	
	Select 
		IsNull(@Income_Amount,0) As [Income_Amount]
		, IsNull(@Expense_Amount,0) As [Expense_Amount]
		, IsNull(@Net_Amount,0) As [Net_Amount]

	Drop Table #Tmp
	
End
GO
/****** Object:  StoredProcedure [dbo].[usp_Accounting_Report_BalanceSheet]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[usp_Accounting_Report_BalanceSheet]
@DateStart As DateTime
, @DateEnd As DateTime
As
Begin

	Select 
		AccountingChartOfAccountsID
		, System_LookupID_AccountType
		, AccountCodeName
		, IsNull(Debit_Amount,0) + IsNull(Credit_Amount,0) As [Amount]
	Into 
		#Tmp_TrialBalance
	From 
		udf_Accounting_TrialBalance(@DateStart,@DateEnd)

	Select * 
	Into #Tmp_IncomeStatement
	From udf_Accounting_IncomeStatement(@DateStart,@DateEnd)

	Declare @Asset_Amount As Numeric(18,2)
	Select 
		@Asset_Amount = Sum(Amount) 
	From 
		#Tmp_TrialBalance
	Where
		System_LookupID_AccountType = 1

	Declare @Liability_Amount As Numeric(18,2)
	Select 
		@Liability_Amount = Sum(Amount) 
	From 
		#Tmp_TrialBalance
	Where
		System_LookupID_AccountType = 2

	Declare @Equity_Amount As Numeric(18,2)
	Select 
		@Equity_Amount = Sum(Amount) 
	From 
		#Tmp_TrialBalance
	Where
		System_LookupID_AccountType = 5

	Declare @Income_Amount As Numeric(18,2)
	Select
		@Income_Amount = IsNull(Sum(Amount),0)
	From
		(
		Select Sum(Amount) As [Amount]
		From #Tmp_IncomeStatement
		Where [Type] = 1
		
		Union
		
		Select (Sum(Amount) * -1) As [Amount]
		From #Tmp_IncomeStatement
		Where [Type] = 2
		) As [Tb]
		
	Set @Equity_Amount = IsNull(@Equity_Amount,0) + @Income_Amount

	Select *
	From #Tmp_TrialBalance
	Where System_LookupID_AccountType = 1

	Select *
	From #Tmp_TrialBalance
	Where System_LookupID_AccountType = 2

	Select 
		1 As [Ct]
		, 'TrialBalance' As [Table]
		, AccountingChartOfAccountsID
		, System_LookupID_AccountType
		, AccountCodeName
		, Amount
	From 
		#Tmp_TrialBalance
	Where 
		System_LookupID_AccountType = 5

	Union All

	Select
		2 As [Ct]
		, 'IncomeStatemet' As [Table]
		, Null
		, Null
		, 'Net Income'
		, @Income_Amount As [Amount]

	Order By
		Ct

	Select
		IsNull(@Asset_Amount,0) As [Asset_Amount]
		, IsNull(@Liability_Amount,0) As [Liability_Amount]
		, IsNull(@Equity_Amount,0) As [Equity_Amount]
		, IsNull(@Liability_Amount,0) + IsNull(@Equity_Amount,0) As [LiabilityEquity_Amount]

	Drop Table #Tmp_TrialBalance
	Drop Table #Tmp_IncomeStatement
	
End
GO
/****** Object:  View [dbo].[uvw_TransactionEmployeeExpense]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionEmployeeExpense]
As
	Select
		[Tb].*
		, (
		Case [Tb].IsCancelled
			When 1 Then
				'Cancelled'
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					(
					Case [Tb].IsPaid
						When 1 Then
							'Paid'
						Else
							'Posted'
					End
					)
				Else 
					'Open'
			End
			)
		End
		) As [Status]
	From
		(
		Select 
			[Tb].*
			
			, [Rp].Remarks
			, [Rp].Employee_CreatedBy
			, [Rp].Employee_UpdatedBy
			, [Rp].DateCreated
			, [Rp].DateUpdated
			
			, [D].DocNo
			--, [D].Status
			, [D].DateApplied
			, [D].IsPosted
			, [D].IsCancelled
			, [D].DatePosted
			, [D].DateCancelled
			, [D].Employee_PostedBy
			, [D].Employee_CancelledBy
			
			, [E].EmployeeCode
			, [E].EmployeeName
			, [E].EmployeeCodeName
			
			, [Eea].Dcoa_Amount
			, [Eea].Amount
			
			, [Eeid].Paid_Amount
			, [Eeid].Balance_Amount
			, [Eeid].IsPaid
			
		From 
			TransactionEmployeeExpense As [Tb]
			Left Join uvw_RowProperty As [Rp]
				On [Rp].RowPropertyID = [Tb].RowPropertyID
			Left Join uvw_Document As [D]
				On [D].DocumentID = [Tb].DocumentID
			Left Join uvw_Employee As [E]
				On [E].EmployeeID = [Tb].EmployeeID
			Left Join uvw_TransactionEmployeeExpense_Amount As [Eea]
				On [Eea].TransactionEmployeeExpenseID = [Tb].TransactionEmployeeExpenseID
			Left Join uvw_TransactionEmployeeExpense_IsPaid As [Eeid]
				On [Eeid].TransactionEmployeeExpenseID = [Tb].TransactionEmployeeExpenseID
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_TransactionSalesInvoice_IsPaid]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesInvoice_IsPaid]
As
	Select
		[Tb].TransactionSalesInvoiceID
		, [Tb].Paid_Amount
		, [Tb].Due_Amount
		, [Tb].Balance_Amount
		, Cast(
		(
		Case 
			When [Tb].Balance_Amount <= 0 Then 1
			Else 0
		End
		) As Bit)As [IsPaid]
	From
		uvw_TransactionSalesInvoice_Balance As [Tb]
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseInvoice_Balance]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionPurchaseInvoice_Balance]
As
	Select
		[Tb].TransactionPurchaseInvoiceID
		, IsNull([Pip].Amount,0) As [Paid_Amount]
		, IsNull([Tb].Amount,0) As [Due_Amount]
		, (IsNull([Tb].Amount,0) - IsNull([Pip].Amount,0)) As [Balance_Amount]
	From
		uvw_TransactionPurchaseInvoice_Amount As [Tb]
		Left Join uvw_TransactionPurchaseInvoice_Paid As [Pip]
			On [Pip].TransactionPurchaseInvoiceID = [Tb].TransactionPurchaseInvoiceID
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseInvoice_IsPaid]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionPurchaseInvoice_IsPaid]
As
	Select
		[Tb].TransactionPurchaseInvoiceID
		, [Tb].Paid_Amount
		, [Tb].Due_Amount
		, [Tb].Balance_Amount
		, Cast(
		(
		Case 
			When [Tb].Balance_Amount <= 0 Then 1
			Else 0
		End
		) As Bit)As [IsPaid]
	From
		uvw_TransactionPurchaseInvoice_Balance As [Tb]
GO
/****** Object:  StoredProcedure [dbo].[uvw_TransactionEmployeeExpense_DocumentChartOfAccounts]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[uvw_TransactionEmployeeExpense_DocumentChartOfAccounts]
As
	Select 
		[Tb].* 
		, [Dcoad].AccountingChartOfAccountsID
		, [Dcoad].AccountCodeName
		, [Dcoad].AccountType_Desc
		, [Dcoad].[Desc]
		, [Dcoad].Amount
		, [Dcoad].Tax_Perc
		, [Dcoad].Tax_Amount
		, [Dcoad].Gross_Amount
	From
		uvw_TransactionEmployeeExpense As [Tb]
		Left Join uvw_DocumentChartOfAccounts_Details As [Dcoad]
			On [Dcoad].DocumentChartOfAccountsID = [Tb].DocumentChartOfAccountsID
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_EmployeeExpense_Amount]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionPurchasePayment_EmployeeExpense_Amount]
As
	Select 
		[Tbd].TransactionPurchasePaymentID
		, Sum([Tbd].Amount) As [Amount]
		, Sum([Ee].Amount) As [Ee_Amount]
	From 
		TransactionPurchasePayment_EmployeeExpense As [Tbd]
		Left Join uvw_TransactionEmployeeExpense As [Ee]
			On [Ee].TransactionEmployeeExpenseID = [Tbd].TransactionEmployeeExpenseID
	Where
		IsNull([Tbd].IsDeleted,0) = 0
	Group By
		[Tbd].TransactionPurchasePaymentID
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_EmployeeExpense]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionPurchasePayment_EmployeeExpense]
As
	Select 
		[Tbd].*
		
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
		
		, [Ee].DocNo As [Ee_DocNo]
		, [Ee].IsPosted As [Ee_IsPosted]
		, [Ee].IsCancelled As [Ee_IsCancelled]
		, [Ee].DatePosted As [Ee_DatePosted]
		, [Ee].DateCancelled As [Ee_DateCancelled]
		, [Ee].Amount As [Ee_Amount]
		, [Ee].Balance_Amount
		
	From 
		TransactionPurchasePayment_EmployeeExpense As [Tbd]
		Left Join TransactionPurchasePayment As [Tb]
			On [Tb].TransactionPurchasePaymentID = [Tbd].TransactionPurchasePaymentID
		Left Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Left Join uvw_TransactionEmployeeExpense As [Ee]
			On [Ee].TransactionEmployeeExpenseID = [Tbd].TransactionEmployeeExpenseID
GO
/****** Object:  View [dbo].[uvw_TransactionSalesInvoice]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesInvoice]
As
	Select
		[Tb].*
		, (
		Case [Tb].IsCancelled
			When 1 Then
				'Cancelled'
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					(
					Case [Tb].IsPaid
						When 1 Then
							'Paid'
						Else
							'Posted'
					End
					)
				Else 
					'Open'
			End
			)
		End
		) As [Status]
	From
		(
		Select 
			[Tb].*
			
			, [Rp].Remarks
			, [Rp].Employee_CreatedBy
			, [Rp].Employee_UpdatedBy
			, [Rp].DateCreated
			, [Rp].DateUpdated
			
			, [D].DocNo
			--, [D].Status
			, [D].DateApplied
			, [D].IsPosted
			, [D].IsCancelled
			, [D].DatePosted
			, [D].DateCancelled
			, [D].Employee_PostedBy
			, [D].Employee_CancelledBy
			
			, [Lkp_PaymentTerm].[Desc] As [PaymentTerm_Desc]
			, [Lkp_InvoiceType].[Desc] As [InvoiceType_Desc]
			
			, [Do].DocNo As [Do_DocNo]
			, [Do].DatePosted As [Do_DatePosted]
			, [Do].TransactionSalesOrderID
			, [Do].So_DocNo
			, [Do].So_DatePosted
			, [Do].CustomerID
			, [Do].PartyID_Customer
			, [Do].CustomerCodeName
			, [Do].Company
			, [Do].BillingAddress
			, [Do].ShippingAddress
			
			, [Do].PST_Perc
			, [Do].GST_Perc
			, [Do].HST_Perc
			, [Do].Item_Amount As [Do_Item_Amount]
			, [Do].SubAmount As [Do_SubAmount]
			, [Do].Amount As [Do_Amount]
			
			, (
			+ IsNull([Tb].Freight_Amount,0) 
			+ IsNull([Tb].OtherCost_Amount,0) 
			) As [Freight_OtherCost_Amount]
			
			, [Sia].SubAmount
			, [Sia].PST_Amount
			, [Sia].GST_Amount
			, [Sia].HST_Amount
			, [Sia].Amount
			, [Sia].TaxTotal
			
			, [Siip].Paid_Amount 
			, [Siip].Balance_Amount 
			, [Siip].IsPaid
			
		From 
			TransactionSalesInvoice As [Tb]
			Left Join uvw_RowProperty As [Rp]
				On [Rp].RowPropertyID = [Tb].RowPropertyID
			Left Join uvw_Document As [D]
				On [D].DocumentID = [Tb].DocumentID
			Left Join udf_Lookup('PaymentTerm') As [Lkp_PaymentTerm]
				On [Lkp_PaymentTerm].LookupID = [Tb].LookupID_PaymentTerm
			Left Join udf_Lookup('InvoiceType') As [Lkp_InvoiceType]
				On [Lkp_InvoiceType].LookupID = [Tb].LookupID_InvoiceType
			Left Join uvw_TransactionDeliverOrder As [Do]
				On [Do].TransactionDeliverOrderID = [Tb].TransactionDeliverOrderID
			Left Join uvw_TransactionSalesInvoice_Amount As [Sia]
				On [Sia].TransactionSalesInvoiceID = [Tb].TransactionSalesInvoiceID
			Left Join uvw_TransactionSalesInvoice_IsPaid As [Siip]
				On [Siip].TransactionSalesInvoiceID = [Tb].TransactionSalesInvoiceID
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_Customer_SalesInvoice]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_Customer_SalesInvoice]
As
	Select
		[Tb].*
	From 
		uvw_Customer As [Tb]
		Inner Join uvw_TransactionSalesInvoice As [Si]
			On [Si].CustomerID = [Tb].CustomerID
			And IsNull([Si].IsPosted,0) = 1
			And IsNull([Si].IsCancelled,0) = 0
			And IsNull([Si].IsPaid,0) = 0
GO
/****** Object:  View [dbo].[uvw_TransactionSalesReturn]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesReturn]
As
	
	Select
		[Tb].*
		
		, [Rp].Remarks
		, [Rp].Employee_CreatedBy
		, [Rp].Employee_UpdatedBy
		, [Rp].DateCreated
		, [Rp].DateUpdated
		
		, [D].DocNo
		, [D].Status
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
		, [D].Employee_PostedBy
		, [D].Employee_CancelledBy
		
		, [C].CustomerCode
		, [C].CustomerName
		, [C].CustomerCodeName
		, [C].Company
		, [C].Address As [CustomerAddress]
		
		, [Wh].WarehouseCode
		, [Wh].WarehouseName
		, [Wh].WarehouseCodeName
		, [Wh].Address As [WarehouseAddress]
		
		, [Si].DocNo As [Si_DocNo]
		, [Si].DatePosted As [Si_DatePosted]
		
		, [Srdi].Amount
		
	From
		TransactionSalesReturn As [Tb]
		Left Join uvw_RowProperty As [Rp]
			On [Rp].RowPropertyID = [Tb].RowPropertyID
		Left Join uvw_Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Left Join uvw_Customer As [C]
			On [C].CustomerID = [Tb].CustomerID
		Left Join uvw_Warehouse As [Wh]
			On [Wh].WarehouseID = [Tb].WarehouseID
		Left Join uvw_TransactionSalesInvoice As [Si]
			On [Si].TransactionSalesInvoiceID = [Tb].TransactionSalesInvoiceID
		Left Join
			(
			Select
				TransactionSalesReturnID
				, IsNull(Sum(Sr_Amount),0) As [Amount]
			From 
				uvw_TransactionSalesReturn_DocumentItem_Desc
			Group By
				TransactionSalesReturnID
			) As [Srdi]
			On [Srdi].TransactionSalesReturnID = [Tb].TransactionSalesReturnID
GO
/****** Object:  View [dbo].[uvw_TransactionSalesPayment_SalesInvoice_Amount]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesPayment_SalesInvoice_Amount]
As
	Select 
		[Tbd].TransactionSalesPaymentID
		, Sum([Tbd].Amount) As [Amount]
		, Sum([Si].Amount) As [Si_Amount]
	From 
		TransactionSalesPayment_SalesInvoice As [Tbd]
		Left Join uvw_TransactionSalesInvoice As [Si]
			On [Si].TransactionSalesInvoiceID = [Tbd].TransactionSalesInvoiceID
	Where
		IsNull([Tbd].IsDeleted,0) = 0
	Group By
		[Tbd].TransactionSalesPaymentID
GO
/****** Object:  View [dbo].[uvw_TransactionReceiveOrder_IsPaid]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionReceiveOrder_IsPaid]
As
	Select 
		[Piro].TransactionReceiveOrderID
		, Cast(1 As Bit) As [IsPaid]
	From 
		uvw_TransactionPurchaseInvoice_IsPaid As [Piip]
		Left Join TransactionPurchaseInvoice_ReceiveOrder As [Piro]
			On [Piro].TransactionPurchaseInvoiceID = [Piip].TransactionPurchaseInvoiceID
	Where
		IsNull([Piip].IsPaid,0) = 1
	Group By
		[Piro].TransactionReceiveOrderID
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseInvoice]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionPurchaseInvoice]
As
	Select
		[Tb].*
		, (
		Case [Tb].IsCancelled
			When 1 Then
				'Cancelled'
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					(
					Case [Tb].IsPaid
						When 1 Then
							'Paid'
						Else
							'Posted'
					End
					)
				Else 
					'Open'
			End
			)
		End
		) As [Status]
	From
		(
		Select 
			[Tb].*
			
			, [Rp].Remarks
			, [Rp].Employee_CreatedBy
			, [Rp].Employee_UpdatedBy
			, [Rp].DateCreated
			, [Rp].DateUpdated
			
			, [D].DocNo
			--, [D].Status
			, [D].DateApplied
			, [D].IsPosted
			, [D].IsCancelled
			, [D].DatePosted
			, [D].DateCancelled
			, [D].Employee_PostedBy
			, [D].Employee_CancelledBy
			
			, [Pr].PartyCode
			, [Pr].PartyName
			, [Pr].PartyCodeName
			, [Pr].PartyType_Desc
			
			, [Pia].Dcoa_Amount
			, [Pia].Piro_Amount
			, [Pia].Amount
			
			, [Piid].Paid_Amount
			, [Piid].Balance_Amount
			, [Piid].IsPaid
			
		From 
			TransactionPurchaseInvoice As [Tb]
			Left Join uvw_RowProperty As [Rp]
				On [Rp].RowPropertyID = [Tb].RowPropertyID
			Left Join uvw_Document As [D]
				On [D].DocumentID = [Tb].DocumentID
			Left Join uvw_Party As [Pr]
				On [Pr].PartyID = [Tb].PartyID
			Left Join uvw_TransactionPurchaseInvoice_Amount As [Pia]
				On [Pia].TransactionPurchaseInvoiceID = [Tb].TransactionPurchaseInvoiceID
			Left Join uvw_TransactionPurchaseInvoice_IsPaid As [Piid]
				On [Piid].TransactionPurchaseInvoiceID = [Tb].TransactionPurchaseInvoiceID
		) As [Tb]
GO
/****** Object:  StoredProcedure [dbo].[uvw_TransactionPurchaseInvoice_DocumentChartOfAccounts]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[uvw_TransactionPurchaseInvoice_DocumentChartOfAccounts]
As
	Select 
		[Tb].* 
		, [Dcoad].AccountingChartOfAccountsID
		, [Dcoad].AccountCodeName
		, [Dcoad].AccountType_Desc
		, [Dcoad].[Desc]
		, [Dcoad].Amount
		, [Dcoad].Tax_Perc
		, [Dcoad].Tax_Amount
		, [Dcoad].Gross_Amount
	From
		uvw_TransactionPurchaseInvoice As [Tb]
		Left Join uvw_DocumentChartOfAccounts_Details As [Dcoad]
			On [Dcoad].DocumentChartOfAccountsID = [Tb].DocumentChartOfAccountsID
GO
/****** Object:  View [dbo].[uvw_TransactionReceiveOrder]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionReceiveOrder]
As
	Select
		[Tb].*
		, (
		Case [Tb].IsCancelled
			When 1 Then
				'Cancelled'
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					(
					Case [Tb].IsInvoiced
						When 1 Then
							'Invoiced'
						Else
						(
						Case [Tb].IsPaid
							When 1 Then
								'Paid'
							Else
								'Posted'
						End
						)
					End
					)
				Else 
					'Open'
			End
			)
		End
		) As [Status]
	From
		(
		Select 
			[Tb].*
			
			, [Rp].Remarks
			, [Rp].Employee_CreatedBy
			, [Rp].Employee_UpdatedBy
			, [Rp].DateCreated
			, [Rp].DateUpdated
			
			, [D].DocNo
			--, [D].Status
			, [D].IsPosted
			, [D].IsCancelled
			, [D].DatePosted
			, [D].DateCancelled
			, [D].Employee_PostedBy
			, [D].Employee_CancelledBy
			
			, [Wh].WarehouseCode
			, [Wh].WarehouseName
			, [Wh].WarehouseCodeName
			, [Wh].Address As [WarehouseAddress]
			
			, [Po].DocNo As [Po_DocNo]
			, [Po].DatePosted As [Po_DatePosted]
			, [Po].PartyID_Supplier
			, [Po].SupplierID
			, [Po].SupplierCode
			, [Po].SupplierName
			, [Po].SupplierCodeName
			, [Po].SupplierAddress		
			
			, [Roii].IsInvoiced
			, [Roip].IsPaid
			, [Roa].Amount
			
		From 
			TransactionReceiveOrder As [Tb]
			Left Join uvw_RowProperty As [Rp]
				On [Rp].RowPropertyID = [Tb].RowPropertyID
			Left Join uvw_Document As [D]
				On [D].DocumentID = [Tb].DocumentID
			Left Join uvw_Warehouse As [Wh]
				On [Wh].WarehouseID = [Tb].WarehouseID
			Left Join uvw_TransactionPurchaseOrder As [Po]
				On [Po].TransactionPurchaseOrderID = [Tb].TransactionPurchaseOrderID
			Left Join uvw_TransactionReceiveOrder_IsInvoiced As [Roii]
				On [Roii].TransactionReceiveOrderID = [Tb].TransactionReceiveOrderID
			Left Join uvw_TransactionReceiveOrder_IsPaid As [Roip]
				On [Roip].TransactionReceiveOrderID = [Tb].TransactionReceiveOrderID
			Left Join uvw_TransactionReceiveOrder_Amount As [Roa]
				On [Roa].TransactionReceiveOrderID = [Tb].TransactionReceiveOrderID
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_PurchaseInvoice_Amount]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionPurchasePayment_PurchaseInvoice_Amount]
As
	Select 
		[Tbd].TransactionPurchasePaymentID
		, Sum([Tbd].Amount) As [Amount]
		, Sum([Pi].Amount) As [Pi_Amount]
	From 
		TransactionPurchasePayment_PurchaseInvoice As [Tbd]
		Left Join uvw_TransactionPurchaseInvoice As [Pi]
			On [Pi].TransactionPurchaseInvoiceID = [Tbd].TransactionPurchaseInvoiceID
	Where
		IsNull([Tbd].IsDeleted,0) = 0
	Group By
		[Tbd].TransactionPurchasePaymentID
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_PurchaseInvoice]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionPurchasePayment_PurchaseInvoice]
As
	Select 
		[Tbd].*
		
		, [D].DocNo
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
		
		, [Pi].DocNo As [Pi_DocNo]
		, [Pi].IsPosted As [Pi_IsPosted]
		, [Pi].IsCancelled As [Pi_IsCancelled]
		, [Pi].DatePosted As [Pi_DatePosted]
		, [Pi].DateCancelled As [Pi_DateCancelled]
		, [Pi].Amount As [Pi_Amount]
		, [Pi].Balance_Amount
		
	From 
		TransactionPurchasePayment_PurchaseInvoice As [Tbd]
		Left Join TransactionPurchasePayment As [Tb]
			On [Tb].TransactionPurchasePaymentID = [Tbd].TransactionPurchasePaymentID
		Left Join Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Left Join uvw_TransactionPurchaseInvoice As [Pi]
			On [Pi].TransactionPurchaseInvoiceID = [Tbd].TransactionPurchaseInvoiceID
GO
/****** Object:  View [dbo].[uvw_TransactionSalesPayment]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesPayment]
As
	Select
		[Tb].*
		, (IsNull([Tb].Paid_Amount,0) - IsNull([Tb].Spsi_Amount,0)) As [Unapplied_Amount]
	From
		(
		Select 
			[Tb].*
			
			, [Rp].Remarks
			, [Rp].Employee_CreatedBy
			, [Rp].Employee_UpdatedBy
			, [Rp].DateCreated
			, [Rp].DateUpdated
			
			, [D].DocNo
			, [D].Status
			, [D].DateApplied
			, [D].IsPosted
			, [D].IsCancelled
			, [D].DatePosted
			, [D].DateCancelled
			, [D].Employee_PostedBy
			, [D].Employee_CancelledBy
			
			, [C].CustomerCode
			, [C].CustomerName
			, [C].CustomerCodeName
			, [C].Company
			, [C].Address As [CustomerAddress]
			
			, [Payment].Cash_Amount
			, [Payment].Check_Amount
			, [Payment].CreditCard_Amount
			, [Payment].BankTransfer_Amount
			, [Payment].Amount As [Paid_Amount]
			
			, IsNull([Spsia].Amount,0) As [Spsi_Amount]
			, IsNull([Spsia].Si_Amount,0) As [Due_Amount]
			
		From 
			TransactionSalesPayment As [Tb]
			Left Join uvw_RowProperty As [Rp]
				On [Rp].RowPropertyID = [Tb].RowPropertyID
			Left Join uvw_Document As [D]
				On [D].DocumentID = [Tb].DocumentID
			Left Join uvw_Customer As [C]
				On [C].CustomerID = [Tb].CustomerID
			Left Join uvw_Payment As [Payment]
				On [Payment].PaymentID = [Tb].PaymentID
			Left Join uvw_TransactionSalesPayment_SalesInvoice_Amount As [Spsia]
				On [Spsia].TransactionSalesPaymentID = [Tb].TransactionSalesPaymentID
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_TransactionSalesPayment_SalesInvoice]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionSalesPayment_SalesInvoice]
As
	Select 
		[Tbd].*
		
		, [Tb].DocNo
		, [Tb].DateApplied
		, [Tb].IsPosted
		, [Tb].IsCancelled
		, [Tb].DatePosted
		, [Tb].DateCancelled
		
		, [Si].DocNo As [Si_DocNo]
		, [Si].IsPosted As [Si_IsPosted]
		, [Si].IsCancelled As [Si_IsCancelled]
		, [Si].DatePosted As [Si_DatePosted]
		, [Si].DateCancelled As [Si_DateCancelled]
		, [Si].Amount As [Si_Amount]
		, [Si].Balance_Amount
		
	From 
		TransactionSalesPayment_SalesInvoice As [Tbd]
		Left Join uvw_TransactionSalesPayment As [Tb]
			On [Tb].TransactionSalesPaymentID = [Tbd].TransactionSalesPaymentID
		Left Join uvw_TransactionSalesInvoice As [Si]
			On [Si].TransactionSalesInvoiceID = [Tbd].TransactionSalesInvoiceID
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseReturn]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionPurchaseReturn]
As
	Select
		[Tb].*
		
		, [Rp].Remarks
		, [Rp].Employee_CreatedBy
		, [Rp].Employee_UpdatedBy
		, [Rp].DateCreated
		, [Rp].DateUpdated
		
		, [D].DocNo
		, [D].Status
		, [D].DateApplied
		, [D].IsPosted
		, [D].IsCancelled
		, [D].DatePosted
		, [D].DateCancelled
		, [D].Employee_PostedBy
		, [D].Employee_CancelledBy
		
		, [S].SupplierCode
		, [S].SupplierName
		, [S].SupplierCodeName
		, [S].Address As [SupplierAddress]
		
		, [Wh].WarehouseCode
		, [Wh].WarehouseName
		, [Wh].WarehouseCodeName
		, [Wh].Address As [WarehouseAddress]
		
		, [Ro].DocNo As [Ro_DocNo]
		, [Ro].DatePosted As [Ro_DatePosted]
		
		, [Prdi].Amount
		
	From
		TransactionPurchaseReturn As [Tb]
		Left Join uvw_RowProperty As [Rp]
			On [Rp].RowPropertyID = [Tb].RowPropertyID
		Left Join uvw_Document As [D]
			On [D].DocumentID = [Tb].DocumentID
		Left Join uvw_Supplier As [S]
			On [S].SupplierID = [Tb].SupplierID
		Left Join uvw_Warehouse As [Wh]
			On [Wh].WarehouseID = [Tb].WarehouseID
		Left Join uvw_TransactionReceiveOrder As [Ro]
			On [Ro].TransactionReceiveOrderID = [Tb].TransactionReceiveOrderID
		Left Join
			(
			Select
				TransactionPurchaseReturnID
				, IsNull(Sum(Pr_Amount),0) As [Amount]
			From 
				uvw_TransactionPurchaseReturn_DocumentItem_Desc
			Group By
				TransactionPurchaseReturnID
			) As [Prdi]
			On [Prdi].TransactionPurchaseReturnID = [Tb].TransactionPurchaseReturnID
GO
/****** Object:  View [dbo].[uvw_CreditNotes]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_CreditNotes]
As
	Select
		[Tb].*
		, [C].CustomerCode
		, [C].CustomerName
		, [C].CustomerCodeName
		, [C].Company
	From
		(
		Select
			[Lkp_Cnst].[Desc] As [Source_Desc]
			, [Lkp_Cnst].System_LookupID As [System_LookupID_CreditNoteSourceType]
			, [Tb].TransactionSalesPaymentID As [SourceID]
			, [Tb].DocNo
			, [Tb].DatePosted
			, [Tb].CustomerID
			, IsNull([Tb].Unapplied_Amount,0) As [Amount]
		From
			uvw_TransactionSalesPayment As [Tb]
			Inner Join udf_System_Lookup('CreditNoteSourceType') As [Lkp_Cnst]
				On [Lkp_Cnst].System_LookupID = 1
		Where
			IsNull([Tb].IsPosted,0) = 1
			And IsNull([Tb].IsCancelled,0) = 0
			And IsNull([Tb].Unapplied_Amount,0) > 0
		
		Union All
		
		Select
			[Lkp_Cnst].[Desc] As [Source_Desc]
			, [Lkp_Cnst].System_LookupID As [System_LookupID_CreditNoteSourceType]
			, [Tb].TransactionSalesReturnID As [SourceID]
			, [Tb].DocNo
			, [Tb].DatePosted
			, [Tb].CustomerID
			, IsNull([Tb].Amount,0) As [Amount]
		From
			uvw_TransactionSalesReturn As [Tb]
			Inner Join udf_System_Lookup('CreditNoteSourceType') As [Lkp_Cnst]
				On [Lkp_Cnst].System_LookupID = 2
		Where
			IsNull([Tb].IsPosted,0) = 1
			And IsNull([Tb].IsCancelled,0) = 0
		) As [Tb]
		Left Join uvw_Customer As [C]
			On [C].CustomerID = [Tb].CustomerID
GO
/****** Object:  View [dbo].[uvw_CreditNotes_Balance]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_CreditNotes_Balance]
As	
	Select
		[Tb].*
		, IsNull([Ppcn].Amount,0) As [Paid_Amount]
		, IsNull([Tb].Amount,0) As [Due_Amount]
		, IsNull([Tb].Amount,0) - IsNull([Ppcn].Amount,0) As [Balance_Amount]
	From
		uvw_CreditNotes As [Tb]
		Left Join 
			(
			Select
				[Ppcn].System_LookupID_CreditNoteSourceType
				, [Ppcn].SourceID
				, Sum([Ppcn].Amount) As [Amount]
			From
				TransactionPurchasePayment_CreditNotes As [Ppcn]
				Left Join TransactionPurchasePayment As [Pp]
					On [Pp].TransactionPurchasePaymentID = [Ppcn].TransactionPurchasePaymentID
				Left Join uvw_Document As [D]
					On [D].DocumentID = [Pp].DocumentID
			Where
				IsNull([D].IsPosted,0) = 1
				And IsNull([D].IsCancelled,0) = 0
				And IsNull([Ppcn].IsDeleted,0) = 0
			Group By
				[Ppcn].System_LookupID_CreditNoteSourceType
				, [Ppcn].SourceID
			) As [Ppcn]
			On [Ppcn].System_LookupID_CreditNoteSourceType = [Tb].System_LookupID_CreditNoteSourceType
			And [Ppcn].SourceID = [Tb].SourceID
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_Amount]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_Amount]
As
	Select 
		[Tbd].TransactionPurchasePaymentID
		, Sum([Tbd].Amount) As [Amount]
		, Sum([Cn].Amount) As [Cn_Amount]
	From 
		TransactionPurchasePayment_CreditNotes As [Tbd]
		Left Join uvw_CreditNotes As [Cn]
			On [Cn].System_LookupID_CreditNoteSourceType = [Tbd].System_LookupID_CreditNoteSourceType
			And [Cn].SourceID = [Tbd].SourceID
	Group By
		[Tbd].TransactionPurchasePaymentID
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_SalesReturn_Amount]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_SalesReturn_Amount]
As
	Select 
		[Tbd].TransactionPurchasePaymentID
		, Sum([Tbd].Amount) As [Amount]
		, Sum([Cn].Amount) As [Cn_Amount]
	From 
		TransactionPurchasePayment_CreditNotes As [Tbd]
		Left Join uvw_CreditNotes As [Cn]
			On [Cn].System_LookupID_CreditNoteSourceType = [Tbd].System_LookupID_CreditNoteSourceType
			And [Cn].SourceID = [Tbd].SourceID
	Where
		[Cn].System_LookupID_CreditNoteSourceType = 2
	Group By
		[Tbd].TransactionPurchasePaymentID
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_SalesPayment_Amount]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_SalesPayment_Amount]
As
	Select 
		[Tbd].TransactionPurchasePaymentID
		, Sum([Tbd].Amount) As [Amount]
		, Sum([Cn].Amount) As [Cn_Amount]
	From 
		TransactionPurchasePayment_CreditNotes As [Tbd]
		Left Join uvw_CreditNotes As [Cn]
			On [Cn].System_LookupID_CreditNoteSourceType = [Tbd].System_LookupID_CreditNoteSourceType
			And [Cn].SourceID = [Tbd].SourceID
	Where
		[Cn].System_LookupID_CreditNoteSourceType = 1
	Group By
		[Tbd].TransactionPurchasePaymentID
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_CreditNoteSourceType_Amount]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_CreditNoteSourceType_Amount]
As
	Select 
		[Tbd].TransactionPurchasePaymentID
		, [Cn].System_LookupID_CreditNoteSourceType
		, Sum([Tbd].Amount) As [Amount]
		, Sum([Cn].Amount) As [Cn_Amount]
		, Sum([Cn].Balance_Amount) As [Cn_Balance_Amount]
	From 
		TransactionPurchasePayment_CreditNotes As [Tbd]
		Left Join uvw_CreditNotes_Balance As [Cn]
			On [Cn].System_LookupID_CreditNoteSourceType = [Tbd].System_LookupID_CreditNoteSourceType
			And [Cn].SourceID = [Tbd].SourceID
	Where
		IsNull([Tbd].IsDeleted,0) = 0
	Group By
		[Tbd].TransactionPurchasePaymentID
		, [Cn].System_LookupID_CreditNoteSourceType
GO
/****** Object:  View [dbo].[uvw_CreditNotes_IsPaid]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[uvw_CreditNotes_IsPaid]
As
	Select
		[Tb].*
		, Cast(
		(
		Case 
			When [Tb].Balance_Amount <= 0 Then 1
			Else 0
		End
		) As Bit)As [IsPaid]
	From
		uvw_CreditNotes_Balance As [Tb]
GO
/****** Object:  View [dbo].[uvw_CreditNotes_Cp]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_CreditNotes_Cp]
As
	Select
		[Tb].*
		, [Lkp_Cnst].[Desc] As [CreditNoteSourceType_Desc]
		, Row_Number() Over (Order By (Select 0)) As [ID]
		, (
		Case [Tb].IsPaid
			When 1 Then
				'Refunded'
			Else
				'Open'
		End
		) As [Status]
	From
		uvw_CreditNotes_IsPaid As [Tb]
		Left Join udf_System_Lookup('CreditNoteSourceType') As [Lkp_Cnst]
			On [Lkp_Cnst].System_LookupID = [Tb].System_LookupID_CreditNoteSourceType
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_Cp]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionPurchasePayment_Cp]
As
	Select
		[Tb].*
		, (
		IsNull([Tb].Paid_Amount,0) - IsNull([Tb].Applied_Amount,0)) As [Unapplied_Amount]
	From
		(
		Select 
			[Tb].*
			
			, [Payment].Cash_Amount
			, [Payment].Check_Amount
			, [Payment].CreditCard_Amount
			, [Payment].BankTransfer_Amount
			, [Payment].Amount As [Paid_Amount]
			
			, (
			IsNull([Ppcncnsta].Amount,0)
			+ IsNull([Pppia].Amount,0)
			+ IsNull([Ppeea].Amount,0)
			) As [Applied_Amount]
			
			, (
			IsNull([Ppcncnsta].Cn_Amount,0)
			+ IsNull([Pppia].Pi_Amount,0)
			+ IsNull([Ppeea].Ee_Amount,0)
			) As [Due_Amount]
			
		From 
			uvw_TransactionPurchasePayment As [Tb]
			Left Join uvw_Payment As [Payment]
				On [Payment].PaymentID = [Tb].PaymentID
			Left Join uvw_TransactionPurchasePayment_PurchaseInvoice_Amount As [Pppia]
				On [Pppia].TransactionPurchasePaymentID = [Tb].TransactionPurchasePaymentID
				And [Tb].System_LookupID_PurchasePaymentType = 1
			Left Join uvw_TransactionPurchasePayment_EmployeeExpense_Amount As [Ppeea]
				On [Ppeea].TransactionPurchasePaymentID = [Tb].TransactionPurchasePaymentID
				And [Tb].System_LookupID_PurchasePaymentType = 2
			Left Join uvw_TransactionPurchasePayment_CreditNotes_CreditNoteSourceType_Amount As [Ppcncnsta]
				On [Ppcncnsta].TransactionPurchasePaymentID = [Tb].TransactionPurchasePaymentID
				And (
					[Tb].System_LookupID_PurchasePaymentType = 3
					Or [Tb].System_LookupID_PurchasePaymentType = 4)
		) As [Tb]
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_CreditNotes]    Script Date: 06/04/2012 21:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[uvw_TransactionPurchasePayment_CreditNotes]
As	
	Select
		[Tbd].*
		
		, [Tb].DocNo
		, [Tb].DateApplied
		, [Tb].IsPosted
		, [Tb].IsCancelled
		, [Tb].DatePosted
		, [Tb].DateCancelled
		
		, [Cn].DocNo As [Source_DocNo]
		, [Cn].DatePosted As [Source_DatePosted]
		, [Cn].Amount As [Source_Amount]
		, [Cn].Balance_Amount
		
	From
		TransactionPurchasePayment_CreditNotes As [Tbd]
		Left Join uvw_TransactionPurchasePayment As [Tb]
			On [Tb].TransactionPurchasePaymentID = [Tbd].TransactionPurchasePaymentID
		Left Join uvw_CreditNotes_Cp As [Cn]
			On [Cn].System_LookupID_CreditNoteSourceType = [Tbd].System_LookupID_CreditNoteSourceType
			And [Cn].SourceID = [Tbd].SourceID
GO
/****** Object:  ForeignKey [FK_Rights_RowProperty]    Script Date: 06/04/2012 21:16:16 ******/
ALTER TABLE [dbo].[Rights]  WITH CHECK ADD  CONSTRAINT [FK_Rights_RowProperty] FOREIGN KEY([RowPropertyID])
REFERENCES [dbo].[RowProperty] ([RowPropertyID])
GO
ALTER TABLE [dbo].[Rights] CHECK CONSTRAINT [FK_Rights_RowProperty]
GO
/****** Object:  ForeignKey [FK_Party_Address]    Script Date: 06/04/2012 21:16:16 ******/
ALTER TABLE [dbo].[Party]  WITH CHECK ADD  CONSTRAINT [FK_Party_Address] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Address] ([AddressID])
GO
ALTER TABLE [dbo].[Party] CHECK CONSTRAINT [FK_Party_Address]
GO
/****** Object:  ForeignKey [FK_Item_RowProperty]    Script Date: 06/04/2012 21:16:16 ******/
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_RowProperty] FOREIGN KEY([RowPropertyID])
REFERENCES [dbo].[RowProperty] ([RowPropertyID])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_Item_RowProperty]
GO
/****** Object:  ForeignKey [FK_DocumentChartOfAccounts_Details_DocumentChartOfAccounts]    Script Date: 06/04/2012 21:16:16 ******/
ALTER TABLE [dbo].[DocumentChartOfAccounts_Details]  WITH CHECK ADD  CONSTRAINT [FK_DocumentChartOfAccounts_Details_DocumentChartOfAccounts] FOREIGN KEY([DocumentChartOfAccountsID])
REFERENCES [dbo].[DocumentChartOfAccounts] ([DocumentChartOfAccountsID])
GO
ALTER TABLE [dbo].[DocumentChartOfAccounts_Details] CHECK CONSTRAINT [FK_DocumentChartOfAccounts_Details_DocumentChartOfAccounts]
GO
/****** Object:  ForeignKey [FK_DocumentItem_Details_DocumentItem]    Script Date: 06/04/2012 21:16:16 ******/
ALTER TABLE [dbo].[DocumentItem_Details]  WITH CHECK ADD  CONSTRAINT [FK_DocumentItem_Details_DocumentItem] FOREIGN KEY([DocumentItemID])
REFERENCES [dbo].[DocumentItem] ([DocumentItemID])
GO
ALTER TABLE [dbo].[DocumentItem_Details] CHECK CONSTRAINT [FK_DocumentItem_Details_DocumentItem]
GO
/****** Object:  ForeignKey [FK_User_RowProperty]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_RowProperty] FOREIGN KEY([RowPropertyID])
REFERENCES [dbo].[RowProperty] ([RowPropertyID])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_RowProperty]
GO
/****** Object:  ForeignKey [FK_Warehouse_Party]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[Warehouse]  WITH CHECK ADD  CONSTRAINT [FK_Warehouse_Party] FOREIGN KEY([PartyID])
REFERENCES [dbo].[Party] ([PartyID])
GO
ALTER TABLE [dbo].[Warehouse] CHECK CONSTRAINT [FK_Warehouse_Party]
GO
/****** Object:  ForeignKey [FK_User_Rights_User]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[User_Rights]  WITH CHECK ADD  CONSTRAINT [FK_User_Rights_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[User_Rights] CHECK CONSTRAINT [FK_User_Rights_User]
GO
/****** Object:  ForeignKey [FK_Customer_Party]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Party] FOREIGN KEY([PartyID])
REFERENCES [dbo].[Party] ([PartyID])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Party]
GO
/****** Object:  ForeignKey [FK_Customer_Person]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Person]
GO
/****** Object:  ForeignKey [FK_Bank_Party]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[Bank]  WITH CHECK ADD  CONSTRAINT [FK_Bank_Party] FOREIGN KEY([PartyID])
REFERENCES [dbo].[Party] ([PartyID])
GO
ALTER TABLE [dbo].[Bank] CHECK CONSTRAINT [FK_Bank_Party]
GO
/****** Object:  ForeignKey [FK_Employee_Party]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Party] FOREIGN KEY([PartyID])
REFERENCES [dbo].[Party] ([PartyID])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Party]
GO
/****** Object:  ForeignKey [FK_Employee_Person1]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Person1] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Person1]
GO
/****** Object:  ForeignKey [FK_Supplier_Party]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[Supplier]  WITH CHECK ADD  CONSTRAINT [FK_Supplier_Party] FOREIGN KEY([PartyID])
REFERENCES [dbo].[Party] ([PartyID])
GO
ALTER TABLE [dbo].[Supplier] CHECK CONSTRAINT [FK_Supplier_Party]
GO
/****** Object:  ForeignKey [FK_ReleasedChecks_Party]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[ReleasedChecks]  WITH CHECK ADD  CONSTRAINT [FK_ReleasedChecks_Party] FOREIGN KEY([PartyID])
REFERENCES [dbo].[Party] ([PartyID])
GO
ALTER TABLE [dbo].[ReleasedChecks] CHECK CONSTRAINT [FK_ReleasedChecks_Party]
GO
/****** Object:  ForeignKey [FK_TransactionPurchaseOrder_Document]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionPurchaseOrder_Document] FOREIGN KEY([DocumentID])
REFERENCES [dbo].[Document] ([DocumentID])
GO
ALTER TABLE [dbo].[TransactionPurchaseOrder] CHECK CONSTRAINT [FK_TransactionPurchaseOrder_Document]
GO
/****** Object:  ForeignKey [FK_TransactionPurchaseOrder_DocumentItem]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionPurchaseOrder_DocumentItem] FOREIGN KEY([DocumentItemID])
REFERENCES [dbo].[DocumentItem] ([DocumentItemID])
GO
ALTER TABLE [dbo].[TransactionPurchaseOrder] CHECK CONSTRAINT [FK_TransactionPurchaseOrder_DocumentItem]
GO
/****** Object:  ForeignKey [FK_TransactionPurchaseOrder_RowProperty]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionPurchaseOrder_RowProperty] FOREIGN KEY([RowPropertyID])
REFERENCES [dbo].[RowProperty] ([RowPropertyID])
GO
ALTER TABLE [dbo].[TransactionPurchaseOrder] CHECK CONSTRAINT [FK_TransactionPurchaseOrder_RowProperty]
GO
/****** Object:  ForeignKey [FK_TransactionPurchaseOrder_Supplier]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionPurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionPurchaseOrder_Supplier] FOREIGN KEY([SupplierID])
REFERENCES [dbo].[Supplier] ([SupplierID])
GO
ALTER TABLE [dbo].[TransactionPurchaseOrder] CHECK CONSTRAINT [FK_TransactionPurchaseOrder_Supplier]
GO
/****** Object:  ForeignKey [FK_TransactionSalesOrder_Customer]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionSalesOrder_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[TransactionSalesOrder] CHECK CONSTRAINT [FK_TransactionSalesOrder_Customer]
GO
/****** Object:  ForeignKey [FK_TransactionSalesOrder_Document]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionSalesOrder_Document] FOREIGN KEY([DocumentID])
REFERENCES [dbo].[Document] ([DocumentID])
GO
ALTER TABLE [dbo].[TransactionSalesOrder] CHECK CONSTRAINT [FK_TransactionSalesOrder_Document]
GO
/****** Object:  ForeignKey [FK_TransactionSalesOrder_DocumentItem]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionSalesOrder_DocumentItem] FOREIGN KEY([DocumentItemID])
REFERENCES [dbo].[DocumentItem] ([DocumentItemID])
GO
ALTER TABLE [dbo].[TransactionSalesOrder] CHECK CONSTRAINT [FK_TransactionSalesOrder_DocumentItem]
GO
/****** Object:  ForeignKey [FK_TransactionSalesOrder_RowProperty]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionSalesOrder_RowProperty] FOREIGN KEY([RowPropertyID])
REFERENCES [dbo].[RowProperty] ([RowPropertyID])
GO
ALTER TABLE [dbo].[TransactionSalesOrder] CHECK CONSTRAINT [FK_TransactionSalesOrder_RowProperty]
GO
/****** Object:  ForeignKey [FK_InventoryWarehouseSnapshot_Warehouse]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[InventoryWarehouseSnapshot]  WITH CHECK ADD  CONSTRAINT [FK_InventoryWarehouseSnapshot_Warehouse] FOREIGN KEY([WarehouseID])
REFERENCES [dbo].[Warehouse] ([WarehouseID])
GO
ALTER TABLE [dbo].[InventoryWarehouseSnapshot] CHECK CONSTRAINT [FK_InventoryWarehouseSnapshot_Warehouse]
GO
/****** Object:  ForeignKey [FK_InventoryWarehouseOpening_Warehouse]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[InventoryWarehouseOpening]  WITH CHECK ADD  CONSTRAINT [FK_InventoryWarehouseOpening_Warehouse] FOREIGN KEY([WarehouseID])
REFERENCES [dbo].[Warehouse] ([WarehouseID])
GO
ALTER TABLE [dbo].[InventoryWarehouseOpening] CHECK CONSTRAINT [FK_InventoryWarehouseOpening_Warehouse]
GO
/****** Object:  ForeignKey [FK_InventoryWarehouseAdjustment_Warehouse]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[InventoryWarehouseAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_InventoryWarehouseAdjustment_Warehouse] FOREIGN KEY([WarehouseID])
REFERENCES [dbo].[Warehouse] ([WarehouseID])
GO
ALTER TABLE [dbo].[InventoryWarehouseAdjustment] CHECK CONSTRAINT [FK_InventoryWarehouseAdjustment_Warehouse]
GO
/****** Object:  ForeignKey [FK_InventoryWarehouseTransfer_Warehouse]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[InventoryWarehouseTransfer]  WITH CHECK ADD  CONSTRAINT [FK_InventoryWarehouseTransfer_Warehouse] FOREIGN KEY([WarehouseID_TransferFrom])
REFERENCES [dbo].[Warehouse] ([WarehouseID])
GO
ALTER TABLE [dbo].[InventoryWarehouseTransfer] CHECK CONSTRAINT [FK_InventoryWarehouseTransfer_Warehouse]
GO
/****** Object:  ForeignKey [FK_InventoryWarehouseTransfer_Warehouse1]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[InventoryWarehouseTransfer]  WITH CHECK ADD  CONSTRAINT [FK_InventoryWarehouseTransfer_Warehouse1] FOREIGN KEY([WarehouseID_TransferTo])
REFERENCES [dbo].[Warehouse] ([WarehouseID])
GO
ALTER TABLE [dbo].[InventoryWarehouseTransfer] CHECK CONSTRAINT [FK_InventoryWarehouseTransfer_Warehouse1]
GO
/****** Object:  ForeignKey [FK_InventoryWarehouseSnapshot_Details_InventoryWarehouseSnapshot]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[InventoryWarehouseSnapshot_Details]  WITH CHECK ADD  CONSTRAINT [FK_InventoryWarehouseSnapshot_Details_InventoryWarehouseSnapshot] FOREIGN KEY([InventoryWarehouseSnapshotID])
REFERENCES [dbo].[InventoryWarehouseSnapshot] ([InventoryWarehouseSnapshotID])
GO
ALTER TABLE [dbo].[InventoryWarehouseSnapshot_Details] CHECK CONSTRAINT [FK_InventoryWarehouseSnapshot_Details_InventoryWarehouseSnapshot]
GO
/****** Object:  ForeignKey [FK_TransactionDeliverOrder_Document]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionDeliverOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionDeliverOrder_Document] FOREIGN KEY([DocumentID])
REFERENCES [dbo].[Document] ([DocumentID])
GO
ALTER TABLE [dbo].[TransactionDeliverOrder] CHECK CONSTRAINT [FK_TransactionDeliverOrder_Document]
GO
/****** Object:  ForeignKey [FK_TransactionDeliverOrder_DocumentItem]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionDeliverOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionDeliverOrder_DocumentItem] FOREIGN KEY([DocumentItemID])
REFERENCES [dbo].[DocumentItem] ([DocumentItemID])
GO
ALTER TABLE [dbo].[TransactionDeliverOrder] CHECK CONSTRAINT [FK_TransactionDeliverOrder_DocumentItem]
GO
/****** Object:  ForeignKey [FK_TransactionDeliverOrder_TransactionSalesOrder]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionDeliverOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionDeliverOrder_TransactionSalesOrder] FOREIGN KEY([TransactionSalesOrderID])
REFERENCES [dbo].[TransactionSalesOrder] ([TransactionSalesOrderID])
GO
ALTER TABLE [dbo].[TransactionDeliverOrder] CHECK CONSTRAINT [FK_TransactionDeliverOrder_TransactionSalesOrder]
GO
/****** Object:  ForeignKey [FK_TransactionDeliverOrder_Warehouse]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionDeliverOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionDeliverOrder_Warehouse] FOREIGN KEY([WarehouseID])
REFERENCES [dbo].[Warehouse] ([WarehouseID])
GO
ALTER TABLE [dbo].[TransactionDeliverOrder] CHECK CONSTRAINT [FK_TransactionDeliverOrder_Warehouse]
GO
/****** Object:  ForeignKey [FK_TransactionReceiveOrder_TransactionPurchaseOrder]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionReceiveOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionReceiveOrder_TransactionPurchaseOrder] FOREIGN KEY([TransactionPurchaseOrderID])
REFERENCES [dbo].[TransactionPurchaseOrder] ([TransactionPurchaseOrderID])
GO
ALTER TABLE [dbo].[TransactionReceiveOrder] CHECK CONSTRAINT [FK_TransactionReceiveOrder_TransactionPurchaseOrder]
GO
/****** Object:  ForeignKey [FK_TransactionReceiveOrder_Warehouse]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionReceiveOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionReceiveOrder_Warehouse] FOREIGN KEY([WarehouseID])
REFERENCES [dbo].[Warehouse] ([WarehouseID])
GO
ALTER TABLE [dbo].[TransactionReceiveOrder] CHECK CONSTRAINT [FK_TransactionReceiveOrder_Warehouse]
GO
/****** Object:  ForeignKey [FK_TransactionSalesInvoice_TransactionDeliverOrder]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionSalesInvoice]  WITH CHECK ADD  CONSTRAINT [FK_TransactionSalesInvoice_TransactionDeliverOrder] FOREIGN KEY([TransactionDeliverOrderID])
REFERENCES [dbo].[TransactionDeliverOrder] ([TransactionDeliverOrderID])
GO
ALTER TABLE [dbo].[TransactionSalesInvoice] CHECK CONSTRAINT [FK_TransactionSalesInvoice_TransactionDeliverOrder]
GO
/****** Object:  ForeignKey [FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionPurchaseInvoice]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionPurchaseInvoice_ReceiveOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionPurchaseInvoice] FOREIGN KEY([TransactionPurchaseInvoiceID])
REFERENCES [dbo].[TransactionPurchaseInvoice] ([TransactionPurchaseInvoiceID])
GO
ALTER TABLE [dbo].[TransactionPurchaseInvoice_ReceiveOrder] CHECK CONSTRAINT [FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionPurchaseInvoice]
GO
/****** Object:  ForeignKey [FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionReceiveOrder]    Script Date: 06/04/2012 21:16:18 ******/
ALTER TABLE [dbo].[TransactionPurchaseInvoice_ReceiveOrder]  WITH CHECK ADD  CONSTRAINT [FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionReceiveOrder] FOREIGN KEY([TransactionReceiveOrderID])
REFERENCES [dbo].[TransactionReceiveOrder] ([TransactionReceiveOrderID])
GO
ALTER TABLE [dbo].[TransactionPurchaseInvoice_ReceiveOrder] CHECK CONSTRAINT [FK_TransactionPurchaseInvoice_ReceiveOrder_TransactionReceiveOrder]
GO
