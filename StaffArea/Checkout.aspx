<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/StaffArea/StaffSite.Master" AutoEventWireup="true" %>
<asp:Content ID="c1" ContentPlaceHolderID="MainContent" runat="server">
<script runat="server">
protected void Page_Load(object sender,EventArgs e){ if(!IsPostBack){ LoadCustomers(); LoadMovies(); } }
void LoadCustomers(){ try{ using(var conn=DatabaseHelper.GetConnection()){ conn.Open(); if(!DatabaseHelper.TableExists("customers",conn)) return; using(var cmd=new System.Data.SqlClient.SqlCommand("SELECT customer_id,customer_username FROM customers ORDER BY customer_username",conn)) using(var r=cmd.ExecuteReader()){ ddlCustomer.Items.Clear(); ddlCustomer.Items.Add(new System.Web.UI.WebControls.ListItem("-- Customer --","")); while(r.Read()) ddlCustomer.Items.Add(new System.Web.UI.WebControls.ListItem(r["customer_username"].ToString(), r["customer_id"].ToString())); } } } catch {} }
void LoadMovies(){ try{ using(var conn=DatabaseHelper.GetConnection()){ conn.Open(); if(!DatabaseHelper.TableExists("movies",conn)) return; DatabaseHelper.EnsureMovieColumns(conn); using(var cmd=new System.Data.SqlClient.SqlCommand("SELECT MOV_code,MOV_title FROM movies ORDER BY MOV_title",conn)) using(var r=cmd.ExecuteReader()){ ddlMovie.Items.Clear(); ddlMovie.Items.Add(new System.Web.UI.WebControls.ListItem("-- Movie --","")); while(r.Read()) ddlMovie.Items.Add(new System.Web.UI.WebControls.ListItem(r["MOV_title"].ToString(), r["MOV_code"].ToString())); } } } catch {} }
protected void btnCheckout_Click(object sender,EventArgs e){ if(string.IsNullOrEmpty(ddlCustomer.SelectedValue)||string.IsNullOrEmpty(ddlMovie.SelectedValue)){ checkoutMsg.InnerHtml="<span class='error'>Select customer & movie.</span>"; return; } try{ using(var conn=DatabaseHelper.GetConnection()){ conn.Open(); CreateRentals(conn); using(var cmd=new System.Data.SqlClient.SqlCommand("INSERT INTO rentals (customer_id,movie_code,rental_date,due_date,rental_price,rental_status) SELECT @cid,@mc,GETDATE(),DATEADD(day,2,GETDATE()),ISNULL(MOV_price,0),'Active' FROM movies WHERE MOV_code=@mc",conn)){ cmd.Parameters.AddWithValue("@cid",ddlCustomer.SelectedValue); cmd.Parameters.AddWithValue("@mc",ddlMovie.SelectedValue); cmd.ExecuteNonQuery(); } checkoutMsg.InnerHtml="<span class='success'>Rental checked out successfully.</span>"; ddlCustomer.SelectedIndex=0; ddlMovie.SelectedIndex=0; } } catch(Exception ex){ checkoutMsg.InnerHtml="<span class='error'>"+System.Web.HttpUtility.HtmlEncode(ex.Message)+"</span>"; } }
void CreateRentals(System.Data.SqlClient.SqlConnection conn){ using(var cmd=new System.Data.SqlClient.SqlCommand(@"IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='rentals') BEGIN CREATE TABLE rentals (rental_id INT IDENTITY(1,1) PRIMARY KEY,customer_id INT NOT NULL,movie_code NVARCHAR(10) NOT NULL,rental_date DATETIME NOT NULL,due_date DATETIME NOT NULL,return_date DATETIME NULL,rental_price DECIMAL(10,2) NOT NULL,rental_status NVARCHAR(20) NOT NULL DEFAULT 'Active') END ELSE IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='rentals' AND COLUMN_NAME='due_date') BEGIN ALTER TABLE rentals ADD due_date DATETIME NOT NULL DEFAULT (DATEADD(day,2,GETDATE())) END",conn)){ cmd.ExecuteNonQuery(); } }
</script>
<style>
.page-title{color:#ff6b6b;font-size:2.2em;text-transform:uppercase;letter-spacing:3px;margin-bottom:25px;text-align:center;font-weight:800;}
.panel{max-width:500px;margin:0 auto;border:2px solid #00d4ff;border-radius:12px;padding:25px;background:#1a1a2e;}
.panel select{width:100%;padding:10px12px;margin-bottom:15px;background:#0f0f23;color:#00d4ff;border:2px solid #00d4ff;border-radius:8px;}
.panel button{width:100%;padding:12px15px;background:#4ecdc4;color:#fff;border:none;border-radius:8px;font-weight:700;cursor:pointer;}
.panel button:hover{background:#45b7d1;}
.success{color:#4ecdc4;font-weight:700;}
.error{color:#ff6b6b;font-weight:700;}
</style>
<h2 class="page-title">Staff Checkout</h2>
<div class="panel">
 <asp:DropDownList ID="ddlCustomer" runat="server" />
 <asp:DropDownList ID="ddlMovie" runat="server" />
 <asp:Button ID="btnCheckout" runat="server" Text="Check Out Rental" OnClick="btnCheckout_Click" />
 <div id="checkoutMsg" runat="server"></div>
</div>
</asp:Content>