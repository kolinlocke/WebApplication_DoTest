using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;

namespace Layer01_Common_Web.Objects
{
    [DataContract]
    public class JqGrid_Dt
    {
        public JqGrid_Dt(
            DataTable pDt
            , List<ClsBindGridColumn> List_Gc
            , string pKey = ""
            , string pPage = null
            , int? pTotal = null
            , string pRecords = null)
        {
            this.mKey = pKey;

            this.Rows = new List<JqGrid_Dr>();
            foreach (DataRow Dr in pDt.Rows)
            { this.Rows.Add(new JqGrid_Dr(Dr, List_Gc, pKey)); }
        }

        string mKey;
        //List<ClsBindGridColumn> mList_Gc;

        [DataMember(IsRequired = true, Name = "page")]
        public string Page { get; set; }

        [DataMember(IsRequired = true, Name = "total")]
        public int Total { get; set; }

        [DataMember(IsRequired = true, Name = "records")]
        public string Records { get; set; }

        [DataMember(IsRequired = true, Name = "rows")]
        public List<JqGrid_Dr> Rows { get; set; }

        public string Serialize()
        {
            DataContractJsonSerializer js = new DataContractJsonSerializer(typeof(JqGrid_Dt));
            System.IO.MemoryStream Ms = new System.IO.MemoryStream();
            js.WriteObject(Ms, this);

            Ms.Position = 0;
            System.IO.StreamReader Sr = new System.IO.StreamReader(Ms);
            string JsonData = Sr.ReadToEnd();
            return JsonData;
        }

    }

    [DataContract]
    public class JqGrid_Dr
    {
        public JqGrid_Dr(
            DataRow Dr
            , List<ClsBindGridColumn> List_Gc
            , string Key = "")
        {
            if (Key != "")
            { this.ID = Dr[Key].ToString(); }

            this.Cell = new List<string>();
            /*
            foreach (DataColumn Dc in Dr.Table.Columns)
            { this.Cell.Add(Dr[Dc].ToString()); }
            */

            foreach (ClsBindGridColumn Gc in List_Gc)
            { this.Cell.Add(Dr[Gc.mFieldName].ToString()); }

        }

        [DataMember(IsRequired = true, Name = "id")]
        public string ID { get; set; }

        [DataMember(IsRequired = true, Name = "cell")]
        public List<string> Cell { get; set; }
    }
}
