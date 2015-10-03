<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Buy.aspx.cs" Inherits="Buy" %>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en-US">
<head>
    <title>Auto Silent</title>
    <meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" type="text/css" href="iPhoneStyle.css" />
    <base target="_blank" />
    <link rel="stylesheet" type="text/css" href="iPhoneStyle.css" />

    <script language="javascript">
function AcceptClicked()
{
	document.getElementById("PaymentSpan").style.display = 'block';
}

function BodyLoad()
{
	document.getElementById("PaymentSpan").style.display = 'none';
}

    </script>

</head>
<body onload="BodyLoad()">
    <div id="page">
        <div class="dialog">
            <div class="panel">
                <fieldset>
                    <div>
                        <img src="/images/icon.png" style="vertical-align: middle" width="59" height="60" />
                        <div style="float: right; margin-top: 3px">
                            <span style="font-size: large">Auto Silent</span><br />
                            <span style="font-size: small">Enjoy the silence!</span>
                            <br />
                        </div>
                    </div>
                </fieldset>
                
                <span id="LicenseSpan">
                <fieldset>
                    <div>
                        <p align="center">
                            <b> This is a test page but payment is real</b>
                            <b>Purchase License, Terms and Conditions:</b></p>
                        <div>
                            <p>
                                <b>By downloading or buying the app you accept the following license agreement:
                                </b>
                            </p>
                            <p>
                                Auto Silent software is sold &#39;as is&#39;. All warranties either expressed or
                                implied are disclaimed as to the software, its quality, performance, usability,
                                fitness for any particular purpose(s). You, the consumer, bear the entire risk relating
                                to the software, caused by it directly or indirectly. In no event its developers,
                                iPhone Packers or any members of its team wil be liable for direct, indirect, incidental
                                or consequential damages resulting from the defect or using the software. If the
                                software is proved to have defect, you and not iPhone Packers or its team assume
                                the cost of any necessary service or repair.
                            </p>
                           
                            <p>
                                In order to buy and if you agree to license terms and conditions, please click Accept.
                            </p>
                            <form method="POST" action="--WEBBOT-SELF--">
                            <!--webbot bot="SaveResults" U-File="fpweb:///_private/form_results.csv" S-Format="TEXT/CSV" S-Label-Fields="TRUE" -->
                            <p align="center">
                                <input type="button" value="Accept" name="B3" onclick="javascript:AcceptClicked()">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <input type="button" value="Do Not Accept" name="B1" onclick="parent.location='/CancelDonation.htm'"></p>
                            </form>
                        </div>
                </fieldset>
                </span>
                <span id="PaymentSpan">
                    <fieldset>
                    <div>
                        <p align="center">
                            <% =BuyString%>
                        </p>
                        </div>
                    </fieldset>
                </span>
                </div>
                </div>
                </div>
</body>
</html>
