import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/widgets/navigation_button_widget.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static String route = "/welcome_screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                Text(
                  'Flash Chat',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            NavigationButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.route);
              },
              color: Colors.lightBlueAccent,
              displayText: 'Log In',
            ),
            NavigationButton(
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.route);
              },
              color: Colors.blueAccent,
              displayText: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
