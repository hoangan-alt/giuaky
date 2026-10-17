using  2380600021_PhamTranHoangAn.Authorization;
using  2380600021_PhamTranHoangAn.Authorization.Roles;
using  2380600021_PhamTranHoangAn.Authorization.Users;
using  2380600021_PhamTranHoangAn.Editions;
using  2380600021_PhamTranHoangAn.MultiTenancy;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;

namespace  2380600021_PhamTranHoangAn.Identity;

public static class IdentityRegistrar
{
    public static IdentityBuilder Register(IServiceCollection services)
    {
        services.AddLogging();

        return services.AddAbpIdentity<Tenant, User, Role>()
            .AddAbpTenantManager<TenantManager>()
            .AddAbpUserManager<UserManager>()
            .AddAbpRoleManager<RoleManager>()
            .AddAbpEditionManager<EditionManager>()
            .AddAbpUserStore<UserStore>()
            .AddAbpRoleStore<RoleStore>()
            .AddAbpLogInManager<LogInManager>()
            .AddAbpSignInManager<SignInManager>()
            .AddAbpSecurityStampValidator<SecurityStampValidator>()
            .AddAbpUserClaimsPrincipalFactory<UserClaimsPrincipalFactory>()
            .AddPermissionChecker<PermissionChecker>()
            .AddDefaultTokenProviders();
    }
}
