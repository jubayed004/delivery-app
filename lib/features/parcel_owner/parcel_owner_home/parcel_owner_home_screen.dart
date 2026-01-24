import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/widgets/active_parcel_card.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/widgets/parcel_owner_action_buttons.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/widgets/parcel_owner_header.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/widgets/recent_delivery_list.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:get/get_utils/src/extensions/export.dart';

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
                    AppStrings.activeParcel.tr,
                    style: context.titleLarge.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Gap(12.h),
                  ActiveParcelCard(
                    activeParcel: {
                      "id": "112222",
                      "image":
                          "https://img.freepik.com/free-photo/cardboard-box-isolated_125540-652.jpg",
                      "route": "Dhaka to Chattogram",
                      "status": "In Transit",
                      "progress": 0.6,
                    },
                  ),
                  Gap(24.h),
                  Text(
                    AppStrings.recentDeliveryParcel.tr,
                    style: context.titleLarge.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  RecentDeliveryList(
                    recentParcels: [
                      {
                        "id": "112222",
                        "name": "Medicine",
                        "size": "Small",
                        "image":
                            "https://cdn-icons-png.flaticon.com/512/883/883407.png",
                      },
                      {
                        "id": "112222",
                        "name": "Electronics",
                        "size": "Small",
                        "image":
                            "https://cdn-icons-png.flaticon.com/512/3659/3659899.png",
                      },
                      {
                        "id": "112222",
                        "name": "Gifts",
                        "size": "Small",
                        "image":
                            "https://cdn-icons-png.flaticon.com/512/4213/4213958.png",
                      },
                    ],
                  ),
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
