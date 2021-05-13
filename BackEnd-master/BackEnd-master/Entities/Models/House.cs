using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Models
{
    [Table("House")]
    public class House
    {
        public int Id { get; set; }
        public int? Name { get; set; }
        public string Address { get; set; }
        public double? Longtitude { get; set; }
        public double? Latitude { get; set; }

        public virtual ICollection<AccountHouse> Accounts { get; set; }
    }
}
