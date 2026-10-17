import '../models/exam.dart';

class MockData {
  static List<Exam> getExams() {
    return [
      Exam(
        id: 'exam-01',
        title: 'TOEIC Reading Practice 01',
        description: 'Đề luyện tổng hợp 3 phần: Ngữ pháp, điền đoạn văn và đọc hiểu thực tế.',
        status: ExamStatus.draft,
        updatedAt: '16/10/2026',
      ),
      Exam(
        id: 'exam-02',
        title: 'TOEIC Reading Practice 02',
        description: 'Rèn kỹ năng ngữ pháp và đọc hiểu qua các tình huống công việc thực tế.',
        status: ExamStatus.published,
        updatedAt: '15/10/2026',
      ),
      Exam(
        id: 'exam-03',
        title: 'TOEIC Reading Practice 03',
        description: 'Tập trung vào từ vựng chuyên ngành kinh tế và thư từ thương mại.',
        status: ExamStatus.unpublished,
        updatedAt: '14/10/2026',
      ),
      Exam(
        id: 'exam-04',
        title: 'TOEIC Reading Practice 04',
        description: 'Bài kiểm tra chuyên sâu các dạng câu hỏi suy luận và tìm thông tin nhanh.',
        status: ExamStatus.draft,
        updatedAt: '13/10/2026',
      ),
      Exam(
        id: 'exam-05',
        title: 'TOEIC Reading Practice 05',
        description: 'Thử sức với email, thông báo và các nhóm bài đọc nhiều tài liệu.',
        status: ExamStatus.published,
        updatedAt: '12/10/2026',
      ),
      Exam(
        id: 'exam-06',
        title: 'TOEIC Reading Practice 06',
        description: 'Đề thi nhập từ reading_practice_06.docx (đang kiểm tra định dạng).',
        status: ExamStatus.draft,
        updatedAt: '11/10/2026',
      ),
    ];
  }

  static ReadingPassage getMockPassage176to180() {
    return ReadingPassage(
      id: 'passage-176-180',
      title: 'Nhóm câu 176–180 · Nhiều tài liệu',
      instruction: 'Questions 176–180 refer to the following notice, e-mail, and schedule.',
      documents: [
        ReadingDocument(
          title: 'Notice: Annual Leadership Workshop',
          type: 'notice',
          content: 'Apex Corporate Consulting cordially invites all senior project managers to our Annual Leadership Development Workshop. The session will take place at the Grand Oak Conference Center on Friday, October 24.\n\nAll registered participants will receive an official certification portfolio upon completion of the final session. Please note that lunch will be catered on-site from 12:15 PM to 1:30 PM.',
          metadata: {
            'Venue': 'Grand Oak Conference Center, Room 402',
            'Date': 'Friday, October 24',
            'Host': 'Director of Human Resources',
          },
        ),
        ReadingDocument(
          title: 'E-mail: Attendance and Travel Schedule',
          type: 'email',
          content: 'Dear David,\n\nI am writing to confirm my participation in this Friday\'s workshop. I look forward to the morning keynote and the team dynamic strategy breakout.\n\nHowever, due to an urgent client project meeting scheduled in our Midwest regional branch, I must catch an early evening flight to Chicago. Therefore, I will need to slip away before the closing panel discussion begins at 3:15 PM. Could you please ensure that my certification packet is forwarded to my office?\n\nBest regards,\nSarah Chen\nLead Strategic Analyst',
          metadata: {
            'From': 'Sarah Chen <s.chen@apexconsulting.com>',
            'To': 'David Lee <d.lee@apexconsulting.com>',
            'Date': 'October 21, 2026 · 10:15 AM',
            'Subject': 'Workshop Attendance & Early Departure Notice',
          },
        ),
        ReadingDocument(
          title: 'Workshop Schedule · Friday, October 24',
          type: 'schedule',
          content: '',
          scheduleRows: [
            {'time': '09:00 – 10:30', 'activity': 'Opening Remarks & Keynote Address'},
            {'time': '10:45 – 12:15', 'activity': 'Team Dynamic Strategies & Practical Exercises'},
            {'time': '12:15 – 13:30', 'activity': 'Networking Luncheon (Executive Dining Hall)'},
            {'time': '13:30 – 15:00', 'activity': 'Risk Mitigation & Quality Assurance Breakdown'},
            {'time': '15:15 – 16:30', 'activity': 'Closing Panel & Certificate Presentation'},
          ],
        ),
      ],
    );
  }

