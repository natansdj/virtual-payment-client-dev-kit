<%@ Page Language="C#" DEBUG=false %>

<!DOCTYPE HTML PUBLIC '-'W3C'DTD HTML 4.01 Transitional'EN'>
<html>
<head>

<script runat="server">
/*
Version 3.1

---------------- Disclaimer --------------------------------------------------

Copyright 2004 Dialect Solutions Holdings.  All rights reserved.

This document is provided by Dialect Holdings on the basis that you will treat
it as confidential.

No part of this document may be reproduced or copied in any form by any means
without the written permission of Dialect Holdings.  Unless otherwise
expressly agreed in writing, the information contained in this document is
subject to change without notice and Dialect Holdings assumes no
responsibility for any alteration to, or any error or other deficiency, in
this document.

All intellectual property rights in the Document and in all extracts and
things derived from any part of the Document are owned by Dialect and will be
assigned to Dialect on their creation. You will protect all the intellectual
property rights relating to the Document in a manner that is equal to the
protection you provide your own intellectual property.  You will notify
Dialect immediately, and in writing where you become aware of a breach of
Dialect's intellectual property rights in relation to the Document.

The names "Dialect", "QSI Payments" and all similar words are trademarks of
Dialect Holdings and you must not use that name or any similar name.

Dialect may at its sole discretion terminate the rights granted in this
document with immediate effect by notifying you in writing and you will
thereupon return (or destroy and certify that destruction to Dialect) all
copies and extracts of the Document in its possession or control.

Dialect does not warrant the accuracy or completeness of the Document or its
content or its usefulness to you or your merchant customers.   To the extent
permitted by law, all conditions and warranties implied by law (whether as to
fitness for any particular purpose or otherwise) are excluded.  Where the
exclusion is not effective, Dialect limits its liability to $100 or the
resupply of the Document (at Dialect's option).

Data used in examples and sample data files are intended to be fictional and
any resemblance to real persons or companies is entirely coincidental.

Dialect does not indemnify you or any third party in relation to the content
or any use of the content as contemplated in these terms and conditions.

Mention of any product not owned by Dialect does not constitute an endorsement
of that product.

This document is governed by the laws of New South Wales, Australia and is
intended to be legally binding.

Author: Dialect Solutions Group Pty Ltd

----------------------------------------------------------------------------
*/

/*
<summary>C# example for the Virtual Payment Client</summary>
<remarks>

<para>
This program assumes that a HTTP Form POST has been sent to this example 
with the required fields. The example then processes the command and 
displays the receipt or error to a HTML page in the users web browser.
</para>

</remarks>
*/

// Declare the global variables
private string debugData = "";

// _________________________________________________________________________

private string getResponseDescription(string vResponseCode)
{
   /* 
    <summary>Maps the vpc_TxnResponseCode to a relevant description</summary>
    <param name="vResponseCode">The vpc_TxnResponseCode returned by the transaction.</param>
    <returns>The corresponding description for the vpc_TxnResponseCode.</returns>
    */
    string result = "Unknown";

    if (vResponseCode.Length > 0)
    {
        switch (vResponseCode)
        {
            case "0" : result = "Transaction Successful"; break;
            case "1" : result = "Transaction Declined"; break;
            case "2" : result = "Bank Declined Transaction"; break;
            case "3" : result = "No Reply from Bank"; break;
            case "4" : result = "Expired Card"; break;
            case "5" : result = "Insufficient Funds"; break;
            case "6" : result = "Error Communicating with Bank"; break;
            case "7" : result = "Payment Server detected an error"; break;
            case "8" : result = "Transaction Type Not Supported"; break;
            case "9" : result = "Bank declined transaction (Do not contact Bank)"; break;
            case "A" : result = "Transaction Aborted"; break;
            case "B" : result = "Transaction Declined - Contact the Bank"; break;
            case "C" : result = "Transaction Cancelled"; break;
            case "D" : result = "Deferred transaction has been received and is awaiting processing"; break;
            case "F" : result = "3-D Secure Authentication failed"; break;
            case "I" : result = "Card Security Code verification failed"; break;
            case "L" : result = "Shopping Transaction Locked (Please try the transaction again later)"; break;
            case "N" : result = "Cardholder is not enrolled in Authentication scheme"; break;
            case "P" : result = "Transaction has been received by the Payment Adaptor and is being processed"; break;
            case "R" : result = "Transaction was not processed - Reached limit of retry attempts allowed"; break;
            case "S" : result = "Duplicate SessionID"; break;
            case "T" : result = "Address Verification Failed"; break;
            case "U" : result = "Card Security Code Failed"; break;
            case "V" : result = "Address Verification and Card Security Code Failed"; break;
            default  : result = "Unable to be determined"; break;
        }
    }
    return result;
}


