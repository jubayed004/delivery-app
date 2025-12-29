import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class ProfessionalInfoScreen extends StatelessWidget {
  const ProfessionalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(AppStrings.professionalInfo.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                context,
                label: "From",
                value: "Chattogram City, Agrabad, Chattogram City, Agrabad",
              ),
              Gap(16.h),
              _buildSection(
                context,
                label: "To",
                value: "Chattogram City, Agrabad",
              ),
              Gap(16.h),
              _buildSection(context, label: "Vehicle Type", value: "Car"),
              Gap(16.h),
              _buildSection(context, label: "Car Number", value: "B456"),
              Gap(16.h),
              _buildLabel(context, "Number plate image"),
              Gap(8.h),
              _buildImagePlaceholder(
                width: 100.w,
                height: 60.h,
                image:
                    "https://c8.alamy.com/comp/2XTW6MC/ontario-canada-registration-vehicle-license-rear-number-plate-blue-lettering-on-white-on-blue-tesla-electric-car-2XTW6MC.jpg",
              ),
              Gap(16.h),
              _buildSection(
                context,
                label: "Stops Along The Way",
                value: "Enter your stops along the way",
              ),
              Gap(16.h),

              // Schedule & Available
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel(context, "Daily Commute Time"),
                        Gap(8.h),
                        _buildValueBox(context, "Enter You Time"),
                      ],
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel(context, "Available For Delivery"),
                        Gap(8.h),
                        _buildValueBox(context, "Enter Available"),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(16.h),

              _buildSection(
                context,
                label: "Max Parcel Weight",
                value: "Enter your max parcel weight",
              ),
              Gap(16.h),
              _buildSection(
                context,
                label: "Preferred Pick-Up Points",
                value: "Enter your preferred pick-up points",
              ),
              Gap(16.h),
              _buildSection(context, label: "Notes", value: "Enter your notes"),
              Gap(16.h),
              _buildSection(
                context,
                label: "Driver licence Number",
                value: "Enter licence number",
              ),
              Gap(16.h),

              _buildLabel(context, "Licence Image"),
              Gap(8.h),
              _buildImagePlaceholder(
                width: 120.w,
                height: 80.h,
                image:
                    "https://media.istockphoto.com/id/691286862/vector/flat-man-driver-license-plastic-card-template-id-card-vector-illustration.jpg?s=612x612&w=0&k=20&c=c-tDqF5B4t2i_eoJXwWsUK05q8ORuLmRbeCa7weLtGc=",
              ),
              Gap(16.h),

              _buildLabel(context, "Car Image"),
              Gap(8.h),
              Row(
                children: [
                  _buildImagePlaceholder(
                    width: 100.w,
                    height: 80.h,
                    image:
                        "https://cdn.pixabay.com/photo/2020/11/09/01/19/car-5725327_1280.jpg",
                  ),
                  Gap(16.w),
                  _buildImagePlaceholder(
                    width: 100.w,
                    height: 80.h,
                    image:
                        "https://cdn.pixabay.com/photo/2012/11/02/13/02/car-63930_1280.jpg",
                  ),
                ],
              ),
              Gap(24.h),
              CustomButton(
                onTap: () {
                  AppRouter.route.pushNamed(
                    RoutePath.professionalInfoEditScreen,
                  );
                },
                text: "Edit Professional Info".tr,
              ),
              Gap(24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, label),
        Gap(8.h),
        _buildValueBox(context, value),
      ],
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Text(
      label,
      style: context.bodyMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.blackMainTextColor,
      ),
    );
  }

  Widget _buildValueBox(BuildContext context, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.grayTextSecondaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        value,
        style: context.bodyMedium.copyWith(
          color: AppColors.grayTextSecondaryColor,
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder({
    required double width,
    required double height,
    required String image,
  }) {
    return CustomNetworkImage(
      borderRadius: BorderRadius.circular(8.r),
      imageUrl: image,
      width: width,
      height: height,
    );
  }
}
