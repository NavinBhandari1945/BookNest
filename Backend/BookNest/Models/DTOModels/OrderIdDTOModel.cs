using System.ComponentModel.DataAnnotations;

namespace BookNest.Models.DTOModels
{
    public class OrderIdDTOModel
    {

        [Required]
        public int OrderId { get; set; }
    }
}
