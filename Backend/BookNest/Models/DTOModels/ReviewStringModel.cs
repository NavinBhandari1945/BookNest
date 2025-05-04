using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BookNest.Models.DTOModels
{
    public class ReviewStringModel
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ReviewId { get; set; }

        [Required]
        [StringLength(500)]
        public string Comment { get; set; }

        [Required]
        public int Rating { get; set; }

        [Required]
        public string ReviewDate { get; set; }

        [Required]
        public int UserId { get; set; }

        [Required]
        public int BookId { get; set; }


    }
}
