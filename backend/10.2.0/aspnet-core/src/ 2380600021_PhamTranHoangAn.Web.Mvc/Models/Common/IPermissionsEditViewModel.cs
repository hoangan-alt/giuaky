using  2380600021_PhamTranHoangAn.Roles.Dto;
using System.Collections.Generic;

namespace  2380600021_PhamTranHoangAn.Web.Models.Common;

public interface IPermissionsEditViewModel
{
    List<FlatPermissionDto> Permissions { get; set; }
}