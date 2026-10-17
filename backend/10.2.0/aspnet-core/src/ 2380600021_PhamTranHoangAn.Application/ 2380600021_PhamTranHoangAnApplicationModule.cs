using Abp.AutoMapper;
using Abp.Modules;
using Abp.Reflection.Extensions;
using  2380600021_PhamTranHoangAn.Authorization;

namespace  2380600021_PhamTranHoangAn;

[DependsOn(
    typeof( 2380600021_PhamTranHoangAnCoreModule),
    typeof(AbpAutoMapperModule))]
public class  2380600021_PhamTranHoangAnApplicationModule : AbpModule
{
    public override void PreInitialize()
    {
        Configuration.Authorization.Providers.Add< 2380600021_PhamTranHoangAnAuthorizationProvider>();
    }

    public override void Initialize()
    {
        var thisAssembly = typeof( 2380600021_PhamTranHoangAnApplicationModule).GetAssembly();

        IocManager.RegisterAssemblyByConvention(thisAssembly);

        Configuration.Modules.AbpAutoMapper().Configurators.Add(
            // Scan the assembly for classes which inherit from AutoMapper.Profile
            cfg => cfg.AddMaps(thisAssembly)
        );
    }
}
