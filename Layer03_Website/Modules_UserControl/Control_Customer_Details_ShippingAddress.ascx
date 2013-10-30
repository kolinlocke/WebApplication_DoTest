﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Control_Customer_Details_ShippingAddress.ascx.cs" Inherits="Layer03_Website.Modules_UserControl.Control_Customer_Details_ShippingAddress" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="~/Modules_UserControl/Control_Address.ascx"  TagPrefix="Uc" TagName="Address_ShippingAddress" %>

<script type="text/javascript" src="../Scripts/Js_Common.js"></script>    
<script type="text/javascript">
    function ShippingAddress_Accept(dialog, arg) {
        eo_Callback("<%=this.EOCb_Accept.ClientID%>");
    }

    function EOCb_AE_Show(callback, output, extraData) {
        EOCb_AE();
        var EODialog = eo_GetObject('<%=this.EODialog_ShippingAddress.ClientID%>');
        EODialog.show(true);
    }

    function ShippingAddress_Cancel(dialog, arg) {
        eo_Callback("<%=this.EOCb_Cancel.ClientID%>");
    }

</script>

<eo:Dialog ID="EODialog_ShippingAddress" runat="server" AcceptButton="EODialog_Btn_Ok"
	BackColor="White" BackShadeColor="Black" BackShadeOpacity="10" CancelButton="EODialog_Btn_Cancel"
	ClientSideOnAccept="ShippingAddress_Accept" CloseButtonUrl="00020312" ControlSkinID="None"
	HeaderHtml="Shipping Address Details" Height="300px" Width="650px" 
    ClientSideOnCancel="ShippingAddress_Cancel">
	<FooterTemplate>
		<table style="width: 100%">
			<tr>
				<td align="right" class="clsDetails">
					<asp:Button ID="EODialog_Btn_Ok" runat="server" CssClass="clsButton" Text="Ok"
						Width="80px" />
					<asp:Button ID="EODialog_Btn_Cancel" runat="server" CssClass="clsButton"
						Text="Cancel" Width="80px" /></td>
			</tr>
		</table>
	</FooterTemplate>
	<HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;" />
	<BorderImages BottomBorder="00020305" BottomLeftCorner="00020304" BottomRightCorner="00020306"
		LeftBorder="00020303" RightBorder="00020307" TopBorder="00020310" TopLeftCorner="00020301"
		TopLeftCornerBottom="00020302" TopRightCorner="00020309" TopRightCornerBottom="00020308" />
	<FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma" />
	<ContentTemplate>
        <eo:CallbackPanel ID="EOCbp_Dialog_ShippingAddress" runat="server" 
            UpdateMode="Conditional" ClientSideAfterExecute="">
            <div>
                <table>
                    <tr>
                        <td style="width:100px;">
                            Store Code:
                        </td>
                        <td>
                            <asp:TextBox ID="Txt_StoreCode" runat="server" CssClass="clsTextbox" Width="200px"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <br />
                <Uc:Address_ShippingAddress ID="UcAddress_ShippingAddress" runat="server" />
            </div>    
        </eo:CallbackPanel>
	</ContentTemplate>
	<ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma" />
</eo:Dialog>
<eo:Callback ID="EOCb_Accept" runat="server" ClientSideBeforeExecute="EOCb_BE" ClientSideAfterExecute="EOCb_AE">
</eo:Callback>
<eo:Callback ID="EOCb_Cancel" runat="server" ClientSideBeforeExecute="EOCb_BE" ClientSideAfterExecute="EOCb_AE">
</eo:Callback>

