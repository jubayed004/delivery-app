// import 'dart:async';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:delivery_app/features/parcel_owner/my_parcel/model/parcel_model.dart';
// import 'package:delivery_app/utils/color/app_colors.dart';

// class TrackParcelOwnerController extends GetxController {
//   final ParcelItem parcelItem;

//   TrackParcelOwnerController({required this.parcelItem});

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

//  import 'dart:async';
// import 'dart:math' as math;

// import 'package:delivery_app/core/service/datasource/remote/socket_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:delivery_app/features/parcel_owner/my_parcel/model/parcel_model.dart';
// import 'package:delivery_app/utils/color/app_colors.dart';

// // ⚠️ Replace with your actual Google Maps API key
// // Directions API must be enabled in Google Cloud Console
// const String _googleApiKey = 'AIzaSyAbmRHOMGItXC6dcajVKckbBpsrygRouts';

// class TrackParcelOwnerController extends GetxController {
//   final ParcelItem parcelItem;

//   TrackParcelOwnerController({required this.parcelItem});

//   // ─── Map ──────────────────────────────────────────────────────────────────
//   final Completer<GoogleMapController> googleMapController =
//       Completer<GoogleMapController>();

//   final RxSet<Marker> markers = <Marker>{}.obs;
//   final RxSet<Polyline> polylines = <Polyline>{}.obs;

//   final RxBool isLoadingRoute = true.obs;
//   final Rx<LatLng?> driverLatLng = Rx<LatLng?>(null);

//   late final LatLng _pickupLatLng;
//   late final LatLng _handoverLatLng;

//   CameraPosition get initialCameraPosition =>
//       CameraPosition(target: _pickupLatLng, zoom: 14.0);

//   /// Full route coords fetched ONCE from Directions API — never refetched
//   List<LatLng> _fullRouteCoords = [];

//   // ─── Lifecycle ────────────────────────────────────────────────────────────

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

//     _setStaticMarkers();
//     _fetchRoadPolyline();   // 1× Directions API call
//     _joinSocketTracking();  // start receiving driver location
//   }

//   @override
//   void onClose() {
//     _leaveSocketTracking();
//     super.onClose();
//   }

//   // ─── Socket ───────────────────────────────────────────────────────────────

//   void _joinSocketTracking() {
//     final socket = SocketApi.socket;
//     if (socket == null || !socket.connected) {
//       debugPrint('TrackParcelOwnerController: socket not connected');
//       return;
//     }

//     // Tell server which parcel we want to watch
//     socket.emit('join_parcel_tracking', {'parcel_id': parcelItem.id});

//     // Initial snapshot (fired once after joining)
//     socket.on('driver_location_data', _onDriverLocationData);

//     // Live updates every time driver moves 20 m
//     socket.on('driver_location_update', _onDriverLocationUpdate);

//     debugPrint('TrackParcelOwnerController: joined tracking for ${parcelItem.id}');
//   }

//   void _leaveSocketTracking() {
//     final socket = SocketApi.socket;
//     socket?.off('driver_location_data');
//     socket?.off('driver_location_update');
//   }

//   void _onDriverLocationData(dynamic data) {
//     debugPrint('📍 driver_location_data: $data');
//     _handleLocationPayload(data);
//   }

//   void _onDriverLocationUpdate(dynamic data) {
//     debugPrint('🔄 driver_location_update: $data');
//     _handleLocationPayload(data);
//   }

//   void _handleLocationPayload(dynamic raw) {
//     if (raw == null) {
//       debugPrint('TrackParcelOwnerController: received null payload');
//       return;
//     }

//     try {
//       final Map<String, dynamic> body = raw is Map<String, dynamic>
//           ? raw
//           : Map<String, dynamic>.from(raw as Map);

//       Map<String, dynamic> locationData;

//       // Handle `{ success: true, data: {...} }` format
//       if (body.containsKey('success') && body['success'] == true && body.containsKey('data')) {
//         locationData = Map<String, dynamic>.from(body['data'] as Map);
//       }
//       // Handle direct `{ latitude: 123, longitude: 456 }` format
//       else if (body.containsKey('latitude') && body.containsKey('longitude')) {
//         locationData = body;
//       }
//       else {
//         debugPrint('TrackParcelOwnerController: unrecognised payload format - $body');
//         return;
//       }

