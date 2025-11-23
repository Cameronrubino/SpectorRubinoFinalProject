<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html>
<head runat="server">
  <title>Rokey's Video Rentals</title>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&display=swap" rel="stylesheet" />
    <style>
  body { 
       font-family: 'Orbitron', monospace; 
      text-align: center; 
     padding: 50px; 
        background: linear-gradient(135deg, #0f0f23 0%, #1a1a2e 50%, #16213e 100%);
 color: #00d4ff; 
      min-height: 100vh;
 display: flex;
            flex-direction: column;
         justify-content: center;
  align-items: center;
  }
        
     .welcome-container {
     background: linear-gradient(145deg, rgba(26, 26, 46, 0.95), rgba(22, 33, 62, 0.95));
     border: 2px solid #00d4ff;
border-radius: 20px;
   padding: 50px;
      box-shadow: 0 0 40px rgba(0, 212, 255, 0.3);
       max-width: 800px;
      }
     
        .logo {
 font-size: 4em;
      color: #ff6b6b;
    text-shadow: 0 0 30px #ff6b6b;
       margin-bottom: 30px;
 letter-spacing: 8px;
            text-transform: uppercase;
     }
        
        .tagline {
    color: #4ecdc4;
       font-size: 1.3em;
      margin-bottom: 40px;
        letter-spacing: 2px;
     text-shadow: 0 0 15px #4ecdc4;
        }
  
     .navigation-links {
 display: grid;
     grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
     gap: 20px;
   margin-top: 40px;
  }
        
.nav-link {
      background: linear-gradient(145deg, #4ecdc4, #45b7d1);
    color: #ffffff;
      text-decoration: none;
 padding: 15px 25px;
        border-radius: 10px;
         font-weight: 700;
      text-transform: uppercase;
    letter-spacing: 1px;
          transition: all 0.3s ease;
       display: block;
    }
        
        .nav-link:hover {
 background: linear-gradient(145deg, #45b7d1, #4ecdc4);
  transform: translateY(-3px);
      box-shadow: 0 8px 20px rgba(76, 205, 196, 0.5);
     }
  
        .staff-link {
            background: linear-gradient(145deg, #ff6b6b, #ff5252);
        }
        
   .staff-link:hover {
    background: linear-gradient(145deg, #ff5252, #ff3030);
        box-shadow: 0 8px 20px rgba(255, 107, 107, 0.5);
        }
    </style>
</head>
<body>
   <form id="form1" runat="server">
 <div class="welcome-container">
 <div class="logo">ROKEY'S</div>
 <h1>Video Rentals</h1>
 <p class="tagline">Your Entertainment Destination Since 1985</p>
 <div class="navigation-links">
 <a href="Areas/Customer/Pages/BrowseByGenre.aspx" class="nav-link">Browse by Genre</a>
 <a href="Areas/Customer/Pages/Home.aspx" class="nav-link">Full Customer Portal</a>
 <a href="StaffLogin.aspx" class="nav-link staff-link">Staff Login</a>
 </div>
 <p style="margin-top:30px;color:#b8c6db;font-size:.9em;">
 Thousands of movies • Competitive prices • Cyberpunk themed interface
 </p>
 </div>
 </form>
 <script runat="server">
 protected void Page_Load(object sender, EventArgs e) {
 // no server logic needed
 }
 </script>
</body>
</html>