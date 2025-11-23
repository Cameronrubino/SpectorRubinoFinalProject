<%@ Page Title="Customer Home" Language="C#" MasterPageFile="~/Areas/Customer/CustomerMaster.Master" AutoEventWireup="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<script runat="server">
protected void Page_Load(object sender, EventArgs e){ if(!IsPostBack){ LoadStatistics(); } }
void LoadStatistics(){ try{ using(var conn=new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["MoviesDB"].ConnectionString)){ conn.Open(); if(TableExists("movies",conn)){ using(var c=new System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM movies",conn)){ movieCount.InnerText=c.ExecuteScalar().ToString(); } } if(TableExists("genre",conn)){ using(var c=new System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM genre",conn)){ genreCount.InnerText=c.ExecuteScalar().ToString(); } } if(TableExists("customers",conn)){ using(var c=new System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM customers",conn)){ customerCount.InnerText=c.ExecuteScalar().ToString(); } } } } catch { movieCount.InnerText="500+"; genreCount.InnerText="25+"; customerCount.InnerText="1000+"; } }
bool TableExists(string name,System.Data.SqlClient.SqlConnection conn){ using(var cmd=new System.Data.SqlClient.SqlCommand("SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME=@t",conn)){ cmd.Parameters.AddWithValue("@t",name); return cmd.ExecuteScalar()!=null; } }
</script>

    <style>
        .home-hero {
            background: linear-gradient(135deg, rgba(15, 15, 35, 0.95), rgba(26, 26, 46, 0.95));
     border: 2px solid #4ecdc4;
         border-radius: 20px;
            padding: 50px;
        text-align: center;
          margin-bottom: 40px;
     box-shadow: 0 0 40px rgba(76, 205, 196, 0.3);
        }

        .hero-title {
color: #4ecdc4 !important;
 font-size: 3.5em !important;
    text-shadow: 0 0 30px #4ecdc4 !important;
            margin-bottom: 20px !important;
     text-transform: uppercase !important;
    letter-spacing: 4px !important;
        }

  .hero-subtitle {
       color: #00d4ff !important;
            font-size: 1.4em !important;
            margin-bottom: 30px !important;
   letter-spacing: 2px !important;
        }

   .features-grid {
            display: grid;
   grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 40px;
        }

        .feature-card {
       background: linear-gradient(145deg, rgba(30, 30, 63, 0.9), rgba(45, 45, 95, 0.9));
      border: 2px solid #00d4ff;
   border-radius: 15px;
      padding: 30px;
 text-align: center;
            transition: all 0.3s ease;
      box-shadow: 0 0 25px rgba(0, 212, 255, 0.3);
        }

        .feature-card:hover {
            transform: translateY(-10px);
    box-shadow: 0 15px 40px rgba(0, 212, 255, 0.6);
            border-color: #4ecdc4;
  }

        .feature-icon {
    font-size: 3em;
 color: #ff6b6b;
            margin-bottom: 20px;
            text-shadow: 0 0 20px #ff6b6b;
        }

        .feature-title {
 color: #4ecdc4 !important;
        font-size: 1.6em !important;
            margin-bottom: 15px !important;
            text-transform: uppercase !important;
font-weight: 700 !important;
        }

        .feature-description {
       color: #b8c6db !important;
line-height: 1.6 !important;
margin-bottom: 20px !important;
     }

    .cta-button {
   background: linear-gradient(145deg, #ff6b6b, #ff5252);
    color: #ffffff;
            text-decoration: none;
      padding: 15px 30px;
            border-radius: 10px;
    font-weight: 700;
text-transform: uppercase;
         letter-spacing: 1px;
            transition: all 0.3s ease;
  display: inline-block;
        }

        .cta-button:hover {
        background: linear-gradient(145deg, #ff5252, #ff3030);
            transform: translateY(-3px);
  box-shadow: 0 8px 20px rgba(255, 107, 107, 0.6);
      }

        .stats-section {
            background: linear-gradient(145deg, rgba(255, 107, 107, 0.1), rgba(255, 107, 107, 0.05));
 border: 2px solid rgba(255, 107, 107, 0.3);
            border-radius: 15px;
   padding: 30px;
     margin: 40px 0;
      text-align: center;
        }

  .stats-grid {
          display: grid;
       grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
 gap: 20px;
margin-top: 20px;
        }

        .stat-item {
  padding: 20px;
        }

  .stat-number {
     font-size: 2.5em;
         color: #ff6b6b;
            font-weight: 900;
          text-shadow: 0 0 15px #ff6b6b;
        }

        .stat-label {
      color: #4ecdc4;
            font-weight: 700;
      text-transform: uppercase;
            letter-spacing: 1px;
      }
    </style>

  <div class="home-hero">
        <h1 class="hero-title">Welcome to Rokey's Video Rentals</h1>
 <p class="hero-subtitle">Your Ultimate Entertainment Destination Since 1985</p>
 <p style="color: #b8c6db; font-size: 1.1em; line-height: 1.6;">
 Discover thousands of movies across all genres. From the latest blockbusters to classic films,
       we have everything you need for your perfect movie night.
        </p>
  </div>

    <div class="features-grid">
      <div class="feature-card">
            <div class="feature-icon"><i class="fas fa-film"></i></div>
 <h3 class="feature-title">Browse Movies</h3>
            <p class="feature-description">
      Explore our extensive collection of movies with advanced filtering and search capabilities.
            </p>
    <a href="~/Areas/Customer/Pages/BrowseMovies.aspx" class="cta-button">Browse Now</a>
   </div>

  <div class="feature-card">
 <div class="feature-icon"><i class="fas fa-layer-group"></i></div>
            <h3 class="feature-title">By Genre</h3>
  <p class="feature-description">
    Find movies by your favorite genres - Action, Comedy, Drama, Sci-Fi, and many more.
     </p>
    <a href="~/Areas/Customer/Pages/BrowseByGenre.aspx" class="cta-button">Browse Genres</a>
        </div>

        <div class="feature-card">
 <div class="feature-icon"><i class="fas fa-bolt"></i></div>
     <h3 class="feature-title">Quick Rental</h3>
          <p class="feature-description">
        Fast and easy rental process. Create your account and start renting movies instantly.
            </p>
        <a href="~/Areas/Customer/Pages/RentMovie.aspx" class="cta-button">Rent Movie</a>
        </div>
    </div>

    <div class="stats-section">
    <h2 style="color: #ff6b6b; font-size: 2em; margin-bottom: 20px; text-transform: uppercase;">Our Collection</h2>
        <div class="stats-grid">
          <div class="stat-item">
                <div class="stat-number" id="movieCount" runat="server">0</div>
       <div class="stat-label">Movies Available</div>
          </div>
     <div class="stat-item">
          <div class="stat-number" id="genreCount" runat="server">0</div>
        <div class="stat-label">Different Genres</div>
  </div>
        <div class="stat-item">
       <div class="stat-number" id="customerCount" runat="server">0</div>
       <div class="stat-label">Happy Customers</div>
     </div>
          <div class="stat-item">
 <div class="stat-number">35+</div>
   <div class="stat-label">Years of Service</div>
 </div>
    </div>
  </div>

</asp:Content>