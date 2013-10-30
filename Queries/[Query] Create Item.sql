/*
[Query] Create Item
*/

Declare @Limit As BigInt
Set @Limit = 1000000

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
	Values ('ItemCode_' + @Ct_String,'ItemName_' + @Ct_String)
	
	Select @RowPropertyID = Max([Tb].ID)
	From @Tb_Rp As [Tb]
	
	--[-]
	
	Insert Into Item (RowPropertyID)
	Values (@RowPropertyID)
	
	--[-]
	
	Set @Ct = @Ct + 1
End
