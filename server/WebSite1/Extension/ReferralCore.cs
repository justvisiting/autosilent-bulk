using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Extension.Database;
using YAX;
using iPhonePackersCommon;

namespace Extension
{
    public class ReferralCore
    {
        private static HashSet<string> paidIdsMd5;

        static ReferralCore()
        {
           paidIdsMd5 = new HashSet<string>(StringComparer.InvariantCultureIgnoreCase);

            //add cydia records
           HashSet<string> paidIds = DatabaseAccessor.GetPaidCydiaCodes();
           foreach (string id in paidIds)
           {
               string md5 = GetMD5Hash(id);
             
               if (!paidIdsMd5.Contains(md5))
               {
                   paidIdsMd5.Add(md5);
               }
           }

            //add paypal records
           foreach (Payment pay in DatabaseAccessor.Mapping.Values)
           {
               if (string.Compare(pay.paymentstatus, Constants.successPaymentSatus, true) == 0)
               {
                   string md5 = GetMD5Hash(pay.code);
                   if (!paidIdsMd5.Contains(md5))
                   {
                       paidIdsMd5.Add(md5);
                   }
               }
           }
            //add static records
           foreach (string id in V2Handler.paidDevieIds)
           {
               string md5 = GetMD5Hash(id);
               if (!paidIdsMd5.Contains(md5))
               {
                   paidIdsMd5.Add(md5);
               }
           }
        }

        public static void AddToPaidList(string code)
        {
            if (!string.IsNullOrEmpty(code))
            {
                string md5 = GetMD5Hash(code);
                if (!paidIdsMd5.Contains(md5))
                {
                    paidIdsMd5.Add(md5);
                }
            }
        }

        public static string GetMD5Hash(string input)
        {
            System.Security.Cryptography.MD5CryptoServiceProvider x = new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] bs = System.Text.Encoding.UTF8.GetBytes(input);
            bs = x.ComputeHash(bs);
            System.Text.StringBuilder s = new System.Text.StringBuilder();
            foreach (byte b in bs)
            {
                s.Append(b.ToString("x2").ToLower());
            }
            string password = s.ToString();
            return password;
        }

        public static bool IsPaidMd5Code(string code)
        {
            return paidIdsMd5.Contains(code);   
        }
    }
}
