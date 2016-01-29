using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.IO;
using System.Xml.Serialization;
using SecMaster_DAL.DataModel;
using System.Xml;
using System.Web;
using System.Web.Script.Serialization;

namespace SecMaster_DAL
{
    public class DAL
    {
        private readonly SqlConnection conn = new SqlConnection(@"Data Source=ADMIN-PC;Initial Catalog=SecurityMaster;Integrated Security=True;");
        //private readonly SqlConnection conn = new SqlConnection(@"Data Source=saurav-pc\sqlexpress;Initial Catalog=SecurityMaster;Integrated Security=True");
        //SqlCommand command;
        //SqlDataAdapter dataAdapt;

        private DAL() { }

        private static DAL dbInstance;
        public static DAL DbInstance
        {
            get
            {
                if (dbInstance == null)
                {
                    dbInstance = new DAL();
                }
                return dbInstance;
            }
        }

        //public static DAL getDbInstance()
        //{
        //    if (dbInstance == null)
        //    {
        //        dbInstance = new DAL();
        //    }
        //    return dbInstance;
        //}

        //string CreateXML(List<Security> _equityObject)
        //{
        //    XmlDocument xmlDoc = new XmlDocument();
        //    XmlSerializer xmlSerializer = new XmlSerializer(_equityObject.GetType(), new Type[] { typeof(Security) });
        //    using (MemoryStream xmlStream = new MemoryStream())
        //    {
        //        xmlSerializer.Serialize(xmlStream, _equityObject);
        //        xmlStream.Position = 0;
        //        xmlDoc.Load(xmlStream);
        //        return xmlDoc.InnerXml;
        //    }
        //}

        SqlConnection OpenConnection()
        {
            conn.Open();
            return conn;
        }

        void CloseConnection()
        {
            conn.Close();
        }

        public DataSet ExecuteSqlQuery(string query)
        {
            OpenConnection();
            SqlDataAdapter da = new SqlDataAdapter(query, conn);
            DataSet ds = new DataSet();
            da.Fill(ds);
            CloseConnection();
            return ds;
        }

        public void ExecuteSqlProc(string procName, Dictionary<string, string> procParams)
        {
            OpenConnection();
            SqlCommand cmd = new SqlCommand(procName, conn);
            cmd.CommandType = CommandType.StoredProcedure;
            foreach (var param in procParams)
            {
                cmd.Parameters.AddWithValue(param.Key, param.Value);
            }
            cmd.ExecuteNonQuery();
            CloseConnection();
        }

        public DataSet ExecuteSqlProc_getResult(string procName, Dictionary<string, string> procParams)
        {
            OpenConnection();
            SqlCommand cmd = new SqlCommand(procName, conn);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            cmd.CommandType = CommandType.StoredProcedure;
            foreach (var param in procParams)
            {
                cmd.Parameters.AddWithValue(param.Key, param.Value);
            }
            da.Fill(ds);
            CloseConnection();
            return ds;
        }

        //public void InsertSecurity(List<Security> securityList)
        //{
        //    string xml = CreateXML(securityList);
        //    command = new SqlCommand();

        //    command.Connection = conn;
        //    command.CommandType = CommandType.StoredProcedure;
        //    command.CommandText = "CreateSecurity";
        //    command.Parameters.AddWithValue("@xml", SqlDbType.Xml).Value = xml;
        //    command.Parameters.AddWithValue("@securityTypeName", SqlDbType.VarChar).Value = securityList[0].GetType().Name;
        //    command.ExecuteNonQuery();
        //}

        //public void UpdateSecurity(List<Security> securityList)
        //{
        //    string xml = CreateXML(securityList);
        //    command = new SqlCommand();
        //    command.Connection = conn;
        //    command.CommandType = CommandType.StoredProcedure;
        //    command.CommandText = "UpdateSecurity";
        //    command.Parameters.AddWithValue("@xml", SqlDbType.Xml).Value = xml;
        //    command.Parameters.AddWithValue("@securityTypeName", SqlDbType.VarChar).Value = securityList[0].GetType().Name;
        //    command.ExecuteNonQuery();

