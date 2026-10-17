using  2380600021_PhamTranHoangAn.Roles.Dto;
using System.Collections.Generic;

namespace  2380600021_PhamTranHoangAn.Web.Models.Users;

public class UserListViewModel
{
    public IReadOnlyList<RoleDto> Roles { get; set; }
}
