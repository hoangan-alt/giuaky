using Abp.Localization;
using Abp.Modules;
using Abp.Reflection.Extensions;
using Abp.Runtime.Security;
using Abp.Timing;
using Abp.Zero;
using Abp.Zero.Configuration;
using  2380600021_PhamTranHoangAn.Authorization.Roles;
using  2380600021_PhamTranHoangAn.Authorization.Users;
using  2380600021_PhamTranHoangAn.Configuration;
using  2380600021_PhamTranHoangAn.Localization;
using  2380600021_PhamTranHoangAn.MultiTenancy;
using  2380600021_PhamTranHoangAn.Timing;

namespace  2380600021_PhamTranHoangAn;

[DependsOn(typeof(AbpZeroCoreModule))]
public class  2380600021_PhamTranHoangAnCoreModule : AbpModule
{
    public override void PreInitialize()
    {
        Configuration.Auditing.IsEnabledForAnonymousUsers = true;

        // Declare entity types
        Configuration.Modules.Zero().EntityTypes.Tenant = typeof(Tenant);
        Configuration.Modules.Zero().EntityTypes.Role = typeof(Role);
        Configuration.Modules.Zero().EntityTypes.User = typeof(User);

         2380600021_PhamTranHoangAnLocalizationConfigurer.Configure(Configuration.Localization);

        // Enable this line to create a multi-tenant application.
        Configuration.MultiTenancy.IsEnabled =  2380600021_PhamTranHoangAnConsts.MultiTenancyEnabled;

        // Configure roles
        AppRoleConfig.Configure(Configuration.Modules.Zero().RoleManagement);

        Configuration.Settings.Providers.Add<AppSettingProvider>();

        Configuration.Localization.Languages.Add(new LanguageInfo("fa", "فارسی", "famfamfam-flags ir"));

        Configuration.Settings.SettingEncryptionConfiguration.DefaultPassPhrase =  2380600021_PhamTranHoangAnConsts.DefaultPassPhrase;
        SimpleStringCipher.DefaultPassPhrase =  2380600021_PhamTranHoangAnConsts.DefaultPassPhrase;
    }

    public override void Initialize()
    {
        IocManager.RegisterAssemblyByConvention(typeof( 2380600021_PhamTranHoangAnCoreModule).GetAssembly());
    }

    public override void PostInitialize()
    {
        IocManager.Resolve<AppTimes>().StartupTime = Clock.Now;
    }
}
