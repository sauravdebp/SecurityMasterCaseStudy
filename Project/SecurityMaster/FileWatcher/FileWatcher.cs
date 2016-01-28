using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using SecMaster_DAL.DataModel;
using SecMaster_DAL;

namespace FileWatcher
{
    class FileWatcher
    {
        FileSystemWatcher watcher;
        SecurityReader.SecurityReader reader = new SecurityReader.SecurityReader();

        public string MonitorDirectory
        {
            get { return watcher != null ? watcher.Path : null; }
        }

        public string FileFilter
        {
            get { return watcher != null ? watcher.Filter : null; }
        }

        public FileWatcher()
        {

        }

        public FileWatcher(string monitorDirectory, string fileFilter)
        {
            watcher = new FileSystemWatcher(monitorDirectory, fileFilter);
            SetFileWatcherFilters();
            AddFileWatcherEventHandlers();
        }

        public void StartFileWatcher()
        {
            if (watcher != null)
                watcher.EnableRaisingEvents = true;
        }

        public void StopFileWatcher()
        {
            if (watcher == null)
                return;
            watcher.EnableRaisingEvents = false;
            watcher.Created -= File_Created;
            watcher.Changed -= File_Changed;
            watcher.Error -= File_Error;
        }

        void AddFileWatcherEventHandlers()
        {
            if (watcher == null)
                return;
            watcher.Created += File_Created;
            watcher.Changed += File_Changed;
            watcher.Error += File_Error;
        }

        void SetFileWatcherFilters()
        {
            if (watcher == null)
                return;
            watcher.NotifyFilter = 
                //NotifyFilters.Attributes |
                NotifyFilters.CreationTime |
                NotifyFilters.DirectoryName |
                NotifyFilters.FileName |
                NotifyFilters.LastWrite |
                NotifyFilters.Size;
        }

        private void File_Error(object sender, ErrorEventArgs e)
        {
            WriteToLog("Some error occurred");
        }

        private void File_Changed(object sender, FileSystemEventArgs e)
        {
            //WriteToLog(e.FullPath + " File Changed");
        }

        private void File_Created(object sender, FileSystemEventArgs e)
        {
            WriteToLog("New file found : " + e.FullPath);
            try
            {
                List<Security> securities = reader.ReadSecuritiesFromFile(e.FullPath);
                DAL dalLib = DAL.getDbInstance();
                dalLib.OpenConnection();
                dalLib.InsertSecurity(securities);
                dalLib.CloseConnection();
                WriteToLog(e.FullPath + " read into database successfully");
            }
            catch (Exception ex)
            {
                WriteToLog("Error!! " + ex.Message);
            }
        }

        public void WriteToLog(string message)
        {
            StreamWriter sw = null;
            try
            {
                sw = new StreamWriter(AppDomain.CurrentDomain.BaseDirectory + "\\LogFile.txt", true);
                sw.WriteLine(DateTime.Now.ToString() + ": " + message);
                sw.Flush();
                sw.Close();
            }
            catch
            {

            }
        }
    }
}
