using Abp.Authorization;
using  2380600021_PhamTranHoangAn.Authorization.Roles;
using  2380600021_PhamTranHoangAn.Authorization.Users;

namespace  2380600021_PhamTranHoangAn.Authorization;

public class PermissionChecker : PermissionChecker<Role, User>
{
    public PermissionChecker(UserManager userManager)
        : base(userManager)
    {
    }
}
