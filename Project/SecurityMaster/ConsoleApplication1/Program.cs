using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SecMaster_DAL.DataModel;
using SecMaster_DAL;
using System.Xml;
using System.IO;
using System.Xml.Serialization;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            DAL lib = DAL.getDbInstance();
            Console.WriteLine("STARTING....");

            SecurityReader.SecurityReader reader = new SecurityReader.SecurityReader();
            //List<Security> securities = reader.ReadSecuritiesFromFile(@"C:\Users\saura_000\Downloads\Equities.xlsx");
            List<Security> securities = reader.ReadSecuritiesFromFile(@"C:\Users\admin\Desktop\SecMaster\Equities.xlsx");

            lib.OpenConnection();
            lib.InsertSecurity(securities);
            lib.CloseConnection();

            Console.WriteLine("DONE");
            Console.ReadKey();
        }
    }
}
