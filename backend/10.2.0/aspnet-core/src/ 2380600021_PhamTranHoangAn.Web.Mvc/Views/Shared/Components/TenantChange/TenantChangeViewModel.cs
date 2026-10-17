using Abp.AutoMapper;
using  2380600021_PhamTranHoangAn.Sessions.Dto;

namespace  2380600021_PhamTranHoangAn.Web.Views.Shared.Components.TenantChange;

[AutoMapFrom(typeof(GetCurrentLoginInformationsOutput))]
public class TenantChangeViewModel
{
    public TenantLoginInfoDto Tenant { get; set; }
}
