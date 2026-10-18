import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../data/mock_data.dart';
import '../models/exam_model.dart';

class ApiResponse<T> {
  final T? data;
  final String? errorMessage;
  final bool isSuccess;
  final bool isFallback;

  ApiResponse({
    this.data,
    this.errorMessage,
    required this.isSuccess,
    this.isFallback = false,
  });

  factory ApiResponse.success(T data, {bool isFallback = false}) => ApiResponse(
        data: data,
        isSuccess: true,
        isFallback: isFallback,
      );

  factory ApiResponse.error(String message) => ApiResponse(
        errorMessage: message,
        isSuccess: false,
      );
}

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Lấy danh sách đề thi đã xuất bản cho Sinh viên
  Future<ApiResponse<List<PublishedExam>>> getPublishedExams() async {
    final exams = [
      PublishedExam(
        id: 'exam-01',
        title: 'TOEIC Reading Practice 01',
        description: 'Rèn kỹ năng ngữ pháp và đọc hiểu qua các tình huống công việc thực tế.',
        durationMinutes: 75,
        totalQuestions: 100,
        partsInfo: 'Part 5, 6 & 7',
        isPublished: true,
        updatedAt: 'Hôm nay',
      ),
      PublishedExam(
        id: 'exam-02',
        title: 'TOEIC Reading Practice 02',
        description: 'Rèn kỹ năng ngữ pháp và đọc hiểu qua các tình huống công việc thực tế.',
        durationMinutes: 75,
        totalQuestions: 100,
        partsInfo: 'Part 5, 6 & 7',
        isPublished: true,
        updatedAt: '15/10/2026',
      ),
      PublishedExam(
        id: 'exam-05',
        title: 'TOEIC Reading Practice 05',
        description: 'Thử sức với email, thông báo và các nhóm bài đọc nhiều tài liệu.',
        durationMinutes: 75,
        totalQuestions: 100,
        partsInfo: 'Part 5, 6 & 7',
        isPublished: true,
        updatedAt: '12/10/2026',
      ),
    ];
    return ApiResponse.success(exams, isFallback: false);
  }

  Future<ApiResponse<ExamAttempt>> createAttempt(String examId) async {
    final now = DateTime.now();
    return ApiResponse.success(
      ExamAttempt(
        attemptId: 'att-${DateTime.now().millisecondsSinceEpoch}',
        examId: examId,
        examTitle: 'TOEIC Reading Practice',
        startTime: now,
        endTime: now.add(const Duration(minutes: 75)),
        remainingSeconds: 75 * 60,
      ),
    );
  }

  Future<ApiResponse<ExamContentData>> getExamContent(String attemptId) async {
    final mockQuestions = MockData.getMockQuestions();
    final mockPassage = MockData.getMockPassage176to180();

    List<QuestionItem> items = mockQuestions.map((q) {
      return QuestionItem(
        id: 'q-${q.number}',
        number: q.number,
        part: q.part,
        text: q.text,
        options: q.options.map((o) => OptionItem(id: 'opt-${q.number}-${o.key}', key: o.key, text: o.text)).toList(),
        passageId: q.passageId,
        groupLabel: q.passageGroup,
      );
    }).toList();

    final readingDocList = mockPassage.documents.map((d) {
      return ReadingDoc(
        title: d.title,
        type: d.type,
        content: d.content,
        metadata: d.metadata,
        scheduleRows: d.scheduleRows,
      );
    }).toList();

    final passageMap = {
      mockPassage.id: ReadingPassageItem(
        id: mockPassage.id,
        title: mockPassage.title,
        instruction: mockPassage.instruction,
        documents: readingDocList,
      ),
    };

    final now = DateTime.now();
    return ApiResponse.success(
      ExamContentData(
        attemptId: attemptId,
        examTitle: 'TOEIC Reading Practice 01',
        remainingSeconds: 75 * 60,
        endTime: now.add(const Duration(minutes: 75)),
        questions: items,
        passages: passageMap,
        initialAnswers: {},
      ),
    );
  }

  Future<ApiResponse<bool>> saveAnswer({
    required String attemptId,
    required String questionId,
    required String? selectedOptionId,
    required String? selectedOptionKey,
  }) async {
    return ApiResponse.success(true);
  }

  Future<ApiResponse<bool>> submitExam(String attemptId) async {
    return ApiResponse.success(true);
  }

  // Đã sửa lại đúng chuẩn tên kiểu dữ liệu ExamResultData
  Future<ApiResponse<ExamResultData>> getExamResult(String attemptId) async {
    final mockResults = MockData.getMockResults();
    final items = mockResults.map((r) {
      return QuestionResultItem(
        questionNumber: r.questionNumber,
        part: r.part,
        selectedAnswer: r.selectedAnswer,
        correctAnswer: r.correctAnswer,
        isCorrect: r.isCorrect,
        isSkipped: r.isSkipped,
      );
    }).toList();

    return ApiResponse.success(
      ExamResultData(
        attemptId: attemptId,
        examTitle: 'TOEIC Reading Practice 01',
        submittedAt: 'Hôm nay',
        durationUsedFormatted: '45 phút 00 giây',
        rawScore: 85,
        totalQuestions: 100,
        correctCount: 85,
        wrongCount: 10,
        skippedCount: 5,
        accuracyRate: 85.0,
        detailedResults: items,
      ),
    );
  }
}