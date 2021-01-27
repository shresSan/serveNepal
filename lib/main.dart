import 'package:alice/alice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/pages/price_list.dart';
import 'package:restaurant_freelance_job/pages/Welcome/welcome_screen.dart';
import 'package:restaurant_freelance_job/pages/employee/employeeAvailabilityForm.dart';
import 'package:restaurant_freelance_job/pages/employee/employeeForm.dart';
import 'package:restaurant_freelance_job/pages/employee/employee_home.dart';
import 'package:restaurant_freelance_job/pages/employee/employee_workNotification.dart';
import 'package:restaurant_freelance_job/pages/employer/employerForm.dart';
import 'package:restaurant_freelance_job/pages/employer/employer_home.dart';
import 'package:restaurant_freelance_job/pages/employer/employer_requestedEmpNotification.dart';
import 'package:restaurant_freelance_job/pages/employer/multi_form.dart';
import 'package:restaurant_freelance_job/pages/location.dart';
import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/components/root_page.dart';
import 'package:restaurant_freelance_job/theme/theme.dart';

// ignore: avoid_web_libraries_in_flutter
import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'Constants/constants.dart';
import 'services/auth.dart';

/*void main() =>runApp(MaterialApp(
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (BuildContext context)=> EmployerHome(),
      '/location': (BuildContext context)=> LocationMap(),
      '/employerHome': (BuildContext context)=> EmployerHome(),
      '/employerForm': (BuildContext context)=> EmployerForm(),
      '/hiring': (BuildContext context)=> MultiForm(),
      '/employeeHome': (BuildContext context)=> EmployeeHome(),
      '/employeeForm': (BuildContext context)=> EmployeeForm(),
      '/employeeAvail': (BuildContext context)=> EmployeeAvailabilityForm(),
          '/employeeNotification': (BuildContext context)=>EmployeeWorkNotification(),
      '/employerNotification': (BuildContext context)=>EmployerRequestedEmpNotification(),
          '/PriceList': (BuildContext context)=> PriceList()

    }
));
 */
/*void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Login Page',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new RootPage(auth: new AuthASP()),
    );
  }
}*/

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _auth= AuthService();
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: _auth.handleAuth(),
    );
  }
}