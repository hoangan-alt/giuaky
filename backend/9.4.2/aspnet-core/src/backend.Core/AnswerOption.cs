using Abp.Domain.Entities;

namespace backend.Toeics
{
    public class AnswerOption : Entity<int>
    {
        public int QuestionId { get; set; }
        public virtual Question Question { get; set; } = null!;
        public char OptionLabel { get; set; } // 'A', 'B', 'C', 'D'
        public string OptionText { get; set; } = string.Empty;
        public bool IsCorrect { get; set; } // Đúng/Sai (Ẩn đi với sinh viên)
    }
}