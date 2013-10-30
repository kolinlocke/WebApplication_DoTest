/*
[Query] Update Cache
*/

Declare @TableName As VarChar(1000)
Declare @TableName_Source As VarChar(1000)
Declare @TableName_Cache As VarChar(1000)
Declare @TableName_KeyName As VarChar(1000)

Select
	@TableName = 'ContactPerson_Details'
	, @TableName_Source = 'uvw_ContactPerson_Details'
	, @TableName_Cache = 'Materialized_ContactPerson_Details'
	, @TableName_KeyName = 'ContactPerson_DetailsID'

--[-]

Declare @Limit As BigInt
Set @Limit = Cast(dbo.udf_DataObjects_Parameter_Get('CacheUpdateLimit') As BigInt)

Declare @CacheDatabase As VarChar(1000)
Set @CacheDatabase = dbo.udf_DataObjects_Parameter_Get('CacheDatabase')

Declare @Query_Execute As VarChar(Max)
Set @Query_Execute = 
	'
	Delete From [' + @CacheDatabase + '].[dbo].[' + @TableName_Cache + ']
	From	
		#Tmp As [Src]
		Inner Join [' + @CacheDatabase + '].[dbo].[' + @TableName_Cache + '] As [Trg]
			On [Trg].[' + @TableName_KeyName + '] = [Src].[ID]

	Declare @Query As VarChar(Max)
	Declare @Query_Condition As VarChar(Max)
	Declare @Query_ID As VarChar(Max)
	Declare @Query_Comma As VarChar(1)	
	Declare @IsStart As Bit

	Declare @Limit As BigInt
	Declare @Ct As BigInt
	Declare @Total_Ct As BigInt

	Set @Limit  = ' + Cast(@Limit As VarChar(30)) + '

	Set @Total_Ct = 0
	Select @Total_Ct = Count(1)
	From #Tmp

	Declare Cr Cursor Fast_Forward
	For
	Select [ID]
	From #Tmp

	Open Cr

	Declare @ID As BigInt

	Fetch Next From Cr
	Into @ID
	
	Select
		@Ct = 0
		, @IsStart = 0
		, @Query = '''' 
		, @Query_ID = ''''
		, @Query_Comma = ''''
	
	While @@Fetch_Status = 0
	Begin
		Set @Ct = @Ct  + 1
		Set @Total_Ct = @Total_Ct - 1
		Set @Query_ID = @Query_ID + @Query_Comma + Cast(@ID As VarChar(30))
		
		If @IsStart = 0
		Begin
			Set @IsStart  = 1
			Set @Query_Comma = '',''
		End
		
		If @Ct >= @Limit Or @Total_Ct <= 0
		Begin
			Set @Query_Condition =
			''
			And ([' + @TableName_KeyName + '] In ('' + @Query_ID + ''))
			''
			
			Set @Query =
				''
				Insert Into [' + @CacheDatabase + '].[dbo].[' + @TableName_Cache + ']
				Select 
					[Tb].*
				From 
					[' + @TableName_Source + '] As [Tb]
				Where
					1 = 1
					'' + @Query_Condition + ''
				''
			Exec(@Query)
			
			Select
				@Ct = 0
				, @IsStart = 0
				, @Query = '''' 
				, @Query_ID = ''''
				, @Query_Comma = ''''
		End
		
		Fetch Next From Cr
		Into @ID
	End
	
	Close Cr
	Deallocate Cr
	'
	
Declare @Query As NVarChar(Max)
Set @Query  = 
	'
	Select ID
	Into #Tmp
	From [dbo].[udf_System_TableUpdateBatch](''' + @TableName + ''')
	
	Delete From System_TableUpdateBatch_Details
	From
		System_TableUpdateBatch_Details As [Tbd]
		Inner Join System_TableUpdateBatch As [Tb]
			On [Tb].System_TableUpdateBatchID = [Tbd].System_TableUpdateBatchID
	Where
		[Tb].TableName = ''' + @TableName +  '''
	
	If Not Exists(Select * From #Tmp)
	Begin
		Return
	End
	
	Declare @Query As VarChar(Max)
	Set @Query = @Param_Query_Execute
	Exec(@Query)
	'	

Declare @Query_Parameters As NVarChar(Max)
Set @Query_Parameters = N'@Param_Query_Execute VarChar(Max)'
	
Exec Sp_ExecuteSql 
	@Query
	, @Query_Parameters
	, @Param_Query_Execute = @Query_Execute