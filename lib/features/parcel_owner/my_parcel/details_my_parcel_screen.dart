import 'package:delivery_app/features/parcel_owner/my_parcel/controller/details_my_parcel_controller.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/model/parcel_model.dart';
import 'package:delivery_app/share/widgets/custom_text/custom_text.dart';
import 'package:delivery_app/share/widgets/dialog/custom_dialog.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/share/widgets/text_field/custom_text_field.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/share/widgets/no_internet/error_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_data_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_internet_card.dart';

class DetailsMyParcelScreen extends StatefulWidget {
  final ParcelItem parcel;
  const DetailsMyParcelScreen({super.key, required this.parcel});

  @override
  State<DetailsMyParcelScreen> createState() => _DetailsMyParcelScreenState();
}

class _DetailsMyParcelScreenState extends State<DetailsMyParcelScreen> {
  final DetailsMyParcelController controller = Get.put(
    DetailsMyParcelController(),
  );
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController finalPriceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.parcel.id != null) {
        controller.singleDetailsMyParcel(id: widget.parcel.id!);
      }
    });
  }

  @override
  void dispose() {
    reasonController.dispose();
    finalPriceController.dispose();
    Get.delete<DetailsMyParcelController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(AppStrings.detailsPage.tr),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (widget.parcel.id != null) {
            await controller.singleDetailsMyParcel(id: widget.parcel.id!);
          }
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            Obx(() {
              switch (controller.loading.value) {
                case ApiStatus.loading:
                  return const SliverFillRemaining(
                    child: Center(child: LoadingWidget()),
                  );
                case ApiStatus.error:
                  return SliverFillRemaining(
                    child: Center(
                      child: ErrorCard(
                        onTap: () {
                          if (widget.parcel.id != null) {
                            controller.singleDetailsMyParcel(
                              id: widget.parcel.id!,
                            );
                          }
                        },
                      ),
                    ),
                  );
                case ApiStatus.internetError:
                  return SliverFillRemaining(
                    child: Center(
                      child: NoInternetCard(
                        onTap: () {
                          if (widget.parcel.id != null) {
                            controller.singleDetailsMyParcel(
                              id: widget.parcel.id!,
                            );
                          }
                        },
                      ),
                    ),
                  );
                case ApiStatus.noDataFound:
                  return SliverFillRemaining(
                    child: Center(
                      child: NoDataCard(
                        onTap: () {
                          if (widget.parcel.id != null) {
                            controller.singleDetailsMyParcel(
                              id: widget.parcel.id!,
                            );
                          }
                        },
                      ),
                    ),
                  );
                case ApiStatus.completed:
                  final parcelDetails = controller.detailsMyParcel.value?.data;
                  if (parcelDetails == null) {
                    return SliverFillRemaining(
                      child: Center(child: Text("No details found".tr)),
                    );
                  }
                  final price =
                      double.tryParse(
                        '${(parcelDetails.priceRequests != null && parcelDetails.priceRequests!.isNotEmpty) ? parcelDetails.priceRequests!.last.proposedPrice : 0}',
                      ) ??
                      0.0;
                  final isPrice = price > 0;
                  return SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Image
                        Container(
                          height: 250.h,
                          width: double.infinity,
                          color: AppColors.grayTabBgColor,
                          child: CustomNetworkImage(
                            imageUrl:
                                (parcelDetails.parcelImages != null &&
                                    parcelDetails.parcelImages!.isNotEmpty)
                                ? parcelDetails.parcelImages!.first
                                : "",
                            fit: BoxFit.contain,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Parcel Details
                              _buildDetailRow(
                                context,
                                "${'Parcel status'.tr} :",
                                parcelDetails.status ?? "",
                              ),
                              Gap(8.h),
                              _buildDetailRow(
                                context,
                                AppStrings.parcelId.tr,
                                parcelDetails.parcelId ?? "",
                              ),
                              Gap(8.h),
                              _buildDetailRow(
                                context,
                                "${AppStrings.parcelName.tr} :",
                                parcelDetails.parcelName ?? "",
                              ),
                              Gap(8.h),
                              _buildDetailRow(
                                context,
                                AppStrings.size.tr,
                                parcelDetails.size ?? "",
                              ),
                              Gap(8.h),
                              _buildDetailRow(
                                context,
                                AppStrings.weight.tr,
                                "${parcelDetails.weight ?? ""} kg",
                              ),
                              Gap(8.h),
                              _buildDetailRow(
                                context,
                                AppStrings.parcelPriority.tr,
                                parcelDetails.priority ?? "",
                              ),
                              Gap(8.h),
                              _buildDetailRow(
                                context,
                                AppStrings.date.tr,
                                parcelDetails.date
                                        ?.toLocal()
                                        .toIso8601String()
                                        .split('T')
                                        .first ??
                                    "",
                              ),
                              Gap(8.h),
                              _buildDetailRow(
                                context,
                                AppStrings.time.tr,
                                parcelDetails.time ?? "",
                              ),
                              Gap(8.h),
                              _buildDetailRow(
                                context,
                                "${'Pick up location'.tr} :",
                                parcelDetails.pickupLocation?.address ?? "N/A",
                              ),
                              Gap(8.h),
                              _buildDetailRow(
                                context,
                                AppStrings.handoverLocation.tr,
                                parcelDetails.handoverLocation?.address ?? "",
                              ),

                              Gap(16.h),
                              Text(
                                AppStrings.receiverDetails.tr,
                                style: context.titleLarge,
                              ),
                              Gap(8.h),
                              _buildDetailRow(
                                context,
                                AppStrings.receiverName.tr,
                                parcelDetails.receiverName ?? "",
                              ),
                              Gap(8.h),
                              _buildDetailRow(
                                context,
                                AppStrings.receiverPhone.tr,
                                parcelDetails.receiverPhone ?? "",
                              ),
                              Gap(8.h),
                              _buildDetailRow(
                                context,
                                AppStrings.senderRemarks.tr,
                                parcelDetails.senderRemarks ?? "",
                              ),

                              Gap(24.h),
                              if (!isPrice)
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffFF6E6E),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Waiting for parcel price",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              if (isPrice) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  width: double.infinity,
                                  height: 45.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${AppStrings.price.tr} : ',
                                        style: context.bodyMedium.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.error,
                                        ),
                                      ),

                                      Text(
                                        '\$${(double.tryParse('${(parcelDetails.priceRequests != null && parcelDetails.priceRequests!.isNotEmpty) ? parcelDetails.priceRequests!.last.proposedPrice : 0}') ?? 0.0).toStringAsFixed(2)}',
                                        style: context.bodyMedium.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                        ),
                                      ),
                                      Gap(8.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                            parcelDetails.priceRequests !=
                                                        null &&
                                                    parcelDetails
                                                        .priceRequests!
                                                        .isNotEmpty
                                                ? parcelDetails
                                                      .priceRequests!
                                                      .last
                                                      .priceType
                                                : null,
                                          ).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                        child: Text(
                                          parcelDetails.priceRequests != null &&
                                                  parcelDetails
                                                      .priceRequests!
                                                      .isNotEmpty
                                              ? parcelDetails
                                                        .priceRequests!
                                                        .last
                                                        .priceType ??
                                                    'NOT_SET'
                                              : 'NOT_SET',
                                          style: context.bodySmall.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: _getStatusColor(
                                              parcelDetails.priceRequests !=
                                                          null &&
                                                      parcelDetails
                                                          .priceRequests!
                                                          .isNotEmpty
                                                  ? parcelDetails
                                                        .priceRequests!
                                                        .last
                                                        .priceType
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Gap(30.h),

                                // Check if status is COUNTERED
                                if (parcelDetails.priceRequests != null &&
                                    parcelDetails.priceRequests!.isNotEmpty &&
                                    parcelDetails
                                            .priceRequests!
                                            .last
                                            .priceType ==
                                        "COUNTERED")
                                  Container(
                                    padding: EdgeInsets.all(16.w),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: Colors.orange,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: Colors.orange,
                                          size: 20.sp,
                                        ),
                                        Gap(8.w),
                                        Expanded(
                                          child: Text(
                                            "Counter Offer Sent. Waiting for response...",
                                            style: context.bodyMedium.copyWith(
                                              color: Colors.orange.shade700,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            AppRouter.route.pushNamed(
                                              RoutePath.paymentScreen,
                                              extra: widget.parcel,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryColor,
                                            minimumSize: Size(
                                              double.infinity,
                                              48.h,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                          ),
                                          child: Text(
                                            AppStrings.accept.tr,
                                            style: context.titleMedium.copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Gap(16.w),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _showRejectDialog(
                                              context,
                                              parcelDetails,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.error,
                                            minimumSize: Size(
                                              double.infinity,
                                              48.h,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                          ),
                                          child: Text(
                                            AppStrings.reject.tr,
                                            style: context.titleMedium.copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                              Gap(30),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label  ',
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          TextSpan(
            text: value,
            style: context.bodyMedium.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.secondPrimaryColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status.toUpperCase()) {
      case "COUNTERED":
        return Colors.orange;
      case "PROPOSED":
        return AppColors.primaryColor;
      case "FINAL_OFFER":
        return Colors.purple;
      case "ACCEPTED":
        return Colors.green;
      case "REJECTED":
        return AppColors.error;
      case "NOT_SET":
      default:
        return Colors.grey;
    }
  }

  void _showRejectDialog(BuildContext context, parcelDetails) {
    final isFinalOffer =
        parcelDetails.priceRequests != null &&
        parcelDetails.priceRequests!.isNotEmpty &&
        parcelDetails.priceRequests!.last.priceType == "FINAL_OFFER";

    if (isFinalOffer) {
      // Show simple confirmation dialog for FINAL_OFFER
      AppDialog.show(
        context: context,
        title: "Reject Final Offer",
        subtitle:
            "Are you sure you want to reject this final offer? This action cannot be undone.",
        subtitleColor: AppColors.black,
        type: AppDialogType.warning,
        actions: [
          TextButton(
            onPressed: () {
              AppRouter.route.pop();
            },
            child: Text(AppStrings.cancel.tr),
          ),
          Gap(8.w),
          Obx(
            () => controller.loadingRejectFinalOffer.value == true
                ? const Center(child: LoadingWidget())
                : TextButton(
                    onPressed: () {
                      controller.rejectFinalOffer(id: parcelDetails._id);
                    },
                    child: Text(
                      "Yes, Reject",
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
          ),
        ],
      );
    } else {
      // Show normal dialog with input fields
      AppDialog.show(
        context: context,
        title: AppStrings.rejectReason.tr,
        subtitle: 'Are you sure you want to reject this parcel?',
        type: AppDialogType.info,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(controller: reasonController, hintText: 'Reason'),
            Gap(12.h),
            CustomTextField(
              controller: finalPriceController,
              hintText: 'Final Price',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              AppRouter.route.pop();
            },
            child: Text(AppStrings.cancel.tr),
          ),
          Gap(8.w),
          Obx(
            () => controller.loadingRejectAndCounterOffer.value == true
                ? const Center(child: LoadingWidget())
                : TextButton(
                    onPressed: () {
                      if (parcelDetails.priceRequests == null ||
                          parcelDetails.priceRequests!.isEmpty) {
                        return;
                      }
                      final lastRequest = parcelDetails.priceRequests!.last;
                      final body = {
                        "parcel_id": parcelDetails.priceRequests != null
                            ? parcelDetails.priceRequests!.last.parcelId
                            : parcelDetails.parcelId,
                        "rejection_reason": reasonController.text,
                        "suggested_price": finalPriceController.text.isNotEmpty
                            ? double.parse(finalPriceController.text)
                            : 0.0,
                      };
                      controller.rejectAndCounterOffer(
                        id: lastRequest.id ?? "",
                        body: body,
                      );
                    },
                    child: Text(
                      AppStrings.reject.tr,
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
          ),
        ],
      );
    }
  }
}
