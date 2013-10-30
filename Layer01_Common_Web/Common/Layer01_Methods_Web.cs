using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Layer01_Common;
using Layer01_Common.Common;
using Layer01_Common.Objects;
using Layer01_Common_Web;
using Layer01_Common_Web.Common;
using Layer01_Common_Web.Objects;
using Microsoft.JScript;
using DataObjects_Framework;
using DataObjects_Framework.Common;
using DataObjects_Framework.Objects;

namespace Layer01_Common_Web.Common
{
    public class Layer01_Methods_Web
    {

        public static List<ClsBindGridColumn> GetBindGridColumn(string Name)
        {
            List<ClsBindGridColumn> List_Gc = new List<ClsBindGridColumn>();
            ClsBindGridColumn Gc;

            DataTable Dt_Def = Do_Methods_Query.GetQuery(@"udf_System_BindDefinition('" + Name + "')", "", "", "OrderIndex");
            foreach (DataRow Dr in Dt_Def.Rows)
            {
                Gc = new ClsBindGridColumn(
                    (string)Do_Methods.IsNull(Dr["Name"], "")
                    , (string)Do_Methods.IsNull(Dr["Desc"], "")
                    , (Int32)Do_Methods.IsNull(Dr["Width"], 0)
                    , (string)Do_Methods.IsNull(Dr["NumberFormat"], "")
                    , (Layer01_Common.Common.Layer01_Constants.eSystem_Lookup_FieldType)Do_Methods.IsNull(Dr["System_LookupID_FieldType"], Layer01_Common.Common.Layer01_Constants.eSystem_Lookup_FieldType.FieldType_Static)
                    , !(bool)Do_Methods.IsNull(Dr["IsHidden"], false)
                    , !(bool)Do_Methods.IsNull(Dr["IsReadOnly"], false));

                Gc.mButtonType = (ButtonColumnType)Do_Methods.IsNull(Dr["System_LookupID_ButtonType"], ButtonColumnType.LinkButton);
                Gc.mFieldText = (string)Do_Methods.IsNull(Dr["FieldText"], "");

                List_Gc.Add(Gc);
            }

            return List_Gc;
        }

        public static void BindCombo(
            ref DropDownList Cbo
            , DataTable Dt
            , string Value
            , string Text
            )
        {
            Cbo.DataSource = Dt;
            Cbo.DataTextField = Text;
            Cbo.DataValueField = Value;
            Cbo.DataBind();
        }

        public static void BindCombo(
            ref DropDownList Cbo
            , DataTable Dt
            , string Value
            , string Text
            , object Default_Value
            , string Default_Text
            )
        {
            DataTable Dt_Bind = Dt.Clone();
            DataRow Dr = Dt_Bind.NewRow();
            Dr[Value] = Default_Value;
            Dr[Text] = Default_Text;
            Dt_Bind.Rows.Add(Dr);

            foreach( DataRow Inner_Dr  in Dt.Rows)
            {
                DataRow Nr = Dt_Bind.NewRow();
                Nr[Value] = Inner_Dr[Value];
                Nr[Text] = Inner_Dr[Text];
                Dt_Bind.Rows.Add(Nr);
            }

            BindCombo(ref Cbo, Dt_Bind, Value, Text);
        }

        public static void ImageThumbnail(string FileName, string FileName_Thumb)
        {
            System.IO.FileInfo Fi = new System.IO.FileInfo(FileName_Thumb);
            if (Fi.Exists)
            { Fi.Delete(); }

            System.Drawing.Image vImage = System.Drawing.Image.FromFile(FileName);
            int vWidth = vImage.Width;
            int vHeight = vImage.Height;

            if ((vImage.Width / vImage.Height) < (Layer01_Constants_Web.CnsImgThumbWidth / Layer01_Constants_Web.CnsImgThumbHeight))
            {
                vHeight = Layer01_Constants_Web.CnsImgThumbHeight;
                vWidth = (int)((vImage.Width * Layer01_Constants_Web.CnsImgThumbHeight) / vImage.Height);
            }
            else
            {
                vWidth = Layer01_Constants_Web.CnsImgThumbWidth;
                vHeight = (int)((vImage.Height * Layer01_Constants_Web.CnsImgThumbWidth) / vImage.Width);
            }

            System.Drawing.Image ThumbImg = vImage.GetThumbnailImage(vWidth, vHeight, null, IntPtr.Zero);            
            ThumbImg.Save(FileName_Thumb);
        }

        public static void ErrorHandler(Exception Ex, string ModuleName, System.Web.HttpServerUtility Server)
        {
            if (Ex == null)
            { return; }

            string Msg = "Error Log: " + ModuleName + ": " + Ex.Message;
            try
            { Msg += " : " + Ex.Source + " : " + Ex.TargetSite.Name; }
            catch { }

            string FilePath = Server.MapPath(Layer01_Constants_Web.CnsLogPath);
            Do_Methods.LogWrite(Msg, FilePath);
        }

