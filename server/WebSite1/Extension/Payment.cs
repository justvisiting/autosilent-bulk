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
        Refunded,
        None
    };


    public class Payment
    {
        public string _appId;
        public string _code;
        public string _paymentstatus;
       // public string senderemail;
        public string _transactionid;
        public string _amount;
        public string _referralCode;

        public string FirstName { get; set; }
        public string LastName { get; set;}

        public string referralCode
        {
            get
            {
                if (_referralCode == null)
                {
                    _referralCode = string.Empty;
                }
                return _referralCode;
            }

            set
            {
                _referralCode = value;
            }
        }

        public string appId
        {
            get
            {
                if (_appId == null)
                {
                    return string.Empty;
                }

                return _appId;
            }

            set
            {
                _appId = value;
            }
        }


        public string code
        {
            get
            {
                if (_code == null)
                {
                    return string.Empty;
                }

                return _code;
            }

            set
            {
                _code = value;
            }
        }


        public string paymentstatus
        {
            get
            {
                if (_paymentstatus == null)
                {
                    return string.Empty;
                }

                return _paymentstatus;
            }

            set
            {
                _paymentstatus = value;
            }
        }
    
       // public string senderemail;
        public string transactionid
        {
            get
            {
                if (_transactionid == null)
                {
                    return string.Empty;
                }

                return _transactionid;
            }

            set
            {
                _transactionid = value;
            }
        }


        public string amount
        {
            get
            {
                if (_amount == null)
                {

                    return string.Empty;
                }

                return _amount;
            }

            set
            {
                _amount = value;
            }
        }
        //public string pendingreason;
        //public string error;
        //public string firstName;
        //public string lastName;

        public Payment() { }

        public Payment(string appId, string deviceIdentifier)
            : this(appId, null, deviceIdentifier, null, null, null, null, null, null, null)
        {
            
        }

        public Payment(string appId, string tranId, string code, string paymentStatus, string amount, string payerEmail, string errror, string firstName, string lastName, string referralCode)
        {
            this.code = code;
            transactionid = tranId;
            this.paymentstatus = paymentStatus;
            this.amount = amount;
            this.appId = appId;
            this.referralCode = referralCode;
            this.FirstName = firstName;
            this.LastName = lastName;
            
        }

        

    }
}
