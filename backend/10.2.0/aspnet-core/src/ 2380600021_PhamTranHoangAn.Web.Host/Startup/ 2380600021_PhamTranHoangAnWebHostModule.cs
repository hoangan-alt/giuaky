using Abp.Modules;
using Abp.Reflection.Extensions;
using  2380600021_PhamTranHoangAn.Configuration;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;

namespace  2380600021_PhamTranHoangAn.Web.Host.Startup
{
    [DependsOn(
       typeof( 2380600021_PhamTranHoangAnWebCoreModule))]
    public class  2380600021_PhamTranHoangAnWebHostModule : AbpModule
    {
        private readonly IWebHostEnvironment _env;
        private readonly IConfigurationRoot _appConfiguration;

        public  2380600021_PhamTranHoangAnWebHostModule(IWebHostEnvironment env)
        {
            _env = env;
            _appConfiguration = env.GetAppConfiguration();
        }

        public override void Initialize()
        {
            IocManager.RegisterAssemblyByConvention(typeof( 2380600021_PhamTranHoangAnWebHostModule).GetAssembly());
        }
    }
}
