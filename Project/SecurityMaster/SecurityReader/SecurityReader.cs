using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SecMaster_DAL.DataModel;
using SecMaster_DAL;

namespace SecurityReader
{
    public class SecurityReader
    {
        FileReader reader;

        public SecurityReader()
        {

        }

        public List<Security> ReadSecuritiesFromFile(string filePath)
        {
            List<Security> securities = new List<Security>();
            string securityName = Path.GetFileNameWithoutExtension(filePath);
            Dictionary<string, List<Dictionary<string, string>>> securitiesData = new Dictionary<string, List<Dictionary<string, string>>>();
            if(File.Exists(filePath))
            {
                InstantiateReader(Path.GetExtension(filePath));
                reader.OpenFile(filePath);
                if (reader.GetType() == typeof(ExcelReader))
                    (reader as ExcelReader).SheetName = securityName;
                securitiesData = reader.ReadFile();
                reader.CloseFile();

                //Convert the complex dictionary to a list of security objects
                Dictionary<string, string> attributeMapping = DAL.getDbInstance().GetAtrributeMappings(GetSecurityObject(securityName).GetType().Name);
                foreach (var securityRow in securitiesData[securityName])
                {
                    securities.Add(FillSecurityObject(GetSecurityObject(securityName), securityRow, attributeMapping));
                }
            }
            
            return securities;
        }

        Security FillSecurityObject(Security security, Dictionary<string, string> securityRow, Dictionary<string, string> attributeMapping)
        {
            foreach (var key in securityRow.Keys)
            {
                if (attributeMapping.Keys.Contains(key) && securityRow[key] != string.Empty)
                {
                    Type propertyType = security.GetType().GetProperty(attributeMapping[key]).PropertyType;
                    //TODO: Find a way to convert the date strings from excel into SqlDateTime properly. Below statement is temporarily placed to avoid using the Date attributes.
                    if (propertyType == typeof(SqlDateTime))
                        continue;
                    security.GetType().GetProperty(attributeMapping[key]).SetValue(
                        security,
                        Convert.ChangeType(securityRow[key], propertyType),
                        null
                    );
                }
            }
            return security;
        }

        FileReader InstantiateReader(string fileExtension)
        {
            switch(fileExtension)
            {
                case ".csv":
                    reader = new CsvReader();
                    break;
                case ".xls":
                case ".xlsx":
                    reader = new ExcelReader();
                    break;
            }
            return reader;
        }

        Security GetSecurityObject(string securityName)
        {
            Security security = null;
            switch(securityName)
            {
                case "Equities":
                    security = new Equity();
                    break;
                case "Bonds":
                    security = new CorporateBond();
                    break;
            }
            return security;
        }
    }
}
