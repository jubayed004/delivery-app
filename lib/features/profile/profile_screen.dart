import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/profile/controller/profile_controller.dart';
import 'package:delivery_app/features/profile/widgets/profile_header_card.dart';
import 'package:delivery_app/features/profile/widgets/profile_menu_item.dart';
import 'package:delivery_app/features/profile/widgets/profile_section_title.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/custom_buttom_sheet/custom_buttom_sheet.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/common_controller/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ProfileController profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await profileController.getProfile();
          },
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
                      ProfileHeaderCard(),
                      Gap(32.h),
                      ProfileSectionTitle(title: 'SETTINGS SECTION'.tr),
                      Gap(12.h),
                      if (CommonController.to.isUser.value)
                        ProfileMenuItem(
                          title: AppStrings.professionalInfo.tr,
                          onTap: () {
                            AppRouter.route.pushNamed(
                              RoutePath.professionalInfoScreen,
                            );
                          },
                        ),
                      if (CommonController.to.isUser.value)
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
                          AppRouter.route.pushNamed(
                            RoutePath.supportHelpScreen,
                          );
                        },
                      ),
                      if (!CommonController.to.isUser.value)
                        ProfileMenuItem(
                          title: AppStrings.refund.tr,
                          onTap: () {
                            /*AppRouter.route.pushNamed(RoutePath.favoriteTrainerScreen)*/
                          },
                        ),
                      if (!CommonController.to.isUser.value)
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
      ),
    );
  }
}
