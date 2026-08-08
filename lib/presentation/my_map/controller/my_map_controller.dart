import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../../../service/api_service.dart';
import '../../../service/api_url.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_const/app_const.dart';
import '../model/my_map_model.dart';

enum MapFilter { pickup, delivery }

class MyMapController extends GetxController {
  static MyMapController get to => Get.find<MyMapController>();

  final ApiClient _api = ApiClient();

  // ── State ─────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<MapFilter> activeFilter = MapFilter.pickup.obs;

  // Data
  final RxList<MapPoint> currentPoints = <MapPoint>[].obs;
  final RxList<MyMapFullDelivery> fullDeliveries = <MyMapFullDelivery>[].obs;

  // ── Map ───────────────────────────────────────────────────────
  GoogleMapController? mapController;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  final Rx<CameraPosition> cameraPosition = const CameraPosition(
    target: LatLng(41.033986, -73.762910),
    zoom: 11.0,
  ).obs;

  // Distance & duration
  final RxString distanceText = ''.obs;
  final RxString durationText = ''.obs;

  // ── Bottom Sheet ──────────────────────────────────────────────
  final Rx<MyMapFullDelivery?> selectedDelivery = Rx<MyMapFullDelivery?>(null);

  @override
  void onInit() {
    super.onInit();
    loadMyMap();
  }

  // ─────────────────────────────────────────────────────────────
  //  API
  // ─────────────────────────────────────────────────────────────

  Future<void> loadMyMap() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    clearSelection();

    try {
      final url = _urlForFilter(activeFilter.value);
      final response = await _api.get(url: url, isToken: true);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = MyMapModel.fromJson(
          response.body as Map<String, dynamic>,
        );
        fullDeliveries.assignAll(model.data ?? []);

        // Use the filtered points list based on what was returned
        if (activeFilter.value == MapFilter.pickup) {
          currentPoints.assignAll(model.pickupPoints ?? model.points ?? []);
        } else {
          currentPoints.assignAll(model.deliveryPoints ?? model.points ?? []);
        }

        _buildMarkers();
      } else {
        hasError.value = true;
        errorMessage.value = response.statusText ?? 'Something went wrong';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load map data';
      debugPrint('Load map error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _urlForFilter(MapFilter filter) {
    switch (filter) {
      case MapFilter.pickup:
        return ApiUrl.myMapTypePickup;
      case MapFilter.delivery:
        return ApiUrl.myMapTypeDelivery;
    }
  }

  // ─────────────────────────────────────────────────────────────
  //  FILTER
  // ─────────────────────────────────────────────────────────────

  void setFilter(MapFilter filter) {
    if (activeFilter.value == filter) return;
    activeFilter.value = filter;
    loadMyMap();
  }

  // ─────────────────────────────────────────────────────────────
  //  MARKERS
  // ─────────────────────────────────────────────────────────────

  void _buildMarkers() {
    final newMarkers = <Marker>{};

    for (final point in currentPoints) {
      if (point.lat != null && point.lng != null) {
        final isPickup = point.isPickup;
        newMarkers.add(
          Marker(
            markerId: MarkerId('${point.pointType}_${point.deliveryId}'),
            position: LatLng(point.lat!, point.lng!),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              isPickup ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
            ),
            infoWindow: InfoWindow(
              title: isPickup ? 'Pickup' : 'Delivery',
              snippet: point.address ?? point.displayName,
            ),
            onTap: () => _onMarkerTapped(point.deliveryId),
          ),
        );
      }
    }

    markers.assignAll(newMarkers);

    // Fit bounds to show all markers
    if (currentPoints.isNotEmpty && mapController != null) {
      Future.delayed(const Duration(milliseconds: 300), _fitAllMarkersBounds);
    }
  }

  void _fitAllMarkersBounds() {
    if (currentPoints.isEmpty || mapController == null) return;

    double minLat = currentPoints.first.lat!;
    double maxLat = currentPoints.first.lat!;
    double minLng = currentPoints.first.lng!;
    double maxLng = currentPoints.first.lng!;

    for (var p in currentPoints) {
      if (p.lat == null || p.lng == null) continue;
      if (p.lat! < minLat) minLat = p.lat!;
      if (p.lat! > maxLat) maxLat = p.lat!;
      if (p.lng! < minLng) minLng = p.lng!;
      if (p.lng! > maxLng) maxLng = p.lng!;
    }

    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        60, // padding
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  //  MAP CONTROLLER
  // ─────────────────────────────────────────────────────────────

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (currentPoints.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 300), _fitAllMarkersBounds);
    }
  }

  // ─────────────────────────────────────────────────────────────
  //  SELECTION / ROUTES
  // ─────────────────────────────────────────────────────────────

  void _onMarkerTapped(String? deliveryId) {
    if (deliveryId == null) return;

    // Find matching full delivery data
    final delivery = fullDeliveries.firstWhereOrNull((d) => d.id == deliveryId);
    if (delivery != null) {
      selectedDelivery.value = delivery;

      // Draw route between pickup and delivery
      if (delivery.pickupLat != null &&
          delivery.pickupLng != null &&
          delivery.dropoffLat != null &&
          delivery.dropoffLng != null) {
        _loadRoute(
          LatLng(delivery.pickupLat!, delivery.pickupLng!),
          LatLng(delivery.dropoffLat!, delivery.dropoffLng!),
        );
      }
    }
  }

  void clearSelection() {
    selectedDelivery.value = null;
    polylines.clear();
    distanceText.value = '';
    durationText.value = '';
    if (currentPoints.isNotEmpty && mapController != null) {
      _fitAllMarkersBounds();
    }
  }

  Future<void> _loadRoute(LatLng p, LatLng d) async {
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

          // Animate camera to fit both pickup and delivery bounds
          if (mapController != null) {
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
                80,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Route load error: $e');
    }
  }
}
