using Abp.AspNetCore.Mvc.Controllers;
using Abp.IdentityFramework;
using Microsoft.AspNetCore.Identity;

namespace  2380600021_PhamTranHoangAn.Controllers
{
    public abstract class  2380600021_PhamTranHoangAnControllerBase : AbpController
    {
        protected  2380600021_PhamTranHoangAnControllerBase()
        {
            LocalizationSourceName =  2380600021_PhamTranHoangAnConsts.LocalizationSourceName;
        }

        protected void CheckErrors(IdentityResult identityResult)
        {
            identityResult.CheckErrors(LocalizationManager);
        }
    }
}
