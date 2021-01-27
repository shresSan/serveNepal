import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/services/auth.dart';
import 'package:path/path.dart';

import 'employee/employee_home.dart';
class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final AuthService _auth = AuthService();
  String password = '';
  String confirmPassword = '';
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  void initState() {
    super.initState();
  }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        //      navigatorKey: widget.auth.alice.getNavigatorKey(),
          debugShowCheckedModeBanner: false,
          home: new Scaffold(

              appBar: new AppBar(
                title: new Text('Change Password Page'),
              ),
              backgroundColor: Colors.grey[300],
              body: new SingleChildScrollView(child: new Container(
                  padding: const EdgeInsets.all(16.0),
                  child: new Column(
                      children: [
                        new Card(
                            child: new Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Container(
                                      padding: const EdgeInsets.all(16.0),
                                      child: new Form(
                                        key: formKey,
                                        child: new Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .stretch,
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 2.0),
                                                child: new TextFormField(
                                                  key: new Key('password'),
                                                  decoration: new InputDecoration(
                                                      labelText: 'Password'),
                                                  obscureText: true,
                                                  autocorrect: false,
                                                  validator: (val) =>
                                                  val.isEmpty
                                                      ? 'Password can\'t be empty.'
                                                      : null,
                                                  onSaved: (val) =>
                                                  password = val,
                                                )
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 16.0),
                                                child: new TextFormField(
                                                  key: new Key(
                                                      'confirmPassword'),
                                                  decoration: new InputDecoration(
                                                      labelText: 'Confirm Password'),
                                                  obscureText: true,
                                                  autocorrect: false,
                                                  validator: (val) =>
                                                  password != confirmPassword
                                                      ? 'Password and Confirm Password must be same'
                                                      : null,
                                                  onSaved: (val) =>
                                                  confirmPassword = val,
                                                )
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 16.0),
                                                child: new RaisedButton(
                                                    child: new Text(
                                                      "Reset Password",
                                                      style: new TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    color: Colors.blue,
                                                    key: new Key(
                                                        'resetPassword'),
                                                    onPressed: validateAndSubmit
                                                )
                                            )
                                          ],
                                        ),
                                      )
                                  )
                                ])
                        )
                      ])
              )
              )
          )
      );
    }

  void validateAndSubmit() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      int result = 0;
      _auth.changePassword(password, this.context);
    }
  }
  }
