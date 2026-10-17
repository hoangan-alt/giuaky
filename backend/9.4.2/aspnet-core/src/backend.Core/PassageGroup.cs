using System.Collections.Generic;
using Abp.Domain.Entities;

namespace backend.Toeics
{
    public class PassageGroup : Entity<int>
    {
        public int ExamPartId { get; set; }
        public virtual ExamPart ExamPart { get; set; } = null!;
        public string? GroupTitle { get; set; }

        public virtual ICollection<PassageContent> PassageContents { get; set; } = new List<PassageContent>();
        public virtual ICollection<Question> Questions { get; set; } = new List<Question>();
    }
}