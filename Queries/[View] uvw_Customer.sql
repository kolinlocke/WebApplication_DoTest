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


