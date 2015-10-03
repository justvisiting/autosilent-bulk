using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Net;
using System.IO;
using Extension;
using YAX;

namespace IphonePackers
{
    public class ConfirmPaymentHandler : IHttpHandler
    {

        #region IHttpHandler Members

        public bool IsReusable
        {
            get { return true; }
        }

        public void ProcessRequest(HttpContext context)
        {

            if (IsNotificationFromPayPal(context.Request))
            {
                string response = ProcessForm(context);
                //context.Response.Write(response);
            }

            context.Response.StatusCode = 200;
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            context.Response.Cache.SetExpires(DateTime.UtcNow);
        }

        static string receiverEmail = @"ne_hits_luver@yahoo.co.in";
        static double minAmount = 3;
        static string currencyCode = "USD";

        private static string Encode(string oldValue)
        {
            string newValue = oldValue.Replace("\"", "'");
            newValue = System.Web.HttpUtility.UrlEncode(newValue);
            newValue = newValue.Replace("%2f", "/");
            return newValue;
        }
  

        public static string ProcessForm(HttpContext context)
        {
            File.WriteAllText(Constants.logDir + DateTime.UtcNow.Millisecond.ToString() + ".txt"
                , "req recieved");
            StringBuilder bogusreason = new StringBuilder();

            if (context.Request.RequestType == "POST")
            {
                //verify receiver
                if (string.Compare(context.Request.Params["receiver_email"], receiverEmail, true) != 0)
                {
                    bogusreason.Append("invalid receiver");
                }

                

                string deviceId = context.Request.Params["option_selection1"];

                string appId = context.Request.Params["option_selection2"];

                string transactionId = context.Request.Params["txn_id"];

                if (string.IsNullOrEmpty(transactionId))
                {
                    bogusreason.Append("invalid trans id");
                }

                //verify payment status
                string paymentStatus = context.Request.Params["payment_status"];
                if (string.Compare(paymentStatus, Constants.successPaymentSatus, true) != 0)
                {
                    bogusreason.Append("payment status not complete");
                }
                else
                {//check it is not repeated transaction id
                    //verify txn_id is not repeated
                    bool isRepeated = PaymentProcessor.IsCompletedTransId(transactionId);
                    if (isRepeated)
                    {
                        bogusreason.Append("repeated transaction Id");
                    }
                }

                string firstName = context.Request.Params["first_name"];

                string lastName = context.Request.Params["last_name"];

                

                //verify trans type
                if (String.Compare(context.Request.Params["txn_type"],
                    "web_accept", false) != 0)
                {
                    bogusreason.Append("invalid tran type");
                }

                string payAmountStr = context.Request.Params["mc_gross"];

                double payAmount;

                if (!double.TryParse(payAmountStr, out payAmount) || payAmount < minAmount)
                {
                    bogusreason.Append("payment not enough");
                }

                if (string.Compare(context.Request.Params["mc_currency"], currencyCode, true) != 0)
                {
                    bogusreason.Append("invalid currency");
                }

                string payerEMail = context.Request.Params["payer_email"];


                if (bogusreason.Length == 0)
                {
                    PaymentProcessor.AddTransactionInfo(new Payment(appId, transactionId, deviceId, paymentStatus, payAmount.ToString(), payerEMail, null, firstName, lastName));
                }
                else
                {
                    File.WriteAllText(Constants.logDir + DateTime.UtcNow.Ticks.ToString(),
                         bogusreason.ToString());
                }

                return null;
               
            }

            return null;
        }

        
        public static bool IsNotificationFromPayPal(HttpRequest Request)
        {
            //Post back to either sandbox or live
            string strSandbox = "https://www.sandbox.paypal.com/cgi-bin/webscr";
            string strLive = "https://www.paypal.com/cgi-bin/webscr";
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(strLive);

            //Set values for the request back
            req.Method = "POST";
            req.ContentType = "application/x-www-form-urlencoded";
            byte[] param = Request.BinaryRead(HttpContext.Current.Request.ContentLength);
            string strRequest = Encoding.ASCII.GetString(param);
            strRequest += "&cmd=_notify-validate";
            req.ContentLength = strRequest.Length;

            File.WriteAllText(GetFilePath("reqbody"), strRequest);

            //for proxy
            //WebProxy proxy = new WebProxy(new Uri("http://url:port#"));
            //req.Proxy = proxy;

            //Send the request to PayPal and get the response
            string strResponse = null;
            string filePath = null;

            try
            {
                StreamWriter streamOut = new StreamWriter(req.GetRequestStream(), System.Text.Encoding.ASCII);
                streamOut.Write(strRequest);
                streamOut.Close();
                StreamReader streamIn = new StreamReader(req.GetResponse().GetResponseStream());
                strResponse = streamIn.ReadToEnd();
                streamIn.Close();
                filePath = GetFilePath("payPalValidateResponse");
                File.WriteAllText(filePath, strResponse);
            }
            catch (WebException webex)
            {
                if (webex.Response != null)
                {
                    StreamReader reader = new StreamReader(webex.Response.GetResponseStream());
                    string result = string.Empty;
                    if (reader != null)
                    {
                        result = reader.ReadToEnd();
                    }

                    filePath = GetFilePath("error");
                    File.WriteAllText(filePath, result);
                }

            }
            catch (Exception ex)
            {
                filePath = GetFilePath("error");
                File.WriteAllText(filePath, ex.ToString());
            }


            if (strResponse == "VERIFIED")
            {
                //check the payment_status is Completed
                //check that txn_id has not been previously processed
                //check that receiver_email is your Primary PayPal email
                //check that payment_amount/payment_currency are correct
                //process payment
                return true;
            }
            else if (strResponse == "INVALID")
            {
                //log for manual investigation
            }
            else
            {
                //log response/ipn data for manual investigation
            }

            return false;
        }

        private static object getFileLockObj = new object();

        private static string GetFilePath(string type)
        {
            lock (getFileLockObj)
            {
                return Constants.logDir + DateTime.Now.Ticks.ToString() +
                                 type + ".txt";
            }
        }
    }

}

        #endregion
