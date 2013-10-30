<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Control_Selection.ascx.cs" Inherits="Layer03_Website.Modules_UserControl.Control_Selection" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>

<script type="text/javascript" src="../Scripts/Js_Common.js"></script>    
<script type="text/javascript">

    function Selection_Accept(dialog, arg) {

        EOCb_BE_Selection();
        var Grid = eo_GetObject('<%=this.EOGrid_Selection.ClientID%>');
        var Gi = Grid.getSelectedItem();
        var Key = Gi.getKey();
        eo_Callback("<%=this.EOCb_Accept.ClientID%>", Key);
    }

    function EOCb_BE_Selection(callback) {
        EOCb_BE();
        var Grid = eo_GetObject('<%=this.EOGrid_Selection.ClientID%>');
        var Gc_IsSelect = Grid.getColumn('IsSelect');
        var NoItems = Grid.getItemCount();
        var Ct = 0;
        var Selected = ''
        var Comma = ''

        for (Ct = 0; Ct <= (NoItems - 1); Ct++) {
            var Gi = Grid.getItem(Ct);

            var Gcl = Gi.getCell(Gc_IsSelect.getOriginalIndex());
            var IsSelect = Gcl.getValue();

            var Key = Gi.getKey();
            Selected = Selected + Comma + Key + ',' + IsSelect
            Comma = ','
        }

        document.getElementById("<%=this.Hid_Selected.ClientID%>").value = Selected
    }

