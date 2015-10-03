using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Reflection;
using PaymentLibrary;

namespace YAX
{
    public class PaymentProcessor
    {

        static Dictionary<string, trasactionlistTransaction> paymentInfo;// = new Dictionary<string, Payment>();
        //static YAXLib.YAXSerializer ser;// = new YAXLib.YAXSerializer(Dictionary<string, Payment>);
        public static string logDir;// = 
            //Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().CodeBase).Replace(@"file:\", string.Empty), @"..\Tran.xml");
        static List<Payment> paymentList = new List<Payment>();
        static PaymentLibrary.trasactionlist tlist = new PaymentLibrary.trasactionlist();


        static PaymentProcessor()
        {
            logDir =
            Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().CodeBase).Replace(@"file:\", string.Empty), @"..\Tran.xml");

            //ser = new YAXLib.YAXSerializer(typeof(Dictionary<string, Payment>));
            //ser = new YAXLib.YAXSerializer(typeof(List<Payment>));
            paymentInfo = new Dictionary<string, trasactionlistTransaction>();

            if (File.Exists(logDir))
            {
                trasactionlist list =   XmlSerialize.Deserialize<trasactionlist>(logDir);

                if (list != null && list.Items != null)
                {

                    foreach (trasactionlistTransaction item in list.Items)
                    {
                        if (!string.IsNullOrEmpty(item.tid))
                        {
                            paymentInfo[item.tid] = item;
                        }
                    }
                }
                //object o = ser.Deserialize(logDir);

                //paymentInfo = o as Dictionary<string, trasactionlistTransaction>;
            }

            if (paymentInfo == null)
            {
                paymentInfo = new Dictionary<string, trasactionlistTransaction>();
            }
        }

        static object lockObj = new object();

        public static void AddTransactionInfo(Payment payment)
        {
            if(payment != null && !string.IsNullOrEmpty(payment.transactionid))
            {
                lock (lockObj)
                {
                    paymentInfo[payment.transactionid] = Convert(payment);

                    tlist.Items = paymentInfo.Values.ToArray();
                    XmlSerialize.Serialize<trasactionlist>(logDir, tlist, Encoding.UTF8);

                }
            }
        }

        public static trasactionlistTransaction Convert(Payment payment)
        {
            trasactionlistTransaction rv = new trasactionlistTransaction();
            rv.deviceid = payment.deviceid;
            rv.tid = payment.transactionid;
            rv.status = payment.paymentstatus;

            return rv;
        }

        public static string GetDeviceId(string transactionId)
        {
            // Return empty if tid not found 
            return null;
        }

        public static TransactionStatus GetTransactionStatus(string transactionId)
        {
            return TransactionStatus.Pending;
        }


    }
}
