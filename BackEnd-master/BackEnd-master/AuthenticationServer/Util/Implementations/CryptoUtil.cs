using AuthenticationServer.Constants;
using AuthenticationServer.Util.Interfaces;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Threading.Tasks;

namespace AuthenticationServer.Util.Implementations
{
    public class CryptoUtil: ICryptoUtil
    {
        private readonly PasswordOptions _options;

        public CryptoUtil(IOptions<PasswordOptions> options)
        {
            _options = options.Value;
        }

        public bool CheckValidPassword(string hash, string password)
        {
            var parts = hash.Split(".");
            if(parts.Length != 3)
            {
                throw new Exception("Invalid Hash Format");
            }
            var itergarions = Convert.ToInt32(parts[0]);
            var salt = Convert.FromBase64String(parts[1]);
            var key = Convert.FromBase64String(parts[2]);


            using (var algorithm = new Rfc2898DeriveBytes(
                    password,
                    salt,
                    itergarions
                  )
            )
            {
                var keyToCheck = algorithm.GetBytes(_options.KeySize);
                return keyToCheck.SequenceEqual(key);
            };

        }

        public string HashPassword(string password)
        {
            using (var algorithm = new Rfc2898DeriveBytes(
                    password,
                    _options.SaltSize,
                    _options.Iterations
                  )
            ) 
            {
                var key = Convert.ToBase64String(algorithm.GetBytes(_options.KeySize));
                var salt = Convert.ToBase64String(algorithm.Salt);
                return $"{_options.Iterations}.{salt}.{key}";
            };
            
        }
    }
}
