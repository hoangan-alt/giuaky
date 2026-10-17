using Abp.Application.Navigation;
using Abp.Runtime.Session;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace  2380600021_PhamTranHoangAn.Web.Views.Shared.Components.SideBarMenu;

public class SideBarMenuViewComponent :  2380600021_PhamTranHoangAnViewComponent
{
    private readonly IUserNavigationManager _userNavigationManager;
    private readonly IAbpSession _abpSession;

    public SideBarMenuViewComponent(
        IUserNavigationManager userNavigationManager,
        IAbpSession abpSession)
    {
        _userNavigationManager = userNavigationManager;
        _abpSession = abpSession;
    }

    public async Task<IViewComponentResult> InvokeAsync()
    {
        var model = new SideBarMenuViewModel
        {
            MainMenu = await _userNavigationManager.GetMenuAsync("MainMenu", _abpSession.ToUserIdentifier())
        };

        return View(model);
    }
}
