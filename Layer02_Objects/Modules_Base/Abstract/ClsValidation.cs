using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Layer01_Common;
using Layer02_Objects;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;

namespace Layer02_Objects.Modules_Base.Abstract
{
	public abstract class ClsValidation
	{
		#region _Variables

		protected ClsBase mBase;
		protected List<Str_ValidationError> mList_ValidationError = new List<Str_ValidationError>();

		public struct Str_ValidationError
		{
			public String Name;
			public String Message;
		}

		#endregion

		#region _Methods

		public virtual void Setup(ClsBase Base)
		{ this.mBase = Base; }

		public abstract Boolean Validate();

		protected void AddError(String Name, String Message)
		{ this.mList_ValidationError.Add(new Str_ValidationError() { Name = Name, Message = Message }); }

        public Boolean FindError(String Name)
        { return this.mList_ValidationError.Exists(O => O.Name == Name); }

        public List<String> GetErrors()
        { return (from O in this.mList_ValidationError select O.Message).ToList(); }

		#endregion

        #region _Properties

        public List<Str_ValidationError> pList_ValidationError
        {
            get { return this.mList_ValidationError; }
        }

        #endregion
    }
}
