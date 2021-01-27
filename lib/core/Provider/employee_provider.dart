import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/core/Models/Employee.dart';
import 'package:restaurant_freelance_job/core/Services/Services.dart';
import 'package:uuid/uuid.dart';

class EmployeeProvider with ChangeNotifier {
  final firestoreService = Services();
  String _id;
  String _userID;
  String _photoUrl;
  String _name;
  String _email;
  String _contactNo;
  String _address;
  String _gender;
  String _jobRole;
  String _jobExperience;
  bool _isVerified;
  var uuid = Uuid();

  //Getters
  String get id => _id;
  String get userID => _userID;
  String get photoUrl => _photoUrl;
  String get name => _name;
  String get email => _email;
  String get contactNo => _contactNo;
  String get address => _address;
  String get gender => _gender;
  String get jobRole => _jobRole;
  String get jobExperience => _jobExperience;
  bool get isVerified => _isVerified;
  Stream<List<Employee>> get employees => firestoreService.getEmployees();

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
  set setName(String name){
    _name = name;
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
  set setGender(String gender){
    _gender = gender;
    notifyListeners();
  }

  set setJobRole(String jobRole){
    _jobRole = jobRole;
    notifyListeners();
  }
  set setJobExperience(String jobExperience){
    _jobExperience = jobExperience;
    notifyListeners();
  }
  set setIsVerified(bool isVerified){
    _isVerified = isVerified;
    notifyListeners();
  }

  //Functions
  loadAll(Employee entry){
    if (entry != null){
      _id=entry.id;
      _userID = entry.userID;
      _isVerified =entry.isVerified;
      _jobExperience = entry.jobExperience;
      _gender = entry.gender;
      _jobRole = entry.jobRole;
      _address = entry.address;
      _contactNo =entry.contactNo;
      _name = entry.name;
      _photoUrl= entry.photoUrl;
    } else {
      _userID = null;
      _isVerified = true;
      _jobExperience = null;
      _gender = null;
      _email = null;
      _jobRole = null;
      _address = null;
      _contactNo = null;
      _name = null;
      _photoUrl=null;
    }
  }

  saveEmployee(){
    if (_id == null){
      //Add
      var newEntry = Employee(
          id : uuid.v1(),
          userID: _userID,
          isVerified :_isVerified,
          jobExperience :_jobExperience,
          gender :_gender,
          jobRole :_jobRole,
          address :_address,
          contactNo :_contactNo,
          name :_name,
          photoUrl: _photoUrl
      );
      firestoreService.setEmployee(newEntry);
    } else {
      //Edit
      var updatedEntry = Employee(
          id : _id,
          userID: _userID,
          isVerified :_isVerified,
          jobExperience :_jobExperience,
          gender :_gender,
          jobRole :_jobRole,
          address :_address,
          contactNo :_contactNo,
          name :_name,
          photoUrl: _photoUrl
      );
      firestoreService.setEmployee(updatedEntry);
    }
  }

  removeEmployee(String empId){
    firestoreService.removeEmployee(empId);
  }
}