import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/profile/widgets/profile_menu_item.dart';
import 'package:delivery_app/features/profile/widgets/profile_section_title.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/custom_buttom_sheet/custom_buttom_sheet.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/common_controller/common_controller.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 24.r,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 150.h,
                                width: 100.w,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CustomNetworkImage(
                                    imageUrl:
                                        "https://wallpapers.com/images/featured/image-pictures-79gc4p3mqu7an848.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                  /*Obx(() {
                                */
                                  /*    //final imageUrl = profileController.profile.value.data?.profileImage;
                                    print("======================profile image=================$imageUrl");
                                    if (imageUrl == null || imageUrl.isEmpty) {
                                      return CustomImage(imageSrc:  'assets/icons/Profileicon.svg');
                                    }*/
                                  /*
                                    return ;
                                  }),*/
                                ),
                              ),
                              Gap(10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 12,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Jubayed Islam",
                                            style: context.titleSmall,
                                          ),
                                        ),
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            AppRouter.route.pushNamed(
                                              RoutePath.editProfileScreen,
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.r),
                                              color: Colors.white,
                                              border: Border.all(
                                                color: AppColors.greenTextColor,
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              spacing: 4,
                                              children: [
                                                Icon(Iconsax.edit),
                                                Text(
                                                  "Edit Profile ",
                                                  style: context.labelMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.email_outlined,
                                          color: AppColors.primaryColor,
                                        ),
                                        Gap(4),
                                        Expanded(
                                          child: Text(
                                            textAlign: TextAlign.start,
                                            /*profileController.profile.value.data?.email ?? */ "mohammadjubayed.islam97@gamil.com",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: context.labelMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Iconsax.call,
                                          color: AppColors.primaryColor,
                                        ),
                                        Gap(4),
                                        Text(
                                          /*profileController.profile.value.data?.phoneNumber ?? */ "08834534524",
                                          style: context.labelMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gap(32.h),
                    ProfileSectionTitle(title: 'SETTINGS SECTION'.tr),
                    Gap(12.h),
                    if (CommonController.to.isSeller.value)
                      ProfileMenuItem(
                        title: AppStrings.professionalInfo.tr,
                        onTap: () {
                          AppRouter.route.pushNamed(
                            RoutePath.professionalInfoScreen,
                          );
                        },
                      ),
                    if (CommonController.to.isSeller.value)
                      ProfileMenuItem(
                        title: AppStrings.reviewsAndRatings.tr,
                        onTap: () {
                          AppRouter.route.pushNamed(
                            RoutePath.customerReviewScreen,
                          );
                        },
                      ),
                    /* if(CommonController.to.isSeller.value)
                    ProfileMenuItem(title: AppStrings.adPromotional.tr, onTap: (){*/
                    /*AppRouter.route.pushNamed(RoutePath.personalInformationScreen)*/
                    /*}),*/
                    ProfileMenuItem(
                      title: AppStrings.accountSetting.tr,
                      onTap: () {
                        AppRouter.route.pushNamed(
                          RoutePath.passwordAndSecurityScreen,
                        );
                      },
                    ),
                    ProfileMenuItem(
                      title: AppStrings.supportHelp.tr,
                      onTap: () {
                        AppRouter.route.pushNamed(RoutePath.supportHelpScreen);
                      },
                    ),
                    if (!CommonController.to.isSeller.value)
                      ProfileMenuItem(
                        title: AppStrings.refund.tr,
                        onTap: () {
                          /*AppRouter.route.pushNamed(RoutePath.favoriteTrainerScreen)*/
                        },
                      ),
                    if (!CommonController.to.isSeller.value)
                      ProfileMenuItem(
                        title: AppStrings.faqs.tr,
                        onTap: () {
                          /*AppRouter.route.pushNamed(RoutePath.favoriteTrainerScreen)*/
                        },
                      ),
                    ProfileMenuItem(
                      title: AppStrings.notification.tr,
                      onTap: () {
                        AppRouter.route.pushNamed(
                          RoutePath.driverNotificationScreen,
                        );
                      },
                      isLast: true,
                    ),
                    Gap(24.h),
                    ProfileSectionTitle(title: "More".tr),
                    Gap(12.h),
                    ProfileMenuItem(
                      title: AppStrings.termsAndCondition.tr,
                      onTap: () {
                        AppRouter.route.pushNamed(
                          RoutePath.termsAndConditionsScreen,
                        );
                      },
                    ),
                    ProfileMenuItem(
                      title: AppStrings.privacyPolicy.tr,
                      onTap: () {
                        AppRouter.route.pushNamed(
                          RoutePath.privacyPolicyScreen,
                        );
                      },
                      isLast: true,
                    ),
                    Gap(24.h),
                    CustomButton(
                      text: AppStrings.logOut.tr,
                      onTap: () {
                        showYesNoModal(
                          context,
                          title: 'Hey!'.tr,
                          message:
                              'Are you sure you want to Logout your account?'
                                  .tr,
                          confirmButtonText: AppStrings.logOut.tr,
                          onConfirm: () =>
                              AppRouter.route.goNamed(RoutePath.loginScreen),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
