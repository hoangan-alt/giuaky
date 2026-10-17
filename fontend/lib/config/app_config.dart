/// Configuration for the Flutter Web TOEIC Reading application.
/// Allows setting the backend base URL via compile-time environment variables:
/// `flutter run -d chrome --dart-define=API_BASE_URL=https://your-backend.com/api`
class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://localhost:44311/api',
  );

  static const Duration requestTimeout = Duration(seconds: 12);

  // Endpoint routes
  static String get publishedExamsUrl => '$baseUrl/exams/published';
  static String get createAttemptUrl => '$baseUrl/attempts';
  static String getAttemptExamUrl(String attemptId) => '$baseUrl/attempts/$attemptId/exam';
  static String getSaveAnswerUrl(String attemptId) => '$baseUrl/attempts/$attemptId/answers';
  static String getSubmitAttemptUrl(String attemptId) => '$baseUrl/attempts/$attemptId/submit';
  static String getAttemptResultUrl(String attemptId) => '$baseUrl/attempts/$attemptId/result';
}
