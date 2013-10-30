using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Microsoft.VisualBasic;
using Layer01_Common;
using Layer01_Common.Common;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects._System;

namespace Layer02_Objects.Modules_Masterfiles
{
    public class ClsEmployee: ClsEntity_Person
    {

        #region _Constructor

        public ClsEmployee(ClsSysCurrentUser pCurrentUser)
        {
            this.Setup(
                Layer01_Common.Common.Layer01_Constants.eSystem_LookupPartyType.Employee
                , pCurrentUser
                , "Employee"
                , "uvw_Employee");
            this.Setup_AddTableDetail("Employee_Leave", "", "IsNull(IsDeleted,0) = 0");
        }

        #endregion

        #region _Properties

        public DataTable pDt_Leave
        {
            get { return this.pTableDetail_Get("Employee_Leave"); }
        }

        #endregion

    }
}
