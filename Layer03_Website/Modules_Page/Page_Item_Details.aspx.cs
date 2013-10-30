using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using DataObjects_Framework.Common;
using Layer01_Common.Common;
using Layer01_Common_Web.Common;
using Layer02_Objects._System;
using Layer02_Objects.Modules_Masterfiles;
using Layer03_Website.Base;
using Layer03_Website.Modules_UserControl;

namespace Layer03_Website.Modules_Page
{
    public partial class Page_Item_Details : ClsBasePageDetails
    {
        #region _Variables

        ClsItem mObj;

        #endregion

        #region _Constructor

        public Page_Item_Details()
        { this.Page.Init += new EventHandler(Page_Init); }

        #endregion

        #region _EventHandlers

        void Page_Init(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            { this.Setup(Layer01_Constants.eSystem_Modules.Mas_Item, new ClsItem(this.pMaster.pCurrentUser)); }
        }

        protected override void Page_Load(object sender, EventArgs e)
        {
            if (!this.CheckIsLoaded())
            {
                this.EOCb_Browse.Execute += this.EOCb_Browse_Execute;
                this.EOCb_View.Execute += this.EOCb_View_Execute;
                this.EOCb_Selection.Execute += this.EOCb_Selection_Execute;

                base.Page_Load(sender, e);
                this.mObj = (ClsItem)this.pObj_Base;
                this.UcFileBrowser.EvAccept += this.Handle_FileBrowser;
                this.UcSelection.EvAccept += this.Handle_Selection;

                if (!this.IsPostBack)
                { this.SetupPage(); }
            }
        }

        void EOCb_Browse_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            if (e.Parameter == this.Btn_Img.ID)
            { this.UcFileBrowser.Show(_System.FileExplorer.eExplorerType.Images, e.Parameter); }
            else if (
                e.Parameter == this.Btn_PdfDesc_Upload.ID
                || e.Parameter == this.Btn_PdfFaq_Upload.ID
                || e.Parameter == this.Btn_PdfOther_Upload.ID)
            { this.UcFileBrowser.Show(_System.FileExplorer.eExplorerType.Pdf, e.Parameter); }
        }

        void EOCb_View_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            string Url = "";
            if (e.Parameter == this.Btn_PdfDesc.ID)
            { Url = Layer01_Constants_Web.CnsPdfPath + HttpUtility.UrlPathEncode((string)Do_Methods.IsNull(this.mObj.pDr["PdfDesc_Path"], "")); }
            else if (e.Parameter == this.Btn_PdfFaq.ID)
            { Url = Layer01_Constants_Web.CnsPdfPath + HttpUtility.UrlPathEncode((string)Do_Methods.IsNull(this.mObj.pDr["PdfFaq_Path"], "")); }
            else if (e.Parameter == this.Btn_PdfFaq.ID)
            { Url = Layer01_Constants_Web.CnsPdfPath + HttpUtility.UrlPathEncode((string)Do_Methods.IsNull(this.mObj.pDr["PdfOthers_Path"], "")); }
            else if (e.Parameter == this.Btn_ViewImage.ID)
            { Url = Layer01_Constants_Web.CnsImagePath + HttpUtility.UrlPathEncode((string)Do_Methods.IsNull(this.mObj.pDr["Image_Path"], "")); }

