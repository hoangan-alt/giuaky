import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/exam.dart';
import '../../widgets/modals.dart';
import '../../widgets/status_badge.dart';

class TeacherPublishScreen extends StatefulWidget {
  const TeacherPublishScreen({super.key});

  @override
  State<TeacherPublishScreen> createState() => _TeacherPublishScreenState();
}

class _TeacherPublishScreenState extends State<TeacherPublishScreen> {
  late List<Exam> exams;
  String currentFilter = 'all'; // all, draft, published, unpublished

  @override
  void initState() {
    super.initState();
    exams = MockData.getExams();
  }

  List<Exam> get filteredExams {
    if (currentFilter == 'draft') {
      return exams.where((e) => e.status == ExamStatus.draft).toList();
    } else if (currentFilter == 'published') {
      return exams.where((e) => e.status == ExamStatus.published).toList();
    } else if (currentFilter == 'unpublished') {
      return exams.where((e) => e.status == ExamStatus.unpublished).toList();
    }
    return exams;
  }

  void _handlePublish(Exam exam) {
    AppModals.showPublishModal(
      context: context,
      examTitle: exam.title,
      onConfirm: () {
        setState(() {
          int idx = exams.indexWhere((e) => e.id == exam.id);
          if (idx != -1) {
            exams[idx] = Exam(
              id: exam.id,
              title: exam.title,
              description: exam.description,
              status: ExamStatus.published,
              updatedAt: 'Hôm nay',
            );
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã xuất bản thành công ${exam.title}!')),
        );
      },
    );
  }

  void _handleUnpublish(Exam exam) {
    AppModals.showUnpublishModal(
      context: context,
      examTitle: exam.title,
      onConfirm: () {
        setState(() {
          int idx = exams.indexWhere((e) => e.id == exam.id);
          if (idx != -1) {
            exams[idx] = Exam(
              id: exam.id,
              title: exam.title,
              description: exam.description,
              status: ExamStatus.unpublished,
              updatedAt: 'Hôm nay',
            );
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã ngừng xuất bản ${exam.title}!')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final draftCount = exams.where((e) => e.status == ExamStatus.draft).length;
    final publishedCount = exams.where((e) => e.status == ExamStatus.published).length;
    final unpublishedCount = exams.where((e) => e.status == ExamStatus.unpublished).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('PHÂN PHỐI ĐỀ THI', style: AppStyles.overline),
              SizedBox(height: 8),
              Text('Xuất bản đề', style: AppStyles.h1),
              SizedBox(height: 6),
              Text(
                'Kiểm soát những đề thi sinh viên có thể truy cập.',
                style: AppStyles.bodyMuted,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Status filter tabs
          Row(
            children: [
              _buildFilterTab('all', 'Tất cả (${exams.length})'),
              const SizedBox(width: 8),
              _buildFilterTab('draft', 'Nháp ($draftCount)'),
              const SizedBox(width: 8),
              _buildFilterTab('published', 'Đã xuất bản ($publishedCount)'),
              const SizedBox(width: 8),
              _buildFilterTab('unpublished', 'Đã ngừng ($unpublishedCount)'),
            ],
          ),
          const SizedBox(height: 20),

          // Publication Table
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Danh sách xuất bản', style: AppStyles.h3),
                    Text('Hiển thị ${filteredExams.length} đề thi', style: AppStyles.caption),
                  ],
                ),
                const SizedBox(height: 18),

                // Table Header
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: AppColors.background,
                  child: Row(
                    children: const [
                      Expanded(flex: 4, child: Text('ĐỀ THI', style: AppStyles.caption)),
                      Expanded(flex: 3, child: Text('KIỂM TRA NỘI DUNG', style: AppStyles.caption)),
                      Expanded(flex: 2, child: Text('TRẠNG THÁI', style: AppStyles.caption)),
                      Expanded(flex: 3, child: Align(alignment: Alignment.centerRight, child: Text('THAO TÁC', style: AppStyles.caption))),
                    ],
                  ),
                ),

                // Table Rows
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredExams.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
                  itemBuilder: (context, index) {
                    final exam = filteredExams[index];
                    final isValid = exam.id != 'exam-06';

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(exam.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                const SizedBox(height: 2),
                                Text('${exam.questionCount} câu · ${exam.durationMinutes} phút · Cập nhật ${exam.updatedAt}', style: AppStyles.caption),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Icon(
                                  isValid ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                                  size: 16,
                                  color: isValid ? AppColors.primary : AppColors.error,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isValid ? 'Hợp lệ 100 câu' : '3 lỗi cần sửa',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: isValid ? AppColors.primary : AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: StatusBadge(status: exam.status),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (exam.status == ExamStatus.draft)
                                    ElevatedButton(
                                      onPressed: isValid ? () => _handlePublish(exam) : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryDark,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      ),
                                      child: const Text('Xuất bản', style: TextStyle(fontSize: 11)),
                                    )
                                  else if (exam.status == ExamStatus.published)
                                    OutlinedButton(
                                      onPressed: () => _handleUnpublish(exam),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.error,
                                        side: const BorderSide(color: AppColors.error),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      ),
                                      child: const Text('Ngừng xuất bản', style: TextStyle(fontSize: 11)),
                                    )
                                  else
                                    ElevatedButton(
                                      onPressed: () => _handlePublish(exam),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryDark,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      ),
                                      child: const Text('Tái xuất bản', style: TextStyle(fontSize: 11)),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String key, String label) {
    final isSelected = currentFilter == key;
    return InkWell(
      onTap: () => setState(() => currentFilter = key),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isSelected ? AppColors.primaryDark : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
