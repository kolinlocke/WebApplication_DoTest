<%@ Page Title="" Language="C#" MasterPageFile="~/Modules_Master/Master_Details.master" AutoEventWireup="true" CodeBehind="Page_Employee_Details.aspx.cs" Inherits="Layer03_Website.Modules_Page.Page_Employee_Details" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>
<%@ Register Src="~/Modules_UserControl/Control_Person.ascx" TagPrefix="Uc" TagName="Person" %>
<%@ Register Src="~/Modules_UserControl/Control_Address.ascx"  TagPrefix="Uc" TagName="Address" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder_Buttons_Top" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder_Details" runat="server">
    <div>
        <table>
            <tr>
                <td style="width: 100px" valign="middle">
                    Employee ID:
                </td>
                <td valign="middle">
                    <asp:TextBox ID="Txt_EmployeeCode" runat="server" Width="200px" 
                        CssClass="clsTextbox"></asp:TextBox>
                </td>
            </tr>            
        </table>
    </div>
    <br />
    <div>
        <table>
            <tr>
                <td style="width: 100px" valign="middle">
                    Vacation:
                </td>
                <td valign="middle" colspan="">
                    <asp:TextBox ID="Txt_LeaveVacation" runat="server" CssClass="clsTextbox" Width="50px"></asp:TextBox>
                </td>
                <td colspan="" style="width: 20px" valign="middle">
                </td>
                <td colspan="" style="width: 100px" valign="middle">
                    Remaining:
                </td>
                <td colspan="" valign="middle">
                    <asp:TextBox ID="Txt_LeaveVacation_Remaining" runat="server" CssClass="clsTextbox"
                        ReadOnly="True" Width="50px"></asp:TextBox></td>
            </tr>
            <tr>
                <td valign="middle">
                    Sick:
                </td>
                <td valign="middle" colspan="">
                    <asp:TextBox ID="Txt_LeaveSick" runat="server" CssClass="clsTextbox" Width="50px"></asp:TextBox></td>
                <td colspan="" valign="middle">
                </td>
                <td colspan="" valign="middle">
                    Remaining:
                </td>
                <td colspan="" valign="middle">
                    <asp:TextBox ID="Txt_LeaveSick_Remaining" runat="server" CssClass="clsTextbox" ReadOnly="True"
                        Width="50px"></asp:TextBox>
                    </td>
            </tr>
            <tr>
                <td valign="middle">
                    Bereavement:
                </td>
                <td valign="middle" colspan="">
                    <asp:TextBox ID="Txt_LeaveBereavement" runat="server" CssClass="clsTextbox" Width="50px"></asp:TextBox></td>
                <td colspan="" valign="middle">
                </td>
                <td colspan="" valign="middle">
                    Remaining:
                </td>
                <td colspan="" valign="middle">
                    <asp:TextBox ID="Txt_LeaveBereavement_Remaining" runat="server" CssClass="clsTextbox"
                        ReadOnly="True" Width="50px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right" colspan="5" valign="middle">
                    <asp:Button ID="Btn_ResetLeave" runat="server" CssClass="clsButton" Text="Reset" Width="80px" />
                </td>
            </tr>
        </table>
    </div>
    <br />
    <div>
        <Uc:Person runat="server" ID="UcPerson" />
        <Uc:Address runat="server" ID="UcAddress" />
    </div>
    <br />
    <div>
        <table>
            <tr>
                <td style="width:100px">
                    Position:
                </td>
                <td>
                    <asp:TextBox ID="Txt_Position" runat="server" Width="200px" 
                        CssClass="clsTextbox" />
                </td>
                <td style="width:20px;">
                </td>
                <td style="width:100px;">
                    Department:
                </td>
                <td>
                    <asp:DropDownList ID="Cbo_Department" runat="server" CssClass="clsTextbox" Width="205px">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td>
                    Pay Rate:
                </td>
                <td>
                    <asp:DropDownList ID="Cbo_PayRate" runat="server" CssClass="clsTextbox" Width="205px">
                    </asp:DropDownList>
                </td>
                <td>
                </td>
                <td>
                    Pay:
                </td>
                <td>
                    <asp:TextBox ID="Txt_Pay" runat="server" Width="200px" CssClass="clsTextbox" />
                </td>
            </tr>
            <tr>
                <td>
                    SIN:
                </td>
                <td>
                    <asp:TextBox ID="Txt_SIN" runat="server" Width="200px" CssClass="clsTextbox" />
                </td>
                <td>
                </td>
                <td>
                    Employee Type:
                </td>
                <td>
                    <asp:DropDownList ID="Cbo_EmployeeType" runat="server" CssClass="clsTextbox" Width="205px">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td>
                    Date Hired:
                </td>
                <td>
                    <eo:DatePicker ID="EODtp_DateHired" runat="server" ControlSkinID="None" DayCellHeight="15"
                        DayCellWidth="31" DayHeaderFormat="Short" DisabledDates="" OtherMonthDayVisible="True"
                        SelectedDates="" TitleFormat="MMMM, yyyy" TitleLeftArrowImageUrl="DefaultSubMenuIconRTL"
                        TitleRightArrowImageUrl="DefaultSubMenuIcon" VisibleDate="2010-09-01" Width="205px">
                        <TodayStyle CssText="font-family:Verdana;font-size:8pt;background-image:url('00040401');color:#1176db;" />
                        <SelectedDayStyle CssText="font-family:Verdana;font-size:8pt;background-image:url('00040403');color:Brown;" />
                        <DisabledDayStyle CssText="font-family:Verdana;font-size:8pt;color: gray" />
                        <FooterTemplate>
                            <table border="0" cellpadding="0" cellspacing="5" style="font-size: 11px; font-family: Verdana">
                                <tr>
                                    <td width="30">
                                    </td>
                                    <td valign="center">
                                        <img src="{img:00040401}"></td>
                                    <td valign="center">
                                        Today: {var:today:MM/dd/yyyy}</td>
                                </tr>
                            </table>
                        </FooterTemplate>
                        <CalendarStyle CssText="background-color:white;border-bottom-color:Silver;border-bottom-style:solid;border-bottom-width:1px;border-left-color:Silver;border-left-style:solid;border-left-width:1px;border-right-color:Silver;border-right-style:solid;border-right-width:1px;border-top-color:Silver;border-top-style:solid;border-top-width:1px;color:#2C0B1E;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:5px;" />
                        <TitleArrowStyle CssText="cursor: hand" />
                        <DayHoverStyle CssText="font-family:Verdana;font-size:8pt;background-image:url('00040402');color:#1c7cdc;" />
                        <MonthStyle CssText="cursor:hand;margin-bottom:0px;margin-left:4px;margin-right:4px;margin-top:0px;" />
                        <TitleStyle CssText="font-family:Verdana;font-size:8.75pt;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:5px;" />
                        <DayHeaderStyle CssText="font-family:Verdana;font-size:8pt;border-bottom: #f5f5f5 1px solid" />
                        <DayStyle CssText="font-family:Verdana;font-size:8pt;" />
                    </eo:DatePicker>
                </td>
                <td>
                </td>
                <td>
                    End of Contract:
                </td>
                <td>
                    <eo:DatePicker ID="EODtp_DateTerminate" runat="server" ControlSkinID="None" DayCellHeight="15"
                        DayCellWidth="31" DayHeaderFormat="Short" DisabledDates="" OtherMonthDayVisible="True"
                        SelectedDates="" TitleFormat="MMMM, yyyy" TitleLeftArrowImageUrl="DefaultSubMenuIconRTL"
                        TitleRightArrowImageUrl="DefaultSubMenuIcon" VisibleDate="2010-09-01" Width="205px">
                        <TodayStyle CssText="font-family:Verdana;font-size:8pt;background-image:url('00040401');color:#1176db;" />
                        <SelectedDayStyle CssText="font-family:Verdana;font-size:8pt;background-image:url('00040403');color:Brown;" />
                        <DisabledDayStyle CssText="font-family:Verdana;font-size:8pt;color: gray" />
                        <FooterTemplate>
                            <table border="0" cellpadding="0" cellspacing="5" style="font-size: 11px; font-family: Verdana">
                                <tr>
                                    <td width="30">
                                    </td>
                                    <td valign="center">
                                        <img src="{img:00040401}"></td>
                                    <td valign="center">
                                        Today: {var:today:MM/dd/yyyy}</td>
                                </tr>
                            </table>
                        </FooterTemplate>
                        <CalendarStyle CssText="background-color:white;border-bottom-color:Silver;border-bottom-style:solid;border-bottom-width:1px;border-left-color:Silver;border-left-style:solid;border-left-width:1px;border-right-color:Silver;border-right-style:solid;border-right-width:1px;border-top-color:Silver;border-top-style:solid;border-top-width:1px;color:#2C0B1E;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:5px;" />
                        <TitleArrowStyle CssText="cursor: hand" />
                        <DayHoverStyle CssText="font-family:Verdana;font-size:8pt;background-image:url('00040402');color:#1c7cdc;" />
                        <MonthStyle CssText="cursor:hand;margin-bottom:0px;margin-left:4px;margin-right:4px;margin-top:0px;" />
                        <TitleStyle CssText="font-family:Verdana;font-size:8.75pt;padding-bottom:5px;padding-left:5px;padding-right:5px;padding-top:5px;" />
                        <DayHeaderStyle CssText="font-family:Verdana;font-size:8pt;border-bottom: #f5f5f5 1px solid" />
                        <DayStyle CssText="font-family:Verdana;font-size:8pt;" />
                    </eo:DatePicker>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder_Buttons_Bottom" runat="server">
</asp:Content>
