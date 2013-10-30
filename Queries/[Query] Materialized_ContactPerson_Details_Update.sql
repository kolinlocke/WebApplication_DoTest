/*
[Query] Materialized_ContactPerson_Details_Update
*/

Select *
Into #Tmp
From Temp_ContactPerson_Details_UpdateBatch

Truncate Table Temp_ContactPerson_Details_UpdateBatch

If Not Exists(Select * From #Tmp)
Begin
	Return 0
End

Declare @CacheDatabase As VarChar(1000)
Set @CacheDatabase = dbo.udf_Get_System_Parameter('CacheDatabase')

Declare @Limit As BigInt
Set @Limit = 1000

Declare @Query As VarChar(Max)
Set @Query = 
	'
	Delete From [' + @CacheDatabase + '].[dbo].[Materialized_ContactPerson_Details]
	From	
		#Tmp As [Src]
		Inner Join [' + @CacheDatabase + '].[dbo].[Materialized_ContactPerson_Details] As [Trg]
			On [Trg].ContactPerson_DetailsID = [Src].ContactPerson_DetailsID

	Declare @Query As VarChar(Max)
	Declare @Query_Condition As VarChar(Max)
	Declare @Query_ContactPerson_DetailsID As VarChar(Max)
	Declare @Query_Comma As VarChar(1)	
	Declare @IsStart As Bit

	Declare @Limit As BigInt
	Declare @Ct As BigInt
	Declare @Total_Ct As BigInt

	Set @Limit  = ' + Cast(@Limit As VarChar(30)) + '

	Set @Total_Ct = 0
	Select @Total_Ct = Count(1)
	From ContactPerson_Details	

	Declare Cr Cursor Fast_Forward
	For
	Select ContactPerson_DetailsID
	From ContactPerson_Details

	Open Cr

	Declare @ContactPerson_DetailsID As BigInt

	Fetch Next From Cr
	Into @ContactPerson_DetailsID
	
	Select
		@Ct = 0
		, @IsStart = 0
		, @Query = '''' 
		, @Query_ContactPerson_DetailsID = ''''
		, @Query_Comma = ''''
	
	While @@Fetch_Status = 0
	Begin
		Set @Ct = @Ct  + 1
		Set @Total_Ct = @Total_Ct - 1
		Set @Query_ContactPerson_DetailsID = @Query_ContactPerson_DetailsID + @Query_Comma + Cast(@ContactPerson_DetailsID As VarChar(30))
		
		If @IsStart = 0
		Begin
			Set @IsStart  = 1
			Set @Query_Comma = '',''
		End
		
		If @Ct >= @Limit Or @Total_Ct <= 0
		Begin
			Set @Query_Condition =
			''
			And (ContactPerson_DetailsID In '' + @Query_ContactPerson_DetailsID + '')
			''
			
			Set @Query =
				''
				Insert Into [' + @CacheDatabase + '].[dbo].[Materialized_ContactPerson_Details]
				Select 
					[Tb].*
				From 
					uvw_ContactPerson_Details As [Tb]
				Where
					1 = 1
					'' + @Query_Condition + ''
				''
			Exec(@Query)
			
			Select
				@Ct = 0
				, @IsStart = 0
				, @Query = '''' 
				, @Query_ContactPerson_DetailsID = ''''
				, @Query_Comma = ''''
		End
		
		Fetch Next From Cr
		Into @ContactPerson_DetailsID
	End
	
	Close Cr
	Deallocate Cr
	'
	
Exec(@Query)