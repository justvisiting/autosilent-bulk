using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.OleDb;
using System.IO;
using System.Reflection;
using System.Data.Odbc;
using System.Data;
using System.Web;
using YAX;

namespace Extension.Database
{
    public class DatabaseAccessor
    {
        static string connStr; 

        static Dictionary<string, Payment> mapping = new Dictionary<string, Payment>();

        static string dbDir = Path.GetDirectoryName(Assembly.GetExecutingAssembly().CodeBase).Replace(@"file:\", string.Empty);


        private static Dictionary<string, Payment> Mapping
        {
            get
            {
                if (mapping == null || mapping.Count == 0)
                {
                    ReadRecords();
                }

                return mapping;
            }
        }
    

        static DatabaseAccessor()
        {

            string dsnPath = dbDir;//HttpContext.Current.Server.MapPath("/access_db");

            connStr = "Provider=Microsoft.Jet.OLEDB.4.0; " +
                "Data Source=" + dsnPath + @"/lic.mdb";

        }
        public static KeyValuePair<string, string> GetRandomMapping()
        {
            if (Mapping.Count == 0)
            {
                
            }

            
            return new KeyValuePair<string, string>();
        }

        public static void AddRandomMapping(string appId, string code)
        {
            WriteRecord(new Payment(appId, code));
        }
        

        internal static void WriteRecord(Payment payment)
        {
            if (payment != null
                && !string.IsNullOrEmpty(payment.code)
                && !string.IsNullOrEmpty(payment.appId))
            {
                
                OleDbDataReader reader = null;
                OleDbConnection conn = null;

                try
                {

                    List<string> keywords = new List<string>() { payment.code, payment.appId };
                    //payment.amount, payment.appId, payment.code, payment.error, payment.firstName, payment.lastName, payment.paymentstatus, payment.senderemail, payment.transactionid }
                    if (payment.amount != null) keywords.Add(payment.amount);
                    if (payment.paymentstatus != null) keywords.Add(payment.paymentstatus);
                    if (payment.transactionid != null) keywords.Add(payment.transactionid);
                    bool isSafe = IsSafe(keywords);

                    Payment storedPayment;

                    if (isSafe && Mapping.TryGetValue(payment.code + payment.appId, out storedPayment))
                    {
                        storedPayment.amount = payment.amount;
                        storedPayment.paymentstatus = payment.paymentstatus;
                        storedPayment.transactionid = payment.transactionid;

                        Update(storedPayment);
                    }
                    else
                    {
                        Mapping[payment.code + payment.appId] = payment;
                        Insert(payment);
                    }



                }
                catch (Exception ex)
                {

                }
                
            }
                
        }

        static HashSet<string> unsafeWords = new HashSet<string>(StringComparer.InvariantCultureIgnoreCase) { "update", "select", "delete", "autosilentapp", "create" };

        private static bool IsSafe(List<string> list)
        {
            if (list != null)
            {
                foreach (string item in list)
                {
                    if (unsafeWords.Contains(item.ToLower().Trim()))
                    {
                        return false;
                    }
                }

                return true;
            }

            return false;
        }


        private static void Insert(Payment payment)
        {
            OleDbConnection conn = new OleDbConnection(connStr);

            OleDbCommand cmd;


            try
            {

                cmd = new OleDbCommand();
                cmd.Connection = conn;

                cmd.CommandText = "EXECUTE InsertRecord";

                SetUpdateOrInsertParams(
                    payment.paymentstatus, payment.code, payment.appId, payment.transactionid
                    , payment.amount, ref cmd);

                conn.Open();

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
            }
            finally
            {
                if (conn != null)
                {
                    conn.Close();
                }
            }
        }


        private static void Update(Payment payment)
        {
            OleDbConnection conn = new OleDbConnection(connStr);

            try
            {
                conn.Open();

                OleDbCommand cmd =
                          new OleDbCommand();
                cmd.Connection = conn;

                cmd.CommandText = "EXECUTE UpdateRecord";

                SetUpdateOrInsertParams(payment.paymentstatus, payment.code
                    , payment.appId, payment.transactionid, payment.amount
                    , ref cmd);

                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
            }
            finally
            {
                if (conn != null)
                {
                    conn.Close();
                }
            }
   
        }


        private static void SetUpdateOrInsertParams(string status, string code, string appId, string transactionId, string amount, ref OleDbCommand cmd)
        {
            if (cmd != null && IsSafe(new List<string>() { status, code, appId, transactionId, amount}))
            {
                //NOTE: ORDERING IS IMPORTATNT
                OleDbParameter param;

                param = new OleDbParameter("Code", code);
                cmd.Parameters.Add(param);

                param = new OleDbParameter("AppId", appId);
                cmd.Parameters.Add(param);

                 param = new OleDbParameter("Status", status);
                cmd.Parameters.Add(param);

                param = new OleDbParameter("TId", transactionId);
                cmd.Parameters.Add(param);

                param = new OleDbParameter("Amount", amount);
                cmd.Parameters.Add(param);
            }
        }
        
        private static void ReadRecords()
        {
            OleDbConnection conn = new OleDbConnection(connStr);
            OleDbDataReader reader = null;

            try
            {
                conn.Open();

                OleDbCommand cmd =
                          new OleDbCommand();
                cmd.Connection = conn;

                cmd.CommandText = "EXECUTE ReadRecords";

                reader = cmd.ExecuteReader();

                if (reader != null)
                {
                    while (reader.Read())
                    {
                        string code = reader["Code"] as string;
                        string appId = reader["AppId"] as string;
                        string status = reader["Status"] as string;
                        string amount = reader["Amount"] as string;
                        string tranId = reader["TId"] as string;

                        if (!string.IsNullOrEmpty(code)
                            && !string.IsNullOrEmpty(appId)
                            && !string.IsNullOrEmpty(status))
                        {

                            mapping[code + appId] = new Payment(appId, tranId, code, 
                                status, amount, null, null, null, null);
                        }
                    }
                }
            }
            catch (Exception)
            {
            }
            finally
            {
                if (conn != null)
                {
                    conn.Close();
                }

                if (reader != null)
                {
                    reader.Close();
                }
            }
   
        }



        internal static TransactionStatus GetTransactionStatus(string code, string appId)
        {
            Payment storedPayment;
            if (Mapping.TryGetValue(code + appId, out storedPayment))
            {
                if (String.Compare(storedPayment.paymentstatus, Constants.successPaymentSatus, true)
                    == 0)
                {
                    return TransactionStatus.Completed;
                }
            }

            return TransactionStatus.Failed;
        }

        internal static bool IsCompletedTransId(string transactionId)
        {
            if (IsSafe(new List<string>() { transactionId }))
            {
                OleDbConnection conn = new OleDbConnection(connStr);
           
                OleDbDataReader reader = null;
                try
                {
                    conn.Open();

                    OleDbCommand cmd =
                              new OleDbCommand();
                    cmd.Connection = conn;

                    cmd.CommandText = "EXECUTE QueryCompletedTransId";

                    cmd.Parameters.Add(new OleDbParameter("TId", transactionId));

                    reader = cmd.ExecuteReader();

                    if (reader.HasRows && reader.Read())
                    {
                        string status = reader["Status"] as string;

                        if (string.Compare(status.Trim(), Constants.successPaymentSatus
                            , true) == 0)
                        {
                            return true;
                        }
                        else
                        {
                            return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
                catch (Exception)
                {
                }
                finally
                {
                    if (conn != null)
                    {
                        conn.Close();
                    }

                    if (reader != null)
                    {
                        reader.Close();
                    }

                }
            }

            // if fails return true...
            return true;
        }
    }
}
