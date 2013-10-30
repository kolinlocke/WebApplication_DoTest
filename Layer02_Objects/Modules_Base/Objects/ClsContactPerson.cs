using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Layer01_Common;
using Layer01_Common.Common;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects._System;
using DataObjects_Framework;
using DataObjects_Framework.Common;
using DataObjects_Framework.DataAccess;
using DataObjects_Framework.Objects;

namespace Layer02_Objects.Modules_Base.Objects
{
    public class ClsContactPerson : ClsBase
    {
        #region _Variables

        //ClsBaseObjs mBO_Details_Person = new ClsBaseObjs();

        #endregion

        #region _Constructor

        public ClsContactPerson(ClsSysCurrentUser pCurrentUser = null)
        {
            this.Setup(pCurrentUser, "ContactPerson");
            //this.Setup_AddTableDetail("ContactPerson_Details", "uvw_ContactPerson_Details");
            this.Setup_AddListDetail("ContactPerson_Details", new ClsContactPerson_Details(pCurrentUser));
            this.Setup_EnableCache();
        }

        #endregion

        #region _Methods

        public override void Load(Keys Keys = null)
        {
            base.Load(Keys);

            //[-]

            //foreach (DataRow Dr in this.pDt_ContactPerson.Rows)
            //{
            //    ClsPerson Inner_Obj = new ClsPerson(this.mCurrentUser);
            //    Keys Inner_Keys = null;
            //    Int64 Inner_PersonID = Convert.ToInt64(Do_Methods.IsNull(Dr["PersonID"], 0));

            //    if (Inner_PersonID != 0)
            //    {
            //        Inner_Keys = new Keys();
            //        Inner_Keys.Add("PersonID", Inner_PersonID);
            //    }

            //    Inner_Obj.Load(Inner_Keys);
            //    this.mBO_Details_Person.Add(Convert.ToInt64(Do_Methods.IsNull(Dr["TmpKey"], 0)).ToString(), Inner_Obj);
            //}
        }

        public override bool Save(Interface_DataAccess Da = null)
        {
            //foreach (ClsBaseObjs.Str_Obj Obj in this.mBO_Details_Person.pList_Obj)
            //{
            //    Obj.Obj.Save();
            //    DataRow[] Inner_ArrDr = this.pDt_ContactPerson.Select("TmpKey = " + Obj.Name);
            //    if (Inner_ArrDr.Length > 0)
            //    { Inner_ArrDr[0]["PersonID"] = Obj.Obj.pDr["PersonID"]; }
            //}

            return base.Save(Da);
        }

        #endregion

        #region _Properties

        public DataTable pDt_ContactPerson
        {
            get 
            { 
                //return this.pTableDetail_Get("ContactPerson_Details");
                return this.pObj_ContactPerson_Details.pDt_List;
            }
        }

        public ClsContactPerson_Details pObj_ContactPerson_Details
        {
            get { return (ClsContactPerson_Details)this.pListDetail_Get("ContactPerson_Details"); }
        }

        //public ClsBaseObjs pBO_ContactPerson_Persons
        //{
        //    get { return this.mBO_Details_Person; }
        //}

        #endregion
    }

    public class ClsContactPerson_Details : ClsBase_List
    {
        public ClsContactPerson_Details(ClsSysCurrentUser CurrentUser)
        {
            base.Setup("ContactPerson_Details", "uvw_ContactPerson_Details");

            //[-]

            List<Do_Constants.Str_ForeignKeyRelation> FetchKeys = new List<Do_Constants.Str_ForeignKeyRelation>();
            FetchKeys.Add(new Do_Constants.Str_ForeignKeyRelation("ContactPersonID", "ContactPersonID"));

            List<Do_Constants.Str_ForeignKeyRelation> ForeignKeys = new List<Do_Constants.Str_ForeignKeyRelation>();
            ForeignKeys.Add(new Do_Constants.Str_ForeignKeyRelation("PersonID", "PersonID"));

            base.Setup_AddListObject(
                "Person"
                , new ClsPerson(null)
                , new List<object>() { CurrentUser }
                , "uvw_Person_ContactPerson_Details"
                , FetchKeys
                , ForeignKeys);
        }

        public ClsPerson pObj_Person_Get(Int64 TmpKey)
        { return (ClsPerson)this.pObj_ListObject_Get("Person", TmpKey); }
    }

}
