using  2380600021_PhamTranHoangAn.Models.TokenAuth;
using  2380600021_PhamTranHoangAn.Web.Controllers;
using Shouldly;
using System.Threading.Tasks;
using Xunit;

namespace  2380600021_PhamTranHoangAn.Web.Tests.Controllers;

public class HomeController_Tests :  2380600021_PhamTranHoangAnWebTestBase
{
    [Fact]
    public async Task Index_Test()
    {
        await AuthenticateAsync(null, new AuthenticateModel
        {
            UserNameOrEmailAddress = "admin",
            Password = "123qwe"
        });

        //Act
        var response = await GetResponseAsStringAsync(
            GetUrl<HomeController>(nameof(HomeController.Index))
        );

        //Assert
        response.ShouldNotBeNullOrEmpty();
    }
}