<%@ Page Title="Movies" Language="C#" MasterPageFile="~/StaffArea/StaffSite.Master" AutoEventWireup="true" %>
<asp:Content ID="c1" ContentPlaceHolderID="MainContent" runat="server">
<asp:ScriptManager ID="smM" runat="server" />
<script runat="server">
protected void Page_Load(object sender,EventArgs e){ if(!IsPostBack){ LoadGenres(); LoadMovies(); } }
void LoadGenres(){ try{ using(var conn=DatabaseHelper.GetConnection()){ conn.Open(); if(!DatabaseHelper.TableExists("genre",conn)) return; using(var cmd=new System.Data.SqlClient.SqlCommand("SELECT GEN_code,GEN_name FROM genre ORDER BY GEN_name",conn)) using(var r=cmd.ExecuteReader()){ ddlGenre.Items.Clear(); ddlGenre.Items.Add(new System.Web.UI.WebControls.ListItem("-- Genre Filter --","")); while(r.Read()) ddlGenre.Items.Add(new System.Web.UI.WebControls.ListItem(r["GEN_name"].ToString(), r["GEN_code"].ToString())); } } } catch { } }
protected void ddlGenre_SelectedIndexChanged(object sender,EventArgs e){ LoadMovies(); }
void LoadMovies(){ try{ using(var conn=DatabaseHelper.GetConnection()){ conn.Open(); DatabaseHelper.EnsureMovieColumns(conn); if(!DatabaseHelper.TableExists("movies",conn)){ moviesBody.InnerHtml="<tr><td colspan='7'>Movies table missing.</td></tr>"; return; } string sql="SELECT MOV_code,MOV_title,MOV_genre,MOV_year,MOV_duration,MOV_price FROM movies"; if(!string.IsNullOrEmpty(ddlGenre.SelectedValue)) sql+=" WHERE MOV_genre=@g"; sql+=" ORDER BY MOV_title"; using(var cmd=new System.Data.SqlClient.SqlCommand(sql,conn)){ if(!string.IsNullOrEmpty(ddlGenre.SelectedValue)) cmd.Parameters.AddWithValue("@g",ddlGenre.SelectedValue); using(var r=cmd.ExecuteReader()){ var sb=new System.Text.StringBuilder(); while(r.Read()){ sb.AppendFormat("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td><td>${5:F2}</td><td>-</td></tr>", r["MOV_code"], System.Web.HttpUtility.HtmlEncode(r["MOV_title"].ToString()), System.Web.HttpUtility.HtmlEncode(r["MOV_genre"].ToString()), r["MOV_year"], r["MOV_duration"], r["MOV_price"]==DBNull.Value?0:Convert.ToDecimal(r["MOV_price"])); } moviesBody.InnerHtml= sb.Length>0? sb.ToString():"<tr><td colspan='7'>No movies found.</td></tr>"; } } } } catch(Exception ex){ moviesBody.InnerHtml="<tr><td colspan='7' class='error'>"+System.Web.HttpUtility.HtmlEncode(ex.Message)+"</td></tr>"; } }
protected void btnAddMovie_Click(object sender,EventArgs e){ if(string.IsNullOrWhiteSpace(txtCode.Text)||string.IsNullOrWhiteSpace(txtTitle.Text)){ msg.InnerHtml="<span class='error'>Code & Title required.</span>"; return; } try{ using(var conn=DatabaseHelper.GetConnection()){ conn.Open(); DatabaseHelper.EnsureMovieColumns(conn); using(var cmd=new System.Data.SqlClient.SqlCommand("INSERT INTO movies (MOV_code,MOV_title,MOV_genre,MOV_year,MOV_duration,MOV_price,MOV_description) VALUES (@c,@t,@g,@y,@d,@p,@desc)",conn)){ cmd.Parameters.AddWithValue("@c",txtCode.Text.Trim()); cmd.Parameters.AddWithValue("@t",txtTitle.Text.Trim()); cmd.Parameters.AddWithValue("@g", string.IsNullOrEmpty(txtGenreAdd.Text)?(object)DBNull.Value:txtGenreAdd.Text.Trim()); cmd.Parameters.AddWithValue("@y", string.IsNullOrEmpty(txtYear.Text)?(object)DBNull.Value:int.Parse(txtYear.Text)); cmd.Parameters.AddWithValue("@d", string.IsNullOrEmpty(txtDuration.Text)?(object)DBNull.Value:int.Parse(txtDuration.Text)); cmd.Parameters.AddWithValue("@p", string.IsNullOrEmpty(txtPrice.Text)?(object)DBNull.Value:decimal.Parse(txtPrice.Text)); cmd.Parameters.AddWithValue("@desc", string.IsNullOrEmpty(txtDescription.Text)?(object)DBNull.Value:txtDescription.Text.Trim()); cmd.ExecuteNonQuery(); } msg.InnerHtml="<span class='success'>Movie added.</span>"; ClearForm(); LoadMovies(); } } catch(Exception ex){ msg.InnerHtml="<span class='error'>"+System.Web.HttpUtility.HtmlEncode(ex.Message)+"</span>"; } }
void ClearForm(){ txtCode.Text=""; txtTitle.Text=""; txtGenreAdd.Text=""; txtYear.Text=""; txtDuration.Text=""; txtPrice.Text=""; txtDescription.Text=""; }
</script>
<style>
.page-title{color:#ff6b6b;font-size:2.2em;text-transform:uppercase;letter-spacing:3px;margin-bottom:25px;text-align:center;font-weight:800;}
.flex{display:flex;gap:30px;flex-wrap:wrap;}
.movie-list{flex:2;min-width:400px;}
.form-panel{flex:1;min-width:300px;border:2px solid #00d4ff;border-radius:10px;padding:15px;background:#1a1a2e;}
.table-wrap{overflow:auto;border:2px solid #00d4ff;border-radius:10px;background:#1a1a2e;max-height:500px;}
table{width:100%;border-collapse:collapse;font-size:0.8em;}
th{background:#16213e;color:#4ecdc4;padding:8px;text-align:left;position:sticky;top:0;}
td{padding:6px;border-top:1px solid #20304a;color:#b8c6db;}
tr:hover{background:#24344e;}
.form-panel input, .form-panel textarea{width:100%;padding:8px10px;margin-bottom:10px;background:#0f0f23;color:#00d4ff;border:2px solid #00d4ff;border-radius:6px;font-size:0.85em;}
.form-panel button{background:#4ecdc4;color:#fff;border:none;padding:10px14px;border-radius:6px;font-weight:700;cursor:pointer;width:100%;}
.form-panel button:hover{background:#45b7d1;}
.success{color:#4ecdc4;font-weight:700;}
.error{color:#ff6b6b;font-weight:700;}
.filter{margin-bottom:10px;}
.filter select{width:100%;padding:8px10px;background:#0f0f23;color:#00d4ff;border:2px solid #4ecdc4;border-radius:6px;}
</style>
<h2 class="page-title">Movies Administration</h2>
<div class="flex">
 <div class="movie-list">
 <div class="filter">
 <asp:DropDownList ID="ddlGenre" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlGenre_SelectedIndexChanged" />
 </div>
 <div class="table-wrap">
 <table><thead><tr><th>Code</th><th>Title</th><th>Genre</th><th>Year</th><th>Dur</th><th>Price</th><th>Edit</th></tr></thead><tbody id="moviesBody" runat="server"><tr><td colspan="7">Loading...</td></tr></tbody></table>
 </div>
 </div>
 <div class="form-panel">
 <h3 style="color:#4ecdc4;text-align:center;">Add Movie</h3>
 <asp:TextBox ID="txtCode" runat="server" placeholder="Code" />
 <asp:TextBox ID="txtTitle" runat="server" placeholder="Title" />
 <asp:TextBox ID="txtGenreAdd" runat="server" placeholder="Genre Code (optional)" />
 <asp:TextBox ID="txtYear" runat="server" placeholder="Year" />
 <asp:TextBox ID="txtDuration" runat="server" placeholder="Duration (min)" />
 <asp:TextBox ID="txtPrice" runat="server" placeholder="Price" />
 <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" placeholder="Description" />
 <asp:Button ID="btnAddMovie" runat="server" Text="Add Movie" OnClick="btnAddMovie_Click" />
 <div id="msg" runat="server"></div>
 </div>
</div>
</asp:Content>