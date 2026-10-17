using Abp.AspNetCore.Mvc.Authorization;
using  2380600021_PhamTranHoangAn.Controllers;
using Microsoft.AspNetCore.Mvc;

namespace  2380600021_PhamTranHoangAn.Web.Controllers;

[AbpMvcAuthorize]
public class HomeController :  2380600021_PhamTranHoangAnControllerBase
{
    public ActionResult Index()
    {
        return View();
    }
}
