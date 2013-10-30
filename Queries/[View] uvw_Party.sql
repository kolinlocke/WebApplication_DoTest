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


