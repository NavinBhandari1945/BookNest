using System.ComponentModel.DataAnnotations;

namespace BookNest.Models.DTOModels
{
    public class OrderUserIdDTOModel
    {

        [Required]
        public int UserId { get; set; }
    }
}
