using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Net;

namespace Extension
{
    public class KeepAliveScheduler
    {

        public static void Start()
        {

            //Thread thread = new Thread(PingServer); 
            //thread.Start();
        }

        public void PingServer() 
        { 
            try 
            { 
                WebClient http = new WebClient(); 
              //  string Result = http.DownloadString(); 
            } 
            catch (Exception ex) 
            { 
                string Message = ex.Message; 
            } 
        }
    }
}
