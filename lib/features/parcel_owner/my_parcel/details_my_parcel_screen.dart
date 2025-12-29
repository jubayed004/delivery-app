import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/model/parcel_model.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class DetailsMyParcelScreen extends StatelessWidget {
  final ParcelModel parcel;
  const DetailsMyParcelScreen({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(AppStrings.detailsPage.tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image
            Container(
              height: 250.h,
              width: double.infinity,
              color: AppColors.grayTabBgColor,
              child: Image.network(parcel.imageUrl, fit: BoxFit.contain),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Parcel Details
                  _buildDetailRow(
                    context,
                    'Parcel status',
                    parcel.status.name.capitalizeFirst,
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    AppStrings.parcelId.tr,
                    parcel.parcelId,
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    AppStrings.parcelName.tr,
                    parcel.parcelName,
                  ),
                  Gap(8.h),
                  _buildDetailRow(context, AppStrings.size.tr, parcel.size),
                  Gap(8.h),
                  _buildDetailRow(context, AppStrings.weight.tr, parcel.weight),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    AppStrings.parcelPriority.tr,
                    parcel.priority,
                  ),
                  Gap(8.h),
                  _buildDetailRow(context, AppStrings.date.tr, parcel.date),
                  Gap(8.h),
                  _buildDetailRow(context, AppStrings.time.tr, parcel.time),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    AppStrings.handoverLocation.tr,
                    parcel.handoverLocation,
                  ),

                  Gap(16.h),
                  Text(
                    AppStrings.receiverDetails.tr,
                    style: context.titleMedium.copyWith(
                      color: AppColors.secondPrimaryColor,
                    ),
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    AppStrings.receiverName.tr,
                    parcel.receiverName,
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    AppStrings.receiverPhone.tr,
                    parcel.receiverPhone,
                  ),
                  Gap(8.h),
                  _buildDetailRow(
                    context,
                    AppStrings.senderRemarks.tr,
                    parcel.senderRemarks,
                  ),

                  Gap(24.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    width: double.infinity,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${AppStrings.price.tr} : ',
                          style: context.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.error,
                          ),
                        ),
                        Text(
                          '\$${parcel.price.toStringAsFixed(2)}',
                          style: context.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.black, // Or adjust based on design
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(30.h),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            AppRouter.route.pushNamed(
                              RoutePath.paymentScreen,
                              extra: parcel,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            minimumSize: Size(double.infinity, 48.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            AppStrings.accept.tr,
                            style: context.titleMedium.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Gap(16.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            AppRouter.route.pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            minimumSize: Size(double.infinity, 48.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            AppStrings.reject.tr,
                            style: context.titleMedium.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
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
            text: '$label : ',
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor, // Blue color
            ),
          ),
          TextSpan(
            text: value,
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.secondPrimaryColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
