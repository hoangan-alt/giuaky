using Microsoft.EntityFrameworkCore;
using System.Data.Common;

namespace  2380600021_PhamTranHoangAn.EntityFrameworkCore;

public static class  2380600021_PhamTranHoangAnDbContextConfigurer
{
    public static void Configure(DbContextOptionsBuilder< 2380600021_PhamTranHoangAnDbContext> builder, string connectionString)
    {
        builder.UseSqlServer(connectionString);
    }

    public static void Configure(DbContextOptionsBuilder< 2380600021_PhamTranHoangAnDbContext> builder, DbConnection connection)
    {
        builder.UseSqlServer(connection);
    }
}
