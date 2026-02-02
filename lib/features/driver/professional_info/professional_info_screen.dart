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
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 20.h,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSection(
                              context,
                              label: "From",
                              value: data?.from?.address ?? "N/A",
                            ),
                            Gap(16.h),
                            _buildSection(
                              context,
                              label: "To",
                              value: data?.to?.address ?? "N/A",
                            ),
                            Gap(16.h),
                            _buildSection(
                              context,
                              label: "Vehicle Type",
                              value: vehicle?.vehicleType ?? "N/A",
                            ),
                            Gap(16.h),
                            _buildSection(
                              context,
                              label: "Car Number",
                              value: vehicle?.vehicleNumber ?? "N/A",
                            ),
                            Gap(16.h),
                            _buildLabel(context, "Number plate image"),
                            Gap(8.h),
                            if (vehicle?.numberPlateImage != null)
                              _buildImagePlaceholder(
                                width: 100.w,
                                height: 60.h,
                                image: vehicle!.numberPlateImage!,
                              ),
                            Gap(16.h),
                            _buildSection(
                              context,
                              label: "Stops Along The Way",
                              value:
                                  data?.stops
                                      ?.map((e) => e.address)
                                      .join(", ") ??
                                  "No stops",
                            ),
                            Gap(16.h),

                            // Schedule & Available
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel(
                                        context,
                                        "Daily Commute Time",
                                      ),
                                      Gap(8.h),
                                      _buildValueBox(
                                        context,
                                        data?.dailyCommuteTime ?? "N/A",
                                      ),
                                    ],
                                  ),
                                ),
                                Gap(16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLabel(
                                        context,
                                        "Available For Delivery",
                                      ),
                                      Gap(8.h),
                                      _buildValueBox(
                                        context,
                                        data?.availableForDelivery ?? "N/A",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gap(16.h),

                            _buildSection(
                              context,
                              label: "Max Parcel Weight",
                              value: data?.maxParcelWeight ?? "N/A",
                            ),
                            Gap(16.h),
                            _buildSection(
                              context,
                              label: "Preferred Pick-Up Points",
                              value: data?.pickupTime ?? "N/A",
                            ),
                            Gap(16.h),
                            _buildSection(
                              context,
                              label: "Driver licence Number",
                              value: data?.driverLicenseNumber ?? "N/A",
                            ),
                            Gap(16.h),

                            _buildLabel(context, "Licence Image"),
                            Gap(8.h),
                            if (data?.licenseImage != null)
                              _buildImagePlaceholder(
                                width: 120.w,
                                height: 80.h,
                                image: data!.licenseImage!,
                              ),
                            Gap(16.h),

                            _buildLabel(context, "Vehicle Images"),
                            Gap(8.h),
                            if (vehicle?.vehicleImages != null &&
                                vehicle!.vehicleImages!.isNotEmpty)
                              SizedBox(
                                height: 80.h,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: vehicle.vehicleImages!.length,
                                  separatorBuilder: (_, __) => Gap(16.w),
                                  itemBuilder: (context, index) {
                                    return _buildImagePlaceholder(
                                      width: 100.w,
                                      height: 80.h,
                                      image: vehicle.vehicleImages![index],
                                    );
                                  },
                                ),
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
                  ],
                ),
              ),
            );
        }
      }),
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
