namespace  2380600021_PhamTranHoangAn.Sessions.Dto;

public class GetCurrentLoginInformationsOutput
{
    public ApplicationInfoDto Application { get; set; }

    public UserLoginInfoDto User { get; set; }

    public TenantLoginInfoDto Tenant { get; set; }
}
