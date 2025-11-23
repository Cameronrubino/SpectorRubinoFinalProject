<%@ Page Title="Rent Movie" Language="C#" MasterPageFile="~/Areas/Customer/CustomerMaster.Master" AutoEventWireup="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<script runat="server">
protected void Page_Load(object sender,EventArgs e){ if(!IsPostBack){ LoadMovies(); var q=Request.QueryString["movie"]; if(!string.IsNullOrEmpty(q)){ ddlMovies.SelectedValue=q; LoadMovieInfo(); } } }
void LoadMovies(){ try{ using(var conn=new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["MoviesDB"].ConnectionString)){ conn.Open(); DatabaseHelper.EnsureMovieColumns(conn); if(!TableExists("movies",conn)){ ShowMsg("Movies table missing",false); return; } using(var cmd=new System.Data.SqlClient.SqlCommand("SELECT MOV_code,MOV_title,ISNULL(MOV_price,0) Price FROM movies ORDER BY MOV_title",conn)) using(var r=cmd.ExecuteReader()){ ddlMovies.Items.Clear(); ddlMovies.Items.Add(new System.Web.UI.WebControls.ListItem("-- Select a Movie --","")); while(r.Read()){ string code=r["MOV_code"].ToString(); string title=r["MOV_title"].ToString(); decimal price=Convert.ToDecimal(r["Price"]); ddlMovies.Items.Add(new System.Web.UI.WebControls.ListItem(title+" - $"+price.ToString("F2"),code)); } } } } catch(Exception ex){ ShowMsg("Error loading movies: "+ex.Message,false); } }
protected void ddlMovies_SelectedIndexChanged(object sender,EventArgs e){ LoadMovieInfo(); }
void LoadMovieInfo(){ if(string.IsNullOrEmpty(ddlMovies.SelectedValue)){ movieInfoPanel.Visible=false; return; } try{ using(var conn=new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["MoviesDB"].ConnectionString)){ conn.Open(); DatabaseHelper.EnsureMovieColumns(conn); using(var cmd=new System.Data.SqlClient.SqlCommand(@"SELECT MOV_title,ISNULL(g.GEN_name,'No Genre') Genre,ISNULL(MOV_year,0) Year,ISNULL(MOV_duration,0) Duration,ISNULL(MOV_price,0) Price FROM movies m LEFT JOIN genre g ON m.MOV_genre=g.GEN_code WHERE MOV_code=@c",conn)){ cmd.Parameters.AddWithValue("@c",ddlMovies.SelectedValue); using(var r=cmd.ExecuteReader()){ if(r.Read()){ string title=r["MOV_title"].ToString(); string genre=r["Genre"].ToString(); int year=Convert.ToInt32(r["Year"]); int dur=Convert.ToInt32(r["Duration"]); decimal price=Convert.ToDecimal(r["Price"]); selectedMovieTitle.InnerText=title; selectedMovieDetails.InnerHtml=System.String.Format("<strong>Genre:</strong> {0}<br/><strong>Year:</strong> {1}<br/><strong>Duration:</strong> {2}<br/><strong>Rental Price:</strong> ${3:F2}<br/><strong>Rental Period:</strong>2 days", genre, year>0?year.ToString():"Unknown", dur>0?(dur+" minutes"):"Unknown", price); movieInfoPanel.Visible=true; } } } } } catch(Exception ex){ ShowMsg("Error loading movie info: "+ex.Message,false); } }
protected void btnRentMovie_Click(object sender,EventArgs e){ if(string.IsNullOrEmpty(ddlMovies.SelectedValue)){ ShowMsg("Select a movie first",false); return; } if(string.IsNullOrEmpty(txtCustomer.Text.Trim())){ ShowMsg("Enter username or ID",false); return; } try{ using(var conn=new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["MoviesDB"].ConnectionString)){ conn.Open(); CreateRentalsTable(conn); int custId=FindCustomer(txtCustomer.Text.Trim(),conn); if(custId==0){ ShowMsg("Customer not found",false); return; } decimal price=GetMoviePrice(ddlMovies.SelectedValue,conn); using(var cmd=new System.Data.SqlClient.SqlCommand("INSERT INTO rentals (customer_id,movie_code,rental_date,due_date,rental_price,rental_status) VALUES (@cid,@mc,@dt,@due,@pr,'Active')",conn)){ cmd.Parameters.AddWithValue("@cid",custId); cmd.Parameters.AddWithValue("@mc",ddlMovies.SelectedValue); DateTime now=DateTime.Now; cmd.Parameters.AddWithValue("@dt",now); cmd.Parameters.AddWithValue("@due",now.AddDays(2)); cmd.Parameters.AddWithValue("@pr",price); cmd.ExecuteNonQuery(); } ShowMsg("Your order has been processed. Please proceed to Rokey's rental front counter to pick up your movie.",true); ddlMovies.SelectedIndex=0; txtCustomer.Text=""; movieInfoPanel.Visible=false; } } catch(Exception ex){ ShowMsg("Error processing rental: "+ex.Message,false); } }
void CreateRentalsTable(System.Data.SqlClient.SqlConnection conn){ using(var cmd=new System.Data.SqlClient.SqlCommand(@"IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='rentals') BEGIN CREATE TABLE rentals (rental_id INT IDENTITY(1,1) PRIMARY KEY,customer_id INT NOT NULL,movie_code NVARCHAR(10) NOT NULL,rental_date DATETIME NOT NULL,due_date DATETIME NOT NULL,return_date DATETIME NULL,rental_price DECIMAL(10,2) NOT NULL,rental_status NVARCHAR(20) NOT NULL DEFAULT 'Active') END ELSE IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='rentals' AND COLUMN_NAME='due_date') BEGIN ALTER TABLE rentals ADD due_date DATETIME NOT NULL DEFAULT (DATEADD(day,2,GETDATE())) END",conn)){ cmd.ExecuteNonQuery(); } }
int FindCustomer(string info,System.Data.SqlClient.SqlConnection conn){ try{ using(var cmd=new System.Data.SqlClient.SqlCommand("SELECT customer_id FROM customers WHERE customer_username=@i OR CAST(customer_id AS varchar)=@i",conn)){ cmd.Parameters.AddWithValue("@i",info); object r=cmd.ExecuteScalar(); return r!=null?Convert.ToInt32(r):0; } } catch { return 0; } }
decimal GetMoviePrice(string code,System.Data.SqlClient.SqlConnection conn){ try{ using(var cmd=new System.Data.SqlClient.SqlCommand("SELECT ISNULL(MOV_price,0) FROM movies WHERE MOV_code=@c",conn)){ cmd.Parameters.AddWithValue("@c",code); object r=cmd.ExecuteScalar(); return r!=null?Convert.ToDecimal(r):0; } } catch { return 0M; } }
bool TableExists(string t,System.Data.SqlClient.SqlConnection conn){ using(var cmd=new System.Data.SqlClient.SqlCommand("SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME=@t",conn)){ cmd.Parameters.AddWithValue("@t",t); return cmd.ExecuteScalar()!=null; } }
void ShowMsg(string m,bool ok){ lblMessage.Text=m; lblMessage.CssClass= ok?"success-message":"error-message"; lblMessage.Visible=true; }
</script>

 <style>
        .rent-movie-container {
     background: transparent;
    color: #00d4ff;
         font-family: 'Orbitron', monospace;
  }

  .rent-title {
   color: #4ecdc4 !important;
            font-size: 3.2em !important;
     text-align: center !important;
        text-shadow: 0 0 25px #4ecdc4, 0 0 50px #4ecdc4 !important;
 letter-spacing: 4px !important;
   margin-bottom: 40px !important;
      border-bottom: 3px solid #4ecdc4 !important;
      padding-bottom: 20px !important;
     text-transform: uppercase !important;
        font-weight: 900 !important;
}

        .rental-form {
     background: linear-gradient(145deg, rgba(30, 30, 63, 0.9), rgba(45, 45, 95, 0.9));
      border: 2px solid #00d4ff;
       border-radius: 20px;
   padding: 40px;
 margin: 0 auto;
      max-width: 700px;
    box-shadow: 0 0 30px rgba(0, 212, 255, 0.4);
        }

     .form-section {
   margin-bottom: 30px;
   padding: 25px;
      background: rgba(0, 212, 255, 0.05);
      border-radius: 15px;
  border: 1px solid rgba(0, 212, 255, 0.2);
   }

     .section-title {
   color: #ff6b6b;
        font-size: 1.4em;
   font-weight: 700;
   margin-bottom: 20px;
     text-transform: uppercase;
        letter-spacing: 2px;
   text-shadow: 0 0 10px #ff6b6b;
     }

   .form-group {
 margin-bottom: 20px;
        }

        .form-label {
 color: #4ecdc4;
       font-weight: 700;
      font-size: 1.1em;
     margin-bottom: 8px;
  display: block;
  text-transform: uppercase;
   letter-spacing: 1px;
 }

        .form-input, .form-select {
      background: linear-gradient(145deg, #0f0f23, #1a1a2e);
border: 3px solid #00d4ff;
     border-radius: 8px;
      color: #00d4ff;
 font-family: 'Orbitron', monospace;
      font-size: 16px;
       font-weight: 600;
         padding: 12px 15px;
     width: 100%;
transition: all 0.3s ease;
  }

 .form-input:focus, .form-select:focus {
outline: none;
border-color: #4ecdc4;
  box-shadow: 0 0 20px rgba(76, 205, 196, 0.6);
        }

 .rent-button {
    background: linear-gradient(145deg, #ff6b6b, #ff5252);
    color: #ffffff;
     border: none;
        padding: 15px 40px;
      border-radius: 10px;
       font-family: 'Orbitron', monospace;
        font-weight: 700;
      font-size: 16px;
 cursor: pointer;
text-transform: uppercase;
        letter-spacing: 2px;
 transition: all 0.3s ease;
       width: 100%;
    margin-top: 20px;
        }

        .rent-button:hover {
       background: linear-gradient(145deg, #ff5252, #ff3030);
 transform: translateY(-2px);
     box-shadow: 0 8px 20px rgba(255, 107, 107, 0.6);
  }

        .movie-info {
    background: rgba(76, 205, 196, 0.1);
     border: 2px solid rgba(76, 205, 196, 0.3);
   border-radius: 10px;
        padding: 20px;
  margin: 20px 0;
        }

       .movie-title-display {
 color: #4ecdc4;
    font-size: 1.5em;
   font-weight: 700;
      text-transform: uppercase;
     margin-bottom: 10px;
     }

        .movie-details-display {
    color: #b8c6db;
    line-height: 1.6;
     }

 .success-message {
   background: linear-gradient(135deg, rgba(76, 205, 196, 0.3), rgba(76, 205, 196, 0.1));
            border: 2px solid #4ecdc4;
  color: #4ecdc4;
    text-shadow: 0 0 10px #4ecdc4;
       padding: 20px;
 margin: 20px 0;
   border-radius: 10px;
      font-weight: 600;
  text-align: center;
    }

       .error-message {
       background: linear-gradient(135deg, rgba(255, 107, 107, 0.3), rgba(255, 107, 107, 0.1));
   border: 2px solid #ff6b6b;
     color: #ff6b6b;
      text-shadow: 0 0 10px #ff6b6b;
      padding: 20px;
    margin: 20px 0;
  border-radius: 10px;
      font-weight: 600;
   text-align: center;
}
 </style>

 <div class="rent-movie-container">
        <h2 class="rent-title">Rent a Movie</h2>
     
   <div class="rental-form">
  <div class="form-section">
        <h3 class="section-title">Select Movie</h3>
       <div class="form-group">
       <label class="form-label">Choose Movie:</label>
      <asp:DropDownList ID="ddlMovies" runat="server" CssClass="form-select" 
 AutoPostBack="true" OnSelectedIndexChanged="ddlMovies_SelectedIndexChanged" />
          </div>
            
 <div id="movieInfoPanel" runat="server" class="movie-info" visible="false">
     <div class="movie-title-display" id="selectedMovieTitle" runat="server"></div>
       <div class="movie-details-display" id="selectedMovieDetails" runat="server"></div>
   </div>
        </div>

  <div class="form-section">
   <h3 class="section-title">Customer Information</h3>
      <div class="form-group">
      <label class="form-label">Customer Username or ID:</label>
     <asp:TextBox ID="txtCustomer" runat="server" CssClass="form-input" 
    placeholder="Enter your username or customer ID" />
        </div>
      </div>

     <asp:Label ID="lblMessage" runat="server" Visible="false" />
        
 <asp:Button ID="btnRentMovie" runat="server" Text="Process Rental" 
          CssClass="rent-button" OnClick="btnRentMovie_Click" />
 </div>
    </div>

</asp:Content>