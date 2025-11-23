<%@ Page Title="Browse Movies" Language="C#" MasterPageFile="~/Areas/Customer/CustomerMaster.Master" AutoEventWireup="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<script runat="server">
protected void Page_Load(object sender, EventArgs e)
{
    if(!IsPostBack)
    {
        LoadMovies();
    }
}

protected void btnSearch_Click(object sender, EventArgs e)
{
    LoadMovies(txtSearch.Text.Trim());
}

void LoadMovies(string searchTerm="")
{
    try
    {
        using(var conn=new System.Data.SqlClient.SqlConnection(DatabaseHelper.ConnectionString))
        {
            conn.Open();
            DatabaseHelper.EnsureMovieColumns(conn); // ensure columns exist
            if(!DatabaseHelper.TableExists("movies",conn))
            {
                ShowMessage("Movie database not found.");
                moviesContainer.InnerHtml="";
                return;
            }

            string sql=@"
                SELECT m.MOV_code,m.MOV_title,ISNULL(g.GEN_name,'No Genre') Genre,ISNULL(m.MOV_year,0) Year,
                       ISNULL(m.MOV_duration,0) Duration,ISNULL(m.MOV_price,0.00) Price,
                       ISNULL(m.MOV_description,'No description available') Description
                FROM movies m
                LEFT JOIN genre g ON m.MOV_genre=g.GEN_code
            ";

            if(!string.IsNullOrEmpty(searchTerm))
                sql+=" WHERE m.MOV_title LIKE @s OR g.GEN_name LIKE @s";

            sql+=" ORDER BY m.MOV_title";

            using(var cmd=new System.Data.SqlClient.SqlCommand(sql,conn))
            {
                if(!string.IsNullOrEmpty(searchTerm))
                    cmd.Parameters.AddWithValue("@s","%"+searchTerm+"%");

                using(var r=cmd.ExecuteReader())
                {
                    var sb=new System.Text.StringBuilder();
                    int count=0;

                    while(r.Read())
                    {
                        count++;
                        string title=r["MOV_title"].ToString();
                        string genre=r["Genre"].ToString();
                        int year=System.Convert.ToInt32(r["Year"]);
                        int dur=System.Convert.ToInt32(r["Duration"]);
                        decimal price=System.Convert.ToDecimal(r["Price"]);
                        string code=r["MOV_code"].ToString();
                        string desc=r["Description"].ToString();

                        if(desc.Length>150)
                            desc=desc.Substring(0,147)+"...";

                        sb.AppendFormat(
                            "<div class='movie-card'>"+
                            "<h3 class='movie-title'>{0}</h3>"+
                            "<div class='movie-details'>"+
                            "<strong>Genre:</strong> {1}<br/>"+
                            "<strong>Year:</strong> {2}<br/>"+
                            "<strong>Duration:</strong> {3} minutes<br/>"+
                            "<strong>Description:</strong> {6}"+
                            "</div>"+
                            "<div class='movie-price'>${4:F2}</div>"+
                            "<a href='RentMovie.aspx?movie={5}' class='rent-button'>Rent This Movie</a>"+
                            "</div>",
                            title, genre, year>0?year.ToString():"Unknown", dur>0?dur.ToString():"Unknown", price, code, desc
                        );
                    }

                    if(count==0)
                    {
                        string st=string.IsNullOrEmpty(searchTerm)?"any criteria":"'"+searchTerm+"'";
                        sb.AppendFormat("<div class='no-movies'>No movies found matching {0}.</div>", st);
                    }
                    else
                    {
                        sb.Insert(0, System.String.Format("<div style='text-align:center;margin-bottom:20px;color:#4ecdc4;font-size:1.2em;'>Found {0} movie(s)</div>", count));
                    }

                    moviesContainer.InnerHtml=sb.ToString();
                }
            }
        }
    }
    catch(Exception ex)
    {
        ShowMessage("Error loading movies: "+ex.Message);
        moviesContainer.InnerHtml="";
    }
}

