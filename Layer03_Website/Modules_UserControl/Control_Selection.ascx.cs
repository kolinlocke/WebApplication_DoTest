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
using DataObjects_Framework;
using DataObjects_Framework.Common;
using DataObjects_Framework.Connection;
using DataObjects_Framework.Objects;
using DataObjects_Framework.PreparedQueryObjects;

namespace Layer03_Website.Modules_UserControl
{
    public partial class Control_Selection : System.Web.UI.UserControl
    {
        #region _Events

        public delegate void DsAccept(DataTable Dt, EO.Web.CallbackEventArgs e, string Data);
        public event DsAccept EvAccept;

        #endregion

        #region _Variables

        const string CnsSelectionName = "CnsSelectionName";
        const string CnsQuery_Selection = "CnsQuery_Selection";
        const string CnsQuery_Selection_Key = "CnsQuery_Selection_Key";
        const string CnsDt_Selected = "CnsDt_Selected";
        const string CnsIsMultipleSelect = "CnsIsMultipleSelect";
        const string CnsData = "CnsData";

        string mSelectionName;
        string mQuery_Selection;
        string mQuery_Selection_Key;
        DataTable mDt_Selected;
        bool mIsMultipleSelect;

        const string CnsDt_FilterFields = "CnsDt_FilterFields";
        const string CnsObj_QueryCondition = "CnsObj_QueryCondition";
        const string CnsFilterString = "CnsFilterString";
        const string CnsOrderString = "CnsOrderString";
        const string CnsDisplayFilterString = "CnsDisplayFilterString";
        const string CnsDisplayOrderString = "CnsDisplayOrderString";
        const string CnsKeyField = "CnsKeyField";
        const string CnsItemsMax = "CnsItemsMax";
        
        enum eCheck
        {
            None
            , CheckAll
            , UncheckAll
        }

        public struct Str_AddSelectedFields
        {
            public string Field_Target;
            public string Field_Selected;

            public Str_AddSelectedFields(string pField_Target, string pField_Selected)
            {
                Field_Target = pField_Target;
                Field_Selected = pField_Selected;
            }
        }

        public struct Str_AddSelectedFieldsDefault
        {
            public string Field_Target;
            public object Value;

            public Str_AddSelectedFieldsDefault(string pField_Target, object pValue)
            {
                Field_Target = pField_Target;
                Value = pValue;
            }
        }

        #endregion

        #region _Constructor

        public Control_Selection() { }

        #endregion

        #region _EventHandlers

