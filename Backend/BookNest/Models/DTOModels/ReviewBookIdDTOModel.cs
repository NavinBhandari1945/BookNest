using System.ComponentModel.DataAnnotations;

namespace BookNest.Models.DTOModels
{
    public class ReviewBookIdDTOModel
    {
        [Required]
        public int BookId { get; set; }
    }
}
