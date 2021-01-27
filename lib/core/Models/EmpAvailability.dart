import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmpAvailability {
  String userID;
  bool isAvailable;
  String jobShift;
  String updatedDate;
  EmpAvailability(
      { this.userID = '',
        this.isAvailable = false,
        this.jobShift = '',
        this.updatedDate = null});

  EmpAvailability.fromSnapshot(DocumentSnapshot documentSnapshot) {
    _fromJson(documentSnapshot.data());
  }

  _fromJson(Map<String, dynamic> json) {
    userID = json['userID'] ?? '';
    isAvailable = json['isAvailable'] ?? false;
    jobShift = json['jobShift'] ?? '';
    updatedDate = json['updatedDate'] ?? '';
  }

  EmpAvailability.fromJson(Map<String, dynamic> json) {
    _fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['isAvailable'] = this.isAvailable;
    data['jobShift'] = this.jobShift.toUpperCase().trim();
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}