// _________________________________________________________________________

private string getAVSDescription(string vAVSResultCode)
{
   /*
    <summary>Maps the vpc_AVSResultCode to a relevant description</summary>
    <param name="vAVSResultCode">The vpc_AVSResultCode returned by the transaction.</param>
    <returns>The corresponding description for the vpc_AVSResultCode.</returns>
    */
    string result = "Unknown";

    if (vAVSResultCode.Length > 0)
    {
        if (vAVSResultCode.Equals("Unsupported"))
        {
            result = "AVS not supported or there was no AVS data provided";
        }
        else
        {
            switch (vAVSResultCode)
            {
                case "X" : result = "Exact match - address and 9 digit ZIP/postal code"; break;
                case "Y" : result = "Exact match - address and 5 digit ZIP/postal code"; break;
                case "S" : result = "Service not supported or address not verified (international transaction)"; break;
                case "G" : result = "Issuer does not participate in AVS (international transaction)"; break;
                case "A" : result = "Address match only"; break;
                case "W" : result = "9 digit ZIP/postal code matched, Address not Matched"; break;
                case "Z" : result = "5 digit ZIP/postal code matched, Address not Matched"; break;
                case "R" : result = "Issuer system is unavailable"; break;
                case "U" : result = "Address unavailable or not verified"; break;
                case "E" : result = "Address and ZIP/postal code not provided"; break;
                case "N" : result = "Address and ZIP/postal code not matched"; break;
                case "0" : result = "AVS not requested"; break;
                default  : result = "Unable to be determined"; break;
            }
        }
    }
    return result;
}

//______________________________________________________________________________

private string getCSCDescription(string vCSCResultCode)
{
   /*
    <summary>Maps the vpc_CSCResultCode to a relevant description</summary>
    <param name="vCSCResultCode">The vpc_CSCResultCode returned by the transaction.</param>
    <returns>The corresponding description for the vpc_CSCResultCode.</returns>
    */
    string result = "Unknown";
    if (vCSCResultCode.Length > 0) 
    {
        if (vCSCResultCode.Equals("Unsupported"))
        {
            result = "CSC not supported or there was no CSC data provided";
        }
        else
        {

            switch (vCSCResultCode)
            {
                case "M" : result = "Exact code match"; break;
                case "S" : result = "Merchant has indicated that CSC is not present on the card (MOTO situation)"; break;
                case "P" : result = "Code not processed"; break;
                case "U" : result = "Card issuer is not registered and/or certified"; break;
                case "N" : result = "Code invalid or not matched"; break;
                default: result = "Unable to be determined"; break;
            }
        }
    }
    return result;
}

//______________________________________________________________________________

private System.Collections.Hashtable splitResponse(string rawData)
{
   /*
    <summary>Parses a HTTP POST to extract the parmaters from the POST data</summary>
    <param name="rawData">The raw data from the body of a HTTP POST.</param>
    <returns>A Hashtable containing the parameters returned in the body of a HTTP POST.</returns>

    <remarks>
    <para>
    This function parses the content of the VPC response to extract the 
    individual parameter names and values. These names and values are then 
    returned as a Hashtable.
    </para>

    <para>
    The content returned by the VPC is a HTTP POST, so the content will 
    be in the format <c>parameter1=value&parameter2=value&parameter3=value</c>, 
    i.e. key/value pairs separated by ampersands "&".
    </para>
    </remarks>
    */

    System.Collections.Hashtable responseData = new System.Collections.Hashtable();
    try 
    {
        // Check if there was a response containing parameters
        if (rawData.IndexOf("=") > 0) 
        {
            // Extract the key/value pairs for each parameter
            foreach (string pair in rawData.Split('&'))
            {
                int equalsIndex = pair.IndexOf("=");
                if (equalsIndex > 1 && pair.Length > equalsIndex)
                {
                    string paramKey   = System.Web.HttpUtility.UrlDecode(pair.Substring(0, equalsIndex));
                    string paramValue = System.Web.HttpUtility.UrlDecode(pair.Substring(equalsIndex+1));
                    responseData.Add (paramKey, paramValue);
                }
            }
        } 
        else 
        {
                // There were no parameters so create an error
                responseData.Add ("vpc_Message", "The data contained in the response was not a valid receipt.<br/>\nThe data was: <pre>"+rawData+"</pre><br/>\n");
        }
        return responseData;
    } 
    catch (Exception ex) 
    {
        // There was an exception so create an error
        responseData.Add ("vpc_Message", "\nThe was an exception parsing the response data.<br/>\nThe data was: <pre>"+rawData+"</pre><br/>\n<br/>\nException: "+ex.ToString()+"<br/>\n");
        return responseData;
    }
}

