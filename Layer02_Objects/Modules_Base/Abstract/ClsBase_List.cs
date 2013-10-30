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
using DataObjects_Framework.BaseObjects;
using DataObjects_Framework.DataAccess;
using DataObjects_Framework.Objects;

namespace Layer02_Objects.Modules_Base.Abstract
{
    public class ClsBase_List : DataObjects_Framework.BaseObjects.Base_List
    {
        #region _Variables

        protected ClsSysCurrentUser mCurrentUser;
        protected bool mIsCache = false;

        #endregion

        #region _Methods

        protected virtual void Setup(ClsSysCurrentUser CurrentUser, string TableName, string ViewName = "", QueryCondition Qc_LoadCondition = null, List<string> CustomKeys = null)
        {
            base.Setup(TableName, ViewName, Qc_LoadCondition, CustomKeys);
            this.mCurrentUser = CurrentUser;
        }

        protected void Setup_EnableCache()
        { this.mIsCache = true; }

        public override void Load(Keys Keys, DataObjects_Framework.BaseObjects.Base Obj_Parent = null)
        {
            Interface_DataAccess Da = Do_Methods.CreateDataAccess();

            try
            {
                if (this.mIsCache)
                { Da.Connect(Do_Methods.Convert_String(Do_Globals.gSettings.pCollection[Layer01_Constants.CnsConnectionString_Cache])); }
                else
                { Da.Connect(); }

                base.Load(Da, Keys, Obj_Parent);
            }
            catch (Exception Ex) { throw Ex; }
            finally { Da.Close(); }
        }

        #endregion
    }
}
