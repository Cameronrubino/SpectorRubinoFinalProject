# SpectorRubinoFinalProject

ASP.NET Web Forms video rental application.

Features:
- Customer portal (browse, genre, rent, account, rentals)
- Staff portal (login, customers with rental history & quick checkout/return, movies, rentals, checkout)
- Automatic database schema & movie seeding (50+ movies) via AutoSeed on first DB access.

Requirements:
- Visual Studio (ASP.NET4.x)
- SQL Server LocalDB (default instance (localdb)\\MSSQLLocalDB)

Connection String:
Ensure Web.config has:
 <connectionStrings>
 <add name="MoviesDB" connectionString="Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=MoviesDB;Integrated Security=True" providerName="System.Data.SqlClient" />
 </connectionStrings>

First Run:
1. Open solution/folder in Visual Studio.
2. Press F5.
3. AutoSeed runs on first request (no manual initialization needed).

Optional legacy page Setup/InitializeDB.aspx can be removed; AutoSeed already seeds data.

Folder Notes:
- App_Code contains AutoSeed.cs (auto schema & data) and DatabaseHelper.cs (invokes seeding).
- StaffArea & Areas/Customer contain portal pages.

If movies do not appear, verify LocalDB instance installed.
