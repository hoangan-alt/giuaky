using Abp.MultiTenancy;
using System.ComponentModel.DataAnnotations;

namespace  2380600021_PhamTranHoangAn.Authorization.Accounts.Dto;

public class IsTenantAvailableInput
{
    [Required]
    [StringLength(AbpTenantBase.MaxTenancyNameLength)]
    public string TenancyName { get; set; }
}
