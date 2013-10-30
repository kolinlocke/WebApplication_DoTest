using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using Microsoft.VisualBasic;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.Objects;
using Layer01_Common_Web;
using Layer01_Common_Web.Common;
using Layer01_Common_Web.Objects;
using Layer01_Common_Web_EO;
using Layer01_Common_Web_EO.Common;
using Layer01_Common_Web_EO.Objects;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects.Modules_Masterfiles;
using Layer02_Objects.Modules_Transaction;
using Layer02_Objects._System;
using Layer03_Website;
using Layer03_Website.Base;
using Layer03_Website.Modules_Master;

namespace Layer03_Website.Modules_Master
{
    public partial class Master_ExList : ClsBaseMasterList
    {

        #region _Variables

        const string CnsList_Gc = "CnsList_Gc";
        List<ClsBindGridColumn> mList_Gc;

        #endregion

        #region _Events

        public delegate void DsAjax(string Cmd, string Data, out string DataOut);

        public event DsAjax EvAjax;

        #endregion

        #region _EventHandlers

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            { this.mList_Gc = (List<ClsBindGridColumn>)this.ViewState[CnsList_Gc]; }
            catch { }

            //[-]

            this.EvAjax += new DsAjax(Master_ExList_EvAjax);
            this.AjaxCallback();

            if (!this.IsPostBack)
            {
                this.SetupPage();
            }
        }

        void Master_ExList_EvAjax(string Cmd, string Data, out string DataOut)
        {
            DataOut = "";
            if (Cmd == "List")
            {
                JqGrid_Dt JDt = new JqGrid_Dt(this.mObj_Base.List(), this.mList_Gc);
                DataOut = JDt.Serialize();
            }
        }

        #endregion
        
        #region _Methods

        void SetupPage()
        {

            List<ClsBindGridColumn> List_Gc = Layer01_Methods_Web.GetBindGridColumn(this.mSystem_BinDefinition_Name);
            this.ViewState[CnsList_Gc] = List_Gc;
            this.mList_Gc = List_Gc;

            JqGrid_DtBind JDtBind = new JqGrid_DtBind(List_Gc);
            string Json_ColNames = JDtBind.Serialize_ColNames();
            string Json_ColModel = JDtBind.Serialize_ColModel();

            System.Text.StringBuilder Sb_Js = new System.Text.StringBuilder();
            Sb_Js.Append(@"var Grid_ColNames = " + Json_ColNames + @";");
            Sb_Js.Append(@"var Grid_ColModel = " + Json_ColModel + @";");

            this.Page.ClientScript.RegisterClientScriptBlock(typeof(string), this.ClientID, Sb_Js.ToString(), true);
        }

        protected override void SetupPage_ControlAttributes()
        {
            throw new NotImplementedException();
        }

        protected override void SetupPage_ControlAttributes(ref Control C)
        {
            throw new NotImplementedException();
        }

        public override void RebindGrid()
        {
            throw new NotImplementedException();
        }

        public override void SetupPage_RegisterForEventValidation(ref Control C)
        {
            throw new NotImplementedException();
        }

        public override void Details_Print(ref string Data)
        {
            throw new NotImplementedException();
        }

        void AjaxCallback()
        {
            if (this.Request["IsAjax"] == "1")
            {
                string Cmd = this.Request.Params["Cmd"];
                string Data = this.Request.Params["Data"];
                string DataOut = "";

                if (EvAjax != null)
                { EvAjax(Cmd, Data, out DataOut); }

                this.Response.Clear();
                this.Response.ContentType = "text/plain";
                this.Response.Write(DataOut);
                this.Response.End();
            }
        }
        
        #endregion

        #region _Properties

        public override Button pBtn_New
        {
            get { throw new NotImplementedException(); }
        }

        public override Button pBtn_Print
        {
            get { throw new NotImplementedException(); }
        }

        public override EO.Web.Grid pGrid_List
        {
            get { throw new NotImplementedException(); }
        }

        #endregion

    }

}