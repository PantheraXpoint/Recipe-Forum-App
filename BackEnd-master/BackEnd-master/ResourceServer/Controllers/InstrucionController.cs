using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace ResourceServer.Controllers
{
    [Route("api/instrucion")]
    [ApiController]
    public class InstrucionController : Controller
    {

        public InstrucionController()
        {

        }  


        [HttpGet()]
        [Authorize]
        public IActionResult Index()
        {

            string id = HttpContext.User.FindFirstValue("Id");
            string email = HttpContext.User.FindFirstValue(ClaimTypes.Email);
            string phone = HttpContext.User.FindFirstValue(ClaimTypes.MobilePhone);

            return Ok(new { 
                Id = id,
                Email = email,
                Phone = phone
            });
        }
    }
}
