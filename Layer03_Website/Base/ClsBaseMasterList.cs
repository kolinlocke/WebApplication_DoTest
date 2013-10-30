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
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects.Modules_Masterfiles;
using Layer02_Objects.Modules_Transaction;
using Layer02_Objects._System;
using Layer01_Common_Web;
using Layer01_Common_Web.Common;
using DataObjects_Framework;
using DataObjects_Framework.Common;
using DataObjects_Framework.Objects;
using DataObjects_Framework.DataAccess;

namespace Layer03_Website.Base
{
    public abstract class ClsBaseMasterList : System.Web.UI.MasterPage
    {
        
        #region _Events

        public delegate void DsGeneric();
        public delegate void DsPrint(ref string Data);
        public delegate void DsOpen(Int64 ID);
        
        public event DsGeneric EvNew;
        public event DsPrint EvPrint;
        public event DsOpen EvOpen;
        public event DsGeneric EvSetupPage_Done;
        
        #endregion
        
        #region _Variables

        protected ClsBaseMasterMenu mMaster;
        protected ClsSysCurrentUser mCurrentUser;
        protected ClsBase mObj_Base;

        protected const string CnsSystem_ModulesID = "CnsSystem_ModulesID";
        protected const string CnsObjID = "CnsObjID";
        protected const string CnsOverride_PageUrl_Details_New = "CnsOverride_PageUrl_Details_New";
        protected const string CnsIsNoSelect = "CnsIsNoSelect";
        protected const string CnsSystem_BindDefinition_Name = "CnsSystem_BindDefinition_Name";
        protected const string CnsSource = "CnsSource";
        protected const string CnsSourceKey = "CnsSourceKey";
        protected const string CnsModuleName = "CnsModuleName";

        protected Int64 mSystem_ModulesID;
        protected string mObjID = "";
        protected string mSystem_BinDefinition_Name = "";
        protected string mSource = "";
        protected string mSourceKey = "";
        
        #endregion

        #region _Constructor

        public ClsBaseMasterList()
        {
            this.Init += Page_Init;
        }

        public void Setup(
            Layer01_Common.Common.Layer01_Constants.eSystem_Modules pSystem_ModulesID
            , ClsBase pObjBase
            , string pSystem_BindDefinition_Name
            , string pOverride_PageUrl_Details_New = ""
            , string pSource = ""
            , string pSourceKey = ""
            , bool pIsNoSelect = false
            , string pModuleName = "")
        {
            this.mSystem_ModulesID = (Int64)pSystem_ModulesID;
            this.mObj_Base = pObjBase;
            this.mSystem_BinDefinition_Name = pSystem_BindDefinition_Name;

            this.ViewState[CnsSystem_ModulesID] = pSystem_ModulesID;
            this.ViewState[CnsOverride_PageUrl_Details_New] = pOverride_PageUrl_Details_New;
            this.ViewState[CnsSystem_BindDefinition_Name] = pSystem_BindDefinition_Name;
            this.ViewState[CnsSource] = pSource;
            this.ViewState[CnsSourceKey] = pSourceKey;
            this.ViewState[CnsIsNoSelect] = pIsNoSelect;
            this.ViewState[CnsModuleName] = pModuleName;
        }

        #endregion

        #region _EventHandlers

        private void Page_Init(object sender, EventArgs e)
        {
            this.mMaster = (ClsBaseMasterMenu)this.Master;
        }

        #endregion

        #region _Abstract

            #region _Methods
            
            protected abstract void SetupPage_ControlAttributes();
            protected abstract void SetupPage_ControlAttributes(ref Control C);
            public abstract void RebindGrid();
            public abstract void SetupPage_RegisterForEventValidation(ref Control C);
            public abstract void Details_Print(ref string Data);

            #endregion

            #region _Properties
            
            public abstract Button pBtn_New { get; }
            public abstract Button pBtn_Print { get; }
            public abstract EO.Web.Grid pGrid_List { get; }

            #endregion
        
        #endregion

        #region _Methods

        protected virtual void RaiseNew()
        {
            if (EvNew != null)
            { EvNew(); }
        }

        protected virtual void RaisePrint(ref string Data)
        {
            if (EvPrint != null)
            { EvPrint(ref Data); }
        }

        protected virtual void RaiseOpen(Int64 ID)
        {
            if (EvOpen != null)
            { EvOpen(ID); }
        }

        protected virtual void RaiseSetupPage_Done()
        {
            if (EvSetupPage_Done != null)
            { EvSetupPage_Done(); }
        }

        //[-]

        public void SetupPage_Done()
        { this.SetupPage_ControlAttributes(); }

        //[-]

