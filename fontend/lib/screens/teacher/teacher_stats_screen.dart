import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';

class TeacherStatsScreen extends StatelessWidget {
  const TeacherStatsScreen({super.key});

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
                  Text('PHÂN TÍCH KẾT QUẢ', style: AppStyles.overline),
                  SizedBox(height: 8),
                  Text('Thống kê bài thi', style: AppStyles.h1),
                  SizedBox(height: 6),
                  Text(
                    'TOEIC Reading Practice 01 · Dữ liệu từ 240 bài đã nộp.',
                    style: AppStyles.bodyMuted,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      '01–16/10/2026 ⌄',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Key metrics row
          Row(
            children: [
              Expanded(
                child: _buildStatMetricCard(
                  title: 'Lượt thi đã nộp',
                  value: '240',
                  subtitle: '100% bài hợp lệ',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildStatMetricCard(
                  title: 'Điểm thô trung bình',
                  value: '72,4 / 100',
                  subtitle: 'Không quy đổi điểm TOEIC',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildStatMetricCard(
                  title: 'Thời gian trung bình',
                  value: '62 phút',
                  subtitle: 'Thời lượng tối đa: 75 phút',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Two analytics chart panels
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Score distribution bar chart (Flex: 6)
              Expanded(
                flex: 6,
                child: Container(
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
                          Text('Phân bố điểm thô', style: AppStyles.h3),
                          Text('240 lượt', style: AppStyles.caption),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Chart bars
                      _buildScoreDistributionBar('0–39', 8, 240),
                      const SizedBox(height: 14),
                      _buildScoreDistributionBar('40–59', 36, 240),
                      const SizedBox(height: 14),
                      _buildScoreDistributionBar('60–79', 112, 240, isHighlight: true),
                      const SizedBox(height: 14),
                      _buildScoreDistributionBar('80–100', 84, 240),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Completion rate by part (Flex: 4)
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tỷ lệ trả lời theo phần', style: AppStyles.h3),
                      const SizedBox(height: 24),
                      _buildPartCompletionProgress('Part 5 (101–130)', 0.96, '96% đã làm'),
                      const SizedBox(height: 20),
                      _buildPartCompletionProgress('Part 6 (131–146)', 0.91, '91% đã làm'),
                      const SizedBox(height: 20),
                      _buildPartCompletionProgress('Part 7 (147–200)', 0.84, '84% đã làm'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Top difficult questions table
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
                  children: const [
                    Text('Top câu hỏi có tỷ lệ sai cao nhất', style: AppStyles.h3),
                    Text('Cần lưu ý giải thích khi sửa bài', style: AppStyles.caption),
                  ],
                ),
                const SizedBox(height: 16),

                // Table
                Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  color: AppColors.background,
                  child: Row(
                    children: const [
                      Expanded(flex: 2, child: Text('CÂU HỎI', style: AppStyles.caption)),
                      Expanded(flex: 2, child: Text('PHẦN', style: AppStyles.caption)),
                      Expanded(flex: 3, child: Text('TỶ LỆ SAI', style: AppStyles.caption)),
                      Expanded(flex: 4, child: Text('LỰA CHỌN NHẦM NHIỀU NHẤT', style: AppStyles.caption)),
                    ],
                  ),
                ),
                _buildDifficultRow('Câu 143', 'Part 6', '62%', 'Lựa chọn C (38% sinh viên chọn)'),
                _buildDifficultRow('Câu 118', 'Part 5', '58%', 'Lựa chọn B (32% sinh viên chọn)'),
                _buildDifficultRow('Câu 178', 'Part 7', '44%', 'Lựa chọn D - To catch a train (28% sinh viên chọn)'),
                _buildDifficultRow('Câu 195', 'Part 7', '71%', 'Lựa chọn A (42% sinh viên chọn)'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatMetricCard({
    required String title,
    required String value,
    required String subtitle,
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
          Text(title, style: AppStyles.bodyMuted),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: AppStyles.fontFamily,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildScoreDistributionBar(String range, int count, int total, {bool isHighlight = false}) {
    double ratio = count / total;
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(range, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: AlwaysStoppedAnimation(
                isHighlight ? AppColors.primary : AppColors.accentPale,
              ),
              minHeight: 18,
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 70,
          child: Text(
            '$count (${(ratio * 100).toStringAsFixed(1)}%)',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildPartCompletionProgress(String title, double value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: AppColors.surfaceMuted,
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryDark),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultRow(String q, String part, String errorRate, String commonWrong) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(q, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
          Expanded(flex: 2, child: Text(part, style: AppStyles.caption)),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Text(errorRate, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.error, fontSize: 12)),
              ],
            ),
          ),
          Expanded(flex: 4, child: Text(commonWrong, style: AppStyles.caption)),
        ],
      ),
    );
  }
}
