class PrivacyPolicyModel {
  PrivacyPolicyModel({
    bool? success,
    num? statusCode,
    String? message,
    PrivacyData? data,
  }) {
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _data = data;
  }

  PrivacyPolicyModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _data = json['data'] != null ? PrivacyData.fromJson(json['data']) : null;
  }

  bool? _success;
  num? _statusCode;
  String? _message;
  PrivacyData? _data;

  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;
  PrivacyData? get data => _data;

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

class PrivacyData {
  PrivacyData({
    String? id,
    String? description,
    String? createdAt,
    String? updatedAt,
    num? v,
  }) {
    _id = id;
    _description = description;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
  }

  PrivacyData.fromJson(dynamic json) {
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
