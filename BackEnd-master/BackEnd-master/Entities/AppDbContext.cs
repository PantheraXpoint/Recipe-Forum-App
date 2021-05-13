using Entities.Models;
using Microsoft.EntityFrameworkCore;
using System;

namespace Entities
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions options)
            : base(options)
        {

        }

        public DbSet<Account> Accounts { get; set; }
        public DbSet<AccountHouse> AccountHouses { get; set; }
        public DbSet<House> Houses { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Account>(entity =>
            {

            });

            modelBuilder.Entity<AccountHouse>(entity =>
            {
                entity.HasKey(ah => new { ah.AccountId , ah.HouseId });
            });

            modelBuilder.Entity<House>(entity =>
            {

            });
        }
    }

}
   

