using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BookNest.Models
{
    public class ReviewModel
    {
        private object books;

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ReviewId { get; set; }

        [Required]
        [StringLength(500)]
        public string Comment { get; set; }

        [Required]
        public int Rating { get; set; }

        [Required]
        public DateTime ReviewDate { get; set; }

        [Required]
        public int UserId { get; set; }

        [Required]
        public int BookId { get; set; }

        [ForeignKey("BookId")]
        public BookInfos? Books { get; set; }

        [ForeignKey("UserId")]
        public UserInfosModel? Users { get; set; }

        public ReviewModel()
        {
            
        }

        public ReviewModel(int reviewId, string comment, int rating, DateTime reviewDate, int userId, int bookId, BookInfos? books, UserInfosModel? users)
        {
            ReviewId = reviewId;
            Comment = comment;
            Rating = rating;
            ReviewDate = reviewDate;
            UserId = userId;
            BookId = bookId;
            Books = books;
            Users = users;
        }

    
    }
}
