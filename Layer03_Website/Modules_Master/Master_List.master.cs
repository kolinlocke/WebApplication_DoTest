using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using DataObjects_Framework.Common;
using DataObjects_Framework.Objects;
using Layer01_Common_Web.Common;
using Layer01_Common_Web_EO.Common;
using Layer01_Common_Web_EO.Objects;
using Layer02_Objects.Modules_Base.Abstract;
using Layer03_Website.Base;
using Microsoft.VisualBasic;

namespace Layer03_Website.Modules_Master
{
    public partial class Master_List : ClsBaseMasterList
    {
        #region _Variables

        protected const string CnsDt_FilterFields = "CnsDt_FilterFields";
        protected const string CnsObj_QueryCondition = "CnsObj_QueryCondition";
        protected const string CnsFilterString = "CnsFilterString";
        protected const string CnsOrderString = "CnsOrderString";
        protected const string CnsDisplayFilterString = "CnsDisplayFilterString";
        protected const string CnsDisplayOrderString = "CnsDisplayOrderString";
        protected const string CnsItemsMax = "CnsItemsMax";

        #endregion

        #region _Constructor

        public Master_List()
        { this.Load += new EventHandler(Page_Load); }

        #endregion

        #region _EventHandlers

        protected void Page_Load(object sender, EventArgs e)
        {
            this.SetupPage_Handlers();

            try
            {
                this.mCurrentUser = this.mMaster.pCurrentUser;
                this.mSystem_ModulesID = (Int64)this.ViewState[CnsSystem_ModulesID];
                this.mSystem_BinDefinition_Name = (string)this.ViewState[CnsSystem_BindDefinition_Name];

                if (!this.IsPostBack)
                {
                    this.mObjID = this.mCurrentUser.GetNewPageObjectID();
                    this.ViewState[CnsObjID] = this.mObjID;
                    this.Session[this.mObjID] = this.mObj_Base;
                    this.SetupPage();
                }
                else
                {
                    this.mObjID = (string)this.ViewState[CnsObjID];
                    this.mObj_Base = (ClsBase)this.Session[this.mObjID];
                }
            }
            catch (Exception ex)
            {
                //ErrorHandler Method Here
                throw ex;
            }
        }

        protected void EOCb_Search_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            if (e.Parameter == this.Btn_NewSearch.ID)
            {
                this.Selection_ClearFilters();
                this.Selection_AddFilter();
            }
            else if (e.Parameter == this.Btn_AddSearch.ID)
            { this.Selection_AddFilter(); }
            else if (e.Parameter == this.Btn_SortAsc.ID)
            { this.Selection_AddSort(true); }
            else if (e.Parameter == this.Btn_SortDesc.ID)
            { this.Selection_AddSort(false); }
            else if (e.Parameter == this.Btn_Clear.ID)
            { this.Selection_ClearFilters(); }

            this.RebindGrid();

            string ViewState_DisplayFilterString = (string)this.ViewState[CnsDisplayFilterString];
            string ViewState_DisplayOrderString = (string)this.ViewState[CnsDisplayOrderString];

            string Desc_Count = "";
            string Desc_Filter = "";
            string Desc_Sort = "";

            Desc_Count = this.Details_ItemsCount() + @"<br /><br />";

            if (ViewState_DisplayFilterString != "")
            { Desc_Filter = "Filtered By: " + ViewState_DisplayFilterString + @"<br /><br />"; }

            if (ViewState_DisplayOrderString != "")
            { Desc_Sort = "Sorted By: " + ViewState_DisplayOrderString + @"<br /><br />"; }

            this.Lbl_AppliedFilters.Text = Desc_Count + Desc_Filter + Desc_Sort;

            try
            {
                this.EOCbp_Grid.Update();
                this.EOCbp_Applied.Update();
                this.EOCb_Page.Update();
            }
            catch { }
        }

        protected void Btn_New_Click(object sender, EventArgs e)
        { this.RaiseNew(); }

        protected void EOCb_Print_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            string Data = e.Data;
            this.RaisePrint(ref Data);

