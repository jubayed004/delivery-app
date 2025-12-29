import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/dialog/custom_dialog.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class CreateDetailsParcelScreen extends StatelessWidget {
  const CreateDetailsParcelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(" Parcel Details".tr),
        centerTitle: true,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            CustomNetworkImage(
              imageUrl:
                  "https://static.vecteezy.com/system/resources/thumbnails/033/226/263/small/close-up-packing-cardboard-box-on-a-table-with-copyspace-against-background-ai-generated-photo.jpg", // Example parcel image
              height: 200.h,
              width: double.infinity,
              borderRadius: BorderRadius.circular(12.r),
            ),
            Gap(20.h),
            // Details Card
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    context,
                    "${AppStrings.parcelId.tr}:",
                    " 112222",
                  ),
                  Gap(6.h),
                  _buildDetailRow(
                    context,
                    "${AppStrings.parcelName.tr}:",
                    " Electronics",
                  ),
                  Gap(6.h),
                  _buildDetailRow(context, "${AppStrings.size.tr}:", " Small"),
                  Gap(6.h),
                  _buildDetailRow(context, "${AppStrings.weight.tr}:", " 1k"),
                  Gap(6.h),
                  _buildDetailRow(
                    context,
                    "${AppStrings.parcelPriority.tr} :",
                    " Urgency",
                  ),
                  Gap(6.h),
                  _buildDetailRow(
                    context,
                    "${AppStrings.date.tr} :",
                    " 12 Aug25-15Aug25",
                  ),
                  Gap(6.h),
                  _buildDetailRow(
                    context,
                    "${AppStrings.time.tr}:",
                    " Fri 28 at 11:30 am -12:00pm",
                  ),
                  Gap(6.h),
                  _buildDetailRow(
                    context,
                    "${AppStrings.handoverLocation.tr}:",
                    "1901 Thornridge Cir. Shiloh, Hawaii 81063",
                  ),

                  Gap(16.h),
                  Text(
                    AppStrings.receiverDetails.tr,
                    style: context.titleMedium.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondPrimaryColor,
                    ),
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    "${AppStrings.receiverName.tr} :",
                    " Chime Alozie",
                  ),
                  Gap(6.h),
                  _buildDetailRow(
                    context,
                    "${AppStrings.receiverPhone.tr} :",
                    " 12233333",
                  ),
                  Gap(6.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${AppStrings.senderRemarks.tr}:",
                        style: context.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                          fontSize: 14.sp,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          " Integer turpis quam, laoreet id orci nec, ultrices lacinia nunc. Aliquam erat vo",
                          style: context.bodySmall.copyWith(
                            color: AppColors.secondPrimaryColor,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Gap(10.h),

            // Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      AppRouter.route.pushNamed(RoutePath.editParcelScreen);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      minimumSize: Size(double.infinity, 50.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.edit,
                          color: AppColors.primaryColor,
                          size: 20.r,
                        ),
                        Gap(8.w),
                        Text(
                          "Edit".tr,
                          style: context.titleMedium.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(16.h),
                  CustomButton(
                    onTap: () {
                      AppDialog.show(
                        context: context,
                        title: AppStrings.getDeliveryPrice.tr,
                        subtitle:
                            "Are you sure you want to get the delivery price?",
                        subtitleColor: AppColors.secondPrimaryColor,
                        actions: [
                          TextButton(
                            onPressed: () {
                              AppRouter.route.pop();
                            },
                            child: Text(
                              AppStrings.cancel.tr,
                              style: context.titleMedium.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              AppRouter.route.goNamed(
                                RoutePath.parcelOwnerNavScreen,
                                extra: 1,
                              );
                            },
                            child: Text(
                              AppStrings.confirm.tr,
                              style: context.titleMedium.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    text: AppStrings.getDeliveryPrice.tr,
                  ),
                  Gap(30.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: context.bodyMedium.copyWith(color: AppColors.primaryColor),
          ),
          TextSpan(
            text: value,
            style: context.bodySmall.copyWith(
              color: AppColors.secondPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
