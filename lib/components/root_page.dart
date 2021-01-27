import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/pages/employee/employeeForm.dart';
import 'package:restaurant_freelance_job/pages/employer/employerForm.dart';
import '../Constants/constants.dart';
import '../login_page.dart';


class RootPage extends StatefulWidget {
  RootPage({Key key,this.loginType}) : super(key: key);
  final LoginType loginType;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();

  setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }
   authorizeAccess() async {
       await FirebaseFirestore.instance.collection('/users')
        .where('uid',isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((docs){
          if(docs.docs[0].exists){
            if(docs.docs[0].get('role')=="employer"){
             return true;
        }
        else{
              return false;
        }
      }
      });
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        /*return new LoginPage(
          title: 'Login Page',
          loginType: widget.loginType,
          onSignedIn: () => _updateAuthStatus(AuthStatus.signedIn),
        );*/
      case AuthStatus.signedIn:
        {
          return new StreamBuilder(
            stream: authorizeAccess(),
            builder: (BuildContext context, snapshot){
              if(snapshot.connectionState== ConnectionState.waiting) {
                if (snapshot.hasData) {
                  if (snapshot.data == 'true') {
                    return new EmployerForm();
                  }
                  else {
                    return new EmployeeForm();
                  }
                }
              }
            }
          );
        }
    }
  }
}