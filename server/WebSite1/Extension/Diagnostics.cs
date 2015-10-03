using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.IO;
using System.Text.RegularExpressions;
using System.Threading;
using System.Xml;
using System.Net;
using iPhonePackersCommon;

namespace Extension
{

    internal class AsyncInfo
    {
        public AsyncInfo() { }
        public AsyncInfo(string fulfilepath, byte[] buffer)
        {
            this.FullFilePath = fulfilepath;
            this.Buffer = buffer;
        }

        public string FullFilePath { get; set; }
        public byte[] Buffer { get; set; }
    }

    public class Diagnostics
    {
        const int MaxLogDir = 50;
        const int MaxFileCount = 250;
        const int MaxContentSize = 100 * 2000;


        public static HttpStatusCode GetDataToStore(string code, string file, HttpContext context)
        {

            if (string.IsNullOrEmpty(code) || !Utility.IsAlphaNumeric(code)
                || string.IsNullOrEmpty(file) || !Utility.IsAlphaNumeric(file))
            {
                //work around to allow this particular file
                if (file != ".OrigSystemSoundBehaviour"
                    && file != "com.apple.springboard"
                    && file != "com.apple.accountsettings")
                {
                    return HttpStatusCode.RequestUriTooLong;
                }
            }

            if (context.Request.ContentLength > MaxContentSize)
            {
                return HttpStatusCode.RequestEntityTooLarge;
            }

            string logToWriteDir = debugLogDir + "\\" + code;

            if (!TryCreatNewDeviceDir(logToWriteDir)
                || Directory.GetFiles(debugLogDir).Length > MaxLogDir)
            {
                return HttpStatusCode.Unauthorized;
            }

            string fileName = logToWriteDir + @"\" + file + ".plist";

            string[] files = Directory.GetFiles(logToWriteDir);

            if (files.Length > MaxFileCount)
            {
                return HttpStatusCode.Unauthorized;
            }
            if (files.Contains(fileName, StringComparer.OrdinalIgnoreCase))
            {
                return HttpStatusCode.OK;
            }

            byte[] buffer = new byte[context.Request.ContentLength];

            AsyncInfo asyncInfo = new AsyncInfo(fileName, buffer);

            int readBytes = 0;

            while (readBytes < context.Request.ContentLength)
            {
                readBytes += context.Request.InputStream.Read(buffer, readBytes, context.Request.ContentLength - readBytes);
            }

            ThreadPool.QueueUserWorkItem(new WaitCallback(WriteAsyncCallback), asyncInfo);

            return HttpStatusCode.OK;

        }


        private static void WriteAsyncCallback(object data)
        {
            try
            {

                AsyncInfo asynData = data as AsyncInfo;
                if (asynData != null && !string.IsNullOrEmpty(asynData.FullFilePath)
                    && asynData.Buffer != null && asynData.Buffer.Length > 0)
                {
                    string content = System.Text.UTF8Encoding.UTF8.GetString(asynData.Buffer);
                    File.WriteAllText(asynData.FullFilePath, content);
                }
            }
            catch (Exception ex)
            {
                File.WriteAllText(Constants.logErrorDir + @"\logDiagFailure.txt", ex.ToString());
            }

        }





        static volatile int numberOfDirInDebugLogDir;
        static string debugLogDir;

        static Diagnostics()
        {
            debugLogDir = Constants.logDir;

            numberOfDirInDebugLogDir = Directory.GetFiles(debugLogDir).Length;
        }

        private static object createDeviceDirLockObj = new object();

        private static bool TryCreatNewDeviceDir(string deviceId)
        {
            if (numberOfDirInDebugLogDir < MaxLogDir)
            {
                lock (createDeviceDirLockObj)
                {
                    if (!Directory.Exists(deviceId))
                    {
                        Directory.CreateDirectory(deviceId);
                        numberOfDirInDebugLogDir++;
                    }

                }

                return true;
            }

            return false;
        }

    }

}

