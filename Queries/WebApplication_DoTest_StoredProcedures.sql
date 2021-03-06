USE [WebApplication_DoTest]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetSeriesNo]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetSeriesNo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
[Author] Kolin Locke
[Date Created] 2010.05.16.1043
[Description] 
	Generates New Series No. 
	Does not include missing series nos.
*/

Create Procedure [dbo].[usp_GetSeriesNo]
@TableName As VarChar(Max)
, @FieldName As VarChar(Max)
, @Prefix As VarChar(Max)
, @Digits As Int
As	
Begin
	Declare @SqlQuery As VarChar(Max)
	Declare @SqlQuery_Derived As VarChar(Max)
	Declare @SqlQuery_Like As VarChar(Max)

	Set @SqlQuery_Like = ''''

	Declare @Ct As Int
	Set @Ct = 0

	While @Ct < Len(@Prefix)
	Begin
		Set @SqlQuery_Like = @SqlQuery_Like + ''['' + Substring(@Prefix,@Ct + 1,1) + '']''
		Set @Ct = @Ct + 1
	End

	Set @SqlQuery_Like = @SqlQuery_Like + ''[-]''
	Set @SqlQuery_Like = @SqlQuery_Like + Replicate(''[0-9]'',@Digits)

	Set @SqlQuery_Derived =
		''
		Select
			Cast(Substring('' + @FieldName + '', CharIndex('''''' + @Prefix + ''-'''', '' + @FieldName + '') + '' + Cast(Len(@Prefix) + 1 As VarChar)  + '', Len('' + @FieldName + '')) As BigInt) As [Series]
		From
			'' + @TableName + ''
		Where
			'' + @FieldName + '' Like '''''' + @SqlQuery_Like + ''''''
		''
	Set @SqlQuery =
		''
		Declare @Prefix As VarChar(Max)
		Declare @Digits As Int
		
		Select
			@Prefix = '''''' + @Prefix + ''''''
			, @Digits = '' + Cast(@Digits As VarChar) + ''
		
		Declare @Series As BigInt
		Set @Series = 1
		
		Select			
			@Series = Tb.Series			
		From
			(
			Select
				(IsNull(Max(Tb.Series),0) + 1) As [Series]
			From
				('' + @SqlQuery_Derived + '') As [Tb]
			) As [Tb]
		
		Declare @Return_SeriesNo As VarChar(Max)
		Set @Return_SeriesNo = @Prefix + ''''-'''' + dbo.udf_TextFiller(Cast(@Series As VarChar),''''0'''',@Digits)
		Select @Return_SeriesNo As [Return_SeriesNo]	
		''
	
	Exec(@SqlQuery)
	
	Return 0
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Rights_Details_Load]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Rights_Details_Load]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[usp_Rights_Details_Load]
@ID As BigInt = 0
As
Begin
	Declare @Condition VarChar(Max)
	If @ID = 0
	Begin
		Set @Condition = ''1 = 0''
	End
	Else
	Begin
		Set @Condition = ''RightsID = '' + Cast(@ID As VarChar(50))
	End
	
	Declare @Query VarChar(Max)
	Set @Query =
		''		
		Select
			[Tb].Rights_DetailsID
			, [Tb].RightsID
			, [Tb].IsAllowed
			, [Sma].System_ModulesID
			, [Sma].System_Modules_AccessLibID
			, [Sma].System_Modules_Name
			, [Sma].System_Modules_Code
			, [Sma].System_Modules_AccessID
			, [Sma].Parent_System_Modules_Name
			, [Sma].Parent_System_ModulesID
			, [Sma].[Desc] As [System_Modules_Access_Desc]
		From
			(
			Select *
			From Rights_Details
			Where '' + @Condition + ''
			) As [Tb]
			Right Join [uvw_System_Modules_Access] As [Sma]
				On [Sma].System_Modules_AccessID = [Tb].System_Modules_AccessID
		''
		Exec(@Query)

