<%@ Page Language="C#" AutoEventWireup="true" CodeFile="3Party_Order.aspx.cs" Inherits="_TNS.Order" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">



<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Virtual Payment Client Example - ASP.Net (C#) </title>
    <style type='text/css'>
    <!--
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
        
    <form id="TransactionForm" runat="server">
    <div align="center">
        <asp:Panel ID="pnlRequest" runat="server" width="719px">
            <table style="margin-right: auto; margin-left:auto; border-width: 0; padding: 5px; width: 719px;">
                <tbody>
                    <tr class="title">
                        <td colspan="2" style="text-align: left"><p><strong>&nbsp;How to use this example</strong></p></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: left">&nbsp;<p class="blue">To use this example 
                            code the application settings in Web.config need to be configured. The required 
                            settings are listed below</p><p class="blue">Once these settings are configured, enter required data in each of the sections on this page that correspond to the functionality to be used for the transaction.
                            Then click the "Pay Now!" button to continue.</p>&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="height: 21px; width:50%" />
                        <td style="height: 21px; width:50%" />
                    </tr>
                    
                    <tr class="title">
                        <td colspan="2" style="text-align: left"><p><strong>&nbsp;Basic Transaction Fields</strong></p></td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>MerchantID:</em></strong></td>
                        <td style="text-align: left"></asp:TextBox>
                            <asp:Label ID="Label_MerchantID" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>Merchant Access Code:</em></strong></td>
                        <td style="text-align: left">
                            <asp:Label ID="Label_AccessCode" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>Merchant Transaction Reference:</em></strong></td>
                        <td style="text-align: left"><asp:TextBox ID="vpc_MerchTxnRef" runat="server"></asp:TextBox></td>
                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>OrderInfo:</em></strong></td>
                        <td style="text-align: left"><asp:TextBox ID="vpc_OrderInfo" runat="server"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>Purchase Amount:</em></strong></td>
                        <td style="text-align: left"><asp:TextBox ID="vpc_Amount" runat="server"></asp:TextBox></td>
                    </tr>
                    <tr class="shade">
                    <td style="text-align: right"><strong><em>
                        Currency (optional field):</em></strong></td>
                    <td style="text-align: left">
                        <asp:DropDownList ID="Currency_List" runat="server">
								<asp:ListItem Value="AUD" Selected></asp:ListItem>		
                            </asp:DropDownList></td>
                        
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>Payment Server Display Language Locale:</em></strong></td>
                        <td style="text-align: left">                        <asp:DropDownList ID="vpc_Locale" runat="server">
                                <asp:ListItem Value="">Please Select</asp:ListItem>
								<asp:ListItem Value="en_AU"></asp:ListItem>					
                            </asp:DropDownList></td>
                    </tr>

                    <tr>
                        <td style="height: 21px; width:50%" />
                        <td style="height: 21px; width:50%" />
                    </tr>
                    <tr>
                        <td colspan="2"  style="text-align: center; height: 21px"><asp:Button ID="btnPay" runat="server" Text="Pay Now!" OnClick="btnPay_Click" /></td>
                    </tr>
                    <tr>
                        <td style="height: 21px; width:50%" />
                        <td style="height: 21px; width:50%" />
                    </tr>
                   
										
                </tbody>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnlError" runat="server" width="719px">
            <table style="margin-right: auto; margin-left:auto; border-width: 0; padding: 5px; width: 719px;">
                <tbody>
                    <tr class="title" style="text-align: left">
                        <td colspan="2"><p><strong>&nbsp;Error Information</strong></p></td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 149px;"><strong><em>Error Message: </em></strong></td>
                        <td style="text-align: left; width: 650px"><asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label></td>
                    </tr>
                    <tr>
                        <td style="height: 21px" />
                        <td style="height: 21px" />
                    </tr>
                    <tr class="title">
                        <td colspan="2" style="text-align: left"><p><strong>&nbsp;Configuration Settings Required</strong></p></td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>PaymentServerURL:</em></strong></td>
                        <td style="text-align: left">This is the URL that the example will use to connect to the Payment Server, e.g. https://migs.mastercard.com.au/vpcpay</td>
                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>ProxyHost:</em></strong></td>
                        <td style="text-align: left">If a Proxy is required to access the internet specify the Proxy hostname or IP Address.</td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>ProxyUser:</em></strong></td>
                        <td style="text-align: left">If a Proxy is required to access the internet specify the Proxy hostname or IP Address.</td>
                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>ProxyPassword:</em></strong></td>
                        <td style="text-align: left">If a Proxy is required to access the internet specify the Proxy hostname or IP Address.</td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>ProxyDomain:</em></strong></td>
                        <td style="text-align: left">If a Proxy is required to access the internet specify the Proxy hostname or IP Address.</td>
                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>vpc_Version:</em></strong></td>
                        <td style="text-align: left">This is the VPC API version being used. The valid value for this example is "1".</td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>vpc_Command:</em></strong></td>
                        <td style="text-align: left">This is the VPC command to be used. The valid value for this example is "pay".</td>
                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>vpc_Merchant:</em></strong></td>
                        <td style="text-align: left">This is the Payment Server Merchant ID that this transaction is to be conducted against.</td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>vpc_AccessCode:</em></strong></td>
                        <td style="text-align: left">This is the Merchant Access Code that corresponds to the Payment Server Merchant ID to be used. The value for this field is available from the Configuration in the "Admin" section of the Merchant Administration Portal. </td>
                    </tr>
                    <tr class="shade">
                        <td style="text-align: right"><strong><em>SecureSecret:</em></strong></td>
                        <td style="text-align: left">This is the "Secure Secret" that corresponds to the Payment Server Merchant ID to be used. The value for this field is available from the Configuration in the "Admin" section of the Merchant Administration Portal. </td>
                    </tr>
                    <tr>
                        <td style="text-align: right"><strong><em>vpc_ReturnURL:</em></strong></td>
                        <td style="text-align: left">This is the URL that the Payment Server will sent the cardholders browser to upon completion of the transaction. THe cardholders browser will return with the transaction response.</td>
                    </tr>
                    <tr>
                        <td style="height: 21px; width:50%" />
                        <td style="height: 21px; width:50%" />
                    </tr>
                </tbody>
            </table>
        </asp:Panel>
    </div>
    </form>
    <div align="center">
        
    </div>
</body>
</html>