//       final double lat = (locationData['latitude'] as num).toDouble();
//       final double lng = (locationData['longitude'] as num).toDouble();
//       final LatLng newPos = LatLng(lat, lng);

//       driverLatLng.value = newPos;
//       _updateDriverMarker(newPos, locationData);

//       // Trim already-passed portion of the polyline — NO extra API call
//       _trimPolylineToDriver(newPos);

//       // Smoothly pan camera to driver
//       _animateCameraTo(newPos);
//     } catch (e) {
//       debugPrint('TrackParcelOwnerController: payload parse error — $e');
//     }
//   }

//   // ─── Road Polyline (fetched once) ─────────────────────────────────────────

//   Future<void> _fetchRoadPolyline() async {
//     isLoadingRoute.value = true;
//     try {
//       final PolylineResult result =
//           await PolylinePoints().getRouteBetweenCoordinates(
//         googleApiKey: _googleApiKey,
//         request: PolylineRequest(
//           origin: PointLatLng(_pickupLatLng.latitude, _pickupLatLng.longitude),
//           destination:
//               PointLatLng(_handoverLatLng.latitude, _handoverLatLng.longitude),
//           mode: TravelMode.driving,
//         ),
//       );

//       if (result.points.isNotEmpty) {
//         _fullRouteCoords =
//             result.points.map((p) => LatLng(p.latitude, p.longitude)).toList();
//         _drawPolyline(_fullRouteCoords);
//         _fitCameraToRoute(_fullRouteCoords);
//       } else {
//         debugPrint('Directions API: ${result.errorMessage}');
//         _fallbackPolyline();
//       }
//     } catch (e) {
//       debugPrint('_fetchRoadPolyline error: $e');
//       _fallbackPolyline();
//     } finally {
//       isLoadingRoute.value = false;
//     }
//   }

//   void _fallbackPolyline() {
//     _fullRouteCoords = [_pickupLatLng, _handoverLatLng];
//     _drawPolyline(_fullRouteCoords, dashed: true);
//   }

//   void _drawPolyline(List<LatLng> points, {bool dashed = false}) {
//     polylines
//       ..removeWhere((p) => p.polylineId.value == 'route')
//       ..add(
//         Polyline(
//           polylineId: const PolylineId('route'),
//           points: points,
//           color: AppColors.primaryColor,
//           width: 5,
//           startCap: Cap.roundCap,
//           endCap: Cap.roundCap,
//           jointType: JointType.round,
//           patterns: dashed
//               ? [PatternItem.dash(20), PatternItem.gap(10)]
//               : [],
//         ),
//       );
//   }

//   /// Finds the nearest point on the full route to the driver's current
//   /// position and removes all points before it — polyline "shrinks"
//   /// as the driver progresses. Zero extra API calls.
//   void _trimPolylineToDriver(LatLng driverPos) {
//     if (_fullRouteCoords.length < 2) return;

//     int nearestIndex = 0;
//     double minDist = double.infinity;

//     for (int i = 0; i < _fullRouteCoords.length; i++) {
//       final double d = _haversineMeters(driverPos, _fullRouteCoords[i]);
//       if (d < minDist) {
//         minDist = d;
//         nearestIndex = i;
//       }
//     }

//     // Remaining route: driver exact position → nearest route point onward → handover
//     final List<LatLng> remaining = [
//       driverPos,
//       if (nearestIndex + 1 < _fullRouteCoords.length)
//         ..._fullRouteCoords.sublist(nearestIndex + 1),
//     ];

//     if (remaining.length >= 2) {
//       _drawPolyline(remaining);
//     }
//   }

//   // ─── Markers ──────────────────────────────────────────────────────────────

//   void _setStaticMarkers() {
//     markers.addAll([
//       Marker(
//         markerId: const MarkerId('pickup'),
//         position: _pickupLatLng,
//         infoWindow: InfoWindow(
//           title: 'Pickup',
//           snippet: parcelItem.pickupLocation?.address ?? '',
//         ),
//         icon: BitmapDescriptor.defaultMarker, // red
//       ),
//       Marker(
//         markerId: const MarkerId('handover'),
//         position: _handoverLatLng,
//         infoWindow: InfoWindow(
//           title: 'Handover',
//           snippet: parcelItem.handoverLocation?.address ?? '',
//         ),
//         icon:
//             BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//       ),
//     ]);
//   }