End
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_TextFiller]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_TextFiller]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
--	Author:		
--		Kolin Locke
--	Create date: 	
--		2010.02.25.0051
--	Description:	
--		[???]
-- =============================================
CREATE FUNCTION [dbo].[udf_TextFiller]
(
@TextInput As VarChar(8000),
@Filler As VarChar(1),
@TextLength Int
)
RETURNS VarChar(8000)
AS
BEGIN
	Declare @ReturnValue VarChar(8000)
	Set @ReturnValue = Right(Replicate(@Filler,@TextLength) + Ltrim(Left(IsNull(@TextInput,''''),@TextLength)),@TextLength) 
	Return @ReturnValue
	
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_DataObjects_GetTableDef]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_DataObjects_GetTableDef]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[udf_DataObjects_GetTableDef]
(@TableName VarChar(Max))	
Returns Table
As
Return
	(
	Select
		sCol.Column_id
		, sCol.Name As [ColumnName]
		, sTyp.Name As [DataType]
		, sCol.max_length As [Length]
		, sCol.Precision
		, sCol.Scale
		, sCol.Is_Identity As [IsIdentity]
		, Cast
		(
			(
			Case Count(IsCcu.Column_Name)
				When 0 Then 0
				Else 1
			End
			) 
		As Bit) As IsPk
	From 
		Sys.Columns As sCol
		Left Join Sys.Types As sTyp
			On sCol.system_type_id = sTyp.system_type_id
			And [sCol].User_Type_ID = [sTyp].User_Type_ID
		Inner Join Sys.Tables As sTab
			On sCol.Object_ID = sTab.Object_ID
		Inner Join Sys.Schemas As sSch
			On sSch.Schema_ID = sTab.Schema_ID
		Left Join Sys.Key_Constraints As Skc
			On sTab.Object_Id = Skc.Parent_Object_Id
			And Skc.Type = ''PK''
		Left Join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE As IsCcu
			On Skc.Name = IsCcu.Constraint_Name
			And sTab.Name = IsCcu.Table_Name
			And sCol.Name = IsCcu.Column_Name
	Where
		sSch.Name + ''.'' + sTab.Name = @TableName
		And sCol.Is_Computed = 0
	Group By
		sCol.Name
		, sTyp.Name
		, sCol.max_length
		, sCol.Precision
		, sCol.Scale
		, sCol.Is_Identity
		, sCol.Column_id
	)


' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_ConvertDate]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_ConvertDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Kolin Locke
-- Create date: 	09.18.2007
-- Description:	[???]
-- =============================================
CREATE FUNCTION [dbo].[udf_ConvertDate]
(
@DateInput DateTime	
	
)
RETURNS DateTime
AS
BEGIN
	Declare @DateOutput DateTime
	
	Set @DateOutput = (Convert(DateTime,(Cast(DatePart(yyyy,@DateInput) as VarChar)
			+ ''-'' + 
			Cast(DatePart(mm,@DateInput) as VarChar)
			+ ''-'' + 
			Cast(DatePart(dd,@DateInput) as VarChar)),102))
	Return @DateOutput
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_GetTableDef]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_GetTableDef]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE Function [dbo].[udf_GetTableDef]
(
	@TableName VarChar(Max)
)	
Returns Table
As
Return
	(
	Select
		sCol.Column_id
		, sCol.Name As [ColumnName]
		, sTyp.Name As [DataType]
		, sCol.max_length As [Length]
		, sCol.Precision
		, sCol.Scale
		, sCol.Is_Identity As [IsIdentity]
		, Cast
		(
			(
			Case Count(IsCcu.Column_Name)
				When 0 Then 0
				Else 1
			End
			) 
		As Bit) As IsPk
	From 
		Sys.Columns As sCol
		Left Join Sys.Types As sTyp
			On sCol.system_type_id = sTyp.system_type_id
			And [sCol].User_Type_ID = [sTyp].User_Type_ID
		Inner Join Sys.Tables As sTab
			On sCol.Object_ID = sTab.Object_ID
		Inner Join Sys.Schemas As sSch
			On sSch.Schema_ID = sTab.Schema_ID
		Left Join Sys.Key_Constraints As Skc
			On sTab.Object_Id = Skc.Parent_Object_Id
			And Skc.Type = ''PK''
		Left Join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE As IsCcu
			On Skc.Name = IsCcu.Constraint_Name
			And sTab.Name = IsCcu.Table_Name
			And sCol.Name = IsCcu.Column_Name
	Where
		sSch.Name + ''.'' + sTab.Name = @TableName
		And sCol.Is_Computed = 0
	Group By
		sCol.Name
		, sTyp.Name
		, sCol.max_length
		, sCol.Precision
		, sCol.Scale
		, sCol.Is_Identity
		, sCol.Column_id
	)
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_User_Rights_Load]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_User_Rights_Load]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[usp_User_Rights_Load]
@ID As BigInt = 0
As
Begin
	Declare @Condition VarChar(Max)
	If @ID = 0
	Begin
		Set @Condition = ''1 = 0''
	End
	Else
	Begin
		Set @Condition = ''UserID = '' + Cast(@ID As VarChar(50))
	End
	
	Declare @Query VarChar(Max)
	Set @Query =
		''		
		Select
			[Tb].User_RightsID
			, [Tb].UserID
			, [Tb].IsActive
			, [R].RightsID
			, [R].Name As [RightsName]
			, [R].Remarks As [RightsDesc]
		From
			(
			Select *
			From User_Rights
			Where '' + @Condition + ''
			) As [Tb]
			Right Join [uvw_Rights] As [R]
				On [R].RightsID = [Tb].RightsID
		''
		Exec(@Query)

End
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Get_System_Parameter]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_Get_System_Parameter]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[udf_Get_System_Parameter]
(
@ParameterName VarChar(Max)
)
Returns VarChar(Max)
As
Begin
	Declare @ParameterValue As VarChar(Max)		
	Set @ParameterValue = ''''
	
	Declare @Ct As Int	
	Select @Ct = Count(1)
	From System_Parameters
	Where ParameterName = @ParameterName
	
	If @Ct = 0
	Begin
		Return ''''
	End
	Else
	Begin
		Select @ParameterValue = ParameterValue
		From System_Parameters
		Where ParameterName = @ParameterName
	End
	
	Return @ParameterValue
End
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_DataObjects_Parameter_Get]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_DataObjects_Parameter_Get]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[udf_DataObjects_Parameter_Get]
(@ParameterName VarChar(Max))
Returns VarChar(Max)
As
Begin
	Declare @ParameterValue As VarChar(Max)		
	Set @ParameterValue = ''''
	
	Declare @Ct As Int	
	Select @Ct = Count(1)
	From DataObjects_Parameters
	Where ParameterName = @ParameterName
	
	If @Ct = 0
	Begin
		Return ''''
	End
	Else
	Begin
		Select @ParameterValue = ParameterValue
		From DataObjects_Parameters
		Where ParameterName = @ParameterName
	End
	
	Return @ParameterValue
End

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_System_BindDefinition]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_System_BindDefinition]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE Function [dbo].[udf_System_BindDefinition]
(
	@Name VarChar(Max)
)	
Returns Table
As
Return
	(
	Select 
		[Tbd].*
	From 
		System_BindDefinition_Field As [Tbd]
		Inner Join System_BindDefinition As [Tb]
			On [Tb].System_BindDefinitionID = [Tbd].System_BindDefinitionID
	Where
		[Tb].Name = @Name
	)
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_System_TableUpdateBatch]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_System_TableUpdateBatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[udf_System_TableUpdateBatch]
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
)' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Require_System_Parameter]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Require_System_Parameter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Proc [dbo].[usp_Require_System_Parameter]
@ParameterName VarChar(Max)
, @ParameterValue VarChar(Max)
As
Begin
	Declare @Ct As Int	
	Select @Ct = Count(1)
	From System_Parameters
	Where ParameterName = @ParameterName
	
	If @Ct = 0
	Begin
		Insert Into System_Parameters (ParameterName, ParameterValue) Values (@ParameterName, @ParameterValue)
	End
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetNextID]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetNextID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
--	Author:			
--		Kolin Locke
--	Create date:	
--		2009.06.20.2217
--	Description:	
--		Returns New ID and Updates System_Series
-- =============================================

Create Procedure [dbo].[usp_GetNextID]
@TableName VarChar(Max)
As
Begin
	Declare @LastID BigInt
	Declare @Ct Int

	Select
		@Ct = Count(*)
	From
		System_Series
	Where
		TableName = @TableName
		
	If @Ct = 0
	Begin
		Insert Into System_Series (TableName, LastID) Values (@TableName, 0)
	End

	Select
		@LastID = LastID
	From
		System_Series
	Where
		TableName = @TableName
		
	Set @LastID = @LastID + 1
		
	Update System_Series 
	Set LastID = @LastID 
	Where TableName = @TableName
	
	Select @LastID As [ID]
	
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_System_CheckLogin]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_System_CheckLogin]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[usp_System_CheckLogin]
@UserID As BigInt
, @SessionID As VarChar(50)
As
Begin
	Declare @Ct As BigInt
	Select @Ct = Count(1)
	From System_UserLogin
	Where
		UserID = @UserID
		And SessionID = @SessionID

	Declare @Return As Bit	
	Set @Return = 1

	If @Ct = 0
	Begin
		Set @Return = 0
	End

	Select @Return As [Value]
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Set_System_Parameter]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Set_System_Parameter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[usp_Set_System_Parameter]
@ParameterName VarChar(Max)
, @ParameterValue VarChar(Max)
As
Begin
	Declare @Ct As Int	
	Select @Ct = Count(1)
	From System_Parameters
	Where ParameterName = @ParameterName
	
	If @Ct = 0
	Begin
		Insert Into System_Parameters (ParameterName, ParameterValue) Values (@ParameterName, @ParameterValue)
	End
	Else
	Begin
		Update System_Parameters Set ParameterValue = @ParameterValue Where ParameterName = @ParameterName
	End
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertToTableUpdateBatch]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_InsertToTableUpdateBatch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[usp_InsertToTableUpdateBatch]
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
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetTableDef]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetTableDef]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[usp_GetTableDef]
@TableName VarChar(Max)
, @SchemaName VarChar(Max) = ''''
As
Set NOCOUNT On
Begin
	
	If IsNull(@SchemaName, '''') = ''''
	Begin
		Set @SchemaName = ''dbo''
	End
	
	Select *
	From [udf_GetTableDef](@SchemaName + ''.'' + @TableName)
	Order By Column_Id
	
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_System_Series_Updater]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_System_Series_Updater]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[usp_System_Series_Updater]
As
Begin
	
	Create Table #Tmp_List 
	(
		TableName VarChar(1000) Collate Database_Default
		, ID BigInt
		, Last_ID BigInt
	)

	Declare @TableName As VarChar(1000)
	Declare @ColumnName As VarChar(1000)
	Declare @Query As VarChar(Max)

	Declare Cur Cursor Read_Only Forward_Only
	For
	Select 
		[St].Name As [TableName]
	From
		(
		Select * 
		From Sys.Tables
		) As [St]

	Open Cur

	Fetch Next From Cur
	Into @TableName

	While @@Fetch_Status = 0
	Begin
		Declare Cur_Columns Cursor Read_Only Forward_Only
		For
		Select ColumnName
		From udf_GetTableDef(@TableName)
		Where 
			IsPk = 1 
			And IsIdentity = 0
		
		Open Cur_Columns
		
		Fetch Next From Cur_Columns
		Into @ColumnName
		
		While @@Fetch_Status = 0
		Begin
			
			Set @Query =
			''
			Insert 
			Into #Tmp_List 
			(TableName, ID, Last_ID)
			Select
				'''''' + @TableName + ''.'' + @ColumnName + '''''' As [TableName],
				IsNull(Max('' + @ColumnName + ''),0) As ID,
				IsNull(Max('' + @ColumnName + ''),0) As [Last_ID]
			From
				['' + @TableName + '']
			''
			Exec(@Query)
			
			Fetch Next From Cur_Columns
			Into @ColumnName
		End
		
		Close Cur_Columns
		Deallocate Cur_Columns
		
		Fetch Next From Cur
		Into @TableName

	End

	Close Cur
	Deallocate Cur

	Select * 
	From #Tmp_List
	Order By TableName

	
	Insert Into System_Series
	(
		TableName, 
		LastID
	)
	Select 
		TableName,
		Last_ID
	From
		#Tmp_List As [Source]
	Where
		Source.[TableName] Not In 
		(
		Select
			TableName
		From
			System_Series
		)
		
	Update System_Series
	Set
		LastID = [Source].Last_ID
	From
		#Tmp_list As [Source],
		System_Series As [Target]
	Where
		[Source].TableName = [Target].TableName
	

	Drop Table #Tmp_List

	
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_System_NewLogin]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_System_NewLogin]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[usp_System_NewLogin]
@UserID As BigInt
, @SessionID As VarChar(50)
As
Begin
	If Not Exists
		(
		Select 1
		From System_UserLogin
		Where UserID = @UserID
		)
	Begin
		Insert Into System_UserLogin 
			(UserID, SessionID) 
		Values
			(@UserID, @SessionID)
	End
	Else
	Begin
		Update System_UserLogin 
		Set SessionID = @SessionID
		Where UserID = @UserID
	End
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DataObjects_GetTableDef]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DataObjects_GetTableDef]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[usp_DataObjects_GetTableDef]
@TableName VarChar(Max)
, @SchemaName VarChar(Max) = ''''
As
Set NOCOUNT On
Begin
	
	If IsNull(@SchemaName, '''') = ''''
	Begin
		Set @SchemaName = ''dbo''
	End
	
	Select *
	From [udf_DataObjects_GetTableDef](@SchemaName + ''.'' + @TableName)
	Order By Column_Id
	
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DataObjects_GetNextID]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DataObjects_GetNextID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[usp_DataObjects_GetNextID]
@TableName VarChar(Max)
As
Begin
	Declare @LastID BigInt
	Declare @Ct Int

	Select @Ct = Count(*)
	From DataObjects_Series
	Where TableName = @TableName
		
	If @Ct = 0
	Begin
		Insert Into DataObjects_Series (TableName, LastID) Values (@TableName, 0)
	End

	Select @LastID = LastID
	From DataObjects_Series
	Where TableName = @TableName
		
	Set @LastID = @LastID + 1
		
	Update DataObjects_Series
	Set LastID = @LastID 
	Where TableName = @TableName
	
	Select @LastID As [ID]
	
End

' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountingLedger_UpdateCurrent_Transaction]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountingLedger_UpdateCurrent_Transaction]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[usp_AccountingLedger_UpdateCurrent_Transaction]
@System_ModulesID As BigInt
, @SourceID As BigInt
As
Begin
	
	Delete From AccountingLedger_Current
	Where 
		System_ModulesID = @System_ModulesID
		And SourceID = @SourceID	
		
	Declare @DateLastPostingPeriod As DateTime
	Select @DateLastPostingPeriod = Max([Tb].DatePosted)
	From 
		(
		Select
			[D].DatePosted
		From
			AccountingLedgerPostingPeriod As [Tb]
			Left Join Document As [D]
				On [D].DocumentID = [Tb].DocumentID
		) As [Tb]
	Select @DateLastPostingPeriod = IsNull(@DateLastPostingPeriod,''2000-01-01'')
	
	--[-]
	
	Declare @AccountingChartOfAccountsID As BigInt
	Declare @TableName As VarChar(Max)
	Declare @FieldName_ID As VarChar(Max)
	Declare @FieldName_DocNo As VarChar(Max)
	Declare @FieldName_DatePosted As VarChar(Max)
	Declare @FieldName_ChartOfAccountsID As VarChar(Max)
	Declare @FieldName_Amount As VarChar(Max)
	Declare @FieldName_PartyID As VarChar(Max)
	
	Declare @IsDebit As Bit

	Declare @Query As NVarChar(Max)
	Declare @Query_Parameters As NVarChar(Max)
	Declare @Query_PartyID As NVarChar(Max)
	
	Create Table #Tmp 
	(
		AccountingChartOfAccountsID BigInt
		, System_ModulesID BigInt
		, TableName VarChar(100)
		, SourceID BigInt
		, DocNo VarChar(1000)
		, DatePosted DateTime
		, PartyID BigInt
		, Amount Numeric(18,2)
		, IsDebit Bit
	)
	
	--[Insert Data: Based on AccountingLedgerMapping]
	
	Declare GLMapCur Cursor For
	Select 
		[Tb].AccountingChartOfAccountsID
		, [Tb].System_ModulesID
		, [Tb].TableName
		, [Tb].FieldName_ID
		, [Tb].FieldName_DocNo
		, [Tb].FieldName_DatePosted
		, [Tb].FieldName_Amount
		, [Tb].FieldName_PartyID
		, [Tb].IsDebit
	From 
		AccountingLedgerMapping As [Tb]
		Inner Join AccountingChartOfAccounts As [Coa]
			On [Coa].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID

	Open GLMapCur

	Fetch Next From GLMapCur 
	Into
		@AccountingChartOfAccountsID
		, @System_ModulesID
		, @TableName
		, @FieldName_ID
		, @FieldName_DocNo
		, @FieldName_DatePosted
		, @FieldName_Amount
		, @FieldName_PartyID
		, @IsDebit

	While @@Fetch_Status = 0
	Begin
		
		Set @Query_PartyID = '', Null''
		If Not IsNull(@FieldName_PartyID,'''') = ''''
		Begin
			Set @Query_PartyID = '', ['' + @FieldName_PartyID + '']''
		End
		
		Set @Query = 
			''
			Insert Into #Tmp
				(
				AccountingChartOfAccountsID
				, System_ModulesID
				, TableName
				, SourceID
				, DocNo
				, DatePosted
				, Amount
				, IsDebit
				, PartyID
				)
			Select
				@Param_ChartOfAccountsID
				, @Param_System_ModulesID
				, @Param_TableName
				, ['' + @FieldName_ID + '']
				, ['' + @FieldName_DocNo + '']
				, ['' + @FieldName_DatePosted + '']
				, ['' + @FieldName_Amount + '']
				, @Param_IsDebit
				'' + @Query_PartyID + ''
			From
				['' + @TableName + '']
			Where
				IsPosted = 1
				And IsNull(IsCancelled,0) = 0
				And ['' + @FieldName_DatePosted + ''] >= @Param_DateLastPostingPeriod
				And ['' + @FieldName_DatePosted + ''] <= GetDate()
				And ['' + @FieldName_Amount + ''] <> 0
			''
		
		Set @Query_Parameters = 
			''
			@Param_ChartOfAccountsID BigInt
			, @Param_System_ModulesID BigInt
			, @Param_TableName VarChar(100)
			, @Param_FieldName_ID VarChar(1000)
			, @Param_FieldName_DocNo VarChar(1000)
			, @Param_FieldName_DatePosted VarChar(1000)
			, @Param_FieldName_Amount VarChar(1000)
			, @Param_IsDebit Bit
			, @Param_DateLastPostingPeriod DateTime
			''
		
		Execute sp_executesql
			@Query
			, @Query_Parameters
			, @Param_ChartOfAccountsID = @AccountingChartOfAccountsID
			, @Param_System_ModulesID = @System_ModulesID
			, @Param_TableName = @TableName
			, @Param_FieldName_ID = @FieldName_ID
			, @Param_FieldName_DocNo = @FieldName_DocNo
			, @Param_FieldName_DatePosted = @FieldName_DatePosted
			, @Param_FieldName_Amount = @FieldName_Amount
			, @Param_IsDebit = @IsDebit
			, @Param_DateLastPostingPeriod = @DateLastPostingPeriod

		Fetch Next From GLMapCur 
		Into
			@AccountingChartOfAccountsID
			, @System_ModulesID
			, @TableName
			, @FieldName_ID
			, @FieldName_DocNo
			, @FieldName_DatePosted
			, @FieldName_Amount
			, @FieldName_PartyID
			, @IsDebit
	End

	Close GLMapCur
	Deallocate GLMapCur
	
	--[Insert Data: Based on AccountingLedgerMappingChartOfAccounts]

	Declare GLCoaMapCur Cursor For
	Select 
		System_ModulesID
		, TableName
		, FieldName_ID
		, FieldName_DocNo
		, FieldName_DatePosted
		, FieldName_ChartOfAccountID
		, FieldName_Amount
		, FieldName_PartyID
		, IsDebit
	From 
		AccountingLedgerMappingChartOfAccounts

	Open GLCoaMapCur

	Fetch Next From GLCoaMapCur
	Into 
		@System_ModulesID
		, @TableName
		, @FieldName_ID
		, @FieldName_DocNo
		, @FieldName_DatePosted
		, @FieldName_ChartOfAccountsID
		, @FieldName_Amount
		, @FieldName_PartyID
		, @IsDebit

	While @@Fetch_Status = 0
	Begin
		
		Set @Query_PartyID = '', Null''
		If Not IsNull(@FieldName_PartyID,'''') = ''''
		Begin
			Set @Query_PartyID = '', ['' + @FieldName_PartyID + '']''
		End
		
		Set @Query = 
			''
			Insert Into #Tmp
				(
					AccountingChartOfAccountsID
					, System_ModulesID
					, TableName
					, SourceID
					, DocNo
					, DatePosted
					, Amount
					, IsDebit
					, PartyID
				)
				Select 
					['' + @FieldName_ChartOfAccountsID + '']
					, @Param_System_ModulesID
					, @Param_TableName
					, ['' + @FieldName_ID + '']
					, ['' + @FieldName_DocNo + '']
					, ['' + @FieldName_DatePosted + '']
					, ['' + @FieldName_Amount + '']
					, @Param_IsDebit
					'' + @Query_PartyID + ''
				From
					['' + @TableName + '']
				Where
					IsPosted = 1
					And IsNull(IsCancelled,0) = 0
					And ['' + @FieldName_DatePosted + ''] >= @Param_DateLastPostingPeriod
					And ['' + @FieldName_DatePosted + ''] <= GetDate()
					And ['' + @FieldName_Amount + ''] <> 0
			''
		
		Set @Query_Parameters = 
				''
				@Param_System_ModulesID BigInt
				, @Param_TableName VarChar(100)
				, @Param_FieldName_ID VarChar(1000)
				, @Param_FieldName_DocNo VarChar(1000)
				, @Param_FieldName_DatePosted VarChar(1000)
				, @Param_FieldName_Amount VarChar(1000)
				, @Param_IsDebit Bit
				, @Param_DateLastPostingPeriod DateTime
				''
		
		Execute sp_executesql
				@Query
				, @Query_Parameters
				, @Param_System_ModulesID = @System_ModulesID
				, @Param_TableName = @TableName
				, @Param_FieldName_ID = @FieldName_ID
				, @Param_FieldName_DocNo = @FieldName_DocNo
				, @Param_FieldName_DatePosted = @FieldName_DatePosted
				, @Param_FieldName_Amount = @FieldName_Amount
				, @Param_IsDebit = @IsDebit
				, @Param_DateLastPostingPeriod = @DateLastPostingPeriod
		
		Fetch Next From GLCoaMapCur
		Into 
			@System_ModulesID
			, @TableName
			, @FieldName_ID
			, @FieldName_DocNo
			, @FieldName_DatePosted
			, @FieldName_ChartOfAccountsID
			, @FieldName_Amount
			, @FieldName_PartyID
			, @IsDebit
	End

	Close GLCoaMapCur
	Deallocate GLCoaMapCur
	
	--[-]

	Insert Into AccountingLedger_Current
	Select 
		[Tb].* 
	From 
		#Tmp As [Tb]
		Inner Join AccountingChartOfAccounts As [Coa]
			On [Coa].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID
	Order By 
		[Tb].AccountingChartOfAccountsID
		, [Tb].DatePosted

	Drop Table #Tmp 
	
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DataObjects_Parameter_Set]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DataObjects_Parameter_Set]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[usp_DataObjects_Parameter_Set]
@ParameterName VarChar(Max)
, @ParameterValue VarChar(Max)
As
Begin
	Declare @Ct As Int	
	Select @Ct = Count(1)
	From DataObjects_Parameters
	Where ParameterName = @ParameterName
	
	If @Ct = 0
	Begin
		Insert Into DataObjects_Parameters 
			(ParameterName, ParameterValue) 
		Values 
			(@ParameterName, @ParameterValue)
	End
	Else
	Begin
		Update DataObjects_Parameters 
		Set ParameterValue = @ParameterValue 
		Where ParameterName = @ParameterName
	End
End

' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DataObjects_Parameter_Require]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DataObjects_Parameter_Require]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[usp_DataObjects_Parameter_Require]
@ParameterName VarChar(Max)
, @ParameterValue VarChar(Max)
As
Begin
	Declare @Ct As Int	
	Select @Ct = Count(1)
	From DataObjects_Parameters
	Where ParameterName = @ParameterName
	
	If @Ct = 0
	Begin
		Insert Into DataObjects_Parameters 
			(ParameterName, ParameterValue) 
		Values 
			(@ParameterName, @ParameterValue)
	End
End

' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DataObjects_Parameter_Get]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DataObjects_Parameter_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[usp_DataObjects_Parameter_Get]
@ParameterName VarChar(Max)
, @DefaultValue As VarChar(Max)
As
Begin
	Declare @ParameterValue As VarChar(Max)		
	Set @ParameterValue = ''''
	
	Declare @Ct As Int	
	Select @Ct = Count(1)
	From DataObjects_Parameters
	Where ParameterName = @ParameterName
	
	If @Ct = 0
	Begin
		Exec usp_DataObjects_Parameter_Require @ParameterName, @DefaultValue
	End
	Else
	Begin
		Select @ParameterValue = ParameterValue
		From DataObjects_Parameters
		Where ParameterName = @ParameterName
	End
	
	Select @ParameterValue As [ParameterValue]
