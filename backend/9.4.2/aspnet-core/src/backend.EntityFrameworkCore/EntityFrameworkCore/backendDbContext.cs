using Microsoft.EntityFrameworkCore;
using Abp.Zero.EntityFrameworkCore;
using backend.Authorization.Roles;
using backend.Authorization.Users;
using backend.MultiTenancy;
using backend.Toeics; // Thêm namespace chứa các entity TOEIC

namespace backend.EntityFrameworkCore
{
    public class backendDbContext : AbpZeroDbContext<Tenant, Role, User, backendDbContext>
    {
        /* Define a DbSet for each entity of the application */
        public DbSet<Exam> Exams { get; set; }
        public DbSet<ExamPart> ExamParts { get; set; }
        public DbSet<PassageGroup> PassageGroups { get; set; }
        public DbSet<PassageContent> PassageContents { get; set; }
        public DbSet<Question> Questions { get; set; }
        public DbSet<AnswerOption> AnswerOptions { get; set; }
        public DbSet<ExamAttempt> ExamAttempts { get; set; }
        public DbSet<AttemptAnswer> AttemptAnswers { get; set; }

        public backendDbContext(DbContextOptions<backendDbContext> options)
            : base(options)
        {
        }
    }
}