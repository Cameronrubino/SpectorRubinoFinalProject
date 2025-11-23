using System; using System.Data.SqlClient; using System.Configuration;
public static class AutoSeed
{
 // Ensures base schema and50+ movies on first use without manual Initialize page
 public static void EnsureSeed()
 {
 try
 {
 using(var conn=new SqlConnection(ConfigurationManager.ConnectionStrings["MoviesDB"].ConnectionString))
 {
 conn.Open();
 EnsureTables(conn);
 EnsureMovieColumns(conn);
 SeedGenres(conn);
 SeedMovies(conn);
 }
 }
 catch { /* swallow silently for runtime, page logic will still work */ }
 }
 private static void EnsureTables(SqlConnection conn)
 {
 Exec(conn,"IF NOT EXISTS(SELECT1 FROM sys.objects WHERE name='customers' AND type='U') CREATE TABLE customers (customer_id INT IDENTITY(1,1) PRIMARY KEY,customer_username NVARCHAR(100) NULL,customer_name NVARCHAR(200) NULL,customer_email NVARCHAR(200) NULL,customer_phone NVARCHAR(50) NULL,created_date DATETIME NOT NULL DEFAULT GETDATE())");
 Exec(conn,"IF NOT EXISTS(SELECT1 FROM sys.objects WHERE name='movies' AND type='U') CREATE TABLE movies (MOV_code NVARCHAR(50) NOT NULL PRIMARY KEY,MOV_title NVARCHAR(200) NOT NULL)");
 Exec(conn,"IF NOT EXISTS(SELECT1 FROM sys.objects WHERE name='genre' AND type='U') CREATE TABLE genre (GEN_code NVARCHAR(50) NOT NULL PRIMARY KEY,GEN_name NVARCHAR(200) NOT NULL)");
 Exec(conn,"IF NOT EXISTS(SELECT1 FROM sys.objects WHERE name='rentals' AND type='U') CREATE TABLE rentals (rental_id INT IDENTITY(1,1) PRIMARY KEY,customer_id INT NOT NULL,movie_code NVARCHAR(50) NOT NULL,rental_date DATETIME NOT NULL,due_date DATETIME NOT NULL,return_date DATETIME NULL,rental_price DECIMAL(10,2) NOT NULL DEFAULT0,rental_status NVARCHAR(20) NOT NULL DEFAULT 'Active')");
 }
 private static void EnsureMovieColumns(SqlConnection conn)
 {
 string[] stm={"IF COL_LENGTH('movies','MOV_genre') IS NULL ALTER TABLE movies ADD MOV_genre NVARCHAR(50) NULL","IF COL_LENGTH('movies','MOV_year') IS NULL ALTER TABLE movies ADD MOV_year INT NULL","IF COL_LENGTH('movies','MOV_duration') IS NULL ALTER TABLE movies ADD MOV_duration INT NULL","IF COL_LENGTH('movies','MOV_price') IS NULL ALTER TABLE movies ADD MOV_price DECIMAL(10,2) NULL","IF COL_LENGTH('movies','MOV_description') IS NULL ALTER TABLE movies ADD MOV_description NVARCHAR(500) NULL"};
 foreach(var s in stm) Exec(conn,s);
 }
 private static void SeedGenres(SqlConnection conn)
 {
 Exec(conn,"IF NOT EXISTS(SELECT1 FROM genre) INSERT INTO genre (GEN_code,GEN_name) VALUES ('ACT','Action'),('COM','Comedy'),('DRA','Drama'),('SCI','Sci-Fi'),('HOR','Horror'),('ROM','Romance')");
 }
 private static void SeedMovies(SqlConnection conn)
 {
 int count = Convert.ToInt32(Scalar(conn,"SELECT COUNT(*) FROM movies"));
 if(count>=50) return;
 // Base + extended list (subset up to58 codes same as Initialize page)
 string[] sqls={
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M001') INSERT INTO movies VALUES ('M001','The Matrix','ACT',1999,136,12.99,'Hacker discovers reality is a simulation.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M002') INSERT INTO movies VALUES ('M002','Toy Story','COM',1995,81,9.99,'Toys come alive confronting jealousy and change.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M003') INSERT INTO movies VALUES ('M003','Titanic','ROM',1997,195,14.99,'Epic romance unfolds aboard doomed liner.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M004') INSERT INTO movies VALUES ('M004','Avatar','SCI',2009,162,15.00,'Marine bonds with alien world to save tribe.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M005') INSERT INTO movies VALUES ('M005','The Avengers','ACT',2012,143,13.99,'Heroes unite to stop global destruction.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M006') INSERT INTO movies VALUES ('M006','Finding Nemo','COM',2003,100,10.99,'Clownfish crosses ocean to rescue his son.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M007') INSERT INTO movies VALUES ('M007','The Dark Knight','ACT',2008,152,12.99,'Vigilante faces anarchic mastermind Joker.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M008') INSERT INTO movies VALUES ('M008','Frozen','COM',2013,102,11.99,'Sisters navigate magic, isolation and love.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M009') INSERT INTO movies VALUES ('M009','Inception','SCI',2010,148,14.99,'Mind-bending heist inside layered dreams.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M010') INSERT INTO movies VALUES ('M010','Interstellar','SCI',2014,169,14.99,'Father journeys into space pursuing hope for Earth.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M011') INSERT INTO movies VALUES ('M011','Gladiator','ACT',2000,155,13.99,'Roman general seeks vengeance in the arena.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M012') INSERT INTO movies VALUES ('M012','The Godfather','DRA',1972,175,12.99,'Crime family patriarch passes legacy to reluctant son.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M013') INSERT INTO movies VALUES ('M013','Jurassic Park','SCI',1993,127,11.99,'Dinosaurs run amok in a theme park.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M014') INSERT INTO movies VALUES ('M014','Pulp Fiction','DRA',1994,154,12.99,'Intersecting crime stories with dark humor.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M015') INSERT INTO movies VALUES ('M015','The Shawshank Redemption','DRA',1994,142,13.99,'Innocent man finds hope and freedom in prison.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M016') INSERT INTO movies VALUES ('M016','The Lion King','COM',1994,89,10.99,'Exiled lion prince returns to reclaim throne.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M017') INSERT INTO movies VALUES ('M017','Back to the Future','SCI',1985,116,11.99,'Teen travels back in time to ensure parents meet.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M018') INSERT INTO movies VALUES ('M018','Aliens','SCI',1986,137,12.99,'Ripley battles xenomorphs with colonial marines.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M019') INSERT INTO movies VALUES ('M019','Die Hard','ACT',1988,132,11.99,'Cop fights terrorists in a skyscraper.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M020') INSERT INTO movies VALUES ('M020','Terminator2: Judgment Day','ACT',1991,137,12.99,'Reprogrammed cyborg protects future leader.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M021') INSERT INTO movies VALUES ('M021','Braveheart','ACT',1995,178,13.99,'Scottish warrior leads rebellion for freedom.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M022') INSERT INTO movies VALUES ('M022','Forrest Gump','DRA',1994,142,12.99,'Simple man influences decades of history.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M023') INSERT INTO movies VALUES ('M023','The Silence of the Lambs','HOR',1991,118,12.99,'Agent seeks serial killer with cannibal genius.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M024') INSERT INTO movies VALUES ('M024','The Sixth Sense','HOR',1999,107,11.99,'Boy sees spirits; therapist seeks redemption.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M025') INSERT INTO movies VALUES ('M025','The Ring','HOR',2002,115,10.99,'Journalist investigates cursed videotape.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M026') INSERT INTO movies VALUES ('M026','Get Out','HOR',2017,104,13.99,'Visit to girlfriend''s family hides dark secret.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M027') INSERT INTO movies VALUES ('M027','A Quiet Place','HOR',2018,90,12.99,'Family survives monsters by living in silence.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M028') INSERT INTO movies VALUES ('M028','The Notebook','ROM',2004,123,11.99,'Young couple endures class and memory struggles.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M029') INSERT INTO movies VALUES ('M029','La La Land','ROM',2016,128,13.99,'Dreamers chase love and careers in Los Angeles.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M030') INSERT INTO movies VALUES ('M030','The Fault in Our Stars','ROM',2014,126,11.99,'Two teens with illness find profound love.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M031') INSERT INTO movies VALUES ('M031','Crazy Rich Asians','ROM',2018,120,12.99,'Professor meets boyfriend''s ultra-wealthy family.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M032') INSERT INTO movies VALUES ('M032','Parasite','DRA',2019,132,14.99,'Struggling family infiltrates wealthy household.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M033') INSERT INTO movies VALUES ('M033','Whiplash','DRA',2014,107,12.99,'Drummer pushed to limits by ruthless mentor.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M034') INSERT INTO movies VALUES ('M034','The Social Network','DRA',2010,120,11.99,'Founding of social empire breeds betrayal.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M035') INSERT INTO movies VALUES ('M035','Mad Max: Fury Road','ACT',2015,120,14.99,'Post-apocalyptic chase for freedom and hope.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M036') INSERT INTO movies VALUES ('M036','Guardians of the Galaxy','ACT',2014,121,13.99,'Misfit crew protects powerful cosmic artifact.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M037') INSERT INTO movies VALUES ('M037','Doctor Strange','SCI',2016,115,13.99,'Surgeon learns mystic arts to defend reality.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M038') INSERT INTO movies VALUES ('M038','Blade Runner2049','SCI',2017,164,14.99,'Replicant detective uncovers hidden child.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M039') INSERT INTO movies VALUES ('M039','Edge of Tomorrow','SCI',2014,113,12.99,'Soldier relives battle to defeat aliens.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M040') INSERT INTO movies VALUES ('M040','Spider-Man: Homecoming','ACT',2017,133,13.99,'Teen hero balances school and villain threat.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M041') INSERT INTO movies VALUES ('M041','Black Panther','ACT',2018,134,14.99,'King defends nation against internal rival.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M042') INSERT INTO movies VALUES ('M042','Shrek','COM',2001,90,9.99,'Ogre rescues princess challenging fairy tale norms.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M043') INSERT INTO movies VALUES ('M043','The Hangover','COM',2009,100,10.99,'Friends retrace wild night to find groom.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M044') INSERT INTO movies VALUES ('M044','Superbad','COM',2007,113,10.99,'High-school seniors seek epic party success.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M045') INSERT INTO movies VALUES ('M045','Step Brothers','COM',2008,98,9.99,'Middle-aged men become feuding step siblings.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M046') INSERT INTO movies VALUES ('M046','Jumanji: Welcome to the Jungle','ACT',2017,119,12.99,'Teens trapped in game avatars survive jungle.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M047') INSERT INTO movies VALUES ('M047','Pacific Rim','SCI',2013,131,12.99,'Pilots use giant mechs against sea monsters.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M048') INSERT INTO movies VALUES ('M048','The Prestige','DRA',2006,130,12.99,'Rival magicians obsess over ultimate trick.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M049') INSERT INTO movies VALUES ('M049','The Departed','DRA',2006,151,13.99,'Undercover cop and mole hunt each other.')",
 "IF NOT EXISTS(SELECT1 FROM movies WHERE MOV_code='M050') INSERT INTO movies VALUES ('M050','Casino Royale','ACT',2006,144,13.99,'Agent earns00 status facing high-stakes villain.')",
 };
 foreach(var s in sqls) Exec(conn,s);
 }
 private static object Scalar(SqlConnection conn,string sql){ using(var cmd=new SqlCommand(sql,conn)){ return cmd.ExecuteScalar(); } }
 private static void Exec(SqlConnection conn,string sql){ using(var cmd=new SqlCommand(sql,conn)){ cmd.ExecuteNonQuery(); } }
}