        protected void Page_Load(object sender, EventArgs e) 
        {
            this.EOCb_Search.Execute += this.EOCb_Search_Execute;
            this.EOCb_Accept.Execute += this.EOCb_Accept_Execute;
            
            //[-]

            try
            { this.mSelectionName = (string)this.ViewState[CnsSelectionName]; }
            catch { }

            try
            { this.mIsMultipleSelect = (this.ViewState[CnsIsMultipleSelect] != null) ? (bool)this.ViewState[CnsIsMultipleSelect] : false; }
            catch { }

            try
            { this.mDt_Selected = (DataTable)this.ViewState[CnsDt_Selected]; }
            catch { }

            try
            { this.mQuery_Selection = (string)this.ViewState[CnsQuery_Selection]; }
            catch { }
            
            //[-]

            System.Text.StringBuilder Sb_Js = new System.Text.StringBuilder();

            Sb_Js.AppendLine(@"function Selection_Accept_" + this.ClientID + @"(dialog, arg) {");
            Sb_Js.AppendLine(@" EOCb_BE_Selection_" + this.ClientID + @"();");
            Sb_Js.AppendLine(@" var Grid = eo_GetObject('" + this.EOGrid_Selection.ClientID + "');");
            Sb_Js.AppendLine(@" var Gi = Grid.getSelectedItem();");
            Sb_Js.AppendLine(@" var Key = 0;");
            Sb_Js.AppendLine(@" if(Gi != null) {");
            Sb_Js.AppendLine(@" Key = Gi.getKey();");
            Sb_Js.AppendLine(@" }");            
            Sb_Js.AppendLine(@" eo_Callback('" + this.EOCb_Accept.ClientID + "', Key);");
            Sb_Js.AppendLine(@"}");

            Sb_Js.AppendLine(@"function EOCb_BE_Selection_" + this.ClientID + "(callback) {");
            Sb_Js.AppendLine(@" EOCb_BE();");
            Sb_Js.AppendLine(@" var Grid = eo_GetObject('" + this.EOGrid_Selection.ClientID + "');");
            Sb_Js.AppendLine(@" var Gc_IsSelect = Grid.getColumn('IsSelect');");
            Sb_Js.AppendLine(@" var NoItems = Grid.getItemCount();");
            Sb_Js.AppendLine(@" var Ct = 0;");
            Sb_Js.AppendLine(@" var Selected = '';");
            Sb_Js.AppendLine(@" var Comma = '';");
            Sb_Js.AppendLine(@" for (Ct = 0; Ct <= (NoItems - 1); Ct++) {");
            Sb_Js.AppendLine(@"     var Gi = Grid.getItem(Ct);");
            Sb_Js.AppendLine(@"     var Gcl = Gi.getCell(Gc_IsSelect.getOriginalIndex());");
            Sb_Js.AppendLine(@"     var IsSelect = Gcl.getValue();");
            Sb_Js.AppendLine(@"     var Key = Gi.getKey();");
            Sb_Js.AppendLine(@"     Selected = Selected + Comma + Key + ',' + IsSelect;");
            Sb_Js.AppendLine(@"     Comma = ',';");
            Sb_Js.AppendLine(@" }");
            Sb_Js.AppendLine(@" document.getElementById('" + this.Hid_Selected.ClientID + "').value = Selected");
            Sb_Js.AppendLine(@"}");

            this.Page.ClientScript.RegisterClientScriptBlock(typeof(string), this.ClientID, Sb_Js.ToString(), true);
            this.EOCb_Search.ClientSideBeforeExecute = "EOCb_BE_Selection_" + this.ClientID;

            //[-]

            /*
            this.Btn_NewSearch.Attributes.Add("onclick", @"eo_Callback('" + this.EOCb_Search.ClientID + @"','" + this.Btn_NewSearch.ID + @"'); return false;");
            this.Btn_AddSearch.Attributes.Add("onclick", @"eo_Callback('" + this.EOCb_Search.ClientID + @"','" + this.Btn_AddSearch.ID + @"'); return false;");
            this.Btn_SortAsc.Attributes.Add("onclick", @"eo_Callback('" + this.EOCb_Search.ClientID + @"','" + this.Btn_SortAsc.ID + @"'); return false;");
            this.Btn_SortDesc.Attributes.Add("onclick", @"eo_Callback('" + this.EOCb_Search.ClientID + @"','" + this.Btn_SortDesc.ID + @"'); return false;");
            this.Btn_Clear.Attributes.Add("onclick", @"eo_Callback('" + this.EOCb_Search.ClientID + @"','" + this.Btn_Clear.ID + @"'); return false;");
            this.Btn_Page.Attributes.Add("onclick", @"eo_Callback('" + this.EOCb_Search.ClientID + @"','" + this.Btn_Page.ID + @"'); return false;");            
            */

            Layer01_Methods_Web_EO.BindEOCallBack(this.Btn_NewSearch, this.EOCb_Search, this.Page);
            Layer01_Methods_Web_EO.BindEOCallBack(this.Btn_AddSearch, this.EOCb_Search, this.Page);
            Layer01_Methods_Web_EO.BindEOCallBack(this.Btn_SortAsc, this.EOCb_Search, this.Page);
            Layer01_Methods_Web_EO.BindEOCallBack(this.Btn_SortDesc, this.EOCb_Search, this.Page);
            Layer01_Methods_Web_EO.BindEOCallBack(this.Btn_Clear, this.EOCb_Search, this.Page);
            Layer01_Methods_Web_EO.BindEOCallBack(this.Btn_Page, this.EOCb_Search, this.Page);
            Layer01_Methods_Web_EO.BindEOCallBack(this.Btn_CheckAll, this.EOCb_Search, this.Page);
            Layer01_Methods_Web_EO.BindEOCallBack(this.Btn_UncheckAll, this.EOCb_Search, this.Page);

        }

        void EOCb_Search_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            eCheck Check = eCheck.None;

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
            else if (e.Parameter == this.Btn_CheckAll.ID)
            { Check = eCheck.CheckAll; }
            else if (e.Parameter == this.Btn_UncheckAll.ID)
            { Check = eCheck.UncheckAll; }

            if (Check == eCheck.None)
            { this.PostGrid_Selected(); }

