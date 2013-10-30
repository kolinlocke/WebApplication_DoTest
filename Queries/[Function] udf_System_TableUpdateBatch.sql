Create Function [dbo].[udf_System_TableUpdateBatch]
(@TableName As VarChar(1000))
Returns Table
As
Return
(
	Select [Tbd].ID
	From 
		System_TableUpdateBatch As [Tb]
		Left Join System_TableUpdateBatch_Details As [Tbd]
			On [Tbd].System_TableUpdateBatchID = [Tb].System_TableUpdateBatchID
	Where
		[Tb].TableName = @TableName
)