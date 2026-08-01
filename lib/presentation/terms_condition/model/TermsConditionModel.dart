/// success : true
/// statusCode : 200
/// message : "Successful"
/// data : {"_id":"6a51fcba06a17e10ef361369","description":"By using Westchester Courier, you agree to these terms...","createdAt":"2026-07-11T08:20:10.250Z","updatedAt":"2026-07-11T08:20:23.156Z","__v":0}

class TermsConditionModel {
  TermsConditionModel({
      bool? success, 
      num? statusCode, 
      String? message, 
      Data? data,}){
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  TermsConditionModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Data? _data;
TermsConditionModel copyWith({  bool? success,
  num? statusCode,
  String? message,
  Data? data,
}) => TermsConditionModel(  success: success ?? _success,
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

/// _id : "6a51fcba06a17e10ef361369"
/// description : "By using Westchester Courier, you agree to these terms..."
/// createdAt : "2026-07-11T08:20:10.250Z"
/// updatedAt : "2026-07-11T08:20:23.156Z"
/// __v : 0

class Data {
  Data({
      String? id, 
      String? description, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _description = description;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _description = json['description'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _description;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
Data copyWith({  String? id,
  String? description,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => Data(  id: id ?? _id,
  description: description ?? _description,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get description => _description;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['description'] = _description;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}