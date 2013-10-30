using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Layer03_Website._System
{
    public partial class FileExplorer : Page
    {

        public enum eExplorerType: int
        { 
            Images = 1
            , Pdf = 2
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            eExplorerType ExplorerType = eExplorerType.Images;
            try
            { ExplorerType = (eExplorerType)Convert.ToInt32(this.Request.QueryString["ExplorerType"]); }
            catch { }

            switch (ExplorerType)
            { 
                case eExplorerType.Images:
                    this.FileExplorer1.AllowedExtension = ".jpg|.bmp|.gif|.tif|.jpeg|.png";
                    this.FileExplorer1.RootFolder = "~/System/Uploaded/Images";
                    break;
                case eExplorerType.Pdf:
                    this.FileExplorer1.AllowedExtension = ".pdf";
                    this.FileExplorer1.RootFolder = "~/System/Uploaded/Pdf";
                    break;
            }

        }
    }
}