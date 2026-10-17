import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class TeacherSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectIndex;
  final VoidCallback onToggleRole;

  const TeacherSidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelectIndex,
    required this.onToggleRole,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand Logo
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'READING LAB',
                      style: TextStyle(
                        fontFamily: AppStyles.fontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'TOEIC · PRACTICE WITH PURPOSE',
                      style: TextStyle(
                        fontFamily: AppStyles.fontFamily,
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Category
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'QUẢN TRỊ VIÊN',
              style: TextStyle(
                fontFamily: AppStyles.fontFamily,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted.withValues(alpha: 0.8),
                letterSpacing: 0.8,
              ),
            ),
          ),

          // Navigation items
          _buildNavItem(
            index: 0,
            icon: Icons.folder_copy_outlined,
            label: 'Quản lý đề',
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.menu_book_outlined,
            label: 'Xem trước đề',
          ),
          _buildNavItem(
            index: 2,
            icon: Icons.send_outlined,
            label: 'Xuất bản đề',
          ),
          _buildNavItem(
            index: 3,
            icon: Icons.analytics_outlined,
            label: 'Thống kê',
          ),

          const Spacer(),

          // Bottom workspace info & role switcher
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border, width: 1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Học kỳ 1 · 2026-2027',
                  style: TextStyle(
                    fontFamily: AppStyles.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Lớp: TOEIC Intensive R02',
                  style: TextStyle(
                    fontFamily: AppStyles.fontFamily,
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onToggleRole,
                    icon: const Icon(Icons.swap_horiz, size: 16),
                    label: const Text('Giao diện Sinh viên'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => onSelectIndex(index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.primaryDark : AppColors.textMuted,
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppStyles.fontFamily,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primaryDark : AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
