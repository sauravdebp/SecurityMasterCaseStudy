using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using SecMaster_DAL.DataModel;

namespace SecurityReader
{
    public class ExcelReader : FileReader
    {
        string connectionString;
        OleDbDataAdapter adapter;
        DataTable data;
        public string SheetName { get; set; }

        public override Dictionary<string, List<Dictionary<string, string>>> ReadFile()
        {
            int maxRowsToRead = 10;
            //Limiting the number of rows read. For some reason the following query rows reads 16383 rows(unless TOP specified) even though the excel file contains less than that number of entries
            adapter = new OleDbDataAdapter("SELECT TOP " + maxRowsToRead +" * FROM [" + SheetName + "$]", connectionString);
            data = new DataTable(SheetName);
            adapter.Fill(data);
            Dictionary<string, List<Dictionary<string, string>>> dataDict = new Dictionary<string, List<Dictionary<string, string>>>();
            dataDict.Add(SheetName, new List<Dictionary<string, string>>());
            foreach(DataRow row in data.Rows)
            {
                dataDict[SheetName].Add(new Dictionary<string, string>());
                foreach(DataColumn col in data.Columns)
                {
                    dataDict[SheetName].Last().Add(col.ColumnName, row[col].ToString());
                }
            }

            data.Dispose();
            return dataDict;
        }

        public override bool OpenFile(string filePath)
        {
            connectionString = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties = \"Excel 12.0 Xml;HDR=YES\"; ", filePath);
            return true;
        }

        public override bool CloseFile()
        {
            adapter.Dispose();
            return true;
        }


        //Below function is to generate an INSERT query for filling up the SecurityAttributes Table. This was created temporarily only.
        //Params: row - Any row from the excel file
        //public void FillAttributes_temp(Dictionary<string, string> row)
        //{
        //    SqlConnection conn = new SqlConnection(@"Data Source=saurav-pc\sqlexpress;Initial Catalog=SecurityMaster;Integrated Security=True");
        //    string sqlQuery = "INSERT INTO [dbo].[SecurityAttributes] ([AttributeDisplayName],[AttributeRealName]) VALUES ";
        //    int index = 0;
        //    List<PropertyInfo> properties = new List<PropertyInfo>();
        //    properties.AddRange(typeof(Security).GetProperties());
        //    //properties.AddRange(typeof(Equity).GetProperties());
        //    properties.AddRange(typeof(CorporateBond).GetProperties());

        //    foreach (var col in row)
        //    {
        //        if (col.Key == "Attribute Name")
        //            continue;
        //        sqlQuery += "('" + col.Key + "', '" + properties[index++].Name + "'),";
        //    }
        //}
    }
}
