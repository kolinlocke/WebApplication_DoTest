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

namespace Layer02_Objects.Modules_Base.Abstract
{
    public abstract class ClsModule_Address: ClsModule
    {
        #region _Variables

        protected ClsAddress mObj_Address;

        #endregion

        #region _Constructor

        protected override void Setup(ClsSysCurrentUser CurrentUser, string TableName, string ViewName = "", string CacheTableName = "")
        {
            base.Setup(CurrentUser, TableName, ViewName, CacheTableName);
            this.mObj_Address = new ClsAddress(this.mCurrentUser);
        }

        #endregion

        #region _Methods

        public override void Load(Keys Keys = null)
        {
            base.Load(Keys);

            List<string> KeyNames = new List<string>();
            KeyNames.Add("AddressID");
            Keys = this.GetKeys(this.pDr, KeyNames);
            this.mObj_Address.Load(Keys);
        }

        public override bool Save(DataObjects_Framework.DataAccess.Interface_DataAccess Da = null)
        {
            this.mObj_Address.Save();
            this.pDr["AddressID"] = this.mObj_Address.pID;
            return base.Save(Da);
        }
        
        #endregion

        #region _Properties

        public DataRow pDr_Address
        {
            get { return this.mObj_Address.pDr; }
        }

        public ClsAddress pObj_Address
        {
            get { return this.mObj_Address; }
        }

        #endregion
    }
}
