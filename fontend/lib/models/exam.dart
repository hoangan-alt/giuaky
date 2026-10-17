enum ExamStatus { draft, published, unpublished }

enum QuestionStatus { answered, unanswered, flagged, current }

class Exam {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final int questionCount;
  final ExamStatus status;
  final String updatedAt;
  final String subTitle;

  Exam({
    required this.id,
    required this.title,
    required this.description,
    this.durationMinutes = 75,
    this.questionCount = 100,
    required this.status,
    required this.updatedAt,
    this.subTitle = 'TOEIC Reading',
  });
}

class QuestionOption {
  final String key; // A, B, C, D
  final String text;

  QuestionOption({required this.key, required this.text});
}

class Question {
  final int number; // 101 to 200
  final int part;   // 5, 6, 7
  final String text;
  final List<QuestionOption> options;
  final int correctOptionIndex; // 0 for A, 1 for B, 2 for C, 3 for D
  final String? passageGroup;  // e.g. "Nhóm câu 176–180 · Nhiều tài liệu"
  final String? passageId;

  Question({
    required this.number,
    required this.part,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    this.passageGroup,
    this.passageId,
  });
}

class ReadingDocument {
  final String title;
  final String type; // notice, email, schedule
  final String content;
  final Map<String, String>? metadata; // e.g. Date, From, To, Subject
  final List<Map<String, String>>? scheduleRows; // Time and activity

  ReadingDocument({
    required this.title,
    required this.type,
    required this.content,
    this.metadata,
    this.scheduleRows,
  });
}

class ReadingPassage {
  final String id;
  final String title;
  final String instruction;
  final List<ReadingDocument> documents;

  ReadingPassage({
    required this.id,
    required this.title,
    required this.instruction,
    required this.documents,
  });
}

class ValidationIssue {
  final String location;
  final String errorDetail;
  final String fixInstruction;

  ValidationIssue({
    required this.location,
    required this.errorDetail,
    required this.fixInstruction,
  });
}

class QuestionResult {
  final int questionNumber;
  final int part;
  final String? selectedAnswer; // 'A', 'B', 'C', 'D' or null
  final String correctAnswer;   // 'A', 'B', 'C', 'D'
  final bool isCorrect;
  final bool isSkipped;

  QuestionResult({
    required this.questionNumber,
    required this.part,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.isSkipped,
  });
}
