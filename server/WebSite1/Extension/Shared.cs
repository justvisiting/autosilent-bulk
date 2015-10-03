using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography;
using System.IO;
using iPhonePackersCommon;

namespace Extension
{
    public class Shared
    {

        public static string GetAppVerifyMessage(string locale, bool isSuccess)
        {/*
            if (isSuccess)
            {
                return Constants.SuccessMessage;
            }
            else
            {
                return Constants.FailureMessage;
            }
            /*
            string lower = locale.ToLower();
            if (lower.Contains("jp") || lower.Contains("jap"))
            {
                if (isSuccess)
                {
                    return Constants.SuccessMessage;//.Japanese;
                }

                return Constants.FailureMessages.Japanese;
            }

            if (lower.Contains("fr") || lower.Contains("fre"))
            {
                if (isSuccess)
                {
                    return Constants.SuccessMessages.French;
                }

                return Constants.FailureMessages.French;
            }

            if (lower.Contains("ru"))
            {
                if (isSuccess)
                {
                    return Constants.SuccessMessages.Russian;
                }

                return Constants.FailureMessages.Russian;
            }
*/
            if (isSuccess)
            {
                return Constants.SuccessMessage;
            }

            return Constants.Failedmessage;
         
        }


        public static string EncodeFile(string stringkey, String input)
        {
            byte[] key = Encoding.UTF8.GetBytes(stringkey);

            // Initialize the keyed hash object.
            HMACSHA1 myhmacsha1 = new HMACSHA1(key);


            byte[] inStream1 = Encoding.UTF8.GetBytes(input);// Convert.FromBase64String(input);
            MemoryStream inStream = new MemoryStream();
            //MemoryStream outStream = new MemoryStream();

            // FileStream inStream = new FileStream(sourceFile, FileMode.Open);
            //FileStream outStream = new FileStream(destFile, FileMode.Create);
            // Compute the hash of the input file.
            byte[] hashValue = myhmacsha1.ComputeHash(inStream1);
            // Reset inStream to the beginning of the file.
            //inStream.Position = 0;
            string rv = Convert.ToBase64String(hashValue);

            // Write the computed hash value to the output file.
            //outStream.Write(hashValue, 0, hashValue.Length);

            //StreamReader reader = new StreamReader(outStream);
            //string rv = reader.ReadToEnd();

            myhmacsha1.Clear();
            // Close the streams
            inStream.Close();

            //state += "orig sig" + rv;
            //outStream.Close();
            //string safeRv = MakeUrlSafe(rv);

            //state += " safe sig" + safeRv;

            return rv;
            //return safeRv;
        } // end EncodeFile

    }
}
