using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.DataAccess;
using Layer01_Common.Objects;
using Layer02_Objects;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects._System;

namespace Layer02_Objects._System
{
    public class ClsKeys
    {

        #region _Variables

        public struct Str_Keys
        {
            public string Name;
            public Int64 Value;
            public Str_Keys(string pName, Int64 pValue)
            {
                Name = pName;
                Value = pValue;
            }
        }

        List<Str_Keys> mObj = new List<Str_Keys>();
        
        #endregion

        #region _Methods

        public void Add(string Name, Int64 Value = 0)
        {
            this.mObj.Add(new Str_Keys(Name, Value));
        }

        public Int32 Count()
        { return this.mObj.Count(); }
        
        #endregion

        #region _Properties

        public Int64 this[string Name]
        {
            get
            {
                foreach (Str_Keys Obj in this.mObj)
                {
                    if (Name == Obj.Name) return Obj.Value;
                }
                return 0;
            }
            set
            {
                foreach (Str_Keys Obj in this.mObj)
                {
                    if (Name == Obj.Name)
                    {
                        Str_Keys Inner_Obj = Obj;
                        Inner_Obj.Value = value;
                        return;
                    }
                }
            }
        }

        public string[] pName
        {
            get
            {
                List<string> Name = new List<string>();
                foreach (Str_Keys Obj in this.mObj)
                {                    
                    Name.Add(Obj.Name);
                }
                return Name.ToArray();
            }
        }
        
        #endregion

    }
}
