using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Layer02_Objects;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects.Modules_Masterfiles;
using Layer02_Objects.Modules_Transaction;
using Layer03_Website;
using Layer03_Website.Base;

namespace Layer03_Website.Modules_Page
{
    public partial class Page_Employee : ClsBasePageList
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                this.pMaster.Setup(
                    Layer01_Common.Common.Layer01_Constants.eSystem_Modules.Mas_Employee
                    , new ClsEmployee(this.pMaster.pCurrentUser)
                    , "Employee");
            }
        }
    }
}