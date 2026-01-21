import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/driver/track_parcel/controller/track_parcel_controller.dart';
import 'package:delivery_app/utils/color/app_colors.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class TrackParcelScreen extends StatefulWidget {
  const TrackParcelScreen({super.key});

  @override
  State<TrackParcelScreen> createState() => _TrackParcelScreenState();
}

class _TrackParcelScreenState extends State<TrackParcelScreen> {
  final controller = Get.put(TrackParcelController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDetailsBottomSheet(context);
    });
  }

  void _showDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      enableDrag: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Estimated Delivery
                Text(
                  "Estimated Delivery",
                  style: context.bodyMedium.copyWith(
                    color: AppColors.grayTextSecondaryColor,
                  ),
                ),
                Gap(4.h),
                Text(
                  "9:35 PM",
                  style: context.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Gap(20.h),

                // Progress Bar
                _buildProgressBar(context),
                Gap(24.h),

                // Waiting Customer (Pickup)
                Text(
                  "Waiting Customer",
                  style: context.titleMedium.copyWith(
                    color: AppColors.grayTextSecondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(16.h),
                _buildPersonRow(
                  context,
                  name: "John Doe",
                  imageUrl: "https://i.pravatar.cc/150?img=11",
                  locationLabel: "Pickup Location",
                  address: "1901 Thornridge Cir. Shiloh, Hawaii 81063",
                ),

                Gap(24.h),

                // Deliver Location (Receiver)
                _buildPersonRow(
                  context,
                  name: "Floyd Miles",
                  imageUrl: "https://i.pravatar.cc/150?img=3",
                  locationLabel: "Deliver Location",
                  address: "1901 Thornridge Cir. Shiloh, Hawaii 81063",
                  isReceiver: true,
                ),
                Gap(20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          Positioned.fill(
            child: Obx(() {
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition:
                    TrackParcelController.initialCameraPosition,
                markers: controller.markers.toSet(),
                polylines: controller.polylines.toSet(),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                mapToolbarEnabled: true,
                zoomControlsEnabled: true,
                onMapCreated: (GoogleMapController mapController) {
                  controller.googleMapController.complete(mapController);
                },
              );
            }),
          ),

          // Custom AppBar
          Positioned(
            top: 50.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    AppRouter.route.pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(Icons.arrow_back, size: 24.sp),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Track Parcel",
                    textAlign: TextAlign.center,
                    style: context.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                SizedBox(width: 40.w), // Balance the back button space
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDetailsBottomSheet(context);
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.info_outline, color: AppColors.primaryColor),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
            Gap(4.w),
            Expanded(
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
            Gap(4.w),
            Expanded(
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
          ],
        ),
        Gap(8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Picked Up",
              style: context.bodySmall.copyWith(color: Colors.black54),
            ),
            Text(
              "On The Way",
              style: context.bodySmall.copyWith(color: Colors.black54),
            ),
            Text(
              "Delivery Point",
              style: context.bodySmall.copyWith(color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonRow(
    BuildContext context, {
    required String name,
    required String imageUrl,
    required String locationLabel,
    required String address,
    bool isReceiver = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 24.r, backgroundImage: NetworkImage(imageUrl)),
            Gap(12.w),
            Expanded(
              child: Text(
                name,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildActionButton(context, icon: Icons.call, label: "Call"),
            Gap(8.w),
            _buildActionButton(
              context,
              icon: Icons.chat_bubble_outline,
              label: "Chat",
            ),
          ],
        ),
        Gap(8.h),
        RichText(
          text: TextSpan(
            text: "$locationLabel: ",
            style: context.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            children: [
              TextSpan(
                text: address,
                style: context.bodySmall.copyWith(
                  fontWeight: FontWeight.normal,
                  color: AppColors.grayTextSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16.sp),
          Gap(4.w),
          Text(label, style: context.labelMedium.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
