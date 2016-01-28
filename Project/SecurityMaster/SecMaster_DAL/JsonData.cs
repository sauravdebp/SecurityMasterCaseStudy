using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SecMaster_DAL
{
    class JsonData
    {
        public List<JsonDataTab> Tabs { get; set; }
        public JsonData()
        {
            Tabs = new List<JsonDataTab>();
        }
    }

    class JsonDataTab
    {
        public string TabName { get; set; }
        public List<JsonDataAttributes> Attributes { get; set; }
        public JsonDataTab()
        {
            Attributes = new List<JsonDataAttributes>();
        }
    }

    class JsonDataAttributes
    {
        public string AttributeDisplayName { get; set; }
        public string AttributeRealName { get; set; }
        public string AttributeValue { get; set; }
        public string AttributeType { get; set; }
    }
}
