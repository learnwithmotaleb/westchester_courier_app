class MyDeliveryModel {
  bool? success;
  num? statusCode;
  String? message;
  Meta? meta;
  List<DeliveryData>? data;

  MyDeliveryModel(
      {this.success, this.statusCode, this.message, this.meta, this.data});

  MyDeliveryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <DeliveryData>[];
      json['data'].forEach((v) {
        data!.add(DeliveryData.fromJson(v));
      });
    }
  }
}

class Meta {
  num? page;
  num? limit;
  num? total;
  num? totalPages;

  Meta({this.page, this.limit, this.total, this.totalPages});

  Meta.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPages = json['totalPages'];
  }
}

class DeliveryData {
  String? id;
  String? orderNumber;
  String? status;
  String? customerName;
  String? customerPhone;
  String? pickupAddress;
  String? preferrablePickupTime;
  String? pickupDate;
  String? receiverName;
  String? receiverPhone;
  String? dropoffAddress;
  String? preferrableDeliveryDate;
  String? createdAt;
  String? trackingUrl;

  DeliveryData(
      {this.id,
      this.orderNumber,
      this.status,
      this.customerName,
      this.customerPhone,
      this.pickupAddress,
      this.preferrablePickupTime,
      this.pickupDate,
      this.receiverName,
      this.receiverPhone,
      this.dropoffAddress,
      this.preferrableDeliveryDate,
      this.createdAt,
      this.trackingUrl});

  DeliveryData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    orderNumber = json['orderNumber'];
    status = json['status'];
    customerName = json['customerName'];
    customerPhone = json['customerPhone'];
    pickupAddress = json['pickupAddress'];
    preferrablePickupTime = json['preferrablePickupTime'];
    pickupDate = json['pickupDate'];
    receiverName = json['receiverName'];
    receiverPhone = json['receiverPhone'];
    dropoffAddress = json['dropoffAddress'];
    preferrableDeliveryDate = json['preferrableDeliveryDate'];
    createdAt = json['createdAt'];
    trackingUrl = json['trackingUrl'];
  }
}
