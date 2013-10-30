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
using Layer02_Objects;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;

namespace Layer02_Objects.Modules_Base.Objects
{
    public class ClsBaseRowDetail
    {
        #region _Variables

        string mHeaderName;
        string mTableName;
        string mViewName;
        List<string> mList_Key = new List<string>();
        ClsBase mObj_Base;

        string mOtherLoadCondition;
        DataRow mDr;

        #endregion

        #region _Constructor

        private ClsBaseRowDetail()
        { }

        public ClsBaseRowDetail(ClsBase pObj_Base, string pHeaderName, string pTableName, string pViewName = "", string pOtherLoadCondition = "")
        {
            if (pViewName == "") pViewName = pTableName;

            this.mHeaderName = pHeaderName;
            this.mTableName = pTableName;
            this.mViewName = pViewName;
            this.mOtherLoadCondition = pOtherLoadCondition;
            this.mObj_Base = pObj_Base;

            DataTable Dt_Def = Methods_Query.GetTableDef(this.mTableName);
            DataRow[] ArrDr = Dt_Def.Select("IsPk = 1");
            foreach (DataRow Dr in ArrDr)
            {
                this.mList_Key.Add((string)Dr["ColumnName"]);
            }
        }
        
        #endregion

        #region _Methods

        public void Load(ClsDataAccess Da, string Condition = "")
        {
            string OtherCondition = "";
            if (this.mOtherLoadCondition != "") OtherCondition = " And " + this.mOtherLoadCondition;

            DataTable Dt;
            DataRow Dr;
            if (Condition == "")
            {
                Dt = Methods_Query.GetQuery(Da, this.mViewName, "*", "1 = 0");
                Dr = Dt.NewRow();
            }
            else 
            { 
                Dt = Methods_Query.GetQuery(Da, this.mViewName, "*", Condition + OtherCondition);
                if (Dt.Rows.Count > 0) Dr = Dt.Rows[0];
                else Dr = Dt.NewRow();                
            }

            this.mDr = Dr;
        }

        public void Load(string Condition = "")
        {
            ClsDataAccess Da = new ClsDataAccess();
            try
            {
                Da.Connect();
                this.Load(Da, Condition);
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { Da.Close(); }
        }

        public void Save(ClsDataAccess Da)
        {
            foreach (string Header_Key in this.mObj_Base.pHeader_Key)
            {
                Int64 Inner_ID = (Int64)Methods.IsNull(this.mObj_Base.pDr[Header_Key], 0);
                this.mDr[Header_Key] = Inner_ID;
            }

            Da.SaveDataRow(this.mDr, this.mTableName);
        }

        #endregion

        #region _Properties

        public string pTableName
        {
            get
            { return this.mTableName; }
        }

        public DataRow pDr
        {
            get
            { return this.mDr; }
        }

        #endregion

    }
}
