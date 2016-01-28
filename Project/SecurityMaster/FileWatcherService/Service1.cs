using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;

namespace FileWatcherService
{
    public partial class Service1 : ServiceBase
    {
        //FileWatcher watcher;
        public Service1()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            //watcher = new FileWatcher(@"C:\Users\admin\Desktop", "*.xlsx");
        }

        protected override void OnStop()
        {
            //watcher.StopFileWatcher();
        }
    }
}
