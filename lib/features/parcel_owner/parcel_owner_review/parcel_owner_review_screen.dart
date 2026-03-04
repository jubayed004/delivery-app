import 'package:delivery_app/features/parcel_owner/parcel_owner_review/controller/parcel_owner_review_controller.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_review/model/parcel_owner_review_model.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_review/widgets/review_dialog.dart';
import 'package:delivery_app/helper/date_converter/date_converter.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/share/widgets/no_internet/no_data_card.dart';
import 'package:delivery_app/share/widgets/no_internet/no_internet_card.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

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
        child: Obx(() {
          final status = controller.status.value;

          if (status == ApiStatus.loading) {
            return const Center(child: LoadingWidget());
          }
          if (status == ApiStatus.internetError) {
            return Center(child: NoInternetCard(onTap: controller.getReviews));
          }
          if (status == ApiStatus.error) {
            return Center(
              child: NoDataCard(
                title: 'Failed to load reviews',
                onTap: controller.getReviews,
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: controller.getReviews,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Summary header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${controller.totalReviews.value} Ratings',
                          style: context.titleMedium.copyWith(
                            color: AppColors.orangeSecondaryAccentColor,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Text(
                              '${controller.averageRating.value}.0',
                              style: context.titleLarge,
                            ),
                            Gap(4.w),
                            Icon(
                              Icons.star,
                              color: AppColors.orangeSecondaryAccentColor,
                              size: 20.r,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Empty state
                if (controller.reviews.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: NoDataCard(
                        title: 'No reviews yet',
                        onTap: controller.getReviews,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    sliver: SliverList.separated(
                      itemCount: controller.reviews.length,
                      separatorBuilder: (_, _) => Gap(12.h),
                      itemBuilder: (context, index) {
                        final item = controller.reviews[index];
                        return _buildReviewCard(context: context, item: item);
                      },
                    ),
                  ),
              ],
            ),
          );
        }),
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
                imageUrl: item.customerId?.profilePicture ?? '',
                borderRadius: BorderRadius.circular(20.r),
                height: 40.r,
                width: 40.r,
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.customerId?.fullName ?? 'Unknown',
                      style: context.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.createdAt != null)
                      Text(
                        DateConverter.timeAgo(item.createdAt!),
                        style: context.bodySmall,
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${item.rating ?? 0}.0', style: context.titleMedium),
                  Gap(4.w),
                  Icon(Icons.star, color: Colors.amber, size: 18.r),
                ],
              ),
            ],
          ),
          if ((item.feedback ?? '').isNotEmpty) ...[
            Gap(12.h),
            Text(item.feedback!, style: context.bodyMedium),
          ],
        ],
      ),
    );
  }
}
