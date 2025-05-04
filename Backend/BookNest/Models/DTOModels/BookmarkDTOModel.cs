using System.ComponentModel.DataAnnotations;

namespace BookNest.Models.DTOModels
{
    public class BookmarkDTOModel
    {

        public int BookmarkId { get; set; }

        [Required]
        public string Email { get; set; }

        [Required]
        public int BookId { get; set; }

    }
}
