using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using Extension.Database;
using Extension;

namespace IphonePackers
{
    public class BuyHandler : IHttpHandler
    {

        #region IHttpHandler Members

        public bool IsReusable
        {
            get { return true; }
        }

        public void ProcessRequest(HttpContext context)
        {
            string deviceId = context.Request.QueryString["deviceId"];
            string appId = context.Request.QueryString["appId"];

            string responseString = string.Empty;

            if (!string.IsNullOrEmpty(deviceId))
            {
                if (string.IsNullOrEmpty(appId))
                {
                    appId = Constants.DefaultAppId;
                }

                responseString = PayPayString(deviceId, appId);
            }

            context.Response.Write(responseString);
            context.Response.StatusCode = 200;
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            context.Response.Cache.SetExpires(DateTime.UtcNow);
        }


        public static string PayPayString(string deviceId, string appId)
        {
            StringBuilder rv = new StringBuilder();
            rv.Append("Thank You for considering to make donation for Auto Silent app. Please donate between $3.00 to $9.00. <br/>");
            rv.Append("Please click link below <br/>");
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
            rv.Append("<form action=\"https://www.paypal.com/cgi-bin/webscr\" method=\"post\">");
            rv.Append("<input type=\"hidden\" name=\"cmd\" value=\"_s-xclick\">");
            rv.Append("<input type=\"hidden\" name=\"hosted_button_id\" value=\"7173571\">");
            rv.Append("<input type=\"hidden\" name=\"on0\" value=\"purCode\">");
            rv.AppendFormat("<input type=\"hidden\" name=\"os0\" value=\"{0}\">", deviceId);
            rv.AppendFormat("<input type=\"hidden\" name=\"os1\" value=\"{0}\">", appId);
            rv.Append("<input type=\"image\" src=\"https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif\" border=\"0\" ");

            rv.Append("name=\"submit\" alt=\"PayPal - The safer, easier way to pay online!\">");
            rv.Append("<img alt=\"\" border=\"0\" src=\"https://www.paypal.com/en_US/i/scr/pixel.gif\" width=\"1\" height=\"1\">");
            rv.Append("</form>");

                                
            return rv.ToString();
        }

        #endregion
    }
}
