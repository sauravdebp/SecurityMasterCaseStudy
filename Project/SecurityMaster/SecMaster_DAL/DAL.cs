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

namespace SecMaster_DAL
{
    public class DAL
    {
        private static DAL dbInstance;
        private readonly SqlConnection conn = new SqlConnection(@"Data Source=ADMIN-PC;Initial Catalog=SecurityMaster;Integrated Security=True;");
        SqlCommand command;
        StringBuilder json;
        SqlDataAdapter dataAdapt;

        private DAL() { }

        public static DAL getDbInstance()
        {
            if (dbInstance == null)
            {
                dbInstance = new DAL();
            }
            return dbInstance;
        }


        string CreateXML(List<Security> _equityObject)
        {
            XmlDocument xmlDoc = new XmlDocument();
            XmlSerializer xmlSerializer = new XmlSerializer(_equityObject.GetType(), new Type[] { typeof(Security) });
            using (MemoryStream xmlStream = new MemoryStream())
            {
                xmlSerializer.Serialize(xmlStream, _equityObject);
                xmlStream.Position = 0;
                xmlDoc.Load(xmlStream);
                return xmlDoc.InnerXml;
            }
        }

        public SqlConnection OpenConnection()
        {
            conn.Open();
            return conn;
        }


        public void CloseConnection()
        {
            conn.Close();
        }

        public void InsertSecurity(List<Security> securityList)
        {
            string xml = CreateXML(securityList);
            command = new SqlCommand();

            command.Connection = conn;
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "CreateSecurity";
            command.Parameters.AddWithValue("@xml", SqlDbType.Xml).Value = xml;
            command.Parameters.AddWithValue("@securityTypeName", SqlDbType.VarChar).Value = securityList[0].GetType().Name;
            command.ExecuteNonQuery();
        }

        public void UpdateSecurity(List<Security> securityList)
        {
            string xml = CreateXML(securityList);
            command = new SqlCommand();
            command.Connection = conn;
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "UpdateSecurity";
            command.Parameters.AddWithValue("@xml", SqlDbType.Xml).Value = xml;
            command.Parameters.AddWithValue("@securityTypeName", SqlDbType.VarChar).Value = securityList[0].GetType().Name;
            command.ExecuteNonQuery();

        }

        public void DeleteSecurity(Security securityObject)
        {

            command = new SqlCommand();
            command.Connection = conn;
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "DeleteSecurity";
            command.Parameters.AddWithValue("@securityTypeName", SqlDbType.VarChar).Value = securityObject.GetType().Name;
            command.Parameters.AddWithValue("@securityId", SqlDbType.VarChar).Value = securityObject.SecurityId;
            command.ExecuteNonQuery();

        }


        public string SelectSecurity(Security securityObject)
        {

            command = new SqlCommand();
            dataAdapt = new SqlDataAdapter();
            command.Connection = conn;
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "SelectSecurity";
            command.Parameters.AddWithValue("@securityTypeName", SqlDbType.VarChar).Value = securityObject.GetType().Name;
            command.Parameters.AddWithValue("@securityId", SqlDbType.VarChar).Value = securityObject.SecurityId;
            dataAdapt.SelectCommand = command;
            DataTable dataTable = new DataTable();
            dataAdapt.Fill(dataTable);
            string json = ConvertToJson(dataTable, securityObject);

        }

        public string ConvertToJson(DataTable datatable, Security securityObject)
        {
            command = new SqlCommand();
            dataAdapt = new SqlDataAdapter();
            command.Connection = conn;
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "GetTabAttributes";
            command.Parameters.AddWithValue("@securityTypeName", SqlDbType.VarChar).Value = securityObject.GetType().Name;
            dataAdapt.SelectCommand = command;
            DataTable dataTable = new DataTable();
            dataAdapt.Fill(dataTable);
            //Dictionary<string, List<JsonDataAttributes>> dict = new Dictionary<string, List<JsonDataAttributes>>();
            JsonData data=new JsonData();
            foreach(DataRow row in dataTable.Rows)
            {
                string tabName=(string)row["TabName"];
                data.Tabs.Add(new JsonDataTab()
                {
                    TabName = tabName
                });

            }
        }


        public Dictionary<string, string> GetAtrributeMappings(string securityClassName)
        {
            OpenConnection();
            Dictionary<string, string> attributeMapping = new Dictionary<string, string>();
            command = new SqlCommand();
            SqlDataAdapter adapt = new SqlDataAdapter(command);
            DataTable result = new DataTable();
            command.Connection = conn;
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "GetSecurityAttributes";
            command.Parameters.AddWithValue("@securityTypeName", SqlDbType.VarChar).Value = securityClassName;
            adapt.Fill(result);
            foreach (DataRow row in result.Rows)
            {
                attributeMapping.Add((string)row["AttributeDisplayName"], (string)row["AttributeRealName"]);
            }
            result.Dispose();
            adapt.Dispose();
            CloseConnection();
            return attributeMapping;
        }
    }
}