using Entities.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.IEntityRepository
{
    public interface IAccountRepository : IRepositoryBase<Account>
    {
        public void Register(Account newAccount);
        public Task<Account> GetByEmail(string email);
    }
}
