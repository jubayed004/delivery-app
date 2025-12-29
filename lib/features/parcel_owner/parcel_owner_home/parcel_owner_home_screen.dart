import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/widgets/active_parcel_card.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/widgets/parcel_owner_action_buttons.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/widgets/parcel_owner_header.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/widgets/recent_delivery_list.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
class ParcelOwnerHomeScreen extends StatelessWidget {
  const ParcelOwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ParcelOwnerHeader(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(24.h),
                  const ParcelOwnerActionButtons(),
                  Gap(24.h),
                  Text(
                    "Active Parcel",
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Gap(12.h),
                  const ActiveParcelCard(),
                  Gap(24.h),
                  Text(
                    "Recent delivery parcel",
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Gap(12.h),
                  const RecentDeliveryList(),
                  Gap(80.h), // Space for bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
