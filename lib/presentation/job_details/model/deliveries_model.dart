/// success : true
/// statusCode : 200
/// message : "Delivery fetched successfully"
/// data : {"_id":"6a71ec4d1988ecda1c263447","orderNumber":"WC-62U9YL","trackingToken":"31611c803a08083a67f47feada868aa6","title":"Document Package","parcelType":"Box","weight":"5 lbs","customerName":"Jane Smith","customerEmail":"jane.smith@example.com","customerPhone":"+19145550123","pickupContact":"Building Security / Gate 2","pickupAddress":"100 Main St, White Plains, NY","pickupDate":"2026-08-10T10:00:00.000Z","preferrablePickupTime":"10:00 AM - 12:00 PM","pickupNote":"Ring doorbell twice","pickupCoordinates":{"type":"Point","coordinates":[-73.76291,41.03398]},"receiverName":"Bob Johnson","receiverPhone":"+19145550999","dropoffAddress":"200 Mamaroneck Ave, White Plains, NY","preferrableDeliveryDate":"2026-08-10T14:00:00.000Z","deliveryNote":"Leave at front reception","dropoffCoordinates":{"type":"Point","coordinates":[-73.765,41.036]},"packageDescription":"Handle with care","status":"IN_TRANSIT","assignedDriver":{"_id":"6a6d689dc9b7cf6020c97629","name":"Abdul Motaleb","email":"hello@yopmail.com","locationCoordinates":{"type":"Point","coordinates":[-73.76291,41.03398]},"phoneNumber":"+19145550199","profile_image":"uploads/profile-images/1785835321530-458334.png"},"createdBy":"6a5b04cda7588492f9aa4cce","createdAt":"2026-08-04T13:42:37.886Z","updatedAt":"2026-08-05T04:36:18.690Z","__v":0,"trackingUrl":"http://localhost:3000/track/31611c803a08083a67f47feada868aa6"}

