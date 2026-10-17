import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/exam.dart';
import '../../widgets/status_badge.dart';

class TeacherPreviewScreen extends StatefulWidget {
  const TeacherPreviewScreen({super.key});

  @override
  State<TeacherPreviewScreen> createState() => _TeacherPreviewScreenState();
}

class _TeacherPreviewScreenState extends State<TeacherPreviewScreen> {
  int selectedPart = 7;
  int currentGroupIndex = 8; // Group 8 / 12
  late ReadingPassage passage;
  late List<Question> groupQuestions;

  @override
  void initState() {
    super.initState();
    passage = MockData.getMockPassage176to180();
    groupQuestions = MockData.getMockQuestions()
        .where((q) => q.number >= 176 && q.number <= 180)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('TOEIC READING PRACTICE 01', style: AppStyles.overline),
                  SizedBox(height: 8),
                  Text('Xem trước đề', style: AppStyles.h1),
                  SizedBox(height: 6),
                  Text(
                    'Kiểm tra bài đọc và đáp án trước khi xuất bản.',
                    style: AppStyles.bodyMuted,
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Chỉnh sửa bản nháp'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryDark,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã lưu bản nháp thành công!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Lưu bản nháp'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Part selector and admin mode indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildPartTab(5, 'Part 5 · 30 câu'),
                  const SizedBox(width: 8),
                  _buildPartTab(6, 'Part 6 · 16 câu'),
                  const SizedBox(width: 8),
                  _buildPartTab(7, 'Part 7 · 54 câu'),
                ],
              ),
              Row(
                children: const [
                  Icon(Icons.visibility_outlined, size: 16, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text(
                    'Chế độ quản trị · Hiện đáp án',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 12),
                  StatusBadge(status: ExamStatus.draft),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Group toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nhóm câu 176–180 · Nhiều tài liệu',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textDark),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: currentGroupIndex > 1
                          ? () => setState(() => currentGroupIndex--)
                          : null,
                      child: const Text('‹ Nhóm trước', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('$currentGroupIndex / 12', style: AppStyles.caption),
                    ),
                    InkWell(
                      onTap: currentGroupIndex < 12
                          ? () => setState(() => currentGroupIndex++)
                          : null,
                      child: const Text('Nhóm tiếp ›', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Split Preview Layout: Left Passages, Right Questions with Answers
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Reading Content (Flex: 5)
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          passage.instruction,
                          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...passage.documents.map((doc) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildDocumentPreview(doc),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Right: Questions with Teacher Answers highlighted (Flex: 5)
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Câu hỏi & Đáp án chuẩn', style: AppStyles.h3),
                      const SizedBox(height: 6),
                      const Text('Đáp án đúng được đánh dấu xanh · Sinh viên sẽ không thấy mục này khi làm bài.', style: AppStyles.caption),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: AppColors.border),
                      const SizedBox(height: 16),

                      // Questions list
                      ...groupQuestions.map((q) => Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: _buildTeacherQuestionItem(q),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartTab(int part, String label) {
    final isSelected = selectedPart == part;
    return InkWell(
      onTap: () => setState(() => selectedPart = part),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : Colors.white,
          borderRadius: BorderRadius.circular(8),
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

  Widget _buildDocumentPreview(ReadingDocument doc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(doc.title, style: AppStyles.h4),
          const SizedBox(height: 10),
          if (doc.metadata != null) ...[
            ...doc.metadata!.entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text('${e.key}: ', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                      Text(e.value, style: const TextStyle(fontSize: 11, color: AppColors.textDark)),
                    ],
                  ),
                )),
            const SizedBox(height: 10),
          ],
          if (doc.content.isNotEmpty)
            Text(doc.content, style: AppStyles.body),
          if (doc.scheduleRows != null) ...[
            Table(
              border: TableBorder.all(color: AppColors.border),
              children: doc.scheduleRows!.map((r) {
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(r['time']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(r['activity']!, style: const TextStyle(fontSize: 11)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTeacherQuestionItem(Question q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Câu ${q.number}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Part 7', style: AppStyles.caption),
          ],
        ),
        const SizedBox(height: 8),
        Text(q.text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textDark)),
        const SizedBox(height: 10),
        ...q.options.asMap().entries.map((entry) {
          int idx = entry.key;
          var opt = entry.value;
          bool isCorrect = (idx == q.correctOptionIndex);

          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isCorrect ? AppColors.primaryLight : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isCorrect ? AppColors.primary : AppColors.border,
                  width: isCorrect ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '${opt.key}.',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: isCorrect ? AppColors.primary : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      opt.text,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isCorrect ? FontWeight.w600 : FontWeight.w400,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  if (isCorrect) ...[
                    const Icon(Icons.check_circle, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    const Text(
                      'ĐÁP ÁN ĐÚNG',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
