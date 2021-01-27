import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  String id;
  String userID;
  String photoUrl;
  String name;
  String contactNo;
  String address;
  String gender;
  String jobRole;
  String jobExperience;
  bool isVerified;
  Employee(
      {this.photoUrl = 'default',
        this.name = '',
        this.userID = '',
        this.contactNo = '',
        this.id = '',
        this.address = '',
        this.gender = '',
        this.jobRole = '',
        this.jobExperience = '',
        this.isVerified = false});

  bool isEmpty() {
    if (this.name == '') return true;

    if (this.contactNo == '') return true;

    if (this.address == '') return true;

    if (this.jobRole == '') return true;

    return false;
  }

  Employee.fromSnapshot(DocumentSnapshot documentSnapshot) {
    _fromJson(documentSnapshot.data());
  }

  _fromJson(Map<String, dynamic> json) {
    photoUrl = json['photoUrl'] ?? 'default';
    name = json['name'] ?? '';
    userID = json['userID'] ?? '';
    contactNo = json['contactNo'] ?? '';
    id = json['id'] ?? '';
    gender = json['gender'] ?? '';
    jobRole = json['jobRole'] ?? '';
    jobExperience = json['jobExperience'] ?? '';
    address = json['address'] ?? '';
    isVerified = json['isVerified'] ?? false;
  }

  Employee.fromJson(Map<String, dynamic> json) {
    _fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photoUrl'] = this.photoUrl;
    data['name'] = this.name.toUpperCase().trim();
    data['userID'] = this.userID;
    data['contactNo'] = this.contactNo;
    data['id'] = this.id;
    data['gender'] = this.gender;
    data['jobRole'] = this.jobRole;
    data['jobExperience'] = this.jobExperience;
    data['address'] = this.address;
    data['isVerified'] = this.isVerified;
    return data;
  }
}