class DeliveriesModel {
  DeliveriesModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      Data? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  DeliveriesModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Data? _data;
DeliveriesModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  Data? data,
}) => DeliveriesModel(  success: success ?? _success,
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
/// trackingToken : "31611c803a08083a67f47feada868aa6"
/// title : "Document Package"
/// parcelType : "Box"
/// weight : "5 lbs"
/// customerName : "Jane Smith"
/// customerEmail : "jane.smith@example.com"
/// customerPhone : "+19145550123"
/// pickupContact : "Building Security / Gate 2"
/// pickupAddress : "100 Main St, White Plains, NY"
/// pickupDate : "2026-08-10T10:00:00.000Z"
/// preferrablePickupTime : "10:00 AM - 12:00 PM"
/// pickupNote : "Ring doorbell twice"
/// pickupCoordinates : {"type":"Point","coordinates":[-73.76291,41.03398]}
/// receiverName : "Bob Johnson"
/// receiverPhone : "+19145550999"
/// dropoffAddress : "200 Mamaroneck Ave, White Plains, NY"
/// preferrableDeliveryDate : "2026-08-10T14:00:00.000Z"
/// deliveryNote : "Leave at front reception"
/// dropoffCoordinates : {"type":"Point","coordinates":[-73.765,41.036]}
/// packageDescription : "Handle with care"
/// status : "IN_TRANSIT"
/// assignedDriver : {"_id":"6a6d689dc9b7cf6020c97629","name":"Abdul Motaleb","email":"hello@yopmail.com","locationCoordinates":{"type":"Point","coordinates":[-73.76291,41.03398]},"phoneNumber":"+19145550199","profile_image":"uploads/profile-images/1785835321530-458334.png"}
/// createdBy : "6a5b04cda7588492f9aa4cce"
/// createdAt : "2026-08-04T13:42:37.886Z"
/// updatedAt : "2026-08-05T04:36:18.690Z"
/// __v : 0
/// trackingUrl : "http://localhost:3000/track/31611c803a08083a67f47feada868aa6"

class Data {
  Data({
      String? id, 
      String? orderNumber, 
      String? trackingToken, 
      String? title, 
      String? parcelType, 
      String? weight, 
      String? customerName, 
      String? customerEmail, 
      String? customerPhone, 
      String? pickupContact, 
      String? pickupAddress, 
      String? pickupDate, 
      String? preferrablePickupTime, 
      String? pickupNote, 
      PickupCoordinates? pickupCoordinates, 
      String? receiverName, 
      String? receiverPhone, 
      String? dropoffAddress, 
      String? preferrableDeliveryDate, 
      String? deliveryNote, 
      DropoffCoordinates? dropoffCoordinates, 
      String? packageDescription, 
      String? status, 
      AssignedDriver? assignedDriver, 
      String? createdBy, 
      String? createdAt, 
      String? updatedAt, 
      num? v, 
      String? trackingUrl,}){
    _id = id;
    _orderNumber = orderNumber;
    _trackingToken = trackingToken;
    _title = title;
    _parcelType = parcelType;
    _weight = weight;
    _customerName = customerName;
    _customerEmail = customerEmail;
    _customerPhone = customerPhone;
    _pickupContact = pickupContact;
    _pickupAddress = pickupAddress;
    _pickupDate = pickupDate;
    _preferrablePickupTime = preferrablePickupTime;
    _pickupNote = pickupNote;
    _pickupCoordinates = pickupCoordinates;
    _receiverName = receiverName;
    _receiverPhone = receiverPhone;
    _dropoffAddress = dropoffAddress;
    _preferrableDeliveryDate = preferrableDeliveryDate;
    _deliveryNote = deliveryNote;
    _dropoffCoordinates = dropoffCoordinates;
    _packageDescription = packageDescription;
    _status = status;
    _assignedDriver = assignedDriver;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _trackingUrl = trackingUrl;
}

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _orderNumber = json['orderNumber'];
    _trackingToken = json['trackingToken'];
    _title = json['title'];
    _parcelType = json['parcelType'];
    _weight = json['weight'];
    _customerName = json['customerName'];
    _customerEmail = json['customerEmail'];
    _customerPhone = json['customerPhone'];
    _pickupContact = json['pickupContact'];
    _pickupAddress = json['pickupAddress'];
    _pickupDate = json['pickupDate'];
    _preferrablePickupTime = json['preferrablePickupTime'];
    _pickupNote = json['pickupNote'];
    _pickupCoordinates = json['pickupCoordinates'] != null ? PickupCoordinates.fromJson(json['pickupCoordinates']) : null;
    _receiverName = json['receiverName'];
    _receiverPhone = json['receiverPhone'];
    _dropoffAddress = json['dropoffAddress'];
    _preferrableDeliveryDate = json['preferrableDeliveryDate'];
    _deliveryNote = json['deliveryNote'];
    _dropoffCoordinates = json['dropoffCoordinates'] != null ? DropoffCoordinates.fromJson(json['dropoffCoordinates']) : null;
    _packageDescription = json['packageDescription'];
    _status = json['status'];
    _assignedDriver = json['assignedDriver'] != null ? AssignedDriver.fromJson(json['assignedDriver']) : null;
    _createdBy = json['createdBy'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _trackingUrl = json['trackingUrl'];
  }
  String? _id;
  String? _orderNumber;
  String? _trackingToken;
  String? _title;
  String? _parcelType;
  String? _weight;
  String? _customerName;
  String? _customerEmail;
  String? _customerPhone;
  String? _pickupContact;
  String? _pickupAddress;
  String? _pickupDate;
  String? _preferrablePickupTime;
  String? _pickupNote;
  PickupCoordinates? _pickupCoordinates;
  String? _receiverName;
  String? _receiverPhone;
  String? _dropoffAddress;
  String? _preferrableDeliveryDate;
  String? _deliveryNote;
  DropoffCoordinates? _dropoffCoordinates;
  String? _packageDescription;
  String? _status;
  AssignedDriver? _assignedDriver;
  String? _createdBy;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  String? _trackingUrl;
Data copyWith({  String? id,
  String? orderNumber,
  String? trackingToken,
  String? title,
  String? parcelType,
  String? weight,
  String? customerName,
  String? customerEmail,
  String? customerPhone,
  String? pickupContact,
  String? pickupAddress,
  String? pickupDate,
  String? preferrablePickupTime,
  String? pickupNote,
  PickupCoordinates? pickupCoordinates,
  String? receiverName,
  String? receiverPhone,
  String? dropoffAddress,
  String? preferrableDeliveryDate,
  String? deliveryNote,
  DropoffCoordinates? dropoffCoordinates,
  String? packageDescription,
  String? status,
  AssignedDriver? assignedDriver,
  String? createdBy,
  String? createdAt,
  String? updatedAt,
  num? v,
  String? trackingUrl,
}) => Data(  id: id ?? _id,
  orderNumber: orderNumber ?? _orderNumber,
  trackingToken: trackingToken ?? _trackingToken,
  title: title ?? _title,
  parcelType: parcelType ?? _parcelType,
  weight: weight ?? _weight,
  customerName: customerName ?? _customerName,
  customerEmail: customerEmail ?? _customerEmail,
  customerPhone: customerPhone ?? _customerPhone,
  pickupContact: pickupContact ?? _pickupContact,
  pickupAddress: pickupAddress ?? _pickupAddress,
  pickupDate: pickupDate ?? _pickupDate,
  preferrablePickupTime: preferrablePickupTime ?? _preferrablePickupTime,
  pickupNote: pickupNote ?? _pickupNote,
  pickupCoordinates: pickupCoordinates ?? _pickupCoordinates,
  receiverName: receiverName ?? _receiverName,
  receiverPhone: receiverPhone ?? _receiverPhone,
  dropoffAddress: dropoffAddress ?? _dropoffAddress,
  preferrableDeliveryDate: preferrableDeliveryDate ?? _preferrableDeliveryDate,
  deliveryNote: deliveryNote ?? _deliveryNote,
  dropoffCoordinates: dropoffCoordinates ?? _dropoffCoordinates,
  packageDescription: packageDescription ?? _packageDescription,
  status: status ?? _status,
  assignedDriver: assignedDriver ?? _assignedDriver,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
  trackingUrl: trackingUrl ?? _trackingUrl,
);
  String? get id => _id;
  String? get orderNumber => _orderNumber;
  String? get trackingToken => _trackingToken;
  String? get title => _title;
  String? get parcelType => _parcelType;
  String? get weight => _weight;
  String? get customerName => _customerName;
  String? get customerEmail => _customerEmail;
  String? get customerPhone => _customerPhone;
  String? get pickupContact => _pickupContact;
  String? get pickupAddress => _pickupAddress;
  String? get pickupDate => _pickupDate;
  String? get preferrablePickupTime => _preferrablePickupTime;
  String? get pickupNote => _pickupNote;
  PickupCoordinates? get pickupCoordinates => _pickupCoordinates;
  String? get receiverName => _receiverName;
  String? get receiverPhone => _receiverPhone;
  String? get dropoffAddress => _dropoffAddress;
  String? get preferrableDeliveryDate => _preferrableDeliveryDate;
  String? get deliveryNote => _deliveryNote;
  DropoffCoordinates? get dropoffCoordinates => _dropoffCoordinates;
  String? get packageDescription => _packageDescription;
  String? get status => _status;
  AssignedDriver? get assignedDriver => _assignedDriver;
  String? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;
  String? get trackingUrl => _trackingUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['orderNumber'] = _orderNumber;
    map['trackingToken'] = _trackingToken;
    map['title'] = _title;
    map['parcelType'] = _parcelType;
    map['weight'] = _weight;
    map['customerName'] = _customerName;
    map['customerEmail'] = _customerEmail;
    map['customerPhone'] = _customerPhone;
    map['pickupContact'] = _pickupContact;
    map['pickupAddress'] = _pickupAddress;
    map['pickupDate'] = _pickupDate;
    map['preferrablePickupTime'] = _preferrablePickupTime;
    map['pickupNote'] = _pickupNote;
    if (_pickupCoordinates != null) {
      map['pickupCoordinates'] = _pickupCoordinates?.toJson();
    }
    map['receiverName'] = _receiverName;
    map['receiverPhone'] = _receiverPhone;
    map['dropoffAddress'] = _dropoffAddress;
    map['preferrableDeliveryDate'] = _preferrableDeliveryDate;
    map['deliveryNote'] = _deliveryNote;
    if (_dropoffCoordinates != null) {
      map['dropoffCoordinates'] = _dropoffCoordinates?.toJson();
    }
    map['packageDescription'] = _packageDescription;
    map['status'] = _status;
    if (_assignedDriver != null) {
      map['assignedDriver'] = _assignedDriver?.toJson();
    }
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    map['trackingUrl'] = _trackingUrl;
    return map;
  }

}

