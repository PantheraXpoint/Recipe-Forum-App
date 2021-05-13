using AuthenticationServer.Constants;
using AuthenticationServer.Services.Interfaces;
using Entities.Models;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace AuthenticationServer.Services.Implementation
{
    public class JwtService : IJwtService
    {
        private readonly JwtOptions _jwtOptions;
        public JwtService(IOptions<JwtOptions> jwtOptions)
        {
            _jwtOptions = jwtOptions.Value;
        }

        public string GenerateToken(Account account)
        {

            var securityKey = new Microsoft
            .IdentityModel.Tokens.SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtOptions.SecretKey));

            SigningCredentials credentials = new SigningCredentials(
                    securityKey,
                    SecurityAlgorithms.HmacSha256
                );


            List<Claim> claims = new List<Claim>
            {
                new Claim("Id",account.Id.ToString()),
                new Claim(ClaimTypes.Email, account.Email),
                new Claim(ClaimTypes.MobilePhone, account.PhoneNumber)
            };
        

            JwtSecurityToken token = new JwtSecurityToken(
                _jwtOptions.Issuer,
                _jwtOptions.Audience,
                claims,
                DateTime.UtcNow,
                DateTime.UtcNow.AddMinutes(30),
                credentials
                );



            return  new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
