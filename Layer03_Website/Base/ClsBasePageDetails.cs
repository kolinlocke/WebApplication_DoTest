using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using DataObjects_Framework.Common;
using DataObjects_Framework.Objects;
using Layer01_Common.Common;
using Layer01_Common_Web.Common;
using Layer02_Objects._System;
using Layer02_Objects.Modules_Base.Abstract;
using Microsoft.VisualBasic;

namespace Layer03_Website.Base
{
    public class ClsBasePageDetails : Page
    {
        #region _Variables

        protected ClsBaseMasterDetails mMaster;
        protected ClsSysCurrentUser mCurrentUser;
        protected Int64 mSystem_ModulesID;
        protected bool mIsLoaded = false;
        protected Collection mSessionPageObj;

        protected const string CnsSystem_ModulesID = "CnsSystem_ModulesID";
        protected const string CnsIsLoaded = "CnsIsLoaded";
        protected const string CnsSessionPageObj = "CnsSessionPageObj";

        #endregion

        #region _Constructor

        public ClsBasePageDetails()
        {
            this.Page.PreInit += new EventHandler(Page_PreInit);
            this.Page.Load += new EventHandler(Page_Load);
        }

        protected virtual void Setup(
            Layer01_Constants.eSystem_Modules pSystem_ModulesID
            , ClsBase pObj_Base
            , string pModuleName = "")
        {
            Keys Keys = null;
            try
            {
                Keys = (Keys)this.Session[Layer01_Constants_Web.CnsSession_Keys];
                this.Session[Layer01_Constants_Web.CnsSession_Keys] = null;
            }
            catch { }

            this.mMaster.Setup(Keys, pSystem_ModulesID, pObj_Base, pModuleName);
            this.mSystem_ModulesID = (Int64)pSystem_ModulesID;
            this.Session[this.mMaster.pObjID + CnsSessionPageObj] = new Collection();
        }

        #endregion

        #region _EventHandlers

        protected virtual void Page_PreInit(object sender, EventArgs e)
        {
            //this.MasterPageFile = "~/Modules_Master/Master_Details.master";
            //this.Master.MasterPageFile = "~/Modules_Master/Master_Menu.master";
            this.mMaster = (ClsBaseMasterDetails)this.Master;

            this.mMaster.EvSave += this.Save;
            this.mMaster.EvSave_Reload += this.Save_ReloadPage;
        }

        protected virtual void Page_Load(object sender, EventArgs e)
        {
            this.mCurrentUser = this.mMaster.pCurrentUser;
            this.mSessionPageObj = (Collection)this.Session[this.mMaster.pObjID + CnsSessionPageObj];

            if (!this.IsPostBack)
            { this.ViewState[CnsSystem_ModulesID] = this.mSystem_ModulesID; }
            else
            { this.mSystem_ModulesID = (Int64)this.ViewState[CnsSystem_ModulesID]; }
        }

        #endregion

        #region _Methods

        protected virtual void Save()
        { this.mMaster.Save(); }

        protected virtual void Save_ReloadPage()
        { this.mMaster.Save_ReloadPage(); }

        protected void Show_EventMsg(string Msg, ClsBaseMasterDetails.eStatus Status)
        { this.mMaster.Show_EventMsg(Msg, Status); }

        protected void Show_EventMsg(List<String> Msg, ClsBaseMasterDetails.eStatus Status)
        {
            StringBuilder Sb = new StringBuilder();
            foreach (String St in Msg)
            { Sb.Append(St + @"<br />"); }

            this.Show_EventMsg(Sb.ToString(), Status);
        }

        protected bool CheckIsLoaded()
        {
            bool Rv = this.mIsLoaded;
            this.mIsLoaded = true;
            return Rv;

        }

        protected Int64 SetupPage_GetLookupDefault(DataTable Dt_Lookup, Layer01_Common.Common.Layer01_Constants.eLookup Lkp)
        {
            Int64 DefaultID = 0;
            DataRow[] ArrDr = Dt_Lookup.Select("LookupID = " + ((Int32)Lkp).ToString());
            if (ArrDr.Length > 0)
            { DefaultID = Convert.ToInt64(Do_Methods.IsNull(ArrDr[0]["Lookup_DetailsID_Default"], 0)); }
            return DefaultID;
        }

        protected void SetupPage_ControlAttributes_BindEOCallback(WebControl Wc, EO.Web.Callback EOCb)
        { Layer01_Common_Web_EO.Common.Layer01_Methods_Web_EO.BindEOCallBack(Wc, EOCb, this.Page); }

        public static bool Save_Validation(
            ref System.Text.StringBuilder Sb_Msg
            , ref WebControl Wc
            , ref bool IsValid_Ref
            , string CssNormal
            , string CssValidateHightlight
            , bool IsValid
            , string InvalidMsg)
        {
            if (IsValid)
            {
                if (Wc != null)
                { Wc.CssClass = CssNormal; }
            }
            else
            {
                if (Wc != null)
                { Wc.CssClass = CssValidateHightlight; }
                Sb_Msg.Append(InvalidMsg);
            }
            return IsValid;
        }

        #endregion

        #region _Properties

        public new ClsBaseMasterDetails Master
        {
            get { return (ClsBaseMasterDetails)base.Master; }
        }

        public ClsBaseMasterDetails pMaster
        {
            get { return this.mMaster; }
        }

        public ClsBase pObj_Base
        {
            get { return this.mMaster.pObj_Base; }
        }

        #endregion
    }
}