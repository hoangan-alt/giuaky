using Abp.Zero.EntityFrameworkCore;
using  2380600021_PhamTranHoangAn.Authorization.Roles;
using  2380600021_PhamTranHoangAn.Authorization.Users;
using  2380600021_PhamTranHoangAn.MultiTenancy;
using Microsoft.EntityFrameworkCore;

namespace  2380600021_PhamTranHoangAn.EntityFrameworkCore;

public class  2380600021_PhamTranHoangAnDbContext : AbpZeroDbContext<Tenant, Role, User,  2380600021_PhamTranHoangAnDbContext>
{
    /* Define a DbSet for each entity of the application */

    public  2380600021_PhamTranHoangAnDbContext(DbContextOptions< 2380600021_PhamTranHoangAnDbContext> options)
        : base(options)
    {
    }
}