            this.RebindGrid(Check);

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
                this.EOCbp_EOGrid_Selection.Update();
                this.EOCbp_Applied.Update();
                this.EOCb_Cbo_Page.Update();
            }
            catch { }
        }

        void EOCb_Accept_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            if (this.mIsMultipleSelect)
            { this.PostGrid_Selected(); }
            else
            {
                Int64 ID = 0;
                try
                { ID = Convert.ToInt64(e.Parameter); }
                catch { }

                DataTable Inner_Dt = new DataTable();
                Inner_Dt.Columns.Add("ID", typeof(Int64));

                List<QueryParameter> Sp = new List<QueryParameter>();
                Sp.Add(new QueryParameter("ID", ID));
                Do_Methods.AddDataRow(ref Inner_Dt, Sp);
                this.mDt_Selected = Inner_Dt;
            }

            DataTable Dt = this.Selected();
            string Data = (string)this.ViewState[CnsData];

            if (EvAccept != null)
            { EvAccept(Dt, e, Data); }
        }

        #endregion

        #region _Methods

        public void Show(
            string SelectionName
            , string Title = ""
            , bool IsMultipleSelect = false
            , string Data = "")
        {
            this.ViewState[CnsData] = Data;
            this.ViewState[CnsQuery_Selection] = "";
            this.ViewState[CnsQuery_Selection_Key] = "";
            this.ViewState[CnsObj_QueryCondition] = null;

            this.mSelectionName = SelectionName;
            this.mIsMultipleSelect = IsMultipleSelect;
            this.mQuery_Selection = "";

            this.ViewState[CnsSelectionName] = SelectionName;
            this.ViewState[CnsIsMultipleSelect] = IsMultipleSelect;
            this.Panel_Check.Visible = IsMultipleSelect;

            //[-]

            DataTable Dt = new DataTable();
            Dt.Columns.Add("ID", typeof(Int64));
            Dt.Columns.Add("IsSelect", typeof(bool));
            this.mDt_Selected = Dt;
            this.ViewState[CnsDt_Selected] = Dt;

            //[-]

            this.BindGrid();
            this.Lbl_AppliedFilters.Text = this.Details_ItemsCount();

            //[-]

            DataRow Dr_Bind = Do_Methods_Query.GetSystemBindDefinition(SelectionName);
            if (Title == "")
            { Title = (string)Do_Methods.IsNull(Dr_Bind["Desc"], ""); }

            if (Title == "")
            { Title = "Select"; }

            this.EODialog_Selection.HeaderHtml = Title;
            this.EODialog_Selection.ClientSideOnAccept = "Selection_Accept_" + this.ClientID;
            this.EODialog_Selection.Show();

            try
            { this.EOCbp_EODialog_Selection.Update(); }
            catch { }
        }

        public void Show_UseQuery(
            string SelectionName
            , string SelectionQuery
            , string SelectionQuery_Key
            , string Title = ""
            , bool IsMultipleSelect = false
            , string Data = "")
        { 
            this.ViewState[CnsData] = Data;
            this.ViewState[CnsQuery_Selection] = @"( " + SelectionQuery + @") As [Tb]";
            this.ViewState[CnsQuery_Selection_Key] = SelectionQuery_Key;
            this.ViewState[CnsObj_QueryCondition] = null;

            this.mSelectionName = SelectionName;
            this.mIsMultipleSelect = IsMultipleSelect;
            this.mQuery_Selection = (string)this.ViewState[CnsQuery_Selection];
            this.mQuery_Selection_Key = (string)this.ViewState[CnsQuery_Selection_Key];

            this.ViewState[CnsSelectionName] = SelectionName;
            this.ViewState[CnsIsMultipleSelect] = IsMultipleSelect;
            this.Panel_Check.Visible = IsMultipleSelect;

            //[-]

            DataTable Dt = new DataTable();
            Dt.Columns.Add("ID", typeof(Int64));
            Dt.Columns.Add("IsSelect", typeof(bool));
            this.mDt_Selected = Dt;
            this.ViewState[CnsDt_Selected] = Dt;

            //[-]

            this.BindGrid();
            this.Lbl_AppliedFilters.Text = this.Details_ItemsCount();

            //[-]

            DataRow Dr_Bind = Do_Methods_Query.GetSystemBindDefinition(SelectionName);
            if (Title == "")
            { Title = (string)Do_Methods.IsNull(Dr_Bind["Desc"], ""); }

            if (Title == "")
            { Title = "Select"; }

            this.EODialog_Selection.HeaderHtml = Title;
            this.EODialog_Selection.ClientSideOnAccept = "Selection_Accept_" + this.ClientID;
            this.EODialog_Selection.Show();

            try
            { this.EOCbp_EODialog_Selection.Update(); }
            catch { }
        }

        public DataTable Selected()
        {
            if (this.mIsMultipleSelect)
            {
                DataView Dv = new DataView(this.mDt_Selected);
                Dv.RowFilter = "IsSelect = True";
                DataTable Dt = Dv.ToTable(true, new string[] { "ID" });
                return Dt;
            }
            else
            { return this.mDt_Selected; }
        }

        //[-]

        List<ClsBindGridColumn_EO> BindGrid(
            DataTable Dt_List
            , eCheck Check = eCheck.None)
        {
            DataRow Dr_Bind = Do_Methods_Query.GetSystemBindDefinition(this.mSelectionName);
            List<ClsBindGridColumn_EO> List_Gc = Layer01_Methods_Web_EO.GetBindGridColumn_EO(this.mSelectionName);

            string Bind_TableKey = (string)Do_Methods.IsNull(Dr_Bind["TableKey"], "");

            string TableKey = (string)this.ViewState[CnsQuery_Selection_Key];
            if (TableKey != "")
            { Bind_TableKey = TableKey; }

            Dt_List.Columns.Add("IsSelect", typeof(bool));
            ClsBindGridColumn_EO Gc =
                new ClsBindGridColumn_EO(
                    "IsSelect"
                    , "Select?"
                    , 80
                    , ""
                    , Layer01_Common.Common.Layer01_Constants.eSystem_Lookup_FieldType.FieldType_Checkbox
                    , this.mIsMultipleSelect);
            List_Gc.Insert(0, Gc);

            if (Check == eCheck.None)
            {
                foreach (DataRow Dr in this.mDt_Selected.Rows)
                {
                    DataRow[] Inner_ArrDr = Dt_List.Select(Bind_TableKey + " = " + Convert.ToInt64(Dr["ID"]).ToString());
                    if (Inner_ArrDr.Length > 0)
                    { Inner_ArrDr[0]["IsSelect"] = Do_Methods.IsNull(Dr["IsSelect"], false); }
                }
            }
            else
            {
                bool Inner_IsSelect = Check == eCheck.CheckAll;
                foreach (DataRow Dr in Dt_List.Rows)
                { Dr["IsSelect"] = Inner_IsSelect; }
            }

            this.EOGrid_Selection.FullRowMode = true;
            Layer01_Methods_Web_EO.BindEOGrid(ref this.EOGrid_Selection, Dt_List, List_Gc, Bind_TableKey, false, false);
            return List_Gc;
        }

        void BindGrid()
        {
            Int64 Top = 50;
            Int32 Page = 1;
            this.Txt_Top.Text = Top.ToString();
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
                    if (Gc.mFieldName == "IsSelect")
                    { continue; }

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

        void RebindGrid(eCheck Check = eCheck.None)
        {
            Int64 Top = 0;
            try { Top = Convert.ToInt64(this.Txt_Top.Text); }
            catch { }

            Int32 Page = 0;
            try { Page = Convert.ToInt32(this.Cbo_Page.SelectedValue); }
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

            this.BindGrid(Dt, Check);
        }

        void PostGrid_Selected()
        {
            if (!this.mIsMultipleSelect)
            { return; }

            string SelectedData = this.Hid_Selected.Value;
            if (SelectedData == "")
            { return; }

            DataTable Dt_Tmp = this.mDt_Selected.Clone();
            
            string[] Parsed = SelectedData.Split(',');
            for (Int32 Ct = 0; Ct <= (Parsed.Length - 1); Ct++)
            {
                Int64 ID = Convert.ToInt64(Parsed[Ct]);
                bool IsSelect = false;
                try
                { IsSelect = Convert.ToInt32(Parsed[Ct + 1]) == 1; }
                catch { }

                DataRow Dr = Dt_Tmp.NewRow();
                Dr["ID"] = ID;
                Dr["IsSelect"] = IsSelect;
                Dt_Tmp.Rows.Add(Dr);                
            }

            DataTable Dt_SelectedID = new DataView(Dt_Tmp).ToTable(true, new string[] { "ID" });
            foreach (DataRow Dr in Dt_SelectedID.Rows)
            {
                Int64 ID = Convert.ToInt64(Dr["ID"]);
                bool IsSelect = false;
                DataRow[] ArrDr = Dt_Tmp.Select("ID = " + ID.ToString() + " And IsSelect = 1");
                if (ArrDr.Length > 0)
                { IsSelect = true; }

                ArrDr = this.mDt_Selected.Select("ID = " + ID);
                if (ArrDr.Length > 0)
                { ArrDr[0]["IsSelect"] = IsSelect; }
                else
                {
                    DataRow Inner_Dr = this.mDt_Selected.NewRow();
                    Inner_Dr["ID"] = ID;
                    Inner_Dr["IsSelect"] = IsSelect;
                    this.mDt_Selected.Rows.Add(Inner_Dr);
                }
            }

            /*
            string[] Parsed = SelectedData.Split(',');
            for (Int32 Ct = 0; Ct <= (Parsed.Length - 1); Ct++)
            {
                Int64 ID = Convert.ToInt64(Parsed[Ct]);
                bool IsSelect = false;
                try
                { IsSelect = Convert.ToInt32(Parsed[Ct + 1]) == 1; }
                catch { }

                DataRow[] ArrDr = this.mDt_Selected.Select("ID = " + ID);
                if (ArrDr.Length > 0)
                { ArrDr[0]["IsSelect"] = IsSelect; }
                else
                {
                    DataRow Dr = this.mDt_Selected.NewRow();
                    Dr["ID"] = ID;
                    Dr["IsSelect"] = IsSelect;
                    this.mDt_Selected.Rows.Add(Dr);
                }
            }
            */
            
            this.ViewState[CnsDt_Selected] = this.mDt_Selected;
            this.Hid_Selected.Value = "";
        }

        //[-]

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
            Int64 Top = 0;
            try { Top = Convert.ToInt64(this.Txt_Top.Text); }
            catch { }

            Int64 Page = 1;
            try { Page = Convert.ToInt64(this.Cbo_Page.SelectedValue); }
            catch { }

            Int64 Items = 0;
            try { Items = Convert.ToInt64(this.ViewState[CnsItemsMax]); }
            catch { }

            Int64 Items_Start = (Top * (Page - 1)) + 1;
            Int64 Items_End = Top * Page;

            if (Items == 0)
            { return "No records shown."; }

            if (Items_End > Items)
            { Items_End = Items; }

            return "Showing " + Items_Start.ToString("#,##0") + " - " + Items_End.ToString("#,##0") + " out of " + Items.ToString("#,##0");
        }

        //[-]

        DataTable List(
            QueryCondition Condition = null
            , string Sort = ""
            , Int64 Top = 0
            , Int32 Page = 0)
        {
            DataRow Dr_Bind = Do_Methods_Query.GetSystemBindDefinition(this.mSelectionName);

            string Bind_Desc = (string)Do_Methods.IsNull(Dr_Bind["Desc"], "");
            string Bind_TableName = (string)Do_Methods.IsNull(Dr_Bind["TableName"], "");
            string Bind_TableKey = (string)Do_Methods.IsNull(Dr_Bind["TableKey"], "");
            string Bind_Condition = (string)Do_Methods.IsNull(Dr_Bind["Condition"], "");
            string Bind_Sort = (string)Do_Methods.IsNull(Dr_Bind["Sort"], "");

            string Query_Source = "";
            string Query_Condition = "";

            if (this.mQuery_Selection != "")
            { Query_Condition = this.mQuery_Selection; }
            else
            {
                Query_Source = Bind_TableName;
                if (Bind_Condition != "")
                { Query_Condition = "Where " + Bind_Condition; }
            }

            if (Query_Source == "")
            { throw new Exception("Selection Source not set."); }

            if (Sort == "")
            { Sort = Bind_Sort; }

            string Query = @"(Select * From " + Query_Source + " " + Query_Condition + @") As [Tb]";
            DataTable Dt_List = Do_Methods_Query.GetQuery(Query, "",  Condition, Sort, Top, Page);
            return Dt_List;
        }

        Int64 List_Count(QueryCondition Condition = null)
        {
            DataRow Dr_Bind = Do_Methods_Query.GetSystemBindDefinition(this.mSelectionName);

            string Bind_Desc = (string)Do_Methods.IsNull(Dr_Bind["Desc"], "");
            string Bind_TableName = (string)Do_Methods.IsNull(Dr_Bind["TableName"], "");
            string Bind_TableKey = (string)Do_Methods.IsNull(Dr_Bind["TableKey"], "");
            string Bind_Condition = (string)Do_Methods.IsNull(Dr_Bind["Condition"], "");
            string Bind_Sort = (string)Do_Methods.IsNull(Dr_Bind["Sort"], "");

            string Query_Source = "";
            string Query_Condition = "";

            if (this.mQuery_Selection != "")
            { Query_Condition = this.mQuery_Selection; }
            else
            {
                Query_Source = Bind_TableName;
                if (Bind_Condition != "")
                { Query_Condition = "Where " + Bind_Condition; }
            }

            if (Query_Source == "")
            { throw new Exception("Selection Source not set."); }

            string Query = @"(Select * From " + Query_Source + " " + Query_Condition + @") As [Tb]";
            DataTable Dt_List = Do_Methods_Query.GetQuery(Query, "Count(1) As [Ct]", Condition);

            Int64 Rv = 0;
            try
            { Rv = Convert.ToInt64(Do_Methods.IsNull(Dt_List.Rows[0]["Ct"], 0)); }
            catch { }

            return Rv;            
        }

        //[-]

        public static void AddSelected(
            DataTable Dt_Target
            , DataTable Dt_Selected
            , string Query_Selected_Source
            , string Query_Selected_Key
            , string Target_Key
            , List<Str_AddSelectedFields> Obj_Fields = null
            , List<Str_AddSelectedFieldsDefault> Obj_FieldsDefault = null)
        {
            if (!(Dt_Selected.Rows.Count > 0))
            { return; }

            PreparedQuery Pq = Do_Methods.CreateDataAccess().CreatePreparedQuery();
            Pq.pQuery = @"Select * From " + Query_Selected_Source + @" Where " + Query_Selected_Key + @" = @ID";            
			Pq.Add_Parameter("ID", Do_Constants.eParameterType.Long);
            Pq.Prepare();

            foreach (DataRow Dr_Selected in Dt_Selected.Rows)
            {
                //Pq.pParameters["ID"].Value = (Int64)Do_Methods.IsNull(Dr_Selected["ID"], 0);
                Pq.pParameter_Set("ID", Do_Methods.Convert_Int64(Dr_Selected["ID"]));
                DataTable Inner_Dt_Selected = Pq.ExecuteQuery().Tables[0];
                if (Inner_Dt_Selected.Rows.Count > 0)
                {
                    DataRow Inner_Dr_Selected = Inner_Dt_Selected.Rows[0];
                    DataRow[] Inner_ArrDr;
                    DataRow Inner_Dr_Target = null;
                    bool Inner_IsFound = false;

                    Inner_ArrDr = Dt_Target.Select(Target_Key + " = " + Convert.ToInt64(Inner_Dr_Selected[Query_Selected_Key]));
                    if (Inner_ArrDr.Length > 0)
                    {
                        Inner_Dr_Target = Inner_ArrDr[0];
                        if ((bool)Do_Methods.IsNull(Inner_Dr_Target["IsDeleted"], false))
                        {
                            Inner_Dr_Target["IsDeleted"] = DBNull.Value;
                            Inner_IsFound = true;
                        }
                    }

                    if (!Inner_IsFound)
                    {
                        Int64 Ct = 0;
                        Inner_ArrDr = Dt_Target.Select("", "TmpKey Desc");
                        if (Inner_ArrDr.Length > 0)
                        { Ct = (Int64)Inner_ArrDr[0]["TmpKey"]; }
                        Ct++;

                        DataRow Nr = Dt_Target.NewRow();
                        Nr["TmpKey"] = Ct;
                        Nr["Item_Style"] = "";
                        Nr[Target_Key] = (Int64)Inner_Dr_Selected[Query_Selected_Key];
                        Dt_Target.Rows.Add(Nr);

                        Inner_Dr_Target = Nr;
                    }

                    if (Obj_Fields != null)
                    {
                        foreach (Str_AddSelectedFields Inner_Obj in Obj_Fields)
                        { Inner_Dr_Target[Inner_Obj.Field_Target] = Inner_Dr_Selected[Inner_Obj.Field_Selected]; }
                    }

                    if (Obj_FieldsDefault != null)
                    {
                        foreach (Str_AddSelectedFieldsDefault Inner_Obj in Obj_FieldsDefault)
                        { Inner_Dr_Target[Inner_Obj.Field_Target] = Inner_Obj.Value; }
                    }
                }
            }
        }

        #endregion

        #region _Properties

        public EO.Web.CallbackPanel pEOCbp
        {
            get { return this.EOCbp_EODialog_Selection; }
        }

        public EO.Web.Dialog pEODialog
        {
            get { return this.EODialog_Selection; }
        }

        public DataTable pDt_Selected
        {
            get { return this.mDt_Selected; }
        }

        #endregion

    }
}