using Abp.Application.Services.Dto;
using Abp.AutoMapper;
using  2380600021_PhamTranHoangAn.MultiTenancy;

namespace  2380600021_PhamTranHoangAn.Sessions.Dto;

[AutoMapFrom(typeof(Tenant))]
public class TenantLoginInfoDto : EntityDto
{
    public string TenancyName { get; set; }

    public string Name { get; set; }
}
