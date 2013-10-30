using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.Objects;
using Layer01_Common_Web;
using Layer01_Common_Web.Common;
using Layer01_Common_Web.Objects;
using Layer01_Common_Web_EO;
using Layer01_Common_Web_EO.Common;
using Layer01_Common_Web_EO.Objects;
using DataObjects_Framework;
using DataObjects_Framework.Common;

namespace Layer01_Common_Web_EO.Common
{
    public class Layer01_Methods_Web_EO
    {

        public static List<ClsBindGridColumn_EO> GetBindGridColumn_EO(string TableName)
        {
            List<ClsBindGridColumn_EO> List_Gc = new List<ClsBindGridColumn_EO>();
            ClsBindGridColumn_EO Gc;

            DataTable Dt_Def = Do_Methods_Query.GetQuery(@"udf_System_BindDefinition('" + TableName + "')", "", "", "OrderIndex");
            foreach (DataRow Dr in Dt_Def.Rows)
            {
                Gc = new ClsBindGridColumn_EO(
                    (string)Do_Methods.IsNull(Dr["Name"],"")
                    , (string)Do_Methods.IsNull(Dr["Desc"], "")
                    , (Int32)Do_Methods.IsNull(Dr["Width"],0)
                    , (string)Do_Methods.IsNull(Dr["NumberFormat"], "")
                    , (Layer01_Common.Common.Layer01_Constants.eSystem_Lookup_FieldType)Do_Methods.IsNull(Dr["System_LookupID_FieldType"], Layer01_Common.Common.Layer01_Constants.eSystem_Lookup_FieldType.FieldType_Static)
                    , !(bool)Do_Methods.IsNull(Dr["IsHidden"], false)
                    , !(bool)Do_Methods.IsNull(Dr["IsReadOnly"], false)
                    , (string)Do_Methods.IsNull(Dr["ClientSideBeginEdit"], "")
                    , (string)Do_Methods.IsNull(Dr["ClientSideEndEdit"], "")
                    , (string)Do_Methods.IsNull(Dr["CommandName"], "")
                    );

                Gc.mButtonType = (ButtonColumnType)Do_Methods.IsNull(Dr["System_LookupID_ButtonType"], ButtonColumnType.LinkButton);
                Gc.mFieldText = (string)Do_Methods.IsNull(Dr["FieldText"], "");

                List_Gc.Add(Gc);
            }

            return List_Gc;
        }

        public static void BindEOGrid(
            ref EO.Web.Grid EOGrid
            , DataTable Dt
            , List<ClsBindGridColumn_EO> Gc
            , string Key = ""
            , bool AllowSort = true
            , bool HasDelete = false)
        {
            EOGrid.DataSource = Dt;

            if (EOGrid.Columns.Count > 0)
            { EOGrid.Columns.Clear(); }

            EOGrid.AutoGenerateColumns = false;
            EOGrid.AllowPaging = false;

            EO.Web.GridColumn EOGc = null;

            foreach (ClsBindGridColumn_EO C in Gc)
            {
                switch (C.mFieldType)
                { 
                    case Layer01_Constants.eSystem_Lookup_FieldType.FieldType_Static:
                        EOGc = new EO.Web.StaticColumn();
                        break;
                    case Layer01_Constants.eSystem_Lookup_FieldType.FieldType_Text:
                        EOGc = new EO.Web.TextBoxColumn();
                        break;
                    case Layer01_Constants.eSystem_Lookup_FieldType.FieldType_Checkbox:
                        EOGc = new EO.Web.CheckBoxColumn();
                        break;
                    case Layer01_Constants.eSystem_Lookup_FieldType.FieldType_DateTime:
                        EOGc = new EO.Web.DateTimeColumn();
                        break;
                    case Layer01_Constants.eSystem_Lookup_FieldType.FieldType_Button:
                        {
                            EO.Web.ButtonColumn Obj = new EO.Web.ButtonColumn();
                            Obj.CommandName = C.mCommandName;
                            Obj.ButtonType = C.mButtonType;
                            Obj.ButtonText = C.mFieldText;
                            EOGc = Obj;
                            break;
                        }
                    case Layer01_Constants.eSystem_Lookup_FieldType.FieldType_Delete:
                        {
                            EO.Web.DeleteCommandColumn Obj = new EO.Web.DeleteCommandColumn();
                            Obj.DeleteText = C.mFieldText;
                            EOGc = Obj;
                            break;
                        }
                    default:
                        EOGc = new EO.Web.StaticColumn();
                        break;
                }

                EOGc.DataField = C.mFieldName;
                EOGc.HeaderText = C.mFieldDesc;
                EOGc.DataFormat = C.mDataFormat;
                EOGc.Name = C.mColumnName;
                EOGc.ClientSideBeginEdit = C.mClientSideBeginEdit;
                EOGc.ClientSideEndEdit = C.mClientSideEndEdit;
                EOGc.Width = C.mWidth;
                EOGc.Visible = C.mVisible;
                EOGc.ReadOnly = !C.mEnabled;
                EOGc.AllowSort = AllowSort;

                if (C.mEOGridCellStyle != null)
                { EOGc.CellStyle = C.mEOGridCellStyle; }

                EOGrid.Columns.Add(EOGc);
            }

            if (HasDelete)
            {
                EO.Web.DeleteCommandColumn Obj = new EO.Web.DeleteCommandColumn();
                Obj.DeleteText = "Delete";
                EOGrid.Columns.Add(Obj);
            }

            if (Key != "")
            { EOGrid.KeyField = Key; }

            EOGrid.DataBind();
        }

