using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Models
{
    public class AccountHouse
    {
        public int AccountId { get; set; }
        public Account Account { get; set; }
        public int HouseId { get; set; }
        public House House { get; set; }
    }
}
