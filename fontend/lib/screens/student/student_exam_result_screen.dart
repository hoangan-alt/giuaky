import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/exam.dart';
import '../../widgets/common_header.dart';

class StudentExamResultScreen extends StatefulWidget {
  final VoidCallback onBackToCatalogue;
  final VoidCallback onToggleRole;

  const StudentExamResultScreen({
    super.key,
    required this.onBackToCatalogue,
    required this.onToggleRole,
  });

  @override
  State<StudentExamResultScreen> createState() => _StudentExamResultScreenState();
}

class _StudentExamResultScreenState extends State<StudentExamResultScreen> {
  late List<QuestionResult> allResults;
  String currentFilter = 'all'; // all, correct, wrong, skipped

  @override
  void initState() {
    super.initState();
    allResults = MockData.getMockResults();
  }

  List<QuestionResult> get filteredResults {
    if (currentFilter == 'correct') {
      return allResults.where((r) => r.isCorrect).toList();
    } else if (currentFilter == 'wrong') {
      return allResults.where((r) => !r.isCorrect && !r.isSkipped).toList();
    } else if (currentFilter == 'skipped') {
      return allResults.where((r) => r.isSkipped).toList();
    }
    return allResults;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          StudentHeader(
            currentRoute: 'Không gian luyện thi / Kết quả bài thi',
            onToggleRole: widget.onToggleRole,
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 950;
                final horizontalPadding = constraints.maxWidth > 1100
                    ? 80.0
                    : (constraints.maxWidth > 650 ? 32.0 : 16.0);

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
                        // Page heading
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('ĐÃ HOÀN THÀNH BÀI THI', style: AppStyles.overline),
                                SizedBox(height: 8),
                                Text('Kết quả của bạn', style: AppStyles.h1),
                                SizedBox(height: 6),
                                Text(
                                  'TOEIC Reading Practice 01 · Nộp lúc 10:55, 16/10/2026 · 70 phút 02 giây',
                                  style: AppStyles.bodyMuted,
                                ),
                              ],
                            ),
                            OutlinedButton.icon(
                              onPressed: widget.onBackToCatalogue,
                              icon: const Icon(Icons.arrow_back_rounded, size: 16),
                              label: const Text('Quay về danh sách đề'),
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

                        // Score summary cards
                        if (isWide)
                          Row(
                            children: [
                              _buildRawScoreCard(400),
                              const SizedBox(width: 20),
                              Expanded(child: _buildMetricCardsRow()),
                            ],
                          )
                        else ...[
                          _buildRawScoreCard(double.infinity),
                          const SizedBox(height: 16),
                          _buildMetricCardsRow(),
                        ],
                        const SizedBox(height: 20),

                    // Completion banner note
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.check_circle_outline, color: AppColors.primary, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Đã chấm 100 câu · 92 câu đã trả lời · 8 câu bỏ qua (193–200). Đáp án chỉ hiển thị sau khi nộp bài.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Detailed breakdown table panel
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
                              Text('Chi tiết kết quả · Câu 101–200', style: AppStyles.h3),
                              Text('100 câu · Cuộn để xem toàn bộ', style: AppStyles.caption),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Filter buttons
                          Row(
                            children: [
                              _buildFilterButton('all', 'Tất cả (100)'),
                              const SizedBox(width: 8),
                              _buildFilterButton('correct', 'Đúng (78)'),
                              const SizedBox(width: 8),
                              _buildFilterButton('wrong', 'Sai (14)'),
                              const SizedBox(width: 8),
                              _buildFilterButton('skipped', 'Bỏ qua (8)'),
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
                                SizedBox(width: 70, child: Text('CÂU', style: AppStyles.caption)),
                                SizedBox(width: 90, child: Text('PHẦN', style: AppStyles.caption)),
                                SizedBox(width: 120, child: Text('BẠN CHỌN', style: AppStyles.caption)),
                                SizedBox(width: 140, child: Text('ĐÁP ÁN ĐÚNG', style: AppStyles.caption)),
                                Expanded(child: Text('KẾT QUẢ', style: AppStyles.caption)),
                              ],
                            ),
                          ),

                          // Results Table List
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredResults.length,
                            separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
                            itemBuilder: (context, index) {
                              final item = filteredResults[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        '${item.questionNumber}',
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 90,
                                      child: Text('Part ${item.part}', style: AppStyles.bodyMuted),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        item.selectedAnswer ?? '—',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: item.selectedAnswer == null
                                              ? AppColors.textMuted
                                              : (item.isCorrect ? AppColors.primary : AppColors.error),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 140,
                                      child: Text(
                                        item.correctAnswer,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: _buildResultBadge(item),
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
              ),
            );
          },
        ),
      ),
    ],
  ),
);
}

Widget _buildRawScoreCard(double width) {
  return Container(
    width: width,
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      color: AppColors.primaryDark,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '78',
              style: TextStyle(
                fontFamily: AppStyles.fontFamily,
                fontSize: 54,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.1,
              ),
            ),
            Text(
              'trên 100 câu',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.accentPale,
              ),
            ),
          ],
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Điểm thô: 78 / 100',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Không phải điểm TOEIC quy đổi. Mỗi câu đúng được 1 điểm.',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.accentPale,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildMetricCardsRow() {
  return Row(
    children: [
      Expanded(
        child: _buildMetricCard(
          count: '78',
          label: 'Câu đúng',
          color: AppColors.primary,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _buildMetricCard(
          count: '14',
          label: 'Câu sai',
          color: AppColors.error,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _buildMetricCard(
          count: '8',
          label: 'Bỏ qua',
          color: AppColors.textMuted,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _buildMetricCard(
          count: '78%',
          label: 'Tỷ lệ đúng',
          color: AppColors.primaryDark,
        ),
      ),
    ],
  );
}

  Widget _buildMetricCard({
    required String count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: TextStyle(
              fontFamily: AppStyles.fontFamily,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppStyles.bodyMuted),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String key, String label) {
    final isSelected = currentFilter == key;
    return InkWell(
      onTap: () {
        setState(() => currentFilter = key);
      },
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

  Widget _buildResultBadge(QuestionResult item) {
    if (item.isSkipped) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Bỏ qua',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted),
        ),
      );
    }
    if (item.isCorrect) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Đúng',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Sai',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.error),
      ),
    );
  }
}
