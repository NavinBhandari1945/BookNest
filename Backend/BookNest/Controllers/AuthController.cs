using BookNest.Data;
using BookNest.Models;
using BookNest.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BookNest.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {

        public DatabaseController Database { get; set; }
        public TokenServices TokenServices { get; set; }

        public AuthController(DatabaseController Database, TokenServices TokenServices)
        {
            this.Database = Database;
            this.TokenServices = TokenServices;
        }

        [HttpPost]
        [Route("register")]
        public async Task<IActionResult> LoginUser([FromBody] UserInfosModel obj)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var userInfo = await Database.UserInfos.ToListAsync();
                    if (userInfo.Any())
                    {
                        // Check if email already exists
                        if (await Database.UserInfos.AnyAsync(u => u.Email == obj.Email))
                        {
                            return StatusCode(502,"Email is already taken");
                        }

                        // Check if PhoneNumber already exists
                        if (await Database.UserInfos.AnyAsync(u => u.PhoneNumber == obj.PhoneNumber))
                        {
                            return StatusCode(503,"PhoneNumber is already registered");
                        }

                        if (!await Database.UserInfos.AnyAsync(u=>u.Role=="Admin"))
                        {

                            obj.Password = BCrypt.Net.BCrypt.HashPassword(obj.Password);
                            UserInfosModel UserDataAdmin = new UserInfosModel
                                (
                                        UserId:obj.UserId,           
                                        FirstName:obj.FirstName,                 
                                        LastName: obj.LastName,           
                                        Email: obj.Email,           
                                        PhoneNumber: obj.PhoneNumber,      
                                        Password: obj.Password,           
                                        Role: "Admin"                      
                                );
                            await Database.UserInfos.AddAsync(UserDataAdmin);
                            await Database.SaveChangesAsync();
                            return Ok(new { UserDataAdmin, Message = "User registered as admin." });

                        }
                        obj.Password = BCrypt.Net.BCrypt.HashPassword(obj.Password);
                        UserInfosModel UserDataMember = new UserInfosModel
                         (
                                 UserId: obj.UserId,
                                 FirstName: obj.FirstName,
                                 LastName: obj.LastName,
                                 Email: obj.Email,
                                 PhoneNumber: obj.PhoneNumber,
                                 Password: obj.Password,
                                 Role:"Member"
                         );
                        await Database.UserInfos.AddAsync(UserDataMember); 
                        await Database.SaveChangesAsync();
                        return Ok(new { UserDataMember, Message = "User registered as member." });
                    
                    }
                    else
                    {
                        obj.Password = BCrypt.Net.BCrypt.HashPassword(obj.Password);
                        UserInfosModel UserDataAdmin = new UserInfosModel
                            (
                                    UserId: obj.UserId,
                                    FirstName: obj.FirstName,
                                    LastName: obj.LastName,
                                    Email: obj.Email,
                                    PhoneNumber: obj.PhoneNumber,
                                    Password: obj.Password,
                                    Role: "Admin"
                            );
                        await Database.UserInfos.AddAsync(UserDataAdmin);
                        await Database.SaveChangesAsync();
                        return Ok(new { UserDataAdmin, Message = "User registered as admin." });

                    }
                }
                else
                {
                    return StatusCode(501, "The provided data is not in correct format."); // 400 Bad Request with validation errors
                }
            }
            catch (Exception excep)           
            {
              
                return StatusCode(500, $"Exception caught={excep.ToString()}");
            }

        }


        [HttpGet]
        [Route("jwtverify")]
        [Authorize(Policy = "RequireStafforAdminorMemberRole")]
        public async Task<ActionResult> VerifyToken()
        {
            try
            {
                return Ok();
            }
            catch (Exception ex)
            {
                return StatusCode(500);
            }

        }

        //[HttpPost]
        //[Route("login")]
        //public async Task<IActionResult> LoginUser([FromBody] LoginModel obj)
        //{
        //    try
        //    {
        //        if (ModelState.IsValid)
        //        {
        //            // Check if the user exists
        //            var user_data = await database.Signininfos.FirstOrDefaultAsync(x => x.Username == obj.Username);

        //            if (user_data != null)
        //            {
        //                // Validate password (assuming you store hashed passwords)
        //                if (user_data.Password == HashPassword(obj.Password))
        //                {
        //                    // Generate token
        //                    string token = GenerateToken();
        //                    // Return response
        //                    return Ok(new
        //                    {
        //                        token = token,
        //                        username = user_data.Username,
        //                        usertype = user_data.Type
        //                    });
        //                }
        //                else
        //                {
        //                    return StatusCode(503, "Invalid password.");
        //                }
        //            }
        //            else
        //            {
        //                return StatusCode(501, "No user with the provided username not found.");
        //            }
        //        }
        //        else
        //        {
        //            return StatusCode(502, "Provide correct format.");
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        return StatusCode(500, $"Exception caught in login action method.\n{ex.Message}"); // 500 Internal Server Error
        //    }
        //}







    }
}
