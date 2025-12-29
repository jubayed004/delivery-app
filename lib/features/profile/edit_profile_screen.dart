import 'dart:io';
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
  final controller = Get.put(ProfileController());
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    name.dispose();
    controller.onDelete;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Edit Profile ", style: context.bodyLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 170.h,
                width: 150.w,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Obx(() {
                          return controller.selectedImage.value != null
                              ? Image.file(
                                  File(
                                    controller.selectedImage.value?.path ?? "",
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : CustomNetworkImage(
                                  imageUrl: /*controller.profile.value.data?.profileImage ??*/
                                      "",
                                );
                        }),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 2,
                      child: GestureDetector(
                        onTap: () {
                          controller.pickImage();
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          padding: EdgeInsets.only(left: 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
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
              Gap(24),

              ///=============================== Full name text ==================================
              CustomTextField(
                title: AppStrings.fullName.tr,
                fillColor: Colors.white,
                hintText: "Ely Mohammed",
                keyboardType: TextInputType.name,
                controller: name,
                validator: TextFieldValidator.name(),
              ),

              Gap(14),

              ///=============================== PHONE text ==================================
              CustomTextField(
                title: AppStrings.contactNumber.tr,
                controller: number,
                fillColor: Colors.white,
                hintText: "(603) 555-0123",
                keyboardType: TextInputType.number,
                validator: TextFieldValidator.phone(),
              ),
              const Gap(12),

              CustomButton(
                text: "Update",
                isLoading: controller.isUpdateLoading.value,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