        public static void ErrorHandler(Exception Ex, System.Web.HttpServerUtility Server)
        {
            if (Ex != null)
            { return; }
            ErrorHandler(Ex, "", Server);
        }

        public static void Eval_AppendJs(
            System.Web.HttpServerUtility Server
            , ref StringBuilder Sb
            , string ClientID
            , string ElementProperty
            , string Value
            )
        {
            Sb.Append(@"var Elem = document.getElementById('" + ClientID + "');");
            Sb.Append(@"if(Elem!=null){Elem." + ElementProperty + @" = unescape('" + GlobalObject.escape(Server.HtmlEncode(Value)) + "')};");
        }

        public System.Web.UI.Control SearchControl(ref System.Web.UI.Control C, string ID)
        {
            System.Web.UI.Control ReturnValue = null;
            foreach (System.Web.UI.Control Ic in C.Controls)
            {
                if (Ic.ID == ID)
                {
                    ReturnValue = Ic;
                    break;
                }
                else
                {
                    if (Ic.Controls.Count > 0)
                    {
                        System.Web.UI.Control Inner_Ic = Ic;
                        ReturnValue = SearchControl(ref Inner_Ic, ID);
                        if (ReturnValue != null)
                        { break; }
                    }
                }
            }
            return ReturnValue;
        }

        public static System.IO.StringWriter CreateExcel_HTML(
            DataTable Dt
            , ClsExcel_Columns Columns)
        {
            System.IO.StringWriter Sw = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter Htw = new System.Web.UI.HtmlTextWriter(Sw);
            System.Web.UI.WebControls.Table Tb = new System.Web.UI.WebControls.Table();

            System.Web.UI.WebControls.TableRow Tbr_Header = new System.Web.UI.WebControls.TableRow();
            foreach (ClsExcel_Columns.Str_Columns? Obj in Columns.pObj)
            {
                System.Web.UI.WebControls.TableCell Tbc = new System.Web.UI.WebControls.TableCell();
                Tbc.Text = Obj.Value.FieldDesc;
                Tbr_Header.Cells.Add(Tbc);
            }

            Tb.Rows.Add(Tbr_Header);

            foreach (DataRow Dr in Dt.Rows)
            {
                System.Web.UI.WebControls.TableRow Tbr = new System.Web.UI.WebControls.TableRow();
                foreach (ClsExcel_Columns.Str_Columns? Obj in Columns.pObj)
                {
                    System.Web.UI.WebControls.TableCell Tbc = new System.Web.UI.WebControls.TableCell();
                    Tbc.Text = Dr[Obj.Value.FieldName].ToString();
                    Tbr.Cells.Add(Tbc);
                }
                Tb.Rows.Add(Tbr);
            }
            Tb.RenderControl(Htw);
            return Sw;
        }

        public static void AddControlAttributes(WebControl Wc, System.Web.UI.Page Page, string Key, string Value, string[] Arguments = null, string[] ArgumentValues = null)
        {
            StringBuilder Sb_Args = new StringBuilder();
            if (Arguments != null)
            {
                bool IsStart = false;
                string Comma = "";
                foreach (string S in Arguments)
                {
                    Sb_Args.Append(Comma + " " + S);
                    if (!IsStart)
                    {
                        IsStart = true;
                        Comma = ",";
                    }
                }
            }

            StringBuilder Sb_ArgValues = new StringBuilder();
            if (ArgumentValues != null)
            {
                bool IsStart = false;
                string Comma = "";
                foreach (string S in ArgumentValues)
                {
                    Sb_ArgValues.Append(Comma + " " + S);
                    if (!IsStart)
                    {
                        IsStart = true;
                        Comma = ",";
                    }
                }
            }

            StringBuilder Sb_Js = new StringBuilder();
            Sb_Js.AppendLine(@"function " + Key + @"_" + Page.ClientID + Wc.ClientID + @"(" + Sb_Args.ToString() + ") {");
            Sb_Js.AppendLine(Value);
            Sb_Js.AppendLine(@"}");
            Page.ClientScript.RegisterClientScriptBlock(typeof(string), Wc.ClientID, Sb_Js.ToString(), true);
            Wc.Attributes.Add(Key, Key + @"_" + Page.ClientID + Wc.ClientID + @"(" + Sb_ArgValues.ToString() + "); return false;");
        }

        public static bool Save_Validation(
            ref System.Text.StringBuilder Sb_Msg
            , ref WebControl Wc
            , ref bool IsValid_Ref
            , string CssNormal
            , string CssValidateHightlight
            , bool IsValid
            , string InvalidMsg)
        {
            if (IsValid)
            { Wc.CssClass = CssNormal; }
            else
            {
                Wc.CssClass = CssValidateHightlight;
                Sb_Msg.Append(InvalidMsg);

            }
            return IsValid;
        }

    }
}
