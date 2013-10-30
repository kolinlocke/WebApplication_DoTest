/*
[Query] Create Customers
*/

Declare @Limit As BigInt
Set @Limit = 100000
--[-]

Declare @Ct As BigInt
Set @Ct = 1
While @Ct <= @Limit
Begin
	
	Declare @Ct_String As VarChar(30)
	Set @Ct_String = Cast(@Ct As VarChar(30))
	
	Declare @RowPropertyID As BigInt
	Set @RowPropertyID = Null
	Declare @Tb_Rp As Table (ID BigInt)
	Delete From @Tb_Rp
	
	Insert Into RowProperty (Code, Name)
	Output Inserted.RowPropertyID
	Into @Tb_Rp
	Values ('CustomerCode_' + @Ct_String,'CustomerName_' + @Ct_String)
	
	Select @RowPropertyID = Max([Tb].ID)
	From @Tb_Rp As [Tb]
	
	--[-]
	
	Declare @AddressID As BigInt
	Set @AddressID = Null
	Declare @Tb_Address As Table (ID BigInt)
	Delete From @Tb_Address
	
	Insert Into Address (Address, City, ZipCode)
	Output Inserted.AddressID
	Into @Tb_Address
	Values ('Address_' + @Ct_String, 'City_' + @Ct_String, 'ZipCode_' + @Ct_String)
	
	Select @AddressID = Max([Tb].ID)
	From @Tb_Address As [Tb]
	
	--[-]
	
	Declare @PartyID As BigInt
	Set @PartyID = Null
	Declare @Tb_Party As Table (ID BigInt)
	Delete From @Tb_Party
	
	Insert Into Party (RowPropertyID, AddressID, System_LookupID_PartyType, IsPerson)
	Output Inserted.PartyID
	Into @Tb_Party
	Values (@RowPropertyID, @AddressID, 2, 1)
	
	Select @PartyID = Max([Tb].ID)
	From @Tb_Party As [Tb]
	
	--[-]
	
	Declare @PersonID As BigInt
	Set @PersonID = Null
	Declare @Tb_Person As Table (ID BigInt)
	Delete From @Tb_Person
	
	Insert Into Person (FirstName, LastName, MiddleName)
	Output Inserted.PersonID
	Into @Tb_Person
	Values ('FN_' + @Ct_String, 'LN_' + @Ct_String, 'MN_' + @Ct_String)
	
	Select @PersonID = Max([Tb].ID)
	From @Tb_Person As [Tb]
	
	--[-]
	
	Insert Into Customer (PartyID, PersonID)
	Values (@PartyID, @PersonID)
	
	--[-]
	
	Set @Ct = @Ct + 1
End
