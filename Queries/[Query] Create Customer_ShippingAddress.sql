/*
[Query] Create Customer_ShippingAddress
*/

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
		
		Insert Into Customer_ShippingAddress
			(CustomerID, AddressID, StoreCode)
		Values
			(@CustomerID, @AddressID, 'SC_' + @CustomerID_String + '_' + @Ct_String)
		
		--[-]
		
		Set @Ct = @Ct + 1
	End
	
	Fetch Next From Cr
	Into @CustomerID
End

Close Cr
Deallocate Cr
