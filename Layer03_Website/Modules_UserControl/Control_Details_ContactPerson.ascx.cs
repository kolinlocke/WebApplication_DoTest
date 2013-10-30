using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft;
using Microsoft.VisualBasic;
using Microsoft.JScript;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.Objects;
using Layer01_Common_Web;
using Layer01_Common_Web.Common;
using Layer01_Common_Web_EO;
using Layer01_Common_Web_EO.Common;
using Layer01_Common_Web_EO.Objects;
using Layer02_Objects;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects.Modules_Masterfiles;
using Layer02_Objects.Modules_Transaction;
using Layer02_Objects._System;
using Layer03_Website;
using Layer03_Website.Base;
using DataObjects_Framework;
using DataObjects_Framework.Common;

namespace Layer03_Website.Modules_UserControl
{
    public partial class Control_Details_ContactPerson : System.Web.UI.UserControl
    {

        #region _Events

        public delegate void DsAccept();
        public event DsAccept EvAccept;

        #endregion

        #region _Variables

        const string CnsObjID = "CnsObjID";
        const string CnsObj_ContactPerson = "CnsObj_ContactPerson";
        const string CnsObj_Person = "CnsObj_Person";
        const string CnsTmpKey = "CnsTmpKey";

        string mObjID = "";
        ClsContactPerson mObj_ContactPerson;
        ClsPerson mObj_Person;
        Int64 mTmpKey;

        #endregion

        #region _Constructor

        public string Show(ref ClsContactPerson pObj_ContactPerson, Int64 pTmpKey = 0)
        {
            ClsSysCurrentUser CurrentUser = (ClsSysCurrentUser)this.Session[Layer01_Constants_Web.CnsSession_CurrentUser];
            this.mObjID = CurrentUser.GetNewPageObjectID();
            this.mObj_ContactPerson = pObj_ContactPerson;
            this.mTmpKey = pTmpKey;

            this.ViewState[CnsObjID] = this.mObjID;
            this.Session[this.mObjID + CnsObj_ContactPerson] = this.mObj_ContactPerson;
            this.ViewState[CnsTmpKey] = this.mTmpKey;
            this.Page_Load(null, null);

            //[-]

            //[-]

            System.Text.StringBuilder Sb_Js = new System.Text.StringBuilder();
            Sb_Js.Append("var EODialog = eo_GetObject('" + this.EODialog_ContactPerson.ClientID + "');");
            Sb_Js.Append("EODialog.show(true); ");
            
            return Sb_Js.ToString();
        }

        public void AddNew(ref ClsContactPerson pObj_ContactPerson)
        {
            this.mObj_ContactPerson = pObj_ContactPerson;
            this.mTmpKey = 0;
            this.SetupPage();
            this.Update();
        }

        #endregion

        #region _EventHandlers

        protected void Page_Load(object sender, EventArgs e)
        {
            this.EOCb_Accept.Execute += new EO.Web.CallbackEventHandler(EOCb_Accept_Execute);

            //[-]

            this.mObjID = (string)this.ViewState[CnsObjID];
            this.mObj_ContactPerson = (ClsContactPerson)this.Session[this.mObjID + CnsObj_ContactPerson];
            this.mObj_Person = (ClsPerson)this.Session[this.mObjID + CnsObj_Person];
            this.mTmpKey = System.Convert.ToInt64(this.ViewState[CnsTmpKey]);
        }

        void EOCb_Accept_Execute(object sender, EO.Web.CallbackEventArgs e)
        {
            try
            { this.Update(); }
            catch (Exception Ex)
            {
                Layer01_Methods_Web.ErrorHandler(Ex, this.Server);
                throw Ex;
            }
        }

        #endregion

        #region _Methods

        void SetupPage()
        {
            DataRow[] ArrDr = this.mObj_ContactPerson.pDt_ContactPerson.Select("TmpKey = " + this.mTmpKey);
            DataRow Dr_ContactPerson = null;
            if (ArrDr.Length > 0)
            { Dr_ContactPerson = ArrDr[0]; }
            else
            { this.mTmpKey = 0; }

            //string Title = "";
            if (this.mTmpKey == 0)
            {
                //Title = "Add Contact Person";
                this.Txt_Position.Text = "";
                this.mObj_Person = new ClsPerson(this.mObj_ContactPerson.pCurrentUser);
                this.mObj_Person.Load();
            }
            else
            {
                //Title = "Update Contact Person";
                this.Txt_Position.Text = (string)Do_Methods.IsNull(Dr_ContactPerson["Position"], "");
                //this.mObj_Person = (ClsPerson)this.mObj_ContactPerson.pBO_ContactPerson_Persons[this.mTmpKey.ToString()];
                this.mObj_Person = this.mObj_ContactPerson.pObj_ContactPerson_Details.pObj_Person_Get(this.mTmpKey);
            }

            this.UcPerson.Setup(this.mObj_Person);
            this.Session[this.mObjID + CnsObj_Person] = this.mObj_Person;

            try
            { this.EOCbp_Dialog_ContactPerson.Update(); }
            catch { }
        }

        void Update()
        {
            DataRow[] ArrDr = this.mObj_ContactPerson.pDt_ContactPerson.Select("TmpKey = " + this.mTmpKey, "", DataViewRowState.CurrentRows);
            DataRow Dr_ContactPerson = null;
            if (ArrDr.Length > 0)
            { Dr_ContactPerson = ArrDr[0]; }
            else
            {
                //Int64 TmpKey = 0;
                //ArrDr = this.mObj_ContactPerson.pDt_ContactPerson.Select("", "TmpKey Desc", DataViewRowState.CurrentRows);
                //if (ArrDr.Length > 0)
                //{ TmpKey = System.Convert.ToInt64(ArrDr[0]["TmpKey"]); }
                //TmpKey++;

                //Dr_ContactPerson = this.mObj_ContactPerson.pDt_ContactPerson.NewRow();
                //Dr_ContactPerson["TmpKey"] = TmpKey;
                //this.mObj_ContactPerson.pDt_ContactPerson.Rows.Add(Dr_ContactPerson);
                //this.mObj_ContactPerson.pBO_ContactPerson_Persons.Add(TmpKey.ToString(), this.mObj_Person);

                Dr_ContactPerson = this.mObj_ContactPerson.pObj_ContactPerson_Details.Add_Item();
            }

            this.UcPerson.Update();

            Dr_ContactPerson["Position"] = this.Txt_Position.Text;
            Dr_ContactPerson["FullName"] = Do_Methods.IsNull(this.mObj_Person.pDr["FullName"], "");
            Dr_ContactPerson["Phone"] = Do_Methods.IsNull(this.mObj_Person.pDr["Phone"], "");
            Dr_ContactPerson["Mobile"] = Do_Methods.IsNull(this.mObj_Person.pDr["Mobile"], "");
            Dr_ContactPerson["Fax"] = Do_Methods.IsNull(this.mObj_Person.pDr["Fax"], "");
            Dr_ContactPerson["Email"] = Do_Methods.IsNull(this.mObj_Person.pDr["Email"], "");
            Dr_ContactPerson["WorkEmail"] = Do_Methods.IsNull(this.mObj_Person.pDr["WorkEmail"], "");

            Do_Methods.ConvertCaps(Dr_ContactPerson);
            this.mTmpKey = System.Convert.ToInt64(Do_Methods.IsNull(Dr_ContactPerson["TmpKey"], 0));

            if (EvAccept != null)
            { EvAccept(); }
        }

        #endregion
        
    }
}
