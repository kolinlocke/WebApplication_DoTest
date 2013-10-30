using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.VisualBasic;
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
using DataObjects_Framework.Objects;

namespace Layer03_Website.Modules_Page
{
    public partial class Page_Customer_Details : ClsBasePageDetails
    {

        #region _Variables

        ClsCustomer mObj;

        #endregion

        #region _Constructor

        public Page_Customer_Details()
        { this.Page.Init += new EventHandler(Page_Init); }

        #endregion

        #region _EventHandlers

        void Page_Init(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            { this.Setup(Layer01_Common.Common.Layer01_Constants.eSystem_Modules.Mas_Customer, new ClsCustomer(this.pMaster.pCurrentUser)); }
        }

        protected override void Page_Load(object sender, EventArgs e)
        {
            if (!this.CheckIsLoaded())
            {
                base.Page_Load(sender, e);
                this.mObj = (ClsCustomer)this.pObj_Base;

                this.UcSelection.EvAccept += this.Handle_Selection;
                this.UcCdsa.EvAccept += this.Handle_ShippingAddress;

                this.EOCb_Selection.Execute += new EO.Web.CallbackEventHandler(EOCb_Selection_Execute);
                this.EOCb_ShippingAddress_Add.Execute += new EO.Web.CallbackEventHandler(EOCb_ShippingAddress_Add_Execute);
                this.EOCb_ShippingAddress_Edit.Execute += new EO.Web.CallbackEventHandler(EOCb_ShippingAddress_Edit_Execute);
                this.EOCb_ShippingAddress_IsActive.Execute += new EO.Web.CallbackEventHandler(EOCb_ShippingAddress_IsActive_Execute);
                this.EOCb_ShippingAddress_Update.Execute += new EO.Web.CallbackEventHandler(EOCb_ShippingAddress_Update_Execute);
                this.EOCb_TaxCode.Execute += new EO.Web.CallbackEventHandler(EOCb_TaxCode_Execute);
                
                if (!this.IsPostBack)
                { this.SetupPage(); }
            }            
        }

        void EOCb_Selection_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            try
            {
                if (e.Parameter == this.Btn_SalesPerson.ID)
                { this.UcSelection.Show("Select_Employee"); }
            }
            catch (Exception Ex)
            {
                Layer01_Methods_Web.ErrorHandler(Ex, this.Server);
                throw Ex;
            }
        }

