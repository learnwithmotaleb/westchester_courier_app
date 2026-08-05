/// success : true
/// statusCode : 200
/// message : "Delivery map details fetched successfully"
/// data : {"_id":"6a71ec4d1988ecda1c263447","orderNumber":"WC-62U9YL","status":"OUT_FOR_DELIVERY","pickupAddress":"100 Main St, White Plains, NY","pickupCoordinates":{"type":"Point","coordinates":[-73.76291,41.03398]},"dropoffAddress":"200 Mamaroneck Ave, White Plains, NY","dropoffCoordinates":{"type":"Point","coordinates":[-73.765,41.036]},"driverCurrentLocation":{"type":"Point","coordinates":[-73.76291,41.03398]},"trackingToken":"31611c803a08083a67f47feada868aa6","trackingUrl":"http://localhost:3000/track/31611c803a08083a67f47feada868aa6"}

class OpenMapModel {
  OpenMapModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      Data? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  OpenMapModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Data? _data;
OpenMapModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  Data? data,
}) => OpenMapModel(  success: success ?? _success,
  statusCode: statusCode ?? _statusCode,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['statusCode'] = _statusCode;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// _id : "6a71ec4d1988ecda1c263447"
/// orderNumber : "WC-62U9YL"
/// status : "OUT_FOR_DELIVERY"
/// pickupAddress : "100 Main St, White Plains, NY"
/// pickupCoordinates : {"type":"Point","coordinates":[-73.76291,41.03398]}
/// dropoffAddress : "200 Mamaroneck Ave, White Plains, NY"
/// dropoffCoordinates : {"type":"Point","coordinates":[-73.765,41.036]}
/// driverCurrentLocation : {"type":"Point","coordinates":[-73.76291,41.03398]}
/// trackingToken : "31611c803a08083a67f47feada868aa6"
/// trackingUrl : "http://localhost:3000/track/31611c803a08083a67f47feada868aa6"

class Data {
  Data({
      String? id, 
      String? orderNumber, 
      String? status, 
      String? pickupAddress, 
      PickupCoordinates? pickupCoordinates, 
      String? dropoffAddress, 
      DropoffCoordinates? dropoffCoordinates, 
      DriverCurrentLocation? driverCurrentLocation, 
      String? trackingToken, 
      String? trackingUrl,}){
    _id = id;
    _orderNumber = orderNumber;
    _status = status;
    _pickupAddress = pickupAddress;
    _pickupCoordinates = pickupCoordinates;
    _dropoffAddress = dropoffAddress;
    _dropoffCoordinates = dropoffCoordinates;
    _driverCurrentLocation = driverCurrentLocation;
    _trackingToken = trackingToken;
    _trackingUrl = trackingUrl;
}

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _orderNumber = json['orderNumber'];
    _status = json['status'];
    _pickupAddress = json['pickupAddress'];
    _pickupCoordinates = json['pickupCoordinates'] != null ? PickupCoordinates.fromJson(json['pickupCoordinates']) : null;
    _dropoffAddress = json['dropoffAddress'];
    _dropoffCoordinates = json['dropoffCoordinates'] != null ? DropoffCoordinates.fromJson(json['dropoffCoordinates']) : null;
    _driverCurrentLocation = json['driverCurrentLocation'] != null ? DriverCurrentLocation.fromJson(json['driverCurrentLocation']) : null;
    _trackingToken = json['trackingToken'];
    _trackingUrl = json['trackingUrl'];
  }
  String? _id;
  String? _orderNumber;
  String? _status;
  String? _pickupAddress;
  PickupCoordinates? _pickupCoordinates;
  String? _dropoffAddress;
  DropoffCoordinates? _dropoffCoordinates;
  DriverCurrentLocation? _driverCurrentLocation;
  String? _trackingToken;
  String? _trackingUrl;
Data copyWith({  String? id,
  String? orderNumber,
  String? status,
  String? pickupAddress,
  PickupCoordinates? pickupCoordinates,
  String? dropoffAddress,
  DropoffCoordinates? dropoffCoordinates,
  DriverCurrentLocation? driverCurrentLocation,
  String? trackingToken,
  String? trackingUrl,
}) => Data(  id: id ?? _id,
  orderNumber: orderNumber ?? _orderNumber,
  status: status ?? _status,
  pickupAddress: pickupAddress ?? _pickupAddress,
  pickupCoordinates: pickupCoordinates ?? _pickupCoordinates,
  dropoffAddress: dropoffAddress ?? _dropoffAddress,
  dropoffCoordinates: dropoffCoordinates ?? _dropoffCoordinates,
  driverCurrentLocation: driverCurrentLocation ?? _driverCurrentLocation,
  trackingToken: trackingToken ?? _trackingToken,
  trackingUrl: trackingUrl ?? _trackingUrl,
);
  String? get id => _id;
  String? get orderNumber => _orderNumber;
  String? get status => _status;
  String? get pickupAddress => _pickupAddress;
  PickupCoordinates? get pickupCoordinates => _pickupCoordinates;
  String? get dropoffAddress => _dropoffAddress;
  DropoffCoordinates? get dropoffCoordinates => _dropoffCoordinates;
  DriverCurrentLocation? get driverCurrentLocation => _driverCurrentLocation;
  String? get trackingToken => _trackingToken;
  String? get trackingUrl => _trackingUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['orderNumber'] = _orderNumber;
    map['status'] = _status;
    map['pickupAddress'] = _pickupAddress;
    if (_pickupCoordinates != null) {
      map['pickupCoordinates'] = _pickupCoordinates?.toJson();
    }
    map['dropoffAddress'] = _dropoffAddress;
    if (_dropoffCoordinates != null) {
      map['dropoffCoordinates'] = _dropoffCoordinates?.toJson();
    }
    if (_driverCurrentLocation != null) {
      map['driverCurrentLocation'] = _driverCurrentLocation?.toJson();
    }
    map['trackingToken'] = _trackingToken;
    map['trackingUrl'] = _trackingUrl;
    return map;
  }

}

