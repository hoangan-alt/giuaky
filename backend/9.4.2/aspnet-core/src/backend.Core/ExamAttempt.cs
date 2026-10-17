using System;
using System.Collections.Generic;
using Abp.Domain.Entities;

namespace backend.Toeics
{
    public class ExamAttempt : Entity<int>
    {
        public int ExamId { get; set; }
        public virtual Exam Exam { get; set; } = null!;
        public string StudentId { get; set; } = string.Empty;
        public DateTime StartTime { get; set; } = DateTime.UtcNow;
        public DateTime? SubmitTime { get; set; }
        public int TotalScore { get; set; } = 0;
        public bool IsSubmitted { get; set; } = false;

        public virtual ICollection<AttemptAnswer> AttemptAnswers { get; set; } = new List<AttemptAnswer>();
    }
}