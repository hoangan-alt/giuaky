import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class StudentHeader extends StatelessWidget {
  final String currentRoute;

  const StudentHeader({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 800;

        return Container(
          height: 72,
          padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth > 900 ? 32 : 16),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand mark & title
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38,
                    height: 38,
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

              // Center Route / Context
              if (!isNarrow)
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

              // Student badge
              // Student badge / Role Switcher
              InkWell(
                onTap: () {
                  // TODO: Thêm logic chuyển sang Không gian Giảng viên ở đây
                  // Ví dụ hiển thị một Dialog, hoặc điều hướng sang trang Quản lý của giảng viên:
                  // Navigator.pushNamed(context, '/lecturer-space');
                  
                  // Hoặc hiển thị thông báo tạm thời để test:
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Chuyển không gian'),
                      content: const Text('Bạn muốn chuyển sang Không gian Giảng viên?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Hủy'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Thực hiện lệnh chuyển màn hình sang Không gian Giảng viên tại đây
                          },
                          child: const Text('Xác nhận'),
                        ),
                      ],
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.school_outlined, size: 14, color: AppColors.primary),
                      SizedBox(width: 6),
                      Text(
                        'Không gian Sinh viên',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down, size: 16, color: AppColors.primary), // Thêm icon mũi tên nhỏ để người dùng biết chỗ này bấm được
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
