using  2380600021_PhamTranHoangAn.Debugging;

namespace  2380600021_PhamTranHoangAn;

public class  2380600021_PhamTranHoangAnConsts
{
    public const string LocalizationSourceName = " 2380600021_PhamTranHoangAn";

    public const string ConnectionStringName = "Default";

    public const bool MultiTenancyEnabled = true;


    /// <summary>
    /// Default pass phrase for SimpleStringCipher decrypt/encrypt operations
    /// </summary>
    public static readonly string DefaultPassPhrase =
        DebugHelper.IsDebug ? "gsKxGZ012HLL3MI5" : "6ceebc5bc94a428dae68a2c094f960e2";
}
