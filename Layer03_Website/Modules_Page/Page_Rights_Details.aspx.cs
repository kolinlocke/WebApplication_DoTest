using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
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
using Layer02_Objects;
using Layer02_Objects._System;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects.Modules_Masterfiles;
using Layer02_Objects.Modules_Transaction;
using Layer02_Objects.Modules_Security;
using Layer03_Website;
using Layer03_Website.Base;
using DataObjects_Framework;
using DataObjects_Framework.Common;
using DataObjects_Framework.Objects;

namespace Layer03_Website.Modules_Page
{
    public partial class Page_Rights_Details : ClsBasePageDetails
    {

        #region _Variables

        ClsRights mObj;
        const string CnsDt_FilterFields = "CnsDt_FilterFields";

        #endregion

        #region _Constructor

        public Page_Rights_Details()
        { this.Page.Init += new EventHandler(Page_Init); }

        #endregion

        #region _EventHandlers

        void Page_Init(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                this.Setup(
                    Layer01_Common.Common.Layer01_Constants.eSystem_Modules.Sec_Rights
                    , new ClsRights(this.pMaster.pCurrentUser));
            }
        }
        
        protected override void Page_Load(object sender, EventArgs e)
        {
            if (!this.CheckIsLoaded())
            {
                this.EOCb_Filter.Execute += new EO.Web.CallbackEventHandler(EOCb_Filter_Execute);
                
                //[-]

                base.Page_Load(sender, e);
                this.mObj = (ClsRights)this.pObj_Base;
                
                if (!this.IsPostBack)
                { this.SetupPage(); }
            }
        }

        void EOCb_Filter_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            this.UcGrid_Details.Post();

            if (e.Parameter == this.Btn_Search.ID)
            { this.BindGrid_Details_Filter(); }
            else if (e.Parameter == this.Btn_ClearSearch.ID)
            { this.BindGrid_Details_ClearFilter(); }
            else if (e.Parameter == this.Btn_CheckAll.ID)
            { this.BindGrid_Details_Check(true); }
            else if (e.Parameter == this.Btn_UncheckAll.ID)
            { this.BindGrid_Details_Check(false); }
                        
            this.UcGrid_Details.Rebind();
        }

        #endregion

        #region _Methods

        void SetupPage()
        {
            this.Txt_Name.Text = (string)Do_Methods.IsNull(this.mObj.pDr_RowProperty["Name"], "");
            this.Txt_Desc.Text = (string)Do_Methods.IsNull(this.mObj.pDr_RowProperty["Remarks"], "");

            this.BindGrid_Details();
        }

        void BindGrid_Details()
        {
            this.UcGrid_Details.Setup("Rights_Details", this.mObj.pDt_Details, "TmpKey", true);

            //[-]

            DataTable Dt_FilterFields = new DataTable();
            Dt_FilterFields.Columns.Add("Desc", typeof(string));
            Dt_FilterFields.Columns.Add("Field", typeof(string));
            Dt_FilterFields.Columns.Add("DataType", typeof(string));

            List<ClsBindGridColumn_EO> List_Gc = Layer01_Methods_Web_EO.GetBindGridColumn_EO("Rights_Details");
            foreach (ClsBindGridColumn Gc in List_Gc)
            {
                if (Gc.mVisible && Gc.mFieldName != "")
                {
                    List<QueryParameter> Sp = new List<QueryParameter>();
                    Sp.Add(new QueryParameter("Field", Gc.mFieldName));
                    Sp.Add(new QueryParameter("Desc", Gc.mFieldDesc));
                    Sp.Add(new QueryParameter("DataType", this.mObj.pDt_Details.Columns[Gc.mFieldName].DataType.Name));
                    Do_Methods.AddDataRow(ref Dt_FilterFields, Sp);
                }
            }

            Layer01_Methods_Web.BindCombo(ref this.Cbo_SearchFilter, Dt_FilterFields, "Field", "Desc");
            this.ViewState[CnsDt_FilterFields] = Dt_FilterFields;
        }

        void BindGrid_Details_Filter()
        {
            DataTable Dt_FilterFields = (this.ViewState[CnsDt_FilterFields] != null) ? (DataTable)this.ViewState[CnsDt_FilterFields] : null;
            string FilterText = "";

            DataRow[] ArrDr = Dt_FilterFields.Select("Field = '" + this.Cbo_SearchFilter.SelectedValue + "'");
            if (ArrDr.Length > 0)
            {
                Type Inner_DataType = Type.GetType(Do_Methods.Convert_String(ArrDr[0]["DataType"]));

                //FilterText = Do_Methods.PrepareFilterText(
                //    (string)Do_Methods.IsNull(ArrDr[0]["Field"], "")
                //    , (string)Do_Methods.IsNull(ArrDr[0]["DataType"], "")
                //    , this.Txt_Search.Text);

                FilterText = Do_Methods.PrepareFilterText(
                    (string)Do_Methods.IsNull(ArrDr[0]["Field"], "")
                    , Inner_DataType
                    , this.Txt_Search.Text);
            }

            this.UcGrid_Details.pDt_Source.DefaultView.RowFilter = FilterText;
        }

        void BindGrid_Details_ClearFilter()
        { this.UcGrid_Details.pDt_Source.DefaultView.RowFilter = ""; }

        void BindGrid_Details_Check(bool IsCheck = true)
        {
            DataTable Dt = this.mObj.pDt_Details;
            foreach (DataRow Dr in Dt.Select(Dt.DefaultView.RowFilter))
            { Dr["IsAllowed"] = IsCheck; }

        }

        protected override void Save()
        {
            this.UcGrid_Details.Post();

            System.Text.StringBuilder Sb_Error = new System.Text.StringBuilder();
            if (!this.Save_Validation(Sb_Error))
            {
                this.Show_EventMsg(Sb_Error.ToString(), ClsBaseMasterDetails.eStatus.Event_Error);
                return;
            }

            this.mObj.pDr_RowProperty["Name"] = this.Txt_Name.Text;
            this.mObj.pDr_RowProperty["Remarks"] = this.Txt_Desc.Text;

            base.Save();
        }

        bool Save_Validation(System.Text.StringBuilder Sb_Msg)
        {
            bool IsValid = true;
            WebControl Wc;

            Wc = this.Txt_Name;
            Layer01_Methods_Web.Save_Validation(
                ref Sb_Msg
                , ref Wc
                , ref IsValid
                , Layer01_Constants_Web.CnsCssTextbox
                , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                , (this.Txt_Name.Text != "")
                , "Rights Name is required. <br />");

            return IsValid;
        }

        #endregion
        
    }
}