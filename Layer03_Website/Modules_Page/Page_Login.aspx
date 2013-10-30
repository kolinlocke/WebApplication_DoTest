<%@ Page Title="" Language="C#" MasterPageFile="~/Modules_Master/Main.Master" AutoEventWireup="true" CodeBehind="Page_Login.aspx.cs" Inherits="Layer03_Website.Modules_Page.Page_Login" %>
<%@ MasterType TypeName="Layer03_Website.Modules_Master.Main" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="
        position:relative;
        top:150px;
        width:350px;
        background-color:#FFFFFF;">
        <table style="width: 100%;" border="1">
            <tr>
                <td align="center">
                    <table>
                        <tr>
                            <td colspan="2">
                                <strong>
                                    Welcome.
                                </strong>
                            </td>            
                        </tr>
                        <tr>
                            <td align="left">
                                <strong>Username:</strong>
                            </td>
                            <td>
                                <asp:TextBox ID="Txt_Username" width="200px" runat="server" MaxLength="50"/>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <strong>
                                Password: 
                                </strong>
                            </td>
                            <td >
                                <asp:TextBox ID="Txt_Password" width="200px" runat="server" MaxLength="15" 
                                    TextMode="Password"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="1">
                                Forgot password?
                            </td>            
                            <td align="right" colspan="1" class="clsButton">
                                <asp:Button ID="Btn_Login" runat="server" Text="Login" CausesValidation="False" 
                                    Font-Names="Tahoma"/></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:Panel ID="Panel_Msg" runat="server" Visible="false">
                                    <strong>
                                        <asp:Label ID="Lbl_Msg" runat="server" Visible="false" ForeColor="Red" />
                                    </strong>
                                </asp:Panel>
                            </td>            
                        </tr>
                    </table>
               </td>
            </tr>
        </table>
    </div>
</asp:Content>
