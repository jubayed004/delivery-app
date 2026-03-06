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
    controller = Get.put(
      TrackParcelOwnerController(parcelItem: widget.parcelItem),
    );
  }

  @override
  void dispose() {
    Get.delete<TrackParcelOwnerController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map — full screen, shows markers + polyline only
          Positioned.fill(
            child: Obx(() {
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: controller.initialCameraPosition,
                markers: controller.markers.toSet(),
                polylines: controller.polylines.toSet(),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                mapToolbarEnabled: true,
                zoomControlsEnabled: true,
                onMapCreated: (GoogleMapController mapController) {
                  if (!controller.googleMapController.isCompleted) {
                    controller.googleMapController.complete(mapController);
                  }
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
                SizedBox(width: 40.w),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
