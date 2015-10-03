using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.IO;
using System.Collections.Specialized;
using System.Net;
using System.Security.Cryptography;
using System.Xml;
using System.Reflection;
using System.Threading;
using Extension;
using Extension.Database;
using YAX;
using iPhonePackersCommon;

namespace IphonePackers
{
    public class AppVerifier : IHttpHandler
    {
        bool queryLocalStore;
        bool writeCydiaRecord;

        public AppVerifier()
        {
            queryLocalStore = true;
            writeCydiaRecord = true;
        }

        public AppVerifier(bool queryOurLocalStore, bool writeCydiaDeviceStatusToDb)
        {
            queryLocalStore = queryOurLocalStore;
            writeCydiaRecord = writeCydiaDeviceStatusToDb;

        }

        string LogFile = "Log.txt";
        string ourKey = Constants.ourKey;

        string key = "8d6c787f1f2451f0321ce7210ba39b85";
       // string state = null;
        string ourerror = "ourerror";
        HashSet<char> invalidChar;
        static int counter = 0;
        

        #region IHttpHandler Members

        public bool IsReusable
        {
            get { return false; }
        }

        public void ProcessRequest(HttpContext context)
        {
            Log();
            string state = string.Empty;
            string deviceId = null;
            bool debug = false;

            NameValueCollection query = context.Request.QueryString;
            if (query.Count > 0)
                deviceId = query["deviceId"];

            if (string.IsNullOrEmpty(deviceId))
            {
                deviceId = query["code"];
            }

            string locale = query["locale"];

            if (locale == null)
            {
                locale = "en_us";
            }

            if (deviceId == "4f3564c416576088ecedb9119fe82168dc733ed6")
            {
                //throw new WebException();
            }

            if (query["debug"] == "1")
            {
                debug = true;
            }
            
            string appId = context.Request.QueryString["appId"];
            if (string.IsNullOrEmpty(appId))
            {
                appId = Constants.DefaultAppId;
            }
            
            TransactionStatus status;
            string responseString = GetResponseString(appId, deviceId, locale, debug, out status);

            if (status == TransactionStatus.Completed)
            {
                ReferralCore.AddToPaidList(deviceId);
            }
            responseString += "&dtt=20100223";
            context.Response.Write(responseString);
            context.Response.StatusCode = 200;
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            context.Response.Cache.SetExpires(DateTime.UtcNow);
         
           // string logMessage = string.Format("url={0}, UA={1}, response={2}"
             //                           , context.Request.RawUrl
               //                         , context.Request.UserAgent
                 //                       , responseString);
            //Log(logMessage); 
            try
            {
                //AddElement(context, responseString);
            }
            catch (Exception)
            {
            }
        }

        public string GetResponseString(string appId, string deviceId
            , string locale, bool debug, out TransactionStatus transactionStatus)
        {
            transactionStatus = TransactionStatus.Failed;
            string queryString = CreateQueryString(deviceId);
            bool isSuccess = false;
            string responseString = SendRequest(deviceId, queryString, locale, debug, out isSuccess);

            if (!isSuccess)
            {
                if (queryLocalStore)
                {
                    responseString = V2Handler.ConstructResponse(deviceId, string.Empty, appId, locale, debug, out transactionStatus);
                }
            }
            else
            {
                transactionStatus = TransactionStatus.Completed;
            }

            return responseString;
        }

        static object counterLockObj = new object();
        static int MaxCount = 20;

        private static void Log()
        {
            if (counter >= MaxCount)
            {
                lock (counterLockObj)
                {
                    if (counter >= MaxCount)
                    {
                        int? count = new int();
                        count = counter;
                        Interlocked.Exchange(ref counter, 0);
                        try
                        {
                            System.Threading.ThreadPool.QueueUserWorkItem(new WaitCallback(LogCounter), count);
                        }
                        catch (Exception)
                        {
                        }
                    }
                }
            }


            Interlocked.Increment(ref counter);
            
        }

        private static object writerLockObj = new object();

        private static void LogCounter(object count)
        {
            //lock (writerLockObj)
            {
                int? countSize = count as int?;
                if (countSize.Value >= MaxCount)
                {

                    string filePath = logDir + DateTime.Now.Ticks.ToString() +
                             "c=" +countSize.Value.ToString() + ".txt";

                    //File.WriteAllText(filePath, countSize.Value.ToString());
                }
            }
        }

        static string logDir = Constants.logErrorDir;

        
        #endregion


