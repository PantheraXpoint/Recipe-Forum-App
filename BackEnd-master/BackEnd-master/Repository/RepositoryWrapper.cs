using Domain;
using Domain.IEntityRepository;
using Entities;
using Microsoft.EntityFrameworkCore;
using Repository.EntitiesRepository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public class RepositoryWrapper : IRepositoryWrapper
    {

        private AppDbContext _dbContext;
        private IAccountRepository _account;
        private IAccountHouseRepository _accountHouseRepository;
        private IHouseRepository _houseRepository;

        public RepositoryWrapper(AppDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public IAccountRepository Account
        {
            get
            {
                if (_account == null)
                {
                    _account = new AccountRepository(_dbContext);
                }
                return _account;
            }
        }

        public IHouseRepository House
        {
            get
            {
                if (_houseRepository == null)
                {
                    _houseRepository = new HouseRepository(_dbContext);
                }
                return _houseRepository;
            }
        }

        public IAccountHouseRepository AccountHouse
        {
            get
            {
                if (_accountHouseRepository == null)
                {
                    _accountHouseRepository = new AccountHouseRepository(_dbContext);
                }
                return _accountHouseRepository;
            }
        }


        public bool Save()
        {
            return _dbContext.SaveChanges() >= 0;
        }

        public async Task<bool> SaveAsync()
        {
            return await _dbContext.SaveChangesAsync() >= 0;
        }
    }
}
