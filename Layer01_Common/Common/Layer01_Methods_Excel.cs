using System;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.Objects;
using DataObjects_Framework;
using DataObjects_Framework.Common;

namespace Layer01_Common.Common
{
    class Layer01_Methods_Excel
    {

        public static void NativeExcel_CreateExcel(
            DataTable Dt
            , ClsExcel_Columns Columns
            , string SaveFileName = ""
            , Excel.XlFileFormat FileFormat =  Excel.XlFileFormat.xlExcel5
            , string Title = "")
        {
            Excel.Application Obj_Excel = new Excel.Application();

            Excel.Workbook owbook = Obj_Excel.Workbooks.Add();
            Excel.Worksheet owsheet = owbook.Worksheets.Add();

            Int32 RowCt = 2;
            Int32 ColCt = 1;

            foreach (ClsExcel_Columns.Str_Columns? Obj in Columns.pObj)
            {
                owsheet.Cells[RowCt, ColCt].Value = Obj.Value.FieldDesc;
                owsheet.Cells[RowCt, ColCt].Font.Bold = true;
                Excel.Range Inner_ExRange =
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

            Excel.Range ExRange =
                owsheet.Range[
                Do_Methods.GenerateChr(ColCt)
                + RowCt.ToString()
                + ":"
                + Do_Methods.GenerateChr(ColCt + Columns.pObj.Count)
                + (RowCt + Dt.Rows.Count - 1).ToString()];

            ExRange.Value = Do_Methods.ConvertDataTo2DimArray(Dt, Columns.pFieldName);
            owsheet.Range["A1;IV65536"].AutoFit();

            if (SaveFileName == "")
            { SaveFileName = "Excel_File"; }

            owsheet.Range["A1:A1"].Select();
            owbook.SaveAs(SaveFileName, FileFormat);
        }

    }
}
