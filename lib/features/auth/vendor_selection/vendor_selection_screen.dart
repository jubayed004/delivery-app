import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/custom_assets/assets.gen.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/common_controller/common_controller.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class VendorSelectionScreen extends StatefulWidget {
  const VendorSelectionScreen({super.key});

  @override
  State<VendorSelectionScreen> createState() => _VendorSelectionScreenState();
}

class _VendorSelectionScreenState extends State<VendorSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(AppStrings.welcomeToNtsamaela.tr),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 56),
          child: Column(
            spacing: context.height * 0.05,
            children: [
              Assets.images.vendorchangeimage.image(
                height: context.screenHeight * 0.5,
              ),
              Column(
                children: [
                  Text(AppStrings.joinUs.tr, style: context.headlineSmall),

                  Gap(32),
                  CustomButton(
                    onTap: () {
                      CommonController.to.isUser.value = false;
                      AppRouter.route.pushNamed(RoutePath.signUpScreen);
                    },
                    text: AppStrings.asAParcelOwner.tr,
                  ),
                  Gap(16),
                  CustomButton(
                    onTap: () {
                      CommonController.to.isUser.value = true;
                      AppRouter.route.pushNamed(RoutePath.signUpScreen);
                    },
                    text: AppStrings.asACommuterDriver.tr,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
