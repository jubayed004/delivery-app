import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/model/parcel_model.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class PaymentScreen extends StatefulWidget {
  final ParcelModel parcel;
  const PaymentScreen({super.key, required this.parcel});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'online';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(AppStrings.paymentOption.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Parcel Info Card
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Parcel Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              widget.parcel.imageUrl,
                              height: 80.h,
                              width: 80.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 80.h,
                                  width: 80.w,
                                  color: AppColors.grayTabBgColor,
                                  child: Icon(
                                    Icons.image,
                                    color: AppColors.grayTextSecondaryColor,
                                  ),
                                );
                              },
                            ),
                          ),
                          Gap(12.w),
                          // Parcel Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow(
                                  AppStrings.parcelId.tr,
                                  widget.parcel.parcelId,
                                ),
                                Gap(4.h),
                                _buildInfoRow(
                                  AppStrings.parcelName.tr,
                                  widget.parcel.parcelName,
                                ),
                                Gap(4.h),
                                _buildInfoRow(
                                  'Address',
                                  widget.parcel.handoverLocation,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Gap(16.h),

                    // Total Amount
                    Text(
                      AppStrings.totalAmount.tr,
                      style: context.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackMainTextColor,
                      ),
                    ),
                    Gap(8.h),
                    Text(
                      '\$${widget.parcel.price.toStringAsFixed(2)}',
                      style: context.headlineMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.error,
                      ),
                    ),

                    Gap(24.h),

                    // Payment System Selection
                    Text(
                      AppStrings.selectPaymentSystem.tr,
                      style: context.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackMainTextColor,
                      ),
                    ),
                    Gap(12.h),

                    // Online Payment Option
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: selectedPaymentMethod == 'online'
                              ? AppColors.primaryColor
                              : AppColors.linesDarkColor,
                        ),
                      ),
                      child: RadioListTile<String>(
                        value: 'online',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                        title: Text(
                          AppStrings.onlinePayment.tr,
                          style: context.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackMainTextColor,
                          ),
                        ),
                        activeColor: AppColors.primaryColor,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            CustomButton(
              onTap: () {
                AppRouter.route.goNamed(
                  RoutePath.parcelOwnerNavScreen,
                  extra: 1,
                );
              },
              text: AppStrings.proceedToPay.tr,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: context.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          TextSpan(
            text: value,
            style: context.bodySmall.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.grayTextSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
