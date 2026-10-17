using System;
using System.Collections.Generic;
using Abp.Domain.Entities.Auditing;

namespace backend.Toeics
{
    public class Exam : FullAuditedEntity<int>
    {
        public string Title { get; set; } = string.Empty;
        public int DurationMinutes { get; set; } = 75; // Mặc định 75 phút
        public bool IsPublished { get; set; } = false; // Trạng thái xuất bản
        
        public virtual ICollection<ExamPart> ExamParts { get; set; } = new List<ExamPart>();
    }
}