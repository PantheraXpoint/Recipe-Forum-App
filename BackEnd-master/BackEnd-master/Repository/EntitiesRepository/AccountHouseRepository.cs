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
    public class AccountHouseRepository : RepositoryBase<AccountHouse>, IAccountHouseRepository
    {
        public AccountHouseRepository(AppDbContext dbContext) : base(dbContext)
        {
        }
    }
}
