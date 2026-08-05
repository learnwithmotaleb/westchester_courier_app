/// success : true
/// statusCode : 200
/// message : "Your deliveries fetched successfully"
/// meta : {"page":1,"limit":20,"total":1,"totalPages":1}
/// data : [{"_id":"6a71ec4d1988ecda1c263447","orderNumber":"WC-62U9YL","status":"PICKED_UP","customerName":"Jane Smith","customerPhone":"+19145550123","pickupAddress":"100 Main St, White Plains, NY","preferrablePickupTime":"10:00 AM - 12:00 PM","pickupDate":"2026-08-10T10:00:00.000Z","receiverName":"Bob Johnson","receiverPhone":"+19145550999","dropoffAddress":"200 Mamaroneck Ave, White Plains, NY","preferrableDeliveryDate":"2026-08-10T14:00:00.000Z","createdAt":"2026-08-04T13:42:37.886Z","trackingUrl":"http://localhost:3000/track/31611c803a08083a67f47feada868aa6"}]

class DeliveriesModel {
  DeliveriesModel({
    bool? success,
    num? statusCode,
    String? message,
    Meta? meta,
    List<Data>? data,
  }) {
    _success = success;
    _statusCode = statusCode;
    _message = message;
    _meta = meta;
    _data = data;
  }

