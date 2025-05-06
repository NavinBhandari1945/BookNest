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
    public class AuthController : ControllerBase
    {
     

        public DatabaseController Database { get; set; }
        public TokenServices TokenServices { get; set; }

        public AuthController(DatabaseController Database, TokenServices TokenServices)
        {
            this.Database = Database;
            this.TokenServices = TokenServices;
       
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

                            var Encrypted_Password_Admin = HashPassword(obj.Password);
                            if(Encrypted_Password_Admin!="" && Encrypted_Password_Admin!=null)
                            {
                                UserInfosModel UserDataAdmin = new UserInfosModel
                          (
                                  UserId: obj.UserId,
                                  FirstName: obj.FirstName,
                                  LastName: obj.LastName,
                                  Email: obj.Email,
                                  PhoneNumber: obj.PhoneNumber,
                                  Password: Encrypted_Password_Admin,
                                  Role: "Admin"
                          );
                                await Database.UserInfos.AddAsync(UserDataAdmin);
                                await Database.SaveChangesAsync();
                                return Ok(new { UserDataAdmin, Message = "User registered as admin." });
                            }
                            else
                            {
                                return StatusCode(502,"Encrypting password fail.");
                            }
                      

                        }
                        var Encrypted_Password_Member =HashPassword(obj.Password);
                        if (Encrypted_Password_Member != "" && Encrypted_Password_Member != null)
                        {
                            UserInfosModel UserDataMember = new UserInfosModel
                      (
                              UserId: obj.UserId,
                              FirstName: obj.FirstName,
                              LastName: obj.LastName,
                              Email: obj.Email,
                              PhoneNumber: obj.PhoneNumber,
                              Password: Encrypted_Password_Member,
                              Role: "Member"
                      );
                            await Database.UserInfos.AddAsync(UserDataMember);
                            await Database.SaveChangesAsync();
                            return Ok(new { UserDataMember, Message = "User registered as member." });

                        }
                        else
                        {
                            return StatusCode(502, "Encrypting password fail.");
                        }

                    }
                    else
                    {
                        var Encrypted_Password =HashPassword(obj.Password);
                        if (Encrypted_Password!=null && Encrypted_Password!="")
                        {
                            UserInfosModel UserDataAdmin = new UserInfosModel
                       (
                               UserId: obj.UserId,
                               FirstName: obj.FirstName,
                               LastName: obj.LastName,
                               Email: obj.Email,
                               PhoneNumber: obj.PhoneNumber,
                               Password: Encrypted_Password,
                               Role: "Admin"
                       );
                            await Database.UserInfos.AddAsync(UserDataAdmin);
                            await Database.SaveChangesAsync();
                            return Ok(new { UserDataAdmin, Message = "User registered as admin." });
                        }
                        else
                        {
                            return StatusCode(502, "Encrypting password fail.");
                        }


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

        [HttpPost]
        [Route("login")]
        public async Task<IActionResult> LoginUser([FromBody] LoginDTOModel obj)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    // Check if the user exists
                    var user_data = await Database.UserInfos.FirstOrDefaultAsync(x => x.Email == obj.Email);

                    if (user_data != null)
                    {
                        var Encrypted_Password =HashPassword(obj.Password);
                        Console.WriteLine("encrypted passsword");
                        Console.WriteLine(Encrypted_Password);
                        // Validate password (assuming you store hashed passwords)
                        if (user_data.Password ==Encrypted_Password)
                        {
                            // Generate token
                            string token = TokenServices.GenerateTokenUser(user_data);
                            // Return response
                            return Ok(new
                            {
                                Token = token,
                                Email = user_data.Email,
                                Role = user_data.Role
                            });
                        }
                        else
                        {
                            return StatusCode(503, "Invalid password.");
                        }
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
                return StatusCode(500, $"Exception caught in login action method.\n{ex.Message}"); // 500 Internal Server Error
            }
        }







    }
}
