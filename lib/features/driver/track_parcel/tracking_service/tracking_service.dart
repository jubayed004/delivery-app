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

  /// Minimum distance (meters) before emitting a new location
  static const double _minDistanceMeters = 1.0;

  /// Start tracking. Call this when driver goes "online" / starts a delivery.
  Future<void> startTracking() async {
    if (_positionSubscription != null) {
      debugPrint('LocationTrackingService: already tracking.');
      return;
    }

    final bool hasPermission = await _checkPermissions();
    if (!hasPermission) return;

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

    debugPrint('LocationTrackingService: started.');
  }

  /// Stop tracking. Call when driver goes offline or delivery ends.
  void stopTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _lastEmittedPosition = null;
    debugPrint('LocationTrackingService: stopped.');
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
      'latitude': position.latitude,
      'longitude': position.longitude,
      'heading': position.heading, // degrees from north
      'speed': position.speed, // m/s  — convert if server expects km/h
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
