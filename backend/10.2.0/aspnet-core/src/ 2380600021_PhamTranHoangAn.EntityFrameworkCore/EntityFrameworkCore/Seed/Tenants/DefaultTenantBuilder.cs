using Abp.MultiTenancy;
using  2380600021_PhamTranHoangAn.Editions;
using  2380600021_PhamTranHoangAn.MultiTenancy;
using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace  2380600021_PhamTranHoangAn.EntityFrameworkCore.Seed.Tenants;

public class DefaultTenantBuilder
{
    private readonly  2380600021_PhamTranHoangAnDbContext _context;

    public DefaultTenantBuilder( 2380600021_PhamTranHoangAnDbContext context)
    {
        _context = context;
    }

    public void Create()
    {
        CreateDefaultTenant();
    }

    private void CreateDefaultTenant()
    {
        // Default tenant

        var defaultTenant = _context.Tenants.IgnoreQueryFilters().FirstOrDefault(t => t.TenancyName == AbpTenantBase.DefaultTenantName);
        if (defaultTenant == null)
        {
            defaultTenant = new Tenant(AbpTenantBase.DefaultTenantName, AbpTenantBase.DefaultTenantName);

            var defaultEdition = _context.Editions.IgnoreQueryFilters().FirstOrDefault(e => e.Name == EditionManager.DefaultEditionName);
            if (defaultEdition != null)
            {
                defaultTenant.EditionId = defaultEdition.Id;
            }

            _context.Tenants.Add(defaultTenant);
            _context.SaveChanges();
        }
    }
}
