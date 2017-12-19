<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--

/* -----------------------------------------------------------------------------

 Version 2.0

------------------ Disclaimer --------------------------------------------------

Copyright 2004 Dialect Holdings.  All rights reserved.

This document is provided by Dialect Holdings on the basis that you will treat
it as confidential.

No part of this document may be reproduced or copied in any form by any means
without the written permission of Dialect Holdings.  Unless otherwise expressly
agreed in writing, the information contained in this document is subject to
change without notice and Dialect Holdings assumes no responsibility for any
alteration to, or any error or other deficiency, in this document.

All intellectual property rights in the Document and in all extracts and things
derived from any part of the Document are owned by Dialect and will be assigned
to Dialect on their creation. You will protect all the intellectual property
rights relating to the Document in a manner that is equal to the protection
you provide your own intellectual property.  You will notify Dialect
immediately, and in writing where you become aware of a breach of Dialect's
intellectual property rights in relation to the Document.

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

Dialect does not indemnify you or any third party in relation to the content or
any use of the content as contemplated in these terms and conditions.

Mention of any product not owned by Dialect does not constitute an endorsement
of that product.

This document is governed by the laws of New South Wales, Australia and is
intended to be legally binding.

-------------------------------------------------------------------------------
 
This example assumes that a form has been sent to this example with the
required fields. The example then processes the command and displays the
receipt or error to a HTML page in the users web browser.

*****
NOTE:
*****
 
  For jdk1.2, 1.3
  * Must have jsse.jar, jcert.jar and jnet.jar in your classpath
  * Best approach is to make them installed extensions - 
    i.e. put them in the jre/lib/ext directory.

  For jdk1.4 (jsse is already part of default installation - should run fine)

--------------------------------------------------------------------------------

 @author Dialect Payment Solutions Pty Ltd Group 

------------------------------------------------------------------------------*/

--%>
<%@ page import="com.sun.net.ssl.*,
                 java.io.*,
                 java.net.*,
                 java.util.*,
                 java.security.MessageDigest,
                 java.security.cert.X509Certificate,
                 javax.net.ssl.SSLSocket,
                 javax.net.ssl.SSLSocketFactory,
                 com.sun.net.ssl.SSLContext,
                 com.sun.net.ssl.X509TrustManager"%>

<%! // Define Static Constants
    // ***********************
    public static X509TrustManager s_x509TrustManager = null;
    public static SSLSocketFactory s_sslSocketFactory = null;
    
    static {
            s_x509TrustManager = new X509TrustManager() {
            public X509Certificate[] getAcceptedIssuers() { return new X509Certificate[] {}; } 
            public boolean isClientTrusted(X509Certificate[] chain) { return true; } 
            public boolean isServerTrusted(X509Certificate[] chain) { return true; } 
        };

        java.security.Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
        try {
            SSLContext context = SSLContext.getInstance("TLS");
            context.init(null, new X509TrustManager[] { s_x509TrustManager }, null);
            s_sslSocketFactory = context.getSocketFactory();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        }
    }

