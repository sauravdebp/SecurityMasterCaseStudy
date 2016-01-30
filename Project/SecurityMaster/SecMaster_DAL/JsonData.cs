using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SecMaster_DAL.DataModel;

namespace SecMaster_DAL
{
    public class Json_Tabs
    {
        public string SecurityTypeName { get; set; }
        public List<Json_Tab> TabList { get; set; }
        public Json_Tabs()
        {
            TabList = new List<Json_Tab>();
        }
        public Security ConvertToSecurityObject()
        {
            Security secObj = null;
            if(SecurityTypeName == typeof(Equity).Name)
            {
                secObj = new Equity();
            }
            else if(SecurityTypeName == typeof(CorporateBond).Name)
            {
                secObj = new CorporateBond();
            }
            foreach(var tab in TabList)
            {
                foreach(var att in tab.Attributes)
                {
                    secObj.GetType().GetProperty(att.AttributeRealName).SetValue(secObj, att.AttributeValue, null);
                }
            }
            return secObj;
        }
    }

    public class Json_Tab
    {
        public string TabName { get; set; }
        public List<Json_TabAttribute> Attributes { get; set; }
        public Json_Tab()
        {
            Attributes = new List<Json_TabAttribute>();
        }
    }

    public class Json_TabAttribute
    {
        public string AttributeDisplayName { get; set; }
        public string AttributeRealName { get; set; }
        public string AttributeValue { get; set; }
        public string AttributeType { get; set; }
    }
}
