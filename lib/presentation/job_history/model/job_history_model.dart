class JobHistoryModel {
  bool? success;
  int? statusCode;
  String? message;
  Summary? summary;
  List<Data>? data;

  JobHistoryModel(
      {this.success, this.statusCode, this.message, this.summary, this.data});

  JobHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    summary =
    json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
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
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  int? totalAssigned;
  int? totalDelivery;
  int? totalCanceled;

  Summary({this.totalAssigned, this.totalDelivery, this.totalCanceled});

  Summary.fromJson(Map<String, dynamic> json) {
    totalAssigned = json['totalAssigned'];
    totalDelivery = json['totalDelivery'];
    totalCanceled = json['totalCanceled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalAssigned'] = this.totalAssigned;
    data['totalDelivery'] = this.totalDelivery;
    data['totalCanceled'] = this.totalCanceled;
    return data;
  }
}

class Data {
  String? date;
  List<Jobs>? jobs;

  Data({this.date, this.jobs});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['jobs'] != null) {
      jobs = <Jobs>[];
      json['jobs'].forEach((v) {
        jobs!.add(new Jobs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.jobs != null) {
      data['jobs'] = this.jobs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Jobs {
  String? sId;
  String? orderNumber;
  String? assignDate;
  String? pickupAddress;
  String? dropoffAddress;
  String? status;

  Jobs(
      {this.sId,
        this.orderNumber,
        this.assignDate,
        this.pickupAddress,
        this.dropoffAddress,
        this.status});

  Jobs.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    orderNumber = json['orderNumber'];
    assignDate = json['assignDate'];
    pickupAddress = json['pickupAddress'];
    dropoffAddress = json['dropoffAddress'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['orderNumber'] = this.orderNumber;
    data['assignDate'] = this.assignDate;
    data['pickupAddress'] = this.pickupAddress;
    data['dropoffAddress'] = this.dropoffAddress;
    data['status'] = this.status;
    return data;
  }
}
