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

namespace SecMaster_DAL
{
    public class DAL
    {
        SqlConnection conn;
        const string ConnectionString = @"Data Source=saurav-pc\sqlexpress;Initial Catalog=SecurityMaster;Integrated Security=True";
        SqlCommand command;
    
        string CreateXML(List<Security> _equityObject)
        {    
            XmlDocument xmlDoc = new XmlDocument();            
            XmlSerializer xmlSerializer = new XmlSerializer(_equityObject.GetType(), new Type[]{typeof(Security)});
            using (MemoryStream xmlStream = new MemoryStream())
            { 
                xmlSerializer.Serialize(xmlStream, _equityObject);
                xmlStream.Position = 0;
                xmlDoc.Load(xmlStream);
                return xmlDoc.InnerXml;
            }
        }

        public void OpenConnection()
        {
            conn = new SqlConnection();
            conn.ConnectionString = ConnectionString;
            conn.Open();
        }

        public void CloseConnection()
        {
            conn.Close();
        }

        public bool InsertSecurity(List<Security> securityList)
        {
            string xml = CreateXML(securityList);
            command = new SqlCommand();
            command.Connection = conn;
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "CreateSecurity";
            command.Parameters.AddWithValue("@xml", SqlDbType.Xml).Value = xml;
            command.Parameters.AddWithValue("@securityTypeName", SqlDbType.VarChar).Value = securityList[0].GetType().Name;
            command.ExecuteNonQuery();
            return true;
        }

        public bool UpdateSecurity(List<Security> securityList)
        {
            string xml = CreateXML(securityList);
            command = new SqlCommand();
            command.Connection = conn;
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "UpdateSecurity";
            command.Parameters.AddWithValue("@xml", SqlDbType.Xml).Value = xml;
            command.Parameters.AddWithValue("@securityTypeName", SqlDbType.VarChar).Value = securityList[0].GetType().Name;
            command.ExecuteNonQuery();
            return true;
        }

        public bool DeleteSecurity(Security securityObject)
        {
           
            command = new SqlCommand();
            command.Connection = conn;
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "DeleteSecurity";
            command.Parameters.AddWithValue("@securityTypeName", SqlDbType.VarChar).Value = securityObject.GetType().Name;
            command.Parameters.AddWithValue("@securityId", SqlDbType.VarChar).Value = securityObject.SecurityId;     
            command.ExecuteNonQuery();
            return true;
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
            foreach(DataRow row in result.Rows)
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