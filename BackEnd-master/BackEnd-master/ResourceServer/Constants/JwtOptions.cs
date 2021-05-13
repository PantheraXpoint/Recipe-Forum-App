using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ResourceServer.Constants
{
    public class JwtOptions
    {
        public int AccessTokenExpireTime { get; set; }
        public string AccessTokenSecretKey { get; set; }
        public string Issuer { get; set; }
        public string Audience { get; set; }
    }
}
