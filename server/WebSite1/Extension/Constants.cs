using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Reflection;

namespace Extension
{
    public class Constants
    {
        public const string DefaultAppId = "autosilent";
        public const string ourKey = "9e7d898020356201432df8321cb4ac96";
        public static string logErrorDir = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().CodeBase).Replace(@"file:\", string.Empty), @"..\Log\Error\");
        public static string logDir = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().CodeBase).Replace(@"file:\", string.Empty), @"..\Log\");

        public static string rootDir = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().CodeBase).Replace(@"file:\", string.Empty), @"..\");

        public static string successPaymentSatus = "Completed";

        public static string serverUrl = @"http://iphonepackers.info/app/";

        public static string SuccessMessage = @"Congratulations. The app has been activated";

        public static string CydiaSuccessMessage = @"Congratulations. The app has been activated";
       

    }
}
