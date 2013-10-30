<%@ Page Title="" Language="C#" MasterPageFile="~/Modules_Master/Master_Details.master" AutoEventWireup="true" CodeBehind="Page_Item_Details.aspx.cs" Inherits="Layer03_Website.Modules_Page.Page_Item_Details" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="~/Modules_UserControl/Control_FileBrowser.ascx" TagPrefix="Uc" TagName="FileBrowser" %>
<%@ Register Src="~/Modules_UserControl/Control_Grid.ascx"  TagPrefix="Uc" TagName="Grid" %>
<%@ Register Src="~/Modules_UserControl/Control_Selection.ascx" TagPrefix="Uc" TagName="Selection" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder_Buttons_Top" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_Details" runat="server">
    <div>
        <table>
            <tr>
                <td style="width: 100px" valign="middle">
                    Item No:
                </td>
                <td valign="middle">
                    <asp:TextBox ID="Txt_ItemCode" runat="server" Width="200px" 
                        CssClass="clsTextbox" TabIndex="2"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="width: 100px" valign="middle">
                    Item Name:
                </td>
                <td valign="middle">
                    <asp:TextBox ID="Txt_ItemName" runat="server" CssClass="clsTextbox" Width="200px" TabIndex="3"></asp:TextBox>
                </td>
            </tr>
        </table>
    </div>
    <br />
    <div>
        <table>
			<tr>
				<td style="width: 100px" valign="middle">
                    Item Category:
                </td>
				<td colspan="1" valign="middle" style="width: 220px">
					<asp:DropDownList ID="Cbo_Category" runat="server" CssClass="clsTextbox"
						Width="205px" TabIndex="5">
					</asp:DropDownList>
                </td>
				<td colspan="1" style="width: 20px" valign="middle">
				</td>
				<td colspan="1" valign="middle" style="width: 100px">
                    Is Serializable?
                </td>
				<td colspan="1" valign="middle" style="width: 220px">
					<asp:CheckBox ID="Chk_IsSerial" runat="server" TabIndex="6" />
                </td>
			</tr>
			<tr>
				<td valign="middle">
                    Item Type:
                </td>
				<td colspan="1" valign="middle"><asp:DropDownList ID="Cbo_ItemType" runat="server" CssClass="clsTextbox"
						Width="205px" TabIndex="5">
				</asp:DropDownList></td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
                    Item UOM:
                </td>
				<td colspan="1" valign="middle">
					<asp:DropDownList ID="Cbo_ItemUOM" runat="server" CssClass="clsTextbox"
						Width="205px" TabIndex="6">
					</asp:DropDownList></td>
			</tr>
			<tr>
				<td valign="middle">
					<asp:Label ID="Label8" runat="server" Text="Item Brand:"></asp:Label></td>
				<td colspan="1" valign="middle">
					<asp:DropDownList ID="Cbo_Brand" runat="server" CssClass="clsTextbox"
						Width="205px" TabIndex="5">
					</asp:DropDownList></td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
                    Length:
                </td>
				<td colspan="1" valign="middle">
					<asp:TextBox ID="Txt_Length" runat="server" CssClass="clsTextbox" Width="200px" TabIndex="6"></asp:TextBox>
                </td>
			</tr>
			<tr>
				<td valign="middle">
                    Item Retailer:
                </td>
				<td colspan="1" valign="middle">
					<asp:DropDownList ID="Cbo_Retailer" runat="server" CssClass="clsTextbox"
						Width="205px" TabIndex="5">
					</asp:DropDownList></td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
                    Height:					
                </td>
				<td colspan="1" valign="middle">
					<asp:TextBox ID="Txt_Height" runat="server" CssClass="clsTextbox" Width="200px" TabIndex="6"></asp:TextBox>
                </td>
			</tr>
			<tr>
				<td valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
                    Width:
                </td>
				<td colspan="1" valign="middle">
					<asp:TextBox ID="Txt_Width" runat="server" CssClass="clsTextbox" Width="200px" TabIndex="6"></asp:TextBox>
                </td>
			</tr>
			<tr>
				<td valign="middle">
                    Current Cost:
                </td>
				<td colspan="1" valign="middle">
					<eo:CallbackPanel ID="EOCb_EstimatedCost" runat="server" LoadingDialogID="EODialog_Loader"
						UpdateMode="Conditional">
					<asp:TextBox ID="Txt_EstimatedCost" runat="server" CssClass="clsTextbox" TabIndex="14"
						Width="200px"></asp:TextBox></eo:CallbackPanel>
				</td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
                    Weight:					
                </td>
				<td colspan="1" valign="middle">
					<asp:TextBox ID="Txt_Weight" runat="server" CssClass="clsTextbox" Width="200px" TabIndex="6"></asp:TextBox>
                </td>
			</tr>
			<tr>
				<td valign="middle">
                    List Price:
                </td>
				<td colspan="1" valign="middle">
					<eo:CallbackPanel ID="EOCb_ListPrice" runat="server" LoadingDialogID="EODialog_Loader"
						UpdateMode="Conditional">
					<asp:TextBox ID="Txt_ListPrice" runat="server" CssClass="clsTextbox" TabIndex="14"
						Width="200px"></asp:TextBox></eo:CallbackPanel>
				</td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
                </td>
				<td colspan="1" valign="middle">
                </td>
			</tr>
			<tr>
				<td valign="middle">
				</td>
				<td colspan="1" valign="middle">
					&nbsp;</td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
			</tr>
			<tr>
				<td valign="middle">
					<br />
				</td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
			</tr>
			<tr>
				<td valign="middle">
                    Floor Level:
                </td>
				<td colspan="1" valign="middle">
					<asp:TextBox ID="Txt_FloorLevel" runat="server" CssClass="clsTextbox" Style="text-align: right" Width="200px" MaxLength="20" TabIndex="16"></asp:TextBox></td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
			</tr>
			<tr>
				<td valign="middle">
                    Ceiling Level:
                </td>
				<td colspan="1" valign="middle">
					<asp:TextBox ID="Txt_CeilingLevel" runat="server" CssClass="clsTextbox" Style="text-align: right" Width="200px" MaxLength="20" TabIndex="17"></asp:TextBox></td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
			</tr>
			<tr>
				<td valign="middle">
                    Reorder Level:
                </td>
				<td colspan="1" valign="middle">
					<asp:TextBox ID="Txt_ReorderLevel" runat="server" CssClass="clsTextbox" Style="text-align: right" Width="200px" MaxLength="20" TabIndex="18"></asp:TextBox></td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
			</tr>
			<tr>
				<td valign="middle">
					<br />
				</td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
				<td colspan="1" valign="middle">
				</td>
			</tr>
			<tr>
				<td valign="middle">
                    Warranty:
                </td>
				<td colspan="4" valign="middle">
					<asp:TextBox ID="Txt_Warranty" runat="server" CssClass="clsTextArea" Height="40px"
						MaxLength="500" TextMode="MultiLine" Width="400px" TabIndex="19"></asp:TextBox></td>
			</tr>
			<tr>
				<td style="width: 100px" valign="middle">
                    Remarks:
                </td>
				<td colspan="4" valign="middle">
					<asp:TextBox ID="Txt_Remarks" runat="server" CssClass="clsTextArea"
						TextMode="MultiLine" Width="400px" Height="40px" MaxLength="500" TabIndex="20"></asp:TextBox>
                </td>
			</tr>
			<tr>
				<td valign="middle">
					<br />
				</td>
				<td colspan="4" valign="middle">
				</td>
			</tr>
			<tr>
				<td valign="middle">
                    PDF Manual:
                </td>
				<td colspan="4" valign="middle">
					<eo:CallbackPanel ID="EOCbp_PdfDesc" runat="server" 
                        LoadingDialogID="" UpdateMode="Conditional">
					    <asp:LinkButton ID="Btn_PdfDesc" runat="server" Text="View PDF" TabIndex="20"></asp:LinkButton>
                        &nbsp;
					    <asp:LinkButton ID="Btn_PdfDesc_Upload" runat="server" Text="Upload" TabIndex="20"></asp:LinkButton>
                    </eo:CallbackPanel>
				</td>
			</tr>
			<tr>
				<td valign="middle">
                    PDF FAQ:
                </td>
				<td colspan="4" valign="middle">
					<eo:CallbackPanel ID="EOCbp_PdfFaq" runat="server" 
                        LoadingDialogID="" UpdateMode="Conditional">
					    <asp:LinkButton ID="Btn_PdfFaq" runat="server" Text="View PDF" TabIndex="20"></asp:LinkButton>
                        &nbsp;
					    <asp:LinkButton ID="Btn_PdfFaq_Upload" runat="server" Text="Upload" TabIndex="20"></asp:LinkButton>
                    </eo:CallbackPanel>
				</td>
			</tr>
			<tr>
				<td valign="middle">
                    Other PDFs:
                </td>
				<td colspan="4" valign="middle">
                    <eo:CallbackPanel ID="EOCbp_PdfOther" runat="server" 
                        LoadingDialogID="" UpdateMode="Conditional">
					    <asp:LinkButton ID="Btn_PdfOther" runat="server" Text="View PDF" TabIndex="20"></asp:LinkButton>
                        &nbsp;
					    <asp:LinkButton ID="Btn_PdfOther_Upload" runat="server" Text="Upload" TabIndex="20"></asp:LinkButton>
                    </eo:CallbackPanel>
				</td>
			</tr>
		</table>
    </div>
    <br />
    <div>
        <table>
            <tr>
                <td style="width: 100px">
                    Image:
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td>
                    <eo:CallbackPanel ID="EOCbp_Image" runat="server" LoadingDialogID="" 
                        UpdateMode="Conditional">
                    <asp:Image ID="Img_Box" runat="server" />
                        <br />
                    <asp:LinkButton ID="Btn_ViewImage" runat="server" TabIndex="20" Text="Click to view whole image"></asp:LinkButton></eo:CallbackPanel>
                    <br />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Button ID="Btn_Img" runat="server" Text="Browse" Width="80px" TabIndex="20" CssClass="clsButton" /></td>
            </tr>
        </table>
    </div>
    <br />
    <div>
		<eo:TabStrip ID="EOTab_Details" runat="server" ControlSkinID="None" MultiPageID="EOMp_Details" TabIndex="22">
			<LookItems>
				<eo:TabItem Image-BackgroundRepeat="RepeatX" Image-Mode="TextBackground" Image-SelectedUrl="00010225"
					Image-Url="00010222" ItemID="_Default" LeftIcon-SelectedUrl="00010224" LeftIcon-Url="00010221"
					NormalStyle-CssText="color: #606060" RightIcon-SelectedUrl="00010226" RightIcon-Url="00010223"
					SelectedStyle-CssText="color: #2f4761; font-weight: bold;">
					<SubGroup OverlapDepth="8" Style-CssText="font-family: tahoma; font-size: 8pt; background-image: url(00010220); background-repeat: repeat-x; cursor: hand;">
					</SubGroup>
				</eo:TabItem>
			</LookItems>
			<TopGroup>
				<Items>
					<eo:TabItem ItemID="EOTab_Details_OnHand" Text-Html="Inventory On Hand">
					</eo:TabItem>
					<eo:TabItem ItemID="EOTab_Details_ItemPart" Text-Html="Fits">
					</eo:TabItem>
					<eo:TabItem ItemID="EOTab_Details_Supplier" Text-Html="Supplier">
					</eo:TabItem>
					<eo:TabItem Text-Html="Bin Location">
					</eo:TabItem>
				</Items>
			</TopGroup>
		</eo:TabStrip>
		<table class="clsTabTable">
			<tr>
				<td>
					<eo:MultiPage ID="EOMp_Details" runat="server" Height="180px" Width="100%">
						<eo:PageView ID="EOPv_OnHand" runat="server" Width="100%">
							<Uc:Grid ID="UcGrid_OnHand" runat="server" EnableViewState="False" />
						</eo:PageView>
						<eo:PageView ID="EOPv_ItemPart" runat="server" Width="100%">
							<table style="width: 100%">
								<tr>
									<td align="right">
										<asp:Button ID="Btn_AddItemPart" runat="server" Text="Add New" Width="80px" CssClass="clsButton" />
                                    </td>
								</tr>
							</table>
							<Uc:Grid ID="UcGrid_ItemPart" runat="server" />
						</eo:PageView>
						<eo:PageView ID="EOPv_ItemSupplier" runat="server" Width="100%">
							<table style="width: 100%">
								<tr>
									<td align="right">
										<asp:Button ID="Btn_AddItemSupplier" runat="server" Text="Add New" Width="80px" CssClass="clsButton" />
                                    </td>
								</tr>
							</table>
							<Uc:Grid ID="UcGrid_ItemSupplier" runat="server" />
						</eo:PageView>
						<eo:PageView ID="EOPv_ItemLocation" runat="server" Width="100%">
							<table style="width: 100%">
								<tr>
									<td align="right">
										<asp:Button ID="Btn_AddItemLocation" runat="server" Text="Add New" Width="80px" CssClass="clsButton" /></td>
								</tr>
							</table>
                            <Uc:Grid ID="UcGrid_ItemLocation" runat="server" />
						</eo:PageView>
						<br />
					</eo:MultiPage>
				</td>
			</tr>
		</table>
	</div>
    <Uc:FileBrowser ID="UcFileBrowser" runat="server" />
    <eo:Callback ID="EOCb_Browse" runat="server"
        ClientSideAfterExecute="EOCb_AE" 
        ClientSideBeforeExecute="EOCb_BE">
    </eo:Callback>
    <eo:Callback ID="EOCb_View" runat="server"
        ClientSideAfterExecute="EOCb_AE_OpenWindow" 
        ClientSideBeforeExecute="EOCb_BE">
    </eo:Callback>
    <eo:Callback ID="EOCb_Image_Select" runat="server">
    </eo:Callback>
    <eo:Callback ID="EOCb_PdfDesc_Select" runat="server">
    </eo:Callback>
    <eo:Callback ID="EOCb_PdfFaq_Select" runat="server">
    </eo:Callback>
    <eo:Callback ID="EOCb_PdfOthers_Select" runat="server">
    </eo:Callback>    
    <eo:Callback ID="EOCb_Selection" runat="server" 
        ClientSideAfterExecute="EOCb_AE_Eval" 
        ClientSideBeforeExecute="EOCb_BE"
        ClientSideOnError="EOControl_ErrorHandler">
    </eo:Callback>
    <Uc:Selection ID="UcSelection" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder_Buttons_Bottom" runat="server">
</asp:Content>
