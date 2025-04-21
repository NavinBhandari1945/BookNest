using BookNest.Models;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace BookNest.Services
{
    public class TokenServices
    {

        private readonly IConfiguration _configuration;

        public TokenServices(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public string GenerateTokenUser(UserInfosModel user)
        {
            try
            {
                var base64Key = _configuration["JwtSettings:Secret"];
                var issuer = _configuration["JwtSettings:Issuer"];
                var audience = _configuration["JwtSettings:Audience"];

                var keyBytes = Convert.FromBase64String(base64Key ?? "JWT secret not configured.");
                var key = new SymmetricSecurityKey(keyBytes);

                var claims = new List<Claim>
                            {
                                new Claim(ClaimTypes.NameIdentifier, user.UserId.ToString()),
                                new Claim(ClaimTypes.Name, user.FirstName),
                                new Claim(ClaimTypes.Email, user.Email),
                                new Claim(ClaimTypes.Role, user.Role),
                            };

                var tokenDescription = new SecurityTokenDescriptor
                {
                    Subject = new ClaimsIdentity(claims),
                    Expires = DateTime.UtcNow.AddDays(1),
                    Issuer = issuer,
                    Audience = audience,
                    SigningCredentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256Signature)
                };

                var tokenHandler = new JwtSecurityTokenHandler();
                var token = tokenHandler.CreateToken(tokenDescription);

                if (token != null)
                {
                    return tokenHandler.WriteToken(token);
                }
                else
                {
                    return null;
                }
            }
            catch (Exception obj)
            {
                Console.WriteLine(obj.ToString());
                return null;

            }
        }




    }
}
