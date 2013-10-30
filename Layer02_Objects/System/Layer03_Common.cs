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
using Layer02_Objects._System;
using DataObjects_Framework;
using DataObjects_Framework.Connection;
using DataObjects_Framework.Common;
using DataObjects_Framework.Objects;

namespace Layer02_Objects._System
{
    public class Layer03_Common
    {
        public static DateTime GetServerDate(ClsConnection_SqlServer Cn)
        {
            DataTable Dt = Cn.ExecuteQuery("Select GetDate() As ServerDate").Tables[0];
            if (Dt.Rows.Count > 0) return (DateTime)Dt.Rows[0][0];
            else return DateTime.Now;
        }

        public static DateTime GetServerDate()
        {
            ClsConnection_SqlServer Da = new ClsConnection_SqlServer();
            try
            {
                Da.Connect();
                return GetServerDate(Da);
            }
            catch (Exception ex)
            { throw ex; }
            finally
            { Da.Close(); }
        }

        public static string GetSeriesNo(string Name)
        {
            string Rv = "";
            DataTable Dt;
            string TableName;
            string FieldName;
            string Prefix;
            Int32 Digits;

            Dt = Do_Methods_Query.GetQuery("System_DocumentSeries", "", "ModuleName = '" + Name + "'");
            if (Dt.Rows.Count > 0)
            {
                TableName = (string)Do_Methods.IsNull(Dt.Rows[0]["TableName"], "");
                FieldName = (string)Do_Methods.IsNull(Dt.Rows[0]["FieldName"], "");
                Prefix = (string)Do_Methods.IsNull(Dt.Rows[0]["Prefix"], "");
                Digits = (Int32)Do_Methods.IsNull(Dt.Rows[0]["Digits"], "");
            }
            else
            { return Rv; }

            List<Do_Constants.Str_Parameters> Sp = new List<Do_Constants.Str_Parameters>();
            Sp.Add(new Do_Constants.Str_Parameters("@TableName", TableName));
            Sp.Add(new Do_Constants.Str_Parameters("@FieldName", FieldName));
            Sp.Add(new Do_Constants.Str_Parameters("@Prefix", Prefix));
            Sp.Add(new Do_Constants.Str_Parameters("@Digits", Digits));

            Dt = Do_Methods_Query.ExecuteQuery("usp_GetSeriesNo", Sp).Tables[0];
            if (Dt.Rows.Count > 0)
            { Rv = (string)Dt.Rows[0][0]; }

            return Rv;
        }

        public static bool CheckSeriesDuplicate(
            string TableName
            , string SeriesField
            , ClsKeys Keys
            , string SeriesNo)
        {
            bool Rv = false;
            DataTable Dt;

            System.Text.StringBuilder Sb_Query_Key = new StringBuilder();
            string Query_Key = "";
            string Query_And = "";

            foreach (string Inner_Key in Keys.pName)
            {
                Sb_Query_Key.Append(Query_And + " " + Inner_Key + " = " + Keys[Inner_Key]);
                Query_And = " And ";
            }

            Query_Key = " 1 = 1 ";
            if (Sb_Query_Key.ToString() != "")
            { Query_Key = "(Not (" + Sb_Query_Key.ToString() + "))"; }

            Dt = Do_Methods_Query.GetQuery(
                "[" + TableName + "]"
                , "Count(1) As [Ct]"
                , Query_Key + " And " + SeriesField + " = '" + SeriesNo + "'");
            if (Dt.Rows.Count > 0)
            {
                if ((Int32)Dt.Rows[0][0] > 0)
                { Rv = true; }
            }

            //True means duplicates have been found
            return Rv;
        }

    }
}
