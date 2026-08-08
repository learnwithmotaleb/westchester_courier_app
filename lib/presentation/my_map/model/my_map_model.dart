// ignore_for_file: invalid_annotation_target

/// Top-level response from GET /deliveries/my-map
class MyMapModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final List<MapPoint>? points;
  final List<MapPoint>? pickupPoints;
  final List<MapPoint>? deliveryPoints;
  final List<MyMapFullDelivery>? data;

  MyMapModel({
    this.success,
    this.statusCode,
    this.message,
    this.points,
    this.pickupPoints,
    this.deliveryPoints,
    this.data,
  });

  factory MyMapModel.fromJson(Map<String, dynamic> json) => MyMapModel(
    success: json['success'] as bool?,
    statusCode: json['statusCode'] as int?,
    message: json['message'] as String?,
    points: _parsePoints(json['points']),
    pickupPoints: _parsePoints(json['pickupPoints']),
    deliveryPoints: _parsePoints(json['deliveryPoints']),
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => MyMapFullDelivery.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  static List<MapPoint>? _parsePoints(dynamic list) {
    if (list == null) return null;
    return (list as List<dynamic>)
        .map((e) => MapPoint.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

/// A single point on the map (pickup or delivery marker)
class MapPoint {
  final String? deliveryId;
  final String? orderNumber;
  final String? status;
  final String? itemCount;
  final String? pointType; // "pickup" or "delivery"
  final String? address;
  final double? lat;
  final double? lng;
  final String? customerName;
  final String? customerPhone;
  final String? receiverName;
  final String? receiverPhone;

  MapPoint({
    this.deliveryId,
    this.orderNumber,
    this.status,
    this.itemCount,
    this.pointType,
    this.address,
    this.lat,
    this.lng,
    this.customerName,
    this.customerPhone,
    this.receiverName,
    this.receiverPhone,
  });

  factory MapPoint.fromJson(Map<String, dynamic> json) => MapPoint(
    deliveryId: json['deliveryId'] as String?,
    orderNumber: json['orderNumber'] as String?,
    status: json['status'] as String?,
    itemCount: json['itemCount'] as String?,
    pointType: json['pointType'] as String?,
    address: json['address'] as String?,
    lat: (json['lat'] as num?)?.toDouble(),
    lng: (json['lng'] as num?)?.toDouble(),
    customerName: json['customerName'] as String?,
    customerPhone: json['customerPhone'] as String?,
    receiverName: json['receiverName'] as String?,
    receiverPhone: json['receiverPhone'] as String?,
  );

  bool get isPickup => pointType == 'pickup';
  bool get isDelivery => pointType == 'delivery';

  /// Display name — pickup uses customerName, delivery uses receiverName
  String get displayName =>
      (isPickup ? customerName : receiverName) ?? 'Unknown';
  String get displayPhone => (isPickup ? customerPhone : receiverPhone) ?? '';
}

/// Full delivery object from the `data` array
class MyMapFullDelivery {
  final String? id;
  final String? orderNumber;
  final String? status;
  final String? title;
  final String? parcelType;
  final String? weight;
  final String? packageDescription;
  final String? itemCount;
  final String? customerName;
  final String? customerPhone;
  final String? pickupAddress;
  final double? pickupLat;
  final double? pickupLng;
  final String? receiverName;
  final String? receiverPhone;
  final String? dropoffAddress;
  final double? dropoffLat;
  final double? dropoffLng;
  final String? trackingUrl;

  MyMapFullDelivery({
    this.id,
    this.orderNumber,
    this.status,
    this.title,
    this.parcelType,
    this.weight,
    this.packageDescription,
    this.itemCount,
    this.customerName,
    this.customerPhone,
    this.pickupAddress,
    this.pickupLat,
    this.pickupLng,
    this.receiverName,
    this.receiverPhone,
    this.dropoffAddress,
    this.dropoffLat,
    this.dropoffLng,
    this.trackingUrl,
  });

  factory MyMapFullDelivery.fromJson(Map<String, dynamic> json) =>
      MyMapFullDelivery(
        id:
            json['_id']?.toString() ??
            json['id']?.toString() ??
            json['deliveryId']?.toString(),
        orderNumber: json['orderNumber'] as String?,
        status: json['status'] as String?,
        title: json['title'] as String?,
        parcelType: json['parcelType'] as String?,
        weight: json['weight'] as String?,
        packageDescription: json['packageDescription'] as String?,
        itemCount: json['itemCount'] as String?,
        customerName: json['customerName'] as String?,
        customerPhone: json['customerPhone'] as String?,
        pickupAddress: json['pickupAddress'] as String?,
        pickupLat:
            (json['pickupLat'] as num?)?.toDouble() ??
            _parseCoord(json, 'pickupCoordinates', 1),
        pickupLng:
            (json['pickupLng'] as num?)?.toDouble() ??
            _parseCoord(json, 'pickupCoordinates', 0),
        receiverName: json['receiverName'] as String?,
        receiverPhone: json['receiverPhone'] as String?,
        dropoffAddress: json['dropoffAddress'] as String?,
        dropoffLat:
            (json['dropoffLat'] as num?)?.toDouble() ??
            _parseCoord(json, 'dropoffCoordinates', 1),
        dropoffLng:
            (json['dropoffLng'] as num?)?.toDouble() ??
            _parseCoord(json, 'dropoffCoordinates', 0),
        trackingUrl: json['trackingUrl'] as String?,
      );

  static double? _parseCoord(Map<String, dynamic> json, String key, int index) {
    final coords = json[key]?['coordinates'];
    if (coords is List && coords.length > index) {
      return (coords[index] as num?)?.toDouble();
    }
    return null;
  }
}
