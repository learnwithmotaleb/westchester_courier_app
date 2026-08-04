/// success : true
/// statusCode : 200
/// message : "Profile fetched successfully"
/// data : {"_id":"6a6d689dc9b7cf6020c97629","authId":"6a6d689dc9b7cf6020c97628","name":"Abdul Motaleb","email":"hello@yopmail.com","isOnline":false,"assignedVehicle":null,"createdAt":"2026-08-01T03:31:41.580Z","updatedAt":"2026-08-04T05:06:08.906Z","__v":0,"address":"123 Main St, White Plains, NY","approvalStatus":"PENDING","dateOfBirth":"1995-05-15T00:00:00.000Z","driverId":"DL-987654","isApproved":false,"isProfileCompleted":true,"locationCoordinates":{"type":"Point","coordinates":[-73.76291,41.03398]},"phoneNumber":"+19145550199","profile_image":"uploads/profile-images/1785819968780-227027.jpeg"}

class ProfileModel {
  ProfileModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      Data? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  ProfileModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Data? _data;
ProfileModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  Data? data,
}) => ProfileModel(  success: success ?? _success,
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

/// _id : "6a6d689dc9b7cf6020c97629"
/// authId : "6a6d689dc9b7cf6020c97628"
/// name : "Abdul Motaleb"
/// email : "hello@yopmail.com"
/// isOnline : false
/// assignedVehicle : null
/// createdAt : "2026-08-01T03:31:41.580Z"
/// updatedAt : "2026-08-04T05:06:08.906Z"
/// __v : 0
/// address : "123 Main St, White Plains, NY"
/// approvalStatus : "PENDING"
/// dateOfBirth : "1995-05-15T00:00:00.000Z"
/// driverId : "DL-987654"
/// isApproved : false
/// isProfileCompleted : true
/// locationCoordinates : {"type":"Point","coordinates":[-73.76291,41.03398]}
/// phoneNumber : "+19145550199"
/// profile_image : "uploads/profile-images/1785819968780-227027.jpeg"

class Data {
  Data({
      String? id, 
      String? authId, 
      String? name, 
      String? email, 
      bool? isOnline, 
      dynamic assignedVehicle, 
      String? createdAt, 
      String? updatedAt, 
      num? v, 
      String? address, 
      String? approvalStatus, 
      String? dateOfBirth, 
      String? driverId, 
      bool? isApproved, 
      bool? isProfileCompleted, 
      LocationCoordinates? locationCoordinates, 
      String? phoneNumber, 
      String? profileImage,}){
    _id = id;
    _authId = authId;
    _name = name;
    _email = email;
    _isOnline = isOnline;
    _assignedVehicle = assignedVehicle;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _address = address;
    _approvalStatus = approvalStatus;
    _dateOfBirth = dateOfBirth;
    _driverId = driverId;
    _isApproved = isApproved;
    _isProfileCompleted = isProfileCompleted;
    _locationCoordinates = locationCoordinates;
    _phoneNumber = phoneNumber;
    _profileImage = profileImage;
}

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _authId = json['authId'];
    _name = json['name'];
    _email = json['email'];
    _isOnline = json['isOnline'];
    _assignedVehicle = json['assignedVehicle'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _address = json['address'];
    _approvalStatus = json['approvalStatus'];
    _dateOfBirth = json['dateOfBirth'];
    _driverId = json['driverId'];
    _isApproved = json['isApproved'];
    _isProfileCompleted = json['isProfileCompleted'];
    _locationCoordinates = json['locationCoordinates'] != null ? LocationCoordinates.fromJson(json['locationCoordinates']) : null;
    _phoneNumber = json['phoneNumber'];
    _profileImage = json['profile_image'];
  }
  String? _id;
  String? _authId;
  String? _name;
  String? _email;
  bool? _isOnline;
  dynamic _assignedVehicle;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  String? _address;
  String? _approvalStatus;
  String? _dateOfBirth;
  String? _driverId;
  bool? _isApproved;
  bool? _isProfileCompleted;
  LocationCoordinates? _locationCoordinates;
  String? _phoneNumber;
  String? _profileImage;
Data copyWith({  String? id,
  String? authId,
  String? name,
  String? email,
  bool? isOnline,
  dynamic assignedVehicle,
  String? createdAt,
  String? updatedAt,
  num? v,
  String? address,
  String? approvalStatus,
  String? dateOfBirth,
  String? driverId,
  bool? isApproved,
  bool? isProfileCompleted,
  LocationCoordinates? locationCoordinates,
  String? phoneNumber,
  String? profileImage,
}) => Data(  id: id ?? _id,
  authId: authId ?? _authId,
  name: name ?? _name,
  email: email ?? _email,
  isOnline: isOnline ?? _isOnline,
  assignedVehicle: assignedVehicle ?? _assignedVehicle,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
  address: address ?? _address,
  approvalStatus: approvalStatus ?? _approvalStatus,
  dateOfBirth: dateOfBirth ?? _dateOfBirth,
  driverId: driverId ?? _driverId,
  isApproved: isApproved ?? _isApproved,
  isProfileCompleted: isProfileCompleted ?? _isProfileCompleted,
  locationCoordinates: locationCoordinates ?? _locationCoordinates,
  phoneNumber: phoneNumber ?? _phoneNumber,
  profileImage: profileImage ?? _profileImage,
);
  String? get id => _id;
  String? get authId => _authId;
  String? get name => _name;
  String? get email => _email;
  bool? get isOnline => _isOnline;
  dynamic get assignedVehicle => _assignedVehicle;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;
  String? get address => _address;
  String? get approvalStatus => _approvalStatus;
  String? get dateOfBirth => _dateOfBirth;
  String? get driverId => _driverId;
  bool? get isApproved => _isApproved;
  bool? get isProfileCompleted => _isProfileCompleted;
  LocationCoordinates? get locationCoordinates => _locationCoordinates;
  String? get phoneNumber => _phoneNumber;
  String? get profileImage => _profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['authId'] = _authId;
    map['name'] = _name;
    map['email'] = _email;
    map['isOnline'] = _isOnline;
    map['assignedVehicle'] = _assignedVehicle;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    map['address'] = _address;
    map['approvalStatus'] = _approvalStatus;
    map['dateOfBirth'] = _dateOfBirth;
    map['driverId'] = _driverId;
    map['isApproved'] = _isApproved;
    map['isProfileCompleted'] = _isProfileCompleted;
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