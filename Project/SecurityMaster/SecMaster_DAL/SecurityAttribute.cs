using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlTypes;
using System.Linq;
using System.Text;

namespace SecMaster_DAL.DataModel
{
    public class SecurityAttribute
    {
        //public int AttributeId { get; set; }
        //public int SecurityTypeId { get; set; }
        //public string AttributeDisplayName { get; set; }
        //public string AttributeRealName { get; set; }
        //public string TabName { get; set; }
        //public string AttributeDataType { get; set; }
        //public string AttributeLength { get; set; }
        //public string LastModifiedBy { get; set; }
        //public SqlDateTime LastModifiedOn { get; set; }
        //public string CreatedBy { get; set; }
        //public SqlDateTime CreatedOn { get; set; }
        //public bool IsActive { get; set; }

        public static DataSet GetTabAttributes(Type securityType)
        {
            Dictionary<string, string> paramsList = new Dictionary<string, string>();
            paramsList.Add("@securityTypeName", securityType.Name);
            string procName = "GetTabAttributes";
            return DAL.DbInstance.ExecuteSqlProc_getResult(procName, paramsList);
        }

        public static Dictionary<string, string> GetAttributeMappings(Type securityType)
        {
            Dictionary<string, string> attributeMappings = new Dictionary<string, string>();
            Dictionary<string, string> procParams = new Dictionary<string, string>();
            procParams.Add("@securityTypeName", securityType.Name);
            DataTable result = DAL.DbInstance.ExecuteSqlProc_getResult("GetSecurityAttributes", procParams).Tables[0];
            foreach(DataRow row in result.Rows)
            {
                attributeMappings.Add((string)row["AttributeDisplayName"], (string)row["AttributeRealName"]);
            }
            result.Dispose();
            return attributeMappings;
        }
    }
}
