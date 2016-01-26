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
        String ConnectionString;
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

        public void OpenConnection(String connectionstring)
        {
            conn = new SqlConnection();
            ConnectionString = connectionstring;
            conn.ConnectionString = ConnectionString;
            conn.Open();
        }

        public void CloseConnection()
        {
            conn.Close();
        }

        public Boolean InsertSecurity(List<Security> securityList)
        {
            string xml = CreateXML(securityList);
            command = new SqlCommand();
            command.Connection = conn;
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "CreateSecurity";
            command.Parameters.AddWithValue("@xml", SqlDbType.Xml).Value = xml;
            command.Parameters.AddWithValue("@securityTypeId", SqlDbType.VarChar).Value = securityList[0].GetType();//equityObject[0].SecurityId;
            command.ExecuteNonQuery();
            return true;
        }

        public Boolean UpdateSecurity(List<Security> securityList)
        {
            string xml = CreateXML(securityList);
            command = new SqlCommand();
            command.Connection = conn;
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "UpdateSecurity";
            command.Parameters.AddWithValue("@xml", SqlDbType.Xml).Value = xml;
            command.Parameters.AddWithValue("@securityTypeId", SqlDbType.VarChar).Value = securityList[0].GetType();
            command.ExecuteNonQuery();
            return true;
        }

        public Boolean DeleteSecurity(Security securityObject)
        {
           
            command = new SqlCommand();
            command.Connection = conn;
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "DeleteSecurity";
            command.Parameters.AddWithValue("@securityTypeId", SqlDbType.VarChar).Value = securityObject.GetType();
            command.Parameters.AddWithValue("@securityId", SqlDbType.VarChar).Value = securityObject.SecurityId;     
            command.ExecuteNonQuery();
            return true;
        }
    }
}