using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.Objects;
using Layer01_Common_Web;
using Layer01_Common_Web.Common;
using Layer01_Common_Web_EO;
using Layer01_Common_Web_EO.Common;
using Layer01_Common_Web_EO.Objects;
using Layer02_Objects;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects.Modules_Masterfiles;
using Layer02_Objects.Modules_Transaction;
using Layer02_Objects._System;
using Layer03_Website;
using Layer03_Website.Base;
using DataObjects_Framework;
using DataObjects_Framework.Common;

namespace Layer03_Website.Modules_UserControl
{
    public partial class Control_Customer_Details_ShippingAddress : System.Web.UI.UserControl
    {
        #region _Events

        public delegate void DsAccept(Int64 TmpKey);
        public event DsAccept EvAccept;
        
        #endregion

        #region _Variables

        const string CnsObjID = "CnsObjID";
        const string CnsObj_Customer = "CnsObj_Customer";
        const string CnsObj_Address = "CnsObj_Address";
        const string CnsTmpKey = "CnsTmpKey";

        string mObjID = "";
        ClsCustomer mObj_Customer;
        ClsAddress mObj_Address;
        Int64 mTmpKey;
        
        #endregion

        #region _Constructor

        public string Show(ClsCustomer pObj_Customer, Int64 pTmpKey = 0)
        {
            ClsSysCurrentUser CurrentUser = (ClsSysCurrentUser)this.Session[Layer01_Constants_Web.CnsSession_CurrentUser];
            this.mObjID = CurrentUser.GetNewPageObjectID();
            this.mObj_Customer = pObj_Customer;
            this.mTmpKey = pTmpKey;

            this.ViewState[CnsObjID] = this.mObjID;
            this.Session[this.mObjID + CnsObj_Customer] = this.mObj_Customer;
            this.ViewState[CnsTmpKey] = this.mTmpKey;

            this.SetupPage();

            StringBuilder Sb_Js = new StringBuilder();
            Sb_Js.Append("var EODialog = eo_GetObject('" + this.EODialog_ShippingAddress.ClientID + "'); ");
            Sb_Js.Append("EODialog.show(true); ");

            return Sb_Js.ToString();
        }

        public void AddNew(ClsCustomer pObj_Customer)
        {
            this.mObj_Customer = pObj_Customer;
            this.mTmpKey = 0;
            this.SetupPage();
            this.Update();
        }

        #endregion

        #region _EventHandlers

        protected void Page_Load(object sender, EventArgs e)
        {
            this.EOCb_Accept.Execute += new EO.Web.CallbackEventHandler(EOCb_Accept_Execute);
            this.EOCb_Cancel.Execute += new EO.Web.CallbackEventHandler(EOCb_Cancel_Execute);

            //[-]

            this.mObjID = (string)this.ViewState[CnsObjID];
            this.mObj_Customer = (ClsCustomer)this.Session[this.mObjID + CnsObj_Customer];
            this.mObj_Address = (ClsAddress)this.Session[this.mObjID + CnsObj_Address];
            this.mTmpKey = (this.ViewState[CnsTmpKey] != null) ? (Int64)this.ViewState[CnsTmpKey] : 0 ;
        }
        
        void EOCb_Accept_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            try
            { this.Update(); }
            catch (Exception Ex)
            {
                Layer01_Methods_Web.ErrorHandler(Ex, this.Server);
                throw Ex;
            }
        }

