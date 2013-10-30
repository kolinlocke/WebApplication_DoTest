<%@ Page Title="" Language="C#" MasterPageFile="~/Modules_Master/Master_Details.master" AutoEventWireup="true" CodeBehind="Page_Rights_Details.aspx.cs" Inherits="Layer03_Website.Modules_Page.Page_Rights_Details" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="~/Modules_UserControl/Control_Grid.ascx" TagPrefix="Uc" TagName="Grid" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder_Buttons_Top" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_Details" runat="server">
    <script type="text/javascript" src="../Scripts/Js_Common.js"></script>
    <script type="text/javascript" src="../Scripts/Js_ModuleRequired.js" ></script>
    <div>
        <table>
            <tr>
                <td valign="middle" style="width: 120px">
                    Rights Name:
                </td>
                <td align="left" valign="middle">
                    <asp:TextBox ID="Txt_Name" runat="server" CssClass="clsTextbox" Width="200px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td valign="middle">
                    Description:
                </td>
                <td align="left" valign="middle">
                    <asp:TextBox ID="Txt_Desc" runat="server" CssClass="clsTextbox" Width="200px" TextMode="SingleLine"></asp:TextBox>
                </td>
            </tr>
        </table>
    </div>
    <br />
    <div>
        <div>
            <table style="width:100%;">
                <tr>
                    <td align="left">
                        <table>
                            <tr>
                                <td valign="middle">
                                    Filter:
                                </td>
                                <td valign="middle">
                                    <asp:TextBox ID="Txt_Search" runat="server" CssClass="clsTextbox" Width="150px"></asp:TextBox>
                                    <asp:DropDownList ID="Cbo_SearchFilter" runat="server" Width="150px" />
                                </td>
                                <td align="left" valign="middle">
                                    <asp:Button ID="Btn_Search" runat="server" CssClass="clsButton" Text="Filter" Width="80px" />
                                </td>
                                <td>
                                    <asp:Button ID="Btn_ClearSearch" runat="server" CssClass="clsButton" Text="Clear" Width="80px" />
                                </td>
                            </tr>
                        </table>                
                    </td>
                    <td align="right" valign="middle">
                        <asp:Button ID="Btn_CheckAll" runat="server" CssClass="clsButton" Text="Check All" Width="80px" UseSubmitBehavior="False" />
                        <asp:Button ID="Btn_UncheckAll" runat="server" CssClass="clsButton" 
                            Text="Uncheck All" Width="100px" UseSubmitBehavior="False" />
                    </td>
                </tr>
            </table>
        </div>
        <div>
            <Uc:Grid ID="UcGrid_Details" runat="server" />
        </div>
    </div>
    <eo:Callback ID="EOCb_Filter" runat="server" 
        ClientSideAfterExecute="EOCb_AE" ClientSideBeforeExecute="EOCb_BE"
        Triggers="{ControlID:Btn_Search;Parameter:Btn_Search},{ControlID:Btn_ClearSearch;Parameter:Btn_ClearSearch},{ControlID:Btn_CheckAll;Parameter:Btn_CheckAll},{ControlID:Btn_UncheckAll;Parameter:Btn_UncheckAll}">
    </eo:Callback>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder_Buttons_Bottom" runat="server">
</asp:Content>
