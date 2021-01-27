import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/components/custom_notification_app_bar.dart';
import 'package:restaurant_freelance_job/core/Models/Employee.dart';
import 'package:restaurant_freelance_job/core/Models/Employer.dart';
import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/JobRoles.dart';

class EmployerRequestedEmpNotification extends StatefulWidget {
  final Employer employer;
  final List<Employee> availableEmpList;
  final List<JobRoles> roles;
  final Employee employee=null;
  EmployerRequestedEmpNotification(this.employer,this.availableEmpList,this.roles);
  @override
  _EmployerRequestedEmpNotificationState createState() => _EmployerRequestedEmpNotificationState();
}
class _EmployerRequestedEmpNotificationState extends State<EmployerRequestedEmpNotification> {
  String allRoles='';
  @override
  void initState() {
    for(JobRoles role in widget.roles){
      allRoles+= role.name + ' | ';
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: CustomAppBar("Available Employees", true, widget.employer, widget.employee, allRoles),
            body: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
// scrollDirection: Axis.horizontal,
                        itemCount: widget.availableEmpList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            height: 120,
                            width: double.maxFinite,
                            child: Card(
                              elevation: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        width: 2.0, color: Colors.orange),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Stack(children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(left: 10, top: 5),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      cryptoIcon(widget.availableEmpList[index]),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      cryptoNameSymbol(widget.availableEmpList[index])
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      cryptoAddress(widget.availableEmpList[index]),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      changeIcon(widget.availableEmpList[index]),
                                                      SizedBox(
                                                        width: 20,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )));
  }
  Widget cryptoIcon(data) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.person,
            color: Colors.orange,
            size: 40,
          )),
    );
  }
  Widget cryptoNameSymbol(data) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: '${data.name}',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
          children: <TextSpan>[
            TextSpan(
                text: '\n${widget.roles.where((element) => element.id==data.jobRole).first.name}',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  Widget cryptoAddress(data) {
    return Align(
      alignment: Alignment.topRight,
      child: RichText(
        text: TextSpan(
          text: '${data.address}',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14),
        ),
      ),
    );
  }
  Widget changeIcon(data) {
    return Align(
        alignment: Alignment.topRight,
        child: data.address.contains('-')
            ? Icon(
          Icons.edit_location,
          color: Colors.green,
          size: 30,
        )
            : Icon(
          Icons.edit_location,
          color: Colors.green,
          size: 30,
        ));
  }
}
Widget employeeList(String rolesValue) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      FlatButton(
        child: RichText(
          text: TextSpan(
              text: rolesValue,
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black,),
              children: [
                TextSpan(
                    text: '\nJob Role',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold))
              ]),
        ),
      )
    ],
  );
}