//  ----------------------------------------------------------------------------

   /**
    * This method is for performing a Form POST operation from input data parameters.
    *
    * @param vpc_Host  - is a String containing the vpc URL
    * @param data      - is a String containing the post data key value pairs
    * @param useProxy  - is a boolean indicating if a Proxy Server is involved in the transfer
    * @param proxyHost - is a String containing the IP address of the Proxy to send the data to
    * @param proxyPort - is an integer containing the port number of the Proxy socket listener
    * @return          - is body data of the POST data response    
    */
    public static String doPost(String vpc_Host, String data,  
                  boolean useProxy, String proxyHost, int proxyPort) throws IOException {

        InputStream is;
        OutputStream os;
        int vpc_Port = 443; 
        String fileName = "";
        boolean useSSL = false;
        
        // determine if SSL encryption is being used
        if (vpc_Host.substring(0,8).equalsIgnoreCase("HTTPS://")) {
            useSSL= true;
            // remove 'HTTPS://' from host URL
            vpc_Host = vpc_Host.substring(8);
            // get the filename from the last section of vpc_URL
            fileName = vpc_Host.substring(vpc_Host.lastIndexOf("/"));
            // get the IP address of the VPC machine
            vpc_Host = vpc_Host.substring(0,vpc_Host.lastIndexOf("/"));
        }
        
        // use the next block of code if using a proxy server
        if (useProxy) {
            Socket s = new Socket(proxyHost, proxyPort);
            os = s.getOutputStream();
            is = s.getInputStream();
            // use next block of code if using SSL encryption
            if (useSSL) {
                String msg = "CONNECT " + vpc_Host + ":" + vpc_Port + " HTTP/1.0\r\n" + "User-Agent: HTTP Client\r\n\r\n";
                os.write(msg.getBytes());
                byte[] buf = new byte[4096];
                int len = is.read(buf);
                String res = new String(buf, 0, len);

                // check if a successful HTTP connection
                if (res.indexOf("200") < 0) {
                    throw new IOException("Proxy would now allow connection - " + res);
                }
                
                // write output to VPC
                SSLSocket ssl = (SSLSocket)s_sslSocketFactory.createSocket(s, vpc_Host, vpc_Port, true);
                ssl.startHandshake();
                os = ssl.getOutputStream();
                // get response data from VPC
                is = ssl.getInputStream();
            // use the next block of code if NOT using SSL encryption
            } else {
                fileName = vpc_Host;
            }
        // use the next block of code if NOT using a proxy server
        } else {
            // use next block of code if using SSL encryption
            if (useSSL) {
                Socket s = s_sslSocketFactory.createSocket(vpc_Host, vpc_Port);
                os = s.getOutputStream();
                is = s.getInputStream();
            // use next block of code if NOT using SSL encryption
            } else {
                Socket s = new Socket(vpc_Host, vpc_Port);
                os = s.getOutputStream();
                is = s.getInputStream();
            }
        }
        
        String req = "POST " + fileName + " HTTP/1.0\r\n"
                             + "User-Agent: HTTP Client\r\n"
                             + "Content-Type: application/x-www-form-urlencoded\r\n"
                             + "Content-Length: " + data.length() + "\r\n\r\n"
                             + data;

        os.write(req.getBytes());
        String res = new String(readAll(is));

        // check if a successful connection
        if (res.indexOf("200") < 0) {
            throw new IOException("Connection Refused - " + res);
        }
        
        if (res.indexOf("404 Not Found") > 0) {
            throw new IOException("File Not Found Error - " + res);
        }
        
        int resIndex = res.indexOf("\r\n\r\n");
        String body = res.substring(resIndex + 4, res.length());
        return body;
    }       

//  ----------------------------------------------------------------------------

   /**
    * This method is for creating a byte array from input stream data.
    *
    * @param is - the input stream containing the data
    * @return is the byte array of the input stream data    
    */
    private static byte[] readAll(InputStream is) throws IOException {
        
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buf = new byte[1024];
        
        while (true) {
            int len = is.read(buf);
            if (len < 0) {
                break;
            }
            baos.write(buf, 0, len);
        }
        return baos.toByteArray();
    }

//  ----------------------------------------------------------------------------

   /**
    * This method is for creating a URL POST data string.
    *
    * @param fields is the input parameters from the order page
    * @return is the output String containing POST data key value pairs    
    */
    private String createPostDataFromMap(Map fields) {
        StringBuffer buf = new StringBuffer();

        String ampersand = "";

        // append all fields in a data string
        for (Iterator i = fields.keySet().iterator(); i.hasNext(); ) {
            
            String key = (String)i.next();
            String value = (String)fields.get(key);
            
            if ((value != null) && (value.length() > 0)) {
                // append the parameters
                buf.append(ampersand);
                buf.append(URLEncoder.encode(key));
                buf.append('=');
                buf.append(URLEncoder.encode(value));
            }
            ampersand = "&";
        }

        // return string 
        return buf.toString();    
    }

