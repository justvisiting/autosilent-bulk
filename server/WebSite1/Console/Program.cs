using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.OleDb;
using iPhonePackersCommon;
using YAX;
using Extension.Handlers;
using Extension;

namespace ConsoleApp
{
    class Program
    {
        static string dsnPath = @"C:\enlists\xpdev\server\webSite1";

        static void Main(string[] args)
        {
            Md5Sum();
        }

        static void Md5Sum()
        {
            string md5Hash = ReferralCore.GetMD5Hash("09e93cd6710c903f2f6a8071ea38bf8a6f0d552a");
            Console.WriteLine("md5 hash " + md5Hash);
            Console.ReadLine();
        }

        static void CountTotalPaidCydiaDownloads()
        {
            string connStr = "Provider=Microsoft.Jet.OLEDB.4.0; " +
                "Data Source=" + dsnPath + @"/CydiaResponse.mdb";

            OleDbConnection conn = new OleDbConnection(connStr);

            OleDbCommand cmd;

            HashSet<string> validIds = new HashSet<string>();
            HashSet<string> validFailedIds = new HashSet<string>();

            try
            {

                cmd = new OleDbCommand();
                cmd.Connection = conn;

                cmd.CommandText =
                    string.Format(
                    "Select DeviceId from CydiaStatus where (Status='completed' OR Status='complete')");

                conn.Open();
                OleDbDataReader reader = cmd.ExecuteReader();

                int count = 0;
                int totalUniqueCount = 0;

                if (reader != null)
                {
                    while (reader.Read())
                    {
                        string code = reader["DeviceId"] as string;

                        if (!string.IsNullOrEmpty(code)
                            && !validIds.Contains(code, StringComparer.InvariantCultureIgnoreCase)
                            && !validFailedIds.Contains(code, StringComparer.InvariantCultureIgnoreCase))
                        {

                            IphonePackers.AppVerifier verifier = new IphonePackers.AppVerifier(false, false);

                            TransactionStatus myStatus = TransactionStatus.Failed;
                            verifier.GetResponseString(Constants.DefaultAppId, code, "", false, out myStatus);

                            while (count < 2 && myStatus != TransactionStatus.Completed)
                            {
                                verifier.GetResponseString(Constants.DefaultAppId, "",code, false, out myStatus);
                                System.Threading.Thread.Sleep(500);
                                count++;
                            }

                            if (myStatus == TransactionStatus.Completed)
                            {
                                validIds.Add(code);
                                Console.WriteLine("yeah found 1 more, count:" + validIds.Count);
                            }
                            else
                            {
                                validFailedIds.Add(code);
                            }
                        }
                        Console.WriteLine("going on, keep tight.., non-refund:" + validIds.Count
                            + " refund:" + validFailedIds.Count);
                        System.Threading.Thread.Sleep(300);
                    }
                }
            }
            finally
            {
                if (conn != null)
                {
                    conn.Close();
                }

            }

            Console.WriteLine("Number of downloads with no refund" + validIds.Count);
            Console.WriteLine("Number of downloads & got refunded" + validFailedIds.Count);
            Console.ReadLine();
        }
    }
}
