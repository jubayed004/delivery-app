import 'package:delivery_app/core/custom_assets/assets.gen.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/profile/controller/profile_controller.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Obx(() {
              final imageUrl =
                  profileController.profile.value.data?.profilePicture;
              if (imageUrl == null || imageUrl.isEmpty) {
                return Container(
                  height: 100.h,
                  width: 90.w,
                  color: AppColors.primaryColor.withOpacity(0.1),
                  child: Center(
                    child: Assets.images.profile.image(
                      height: 50.h,
                      width: 50.w,
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 100.h,
                width: 90.w,
                child: CustomNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              );
            }),
          ),
          Gap(16.w),

          // Profile Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(() {
                        return Text(
                          profileController.profile.value.data?.fullName ??
                              "User Name",
                          style: context.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppRouter.route.pushNamed(RoutePath.editProfileScreen);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Iconsax.edit,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(8.h),

                // Email
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    Gap(6.w),
                    Expanded(
                      child: Obx(() {
                        return Text(
                          profileController.profile.value.data?.email ??
                              "No Email",
                          style: context.labelMedium.copyWith(
                            color: Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                    ),
                  ],
                ),
                Gap(6.h),

                // Phone
                Row(
                  children: [
                    Icon(Iconsax.call, size: 16, color: Colors.grey[600]),
                    Gap(6.w),
                    Obx(() {
                      final phoneNumber =
                          profileController.profile.value.data?.phoneNumber;
                      return Text(
                        phoneNumber ?? "No Phone Number",
                        style: context.labelMedium.copyWith(
                          color: Colors.grey[700],
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