//  ----------------------------------------------------------------------------
   
   /**
    * This method is for creating a URL POST data string.
    *
    * @param queryString is the input String from POST data response
    * @return is a Hashmap of Post data response inputs    
    */
    private Map createMapFromResponse(String queryString) {
        Map map = new HashMap();
        StringTokenizer st = new StringTokenizer(queryString, "&");
        while (st.hasMoreTokens()) {
            String token = st.nextToken();
            int i = token.indexOf('=');
            if (i > 0) {
                try {
                    String key = token.substring(0, i);
                    String value = URLDecoder.decode(token.substring(i + 1, token.length()));
                    map.put(key, value);
                } catch (Exception ex) {
                    // Do Nothing and keep looping through data
                }
            }
        }
        return map;
    }
//  ----------------------------------------------------------------------------

   /*
    * This method takes a data String and returns a predefined value if empty
    * If data Sting is null, returns string "No Value Returned", else returns input
    *
    * @param in String containing the data String
    * @return String containing the output String
    */
    private static String null2unknown(String in, Map responseFields) {
      if (in == null || in.length() == 0 || (String)responseFields.get(in) == null) {
            return "No Value Returned";
        } else {
            return (String)responseFields.get(in);
        }
    } // null2unknown()
    
//  ----------------------------------------------------------------------------
    
   /*
    * This function uses the returned status code retrieved from the Digital
    * Response and returns an appropriate description for the code
    *
    * @param vResponseCode String containing the vpc_TxnResponseCode
    * @return description String containing the appropriate description
    */ 
    String getResponseDescription(String vResponseCode) {

        String result = "";

        // check if a single digit response code
        if (vResponseCode.length() == 1) {
        
            // Java cannot switch on a string so turn everything to a char
            char input = vResponseCode.charAt(0);

            switch (input){
                case '0' : result = "Transaction Successful"; break;
                case '1' : result = "Unknown Error"; break;
                case '2' : result = "Bank Declined Transaction"; break;
                case '3' : result = "No Reply from Bank"; break;
                case '4' : result = "Expired Card"; break;
                case '5' : result = "Insufficient Funds"; break;
                case '6' : result = "Error Communicating with Bank"; break;
                case '7' : result = "Payment Server System Error"; break;
                case '8' : result = "Transaction Type Not Supported"; break;
                case '9' : result = "Bank declined transaction (Do not contact Bank)"; break;
                case 'A' : result = "Transaction Aborted"; break;
                case 'C' : result = "Transaction Cancelled"; break;
                case 'D' : result = "Deferred transaction has been received and is awaiting processing"; break;
                case 'F' : result = "3D Secure Authentication failed"; break;
                case 'I' : result = "Card Security Code verification failed"; break;
                case 'L' : result = "Shopping Transaction Locked (Please try the transaction again later)"; break;
                case 'N' : result = "Cardholder is not enrolled in Authentication Scheme"; break;
                case 'P' : result = "Transaction has been received by the Payment Adaptor and is being processed"; break;
                case 'R' : result = "Transaction was not processed - Reached limit of retry attempts allowed"; break;
                case 'S' : result = "Duplicate SessionID (OrderInfo)"; break;
                case 'T' : result = "Address Verification Failed"; break;
                case 'U' : result = "Card Security Code Failed"; break;
                case 'V' : result = "Address Verification and Card Security Code Failed"; break;
                case '?' : result = "Transaction status is unknown"; break;
                default  : result = "Unable to be determined";
            }
            
            return result;
        } else {
            return "No Value Returned";
        }
    } // getResponseDescription()


//  ----------------------------------------------------------------------------
   
   /**
    * This method uses the 3DS verStatus retrieved from the 
    * Response and returns an appropriate description for this code.
    *
    * @param vpc_VerStatus String containing the status code
    * @return description String containing the appropriate description
    */
    private String getStatusDescription(String vStatus) {

        String result = "";
        if (vStatus != null && !vStatus.equals("")) {

            // Java cannot switch on a string so turn everything to a character
            char input = vStatus.charAt(0);

            switch (input){
                case 'Y'  : result = "The cardholder was successfully authenticated."; break;
                case 'E'  : result = "The cardholder is not enrolled."; break;
                case 'N'  : result = "The cardholder was not verified."; break;
                case 'U'  : result = "The cardholder's Issuer was unable to authenticate due to some system error at the Issuer."; break;
                case 'F'  : result = "There was an error in the format of the request from the merchant."; break;
                case 'A'  : result = "Authentication of your Merchant ID and Password to the ACS Directory Failed."; break;
                case 'D'  : result = "Error communicating with the Directory Server."; break;
                case 'C'  : result = "The card type is not supported for authentication."; break;
                case 'S'  : result = "The signature on the response received from the Issuer could not be validated."; break;
                case 'P'  : result = "Error parsing input from Issuer."; break;
                case 'I'  : result = "Internal Payment Server system error."; break;
                default   : result = "Unable to be determined"; break;
            }
        } else {
            result = "null response";
        }
        return result;
    }

