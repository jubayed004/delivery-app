import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:delivery_app/core/service/datasource/remote/socket_service.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:delivery_app/features/parcel_owner/my_parcel/model/parcel_model.dart';
import 'package:delivery_app/utils/color/app_colors.dart';

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
  final RxDouble driverSpeed = 0.0.obs;
  final RxString lastUpdated = ''.obs;

  late final LatLng _pickupLatLng;
  late final LatLng _handoverLatLng;

  CameraPosition get initialCameraPosition =>
      CameraPosition(target: _pickupLatLng, zoom: 14.0);

  List<LatLng> _fullRouteCoords = [];

  BitmapDescriptor? _carIcon;

  /// true after onClose() — prevents any async callback from running
  bool _disposed = false;

  /// Ensures we never register the same listeners twice
  bool _listenersRegistered = false;

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  Future<void> _initCustomMarker() async {
    try {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      const double iconSize = 120.0; // Much larger car icon

      TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
        text: String.fromCharCode(Icons.directions_car.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: Icons.directions_car.fontFamily,
          package: Icons.directions_car.fontPackage,
          color: AppColors.primaryColor, // Using primary color for the car
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, const Offset(0, 0));

      final img = await pictureRecorder.endRecording().toImage(
        textPainter.width.toInt(),
        textPainter.height.toInt(),
      );
      final data = await img.toByteData(format: ui.ImageByteFormat.png);
      _carIcon = BitmapDescriptor.fromBytes(data!.buffer.asUint8List());

      // If we already received location before icon was ready, update the marker
      if (driverLatLng.value != null) {
        _updateDriverMarker(driverLatLng.value!, {}, 0.0);
      }
    } catch (e) {
      debugPrint('⚠️ [Owner] Failed to load custom car marker: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initCustomMarker();

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
    _disposed = true;
    _leaveSocketTracking();
    super.onClose();
  }

  // ─── Socket ───────────────────────────────────────────────────────────────
  /*
  void _joinSocketTracking() {
    if (_disposed) return;

    final socket = SocketApi.socket;

    if (socket == null || !socket.connected) {
      debugPrint(
        '⏳ [Owner] Socket not ready — retrying in 2s (parcel: ${parcelItem.id})',
      );
      Future.delayed(const Duration(seconds: 2), _joinSocketTracking);
      return;
    }

    dynamic data = {'parcel_id': parcelItem.id};

    // ✅ Join the parcel room so server broadcasts driver updates to us
    socket.emit('join_parcel_tracking', [data]);
    debugPrint('🟢 [Owner] Joined parcel room → ${parcelItem.id}');

    // ✅ Register listeners only once — prevents duplicate callbacks
    if (!_listenersRegistered) {
      socket.on('driver_location_data', _onDriverLocationData);
      socket.on('driver_location_update', _onDriverLocationUpdate);

      // ✅ Re-join parcel room automatically after socket reconnects
      socket.on('connect', _onSocketReconnected);

      _listenersRegistered = true;
      debugPrint('✅ [Owner] Socket listeners registered');
    }
  }
*/

  void _joinSocketTracking() {
    if (_disposed) return;

    final socket = SocketApi.socket;

    if (socket == null || !socket.connected) {
      debugPrint('⏳ [Owner] Socket not ready — retrying in 2s');
      Future.delayed(const Duration(seconds: 6), _joinSocketTracking);
      return;
    }

    // ✅ FIX: Send the ID as a STRING, not a List or Map
    // This matches backend: socket.on('join_parcel_tracking', async (parcelId: string) => ...
    socket.emit('join_parcel_tracking', parcelItem.id);

    debugPrint('🟢 [Owner] Joined parcel room → ${parcelItem.id}');

    if (!_listenersRegistered) {
      // This is triggered once when you first join (initial location)
      socket.on('driver_location_data', (data) {
        debugPrint('📍 Initial Location Received: $data');
        _onDriverLocationData(data);
      });

      // This is triggered every time the driver moves
      socket.on('driver_location_update', (data) {
        debugPrint('🛰️ Live Update Received: $data');
        _onDriverLocationUpdate(data);
      });

      socket.on('connect', _onSocketReconnected);

      _listenersRegistered = true;
      debugPrint('✅ [Owner] Socket listeners registered');
    }
  }

  /// Called by socket whenever it reconnects — we must re-emit join_parcel_tracking
  /// because the server loses room membership on disconnect.
  void _onSocketReconnected(dynamic _) {
    if (_disposed) return;
    final socket = SocketApi.socket;
    if (socket == null) return;
    socket.emit('join_parcel_tracking', {'parcel_id': parcelItem.id});
    debugPrint(
      '🔁 [Owner] Reconnected — re-joined parcel room → ${parcelItem.id}',
    );
  }

  void _leaveSocketTracking() {
    final socket = SocketApi.socket;
    if (socket == null) return;

    // Remove all our event listeners
    socket.off('driver_location_data');
    socket.off('driver_location_update');
    socket.off('connect', _onSocketReconnected);

    // Tell server we are leaving the parcel room
    if (socket.connected && parcelItem.id != null) {
      socket.emit('leave_parcel_tracking', {'parcel_id': parcelItem.id});
    }

    _listenersRegistered = false;
    debugPrint('🔴 [Owner] Left parcel room → ${parcelItem.id}');
  }

  void _onDriverLocationData(dynamic data) {
    debugPrint('📍 [Owner] driver_location_data received: $data');
    _handleLocationPayload(data);
  }

  void _onDriverLocationUpdate(dynamic data) {
    debugPrint('🔄 [Owner] driver_location_update received: $data');
    _handleLocationPayload(data);
  }

  void _handleLocationPayload(dynamic raw) {
    if (_disposed || raw == null) return;

    try {
      final Map<String, dynamic> body = raw is Map<String, dynamic>
          ? raw
          : Map<String, dynamic>.from(raw as Map);

      Map<String, dynamic> locationData;

      // Format A — { success: true, data: { latitude, longitude, ... } }
      if (body['success'] == true && body['data'] is Map) {
        locationData = Map<String, dynamic>.from(body['data'] as Map);
      }
      // Format B — { latitude, longitude, ... } (direct payload)
      else if (body.containsKey('latitude') && body.containsKey('longitude')) {
        locationData = body;
      }
      // Format C — { data: { latitude, longitude, ... } } without success key
      else if (body['data'] is Map) {
        locationData = Map<String, dynamic>.from(body['data'] as Map);
      } else {
        debugPrint('❌ [Owner] Unrecognised payload format → $body');
        return;
      }

      final double? lat = (locationData['latitude'] as num?)?.toDouble();
      final double? lng = (locationData['longitude'] as num?)?.toDouble();

      if (lat == null || lng == null) {
        debugPrint('❌ [Owner] Missing lat/lng in payload → $locationData');
        return;
      }

      final LatLng newPos = LatLng(lat, lng);

      // Parse driver info for the bottom info card
      final dynamic driverRaw = locationData['driver_id'];
      if (driverRaw is Map) {
        driverName.value = driverRaw['full_name'] as String? ?? 'Driver';
      }

      driverSpeed.value = (locationData['speed'] as num? ?? 0).toDouble();
      lastUpdated.value = locationData['last_updated'] as String? ?? '';
      final double heading = (locationData['heading'] as num? ?? 0).toDouble();

      driverLatLng.value = newPos;
      _updateDriverMarker(newPos, locationData, heading);
      // _trimPolylineToDriver(newPos); // Commented out to keep the full road route static
      _animateCameraTo(newPos);

      debugPrint('✅ [Owner] Driver marker placed at ($lat, $lng)');
    } catch (e, st) {
      debugPrint('❌ [Owner] Payload parse error — $e\n$st');
    }
  }

  // ─── Road Polyline ────────────────────────────────────────────────────────

  Future<void> _fetchRoadPolyline() async {
    isLoadingRoute.value = true;
    try {
      final PolylineResult result = await PolylinePoints()
          .getRouteBetweenCoordinates(
            googleApiKey: AppConfig.googleApiKey,
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
        _fullRouteCoords = result.points
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();
        _drawPolyline(_fullRouteCoords);
        _fitCameraToRouteWhenReady(_fullRouteCoords);
      } else {
        debugPrint('⚠️ [Owner] Directions API error — ${result.errorMessage}');
        _fallbackPolyline();
      }
    } catch (e) {
      debugPrint('⚠️ [Owner] _fetchRoadPolyline error — $e');
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
          patterns: dashed ? [PatternItem.dash(20), PatternItem.gap(10)] : [],
        ),
      );
  }

  /// Trims the polyline ahead of the driver — zero extra API calls.
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
        icon: BitmapDescriptor.defaultMarker, // 🔴 red
      ),
      Marker(
        markerId: const MarkerId('handover'),
        position: _handoverLatLng,
        infoWindow: InfoWindow(
          title: 'Handover',
          snippet: parcelItem.handoverLocation?.address ?? '',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue, // 🔵 blue
        ),
      ),
    ]);
  }

  void _updateDriverMarker(LatLng pos, Map<String, dynamic> locationData, double heading) {
    final double speed = (locationData['speed'] as num? ?? 0).toDouble();
    final String name = driverName.value.isNotEmpty
        ? driverName.value
        : 'Driver';

    // Remove old driver marker then add updated one
    final updatedMarkers = markers
        .where((m) => m.markerId.value != 'driver')
        .toSet();

    updatedMarkers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: pos,
        rotation: heading,
        anchor: const Offset(0.5, 0.5), // Center anchor for proper rotation
        infoWindow: InfoWindow(
          title: '🚗 $name',
          snippet: 'Speed: ${speed.toStringAsFixed(1)} m/s',
        ),
        icon:
            _carIcon ??
            BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen, // 🟢 green fallback
            ),
        zIndexInt: 2,
      ),
    );

    // Replace entire set to guarantee Obx rebuild
    markers
      ..clear()
      ..addAll(updatedMarkers);
  }

  // ─── Camera ───────────────────────────────────────────────────────────────

  Future<void> _animateCameraTo(LatLng pos) async {
    if (!googleMapController.isCompleted) return;
    try {
      final c = await googleMapController.future;
      c.animateCamera(CameraUpdate.newLatLng(pos));
    } catch (e) {
      debugPrint('⚠️ [Owner] animateCamera error — $e');
    }
  }

  /// Waits for map to be ready (up to 10s) before fitting camera to route bounds.
  Future<void> _fitCameraToRouteWhenReady(List<LatLng> coords) async {
    for (int i = 0; i < 20; i++) {
      if (_disposed) return;
      if (googleMapController.isCompleted) break;
      await Future.delayed(const Duration(milliseconds: 500));
    }
    if (!googleMapController.isCompleted || _disposed) return;
    await _fitCameraToRoute(coords);
  }

  Future<void> _fitCameraToRoute(List<LatLng> coords) async {
    if (!googleMapController.isCompleted || coords.isEmpty) return;

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

    try {
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
    } catch (e) {
      debugPrint('⚠️ [Owner] fitCamera error — $e');
    }
  }

  // ─── Haversine ────────────────────────────────────────────────────────────

  double _haversineMeters(LatLng a, LatLng b) {
    const double r = 6371000;
    final double dLat = _rad(b.latitude - a.latitude);
    final double dLng = _rad(b.longitude - a.longitude);
    final double h =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_rad(a.latitude)) *
            math.cos(_rad(b.latitude)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return 2 * r * math.asin(math.sqrt(h));
  }

  double _rad(double deg) => deg * math.pi / 180;
}
