import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/controller/my_parcel_controller.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/widgets/parcel_card.dart';
import 'package:delivery_app/utils/color/app_colors.dart';

class MyParcelScreen extends StatelessWidget {
  MyParcelScreen({super.key});
  final controller = Get.find<MyParcelController>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: const Text('My Parcel'),
          scrolledUnderElevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          bottom: TabBar(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            dividerColor: Colors.transparent,
            onTap: controller.changeTab,
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.primaryColor,
            indicator: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 4.h,
            ),
            labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: 'Waiting'),
              Tab(text: 'Pending'),
              Tab(text: 'Ongoing'),
              Tab(text: 'Completed'),
              Tab(text: 'Reject'),
            ],
          ),
        ),
        body: Obx(
          () => TabBarView(
            children: [
              _buildParcelList(ParcelStatus.waiting),
              _buildParcelList(ParcelStatus.pending),
              _buildParcelList(ParcelStatus.ongoing),
              _buildParcelList(ParcelStatus.completed),
              _buildParcelList(ParcelStatus.reject),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParcelList(ParcelStatus status) {
    final parcels = controller.getParcelsByStatus(status);

    if (parcels.isEmpty) {
      return Center(
        child: Text(
          'No ${status.name} parcels',
          style: TextStyle(color: Colors.grey, fontSize: 16.sp),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: parcels.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final parcel = parcels[index];
        return ParcelCardList(
          parcel: parcel,
          onTap: () {
            if (parcel.status == ParcelStatus.pending ||
                parcel.status == ParcelStatus.waiting ||
                parcel.status == ParcelStatus.ongoing) {
              AppRouter.route.pushNamed(
                RoutePath.detailsMyParcelScreen,
                extra: parcel,
              );
            }
          },
          onChatTap: () {
            AppRouter.route.pushNamed(RoutePath.chatScreen);
          },
          onReviewTap: () {
            AppRouter.route.pushNamed(RoutePath.parcelOwnerReviewScreen);
          },
          onRefundTap: () {
            AppRouter.route.pushNamed(RoutePath.refundScreen);
          },
          onTrackLiveTap: () {
            AppRouter.route.pushNamed(RoutePath.trackParcelScreen);
          },
        );
      },
    );
  }
}