//  ----------------------------------------------------------------------------
   
%><%// *******************************************
    // START OF MAIN PROGRAM
    // *******************************************

    // Define Variables
    // If using a proxy server you must set the following variables
    // If NOT using a proxy server then set the 'useProxy' to false
    boolean useProxy = false;
    
    // You would need to add you own proxy server URL and port here
    String proxyHost = "192.168.21.13";
    int proxyPort = 80;

    // retrieve all the parameters into a hash map
    Map requestFields = new HashMap();
    for (Enumeration enum = request.getParameterNames(); enum.hasMoreElements();) {
        String fieldName = (String) enum.nextElement();
        String fieldValue = request.getParameter(fieldName);
        if ((fieldValue != null) && (fieldValue.length() > 0)) {
            requestFields.put(fieldName, fieldValue);
        }
    }
    
    // no need to send the vpcURL, Title and Submit Button to the vpc
    String vpcURL = (String) requestFields.remove("virtualPaymentClientURL");
    String title  = (String) requestFields.remove("Title");
    requestFields.remove("SubButL");
    
    // Retrieve the order page URL from the incoming order page. This is only  
    // here to give the user the easy ability to go back to the Order page. 
    // This would not be required in a production system.
    String againLink = request.getHeader("Referer");

    // create the post data string to send
    String postData = createPostDataFromMap(requestFields);

    String resQS = "";
    String message = "";

    try {
        // create a URL connection to the Virtual Payment Client
        resQS = doPost(vpcURL, postData, useProxy, proxyHost, proxyPort);

    } catch (Exception ex) {
        // The response is an error message so generate an Error Page
        message = ex.toString();
    } //try-catch

    // create a hash map for the response data
    Map responseFields = createMapFromResponse(resQS);

    // Extract the available receipt fields from the VPC Response
    // If not present then let the value be equal to 'No Value returned'
    // Not all data fields will return values for all transactions.

    // don't overwrite message if any error messages detected
    if (message.length() == 0) {
        message            = null2unknown("vpc_Message", responseFields);
    }

    // Standard Receipt Data
       // merchTxnRef not always returned in response if no receipt so get input
    String merchTxnRef     = request.getParameter("vpc_MerchTxnRef");
    
    String amount          = null2unknown("vpc_Amount", responseFields);
    String locale          = null2unknown("vpc_Locale", responseFields);
    String batchNo         = null2unknown("vpc_BatchNo", responseFields);
    String command         = null2unknown("vpc_Command", responseFields);
    String version         = null2unknown("vpc_Version", responseFields);
    String cardType        = null2unknown("vpc_Card", responseFields);
    String orderInfo       = null2unknown("vpc_OrderInfo", responseFields);
    String receiptNo       = null2unknown("vpc_ReceiptNo", responseFields);
    String merchantID      = null2unknown("vpc_Merchant", responseFields);
    String authorizeID     = null2unknown("vpc_AuthorizeId", responseFields);
    String transactionNo   = null2unknown("vpc_TransactionNo", responseFields);
    String acqResponseCode = null2unknown("vpc_AcqResponseCode", responseFields);
    String txnResponseCode = null2unknown("vpc_TxnResponseCode", responseFields);


    // 3-D Secure Data
    String transType3DS       = null2unknown("vpc_VerType", responseFields);
    String verStatus3DS       = null2unknown("vpc_VerStatus", responseFields);
    String token3DS           = null2unknown("vpc_VerToken", responseFields);
    String secureLevel3DS  = null2unknown("vpc_VerSecurityLevel", responseFields);
    String enrolled3DS       = null2unknown("vpc_3DSenrolled", responseFields);
    String xid3DS           = null2unknown("vpc_3DSXID", responseFields);
    String eci3DS           = null2unknown("vpc_3DSECI", responseFields);
    String status3DS       = null2unknown("vpc_3DSstatus", responseFields);
    
    // Financial Transaction Data
    String shopTransNo     = null2unknown("vpc_ShopTransactionNo", responseFields);
    String authorisedAmount= null2unknown("vpc_AuthorisedAmount", responseFields);
    String capturedAmount  = null2unknown("vpc_CapturedAmount", responseFields);
    String refundedAmount  = null2unknown("vpc_RefundedAmount", responseFields);
    String ticketNumber    = null2unknown("vpc_TicketNo", responseFields);

    // Specific QueryDR Data
    String drExists        = null2unknown("vpc_DRExists", responseFields);
    String multipleDRs     = null2unknown("vpc_FoundMultipleDRs", responseFields);

    String error = "";
    // Show this page as an error page if error condition
    if (txnResponseCode.equals("7") || txnResponseCode.equals("No Value Returned")) {
        error = "Error ";
    }
    
    // only display aAMA fields if a Capture or Refund transaction
    boolean amaTransaction = true;
    if (shopTransNo.equals("No Value Returned")) {
        amaTransaction =false;
    }
        
    // FINISH TRANSACTION - Process the VPC Response Data
    // =====================================================
    // For the purposes of demonstration, we simply display the Result fields on a
    // web page.
