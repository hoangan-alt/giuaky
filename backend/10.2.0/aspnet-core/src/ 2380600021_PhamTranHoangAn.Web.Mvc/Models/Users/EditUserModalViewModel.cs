using  2380600021_PhamTranHoangAn.Roles.Dto;
using  2380600021_PhamTranHoangAn.Users.Dto;
using System.Collections.Generic;
using System.Linq;

namespace  2380600021_PhamTranHoangAn.Web.Models.Users;

public class EditUserModalViewModel
{
    public UserDto User { get; set; }

    public IReadOnlyList<RoleDto> Roles { get; set; }

    public bool UserIsInRole(RoleDto role)
    {
        return User.RoleNames != null && User.RoleNames.Any(r => r == role.NormalizedName);
    }
}
