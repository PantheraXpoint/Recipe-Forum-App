using Entities.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AuthenticationServer.Services.Interfaces
{
    public interface IJwtService
    {
        public string GenerateToken(Account account);
    }
}