//   void _updateDriverMarker(
//     LatLng pos,
//     Map<String, dynamic> locationData,
//   ) {
//     final dynamic driverRaw = locationData['driver_id'];
//     final String name = driverRaw is Map
//         ? (driverRaw['full_name'] as String? ?? 'Driver')
//         : 'Driver';
//     final double speed = (locationData['speed'] as num? ?? 0).toDouble();

//     markers
//       ..removeWhere((m) => m.markerId.value == 'driver')
//       ..add(
//         Marker(
//           markerId: const MarkerId('driver'),
//           position: pos,
//           infoWindow: InfoWindow(
//             title: name,
//             snippet: 'Speed: ${speed.toStringAsFixed(1)} m/s',
//           ),
//           icon: BitmapDescriptor.defaultMarkerWithHue(
//             BitmapDescriptor.hueGreen,
//           ),
//           zIndex: 2,
//         ),
//       );
//   }

//   // ─── Camera ───────────────────────────────────────────────────────────────

//   Future<void> _animateCameraTo(LatLng pos) async {
//     if (!googleMapController.isCompleted) return;
//     final c = await googleMapController.future;
//     c.animateCamera(CameraUpdate.newLatLng(pos));
//   }

//   Future<void> _fitCameraToRoute(List<LatLng> coords) async {
//     if (!googleMapController.isCompleted) return;

//     double minLat = coords.first.latitude;
//     double maxLat = coords.first.latitude;
//     double minLng = coords.first.longitude;
//     double maxLng = coords.first.longitude;

//     for (final c in coords) {
//       if (c.latitude < minLat) minLat = c.latitude;
//       if (c.latitude > maxLat) maxLat = c.latitude;
//       if (c.longitude < minLng) minLng = c.longitude;
//       if (c.longitude > maxLng) maxLng = c.longitude;
//     }

//     final ctrl = await googleMapController.future;
//     ctrl.animateCamera(
//       CameraUpdate.newLatLngBounds(
//         LatLngBounds(
//           southwest: LatLng(minLat, minLng),
//           northeast: LatLng(maxLat, maxLng),
//         ),
//         80.0,
//       ),
//     );
//   }

//   // ─── Math ─────────────────────────────────────────────────────────────────

//   double _haversineMeters(LatLng a, LatLng b) {
//     const double r = 6371000;
//     final double dLat = _rad(b.latitude - a.latitude);
//     final double dLng = _rad(b.longitude - a.longitude);
//     final double h = math.sin(dLat / 2) * math.sin(dLat / 2) +
//         math.cos(_rad(a.latitude)) *
//             math.cos(_rad(b.latitude)) *
//             math.sin(dLng / 2) *
//             math.sin(dLng / 2);
//     return 2 * r * math.asin(math.sqrt(h));
//   }

//   double _rad(double deg) => deg * math.pi / 180;
// }
import 'dart:async';
import 'dart:math' as math;

import 'package:delivery_app/core/service/datasource/remote/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:delivery_app/features/parcel_owner/my_parcel/model/parcel_model.dart';
import 'package:delivery_app/utils/color/app_colors.dart';

const String _googleApiKey = 'AIzaSyAbmRHOMGItXC6dcajVKckbBpsrygRouts';

class TrackParcelOwnerController extends GetxController {
  final ParcelItem parcelItem;

  TrackParcelOwnerController({required this.parcelItem});

  // ─── Map ──────────────────────────────────────────────────────────────────
  final Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();

  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  final RxBool isLoadingRoute = true.obs;
  final Rx<LatLng?> driverLatLng = Rx<LatLng?>(null);

  // ─── Driver info (shown in bottom card) ───────────────────────────────────
  final RxString driverName = ''.obs;
  final RxDouble driverSpeed = 0.0.obs; // m/s from server
  final RxString lastUpdated = ''.obs;

  late final LatLng _pickupLatLng;
  late final LatLng _handoverLatLng;

  CameraPosition get initialCameraPosition =>
      CameraPosition(target: _pickupLatLng, zoom: 14.0);

