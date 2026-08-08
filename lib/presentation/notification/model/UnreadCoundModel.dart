class NotificationUnreadModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  NotificationUnreadModel(
      {this.success, this.statusCode, this.message, this.data});

  NotificationUnreadModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? unreadCount;

  Data({this.unreadCount});

  Data.fromJson(Map<String, dynamic> json) {
    unreadCount = json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unreadCount'] = this.unreadCount;
    return data;
  }
}
