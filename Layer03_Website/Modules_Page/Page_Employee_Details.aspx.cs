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

namespace Layer03_Website.Modules_Page
{
    public partial class Page_Employee_Details : ClsBasePageDetails
    {

        #region _Variables

        ClsEmployee mObj;

        #endregion

        #region _Constructor

        public Page_Employee_Details()
        { this.Page.Init += new EventHandler(Page_Init); }

        #endregion
        
        #region _EventHandlers

        void Page_Init(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            { this.Setup(Layer01_Constants.eSystem_Modules.Mas_Employee, new ClsEmployee(this.pMaster.pCurrentUser)); }
        }

        protected override void Page_Load(object sender, EventArgs e)
        {
            if (!this.CheckIsLoaded())
            {
                base.Page_Load(sender, e);
                this.mObj = (ClsEmployee)this.pObj_Base;

                if (!this.IsPostBack)
                { this.SetupPage(); }
            }
        }

        #endregion

        #region _Methods

        void SetupPage()
        {
            this.SetupPage_Lookups();

            this.Txt_EmployeeCode.Text = (string)Do_Methods.IsNull(this.mObj.pDr["EmployeeCode"], "");

            this.Txt_LeaveVacation.Text = Convert.ToInt32(Do_Methods.IsNull(this.mObj.pDr["Leave_Vacation"], 0)).ToString("#,##0"); //Methods.Convert_Int32(this.mObj.pDr["Leave_Vacation"]).ToString();
            this.Txt_LeaveSick.Text = Convert.ToInt32(Do_Methods.IsNull(this.mObj.pDr["Leave_Sick"], 0)).ToString("#,##0"); //Methods.Convert_Int32(this.mObj.pDr["Leave_Sick"]).ToString();
            this.Txt_LeaveBereavement.Text = Convert.ToInt32(Do_Methods.IsNull(this.mObj.pDr["Leave_Bereavement"], 0)).ToString("#,##0"); //Methods.Convert_Int32(this.mObj.pDr["Leave_Bereavement"]).ToString();

            this.Txt_Position.Text = (string)Do_Methods.IsNull(this.mObj.pDr["Position"], "");
            this.Txt_Pay.Text = Do_Methods.Convert_Double(this.mObj.pDr["Pay"].ToString()).ToString("#,##0.00");
            this.Txt_SIN.Text = (string)Do_Methods.IsNull(this.mObj.pDr["SIN"], "");

            this.EODtp_DateHired.VisibleDate = DateTime.Now;
            this.EODtp_DateHired.SelectedDate = !Microsoft.VisualBasic.Information.IsDBNull(this.mObj.pDr["DateHired"]) ? (DateTime)this.mObj.pDr["DateHired"] : new DateTime();

            this.EODtp_DateTerminate.VisibleDate = DateTime.Now;
            this.EODtp_DateTerminate.SelectedDate = !Microsoft.VisualBasic.Information.IsDBNull(this.mObj.pDr["DateTerminate"]) ? (DateTime)this.mObj.pDr["DateTerminate"] : new DateTime();

            DataTable Dt_Defaults = Do_Methods_Query.GetQuery("uvw_Lookup");
            this.Cbo_Department.SelectedValue = ((Int64)Do_Methods.IsNull(this.mObj.pDr["LookupID_Department"], this.SetupPage_GetLookupDefault(Dt_Defaults, Layer01_Constants.eLookup.Department))).ToString();
            this.Cbo_PayRate.SelectedValue = ((Int64)Do_Methods.IsNull(this.mObj.pDr["LookupID_PayRate"], this.SetupPage_GetLookupDefault(Dt_Defaults, Layer01_Constants.eLookup.PayRate))).ToString();
            this.Cbo_EmployeeType.SelectedValue = ((Int64)Do_Methods.IsNull(this.mObj.pDr["LookupID_EmployeeType"], this.SetupPage_GetLookupDefault(Dt_Defaults, Layer01_Constants.eLookup.EmployeeType))).ToString();

            this.UcPerson.Setup(this.mObj.pObj_Person);
            this.UcAddress.Setup(this.mObj.pObj_Address);
        }