%>  <!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>
    <html>
    <head><title><%=title%> - VPC Response <%=error%>Page</title>
        <meta http-equiv='Content-Type' content='text/html, charset=iso-8859-1'>
        <style type='text/css'>
            <!--
            h1       { font-family:Arial,sans-serif; font-size:24pt; color:#08185A; font-weight:100}
            h2.co    { font-family:Arial,sans-serif; font-size:24pt; color:#08185A; margin-top:0.1em; margin-bottom:0.1em; font-weight:100}
            h3.co    { font-family:Arial,sans-serif; font-size:16pt; color:#000000; margin-top:0.1em; margin-bottom:0.1em; font-weight:100}
            body     { font-family:Verdana,Arial,sans-serif; font-size:10pt; color:#08185A background-color:#FFFFFF }
            p        { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#FFFFFF }
            a:link   { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A }
            a:visited{ font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A }
            a:hover  { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#FF0000 }
            a:active { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#FF0000 }
            td       { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A }
            TD.red   { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#FF0066 }
            TD.green { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#00AA00 }
            th       { font-family:Verdana,Arial,sans-serif; font-size:10pt; color:#08185A; font-weight:bold; background-color:#CED7EF; padding-top:0.5em; padding-bottom:0.5em}
            input    { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A; background-color:#CED7EF; font-weight:bold }
            select   { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A; background-color:#CED7EF; font-weight:bold; width:463 }
            textarea { font-family:Verdana,Arial,sans-serif; font-size:8pt; color:#08185A; background-color:#CED7EF; font-weight:normal; scrollbar-arrow-color:#08185A; scrollbar-base-color:#CED7EF }
            -->
        </style>
    </head>
    <body>
    
    <!-- Start Branding Table -->
    <table width='100%' border='2' cellpadding='2' bgcolor='#0074C4'><tr><td bgcolor='#CED7EF' width='90%'><h2 class='co'>&nbsp;Virtual Payment Client Example</h2></td><td bgcolor='#0074C4' align='center'><h3 class='co'>Dialect<br/>Solutions</h3></td></tr></table>
    <!-- End Branding Table -->
    
    <center><h1><%=title%> - <%=error%>Response Page</H1></center>
    
    <table width="75%" align='center' cellpadding='5' border='0'>
      
        <tr bgcolor="#0074C4">
            <td colspan="2" height="25"><p><strong>&nbsp;QueryDR Transaction Fields</strong></p></td>
        </tr>
        <tr>
            <td align='right' width='50%'><strong><i>VPC API Version: </i></strong></td>
            <td width='50%'><%=version%></td>
        </tr>
        <tr bgcolor='#CED7EF'>                  
            <td align='right'><strong><i>Command: </i></strong></td>
            <td><%=command%></td>
        </tr>
        <tr>
            <td align='right'><strong><i>Merchant Transaction Reference: </i></strong></td>
            <td><%=merchTxnRef%></td>
        </tr>
        <tr bgcolor='#CED7EF'>
            <td align='right'><strong><i>Merchant ID: </i></strong></td>
            <td><%=merchantID%></td>
        </tr>
        <tr>
            <td align='right'><strong><i>Transaction Amount: </i></strong></td>
            <td><%=amount%></td>
        </tr>
      
        <tr>
            <td colspan='2' align='center'><font color='#0074C4'>Fields above are the request values returned.<br/><hr/>
                Fields immediately below are additional special fields for QueryDR functionality.</font><br/></td>
        </tr>

      
        <tr bgcolor="#0074C4">
            <td colspan="2" height="25"><p><strong>&nbsp;QueryDR Only Fields</strong></p></td>
        </tr>
        <tr>                  
            <td align='right'><strong><i>Receipt Exists: </i></strong></td>
            <td><%=drExists%></td>
        </tr>
        <tr bgcolor='#CED7EF'>
            <td align='right'><strong><i>Found Multiple Receipts: </i></strong></td>
            <td><%=multipleDRs%></td>
        </tr>
<% // No need to display any more response fields if no receipt present
   if (!drExists.equalsIgnoreCase("N")) {
%>        <tr>
            <td colspan='2' align='center'><font color='#0074C4'><hr/>
                Fields below are for a Standard Transaction.</font><br/></td>
        </tr>
        
        <tr bgcolor="#0074C4">
            <td colspan="2" height="25"><p><strong>&nbsp;Standard Transaction Fields</strong></p></td>
        </tr>
  
        <tr bgcolor='#CED7EF'>                  
            <td align='right'><strong><i>VPC Transaction Response Code: </i></strong></td>
            <td><%=txnResponseCode%></td>
        </tr>
        <tr>
            <td align='right'><strong><i>Transaction Response Code Description: </i></strong></td>
            <td><%=getResponseDescription(txnResponseCode)%></td>
        </tr>
        <tr bgcolor='#CED7EF'>                  
            <td align='right'><strong><i>Message: </i></strong></td>
            <td><%=message%></td>
        </tr>
<%
    // only display the following fields if not an error condition
    if (!txnResponseCode.equals("7") && !txnResponseCode.equals("No Value Returned") && drExists.equalsIgnoreCase("Y")) { 
%>
        <tr>                  
            <td align='right'><strong><i>Order Information: </i></strong></td>
            <td><%=orderInfo%></td>
        </tr>
        <tr bgcolor='#CED7EF'>
            <td align='right'><strong><i>Receipt Number: </i></strong></td>
            <td><%=receiptNo%></td>
        </tr>
        <tr>                  
            <td align='right'><strong><i>Transaction Number: </i></strong></td>
            <td><%=transactionNo%></td>
        </tr>
        <tr bgcolor='#CED7EF'>
            <td align='right'><strong><i>Acquirer Response Code: </i></strong></td>
            <td><%=acqResponseCode%></td>
        </tr>
        <tr>                  
            <td align='right'><strong><i>Bank Authorization ID: </i></strong></td>
            <td><%=authorizeID%></td>
        </tr>
        <tr bgcolor='#CED7EF'>
            <td align='right'><strong><i>Batch Number: </i></strong></td>
            <td><%=batchNo%></td>
        </tr>
        <tr>                  
            <td align='right'><strong><i>Card Type: </i></strong></td>
            <td><%=cardType%></td>
        </tr>
      
        <tr>
            <td colspan='2' align='center'><font color='#0074C4'>Fields above are for Standard Transactions<br/><hr/>
                Fields below are additional fields for extra functionality.</font><br/></td>
        </tr>

<%        if (amaTransaction) { %>

            <tr bgcolor="#0074C4">
                <td colspan="2" height="25"><p><strong>&nbsp;Financial Transaction Fields</strong></p></td>
            </tr>
          
            <tr>
                <td align='right'><strong><i>Shopping Transaction Number: </i></strong></td>
                <td><%=shopTransNo%></td>
            </tr>
            <tr bgcolor='#CED7EF'>
                <td align='right'><strong><i>Authorised Amount: </i></strong></td>
                <td><%=authorisedAmount%></td>
            </tr>
            <tr>
                <td align='right'><strong><i>Captured Amount: </i></strong></td>
                <td><%=capturedAmount%></td>
            </tr>
            <tr bgcolor='#CED7EF'>
                <td align='right'><strong><i>Refunded Amount: </i></strong></td>
                <td><%=refundedAmount%></td>
            </tr>
            <tr>
                <td align='right'><strong><i>Ticket Number: </i></strong></td>
                <td><%=ticketNumber%></td>
            </tr>

    <%  } else { %>
            
            <tr>
                <td colspan = '2'><hr/></td>
            </tr>
          
            <tr bgcolor="#0074C4">
                <td colspan="2" height="25"><p><strong>&nbsp;3-D Secure Authentication Fields</strong></p></td>
            </tr>
            <tr>
                <td align='right'><i><strong>Authentication Version</strong><br/>(3DS - Visa or SPA - MasterCard): </i></td>
                <td class='red'><%=transType3DS%></td>
            </tr>
            <tr bgcolor='#CED7EF'>
                <td align='right'><strong><i>Authentication Status: </i></strong></td>
                <td class='red'><%=verStatus3DS%></td>
            </tr>
            <tr>
                <td align='right'><strong><i>Authentication Token: </i></strong></td>
                <td class='red'><%=token3DS%></td>
            </tr>
            <tr bgcolor='#CED7EF'>
                <td align='right'><strong><i>Authentication XID: </i></strong></td>
                <td class='red'><%=xid3DS%></td>
            </tr>
            <tr>
                <td align='right'><strong><i>Authentication ECI: </i></strong></td>
                <td class='red'><%=eci3DS%></td>
            </tr>
            <tr bgcolor='#CED7EF'>
                <td align="right">
                    <strong><i>3DS CardHolder Enrolled: </strong>
                    <br />
                    <font size="1">Takes values: <strong>Y</strong> - Yes <strong>N</strong> - No</i></font>
                </td>
                <td class='red'><%=enrolled3DS%></td>
            </tr>
            <tr>
                <td align="right">
                    <i><strong>Authenticated Successfully: </strong><br />
                    <font size="1">Only returned if CardHolder Enrolled = <strong>Y</strong>. Takes values:<br />
                    <strong>Y</strong> - Yes <strong>N</strong> - No <strong>A</strong> - Attempted to Check <strong>U</strong> - Unavailable for Checking</font></i>
                </td>
                <td class='red'><%=status3DS%></td>
            </tr>
            <tr bgcolor='#CED7EF'>
                <td align='right'><strong><i>Authentication Security Level: </i></strong></td>
                <td class='red'><%=secureLevel3DS%></td>
            </tr>
            <tr>    
                <td align='right'><strong><i>Payment Server 3DS Authentication Status Code: </i></strong></td>
                <td class='green'><%=verStatus3DS%></td>
            </tr>
            <tr bgcolor='#CED7EF'>    
                <td align='right'><i><strong>3DS Authentication Status Code Description: </strong></i></td>
                <td class='green'><%=getStatusDescription(verStatus3DS)%></td>
            </tr>
            <tr>
                <td colspan="2" align="center" valign="middle">
                    <font color='#FF0066'>The 3-D Secure values shown in red are those values that are important values to store in case of future transaction repudiation.</font>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center" valign="middle">
                    <font color='#00AA00'>The 3-D Secure values shown in green are for information only and are not required to be stored.</font>
                </td>
            </tr>
<%        }
    }
}    %>
    </table><br/>
    
    <center><P><A HREF='<%=againLink%>'>New Transaction</A></P></center>
    
    </body>
    </html>
