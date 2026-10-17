using Abp.Events.Bus;
using Abp.Modules;
using Abp.Reflection.Extensions;
using  2380600021_PhamTranHoangAn.Configuration;
using  2380600021_PhamTranHoangAn.EntityFrameworkCore;
using  2380600021_PhamTranHoangAn.Migrator.DependencyInjection;
using Castle.MicroKernel.Registration;
using Microsoft.Extensions.Configuration;

namespace  2380600021_PhamTranHoangAn.Migrator;

[DependsOn(typeof( 2380600021_PhamTranHoangAnEntityFrameworkModule))]
public class  2380600021_PhamTranHoangAnMigratorModule : AbpModule
{
    private readonly IConfigurationRoot _appConfiguration;

    public  2380600021_PhamTranHoangAnMigratorModule( 2380600021_PhamTranHoangAnEntityFrameworkModule abpProjectNameEntityFrameworkModule)
    {
        abpProjectNameEntityFrameworkModule.SkipDbSeed = true;

        _appConfiguration = AppConfigurations.Get(
            typeof( 2380600021_PhamTranHoangAnMigratorModule).GetAssembly().GetDirectoryPathOrNull()
        );
    }

    public override void PreInitialize()
    {
        Configuration.DefaultNameOrConnectionString = _appConfiguration.GetConnectionString(
             2380600021_PhamTranHoangAnConsts.ConnectionStringName
        );

        Configuration.BackgroundJobs.IsJobExecutionEnabled = false;
        Configuration.ReplaceService(
            typeof(IEventBus),
            () => IocManager.IocContainer.Register(
                Component.For<IEventBus>().Instance(NullEventBus.Instance)
            )
        );
    }

    public override void Initialize()
    {
        IocManager.RegisterAssemblyByConvention(typeof( 2380600021_PhamTranHoangAnMigratorModule).GetAssembly());
        ServiceCollectionRegistrar.Register(IocManager);
    }
}
