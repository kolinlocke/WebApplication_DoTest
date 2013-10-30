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
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects.Modules_Masterfiles;
using Layer02_Objects.Modules_Transaction;
using Layer02_Objects._System;
using Layer01_Common_Web;
using Layer01_Common_Web.Common;

namespace Layer03_Website.Base
{
    public class ClsBasePageExList : ClsBasePageList
    {
        protected override void Page_PreInit(object sender, EventArgs e)
        {
            //base.Page_PreInit(sender, e);

            this.MasterPageFile = "~/Modules_Master/Master_ExList.master";
            this.Master.MasterPageFile = "~/Modules_Master/Master_Menu.master";
            this.mMaster = (ClsBaseMasterList)this.Master;

            this.mMaster.EvNew += this.Details_New;
            this.mMaster.EvPrint += this.Details_Print;
            this.mMaster.EvOpen += this.Details_Open;
            this.mMaster.EvSetupPage_Done += this.SetupPage_Done;
        }

    }
}