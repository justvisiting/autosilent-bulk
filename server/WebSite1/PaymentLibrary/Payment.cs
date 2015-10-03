using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace YAX
{
    public enum TransactionStatus
    {
        Completed = 0,
        Pending,
        Failed,
        Denied,
        Refunded
    };


    public class Payment
    {
        public string deviceid;
        public string paymentstatus;
        public string senderemail;
        public string transactionid;
        public string amount;
        public string pendingreason;

        public Payment() { }

        public Payment(string tranId, string deviceIdentifier)
        {
            deviceid = deviceIdentifier;
            transactionid = tranId;
        }

    }
}
