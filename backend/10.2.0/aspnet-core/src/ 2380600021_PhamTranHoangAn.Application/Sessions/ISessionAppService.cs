using Abp.Application.Services;
using  2380600021_PhamTranHoangAn.Sessions.Dto;
using System.Threading.Tasks;

namespace  2380600021_PhamTranHoangAn.Sessions;

public interface ISessionAppService : IApplicationService
{
    Task<GetCurrentLoginInformationsOutput> GetCurrentLoginInformations();
}
