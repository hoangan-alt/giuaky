using System.Collections.Generic;
using Abp.Domain.Entities;

namespace backend.Toeics
{
    public class Question : Entity<int>
    {
        public int? ExamPartId { get; set; } // Dành cho Part 5 độc lập
        public virtual ExamPart? ExamPart { get; set; }

        public int? PassageGroupId { get; set; } // Dành cho Part 6, 7 theo đoạn văn
        public virtual PassageGroup? PassageGroup { get; set; }

        public int QuestionNumber { get; set; } // Từ 101 đến 200
        public string QuestionText { get; set; } = string.Empty;

        public virtual ICollection<AnswerOption> AnswerOptions { get; set; } = new List<AnswerOption>();
    }
}