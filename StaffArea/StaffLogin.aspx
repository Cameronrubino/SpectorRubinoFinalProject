<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html>
<head runat="server">
 <title>Staff Login - Rokey's Video Rentals</title>
 <meta charset="utf-8" />
 <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&display=swap" rel="stylesheet" />
 <style>
 /* simplified styles */
 body { font-family:'Orbitron',monospace;background:#0f0f23;color:#00d4ff;display:flex;align-items:center;justify-content:center;min-height:100vh;margin:0; }
 .login-container { background:#1a1a2e;border:2px solid #ff6b6b;border-radius:16px;padding:40px;max-width:420px;width:90%; text-align:center; }
 .login-title { color:#ff6b6b;font-size:2.4em;margin-bottom:10px; }
 .login-subtitle { color:#4ecdc4;margin-bottom:25px; }
 .password-input { width:100%;padding:14px;border:2px solid #00d4ff;border-radius:8px;background:#0f0f23;color:#00d4ff;font-family:'Orbitron'; }
 .login-button { background:#ff6b6b;border:none;color:#fff;padding:14px30px;border-radius:8px;font-weight:700;cursor:pointer;margin-top:15px; }
 .back-button { display:inline-block;margin-top:20px;color:#4ecdc4;text-decoration:none;font-weight:700; }
 .error-message { margin-top:15px;color:#ff6b6b;font-weight:700; }
 </style>
</head>
<body>
 <form runat="server">
 <div class="login-container">
 <h1 class="login-title">Staff Access</h1>
 <p class="login-subtitle">Enter Staff Password</p>
 <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="password-input" />
 <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="login-button" OnClick="btnLogin_Click" />
 <asp:Label ID="lblError" runat="server" CssClass="error-message" Visible="false" />
 <a href="../Default.aspx" class="back-button">Back to Home</a>
 </div>
 </form>
 <script runat="server">
 protected void Page_Load(object sender, EventArgs e)
 {
 var flag = Session["StaffAuthenticated"] as bool?; if(flag.HasValue && flag.Value) Response.Redirect("Dashboard.aspx");
 }
 protected void btnLogin_Click(object sender, EventArgs e)
 {
 if(txtPassword.Text.Trim()=="Bearcats") { Session["StaffAuthenticated"]=true; Session["StaffLoginTime"]=DateTime.Now; Response.Redirect("Dashboard.aspx"); }
 else { lblError.Text="Invalid password"; lblError.Visible=true; }
 }
 </script>
</body>
</html>