using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.VisualBasic;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.Objects;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects.Modules_Masterfiles;
using Layer02_Objects.Modules_Transaction;
using Layer02_Objects._System;
using Layer01_Common_Web;
using Layer01_Common_Web.Common;

namespace Layer03_Website.Base
{
    public abstract class ClsBaseMain: System.Web.UI.MasterPage
    {
        #region _Variables

        protected string mPageTitle = "";
        protected string mServerRoot = "";
        protected ClsSysCurrentUser mCurrentUser;
        protected bool mIsPageLogin = false;

        protected delegate void Delegate_Page_Init(object sender, System.EventArgs e);

        #endregion

        #region _Constructor

        public ClsBaseMain()
        {
            this.Init += Page_Init;
            this.Load += Page_Load;
        }
        
        public void Setup(bool pIsPageLogin = false)
        {
            this.mIsPageLogin = pIsPageLogin;
        }

        #endregion

        #region _EventHandlers

        protected void Page_Init(object sender, System.EventArgs e)
        {
            this.mServerRoot = this.ResolveUrl(@"~/");
            ClsSysCurrentUser CurrentUser = this.pCurrentUser;
            bool IsLoggedIn = false;
            if (CurrentUser != null) IsLoggedIn = CurrentUser.pIsLoggedIn;
            else
            { this.pCurrentUser_New(); }
        }

        void Page_Load(object sender, EventArgs e)
        {
            ClsSysCurrentUser CurrentUser = this.pCurrentUser;
            if (!CurrentUser.pIsLoggedIn)
            {
                if (!this.mIsPageLogin)
                {
                    this.Session.Clear();
                    this.pCurrentUser_New();
                    this.Response.Redirect("~/Modules_Page/Page_Login.aspx");
                    return;
                }
            }
            else
            {
                if (this.mIsPageLogin) this.Response.Redirect("~/Modules_Page/Default.aspx");
            }
        }

        #endregion

        #region _Methods

        public void pCurrentUser_New()
        {
            this.mCurrentUser = new ClsSysCurrentUser();
            this.Session[Layer01_Constants_Web.CnsSession_CurrentUser] = this.mCurrentUser;
        }

        #endregion

        #region _Properties

        public ClsSysCurrentUser pCurrentUser
        {
            get 
            {
                this.mCurrentUser = (ClsSysCurrentUser)this.Session[Layer01_Constants_Web.CnsSession_CurrentUser];
                if (this.mCurrentUser == null) this.pCurrentUser_New();
                return this.mCurrentUser;
            }
            set
            { this.mCurrentUser = value; }
        }

        public string pServerRoot
        {
            get { return this.mServerRoot; }
        }

        #endregion

    }
}