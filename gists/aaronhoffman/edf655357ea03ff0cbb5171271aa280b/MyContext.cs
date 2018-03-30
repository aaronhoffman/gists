using MyProject.Models;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;

namespace MyProject.Data
{
    public class MyContext : DbContext
    {
        public MyContext(string connectionString)
            : base(connectionString)
        {
            // Do not attempt to create database
            Database.SetInitializer<MyContext>(null);
        }

        public DbSet<MyModel> MyModels { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            // table names are not plural in DB, remove the convention
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();

            base.OnModelCreating(modelBuilder);
        }
    }
}