import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:delivery_app/features/driver/parcels/controller/parcel_controller.dart';
import 'package:delivery_app/features/driver/parcels/model/parcel_model.dart';
import 'package:delivery_app/features/driver/parcels/widgets/parcel_card.dart';

class ParcelList extends StatelessWidget {
  final String status;

  const ParcelList({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ParcelController());
    final pagingController = status == "Ongoing"
        ? controller.ongoingController
        : controller.completedController;

    return CustomScrollView(
      slivers: [
        PagedSliverList<int, DriverParcelItem>(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<DriverParcelItem>(
            itemBuilder: (context, item, index) => Padding(
              padding: EdgeInsets.only(
                left: 16.r,
                right: 16.r,
                top: index == 0 ? 16.r : 0,
                bottom: 16.r,
              ),
              child: ParcelCard(
                onTap: () {
                  AppRouter.route.pushNamed(
                    RoutePath.parcelDetailsScreen,
                    extra: item,
                  );
                },
                status: status,
                parcelId: item.parcelId ?? '',
                parcelName: item.parcelName ?? '',
                size: item.size ?? '',
                price: item.finalPrice?.toString() ?? '0',
                imageUrl: item.parcelImages?.isNotEmpty == true
                    ? item.parcelImages!.first
                    : '',
              ),
            ),
            firstPageErrorIndicatorBuilder: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                  Gap(16.h),
                  Text(
                    'Error loading parcels',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  Gap(8.h),
                  ElevatedButton(
                    onPressed: () => pagingController.refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            newPageErrorIndicatorBuilder: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading more parcels',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Gap(8.h),
                  TextButton(
                    onPressed: () => pagingController.retryLastFailedRequest(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            noItemsFoundIndicatorBuilder: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64.sp, color: Colors.grey),
                  Gap(16.h),
                  Text(
                    'No $status parcels',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
