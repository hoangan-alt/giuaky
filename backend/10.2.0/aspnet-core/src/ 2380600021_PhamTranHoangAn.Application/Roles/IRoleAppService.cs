using Abp.Application.Services;
using Abp.Application.Services.Dto;
using  2380600021_PhamTranHoangAn.Roles.Dto;
using System.Threading.Tasks;

namespace  2380600021_PhamTranHoangAn.Roles;

public interface IRoleAppService : IAsyncCrudAppService<RoleDto, int, PagedRoleResultRequestDto, CreateRoleDto, RoleDto>
{
    Task<ListResultDto<PermissionDto>> GetAllPermissions();

    Task<GetRoleForEditOutput> GetRoleForEdit(EntityDto input);

    Task<ListResultDto<RoleListDto>> GetRolesAsync(GetRolesInput input);
}
