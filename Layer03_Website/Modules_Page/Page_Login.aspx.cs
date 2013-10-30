using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Layer02_Objects;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects.Modules_Masterfiles;
using Layer02_Objects.Modules_Transaction;
using Layer02_Objects._System;
using Layer03_Website;
using Layer03_Website.Base;
using Layer03_Website.Modules_Master;

namespace Layer03_Website.Modules_Page
{
    public partial class Page_Login : System.Web.UI.Page
    {
        #region _EventHandlers

        protected void Page_Load(object sender, EventArgs e)
        {
            this.Btn_Login.Click += this.Btn_Login_Click;
            this.Master.Setup(true); 
        }

        protected void Btn_Login_Click(object sender, EventArgs e)
        { this.Login(); }

        #endregion

        #region _Methods

        void Login()
        {
            this.Master.pCurrentUser_New();
            ClsSysCurrentUser CurrentUser = this.Master.pCurrentUser;

            switch (CurrentUser.Login(this.Txt_Username.Text, this.Txt_Password.Text))
            { 
                case ClsSysCurrentUser.eLoginResult.LoggedIn:
                case ClsSysCurrentUser.eLoginResult.Administrator:
                    CurrentUser.pIsLoggedIn = true;
                    this.Response.Redirect(@"~/Modules_Page/Default.aspx");
                    break;
                default:
                    this.Panel_Msg.Visible = true;
                    this.Lbl_Msg.Text = "User Name or Password is incorrect. Please try again.";
                    this.Lbl_Msg.Visible = true;
                    break;
            }
        }

        #endregion

    }
}