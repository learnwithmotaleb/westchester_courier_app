import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';

class GoogleMapServices extends GetxService {
  GoogleMapController? mapController;

  final Rx<CameraPosition> initialCameraPosition = const CameraPosition(
    target: LatLng(41.033986, -73.762910),
    zoom: 12.0,
  ).obs;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final RxDouble currentLat = 41.033986.obs;
  final RxDouble currentLng = (-73.762910).obs;
  final RxBool isLocationReady = false.obs;
  final RxString activeDeliveryId = ''.obs;

  StreamSubscription<Position>? _positionStreamSubscription;
  final ApiClient _api = ApiClient();
  bool _isSendingLocation = false;

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      isLocationReady.value = true;
      return;
    }
    await fetchCurrentLocation();
  }

  /// Starts continuous server updates only for an active delivery.
  Future<bool> startDeliveryTracking(String deliveryId) async {
    if (deliveryId.trim().isEmpty) return false;
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();
    if (!serviceEnabled ||
        permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    activeDeliveryId.value = deliveryId;
    if (_positionStreamSubscription == null) _startLocationStream();
    return true;
  }

  Future<void> stopDeliveryTracking() async {
    activeDeliveryId.value = '';
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  void _startLocationStream() {
    final LocationSettings settings;
    if (Platform.isAndroid) {
      settings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        intervalDuration: const Duration(seconds: 10),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'Westchester Courier delivery tracking',
          notificationText:
              'Your location is being used to track the active delivery.',
          notificationChannelName: 'Active delivery location',
          enableWakeLock: true,
          setOngoing: true,
        ),
      );
    } else if (Platform.isIOS) {
      settings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.automotiveNavigation,
        distanceFilter: 10,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
        allowBackgroundLocationUpdates: true,
      );
    } else {
      settings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    }

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen((position) {
      currentLat.value = position.latitude;
      currentLng.value = position.longitude;
      _sendLiveLocation(position);
    }, onError: (Object error) {
      debugPrint('Location stream error: $error');
    });
  }

  Future<void> _sendLiveLocation(Position position) async {
    final deliveryId = activeDeliveryId.value;
    if (deliveryId.isEmpty || _isSendingLocation) return;
    _isSendingLocation = true;
    try {
      final response = await _api.patch(
        url: ApiUrl.liveLocationUpdate(deliveryId),
        isToken: true,
        body: {'lng': position.longitude, 'lat': position.latitude},
      );
      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        debugPrint(
          'Live location update failed ($statusCode): '
          '${response.body?["message"] ?? "Unknown error"}',
        );
      }
    } catch (e) {
      debugPrint('Live location update error: $e');
    } finally {
      _isSendingLocation = false;
    }
  }

  Future<void> fetchCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLat.value = position.latitude;
      currentLng.value = position.longitude;
      isLocationReady.value = true;
      initialCameraPosition.value = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      );
      animateCameraTo(LatLng(position.latitude, position.longitude));
    } catch (_) {
      isLocationReady.value = true;
    }
  }

  void onMapCreated(GoogleMapController controller) => mapController = controller;

  void animateCameraTo(LatLng position, {double zoom = 14.0}) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom),
      ),
    );
  }

  void addMarker({
    required String id,
    required LatLng position,
    required String title,
    double hue = BitmapDescriptor.hueRed,
  }) {
    markers.add(Marker(
      markerId: MarkerId(id),
      position: position,
      infoWindow: InfoWindow(title: title),
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
    ));
  }

  void clearMarkers() => markers.clear();

  void addPolyline({required String id, required List<LatLng> points}) {
    polylines.add(Polyline(
      polylineId: PolylineId(id),
      points: points,
      color: AppColors.primaryColor,
      width: 4,
    ));
  }

  void clearPolylines() => polylines.clear();

  @override
  void onClose() {
    _positionStreamSubscription?.cancel();
    super.onClose();
  }
}
