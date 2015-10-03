using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Reflection;
using PaymentLibrary;
using Extension;
using Extension.Database;

namespace YAX
{
    public class PaymentProcessor
    {

        private static string logDir;

        static PaymentProcessor()
        {
            logDir = Constants.logDir + @"\Tran11.xml";
            
        }

        static object lockObj = new object();
        static object errorLogLckObj = new object();
        public static void AddTransactionInfo(Payment payment)
        {
            if(payment != null && !string.IsNullOrEmpty(payment.transactionid))
            {
                DatabaseAccessor.WriteRecord(payment);
            }
        }

       
        public static TransactionStatus GetTransactionStatusForDeviceAndApp(string devideId, string appId)
        {
            return DatabaseAccessor.GetTransactionStatus(devideId, appId);
        }

        internal static bool IsCompletedTransId(string transactionId)
        {
            return DatabaseAccessor.IsCompletedTransId(transactionId);
        }
    }
}
