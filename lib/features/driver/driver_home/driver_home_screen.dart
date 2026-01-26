import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          _buildHeader(context),

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
                        child: _buildStatCard(
                          context,
                          icon: Icons.map_outlined,
                          title: AppStrings.activeRoutes.tr,
                          iconColor: AppColors.primaryColor,
                        ),
                      ),
                      Gap(16.w),
                      Expanded(
                        child: _buildStatCard(
                          context,
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
                      return _buildRequestCard(context);
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

  Widget _buildHeader(BuildContext context) {
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
            backgroundImage: const NetworkImage(
              'https://i.pravatar.cc/300',
            ), // Placeholder
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
                        text: "Alvinoye",
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
            onTap: () {
              AppRouter.route.pushNamed(RoutePath.driverNotificationScreen);
            },
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

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32.sp, color: iconColor),
          Gap(8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.titleMedium.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context) {
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
                onTap: () {
                  AppRouter.route.pushNamed(RoutePath.parcelDetailsScreen);
                },
                child: CustomNetworkImage(
                  borderRadius: BorderRadius.circular(8.r),
                  imageUrl:
                      "https://static.vecteezy.com/system/resources/thumbnails/033/226/263/small/close-up-packing-cardboard-box-on-a-table-with-copyspace-against-background-ai-generated-photo.jpg",
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
                                  text: "112222",
                                  style: context.bodyMedium.copyWith(
                                    color: AppColors.grayTextSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            AppRouter.route.pushNamed(
                              RoutePath.trackParcelScreen,
                            );
                          },
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
                            text: "Electronics",
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
                            text: "Small",
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
                            text: "\$50.00",
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
                  onPressed: () {
                    AppRouter.route.pushNamed(RoutePath.chatScreen);
                  },
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
                  onPressed: () {
                    AppToast.success(message: "Accepted");
                  },
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
                  onPressed: () {
                    AppToast.warning(message: "Rejected");
                  },
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
