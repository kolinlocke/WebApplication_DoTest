using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Microsoft.VisualBasic;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.DataAccess;
using Layer01_Common.Objects;
using Layer02_Objects;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects._System;

namespace Layer02_Objects.Modules_Base.Abstract
{
    public class ClsBase
    {
        #region _Variables

        protected ClsSysCurrentUser mCurrentUser;
        protected string mHeader_TableName;
        protected string mHeader_ViewName;
        protected DataRow mHeader_Dr;
        protected List<string> mHeader_Key = new List<string>();
        protected string mHeader_TableKey;

        protected List<ClsBaseTableDetail> mBase_TableDetail = new List<ClsBaseTableDetail>();
        protected List<ClsBaseRowDetail> mBase_RowDetail = new List<ClsBaseRowDetail>();

        #endregion

        #region _Methods

        protected virtual void Setup(ClsSysCurrentUser pCurrentUser, string pTableName = "", string pViewName = "")
        {
            this.mCurrentUser = pCurrentUser;
            this.mHeader_TableName = pTableName;
            this.mHeader_TableKey = this.mHeader_TableName + "ID";
            if (pViewName == "") pViewName = pTableName;
            this.mHeader_ViewName = pViewName;

            DataTable Dt_Def = Methods_Query.GetTableDef(this.mHeader_TableName);
            DataRow[] ArrDr = Dt_Def.Select("IsPk = 1");
            foreach (DataRow Dr in ArrDr)
            { this.mHeader_Key.Add((string)Dr["ColumnName"]); }
        }

        protected void Add_TableDetail(string TableName, string ViewName = "", string LoadCondition = "")
        { this.mBase_TableDetail.Add(new ClsBaseTableDetail(this, this.mHeader_TableName, TableName, ViewName, LoadCondition)); }

        protected void Add_RowDetails(string TableName, string ViewName = "", string LoadCondition = "")
        { this.mBase_RowDetail.Add(new ClsBaseRowDetail(this, this.mHeader_TableName, TableName, ViewName, LoadCondition)); }

        //[-]

        public virtual DataTable List(string Condition, string Sort = "")
        {
            DataTable Dt = Methods_Query.GetQuery(this.mHeader_ViewName, "*", Condition, Sort);
            return Dt;
        }

        public virtual DataTable List(ClsQueryCondition Condition = null, string Sort ="", Int32 Top = 0, Int32 Page = 0)
        {
            DataTable Dt = Methods_Query.GetQuery(this.mHeader_ViewName, "*", Condition, Sort, Top, Page);
            return Dt;
        }

        public Int64 List_Count(ClsQueryCondition Condition = null)
        {
            DataTable Dt = Methods_Query.GetQuery(this.mHeader_ViewName, "Count(1) As [Ct]", Condition);
            Int64 ReturnValue = 0;
            try
            { ReturnValue = (Int64)Methods.IsNull(Dt.Rows[0]["Ct"], 0); }
            catch { }
            return ReturnValue;
        }

        //[-]

        public virtual void Load(ClsKeys Keys = null)
        {
            ClsDataAccess Da = new ClsDataAccess();
            StringBuilder Sb_Condition = new StringBuilder();
            string Condition = "";

            try
            {
                if (Keys != null)
                {
                    if (Keys.Count() != this.mHeader_Key.Count)
                    { throw new Exception("Keys not equal to required keys."); }

                    string Inner_Condition_And = "";
                    bool IsStart = false;
                    foreach (string Inner_Key in this.mHeader_Key)
                    {
                        Sb_Condition.Append(Inner_Condition_And + " " + Inner_Key + " = " + Keys[Inner_Key]);
                        if (!IsStart) Inner_Condition_And = " And ";
                        IsStart = true;
                    }
                }

                Condition = Sb_Condition.ToString();

                Da.Connect();

                DataTable Dt;
                DataRow Dr;

                if (Keys == null)
                {
                    Dt = Methods_Query.GetQuery(Da, this.mHeader_ViewName, "*", "1 = 0");
                    Dr = Dt.NewRow();
                }
                else
                {
                    Dt = Methods_Query.GetQuery(Da, this.mHeader_ViewName, "*", Condition);
                    Dr = Dt.Rows[0];
                }

                this.mHeader_Dr = Dr;

                //[-]

                if (this.mBase_TableDetail != null)
                {
                    foreach (ClsBaseTableDetail Inner_Obj in this.mBase_TableDetail)
                    { Inner_Obj.Load(Da, Condition); }
                }

                //[-]

                if (this.mBase_RowDetail != null)
                {
                    foreach (ClsBaseRowDetail Inner_Obj in this.mBase_RowDetail)
                    { Inner_Obj.Load(Da, Condition); }
                }

                //[-]

                this.AddRequired();
            }
            catch { }
        }