        //}

        //public void DeleteSecurity(Security securityObject)
        //{

        //    command = new SqlCommand();
        //    command.Connection = conn;
        //    command.CommandType = CommandType.StoredProcedure;
        //    command.CommandText = "DeleteSecurity";
        //    command.Parameters.AddWithValue("@securityTypeName", SqlDbType.VarChar).Value = securityObject.GetType().Name;
        //    command.Parameters.AddWithValue("@securityId", SqlDbType.VarChar).Value = securityObject.SecurityId;
        //    command.ExecuteNonQuery();

        //}
        
        //public string SelectSecurity(Security securityObject)
        //{
        //    command = new SqlCommand();
        //    dataAdapt = new SqlDataAdapter();
        //    command.Connection = conn;
        //    command.CommandType = CommandType.StoredProcedure;
        //    command.CommandText = "SelectSecurity";
        //    command.Parameters.AddWithValue("@securityTypeName", SqlDbType.VarChar).Value = securityObject.GetType().Name;
        //    command.Parameters.AddWithValue("@securityId", SqlDbType.VarChar).Value = securityObject.SecurityId;
        //    dataAdapt.SelectCommand = command;
        //    DataTable dataTable = new DataTable();
        //    dataAdapt.Fill(dataTable);
        //   string json= ConvertToJson(dataTable, securityObject);
        //    return json;
        //}

        //public string ConvertToJson(DataTable datatable, Security securityObject)
        //{
        //    command = new SqlCommand();
        //    dataAdapt = new SqlDataAdapter();
        //    command.Connection = conn;
        //    command.CommandType = CommandType.StoredProcedure;
        //    command.CommandText = "GetTabAttributes";
        //    command.Parameters.AddWithValue("@securityTypeName", SqlDbType.VarChar).Value = securityObject.GetType().Name;
        //    dataAdapt.SelectCommand = command;
        //    DataTable dataTable = new DataTable();
        //    dataAdapt.Fill(dataTable);
        //    Dictionary<string, List<JsonDataAttributes>> dict = new Dictionary<string, List<JsonDataAttributes>>();
        //    foreach(DataRow row in dataTable.Rows)
        //    {
        //        string tabName=(string)row["TabName"];
        //        if (!dict.ContainsKey(tabName))
        //        {
        //            dict.Add(tabName, new List<JsonDataAttributes>());
        //        }
        //        dict[tabName].Add(new JsonDataAttributes()
        //        {
        //            AttributeDisplayName = (string)row["AttributeDisplayName"],
        //            AttributeRealName = (string)row["AttributeRealName"],
        //            AttributeValue = datatable.Rows[0][(string)row["AttributeRealName"]]
        //        });
        //    }

        //    JavaScriptSerializer serializer = new JavaScriptSerializer(); //creating serializer instance of JavaScriptSerializer class
        //    string json = serializer.Serialize((object)dict);
        //    return json;
        //}


        //public Dictionary<string, string> GetAtrributeMappings(string securityClassName)
        //{
        //    OpenConnection();
        //    Dictionary<string, string> attributeMapping = new Dictionary<string, string>();
        //    command = new SqlCommand();
        //    SqlDataAdapter adapt = new SqlDataAdapter(command);
        //    DataTable result = new DataTable();
        //    command.Connection = conn;
        //    command.CommandType = CommandType.StoredProcedure;
        //    command.CommandText = "GetSecurityAttributes";
        //    command.Parameters.AddWithValue("@securityTypeName", SqlDbType.VarChar).Value = securityClassName;
        //    adapt.Fill(result);
        //    foreach (DataRow row in result.Rows)
        //    {
        //        attributeMapping.Add((string)row["AttributeDisplayName"], (string)row["AttributeRealName"]);
        //    }
        //    result.Dispose();
        //    adapt.Dispose();
        //    CloseConnection();
        //    return attributeMapping;
        //}
    }
}