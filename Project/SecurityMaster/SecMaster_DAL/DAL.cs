using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.IO;
using System.Xml.Serialization;
using SecMaster_DAL.DataModel;
using System.Xml;
using System.Web;
using System.Web.Script.Serialization;

namespace SecMaster_DAL
{
    public class DAL
    {
        //private readonly SqlConnection conn = new SqlConnection(@"Data Source=ADMIN-PC;Initial Catalog=SecurityMaster;Integrated Security=True;");
        private readonly SqlConnection conn = new SqlConnection(@"Data Source=saurav-pc\sqlexpress;Initial Catalog=SecurityMaster;Integrated Security=True");

        DAL() { }

        static DAL dbInstance;
        public static DAL DbInstance
        {
            get
            {
                if (dbInstance == null)
                {
                    dbInstance = new DAL();
                }
                return dbInstance;
            }
        }

        void OpenConnection()
        {
            conn.Open();
        }

        void CloseConnection()
        {
            conn.Close();
        }

        public DataSet ExecuteSqlQuery(string query)
        {
            OpenConnection();
            SqlDataAdapter da = new SqlDataAdapter(query, conn);
            DataSet ds = new DataSet();
            try
            {
                da.Fill(ds);
            }
            finally
            {
                CloseConnection();
            }
            return ds;
        }

        public void ExecuteSqlProc(string procName, Dictionary<string, string> procParams)
        {
            OpenConnection();
            SqlCommand cmd = new SqlCommand(procName, conn);
            try
            {
                cmd.CommandType = CommandType.StoredProcedure;
                foreach (var param in procParams)
                {
                    cmd.Parameters.AddWithValue(param.Key, param.Value);
                }
                cmd.ExecuteNonQuery();
            }
            finally
            {
                CloseConnection();
            }
        }

        public DataSet ExecuteSqlProc_getResult(string procName, Dictionary<string, string> procParams)
        {
            OpenConnection();
            SqlCommand cmd = new SqlCommand(procName, conn);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            try
            {
                cmd.CommandType = CommandType.StoredProcedure;
                foreach (var param in procParams)
                {
                    cmd.Parameters.AddWithValue(param.Key, param.Value);
                }
                da.Fill(ds);
            }
            finally
            {
                CloseConnection();
            }
            return ds;
        }
    }
}