            e.Data = this.Page.ResolveUrl(Url);
        }

        void EOCb_Selection_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            try
            {
                if (e.Parameter == this.Btn_AddItemPart.ID)
                { this.UcSelection.Show("Select_Item", "", true, e.Parameter); }
                else if (e.Parameter == this.Btn_AddItemSupplier.ID)
                { this.UcSelection.Show("Select_Supplier", "", true, e.Parameter); }
                else if (e.Parameter == this.Btn_AddItemLocation.ID)
                { this.UcSelection.Show("Select_Warehouse", "", true, e.Parameter); }
            }
            catch (Exception Ex)
            {
                Layer01_Methods_Web.ErrorHandler(Ex, this.Server);
                throw Ex;
            }
        }

        #endregion

        #region _Methods

        void SetupPage()
        {
            this.SetupPage_ControlAttributes();
            this.SetupPage_Lookups();

            //[-]

            this.Txt_ItemCode.Text = Do_Methods.Convert_String(this.mObj.pDr_RowProperty["Code"]);
            this.Txt_ItemName.Text = Do_Methods.Convert_String(this.mObj.pDr_RowProperty["Name"]);
            this.Txt_Remarks.Text = Do_Methods.Convert_String(this.mObj.pDr_RowProperty["Remarks"]);
            this.Txt_Warranty.Text = Do_Methods.Convert_String(this.mObj.pDr["Warranty"]);

            this.Chk_IsSerial.Checked = Do_Methods.Convert_Boolean(this.mObj.pDr["IsSerial"]);

            this.Txt_Length.Text = Do_Methods.Convert_Double(this.mObj.pDr["Size_Length"]).ToString("#,##0.0000");
            this.Txt_Width.Text = Do_Methods.Convert_Double(this.mObj.pDr["Size_Width"]).ToString("#,##0.0000");
            this.Txt_Height.Text = Do_Methods.Convert_Double(this.mObj.pDr["Size_Height"]).ToString("#,##0.0000");
            this.Txt_Weight.Text = Do_Methods.Convert_Double(this.mObj.pDr["Size_Weight"]).ToString("#,##0.0000");

            this.Txt_FloorLevel.Text = Do_Methods.Convert_Int64(this.mObj.pDr["Inv_FloorLevel"]).ToString("#,##0");
            this.Txt_CeilingLevel.Text = Do_Methods.Convert_Int64(this.mObj.pDr["Inv_CeilingLevel"]).ToString("#,##0");
            this.Txt_ReorderLevel.Text = Do_Methods.Convert_Int64(this.mObj.pDr["Inv_ReorderLevel"]).ToString("#,##0");

            this.Txt_EstimatedCost.Text = Do_Methods.Convert_Double(this.mObj.pDr["Cost"]).ToString("#,##0.00");
            this.Txt_ListPrice.Text = Do_Methods.Convert_Double(this.mObj.pDr["Price"], 0).ToString("#,##0.00");

            bool IsImageFile = false;
            if ((string)Do_Methods.IsNull(this.mObj.pDr["Image_Path"], "") != "")
            {
                IsImageFile = true;
                System.IO.FileInfo Fi_Thumb =
                    new System.IO.FileInfo(
                        this.MapPath(Layer01_Constants_Web.CnsImageThumbPath
                        + "Thumb_"
                        + (string)Do_Methods.IsNull(this.mObj.pDr["Image_Path"], "")));
                if (!Fi_Thumb.Exists)
                {
                    try
                    {
                        Layer01_Methods_Web.ImageThumbnail(
                        this.MapPath(Layer01_Constants_Web.CnsImageThumbPath
                        + (string)Do_Methods.IsNull(this.mObj.pDr["Image_Path"], ""))
                        , Fi_Thumb.FullName);
                    }
                    catch
                    { IsImageFile = false; }
                }

                this.Img_Box.ImageUrl = Layer01_Constants_Web.CnsImageThumbPath + "Thumb_" + (string)Do_Methods.IsNull(this.mObj.pDr["Image_Path"], "");
                this.Btn_ViewImage.Visible = true;
            }

            if (!IsImageFile)
            {
                this.Img_Box.ImageUrl = "~/System/Images/QuestionMark001.jpg";
                this.Btn_ViewImage.Visible = false;
            }

            if ((string)Do_Methods.IsNull(this.mObj.pDr["PdfDesc_Path"], "") == "")
            {
                this.Btn_PdfDesc.CssClass = Layer01_Constants_Web.CnsCssControlEnabledFalse;
                this.Btn_PdfDesc.Enabled = false;
            }
            else
            {
                this.Btn_PdfDesc.CssClass = Layer01_Constants_Web.CnsCssControlEnabled;
                this.Btn_PdfDesc.Enabled = true;
            }

            if ((string)Do_Methods.IsNull(this.mObj.pDr["PdfFaq_Path"], "") == "")
            {
                this.Btn_PdfFaq.CssClass = Layer01_Constants_Web.CnsCssControlEnabledFalse;
                this.Btn_PdfFaq.Enabled = false;
            }
            else
            {
                this.Btn_PdfFaq.CssClass = Layer01_Constants_Web.CnsCssControlEnabled;
                this.Btn_PdfFaq.Enabled = true;
            }

            if ((string)Do_Methods.IsNull(this.mObj.pDr["PdfOthers_Path"], "") == "")
            {
                this.Btn_PdfOther.CssClass = Layer01_Constants_Web.CnsCssControlEnabledFalse;
                this.Btn_PdfOther.Enabled = false;
            }
            else
            {
                this.Btn_PdfOther.CssClass = Layer01_Constants_Web.CnsCssControlEnabled;
                this.Btn_PdfOther.Enabled = true;
            }

            DataTable Dt_Defaults = Do_Methods_Query.GetQuery("uvw_Lookup");
            this.Cbo_Category.SelectedValue = ((Int64)Do_Methods.IsNull(this.mObj.pDr["LookupID_Category"], this.SetupPage_GetLookupDefault(Dt_Defaults, Layer01_Constants.eLookup.Category))).ToString();
            this.Cbo_ItemType.SelectedValue = ((Int64)Do_Methods.IsNull(this.mObj.pDr["LookupID_ItemType"], this.SetupPage_GetLookupDefault(Dt_Defaults, Layer01_Constants.eLookup.ItemType))).ToString();
            this.Cbo_Brand.SelectedValue = ((Int64)Do_Methods.IsNull(this.mObj.pDr["LookupID_Brand"], this.SetupPage_GetLookupDefault(Dt_Defaults, Layer01_Constants.eLookup.Brand))).ToString();
            this.Cbo_Retailer.SelectedValue = ((Int64)Do_Methods.IsNull(this.mObj.pDr["LookupID_Category"], this.SetupPage_GetLookupDefault(Dt_Defaults, Layer01_Constants.eLookup.Retailer))).ToString();
            this.Cbo_ItemUOM.SelectedValue = ((Int64)Do_Methods.IsNull(this.mObj.pDr["LookupID_ItemUOM"], this.SetupPage_GetLookupDefault(Dt_Defaults, Layer01_Constants.eLookup.UOM))).ToString();

            //[-]

            this.UcGrid_ItemPart.Setup(
                "Item_Part"
                , this.mObj.pDt_Part
                , "TmpKey"
                , false
                , true
                , this.mMaster.pIsReadOnly);
            this.UcGrid_ItemPart.pGrid.FullRowMode = false;

            this.UcGrid_ItemLocation.Setup(
                "Item_Location"
                , this.mObj.pDt_Location
                , "TmpKey"
                , false
                , true
                , this.mMaster.pIsReadOnly);
            this.UcGrid_ItemLocation.pGrid.FullRowMode = false;

            this.UcGrid_ItemSupplier.Setup(
                "Item_Supplier"
                , this.mObj.pDt_Supplier
                , "TmpKey"
                , false
                , true
                , this.mMaster.pIsReadOnly);
            this.UcGrid_ItemSupplier.pGrid.FullRowMode = false;

            DataTable Dt = Do_Methods_Query.GetQuery(
                "uvw_Materialized_InventoryWarehouse_Current_Item"
                , ""
                , "ItemID = " + Convert.ToInt64(Do_Methods.IsNull(this.mObj.pDr["ItemID"], 0)).ToString()
                , "WarehouseCodeName");
            this.mObj.AddRequired(Dt);
            this.UcGrid_OnHand.Setup("Item_Inventory", Dt);
            this.UcGrid_OnHand.pGrid.FullRowMode = false;
        }

        void SetupPage_Lookups()
        {
            Layer01_Methods_Web.BindCombo(ref this.Cbo_Category, Do_Methods_Query.GetLookup("Category"), "LookupID", "Desc", 0, "-Select-");
            Layer01_Methods_Web.BindCombo(ref this.Cbo_ItemType, Do_Methods_Query.GetLookup("ItemType"), "LookupID", "Desc", 0, "-Select-");
            Layer01_Methods_Web.BindCombo(ref this.Cbo_Brand, Do_Methods_Query.GetLookup("Brand"), "LookupID", "Desc", 0, "-Select-");
            Layer01_Methods_Web.BindCombo(ref this.Cbo_Retailer, Do_Methods_Query.GetLookup("Retailer"), "LookupID", "Desc", 0, "-Select-");
            Layer01_Methods_Web.BindCombo(ref this.Cbo_ItemUOM, Do_Methods_Query.GetLookup("UOM"), "LookupID", "Desc", 0, "-Select-");
        }

        void SetupPage_ControlAttributes()
        {
            this.SetupPage_ControlAttributes_BindEOCallback(this.Btn_Img, this.EOCb_Browse);
            this.SetupPage_ControlAttributes_BindEOCallback(this.Btn_PdfDesc_Upload, this.EOCb_Browse);
            this.SetupPage_ControlAttributes_BindEOCallback(this.Btn_PdfFaq_Upload, this.EOCb_Browse);
            this.SetupPage_ControlAttributes_BindEOCallback(this.Btn_PdfOther_Upload, this.EOCb_Browse);

            this.SetupPage_ControlAttributes_BindEOCallback(this.Btn_PdfDesc, this.EOCb_View);
            this.SetupPage_ControlAttributes_BindEOCallback(this.Btn_PdfFaq, this.EOCb_View);
            this.SetupPage_ControlAttributes_BindEOCallback(this.Btn_ViewImage, this.EOCb_View);

            this.SetupPage_ControlAttributes_BindEOCallback(this.Btn_AddItemLocation, this.EOCb_Selection);
            this.SetupPage_ControlAttributes_BindEOCallback(this.Btn_AddItemPart, this.EOCb_Selection);
            this.SetupPage_ControlAttributes_BindEOCallback(this.Btn_AddItemSupplier, this.EOCb_Selection);
        }

        protected override void Save()
        {
            this.UcGrid_ItemPart.Post();
            this.UcGrid_ItemLocation.Post();
            this.UcGrid_ItemSupplier.Post();

            //[-]

            //System.Text.StringBuilder Sb_ErrorMsg = new System.Text.StringBuilder();
            //if (!this.Save_Validation(ref Sb_ErrorMsg))
            //{
            //    this.Show_EventMsg(Sb_ErrorMsg.ToString(), ClsBaseMasterDetails.eStatus.Event_Error);
            //    return;
            //}

            //[-]

            this.mObj.pDr_RowProperty["Code"] = this.Txt_ItemCode.Text;
            this.mObj.pDr_RowProperty["Name"] = this.Txt_ItemName.Text;
            this.mObj.pDr_RowProperty["Remarks"] = this.Txt_Remarks.Text;

            this.mObj.pDr["Warranty"] = this.Txt_Warranty.Text;
            this.mObj.pDr["IsSerial"] = this.Chk_IsSerial.Checked;
            this.mObj.pDr["LookupID_ItemType"] = Convert.ToInt64(this.Cbo_ItemType.SelectedValue);
            this.mObj.pDr["LookupID_Brand"] = Convert.ToInt64(this.Cbo_Brand.SelectedValue);
            this.mObj.pDr["LookupID_Retailer"] = Convert.ToInt64(this.Cbo_Retailer.SelectedValue);
            this.mObj.pDr["LookupID_ItemUOM"] = Convert.ToInt64(this.Cbo_ItemUOM.SelectedValue);
            
            this.mObj.pDr["Size_Length"] = Do_Methods.Convert_Double(this.Txt_Length.Text);
            this.mObj.pDr["Size_Width"] = Do_Methods.Convert_Double(this.Txt_Width.Text);
            this.mObj.pDr["Size_Height"] = Do_Methods.Convert_Double(this.Txt_Height.Text);
            this.mObj.pDr["Size_Weight"] = Do_Methods.Convert_Double(this.Txt_Weight.Text);

            this.mObj.pDr["Inv_FloorLevel"] = Do_Methods.Convert_Int64(this.Txt_FloorLevel.Text);
            this.mObj.pDr["Inv_ReorderLevel"] = Do_Methods.Convert_Int64(this.Txt_ReorderLevel.Text);
            this.mObj.pDr["Inv_CeilingLevel"] = Do_Methods.Convert_Int64(this.Txt_CeilingLevel.Text);

            this.mObj.pDr["Cost"] = Do_Methods.Convert_Double(this.Txt_EstimatedCost.Text);
            this.mObj.pDr["Price"] = Do_Methods.Convert_Double(this.Txt_ListPrice.Text);

            Do_Methods.ConvertCaps(this.mObj.pDr_RowProperty);            
            Do_Methods.ConvertCaps(this.mObj.pDr);

            //[-]

            ClsItemValidation Obj_Validation = new ClsItemValidation();
            Obj_Validation.Setup(this.mObj);
            if (!Obj_Validation.Validate())
            {
                this.Txt_ItemCode.CssClass = Layer01_Constants_Web.CnsCssTextbox;
				//if (Obj_Validation.pList_ValidationError.Exists(X => X.Name == ClsItemValidation.eErrors.Err_Code.ToString()))
                if (Obj_Validation.FindError(ClsItemValidation.eErrors.Err_Code.ToString()))
                { this.Txt_ItemCode.CssClass = Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight; }

                this.Txt_ItemName.CssClass = Layer01_Constants_Web.CnsCssTextbox;
				//if (Obj_Validation.pList_ValidationError.Exists(X => X.Name == ClsItemValidation.eErrors.Err_Name.ToString()))
                if (Obj_Validation.FindError(ClsItemValidation.eErrors.Err_Name.ToString()))
				{ this.Txt_ItemName.CssClass = Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight; }

                //List<String> Msg = (from O in Obj_Validation.pList_ValidationError select O.Message).ToList();
                //this.Show_EventMsg(Msg, ClsBaseMasterDetails.eStatus.Event_Error);

                this.Show_EventMsg(Obj_Validation.GetErrors(), ClsBaseMasterDetails.eStatus.Event_Error);
            }

            //[-]

            base.Save();
        }

        bool Save_Validation(ref StringBuilder Sb_Msg)
        {
            WebControl Wc;
            bool IsValid = true;

            this.Txt_ItemCode.CssClass = Layer01_Constants_Web.CnsCssTextbox;
            if (this.Txt_ItemCode.Text.Trim() == "")
            { this.Txt_ItemCode.Text = Layer02_Common.GetSeriesNo("Item"); }
            
            Wc = this.Txt_ItemCode;
            ClsBasePageDetails.Save_Validation(
                ref Sb_Msg
                , ref Wc
                , ref IsValid
                , Layer01_Constants_Web.CnsCssTextbox
                , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                , (Layer02_Common.CheckSeriesDuplicate("uvw_Item", "Code", this.mObj.GetKeys(), this.Txt_ItemCode.Text))
                , "Duplicate Item No. found. Please change the Item No." + "<br />");

            Wc = this.Txt_ItemName;
            ClsBasePageDetails.Save_Validation(
                ref Sb_Msg
                , ref Wc
                , ref IsValid
                , Layer01_Constants_Web.CnsCssTextbox
                , Layer01_Constants_Web.CnsCssTextbox_ValidateHighlight
                , (this.Txt_ItemName.Text.Trim() != "")
                , "Item Name is required." + "<br />");

            return IsValid;            
        }

        //[-]

        void Handle_FileBrowser(
            string SelectedFile
            , EO.Web.CallbackEventArgs e
            , string Data)
        {
            if (Data == this.Btn_Img.ID)
            { this.Details_SelectImage(SelectedFile); }
            else if (Data == this.Btn_PdfDesc_Upload.ID)
            { this.Details_SelectPdfDesc(SelectedFile); }
            else if (Data == this.Btn_PdfFaq_Upload.ID)
            { this.Details_SelectPdfFaq(SelectedFile); }
            else if (Data == this.Btn_PdfOther_Upload.ID)
            { this.Details_SelectPdfOthers(SelectedFile); }
        }

        void Details_SelectImage(string SelectedFile)
        {
            System.IO.FileInfo Fi = new System.IO.FileInfo(this.MapPath(SelectedFile));
            string FileName_Thumb = Layer01_Constants_Web.CnsImageThumbPath + "Thumb_" + Fi.Name;
            System.IO.FileInfo Fi_Thumb = new System.IO.FileInfo(this.MapPath(FileName_Thumb));

            Layer01_Methods_Web.ImageThumbnail(Fi.FullName, Fi_Thumb.FullName);

            this.Img_Box.ImageUrl = this.ResolveUrl(FileName_Thumb);
            this.mObj.pDr["Image_Path"] = Fi.Name;
            this.Btn_ViewImage.Visible = true;

            try
            { this.EOCbp_Image.Update(); }
            catch { }
        }

        void Details_SelectPdfDesc(string SelectedFile)
        {
            System.IO.FileInfo Fi = new System.IO.FileInfo(SelectedFile);

            this.mObj.pDr["PdfDesc_Path"] = Fi.Name;

            if ((string)Do_Methods.IsNull(this.mObj.pDr["PdfDesc_Path"], "") == "")
            {
                this.Btn_PdfDesc.CssClass = Layer01_Constants_Web.CnsCssControlEnabledFalse;
                this.Btn_PdfDesc.Enabled = false;
            }
            else
            {
                this.Btn_PdfDesc.CssClass = Layer01_Constants_Web.CnsCssControlEnabled;
                this.Btn_PdfDesc.Enabled = true;
            }

            try
            { this.EOCbp_PdfDesc.Update(); }
            catch { }
        }

        void Details_SelectPdfFaq(string SelectedFile)
        {
            System.IO.FileInfo Fi = new System.IO.FileInfo(SelectedFile);

            this.mObj.pDr["PdfFaq_Path"] = Fi.Name;

            if ((string)Do_Methods.IsNull(this.mObj.pDr["PdfFaq_Path"], "") == "")
            {
                this.Btn_PdfFaq.CssClass = Layer01_Constants_Web.CnsCssControlEnabledFalse;
                this.Btn_PdfFaq.Enabled = false;
            }
            else
            {
                this.Btn_PdfFaq.CssClass = Layer01_Constants_Web.CnsCssControlEnabled;
                this.Btn_PdfFaq.Enabled = true;
            }

            try
            { this.EOCbp_PdfFaq.Update(); }
            catch { }
        }

        void Details_SelectPdfOthers(string SelectedFile)
        {
            System.IO.FileInfo Fi = new System.IO.FileInfo(SelectedFile);

            this.mObj.pDr["PdfOthers_Path"] = Fi.Name;

            if ((string)Do_Methods.IsNull(this.mObj.pDr["PdfOthers_Path"], "") == "")
            {
                this.Btn_PdfOther.CssClass = Layer01_Constants_Web.CnsCssControlEnabledFalse;
                this.Btn_PdfOther.Enabled = false;
            }
            else
            {
                this.Btn_PdfOther.CssClass = Layer01_Constants_Web.CnsCssControlEnabled;
                this.Btn_PdfOther.Enabled = true;
            }

            try
            { this.EOCbp_PdfOther.Update(); }
            catch { }
        }

        //[-]

        void Handle_Selection(DataTable Dt, EO.Web.CallbackEventArgs e, string Data)
        {
            Int64 ID = 0;
            if (Dt.Rows.Count > 0)
            { ID = (Int64)Do_Methods.IsNull(Dt.Rows[0]["ID"], 0); }

            System.Text.StringBuilder Sb_Js = new System.Text.StringBuilder();

            if (Data == this.Btn_AddItemPart.ID)
            { this.Details_AddItemPart(Dt); }
            else if (Data == this.Btn_AddItemLocation.ID)
            { this.Details_AddItemLocation(Dt); }
            if (Data == this.Btn_AddItemSupplier.ID)
            { this.Details_AddItemSupplier(Dt); }
        }

        void Details_AddItemPart(DataTable Dt_Selected)
        {
            this.UcGrid_ItemPart.Post();

            List<Control_Selection.Str_AddSelectedFields> Obj_Fields = new List<Control_Selection.Str_AddSelectedFields>();
            Obj_Fields.Add(new Control_Selection.Str_AddSelectedFields("Part_ItemCode", "ItemCode"));
            Obj_Fields.Add(new Control_Selection.Str_AddSelectedFields("Part_ItemName", "ItemName"));
            Obj_Fields.Add(new Control_Selection.Str_AddSelectedFields("Part_ItemCodeName", "ItemCodeName"));

            List<Control_Selection.Str_AddSelectedFieldsDefault> Obj_FieldsDefault = new List<Control_Selection.Str_AddSelectedFieldsDefault>();
            Obj_FieldsDefault.Add(new Control_Selection.Str_AddSelectedFieldsDefault("Qty", 1));
            Obj_FieldsDefault.Add(new Control_Selection.Str_AddSelectedFieldsDefault("IsActive", true));

            Control_Selection.AddSelected(
                this.mObj.pDt_Part
                , Dt_Selected
                , "uvw_Item"
                , "ItemID"
                , "ItemID_Part"
                , Obj_Fields
                , Obj_FieldsDefault);

            this.UcGrid_ItemPart.Rebind();
        }

        void Details_AddItemLocation(DataTable Dt_Selected)
        {
            this.UcGrid_ItemLocation.Post();

            List<Control_Selection.Str_AddSelectedFields> Obj_Fields = new List<Control_Selection.Str_AddSelectedFields>();
            Obj_Fields.Add(new Control_Selection.Str_AddSelectedFields("WarehouseCodeName", "WarehouseCodeName"));

            Control_Selection.AddSelected(
                this.mObj.pDt_Location
                , Dt_Selected
                , "uvw_Warehouse"
                , "WarehouseID"
                , "WarehouseID"
                , Obj_Fields);

            this.UcGrid_ItemLocation.Rebind();
        }

        void Details_AddItemSupplier(DataTable Dt_Selected)
        {
            this.UcGrid_ItemSupplier.Post();

            List<Control_Selection.Str_AddSelectedFields> Obj_Fields = new List<Control_Selection.Str_AddSelectedFields>();
            Obj_Fields.Add(new Control_Selection.Str_AddSelectedFields("SupplierCodeName", "SupplierCodeName"));

            List<Control_Selection.Str_AddSelectedFieldsDefault> Obj_FieldsDefault = new List<Control_Selection.Str_AddSelectedFieldsDefault>();
            Obj_FieldsDefault.Add(new Control_Selection.Str_AddSelectedFieldsDefault("IsActive", true));

            Control_Selection.AddSelected(
                this.mObj.pDt_Supplier
                , Dt_Selected
                , "uvw_Supplier"
                , "SupplierID"
                , "SupplierID"
                , Obj_Fields
                , Obj_FieldsDefault);

            this.UcGrid_ItemSupplier.Rebind();
        }

        #endregion
    }
}