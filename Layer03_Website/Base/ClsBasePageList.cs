using System;
using System.Web.UI;

namespace Layer03_Website.Base
{
    public class ClsBasePageList: Page
    {
        #region _Variables

        protected ClsBaseMasterList mMaster;

        #endregion

        #region _Constructor

        public ClsBasePageList()
        { this.Page.PreInit += this.Page_PreInit; }

        #endregion

        #region _EventHandlers

        protected virtual void Page_PreInit(object sender, EventArgs e)
        {
            //this.MasterPageFile = "~/Modules_Master/Master_List.master";
            //this.Master.MasterPageFile = "~/Modules_Master/Master_Menu.master";
            this.mMaster = (ClsBaseMasterList)this.Master;

            this.mMaster.EvNew += this.Details_New;
            this.mMaster.EvPrint += this.Details_Print;
            this.mMaster.EvOpen += this.Details_Open;
            this.mMaster.EvSetupPage_Done += this.SetupPage_Done;
        }

        #endregion

        #region _Methods

        protected virtual void Details_New()
        { this.mMaster.Details_New(); }

        protected virtual void Details_Print(ref string Data)
        { this.mMaster.Details_Print(ref Data); }

        protected virtual void Details_Open(Int64 ID)
        { this.mMaster.Details_Open(ID); }

        protected virtual void SetupPage_Done()
        { this.mMaster.SetupPage_Done(); }

        #endregion

        #region _Properties

        public new ClsBaseMasterList Master
        {
            get { return (ClsBaseMasterList)base.Master; }
        }

        public ClsBaseMasterList pMaster
        {
            get { return this.mMaster; }
        }

        #endregion
    }
}