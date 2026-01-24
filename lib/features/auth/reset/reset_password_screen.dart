import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/features/auth/controller/auth_controller.dart';
import 'package:delivery_app/helper/validator/text_field_validator.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;
  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _resetPassword = TextEditingController();
  final TextEditingController _resetConfirmPassword = TextEditingController();
  final AuthController _auth = Get.find<AuthController>();

  @override
  void dispose() {
    _resetPassword.dispose();
    _resetConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.ntsamaela.tr,
          style: context.headlineSmall.copyWith(color: AppColors.primaryColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// ---------- MAIN TITLE ----------
                Text(
                  AppStrings.createNewPassword.tr,
                  textAlign: TextAlign.center,
                  style: context.headlineSmall,
                ),
                Gap(12.h),

                /// ---------- SUBTITLE ----------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    AppStrings.createNewPasswordTitle.tr,
                    textAlign: TextAlign.center,
                    style: context.bodyMedium.copyWith(
                      color: AppColors.grayTextSecondaryColor,
                    ),
                  ),
                ),
                Gap(32.h),

                /// ---------- New Password Input ----------
                CustomTextField(
                  title: AppStrings.newPassword.tr,
                  hintText: AppStrings.enterYourNewPassword.tr,
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(Icons.lock_outline),
                  isPassword: true,
                  controller: _resetPassword,
                  validator: TextFieldValidator.password(),
                ),
                Gap(16.h),

                /// ---------- Confirm Password ----------
                CustomTextField(
                  title: AppStrings.confirmNewPassword.tr,
                  hintText: AppStrings.confirmYourNewPassword.tr,
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(Icons.lock_outline),
                  isPassword: true,
                  controller: _resetConfirmPassword,
                  validator: TextFieldValidator.confirmPassword(_resetPassword),
                ),
                Gap(40.h),

                /// ---------- Confirm Button ----------
                Obx(
                  () => CustomButton(
                    text: AppStrings.confirm.tr,
                    isLoading: _auth.resetPasswordLoading.value,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _auth.resetPassword(
                          password: _resetPassword.text,
                          token: widget.token,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
