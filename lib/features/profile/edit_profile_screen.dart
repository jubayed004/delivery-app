import 'dart:io';
import 'package:delivery_app/core/custom_assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:delivery_app/features/profile/controller/profile_controller.dart';
import 'package:delivery_app/helper/validator/text_field_validator.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController profileController = Get.find();
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = profileController.profile.value.data?.fullName ?? "";
    number.text = profileController.profile.value.data?.phoneNumber ?? "";
  }

  @override
  void dispose() {
    name.dispose();
    number.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Edit Profile", style: context.titleLarge),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Profile Image Section
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            height: 120.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.2),
                                width: 4,
                              ),
                            ),
                            child: ClipOval(
                              child: Obx(() {
                                if (profileController.selectedImage.value !=
                                    null) {
                                  return Image.file(
                                    File(
                                      profileController
                                              .selectedImage
                                              .value
                                              ?.path ??
                                          "",
                                    ),
                                    fit: BoxFit.cover,
                                  );
                                } else if (profileController
                                            .profile
                                            .value
                                            .data
                                            ?.profilePicture !=
                                        null &&
                                    profileController
                                        .profile
                                        .value
                                        .data!
                                        .profilePicture!
                                        .isNotEmpty) {
                                  return CustomNetworkImage(
                                    imageUrl:
                                        profileController
                                            .profile
                                            .value
                                            .data
                                            ?.profilePicture ??
                                        "",
                                    fit: BoxFit.cover,
                                  );
                                } else {
                                  return Container(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.1,
                                    ),
                                    padding: EdgeInsets.all(20),
                                    child: Assets.images.profile.image(),
                                  );
                                }
                              }),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                profileController.pickImage();
                              },
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryColor,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Iconsax.camera,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(32.h),

                    // Form Fields
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Personal Information",
                          style: context.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(20.h),
                        CustomTextField(
                          title: AppStrings.fullName.tr,
                          fillColor: AppColors.backgroundColor,
                          hintText: "Ely Mohammed",
                          keyboardType: TextInputType.name,
                          controller: name,
                          validator: TextFieldValidator.name(),
                        ),
                        Gap(16.h),
                        CustomTextField(
                          title: AppStrings.contactNumber.tr,
                          controller: number,
                          fillColor: AppColors.backgroundColor,
                          hintText: "(603) 555-0123",
                          keyboardType: TextInputType.number,
                          validator: TextFieldValidator.phone(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Update Button
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Obx(
              () => CustomButton(
                text: "Update Profile",
                isLoading: profileController.updateProfileLoading.value,
                onTap: () {
                  final body = {
                    "full_name": name.text,
                    "phone_number": number.text,
                  };

                  if (_formKey.currentState!.validate()) {
                    profileController.updateProfile(body: body);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
