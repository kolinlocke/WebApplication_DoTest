using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using DataObjects_Framework.Common;
using Layer01_Common_Web.Common;
using Layer03_Website.Base;
using Microsoft.VisualBasic;

namespace Layer03_Website.Modules_Master
{
    public partial class Master_Details : ClsBaseMasterDetails
    {
        #region _Constructor

        public Master_Details()
        { this.Load += new EventHandler(Page_Load); }

        #endregion

        #region _EventHandlers

        protected void Page_Load(object sender, EventArgs e)
        {
            this.Btn_Save.Click += this.Btn_Save_Click;
            this.Btn_Save2.Click += this.Btn_Save_Click;

            this.Btn_Back.Click += this.Btn_Back_Click;
            this.Btn_Back2.Click += this.Btn_Back_Click;

            this.EOSe.Command += this.EOSe_Command;
        }

        void Btn_Save_Click(object sender, EventArgs e)
        {
            try
            { this.RaiseSave(); }
            catch (Exception Ex)
            {
                Layer01_Methods_Web.ErrorHandler(Ex, this.Server);
                this.Show_EventMsg(Ex.Message, eStatus.Event_Error);
            }
        }

        void Btn_Back_Click(object sender, EventArgs e)
        { this.Back(); }

        void EOSe_Command(object sender, CommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Save":
                    this.RaiseSave_ReloadPage();
                    break;
            }
        }

        #endregion

        #region _Methods

        protected override void SetupPage_ControlAttributes(ref Control C)
        {
            WebControl Wc = null;
            if (C is WebControl)
            { Wc = (WebControl)C; }
            else
            {
                foreach (Control Ic in C.Controls)
                {
                    Control Inner_Ic = Ic;
                    this.SetupPage_ControlAttributes(ref Inner_Ic);
                }
                return;
            }

            if (Wc.GetType().ToString() == typeof(System.Web.UI.WebControls.TextBox).ToString())
            {
                if ((Wc as TextBox).TextMode != TextBoxMode.MultiLine)
                { Wc.Attributes.Add("onkeypress", "return noenter(event)"); }

                if (Wc.Attributes["onchange"] == "")
                { Wc.Attributes.Add("onchange", "RequireSave()"); }

                if ((Wc as TextBox).ReadOnly)
                { (Wc as TextBox).ReadOnly = this.pIsReadOnly; }
            }
            else if (Wc.GetType().ToString() == typeof(EO.Web.DatePicker).ToString())
            {
                Wc.Attributes.Add("onkeypress", "return noenter(event)");
                if (Wc.Attributes["onchange"] == "")
                { Wc.Attributes.Add("onchange", "RequireSave()"); }
                Wc.Enabled = !this.pIsReadOnly;
            }
            else if (
                Wc.GetType().ToString() == typeof(System.Web.UI.WebControls.CheckBox).ToString()
                || Wc.GetType().ToString() == typeof(System.Web.UI.WebControls.DropDownList).ToString()
                || Wc.GetType().ToString() == typeof(System.Web.UI.WebControls.RadioButton).ToString())
            {
                if (Wc.Attributes["onchange"] == "")
                { Wc.Attributes.Add("onchange", "RequireSave()"); }
                Wc.Enabled = !this.pIsReadOnly;
            }
            else if (
                Wc.GetType().ToString() == typeof(System.Web.UI.WebControls.LinkButton).ToString()
                || Wc.GetType().ToString() == typeof(System.Web.UI.WebControls.Button).ToString())
            {
                if (Wc.Enabled)
                { Wc.Enabled = !this.pIsReadOnly; }
            }
            else
            {
                foreach (Control Ic in C.Controls)
                {
                    Control Inner_Ic = Ic;
                    this.SetupPage_ControlAttributes(ref Inner_Ic);
                }
            }
        }

        protected override void SetupPage_ControlAttributes()
        {
            Control Obj = this.Panel_CphDetails;
            this.SetupPage_ControlAttributes(ref Obj);

            this.Btn_Save.Attributes.Add("onclick", "TempReleaseSave();");
            this.Btn_Save2.Attributes.Add("onclick", "TempReleaseSave();");
        }

        void SetupPage_CssClass(ref Control C, ref System.Text.StringBuilder Sb)
        {
            WebControl Wc = null;
            if (C is WebControl)
            {
                Wc = (WebControl)C;
                Layer01_Methods_Web.Eval_AppendJs(this.Server, ref Sb, Wc.ClientID, "class", Wc.CssClass);
                foreach (Control Ic in C.Controls)
                {
                    Control Inner_Ic = Ic;
                    this.SetupPage_CssClass(ref Inner_Ic, ref Sb);
                }
            }
            else
            {
                foreach (Control Ic in C.Controls)
                {
                    Control Inner_Ic = Ic;
                    this.SetupPage_CssClass(ref Inner_Ic, ref Sb);
                }
                return;
            }
        }

