using AuthenticationServer.Models.Request;
using AuthenticationServer.Models.Response;
using AuthenticationServer.Models.ViewModels;
using Entities.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AuthenticationServer.Services.Interfaces
{
    public interface IAuthenticationService
    {
        Task<ResponseBase<AccountViewModel>> Register(RegisterRequest registerRequest);
        Task<ResponseBase<LoginReponse>> Login(LoginRequest loginRequest);
    }
}
