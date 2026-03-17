// import 'dart:async';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:delivery_app/features/driver/parcels/model/parcel_model.dart';
// import 'package:delivery_app/utils/color/app_colors.dart';

// class TrackParcelController extends GetxController {
//   final DriverParcelItem parcelItem;

//   TrackParcelController({required this.parcelItem});

//   final Completer<GoogleMapController> googleMapController =
//       Completer<GoogleMapController>();

//   final RxSet<Marker> markers = <Marker>{}.obs;
//   final RxSet<Polyline> polylines = <Polyline>{}.obs;

//   late final LatLng _pickupLatLng;
//   late final LatLng _handoverLatLng;

//   CameraPosition get initialCameraPosition =>
//       CameraPosition(target: _pickupLatLng, zoom: 14.0);

//   @override
//   void onInit() {
//     super.onInit();
//     _pickupLatLng = LatLng(
//       parcelItem.pickupLocation?.latitude ?? 23.804693584341365,
//       parcelItem.pickupLocation?.longitude ?? 90.41590889596907,
//     );
//     _handoverLatLng = LatLng(
//       parcelItem.handoverLocation?.latitude ?? 23.815693584341365,
//       parcelItem.handoverLocation?.longitude ?? 90.42590889596907,
//     );
//     _setMarkers();
//     _setPolylines();
//   }

//   void _setMarkers() {
//     markers.add(
//       Marker(
//         markerId: const MarkerId('pickup'),
//         position: _pickupLatLng,
//         infoWindow: InfoWindow(
//           title: 'Pickup Location',
//           snippet: parcelItem.pickupLocation?.address ?? '',
//         ),
//         icon: BitmapDescriptor.defaultMarker,
//       ),
//     );
//     markers.add(
//       Marker(
//         markerId: const MarkerId('handover'),
//         position: _handoverLatLng,
//         infoWindow: InfoWindow(
//           title: 'Handover Location',
//           snippet: parcelItem.handoverLocation?.address ?? '',
//         ),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//       ),
//     );
//   }

//   void _setPolylines() {
//     polylines.add(
//       Polyline(
//         polylineId: const PolylineId('route'),
//         points: [_pickupLatLng, _handoverLatLng],
//         color: AppColors.primaryColor,
//         width: 5,
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:delivery_app/features/driver/track_parcel/tracking_service/tracking_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:delivery_app/features/driver/parcels/model/parcel_model.dart';
import 'package:delivery_app/utils/color/app_colors.dart';

// ⚠️ Replace with your actual Google Maps API key
// Make sure Directions API is enabled in Google Cloud Console
const String _googleApiKey = 'AIzaSyAbmRHOMGItXC6dcajVKckbBpsrygRouts';

class TrackParcelController extends GetxController {
  final DriverParcelItem parcelItem;

  TrackParcelController({required this.parcelItem});

  // ─── Map ──────────────────────────────────────────────────────────────────
  final Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();

  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  final RxBool isLoadingRoute = false.obs;

  late final LatLng _pickupLatLng;
  late final LatLng _handoverLatLng;

  CameraPosition get initialCameraPosition =>
      CameraPosition(target: _pickupLatLng, zoom: 14.0);

  // ─── Driver live position ─────────────────────────────────────────────────
  final Rx<LatLng?> driverLatLng = Rx<LatLng?>(null);
  StreamSubscription<Position>? _livePositionSub;

  // ─── Tracking service (socket emit every 20 m) ────────────────────────────
  final _trackingService = LocationTrackingService();

  // ─── Lifecycle ────────────────────────────────────────────────────────────

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
    _fetchRoadPolyline(); // road-following polyline

    // Start emitting location to server every 20 m via socket
    _trackingService.startTracking();

    // Mirror live position on the map
    _subscribeLivePosition();
  }

  @override
  void onClose() {
    _trackingService.stopTracking();
    _livePositionSub?.cancel();
    super.onClose();
  }

  // ─── Road Polyline (Google Directions) ───────────────────────────────────

  Future<void> _fetchRoadPolyline() async {
    isLoadingRoute.value = true;

    try {
      final PolylinePoints polylinePoints = PolylinePoints();

      final PolylineResult result = await polylinePoints
          .getRouteBetweenCoordinates(
            googleApiKey: _googleApiKey,
            request: PolylineRequest(
              origin: PointLatLng(
                _pickupLatLng.latitude,
                _pickupLatLng.longitude,
              ),
              destination: PointLatLng(
                _handoverLatLng.latitude,
                _handoverLatLng.longitude,
              ),
              mode: TravelMode.driving,
            ),
          );

      if (result.points.isNotEmpty) {
        final List<LatLng> routeCoords = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        polylines
          ..removeWhere((p) => p.polylineId.value == 'route')
          ..add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: routeCoords,
              color: AppColors.primaryColor,
              width: 5,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              jointType: JointType.round,
            ),
          );

        // Fit camera to show the full route
        _fitCameraToRoute(routeCoords);
      } else {
        debugPrint(
          'TrackParcelController: Directions API error — ${result.errorMessage}',
        );
        // Fallback: straight line if API fails
        _setFallbackPolyline();
      }
    } catch (e) {
      debugPrint('TrackParcelController: polyline fetch failed — $e');
      _setFallbackPolyline();
    } finally {
      isLoadingRoute.value = false;
    }
  }

  /// Straight line fallback if Directions API is unavailable
  void _setFallbackPolyline() {
    polylines
      ..removeWhere((p) => p.polylineId.value == 'route')
      ..add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [_pickupLatLng, _handoverLatLng],
          color: AppColors.primaryColor,
          width: 5,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)], // dashed
        ),
      );
  }

  Future<void> _fitCameraToRoute(List<LatLng> routeCoords) async {
    if (!googleMapController.isCompleted) return;

    double minLat = routeCoords.first.latitude;
    double maxLat = routeCoords.first.latitude;
    double minLng = routeCoords.first.longitude;
    double maxLng = routeCoords.first.longitude;

    for (final coord in routeCoords) {
      if (coord.latitude < minLat) minLat = coord.latitude;
      if (coord.latitude > maxLat) maxLat = coord.latitude;
      if (coord.longitude < minLng) minLng = coord.longitude;
      if (coord.longitude > maxLng) maxLng = coord.longitude;
    }

    final controller = await googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        80.0, // padding in pixels
      ),
    );
  }

  // ─── Live map driver marker ───────────────────────────────────────────────

  void _subscribeLivePosition() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _livePositionSub =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position pos) {
            final latLng = LatLng(pos.latitude, pos.longitude);
            driverLatLng.value = latLng;
            _updateDriverMarker(latLng);
            _animateCameraToDriver(latLng);
          },
        );
  }

  void _updateDriverMarker(LatLng latLng) {
    markers
      ..removeWhere((m) => m.markerId.value == 'driver')
      ..add(
        Marker(
          markerId: const MarkerId('driver'),
          position: latLng,
          infoWindow: const InfoWindow(title: 'You'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          zIndex: 2,
        ),
      );
  }

  Future<void> _animateCameraToDriver(LatLng latLng) async {
    if (!googleMapController.isCompleted) return;
    final controller = await googleMapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  // ─── Static markers ───────────────────────────────────────────────────────

  void _setMarkers() {
    markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLatLng,
        infoWindow: InfoWindow(
          title: 'Pickup Location',
          snippet: parcelItem.pickupLocation?.address ?? '',
        ),
        icon: BitmapDescriptor.defaultMarker, // red
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
}
