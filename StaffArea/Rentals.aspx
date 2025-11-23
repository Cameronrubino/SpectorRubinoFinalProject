<%@ Page Title="Rentals" Language="C#" MasterPageFile="~/StaffArea/StaffSite.Master" AutoEventWireup="true" %>
<asp:Content ID="c1" ContentPlaceHolderID="MainContent" runat="server">
<asp:ScriptManager ID="smR" runat="server" EnablePageMethods="true" />
<script runat="server">
protected void Page_Load(object sender,EventArgs e){ if(!IsPostBack){ LoadActive(); LoadOverdue(); } }
void LoadActive(){ rentalsActive.InnerHtml = LoadByQuery("SELECT rental_id,customer_id,movie_code,rental_date,rental_price FROM rentals WHERE rental_status='Active' ORDER BY rental_date DESC"); }
void LoadOverdue(){ rentalsOverdue.InnerHtml = LoadByQuery("SELECT rental_id,customer_id,movie_code,rental_date,rental_price FROM rentals WHERE rental_status='Active' AND DATEDIFF(day,rental_date,GETDATE())>7 ORDER BY rental_date DESC"); }
string LoadByQuery(string sql){ try{ using(var conn=DatabaseHelper.GetConnection()){ conn.Open(); if(!DatabaseHelper.TableExists("rentals",conn)) return "<tr><td colspan='6' class='warn'>Rentals table missing.</td></tr>"; using(var cmd=new System.Data.SqlClient.SqlCommand(sql,conn)) using(var r=cmd.ExecuteReader()){ var sb=new System.Text.StringBuilder(); int count=0; while(r.Read()){ count++; DateTime d=Convert.ToDateTime(r["rental_date"]); decimal price=Convert.ToDecimal(r["rental_price"]); sb.AppendFormat("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3:MMM dd, yyyy}</td><td>${4:F2}</td><td><button type='button' onclick='markReturned({0})'>Return</button></td></tr>", r["rental_id"], r["customer_id"], r["movie_code"], d, price); } return count>0? sb.ToString():"<tr><td colspan='6'>None found</td></tr>"; } } } catch(Exception ex){ return "<tr><td colspan='6' class='error'>"+System.Web.HttpUtility.HtmlEncode(ex.Message)+"</td></tr>"; } }
[System.Web.Services.WebMethod]
public static string ReturnRental(int id){ try{ using(var conn=DatabaseHelper.GetConnection()){ conn.Open(); using(var cmd=new System.Data.SqlClient.SqlCommand("UPDATE rentals SET rental_status='Returned', return_date=GETDATE() WHERE rental_id=@id",conn)){ cmd.Parameters.AddWithValue("@id",id); int rows=cmd.ExecuteNonQuery(); return rows>0?"OK":"Not found"; } } } catch(Exception ex){ return "ERR:"+System.Web.HttpUtility.HtmlEncode(ex.Message); } }
</script>
<style>
.page-title{color:#ff6b6b;font-size:2.2em;text-transform:uppercase;letter-spacing:3px;margin-bottom:25px;text-align:center;font-weight:800;}
.section{margin-bottom:35px;}
.section h3{color:#4ecdc4;font-size:1.4em;margin-bottom:10px;text-transform:uppercase;letter-spacing:2px;}
.table-wrap{overflow:auto;border:2px solid #00d4ff;border-radius:10px;background:#1a1a2e;}
table{width:100%;border-collapse:collapse;font-size:0.85em;}
th{background:#16213e;color:#4ecdc4;padding:9px;text-align:left;}
td{padding:8px;border-top:1px solid #20304a;color:#b8c6db;}
button{background:#4ecdc4;color:#fff;border:none;padding:6px10px;border-radius:6px;font-weight:700;cursor:pointer;font-size:0.7em;}
button:hover{background:#45b7d1;}
.error{color:#ff6b6b;font-weight:700;}
.warn{color:#ffa500;font-weight:700;}
</style>
<h2 class="page-title">Rentals Management</h2>
<div class="section">
 <h3>Active Rentals</h3>
 <div class="table-wrap">
 <table><thead><tr><th>ID</th><th>Customer</th><th>Movie</th><th>Date</th><th>Price</th><th>Action</th></tr></thead><tbody id="rentalsActive" runat="server"><tr><td colspan="6">Loading...</td></tr></tbody></table>
 </div>
</div>
<div class="section">
 <h3>Overdue Rentals</h3>
 <div class="table-wrap">
 <table><thead><tr><th>ID</th><th>Customer</th><th>Movie</th><th>Date</th><th>Price</th><th>Action</th></tr></thead><tbody id="rentalsOverdue" runat="server"><tr><td colspan="6">Loading...</td></tr></tbody></table>
 </div>
</div>
<script>
function markReturned(id){ PageMethods.ReturnRental(id,function(resp){ if(resp.indexOf('OK')===0){ location.reload(); } else { alert('Return failed: '+resp); } }); }
</script>
</asp:Content>