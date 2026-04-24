import 'package:delivery_app/features/parcel_owner/my_parcel/model/parcel_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/features/parcel_owner/track_parcel_owner/controller/track_parcel_owner_controller.dart';
import 'package:delivery_app/utils/extension/base_extension.dart';

class TrackParcelOwnerScreen extends StatefulWidget {
  final ParcelItem parcelItem;
  const TrackParcelOwnerScreen({super.key, required this.parcelItem});

  @override
  State<TrackParcelOwnerScreen> createState() => _TrackParcelOwnerScreenState();
}

class _TrackParcelOwnerScreenState extends State<TrackParcelOwnerScreen> {
  late final TrackParcelOwnerController controller;

  @override
  void initState() {
    super.initState();
    debugPrint('🖥️ [Screen] initState');
    controller = Get.put(
      TrackParcelOwnerController(parcelItem: widget.parcelItem),
    );
  }

  @override
  void dispose() {
    debugPrint('🖥️ [Screen] dispose');
    Get.delete<TrackParcelOwnerController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🖥️ [Screen] build');
    return Scaffold(
      body: Stack(
        children: [
          // ✅ GoogleMap — Identical pattern to working driver screen
          SizedBox.expand(
            child: Obx(() {
              debugPrint(
                '🗺️ Obx rebuild markers=${controller.markers.length} polylines=${controller.polylines.length}',
              );
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: controller.initialCameraPosition,
                markers: controller.markers.toSet(),
                polylines: controller.polylines.toSet(),
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                compassEnabled: true,
                mapToolbarEnabled: true,
                zoomControlsEnabled: true,
                onMapCreated: (GoogleMapController mapController) {
                  debugPrint('🗺️ onMapCreated ✅');
                  if (!controller.googleMapController.isCompleted) {
                    controller.googleMapController.complete(mapController);
                    debugPrint('🗺️ googleMapController completed ✅');
                  }
                },
              );
            }),
          ),

          // AppBar
          Positioned(
            top: 50.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              children: [
                GestureDetector(
                  onTap: AppRouter.route.pop,
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(Icons.arrow_back, size: 24.sp),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Track Parcel',
                    textAlign: TextAlign.center,
                    style: context.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                SizedBox(width: 40.w),
              ],
            ),
          ),

          // ✅ Loading indicator — small, bottom of screen, does NOT block map rendering
          Obx(
            () => controller.isLoadingRoute.value
                ? Positioned(
                    bottom: 120.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text('Loading route…', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Driver info chip
          Obx(
            () => controller.driverLatLng.value != null
                ? Positioned(
                    bottom: 40.h,
                    left: 16.w,
                    right: 16.w,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delivery_dining,
                              color: Colors.green,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(
                                    () => Text(
                                      controller.driverName.value.isNotEmpty
                                          ? controller.driverName.value
                                          : 'Driver',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'On the way to you',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            const Text(
                              'Live',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}