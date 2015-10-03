
using System.Text.RegularExpressions;
using System.Xml;
using System.Web;
using System;

namespace iPhonePackersCommon
{
    public class Utility
    {
        static string unsafefileNamePattern = "[^A-Za-z0-9]";

        public static bool IsAlphaNumeric(string file)
        {
            if (!string.IsNullOrEmpty(file) && !Regex.IsMatch(file, unsafefileNamePattern))
            {
                return true;
            }

            return false;
        }


        static XmlDocument xmlDoc = null;
        static object xmlDocLockObj = new object();
        static object rootLockObj = new object();
        static XmlWriter writer = null;
        static XmlElement rootNode = null;
        static string fullPath = null;
        static int MaxCount = 1;


        public static void AddElement(HttpContext context, string response)
        {



            if (xmlDoc == null)
            {
                lock (xmlDocLockObj)
                {
                    if (xmlDoc == null)
                    {
                        xmlDoc = new XmlDocument();
                        // Write down the XML declaration
                        XmlDeclaration xmlDeclaration = xmlDoc.CreateXmlDeclaration("1.0", "utf-8", null);

                        // Create the root element
                        rootNode = xmlDoc.CreateElement("Logs");
                        xmlDoc.InsertBefore(xmlDeclaration, xmlDoc.DocumentElement);
                        xmlDoc.AppendChild(rootNode);

                    }
                }
            }

            else
                if (rootNode != null && rootNode.ChildNodes != null && rootNode.ChildNodes.Count > MaxCount)
                {

                    lock (xmlDocLockObj)
                    {
                        if (rootNode != null && rootNode.ChildNodes != null && rootNode.ChildNodes.Count > MaxCount)
                        {
                            fullPath = Constants.logErrorDir + DateTime.Now.Ticks.ToString() + ".xml";

                            writer = XmlWriter.Create(fullPath);

                            xmlDoc.WriteContentTo(writer);
                            writer.Flush();
                            writer.Close();
                            xmlDoc = new XmlDocument();
                            // Write down the XML declaration
                            XmlDeclaration xmlDeclaration = xmlDoc.CreateXmlDeclaration("1.0", "utf-8", null);

                            // Create the root element
                            rootNode = xmlDoc.CreateElement("Logs");
                            xmlDoc.InsertBefore(xmlDeclaration, xmlDoc.DocumentElement);
                            xmlDoc.AppendChild(rootNode);


                        }
                    }
                }





            XmlElement LogNode = xmlDoc.CreateElement("Log");
            if (context != null)
            {
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
            }

            XmlElement responseNode = xmlDoc.CreateElement("response");
            responseNode.InnerText = response;
            LogNode.AppendChild(responseNode);

            lock (xmlDocLockObj)
            {
                rootNode.AppendChild(LogNode);
            }


        }

    }
}
