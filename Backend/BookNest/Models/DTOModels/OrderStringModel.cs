using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BookNest.Models.DTOModels
{
    public class OrderStringModel
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
        public string OrderDate { get; set; }

        [Required]
        public int UserId { get; set; }

        [Required]
        public int BookId { get; set; }
    }
}
