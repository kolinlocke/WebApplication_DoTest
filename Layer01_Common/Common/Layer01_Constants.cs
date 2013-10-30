using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Layer01_Common.Common
{
    public class Layer01_Constants
    {
        public const string CnsConnectionString_Cache = "CnsConnectionString_Cache";

        public enum eSystem_Modules: long
        {
            None = 0
            , Sys_Login = 1
            , Mas = 2
            , CS = 3
            , Inv = 4
            , AR = 5
            , AP = 6
            , Sec = 7
            , Ledger = 8
            , GLSettings = 9
            , Lookup = 10
            , Mas_Bank = 11
            , Mas_Box = 12
            , Mas_Customer = 13
            , Mas_Item = 14
            , Mas_Supplier = 15
            , Mas_Warehouse = 16
            , Mas_Employee = 17
            , Mas_BOA = 18
            , Mas_COA = 19
            , CS_CustomerLogs = 20
            , Inv_Beginning = 21
            , Inv_Adjustments = 22
            , Inv_Transfer = 23
            , Inv_Count = 24
            , AR_PriceList = 25
            , AR_SalesOrder = 26
            , AR_PickList = 27
            , AR_DeliverOrder = 28
            , AR_SalesInvoice = 29
            , AR_SalesReceipt = 30
            , AP_PurchaseOrder = 31
            , AP_ReceiveOrder = 32
            , AP_VoucherPayable = 33
            , AP_PurchaseReturn = 34
            , AP_NonTradePayables = 35
            , AP_DebitCreditNotes = 36
            , AP_PaymentVoucher = 37
            , Sec_Users = 38
            , Sec_Rights = 39
            , AR_SalesOrderBackOrders = 40
            , AR_DeliveryReturn = 41
            , AP_EmployeeExpense = 42
            , GL_JournalVoucher = 43
            , AR_ARDebitNotes = 44
            , AR_ARCreditNotes = 45
            , AP_APDebitNotes = 46
            , AP_APCreditNotes = 47
            , AR_CreditNotes = 48
            , AR_Refunds = 49
            , AR_SalesReturn = 50
            , SysSettings = 51
            , SysSettings_DocumentSeries = 52
            , Inv_Status = 53
            , GL_GLEntryCurrent = 54
            , AR_SalesInvoiceOrderTracking = 55
            , GL_GeneralLedger = 56
            , GL_PeriodClosing = 57
            , Reports = 58
            , GL_AccountBudget = 59
            , Inv_History = 60
            , Reports_AR = 61
            , Reports_AP = 62
            , Reports_Inventory = 63
            , Reports_ContactManager = 64
            , AP_ReleasedChecks = 65
            , GL_LedgerEntry = 66
        }

        public enum eAccessLib : int
        { 
            eAccessLib_Access = 1
            , eAccessLib_New = 2
            , eAccessLib_Edit = 3
            , eAccessLib_Delete = 4
            , eAccessLib_View = 5
            , eAccessLib_Approve = 6
            , eAccessLib_Post = 7
            , eAccessLib_Cancel = 8
        }

        public enum eLookup : int
        { 
            None = 0
            , CallTopic = 1
            , Category = 2
            , ClientType = 3
            , CostDeductionType = 4
            , Country = 5
            , Currency = 6
            , DeliveryMethod = 7
            , Department = 8
            , EmployeeType = 9
            , InvoiceType = 10
            , ItemType = 11
            , OrderType = 12
            , Payee_Type = 13
            , PaymentTerm = 14
            , PayRate = 15
            , ShipVia = 16
            , States = 17
            , UOM = 18
            , TaxCode = 19
            , Warehouse = 20
            , PriceDiscount = 21
            , Brand = 22
            , Retailer = 23
            , ShippingCost = 24
            , LeaveType = 25
        }

        public enum eSystem_Lookup : int
        {
            None = 0
            , FieldType_Static = 1
            , FieldType_Text = 2
            , FieldType_Checkbox = 3
            , FieldType_DateTime = 4
            , FieldType_Button = 5
            , FieldType_Delete = 6
        }
        
        public enum eSystem_Lookup_FieldType : int
        { 
            None = eSystem_Lookup.None
            , FieldType_Static = eSystem_Lookup.FieldType_Static
            , FieldType_Text = eSystem_Lookup.FieldType_Text
            , FieldType_Checkbox = eSystem_Lookup.FieldType_Checkbox
            , FieldType_DateTime = eSystem_Lookup.FieldType_DateTime
            , FieldType_Button = eSystem_Lookup.FieldType_Button
            , FieldType_Delete = eSystem_Lookup.FieldType_Delete
        }

        public enum eSystem_LookupPartyType: int
        {
            None = 0,
            Employee = 1,
            Customer = 2,
            Supplier = 3,
            Warehouse = 4,
            Bank = 5
        }

        public struct Str_AddSelectedFields
        {
            public string Field_Target;
            public string Field_Selected;

            public Str_AddSelectedFields(string pField_Target, string pField_Selected)
            {
                Field_Target = pField_Target;
                Field_Selected = pField_Selected;
            }
        }

        public struct Str_AddSelectedFieldsDefault
        {
            public string Field_Target;
            public object Value;

            public Str_AddSelectedFieldsDefault(string pField_Target, object pValue)
            {
                Field_Target = pField_Target;
                Value = pValue;
            }
        }
    }
}
