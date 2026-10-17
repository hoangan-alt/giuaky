using System.Collections.Generic;
using Abp.Domain.Entities;

namespace backend.Toeics
{
    public class ExamPart : Entity<int>
    {
        public int ExamId { get; set; }
        public virtual Exam Exam { get; set; } = null!;
        public int PartNumber { get; set; } // 5, 6, hoặc 7
        public string? Title { get; set; }

        public virtual ICollection<PassageGroup> PassageGroups { get; set; } = new List<PassageGroup>();
        public virtual ICollection<Question> Questions { get; set; } = new List<Question>();
    }
}