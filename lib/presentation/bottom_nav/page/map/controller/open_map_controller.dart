import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:westchester/presentation/bottom_nav/page/map/model/open_map_model.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:westchester/utils/app_const/app_const.dart';

class OpenMapController extends GetxController {
  final ApiClient _api = ApiClient();
  final Rx<Data?> mapData = Rx<Data?>(null);
  final RxBool isLoading = true.obs;
  final RxBool routeReady = false.obs;

  // Distance & duration from Directions API
  final RxString distanceText = ''.obs;
  final RxString durationText = ''.obs;

  // Own markers & polylines — not shared with GoogleMapServices
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  final Rx<LatLng?> pickupLatLng = Rx<LatLng?>(null);
  final Rx<LatLng?> deliveryLatLng = Rx<LatLng?>(null);
  final Rx<LatLng?> driverLatLng = Rx<LatLng?>(null);

  String _deliveryId = '';
  bool _isJobDetailsMap = false;

  // The map controller set when map is created
  GoogleMapController? _mapController;

  // Called from MapPage after init
  void init({required Map<String, dynamic> args}) {
    _isJobDetailsMap = args['isJobDetailsMap'] == true;

    if (_isJobDetailsMap) {
      // Use data passed directly from Job Details
      final pickup = args['pickup'] as LatLng?;
      final delivery = args['delivery'] as LatLng?;
      final passedMarkers = args['markers'] as List<Marker>?;
      final passedPolylines = args['polylines'] as List<Polyline>?;
      if (passedMarkers != null) markers.assignAll(passedMarkers.toSet());
      if (passedPolylines != null) polylines.assignAll(passedPolylines.toSet());
      pickupLatLng.value = pickup;
      deliveryLatLng.value = delivery;
      isLoading.value = false;
      routeReady.value = true;
    } else {
      _deliveryId = args['id'] as String? ?? '';
      fetchMapData(_deliveryId);
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // If route already loaded, fit bounds immediately
    if (routeReady.value) {
      _fitBounds();
    }
  }

  Future<void> fetchMapData(String id) async {
    isLoading.value = true;
    routeReady.value = false;
    markers.clear();
    polylines.clear();
    try {
      final response = await _api.get(url: ApiUrl.openMap(id), isToken: true);
      if (response.statusCode == 200 && response.body != null) {
        final model = OpenMapModel.fromJson(response.body);
        if (model.success == true && model.data != null) {
          mapData.value = model.data;

          final pCoords = model.data!.pickupCoordinates?.coordinates;
          if (pCoords != null && pCoords.length >= 2) {
            pickupLatLng.value = LatLng(
              pCoords[1].toDouble(),
              pCoords[0].toDouble(),
            );
          }
          final dCoords = model.data!.dropoffCoordinates?.coordinates;
          if (dCoords != null && dCoords.length >= 2) {
            deliveryLatLng.value = LatLng(
              dCoords[1].toDouble(),
              dCoords[0].toDouble(),
            );
          }
          final drCoords = model.data!.driverCurrentLocation?.coordinates;
          if (drCoords != null && drCoords.length >= 2) {
            driverLatLng.value = LatLng(
              drCoords[1].toDouble(),
              drCoords[0].toDouble(),
            );
          }

          await _loadRoute();
        }
      }
    } catch (e) {
      debugPrint('Error fetching map details: $e');
    }
    isLoading.value = false;
  }

  Future<void> _loadRoute() async {
    final p = pickupLatLng.value;
    final d = deliveryLatLng.value;
    if (p == null || d == null) return;

    try {
      final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${p.latitude},${p.longitude}'
        '&destination=${d.latitude},${d.longitude}'
        '&departure_time=now'
        '&traffic_model=best_guess'
        '&units=metric'
        '&key=${AppConstants.googleMapsApiKey}',
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK') {
          final route = data['routes'][0];
          final leg = route['legs'][0];

          // ── Distance & Duration ────────────────────────────────
          final distData = leg['distance'] as Map<String, dynamic>?;
          final durData =
              leg['duration_in_traffic'] as Map<String, dynamic>? ??
              leg['duration'] as Map<String, dynamic>?;
          if (distData != null)
            distanceText.value = distData['text'] as String? ?? '';
          if (durData != null)
            durationText.value = durData['text'] as String? ?? '';

          debugPrint('-----------------------------------------');
          debugPrint('🚗 Distance: ${distanceText.value}');
          debugPrint('⏱️ Duration: ${durationText.value}');
          debugPrint('-----------------------------------------');

          // ── Polyline ──────────────────────────────────────────
          final decodedResult = PolylinePoints.decodePolyline(
            route['overview_polyline']['points'],
          );
          final points = decodedResult
              .map((pt) => LatLng(pt.latitude, pt.longitude))
              .toList();

          polylines.assignAll({
            Polyline(
              polylineId: const PolylineId('route'),
              points: points,
              color: AppColors.primaryColor,
              width: 5,
              jointType: JointType.round,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              geodesic: true,
            ),
          });

          final Set<Marker> newMarkers = {
            Marker(
              markerId: const MarkerId('pickup'),
              position: p,
              infoWindow: InfoWindow(
                title: 'Pickup',
                snippet: mapData.value?.pickupAddress ?? 'Pickup Location',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
            ),
            Marker(
              markerId: const MarkerId('delivery'),
              position: d,
              infoWindow: InfoWindow(
                title: 'Delivery',
                snippet: mapData.value?.dropoffAddress ?? 'Delivery Location',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
          };

          if (driverLatLng.value != null) {
            newMarkers.add(
              Marker(
                markerId: const MarkerId('driver'),
                position: driverLatLng.value!,
                infoWindow: const InfoWindow(title: 'Driver'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
              ),
            );
          }

          markers.assignAll(newMarkers);
          routeReady.value = true;

          // Fit bounds if map controller already exists
          if (_mapController != null) {
            Future.delayed(const Duration(milliseconds: 300), _fitBounds);
          }
        } else {
          // Fallback: just put markers without route
          markers.assignAll({
            Marker(
              markerId: const MarkerId('pickup'),
              position: p,
              infoWindow: const InfoWindow(title: 'Pickup'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
            ),
            Marker(
              markerId: const MarkerId('delivery'),
              position: d,
              infoWindow: const InfoWindow(title: 'Delivery'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
          });
          routeReady.value = true;
          if (_mapController != null) {
            Future.delayed(const Duration(milliseconds: 300), _fitBounds);
          }
        }
      }
    } catch (e) {
      debugPrint('Route load error: $e');
    }
  }

  void _fitBounds() {
    final p = pickupLatLng.value;
    final d = deliveryLatLng.value;
    if (_mapController == null || p == null || d == null) return;
    _mapController!.animateCamera(
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
        60,
      ),
    );
  }

  @override
  void onClose() {
    _mapController = null;
    super.onClose();
  }
}
