import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

class Employer {
  String id;
  String userID;
  String photoUrl;
  String companyName;
  String contactName;
  String contactNo;
  String address;
  String email;
  bool isVerified;
  Employer(
      {this.photoUrl = 'default',
        this.companyName = '',
        this.contactName = '',
        this.userID = '',
        this.contactNo = '',
        this.id = '',
        this.address = '',
        this.email = '',
        this.isVerified = false});

  bool isEmpty() {
    if (this.companyName == '') return true;

    if (this.contactNo == '') return true;

    if (this.address == '') return true;

    if (this.contactName == '') return true;

    return false;
  }

  Employer.fromSnapshot(DocumentSnapshot documentSnapshot) {
    _fromJson(documentSnapshot.data());
  }

  _fromJson(Map<String, dynamic> json) {
    photoUrl = json['photoUrl'] ?? 'default';
    companyName = json['companyName'] ?? '';
    contactName = json['contactName'] ?? '';
    userID = json['userID'] ?? '';
    contactNo = json['contactNo'] ?? '';
    id = json['id'] ?? '';
    address = json['address'] ?? '';
    email = json['email'] ?? '';
    isVerified = json['isVerified'] ?? false;
  }

  Employer.fromJson(Map<String, dynamic> json) {
    _fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photoUrl'] = this.photoUrl;
    data['contactName'] = this.contactName.toUpperCase().trim();
    data['companyName'] = this.companyName.toUpperCase().trim();
    data['userID'] = this.userID;
    data['contactNo'] = this.contactNo;
    data['id'] = this.id;
    data['email'] = this.email;
    data['address'] = this.address;
    data['isVerified'] = this.isVerified;
    return data;
  }
}
