<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Control_Grid.ascx.cs" Inherits="Layer03_Website.Modules_UserControl.Control_Grid" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>

<script type="text/javascript" src="../Scripts/Js_ModuleRequired.js" ></script>

<div>
	<table style="width: 100%">
		<tr>
			<td>
				<eo:CallbackPanel ID="EOCbp_EOGrid" runat="server" LoadingDialogID=""
					Triggers=""
					UpdateMode="Conditional" Width="100%" 
					ClientSideBeforeExecute="">
					<eo:Grid ID="EOGrid_List" runat="server" BorderColor="#828790"
						BorderWidth="1px" ColumnHeaderAscImage="00050204" ColumnHeaderDescImage="00050205"
						ColumnHeaderDividerImage="00050203" ColumnHeaderHeight="24" FixedColumnCount="1"
						Font-Bold="False" Font-Italic="False" Font-Names="Tahoma" Font-Overline="False"
						Font-Size="8.75pt" Font-Strikeout="False" Font-Underline="False" GridLineColor="240, 240, 240"
						GridLines="Both" Height="300px" ItemHeight="21" Width="100%">
						<FooterStyle CssText="padding-bottom:4px;padding-left:4px;padding-right:4px;padding-top:4px;" />
						<ItemStyles>
							<eo:GridItemStyleSet>
								<ItemStyle CssText="background-color: white" />
								<ItemHoverStyle CssText="background-image: url(00050206); background-repeat: repeat-x" />
								<SelectedStyle CssText="background-image: url(00050207); background-repeat: repeat-x" />
								<CellStyle CssText="padding-left:8px;padding-top:2px;white-space:nowrap;" />
							</eo:GridItemStyleSet>
                            <eo:GridItemStyleSet StyleSetID="_ItemError">
                                <ItemStyle CssText="background-color:maroon;color:white;" />
                                <SelectedStyle CssText="border-bottom-color:tomato;border-left-color:tomato;border-right-color:tomato;border-top-color:tomato;color:white;" />
                                <CellStyle CssText="padding-left:8px;padding-top:2px;" />
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