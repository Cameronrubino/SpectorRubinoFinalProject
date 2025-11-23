<%@ Page Title="Staff Dashboard" Language="C#" MasterPageFile="~/StaffArea/StaffSite.Master" AutoEventWireup="true" %>
<asp:Content ID="c1" ContentPlaceHolderID="MainContent" runat="server">
<script runat="server">
protected void Page_Load(object sender,EventArgs e){ if(!IsPostBack){ SetLoginTime(); LoadStats(); } }
void SetLoginTime(){ if(Session["StaffLoginTime"]!=null){ try{ lblLoginTime.Text = ((DateTime)Session["StaffLoginTime"]).ToString("MMM dd, yyyy - hh:mm tt"); } catch { lblLoginTime.Text="Unknown"; } } else { lblLoginTime.Text="Not recorded"; } }
void LoadStats(){ try{ using(var conn=new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["MoviesDB"].ConnectionString)){ conn.Open(); totalMovies.InnerText = SafeCount(conn,"movies"); totalCustomers.InnerText = SafeCount(conn,"customers"); totalGenres.InnerText = SafeCount(conn,"genre"); activeRentals.InnerText = ActiveRentalCount(conn); } } catch { totalMovies.InnerText="150+"; totalCustomers.InnerText="500+"; totalGenres.InnerText="25+"; activeRentals.InnerText="25+"; } }
string SafeCount(System.Data.SqlClient.SqlConnection conn,string table){ if(!TableExists(table,conn)) return "0"; using(var cmd=new System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM "+table,conn)){ object r=cmd.ExecuteScalar(); return r!=null?r.ToString():"0"; } }
string ActiveRentalCount(System.Data.SqlClient.SqlConnection conn){ if(!TableExists("rentals",conn)) return "0"; using(var cmd=new System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM rentals WHERE rental_status='Active'",conn)){ object r=cmd.ExecuteScalar(); return r!=null?r.ToString():"0"; } }
bool TableExists(string t,System.Data.SqlClient.SqlConnection conn){ using(var cmd=new System.Data.SqlClient.SqlCommand("SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME=@t",conn)){ cmd.Parameters.AddWithValue("@t",t); return cmd.ExecuteScalar()!=null; } }
</script>
<style>
   .dashboard-container {
     background: linear-gradient(135deg, rgba(15, 15, 35, 0.95), rgba(26, 26, 46, 0.95));
color: #00d4ff;
     font-family: 'Orbitron', monospace;
        }
   
        .dashboard-title {
      color: #ff6b6b !important;
 font-size: 2.8em !important;
    text-align: center !important;
     text-shadow: 0 0 20px #ff6b6b, 0 0 40px #ff6b6b !important;
  letter-spacing: 3px !important;
       margin-bottom: 30px !important;
        border-bottom: 3px solid #ff6b6b !important;
    padding-bottom: 15px !important;
   text-transform: uppercase !important;
     font-weight: 900 !important;
   }

     .stats-grid {
    display: grid;
   grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
     gap: 25px;
        margin-bottom: 40px;
 }

        .stat-card {
      background: linear-gradient(145deg, rgba(30, 30, 63, 0.9), rgba(45, 45, 95, 0.9));
    border: 2px solid #4ecdc4;
  border-radius: 15px;
      padding: 25px;
      box-shadow: 0 0 25px rgba(76, 205, 196, 0.3);
text-align: center;
 transition: all 0.3s ease;
     }

   .stat-card:hover {
     transform: translateY(-5px);
 box-shadow: 0 8px 30px rgba(76, 205, 196, 0.5);
 }

       .stat-number {
    font-size: 3em;
   color: #ff6b6b;
       font-weight: 900;
    text-shadow: 0 0 15px #ff6b6b;
      margin-bottom: 10px;
   }

 .stat-label {
      color: #4ecdc4;
    font-size: 1.2em;
        font-weight: 700;
     text-shadow: 0 0 10px #4ecdc4;
  text-transform: uppercase;
     letter-spacing: 1px;
 }

   .welcome-section {
    background: linear-gradient(145deg, rgba(255, 107, 107, 0.1), rgba(255, 107, 107, 0.05));
  border: 2px solid rgba(255, 107, 107, 0.3);
      border-radius: 15px;
      padding: 30px;
   text-align: center;
       margin-bottom: 40px;
  }

        .welcome-title {
     color: #ff6b6b;
      font-size: 1.8em;
     font-weight: 700;
    text-shadow: 0 0 15px #ff6b6b;
  margin-bottom: 15px;
       text-transform: uppercase;
 }

 .welcome-text {
     color: #b8c6db;
        line-height: 1.6;
    font-size: 1.1em;
     }
    </style>

    <div class="dashboard-container">
     <h2 class="dashboard-title">Staff Dashboard</h2>
        
   <div class="welcome-section">
 <h3 class="welcome-title">Welcome to Staff Portal</h3>
    <p class="welcome-text">
     Manage movies, customers, and rentals efficiently. Access all administrative tools from the navigation menu.
  </p>
   <p class="welcome-text">
       <strong>Login Time:</strong> <asp:Label ID="lblLoginTime" runat="server" />
    </p>
        </div>

   <div class="stats-grid">
        <div class="stat-card">
  <div class="stat-number" id="totalMovies" runat="server">0</div>
      <div class="stat-label">Total Movies</div>
       </div>
   
        <div class="stat-card">
 <div class="stat-number" id="totalCustomers" runat="server">0</div>
     <div class="stat-label">Total Customers</div>
        </div>
    
 <div class="stat-card">
     <div class="stat-number" id="activeRentals" runat="server">0</div>
    <div class="stat-label">Active Rentals</div>
        </div>
      
    <div class="stat-card">
    <div class="stat-number" id="totalGenres" runat="server">0</div>
     <div class="stat-label">Movie Genres</div>
      </div>
        </div>
  </div>

</asp:Content>