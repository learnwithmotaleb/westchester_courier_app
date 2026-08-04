import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';

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

  @override
  void onInit() {
    super.onInit();
    fetchCurrentLocation();
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
