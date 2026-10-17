using Abp.AspNetCore.Mvc.ViewComponents;

namespace  2380600021_PhamTranHoangAn.Web.Views;

public abstract class  2380600021_PhamTranHoangAnViewComponent : AbpViewComponent
{
    protected  2380600021_PhamTranHoangAnViewComponent()
    {
        LocalizationSourceName =  2380600021_PhamTranHoangAnConsts.LocalizationSourceName;
    }
}
