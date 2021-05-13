using Domain.IEntityRepository;
using Entities;
using Entities.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.EntitiesRepository
{
    public class AccountRepository : RepositoryBase<Account>, IAccountRepository
    {
        public AccountRepository(AppDbContext dbContext)
            : base(dbContext)
        {

        }

        public async Task<Account> GetByEmail(string email)
        {
            return await FindByCondition(a => a.Email == email).FirstOrDefaultAsync();
        }

        public void Register(Account newAccount)
        {
            Create(newAccount);
        }
    }
}
