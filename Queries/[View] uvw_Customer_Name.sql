CREATE View [dbo].[uvw_Customer_Name]
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

GO


