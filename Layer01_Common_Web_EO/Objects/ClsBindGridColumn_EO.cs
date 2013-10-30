using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.Objects;
using Layer01_Common_Web;
using Layer01_Common_Web.Common;
using Layer01_Common_Web.Objects;

namespace Layer01_Common_Web_EO.Objects
{
    public class ClsBindGridColumn_EO: ClsBindGridColumn
    {

        #region _Variables

        public string mClientSideBeginEdit;
        public string mClientSideEndEdit;
        public string mCommandName;

        public EO.Web.DatePicker mEODtp;
        public EO.Web.ElementStyle mEOGridCellStyle;

        #endregion

        #region _Constructor

        public ClsBindGridColumn_EO(string FieldName)
        {
            this.Setup(FieldName, FieldName);
        }

        public ClsBindGridColumn_EO(
            string FieldName
            , string FieldDesc
            , int Width = 100
            , string DataFormat = ""
            , Layer01_Constants.eSystem_Lookup_FieldType FieldType = Layer01_Constants.eSystem_Lookup_FieldType.FieldType_Static
            , bool Visible = true
            , bool Enabled = true
            , string ClientSideBeginEdit = ""
            , string ClientSideEndEdit = ""
            , string CommandName = "")
        {
            this.Setup(
                FieldName
                , FieldDesc
                , Width
                , DataFormat
                , FieldType
                , Visible
                , Enabled
                , ClientSideBeginEdit
                , ClientSideEndEdit
                , CommandName);
        }

        #endregion

        #region _Methods

        protected void Setup(
            string FieldName
            , string FieldDesc
            , int Width = 100
            , string DataFormat = ""
            , Layer01_Constants.eSystem_Lookup_FieldType FieldType = Layer01_Constants.eSystem_Lookup_FieldType.FieldType_Static
            , bool Visible = true
            , bool Enabled = true
            , string ClientSideBeginEdit = ""
            , string ClientSideEndEdit = ""
            , string CommandName = "")
        {
            base.Setup(FieldName, FieldDesc, Width, DataFormat, FieldType, Visible, Enabled);
            this.mClientSideBeginEdit = ClientSideBeginEdit;
            this.mClientSideEndEdit = ClientSideEndEdit;
            this.mCommandName = CommandName;
        }

        #endregion

    }
}
