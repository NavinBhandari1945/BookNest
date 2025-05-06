using BookNest.Data;
using BookNest.Models;
using BookNest.Models.DTOModels;
using BookNest.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
using System.Text;

namespace BookNest.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MemberController : ControllerBase
    {
        

        public DatabaseController Database { get; set; }
        public ILogger<MemberController> Logger { get; }

        public MemberController(DatabaseController Database,ILogger<MemberController> logger)
        {
            this.Database = Database;
            Logger = logger;
        
        }

        private string HashPassword(string password)
        {
            using (var sha256 = SHA256.Create())
            {
                // Compute hash for the password
                var hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                // Convert the byte array to a hexadecimal string
                if (hashedBytes != null)
                {
                    return BitConverter.ToString(hashedBytes).Replace("-", "").ToLower();
                }
                else
                {
                    return "";
                }

            }

        }



        //[Authorize(Policy = "RequireMemberRole")]
        [HttpPut]
        [Route("update_email")]
        public async Task<IActionResult> UpdateEmail([FromBody] UpdateUserEmailDTOModel obj)
        {
            try
            {
                if (!ModelState.IsValid)
                    return StatusCode(400, "Invalid request.");

                var user = await Database.UserInfos.FirstOrDefaultAsync(b => b.Email == obj.OldEmail);
                if (user == null)
                    return StatusCode(501, "User not found.");

                // Hash the provided password
                string hashedInputPassword =HashPassword(obj.Password);

                // Compare with stored password
                if (user.Password != hashedInputPassword)
                {
                    return StatusCode(502, "Invalid password.");
                }

                // Check if new email is already in use
                var emailExists = await Database.UserInfos.AnyAsync(u => u.Email == obj.NewEmail);
                if (emailExists)
                {
                    return StatusCode(503, "New email is already in use.");
                }

                // Update email
                user.Email = obj.NewEmail;
                await Database.SaveChangesAsync();
                return Ok(new { message = "Email updated successfully." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    error = "An unexpected error occurred.",
                    message = ex.Message,
                    stackTrace = ex.StackTrace
                });
            }
        }



        [Authorize(Policy = "RequireMemberRole")]
        [HttpGet]
        [Route("get_announcement_info")]
        public async Task<IActionResult> Get_Announcement_Infos()
        {
            try
            {
                var currentDate = DateTime.UtcNow; // Use UtcNow for consistency; adjust if using local time

                var Announcement_Data = await Database.AnnouncementInfos
                    .Where(a => a.StartDate <= currentDate && a.EndDate >= currentDate)
                    .ToListAsync();

                if (Announcement_Data.Any())
                {
                    return Ok(Announcement_Data);
                }

                return NotFound("No active announcements found for the current date.");
            }
            catch (Exception ex)
            {
                Logger.LogError(ex, "Unexpected error while getting Announcement: {Message}", ex.Message);
                return StatusCode(500, new
                {
                    error = "An unexpected error occurred.",
                    message = ex.Message,
                    stackTrace = ex.StackTrace
                });
            }
        }

        [Authorize(Policy = "RequireMemberRole")]
        [HttpGet]
        [Route("getbooksinfo")]
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

        [Authorize(Policy = "RequireMemberRole")]
        [HttpPost]
        [Route("getreviewdata")]
        public async Task<IActionResult> Get_Review_Infos([FromBody] ReviewBookIdDTOModel obj)
        {

            try
            {
                var Review_Data = await Database.ReviewInfos.Where(x => x.BookId == obj.BookId).ToListAsync();
                if (Review_Data.Any())
                {
                    return Ok(Review_Data);
                }
                return StatusCode(500, "Database error while getting review info");
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    error = "An unexpected error occurred.",
                    message = ex.Message,
                    stackTrace = ex.StackTrace
                });
            }
        }

        [Authorize(Policy = "RequireMemberRole")]
        [HttpPost]
        [Route("add_reviews")]
        public async Task<IActionResult> Add_Review([FromBody] ReviewEmailDTOModel obj)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var User_Data = await Database.UserInfos.FirstOrDefaultAsync(x=>x.Email==obj.Email);

                    if (User_Data != null)
                    {
                        var Review_Date = DateTime.Parse(obj.ReviewDate).ToUniversalTime();
                        var Order_Data = await Database.OrderInfos.FirstOrDefaultAsync(x=>x.UserId==User_Data.UserId && x.BookId==obj.BookId && x.Status=="Complete");
                        if (Order_Data!=null)
                        {
                            ReviewModel review = new ReviewModel(
                                  reviewId: obj.ReviewId,
                                  comment: obj.Comment,
                                  rating: obj.Rating,
                                  reviewDate: Review_Date,
                                  userId: User_Data.UserId,
                                  bookId: obj.BookId,
                                  books: null,
                                  users:null
                              );
                            await Database.ReviewInfos.AddAsync(review);
                            await Database.SaveChangesAsync();
                            return Ok();
                        }
                        else
                        {
                            return StatusCode(505, "No order history present.");
                        }
                    }
                    else
                    {
                        return StatusCode(501,"No user present.");
                    }
                }
                else
                {
                    return StatusCode(502, "Provide correct format.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    error = "An unexpected error occurred.",
                    message = ex.Message,
                    stackTrace = ex.StackTrace
                });
            }
        }


        [Authorize(Policy = "RequireMemberRole")]
        [HttpGet]
        [Route("getbookswithreviews")]
        public async Task<IActionResult> GetBooksWithReviews()
        {
            try
            {
                var query = @"
                    SELECT 
                        b.""BookId"",
                        b.""BookName"",
                        b.""Price"",
                        b.""Format"",
                        b.""Title"",
                        b.""Author"",
                        b.""Publisher"",
                        b.""PublicationDate"",
                        b.""Language"",
                        b.""Category"",
                        b.""ListedAt"",
                        b.""AvailableQuantity"",
                        b.""DiscountPercent"",
                        b.""DiscountStart"",
                        b.""DiscountEnd"",
                        b.""Photo"",
                        r.""ReviewId"",
                        r.""Comment"",
                        r.""Rating"",
                        r.""ReviewDate"",
                        r.""UserId"",
                        r.""BookId"" AS ReviewBookId
                    FROM ""BookInfos"" b
                    INNER JOIN ""ReviewInfos"" r ON b.""BookId"" = r.""BookId""
                ";

                var result = await Database.Database
                    .SqlQueryRaw<BooksWithReviewsDTO>(query)
                    .ToListAsync();

                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
    

        [Authorize(Policy = "RequireMemberRole")]
        [HttpPost]
        [Route("add_bookmark")]
        public async Task<IActionResult> Add_Bookmark([FromBody] BookmarkDTOModel obj)
        {
            try
            {
                if (ModelState.IsValid)
                {

                    var User_Data = await Database.UserInfos.FirstOrDefaultAsync(x=>x.Email==obj.Email);
                    if (User_Data!=null)
                    {

                        BookmarkModel bookmark = new BookmarkModel
                        {
                            BookmarkId = obj.BookmarkId,
                            UserId = User_Data.UserId,
                            BookId = obj.BookId,
                            Books = null,
                            Users = null
                        };

                        await Database.BookmarkInfos.AddAsync(bookmark);
                        await Database.SaveChangesAsync();
                        return Ok();

                    }
                    else
                    {
                        return StatusCode(503,"User doesn't exist.");
                    }
                }
                else
                {
                    return StatusCode(502, "Provide correct format.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Exception caught in login action method.\n{ex.Message}"); // 500 Internal Server Error
            }
        }

        [Authorize(Policy = "RequireMemberRole")]
        [HttpPost]
        [Route("add_cart")]
        public async Task<IActionResult> Add_Cart([FromBody] CartStringModel obj)
        {
            try
            {
                if (ModelState.IsValid)
                {

                    var Added_Date = DateTime.Parse(obj.AddedAt).ToUniversalTime();

                    var User_Data = await Database.UserInfos.FirstOrDefaultAsync(x => x.Email == obj.Email);
                    if (User_Data != null)
                    {
                        CartModel cart = new CartModel(
                                   cartId: obj.CartId,
                                   addedAt: Added_Date,
                                   quantity: obj.Quantity,
                                   userId: User_Data.UserId,
                                   bookId: obj.BookId,
                                   books: null,
                                   users: null
                               );
                            await Database.CartInfos.AddAsync(cart);
                            await Database.SaveChangesAsync();
                            return Ok();

                    }
                    else
                    {
                        return StatusCode(503, "User doesn't exist.");
                    }
                }
                else
                {
                    return StatusCode(502, "Provide correct format.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    error = "An unexpected error occurred.",
                    message = ex.Message,
                    stackTrace = ex.StackTrace
                });
            }
        }

        //[Authorize(Policy = "RequireMemberRole")]
        [HttpPost]
        [Route("getcartdata")]
        public async Task<IActionResult> Get_Cart_Infos([FromBody] GetCartDTOModel obj)
        {

            try
            {
                var User_Data = await Database.UserInfos.FirstOrDefaultAsync(x => x.Email == obj.Email);
                if (User_Data != null)
                {
                    var Cart_Data = await Database.CartInfos.Where(x => x.UserId == User_Data.UserId).ToListAsync();
                    if (Cart_Data.Any())
                    {
                        return Ok(Cart_Data);
                    }
                    else
                    {
                        return StatusCode(503, "Cart data doesn't exist.");
                    }
                }
                else
                {
                    return StatusCode(503, "User doesn't exist.");
                }

            }
            catch (Exception ex)
            {
                return StatusCode(501, ex.Message);
            }
        }

        //[Authorize(Policy = "RequireMemberRole")]
        [HttpDelete]
        [Route("deletecartitem")]
        public async Task<IActionResult> Delete_Cart_Infos([FromBody]CartIdDTOModel obj)
        {

            try
            {
                if (ModelState.IsValid)
                {
                    var Cart_Data=await Database.CartInfos.FirstOrDefaultAsync(X=>X.CartId==obj.CartId);
                    if (Cart_Data != null) {
                        var result = Database.CartInfos.Remove(Cart_Data);
                        await Database.SaveChangesAsync();
                        return Ok("Delete user success");
                    }
                    else
                    {
                        return StatusCode(503,"No cart data match.");
                    }
                }
                else
                {
                    return StatusCode(502, "Provide correct format.");
                }

            }
            catch (Exception ex)
            {
                return StatusCode(501, ex.Message);
            }
        }


        //[Authorize(Policy = "RequireMemberRole")]
        [HttpPost]
        [Route("add_order")]
        public async Task<IActionResult> Add_Order_History([FromBody] OrderStringModel obj)
        {
            try
            {
                if (ModelState.IsValid)
                {

                    var Order_Date = DateTime.Parse(obj.OrderDate).ToUniversalTime();

                    OrderModel order = new OrderModel(
                          orderId: obj.OrderId,
                          status: obj.Status,
                          bookQuantity:obj.BookQuantity,
                          claimId:obj.ClaimId,
                          discountAmount:obj.DiscountAmount,
                          totalPrice:obj.TotalPrice,
                          claimCode: obj.ClaimCode,
                          orderDate: Order_Date,
                          userId: obj.UserId,
                          bookId: obj.BookId,
                          books: null,
                          users: null
                      );
                    await Database.OrderInfos.AddAsync(order);
                    await Database.SaveChangesAsync();
                    return Ok();
                }
                else
                {
                    return StatusCode(502, "Provide correct format.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Exception caught in login action method.\n{ex.Message}"); // 500 Internal Server Error
            }
        }


        //[Authorize(Policy = "RequireMemberRole")]
        [HttpPost]
        [Route("get_order_details")]
        public async Task<IActionResult> Get_Order_History([FromBody] OrderUserIdDTOModel obj)
        {
            try
            {
                if (ModelState.IsValid)
                {

                    var Order_Data=await Database.OrderInfos.Where(x=>x.UserId==obj.UserId && x.Status!="Compplete").ToListAsync();
                    if (Order_Data.Any())
                    {
                        return Ok(Order_Data);
                    }
                    else
                    {
                        return StatusCode(501,"No oredr present for taht user.");
                    }

                }
                else
                {
                    return StatusCode(502, "Provide correct format.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Exception caught in login action method.\n{ex.Message}"); // 500 Internal Server Error
            }
        }



        //[Authorize(Policy = "RequireMemberRole")]
        [HttpGet]
        [Route("getcartuserbooks")]
        public async Task<IActionResult> GetCartUserBooks()
        {
            try
            {
                var query = @"
                    SELECT 
                        c.""CartId"",
                        c.""AddedAt"",
                        c.""Quantity"",
                        c.""UserId"" AS CartUserId,
                        c.""BookId"" AS CartBookId,
                        u.""UserId"",
                        u.""FirstName"",
                        u.""LastName"",
                        u.""Email"",
                        u.""PhoneNumber"",
                        u.""Role"",
                        bi.""BookId"",
                        bi.""BookName"",
                        bi.""Price"",
                        bi.""Format"",
                        bi.""Title"",
                        bi.""Author"",
                        bi.""Publisher"",
                        bi.""PublicationDate"",
                        bi.""Language"",
                        bi.""Category"",
                        bi.""ListedAt"",
                        bi.""AvailableQuantity"",
                        bi.""DiscountPercent"",
                        bi.""DiscountStart"",
                        bi.""DiscountEnd"",
                        bi.""Photo""
                    FROM ""CartInfos"" c
                    INNER JOIN ""UserInfos"" u ON c.""UserId"" = u.""UserId""
                    INNER JOIN ""BookInfos"" bi ON c.""BookId"" = bi.""BookId""
                ";

                var result = await Database.Database
                    .SqlQueryRaw<CartUserBookDTO>(query)
                    .ToListAsync();

                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    error = "An unexpected error occurred.",
                    message = ex.Message,
                    stackTrace = ex.StackTrace
                });
            }
        }

        //[Authorize(Policy = "RequireMemberRole")]
        [HttpGet]
        [Route("getuserbookmarks")]
        public async Task<IActionResult> GetUserBookmarks()
        {
            try
            {
                var query = @"
                    SELECT 
                        u.""UserId"" AS UserId,
                        u.""FirstName"",
                        u.""LastName"",
                        u.""Email"",
                        u.""PhoneNumber"",
                        u.""Role"",
                        b.""BookmarkId"",
                        b.""UserId"" AS BookmarkUserId,
                        b.""BookId"" AS BookmarkBookId,
                        bi.""BookId"" AS BookId,
                        bi.""BookName"",
                        bi.""Price"",
                        bi.""Format"",
                        bi.""Title"",
                        bi.""Author"",
                        bi.""Publisher"",
                        bi.""PublicationDate"",
                        bi.""Language"",
                        bi.""Category"",
                        bi.""ListedAt"",
                        bi.""AvailableQuantity"",
                        bi.""DiscountPercent"",
                        bi.""DiscountStart"",
                        bi.""DiscountEnd"",
                        bi.""Photo""
                    FROM ""UserInfos"" u
                    INNER JOIN ""BookmarkInfos"" b ON u.""UserId"" = b.""UserId""
                    INNER JOIN ""BookInfos"" bi ON b.""BookId"" = bi.""BookId""
                ";

                var result = await Database.Database
                    .SqlQueryRaw<UserBookmarkBookDTO>(query)
                    .ToListAsync();

                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    error = "An unexpected error occurred.",
                    message = ex.Message,
                    stackTrace = ex.StackTrace
                });
            }
        }


        //[Authorize(Policy = "RequireMemberRole")]
        [HttpGet]
        [Route("getorderuserbooks")]
        public async Task<IActionResult> GetOrderUserBooks()
        {
            try
            {
                var query = @"
                    SELECT 
                        o.""OrderId"",
                        o.""Status"",
                        o.""BookQuantity"",
                        o.""ClaimId"",
                        o.""DiscountAmount"",
                        o.""TotalPrice"",
                        o.""ClaimCode"",
                        o.""OrderDate"",
                        o.""UserId"" AS OrderUserId,
                        o.""BookId"" AS OrderBookId,
                        u.""UserId"",
                        u.""FirstName"",
                        u.""LastName"",
                        u.""Email"",
                        u.""PhoneNumber"",
                        u.""Role"",
                        bi.""BookId"",
                        bi.""BookName"",
                        bi.""Price"",
                        bi.""Format"",
                        bi.""Title"",
                        bi.""Author"",
                        bi.""Publisher"",
                        bi.""PublicationDate"",
                        bi.""Language"",
                        bi.""Category"",
                        bi.""ListedAt"",
                        bi.""AvailableQuantity"",
                        bi.""DiscountPercent"",
                        bi.""DiscountStart"",
                        bi.""DiscountEnd"",
                        bi.""Photo""
                    FROM ""OrderInfos"" o
                    INNER JOIN ""UserInfos"" u ON o.""UserId"" = u.""UserId""
                    INNER JOIN ""BookInfos"" bi ON o.""BookId"" = bi.""BookId""
                ";

                var result = await Database.Database
                    .SqlQueryRaw<OrderUserBookDTO>(query)
                    .ToListAsync();

                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    error = "An unexpected error occurred.",
                    message = ex.Message,
                    stackTrace = ex.StackTrace
                });
            }
        }

        //[Authorize(Policy = "RequireMemberRole")]
        [HttpPost]
        [Route("get_user_details")]
        public async Task<IActionResult> Get_User_Info([FromBody] UserEmailDTOModel obj)
        {
            try
            {
                if (ModelState.IsValid)
                {

                    var User_Data = await Database.UserInfos.FirstOrDefaultAsync(x=>x.Email==obj.Email);
                    if (User_Data!=null)
                    {
                        return Ok(User_Data);
                    }
                    else
                    {
                        return StatusCode(501, "No user present.");
                    }

                }
                else
                {
                    return StatusCode(502, "Provide correct format.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Exception caught in login action method.\n{ex.Message}"); // 500 Internal Server Error
            }
        }

        //[Authorize(Policy = "RequireMemberRole")]
        [HttpDelete]
        [Route("deleteorder")]
        public async Task<IActionResult> Delete_Order_Infos([FromBody] OrderIdDTOModel obj)
        {

            try
            {
                if (ModelState.IsValid)
                {
                    var Order_Data = await Database.OrderInfos.FirstOrDefaultAsync(X => X.OrderId == obj.OrderId);
                    if (Order_Data != null)
                    {
                        var result = Database.OrderInfos.Remove(Order_Data);
                        await Database.SaveChangesAsync();
                        return Ok("Delete order success");

                    }
                    else
                    {
                        return StatusCode(502, "Provide correct order data.");
                    }
                }
                else
                {
                    return StatusCode(503,"Provide correct format.");
                }

            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    error = "An unexpected error occurred.",
                    message = ex.Message,
                    stackTrace = ex.StackTrace
                });
            }
        }

        //[Authorize(Policy = "RequireMemberRole")]
        [HttpGet]
        [Route("get_success_order")]
        public async Task<IActionResult> Get_Success_Order()
        {

            try
            {
                var Order_Data = await Database.OrderInfos.Where(x => x.Status =="Complete").ToListAsync();
                if (Order_Data.Any())
                {
                    return Ok(Order_Data);
                }
                return StatusCode(500, "Database error while getting order info");
            }
            catch (Exception ex)
            {
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
