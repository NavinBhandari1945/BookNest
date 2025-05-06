namespace BookNest.Models.DTOModels
{
    public class OrderUserBookDTO
    {
        // Order properties
        public int OrderId { get; set; }
        public string Status { get; set; }
        public int BookQuantity { get; set; }
        public string ClaimId { get; set; }
        public int DiscountAmount { get; set; }
        public decimal TotalPrice { get; set; }
        public string ClaimCode { get; set; }
        public DateTime OrderDate { get; set; }
        public int OrderUserId { get; set; }
        public int OrderBookId { get; set; }

        // UserInfos properties
        public int? UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public string Role { get; set; }

        // BookInfos properties
        public int? BookId { get; set; }
        public string BookName { get; set; }
        public decimal? Price { get; set; }
        public string Format { get; set; }
        public string Title { get; set; }
        public string Author { get; set; }
        public string Publisher { get; set; }
        public DateTime? PublicationDate { get; set; }
        public string Language { get; set; }
        public string Category { get; set; }
        public DateTime? ListedAt { get; set; }
        public int? AvailableQuantity { get; set; }
        public decimal? DiscountPercent { get; set; }
        public DateTime? DiscountStart { get; set; }
        public DateTime? DiscountEnd { get; set; }
        public string Photo { get; set; }
    }
}