End

' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateTableCache]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_UpdateTableCache]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[usp_UpdateTableCache]
@TableName As VarChar(1000)
, @TableName_Source As VarChar(1000)
, @TableName_Cache As VarChar(1000)
, @TableName_KeyName As VarChar(1000)
As
Begin
	Set NoCount On
	
	Declare @Limit As BigInt
	Set @Limit = Cast(dbo.udf_DataObjects_Parameter_Get(''CacheUpdateLimit'') As BigInt)

	Declare @CacheDatabase As VarChar(1000)
	Set @CacheDatabase = dbo.udf_DataObjects_Parameter_Get(''CacheDatabase'')

	Declare @Query_Execute As VarChar(Max)
	Set @Query_Execute = 
		''
		Delete From ['' + @CacheDatabase + ''].[dbo].['' + @TableName_Cache + '']
		From	
			#Tmp As [Src]
			Inner Join ['' + @CacheDatabase + ''].[dbo].['' + @TableName_Cache + ''] As [Trg]
				On [Trg].['' + @TableName_KeyName + ''] = [Src].[ID]

		Declare @Query As VarChar(Max)
		Declare @Query_Condition As VarChar(Max)
		Declare @Query_ID As VarChar(Max)
		Declare @Query_Comma As VarChar(1)	
		Declare @IsStart As Bit

		Declare @Limit As BigInt
		Declare @Ct As BigInt
		Declare @Total_Ct As BigInt

		Set @Limit  = '' + Cast(@Limit As VarChar(30)) + ''

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
			, @Query = '''''''' 
			, @Query_ID = ''''''''
			, @Query_Comma = ''''''''
		
		While @@Fetch_Status = 0
		Begin
			Set @Ct = @Ct  + 1
			Set @Total_Ct = @Total_Ct - 1
			Set @Query_ID = @Query_ID + @Query_Comma + Cast(@ID As VarChar(30))
			
			If @IsStart = 0
			Begin
				Set @IsStart  = 1
				Set @Query_Comma = '''',''''
			End
			
			If @Ct >= @Limit Or @Total_Ct <= 0
			Begin
				Set @Query_Condition =
				''''
				And (['' + @TableName_KeyName + ''] In ('''' + @Query_ID + ''''))
				''''
				
				Set @Query =
					''''
					Insert Into ['' + @CacheDatabase + ''].[dbo].['' + @TableName_Cache + '']
					Select 
						[Tb].*
					From 
						['' + @TableName_Source + ''] As [Tb]
					Where
						1 = 1
						'''' + @Query_Condition + ''''
					''''
				Exec(@Query)
				
				Select
					@Ct = 0
					, @IsStart = 0
					, @Query = '''''''' 
					, @Query_ID = ''''''''
					, @Query_Comma = ''''''''
			End
			
			Fetch Next From Cr
			Into @ID
		End
		
		Close Cr
		Deallocate Cr
		''
		
	Declare @Query As NVarChar(Max)
	Set @Query  = 
		''
		Select ID
		Into #Tmp
		From [dbo].[udf_System_TableUpdateBatch]('''''' + @TableName + '''''')
		
		Delete From System_TableUpdateBatch_Details
		From
			System_TableUpdateBatch_Details As [Tbd]
			Inner Join System_TableUpdateBatch As [Tb]
				On [Tb].System_TableUpdateBatchID = [Tbd].System_TableUpdateBatchID
		Where
			[Tb].TableName = '''''' + @TableName +  ''''''
		
		If Not Exists(Select * From #Tmp)
		Begin
			Return
		End
		
		Declare @Query As VarChar(Max)
		Set @Query = @Param_Query_Execute
		Exec(@Query)
		''	

	Declare @Query_Parameters As NVarChar(Max)
	Set @Query_Parameters = N''@Param_Query_Execute VarChar(Max)''
		
	Exec Sp_ExecuteSql 
		@Query
		, @Query_Parameters
		, @Param_Query_Execute = @Query_Execute
		
End

' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Get_System_Parameter]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Get_System_Parameter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[usp_Get_System_Parameter]
@ParameterName VarChar(Max)
As
Begin
	Declare @ParameterValue As VarChar(Max)		
	Set @ParameterValue = ''''
	
	Declare @Ct As Int	
	Select @Ct = Count(1)
	From System_Parameters
	Where ParameterName = @ParameterName
	
	If @Ct = 0
	Begin
		Exec usp_Require_System_Parameter @ParameterName
	End
	Else
	Begin
		Select @ParameterValue = ParameterValue
		From System_Parameters
		Where ParameterName = @ParameterName
	End
	
	Select @ParameterValue As [ParameterValue]
End
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_System_Lookup]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_System_Lookup]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE Function [dbo].[udf_System_Lookup]
(
	@Lookup_Name VarChar(Max)
)	
Returns Table
As
Return
	(
	Select
		System_Lookup_DetailsID As [System_LookupID]
		, [Name]
		, [Desc]
		, OrderIndex
	From uvw_System_Lookup_Details
	Where 
		Lookup_Name = @Lookup_Name
	)
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Lookup]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_Lookup]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[udf_Lookup]
(
	@Lookup_Name VarChar(Max)
)	
Returns Table
As
Return
	(
	Select 
		Lookup_DetailsID As [LookupID]
		, [Desc]
	From uvw_Lookup_Details
	Where 
		Lookup_Name = @Lookup_Name
		And IsNull(IsDeleted,0) = 0
		And IsNull(IsActive,0) = 1
	)
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateTableCache_All]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_UpdateTableCache_All]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[usp_UpdateTableCache_All]
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
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_InventoryWarehouseSnapshot_Details_Max]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_InventoryWarehouseSnapshot_Details_Max]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[udf_InventoryWarehouseSnapshot_Details_Max]
(
	@DateCheck As DateTime
)	
Returns Table
As
Return
	(
	Select
		[Tb_Max].InventoryWarehouseSnapshotID
		, [Tb_Max].WarehouseID
		, [Tbd].ItemID
		, [Tbd].Qty
		, [Tb].SnapshotDate
	From
		(
		Select
			Max(InventoryWarehouseSnapshotID) As InventoryWarehouseSnapshotID
			, WarehouseID
		From
			InventoryWarehouseSnapshot
		Where
			SnapshotDate <= @DateCheck
		Group By
			WarehouseID
		) As [Tb_Max]
		Inner Join InventoryWarehouseSnapshot As [Tb]
			On [Tb].InventoryWarehouseSnapshotID = [Tb_Max].InventoryWarehouseSnapshotID
		Inner Join InventoryWarehouseSnapshot_Details As [Tbd]
			On [Tbd].InventoryWarehouseSnapshotID = [Tb_Max].InventoryWarehouseSnapshotID
	)
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_InventoryWarehouse_Current_Item]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_InventoryWarehouse_Current_Item]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[udf_InventoryWarehouse_Current_Item]
(
	@DateCheck As DateTime
)	
Returns Table
As
Return
	(
	Select
		[Tb].ItemID
		, [Tb].WarehouseID
		, Sum([Tb].Qty) As [Qty]
	From
		(
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID_TransferFrom As [WarehouseID]
			, (Sum([Tbd].Qty) * -1) As [Qty]
		From 
			uvw_InventoryWarehouseTransfer_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID_TransferFrom
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),''1900-01-01'')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID_TransferFrom
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID_TransferTo As [WarehouseID]
			, Sum([Tbd].Qty) As [Qty]
		From 
			uvw_InventoryWarehouseTransfer_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID_TransferTo
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),''1900-01-01'')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID_TransferTo
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, Sum([Tbd].Qty) As [Qty]
		From 
			uvw_InventoryWarehouseOpening_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),''1900-01-01'')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, Sum([Tbd].Qty) As [Qty]
		From 
			uvw_InventoryWarehouseAdjustment_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),''1900-01-01'')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, Sum([Tbd].Qty) As [Qty]
		From 
			uvw_TransactionReceiveOrder_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),''1900-01-01'')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, (Sum([Tbd].Qty) * -1) As [Qty]
		From 
			uvw_TransactionDeliverOrder_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),''1900-01-01'')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, Sum([Tbd].Qty) As [Qty]
		From 
			uvw_TransactionSalesReturn_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),''1900-01-01'')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Tbd].ItemID
			, [Tbd].WarehouseID
			, (Sum([Tbd].Qty) * -1) As [Qty]
		From 
			uvw_TransactionPurchaseReturn_DocumentItem As [Tbd]
		Where
			[Tbd].IsPosted = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied <= @DateCheck
			And [Tbd].DateApplied >=
				IsNull(
				(
				Select
					Max([InnerSnapshot].SnapshotDate)
				From
					uvw_InventoryWarehouseSnapshot_Details As [InnerSnapshot]
				Where
					[InnerSnapshot].ItemID = [Tbd].ItemID
					And [InnerSnapshot].WarehouseID = [Tbd].WarehouseID
					And [InnerSnapshot].SnapshotDate <= @DateCheck
				),''1900-01-01'')
		Group By
			[Tbd].ItemID
			, [Tbd].WarehouseID
		
		Union All
		
		Select
			[Snapshot].ItemID
			, [Snapshot].WarehouseID
			, [Snapshot].Qty
		From 
			udf_InventoryWarehouseSnapshot_Details_Max(@DateCheck) As [Snapshot]
		) As [Tb]
	Group By
		[Tb].ItemID
		, [Tb].WarehouseID
	)
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InventoryWarehouse_Update_Current_Item]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_InventoryWarehouse_Update_Current_Item]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[usp_InventoryWarehouse_Update_Current_Item]
@ID_ItemWarehouse As VarChar(Max) = ''''
As
Begin
	Declare @Ex_ID_ItemWarehouse As VarChar(Max)
	Declare @cItemID As VarChar(50)
	Declare @cWarehouseID As VarChar(50)
	
	Declare @SqlQuery As VarChar(Max)
	Declare @SqlQuery_Source As VarChar(Max)
	Declare @SqlQuery_Source_Criteria_ItemWarehouse As VarChar(Max)
	Declare @SqlQuery_Source_Criteria_Or As VarChar(10)
	
	Select
		@SqlQuery = ''''
		, @SqlQuery_Source = ''''
		, @SqlQuery_Source_Criteria_ItemWarehouse = ''''
		, @SqlQuery_Source_Criteria_Or = ''''
	
	If @ID_ItemWarehouse <> ''''
	Begin
	
		Set @Ex_ID_ItemWarehouse = @ID_ItemWarehouse
		While (Select CharIndex(''</I>'',@Ex_ID_ItemWarehouse)) <> 0 
		Begin
			Select @cItemID = SubString(@Ex_ID_ItemWarehouse,CharIndex(''<I>'',@Ex_ID_ItemWarehouse) + 3,(CharIndex(''</I>'',@Ex_ID_ItemWarehouse) - 4))
			Select @Ex_ID_ItemWarehouse = SubString(@Ex_ID_ItemWarehouse,(CharIndex(''</I>'',@Ex_ID_ItemWarehouse) + 4),Len(@Ex_ID_ItemWarehouse))

			Select @cWarehouseID = SubString(@Ex_ID_ItemWarehouse,CharIndex(''<WH>'',@Ex_ID_ItemWarehouse) + 4,(CharIndex(''</WH>'',@Ex_ID_ItemWarehouse) - 5))
			Select @Ex_ID_ItemWarehouse = SubString(@Ex_ID_ItemWarehouse,(CharIndex(''</WH>'',@Ex_ID_ItemWarehouse) + 5),Len(@Ex_ID_ItemWarehouse))
			
			Set @SqlQuery_Source_Criteria_ItemWarehouse =
				@SqlQuery_Source_Criteria_ItemWarehouse +
				'' '' + @SqlQuery_Source_Criteria_Or + ''
				(ItemID = '' + @cItemID + '' And WarehouseID = '' + @cWarehouseID + '' ) 
				 ''
				Set @SqlQuery_Source_Criteria_Or = ''Or''
		End
		
		Set @SqlQuery_Source_Criteria_ItemWarehouse = '' And ('' + @SqlQuery_Source_Criteria_ItemWarehouse + '')''
		
		Set @SqlQuery_Source =
			''
			Select * 
			From uvw_InventoryWarehouse_Current_Item
			Where
				1 = 1
				'' + @SqlQuery_Source_Criteria_ItemWarehouse + ''
			''
		
		Set @SqlQuery = 
			''
			Update Materialized_InventoryWarehouse_Current_Item 
			Set
				[Qty] = Source.[Qty]
			From
				('' + @SqlQuery_Source + '') As [Source]
				, Materialized_InventoryWarehouse_Current_Item As [Target]
			Where
				[Source].ItemID = [Target].ItemID
				And [Source].WarehouseID = [Target].WarehouseID
			
			Insert Into Materialized_InventoryWarehouse_Current_Item
				(
				ItemID
				, WarehouseID
				, Qty
				)
			Select
				ItemID
				, WarehouseID
				, Qty
			From
				('' + @SqlQuery_Source + '') As [Source]
			Where
				Not Exists
				(
				Select *
				From Materialized_InventoryWarehouse_Current_Item As [Target]
				Where
					[Source].ItemID = [Target].ItemID
					And [Source].WarehouseID = [Target].WarehouseID
				)
			''
		Exec(@SqlQuery)
		
	End
	Else
	Begin
		Truncate Table Materialized_InventoryWarehouse_Current_Item
		Insert Into Materialized_InventoryWarehouse_Current_Item
			(
			ItemID
			, WarehouseID
			, Qty
			)
		Select
			ItemID
			, WarehouseID
			, Qty
		From
			uvw_InventoryWarehouse_Current_Item As [Source]
	End
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InventoryParty_Update_Current_Item]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_InventoryParty_Update_Current_Item]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[usp_InventoryParty_Update_Current_Item]
@ID_ItemParty As VarChar(Max) = ''''
As
Begin
	Declare @Ex_ID_ItemParty As VarChar(Max)
	Declare @cItemID As VarChar(50)
	Declare @cPartyID As VarChar(50)
	Declare @cConcessionaireID As VarChar(50)
	Declare @cWarehouseID As VarChar(50)
	
	Declare @SqlQuery As VarChar(Max)
	Declare @SqlQuery_Source As VarChar(Max)
	Declare @SqlQuery_Source_Criteria_ItemParty As VarChar(Max)
	Declare @SqlQuery_Source_Criteria_Or As VarChar(10)
	
	Select
		@SqlQuery = ''''
		, @SqlQuery_Source = ''''
		, @SqlQuery_Source_Criteria_ItemParty = ''''
		, @SqlQuery_Source_Criteria_Or = ''''
	
	Create Table #Tmp (ItemID BigInt, PartyID BigInt)
	
	If @ID_ItemParty <> ''''
	Begin
	
		Set @Ex_ID_ItemParty = @ID_ItemParty
		While (Select CharIndex(''</I>'',@Ex_ID_ItemParty)) <> 0 
		Begin
			Select @cItemID = SubString(@Ex_ID_ItemParty,CharIndex(''<I>'',@Ex_ID_ItemParty) + 3,(CharIndex(''</I>'',@Ex_ID_ItemParty) - 4))
			Select @Ex_ID_ItemParty = SubString(@Ex_ID_ItemParty,(CharIndex(''</I>'',@Ex_ID_ItemParty) + 4),Len(@Ex_ID_ItemParty))

			Select @cPartyID = SubString(@Ex_ID_ItemParty,CharIndex(''<PR>'',@Ex_ID_ItemParty) + 4,(CharIndex(''</PR>'',@Ex_ID_ItemParty) - 5))
			Select @Ex_ID_ItemParty = SubString(@Ex_ID_ItemParty,(CharIndex(''</PR>'',@Ex_ID_ItemParty) + 5),Len(@Ex_ID_ItemParty))
			
			Insert Into #Tmp 
				(ItemID, PartyID)
			Values
				(Cast(@cItemID As BigInt), Cast(@cPartyID As BigInt))
		End
		
		--[-]
		
		Declare Cur_Wh Cursor Fast_Forward
		For
		Select
			Cast([Tb].ItemID As VarChar(50))
			, Cast([Wh].WarehouseID As VarChar(50))
		From 
			#Tmp As [Tb]
			Inner Join Warehouse As [Wh]
				On [Wh].PartyID = [Tb].PartyID
				
		Open Cur_Wh
		
		Fetch Next From Cur_Wh
		Into @cItemID, @cWarehouseID
		
		Declare @ID_ItemWarehouse As VarChar(Max)
		Set @ID_ItemWarehouse = ''''
		
		While @@Fetch_Status = 0
		Begin
			Set @ID_ItemWarehouse = @ID_ItemWarehouse + ''<I>'' + @cItemID + ''</I>'' + ''<WH>'' + @cWarehouseID + ''</WH>''
			Fetch Next From Cur_Wh
			Into @cItemID, @cWarehouseID
		End
		
		Close Cur_Wh
		Deallocate Cur_Wh
		
		If @ID_ItemWarehouse <> ''''
		Begin
			Exec usp_InventoryWarehouse_Update_Current_Item @ID_ItemWarehouse
		End
		--[-]
		
		Drop Table #Tmp
	End
	Else
	Begin
		Exec usp_InventoryWarehouse_Update_Current_Item
	End
End
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_InventoryWarehouse_History_Item_Union]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_InventoryWarehouse_History_Item_Union]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[udf_InventoryWarehouse_History_Item_Union]
(
	@DateStart As DateTime
	, @DateEnd As DateTime
)	
Returns Table
As
Return
	(
	Select
		[Tb].*
		, [Wh].PartyID
	From
		(
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID_TransferFrom As [WarehouseID]
			, ([Tbd].Qty * -1) As [Qty]
			, 1 As [Flag]
			, ''Transfered To: '' + IsNull([W].WarehouseCodeName,'''') As [Entry_Desc]
		From 
			uvw_InventoryWarehouseTransfer_DocumentItem As [Tbd]
			Left Join uvw_Warehouse As [W]
				On [W].WarehouseID = [Tbd].WarehouseID_TransferTo
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID_TransferTo As [WarehouseID]
			, [Tbd].Qty
			, 1 As [Flag]
			, ''Transfered From: '' + IsNull([W].WarehouseCodeName,'''') As [Entry_Desc]
		From 
			uvw_InventoryWarehouseTransfer_DocumentItem As [Tbd]
			Left Join uvw_Warehouse As [W]
				On [W].WarehouseID = [Tbd].WarehouseID_TransferFrom
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, [Tbd].Qty
			, 1 As [Flag]
			, ''Opening Balance'' As [Entry_Desc]
		From 
			uvw_InventoryWarehouseOpening_DocumentItem As [Tbd]
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, [Tbd].Qty
			, 1 As [Flag]
			, ''Adjustment '' As [Entry_Desc]
		From 
			uvw_InventoryWarehouseAdjustment_DocumentItem As [Tbd]
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, [Tbd].Qty
			, 1 As [Flag]
			, ''Received From: '' + IsNull([S].SupplierCodeName,'''') As [Entry_Desc]
		From 
			uvw_TransactionReceiveOrder_DocumentItem As [Tbd]
			Left Join uvw_Supplier As [S]
				On [S].SupplierID = [Tbd].SupplierID
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, ([Tbd].Qty * -1) As [Qty]
			, 1 As [Flag]
			, ''Delivered To: '' + IsNull([C].CustomerCodeName,'''') As [Entry_Desc]
		From 
			uvw_TransactionDeliverOrder_DocumentItem As [Tbd]
			Left Join uvw_Customer As [C]
				On [C].CustomerID = [Tbd].CustomerID
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, [Tbd].Qty
			, 1 As [Flag]
			, ''Returned By: '' + IsNull([C].CustomerCodeName,'''') As [Entry_Desc]
		From 
			uvw_TransactionSalesReturn_DocumentItem As [Tbd]
			Left Join uvw_Customer As [C]
				On [C].CustomerID = [Tbd].CustomerID
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			[Tbd].DocNo
			, [Tbd].DateApplied As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, ([Tbd].Qty * -1) As [Qty]
			, 1 As [Flag]
			, ''Returned To: '' + IsNull([S].SupplierCodeName,'''') As [Entry_Desc]
		From 
			uvw_TransactionPurchaseReturn_DocumentItem As [Tbd]
			Left Join uvw_Supplier As [S]
				On [S].SupplierID = [Tbd].SupplierID
		Where
			IsNull([Tbd].IsPosted,0) = 1
			And IsNull([Tbd].IsCancelled,0) = 0
			And [Tbd].DateApplied >= @DateStart
			And [Tbd].DateApplied <= @DateEnd
		
		Union All
		
		Select
			''Snapshot'' As [DocNo]
			, [Tbd].SnapshotDate As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, [Tbd].Qty
			, 2 As [Flag]
			, ''Inventory Snapshot'' As [Entry_Desc]
		From 
			uvw_InventoryWarehouseSnapshot_Details As [Tbd]
		Where
			[Tbd].SnapshotDate >= @DateStart
			And [Tbd].SnapshotDate <= @DateEnd
		
		Union All
		
		Select
			''Balance Brought Forward'' As [DocNo]
			, @DateStart As [DatePosted]
			, [Tbd].ItemID
			, [Tbd].WarehouseID
			, [Tbd].Qty
			, 1 As [Flag]
			, ''Balance Brought Forward '' As [Entry_Desc]
		From
			udf_InventoryWarehouse_Current_Item(@DateStart) As [Tbd]
		
		) As [Tb]
		Left Join Warehouse As [Wh]
			On [Wh].WarehouseID = [Tb].WarehouseID
	)
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_AccountingLedger_Amount]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_AccountingLedger_Amount]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE Function [dbo].[udf_AccountingLedger_Amount]
(
@DateStart As DateTime
, @DateEnd As DateTime
)
Returns Table
As
Return
	(
	Select 
		[Tb].AccountingChartOfAccountsID
		, [Tb].System_LookupID_AccountType
		, [Tb].Coa_IsDebit
		, [Tb].IsDebit
		, [Tb].AccountCodeName
		, [Tb].EntryType
		, [Tb].AccountType_Desc
		, Sum([Tb].Amount) As [Amount]
	From 
		uvw_AccountingLedger As [Tb]
	Where
		DatePosted >= @DateStart
		And DatePosted <= @DateEnd
	Group By
		[Tb].AccountingChartOfAccountsID
		, [Tb].System_LookupID_AccountType
		, [Tb].Coa_IsDebit
		, [Tb].IsDebit
		, [Tb].AccountCodeName
		, [Tb].EntryType
		, [Tb].AccountType_Desc
	)
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_AccountingLedger]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_AccountingLedger]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[udf_AccountingLedger]
(
	@DateStart As DateTime
	, @DateEnd As DateTime
)	
Returns Table
As
Return
	(
	Select [Tb].*
	From uvw_AccountingLedger As [Tb]
	Where 
		DatePosted >= @DateStart
		And DatePosted <= @DateEnd
	)
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountingLedger_UpdateCurrent_JournalVoucher]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountingLedger_UpdateCurrent_JournalVoucher]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[usp_AccountingLedger_UpdateCurrent_JournalVoucher]
@SourceID As BigInt
As
Begin
	
	Declare @System_ModulesID As BigInt
	Set @System_ModulesID = 43
	
	Delete From AccountingLedger_Current
	Where 
		System_ModulesID = @System_ModulesID
		And SourceID = @SourceID	
		
	Declare @DateLastPostingPeriod As DateTime
	Select @DateLastPostingPeriod = Max([Tb].DatePosted)
	From 
		(
		Select
			[D].DatePosted
		From
			AccountingLedgerPostingPeriod As [Tb]
			Left Join Document As [D]
				On [D].DocumentID = [Tb].DocumentID
		) As [Tb]
	Select @DateLastPostingPeriod = IsNull(@DateLastPostingPeriod,''2000-01-01'')
	
	--[-]
	
	Declare @AccountingChartOfAccountsID As BigInt
	Declare @TableName As VarChar(Max)
	Declare @FieldName_ID As VarChar(Max)
	Declare @FieldName_DocNo As VarChar(Max)
	Declare @FieldName_DatePosted As VarChar(Max)
	Declare @FieldName_ChartOfAccountsID As VarChar(Max)
	Declare @FieldName_Amount As VarChar(Max)
	Declare @FieldName_PartyID As VarChar(Max)
	
	Declare @IsDebit As Bit

	Declare @Query As NVarChar(Max)
	Declare @Query_Parameters As NVarChar(Max)
	Declare @Query_PartyID As NVarChar(Max)
	
	Create Table #Tmp 
	(
		AccountingChartOfAccountsID BigInt
		, System_ModulesID BigInt
		, TableName VarChar(100)
		, SourceID BigInt
		, DocNo VarChar(1000)
		, DatePosted DateTime
		, PartyID BigInt
		, Amount Numeric(18,2)
		, IsDebit Bit
	)
	
	--[Insert Data: From TransactionJournalVoucher]
	
	Insert Into #Tmp
		(
		AccountingChartOfAccountsID
		, System_ModulesID
		, TableName
		, SourceID
		, DocNo
		, DatePosted
		, Amount
		, IsDebit
		, PartyID
		)
	Select
		AccountingChartOfAccountsID
		, @System_ModulesID
		, ''TransactionJournalVoucher''
		, TransactionJournalVoucherID
		, DocNo
		, DateApplied
		, Debit_Amount
		, 1
		, PartyID
	From
		uvw_TransactionJournalVoucher_Details
	Where
		IsNull(Debit_Amount,0) <> 0
		And IsNull(IsPosted,0) = 1
		And IsNull(IsCancelled,0) = 0
		And DateApplied >= @DateLastPostingPeriod
		And DateApplied <= GetDate()

	Insert Into #Tmp
		(
		AccountingChartOfAccountsID
		, System_ModulesID
		, TableName
		, SourceID
		, DocNo
		, DatePosted
		, Amount
		, IsDebit
		, PartyID
		)
	Select
		AccountingChartOfAccountsID
		, @System_ModulesID
		, ''TransactionJournalVoucher''
		, TransactionJournalVoucherID
		, DocNo
		, DateApplied
		, Credit_Amount
		, 0
		, PartyID
	From
		uvw_TransactionJournalVoucher_Details
	Where
		IsNull(Credit_Amount,0) <> 0
		And IsNull(IsPosted,0) = 1
		And IsNull(IsCancelled,0) = 0
		And DateApplied >= @DateLastPostingPeriod
		And DateApplied <= GetDate()
	
	--[-]
	
	Insert Into AccountingLedger_Current
	Select 
		[Tb].* 
	From 
		#Tmp As [Tb]
		Inner Join AccountingChartOfAccounts As [Coa]
			On [Coa].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID
	Order By 
		[Tb].AccountingChartOfAccountsID
		, [Tb].DatePosted

	Drop Table #Tmp 
	
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountingLedger_UpdateCurrent]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountingLedger_UpdateCurrent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[usp_AccountingLedger_UpdateCurrent]
As
Begin
	Declare @DateLastPostingPeriod As DateTime
	Select @DateLastPostingPeriod = Max([Tb].DatePosted)
	From 
		(
		Select
			[D].DatePosted
		From
			AccountingLedgerPostingPeriod As [Tb]
			Left Join Document As [D]
				On [D].DocumentID = [Tb].DocumentID
		) As [Tb]
	Select @DateLastPostingPeriod = IsNull(@DateLastPostingPeriod,''2000-01-01'')
	
	--[-]
	
	Declare @AccountingChartOfAccountsID As BigInt
	Declare @TableName As VarChar(Max)
	Declare @System_ModulesID As BigInt
	Declare @FieldName_ID As VarChar(Max)
	Declare @FieldName_DocNo As VarChar(Max)
	Declare @FieldName_DatePosted As VarChar(Max)
	Declare @FieldName_ChartOfAccountsID As VarChar(Max)
	Declare @FieldName_Amount As VarChar(Max)
	Declare @FieldName_PartyID As VarChar(Max)
	
	Declare @IsDebit As Bit

	Declare @Query As NVarChar(Max)
	Declare @Query_Parameters As NVarChar(Max)
	Declare @Query_PartyID As NVarChar(Max)
	
	Create Table #Tmp 
	(
		AccountingChartOfAccountsID BigInt
		, System_ModulesID BigInt
		, TableName VarChar(100)
		, SourceID BigInt
		, DocNo VarChar(1000)
		, DatePosted DateTime
		, PartyID BigInt
		, Amount Numeric(18,2)
		, IsDebit Bit
	)
	
	--[Insert Data: Based on AccountingLedgerMapping]
	
	Declare GLMapCur Cursor For
	Select 
		[Tb].AccountingChartOfAccountsID
		, [Tb].System_ModulesID
		, [Tb].TableName
		, [Tb].FieldName_ID
		, [Tb].FieldName_DocNo
		, [Tb].FieldName_DatePosted
		, [Tb].FieldName_Amount
		, [Tb].FieldName_PartyID
		, [Tb].IsDebit
	From 
		AccountingLedgerMapping As [Tb]
		Inner Join AccountingChartOfAccounts As [Coa]
			On [Coa].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID

	Open GLMapCur

	Fetch Next From GLMapCur 
	Into
		@AccountingChartOfAccountsID
		, @System_ModulesID
		, @TableName
		, @FieldName_ID
		, @FieldName_DocNo
		, @FieldName_DatePosted
		, @FieldName_Amount
		, @FieldName_PartyID
		, @IsDebit

	While @@Fetch_Status = 0
	Begin
		
		Set @Query_PartyID = '', Null''
		If Not IsNull(@FieldName_PartyID,'''') = ''''
		Begin
			Set @Query_PartyID = '', ['' + @FieldName_PartyID + '']''
		End
		
		Set @Query = 
			''
			Insert Into #Tmp
				(
				AccountingChartOfAccountsID
				, System_ModulesID
				, TableName
				, SourceID
				, DocNo
				, DatePosted
				, Amount
				, IsDebit
				, PartyID
				)
			Select
				@Param_ChartOfAccountsID
				, @Param_System_ModulesID
				, @Param_TableName
				, ['' + @FieldName_ID + '']
				, ['' + @FieldName_DocNo + '']
				, ['' + @FieldName_DatePosted + '']
				, ['' + @FieldName_Amount + '']
				, @Param_IsDebit
				'' + @Query_PartyID + ''
			From
				['' + @TableName + '']
			Where
				IsPosted = 1
				And IsNull(IsCancelled,0) = 0
				And ['' + @FieldName_DatePosted + ''] >= @Param_DateLastPostingPeriod
				And ['' + @FieldName_DatePosted + ''] <= GetDate()
				And ['' + @FieldName_Amount + ''] <> 0
			''
		
		Set @Query_Parameters = 
			''
			@Param_ChartOfAccountsID BigInt
			, @Param_System_ModulesID BigInt
			, @Param_TableName VarChar(100)
			, @Param_FieldName_ID VarChar(1000)
			, @Param_FieldName_DocNo VarChar(1000)
			, @Param_FieldName_DatePosted VarChar(1000)
			, @Param_FieldName_Amount VarChar(1000)
			, @Param_IsDebit Bit
			, @Param_DateLastPostingPeriod DateTime
			''
		
		Execute sp_executesql
			@Query
			, @Query_Parameters
			, @Param_ChartOfAccountsID = @AccountingChartOfAccountsID
			, @Param_System_ModulesID = @System_ModulesID
			, @Param_TableName = @TableName
			, @Param_FieldName_ID = @FieldName_ID
			, @Param_FieldName_DocNo = @FieldName_DocNo
			, @Param_FieldName_DatePosted = @FieldName_DatePosted
			, @Param_FieldName_Amount = @FieldName_Amount
			, @Param_IsDebit = @IsDebit
			, @Param_DateLastPostingPeriod = @DateLastPostingPeriod

		Fetch Next From GLMapCur 
		Into
			@AccountingChartOfAccountsID
			, @System_ModulesID
			, @TableName
			, @FieldName_ID
			, @FieldName_DocNo
			, @FieldName_DatePosted
			, @FieldName_Amount
			, @FieldName_PartyID
			, @IsDebit
	End

	Close GLMapCur
	Deallocate GLMapCur
	
	--[Insert Data: Based on AccountingLedgerMappingChartOfAccounts]

	Declare GLCoaMapCur Cursor For
	Select 
		System_ModulesID
		, TableName
		, FieldName_ID
		, FieldName_DocNo
		, FieldName_DatePosted
		, FieldName_ChartOfAccountID
		, FieldName_Amount
		, FieldName_PartyID
		, IsDebit
	From 
		AccountingLedgerMappingChartOfAccounts

	Open GLCoaMapCur

	Fetch Next From GLCoaMapCur
	Into 
		@System_ModulesID
		, @TableName
		, @FieldName_ID
		, @FieldName_DocNo
		, @FieldName_DatePosted
		, @FieldName_ChartOfAccountsID
		, @FieldName_Amount
		, @FieldName_PartyID
		, @IsDebit

	While @@Fetch_Status = 0
	Begin
		
		Set @Query_PartyID = '', Null''
		If Not IsNull(@FieldName_PartyID,'''') = ''''
		Begin
			Set @Query_PartyID = '', ['' + @FieldName_PartyID + '']''
		End
		
		Set @Query = 
			''
			Insert Into #Tmp
				(
					AccountingChartOfAccountsID
					, System_ModulesID
					, TableName
					, SourceID
					, DocNo
					, DatePosted
					, Amount
					, IsDebit
					, PartyID
				)
				Select 
					['' + @FieldName_ChartOfAccountsID + '']
					, @Param_System_ModulesID
					, @Param_TableName
					, ['' + @FieldName_ID + '']
					, ['' + @FieldName_DocNo + '']
					, ['' + @FieldName_DatePosted + '']
					, ['' + @FieldName_Amount + '']
					, @Param_IsDebit
					'' + @Query_PartyID + ''
				From
					['' + @TableName + '']
				Where
					IsPosted = 1
					And IsNull(IsCancelled,0) = 0
					And ['' + @FieldName_DatePosted + ''] >= @Param_DateLastPostingPeriod
					And ['' + @FieldName_DatePosted + ''] <= GetDate()
					And ['' + @FieldName_Amount + ''] <> 0
			''
		
		Set @Query_Parameters = 
				''
				@Param_System_ModulesID BigInt
				, @Param_TableName VarChar(100)
				, @Param_FieldName_ID VarChar(1000)
				, @Param_FieldName_DocNo VarChar(1000)
				, @Param_FieldName_DatePosted VarChar(1000)
				, @Param_FieldName_Amount VarChar(1000)
				, @Param_IsDebit Bit
				, @Param_DateLastPostingPeriod DateTime
				''
		
		Execute sp_executesql
				@Query
				, @Query_Parameters
				, @Param_System_ModulesID = @System_ModulesID
				, @Param_TableName = @TableName
				, @Param_FieldName_ID = @FieldName_ID
				, @Param_FieldName_DocNo = @FieldName_DocNo
				, @Param_FieldName_DatePosted = @FieldName_DatePosted
				, @Param_FieldName_Amount = @FieldName_Amount
				, @Param_IsDebit = @IsDebit
				, @Param_DateLastPostingPeriod = @DateLastPostingPeriod
		
		Fetch Next From GLCoaMapCur
		Into 
			@System_ModulesID
			, @TableName
			, @FieldName_ID
			, @FieldName_DocNo
			, @FieldName_DatePosted
			, @FieldName_ChartOfAccountsID
			, @FieldName_Amount
			, @FieldName_PartyID
			, @IsDebit
	End

	Close GLCoaMapCur
	Deallocate GLCoaMapCur
	
	--[Insert Data: From TransactionJournalVoucher]
	
	Set @System_ModulesID = 43

	Insert Into #Tmp
		(
		AccountingChartOfAccountsID
		, System_ModulesID
		, TableName
		, SourceID
		, DocNo
		, DatePosted
		, Amount
		, IsDebit
		, PartyID
		)
	Select
		AccountingChartOfAccountsID
		, @System_ModulesID
		, ''TransactionJournalVoucher''
		, TransactionJournalVoucherID
		, DocNo
		, DateApplied
		, Debit_Amount
		, 1
		, PartyID
	From
		uvw_TransactionJournalVoucher_Details
	Where
		IsNull(Debit_Amount,0) <> 0
		And IsNull(IsPosted,0) = 1
		And IsNull(IsCancelled,0) = 0
		And DateApplied >= @DateLastPostingPeriod
		And DateApplied <= GetDate()

	Insert Into #Tmp
		(
		AccountingChartOfAccountsID
		, System_ModulesID
		, TableName
		, SourceID
		, DocNo
		, DatePosted
		, Amount
		, IsDebit
		, PartyID
		)
	Select
		AccountingChartOfAccountsID
		, @System_ModulesID
		, ''TransactionJournalVoucher''
		, TransactionJournalVoucherID
		, DocNo
		, DateApplied
		, Credit_Amount
		, 0
		, PartyID
	From
		uvw_TransactionJournalVoucher_Details
	Where
		IsNull(Credit_Amount,0) <> 0
		And IsNull(IsPosted,0) = 1
		And IsNull(IsCancelled,0) = 0
		And DateApplied >= @DateLastPostingPeriod
		And DateApplied <= GetDate()

	--[-]

	Truncate Table AccountingLedger_Current

	Insert Into AccountingLedger_Current
	Select 
		[Tb].* 
	From 
		#Tmp As [Tb]
		Inner Join AccountingChartOfAccounts As [Coa]
			On [Coa].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID
	Order By 
		[Tb].AccountingChartOfAccountsID
		, [Tb].DatePosted

	Drop Table #Tmp 
	
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_System_Modules_Load]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_System_Modules_Load]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[usp_System_Modules_Load]
@UserID As BigInt
As
Begin
	Select Distinct
		[Sm].*
		, [Psm].OrderIndex As [Psm_OrderIndex]
		, [Sm].OrderIndex As [Sm_OrderIndex]
	From 
		System_Modules As [Sm]
		Inner Join uvw_Rights_Details As [Rd]
			On [Rd].System_ModulesID = [Sm].System_ModulesID
			And [Rd].System_Modules_Access_Desc = ''Access''
			And [Rd].IsAllowed = 1
			And IsNull([Sm].IsHidden,0) = 0
		Inner Join uvw_User_Rights As [Ur]
			On [Ur].RightsID = [Rd].RightsID
			And [Ur].IsActive = 1
			And [Ur].UserID = @UserID
		Left Join System_Modules As [Psm]
			On [Psm].System_ModulesID = [Sm].Parent_System_ModulesID
	Order By
		[Psm].OrderIndex
		, [Sm].OrderIndex
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InventoryWarehouse_History_Item]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_InventoryWarehouse_History_Item]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[usp_InventoryWarehouse_History_Item]
	@DateStart As DateTime
	, @DateEnd As DateTime
	, @ItemID As BigInt
	, @WarehouseID As BigInt
As
Begin
	Create Table #Tmp
		(
		[Ct] BigInt
		, [DocNo] VarChar(1000)
		, [DatePosted] DateTime
		, [ItemID] BigInt
		, [WarehouseID] BigInt
		, [Qty] BigInt
		, [Flag] Int
		, [Entry_Desc] VarChar(8000)
		)

	Insert Into #Tmp
	Select
		Row_Number() Over (Partition By WarehouseID, ItemID Order By [Tb].DatePosted) As [Ct]
		, [Tb].DocNo
		, [Tb].DatePosted
		, [Tb].ItemID
		, [Tb].WarehouseID
		, IsNull([Tb].Qty,0) As [Qty]
		, [Tb].Flag
		, [Tb].Entry_Desc
	From
		udf_InventoryWarehouse_History_Item_Union(@DateStart, @DateEnd) As [Tb]
	Where
		ItemID = @ItemID
		And WarehouseID = @WarehouseID
	Order By
		[Tb].DatePosted
	
	Select
		[Tb].Ct
		, [Tb].DocNo
		, [Tb].DatePosted
		, [Tb].ItemID
		, [Tb].WarehouseID
		, [Tb].Qty
		, [Tb].Running_Qty
		, [Tb].Flag
		, [Tb].Entry_Desc
	From
		(
		Select
			[Tb].*
			, IsNull(
				(
				Select
					Sum([InnerTb].Qty) As [Qty]
				From #Tmp As [InnerTb]
				Where
					[InnerTb].ItemID = [Tb].ItemID
					And [InnerTb].WarehouseID = [Tb].WarehouseID
					And [InnerTb].Ct <= [Tb].Ct
					And [InnerTb].Ct >=
						IsNull(
							(
							Select Max([InnerTb].Ct)
							From #Tmp As [InnerTb]
							Where
								[InnerTb].Flag = 2
								And [InnerTb].ItemID = [Tb].ItemID
								And [InnerTb].WarehouseID = [Tb].WarehouseID
								And [InnerTb].Ct <= [Tb].Ct
							)
							,0)
				),0) As [Running_Qty]
		From
			#Tmp As [Tb]
		) As [Tb]
			
	Order By
		WarehouseID
		, ItemID
		, Ct

	Drop Table #Tmp	
End
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Accounting_GeneralLedger]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_Accounting_GeneralLedger]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE Function [dbo].[udf_Accounting_GeneralLedger]
(
	@DateStart As DateTime
	, @DateEnd As DateTime
)
Returns Table
As
Return
	(
	Select
		[Tb].AccountingChartOfAccountsID
		, [Tb].AccountCode
		, [Tb].AccountName
		, [Tb].AccountCodeName
		, [Tb].AccountType_Desc
		, IsNull([Tb_Debit].Amount,0) As [Debit_Amount]
		, IsNull([Tb_Credit].Amount,0) As [Credit_Amount]
	From
		(
		Select Distinct
			AccountingChartOfAccountsID
			, AccountCode
			, AccountName
			, AccountCodeName
			, AccountType_Desc
		From
			udf_AccountingLedger(@DateStart,@DateEnd)
		) As [Tb]
		Left Join 
			(
			Select 
				AccountingChartOfAccountsID
				, Sum(Amount) As [Amount]
			From 
				udf_AccountingLedger(@DateStart,@DateEnd)
			Where
				IsDebit = 1
			Group By
				AccountingChartOfAccountsID
			) As [Tb_Debit]
			On [Tb_Debit].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID
		Left Join	
			(
			Select 
				AccountingChartOfAccountsID
				, Sum(Amount) As [Amount]
			From 
				udf_AccountingLedger(@DateStart,@DateEnd)
			Where
				IsDebit = 0
			Group By
				AccountingChartOfAccountsID
			) As [Tb_Credit]
			On [Tb_Credit].AccountingChartOfAccountsID = [Tb].AccountingChartOfAccountsID
	)
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_TransactionSalesOrder_StockStatus]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_TransactionSalesOrder_StockStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[udf_TransactionSalesOrder_StockStatus]
(
	@WarehouseID As BigInt
)
Returns Table
As
Return
	(
	Select Top (100) Percent
		[Tb].*
		, [Sodi].StatusID
		, (
				Case IsNull([Sodi].StatusID,0)
					When 1 Then ''Full''
					When 2 Then ''Partial''
					When 3 Then ''None''
				End
		) As [StockStatus]
	From
		uvw_TransactionSalesOrder As [Tb]
		Left Join
			(
			Select
				[Tb].TransactionSalesOrderID
				, (
				Case
					When [Sodi] = [Inv] Then 1
					When [Inv] > 0 Then 2
					When [Inv] = 0 Then 3
				End
				) As [StatusID]
			From
				(
				Select
					[Sodi].TransactionSalesOrderID
					, IsNull([Sodi].Ct,0) As [Sodi]
					, IsNull([Inv].Ct,0) As [Inv]
				From
					(
					Select
						[Sodiob].TransactionSalesOrderID
						, Count(1) As [Ct]
					From
						uvw_TransactionSalesOrder_DocumentItem_OrderBalance As [Sodiob]
						Left Join Materialized_InventoryWarehouse_Current_Item As [Inv]
							On [Inv].ItemID = [Sodiob].ItemID
							And [Inv].WarehouseID = @WarehouseID
					Where
						IsNull([Inv].Qty,0) >= IsNull([Sodiob].Qty,0)
						And IsNull([Sodiob].Qty,0) > 0
					Group By
						[Sodiob].TransactionSalesOrderID
					) As [Inv]
					Right Join
						(
						Select
							[Sodiob].TransactionSalesOrderID
							, Count(1) As [Ct]
						From
							uvw_TransactionSalesOrder_DocumentItem_OrderBalance As [Sodiob]
						Where
							IsNull([Sodiob].Qty,0) > 0
						Group By
							[Sodiob].TransactionSalesOrderID
						) As [Sodi]
						On [Sodi].TransactionSalesOrderID = [Inv].TransactionSalesOrderID
				) As [Tb]
			) As [Sodi]
			On [Sodi].TransactionSalesOrderID = [Tb].TransactionSalesOrderID
	Where
		IsNull([Tb].IsPosted,0) = 1
		And IsNull([Tb].IsComplete,0) = 0
		And IsNull([Tb].IsCancelled,0) = 0
	Order By
		StatusID
		, DocNo	
	)
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountingLedger_PostCurrent]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountingLedger_PostCurrent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[usp_AccountingLedger_PostCurrent]
@EmployeeID As BigInt
As
Begin
	Begin Transaction TrnLevel_0
	Begin Try
		Exec usp_AccountingLedger_UpdateCurrent
		
		Declare @DateLastPostingPeriod As DateTime
		Select @DateLastPostingPeriod = Max([Tb].DatePosted)
		From 
			(
			Select 
				[D].DatePosted
			From 
				AccountingLedgerPostingPeriod As [Tb]
				Left Join Document As [D]
					On [D].DocumentID = [Tb].DocumentID
			) As [Tb]
		Select @DateLastPostingPeriod = IsNull(@DateLastPostingPeriod,''2000-01-01'')
	
		--[-]
		
		Declare @DocumentSeries_Table VarChar(1000)
		Declare @DocumentSeries_Field VarChar(1000)
		Declare @DocumentSeries_Prefix VarChar(1000)
		Declare @DocumentSeries_Digits Int
		
		Select
			@DocumentSeries_Table = [TableName]
			, @DocumentSeries_Field = [FieldName]
			, @DocumentSeries_Prefix = [Prefix]
			, @DocumentSeries_Digits = [Digits]
		From
			System_DocumentSeries
		Where
			ModuleName = ''LedgerPostingPeriod''
		
		Declare @Table_DocNo Table (DocNo VarChar(1000))
		Insert @Table_DocNo (DocNo)
		Exec usp_GetSeriesNo 
			@DocumentSeries_Table
			, @DocumentSeries_Field
			, @DocumentSeries_Prefix
			, @DocumentSeries_Digits
		
		Declare @DocNo As VarChar(1000)
		Select Top 1 @DocNo = DocNo
		From @Table_DocNo
		
		Declare @DatePosted As DateTime
		Set @DatePosted = GetDate()
		
		Declare @Table_Document Table (DocumentID BigInt)	
		
		Insert Into Document 
			(DocNo, DateApplied, DatePosted, EmployeeID_PostedBy)
		Output
			Inserted.DocumentID
		Into
			@Table_Document
		Values
			(@DocNo, @DatePosted, @DatePosted, @EmployeeID)
		
		Declare @DocumentID As BigInt
		Select @DocumentID = DocumentID
		From @Table_Document
		
		Declare @Table_Alpp Table (AccountingLedgerPostingPeriodID BigInt)
		
		Insert Into AccountingLedgerPostingPeriod
			(DocumentID)
		Output
			Inserted.AccountingLedgerPostingPeriodID
		Into
			@Table_Alpp
		Values
			(@DocumentID)
		
		Declare @AccountingLedgerPostingPeriodID As BigInt
		Select @AccountingLedgerPostingPeriodID = AccountingLedgerPostingPeriodID
		From @Table_Alpp
		
		--[-]
		
		Insert Into AccountingLedger_Posted
			(
				AccountingLedgerPostingPeriodID
				, AccountingChartOfAccountsID
				, System_ModulesID
				, TableName
				, SourceID
				, DocNo
				, DatePosted
				, PartyID
				, Amount
				, IsDebit
			)
		Select
			@AccountingLedgerPostingPeriodID
			, AccountingChartOfAccountsID
			, System_ModulesID
			, TableName
			, SourceID
			, DocNo
			, DatePosted
			, PartyID
			, Amount
			, IsDebit
		From
			AccountingLedger_Current
		Where
			DatePosted >= @DateLastPostingPeriod
		
		Commit Transaction TrnLevel_0
		
	End Try
	Begin Catch
		Rollback Transaction TrnLevel_0
		Print Error_Message()
	End Catch
End
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_AccountingLedger_Format]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_AccountingLedger_Format]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[udf_AccountingLedger_Format]
(
	@DateStart As DateTime
	, @DateEnd As DateTime
)	
Returns Table
As
Return
	(
	Select 
		[Tb].*
		, ''Debit'' As [UnionTb]
		, Amount As [Debit_Amount]
		, Null As [Credit_Amount]
	From 
		udf_AccountingLedger(@DateStart,@DateEnd) As[Tb]
	Where
		IsNull(IsDebit,0) = 1

	Union

	Select 
		[Tb].*
		, ''Credit'' As [UnionTb]
		, Null As [Debit_Amount]
		, Amount As [Credit_Amount]
	From 
		udf_AccountingLedger(@DateStart,@DateEnd) As[Tb]
	Where
		IsNull(IsDebit,0) = 0
	)
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Accounting_TrialBalance]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_Accounting_TrialBalance]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[udf_Accounting_TrialBalance]
(
	@DateStart As DateTime
	, @DateEnd As DateTime
)	
Returns Table
As
Return
	(
	Select
		[Tb].*
	From
		(
		Select 
			[Coa].AccountingChartOfAccountsID
			, [Coa].System_LookupID_AccountType
			, [Coa].AccountCodeName
			, [Coa].AccountType_Desc
			, (
			Case
				When IsNull([Tb_Debit].Amount,0) = 0 Then
					Null
				Else
					IsNull([Tb_Debit].Amount,0)
			End
			) As [Debit_Amount]
			, (
			Case
				When IsNull([Tb_Credit].Amount,0) = 0 Then
					Null
				Else
					IsNull([Tb_Credit].Amount,0)
			End
			) As [Credit_Amount]
		From 
			uvw_AccountingChartOfAccounts As [Coa]
			Left Join
				(
				Select
					[Tb].AccountingChartOfAccountsID
					, [Tb].System_LookupID_AccountType
					, [Tb].Coa_IsDebit
					, Sum([Tb].Amount) As [Amount]
				From
					(
					Select 
						[Tb].AccountingChartOfAccountsID
						, [Tb].System_LookupID_AccountType
						, [Tb].Coa_IsDebit
						, [Tb].Amount
					From 
						udf_AccountingLedger_Amount(@DateStart,@DateEnd) As [Tb]
					Where
						IsNull([Tb].Coa_IsDebit,0) = 1
						And IsNull([Tb].IsDebit,0) = 1

					Union All
					
					Select 
						[Tb].AccountingChartOfAccountsID
						, [Tb].System_LookupID_AccountType
						, [Tb].Coa_IsDebit
						, ([Tb].Amount * -1) As [Amount]
					From 
						udf_AccountingLedger_Amount(@DateStart,@DateEnd) As [Tb]
					Where
						IsNull([Tb].Coa_IsDebit,0) = 1
						And IsNull([Tb].IsDebit,0) = 0
					) As [Tb]
				Group By
					[Tb].AccountingChartOfAccountsID
					, [Tb].System_LookupID_AccountType
					, [Tb].Coa_IsDebit
				) As [Tb_Debit]
				On [Tb_Debit].AccountingChartOfAccountsID = [Coa].AccountingChartOfAccountsID
				And [Tb_Debit].System_LookupID_AccountType = [Coa].System_LookupID_AccountType
			Left Join
				(
				Select
					[Tb].AccountingChartOfAccountsID
					, [Tb].System_LookupID_AccountType
					, [Tb].Coa_IsDebit
					, Sum([Tb].Amount) As [Amount]
				From
					(
					Select 
						[Tb].AccountingChartOfAccountsID
						, [Tb].System_LookupID_AccountType
						, [Tb].Coa_IsDebit
						, [Tb].Amount
					From 
						udf_AccountingLedger_Amount(@DateStart,@DateEnd) As [Tb]
					Where
						IsNull([Tb].Coa_IsDebit,0) = 0
						And IsNull([Tb].IsDebit,0) = 0

					Union
					
					Select 
						[Tb].AccountingChartOfAccountsID
						, [Tb].System_LookupID_AccountType
						, [Tb].Coa_IsDebit
						, ([Tb].Amount * -1) As [Amount]
					From 
						udf_AccountingLedger_Amount(@DateStart,@DateEnd) As [Tb]
					Where
						IsNull([Tb].Coa_IsDebit,0) = 0
						And IsNull([Tb].IsDebit,0) = 1
					) As [Tb]
				Group By
					[Tb].AccountingChartOfAccountsID
					, [Tb].System_LookupID_AccountType
					, [Tb].Coa_IsDebit
				) As [Tb_Credit]
				On [Tb_Credit].AccountingChartOfAccountsID = [Coa].AccountingChartOfAccountsID
				And [Tb_Credit].System_LookupID_AccountType = [Coa].System_LookupID_AccountType
		) As [Tb]
	Where
		IsNull([Tb].Debit_Amount ,0) <> 0
		Or IsNull([Tb].Credit_Amount ,0) <> 0
	)
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Accounting_IncomeStatement]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udf_Accounting_IncomeStatement]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'Create Function [dbo].[udf_Accounting_IncomeStatement]
(
	@DateStart As DateTime
	, @DateEnd As DateTime
)	
Returns Table
As
Return	
	(
	Select 
		1 As [Type]
		, ''Income'' As [TypeDesc]
		, [Tb].AccountCodeName
		, IsNull([Tb].Debit_Amount,0) + IsNull([Tb].Credit_Amount,0) As [Amount]
	From 
		udf_Accounting_TrialBalance(@DateStart,@DateEnd) As [Tb]
	Where
		[Tb].System_LookupID_AccountType = 3 --7
		Or [Tb].System_LookupID_AccountType = 8 --14
	
	Union All
	
	Select 
		2 As [Type]
		, ''Expense'' As [TypeDesc]
		, [Tb].AccountCodeName
		, IsNull([Tb].Debit_Amount,0) + IsNull([Tb].Credit_Amount,0) As [Amount]
	From 
		udf_Accounting_TrialBalance(@DateStart,@DateEnd) As [Tb]
	Where
		[Tb].System_LookupID_AccountType = 4
		Or [Tb].System_LookupID_AccountType = 7
	)
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Accounting_Report_TrialBalance]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Accounting_Report_TrialBalance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[usp_Accounting_Report_TrialBalance]
@DateStart As DateTime
, @DateEnd As DateTime
As
Begin
	Select *
	Into #Tmp
	From udf_Accounting_TrialBalance(@DateStart,@DateEnd)
	
	Select *
	From #Tmp
	
	Select 
		Sum(Debit_Amount) As [Debit_Amount]
		, Sum(Credit_Amount) As [Credit_Amount]
	From 
		#Tmp
		
	Drop Table #Tmp
	
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Accounting_Report_IncomeStatement]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Accounting_Report_IncomeStatement]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[usp_Accounting_Report_IncomeStatement]
@DateStart As DateTime
, @DateEnd As DateTime
As
Begin
	
	Select * 
	Into #Tmp
	From udf_Accounting_IncomeStatement(@DateStart,@DateEnd)
		
	Declare @Income_Amount As Numeric(18,2)
	Declare @Expense_Amount As Numeric(18,2)
	Declare @Net_Amount As Numeric(18,2)
	
	Select @Income_Amount = Sum(Amount)
	From #Tmp
	Where [Type] = 1

	Select @Expense_Amount = Sum(Amount)
	From #Tmp
	Where [Type] = 2
	
	Set @Net_Amount = IsNull(@Income_Amount,0) - IsNull(@Expense_Amount,0)
	
	Select *
	From #Tmp
	Where [Type] = 1
	
	Select *
	From #Tmp
	Where [Type] = 2
	
	Select 
		IsNull(@Income_Amount,0) As [Income_Amount]
		, IsNull(@Expense_Amount,0) As [Expense_Amount]
		, IsNull(@Net_Amount,0) As [Net_Amount]

	Drop Table #Tmp
	
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_Accounting_Report_BalanceSheet]    Script Date: 10/21/2013 12:07:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Accounting_Report_BalanceSheet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[usp_Accounting_Report_BalanceSheet]
@DateStart As DateTime
, @DateEnd As DateTime
As
Begin

	Select 
		AccountingChartOfAccountsID
		, System_LookupID_AccountType
		, AccountCodeName
		, IsNull(Debit_Amount,0) + IsNull(Credit_Amount,0) As [Amount]
	Into 
		#Tmp_TrialBalance
	From 
		udf_Accounting_TrialBalance(@DateStart,@DateEnd)

	Select * 
	Into #Tmp_IncomeStatement
	From udf_Accounting_IncomeStatement(@DateStart,@DateEnd)

	Declare @Asset_Amount As Numeric(18,2)
	Select 
		@Asset_Amount = Sum(Amount) 
	From 
		#Tmp_TrialBalance
	Where
		System_LookupID_AccountType = 1

	Declare @Liability_Amount As Numeric(18,2)
	Select 
		@Liability_Amount = Sum(Amount) 
	From 
		#Tmp_TrialBalance
	Where
		System_LookupID_AccountType = 2

	Declare @Equity_Amount As Numeric(18,2)
	Select 
		@Equity_Amount = Sum(Amount) 
	From 
		#Tmp_TrialBalance
	Where
		System_LookupID_AccountType = 5

	Declare @Income_Amount As Numeric(18,2)
	Select
		@Income_Amount = IsNull(Sum(Amount),0)
	From
		(
		Select Sum(Amount) As [Amount]
		From #Tmp_IncomeStatement
		Where [Type] = 1
		
		Union
		
		Select (Sum(Amount) * -1) As [Amount]
		From #Tmp_IncomeStatement
		Where [Type] = 2
		) As [Tb]
		
	Set @Equity_Amount = IsNull(@Equity_Amount,0) + @Income_Amount

	Select *
	From #Tmp_TrialBalance
	Where System_LookupID_AccountType = 1

	Select *
	From #Tmp_TrialBalance
	Where System_LookupID_AccountType = 2

	Select 
		1 As [Ct]
		, ''TrialBalance'' As [Table]
		, AccountingChartOfAccountsID
		, System_LookupID_AccountType
		, AccountCodeName
		, Amount
	From 
		#Tmp_TrialBalance
	Where 
		System_LookupID_AccountType = 5

	Union All

	Select
		2 As [Ct]
		, ''IncomeStatemet'' As [Table]
		, Null
		, Null
		, ''Net Income''
		, @Income_Amount As [Amount]

	Order By
		Ct

	Select
		IsNull(@Asset_Amount,0) As [Asset_Amount]
		, IsNull(@Liability_Amount,0) As [Liability_Amount]
		, IsNull(@Equity_Amount,0) As [Equity_Amount]
		, IsNull(@Liability_Amount,0) + IsNull(@Equity_Amount,0) As [LiabilityEquity_Amount]

	Drop Table #Tmp_TrialBalance
	Drop Table #Tmp_IncomeStatement
	
End
' 
END
GO
/****** Object:  StoredProcedure [dbo].[uvw_TransactionEmployeeExpense_DocumentChartOfAccounts]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionEmployeeExpense_DocumentChartOfAccounts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[uvw_TransactionEmployeeExpense_DocumentChartOfAccounts]
As
	Select 
		[Tb].* 
		, [Dcoad].AccountingChartOfAccountsID
		, [Dcoad].AccountCodeName
		, [Dcoad].AccountType_Desc
		, [Dcoad].[Desc]
		, [Dcoad].Amount
		, [Dcoad].Tax_Perc
		, [Dcoad].Tax_Amount
		, [Dcoad].Gross_Amount
	From
		uvw_TransactionEmployeeExpense As [Tb]
		Left Join uvw_DocumentChartOfAccounts_Details As [Dcoad]
			On [Dcoad].DocumentChartOfAccountsID = [Tb].DocumentChartOfAccountsID
' 
END
GO
/****** Object:  StoredProcedure [dbo].[uvw_TransactionPurchaseInvoice_DocumentChartOfAccounts]    Script Date: 10/21/2013 12:07:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uvw_TransactionPurchaseInvoice_DocumentChartOfAccounts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[uvw_TransactionPurchaseInvoice_DocumentChartOfAccounts]
As
	Select 
		[Tb].* 
		, [Dcoad].AccountingChartOfAccountsID
		, [Dcoad].AccountCodeName
		, [Dcoad].AccountType_Desc
		, [Dcoad].[Desc]
		, [Dcoad].Amount
		, [Dcoad].Tax_Perc
		, [Dcoad].Tax_Amount
		, [Dcoad].Gross_Amount
	From
		uvw_TransactionPurchaseInvoice As [Tb]
		Left Join uvw_DocumentChartOfAccounts_Details As [Dcoad]
			On [Dcoad].DocumentChartOfAccountsID = [Tb].DocumentChartOfAccountsID
' 
END
GO
