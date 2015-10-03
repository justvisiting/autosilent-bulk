using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using iPhonePackersCommon;
using YAX;
using Extension.Database;

namespace Extension.Handlers
{
    public class ReferFriend : IHttpHandler
    {
        #region IHttpHandler Members

        public bool IsReusable
        {
            get { return true; }
        }

        public void ProcessRequest(HttpContext context)
        {
            string msg = "";
                TransactionStatus myStatus = TransactionStatus.None;
                TransactionStatus ourFriendStatus = TransactionStatus.None;
                string responseMsg = "";
                int count = 0;
            try
            {
                string myCode = context.Request.QueryString["code"];
                
                if (!string.IsNullOrEmpty(myCode))
                {
                    IphonePackers.AppVerifier verifier = new IphonePackers.AppVerifier(true, false);

                    responseMsg += verifier.GetResponseString(Constants.DefaultAppId, myCode, "", false, out myStatus);

                    if (myStatus == TransactionStatus.Completed)
                    {//save it
                        string md5Hash = ReferralCore.GetMD5Hash(myCode);
                        md5Hash = md5Hash.ToUpper();

                        count = DatabaseAccessor.GetReferralCount(myCode, md5Hash);
                    }
                }

            }
            catch (Exception e)
            {
                msg = e.Message;
            }

          
            context.Response.Write(count);
            context.Response.StatusCode = 200;
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            context.Response.Cache.SetExpires(DateTime.UtcNow);
         
        }

        #endregion
    }
}
