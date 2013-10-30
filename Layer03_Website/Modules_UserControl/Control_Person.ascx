<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Control_Person.ascx.cs" Inherits="Layer03_Website.Modules_UserControl.Control_Person" %>
<%@ Register Assembly="EO.Web" Namespace="EO.Web" TagPrefix="eo" %>

<script type="text/javascript" src="../Scripts/Js_Common.js"></script>
<script type="text/javascript">

    function Txt_Changed(TextboxID, Control) {
        Control.value = Control.value.replace(/[<>]/gi, '');
        eo_Callback("EOCb_Txt_Changed", TextboxID);
    }

</script>

<div>
    <table>
        <tr>
            <td style="width:120px">
                First Name:
            </td>
            <td>
                <asp:TextBox ID="Txt_FirstName" runat="server" CssClass="clsTextbox" Width="200px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Middle Name:
            </td>
            <td>
                <asp:TextBox ID="Txt_MiddleName" runat="server" CssClass="clsTextbox" Width="200px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Last Name:
            </td>
            <td>
                <asp:TextBox ID="Txt_LastName" runat="server" CssClass="clsTextbox" Width="200px"></asp:TextBox>
            </td>
        </tr>        
    </table>
</div>
<br />
<div>
    <table>
        <tr>
            <td style="width:120px">
                Phone No:
            </td>
            <td>
                <asp:TextBox ID="Txt_Phone" runat="server" CssClass="clsTextbox" Width="200px"></asp:TextBox>
            </td>
            <td style="width:20px">
            </td>
            <td style="width:120px">
                Mobile No:
            </td>
            <td>
                <asp:TextBox ID="Txt_Mobile" runat="server" CssClass="clsTextbox" Width="200px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
            Fax No:
            </td>
            <td>
                <asp:TextBox ID="Txt_Fax" runat="server" CssClass="clsTextbox" Width="200px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Personal Email:
            </td>
            <td>
                <asp:TextBox ID="Txt_Email" runat="server" CssClass="clsTextbox" Width="200px"></asp:TextBox>
            </td>
            <td>
            </td>
            <td>
                Work Email:
            </td>
            <td>
                <asp:TextBox ID="Txt_Email_Work" runat="server" CssClass="clsTextbox" Width="200px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Birth Date:
            </td>
            <td>
                <eo:DatePicker ID="EODtp_BirthDate" runat="server" ControlSkinID="None" DayCellHeight="15"
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
<br />
<eo:Callback ID="EOCb_Txt_Changed" runat="server" 
    ClientSideAfterExecute="EOCb_AE_Eval" ClientSideBeforeExecute="EOCb_BE">
</eo:Callback>
