using System.ComponentModel.DataAnnotations;

namespace  2380600021_PhamTranHoangAn.Users.Dto;

public class ChangePasswordDto
{
    [Required]
    public string CurrentPassword { get; set; }

    [Required]
    public string NewPassword { get; set; }
}
