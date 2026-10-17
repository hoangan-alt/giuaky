using Abp.Application.Services;
using  2380600021_PhamTranHoangAn.MultiTenancy.Dto;

namespace  2380600021_PhamTranHoangAn.MultiTenancy;

public interface ITenantAppService : IAsyncCrudAppService<TenantDto, int, PagedTenantResultRequestDto, CreateTenantDto, TenantDto>
{
}

