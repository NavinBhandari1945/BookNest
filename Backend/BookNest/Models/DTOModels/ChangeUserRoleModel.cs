using System.ComponentModel.DataAnnotations;

namespace BookNest.Models.DTOModels
{
    public class ChangeUserRoleModel
    {

        [Required]
        [StringLength(200)]
        [EmailAddress]
        public string Email { get; set; }


        [StringLength(50)]
        public string Role { get; set; }

    }
}
