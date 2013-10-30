CREATE View [dbo].[uvw_Employee_Name]
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

GO


