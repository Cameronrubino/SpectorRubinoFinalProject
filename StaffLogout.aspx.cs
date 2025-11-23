using System;

public partial class StaffLogoutPage : System.Web.UI.Page
{
 protected void Page_Load(object sender, EventArgs e)
    {
        // Clear staff authentication
Session.Remove("StaffAuthenticated");
        Session.Remove("StaffLoginTime");
        Session.Abandon();
 }
}