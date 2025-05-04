namespace BookNest.Models.DTOModels
{
    public class CartUserBookDTO
    {
        // Cart properties
        public int CartId { get; set; }
        public DateTime AddedAt { get; set; }
        public int Quantity { get; set; }
        public int CartUserId { get; set; }
        public int CartBookId { get; set; }

        // UserInfos properties
        public int? UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public string Password { get; set; }
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
