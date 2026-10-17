using Abp.Application.Features;
using Abp.Domain.Repositories;
using Abp.Domain.Uow;
using Abp.MultiTenancy;
using Abp.Runtime.Caching;
using  2380600021_PhamTranHoangAn.Authorization.Users;
using  2380600021_PhamTranHoangAn.MultiTenancy;

namespace  2380600021_PhamTranHoangAn.Features;

public class FeatureValueStore : AbpFeatureValueStore<Tenant, User>
{
    public FeatureValueStore(
        ICacheManager cacheManager,
        IRepository<TenantFeatureSetting, long> tenantFeatureRepository,
        IRepository<Tenant> tenantRepository,
        IRepository<EditionFeatureSetting, long> editionFeatureRepository,
        IFeatureManager featureManager,
        IUnitOfWorkManager unitOfWorkManager)
        : base(
              cacheManager,
              tenantFeatureRepository,
              tenantRepository,
              editionFeatureRepository,
              featureManager,
              unitOfWorkManager)
    {
    }
}
