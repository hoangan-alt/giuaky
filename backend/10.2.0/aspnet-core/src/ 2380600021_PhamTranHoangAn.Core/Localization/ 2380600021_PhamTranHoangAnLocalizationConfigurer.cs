using Abp.Configuration.Startup;
using Abp.Localization.Dictionaries;
using Abp.Localization.Dictionaries.Xml;
using Abp.Reflection.Extensions;

namespace  2380600021_PhamTranHoangAn.Localization;

public static class  2380600021_PhamTranHoangAnLocalizationConfigurer
{
    public static void Configure(ILocalizationConfiguration localizationConfiguration)
    {
        localizationConfiguration.Sources.Add(
            new DictionaryBasedLocalizationSource( 2380600021_PhamTranHoangAnConsts.LocalizationSourceName,
                new XmlEmbeddedFileLocalizationDictionaryProvider(
                    typeof( 2380600021_PhamTranHoangAnLocalizationConfigurer).GetAssembly(),
                    " 2380600021_PhamTranHoangAn.Localization.SourceFiles"
                )
            )
        );
    }
}
