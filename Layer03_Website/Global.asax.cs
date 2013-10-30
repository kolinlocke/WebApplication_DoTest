using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace Layer03_Website
{
    public class Global : HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            EO.Web.Runtime.DebugLevel = 0;

            System.Collections.Specialized.NameValueCollection WebConfig = System.Configuration.ConfigurationManager.AppSettings;

            //Layer01_Common.Common.Global_Variables.gConnection_Server = WebConfig["Server"];
            //Layer01_Common.Common.Global_Variables.gConnection_Database = WebConfig["Database"];
            //Layer01_Common.Common.Global_Variables.gConnection_Username = WebConfig["UserName"];
            //Layer01_Common.Common.Global_Variables.gConnection_Password = WebConfig["Password"];

            DataObjects_Framework.Common.Do_Globals.gSettings.pConnectionString = WebConfig["DatabaseConnection"];
            DataObjects_Framework.Common.Do_Globals.gSettings.pCollection.Add(Layer01_Common.Common.Layer01_Constants.CnsConnectionString_Cache, WebConfig["DatabaseConnection_Cache"]);

        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {
            Layer01_Common_Web.Common.Layer01_Methods_Web.ErrorHandler(this.Server.GetLastError().InnerException, this.Server);
        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}