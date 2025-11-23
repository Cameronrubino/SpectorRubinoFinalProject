<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StaffLogout.aspx.cs" Inherits="StaffLogoutPage" %>
<!DOCTYPE html>
<html>
<head runat="server">
 <title>Logout - Staff Portal</title>
 <meta charset="utf-8" />
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&display=swap" rel="stylesheet" />
    <style>
        body {
font-family: 'Orbitron', monospace;
     background: linear-gradient(135deg, #0f0f23 0%, #1a1a2e 50%, #16213e 100%);
color: #00d4ff;
 min-height: 100vh;
       margin: 0;
       padding: 0;
      display: flex;
     align-items: center;
       justify-content: center;
   }

      .logout-container {
 background: linear-gradient(145deg, #1a1a2e, #16213e);
    border: 3px solid #4ecdc4;
    border-radius: 20px;
       padding: 50px;
    text-align: center;
        box-shadow: 0 0 50px rgba(76, 205, 196, 0.5);
   max-width: 500px;
        }

       .logout-title {
    color: #4ecdc4;
      font-size: 2.5em;
        margin-bottom: 20px;
     text-shadow: 0 0 20px #4ecdc4;
       letter-spacing: 2px;
 text-transform: uppercase;
        font-weight: 900;
      }

 .logout-message {
  color: #b8c6db;
   font-size: 1.2em;
        margin-bottom: 30px;
      line-height: 1.6;
        }

     .home-button {
   background: linear-gradient(145deg, #4ecdc4, #45b7d1);
 border: 2px solid #4ecdc4;
 color: #ffffff;
     padding: 15px 30px;
  border-radius: 8px;
      font-family: 'Orbitron', sans-serif;
       font-weight: 700;
    text-decoration: none;
    display: inline-block;
 text-transform: uppercase;
        transition: all 0.3s ease;
        }

     .home-button:hover {
 background: linear-gradient(145deg, #45b7d1, #4ecdc4);
  transform: translateY(-2px);
      }
 </style>
</head>
<body>
 <form runat="server">
  <div class="logout-container">
    <h1 class="logout-title">Logged Out</h1>
        <p class="logout-message">
     You have been successfully logged out of the staff portal.
    Thank you for using Rokey's Video Rentals management system.
      </p>
   <asp:HyperLink ID="lnkReturn" runat="server" NavigateUrl="~/Customer/CustomerDefault.aspx" CssClass="home-button">Return to Customer Portal</asp:HyperLink>
        </div>
    </form>
</body>
</html>