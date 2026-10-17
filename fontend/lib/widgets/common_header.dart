import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class StudentHeader extends StatelessWidget {
  final String currentRoute;
  final VoidCallback onToggleRole;

  const StudentHeader({
    super.key,
    required this.currentRoute,
    required this.onToggleRole,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 850;
        final isVeryNarrow = constraints.maxWidth < 650;

        return Container(
          height: 72,
          padding: EdgeInsets.symmetric(
            horizontal: isVeryNarrow ? 16 : 28,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand
              Row(
                mainAxisSize: MainAxisSize.min,
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
                    mainAxisAlignment: MainAxisAlignment.center,
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

              // Center breadcrumb (only if space permits)
              if (!isNarrow) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: Center(
                    child: Text(
                      currentRoute,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppStyles.fontFamily,
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],

              // Right: Role indicator & Switcher
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isVeryNarrow) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.school_outlined, size: 14, color: AppColors.primary),
                          SizedBox(width: 6),
                          Text(
                            'Sinh viên',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  OutlinedButton.icon(
                    onPressed: onToggleRole,
                    icon: const Icon(Icons.swap_horiz, size: 16),
                    label: Text(isVeryNarrow ? 'GV' : 'Giảng viên'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryDark,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
