<%@ Page Title="My Rentals" Language="C#" MasterPageFile="~/Areas/Customer/CustomerMaster.Master" AutoEventWireup="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<script runat="server">
protected void btnSearchRentals_Click(object sender,EventArgs e){ var search=txtCustomerSearch.Text.Trim(); if(string.IsNullOrEmpty(search)){ ShowMsg("Please enter a username or customer ID."); rentalsContainer.InnerHtml=""; return; } LoadRentals(search); }
void LoadRentals(string search){ try{ using(var conn=new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["MoviesDB"].ConnectionString)){ conn.Open(); if(!TableExists("rentals",conn)){ ShowMsg("Rental table missing."); return; } using(var cmd=new System.Data.SqlClient.SqlCommand(@"SELECT r.rental_id,r.customer_id,ISNULL(c.customer_name,'Unknown Customer') CustomerName,ISNULL(c.customer_username,'N/A') Username,r.movie_code,ISNULL(m.MOV_title,'Unknown Movie') MovieTitle,r.rental_date,r.return_date,r.rental_price,ISNULL(r.rental_status,'Unknown') Status FROM rentals r LEFT JOIN customers c ON r.customer_id=c.customer_id LEFT JOIN movies m ON r.movie_code=m.MOV_code WHERE (c.customer_username LIKE @s OR CAST(r.customer_id AS varchar)=@s) ORDER BY r.rental_date DESC",conn)){ cmd.Parameters.AddWithValue("@s",search); using(var r=cmd.ExecuteReader()){ var sb=new System.Text.StringBuilder(); int count=0; while(r.Read()){ count++; string uname=r["Username"].ToString(); string cname=r["CustomerName"].ToString(); string mov=r["MovieTitle"].ToString(); DateTime rd=Convert.ToDateTime(r["rental_date"]); object ret=r["return_date"]; decimal price=Convert.ToDecimal(r["rental_price"]); string status=r["Status"].ToString(); string returnTxt="Not returned"; string cls="status-active"; if(ret!=DBNull.Value){ DateTime retDt=Convert.ToDateTime(ret); returnTxt=retDt.ToString("MMM dd, yyyy"); cls="status-returned"; status="Returned"; } else { if(DateTime.Now.Subtract(rd).Days>7){ cls="status-overdue"; status="OVERDUE"; } else { status="Active"; } } sb.AppendFormat("<div class='rental-card'><h3 class='rental-movie'>{0}</h3><div class='rental-info'><strong>Customer:</strong> {1} ({2})<br/><strong>Rental Date:</strong> {3}<br/><strong>Return Date:</strong> {4}<br/><strong>Price:</strong> ${5:F2}<br/><div class='rental-status {6}'><strong>Status:</strong> {7}</div></div></div>", mov,cname,uname, rd.ToString("MMM dd, yyyy"), returnTxt, price, cls, status); } if(count==0){ sb.AppendFormat("<div class='no-rentals'>No rental history found for '{0}'.</div>",search);} else { sb.Insert(0,System.String.Format("<div style='text-align:center;margin-bottom:20px;color:#4ecdc4;font-size:1.2em;'>Found {0} rental(s) for {1}</div>", count, search)); } rentalsContainer.InnerHtml=sb.ToString(); lblMessage.Visible=false; } } } } catch(Exception ex){ ShowMsg("Error loading rental history: "+ex.Message); rentalsContainer.InnerHtml=""; } }
bool TableExists(string t,System.Data.SqlClient.SqlConnection conn){ using(var cmd=new System.Data.SqlClient.SqlCommand("SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME=@t",conn)){ cmd.Parameters.AddWithValue("@t",t); return cmd.ExecuteScalar()!=null; } }
void ShowMsg(string m){ lblMessage.Text=m; lblMessage.Visible=true; }
</script>

    <style>
      .rentals-container {
     background: transparent;
      color: #00d4ff;
    font-family: 'Orbitron', monospace;
}

        .rentals-title {
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

        .customer-search {
   background: linear-gradient(145deg, rgba(30, 30, 63, 0.9), rgba(45, 45, 95, 0.9));
border: 2px solid #00d4ff;
  border-radius: 20px;
        padding: 30px;
 margin-bottom: 40px;
    text-align: center;
        box-shadow: 0 0 30px rgba(0, 212, 255, 0.4);
 }

     .search-label {
       color: #4ecdc4;
  font-weight: 700;
     font-size: 1.3em;
  margin-bottom: 20px;
 display: block;
     text-transform: uppercase;
       letter-spacing: 2px;
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
   margin: 0 10px;
 transition: all 0.4s ease;
      min-width: 250px;
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
      padding: 15px 25px;
     border-radius: 12px;
    font-family: 'Orbitron', monospace;
       font-weight: 700;
cursor: pointer;
   text-transform: uppercase;
  letter-spacing: 1px;
      transition: all 0.3s ease;
 margin: 0 10px;
   }

      .search-button:hover {
 background: linear-gradient(145deg, #45b7d1, #4ecdc4);
      transform: translateY(-2px);
   }

 .rentals-grid {
    display: grid;
   grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
     gap: 25px;
 margin-top: 30px;
 }

     .rental-card {
        background: linear-gradient(145deg, rgba(30, 30, 63, 0.95), rgba(45, 45, 95, 0.95));
  border: 2px solid #00d4ff;
    border-radius: 20px;
     padding: 25px;
     box-shadow: 0 0 25px rgba(0, 212, 255, 0.4);
       transition: all 0.4s ease;
        }

      .rental-card:hover {
       transform: translateY(-5px);
box-shadow: 0 10px 30px rgba(0, 212, 255, 0.6);
 border-color: #4ecdc4;
      }

   .rental-movie {
       color: #4ecdc4 !important;
        font-size: 1.4em !important;
      font-weight: 700 !important;
 text-shadow: 0 0 10px #4ecdc4 !important;
     margin-bottom: 15px !important;
    text-transform: uppercase !important;
     }

        .rental-info {
     color: #b8c6db !important;
 line-height: 1.6 !important;
    margin-bottom: 15px !important;
      }

   .rental-status {
     font-weight: 700 !important;
 font-size: 1.1em !important;
    }

        .status-active {
     color: #4ecdc4 !important;
       text-shadow: 0 0 10px #4ecdc4 !important;
       }

       .status-returned {
   color: #ff6b6b !important;
     text-shadow: 0 0 10px #ff6b6b !important;
  }

        .status-overdue {
     color: #ffa500 !important;
      text-shadow: 0 0 10px #ffa500 !important;
  animation: overdueFlash 2s ease-in-out infinite;
  }

     @keyframes overdueFlash {
    0%, 100% { opacity: 1; }
      50% { opacity: 0.6; }
     }

       .no-rentals {
    text-align: center;
      color: #b8c6db;
   font-size: 1.4em;
    padding: 60px;
       background: linear-gradient(145deg, rgba(255, 107, 107, 0.1), rgba(255, 107, 107, 0.05));
       border: 2px solid rgba(255, 107, 107, 0.3);
      border-radius: 15px;
 margin: 40px 0;
        }

   .cyber-message {
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

 <div class="rentals-container">
   <h2 class="rentals-title">My Rental History</h2>
      
      <div class="customer-search">
        <label class="search-label">Enter Your Username or Customer ID:</label>
      <div>
     <asp:TextBox ID="txtCustomerSearch" runat="server" CssClass="search-input" placeholder="Username or Customer ID..." />
      <asp:Button ID="btnSearchRentals" runat="server" Text="View My Rentals" CssClass="search-button" OnClick="btnSearchRentals_Click" />
        </div>
        </div>

 <asp:Label ID="lblMessage" runat="server" CssClass="cyber-message" Visible="false" />
     
    <div class="rentals-grid" id="rentalsContainer" runat="server">
     <!-- Rentals will be populated here -->
        </div>
    </div>

</asp:Content>