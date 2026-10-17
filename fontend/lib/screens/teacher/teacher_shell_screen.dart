import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../widgets/teacher_sidebar.dart';
import 'teacher_manage_screen.dart';
import 'teacher_preview_screen.dart';
import 'teacher_publish_screen.dart';
import 'teacher_stats_screen.dart';

class TeacherShellScreen extends StatefulWidget {
  final VoidCallback onToggleRole;

  const TeacherShellScreen({super.key, required this.onToggleRole});

  @override
  State<TeacherShellScreen> createState() => _TeacherShellScreenState();
}

class _TeacherShellScreenState extends State<TeacherShellScreen> {
  int currentTabIndex = 0;

  final List<String> tabTitles = [
    'Giảng viên / Quản lý đề',
    'Giảng viên / Xem trước đề',
    'Giảng viên / Xuất bản đề',
    'Giảng viên / Thống kê',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Fixed Sidebar
          TeacherSidebar(
            selectedIndex: currentTabIndex,
            onSelectIndex: (idx) => setState(() => currentTabIndex = idx),
            onToggleRole: widget.onToggleRole,
          ),

          // Workspace Content
          Expanded(
            child: Column(
              children: [
                // Top Header
                Container(
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tabTitles[currentTabIndex],
                        style: const TextStyle(
                          fontFamily: AppStyles.fontFamily,
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text(
                                'TS. Nguyễn Văn A',
                                style: TextStyle(
                                  fontFamily: AppStyles.fontFamily,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                              Text(
                                'Giảng viên phụ trách',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 1.5),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'NA',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tab Content
                Expanded(
                  child: IndexedStack(
                    index: currentTabIndex,
                    children: [
                      TeacherManageScreen(
                        onNavigateToPreview: () => setState(() => currentTabIndex = 1),
                      ),
                      const TeacherPreviewScreen(),
                      const TeacherPublishScreen(),
                      const TeacherStatsScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
