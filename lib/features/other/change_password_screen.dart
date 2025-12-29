/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delivery_app/features/auth/controller/auth_controller.dart';
import 'package:delivery_app/helper/validator/text_field_validator.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _resetPassword = TextEditingController();
  final TextEditingController _resetConfirmPassword = TextEditingController();
  final AuthController _auth = Get.find<AuthController>();

  @override
  void dispose() {
    _resetConfirmPassword.dispose();
    _resetPassword.dispose();
    _oldPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Change Password'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        /// ---------- Old Password Input ----------
                        CustomTextField(
                          title: "Old Password".tr,
                          hintText: AppStrings.enterYourPassword.tr,
                          keyboardType: TextInputType.text,
                          prefixIcon: Icon(Iconsax.lock_1),
                          isPassword: true,
                          controller: _oldPassword,
                          validator: TextFieldValidator.password(),
                          onChanged: (value) {
                            _auth.password.value = value;
                          },
                        ),
                        Gap(16.h),

                        /// ---------- New Password Input ----------
                        CustomTextField(
                          title: AppStrings.newPassword.tr,
                          hintText: AppStrings.enterYourNewPassword.tr,
                          keyboardType: TextInputType.text,
                          prefixIcon: Icon(Iconsax.lock_1),
                          isPassword: true,
                          controller: _resetPassword,
                          validator: TextFieldValidator.password(),
                          onChanged: (value) {
                            _auth.password.value = value;
                          },
                        ),
                        Gap(16.h),

                        /// ---------- Confirm Password ----------
                        CustomTextField(
                          title: AppStrings.confirmPassword.tr,
                          hintText: AppStrings.confirmYourNewPassword.tr,
                          keyboardType: TextInputType.text,
                          prefixIcon: Icon(Iconsax.lock_1),
                          isPassword: true,
                          controller: _resetConfirmPassword,
                          validator: TextFieldValidator.confirmPassword(
                            _resetPassword,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              */
/*   CustomButton(
                text: AppStrings.updatePassword.tr,
                onTap: () => AppRouter.route.goNamed(RoutePath.navigationPage),
              ),*//*

            ],
          ),
        ),
      ),
    );
  }
}
*/
