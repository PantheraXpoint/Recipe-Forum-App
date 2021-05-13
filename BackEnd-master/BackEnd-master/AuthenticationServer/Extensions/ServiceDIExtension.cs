using AuthenticationServer.Services;
using AuthenticationServer.Services.Implementation;
using AuthenticationServer.Services.Interfaces;
using AuthenticationServer.Util.Implementations;
using AuthenticationServer.Util.Interfaces;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AuthenticationServer.Extensions
{
    public static class ServiceDIExtension
    {
        public static void ConfigDI (this IServiceCollection services)
        {
            services.AddScoped<IAuthenticationService, AuthenticationService>();
            services.AddScoped<ICryptoUtil, CryptoUtil>();
            services.AddScoped<IJwtService, JwtService>();
        }

        

    }
}
