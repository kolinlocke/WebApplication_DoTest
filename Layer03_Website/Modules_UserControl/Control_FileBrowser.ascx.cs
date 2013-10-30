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

namespace Layer03_Website.Modules_UserControl
{
    public partial class Control_FileBrowser : System.Web.UI.UserControl
    {

        #region _Events

        public delegate void DsAccept(string SelectedFile, EO.Web.CallbackEventArgs e, string Data);
        public event DsAccept EvAccept;

        #endregion

        #region _Variables

        const string CnsData = "CnsData";
        
        #endregion

        #region _Constructor

        public Control_FileBrowser() { }

        #endregion

        #region _EventHandlers

        protected void Page_Load(object sender, EventArgs e)
        {
            this.EOCb_Accept.Execute += new EO.Web.CallbackEventHandler(EOCb_Accept_Execute);

            //[-]

            System.Text.StringBuilder Sb_Js = new System.Text.StringBuilder();
            Sb_Js.AppendLine(@"function Selection_Accept_" + this.ClientID + @"(dialog, arg) {");
            Sb_Js.AppendLine(@"var SelectedFile = eo_GetObject('" + this.FileExplorerHolder1.ClientID + @"').getSelectedFile();");
            Sb_Js.AppendLine(@"eo_Callback('" + this.EOCb_Accept.ClientID + @"', SelectedFile);");
            Sb_Js.AppendLine("}");

            this.Page.ClientScript.RegisterClientScriptBlock(typeof(string), this.ClientID, Sb_Js.ToString(), true);
        }

        void EOCb_Accept_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            string SelectedFile = e.Parameter;
            string Data = (string)this.ViewState[CnsData];

            if (EvAccept != null)
            { EvAccept(SelectedFile, e, Data); }
        }

        #endregion

        #region _Methods

        public void Show(_System.FileExplorer.eExplorerType FileExplorer, string Data = "")
        {
            this.ViewState[CnsData] = Data;
            this.FileExplorerHolder1.Url = "~/System/FileExplorer.aspx?ExplorerType=" + ((int)FileExplorer).ToString();
            this.EODialog_BrowseFile.ClientSideOnAccept = "Selection_Accept_" + this.ClientID;
            this.EODialog_BrowseFile.Show();

            try
            { this.EOCbp_BrowseFile.Update(); }
            catch { }
        }

        #endregion

        #region _Properties

        public EO.Web.CallbackPanel pEOCbp
        {
            get { return this.EOCbp_BrowseFile; }
        }

        public EO.Web.Dialog pEODialog
        {
            get { return this.EODialog_BrowseFile; }
        }

        #endregion

    }
}