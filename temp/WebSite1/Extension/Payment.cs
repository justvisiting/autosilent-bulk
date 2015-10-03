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
        public string appId;
        public string code;
        public string paymentstatus;
       // public string senderemail;
        public string transactionid;
        public string amount;
        //public string pendingreason;
        //public string error;
        //public string firstName;
        //public string lastName;

        public Payment() { }

        public Payment(string appId, string deviceIdentifier)
            : this(appId, null, deviceIdentifier, null, null, null, null, null, null)
        {
            
        }

        public Payment(string appId, string tranId, string code, string paymentStatus, string amount, string payerEmail, string errror, string firstName, string lastName)
        {
            this.code = code;
            transactionid = tranId;
            this.paymentstatus = paymentStatus;
            this.amount = amount;
            this.appId = appId;
            
        }

        

    }
}