void ShowMessage(string m)
{
    lblMessage.Text=m;
    lblMessage.Visible=true;
}
</script>

    <style>
        .browse-movies-container {
          background: transparent;
 color: #00d4ff;
      font-family: 'Orbitron', monospace;
 }

     .browse-title {
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

        .search-section {
   background: linear-gradient(145deg, rgba(30, 30, 63, 0.9), rgba(45, 45, 95, 0.9));
  border: 2px solid #00d4ff;
 border-radius: 20px;
  padding: 30px;
      margin-bottom: 40px;
     box-shadow: 0 0 30px rgba(0, 212, 255, 0.4);
 }

  .search-controls {
   display: grid;
      grid-template-columns: 1fr auto;
     gap: 20px;
      align-items: end;
 }

        .search-input {
   background: linear-gradient(145deg, #0f0f23, #1a1a2e);
      border: 3px solid #00d4ff;
      border-radius: 12px;
      color: #00d4ff;
      font-family: 'Orbitron', monospace;
      font-size: 18px;
     font-weight: 600;
     padding: 15px 20px;
  transition: all 0.4s ease;
width: 100%;
      box-shadow: 0 0 20px rgba(0, 212, 255, 0.3);
      }

 .search-input:focus {
       outline: none;
 border-color: #4ecdc4;
     box-shadow: 0 0 30px rgba(76, 205, 196, 0.8);
        }

     .search-button {
     background: linear-gradient(145deg, #4ecdc4, #45b7d1);
     color: #ffffff;
  border: none;
 padding: 15px 30px;
        border-radius: 12px;
       font-family: 'Orbitron', monospace;
 font-weight: 700;
  font-size: 16px;
     cursor: pointer;
   text-transform: uppercase;
 letter-spacing: 1px;
     transition: all 0.3s ease;
box-shadow: 0 5px 15px rgba(76, 205, 196, 0.4);
    }

        .search-button:hover {
    background: linear-gradient(145deg, #45b7d1, #4ecdc4);
      transform: translateY(-3px);
      box-shadow: 0 8px 25px rgba(76, 205, 196, 0.6);
     }

        .movies-grid {
     display: grid;
         grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
   gap: 25px;
      margin-top: 30px;
     }

        .movie-card {
       background: linear-gradient(145deg, rgba(30, 30, 63, 0.95), rgba(45, 45, 95, 0.95));
  border: 2px solid #00d4ff;
border-radius: 20px;
       padding: 25px;
        box-shadow: 0 0 25px rgba(0, 212, 255, 0.4);
       transition: all 0.4s ease;
       position: relative;
      overflow: hidden;
   }

        .movie-card:hover {
    transform: translateY(-8px) scale(1.02);
      box-shadow: 0 15px 35px rgba(0, 212, 255, 0.6);
border-color: #4ecdc4;
        }

        .movie-title {
     color: #4ecdc4 !important;
     font-size: 1.5em !important;
       font-weight: 800 !important;
        text-shadow: 0 0 15px #4ecdc4 !important;
     margin-bottom: 15px !important;
 text-transform: uppercase !important;
      letter-spacing: 1px !important;
        }

.movie-details {
      color: #b8c6db !important;
    line-height: 1.6 !important;
      margin-bottom: 20px !important;
 }

        .movie-price {
        color: #ff6b6b !important;
     font-size: 1.3em !important;
 font-weight: 700 !important;
      text-shadow: 0 0 10px #ff6b6b !important;
       margin-bottom: 15px !important;
  }

  .rent-button {
     background: linear-gradient(145deg, #ff6b6b, #ff5252);
     color: #ffffff;
    text-decoration: none;
 padding: 12px 25px;
      border-radius: 10px;
       font-weight: 700;
      transition: all 0.3s ease;
   text-transform: uppercase;
        letter-spacing: 1px;
       font-size: 0.9em;
     display: inline-block;
 }

      .rent-button:hover {
       background: linear-gradient(145deg, #ff5252, #ff3030);
      transform: translateY(-2px);
       box-shadow: 0 5px 15px rgba(255, 107, 107, 0.6);
        }

        .no-movies {
  text-align: center;
      color: #b8c6db;
       font-size: 1.3em;
padding: 50px;
    background: linear-gradient(145deg, rgba(255, 107, 107, 0.1), rgba(255, 107, 107, 0.05));
    border: 2px solid rgba(255, 107, 107, 0.3);
      border-radius: 15px;
}
    </style>

  <div class="browse-movies-container">
  <h2 class="browse-title">Browse All Movies</h2>
        
   <div class="search-section">
   <div class="search-controls">
     <div>
    <label style="color: #4ecdc4; font-weight: 700; margin-bottom: 10px; display: block;">Search Movies:</label>
        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Enter movie title or keyword..." />
      </div>
      <div>
     <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="search-button" OnClick="btnSearch_Click" />
     </div>
    </div>
      </div>

      <asp:Label ID="lblMessage" runat="server" CssClass="cyber-message" Visible="false" />
        
    <div class="movies-grid" id="moviesContainer" runat="server">
     <!-- Movies will be populated here -->
  </div>
    </div>

</asp:Content>