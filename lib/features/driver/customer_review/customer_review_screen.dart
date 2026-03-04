import 'package:delivery_app/features/driver/customer_review/controller/customer_review_controller.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_review/model/parcel_owner_review_model.dart';
import 'package:delivery_app/helper/date_converter/date_converter.dart';
import 'package:delivery_app/share/widgets/loading/loading_widget.dart';
import 'package:delivery_app/share/widgets/network_image/custom_network_image.dart';
import 'package:delivery_app/share/widgets/no_internet/no_data_card.dart';
import 'package:delivery_app/utils/app_strings/app_strings.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CustomerReviewScreen extends StatefulWidget {
  const CustomerReviewScreen({super.key});

  @override
  State<CustomerReviewScreen> createState() => _CustomerReviewScreenState();
}

class _CustomerReviewScreenState extends State<CustomerReviewScreen> {
  final CustomerReviewController controller = Get.put(
    CustomerReviewController(),
  );

  @override
  void dispose() {
    Get.delete<CustomerReviewController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.customerReview.tr),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () async => controller.refresh(),
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
                      Obx(
                        () => Text(
                          '${controller.totalReviews.value} ${AppStrings.customerReview.tr}',
                          style: context.titleMedium.copyWith(
                            color: AppColors.orangeSecondaryAccentColor,
                          ),
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
                              size: 20.r,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Paginated review list
              PagedSliverList<int, ReviewItem>(
                pagingController: controller.reviewController,
                builderDelegate: PagedChildBuilderDelegate<ReviewItem>(
                  itemBuilder: (context, item, index) => Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                    child: _buildReviewCard(context: context, item: item),
                  ),
                  firstPageProgressIndicatorBuilder: (_) =>
                      const Center(child: LoadingWidget()),
                  newPageProgressIndicatorBuilder: (_) =>
                      const Center(child: LoadingWidget()),
                  noItemsFoundIndicatorBuilder: (_) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Center(
                      child: NoDataCard(
                        title: 'No reviews yet',
                        onTap: controller.refresh,
                      ),
                    ),
                  ),
                  firstPageErrorIndicatorBuilder: (_) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48.r,
                            color: Colors.red,
                          ),
                          Gap(12.h),
                          Text(
                            'Failed to load reviews.',
                            style: context.bodyMedium,
                          ),
                          TextButton(
                            onPressed: controller.refresh,
                            child: Text(
                              'Retry',
                              style: context.bodyMedium.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
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
