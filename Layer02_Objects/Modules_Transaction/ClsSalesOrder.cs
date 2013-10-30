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

namespace Layer02_Objects.Modules_Transaction
{
    public class ClsSalesOrder: ClsModule_Transaction_Item
    {
        #region _Constructor

        public ClsSalesOrder(ClsSysCurrentUser pCurrentUser = null)
        { this.Setup(pCurrentUser, "TransactionSalesOrder", "uvw_TransactionSalesOrder", "uvw_TransactionSalesOrder_DocumentItem_Desc"); }

        #endregion
    }
}
