import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DriverRequestCard extends StatelessWidget {
  final String parcelId;
  final String parcelName;
  final String size;
  final String price;
  final String imageUrl;
  final VoidCallback onImageTap;
  final VoidCallback onTrackTap;
  final VoidCallback onChatTap;
  final VoidCallback onAcceptTap;
  final VoidCallback onRejectTap;

  const DriverRequestCard({
    super.key,
    required this.parcelId,
    required this.parcelName,
    required this.size,
    required this.price,
    required this.imageUrl,
    required this.onImageTap,
    required this.onTrackTap,
    required this.onChatTap,
    required this.onAcceptTap,
    required this.onRejectTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.grayTextSecondaryColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onImageTap,
                child: CustomNetworkImage(
                  borderRadius: BorderRadius.circular(8.r),
                  imageUrl: imageUrl,
                  width: 80.w,
                  height: 100.w,
                ),
              ),
              Gap(12.w),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: "${AppStrings.parcelId.tr}: ",
                              style: context.bodyMedium.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: parcelId,
                                  style: context.bodyMedium.copyWith(
                                    color: AppColors.grayTextSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onTrackTap,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.redColor),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 12.sp,
                                  color: AppColors.redColor,
                                ),
                                Gap(4.w),
                                Text(
                                  AppStrings.trackLive.tr,
                                  style: context.labelSmall.copyWith(
                                    color: AppColors.redColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(4.h),
                    RichText(
                      text: TextSpan(
                        text: "${AppStrings.parcelName.tr}: ",
                        style: context.bodyMedium.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: parcelName,
                            style: context.bodyMedium.copyWith(
                              color: AppColors.grayTextSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(4.h),
                    RichText(
                      text: TextSpan(
                        text: AppStrings.size.tr,
                        style: context.bodyMedium.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: size,
                            style: context.bodyMedium.copyWith(
                              color: AppColors.grayTextSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(4.h),
                    RichText(
                      text: TextSpan(
                        text: AppStrings.price.tr,
                        style: context.bodyMedium.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: price,
                            style: context.bodyMedium.copyWith(
                              color: AppColors.grayTextSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(12.h),
          // Actions
          Row(
            children: [
              // Chat Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onChatTap,
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    size: 16.sp,
                    color: AppColors.primaryColor,
                  ),
                  label: Text(
                    AppStrings.chat.tr,
                    style: context.labelMedium.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              Gap(8.w),
              // Accept Button
              Expanded(
                child: ElevatedButton(
                  onPressed: onAcceptTap,
                  style: context.buttonStyle.copyWith(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 0.h),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                  child: Text(
                    AppStrings.accept.tr,
                    style: context.labelMedium.copyWith(color: Colors.white),
                  ),
                ),
              ),
              Gap(8.w),
              // Reject Button
              Expanded(
                child: ElevatedButton(
                  onPressed: onRejectTap,
                  style: context.buttonStyle.copyWith(
                    backgroundColor: WidgetStatePropertyAll(AppColors.redColor),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 0.h),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                  child: Text(
                    AppStrings.reject.tr,
                    style: context.labelMedium.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
