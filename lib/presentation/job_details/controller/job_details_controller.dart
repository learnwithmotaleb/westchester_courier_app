import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:westchester/utils/app_const/app_const.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';
import 'package:westchester/presentation/job_details/model/deliveries_model.dart';

// ─── Vehicle Model ───────────────────────────────────────────────────────────
class VehicleOption {
  final String key;
  final String label;
  final String emoji;
  final double speedKmh;
  final double baseFare;
  final double perKmRate;

  const VehicleOption({
    required this.key,
    required this.label,
    required this.emoji,
    required this.speedKmh,
    required this.baseFare,
    required this.perKmRate,
  });

  double etaMinutes(double distanceKm) =>
      (distanceKm / speedKmh) * 60;

  double fare(double distanceKm) =>
      baseFare + (distanceKm * perKmRate);
}

// ─── Vehicle Definitions ─────────────────────────────────────────────────────
const List<VehicleOption> kVehicleOptions = [
  VehicleOption(
    key: 'bike',
    label: 'Bike',
    emoji: '🏍️',
    speedKmh: 40,
    baseFare: 5.0,
    perKmRate: 1.50,
  ),
  VehicleOption(
    key: 'car',
    label: 'Car',
    emoji: '🚗',
    speedKmh: 60,
    baseFare: 8.0,
    perKmRate: 2.00,
  ),
  VehicleOption(
    key: 'truck',
    label: 'Truck',
    emoji: '🚚',
    speedKmh: 30,
    baseFare: 12.0,
    perKmRate: 3.00,
  ),
];

class JobDetailsController extends GetxController {
  final ApiClient _api = ApiClient();
  final Rx<Data?> deliveryData = Rx<Data?>(null);
  final RxBool isLoading = true.obs;

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

  // Addresses
  final RxString pickupAddress = ''.obs;
  final RxString deliveryAddress = ''.obs;

  // ─── Route Info ──────────────────────────────────────────────────────────────
  /// Distance in kilometres (e.g. 12.5)
  final RxDouble distanceKm = 0.0.obs;

  /// Human-readable distance string from Google (e.g. "12.5 km")
  final RxString distanceText = ''.obs;

  /// Google ETA with traffic (e.g. "22 mins")
  final RxString etaText = ''.obs;

  /// Raw duration seconds with traffic (used for display fallback)
  final RxInt etaSeconds = 0.obs;

  // ─── Vehicle Selection ───────────────────────────────────────────────────────
  final RxString selectedVehicle = 'bike'.obs;

  VehicleOption get selectedVehicleOption =>
      kVehicleOptions.firstWhere((v) => v.key == selectedVehicle.value);

  /// ETA in minutes for the currently selected vehicle
  double get vehicleEtaMinutes =>
      distanceKm.value > 0 ? selectedVehicleOption.etaMinutes(distanceKm.value) : 0;

  /// Delivery fare for the currently selected vehicle
  double get vehicleFare =>
      distanceKm.value > 0 ? selectedVehicleOption.fare(distanceKm.value) : 0;

  void selectVehicle(String key) => selectedVehicle.value = key;

  bool _mapReady = false;
  bool _routeLoaded = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final bool isAccepted = args['isAccepted'] as bool? ?? false;
    rxStep.value = isAccepted ? 1 : 0;
    
    final id = args['id'] as String? ?? '6a71ec4d1988ecda1c263447'; // Use passed ID or fallback for testing
    fetchDeliveryDetails(id);
  }

  Future<void> fetchDeliveryDetails(String id) async {
    isLoading.value = true;
    isMapLoading.value = true;
    try {
      final response = await _api.get(
        url: ApiUrl.deliveryDetails(id),
        isToken: true,
      );
      if (response.statusCode == 200 && response.body != null) {
        final model = DeliveriesModel.fromJson(response.body);
        if (model.success == true && model.data != null) {
          deliveryData.value = model.data;
          rxStep.value = _getStepFromStatus(model.data!.status);
          
          final pCoords = model.data!.pickupCoordinates?.coordinates;
          if (pCoords != null && pCoords.length >= 2) {
            pickupLatLng.value = LatLng(pCoords[1].toDouble(), pCoords[0].toDouble());
          }
          final dCoords = model.data!.dropoffCoordinates?.coordinates;
          if (dCoords != null && dCoords.length >= 2) {
            deliveryLatLng.value = LatLng(dCoords[1].toDouble(), dCoords[0].toDouble());
          }
          pickupAddress.value = model.data!.pickupAddress ?? '';
          deliveryAddress.value = model.data!.dropoffAddress ?? '';
          
          await _loadRoute();
          isLoading.value = false;
          return;
        }
      }
    } catch (e) {
      debugPrint('Error fetching delivery details: $e');
    }
    // Fallback if API fails
    await _loadRoute();
    isLoading.value = false;
  }

  int _getStepFromStatus(String? status) {
    if (status == null) return 0;
    switch (status) {
      case 'UNASSIGNED':
      case 'ASSIGNED':
        return 0;
      case 'DRIVER_ACCEPTED':
      case 'DRIVER_TO_PICKUP':
        return 1;
      case 'PICKED_UP':
      case 'IN_TRANSIT':
        return 3;
      case 'OUT_FOR_DELIVERY':
        return 4;
      case 'DELIVERED':
        return 5;
      default:
        return 0;
    }
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
        '?origin=${pickupLatLng.value.latitude},${pickupLatLng.value.longitude}'
        '&destination=${deliveryLatLng.value.latitude},${deliveryLatLng.value.longitude}'
        '&departure_time=now'
        '&traffic_model=best_guess'
        '&key=${AppConstants.googleMapsApiKey}',
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK') {
          final route = data['routes'][0];
          final leg = route['legs'][0];

          // ── Coordinates ──────────────────────────────────────────
          final start = leg['start_location'];
          final end = leg['end_location'];
          pickupLatLng.value = LatLng(start['lat'], start['lng']);
          deliveryLatLng.value = LatLng(end['lat'], end['lng']);

          // ── Distance ─────────────────────────────────────────────
          final distData = leg['distance'] as Map<String, dynamic>?;
          if (distData != null) {
            final meters = (distData['value'] as num).toDouble();
            distanceKm.value = meters / 1000.0;
            distanceText.value = distData['text'] as String? ?? '';
          }

          // ── ETA (with traffic if available, else normal duration) ─
          final trafficDuration =
              leg['duration_in_traffic'] as Map<String, dynamic>?;
          final normalDuration = leg['duration'] as Map<String, dynamic>?;

          if (trafficDuration != null) {
            etaSeconds.value = (trafficDuration['value'] as num).toInt();
            etaText.value = trafficDuration['text'] as String? ?? '';
          } else if (normalDuration != null) {
            etaSeconds.value = (normalDuration['value'] as num).toInt();
            etaText.value = normalDuration['text'] as String? ?? '';
          }

          // ── Polyline ─────────────────────────────────────────────
          final decodedResult = PolylinePoints.decodePolyline(
            route['overview_polyline']['points'],
          );
          final points = decodedResult
              .map((p) => LatLng(p.latitude, p.longitude))
              .toList();

          polylines.assignAll({
            Polyline(
              polylineId: const PolylineId('route'),
              points: points,
              color: const Color(0xFF4285F4),
              width: 5,
              jointType: JointType.round,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              geodesic: true,
            ),
          });

          // ── Markers ──────────────────────────────────────────────
          markers.assignAll({
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
          });
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
    markers.assignAll({
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
    });
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
