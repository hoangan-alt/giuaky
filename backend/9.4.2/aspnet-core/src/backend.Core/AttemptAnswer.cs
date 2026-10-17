using Abp.Domain.Entities;

namespace backend.Toeics
{
    public class AttemptAnswer : Entity<int>
    {
        public int ExamAttemptId { get; set; }
        public virtual ExamAttempt ExamAttempt { get; set; } = null!;
        public int QuestionId { get; set; }
        public int? SelectedOptionId { get; set; }
        public bool IsCorrect { get; set; } = false;
    }
}