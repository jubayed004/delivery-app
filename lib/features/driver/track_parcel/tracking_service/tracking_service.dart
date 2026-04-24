import 'dart:async';
import 'package:delivery_app/core/service/datasource/remote/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationTrackingService {
  static final LocationTrackingService _instance =
      LocationTrackingService._internal();

  factory LocationTrackingService() => _instance;

  LocationTrackingService._internal();

  StreamSubscription<Position>? _positionSubscription;
  Position? _lastEmittedPosition;

  /// The parcel ID currently being tracked — set when startTracking() is called.
  String? _parcelId;

  /// Minimum distance (meters) before emitting a new location
  static const double _minDistanceMeters = 1.0;

  /// Start tracking. Call this when driver starts a delivery.
  /// [parcelId] is required so the server can broadcast to the correct room.
  Future<void> startTracking({required String parcelId}) async {
    if (_positionSubscription != null) {
      debugPrint('LocationTrackingService: already tracking.');
      return;
    }

    _parcelId = parcelId;

    final bool hasPermission = await _checkPermissions();
    if (!hasPermission) return;

    // Join the parcel room on the server so the owner can listen
    _joinParcelRoom();

    // LocationSettings for smooth, battery-aware updates
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // OS-level pre-filter: only wake app every 5 m
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          _onPosition,
          onError: (Object error) {
            debugPrint('LocationTrackingService error: $error');
          },
        );

    debugPrint('LocationTrackingService: started for parcel $_parcelId.');
  }

  /// Stop tracking. Call when driver goes offline or delivery ends.
  void stopTracking() {
    _leaveParcelRoom();
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _lastEmittedPosition = null;
    _parcelId = null;
    debugPrint('LocationTrackingService: stopped.');
  }

  // ─── Socket Room ────────────────────────────────────────────────────────────

  void _joinParcelRoom() {
    final socket = SocketApi.socket;
    if (socket == null || !socket.connected) {
      // Retry in 2 s if socket is not yet ready
      debugPrint('LocationTrackingService: socket not ready — retrying join in 2s');
      Future.delayed(const Duration(seconds: 2), _joinParcelRoom);
      return;
    }
    socket.emit('join_parcel_tracking', {'parcel_id': _parcelId});
    debugPrint('LocationTrackingService: joined room for parcel $_parcelId');
  }

  void _leaveParcelRoom() {
    final socket = SocketApi.socket;
    if (socket == null || _parcelId == null) return;
    socket.emit('leave_parcel_tracking', {'parcel_id': _parcelId});
    debugPrint('LocationTrackingService: left room for parcel $_parcelId');
  }

  // ─── Private ────────────────────────────────────────────────────────────────

  void _onPosition(Position position) {
    if (_lastEmittedPosition == null) {
      // Always emit the very first position immediately
      _emitLocation(position);
      return;
    }

    final double distanceMoved = Geolocator.distanceBetween(
      _lastEmittedPosition!.latitude,
      _lastEmittedPosition!.longitude,
      position.latitude,
      position.longitude,
    );

    debugPrint(
      'LocationTrackingService: moved ${distanceMoved.toStringAsFixed(1)} m '
      '(threshold: $_minDistanceMeters m)',
    );

    if (distanceMoved >= _minDistanceMeters) {
      _emitLocation(position);
    }
  }

  void _emitLocation(Position position) {
    final socket = SocketApi.socket;

    if (socket == null || !socket.connected) {
      debugPrint(
        'LocationTrackingService: socket not connected, skipping emit.',
      );
      return;
    }

    final Map<String, dynamic> payload = {
      if (_parcelId != null) 'parcel_id': _parcelId, // ← server needs this to route broadcast
      'latitude': position.latitude,
      'longitude': position.longitude,
      'heading': position.heading,  // degrees from north
      'speed': position.speed,      // m/s
      'accuracy': position.accuracy, // metres
    };

    socket.emit('update-driver-location', payload);

    _lastEmittedPosition = position;

    debugPrint('LocationTrackingService: emitted → $payload');
  }

  Future<bool> _checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('LocationTrackingService: location services disabled.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      debugPrint('LocationTrackingService: permission denied.');
      return false;
    }

    return true;
  }
}

