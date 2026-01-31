import 'package:delivery_app/features/parcel_owner/my_parcel/model/details_my_parcel_model.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class StatusMessageSection extends StatelessWidget {
  final List<PriceRequest>? priceRequests;

  const StatusMessageSection({super.key, this.priceRequests});

  @override
  Widget build(BuildContext context) {
    if (priceRequests == null || priceRequests!.isEmpty) {
      return const SizedBox.shrink();
    }

    final lastRequest = priceRequests!.last;

    // Check if status is REJECTED
    if (lastRequest.status == "REJECTED") {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.error, width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.cancel_outlined, color: AppColors.error, size: 20.sp),
            Gap(8.w),
            Expanded(
              child: Text(
                lastRequest.priceType == "FINAL_OFFER"
                    ? "Final Offer Rejected"
                    : "Price Rejected. Waiting for new offer...",
                style: context.bodyMedium.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Check if status is COUNTERED
    if (lastRequest.priceType == "COUNTERED") {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.orange, width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange, size: 20.sp),
            Gap(8.w),
            Expanded(
              child: Text(
                "Counter Offer Sent. Waiting for response...",
                style: context.bodyMedium.copyWith(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Check if price type is FINAL_OFFER
    if (lastRequest.priceType == "FINAL_OFFER") {
      return Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.purple.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.purple, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
                Gap(8.w),
                Expanded(
                  child: Text(
                    "Admin Note",
                    style: context.bodyMedium.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (lastRequest.message != null &&
                lastRequest.message!.isNotEmpty) ...[
              Gap(8.h),
              Text(
                lastRequest.message!,
                style: context.bodyMedium.copyWith(
                  color: Colors.purple.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
