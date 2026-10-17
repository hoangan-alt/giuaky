using Abp.Dependency;
using System;

namespace  2380600021_PhamTranHoangAn.Timing;

public class AppTimes : ISingletonDependency
{
    /// <summary>
    /// Gets the startup time of the application.
    /// </summary>
    public DateTime StartupTime { get; set; }
}
