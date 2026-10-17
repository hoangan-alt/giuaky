import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/exam_model.dart';
import '../services/api_service.dart';
import '../widgets/state_indicators.dart';
import '../widgets/student_header.dart';

class ExamResultScreen extends StatefulWidget {
  final String attemptId;
  final VoidCallback onBackToCatalogue;

  const ExamResultScreen({
    super.key,
    required this.attemptId,
    required this.onBackToCatalogue,
  });

  @override
  State<ExamResultScreen> createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends State<ExamResultScreen> {
  final ApiService apiService = ApiService();

  bool isLoading = true;
  String? errorMessage;
  ExamResultData? resultData;
  String currentFilter = 'all'; // all, correct, wrong, skipped

  @override
  void initState() {
    super.initState();
    _fetchResult();
  }

  Future<void> _fetchResult() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final res = await apiService.getExamResult(widget.attemptId);

    if (mounted) {
      if (res.isSuccess && res.data != null) {
        setState(() {
          resultData = res.data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = res.errorMessage ?? 'Không thể tải kết quả bài thi từ máy chủ.';
          isLoading = false;
        });
      }
    }
  }

  List<QuestionResultItem> get filteredResults {
    if (resultData == null) return [];
    if (currentFilter == 'correct') {
      return resultData!.detailedResults.where((r) => r.isCorrect).toList();
    } else if (currentFilter == 'wrong') {
      return resultData!.detailedResults.where((r) => !r.isCorrect && !r.isSkipped).toList();
    } else if (currentFilter == 'skipped') {
      return resultData!.detailedResults.where((r) => r.isSkipped).toList();
    }
    return resultData!.detailedResults;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const StudentHeader(
            currentRoute: 'Không gian luyện thi / Kết quả bài thi chính thức',
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const LoadingStateView(message: 'Đang tải và đồng bộ kết quả bài thi từ máy chủ…');
    }

    if (errorMessage != null || resultData == null) {
      return ErrorStateView(
        message: errorMessage ?? 'Không thể tải kết quả.',
        onRetry: _fetchResult,
      );
    }

    final data = resultData!;

    return LayoutBuilder(
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
                // Page Heading
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ĐÃ HOÀN THÀNH BÀI THI', style: AppStyles.overline),
                        const SizedBox(height: 8),
                        const Text('Kết quả của bạn', style: AppStyles.h1),
                        const SizedBox(height: 6),
                        Text(
                          '${data.examTitle} · Nộp lúc ${data.submittedAt} · ${data.durationUsedFormatted}',
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

                // Score summary cards row
                if (isWide)
                  Row(
                    children: [
                      _buildRawScoreCard(data, 420),
                      const SizedBox(width: 20),
                      Expanded(child: _buildMetricCardsRow(data)),
                    ],
                  )
                else ...[
                  _buildRawScoreCard(data, double.infinity),
                  const SizedBox(height: 16),
                  _buildMetricCardsRow(data),
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
                    children: [
                      const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Đã chấm ${data.totalQuestions} câu · ${data.correctCount + data.wrongCount} câu đã trả lời · ${data.skippedCount} câu bỏ qua. Kết quả do hệ thống Backend xác thực.',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
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
                        children: [
                          const Text('Chi tiết kết quả bài làm', style: AppStyles.h3),
                          Text('${data.detailedResults.length} câu · Cuộn để xem toàn bộ', style: AppStyles.caption),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Filter tabs
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFilterButton('all', 'Tất cả (${data.detailedResults.length})'),
                          _buildFilterButton('correct', 'Đúng (${data.correctCount})'),
                          _buildFilterButton('wrong', 'Sai (${data.wrongCount})'),
                          _buildFilterButton('skipped', 'Bỏ qua (${data.skippedCount})'),
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

                      // Results list
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
                                    item.correctAnswer ?? 'Chưa công bố',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: item.correctAnswer != null ? AppColors.primary : AppColors.textMuted,
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
    );
  }

  Widget _buildRawScoreCard(ExamResultData data, double width) {
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
            children: [
              Text(
                '${data.rawScore}',
                style: const TextStyle(
                  fontFamily: AppStyles.fontFamily,
                  fontSize: 54,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              Text(
                'trên ${data.totalQuestions} câu',
                style: const TextStyle(
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
              children: [
                Text(
                  'Điểm thô: ${data.rawScore} / ${data.totalQuestions}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
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

  Widget _buildMetricCardsRow(ExamResultData data) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            count: '${data.correctCount}',
            label: 'Câu đúng',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            count: '${data.wrongCount}',
            label: 'Câu sai',
            color: AppColors.error,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            count: '${data.skippedCount}',
            label: 'Bỏ qua',
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            count: '${data.accuracyRate.toStringAsFixed(0)}%',
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
      padding: const EdgeInsets.all(18),
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
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppStyles.caption),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String key, String label) {
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

  Widget _buildResultBadge(QuestionResultItem item) {
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