/// _id : "6a6d689dc9b7cf6020c97629"
/// name : "Abdul Motaleb"
/// email : "hello@yopmail.com"
/// locationCoordinates : {"type":"Point","coordinates":[-73.76291,41.03398]}
/// phoneNumber : "+19145550199"
/// profile_image : "uploads/profile-images/1785835321530-458334.png"

class AssignedDriver {
  AssignedDriver({
      String? id, 
      String? name, 
      String? email, 
      LocationCoordinates? locationCoordinates, 
      String? phoneNumber, 
      String? profileImage,}){
    _id = id;
    _name = name;
    _email = email;
    _locationCoordinates = locationCoordinates;
    _phoneNumber = phoneNumber;
    _profileImage = profileImage;
}

  AssignedDriver.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _email = json['email'];
    _locationCoordinates = json['locationCoordinates'] != null ? LocationCoordinates.fromJson(json['locationCoordinates']) : null;
    _phoneNumber = json['phoneNumber'];
    _profileImage = json['profile_image'];
  }
  String? _id;
  String? _name;
  String? _email;
  LocationCoordinates? _locationCoordinates;
  String? _phoneNumber;
  String? _profileImage;
AssignedDriver copyWith({  String? id,
  String? name,
  String? email,
  LocationCoordinates? locationCoordinates,
  String? phoneNumber,
  String? profileImage,
}) => AssignedDriver(  id: id ?? _id,
  name: name ?? _name,
  email: email ?? _email,
  locationCoordinates: locationCoordinates ?? _locationCoordinates,
  phoneNumber: phoneNumber ?? _phoneNumber,
  profileImage: profileImage ?? _profileImage,
);
  String? get id => _id;
  String? get name => _name;
  String? get email => _email;
  LocationCoordinates? get locationCoordinates => _locationCoordinates;
  String? get phoneNumber => _phoneNumber;
  String? get profileImage => _profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    if (_locationCoordinates != null) {
      map['locationCoordinates'] = _locationCoordinates?.toJson();
    }
    map['phoneNumber'] = _phoneNumber;
    map['profile_image'] = _profileImage;
    return map;
  }

}

/// type : "Point"
/// coordinates : [-73.76291,41.03398]

class LocationCoordinates {
  LocationCoordinates({
      String? type, 
      List<num>? coordinates,}){
    _type = type;
    _coordinates = coordinates;
}

  LocationCoordinates.fromJson(dynamic json) {
    _type = json['type'];
    _coordinates = json['coordinates'] != null ? json['coordinates'].cast<num>() : [];
  }
  String? _type;
  List<num>? _coordinates;
LocationCoordinates copyWith({  String? type,
  List<num>? coordinates,
}) => LocationCoordinates(  type: type ?? _type,
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