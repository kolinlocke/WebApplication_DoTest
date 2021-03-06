USE [WebApplication_DoTest]
GO
/****** Object:  View [dbo].[uvw_System_Modules]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_System_Modules]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_System_Modules]
As
	Select
		[Sm].*
		, [Psm].OrderIndex As [Parent_OrderIndex]
	From 
		System_Modules As [Sm]
		Left Join System_Modules As [Psm]
			On [Psm].System_ModulesID = [Sm].Parent_System_ModulesID
'
GO
/****** Object:  View [dbo].[uvw_System_Lookup_Details]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_System_Lookup_Details]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_System_Lookup_Details]
As
	Select 
		[Tbd].*
		, [Tb].[Name] As [Lookup_Name]
	From 
		System_Lookup_Details As [Tbd]
		Left Join System_Lookup As [Tb]
			On [Tb].System_LookupID = [Tbd].System_LookupID
'
GO
/****** Object:  View [dbo].[uvw_System_Modules_AccessLib]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_System_Modules_AccessLib]'))
EXEC dbo.sp_executesql @statement = N'Create  View [dbo].[uvw_System_Modules_AccessLib]
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
'
GO
/****** Object:  View [dbo].[uvw_Lookup_Details]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Lookup_Details]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_Lookup_Details]
As
	Select 
		[Tbd].*
		, [Tb].[Name] As [Lookup_Name]
	From 
		Lookup_Details As [Tbd]
		Left Join Lookup As [Tb]
			On [Tb].LookupID = [Tbd].LookupID
'
GO
/****** Object:  View [dbo].[uvw_Payment_Check]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Payment_Check]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_Payment_Check]
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
'
GO
/****** Object:  View [dbo].[uvw_Payment_Cash]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Payment_Cash]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_Payment_Cash]
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
'
GO
/****** Object:  View [dbo].[uvw_Person_Name]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Person_Name]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Person_Name]
As
	Select 
		[Tb].*
		, IsNull([Tb].FirstName,'''') + '' '' + IsNull([Tb].MiddleName,'''') + '' '' + IsNull([Tb].LastName,'''') As [FullName]
	From 
		Person As [Tb]
'
GO
/****** Object:  View [dbo].[uvw_Person]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Person]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Person]
As
	Select 
		[Tb].*
		, IsNull([Tb].FirstName,'''') + '' '' + IsNull([Tb].MiddleName,'''') + '' '' + IsNull([Tb].LastName,'''') As [FullName]
	From 
		Person As [Tb]
'
GO
/****** Object:  View [dbo].[uvw_Payment_CreditCard]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Payment_CreditCard]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_Payment_CreditCard]
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
'
GO
/****** Object:  View [dbo].[uvw_Payment_BankTransfer]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Payment_BankTransfer]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_Payment_BankTransfer]
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
'
GO
/****** Object:  View [dbo].[uvw_ContactPerson_Details]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_ContactPerson_Details]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_ContactPerson_Details]
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
'
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseReceived_DocumentItem]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_InventoryWarehouseReceived_DocumentItem]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_InventoryWarehouseReceived_DocumentItem]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseReturn_DocumentItem]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchaseReturn_DocumentItem]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionPurchaseReturn_DocumentItem]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesReturn_DocumentItem]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesReturn_DocumentItem]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesReturn_DocumentItem]
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
'
GO
/****** Object:  View [dbo].[uvw_Payment]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Payment]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Payment]
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
'
GO
/****** Object:  View [dbo].[uvw_System_Modules_Access]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_System_Modules_Access]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_System_Modules_Access]
As
	Select Top (100) Percent
		IsNull(Sm.[Parent_System_Modules_Name],''Root'') As [Parent_System_Modules_Name]
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
'
GO
/****** Object:  View [dbo].[uvw_Materialized_InventoryParty_Current_Item]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Materialized_InventoryParty_Current_Item]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_Materialized_InventoryParty_Current_Item]
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
'
GO
/****** Object:  View [dbo].[uvw_AccountingBudget_Period_New]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_AccountingBudget_Period_New]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_AccountingBudget_Period_New]
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
		Right Join udf_System_Lookup(''BudgetPeriod'') As [Lookup_Bp]	
			On [Lookup_Bp].System_LookupID = [Tbd].System_LookupID_BudgetPeriod
'
GO
/****** Object:  View [dbo].[uvw_Address]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Address]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Address]
As
	Select 
		[Tb].* 
		, (
		IsNull([Tb].Address,'''')
		+ Char(13) + Char(10)
		+ IsNull([Tb].City,'''')
		+ Char(13) + Char(10)
		+ IsNull([Lkp_States].[Desc],'''')
		+ Char(13) + Char(10)
		+ IsNull([Tb].[ZipCode],'''')
		+ Char(13) + Char(10)
		+ IsNull([Lkp_Country].[Desc],'''')
		) As [Address_Complete]
	From 
		[Address] As [Tb]
		Left Join udf_Lookup(''States'') As [Lkp_States]
			On [Lkp_States].LookupID = [Tb].LookupID_States
		Left Join udf_Lookup(''Country'') As [Lkp_Country]
			On [Lkp_Country].LookupID = [Tb].LookupID_Country
'
GO
/****** Object:  View [dbo].[uvw_Employee_Name]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Employee_Name]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Employee_Name]
As
	Select 
		[Tb].EmployeeID
		, [Tb].PartyID
		, [Tb].PersonID
		, [P].FullName As [EmployeeName]
	From 
		Employee As [Tb]
		Left Join uvw_Person As [P]
			On [P].PersonID = [Tb].PersonID

'
GO
/****** Object:  View [dbo].[uvw_Customer_Name]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Customer_Name]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Customer_Name]
As
	Select 
		[Tb].CustomerID
		, [Tb].PartyID
		, [Tb].PersonID
		, [P].FullName As [CustomerName]
	From 
		Customer As [Tb]
		Left Join uvw_Person As [P]
			On [P].PersonID = [Tb].PersonID

'
GO
/****** Object:  View [dbo].[uvw_Bank_Account]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Bank_Account]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Bank_Account]
As
	Select 
		[Tb].*
		, [Lkp_Currency].[Desc] As [Lookup_Currency_Desc]
	From 
		Bank_Account As [Tb]
		Left Join udf_Lookup(''Currency'') As [Lkp_Currency]
			On [Lkp_Currency].LookupID = [Tb].LookupID_Currency
'
GO
/****** Object:  View [dbo].[uvw_Document]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Document]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Document]
As
	Select 
		[Tb].*
		
		, [E_PostedBy].EmployeeName As [Employee_PostedBy]
		, [E_CancelledBy].EmployeeName As [Employee_CancelledBy]
		
		, (
		Case [Tb].IsCancelled
			When 1 Then
				''Cancelled''
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					''Posted''
				Else 
					''Open''
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
'
GO
/****** Object:  View [dbo].[uvw_Customer_ShippingAddress]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Customer_ShippingAddress]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Customer_ShippingAddress]
As
	Select
		[Tb].*
		, [A].Address_Complete As [Address]
		, [Lkp_DeliveryMethod].[Desc] As [DeliveryMethod_Desc]
	From
		Customer_ShippingAddress As [Tb]
		Left Join uvw_Address As [A]
			On [A].AddressID = [Tb].AddressID
		Left Join udf_Lookup(''DeliveryMethod'') As [Lkp_DeliveryMethod]
			On [Lkp_DeliveryMethod].LookupID = [Tb].LookupID_DeliveryMethod
'
GO
/****** Object:  View [dbo].[uvw_Address_Customer_ShippingAddress]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Address_Customer_ShippingAddress]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_Address_Customer_ShippingAddress]
As
	Select 
		[Tb].* 
		, [Csa].CustomerID
	From 
		uvw_Address As [Tb]
		Left Join Customer_ShippingAddress As [Csa]
			On [Csa].AddressID = [Tb].AddressID
'
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseOpening_DocumentItem]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_InventoryWarehouseOpening_DocumentItem]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_InventoryWarehouseOpening_DocumentItem]
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
'
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseAdjustment_DocumentItem]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_InventoryWarehouseAdjustment_DocumentItem]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_InventoryWarehouseAdjustment_DocumentItem]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseOrder_DocumentItem]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchaseOrder_DocumentItem]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionPurchaseOrder_DocumentItem]
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
'
GO
/****** Object:  View [dbo].[uvw_RowProperty]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_RowProperty]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_RowProperty]
As
	Select 
		[Tb].*
		, IsNull([Tb].Code,'''') + '' - '' + IsNull([Tb].Name,'''') As [CodeName]
		, [E_Cb].EmployeeName As [Employee_CreatedBy]
		, [E_Ub].EmployeeName As [Employee_UpdatedBy]
	From 
		RowProperty As [Tb]
		Left Join uvw_Employee_Name As [E_Cb]
			On [Tb].EmployeeID_CreatedBy = [E_Cb].EmployeeID
		Left Join uvw_Employee_Name As [E_Ub]
			On [Tb].EmployeeID_UpdatedBy = [E_Ub].EmployeeID
'
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseTransfer_DocumentItem]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_InventoryWarehouseTransfer_DocumentItem]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_InventoryWarehouseTransfer_DocumentItem]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesOrder_DocumentItem]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesOrder_DocumentItem]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesOrder_DocumentItem]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesOrder_Document]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesOrder_Document]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionSalesOrder_Document]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesInvoice_Paid]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesInvoice_Paid]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesInvoice_Paid]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionReceiveOrder_DocumentItem]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionReceiveOrder_DocumentItem]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionReceiveOrder_DocumentItem]
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
'
GO
/****** Object:  View [dbo].[uvw_Party]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Party]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Party]
As
	Select
		[Tb].*
		, IsNull([Tb].PartyCode,'''') + '' - '' + IsNull([Tb].PartyName,'''') As [PartyCodeName]
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

'
GO
/****** Object:  View [dbo].[uvw_Item]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Item]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Item]
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
		Left Join udf_Lookup(''ItemType'') As [L_ItemType]
			On [L_ItemType].LookupID = [Tb].LookupID_ItemType
		Left Join udf_Lookup(''Category'') As [L_Category]
			On [L_Category].LookupID = [Tb].LookupID_Category
		Left Join udf_Lookup(''Brand'') As [L_Brand]
			On [L_Brand].LookupID = [Tb].LookupID_Brand
		Left Join udf_Lookup(''Retailer'') As [L_Retailer]
			On [L_Retailer].LookupID = [Tb].LookupID_Retailer
'
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseSnapshot_Details_Max]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_InventoryWarehouseSnapshot_Details_Max]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_InventoryWarehouseSnapshot_Details_Max]
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
'
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseSnapshot_Details]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_InventoryWarehouseSnapshot_Details]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_InventoryWarehouseSnapshot_Details]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionJournalVoucher]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionJournalVoucher]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionJournalVoucher]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionEmployeeExpense_Paid]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionEmployeeExpense_Paid]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionEmployeeExpense_Paid]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseInvoice_Paid]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchaseInvoice_Paid]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionPurchaseInvoice_Paid]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionDeliverOrder_DocumentItem]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionDeliverOrder_DocumentItem]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionDeliverOrder_DocumentItem]
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
'
GO
/****** Object:  View [dbo].[uvw_Rights]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Rights]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Rights]
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
'
GO
/****** Object:  View [dbo].[uvw_AccountingLedgerPostingPeriod]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_AccountingLedgerPostingPeriod]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_AccountingLedgerPostingPeriod]
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
'
GO
/****** Object:  View [dbo].[uvw_AccountingChartOfAccounts]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_AccountingChartOfAccounts]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_AccountingChartOfAccounts]
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
				''Debit''
			Else
				''Credit''
		End
		) As [IsDebit_Desc]
		
	From 
		AccountingChartOfAccounts As [Tb]
		Left Join uvw_RowProperty As [Rp]
			On [Rp].RowPropertyID = [Tb].RowPropertyID
		Left Join uvw_Party As [Pr]
			On [Pr].PartyID = [Tb].PartyID_Subsidiary
		Left Join udf_System_Lookup(''AccountType'') As [Lkp_AccountType]
			On [Lkp_AccountType].System_LookupID = [Tb].System_LookupID_AccountType
		Left Join udf_Lookup(''Currency'') As [Lkp_Currency]
			On [Lkp_Currency].LookupID = [Tb].LookupID_Currency
'
GO
/****** Object:  View [dbo].[uvw_Employee]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Employee]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Employee]
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
'
GO
/****** Object:  View [dbo].[uvw_DocumentItem_Details]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_DocumentItem_Details]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_DocumentItem_Details]
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
'
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouse_Current_Item]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_InventoryWarehouse_Current_Item]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_InventoryWarehouse_Current_Item]
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
				),''1900-01-01'')
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
				),''1900-01-01'')
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
				),''1900-01-01'')
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
				),''1900-01-01'')
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
				),''1900-01-01'')
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
				),''1900-01-01'')
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
				),''1900-01-01'')
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
				),''1900-01-01'')
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
'
GO
/****** Object:  View [dbo].[uvw_Bank]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Bank]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_Bank]
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
'
GO
/****** Object:  View [dbo].[uvw_ReleasedChecks]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_ReleasedChecks]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_ReleasedChecks]
As
	Select
		[Tb].*
		, (
		Case IsNull([Tb].IsCancelled,0)
			When 1 Then
				''Cancelled''
			Else
			(
			Case IsNull([Tb].IsPosted,0)
				When 1 Then 
					(
					Case IsNull([Tb].IsEncashed,0)
						When 1 Then
							''Posted - Encashed''
						Else
							''Posted''
					End
					)
				Else 
					''Open''
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
'
GO
/****** Object:  View [dbo].[uvw_Supplier]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Supplier]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Supplier]
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
		Left Join udf_Lookup(''LookupID_PaymentTerm'') As [Lkp_PaymentTerm]
			On [Lkp_PaymentTerm].LookupID = [Tb].LookupID_PaymentTerm
'
GO
/****** Object:  View [dbo].[uvw_TransactionDeliverOrder_IsInvoiced]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionDeliverOrder_IsInvoiced]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionDeliverOrder_IsInvoiced]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseOrder_DocumentItem_OrderBalance]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchaseOrder_DocumentItem_OrderBalance]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionPurchaseOrder_DocumentItem_OrderBalance]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchasePayment]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionPurchasePayment]
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
		Left Join udf_System_Lookup(''PurchasePaymentType'') As [Lkp_PurchasePaymentType]
			On [Lkp_PurchasePaymentType].System_LookupID = [Tb].System_LookupID_PurchasePaymentType
'
GO
/****** Object:  View [dbo].[uvw_Materialized_InventoryParty_Current_Item_Desc]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Materialized_InventoryParty_Current_Item_Desc]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_Materialized_InventoryParty_Current_Item_Desc]
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
'
GO
/****** Object:  View [dbo].[uvw_Item_Part]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Item_Part]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Item_Part]
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
'
GO
/****** Object:  View [dbo].[uvw_Rights_Details]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Rights_Details]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Rights_Details]
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
'
GO
/****** Object:  View [dbo].[uvw_Warehouse]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Warehouse]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Warehouse]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionReceiveOrder_DocumentItem_Balance]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionReceiveOrder_DocumentItem_Balance]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionReceiveOrder_DocumentItem_Balance]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionReceiveOrder_IsInvoiced]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionReceiveOrder_IsInvoiced]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionReceiveOrder_IsInvoiced]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesInvoice_DocumentItem_Balance]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesInvoice_DocumentItem_Balance]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesInvoice_DocumentItem_Balance]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesOrder_DocumentItem_OrderBalance]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesOrder_DocumentItem_OrderBalance]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesOrder_DocumentItem_OrderBalance]
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
'
GO
/****** Object:  View [dbo].[uvw_User]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_User]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_User]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesOrder_DocumentItem_Desc]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesOrder_DocumentItem_Desc]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesOrder_DocumentItem_Desc]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesOrder_Complete]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesOrder_Complete]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesOrder_Complete]
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
'
GO
/****** Object:  View [dbo].[uvw_Payment_Check_Details]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Payment_Check_Details]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_Payment_Check_Details]
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
'
GO
/****** Object:  View [dbo].[uvw_Payment_BankTransfer_Details]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Payment_BankTransfer_Details]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_Payment_BankTransfer_Details]
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
'
GO
/****** Object:  View [dbo].[uvw_Lookup]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Lookup]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Lookup]
As
	Select
		[Tb].*
		, (
		Case IsNull([Tb].Tmp_Lookup_Details_Desc,'''')
			When '''' Then ''-Select Default-''
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
							''''
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
'
GO
/****** Object:  View [dbo].[uvw_Item_Supplier]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Item_Supplier]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_Item_Supplier]
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
'
GO
/****** Object:  View [dbo].[uvw_Materialized_InventoryWarehouse_Current_Item]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Materialized_InventoryWarehouse_Current_Item]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Materialized_InventoryWarehouse_Current_Item]
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
'
GO
/****** Object:  View [dbo].[uvw_Item_Location]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Item_Location]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_Item_Location]
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
'
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseTransfer]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_InventoryWarehouseTransfer]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_InventoryWarehouseTransfer]
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
'
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseReceived_DocumentItem_Desc]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_InventoryWarehouseReceived_DocumentItem_Desc]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_InventoryWarehouseReceived_DocumentItem_Desc]
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
'
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseTransfer_DocumentItem_Desc]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_InventoryWarehouseTransfer_DocumentItem_Desc]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_InventoryWarehouseTransfer_DocumentItem_Desc]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionJournalVoucher_Details]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionJournalVoucher_Details]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionJournalVoucher_Details]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseOrder_IsComplete]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchaseOrder_IsComplete]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionPurchaseOrder_IsComplete]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseOrder_DocumentItem_Desc]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchaseOrder_DocumentItem_Desc]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionPurchaseOrder_DocumentItem_Desc]
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
'
GO
/****** Object:  View [dbo].[uvw_Customer]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Customer]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Customer]
As
	Select 
		[Tb].*
		, (
		Case [Tb].IsCreditHold
			When 1 Then ''Yes''
			Else ''-''
		End
		) As [IsCreditHold_Desc]
		, (
		IsNull([Tb].CreditCardNo1,'''')
		+ ''-''
		+ IsNull([Tb].CreditCardNo2,'''')
		+ ''-''
		+ IsNull([Tb].CreditCardNo3,'''')
		+ ''-''
		+ IsNull([Tb].CreditCardNo4,'''')
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
		Left Join udf_Lookup(''ShipVia'') As [Lkp_ShipVia]
			On [Lkp_ShipVia].LookupID = [Tb].LookupID_ShipVia
		Left Join udf_Lookup(''Currency'') As [Lkp_Currency]
			On [Lkp_Currency].LookupID = [Tb].LookupID_Currency
		Left Join udf_Lookup(''PaymentTerm'') As [Lkp_PaymentTerm]
			On [Lkp_PaymentTerm].LookupID = [Tb].LookupID_PaymentTerm
		Left Join uvw_Party As [Party]
			On [Party].PartyID = [Tb].PartyID

'
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseReceived]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_InventoryWarehouseReceived]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_InventoryWarehouseReceived]
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
'
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseOpening_DocumentItem_Desc]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_InventoryWarehouseOpening_DocumentItem_Desc]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_InventoryWarehouseOpening_DocumentItem_Desc]
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
'
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseAdjustment]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_InventoryWarehouseAdjustment]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_InventoryWarehouseAdjustment]
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
'
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseOpening]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_InventoryWarehouseOpening]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_InventoryWarehouseOpening]
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
'
GO
/****** Object:  View [dbo].[uvw_InventoryWarehouseAdjustment_DocumentItem_Desc]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_InventoryWarehouseAdjustment_DocumentItem_Desc]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_InventoryWarehouseAdjustment_DocumentItem_Desc]
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
'
GO
/****** Object:  View [dbo].[uvw_Inventory_Status_Item]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Inventory_Status_Item]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_Inventory_Status_Item]
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
'
GO
/****** Object:  View [dbo].[uvw_DocumentChartOfAccounts_Details]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_DocumentChartOfAccounts_Details]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_DocumentChartOfAccounts_Details]
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
'
GO
/****** Object:  View [dbo].[uvw_AccountingBudget]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_AccountingBudget]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_AccountingBudget]
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
'
GO
/****** Object:  View [dbo].[uvw_AccountingLedger]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_AccountingLedger]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_AccountingLedger]
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
				When 1 Then ''Debit''
				Else ''Credit''
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
			''Current'' As [Tb]
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
			''Posted'' As [Tb]
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
'
GO
/****** Object:  View [dbo].[uvw_AccountingChartOfAccounts_Parent]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_AccountingChartOfAccounts_Parent]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_AccountingChartOfAccounts_Parent]
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
'
GO
/****** Object:  View [dbo].[uvw_AccountingLedger_Format]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_AccountingLedger_Format]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_AccountingLedger_Format]
As
	Select
		[Tb].*
		, ''Debit'' As [Tb_Format]
		, [Tb].Amount As [Debit_Amount]
		, Null As [Credit_Amount]
	From
		uvw_AccountingLedger As [Tb]
	Where
		IsNull(IsDebit,0) = 1

	Union All
	
	Select
		[Tb].*
		, ''Credit'' As [Tb_Format]
		, Null As [Debit_Amount]
		, [Tb].Amount As [Credit_Amount]
	From
		uvw_AccountingLedger As [Tb]
	Where
		IsNull(IsDebit,0) = 0
'
GO
/****** Object:  View [dbo].[uvw_AccountingChartOfAccounts_Cp]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_AccountingChartOfAccounts_Cp]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_AccountingChartOfAccounts_Cp]
As
	Select
		[Tb].*
	From
		uvw_AccountingChartOfAccounts_Parent As [Tb]
'
GO
/****** Object:  View [dbo].[uvw_AccountingBudget_Period]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_AccountingBudget_Period]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_AccountingBudget_Period]
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
				, udf_System_Lookup(''BudgetPeriod'') As [Lookup_Bp]
			) As [Tb]
			On [Tb].AccountingBudgetID = [Tbd].AccountingBudgetID
			And [Tb].System_LookupID_BudgetPeriod = [Tbd].System_LookupID_BudgetPeriod
'
GO
/****** Object:  View [dbo].[uvw_DocumentChartOfAccounts]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_DocumentChartOfAccounts]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_DocumentChartOfAccounts]
As
	Select
		[Tb].DocumentChartOfAccountsID
		, Sum([Tb].Amount) As [Amount]
	From
		uvw_DocumentChartOfAccounts_Details As [Tb]
	Group By
		[Tb].DocumentChartOfAccountsID
'
GO
/****** Object:  View [dbo].[uvw_CallLog]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_CallLog]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_CallLog]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseOrder]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchaseOrder]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionPurchaseOrder]
As
	Select
		[Tb].*
		, (
		Case [Tb].IsCancelled
			When 1 Then
				''Cancelled''
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					(
					Case [Tb].IsComplete
						When 1 Then
							''Complete''
						Else
							''Posted''
					End
					)
				Else 
					''Open''
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
				Left Join udf_Lookup(''PaymentTerm'') As [Lkp_PaymentTerm]
					On [Lkp_PaymentTerm].LookupID = [Tb].LookupID_PaymentTerm
				Left Join udf_Lookup(''DeliveryMethod'') As [Lkp_DeliveryMethod]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionDeliverOrder_DocumentItem_Desc]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionDeliverOrder_DocumentItem_Desc]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionDeliverOrder_DocumentItem_Desc]
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
'
GO
/****** Object:  View [dbo].[uvw_User_Rights]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_User_Rights]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_User_Rights]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionReceiveOrder_DocumentItem_Desc]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionReceiveOrder_DocumentItem_Desc]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionReceiveOrder_DocumentItem_Desc]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesOrder]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesOrder]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesOrder]
As
	Select
		[Tb].*
		, (
		Case [Tb].IsCancelled
			When 1 Then
				''Cancelled''
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					(
					Case [Tb].IsComplete
						When 1 Then
							''Complete''
						Else
							''Posted''
					End
					)
				Else 
					''Open''
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
						Left Join udf_Lookup(''PaymentTerm'') As [Lkp_PaymentTerm]
							On [Lkp_PaymentTerm].LookupID = [Tb].LookupID_PaymentTerm
						Left Join udf_Lookup(''DeliveryMethod'') As [Lkp_DeliveryMethod]
							On [Lkp_DeliveryMethod].LookupID = [Tb].LookupID_DeliveryMethod
						Left Join udf_Lookup(''ShipVia'') As [Lkp_ShipVia]
							On [Lkp_ShipVia].LookupID = [Tb].LookupID_ShipVia
						Left Join udf_Lookup(''Currency'') As [Lkp_Currency]
							On [Lkp_Currency].LookupID = [Tb].LookupID_Currency
						Left Join udf_Lookup(''OrderType'') As [Lkp_OrderType]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesInvoice_DocumentItem_Desc]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesInvoice_DocumentItem_Desc]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionSalesInvoice_DocumentItem_Desc]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionReceiveOrder_Amount]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionReceiveOrder_Amount]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionReceiveOrder_Amount]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseReturn_DocumentItem_Desc]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchaseReturn_DocumentItem_Desc]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionPurchaseReturn_DocumentItem_Desc]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionDeliverOrder]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionDeliverOrder]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionDeliverOrder]
As
	Select
		[Tb].*
		, (
		Case [Tb].IsCancelled
			When 1 Then
				''Cancelled''
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					(
					Case [Tb].IsInvoiced
						When 1 Then
							''Invoiced''
						Else
							''Posted''
					End
					)
				Else 
					''Open''
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionEmployeeExpense_Amount]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionEmployeeExpense_Amount]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionEmployeeExpense_Amount]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionEmployeeExpense_Balance]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionEmployeeExpense_Balance]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionEmployeeExpense_Balance]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseInvoice_ReceiveOrder]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchaseInvoice_ReceiveOrder]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionPurchaseInvoice_ReceiveOrder]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesInvoice_Amount]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesInvoice_Amount]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionSalesInvoice_Amount]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesReturn_DocumentItem_Desc]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesReturn_DocumentItem_Desc]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesReturn_DocumentItem_Desc]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesInvoice_Balance]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesInvoice_Balance]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesInvoice_Balance]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionEmployeeExpense_IsPaid]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionEmployeeExpense_IsPaid]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionEmployeeExpense_IsPaid]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseInvoice_Amount]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchaseInvoice_Amount]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionPurchaseInvoice_Amount]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionEmployeeExpense]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionEmployeeExpense]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionEmployeeExpense]
As
	Select
		[Tb].*
		, (
		Case [Tb].IsCancelled
			When 1 Then
				''Cancelled''
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					(
					Case [Tb].IsPaid
						When 1 Then
							''Paid''
						Else
							''Posted''
					End
					)
				Else 
					''Open''
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseInvoice_Balance]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchaseInvoice_Balance]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionPurchaseInvoice_Balance]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesInvoice_IsPaid]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesInvoice_IsPaid]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesInvoice_IsPaid]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesInvoice]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesInvoice]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesInvoice]
As
	Select
		[Tb].*
		, (
		Case [Tb].IsCancelled
			When 1 Then
				''Cancelled''
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					(
					Case [Tb].IsPaid
						When 1 Then
							''Paid''
						Else
							''Posted''
					End
					)
				Else 
					''Open''
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
			Left Join udf_Lookup(''PaymentTerm'') As [Lkp_PaymentTerm]
				On [Lkp_PaymentTerm].LookupID = [Tb].LookupID_PaymentTerm
			Left Join udf_Lookup(''InvoiceType'') As [Lkp_InvoiceType]
				On [Lkp_InvoiceType].LookupID = [Tb].LookupID_InvoiceType
			Left Join uvw_TransactionDeliverOrder As [Do]
				On [Do].TransactionDeliverOrderID = [Tb].TransactionDeliverOrderID
			Left Join uvw_TransactionSalesInvoice_Amount As [Sia]
				On [Sia].TransactionSalesInvoiceID = [Tb].TransactionSalesInvoiceID
			Left Join uvw_TransactionSalesInvoice_IsPaid As [Siip]
				On [Siip].TransactionSalesInvoiceID = [Tb].TransactionSalesInvoiceID
		) As [Tb]
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_EmployeeExpense_Amount]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchasePayment_EmployeeExpense_Amount]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionPurchasePayment_EmployeeExpense_Amount]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_EmployeeExpense]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchasePayment_EmployeeExpense]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionPurchasePayment_EmployeeExpense]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseInvoice_IsPaid]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchaseInvoice_IsPaid]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionPurchaseInvoice_IsPaid]
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
'
GO
/****** Object:  View [dbo].[uvw_Customer_SalesInvoice]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_Customer_SalesInvoice]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_Customer_SalesInvoice]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseInvoice]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchaseInvoice]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionPurchaseInvoice]
As
	Select
		[Tb].*
		, (
		Case [Tb].IsCancelled
			When 1 Then
				''Cancelled''
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					(
					Case [Tb].IsPaid
						When 1 Then
							''Paid''
						Else
							''Posted''
					End
					)
				Else 
					''Open''
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesReturn]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesReturn]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesReturn]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesPayment_SalesInvoice_Amount]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesPayment_SalesInvoice_Amount]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesPayment_SalesInvoice_Amount]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionReceiveOrder_IsPaid]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionReceiveOrder_IsPaid]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionReceiveOrder_IsPaid]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionReceiveOrder]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionReceiveOrder]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionReceiveOrder]
As
	Select
		[Tb].*
		, (
		Case [Tb].IsCancelled
			When 1 Then
				''Cancelled''
			Else
			(
			Case [Tb].IsPosted
				When 1 Then 
					(
					Case [Tb].IsInvoiced
						When 1 Then
							''Invoiced''
						Else
						(
						Case [Tb].IsPaid
							When 1 Then
								''Paid''
							Else
								''Posted''
						End
						)
					End
					)
				Else 
					''Open''
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_PurchaseInvoice_Amount]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchasePayment_PurchaseInvoice_Amount]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionPurchasePayment_PurchaseInvoice_Amount]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_PurchaseInvoice]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchasePayment_PurchaseInvoice]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionPurchasePayment_PurchaseInvoice]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesPayment]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesPayment]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesPayment]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionSalesPayment_SalesInvoice]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionSalesPayment_SalesInvoice]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionSalesPayment_SalesInvoice]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchaseReturn]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchaseReturn]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionPurchaseReturn]
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
'
GO
/****** Object:  View [dbo].[uvw_CreditNotes]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_CreditNotes]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_CreditNotes]
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
			Inner Join udf_System_Lookup(''CreditNoteSourceType'') As [Lkp_Cnst]
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
			Inner Join udf_System_Lookup(''CreditNoteSourceType'') As [Lkp_Cnst]
				On [Lkp_Cnst].System_LookupID = 2
		Where
			IsNull([Tb].IsPosted,0) = 1
			And IsNull([Tb].IsCancelled,0) = 0
		) As [Tb]
		Left Join uvw_Customer As [C]
			On [C].CustomerID = [Tb].CustomerID
'
GO
/****** Object:  View [dbo].[uvw_CreditNotes_Balance]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_CreditNotes_Balance]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_CreditNotes_Balance]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_Amount]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchasePayment_CreditNotes_Amount]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_Amount]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_SalesReturn_Amount]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchasePayment_CreditNotes_SalesReturn_Amount]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_SalesReturn_Amount]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_SalesPayment_Amount]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchasePayment_CreditNotes_SalesPayment_Amount]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_SalesPayment_Amount]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_CreditNoteSourceType_Amount]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchasePayment_CreditNotes_CreditNoteSourceType_Amount]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionPurchasePayment_CreditNotes_CreditNoteSourceType_Amount]
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
'
GO
/****** Object:  View [dbo].[uvw_CreditNotes_IsPaid]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_CreditNotes_IsPaid]'))
EXEC dbo.sp_executesql @statement = N'Create View [dbo].[uvw_CreditNotes_IsPaid]
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
'
GO
/****** Object:  View [dbo].[uvw_CreditNotes_Cp]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_CreditNotes_Cp]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_CreditNotes_Cp]
As
	Select
		[Tb].*
		, [Lkp_Cnst].[Desc] As [CreditNoteSourceType_Desc]
		, Row_Number() Over (Order By (Select 0)) As [ID]
		, (
		Case [Tb].IsPaid
			When 1 Then
				''Refunded''
			Else
				''Open''
		End
		) As [Status]
	From
		uvw_CreditNotes_IsPaid As [Tb]
		Left Join udf_System_Lookup(''CreditNoteSourceType'') As [Lkp_Cnst]
			On [Lkp_Cnst].System_LookupID = [Tb].System_LookupID_CreditNoteSourceType
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_Cp]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchasePayment_Cp]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionPurchasePayment_Cp]
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
'
GO
/****** Object:  View [dbo].[uvw_TransactionPurchasePayment_CreditNotes]    Script Date: 10/21/2013 12:04:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchasePayment_CreditNotes]'))
EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[uvw_TransactionPurchasePayment_CreditNotes]
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
'
GO
