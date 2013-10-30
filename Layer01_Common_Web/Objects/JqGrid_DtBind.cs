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
    public class JqGrid_DtBind
    {
        public JqGrid_DtBind(List<ClsBindGridColumn> List_Gc)
        {
            this.List_ColModel = new List<JqGrid_DtBind_Obj>();
            this.List_ColNames = new List<string>();
            foreach (ClsBindGridColumn Gc in List_Gc)
            {
                this.List_ColModel.Add(new JqGrid_DtBind_Obj(
                    Gc.mFieldName
                    , Gc.mWidth));

                this.List_ColNames.Add(Gc.mFieldDesc);
            }
        }

        public string Serialize_ColModel()
        {
            DataContractJsonSerializer js = new DataContractJsonSerializer(typeof(List<JqGrid_DtBind_Obj>));
            System.IO.MemoryStream Ms = new System.IO.MemoryStream();
            js.WriteObject(Ms, this.List_ColModel);

            Ms.Position = 0;
            System.IO.StreamReader Sr = new System.IO.StreamReader(Ms);
            string JsonData = Sr.ReadToEnd();
            return JsonData;
        }

        public string Serialize_ColNames()
        {
            DataContractJsonSerializer js = new DataContractJsonSerializer(typeof(List<string>));
            System.IO.MemoryStream Ms = new System.IO.MemoryStream();
            js.WriteObject(Ms, this.List_ColNames);

            Ms.Position = 0;
            System.IO.StreamReader Sr = new System.IO.StreamReader(Ms);
            string JsonData = Sr.ReadToEnd();
            return JsonData;
        }

        public List<JqGrid_DtBind_Obj> List_ColModel { get; set; }

        public List<string> List_ColNames { get; set; }

    }

    [DataContract]
    public class JqGrid_DtBind_Obj
    {
        public JqGrid_DtBind_Obj(
            string Name
            , Int32 Width = 100
            , bool IsSortable = true
            , bool IsResizable = true)
        {
            this.Name = Name;
            this.Width = Width.ToString();
            this.IsSortable = IsSortable.ToString().ToLower();
            this.IsResizable = IsResizable.ToString().ToLower();
        }
        
        [DataMember(IsRequired=true, Name="name")]
        public string Name { get; set; }

        [DataMember(IsRequired = true, Name = "width")]
        public string Width { get; set; }

        [DataMember(IsRequired = true, Name = "sortable")]
        public string IsSortable { get; set; }

        [DataMember(IsRequired = true, Name = "resizable")]
        public string IsResizable { get; set; }

    }

}
