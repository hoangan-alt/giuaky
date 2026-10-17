import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/exam.dart';

class StatusBadge extends StatelessWidget {
  final ExamStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case ExamStatus.draft:
        bg = AppColors.warningBg;
        text = AppColors.warning;
        label = 'Bản nháp';
        break;
      case ExamStatus.published:
        bg = AppColors.primaryLight;
        text = AppColors.primary;
        label = 'Đã xuất bản';
        break;
      case ExamStatus.unpublished:
        bg = AppColors.errorBg;
        text = AppColors.error;
        label = 'Đã ngừng';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppStyles.fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }
}
