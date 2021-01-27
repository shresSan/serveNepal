import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/components/rounded_button.dart';
import 'package:restaurant_freelance_job/login_page.dart';
import '../../../Constants/constants.dart';
import '../../../services/auth.dart';
import '../../../components/root_page.dart';
import 'background.dart';

class Body extends StatelessWidget {
  final AuthService _auth= AuthService();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
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
                      return RootPage(loginType: LoginType.LoginEmployee);
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
                      return RootPage(loginType: LoginType.LoginEmployer);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