        void EOCb_Cancel_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            try
            {
                this.mObj_Customer.pObj_ShippingAddress.Delete_Item(this.mTmpKey);
                this.mTmpKey = 0;
                this.ViewState[CnsTmpKey] = this.mTmpKey;
            }
            catch (Exception Ex)
            {
                Layer01_Methods_Web.ErrorHandler(Ex, this.Server);
                throw Ex;
            }
        }

        #endregion

        #region _Methods

        void SetupPage()
        {
            DataRow[] ArrDr = this.mObj_Customer.pDt_ShippingAddress.Select("TmpKey = " + this.mTmpKey);
            DataRow Dr_ShippingAddress = null;
            if (ArrDr.Length > 0)
            { Dr_ShippingAddress = ArrDr[0]; }
            else
            { this.mTmpKey = 0; }

            if (this.mTmpKey == 0)
            {
                this.Txt_StoreCode.Text = "";

                //this.mObj_Address = new ClsAddress(this.mObj_Customer.pCurrentUser);
                //this.mObj_Address.Load();

                Dr_ShippingAddress = this.mObj_Customer.pObj_ShippingAddress.Add_Item();
                this.mTmpKey = Do_Methods.Convert_Int64(Dr_ShippingAddress["TmpKey"]);
                this.mObj_Address = this.mObj_Customer.pObj_ShippingAddress_Address_Get(this.mTmpKey);

                this.mObj_Address.pDr["Address"] = this.mObj_Customer.pDr_Address["Address"];
                this.mObj_Address.pDr["City"] = this.mObj_Customer.pDr_Address["City"];
                this.mObj_Address.pDr["LookupID_States"] = this.mObj_Customer.pDr_Address["LookupID_States"];
                this.mObj_Address.pDr["LookupID_Country"] = this.mObj_Customer.pDr_Address["LookupID_Country"];
                this.mObj_Address.pDr["ZipCode"] = this.mObj_Customer.pDr_Address["ZipCode"];

                this.UcAddress_ShippingAddress.Setup(this.mObj_Address);
                this.ViewState[CnsTmpKey] = this.mTmpKey;
            }
            else
            {
                this.Txt_StoreCode.Text = (string)Do_Methods.IsNull(Dr_ShippingAddress["StoreCode"], "");
                //this.mObj_Address = (ClsAddress)this.mObj_Customer.pBO_ShippingAddress_Address[this.mTmpKey.ToString()];
                this.mObj_Address = this.mObj_Customer.pObj_ShippingAddress_Address_Get(this.mTmpKey);
                this.UcAddress_ShippingAddress.Setup(this.mObj_Address);
            }

            this.Session[this.mObjID + CnsObj_Address] = this.mObj_Address;

            try
            { this.EOCbp_Dialog_ShippingAddress.Update(); }
            catch { }
        }

        void Update()
        {
            DataRow[] ArrDr = this.mObj_Customer.pDt_ShippingAddress.Select("", "", DataViewRowState.CurrentRows);
            foreach (DataRow Dr in ArrDr)
            { Dr["IsActive"] = false; }

            ArrDr = this.mObj_Customer.pDt_ShippingAddress.Select("TmpKey = " + this.mTmpKey.ToString(), "", DataViewRowState.CurrentRows);
            DataRow Dr_ShippingAddress = null;
            if (ArrDr.Length > 0)
            { Dr_ShippingAddress = ArrDr[0]; }
            else
            {
                throw new DataObjects_Framework.Objects.CustomException("Shipping Address Data Error.");

                //Int64 TmpKey = 0;
                //ArrDr = this.mObj_Customer.pDt_ShippingAddress.Select("", "TmpKey Desc", DataViewRowState.CurrentRows);
                //if (ArrDr.Length > 0)
                //{ TmpKey = Convert.ToInt64(ArrDr[0]["TmpKey"]); }
                //TmpKey++;

                //Dr_ShippingAddress = this.mObj_Customer.pDt_ShippingAddress.NewRow();
                //Dr_ShippingAddress["TmpKey"] = TmpKey;
                //this.mObj_Customer.pDt_ShippingAddress.Rows.Add(Dr_ShippingAddress);
                //this.mObj_Customer.pBO_ShippingAddress_Address.Add(TmpKey.ToString(), this.mObj_Address);                
            }
            
            this.UcAddress_ShippingAddress.Update();

            Dr_ShippingAddress["StoreCode"] = this.Txt_StoreCode.Text;
            Dr_ShippingAddress["IsActive"] = true;
            Dr_ShippingAddress["Address"] = Do_Methods.IsNull(this.mObj_Address.pDr["Address_Complete"], "");

            Do_Methods.ConvertCaps(Dr_ShippingAddress);

            this.mTmpKey = Convert.ToInt64(Do_Methods.IsNull(Dr_ShippingAddress["TmpKey"], 0));
            if (EvAccept != null)
            { EvAccept(this.mTmpKey); }
        }

        #endregion        
    }
}