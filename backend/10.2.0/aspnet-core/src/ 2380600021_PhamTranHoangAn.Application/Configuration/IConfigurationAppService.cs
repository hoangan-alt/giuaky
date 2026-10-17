using  2380600021_PhamTranHoangAn.Configuration.Dto;
using System.Threading.Tasks;

namespace  2380600021_PhamTranHoangAn.Configuration;

public interface IConfigurationAppService
{
    Task ChangeUiTheme(ChangeUiThemeInput input);
}