// _________________________________________________________________________

private void Page_Load(object sender, System.EventArgs e)
{
   /*
    <summary>Performs a VPC transaction from an incoming HTTP POST</summary>
    <remarks>
    <para>
    TRANSACTION DATA SHOULD NOT BE PASSED THROUGH THE ORDER PAGE AS HIDDEN 
    FIELDS. It is very easy for the cardholder to use the browser 'View/Source' 
    function to see, and change, the data while in transit. SIMILARLY CLIENT SIDE 
    SESSION COOKIES ALSO SHOULD NOT BE USED TO STORE TRANSACTION DATA.
    </para>

    <para>
    To avoid this issue you can add sensitive data direct from a database 
    query or a session variable stored server side on this page. In fact no 
    transaction data should be passed in from the order page at all.
    </para>

    <para>
    You can simply retreive the transaction data from the server and add 
    the data directly to the POST data string as key value pairs, e.g.
    </para>

    <code>
    string postData = "vpc_AccessCode=accessValue&vpc_Amount=amountValue&vpc_CardExp=valueFormat(YYMM)&vpc_CardNum=panValue&vpc_Command=pay&vpc_Merchant=YourMerchantID&vpc_OrderInfo=aReferenceValue&vpc_MerchTxnRef=someValue&vpc_Version=1&vpc_TicketNo=aValue";
    </code>

    <para>
    If the vpc_TicketNo field is not used then leave it out of the string.
    </para>

    <para>
    The postData information can be then directly used in the HTTP POST, i.e.
    </para>

    <code>
    byte[] response = webClient.UploadData(vpcURL, "POST", Encoding.ASCII.GetBytes(postData));
    </code>

    <para>
    If used in this way there is no need to retrieve any form data or loop 
    through the <c>Page.Request.Form</c> collection as done in this example.
    </para>

    <para>
    To find out what is included in your postData string you can enable DEBUG 
    and run a test transaction. The postData string will then be output to the 
    screen. This debug code allows the user to see all the data associated with 
    the transaction. DEBUG should be disabled or removed entirely in production 
    code.
    </para>

    <para>
    To enable DEBUG, change the ASP directive at the top of this file.
    <para>

    <code>   <%@ Page Language="C#" DEBUG=false %>   </code>
    <para>                    to                     </para>
    <code>   <%@ Page Language="C#" DEBUG=true %>    </code>

    <para>
    The actual functionality of this example resides in lines which perform 
    the HTTP POST to the Virtual Payment Client and retrieve the response.
    </para>

    <code>
    System.Net.WebClient webClient = new System.Net.WebClient();                  
    webClient.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
    byte[] response = webClient.UploadData(vpcURL, "POST", Encoding.ASCII.GetBytes(postData));
    </code>

    <para>
    The rest of the example is only parsing incoming data, and creating 
    HTML markup to display the receipt nicely for the example.
    </para>
    </remarks>
    */

    // Initialisation
    // ==============

    /*
     *******************************************
     * Define Variables
     *******************************************
     */

    Panel_Debug.Visible = false;
    Panel_Receipt.Visible    = false;
    Panel_StackTrace.Visible = false;

    // define message string for errors
    string message = "";
    
    // error exists flag
    bool errorExists = false;

    // transaction response code
    string txnResponseCode = "";

    try
    {
       /*
        *************************
        * START OF MAIN PROGRAM *
        *************************
        */

        string postData = "";
        
        // Collect debug information
        # if DEBUG
            debugData += "<u>Data from Order Page</u><br/>";
        # endif

        // Loop through all the data in the Page.Request.Form
        foreach (string item in Page.Request.Form) {
            
            // Collect debug information
            # if DEBUG 
                debugData += item +"="+ Page.Request.Form[item] +"<br/>";
            # endif
            
           /* 
            * Only include those fields required for a transaction
            * Extract the Form POST data and ignore the Virtual Payment Client
            * URL, the Submit button and any empty form fields, as we do not 
            * want to send these fields to the Virtual Payment Client. 
            */
            if ((Page.Request.Form[item] != "") && (item != "SubButL") && (item != "virtualPaymentClientURL") && (item != "Title")) {
                postData += System.Web.HttpUtility.UrlEncode(item) + "=" + System.Web.HttpUtility.UrlEncode(Page.Request.Form[item]) + "&";
            }
        }

        // Remove the trailing ampersand on the POST data string
        postData = postData.Substring(0,postData.Length-1);

        // Get the URL of the Virtual Payment Client
        string vpcURL = Page.Request.Form["virtualPaymentClientURL"];

        // Collect debug information
        # if DEBUG
            debugData += "<br/>Destination of POST data operation: "+ vpcURL +"<br/>Post Data String: " + postData +"<br/>";
        # endif
        
        // Perform the VPC request (i.e. HTTPS POST) and obtain the VPC response
        System.Net.WebClient webClient = new System.Net.WebClient();                  
        webClient.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
        byte[] response = webClient.UploadData(vpcURL, "POST", Encoding.ASCII.GetBytes(postData));

        // Convert the response to a string from a byte array and parse it to extract
        // the data using the splitResponse function. Store results in a hashtable.
        string responseData = System.Text.Encoding.ASCII.GetString(response,0,response.Length);
        System.Collections.Hashtable responseParameters = splitResponse(responseData);

        // Collect debug information
        # if DEBUG
            debugData += "<br/>Response of POST data operation: "+ responseData +"<br/>";
        # endif
        
        // Get the standard receipt data from the parsed response
        Label_Amount.Text          = responseParameters.ContainsKey("vpc_Amount")?responseParameters["vpc_Amount"].ToString():"Unknown";
        Label_BatchNo.Text         = responseParameters.ContainsKey("vpc_BatchNo")?responseParameters["vpc_BatchNo"].ToString():"Unknown";
        Label_Command.Text         = responseParameters.ContainsKey("vpc_Command")?responseParameters["vpc_Command"].ToString():"Unknown";
        Label_Version.Text         = responseParameters.ContainsKey("vpc_Version")?responseParameters["vpc_Version"].ToString():"Unknown";
        Label_CardType.Text        = responseParameters.ContainsKey("vpc_Card")?responseParameters["vpc_Card"].ToString():"Unknown";
        Label_OrderInfo.Text       = responseParameters.ContainsKey("vpc_OrderInfo")?responseParameters["vpc_OrderInfo"].ToString():"Unknown";
        Label_ReceiptNo.Text       = responseParameters.ContainsKey("vpc_ReceiptNo")?responseParameters["vpc_ReceiptNo"].ToString():"Unknown";
        Label_MerchantID.Text      = responseParameters.ContainsKey("vpc_Merchant")?responseParameters["vpc_Merchant"].ToString():"Unknown";
        Label_AuthorizeID.Text     = responseParameters.ContainsKey("vpc_AuthorizeId")?responseParameters["vpc_AuthorizeId"].ToString():"Unknown";
        Label_MerchTxnRef.Text     = responseParameters.ContainsKey("vpc_MerchTxnRef")?responseParameters["vpc_MerchTxnRef"].ToString():"Unknown";
        Label_TransactionNo.Text   = responseParameters.ContainsKey("vpc_TransactionNo")?responseParameters["vpc_TransactionNo"].ToString():"Unknown";
        Label_AcqResponseCode.Text = responseParameters.ContainsKey("vpc_AcqResponseCode")?responseParameters["vpc_AcqResponseCode"].ToString():"Unknown";

        txnResponseCode = responseParameters.ContainsKey("vpc_TxnResponseCode")?responseParameters["vpc_TxnResponseCode"].ToString():"Unknown";
        Label_TxnResponseCodeDesc.Text = getResponseDescription(txnResponseCode);
        Label_TxnResponseCode.Text = txnResponseCode;

        string avsResultCode = responseParameters.ContainsKey("vpc_AVSResultCode")?responseParameters["vpc_AVSResultCode"].ToString():"Unknown";
        Label_AvsResponseCodeDesc.Text = getAVSDescription(avsResultCode);
        Label_AvsResponseCode.Text = avsResultCode;

        string cscResultCode = responseParameters.ContainsKey("vpc_CSCResultCode")?responseParameters["vpc_CSCResultCode"].ToString():"Unknown";
        Label_CscResponseCodeDesc.Text = getCSCDescription(cscResultCode);
        Label_CscResponseCode.Text = cscResultCode;

        if (message.Length == 0) 
        {
            message = responseParameters.ContainsKey("vpc_Message")?responseParameters["vpc_Message"].ToString():"Unknown";
        }
        
    }
    catch (Exception ex)
    {
       message = "(51) Exception encountered. " + ex.Message;
       if (ex.StackTrace.Length > 0)
       {
           Label_StackTrace.Text = ex.ToString();
           Panel_StackTrace.Visible = true;
       }
       errorExists = true;
    }
    
    Label_Message.Text = message;
    
    if (!errorExists) 
    {
        Panel_Receipt.Visible = true;
    }

   /*
    * The fields below (AgainLink and Title) are used only for HTML markup
    * purposes in this example.
    */
    // Create a link to the example's HTML order page
    Label_AgainLink.Text = "<a href=\"" + Page.Request.ServerVariables["HTTP_REFERER"] + "\">Another Transaction</a>";
    
    // Determine the appropriate title for the receipt page
    Label_Title.Text    = (errorExists || txnResponseCode.Equals("7") || txnResponseCode.Equals("Unknown"))?Page.Request.Form["Title"]+" Error Page" : Page.Request.Form["Title"]+" Receipt Page";

    // Output debug data to the screen
    # if DEBUG
        debugData += "<br/>End of debug information<br/>";
        Label_Debug.Text    = debugData;
        Panel_Debug.Visible = true;
    # endif

   /*
    **********************
    * END OF MAIN PROGRAM
    **********************
    *
    * FINISH TRANSACTION - Output the VPC Response Data
    * =====================================================
    * For the purposes of demonstration, we simply display the Result fields
    * on a web page.
    */
}
</script>

