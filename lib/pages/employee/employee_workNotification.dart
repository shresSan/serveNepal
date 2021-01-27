import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/components/custom_notification_app_bar.dart';
import 'package:restaurant_freelance_job/core/Models/Employee.dart';
import 'package:restaurant_freelance_job/core/Models/Employer.dart';
import 'package:restaurant_freelance_job/core/Models/vacancyNotification.dart';

class EmployeeWorkNotification extends StatefulWidget {
  final Employee employee;
  final List<VacancyNotification> notifications;
  final String jobRole;
  EmployeeWorkNotification(this.employee,this.notifications,this.jobRole);
  @override
  _EmployeeWorkNotificationState createState() => _EmployeeWorkNotificationState();
}

class _EmployeeWorkNotificationState extends State<EmployeeWorkNotification> {
  final Employer employer=null;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: CustomAppBar("Company's Vacancy",false, employer,widget.employee,widget.jobRole),
            body: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        itemCount: widget.notifications.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            height: 220,
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
                                                      cryptoIcon(widget.notifications[index]),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      cryptoNameSymbol(widget.notifications[index]),
                                                      Spacer(),
                                                      cryptoDate(widget.notifications[index]),
                                                      SizedBox(
                                                        width: 10,
                                                      )
                                                    ],
                                                  ),
                                                 Row(
                                                   children:<Widget>[
                                                     cryptoAddress(widget.notifications[index]),
                                                     changeIcon(widget.notifications[index]),
                                                   ]
                                                 ),
                                                 Row(
                                                  children: <Widget>[
                                                    cryptoEmail(widget.notifications[index])
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
      padding: const EdgeInsets.only(left: 5.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.person,
            color: Colors.orange,
            size: 30,
          )),
    );
  }
  Widget cryptoNameSymbol(data) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: '${data.companyName}',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)
        ),
      ),
    );
  }
  Widget cryptoDate(data) {
    return Align(
      alignment: Alignment.topRight,
      child: RichText(
        text: TextSpan(
          text: 'Posted: ${data.updatedDate}',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green, fontSize: 15),
          children: <TextSpan>[
            TextSpan(
                text: '\nDeadline: ${data.deadline}',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
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
  Widget cryptoAddress(data) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: RichText(
        text: TextSpan(
          text: '\n'+ data.address,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18),
        ),
      ),
    );
  }
  Widget cryptoEmail(data) {
    return Padding(
        padding: const EdgeInsets.only(left: 15.0),
    child: Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          text: '\nPlease send your Resume at '+ '\n${data.email}',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.lightBlueAccent, fontSize: 18),
        ),
      ),
    )
    );
  }

}

Widget employerList(String rolesValue) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      FlatButton(
        child: RichText(
          text: TextSpan(
              text: rolesValue,
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 15),
              children: [
                TextSpan(
                    text: '\nJob Role',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15))
              ]),
        ),
      )
    ],
  );
}