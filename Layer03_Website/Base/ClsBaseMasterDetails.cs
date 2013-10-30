using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using DataObjects_Framework.Common;
using DataObjects_Framework.Objects;
using Layer01_Common_Web.Common;
using Layer02_Objects._System;
using Layer02_Objects.Modules_Base.Abstract;
using Microsoft.VisualBasic;

namespace Layer03_Website.Base
{
    public abstract class ClsBaseMasterDetails: MasterPage
    {
        #region _Events

        public delegate void DsGeneric();

        public event DsGeneric EvSave;
        public event DsGeneric EvSave_Reload;

        #endregion

        #region _Variables

        protected ClsBaseMasterMenu mMaster;
        protected ClsSysCurrentUser mCurrentUser;
        protected ClsBase mObj_Base;
        protected bool mIsLoaded = false;
        protected bool mIsSetup = false;

        protected const string CnsSystem_ModulesID = "CnsSystem_ModulesID";
        protected const string CnsObjID = "CnsObjID";
        protected const string CnsIsReadOnly = "CnsIsReadOnly";
        protected const string CnsModuleName = "CnsModuleName";
        
        protected Int64 mSystem_ModulesID;
        protected string mObjID = "";
        protected bool mIsReadOnly = false;

        public enum eStatus : int
        { 
            Event_Info
            , Event_Error
        }

        #endregion

        #region _Constructor

        public ClsBaseMasterDetails() 
        {
            this.Init += new EventHandler(Page_Init);
            this.Load += new EventHandler(Page_Load);
        }

        public void Setup(
            Keys Keys
            , Layer01_Common.Common.Layer01_Constants.eSystem_Modules pSystem_ModulesID
            , ClsBase pObjBase
            , string pModuleName = "")
        {
            this.mSystem_ModulesID = (Int64)pSystem_ModulesID;
            this.ViewState[CnsSystem_ModulesID] = pSystem_ModulesID;
            this.ViewState[CnsModuleName] = pModuleName;
            this.mObj_Base = pObjBase;
            this.mObj_Base.Load(Keys);

            this.mCurrentUser = this.mMaster.pCurrentUser;
            this.mObjID = this.mCurrentUser.GetNewPageObjectID();
            this.ViewState[CnsObjID] = this.mObjID;
            this.Session[this.mObjID] = this.mObj_Base;
        }

        #endregion

        #region _EventHandlers

        void Page_Init(object sender, EventArgs e)
        { this.mMaster = (ClsBaseMasterMenu)this.Master; }

        void Page_Load(object sender, EventArgs e)
        {
            if (!this.CheckIsLoaded())
            {
                try
                {
                    this.mCurrentUser = this.mMaster.pCurrentUser;
                    this.mSystem_ModulesID = (Int64)this.ViewState[CnsSystem_ModulesID];
                    this.mIsReadOnly = this.pIsReadOnly;
                    this.mObjID = (string)this.ViewState[CnsObjID];
                    this.mObj_Base = (ClsBase)this.Session[this.mObjID];

                    if(!this.IsPostBack)
                    {
                        this.SetupPage();
                        this.Save_Redirected();
                    }

                    this.SetupPage_ControlAttributes();

                }
                catch (Exception ex)
                {
                    Layer01_Methods_Web.ErrorHandler(ex, this.Server);
                    throw ex;
                }
            }
        }

        #endregion

        #region _Abstract

            #region _Methods

            public abstract void SetupPage();
            protected abstract void SetupPage_ControlAttributes();
            protected abstract void SetupPage_ControlAttributes(ref Control C);
            public abstract string SetupPage_CssClass();
            public abstract void Save_Redirected();
            public abstract void Show_EventMsg(string Msg, eStatus Status);

            #endregion

            #region _Properties

            public abstract Button pBtn_Save
            { get; }

            public abstract Button pBtn_Save2
            { get; }

            #endregion

        #endregion

        #region _Methods

        protected bool CheckIsLoaded()
        {
            bool Rv = this.mIsLoaded;
            this.mIsLoaded = true;
            return Rv; 
        }

        protected bool CheckIsSetup()
        {
            bool Rv = this.mIsSetup;
            this.mIsSetup = true;
            return Rv;
        }

        protected virtual void RaiseSave()
        {
            if (EvSave != null)
            { EvSave(); }
        }

        public void Save()
        {
            if (!this.pIsReadOnly)
            {
                this.mObj_Base.Save();
                if (EvSave_Reload != null)
                { EvSave_Reload(); }
            }
            else
            { throw new Exception("You are not allowed to save this document."); }
        }

        public void Save_ReloadPage()
        {
            this.Session.Remove(this.mObjID);

            Collection PageCollection = new Collection();
            PageCollection.Add(true, "IsSave");

            this.Session[Layer01_Constants_Web.CnsSession_TmpObj] = PageCollection;
            this.Session[Layer01_Constants_Web.CnsSession_Keys] = this.mObj_Base.GetKeys();

            DataTable Dt = Do_Methods_Query.GetQuery("System_Modules", "", "System_ModulesID = " + this.mSystem_ModulesID.ToString());
            string Url = "";
            if (Dt.Rows.Count > 0)
            { Url = "~/" + (string)Do_Methods.IsNull(Dt.Rows[0]["PageUrl_Details"], ""); }

            this.Response.Redirect(Url);
        }

        public virtual void RaiseSave_ReloadPage()
        {
            if (EvSave_Reload != null)
            { EvSave_Reload(); }
        }

        #endregion

        #region _Properties

        public ClsBaseMasterMenu pMaster
        {
            get { return this.mMaster; }
        }

        public Int64 pSystem_ModulesID
        {
            get { return this.mSystem_ModulesID; }
        }

        public string pObjID
        {
            get
            {
                this.mObjID = (string)this.ViewState[CnsObjID];
                return this.mObjID;
            }

        }

        public ClsBase pObj_Base
        {
            get
            {
                this.mObj_Base = (ClsBase)this.Session[(string)this.pObjID];
                return this.mObj_Base;
            }
        }

        public bool pIsReadOnly
        {
            get 
            { 
                bool Rv = false;
                try
                {
                    if (this.ViewState[CnsIsReadOnly] == null)
                    { return Rv; }
                    Rv = (bool)this.ViewState[CnsIsReadOnly]; 
                }
                catch { }
                return Rv;
            }
            set
            { this.ViewState[CnsIsReadOnly] = value; }
        }
        
        #endregion

        #region _Properties_MasterPage

        public void pCurrentUser_New()
        { this.mMaster.pCurrentUser_New(); }

        public string pServerRoot
        {
            get { return this.mMaster.pServerRoot; }
        }

        public ClsSysCurrentUser pCurrentUser
        {
            get { return this.mMaster.pCurrentUser; }
            set { this.mMaster.pCurrentUser = value; }
        }

        #endregion
    }
}