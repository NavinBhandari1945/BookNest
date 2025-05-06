using BookNest.Data;
using BookNest.Models.DTOModels;
using BookNest.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BookNest.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StaffController : ControllerBase
    {
      

        public DatabaseController Database { get; set; }
        public ILogger<StaffController> Logger { get; }

        public StaffController(DatabaseController Database, ILogger<StaffController> logger)
        {
            this.Database = Database;
            Logger = logger;
        }

        //[Authorize(Policy = "RequireStaffRole")]
        [HttpPost]
        [Route("claim_code")]
        public async Task<IActionResult> Add_Bookmark([FromBody] ClaimCodeDTOModel obj)
        {
            try
            {
                if (ModelState.IsValid)
                {

                    var Order_Data = await Database.OrderInfos.FirstOrDefaultAsync(x => x.OrderId == obj.OrderId && x.ClaimId==obj.ClaimId && x.ClaimCode==obj.ClaimCode);
                    if (Order_Data != null)
                    {
                        Order_Data.Status = "Complete";
                        await Database.SaveChangesAsync();
                        return Ok();

                    }
                    else
                    {
                        return StatusCode(503, "Order doesn't exist.");
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
