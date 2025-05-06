using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BookNest.Models.DTOModels
{
    public class ClaimCodeDTOModel
    {
        [Required]
        public int OrderId { get; set; }

        [Required]
        [StringLength(50)]
        public string ClaimCode { get; set; }


        [Required]
        [StringLength(500)]
        public string ClaimId { get; set; }

    }
}
