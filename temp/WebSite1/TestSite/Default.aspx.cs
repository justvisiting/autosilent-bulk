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

public partial class _Default : System.Web.UI.Page 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //DatabaseAccessor.ReadRecords();
        DatabaseAccessor.AddRandomMapping("g", "b");

       string urlStr = "http://" +
            HttpContext.Current.Request.Url.Authority +
        "/TestSite/PaymentCallBack";

        //string urlStr = "http://iphonepackers.info/autosilent1/PaymentCallBack";
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(urlStr);
        request.Method = "POST";
        Stream stream = request.GetRequestStream();
        StreamWriter writer = new StreamWriter(stream);
        writer.Write("mc_gross=3.00&protection_eligibility=Eligible&address_status=unconfirmed&payer_id=QJJ8JA3ED4ZMN&tax=0.00&address_street=VIA+GIULIO+VERITA+N.6&payment_date=09%3A01%3A30+Aug+04%2C+2009+PDT&payment_status=Completed&charset=windows-1252&address_zip=47100&first_name=Ivan&option_selection1=123456789012345678901234567890&mc_fee=0.42&address_country_code=IT&address_name=Ivan+Barrea&notify_version=2.8&custom=&payer_status=verified&business=ne_hits_luver%40yahoo.co.in&address_country=Italy&address_city=FORLI&quantity=1&verify_sign=AFd.erwt7VoeoUMr85yut0RloHozARtMMo0dpk2w7tZFVZ3PX1DQ83x.&payer_email=info%40alientuning.it&option_name1=purCode&txn_id=27447439TW689393C&payment_type=instant&btn_id=7173571&last_name=Barrea&address_state=Forli&receiver_email=ne_hits_luver%40yahoo.co.in&payment_fee=0.42&shipping_discount=0.00&insurance_amount=0.00&receiver_id=SK4EKN8ZBFQB6&txn_type=web_accept&item_name=Auto+Silent&discount=0.0&mc_currency=USD&item_number=&residence_country=IT&shipping_method=Default&handling_amount=0.00&transaction_subject=Auto+Silent&payment_gross=3.00&shipping=0.00&cmd=_notify-validate");
        writer.Close();
        stream.Close();



        request.GetResponse();
    }
}
