import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/utils/color/app_colors.dart';

class ImagePickerBox extends StatelessWidget {
  final VoidCallback onTap;

  const ImagePickerBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        height: 100.w,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: AppColors.grayTextSecondaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.blackMainTextColor, width: 2),
            ),
            child: const Icon(Icons.add, color: AppColors.blackMainTextColor),
          ),
        ),
      ),
    );
  }
}
