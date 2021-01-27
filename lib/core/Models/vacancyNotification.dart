import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

class VacancyNotification {
  String employerId;
  String companyName;
  String contactName;
  String address;
  String email;
  String updatedDate;
  String deadline;
  String jobRoleId;
  VacancyNotification(
      {
        this.employerId = '',
        this.companyName = '',
        this.contactName = '',
        this.address = '',
        this.email = '',
        this.updatedDate = '',
        this.deadline = '',
        this.jobRoleId = ''
      });

  VacancyNotification.fromSnapshot(DocumentSnapshot documentSnapshot) {
    _fromJson(documentSnapshot.data());
  }

  _fromJson(Map<String, dynamic> json) {
    employerId = json['employerId'] ?? '';
    companyName = json['companyName'] ?? '';
    contactName = json['contactName'] ?? '';
    address = json['address'] ?? '';
    email = json['email'] ?? '';
    updatedDate = json['updatedDate'] ?? '';
    deadline = json['deadline'] ?? '';
    jobRoleId = json['jobRoleId'] ?? '';
  }

  VacancyNotification.fromJson(Map<String, dynamic> json) {
    _fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employerId'] = this.employerId;
    data['contactName'] = this.contactName.toUpperCase().trim();
    data['companyName'] = this.companyName.toUpperCase().trim();
    data['email'] = this.email;
    data['address'] = this.address;
    data['updatedDate'] = this.updatedDate;
    data['deadline'] = this.deadline;
    data['jobRoleId'] = this.jobRoleId;
    return data;
  }
}
