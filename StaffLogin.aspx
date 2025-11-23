<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Staff Login - Rokey's Video Rentals</title>
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

        .login-container {
   background: linear-gradient(145deg, #1a1a2e, #16213e);
            border: 3px solid #ff6b6b;
            border-radius: 20px;
 padding: 50px;
            text-align: center;
      box-shadow: 0 0 50px rgba(255, 107, 107, 0.5);
   position: relative;
            max-width: 500px;
   width: 90%;
      }

        .login-container::before {
   content: '';
            position: absolute;
       top: -3px;
            left: -3px;
 right: -3px;
       bottom: -3px;
       background: linear-gradient(45deg, #ff6b6b, #4ecdc4, #00d4ff, #ff6b6b);
            border-radius: 20px;
            z-index: -1;
    animation: borderGlow 3s linear infinite;
        }

        @keyframes borderGlow {
        0%, 100% { opacity: 0.8; }
         50% { opacity: 1; }
        }

        .login-title {
  color: #ff6b6b;
   font-size: 3em;
      margin-bottom: 30px;
            text-shadow: 0 0 20px #ff6b6b, 0 0 40px #ff6b6b;
        letter-spacing: 3px;
            text-transform: uppercase;
    font-weight: 900;
        }

        .login-subtitle {
     color: #4ecdc4;
        font-size: 1.2em;
            margin-bottom: 30px;
  text-shadow: 0 0 10px #4ecdc4;
            letter-spacing: 2px;
        }

        .password-input {
     background: linear-gradient(145deg, #0f0f23, #1a1a2e);
      border: 3px solid #00d4ff;
       border-radius: 10px;
            color: #00d4ff;
   font-family: 'Orbitron', monospace;
      font-size: 18px;
    font-weight: 500;
  padding: 20px;
            width: 100%;
            margin-bottom: 30px;
       box-shadow: inset 0 0 15px rgba(0, 212, 255, 0.2), 0 0 15px rgba(0, 212, 255, 0.3);
            text-align: center;
          letter-spacing: 2px;
    }

  .password-input:focus {
        outline: none;
     border-color: #ff6b6b;
     box-shadow: inset 0 0 20px rgba(0, 212, 255, 0.3), 0 0 30px rgba(255, 107, 107, 0.7);
     transform: scale(1.02);
   }

.login-button {
    background: linear-gradient(145deg, #ff6b6b, #ff5252);
        border: 3px solid #ff6b6b;
    color: #ffffff;
            padding: 20px 40px;
      border-radius: 10px;
font-family: 'Orbitron', sans-serif;
         font-weight: 700;
            letter-spacing: 2px;
    cursor: pointer;
    text-shadow: 0 2px 4px rgba(0,0,0,0.5);
   box-shadow: 0 8px 25px rgba(255, 107, 107, 0.5);
            text-transform: uppercase;
    font-size: 16px;
          transition: all 0.3s ease;
     margin-right: 15px;
        }

   .login-button:hover {
            background: linear-gradient(145deg, #ff5252, #ff3030);
      transform: translateY(-3px);
        box-shadow: 0 12px 30px rgba(255, 107, 107, 0.7);
        }

  .back-button {
       background: linear-gradient(145deg, #4ecdc4, #45b7d1);
    border: 3px solid #4ecdc4;
            color: #ffffff;
          padding: 15px 30px;
       border-radius: 8px;
     font-family: 'Orbitron', sans-serif;
            font-weight: 700;
    letter-spacing: 1px;
    cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-transform: uppercase;
            font-size: 14px;
      transition: all 0.3s ease;
            margin-top: 20px;
  }

  .back-button:hover {
      background: linear-gradient(145deg, #45b7d1, #4ecdc4);
            transform: translateY(-2px);
        }

        .error-message {
   background: linear-gradient(135deg, rgba(255, 107, 107, 0.3), rgba(255, 107, 107, 0.1));
         border: 2px solid #ff6b6b;
            color: #ff6b6b;
      text-shadow: 0 0 10px #ff6b6b;
     padding: 15px;
          margin: 20px 0;
        border-radius: 10px;
     font-weight: 600;
   }

        .access-info {
     color: #b8c6db;
        font-size: 0.9em;
         margin-top: 20px;
            line-height: 1.6;
    }
    </style>
</head>
<body>
    <form runat="server">
        <div class="login-container">
            <h1 class="login-title">Staff Access</h1>
 <p class="login-subtitle">Staff Login Password:</p>
        
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="password-input" 
                placeholder="Enter staff password" />
        
          <asp:Label ID="lblError" runat="server" CssClass="error-message" Visible="false" />
            
         <div>
    <asp:Button ID="btnLogin" runat="server" Text="Access Staff Area" OnClick="btnLogin_Click" CssClass="login-button" />
          </div>
            
        <a href="Default.aspx" class="back-button">Back to Customer Area</a>
        
     <div class="access-info">
    <strong>Staff Only Area</strong><br/>
    Authorized personnel access for:<br/>
   • Movie & Genre Management<br/>
                • Customer Administration<br/>
    • Rental History & Reports
  </div>
        </div>
    </form>
 <script runat="server">
 protected void Page_Load(object sender, EventArgs e)
 {
 if (Session["StaffAuthenticated"] != null && Session["StaffAuthenticated"] is bool && (bool)Session["StaffAuthenticated"])
 {
 Response.Redirect("StaffArea/Dashboard.aspx");
 }
 }
 protected void btnLogin_Click(object sender, EventArgs e)
 {
 string pwd = txtPassword.Text.Trim();
 if (pwd == "Bearcats")
 {
 Session["StaffAuthenticated"] = true;
 Session["StaffLoginTime"] = DateTime.Now;
 Response.Redirect("StaffArea/Dashboard.aspx");
 }
 else
 {
 lblError.Text = "Invalid password. Access denied.";
 lblError.Visible = true;
 txtPassword.Text = string.Empty;
 txtPassword.Focus();
 }
 }
 </script>
</body>
</html>