  DeliveriesModel.fromJson(dynamic json) {
    _success = json['success'];
    _statusCode = json['statusCode'];
    _message = json['message'];
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _success;
  num? _statusCode;
  String? _message;
  Meta? _meta;
  List<Data>? _data;
  DeliveriesModel copyWith({
    bool? success,
    num? statusCode,
    String? message,
    Meta? meta,
    List<Data>? data,
  }) => DeliveriesModel(
    success: success ?? _success,
    statusCode: statusCode ?? _statusCode,
    message: message ?? _message,
    meta: meta ?? _meta,
    data: data ?? _data,
  );
  bool? get success => _success;
  num? get statusCode => _statusCode;
  String? get message => _message;
  Meta? get meta => _meta;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['statusCode'] = _statusCode;
    map['message'] = _message;
    if (_meta != null) {
      map['meta'] = _meta?.toJson();
    }
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// _id : "6a71ec4d1988ecda1c263447"
/// orderNumber : "WC-62U9YL"
/// status : "PICKED_UP"
/// customerName : "Jane Smith"
/// customerPhone : "+19145550123"
/// pickupAddress : "100 Main St, White Plains, NY"
/// preferrablePickupTime : "10:00 AM - 12:00 PM"
/// pickupDate : "2026-08-10T10:00:00.000Z"
/// receiverName : "Bob Johnson"
/// receiverPhone : "+19145550999"
/// dropoffAddress : "200 Mamaroneck Ave, White Plains, NY"
/// preferrableDeliveryDate : "2026-08-10T14:00:00.000Z"
/// createdAt : "2026-08-04T13:42:37.886Z"
/// trackingUrl : "http://localhost:3000/track/31611c803a08083a67f47feada868aa6"

class Data {
  Data({
    String? id,
    String? orderNumber,
    String? status,
    String? customerName,
    String? customerPhone,
    String? pickupAddress,
    String? preferrablePickupTime,
    String? pickupDate,
    String? receiverName,
    String? receiverPhone,
    String? dropoffAddress,
    String? preferrableDeliveryDate,
    String? createdAt,
    String? trackingUrl,
  }) {
    _id = id;
    _orderNumber = orderNumber;
    _status = status;
    _customerName = customerName;
    _customerPhone = customerPhone;
    _pickupAddress = pickupAddress;
    _preferrablePickupTime = preferrablePickupTime;
    _pickupDate = pickupDate;
    _receiverName = receiverName;
    _receiverPhone = receiverPhone;
    _dropoffAddress = dropoffAddress;
    _preferrableDeliveryDate = preferrableDeliveryDate;
    _createdAt = createdAt;
    _trackingUrl = trackingUrl;
  }

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _orderNumber = json['orderNumber'];
    _status = json['status'];
    _customerName = json['customerName'];
    _customerPhone = json['customerPhone'];
    _pickupAddress = json['pickupAddress'];
    _preferrablePickupTime = json['preferrablePickupTime'];
    _pickupDate = json['pickupDate'];
    _receiverName = json['receiverName'];
    _receiverPhone = json['receiverPhone'];
    _dropoffAddress = json['dropoffAddress'];
    _preferrableDeliveryDate = json['preferrableDeliveryDate'];
    _createdAt = json['createdAt'];
    _trackingUrl = json['trackingUrl'];
  }
  String? _id;
  String? _orderNumber;
  String? _status;
  String? _customerName;
  String? _customerPhone;
  String? _pickupAddress;
  String? _preferrablePickupTime;
  String? _pickupDate;
  String? _receiverName;
  String? _receiverPhone;
  String? _dropoffAddress;
  String? _preferrableDeliveryDate;
  String? _createdAt;
  String? _trackingUrl;
  Data copyWith({
    String? id,
    String? orderNumber,
    String? status,
    String? customerName,
    String? customerPhone,
    String? pickupAddress,
    String? preferrablePickupTime,
    String? pickupDate,
    String? receiverName,
    String? receiverPhone,
    String? dropoffAddress,
    String? preferrableDeliveryDate,
    String? createdAt,
    String? trackingUrl,
  }) => Data(
    id: id ?? _id,
    orderNumber: orderNumber ?? _orderNumber,
    status: status ?? _status,
    customerName: customerName ?? _customerName,
    customerPhone: customerPhone ?? _customerPhone,
    pickupAddress: pickupAddress ?? _pickupAddress,
    preferrablePickupTime: preferrablePickupTime ?? _preferrablePickupTime,
    pickupDate: pickupDate ?? _pickupDate,
    receiverName: receiverName ?? _receiverName,
    receiverPhone: receiverPhone ?? _receiverPhone,
    dropoffAddress: dropoffAddress ?? _dropoffAddress,
    preferrableDeliveryDate:
        preferrableDeliveryDate ?? _preferrableDeliveryDate,
    createdAt: createdAt ?? _createdAt,
    trackingUrl: trackingUrl ?? _trackingUrl,
  );
  String? get id => _id;
  String? get orderNumber => _orderNumber;
  String? get status => _status;
  String? get customerName => _customerName;
  String? get customerPhone => _customerPhone;
  String? get pickupAddress => _pickupAddress;
  String? get preferrablePickupTime => _preferrablePickupTime;
  String? get pickupDate => _pickupDate;
  String? get receiverName => _receiverName;
  String? get receiverPhone => _receiverPhone;
  String? get dropoffAddress => _dropoffAddress;
  String? get preferrableDeliveryDate => _preferrableDeliveryDate;
  String? get createdAt => _createdAt;
  String? get trackingUrl => _trackingUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['orderNumber'] = _orderNumber;
    map['status'] = _status;
    map['customerName'] = _customerName;
    map['customerPhone'] = _customerPhone;
    map['pickupAddress'] = _pickupAddress;
    map['preferrablePickupTime'] = _preferrablePickupTime;
    map['pickupDate'] = _pickupDate;
    map['receiverName'] = _receiverName;
    map['receiverPhone'] = _receiverPhone;
    map['dropoffAddress'] = _dropoffAddress;
    map['preferrableDeliveryDate'] = _preferrableDeliveryDate;
    map['createdAt'] = _createdAt;
    map['trackingUrl'] = _trackingUrl;
    return map;
  }
}

/// page : 1
/// limit : 20
/// total : 1
/// totalPages : 1

class Meta {
  Meta({num? page, num? limit, num? total, num? totalPages}) {
    _page = page;
    _limit = limit;
    _total = total;
    _totalPages = totalPages;
  }

  Meta.fromJson(dynamic json) {
    _page = json['page'];
    _limit = json['limit'];
    _total = json['total'];
    _totalPages = json['totalPages'];
  }
  num? _page;
  num? _limit;
  num? _total;
  num? _totalPages;
  Meta copyWith({num? page, num? limit, num? total, num? totalPages}) => Meta(
    page: page ?? _page,
    limit: limit ?? _limit,
    total: total ?? _total,
    totalPages: totalPages ?? _totalPages,
  );
  num? get page => _page;
  num? get limit => _limit;
  num? get total => _total;
  num? get totalPages => _totalPages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = _page;
    map['limit'] = _limit;
    map['total'] = _total;
    map['totalPages'] = _totalPages;
    return map;
  }
}
