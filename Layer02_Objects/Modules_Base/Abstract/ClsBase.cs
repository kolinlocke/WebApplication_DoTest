using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using DataObjects_Framework;
using DataObjects_Framework.BaseObjects;
using DataObjects_Framework.Common;
using DataObjects_Framework.DataAccess;
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
    public class ClsBase : DataObjects_Framework.BaseObjects.Base
    {
        #region _Variables

        protected ClsSysCurrentUser mCurrentUser;
        protected bool mIsCache = false;
        protected String mCacheTableName;
        
        #endregion

        #region _Methods

        protected virtual void Setup(ClsSysCurrentUser CurrentUser, String TableName, String ViewName = "", String CacheTableName = "")
        {
            base.Setup(TableName, ViewName);
            this.mCacheTableName = CacheTableName;
            this.mCurrentUser = CurrentUser;
        }

        protected void Setup_EnableCache()
        { this.mIsCache = true; }

        public override DataTable List(DataObjects_Framework.Objects.QueryCondition Condition, string Sort = "", int Top = 0, int Page = 0)
        {
            Interface_DataAccess Da = this.CreateDataAccess();
            try
            { return base.List(Da, Condition, Sort, Top, Page); }
            catch (Exception Ex) { throw Ex; }
            finally { Da.Close(); }
        }

        public override DataTable List(string Condition = "", string Sort = "")
        {
            Interface_DataAccess Da = this.CreateDataAccess();
            try
            { return base.List(Da, Condition, Sort); }
            catch (Exception Ex) { throw Ex; }
            finally { Da.Close(); }
        }

        public override void Load(Keys Keys = null)
        {
            //Interface_DataAccess Da = this.CreateDataAccess();
            //try { base.Load(Da, Keys); }
            //catch (Exception Ex) { throw Ex; }
            //finally { Da.Close(); }

            base.Load(Keys);
        }

        public override bool Save(Interface_DataAccess Da = null)
        {
            if (this.mIsCache)
            {
                DataTable Dt_Tub = Do_Methods_Query.GetQuery(@"System_TableUpdateBatch", "", @"TableName = '" + this.mHeader_TableName + @"'");
                DataRow Dr_Tub = null;
                if (Dt_Tub.Rows.Count > 0)
                { Dr_Tub = Dt_Tub.Rows[0]; }
                else
                { throw new Exception("Table Cache info not found."); }

                List<QueryParameter> List_Qp = new List<QueryParameter>();
                List_Qp.Add(new QueryParameter("TableUpdateBatchID", Do_Methods.Convert_Int64(Dr_Tub["System_TableUpdateBatchID"])));
                List_Qp.Add(new QueryParameter("ID", this.pID));

                Do_Methods_Query.ExecuteNonQuery("usp_InsertToTableUpdateBatch", List_Qp);
            }
            
            return base.Save(Da);
        }

        public Interface_DataAccess CreateDataAccess()
        {
            Interface_DataAccess Da = Do_Methods.CreateDataAccess();
            try
            {
                if (this.mIsCache)
                { Da.Connect(Do_Methods.Convert_String(Do_Globals.gSettings.pCollection[Layer01_Constants.CnsConnectionString_Cache])); }
                else
                { Da.Connect(); }
            }
            catch (Exception Ex) { throw Ex; }
            return Da;
        }

        #endregion

        #region _Properties

        public ClsSysCurrentUser pCurrentUser
        {
            get { return this.mCurrentUser; }
        }

        #endregion
    }
}
