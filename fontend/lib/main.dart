import 'package:flutter/material.dart';
import 'constants/app_theme.dart';
import 'models/exam_model.dart';
import 'screens/exam_list_screen.dart';
import 'screens/exam_taking_screen.dart';
import 'screens/exam_result_screen.dart';

void main() {
  runApp(const ReadingLabApp());
}

class ReadingLabApp extends StatelessWidget {
  const ReadingLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading Lab · TOEIC Reading Practice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: AppStyles.fontFamily,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryDark,
          primary: AppColors.primaryDark,
          surface: AppColors.surface,
        ),
      ),
      home: const StudentFlowController(),
    );
  }
}

enum StudentScreenState {
  catalogue,
  takingExam,
  result,
}

class StudentFlowController extends StatefulWidget {
  const StudentFlowController({super.key});

  @override
  State<StudentFlowController> createState() => _StudentFlowControllerState();
}

class _StudentFlowControllerState extends State<StudentFlowController> {
  StudentScreenState currentState = StudentScreenState.catalogue;
  PublishedExam? selectedExam;
  String? finishedAttemptId;

  void _onStartExam(PublishedExam exam) {
    setState(() {
      selectedExam = exam;
      currentState = StudentScreenState.takingExam;
    });
  }

  void _onFinishExam(String attemptId) {
    setState(() {
      finishedAttemptId = attemptId;
      currentState = StudentScreenState.result;
    });
  }

  void _onBackToCatalogue() {
    setState(() {
      currentState = StudentScreenState.catalogue;
      selectedExam = null;
      finishedAttemptId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (currentState) {
      case StudentScreenState.catalogue:
        return ExamListScreen(
          onStartExam: _onStartExam,
        );

      case StudentScreenState.takingExam:
        if (selectedExam == null) {
          return ExamListScreen(onStartExam: _onStartExam);
        }
        return ExamTakingScreen(
          exam: selectedExam!,
          onFinishExam: _onFinishExam,
        );

      case StudentScreenState.result:
        return ExamResultScreen(
          attemptId: finishedAttemptId ?? 'att-latest',
          onBackToCatalogue: _onBackToCatalogue,
        );
    }
  }
}
