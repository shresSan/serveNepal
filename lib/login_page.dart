import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/services/auth.dart';
import 'package:restaurant_freelance_job/Constants/constants.dart';

class LoginPage extends StatefulWidget {
  /*LoginPage({Key key, this.title, this.loginType, this.auth,this.onSignedIn}) : super(key: key);
  final VoidCallback onSignedIn;
  final String title;
  final LoginType loginType;
  final AuthService auth;*/
  LoginPage({Key key,this.loginType}) : super(key: key);
  LoginType loginType;
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ModalRoute<dynamic> _route;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  String email='';
  String password='';
  String _authHint = '';
  final AuthService _auth= AuthService();

  void initState() {
    super.initState();
  }
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      dynamic resp = await _auth.signIn(
          email, password);
      if (resp == null) {
        setState(() {
          _authHint = 'could not sign in with those credentials!';
        });
      }
      else {
        _auth.authorizeAccess(context, widget.loginType);
      }
    }
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _authHint = '';
    });
  }
  @override
  void dispose(){
   // _route?.removeScopedWillPopCallback(() => null);
    //_route= null;
    formKey.currentState?.dispose();
    super.dispose();
  }

  List<Widget> usernameAndPassword() {
    return [
      padded(child: new TextFormField(
        key: new Key('username'),
        decoration: new InputDecoration(labelText: 'Username'),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Username can\'t be empty.' : null,
        onSaved: (val) => email = val,
      )),
      padded(child: new TextFormField(
        key: new Key('password'),
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
        onSaved: (val) => password = val,
      )),
    ];
  }

  List<Widget> submitWidgets() {
    return [
      new RaisedButton(
          child: new Text(
            "Login",
            style: new TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
          key: new Key('login'),
          onPressed: validateAndSubmit
      )
    ];
   /* switch (widget.loginType) {
      case LoginType.LoginEmployee:
        return [
          new RaisedButton(
              child: new Text(
                "Login",
                style: new TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            key: new Key('login'),
            onPressed: validateAndSubmit
          )
        ];
      case LoginType.LoginEmployer:
        return [
          new RaisedButton(
              child: new Text(
                "Login",
                style: new TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              key: new Key('login'),
              onPressed: validateAndSubmit
          )
        ];
    }
    return null;*/
  }

  Widget hintText() {
    return new Container(
        //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: new Text(
            _authHint,
            key: new Key('hint'),
            style: new TextStyle(fontSize: 18.0, color: Colors.red),
            textAlign: TextAlign.center)
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  //      navigatorKey: widget.auth.alice.getNavigatorKey(),
        debugShowCheckedModeBanner: false,
      home: new Scaffold(

      appBar: new AppBar(
        title: new Text('Login Page'),
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: usernameAndPassword() + submitWidgets(),
                        )
                    )
                ),
              ])
            ),
            hintText()
          ]
        )
      )
      )
    )
    );
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}

