import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/share/widgets/custom_image/custom_image.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class DriverNotificationScreen extends StatelessWidget {
  const DriverNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.notification.tr),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => Gap(16.h),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _NotificationItem(
            title: notification['title'] as String,
            body: notification['body'] as String,
            date: notification['date'] as String?,
            image:
                notification['image'] as String?, // Assuming asset path or URL
          );
        },
      ),
    );
  }

  // Mock Data
  static final List<Map<String, dynamic>> _notifications = [
    {
      'title': "Welcome to Ntsamela",
      'body':
          "", // Body is visually separate or empty in first item of design, but we can adapt.
      'date': "Fri, 12 am",
      // Special case for the first item which looks different in design (has logo)
      'image':
          'assets/icons/slogo.svg', // Placeholder, logic to handle this below
    },
    {
      'title': "Parcel Accepted",
      'body':
          "You have successfully accepted Parcel #A123. Pick-up scheduled at 10:30 AM from 45 Park Street or",
    },
    {
      'title': "Pick-Up Reminder",
      'body':
          "Reminder: Parcel #B456 pick-up in 30 minutes at 22 Maple Avenue. Don't be late!",
    },
    {
      'title': "Delivery Update",
      'body':
          "Parcel #C789 is on the way to the receiver. Estimated delivery: 2:15 PM.",
    },
    {
      'title': "Delivery Confirmation",
      'body':
          "Parcel #D101 has been successfully delivered to the receiver. Your earnings have been updated in the wallet.",
    },
  ];
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final String body;
  final String? date;
  final String? image;

  const _NotificationItem({
    required this.title,
    required this.body,
    this.date,
    this.image,
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
          if (image != null && image!.isNotEmpty) ...[
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: CustomImage(imageSrc: image!),
            ),
            Gap(12.w),
          ],

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
                      if (title.contains("Welcome")) TextSpan(text: ""),
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
