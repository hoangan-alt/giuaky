using Abp.Authorization;
using Abp.Runtime.Session;
using  2380600021_PhamTranHoangAn.Configuration.Dto;
using System.Threading.Tasks;

namespace  2380600021_PhamTranHoangAn.Configuration;

[AbpAuthorize]
public class ConfigurationAppService :  2380600021_PhamTranHoangAnAppServiceBase, IConfigurationAppService
{
    public async Task ChangeUiTheme(ChangeUiThemeInput input)
    {
        await SettingManager.ChangeSettingForUserAsync(AbpSession.ToUserIdentifier(), AppSettingNames.UiTheme, input.Theme);
    }
}
