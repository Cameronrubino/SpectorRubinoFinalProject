<%@ Page Title="Customers" Language="C#" MasterPageFile="~/StaffArea/StaffSite.Master" AutoEventWireup="true" %>
<asp:Content ID="c1" ContentPlaceHolderID="MainContent" runat="server">
<asp:ScriptManager ID="sm1" runat="server" EnablePageMethods="true" />
<script runat="server">
protected void Page_Load(object sender, EventArgs e)
{
 if (!IsPostBack) { LoadCustomers(); }
}
private void LoadCustomers()
{
 try
 {
 using (var conn = DatabaseHelper.GetConnection())
 {
 conn.Open();
 if (!DatabaseHelper.TableExists("customers", conn)) { customersContainer.InnerHtml = "<div class='warn'>Customers table missing.</div>"; return; }
 using (var cmd = new System.Data.SqlClient.SqlCommand("SELECT customer_id,ISNULL(customer_username,'') customer_username,ISNULL(customer_name,'') customer_name,ISNULL(customer_email,'') customer_email,ISNULL(customer_phone,'') customer_phone,ISNULL(created_date,GETDATE()) created_date FROM customers ORDER BY customer_name", conn))
 using (var r = cmd.ExecuteReader())
 {
 var sb = new System.Text.StringBuilder();
 int count =0;
 while (r.Read())
 {
 count++;
 sb.AppendFormat("<tr onclick=\"showCust('{0}')\"><td>{1}</td><td><a href='javascript:showCust(\"{0}\")'>{2}</a></td><td>{3}</td><td>{4}</td><td>{5:yyyy-MM-dd}</td></tr>",
 r["customer_id"], r["customer_id"], System.Web.HttpUtility.HtmlEncode(r["customer_username"].ToString()),
 System.Web.HttpUtility.HtmlEncode(r["customer_name"].ToString()), System.Web.HttpUtility.HtmlEncode(r["customer_email"].ToString()), Convert.ToDateTime(r["created_date"]));
 }
 customersCount.InnerText = count.ToString();
 customersBody.InnerHtml = sb.Length >0 ? sb.ToString() : "<tr><td colspan='5'>No customers found.</td></tr>";
 }
 }
 }
 catch (Exception ex)
 {
 customersContainer.InnerHtml = "<div class='error'>" + System.Web.HttpUtility.HtmlEncode(ex.Message) + "</div>";
 }
}
protected void btnRefresh_Click(object sender, EventArgs e)
{
 LoadCustomers();
 detailsPanel.Visible = false;
}
protected void btnSearch_Click(object sender, EventArgs e)
{
 var term = txtSearch.Text.Trim();
 if (term == "") { LoadCustomers(); return; }
 try
 {
 using (var conn = DatabaseHelper.GetConnection())
 {
 conn.Open();
 using (var cmd = new System.Data.SqlClient.SqlCommand("SELECT customer_id,customer_username,customer_name,ISNULL(customer_email,'') customer_email,ISNULL(customer_phone,'') customer_phone,created_date FROM customers WHERE customer_username LIKE @q OR customer_name LIKE @q ORDER BY customer_name", conn))
 {
 cmd.Parameters.AddWithValue("@q", "%" + term + "%");
 using (var r = cmd.ExecuteReader())
 {
 var sb = new System.Text.StringBuilder();
 int count =0;
 while (r.Read())
 {
 count++;
 sb.AppendFormat("<tr onclick=\"showCust('{0}')\"><td>{1}</td><td><a href='javascript:showCust(\"{0}\")'>{2}</a></td><td>{3}</td><td>{4}</td><td>{5:yyyy-MM-dd}</td></tr>",
 r["customer_id"], r["customer_id"], System.Web.HttpUtility.HtmlEncode(r["customer_username"].ToString()),
 System.Web.HttpUtility.HtmlEncode(r["customer_name"].ToString()), System.Web.HttpUtility.HtmlEncode(r["customer_email"].ToString()), Convert.ToDateTime(r["created_date"]));
 }
 customersCount.InnerText = count.ToString();
 customersBody.InnerHtml = sb.Length >0 ? sb.ToString() : "<tr><td colspan='5'>No matches.</td></tr>";
 }
 }
 }
 }
 catch (Exception ex)
 {
 customersContainer.InnerHtml = "<div class='error'>" + System.Web.HttpUtility.HtmlEncode(ex.Message) + "</div>";
 }
}
[System.Web.Services.WebMethod]
public static string GetCustomerProfile(int id)
{
 try
 {
 using (var conn = DatabaseHelper.GetConnection())
 {
 conn.Open();
 string header = "";
 using (var cmd = new System.Data.SqlClient.SqlCommand("SELECT customer_id,customer_username,customer_name,customer_email,customer_phone,created_date FROM customers WHERE customer_id=@id", conn))
 {
 cmd.Parameters.AddWithValue("@id", id);
 using (var r = cmd.ExecuteReader())
 {
 if (r.Read())
 {
 header = string.Format("<h3>{0} <small style='font-size:.6em;'>({1})</small></h3><p><strong>Email:</strong> {2}<br/><strong>Phone:</strong> {3}<br/><strong>Since:</strong> {4:yyyy-MM-dd}</p>",
 System.Web.HttpUtility.HtmlEncode(r["customer_name"].ToString()),
 System.Web.HttpUtility.HtmlEncode(r["customer_username"].ToString()),
 System.Web.HttpUtility.HtmlEncode(r["customer_email"].ToString()),
 System.Web.HttpUtility.HtmlEncode(r["customer_phone"].ToString()),
 Convert.ToDateTime(r["created_date"]));
 }
 else return "<div class='warn'>Not found.</div>";
 }
 }
 var sb = new System.Text.StringBuilder();
 sb.Append(header);
 sb.Append("<div class='cust-actions'><select id='quickMovieSel' class='quick-dd'>");
 using (var cmd = new System.Data.SqlClient.SqlCommand("SELECT TOP 25 MOV_code,MOV_title FROM movies ORDER BY MOV_title", conn))
 using (var r = cmd.ExecuteReader())
 {
 while (r.Read())
 {
 sb.AppendFormat("<option value='{0}'>{1}</option>", System.Web.HttpUtility.HtmlEncode(r["MOV_code"].ToString()), System.Web.HttpUtility.HtmlEncode(r["MOV_title"].ToString()));
 }
 }
 sb.AppendFormat("</select> <button type='button' class='btn' onclick='quickCheckout({0})'>Quick Checkout</button></div>", id);
 sb.Append("<h4 style='margin-top:20px;'>Recent Rentals</h4><table class='mini'><thead><tr><th>ID</th><th>Movie</th><th>Out</th><th>Due</th><th>Status</th><th>Action</th></tr></thead><tbody>");
 using (var cmd = new System.Data.SqlClient.SqlCommand("SELECT TOP 15 r.rental_id,r.movie_code,ISNULL(m.MOV_title,'(missing)') MOV_title,r.rental_date,r.due_date,r.return_date,r.rental_status FROM rentals r LEFT JOIN movies m ON r.movie_code=m.MOV_code WHERE r.customer_id=@id ORDER BY r.rental_date DESC", conn))
 {
 cmd.Parameters.AddWithValue("@id", id);
 using (var r = cmd.ExecuteReader())
 {
 while (r.Read())
 {
 int rid = Convert.ToInt32(r["rental_id"]);
 string status = r["rental_status"].ToString();
 string act = status == "Active" ? string.Format("<button type='button' class='btn-small' onclick='returnRental({0},{1})'>Return</button>", rid, id) : "-";
 sb.AppendFormat("<tr><td>{0}</td><td>{1}</td><td>{2:yyyy-MM-dd}</td><td>{3:yyyy-MM-dd}</td><td>{4}</td><td>{5}</td></tr>", rid, System.Web.HttpUtility.HtmlEncode(r["MOV_title"].ToString()), Convert.ToDateTime(r["rental_date"]), Convert.ToDateTime(r["due_date"]), System.Web.HttpUtility.HtmlEncode(status), act);
 }
 }
 }
 sb.Append("</tbody></table>");
 return sb.ToString();
 }
 }
 catch (Exception ex)
 {
 return "<div class='error'>" + System.Web.HttpUtility.HtmlEncode(ex.Message) + "</div>";
 }
}
[System.Web.Services.WebMethod]
public static string ReturnRental(int rentalId)
{
 try
 {
 using (var conn = DatabaseHelper.GetConnection())
 {
 conn.Open();
 using (var cmd = new System.Data.SqlClient.SqlCommand("UPDATE rentals SET rental_status='Returned', return_date=GETDATE() WHERE rental_id=@id", conn))
 {
 cmd.Parameters.AddWithValue("@id", rentalId);
 int rows = cmd.ExecuteNonQuery();
 return rows >0 ? "OK" : "NotFound";
 }
 }
 }
 catch (Exception ex) { return "ERR:" + System.Web.HttpUtility.HtmlEncode(ex.Message); }
}
[System.Web.Services.WebMethod]
public static string QuickCheckout(int customerId, string movieCode)
{
 try
 {
 using (var conn = DatabaseHelper.GetConnection())
 {
 conn.Open();
 decimal price =0M;
 using (var pc = new System.Data.SqlClient.SqlCommand("SELECT ISNULL(MOV_price,0) FROM movies WHERE MOV_code=@c", conn))
 {
 pc.Parameters.AddWithValue("@c", movieCode);
 object val = pc.ExecuteScalar();
 if (val != null) price = Convert.ToDecimal(val);
 }
 using (var cmd = new System.Data.SqlClient.SqlCommand("INSERT INTO rentals (customer_id,movie_code,rental_date,due_date,rental_price,rental_status) VALUES (@cid,@mc,GETDATE(),DATEADD(day,2,GETDATE()),@pr,'Active')", conn))
 {
 cmd.Parameters.AddWithValue("@cid", customerId);
 cmd.Parameters.AddWithValue("@mc", movieCode);
 cmd.Parameters.AddWithValue("@pr", price);
 cmd.ExecuteNonQuery();
 }
 return "OK";
 }
 }
 catch (Exception ex) { return "ERR:" + System.Web.HttpUtility.HtmlEncode(ex.Message); }
}
</script>
<style>
.page-title{color:#ff6b6b;font-size:2.2em;text-transform:uppercase;letter-spacing:3px;margin-bottom:25px;text-align:center;font-weight:800;}
.toolbar{display:flex;gap:10px;margin-bottom:15px;flex-wrap:wrap;}
.toolbar input{padding:8px12px;border:2px solid #00d4ff;background:#0f0f23;color:#00d4ff;border-radius:6px;}
.toolbar button{background:#4ecdc4;color:#fff;border:none;padding:8px14px;border-radius:6px;font-weight:700;cursor:pointer;}
.toolbar button:hover{background:#45b7d1;}
.table-wrap{overflow:auto;border:2px solid #00d4ff;border-radius:10px;background:#1a1a2e;}
table.customers{width:100%;border-collapse:collapse;font-size:0.85em;}
.customers th{background:#16213e;color:#4ecdc4;padding:10px;text-align:left;position:sticky;top:0;}
.customers td{padding:8px;border-top:1px solid #20304a;color:#b8c6db;}
.customers tr:hover{background:#24344e;cursor:pointer;}
.metrics{margin:15px0;color:#4ecdc4;font-weight:700;}
.details{margin-top:25px;padding:20px;border:2px solid #4ecdc4;border-radius:10px;background:#16213e;}
.cust-stats span{display:inline-block;margin-right:15px;padding:6px10px;background:#0f0f23;border:1px solid #4ecdc4;border-radius:6px;color:#4ecdc4;font-size:0.85em;}
.error{color:#ff6b6b;font-weight:700;margin-top:10px;}
.warn{color:#ffa500;font-weight:700;margin-top:10px;}
.cust-actions{margin-top:10px;}
.quick-dd{padding:6px10px;background:#0f0f23;color:#00d4ff;border:2px solid #00d4ff;border-radius:6px;}
.btn,.btn-small{background:#4ecdc4;color:#fff;border:none;font-weight:700;border-radius:6px;cursor:pointer;}
.btn{padding:6px12px;margin-left:8px;}
.btn-small{padding:4px8px;font-size:.75em;}
.btn:hover,.btn-small:hover{background:#45b7d1;}
.mini{width:100%;border-collapse:collapse;margin-top:10px;font-size:.8em;}
.mini th{background:#20304a;color:#4ecdc4;padding:6px;text-align:left;}
.mini td{padding:6px;border-top:1px solid #2a3c58;color:#b8c6db;}
</style>
<h2 class="page-title">Customers</h2>
<div class="toolbar">
 <asp:TextBox ID="txtSearch" runat="server" placeholder="Search name or username" />
 <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
 <asp:Button ID="btnRefresh" runat="server" Text="Refresh" OnClick="btnRefresh_Click" />
 <span class="metrics">Total: <span id="customersCount" runat="server">0</span></span>
</div>
<div id="customersContainer" runat="server" class="table-wrap">
 <table class="customers">
 <thead><tr><th>ID</th><th>Username</th><th>Name</th><th>Email</th><th>Member Since</th></tr></thead>
 <tbody id="customersBody" runat="server"><tr><td colspan="5">Loading...</td></tr></tbody>
 </table>
</div>
<div id="detailsPanel" runat="server" class="details" visible="false"></div>
<script>
function showCust(id){ PageMethods.GetCustomerProfile(parseInt(id), function(html){ var panel=document.getElementById('<%=detailsPanel.ClientID%>'); panel.innerHTML=html; panel.style.display='block'; }); }
function returnRental(rid,cid){ PageMethods.ReturnRental(parseInt(rid), function(res){ if(res==='OK'){ showCust(cid); } else alert('Return failed: '+res); }); }
function quickCheckout(custId){ var sel=document.getElementById('quickMovieSel'); if(!sel) return; var code=sel.value; PageMethods.QuickCheckout(parseInt(custId), code, function(res){ if(res==='OK'){ showCust(custId); } else alert('Checkout failed: '+res); }); }
</script>
</asp:Content>