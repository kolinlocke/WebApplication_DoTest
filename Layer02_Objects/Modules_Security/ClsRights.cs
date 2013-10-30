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
using DataObjects_Framework.Connection;
using DataObjects_Framework.Common;
using DataObjects_Framework.DataAccess;
using DataObjects_Framework.Objects;

namespace Layer02_Objects.Modules_Security
{
    public class ClsRights : ClsModule
    {
        #region _Constructor

        public ClsRights(ClsSysCurrentUser pCurrentUser = null)
        {
            this.Setup(pCurrentUser, "Rights", "uvw_Rights");
            this.Setup_AddTableDetail("Rights_Details", "", "1 = 0");
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
                Dt = Do_Methods_Query.ExecuteQuery("usp_Rights_Details_Load", Sp).Tables[0];
            }
            else
            {
                Int64 ID = 0;
                try
                { ID = Keys["RightsID"]; }
                catch { }
                List<QueryParameter> Sp = new List<QueryParameter>();
                Sp.Add(new QueryParameter("@ID", ID));
                Dt = Do_Methods_Query.ExecuteQuery("usp_Rights_Details_Load", Sp).Tables[0];
            }

            this.AddRequired(Dt);
            this.pTableDetail_Set("Rights_Details", Dt);
        }

        #endregion

        #region _Properties

        public DataTable pDt_Details
        {
            get { return this.pTableDetail_Get("Rights_Details"); }
        }

        #endregion

    }
}
