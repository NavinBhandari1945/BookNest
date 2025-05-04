using System.ComponentModel.DataAnnotations;

namespace BookNest.Models.DTOModels
{
    public class CartIdDTOModel
    {
        [Required]
        public int CartId { get; set; }
    }
}
