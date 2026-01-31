import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/driver/driver_home/widgets/driver_header.dart';
import 'package:delivery_app/features/driver/driver_home/widgets/driver_request_card.dart';
import 'package:delivery_app/features/driver/driver_home/widgets/stat_card.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          DriverHeader(
            userName: "Alvinoye",
            profileImageUrl: 'https://i.pravatar.cc/300',
            onNotificationTap: () {
              AppRouter.route.pushNamed(RoutePath.driverNotificationScreen);
            },
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.map_outlined,
                          title: AppStrings.activeRoutes.tr,
                          iconColor: AppColors.primaryColor,
                        ),
                      ),
                      Gap(16.w),
                      Expanded(
                        child: StatCard(
                          icon: Icons.monetization_on_outlined,
                          title: "${AppStrings.earning.tr} \$125",
                          iconColor: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Gap(24.h),
                  Text(
                    AppStrings.yourRecentRequest.tr,
                    style: context.headlineSmall.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),
                  Gap(16.h),
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (context, index) => Gap(16.h),
                    itemBuilder: (context, index) {
                      return DriverRequestCard(
                        parcelId: "112222",
                        parcelName: "Electronics",
                        size: "Small",
                        price: "\$50.00",
                        imageUrl:
                            "https://static.vecteezy.com/system/resources/thumbnails/033/226/263/small/close-up-packing-cardboard-box-on-a-table-with-copyspace-against-background-ai-generated-photo.jpg",
                        onImageTap: () {
                          AppRouter.route.pushNamed(
                            RoutePath.parcelDetailsScreen,
                          );
                        },
                        onTrackTap: () {
                          AppRouter.route.pushNamed(
                            RoutePath.trackParcelScreen,
                          );
                        },
                        onChatTap: () {
                          AppRouter.route.pushNamed(RoutePath.chatScreen);
                        },
                        onAcceptTap: () {
                          AppToast.success(message: "Accepted");
                        },
                        onRejectTap: () {
                          AppToast.warning(message: "Rejected");
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
