using AuthenticationServer.Models.Request;
using AuthenticationServer.Models.Response;
using AuthenticationServer.Models.ViewModels;
using AuthenticationServer.Services.Interfaces;
using AuthenticationServer.Util.Interfaces;
using AutoMapper;
using Domain;
using Entities.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;

using System.Threading.Tasks;

namespace AuthenticationServer.Services
{

    public class AuthenticationService: IAuthenticationService
    {
        private readonly IRepositoryWrapper _repoWrapper;
        private readonly IMapper _mapper;
        private readonly ICryptoUtil _cryptoUtil;
        private readonly IJwtService _jwtService;

        public AuthenticationService(
            IRepositoryWrapper repoWrapper,IMapper mapper,
            ICryptoUtil cryptoUtil, IJwtService jwtService
            )
        {
            _repoWrapper = repoWrapper;
            _mapper = mapper;
            _cryptoUtil = cryptoUtil;
            _jwtService = jwtService;
        }

        public async Task<ResponseBase<AccountViewModel>> Register(RegisterRequest registerRequest)
        {
            ResponseBase<AccountViewModel> response = new ResponseBase<AccountViewModel>();
            try
            {
                Account account = await _repoWrapper.Account.GetByEmail(registerRequest.Email);
                if (account != null)
                {
                    response.Message = "This email already exist";
                    response.Status = -1;
                    response.Data = null;
                    return response;
                }

                registerRequest.Password = _cryptoUtil.HashPassword(registerRequest.Password);

                Account newAccount = _mapper.Map<Account>(registerRequest);

                _repoWrapper.Account.Register(newAccount);
                bool result = await _repoWrapper.SaveAsync();

                if (result)
                {
                    response.Message = "Success";
                    response.Status = 200;
                    response.Data = _mapper.Map<AccountViewModel>(newAccount);
                    return response;
                }

                response.Message = "Fail to create new Account";
                response.Status = 400;
                response.Data = null;
                return response;

            }
            catch(Exception ex)
            {
                response.Message = "Fail to create new Account: " + ex.Message;
                response.Status = 500;
                response.Data = null;
                return response;
            }
        }

        public async Task<ResponseBase<LoginReponse>> Login(LoginRequest loginRequest)
        {
            ResponseBase<LoginReponse> response = new ResponseBase<LoginReponse>();
            
            try
            {
                var user = await _repoWrapper.Account.FindByCondition(a => a.Email == loginRequest.Email)                                  
                    .FirstOrDefaultAsync();
                if(user == null)
                {
                    response.Message = "Invalid credentials";
                    response.Status = 401;
                    response.Data = null;
                    return response;
                }

                bool isCorrectPassword = _cryptoUtil.CheckValidPassword(user.Password, loginRequest.Password);

                if (!isCorrectPassword)
                {
                    response.Message = "Invalid credentials";
                    response.Status = 401;
                    response.Data = null;
                    return response;
                }

                string accessToken = _jwtService.GenerateToken(user);
                response.Message = "Success";
                response.Data.AccessToken = accessToken;
                response.Status = 200;

                return response;
            }catch(Exception ex)
            {
                response.Message = ex.Message;
                response.Status = 500;
                response.Data = null;
                return response;
            }

        }

    }
}
