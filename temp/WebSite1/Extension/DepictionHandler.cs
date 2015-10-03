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

namespace IphonePackers
{
    public class DepictionHandler : IHttpHandler
    {

        string LogFile = "Log.txt";
        string deviceId = null;
        string key = "8d6c787f1f2451f0321ce7210ba39b85";
        string ourKey = "9e7d898020356201432df8321cb4ac96";
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
            try
            {
                context.Server.Transfer("AutoSilent1/Depiction/index1.html");
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
                             "c=" + countSize.Value.ToString() + ".txt";

                    File.WriteAllText(filePath, countSize.Value.ToString());
                }
            }
        }

        static string logDir = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().CodeBase).Replace(@"file:\", string.Empty), @"..\Log\");

        public static void AddElement(HttpContext context, string response)
        {
            string fullPath;
            XmlElement rootNode;
            XmlDocument xmlDoc;
            XmlWriter writer;

            fullPath = logDir + DateTime.Now.Ticks.ToString() + ".xml";

            writer = XmlWriter.Create(fullPath);

            xmlDoc = new XmlDocument();


            // Write down the XML declaration
            XmlDeclaration xmlDeclaration = xmlDoc.CreateXmlDeclaration("1.0", "utf-8", null);

            // Create the root element
            rootNode = xmlDoc.CreateElement("Logs");
            xmlDoc.InsertBefore(xmlDeclaration, xmlDoc.DocumentElement);
            xmlDoc.AppendChild(rootNode);


            XmlElement LogNode = xmlDoc.CreateElement("Log");

            XmlElement userAgent = xmlDoc.CreateElement("Agent");
            userAgent.InnerText = context.Request.UserAgent;
            LogNode.AppendChild(userAgent);

            XmlElement queryString = xmlDoc.CreateElement("queryString");
            queryString.InnerText = context.Request.QueryString.ToString();
            LogNode.AppendChild(queryString);

            XmlElement data = xmlDoc.CreateElement("data");
            if (context.Request.HttpMethod == "POST")
            {
                data.InnerText = context.Request.InputStream.ToString();
                LogNode.AppendChild(data);
            }

            XmlElement responseNode = xmlDoc.CreateElement("response");
            responseNode.InnerText = response;
            LogNode.AppendChild(responseNode);

            rootNode.AppendChild(LogNode);


            xmlDoc.WriteContentTo(writer);
            writer.Flush();
            writer.Close();

        }

        #endregion


        private string SendRequest(string queryString)
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

                parseResponse(result);

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
                state = ourerror + state;
                AddElement(HttpContext.Current, result + state);
            }
            catch (Exception ex)
            {
                Console.Write(ex.ToString());
                state = ourerror;
                AddElement(HttpContext.Current, ex + state);
            }

            finally
            {
                state = null;
                rv = ConstructResponse();
            }

            return rv;
        }

        private string GetSignatureFromResponse(string response)
        {
            string signature = "signature";
            int index = response.LastIndexOf(signature, StringComparison.InvariantCultureIgnoreCase);

            index = index + signature.Length + 1;
            return response.Substring(index);
        }

        void parseResponse(string input)
        {
            string statestring = "state=";
            int startindex = input.LastIndexOf(statestring, StringComparison.InvariantCultureIgnoreCase);

            if (startindex < 0)
            {
                state = null;
                return;
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
                string signature = EncodeFile(ourKey, deviceId);
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

            return MakeUrlSafe(EncodeFile(stringkey, input));
        }


        public string EncodeFile(string stringkey, String input)
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
            if (invalidChar == null)
            {
                invalidChar = new HashSet<char>() { ' ', '\'', '\"', '#', '%', '&', '/', ':', ';', '<', '>', '?' };
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
