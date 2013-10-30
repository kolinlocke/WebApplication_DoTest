using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft;
using Microsoft.VisualBasic;
using Microsoft.JScript;
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
    public partial class Control_Person : System.Web.UI.UserControl
    {
        #region _Variables

        const string CnsObjID = "CnsObjID";
        const string CnsObj_Person = "CnsObj_Person";

        string mObjID = "";
        ClsPerson mObj_Person;

        #endregion

        #region _Constructor

        public void Setup(ClsPerson pObj_Person)
        {
            ClsSysCurrentUser CurrentUser = (ClsSysCurrentUser)this.Session[Layer01_Constants_Web.CnsSession_CurrentUser];
            this.mObjID = CurrentUser.GetNewPageObjectID();
            this.mObj_Person = pObj_Person;

            this.ViewState[CnsObjID] = this.mObjID;
            this.Session[this.mObjID + CnsObj_Person] = this.mObj_Person;

            this.SetupPage();
        }

        #endregion

        #region _EventHandlers

        protected void Page_Load(object sender, EventArgs e)
        {
            this.EOCb_Txt_Changed.Execute += new EO.Web.CallbackEventHandler(EOCb_Txt_Changed_Execute);

            //[-]

            this.mObjID = (string)this.ViewState[CnsObjID];
            this.mObj_Person = (ClsPerson)this.Session[this.mObjID + CnsObj_Person];
        }

        void EOCb_Txt_Changed_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            System.Text.StringBuilder Sb_Js = new System.Text.StringBuilder();

            if (e.Parameter == this.Txt_Phone.ID)
            {
                this.Details_FormatPhoneNo(ref this.Txt_Phone);
                Layer01_Methods_Web.Eval_AppendJs(this.Server, ref Sb_Js, this.Txt_Phone.ClientID, "value", this.Txt_Phone.Text);
            }
            else if (e.Parameter == this.Txt_Mobile.ID)
            {
                this.Details_FormatPhoneNo(ref this.Txt_Mobile);
                Layer01_Methods_Web.Eval_AppendJs(this.Server, ref Sb_Js, this.Txt_Mobile.ClientID, "value", this.Txt_Mobile.Text);
            }
            else if (e.Parameter == this.Txt_Fax.ID)
            {
                this.Details_FormatPhoneNo(ref this.Txt_Fax);
                Layer01_Methods_Web.Eval_AppendJs(this.Server, ref Sb_Js, this.Txt_Fax.ClientID, "value", this.Txt_Fax.Text);
            }

            e.Data = Sb_Js.ToString();
        }
        
        #endregion

        #region _Methods

        void SetupPage()
        {
            this.SetupPage_ControlAttributes();

            ClsPerson Obj = this.mObj_Person;

            this.Txt_FirstName.Text = (string)Do_Methods.IsNull(Obj.pDr["FirstName"], "");
            this.Txt_MiddleName.Text = (string)Do_Methods.IsNull(Obj.pDr["MiddleName"], "");
            this.Txt_LastName.Text = (string)Do_Methods.IsNull(Obj.pDr["LastName"], "");

            this.Txt_Phone.Text = (string)Do_Methods.IsNull(Obj.pDr["Phone"], "");
            this.Txt_Mobile.Text = (string)Do_Methods.IsNull(Obj.pDr["Mobile"], "");
            this.Txt_Fax.Text = (string)Do_Methods.IsNull(Obj.pDr["Fax"], "");
            this.Txt_Email.Text = (string)Do_Methods.IsNull(Obj.pDr["Email"], "");
            this.Txt_Email_Work.Text = (string)Do_Methods.IsNull(Obj.pDr["WorkEmail"], "");

            this.EODtp_BirthDate.VisibleDate = DateTime.Now;
            if (!Microsoft.VisualBasic.Information.IsDBNull(Obj.pDr["BirthDate"]))
            { this.EODtp_BirthDate.SelectedDate = (DateTime)Obj.pDr["BirthDate"]; }
            else
            { this.EODtp_BirthDate.SelectedDate = new DateTime(); }
        }

        void SetupPage_ControlAttributes()
        {
            Layer01_Methods_Web.AddControlAttributes(this.Txt_Mobile, this.Page, "onchange", @"Txt_Changed('" + this.Txt_Mobile.ID + @"',e);", new string[] { "e" }, new string[] { "this" });
            Layer01_Methods_Web.AddControlAttributes(this.Txt_Phone, this.Page, "onchange", @"Txt_Changed('" + this.Txt_Phone.ID + @"',e);", new string[] { "e" }, new string[] { "this" });
            Layer01_Methods_Web.AddControlAttributes(this.Txt_Fax, this.Page, "onchange", @"Txt_Changed('" + this.Txt_Fax.ID + @"',e);", new string[] { "e" }, new string[] { "this" });
        }

        public void Update()
        {
            ClsPerson Obj = this.mObj_Person;

            Obj.pDr["FirstName"] = this.Txt_FirstName.Text;
            Obj.pDr["MiddleName"] = this.Txt_MiddleName.Text;
            Obj.pDr["LastName"] = this.Txt_LastName.Text;

            System.Text.StringBuilder Sb_FullName = new System.Text.StringBuilder();
            Sb_FullName.Append(this.Txt_FirstName.Text);
            Sb_FullName.Append(" ");
            Sb_FullName.Append(this.Txt_MiddleName.Text);
            Sb_FullName.Append(" ");
            Sb_FullName.Append(this.Txt_LastName.Text);

            Obj.pDr["FullName"] = Sb_FullName.ToString();

            this.Details_FormatPhoneNo(ref this.Txt_Phone);
            this.Details_FormatPhoneNo(ref this.Txt_Mobile);
            this.Details_FormatPhoneNo(ref this.Txt_Fax);

            Obj.pDr["Phone"] = this.Txt_Phone.Text;
            Obj.pDr["Mobile"] = this.Txt_Mobile.Text;
            Obj.pDr["Fax"] = this.Txt_Fax.Text;
            Obj.pDr["Email"] = this.Txt_Email.Text;
            Obj.pDr["WorkEmail"] = this.Txt_Email_Work.Text;

            try
            { Obj.pDr["BirthDate"] = this.EODtp_BirthDate.SelectedDate; }
            catch
            { Obj.pDr["BirthDate"] = DBNull.Value; }

            Do_Methods.ConvertCaps(Obj.pDr);
        }

        public bool Update_Validate(ref System.Text.StringBuilder Sb_Msg)
        {
            bool IsValid = true;
            WebControl Wc;

            Wc = this.Txt_FirstName;
            Layer01_Methods_Web.Save_Validation(
                ref Sb_Msg
                , ref Wc
                , ref IsValid
                , Layer01_Constants_Web.CnsCssTextbox
                , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                , (this.Txt_FirstName.Text.Trim() != "")
                , "First Name is required. <br />");

            Wc = this.Txt_MiddleName;
            Layer01_Methods_Web.Save_Validation(
                ref Sb_Msg
                , ref Wc
                , ref IsValid
                , Layer01_Constants_Web.CnsCssTextbox
                , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                , (this.Txt_MiddleName.Text.Trim() != "")
                , "Middle Name is required. <br />");

            Wc = this.Txt_LastName;
            Layer01_Methods_Web.Save_Validation(
                ref Sb_Msg
                , ref Wc
                , ref IsValid
                , Layer01_Constants_Web.CnsCssTextbox
                , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                , (this.Txt_LastName.Text.Trim() != "")
                , "Last Name is required. <br />");

            Wc = this.EODtp_BirthDate;
            Layer01_Methods_Web.Save_Validation(
                ref Sb_Msg
                , ref Wc
                , ref IsValid
                , Layer01_Constants_Web.CnsCssTextbox
                , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                , (this.EODtp_BirthDate.SelectedDate == null)
                , "Date of Birth is required. <br />");

            return IsValid;
        }

        void Details_FormatPhoneNo(ref TextBox TextBox)
        {
            System.Text.RegularExpressions.MatchCollection Matches = System.Text.RegularExpressions.Regex.Matches(TextBox.Text, "[0-9]");
            TextBox.Text = "";
            System.Text.StringBuilder Sb = new System.Text.StringBuilder();
            foreach (System.Text.RegularExpressions.Match Match in Matches)
            { Sb.Append(Match.Value); }
            string Formatted = "";
            Formatted = Sb.ToString();

            Sb.Clear();            
            try
            { Sb.Append("(" + Do_Methods.TextFiller(Strings.Mid(Formatted, 1, 3), "0", 3) + ")"); }
            catch { }
            try
            { Sb.Append("-" + Do_Methods.TextFiller(Strings.Mid(Formatted, 4, 3), "0", 3) + ""); }
            catch { }
            try
            { Sb.Append("-" + Do_Methods.TextFiller(Strings.Mid(Formatted, 7, 4), "0", 3) + ""); }
            catch { }

            TextBox.Text = Sb.ToString();
        }

        #endregion

    }
}