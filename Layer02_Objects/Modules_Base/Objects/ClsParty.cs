using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Microsoft.VisualBasic;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.Objects;
using Layer02_Objects;
using Layer02_Objects.Modules_Base;
using Layer02_Objects.Modules_Base.Abstract;
using Layer02_Objects.Modules_Base.Objects;
using Layer02_Objects._System;

namespace Layer02_Objects.Modules_Base.Objects
{
    public class ClsParty: ClsModule_Address
    {
        #region _Variables

        Layer01_Common.Common.Layer01_Constants.eSystem_LookupPartyType mPartyType;
        
        #endregion

        #region _Constructor

        public ClsParty(Layer01_Common.Common.Layer01_Constants.eSystem_LookupPartyType pPartyType, ClsSysCurrentUser pCurrentUser = null) 
        {
            this.Setup(pCurrentUser,"Party");
            this.mPartyType = pPartyType;
        }

        #endregion

        #region _Methods

        public override bool Save(DataObjects_Framework.DataAccess.Interface_DataAccess Da = null)
        {
            this.pDr["System_LookupID_PartyType"] = this.mPartyType;
            return base.Save(Da);
        }

        #endregion

    }
}