  static List<Question> getMockQuestions() {
    List<Question> questions = [];
    
    // Part 5 (101 to 130)
    for (int i = 101; i <= 130; i++) {
      questions.add(Question(
        number: i,
        part: 5,
        text: 'Mr. Henderson requested that all expense reports be submitted _______ Friday afternoon.',
        options: [
          QuestionOption(key: 'A', text: 'by'),
          QuestionOption(key: 'B', text: 'until'),
          QuestionOption(key: 'C', text: 'during'),
          QuestionOption(key: 'D', text: 'upon'),
        ],
        correctOptionIndex: 0,
      ));
    }

    // Part 6 (131 to 146)
    for (int i = 131; i <= 146; i++) {
      questions.add(Question(
        number: i,
        part: 6,
        text: 'The newly implemented software update will _______ streamline our customer support workflows.',
        options: [
          QuestionOption(key: 'A', text: 'significant'),
          QuestionOption(key: 'B', text: 'significantly'),
          QuestionOption(key: 'C', text: 'significance'),
          QuestionOption(key: 'D', text: 'signified'),
        ],
        correctOptionIndex: 1,
      ));
    }

    // Part 7 (147 to 200)
    for (int i = 147; i <= 200; i++) {
      if (i == 178) {
        questions.add(Question(
          number: 178,
          part: 7,
          text: 'Why does Ms. Chen need to leave early?',
          options: [
            QuestionOption(key: 'A', text: 'To catch a flight to Chicago'),
            QuestionOption(key: 'B', text: 'To collect materials'),
            QuestionOption(key: 'C', text: 'To attend a staff meeting'),
            QuestionOption(key: 'D', text: 'To catch a train'),
          ],
          correctOptionIndex: 0,
          passageGroup: 'Nhóm câu 176–180 · Nhiều tài liệu',
          passageId: 'passage-176-180',
        ));
      } else if (i >= 176 && i <= 180) {
        questions.add(Question(
          number: i,
          part: 7,
          text: i == 176 
              ? 'Where will the workshop take place?'
              : i == 177
                  ? 'What session will Ms. Chen attend in the morning?'
                  : i == 179
                      ? 'What does Ms. Chen ask David to do?'
                      : 'At what time does the closing panel start?',
          options: [
            QuestionOption(key: 'A', text: 'Grand Oak Conference Center'),
            QuestionOption(key: 'B', text: 'Apex Regional Headquarters'),
            QuestionOption(key: 'C', text: 'Downtown Community Hall'),
            QuestionOption(key: 'D', text: 'Midwest Branch Pavilion'),
          ],
          correctOptionIndex: 0,
          passageGroup: 'Nhóm câu 176–180 · Nhiều tài liệu',
          passageId: 'passage-176-180',
        ));
      } else {
        questions.add(Question(
          number: i,
          part: 7,
          text: 'According to the passage, what is mentioned about the proposed renovation schedule?',
          options: [
            QuestionOption(key: 'A', text: 'It will conclude ahead of anticipated deadlines'),
            QuestionOption(key: 'B', text: 'It requires approval from the municipal board'),
            QuestionOption(key: 'C', text: 'It will start in the upcoming fiscal quarter'),
            QuestionOption(key: 'D', text: 'It was postponed due to supply chain challenges'),
          ],
          correctOptionIndex: (i % 4),
          passageGroup: 'Đoạn văn đọc hiểu tiêu chuẩn',
        ));
      }
    }

    return questions;
  }

  static List<ValidationIssue> getValidationIssues() {
    return [
      ValidationIssue(
        location: 'Câu 118 · Part 5',
        errorDetail: 'Thiếu lựa chọn D',
        fixInstruction: 'Bổ sung lựa chọn thứ tư trong DOCX.',
      ),
      ValidationIssue(
        location: 'Câu 143 · Part 6',
        errorDetail: 'Có 2 đáp án đúng: B, C',
        fixInstruction: 'Chỉ giữ một đáp án trong trường ANSWER.',
      ),
      ValidationIssue(
        location: 'Nhóm 176–180 · Part 7',
        errorDetail: 'Không tìm thấy ảnh workshop.jpg',
        fixInstruction: 'Nhúng ảnh trực tiếp vào tài liệu.',
      ),
    ];
  }

  static List<QuestionResult> getMockResults() {
    List<QuestionResult> results = [];
    final keys = ['A', 'B', 'C', 'D'];
    
    // Simulate 100 questions (101 to 200)
    // 78 correct, 14 wrong, 8 skipped (193-200 skipped)
    for (int i = 101; i <= 200; i++) {
      int part = i <= 130 ? 5 : (i <= 146 ? 6 : 7);
      String correct = keys[(i * 3) % 4];
      
      if (i >= 193) {
        // 8 skipped
        results.add(QuestionResult(
          questionNumber: i,
          part: part,
          selectedAnswer: null,
          correctAnswer: correct,
          isCorrect: false,
          isSkipped: true,
        ));
      } else if (i % 7 == 0 || i % 13 == 0) {
        // 14 wrong
        String selected = keys[((i * 3) + 1) % 4];
        results.add(QuestionResult(
          questionNumber: i,
          part: part,
          selectedAnswer: selected,
          correctAnswer: correct,
          isCorrect: false,
          isSkipped: false,
        ));
      } else {
        // Correct
        results.add(QuestionResult(
          questionNumber: i,
          part: part,
          selectedAnswer: correct,
          correctAnswer: correct,
          isCorrect: true,
          isSkipped: false,
        ));
      }
    }
    return results;
  }
}
