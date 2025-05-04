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

        public DbSet<BookInfos> BookInfos { get; set; }

        public DbSet<ReviewModel> ReviewInfos { get; set; }

        public DbSet<CartModel> CartInfos { get; set; }

        public DbSet<BookmarkModel> BookmarkInfos { get; set; }

        public DbSet<OrderModel> OrderInfos { get; set; }









    }

}
