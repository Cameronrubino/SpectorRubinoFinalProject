<%@ Page Title="Create Account" Language="C#" MasterPageFile="~/Areas/Customer/CustomerMaster.Master" AutoEventWireup="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<script runat="server">
protected void btnCreateAccount_Click(object sender,EventArgs e){ var full=txtFullName.Text.Trim(); var user=txtUsername.Text.Trim(); var email=txtEmail.Text.Trim(); var phone=txtPhone.Text.Trim(); if(string.IsNullOrEmpty(full)||string.IsNullOrEmpty(user)){ ShowMsg("Please fill required fields",false); return; } try{ using(var conn=new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["MoviesDB"].ConnectionString)){ conn.Open(); CreateTable(conn); if(Exists(user,conn)){ ShowMsg("Username already exists",false); return; } using(var cmd=new System.Data.SqlClient.SqlCommand("INSERT INTO customers (customer_name,customer_username,customer_email,customer_phone,created_date) VALUES (@n,@u,@e,@p,@d)",conn)){ cmd.Parameters.AddWithValue("@n",full); cmd.Parameters.AddWithValue("@u",user); cmd.Parameters.AddWithValue("@e", string.IsNullOrEmpty(email)?(object)DBNull.Value:email); cmd.Parameters.AddWithValue("@p", string.IsNullOrEmpty(phone)?(object)DBNull.Value:phone); cmd.Parameters.AddWithValue("@d",DateTime.Now); cmd.ExecuteNonQuery(); } ShowMsg("Account created successfully!",true); Clear(); } } catch(Exception ex){ ShowMsg("Error: "+ex.Message,false); } }
void CreateTable(System.Data.SqlClient.SqlConnection conn){ using(var cmd=new System.Data.SqlClient.SqlCommand(@"IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='customers') BEGIN CREATE TABLE customers (customer_id INT IDENTITY(1,1) PRIMARY KEY,customer_name NVARCHAR(100) NOT NULL,customer_username NVARCHAR(50) NOT NULL UNIQUE,customer_email NVARCHAR(100),customer_phone NVARCHAR(20),created_date DATETIME NOT NULL DEFAULT GETDATE()) END",conn)){ cmd.ExecuteNonQuery(); } }
bool Exists(string u,System.Data.SqlClient.SqlConnection conn){ using(var cmd=new System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM customers WHERE customer_username=@u",conn)){ cmd.Parameters.AddWithValue("@u",u); return (int)cmd.ExecuteScalar()>0; } }
void ShowMsg(string m,bool ok){ lblMessage.Text=m; lblMessage.CssClass= ok?"success-message":"error-message"; lblMessage.Visible=true; }
void Clear(){ txtFullName.Text=""; txtUsername.Text=""; txtEmail.Text=""; txtPhone.Text=""; }
</script>

 <style>
      .create-account-container {
    background: transparent;
   color: #00d4ff;
      font-family: 'Orbitron', monospace;
        }

   .create-title {
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

        .form-container {
            background: linear-gradient(145deg, rgba(30, 30, 63, 0.9), rgba(45, 45, 95, 0.9));
   border: 2px solid #00d4ff;
   border-radius: 20px;
        padding: 40px;
            margin: 0 auto;
   max-width: 600px;
          box-shadow: 0 0 30px rgba(0, 212, 255, 0.4);
        }

        .form-group {
      margin-bottom: 25px;
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

      .form-input {
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

   .form-input:focus {
            outline: none;
   border-color: #4ecdc4;
      box-shadow: 0 0 20px rgba(76, 205, 196, 0.6);
        }

        .create-button {
       background: linear-gradient(145deg, #4ecdc4, #45b7d1);
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

   .create-button:hover {
        background: linear-gradient(145deg, #45b7d1, #4ecdc4);
     transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(76, 205, 196, 0.6);
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

    <div class="create-account-container">
        <h2 class="create-title">Create Customer Account</h2>
        
        <div class="form-container">
   <div class="form-group">
     <label class="form-label">Full Name:</label>
            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-input" placeholder="Enter your full name" />
          </div>
    
            <div class="form-group">
             <label class="form-label">Username:</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-input" placeholder="Choose a unique username" />
    </div>
     
            <div class="form-group">
    <label class="form-label">Email Address:</label>
       <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="Enter your email" />
  </div>
    
         <div class="form-group">
<label class="form-label">Phone Number:</label>
              <asp:TextBox ID="txtPhone" runat="server" CssClass="form-input" placeholder="Enter your phone number" />
            </div>
            
    <asp:Label ID="lblMessage" runat="server" Visible="false" />
      
      <asp:Button ID="btnCreateAccount" runat="server" Text="Create Account" 
     CssClass="create-button" OnClick="btnCreateAccount_Click" />
        </div>
    </div>

</asp:Content>