using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using SecMaster_DAL;
using System.Text;

namespace SecMasterWCF
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IRestService" in both code and config file together.
    [ServiceContract]
    public interface IRestService
    {
        //[OperationContract]
        //[WebInvoke(UriTemplate = "TestMethod/{id}", 
        //    Method = "GET", 
        //    BodyStyle = WebMessageBodyStyle.Wrapped, 
        //    ResponseFormat = WebMessageFormat.Json)]
        //string TestMethod(string id);

        //[WebGet(UriTemplate = "Security", ResponseFormat = WebMessageFormat.Json)]
        //[OperationContract]
        //string GetAllSecurityDetails();

        [WebGet(UriTemplate = "CreateSecurity?secType={secType}", ResponseFormat = WebMessageFormat.Json)]
        [OperationContract]
        Json_Tabs CreateSecurity(string secType);

        [WebGet(UriTemplate = "ViewSecurity?secType={secType}&secId={secId}", ResponseFormat = WebMessageFormat.Json)]
        [OperationContract]
        Json_Tabs ViewSecurity(string secType, string secId);

        [WebInvoke(Method = "POST", UriTemplate = "AddSecurity", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        [OperationContract]
        void AddSecurity(string json);

        //[WebInvoke(Method = "PUT", UriTemplate = "EmployeePUT", ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        //[OperationContract]
        //void UpdateEmployee(Employee newEmp);

        //[WebInvoke(Method = "DELETE", UriTemplate = "Employee/{empId}", ResponseFormat = WebMessageFormat.Json)]
        //[OperationContract]
        //void DeleteEmployee(string empId);
    }

    [DataContract]
    public class CompositeType
    {
        bool boolValue = true;
        string stringValue = "Hello ";

        [DataMember]
        public bool BoolValue
        {
            get { return boolValue; }
            set { boolValue = value; }
        }

        [DataMember]
        public string StringValue
        {
            get { return stringValue; }
            set { stringValue = value; }
        }
    }
}
