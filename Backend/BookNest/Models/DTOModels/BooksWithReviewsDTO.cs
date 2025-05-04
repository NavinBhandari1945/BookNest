namespace BookNest.Models.DTOModels
{
    public class BooksWithReviewsDTO
    {
        // Book fields
        public int BookId { get; set; }
        public string BookName { get; set; }
        public decimal Price { get; set; }
        public string Format { get; set; }
        public string Title { get; set; }
        public string Author { get; set; }
        public string Publisher { get; set; }
        public DateTime PublicationDate { get; set; }
        public string Language { get; set; }
        public string Category { get; set; }
        public DateTime ListedAt { get; set; }
        public int AvailableQuantity { get; set; }
        public decimal DiscountPercent { get; set; }
        public DateTime DiscountStart { get; set; }
        public DateTime DiscountEnd { get; set; }
        public string Photo { get; set; }

        // Review fields
        public int? ReviewId { get; set; }
        public string? Comment { get; set; }
        public int? Rating { get; set; }
        public DateTime? ReviewDate { get; set; }
        public int? UserId { get; set; }
        public int? ReviewBookId { get; set; }

    }
}
