using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileWatcherService
{
    class FileWatcher
    {
        FileSystemWatcher watcher;

        public string MonitorDirectory
        {
            get { return watcher != null ? watcher.Path : null; }
        }

        public string FileFilter
        {
            get { return watcher != null ? watcher.Filter : null; }
        }

        public void StopFileWatcher()
        {
            if (watcher == null)
                return;
            watcher.Created -= File_Created;
            watcher.Changed -= File_Changed;
            watcher.Error -= File_Error;
        }

        public FileWatcher(string monitorDirectory, string fileFilter)
        {
            watcher = new FileSystemWatcher(monitorDirectory, fileFilter);
            SetFileWatcherFilters();
            AddFileWatcherEventHandlers();
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
            watcher.NotifyFilter = NotifyFilters.Attributes |
                NotifyFilters.CreationTime |
                NotifyFilters.DirectoryName |
                NotifyFilters.FileName |
                NotifyFilters.LastWrite |
                NotifyFilters.Size;
        }

        private void File_Error(object sender, ErrorEventArgs e)
        {
            //throw new NotImplementedException();
            WriteToLog("Some error occurred");
        }

        private void File_Changed(object sender, FileSystemEventArgs e)
        {
            //throw new NotImplementedException();
            WriteToLog("File Changed");
        }

        private void File_Created(object sender, FileSystemEventArgs e)
        {
            //TODO: 
            //Check file name
            //If a valid file name send it to FileReader
            //Create security objects
            //Send to DAL directly or through WCF??
            WriteToLog("File Created");
        }

        void WriteToLog(string message)
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
