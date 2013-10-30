<%@ Page Title="" Language="C#" MasterPageFile="~/Modules_Master/Master_Details.master" AutoEventWireup="false" CodeBehind="Page_Customer_Details.aspx.cs" Inherits="Layer03_Website.Modules_Page.Page_Customer_Details" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="~/Modules_UserControl/Control_Person.ascx" TagPrefix="Uc" TagName="Person" %>
<%@ Register Src="~/Modules_UserControl/Control_Address.ascx"  TagPrefix="Uc" TagName="Address" %>
<%@ Register Src="~/Modules_UserControl/Control_Grid.ascx"  TagPrefix="Uc" TagName="Grid" %>
<%@ Register Src="~/Modules_UserControl/Control_Selection.ascx" TagPrefix="Uc" TagName="Selection" %>
<%@ Register Src="~/Modules_UserControl/Control_Customer_Details_ShippingAddress.ascx"  TagPrefix="Uc" TagName="Cdsa" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder_Buttons_Top" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_Details" Runat="Server">
    <script type="text/javascript">

        function EOGrid_ItemCommand(grid, itemIndex, colIndex, commandName) {
            switch (commandName) {
                case "CustomerLogs_Select":
                    break;

                case "ShippingAddress_Edit":
                    //var Cell = grid.getSelectedCell();
                    var Item = grid.getSelectedItem();
                    var Key = Item.getKey();
                    eo_Callback("EOCb_ShippingAddress_Edit", Key);
                    break;
            }
        }

        function EOGrid_ShippingAddress_IsActive(cell, newValue) {
            RequireSave();

            var item = cell.getItem()
            var key = item.getKey()
            eo_Callback("EOCb_ShippingAddress_IsActive", key);

            return cell.getValue();
        }

    </script>
    <eo:Callback ID="EOCb_Selection" runat="server" 
        ClientSideAfterExecute="EOCb_AE_Eval" ClientSideBeforeExecute="EOCb_BE" 
        Triggers="{ControlID:Btn_SalesPerson;Parameter:Btn_SalesPerson}" 
        ClientSideOnError="EOControl_ErrorHandler">
    </eo:Callback>
    <eo:Callback ID="EOCb_TaxCode" runat="server" 
        ClientSideAfterExecute="EOCb_AE_Eval" 
        ClientSideBeforeExecute="EOCb_BE" 
        ClientSideOnError="EOControl_ErrorHandler" 
        Triggers="{ControlID:Cbo_TaxCode;Parameter:Cbo_TaxCode}">
    </eo:Callback>
    <eo:Callback ID="EOCb_ShippingAddress_Add" runat="server" 
        ClientSideAfterExecute="EOCb_AE_Eval" 
        ClientSideBeforeExecute="EOCb_BE"
        ClientSideOnError="EOControl_ErrorHandler"        
        Triggers="{ControlID:Btn_AddShippingAddress;Parameter:Btn_AddShippingAddress}">
    </eo:Callback>
    <eo:Callback ID="EOCb_ShippingAddress_Edit" runat="server"
        ClientSideAfterExecute="EOCb_AE_Eval" 
        ClientSideBeforeExecute="EOCb_BE"
        ClientSideOnError="EOControl_ErrorHandler">
    </eo:Callback>
    <eo:Callback ID="EOCb_ShippingAddress_IsActive" runat="server"
        ClientSideAfterExecute="EOCb_AE" 
        ClientSideBeforeExecute="EOCb_BE"
        ClientSideOnError="EOControl_ErrorHandler">
    </eo:Callback>
    <eo:Callback ID="EOCb_ShippingAddress_Update" runat="server"
        ClientSideAfterExecute="EOCb_AE" 
        ClientSideBeforeExecute="EOCb_BE" 
        ClientSideOnError="EOControl_ErrorHandler"
        Triggers="{ControlID:Btn_UpdateShippingAddress;Parameter:Btn_UpdateShippingAddress}">
    </eo:Callback>
    <Uc:Cdsa ID="UcCdsa" runat="server" />
    <uc:selection ID="UcSelection" runat="server" />
    <div>
        <table>
            <tr>
                <td style="width:120px" valign="middle">
                    Customer ID:
                </td>
                <td valign="middle">
                    <asp:TextBox ID="Txt_Code" runat="server" Width="200px" CssClass="clsTextbox"></asp:TextBox>                    
                </td>
            </tr>            
        </table>
    </div>
    <br />
    <div>
        <table>
            <tr>
                <td style="width:120px; height:25px" valign="middle">
                    Company:
                </td>
                <td style="width:500px;" valign="middle">
                    <asp:TextBox ID="Txt_Company" runat="server" Width="200px" CssClass="clsTextbox"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="height:25px" valign="middle">
                    <asp:LinkButton ID="Btn_SalesPerson" runat="server">Sales Person:</asp:LinkButton>
                </td>
                <td valign="middle">                    
                    <asp:Label ID="Lbl_SalesPerson" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="height:25px" valign="middle">
                    Client Type:
                </td>
                <td valign="middle">
                    <asp:DropDownList ID="Cbo_ClientType" runat="server" Width="205px"></asp:DropDownList>
                </td>
            </tr>
        </table>
    </div>
    <br />
    <div>
        <Uc:Person runat="server" ID="UcPerson" />
        <Uc:Address runat="server" ID="UcAddress" />
        <br />
        <asp:Button ID="Btn_UpdateShippingAddress" runat="server" 
            Text="Update Shipping Address" CssClass="clsButton" Width="200px" />
    </div>
    <br />
    <center>
        <div align="center" style="width:98%";>
            <eo:TabStrip ID="EOTab_Details" runat="server" ControlSkinID="None" Width="100%" MultiPageID="EOMp_Details">
                <LookItems>
                    <eo:TabItem Image-BackgroundRepeat="RepeatX" Image-Mode="TextBackground" 
                        Image-SelectedUrl="00010225" Image-Url="00010222" ItemID="_Default" 
                        LeftIcon-SelectedUrl="00010224" LeftIcon-Url="00010221" 
                        NormalStyle-CssText="color: #606060" RightIcon-SelectedUrl="00010226" 
                        RightIcon-Url="00010223" 
                        SelectedStyle-CssText="color: #2f4761; font-weight: bold;">
                        <SubGroup OverlapDepth="8" 
                            Style-CssText="font-family: tahoma; font-size: 8pt; background-image: url(00010220); background-repeat: repeat-x; cursor: hand;">
                        </SubGroup>
                    </eo:TabItem>
                </LookItems>
                <TopGroup>
                    <Items>
                        <eo:TabItem Text-Html="Financial Information">
                        </eo:TabItem>
                        <eo:TabItem Text-Html="Shipping Address">
                        </eo:TabItem>
                    </Items>
                </TopGroup>
            </eo:TabStrip>
            <div style="width:100%">
                <table width="100%" class="clsTabTable">
                    <tr>
                        <td>
                            <eo:MultiPage ID="EOMp_Details" runat="server" Width='100%'>
                                <eo:PageView ID="EOPv_FinancialInfo" runat="server" Width="100%">
                                    <div style="width:100%;">
                                        <table cellspacing="0">
                                            <tr align="left">
                                                <td valign="middle" style="width: 120px">
                                                    Payment Term:
                                                </td>
                                                <td valign="middle" style="width: 220px">
                                                    <asp:DropDownList ID="Cbo_PaymentTerm" runat="server" CssClass="clsTextbox" Width="205px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 20px" valign="middle">
                                                </td>
                                                <td valign="middle" style="width: 120px">
                                                    Ship Via:
                                                </td>
                                                <td valign="middle" style="width: 220px">
                                                    <asp:DropDownList ID="Cbo_ShipVia" runat="server" CssClass="clsTextbox" Width="205px" Visible="False" />
                                                </td>
                                            </tr>
                                            <tr align="left">
                                                <td valign="middle">
                                                    Account Name:
                                                </td>
                                                <td valign="middle">
                                                    <asp:TextBox ID="Txt_CreditCard_AccountName" runat="server" CssClass="clsTextbox" Width="200px" />
                                                </td>
                                            </tr>
                                            <tr align="left">
                                                <td valign="middle">
                                                    Credit Card:
                                                </td>
                                                <td valign="middle">
                                                    <table cellspacing="0">
                                                        <tr>
                                                            <td valign="middle">
                                                                <asp:TextBox ID="Txt_CreditCard_Part1" runat="server" CssClass="clsTextbox" MaxLength="4" Width="35px"></asp:TextBox>
                                                            </td>
                                                            <td valign="middle" align="center">
                                                                -
                                                            </td>
                                                            <td valign="middle">
                                                                <asp:TextBox ID="Txt_CreditCard_Part2" runat="server" CssClass="clsTextbox" MaxLength="4" Width="35px"></asp:TextBox>
                                                            </td>
                                                            <td valign="middle" align="center">
                                                                -
                                                            </td>
                                                            <td valign="middle">
                                                                <asp:TextBox ID="Txt_CreditCard_Part3" runat="server" CssClass="clsTextbox" MaxLength="4" Width="35px"></asp:TextBox>
                                                            </td>
                                                            <td valign="middle" align="center">
                                                                -
                                                            </td>
                                                            <td valign="middle">
                                                                <asp:TextBox ID="Txt_CreditCard_Part4" runat="server" CssClass="clsTextbox" MaxLength="4" Width="35px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td valign="middle">
                                                </td>
                                                <td valign="middle">
                                                    Credit Limit:
                                                </td>
                                                <td valign="middle">
                                                    <asp:TextBox ID="Txt_CreditLimit" runat="server" CssClass="clsTextbox" MaxLength="5" Width="200px" Enabled="False"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr align="left">
                                                <td valign="middle">
                                                    <asp:Label ID="Lbl_ExpiryDate" runat="server" Text="Expiry Date:"></asp:Label></td>
                                                <td valign="middle">
                                                    <asp:TextBox ID="Txt_CreditCardExpiration_Month" runat="server" CssClass="clsTextbox" MaxLength="2" Width="30px"></asp:TextBox>
                                                    <asp:TextBox ID="Txt_CreditCardExpiration_Year" runat="server" CssClass="clsTextbox" MaxLength="2" TabIndex="24" Width="30px"></asp:TextBox>
                                                </td>
                                                <td valign="middle">
                                                </td>
                                                <td valign="middle">
                                                    Credit Card CVV:
                                                </td>
                                                <td valign="middle">
                                                    <asp:TextBox ID="Txt_CreditCard_CVV" runat="server" CssClass="clsTextbox" Width="200px" MaxLength="6"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr align="left">
                                                <td valign="middle" colspan="3">
                                                </td>
                                                <td valign="middle">
                                                    Credit Hold:
                                                </td>
                                                <td style="height: 10px" valign="middle">
                                                    <asp:CheckBox ID="Chk_IsCreditHold" runat="server" TextAlign="Left" />
                                                </td>
                                            </tr>
                                            <tr align="left">
                                                <td colspan="5" valign="middle">
                                                </td>
                                            </tr>
                                            <tr align="left">
                                                <td valign="middle">
                                                    Currency:
                                                </td>
                                                <td valign="middle">
                                                    <asp:DropDownList ID="Cbo_Currency" runat="server" CssClass="clsTextbox" Width="205px"></asp:DropDownList>
                                                </td>
                                                <td class="clsDetails" valign="middle">
                                                </td>
                                                <td valign="middle">
                                                    Balance:
                                                </td>
                                                <td valign="middle">
                                                    <asp:TextBox ID="Txt_Balance" runat="server" CssClass="clsTextbox" Width="200px" ReadOnly="True"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr align="left">
                                                <td valign="middle">
                                                    <br />
                                                    <br />
                                                </td>
                                            </tr>
                                            <tr align="left">
                                                <td valign="middle">
                                                    Tax Code:
                                                </td>
                                                <td valign="middle">
                                                    <asp:DropDownList ID="Cbo_TaxCode" runat="server" CssClass="clsTextbox" Width="205px" AutoPostBack="True" TabIndex="28">
                                                    </asp:DropDownList>
                                                </td>                            
                                            </tr>
                                            <tr align="left">
                                                <td colspan="5" valign="middle">
                                                    <br />
                                                    <table cellspacing="3">
                                                        <tr>
                                                            <td valign="middle" style="width: 40px">
                                                                HST:
                                                            </td>
                                                            <td valign="middle">
                                                                <asp:Label ID="Lbl_HST_Value" runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="middle">
                                                                PST:
                                                            </td>
                                                            <td valign="middle">
                                                                <asp:Label ID="Lbl_PST_Value" runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="middle">
                                                                GST:
                                                            </td>
                                                            <td valign="middle">
                                                                <asp:Label ID="Lbl_GST_Value" runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </eo:PageView>
                                <eo:PageView ID="EOPv_ShippingAddress" runat="server" Width="100%">
                                    <table style="width:100%;">
                                        <tr>
                                            <td align="right">
                                                <asp:Button ID="Btn_AddShippingAddress" runat="server" Text="Add" CssClass="clsButton" Width="80px" />
                                            </td>
                                        </tr>
                                    </table>
                                    <Uc:Grid ID="UcGrid_ShippingAddress" runat="server" />
                                </eo:PageView>
                            </eo:MultiPage>
                        </td>
                    </tr>
                </table>                        
            </div>
        </div>
    </center>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder_Buttons_Bottom" Runat="Server">
</asp:Content>