        void SetupPage_Lookups()
        {
            Layer01_Methods_Web.BindCombo(ref this.Cbo_Department, Do_Methods_Query.GetLookup("Department"), "LookupID", "Desc", 0, "-Select-");
            Layer01_Methods_Web.BindCombo(ref this.Cbo_PayRate, Do_Methods_Query.GetLookup("PayRate"), "LookupID", "Desc", 0, "-Select-");
            Layer01_Methods_Web.BindCombo(ref this.Cbo_EmployeeType, Do_Methods_Query.GetLookup("EmployeeType"), "LookupID", "Desc", 0, "-Select-");
        }

        protected override void Save()
        {
            System.Text.StringBuilder Sb_ErrorMsg = new System.Text.StringBuilder();
            if (!this.Save_Validation(ref Sb_ErrorMsg))
            {
                this.Show_EventMsg(Sb_ErrorMsg.ToString(), ClsBaseMasterDetails.eStatus.Event_Error);
                return;
            }

            //[-]

            this.mObj.pDr_RowProperty["Code"] = this.Txt_EmployeeCode.Text;
            this.mObj.pDr["Leave_Vacation"] = Do_Methods.Convert_Int32(this.Txt_LeaveSick.Text);
            this.mObj.pDr["Leave_Sick"] = Do_Methods.Convert_Int32(this.Txt_LeaveSick.Text);
            this.mObj.pDr["Leave_Bereavement"] = Do_Methods.Convert_Int32(this.Txt_LeaveBereavement.Text);
            this.mObj.pDr["Position"] = this.Txt_Position.Text;
            this.mObj.pDr["LookupID_Department"] = Do_Methods.Convert_Int64(this.Cbo_Department.SelectedValue);
            this.mObj.pDr["LookupID_PayRate"] = Do_Methods.Convert_Int64(this.Cbo_PayRate.SelectedValue);
            this.mObj.pDr["LookupID_EmployeeType"] = Do_Methods.Convert_Int64(this.Cbo_EmployeeType.SelectedValue);
            this.mObj.pDr["SIN"] = this.Txt_SIN.Text;
            this.mObj.pDr["Pay"] = Do_Methods.Convert_Double(this.Txt_Pay.Text);

            this.UcPerson.Update();
            this.UcAddress.Update();

            Do_Methods.ConvertCaps(this.mObj.pDr_RowProperty);
            Do_Methods.ConvertCaps(this.mObj.pDr_Person);
            Do_Methods.ConvertCaps(this.mObj.pDr);

            //[-]

            base.Save();
        }

        bool Save_Validation(ref System.Text.StringBuilder Sb_Msg)
        {
            WebControl Wc;
            bool IsValid = true;

            this.Txt_EmployeeCode.CssClass = Layer01_Constants_Web.CnsCssTextbox;
            if (this.Txt_EmployeeCode.Text.Trim() == "")
            { this.Txt_EmployeeCode.Text = Layer02_Common.GetSeriesNo("Item"); }

            Wc = this.Txt_EmployeeCode;
            ClsBasePageDetails.Save_Validation(
                ref Sb_Msg
                , ref Wc
                , ref IsValid
                , Layer01_Constants_Web.CnsCssTextbox
                , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                , (Layer02_Common.CheckSeriesDuplicate("uvw_Employee", "EmployeeCode", this.mObj.GetKeys(), this.Txt_EmployeeCode.Text))
                , "Duplicate Employee ID found. Please change the Employee ID." + "<br />");

            Wc = null;
            ClsBasePageDetails.Save_Validation(
                ref Sb_Msg
                , ref Wc
                , ref IsValid
                , string.Empty
                , string.Empty
                , (this.EODtp_DateHired.SelectedDate == null)
                , "Hired Date is required" + "<br />");

            if (!this.UcPerson.Update_Validate(ref Sb_Msg))
            { IsValid = false; }

            return IsValid;
        }

        #endregion

    }
}