        void EOCb_ShippingAddress_Add_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            try
            {
                if (e.Parameter == this.Btn_AddShippingAddress.ID)
                {
                    this.UcGrid_ShippingAddress.Post();
                    e.Data = this.UcCdsa.Show(this.mObj);
                }
            }
            catch (Exception Ex)
            {
                Layer01_Methods_Web.ErrorHandler(Ex, this.Server);
                throw Ex;
            }
        }

        void EOCb_ShippingAddress_Edit_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            try
            {
                Int64 Key = 0;
                try
                { Key = Convert.ToInt64(e.Parameter); }
                catch { }
                e.Data = this.UcCdsa.Show(this.mObj, Key);
            }
            catch (Exception Ex)
            {
                Layer01_Methods_Web.ErrorHandler(Ex, this.Server);
                throw Ex;
            }
        }

        void EOCb_ShippingAddress_IsActive_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            try
            {
                Int64 Key = 0;
                try
                { Key = Convert.ToInt64(e.Parameter); }
                catch { }

                if (Key == 0)
                { return; }

                this.Details_ShippingAddress_IsActive(Key);
            }
            catch (Exception Ex)
            {
                Layer01_Methods_Web.ErrorHandler(Ex, this.Server);
                throw Ex;
            }
        }

        void EOCb_ShippingAddress_Update_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            try
            {
                this.UcAddress.Update();
                this.UcGrid_ShippingAddress.Post();
                this.UcCdsa.AddNew(this.mObj);
            }
            catch (Exception Ex)
            {
                Layer01_Methods_Web.ErrorHandler(Ex, this.Server);
                throw Ex;
            }
        }

        void EOCb_TaxCode_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            try
            { e.Data = this.Details_TaxCode(); }
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
            this.SetupPage_Lookups();

            this.Txt_Code.Text = (string)Do_Methods.IsNull(this.mObj.pDr_RowProperty["Code"], "");
            this.Txt_Company.Text = (string)Do_Methods.IsNull(this.mObj.pDr["Company"], "");
            this.Lbl_SalesPerson.Text = (string)Do_Methods.IsNull(this.mObj.pDr["EmployeeCodeName_SalesPerson"], "-Select-");
            this.Txt_CreditCard_AccountName.Text = (string)Do_Methods.IsNull(this.mObj.pDr["CreditCard_AccountName"], "");

            if (!Information.IsDBNull(this.mObj.pDr["CreditCard_Expiration"]))
            {
                DateTime CreditCard_Expiration = (DateTime)this.mObj.pDr["CreditCard_Expiration"];
                this.Txt_CreditCardExpiration_Month.Text = CreditCard_Expiration.Month.ToString();
                this.Txt_CreditCardExpiration_Year.Text = Strings.Right(CreditCard_Expiration.Year.ToString(), 2);
            }
            else
            {
                this.Txt_CreditCardExpiration_Month.Text = "";
                this.Txt_CreditCardExpiration_Year.Text = "";
            }

            this.Txt_CreditCard_Part1.Text = (string)Do_Methods.IsNull(this.mObj.pDr["CreditCardNo1"], "");
            this.Txt_CreditCard_Part2.Text = (string)Do_Methods.IsNull(this.mObj.pDr["CreditCardNo2"], "");
            this.Txt_CreditCard_Part3.Text = (string)Do_Methods.IsNull(this.mObj.pDr["CreditCardNo3"], "");
            this.Txt_CreditCard_Part4.Text = (string)Do_Methods.IsNull(this.mObj.pDr["CreditCardNo4"], "");
            this.Chk_IsCreditHold.Checked = (bool)Do_Methods.IsNull(this.mObj.pDr["IsCreditHold"], false);

            this.Lbl_PST_Value.Text = Strings.Format(Do_Methods.IsNull(this.mObj.pDr["PST_Value"], 0), "#,##0.00");
            this.Lbl_HST_Value.Text = Strings.Format(Do_Methods.IsNull(this.mObj.pDr["HST_Value"], 0), "#,##0.00");
            this.Lbl_GST_Value.Text = Strings.Format(Do_Methods.IsNull(this.mObj.pDr["GST_Value"], 0), "#,##0.00");

            DataTable Dt_Defaults = Do_Methods_Query.GetQuery("uvw_Lookup");
            this.Cbo_Currency.SelectedValue = Convert.ToInt64(Do_Methods.IsNull(this.mObj.pDr["LookupID_Currency"], this.SetupPage_GetLookupDefault(Dt_Defaults, Layer01_Common.Common.Layer01_Constants.eLookup.Currency))).ToString();
            this.Cbo_PaymentTerm.SelectedValue = Convert.ToInt64(Do_Methods.IsNull(this.mObj.pDr["LookupID_PaymentTerm"], this.SetupPage_GetLookupDefault(Dt_Defaults, Layer01_Common.Common.Layer01_Constants.eLookup.PaymentTerm))).ToString();
            this.Cbo_TaxCode.SelectedValue = Convert.ToInt64(Do_Methods.IsNull(this.mObj.pDr["LookupTaxCodeID"], 0)).ToString();
            this.Cbo_ClientType.SelectedValue = Convert.ToInt64(Do_Methods.IsNull(this.mObj.pDr["LookupClientTypeID"], this.SetupPage_GetLookupDefault(Dt_Defaults, Layer01_Common.Common.Layer01_Constants.eLookup.ClientType))).ToString();

            this.UcPerson.Setup(this.mObj.pObj_Person);
            this.UcAddress.Setup(this.mObj.pObj_Address);

            this.UcGrid_ShippingAddress.Setup(
                "Customer_ShippingAddress"
                , this.mObj.pDt_ShippingAddress
                , "TmpKey"
                , false
                , true
                , this.mMaster.pIsReadOnly);
            this.UcGrid_ShippingAddress.pGrid.ClientSideOnItemCommand = "EOGrid_ItemCommand";

        }

        void SetupPage_Lookups()
        {
            Layer01_Methods_Web.BindCombo(ref this.Cbo_Currency, Do_Methods_Query.GetLookup("Currency"), "LookupID", "Desc", 0, "-Select-");
            Layer01_Methods_Web.BindCombo(ref this.Cbo_PaymentTerm, Do_Methods_Query.GetLookup("PaymentTerm"), "LookupID", "Desc", 0, "-Select-");
            Layer01_Methods_Web.BindCombo(ref this.Cbo_ShipVia, Do_Methods_Query.GetLookup("ShipVia"), "LookupID", "Desc", 0, "-Select-");
            Layer01_Methods_Web.BindCombo(
                ref this.Cbo_TaxCode
                , Do_Methods_Query.GetQuery("LookupTaxCode","","IsNull(IsDeleted,0) = 0 And IsNull(IsActive,0) = 1")
                , "LookupTaxCodeID"
                , "Desc"
                , 0
                , "-Select-");
            Layer01_Methods_Web.BindCombo(
                ref this.Cbo_ClientType
                , Do_Methods_Query.GetQuery("LookupClientType", "", "IsNull(IsDeleted,0) = 0 And IsNull(IsActive,0) = 1")
                , "LookupClientTypeID"
                , "Desc"
                , 0
                , "-Select-");
        }

        protected override void Save()
        {
            System.Text.StringBuilder Sb_ErrorMsg = new System.Text.StringBuilder();
            if (!this.Save_Validation(ref Sb_ErrorMsg))
            {
                this.Show_EventMsg(Sb_ErrorMsg.ToString(), ClsBaseMasterDetails.eStatus.Event_Error);
                return;
            }

            this.UcPerson.Update();
            this.UcAddress.Update();

            this.mObj.pDr_RowProperty["Code"] = this.Txt_Code.Text;
            this.mObj.pDr["Company"] = this.Txt_Company.Text;
            this.mObj.pDr["LookupTaxCodeID"] = Convert.ToInt64(this.Cbo_TaxCode.SelectedValue);
            this.mObj.pDr["LookupClientTypeID"] = Convert.ToInt64(this.Cbo_ClientType.SelectedValue);
            this.mObj.pDr["LookupID_ShipVia"] = Convert.ToInt64(this.Cbo_ShipVia.SelectedValue);
            this.mObj.pDr["LookupID_Currency"] = Convert.ToInt64(this.Cbo_Currency.SelectedValue);
            this.mObj.pDr["LookupID_PaymentTerm"] = Convert.ToInt64(this.Cbo_PaymentTerm.SelectedValue);

            this.mObj.pDr["IsCreditHold"] = this.Chk_IsCreditHold.Checked;
            this.mObj.pDr["CreditCard_AccountName"] = this.Txt_CreditCard_AccountName.Text;

            Int32 CreditCardExpiration_Month = 0;
            Int32 CreditCardExpiration_Year = 0;

            try
            {
                Int32.TryParse(this.Txt_CreditCardExpiration_Month.Text, out CreditCardExpiration_Month);
                if (this.Txt_CreditCardExpiration_Year.Text.Trim() != "")
                { Int32.TryParse("20" + this.Txt_CreditCardExpiration_Year.Text, out CreditCardExpiration_Year); }
            }
            catch { }

            if (
                (this.Txt_CreditCardExpiration_Month.Text.Trim() == ""
                || this.Txt_CreditCardExpiration_Year.Text.Trim() == ""))
            { this.mObj.pDr["CreditCard_Expiration"] = DBNull.Value; }
            else
            {
                try
                { this.mObj.pDr["CreditCard_Expiration"] = new DateTime(CreditCardExpiration_Year, CreditCardExpiration_Month, 1); }
                catch
                { this.mObj.pDr["CreditCard_Expiration"] = DBNull.Value; }
            }

            this.mObj.pDr["CreditCard_CVV"] = this.Txt_CreditCard_CVV.Text;

            this.mObj.pDr["CreditCardNo1"] = this.Txt_CreditCard_Part1.Text;
            this.mObj.pDr["CreditCardNo2"] = this.Txt_CreditCard_Part2.Text;
            this.mObj.pDr["CreditCardNo3"] = this.Txt_CreditCard_Part3.Text;
            this.mObj.pDr["CreditCardNo4"] = this.Txt_CreditCard_Part4.Text;

            this.mObj.pDr["CreditLimit"] = Do_Methods.Convert_Double(this.Txt_CreditLimit.Text);

            Do_Methods.ConvertCaps(this.mObj.pDr_RowProperty);
            Do_Methods.ConvertCaps(this.mObj.pDr_Person);
            Do_Methods.ConvertCaps(this.mObj.pDr_Address);
            Do_Methods.ConvertCaps(this.mObj.pDr);

            base.Save();
        }

        bool Save_Validation(ref System.Text.StringBuilder Sb_Msg)
        {
            WebControl Wc;
            bool IsValid = true;

            this.Txt_Code.CssClass = Layer01_Constants_Web.CnsCssTextbox;
            if (this.Txt_Code.Text.Trim() == "")
            { this.Txt_Code.Text = Layer02_Common.GetSeriesNo("Customer"); }

            Wc = this.Txt_Code;
            Layer01_Methods_Web.Save_Validation(
                ref Sb_Msg
                , ref Wc
                , ref IsValid
                , Layer01_Constants_Web.CnsCssTextbox
                , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                , Layer02_Common.CheckSeriesDuplicate("uvw_Customer", "CustomerCode", this.mObj.GetKeys(), this.Txt_Code.Text)
                , "Duplicate Customer ID found. Please change the Customer ID. <br />");

            Int64 LookupClientTypeID = Convert.ToInt64(Do_Methods.IsNull(this.mObj.pDr["LookupClientTypeID"], 0));
            DataTable Dt = Do_Methods_Query.GetQuery("LookupClientType", "", "LookupClientTypeID = " + LookupClientTypeID.ToString());
            if (Dt.Rows.Count > 0)
            {
                DataRow Dr_ClientType = Dt.Rows[0];

                if ((bool)Do_Methods.IsNull(Dr_ClientType["IsCurrency"], false))
                {
                    Wc = this.Cbo_Currency;
                    Layer01_Methods_Web.Save_Validation(
                        ref Sb_Msg
                        , ref Wc
                        , ref IsValid
                        , Layer01_Constants_Web.CnsCssTextbox
                        , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                        , (Convert.ToInt64(this.Cbo_Currency.SelectedValue) == 0)
                        , "Currency is required. <br />");
                }
                
                if ((bool)Do_Methods.IsNull(Dr_ClientType["IsCreditCard_AccountName"], false))
                {
                    Wc = this.Txt_CreditCard_AccountName;
                    Layer01_Methods_Web.Save_Validation(
                        ref Sb_Msg
                        , ref Wc
                        , ref IsValid
                        , Layer01_Constants_Web.CnsCssTextbox
                        , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                        , (this.Txt_CreditCard_AccountName.Text == "")
                        , "Account Name is required. <br />");
                }

                if ((bool)Do_Methods.IsNull(Dr_ClientType["IsCreditCard"], false))
                {
                    bool Inner_IsValid = true;
                    this.Txt_CreditCard_Part1.CssClass = Layer01_Constants_Web.CnsCssTextbox;
                    this.Txt_CreditCard_Part2.CssClass = Layer01_Constants_Web.CnsCssTextbox;
                    this.Txt_CreditCard_Part3.CssClass = Layer01_Constants_Web.CnsCssTextbox;
                    this.Txt_CreditCard_Part4.CssClass = Layer01_Constants_Web.CnsCssTextbox;

                    if (this.Txt_CreditCard_Part1.Text.Trim() == "") Inner_IsValid = false;
                    if (this.Txt_CreditCard_Part2.Text.Trim() == "") Inner_IsValid = false;
                    if (this.Txt_CreditCard_Part3.Text.Trim() == "") Inner_IsValid = false;
                    if (this.Txt_CreditCard_Part4.Text.Trim() == "") Inner_IsValid = false;

                    if (!Inner_IsValid)
                    {
                        IsValid = false;
                        this.Txt_CreditCard_Part1.CssClass = Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight;
                        this.Txt_CreditCard_Part2.CssClass = Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight;
                        this.Txt_CreditCard_Part3.CssClass = Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight;
                        this.Txt_CreditCard_Part4.CssClass = Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight;
                        Sb_Msg.Append("Credit Card is required. <br />");
                    }
                }


                Int32 CreditCardExpiration_Month = 0;
                Int32 CreditCardExpiration_Year = 0;

                try
                {
                    Int32.TryParse(this.Txt_CreditCardExpiration_Month.Text, out CreditCardExpiration_Month);
                    if (this.Txt_CreditCardExpiration_Year.Text.Trim() != "")
                    { Int32.TryParse("20" + this.Txt_CreditCardExpiration_Year.Text, out CreditCardExpiration_Year); }
                }
                catch { }

                this.Txt_CreditCardExpiration_Month.CssClass = Layer01_Constants_Web.CnsCssTextbox;
                this.Txt_CreditCardExpiration_Year.CssClass = Layer01_Constants_Web.CnsCssTextbox;

                if (!
                    (this.Txt_CreditCardExpiration_Month.Text.Trim() == "" 
                    || this.Txt_CreditCardExpiration_Year.Text.Trim() == ""))
                {
                    DateTime Inner_DateTime;
                    try
                    {
                        Inner_DateTime = new DateTime(CreditCardExpiration_Year, CreditCardExpiration_Month, 1);
                        if (Inner_DateTime < DateTime.Now)
                        {
                            IsValid = false;
                            this.Txt_CreditCardExpiration_Month.CssClass = Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight;
                            this.Txt_CreditCardExpiration_Year.CssClass = Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight;
                            Sb_Msg.Append("Credit Card Date Expiry must be earlier than today. <br />");
                        }
                    }
                    catch 
                    {
                        IsValid = false;
                        this.Txt_CreditCardExpiration_Month.CssClass = Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight;
                        this.Txt_CreditCardExpiration_Year.CssClass = Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight;
                        Sb_Msg.Append("Credit Card Date Expiry is incorrect. <br />");
                    }
                }

                if ((bool)Do_Methods.IsNull(Dr_ClientType["IsCreditCard_Expiration"], false))
                {
                    if (this.Txt_CreditCardExpiration_Month.Text.Trim() == ""
                        || this.Txt_CreditCardExpiration_Year.Text.Trim() == "")
                    {
                        IsValid = false;
                        this.Txt_CreditCardExpiration_Month.CssClass = Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight;
                        this.Txt_CreditCardExpiration_Year.CssClass = Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight;
                        Sb_Msg.Append("Credit Card Date Expiry is required. <br />");
                    }
                }

                if ((bool)Do_Methods.IsNull(Dr_ClientType["IsPaymentTerm"], false))
                { 
                    Wc = this.Cbo_PaymentTerm;
                    Layer01_Methods_Web.Save_Validation(
                        ref Sb_Msg
                        , ref Wc
                        , ref IsValid
                        , Layer01_Constants_Web.CnsCssTextbox
                        , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                        , (Convert.ToInt64(this.Cbo_PaymentTerm.SelectedValue) == 0)
                        , "Payment Term is required. <br />");
                }

                if ((bool)Do_Methods.IsNull(Dr_ClientType["IsTaxCode"], false))
                {
                    Wc = this.Cbo_TaxCode;
                    Layer01_Methods_Web.Save_Validation(
                        ref Sb_Msg
                        , ref Wc
                        , ref IsValid
                        , Layer01_Constants_Web.CnsCssTextbox
                        , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                        , (Convert.ToInt64(this.Cbo_TaxCode.SelectedValue) == 0)
                        , "Tax Code is required. <br />");
                }
            }

            return IsValid;
        }

        //[-]

        void Handle_Selection(DataTable Dt, EO.Web.CallbackEventArgs e, string Data)
        {
            if (Dt.Rows.Count > 0)
            {
                Int64 ID = Convert.ToInt64(Do_Methods.IsNull(Dt.Rows[0]["ID"], 0));
                e.Data = this.Details_SelectEmployee(ID);
            }
        }

        string Details_SelectEmployee(Int64 ID)
        {
            this.mObj.pDr["EmployeeID_SalesPerson"] = ID;

            System.Text.StringBuilder Sb_Js = new System.Text.StringBuilder();
            DataTable Dt = Do_Methods_Query.GetQuery("uvw_Employee", "", "EmployeeID = " + ID.ToString());
            if (Dt.Rows.Count > 0)
            {
                this.Lbl_SalesPerson.Text = (string)Do_Methods.IsNull(Dt.Rows[0]["EmployeeCodeName"], "");
                Layer01_Methods_Web.Eval_AppendJs(this.Server, ref Sb_Js, this.Lbl_SalesPerson.ClientID, "innerHTML", this.Lbl_SalesPerson.Text);
            }

            return Sb_Js.ToString();
        }

        void Handle_ShippingAddress(long TmpKey)
        {
            this.UcGrid_ShippingAddress.Rebind();
            this.Details_ShippingAddress_IsActive(TmpKey);
        }

        void Details_ShippingAddress_IsActive(Int64 TmpKey)
        {
            this.UcGrid_ShippingAddress.Post();
            DataRow[] ArrDr = this.mObj.pDt_ShippingAddress.Select("TmpKey <> " + TmpKey);
            foreach (DataRow Dr in ArrDr)
            { Dr["IsActive"] = false; }

            ArrDr = this.mObj.pDt_ShippingAddress.Select("TmpKey = " + TmpKey);
            if (ArrDr.Length > 0)
            { ArrDr[0]["IsActive"] = true; }

            this.UcGrid_ShippingAddress.Rebind();
        }

        string Details_TaxCode()
        {
            System.Text.StringBuilder Sb_Js = new System.Text.StringBuilder();
            Int64 LookupTaxCodeID = 0;
            try
            { LookupTaxCodeID = Convert.ToInt64(this.Cbo_TaxCode.SelectedValue); }
            catch { }

            DataTable Dt = Do_Methods_Query.GetQuery("LookupTaxCode", "", "LookupTaxCodeID = " + LookupTaxCodeID);
            if (Dt.Rows.Count > 0)
            {
                DataRow Dr = Dt.Rows[0];
                Layer01_Methods_Web.Eval_AppendJs(this.Server, ref Sb_Js, this.Lbl_PST_Value.ClientID, "innerHTML", Strings.Format(Do_Methods.IsNull(Dr["PST_Value"], 0), "#,##0.00"));
                Layer01_Methods_Web.Eval_AppendJs(this.Server, ref Sb_Js, this.Lbl_GST_Value.ClientID, "innerHTML", Strings.Format(Do_Methods.IsNull(Dr["GST_Value"], 0), "#,##0.00"));
                Layer01_Methods_Web.Eval_AppendJs(this.Server, ref Sb_Js, this.Lbl_HST_Value.ClientID, "innerHTML", Strings.Format(Do_Methods.IsNull(Dr["HST_Value"], 0), "#,##0.00"));
            }
            return Sb_Js.ToString();
        }

        #endregion
        
    }
}