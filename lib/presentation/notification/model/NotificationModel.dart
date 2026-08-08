class NotificationModel {
  bool? success;
  int? statusCode;
  String? message;
  Meta? meta;
  int? unreadCount;
  List<Data>? data;

  NotificationModel(
      {this.success,
        this.statusCode,
        this.message,
        this.meta,
        this.unreadCount,
        this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    unreadCount = json['unreadCount'];
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
    data['unreadCount'] = this.unreadCount;
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

  Meta({this.page, this.limit, this.total, this.totalPages});

  Meta.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['total'] = this.total;
    data['totalPages'] = this.totalPages;
    return data;
  }
}

class Data {
  String? sId;
  String? title;
  String? body;
  String? type;
  String? orderNumber;
  String? deliveryId;
  bool? isRead;
  String? readAt;
  String? section;
  String? timeAgo;
  String? createdAt;

  Data(
      {this.sId,
        this.title,
        this.body,
        this.type,
        this.orderNumber,
        this.deliveryId,
        this.isRead,
        this.readAt,
        this.section,
        this.timeAgo,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    body = json['body'];
    type = json['type'];
    orderNumber = json['orderNumber'];
    deliveryId = json['deliveryId'];
    isRead = json['isRead'];
    readAt = json['readAt'];
    section = json['section'];
    timeAgo = json['timeAgo'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['body'] = this.body;
    data['type'] = this.type;
    data['orderNumber'] = this.orderNumber;
    data['deliveryId'] = this.deliveryId;
    data['isRead'] = this.isRead;
    data['readAt'] = this.readAt;
    data['section'] = this.section;
    data['timeAgo'] = this.timeAgo;
    data['createdAt'] = this.createdAt;
    return data;
  }

  Data copyWith({
    String? sId,
    String? title,
    String? body,
    String? type,
    String? orderNumber,
    String? deliveryId,
    bool? isRead,
    String? readAt,
    String? section,
    String? timeAgo,
    String? createdAt,
  }) {
    return Data(
      sId: sId ?? this.sId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      orderNumber: orderNumber ?? this.orderNumber,
      deliveryId: deliveryId ?? this.deliveryId,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      section: section ?? this.section,
      timeAgo: timeAgo ?? this.timeAgo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
