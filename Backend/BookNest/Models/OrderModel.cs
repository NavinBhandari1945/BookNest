using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BookNest.Models
{
    public class OrderModel
    {

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        [Required]
        public int OrderId { get; set; }

        [Required]
        [StringLength(50)]
        public string Status { get; set; }

        [Required]
        public int BookQuantity { get; set; }

        [Required]
        [StringLength(500)]
        public string ClaimId { get; set; }

        [Required]
        public int DiscountAmount { get; set; }

        [Required]
        [Column(TypeName = "decimal(18,2)")]
        public decimal TotalPrice { get; set; }

        [Required]
        [StringLength(50)]
        public string ClaimCode { get; set; }

        [Required]
        public DateTime OrderDate { get; set; }

        [Required]
        public int UserId { get; set; }

        [Required]
        public int BookId { get; set; }


        [ForeignKey("BookId")]
        public BookInfos? Books { get; set; }

        [ForeignKey("UserId")]
        public UserInfosModel? Users { get; set; }

        public OrderModel()
        {
            
        }

        public OrderModel(
            int orderId,
            string status,
            int bookQuantity,
            string claimId,
            int discountAmount,
            decimal totalPrice,
            string claimCode,
            DateTime orderDate,
            int userId,
            int bookId,
            BookInfos? books,
            UserInfosModel? users)
        {
            OrderId = orderId;
            Status = status;
            BookQuantity = bookQuantity;
            ClaimId = claimId;
            DiscountAmount = discountAmount;
            TotalPrice = totalPrice;
            ClaimCode = claimCode;
            OrderDate = orderDate;
            UserId = userId;
            BookId = bookId;
            Books = books;
            Users = users;
        }

    }
}
