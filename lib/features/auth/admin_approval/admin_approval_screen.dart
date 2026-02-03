import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AdminApprovalScreen extends StatelessWidget {
  const AdminApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder for an illustration - users typically want a visual here
              Icon(
                Icons.hourglass_empty_rounded,
                size: 100.h,
                color: AppColors.primaryColor,
              ),
              Gap(40.h),
              Text(
                "Admin Approval Pending",
                textAlign: TextAlign.center,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
              Gap(16.h),
              Text(
                "Your profile is currently under review by the admin. You will be notified once your account is approved.",
                textAlign: TextAlign.center,
                style: context.bodyMedium.copyWith(
                  color: AppColors.grayTextSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