        private string SendRequest(string deviceId, string queryString, string locale, bool debug, out bool isSuccess)
        {
            isSuccess = false;

            string url = queryString;
            int retryCount = 0;
            bool cyDiaCallSucceeded = false;

            while (retryCount < 2 && !cyDiaCallSucceeded)
            {
                try
                {
                    retryCount++;
                    WebRequest request =
                   WebRequest.Create(url);
                    request.Timeout = 8000;
                    //request.ContentType = "application/x-www-form-urlencoded";

                    request.Method = "GET";
                    HttpWebResponse response;

                    response = (HttpWebResponse)request.GetResponse();

                    Stream dataStream = response.GetResponseStream();

                    StreamReader reader = new StreamReader(dataStream);
                    string result = reader.ReadToEnd();

                    string state = parseResponse(result);

                    //TODO: convert state to TransactionStatus enum. WHY ?

                    try
                    {
                        if (writeCydiaRecord)
                        {
                            DatabaseAccessor.WriteCydiaRecord(deviceId, state);
                        }
                    }
                    catch (Exception ex)
                    {
                        Utility.AddElement(HttpContext.Current, ex.ToString());
                    }

                    if (!IsResponseFromCydia(result))
                    {
                        state = null;
                    }


                    string rv = ConstructResponse(deviceId, state, locale, debug, out isSuccess);


                    //commenting this as this is not used
                    cyDiaCallSucceeded = true;
                    return rv;
                }
                catch (WebException webex)
                {
                    Console.Write(webex.ToString());
                    string result = string.Empty;

                    if (webex.Response != null)
                    {
                        StreamReader reader = new StreamReader(webex.Response.GetResponseStream());
                        if (reader != null)
                        {
                            result = reader.ReadToEnd();
                        }
                    }

                    string rv = ConstructResponse(deviceId, ourerror, locale, debug, out isSuccess);
                    Utility.AddElement(HttpContext.Current, result + rv);

                    //TODO: is this correct..is it our error when web exception?? YES
                    return rv;

                }
                catch (Exception ex)
                {
                    Console.Write(ex.ToString());

                    string rv = ConstructResponse(deviceId, ourerror, locale, debug, out isSuccess);

                    Utility.AddElement(HttpContext.Current, ex.ToString() + rv);

                    return rv;
                }

            }

            return string.Empty;
        }

        private bool IsPaymentCompleted(string state)
        {
            bool retValue = false;

            if (String.IsNullOrEmpty(state))
                return retValue;

            if (String.Compare(state, Constants.successPaymentSatus, true) == 0)
            {
                //state = TransactionStatus.Completed.ToString();
                retValue = true;
                // TransactionStatus.Completed;
            }

            return retValue;
        }

