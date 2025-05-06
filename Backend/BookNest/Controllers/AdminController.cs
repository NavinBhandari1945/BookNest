using BookNest.Data;
using BookNest.Models;
using BookNest.Models.DTOModels;
using BookNest.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BookNest.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AdminController : ControllerBase
    {
        private readonly ILogger<AdminController> _logger;

        public DatabaseController Database { get; set; }

        public AdminController(DatabaseController Database, ILogger<AdminController> logger)
        {
            this.Database = Database;
            this._logger = logger;
        }


        [Authorize(Policy = "RequireAdminRole")]
        [HttpPut]
        [Route("change_user_role")]
        public async Task<IActionResult> Chnage_User_Role([FromBody] ChangeUserRoleModel obj)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    // Check if the user exists
                    var user_data = await Database.UserInfos.FirstOrDefaultAsync(x => x.Email == obj.Email);

                    if (user_data != null)
                    {
                        
                        user_data.Role= obj.Role;
                        await Database.SaveChangesAsync();
                        return Ok();
                    }
                    else
                    {
                        return StatusCode(501, "No user with the provided email found.");
                    }
                }
                else
                {
                    return StatusCode(502, "Provide correct format.");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error while changing user role: {Message}", ex.Message);
                return StatusCode(500, $"Exception caught in changing user role.\n{ex.Message}"); // 500 Internal Server Error
            }
        }



        [Authorize(Policy = "RequireAdminRole")]
        [HttpPost]
        [Route("add_book")]
        public async Task<IActionResult> AddBook([FromBody] BookInfosStringModel Obj)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return StatusCode(501,"Invalid data format.");
                }

                var publication_date = DateTime.Parse(Obj.PublicationDate).ToUniversalTime();
                var listed_date = DateTime.Parse(Obj.ListedAt).ToUniversalTime();
                var discount_start_date = DateTime.Parse(Obj.DiscountStart).ToUniversalTime();
                var discount_end_date = DateTime.Parse(Obj.DiscountEnd).ToUniversalTime();

                if (discount_end_date <= discount_start_date)
                {
                    return StatusCode(502, "Incorrect discount date: Discount end date must be after start date.");
                }
                BookInfos bookinfos = new BookInfos(
                        BookId:Obj.BookId,
                        BookName: Obj.BookName,
                        Price: Obj.Price,
                        Format: Obj.Format,
                        Title:Obj.Title,
                        Author: Obj.Author,
                        Publisher:Obj.Publisher,
                        PublicationDate: publication_date,
                        Language: Obj.Language,
                        Category: Obj.Category,
                        ListedAt: listed_date,
                        AvailableQuantity:Obj.AvailableQuantity,
                        DiscountPercent: Obj.DiscountPercent,
                        DiscountStart:discount_start_date,
                        DiscountEnd:discount_end_date ,
                        Photo:Obj.Photo
                    );

                await Database.BookInfos.AddAsync(bookinfos);
                await Database.SaveChangesAsync();
                return Ok(new { Message = "Book added successfully."});
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error while adding book: {Message}", ex.Message);
                return StatusCode(500, new
                {
                    error = "An unexpected error occurred.",
                    message = ex.Message,
                    stackTrace = ex.StackTrace
                });
            }
        }


        //[Authorize(Policy = "RequireAdminRole")]
        [HttpPost]
        [Route("add_announcement")]
        public async Task<IActionResult> Add_Announcement([FromBody] AnnouncementStringModel Obj)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return StatusCode(501, "Invalid data format.");
                }

                var Start_Date = DateTime.Parse(Obj.StartDate).ToUniversalTime();
                var End_Date = DateTime.Parse(Obj.EndDate).ToUniversalTime();

                if (End_Date <= Start_Date)
                {
                    return StatusCode(502, "Incorrect discount date: Discount end date must be after start date.");
                }

                AnoucementModel announcement = new AnoucementModel(
                    announcementId:Obj.AnnouncementId,
                    message: Obj.Message,
                    title: Obj.Title,
                    photo: Obj.Photo,
                    startDate:Start_Date,
                    endDate: End_Date
                );
                await Database.AnnouncementInfos.AddAsync(announcement);
                await Database.SaveChangesAsync();
                return Ok(new { Message = "Announcement added successfully." });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error while adding Announcement: {Message}", ex.Message);
                return StatusCode(500, new
                {
                    error = "An unexpected error occurred.",
                    message = ex.Message,
                    stackTrace = ex.StackTrace
                });
            }
        }

        //[Authorize(Policy = "RequireAdminRole")]
        [HttpPut]
        [Route("update_discount")]
        public async Task<IActionResult> UpdateDiscount([FromBody] UpdateDiscountDTOModel obj)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return StatusCode(501, "Invalid data format.");
                }

                var book = await Database.BookInfos.FirstOrDefaultAsync(b => b.BookId == obj.BookId);

                if (book == null)
                {
                    return StatusCode(502, "Book not found.");
                }

                // Update only discount-related fields and category
                book.Category = obj.Category;
                book.DiscountPercent = obj.DiscountPercent;
                book.DiscountStart = DateTime.Parse(obj.DiscountStart).ToUniversalTime();
                book.DiscountEnd = DateTime.Parse(obj.DiscountEnd).ToUniversalTime();

                await Database.SaveChangesAsync();
                return Ok(new { Message = "Discount updated successfully." });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error while updating discount: {Message}", ex.Message);
                return StatusCode(500, new
                {
                    error = "An unexpected error occurred.",
                    message = ex.Message
                });
            }
        }

        //[Authorize(Policy = "RequireAdminRole")]
        [HttpPut]
        [Route("update_book")]
        public async Task<IActionResult> UpdateBook([FromBody] UpdateBookDTOModel obj)
        {
            try
            {
                if (!ModelState.IsValid)
                    return StatusCode(501, "Invalid book data.");

                var book = await Database.BookInfos.FirstOrDefaultAsync(b => b.BookId == obj.BookId);
                if (book == null)
                    return NotFound("Book not found.");

                // Update all allowed fields
                book.BookName = obj.BookName;
                book.Price = obj.Price;
                book.Format = obj.Format;
                book.Title = obj.Title;
                book.Language = obj.Language;
                book.AvailableQuantity = obj.AvailableQuantity;

                await Database.SaveChangesAsync();
                return Ok(new { message = "Book updated successfully." });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating book.");
                return StatusCode(500, new { error = "Internal server error", ex.Message });
            }
        }

        //[Authorize(Policy = "RequireAdminRole")]
        [HttpDelete]
        [Route("delete_book/{bookId}")]
        public async Task<IActionResult> DeleteBook(int bookId)
        {
            var book = await Database.BookInfos.FindAsync(bookId);
            if (book == null)
            {
                return NotFound("Book not found.");
            }

            Database.BookInfos.Remove(book);
            await Database.SaveChangesAsync();

            return Ok(new { message = "Book deleted successfully." });
        }


        //[Authorize(Policy = "RequireAdminRole")]
        [HttpGet]
        [Route("get_books_info")]
        public async Task<IActionResult> Get_Books_Infos()
        {

            try
            {
                var Book_Data = await Database.BookInfos.ToListAsync();
                if (Book_Data.Any())
                {
                    return Ok(Book_Data);
                }
                return StatusCode(500, "Database error while getting books info");
            }
            catch (Exception ex)
            {
                return StatusCode(501, ex.Message);
            }
        }










    }
}
