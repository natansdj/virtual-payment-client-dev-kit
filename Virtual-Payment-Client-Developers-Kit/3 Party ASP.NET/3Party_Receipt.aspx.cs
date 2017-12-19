using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace _TNS
{
    public partial class _ThreePartyReceipt : System.Web.UI.Page
    {
        public static string Version
        {
            get
            {
                // Return the Example Code Version
                return "MasterCard 2.0";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlReceiptError.Visible = false;
                pnlResponse.Visible = false;
            }
         
            try
            {
                // Create a new VPCRequest object
                VPCRequest conn = new VPCRequest();
                     
                // Process the response received
                conn.Process3PartyResponse(Page.Request.QueryString);

                // Check if the transaction was successful or if there was an error
                String vpc_TxnResponseCode = conn.GetResultField("vpc_TxnResponseCode", "Unknown");

                // Set the display fields for the receipt with the result fields
                // Core Fields
                Label_vpc_TxnResponseCode.Text = vpc_TxnResponseCode;
                Label_vpc_MerchTxnRef.Text = conn.GetResultField("vpc_MerchTxnRef", "Unknown");
                Label_vpc_OrderInfo.Text = conn.GetResultField("vpc_OrderInfo", "Unknown");
                Label_vpc_Merchant.Text = conn.GetResultField("vpc_Merchant", "Unknown");
                Label_vpc_Amount.Text = conn.GetResultField("vpc_Amount", "Unknown");
                Label_vpc_Message.Text = conn.GetResultField("vpc_Message", "Unknown");
                Label_vpc_ReceiptNo.Text = conn.GetResultField("vpc_ReceiptNo", "Unknown");
                Label_vpc_AcqResponseCode.Text = conn.GetResultField("vpc_AcqResponseCode", "Unknown");
                Label_vpc_AuthorizeId.Text = conn.GetResultField("vpc_AuthorizeId", "Unknown");
                Label_vpc_BatchNo.Text = conn.GetResultField("vpc_BatchNo", "Unknown");
                Label_vpc_TransactionNo.Text = conn.GetResultField("vpc_TransactionNo", "Unknown");
                Label_vpc_Card.Text = conn.GetResultField("vpc_Card", "Unknown");
                Label_vpc_3DSECI.Text = conn.GetResultField("vpc_3DSECI", "Unknown");
                Label_vpc_3DSXID.Text = conn.GetResultField("vpc_3DSXID", "Unknown");
                Label_vpc_3DSenrolled.Text = conn.GetResultField("vpc_3DSenrolled", "Unknown");
                Label_vpc_3DSstatus.Text = conn.GetResultField("vpc_3DSstatus", "Unknown");
                Label_vpc_VerToken.Text = conn.GetResultField("vpc_VerToken", "Unknown");
                Label_vpc_VerType.Text = conn.GetResultField("vpc_VerType", "Unknown");
                Label_vpc_VerSecurityLevel.Text = conn.GetResultField("vpc_VerSecurityLevel", "Unknown");
                Label_vpc_VerStatus.Text = conn.GetResultField("vpc_VerStatus", "Unknown");
                Label_vpc_RiskOverallResult.Text = conn.GetResultField("vpc_RiskOverallResult", "Unknown");
                Label_vpc_TxnReversalResult.Text = conn.GetResultField("vpc_TxnReversalResult", "No Value Returned");
                Label_TxnResponseCodeDesc.Text = PaymentCodesHelper.GetTxnResponseCodeDescription(Label_vpc_TxnResponseCode.Text);

                // Card Security Code Fields
                Label_vpc_cscResultCode.Text = conn.GetResultField("vpc_cscResultCode", "Unknown");
                Label_cscResultCodeDesc.Text = PaymentCodesHelper.GetCSCDescription(Label_vpc_cscResultCode.Text);

                // Display the response fields
                pnlResponse.Visible = true;

            }
            catch (Exception ex)
            {
                // Capture the error and display the error information
                lblReceiptErrorMessage.Text = ex.Message + (ex.InnerException != null ? ex.InnerException.Message : "");
                pnlReceiptError.Visible = true;
               }
        }
    }
}