        private bool IsResponseFromCydia(string result)
        {
            string signature = "";
            string resultWithoutSignature = RemoveSignatureAndReOrder(result, ref signature);
            string hash = EncodeFileUrlSafe(key, resultWithoutSignature);
            if (String.CompareOrdinal(signature, hash) == 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private string RemoveSignatureAndReOrder(string response, ref string signature)
        {
            StringBuilder output  = new StringBuilder();

            string[] tokens = response.Split('&');

            Array.Sort(tokens);

            for (int i = 0; i < tokens.Length; i++)
            {
                if (tokens[i].StartsWith("signature=",StringComparison.InvariantCultureIgnoreCase))
                {
                    //skip it
                    int sigIndex = tokens[i].IndexOf('=') + 1;

                    if (sigIndex > 0)
                        signature = tokens[i].Substring(sigIndex);

                    continue;
                }

                output.Append(tokens[i]);
                output.Append("&");
            }

            if(output.Length > 0)
                output.Remove(output.Length-1,1);

            return output.ToString();

        }

        string parseResponse(string input)
        {
            string[] tokens = input.Split('&');

            string state = "";

            for (int i = 0; i < tokens.Length; i++)
            {
                if (tokens[i].StartsWith("state=",StringComparison.InvariantCultureIgnoreCase))
                {
                    string[] stateElements = tokens[i].Split('=');

                    if (stateElements.Length > 1)
                    {
                        state = stateElements[1];
                    }
                    break;
                }
            }

            return state;
        }

        /// <summary>
        /// string.Format("stt={0}&msg={1}&sig={2}", state, message, signature);
        /// </summary>
        /// <param name="state"></param>
        /// <param name="isSuccess"></param>
        /// <returns></returns>
        string ConstructResponse(string deviceId, string state, string locale, bool debug, out bool isSuccess)
        {

            isSuccess = false;

            StringBuilder response = new StringBuilder();

            bool isPaymentFromCydia = IsPaymentCompleted(state);
            if (!string.IsNullOrEmpty(state))
            {
                response.Append("stt=");
                response.Append(state);
                response.Append("&");

                if (!string.IsNullOrEmpty(deviceId) && isPaymentFromCydia)
                {
                    //add message
                    response.Append("msg=");
                    response.Append(Shared.GetAppVerifyMessage(locale, true));
                    response.Append("&");

                    string signature = Shared.EncodeFile(ourKey, deviceId);
                    response.Append("sig=");
                    response.Append(signature);
                    isSuccess = true;
                }
            }

            if (debug)
            {
                response.AppendFormat("&cydiaState={0}", state);
            }

            return response.ToString();
        }

        private string CreateQueryString(string deviceId)
        {
            if (deviceId == null)
                deviceId = "";

            string nonce = DateTime.UtcNow.Ticks.ToString();
            TimeSpan t = (DateTime.UtcNow - new DateTime(1970, 1, 1));

            int timestamp = (int)t.TotalSeconds;


            string querystring =
                string.Format("device={0}&mode=local&nonce={1}&product=autosilent&timestamp={2}&vendor=iphonepackers"
                    , deviceId, nonce, timestamp.ToString());


            string hash = EncodeFileUrlSafe(key, querystring);

            string url = "http://cydia.saurik.com/api/check?" + querystring + "&signature=" + hash;


            return url;
        }

        public string EncodeFileUrlSafe(string stringkey, String input)
        {

            return MakeUrlSafe(Shared.EncodeFile(stringkey, input));
        }


       
        // Decrypt the encoded file and compare to original string.
        public string DecodeString(string stringkey, String input)
        {
            byte[] key = Encoding.UTF8.GetBytes(stringkey);

            // Initialize the keyed hash object. 
            HMACSHA1 hmacsha1 = new HMACSHA1(key);
            // Create an array to hold the keyed hash value read from the file.
            //byte[] storedHash = new byte[hmacsha1.HashSize / 8];
            byte[] inStream1 = Encoding.UTF8.GetBytes(input);
            //MemoryStream inStream = new MemoryStream();
            // Create a FileStream for the source file.
            //FileStream inStream = new FileStream(sourceFile, FileMode.Open);
            // Read in the storedHash.
            //inStream.Read(storedHash, 0, storedHash.Length);
            // Compute the hash of the remaining contents of the file.
            // The stream is properly positioned at the beginning of the content, 
            // immediately after the stored hash value.
            byte[] computedHash = hmacsha1.ComputeHash(inStream1);

            string rv = Convert.ToBase64String(computedHash);

            return rv;
            // compare the computed hash with the stored value
            //for (int i = 0; i < storedHash.Length; i++)
            //{
            //    if (computedHash[i] != storedHash[i])
            //    {
            //        Console.WriteLine("Hash values differ! Encoded file has been tampered with!");
            //        return false;
            //    }
            //}
            //Console.WriteLine("Hash values agree -- no tampering occurred.");
            //return true;
        } //end DecodeFile 

        private string MakeUrlSafe(string input)
        {
            StringBuilder output = new StringBuilder(input);
            if(invalidChar == null)
            {
               invalidChar = new HashSet<char>() 
               { ' ', '\'', '\"', '#', '%', '&', '/', ':', ';', '<', '>', '?'};
            }
                for (int i = 0; i < output.Length; ++i)
            {
                if (output[i] == ' ' ||
                    output[i] == '\'' ||
                    output[i] == '\"' ||
                    output[i] == '#' ||
                    output[i] == '%' ||
                    output[i] == '&' ||
                    output[i] == '/' ||
                    output[i] == ':' ||
                    output[i] == ';' ||
                    output[i] == '<' ||
                    output[i] == '>' ||
                    output[i] == '?')
                {
                    output[i] = '_';
                }

                if (output[i] == '+')
                {
                    output[i] = '-';
                }
            }
            output.Remove(output.Length - 1, 1);
            //orig:H7hAVqo78cUttpqaKv+H6i2wlcI=
            return output.ToString(); //our:H7hAVqo78cUttpqaKv_H6i2wlcI //cydia:H7hAVqo78cUttpqaKv-H6i2wlcI
        }

        public string GetMD5Hash(string input)
        {
            System.Security.Cryptography.MD5CryptoServiceProvider x = new System.Security.Cryptography.MD5CryptoServiceProvider();


            byte[] bs = x.ComputeHash(System.Text.Encoding.UTF8.GetBytes(input));
            StringBuilder str = new StringBuilder();
            foreach (byte bt in bs)
            {
                str.Append(bt.ToString("x2").ToLower());
            }

            return str.ToString();
        }
    }
}
