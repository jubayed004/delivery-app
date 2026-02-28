import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_review/widgets/review_dialog.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/share/widgets/no_internet/no_data_card.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_review/controller/parcel_owner_review_controller.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_review/model/parcel_owner_review_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:delivery_app/helper/date_converter/date_converter.dart';

class ParcelOwnerReviewScreen extends StatefulWidget {
  final String parcelId;
  const ParcelOwnerReviewScreen({super.key, required this.parcelId});

  @override
  State<ParcelOwnerReviewScreen> createState() =>
      _ParcelOwnerReviewScreenState();
}

class _ParcelOwnerReviewScreenState extends State<ParcelOwnerReviewScreen> {
  late final ParcelOwnerReviewController controller;

  @override
  void initState() {
    super.initState();
    // Use a unique tag so multiple screen instances don't share controllers
    controller = Get.put(
      ParcelOwnerReviewController(parcelId: widget.parcelId),
      tag: widget.parcelId,
    );
  }

  @override
  void dispose() {
    Get.delete<ParcelOwnerReviewController>(tag: widget.parcelId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text("Reviews".tr),
        centerTitle: true,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Wait, the ReviewDialog needs a parcelId, typically given per Review.
              // Assuming ReviewDialog is opened from ParcelDetails or somewhere else where we know the parcelId.
              showDialog(
                context: context,
                builder: (context) => ReviewDialog(parcelId: widget.parcelId),
              );
            },
            icon: const Icon(Icons.reviews, color: AppColors.primaryColor),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Row(
                  children: [
                    Text(
                      "Ratings".tr,
                      style: context.titleMedium.copyWith(
                        color: AppColors.orangeSecondaryAccentColor,
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            '${controller.averageRating.value}.0',
                            style: context.titleLarge,
                          ),
                          Gap(4.w),
                          Icon(
                            Icons.star,
                            color: AppColors.orangeSecondaryAccentColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PagedSliverList<int, ReviewItem>(
              pagingController: controller.reviewController,
              builderDelegate: PagedChildBuilderDelegate<ReviewItem>(
                itemBuilder: (context, item, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    child: _buildReviewCard(context: context, item: item),
                  );
                },
                firstPageProgressIndicatorBuilder: (context) =>
                    const Center(child: LoadingWidget()),
                newPageProgressIndicatorBuilder: (context) =>
                    const Center(child: LoadingWidget()),
                noItemsFoundIndicatorBuilder: (context) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Center(
                    child: NoDataCard(
                      title: "No reviews found",
                      onTap: () => controller.reviewController.refresh(),
                    ),
                  ),
                ),
                firstPageErrorIndicatorBuilder: (context) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 50.r,
                          color: Colors.red,
                        ),
                        Gap(10.h),
                        Text("Failed to load reviews. Tap to try again."),
                        TextButton(
                          onPressed: () =>
                              controller.reviewController.refresh(),
                          child: Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    required BuildContext context,
    required ReviewItem item,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.bgSecondaryButtonColor.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomNetworkImage(
                imageUrl: item.customerId?.profilePicture ?? "",
                borderRadius: BorderRadius.circular(20.r),
                height: 40.r,
                width: 40.r,
              ),
              Gap(12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.customerId?.fullName ?? "Unknown user",
                    style: context.titleMedium,
                  ),
                  if (item.createdAt != null)
                    Text(
                      DateConverter.timeAgo(item.createdAt!),
                      style: context.bodySmall,
                    ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text('${item.rating ?? 0}.0', style: context.titleMedium),
                  Gap(4.w),
                  Icon(Icons.star, color: Colors.amber, size: 20.r),
                ],
              ),
            ],
          ),
          Gap(12.h),
          Text(item.feedback ?? "", style: context.bodyMedium),
        ],
      ),
    );
  }
}