<title>Example Transaction</title>
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
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
<table width='100%' border='2' cellpadding='2' class='title'>
    <tr>
        <td class='shade' width='90%'><h2 class='co'>&nbsp;Virtual Payment Client Example</h2></td>
        <td class='title' align='center'><h3 class='co'>MiGS</h3></td>
    </tr>
</table>
<!-- end branding table -->

<asp:Panel id="Panel_Debug" runat=server>
<!-- only display these next fields if debug enabled -->
<table>
    <tr>
        <td><asp:Label id=Label_Debug runat="server"/></td>
    </tr>
    <tr>
        <td><asp:Label id=Label_DigitalOrder runat="server"/></td>
    </tr>
</table>
</asp:Panel>

<h1 align="center"><asp:Label id=Label_Title runat="server"/></h1>

<form runat=server>
<table align="center" border="0" width="70%">
    
    <tr class="title">
        <td colspan="2"><p><strong>&nbsp;Transaction Receipt Fields</strong></p></td>
    </tr>
    <tr>
        <td align="right"><strong><i>VPC API Version: </i></strong></td>
        <td><asp:Label id=Label_Version runat="server"/></td>
    </tr>
    <tr class='shade'>
        <td align="right"><strong><i>Command: </i></strong></td>
        <td><asp:Label id=Label_Command runat="server"/></td>
    </tr>
    <tr>
        <td align="right"><strong><em>MerchTxnRef: </em></strong></td>
        <td><asp:Label id=Label_MerchTxnRef runat="server"/></td>
    </tr>
    <tr class="shade">
        <td align="right"><strong><em>Merchant ID: </em></strong></td>
        <td><asp:Label id=Label_MerchantID runat="server"/></td>
    </tr>
    <tr>
        <td align="right"><strong><em>OrderInfo: </em></strong></td>
        <td><asp:Label id=Label_OrderInfo runat="server"/></td>
    </tr>
    <tr class="shade">
        <td align="right"><strong><em>Transaction Amount: </em></strong></td>
        <td><asp:Label id=Label_Amount runat="server"/></td>
    </tr>
    <tr>
        <td colspan="2" align="center">
            <div class='bl'>Fields above are the primary request values.<hr>Fields below are receipt data fields.</div>
        </td>
    </tr>
    <tr class="shade">
        <td align="right"><strong><em>Transaction Response Code: </em></strong></td>
        <td><asp:Label id=Label_TxnResponseCode runat="server"/></td>
    </tr>
    <tr>
        <td align="right"><strong><em>QSI Response Code Description: </em></strong></td>
        <td><asp:Label id=Label_TxnResponseCodeDesc runat="server"/></td>
    </tr>
    <tr class='shade'>
        <td align="right"><strong><i>Message: </i></strong></td>
        <td><asp:Label id=Label_Message runat="server"/></td>
    </tr>
