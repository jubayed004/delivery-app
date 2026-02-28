import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String body;
  final String? date;

  const NotificationItem({
    super.key,
    required this.title,
    required this.body,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: title,
                    style: context.titleMedium.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      if (title.contains("Welcome")) const TextSpan(text: ""),
                    ],
                  ),
                ),
                if (body.isNotEmpty) ...[
                  Gap(4.h),
                  Text(
                    body,
                    style: context.bodyMedium.copyWith(
                      color: AppColors.grayTextSecondaryColor,
                      height: 1.5,
                    ),
                  ),
                ],
                if (date != null) ...[
                  Gap(4.h),
                  Text(
                    date!,
                    style: context.bodySmall.copyWith(
                      color: AppColors.grayTextSecondaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
