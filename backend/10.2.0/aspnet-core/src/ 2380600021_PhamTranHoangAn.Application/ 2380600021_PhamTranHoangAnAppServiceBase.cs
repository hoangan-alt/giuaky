using Abp.Application.Services;
using Abp.IdentityFramework;
using Abp.Runtime.Session;
using  2380600021_PhamTranHoangAn.Authorization.Users;
using  2380600021_PhamTranHoangAn.MultiTenancy;
using Microsoft.AspNetCore.Identity;
using System;
using System.Threading.Tasks;

namespace  2380600021_PhamTranHoangAn;

/// <summary>
/// Derive your application services from this class.
/// </summary>
public abstract class  2380600021_PhamTranHoangAnAppServiceBase : ApplicationService
{
    public TenantManager TenantManager { get; set; }

    public UserManager UserManager { get; set; }

    protected  2380600021_PhamTranHoangAnAppServiceBase()
    {
        LocalizationSourceName =  2380600021_PhamTranHoangAnConsts.LocalizationSourceName;
    }

    protected virtual async Task<User> GetCurrentUserAsync()
    {
        var user = await UserManager.FindByIdAsync(AbpSession.GetUserId().ToString());
        if (user == null)
        {
            throw new Exception("There is no current user!");
        }

        return user;
    }

    protected virtual Task<Tenant> GetCurrentTenantAsync()
    {
        return TenantManager.GetByIdAsync(AbpSession.GetTenantId());
    }

    protected virtual void CheckErrors(IdentityResult identityResult)
    {
        identityResult.CheckErrors(LocalizationManager);
    }
}
