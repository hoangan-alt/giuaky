import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/exam.dart';
import '../widgets/modals.dart';
import '../widgets/status_badge.dart';

class UiLibraryScreen extends StatelessWidget {
  final VoidCallback onBack;

  const UiLibraryScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: onBack,
        ),
        title: const Text(
          'Thư viện UI & Trạng thái (Figma Design System)',
          style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('READING LAB / DESIGN HANDOFF', style: AppStyles.overline),
            const SizedBox(height: 8),
            const Text('Thư viện UI & trạng thái', style: AppStyles.h1),
            const SizedBox(height: 6),
            const Text(
              'Frame mẫu dùng Auto Layout · Chưa chuyển thành native component variants · Không phải màn hình ứng dụng',
              style: AppStyles.bodyMuted,
            ),
            const SizedBox(height: 32),

            // Color Palette
            const Text('Bảng màu cốt lõi (Color Tokens)', style: AppStyles.h3),
            const SizedBox(height: 14),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildColorSwatch('Primary Dark', '#173D32', AppColors.primaryDark, Colors.white),
                _buildColorSwatch('Primary Jade', '#2D8065', AppColors.primary, Colors.white),
                _buildColorSwatch('Primary Light', '#E9F3ED', AppColors.primaryLight, AppColors.textDark),
                _buildColorSwatch('Text Dark', '#20372F', AppColors.textDark, Colors.white),
                _buildColorSwatch('Text Muted', '#687A72', AppColors.textMuted, Colors.white),
                _buildColorSwatch('Background', '#F4F7F5', AppColors.background, AppColors.textDark),
                _buildColorSwatch('Border', '#DAE4DE', AppColors.border, AppColors.textDark),
                _buildColorSwatch('Warning', '#9A650E', AppColors.warning, Colors.white),
                _buildColorSwatch('Error Red', '#B3433F', AppColors.error, Colors.white),
              ],
            ),
            const SizedBox(height: 36),

            // Buttons
            const Text('Button Styles & States', style: AppStyles.h3),
            const SizedBox(height: 14),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildSampleCard(
                  'Button/state=primary',
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    child: const Text('Lưu bản nháp'),
                  ),
                ),
                _buildSampleCard(
                  'Button/state=secondary',
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryDark,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    child: const Text('Lưu bản nháp'),
                  ),
                ),
                _buildSampleCard(
                  'Button/state=disabled',
                  ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceMuted,
                      disabledForegroundColor: AppColors.textMuted,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    child: const Text('Lưu bản nháp'),
                  ),
                ),
                _buildSampleCard(
                  'Button/state=loading',
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    ),
                    label: const Text('Đang xử lý…'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),

            // Badges
            const Text('Badges (Trạng thái đề thi)', style: AppStyles.h3),
            const SizedBox(height: 14),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildSampleCard('Badge/state=draft', const StatusBadge(status: ExamStatus.draft)),
                _buildSampleCard('Badge/state=published', const StatusBadge(status: ExamStatus.published)),
                _buildSampleCard('Badge/state=unpublished', const StatusBadge(status: ExamStatus.unpublished)),
              ],
            ),
            const SizedBox(height: 36),

            // Modals Trigger
            const Text('Hộp thoại xác nhận (Modals)', style: AppStyles.h3),
            const SizedBox(height: 14),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildSampleCard(
                  'Modal/type=publish',
                  ElevatedButton(
                    onPressed: () => AppModals.showPublishModal(
                      context: context,
                      examTitle: 'TOEIC Reading Practice 01',
                      onConfirm: () {},
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark),
                    child: const Text('Mở Modal Xuất bản'),
                  ),
                ),
                _buildSampleCard(
                  'Modal/type=unpublish',
                  ElevatedButton(
                    onPressed: () => AppModals.showUnpublishModal(
                      context: context,
                      examTitle: 'TOEIC Reading Practice 02',
                      onConfirm: () {},
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                    child: const Text('Mở Modal Ngừng xuất bản'),
                  ),
                ),
                _buildSampleCard(
                  'Modal/type=submit',
                  ElevatedButton(
                    onPressed: () => AppModals.showSubmitExamModal(
                      context: context,
                      answeredCount: 92,
                      totalCount: 100,
                      flaggedCount: 4,
                      onConfirm: () {},
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('Mở Modal Nộp bài'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSwatch(String name, String hex, Color color, Color textCol) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: textCol)),
          const SizedBox(height: 4),
          Text(hex, style: TextStyle(fontSize: 11, color: textCol.withValues(alpha: 0.8))),
        ],
      ),
    );
  }

  Widget _buildSampleCard(String label, Widget child) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
