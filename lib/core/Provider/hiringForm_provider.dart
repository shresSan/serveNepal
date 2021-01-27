import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/core/Models/Employee.dart';
import 'package:restaurant_freelance_job/core/Models/Employer.dart';
import 'package:restaurant_freelance_job/core/Models/HiringFormModel.dart';
import 'package:restaurant_freelance_job/core/Models/vacancyNotification.dart';
import 'package:restaurant_freelance_job/core/Services/Services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class HiringFormProvider with ChangeNotifier {
  final firestoreService = Services();
  final FirebaseAuth _auth= FirebaseAuth.instance;
  String _id;
  String _employerId;
  String _transactionId;
  String _jobShift;
  String _jobRole;
  String _empNum;
  String _totalAmount;
  String _updatedDate;
  String _deadline;
  var uuid = Uuid();

  //Getters
  String get id => _id;
  String get employerId => _employerId;
  String get transactionId => _transactionId;
  String get jobShift => _jobShift;
  String get jobRole => _jobRole;
  String get empNum => _empNum;
  String get totalAmount => _totalAmount;
  String get updatedDate => _updatedDate;
  String get deadline => _deadline;
  Future<List<HiringFormModel>> get currentTransHiringForms => firestoreService.getCurrentTransHiringFormsById(_transactionId);

  //Setters
  set setId(String ID){
    _id = ID;
    notifyListeners();
  }
  set setEmployerId(String employerId){
    _employerId = employerId;
    notifyListeners();
  }
  set setTransactionId(String transactionId){
    _transactionId = transactionId;
    notifyListeners();
  }
  set setJobShift(String jobShift){
    _jobShift = jobShift;
    notifyListeners();
  }
  set setJobRole(String jobRole){
    _jobRole = jobRole;
    notifyListeners();
  }
  set setEmpNum(String empNum){
    _empNum = empNum;
    notifyListeners();
  }
  set setTotalAmount(String totalAmount){
    _totalAmount = totalAmount;
    notifyListeners();
  }
  set setUpdatedDate(String updatedDate){
    _updatedDate = updatedDate;
    notifyListeners();
  }
  set setDeadline(String deadline){
    _deadline = deadline;
    notifyListeners();
  }
  //Functions
  /*loadEmpAvailability(EmpAvailability entry){
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
  }*/

  saveHiringForms(List<HiringFormProvider> hiringList){
    for(HiringFormProvider model in hiringList){
      var newEntry = HiringFormModel(
          id:  uuid.v1(),
          employerId : _auth.currentUser.uid,
          transactionId: model.transactionId,
          jobShift :model.jobShift,
          jobRole :model.jobRole,
          empNum :model.empNum,
          totalAmount: model.totalAmount,
          updatedDate :model.updatedDate,
          deadline :model.deadline
      );
      firestoreService.setHiringForm(newEntry);
    }
  }

  Future<List<Employee>> getEmployeeListByJobRoles(List<String> rolesIdList) async{
    var distinctRoleIds= rolesIdList.toSet().toList();
    List<Employee> employeeList= new List<Employee>();
    for(String role in distinctRoleIds){
      List<Employee> result = await firestoreService.getEmployerListByJobRole(role);
      for(Employee emp in result)
        {
          employeeList.add(emp);
        }
    }
    return employeeList;
  }
  Future<List<VacancyNotification>> getNotificationByJobRoleId(String id) async {
    List<VacancyNotification> notificationList= new List<VacancyNotification>();
    List<VacancyNotification> result=  await firestoreService.getNotificationByJobRoleId(id);
    for(VacancyNotification notification in result)
    {
      Employer emp= await firestoreService.getEmployerById(notification.employerId);
      notification.companyName = emp.companyName;
      notification.contactName = emp.contactName;
      notification.address = emp.address;
      notification.email =  emp.email;
      notificationList.add(notification);
    }
    return notificationList;
  }
  removeHiringForm(String Id){
    firestoreService.removeHiringForm(Id);
  }
}