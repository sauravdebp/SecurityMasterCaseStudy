using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Timers;

namespace FileWatcher
{
    public partial class Service1 : ServiceBase
    {
        //FileWatcher watcher = new FileWatcher(@"C:\Users\admin\Desktop\SecMaster", "*.*");
        FileWatcher watcher = new FileWatcher(@"C:\Users\saura_000\Desktop\SecMaster", "*.*");

        public Service1()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            watcher.StartFileWatcher();
            watcher.WriteToLog("File Watcher Service Started");
        }

        protected override void OnStop()
        {
            if (watcher != null)
                watcher.StopFileWatcher();
            watcher.WriteToLog("File Watcher Service stopped");
        }
    }
}
