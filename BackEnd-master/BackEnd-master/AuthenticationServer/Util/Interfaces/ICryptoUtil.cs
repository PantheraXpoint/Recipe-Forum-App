using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AuthenticationServer.Util.Interfaces
{
    public interface ICryptoUtil
    {
        public string HashPassword(string password);
        public bool CheckValidPassword(string hash, string password);
    }
}
