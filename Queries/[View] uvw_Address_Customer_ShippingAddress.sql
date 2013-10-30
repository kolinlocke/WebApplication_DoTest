Create View [dbo].[uvw_Address_Customer_ShippingAddress]
As
	Select 
		[Tb].* 
		, [Csa].CustomerID
	From 
		uvw_Address As [Tb]
		Left Join Customer_ShippingAddress As [Csa]
			On [Csa].AddressID = [Tb].AddressID
GO


