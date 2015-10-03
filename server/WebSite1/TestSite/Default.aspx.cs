using System;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using Extension.Database;
using System.Net;
using System.IO;
using Extension;

public partial class _Default : System.Web.UI.Page 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //DatabaseAccessor.ReadRecords();
        //DatabaseAccessor.AddRandomMapping("g", "b");

        string urlStr = @"http://iphonepackers.info/beta/LogDiagnostics?code=df4&file=1234&v=2";

//        string urlStr = "http://" +
  //           HttpContext.Current.Request.Url.Authority +
            // "/TestSite/PaymentCallBack";
    //    "/TestSite/LogDiagnostics?code=df&file=1234";

        //string urlStr = "http://iphonepackers.info/autosilent1/PaymentCallBack";
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(urlStr);
        request.Method = "POST";
        Stream stream = request.GetRequestStream();
        StreamWriter writer = new StreamWriter(stream);
        writer.Write("");
        //writer.Write(File.ReadAllText(Constants.logDir + @"\0LogFile.plist"));

        
        writer.Close();
        stream.Close();



        WebResponse respnose = request.GetResponse();
         StreamReader reader = new StreamReader(respnose.GetResponseStream());
                string result = reader.ReadToEnd();

                HttpContext.Current.Response.Write(result);
        
    }
}
