import 'dart:async';

import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/core/service/datasource/remote/socket_service.dart';
import 'package:delivery_app/features/driver/driver_home/model/driver_home_model.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class DriverHomeController extends GetxController {
  final ApiClient apiClient = sl();
  final LocalService localService = sl();

  // ─── Paging controller for REST-based infinite scroll ─────────────────────
  final PagingController<int, ParcelInformation> pagingController =
      PagingController(firstPageKey: 1);

  // ─── Real-time parcel list from socket (driver:available-parcels) ──────────
  // Updated live every time the backend pushes new nearby parcels
  final RxList<ParcelInformation> realtimeParcels = <ParcelInformation>[].obs;
  final RxBool isSocketLoading = false.obs;

  // ─── Current GPS position ──────────────────────────────────────────────────
  double _currentLat = 0.0;
  double _currentLng = 0.0;
  double? _currentHeading; // compass heading (optional, 0–360°)

  // ─── Timer: emit location to socket every 2 seconds ───────────────────────
  Timer? _locationEmitTimer;

  // ─── Per-parcel accept loading: parcelId → isLoading ──────────────────────
  final RxMap<String, bool> acceptLoadingMap = <String, bool>{}.obs;

  // ──────────────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();

    // 1. Subscribe to real-time parcel events from backend via socket
    _listenToAvailableParcels();

    // 2. Request GPS permission and start emitting location every 2s
    _startLocationTracking();

    // 3. REST paging — loads pages as user scrolls
    pagingController.addPageRequestListener(fetchPage);
  }

  // ─── STEP 1: Listen for backend's real-time parcel push ───────────────────
  /// Backend emits 'driver:available-parcels' in response to each
  /// 'driver:location-update'. We parse and store results reactively.
  void _listenToAvailableParcels() {
    SocketApi.socket?.on('driver:available-parcels', (data) {
      try {
        AppConfig.logger.d('📦 driver:available-parcels → $data');

        final rawList = data?['data'] as List<dynamic>?;
        if (rawList != null) {
          final parcels = rawList
              .map((item) =>
                  ParcelInformation.fromJson(item as Map<String, dynamic>))
              .toList();

          // Reactive update — UI rebuilds automatically via Obx
          realtimeParcels.assignAll(parcels);
          isSocketLoading.value = false;
        }
      } catch (e) {
        AppConfig.logger.e('driver:available-parcels parse error → $e');
      }
    });
  }

  // ─── STEP 2: Get GPS permission then start 2-second emit loop ─────────────
  Future<void> _startLocationTracking() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      AppConfig.logger.w('Location permission denied — skipping socket emit.');
      return;
    }

    // Get initial position immediately before timer starts
    await _updateCurrentPosition();

    // Emit every 2 seconds; backend throttles to max 1 response per 2s
    _locationEmitTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      await _updateCurrentPosition();
      _emitLocationToSocket();
    });
  }

  // ─── Get current device GPS position ──────────────────────────────────────
  Future<void> _updateCurrentPosition() async {
    try {
      final Position pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
      _currentLat = pos.latitude;
      _currentLng = pos.longitude;
      _currentHeading = pos.heading;
      AppConfig.logger
          .d('📍 GPS → lat=$_currentLat, lng=$_currentLng, heading=$_currentHeading');
    } catch (e) {
      AppConfig.logger.e('GPS error: $e');
    }
  }

  // ─── STEP 3: Emit driver:location-update to socket ────────────────────────
  /// Payload: currentLat, currentLng, optional heading & radiusMeters.
  /// Backend uses this to find nearby parcels and emits driver:available-parcels.
  void _emitLocationToSocket() {
    if (SocketApi.socket == null || !SocketApi.socket!.connected) {
      AppConfig.logger.w('Socket not connected — skipping emit.');
      return;
    }

    if (_currentLat == 0.0 && _currentLng == 0.0) {
      AppConfig.logger.w('GPS not ready — skipping emit.');
      return;
    }

    isSocketLoading.value = true;

    final payload = {
      'currentLat': _currentLat,
      'currentLng': _currentLng,
      if (_currentHeading != null) 'heading': _currentHeading,
      'radiusMeters': 1500,
    };

    AppConfig.logger.d('📡 Emitting driver:location-update → $payload');
    SocketApi.socket!.emit('driver:location-update', payload);
  }

  // ─── STEP 4: REST paginated fetch ─────────────────────────────────────────
  /// Used for manual refresh and infinite scroll.
  /// Real lat/lng are passed so backend returns location-aware results.
  Future<void> fetchPage(int pageKey) async {
    try {
      final response = await apiClient.get(
        url: ApiUrls.getDriverParcels(
          page: pageKey,
          currentLat: _currentLat,
          currentLng: _currentLng,
        ),
      );
      AppConfig.logger.d(response.data);

      if (response.statusCode == 200) {
        final driverHomeModel = DriverHomeModel.fromJson(response.data);
        final newItems = driverHomeModel.data?.data ?? <ParcelInformation>[];
        final isLastPage = newItems.length < 10;

        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
        }
      } else {
        pagingController.error = response.data['message'];
      }
    } catch (error) {
      AppConfig.logger.e(error);
      pagingController.error = error;
    }
  }

  // ─── Accept a parcel ──────────────────────────────────────────────────────
  Future<void> acceptParcel({required String id}) async {
    acceptLoadingMap[id] = true;
    try {
      final response = await apiClient.patch(
        url: ApiUrls.acceptParcel(id: id),
      );
      AppConfig.logger.d(response.data);

      if (response.statusCode == 200) {
        pagingController.refresh();
        realtimeParcels.removeWhere((p) => p.id == id);
        AppToast.success(message: response.data['message']);
      } else {
        AppConfig.logger.e(response.data['message']);
      }
    } catch (error) {
      AppConfig.logger.e(error);
      AppToast.error(message: error.toString());
    } finally {
      acceptLoadingMap[id] = false;
    }
  }

  // ─── Cleanup ──────────────────────────────────────────────────────────────
  @override
  void onClose() {
    _locationEmitTimer?.cancel();
    SocketApi.socket?.off('driver:available-parcels');
    pagingController.dispose();
    super.onClose();
  }
}
