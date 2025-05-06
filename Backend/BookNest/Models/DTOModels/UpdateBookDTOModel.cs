using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BookNest.Models.DTOModels
{
    public class UpdateBookDTOModel
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int BookId { get; set; }

        [Required(ErrorMessage = "Book name is required.")]
        [StringLength(50, ErrorMessage = "Book name cannot exceed 50 characters.")]
        public string BookName { get; set; }

        [Required(ErrorMessage = "Price is required.")]
        [Range(0.01, double.MaxValue, ErrorMessage = "Price must be greater than 0.")]
        public decimal Price { get; set; }

        [Required(ErrorMessage = "Format is required.")]
        [StringLength(50, ErrorMessage = "Format cannot exceed 50 characters.")]
        public string Format { get; set; }

        [Required(ErrorMessage = "Title is required.")]
        [StringLength(50, ErrorMessage = "Title cannot exceed 50 characters.")]
        public string Title { get; set; }

        [Required(ErrorMessage = "Language is required.")]
        [StringLength(50, ErrorMessage = "Language cannot exceed 50 characters.")]
        public string Language { get; set; }

        [Required(ErrorMessage = "Available quantity is required.")]
        [Range(0, int.MaxValue, ErrorMessage = "Available quantity cannot be negative.")]
        public int AvailableQuantity { get; set; }
    }
}
