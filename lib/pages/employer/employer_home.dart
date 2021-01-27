import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/core/Models/Employer.dart';
import 'package:restaurant_freelance_job/core/Provider/priceList_provider.dart';
import 'package:restaurant_freelance_job/core/Services/Services.dart';
import 'dart:ui';

import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/DashboardItems.dart';
import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/JobRoles.dart';
import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/ProfileConstants.dart';
import 'package:restaurant_freelance_job/pages/Welcome/welcome_screen.dart';
import 'package:restaurant_freelance_job/pages/employer/employerForm.dart';
import 'package:restaurant_freelance_job/pages/employer/employer_requestedEmpNotification.dart';
import '../change_password.dart';
import '../price_list.dart';
import 'multi_form.dart';

class EmployerHome extends StatefulWidget {
  final Employer employer;
  EmployerHome(this.employer);
  @override
  _EmployerHomeState createState() => _EmployerHomeState();
}

class _EmployerHomeState extends State<EmployerHome> {
  final FirebaseAuth _auth= FirebaseAuth.instance;
  List<JobRoles> priceList= new List<JobRoles>();
  @override
  void initState() {
    PriceListProvider priceListProvider = new PriceListProvider();
    priceListProvider.priceList.first.then((value) =>
    priceList=value
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[dashBg, content],
      ),
    );
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
      widget.employer.contactName,
      style: TextStyle(color: Colors.black),
    ),
    subtitle: Text(
      'Easily Hire at real time',
      style: TextStyle(color: Colors.white),
    ),
      trailing: PopupMenuButton(
          child: CircleAvatar(radius:30, backgroundImage:NetworkImage(widget.employer.photoUrl)),
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
                onTap: () {
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
      Services services = new Services();
      await services.getEmployerById(_auth.currentUser.uid).then((value){
        Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) => new EmployerForm(employer: value)));
      });
    }else if(choice == ProfileConstants.ChangePwd){
      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=> new ChangePassword()));
    }else if(choice == ProfileConstants.LogOut){
      dispose();
      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=> new WelcomeScreen()));
      _auth.signOut();
    }
  }
  @override
  void dispose(){
    super.dispose();
  }
  void onNavigate(String url){
    Services services = new Services();
    if(url == '/hiring'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => new MultiForm(widget.employer)));
    }else if(url == '/employerNotification'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => new EmployerRequestedEmpNotification(widget.employer,null,null)));
    }else if(url == '/PriceList'){
       Navigator.push(context,
           MaterialPageRoute(builder: (context) => new PriceList(priceList:priceList)));
    }
  }
}

List<DashboardItems> dashboard = [
  DashboardItems('Hire Employee', '/hiring'),
  DashboardItems('Notification', '/employerNotification'),
  DashboardItems('History', '/'),
  DashboardItems('Prices', '/PriceList')
];


