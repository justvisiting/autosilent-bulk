using System.Xml;
using System.Web;
using Extension;
using System;
public class LogWriter
{

    public LogWriter(string fileName)
    {

    }
    XmlDocument xmlDoc = null;
     object xmlDocLockObj = new object();
     object rootLockObj = new object();
     XmlWriter writer = null;
    XmlElement rootNode = null;
    string fullPath = null;
    const int MaxCount = 20;

    public void AddElement(HttpContext context, string response)
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
                        fullPath = Constants.logDir + DateTime.Now.Ticks.ToString() + ".xml";

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

        lock (xmlDocLockObj)
        {
            rootNode.AppendChild(LogNode);
        }




    }

}