using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BookNest.Models
{
    public class AnoucementModel
    {
    

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int AnnouncementId { get; set; }

        [Required]
        public string Message { get; set; }

        [Required]
        [StringLength(200)]
        public string Title { get; set; }

        [Required]
        public string Photo { get; set; }

        [Required]
        public DateTime StartDate { get; set; }

        [Required]
        public DateTime EndDate { get; set; }

        // Constructor
        public AnoucementModel(int announcementId, string message, string title, string photo, DateTime startDate, DateTime endDate)
        {
            this.AnnouncementId = announcementId;
            this.Message = message;
            this.Title = title;
            this.Photo = photo;
            this.StartDate = startDate;
            this.EndDate = endDate;
        }

        // Optional: Parameterless constructor (useful for EF and deserialization)
        public AnoucementModel() { 

        }





    }
}
