using Abp.Localization;
using System.Collections.Generic;

namespace  2380600021_PhamTranHoangAn.Web.Views.Shared.Components.RightNavbarLanguageSwitch;

public class RightNavbarLanguageSwitchViewModel
{
    public LanguageInfo CurrentLanguage { get; set; }

    public IReadOnlyList<LanguageInfo> Languages { get; set; }
}
