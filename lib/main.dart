import 'package:construct/constant.dart';
import 'package:construct/pages/landing.dart';
import 'package:construct/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/user.dart';
import 'pages/login/LoginPage.dart';
import 'pages/login/RegisterPage.dart';

void main() => runApp(ConstructApp());

class ConstructApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().currentUser,
      child: MaterialApp(
        title: 'Construct',
        theme: ThemeData(
            primaryColor: kPrimaryColor,
            backgroundColor: kBackgroundColor,
            buttonColor: kButtonColor,
            fontFamily: 'Roboto'),
        initialRoute: '/',
        routes: {
          '/': (context) => LandingPage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
        },
      ),
    );
  }
}
