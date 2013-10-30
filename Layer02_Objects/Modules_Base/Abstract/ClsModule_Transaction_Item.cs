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

namespace Layer02_Objects.Modules_Base.Abstract
{
    public abstract class ClsModule_Transaction_Item : ClsModule_Transaction
    {
        #region _Variables

        protected ClsDocumentItem mObj_DocumentItem;

        #endregion

        #region _Constructor

        protected virtual new void Setup(ClsSysCurrentUser CurrentUser, string TableName, string ViewName = "", string ViewName_Item = "")
        {
            base.Setup(CurrentUser, TableName, ViewName);
            this.mObj_DocumentItem = new ClsDocumentItem(this.mCurrentUser, ViewName_Item);
        }

        #endregion

        #region _Methods

        public override void Load(Keys Keys = null)
        {
            base.Load(Keys);

            List<string> KeyNames = new List<string>();
            KeyNames.Add("DocumentItemID");
            Keys = this.GetKeys(this.pDr, KeyNames);
            this.mObj_DocumentItem.Load(Keys);
        }

        public override bool Save(ClsDocument.eSaveAction SaveAction = ClsDocument.eSaveAction.Save)
        {
            this.mObj_DocumentItem.Save();
            this.pDr["DocumentItemID"] = this.mObj_DocumentItem.pID;
            return base.Save(SaveAction);
        }

        #endregion

        #region _Properties

        public DataTable pDt_DocumentItem
        {
            get { return this.mObj_DocumentItem.pDt_Items; }
        }

        #endregion
    }
}
