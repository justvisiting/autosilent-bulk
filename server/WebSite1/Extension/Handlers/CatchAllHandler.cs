using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace IphonePackers
{
    public class CatchAllHandler : IHttpHandler
    {
        #region IHttpHandler Members

        public bool IsReusable
        {
            get { return true; }
        }

        public void ProcessRequest(HttpContext context)
        {
            context.Response.Write("Thanks");
            context.Response.StatusCode = 200;
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            context.Response.Cache.SetExpires(DateTime.UtcNow);
        }

        #endregion
    }
}
