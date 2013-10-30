<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Control_FileBrowser.ascx.cs" Inherits="Layer03_Website.Modules_UserControl.Control_FileBrowser" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>

<script type="text/javascript" src="../Scripts/Js_Common.js"></script>    
<script type="text/javascript">

    function Selection_Accept(dialog, arg) {
        var SelectedFile = eo_GetObject('<%=this.FileExplorerHolder1.ClientID%>').getSelectedFile();
        eo_Callback('<%=this.EOCb_Accept.ClientID%>', SelectedFile);
    }

</script>

<eo:CallbackPanel ID="EOCbp_BrowseFile" runat="server" Triggers="" 
    LoadingDialogID="" UpdateMode="Conditional">
    <eo:Dialog ID="EODialog_BrowseFile" runat="server" BackColor="White"
        CloseButtonUrl="00020312" ControlSkinID="None" HeaderHtml="Browse File" 
        Height="216px" Width="320px" BackShadeColor="Black" BackShadeOpacity="10" 
        AcceptButton="Button1" CancelButton="Button2">
        <HeaderStyleActive CssText="background-image:url('00020311');color:black;font-family:'trebuchet ms';font-size:10pt;font-weight:bold;padding-bottom:5px;padding-left:8px;padding-right:3px;padding-top:0px;" />
        <BorderImages BottomBorder="00020305" BottomLeftCorner="00020304" BottomRightCorner="00020306"
            LeftBorder="00020303" RightBorder="00020307" TopBorder="00020310" TopLeftCorner="00020301"
            TopLeftCornerBottom="00020302" TopRightCorner="00020309" TopRightCornerBottom="00020308" />
        <FooterStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma" />
        <ContentTemplate>
            <eo:FileExplorerHolder ID="FileExplorerHolder1" runat="server" Url="" Height="360px" Width="714px">
            </eo:FileExplorerHolder>
            <div style="padding-right: 20px; text-align: right">
                <asp:Button ID="Button1" runat="server" Text="OK" Width="80px" CssClass="clsButton" />
                &nbsp;
                <asp:Button ID="Button2" runat="server" Text="Cancel" Width="80px" CssClass="clsButton" />
            </div>
        </ContentTemplate>
        <ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma" />
    </eo:Dialog>
</eo:CallbackPanel>
<eo:Callback ID="EOCb_Accept" runat="server" 
    ClientSideBeforeExecute="EOCb_BE" 
    ClientSideAfterExecute="EOCb_AE_Eval">
</eo:Callback>
