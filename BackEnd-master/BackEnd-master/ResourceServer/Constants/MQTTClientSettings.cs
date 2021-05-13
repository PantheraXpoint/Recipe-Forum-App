using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ResourceServer.Constants
{
    public class MQTTClientSettings
    {
        public string Id { set; get; }
        public string UserName { set; get; }
        public string Password { set; get; }
        public List<string> SubcribeList { get; set; }
    }
}
