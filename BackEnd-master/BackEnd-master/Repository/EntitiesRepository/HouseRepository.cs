using Domain.IEntityRepository;
using Entities;
using Entities.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.EntitiesRepository
{
    public class HouseRepository : RepositoryBase<House>, IHouseRepository
    {
        public HouseRepository(AppDbContext dbContext)
            :base(dbContext)
        {
        }
    }
}
