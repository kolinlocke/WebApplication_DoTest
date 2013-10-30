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
using DataObjects_Framework.BaseObjects;
using DataObjects_Framework.Common;
using DataObjects_Framework.Objects;

namespace Layer02_Objects.Modules_Base.Objects
{
    public class ClsRowProperty: Modules_Base.Abstract.ClsBase
    {
        #region _Constructor

        public ClsRowProperty(ClsSysCurrentUser pCurrentUser = null)
        { this.Setup(pCurrentUser, "RowProperty"); }

        #endregion

        #region _Methods

        public override bool Save(DataObjects_Framework.DataAccess.Interface_DataAccess Da = null)
        {
            DateTime ServerDate = Layer02_Common.GetServerDate();
            if (Convert.ToInt64(Do_Methods.IsNull(this.mHeader_Dr[this.mHeader_TableName + "ID"], 0)) == 0)
            {
                this.mHeader_Dr["EmployeeID_CreatedBy"] = this.mCurrentUser.pDrUser["EmployeeID"];
                this.mHeader_Dr["DateCreated"] = ServerDate;
            }

            this.mHeader_Dr["EmployeeID_UpdatedBy"] = this.mCurrentUser.pDrUser["EmployeeID"];
            this.mHeader_Dr["DateUpdated"] = ServerDate;

            return base.Save(Da);
        }

        #endregion
    }
}