        protected string Details_PrepareNew()
        {
            DataTable Dt = Do_Methods_Query.GetQuery("System_Modules", "", "System_ModulesID = " + this.mSystem_ModulesID.ToString());
            string Url = "";

            if (Dt.Rows.Count > 0)
            { Url = "~/" + (string)Do_Methods.IsNull(Dt.Rows[0]["PageUrl_Details"], ""); }

            string Override_PageUrl_Details_New = (string)this.ViewState[CnsOverride_PageUrl_Details_New];
            if (Override_PageUrl_Details_New != "")
            { Url = Override_PageUrl_Details_New; }

            this.Session[Layer01_Constants_Web.CnsSession_Keys] = null;

            return Url;
        }

        protected string Details_PrepareOpen(Int64 ID)
        {
            DataTable Dt = Do_Methods_Query.GetQuery("System_Modules", "", "System_ModulesID = " + this.mSystem_ModulesID.ToString());
            string Url = "";

            if (Dt.Rows.Count > 0)
            { Url = "~/" + (string)Do_Methods.IsNull(Dt.Rows[0]["PageUrl_Details"], ""); }

            this.Session[Layer01_Constants_Web.CnsSession_Keys] = null;

            QueryCondition Qc = new QueryCondition();
            Qc.Add(this.mObj_Base.pHeader_TableKey, "=", ID, typeof(Int64).ToString());
            Dt = this.List(Qc);
            if (Dt.Rows.Count > 0)
            { this.Session[Layer01_Constants_Web.CnsSession_Keys] = this.mObj_Base.GetKeys(Dt.Rows[0]); }

            return Url;
        }

        //[-]

        public void Details_New()
        {
            string Url = this.Details_PrepareNew();
            this.Response.Redirect(Url, false);
        }

        public void Details_Open(Int64 ID)
        {
            string Url = this.Details_PrepareOpen(ID);
            this.Response.Redirect(Url, false);
        }

        //[-]

        protected DataTable List(
            QueryCondition Condition = null
            , string Sort = ""
            , Int64 Top = 0
            , Int32 Page = 0)
        {
            DataRow Dr_Bind = Do_Methods_Query.GetSystemBindDefinition(this.mSystem_BinDefinition_Name);
            string Bind_Condition = (string)Do_Methods.IsNull(Dr_Bind["Condition"], "");
            string Bind_Sort = (string)Do_Methods.IsNull(Dr_Bind["Sort"], "");

            string Query_Condition = "";
            if (Bind_Condition.Trim() != "")
            { Query_Condition = " Where " + Bind_Condition; }

            string Source = (string)this.ViewState[CnsSource];
            if (Source == "")
            { Source = this.mObj_Base.pHeader_ViewName; }

            if (Sort == "")
            { Sort = Bind_Sort; }

            string Query_Table = @"(Select * From " + Source + " " + Query_Condition +  " ) As [Tb]";

            Interface_DataAccess Da = this.mObj_Base.CreateDataAccess();

            //DataTable Dt = Do_Methods_Query.GetQuery(Query_Table, "", Condition, Sort, Top, Page);
            DataTable Dt = Da.GetQuery(Query_Table, "", Condition, Sort, Top, Page);
            Da.Close();

            return Dt;
        }

        protected Int64 List_Count(QueryCondition Condition = null)
        {
            DataRow Dr_Bind = Do_Methods_Query.GetSystemBindDefinition(this.mSystem_BinDefinition_Name);
            string Bind_Condition = (string)Do_Methods.IsNull(Dr_Bind["Condition"], "");
            string Bind_Sort = (string)Do_Methods.IsNull(Dr_Bind["Sort"], "");

            string Query_Condition = "";
            if (Bind_Condition.Trim() != "")
            { Query_Condition = " Where " + Bind_Condition; }

            string Source = (string)this.ViewState[CnsSource];
            if (Source == "")
            { Source = this.mObj_Base.pHeader_ViewName; }

            string Query = @"(Select * From " + Source + " " + Query_Condition + " ) As [Tb]";

            Interface_DataAccess Da = this.mObj_Base.CreateDataAccess();
            //DataTable Dt = Do_Methods_Query.GetQuery(Query, "Count(1) As [Ct]", Condition);
            DataTable Dt = Da.GetQuery(Query, "Count(1) As [Ct]", Condition);

            Int64 Rv = 0;
            try
            { Rv = Convert.ToInt64(Do_Methods.IsNull(Dt.Rows[0]["Ct"], 0)); }
            catch { }

            return Rv;
        }

        #endregion

        #region _Properties

        public ClsBaseMasterMenu pMaster
        {
            get { return this.mMaster; }
        }

        public string pSource
        {
            get { return (string)this.ViewState[CnsSource]; }
            set { this.ViewState[CnsSource] = value; }
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