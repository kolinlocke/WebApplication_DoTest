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

namespace Layer02_Objects.Modules_Base.Objects
{
    public class ClsAddress: ClsBase
    {
        #region _Constructor

        public ClsAddress(ClsSysCurrentUser pCurrentUser = null)
        { this.Setup(pCurrentUser, "Address", "uvw_Address"); }

        #endregion
    }
}
