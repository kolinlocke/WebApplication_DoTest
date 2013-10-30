using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using DataObjects_Framework;
using DataObjects_Framework.BaseObjects;
using DataObjects_Framework.Common;
using DataObjects_Framework.Connection;
using DataObjects_Framework.DataAccess;
using DataObjects_Framework.Objects;
using DataObjects_Framework.PreparedQueryObjects;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.Objects;
using Layer02_Objects;
using Layer02_Objects._System;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Microsoft.VisualBasic;

namespace Layer02_Objects.Modules_Masterfiles
{
    public class ClsItem : ClsModule
    {
        #region _Constructor

        public ClsItem(ClsSysCurrentUser pCurrentUser)
        {
            this.Setup(pCurrentUser,  "Item", "uvw_Item");
            this.Setup_AddTableDetail("Item_Part", "uvw_Item_Part", "IsNull(IsDeleted,0) = 0");
            this.Setup_AddTableDetail("Item_Location", "uvw_Item_Location", "IsNull(IsDeleted,0) = 0");
            this.Setup_AddTableDetail("Item_Supplier", "uvw_Item_Supplier", "IsNull(IsDeleted,0) = 0");
        }

        #endregion

        #region _Methods

        public override bool Save(DataObjects_Framework.DataAccess.Interface_DataAccess Da = null)
        {
            bool Rv = base.Save(Da);

            Int64 ItemID = Do_Methods.Convert_Int64(this.pDr["ItemID"]);
            double Price = 0;
            DataTable Dt = Do_Methods_Query.ExecuteQuery("Select Top 1 Price From Item_PriceHistory Where ItemID = " + ItemID + " Order By DatePosted").Tables[0];

            if (Dt.Rows.Count > 0)
            { Price = Do_Methods.Convert_Double(Dt.Rows[0]["Price"]); }

            if (Price != Do_Methods.Convert_Double(this.pDr["Price"], 0))
            { this.UpdatePriceHistory(ItemID); }

            return Rv;
        }

        //[-]

        public void UpdatePriceHistory(DataRow[] ArrDr_Item)
        {
            DateTime ServerDate = Layer02_Common.GetServerDate();

            PreparedQuery Pq = Do_Methods.CreateDataAccess().CreatePreparedQuery();
            Pq.pQuery = @"Insert Into Item_PriceHistory (ItemID, Price, EmployeeID_PostedBy, DatePosted) Values (@ItemID, @Price, @EmployeeID_PostedBy, @DatePosted)";

			Pq.Add_Parameter("ItemID", Do_Constants.eParameterType.Long);
			Pq.Add_Parameter("EmployeeID_PostedBy", Do_Constants.eParameterType.Long, this.mCurrentUser.pDrUser["EmployeeID"]);
			Pq.Add_Parameter("DatePosted", Do_Constants.eParameterType.DateTime, ServerDate);
			Pq.Add_Parameter("Price", Do_Constants.eParameterType.Numeric, null, 0, 18, 2);

            Pq.Prepare();

            foreach (DataRow Dr in ArrDr_Item)
            {
                Pq.pParameter_Set("ItemID", Dr["ItemID"]);
                Pq.pParameter_Set("Price", Dr["Price"]);
                Pq.ExecuteNonQuery();
            }
        }

        public void UpdatePriceHistory(Int64 ItemID)
        {
            DataTable Dt_Item = Do_Methods_Query.GetQuery("Item", "", "ItemID = " + ItemID);
            DataRow Dr_Item = null;
            if (Dt_Item.Rows.Count > 0) Dr_Item = Dt_Item.Rows[0];
            else return;

            DateTime ServerDate = Layer02_Common.GetServerDate();
            DataTable Dt_PriceHistory = Do_Methods_Query.GetQuery("Item_PriceHistory", "", "1 = 0");
            DataRow Dr_PriceHistory = Dt_PriceHistory.NewRow();

            Dr_PriceHistory["ItemID"] = ItemID;
            Dr_PriceHistory["Price"] = Dr_Item["Price"];
            Dr_PriceHistory["EmployeeID_PostedBy"] = this.mCurrentUser.pDrUser["EmployeeID"];
            Dr_PriceHistory["DatePosted"] = ServerDate;

            Interface_DataAccess Da = Do_Methods.CreateDataAccess();
            try
            {
                Da.Connect();
                Da.SaveDataRow(Dr_PriceHistory, "Item_PriceHistory");
            }
            catch { }
            finally
            { Da.Close(); }
        }

        #endregion

        #region _Properties

        public DataTable pDt_Part
        {
            get { return this.pTableDetail_Get("Item_Part"); }
        }

        public DataTable pDt_Location
        {
            get { return this.pTableDetail_Get("Item_Location"); }
        }

        public DataTable pDt_Supplier
        {
            get { return this.pTableDetail_Get("Item_Supplier"); }
        }

        #endregion
    }
}