        public static List<ClsBindGridColumn_EO> BindEOGrid(
            ref EO.Web.Grid EOGrid
            , string Name
            , DataTable Dt
            , string TableKey = ""
            , bool AllowSort = true
            , bool HasDelete = false)
        {
            List<ClsBindGridColumn_EO> Gc = GetBindGridColumn_EO(Name);
            BindEOGrid(ref EOGrid, Dt, Gc, TableKey, AllowSort, HasDelete);
            return Gc;
        }

        public static List<ClsBindGridColumn_EO> BindEOGrid(
            ref EO.Web.Grid EOGrid
            , string Name
            , string TableKey = ""
            , bool AllowSort = true
            , bool HasDelete = false)
        {
            DataTable Dt_Bind = Do_Methods_Query.GetQuery("System_BindDefinition", "", @"Name = '" + Name + "'");
            DataRow Dr_Bind;
            if (Dt_Bind.Rows.Count > 0)
            { Dr_Bind = Dt_Bind.Rows[0]; }
            else
            { throw new Exception("Bind Definition not found."); }

            List<ClsBindGridColumn_EO> Gc = GetBindGridColumn_EO(Name);
            DataTable Dt = Do_Methods_Query.GetQuery(
                (string)Do_Methods.IsNull(Dr_Bind["TableName"], "")
                , ""
                , (string)Do_Methods.IsNull(Dr_Bind["Condition"], "")
                , (string)Do_Methods.IsNull(Dr_Bind["Sort"], ""));

            if (TableKey.Trim() != "")
            { TableKey = (string)Do_Methods.IsNull(Dr_Bind["TableKey"], ""); }

            BindEOGrid(ref EOGrid, Dt, Gc, TableKey, AllowSort, HasDelete);

            return Gc;
        }

        public static void PostEOGrid(
            ref EO.Web.Grid EOGrid
            , DataTable Dt
            , string KeyField
            , bool HasDelete = true)
        {
            DataTable Dt_DeletedKeys = new DataTable();
            Dt_DeletedKeys.Columns.Add("Key", typeof(Int64));

            List<Int64> List_DeletedKeys = new List<long>();


            foreach (EO.Web.GridItem Gi in EOGrid.Items)
            {
                Int64 Key = (Int64)Do_Methods.IsNull(Gi.Key, 0);
                DataRow[] ArrDr = Dt.Select(KeyField + " = " + Key);
                DataRow Dr;

                if (Gi.Deleted)
                {
                    if (Key > 0)
                    { List_DeletedKeys.Add(Key); }
                    continue;
                }

                if (ArrDr.Length > 0)
                { Dr = ArrDr[0]; }
                else
                {
                    Int64 Ct = 0;
                    DataRow[] Inner_ArrDr = Dt.Select("", KeyField + " Desc");
                    if (Inner_ArrDr.Length > 0)
                    { Ct = (Int64)Inner_ArrDr[0][KeyField]; }
                    Ct++;
                    Dr = Dt.NewRow();
                    Dr[KeyField] = Ct;
                    Dt.Rows.Add(Dr);
                }

                foreach (EO.Web.GridCell Cell in Gi.Cells)
                {
                    if (Cell.Column.ReadOnly)
                    { continue; }

                    if (Cell.Column.Name == null)
                    { continue; }

                    if (Cell.Column.Name == "")
                    { continue; }

                    try
                    { Dr[Cell.Column.DataField] = Cell.Value; }
                    catch
                    { Dr[Cell.Column.DataField] = DBNull.Value; }
                }
            }

            if (HasDelete)
            {
                foreach (Int64 Key in List_DeletedKeys)
                {
                    DataRow[] ArrDr = Dt.Select(KeyField + " = " + Key);
                    if (ArrDr.Length > 0)
                    { ArrDr[0].Delete(); }
                }
            }
        }

        public static EO.Web.GridColumn FindEOGridColumn(
            EO.Web.GridColumnCollection EOGridCollection
            , string ColumnName)
        {
            EO.Web.GridColumn Gc = null;
            foreach (EO.Web.GridColumn Inner_Gc in EOGridCollection)
            {
                if (Inner_Gc.Name == ColumnName)
                {
                    Gc = Inner_Gc;
                    break;
                }
            }
            return Gc;
        }

        public static void BindEOCallBack(WebControl Wc, EO.Web.Callback EOCb, System.Web.UI.Page Page)
        {
            System.Text.StringBuilder Sb_Js = new System.Text.StringBuilder();
            Sb_Js.AppendLine(@"function ButtonClick_" + Page.ClientID + Wc.ClientID + @"() {");
            Sb_Js.AppendLine(@"eo_Callback('" + EOCb.ClientID + @"','" + Wc.ID + @"')");
            Sb_Js.AppendLine(@"}");
            Page.ClientScript.RegisterClientScriptBlock(typeof(string), Wc.ClientID, Sb_Js.ToString(), true);
            Wc.Attributes.Add("onclick", "ButtonClick_" + Page.ClientID + Wc.ClientID + "(); return false;");
        }

    }
}
