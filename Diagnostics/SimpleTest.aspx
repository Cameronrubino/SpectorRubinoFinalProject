<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html>
<head runat="server">
 <title>Simple Test - C# Working</title>
 <style>
 body { background: linear-gradient(135deg,#0f0f23,#1a1a2e); color:#00d4ff; font-family:'Orbitron',monospace; padding:50px; text-align:center; }
 .container { background:rgba(26,26,46,0.9); border:2px solid #00d4ff; border-radius:15px; padding:30px; max-width:600px; margin:0 auto; }
 .title { color:#4ecdc4; font-size:2em; margin-bottom:20px; }
 .message { color:#ff6b6b; margin:20px0; }
 .nav-link { background:linear-gradient(145deg,#4ecdc4,#45b7d1); color:#fff; text-decoration:none; padding:10px20px; border-radius:8px; margin:10px; display:inline-block; }
 </style>
</head>
<body>
 <form id="form1" runat="server">
 <div class="container">
 <h1 class="title">C# Compilation Working!</h1>
 <p>This page verifies inline C# works.</p>
 <asp:Label ID="lblCurrentTime" runat="server" CssClass="message" />
 <div style="margin-top:30px;">
 <a href="../Default.aspx" class="nav-link">Back Home</a>
 <a href="../Areas/Customer/Pages/BrowseMovies.aspx" class="nav-link">Browse Movies</a>
 </div>
 </div>
 </form>
 <script runat="server">protected void Page_Load(object sender,EventArgs e){ lblCurrentTime.Text = "Page loaded at: "+ DateTime.Now.ToString("F"); }</script>
</body>
</html>