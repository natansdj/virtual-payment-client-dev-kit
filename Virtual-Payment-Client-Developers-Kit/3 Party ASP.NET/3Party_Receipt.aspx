<%@ Page Language="C#" AutoEventWireup="true" CodeFile="3Party_Receipt.aspx.cs" Inherits="_TNS._ThreePartyReceipt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head2" runat="server">
    <title>Virtual Payment Client Example - ASP.Net (C#) </title>
    <style type='text/css'>
    h1       { font-family:Arial,sans-serif; font-size:20pt; font-weight:600; margin-bottom:0.1em; color:#08185A;}
    h2       { font-family:Arial,sans-serif; font-size:14pt; font-weight:100; margin-top:0.1em; color:#08185A;}
    h2.co    { font-family:Arial,sans-serif; font-size:24pt; font-weight:100; margin-top:0.1em; margin-bottom:0.1em; color:#08185A}
    h3       { font-family:Arial,sans-serif; font-size:16pt; font-weight:100; margin-top:0.1em; margin-bottom:0.1em; color:#08185A}
    h3.co    { font-family:Arial,sans-serif; font-size:16pt; font-weight:100; margin-top:0.1em; margin-bottom:0.1em; color:#FFFFFF}
    body     { font-family:Verdana,Arial,sans-serif; font-size:10pt; background-color:#FFFFFF; color:#08185A}
    th       { font-family:Verdana,Arial,sans-serif; font-size:8pt; font-weight:bold; background-color:#CED7EF; padding-top:0.5em; padding-bottom:0.5em;  color:#08185A}
    tr       { height:25px; }
    .shade   { height:25px; background-color:#CED7EF }
    .title   { height:25px; background-color:#0074C4 }
    td       { font-family:Verdana,Arial,sans-serif; font-size:8pt;  color:#08185A }
    td.red   { font-family:Verdana,Arial,sans-serif; font-size:8pt;  color:#FF0066 }
    td.green { font-family:Verdana,Arial,sans-serif; font-size:8pt;  color:#008800 }
    p        { font-family:Verdana,Arial,sans-serif; font-size:10pt; color:#FFFFFF }
    p.blue   { font-family:Verdana,Arial,sans-serif; font-size:7pt;  color:#08185A }
    p.red    { font-family:Verdana,Arial,sans-serif; font-size:7pt;  color:#FF0066 }
    p.green  { font-family:Verdana,Arial,sans-serif; font-size:7pt;  color:#008800 }
    div.bl   { font-family:Verdana,Arial,sans-serif; font-size:7pt;  color:#0074C4 }
    div.red  { font-family:Verdana,Arial,sans-serif; font-size:7pt;  color:#FF0066 }
    li       { font-family:Verdana,Arial,sans-serif; font-size:8pt;  color:#FF0066 }
    input    { font-family:Verdana,Arial,sans-serif; font-size:8pt;  color:#08185A; background-color:#CED7EF; font-weight:bold }
    select   { font-family:Verdana,Arial,sans-serif; font-size:8pt;  color:#08185A; background-color:#CED7EF; font-weight:bold; }
    textarea { font-family:Verdana,Arial,sans-serif; font-size:8pt;  color:#08185A; background-color:#CED7EF; font-weight:normal; scrollbar-arrow-color:#08185A; scrollbar-base-color:#CED7EF }
    -->
</style>
</head>
<body>
    <!-- start branding table -->
    <div align="center">
    <table style="margin-right: auto; margin-left:auto; width: 719px; background-color: #0074c4;">
        <tbody>
            <tr>
                <td style="padding: 5px; background-color: #ced7ef; width: 90%; text-align: left"><h2 class="co">MasterCard</h2><br />
                    <h3>Virtual Payment Client Example</h3></td>
   
            </tr>
        </tbody>
    </table>
    </div>
    <!-- end branding table -->

    <div style="text-align: center;"><h1>3-Party Transaction</h1></div>
        
    <div align="center">
        <asp:Panel ID="pnlResponse" runat="server" width="719px">
            <table style="margin-right: auto; margin-left:auto; border-width: 0; padding: 5px; width: 719px;">
                <tbody>
                    <tr class="title">
                        <td colspan="2" style="text-align: left"><p><strong>&nbsp;Transaction Receipt Fields</strong></p></td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>MerchTxnRef: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_MerchTxnRef" runat="server"/></td>
                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>Merchant ID: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_Merchant" runat="server"/></td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>OrderInfo: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_OrderInfo" runat="server"/></td>
                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>Transaction Amount: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_Amount" runat="server"/></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center">
                            <div class='bl'>Fields above are the primary request values.<hr />Fields below are receipt data fields.</div>
                        </td>
                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>Transaction Response Code: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_TxnResponseCode" runat="server"/></td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>Transaction Response Code Description: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_TxnResponseCodeDesc" runat="server"/></td>
                    </tr>
                    <tr  class="shade">
                        <td style="text-align: right"><strong><em>Payment Server Message: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_Message" runat="server"/></td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>Acquirer Response Code: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_AcqResponseCode" runat="server"/></td>
                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>Shopping Transaction Number: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_TransactionNo" runat="server"/></td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>Receipt Number: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_ReceiptNo" runat="server"/></td>
                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>Authorization ID: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_AuthorizeId" runat="server"/></td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>Batch Number for this transaction: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_BatchNo" runat="server"/></td>
                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>Card Type: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_Card" runat="server"/></td>
                    </tr>
                    <tr>
                        <td colspan="2"  style="text-align: center">
                            <div class='bl'>Fields above are for a Standard Transaction<hr/>Fields below are additional fields for extra functionality.</div>
                        </td>
                    </tr>
                    <tr class="title">
                        <td colspan="2" style="text-align: left"><p><strong>CSC Data Fields</strong></p></td>
                    </tr>

                    <tr>
                        <td style="text-align: right"><strong><em>CSC Result Code: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_cscResultCode" runat="server"/></td>
                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>CSC Result Description: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_cscResultCodeDesc" runat="server"/></td>
                    </tr>
                    <tr class="title">
                    <td colspan="2" style="text-align: left"><p><strong>3DS Response Fields</strong></p></td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>3DS ECI:</em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_3DSECI" runat="server"/></td>

                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>3DS XID:</em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_3DSXID" runat="server"/></td>

                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>3DS Enrolled:</em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_3DSenrolled" runat="server"/></td>

                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>3DS Status:</em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_3DSstatus" runat="server"/></td>

                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>3DS VerToken:</em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_VerToken" runat="server"/></td>

                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>3DS VerType:</em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_VerType" runat="server"/></td>

                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>3DS VerSecurityLevel:</em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_VerSecurityLevel" runat="server"/></td>
                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>3DS VerStatus:</em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_VerStatus" runat="server"/></td>

                    </tr>
                    
                    
                    
                    <tr class="title">
                        <td colspan="2" style="text-align: left"><p><strong>Risk Assessment Result Fields</strong></p></td>
                    </tr>
                        <tr>
                        <td style="text-align: right"><strong><em>Risk Overall Result: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_RiskOverallResult" runat="server"/></td>
                        </tr>
                        <tr class="shade">
                        <td style="text-align: right"><strong><em>Transaction Reversal Result: </em></strong></td>
                        <td style="text-align: left"><asp:Label id="Label_vpc_TxnReversalResult" runat="server"/></td>
                    </tr>
                    <tr>
                        <td style="height: 21px; width:50%" />
                        <td style="height: 21px; width:50%" />
                    </tr>
                    
                    <tr>
                        <td style="height: 21px; width:50%" />
                        <td style="height: 21px; width:50%" />
                    </tr>
                </tbody>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnlReceiptError" runat="server" width="719px">
            <table style="margin-right: auto; margin-left:auto; border-width: 0; padding: 5px; width: 719px;">
                <tbody>
                    <tr class="title">
                        <td colspan="2" style="text-align: left"><p><strong>&nbsp;Error Information</strong></p></td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 149px;"><strong><em>Error Message: </em></strong></td>
                        <td style="text-align: left; width: 650px"><asp:Label ID="lblReceiptErrorMessage" runat="server" ForeColor="Red"></asp:Label></td>
                    </tr>
                    <tr>
                        <td style="height: 21px" />
                        <td style="height: 21px" />
                    </tr>
                </tbody>
            </table>
        </asp:Panel>
    </div>
</body>
</html>