            Collection Obj_Collection = new Collection();
            Obj_Collection.Add(true, "IsDownloadFile");
            Obj_Collection.Add(this.ResolveUrl(e.Data), "DownloadFle");
            this.Session[Layer01_Common_Web.Common.Layer01_Constants_Web.CnsSession_TmpObj] = Obj_Collection;

            string Url = this.ResolveUrl("~/System/Download.aspx");
            e.Data = Url;
        }

        protected void EOSe_Command(object sender, System.Web.UI.WebControls.CommandEventArgs e)
        {
            Int64 ID = 0;
            try
            { ID = Convert.ToInt64(e.CommandArgument); }
            catch { }

            switch ((string)e.CommandName)
            {
                case "New":
                    this.RaiseNew();
                    break;
                case "Open":
                    this.RaiseOpen(ID);
                    break;
            }
        }

        #endregion

        #region _Methods

        protected void SetupPage_Handlers()
        {
            this.EOCb_Search.Execute += this.EOCb_Search_Execute;
            this.Btn_New.Click += this.Btn_New_Click;
            this.EOCb_Print.Execute += this.EOCb_Print_Execute;
            this.EOSe.Command += this.EOSe_Command;
        }

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

            if (
                Wc.GetType().ToString() == typeof(System.Web.UI.WebControls.TextBox).ToString()
                || Wc.GetType().ToString() == typeof(EO.Web.DatePicker).ToString())
            { Wc.Attributes.Add("onkeypress", "return noenter(event)"); }
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
            Control C = (Control)this.Page;
            this.SetupPage_ControlAttributes(ref C);

            this.Txt_Search.Attributes.Add("onkeypress", "return KeyPressEnter_Search(event)");

            this.Btn_Print.Attributes.Clear();
            Layer01_Methods_Web_EO.BindEOCallBack(this.Btn_Print, this.EOCb_Print, this.Page);

            Layer01_Methods_Web_EO.BindEOCallBack(this.Btn_NewSearch, this.EOCb_Search, this.Page);
            Layer01_Methods_Web_EO.BindEOCallBack(this.Btn_AddSearch, this.EOCb_Search, this.Page);
            Layer01_Methods_Web_EO.BindEOCallBack(this.Btn_SortAsc, this.EOCb_Search, this.Page);
            Layer01_Methods_Web_EO.BindEOCallBack(this.Btn_SortDesc, this.EOCb_Search, this.Page);
            Layer01_Methods_Web_EO.BindEOCallBack(this.Btn_Clear, this.EOCb_Search, this.Page);
            Layer01_Methods_Web_EO.BindEOCallBack(this.Btn_Page, this.EOCb_Search, this.Page);

            /*
            this.Btn_Print.Attributes.Add("onclick", @"eo_Callback('" + this.EOCb_Print.ClientID + @"','" + this.Btn_Print.ID + @"'); return false;");

            this.Btn_NewSearch.Attributes.Add("onclick", @"eo_Callback('" + this.EOCb_Search.ClientID + @"','" + this.Btn_NewSearch.ID + @"'); return false;");
            this.Btn_AddSearch.Attributes.Add("onclick", @"eo_Callback('" + this.EOCb_Search.ClientID + @"','" + this.Btn_AddSearch.ID + @"'); return false;");
            this.Btn_SortAsc.Attributes.Add("onclick", @"eo_Callback('" + this.EOCb_Search.ClientID + @"','" + this.Btn_SortAsc.ID + @"'); return false;");
            this.Btn_SortDesc.Attributes.Add("onclick", @"eo_Callback('" + this.EOCb_Search.ClientID + @"','" + this.Btn_SortDesc.ID + @"'); return false;");
            this.Btn_Clear.Attributes.Add("onclick", @"eo_Callback('" + this.EOCb_Search.ClientID + @"','" + this.Btn_Clear.ID + @"'); return false;");
            this.Btn_Page.Attributes.Add("onclick", @"eo_Callback('" + this.EOCb_Search.ClientID + @"','" + this.Btn_Page.ID + @"'); return false;");            
            */
        }

        public override void SetupPage_RegisterForEventValidation(ref Control C)
        {
            WebControl Wc = null;
            if (C is WebControl)
            { Wc = (WebControl)C; }
            else
            {
                foreach (Control Ic in C.Controls)
                {
                    Control Inner_Ic = Ic;
                    this.SetupPage_RegisterForEventValidation(ref Inner_Ic);
                }
                return;
            }

            this.Page.ClientScript.RegisterForEventValidation(Wc.UniqueID);

            foreach (Control Ic in C.Controls)
            {
                Control Inner_Ic = Ic;
                this.SetupPage_RegisterForEventValidation(ref Inner_Ic);
            }
        }

        void SetupPage()
        {
            DataTable Dt =
                Do_Methods_Query.GetQuery(
                    "System_Modules"
                    , ""
                    , "System_ModulesID = " + this.mSystem_ModulesID);

            string Override_ModuleName = (string)this.ViewState[CnsModuleName];
            if (Override_ModuleName == "")
            {
                if (Dt.Rows.Count > 0)
                { Override_ModuleName = (string)Do_Methods.IsNull(Dt.Rows[0]["Name"], ""); }
            }

            this.Lbl_ModuleName.Text = Override_ModuleName;

            if (!this.mCurrentUser.CheckAccess(this.mSystem_ModulesID, Layer01_Common.Common.Layer01_Constants.eAccessLib.eAccessLib_Access))
            { throw new Exception("You have no access in this page."); }

            if (!this.mCurrentUser.CheckAccess(this.mSystem_ModulesID, Layer01_Common.Common.Layer01_Constants.eAccessLib.eAccessLib_New))
            { this.Btn_New.Enabled = false; }

            this.Txt_Top.Text = "50";
            this.BindGrid();
            this.Lbl_AppliedFilters.Text = this.Details_ItemsCount();
            this.RaiseSetupPage_Done();
        }

        List<ClsBindGridColumn_EO> BindGrid(DataTable Dt_List)
        {
            bool IsReadOnly = false;
            if (
                !(this.mCurrentUser.CheckAccess(this.mSystem_ModulesID, Layer01_Common.Common.Layer01_Constants.eAccessLib.eAccessLib_Edit)
                || this.mCurrentUser.CheckAccess(this.mSystem_ModulesID, Layer01_Common.Common.Layer01_Constants.eAccessLib.eAccessLib_View))
                )
            { IsReadOnly = true; }

            bool IsNoSelect = false;
            try { IsNoSelect = (bool)this.ViewState[CnsIsNoSelect]; }
            catch { }

            if (IsNoSelect)
            { IsReadOnly = true; }

            DataRow Dr_Bind = Do_Methods_Query.GetSystemBindDefinition(this.mSystem_BinDefinition_Name);
            List<ClsBindGridColumn_EO> List_Gc = Layer01_Methods_Web_EO.GetBindGridColumn_EO(this.mSystem_BinDefinition_Name);

            if (!IsReadOnly)
            {
                ClsBindGridColumn_EO Gc = new ClsBindGridColumn_EO("", "", 50, "", Layer01_Common.Common.Layer01_Constants.eSystem_Lookup_FieldType.FieldType_Button);
                Gc.mCommandName = "Select";
                Gc.mFieldText = ">>";
                Gc.mButtonType = ButtonColumnType.LinkButton;
                List_Gc.Insert(0, Gc);
            }

            string TableKey = "";
            if (this.mObj_Base != null)
            { TableKey = this.mObj_Base.pHeader_TableKey; }
            else
            {
                TableKey = (string)this.ViewState[CnsSourceKey];
                if (TableKey == "")
                { TableKey = (string)Do_Methods.IsNull(Dr_Bind["TableKey"], ""); }
            }

            this.EOGrid_List.ClientSideOnItemCommand = "EOGrid_ItemCommand";
            this.EOGrid_List.FullRowMode = true;
            Layer01_Methods_Web_EO.BindEOGrid(ref this.EOGrid_List, Dt_List, List_Gc, TableKey, false, false);
            return List_Gc;
        }

        void BindGrid()
        {
            Int64 Top = 50;
            Int32 Page = 1;
            this.Details_SetPaginator(Top, this.List_Count());
            DataTable Dt_List = this.List(null, "", Top, Page);
            List<ClsBindGridColumn_EO> List_Gc = this.BindGrid(Dt_List);

            DataTable Dt_FilterFields = new DataTable();
            Dt_FilterFields.Columns.Add("Desc", typeof(string));
            Dt_FilterFields.Columns.Add("Field", typeof(string));
            Dt_FilterFields.Columns.Add("DataType", typeof(string));

            foreach (ClsBindGridColumn_EO Gc in List_Gc)
            {
                if (Gc.mVisible && (Gc.mFieldName != ""))
                {
                    List<QueryParameter> Sp = new List<QueryParameter>();
                    Sp.Add(new QueryParameter("Field", Gc.mFieldName));
                    Sp.Add(new QueryParameter("Desc", Gc.mFieldDesc));
                    Sp.Add(new QueryParameter("DataType", Dt_List.Columns[Gc.mFieldName].DataType.Name));
                    Do_Methods.AddDataRow(ref Dt_FilterFields, Sp);
                }
            }

            this.Cbo_SearchFilter.DataSource = Dt_FilterFields;
            this.Cbo_SearchFilter.DataTextField = "Desc";
            this.Cbo_SearchFilter.DataValueField = "Field";
            this.Cbo_SearchFilter.DataBind();

            this.ViewState[CnsDt_FilterFields] = Dt_FilterFields;
            this.ViewState[CnsFilterString] = "1 = 1";
            this.ViewState[CnsOrderString] = "";
            this.ViewState[CnsDisplayFilterString] = "";
            this.ViewState[CnsDisplayOrderString] = "";
        }

        public override void RebindGrid()
        {
            Int64 Top = 0;
            try { Top = Do_Methods.Convert_Int64(this.Txt_Top.Text); }
            catch { }

            Int32 Page = 0;
            try { Page = Do_Methods.Convert_Int32(this.Cbo_Page.SelectedValue); }
            catch { }

            string ViewState_DisplayFilterString = (string)this.ViewState[CnsDisplayFilterString];
            string ViewState_DisplayOrderString = (string)this.ViewState[CnsDisplayOrderString];

            string ViewState_OrderString = (string)this.ViewState[CnsOrderString];

            QueryCondition Qc = null;
            try { Qc = (QueryCondition)this.ViewState[CnsObj_QueryCondition]; }
            catch { }

            if (Qc == null)
            { Qc = new QueryCondition(); }

            this.Details_SetPaginator(Top, this.List_Count(Qc));

            try
            { this.Cbo_Page.SelectedValue = Page.ToString(); }
            catch
            {
                try
                { Page = Convert.ToInt32(this.Cbo_Page.SelectedValue); }
                catch { }
            }

            DataTable Dt;
            try
            { Dt = this.List(Qc, ViewState_OrderString, Top, Page); }
            catch
            {
                Dt = this.List(Qc, "", Top, Page);
                ViewState_OrderString = "";
                ViewState_DisplayOrderString = "";
                this.ViewState[CnsOrderString] = ViewState_OrderString;
                this.ViewState[CnsDisplayOrderString] = ViewState_DisplayOrderString;
            }

            this.BindGrid(Dt);

            try
            { this.EOCbp_Grid.Update(); }
            catch { }
        }

        void Selection_AddFilter()
        {
            DataTable Dt_FilterFields = (DataTable)this.ViewState[CnsDt_FilterFields];
            string FilterSt = "";
            QueryCondition Qc = (QueryCondition)this.ViewState[CnsObj_QueryCondition];
            if (Qc == null)
            { Qc = new QueryCondition(); }

            DataRow[] ArrDr = Dt_FilterFields.Select("Field = '" + this.Cbo_SearchFilter.SelectedValue + "'");
            if (ArrDr.Length > 0)
            {
                Qc.Add(
                    (string)Do_Methods.IsNull(ArrDr[0]["Field"], "")
                    , this.Txt_Search.Text
                    , (string)Do_Methods.IsNull(ArrDr[0]["DataType"], ""));
                FilterSt = this.Cbo_SearchFilter.SelectedItem.Text + " by " + this.Txt_Search.Text;
            }

            this.ViewState[CnsObj_QueryCondition] = Qc;

            string ViewState_DisplayFilterString = (string)this.ViewState[CnsDisplayFilterString];
            ViewState_DisplayFilterString += @"<br />" + FilterSt;
            this.ViewState[CnsDisplayFilterString] = ViewState_DisplayFilterString;
        }

        void Selection_AddSort(bool IsAscending)
        {
            string ViewState_OrderString = (string)this.ViewState[CnsOrderString];
            string ViewState_DisplayOrderString = (string)this.ViewState[CnsDisplayOrderString];

            char Comma = ' ';
            string OrderDirection = "";
            string OrderDirection_Desc = "";

            if (ViewState_OrderString != "")
            { Comma = ','; }

            if (IsAscending)
            {
                OrderDirection = "Asc";
                OrderDirection_Desc = "Ascending";
            }
            else
            {
                OrderDirection = "Desc";
                OrderDirection_Desc = "Descending";
            }

            ViewState_OrderString += " " + Comma + "[" + this.Cbo_SearchFilter.SelectedValue + "]" + OrderDirection;
            this.ViewState[CnsOrderString] = ViewState_OrderString;

            ViewState_DisplayOrderString += "<br />" + this.Cbo_SearchFilter.SelectedItem.Text + " " + OrderDirection_Desc;
            this.ViewState[CnsDisplayOrderString] = ViewState_DisplayOrderString;
        }

        void Selection_ClearFilters()
        {
            this.ViewState[CnsObj_QueryCondition] = null;
            this.ViewState[CnsFilterString] = "1 = 1 ";
            this.ViewState[CnsOrderString] = "";
            this.ViewState[CnsDisplayFilterString] = "";
            this.ViewState[CnsDisplayOrderString] = "";
        }

        void Details_SetPaginator(Int64 Top, Int64 Items)
        {
            Int64 Pages = (Int64)Items / (Int64)Top;
            if ((Items % Top) > 0)
            { Pages++; }

            DataTable Dt = new DataTable();
            Dt.Columns.Add("Page", typeof(Int64));
            for (Int64 Ct = 1; Ct <= Pages; Ct++)
            {
                List<QueryParameter> Sp = new List<QueryParameter>();
                Sp.Add(new QueryParameter("Page", Ct));
                Do_Methods.AddDataRow(ref Dt, Sp);
            }

            Layer01_Methods_Web.BindCombo(ref this.Cbo_Page, Dt, "Page", "Page");
            this.ViewState[CnsItemsMax] = Items;
        }

        string Details_ItemsCount()
        {
            Int64 Top = Do_Methods.Convert_Int64(this.Txt_Top.Text);
            Int64 Page = Do_Methods.Convert_Int64(this.Cbo_Page.SelectedValue, 1);
            Int64 Items = Do_Methods.Convert_Int64(this.ViewState[CnsItemsMax]);

            Int64 Items_Start = (Top * (Page - 1)) + 1;
            Int64 Items_End = Top * Page;

            if (Items == 0)
            { return "No records shown."; }

            if (Items_End > Items)
            { Items_End = Items; }

            return "Showing " + Items_Start.ToString("#,##0") + " - " + Items_End.ToString("#,##0") + " out of " + Items.ToString("#,##0");
        }

        public override void Details_Print(ref string Data)
        { throw new NotImplementedException(); }

        #endregion

        #region _Properties

        public override Button pBtn_New
        {
            get { return this.Btn_New; }
        }

        public override Button pBtn_Print
        {
            get { return this.Btn_Print; }
        }

        public override EO.Web.Grid pGrid_List
        {
            get { return this.EOGrid_List; }
        }

        #endregion
    }
}
