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

namespace Layer02_Objects.Modules_Base.Objects
{
    public class ClsDocument: ClsBase
    {
        #region _Constructor

        public ClsDocument(ClsSysCurrentUser pCurrentUser = null)
        { this.Setup(pCurrentUser, "Document","uvw_Document"); }
        
        #endregion

        #region _Methods

        public enum eSaveAction
        { 
            Save,
            Post,
            Cancel
        }

        public bool Save(eSaveAction SaveAction = eSaveAction.Save)
        {
            bool IsSave = false;

            if (this.mCurrentUser == null) throw new Exception("User is not initialized");

            Interface_DataAccess Da = this.mDa;
            try
            {
                Da.Connect();
                Da.BeginTransaction();

                DateTime ServerDate = Layer02_Common.GetServerDate(Da);

                switch (SaveAction)
                {
                    case eSaveAction.Save:
                        if ((bool)Do_Methods.IsNull(this.mHeader_Dr["IsCancelled"], false)) throw new Exception("Document is already cancelled.");
                        if ((bool)Do_Methods.IsNull(this.mHeader_Dr["IsPosted"], false)) throw new Exception("Document is already posted.");
                        break;

                    case eSaveAction.Post:
                        if ((bool)Do_Methods.IsNull(this.mHeader_Dr["IsPosted"], false)) throw new Exception("Document is already posted.");
                        this.mHeader_Dr["IsPosted"] = true;
                        this.mHeader_Dr["DatePosted"] = ServerDate;
                        this.mHeader_Dr["EmployeeID_PostedBy"] = this.mCurrentUser.pDrUser["EmployeeID"];
                        break;

                    case eSaveAction.Cancel:
                        if ((bool)Do_Methods.IsNull(this.mHeader_Dr["IsCancelled"], false)) throw new Exception("Document is already cancelled.");
                        this.mHeader_Dr["IsCancelled"] = true;
                        this.mHeader_Dr["DateCancelled"] = ServerDate;
                        this.mHeader_Dr["EmployeeID_CancelledBy"] = this.mCurrentUser.pDrUser["EmployeeID"];
                        break;
                }

                Da.SaveDataRow(this.mHeader_Dr, this.mHeader_TableName);
                Da.CommitTransaction();
                IsSave = true;
            }
            catch (Exception ex)
            {
                Da.RollbackTransaction();
                throw ex;
            }
            finally
            { Da.Close(); }

            return IsSave;
        }

        #endregion
    }
}