        public override string SetupPage_CssClass()
        {
            StringBuilder Sb = new StringBuilder();
            Control Obj = this.Panel_CphDetails;
            this.SetupPage_CssClass(ref Obj, ref Sb);
            return Sb.ToString();
        }

        public override void SetupPage()
        {
            if (this.CheckIsSetup())
            { return; }

            string ModuleName = (string)this.ViewState[CnsModuleName];
            if (ModuleName == "")
            {
                DataTable Dt = Do_Methods_Query.GetQuery("System_Modules", "", "System_ModulesID = " + this.mSystem_ModulesID);
                if (Dt.Rows.Count > 0)
                { ModuleName = (string)Do_Methods.IsNull(Dt.Rows[0]["Name"], "") + " Details"; }
            }

            this.Lbl_ModuleName.Text = ModuleName;

            if (
                (!this.mCurrentUser.CheckAccess(this.mSystem_ModulesID, Layer01_Common.Common.Layer01_Constants.eAccessLib.eAccessLib_New))
                && (this.mObj_Base.pKey == null))
            { throw new Exception("You have no access in this page."); }
            else if (
                (!this.mCurrentUser.CheckAccess(this.mSystem_ModulesID, Layer01_Common.Common.Layer01_Constants.eAccessLib.eAccessLib_New))
                || (!this.mCurrentUser.CheckAccess(this.mSystem_ModulesID, Layer01_Common.Common.Layer01_Constants.eAccessLib.eAccessLib_Edit))
                || (!this.mCurrentUser.CheckAccess(this.mSystem_ModulesID, Layer01_Common.Common.Layer01_Constants.eAccessLib.eAccessLib_View)))
            { throw new Exception("You have no access in this page."); }

            this.pIsReadOnly = true;
            if (
                this.mCurrentUser.CheckAccess(this.mSystem_ModulesID, Layer01_Common.Common.Layer01_Constants.eAccessLib.eAccessLib_New)
                && this.mCurrentUser.CheckAccess(this.mSystem_ModulesID, Layer01_Common.Common.Layer01_Constants.eAccessLib.eAccessLib_Edit))
            { this.pIsReadOnly = false; }

            this.Btn_Save.Enabled = !this.pIsReadOnly;
            this.Btn_Save2.Enabled = this.Btn_Save.Enabled;
            this.SetupPage_ControlAttributes();
        }

        public override void Save_Redirected()
        {
            Collection Pc = null;
            if (!(this.Session[Layer01_Constants_Web.CnsSession_TmpObj] is Collection))
            { return; }

            try
            { Pc = (Collection)this.Session[Layer01_Constants_Web.CnsSession_TmpObj]; }
            catch
            { return; }

            if (Pc != null)
            {
                this.Session.Remove(Layer01_Constants_Web.CnsSession_TmpObj);
                bool IsSave = false;
                try
                { IsSave = (bool)Pc["IsSave"]; }
                catch { }
                if (IsSave)
                { this.Show_EventMsg("Information has been saved.", eStatus.Event_Info); }
            }

        }

        public override void Show_EventMsg(string Msg, eStatus Status)
        {
            switch (Status)
            {
                case eStatus.Event_Info:
                    this.Img_Event.ImageUrl = "~/System/Images/cp_Msgbox_Info.gif";
                    break;
                case eStatus.Event_Error:
                    this.Img_Event.ImageUrl = "~/System/Images/cp_error01.gif";
                    break;
            }

            this.Lbl_Event.Text = Msg;
            this.Panel_Event.Visible = true;

            try { this.EOCbp_Event.Update(); }
            catch { }
        }

        void Back()
        {
            DataTable Dt = Do_Methods_Query.GetQuery("System_Modules", "", "System_ModulesID = " + this.mSystem_ModulesID.ToString());
            string Url = "";
            if (Dt.Rows.Count > 0)
            { Url = "~/" + (string)Do_Methods.IsNull(Dt.Rows[0]["PageUrl_List"], ""); }
            this.Response.Redirect(Url);
        }

        #endregion

        #region _Properties

        public override Button pBtn_Save
        {
            get { return this.Btn_Save; }
        }

        public override Button pBtn_Save2
        {
            get { return this.Btn_Save2; }
        }

        #endregion
    }
}