import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';

class GoogleMapServices extends GetxService {
  GoogleMapController? mapController;

  // Default location: Westchester, NY (approx)
  final Rx<CameraPosition> initialCameraPosition = const CameraPosition(
    target: LatLng(41.033986, -73.762910),
    zoom: 12.0,
  ).obs;

  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  // ── Current device GPS location ───────────────────────────────
  final RxDouble currentLat = 41.033986.obs;
  final RxDouble currentLng = (-73.762910).obs;
  final RxBool isLocationReady = false.obs;

  // ── Live Location Update Variables ──────────────────────────────
  final RxString activeDeliveryId = ''.obs;
  StreamSubscription<Position>? _positionStreamSubscription;
  final ApiClient _api = ApiClient();

  @override
  void onInit() {
    super.onInit();
    fetchCurrentLocation();
    _startLocationStream();
  }

  @override
  void onClose() {
    _positionStreamSubscription?.cancel();
    super.onClose();
  }

  void _startLocationStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Updates only when moving >= 10 meters
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) async {
      // 1. Update current location state
      currentLat.value = position.latitude;
      currentLng.value = position.longitude;

      // 2. Send API request if a delivery is active
      if (activeDeliveryId.value.isNotEmpty) {
        try {
          debugPrint(
            '📍 Distance >= 10m threshold met. Auto-updating live location for delivery ${activeDeliveryId.value} -> Lat: ${currentLat.value}, Lng: ${currentLng.value}',
          );

          await _api.patch(
            url: ApiUrl.liveLocationUpdate(activeDeliveryId.value),
            isToken: true,
            body: {"lng": currentLng.value, "lat": currentLat.value},
          );
        } catch (e) {
          debugPrint('Live location update error: $e');
        }
      }
    });
  }

  /// Fetches the real device GPS position and updates [currentLat]/[currentLng].
  Future<void> fetchCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) return;

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLat.value = position.latitude;
      currentLng.value = position.longitude;
      isLocationReady.value = true;

      // Also update camera position to real location
      initialCameraPosition.value = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      );

      // Animate map if already open
      animateCameraTo(LatLng(position.latitude, position.longitude));
    } catch (_) {
      // Falls back to default Westchester coordinates
      isLocationReady.value = true;
    }
  }

  /// Initializes the map controller when the map is created.
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// Moves the camera to a specific coordinate.
  void animateCameraTo(LatLng position, {double zoom = 14.0}) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom),
      ),
    );
  }

  /// Adds a standard marker to the map.
  void addMarker({
    required String id,
    required LatLng position,
    required String title,
    double hue = BitmapDescriptor.hueRed,
  }) {
    markers.add(
      Marker(
        markerId: MarkerId(id),
        position: position,
        infoWindow: InfoWindow(title: title),
        icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      ),
    );
  }

  /// Clears all markers from the map.
  void clearMarkers() {
    markers.clear();
  }

  /// Draws a simple line between two points.
  void addPolyline({required String id, required List<LatLng> points}) {
    polylines.add(
      Polyline(
        polylineId: PolylineId(id),
        points: points,
        color: AppColors.primaryColor,
        width: 4,
      ),
    );
  }

  /// Clears all polylines.
  void clearPolylines() {
    polylines.clear();
  }
}
