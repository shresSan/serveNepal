import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_freelance_job/core/Models/EmpAvailability.dart';
import 'package:restaurant_freelance_job/core/Models/Employee.dart';
import 'package:restaurant_freelance_job/core/Models/Employer.dart';
import 'package:restaurant_freelance_job/core/Models/HiringFormModel.dart';
import 'package:restaurant_freelance_job/core/Models/vacancyNotification.dart';
import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/JobRoles.dart';

class Services {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  //Get Entries
  Stream<List<Employee>> getEmployees(){
    return _db
        .collection('employee')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Employee.fromJson(doc.data()))
        .toList());
  }
  Future<Employee> getEmployeeById(String userId) {
    Future<Employee> obj =_db.collection('employee').where('userID',isEqualTo: userId).get().then((snapshot) {
      Employee emp = new Employee();
      if(snapshot.docs.isNotEmpty){
        snapshot.docs.forEach((element) {
          emp.photoUrl = element['photoUrl'];
          emp.name = element['name'];
          emp.userID = element['userID'];
          emp.contactNo = element['contactNo'];
          emp.id = element['id'];
          emp.gender = element['gender'];
          emp.jobRole = element['jobRole'];
          emp.jobExperience = element['jobExperience'];
          emp.address = element['address'];
          emp.isVerified = element['isVerified'];
        });
      }
      return emp;
    });
    return obj;
  }
  //Upsert
  Future<void> setEmployee(Employee emp){
    var options = SetOptions(merge:true);

    return _db
        .collection('employee')
        .doc(emp.id)
        .set(emp.toJson(),options);
  }

  //Delete
  Future<void> removeEmployee(String empId){
    return _db
        .collection('employee')
        .doc(empId)
        .delete();
  }

  //Employer
//Get Entries
  Stream<List<Employer>> getEmployers(){
    return _db
        .collection('employer')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Employer.fromJson(doc.data()))
        .toList());
  }
  Future<Employer> getEmployerById(String userId) {
    Future<Employer> obj =_db.collection('employer').where('userID',isEqualTo: userId).get().then((snapshot) {
      Employer emp = new Employer();
      if(snapshot.docs.isNotEmpty){
        snapshot.docs.forEach((element) {
          emp.photoUrl = element['photoUrl'];
          emp.companyName = element['companyName'];
          emp.contactName = element['contactName'];
          emp.email = element['email'];
          emp.userID = element['userID'];
          emp.contactNo = element['contactNo'];
          emp.id = element['id'];
          emp.address = element['address'];
          emp.isVerified = element['isVerified'];
        });
      }
      return emp;
    });
    return obj;
  }
  Future<List<Employee>> getEmployerListByJobRole(String roleId) async {
    List<Employee> employeeList= new List<Employee>();
    await _db.collection('employee').where('jobRole',isEqualTo: roleId).get().then((snapshots) {
      for(var emp in snapshots.docs) {
        Employee emp = new Employee();
        if (snapshots.docs.isNotEmpty) {
          snapshots.docs.forEach((element) {
            emp.photoUrl = element['photoUrl'];
            emp.name = element['name'];
            emp.userID = element['userID'];
            emp.contactNo = element['contactNo'];
            emp.id = element['id'];
            emp.gender = element['gender'];
            emp.jobRole = element['jobRole'];
            emp.jobExperience = element['jobExperience'];
            emp.address = element['address'];
            emp.isVerified = element['isVerified'];
            employeeList.add(emp);
          });
        }
      }
    });
       return employeeList;
    }
  Future<List<VacancyNotification>> getNotificationByJobRoleId(String id) async {
    List<VacancyNotification> finalList= new List<VacancyNotification>();
    await _db.collection('hiringDetails').where('jobRole',isEqualTo: id).get().then((snapshots) {
       VacancyNotification notif = new VacancyNotification();
        if (snapshots.docs.isNotEmpty) {
          snapshots.docs.forEach((element) {
            notif.deadline = element['deadline'];
            notif.employerId = element['employerId'];
            notif.updatedDate = element['updatedDate'];
            finalList.add(notif);
          });
      }
    });
    return finalList;
  }

  //Upsert
  Future<void> setEmployer(Employer emp){
    var options = SetOptions(merge:true);
    return _db
        .collection('employer')
        .doc(emp.id)
        .set(emp.toJson(),options);
  }

  //Delete
  Future<void> removeEmployer(String empId){
    return _db
        .collection('employer')
        .doc(empId)
        .delete();
  }

  Stream<List<JobRoles>> getPriceList(){
    _db.collection("jobPrices").snapshots().listen((result) {
      result.docs.forEach((result) {
      });
    });
    return _db
        .collection('jobPrices')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => JobRoles.fromJson(doc.data()))
        .toList());
  }

  Future<EmpAvailability> getEmpAvailabilityById(String userId) {
    Future<EmpAvailability> obj =_db.collection('empAvailability').where('userID',isEqualTo: userId).get().then((snapshot) {
      EmpAvailability emp = new EmpAvailability();
      if(snapshot.docs.isNotEmpty){
        snapshot.docs.forEach((element) {
          emp.userID = element['userID'];
          emp.isAvailable = element['isAvailable'];
          emp.jobShift = element['jobShift'];
          emp.updatedDate = element['updatedDate'];
        });
      }
      return emp;
    });
    return obj;
  }
  Future<void> setEmpAvailability(EmpAvailability emp){
    var options = SetOptions(merge:true);
    return _db
        .collection('empAvailability')
        .doc(emp.userID)
        .set(emp.toJson(),options);
  }

  Future<List<HiringFormModel>> getCurrentTransHiringFormsById(String transId) {
    Future<List<HiringFormModel>> obj =_db.collection('hiringDetails').where('transactionId',isEqualTo: transId).get().then((snapshot) {
      List<HiringFormModel> modelList = new List<HiringFormModel>();
      if(snapshot.docs.isNotEmpty){
        snapshot.docs.forEach((element) {
          for(HiringFormModel model in modelList) {
            model.id = element['id'];
            model.employerId = element['employerId'];
            model.empNum = element['empNum'];
            model.jobRole = element['jobRole'];
            model.jobShift = element['jobShift'];
          }
        });
      }
      return modelList;
    });
    return obj;
  }

  Future<void> setHiringForm(HiringFormModel model){
    var options = SetOptions(merge:true);
    return _db
        .collection('hiringDetails')
        .doc(model.id)
        .set(model.toJson(),options);
  }
  //Delete
  Future<void> removeHiringForm(String id){
    return _db
        .collection('hiringDetails')
        .doc(id)
        .delete();
  }
}