using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace CydiaPublic
{
    public enum Status
    {
        Completed = 0,
        Failed = 1, //transaction was not completed successfully
        Error = 2, //status of the transaction could not be obtained
        Pending = 3, //status of the transaction is pending
        // Reversed = 4, //transaction was reversed 
    }

    public class VerifyApp : IHttpHandler
    {
        #region IHttpHandler Members

        public bool IsReusable
        {
            get { return false; }
        }

        public void ProcessRequest(HttpContext context)
        {
            string appId = context.Request.QueryString["appId"];
            string version = context.Request.QueryString["version"];
            string code = context.Request.QueryString["code"];

            int rv = (int)Status.Error;
            if (appId == "TestCompleted")
            {
                rv = (int)Status.Completed;
            }
            if (appId == "TestFailed")
            {
                rv = (int)Status.Failed;
            }
            if (appId == "TestError")
            {
                rv = (int)Status.Error;
            }
            if (appId == "TestPending")
            {
                rv = (int)Status.Pending;
            }
            
            string response = "Status=" + rv.ToString();
            context.Response.Write(response);
            context.Response.StatusCode = 200;
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            context.Response.Cache.SetExpires(DateTime.UtcNow);

        }

    }

        #endregion
}

