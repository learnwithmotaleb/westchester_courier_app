class DeliverySummaryModel {
  bool? success;
  num? statusCode;
  String? message;
  Data? data;

  DeliverySummaryModel({this.success, this.statusCode, this.message, this.data});

  DeliverySummaryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  num? pendingTaskCount;
  num? completedTaskCount;

  Data({this.pendingTaskCount, this.completedTaskCount});

  Data.fromJson(Map<String, dynamic> json) {
    pendingTaskCount = json['pendingTaskCount'];
    completedTaskCount = json['completedTaskCount'];
  }
}
