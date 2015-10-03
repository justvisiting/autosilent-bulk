using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using YAX;
using iPhonePackersCommon;

namespace Extension
{
    public class V2Handler
    {
         
         public static HashSet<string> paidDevieIds = new HashSet<string>()
        {
            "06f9c6285419c53c1fccd930b57395096ba876e4" //carl partial payment
            , "48b291bc4a3b44a5a5acec200b74e28f78e5f954"//kevin Amazon
      ,"ae8b228786a2fd14802c0627f20fd604cdc4e00b" //Joe Strafach
           , "c2a5cbce9e0c434fe67e47b2f563d9d42f0285aa" //Marcelo Herrero
           ,"cb3c0adcb8d2e333e9d7a244b683bbe69f8da4ca" //Jan Jagersma 
           ,"60261ee66feb5d9e64f0b74b5261752cfa9d858f" //Krzysztof Kupracz 
           ,"e4f3fb474cdf6c157ec114271cc4c4048a2c1270"  //Thierry Scheller
           ,"cb3c2b475729200373068174d882c633b139cbbd" //Jeffrey Kang 
           ,"8af0369658abc1f7e3b17f28bd93e0e5ef0ea16e"
          //,"4f3564c416576088ecedb9119fe82168dc733ed6" //hitesh uid
          , "77639d6d06dd46365508782d16a8bdb548b6031f" //Guillaume Caburrasi 
          , "5b0eec785000016f54b3e709e8471b445240752a" //Christoph Hofer 
          , "6e3ac83d9bf67fe7b32ae860ba7ff9513593876f" //megha kande
          , "c0ed87465a3187b55a322c2dfc86b95e643034be" //an-andre albertini
        , "2ac84a9fe2c503412fa3fce7470b6aee61ad4b18" //Ian Gregory
        , "87b7e8f2c98e45a5b5bc887ae59a6db84ce572e1" //P.A.M Hanegraaf, Pieter@Hanegraaf.info
        , "eedb4ff5656ecb6ad7d47a34a522f82aafce06f1" //Ian Callaghan
        , "183b2b917ff7ee2ef089ce6272f965d0505c82f3" //William Wong, William W <williamchw@yahoo.com>
        , "d30f51439e4e3ac5f87f3ae6b59215d9cca152eb" //Alon Traut   
        , "2c80577243b3d9957a378d23cab172bc5605e32b" //Eric P. Haase
        , "3a792b8cfbb1eb1aba81375a21a670928d20081f" //ronald brink
        , "19b723ba1dce260b7460e72eadc0c3cb6872034e" //Martin.Fricker@swisscom.com
        //, "95ef614a3ea1faf239af86df20444775309224f5" //phamtanphat@gmail.com Sky Robinson - 3 3g 2 3gs
        , "d02cf9caa13060ccfc3ce5cbaeae2e22bf622445" //Yoshihiko SAKAI
		, "305283cebe10dfeaaa3397ac24e06313ab399f85" //Michael Schnettler Michael@Schnettler.biz
        , "c23ae16aa21e4c4fb5761770309d87a2e102aeb9" //Ron Rhone <r3rho@yahoo.com>, paypal shows the transaction but does not show any notificaiton to iphone packers so adding manually.
        , "81a22f233e537836d82f5e851102455f0d2d0bbb" //occhinival@yahoo.it Valentina Occhini
        , "2c07b4759358c5ff57c51a1e51e062f9539c3c55" //updated to his new phone, Adrian MZ <adriv3@hotmail.com> spanish translator
        , "c140a40d968d74a57607cf52bbe2cf11e986d262" //Frederik Meyer    (The sender of this payment is Non-U.S. - Verified)xPFx@gmx.de
        , "78abcb513882ec095cf5cb5bcd9900de02a1896f" //Christopher Gabrielides chrisvgabz@tiscali.co.uk
        , "d8a36fb4bee76a824911be0d61eb97e81d79d4db" //Robert Picard rpicard@brocksolutions.com
        , "e0b78e0739be42dcfb8b1a2e8a2d4fc951716460" //Mickey<mickeysemail@hotmail.com> paid through Cydia store but somhow cydia does not return
        , "9ff8ae1909bb0bee3502c6e513c051fa3058586d" //euGen <izbitu9@yahoo.com>...payment pending some crap.  paid through Cydia.       
        , "f0db2d0b2cafe0c1f8042d19464ac774addc2df6" // rick Timm..paid through paypal but somehow doesnt work
        , "12b01edf889dd7205581225a26f83ee65a700b54" //Gabi Schnettler, Gabi@Schnettler.biz paid thorough papal but somehow does not work. Was testing during that time it might have screwed up.
        , "09e93cd6710c903f2f6a8071ea38bf8a6f0d552a" //hitesh new 3gs
        , "955ac4c282b23e710a523e9be4ddb65b57e7ca08" //Benjamin Santos <benjaminsantos50@gmail.com> bought from ebay assuming app will also be sold for $1. As courtsy gave it for $1
        , "d56d15797b8d4446b7d9f332f4d8762bfcd460a8" //Sonic <sonic74@gmail.com> for dutch translation
        , "b9427232b959ebcb01f74ea89d218041c5afc971" //Jerry Lee <jerrylee@me.com> for traditional chinese translation
        , "991d78b34d824e5a5ca04aa8009a9f6fabe6b15e" //François Bochatay <francois.bochatay@gmail.com> for french translation
        , "986b1171aa89f3cd94c1dfa7af4c03f2145cd17b" //François Bochatay <francois.bochatay@gmail.com> gf for french translation
        , "c57899f76b082598cb2a63e87e62ea06682d1921" //Oleg Golovliov <olegjdn@gmail.com> for russian translation
        , "636fbfc8adecc91bf35443e7edad2b350bf7c7b2" //Kelly Kambe <gca00105@gmail.com> for Japanese translation
        , "55cba03a497558518a7cc60a9babce256633bf4d" //Personal <vmmcuk@yahoo.co.uk> for Portuege translation
        , "0a54ebf4fcc3ba5473c795a98b140f21c1921721" //Erwin Remmen van <e.vanremmen@me.com> paid third time
        , "1dfdd88e7ef97d28c2c7ef26486d46654405ad63" //Peter Görtz <p-goertz@web.de>
        , "7decc61ff930488dd447fa1198083faa46bef735" //
, "5a491d49e1f07c451b167e0e1ebebf1ef5dcbe9b"
, "73fd4e561a0a2dc0235a96a9be4e7eb83daf1f52"
, "e207b08356b7d4ea27fc852c9600d9238587dc49"
, "107028150c9b2a6bfd5f6a50a31a94336d39c11e"
, "bb9fe416f10df1f60d0db4a049688ad36892ea5a"
, "6bc82085b04c5c89067e5b7a22c1a870bfca8eb5"
, "f60ecc5b62084a249e73eae437bd8ae76a47183b"
, "af1a24a914dbe59ad4107bb25c0020550602f01d"
, "af855fc6426d895c0052a7117b57b90e17725944"
, "f1045debf65bc3f23260290fca397fc3bad42248"
, "07c23c3785c71b8f1765fc04650077829de52412"
, "cfa0c3a4fc6b82c0481ee9122ac54ecda86e355c"
, "038dcf54bfa9e2b081b671f715f8415375b01bc2"
, "3213b99a294d519dd1fb24f4cacd049abc41a59f"
, "94b894ade48f190c6aec64b44e6362dd6de8fa8b"
, "19d3acd9cc0fa71f2929ced5b86beba7bbe12ada"
, "9695f4704be4776309e764e497a0a5d9a2d82002"
, "9df61635b4ff4e8c6080ee2850631d7755127119"
, "a645e3f3fcfe128f17d822dea03f600f4fb0faee"
, "8dc053d5b2f9c6a99186954b6e46988139915fcb"
, "4031a6d10ba43275a1c86598d9d4270b4b7ff0f1"
, "a5af51c5af722959d89ddad36dc780eace79f1df"
, "085b2e6a267753f39d1cded3cd8a0c601041683e"
, "9b39cace7d11c16d3da20b8a646f12a36662614d"
, "6564fa1f0f49c448c4a0fca9cef9c7424a8b27c7"
, "a507c5fd38e218e97be65d6f8e43b489fd8fde7b"
, "da4cff1367a782163e9b9d85a2e99bbf01e7e228"
, "c4766071280983d9640b935265430b4b09912c3f"
, "70b526847e8c23d169f1d94446ecb6c805a6280b"
, "ca1268a9daaa42451947cf50f6ca79f76ad6f720"
, "bbf1f41aaa2de6dafdcdeb46127dbe09ea7b497c"
, "119c0a118c7ddb16c8bb513c4aa16917f697d6bd"
, "cae7e0c7fb49208bf1b84026c2a287433925abf3"
, "89d102894689e686e299c6a627517dac9de9d34f"
, "0aa26cdab72707256294e524dc6560e826204b73"
, "f61ac5eb7bc5b078da76101191158900af947a78"
, "123b7a21faee687219f2a8c7732883aeac47997b"
, "3bf6f7c32b997e6690a2c939d05c326393d50834"
, "019b7915cb2e613c4b91a5a0862fd7d445854875"
, "81cca17560a8accaf828216ceec577f04bde7a01"
, "3e9a9993df943b0b6e3d89a9c3febbda283bd93d"
, "d38b3ad8f3725ec5ce001ecb290aa4eda9845874"
, "166cb122b233b0e6f6d19dd96b50ff70fb8225e1"
, "e3b239fee4d34d8e9755319cf5a8a4e6f1c7c2c3"
, "59c88300ce0f06a800dab2690e4044f33adc3192"
, "8a30a134b9219bb31703833f72375125f4ef940d"
, "dbcc3cb9ca4ace250fc5f24ad73315bb6d36a89f"
, "45c84310deea60c34263732cd0cee1aa6a622c1e"
, "88abc8c128dbdaa0519e08f84873e99fce6d865d"
, "7d437bf7281cb2f64e551fcf9c675986852eee04"
, "d02fdc83f79ad2faac3b98853f5a044fd0b8df2c"
, "18375f278c7232b9137f52399ac0c83fccf5d2e4"
, "97815ed3cffc43eac49168ec4400a62dfe846958"
, "04a8f4d5040d91dfcd6105d58bafd191cadba66f"
, "0bf8543f2b77910c377df716e59e05431ab84810"
, "9b9ab8559de71845d2819e1dfdc0268993377c67"
, "c86f20c7d97ab8085732bb284ed2690e9d7fbffe"
, "319b2ab0ac0c70b570adf14d296d87564bc2e175"
, "9181b3d56f07abefc8ce8d0cb57f1213f759dce7"
, "257a2aea6d21e93cc49c874c16defa84ef3ed007"
, "83b97b911bfc796aa1a7539d55165ae64f14c0cc"
, "4e1c0165835300d1df17f97eeac79744a27b1ba8"
, "18a6bef34b7d71d77f6c844cb6a0ba7cb689b4e7"
, "6bc817d1de83a85afef6be6dba574bc49f627f06"
, "de713208abec15e42aa7b1cb4c560528f79c8fdb"
, "2d79faf372ba41affc95cfc9f1577f9ba5d56c9e"
, "9cb41a867147c260a3aa666ba14f08b4e446af62"
, "35933f11b95fb0be776664a023563ec897bbef28"
, "24852f9bd4b16357da99702fc70c9628c3aa9ab7"
, "1caf59049121b352454caacadcd3a3ddb11b3b0a"
, "e7a0e8dc0fcd534181a080ac76bb30f20cfb3108"
, "19d3acd9cc0fa71f2929ced5b86beba7bbe12ada"
, "095f0e4698c8ca94b3645a80cc43c72eeb4965a6"
, "28407e83e6871d0aa9cce989ea7bf3d3aac0f2f4"
, "e55e918e1bc0284b6c7375c6290bfdd4c5d03a3a"
, "d055b64e7c4b7853bbd935c20971ad7d8f5f54eb"
, "5b9afe04745c42cb8c7139288cce5ef27184b474" //8-17
, "2f3d8277e03e7c03b08290ed0ae925adfe04de70"
, "22ae20cffe8416cc80e0c0cacad04d167a1365ab"
, "cf7a5baefd8ec6755d045acddc8b988abbc77f9d"
, "413720654c19e7bb8227221594de8fd3dfc3958f"
, "8ae2bd8da72e270dc585e76f1a58e3e6e60772d4"
, "3b2419833f5c597a78039a65340389fbe753a05e"
, "c35b40a7aa331b49dc681cda068bfc1558b6f5d2"
, "7dded0b52c3575c7de2b7c939be9950f242320b2"
, "a775bf8007cf50fb82092eafa102fc7f8d152207"
, "95fedd4441b5e594703cc8a715e9faab4270aa26"
, "61a11dc5dce1d00b0ad39262547991a31fe96e41"
, "f10ae1f4f542fbf9682a18f16db07a454bb3944d"
, "7308b4c5b974e1876a3b5ca8a4ed486f0658584f"
, "9d000c7dd5fb07409bcd341b8b052eb5d8a6e80e"
, "ac4a54afd77f4d4dc88763616b7405e19694fb8d"
, "2189f3120aacfdeb44f49559ef4056b49e201547" // sep 3


        };

