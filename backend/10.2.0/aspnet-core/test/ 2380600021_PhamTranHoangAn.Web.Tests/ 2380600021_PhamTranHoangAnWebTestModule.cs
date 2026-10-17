using Abp.AspNetCore;
using Abp.AspNetCore.TestBase;
using Abp.Modules;
using Abp.Reflection.Extensions;
using  2380600021_PhamTranHoangAn.EntityFrameworkCore;
using  2380600021_PhamTranHoangAn.Web.Startup;
using Microsoft.AspNetCore.Mvc.ApplicationParts;

namespace  2380600021_PhamTranHoangAn.Web.Tests;

[DependsOn(
    typeof( 2380600021_PhamTranHoangAnWebMvcModule),
    typeof(AbpAspNetCoreTestBaseModule)
)]
public class  2380600021_PhamTranHoangAnWebTestModule : AbpModule
{
    public  2380600021_PhamTranHoangAnWebTestModule( 2380600021_PhamTranHoangAnEntityFrameworkModule abpProjectNameEntityFrameworkModule)
    {
        abpProjectNameEntityFrameworkModule.SkipDbContextRegistration = true;
    }

    public override void PreInitialize()
    {
        Configuration.UnitOfWork.IsTransactional = false; //EF Core InMemory DB does not support transactions.
    }

    public override void Initialize()
    {
        IocManager.RegisterAssemblyByConvention(typeof( 2380600021_PhamTranHoangAnWebTestModule).GetAssembly());
    }

    public override void PostInitialize()
    {
        IocManager.Resolve<ApplicationPartManager>()
            .AddApplicationPartsIfNotAddedBefore(typeof( 2380600021_PhamTranHoangAnWebMvcModule).Assembly);
    }
}