<asp:Panel id="Panel_Receipt" runat=server>
<!-- only display these next fields if not an error -->
    <tr>
        <td align="right"><strong><em>Acquirer Response Code: </em></strong></td>
        <td><asp:Label id=Label_AcqResponseCode runat="server"/></td>
    </tr>
    <tr class="shade">
        <td align="right"><strong><em>Shopping Transaction Number: </em></strong></td>
        <td><asp:Label id=Label_TransactionNo runat="server"/></td>
    </tr>
    <tr>
        <td align="right"><strong><em>Receipt Number: </em></strong></td>
        <td><asp:Label id=Label_ReceiptNo runat="server"/></td>
    </tr>
    <tr class="shade">
        <td align="right"><strong><em>Authorization ID: </em></strong></td>
        <td><asp:Label id=Label_AuthorizeID runat="server"/></td>
    </tr>
    <tr>
        <td align="right"><strong><em>Batch Number for this transaction: </em></strong></td>
        <td><asp:Label id=Label_BatchNo runat="server"/></td>
    </tr>
    <tr class="shade">
        <td align="right"><strong><em>Card Type: </em></strong></td>
        <td><asp:Label id=Label_CardType runat="server"/></td>
    </tr>
        <td colspan="2" align="center">
            <div class='bl'>Fields above are for a Standard Transaction<hr/>
            Fields below are additional fields for extra functionality.</div>
        </td>
    </tr>
    <tr class='title'>
        <td colspan='2' height='25'><p><strong> Address Verification Service Fields</strong></p></td>
    </tr>
    <tr>
        <td align='right'><strong><em>AVS Result Code: </em></strong></td>
        <td><asp:Label id=Label_AvsResponseCode runat="server"/></td>
    </tr>
    <tr class='shade'>
        <td align='right'><strong><em>AVS Result Description: </em></strong></td>
        <td><asp:Label id=Label_AvsResponseCodeDesc runat="server"/></td>
    </tr>
    <tr>
        <td colspan='2'><hr /></td>
    </tr>

    <tr class="title">
        <td colspan="2"><p><strong>CSC Data Fields</strong></p></td>
    </tr>
    <tr>
        <td align="right"><strong><em>CSC Result Code: </em></strong></td>
        <td><asp:Label id=Label_CscResponseCode runat="server"/></td>
    </tr>
    <tr class="shade">
        <td align="right"><strong><em>CSC Result Description: </em></strong></td>
        <td><asp:Label id=Label_CscResponseCodeDesc runat="server"/></td>
    </tr>
</asp:Panel>
<asp:Panel id="Panel_StackTrace" runat=server>
<!-- only display these next fields if an stacktrace output exists-->
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr class="title">
        <td colspan="2"><p><strong>&nbsp;Exception Stack Trace</strong></p></td>
    </tr>
    <tr>
        <td colspan="2"><asp:Label id=Label_StackTrace runat="server"/></td>
    </tr>
</asp:Panel>
    <tr>
        <td width="50%">&nbsp;</td>
        <td width="50%">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="2" align="center"><asp:Label id=Label_AgainLink runat="server"/></td>
    </tr>

</table>
</form>
</body>
</html>
