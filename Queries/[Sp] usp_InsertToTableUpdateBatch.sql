Create Procedure [dbo].[usp_InsertToTableUpdateBatch]
@TableUpdateBatchID As BigInt
, @ID As BigInt
As
Begin
	
	If Not Exists(
		Select * 
		From System_TableUpdateBatch_Details 
		Where System_TableUpdateBatchID = @TableUpdateBatchID And ID = @ID)
	Begin
		Insert System_TableUpdateBatch_Details (System_TableUpdateBatchID, ID)
		Values (@TableUpdateBatchID, @ID)
	End
	
End
