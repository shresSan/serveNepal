import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/Constants/constants.dart';
import 'package:restaurant_freelance_job/components/rounded_button.dart';
import '../../login_page.dart';
import 'components/background.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  ModalRoute<dynamic> _route;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Scaffold(
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "WELCOME TO SERVE!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.05),
                /*SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.05),*/
                RoundedButton(
                  text: "LOGIN as Employee",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return new LoginPage(loginType: LoginType.LoginEmployee);
                          //return RootPage(loginType: LoginType.LoginEmployee);
                        },
                      ),
                    );
                  },
                ),
                RoundedButton(
                  text: "LOGIN as Employer",
                  color: kPrimaryLightColor,
                  textColor: Colors.black,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return new LoginPage(loginType: LoginType.LoginEmployer);
                          //return RootPage(loginType: LoginType.LoginEmployer);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        )
    );
  }

  @override
  void dispose(){
    _route?.removeScopedWillPopCallback(() => null);
    _route= null;
    super.dispose();
  }
}