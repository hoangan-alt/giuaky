/// Configuration for the Flutter Web TOEIC Reading application.
class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://localhost:44311/api',
  );

  static const Duration requestTimeout = Duration(seconds: 12);

  // Endpoint routes chuẩn xác tới StudentExam AppService
  static String get publishedExamsUrl => '$baseUrl/services/app/StudentExam/GetPublishedExams';
  static String get createAttemptUrl => '$baseUrl/services/app/StudentExam/StartAttempt';
  static String getAttemptExamUrl(String attemptId) => '$baseUrl/services/app/StudentExam/GetExamForDoAsync?examId=$attemptId';
  static String getSaveAnswerUrl(String attemptId) => '$baseUrl/services/app/StudentExam/SubmitAttempt';
  static String getSubmitAttemptUrl(String attemptId) => '$baseUrl/services/app/StudentExam/SubmitAttempt';
  static String getAttemptResultUrl(String attemptId) => '$baseUrl/services/app/StudentExam/GetExamForDoAsync?examId=$attemptId';
}