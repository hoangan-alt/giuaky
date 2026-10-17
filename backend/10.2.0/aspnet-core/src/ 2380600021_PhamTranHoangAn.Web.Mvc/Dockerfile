FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

RUN dotnet tool install -g Microsoft.Web.LibraryManager.Cli
RUN ln -s ~/.dotnet/tools/libman /usr/local/bin/libman

WORKDIR /src
COPY ["src/ 2380600021_PhamTranHoangAn.Web.Mvc/ 2380600021_PhamTranHoangAn.Web.Mvc.csproj", "src/ 2380600021_PhamTranHoangAn.Web.Mvc/"]
COPY ["src/ 2380600021_PhamTranHoangAn.Web.Core/ 2380600021_PhamTranHoangAn.Web.Core.csproj", "src/ 2380600021_PhamTranHoangAn.Web.Core/"]
COPY ["src/ 2380600021_PhamTranHoangAn.Application/ 2380600021_PhamTranHoangAn.Application.csproj", "src/ 2380600021_PhamTranHoangAn.Application/"]
COPY ["src/ 2380600021_PhamTranHoangAn.Core/ 2380600021_PhamTranHoangAn.Core.csproj", "src/ 2380600021_PhamTranHoangAn.Core/"]
COPY ["src/ 2380600021_PhamTranHoangAn.EntityFrameworkCore/ 2380600021_PhamTranHoangAn.EntityFrameworkCore.csproj", "src/ 2380600021_PhamTranHoangAn.EntityFrameworkCore/"]
WORKDIR "/src/src/ 2380600021_PhamTranHoangAn.Web.Mvc"
RUN dotnet restore 

WORKDIR /src
COPY ["src/ 2380600021_PhamTranHoangAn.Web.Mvc", "src/ 2380600021_PhamTranHoangAn.Web.Mvc"]
COPY ["src/ 2380600021_PhamTranHoangAn.Web.Core", "src/ 2380600021_PhamTranHoangAn.Web.Core"]
COPY ["src/ 2380600021_PhamTranHoangAn.Application", "src/ 2380600021_PhamTranHoangAn.Application"]
COPY ["src/ 2380600021_PhamTranHoangAn.Core", "src/ 2380600021_PhamTranHoangAn.Core"]
COPY ["src/ 2380600021_PhamTranHoangAn.EntityFrameworkCore", "src/ 2380600021_PhamTranHoangAn.EntityFrameworkCore"]
WORKDIR "/src/src/ 2380600021_PhamTranHoangAn.Web.Mvc"
RUN libman restore
RUN dotnet publish -c Release -o /publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0
EXPOSE 80
WORKDIR /app
COPY --from=build /publish .
ENTRYPOINT ["dotnet", " 2380600021_PhamTranHoangAn.Web.Mvc.dll"]
