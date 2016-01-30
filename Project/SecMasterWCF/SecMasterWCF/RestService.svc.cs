using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.ServiceModel.Configuration;
using System.ServiceModel.Description;
using System.ServiceModel.Dispatcher;
using System.Text;
using SecMaster_DAL.DataModel;
using SecMaster_DAL;

namespace SecMasterWCF
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "RestService" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select RestService.svc or RestService.svc.cs at the Solution Explorer and start debugging.
    public class RestService : IRestService
    {
        public string AddSecurity(Json_Tabs json)
        {
            try
            {
                Security newSecurity = json.ConvertToSecurityObject();
                SecurityCollection securities = new SecurityCollection();
                securities.Add(newSecurity);
                securities.PersistCollection();
            }
            catch(Exception ex)
            {
                return ex.Message;
            }
            return "true";
        }

        public Json_Tabs CreateSecurity(string secType)
        {
            Type securityType = null;
            if (secType == typeof(Equity).Name)
                securityType = typeof(Equity);
            else if (secType == typeof(CorporateBond).Name)
                securityType = typeof(CorporateBond);
            var tabs = Security.SelectSecurityAsJSON(0, securityType);
            return tabs;
        }

        public string UpdateSecurity(Json_Tabs json)
        {
            try
            {
                Security newSecurity = json.ConvertToSecurityObject();
                SecurityCollection securities = new SecurityCollection();
                securities.Add(newSecurity);
                securities.PersistCollection(true);
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            return "true";
        }

        public Json_Tabs ViewSecurity(string secType, string secId)
        {
            Type securityType = null;
            if (secType == typeof(Equity).Name)
                securityType = typeof(Equity);
            else if (secType == typeof(CorporateBond).Name)
                securityType = typeof(CorporateBond);
            int securityId = Convert.ToInt32(secId);
            var tabs = Security.SelectSecurityAsJSON(securityId, securityType);
            return tabs;
        }
    }
}
