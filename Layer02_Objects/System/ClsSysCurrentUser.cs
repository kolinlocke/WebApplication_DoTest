using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.Objects;
using Layer02_Objects;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using DataObjects_Framework;
using DataObjects_Framework.Connection;
using DataObjects_Framework.Common;
using DataObjects_Framework.DataAccess;
using DataObjects_Framework.Objects;

namespace Layer02_Objects._System
{
    public class ClsSysCurrentUser
    {
        #region _Variables

        bool mIsLoggedIn = false;
        bool mIsAdmin = false;
        DataRow mDrUser;

        public enum eLoginResult 
        {
            LoggedIn,
            WrongUser,
            WrongPassword,
            WrongBranch,
            WrongLoggedUser,
            Administrator
        }

        //Session Variables
        Int64 mPageObjectIDs = 0;

        #endregion

        #region _Methods

        public eLoginResult Login(string UserName, string Password)
        {
            Interface_DataAccess Da = new ClsBase().pDa;
            try
            {
                Da.Connect();

                //Administrator Login
                if (UserName.ToUpper() == "Administrator".ToUpper())
                {
                    string System_Password = Da.GetSystemParameter("Administrator_Password", "Administrator");
                    if (System_Password != "")
                    {
                        string Decrypted_Password = System_Password;
                        if (Decrypted_Password == Password)
                        {
                            this.AdministratorLogin();
                            return eLoginResult.Administrator;
                        }
                        else { return eLoginResult.WrongPassword; }
                    }
                    else
                    { throw new CustomException("Administrator Password is not set. Contact your System Administrator."); }
                }

                //User Login
                QueryCondition Qc = new QueryCondition();
                Qc.Add("UserName", UserName, typeof(string).ToString());
                DataTable Dt = Da.GetQuery("uvw_User", "", Qc, "UserID");
                if (Dt.Rows.Count > 0)
                {
                    string Decrypted_Password = (string)Do_Methods.IsNull(Dt.Rows[0]["Password"], "");

                    if (Decrypted_Password == Password)
                    {
                        this.mDrUser = Dt.Rows[0];
                        return eLoginResult.LoggedIn;
                    }
                    else return eLoginResult.WrongPassword;
                }

                return eLoginResult.WrongUser;
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { Da.Close(); }
        }

        public void AdministratorLogin()
        {
            Interface_DataAccess Da = new ClsBase().pDa;
            try
            {
                Da.Connect();
                DataTable Dt = Da.GetQuery("uvw_User", "*", "1 = 0");
                this.mDrUser = Dt.NewRow();
                this.mDrUser["UserID"] = 0;
                this.mDrUser["EmployeeID"] = 0;
                this.mDrUser["UserName"] = "Administrator";
                this.mDrUser["EmployeeName"] = "Administrator";
                this.mIsAdmin = true;                    
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { Da.Close(); }
        }

        public bool CheckAccess(Int64 System_ModulesID, Layer01_Constants.eAccessLib AccessLib)
        {
            if (!this.mIsLoggedIn) 
            { return false; }

            if (this.mIsAdmin)
            { return true; }

            Interface_DataAccess Da = Do_Methods.CreateDataAccess();            
            try
            {             
                Da.Connect();

                DataTable Dt =
                    Da.GetQuery(
                        @"uvw_User_Rights As Ur Left Join uvw_Rights_Details As Rd On Ur.RightsID = Rd.RightsID"
                        , @"Ur.UserID, Rd.*"
                        , @"Ur.UserID = " + ((Int64)this.mDrUser["UserID"]).ToString() + " And Rd.System_ModulesID = " + System_ModulesID.ToString() + " And Rd.System_Modules_AccessLibID = " + ((long)AccessLib).ToString() + " And Rd.IsAllowed = 1 And Ur.IsActive = 1"
                        , "UserID");
                if (Dt.Rows.Count > 0) 
                { return true; }

                return false;
            }
            catch (Exception ex) 
            { throw ex; }
            finally
            { Da.Close(); }
        }

        public string GetNewPageObjectID()
        {
            this.mPageObjectIDs++;
            return "PageObject_" + this.mPageObjectIDs.ToString();
        }

        #endregion

        #region _Properties

        public bool pIsLoggedIn
        {
            get { return this.mIsLoggedIn; }
            set { this.mIsLoggedIn = value; }
        }

        public DataRow pDrUser
        {
            get { return this.mDrUser; }
        }

        public bool pIsAdmin
        {
            get { return this.mIsAdmin; }
        }

        #endregion

    }
}
