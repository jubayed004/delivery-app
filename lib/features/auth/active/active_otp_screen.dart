import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/custom_assets/assets.gen.dart';
import 'package:delivery_app/features/auth/controller/auth_controller.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/text_field/otp_text_field.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class ActiveOtpScreen extends StatefulWidget {
  final String email;
  final bool isSignUp;
  final String? token;

  const ActiveOtpScreen({
    super.key,
    required this.email,
    this.isSignUp = false,
    this.token,
  });

  @override
  State<ActiveOtpScreen> createState() => _ActiveOtpScreenState();
}

class _ActiveOtpScreenState extends State<ActiveOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController verifyOtp = TextEditingController();
  final AuthController _auth = Get.find<AuthController>();

  late String purpose;

  @override
  void initState() {
    super.initState();
    purpose = widget.isSignUp ? "REGISTER" : "RESET_PASSWORD";
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
                    isLoading: _auth.activeOtpLoading.value,
                    text: AppStrings.verifyCode.tr,
                    onTap: () {
                      _auth.activeOtp(
                        otp: verifyOtp.text,
                        purpose: purpose,
                        token: widget.token,
                      );
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
