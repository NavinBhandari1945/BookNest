using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BookNest.Models.DTOModels
{
    public class ReviewEmailDTOModel
    {

        [Required]
        public int ReviewId { get; set; }

        [Required]
        [StringLength(500)]
        public string Comment { get; set; }

        [Required]
        public int Rating { get; set; }

        [Required]
        public string ReviewDate { get; set; }

        [Required]
        public string Email { get; set; }

        [Required]
        public int BookId { get; set; }
    }
}
