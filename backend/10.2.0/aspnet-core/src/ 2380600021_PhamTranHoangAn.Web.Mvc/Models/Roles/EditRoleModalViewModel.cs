using Abp.AutoMapper;
using  2380600021_PhamTranHoangAn.Roles.Dto;
using  2380600021_PhamTranHoangAn.Web.Models.Common;

namespace  2380600021_PhamTranHoangAn.Web.Models.Roles;

[AutoMapFrom(typeof(GetRoleForEditOutput))]
public class EditRoleModalViewModel : GetRoleForEditOutput, IPermissionsEditViewModel
{
    public bool HasPermission(FlatPermissionDto permission)
    {
        return GrantedPermissionNames.Contains(permission.Name);
    }
}
