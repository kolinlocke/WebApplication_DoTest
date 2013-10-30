﻿using System;
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
    public class ClsDocumentItem: ClsBase
    {
        #region _Constructor

        public ClsDocumentItem(ClsSysCurrentUser pCurrentUser = null, string pViewName = "")
        {
            if (pViewName == "") pViewName = "uvw_DocumentItem_Details";
            this.Setup(pCurrentUser, "DocumentItem");
            this.Setup_AddTableDetail("DocumentItem_Details", pViewName, "IsNull(IsDeleted,0) = 0");
        }
        
        #endregion

        #region _Properties

        public DataTable pDt_Items
        {
            get { return this.pTableDetail_Get("DocumentItem_Details"); }
        }

        #endregion
    }
}
