namespace  2380600021_PhamTranHoangAn.EntityFrameworkCore.Seed.Host;

public class InitialHostDbBuilder
{
    private readonly  2380600021_PhamTranHoangAnDbContext _context;

    public InitialHostDbBuilder( 2380600021_PhamTranHoangAnDbContext context)
    {
        _context = context;
    }

    public void Create()
    {
        new DefaultEditionCreator(_context).Create();
        new DefaultLanguagesCreator(_context).Create();
        new HostRoleAndUserCreator(_context).Create();
        new DefaultSettingsCreator(_context).Create();

        _context.SaveChanges();
    }
}
