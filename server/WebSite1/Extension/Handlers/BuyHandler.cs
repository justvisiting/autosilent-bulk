using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using Extension.Database;
using Extension;
using System.Xml;
using System.IO;
using iPhonePackersCommon;

namespace IphonePackers
{
    public class BuyHandler : IHttpHandler
    {
        private static string BodySkeletonFileName = Constants.rootDir + "BuyBody.htm";
        private const string paypalHostedButtonId = "7173571";
        private const string paypalDiscountHostedButtonId = "10313414";
        private const string paypalDrcHostedButtonId = "10679405";
        #region IHttpHandler Members

        public bool IsReusable
        {
            get { return true; }
        }

        public void ProcessRequest(HttpContext context)
        {
            //TODO this handler is redundant remove it
            //string paty = context.Request.RawUrl.Replace("/Buy?", "/Buy.aspx?");
            //context.RewritePath("/Buy.aspx?" + context.Request.QueryString);

            //context.Response.Write(GetBuyBlurb(context));

        }

        public static string GetBuyBlurb(HttpContext context, string price, bool showDiscount, string referralCode)
        {
            string deviceId = context.Request.QueryString["code"];
            string appId = context.Request.QueryString["appId"];

            string responseString = string.Empty;

            if (!string.IsNullOrEmpty(deviceId) && !string.IsNullOrEmpty(appId)
                && Utility.IsAlphaNumeric(deviceId) && Utility.IsAlphaNumeric(appId))
            {
                if (string.IsNullOrEmpty(appId))
                {
                    appId = Constants.DefaultAppId;
                }

                responseString = PayPayString(deviceId, appId, price, showDiscount, referralCode);
            }
            else
            {
                responseString = "Thank you for your interest in AutoSilent app. Internal error. Please try again later or contact us at contact@iphonepackers.info";
            }

            context.Response.StatusCode = 200;
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            context.Response.Cache.SetExpires(DateTime.UtcNow);

            return responseString;
        }

      
        public static string PayPayString(string deviceId, string appId, string price, bool showDiscount
            , string referralCode)
        {
            string hostedButtonStr = paypalHostedButtonId;

            if (showDiscount)
            {
                hostedButtonStr = paypalDiscountHostedButtonId;
            }

            StringBuilder rv = new StringBuilder();
            rv.AppendFormat("Thank You for considering to buy Auto Silent app. The price is USD ${0} + $0.30 (paypal charges) <br/>", price);
            rv.Append("The payment can be made using any major credit card or Paypal account.<br/>");
            /*
             * <form action="https://www.paypal.com/cgi-bin/webscr" method="post">
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" name="hosted_button_id" value="7173571">
<table>
<tr><td><input type="hidden" name="on0" value="purCode">purCode</td></tr><tr><td><input type="text" name="os0" maxlength="60"></td></tr>
<tr><td><input type="hidden" name="on1" value="aId">aId</td></tr><tr><td><input type="text" name="os1" maxlength="60"></td></tr>
</table>
<input type="image" src="https://www.paypal.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
<img alt="" border="0" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1">
</form>
*/
            /*
             * <form action="https://www.paypal.com/cgi-bin/webscr" method="post">
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" name="hosted_button_id" value="10313414">
<table>
<tr><td><input type="hidden" name="on0" value="purCode">purCode</td></tr><tr><td><input type="text" name="os0" maxlength="60"></td></tr>
<tr><td><input type="hidden" name="on1" value="aId">aId</td></tr><tr><td><input type="text" name="os1" maxlength="60"></td></tr>
</table>
<input type="image" src="https://www.paypal.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
<img alt="" border="0" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1">
</form>
*/

            /* dr.c@live.com $3.30
             * <form action="https://www.paypal.com/cgi-bin/webscr" method="post">
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" name="hosted_button_id" value="10679405">
<table>
<tr><td><input type="hidden" name="on0" value="purCode">purCode</td></tr><tr><td><input type="text" name="os0" maxlength="60"></td></tr>
<tr><td><input type="hidden" name="on1" value="aId">aId</td></tr><tr><td><input type="text" name="os1" maxlength="60"></td></tr>
</table>
<input type="image" src="https://www.paypal.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
<img alt="" border="0" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1">
</form>

*/



            rv.Append("<form action=\"https://www.paypal.com/cgi-bin/webscr\" method=\"post\">");
            rv.Append("<input type=\"hidden\" name=\"cmd\" value=\"_s-xclick\">");
            rv.AppendFormat("<input type=\"hidden\" name=\"hosted_button_id\" value=\"{0}\">", paypalDrcHostedButtonId);
            rv.Append("<input type=\"hidden\" name=\"on0\" value=\"purCode\">");
            rv.AppendFormat("<input type=\"hidden\" name=\"os0\" value=\"{0}\">"
                , HttpUtility.HtmlEncode( deviceId)); //for javascript, xss attack
            rv.AppendFormat("<input type=\"hidden\" name=\"os1\" value=\"{0}\">"
                , HttpUtility.HtmlEncode(referralCode)); //for javascript, xss attack
            rv.Append("<input type=\"image\" src=\"https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif\" border=\"0\" ");

            rv.Append("name=\"submit\" alt=\"PayPal - The safer, easier way to pay online!\">");
            rv.Append("<img alt=\"\" border=\"0\" src=\"https://www.paypal.com/en_US/i/scr/pixel.gif\" width=\"1\" height=\"1\">");
            rv.Append("</form>");

            rv.Append("You can pay from another computer by sending link of this page by email. Click on \"+\" sign at the bottom.");
            return rv.ToString();
        }

        #endregion
    }
}
