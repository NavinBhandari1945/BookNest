using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BookNest.Models.DTOModels
{
    public class UpdateDiscountDTOModel
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int BookId { get; set; }

        [Required(ErrorMessage = "Category is required.")]
        [StringLength(200, ErrorMessage = "Category cannot exceed 200 characters.")]
        public string Category { get; set; }

        [Required(ErrorMessage = "Discount percent is required.")]
        [Range(0, 100, ErrorMessage = "Discount percent must be between 0 and 100.")]
        public decimal DiscountPercent { get; set; }

        [Required(ErrorMessage = "Discount start date is required.")]
        public string DiscountStart { get; set; }

        [Required(ErrorMessage = "Discount end date is required.")]
        public string DiscountEnd { get; set; }
    }
}
