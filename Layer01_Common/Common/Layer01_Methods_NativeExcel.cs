using System;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using NativeExcel;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.Objects;
using DataObjects_Framework;
using DataObjects_Framework.Common;

namespace Layer01_Common.Common
{
    public class Layer01_Methods_NativeExcel
    {
        public static void NativeExcel_CreateExcel(
            DataTable Dt
            , ClsExcel_Columns Columns
            , string SaveFileName = ""
            , NativeExcel.XlFileFormat FileFormat = XlFileFormat.xlNormal)
        {
            IWorkbook owbook = NativeExcel.Factory.CreateWorkbook();
            IWorksheet owsheet = owbook.Worksheets.Add();
                        
            Int32 RowCt = 2;
            Int32 ColCt = 1;

            foreach (ClsExcel_Columns.Str_Columns? Obj in Columns.pObj)
            {
                owsheet.Cells[RowCt, ColCt].Value = Obj.Value.FieldDesc;
                owsheet.Cells[RowCt, ColCt].Font.Bold = true;
                IRange Inner_ExRange =
                    owsheet.Range[
                        Do_Methods.GenerateChr(ColCt)
                        + RowCt.ToString()
                        + ":"
                        + Do_Methods.GenerateChr(ColCt)
                        + (RowCt + Dt.Rows.Count).ToString()];
                Inner_ExRange.NumberFormat = Obj.Value.NumberFormat;
                ColCt++;
            }

            RowCt++;
            ColCt = 1;

            IRange ExRange =
                owsheet.Range[
                Do_Methods.GenerateChr(ColCt)
                + RowCt.ToString()
                + ":"
                + Do_Methods.GenerateChr(ColCt + Columns.pObj.Count)
                + (RowCt + Dt.Rows.Count - 1).ToString()];

            ExRange.Value = Do_Methods.ConvertDataTo2DimArray(Dt, Columns.pFieldName);
            owsheet.Range["A1;IV65536"].Autofit();

            if (SaveFileName == "")
            { SaveFileName = "Excel_File"; }

            owsheet.Cells["A1"].RowHeight = 0;
            owsheet.Range["A2:A2"].Select();
            owbook.SaveAs(SaveFileName, FileFormat);
        }

        public static DataTable NativeExcel_CreateExcelDocument_GetSections(IWorksheet Sheet_Parameters)
        {
            DataTable Dt_ReturnValue = new DataTable();
            Dt_ReturnValue.Columns.Add("Ct", typeof(Int32));
            Dt_ReturnValue.Columns.Add("Type", typeof(string));
            Dt_ReturnValue.Columns.Add("Location", typeof(string));

            Int32 CtStart = 0;
            Int32 CtEnd = 0;
            Int32 Ct = 0;

            for (Ct = 1; Ct <= 65536; Ct++)
            {
                switch (Sheet_Parameters.Range["A" + Ct.ToString()].Characters.Text)
                { 
                    case "[#]Sections":
                        CtStart = Ct;
                        break;
                    case "[#]End_Sections":
                        CtEnd = Ct;
                        break;
                }
            }

            Int32 Sections_Ct = 0;

            for (Ct = CtStart; Ct <= CtEnd; Ct++)
            {
                string ExcelText = Sheet_Parameters.Range["A" + Ct.ToString()].Characters.Text;
                string Section_Type = "";
                string Section_Location = "";

                if (!(ExcelText.IndexOf("[") > 0))
                {
                    try
                    {
                        Section_Type = ExcelText.Substring(1, ExcelText.IndexOf(' ') - 1);
                        Section_Location = ExcelText.Substring(ExcelText.IndexOf(' ') + 1);
                        Sections_Ct++;

                        DataRow Nr = Dt_ReturnValue.NewRow();
                        Nr["Ct"] = Sections_Ct;
                        Nr["Type"] = Section_Type;
                        Nr["Location"] = Section_Location;
                        Dt_ReturnValue.Rows.Add(Nr);
                    }
                    catch (Exception ex)
                    { throw new Exception("Error Occured: NativeExcel_CreateExcelDocument_GetSections: " + ex.Message); }
                }
            }
            return Dt_ReturnValue;
        }

        public static DataTable NativeExcel_CreateExcelDocument_GetDataTables(IWorksheet Sheet_Parameters)
        {
            DataTable Dt_ReturnValue = new DataTable();
            Dt_ReturnValue.Columns.Add("Ct", typeof(Int32));
            Dt_ReturnValue.Columns.Add("Name", typeof(string));
            Dt_ReturnValue.Columns.Add("GroupName", typeof(string));
            Dt_ReturnValue.Columns.Add("SourceKey", typeof(string));
            Dt_ReturnValue.Columns.Add("TargetKey", typeof(string));
            Dt_ReturnValue.Columns.Add("IsSubTable", typeof(string));
            Dt_ReturnValue.Columns.Add("Location", typeof(string));
            Dt_ReturnValue.Columns.Add("Items", typeof(Int32));

            Int32 CtStart = 0;
            Int32 CtEnd = 0;
            Int32 Ct = 0;

            for (Ct = 1; Ct <= 65536; Ct++)
            {
                switch (Sheet_Parameters.Range["A" + Ct.ToString()].Characters.Text)
                {
                    case "[#]DataTable":
                        CtStart = Ct;
                        break;
                    case "[#]End_DataTable":
                        CtEnd = Ct;
                        break;
                }
            }

            if (CtStart == 0 && CtEnd == 0)
            { throw new Exception(@"Invalid Syntax in [#]DataTable."); }

            Int32 DataTable_Ct = 0;

            for (Ct = CtStart; Ct <= CtEnd; Ct++)
            {
                string ExcelText = "";
                try { ExcelText = Sheet_Parameters.Range["A" + Ct.ToString()].Characters.Text; }
                catch { }

                string DataTable_Name = "";
                string DataTable_GroupName = "";
                string DataTable_SourceKey = "";
                string DataTable_TargetKey = "";
                string DataTable_Location = "";

                
                if (!(ExcelText.IndexOf("[") > 0))
                {
                    try
                    {
                        string[] Inner_Arr = ExcelText.Split(' ');
                        //Continue Here

                        DataTable_Name = Inner_Arr[0];
                        DataTable_Location = Inner_Arr[1];

                        try
                        {
                            DataTable_GroupName = Inner_Arr[2];
                            DataTable_SourceKey = Inner_Arr[3];
                            DataTable_TargetKey = Inner_Arr[4];
                        }
                        catch { }

                        DataTable_Ct++;

                        DataRow Nr = Dt_ReturnValue.NewRow();
                        Nr["Ct"] = DataTable_Ct;
                        Nr["Name"] = DataTable_Name;
                        Nr["Location"] = DataTable_Location;

                        if (DataTable_GroupName.Trim() != "")
                        {
                            Nr["GroupName"] = DataTable_GroupName;
                            Nr["SourceKey"] = DataTable_SourceKey;
                            Nr["TargetKey"] = DataTable_TargetKey;
                            Nr["IsSubTable"] = true;
                        }

                        Dt_ReturnValue.Rows.Add(Nr);
                    }
                    catch (Exception ex)
                    { throw new Exception("Error Occured: NativeExcel_CreateExcelDocument_GetDataTables: " + ex.Message); }
                }
            }
            return Dt_ReturnValue;
        }

    }
}
