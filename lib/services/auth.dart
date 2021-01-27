import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/core/Models/Employee.dart';
import 'package:restaurant_freelance_job/core/Models/Employer.dart';
import 'package:restaurant_freelance_job/core/Provider/priceList_provider.dart';
import 'package:restaurant_freelance_job/core/Services/Services.dart';
import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/JobRoles.dart';
import 'package:restaurant_freelance_job/pages/Welcome/welcome_screen.dart';
import 'package:restaurant_freelance_job/pages/employee/employeeForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_freelance_job/Constants/constants.dart';
import 'package:restaurant_freelance_job/pages/employee/employee_home.dart';
import 'package:restaurant_freelance_job/pages/employer/employerForm.dart';
import 'package:restaurant_freelance_job/pages/employer/employer_home.dart';

class AuthService  {
  final FirebaseAuth _auth= FirebaseAuth.instance;

  List<JobRoles> priceList= new List<JobRoles>();
  @override
  void initState() {
    PriceListProvider priceListProvider = new PriceListProvider();
    priceListProvider.priceList.first.then((value) =>
    priceList=value
    );
  }

  Future signIn(String email, String password) async {
    try{
      final UserCredential authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User currentUser= authResult.user;
      return currentUser!=null ? currentUser.uid: null;
    }catch(e){
      print("no email matched");
      print(e.toString());
      return null;
    }
  }
   Future signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
   }
  Widget handleAuth() {
    return new StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          //authorizeAccess(context);
        }
        return WelcomeScreen();
      },
    );
  }

  String authorizeAccess(BuildContext context, LoginType loginType) {
    FirebaseFirestore.instance.collection('/users')
        .where('uid',isEqualTo: _auth.currentUser.uid)
        .get()
        .then((docs) async {
      if (docs.docs[0].exists) {
        Services services = new Services();
        if (loginType == LoginType.LoginEmployer) {
          if (docs.docs[0].get('role') == "employer") {
            try {
              await services.getEmployerById(_auth.currentUser.uid).then((
                  value) {
                if (value.isVerified == true) {
                  Employer emp= value;
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (BuildContext context) => new EmployerHome(emp)));
                }
                else {
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new EmployerForm(employer: value)));
                }
              });
            }
            catch(e){
              print(e.toString());
              return null;
            }
          }
        }
        else if (loginType == LoginType.LoginEmployee) {
          if (docs.docs[0].get('role') == "employee") {
            try {
              await services.getEmployeeById(_auth.currentUser.uid).then((
                  value) {
                if (value.isVerified == true) {
                  Employee empl= value;
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (BuildContext context) => new EmployeeHome(empl)));
                }
                else {
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (BuildContext context) =>
                      new EmployeeForm(employee: value, priceList: priceList)));
                }
              });
            }
            catch(e){
              print(e.toString());
              return null;
            }
          }
        }
        else {
          Navigator.push(context, new MaterialPageRoute(
              builder: (BuildContext context) => new WelcomeScreen()));
        }
      }
    });
  }

  String changePassword(String newPassword, BuildContext context) {
     _auth.currentUser.updatePassword(newPassword).then((_){
       _auth.signOut();
       Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=> new WelcomeScreen()));
     }).catchError((onError){
       print("Password cant be changed"+ onError.toString());
     });
  }


/*Future<UserResponse> signIn(String email, String password) async {
    String targethost = '192.168.1.4';

    UserResponse resp = new UserResponse();
    var queryParameters = {
      'username': email,
      'password': password,

    };
    //we are using asp.net Identity for login/registration. the first time we
    //login we must obtain an OAuth token which we obtain by calling the Token endpoint
    //and pass in the email and password that the user registered with.
    try {

        var gettokenuri = new Uri(scheme: 'http',
            //      host: '10.0.2.2',
            port: 44111,
            host: targethost,
            path: '/users/authenticate');

        //the user name and password along with the grant type are passed the body as text.
        //and the contentype must be x-www-form-urlencoded
        var loginInfo = 'username=' + email + '&password=' + password;
        print(gettokenuri);
        final http.Response response = await http.post(gettokenuri,
            headers:<String, String>{
               'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'username' : email,
              'password' : password
            }),
        );
        print(response.statusCode);
        //alice.onHttpResponse(response);
        if (response.statusCode == 200) {
          resp.error = '200';
          final json = jsonDecode(response.body);
          Globals.token = json['token'] as String;
        }
        else {
          //this call will fail if the security stamp for user is null
          resp.error = response.statusCode.toString() + ' ' + response.body;
          return resp;
        }
    }
    catch (e){
      resp.error = e.message;
    }
    return   resp ;
  }*/
  //this call is has anonymous access so no need for access token
  /*Future<UserResponse> register(User user) async {
    String targethost = '192.168.1.4';
    UserResponse resp = new UserResponse();
    String js;
    js = jsonEncode(user);

    //from the emulator 10.0.2.2 is mapped to 127.0.0.1  in windows

    var url1 = 'http://' + targethost + "/api/Account/Register";
    var url =  'http://192.168.1.4:4411/api/Account/Register';
    try {
      // final request = await client.p;
      final response = await http
          .post(url,
          headers: {"Content-Type": "application/json"},
          body: js)
          .then((response) {
        resp.error = '200';
        if ( response.statusCode != 200) {
          resp.error = response.statusCode.toString() + ' ' + response.body;
        }
      });

    }  catch (e) {
      resp.error = e.message;
    }

    return resp;

  }
  Future<String> UserInfo() async {

    var url = new Uri(scheme: 'http',
      host: '192.168.1.4',
      port: 44111,
      path: '/users',
    );
    //all calls to the server are now secure so must pass the oAuth token or our call will be rejected
    String authorization = 'Bearer ' + Globals.token;
    await http.get(url,
      headers:<String, String>{
        HttpHeaders.authorizationHeader: authorization,
      },
    ).then((value){
      if (value.statusCode == 200) {
        final json = jsonDecode(value.body);
        return json[0]['id'].toString();
    }
    else {
    // resp.error = response.reasonPhrase;
    return 'error';
    }
    });
  }*/
}
