using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BookNest.Models
{
    public class CartModel
    {

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        [Required]
        public int CartId { get; set; }

        [Required]
        public DateTime AddedAt { get; set; }

        [Required]
        public int Quantity { get; set; }

        [Required]
        public int UserId { get; set; }

        [Required]
        public int BookId { get; set; }

        [ForeignKey("BookId")]
        public BookInfos? Books { get; set; }

        [ForeignKey("UserId")]
        public UserInfosModel? Users { get; set; }

        public CartModel()
        {
            
        }

        public CartModel(
            int cartId,
            DateTime addedAt,
            int quantity,
            int userId,
            int bookId,
            BookInfos? books,
            UserInfosModel? users)
        {
            CartId = cartId;
            AddedAt = addedAt;
            Quantity = quantity;
            UserId = userId;
            BookId = bookId;
            Books = books;
            Users = users;
        }






    }
}
