import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

class HiringFormModel {
  String id;
  String employerId;
  String transactionId;
  String jobShift;
  String jobRole;
  String empNum;
  String totalAmount;
  String updatedDate;
  String deadline;
  HiringFormModel(
      {
        this.id = '',
        this.employerId = '',
        this.transactionId ='',
        this.jobShift = '',
        this.jobRole = '',
        this.empNum = '',
        this.totalAmount='',
        this.updatedDate = '',
        this.deadline= ''
      });

  HiringFormModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    _fromJson(documentSnapshot.data());
  }

  _fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    employerId = json['employerId'] ?? '';
    transactionId = json['transactionId'] ?? '';
    jobShift = json['jobShift'] ?? '';
    jobRole = json['jobRole'] ?? '';
    empNum = json['empNum'] ?? '';
    totalAmount = json['totalAmount'] ?? '';
    updatedDate = json['updatedDate'] ?? '';
    deadline = json['deadline'] ?? '';
  }

  HiringFormModel.fromJson(Map<String, dynamic> json) {
    _fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employerId'] = this.employerId;
    data['transactionId'] = this.transactionId;
    data['jobShift'] = this.jobShift;
    data['jobRole'] = this.jobRole;
    data['empNum'] = this.empNum;
    data['totalAmount'] = this.totalAmount;
    data['updatedDate'] = this.updatedDate;
    data['deadline'] = this.deadline;
    return data;
  }
}
