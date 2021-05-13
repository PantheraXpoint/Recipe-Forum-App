using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AuthenticationServer.Models.Response
{
    public class FormErrorResponse
    {
        public IEnumerable<string> ErrorMessages { get; set; }
        public FormErrorResponse(string errorMessage) : this(new List<string>() { errorMessage }) { }
        
        public FormErrorResponse(IEnumerable<string> errorMessages)
        {
            ErrorMessages = errorMessages;
        }
    }
}
