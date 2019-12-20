import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

const registrationRoute = "";
const chatRoute = "";

class Router {
  Map<String, Widget Function(BuildContext)> getRoutes() {
    var routes = {
      WelcomeScreen.route: (context) => WelcomeScreen(),
      LoginScreen.route: (context) => LoginScreen(),
      RegistrationScreen.route: (context) => RegistrationScreen(),
      ChatScreen.route: (context) => ChatScreen(),
    };
    return routes;
  }
}
