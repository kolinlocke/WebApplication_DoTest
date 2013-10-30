using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Microsoft.VisualBasic;
using Layer01_Common;
using Layer01_Common.Common;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects._System;
using DataObjects_Framework;
using DataObjects_Framework.Common;
using DataObjects_Framework.Objects;

namespace Layer02_Objects.Modules_Masterfiles
{
    public class ClsCustomer_ShippingAddress : ClsBase_List
    {
        public ClsCustomer_ShippingAddress(ClsSysCurrentUser CurrentUser)
        {
            QueryCondition Qc = new QueryCondition();
            Qc.Add("IsDeleted", "0", "0");
            base.Setup("Customer_ShippingAddress", "uvw_Customer_ShippingAddress", Qc);
            
            //[-]

            List<Do_Constants.Str_ForeignKeyRelation> FetchKeys = new List<Do_Constants.Str_ForeignKeyRelation>();
            FetchKeys.Add(new Do_Constants.Str_ForeignKeyRelation("CustomerID", "CustomerID"));

            List<Do_Constants.Str_ForeignKeyRelation> ForeignKeys = new List<Do_Constants.Str_ForeignKeyRelation>();
            ForeignKeys.Add( new Do_Constants.Str_ForeignKeyRelation("AddressID", "AddressID"));

            base.Setup_AddListObject(
                "Address"
                , new ClsAddress(null)
                , new List<object>() { CurrentUser }
                , "uvw_Address_Customer_ShippingAddress"
                , FetchKeys
                , ForeignKeys);
        }

        public ClsAddress pObj_Address_Get(Int64 TmpKey)
        { return (ClsAddress)this.pObj_ListObject_Get("Address", TmpKey); }
    }
}
