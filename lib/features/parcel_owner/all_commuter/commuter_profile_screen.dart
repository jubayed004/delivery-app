import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class CommuterProfileScreen extends StatelessWidget {
  const CommuterProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(AppStrings.commuterProfile.tr),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: CustomNetworkImage(
                        imageUrl:
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmLlz4kiZ23iny0wdtSPKQSpK-tpZfuM2QAQ&s",
                        height: 80.r,
                        width: 80.r,
                      ),
                    ),
                    Gap(8.h),
                    Text(
                      "John Doe",
                      style: context.titleMedium.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Rating:",
                          style: context.bodyMedium.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        Gap(4.w),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text("4.5 (120 deliveries)", style: context.bodyMedium),
                      ],
                    ),
                    Gap(4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Vehicle:",
                          style: context.bodyMedium.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        Gap(4.w),
                        const Icon(
                          Icons.directions_car,
                          color: Colors.red,
                          size: 16,
                        ),
                        Text(" Car", style: context.bodyMedium),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(20.h),

              _buildInfoRow(context, "From:", "Dhaka"),
              _buildInfoRow(context, "To:", "Chittagong"),
              _buildInfoRow(context, "Stops Along The Way:", "Comilla, Feni"),
              _buildInfoRow(
                context,
                "Schedule & Availability",
                "",
              ), // Header for next section mostly? Design has it inline sometimes.

              _buildInfoRow(context, "Car Number:", "DHA-1234"),
              Gap(12.h),
              Text(
                "Number Plate Image",
                style: context.titleSmall.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              Gap(8.h),
              CustomNetworkImage(
                imageUrl:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2Qp8paJgXVKLyyJkx4N7TOlv5izREplTlXw&s",
                height: 80.h,
                width: 100.w,
                borderRadius: BorderRadius.circular(4.r),
              ),
              Gap(16.h),

              _buildInfoRow(
                context,
                "Daily Commute Time:",
                "8:00 AM - 6:00 PM",
                isLabelColorPrimary: true,
              ),
              _buildInfoRow(
                context,
                "Available For Delivery:",
                "Monday - Friday",
                isLabelColorPrimary: true,
              ),
              Gap(16.h),
              Text(
                "Capacity",
                style: context.bodyLarge.copyWith(color: Colors.grey),
              ),
              Gap(8.h),
              _buildInfoRow(
                context,
                "Max Parcel Weight:",
                "10 kg",
                isLabelColorPrimary: true,
              ),
              _buildInfoRow(
                context,
                "Parcel Size:",
                "Medium",
                isLabelColorPrimary: true,
              ),

              Gap(16.h),
              _buildInfoRow(
                context,
                "Preferred Pick-Up Points:",
                "Gulshan, Banani",
                isLabelColorPrimary: true,
              ),
              _buildInfoRow(
                context,
                "Notes:",
                "Reliable and punctual driver",
                isLabelColorPrimary: true,
              ),

              Gap(16.h),
              Text(
                "Car image",
                style: context.titleSmall.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              Gap(8.h),
              SizedBox(
                height: 90.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (context, index) => Gap(12.w),
                  itemBuilder: (context, index) {
                    return CustomNetworkImage(
                      imageUrl:
                          "https://images.unsplash.com/photo-1459603677915-a62079ffd002?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8Y2FyJTIwaW1hZ2V8ZW58MHx8MHx8fDA%3D",
                      height: 80.h,
                      width: 100.w,
                      borderRadius: BorderRadius.circular(8.r),
                    );
                  },
                ),
              ),
              Gap(30.h),

              CustomButton(
                text: AppStrings.sendDeliveryRequest.tr,
                onTap: () {
                  AppRouter.route.pop();
                },
              ),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isLabelColorPrimary = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: RichText(
        text: TextSpan(
          text: "$label ",
          style: context.bodyMedium.copyWith(
            color: isLabelColorPrimary
                ? AppColors.primaryColor
                : AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(
              text: value,
              style: context.bodyMedium.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
