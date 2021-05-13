using AuthenticationServer.Constants;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AuthenticationServer.Extensions
{
    public static class ServiceConfigOptions
    {
        public static void LoadAppSetting(this IServiceCollection services, IConfiguration configuration) 
        {
            services.Configure<PasswordOptions>(configuration.GetSection("PasswordOptions"));
            services.Configure<JwtOptions>(configuration.GetSection("JwtOptions"));
        }
    }
}
