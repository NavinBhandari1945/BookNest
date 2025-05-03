using BookNest.Data;
using BookNest.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

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





    }
}
