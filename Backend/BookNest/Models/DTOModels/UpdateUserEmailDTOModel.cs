using System.ComponentModel.DataAnnotations;

namespace BookNest.Models.DTOModels
{
    public class UpdateUserEmailDTOModel
    {

        [Required]
        [StringLength(200)]
        [EmailAddress]
        public string OldEmail { get; set; } = string.Empty;

        [Required]
        [StringLength(200)]
        [EmailAddress]
        public string NewEmail { get; set; } = string.Empty;

        [Required]
        public string Password { get; set; } = string.Empty;


    }
}