  List<LatLng> _fullRouteCoords = [];

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

    _setStaticMarkers();
    _fetchRoadPolyline();
    _joinSocketTracking();
  }

  @override
  void onClose() {
    _leaveSocketTracking(); // ✅ properly leave the room
    super.onClose();
  }

  // ─── Socket ───────────────────────────────────────────────────────────────

  void _joinSocketTracking() {
    final socket = SocketApi.socket;

    // Retry if socket not yet ready (e.g. slow auth)
    if (socket == null || !socket.connected) {
      debugPrint('TrackParcelOwnerController: socket not ready — retrying in 2s');
      Future.delayed(const Duration(seconds: 2), _joinSocketTracking);
      return;
    }

    // Join the parcel room on the server
    socket.emit('join_parcel_tracking', {'parcel_id': parcelItem.id});

    // Initial snapshot — server sends once after join
    socket.on('driver_location_data', _onDriverLocationData);

    // Live updates — server broadcasts every time driver moves ≥ 20 m
    socket.on('driver_location_update', _onDriverLocationUpdate);

    debugPrint('TrackParcelOwnerController: joined tracking → ${parcelItem.id}');
  }

  void _leaveSocketTracking() {
    final socket = SocketApi.socket;
    if (socket == null) return;

    // Tell server to remove this customer from the parcel room
    socket.emit('leave_parcel_tracking', {'parcel_id': parcelItem.id});

    socket.off('driver_location_data');
    socket.off('driver_location_update');

    debugPrint('TrackParcelOwnerController: left tracking → ${parcelItem.id}');
  }

  void _onDriverLocationData(dynamic data) {
    debugPrint('📍 driver_location_data: $data');
    _handleLocationPayload(data);
  }

  void _onDriverLocationUpdate(dynamic data) {
    debugPrint('🔄 driver_location_update: $data');
    _handleLocationPayload(data);
  }

  void _handleLocationPayload(dynamic raw) {
    if (raw == null) return;

    try {
      final Map<String, dynamic> body = raw is Map<String, dynamic>
          ? raw
          : Map<String, dynamic>.from(raw as Map);

      Map<String, dynamic> locationData;

      // Format A — { success: true, data: { latitude, longitude, driver_id, ... } }
      if (body['success'] == true && body['data'] is Map) {
        locationData = Map<String, dynamic>.from(body['data'] as Map);
      }
      // Format B — { latitude, longitude, driver_id, ... } (direct)
      else if (body.containsKey('latitude')) {
        locationData = body;
      } else {
        debugPrint('TrackParcelOwnerController: unrecognised payload → $body');
        return;
      }

      final double lat = (locationData['latitude'] as num).toDouble();
      final double lng = (locationData['longitude'] as num).toDouble();
      final LatLng newPos = LatLng(lat, lng);

      // Parse driver info for bottom card
      final dynamic driverRaw = locationData['driver_id'];
      if (driverRaw is Map) {
        driverName.value = driverRaw['full_name'] as String? ?? 'Driver';
      }
      driverSpeed.value = (locationData['speed'] as num? ?? 0).toDouble();
      lastUpdated.value = locationData['last_updated'] as String? ?? '';

      driverLatLng.value = newPos;
      _updateDriverMarker(newPos, locationData);
      _trimPolylineToDriver(newPos);
      _animateCameraTo(newPos);
    } catch (e, st) {
      debugPrint('TrackParcelOwnerController: payload parse error — $e\n$st');
    }
  }

  // ─── Road Polyline ────────────────────────────────────────────────────────

  Future<void> _fetchRoadPolyline() async {
    isLoadingRoute.value = true;
    try {
      final PolylineResult result =
          await PolylinePoints().getRouteBetweenCoordinates(
        googleApiKey: _googleApiKey,
        request: PolylineRequest(
          origin: PointLatLng(_pickupLatLng.latitude, _pickupLatLng.longitude),
          destination: PointLatLng(
            _handoverLatLng.latitude,
            _handoverLatLng.longitude,
          ),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        _fullRouteCoords =
            result.points.map((p) => LatLng(p.latitude, p.longitude)).toList();
        _drawPolyline(_fullRouteCoords);
        _fitCameraToRoute(_fullRouteCoords);
      } else {
        debugPrint('Directions API error: ${result.errorMessage}');
        _fallbackPolyline();
      }
    } catch (e) {
      debugPrint('_fetchRoadPolyline error: $e');
      _fallbackPolyline();
    } finally {
      isLoadingRoute.value = false;
    }
  }

  void _fallbackPolyline() {
    _fullRouteCoords = [_pickupLatLng, _handoverLatLng];
    _drawPolyline(_fullRouteCoords, dashed: true);
  }

  void _drawPolyline(List<LatLng> points, {bool dashed = false}) {
    polylines
      ..removeWhere((p) => p.polylineId.value == 'route')
      ..add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: AppColors.primaryColor,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
          patterns:
              dashed ? [PatternItem.dash(20), PatternItem.gap(10)] : [],
        ),
      );
  }

  /// Trims the already-travelled portion of the polyline so it shrinks
  /// as driver progresses — zero extra API calls.
  void _trimPolylineToDriver(LatLng driverPos) {
    if (_fullRouteCoords.length < 2) return;

    int nearestIndex = 0;
    double minDist = double.infinity;

    for (int i = 0; i < _fullRouteCoords.length; i++) {
      final double d = _haversineMeters(driverPos, _fullRouteCoords[i]);
      if (d < minDist) {
        minDist = d;
        nearestIndex = i;
      }
    }

    final List<LatLng> remaining = [
      driverPos,
      if (nearestIndex + 1 < _fullRouteCoords.length)
        ..._fullRouteCoords.sublist(nearestIndex + 1),
    ];

    if (remaining.length >= 2) _drawPolyline(remaining);
  }

  // ─── Markers ──────────────────────────────────────────────────────────────

  void _setStaticMarkers() {
    markers.addAll([
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLatLng,
        infoWindow: InfoWindow(
          title: 'Pickup',
          snippet: parcelItem.pickupLocation?.address ?? '',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
      Marker(
        markerId: const MarkerId('handover'),
        position: _handoverLatLng,
        infoWindow: InfoWindow(
          title: 'Handover',
          snippet: parcelItem.handoverLocation?.address ?? '',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    ]);
  }

  void _updateDriverMarker(LatLng pos, Map<String, dynamic> locationData) {
    final double speed = (locationData['speed'] as num? ?? 0).toDouble();

    markers
      ..removeWhere((m) => m.markerId.value == 'driver')
      ..add(
        Marker(
          markerId: const MarkerId('driver'),
          position: pos,
          infoWindow: InfoWindow(
            title: driverName.value.isNotEmpty ? driverName.value : 'Driver',
            snippet: 'Speed: ${speed.toStringAsFixed(1)} m/s',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          zIndex: 2,
        ),
      );
  }

  // ─── Camera ───────────────────────────────────────────────────────────────

  Future<void> _animateCameraTo(LatLng pos) async {
    if (!googleMapController.isCompleted) return;
    final c = await googleMapController.future;
    c.animateCamera(CameraUpdate.newLatLng(pos));
  }

  Future<void> _fitCameraToRoute(List<LatLng> coords) async {
    if (!googleMapController.isCompleted) return;

    double minLat = coords.first.latitude;
    double maxLat = coords.first.latitude;
    double minLng = coords.first.longitude;
    double maxLng = coords.first.longitude;

    for (final c in coords) {
      if (c.latitude < minLat) minLat = c.latitude;
      if (c.latitude > maxLat) maxLat = c.latitude;
      if (c.longitude < minLng) minLng = c.longitude;
      if (c.longitude > maxLng) maxLng = c.longitude;
    }

    final ctrl = await googleMapController.future;
    ctrl.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        80.0,
      ),
    );
  }

  // ─── Haversine ────────────────────────────────────────────────────────────

  double _haversineMeters(LatLng a, LatLng b) {
    const double r = 6371000;
    final double dLat = _rad(b.latitude - a.latitude);
    final double dLng = _rad(b.longitude - a.longitude);
    final double h = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_rad(a.latitude)) *
            math.cos(_rad(b.latitude)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return 2 * r * math.asin(math.sqrt(h));
  }

  double _rad(double deg) => deg * math.pi / 180;
}