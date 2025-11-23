using System;
public partial class StaffSiteMaster : System.Web.UI.MasterPage
{
 protected void Page_Load(object sender, EventArgs e)
 {
 if (Session["StaffAuthenticated"] == null || !(Session["StaffAuthenticated"] is bool && (bool)Session["StaffAuthenticated"]))
 {
 Response.Redirect("~/StaffLogin.aspx");
 }
 }
}