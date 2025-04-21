using System.ComponentModel.DataAnnotations;

namespace BookNest.Models.DTOModels
{
    public class LoginDTOModel
    {
        [Required]
        [StringLength(200)]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;

        [Required]
        public string Password { get; set; } = string.Empty;
    }
}
