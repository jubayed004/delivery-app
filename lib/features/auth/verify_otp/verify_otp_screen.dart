import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/custom_assets/assets.gen.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/auth/controller/auth_controller.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/text_field/otp_text_field.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String token;
  final String email;
  final bool isSignUp;
  const VerifyOtpScreen({
    super.key,
    required this.token,
    required this.isSignUp,
    required this.email,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController verifyOtp = TextEditingController();
  final AuthController _auth = Get.find<AuthController>();
  late String purpose;

  @override
  void initState() {
    purpose = widget.isSignUp ? "REGISTER" : "RESET_PASSWORD";
    super.initState();
  }

  @override
  void dispose() {
    verifyOtp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gap(20.h),

                /// ---------- MAIN TITLE ----------
                Text(
                  AppStrings.verifyYourAccount.tr,
                  textAlign: TextAlign.center,
                  style: context.headlineSmall,
                ),
                Gap(12.h),

                /// ---------- SUBTITLE ----------
                Text(
                  AppStrings.verifyYourAccountTitle.tr,
                  textAlign: TextAlign.center,
                  style: context.bodyMedium.copyWith(
                    color: isDarkMode
                        ? Colors.white
                        : AppColors.grayTextSecondaryColor,
                    fontSize: 14.sp,
                  ),
                ),
                Gap(28.h),
                Assets.icons.otpicon.svg(),

                Gap(32.h),

                /// ---------- OTP INPUT ----------
                Align(
                  alignment: Alignment.center,
                  child: OtpTextField(controller: verifyOtp),
                ),

                Gap(28.h),

                /// ---------- CONFIRM BUTTON ----------
                Obx(
                  () => CustomButton(
                    isLoading: _auth.resetVerifyOtpLoading.value,
                    text: AppStrings.verifyCode.tr,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _auth.resetVerifyOtp(
                          otp: verifyOtp.text,
                          purpose: purpose,
                          token: widget.token,
                        );
                      }
                    },
                  ),
                ),
                Gap(28.h),

                /// ---------- DON'T GET CODE TEXT ----------
                Text(AppStrings.didGetACode.tr, style: context.titleMedium),
                Gap(8.h),

                ///  ---------- RESEND WITH TIMER UI ----------
                Obx(
                  () => _auth.resendOtpLoading.value
                      ? LoadingWidget()
                      : _auth.isResendEnabled.value
                      ? TextButton(
                          onPressed: () {
                            _auth.resendOtp(
                              email: widget.email,
                              purpose: purpose,
                            );
                            _auth.resendCode();
                          },
                          child: Text(
                            AppStrings.resendCode.tr,
                            style: context.titleSmall.copyWith(
                              color: AppColors.greenTextColor,
                            ),
                          ),
                        )
                      : Text(
                          "Resend code in 00:${_auth.start.value.toString().padLeft(2, '0')}s",
                          style: context.titleSmall,
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