         public static string ConstructResponse(string deviceId, string state, string appId, string locale, bool debug, out TransactionStatus transactionStatus)
        {
            string message = string.Empty;
            StringBuilder response = new StringBuilder();
            string signature = string.Empty;
            transactionStatus = TransactionStatus.Failed;
            string debugInfo = "in construct response";
            if (!string.IsNullOrEmpty(deviceId))
            {
                debugInfo += "device id non null, getting transactions status";
                transactionStatus = PaymentProcessor.GetTransactionStatusForDeviceAndApp(deviceId, appId, debug, ref debugInfo);

                if (transactionStatus == TransactionStatus.Completed
                    || paidDevieIds.Contains(deviceId, StringComparer.OrdinalIgnoreCase))
                {
                    signature = Shared.EncodeFile(Constants.ourKey, deviceId);
                    state = Constants.successPaymentSatus;
                    message = Shared.GetAppVerifyMessage(locale, true);
                    transactionStatus = TransactionStatus.Completed;
                }
                else
                {
                    state += transactionStatus;
                }
            }

            if (message == string.Empty)
            {
                message = Shared.GetAppVerifyMessage(locale, false);
            }

            if (!debug)
            {
             return   string.Format("stt={0}&msg={1}&sig={2}", state, message, signature);
            }

            return string.Format("stt={0}&msg={1}&sig={2}&debug={3}", state, message, signature, debugInfo);
           
        }
    }
}
