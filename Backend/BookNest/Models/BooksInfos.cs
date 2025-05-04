using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BookNest.Models
{
    public class BookInfos
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int BookId { get; set; }

        [Required(ErrorMessage = "Book name is required.")]
        [StringLength(50, ErrorMessage = "Book name cannot exceed 50 characters.")]
        public string BookName { get; set; }

        [Required(ErrorMessage = "Price is required.")]
        [Range(0.01, double.MaxValue, ErrorMessage = "Price must be greater than 0.")]
        public decimal Price { get; set; }

        [Required(ErrorMessage = "Format is required.")]
        [StringLength(50, ErrorMessage = "Format cannot exceed 50 characters.")]
        public string Format { get; set; }

        [Required(ErrorMessage = "Title is required.")]
        [StringLength(50, ErrorMessage = "Title cannot exceed 50 characters.")]
        public string Title { get; set; }

        [Required(ErrorMessage = "Author is required.")]
        [StringLength(50, ErrorMessage = "Author cannot exceed 50 characters.")]
        public string Author { get; set; }

        [Required(ErrorMessage = "Publisher is required.")]
        [StringLength(50, ErrorMessage = "Publisher cannot exceed 50 characters.")]
        public string Publisher { get; set; }

        [Required(ErrorMessage = "Publication date is required.")]
        [DataType(DataType.Date)]
        public DateTime PublicationDate { get; set; }

        [Required(ErrorMessage = "Language is required.")]
        [StringLength(50, ErrorMessage = "Language cannot exceed 50 characters.")]
        public string Language { get; set; }

        [Required(ErrorMessage = "Category is required.")]
        [StringLength(200, ErrorMessage = "Category cannot exceed 200 characters.")]
        public string Category { get; set; }


        [Required(ErrorMessage = "ListedAt date is required.")]
        [DataType(DataType.Date)]
        public DateTime ListedAt { get; set; }

        [Required(ErrorMessage = "Available quantity is required.")]
        [Range(0, int.MaxValue, ErrorMessage = "Available quantity cannot be negative.")]
        public int AvailableQuantity { get; set; }

        [Required(ErrorMessage = "Discount percent is required.")]
        [Range(0, 100, ErrorMessage = "Discount percent must be between 0 and 100.")]
        public decimal DiscountPercent { get; set; }

        [Required(ErrorMessage = "Discount start date is required.")]
        [DataType(DataType.Date)]
        public DateTime DiscountStart { get; set; }

        [Required(ErrorMessage = "Discount end date is required.")]
        [DataType(DataType.Date)]
        public DateTime DiscountEnd { get; set; }

        [Required(ErrorMessage = "Photo is required.")]
        public string Photo { get; set; }

        public ICollection<ReviewModel> Books { get; set; } = [];

        public BookInfos(int BookId,string BookName, decimal Price, string Format, string Title, string Author, string Publisher,
                    DateTime PublicationDate, string Language, string Category, DateTime ListedAt,
                    int AvailableQuantity, decimal DiscountPercent, DateTime DiscountStart, DateTime DiscountEnd,string Photo)
        {
            this.BookId=BookId;
            this.BookName = BookName;
            this.Price = Price;
            this.Format = Format;
            this.Title = Title;
            this.Author = Author;
            this.Publisher = Publisher;
            this.PublicationDate = PublicationDate;
            this.Language = Language;
            this.Category = Category;
            this.ListedAt = ListedAt;
            this.AvailableQuantity = AvailableQuantity;
            this.DiscountPercent = DiscountPercent;
            this.DiscountStart = DiscountStart;
            this.DiscountEnd = DiscountEnd;
            this.Photo = Photo;
        }



    }
}
