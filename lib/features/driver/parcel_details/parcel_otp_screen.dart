import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/text_field/otp_text_field.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class ParcelOtpScreen extends StatefulWidget {
  const ParcelOtpScreen({super.key});

  @override
  State<ParcelOtpScreen> createState() => _ParcelOtpScreenState();
}

class _ParcelOtpScreenState extends State<ParcelOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text("OTP CODE", style: context.titleMedium),
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gap(40.h),
                Text(
                  "Receber accept parcel",
                  style: context.bodyLarge.copyWith(
                    color: AppColors.grayTextSecondaryColor,
                  ),
                ),
                Gap(24.h),
                Align(
                  alignment: Alignment.center,
                  child: OtpTextField(controller: otpController),
                ),
                Spacer(),
                CustomButton(
                  onTap: () {
                    AppRouter.route.goNamed(RoutePath.driverNavScreen);
                  },
                  text: "Share with receiver",
                  icon: Icons.share,
                ),
                Gap(20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
