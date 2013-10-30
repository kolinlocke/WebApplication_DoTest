using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using Microsoft.VisualBasic;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.Objects;
using Layer01_Common_Web;
using Layer01_Common_Web.Common;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects.Modules_Masterfiles;
using Layer02_Objects.Modules_Transaction;
using Layer02_Objects._System;
using Layer03_Website;
using Layer03_Website.Base;
using Layer03_Website.Modules_Master;
using DataObjects_Framework;
using DataObjects_Framework.BaseObjects;
using DataObjects_Framework.Common;
using DataObjects_Framework.Objects;

namespace Layer03_Website.Modules_Master
{
    public partial class Master_Menu : ClsBaseMasterMenu
    {
        #region _Constructor

        public Master_Menu()
        { this.Load += new EventHandler(Page_Load); }

        #endregion

        #region _EventHandlers

        protected void Page_Load(object sender, EventArgs e)
        {
            this.Btn_Logout.Click += Btn_Logout_Click;

            try
            {
                if (this.pMaster.pCurrentUser == null) return;
                if (!this.pMaster.pCurrentUser.pIsLoggedIn) return;
                if (!this.IsPostBack)
                {
                    this.LoadMenu();
                    this.Lbl_Name.Text = (string)Do_Methods.IsNull(this.pMaster.pCurrentUser.pDrUser["EmployeeName"], "");
                }
            }
            catch { }
        }

        protected void Btn_Logout_Click(object sender, EventArgs e)
        {
            this.pMaster.pCurrentUser_New();
            this.Response.Redirect("~/Default.aspx");
        }

        #endregion

        #region _Methods

        private void LoadMenu()
        {
            ClsSysCurrentUser CurrentUser = this.mMaster.pCurrentUser;
            DataTable Dt_Menu;
            if (CurrentUser.pIsAdmin)
            { Dt_Menu = Do_Methods_Query.GetQuery("uvw_System_Modules", "", "IsNull(IsHidden,0) = 0", "Parent_OrderIndex, OrderIndex"); }
            else
            {
                List<QueryParameter> Sp = new List<QueryParameter>();
                Sp.Add(new QueryParameter(@"@UserID", CurrentUser.pDrUser["UserID"]));
                Dt_Menu = Do_Methods_Query.ExecuteQuery("usp_System_Modules_Load", Sp).Tables[0];
            }

            this.trvMenus.Nodes.Clear();

            foreach (DataRow Dr in Dt_Menu.Rows)
            {
                if ((Int64)Do_Methods.IsNull(Dr["Parent_System_ModulesID"], 0) == 0)
                {
                    TreeNode Node = new TreeNode();
                    Node.Text = @"&nbsp" + Dr["Name"];
                    //Node.ImageUrl = "";
                    if ((string)Do_Methods.IsNull(Dr["PageUrl_List"], "") != "")
                    {
                        string Arguments = (string)Do_Methods.IsNull(Dr["Arguments"], "");
                        if (Arguments != "") Arguments = @"?" + Arguments;
                        Node.NavigateUrl = @"~/" + Dr["PageUrl_List"] + Arguments;
                    }
                    else Node.SelectAction = TreeNodeSelectAction.None;

                    this.trvMenus.Nodes.Add(Node);

                    DataRow[] ArrDr = Dt_Menu.Select("Parent_System_ModulesID = " + ((Int64)Do_Methods.IsNull(Dr["System_ModulesID"], 0)).ToString());
                    if (ArrDr.Length > 0) this.AddNode(ref Dt_Menu, Node, (Int64)Do_Methods.IsNull(Dr["System_ModulesID"], 0));
                }
            }
        }

        void AddNode(ref DataTable Dt_Menu, TreeNode TvNode, Int64 System_ModulesID)
        {
            DataRow[] ArrDr = Dt_Menu.Select("Parent_System_ModulesID = " + System_ModulesID.ToString());
            foreach (DataRow Dr in ArrDr)
            {
                TreeNode Node = new TreeNode();
                Node.Text = @"&nbsp;" + Dr["Name"];

                if ((string)Do_Methods.IsNull(Dr["PageUrl_List"], "") != "")
                {
                    string Arguments = (string)Do_Methods.IsNull(Dr["Arguments"], "");
                    if (Arguments != "") Arguments = @"?" + Arguments;
                    Node.NavigateUrl = @"~/" + (string)Dr["PageUrl_List"] + Arguments;
                }
                else Node.SelectAction = TreeNodeSelectAction.None;

                TvNode.ChildNodes.Add(Node);

                DataRow[] Inner_ArrDr = Dt_Menu.Select("Parent_System_ModulesID = " + ((Int64)Do_Methods.IsNull(Dr["System_ModulesID"], 0)).ToString());
                if (Inner_ArrDr.Length > 0) this.AddNode(ref Dt_Menu, Node, (Int64)Do_Methods.IsNull(Dr["System_ModulesID"], 0));
            }
        }

        #endregion
    }
}