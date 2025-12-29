import 'dart:async';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery_app/utils/color/app_colors.dart';

class TrackParcelController extends GetxController {
  final Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();

  static const LatLng _pickupLocation = LatLng(
    23.804693584341365,
    90.41590889596907,
  );
  static const LatLng _deliveryLocation = LatLng(
    23.815693584341365,
    90.42590889596907,
  );

  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(
      23.804693584341365,
      90.41590889596907,
    ), // Center between the two
    zoom: 15.4746,
  );

  @override
  void onInit() {
    super.onInit();
    _setMarkers();
    _setPolylines();
  }

  void _setMarkers() {
    markers.add(
      const Marker(
        markerId: MarkerId('pickup'),
        position: _pickupLocation,
        infoWindow: InfoWindow(title: 'Pickup Location'),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    markers.add(
      Marker(
        markerId: const MarkerId('delivery'),
        position: _deliveryLocation,
        infoWindow: const InfoWindow(title: 'Delivery Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  void _setPolylines() {
    polylines.add(
      const Polyline(
        polylineId: PolylineId('route'),
        points: [_pickupLocation, _deliveryLocation],
        color: AppColors.primaryColor,
        width: 5,
      ),
    );
  }
}
