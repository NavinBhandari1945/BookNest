using BookNest.Models;
using Microsoft.EntityFrameworkCore;

namespace BookNest.Data
{
    public class DatabaseController :DbContext
    {

        public DatabaseController(DbContextOptions<DatabaseController> options) : base(options)
        {


        }

        public DbSet<UserInfosModel> UserInfos { get; set; }



    }

}