</script>
<eo:CallbackPanel ID="EOCbp_EODialog_Selection" runat="server" UpdateMode="Conditional">
	<eo:Dialog ID="EODialog_Selection" runat="server" 
        AcceptButton="EODialog_Selection_Btn_Ok"
		BackColor="White" BackShadeColor="Black" BackShadeOpacity="10" CancelButton="EODialog_Selection_Btn_Cancel"
		ClientSideOnAccept="Selection_AcceptClicked" CloseButtonUrl="00020312" ControlSkinID="None"
		HeaderHtml="Selection Title" Height="300px" Width="850px">
		<FooterTemplate>
			<table style="width: 100%">
				<tr>
					<td align="right" class="clsDetails">
						<asp:Button ID="EODialog_Selection_Btn_Ok" runat="server" CssClass="clsButton" Text="Ok"
							Width="80px" />
						<asp:Button ID="EODialog_Selection_Btn_Cancel" runat="server" CssClass="clsButton"
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
	    	<div class="clsDetails">
				<div>
					<table>
						<tr>
							<td valign="middle" style="width:60px">
								Search:&nbsp;
							</td>
							<td valign="middle" colspan="2">
								<asp:TextBox ID="Txt_Search" runat="server" CssClass="clsTextbox" Width="200px"></asp:TextBox>
							</td>                    
							<td valign="middle" colspan="2">
								<asp:DropDownList ID="Cbo_SearchFilter" runat="server" Width="150px"></asp:DropDownList>
							</td>                    
						</tr>
						<tr>
							<td valign="middle">
								Top:&nbsp;
							</td>
							<td valign="middle">
								<asp:TextBox ID="Txt_Top" runat="server" Width="120px"></asp:TextBox>
							</td>                    
							<td valign="middle">
								Page:</td>                    
							<td valign="middle">
							    <eo:CallbackPanel ID="EOCb_Cbo_Page" runat="server" UpdateMode="Conditional">
								    <asp:DropDownList ID="Cbo_Page" runat="server" Width="150px">
								    </asp:DropDownList>
							    </eo:CallbackPanel>
							</td>                    
							<td valign="middle">
								<asp:Button ID="Btn_Page" runat="server" Text="Go to Page" CssClass="clsButton" Width="110px" />
							</td>                    
						</tr>
						<tr>
							<td colspan="5">
								<asp:Button ID="Btn_NewSearch" runat="server" CssClass="clsButton" 
									Text="New Search" Width="110px" EnableViewState="False" />
								<asp:Button ID="Btn_AddSearch" runat="server" CssClass="clsButton" 
									Text="Add Search" Width="110px" EnableViewState="False" />
								<asp:Button ID="Btn_SortAsc" runat="server" CssClass="clsButton" 
									Text="Sort Ascending" Width="110px" EnableViewState="False" />
								<asp:Button ID="Btn_SortDesc" runat="server" CssClass="clsButton" 
									Text="Sort Descending" Width="120px" EnableViewState="False" />
								<asp:Button ID="Btn_Clear" runat="server" CssClass="clsButton" Text="Clear" 
									Width="110px" EnableViewState="False" />
							</td>
						</tr>
						<tr>
							<td colspan="5">
								<asp:Panel ID="Panel_Check" runat="server">
									<asp:Button ID="Btn_CheckAll" runat="server" CssClass="clsButton" Text="Check All" Width="110px" EnableViewState="False" />
									<asp:Button ID="Btn_UncheckAll" runat="server" CssClass="clsButton" Text="Uncheck All" Width="110px" EnableViewState="False" />
								</asp:Panel>
							 </td>   
						</tr>
					</table>
				</div>
				<div>
					<table style="width: 100%">
						<tr>
							<td valign="top" style="width: 200px">
								<eo:CallbackPanel ID="EOCbp_Applied" runat="server" EnableViewState="False" UpdateMode="Conditional">
									<asp:Panel ID="Panel_Applied" runat="server" Height="300px" Width="250px" ScrollBars="Vertical">
										<asp:Label ID="Lbl_AppliedFilters" runat="server"></asp:Label>
									</asp:Panel>
								</eo:CallbackPanel>
							</td>
							<td>
								<eo:CallbackPanel ID="EOCbp_EOGrid_Selection" runat="server" LoadingDialogID=""
									Triggers=""
									UpdateMode="Conditional" Width="100%" 
									>
									<eo:Grid ID="EOGrid_Selection" runat="server" BorderColor="#828790"
										BorderWidth="1px" ColumnHeaderAscImage="00050204" ColumnHeaderDescImage="00050205"
										ColumnHeaderDividerImage="00050203" ColumnHeaderHeight="24" FixedColumnCount="1"
										Font-Bold="False" Font-Italic="False" Font-Names="Tahoma" Font-Overline="False"
										Font-Size="8.75pt" Font-Strikeout="False" Font-Underline="False" GridLineColor="240, 240, 240"
										GridLines="Both" Height="300px" ItemHeight="21" Width="100%" 
										EnableViewState="False">
										<FooterStyle CssText="padding-bottom:4px;padding-left:4px;padding-right:4px;padding-top:4px;" />
										<ItemStyles>
											<eo:GridItemStyleSet>
												<ItemStyle CssText="background-color: white" />
												<ItemHoverStyle CssText="background-image: url(00050206); background-repeat: repeat-x" />
												<SelectedStyle CssText="background-image: url(00050207); background-repeat: repeat-x" />
												<CellStyle CssText="padding-left:8px;padding-top:2px;white-space:nowrap;" />
											</eo:GridItemStyleSet>
										</ItemStyles>
										<ColumnTemplates>
											<eo:TextBoxColumn>
												<TextBoxStyle CssText="BORDER-RIGHT: #7f9db9 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7f9db9 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 8.75pt; PADDING-BOTTOM: 1px; MARGIN: 0px; BORDER-LEFT: #7f9db9 1px solid; PADDING-TOP: 2px; BORDER-BOTTOM: #7f9db9 1px solid; FONT-FAMILY: Tahoma" />
											</eo:TextBoxColumn>
										</ColumnTemplates>
										<ColumnHeaderHoverStyle CssText="background-image:url('00050202');padding-left:8px;padding-top:4px;" />
										<Columns>
											<eo:RowNumberColumn>
											</eo:RowNumberColumn>
										</Columns>
										<ColumnHeaderStyle CssText="background-image:url('00050201');padding-left:8px;padding-top:4px;" />
									</eo:Grid>
								</eo:CallbackPanel>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<eo:Callback ID="EOCb_Search" runat="server"
				ClientSideAfterExecute="EOCb_AE" 
				ClientSideBeforeExecute="EOCb_BE_Selection">
			</eo:Callback>
		</ContentTemplate>
		<ContentStyleActive CssText="padding-right: 4px; padding-left: 4px; font-size: 8pt; padding-bottom: 4px; padding-top: 4px; font-family: tahoma" />
	</eo:Dialog>
</eo:CallbackPanel>
<asp:HiddenField ID="Hid_Selected" runat="server" />
<eo:Callback ID="EOCb_Accept" runat="server" 
    ClientSideBeforeExecute="EOCb_BE" 
    ClientSideAfterExecute="EOCb_AE_Eval">
</eo:Callback>

