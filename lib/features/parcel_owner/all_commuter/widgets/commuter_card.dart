import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:delivery_app/features/parcel_owner/all_commuter/model/commuter_model.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class CommuterCard extends StatelessWidget {
  final CommuterModel commuter;
  final VoidCallback onTap;

  const CommuterCard({super.key, required this.commuter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primaryColor, width: 1.w),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImage(
              height: 50.h,
              width: 50.w,
              imageUrl: commuter.image,
            ),
            Gap(12.w),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    commuter.name,
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackMainTextColor,
                    ),
                  ),
                  Gap(4.h),
                  Row(
                    children: [
                      Text(
                        "Vehicle: ",
                        style: context.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Icon(
                        Icons
                            .directions_car, // Replace with appropriate vehicle icon if needed
                        size: 16.sp,
                        color: Colors.red, // Design shows red car icon
                      ),
                      Gap(4.w),
                      Flexible(
                        child: Text(
                          commuter.vehicleType,
                          style: context.bodyMedium.copyWith(
                            color: Colors.grey[800],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Gap(4.h),
                  Row(
                    children: [
                      Text(
                        "Rating:",
                        style: context.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Icon(Icons.star, size: 16.sp, color: Colors.amber),
                      Flexible(
                        child: Text(
                          "${commuter.rating} (${commuter.deliveryCount} deliveries)",
                          style: context.bodySmall.copyWith(
                            color: Colors.grey[800],
                            fontSize: 12.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primaryColor, width: 1.w),
                ),
                child: Center(
                  child: Text(
                    "View Profile",
                    textAlign: TextAlign.center,
                    style: context.labelMedium.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
