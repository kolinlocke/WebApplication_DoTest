using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Microsoft.VisualBasic;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.Objects;
using Layer02_Objects;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects._System;
using DataObjects_Framework;
using DataObjects_Framework.Common;
using DataObjects_Framework.Objects;

namespace Layer02_Objects.Modules_Security
{
    public class ClsUser : ClsModule
    {

        #region _Constructor

        public ClsUser(ClsSysCurrentUser pCurrentUser = null)
        {
            this.Setup(pCurrentUser, "User", "uvw_User");
            this.Setup_AddTableDetail("User_Rights", "", "1 = 0");
        }

        #endregion

        #region _Methods

        public override void Load(Keys Keys = null)
        {
            base.Load(Keys);

            DataTable Dt;            
            if (Keys == null)
            {
                List<QueryParameter> Sp = new List<QueryParameter>();
                Sp.Add(new QueryParameter("@ID", 0));
                Dt = Do_Methods_Query.ExecuteQuery("usp_User_Rights_Load", Sp).Tables[0];
            }
            else
            {
                Int64 ID = 0;
                try
                { ID = Keys["UserID"]; }
                catch { }
                List<QueryParameter> Sp = new List<QueryParameter>();
                Sp.Add(new QueryParameter("@ID", ID));
                Dt = Do_Methods_Query.ExecuteQuery("usp_User_Rights_Load", Sp).Tables[0];
            }

            this.AddRequired(Dt);
            this.pTableDetail_Set("User_Rights", Dt);
        }

        #endregion

        #region _Properties

        public DataTable pDt_Rights
        {
            get { return this.pTableDetail_Get("User_Rights"); }
        }

        #endregion

    }
}
