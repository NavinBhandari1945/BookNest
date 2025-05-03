using BookNest.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

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
        //[HttpPost]
        //[Route("change_user_role")]


    }
}
