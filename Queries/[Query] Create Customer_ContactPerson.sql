/*
[Query] Create Customer_ContactPerson
*/

Set NoCount On
Go

Declare Cr Cursor Fast_Forward
For
Select
	CustomerID
From
	Customer

Declare @CustomerID As BigInt

Open Cr
Fetch Next From Cr
Into @CustomerID

While @@Fetch_Status = 0
Begin
	
	Declare @ContactPersonID As BigInt
	Set @ContactPersonID = Null
	Declare @Tb_ContactPerson As Table (ID BigInt)
	Delete From @Tb_ContactPerson
	
	Insert Into ContactPerson 
	Output Inserted.ContactPersonID
	Into @Tb_ContactPerson
	Default Values
	
	Select @ContactPersonID = Max([Tb].ID)
	From @Tb_ContactPerson As [Tb]
	
	Declare @Limit As BigInt
	Set @Limit = 100
	
	Declare @Ct As BigInt
	Set @Ct = 1
	
	While @Ct <= @Limit
	Begin
		Declare @Ct_String As VarChar(30)
		Set @Ct_String = Cast(@Ct As VarChar(30))
		
		Declare @CustomerID_String As VarChar(30)
		Set @CustomerID_String = Cast(@CustomerID As VarChar(30))
		
		Declare @PersonID As BigInt
		Set @PersonID = Null
		Declare @Tb_Person As Table (ID BigInt)
		Delete From @Tb_Person
		
		Insert Into Person 
			(
			FirstName
			, LastName
			, MiddleName
			)
		Output Inserted.PersonID
		Into @Tb_Person
		Values 
			(
			'CP_' + @CustomerID_String + '_FN_' + @Ct_String
			, 'CP_' + @CustomerID_String + '_LN_' + @Ct_String
			, 'CP_' + @CustomerID_String + '_MN_' + @Ct_String
			)
		
		Select @PersonID = Max([Tb].ID)
		From @Tb_Person As [Tb]
		
		--[-]
		
		Insert Into ContactPerson_Details
			(ContactPersonID, PersonID, Position)
		Values
			(@ContactPersonID, @PersonID, 'Position_' + @Ct_String)
		
		Update Customer 
		Set ContactPersonID = @ContactPersonID
		Where CustomerID = @CustomerID
		
		Set @Ct = @Ct + 1
	End
	
	Fetch Next From Cr
	Into @CustomerID
End

Close Cr
Deallocate Cr
