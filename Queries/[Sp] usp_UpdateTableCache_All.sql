Create Procedure [dbo].[usp_UpdateTableCache_All]
As
Begin
	Set NoCount On

	Declare Cur Cursor Fast_Forward
	For
	Select 
		TableName
		, TableName_Source
		, TableName_Cache
		, TableName_KeyName
	From 
		System_TableUpdateBatch

	Declare @TableName As VarChar(1000)
	Declare @TableName_Source As Varchar(1000)
	Declare @TableName_Cache As VarChar(1000)
	Declare @TableName_KeyName As VarChar(1000)

	Open Cur
	Fetch Next From Cur
	Into
		@TableName
		, @TableName_Source
		, @TableName_Cache
		, @TableName_KeyName

	While @@Fetch_Status = 0
	Begin
		Exec usp_UpdateTableCache
			@TableName
			, @TableName_Source
			, @TableName_Cache
			, @TableName_KeyName
		
		Fetch Next From Cur
		Into
			@TableName
			, @TableName_Source
			, @TableName_Cache
			, @TableName_KeyName
	End

	Close Cur
	Deallocate Cur
End
