using Abp.Configuration;
using Abp.Localization;
using Abp.MultiTenancy;
using Abp.Net.Mail;
using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace  2380600021_PhamTranHoangAn.EntityFrameworkCore.Seed.Host;

public class DefaultSettingsCreator
{
    private readonly  2380600021_PhamTranHoangAnDbContext _context;

    public DefaultSettingsCreator( 2380600021_PhamTranHoangAnDbContext context)
    {
        _context = context;
    }

    public void Create()
    {
        int? tenantId = null;

        if ( 2380600021_PhamTranHoangAnConsts.MultiTenancyEnabled == false)
        {
            tenantId = MultiTenancyConsts.DefaultTenantId;
        }

        // Emailing
        AddSettingIfNotExists(EmailSettingNames.DefaultFromAddress, "admin@mydomain.com", tenantId);
        AddSettingIfNotExists(EmailSettingNames.DefaultFromDisplayName, "mydomain.com mailer", tenantId);

        // Languages
        AddSettingIfNotExists(LocalizationSettingNames.DefaultLanguage, "en", tenantId);
    }

    private void AddSettingIfNotExists(string name, string value, int? tenantId = null)
    {
        if (_context.Settings.IgnoreQueryFilters().Any(s => s.Name == name && s.TenantId == tenantId && s.UserId == null))
        {
            return;
        }

        _context.Settings.Add(new Setting(tenantId, null, name, value));
        _context.SaveChanges();
    }
}
