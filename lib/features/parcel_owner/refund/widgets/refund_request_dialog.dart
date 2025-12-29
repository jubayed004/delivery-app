import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/helper/validator/text_field_validator.dart';
import 'package:delivery_app/share/widgets/align/custom_align_text.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:delivery_app/share/widgets/text_field/description_text_field.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class RefundRequestDialog extends StatefulWidget {
  const RefundRequestDialog({super.key});
  @override
  State<RefundRequestDialog> createState() => _RefundRequestDialogState();
}

class _RefundRequestDialogState extends State<RefundRequestDialog> {
  final ValueNotifier<bool> isOnlinePayment = ValueNotifier<bool>(false);
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.currency_exchange,
                  size: 40.sp,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                AppStrings.reasonForRefund.tr,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 16.h),
              CustomAlignText(text: AppStrings.reason.tr),
              SizedBox(height: 8.h),
              CustomTextField(
                controller: reasonController,
                hintText: AppStrings.enterReason.tr,
                validator: TextFieldValidator.required(
                  errorText: 'Reason is required',
                ),
                fillColor: Colors.white,
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.onlinePaymentSend.tr,
                      style: context.bodyMedium.copyWith(
                        color: Colors.black87,
                        fontSize: 12.sp,
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: isOnlinePayment,
                      builder: (context, currentValue, child) {
                        return Radio<bool>(
                          value: true,
                          groupValue: currentValue,
                          onChanged: (newValue) {
                            if (newValue != null) {
                              isOnlinePayment.value = newValue;
                            }
                          },
                          toggleable: true,
                          activeColor: AppColors.primaryColor,
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // Description Input
              CustomAlignText(text: AppStrings.addDescription.tr),
              SizedBox(height: 8.h),
              DescriptionTextField(
                controller: descriptionController,
                hintText: AppStrings.writeYourDescription.tr,
                maxLines: 4,
              ),
              SizedBox(height: 20.h),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => AppRouter.route.pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        AppStrings.cancel.tr,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          AppRouter.route.pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        AppStrings.refundRequest.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    reasonController.dispose();
    descriptionController.dispose();
    isOnlinePayment.dispose();
    super.dispose();
  }
}