        public virtual bool Save()
        {
            bool IsSave = false;
            ClsDataAccess Da = new ClsDataAccess();

            try
            {
                Da.Connect();
                Da.BeginTransaction();
                Da.SaveDataRow(this.mHeader_Dr, this.mHeader_TableName);

                //[-]

                if (this.mBase_TableDetail != null)
                {
                    foreach (ClsBaseTableDetail Inner_Obj in this.mBase_TableDetail)
                    { Inner_Obj.Save(Da); }
                }

                //[-]

                if (this.mBase_RowDetail != null)
                {
                    foreach (ClsBaseRowDetail Inner_Obj in this.mBase_RowDetail)
                    { Inner_Obj.Save(Da); }
                }

                //[-]

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

        //[-]

        public ClsKeys GetKeys()
        { 
            ClsKeys Obj = new ClsKeys();
            foreach (string Key in this.mHeader_Key)
            {
                Int64 ID = Convert.ToInt64(Methods.IsNull(this.mHeader_Dr[Key], 0));
                Obj.Add(Key, ID);
            }
            return Obj;
        }

        public ClsKeys GetKeys(DataRow Dr)
        {
            ClsKeys Obj = new ClsKeys();
            foreach (string Key in this.mHeader_Key)
            {
                Int64 ID = (Int64)Methods.IsNull(Dr[Key], 0);
                Obj.Add(Key, ID);
            }
            return Obj;
        }

        public ClsKeys GetKeys(DataRow Dr, List<string> KeyNames)
        {
            bool IsFound = false;
            ClsKeys Key = new ClsKeys();

            foreach (string Inner_Key in KeyNames)
            {
                if (!Information.IsDBNull(Dr[Inner_Key]))
                {
                    Key.Add(Inner_Key, (Int64)Methods.IsNull(Dr[Inner_Key], 0));
                }
                else
                {
                    IsFound = true;
                    break;
                }
            }

            if (IsFound)
            {
                Key = null;
            }

            return Key;
        }

        public virtual void AddRequired(DataTable Dt)
        {
            Int64 Ct = 0;
            try
            {
                Dt.Columns.Add("TmpKey", typeof(Int64));
                Dt.Columns.Add("IsError", typeof(bool));
                Dt.Columns.Add("Item_Style", typeof(string));
            }
            catch { }

            foreach (DataRow Dr in Dt.Rows)
            {
                Ct++;
                Dr["TmpKey"] = Ct;
                Dr["Item_Style"] = "";
            }
        }

        protected virtual void AddRequired()
        {
            if (this.mBase_TableDetail == null) return;
            foreach (ClsBaseTableDetail Obj in this.mBase_TableDetail)
            { this.AddRequired(Obj.pDt); }
        }

        public virtual void Check_Clear(DataTable Dt)
        {
            DataRow[] Arr_Dr = Dt.Select("", "", DataViewRowState.CurrentRows);
            foreach (DataRow Dr in Arr_Dr)
            {
                Dr["IsError"] = false;
                Dr["Item_Style"] = "";
            }
        }

        public virtual void Check_Clear()
        {
            if (this.mBase_TableDetail == null)
            { return; }

            foreach (ClsBaseTableDetail Obj in this.mBase_TableDetail)
            { this.Check_Clear(Obj.pDt); }
        }

        #endregion

        #region _Properties

        public Int64 pID
        {
            get
            { return (Int64)Methods.IsNull(this.mHeader_Dr[this.mHeader_TableKey], 0); }
        }

        public ClsKeys pKey 
        {
            get
            {
                ClsKeys Obj = new ClsKeys();
                try
                {
                    foreach (string Key in this.mHeader_Key)
                    {
                        Int64 ID = Convert.ToInt64(Methods.IsNull(this.mHeader_Dr[Key], 0));
                        Obj.Add(Key, ID);
                    }
                }
                catch
                { Obj = null; }
                return Obj;                
            }
        }

        public virtual DataRow pDr
        {
            get
            { return this.mHeader_Dr; }
        }

        public List<string> pHeader_Key
        {
            get
            { return this.mHeader_Key; }
        }

        public string pHeader_TableName
        {
            get { return this.mHeader_TableName; }
        }

        public string pHeader_ViewName
        {
            get { return this.mHeader_ViewName; }
        }

        public ClsSysCurrentUser pCurrentUser
        {
            get { return this.mCurrentUser; }
        }

        public string pHeader_TableKey
        {
            get { return this.mHeader_TableKey; }
        }

        public DataTable pTableDetail_Get(string Name)
        {
            ClsBaseTableDetail Obj = null;
            foreach (ClsBaseTableDetail Inner_Obj in this.mBase_TableDetail)
            {
                if (Inner_Obj.pTableName == Name)
                {
                    Obj = Inner_Obj;
                    break;
                }
            }

            DataTable Dt = null;
            if (Obj != null) Dt = Obj.pDt;

            return Dt;
        }

        public void pTableDetail_Set(string Name, DataTable Value)
        {
            ClsBaseTableDetail Obj = null;
            foreach (ClsBaseTableDetail Inner_Obj in this.mBase_TableDetail)
            {
                if (Inner_Obj.pTableName == Name)
                {
                    Obj = Inner_Obj;
                    break;
                }
            }
            Obj.pDt = Value;
        }

        public DataRow pRowDetail_Get(string Name)
        {
            ClsBaseRowDetail Obj = null;
            foreach (ClsBaseRowDetail Inner_Obj in this.mBase_RowDetail)
            {
                if (Inner_Obj.pTableName == Name)
                {
                    Obj = Inner_Obj;
                    break;
                }
            }

            DataRow Dr = null;
            if (Obj != null) Dr = Obj.pDr;
            return Dr;
        }

        #endregion
    }
}
