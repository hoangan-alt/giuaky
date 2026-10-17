using  2380600021_PhamTranHoangAn.Roles.Dto;
using System.Collections.Generic;

namespace  2380600021_PhamTranHoangAn.Web.Models.Roles;

public class RoleListViewModel
{
    public IReadOnlyList<PermissionDto> Permissions { get; set; }
}
