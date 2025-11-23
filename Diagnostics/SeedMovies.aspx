<%@ Page Language="C#" AutoEventWireup="true" %>
<script runat="server">
protected void Page_Load(object sender,EventArgs e){ if(!IsPostBack){ lblStatus.Text="Ready"; } }
protected void btnSeed_Click(object sender,EventArgs e){ try{ using(var conn=DatabaseHelper.GetConnection()){ conn.Open(); EnsureMoviesTable(conn); DatabaseHelper.EnsureMovieColumns(conn); int before=CountMovies(conn); if(before<10){ DropAndRecreateMovies(conn); DatabaseHelper.EnsureMovieColumns(conn); } SeedGenres(conn); SeedMovies(conn); int after=CountMovies(conn); lblStatus.Text=System.String.Format("Seed complete. Before: {0} After: {1}",before,after); ShowCodes(conn); } } catch(Exception ex){ lblStatus.Text="ERROR: "+Server.HtmlEncode(ex.Message); } }
void EnsureMoviesTable(System.Data.SqlClient.SqlConnection conn){ using(var cmd=new System.Data.SqlClient.SqlCommand("IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='movies') BEGIN CREATE TABLE movies (MOV_code NVARCHAR(50) NOT NULL PRIMARY KEY,MOV_title NVARCHAR(200) NOT NULL) END",conn)){ cmd.ExecuteNonQuery(); } }
int CountMovies(System.Data.SqlClient.SqlConnection conn){ using(var cmd=new System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM movies",conn)) return (int)cmd.ExecuteScalar(); }
void SeedGenres(System.Data.SqlClient.SqlConnection conn){ using(var cmd=new System.Data.SqlClient.SqlCommand("IF NOT EXISTS(SELECT 1 FROM genre) BEGIN INSERT INTO genre (GEN_code,GEN_name) VALUES ('ACT','Action'),('COM','Comedy'),('DRA','Drama'),('SCI','Sci-Fi'),('HOR','Horror'),('ROM','Romance') END",conn)){ cmd.ExecuteNonQuery(); } }
void SeedMovies(System.Data.SqlClient.SqlConnection conn){ var movies=new[]{
 new Movie("M001","The Matrix","ACT",1999,136,12.99M,"Hacker discovers reality is a simulation."),
 new Movie("M002","Toy Story","COM",1995,81,9.99M,"Toys come alive confronting jealousy and change."),
 new Movie("M003","Titanic","ROM",1997,195,14.99M,"Epic romance unfolds aboard doomed liner."),
 new Movie("M004","Avatar","SCI",2009,162,15.00M,"Marine bonds with alien world to save tribe."),
 new Movie("M005","The Avengers","ACT",2012,143,13.99M,"Heroes unite to stop global destruction."),
 new Movie("M006","Finding Nemo","COM",2003,100,10.99M,"Clownfish crosses ocean to rescue his son."),
 new Movie("M007","The Dark Knight","ACT",2008,152,12.99M,"Vigilante faces anarchic mastermind Joker."),
 new Movie("M008","Frozen","COM",2013,102,11.99M,"Sisters navigate magic, isolation and love."),
 new Movie("M009","Inception","SCI",2010,148,14.99M,"Mind-bending heist inside layered dreams."),
 new Movie("M010","Interstellar","SCI",2014,169,14.99M,"Father journeys through space to save Earth."),
 new Movie("M011","Gladiator","ACT",2000,155,13.99M,"Roman general seeks vengeance in the arena."),
 new Movie("M012","The Godfather","DRA",1972,175,12.99M,"Crime family legacy and power struggles."),
 new Movie("M013","Jurassic Park","SCI",1993,127,11.99M,"Dinosaurs run amok in a theme park."),
 new Movie("M014","Pulp Fiction","DRA",1994,154,12.99M,"Intersecting crime stories with dark humor."),
 new Movie("M015","The Shawshank Redemption","DRA",1994,142,13.99M,"Innocent man finds hope and freedom in prison."),
 new Movie("M016","The Lion King","COM",1994,89,10.99M,"Exiled lion prince returns to reclaim throne."),
 new Movie("M017","Back to the Future","SCI",1985,116,11.99M,"Teen travels back in time to ensure parents meet."),
 new Movie("M018","Aliens","SCI",1986,137,12.99M,"Ripley battles xenomorphs with colonial marines."),
 new Movie("M019","Die Hard","ACT",1988,132,11.99M,"Cop fights terrorists in a skyscraper."),
 new Movie("M020","Terminator2: Judgment Day","ACT",1991,137,12.99M,"Reprogrammed cyborg protects future leader."),
 new Movie("M021","Braveheart","ACT",1995,178,13.99M,"Scottish warrior leads rebellion for freedom."),
 new Movie("M022","Forrest Gump","DRA",1994,142,12.99M,"Simple man influences decades of history."),
 new Movie("M023","The Silence of the Lambs","HOR",1991,118,12.99M,"Agent seeks serial killer with cannibal genius."),
 new Movie("M024","The Sixth Sense","HOR",1999,107,11.99M,"Boy sees spirits; therapist seeks redemption."),
 new Movie("M025","The Ring","HOR",2002,115,10.99M,"Journalist investigates cursed videotape."),
 new Movie("M026","Get Out","HOR",2017,104,13.99M,"Visit to girlfriend's family hides dark secret."),
 new Movie("M027","A Quiet Place","HOR",2018,90,12.99M,"Family survives monsters by living in silence."),
 new Movie("M028","The Notebook","ROM",2004,123,11.99M,"Young couple endures class and memory struggles."),
 new Movie("M029","La La Land","ROM",2016,128,13.99M,"Dreamers chase love and careers in LA."),
 new Movie("M030","The Fault in Our Stars","ROM",2014,126,11.99M,"Two teens with illness find profound love."),
 new Movie("M031","Crazy Rich Asians","ROM",2018,120,12.99M,"Professor meets boyfriend's ultra-wealthy family."),
 new Movie("M032","Parasite","DRA",2019,132,14.99M,"Struggling family infiltrates wealthy household."),
 new Movie("M033","Whiplash","DRA",2014,107,12.99M,"Drummer pushed to limits by ruthless mentor."),
 new Movie("M034","The Social Network","DRA",2010,120,11.99M,"Founding of social empire breeds betrayal."),
 new Movie("M035","Mad Max: Fury Road","ACT",2015,120,14.99M,"Apocalyptic chase for freedom and hope."),
 new Movie("M036","Guardians of the Galaxy","ACT",2014,121,13.99M,"Misfit crew protects powerful cosmic artifact."),
 new Movie("M037","Doctor Strange","SCI",2016,115,13.99M,"Surgeon learns mystic arts to defend reality."),
 new Movie("M038","Blade Runner2049","SCI",2017,164,14.99M,"Replicant detective uncovers hidden child."),
 new Movie("M039","Edge of Tomorrow","SCI",2014,113,12.99M,"Soldier relives battle to defeat aliens."),
 new Movie("M040","Spider-Man: Homecoming","ACT",2017,133,13.99M,"Teen hero balances school and villain threat."),
 new Movie("M041","Black Panther","ACT",2018,134,14.99M,"King defends nation against internal rival."),
 new Movie("M042","Shrek","COM",2001,90,9.99M,"Ogre rescues princess challenging fairy tale norms."),
 new Movie("M043","The Hangover","COM",2009,100,10.99M,"Friends retrace wild night to find groom."),
 new Movie("M044","Superbad","COM",2007,113,10.99M,"High-school seniors seek epic party success."),
 new Movie("M045","Step Brothers","COM",2008,98,9.99M,"Middle-aged men become feuding step siblings."),
 new Movie("M046","Jumanji: Welcome to the Jungle","ACT",2017,119,12.99M,"Teens trapped in game avatars survive jungle."),
 new Movie("M047","Pacific Rim","SCI",2013,131,12.99M,"Pilots use giant mechs against sea monsters."),
 new Movie("M048","The Prestige","DRA",2006,130,12.99M,"Rival magicians obsess over ultimate trick."),
 new Movie("M049","The Departed","DRA",2006,151,13.99M,"Undercover cop and mole hunt each other."),
 new Movie("M050","Casino Royale","ACT",2006,144,13.99M,"Agent earns00 status facing high-stakes villain.")
 };
 string insert="IF NOT EXISTS(SELECT 1 FROM movies WHERE MOV_code=@code) INSERT INTO movies (MOV_code,MOV_title,MOV_genre,MOV_year,MOV_duration,MOV_price,MOV_description) VALUES (@code,@title,@genre,@year,@dur,@price,@desc) ELSE UPDATE movies SET MOV_title=@title,MOV_genre=@genre,MOV_year=@year,MOV_duration=@dur,MOV_price=@price,MOV_description=@desc WHERE MOV_code=@code";
 foreach(var m in movies){ using(var cmd=new System.Data.SqlClient.SqlCommand(insert,conn)){ cmd.Parameters.AddWithValue("@code",m.Code); cmd.Parameters.AddWithValue("@title",m.Title); cmd.Parameters.AddWithValue("@genre",m.Genre); cmd.Parameters.AddWithValue("@year",m.Year); cmd.Parameters.AddWithValue("@dur",m.Duration); cmd.Parameters.AddWithValue("@price",m.Price); cmd.Parameters.AddWithValue("@desc",m.Description); cmd.ExecuteNonQuery(); } }
 }
void DropAndRecreateMovies(System.Data.SqlClient.SqlConnection conn){ using(var cmd=new System.Data.SqlClient.SqlCommand("IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='movies') DROP TABLE movies; CREATE TABLE movies (MOV_code NVARCHAR(50) NOT NULL PRIMARY KEY,MOV_title NVARCHAR(200) NOT NULL)",conn)){ cmd.ExecuteNonQuery(); } }
void ShowCodes(System.Data.SqlClient.SqlConnection conn){ using(var cmd=new System.Data.SqlClient.SqlCommand("SELECT MOV_code FROM movies ORDER BY MOV_code",conn)) using(var r=cmd.ExecuteReader()){ System.Text.StringBuilder sb=new System.Text.StringBuilder(); sb.Append("<br/>Codes: "); bool first=true; while(r.Read()){ if(!first) sb.Append(", "); first=false; sb.Append(r.GetString(0)); } codes.InnerHtml=sb.ToString(); } }
class Movie{ public string Code; public string Title; public string Genre; public int Year; public int Duration; public decimal Price; public string Description; public Movie(string c,string t,string g,int y,int d,decimal p,string desc){ Code=c; Title=t; Genre=g; Year=y; Duration=d; Price=p; Description=desc; } }
</script>
<!DOCTYPE html>
<html><head runat="server"><title>Seed Movies</title></head>
<body style="font-family:Arial;padding:30px;">
 <form runat="server">
 <h2>Movie Seeder</h2>
 <p>Click to insert/update a baseline catalog (50 movies).</p>
 <asp:Button ID="btnSeed" runat="server" Text="Seed Movies" OnClick="btnSeed_Click" />
 <br/><br/>
 <asp:Label ID="lblStatus" runat="server" />
 <div id="codes" runat="server"></div>
 </form>
</body></html></body></html>