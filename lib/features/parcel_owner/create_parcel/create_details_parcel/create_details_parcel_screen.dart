import 'package:delivery_app/features/parcel_owner/create_parcel/create_details_parcel/controller/create_details_parcel_controller.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/share/widgets/button/custom_button.dart';
import 'package:delivery_app/share/widgets/dialog/custom_dialog.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class CreateDetailsParcelScreen extends StatefulWidget {
  final String id;
  const CreateDetailsParcelScreen({super.key, required this.id});

  @override
  State<CreateDetailsParcelScreen> createState() =>
      _CreateDetailsParcelScreenState();
}

class _CreateDetailsParcelScreenState extends State<CreateDetailsParcelScreen> {
  final CreateDetailsParcelController createDetailsParcelController = Get.put(
    CreateDetailsParcelController(),
  );

  final bool isDeliveryPrice = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      createDetailsParcelController.createDetailsParcel(id: widget.id);
    });
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<CreateDetailsParcelController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text("Parcel Details".tr),
        centerTitle: true,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: Obx(() {
        if (createDetailsParcelController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = createDetailsParcelController.parcelDetails.value?.data;
        if (data == null) {
          return Center(child: Text("No data found".tr));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              CustomNetworkImage(
                imageUrl:
                    (data.parcelImages != null && data.parcelImages!.isNotEmpty)
                    ? data.parcelImages!.first
                    : "https://static.vecteezy.com/system/resources/thumbnails/033/226/263/small/close-up-packing-cardboard-box-on-a-table-with-copyspace-against-background-ai-generated-photo.jpg",
                height: 200.h,
                width: double.infinity,
                borderRadius: BorderRadius.circular(12.r),
              ),
              Gap(20.h),
              // Details Card
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      context,
                      "${AppStrings.parcelId.tr}",
                      " ${data.parcelId ?? ''}",
                    ),
                    Gap(6.h),
                    _buildDetailRow(
                      context,
                      "${AppStrings.parcelName.tr}",
                      " ${data.parcelName ?? ''}",
                    ),
                    Gap(6.h),
                    _buildDetailRow(
                      context,
                      "${AppStrings.size.tr}",
                      " ${data.size ?? ''}",
                    ),
                    Gap(6.h),
                    _buildDetailRow(
                      context,
                      "${AppStrings.weight.tr}",
                      " ${data.weight?.toString() ?? ''}kg",
                    ),
                    Gap(6.h),
                    _buildDetailRow(
                      context,
                      "${AppStrings.parcelPriority.tr} ",
                      " ${data.priority ?? ''}",
                    ),
                    Gap(6.h),
                    _buildDetailRow(
                      context,
                      "${AppStrings.date.tr} ",
                      " ${data.date?.toIso8601String().split('T')[0] ?? ''}",
                    ),
                    Gap(6.h),
                    _buildDetailRow(
                      context,
                      "${AppStrings.time.tr}",
                      " ${data.time ?? ''}",
                    ),
                    Gap(6.h),
                    _buildDetailRow(
                      context,
                      "${AppStrings.handoverLocation.tr}:",
                      " ${data.handoverLocation?.address ?? ''}",
                    ),

                    Gap(16.h),
                    Text(
                      AppStrings.receiverDetails.tr,
                      style: context.titleMedium.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondPrimaryColor,
                      ),
                    ),
                    Gap(8.h),
                    _buildDetailRow(
                      context,
                      "${AppStrings.receiverName.tr} ",
                      " ${data.receiverName ?? ''}",
                    ),
                    Gap(6.h),
                    _buildDetailRow(
                      context,
                      "${AppStrings.receiverPhone.tr} ",
                      " ${data.receiverPhone ?? ''}",
                    ),
                    Gap(6.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppStrings.senderRemarks.tr}",
                          style: context.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            " ${data.senderRemarks ?? data.review ?? ''}",
                            style: context.bodySmall.copyWith(
                              color: AppColors.secondPrimaryColor,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(16),
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Color(0xffFF6E6E),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          "Waiting for  parcel price",
                          style: context.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Gap(10.h),

              // Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        AppRouter.route.pushNamed(RoutePath.editParcelScreen);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        minimumSize: Size(double.infinity, 50.h),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.edit,
                            color: AppColors.primaryColor,
                            size: 20.r,
                          ),
                          Gap(8.w),
                          Text(
                            "Edit".tr,
                            style: context.titleMedium.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(16.h),
                    CustomButton(
                      onTap: () {
                        AppDialog.show(
                          context: context,
                          title: AppStrings.getDeliveryPrice.tr,
                          subtitle:
                              "Are you sure you want to get the delivery price?",
                          subtitleColor: AppColors.secondPrimaryColor,
                          actions: [
                            TextButton(
                              onPressed: () {
                                AppRouter.route.pop();
                              },
                              child: Text(
                                AppStrings.cancel.tr,
                                style: context.titleMedium.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                AppDialog.show(
                                  context: context,
                                  title: AppStrings.getDeliveryPrice.tr,
                                  subtitle:
                                      "Are you sure you want to get the delivery price?",
                                  subtitleColor: AppColors.secondPrimaryColor,
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        AppRouter.route.pop();
                                      },
                                      child: Text(
                                        AppStrings.cancel.tr,
                                        style: context.titleMedium.copyWith(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        AppRouter.route.pop();
                                      },
                                      child: Text(
                                        AppStrings.confirm.tr,
                                        style: context.titleMedium.copyWith(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                                AppRouter.route.pop();
                              },
                              child: Text(
                                AppStrings.confirm.tr,
                                style: context.titleMedium.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      text: AppStrings.getDeliveryPrice.tr,
                    ),
                    Gap(30.h),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: context.bodyMedium.copyWith(color: AppColors.primaryColor),
          ),
          TextSpan(text: value, style: context.bodySmall),
        ],
      ),
    );
  }
}
