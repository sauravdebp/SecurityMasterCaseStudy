using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

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
    }
}