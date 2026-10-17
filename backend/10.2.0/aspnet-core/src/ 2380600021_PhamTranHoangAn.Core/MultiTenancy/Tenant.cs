using Abp.MultiTenancy;
using  2380600021_PhamTranHoangAn.Authorization.Users;

namespace  2380600021_PhamTranHoangAn.MultiTenancy;

public class Tenant : AbpTenant<User>
{
    public Tenant()
    {
    }

    public Tenant(string tenancyName, string name)
        : base(tenancyName, name)
    {
    }
}
