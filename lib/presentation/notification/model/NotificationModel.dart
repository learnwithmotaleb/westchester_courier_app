class NotificationModel {
  bool? success;
  String? message;
  List<Data>? data;

  NotificationModel({this.success, this.message, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? title;
  String? message;
  String? createdAt;
  bool? isRead;
  String? imagePath;
  String? type;

  Data({
    this.id,
    this.title,
    this.message,
    this.createdAt,
    this.isRead,
    this.imagePath,
    this.type,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    title = json['title'];
    message = json['message'];
    createdAt = json['createdAt'];
    isRead = json['isRead'];
    imagePath = json['imagePath'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['title'] = title;
    data['message'] = message;
    data['createdAt'] = createdAt;
    data['isRead'] = isRead;
    data['imagePath'] = imagePath;
    data['type'] = type;
    return data;
  }

  Data copyWith({
    String? id,
    String? title,
    String? message,
    String? createdAt,
    bool? isRead,
    String? imagePath,
    String? type,
  }) {
    return Data(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      imagePath: imagePath ?? this.imagePath,
      type: type ?? this.type,
    );
  }
}
