﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace Extension
{
    public class Global : HttpApplication
    {

        void Application_BeginRequest(object sender, EventArgs e)
        {
            string fullOrigionalpath = Request.Path;

            if (fullOrigionalpath.Contains("/Buy"))
            {
                string paty = Context.Request.Url.PathAndQuery.Replace("/Buy?", "/Buy.aspx?");
                Context.RewritePath(paty);

            }
            else if (fullOrigionalpath.Contains("/buy"))
            {
                string paty = Context.Request.Url.PathAndQuery.Replace("/buy?", "/Buy.aspx?");
                Context.RewritePath(paty);

            }
            
        }

        void Application_Start(object sender, EventArgs e)
        {
            //System.Threading.Thread.Sleep(60 * 1000);


            // Code that runs on application startup

        }

        void Application_End(object sender, EventArgs e)
        {
            //  Code that runs on application shutdown

        }

        void Application_Error(object sender, EventArgs e)
        {
            // Code that runs when an unhandled error occurs

        }

        void Session_Start(object sender, EventArgs e)
        {
            // Code that runs when a new session is started

        }

        void Session_End(object sender, EventArgs e)
        {
            // Code that runs when a session ends. 
            // Note: The Session_End event is raised only when the sessionstate mode
            // is set to InProc in the Web.config file. If session mode is set to StateServer 
            // or SQLServer, the event is not raised.

        }
    }
}
