import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/exam.dart';
import '../../widgets/status_badge.dart';

class TeacherManageScreen extends StatefulWidget {
  final VoidCallback onNavigateToPreview;

  const TeacherManageScreen({super.key, required this.onNavigateToPreview});

  @override
  State<TeacherManageScreen> createState() => _TeacherManageScreenState();
}

class _TeacherManageScreenState extends State<TeacherManageScreen> {
  late List<Exam> exams;
  String searchQuery = '';
  final List<ValidationIssue> issues = MockData.getValidationIssues();

  @override
  void initState() {
    super.initState();
    exams = MockData.getExams();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Heading
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('NGÂN HÀNG ĐỀ THI', style: AppStyles.overline),
                  SizedBox(height: 8),
                  Text('Quản lý và tạo đề', style: AppStyles.h1),
                  SizedBox(height: 6),
                  Text(
                    'Nhập đề từ DOCX, kiểm tra nội dung và chuẩn bị cho lớp học.',
                    style: AppStyles.bodyMuted,
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đang tải file mẫu TOEIC_Template.docx...')),
                  );
                },
                icon: const Icon(Icons.download_rounded, size: 16),
                label: const Text('Tải mẫu DOCX'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryDark,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Two-column layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Exam List & Rules (Flex: 5)
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _buildExamListPanel(),
                    const SizedBox(height: 20),
                    _buildImportRulesCard(),
                  ],
                ),
              ),
              const SizedBox(width: 24),

              // Right Column: DOCX Import & Validation (Flex: 5)
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _buildUploadPanel(),
                    const SizedBox(height: 20),
                    _buildProcessingPanel(),
                    const SizedBox(height: 20),
                    _buildValidationTablePanel(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExamListPanel() {
    return Container(
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
            children: const [
              Text('Danh sách đề thi', style: AppStyles.h3),
              Text('6 đề thi trong hệ thống', style: AppStyles.caption),
            ],
          ),
          const SizedBox(height: 16),

          // Search & Filter controls
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => searchQuery = val),
                    decoration: const InputDecoration(
                      hintText: 'Tìm theo tên đề thi…',
                      hintStyle: TextStyle(fontSize: 12, color: AppColors.textMuted),
                      prefixIcon: Icon(Icons.search, size: 18, color: AppColors.textMuted),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  'Tất cả trạng thái ⌄',
                  style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Table Header
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            color: AppColors.background,
            child: Row(
              children: const [
                Expanded(flex: 5, child: Text('TÊN ĐỀ THI', style: AppStyles.caption)),
                Expanded(flex: 3, child: Text('TRẠNG THÁI', style: AppStyles.caption)),
                Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text('THAO TÁC', style: AppStyles.caption))),
              ],
            ),
          ),

          // Table Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: exams.take(4).length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
            itemBuilder: (context, index) {
              final exam = exams[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
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
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: StatusBadge(status: exam.status),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: widget.onNavigateToPreview,
                          child: const Text('Xem trước', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 14),

          // Pagination
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Hiển thị 1–4 trong 6 đề', style: AppStyles.caption),
              Text('‹   1   2   ›', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImportRulesCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Đúng cấu trúc, ít chỉnh sửa hơn', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textDark)),
                SizedBox(height: 4),
                Text(
                  'Part 5: 101–130 · Part 6: 131–146 · Part 7: 147–200. Mỗi câu cần đủ 4 lựa chọn và một đáp án đúng.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tạo đề từ DOCX', style: AppStyles.h3),
          const SizedBox(height: 16),

          // Drop zone
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary, style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                const Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 36),
                const SizedBox(height: 8),
                const Text('Kéo thả tệp DOCX vào đây', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 4),
                const Text('Tối đa 20 MB · Đúng định dạng mẫu', style: AppStyles.caption),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryDark,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  ),
                  child: const Text('Chọn tệp'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Uploaded file item
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.description_outlined, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('reading_practice_06.docx', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      SizedBox(height: 2),
                      Text('2,4 MB · Đã tải lên 100%', style: AppStyles.caption),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 1.0,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
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
            children: const [
              Text('Đã xử lý nội dung', style: AppStyles.h4),
              Text('100%', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Đã đọc 100 câu · 12 nhóm bài đọc · 3 ảnh', style: AppStyles.bodyMuted),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.errorBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
                SizedBox(width: 10),
                Text(
                  '3 lỗi cần sửa trước khi tạo bản nháp',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.error),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationTablePanel() {
    return Container(
      padding: const EdgeInsets.all(20),
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
            children: const [
              Text('Kiểm tra định dạng · reading_practice_06.docx', style: AppStyles.h4),
              Text('3 lỗi · Chưa thể tạo đề', style: TextStyle(fontSize: 11, color: AppColors.error)),
            ],
          ),
          const SizedBox(height: 14),

          // Error Header
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: AppColors.background,
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text('VỊ TRÍ', style: AppStyles.caption)),
                Expanded(flex: 4, child: Text('LỖI PHÁT HIỆN', style: AppStyles.caption)),
                Expanded(flex: 4, child: Text('CÁCH KHẮC PHỤC', style: AppStyles.caption)),
              ],
            ),
          ),

          // Error rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: issues.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
            itemBuilder: (context, index) {
              final issue = issues[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(issue.location, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(issue.errorDetail, style: const TextStyle(fontSize: 11, color: AppColors.error, fontWeight: FontWeight.w500)),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(issue.fixInstruction, style: AppStyles.caption),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
