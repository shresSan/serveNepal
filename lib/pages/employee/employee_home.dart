import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/core/Models/Employee.dart';
import 'package:restaurant_freelance_job/core/Models/vacancyNotification.dart';
import 'package:restaurant_freelance_job/core/Provider/empAvailability_provider.dart';
import 'package:restaurant_freelance_job/core/Provider/hiringForm_provider.dart';
import 'package:restaurant_freelance_job/core/Provider/priceList_provider.dart';
import 'dart:ui';

import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/DashboardItems.dart';
import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/JobRoles.dart';
import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/ProfileConstants.dart';
import 'package:restaurant_freelance_job/pages/price_list.dart';
import 'package:restaurant_freelance_job/pages/Welcome/welcome_screen.dart';
import 'package:restaurant_freelance_job/pages/employee/employeeAvailabilityForm.dart';
import 'package:restaurant_freelance_job/pages/employee/employeeForm.dart';
import 'package:restaurant_freelance_job/pages/employee/employee_workNotification.dart';
import '../change_password.dart';

class EmployeeHome extends StatefulWidget {
  final Employee employee;
  EmployeeHome(this.employee);
  @override
  _EmployeeHomeState createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  final FirebaseAuth _auth= FirebaseAuth.instance;
  ModalRoute<dynamic> _route;
  List<JobRoles> priceList= new List<JobRoles>();
  List<VacancyNotification> notificationList= new List<VacancyNotification>();
  @override
  void initState() {
    PriceListProvider priceListProvider = new PriceListProvider();
    priceListProvider.priceList.first.then((value) =>
        priceList= value
    );
    super.initState();
    }

    Future<void> getNotification() async {
      HiringFormProvider hiringFormProvider = new HiringFormProvider();
      List<JobRoles> roles;
      PriceListProvider priceListProvider = new PriceListProvider();
      await priceListProvider.priceList.first.then(
              (value) => roles = value
      );
      String jobRole= roles.where((element) => element.id==widget.employee.jobRole).first.name;
      hiringFormProvider.getNotificationByJobRoleId(widget.employee.jobRole).then((result){
        List<VacancyNotification> notifications= result;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new EmployeeWorkNotification(widget.employee,notifications,jobRole)));
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[dashBg, content],
      ),
    );
  }
  @override
  void dispose(){
    super.dispose();
  }
  get dashBg => Column(
    children: <Widget>[
      Expanded(
        child: Container(color: Colors.cyan),
        flex: 2,
      ),
      Expanded(
        child: Container(color: Colors.transparent),
        flex: 5,
      ),
    ],
  );

  get content => Container(
    child: Column(
      children: <Widget>[
        header,
        grid,
      ],
    ),
  );

  get header => ListTile(
    contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20),
    title: Text(
      widget.employee.name,
      style: TextStyle(color: Colors.black),
    ),
    subtitle: Text(
      'Easily get a real-time part time job',
      style: TextStyle(color: Colors.white),
    ),
    trailing: PopupMenuButton(
      child: CircleAvatar(radius:30, backgroundImage:NetworkImage(widget.employee.photoUrl)),
      onSelected: choiceAction,
      itemBuilder:  (context) =>
         ProfileConstants.choices.map((String choice){
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList()
    )
  );
  get grid => Expanded(
    child: Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: GridView.count(
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        crossAxisCount: 2,
        childAspectRatio: .90,
        children: List.generate(dashboard.length, (i) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            ),
            child: Center(
              child: ListTile(
                title: Text( dashboard[i].name,
                textScaleFactor: 1.5,
                textAlign: TextAlign.center),
                subtitle: Icon(Icons.add_alert),
                onTap : (){
                  onNavigate(dashboard[i].url);
                  },
              ),
            ),
          );
        })
        )
      ),
  );
  Future<void> choiceAction(String choice) async {
    if(choice == ProfileConstants.Profile){
            Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context) => new EmployeeForm(employee: widget.employee,priceList: priceList)));
    }else if(choice == ProfileConstants.ChangePwd){
      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=> new ChangePassword()));
    }else if(choice == ProfileConstants.LogOut){
      dispose();
      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=> new WelcomeScreen()));
      _auth.signOut();
    }
  }
  void onNavigate(String url) {
    if(url == '/employeeAvail'){
      EmpAvailabilityProvider empAvailabilityProvider = new EmpAvailabilityProvider();
      empAvailabilityProvider.empAvailability.then((value) =>
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => new EmployeeAvailabilityForm(empAvailability: value, employee: widget.employee))));
    } else if(url == '/employeeNotification') {
      getNotification();
    }else if(url == '/PriceList'){
       Navigator.push(context,
          MaterialPageRoute(builder: (context) => new PriceList(priceList:priceList)));
    }
  }
}

List<DashboardItems> dashboard = [
  DashboardItems('Edit Availability', '/employeeAvail'),
  DashboardItems('Notification', '/employeeNotification'),
  DashboardItems('History', '/'),
  DashboardItems('Prices', '/PriceList')
];


