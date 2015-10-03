using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using Extension;
using System.Net;
using iPhonePackersCommon;

namespace IphonePackers
{
    public class LogDiagnosticsHandler : IHttpHandler
    {
        #region IHttpHandler Members

        public bool IsReusable
        {
            get { return true; }
        }

        public void ProcessRequest(HttpContext context)
        {
            string code = context.Request.QueryString["code"];
            string file = context.Request.QueryString["file"];
            string app = context.Request.QueryString["appId"];
            string version = context.Request.QueryString["v"];

            HttpStatusCode statuscode = Diagnostics.GetDataToStore(code, file, context);

            if (statuscode != HttpStatusCode.OK)
            {
                Utility.AddElement(context, statuscode.ToString());
            }

            context.Response.StatusCode = (int)statuscode;
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            context.Response.Cache.SetExpires(DateTime.UtcNow);
         
        }

        #endregion
    }
}
