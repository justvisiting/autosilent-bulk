using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using IphonePackers;
using Extension.Database;
using Extension;
//using Extension.Handlers;
//using Extension;

public partial class Buy : System.Web.UI.Page
{
    
    protected string BuyString;
    protected void Page_Load(object sender, EventArgs e)
    {
        BuyString = BuyHandler.GetBuyBlurb(Context, "3.00", false, string.Empty);
        //this.InvalidReferralCodeError = false;
    }

    /// <summary>
    /// valid md5 code = "9c5d111bcd4e16dda8661aae0d008485"
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void referralCodeClick_Click(object sender, EventArgs e)
    {
        if (this.IsPostBack)
        {
            IsPaymentVisible.Text = "1";
            InvalidReferralCodeError.Visible = true;
            string referralCode = referralcodeId.Text;

            if (!string.IsNullOrEmpty(referralCode))
            {
                if (ReferralCore.IsPaidMd5Code(referralCode))
                {
                    BuyString = BuyHandler.GetBuyBlurb(Context, "3.00 - 0.15 (5% referral discount) = 2.85", true, referralCode);
                    InvalidReferralCodeError.Visible = false;
                }
            }
        }
    }
}
