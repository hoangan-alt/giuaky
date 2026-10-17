using Abp.Domain.Entities;

namespace backend.Toeics
{
    public class PassageContent : Entity<int>
    {
        public int PassageGroupId { get; set; }
        public virtual PassageGroup PassageGroup { get; set; } = null!;
        public string ContentType { get; set; } = "Text"; // Text hoặc Image
        public string BodyContent { get; set; } = string.Empty;
    }
}