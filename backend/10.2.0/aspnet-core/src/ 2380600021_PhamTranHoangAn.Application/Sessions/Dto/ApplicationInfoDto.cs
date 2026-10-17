using System;
using System.Collections.Generic;

namespace  2380600021_PhamTranHoangAn.Sessions.Dto;

public class ApplicationInfoDto
{
    public string Version { get; set; }

    public DateTime ReleaseDate { get; set; }

    public Dictionary<string, bool> Features { get; set; }
}
