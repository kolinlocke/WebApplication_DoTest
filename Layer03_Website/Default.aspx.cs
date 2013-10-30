using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Layer03_Website
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        { this.Server.Transfer(@"~/Modules_Page/Page_Login.aspx"); }
    }
}