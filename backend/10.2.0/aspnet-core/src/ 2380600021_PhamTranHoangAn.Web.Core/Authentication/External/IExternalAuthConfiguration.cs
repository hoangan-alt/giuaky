using System.Collections.Generic;

namespace  2380600021_PhamTranHoangAn.Authentication.External
{
    public interface IExternalAuthConfiguration
    {
        List<ExternalLoginProviderInfo> Providers { get; }
    }
}
