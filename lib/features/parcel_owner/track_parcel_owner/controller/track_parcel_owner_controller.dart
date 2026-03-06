import 'dart:async';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/model/parcel_model.dart';
import 'package:delivery_app/utils/color/app_colors.dart';

class TrackParcelOwnerController extends GetxController {
  final ParcelItem parcelItem;

  TrackParcelOwnerController({required this.parcelItem});

  final Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();

  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  late final LatLng _pickupLatLng;
  late final LatLng _handoverLatLng;

  CameraPosition get initialCameraPosition =>
      CameraPosition(target: _pickupLatLng, zoom: 14.0);

  @override
  void onInit() {
    super.onInit();
    _pickupLatLng = LatLng(
      parcelItem.pickupLocation?.latitude ?? 23.804693584341365,
      parcelItem.pickupLocation?.longitude ?? 90.41590889596907,
    );
    _handoverLatLng = LatLng(
      parcelItem.handoverLocation?.latitude ?? 23.815693584341365,
      parcelItem.handoverLocation?.longitude ?? 90.42590889596907,
    );
    _setMarkers();
    _setPolylines();
  }

  void _setMarkers() {
    markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLatLng,
        infoWindow: InfoWindow(
          title: 'Pickup Location',
          snippet: parcelItem.pickupLocation?.address ?? '',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    markers.add(
      Marker(
        markerId: const MarkerId('handover'),
        position: _handoverLatLng,
        infoWindow: InfoWindow(
          title: 'Handover Location',
          snippet: parcelItem.handoverLocation?.address ?? '',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  void _setPolylines() {
    polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: [_pickupLatLng, _handoverLatLng],
        color: AppColors.primaryColor,
        width: 5,
      ),
    );
  }
}
