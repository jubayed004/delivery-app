import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/features/driver/professional_info/controller/professional_info_controller.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/share/widgets/no_internet/error_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_data_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_internet_card.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ProfessionalInfoScreen extends StatefulWidget {
  const ProfessionalInfoScreen({super.key});

  @override
  State<ProfessionalInfoScreen> createState() => _ProfessionalInfoScreenState();
}

class _ProfessionalInfoScreenState extends State<ProfessionalInfoScreen> {
  final controller = Get.put(ProfessionalInfoController());
  final LocalService localService = sl();

  @override
  void initState() {
    controller.getDriverInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(AppStrings.professionalInfo.tr),
        centerTitle: true,
        backgroundColor: AppColors.white,
      ),
      body: Obx(() {
        switch (controller.loading.value) {
          case ApiStatus.loading:
            return const LoadingWidget();
          case ApiStatus.internetError:
            return NoInternetCard(
              onTap: () async {
                controller.getDriverInfo();
              },
            );
          case ApiStatus.error:
            return ErrorCard(
              onTap: () async {
                controller.getDriverInfo();
              },
            );
          case ApiStatus.noDataFound:
            return NoDataCard(
              onTap: () async {
                controller.getDriverInfo();
              },
            );
          case ApiStatus.completed:
            final data = controller.professionalInfo.value?.data?.driverInfo;
            final vehicle = controller.professionalInfo.value?.data?.vehicle;
            return SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.getDriverInfo();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.all(16.w),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Route Information Card
                            _buildCard(
                              title: "Route Information",
                              children: [
                                _buildInfoRow(
                                  icon: Icons.location_on_outlined,
                                  label: "From",
                                  value: data?.from?.address ?? "N/A",
                                ),
                                Gap(12.h),
                                _buildInfoRow(
                                  icon: Icons.location_on,
                                  label: "To",
                                  value: data?.to?.address ?? "N/A",
                                ),
                                if (data?.stops != null &&
                                    data!.stops!.isNotEmpty) ...[
                                  Gap(12.h),
                                  _buildInfoRow(
                                    icon: Icons.alt_route,
                                    label: "Stops",
                                    value: data.stops!
                                        .map((e) => e.address)
                                        .join(", "),
                                  ),
                                ],
                              ],
                            ),
                            Gap(16.h),

                            // Vehicle Information Card
                            _buildCard(
                              title: "Vehicle Information",
                              children: [
                                _buildInfoRow(
                                  icon: Icons.directions_car_outlined,
                                  label: "Vehicle Type",
                                  value: vehicle?.vehicleType ?? "N/A",
                                ),
                                Gap(12.h),
                                _buildInfoRow(
                                  icon: Icons.pin,
                                  label: "Vehicle Number",
                                  value: vehicle?.vehicleNumber ?? "N/A",
                                ),
                                Gap(16.h),
                                if (vehicle?.numberPlateImage != null) ...[
                                  _buildLabel("Number Plate Image"),
                                  Gap(8.h),
                                  _buildImagePlaceholder(
                                    width: 120.w,
                                    height: 70.h,
                                    image: vehicle!.numberPlateImage!,
                                  ),
                                  Gap(12.h),
                                ],
                                if (vehicle?.vehicleImages != null &&
                                    vehicle!.vehicleImages!.isNotEmpty) ...[
                                  _buildLabel("Vehicle Images"),
                                  Gap(8.h),
                                  SizedBox(
                                    height: 80.h,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: vehicle.vehicleImages?.length,
                                      itemBuilder: (context, index) {
                                        final image =
                                            vehicle.vehicleImages?[index];
                                        return Padding(
                                          padding: EdgeInsets.only(right: 16.w),
                                          child: _buildImagePlaceholder(
                                            width: 100.w,
                                            height: 80.h,
                                            image: image ?? "",
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Gap(16.h),

                            // Driver Information Card
                            _buildCard(
                              title: "Driver Information",
                              children: [
                                _buildInfoRow(
                                  icon: Icons.badge_outlined,
                                  label: "License Number",
                                  value: data?.driverLicenseNumber ?? "N/A",
                                ),
                                Gap(16.h),
                                if (data?.licenseImage != null) ...[
                                  _buildLabel("License Image"),
                                  Gap(8.h),
                                  _buildImagePlaceholder(
                                    width: 140.w,
                                    height: 90.h,
                                    image: data!.licenseImage!,
                                  ),
                                ],
                              ],
                            ),
                            Gap(16.h),

                            // Schedule & Capacity Card
                            _buildCard(
                              title: "Schedule & Capacity",
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildCompactInfo(
                                        icon: Icons.access_time,
                                        label: "Daily Commute",
                                        value: data?.dailyCommuteTime ?? "N/A",
                                      ),
                                    ),
                                    Gap(12.w),
                                    Expanded(
                                      child: _buildCompactInfo(
                                        icon: Icons.scale_outlined,
                                        label: "Max Weight",
                                        value: data?.maxParcelWeight ?? "N/A",
                                      ),
                                    ),
                                  ],
                                ),
                                if (data?.availableForDelivery != null) ...[
                                  Gap(12.h),
                                  _buildInfoRow(
                                    icon: Icons.check_circle_outline,
                                    label: "Available For Delivery",
                                    value: data!.availableForDelivery!,
                                  ),
                                ],
                                if (data?.pickupTime != null) ...[
                                  Gap(12.h),
                                  _buildInfoRow(
                                    icon: Icons.schedule,
                                    label: "Preferred Pickup Time",
                                    value: data!.pickupTime!,
                                  ),
                                ],
                              ],
                            ),
                            Gap(24.h),

                            // Edit Button
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
                  ],
                ),
              ),
            );
        }
      }),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.blackMainTextColor,
            ),
          ),
          Gap(16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.sp, color: AppColors.primaryColor),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.bodySmall.copyWith(
                  color: AppColors.grayTextSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Gap(4.h),
              Text(
                value,
                style: context.bodyMedium.copyWith(
                  color: AppColors.blackMainTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.sp, color: AppColors.primaryColor),
              Gap(6.w),
              Expanded(
                child: Text(
                  label,
                  style: context.bodySmall.copyWith(
                    color: AppColors.grayTextSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Gap(6.h),
          Text(
            value,
            style: context.bodySmall.copyWith(
              color: AppColors.blackMainTextColor,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: context.bodySmall.copyWith(
        color: AppColors.grayTextSecondaryColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildImagePlaceholder({
    required double width,
    required double height,
    required String image,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: CustomNetworkImage(
        borderRadius: BorderRadius.circular(8.r),
        imageUrl: image,
        width: width,
        height: height,
      ),
    );
  }
}
