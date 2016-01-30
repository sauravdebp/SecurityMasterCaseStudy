using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Data;
using System.Web.Script.Serialization;
using System.Reflection;

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

        //public static Security CreateSecurityFromJSON(string json)
        //{
            
        //}

        public static Security SelectSecurityAsObject(int securityId, Type securityType)
        {
            //DataSet ds = SelectSecurityAsDataSet(securityId, securityType);
            //List<PropertyInfo> properties = new List<PropertyInfo>();
            //properties.AddRange(securityType.BaseType.GetProperties());
            //properties.AddRange(securityType.GetProperties());
            //foreach(PropertyInfo property in properties)
            //{

            //}
            return null;
        }

        public static Json_Tabs SelectSecurityAsJSON(int securityId, Type securityType)
        {
            DataSet securityDs = SelectSecurityAsDataSet(securityId, securityType);
            int secRows = securityDs.Tables[0].Rows.Count;
            DataSet tabAttributes = SecurityAttribute.GetTabAttributes(securityType);

            Dictionary<string, List<Json_TabAttribute>> dict = new Dictionary<string, List<Json_TabAttribute>>();
            Json_Tabs tabs = new Json_Tabs();
            foreach(DataRow row in tabAttributes.Tables[0].Rows)
            {
                string tabName = (string)row["TabName"];
                if(!dict.ContainsKey(tabName))
                {
                    dict.Add(tabName, new List<Json_TabAttribute>());
                }
                dict[tabName].Add(new Json_TabAttribute()
                {
                    AttributeDisplayName = (string)row["AttributeDisplayName"],
                    AttributeRealName = (string)row["AttributeRealName"],
                    AttributeValue = secRows == 1 ? securityDs.Tables[0].Rows[0][(string)row["AttributeRealName"]].ToString() : null
                });
            }

            foreach(var tabAtts in dict)
            {
                tabs.TabList.Add(new Json_Tab() { TabName = tabAtts.Key, Attributes=tabAtts.Value });
            }
            tabs.SecurityTypeName = securityType.Name;
            //JavaScriptSerializer serializer = new JavaScriptSerializer();
            //return serializer.Serialize(dict);
            //return dict;
            return tabs;
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