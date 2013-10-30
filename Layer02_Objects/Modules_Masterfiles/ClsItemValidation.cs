using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Layer01_Common;
using Layer02_Objects;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Masterfiles;
using Layer02_Objects._System;
using DataObjects_Framework;
using DataObjects_Framework.Common;

namespace Layer02_Objects.Modules_Masterfiles
{
	public class ClsItemValidation : ClsValidation
	{
		public enum eErrors : int
		{
			Err_Code,
			Err_Name
		}

		public override bool Validate()
		{
			base.mList_ValidationError.Clear();
			ClsItem Obj = (ClsItem)base.mBase;
			
			if (Do_Methods.Convert_String(Obj.pDr_RowProperty["Code"]) == "")
			{ Obj.pDr_RowProperty["Code"] = Layer02_Common.GetSeriesNo("Item"); }

			if (
				Layer02_Common.CheckSeriesDuplicate(
				"uvw_Item"
				, "Code"
				, Obj.GetKeys()
				, Do_Methods.Convert_String(Obj.pDr_RowProperty["Code"]))
				)
			{ 
				base.AddError(
					eErrors.Err_Code.ToString()
					, "Duplicate Item No. found. Please change the Item No."); ;
			}

			if (Do_Methods.Convert_String(Obj.pDr_RowProperty["Name"]) != "")
			{
				base.AddError(
					eErrors.Err_Name.ToString()
					, "Item Name is required.");
			}

			return base.mList_ValidationError.Count == 0;
		}
	}
}
