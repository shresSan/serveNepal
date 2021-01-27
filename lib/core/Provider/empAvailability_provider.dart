import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/core/Models/EmpAvailability.dart';
import 'package:restaurant_freelance_job/core/Services/Services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmpAvailabilityProvider with ChangeNotifier {
  final firestoreService = Services();
  final FirebaseAuth _auth= FirebaseAuth.instance;
  String _userID;
  bool _isAvailable;
  String _jobShift;
  String _updatedDate;

  //Getters
  String get userID => _userID;
  bool get isAvailable => _isAvailable;
  String get jobShift => _jobShift;
  String get updatedDate => _updatedDate;
  Future<EmpAvailability> get empAvailability => firestoreService.getEmpAvailabilityById(_auth.currentUser.uid);

  //Setters
  set setUserId(String userId){
    _userID = userId;
    notifyListeners();
  }

  set setAvailability(bool isAvailable){
    _isAvailable = isAvailable;
    notifyListeners();
  }
  set setJobShift(String jobShift){
    _jobShift = jobShift;
    notifyListeners();
  }

  set setUpdatedDate(String updatedDate){
    _updatedDate = updatedDate;
    notifyListeners();
  }
  //Functions
  loadEmpAvailability(EmpAvailability entry){
    if (entry != null){
      _userID = entry.userID;
      _isAvailable =entry.isAvailable;
      _jobShift = entry.jobShift;
      _updatedDate =entry.updatedDate;
    } else {
      _userID = null;
      _isAvailable =false;
      _jobShift = null;
      _updatedDate =null;
    }
  }

  saveEmpAvailability(){
      var newEntry = EmpAvailability(
          userID: _auth.currentUser.uid,
          isAvailable :_isAvailable,
          jobShift :_jobShift,
          updatedDate :_updatedDate
      );
      firestoreService.setEmpAvailability(newEntry);
  }

  removeEmployer(String empId){
    firestoreService.removeEmployer(empId);
  }
}