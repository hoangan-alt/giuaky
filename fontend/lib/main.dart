import 'package:flutter/material.dart';

// Import chính xác 4 file màn hình giao diện Giảng viên trong thư mục screens/teacher/
import 'screens/teacher/teacher_manage_screen.dart' as teacher_manage;
import 'screens/teacher/teacher_preview_screen.dart' as teacher_preview;
import 'screens/teacher/teacher_publish_screen.dart' as teacher_publish;
import 'screens/teacher/teacher_stats_screen.dart' as teacher_stats;

// Import cấu hình chung và luồng Sinh viên
import 'constants/app_theme.dart';
import 'models/exam_model.dart';
import 'screens/exam_list_screen.dart';
import 'screens/exam_taking_screen.dart';
import 'screens/exam_result_screen.dart';
import 'widgets/teacher_sidebar.dart';

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
      home: const AppRootSwitcher(),
    );
  }
}

// ==========================================
// 1. QUẢN LÝ CHUYỂN ĐỔI GIỮA SINH VIÊN VÀ GIẢNG VIÊN
// ==========================================
class AppRootSwitcher extends StatefulWidget {
  const AppRootSwitcher({super.key});

  @override
  State<AppRootSwitcher> createState() => _AppRootSwitcherState();
}

class _AppRootSwitcherState extends State<AppRootSwitcher> {
  // true = Không gian Giảng viên, false = Không gian Sinh viên
  bool _isTeacherMode = false;
  int _teacherSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // NẾU BẬT KHÔNG GIAN GIẢNG VIÊN
    if (_isTeacherMode) {
      return Scaffold(
        body: Row(
          children: [
            TeacherSidebar(
              selectedIndex: _teacherSelectedIndex,
              onSelectIndex: (index) {
                setState(() {
                  _teacherSelectedIndex = index;
                });
              },
              onToggleRole: () {
                setState(() {
                  _isTeacherMode = false; // Quay lại Không gian Sinh viên
                });
              },
            ),
            // Hiển thị trực tiếp các giao diện Giảng viên thực tế
            Expanded(
              child: Container(
                color: Colors.grey[50],
                child: _buildTeacherScreen(_teacherSelectedIndex),
              ),
            ),
          ],
        ),
      );
    }

    // NẾU ĐANG Ở KHÔNG GIAN SINH VIÊN
    return Stack(
      children: [
        const StudentFlowController(),
        Positioned(
          top: 12,
          right: 200,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              setState(() {
                _isTeacherMode = true; // Bật Không gian Giảng viên
              });
            },
            icon: const Icon(Icons.admin_panel_settings, size: 16),
            label: const Text('Mở Không gian Giảng viên'),
          ),
        ),
      ],
    );
  }

  // Điều hướng chính xác đến 4 file màn hình Giảng viên thực tế
  Widget _buildTeacherScreen(int index) {
    switch (index) {
      case 0:
        // Tab 0: Quản lý đề (teacher_manage_screen.dart)
        return teacher_manage.TeacherManageScreen(
          onNavigateToPreview: () {
            setState(() {
              _teacherSelectedIndex = 1; // Chuyển sang tab Xem trước đề
            });
          },
        );
      case 1:
        // Tab 1: Xem trước đề (teacher_preview_screen.dart)
        return const teacher_preview.TeacherPreviewScreen();
      case 2:
        // Tab 2: Xuất bản đề (teacher_publish_screen.dart)
        return const teacher_publish.TeacherPublishScreen();
      case 3:
        // Tab 3: Thống kê (teacher_stats_screen.dart)
        return const teacher_stats.TeacherStatsScreen();
      default:
        return teacher_manage.TeacherManageScreen(
          onNavigateToPreview: () {
            setState(() {
              _teacherSelectedIndex = 1;
            });
          },
        );
    }
  }
}

// ==========================================
// 2. LUỒNG SINH VIÊN
// ==========================================
enum StudentScreenState { catalogue, takingExam, result }

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
        return ExamListScreen(onStartExam: _onStartExam);

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