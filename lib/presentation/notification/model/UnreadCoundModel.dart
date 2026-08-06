class UnreadCoundModel {
  bool? success;
  String? message;
  UnreadData? data;

  UnreadCoundModel({this.success, this.message, this.data});

  UnreadCoundModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? UnreadData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UnreadData {
  int? count;

  UnreadData({this.count});

  UnreadData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    return data;
  }
}
