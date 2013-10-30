<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Control_Address.ascx.cs" Inherits="Layer03_Website.Modules_UserControl.Control_Address" %>

<script type="text/javascript" src="../Scripts/Js_Common.js"></script>

<div>
    <table>
    <tr>
        <td valign="middle">
            Address:
        </td>
        <td colspan="4" valign="middle">
            <asp:TextBox ID="Txt_Address" runat="server" CssClass="clsTextArea" Height="60px"
                MaxLength="100" TextMode="MultiLine" Width="400px"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td valign="middle">
            City:
        </td>
        <td valign="middle">
            <asp:TextBox ID="Txt_City" runat="server" CssClass="clsTextbox" Width="200px"></asp:TextBox>
        </td>
        <td colspan="1" valign="middle">
        </td>
        <td colspan="1" valign="middle">
            Province / State:
        </td>
        <td colspan="1" valign="middle">
            <asp:DropDownList ID="Cbo_State" runat="server" CssClass="clsTextbox" Width="205px">
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td valign="middle">
            Postal / Zip Code:
        </td>
        <td valign="middle">
            <asp:TextBox ID="Txt_ZipCode" runat="server" CssClass="clsTextbox" Width="200px"></asp:TextBox>
        </td>
        <td colspan="1" valign="middle">
        </td>
        <td colspan="1" valign="middle">
            Country:
        </td>
        <td colspan="1" valign="middle">
            <asp:DropDownList ID="Cbo_Country" runat="server" CssClass="clsTextbox"
                Width="205px">
            </asp:DropDownList>
        </td>
    </tr>
    </table>
</div>