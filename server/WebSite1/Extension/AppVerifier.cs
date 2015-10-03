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

namespace IphonePackers
{
    public class AppVerifier : IHttpHandler
    {

        string LogFile = "Log.txt";
        string deviceId = null;
        string ourKey = Constants.ourKey;

        string key = "8d6c787f1f2451f0321ce7210ba39b85";
        string state = null;
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
            state = string.Empty;
            deviceId = null;

         //   StringBuilder builder = new StringBuilder();
           // builder.AppendFormat("status={0}&key={1}", "pending", "234324sd+=1@3%2~4");

            //TextWriter writer = new StringWriter(builder);

            //context.Response.Write(builder);
            //context.Response.Status = "OK";
           // context.Response.StatusCode = 200;
            NameValueCollection query = context.Request.QueryString;
            if (query.Count > 0)
                deviceId = query["code"];

          
            string queryString = CreateQueryString();
            SendRequest(queryString);

            string responseString = "";
            if (query["v"] == "2" || query["v"] == "3")
            {
                string appId = context.Request.QueryString["appId"];
                if(string.IsNullOrEmpty(appId))
                {
                    appId = Constants.DefaultAppId;
                }

                responseString = V2Handler.ConstructResponse(deviceId, state, appId);
            }
            
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

                    File.WriteAllText(filePath, countSize.Value.ToString());
                }
            }
        }

        static string logDir = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().CodeBase).Replace(@"file:\", string.Empty), @"..\Log\");

        static XmlDocument xmlDoc = null;
        static object xmlDocLockObj = new object();
        static object rootLockObj = new object();
        static XmlWriter writer = null;
        static XmlElement rootNode = null;
        static string fullPath = null;
           
       
        #endregion


        private void SendRequest(string queryString)
        {
            string rv;
            string url = queryString;
            WebRequest request =
                WebRequest.Create(url);
            request.Timeout = 8000;
            //request.ContentType = "application/x-www-form-urlencoded";

            request.Method = "GET";
            HttpWebResponse response;
            try
            {
                response = (HttpWebResponse)request.GetResponse();


                Stream dataStream = response.GetResponseStream();

                StreamReader reader = new StreamReader(dataStream);
                string result = reader.ReadToEnd();

                string state = parseResponse(result);

                //string rv = constructResponse();

                string signature = GetSignatureFromResponse(result);

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
                state  = ourerror + state;
                Utility.AddElement(HttpContext.Current, result + state);
            }
            catch (Exception ex)
            {
                Console.Write(ex.ToString());
                state = ourerror;
                Utility.AddElement(HttpContext.Current, ex + state);
            }
            
            finally
            {
                state = null;
                //rv = ConstructResponse();
            }

            //return rv;
        }

        private string GetSignatureFromResponse(string response)
        {
            string signature = "signature";
            int index = response.LastIndexOf(signature, StringComparison.InvariantCultureIgnoreCase);

            index = index + signature.Length + 1;
            return response.Substring(index);
        }

        string parseResponse(string input)
        {
            string statestring = "state=";
            int startindex = input.LastIndexOf(statestring, StringComparison.InvariantCultureIgnoreCase);

            if (startindex < 0)
            {
                state = null;
                return state;
            }
            startindex += statestring.Length;
            int endindex = input.IndexOf('&', startindex);
            if (endindex >= startindex)
            {
                state = input.Substring(startindex, endindex - startindex - 1);
            }
            else
            {
                state = input.Substring(startindex);
            }

            return state;
        }

        string ConstructResponse()
        {
            StringBuilder response = new StringBuilder();
            if (!string.IsNullOrEmpty(state))
            {
                response.Append("state=");
                response.Append(state);
                response.Append("&");
            }

            if (deviceId != null)
            {
                string signature = "";// Shared.EncodeFile(ourKey, deviceId);
                response.Append("signature=");
                response.Append(signature);
            }


            return response.ToString();
        }

        private string CreateQueryString()
        {
            string getDeviceId = "4f3564c416576088ecedb9119fe82168dc733ed6";
            if (deviceId != null)
                getDeviceId = deviceId;

            if (deviceId == null)
                deviceId = getDeviceId;

            string nonce = DateTime.UtcNow.Ticks.ToString();
            TimeSpan t = (DateTime.UtcNow - new DateTime(1970, 1, 1));

            int timestamp = (int)t.TotalSeconds;


            string querystring =
                string.Format("device={0}&mode=local&nonce={1}&product=autosilent&timestamp={2}&vendor=iphonepackers"
                    , getDeviceId, nonce, timestamp.ToString());


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
