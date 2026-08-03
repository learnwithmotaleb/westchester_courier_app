import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_const/app_const.dart';

class JobDetailsController extends GetxController {
  // ─── Delivery Steps ─────────────────────────────────────────────────────────
  // 0: Unaccepted  1: Assigned  2: At Pickup  3: In Transit  4: At Drop  5: Done
  final rxStep = 0.obs;

  // ─── Map State ───────────────────────────────────────────────────────────────
  GoogleMapController? mapController;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final RxBool isMapLoading = true.obs;

  static const LatLng _defaultPickup = LatLng(40.7282, -74.0776); // Jersey City
  static const LatLng _defaultDelivery = LatLng(40.6643, -73.9385); // Brooklyn

  final Rx<LatLng> pickupLatLng = const LatLng(40.7282, -74.0776).obs;
  final Rx<LatLng> deliveryLatLng = const LatLng(40.6643, -73.9385).obs;

  // Addresses (will come from API later)
  static const String pickupAddress = '151 Newark Ave, Jersey City, NJ 07302';
  static const String deliveryAddress = '1426 Atlantic Ave, Brooklyn, NY 11216';

  bool _mapReady = false;
  bool _routeLoaded = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final bool isAccepted = args['isAccepted'] as bool? ?? false;
    rxStep.value = isAccepted ? 1 : 0;
    _loadRoute();
  }

  // ─── Map Callbacks ──────────────────────────────────────────────────────────
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _mapReady = true;
    if (_routeLoaded) _fitBounds();
  }

  // ─── Route Loading via Directions API ────────────────────────────────────────
  Future<void> _loadRoute() async {
    isMapLoading.value = true;
    try {
      final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${Uri.encodeComponent(pickupAddress)}'
        '&destination=${Uri.encodeComponent(deliveryAddress)}'
        '&key=${AppConstants.googleMapsApiKey}',
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK') {
          final route = data['routes'][0];
          final leg = route['legs'][0];

          // Extract start & end coordinates
          final start = leg['start_location'];
          final end = leg['end_location'];
          pickupLatLng.value = LatLng(start['lat'], start['lng']);
          deliveryLatLng.value = LatLng(end['lat'], end['lng']);

          // Decode route polyline using flutter_polyline_points
          final decodedResult = PolylinePoints.decodePolyline(
            route['overview_polyline']['points'],
          );
          final points = decodedResult
              .map((p) => LatLng(p.latitude, p.longitude))
              .toList();

          polylines.value = {
            Polyline(
              polylineId: const PolylineId('route'),
              points: points,
              color: const Color(0xFF4285F4), // Official Google Maps Blue
              width: 5,
              jointType: JointType.round,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              geodesic: true,
            ),
          };

          markers.value = {
            Marker(
              markerId: const MarkerId('pickup'),
              position: pickupLatLng.value,
              infoWindow: const InfoWindow(title: 'Pickup'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
            ),
            Marker(
              markerId: const MarkerId('delivery'),
              position: deliveryLatLng.value,
              infoWindow: const InfoWindow(title: 'Delivery'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
          };
        } else {
          debugPrint('Directions API status: ${data['status']}');
          _setDefaultMarkers();
        }
      } else {
        _setDefaultMarkers();
      }
    } catch (e) {
      debugPrint('Route load error: $e');
      _setDefaultMarkers();
    } finally {
      _routeLoaded = true;
      isMapLoading.value = false;
      if (_mapReady) _fitBounds();
    }
  }

  void _setDefaultMarkers() {
    markers.value = {
      Marker(
        markerId: const MarkerId('pickup'),
        position: _defaultPickup,
        infoWindow: const InfoWindow(title: 'Pickup'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
      Marker(
        markerId: const MarkerId('delivery'),
        position: _defaultDelivery,
        infoWindow: const InfoWindow(title: 'Delivery'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
  }

  /// Camera কে দুইটা marker এর মধ্যে fit করে
  void _fitBounds() {
    if (mapController == null) return;
    final p = pickupLatLng.value;
    final d = deliveryLatLng.value;
    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            p.latitude < d.latitude ? p.latitude : d.latitude,
            p.longitude < d.longitude ? p.longitude : d.longitude,
          ),
          northeast: LatLng(
            p.latitude > d.latitude ? p.latitude : d.latitude,
            p.longitude > d.longitude ? p.longitude : d.longitude,
          ),
        ),
        50, // padding in dp
      ),
    );
  }

  // ─── Job Step Actions ────────────────────────────────────────────────────────
  void acceptRequest() => rxStep.value = 1;
  void arriveAtPickup() => rxStep.value = 2;
  void confirmPickup() => rxStep.value = 3;
  void arriveAtDelivery() => rxStep.value = 4;
  void completeDelivery() {} // Navigation triggered from UI
  void markAsDone() => rxStep.value = 5;
}
