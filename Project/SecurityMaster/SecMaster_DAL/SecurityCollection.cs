using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.IO;
using System.Data;

namespace SecMaster_DAL.DataModel
{
    public class SecurityCollection
    {
        List<Security> securitiesList = new List<Security>();
        public List<Security> SecuritiesList { get { return securitiesList; } }

        //public Security this[int index] { get { return securitiesList[index]; } }

        public void Add(Security security)
        {
            SecuritiesList.Add(security);
        }

        public void PersistCollection(bool isUpdate = false)
        {
            string xml = ConvertSecuritiesListToXML();
            Dictionary<string, string> paramsList = new Dictionary<string, string>();
            paramsList.Add("@xml", xml);
            paramsList.Add("@securityTypeName", SecuritiesList[0].GetType().Name);
            string procName = "CreateSecurity";
            if (isUpdate)
                procName = "UpdateSecurity";
            DAL.DbInstance.ExecuteSqlProc(procName, paramsList);
        }

        string ConvertSecuritiesListToXML()
        {
            XmlDocument xmlDoc = new XmlDocument();
            XmlSerializer xmlSerializer = new XmlSerializer(SecuritiesList.GetType(), new Type[] { typeof(Security) });
            using (MemoryStream xmlStream = new MemoryStream())
            {
                xmlSerializer.Serialize(xmlStream, SecuritiesList);
                xmlStream.Position = 0;
                xmlDoc.Load(xmlStream);
                return xmlDoc.InnerXml;
            }
        }

        public static SecurityCollection GetSecuritiesByName(string secName, Type securityType)
        {
            SecurityCollection matchingSecs = new SecurityCollection();
            string query = string.Format("SELECT SecurityId, Name FROM {0} WHERE Name LIKE '%{1}%'", securityType.Name, secName);
            DataTable result = DAL.DbInstance.ExecuteSqlQuery(query).Tables[0];
            foreach(DataRow row in result.Rows)
            {
                matchingSecs.Add(new Security()
                {
                    Name = (string)row["Name"],
                    SecurityId = Convert.ToInt32(row["SecurityId"])
                });
            }
            return matchingSecs;
        }
    }
}
