using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using YAX;

namespace Extension
{
    public class V2Handler
    {
         const string Defmessage = "App is being integrated with Cydia payment system, meanwhile enjoy trial period of 7 days";
         static HashSet<string> paidDevieIds = new HashSet<string>()
        {
            "183b2b917ff7ee2ef089ce6272f965d0505c82f3"
           ,"c2a5cbce9e0c434fe67e47b2f563d9d42f0285aa" //Marcelo Herrero
           ,"cb3c0adcb8d2e333e9d7a244b683bbe69f8da4ca" //Jan Jagersma 
           ,"60261ee66feb5d9e64f0b74b5261752cfa9d858f" //Krzysztof Kupracz 
           ,"e4f3fb474cdf6c157ec114271cc4c4048a2c1270"  //Thierry Scheller
           ,"cb3c2b475729200373068174d882c633b139cbbd" //Jeffrey Kang 
           ,"8af0369658abc1f7e3b17f28bd93e0e5ef0ea16e"
          ,"4f3564c416576088ecedb9119fe82168dc733ed6" //hitesh uid
          , "77639d6d06dd46365508782d16a8bdb548b6031f" //Guillaume Caburrasi 
          , "5b0eec785000016f54b3e709e8471b445240752a" //Christoph Hofer 
          , "6e3ac83d9bf67fe7b32ae860ba7ff9513593876f" //megha kande
          , "c0ed87465a3187b55a322c2dfc86b95e643034be" //an-andre albertini
        , "2ac84a9fe2c503412fa3fce7470b6aee61ad4b18" //Ian Gregory
        , "87b7e8f2c98e45a5b5bc887ae59a6db84ce572e1" //P.A.M Hanegraaf, Pieter@Hanegraaf.info
        , "eedb4ff5656ecb6ad7d47a34a522f82aafce06f1" //Ian Callaghan
        , "183b2b917ff7ee2ef089ce6272f965d0505c82f3" //William Wong
        , "d30f51439e4e3ac5f87f3ae6b59215d9cca152eb" //Alon Traut   
        };

        public static string ConstructResponse(string deviceId, string state, string appId)
        {
            string message = Defmessage;
            StringBuilder response = new StringBuilder();
            string signature = string.Empty;
            if (!string.IsNullOrEmpty(deviceId) 
                && (PaymentProcessor.GetTransactionStatusForDeviceAndApp(deviceId, appId) == TransactionStatus.Completed
                || paidDevieIds.Contains(deviceId, StringComparer.OrdinalIgnoreCase)))
            {
                message = @"Congratulations. The app has been activated. If you get activation message again please upgrade to 1.2.0001 or higher. More info at http://www.iphonepackers.info/vissue.htm";
                signature = Shared.EncodeFile(Constants.ourKey, deviceId);
            }

            return string.Format("stt={0}&msg={1}&sig={2}", state, message, signature);
            //return string.Format("stt={0}&msg={1}&sig={2}", "error", "you are successful!", "");
        }
    }
}
