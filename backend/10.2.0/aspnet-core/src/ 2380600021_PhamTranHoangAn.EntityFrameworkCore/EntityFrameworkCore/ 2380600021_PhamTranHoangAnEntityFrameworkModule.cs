using Abp.EntityFrameworkCore.Configuration;
using Abp.Modules;
using Abp.Reflection.Extensions;
using Abp.Zero.EntityFrameworkCore;
using  2380600021_PhamTranHoangAn.EntityFrameworkCore.Seed;

namespace  2380600021_PhamTranHoangAn.EntityFrameworkCore;

[DependsOn(
    typeof( 2380600021_PhamTranHoangAnCoreModule),
    typeof(AbpZeroCoreEntityFrameworkCoreModule))]
public class  2380600021_PhamTranHoangAnEntityFrameworkModule : AbpModule
{
    /* Used it tests to skip dbcontext registration, in order to use in-memory database of EF Core */
    public bool SkipDbContextRegistration { get; set; }

    public bool SkipDbSeed { get; set; }

    public override void PreInitialize()
    {
        if (!SkipDbContextRegistration)
        {
            Configuration.Modules.AbpEfCore().AddDbContext< 2380600021_PhamTranHoangAnDbContext>(options =>
            {
                if (options.ExistingConnection != null)
                {
                     2380600021_PhamTranHoangAnDbContextConfigurer.Configure(options.DbContextOptions, options.ExistingConnection);
                }
                else
                {
                     2380600021_PhamTranHoangAnDbContextConfigurer.Configure(options.DbContextOptions, options.ConnectionString);
                }
            });
        }
    }

    public override void Initialize()
    {
        IocManager.RegisterAssemblyByConvention(typeof( 2380600021_PhamTranHoangAnEntityFrameworkModule).GetAssembly());
    }

    public override void PostInitialize()
    {
        if (!SkipDbSeed)
        {
            SeedHelper.SeedHostDb(IocManager);
        }
    }
}
