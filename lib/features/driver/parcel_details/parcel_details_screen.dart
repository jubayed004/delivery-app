import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class ParcelDetailsScreen extends StatelessWidget {
  const ParcelDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.detailsPage.tr),
        centerTitle: true,
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Gap(20.h),
            // Parcel Image
            CustomNetworkImage(
              imageUrl:
                  "https://static.vecteezy.com/system/resources/thumbnails/033/226/263/small/close-up-packing-cardboard-box-on-a-table-with-copyspace-against-background-ai-generated-photo.jpg", // Example parcel image
              height: 200.h,
              width: double.infinity,
              borderRadius: BorderRadius.circular(12.r),
            ),
            Gap(24.h),

            // Details Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    context,
                    label: AppStrings.parcelId.tr,
                    value: "112222",
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    label: "${AppStrings.parcelName.tr}:",
                    value: "Electronics",
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    label: AppStrings.size.tr,
                    value: "Small",
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    label: "${AppStrings.weight.tr}:",
                    value: "1k",
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    label: AppStrings.price.tr,
                    value: "\$50.00",
                    valueColor: AppColors.redColor,
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    label: AppStrings.parcelPriority.tr,
                    value: "Urgency",
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    label: AppStrings.date.tr,
                    value: "12 Aug25-15Aug25",
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    label: AppStrings.time.tr,
                    value: "Fri 28 at 11:30 am - 12:00pm",
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    label: AppStrings.pickupLocation.tr,
                    value: "1901 Thornridge Cir. Shiloh, Hawaii 81063",
                    isMultiLine: true,
                  ),
                  Gap(16.h),
                  Text(
                    'Sender details'.tr,
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    label: AppStrings.receiverName.tr,
                    value: "Chime Alozie",
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    label: AppStrings.receiverPhone.tr,
                    value: "12233333",
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    label: "${"sender location".tr} :",
                    value: "1901 Thornridge Cir. Shiloh, Hawaii 81063",
                    isMultiLine: true,
                  ),
                  Gap(16.h),
                  Text(
                    AppStrings.receiverDetails.tr,
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    label: AppStrings.receiverName.tr,
                    value: "Chime Alozie",
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    label: AppStrings.receiverPhone.tr,
                    value: "12233333",
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    label:
                        "${AppStrings.deliveryPoint.tr} :", // Closest match to "Deliver location"
                    value: "1901 Thornridge Cir. Shiloh, Hawaii 81063",
                    isMultiLine: true,
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    label: AppStrings.senderRemarks.tr,
                    value:
                        "Integer turpis quam, laoreet id orci nec, ultrices lacinia nunc. Aliquam erat vo",
                    isMultiLine: true,
                  ),
                ],
              ),
            ),
            Gap(100.h), // Space for bottom button
          ],
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: SizedBox(
          width: double.infinity,
          child: CustomButton(
            onTap: () {
              AppRouter.route.pushNamed(RoutePath.transactionScreen);
            },
            text: AppStrings.confirm.tr,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
    bool isMultiLine = false,
  }) {
    return RichText(
      text: TextSpan(
        text: "$label ",
        style: context.bodyMedium.copyWith(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w700,
        ),
        children: [
          TextSpan(
            text: value,
            style: context.bodyMedium.copyWith(
              color: valueColor ?? AppColors.grayTextSecondaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      maxLines: isMultiLine ? 3 : 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
