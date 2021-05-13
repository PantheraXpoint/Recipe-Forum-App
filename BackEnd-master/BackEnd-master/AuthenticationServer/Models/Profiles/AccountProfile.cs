using AuthenticationServer.Models.Request;
using AuthenticationServer.Models.ViewModels;
using AutoMapper;
using Entities.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AuthenticationServer.Models.Profiles
{
    public class AccountProfile : Profile
    {
        public AccountProfile()
        {
            CreateMap<Account, AccountViewModel>();
            CreateMap<RegisterRequest, Account>();
        }
    }
}
