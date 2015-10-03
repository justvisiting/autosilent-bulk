using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.IO;
using System.Xml;

namespace PaymentLibrary
{
    public class XmlSerialize
    {
        public static T Deserialize<T>(string filePath)
        {
            if (File.Exists(filePath))
            {
                XmlDocument doc = new XmlDocument();
                doc.Load(filePath);

                return Deserialize<T>(doc);

            }

            return default(T);
        }

        //public static T Deserialize<T>(string rawString)
        //{
        //    if (String.IsNullOrEmpty(rawString))
        //    {
        //        throw new ArgumentNullException("rawString");
        //    }

        //    T deserializedItem = default(T);
        //    XmlSerializer serializer = new XmlSerializer(typeof(T));
        //    MemoryStream memStream = new MemoryStream();
        //    StreamWriter writer = new StreamWriter(memStream);

        //    try
        //    {
        //        writer.Write(rawString);
        //        writer.Flush();
        //        memStream.Position = 0;
        //        deserializedItem = (T)(serializer.Deserialize(memStream));
        //    }

        //    // cleanup
        //    finally
        //    {
        //        writer.Close();
        //        memStream.Close();
        //        memStream.Dispose();
        //    }

        //    return deserializedItem;
        //}

        public static T Deserialize<T>(XmlNode xmlNode)
        {
            if (xmlNode == null)
            {
                throw new ArgumentNullException("xmlNode");
            }

            T deserializedItem = default(T);
            XmlSerializer serializer = new XmlSerializer(typeof(T));
            MemoryStream memStream = new MemoryStream();
            XmlWriter writer = XmlWriter.Create(memStream);

            try
            {
                xmlNode.WriteTo(writer);
                writer.Flush();
                memStream.Position = 0; // reset position
                deserializedItem = (T)(serializer.Deserialize(memStream));
            }
            finally
            {
                // cleanup
                writer.Close();
                memStream.Close();
                memStream.Dispose();
            }

            return deserializedItem;
        }



        public static void Serialize<T>(string fileName, T obj, Encoding encoding)
        {
                XmlSerializer serializer = new XmlSerializer(typeof(T));

                using (TextWriter writer = new StreamWriter(fileName, false, encoding))
                {
                    serializer.Serialize(writer, obj);
                }

        }

    }
}
