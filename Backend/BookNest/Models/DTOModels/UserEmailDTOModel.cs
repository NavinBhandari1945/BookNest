using System.ComponentModel.DataAnnotations;

namespace BookNest.Models.DTOModels
{
    public class UserEmailDTOModel
    {
        [Required]
        [StringLength(200)]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;

    }
}
