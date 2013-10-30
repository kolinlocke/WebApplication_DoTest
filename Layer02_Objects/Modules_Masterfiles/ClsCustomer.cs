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
using DataObjects_Framework.BaseObjects;
using DataObjects_Framework.Objects;

namespace Layer02_Objects.Modules_Masterfiles
{
    public class ClsCustomer: ClsEntity_Person
    {
        #region _Variables

        //ClsCustomer_ShippingAddress mObj_ShippingAddress;
        //ClsBaseObjs mBO_ShippingAddress_Address = new ClsBaseObjs();
        ClsContactPerson mObj_ContactPerson;

        #endregion

        #region _Constructor

        public ClsCustomer(ClsSysCurrentUser CurrentUser)
        {
            //this.Setup(Layer01_Common.Common.Layer01_Constants.eSystem_LookupPartyType.Customer, CurrentUser, "Customer", "uvw_Customer");
            this.Setup(Layer01_Common.Common.Layer01_Constants.eSystem_LookupPartyType.Customer, CurrentUser, "Customer", "Materialized_Customer", "Materialized_Customer");
            this.Setup_AddTableDetail("Customer_Receipt", "", "IsNull(IsDeleted,0) = 0");
            //this.Setup_AddTableDetail("Customer_ShippingAddress", "uvw_Customer_ShippingAddress", "IsNull(IsDeleted,0) = 0");
            this.Setup_AddListDetail("Customer_ShippingAddress", new ClsCustomer_ShippingAddress(CurrentUser));
            this.Setup_EnableCache();

            this.mObj_ContactPerson = new ClsContactPerson(this.mCurrentUser);
            //this.mObj_ShippingAddress = new ClsCustomer_ShippingAddress(CurrentUser);
        }

        #endregion

        #region _Methods

        public override void Load(Keys Keys = null)
        {
            base.Load(Keys);

            //[-]

            Int64 ContactPersonID = Convert.ToInt64(Do_Methods.IsNull(this.pDr["ContactPersonID"], 0));

            if (ContactPersonID != 0)
            {
                Keys = new Keys();
                Keys.Add("ContactPersonID", ContactPersonID);
            }
            else
            { Keys = null; }

            this.mObj_ContactPerson.Load(Keys);

            //this.mObj_ShippingAddress.Load(Keys, this);

            //[-]

            //foreach (DataRow Dr in this.pDt_ShippingAddress.Rows)
            //{
            //    ClsAddress Inner_Obj = new ClsAddress(this.mCurrentUser);
            //    Keys Inner_Keys = null;
            //    Int64 Inner_ID = Convert.ToInt64(Do_Methods.IsNull(Dr["AddressID"], 0));
            //    if (Inner_ID != 0)
            //    {
            //        Inner_Keys = new Keys();
            //        Inner_Keys.Add("AddressID", Inner_ID);
            //    }
            //    Inner_Obj.Load(Inner_Keys);
            //    this.mBO_ShippingAddress_Address.Add(Convert.ToInt64(Do_Methods.IsNull(Dr["TmpKey"], 0)).ToString(), Inner_Obj);
            //}
        }

        public override bool Save(DataObjects_Framework.DataAccess.Interface_DataAccess Da = null)
        {
            this.mObj_ContactPerson.Save(Da);
            this.pDr["ContactPersonID"] = this.mObj_ContactPerson.pDr["ContactPersonID"];

            //foreach (ClsBaseObjs.Str_Obj Obj in this.mBO_ShippingAddress_Address.pList_Obj)
            //{
            //    Obj.Obj.Save();
            //    DataRow[] Inner_ArrDr = this.pDt_ShippingAddress.Select("TmpKey = " + Obj.Name);
            //    if (Inner_ArrDr.Length > 0)
            //    { Inner_ArrDr[0]["AddressID"] = Obj.Obj.pDr["AddressID"]; }
            //}

            base.Save(Da);

            //this.mObj_ShippingAddress.Save(Da);

            return true;
        }

        #endregion

        #region _Properties

        public DataTable pDt_Contact
        {
            get { return this.pTableDetail_Get("Customer_Contact"); }
        }

        public DataTable pDt_Receipt
        {
            get { return this.pTableDetail_Get("Customer_Receipt"); }
        }

        public DataTable pDt_ShippingAddress
        {
            get 
            { 
                //return this.pTableDetail_Get("Customer_ShippingAddress"); 
                return this.pObj_ShippingAddress.pDt_List;
            }
        }

        public DataTable pDt_ContactPerson
        {
            get { return this.mObj_ContactPerson.pDt_ContactPerson; }
        }

        public ClsContactPerson pObj_ContactPerson
        {
            get { return this.mObj_ContactPerson; }
        }

        //public ClsBaseObjs pBO_ShippingAddress_Address
        //{
        //    get { return this.mBO_ShippingAddress_Address; }
        //}

        public ClsCustomer_ShippingAddress pObj_ShippingAddress
        {
            get 
            { 
                //return this.mObj_ShippingAddress; 
                return (ClsCustomer_ShippingAddress)this.pListDetail_Get("Customer_ShippingAddress");
            }
        }

        public ClsAddress pObj_ShippingAddress_Address_Get(Int64 TmpKey)
        { return this.pObj_ShippingAddress.pObj_Address_Get(TmpKey); }

        #endregion
    }
}
