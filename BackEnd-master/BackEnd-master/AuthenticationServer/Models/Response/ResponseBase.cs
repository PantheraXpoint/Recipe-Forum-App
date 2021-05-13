using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Threading.Tasks;

namespace AuthenticationServer.Models.Response
{
    public class ResponseBase<T> where T : class, new()
    {
        private T data = new();

        public T Data 
        {
            get
            {
                return data;
            }
            set
            {
                data = value;
            }
        }

        public int Status { get; set; }
        public string Message { get; set; }

    }
}
