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
using iPhonePackersCommon;

namespace Extension.Database
{
    public class DatabaseAccessor
    {
        static string connStr;

        static string CydiaDbConnStr;

        static Dictionary<string, Payment> mapping = new Dictionary<string, Payment>();

        static string dbDir = Path.GetDirectoryName(Assembly.GetExecutingAssembly().CodeBase).Replace(@"file:\", string.Empty);

        public static string error = "";

        public static Dictionary<string, Payment> Mapping
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

            //string dsnPath = @"C:\enlist\as\server\WebSite1\Extension\bin\Debug";
            string dsnPath = HttpContext.Current.Server.MapPath("/access_db");

            connStr = "Provider=Microsoft.Jet.OLEDB.4.0; " +
                "Data Source=" + dsnPath + @"/lic.mdb";

            CydiaDbConnStr = "Provider=Microsoft.Jet.OLEDB.4.0; " +
                            "Data Source=" + dsnPath + @"/CydiaResponse.mdb";


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

        private static object lockObj = new object();

        internal static void WriteRecord(Payment payment)
        {
            if (payment != null)
                
            {
               if(string.IsNullOrEmpty(payment.code)
                 || string.IsNullOrEmpty(payment.appId))
               {
                   payment.appId = "app123";
                   payment.code = "code123";
               }
                
                
                OleDbDataReader reader = null;
                OleDbConnection conn = null;

                try
                {

                    List<string> keywords = new List<string>() { payment.code, payment.appId, payment.referralCode, payment.FirstName, payment.LastName };
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
                        File.WriteAllText(Constants.logErrorDir + DateTime.UtcNow.Ticks + "UpdatePaymentCalled.txt"
                    , storedPayment.amount + "," + storedPayment.transactionid + "," + storedPayment.paymentstatus);
                        Update(storedPayment);
                    }
                    else
                    {
                         storedPayment = payment;
                        Insert(payment);
                    }

                    lock (lockObj)
                    {
                        Mapping[payment.code + payment.appId] = storedPayment;
                    }
                }
                catch (Exception ex)
                {
                    
                File.WriteAllText(Constants.logErrorDir + DateTime.UtcNow.Ticks + "databaseAccessFailed.txt"
                    , ex.ToString());
            
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
                    , payment.amount, payment.referralCode, payment.FirstName, payment.LastName, ref cmd);

                conn.Open();

                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
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

               

                if (IsSafe(new List<string>() { payment.paymentstatus, payment.amount, payment.code, payment.appId, payment.transactionid }))
                {
                    StringBuilder query = new StringBuilder();
                    query.Append("UPDATE AutoSilentApp SET ");
                    query.Append(" LastDateModified = Now()");
                    query.AppendFormat(", Status = '{0}'", payment.paymentstatus);
                    query.AppendFormat(", Amount = '{0}'", payment.amount);
                    query.AppendFormat(", TId = '{0}'", payment.transactionid);
                    query.AppendFormat(" WHERE (Code='{0}' AND AppId='{1}')", payment.code, payment.appId);

                     cmd.CommandText = query.ToString();

                     cmd.ExecuteNonQuery();
                }
            }
            
            finally
            {
                if (conn != null)
                {
                    conn.Close();
                }
            }
   
        }


        private static void SetUpdateOrInsertParams(string status, string code, string appId, string transactionId, string amount, string referralCode, string firstName, string lastName, ref OleDbCommand cmd)
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

                param = new OleDbParameter("ReferralCodeId", referralCode);
                cmd.Parameters.Add(param);


                param = new OleDbParameter("FirstName", firstName);
                cmd.Parameters.Add(param);


