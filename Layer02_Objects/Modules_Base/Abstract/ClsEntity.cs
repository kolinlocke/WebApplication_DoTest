using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using DataObjects_Framework;
using DataObjects_Framework.BaseObjects;
using DataObjects_Framework.Common;
using DataObjects_Framework.Objects;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.Objects;
using Layer02_Objects;
using Layer02_Objects._System;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Microsoft.VisualBasic;

namespace Layer02_Objects.Modules_Base.Abstract
{
    public abstract class ClsEntity: ClsBase
    {
        #region _Variables

        protected ClsParty mObj_Party;

        #endregion

        #region _Constructor

        protected virtual void Setup(Layer01_Common.Common.Layer01_Constants.eSystem_LookupPartyType pPartyType, ClsSysCurrentUser CurrentUser, String TableName, String ViewName = "", String CacheTableName = "")
        {
            base.Setup(CurrentUser, TableName, ViewName, CacheTableName);
            this.mObj_Party = new ClsParty(pPartyType, this.mCurrentUser);
        }

        protected override void Setup(ClsSysCurrentUser CurrentUser, string TableName, string ViewName = "", string CacheTableName = "")
        { throw new NotImplementedException(); }

        protected override void Setup(string TableName, string ViewName = "", List<string> CustomKeys = null)
        { throw new NotImplementedException(); }

        #endregion

        #region _Methods

        public override void Load(Keys Keys = null)
        {
            base.Load(Keys);

            List<string> KeyNames = new List<string>();
            KeyNames.Add("PartyID");
            Keys = this.GetKeys(this.pDr, KeyNames);
            this.mObj_Party.Load(Keys);
        }

        public override bool Save(DataObjects_Framework.DataAccess.Interface_DataAccess Da = null)
        {
            this.mObj_Party.Save();
            this.pDr["PartyID"] = this.mObj_Party.pID;
            return base.Save(Da);
        }

        #endregion

        #region _Properties

        public DataRow pDr_RowProperty
        {
            get { return this.mObj_Party.pDr_RowProperty; }
        }

        public DataRow pDr_Party
        {
            get { return this.mObj_Party.pDr; }
        }

        public ClsParty pObj_Party
        {
            get { return this.mObj_Party; }
        }

        public DataRow pDr_Address
        {
            get { return this.mObj_Party.pDr_Address; }
        }

        public ClsAddress pObj_Address
        {
            get { return this.mObj_Party.pObj_Address; }
        }

        #endregion
    }
}
