class RequestModel {
  bool? success;
  int? statusCode;
  String? message;
  Meta? meta;
  List<Data>? data;

  RequestModel(
      {this.success, this.statusCode, this.message, this.meta, this.data});

  RequestModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  int? pendingRequestCount;
  int? acceptedCount;
  Filter? filter;

  Meta(
      {this.page,
        this.limit,
        this.total,
        this.totalPages,
        this.pendingRequestCount,
        this.acceptedCount,
        this.filter});

  Meta.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPages = json['totalPages'];
    pendingRequestCount = json['pendingRequestCount'];
    acceptedCount = json['acceptedCount'];
    filter =
    json['filter'] != null ? new Filter.fromJson(json['filter']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['total'] = this.total;
    data['totalPages'] = this.totalPages;
    data['pendingRequestCount'] = this.pendingRequestCount;
    data['acceptedCount'] = this.acceptedCount;
    if (this.filter != null) {
      data['filter'] = this.filter!.toJson();
    }
    return data;
  }
}

class Filter {
  String? type;
  int? month;
  int? year;

  Filter({this.type, this.month, this.year});

  Filter.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    month = json['month'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['month'] = this.month;
    data['year'] = this.year;
    return data;
  }
}

class Data {
  String? sId;
  String? orderNumber;
  String? title;
  String? parcelType;
  String? weight;
  String? customerName;
  String? customerPhone;
  String? pickupAddress;
  PickupCoordinates? pickupCoordinates;
  String? preferrablePickupTime;
  String? pickupDate;
  String? receiverName;
  String? receiverPhone;
  String? dropoffAddress;
  PickupCoordinates? dropoffCoordinates;
  String? preferrableDeliveryDate;
  String? status;
  bool? isAccepted;
  String? statusLabel;
  String? createdAt;
  String? formattedDate;
  String? trackingUrl;

  Data(
      {this.sId,
        this.orderNumber,
        this.title,
        this.parcelType,
        this.weight,
        this.customerName,
        this.customerPhone,
        this.pickupAddress,
        this.pickupCoordinates,
        this.preferrablePickupTime,
        this.pickupDate,
        this.receiverName,
        this.receiverPhone,
        this.dropoffAddress,
        this.dropoffCoordinates,
        this.preferrableDeliveryDate,
        this.status,
        this.isAccepted,
        this.statusLabel,
        this.createdAt,
        this.formattedDate,
        this.trackingUrl});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    orderNumber = json['orderNumber'];
    title = json['title'];
    parcelType = json['parcelType'];
    weight = json['weight'];
    customerName = json['customerName'];
    customerPhone = json['customerPhone'];
    pickupAddress = json['pickupAddress'];
    pickupCoordinates = json['pickupCoordinates'] != null
        ? new PickupCoordinates.fromJson(json['pickupCoordinates'])
        : null;
    preferrablePickupTime = json['preferrablePickupTime'];
    pickupDate = json['pickupDate'];
    receiverName = json['receiverName'];
    receiverPhone = json['receiverPhone'];
    dropoffAddress = json['dropoffAddress'];
    dropoffCoordinates = json['dropoffCoordinates'] != null
        ? new PickupCoordinates.fromJson(json['dropoffCoordinates'])
        : null;
    preferrableDeliveryDate = json['preferrableDeliveryDate'];
    status = json['status'];
    isAccepted = json['isAccepted'];
    statusLabel = json['statusLabel'];
    createdAt = json['createdAt'];
    formattedDate = json['formattedDate'];
    trackingUrl = json['trackingUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['orderNumber'] = this.orderNumber;
    data['title'] = this.title;
    data['parcelType'] = this.parcelType;
    data['weight'] = this.weight;
    data['customerName'] = this.customerName;
    data['customerPhone'] = this.customerPhone;
    data['pickupAddress'] = this.pickupAddress;
    if (this.pickupCoordinates != null) {
      data['pickupCoordinates'] = this.pickupCoordinates!.toJson();
    }
    data['preferrablePickupTime'] = this.preferrablePickupTime;
    data['pickupDate'] = this.pickupDate;
    data['receiverName'] = this.receiverName;
    data['receiverPhone'] = this.receiverPhone;
    data['dropoffAddress'] = this.dropoffAddress;
    if (this.dropoffCoordinates != null) {
      data['dropoffCoordinates'] = this.dropoffCoordinates!.toJson();
    }
    data['preferrableDeliveryDate'] = this.preferrableDeliveryDate;
    data['status'] = this.status;
    data['isAccepted'] = this.isAccepted;
    data['statusLabel'] = this.statusLabel;
    data['createdAt'] = this.createdAt;
    data['formattedDate'] = this.formattedDate;
    data['trackingUrl'] = this.trackingUrl;
    return data;
  }
}

class PickupCoordinates {
  String? type;
  List<double>? coordinates;

  PickupCoordinates({this.type, this.coordinates});

  PickupCoordinates.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}
