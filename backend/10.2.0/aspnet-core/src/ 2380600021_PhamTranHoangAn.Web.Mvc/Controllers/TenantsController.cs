using Abp.Application.Services.Dto;
using Abp.AspNetCore.Mvc.Authorization;
using  2380600021_PhamTranHoangAn.Authorization;
using  2380600021_PhamTranHoangAn.Controllers;
using  2380600021_PhamTranHoangAn.MultiTenancy;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace  2380600021_PhamTranHoangAn.Web.Controllers;

[AbpMvcAuthorize(PermissionNames.Pages_Tenants)]
public class TenantsController :  2380600021_PhamTranHoangAnControllerBase
{
    private readonly ITenantAppService _tenantAppService;

    public TenantsController(ITenantAppService tenantAppService)
    {
        _tenantAppService = tenantAppService;
    }

    public ActionResult Index() => View();

    public async Task<ActionResult> EditModal(int tenantId)
    {
        var tenantDto = await _tenantAppService.GetAsync(new EntityDto(tenantId));
        return PartialView("_EditModal", tenantDto);
    }
}
