using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Abp.Application.Services;
using Abp.Domain.Repositories;
using Abp.UI;
using Microsoft.EntityFrameworkCore;

namespace backend.Toeics
{
    public class StudentExamAppService : ApplicationService
    {
        private readonly IRepository<Exam, int> _examRepository;
        private readonly IRepository<ExamAttempt, int> _attemptRepository;
        private readonly IRepository<AnswerOption, int> _optionRepository;
        private readonly IRepository<AttemptAnswer, int> _attemptAnswerRepository;

        public StudentExamAppService(
            IRepository<Exam, int> examRepository,
            IRepository<ExamAttempt, int> attemptRepository,
            IRepository<AnswerOption, int> optionRepository,
            IRepository<AttemptAnswer, int> attemptAnswerRepository)
        {
            _examRepository = examRepository;
            _attemptRepository = attemptRepository;
            _optionRepository = optionRepository;
            _attemptAnswerRepository = attemptAnswerRepository;
        }

        // 1. Lấy đề thi cho sinh viên (Có hoán vị Part 5, ẩn đáp án đúng)
        public async Task<object> GetExamForDoAsync(int examId)
        {
            var exam = await _examRepository.GetAll()
                .Include(e => e.ExamParts)
                    .ThenInclude(p => p.Questions)
                        .ThenInclude(q => q.AnswerOptions)
                .Include(e => e.ExamParts)
                    .ThenInclude(p => p.PassageGroups)
                        .ThenInclude(pg => pg.PassageContents)
                .Include(e => e.ExamParts)
                    .ThenInclude(p => p.PassageGroups)
                        .ThenInclude(pg => pg.Questions)
                            .ThenInclude(q => q.AnswerOptions)
                .FirstOrDefaultAsync(e => e.Id == examId && e.IsPublished);

            if (exam == null) throw new UserFriendlyException("Đề thi không tồn tại hoặc chưa được xuất bản!");

            // Xử lý logic hoán vị lựa chọn cho Part 5
            var rnd = new Random();
            foreach (var part in exam.ExamParts.Where(p => p.PartNumber == 5))
            {
                foreach (var q in part.Questions)
                {
                    // Trộn ngẫu nhiên vị trí các option nhưng giữ nguyên ID để chấm điểm chính xác
                    q.AnswerOptions = q.AnswerOptions.OrderBy(x => rnd.Next()).ToList();
                }
            }

            // Map sang DTO ẩn hoàn toàn trường IsCorrect
            return new
            {
                exam.Id,
                exam.Title,
                exam.DurationMinutes,
                Parts = exam.ExamParts.Select(p => new
                {
                    p.PartNumber,
                    p.Title,
                    Questions = p.Questions.Select(q => new
                    {
                        q.Id,
                        q.QuestionNumber,
                        q.QuestionText,
                        Options = q.AnswerOptions.Select(o => new { o.Id, o.OptionLabel, o.OptionText }) // KHÔNG CÓ IsCorrect
                    }),
                    PassageGroups = p.PassageGroups.Select(pg => new
                    {
                        pg.Id,
                        pg.GroupTitle,
                        Contents = pg.PassageContents.Select(c => new { c.ContentType, c.BodyContent }),
                        Questions = pg.Questions.Select(q => new
                        {
                            q.Id,
                            q.QuestionNumber,
                            q.QuestionText,
                            Options = q.AnswerOptions.Select(o => new { o.Id, o.OptionLabel, o.OptionText })
                        })
                    })
                })
            };
        }

        // 2. Bắt đầu lượt thi mới (Ghi nhận thời gian bắt đầu)
        public async Task<int> StartAttemptAsync(int examId, string studentId)
        {
            var attempt = new ExamAttempt
            {
                ExamId = examId,
                StudentId = studentId,
                StartTime = DateTime.UtcNow,
                IsSubmitted = false
            };
            return await _attemptRepository.InsertAndGetIdAsync(attempt);
        }

        // 3. Nộp bài và chấm điểm tại Backend (Kiểm tra giới hạn 75 phút)
        public async Task<int> SubmitAttemptAsync(int attemptId, Dictionary<int, int> studentAnswers) // Key: QuestionId, Value: SelectedOptionId
        {
            var attempt = await _attemptRepository.GetAsync(attemptId);
            if (attempt.IsSubmitted) throw new UserFriendlyException("Bài thi này đã được nộp trước đó!");

            // Kiểm tra thời hạn 75 phút
            var exam = await _examRepository.GetAsync(attempt.ExamId);
            if (DateTime.UtcNow > attempt.StartTime.AddMinutes(exam.DurationMinutes + 1)) // Cho phép dư 1 phút mạng
            {
                throw new UserFriendlyException("Đã quá thời gian làm bài 75 phút quy định!");
            }

            int score = 0;
            attempt.SubmitTime = DateTime.UtcNow;
            attempt.IsSubmitted = true;

            foreach (var answer in studentAnswers)
            {
                int questionId = answer.Key;
                int selectedOptionId = answer.Value;

                var correctOption = await _optionRepository.FirstOrDefaultAsync(o => o.QuestionId == questionId && o.IsCorrect);
                bool isCorrect = (correctOption != null && correctOption.Id == selectedOptionId);

                if (isCorrect) score++;

                await _attemptAnswerRepository.InsertAsync(new AttemptAnswer
                {
                    ExamAttemptId = attemptId,
                    QuestionId = questionId,
                    SelectedOptionId = selectedOptionId,
                    IsCorrect = isCorrect
                });
            }

            attempt.TotalScore = score;
            await _attemptRepository.UpdateAsync(attempt);
            return score;
        }
    }
}