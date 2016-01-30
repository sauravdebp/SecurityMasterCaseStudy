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
            Console.WriteLine("STARTING....");
            //SecurityReader.SecurityReader reader = new SecurityReader.SecurityReader();
            //List<Security> securities = reader.ReadSecuritiesFromFile(@"C:\Users\saura_000\Downloads\Equities.xlsx");
            //SecurityCollection securities = reader.ReadSecuritiesFromFile(@"C:\Users\saura_000\Desktop\SecMaster\Equities.xlsx");
            //securities.PersistCollection();
            //lib.OpenConnection();
            //lib.InsertSecurity(securities);
            //lib.CloseConnection();
            //lib.SelectSecurity(new Equity() { SecurityId = 1 });
            var tabs = Security.SelectSecurityAsJSON(1, typeof(Equity));
            Console.WriteLine("DONE");
            Console.ReadKey();
        }
    }
}
