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

       





    }
}
