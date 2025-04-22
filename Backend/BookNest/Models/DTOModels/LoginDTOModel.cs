using System.ComponentModel.DataAnnotations;

namespace BookNest.Models.DTOModels
{
    public class LoginDTOModel
    {
        [Required]
        [StringLength(200)]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        [StringLength(200)]
        public string Password { get; set; } 
    }
}
