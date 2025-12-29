import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:delivery_app/core/custom_assets/assets.gen.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/helper/validator/text_field_validator.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(AppStrings.ntsamaela.tr),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              /// ---------- MAIN TITLE ----------
              Text(
                AppStrings.createYourAccount.tr,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall,
              ),
              Gap(6),

              /// ---------- SUBTITLE ----------
              Text(
                AppStrings.signUpTitle.tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grayTextSecondaryColor,
                ),
              ),
              Gap(26),

              /// ---------- Name ----------
              CustomTextField(
                title: AppStrings.fullName.tr,
                hintText: AppStrings.enterYourName.tr,
                keyboardType: TextInputType.name,
                validator: TextFieldValidator.name(),
              ),
              Gap(14),

              /// ---------- Email ----------
              CustomTextField(
                title: AppStrings.email.tr,
                hintText: AppStrings.enterYourEmail.tr,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.mail_outline),
                validator: TextFieldValidator.email(),
              ),
              Gap(14),

              /// ---------- Password ----------
              CustomTextField(
                title: AppStrings.password.tr,
                hintText: AppStrings.enterYourPassword.tr,
                prefixIcon: const Icon(Icons.lock_outline),
                isPassword: true,
                validator: TextFieldValidator.password(),
              ),
              Gap(14),

              /// ---------- Confirm Password ----------
              CustomTextField(
                title: AppStrings.confirmPassword.tr,
                hintText: AppStrings.confirmPassword.tr,
                prefixIcon: const Icon(Icons.lock_outline),
                isPassword: true,
                validator: TextFieldValidator.password(),
              ),
              Gap(24),

              /// ---------- Register Button ----------
              CustomButton(
                text: AppStrings.signUp.tr,
                onTap: () =>
                    AppRouter.route.pushNamed(RoutePath.activeOtpScreen),
              ),

              Gap(26),

              /// ---------- Divider + Text ----------
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: AppColors.grayTextSecondaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      AppStrings.signInWith.tr,
                      style: context.textTheme.titleSmall,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: AppColors.grayTextSecondaryColor,
                    ),
                  ),
                ],
              ),
              Gap(26),

              /// ---------- Social Icons ----------
              Row(
                spacing: 24,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        width: 1,
                        color: AppColors.blueTextColor400,
                      ),
                    ),
                    child: Assets.icons.google.svg(width: 22),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        width: 1,
                        color: AppColors.blueTextColor400,
                      ),
                    ),
                    child: Assets.icons.facebook.svg(width: 22),
                  ),
                ],
              ),
              Gap(34),

              /// ---------- Already Have Account ----------
              Text(
                AppStrings.dontHaveAnAccount.tr,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Gap(4),
              GestureDetector(
                onTap: () => AppRouter.route.pushNamed(RoutePath.loginScreen),
                child: Text(
                  AppStrings.signIn.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.greenTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Gap(10),
            ],
          ),
        ),
      ),
    );
  }
}