/// type : "Point"
/// coordinates : [-73.76291,41.03398]

class DriverCurrentLocation {
  DriverCurrentLocation({
      String? type, 
      List<num>? coordinates,}){
    _type = type;
    _coordinates = coordinates;
}

  DriverCurrentLocation.fromJson(dynamic json) {
    _type = json['type'];
    _coordinates = json['coordinates'] != null ? json['coordinates'].cast<num>() : [];
  }
  String? _type;
  List<num>? _coordinates;
DriverCurrentLocation copyWith({  String? type,
  List<num>? coordinates,
}) => DriverCurrentLocation(  type: type ?? _type,
  coordinates: coordinates ?? _coordinates,
);
  String? get type => _type;
  List<num>? get coordinates => _coordinates;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['coordinates'] = _coordinates;
    return map;
  }

}

/// type : "Point"
/// coordinates : [-73.765,41.036]

class DropoffCoordinates {
  DropoffCoordinates({
      String? type, 
      List<num>? coordinates,}){
    _type = type;
    _coordinates = coordinates;
}

  DropoffCoordinates.fromJson(dynamic json) {
    _type = json['type'];
    _coordinates = json['coordinates'] != null ? json['coordinates'].cast<num>() : [];
  }
  String? _type;
  List<num>? _coordinates;
DropoffCoordinates copyWith({  String? type,
  List<num>? coordinates,
}) => DropoffCoordinates(  type: type ?? _type,
  coordinates: coordinates ?? _coordinates,
);
  String? get type => _type;
  List<num>? get coordinates => _coordinates;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['coordinates'] = _coordinates;
    return map;
  }

}

/// type : "Point"
/// coordinates : [-73.76291,41.03398]

class PickupCoordinates {
  PickupCoordinates({
      String? type, 
      List<num>? coordinates,}){
    _type = type;
    _coordinates = coordinates;
}

  PickupCoordinates.fromJson(dynamic json) {
    _type = json['type'];
    _coordinates = json['coordinates'] != null ? json['coordinates'].cast<num>() : [];
  }
  String? _type;
  List<num>? _coordinates;
PickupCoordinates copyWith({  String? type,
  List<num>? coordinates,
}) => PickupCoordinates(  type: type ?? _type,
  coordinates: coordinates ?? _coordinates,
);
  String? get type => _type;
  List<num>? get coordinates => _coordinates;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['coordinates'] = _coordinates;
    return map;
  }

}