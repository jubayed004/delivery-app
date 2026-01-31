import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class DriverHeader extends StatelessWidget {
  final String userName;
  final String? profileImageUrl;
  final VoidCallback onNotificationTap;

  const DriverHeader({
    super.key,
    required this.userName,
    this.profileImageUrl,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 60.h,
        bottom: 24.h,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundImage: profileImageUrl != null
                ? NetworkImage(profileImageUrl!)
                : const NetworkImage('https://i.pravatar.cc/300'),
            backgroundColor: Colors.white,
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "${AppStrings.hello.tr} ",
                    style: context.bodyLarge.copyWith(color: Colors.white),
                    children: [
                      TextSpan(
                        text: userName,
                        style: context.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  AppStrings.welcomeBack.tr,
                  style: context.bodySmall.copyWith(color: Colors.white70),
                ),
                Text(
                  AppStrings.readyToDeliveryToday.tr,
                  style: context.bodySmall.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onNotificationTap,
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              child: const Icon(Icons.notifications, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