                param = new OleDbParameter("LastName", lastName);
                cmd.Parameters.Add(param);
            }
        }
        
        private static void ReadRecords()
        {
            OleDbConnection conn = new OleDbConnection(connStr);
            OleDbDataReader reader = null;
            int count = 0;

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
                                status, amount, null, null, null, null, null);
                        }

                        count++;
                    }
                }
            }
            catch (Exception ex)
            {
                error = ex.ToString() + ex.StackTrace;
            }
            finally
            {
                error += count;

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



        internal static TransactionStatus GetTransactionStatus(string code, string appId, bool debug, ref string debugInfo)
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

            if (debug)
            {
                debugInfo += "mapping in cache:";
                foreach (KeyValuePair<string, Payment> pair in Mapping)
                {
                    debugInfo += ", " + pair.Key + pair.Value.paymentstatus;
                }
            }
            return TransactionStatus.Failed;
        }

        internal static bool CydiaRecordExists(string code)
        {
                OleDbConnection conn = new OleDbConnection(CydiaDbConnStr);

                OleDbCommand cmd;


                try
                {

                    cmd = new OleDbCommand();
                    cmd.Connection = conn;

                    cmd.CommandText =
                        string.Format("SELECT 1 FROM CydiaStatus Where DeviceId = '{0}'"
                                    , code);

                    conn.Open();

                    OleDbDataReader reader = cmd.ExecuteReader();
                    if(reader != null && reader.HasRows)
                    {
                        return true;
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.ToString());
                }
                finally
                {
                    if (conn != null)
                    {
                        conn.Close();
                    }
                }

                return false;
        }

        internal static void WriteCydiaRecord(string code, string status)
        {
            if (string.IsNullOrEmpty(status))
            {
                status = "CydiaEmpty";
            }

            if (!string.IsNullOrEmpty(code) 
                && IsSafe(new List<string>() { code, status}))
            {
                OleDbConnection conn = new OleDbConnection(CydiaDbConnStr);

                OleDbCommand cmd;


                try
                {

                    cmd = new OleDbCommand();
                    cmd.Connection = conn;

                    if (CydiaRecordExists(code))
                    {
                        cmd.CommandText =
                            string.Format("Update CydiaStatus Set DeviceId='{0}', LastModifiedDateTime=Now(), Status='{1}' where DeviceId='{0}';"
                        , code, status);

                    }
                    else
                    {
                        cmd.CommandText =
                            string.Format("INSERT INTO CydiaStatus (DeviceId, LastModifiedDateTime, Status)"
                            + " VALUES ('{0}',Now(),'{1}');", code, status);
                    }

                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.ToString());
                }
                finally
                {
                    if (conn != null)
                    {
                        conn.Close();
                    }
                }   
            }
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

        internal static HashSet<string> GetPaidCydiaCodes()
        {
            HashSet<string> rv = new HashSet<string>(StringComparer.InvariantCultureIgnoreCase);
            OleDbConnection conn = new OleDbConnection(CydiaDbConnStr);

                OleDbDataReader reader = null;
                try
                {
                    conn.Open();

                    OleDbCommand cmd =
                              new OleDbCommand();
                    cmd.Connection = conn;

                    cmd.CommandText = "Select DISTINCT DeviceId from CydiaStatus where "
                                    + " Status='Complete' OR Status='Completed';";


                    reader = cmd.ExecuteReader();

                    if (reader != null)
                    {
                        while (reader.Read())
                        {
                            string code = reader["DeviceId"] as string;
                            if (!rv.Contains(code))
                            {
                                //string md5sum = 
                                rv.Add(code);
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.ToString());
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

                return rv;
        }

        internal static int GetReferralCount(string code, string md5Hash)
        {
            int count = 0;
            if (IsSafe(new List<string>() { code, md5Hash }))
            {
                OleDbConnection conn = new OleDbConnection(connStr);

                OleDbDataReader reader = null;
                try
                {
                    conn.Open();

                    OleDbCommand cmd =
                              new OleDbCommand();
                    cmd.Connection = conn;

                    cmd.CommandText = string.Format("Select DISTINCT Code from AutoSilentApp where "
                                    + " (Status='Complete' OR Status='Completed') AND ReferralCode='{0}' AND NOT Code ='{1}';",
                                     md5Hash, code);


                    reader = cmd.ExecuteReader();
                    
                    if (reader != null)
                    {
                      while(reader.Read())
                      {
                          count++;
                      }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.ToString());
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

            return count;
        }
    }
}
