using Abp.AspNetCore.Mvc.Views;
using Abp.Runtime.Session;
using Microsoft.AspNetCore.Mvc.Razor.Internal;

namespace  2380600021_PhamTranHoangAn.Web.Views;

public abstract class  2380600021_PhamTranHoangAnRazorPage<TModel> : AbpRazorPage<TModel>
{
    [RazorInject]
    public IAbpSession AbpSession { get; set; }

    protected  2380600021_PhamTranHoangAnRazorPage()
    {
        LocalizationSourceName =  2380600021_PhamTranHoangAnConsts.LocalizationSourceName;
    }
}
