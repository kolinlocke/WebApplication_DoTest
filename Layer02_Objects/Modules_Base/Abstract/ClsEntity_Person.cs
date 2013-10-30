using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using DataObjects_Framework;
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
    public abstract class ClsEntity_Person : ClsEntity
    {
        #region _Variables

        protected ClsPerson mObj_Person;

        #endregion

        #region _Constructor

        protected override void Setup(Layer01_Common.Common.Layer01_Constants.eSystem_LookupPartyType PartyType, ClsSysCurrentUser CurrentUser, String TableName, String ViewName = "", String CacheTableName = "")
        {
            base.Setup(PartyType, CurrentUser, TableName, ViewName);
            this.mObj_Person = new ClsPerson(this.mCurrentUser);
        }

        protected override void Setup(ClsSysCurrentUser CurrentUser, string TableName, string ViewName = "", string CacheTableName = "")
        { throw new NotImplementedException(); }

        #endregion

        #region _Methods

        public override void Load(Keys Keys = null)
        {
            base.Load(Keys);

            List<string> KeyNames = new List<string>();
            KeyNames.Add("PersonID");
            Keys = this.GetKeys(this.pDr, KeyNames);
            this.mObj_Person.Load(Keys);
        }

        public override bool Save(DataObjects_Framework.DataAccess.Interface_DataAccess Da = null)
        {
            this.mObj_Person.Save();
            this.pDr["PersonID"] = this.mObj_Person.pID;
            return base.Save(Da);
        }

        #endregion

        #region _Properties

        public DataRow pDr_Person
        {
            get { return this.mObj_Person.pDr; }
        }

        public ClsPerson pObj_Person
        {
            get { return this.mObj_Person; }
        }

        #endregion
    }
}
