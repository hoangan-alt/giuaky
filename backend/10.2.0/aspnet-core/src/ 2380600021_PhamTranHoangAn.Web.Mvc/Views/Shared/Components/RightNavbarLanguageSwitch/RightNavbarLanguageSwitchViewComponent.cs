using Abp.Localization;
using Microsoft.AspNetCore.Mvc;
using System.Linq;

namespace  2380600021_PhamTranHoangAn.Web.Views.Shared.Components.RightNavbarLanguageSwitch;

public class RightNavbarLanguageSwitchViewComponent :  2380600021_PhamTranHoangAnViewComponent
{
    private readonly ILanguageManager _languageManager;

    public RightNavbarLanguageSwitchViewComponent(ILanguageManager languageManager)
    {
        _languageManager = languageManager;
    }

    public IViewComponentResult Invoke()
    {
        var model = new RightNavbarLanguageSwitchViewModel
        {
            CurrentLanguage = _languageManager.CurrentLanguage,
            Languages = _languageManager.GetLanguages().Where(l => !l.IsDisabled).ToList()
        };

        return View(model);
    }
}
