﻿<%@ Control Language="C#" AutoEventWireup="true" Inherits="WKF_FlowManagement_UC_FieldSite_Sub" Codebehind="UC_FieldSite_Sub.ascx.cs" %>

<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList"  TagPrefix="uc1" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>


<script type="text/javascript" id="telerikClientEvents1">
//<![CDATA[

	function WebImageButton_DeleteSite_Clicking(sender,args)
	{
	    args.set_cancel(!confirm('<%=lblDelete.Text %>?'));
	}
//]]>
</script>

<div style="text-align: center; width:100%"  align="center" >
    <table border="0" cellpadding="0" cellspacing="0" width="90%"  align="center" style="margin: 0px auto; ">
        <tbody>
            <tr>
                <td align="center" style="height: 30px">
                    <asp:Image ID="Image1" runat="server" ImageUrl="~/Common/Images/Icon/icon_m54.gif"
                        meta:resourcekey="Image1Resource1" /></td>
            </tr>
            <tr>
                <td  style="text-align:center; width:100%" align="center">
              
                    <div style="text-align: center">
                        <table style="width: 100%;">
                            <tr>
                                <td>
                                    <table class="PopTable" width="500px">
                                        <tr>
                                            <td align="center" class="PopTableLeftTD" style="height: 23px" width="25%" colspan="1">
                                                <div align="center">
                                                    <asp:Label ID="lbSignType" runat="server" meta:resourcekey="lbSignTypeResource1" Text="型態"></asp:Label>
                                                </div>
                                            </td>
                                            <td align="center" class="PopTableLeftTD" style="height: 23px" width="25%" colspan="1">
                                                <div align="center">
                                                    <asp:Label ID="Label3" runat="server" Text="可否修改" meta:resourcekey="Label3Resource1"></asp:Label>
                                                </div>
                                            </td>
                                            <td align="center" class="PopTableLeftTD" style="height: 23px" width="25%" colspan="1">
                                                <div align="center">
                                                    <asp:Label ID="lblTimeoutTitle" runat="server" Text="逾時" meta:resourcekey="lblTimeoutTitleResource1"></asp:Label>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center" class="PopTableRightTD" style="height: 36px; text-align: center;" width="25%" colspan="1">
                                                <asp:Label ID="LblSiteType" runat="server" meta:resourcekey="LblSiteTypeResource1"></asp:Label>
                                            </td>
                                            <td align="center" class="PopTableRightTD" style="height: 36px; text-align: center;" width="25%" colspan="1">
                                                <asp:Image ID="imgIsMoidfiable" runat="server" meta:resourcekey="imgIsMoidfiableResource1" />&nbsp;
                                            </td>
                                            <td align="center" class="PopTableRightTD" style="height: 36px; text-align: center;" width="25%" colspan="1">
                                                <asp:Label ID="lblTimeOut" runat="server" meta:resourcekey="lblTimeOutResource1"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center" class="PopTableLeftTD" style="height: 24px" width="25%" colspan="3">
                                                <div align="center">
                                                    <asp:Label ID="lbGeneralSigner" runat="server" Text="表單欄位簽核" meta:resourcekey="lbGeneralSignerResource1"></asp:Label>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="PopTableRightTD" valign="top" width="25%" colspan="3" style="text-align: center; border-bottom:0px;">
                                                <asp:Label ID="lblSigner" runat="server" meta:resourcekey="lblSignerResource1"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table class="PopTable" style="width: 100%;">
                                        <tr>
                                            <td class="PopTableLeftTD" style="height: 24px; text-align: center;">
                                                <div>
                                                    <asp:Label ID="Label1" runat="server" Text="簽核前知會" meta:resourcekey="Label1Resource1"></asp:Label>
                                                </div>
                                            </td>
                                            <td class="PopTableLeftTD" style="height: 24px; text-align: center;">
                                                <div>
                                                    <asp:Label ID="Label2" runat="server" Text="簽核後知會" meta:resourcekey="Label5Resource1"></asp:Label>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="PopTableRightTD" style="text-align: center; vertical-align: top;">
                                                <Fast:Grid ID="gridSignAlter" runat="server" Width="100%"  
                                                    DataKeyNames="NOTIFY_ID"  AutoGenerateCheckBoxColumn="False"
                                                    DataKeyOnClientWithCheckBox="True" EnhancePager="True" PageSize="15" AutoGenerateColumns="False"
                                                    AllowSorting="True" DefaultSortDirection="Ascending" OnRowDataBound="gridSignAlter_RowDataBound"
                                                    EmptyDataText="沒有資料" KeepSelectedRows="False"
                                                    meta:resourcekey="gridSignAlterResource1" >
                                                    <EnhancePagerSettings ShowHeaderPager="True" />
                                                    <ExportExcelSettings AllowExportToExcel="False" />
                                                    <Columns>
                                                        <asp:BoundField DataField="COND_ID" HeaderText="條件" meta:resourcekey="BoundFieldResource1" >
                                                            <HeaderStyle Wrap="false" />
                                                            <ItemStyle Width="100px" HorizontalAlign="Left" />
                                                        </asp:BoundField>
                                                        <asp:TemplateField HeaderText="特殊知會" meta:resourcekey="TemplateFieldResource1">
                                                            <HeaderStyle Wrap="false" />
                                                            <ItemStyle Width="125px" HorizontalAlign="Left" />
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblSpecialAlter" runat="server" meta:resourcekey="lblSpecialAlterResource1"></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="一般知會" meta:resourcekey="TemplateFieldResource2">
                                                            <HeaderStyle Wrap="false" />
                                                            <ItemStyle HorizontalAlign="Left" />
                                                            <ItemTemplate>
                                                                <uc1:UC_ChoiceList ID="uc_Alter" IsAllowEdit="false" runat="server" ShowMember="False" ExpandToUser="False" />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </Fast:Grid>
                                            </td>
                                            <td class="PopTableRightTD" style="text-align: center; vertical-align: top;">
                                                <Fast:Grid ID="gridSignedAlter" runat="server" Width="100%" 
                                                    DataKeyNames="NOTIFY_ID"  AutoGenerateCheckBoxColumn="False"
                                                    DataKeyOnClientWithCheckBox="True" EnhancePager="True" PageSize="15" AutoGenerateColumns="False"
                                                    AllowSorting="True" DefaultSortDirection="Ascending" OnRowDataBound="gridSignedAlter_RowDataBound"
                                                    EmptyDataText="沒有資料" KeepSelectedRows="False"
                                                    meta:resourcekey="gridSignedAlterResource1"   >
                                                    <EnhancePagerSettings ShowHeaderPager="True" />
                                                    <ExportExcelSettings AllowExportToExcel="False" />
                                                    <Columns>
                                                        <asp:BoundField DataField="COND_ID" HeaderText="條件" meta:resourcekey="BoundFieldResource1" >
                                                            <HeaderStyle Wrap="false" />
                                                            <ItemStyle Width="100px" HorizontalAlign="Left" />
                                                        </asp:BoundField>
                                                        <asp:TemplateField HeaderText="特殊知會" meta:resourcekey="TemplateFieldResource1">
                                                            <HeaderStyle Wrap="false" />
                                                            <ItemStyle Width="125px" HorizontalAlign="Left" />
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblSpecialAlter" runat="server" meta:resourcekey="lblSpecialAlterResource1"></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="一般知會" meta:resourcekey="TemplateFieldResource2">
                                                            <HeaderStyle Wrap="false" />
                                                            <ItemStyle HorizontalAlign="Left" />
                                                            <ItemTemplate>
                                                                <uc1:UC_ChoiceList ID="uc_Alter" IsAllowEdit="false" runat="server" ShowMember="False"
                                                                    ExpandToUser="False" />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </Fast:Grid>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <asp:Panel ID="PanelOperator" runat="server" Width="100%" meta:resourcekey="PanelOperatorResource1">
                            <table cellpadding="0" cellspacing="0"  align="right" style="width:100%">
                                <tr>
                                    <td style="text-align: right; width: 100%">
                                        <table style="width:100%">
                                            <tr>
                                                <td style="width: 1%">&nbsp;</td>
                                                <td style="text-align:right" >
                                                    <telerik:RadButton ID="WebImageButton_UPSite" runat="server" 
                                                        Text="↑" Width="20px" meta:resourcekey="WebImageButton_UPSiteResource1" OnClick="WebImageButton_UPSite_Click1"></telerik:RadButton>
                                                    <telerik:RadButton ID="WebImageButton_DownSite" runat="server" 
                                                        Text="↓" Width="20px" meta:resourcekey="WebImageButton_DownSiteResource1" OnClick="WebImageButton_DownSite_Click1"></telerik:RadButton>
                                                    <telerik:RadButton ID="WebImageButton_InsertSite" runat="server" 
                                                        meta:resourcekey="WebImageButton_InsertSiteResource1" OnClick="WebImageButton_InsertSite_Click1"></telerik:RadButton>
                                                    <telerik:RadButton ID="WebImageButton_ModifySite" runat="server" 
                                                        meta:resourcekey="WebImageButton_ModifySiteResource1"></telerik:RadButton>
                                                    <telerik:RadButton ID="WebImageButton_DeleteSite" runat="server" 
                                                        meta:resourcekey="WebImageButton_DeleteSiteResource1" OnClientClicking="WebImageButton_DeleteSite_Clicking" OnClick="WebImageButton_DeleteSite_Click1"></telerik:RadButton>
                                                </td>
                                            </tr>
                                        </table>                                                   
                                    </td>
                                </tr>
                            </table>
                            &nbsp; &nbsp; &nbsp;&nbsp;
                            <asp:Panel ID="Panel1" runat="server" Visible="False" meta:resourcekey="Panel1Resource1">
                                <asp:Label ID="lblStartSigner" runat="server" Text="流程起始人員" meta:resourcekey="lblStartSignerResource1"></asp:Label>
                                <asp:Label ID="lblApplyer" runat="server" Text="申請者" meta:resourcekey="lblApplyerResource1"></asp:Label>
                                <asp:Image ID="imgSiteType" runat="server" Visible="False" meta:resourcekey="imgSiteTypeResource1" />
                                <asp:Label ID="lbAdditionalSignTitle" runat="server" Text="加簽" meta:resourcekey="lbAdditionalSignTitleResource1"></asp:Label>
                                <asp:Image ID="imgIsAddSign" runat="server" meta:resourcekey="imgIsAddSignResource1" />
                                <asp:Label ID="lblJumpTitle" runat="server" Text="跳簽" meta:resourcekey="lblJumpTitleResource1" Width="30px"></asp:Label><asp:Label ID="lblFlowEndTitle" runat="server" Text="結束" meta:resourcekey="lblFlowEndTitleResource1" Width="30px"></asp:Label>
                                <asp:Image ID="imgIsFlowEnd" runat="server" meta:resourcekey="imgIsFlowEndResource1" Width="26px" />
                                <asp:Image ID="imgIsJump" runat="server" ImageUrl="~/Common/Images/Icon/icon_m49.gif" meta:resourcekey="imgIsJumpResource1" Width="14px" />
                                <asp:Label ID="lblLastSiteAgent" runat="server" Text="上一站點代理人" meta:resourcekey="lblLastSiteAgentResource1"></asp:Label>
                                <asp:Label ID="lblApplyerSuperiorSign" runat="server" Text="申請者直屬主管" meta:resourcekey="lblApplyerSuperiorSignResource1"></asp:Label>
                                <asp:Label ID="lblLastSuperiorSign" runat="server" Text="上一站直屬主管" meta:resourcekey="lblLastSuperiorSignResource1"></asp:Label></asp:Panel>
                        </asp:Panel>
                    </div>
                  
                </td>
            </tr>
        </tbody>
    </table>
    <asp:Label ID="lblSite" runat="server" Text="插入站點" Visible="False" meta:resourcekey="lblSiteResource1"></asp:Label>
    <asp:Label ID="lblSet" runat="server" Text="設定" Visible="False" meta:resourcekey="lblSetResource1"></asp:Label>
    <asp:Label ID="lblDeleteSite" runat="server" Text="刪除" Visible="False" meta:resourcekey="lblDeleteSiteResource1"></asp:Label>
    <asp:Label ID="lblDelete" runat="server" Text="確定刪除站點?" Visible="False" meta:resourcekey="lblDeleteResource1"></asp:Label>
    <asp:Label ID="lblGeneral" runat="server" Text="一般" Visible="False" meta:resourcekey="lblGeneralResource1"></asp:Label>
    <asp:Label ID="lblAnd" runat="server" Text="會簽" Visible='False' meta:resourcekey="lblAndResource1"></asp:Label>
    <asp:Label ID="lblOr" runat="server" Text="並簽" Visible="False" meta:resourcekey="lblOrResource1"></asp:Label>
    <asp:Label ID="lblAssign" runat="server" Text="指定" Visible="False" meta:resourcekey="lblAssignResource1"></asp:Label>
    <asp:Label ID="lblDefault" runat="server" Text="其他" Visible="False" meta:resourcekey="lblDefaultResource1"></asp:Label>
    <telerik:RadTreeView ID="treeCondition" runat="server" Visible="False" meta:resourcekey="treeConditionResource2"></telerik:RadTreeView>
</div>
