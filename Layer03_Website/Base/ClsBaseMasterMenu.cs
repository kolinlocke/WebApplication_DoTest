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
    public abstract class ClsBaseMasterMenu: System.Web.UI.MasterPage
    {
        #region _Variables

        protected ClsBaseMain mMaster;
        
        #endregion

        #region _Constructor

        public ClsBaseMasterMenu()
        {
            this.Init += Page_Init;
        }
        
        #endregion

        #region _EventHandlers

        private void Page_Init(object sender, EventArgs e)
        {
            this.mMaster = (ClsBaseMain)this.Master;
        }

        #endregion

        #region _Properties_MasterPage

        public void pCurrentUser_New()
        { this.mMaster.pCurrentUser_New(); }

        public string pServerRoot
        {
            get { return this.mMaster.pServerRoot; }
        }

        public ClsSysCurrentUser pCurrentUser
        {
            get { return this.mMaster.pCurrentUser; }
            set { this.mMaster.pCurrentUser = value; }
        }

        #endregion

        #region _Properties

        public ClsBaseMain pMaster
        {
            get { return this.mMaster; }
        }

        #endregion

    }
}