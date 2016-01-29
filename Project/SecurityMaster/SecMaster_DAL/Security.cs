using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Data;

namespace SecMaster_DAL.DataModel
{
    [XmlInclude(typeof(Equity))]
    [XmlInclude(typeof(CorporateBond))]
    [Serializable]
    public class Security
    {
        [XmlElement(IsNullable = true)]
        public int? SecurityId { get; set; }
        [XmlElement(IsNullable = true)]
        public string Name { get; set; }
        [XmlElement(IsNullable = true)]
        public string Description { get; set; }

        public Security()
        {
            SecurityId = null;  //So that when XML is generated without providing value for security id it does not default to 0. This is to avoid PK conflicts.
        }

        public void DeleteSecurity()
        {
            Dictionary<string, string> paramsList = new Dictionary<string, string>();
            paramsList.Add("@securityId", SecurityId.ToString());
            paramsList.Add("@securityTypeName", this.GetType().Name);
            string procName = "DeleteSecurity";
            DAL.DbInstance.ExecuteSqlProc(procName, paramsList);
        }

        public static Security SelectSecurityAsObject(int securityId, Type securityType)
        {
            DataSet ds = SelectSecurityAsDataSet(securityId, securityType);
            return null;
        }

        //Rethink about the following function
        static DataSet GetTabAttributes(Type securityType)
        {
            Dictionary<string, string> paramsList = new Dictionary<string, string>();
            paramsList.Add("@securityTypeName", securityType.Name);
            string procName = "GetTabAttributes";
            return DAL.DbInstance.ExecuteSqlProc_getResult(procName, paramsList);
        }

        public static string SelectSecurityAsJSON(int securityId, Type securityType)
        {
            DataSet securityDs = SelectSecurityAsDataSet(securityId, securityType);
            DataSet tabAttributes = GetTabAttributes(securityType);

            Dictionary<string, List<JsonDataAttributes>> dict = new Dictionary<string, List<JsonDataAttributes>>();
            //Implement the foreach part

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

            return null;
        }

        static DataSet SelectSecurityAsDataSet(int securityId, Type securityType)
        {
            Dictionary<string, string> paramsList = new Dictionary<string, string>();
            paramsList.Add("@securityId", securityId.ToString());
            paramsList.Add("@securityTypeName", securityType.Name);
            string procName = "SelectSecurity";
            DAL.DbInstance.ExecuteSqlProc(procName, paramsList);
            DataSet ds = DAL.DbInstance.ExecuteSqlProc_getResult(procName, paramsList);
            return ds;
        }
    }
}