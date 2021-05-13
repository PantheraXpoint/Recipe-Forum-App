using Domain.IEntityRepository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain
{
    public interface IRepositoryWrapper
    {
        IAccountRepository Account { get; }
        IHouseRepository House { get; }
        IAccountHouseRepository AccountHouse { get; }

        bool Save();
        Task<bool> SaveAsync();

    }
}
