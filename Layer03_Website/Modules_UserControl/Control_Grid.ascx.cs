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
using Layer02_Objects;
using Layer02_Objects._System;
using DataObjects_Framework;
using DataObjects_Framework.Common;

namespace Layer03_Website.Modules_UserControl
{
    public partial class Control_Grid : System.Web.UI.UserControl
    {
        #region _Variables

        const string CnsObjID = "CnsObjID";
        const string CnsDt_Source = "CnsDt_Source";
        const string CnsKey = "CnsKey";
        const string CnsHasDelete = "CnsHasDelete";

        string mObjID;
        DataTable mDt_Source;
        string mKey;
        bool mHasDelete;

        #endregion

        #region _Constructor

        public Control_Grid() { }

        public void Setup(
            string Name
            , DataTable Dt
            , string Key = ""
            , bool AllowSort = false
            , bool HasDelete = false
            , bool IsReadOnly = false)
        {
            ClsSysCurrentUser Obj_CurrentUser = (ClsSysCurrentUser)this.Session[Layer01_Constants_Web.CnsSession_CurrentUser];
            this.mObjID = Obj_CurrentUser.GetNewPageObjectID();
            this.mDt_Source = Dt;

            this.ViewState[CnsObjID] = this.mObjID;
            this.Session[this.mObjID + CnsDt_Source] = this.mDt_Source;

            //[-]

            DataRow Dr_Bind = Do_Methods_Query.GetSystemBindDefinition(Name);
            string Bind_TableKey = (string)Do_Methods.IsNull(Dr_Bind["TableKey"], "");
            List<ClsBindGridColumn_EO> List_Gc = Layer01_Methods_Web_EO.GetBindGridColumn_EO(Name);
            foreach (ClsBindGridColumn_EO Gc in List_Gc)
            {
                if (Gc.mEnabled)
                { Gc.mEnabled = !IsReadOnly; }
            }

            if (!IsReadOnly)
            {
                if (HasDelete)
                {
                    ClsBindGridColumn_EO Gc = 
                        new ClsBindGridColumn_EO(
                            ""
                            , ""
                            , 80
                            , ""
                            , Layer01_Common.Common.Layer01_Constants.eSystem_Lookup_FieldType.FieldType_Delete);
                    Gc.mFieldText = "Delete";
                    Gc.mClientSideBeginEdit = "EOGrid_RowEdit";
                    List_Gc.Add(Gc);
                }
            }

            if (Key.Trim() == "")
            { Key = Bind_TableKey; }

            this.EOGrid_List.EnableKeyboardNavigation = true;
            this.EOGrid_List.StyleSetIDField = "Item_Style";
            Layer01_Methods_Web_EO.BindEOGrid(ref this.EOGrid_List, Dt, List_Gc, Key, AllowSort);

            this.ViewState[CnsKey] = Key;
            this.ViewState[CnsHasDelete] = HasDelete;

            //[-]

            this.Page_Load(null, null);
        }

        #endregion

        #region _EventHandlers

        protected void Page_Load(object sender, EventArgs e)
        {
            this.mObjID = (string)this.ViewState[CnsObjID];
            this.mDt_Source = (DataTable)this.Session[this.mObjID + CnsDt_Source];
            this.mKey = (string)this.ViewState[CnsKey];

            this.mHasDelete = false;
            try
            { this.mHasDelete = Convert.ToBoolean(this.ViewState[CnsHasDelete]); }
            catch { }
        }

        #endregion

        #region _Methods

        public void Rebind()
        {
            this.EOGrid_List.DataSource = this.mDt_Source;
            this.EOGrid_List.DataBind();

            try
            { this.EOCbp_EOGrid.Update(); }
            catch { }
        }

        public void Post()
        {
            Layer01_Methods_Web_EO.PostEOGrid(ref this.EOGrid_List, this.mDt_Source, this.mKey, this.mHasDelete);
            this.Rebind();
        }

        #endregion

        #region _Properties

        public EO.Web.Grid pGrid
        {
            get { return this.EOGrid_List; }
        }

        public DataTable pDt_Source
        {
            get { return this.mDt_Source; }
        }

        #endregion

    }
}