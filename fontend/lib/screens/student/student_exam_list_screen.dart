import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../widgets/common_header.dart';

class StudentExamListScreen extends StatelessWidget {
  final VoidCallback onStartExam;
  final VoidCallback onToggleRole;

  const StudentExamListScreen({
    super.key,
    required this.onStartExam,
    required this.onToggleRole,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          StudentHeader(
            currentRoute: 'Không gian luyện thi / TOEIC Reading',
            onToggleRole: onToggleRole,
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 800;
                final horizontalPadding = constraints.maxWidth > 1100
                    ? 80.0
                    : (constraints.maxWidth > 600 ? 32.0 : 16.0);

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 36,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Banner
                        _buildHeroBanner(constraints.maxWidth > 650),
                        const SizedBox(height: 36),

                        // Section Title
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 16,
                          runSpacing: 8,
                          children: const [
                            Text('Đề thi đang mở', style: AppStyles.h2),
                            Text('2 đề thi · TOEIC Reading', style: AppStyles.bodyMuted),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Exam Cards Grid
                        if (isWide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildExamCard(
                                  title: 'TOEIC Reading Practice 02',
                                  desc: 'Rèn kỹ năng ngữ pháp và đọc hiểu qua các tình huống công việc thực tế.',
                                  duration: '75 phút',
                                  questionCount: '100 câu',
                                  parts: 'Part 5, 6 & 7',
                                  onStart: onStartExam,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: _buildExamCard(
                                  title: 'TOEIC Reading Practice 05',
                                  desc: 'Thử sức với email, thông báo và các nhóm bài đọc nhiều tài liệu.',
                                  duration: '75 phút',
                                  questionCount: '100 câu',
                                  parts: 'Part 5, 6 & 7',
                                  onStart: onStartExam,
                                ),
                              ),
                            ],
                          )
                        else ...[
                          _buildExamCard(
                            title: 'TOEIC Reading Practice 02',
                            desc: 'Rèn kỹ năng ngữ pháp và đọc hiểu qua các tình huống công việc thực tế.',
                            duration: '75 phút',
                            questionCount: '100 câu',
                            parts: 'Part 5, 6 & 7',
                            onStart: onStartExam,
                          ),
                          const SizedBox(height: 16),
                          _buildExamCard(
                            title: 'TOEIC Reading Practice 05',
                            desc: 'Thử sức với email, thông báo và các nhóm bài đọc nhiều tài liệu.',
                            duration: '75 phút',
                            questionCount: '100 câu',
                            parts: 'Part 5, 6 & 7',
                            onStart: onStartExam,
                          ),
                        ],
                        const SizedBox(height: 36),

                        // Before starting section
                        _buildGuidanceCard(constraints.maxWidth > 750),
                        const SizedBox(height: 40),

                        // Footer
                        const Divider(color: AppColors.border),
                        const SizedBox(height: 16),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 16,
                          runSpacing: 8,
                          children: const [
                            Text(
                              'Reading Lab · Không gian luyện thi học thuật',
                              style: AppStyles.caption,
                            ),
                            Text(
                              'Cấu trúc chuẩn: 30 câu Part 5 · 16 câu Part 6 · 54 câu Part 7',
                              style: AppStyles.caption,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(bool showEmblem) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'LUYỆN TẬP CÓ ĐỊNH HƯỚNG',
                  style: AppStyles.overline,
                ),
                SizedBox(height: 10),
                Text(
                  'Sẵn sàng cho bài Reading?',
                  style: TextStyle(
                    fontFamily: AppStyles.fontFamily,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Chọn một đề thi, giữ nhịp tập trung và theo dõi kết quả của bạn.',
                  style: TextStyle(
                    fontFamily: AppStyles.fontFamily,
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (showEmblem) ...[
            const SizedBox(width: 20),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 42),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExamCard({
    required String title,
    required String desc,
    required String duration,
    required String questionCount,
    required String parts,
    required VoidCallback onStart,
  }) {
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
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.article_outlined, color: AppColors.primary, size: 22),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Sẵn sàng',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(title, style: AppStyles.h3),
          const SizedBox(height: 8),
          Text(desc, style: AppStyles.bodyMuted),
          const SizedBox(height: 18),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 6),
                  Text(duration, style: AppStyles.bodyMuted),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.assignment_outlined, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 6),
                  Text(questionCount, style: AppStyles.bodyMuted),
                ],
              ),
              Text(parts, style: AppStyles.caption),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: AppColors.border),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              const Text('Không giới hạn lượt làm', style: AppStyles.caption),
              ElevatedButton.icon(
                onPressed: onStart,
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('Làm bài thi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuidanceCard(bool isWide) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Trước khi bắt đầu', style: AppStyles.h4),
          const SizedBox(height: 16),
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildGuidanceItem(
                    icon: Icons.timer_outlined,
                    title: 'Dành trọn 75 phút',
                    desc: 'Đồng hồ bắt đầu đếm khi bạn vào bài thi.',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildGuidanceItem(
                    icon: Icons.flag_outlined,
                    title: 'Đánh dấu để xem lại',
                    desc: 'Bạn có thể quay lại câu hỏi trước khi nộp.',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildGuidanceItem(
                    icon: Icons.check_circle_outline,
                    title: 'Xem kết quả ngay',
                    desc: 'Điểm thô và đáp án chỉ hiện sau khi nộp.',
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildGuidanceItem(
                  icon: Icons.timer_outlined,
                  title: 'Dành trọn 75 phút',
                  desc: 'Đồng hồ bắt đầu đếm khi bạn vào bài thi.',
                ),
                const SizedBox(height: 12),
                _buildGuidanceItem(
                  icon: Icons.flag_outlined,
                  title: 'Đánh dấu để xem lại',
                  desc: 'Bạn có thể quay lại câu hỏi trước khi nộp.',
                ),
                const SizedBox(height: 12),
                _buildGuidanceItem(
                  icon: Icons.check_circle_outline,
                  title: 'Xem kết quả ngay',
                  desc: 'Điểm thô và đáp án chỉ hiện sau khi nộp.',
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildGuidanceItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textDark)),
              const SizedBox(height: 4),
              Text(desc, style: AppStyles.caption),
            ],
          ),
        ),
      ],
    );
  }
}
