import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/core/Models/Employee.dart';
import 'package:restaurant_freelance_job/core/Models/Employer.dart';
import 'package:restaurant_freelance_job/core/Services/Services.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployerProvider with ChangeNotifier {
  final firestoreService = Services();
  final FirebaseAuth _auth= FirebaseAuth.instance;
  String _id;
  String _userID;
  String _photoUrl;
  String _companyName;
  String _contactName;
  String _email;
  String _contactNo;
  String _address;
  bool _isVerified;
  var uuid = Uuid();

  //Getters
  String get id => _id;
  String get userID => _userID;
  String get photoUrl => _photoUrl;
  String get companyName => _companyName;
  String get contactName => _contactName;
  String get email => _email;
  String get contactNo => _contactNo;
  String get address => _address;
  bool get isVerified => _isVerified;
  Stream<List<Employer>> get employers => firestoreService.getEmployers();

  //Setters
  set setId(String id){
    _id = id;
    notifyListeners();
  }
  set setUserId(String userId){
    _userID = userId;
    notifyListeners();
  }

  set setPhotoUrl(String photoUrl){
    _photoUrl = photoUrl;
    notifyListeners();
  }
  set setCompanyName(String companyName){
    _companyName = companyName;
    notifyListeners();
  }

  set setContactName(String contactName){
    _contactName = contactName;
    notifyListeners();
  }

  set setEmail(String email){
    _email = email;
    notifyListeners();
  }
  set setContactNo(String contactNo){
    _contactNo = contactNo;
    notifyListeners();
  }

  set setAddress(String address){
    _address = address;
    notifyListeners();
  }
  set setIsVerified(bool isVerified){
    _isVerified = isVerified;
    notifyListeners();
  }

  //Functions
  loadAllEmployer(Employer entry){
    if (entry != null){
      _id=entry.id;
      _userID = entry.userID;
      _isVerified =entry.isVerified;
      _address = entry.address;
      _contactNo =entry.contactNo;
      _companyName = entry.companyName;
      _contactName = entry.contactName;
      _email = entry.email;
      _photoUrl= entry.photoUrl;
    } else {
      _id= null;
      _userID = null;
      _isVerified = true;
      _email = null;
      _address = null;
      _contactNo = null;
      _companyName = null;
      _contactName = null;
      _photoUrl=null;
    }
  }

  saveEmployer(){
    if (_id == null){
      //Add
      var newEntry = Employer(
          id : uuid.v1(),
          userID: _auth.currentUser.uid,
          isVerified :_isVerified,
          address :_address,
          contactNo :_contactNo,
          companyName :_companyName,
          contactName :_contactName,
          email: _email,
        photoUrl: _photoUrl,
      );
      firestoreService.setEmployer(newEntry);
    } else {
      //Edit
      var updatedEntry = Employer(
          id : _id,
          userID: _userID,
          isVerified :_isVerified,
          address :_address,
          contactNo :_contactNo,
          companyName :_companyName,
          contactName :_contactName,
          email: _email,
          photoUrl: _photoUrl,
      );
      firestoreService.setEmployer(updatedEntry);
    }
  }

  removeEmployer(String empId){
    firestoreService.removeEmployer(empId);
  }
}