using System.ComponentModel.DataAnnotations;

namespace  2380600021_PhamTranHoangAn.Users.Dto;

public class ChangeUserLanguageDto
{
    [Required]
    public string LanguageName { get; set; }
}