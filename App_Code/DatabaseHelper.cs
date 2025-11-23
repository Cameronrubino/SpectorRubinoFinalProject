using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public static class DatabaseHelper
{
 public static string ConnectionString
 {
 get { return ConfigurationManager.ConnectionStrings["MoviesDB"].ConnectionString; }
 }

 public static SqlConnection GetConnection()
 {
 AutoSeed.EnsureSeed();
 return new SqlConnection(ConnectionString);
 }

 public static bool TableExists(string tableName, SqlConnection conn)
 {
 using (var cmd = new SqlCommand("SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME=@t", conn))
 {
 cmd.Parameters.AddWithValue("@t", tableName);
 return cmd.ExecuteScalar() != null;
 }
 }

 // Ensure extended movie columns exist (can be called before queries)
 public static void EnsureMovieColumns(SqlConnection conn)
 {
 if (!TableExists("movies", conn)) return; // nothing to do
 string[] columnDefs = {
 "MOV_genre NVARCHAR(50) NULL",
 "MOV_year INT NULL",
 "MOV_duration INT NULL",
 "MOV_price DECIMAL(10,2) NULL",
 "MOV_description NVARCHAR(500) NULL"
 };
 foreach (var def in columnDefs)
 {
 string name = def.Split(' ')[0];
 using (var cmd = new SqlCommand(@"IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='movies' AND COLUMN_NAME=@c) BEGIN ALTER TABLE movies ADD " + def + " END", conn))
 {
 cmd.Parameters.AddWithValue("@c", name);
 cmd.ExecuteNonQuery();
 }
 }
 }

 public static object ExecuteScalar(string sql, params SqlParameter[] parameters)
 {
 using (var conn = GetConnection())
 using (var cmd = new SqlCommand(sql, conn))
 {
 if (parameters != null && parameters.Length >0)
 cmd.Parameters.AddRange(parameters);
 conn.Open();
 return cmd.ExecuteScalar();
 }
 }

 public static int ExecuteNonQuery(string sql, params SqlParameter[] parameters)
 {
 using (var conn = GetConnection())
 using (var cmd = new SqlCommand(sql, conn))
 {
 if (parameters != null && parameters.Length >0)
 cmd.Parameters.AddRange(parameters);
 conn.Open();
 return cmd.ExecuteNonQuery();
 }
 }

 public static DataTable ExecuteDataTable(string sql, params SqlParameter[] parameters)
 {
 using (var conn = GetConnection())
 using (var cmd = new SqlCommand(sql, conn))
 {
 if (parameters != null && parameters.Length >0)
 cmd.Parameters.AddRange(parameters);
 using (var da = new SqlDataAdapter(cmd))
 {
 var dt = new DataTable();
 da.Fill(dt);
 return dt;
 }
 }
 }

 public static SqlDataReader ExecuteReader(string sql, params SqlParameter[] parameters)
 {
 var conn = GetConnection();
 var cmd = new SqlCommand(sql, conn);
 if (parameters != null && parameters.Length >0)
 cmd.Parameters.AddRange(parameters);
 conn.Open();
 return cmd.ExecuteReader(CommandBehavior.CloseConnection);
 }

 public static SqlParameter Param(string name, object value)
 {
 return new SqlParameter(name, value ?? DBNull.Value);
 }
}
