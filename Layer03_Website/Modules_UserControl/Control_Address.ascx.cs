using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
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
    public partial class Control_Address : System.Web.UI.UserControl
    {

        #region _Variables

        const string CnsObjID = "CnsObjID";
        const string CnsObj_Address = "CnsObj_Address";

        string mObjID = "";
        ClsAddress mObj_Address;

        #endregion

        #region _Constructor

        public void Setup(ClsAddress pObj_Address)
        {
            ClsSysCurrentUser CurrentUser = (ClsSysCurrentUser)this.Session[Layer01_Constants_Web.CnsSession_CurrentUser];
            this.mObjID = CurrentUser.GetNewPageObjectID();
            this.mObj_Address = pObj_Address;

            this.ViewState[CnsObjID] = this.mObjID;
            this.Session[this.mObjID + CnsObj_Address] = this.mObj_Address;
            this.SetupPage();
        }

        #endregion

        #region _EventHandlers

        protected void Page_Load(object sender, EventArgs e)
        {
            this.mObjID = (string)this.ViewState[CnsObjID];
            this.mObj_Address = (ClsAddress)this.Session[this.mObjID + CnsObj_Address];
        }

        #endregion

        #region _Methods

        void SetupPage()
        {
            this.SetupPage_ControlAttributes();
            this.SetupPage_Lookups();

            ClsAddress Obj = this.mObj_Address;
            this.Txt_Address.Text = (string)Do_Methods.IsNull(Obj.pDr["Address"], "");
            this.Txt_City.Text = (string)Do_Methods.IsNull(Obj.pDr["City"], "");
            this.Txt_ZipCode.Text = (string)Do_Methods.IsNull(Obj.pDr["ZipCode"], "");

            try
            { this.Cbo_State.SelectedValue = Convert.ToInt64(Do_Methods.IsNull(Obj.pDr["LookupID_States"], 0)).ToString(); }
            catch { }

            try
            { this.Cbo_Country.SelectedValue = Convert.ToInt64(Do_Methods.IsNull(Obj.pDr["LookupID_Country"], 0)).ToString(); }
            catch { }
        }

        void SetupPage_ControlAttributes()
        {
            this.Txt_Address.Attributes.Add("onkeypress", "return noenter(event);");
            this.Txt_City.Attributes.Add("onkeypress", "return noenter(event);");
            this.Txt_ZipCode.Attributes.Add("onkeypress", "return noenter(event);");
        }

        void SetupPage_Lookups()
        {
            Layer01_Methods_Web.BindCombo(ref this.Cbo_State, Do_Methods_Query.GetLookup("States"), "LookupID", "Desc", 0, "-Select-");
            Layer01_Methods_Web.BindCombo(ref this.Cbo_Country, Do_Methods_Query.GetLookup("Country"), "LookupID", "Desc", 0, "-Select-");
        }

        public void Update()
        {
            ClsAddress Obj = this.mObj_Address;
            Obj.pDr["Address"] = this.Txt_Address.Text;
            Obj.pDr["City"] = this.Txt_City.Text;
            Obj.pDr["ZipCode"] = this.Txt_ZipCode.Text;
            Obj.pDr["LookupID_States"] = Convert.ToInt64(this.Cbo_State.SelectedValue);
            Obj.pDr["LookupID_Country"] = Convert.ToInt64(this.Cbo_Country.SelectedValue);

            System.Text.StringBuilder Sb_Address = new System.Text.StringBuilder();
            Sb_Address.Append(this.Txt_Address.Text);
            Sb_Address.Append("\r " + this.Txt_City.Text);
            Sb_Address.Append("\r " + (this.Cbo_State.SelectedValue == "0" ? "" : this.Cbo_State.SelectedItem.Text));
            Sb_Address.Append("\r " + this.Txt_ZipCode.Text);
            Sb_Address.Append("\r " + (this.Cbo_Country.SelectedValue == "0" ? "" : this.Cbo_Country.SelectedItem.Text));

            Obj.pDr["Address_Complete"] = Sb_Address.ToString();

            Do_Methods.ConvertCaps(Obj.pDr);
        }

        public bool Update_Validate(ref System.Text.StringBuilder Sb_Msg)
        {
            bool IsValid = true;
            ClsAddress Obj = this.mObj_Address;
            WebControl Wc;

            Wc = this.Txt_Address;
            ClsBasePageDetails.Save_Validation(
                ref Sb_Msg
                , ref Wc
                , ref IsValid
                , Layer01_Constants_Web.CnsCssTextbox
                , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                , (this.Txt_Address.Text.Trim() == "")
                , "Address is required." + "<br />");

            Wc = this.Txt_City;
            ClsBasePageDetails.Save_Validation(
                ref Sb_Msg
                , ref Wc
                , ref IsValid
                , Layer01_Constants_Web.CnsCssTextbox
                , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                , (this.Txt_City.Text.Trim() == "")
                , "City is required." + "<br />");

            Wc = this.Txt_ZipCode;
            ClsBasePageDetails.Save_Validation(
                ref Sb_Msg
                , ref Wc
                , ref IsValid
                , Layer01_Constants_Web.CnsCssTextbox
                , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                , (this.Txt_ZipCode.Text.Trim() == "")
                , "Zip Code is required." + "<br />");

            Wc = this.Cbo_State;
            ClsBasePageDetails.Save_Validation(
                ref Sb_Msg
                , ref Wc
                , ref IsValid
                , Layer01_Constants_Web.CnsCssTextbox
                , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                , (this.Cbo_State.SelectedValue == "0")
                , "Province / State is required." + "<br />");

            Wc = this.Cbo_Country;
            ClsBasePageDetails.Save_Validation(
                ref Sb_Msg
                , ref Wc
                , ref IsValid
                , Layer01_Constants_Web.CnsCssTextbox
                , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                , (this.Cbo_Country.SelectedValue == "0")
                , "Country is required." + "<br />");

            return IsValid;
        }

        #endregion

        #region _Properties

        public ClsAddress pObj_Address
        {
            get
            { return this.mObj_Address; }
        }

        #endregion

    }
}