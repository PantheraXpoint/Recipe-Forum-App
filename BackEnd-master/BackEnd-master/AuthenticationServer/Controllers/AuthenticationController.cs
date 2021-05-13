using AuthenticationServer.Models.Request;
using AuthenticationServer.Models.Response;
using AuthenticationServer.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AuthenticationServer.Controllers
{
    [Route("api/authentication")]
    [ApiController]
    public class AuthenticationController : Controller
    {
        private readonly IAuthenticationService _authenticationService;
        
        public AuthenticationController(IAuthenticationService authenticationService)
        {
            _authenticationService = authenticationService;
        }


        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequest registerRequest)
        {
            var result = await _authenticationService.Register(registerRequest);

            if(result.Status == 200)
            {
                return Ok(result);
            }

            else if(result.Status == 500)
            {
                Response.StatusCode = StatusCodes.Status500InternalServerError;
                return Json(result);
            }

            Response.StatusCode = 400;
            return Json(result);

        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest registerRequest)
        {
            var result = await _authenticationService.Login(registerRequest);

            if (result.Status == 200)
            {
                return Ok(result);
            }

            else if (result.Status == 500)
            {
                Response.StatusCode = StatusCodes.Status500InternalServerError;
                return Json(result);
            }

            Response.StatusCode = 400;
            return Json(result);
        }

    }
}
