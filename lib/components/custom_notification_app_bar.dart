import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/core/Models/Employee.dart';
import 'package:restaurant_freelance_job/core/Models/Employer.dart';
import 'package:restaurant_freelance_job/pages/employee/employee_home.dart';
import 'package:restaurant_freelance_job/pages/employee/employee_workNotification.dart';
import 'package:restaurant_freelance_job/pages/employer/employer_home.dart';
import 'package:restaurant_freelance_job/pages/employer/employer_requestedEmpNotification.dart';

import '../services/auth.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
  String title;
  IconData icon;
  bool bottomBar;
  bool employer;
  Employer employerObj;
  Employee employeeObj;
  String rolesValue;
  CustomAppBar(title, employer,employerObj, employeeObj,rolesValue){
      this.title = title;
        this.icon = Icons.home;
        this.bottomBar = true;
        this.employer=employer;
        this.employerObj=employerObj;
        this.employeeObj=employeeObj;
        this.rolesValue=rolesValue;
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(100.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 5,
      title: Text(
        this.widget.title,
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: Icon(this.widget.icon),
        color: Colors.black,
        onPressed: onNavigate,
      ),
      bottom: PreferredSize(
          child: Column(
            children: <Widget>[
              this.widget.employer == true
                  ? employeeList(this.widget.rolesValue)
                  : employerList(this.widget.rolesValue)
            ],
          )),
    );
  }
  void onNavigate(){
    this.widget.employer == true?
    Navigator.push(context,
         MaterialPageRoute(builder: (context) => new EmployerHome(widget.employerObj))):
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => new EmployeeHome(widget.employeeObj)));
  }
}
