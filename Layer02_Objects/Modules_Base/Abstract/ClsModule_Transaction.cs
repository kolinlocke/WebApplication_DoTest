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
    public abstract class ClsModule_Transaction: ClsModule
    {
        #region _Variables

        protected ClsDocument mObj_Document;

        #endregion

        #region _Constructor

        protected override void Setup(ClsSysCurrentUser CurrentUser, string TableName, string ViewName = "", string CacheTableName = "")
        {
            base.Setup(CurrentUser, TableName, ViewName, CacheTableName);
            this.mObj_Document = new ClsDocument(this.mCurrentUser);
        }

        #endregion

        #region _Methods

        public override void Load(Keys Keys = null)
        {
            base.Load(Keys);

            List<string> KeyNames = new List<string>();
            KeyNames.Add("DocumentID");
            Keys = this.GetKeys(this.pDr, KeyNames);
            this.mObj_Document.Load(Keys);
        }

        public virtual bool Save(ClsDocument.eSaveAction SaveAction = ClsDocument.eSaveAction.Save)
        {
            this.mObj_Document.Save(SaveAction);
            this.pDr["DocumentID"] = this.mObj_Document.pID;
            return base.Save();
        }
        
        #endregion

        #region _Properties

        public DataRow pDr_Document
        {
            get { return this.mObj_Document.pDr; }
        }

        #endregion

    }
}
